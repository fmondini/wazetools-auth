<%@ page
	language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="java.util.*"
	import="net.danisoft.dslib.*"
	import="net.danisoft.wtlib.auth.*"
	import="net.danisoft.wtlib.ureq.*"
%>
<%!
	private static final String PAGE_Title = "Change your profile data";
	private static final String PAGE_Keywords = "Change, User, Profile";
	private static final String PAGE_Description = "Utility to change your user profile data";

	private static final String MAIL_CFG_DESCR_MASK = "%-20s";

	private static String mailCfgHead(String headText) {
		return(
			"<tt><b style=\"color:DarkSlateBlue\"><big>" + headText + "</big></b></tt><br>"
		);
	}

	private static String mailCfgBody(String descrText, String valueText) {
		String descr = String.format(Locale.ROOT, MAIL_CFG_DESCR_MASK, descrText).replaceAll(" ", "_");
		return(
			"<tt>" +
				descr + " <b>" + valueText + "</b>" +
			"</tt>" +
			"<br>"
		);
	}

	private static String mailCfgBody(String descrText, String valueBold, String valueData) {
		String descr = String.format(Locale.ROOT, MAIL_CFG_DESCR_MASK, descrText).replaceAll(" ", "_");
		return(
			"<tt>" +
				descr + " <b>" + valueBold + "</b> (" + valueData + ")" +
			"</tt>" +
			"<br>"
		);
	}
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
	 * Show SlackID Help
	 */
	function getSlackIdHelp() {

		let HelpHead = '',  HelpBody = '';

		$.ajax({
			type: "GET",
			url: '../home/_slackid_help_content.jsp',

			success: function(data) {
				HelpHead = 'How to add your SlackID in your AUTH profile';
				HelpBody = data;
			},

			error: function(XMLHttpRequest, textStatus, errorThrown) {
				HelpHead = '+++ ERROR FOUND +++';
				HelpBody = 'ERROR ' + XMLHttpRequest.status + ': ' + XMLHttpRequest.statusText;
			},

			complete: function(jqXHR, textStatus) {
				ShowDialog_OK(HelpHead, '<div class="DS-padding-lfrg-8px">' + HelpBody + '</div>', 'OK');
			}
		});
	}

	/**
	 * Test SlackID
	 */
	function testSlackID(SlackID) {

		var ResultText = '';

		$.ajax({
			type: "POST",
			url: '../home/_slackid_test.jsp',
			data: { id: SlackID },

			success: function(data) {
				ResultText = data;
			},

			error: function(XMLHttpRequest, textStatus, errorThrown) {
				ResultText = 'ERROR ' + XMLHttpRequest.status + ': ' + XMLHttpRequest.statusText;
			},

			complete: function(jqXHR, textStatus) {
				ShowDialog_OK('SlackID Test Results', '<div class="DS-padding-lfrg-8px">' + ResultText + '</div>', 'OK');
			}
		});
	}

	</script>

</head>

<body>

	<jsp:include page="../_common/header.jsp" />

	<div class="mdc-layout-grid DS-layout-body">
	<div class="mdc-layout-grid__inner">
	<div class="<%= MdcTool.Layout.Cell(12, 8, 4) %>">
<%
	Database DB = new Database();
	MsgTool MSG = new MsgTool(session);
	User USR = new User(DB.getConnection());
	LogTool LOG = new LogTool(DB.getConnection());

	String RedirectTo = "";
	String Action = EnvTool.getStr(request, "Action", "");
	String envFirstName = EnvTool.getStr(request, "envFirstName", "");
	String envLastName = EnvTool.getStr(request, "envLastName", "");
	String envMail = EnvTool.getStr(request, "envMail", "");
	String envSlackID = EnvTool.getStr(request, "envSlackID", "");
	String envPhone = EnvTool.getStr(request, "envPhone", "");

	try {

		if (Action.equals("")) {

			////////////////////////////////////////////////////////////////////////////////////////////////////
			//
			// Show profile data
			//

			User.Data usrData = USR.Read(SysTool.getCurrentUser(request));
%>
			<div class="DS-card-body">
				<div class="DS-text-title-shadow">Waze.Tools profile for <%= usrData.getName() %><span class="DS-text-gray">(<%= usrData.getRank() %>)</span></div>
			</div>

			<form>

				<input type="hidden" name="Action" value="update">
<%
				//
				// Line 1
				//
%>
				<div class="mdc-layout-grid__inner DS-padding-updn-8px">

					<div class="<%= MdcTool.Layout.Cell(4, 2, 4) %>">
						<%= MdcTool.Text.Box(
							"envFirstName",
							usrData.getFirstName(),
							MdcTool.Text.Type.TEXT,
							MdcTool.Text.Width.FULL,
							"First Name",
							"maxlength=\"254\""
						) %>
					</div>

					<div class="<%= MdcTool.Layout.Cell(4, 2, 4) %>">
						<%= MdcTool.Text.Box(
							"envLastName",
							usrData.getLastName(),
							MdcTool.Text.Type.TEXT,
							MdcTool.Text.Width.FULL,
							"Last Name",
							"maxlength=\"254\""
						) %>
					</div>

					<div class="<%= MdcTool.Layout.Cell(4, 4, 4) %>">
						<%= MdcTool.Text.Box(
							"envMail",
							usrData.getMail(),
							MdcTool.Text.Type.TEXT,
							MdcTool.Text.Width.FULL,
							"e-Mail Address",
							"maxlength=\"254\""
						) %>
					</div>

				</div>
<%
				//
				// Line 2
				//
%>
				<div class="mdc-layout-grid__inner DS-padding-updn-8px">

					<div class="<%= MdcTool.Layout.Cell(2, 2, 2) %>">
						<%= MdcTool.Text.Box(
							"envPhone",
							usrData.getPhone(),
							MdcTool.Text.Type.TEXT,
							MdcTool.Text.Width.FULL,
							"Cellular / Phone",
							"maxlength=\"32\""
						) %>
					</div>

					<div class="<%= MdcTool.Layout.Cell(2, 2, 2) %>">
						<%= MdcTool.Text.Box(
							"envSlackID",
							usrData.getSlackID(),
							MdcTool.Text.Type.TEXT,
							MdcTool.Text.Width.FULL,
							"Slack UserID",
							"maxlength=\"32\""
						) %>
					</div>

					<div class="<%= MdcTool.Layout.Cell(2, 4, 4) %>">
						<div class="mdc-layout-grid__inner DS-grid-gap-4px">
							<div class="<%= MdcTool.Layout.Cell(2, 2, 1) %> DS-grid-middle-center">
								<span class="material-icons DS-text-blue">help_outline</span>
							</div>
							<div class="<%= MdcTool.Layout.Cell(10, 6, 3) %> DS-grid-middle-left">
								<div class="DS-text-compact DS-text-italic">
									<a href="#" onClick="getSlackIdHelp();">Help on SlackID</a>
								</div>
							</div>
							<div class="<%= MdcTool.Layout.Cell(2, 2, 1) %> DS-grid-middle-center">
								<span class="material-icons DS-text-green">event_available</span>
							</div>
							<div class="<%= MdcTool.Layout.Cell(10, 6, 3) %> DS-grid-middle-left">
								<div class="DS-text-compact DS-text-italic">
									<a href="#" onClick="testSlackID('<%= usrData.getSlackID() %>');">Test your SlackID</a>
								</div>
							</div>
						</div>
					</div>
					
					<div class="<%= MdcTool.Layout.Cell(2, 4, 4) %>"></div>

					<div class="<%= MdcTool.Layout.Cell(4, 4, 4) %> DS-grid-middle-center">
						<% if (!usrData.getWazerConfig().getCifp().getApiKey().equals(SysTool.getEmptyUuidValue())) { %>
							<div align="center">
								<div class="DS-text-black DS-text-italic">Your current CIFP API-KEY</div>
								<div class="DS-text-fixed DS-text-purple DS-text-bold"><%= usrData.getWazerConfig().getCifp().getApiKey() %></div>
							</div>
						<% } %>
					</div>

				</div>
<%
				//
				// Line 3 (notes)
				//
%>
				<div class="mdc-layout-grid__inner DS-padding-updn-8px">

					<div class="<%= MdcTool.Layout.Cell(1, 1, 1) %> DS-grid-top-right">
						<div class="DS-text-large DS-text-bold DS-text-italic DS-padding-top-8px">NOTE:</div>
					</div>

					<div class="<%= MdcTool.Layout.Cell(11, 7, 3) %> DS-grid-top-left">
						<div class="DS-padding-top-8px">
							<div class="DS-padding-top-0px DS-padding-bottom-4px">&#10132; <i>Don't forget to <b>SAVE your profile data</b> before testing your SlackID</i></div>
							<div class="DS-padding-top-0px DS-padding-bottom-4px">&#10132; <i>If both e-Mail and SlackID are missing, no communication will take place</i></div>
							<div class="DS-padding-top-0px DS-padding-bottom-4px">&#10132; <i>If SlackID is missing but e-mail is present, communications will take place via e-mail</i></div>
							<div class="DS-padding-top-0px DS-padding-bottom-4px">&#10132; <i>If e-Mail is missing but SlackID is present, communications will take place via Slack Direct Message</i></div>
							<div class="DS-padding-top-0px DS-padding-bottom-4px">&#10132; <i>If both e-Mail and SlackID are present, communications will occur via Slack Direct Message; e-Mail will only be used for messages that haven't been converted to Slack yet</i></div>
							<div class="DS-padding-top-0px DS-padding-bottom-4px">&#10132; <i>Your phone number will not be used under any circumstances; it's only here for possible future 2FA authentication. You can skip it.</i></div>
						</div>
					</div>

				</div>
<%
				//
				// Footer
				//
%>
				<div class="DS-card-foot">
					<div class="mdc-layout-grid__inner DS-padding-updn-8px">
						<div class="<%= MdcTool.Layout.Cell(2, 2, 1) %> DS-grid-middle-left">
							<%= MdcTool.Button.BackTextIcon("Back", "../user/") %>
						</div>
						<div class="<%= MdcTool.Layout.Cell(8, 4, 2) %> DS-grid-middle-center">
							<div align="center">
								<div class="DS-text-purple DS-text-italic">Please note that this data will be used in all Waze.Tools suite applications</div>
							</div>
						</div>
						<div class="<%= MdcTool.Layout.Cell(2, 2, 1) %> DS-grid-middle-right">
							<%= MdcTool.Button.SubmitTextIconClass("save", "&nbsp;Save", null, "DS-text-lime", null, null) %>
						</div>
					</div>
				</div>

			</form>
<%
		} else if (Action.equals("update")) {

			////////////////////////////////////////////////////////////////////////////////////////////////////
			//
			// Check data
			//

			String OldMail = "";

			if (!envFirstName.equals("") && !envFirstName.equals(User.getChangeFieldReminder())) {
			
				if (!envLastName.equals("") && !envLastName.equals(User.getChangeFieldReminder())) {

					if (!envMail.equals("") && !envMail.equals(User.getChangeFieldReminder())) {

						User.Data usrData = USR.Read(SysTool.getCurrentUser(request));

						// Save data

						OldMail = usrData.getMail();

						usrData.setFirstName(envFirstName);
						usrData.setLastName(envLastName);
						usrData.setMail(envMail);
						usrData.setSlackID(envSlackID);
						usrData.setPhone(envPhone);

						USR.Update(SysTool.getCurrentUser(request), usrData);

						DB.commit();

						// Refresh data

						usrData = USR.Read(SysTool.getCurrentUser(request));

						// Notify the user

						if (!usrData.getMail().equals(OldMail)) {

							Mail MAIL_O = new Mail(request);

							MAIL_O.setRecipient(OldMail);
							MAIL_O.setSubject("Your Waze.Tools email has been changed");
							MAIL_O.setHtmlTitle("This e-Mail address has just been removed");

							MAIL_O.addHtmlBody("<div>The " + OldMail + " address has just been <u>removed</u> from your Waze.Tools</div>");
							MAIL_O.addHtmlBody("<div>profile and replaced by the new e-Mail address: <b>" + usrData.getMail() + "</u></div>");

							if (MAIL_O.Send()) {
								MSG.setSnackText("Mail sent to " + MAIL_O.getRecipient());
								LOG.Info(request, LogTool.Category.MAIL, "Mail sent to '" + MAIL_O.getRecipient() + "' with subject '" + MAIL_O.getSubject() + "'");
							} else {
								MSG.setSlideText("Mail Error", MAIL_O.getLastError());
								LOG.Error(request, LogTool.Category.MAIL, "Error sending mail to '" + MAIL_O.getRecipient() + "' with subject '" + MAIL_O.getSubject() + "': " + MAIL_O.getLastError());
							}
						}

						GeoIso GEO = new GeoIso(DB.getConnection());
						Mail MAIL_N = new Mail(request);

						MAIL_N.setRecipient(usrData.getMail());
						MAIL_N.setSubject("Your Waze.Tools profile has been updated");
						MAIL_N.setHtmlTitle("Your profile on Waze.Tools has just been updated");

						MAIL_N.addHtmlBody("<p>This operation was triggered at <b>" + FmtTool.fmtDateTime() + "</b> from IP Address <b>" + FmtTool.getWhoisLink(request.getRemoteAddr()) + "</b></p>");
						MAIL_N.addHtmlBody("<p>Here is a summary of your current profile:</p>");

						MAIL_N.addHtmlBody(mailCfgHead("Contacts"));
						MAIL_N.addHtmlBody(mailCfgBody("User Name", usrData.getName()));
						MAIL_N.addHtmlBody(mailCfgBody("Password", usrData.getPass()));
						MAIL_N.addHtmlBody(mailCfgBody("First Name", usrData.getFirstName()));
						MAIL_N.addHtmlBody(mailCfgBody("Last Name", usrData.getLastName()));
						MAIL_N.addHtmlBody(mailCfgBody("Phone", usrData.getPhone()));
						MAIL_N.addHtmlBody(mailCfgBody("e-Mail", usrData.getMail()));
						MAIL_N.addHtmlBody(mailCfgBody("Slack ID", usrData.getSlackID()));
						MAIL_N.addHtmlBody("<br>");

						// AUTH

						MAIL_N.addHtmlBody(mailCfgHead("AUTH WebApp"));
						MAIL_N.addHtmlBody(mailCfgBody("Home Country", usrData.getCountry(), GEO.getFullDesc(usrData.getCountry())));
						
						Vector<String> vecAuthCountryCodes = usrData.getWazerConfig().getAuth().getActiveCountryCodes();
						
						for (String authCountryCode : vecAuthCountryCodes)
							MAIL_N.addHtmlBody(mailCfgBody("Additional Country", authCountryCode, GEO.getFullDesc(authCountryCode)));

						MAIL_N.addHtmlBody("<br>");

						// UREQ

						TomcatRole TCR = new TomcatRole(DB.getConnection());

						MAIL_N.addHtmlBody(mailCfgHead("UREQ WebApp"));
						MAIL_N.addHtmlBody(mailCfgBody("Unlock Privileges", TCR.haveRoleUREQ(usrData.getName(), UreqRole.UNLCK) ? "YES (in enabled countries)" : "NO"));

						Vector<String> vecUreqCountryCodes = usrData.getWazerConfig().getUreq().getActiveCountryCodes();

						if (vecUreqCountryCodes.isEmpty()) {
							MAIL_N.addHtmlBody(mailCfgBody("Enabled Country", "NONE"));
						} else {
							for (String ureqCountryCode : vecUreqCountryCodes)
								MAIL_N.addHtmlBody(mailCfgBody("Enabled Country", ureqCountryCode, GEO.getFullDesc(ureqCountryCode)));
						}

						MAIL_N.addHtmlBody("<br>");

						// CIFP

						boolean apiKeyIsValid = (
							!usrData.getWazerConfig().getCifp().getApiKey().trim().equals("") &&
							!usrData.getWazerConfig().getCifp().getApiKey().equals(SysTool.getEmptyUuidValue())
						);

						MAIL_N.addHtmlBody(mailCfgHead("CIFP WebApp"));

						if (apiKeyIsValid) {

							MAIL_N.addHtmlBody(mailCfgBody("Your API-KEY", usrData.getWazerConfig().getCifp().getApiKey()));
							
							MAIL_N.addHtmlBody(mailCfgBody("Admin Flag", usrData.getWazerConfig().getCifp().isAdmin() ? "YES (in enabled countries)" : "NO"));

							Vector<String> vecCountries = usrData.getWazerConfig().getCifp().getActiveCountryCodes();

							for (String usrCountry : vecCountries)
								MAIL_N.addHtmlBody(mailCfgBody("Enabled Country", usrCountry, GEO.getFullDesc(usrCountry)));

						} else
							MAIL_N.addHtmlBody(mailCfgBody("Your API-KEY", "No API-KEY found"));

						MAIL_N.addHtmlBody("<p>End of summary.</p>");

						if (MAIL_N.Send()) {
							MSG.setSnackText("Mail sent to " + MAIL_N.getRecipient());
							LOG.Info(request, LogTool.Category.MAIL, "Mail sent to '" + MAIL_N.getRecipient() + "' with subject '" + MAIL_N.getSubject() + "'");
						} else {
							MSG.setSlideText("Mail Error", MAIL_N.getLastError());
							LOG.Error(request, LogTool.Category.MAIL, "Error sending mail to '" + MAIL_N.getRecipient() + "' with subject '" + MAIL_N.getSubject() + "': " + MAIL_N.getLastError());
						}

						MSG.setSnackText("Mail sent to " + usrData.getMail());

						// Done

						RedirectTo = "../user/";

					} else {
						MSG.setSlideText("Data Error", "e-Mail address needed");
						RedirectTo = "?";
					}

				} else {
					MSG.setSlideText("Data Error", "Lastname needed");
					RedirectTo = "?";
				}

			} else {
				MSG.setSlideText("Data Error", "Firstname needed");
				RedirectTo = "?";
			}

		} else {

			throw new Exception("Unknown Action: '" + Action + "'");
		}

	} catch (Exception e) {
%>
		<div class="DS-card-head">
			<div class="DS-text-subtitle DS-text-exception">Internal Error</div>
		</div>
		<div class="DS-card-foot">
			<div class="DS-text-exception"><%= e.toString() %></div>
		</div>
<%
	}

	DB.destroy();
%>
	</div>
	</div> <!-- /mdc-layout-grid__inner -->
	</div> <!-- /mdc-layout-grid -->

	<jsp:include page="../_common/footer.jsp">
		<jsp:param name="RedirectTo" value="<%= RedirectTo %>"/>
	</jsp:include>

</body>
</html>
