////////////////////////////////////////////////////////////////////////////////////////////////////
//
// GetUserAreas.java
//
// Servlet to get all area paths for a given user
//
// First Release: Sep/2021 by Fulvio Mondini (https://danisoft.software/)
//       Revised: Mar/2025 Ported to Waze dslib.jar
//                         Changed to @WebServlet style
//
////////////////////////////////////////////////////////////////////////////////////////////////////

package net.danisoft.wazetools.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Enumeration;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.danisoft.dslib.Database;
import net.danisoft.dslib.EnvTool;
import net.danisoft.dslib.FmtTool;
import net.danisoft.dslib.SysTool;
import net.danisoft.wazetools.auth.Area;

@WebServlet(description = "Get all area paths for a given user", urlPatterns = { "/servlet/GetUserAreas" })

public class GetUserAreas extends HttpServlet {
       
	private static final long serialVersionUID = FmtTool.getSerialVersionUID();

    public GetUserAreas() {
        super();
    }

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		response.setContentType("text/javascript; charset=UTF-8");

		String AllPaths = "";
		String UserName = EnvTool.getStr(request, "user", "");

		Database DB = null;

		try {

			DB = new Database();
			String FillOpacity = (UserName.equals("") ? "0.05" : "0.35");
			String StrokeOpacity = (UserName.equals("") ? "0.20" : "0.50");

			Enumeration<String> usrAreas = _get_user_area_coords(DB.getConnection(), UserName);

			while (usrAreas.hasMoreElements())
				AllPaths +=
					"new google.maps.Polygon({" +
						"map:MapObj," +
						"clickable:false," +
						"fillColor:'#aaaaaa'," +
						"fillOpacity:" + FillOpacity + "," +
						"strokeColor:'#005279'," +
						"strokeOpacity:" + StrokeOpacity + "," +
						"strokeWeight:3," +
						"paths:[" + usrAreas.nextElement() + "]" +
					"});"
				;

		} catch (Exception e) {

			AllPaths = "";
			System.err.println("GetUserAreas.doPost(): " + e.toString());
		}

		if (DB != null)
			DB.destroy();

		response.getOutputStream().println(AllPaths);
	}

	/**
	 * Create array of UserArea Coords
	 * @note To create a polygon via javascript
	 * @return a lot of "{lat: 25.774, lng: -80.190}," in a single string
	 */
	private static Enumeration<String> _get_user_area_coords(Connection cn, String UserID) {

		int i, p;
		Enumeration<String> uuaEnum = null;
		Vector<String> Results = new Vector<>();
		String tmpStr, UsrArea = "", UsrPoly[] = null, UsrVertex[] = null, UsrPoints[] = null;

		try {

			uuaEnum = _read_all(cn, UserID);

			while (uuaEnum.hasMoreElements()) {

				UsrArea = uuaEnum.nextElement().split(SysTool.getDelimiter())[2] // Third field
				    .replace("POLYGON((", "")
				    .replace("))", "")
				    .replace("),(", SysTool.getDelimiter());
				
				UsrPoly = UsrArea.split(SysTool.getDelimiter());
				
				for (p=0; p<UsrPoly.length; p++) {
					
					UsrVertex = UsrPoly[p].split(",");

					tmpStr = "";

					for (i = 0; i < UsrVertex.length; i++) {

						UsrPoints = UsrVertex[i].split(" ");
						tmpStr += "{lng:" + UsrPoints[0] + ",lat:" + UsrPoints[1] + "}, ";
					}

					Results.addElement(tmpStr);
				}
			}

		} catch (Exception e) {
			System.err.println(e.toString());
		}
		return(Results.elements());
	}

	/**
	 * Read
	 * @throws Exception
	 * @return Enumeration of (AUA_ID + AUA_User + AUA_Area)
	 */
	private static Enumeration<String> _read_all(Connection cn, String UserID) throws Exception {

		Vector<String> Results = new Vector<>();

		Statement st = cn.createStatement();

		ResultSet rs = st.executeQuery(
			"SELECT AUA_ID, AUA_User, ST_AsText(AUA_Area) AS UserArea " +
			"FROM " + Area.getTblName() + " " +
			(UserID.equals("") ? "" : "WHERE AUA_User = '" + UserID + "'") +
			"ORDER BY AUA_User;"
		);

		while (rs.next())
			Results.addElement(
				rs.getString("AUA_ID") + SysTool.getDelimiter() +
				rs.getString("AUA_User") + SysTool.getDelimiter() +
				rs.getString("UserArea")
			);

		rs.close();
		st.close();

		return(Results.elements());
	}

}
