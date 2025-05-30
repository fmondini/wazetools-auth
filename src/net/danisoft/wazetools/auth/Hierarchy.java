////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Hierarchy.java
//
// DB Interface for the Waze hierarchy in the community
//
// First Release: Dec 2019 by Fulvio Mondini (https://danisoft.software/)
//       Revised: Jan 2024 - Moved to V3
//       Revised: Mar/2025 Ported to Waze dslib.jar
//
////////////////////////////////////////////////////////////////////////////////////////////////////

package net.danisoft.wazetools.auth;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.Vector;

import net.danisoft.dslib.FmtTool;
import net.danisoft.wtlib.auth.GeoIso;
import net.danisoft.wtlib.auth.User;

/**
 * DB Interface for the Waze hierarchy in the community
 * @apiNote Also used by Tomcat JDBCRealm
 */
public class Hierarchy {

	private final static String TBL_NAME = "AUTH_hierarchy";

	private static final String AHI_COMMON_SELECT_STATEMENT =
		"SELECT " +
			"AHI_ID, AHI_NickName, " +
			"AHI_GeoRef, " +
			"(SELECT GEO_Name FROM AUTH_geo WHERE GEO_Code = LEFT(AHI_GeoRef, 3) LIMIT 1) AS Country, " +
			"IF (LENGTH(GEO_Code) >= 7, (SELECT GEO_Name FROM AUTH_geo WHERE GEO_Code = LEFT(AHI_GeoRef, 7) LIMIT 1), '') AS State, " +
			"IF (LENGTH(GEO_Code) = 10, (SELECT GEO_Name FROM AUTH_geo WHERE GEO_Code = AHI_GeoRef LIMIT 1), '') AS District, " +
	        "CONCAT( " +
				"(SELECT GEO_Name FROM AUTH_geo WHERE GEO_Code = LEFT(AHI_GeoRef, 3) LIMIT 1), " +
				"IF (LENGTH(GEO_Code) >= 7, CONCAT(' :: ', (SELECT GEO_Name FROM AUTH_geo WHERE GEO_Code = LEFT(AHI_GeoRef, 7) LIMIT 1)), ''), " +
				"IF (LENGTH(GEO_Code) = 10, CONCAT(' :: ', (SELECT GEO_Name FROM AUTH_geo WHERE GEO_Code = AHI_GeoRef LIMIT 1)) , '') " +
			") AS Location, " +
			"AHI_Role, AHI_Since, AHI_LastUpdate, AHI_LastUpdatedBy, " +
			"USR_Firstname, USR_LastName, USR_Mail, USR_SlackID, USR_Phone, USR_Rank " +
		"FROM " + TBL_NAME + " " +
		"LEFT JOIN " + User.getTblName() + " ON AHI_NickName = USR_Name " +
		"LEFT JOIN " + GeoIso.getTblName() + " ON AHI_GeoRef = GEO_Code "
	;

	private Connection cn;

	/**
	 * Constructor
	 */
	public Hierarchy(Connection conn) {
		this.cn = conn;
	}

	/**
	 * Hierarchy Aggregate Data
	 */
	public class Data {

		// Fields
		private int			_ID;			// `AHI_ID` int NOT NULL AUTO_INCREMENT,
		private String		_NickName;		// `AHI_NickName` varchar(32) NOT NULL DEFAULT '',
		private String		_GeoRef;		// `AHI_GeoRef` varchar(16) NOT NULL DEFAULT '',
		private String		_Country;
		private String		_State;
		private String		_District;
		private String		_Location;
		private String		_Role;			// `AHI_Role` char(2) NOT NULL DEFAULT 'UN',
		private Timestamp	_Since;			// `AHI_Since` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
		private Timestamp	_LastUpdate;	// `AHI_LastUpdate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		private String		_LastUpdatedBy;	// `AHI_LastUpdatedBy` varchar(32) DEFAULT '[system]',
		private String		_Firstname;
		private String		_LastName;
		private String		_Mail;
		private String		_SlackID;
		private String		_Phone;
		private int			_Rank;

		// Getters
		public int			getID()				{ return this._ID;				}
		public String		getNickName()		{ return this._NickName;		}
		public String		getGeoRef()			{ return this._GeoRef;			}
		public String		getCountry()		{ return this._Country;			}
		public String		getState()			{ return this._State;			}
		public String		getDistrict()		{ return this._District;		}
		public String		getLocation()		{ return this._Location;		}
		public String		getRole()			{ return this._Role;			}
		public Timestamp	getSince()			{ return this._Since;			}
		public Timestamp	getLastUpdate()		{ return this._LastUpdate;		}
		public String		getLastUpdatedBy()	{ return this._LastUpdatedBy;	}
		public String		getFirstname()		{ return this._Firstname;		}
		public String		getLastName()		{ return this._LastName;		}
		public String		getMail()			{ return this._Mail;			}
		public String		getSlackID()		{ return this._SlackID;			}
		public String		getPhone()			{ return this._Phone;			}
		public int			getRank()			{ return this._Rank;			}

		// Setters
		public void setID(int id)							{ this._ID = id;						}
		public void setNickName(String nickName)			{ this._NickName = nickName;			}
		public void setGeoRef(String geoRef)				{ this._GeoRef = geoRef;				}
		public void setCountry(String country)				{ this._Country = country;				}
		public void setState(String state)					{ this._State = state;					}
		public void setDistrict(String district)			{ this._District = district;			}
		public void setLocation(String location)			{ this._Location = location;			}
		public void setRole(String role)					{ this._Role = role;					}
		public void setSince(Timestamp since)				{ this._Since = since;					}
		public void setLastUpdate(Timestamp lastUpdate)		{ this._LastUpdate = lastUpdate;		}
		public void setLastUpdatedBy(String lastUpdatedBy)	{ this._LastUpdatedBy = lastUpdatedBy;	}
		public void setFirstname(String firstname)			{ this._Firstname = firstname;			}
		public void setLastName(String lastName)			{ this._LastName = lastName;			}
		public void setMail(String mail)					{ this._Mail = mail;					}
		public void setSlackID(String slackID)				{ this._SlackID = slackID;				}
		public void setPhone(String phone)					{ this._Phone = phone;					}
		public void setRank(int rank)						{ this._Rank = rank;					}

		/**
		 * Constructor
		 */
		public Data() {
			super();

			this._ID			= 0;
			this._NickName		= "";
			this._GeoRef		= "";
			this._Country		= "";
			this._State			= "";
			this._District		= "";
			this._Location		= "";
			this._Role			= "";
			this._Since			= FmtTool.DATEZERO;
			this._LastUpdate	= FmtTool.DATEZERO;
			this._LastUpdatedBy	= "";
			this._Firstname		= "";
			this._LastName		= "";
			this._Mail			= "";
			this._SlackID		= "";
			this._Phone			= "";
			this._Rank			= 0;
		}
	}

	/**
	 * Create a new HierarchyRole
	 * @throws Exception
	 */
	public void Insert(Data ahiData) throws Exception {

		Statement st = this.cn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
		ResultSet rs = st.executeQuery("SELECT * FROM " + TBL_NAME + " LIMIT 1");

		rs.moveToInsertRow();

		rs.updateString("AHI_NickName", ahiData.getNickName());
		rs.updateString("AHI_GeoRef", ahiData.getGeoRef());
		rs.updateString("AHI_Role", ahiData.getRole());
		rs.updateTimestamp("AHI_Since", ahiData.getSince());
		rs.updateString("AHI_LastUpdatedBy", ahiData.getLastUpdatedBy());

		rs.insertRow();

		rs.close();
		st.close();
	}

	/**
	 * Delete ALL HierarchyRole for a UserName
	 * @throws Exception
	 */
	public void clearRoles(String userName) throws Exception {

		Statement st = this.cn.createStatement();
		st.execute("DELETE FROM " + TBL_NAME + " WHERE AHI_NickName = '" + userName + "'");
		st.close();
	}

	/**
	 * Delete
	 * @throws Exception
	 */
	public void Delete(String userName, String hierRole, String geoRef) throws Exception {

		Statement st = this.cn.createStatement();

		st.executeUpdate(
			"DELETE FROM " + TBL_NAME + " " +
			"WHERE " +
				"(AHI_Nickname = '" + userName + "') AND " +
				"(AHI_Role = '" + hierRole + "') AND " +
				"(AHI_GeoRef = '" + geoRef + "')" +
			";"
		);

		st.close();
	}

	/**
	 * Check if a UserName have the specified HierarchyRole
	 */
	public boolean haveRole(String UserName, HierRole hierRole) {

		boolean rc = false;

		try {

			Statement st = this.cn.createStatement();

			ResultSet rs = st.executeQuery(
				"SELECT AHI_Role " +
				"FROM " + TBL_NAME + " " +
				"WHERE (" +
					"AHI_NickName = '" + UserName + "' AND " +
					"AHI_Role = '" + hierRole.getCode() + "'" +
				");"
			);

			rc = rs.next();

			rs.close();
			st.close();

		} catch (Exception e) { }

		return(rc);
	}

	/**
	 * Get start date for a specified UserName and HierarchyRole
	 */
	public Timestamp haveRoleSince(String UserName, HierRole hierRole) {

		Timestamp rc = FmtTool.DATEZERO;

		try {

			Statement st = this.cn.createStatement();

			ResultSet rs = st.executeQuery(
				"SELECT AHI_Since " +
				"FROM " + TBL_NAME + " " +
				"WHERE (" +
					"AHI_NickName = '" + UserName + "' AND " +
					"AHI_Role = '" + hierRole.getCode() + "'" +
				");"
			);

			if (rs.next())
				rc = rs.getTimestamp("AHI_Since");

			rs.close();
			st.close();

		} catch (Exception e) { }

		return(rc);
	}

	/**
	 * Get all Hierarchy.Data for a specified user and role
	 * @throws Exception
	 */
	public Vector<Data> getAllByRole(String userName, HierRole hierRole) throws Exception {

		return(
			_fill_ahi_vector(
				AHI_COMMON_SELECT_STATEMENT +
				"WHERE (" +
					"AHI_NickName = '" + userName + "' AND " +
					"AHI_Role = '" + hierRole.getCode() + "' " +
				") ORDER BY Location;"
			)
		);
	}

	/**
	 * Retrieve all Hierarchy.Data for a given CountryCode / HierarchyRole
	 * @throws Exception
	 */
	public Vector<Data> getAll(HierRole hierRole, String CountryCode) throws Exception {

		return(
			_fill_ahi_vector(
				AHI_COMMON_SELECT_STATEMENT +
				"WHERE (" +
					"AHI_Role = '" + hierRole.getCode() + "' AND " +
					"AHI_Georef LIKE '" + CountryCode + "%' " +
				") ORDER BY AHI_NickName;"
			)
		);
	}

	/**
	 * Create a Combo of Country Codes that have active users in Hierarchy (avoiding the "" country)
	 * @throws Exception
	 */
	public String getPopulatedCountriesCombo(String Default) {

		String rc = "", CouCode, CouDesc;

		try {

			Statement st = this.cn.createStatement();

			ResultSet rs = st.executeQuery(
				"SELECT DISTINCT LEFT(AHI_GeoRef, 3) AS CouCode, GEO_Name AS CouDesc " +
				"FROM " + TBL_NAME + " " +
					"LEFT JOIN AUTH_geo ON LEFT(AHI_GeoRef, 3) = GEO_Code " +
				"ORDER BY GEO_Name;"
			);

			while (rs.next()) {

				CouCode = rs.getString("CouCode");
				CouDesc = rs.getString("CouDesc");

				if (!CouCode.equals(""))
					rc += "<option " +
						"value=\"" + CouCode + "\"" + (CouCode.equals(Default) ? " selected" : "") + ">" +
						"[" + CouCode + "] " + CouDesc +
					"</option>";
			}

			rs.close();
			st.close();

		} catch (Exception e) {
			System.err.println("getPopulatedCountriesCombo(): " + e.toString());
		}

		return(rc);
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////
	//
	// +++ PRIVATE +++
	//
	////////////////////////////////////////////////////////////////////////////////////////////////////

	/**
	 * Read AHI Records based on given query
	 * @return Vector<Hierarchy.Data> of results 
	 * @throws Exception
	 */
	private Vector<Data> _fill_ahi_vector(String query) throws Exception {

		Data ahiData;
		Vector<Data> vecAhiData = new Vector<Data>();

		Statement st = this.cn.createStatement();
		ResultSet rs = st.executeQuery(query);

		while (rs.next()) {

			ahiData = new Data();

			ahiData.setID(rs.getInt("AHI_ID"));
			ahiData.setNickName(rs.getString("AHI_NickName"));
			ahiData.setGeoRef(rs.getString("AHI_GeoRef"));
			ahiData.setCountry(rs.getString("Country"));
			ahiData.setState(rs.getString("State"));
			ahiData.setDistrict(rs.getString("District"));
			ahiData.setLocation(rs.getString("Location"));
			ahiData.setRole(rs.getString("AHI_Role"));
			ahiData.setSince(rs.getTimestamp("AHI_Since"));
			ahiData.setLastUpdate(rs.getTimestamp("AHI_LastUpdate"));
			ahiData.setLastUpdatedBy(rs.getString("AHI_LastUpdatedBy"));
			ahiData.setFirstname(rs.getString("USR_Firstname"));
			ahiData.setLastName(rs.getString("USR_LastName"));
			ahiData.setMail(rs.getString("USR_Mail"));
			ahiData.setSlackID(rs.getString("USR_SlackID"));
			ahiData.setPhone(rs.getString("USR_Phone"));
			ahiData.setRank(rs.getInt("USR_Rank"));

			vecAhiData.add(ahiData);
		}

		rs.close();
		st.close();

		return(vecAhiData);
	}

}
