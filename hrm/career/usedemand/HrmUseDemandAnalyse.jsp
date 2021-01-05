<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page"/>
<jsp:useBean id="UseKindComInfo" class="weaver.hrm.job.UseKindComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
Calendar todaycal = Calendar.getInstance ();
  String today = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;
String userid =""+user.getUID();

String department = Util.null2String(request.getParameter("department"));
String jobactivity = Util.null2String(request.getParameter("jobactivity"));
String jobtitle = Util.null2String(request.getParameter("jobtitle"));
String leastedulevel = Util.null2String(request.getParameter("leastedulevel"));
String demandkind = Util.null2String(request.getParameter("demandkind"));
String regdate = Util.null2String(request.getParameter("regdate"));
String regdateTo = Util.null2String(request.getParameter("regdateTo"));

if(regdateTo.equals("")){
  regdateTo = today;
}
String sqlwhere = "";
int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!department.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where demandjobtitle in (select id from HrmJobTitles where departmentid =" + Util.fromScreen2(department,user.getLanguage()) +") ";
	}
	else 
		sqlwhere += " and demandjobtitle in (select id from HrmJobTitles where departmentid =" + Util.fromScreen2(department,user.getLanguage()) +") ";		
}
if(!jobactivity.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where demandjobtitle in (select id from HrmJobTitles where jobactivityid =" + Util.fromScreen2(jobactivity,user.getLanguage()) +") ";
	}
	else 
		sqlwhere += " and demandjobtitle in (select id from HrmJobTitles where jobactivityid =" + Util.fromScreen2(jobactivity,user.getLanguage()) +") ";
}
if(!jobtitle.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where jobtitle =" + Util.fromScreen2(jobtitle,user.getLanguage()) +" ";
	}
	else 
		sqlwhere += " and jobtitle  =" + Util.fromScreen2(jobtitle,user.getLanguage()) +" ";		
}
if(!leastedulevel.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where leastedulevel =" + Util.fromScreen2(leastedulevel,user.getLanguage()) +" ";
	}
	else 
		sqlwhere += " and leastedulevel  =" + Util.fromScreen2(leastedulevel,user.getLanguage()) +" ";		
}
if(!demandkind.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where demandkind =" + Util.fromScreen2(demandkind,user.getLanguage()) +" ";
	}
	else 
		sqlwhere += " and demandkind  =" + Util.fromScreen2(demandkind,user.getLanguage()) +" ";		
}
if(!regdate.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where demandregdate >='" + Util.fromScreen2(regdate,user.getLanguage()) +"' ";
	}
	else 
		sqlwhere += " and demandregdate >='" + Util.fromScreen2(regdate,user.getLanguage()) +"' ";
}
if(!regdateTo.equals("")){
	if(ishead==0){
		ishead = 1;
		if(rs.getDBType().equals("oracle")){
		sqlwhere += " where (demandregdate is not null and demandregdate <='" + Util.fromScreen2(regdateTo,user.getLanguage()) +"') ";
		}else{
		sqlwhere += " where (demandregdate <> '' and demandregdate <='" + Util.fromScreen2(regdateTo,user.getLanguage()) +"') ";
		}
	}
	else 
	   if(rs.getDBType().equals("oracle")){
		sqlwhere += " and (demandregdate is not null and demandregdate <='" + Util.fromScreen2(regdateTo,user.getLanguage()) +"') ";
		} else{
		sqlwhere += " and (demandregdate <>'' and demandregdate <='" + Util.fromScreen2(regdateTo,user.getLanguage()) +"') ";
		}
}

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+SystemEnv.getHtmlLabelName(352,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
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
<FORM id=weaver name=frmain action="HrmUseDemandAnalyse.jsp" method=post>
<input type="hidden" name="orderby" value="departmentid">
  <table class=viewform>
    <colgroup>
    <col width="10%"> 
    <col width="20%">
    <col width="10%"> 
    <col width="25%">
    <col width="10%"> 
    <col width="25%"><tbody> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
      <td class=Field><button class=Browser id=SelectDepartmentID onClick="onShowDepartmentID()"></button> 
        <span id=departmentspan><%=DepartmentComInfo.getDepartmentname(department)%></span> 
        <input class=inputstyle id=department type=hidden name=department value="<%=department%>">
      </td>
      <td><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%></td>
      <td class=Field>
        <BUTTON class=Browser onClick="onShowJobActivity()"></BUTTON> 
        <span class=inputstyle id=jobactivityspan> <%=JobActivitiesComInfo.getJobActivitiesname(jobactivity)%></span> 
        <INPUT class=inputstyle id=jobactivity type=hidden name=jobactivity value="<%=jobactivity%>">
      </td>
      <td><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></td>
      <TD class=Field>
            <BUTTON class=Browser id=SelectJobTitle onclick="onShowJobtitle()"></BUTTON> 
              <SPAN id=jobtitlespan><%=JobTitlesComInfo.getJobTitlesname(jobtitle)%> 
              </SPAN> 
              <INPUT id=jobtitle type=hidden name=jobtitle value="<%=jobtitle%>"> 
          </td>
        </tr>      
      <TR><TD class=Line colSpan=6></TD></TR> 
    <tr>
      <TD><%=SystemEnv.getHtmlLabelName(1860,user.getLanguage())%></TD>
          <TD class=Field>
            <select class=inputstyle id=leastedulevel name="leastedulevel" value="<%=leastedulevel%>">
	            <option value=0 <%if(leastedulevel.equals("0")){%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%></option>
	            <option value=1 <%if(leastedulevel.equals("1")){%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(819,user.getLanguage())%></option>
	            <option value=2 <%if(leastedulevel.equals("2")){%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(764,user.getLanguage())%></option>
	            <option value=12 <%if(leastedulevel.equals("12")){%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(2122,user.getLanguage())%></option>
	            <option value=13 <%if(leastedulevel.equals("13")){%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(2123,user.getLanguage())%></option>
	            <option value=3 <%if(leastedulevel.equals("3")){%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(820,user.getLanguage())%></option>
	            <option value=4 <%if(leastedulevel.equals("4")){%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(765,user.getLanguage())%></option>
	            <option value=5 <%if(leastedulevel.equals("5")){%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(766,user.getLanguage())%></option>
	            <option value=6 <%if(leastedulevel.equals("6")){%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(767,user.getLanguage())%></option>
	            <option value=7 <%if(leastedulevel.equals("7")){%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(768,user.getLanguage())%></option>
	            <option value=8 <%if(leastedulevel.equals("8")){%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(769,user.getLanguage())%></option>
	            <option value=9 <%if(leastedulevel.equals("9")){%>selected <%}%> >MBA</option>
	            <option value=10 <%if(leastedulevel.equals("10")){%>selected <%}%> >EMBA</option>
	            <option value=11 <%if(leastedulevel.equals("11")){%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(2119,user.getLanguage())%></option>
	     </select>              
          </TD>     
      <td><%=SystemEnv.getHtmlLabelName(6152,user.getLanguage())%></td>
          <td class=Field >
             <BUTTON class=Browser onclick="onShowUsekind()"></BUTTON> 
             <SPAN id=usekindspan><%=UseKindComInfo.getUseKindname(demandkind)%></SPAN> 
             <INPUT type=hidden name=demandkind value="<%=demandkind%>">         
          </td>
      <TD><%=SystemEnv.getHtmlLabelName(6153,user.getLanguage())%></td>
      <TD class=Field><BUTTON class=Calendar id=selectbirthday onclick="gettheDate(regdate,regdatespan)"></BUTTON> 
        <SPAN id=regdatespan ><%=regdate%></SPAN> 
        - <BUTTON class=Calendar id=selectbirthdayTo onclick="gettheDate(regdateTo,regdateTospan)"></BUTTON> 
        <SPAN id=regdateTospan > <%=regdateTo%></SPAN> 
        <input type="hidden" name="regdate" value="<%=regdate%>">
        <input type="hidden" name="regdateTo" value="<%=regdateTo%>">
      <td>&nbsp;</td>
      <td class=Field>&nbsp;</td>
    </tr>
    </tbody> 
  </table>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="5%">  
  <COL width="20%">
  <COL width="15%">  
  <COL width="20%">
  <COL width="20%">
  <COL width="20%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=7><%=SystemEnv.getHtmlLabelName(6131,user.getLanguage())%></TH></TR>
    <TR class=Header>
    <td></td>
    <TD><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1859,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(6152,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(6153,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
  </TR>
  <TR class=Line><TD colspan="7" ></TD></TR> 
 
<% 
String sql = "select * from HrmUseDemand"+ sqlwhere; 
rs.executeSql(sql); 
int needchange = 0; 
while(rs.next()){ 
String	jobtitleid=rs.getString("demandjobtitle"); 
String	num=rs.getString("demandnum"); 
String  kind = rs.getString("demandkind");
String  date = rs.getString("demandregdate");
int  status = Util.getIntValue(rs.getString("status"));
try{ 
  if(needchange ==0){ 
  needchange = 1; 
%> 
  <TR class=datalight> 
<% 
}else{ needchange=0; 
%>
  <TR class=datadark> 
<%
} 
%> 
   <td><a href="HrmUseDemandEdit.jsp?id=<%=rs.getString("id")%>">>>></a></td>
   <TD><%=JobTitlesComInfo.getJobTitlesname(jobtitleid)%></a>
   </TD> 
   <TD><%=num%>
   </TD> 
   <TD><%=UseKindComInfo.getUseKindname(kind)%>
   </TD> 
   <TD><%=date%>
   </TD> 
   <td>
     <%if(status == 0){%><%=SystemEnv.getHtmlLabelName(15746,user.getLanguage())%><%}%>
     <%if(status == 1){%><%=SystemEnv.getHtmlLabelName(15747,user.getLanguage())%><%}%>
     <%if(status == 2){%><%=SystemEnv.getHtmlLabelName(15748,user.getLanguage())%><%}%>
     <%if(status == 3){%><%=SystemEnv.getHtmlLabelName(15749,user.getLanguage())%><%}%>
     <%if(status == 4){%><%=SystemEnv.getHtmlLabelName(15750,user.getLanguage())%><%}%>
   </td>
  </TR>
<% 
  }catch(Exception e){ 
  rs.writeLog(e.toString()); } } 
%>
</TBODY>
</TABLE>
</FORM>
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
<script language=javascript>  
function submitData() {
 frmMain.submit();
}
</script>

 <script language=vbs>
sub onShowUsekind()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/usekind/UseKindBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	usekindspan.innerHtml = id(1)
	frmain.demandkind.value=id(0)
	else 
	usekindspan.innerHtml = ""
	frmain.demandkind.value=""
	end if
	end if
end sub
sub onShowJobtitle()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	jobtitlespan.innerHtml = id(1)
	frmain.jobtitle.value=id(0)
	else 
	jobtitlespan.innerHtml = ""
	frmain.jobtitle.value=""
	end if
	end if
end sub
sub onShowJobActivity()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobactivities/JobActivitiesBrowser.jsp")
	if Not isempty(id) then 
	if id(0)<> 0 then
	jobactivityspan.innerHtml = "<a href='/hrm/jobactivities/HrmJobActivitiesEdit.jsp?id="&id(0)&"'>"&id(1)&"</a>"
	frmain.jobactivity.value=id(0)
	else
	jobactivityspan.innerHtml = ""
	frmain.jobactivity.value=""
	end if
	end if
end sub
 sub onShowDepartmentID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmain.department.value)
	issame = false 
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	if id(0) = frmain.department.value then
		issame = true 
	end if
	departmentspan.innerHtml = id(1)
	frmain.department.value=id(0)
	else
	departmentspan.innerHtml = ""
	frmain.department.value=""
	end if
	end if
end sub
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>