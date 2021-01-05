<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SystemComInfo" class="weaver.system.SystemComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String isdefalue = Util.null2String(request.getParameter("isdefalue")) ;
String fromdate = Util.null2String(request.getParameter("fromdate")) ;
String todate = Util.null2String(request.getParameter("todate")) ;
String classname = Util.null2String(request.getParameter("classname")) ;
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
				 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
				 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
if(fromdate.equals("") && !isdefalue.equals("1")) fromdate = currentdate ;
if(todate.equals("") && !isdefalue.equals("1")) todate = currentdate ;

String logleaveday = SystemComInfo.getLogleaveday() ;
if(!logleaveday.equals("0") && !SystemComInfo.getHasdeletelog()) {
	today.add(Calendar.DATE, (-1)*Util.getIntValue(logleaveday,0)) ;
	String lastdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
				 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
				 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
	RecordSet.executeProc("SystemLog_Delete",lastdate) ;
	SystemComInfo.setHasdeletelog(true) ;
}

String sqlstr = "select id, createdate,createtime,classname,sqlstr from SystemLog " ;
int headwhere = 0 ;

if(!fromdate.equals("")) {
sqlstr += " where createdate >= '"+ fromdate +"' ";
headwhere = 1 ;
}
if(!todate.equals("")) {
	if(headwhere==0) {
		sqlstr += " where createdate <= '"+ todate +"' ";
		headwhere = 1 ;
	}
	else sqlstr += " and createdate <= '"+ todate +"' ";
}

if(!classname.equals("")) {
	if(headwhere==0) {
		sqlstr += " where LOWER(classname) like '%"+ classname.toLowerCase() +"%' ";
		headwhere = 1 ;
	}
	else sqlstr += " and LOWER(classname) like '%"+ classname.toLowerCase() +"%' ";
}
sqlstr += " order by createdate desc ,createtime desc " ;

String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(775,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<FORM id=weaver name=frmMain action="SystemLogView.jsp" method=post>
<DIV class=HdrProps></DIV>

  <BUTTON class=BtnRefresh id=cmdRefresh accessKey=R 
      type="submit" name=cmdRefresh><U>R</U>-<%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%></BUTTON> 
  <input type="hidden" name="isdefalue" value="1">
  <TABLE class=form>
    <COLGROUP> <COL width="20%"> <COL width="30%"> <COL width="20%"> <COL width="30%"> 
    <TBODY> 
    <TR class=Section> 
      <TH colSpan=4><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH>
    </TR>
    <TR class=separator> 
      <TD class=Sep1 colSpan=4 ></TD>
    </TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(2060,user.getLanguage())%></td>
      <td class=Field> 
        <input type="text" name="classname" size="20" maxlength="30"  value="<%=classname%>">
      </td>
      <td><%=SystemEnv.getHtmlLabelName(2061,user.getLanguage())%></td>
      <td class=Field><button class=calendar id=SelectDate onClick="getDate(fromdatespan,fromdate)"></button>&nbsp; 
        <span id=fromdatespan ><%=fromdate%></span> 
        -&nbsp;&nbsp;<button class=calendar 
      id=SelectDate2 onClick="getDate(todatespan,todate)"></button>&nbsp; <SPAN id=todatespan><%=todate%></span> 
        <input type="hidden" name="fromdate" value="<%=fromdate%>">
        <input type="hidden" name="todate" value="<%=todate%>">
      </td>
    </tr>
    </TBODY> 
  </TABLE>
 </form>
 
<br>
 
<TABLE class=ListShort>
  <COLGROUP> <COL width="20%"> <COL width="20%"> <COL width="60%"> 
  <TBODY> 
  <TR class=Section> 
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%></TH>
  </TR>
  <TR class=separator> 
    <TD class=Sep1 colSpan=3 ></TD>
  </TR>
  <TR class=Header> 
    <TD><%=SystemEnv.getHtmlLabelName(2061,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(2060,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></TD>
  </TR>
  <%
    int needchange = 0;
	RecordSet.executeSql(sqlstr);
	while(RecordSet.next()) {
		String createdates = Util.null2String(RecordSet.getString("createdate")) ;
		String createtimes = Util.null2String(RecordSet.getString("createtime")) ;
		String classnames = Util.null2String(RecordSet.getString("classname")) ;
		String sqlstrs = Util.null2String(RecordSet.getString("sqlstr")) ;
       	if(needchange ==0){
       		needchange = 1;
%>
  <TR class=datalight>
  <%
  	}else{
  		needchange=0;
  %><TR class=datadark>
  <% }%>
    <TD><%=createdates%> <%=createtimes%></TD>
    <TD><%=classnames%></TD>
    <TD><%=sqlstrs%></TD>
  </TR>
  <%}%>
  </TBODY> 
</TABLE>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
