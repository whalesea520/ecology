<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.tools.Time" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
Time time = new Time();


Calendar todaycal = Calendar.getInstance ();
String year = Util.add0(todaycal.get(Calendar.YEAR), 4);
String month = Util.add0(todaycal.get(Calendar.MONTH)+1, 2);


String firstday = Util.null2String(request.getParameter("firstday"));
String lastday = Util.null2String(request.getParameter("lastday"));
int content = Util.getIntValue(request.getParameter("content"),2);

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(16045,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(16046,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

float resultpercent=0;
int linecolor=0;

String sqlwhere = "";
if(firstday.equals("")){
firstday = ""+year+"-"+month+"-01";
}
if(lastday.equals("")){
lastday = ""+year+"-"+month+"-31";	  
}
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{Excel,/weaver/weaver.file.ExcelOut,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(887,user.getLanguage())+",/hrm/report/schedulediff/HrmScheduleDiffDepMonReport.jsp,_self} " ;
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

<form name=frmmain method=post action="HrmScheduleDiffDayReport.jsp">
<TABLE class=viewform>
  <TBODY> 
  <tr>    
    <td width=10%><%=SystemEnv.getHtmlLabelName(16037,user.getLanguage())%></td>
    <td class=field>
    <BUTTON class=calendar id=SelectDate onclick=getDate(firstdayspan,firstday)></BUTTON>&nbsp;
    <SPAN id=firstdayspan ><%=Util.toScreen(firstday,user.getLanguage())%></SPAN>
    <input type="hidden" name="firstday" value=<%=firstday%>>
    －<BUTTON class=calendar id=SelectDate onclick=getDate(lastdayspan,lastday)></BUTTON>&nbsp;
    <SPAN id=lastdayspan ><%=Util.toScreen(lastday,user.getLanguage())%></SPAN>
    <input type="hidden" name="lastday" value=<%=lastday%>>  
    </td>
    <td><%=SystemEnv.getHtmlLabelName(15935,user.getLanguage())%></td> 
    <td class=field>            
    <select class=inputstyle name=content value="<%=content%>" onchange="dochange()">
       <option value=1 <%if(content==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1892,user.getLanguage())%></option>
       <option value=2 <%if(content==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(496,user.getLanguage())%></option>
    </select>
    </td>             
  </tr>
  </TBODY> 
</TABLE>
<table class=ListStyle cellspacing=1 >
<tbody>
<tr class=header>
  <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
<%
   int line = 0;
   ExcelFile.init ();
   String filename = SystemEnv.getHtmlLabelName(16045,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(16047,user.getLanguage()) ;
   ExcelFile.setFilename(filename+year+"-"+month) ;
   
   // 下面建立一个头部的样式, 我们系统中的表头都采用这个样式!
   ExcelStyle es = ExcelFile.newExcelStyle("Header") ;
   es.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
   es.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
   es.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
   es.setAlign(ExcelStyle.WeaverHeaderAlign) ;
   
   ExcelSheet et = ExcelFile.newExcelSheet(filename+year+"-"+month) ;

   // 下面设置每一列的宽度, 如果不设置, 将按照excel默认的宽度  
   et.addColumnwidth(8000) ;
   
   ExcelRow erdepType = null ;

   erdepType = et.newExcelRow() ;
   erdepType.addStringValue( SystemEnv.getHtmlLabelName(124,user.getLanguage()) , "Header" ) ; 
   

  String sql = "select id,diffname from HrmScheduleDiff order by id";
  rs.executeSql(sql);
  Hashtable ht = new Hashtable();
  Hashtable htname = new Hashtable();
  int i = 0;
  while(rs.next()){
    String id = rs.getString("id");
    ht.put(new Integer(i),id);
    htname.put(new Integer(i),rs.getString("diffname"));
    i++;
  }
  Enumeration keynames = htname.keys();     
  while(keynames.hasMoreElements()){
    Integer index = (Integer)keynames.nextElement();
    String diffname = (String)htname.get(index); 
    erdepType.addStringValue(Util.toScreen(Util.null2String(diffname),user.getLanguage()), "Header" ) ; 
%>
  <td><%=Util.null2String(diffname)%></td>
<%        
  }
%>  
</tr>
 <TR class=Line><TD colspan="6" ></TD></TR> 
<%    
   sql = "select distinct(t2.departmentid) resultid from HrmScheduleMaintance t1,HrmResource t2 where t1.resourceid = t2.id";
   rs2.executeSql(sql);
   while(rs2.next()){   
     String resultid = ""+rs2.getString(1);
     ExcelRow erdep = et.newExcelRow() ;
     String depname = Util.toScreen(DepartmentComInfo.getDepartmentname(resultid),user.getLanguage());
     erdep.addStringValue(depname);
     if(line%2==0){
     line++;
%>
<tr class=datalight>
<%}else{%><tr class=datadark><%line++;}%>
  <td><%=depname%></td>
<%     
     Enumeration keys = ht.keys();     
     while(keys.hasMoreElements()){
           Integer index = (Integer)keys.nextElement();
           String diffid = (String)ht.get(index);                	    
	   sqlwhere =" and (t1.startdate >='"+firstday +"' and t1.startdate <= '"+lastday+"')";  	   
	   String resultcount = ""+time.getTotalDayByType(diffid,sqlwhere,"",resultid);
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
</form>
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
 frmmain.submit();
}
</script>
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
</script>
<script language=javascript>
 function dochange(){
   if(document.frmmain.content.value == 1){
      document.frmmain.action="HrmScheduleDiffReport.jsp";
      document.frmmain.submit();
   }else{
      document.frmmain.action="HrmScheduleDiffDiffReport.jsp";
      document.frmmain.submit();
   }
 }
</script>
</body>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
