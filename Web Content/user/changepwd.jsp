<%@ page
	language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="net.danisoft.dslib.*"
	import="net.danisoft.wtlib.auth.*"
%>
<%!
	private static final String PAGE_Title = "Change your password";
	private static final String PAGE_Keywords = "Change, Password";
	private static final String PAGE_Description = "Utility to change your password";
%>
<!DOCTYPE html>
<html>
<head>
	<jsp:include page="../_common/head.jsp">
		<jsp:param name="PAGE_Title" value="<%= PAGE_Title %>"/>
		<jsp:param name="PAGE_Keywords" value="<%= PAGE_Keywords %>"/>
		<jsp:param name="PAGE_Description" value="<%= PAGE_Description %>"/>
	</jsp:include>
</head>

<body>

	<jsp:include page="../_common/header.jsp" />

	<div class="mdc-layout-grid DS-layout-body">
	<div class="mdc-layout-grid__inner">
	<div class="<%= MdcTool.Layout.Cell(12, 8, 4) %>">

	<div class="DS-card-body">
		<div class="DS-text-title-shadow"><%= PAGE_Title %></div>
	</div>
<%
	Database DB = new Database();
	MsgTool MSG = new MsgTool(session);
	LogTool LOG = new LogTool(DB.getConnection());

	String RedirectTo = "";
	String Action = EnvTool.getStr(request, "Action", "");
	String txtOldPwd = EnvTool.getStr(request, "txtOldPwd", "");
	String txtNewPwd = EnvTool.getStr(request, "txtNewPwd", "");
	String txtVerPwd = EnvTool.getStr(request, "txtVerPwd", "");

	try {

		if (Action.equals("")) {

			////////////////////////////////////////////////////////////////////////////////////////////////////
			//
			// Ask new password
			//
%>
			<form>

				<input type="hidden" name="Action" value="update">

				<div class="mdc-layout-grid__inner">

					<div class="<%= MdcTool.Layout.Cell(4, 2, 4) %>"></div>

					<div class="<%= MdcTool.Layout.Cell(4, 4, 4) %>">

						<div class="DS-card-head">
							<%= MdcTool.Text.Box(
								"txtOldPwd",
								"",
								MdcTool.Text.Type.PASS,
								MdcTool.Text.Width.FULL,
								"Enter your current password",
								"maxlength=\"32\""
							) %>
						</div>

						<div class="DS-card-body">
							<%= MdcTool.Text.Box(
								"txtNewPwd",
								"",
								MdcTool.Text.Type.PASS,
								MdcTool.Text.Width.FULL,
								"Type the desired new password (8 chars min)",
								"maxlength=\"32\""
							) %>
						</div>

						<div class="DS-card-foot">
							<%= MdcTool.Text.Box(
								"txtVerPwd",
								"",
								MdcTool.Text.Type.PASS,
								MdcTool.Text.Width.FULL,
								"Retype the new password (for verification)",
								"maxlength=\"32\""
							) %>
						</div>

					</div>

					<div class="<%= MdcTool.Layout.Cell(4, 2, 4) %>"></div>

				</div>

				<div class="mdc-layout-grid__inner">
					<div class="<%= MdcTool.Layout.Cell(2, 2, 4) %> DS-grid-middle-left">
						<div class="DS-card-foot">
							<%= MdcTool.Button.BackTextIcon("Back", "../user/") %>
						</div>
					</div>
					<div class="<%= MdcTool.Layout.Cell(8, 4, 4) %> DS-grid-middle-center">
						<div class="DS-card-foot DS-text-italic DS-text-FireBrick" align="center">
							Please note that the new password will be used for all applications in the Waze.Tools suite
						</div>
					</div>
					<div class="<%= MdcTool.Layout.Cell(2, 2, 4) %> DS-grid-middle-right">
						<div class="DS-card-foot">
							<%= MdcTool.Button.SubmitTextIconClass("save", "&nbsp;Save", null, "DS-text-lime", null, null) %>
						</div>
					</div>
				</div>

			</form>

			<script>
				$('#txtOldPwd').focus();
			</script>
<%
		} else if (Action.equals("update")) {

			////////////////////////////////////////////////////////////////////////////////////////////////////
			//
			// Check and update new password
			//

			User USR = new User(DB.getConnection());
			User.Data usrData = USR.Read(SysTool.getCurrentUser(request));

			if (txtOldPwd.equals(usrData.getPass())) {

				if (txtNewPwd.equals(txtVerPwd)) {

					if (txtNewPwd.length() >= 8) {

						usrData.setPass(txtNewPwd);
						USR.Update(SysTool.getCurrentUser(request), usrData);

						MSG.setSnackText("Password changed!");

						// Notify user

						Mail MAIL = new Mail(request);

						MAIL.setRecipient(usrData.getMail());
						MAIL.setSubject("Your Waze.Tools password has changed");
						MAIL.setHtmlTitle("Waze.Tools password changes have been detected");
						MAIL.addHtmlBody("<p>Hello, Wazer!</p>");
						MAIL.addHtmlBody("<p>I am sending you this email because your Waze.Tools password has just been changed.</p>");
						MAIL.addHtmlBody("<p>The change operation was triggered at <b>" + FmtTool.fmtDateTime() + "</b> by a request from IP address <b>" + FmtTool.getWhoisLink(request.getRemoteAddr()) + "</b></p>");
						MAIL.addHtmlBody("<p>If you did not initiate this change, please contact us immediately at dev@waze.tools</p>");

						if (MAIL.Send()) {
							MSG.setSnackText("Mail sent to " + MAIL.getRecipient());
							LOG.Info(request, LogTool.Category.MAIL, "Mail sent to '" + MAIL.getRecipient() + "' with subject '" + MAIL.getSubject() + "'");
						} else {
							MSG.setSlideText("Mail Error", MAIL.getLastError());
							LOG.Error(request, LogTool.Category.MAIL, "Error sending mail to '" + MAIL.getRecipient() + "' with subject '" + MAIL.getSubject() + "': " + MAIL.getLastError());
						}

						RedirectTo = "../user/";

					} else {
						MSG.setSlideText("Error changing password", "Your new password is too short");
						RedirectTo = "?";
					}

				} else {
					MSG.setSlideText("Error changing password", "Your new password is incorrect or badly rewritten");
					RedirectTo = "?";
				}

			} else {
				MSG.setSlideText("Error changing password", "Your current password is incorrect");
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
	</div>
	</div>

	<jsp:include page="../_common/footer.jsp">
		<jsp:param name="RedirectTo" value="<%= RedirectTo %>"/>
	</jsp:include>

</body>
</html>
