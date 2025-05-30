<%@ page
	language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="net.danisoft.dslib.*"
	import="net.danisoft.wazetools.auth.*"
%>
<%!
	private static final String PAGE_Title = "View Assigned Areas";
	private static final String PAGE_Keywords = "View, Assigned, Editing Areas";
	private static final String PAGE_Description = "Graphically displays a map of the assigned editing areas (Italy only)";

	private static final String	MAP_CONTAINER_ID = "map_canvas";

	private static final int	DEFAULT_ZOOM = 6;
	private static final double	DEFAULT_CENTER_LAT = 41.9;
	private static final double	DEFAULT_CENTER_LNG = 12.5;
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

	<jsp:include page="../_common/header.jsp">
		<jsp:param name="Force-Hide" value="Y"/>
	</jsp:include>

	<div id="<%= MAP_CONTAINER_ID %>" style="position: absolute; top: 0px; left: 0px; width: 100%; height: 100%; z-index: -1;"></div>
<%
	Database DB = null;

	String selUser = EnvTool.getStr(request, "selUser", "");

	try {

		DB = new Database();
		Area UUA = new Area(DB.getConnection());
%>
		<div class="DS-padding-0px DS-back-white" style="position: absolute; top: 60px; right: 15px; border-radius: 7px; -moz-border-radius: 7px; box-shadow: 3px 3px 5px #888888;">
			<form>
				<%= MdcTool.Select.Box(
					"selUser",
					MdcTool.Select.Width.NORM,
					"",
					UUA.getUsersCombo(selUser),
					"onChange=\"submit();\""
				) %>
			</form>
		</div>

		<div style="position: absolute; bottom: 25px; left: 25px;">
			<%= MdcTool.Button.BackTextIcon("Back", "../user/") %>
		</div>
<%

	} catch (Exception e) {
%>
		<div class="mdc-layout-grid">
			<div class="mdc-layout-grid__inner">
				<div style="position: absolute; top: 100px; left: 100px; right: 100px; padding: 10px; background-color: white; border-radius: 7px; -moz-border-radius: 7px; box-shadow: 3px 3px 5px #888888;">
					<div class="DS-padding-updn-8px">
						<div class="DS-text-subtitle DS-text-exception"><b>INTERNAL ERROR</b></div>
					</div>
					<div class="DS-padding-updn-8px">
						<div class="DS-text-exception"><%= e.toString() %></div>
					</div>
					<div class="DS-padding-updn-8px">
						<div class="DS-text-paragraph DS-text-exception">Please report to <a href="mailto:dev@waze.tools">dev@waze.tools</a></div>
					</div>
				</div>
			</div>
		</div>
<%
	}

	if (DB != null)
		DB.destroy();

	////////////////////////////////////////////////////////////////////////////////////////////////////
	//
	// SCRIPTS
	//
%>
	<script>

		var MapObj = null;

		/**
		 * Init map
		 */
		function InitMap() {

			var mapDefaultZoom = <%= DEFAULT_ZOOM %>;
			var mapDefaultCLat = <%= DEFAULT_CENTER_LAT %>;
			var mapDefaultCLng = <%= DEFAULT_CENTER_LNG %>;

			MapObj = new google.maps.Map(
				document.getElementById('<%= MAP_CONTAINER_ID %>'), {
					zoom: mapDefaultZoom,
					fullscreenControl: false,
					scaleControl: false,
					mapTypeControl: false,
					streetViewControl: false,
					panControl: true,
					center: new google.maps.LatLng(mapDefaultCLat, mapDefaultCLng)
				}
			);

			DrawUserAreaPaths('<%= selUser %>');
		}

		/**
		 * Get and Draw User Area Paths
		 */
		function DrawUserAreaPaths(User) {

			$.ajax({

				type: 'POST',
				dataType: 'text',
				url: '../servlet/GetUserAreas',
				data: { user: User },

				success: function(data) {
					$('#UserAreaPathsScript').html(data);
				},

				error: function(jqXHR, textStatus, errorThrown) {
					console.error('DrawUserAreaPaths() Error: jqXHR: %o', jqXHR);
				}
			});
		}

	</script>

	<script id="UserAreaPathsScript"></script>

	<script src="https://maps.googleapis.com/maps/api/js?key=<%= new SiteCfg().getPrivateParams().getGoogleMapKey() %>&loading=async&callback=InitMap"></script>

	<jsp:include page="../_common/footer.jsp">
		<jsp:param name="Force-Hide" value="Y"/>
	</jsp:include>

</body>
</html>
