<%@ page
	language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="java.util.*"
	import="net.danisoft.dslib.*"
	import="net.danisoft.wtlib.auth.*"
%>
	<table class="TableSpacing_0px">
<%
	Database DB = null;
	
	try {

		DB = new Database();
		User USR = new User(DB.getConnection());
		GeoIso GEO = new GeoIso(DB.getConnection());

		String reqUser = EnvTool.getStr(request, "reqUser", "");

		String countryName;
		User.Data usrData = USR.Read(reqUser);
		Vector<String> vecCountries = usrData.getWazerConfig().getUreq().getActiveCountryCodes();

		for (String usrCountry : vecCountries) {

			countryName = GEO.getFullDesc(usrCountry);
%>
			<tr class="DS-border-updn">
				<td class="DS-padding-lfrg-4px DS-padding-top-4px">
					<div class=""><%= GEO.getFlag24x18byIso3(usrCountry) %></div>
				</td>
				<td class="DS-padding-lfrg-4px DS-padding-updn-2px">
					<div class="DS-text-fixed-reduced DS-text-black">[<b><%= usrCountry %></b>]</div>
				</td>
				<td class="DS-padding-lfrg-4px DS-padding-updn-2px">
					<div class="DS-text-italic"><%= countryName %></div>
				</td>
				<td class="DS-padding-lfrg-4px DS-padding-top-4px DS-padding-bottom-0px" align="right">
					<span class="DS-cursor-pointer" title="Remove <%= countryName %> from <%= reqUser %> unlock rights" onClick="DeleteUreqCountry('<%= reqUser %>', '<%= usrCountry %>')">
						<%= IcoTool.Symbol.RndExtn("cancel", true, "20px", "Crimson", "", "") %>
					</span>
				</td>
			</tr>
<%
		}
%>
		<tr class="DS-border-up">
			<td class="DS-padding-updn-8px DS-cursor-pointer" ColSpan="4">
				<%= MdcTool.Button.TextIconOutlinedClass(
					"add_circle",
					"&nbsp;Add New Country",
					null,
					"DS-text-green",
					"DS-text-compact DS-text-DarkGreen",
					"onClick=\"AddUreqCountry('" + reqUser + "')\"",
					"Add New Country"
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
