<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.*" %>
<%@ page import="java.util.*" %>

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
String trainname = Util.null2String(request.getParameter("name"));
String resource = Util.null2String(request.getParameter("resource"));
String planname = Util.null2String(request.getParameter("planname"));
String organizer = Util.null2String(request.getParameter("organizer"));
String startdatefrom = Util.null2String(request.getParameter("startdatefrom"));
String startdateto = Util.null2String(request.getParameter("startdateto"));
String enddatefrom = Util.null2String(request.getParameter("enddatefrom"));
String enddateto = Util.null2String(request.getParameter("enddateto"));
String content = Util.null2String(request.getParameter("content"));
String aim = Util.null2String(request.getParameter("aim"));
String address = Util.null2String(request.getParameter("address"));

String sqlwhere = "";
int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!trainname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where name like '%" + Util.fromScreen2(trainname,user.getLanguage()) +"%' ";
	}
	else 
		sqlwhere += " and name like '%" + Util.fromScreen2(trainname,user.getLanguage()) +"%' ";
}
if(!planname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where planid in (select id from HrmTrainPlan where planname like '%" + Util.fromScreen2(planname,user.getLanguage()) +"%') ";
	}
	else 
		sqlwhere += " and planid in (select id from HrmTrainPlan where planname like '%" + Util.fromScreen2(planname,user.getLanguage()) +"%') ";
}
if(!resource.equals("")){
	if(ishead==0){
		ishead = 1;		
		sqlwhere += " where resource_n =" + Util.fromScreen2(resource,user.getLanguage()) +" ";
	}
	else 
		sqlwhere += " and resource_n =" + Util.fromScreen2(resource,user.getLanguage()) +" ";
}

if(!startdatefrom.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where startdate >='" + Util.fromScreen2(startdatefrom,user.getLanguage()) +"' ";
	}
	else 
		sqlwhere += " and startdate >='" + Util.fromScreen2(startdatefrom,user.getLanguage()) +"' ";
}
if(!startdateto.equals("")){
	if(ishead==0){
		ishead = 1;
		if(rs.getDBType().equals("oracle")){
		sqlwhere += " where (startdate is not null and startdate <='" + Util.fromScreen2(startdateto,user.getLanguage()) +"') ";
		}else{
		sqlwhere += " where (startdate <> '' and startdate <='" + Util.fromScreen2(startdateto,user.getLanguage()) +"') ";
		}
	}
	else 
		if(rs.getDBType().equals("oracle")){
		sqlwhere += " and (startdate is not null and startdate <='" + Util.fromScreen2(startdateto,user.getLanguage()) +"') ";
		}else{
		sqlwhere += " and (startdate<>'' and startdate <='" + Util.fromScreen2(startdateto,user.getLanguage()) +"') ";
		}
}
if(!enddatefrom.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where enddate >='" + Util.fromScreen2(enddatefrom,user.getLanguage()) +"' ";
	}
	else 
		sqlwhere += " and enddate >='" + Util.fromScreen2(enddatefrom,user.getLanguage()) +"' ";
}
if(!enddateto.equals("")){
	if(ishead==0){
		ishead = 1;
		if(rs.getDBType().equals("oracle")){
		sqlwhere += " where (enddate is not null and enddate <='" + Util.fromScreen2(enddateto,user.getLanguage()) +"') ";
		}else{
		sqlwhere += " where (enddate <> '' and enddate <='" + Util.fromScreen2(enddateto,user.getLanguage()) +"') ";
		}
	}
	else 
		if(rs.getDBType().equals("oracle")){
		sqlwhere += " and (enddate is not null and enddate <='" + Util.fromScreen2(enddateto,user.getLanguage()) +"') ";
		}else{
		sqlwhere += " and (enddate<>'' and enddate <='" + Util.fromScreen2(enddateto,user.getLanguage()) +"') ";
		}
}
if(!organizer.equals("")&&!organizer.equals("0")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where (organizer like '%," + Util.fromScreen2(organizer,user.getLanguage()) +",%' or organizer like '"+Util.fromScreen2(organizer,user.getLanguage())+",%') ";
	}
	else 
		sqlwhere += " and (organizer like '%," + Util.fromScreen2(organizer,user.getLanguage()) +",%' or organizer like '"+Util.fromScreen2(organizer,user.getLanguage())+",%') ";
}
if(!content.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where content like '%" + Util.fromScreen2(content,user.getLanguage()) +"%' ";
	}
	else 
		sqlwhere += " and content like '%" + Util.fromScreen2(content,user.getLanguage()) +"%' ";
}
if(!aim.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where aim like '%" + Util.fromScreen2(aim,user.getLanguage()) +"%' ";
	}
	else 
		sqlwhere += " and aim like '%" + Util.fromScreen2(aim,user.getLanguage()) +"%' ";
}
if(!address.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where address like '%" + Util.fromScreen2(address,user.getLanguage()) +"%' ";
	}
	else 
		sqlwhere += " and address like '%" + Util.fromScreen2(address,user.getLanguage()) +"%' ";
}
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(352,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6136,user.getLanguage());
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
<form name=frmmain method=post action="HrmTrainReport.jsp">
   <table class=ViewForm>
  <colgroup>
    <col width=10%>
    <col width=20%>
    <col width=10%>
    <col width=23%>    
    <col width=10%>
    <col width=23%>
  <tbody>
  <tr>
    <td class=field><%=SystemEnv.getHtmlLabelName(15678,user.getLanguage())%></td>
    <td class=field><input class=inputStyle type=text name="name" value="<%=trainname%>"></td>    
    <td class=field><%=SystemEnv.getHtmlLabelName(6156,user.getLanguage())%></td>
    <td class=field><input class=inputStyle type=text name="planname" value="<%=planname%>"></td>
    <td class=field><%=SystemEnv.getHtmlLabelName(15879,user.getLanguage())%></td>
    <td class=field>
      <input class=wuiBrowser type=hidden name=resource value="<%=resource%>"
      _url="/systeminfo/BrowserMain.jsp?url=/hrm/train/trainresource/HrmTrainResourceBrowser.jsp"
      _displayText="<%=TrainResourceComInfo.getResourcename(resource)%>"
      >
    </td>
  </tr>
  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR> 
  <tr>
    <td class=field><%=SystemEnv.getHtmlLabelName(15915,user.getLanguage())%></td>
    <td class=field>
      <INPUT class=wuiBrowser id=organizer type=hidden name=organizer value="<%=organizer%>"
      _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
      _displayText="ResourceComInfo.getMulResourcename(organizer)"
      >
    </td>    
    <td class=field><%=SystemEnv.getHtmlLabelName(1971,user.getLanguage())%></td>
    <td class=field>
        <BUTTON type=button class=Calendar id=selectstartdatefrom onclick="getDate(startdatefromspan,startdatefrom)"></BUTTON> 
       <SPAN id=startdatefromspan ><%=startdatefrom%></SPAN> -
        <BUTTON type=button class=Calendar id=selectstartdateto onclick="getDate(startdatetospan,startdateto)"></BUTTON> 
       <SPAN id=startdatetospan ><%=startdateto%></SPAN> 
       <input class=inputStyle type="hidden" name="startdatefrom" value="<%=startdatefrom%>">
       <input class=inputStyle type="hidden" name="startdateto" value="<%=startdateto%>">
    </td>
    <td class=field><%=SystemEnv.getHtmlLabelName(1972,user.getLanguage())%></td>
    <td class=field>
        <BUTTON type=button class=Calendar id=selectenddatefrom onclick="getDate(enddatefromspan,enddatefrom)"></BUTTON> 
       <SPAN id=enddatefromspan ><%=enddatefrom%></SPAN> -
        <BUTTON type=button class=Calendar id=selectenddateto onclick="getDate(enddatetospan,enddateto)"></BUTTON> 
       <SPAN id=enddatetospan ><%=enddateto%></SPAN> 
       <input class=inputStyle type="hidden" name="enddatefrom" value="<%=enddatefrom%>">
       <input class=inputStyle type="hidden" name="enddateto" value="<%=enddateto%>">
    </td>
  </tr>
  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR> 
  <tr>
    <td class=field><%=SystemEnv.getHtmlLabelName(15926,user.getLanguage())%></td>
    <td class=field><input class=inputStyle type=text name="content" value="<%=content%>"></td>    
    <td class=field><%=SystemEnv.getHtmlLabelName(15917,user.getLanguage())%></td>
    <td class=field><input class=inputStyle type=text name="aim" value="<%=aim%>"></td>
    <td class=field><%=SystemEnv.getHtmlLabelName(15918,user.getLanguage())%></td>
    <td class=field><input class=inputStyle type=text name="address" value="<%=address%>"></td>
  </tr>
  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR> 
  </tbody>
  </table>
  <table class=ListStyle cellspacing=1 >
  <colgroup>
    <col width=25%>
    <col width=8%>
    <col width=7%>
    <col width=7%>
    <col width=7%>
    <col width=7%>
    <col width=7%>
    <col width=7%>
    <col width=7%>
    <col width=7%>
    <col width=7%>    
  <tbody>
    <tr class=header>
      <td rowspan=2><%=SystemEnv.getHtmlLabelName(15919,user.getLanguage())%></td>
      <td rowspan=2><%=SystemEnv.getHtmlLabelName(15899,user.getLanguage())%>(%)</td>      
      <td colspan=4 ><%=SystemEnv.getHtmlLabelName(15920,user.getLanguage())%></td>
      <td colspan=5><%=SystemEnv.getHtmlLabelName(15738,user.getLanguage())%></td>
    </tr>
    <tr class=header>
      <td><%=SystemEnv.getHtmlLabelName(15911,user.getLanguage())%>(%)</td>
      <td><%=SystemEnv.getHtmlLabelName(15912,user.getLanguage())%>(%)</td>
      <td><%=SystemEnv.getHtmlLabelName(15913,user.getLanguage())%>(%)</td>
      <td><%=SystemEnv.getHtmlLabelName(15914,user.getLanguage())%>(%)</td>      
      <td><%=SystemEnv.getHtmlLabelName(15906,user.getLanguage())%>(%)</td>
      <td><%=SystemEnv.getHtmlLabelName(15907,user.getLanguage())%>(%)</td>
      <td><%=SystemEnv.getHtmlLabelName(15908,user.getLanguage())%>(%)</td>
      <td><%=SystemEnv.getHtmlLabelName(15909,user.getLanguage())%>(%)</td>
      <td><%=SystemEnv.getHtmlLabelName(15910,user.getLanguage())%>(%)</td>      
    </tr>
    <TR class=Line><TD colspan="11" ></TD></TR> 
<%
  int line=0;
  
   ExcelFile.init ();
   String filename = SystemEnv.getHtmlLabelName(15922,user.getLanguage());
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
   er.addStringValue(SystemEnv.getHtmlLabelName(15678,user.getLanguage()),"Header");  
   er.addStringValue(SystemEnv.getHtmlLabelName(15899,user.getLanguage()),"Header");  
   er.addStringValue(SystemEnv.getHtmlLabelName(15920,user.getLanguage()),"Header");  
   er.addStringValue(" ","Header");  
   er.addStringValue(" ","Header");  
   er.addStringValue(" ","Header");  
   er.addStringValue(SystemEnv.getHtmlLabelName(15738,user.getLanguage()),"Header");  
   er.addStringValue(" ","Header");  
   er.addStringValue(" ","Header");  
   er.addStringValue(" ","Header");  
   er.addStringValue(" ","Header");     
   
   ExcelRow er1= null ;
   er1 = et.newExcelRow() ;   
   er1.addStringValue(Util.toScreen(" ",user.getLanguage(),"0"),"Header");  
   er1.addStringValue(Util.toScreen(" ",user.getLanguage(),"0"),"Header");  
   er1.addStringValue(SystemEnv.getHtmlLabelName(15911,user.getLanguage()),"Header");    
   er1.addStringValue(SystemEnv.getHtmlLabelName(15912,user.getLanguage()),"Header");    
   er1.addStringValue(SystemEnv.getHtmlLabelName(15913,user.getLanguage()),"Header");    
   er1.addStringValue(SystemEnv.getHtmlLabelName(15914,user.getLanguage()),"Header");    
   er1.addStringValue(SystemEnv.getHtmlLabelName(15906,user.getLanguage()),"Header");    
   er1.addStringValue(SystemEnv.getHtmlLabelName(15907,user.getLanguage()),"Header");    
   er1.addStringValue(SystemEnv.getHtmlLabelName(15908,user.getLanguage()),"Header");    
   er1.addStringValue(SystemEnv.getHtmlLabelName(15909,user.getLanguage()),"Header");    
   er1.addStringValue(SystemEnv.getHtmlLabelName(15910,user.getLanguage()),"Header");    
   
  String sql = "select id,name from HrmTrain"+sqlwhere;    
  rs.executeSql(sql);
  while(rs.next()){
    ExcelRow erres = et.newExcelRow();    
    String id = Util.null2String(rs.getString("id"));
    String name = Util.null2String(rs.getString("name"));
    float rate = TrainReportManage.getAttendRate(id);
    float result0 = TrainReportManage.getTestInfo(id,0);
    float result1 = TrainReportManage.getTestInfo(id,1);
    float result2 = TrainReportManage.getTestInfo(id,2);
    float result3 = TrainReportManage.getTestInfo(id,3);    
    float assres0 = TrainReportManage.getAssessInfo(id,0);
    float assres1 = TrainReportManage.getAssessInfo(id,1);
    float assres2 = TrainReportManage.getAssessInfo(id,2);
    float assres3 = TrainReportManage.getAssessInfo(id,3);
    float assres4 = TrainReportManage.getAssessInfo(id,4);
    
    erres.addStringValue(name);
    erres.addStringValue(""+rate);
    erres.addStringValue(""+result0);
    erres.addStringValue(""+result1);
    erres.addStringValue(""+result2);
    erres.addStringValue(""+result3);
    erres.addStringValue(""+assres0);
    erres.addStringValue(""+assres1);
    erres.addStringValue(""+assres2);
    erres.addStringValue(""+assres3);
    erres.addStringValue(""+assres4);
    
    if(line==0){
    line = 1;
%>
    <tr class=datalight>
<%}else{
  line=0;
%>
    <tr class=datadark>
<%}%>    
      <td><a href="/hrm/train/train/HrmTrainEdit.jsp?id=<%=id%>"><%=name%></a></td>
      <td><%=rate%></td>
      <td><%=result0%></td>
      <td><%=result1%></td>
      <td><%=result2%></td>
      <td><%=result3 %></td>      
      <td><%=assres0%></td>
      <td><%=assres1%></td>
      <td><%=assres2%></td>
      <td><%=assres3%></td>
      <td><%=assres4%></td>
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
 frmmain.submit();
}
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>