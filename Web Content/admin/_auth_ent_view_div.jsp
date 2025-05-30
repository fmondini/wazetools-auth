<%@ page
	language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="java.util.*"
	import="net.danisoft.dslib.*"
	import="net.danisoft.wtlib.auth.*"
	import="net.danisoft.wazetools.auth.*"
%>
	<table class="TableSpacing_0px">
<%
	Database DB = null;
	
	try {

		DB = new Database();
		User USR = new User(DB.getConnection());
		GeoIso GEO = new GeoIso(DB.getConnection());
		Hierarchy AHI = new Hierarchy(DB.getConnection());

		String reqUser = EnvTool.getStr(request, "reqUser", "");

		boolean firstElem;
		boolean atLeastOne = false;
		Vector<Hierarchy.Data> vecAhiData;

		User.Data usrData = USR.Read(reqUser);

		for (HierRole X : HierRole.values()) {

			firstElem = true;

			vecAhiData = AHI.getAllByRole(usrData.getName(), X);

			for (Hierarchy.Data ahiData : vecAhiData) {
%>
				<tr class="<%= firstElem ? "DS-border-up" : "" %>">
					<td class="DS-padding-lfrg-4px DS-padding-updn-2px DS-text-bold"><%= firstElem ? X.getDesc() : "&nbsp;" %></td>
					<td class="DS-padding-lfrg-4px DS-padding-top-4px">
						<div class=""><%= GEO.getFlag24x18byIso3(ahiData.getGeoRef()) %></div>
					</td>
					<td class="DS-padding-lfrg-4px DS-padding-updn-0px">
						<table class="TableSpacing_0px DS-full-width">
							<tr>
								<td class="DS-padding-lfrg-4px DS-padding-updn-2px"><%= GEO.getFullDesc(ahiData.getGeoRef()) %></td>
								<td class="DS-padding-lfrg-4px DS-padding-updn-2px" style="width: var(--font-size);" align="right">
									<div class="DS-padding-top-4px">
										<span class="DS-padding-top-4px DS-cursor-help" title="<%= "Active since " + FmtTool.fmtDate(ahiData.getSince()) + " - Last Update: " + FmtTool.fmtDateTime(ahiData.getLastUpdate()) + " by " + ahiData.getLastUpdatedBy() %>">
											<%= IcoTool.Symbol.RndExtn("help", false, "20px", "LightSlateGrey", "", "") %>
										</span>
									</div>
								</td>
								<td class="DS-padding-lfrg-4px DS-padding-updn-2px" style="width: var(--font-size);" align="right">
									<div class="DS-padding-top-4px">
										<span class="DS-cursor-pointer" title="Delete <%= X.getDesc() %> for <%= ahiData.getLocation() %>"
											onClick="DeleteEntitlement('<%= usrData.getName() %>', '<%= X.getCode() %>', '<%= X.getDesc() %>', '<%= ahiData.getGeoRef() %>');">
											<%= IcoTool.Symbol.RndExtn("cancel", true, "20px", "Crimson", "", "") %>
										</span>
									</div>
								</td>
							</tr>
						</table>
					</td>
				</tr>
<%
				atLeastOne = true;
				firstElem = false;
			}
		}

		if (!atLeastOne) {
%>
			<tr class="DS-border-updn">
				<td class="CellPadding_9px" ColSpan="3" align="center">
					<div class="DS-text-exception DS-text-italic">This user does not have any entitlements</div>
				</td>
			</tr>
<%
		}
%>
		<tr>
			<td class="DS-padding-top-16px DS-padding-bottom-16px DS-border-up" ColSpan="3">
				<%= MdcTool.Button.TextIconOutlinedClass(
					"add_circle",
					"&nbsp;Add New Entitlement",
					null,
					"DS-text-green",
					"DS-text-green",
					"onClick=\"window.location.href=encodeURI('?Action=newent_step1&reqUser=" + usrData.getName() + "');\"",
					"Add a new entitlement to " + usrData.getName() + " account"
				) %>
			</td>
		</tr>
<%
	} catch (Exception e) {
		out.println(e.toString());
	}

	if (DB != null)
		DB.destroy();
%>
	</table>
