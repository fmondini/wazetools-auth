////////////////////////////////////////////////////////////////////////////////////////////////////
//
// AcUSR.java
//
// Users autocomplete Servlet 
//
// First Release: Aug/2022 by Fulvio Mondini (https://danisoft.software/)
//       Revised: Mar/2025 Ported to Waze dslib.jar
//                         Changed to @WebServlet style
//
////////////////////////////////////////////////////////////////////////////////////////////////////

package net.danisoft.wazetools.servlets;

import java.io.IOException;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;

import net.danisoft.dslib.Database;
import net.danisoft.dslib.EnvTool;
import net.danisoft.dslib.FmtTool;
import net.danisoft.wtlib.auth.User;

@WebServlet(description = "Users Autocomplete Servlet", urlPatterns = { "/servlet/AcUSR" })

public class AcUSR extends HttpServlet {

	private static final long serialVersionUID = FmtTool.getSerialVersionUID();

	public AcUSR() {
		super();
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		Database DB = null;
		ServletOutputStream out = response.getOutputStream();

		String SearchKey = EnvTool.getStr(request, "SearchKey", "");

		try {

			DB = new Database();
			User USR = new User(DB.getConnection());

			JSONObject jRoot = new JSONObject();
			JSONArray jaUsers = new JSONArray();
			JSONObject jUser;

			Vector<User.Data> vecUsrData = USR.Search(request, SearchKey);

			if (vecUsrData.size() > 0) {

				for (User.Data usrData : vecUsrData) {

					jUser = new JSONObject();

					jUser.put("nn", usrData.getName());
					jUser.put("fn", usrData.getFirstName());
					jUser.put("ln", usrData.getLastName());
					jUser.put("ma", usrData.getMail());
					jUser.put("rk", usrData.getRank());
					
					jaUsers.put(jUser);
				}

				jRoot.put("result", jaUsers);

				out.println(jRoot.toString());

			} else
				response.sendError(HttpServletResponse.SC_NOT_ACCEPTABLE, "No matches found for '" + SearchKey + "'");

		} catch (Exception e) {
			System.err.println(e.toString());
		}

		if (DB != null)
			DB.destroy();

		out.flush();
	}

}
