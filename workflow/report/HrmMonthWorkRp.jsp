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
String department=Util.null2String(request.getParameter("Department"));
String checkmonth=Util.null2String(request.getParameter("checkmonth"));

int userid=user.getUID();

if(department.equals("")){
	department=""+user.getUserDepartment();
}
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
int thisyear=today.get(Calendar.YEAR);
int thismonth=today.get(Calendar.MONTH);
int thisday=today.get(Calendar.DAY_OF_MONTH)+1;

if(!checkmonth.equals("")){
    thismonth=Util.getIntValue(checkmonth,0);
}
int fromday=1;
int endday=1;
today.set(thisyear,thismonth,fromday);
String fromdate= Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
today.set(thisyear,thismonth+1,endday);
String enddate=Util.add0(today.get(Calendar.YEAR), 4) +"-"+
               Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
               Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
    
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1039,user.getLanguage());
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
String sqlstr = "select t1.resourceid, t1.departmentid,t2.type,t2.targetname,t2.targetresult,t2.forecastdate,t2.scale,t2.point "+
                " from bill_workinfo  t1,bill_monthinfodetail  t2 "+
                " where t1.id = t2.infoid and t1.manager=" +userid+ " and t1.departmentid="+department;
if(!fromdate.equals(""))
    sqlstr+=" and t1.createdate>='"+fromdate+"' ";
if(!enddate.equals(""))
    sqlstr+=" and t1.createdate<'"+enddate+"' ";
    
sqlstr+=" order by t1.resourceid asc,t1.createdate,t2.type desc" ;

RecordSet.executeSql(sqlstr);

%>
<form name=weaver method=post action="HrmMonthWorkRp.jsp">
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
	<td align=center><%=SystemEnv.getHtmlLabelName(887,user.getLanguage())%></td>
	<td class=field>
	  <select class=Inputstyle  name="checkmonth" size=1>
	    <option value=0 <%if(thismonth==0){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1492,user.getLanguage())%></option>
	    <option value=1 <%if(thismonth==1){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1493,user.getLanguage())%></option>
	    <option value=2 <%if(thismonth==2){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1494,user.getLanguage())%></option>
	    <option value=3 <%if(thismonth==3){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1495,user.getLanguage())%></option>
	    <option value=4 <%if(thismonth==4){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1496,user.getLanguage())%></option>
	    <option value=5 <%if(thismonth==5){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1497,user.getLanguage())%></option>
	    <option value=6 <%if(thismonth==6){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1498,user.getLanguage())%></option>
	    <option value=7 <%if(thismonth==7){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1499,user.getLanguage())%></option>
	    <option value=8 <%if(thismonth==8){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1800,user.getLanguage())%></option>
	    <option value=9 <%if(thismonth==9){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1801,user.getLanguage())%></option>
	    <option value=10<%if(thismonth==10){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1802,user.getLanguage())%></option>
	    <option value=11<%if(thismonth==11){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1803,user.getLanguage())%></option>
	  </select>
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
	String targetname=RecordSet.getString("targetname");
	String targetresult=RecordSet.getString("targetresult");
	String forecastdate=RecordSet.getString("forecastdate");
	String scale=RecordSet.getString("scale");
	String point=RecordSet.getString("point");
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
<%if(type.equals("2")){%>
	<%if(newtype){%>
<TR CLASS=DataDark>
  <td><%=resourcename%></td>
  <td colspan=5 align=center class=fontred><%=SystemEnv.getHtmlLabelName(15485,user.getLanguage())%></td>
</TR>
<TR CLASS=DataDark>
  <td></td>
  <td class=fontred><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></td>
  <td class=fontred><%=SystemEnv.getHtmlLabelName(15487,user.getLanguage())%></td>
  <td class=fontred><%=SystemEnv.getHtmlLabelName(15488,user.getLanguage())%></td>
  <td class=fontred><%=SystemEnv.getHtmlLabelName(15489,user.getLanguage())%></td>
  <td></td>
</TR>
  <TR class=Line><TD colspan="6" ></TD></TR> 
	<%
		resourcename="";  
    }%>
<TR CLASS=DataDark>

  <td><%=resourcename%></td>
  <td><%=xuhao%></td>
  <td><%=Util.toScreen(targetresult,user.getLanguage())%></td>
  <td><%=scale%></td>
  <td><%if(!point.equals("0")){%><%=point%><%}%></td>
  <td></td>
</TR>
<%}else if(type.equals("1")){%>
	<%if(newtype){%>
<TR CLASS=DataDark>
  <td><%=resourcename%></td>
  <td colspan=5 align=center class=fontred><%=SystemEnv.getHtmlLabelName(15490,user.getLanguage())%></td>
</TR>
<TR CLASS=DataDark>
  <td></td>
  <td class=fontred><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></td>
  <td class=fontred><%=SystemEnv.getHtmlLabelName(15491,user.getLanguage())%></td>
  <td class=fontred><%=SystemEnv.getHtmlLabelName(15492,user.getLanguage())%></td>
  <td class=fontred><%=SystemEnv.getHtmlLabelName(1035,user.getLanguage())%></td>
  <td class=fontred><%=SystemEnv.getHtmlLabelName(15488,user.getLanguage())%></td>
</TR>
	<%
		resourcename="";  
    }%>
<TR CLASS=DataDark>

  <td><%=resourcename%></td>
  <td><%=xuhao%></td>
  <td><%=Util.toScreen(targetname,user.getLanguage())%></td>
  <td><%=Util.toScreen(targetresult,user.getLanguage())%></td>
  <td><%=forecastdate%></td>
  <td><%=scale%></td>
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
<script language=vbs>
sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&weaver.Department.value)
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