<%@ page
	language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="java.util.*"
	import="net.danisoft.dslib.*"
	import="net.danisoft.wtlib.auth.*"
	import="net.danisoft.wazetools.*"
%>
<%!
	private static final String PAGE_Title = "Recover a forgotten password";
	private static final String PAGE_Keywords = "Access, Recover, Credentials, Password";
	private static final String PAGE_Description = "Recover a forgotten password";
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
<%
	String RedirectTo = "";

	String reqMail = EnvTool.getStr(request, "reqMail", "");

	if (reqMail.equals("")) {

		////////////////////////////////////////////////////////////////////////////////////////////////////
		//
		// Ask e-Mail
		//
%>
		<form>

			<div class="DS-padding-updn-8px">
				<div class="DS-text-title-shadow"><%= PAGE_Title %></div>
			</div>

			<div class="DS-padding-updn-8px" align="center">
				<div>Enter your e-Mail address and we'll send you your access tokens</div>
			</div>

			<div class="DS-padding-updn-8px" align="center">
				<%= MdcTool.Text.Box(
					"reqMail",
					"",
					MdcTool.Text.Type.TEXT,
					MdcTool.Text.Width.NORM,
					"Your e-Mail Address",
					"size=\"48\""
				) %>
			</div>

			<div class="DS-padding-updn-8px">
				<table class="TableSpacing_0px DS-full-width">
					<tr>
						<td class="CellPadding_0px" align="left">
							<%= MdcTool.Button.BackTextIcon("Back", "../anonymous/") %>
						</td>
						<td class="CellPadding_0px" align="right">
							<%= MdcTool.Button.SubmitTextIconClass("mail", "&nbsp;Send", null, "DS-text-lime", null, "Sand e-Mail") %>
						</td>
					</tr>
				</table>
			</div>

		</form>

		<script>
			$('#reqMail').focus();
		</script>
<%
	} else {

		////////////////////////////////////////////////////////////////////////////////////////////////////
		//
		// Send e-Mail
		//
%>
		<div class="DS-padding-updn-8px" align="center">
			<div class="DS-text-subtitle">Sending e-Mail to <b><%= reqMail %></b> - Please wait...</div>
		</div>
<%
		Database DB = new Database();
		MsgTool MSG = new MsgTool(session);
		User USR = new User(DB.getConnection());
		LogTool LOG = new LogTool(DB.getConnection());

		int credCount = 0;
		Vector<String> vecLines = new Vector<>();

		Vector<User.Data> vecUsrData = USR.getAllByMail(reqMail);

		try {

			for (User.Data usrData : vecUsrData) {
				vecLines.add("<tt>Account #" + (credCount+1) + " - Username: <b>" + usrData.getName() + "</b> - Password: <b>" + usrData.getPass() + "</b></tt><br>");
				credCount++;
			}

			vecLines.add("<p>Total found: <b>" + credCount + "</b> accounts.</p>");

			if (credCount > 0) {

				Mail MAIL = new Mail(request);
				
				MAIL.setRecipient(reqMail);
				MAIL.setSubject("Access credentials for " + AppCfg.getAppName());
				MAIL.setHtmlTitle("Your Waze.Tools access credentials for " + reqMail);

				for (int i=0; i<vecLines.size(); i++)
					MAIL.addHtmlBody(vecLines.get(i));

				if (MAIL.Send()) {
					MSG.setSnackText("Mail sent to " + MAIL.getRecipient());
					LOG.Info(request, LogTool.Category.MAIL, "Mail sent to '" + MAIL.getRecipient() + "' with subject '" + MAIL.getSubject() + "'");
				} else {
					MSG.setSlideText("Mail Error", MAIL.getLastError());
					LOG.Error(request, LogTool.Category.MAIL, "Error sending mail to '" + MAIL.getRecipient() + "' with subject '" + MAIL.getSubject() + "': " + MAIL.getLastError());
				}

			} else {

				MSG.setAlertText("No credentials found", "Sorry, the mail address <b>" + reqMail + "</b> was NOT found in our database.");
			}

		} catch (Exception e) {

			MSG.setAlertText("Internal Error", e.toString());
		}

		RedirectTo = "../anonymous/";

		DB.destroy();
	}
%>
	</div>
	</div>
	</div>

	<jsp:include page="../_common/footer.jsp">
		<jsp:param name="RedirectTo" value="<%= RedirectTo %>"/>
	</jsp:include>

</body>
</html>
