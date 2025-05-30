<%@ page
	language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="net.danisoft.dslib.*"
	import="net.danisoft.wazetools.*"
%>
<%!
	private static final String PAGE_Title = AppCfg.getAppName();
	private static final String PAGE_Keywords = "Waze, Auth, Home";
	private static final String PAGE_Description = AppCfg.getAppName() + " is responsible for authenticating and managing Waze.Tools user credentials";
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
<%
	try {
%>
		<div class="mdc-layout-grid__inner">
			<div class="<%= MdcTool.Layout.Cell(12, 8, 4) %>">
				<div class="DS-padding-updn-8px">
					<div class="DS-text-title-shadow">Credential and Privilege Management</div>
				</div>
				<div class="DS-padding-updn-8px">
					<div>This web application is responsible for authenticating and managing Waze.Tools user credentials.</div>
					<div>All WebApps in this suite use this method to authenticate and distribute privileges within the suite.</div>
				</div>
			</div>
		</div>

		<div class="DS-padding-updn-8px">
			<div class="mdc-layout-grid__inner DS-grid-colgap-0px">
				<div class="<%= MdcTool.Layout.Cell(4, 4, 4) %> DS-padding-bottom-16px DS-border-rg">
					<%= MdcTool.Layout.IconCard(
						true,					// isEnabled
						"",						// Div Class		
						AppCfg.DESCR_ANON_ICON,	// Icon Name
						AppCfg.DESCR_ANON_LINK,	// Link HREF
						AppCfg.DESCR_ANON_NAME,	// Icon Text
						AppCfg.DESCR_ANON_HEAD,	// Title Text
						AppCfg.DESCR_ANON_ABST,	// Body Text
						true,
						true
					) %>
				</div>
				<div class="<%= MdcTool.Layout.Cell(4, 4, 4) %> DS-padding-bottom-16px DS-border-rg">
					<%= MdcTool.Layout.IconCard(
						true,					// isEnabled
						"",						// Div Class		
						AppCfg.DESCR_USER_ICON,	// Icon Name
						AppCfg.DESCR_USER_LINK,	// Link HREF
						AppCfg.DESCR_USER_NAME,	// Icon Text
						AppCfg.DESCR_USER_HEAD,	// Title Text
						AppCfg.DESCR_USER_ABST,	// Body Text
						true,
						true
					) %>
				</div>
				<div class="<%= MdcTool.Layout.Cell(4, 4, 4) %> DS-padding-bottom-16px">
					<%= MdcTool.Layout.IconCard(
						true,					// isEnabled
						"",						// Div Class		
						AppCfg.DESCR_ADMN_ICON,	// Icon Name
						AppCfg.DESCR_ADMN_LINK,	// Link HREF
						AppCfg.DESCR_ADMN_NAME,	// Icon Text
						AppCfg.DESCR_ADMN_HEAD,	// Title Text
						AppCfg.DESCR_ADMN_ABST,	// Body Text
						true,
						true
					) %>
				</div>
			</div>
		</div>

		<div class="DS-padding-updn-8px">	
			<%= MdcTool.Button.BackTextIcon("Exit", AppCfg.getAppExitLink()) %>
		</div>
<%
	} catch (Exception e) {
%>
		<div class="DS-padding-updn-8px">
			<div class="DS-text-subtitle DS-text-exception">Internal Error</div>
		</div>
		<div class="DS-padding-updn-8px">
			<div class="DS-text-exception"><%= e.toString() %></div>
		</div>
<%
	}
%>
	</div>
	</div> <!-- /mdc-layout-grid__inner -->
	</div> <!-- /mdc-layout-grid -->

	<jsp:include page="../_common/footer.jsp">
		<jsp:param name="RedirectTo" value=""/>
	</jsp:include>

</body>
</html>
