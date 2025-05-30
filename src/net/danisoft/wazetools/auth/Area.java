////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Area.java
//
// DB Interface for the user areas table
//
// First Release: Feb/2020 by Fulvio Mondini (https://danisoft.software)
//       Revised: Mar/2025 Ported to Waze dslib.jar
//
////////////////////////////////////////////////////////////////////////////////////////////////////

package net.danisoft.wazetools.auth;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Enumeration;
import java.util.Vector;

/**
 * AUTH User Area table
 * @apiNote Also used by Tomcat JDBCRealm
 */
public class Area {

	private final static String TBL_NAME = "AUTH_areas";
	private final static String TMP_TABLE = "AUTH_tmpAreas";

	public static String getTblName() { return TBL_NAME; }

	private Connection cn;

	/**
	 * Constructor
	 */
	public Area(Connection conn) {
		this.cn = conn;
	}

	/**
	 * Create
	 */
	public void Create(String UserName, String JsonArea) throws Exception {

		Statement st = this.cn.createStatement();

		st.executeUpdate(
			"INSERT INTO " + TBL_NAME + " (" +
				"AUA_User, AUA_Area" +
			") VALUES (" +
				"'" + UserName + "', ST_GeomFromText('" + JsonArea + "')" +
			");"
		);

		st.close();
	}

	/**
	 * Delete all areas for a given user
	 */
	public void Delete(String UserName) throws Exception {

		Statement st = this.cn.createStatement();
		st.executeUpdate("DELETE FROM " + TBL_NAME + " WHERE AUA_User = '" + UserName + "';");
		st.close();
	}

	/**
	 * Get a combo of all Users with an area
	 */
	public String getUsersCombo(String defaultUser) {

		String rc =
			"<option" + (defaultUser.equals("") ? " selected" : "") + " value=\"\">" +
				"-=[ All Users ]=-" +
			"</option>"
		;

		try {

			Statement st = this.cn.createStatement();

			ResultSet rs = st.executeQuery(
				"SELECT DISTINCT AUA_User, COUNT(*) AS AreaCount " +
				"FROM " + TBL_NAME + " " +
				"GROUP BY AUA_User " +
				"ORDER BY AUA_User;"
			);

			while (rs.next()) {
				rc += "<option " +
					"value=\"" + rs.getString("AUA_User") + "\"" + (rs.getString("AUA_User").equals(defaultUser) ? " selected" : "") + ">" +
					rs.getString("AUA_User") + " [" + rs.getInt("AreaCount") + "]" +
				"</option>";
			}

			rs.close();
			st.close();

		} catch (Exception e) { }

		return(rc);
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////
	//
	// TEMPORARY TABLE HANDLING
	//
	////////////////////////////////////////////////////////////////////////////////////////////////////

	/**
	 * Create temporary table for areas import
	 */
	public void tmpTblCreate() throws Exception {

		Statement st = this.cn.createStatement();

		st.execute("DROP TABLE IF EXISTS " + TMP_TABLE);

		st.execute(
			"CREATE TABLE " + TMP_TABLE + " (" +
				"AUA_T_ID int NOT NULL AUTO_INCREMENT, " +
				"AUA_T_User varchar(255) NOT NULL DEFAULT '', " +
				"AUA_T_Rank int NOT NULL DEFAULT '0', " +
				"AUA_T_Area polygon DEFAULT NULL, " +
				"PRIMARY KEY (AUA_T_ID), " +
				"KEY IX_T_User (AUA_T_User) " +
			") ENGINE=InnoDB;"
		);

		st.close();
	}

	/**
	 * Insert in temporary table for areas import
	 */
	public void tmpTblInsert(String UserName, int UserRank, String JsonArea) throws Exception {

		Statement st = this.cn.createStatement();

		st.executeUpdate(
			"INSERT INTO " + TMP_TABLE + " (" +
				"AUA_T_User, AUA_T_Rank, AUA_T_Area" +
			") VALUES (" +
				"'" + UserName + "', " + UserRank + ", ST_GeomFromText('" + JsonArea + "')" +
			");"
		);

		st.close();
	}

	/**
	 * Retrieve all DISTINCT(user) in temporary table for areas import
	 */
	public Enumeration<String> tmpTblGetUsers() throws Exception {

		Vector<String> Results = new Vector<>();

		Statement st = this.cn.createStatement();
		ResultSet rs = st.executeQuery("SELECT DISTINCT(AUA_T_User) FROM " + TMP_TABLE + " ORDER BY AUA_T_User;");

		while (rs.next())
			Results.addElement(rs.getString("AUA_T_User"));

		rs.close();
		st.close();

		return(Results.elements());
	}

	/**
	 * Retrieve ALL areas for a given user in temporary table for areas import
	 */
	public Enumeration<String> tmpTblGetAreas(String UserName) throws Exception {

		Vector<String> Results = new Vector<>();

		Statement st = this.cn.createStatement();
		ResultSet rs = st.executeQuery("SELECT ST_AsText(AUA_T_Area) AS TextArea FROM " + TMP_TABLE + " WHERE AUA_T_User = '" + UserName + "';");

		while (rs.next())
			Results.addElement(rs.getString("TextArea"));

		rs.close();
		st.close();

		return(Results.elements());
	}

	/**
	 * Retrieve a user rank from temporary table for areas import
	 */
	public int tmpTblGetRank(String UserName) throws Exception {

		int rc = 0;
		String ErrorMsg = null;

		Statement st = this.cn.createStatement();
		ResultSet rs = st.executeQuery("SELECT AUA_T_Rank FROM " + TMP_TABLE + " WHERE AUA_T_User = '" + UserName + "';");

		if (rs.next())
			rc = rs.getInt("AUA_T_Rank");
		else
			ErrorMsg = "Area.tmptblGetRank(): AUA_T_User '" + UserName + "' NOT found";

		rs.close();
		st.close();

		if (ErrorMsg != null)
			throw new Exception(ErrorMsg);

		return(rc);
	}

	/**
	 * Drop temporary table after work
	 */
	public void tmpTblDrop() throws Exception {

		Statement st = this.cn.createStatement();
		st.execute("DROP TABLE IF EXISTS " + TMP_TABLE);
		st.close();
	}

}
