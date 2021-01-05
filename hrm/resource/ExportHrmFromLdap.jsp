<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.file.Prop"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.ldap.LdapUtil"%>
<%@ page import="ln.LN"%>
<%@ page import="weaver.integration.logging.Logger"%>
<%@ page import="weaver.integration.logging.LoggerFactory"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs2_wev8.css" rel="stylesheet" />
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/jQuery.modalDialog_wev8.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("intergration:ldapsetting", user)){
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}
Logger log = LoggerFactory.getLogger();
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(17743,user.getLanguage());
String needfav ="1";
String needhelp ="";
String needSynOrg = "";
String useldap = "";
String flage = "0";

weaver.soa.hrm.HrmService service = new weaver.soa.hrm.HrmService();
weaver.soa.hrm.ExportResult[] result = null;
String operation = Util.null2String(request.getParameter("operation"));
String lastupdate = Util.null2String(request.getParameter("lastupdate"));

if(lastupdate.equals("")){
	lastupdate = TimeUtil.getCurrentDateString();
}

if(operation.equals("all")){
	flage = "1";
	result = service.exportLdap();
}else if(operation.equals("time")){
	flage = "1";
	String type = Prop.getPropValue(weaver.general.GCONST.getConfigFile(), LdapUtil.TYPE);
	String syncdate = lastupdate+" 00:00:00";
	 Calendar today = weaver.general.TimeUtil.getCalendar(syncdate);
     Calendar syntoday=today;
     //减８个小时
     syntoday.set(Calendar.HOUR_OF_DAY, syntoday.get(Calendar.HOUR_OF_DAY)-8);
     syncdate=Util.add0(syntoday.get(Calendar.YEAR), 4)  + Util.add0(syntoday.get(Calendar.MONTH) + 1, 2) + Util.add0(syntoday.get(Calendar.DAY_OF_MONTH), 2)+Util.add0(syntoday.get(Calendar.HOUR_OF_DAY), 2)+Util.add0(syntoday.get(Calendar.MINUTE), 2)+Util.add0(syntoday.get(Calendar.SECOND), 2);
	if (type.equals("ad"))
		syncdate += ".0Z";
	result = service.exportLdapByTime(syncdate.replaceAll("-",""));
	
}
if(operation.equals("all") || operation.equals("time")){
	Calendar today = Calendar.getInstance();
	String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + Util.add0(today.get(Calendar.MONTH) + 1, 2) + Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
	LN l = new LN();
	if (l.CkHrmnum() >= 0) {  //reach the max hrm number
		log.info("====license====reach the max hrm number============");
	  
	} else {
		//String sql = "update ldapimporttime set usertime='" + currentdate + "'";
		//rs.executeSql(sql);
	}
}

rs.executeSql("select * from ldapset");
String ldapSyncMethod = "";
if(rs.next()) {
	needSynOrg = rs.getString("needSynOrg");
	useldap = rs.getString("isuseldap");
	ldapSyncMethod = rs.getString("ldapSyncMethod");
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	if(!"2".equals(ldapSyncMethod)) {
		RCMenu += "{" + SystemEnv.getHtmlLabelName(32632, user.getLanguage()) + ",javascript:syncAll(),_self} ";
		RCMenuHeight += RCMenuHeightStep;
		RCMenu += "{" + SystemEnv.getHtmlLabelName(32633, user.getLanguage()) + ",javascript:syncTime(),_self} ";
		RCMenuHeight += RCMenuHeightStep;
	}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="LdapForm" name="LdapForm" method="post" action="ExportHrmFromLdap.jsp">
<input type="hidden" name="operation">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<%
				if(!"2".equals(ldapSyncMethod)) {
			%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(32632 ,user.getLanguage()) %>" class="e8_btn_top" onclick="syncAll();"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(32633 ,user.getLanguage()) %>" class="e8_btn_top" onclick="syncTime();"/>
			<%
				}
			%>
			<span id="advancedSearch" class="advancedSearch" style='display:none;'><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>

		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=titlename%></span> 
</div>
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'>
</div>
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(32328,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
		<wea:item>
		<%=SystemEnv.getHtmlLabelName(31131,user.getLanguage())%>
		</wea:item>
		<wea:item>
		<button type=button  class=calendar id=lastupdateBtn  onclick="gettheDate(lastupdate,lastupdatespan)"></BUTTON>
		<SPAN id=lastupdatespan ><%=lastupdate%></SPAN>
		<input type="hidden" name="lastupdate" value="<%=lastupdate%>">
		</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(17743,user.getLanguage())%>' attributes="{'samePair':'ExportInfo','groupOperDisplay':'none','itemAreaDisplay':'block'}">
		<wea:item attributes="{'colspan':'2','isTableList':'true'}">
			<%if("1".equals(flage)) { %>
			<TABLE class=ListStyle cellspacing=1 >
			  <COLGROUP>
			  <COL width="20%">
			  <COL width="60%">
			  <COL width="20%">
			  </COLGROUP>
			  <%if("y".equals(needSynOrg) && "1".equals(useldap)) { %>
			  
			  <TBODY>
			  <TR class=header>
			    <Th><%=SystemEnv.getHtmlLabelName(32333,user.getLanguage())%></Th>
			    <Th><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></Th>
			    <Th><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></Th>
			  </TR>
			  <%
			    rs.executeSql("select * from addepmap where orgtype = '1' and status != '2' order by id");
			    int needchange0 = 0;
			    while (rs.next()) {
			    	String status = rs.getString("status");
			    	int note = 0;
			    	if("1".equals(status)) {
			    		note = 17744;
			    	}else if("0".equals(status)){
			    		note = 365;
			    	}
			        int isfirst = 1;
			        try {
			            if (needchange0 == 0) {
			                needchange0 = 1;
			 %>
			  <TR class=DataLight>
			 <%
			  	}else{
			  		needchange0=0;
			 %>
			     <TR class=DataDark>
			 <%
			   }
			 %>
			    <TD><%=rs.getString("dep")%>
			    </TD>
			    <TD><%=SystemEnv.getHtmlLabelName(note,user.getLanguage())%>
			    </TD>
			    <TD><%=SystemEnv.getHtmlLabelName(25008,user.getLanguage())%>
			    </TD>
			  </TR>
			  <%isfirst=0;
			      }catch(Exception e){
			       log.error(e.toString());
			      }
			
			    }
			%>
			  </TBODY>
			  <TBODY><tr></tr></TBODY>
			  <TBODY>
			  <TR class=header>
			    <Th><%=SystemEnv.getHtmlLabelName(32334,user.getLanguage())%></Th>
			    <Th><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></Th>
			    <Th><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></Th>
			  </TR>
			  <%
			    rs.executeSql("select * from addepmap where orgtype = '2' and status != '2' order by id");
			    int needchange1 = 0;
			    while (rs.next()) {
			    	String status = rs.getString("status");
			    	int note = 0;
			    	if("1".equals(status)) {
			    		note = 17744;
			    	}else if("0".equals(status)){
			    		note = 365;
			    	}
			        int isfirst = 1;
			        try {
			            if (needchange1 == 0) {
			                needchange1 = 1;
			 %>
			  <TR class=DataLight>
			 <%
			  	}else{
			  		needchange1=0;
			 %>
			     <TR class=DataDark>
			 <%
			   }
			 %>
			    <TD><%=rs.getString("dep")%>
			    </TD>
			    <TD><%=SystemEnv.getHtmlLabelName(note,user.getLanguage())%>
			    </TD>
			    <TD><%=SystemEnv.getHtmlLabelName(25008,user.getLanguage())%>
			    </TD>
			  </TR>
			  <%isfirst=0;
			      }catch(Exception e){
			        log.error(e.toString());
			      }
			
			    }
			%>
			  </TBODY>
			  <TBODY><tr></tr></TBODY>
			  <%} %>
			  <TBODY>
			  <TR class=header>
			    <Th><%=SystemEnv.getHtmlLabelName(81793,user.getLanguage())%></Th>
			    <Th><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></Th>
			    <Th><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></Th>
			  </TR>
			
			<%
			    
			    int needchange = 0;
			    for (int i = 0; result!=null && i < result.length; i++) {
			        int isfirst = 1;
			        try {
			            if (needchange == 0) {
			                needchange = 1;
			 %>
			  <TR class=DataLight>
			 <%
			  	}else{
			  		needchange=0;
			 %>
			     <TR class=DataDark>
			 <%
			   }
			 %>
			    <TD><%=result[i].getLastname()%>
			    </TD>
			    <TD><%=SystemEnv.getHtmlLabelName(Util.getIntValue(result[i].getOperation()),user.getLanguage())%>
			    </TD>
			    <TD><%=SystemEnv.getHtmlLabelName(Util.getIntValue(result[i].getStatus()),user.getLanguage())%>
			    </TD>
			  </TR>
			<%isfirst=0;
			      }catch(Exception e){
			        log.error(e.toString());
			      }
			
			    }
			%>
			 </TBODY></TABLE>
			 <%} %>
		</wea:item>
	</wea:group>
</wea:layout>
</form>

</BODY></HTML>
<script language="javascript">
/**
* 检测LDAP是否启用
* @returns {boolean} true：启用，false：未启用
*/
function checkLdapUser() {

    if("1" == "<%=useldap%>"){
		return true;
    }else{
        top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("34148,32386",user.getLanguage()) %>");
        return false
	}
}
	
function syncAll(){
	if(!checkLdapUser()){
	    return;
	}
	if(""==document.LdapForm.operation.value){//防止多次点击
		document.LdapForm.operation.value = "all";
		document.LdapForm.submit();
	}
}
function syncTime(){
    if(!checkLdapUser()){
        return;
    }
	if(""==document.LdapForm.operation.value){//防止多次点击
		document.LdapForm.operation.value = "time";
		document.LdapForm.submit();
	}
}
</script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
