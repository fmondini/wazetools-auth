////////////////////////////////////////////////////////////////////////////////////////////////////
//
// RefreshFromIBot.java
//
// Servlet to retrieve data from iBot
//
// First Release: Feb/2018 by Fulvio Mondini (https://danisoft.software/)
//       Revised: Feb/2020 by Fulvio Mondini (https://danisoft.software/)
//       Revised: Jun/2021 by Fulvio Mondini (https://danisoft.software/)
//       Revised: Jan/2024 Moved to V3
//       Revised: Mar/2025 Ported to Waze dslib.jar
//                         Changed to @WebServlet style
//
////////////////////////////////////////////////////////////////////////////////////////////////////

package net.danisoft.wazetools.servlets;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Enumeration;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;

import net.danisoft.dslib.Database;
import net.danisoft.dslib.FmtTool;
import net.danisoft.wtlib.auth.User;
import net.danisoft.wazetools.AppCfg;
import net.danisoft.wazetools.auth.Area;

@WebServlet(description = "Retrieve data from iBot", urlPatterns = { "/servlet/RefreshFromIBot" })

public class RefreshFromIBot extends HttpServlet {

	private static final long serialVersionUID = FmtTool.getSerialVersionUID();

	private static final String ALLOWED_ACCESS_IP	= "0:0:0:0:0:0:0:1 127.0.0.1 82.113.201.188 5.135.239.3";
	private static final String ERROR_PREFIX		= "[ERROR]";
	private static final String IBOT_REMOTE_URL		= AppCfg.getIBotFullAreasUrl(); // Since 2021-06-19

	/**
	 * Refresh user data from iBot
	 */
	@Override
	public void doGet(final HttpServletRequest request, final HttpServletResponse response) throws ServletException, IOException {

		ServletOutputStream out = response.getOutputStream();

		Database DB = null;

		JSONArray jsonAll = null;
		JSONObject jsonObj = null;

		String jsonRaw = "";
		String jsonUser = "";
		String jsonArea = "";
		int i, jsonRank, totUsers = 0, totNewUsers = 0, totAreas = 0;

		long startTime = System.nanoTime();

		try {

			DB = new Database();
			User USR = new User(DB.getConnection());
			Area AUA = new Area(DB.getConnection());

			if (!ALLOWED_ACCESS_IP.contains(request.getRemoteAddr()))
				throw new Exception("Sorry, access from " + request.getRemoteAddr() + " is not allowed.");

			jsonRaw = _get_json_url(IBOT_REMOTE_URL);

			if (jsonRaw.startsWith(ERROR_PREFIX))
				throw new Exception(jsonRaw);

			if (jsonRaw.equals("null"))
				throw new Exception("iBot: No area associated");

			jsonAll = new JSONArray(jsonRaw);

			//
			// Save ALL json data to a temp table
			//

			AUA.tmpTblCreate();

			for (i = 0; i < jsonAll.length(); i++) {

				jsonObj = jsonAll.getJSONObject(i);
				jsonUser = jsonObj.get("username").toString();
				jsonArea = jsonObj.get("polygon").toString();
				jsonRank = Integer.parseInt(jsonObj.get("rank").toString());

				AUA.tmpTblInsert(jsonUser, jsonRank, jsonArea);
			}

			//
			// Loop through the temp table and update Users and Areas
			//

			int tmpRank;
			String tmpUser, tmpArea;
			Enumeration<String> enumUser, enumArea;
			
			enumUser = AUA.tmpTblGetUsers();

			while (enumUser.hasMoreElements()) {

				tmpUser = enumUser.nextElement();
				tmpRank = AUA.tmpTblGetRank(tmpUser);

				// Update Rank

				try {

					if (!USR.Exists(tmpUser)) {

						USR.Create(tmpUser, "ITA", "iBotAreaImport");
						out.println("[NEWUSR] New user created: " + tmpUser + " in ITA country");
						totNewUsers++;
					}

					User.Data usrData = USR.Read(tmpUser);
					usrData.setRank(tmpRank);
					USR.Update(tmpUser, usrData);

					totUsers++;

					// Update Areas 

					AUA.Delete(tmpUser);

					enumArea = AUA.tmpTblGetAreas(tmpUser);

					while (enumArea.hasMoreElements()) {

						tmpArea = enumArea.nextElement();
						
						try {

							AUA.Create(tmpUser, tmpArea);

							totAreas++;

						} catch (Exception ei) {
							out.println("[INSERT] " + ei.getMessage());
						}
					}

				} catch (Exception ee) {
					out.println("[SETRNK] " + ee.getMessage());
				}
			}

			AUA.tmpTblDrop();

		} catch (Exception e) {
			out.println(e.getMessage());
		}

		if (DB != null)
			DB.destroy();

		double runningTimeMillis = (System.nanoTime() - startTime) / 1000L / 1000L;

		out.println("[RESULT] " + totAreas + " areas updated for " + totUsers + " users (" + totNewUsers + " new) in " + FmtTool.fmtNumber2dUS(runningTimeMillis / 1000.0D) + " seconds.");
	}

	/**
	 * Retrieve a remote json URL
	 */
	private static String _get_json_url(String JsonUrl) throws Exception {

		String InLine;
		StringBuilder result = new StringBuilder();

		try {

			URL url = new URL(JsonUrl);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();

			if (conn.getResponseCode() == 200) {

				BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));

				while ((InLine = rd.readLine()) != null)
					result.append(InLine);

				rd.close();

			} else
				result.append(ERROR_PREFIX + " " + conn.getResponseCode() + " retrieving iBot data");

			conn.disconnect();

		} catch (Exception e) {
			result.append(ERROR_PREFIX + " _getJsonUrl() Exception<br>" + e.toString());
		}

		return result.toString();
	}
	
}
