<%@ page
	language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="org.json.*"
	import="net.danisoft.dslib.*"
%>
<%!
	private static final String SYSOP_SLACKID = "U03AA2A45"; // fmondini
%>
<%
	String TestResult = "";

	String SlackID = EnvTool.getStr(request, "id", "");

	try {

		if (!SlackMsg.isSlackIdValid(SlackID))
			throw new Exception("A SlackID must start with letter \"U\"");

		SlackMsg SLM = new SlackMsg();
		JSONArray jaBlocks = new JSONArray();

		jaBlocks.put(SLM.DM_BlockCreate_HEAD("Waze.Tools -> Slack Connection Test"));

		jaBlocks.put(SLM.DM_BlockCreate_SECTION(
			"*Good News!*\n" +
			"\n" +
			"The connection between Waze.Tools and Slack is operational.\n" +
			"All enabled apps will contact you here on Slack.",
			"https://www.waze.tools/images/suite_logo.png",
			"Waze.Tools Logo"
		));

		jaBlocks.put(SLM.DM_BlockCreate_DIVIDER());

		jaBlocks.put(SLM.DM_BlockCreate_SECTION(
			"_This message was sent to you by a stupid bot._\n" +
			"_For more info on this service contact Waze.Tools SysOp_\n" +
			"_via Slack at <@" + SYSOP_SLACKID + "> or via e-Mail at dev@waze.tools_"
		));

		JSONObject jResult = SLM.DirectMessage(SlackID, jaBlocks);
		
		if (jResult.getInt("rc") != HttpServletResponse.SC_OK)
			throw new Exception(jResult.getString("error"));

		TestResult = "<p class=\"DS-text-green\">SlackID Test: <b>Direct Message Sent</b></p>";

	} catch (Exception e) {

		TestResult =
			"<div class=\"DS-text-exception\">" +
				"<p class=\"DS-text-bold\">SlackID Test Error</p>" +
				"<p class=\"DS-text-fixed\">" + e.getMessage() + "</p>" +
			"</div>";
	}
%>
	<div>
		<div class="DS-card-body">
			<div class="DS-text-fixed"><%= TestResult %></div>
		</div>
	</div>
