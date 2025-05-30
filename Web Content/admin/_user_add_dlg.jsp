<%@ page
	language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="net.danisoft.dslib.*"
	import="net.danisoft.wtlib.auth.*"
%>
<%!
	String RemoveBadChar(String str) {

		return(str.replace("'", "\\'").replace("\r", "").replace("\n", "<br>"));
	}
%>
	<div class="DS-padding-lfrg-8px DS-back-gray DS-border-dn">
		<div class="DS-text-title-shadow">Add a new user</div>
	</div>
<%
	Database DB = new Database();
	User USR = new User(DB.getConnection());

	try {

		User.Data usrData = USR.Read(SysTool.getCurrentUser(request));
%>
		<form action="users.jsp">

			<input type="hidden" name="Action" value="create">

			<div class="DS-card-head DS-padding-lfrg-8px">
				<div class="DS-text-large DS-text-black">Enter the nickname of the new user to be created</div>
			</div>
			<div class="DS-card-none DS-padding-lfrg-8px">
				<input class="DS-input-textbox DS-full-width" type="text" id="NewUser" name="NewUser" value="">
			</div>
			<div class="DS-card-foot DS-padding-lfrg-8px DS-border-dn">
				<div class="DS-text-compact DS-text-italic DS-text-gray">If the user does not exist it will be created, otherwise you will be directed to the existing account.</div>
			</div>

			<div class="DS-card-head DS-padding-lfrg-8px">
				<div class="DS-text-large DS-text-black">Select the country in which to create this user</div>
			</div>
			<div class="DS-card-none DS-padding-lfrg-8px">
				<select name="NewUserCountry" class="DS-input-textbox"><%= usrData.getWazerConfig().getAuth().getActiveCountriesCombo(usrData.getCountry()) /* USR.getManagedCountriesCombo(SysTool.getCurrentUser(request), usrData.getCountry()) */ %></select>
			</div>
			<div class="DS-card-foot DS-padding-lfrg-8px">
				<div class="DS-text-compact DS-text-italic DS-text-gray DS-text-bold">The country defines who can manage this user.</div>
				<div class="DS-text-compact DS-text-italic DS-text-gray">(eg. A user created in Italy can only be managed by an administrator with rights over Italy)</div>
			</div>

			<div class="DS-card-body DS-back-lightgray DS-padding-lfrg-8px DS-border-full">
				<table class="TableSpacing_0px DS-full-width">
					<tr>
						<td class="CellPadding_0px">
							<%= MdcTool.Dialog.BtnDismiss("btnCancel", "Cancel", true, "", "") %>
						</td>
						<td class="CellPadding_0px" align="right">
							<%= MdcTool.Button.SubmitTextIconOutlinedClass("save", "&nbsp;Save", null, "DS-text-green", null, "Save this account") %>
						</td>
					</tr>
				</table>
			</div>

		</form>
<%
	} catch (Exception e) {
%>
		<div class="DS-card-head DS-back-pastel-red DS-border-up">
			<div class="DS-text-subtitle DS-text-exception">Internal Error</div>
		</div>
		<div class="DS-card-foot DS-back-pastel-red">
			<div class="DS-text-exception"><%= e.toString() %></div>
		</div>
<%
	}

	DB.destroy();
%>
