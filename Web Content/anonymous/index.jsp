<%@ page
	language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="net.danisoft.dslib.*"
	import="net.danisoft.wazetools.*"
%>
<%!
	private static final String PAGE_Title = AppCfg.DESCR_ANON_NAME;
	private static final String PAGE_Keywords = AppCfg.DESCR_ANON_NAME;
	private static final String PAGE_Description = AppCfg.DESCR_ANON_NAME;
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
					<div class="DS-text-title-shadow"><%= AppCfg.DESCR_ANON_NAME %> Path</div>
				</div>

				<div class="DS-padding-updn-8px">
					<div class=""><%= AppCfg.DESCR_ANON_TEXT %></div>
				</div>

				<div class="DS-padding-updn-8px">
					<div class="mdc-layout-grid__inner">
						<div class="<%= MdcTool.Layout.Cell(4, 3, 4) %> DS-padding-bottom-16px DS-border-rg">
							<%= MdcTool.Layout.IconCard(
								true,
								"",		
								"person_add",
								"register.jsp",
								"Register",
								"Register as new user",
								"Your new account will be ready<br>once approved by our administrators",
								true,
								true
							) %>
						</div>
						<div class="<%= MdcTool.Layout.Cell(4, 2, 4) %> DS-padding-bottom-16px DS-border-rg">
							<%= MdcTool.Layout.IconCard(
								true,
								"",		
								"passkey",
								"sendpwd.jsp",
								"Password",
								"Retrieve Your Password",
								"Enter your e-Mail address and we'll<br>send you your access tokens",
								true,
								true
							) %>
						</div>
						<div class="<%= MdcTool.Layout.Cell(4, 3, 4) %> DS-padding-bottom-16px">
							<%= MdcTool.Layout.IconCard(
								true,
								"",		
								"groups",
								"hierarchy.jsp",
								"Hierarchy",
								"Waze Hierarchy &amp; Roles",
								"Get a list of Positions and Roles<br>held in Waze hierarchy",
								true,
								true
							) %>
						</div>
					</div>
				</div>

				<div class="DS-padding-updn-8px">
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
