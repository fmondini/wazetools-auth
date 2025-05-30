<%@ page
	language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="net.danisoft.dslib.*"
%>
<%!
	private static final String PAGE_Title = "How to setup your SlackID";
	private static final String PAGE_Keywords = "";
	private static final String PAGE_Description = "";
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

		<div class="DS-card-body">
			<jsp:include page="./_slackid_help_content.jsp"></jsp:include>
		</div>

		<div class="<%= MdcTool.Layout.Cell(12, 8, 4) %>">
			<div class="DS-card-foot">
				<%= MdcTool.Button.BackTextIcon("Back", "../home/") %>
			</div>
		</div>

	</div>

	<jsp:include page="../_common/footer.jsp">
		<jsp:param name="RedirectTo" value=""/>
	</jsp:include>

</body>
</html>
