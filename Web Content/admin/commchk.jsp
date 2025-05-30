<%@ page
	language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="java.util.*"
	import="net.danisoft.dslib.*"
	import="net.danisoft.wtlib.auth.*"
%>
<%!
	private static final String PAGE_Title = "Comms Methods Check";
	private static final String PAGE_Keywords = "";
	private static final String PAGE_Description = "";

	private static String getHtmlTable(String Title, GeoIso GEO, Vector<User.Data> vecUsrData) throws Exception {

		String Result = "";
		String MailAdd = "";
		String SlackID = "";

		Title = Title
			.replace("GOOD", "<span class=\"DS-text-DarkGreen DS-text-bold\">GOOD</span>")
			.replace("BAD", "<span class=\"DS-text-FireBrick DS-text-bold\">BAD</span>")
		;

		Result += "<div class=\"DS-padding-updn-8px DS-text-huge DS-text-black\">" + Title + "</div>";

		Result += "<table class=\"TableSpacing_0px\">";
		Result += "<tr class=\"DS-back-gray DS-border-updn\">";
		Result += "<td class=\"DS-padding-4px DS-border-lfrg\" ColSpan=\"2\">Nickname</td>";
		Result += "<td class=\"DS-padding-4px DS-border-rg\">e-Mail</td>";
		Result += "<td class=\"DS-padding-4px DS-border-rg\" align=\"center\">SlackID</td>";
		Result += "</tr>";

		if (vecUsrData.size() > 0) {

			for (User.Data usrData : vecUsrData) {

				MailAdd = "<div class=\"DS-text-" + (Mail.isAddressValid(usrData.getMail()) ? "DarkGreen" : "FireBrick") + "\">" + usrData.getMail() + "</div>";
				SlackID = "<div class=\"DS-text-" + (SlackMsg.isSlackIdValid(usrData.getSlackID()) ? "DarkGreen" : "FireBrick") + "\">" + usrData.getSlackID() + "</div>";

				Result += "<tr class=\"DS-border-updn\">";
				Result += "<td class=\"DS-padding-lfrg-4px DS-padding-top-4px DS-border-lf\" title=\"" + GEO.getDesc(usrData.getCountry()) + "\" align=\"right\">" + GEO.getFlag24x18byIso3(usrData.getCountry()) + "</td>";
				Result += "<td class=\"DS-padding-4px DS-border-rg\"><a href=\"users.jsp?Action=edit&reqUser=" + usrData.getName() + "\" target=\"_blank\">" + usrData.getName() + "</a></td>";
				Result += "<td class=\"DS-padding-4px DS-border-rg\">" + MailAdd + "</td>";
				Result += "<td class=\"DS-padding-4px DS-border-rg DS-text-fixed-compact\" align=\"center\">" + SlackID + "</td>";
				Result += "</tr>";
			}

		} else {

			Result += "<tr class=\"DS-border-updn\">";
			Result += "<td class=\"DS-padding-4px DS-border-lfrg\" ColSpan=\"4\">No users found</td>";
			Result += "</tr>";
		}

		Result += "</table>";
		Result += "<div class=\"DS-padding-bottom-32px\"></div>";

		return(Result);
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
</head>

<body>

	<jsp:include page="../_common/header.jsp" />

	<div class="mdc-layout-grid DS-layout-body">
	<div class="mdc-layout-grid__inner">
	<div class="<%= MdcTool.Layout.Cell(12, 8, 4) %>">

	<div class="DS-card-body">
		<div class="DS-text-title-shadow"><%= PAGE_Title %></div>
	</div>
	
	<div class="DS-card-body">
<%
	String RedirectTo = "";

	Database DB = new Database();
	MsgTool MSG = new MsgTool(session);
	User USR = new User(DB.getConnection());
	GeoIso GEO = new GeoIso(DB.getConnection());
	
	try {

		User.Data currUsrData = USR.Read(SysTool.getCurrentUser(request));

		Vector<User.Data> vecTmpData = new Vector<User.Data>();
		Vector<User.Data> vecUsrData = new Vector<User.Data>();

		//
		// Get all users in all enabled countries 
		//

		Vector<String> vecCountries = currUsrData.getWazerConfig().getAuth().getActiveCountryCodes();

		for (String enabledCountry : vecCountries) {

			vecTmpData = USR.getAllByCountry(enabledCountry);

			for (User.Data usrTmpData : vecTmpData)
				vecUsrData.add(usrTmpData);
		}

		Vector<User.Data> vecTblData = new Vector<User.Data>();

		//
		// e-Mail OK AND SlackID OK 
		//

		vecTblData.clear();

		for (User.Data usrData : vecUsrData)
			if (Mail.isAddressValid(usrData.getMail()) && SlackMsg.isSlackIdValid(usrData.getSlackID()))
				vecTblData.add(usrData);

		out.println(getHtmlTable("<b>" + vecTblData.size() + "</b> User(s) with GOOD email address and GOOD slackid", GEO, vecTblData));

		//
		// e-mail OK AND SlackID KO 
		//

		vecTblData.clear();

		for (User.Data usrData : vecUsrData)
			if (Mail.isAddressValid(usrData.getMail()) && !SlackMsg.isSlackIdValid(usrData.getSlackID()))
				vecTblData.add(usrData);

		out.println(getHtmlTable("<b>" + vecTblData.size() + "</b> User(s) with GOOD email address and BAD slackid", GEO, vecTblData));

		//
		// e-mail KO AND SlackID OK 
		//

		vecTblData.clear();

		for (User.Data usrData : vecUsrData)
			if (!Mail.isAddressValid(usrData.getMail()) && SlackMsg.isSlackIdValid(usrData.getSlackID()))
				vecTblData.add(usrData);

		out.println(getHtmlTable("<b>" + vecTblData.size() + "</b> User(s) with BAD email address and GOOD slackid", GEO, vecTblData));

		//
		// e-mail KO AND SlackID KO 
		//

		vecTblData.clear();

		for (User.Data usrData : vecUsrData)
			if (!Mail.isAddressValid(usrData.getMail()) && !SlackMsg.isSlackIdValid(usrData.getSlackID()))
				vecTblData.add(usrData);

		out.println(getHtmlTable("<b>" + vecTblData.size() + "</b> User(s) with BAD email address and BAD slackid", GEO, vecTblData));
%>
	</div>
<%
	} catch (Exception e) {
		
		MSG.setAlertText("Internal Error", e.toString());
		RedirectTo = "../admin/";
	}
%>
	<div class="DS-card-foot">
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
