<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>


<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String reportid=Util.null2String(request.getParameter("reportid"));
int sharelevel = 0 ;
RecordSet.executeSql("select sharelevel from WorkflowReportShareDetail where userid="+user.getUID()+" and usertype=1 and reportid="+reportid);
if(RecordSet.next()) {
    sharelevel = Util.getIntValue(RecordSet.getString("sharelevel"),0) ;
}
else {
    response.sendRedirect("/notice/noright.jsp");
    return;
}

String department=Util.null2String(request.getParameter("Department"));
String fromdate=Util.null2String(request.getParameter("fromdate"));
String todate=Util.null2String(request.getParameter("todate"));
int userid=user.getUID();

if(department.equals("")){
	department=""+user.getUserDepartment();
}
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
int dayofweek=today.get(Calendar.DAY_OF_WEEK);
int thisyear=today.get(Calendar.YEAR);
int thismonth=today.get(Calendar.MONTH);
int thisday=today.get(Calendar.DAY_OF_MONTH)+1;
int fromday=thisday-(dayofweek-1);
int endday=thisday+(7-dayofweek);
today.set(thisyear,thismonth,fromday);
String weekfromdate= Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
today.set(thisyear,thismonth,endday);
String weekenddate= Util.add0(today.get(Calendar.YEAR), 4) +"-"+
               Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
               Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
if(fromdate.equals("")&&todate.equals("")){
    fromdate=weekfromdate;
    todate=weekenddate;
}
    
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1308,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:weaver.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
String sqlstr = "select t1.resourceid, t1.departmentid,t2.type,t2.workname,t2.workdesc,t2.forecastdate "+
                " from bill_workinfo  t1,bill_weekinfodetail  t2 "+
                " where t1.id = t2.infoid and t1.manager=" +userid+ " and t1.departmentid="+department;
if(!fromdate.equals(""))
    sqlstr+=" and t1.createdate>='"+fromdate+"' ";
if(!todate.equals(""))
    sqlstr+=" and t1.createdate<='"+todate+"' ";
    
sqlstr+=" order by t1.resourceid,t2.type asc,t1.createdate desc" ;

RecordSet.executeSql(sqlstr);


%>
<form name=weaver method=post action="HrmWeekWorkRp.jsp">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">


<table class="viewform">
  <colgroup>
  <col width="10%">
  <col width="40%">
  <col width="10%">
  <col width="40%">
  <tbody>
  <tr>
	<td align=center><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
	<td class=field>
          <button type='button' class=Browser id=SelectDeparment onClick="onShowDepartment()"></button>
              <span class=Inputstyle id=departmentspan><%=Util.toScreen(DepartmentComInfo.getDepartmentname(department),user.getLanguage())%></span> 
              <input id=departmentid type=hidden name=Department value="<%=department%>"></TD>

	</td>
	<td align=center><%=SystemEnv.getHtmlLabelName(446,user.getLanguage())%></td>
	<td class=field>
	  <BUTTON type='button' class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
      <SPAN id=fromdatespan ><%=fromdate%></SPAN>
      -&nbsp;&nbsp;<BUTTON type='button' class=calendar 
      id=SelectDate2 onclick="gettoDate()"></BUTTON>&nbsp;
      <SPAN id=todatespan><%=todate%></SPAN>
	  <input type="hidden" name="fromdate" value="<%=fromdate%>"><input type="hidden" name="todate" value="<%=todate%>">
	</td>
  </tr>
</tbody>
</table>

<table class=liststyle cellspacing=1  >
<colgroup>



<%
boolean islight=true;
boolean newtype=true;
String curtype="";
float totaldeptamount=0;
String curresource="";
int xuhao=0;
while(RecordSet.next()){
	String resourcename=ResourceComInfo.getResourcename(RecordSet.getString("resourceid"));
		   department=DepartmentComInfo.getDepartmentname(RecordSet.getString("departmentid"));
	String type=RecordSet.getString("type");
	String workname=RecordSet.getString("workname");
	String workdesc=RecordSet.getString("workdesc");
	String forecastdate=RecordSet.getString("forecastdate");
	if(resourcename.equals(curresource)){
		resourcename="";
	}else{
		curresource = resourcename;
		curtype="";
	}
	if(type.equals(curtype)){
		newtype=false;
		xuhao+=1;
	}else{
		curtype = type;
		newtype=true;
		xuhao=1;
	}
%>
<%if(type.equals("1")){%>
	<%if(newtype){%>
<TR CLASS=DataDark>
  <td><%=resourcename%></td>
  <td colspan=4 align=center class=fontred><%=SystemEnv.getHtmlLabelName(15493,user.getLanguage())%></td>
</TR>
<TR CLASS=DataDark>
  <td></td>
  <td class=fontred><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></td>
  <td class=fontred><%=SystemEnv.getHtmlLabelName(15494,user.getLanguage())%></td>
  <td class=fontred><%=SystemEnv.getHtmlLabelName(15495,user.getLanguage())%></td>
  <td></td>
</TR>
	<%
		resourcename="";  
    }%>
<TR CLASS=DataDark>

  <td><%=resourcename%></td>
  <td><%=xuhao%></td>
  <td><%=workname%></td>
  <td><%=workdesc%></td>
  <td></td>
</TR>
<%}else if(type.equals("2")){%>
	<%if(newtype){%>
<TR CLASS=DataDark>
  <td><%=resourcename%></td>
  <td class=fontred><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></td>
  <td class=fontred><%=SystemEnv.getHtmlLabelName(15496,user.getLanguage())%></td>
  <td class=fontred><%=SystemEnv.getHtmlLabelName(15497,user.getLanguage())%></td>
  <td></td>
</TR>
<TR class=Line><TD colspan="4" ></TD></TR> 
	<%
		resourcename="";  
    }%>
<TR CLASS=DataDark>

  <td><%=resourcename%></td>
  <td><%=xuhao%></td>
  <td><%=workname%></td>
  <td><%=workdesc%></td>
  <td></td>
</TR>
<%}else if(type.equals("3")){%>
	<%if(newtype){%>
<TR CLASS=DataDark>
  <td><%=resourcename%></td>
  <td colspan=4 align=center class=fontred><%=SystemEnv.getHtmlLabelName(15498,user.getLanguage())%></td>
</TR>
<TR CLASS=DataDark>
  <td></td>
  <td class=fontred><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></td>
  <td class=fontred><%=SystemEnv.getHtmlLabelName(15499,user.getLanguage())%></td>
  <td class=fontred><%=SystemEnv.getHtmlLabelName(15500,user.getLanguage())%></td>
  <td class=fontred><%=SystemEnv.getHtmlLabelName(15501,user.getLanguage())%></td>
</TR>
<TR class=Line><TD colspan="5" ></TD></TR> 
	<%
		resourcename="";  
    }%>
<TR CLASS=DataDark>

  <td><%=resourcename%></td>
  <td><%=xuhao%></td>
  <td><%=workname%></td>
  <td><%=forecastdate%></td>
  <td><%=workdesc%></td>
</TR>
<%}%>
	 
<%
	islight=!islight;
}
%>
</table>

		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>	
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>


</form>
</body>
<%
    String sqlwhere="";
    if(sharelevel<2){
        if(sharelevel==1)   sqlwhere="?sqlwhere=where subcompanyid1 = " + user.getUserSubCompany1() ;
        else    sqlwhere="?sqlwhere=where id = " + user.getUserDepartment() ;
    }
%>
<script language=vbs>
sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp<%=sqlwhere%>&selectedids="&weaver.Department.value)
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	departmentspan.innerHtml = id(1)
	weaver.Department.value=id(0)
	else
	departmentspan.innerHtml = ""
	weaver.Department.value=""
	end if
	end if
end sub
</script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>