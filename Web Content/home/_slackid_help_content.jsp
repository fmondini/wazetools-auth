<%@ page
	language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="net.danisoft.dslib.*"
%>
<%!
	private static final String HAMBURGER_MENU = "<span class=\"DS-padding-8px DS-border-full DS-border-round DS-back-AliceBlue\">&#9776</span>";
	private static final String OPTIONS_MENU = "<span class=\"DS-padding-8px DS-border-full DS-border-round DS-back-AliceBlue\">&nbsp;&#10247;</span>";

	private static String circledNo(int no) {
		return(
			"<span class=\"DS-text-black DS-text-bold\">" +
				"(" + no + ")" +
			"</span>"
		);
	}

	private static String menuKey(String key) {
		return(
			"<span class=\"DS-text-fixed-compact DS-text-bold DS-padding-lfrg-8px DS-border-full DS-border-round DS-back-FloralWhite\">" +
				key +
			"</span>"
		);
	}
%>
	<div class="mdc-layout-grid__inner">

		<div class="<%= MdcTool.Layout.Cell(6, 4, 4) %> DS-border-rg">
			<div class="DS-padding-updn-8px">
				<div class="DS-text-title-shadow">How to add your SlackID</div>
			</div>
			<div class="DS-padding-updn12px">
				<div class="DS-text-large"><%= circledNo(1) %> Click the upper-left menu <%= HAMBURGER_MENU %> icon</div>
			</div>
			<div class="DS-padding-updn12px">
				<div class="DS-text-large"><%= circledNo(2) %> Select <%= menuKey("GO") %> &#129054; <%= menuKey("Profile") %></div>
				<div class="DS-text-italic DS-padding-lfrg24px">&#8627; Your profile data is displayed on the right</div>
			</div>
			<div class="DS-padding-updn12px">
				<div class="DS-text-large"><%= circledNo(3) %> Click the options <%= OPTIONS_MENU %> icon in the profile</div>
			</div>
			<div class="DS-padding-updn12px">
				<div class="DS-text-large"><%= circledNo(4) %> Click <%= menuKey("Copy member ID") %></div>
				<div class="DS-text-italic DS-padding-lfrg24px">&#8627; Your Slack UserID will be copied to the clipboard</div>
			</div>
			<div class="DS-padding-updn12px">
				<div class="DS-text-large"><%= circledNo(5) %> Paste the copied UserID into your AUTH profile</div>
				<div class="DS-text-italic DS-padding-lfrg24px">&#8627; You can find your AUTH profile by <a href="../user/profile.jsp">clicking on this link</a>.</div>
			</div>
		</div>

		<div class="<%= MdcTool.Layout.Cell(6, 4, 4) %>">
			<div class="DS-padding-updn-8px">
				<div class="DS-text-title-shadow">Aggiungi il tuo SlackID</div>
			</div>
			<div class="DS-padding-updn12px">
				<div class="DS-text-large"><%= circledNo(1) %> Clicca sull'icona del menu <%= HAMBURGER_MENU %> in alto a sinistra</div>
			</div>
			<div class="DS-padding-updn12px">
				<div class="DS-text-large"><%= circledNo(2) %> Seleziona <%= menuKey("Vai") %> &#129054; <%= menuKey("Profilo") %></div>
				<div class="DS-text-italic DS-padding-lfrg24px">&#8627; Il box del tuo profilo appare sulla destra</div>
			</div>
			<div class="DS-padding-updn12px">
				<div class="DS-text-large"><%= circledNo(3) %> Clicca sull'icona delle opzioni <%= OPTIONS_MENU %> del profilo</div>
			</div>
			<div class="DS-padding-updn12px">
				<div class="DS-text-large"><%= circledNo(4) %> Clicca <%= menuKey("Copia ID del membro") %> <span class="DS-text-small DS-text-italic DS-text-gray">(ma chi l'ha tradotto?)</span></div>
				<div class="DS-text-italic DS-padding-lfrg24px">&#8627; Il tuo Slack UserID verr&agrave; copiato nella clipboard</div>
			</div>
			<div class="DS-padding-updn12px">
				<div class="DS-text-large"><%= circledNo(5) %> Incolla il tuo UserID nel tuo profilo di AUTH</div>
				<div class="DS-text-italic DS-padding-lfrg24px">&#8627; Il tuo profilo di AUTH lo puoi trovare <a href="../user/profile.jsp">cliccando questo link</a>.</div>
			</div>
		</div>

	</div>
