<%@ page
	language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="java.util.*"
	import="net.danisoft.dslib.*"
%>
<%!
	private static final String PAGE_Title = "LOG Viewer";
	private static final String PAGE_Keywords = "";
	private static final String PAGE_Description = "";

	private static final  String SESSION_LOG_SOURCEAPP = "AUTH_Session_LOG_SourceApp";
	private static final  String SESSION_LOG_FIRSTDATE = "AUTH_Session_LOG_FirstDate";
	private static final  String SESSION_LOG_LAST_DATE = "AUTH_Session_LOG_Last_Date";
	private static final  String SESSION_LOG_SEARCHTXT = "AUTH_Session_LOG_SearchTxt";
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

	<div class="DS-padding-updn-8px">
		<table class="TableSpacing_0px DS-full-width">
			<tr>
				<td class="DS-padding-0px" align="left">
					<div class="DS-text-title-shadow"><%= PAGE_Title %></div>
				</td>
				<td class="DS-padding-0px" align="right">
					<%= MdcTool.Button.TextIconOutlined(
						"refresh",
						"&nbsp;Reset Filters",
						null,
						"onClick=\"window.location.href='?Action=ResetFilters'\"",
						"Reset all filters"
					) %>
				</td>
			</tr>
		</table>
	</div>
<%
	String RedirectTo = "";

	Database DB = new Database();
	LogTool LOG = new LogTool(DB.getConnection());
	MsgTool MSG = new MsgTool(session);

	String LOG_SourceApp;
	String LOG_FirstDate;
	String LOG_Last_Date;
	String LOG_SearchTxt;

	// Store params in session

	LOG_SourceApp = EnvTool.getStr(request, "LOG_SourceApp", "");
	LOG_FirstDate = EnvTool.getStr(request, "LOG_FirstDate", "");
	LOG_Last_Date = EnvTool.getStr(request, "LOG_Last_Date", "");
	LOG_SearchTxt = EnvTool.getStr(request, "LOG_SearchTxt", "");

	if (!LOG_SourceApp.equals(""))
		session.setAttribute(SESSION_LOG_SOURCEAPP, LOG_SourceApp);

	if (!LOG_FirstDate.equals(""))
		session.setAttribute(SESSION_LOG_FIRSTDATE, LOG_FirstDate);

	if (!LOG_Last_Date.equals(""))
		session.setAttribute(SESSION_LOG_LAST_DATE, LOG_Last_Date);

	if (!LOG_SearchTxt.equals(""))
		session.setAttribute(SESSION_LOG_SEARCHTXT, LOG_SearchTxt);

	// Read params from session

	LOG_SourceApp = EnvTool.getStr(session, SESSION_LOG_SOURCEAPP, "");
	LOG_FirstDate = EnvTool.getStr(session, SESSION_LOG_FIRSTDATE, FmtTool.fmtDate(LOG.getLastDate()));
	LOG_Last_Date = EnvTool.getStr(session, SESSION_LOG_LAST_DATE, FmtTool.fmtDate(LOG.getLastDate()));
	LOG_SearchTxt = EnvTool.getStr(session, SESSION_LOG_SEARCHTXT, "");

	//
	// Start HERE
	//

	try {

		String Action = EnvTool.getStr(request, "Action", "");

		if (Action.equals("")) {

			////////////////////////////////////////////////////////////////////////////////
			//
			// Filter Section
			//
%>
			<div class="DS-padding-updn-8px">
				<div class="DS-text-huge">Filter Parameters</div>
			</div>

			<div class="DS-padding-updn-8px">
				<div class="mdc-layout-grid__inner">
			
				<div class="<%= MdcTool.Layout.Cell(3, 2, 4) %>">
					<form>
						<%= MdcTool.Select.Box(
							"LOG_SourceApp",
							MdcTool.Select.Width.FULL,
							"Source APP",
							"<option value=\"\"></option>" + LOG.getAppCombo(LOG_SourceApp),
							"onChange=\"submit();\""
						) %>
					</form>
				</div>

				<div class="<%= MdcTool.Layout.Cell(2, 2, 4) %>" align="center">
					<form>
						<%= MdcTool.Text.Box(
							"LOG_FirstDate",
							LOG_FirstDate,
							MdcTool.Text.Type.TEXT,
							MdcTool.Text.Width.FULL,
							"Start Date",
							"onChange=\"submit();\""
						) %>
					</form>
				</div>

				<div class="<%= MdcTool.Layout.Cell(2, 2, 4) %>" align="center">
					<form>
						<%= MdcTool.Text.Box(
							"LOG_Last_Date",
							LOG_Last_Date,
							MdcTool.Text.Type.TEXT,
							MdcTool.Text.Width.FULL,
							"End Date",
							"onChange=\"submit();\""
						) %>
					</form>
				</div>

				<div class="<%= MdcTool.Layout.Cell(5, 2, 4) %>">
					<form>
						<%= MdcTool.Text.Box(
							"LOG_SearchTxt",
							LOG_SearchTxt,
							MdcTool.Text.Type.TEXT,
							MdcTool.Text.Width.FULL,
							"Search Text in User and Data",
							"onChange=\"submit();\""
						) %>
					</form>
				</div>

				</div>
			</div>

			<div class="DS-padding-updn-8px">
				<div class="DS-text-huge">Results</div>
			</div>

			<div class="DS-padding-updn-8px">
<%
			////////////////////////////////////////////////////////////////////////////////
			//
			// Show Data
			//
%>
			<table class="TableSpacing_0px DS-full-width">
				<tr class="DS-back-gray DS-border-updn">
					<td class="DS-padding-4px DS-border-lfrg" nowrap align="center">Date / Time</td>
					<td class="DS-padding-4px DS-border-rg" nowrap align="center" ColSpan="5" nowrap>App / Severity / Category</td>
					<td class="DS-padding-4px DS-border-rg" nowrap>IP Address</td>
					<td class="DS-padding-4px DS-border-rg" nowrap>User</td>
					<td class="DS-padding-4px DS-border-rg" nowrap>Data</td>
				</tr>
<%
			String Where = "LOG_Timestamp BETWEEN '" + FmtTool.fmtDateSqlStyle(FmtTool.scnDate(LOG_FirstDate)) + " 00:00:00' AND '" + FmtTool.fmtDateSqlStyle(FmtTool.scnDate(LOG_Last_Date)) + " 23:59:59'";

			if (!LOG_SourceApp.equals(""))
				Where += " AND LOG_SourceApp = '" + LOG_SourceApp + "'";

			if (!LOG_SearchTxt.equals(""))
				Where += " AND (LOG_SourceUser LIKE '%" + LOG_SearchTxt + "%' OR LOG_TextData LIKE '%" + LOG_SearchTxt + "%')";

			Vector<LogTool.Data> vecLogObj = LOG.getAll(Where);

			for (LogTool.Data logData : vecLogObj) {
%>
				<tr class="DS-text-compact DS-border-dn" style="background-color: <%= logData.getSeverity().getColor() %>">
					<td class="DS-padding-4px DS-border-lfrg" valign="top" align="center" nowrap><%= FmtTool.fmtDateTime(logData.getTimestamp()) %></td>
					<td class="DS-padding-4px" valign="top" align="right"><%= logData.getSourceApp().getName() %></td>
					<td class="DS-padding-4px" valign="top" align="center">/</td>
					<td class="DS-padding-4px" valign="top" align="center"><%= logData.getSeverity().toString() %></td>
					<td class="DS-padding-4px" valign="top" align="center">/</td>
					<td class="DS-padding-4px DS-border-rg" valign="top" align="left"><%= logData.getCategory().getCode() %></td>
					<td class="DS-padding-4px DS-border-rg" valign="top"><%= logData.getSourceIP() %></td>
					<td class="DS-padding-4px DS-border-rg" valign="top"><%= logData.getSourceUser() %></td>
					<td class="DS-padding-4px DS-border-rg" valign="top"><%= logData.getTextData() %></td>
				</tr>
<%
			}
%>
			</table>
			</div>
<%
		} else if (Action.equals("ResetFilters")) {

			////////////////////////////////////////////////////////////////////////////////
			//
			// RESET FILTERS
			//

			session.removeAttribute(SESSION_LOG_SOURCEAPP);
			session.removeAttribute(SESSION_LOG_FIRSTDATE);
			session.removeAttribute(SESSION_LOG_LAST_DATE);
			session.removeAttribute(SESSION_LOG_SEARCHTXT);

			RedirectTo = "?";

		} else {

			////////////////////////////////////////////////////////////////////////////////
			//
			// UNKNOWN ACTION
			//

			throw new Exception("Unknown Action: '" + Action + "'");
		}

	} catch (Exception e) {
		
		MSG.setAlertText("Internal Error", e.toString());
		RedirectTo = "../admin/";
	}
%>
	<div class="DS-padding-updn-8px">
		<%= MdcTool.Button.BackTextIcon("Back", "../admin/") %>
	</div>
<%
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
