////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Cones.java
//
// AUTH User Cones
//
// First Release: ???/???? by Fulvio Mondini (https://danisoft.software/)
//       Revised: Mar/2025 Ported to Waze dslib.jar
//
////////////////////////////////////////////////////////////////////////////////////////////////////

package net.danisoft.wazetools.auth;

/**
 * AUTH User Cones
 */
public enum Cones {

	C0	(0, "Unknown Status"),
	C1	(1, "Baby Editor"),
	C2	(2, "Junior Editor"),
	C3	(3, "Area Manager"),
	C4	(4, "Advanced Editor"),
	C5	(5, "Senior Editor"),
	C6	(6, "Monster Editor"),
	C7	(7, "STAFF-ONLY");

	private final int		_Cones;
	private final String	_Descr;

	Cones(int cones, String descr) {
		this._Cones = cones;
		this._Descr = descr;
    }

	public int		getCones() { return(this._Cones); }
	public String	getDescr() { return(this._Descr); }

	/**
	 * Create Combo
	 */
	public static String getCombo(int Default) {

		String rc = "";

		for (Cones X : Cones.values())
			rc +=
				"<option value=\"" + X.getCones() + "\"" + (X.getCones() == Default ? " selected" : "") + ">" +
					"[" + X.getCones() + "] " + X.getDescr() +
				"</option>"
			;

		return(rc);
	}

}
