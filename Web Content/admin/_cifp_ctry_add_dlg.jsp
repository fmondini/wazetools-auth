<%@ page
	language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="net.danisoft.dslib.*"
	import="net.danisoft.wtlib.auth.*"
%>
<%!
	private static final String SELECT_NAME = "selCifpCountry";
%>
	<script>

		function updateCifpCountry(reqUser) {

			var reqCtry = document.getElementById('<%= SELECT_NAME %>').value;

			if (reqCtry != '') {

				$.ajax({

					async: true,
					cache: false,
					type: 'POST',
					url: '../api/cifp/country/add',
					dataType: 'text',

					data: {
						reqUser: reqUser,
						reqCtry: reqCtry
					},

					success: function(data) {
						if (data.startsWith('OK'))
							ShowCifpCountry(reqUser);
						else
							ShowDialog_Error(data);

					},
					error: function(jqXHR, textStatus, errorThrown) {
						ShowDialog_AJAX(jqXHR.responseText);
					}
				});
			}
		}

	</script>

	<div class="DS-padding-lfrg-8px DS-back-gray DS-border-dn">
		<div class="DS-text-title-shadow">Add CIFP Country</div>
	</div>
<%
	Database DB = null;

	try {

		DB = new Database();
		GeoIso GEO = new GeoIso(DB.getConnection());

		String reqUser = EnvTool.getStr(request, "reqUser", "");
%>
		<div class="DS-padding-8px">
			<select id="<%= SELECT_NAME %>" name="<%= SELECT_NAME %>" class="DS-input-textbox" size="16">
				<%= GEO.getCountryCombo(null) %>
			</select>
		</div>

		<div class="DS-padding-8px DS-back-lightgray DS-border-full">
			<table class="TableSpacing_0px DS-full-width">
				<tr>
					<td class="DS-padding-0px">
						<%= MdcTool.Dialog.BtnDismiss("btnCancel", "Cancel", true, "", "") %>
					</td>
					<td class="DS-padding-0px" align="right">
						<%= MdcTool.Dialog.BtnConfirm(
							"btnConfirm",
							"Add",
							false,
							"onClick=\"updateCifpCountry('" + reqUser + "');\"",
							"Add the selected country"
						) %>
					</td>
				</tr>
			</table>
		</div>

<%
	} catch (Exception e) {
%>
		<div class="DS-padding-8px DS-text-exception DS-back-pastel-red">
			<div class="DS-padding-updn-4px DS-text-big">Internal Error</div>
			<div class="DS-padding-updn-4px"><%= e.toString() %></div>
		</div>
<%
	}

	if (DB != null)
		DB.destroy();
%>
