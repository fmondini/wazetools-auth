<%@ page
	language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="net.danisoft.dslib.*"
	import="net.danisoft.wazetools.*"
%>
<%!
	private static final String PAGE_Title = AppCfg.DESCR_USER_NAME;
	private static final String PAGE_Keywords = AppCfg.DESCR_USER_NAME;
	private static final String PAGE_Description = AppCfg.DESCR_USER_NAME;
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
					<div class="DS-text-title-shadow"><%= AppCfg.DESCR_USER_NAME %> Path</div>
				</div>

				<div class="DS-card-body">
					<div class=""><%= AppCfg.DESCR_USER_TEXT %></div>
				</div>

				<div class="DS-card-full">
					<div class="mdc-layout-grid__inner">
						<div class="<%= MdcTool.Layout.Cell(4, 3, 4) %> DS-padding-bottom-16px DS-border-rg">
							<%= MdcTool.Layout.IconCard(
								true,
								"",		
								"badge",
								"profile.jsp",
								"Profile",
								"Change Your Data",
								"Select this link to change your current<br>name, address and phone",
								true,
								true
							) %>
						</div>
						<div class="<%= MdcTool.Layout.Cell(4, 3, 4) %> DS-padding-bottom-16px DS-border-rg">
							<%= MdcTool.Layout.IconCard(
								true,
								"",		
								"passkey",
								"changepwd.jsp",
								"Password",
								"Change Password",
								"Select this link to change your<br>current password with a new one",
								true,
								true
							) %>
						</div>
						<div class="<%= MdcTool.Layout.Cell(4, 3, 4) %> DS-padding-bottom-16px">
							<%= MdcTool.Layout.IconCard(
								true,
								"",		
								"map",
								"viewareas.jsp",
								"AM Areas",
								"View Assigned Areas",
								"Graphically displays a map of all the<br>assigned editing areas <span class=\"DS-text-compact DS-text-italic DS-text-exception\">(Italy only)</span>",
								true,
								true
							) %>
						</div>
					</div>
				</div>

				<div class="DS-card-foot">
					<%= MdcTool.Button.BackTextIcon("Back", "../home/") %>
				</div>

			</div>
		</div>
	</div>

	<jsp:include page="../_common/footer.jsp">
		<jsp:param name="RedirectTo" value=""/>
	</jsp:include>

</body>
</html>
