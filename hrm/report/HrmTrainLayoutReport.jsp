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
String typename = Util.null2String(request.getParameter("typename"));
String assessor = Util.null2String(request.getParameter("assessor"));

String startdatefrom = Util.null2String(request.getParameter("startdatefrom"));
String startdateto = Util.null2String(request.getParameter("startdateto"));
String enddatefrom = Util.null2String(request.getParameter("enddatefrom"));
String enddateto = Util.null2String(request.getParameter("enddateto"));

String content = Util.null2String(request.getParameter("content"));
String aim = Util.null2String(request.getParameter("aim"));
String address = Util.null2String(request.getParameter("address"));
String assessdatefrom = Util.null2String(request.getParameter("assessdatefrom"));

String assessdateto = Util.null2String(request.getParameter("assessdateto"));
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
if(!typename.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where typeid in (select id from HrmTrainType where name like '%" + Util.fromScreen2(typename,user.getLanguage()) +"%') ";
	}
	else 
		sqlwhere += " and typeid in (select id from HrmTrainType where name like '%" + Util.fromScreen2(typename,user.getLanguage()) +"%') ";
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
		sqlwhere += " where layoutstartdate >='" + Util.fromScreen2(startdatefrom,user.getLanguage()) +"' ";
	}
	else 
		sqlwhere += " and layoutstartdate >='" + Util.fromScreen2(startdatefrom,user.getLanguage()) +"' ";
}
if(!startdateto.equals("")){
	if(ishead==0){
		ishead = 1;
		if(rs.getDBType().equals("oracle")){
		sqlwhere += " where (layoutstartdate is not null and layoutstartdate <='" + Util.fromScreen2(startdateto,user.getLanguage()) +"') ";
		}else{
		sqlwhere += " where (layoutstartdate <> '' and layoutstartdate <='" + Util.fromScreen2(startdateto,user.getLanguage()) +"') ";
		}
	}
	else 
		if(rs.getDBType().equals("oracle")){
		sqlwhere += " and (layoutstartdate is not null and layoutstartdate <='" + Util.fromScreen2(startdateto,user.getLanguage()) +"') ";
		}else{
		sqlwhere += " and (layoutstartdate<>'' and layoutstartdate <='" + Util.fromScreen2(startdateto,user.getLanguage()) +"') ";
		}
}
if(!enddatefrom.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where layoutenddate >='" + Util.fromScreen2(enddatefrom,user.getLanguage()) +"' ";
	}
	else 
		sqlwhere += " and layoutenddate >='" + Util.fromScreen2(enddatefrom,user.getLanguage()) +"' ";
}
if(!enddateto.equals("")){
	if(ishead==0){
		ishead = 1;
		if(rs.getDBType().equals("oracle")){
		sqlwhere += " where (layoutenddate is not null and layoutenddate <='" + Util.fromScreen2(enddateto,user.getLanguage()) +"') ";
		}else{
		sqlwhere += " where (layoutenddate <> '' and layoutenddate <='" + Util.fromScreen2(enddateto,user.getLanguage()) +"') ";
		}
	}
	else 
		if(rs.getDBType().equals("oracle")){
		sqlwhere += " and (layoutenddate is not null and layoutenddate <='" + Util.fromScreen2(enddateto,user.getLanguage()) +"') ";
		}else{
		sqlwhere += " and (layoutenddate<>'' and layoutenddate <='" + Util.fromScreen2(enddateto,user.getLanguage()) +"') ";
		}
}
if(!assessor.equals("")&&!assessor.equals("0")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where (layoutassessor like '%," + Util.fromScreen2(assessor,user.getLanguage()) +",%' or layoutassessor like '"+Util.fromScreen2(assessor,user.getLanguage())+",%') ";
	}
	else 
		sqlwhere += " and (layoutassessor like '%," + Util.fromScreen2(assessor,user.getLanguage()) +",%' or layoutassessor like '"+Util.fromScreen2(assessor,user.getLanguage())+",%') ";
}
if(!content.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where layoutcontent like '%" + Util.fromScreen2(content,user.getLanguage()) +"%' ";
	}
	else 
		sqlwhere += " and layoutcontent like '%" + Util.fromScreen2(content,user.getLanguage()) +"%' ";
}
if(!aim.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where layoutaim like '%" + Util.fromScreen2(aim,user.getLanguage()) +"%' ";
	}
	else 
		sqlwhere += " and layoutaim like '%" + Util.fromScreen2(aim,user.getLanguage()) +"%' ";
}

if(!assessdatefrom.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where layouttestdate >='" + Util.fromScreen2(assessdatefrom,user.getLanguage()) +"' ";
	}
	else 
		sqlwhere += " and layouttestdate >='" + Util.fromScreen2(assessdatefrom,user.getLanguage()) +"' ";
}
if(!assessdateto.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where (layouttestdate <> '' and layouttestdate <='" + Util.fromScreen2(assessdateto,user.getLanguage()) +"') ";
	}
	else 
		sqlwhere += " and (layouttestdate<>'' and layouttestdate <='" + Util.fromScreen2(assessdateto,user.getLanguage()) +"') ";
}
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(352,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6128,user.getLanguage());
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
<form name=frmmain id="frmmain" method=post action="HrmTrainLayoutReport.jsp">
  <table class=ViewForm>
  <colgroup>
    <col width=20%>
    <col width=30%>
    <col width=20%>
    <col width=30%>        
  <tbody>
  <tr>
    <td class=field><%=SystemEnv.getHtmlLabelName(15892,user.getLanguage())%></td>
    <td class=field><input class=inputStyle type=text name="name" value="<%=trainname%>"></td>    
    <td class=field><%=SystemEnv.getHtmlLabelName(6130,user.getLanguage())%></td>
    <td class=field><input class=inputStyle type=text name="typename" value="<%=typename%>"></td>    
  </tr>
  <TR style="height:1px"><TD class=Line colSpan=4></TD></TR> 
  <tr>
    <td class=field><%=SystemEnv.getHtmlLabelName(15893,user.getLanguage())%></td>
    <td class=field>
      <INPUT class=wuiBrowser  id=assessor type=hidden name=assessor value="<%=assessor%>"
      _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
      _displayText="<%=ResourceComInfo.getMulResourcename(assessor)%>"
      >
    </td>
    <td class=field><%=SystemEnv.getHtmlLabelName(15894,user.getLanguage())%></td>
    <td class=field>
       <BUTTON type=button class=Calendar id=selectassessdatefrom onclick="getDate(assessdatefromspan,assessdatefrom)"></BUTTON> 
       <SPAN id=assessdatefromspan ><%=assessdatefrom%></SPAN> -
       <BUTTON type=button class=Calendar id=selectassessdateto onclick="getDate(assessdatetospan,assessdateto)"></BUTTON> 
       <SPAN id=assessdatetospan ><%=assessdateto%></SPAN> 
       <input class=inputStyle type="hidden" name="assessdatefrom" value="<%=assessdatefrom%>">
       <input class=inputStyle type="hidden" name="assessdateto" value="<%=assessdateto%>">
    </td>
  </tr>
  <TR style="height:1px"><TD class=Line colSpan=4></TD></TR> 
  <tr>      
    <td class=field><%=SystemEnv.getHtmlLabelName(15895,user.getLanguage())%></td>
    <td class=field>
       <BUTTON class=Calendar type=button id=selectstartdatefrom onclick="getDate(startdatefromspan,startdatefrom)"></BUTTON> 
       <SPAN id=startdatefromspan ><%=startdatefrom%></SPAN> -
       <BUTTON class=Calendar type=button id=selectstartdateto onclick="getDate(startdatetospan,startdateto)"></BUTTON> 
       <SPAN id=startdatetospan ><%=startdateto%></SPAN> 
       <input class=inputStyle type="hidden" name="startdatefrom" value="<%=startdatefrom%>">
       <input class=inputStyle type="hidden" name="startdateto" value="<%=startdateto%>">
    </td>
    <td class=field><%=SystemEnv.getHtmlLabelName(15896,user.getLanguage())%></td>
    <td class=field>
       <BUTTON class=Calendar type=button id=selectenddatefrom onclick="getDate(enddatefromspan,enddatefrom)"></BUTTON> 
       <SPAN id=enddatefromspan ><%=enddatefrom%></SPAN> -
       <BUTTON class=Calendar type=button id=selectenddateto onclick="getDate(enddatetospan,enddateto)"></BUTTON> 
       <SPAN id=enddatetospan ><%=enddateto%></SPAN> 
       <input class=inputStyle type="hidden" name="enddatefrom" value="<%=enddatefrom%>">
       <input class=inputStyle type="hidden" name="enddateto" value="<%=enddateto%>">
    </td>
  </tr>
  <TR style="height:1px"><TD class=Line colSpan=4></TD></TR> 
  <tr>
    <td class=field><%=SystemEnv.getHtmlLabelName(15897,user.getLanguage())%></td>
    <td class=field><input class=inputStyle type=text name="content" value="<%=content%>"></td>    
    <td class=field><%=SystemEnv.getHtmlLabelName(15898,user.getLanguage())%></td>
    <td class=field><input class=inputStyle type=text name="aim" value="<%=aim%>"></td>    
  </tr>
  <TR style="height:1px"><TD class=Line colSpan=4></TD></TR> 
  </tbody>
  </table>
  <table class=ListStyle cellspacing=1 >
  <colgroup>
    <col width=16%>    
    <col width=6%>
    <col width=6%>
    <col width=6%>
    <col width=6%>
    <col width=6%>
    <col width=6%>
    <col width=6%>
    <col width=6%>
    <col width=6%>  
    <col width=6%>
    <col width=6%>
    <col width=6%>
    <col width=6%>
    <col width=6%>   
  <tbody>
    <tr class=header>
      <td rowspan=2><%=SystemEnv.getHtmlLabelName(15892,user.getLanguage())%></td>
      <td rowspan=2><%=SystemEnv.getHtmlLabelName(15899,user.getLanguage())%>(%)</td>      
      <td colspan=5><%=SystemEnv.getHtmlLabelName(15738,user.getLanguage())%></td>
      <td colspan=4 ><%=SystemEnv.getHtmlLabelName(15901,user.getLanguage())%></td>
      <td colspan=5><%=SystemEnv.getHtmlLabelName(15902,user.getLanguage())%></td>      
    </tr>
    <tr class=header>
      <td><%=SystemEnv.getHtmlLabelName(15906,user.getLanguage())%>(%)</td>
      <td><%=SystemEnv.getHtmlLabelName(15907,user.getLanguage())%>(%)</td>
      <td><%=SystemEnv.getHtmlLabelName(15908,user.getLanguage())%>(%)</td>
      <td><%=SystemEnv.getHtmlLabelName(15909,user.getLanguage())%>(%)</td>
      <td><%=SystemEnv.getHtmlLabelName(15910,user.getLanguage())%>(%)</td>
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
    <TR class=Line><TD colspan="16" ></TD></TR> 
<%
  int line=0;
  
  ExcelFile.init ();
   String filename = SystemEnv.getHtmlLabelName(15921,user.getLanguage());
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
   er.addStringValue(SystemEnv.getHtmlLabelName(15900,user.getLanguage()),"Header");  
   er.addStringValue(SystemEnv.getHtmlLabelName(15899,user.getLanguage()),"Header"); 
   er.addStringValue(SystemEnv.getHtmlLabelName(15738,user.getLanguage()),"Header");  
   er.addStringValue(Util.toScreen(" ",user.getLanguage(),"0"),"Header");  
   er.addStringValue(Util.toScreen(" ",user.getLanguage(),"0"),"Header");  
   er.addStringValue(Util.toScreen(" ",user.getLanguage(),"0"),"Header");  
   er.addStringValue(Util.toScreen(" ",user.getLanguage(),"0"),"Header");  
   er.addStringValue(SystemEnv.getHtmlLabelName(15903,user.getLanguage()),"Header");  
   er.addStringValue(SystemEnv.getHtmlLabelName(15904,user.getLanguage()),"Header");  
   er.addStringValue(Util.toScreen(" ",user.getLanguage(),"0"),"Header");  
   er.addStringValue(Util.toScreen(" ",user.getLanguage(),"0"),"Header");  
   er.addStringValue(SystemEnv.getHtmlLabelName(15903,user.getLanguage()),"Header");  
   er.addStringValue(SystemEnv.getHtmlLabelName(15905,user.getLanguage()),"Header");  
   er.addStringValue(Util.toScreen(" ",user.getLanguage(),"0"),"Header");  
   er.addStringValue(Util.toScreen(" ",user.getLanguage(),"0"),"Header");  
   er.addStringValue(Util.toScreen(" ",user.getLanguage(),"0"),"Header");     
   
   ExcelRow er1= null ;
   er1 = et.newExcelRow() ;   
   er1.addStringValue(Util.toScreen(" ",user.getLanguage(),"0"),"Header");  
   er1.addStringValue(Util.toScreen(" ",user.getLanguage(),"0"),"Header"); 
   er1.addStringValue(SystemEnv.getHtmlLabelName(15906,user.getLanguage()),"Header");    
   er1.addStringValue(SystemEnv.getHtmlLabelName(15907,user.getLanguage()),"Header");    
   er1.addStringValue(SystemEnv.getHtmlLabelName(15908,user.getLanguage()),"Header");    
   er1.addStringValue(SystemEnv.getHtmlLabelName(15909,user.getLanguage()),"Header");    
   er1.addStringValue(SystemEnv.getHtmlLabelName(15910,user.getLanguage()),"Header");     
   er1.addStringValue(SystemEnv.getHtmlLabelName(15911,user.getLanguage()),"Header");    
   er1.addStringValue(SystemEnv.getHtmlLabelName(15912,user.getLanguage()),"Header");    
   er1.addStringValue(SystemEnv.getHtmlLabelName(15913,user.getLanguage()),"Header");    
   er1.addStringValue(SystemEnv.getHtmlLabelName(15914,user.getLanguage()),"Header");    
   er1.addStringValue(SystemEnv.getHtmlLabelName(15906,user.getLanguage()),"Header");    
   er1.addStringValue(SystemEnv.getHtmlLabelName(15907,user.getLanguage()),"Header");    
   er1.addStringValue(SystemEnv.getHtmlLabelName(15908,user.getLanguage()),"Header");    
   er1.addStringValue(SystemEnv.getHtmlLabelName(15909,user.getLanguage()),"Header");    
   er1.addStringValue(SystemEnv.getHtmlLabelName(15910,user.getLanguage()),"Header");    
   
  String sql = "select id,layoutname from HrmTrainLayout"+sqlwhere;      
  rs.executeSql(sql);
  while(rs.next()){
    ExcelRow erres = et.newExcelRow();    
    String id = Util.null2String(rs.getString("id"));
    String name = Util.null2String(rs.getString("layoutname"));
    float rate = TrainReportManage.getLayoutAttendRate(id);
    float result0 = TrainReportManage.getLayoutTestByTrain(id,0);
    float result1 = TrainReportManage.getLayoutTestByTrain(id,1);
    float result2 = TrainReportManage.getLayoutTestByTrain(id,2);
    float result3 = TrainReportManage.getLayoutTestByTrain(id,3);
    float layoutass0 =   TrainReportManage.getLayoutAssess(id,0);  
    float layoutass1 =   TrainReportManage.getLayoutAssess(id,1);  
    float layoutass2 =   TrainReportManage.getLayoutAssess(id,2);  
    float layoutass3 =   TrainReportManage.getLayoutAssess(id,3);  
    float layoutass4 =   TrainReportManage.getLayoutAssess(id,4); 
    float trainass0 =  TrainReportManage.getLayoutAssessByTrain(id,0);
    float trainass1 =  TrainReportManage.getLayoutAssessByTrain(id,1);
    float trainass2 =  TrainReportManage.getLayoutAssessByTrain(id,2);
    float trainass3 =  TrainReportManage.getLayoutAssessByTrain(id,3);
    float trainass4 =  TrainReportManage.getLayoutAssessByTrain(id,4);
    
    erres.addStringValue(name);
    erres.addStringValue(""+rate);
    erres.addStringValue(""+layoutass0);
    erres.addStringValue(""+layoutass1);
    erres.addStringValue(""+layoutass2);
    erres.addStringValue(""+layoutass3);
    erres.addStringValue(""+layoutass4);
    erres.addStringValue(""+result0);
    erres.addStringValue(""+result1);
    erres.addStringValue(""+result2);
    erres.addStringValue(""+result3);    
    erres.addStringValue(""+trainass0);
    erres.addStringValue(""+trainass1);
    erres.addStringValue(""+trainass2);
    erres.addStringValue(""+trainass3);
    erres.addStringValue(""+trainass4);
    
    if(line==0){
    line = 1;
%>
    <tr class=datalight>
<%}else{
  line=0;
%>
    <tr class=datadark>
<%}%>    
      <td><a href="/hrm/train/trainlayout/HrmTrainLayoutEdit.jsp?id=<%=id%>"><%=name%></a></td>
      <td><%=rate%></td>
      <td><%=layoutass0%></td>
      <td><%=layoutass1%></td>
      <td><%=layoutass2%></td>
      <td><%=layoutass3%></td>
      <td><%=layoutass4%></td>
      <td><%=result0%></td>
      <td><%=result1%></td>
      <td><%=result2%></td>
      <td><%=result3 %></td>      
      <td><%=trainass0%></td>
      <td><%=trainass1%></td>
      <td><%=trainass2%></td>
      <td><%=trainass3%></td>
      <td><%=trainass4%></td>
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