<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.tools.Time" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ScheduleDiffComInfo" class="weaver.hrm.schedule.HrmScheduleDiffComInfo" scope="page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
Time time = new Time();;

int content = Util.getIntValue(request.getParameter("content"),1);
String depid = Util.null2String(request.getParameter("departmentid"));
String year = Util.null2String(request.getParameter("year"));
if(year.equals("")){
Calendar todaycal = Calendar.getInstance ();
year = Util.add0(todaycal.get(Calendar.YEAR), 4);
}

String isself = Util.null2String(request.getParameter("isself"));

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6139,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(16049,user.getLanguage());
String needfav ="1";
String needhelp ="";

float resultpercent=0;
int linecolor=0;
String sqlwhere = "";
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{Excel,/weaver/weaver.file.ExcelOut,_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/report/schedulediff/HrmScheduleDiffReport.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name=frmmain method=post action="HrmScheduleDiffTypeMonReport.jsp">
<input type="hidden" name="isself" value="1">

<TABLE class=ViewForm>
  <TBODY> 
  <tr>    
    <td width=10%><%=SystemEnv.getHtmlLabelName(15933,user.getLanguage())%></td>
    <td class=field>
      <INPUT class=inputStyle maxLength=4 size=4 name="year"    onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("year")' value="<%=year%>">
    </td>     
    <td width=10%><%=SystemEnv.getHtmlLabelName(15935,user.getLanguage())%></td> 
    <td class=field>            
    <select class=inputstyle name=content value="<%=content%>"><!--onchange="dochange()"-->
       <option value=1 <%if(content==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1892,user.getLanguage())%></option>
       <option value=2 <%if(content==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></option>
    </select>
    </td>
    <TD width=10%><%=SystemEnv.getHtmlLabelName(15393,user.getLanguage())%></TD>
    <TD class=Field>         
      <BUTTON class=Browser id=SelectDepartment onclick="onShowDepartment()"></BUTTON>
      <SPAN id=departmentspan> <%=DepartmentComInfo.getDepartmentname(depid)%>
      </SPAN> 
      <INPUT class=inputStyle id=departmentid type=hidden name=departmentid value="<%=depid%>">    
    </TD>
  </tr>
  <TR><TD class=Line colSpan=6></TD></TR> 
  </TBODY> 
</TABLE>

<% if(isself.equals("1")) { %>
<table class=ListStyle cellspacing=1 >
<tbody>
<tr class=header>
  <td><%=SystemEnv.getHtmlLabelName(6139,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1492,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1493,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1494,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1495,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1496,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1497,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1498,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1499,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1800,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1801,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1802,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1803,user.getLanguage())%></td>
</tr>
<TR class=Line><TD colspan="13" ></TD></TR> 
<%
   int line = 0;
   ExcelFile.init ()
;  String filename = SystemEnv.getHtmlLabelName(16059,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(16049,user.getLanguage()) ; 
  if(content==1){
     filename = SystemEnv.getHtmlLabelName(16059,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(16052,user.getLanguage()) ;
   }
   if(content == 2){
     filename = SystemEnv.getHtmlLabelName(16059,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(16053,user.getLanguage()) ;
   } 
   if(!depid.equals("")){
     filename += Util.toScreen("--"+DepartmentComInfo.getDepartmentname(depid),user.getLanguage());
   }
   ExcelFile.setFilename(""+year+filename) ;

   // 下面建立一个头部的样式, 我们系统中的表头都采用这个样式!
   ExcelStyle es = ExcelFile.newExcelStyle("Header") ;
   es.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
   es.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
   es.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
   es.setAlign(ExcelStyle.WeaverHeaderAlign) ;
   
   ExcelSheet et = ExcelFile.newExcelSheet(""+year+filename) ;

   // 下面设置每一列的宽度, 如果不设置, 将按照excel默认的宽度  
   et.addColumnwidth(8000) ;
   
   ExcelRow er = null ;

   er = et.newExcelRow() ;
   er.addStringValue( SystemEnv.getHtmlLabelName(6139,user.getLanguage()) , "Header" ) ; 
   
   String sql = "select distinct(t1.id) resultid from HrmScheduleDiff t1";
   rs2.executeSql(sql);
   while(rs2.next()){   
     String resultid = ""+rs2.getString(1);
     ExcelRow erdep = et.newExcelRow() ;
     String depname = Util.toScreen(ScheduleDiffComInfo.getDiffname(resultid),user.getLanguage());
     erdep.addStringValue(depname);
     if(line%2==0){
     line++;
%>
<tr class=datalight>
<%}else{%><tr class=datadark><%line++;}%>
  <td><%=depname%></td>
<%     
     for(int month = 1;month<13;month++){   
   	   String title = ""+month+ SystemEnv.getHtmlLabelName(6076,user.getLanguage()) ;
   	   er.addStringValue(""+title, "Header" ) ;   	      	   
   	   String resultcount = "";
	   String firstday = ""+year+"-"+Util.add0(month,2)+"-01";
	   String lastday = ""+year+"-"+Util.add0(month,2)+"-31";
	   sqlwhere =" and (t1.startdate >='"+firstday +"' and t1.startdate <= '"+lastday+"')";
	   if(!depid.equals("")){
	     sqlwhere += " and t2.departmentid="+depid;
	   }
	   if(content==1){	   
           sql = "select count(t1.id) resultcount from HrmScheduleMaintance t1,HrmResource t2 where t1.resourceid=t2.id and t1.diffid = "+resultid+sqlwhere;
           int resultcountint = 0 ;
	       rs.executeSql(sql);
	       if(rs.next()) resultcountint = Util.getIntValue(rs.getString(1),0);

	       if(resultcountint != 0 ) resultcount = ""+resultcountint;
	   }
	   if(content == 2){
	       sql = "select sum(t1.realdifftime) resultcount from HrmScheduleMaintance t1,HrmResource t2 where t1.resourceid=t2.id and t1.diffid = "+resultid+sqlwhere;
           int resultcountint = 0 ;
	       rs.executeSql(sql);
	       if(rs.next()) resultcountint = Util.getIntValue(rs.getString(1),0);
           if(resultcountint != 0 ) {
               int realcarddiffhour = resultcountint/60 ;
               int realcarddiffmin = resultcountint - realcarddiffhour*60 ;
               resultcount = Util.add0(realcarddiffhour,2) + ":" + Util.add0(realcarddiffmin,2) ;
           }
	   }
	   erdep.addStringValue(resultcount);
%>
  <td><%=resultcount%></td>
<%	   	   	   
   } 
%>
</tr>
<%    
 } 
%>
</tbody>
</table>
<%}%>
</form>


<script language=vbs>
sub onShowScheduleDiff(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/schedule/HrmScheduleDiffBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> 0 then
		document.all(tdname).innerHtml = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHtml = ""
		document.all(inputename).value=""
		end if
	end if
end sub
sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmMain.departmentid.value)	
	if id(0)<> 0 then	
	departmentspan.innerHtml = id(1)
	frmMain.departmentid.value=id(0)
	else
	departmentspan.innerHtml = ""
	frmMain.departmentid.value=""	
	end if
end sub
</script>
<script language=javascript>
 function dochange(){   
      document.frmmain.action="HrmScheduleDiffTypeMonReport.jsp";
      document.frmmain.submit();   
 }
function submitData() {
 frmMain.submit();
}
</script>
</body>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
