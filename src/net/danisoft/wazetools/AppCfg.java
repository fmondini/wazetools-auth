////////////////////////////////////////////////////////////////////////////////////////////////////
//
// AppCfg.java
//
// main application configuration file
//
// First Release: May/2025 by Fulvio Mondini (https://danisoft.software/)
//
////////////////////////////////////////////////////////////////////////////////////////////////////

package net.danisoft.wazetools;

import net.danisoft.dslib.AppList;
import net.danisoft.dslib.FmtTool;
import net.danisoft.dslib.SiteCfg;
import net.danisoft.dslib.SysTool;

/**
 * Main application configuration file
 */
public class AppCfg {

	////////////////////////////////////////////////////////////////////////////////////////////////////
	//
	// Editable parameters
	//

	private static final int	APP_VERS_MAJ = 3;
	private static final int	APP_VERS_MIN = 0;
	private static final String	APP_VERS_REL = "GA";
	private static final String	APP_DATE_REL = "May 30, 2025";

	private static final String	APP_NAME_TAG = AppList.AUTH.getName();
	private static final String	APP_NAME_TXT = "Waze.Tools " + APP_NAME_TAG;
	private static final String	APP_ABSTRACT = "Waze.Tools Suite AUTH Manager";
	private static final String	APP_EXITLINK = "https://waze.tools/";

	private static final String	SERVER_ROOTPATH_DEVL = "C:/WorkSpace/Eclipse/Waze.Tools/wazetools-auth/Web Content";
	private static final String	SERVER_ROOTPATH_PROD = "/var/www/html/auth.waze.tools/Web Content";

	private static final String	SERVER_HOME_URL_DEVL = "http://localhost:8080/auth.waze.tools";
	private static final String	SERVER_HOME_URL_PROD = "https://auth.waze.tools";

	// Login stuff
	private static final String	ONLOGOUT_URL = "../home/";

	// Slack stuff
	private static final String	SLACK_BTNAME = "AUTH_TestBot";
	private static final String	SLACK_BTEMOJ = ":bowtie:";

	////////////////////////////////////////////////////////////////////////////////////////////////////
	//
	// Getters
	//

	public static final String getAppTag()				{ return(APP_NAME_TAG);	}
	public static final String getAppName()				{ return(APP_NAME_TXT);	}
	public static final String getAppAbstract()			{ return(APP_ABSTRACT);	}
	public static final String getAppVersion()			{ return(APP_VERS_MAJ + "." + FmtTool.fmtZeroPad(APP_VERS_MIN, 2) + "." + APP_VERS_REL); }
	public static final String getAppRelDate()			{ return(APP_DATE_REL);	}
	public static final String getAppExitLink()			{ return(APP_EXITLINK);	}
	public static final String getServerRootPath()		{ return(SysTool.isWindog() ? SERVER_ROOTPATH_DEVL : SERVER_ROOTPATH_PROD); }
	public static final String getServerHomeUrl()		{ return(SysTool.isWindog() ? SERVER_HOME_URL_DEVL : SERVER_HOME_URL_PROD); }

	// Login stuff
	public static final String getAuthDefaultUser()		{ return(SysTool.isWindog() ? new SiteCfg().getPrivateParams().getDebugUser() : ""); }
	public static final String getAuthDefaultPass()		{ return(SysTool.isWindog() ? new SiteCfg().getPrivateParams().getDebugPass() : ""); }
	public static final String getAuthOnLogoutUrl()		{ return(ONLOGOUT_URL); }

	// Slack stuff
	public static final String getSlackBotName()		{ return(SLACK_BTNAME); }
	public static final String getSlackBotEmoji()		{ return(SLACK_BTEMOJ); }
	public static final String getSlackSecretToken()	{ return(new SiteCfg().getPrivateParams().getSlackToken()); }

	// iBot stuff
	public static final String getIBotFullAreasUrl()	{ return(new SiteCfg().getPrivateParams().getIBotFullAreasUrl()); }

	////////////////////////////////////////////////////////////////////////////////////////////////////
	//
	// Local strings
	//

	// Anonymous
	public static final String DESCR_ANON_ICON = "no_accounts";
	public static final String DESCR_ANON_NAME = "Anonymous";
	public static final String DESCR_ANON_HEAD = "For ALL Users";
	public static final String DESCR_ANON_ABST = "Simple tools like password recovery";
	public static final String DESCR_ANON_TEXT = "In this path you will find some basic utilities, such as the password recovery mechanism.";
	public static final String DESCR_ANON_LINK = "../anonymous/";

	// Registered
	public static final String DESCR_USER_ICON = "account_circle";
	public static final String DESCR_USER_NAME = "Users";
	public static final String DESCR_USER_HEAD = "For Registered Users";
	public static final String DESCR_USER_ABST = "Manage your personal data";
	public static final String DESCR_USER_TEXT = "In this path the user will find a tool to modify his profile and some other utilities.<br>Note that the dedicated settings of an application are accessible only from the settings page of that application.";
	public static final String DESCR_USER_LINK = "../user/";

	// Administrators
	public static final String DESCR_ADMN_ICON = "manage_accounts";
	public static final String DESCR_ADMN_NAME = "Admins";
	public static final String DESCR_ADMN_HEAD = "Administrators only";
	public static final String DESCR_ADMN_ABST = "Manage all users permissions";
	public static final String DESCR_ADMN_TEXT = "ADMIN accounts can edit almost everything and assign user roles used across the entire Waze.Tools universe in the country they have access to.<br>To get ADMIN access, you must be a Waze Country Administrator and request it by writing to dev [at] waze [dot] tools.<br>ADMIN credentials also grant access to lower-level paths.<br><br><div class=\"DS-text-italic DS-text-exception\">NOTE: Administrators have their rights only on the country to which they belong.</div>";
	public static final String DESCR_ADMN_LINK = "../admin/";
}
