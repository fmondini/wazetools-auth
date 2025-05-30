<%@ page
	language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="net.danisoft.dslib.*"
	import="net.danisoft.wazetools.*"
%>
<%!
	private static final String PAGE_Title = AppCfg.DESCR_ADMN_NAME;
	private static final String PAGE_Keywords = AppCfg.DESCR_ADMN_NAME;
	private static final String PAGE_Description = AppCfg.DESCR_ADMN_NAME;
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
					<div class="DS-text-title-shadow"><%= AppCfg.DESCR_ADMN_NAME %> Path</div>
				</div>

				<div class="DS-card-body">
					<div class=""><%= AppCfg.DESCR_ADMN_TEXT %></div>
				</div>
		
				<div class="DS-card-full">
					<div class="mdc-layout-grid__inner">
						<div class="<%= MdcTool.Layout.Cell(4, 3, 4) %> DS-padding-bottom-16px DS-border-rg">
							<%= MdcTool.Layout.IconCard(
								true,
								"",		
								"manage_accounts",
								"users.jsp",
								"Users Manager",
								"Users Management",
								"Manage User Accounts, Privileges and Hierarchy",
								true,
								true
							) %>
						</div>
						<div class="<%= MdcTool.Layout.Cell(4, 3, 4) %> DS-padding-bottom-16px DS-border-rg">
							<%= MdcTool.Layout.IconCard(
								true,
								"",		
								"patient_list",
								"log.jsp",
								"LOG Viewer",
								"View LOG files",
								"Real time LOG events with filter and selection",
								true,
								true
							) %>
						</div>
						<div class="<%= MdcTool.Layout.Cell(4, 2, 4) %> DS-padding-bottom-16px">
							<%= MdcTool.Layout.IconCard(
								true,
								"",		
								"call_quality",
								"commchk.jsp",
								"Contacts Check",
								"Check communication methods",
								"Check the communication methods active for the user",
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
