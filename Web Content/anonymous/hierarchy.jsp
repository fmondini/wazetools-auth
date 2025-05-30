<%@ page
	language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="java.util.*"
	import="net.danisoft.dslib.*"
	import="net.danisoft.wtlib.auth.*"
	import="net.danisoft.wazetools.auth.*"
%>
<%!
	private static final String PAGE_Title = "Waze Hierarchy";
	private static final String PAGE_Keywords = "Hierarchy";
	private static final String PAGE_Description = "Manage Waze Hierarchy";

	String GetTableHeader(String ViewType) {

		String firstTwoCols =
			ViewType.equals("H")
				?	"<td class=\"DS-padding-4px DS-border-lfrg\" nowrap>NickName</td>" +
					"<td class=\"DS-padding-4px DS-border-rg\" nowrap>Location</td>"
				:	"<td class=\"DS-padding-4px DS-border-lfrg\" nowrap>Location</td>" +
					"<td class=\"DS-padding-4px DS-border-rg\" nowrap>NickName</td>"
		;

		return(
			"<tr class=\"DS-back-gray DS-border-updn\">" +
				firstTwoCols +
				"<td class=\"DS-padding-4px DS-border-lfrg\" nowrap>Real Name</td>" +
				"<td class=\"DS-padding-4px DS-border-rg\" nowrap>e-Mail</td>" +
				"<td class=\"DS-padding-4px DS-border-rg\" nowrap>Phone</td>" +
				"<td class=\"DS-padding-4px DS-border-rg\" nowrap align=\"center\">Slack ID</td>" +
				"<td class=\"DS-padding-4px DS-border-rg\" nowrap align=\"center\">In charge since</td>" +
			"</tr>"
		);
	}

	String GetTableData(Hierarchy.Data ahiObject, String ViewType, boolean isAdmin, HttpServletRequest request) throws Exception {

		String NickName =
			(isAdmin ? "<a href=\"../admin/users.jsp?Action=edit&reqUser=" + ahiObject.getNickName() + "\" target=\"_blank\">" : "") +
			"<span class=\"DS-text-black\">" + ahiObject.getNickName() + "</span>" +
			(isAdmin ? "</a>" : "")
		;

		String firstTwoCols =
			ViewType.equals("H")
				?	"<td class=\"DS-padding-4px DS-border-lfrg\">" + NickName + "<span class=\"DS-text-italic DS-text-disabled\">(" + ahiObject.getRank() + ")</span></td>" +
					"<td class=\"DS-padding-4px DS-border-rg\">" + ahiObject.getLocation() + "</td>"
				:	"<td class=\"DS-padding-4px DS-border-lfrg\"><b>" + ahiObject.getLocation() + "</b></td>" +
					"<td class=\"DS-padding-4px DS-border-rg\">" + NickName + "<span class=\"DS-text-italic DS-text-disabled\">(" + ahiObject.getRank() + ")</span></td>"
		;

		return(
			"<tr class=\"DS-border-dn\" style=\"background-color: " + (ahiObject.getNickName().equals(SysTool.getCurrentUser(request)) ? "#ffffe0" : "#ffffff") + "\">" +
				firstTwoCols +
				"<td class=\"DS-padding-4px DS-border-lfrg\">" + (isAdmin ? (ahiObject.getLastName() + ", " + ahiObject.getFirstname()) : "<span class=\"DS-text-disabled DS-text-italic\">hidden</span>") + "</td>" +
				"<td class=\"DS-padding-4px DS-border-rg\">" + (isAdmin ? ("<a href=\"mailto:" + ahiObject.getMail() + "\">" + ahiObject.getMail() + "</a>") : "<span class=\"DS-text-disabled DS-text-italic\">hidden</span>") + "</td>" +
				"<td class=\"DS-padding-4px DS-border-rg\">" + (isAdmin ? ("<a href=\"tel:" + ahiObject.getPhone() + "\">" + ahiObject.getPhone() + "</a>") : "<span class=\"DS-text-disabled DS-text-italic\">hidden</span>") + "</td>" +
				"<td class=\"DS-padding-4px DS-border-rg\" align=\"center\">" + (isAdmin ? ("<span class=\"DS-text-fixed-compact\">" + ahiObject.getSlackID() + "</span>") : "<span class=\"DS-text-disabled DS-text-italic\">hidden</span>") + "</td>" +
				"<td class=\"DS-padding-4px DS-border-rg\" align=\"center\">" + (ahiObject.getSince().equals(FmtTool.DATEZERO) ? "<span class=\"DS-text-disabled DS-text-italic\">NO DATE</span>" : FmtTool.fmtDate(ahiObject.getSince())) + "</td>" +
			"</tr>"
		);
	}

	String GetNoDataTR(String msg) {
		return(
			"<tr class=\"DS-border-dn\">" +
				"<td class=\"DS-padding-8px DS-border-lfrg\" align=\"center\" ColSpan=\"7\">" +
					"<div class=\"DS-text-exception\">" + msg + "</div>" +
				"</td>" +
			"</tr>"
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

	<style type="text/css">
		.ui-state-default { background-color: #e0e0e0; background-image: none; }
		.ui-accordion-header-collapsed { background-color: #f7f7f7; }
	</style>

	<script>
		$(function() {
			$('#headHierarchy').accordion({
				icons: false,
				heightStyle: 'content'
			});
		});
		$(function() {
			$('#headLocation').accordion({
				icons: false,
				heightStyle: 'content'
			});
		});
		$(document).ready(
			function() {
				$('#headHierarchy').show();
				$('#headLocation').show();
			}
		);
	</script>

</head>

<body>
<%
	Database DB = new Database();
	
	TomcatRole TCR = new TomcatRole(DB.getConnection());
	Hierarchy AHI = new Hierarchy(DB.getConnection());
	GeoIso GEO = new GeoIso(DB.getConnection());

	String actCountry = EnvTool.getStr(request, "actCountry", "ITA");
	String SortBy = EnvTool.getStr(request, "SortBy", "H"); // Default: by hierarchy

	boolean isAdmin = TCR.haveRoleAUTH(SysTool.getCurrentUser(request), AuthRole.ADMIN);
%>
	<jsp:include page="../_common/header.jsp" />

	<div class="mdc-layout-grid DS-layout-body">
	<div class="mdc-layout-grid__inner">
	<div class="<%= MdcTool.Layout.Cell(12, 8, 4) %>">

	<form>
		<input type="hidden" name="SortBy" value="<%= SortBy %>">
		<div class="mdc-layout-grid__inner">
			<div class="<%= MdcTool.Layout.Cell(8, 6, 4) %> DS-grid-middle-left">
				<div class="DS-padding-updn-8px">
					<div class="DS-padding-0px DS-text-title-shadow"><%= PAGE_Title %> - <%= GEO.getFullDesc(actCountry) %></div>
				</div>
			</div>
			<div class="<%= MdcTool.Layout.Cell(4, 2, 4) %> DS-grid-middle-right">
				<div class="DS-padding-updn-8px">
					<%= MdcTool.Select.Box(
						"actCountry",
						MdcTool.Select.Width.NORM,
						"Select a Country",
						AHI.getPopulatedCountriesCombo(actCountry),
						"onChange=\"submit();\""
					) %>
				</div>
			</div>
		</div>
	</form>
<%
	try {
	
		if (SortBy.equals("H")) {

			////////////////////////////////////////////////////////////////////////////////////////////////////
			//
			// SORT BY HIERARCHY
			//
%>
			<div class="DS-padding-updn-8px">
			<div id="headHierarchy" style="display:none">
<%
			for (HierRole hierarchyRole : HierRole.values()) {

				if (!hierarchyRole.equals(HierRole.UNKNW)) {

					Vector<Hierarchy.Data> vecAhiData = AHI.getAll(hierarchyRole, actCountry);

					if (!vecAhiData.isEmpty()) {
%>
						<h3>
							<span class="DS-text-huge">
								<b><%= hierarchyRole.getCode() %></b>&nbsp;<%= hierarchyRole.getDesc() %>s
								<span id="<%= hierarchyRole.getCode() %>_count" class="DS-text-gray DS-text-small DS-text-italic"></span>
							</span>
						</h3>

						<div>

						<table class="TableSpacing_0px DS-full-width">
<%
						out.println(GetTableHeader("H"));

						for (Hierarchy.Data ahiData : vecAhiData)
							out.println(GetTableData(ahiData, "H", isAdmin, request));
%>
						</table>

						<script>
							$('#<%= hierarchyRole.getCode() %>_count').text('(<%= vecAhiData.size() %>)');
						</script>

					</div>
<%
					}
				}
			}
%>
			</div> <!-- /headHierarchy -->
			</div> <!-- /DS-card-head -->
<%
		} else if (SortBy.equals("L")) {

			////////////////////////////////////////////////////////////////////////////////////////////////////
			//
			// SORT BY LOCATION
			//
%>
			<div class="DS-padding-updn-8px">
			<div id="headLocation" style="display:none">
<%
			Vector<Hierarchy.Data> vecAhiData;

			GeoIso.Data geoCountry = GEO.Read(actCountry);

			String CountryName = geoCountry.getDesc();
			
			//
			// Country
			//

			vecAhiData = AHI.getAll(HierRole.COMGR, geoCountry.getCode());
%>
			<h3>
				<span class="DS-text-huge DS-text-bold DS-text-italic"><%= geoCountry.getDesc() %></span>
			</h3>
			<div id="dataLocation_<%= geoCountry.getCode() %>">
			<table class="TableSpacing_0px DS-full-width">
			<tr>
				<td class="DS-padding-0px" ColSpan="6">
					<div class="DS-padding-updn-8px DS-text-big DS-text-bold">Country Managers</div>
				</td>
			</tr>
<%
			out.println(GetTableHeader("L"));

			if (!vecAhiData.isEmpty()) {
				for (Hierarchy.Data ahiData : vecAhiData)
					out.println(GetTableData(ahiData, "L", isAdmin, request));
			} else
				out.println(GetNoDataTR("NO COUNTRY MANAGERS"));
%>
			</table>
			</div> <!-- /dataLocation_<%= geoCountry.getCode() %> -->
<%
			//
			// States
			//

			Vector<GeoIso.Data> vecStates = GEO.getStates(geoCountry.getCode());

			for (GeoIso.Data geoState : vecStates) {
%>
				<h3>
					<span class="DS-text-big DS-text-italic"><%= CountryName %> :: <b><%= geoState.getDesc() %></b></span>
				</h3>
				<div id="dataCountry_<%= geoState.getCode().replace(":", "_") %>">
				<table class="TableSpacing_0px DS-full-width">
				<tr class="">
					<td class="DS-padding-0px" ColSpan="6">
						<div class="DS-padding-updn-8px DS-text-big DS-text-bold">State Managers</div>
					</td>
				</tr>
<%
				// State Managers

				vecAhiData = AHI.getAll(HierRole.STATM, geoState.getCode());

				out.println(GetTableHeader("L"));

				if (!vecAhiData.isEmpty()) {
					for (Hierarchy.Data ahiData : vecAhiData)
						out.println(GetTableData(ahiData, "L", isAdmin, request));
				} else
					out.println(GetNoDataTR("NO STATE MANAGERS"));
%>
				<tr>
					<td class="DS-padding-0px" ColSpan="6">&nbsp;</td>
				</tr>
<%
				//
				// Districts
				//
%>
				<tr class="">
					<td class="DS-padding-0px" ColSpan="6">
						<div class="DS-card-body DS-text-big DS-text-bold">District Managers</div>
					</td>
				</tr>
<%
				vecAhiData = AHI.getAll(HierRole.DISTM, geoState.getCode());

				out.println(GetTableHeader("L"));

				if (!vecAhiData.isEmpty()) {
					for (Hierarchy.Data ahiData : vecAhiData)
						out.println(GetTableData(ahiData, "L", isAdmin, request));
				} else
					out.println(GetNoDataTR("NO DISTRICT MANAGERS"));
%>
				</table>
				</div> <!-- /dataCountry_<%= geoState.getCode().replace(":", "_") %> -->
<%
			} // agrStates.hasMoreElements()
%>
			</div>
			</div>
<%
		} else
			out.println(GetNoDataTR("SORT ERROR"));
%>
		<div class="DS-padding-updn-8px">
			<div class="mdc-layout-grid__inner">
				<div class="<%= MdcTool.Layout.Cell(6, 4, 2) %>" align="left">
					<%= MdcTool.Button.BackTextIcon("Back", "../anonymous/") %>
				</div>
				<div class="<%= MdcTool.Layout.Cell(6, 4, 2) %>" align="right">
					<%= MdcTool.Button.TextIconClass(
						(SortBy.equals("H") ? "public" : "group"),
						"&nbsp;View by " + (SortBy.equals("H") ? "Location" : "Hierarchy"),
						null,
						"DS-text-lime",
						null,
						"onClick=\"window.location.href='?actCountry=" + actCountry + "&SortBy=" + (SortBy.equals("H") ? "L" : "H") + "'\"",
						null
					) %>
				</div>
			</div>
		</div>
<%
	} catch (Exception e) {

		System.err.println(e.toString());
	}

	DB.destroy();
%>

	</div>
	</div>
	</div>

	<jsp:include page="../_common/footer.jsp" />

</body>
</html>
