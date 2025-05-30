<%@ page
	language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="net.danisoft.dslib.*"
	import="net.danisoft.wtlib.auth.*"
	import="net.danisoft.wazetools.*"
	import="net.danisoft.wazetools.auth.*"
%>
<%!
	private static final String PAGE_Title = "Register as a new user";
	private static final String PAGE_Keywords = "Register, New, User, Credentials, Password";
	private static final String PAGE_Description = "Register as a new user. Your new account will be ready once approved by our administrators.";

	private static final String MANDATORY_FLAG = "<span class=\"DS-text-exception\">&nbsp;(<b>*</b>)</span>";
%>
<!DOCTYPE html>
<html>
<head>
	<jsp:include page="../_common/head.jsp">
		<jsp:param name="PAGE_Title" value="<%= PAGE_Title %>"/>
		<jsp:param name="PAGE_Keywords" value="<%= PAGE_Keywords %>"/>
		<jsp:param name="PAGE_Description" value="<%= PAGE_Description %>"/>
	</jsp:include>
	<script <%= "async defer" %> src="https://www.google.com/recaptcha/api.js"></script>
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
	TomcatRole TCR = new TomcatRole(DB.getConnection());
	LogTool LOG = new LogTool(DB.getConnection());

	String Action = EnvTool.getStr(request, "Action", "");

	String reqCountry = EnvTool.getStr(request, "reqCountry", "").trim();
	String reqUsr = EnvTool.getStr(request, "reqUsr", "").trim();
	String reqPwd = EnvTool.getStr(request, "reqPwd", "").trim();
	String reqMail = EnvTool.getStr(request, "reqMail", "").trim();
	int reqCones = EnvTool.getInt(request, "reqCones", Cones.C1.getCones());
	String reqFName = EnvTool.getStr(request, "reqFName", "").trim();
	String reqLName = EnvTool.getStr(request, "reqLName", "").trim();
	String reqCell = EnvTool.getStr(request, "reqCell", "").replace(" 39", "+39").trim();

	if (Action.equals("")) {

		////////////////////////////////////////////////////////////////////////////////////////////////////
		//
		// Ask registration data
		//
%>
		<form>

			<input type="hidden" name="Action" value="create">

			<div class="DS-padding-updn-8px">
				<div class="DS-text-title-shadow"><%= PAGE_Title %></div>
			</div>

			<div class="DS-padding-updn-8px">
				<table class="TableSpacing_0px DS-full-width">

					<tr class="DS-border-updn">
						<td class="DS-padding-4px DS-back-gray DS-border-lfrg">
							<table class="TableSpacing_0px DS-full-width">
								<tr>
									<td class="DS-padding-0px" align="left">Country</td>
									<td class="DS-padding-0px" align="right"><%= MANDATORY_FLAG %></td>
								</tr>
							</table>
						</td>
						<td class="DS-padding-4px">
							<select id="reqCountry" name="reqCountry" class="DS-input-textbox" style="width: 100%">
								<%= TCR.getActiveCountriesCombo(reqCountry) %>
							</select>
						</td>
						<td class="DS-padding-4px DS-text-italic DS-text-gray DS-border-rg">Only countries with an active administrator are displayed</td>
					</tr>

					<tr class="DS-border-dn">
						<td class="DS-padding-4px DS-back-gray DS-border-lfrg">
							<table class="TableSpacing_0px DS-full-width">
								<tr>
									<td class="DS-padding-0px" align="left">Username</td>
									<td class="DS-padding-0px" align="right"><%= MANDATORY_FLAG %></td>
								</tr>
							</table>
						</td>
						<td class="DS-padding-4px DS-border-dn"><input class="DS-input-textbox" type="text" id="reqUsr" name="reqUsr" style="width: 100%" value="<%= reqUsr %>"></td>
						<td class="DS-padding-4px DS-text-italic DS-text-gray DS-border-rg">The username you are registered with in waze</td>
					</tr>

					<tr class="DS-border-dn">
						<td class="DS-padding-4px DS-back-gray DS-border-lfrg">
							<table class="TableSpacing_0px DS-full-width">
								<tr>
									<td class="DS-padding-0px" align="left">Password</td>
									<td class="DS-padding-0px" align="right"><%= MANDATORY_FLAG %></td>
								</tr>
							</table>
						</td>
						<td class="DS-padding-4px"><input class="DS-input-textbox" type="text" id="reqPwd" name="reqPwd" style="width: 100%" value="<%= reqPwd %>"></td>
						<td class="DS-padding-4px DS-text-italic DS-text-gray DS-border-rg">For security reasons, do not use the same password used in Waze</td>
					</tr>

					<tr class="DS-border-dn">
						<td class="DS-padding-4px DS-back-gray DS-border-lfrg">
							<table class="TableSpacing_0px DS-full-width">
								<tr>
									<td class="DS-padding-0px" align="left">e-Mail Address</td>
									<td class="DS-padding-0px" align="right"><%= MANDATORY_FLAG %></td>
								</tr>
							</table>
						</td>
						<td class="DS-padding-4px"><input class="DS-input-textbox" type="text" id="reqMail" name="reqMail" style="width: 100%" value="<%= reqMail %>"></td>
						<td class="DS-padding-4px DS-text-italic DS-text-gray DS-border-rg">Your email address to receive communications from all Waze.Tools Suite apps</td>
					</tr>

					<tr class="DS-border-dn">
						<td class="DS-padding-4px DS-back-gray DS-border-lfrg">
							<table class="TableSpacing_0px DS-full-width">
								<tr>
									<td class="DS-padding-0px" align="left">Waze Rank</td>
									<td class="DS-padding-0px" align="right"><%= MANDATORY_FLAG %></td>
								</tr>
							</table>
						</td>
						<td class="DS-padding-4px">
							<select id="reqCones" name="reqCones" class="DS-input-textbox" style="width: 100%">
								<%= Cones.getCombo(reqCones) %>
							</select>
						</td>
						<td class="DS-padding-4px DS-text-italic DS-text-gray DS-border-rg">Select the Rank (number of cones) you have in your Waze account</td>
					</tr>

					<tr class="DS-border-dn">
						<td class="DS-padding-4px DS-back-gray DS-border-lfrg">First Name</td>
						<td class="DS-padding-4px">
							<input class="DS-input-textbox" type="text" id="reqFName" name="reqFName" style="width: 100%" value="<%= reqFName %>">
						</td>
						<td class="DS-padding-4px DS-text-italic DS-text-gray DS-border-rg">Your Name (optional)</td>
					</tr>

					<tr class="DS-border-dn">
						<td class="DS-padding-4px DS-back-gray DS-border-lfrg">Last Name</td>
						<td class="DS-padding-4px">
							<input class="DS-input-textbox" type="text" id="reqLName" name="reqLName" style="width: 100%" value="<%= reqLName %>">
						</td>
						<td class="DS-padding-4px DS-text-italic DS-text-gray DS-border-rg">Your Surname (optional)</td>
					</tr>

					<tr class="DS-border-dn">
						<td class="DS-padding-4px DS-back-gray DS-border-lfrg">Cell Phone</td>
						<td class="DS-padding-4px">
							<input class="DS-input-textbox" type="text" id="reqCell" name="reqCell" style="width: 100%" value="<%= reqCell %>">
						</td>
						<td class="DS-padding-4px DS-text-italic DS-text-gray DS-border-rg">Your cell phone number (optional)</td>
					</tr>

				</table>
			</div>

			<div class="DS-padding-updn-8px">
				<table class="TableSpacing_0px DS-full-width">
					<tr>
						<td class="DS-padding-0px" align="left" width="25%">
							<div class="DS-text-italic"><%= MANDATORY_FLAG %> = This field is mandatory</div>
						</td>
						<td class="DS-padding-0px" valign="top" align="center" width="50%" RowSpan="2">
							<div <%= "data-sitekey=\"6Ldpz-QUAAAAAJp9kOr555-Vl0HqYM5X-yFjvsjD\"" %> class="g-recaptcha"></div>
						</td>
						<td class="DS-padding-0px" align="right" width="25%">
						</td>
					</tr>
					<tr>
						<td class="DS-padding-0px" align="left" valign="bottom">
							<%= MdcTool.Button.BackTextIcon("Back", "../anonymous/") %>
						</td>
						<td class="DS-padding-0px" align="right" valign="bottom">
							<%= MdcTool.Button.SubmitTextIconClass("save", "&nbsp;Save", null, "DS-text-lime", null, "Save and Continue") %>
						</td>
					</tr>
				</table>
			</div>

		</form>
<%
	} else if (Action.equals("create")) {

		////////////////////////////////////////////////////////////////////////////////////////////////////
		//
		// Check data and create user
		//
%>
		<div class="DS-padding-updn-8px" align="center">
			<div class="DS-text-subtitle">Please wait...</div>
		</div>
<%
		try {

			User USR = new User(DB.getConnection());

			// Check fields

			String AllErrors = "";

			if (reqCountry.equals(""))	AllErrors += "<li>Country is needed</li>";
			if (reqUsr.equals(""))		AllErrors += "<li>Username is needed</li>";
			if (reqPwd.equals(""))		AllErrors += "<li>Password is needed</li>";
			if (reqMail.equals(""))		AllErrors += "<li>e-Mail address is needed</li>";

			if (USR.Exists(reqUsr))
				throw new Exception("<b>Unable to insert, user " + reqUsr + " already exists.</b>");

			if (!AllErrors.equals(""))
				throw new Exception("<b>Cannot insert user, some errors found:</b><ul>" + AllErrors + "</ul>");

			// Check ReCaptcha

			if (!ReCaptchaV2.VerifyResponse(EnvTool.getStr(request, "g-recaptcha-response", "")))
				throw new Exception("Anti-Robot Check failed.");

			// Create

			USR.Create(reqUsr, reqCountry, SysTool.getCurrentUser(request));

			// Update

			User.Data usrData = USR.Read(reqUsr);

			usrData.setPass(reqPwd);
			usrData.setMail(reqMail);
			usrData.setRank(reqCones);
			usrData.setFirstName(reqFName);
			usrData.setLastName(reqLName);
			usrData.setPhone(reqCell);
			
			USR.Update(reqUsr, usrData);

			LOG.Info(request, LogTool.Category.USER, "New account created by " + SysTool.getCurrentUser(request) + ": " + reqUsr);

			// Alert SysOp

			GeoIso GEO = new GeoIso(DB.getConnection());
			Mail MAIL = new Mail(request);

			MAIL.setRecipient("fmondini@danisoft.net"); // TODO: New User Registration: Send an email to every country admin
			MAIL.setSubject("New account created in " +  AppCfg.getAppName());
			MAIL.setHtmlTitle("A new account has been created by " + SysTool.getCurrentUser(request) + ": " + reqUsr);

			MAIL.addHtmlBody("<div>You are receiving this email because you are listed as an administrator in this country of " + AppCfg.getAppName() + ": <b>[" + reqCountry + "] " + GEO.getFullDesc(reqCountry) + "</b></div>");
			MAIL.addHtmlBody("<pre>");
			MAIL.addHtmlBody("Country.....: " + reqCountry);
			MAIL.addHtmlBody("Username....: " + reqUsr);
			MAIL.addHtmlBody("Rank (cones): " + reqCones);
			MAIL.addHtmlBody("e-Mail......: " + reqMail);
			MAIL.addHtmlBody("First Name..: " + reqFName);
			MAIL.addHtmlBody("Last Name...: " + reqLName);
			MAIL.addHtmlBody("Phone.......: " + reqCell);
			MAIL.addHtmlBody("</pre>");
			MAIL.addHtmlBody("<div>Review the account by <a href=\"" + AppCfg.getServerHomeUrl() + "/admin/users.jsp?Action=edit&reqUser=" + reqUsr + "\">clicking here</a> (Admin privilege required).</div>");

			if (MAIL.Send()) {
				MSG.setSnackText("Mail sent to " + MAIL.getRecipient());
				LOG.Info(request, LogTool.Category.MAIL, "Mail sent to '" + MAIL.getRecipient() + "' with subject '" + MAIL.getSubject() + "'");
			} else {
				MSG.setSlideText("Mail Error", MAIL.getLastError());
				LOG.Error(request, LogTool.Category.MAIL, "Error sending mail to '" + MAIL.getRecipient() + "' with subject '" + MAIL.getSubject() + "': " + MAIL.getLastError());
			}

			// Done

			MSG.setInfoText("Account created",
				"Your account has been created. Log in using the username and password you just provided.<br>" +
				"Keep in mind that your account must now be validated by an administrator before you can use it in full."
			);

			RedirectTo = "../user/";

		} catch (Exception e) {

			MSG.setSlideText("Update Error", e.getMessage());

			RedirectTo = "?" +
				"reqCountry=" + reqCountry + "&" +
				"reqUsr=" + reqUsr + "&" +
				"reqPwd=" + reqPwd + "&" +
				"reqMail=" + reqMail + "&" +
				"reqCones=" + reqCones + "&" +
				"reqFName=" + reqFName + "&" +
				"reqLName=" + reqLName + "&" +
				"reqCell=" + reqCell
			;
		}

	} else {

		MSG.setAlertText("Internal Error", "Bad Action: '" + Action + "'");
		RedirectTo = "../anonymous/";
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
