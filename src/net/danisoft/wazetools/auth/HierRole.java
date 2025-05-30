////////////////////////////////////////////////////////////////////////////////////////////////////
//
// HierRole.java
//
// AUTH Hierarchical roles
//
// First Release: ???/???? by Fulvio Mondini (https://danisoft.software/)
//       Revised: Mar/2025 Ported to Waze dslib.jar
//
////////////////////////////////////////////////////////////////////////////////////////////////////

package net.danisoft.wazetools.auth;

/**
 * AUTH Hierarchical roles
 */
public enum HierRole {

	// Please keep roles in order of importance

	COORD ("CO", "Coordinator",					1, "Country"),
	GCHMP ("GC", "Global Champ",				1, "Country"),
	GCEMR ("GE", "Emeritus Champ",				1, "Country"),
	COMGR ("CM", "Country Manager",				1, "Country"),
	LCHMP ("LC", "Local Champ",					1, "Country"),
	STATM ("SM", "State/Region Manager",		2, "State"),
	DISTM ("DM", "District/Province Manager",	3, "District"),
	AREAM ("AM", "Area Manager",				0, ""),
	UNKNW ("XX", "Unknown",						0, "");

	private final String	_Code;
	private final String	_Desc;
	private final int		_GeoLevelDeep;
	private final String	_GeoLevelDesc;

	HierRole(String Code, String Desc, int GeoLevelDeep, String GeoLevelDesc) {
		this._Code = Code;
		this._Desc = Desc;
		this._GeoLevelDeep = GeoLevelDeep;
		this._GeoLevelDesc = GeoLevelDesc;
    }

	public String	getCode()			{ return(this._Code);			}
	public String	getDesc()			{ return(this._Desc);			}
	public int		getGeoLevelDeep()	{ return(this._GeoLevelDeep);	}
	public String	getGeoLevelDesc()	{ return(this._GeoLevelDesc);	}

	/**
	 * GET Enum by Code
	 */
	public static HierRole getEnum(String Code) {

		HierRole rc = UNKNW;

		for (HierRole X : HierRole.values())
			if (X.getCode().equals(Code))
				rc = X;

		return(rc);
	}

	/**
	 * Description
	 */
	public static String getDesc(String Code) {

		String rc = UNKNW.getDesc();

		for (HierRole X : HierRole.values())
			if (X.getCode().equals(Code))
				rc = X.getDesc();

		return(rc);
	}

	/**
	 * Create Combo
	 */
	public static String getCombo(String Default) {

		String rc = "";

		for (HierRole X : HierRole.values())
			rc += "<option " +
				"value=\"" + X.getCode() + "\"" + (X.getCode().equals(Default) ? " selected" : "") + ">" +
				"[" + X.getCode() + "] " + X.getDesc() +
			"</option>";

		return(rc);
	}

}
