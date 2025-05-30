<%@ page
	language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="java.util.*"
	import="net.danisoft.dslib.*"
	import="net.danisoft.wtlib.auth.*"
	import="net.danisoft.wtlib.cifp.*"
	import="net.danisoft.wtlib.cmon.*"
	import="net.danisoft.wtlib.code.*"
	import="net.danisoft.wtlib.ureq.*"
	import="net.danisoft.wazetools.auth.*"
%>
<%!
	private static final String PAGE_Title = "User Accounts Management";
	private static final String PAGE_Keywords = "Users, Accounts, Privileges, Management";
	private static final String PAGE_Description = "Users Accounts and Privileges Management";
%>
<!DOCTYPE html>
<html>
<head>

	<jsp:include page="../_common/head.jsp">
		<jsp:param name="PAGE_Title" value="<%= PAGE_Title %>"/>
		<jsp:param name="PAGE_Keywords" value="<%= PAGE_Keywords %>"/>
		<jsp:param name="PAGE_Description" value="<%= PAGE_Description %>"/>
	</jsp:include>

	<script>

		/**
		 * USR Autocomplete Function
		 */
		$(function() {
	
			$('#SearchKey').autocomplete({

				minLength: 2,

				source: function(request, response) {

					$.ajax({

						cache: false,
						type: 'POST',
						dataType: 'json',
						url: '../servlet/AcUSR',
						data: { SearchKey: request.term },

						beforeSend: function(XMLHttpRequest) {
							$('#AcUsrErr').html('');
							$('#AcUsrErr').hide();
						},

						success: function(data) {
							response($.map(data.result, function(item) {
								return {
									label: item.nn + (item.rk == 0 ? '' : '(' + item.rk + ')') + ' - ' + item.ln + ', ' + item.fn + ' - ' + item.ma,
									nickn: item.nn
								}
							}))
						},

						error: function (jqXHR, textStatus, errorThrown) {
							$('#AcUsrErr').html(jqXHR.status == 406
								? ('Sorry, no matches were found in the countries you manage')
								: ('Error <b>' + jqXHR.status + '</b><br>' + errorThrown + ' - Please notify SysOp')
							).slideDown(200);
							setTimeout(function() {
								$('#AcUsrErr').slideUp(1500);
							}, 1500);
						}
					})
				},

				select: function(event, ui) {
					window.location.href = encodeURI('?Action=edit&reqUser=' + ui.item.nickn);
				}

			});
		});

		/**
		 * Add a new user
		 */

		function AddUsr() {

			$.ajax({

				async: true,
				cache: false,
				type: 'POST',
				dataType: 'text',
				url: '_user_add_dlg.jsp',

				success: function(data) {
					ShowDialog_AJAX(data);
				},
				error: function(jqXHR, textStatus, errorThrown) {
					ShowDialog_AJAX(jqXHR.responseText);
				}
			});
		}

		/**
		 * Delete a user
		 */
		function DelUsr(NickName) {

			ShowDialog_YesNo(
				'Delete This Account',
				'<div class="DS-padding-updn-4px">Clicking the &quot;Yes&quot; button will <span class="DS-text-exception"><b>delete</b></span> the <b>' + NickName + '</b> account from the Waze.Tools Suite.</div>' +
					'<div class="DS-padding-updn-4px">Are you sure you want to continue?</div>',
				'Yes, delete it', encodeURI('?Action=delete&DelUser=' + NickName),
				'No, Keep it', ''
			);
		}

		/**
		 * Set Today Date for a given field
		 */
		function SetTodayDate(txtId) {

			$('#' + txtId).val('<%= FmtTool.fmtDate() %>');
		}

		/**
		 * Delete an entitlement
		 */
		function DeleteEntitlement(NickName, EntCode, EntDesc, GeoCode) {

			ShowDialog_YesNo(
				'Delete This Entitlement',
				'This action will delete the <b>' + EntDesc + '</b> entitlement for the zone <b>' + GeoCode + '</b>.',
				'Yes, delete it', encodeURI('?Action=delent&reqUser=' + NickName + '&reqRole=' + EntCode + '&reqGeoc=' + GeoCode),
				'No, Keep it', ''
			);
		}

		/**
		 * Show AUTH Entitlements
		 */
		function ShowEntitlements(reqUser) {
			
			$.ajax({

				async: true,
				cache: false,
				type: 'GET',
				url: '_auth_ent_view_div.jsp',
				dataType: 'text',
				data: { reqUser: reqUser },

				success: function(data) {
					$('#divEntShow').html(data);
				},
				error: function(jqXHR, textStatus, errorThrown) {
					$('#divEntShow').html(jqXHR.responseText);
				}
			});
		}

		/**
		 * Show AUTH Countries
		 */
		function ShowAuthCountry(reqUser) {
			
			$.ajax({

				async: true,
				cache: false,
				type: 'GET',
				url: '_auth_ctry_view_div.jsp',
				dataType: 'text',
				data: { reqUser: reqUser },

				success: function(data) {
					$('#divAuthCountries').html(data);
				},
				error: function(jqXHR, textStatus, errorThrown) {
					$('#divAuthCountries').html(jqXHR.responseText);
				}
			});
		}

		/**
		 * Add an AUTH Country
		 */
		function AddAuthCountry(reqUser) {

			$.ajax({

				async: true,
				cache: false,
				type: 'GET',
				url: '_auth_ctry_add_dlg.jsp',
				dataType: 'text',
				data: { reqUser: reqUser },

				success: function(data) {
					ShowDialog_AJAX(data);
				},
				error: function(jqXHR, textStatus, errorThrown) {
					ShowDialog_AJAX(jqXHR.responseText);
				}
			});
		}

		/**
		 * Delete an AUTH Country
		 */
		function DeleteAuthCountry(reqUser, reqCtry) {

			$.ajax({

				async: true,
				cache: false,
				type: 'POST',
				url: '../api/auth/country/delete',
				dataType: 'text',

				data: {
					reqUser: reqUser,
					reqCtry: reqCtry
				},

				success: function(data) {
					if (data.startsWith('OK'))
						ShowAuthCountry(reqUser);
					else
						ShowDialog_Error(data);
				},
				error: function(jqXHR, textStatus, errorThrown) {
					ShowDialog_AJAX(jqXHR.responseText);
				}
			});
		}

		/**
		 * Show UREQ Countries
		 */
		function ShowUreqCountry(reqUser) {
			
			$.ajax({

				async: true,
				cache: false,
				type: 'GET',
				url: '_ureq_ctry_view_div.jsp',
				dataType: 'text',
				data: { reqUser: reqUser },

				success: function(data) {
					$('#divUreqCountries').html(data);
				},
				error: function(jqXHR, textStatus, errorThrown) {
					$('#divUreqCountries').html(jqXHR.responseText);
				}
			});
		}

		/**
		 * Add an UREQ Country
		 */
		function AddUreqCountry(reqUser) {

			$.ajax({

				async: true,
				cache: false,
				type: 'GET',
				url: '_ureq_ctry_add_dlg.jsp',
				dataType: 'text',
				data: { reqUser: reqUser },

				success: function(data) {
					ShowDialog_AJAX(data);
				},
				error: function(jqXHR, textStatus, errorThrown) {
					ShowDialog_AJAX(jqXHR.responseText);
				}
			});
		}

		/**
		 * Delete an UREQ Country
		 */
		function DeleteUreqCountry(reqUser, reqCtry) {

			$.ajax({

				async: true,
				cache: false,
				type: 'POST',
				url: '../api/ureq/country/delete',
				dataType: 'text',

				data: {
					reqUser: reqUser,
					reqCtry: reqCtry
				},

				success: function(data) {
					if (data.startsWith('OK'))
						ShowUreqCountry(reqUser);
					else
						ShowDialog_Error(data);
				},
				error: function(jqXHR, textStatus, errorThrown) {
					ShowUreqCountry(reqUser);
					ShowDialog_AJAX(jqXHR.responseText);
				}
			});
		}

		/**
		 * Show CIFP Countries
		 */
		function ShowCifpCountry(reqUser) {
			
			$.ajax({

				async: true,
				cache: false,
				type: 'GET',
				url: '_cifp_ctry_view_div.jsp',
				dataType: 'text',
				data: { reqUser: reqUser },

				success: function(data) {
					$('#divCifpCountries').html(data);
				},
				error: function(jqXHR, textStatus, errorThrown) {
					$('#divCifpCountries').html(jqXHR.responseText);
				}
			});
		}

		/**
		 * Add a CIFP Country
		 */
		function AddCifpCountry(reqUser) {

			$.ajax({

				async: true,
				cache: false,
				type: 'GET',
				url: '_cifp_ctry_add_dlg.jsp',
				dataType: 'text',
				data: { reqUser: reqUser },

				success: function(data) {
					ShowDialog_AJAX(data);
				},
				error: function(jqXHR, textStatus, errorThrown) {
					ShowDialog_AJAX(jqXHR.responseText);
				}
			});
		}

		/**
		 * Delete a CIFP Country
		 */
		function DeleteCifpCountry(reqUser, reqCtry) {

			$.ajax({

				async: true,
				cache: false,
				type: 'POST',
				url: '../api/cifp/country/delete',
				dataType: 'text',

				data: {
					reqUser: reqUser,
					reqCtry: reqCtry
				},

				success: function(data) {
					if (data.startsWith('OK'))
						ShowCifpCountry(reqUser);
					else
						ShowDialog_Error(data);
				},
				error: function(jqXHR, textStatus, errorThrown) {
					ShowCifpCountry(reqUser);
					ShowDialog_AJAX(jqXHR.responseText);
				}
			});
		}

		/**
		 * Mail current CIFP API-KEY
		 */
		function MailCifpApiKey(userName, userMail) {
			
			ShowDialog_YesNo(
				'Send CIFP API-KEY via e-Mail',
				'This action sends the current CIFP API key to <b>' + userName + '</b> <i>(' + userMail + ')</i>.<br><br>Are you sure you want to proceed?',
				'Yes, Send it!', encodeURI('?Action=mailapikey&apiUser=' + userName),
				'No', ''
			);
		}

		/**
		 * Generate a new CIFP API-KEY
		 */
		function RegenCifpApiKey(userName) {
			
			ShowDialog_YesNo(
				'CIFP API-KEY Creation',
				'This action regenerates a new CIFP API-KEY for <b>' + userName + '</b>.<br><br>Please note that, if existing, any API-KEY already present will be <span class="DS-text-exception DS-text-bold">invalidated</span> and <span class="DS-text-green DS-text-bold">replaced</span> with the generated one.<br><br>Are you sure you want to proceed?',
				'Yes, Create a NEW key', encodeURI('?Action=newapikey&reqUser=' + userName),
				'No, Keep this one', ''
			);
		}

		/**
		 * Delete current CIFP API-KEY
		 */
		function DeleteCifpApiKey(userName) {
			
			ShowDialog_YesNo(
				'Delete CIFP API-KEY',
				'This action <span class="DS-text-exception DS-text-bold">deletes</span> the current CIFP API-KEY for <b>' + userName + '</b>.<br><br>Please note that, if existing, <span class="DS-text-exception DS-text-bold">any API-KEY</span> already present <span class="DS-text-exception DS-text-bold">will be invalidated</span>.<br><br>Are you sure you want to proceed?',
				'Yes, delete this key', encodeURI('?Action=delapikey&reqUser=' + userName),
				'No, Keep this one', ''
			);
		}

	</script>

</head>

<body>

	<jsp:include page="../_common/header.jsp" />

	<div class="mdc-layout-grid DS-layout-body">
	<div class="mdc-layout-grid__inner">
	<div class="<%= MdcTool.Layout.Cell(12, 8, 4) %>">
<%
	String RedirectTo = "";

	Database DB = new Database();
	MsgTool MSG = new MsgTool(session);
	User USR = new User(DB.getConnection());
	TomcatRole TCR = new TomcatRole(DB.getConnection());
	Hierarchy AHI = new Hierarchy(DB.getConnection());
	GeoIso GEO = new GeoIso(DB.getConnection());
	LogTool LOG = new LogTool(DB.getConnection());

	String Action = EnvTool.getStr(request, "Action", "");
	String reqUser = EnvTool.getStr(request, "reqUser", "");

	User.Data usrData;

	try {

		// Get enabled countries

		usrData = USR.Read(SysTool.getCurrentUser(request));
		Vector<String> vecEnabledCountries = usrData.getWazerConfig().getAuth().getActiveCountryCodes();

		// Body

		if (Action.equals("")) {

			////////////////////////////////////////////////////////////////////////////////////////////////////
			//
			// Search User
			//
%>
			<form>

				<div class="DS-padding-updn-8px">
					<div class="DS-text-title-shadow"><%= PAGE_Title %></div>
				</div>

				<div class="DS-padding-updn-8px">
					<div class="DS-text-large">You have the rights to manage user accounts in the following countries:</div>
				</div>

				<div class="DS-padding-updn-8px">
					<table class="TableSpacing_0px">
						<% for (String enabledCountry : vecEnabledCountries) { %>
						<tr>
							<td class="DS-padding-lf32px"><%= GEO.getFlag24x18byIso3(enabledCountry) %></td>
							<td class="DS-text-fixed-reduced DS-padding-lf-8px">[<b><%= enabledCountry %></b>]</td>
							<td class="DS-padding-lf-4px DS-text-italic"><%= GEO.getFullDesc(enabledCountry) %></td>
						</tr>
						<% } %>
					</table>
				</div>

				<div class="DS-padding-updn16px">
					<%= MdcTool.Text.Box(
						"SearchKey",
						"",
						MdcTool.Text.Type.TEXT,
						MdcTool.Text.Width.FULL,
						"Enter at least 2 characters to search for Nickname, First Name, Last Name or e-Mail Address",
						""
					) %>
					<div id="AcUsrErr" class="DS-text-exception DS-text-italic DS-padding-updn-8px" style="display:none">AC Errors Here</div>
				</div>

				<div class="DS-padding-bottom-8px">
					<div class="DS-text-compact DS-text-italic">NOTE: Only the first <%= User.getAutocompleteMaxResults() %> results will be shown</div>
				</div>

				<div class="DS-padding-updn-8px">
					<table style="width: 100%" class="TableSpacing_0px">
						<tr>
							<td class="DS-padding-0px" align="left">
								<%= MdcTool.Button.BackTextIcon("Back", "../admin/") %>
							</td>
							<td class="DS-padding-0px" align="right">
								<%= MdcTool.Button.TextIconClass(
									"add_circle",
									"&nbsp;Add New",
									null,
									"DS-text-lime",
									null,
									"onClick=\"AddUsr();\"",
									"Add a NEW user"
								) %>
							</td>
						</tr>
					</table>
				</div>

			</form>

			<script>
				$('#SearchKey').focus();
			</script>
<%
		} else if (Action.equals("edit")) {

			////////////////////////////////////////////////////////////////////////////////////////////////////
			//
			// Edit user
			//

			try {

				usrData = USR.Read(reqUser);

				if (usrData.getName().equals(""))
					throw new Exception("Error reading user data");

				// Check edit permission

				String PermittedCountriesList = "";
				boolean HavePermissionToEdit = false;

				for (String enabledCountry : vecEnabledCountries)
					PermittedCountriesList += ((PermittedCountriesList.equals("") ? "" : ", ") + GEO.getFullDesc(enabledCountry));

				for (String enabledCountry : vecEnabledCountries)
					if (usrData.getCountry().equals(enabledCountry))
						HavePermissionToEdit = true;

				if (!HavePermissionToEdit)
					throw new Exception("You are attempting to modify a user in <b>" + GEO.getFullDesc(usrData.getCountry()) + "</b>, but you have modification privileges only in these countries: <b>" + PermittedCountriesList + "</b>.");
%>
				<form>

					<input type="hidden" name="Action" value="update">
					<input type="hidden" name="reqUser" value="<%= usrData.getName() %>">
<%
					//
					// TITLE
					//
%>
					<div class="DS-padding-updn-8px">
						<div class="mdc-layout-grid__inner">
							<div class="<%= MdcTool.Layout.Cell(6, 4, 4) %>">
								<div class="DS-text-title-shadow">Editing Account:
									<span class="DS-text-fixed DS-text-blue"><%= usrData.getName() %></span>
									<span class="DS-text-gray">(<%= usrData.getRank() %>)</span>
								</div>
							</div>
							<div class="<%= MdcTool.Layout.Cell(6, 4, 4) %>" align="right">
								<%= MdcTool.Select.Box(
									"USR_Country",
									MdcTool.Select.Width.NORM,
									"User Home Country",
									GEO.getCountryCombo(usrData.getCountry()),
									"" // AddData
								) %>
							</div>
						</div>
					</div>
<%
					//
					// TAB PANELS
					//
%>
					<div class="DS-card-head">
						<div class="mdc-tab-bar DS-back-lightgray DS-border-full" role="tablist">
							<div class="mdc-tab-scroller">
								<div class="mdc-tab-scroller__scroll-area">
									<div class="mdc-tab-scroller__scroll-content">
										<%= MdcTool.Tab.ElementIconText(0, "task_alt", "User Data", "DS-text-blue DS-text-bold", true) %>
										<%= MdcTool.Tab.ElementIconText(1, "task_alt", "Hierarchy", "DS-text-blue DS-text-bold", false) %>
										<%= MdcTool.Tab.ElementIconText(2, "task_alt", "AUTH", "DS-text-blue DS-text-bold", false) %>
										<%= MdcTool.Tab.ElementIconText(3, "blur_on", "AMGR", "DS-text-disabled", false) %>
										<%= MdcTool.Tab.ElementIconText(4, "task_alt", "CMON", "DS-text-blue DS-text-bold", false) %>
										<%= MdcTool.Tab.ElementIconText(5, "task_alt", "CODE", "DS-text-blue DS-text-bold", false) %>
										<%= MdcTool.Tab.ElementIconText(6, "blur_on", "MNTR", "DS-text-disabled", false) %>
										<%= MdcTool.Tab.ElementIconText(7, "task_alt", "UREQ", "DS-text-blue DS-text-bold", false) %>
										<%= MdcTool.Tab.ElementIconText(8, "task_alt", "CIFP", "DS-text-blue DS-text-bold", false) %>
									</div>
								</div>
							</div>
						</div>
					</div>
<%
					//
					// USER DATA PANEL
					//
%>
					<div class="DS-tab-panel DS-tab-panel-active">

						<div class="DS-padding-updn-8px">
							<div class="DS-text-extra-large">Name, Rank &amp; Contacts</div>
						</div>

						<div class="DS-padding-updn-8px">
							<div class="mdc-layout-grid__inner">
								<div class="<%= MdcTool.Layout.Cell(3, 4, 4) %>">
									<%= MdcTool.Text.Box("USR_FirstName", usrData.getFirstName(), MdcTool.Text.Type.TEXT, MdcTool.Text.Width.FULL, "First Name", "") %>
								</div>
								<div class="<%= MdcTool.Layout.Cell(3, 4, 4) %>">
									<%= MdcTool.Text.Box("USR_LastName", usrData.getLastName(), MdcTool.Text.Type.TEXT, MdcTool.Text.Width.FULL, "Last Name", "") %>
								</div>
								<div class="<%= MdcTool.Layout.Cell(3, 4, 4) %>">
									<%= MdcTool.Select.Box("USR_Rank", MdcTool.Select.Width.FULL, "User Rank (cones)", Cones.getCombo(usrData.getRank()), "") %>
								</div>
								<div class="<%= MdcTool.Layout.Cell(3, 4, 4) %>">
									<%= MdcTool.Text.Box("USR_Pass", usrData.getPass(), MdcTool.Text.Type.PASS, MdcTool.Text.Width.FULL, "Waze.Tools Password", "") %>
								</div>
							</div>
						</div>

						<div class="DS-padding-updn-8px">
							<div class="mdc-layout-grid__inner">
								<div class="<%= MdcTool.Layout.Cell(5, 4, 4) %>">
									<%= MdcTool.Text.Box("USR_Mail", usrData.getMail(), MdcTool.Text.Type.TEXT, MdcTool.Text.Width.FULL, "e-Mail Address", "") %>
								</div>
								<div class="<%= MdcTool.Layout.Cell(2, 4, 4) %>">
									<%= MdcTool.Text.Box("USR_Phone", usrData.getPhone(), MdcTool.Text.Type.TEXT, MdcTool.Text.Width.FULL, "Cell/Phone Number", "") %>
								</div>
								<div class="<%= MdcTool.Layout.Cell(2, 4, 4) %>">
									<%= MdcTool.Text.Box("USR_SlackID", usrData.getSlackID(), MdcTool.Text.Type.TEXT, MdcTool.Text.Width.FULL, "Slack ID", "") %>
								</div>
								<div class="<%= MdcTool.Layout.Cell(3, 4, 4) %> DS-grid-middle-left">
									<div class="mdc-layout-grid__inner DS-grid-gap-4px">
										<% if (!usrData.getMail().contains("@") || !usrData.getMail().contains(".")) { %>
										<div class="<%= MdcTool.Layout.Cell(2, 2, 1) %> DS-grid-middle-center">
											<span class="material-icons DS-text-exception">error</span>
										</div>
										<div class="<%= MdcTool.Layout.Cell(10, 6, 3) %> DS-grid-middle-left">
											<div class="DS-text-compact DS-text-exception DS-text-italic">Bad e-Mail Address</div>
										</div>
										<% } %>
										<% if (usrData.getSlackID().trim().equals("")) { %>
										<div class="<%= MdcTool.Layout.Cell(2, 2, 1) %> DS-grid-middle-center">
											<span class="material-icons DS-text-exception">error</span>
										</div>
										<div class="<%= MdcTool.Layout.Cell(10, 6, 3) %> DS-grid-middle-left">
											<div class="DS-text-compact DS-text-exception DS-text-italic">No SlackID</div>
										</div>
										<% } %>
									</div>
								</div>
							</div>
						</div>

						<div class="DS-padding-updn-8px">
							<%= MdcTool.Text.Area("USR_Notes", null, "Notes &amp; Comments on " + usrData.getName(), 5, 0, usrData.getNotes(), true, null) %>
						</div>

					</div>
<%
					//
					// HIERARCHY PANEL
					//
%>
					<div class="DS-tab-panel">

						<div class="DS-padding-updn-8px">
							<div class="DS-text-extra-large">Waze Hierarchy Entitlements</div>
						</div>

						<div class="DS-padding-updn-8px">
							<div id="divEntShow"></div>
						</div>

						<script>
							ShowEntitlements('<%= usrData.getName() %>');
						</script>

					</div>
<%
					//
					// AUTH PANEL
					//
%>
					<div class="DS-tab-panel">

						<div class="DS-padding-updn-8px">
							<div class="DS-text-extra-large">User Permissions in AUTH</div>
						</div>

						<div class="DS-padding-updn-8px">
<%
							for (AuthRole X : AuthRole.values()) {
								if (!X.equals(AuthRole.UNKWN)) {
									out.println(
										MdcTool.Check.Box(
											"chk-" + X.getCode(),
											X.getDesc() + (X.equals(AuthRole.ADMIN) ? " <span class='DS-text-italic DS-text-purple'>(WARNING: with this privilege " + usrData.getName() + " can <b>manage all users</b> in his active countries)</span>" : ""),
											"ON",
											TCR.haveRoleAUTH(reqUser, X) ? MdcTool.Check.Status.CHECKED : MdcTool.Check.Status.UNCHECKED, "") +
										"<br>"
									);
								}
							}
%>
						</div>

						<div class="DS-padding-top-8px">
							<div class="DS-text-big">AUTH Countries with management rights</div>
						</div>

						<div class="DS-padding-updn-8px">
							<div id="divAuthCountries"></div>
						</div>

						<script>
							ShowAuthCountry('<%= usrData.getName() %>');
						</script>

					</div>
<%
					//
					// AMGR PANEL
					//
%>
					<div class="DS-tab-panel">

						<div class="DS-padding-updn-8px">
							<div class="DS-text-extra-large">AMGR Section</div>
						</div>

						<div class="DS-padding-updn-8px">
							<div class="DS-text-huge DS-text-exception" align="center">AM Area Manager Tool is DEPRECATED</div>
						</div>

					</div>
<%
					//
					// CMON PANEL
					//
%>
					<div class="DS-tab-panel">

						<div class="DS-padding-updn-8px">
							<div class="DS-text-extra-large">CMON Privileges</div>
						</div>

						<div class="DS-padding-updn-8px">
<%
							for (CmonRole X : CmonRole.values()) {
								out.println(
									MdcTool.Check.Box(
										"CMON_opt_" + X.toString(),
										X.getDescr(),
										Integer.toString(X.getValue()),
										usrData.getWazerConfig().getCmon().isEnabled(X) ? MdcTool.Check.Status.CHECKED : MdcTool.Check.Status.UNCHECKED,
										""
									) +
									"<br>"
								);
							}
%>
						</div>
					</div>
<%
					//
					// CODE PANEL
					//
%>
					<div class="DS-tab-panel">

						<div class="DS-padding-updn-8px">
							<div class="DS-text-extra-large">CODE Privileges</div>
						</div>

						<div class="DS-padding-updn-8px">
<%
							for (CodeRole X : CodeRole.values()) {
								out.println(
									MdcTool.Check.Box(
										"CODE_opt_" + X.toString(),
										X.getDescr(),
										Integer.toString(X.getValue()),
										(usrData.getWazerConfig().getCode().getRole() & X.getValue()) == X.getValue() ? MdcTool.Check.Status.CHECKED : MdcTool.Check.Status.UNCHECKED,
										""
									) +
									"<br>"
								);
							}
%>
						</div>
					</div>
<%
					//
					// MNTR PANEL
					//
%>
					<div class="DS-tab-panel">

						<div class="DS-padding-updn-8px">
							<div class="DS-text-extra-large">MNTR Section</div>
						</div>

						<div class="DS-padding-updn-8px">
							<div class="DS-text-huge DS-text-exception" align="center">Mentoring Manager Tool is DEPRECATED</div>
						</div>

					</div>
<%
					//
					// UREQ PANEL
					//
%>
					<div class="DS-tab-panel">

						<div class="DS-padding-updn-8px">
							<div class="DS-text-extra-large">UREQ Enablement</div>
						</div>

						<div class="DS-padding-updn-8px">
							<% for (UreqRole X : UreqRole.values()) { %>
								<%= MdcTool.Radio.Box(
									"opt_UREQ_Role",
									"opt_" + X.getCode(),
									X.getDesc(),
									X.getCode(),
									TCR.haveRoleUREQ(reqUser, X) ? MdcTool.Radio.Status.CHECKED : MdcTool.Radio.Status.UNCHECKED
								) %>
								<br>
							<% } %>
						</div>

						<div class="DS-padding-updn-8px">
							<div class="DS-text-big">UREQ Countries with unlock rights</div>
						</div>

						<div class="DS-padding-updn-8px">
							<div id="divUreqCountries"></div>
						</div>

						<script>
							ShowUreqCountry('<%= usrData.getName() %>');
						</script>

					</div>
<%
					//
					// CIFP PANEL
					//

					String CifpApiKey = SysTool.getEmptyUuidValue();
					boolean CifpIsAdmin = false;
					boolean CifpExpiringMail = false;
					boolean CifpExpiredMail = false;
					boolean CifpExpiringSlack = false;
					boolean CifpExpiredSlack = false;

					try { CifpApiKey		= usrData.getWazerConfig().getCifp().getApiKey();		} catch (Exception e) { }
					try { CifpIsAdmin		= usrData.getWazerConfig().getCifp().isAdmin();			} catch (Exception e) { }
					try { CifpExpiringMail	= usrData.getWazerConfig().getCifp().isExpireMail();	} catch (Exception e) { }
					try { CifpExpiredMail	= usrData.getWazerConfig().getCifp().isExpiredMail();	} catch (Exception e) { }
					try { CifpExpiringSlack	= usrData.getWazerConfig().getCifp().isExpireSlack();	} catch (Exception e) { }
					try { CifpExpiredSlack	= usrData.getWazerConfig().getCifp().isExpiredSlack();	} catch (Exception e) { }
%>
					<div class="DS-tab-panel">
						<div class="mdc-layout-grid__inner">

							<div class="<%= MdcTool.Layout.Cell(6, 4, 4) %>">
<%
								//
								// Global Switches
								//
%>
								<div class="DS-padding-updn-8px">
									<div class="DS-text-extra-large">CIFP Global Enablement</div>
								</div>

								<div class="DS-padding-updn-8px">
<%
									for (CifpRole X : CifpRole.values()) {
										out.println(
											MdcTool.Check.Box(
												"CIFP_opt_" + X.toString(),
												X.getDesc(),
												X.getCode(),
												TCR.haveRoleCIFP(reqUser, X) ? MdcTool.Check.Status.CHECKED : MdcTool.Check.Status.UNCHECKED,
												""
											) +
											"<br>"
										);
									}
%>
									<div class="DS-padding-0px">
										<%= MdcTool.Check.Box(
											"CIFP_opt_ADM",
											"Authorized to handle <b>all closures</b> in enabled countries (<span class=\"DS-text-FireBrick DS-text-bold\">ADMIN rights</span>)",
											"Y",
											CifpIsAdmin ? MdcTool.Check.Status.CHECKED : MdcTool.Check.Status.UNCHECKED,
											""
										) %>
									</div>

									<div class="DS-padding-updn-8px">
										<div class="DS-text-big">CIFP Countries with management rights</div>
									</div>

									<div class="DS-padding-updn-8px">
										<div id="divCifpCountries"></div>
									</div>

								</div>

							</div>

							<div class="<%= MdcTool.Layout.Cell(6, 4, 4) %>">
<%
								//
								// API Key
								//
%>
								<div class="DS-padding-updn-8px">
									<div class="DS-text-extra-large">CIFP API-KEY</div>
								</div>

								<div class="DS-padding-updn-8px">
									<div class="DS-text-large DS-text-bold DS-text-italic DS-text-DarkOrchid DS-padding-bottom-8px">Please note that...</div>
									<div class="DS-text-italic">Changing this API-KEY means that any CIFP key installed in the
										<%= usrData.getName() %>'s browser <b>will be invalidated</b>. The user will have to enter
										the new one when prompted by the script.</div>
								</div>

								<div class="DS-padding-updn-8px">
									<%= MdcTool.Text.Box(
										"CIFP_ApiKey",
										CifpApiKey,
										"DS-input-textbox-fixed-large",
										MdcTool.Text.Type.TEXT,
										MdcTool.Text.Width.FULL,
										"Current API-KEY",
										"" // AddData
									) %>
								</div>

								<div class="DS-padding-updn-8px">
									<table class="TableSpacing_0px DS-full-width">
										<tr class="">
											<td class="DS-padding-0px" width="33%" align="left">
												<%= MdcTool.Button.TextIconOutlinedClass(
													"mail",
													"&nbsp;Send Key via Mail",
													null,
													"DS-text-green",
													"DS-text-green",
													"onClick=\"MailCifpApiKey('" + reqUser + "', '" + usrData.getMail() + "');\"",
													"Mail current API-KEY to " + reqUser
												) %>
											</td>
											<td class="DS-padding-0px" width="34%" align="center">
												<%= MdcTool.Button.TextIconOutlinedClass(
													"replay_circle_filled",
													"&nbsp;Generate a new key",
													null,
													"DS-text-purple",
													"DS-text-purple",
													"onClick=\"RegenCifpApiKey('" + reqUser + "');\"",
													"Generate a new API-KEY"
												) %>
											</td>
											<td class="DS-padding-0px" width="33%" align="right">
												<%= MdcTool.Button.TextIconOutlinedClass(
													"remove_circle",
													"&nbsp;Invalidate this key",
													null,
													"DS-text-darkred",
													"DS-text-darkred",
													"onClick=\"DeleteCifpApiKey('" + reqUser + "');\"",
													"Delete current API-KEY"
												) %>
											</td>
										</tr>
									</table>
									
								</div>

							</div>
						</div>

						<div class="mdc-layout-grid__inner">

							<div class="<%= MdcTool.Layout.Cell(12, 8, 4) %>">
								<div class="DS-padding-top-24px DS-border-up" align="center">
									<span class="DS-text-huge DS-padding-lfrg-8px DS-padding-updn-4px DS-back-lightgray DS-border-full DS-border-round">
										CIFP Alerts triggered by closure state
									</span>
								</div>
							</div>

							<div class="<%= MdcTool.Layout.Cell(6, 4, 4) %>">
<%
								//
								// Mail Alerts
								//
%>
								<div class="DS-padding-updn-8px">
									<div class="DS-text-big">Alerts sent via e-Mail</div>
								</div>

								<div class="DS-padding-0px">
									<%= MdcTool.Check.Box(
										"CIFP_opt_EXPM",
										"This user wants to receive an email <b>before</b> a closure expires",
										"Y",
										CifpExpiringMail ? MdcTool.Check.Status.CHECKED : MdcTool.Check.Status.UNCHECKED,
										""
									) %>
								</div>

								<div class="DS-padding-0px">
									<%= MdcTool.Check.Box(
										"CIFP_opt_EXPMD",
										"This user wants to receive an email <b>when</b> a closure expires",
										"Y",
										CifpExpiredMail ? MdcTool.Check.Status.CHECKED : MdcTool.Check.Status.UNCHECKED,
										""
									) %>
								</div>

							</div>

							<div class="<%= MdcTool.Layout.Cell(6, 4, 4) %>">
<%
								//
								// Slack Alerts
								//
%>
								<div class="DS-padding-updn-8px">
									<div class="DS-text-big">Alerts sent vis Slack DMs <span class="DS-text-small DS-text-gray DS-text-italic">(Under development)</span></div>
								</div>

								<div class="DS-padding-0px">
									<%= MdcTool.Check.Box(
										"CIFP_opt_EXPS",
										"<span class=\"DS-text-disabled\">This user wants to receive a Slack DM <b>before</b> a closure expires</span> <span class=\"DS-text-FireBrick\">[not yet active]</span>",
										"Y",
										CifpExpiringSlack ? MdcTool.Check.Status.CHECKED : MdcTool.Check.Status.UNCHECKED,
										"disabled"
									) %>
								</div>

								<div class="DS-padding-0px">
									<%= MdcTool.Check.Box(
										"CIFP_opt_EXPSD",
										"<span class=\"DS-text-disabled\">This user wants to receive a Slack DM <b>when</b> a closure expires</span> <span class=\"DS-text-FireBrick\">[not yet active]</span>",
										"Y",
										CifpExpiredSlack ? MdcTool.Check.Status.CHECKED : MdcTool.Check.Status.UNCHECKED,
										"disabled"
									) %>
								</div>

							</div>

						</div>

						<script>
							ShowCifpCountry('<%= usrData.getName() %>');
						</script>

					</div>
<%
					//
					// FOOTER BUTTONS
					//
%>
					<div class="DS-padding-updn16px">
						<table style="width: 100%" class="TableSpacing_0px">
							<tr>
								<td class="DS-padding-0px" align="left">
									<%= MdcTool.Button.BackTextIcon("Cancel", "?") %>
								</td>
								<td class="DS-padding-0px" align="center">
									<%= MdcTool.Button.TextIconOutlinedClass(
										"delete",
										"&nbsp;Delete <b>" + reqUser + "</b>'s Account",
										null,
										"DS-text-exception",
										"DS-text-exception",
										"onClick=\"DelUsr('" + reqUser + "');\"",
										""
									) %>
								</td>
								<td class="DS-padding-0px" align="right">
									<%= MdcTool.Button.SubmitTextIconClass(
										"save",
										"&nbsp;Save All",
										null,
										"DS-text-lime",
										null,
										""
									) %>
								</td>
							</tr>
						</table>
					</div>

				</form>
<%
				//
				// Check if some fields need to be changed
				//

				if (usrData.getFirstName().equals(User.getChangeFieldReminder()) ||
					usrData.getLastName().equals(User.getChangeFieldReminder()) ||
					usrData.getPass().equals(User.getChangeFieldReminder()) ||
					usrData.getMail().equals(User.getChangeFieldReminder())
				) {
%>
					<script>

						var defaultFieldText = '<%= User.getChangeFieldReminder() %>';

						ShowDialog_OK(
							'Incomplete field(s) found',
							'<p>The content of incomplete field(s) has been set to "<b><tt>' + defaultFieldText + '</tt></b>" by default.</p>' +
								'<p>Remember to fix them before you finish editing.</p>',
							'Well, now I\'ll fix it'
						);

					</script>
<%
				}

			} catch (Exception e) {

				MSG.setAlertText("An error has occurred", e.toString());
				e.printStackTrace();

				RedirectTo = "?";
			}

		} else if (Action.equals("update")) {

			////////////////////////////////////////////////////////////////////////////////////////////////////
			//
			// UPDATE
			//

			try {

				String Key, Value;
				Enumeration<String> reqEnum = null;

				usrData = USR.Read(reqUser);

				if (usrData.getName().equals(reqUser)) {

					//
					// USER DATA
					//

					usrData.setCountry(EnvTool.getStr(request, "USR_Country", ""));
					usrData.setFirstName(EnvTool.getStr(request, "USR_FirstName", ""));
					usrData.setLastName(EnvTool.getStr(request, "USR_LastName", ""));
					usrData.setRank(EnvTool.getInt(request, "USR_Rank", 0));
					usrData.setPass(EnvTool.getStr(request, "USR_Pass", ""));
					usrData.setMail(EnvTool.getStr(request, "USR_Mail", ""));
					usrData.setPhone(EnvTool.getStr(request, "USR_Phone", ""));
					usrData.setSlackID(EnvTool.getStr(request, "USR_SlackID", ""));
					usrData.setNotes(EnvTool.getStr(request, "USR_Notes", ""));

					//
					// HIERARCHY
					//

					// No data to update

					//
					// CMON/CODE UserRole
					//

					int CMON_RoleValue = 0;
					int CODE_RoleValue = 0;

					reqEnum = request.getParameterNames();

					while (reqEnum.hasMoreElements()) {

						Key = reqEnum.nextElement().toString();

						if (Key.startsWith("CMON_opt_"))
							CMON_RoleValue += Integer.parseInt(request.getParameter(Key));

						if (Key.startsWith("CODE_opt_"))
							CODE_RoleValue += Integer.parseInt(request.getParameter(Key));
					}

					usrData.getWazerConfig().getCmon().setRole(CMON_RoleValue);
					usrData.getWazerConfig().getCode().setRole(CODE_RoleValue);

					//
					// CIFP - NO COUNTRY - Country always already updated
					//

					// Admin flag

					usrData.getWazerConfig().getCifp().setIsAdmin(false);

					reqEnum = request.getParameterNames();

					while (reqEnum.hasMoreElements()) {

						Key = reqEnum.nextElement().toString();

						if (Key.equals("CIFP_opt_ADM"))
							usrData.getWazerConfig().getCifp().setIsAdmin(request.getParameter(Key).equals("Y"));
					}

					// WazerConfig

					usrData.getWazerConfig().getCifp().setApiKey(EnvTool.getStr(request, "CIFP_ApiKey", ""));
					usrData.getWazerConfig().getCifp().setIsExpireMail(EnvTool.getStr(request, "CIFP_opt_EXPM", "").equals("Y"));
					usrData.getWazerConfig().getCifp().setIsExpiredMail(EnvTool.getStr(request, "CIFP_opt_EXPMD", "").equals("Y"));
					usrData.getWazerConfig().getCifp().setIsExpireSlack(EnvTool.getStr(request, "CIFP_opt_EXPS", "").equals("Y"));
					usrData.getWazerConfig().getCifp().setIsExpiredSlack(EnvTool.getStr(request, "CIFP_opt_EXPSD", "").equals("Y"));

					//
					// Update fields
					//

					USR.Update(reqUser, usrData);

					//////////////////////////////////////////////////
					//
					//  Update ROLES
					//
					//////////////////////////////////////////////////

					TCR.clearRoles(reqUser);

					//
					// AUTH Roles
					//

					for (AuthRole X : AuthRole.values())
						if (EnvTool.getStr(request, "chk-" + X.getCode(), "").equalsIgnoreCase("ON"))
							TCR.Insert(reqUser, X.getCode());

					//
					// CODE Roles
					//

					TCR.Insert(reqUser, CodeRole.DEFAULT_ROLE); // Force insertion of the CODE AuthRole

					//
					// CMON Roles
					//

					TCR.Insert(reqUser, CmonRole.DEFAULT_ROLE); // Force insertion of the CMON AuthRole

					//
					// UREQ Roles
					//

					reqEnum = request.getParameterNames();

					while (reqEnum.hasMoreElements()) {

						Key = reqEnum.nextElement().toString();
						Value = request.getParameter(Key);

						if (Key.equals("opt_UREQ_Role"))
							if (!Value.equals(""))
								TCR.Insert(reqUser, Value);
					}

					//
					// CIFP Roles
					//

					reqEnum = request.getParameterNames();

					while (reqEnum.hasMoreElements()) {

						Key = reqEnum.nextElement().toString();
						Value = request.getParameter(Key);

						if (Key.equals("CIFP_opt_MGR"))
							TCR.Insert(reqUser, CifpRole.MGR.getCode());
					}

					//
					// Toast for the user
					//

					MSG.setSnackText("User " + reqUser + " updated");

					RedirectTo = "?";

				} else
					throw new Exception("Unable to read UserName '" + reqUser + "'");

			} catch (Exception e) {

				MSG.setAlertText("Internal Error", e.toString());
				RedirectTo = "?";
			}

		} else if (Action.equals("create")) {

			////////////////////////////////////////////////////////////////////////////////////////////////////
			//
			// Create a new user
			//

			String NewUser = EnvTool.getStr(request, "NewUser", "");
			String NewUserCountry = EnvTool.getStr(request, "NewUserCountry", "");

			if (NewUser.length() < 3) {

				MSG.setSlideText("Bad UserName", "Username is needed to create a new account");
				RedirectTo = "?";

			} else {
			
				try {
					USR.Create(NewUser, NewUserCountry, SysTool.getCurrentUser(request));
				} catch (Exception e) {
					// Already exists, proceed to edit	
				}

				RedirectTo = "?Action=edit&reqUser=" + NewUser;
			}

		} else if (Action.equals("delete")) {

			////////////////////////////////////////////////////////////////////////////////////////////////////
			//
			// Delete an existing user
			//

			String DelUser = EnvTool.getStr(request, "DelUser", "");

			try {

				TCR.clearRoles(DelUser);
				AHI.clearRoles(DelUser);
				USR.Delete(DelUser);

				MSG.setSnackText("Account " + DelUser + " deleted");
				RedirectTo = "?";

			} catch (Exception e) {

				MSG.setAlertText("Internal Error", e.toString());
				RedirectTo = "?Action=edit&reqUser=" + DelUser;
			}

		} else if (Action.equals("newent_step1")) {

			////////////////////////////////////////////////////////////////////////////////////////////////////
			//
			// Add a new entitlement (Step 1)
			//

			usrData = USR.Read(reqUser);
%>
			<div class="DS-padding-updn-8px">
				<div class="DS-text-title-shadow">New Entitlement for
					<b><%= usrData.getName() %></b><span class="DS-text-gray">(<%= usrData.getRank() %>)</span>
					<span class="DS-text-italic">(<%= usrData.getLastName() %>, <%= usrData.getFirstName() %>)</span>
				</div>
			</div>

			<form id="frmEntStep1">

				<input type="hidden" name="Action" value="newent_step2">
				<input type="hidden" name="reqUser" value="<%= reqUser %>">

				<div class="DS-padding-updn-8px">
					<%= MdcTool.Select.Box(
						"reqRole",
						MdcTool.Select.Width.NORM,
						"Select Hierarchy Role",
						HierRole.getCombo(HierRole.UNKNW.getCode()),
						"onChange=\"submit();\""
					) %>
				</div>

				<div class="DS-padding-updn-8px">
					<%= MdcTool.Button.TextIcon(
						"arrow_back_ios",
						"Cancel",
						null,
						"onClick=\"window.location.href=encodeURI('?Action=edit&reqUser=" + reqUser + "')\"",
						null
					) %>
				</div>

			</form>
<%
		} else if (Action.equals("newent_step2")) {

			////////////////////////////////////////////////////////////////////////////////////////////////////
			//
			// Add a new entitlement (Step 2)
			//

			HierRole reqRole = HierRole.getEnum(EnvTool.getStr(request, "reqRole", HierRole.UNKNW.getCode()));

			usrData = USR.Read(reqUser);
%>
			<div class="DS-padding-updn-8px">
				<div class="DS-text-title-shadow">New Entitlement for
					<b><%= usrData.getName() %></b><span class="DS-text-gray">(<%= usrData.getRank() %>)</span>
					<span class="DS-text-italic">(<%= usrData.getLastName() %>, <%= usrData.getFirstName() %>)</span>
				</div>
			</div>

			<div class="DS-padding-updn-8px">
				<table class="TableSpacing_0px">
					<tr class="DS-border-full">
						<td class="DS-padding-8px DS-back-gray DS-border-rg">Selected Hierarchy Role</td>
						<td class="DS-padding-8px DS-text-bold"><%= reqRole.getDesc() %></td>
						<td class="DS-padding-8px DS-text-bold DS-text-green">&#9989;</td>
					</tr>
				</table>
			</div>

			<form id="frmEntStep2">

				<input type="hidden" name="Action" value="newent_step3">
				<input type="hidden" name="reqUser" value="<%= reqUser %>">
				<input type="hidden" name="reqRole" value="<%= reqRole.getCode() %>">
<%
				if (reqRole.getGeoLevelDeep() > 0) {
%>
					<div class="DS-padding-updn-8px">
						<%= MdcTool.Select.Box(
							"reqCountry",
							MdcTool.Select.Width.NORM,
							"The " + reqRole.getDesc() + " entitlement require a COUNTRY",
							GEO.getCountryCombo("ITA"),
							"onChange=\"submit();\""
						) %>
					</div>
<%
				} else {
%>
					<script>
						$('#frmEntStep2').submit();
					</script>
<%
				}
%>
				<div class="DS-padding-updn-8px">
					<table style="width: 100%" class="TableSpacing_0px">
						<tr>
							<td class="DS-padding-0px" align="left">
								<%= MdcTool.Button.TextIcon(
									"arrow_back_ios",
									"Cancel",
									null,
									"onClick=\"window.location.href=encodeURI('?Action=edit&reqUser=" + reqUser + "')\"",
									null
								) %>
							</td>
							<td class="DS-padding-0px" align="right">
								<%= MdcTool.Button.SubmitTextIcon(
									null,
									"Next&nbsp;",
									"arrow_forward_ios",
									null
								) %>
							</td>
						</tr>
					</table>
				</div>

			</form>
<%
		} else if (Action.equals("newent_step3")) {

			////////////////////////////////////////////////////////////////////////////////////////////////////
			//
			// Add a new entitlement (Step 3)
			//

			String reqCountry = EnvTool.getStr(request, "reqCountry", "");
			HierRole reqRole = HierRole.getEnum(EnvTool.getStr(request, "reqRole", HierRole.UNKNW.getCode()));

			usrData = USR.Read(reqUser);
%>
			<div class="DS-padding-updn-8px">
				<div class="DS-text-title-shadow">New Entitlement for
					<b><%= usrData.getName() %></b><span class="DS-text-gray">(<%= usrData.getRank() %>)</span>
					<span class="DS-text-italic">(<%= usrData.getLastName() %>, <%= usrData.getFirstName() %>)</span>
				</div>
			</div>

			<form id="frmEntStep3">

				<input type="hidden" name="Action" value="newent_step4">
				<input type="hidden" name="reqUser" value="<%= reqUser %>">
				<input type="hidden" name="reqRole" value="<%= reqRole.getCode() %>">
				<input type="hidden" name="reqCountry" value="<%= reqCountry %>">

				<div class="DS-padding-updn-8px">
					<table class="TableSpacing_0px">
						<tr class="DS-border-full">
							<td class="DS-padding-8px DS-back-gray DS-border-rg">Selected Hierarchy Role</td>
							<td class="DS-padding-8px DS-text-bold"><%= reqRole.getDesc() %></td>
							<td class="DS-padding-8px DS-text-bold DS-text-green">&#9989;</td>
						</tr>
						<tr class="DS-border-dn DS-border-lfrg">
							<td class="DS-padding-8px DS-back-gray DS-border-rg">Selected Hierarchy Country</td>
							<td class="DS-padding-8px"><%= reqCountry.equals("") ? "N/A" : "<b>" + GEO.getFullDesc(reqCountry) + "</b>" %></td>
							<td class="DS-padding-8px DS-text-bold DS-text-green">&#9989;</td>
						</tr>
					</table>
				</div>
<%
				if (reqRole.getGeoLevelDeep() > 1) {
%>
					<div class="DS-padding-updn-8px">
						<%= MdcTool.Select.Box(
							"reqState",
							MdcTool.Select.Width.NORM,
							reqRole.getDesc() + " require a STATE",
							GEO.getStateCombo(reqCountry, ""),
							"onChange=\"submit();\""
						) %>
					</div>
<%
				} else {
%>
					<script>
						$('#frmEntStep3').submit();
					</script>
<%
				}
%>
				<div class="DS-padding-updn-8px">
					<table style="width: 100%" class="TableSpacing_0px">
						<tr>
							<td class="DS-padding-0px" align="left">
								<%= MdcTool.Button.TextIcon(
									"arrow_back_ios",
									"Cancel",
									null,
									"onClick=\"window.location.href=encodeURI('?Action=edit&reqUser=" + reqUser + "')\"",
									null
								) %>
							</td>
							<td class="DS-padding-0px" align="right">
								<%= MdcTool.Button.SubmitTextIcon(
									null,
									"Next&nbsp;",
									"arrow_forward_ios",
									null
								) %>
							</td>
						</tr>
					</table>
				</div>

			</form>
<%
		} else if (Action.equals("newent_step4")) {

			////////////////////////////////////////////////////////////////////////////////////////////////////
			//
			// Add a new entitlement (Step 4)
			//

			HierRole reqRole = HierRole.getEnum(EnvTool.getStr(request, "reqRole", HierRole.UNKNW.getCode()));
			String reqCountry = EnvTool.getStr(request, "reqCountry", "");
			String reqState = EnvTool.getStr(request, "reqState", "");

			usrData = USR.Read(reqUser);
%>
			<div class="DS-padding-updn-8px">
				<div class="DS-text-title-shadow">New Entitlement for
					<b><%= usrData.getName() %></b><span class="DS-text-gray">(<%= usrData.getRank() %>)</span>
					<span class="DS-text-italic">(<%= usrData.getLastName() %>, <%= usrData.getFirstName() %>)</span>
				</div>
			</div>

			<form id="frmEntStep4">

				<input type="hidden" name="Action" value="newent_step5">
				<input type="hidden" name="reqUser" value="<%= reqUser %>">
				<input type="hidden" name="reqRole" value="<%= reqRole.getCode() %>">
				<input type="hidden" name="reqCountry" value="<%= reqCountry %>">
				<input type="hidden" name="reqState" value="<%= reqState %>">

				<div class="DS-padding-updn-8px">
					<table class="TableSpacing_0px">
						<tr class="DS-border-full">
							<td class="DS-padding-8px DS-back-gray DS-border-rg">Selected Hierarchy Role</td>
							<td class="DS-padding-8px DS-text-bold"><%= reqRole.getDesc() %></td>
							<td class="DS-padding-8px DS-text-bold DS-text-green">&#9989;</td>
						</tr>
						<tr class="DS-border-dn DS-border-lfrg">
							<td class="DS-padding-8px DS-back-gray DS-border-rg">Selected Hierarchy Country</td>
							<td class="DS-padding-8px"><%= reqCountry.equals("") ? "N/A" : "<b>" + GEO.getFullDesc(reqCountry) + "</b>" %></td>
							<td class="DS-padding-8px DS-text-bold DS-text-green">&#9989;</td>
						</tr>
						<tr class="DS-border-dn DS-border-lfrg">
							<td class="DS-padding-8px DS-back-gray DS-border-rg">Selected Hierarchy State</td>
							<td class="DS-padding-8px"><%= reqState.equals("") ? "N/A" : "<b>" + GEO.getFullDesc(reqState) + "</b>" %></td>
							<td class="DS-padding-8px DS-text-bold DS-text-green">&#9989;</td>
						</tr>
					</table>
				</div>
<%
				if (reqRole.getGeoLevelDeep() > 2) {
%>
					<div class="DS-padding-updn-8px">
						<%= MdcTool.Select.Box(
							"reqDistrict",
							MdcTool.Select.Width.NORM,
							reqRole.getDesc() + " require a DISTRICT",
							GEO.getDistrictCombo(reqState, ""),
							"onChange=\"submit();\""
						) %>
					</div>
<%
				} else {
%>
					<script>
						$('#frmEntStep4').submit();
					</script>
<%
				}
%>
				<div class="DS-padding-updn-8px">
					<table style="width: 100%" class="TableSpacing_0px">
						<tr>
							<td class="DS-padding-0px" align="left">
								<%= MdcTool.Button.TextIcon(
									"arrow_back_ios",
									"Cancel",
									null,
									"onClick=\"window.location.href=encodeURI('?Action=edit&reqUser=" + reqUser + "')\"",
									null
								) %>
							</td>
							<td class="DS-padding-0px" align="right">
								<%= MdcTool.Button.SubmitTextIcon(
									null,
									"Next&nbsp;",
									"arrow_forward_ios",
									null
								) %>
							</td>
						</tr>
					</table>
				</div>

			</form>
<%
		} else if (Action.equals("newent_step5")) {

			////////////////////////////////////////////////////////////////////////////////////////////////////
			//
			// Add a new entitlement (Step 5)
			//

			HierRole reqRole = HierRole.getEnum(EnvTool.getStr(request, "reqRole", HierRole.UNKNW.getCode()));
			String reqCountry = EnvTool.getStr(request, "reqCountry", "");
			String reqState = EnvTool.getStr(request, "reqState", "");
			String reqDistrict = EnvTool.getStr(request, "reqDistrict", "");

			usrData = USR.Read(reqUser);
%>
			<div class="DS-padding-updn-8px">
				<div class="DS-text-title-shadow">New Entitlement for
					<b><%= usrData.getName() %></b><span class="DS-text-gray">(<%= usrData.getRank() %>)</span>
					<span class="DS-text-italic">(<%= usrData.getLastName() %>, <%= usrData.getFirstName() %>)</span>
				</div>
			</div>

			<form id="frmEntStep5">

				<input type="hidden" name="Action" value="newent_insert">
				<input type="hidden" name="reqUser" value="<%= reqUser %>">
				<input type="hidden" name="reqRole" value="<%= reqRole.getCode() %>">
				<input type="hidden" name="reqCountry" value="<%= reqCountry %>">
				<input type="hidden" name="reqState" value="<%= reqState %>">
				<input type="hidden" name="reqDistrict" value="<%= reqDistrict %>">

				<div class="DS-padding-updn-8px">
					<table class="TableSpacing_0px">
						<tr class="DS-border-full">
							<td class="DS-padding-8px DS-back-gray DS-border-rg">Selected Hierarchy Role</td>
							<td class="DS-padding-8px DS-text-bold"><%= reqRole.getDesc() %></td>
							<td class="DS-padding-8px DS-text-bold DS-text-green">&#9989;</td>
						</tr>
						<tr class="DS-border-dn DS-border-lfrg">
							<td class="DS-padding-8px DS-back-gray DS-border-rg">Selected Hierarchy Country</td>
							<td class="DS-padding-8px"><%= reqCountry.equals("") ? "N/A" : "<b>" + GEO.getFullDesc(reqCountry) + "</b>" %></td>
							<td class="DS-padding-8px DS-text-bold DS-text-green">&#9989;</td>
						</tr>
						<tr class="DS-border-dn DS-border-lfrg">
							<td class="DS-padding-8px DS-back-gray DS-border-rg">Selected Hierarchy State</td>
							<td class="DS-padding-8px"><%= reqState.equals("") ? "N/A" : "<b>" + GEO.getFullDesc(reqState) + "</b>" %></td>
							<td class="DS-padding-8px DS-text-bold DS-text-green">&#9989;</td>
						</tr>
						<tr class="DS-border-dn DS-border-lfrg">
							<td class="DS-padding-8px DS-back-gray DS-border-rg">Selected Hierarchy District</td>
							<td class="DS-padding-8px"><%= reqDistrict.equals("") ? "N/A" : "<b>" + GEO.getFullDesc(reqDistrict) + "</b>" %></td>
							<td class="DS-padding-8px DS-text-bold DS-text-green">&#9989;</td>
						</tr>
					</table>
				</div>

				<div class="DS-padding-updn-8px">
					<%= MdcTool.Text.Box(
						"reqStartDate",
						FmtTool.fmtDate(FmtTool.DATEZERO),
						MdcTool.Text.Type.TEXT,
						MdcTool.Text.Width.NORM,
						"Role start date (dd/mm/yyyy)",
						"size=\"18\" maxlength=\"10\""
					) %>
				</div>

				<div class="DS-padding-updn-8px">
					<table style="width: 100%" class="TableSpacing_0px">
						<tr>
							<td class="DS-padding-0px" align="left">
								<%= MdcTool.Button.TextIcon(
									"arrow_back_ios",
									"Cancel",
									null,
									"onClick=\"window.location.href=encodeURI('?Action=edit&reqUser=" + reqUser + "')\"",
									null
								) %>
							</td>
							<td class="DS-padding-0px" align="right">
								<%= MdcTool.Button.SubmitTextIconClass(
									"save",
									"&nbsp;Save",
									null,
									"DS-text-lime",
									null,
									"Save this entitlement and continue"
								) %>
							</td>
						</tr>
					</table>
				</div>

			</form>

			<script>
				$('#reqStartDate').select();
				$('#reqStartDate').focus();
			</script>
<%
		} else if (Action.equals("newent_insert")) {

			////////////////////////////////////////////////////////////////////////////////////////////////////
			//
			// Add a new entitlement (real insert)
			//

			String reqRole = EnvTool.getStr(request, "reqRole", HierRole.UNKNW.getCode());
			String reqCountry = EnvTool.getStr(request, "reqCountry", "");
			String reqState = EnvTool.getStr(request, "reqState", "");
			String reqDistrict = EnvTool.getStr(request, "reqDistrict", "");
			Date reqStartDate = FmtTool.scnDate(EnvTool.getStr(request, "reqStartDate", FmtTool.fmtDate(FmtTool.DATEZERO)));

			Hierarchy.Data ahiData = AHI.new Data();

			ahiData.setNickName(reqUser);
			ahiData.setRole(reqRole);
			ahiData.setSince(FmtTool.Date2Timestamp(reqStartDate));
			ahiData.setLastUpdatedBy(SysTool.getCurrentUser(request));

			ahiData.setGeoRef(
				(reqDistrict.equals("")
					? (reqState.equals("")
						? reqCountry
						: reqState
					)
					: reqDistrict
				)
			);

			try {

				AHI.Insert(ahiData);
				MSG.setSnackText("Entitlement Created");

			} catch (java.sql.SQLIntegrityConstraintViolationException ee) {

				MSG.setSlideText("Existing Entitlement", "This user is already a <b>" + HierRole.getDesc(reqRole) + "</b> of <b>" + GEO.getFullDesc(ahiData.getGeoRef()) + "</b>");
			}

			RedirectTo = "?Action=edit&reqUser=" + reqUser;

		} else if (Action.equals("delent")) {

			////////////////////////////////////////////////////////////////////////////////////////////////////
			//
			// Delete an existing entitlement
			//

			String reqRole = EnvTool.getStr(request, "reqRole", HierRole.UNKNW.getCode());
			String reqGeoc = EnvTool.getStr(request, "reqGeoc", "");

			try {
			
				AHI.Delete(reqUser, reqRole, reqGeoc);
				MSG.setSnackText("Entitlement deleted");

			} catch (Exception ee) {

				MSG.setAlertText("Error Deleting Entitlement", ee.toString());
			}

			RedirectTo = "?Action=edit&reqUser=" + reqUser;

		} else if (Action.equals("delapikey")) {

			////////////////////////////////////////////////////////////////////////////////////////////////////
			//
			// Delete CIFP API-KEY
			//

			usrData = USR.Read(reqUser);

			usrData.getWazerConfig().getCifp().setApiKey(SysTool.getEmptyUuidValue());
			usrData.setConfig(usrData.getWazerConfig().toJson());
			USR.Update(reqUser, usrData);

			MSG.setSnackText("CIFP API-KEY deleted");
			RedirectTo = "?Action=edit&reqUser=" + reqUser;

		} else if (Action.equals("newapikey")) {

			////////////////////////////////////////////////////////////////////////////////////////////////////
			//
			// Regenerate CIFP API-KEY
			//

			usrData = USR.Read(reqUser);

			usrData.getWazerConfig().getCifp().setApiKey(UUID.randomUUID().toString());
			usrData.setConfig(usrData.getWazerConfig().toJson());
			USR.Update(reqUser, usrData);

			MSG.setSnackText("New CIFP API-KEY created");
			RedirectTo = "?Action=edit&reqUser=" + reqUser;

		} else if (Action.equals("mailapikey")) {

			////////////////////////////////////////////////////////////////////////////////////////////////////
			//
			// Mail CIFP API-KEY
			//

			usrData = USR.Read(EnvTool.getStr(request, "apiUser", ""));

			Mail MAIL = new Mail(request);

			MAIL.setRecipient(usrData.getMail());
			MAIL.setSubject("Your CIFP API-KEY");
			MAIL.setHtmlTitle("A CIFP Admin sent you your API-KEY");

			MAIL.addHtmlBody("<div>You received this email because <b>" + SysTool.getCurrentUser(request) + "</b> sent you the <b>CIFP API-KEY</b> for use with the WME WCIFP script.</div>");
			MAIL.addHtmlBody("<pre>");
			MAIL.addHtmlBody("<big><b>Your API-KEY</b>: <b style=\"color:green\">" + usrData.getWazerConfig().getCifp().getApiKey() + "</b></big>");
			MAIL.addHtmlBody("</pre>");
			MAIL.addHtmlBody("<div>Register your API-KEY from WME using the WCIFP script and clicking the golden key button.</div>");
			MAIL.addHtmlBody("<p>Happy editing...</p>");

			if (MAIL.Send()) {
				MSG.setSnackText("Mail sent to " + MAIL.getRecipient());
				LOG.Info(request, LogTool.Category.MAIL, "Mail sent to '" + MAIL.getRecipient() + "' with subject '" + MAIL.getSubject() + "'");
			} else {
				MSG.setSlideText("Mail Error", MAIL.getLastError());
				LOG.Error(request, LogTool.Category.MAIL, "Error sending mail to '" + MAIL.getRecipient() + "' with subject '" + MAIL.getSubject() + "': " + MAIL.getLastError());
			}

			MSG.setSnackText("CIFP API-KEY sent to " + usrData.getMail());
			RedirectTo = "?Action=edit&reqUser=" + usrData.getName();

		} else {

			////////////////////////////////////////////////////////////////////////////////////////////////////
			//
			// BAD Action
			//

			MSG.setAlertText("Internal Error", "BAD Action: '" + Action + "'");

			RedirectTo = "../admin/";
		}

	} catch (Exception e) {

		MSG.setAlertText("Internal Error", e.toString());
		RedirectTo = "../admin/";
	}

	DB.destroy();
%>
	</div>
	</div>
	</div>

	<jsp:include page="../_common/footer.jsp">
		<jsp:param name="RedirectTo" value="<%= RedirectTo %>"/>
	</jsp:include>

</body>
</html>
