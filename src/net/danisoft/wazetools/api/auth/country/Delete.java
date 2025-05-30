////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Delete.java
//
// Delete a country in AUTH section
//
// First Release: May/2025 by Fulvio Mondini (https://danisoft.software/)
//
////////////////////////////////////////////////////////////////////////////////////////////////////

package net.danisoft.wazetools.api.auth.country;

import java.io.IOException;

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
import net.danisoft.wtlib.auth.AuthRole;
import net.danisoft.wtlib.auth.User;

@WebServlet(description = "Delete a country in AUTH section", urlPatterns = { "/api/auth/country/delete" })

public class Delete extends HttpServlet {

	private static final long serialVersionUID = FmtTool.getSerialVersionUID();
	private static final String msgHead = "/api/auth/country/delete: ";

	/**
	 * POST
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String reqUser = EnvTool.getStr(request, "reqUser", "");
		String reqCtry = EnvTool.getStr(request, "reqCtry", "");
		
		Database DB = null;
		ServletOutputStream OUT = response.getOutputStream();
		
		try {

			if (!request.isUserInRole(AuthRole.ADMIN.getCode()))
				throw new Exception("Unauthorized");

			DB = new Database();
			User USR = new User(DB.getConnection());
			User.Data usrData = USR.Read(reqUser);

			JSONObject jConfig = usrData.getConfig();
			JSONObject jCfgAuth = jConfig.getJSONObject("auth");
			JSONArray jaCountries = jCfgAuth.getJSONArray("activeCountries");

			for (int i=0; i<jaCountries.length(); i++)
				if (jaCountries.getString(i).equals(reqCtry))
					jaCountries.remove(i);

			jCfgAuth.put("activeCountries", jaCountries);
			jConfig.put("auth", jCfgAuth);
			usrData.setConfig(jConfig);
			USR.Update(reqUser, usrData);

			OUT.println("OK " + msgHead + "Country " + reqCtry + " removed from user " + reqUser);

		} catch (Exception e) {
			System.err.println(msgHead + e.toString());
			OUT.println(e.getMessage());
		}

		if (DB != null)
			DB.destroy();
	}

}
