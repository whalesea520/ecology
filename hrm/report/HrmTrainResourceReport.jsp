<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="TrainReportManage" class="weaver.hrm.report.TrainReportManage" scope="page" />
<jsp:useBean id="TrainResourceComInfo" class="weaver.hrm.train.TrainResourceComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String resourcename = Util.null2String(request.getParameter("name"));
String resource = Util.null2String(request.getParameter("resource"));
String type = Util.null2String(request.getParameter("type"));

String fare = Util.null2String(request.getParameter("fare"));
String time = Util.null2String(request.getParameter("time"));

String sqlwhere = "";
int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!resourcename.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where name like '%" + Util.fromScreen2(resourcename,user.getLanguage()) +"%' ";
	}
	else 
		sqlwhere += " and name like '%" + Util.fromScreen2(resourcename,user.getLanguage()) +"%' ";
}
if(!type.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where type_n = " + Util.fromScreen2(type,user.getLanguage()) +" ";
	}
	else 
		sqlwhere += " and type_n = " + Util.fromScreen2(type,user.getLanguage()) +" ";
}


if(!fare.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where fare like '%" + Util.fromScreen2(fare,user.getLanguage()) +"%' ";
	}
	else 
		sqlwhere += " and fare like '%" + Util.fromScreen2(fare,user.getLanguage()) +"%' ";
}
if(!time.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where time like '%" + Util.fromScreen2(time,user.getLanguage()) +"%' ";
	}
	else 
		sqlwhere += " and time like '%" + Util.fromScreen2(time,user.getLanguage()) +"%' ";
}


String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(352,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(15879,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{Excel,/weaver/weaver.file.ExcelOut,_self} " ;
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
<form name=frmmain id="frmmain" method=post action="HrmTrainResourceReport.jsp">
  <table class=ViewForm>
  <colgroup>
    <col width=20%>
    <col width=30%>
    <col width=20%>
    <col width=30%>       
  <tbody>
  <tr>
    <td class=field><%=SystemEnv.getHtmlLabelName(15923,user.getLanguage())%></td>
    <td class=field><input class=inputstyle type=text name="name" value="<%=resourcename%>"></td>    
    <td class=field><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
    <td class=field>
      <select class=inputstyle name=type value="<%=type%>">
        <option value="" <%if(type.equals("")){%> selected <%}%>></option>
        <option value=1 <%if(type.equals("1")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%></option>
        <option value=0 <%if(type.equals("0")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(1994,user.getLanguage())%></option>
      </select>
    </td>    
  </tr>
  <TR style="height:1px"><TD class=Line colSpan=4></TD></TR>   
  <tr>
    <td class=field><%=SystemEnv.getHtmlLabelName(1491,user.getLanguage())%></td>
    <td class=field><input class=inputstyle type=text name="fare" value="<%=fare%>"></td>    
    <td class=field><%=SystemEnv.getHtmlLabelName(15386,user.getLanguage())%></td>
    <td class=field><input class=inputstyle type=text name="time" value="<%=time%>"></td>    
  </tr>
  <TR style="height:1px"><TD class=Line colSpan=4></TD></TR> 
  </tbody>
  </table>
  <table class=ListStyle cellspacing=1 >
  <colgroup>
    <col width=25%>    
    <col width=15%>
    <col width=15%>
    <col width=15%>
    <col width=15%>    
    <col width=15%>    
  <tbody>
    <tr class=header>
      <td rowspan=2><%=SystemEnv.getHtmlLabelName(15924,user.getLanguage())%></td>                  
      <td colspan=5><%=SystemEnv.getHtmlLabelName(15738,user.getLanguage())%></td>
    </tr>
    <tr class=header>
      <td><%=SystemEnv.getHtmlLabelName(15906,user.getLanguage())%>(%)</td>
      <td><%=SystemEnv.getHtmlLabelName(15907,user.getLanguage())%>(%)</td>
      <td><%=SystemEnv.getHtmlLabelName(15908,user.getLanguage())%>(%)</td>
      <td><%=SystemEnv.getHtmlLabelName(15909,user.getLanguage())%>(%)</td>
      <td><%=SystemEnv.getHtmlLabelName(15910,user.getLanguage())%>(%)</td>      
    </tr>
    <TR class=Line><TD colspan="6" ></TD></TR> 
<%
  int line=0;
  
  ExcelFile.init ();
   String filename = SystemEnv.getHtmlLabelName(15925,user.getLanguage());
   ExcelFile.setFilename(""+filename) ;
   
   // 下面建立一个头部的样式, 我们系统中的表头都采用这个样式!
   ExcelStyle es = ExcelFile.newExcelStyle("Header") ;
   es.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
   es.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
   es.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
   es.setAlign(ExcelStyle.WeaverHeaderAlign) ;
   
   ExcelSheet et = ExcelFile.newExcelSheet(""+filename) ;

   // 下面设置每一列的宽度, 如果不设置, 将按照excel默认的宽度  
   et.addColumnwidth(8000) ;
   
   ExcelRow er = null ;
   er = et.newExcelRow() ;   
   er.addStringValue(SystemEnv.getHtmlLabelName(15924,user.getLanguage()),"Header");  
   er.addStringValue(SystemEnv.getHtmlLabelName(15738,user.getLanguage()),"Header");  
   er.addStringValue(" ","Header");  
   er.addStringValue(" ","Header");  
   er.addStringValue(" ","Header");  
   er.addStringValue(" ","Header");  
   
   ExcelRow er1= null ;
   er1 = et.newExcelRow() ;   
   er1.addStringValue(" ","Header");  
   er1.addStringValue(SystemEnv.getHtmlLabelName(15906,user.getLanguage()),"Header");    
   er1.addStringValue(SystemEnv.getHtmlLabelName(15907,user.getLanguage()),"Header");    
   er1.addStringValue(SystemEnv.getHtmlLabelName(15908,user.getLanguage()),"Header");    
   er1.addStringValue(SystemEnv.getHtmlLabelName(15909,user.getLanguage()),"Header");    
   er1.addStringValue(SystemEnv.getHtmlLabelName(15910,user.getLanguage()),"Header");    
   
  String sql = "select id, name from HrmTrainResource "+sqlwhere;       
  rs.executeSql(sql);
  while(rs.next()){
    ExcelRow erres = et.newExcelRow();    
    String id = Util.null2String(rs.getString("id"));
    String name = Util.null2String(rs.getString("name"));    
    float result0 = TrainReportManage.getResourceAssess(id,0);
    float result1 = TrainReportManage.getResourceAssess(id,1);
    float result2 = TrainReportManage.getResourceAssess(id,2);
    float result3 = TrainReportManage.getResourceAssess(id,3);
    float result4 = TrainReportManage.getResourceAssess(id,4);
    erres.addStringValue(name);
    erres.addStringValue(""+result0);
    erres.addStringValue(""+result1);
    erres.addStringValue(""+result2);
    erres.addStringValue(""+result3);
    erres.addStringValue(""+result4);
    if(line==0){
    line = 1;
%>
    <tr class=datalight>
<%}else{
  line=0;
%>
    <tr class=datadark>
<%}%>    
      <td><a href="/hrm/train/trainresource/HrmTrainResourcetEdit.jsp?id=<%=id%>"><%=name%></td>            
      <td><%=result0%></td>
      <td><%=result1%></td>
      <td><%=result2%></td>
      <td><%=result3%></td>
      <td><%=result4%></td>
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
 <script language=vbs>
sub onShowResource(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	    resourceids = id(0)
		resourcename = id(1)
		sHtml = ""
		resourceids = Mid(resourceids,2,len(resourceids))
		resourcename = Mid(resourcename,2,len(resourcename))
		inputname.value= resourceids
		while InStr(resourceids,",") <> 0
			curid = Mid(resourceids,1,InStr(resourceids,",")-1)
			curname = Mid(resourcename,1,InStr(resourcename,",")-1)
			resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
			resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
			sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
		wend
		sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
		spanname.innerHtml = sHtml
	else	
    	spanname.innerHtml = ""
    	inputname.value="0"
	end if
	end if
end sub

sub onShowTrainResource()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/train/trainresource/HrmTrainResourceBrowser.jsp")
	if Not isempty(id) then
	if id(0)<> 0 then
	resourcespan.innerHtml = id(1)
	frmMain.resource.value=id(0)
	else
	resourcespan.innerHtml = ""
	frmMain.resource.value=""
	end if
	end if
end sub
</script>
<script language=javascript>  
function submitData() {
 jQuery("#frmmain").submit();
}
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>