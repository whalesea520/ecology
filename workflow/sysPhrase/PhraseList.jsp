
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />


<HTML>
<HEAD>
	<LINK href = "/css/Weaver_wev8.css" type = "text/css" rel="STYLESHEET">
	<SCRIPT language = "javascript" src = "/js/weaver_wev8.js"></script>
</HEAD>
<%
    int userId = user.getUID();
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(17561,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(320,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
%>
	<BODY>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
		RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:location='PhraseAdd.jsp',_self} " ;
		RCMenuHeight += RCMenuHeightStep;

		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
     %>

	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<TABLE class=ListStyle >
	 <colgroup>
		<col width="15%">
		<col width="30%">
		<col width="55%">
		 <TR class = header>
		  <TH><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH> <%--added by xwj for td1802 on 2005-04-27--%>
			<TH><%=SystemEnv.getHtmlLabelName(18774,user.getLanguage())%></TH>
			<TH><%=SystemEnv.getHtmlLabelName(18775,user.getLanguage())%></TH>
		<TR>	
		<%  boolean isLight = false ;
			rs.executeProc("sysPhrase_selectByHrmId",""+userId) ;			
			while (rs.next()) {	
				String id = Util.null2String(rs.getString("id"));			
				String phraseShort = Util.null2String(rs.getString("phraseShort"));
				String phraseDesc = Util.null2String(rs.getString("phraseDesc"));				
				isLight = !isLight ;
		%>
			<%if (isLight) {%>
				<TR class=DataLight>
			<%}else{%>
				<TR class=datadark>
			<%}%>
					<%--added by xwj for td1802 on 2005-04-27--%>
					<TD><A href ="PhraseView.jsp?phraseId=<%=id%>"><%=id%></A></TD>			
					<TD><%=phraseShort%></TD>
					<TD><%=phraseDesc%></TD>			
		<%	}
		%>
	</TABLE>
	</BODY>
</HTML>
