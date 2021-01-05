<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.file.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="UseKindComInfo" class="weaver.hrm.job.UseKindComInfo" scope="page" />
<jsp:useBean id="EducationLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="page" />
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>	
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
var dialog = parent.parent.getDialog(parent);
dialog.checkDataChange = false
function excel(){
	window.location.href="/weaver/weaver.file.ExcelOut";
}
</script>
</head>
<%
String isDialog = Util.null2String(request.getParameter("isdialog"));
String year = Util.null2String(request.getParameter("year"));
String month = Util.null2String(request.getParameter("month"));
if(year.equals("")){
Calendar todaycal = Calendar.getInstance ();
year = Util.add0(todaycal.get(Calendar.YEAR), 4);
month = Util.add0(todaycal.get(Calendar.MONTH)+1, 2);
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16060,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(15729,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

String fromdateselect = Util.null2String(request.getParameter("fromdateselect"));
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
if(!fromdateselect.equals("") && !fromdateselect.equals("0")&& !fromdateselect.equals("6")){
	fromdate = TimeUtil.getDateByOption(fromdateselect,"0");
	enddate = TimeUtil.getDateByOption(fromdateselect,"1");
}
String fromdatetoselect = Util.null2String(request.getParameter("fromdatetoselect"));
String fromdateto=Util.fromScreen(request.getParameter("fromdateto"),user.getLanguage());
String enddateto=Util.fromScreen(request.getParameter("enddateto"),user.getLanguage());
if(!fromdatetoselect.equals("") && !fromdatetoselect.equals("0")&& !fromdatetoselect.equals("6")){
	fromdateto = TimeUtil.getDateByOption(fromdatetoselect,"0");
	enddateto = TimeUtil.getDateByOption(fromdatetoselect,"1");
}


String jobtitleid=Util.fromScreen(request.getParameter("jobtitleid"),user.getLanguage());
String departmentid=Util.fromScreen(request.getParameter("departmentid"),user.getLanguage());
String numfrom=Util.fromScreen(request.getParameter("numfrom"),user.getLanguage());
String numto=Util.fromScreen(request.getParameter("numto"),user.getLanguage());
String usekind=Util.fromScreen(request.getParameter("usekind"),user.getLanguage());
int statuses=Util.getIntValue(request.getParameter("statuses"),9);
String edulevel=Util.fromScreen(request.getParameter("edulevel"),user.getLanguage());

int content=Util.getIntValue(request.getParameter("content"),1);

String sqlwhere = "";
if(fromdate.equals("")&&enddate.equals("")){
  fromdate = year+"-"+month+"-01";
  enddate = year+"-"+month+"-31";
}
if(!fromdate.equals("")){
	sqlwhere+=" and demandregdate>='"+fromdate+"'";
}
if(!enddate.equals("")){
  if(rs.getDBType().equals("oracle")){
	sqlwhere+=" and (demandregdate<='"+enddate+"' and demandregdate is not null)";
  }else{
    sqlwhere+=" and (demandregdate<='"+enddate+"' and demandregdate is not null and demandregdate <> '')";
  }
}

if(!fromdateto.equals("")){
	sqlwhere+=" and referdate>='"+fromdateto+"'";
}
if(!enddateto.equals("")){
  if(rs.getDBType().equals("oracle")){
	sqlwhere+=" and (referdate<='"+enddateto+"' and referdate is not null)";
  }else{
    sqlwhere+=" and (referdate<='"+enddateto+"' and referdate is not null and referdate <> '')";
  }
}
if(!jobtitleid.equals("")){
  sqlwhere +=" and demandjobtitle="+jobtitleid;
}
if(!departmentid.equals("")){
  sqlwhere +=" and demanddep="+departmentid;
}
if(!usekind.equals("")){
  sqlwhere +=" and demandkind="+usekind;
}
if(!edulevel.equals("")){
  sqlwhere +=" and leastedulevel="+edulevel;
}
if(statuses != 9){
  sqlwhere +=" and status ="+statuses;
}
if(!numfrom.equals("")){
  sqlwhere +=" and demandnum >="+Util.getIntValue(request.getParameter("numfrom"),0);
}
if(!numto.equals("")){
  sqlwhere +=" and demandnum <="+Util.getIntValue(request.getParameter("numto"),0);
}
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(352,user.getLanguage())+",/hrm/report/usedemand/HrmRpUseDemand.jsp,_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(15101,user.getLanguage())+",/hrm/report/usedemand/HrmUseDemandReport.jsp,_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{Excel,/weaver/weaver.file.ExcelOut,ExcelOut} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="submitData()" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
		  <input type=button class="e8_btn_top" onclick="excel();" value="<%=SystemEnv.getHtmlLabelName(28343, user.getLanguage())%>"></input>
		  <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form name=frmmain method=post action="HrmRpUseDemandDetail.jsp">
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
    <wea:item><%=SystemEnv.getHtmlLabelName(15934,user.getLanguage())%></wea:item>
    <wea:item>
	    <select name="fromdateselect" id="fromdateselect" onchange="changeDate(this,'spanFromdate');" style="width: 135px">
    		<option value="0" <%=fromdateselect.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
    		<option value="1" <%=fromdateselect.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
    		<option value="2" <%=fromdateselect.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
    		<option value="3" <%=fromdateselect.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
    		<option value="4" <%=fromdateselect.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
    		<option value="5" <%=fromdateselect.equals("5")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
    		<option value="6" <%=fromdateselect.equals("6")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
    	</select>
       <span id=spanFromdate style="<%=fromdateselect.equals("6")?"":"display:none;" %>">
      		<BUTTON class=Calendar type="button" id=selectFromdate onclick="getDate(fromdatespan,fromdate)"></BUTTON>
       		<SPAN id=fromdatespan ><%=fromdate%></SPAN>－
       		<BUTTON class=Calendar type="button" id=selectEnddate onclick="getDate(enddatespan,enddate)"></BUTTON>
       		<SPAN id=enddatespan ><%=enddate%></SPAN>
       </span>
       <input class=inputstyle type="hidden" id="fromdate" name="fromdate" value="<%=fromdate%>">
       <input class=inputstyle type="hidden" id="enddate" name="enddate" value="<%=enddate%>">
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15175,user.getLanguage())%></wea:item>
    <wea:item>
    	<select name="fromdatetoselect" id="fromdatetoselect" onchange="changeDate(this,'spanFromdateto');" style="width: 135px">
    		<option value="0" <%=fromdatetoselect.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
    		<option value="1" <%=fromdatetoselect.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
    		<option value="2" <%=fromdatetoselect.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
    		<option value="3" <%=fromdatetoselect.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
    		<option value="4" <%=fromdatetoselect.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
    		<option value="5" <%=fromdatetoselect.equals("5")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
    		<option value="6" <%=fromdatetoselect.equals("6")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
    	</select>
       <span id=spanFromdateto style="<%=fromdatetoselect.equals("6")?"":"display:none;" %>">
      		<BUTTON class=Calendar type="button" id=selectFromdateto onclick="getDate(fromdatetospan,fromdateto)"></BUTTON>
       		<SPAN id=fromdatetospan ><%=fromdateto%></SPAN>－
       		<BUTTON class=Calendar type="button" id=selectEnddateto onclick="getDate(enddatetospan,enddateto)"></BUTTON>
       		<SPAN id=enddatetospan ><%=enddateto%></SPAN>
       </span>
       <input class=inputstyle type="hidden" id="fromdateto" name="fromdateto" value="<%=fromdateto%>">
       <input class=inputstyle type="hidden" id="enddateto" name="enddateto" value="<%=enddateto%>"> 
    </wea:item>          
    <wea:item><%=SystemEnv.getHtmlLabelName(15393,user.getLanguage())%></wea:item>
    <wea:item>
    <!-- 
      <input type="hidden" class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
       _displayText="<%=DepartmentComInfo.getDepartmentname(departmentid)%>" id=departmentid
       name=departmentid value="<%=departmentid%>"
      >
     --> 
      <brow:browser viewType="0" name="departmentid" browserValue='<%=departmentid %>' 
	      browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/DepartmentBrowser.jsp" hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
	      completeUrl="/data.jsp?type=4" width="165px"
	      browserSpanValue='<%=DepartmentComInfo.getDepartmentname(departmentid)%>'>
	   	</brow:browser> 
    </wea:item> 
    <wea:item><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></wea:item>
    <wea:item>
    	<!-- 
    	       <input type="hidden" class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp"
       _displayText="<%=JobTitlesComInfo.getJobTitlesname(jobtitleid)%>"
       id=jobtitleid name=jobtitleid value="<%=jobtitleid%>"
       >
    	 -->
      <brow:browser viewType="0" name="jobtitleid" browserValue='<%=jobtitleid %>' 
	      browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp" hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
	      completeUrl="/data.jsp?type=hrmjobtitles" width="165px"
	      browserSpanValue='<%=JobTitlesComInfo.getJobTitlesname(jobtitleid)%>'>
	   	</brow:browser> 
    </wea:item>         
    <wea:item><%=SystemEnv.getHtmlLabelName(6152,user.getLanguage())%></wea:item>
    <wea:item>
      <brow:browser viewType="0" name="usekind" browserValue='<%=usekind %>' 
	      browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/usekind/UseKindBrowser.jsp" hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
	      completeUrl="/data.jsp?type=usedemand" width="165px"
	      browserSpanValue='<%=UseKindComInfo.getUseKindname(usekind)%>'>
	   	</brow:browser>
	   	<!-- 
	   	 <input type="hidden" class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/hrm/usekind/UseKindBrowser.jsp"
       _displayText="<%=UseKindComInfo.getUseKindname(usekind)%>"
       id=usekind name=usekind value="<%=usekind%>"
       > 
	   	 -->
    </wea:item>   
    <wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
    <wea:item>
      <select class=inputstyle name=statuses value="<%=statuses %>">
        <option value=9 <%if(statuses  == 9){%>selected <%}%>></option>
        <option value=0 <%if(statuses  == 0){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15746,user.getLanguage())%></option>
        <option value=1 <%if(statuses  == 1){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15747,user.getLanguage())%></option>
        <option value=2 <%if(statuses  == 2){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15748,user.getLanguage())%></option>
        <option value=3 <%if(statuses  == 3){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15749,user.getLanguage())%></option>
        <option value=4 <%if(statuses  == 4){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15750,user.getLanguage())%></option> </select>
    </wea:item>              
    <wea:item><%=SystemEnv.getHtmlLabelName(1859,user.getLanguage())%></wea:item>
    <wea:item>
      <input class=inputstyle type=text size=5 name="numfrom" style="width: 80px" value="<%=numfrom%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("numfrom")' >--<input class=inputstyle type=text style="width: 80px" size=5 name="numto" value="<%=numto%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("numto")' >             
    </wea:item>   
    <wea:item><%=SystemEnv.getHtmlLabelName(1860,user.getLanguage())%></wea:item>
    <wea:item>   
      <brow:browser viewType="0" name="edulevel" browserValue='<%=edulevel %>' 
	      browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/educationlevel/EduLevelBrowser.jsp" hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
	      completeUrl="/data.jsp?type=educationlevel" width="165px"
	      browserSpanValue='<%=EducationLevelComInfo.getEducationLevelname(edulevel)%>'>
	   	</brow:browser>
	   	<!-- 
	    <input type="hidden" class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/hrm/educationlevel/EduLevelBrowser.jsp"
       _displayText="<%=EducationLevelComInfo.getEducationLevelname(edulevel)%>"
       id=edulevel name=edulevel value="<%=edulevel%>"> 
	   	 -->
    </wea:item>    
	</wea:group>
</wea:layout>
<TABLE class=ListStyle cellspacing=1 style="display: none">
  <COLGROUP>  
  <COL width="15%">
  <COL width="15%">  
  <COL width="5%">
  <COL width="10%">
  <COL width="15%">
  <COL width="10%">
  <COL width="15%">
  <COL width="15%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=8><%=SystemEnv.getHtmlLabelName(6131,user.getLanguage())%></TH></TR>
    <TR class=Header>    
    <TD><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1859,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(6152,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(6153,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(616,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15175,user.getLanguage())%></TD>
  </TR>
  <TR class=Line style="height: 1px;"><TD colspan="8" ></TD></TR> 
<%
   ExcelFile.init ();
   String filename = SystemEnv.getHtmlLabelName(16062,user.getLanguage()) ; 
   filename += fromdate+"--"+  enddate;
   ExcelFile.setFilename(filename+"  "+year+"-"+month) ;
   
   // 下面建立一个头部的样式, 我们系统中的表头都采用这个样式!
   ExcelStyle es = ExcelFile.newExcelStyle("Header") ;
   es.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
   es.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
   es.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
   es.setAlign(ExcelStyle.WeaverHeaderAlign) ;
   
   ExcelSheet et = ExcelFile.newExcelSheet(""+year+filename) ;
   // 下面设置每一列的宽度, 如果不设置, 将按照excel默认的宽度  
   et.addColumnwidth(6000) ;
   et.addColumnwidth(6000) ;
   et.addColumnwidth(2000) ;
   et.addColumnwidth(4000) ;
   et.addColumnwidth(4000) ;
   et.addColumnwidth(4000) ;
   et.addColumnwidth(4000) ;
   et.addColumnwidth(4000) ;
   
   ExcelRow erdepType = null ;
   erdepType = et.newExcelRow();
   erdepType.addStringValue(SystemEnv.getHtmlLabelName(6086,user.getLanguage()), "Header" ) ; 
   erdepType.addStringValue(SystemEnv.getHtmlLabelName(124,user.getLanguage()), "Header" ) ; 
   erdepType.addStringValue(SystemEnv.getHtmlLabelName(1859,user.getLanguage()), "Header" ) ; 
   erdepType.addStringValue(SystemEnv.getHtmlLabelName(6152,user.getLanguage()), "Header" ) ; 
   erdepType.addStringValue(SystemEnv.getHtmlLabelName(6153,user.getLanguage()), "Header" ) ; 
   erdepType.addStringValue(SystemEnv.getHtmlLabelName(602,user.getLanguage()), "Header" ) ; 
   erdepType.addStringValue(SystemEnv.getHtmlLabelName(616,user.getLanguage()), "Header" ) ; 
   erdepType.addStringValue(SystemEnv.getHtmlLabelName(15175,user.getLanguage()), "Header" ) ; 
    
String sql = "select * from HrmUseDemand where 1 = 1 "+ sqlwhere +" order by referdate desc"; 
rs.executeSql(sql); 
int needchange = 0; 
while(rs.next()){ 
ExcelRow erdep = et.newExcelRow() ;

String	jobtitle=Util.null2String(rs.getString("demandjobtitle")); 
String  department = Util.null2String(rs.getString("demanddep")); 
String	num= Util.null2String(rs.getString("demandnum")); 
String  kind = Util.null2String(rs.getString("demandkind"));
String  date = Util.null2String(rs.getString("demandregdate"));
String  referman = Util.null2String(rs.getString("refermandid"));
String  referdate = Util.null2String(rs.getString("referdate"));
int  status = Util.getIntValue(rs.getString("status"));
String statusname = "";
if(status == 0){statusname = SystemEnv.getHtmlLabelName(15746,user.getLanguage());}
if(status == 1){statusname = SystemEnv.getHtmlLabelName(15747,user.getLanguage());}
if(status == 2){statusname = SystemEnv.getHtmlLabelName(15748,user.getLanguage());}
if(status == 3){statusname = SystemEnv.getHtmlLabelName(15749,user.getLanguage());}
if(status == 4){statusname = SystemEnv.getHtmlLabelName(15750,user.getLanguage());}
erdep.addStringValue(Util.toScreen(JobTitlesComInfo.getJobTitlesname(jobtitle),user.getLanguage()));
erdep.addStringValue(Util.toScreen(DepartmentComInfo.getDepartmentname(department),user.getLanguage()));
erdep.addStringValue(Util.toScreen(num,user.getLanguage()));
erdep.addStringValue(Util.toScreen(UseKindComInfo.getUseKindname(kind),user.getLanguage()));
erdep.addStringValue(Util.toScreen(date,user.getLanguage()));
erdep.addStringValue(Util.toScreen(statusname,user.getLanguage()));
erdep.addStringValue(Util.toScreen(ResourceComInfo.getResourcename(referman) ,user.getLanguage()));
erdep.addStringValue(Util.toScreen(referdate,user.getLanguage()));
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
   <TD><%=JobTitlesComInfo.getJobTitlesname(jobtitle)%>
   </TD>
   <td><%=DepartmentComInfo.getDepartmentname(department) %>
   </td>
   <TD><%=num%>
   </TD> 
   <TD><%=UseKindComInfo.getUseKindname(kind)%>
   </TD> 
   <TD><%=date%>
   </TD> 
   <td> <%=statusname%>
   </td>
   <td><%=ResourceComInfo.getResourcename(referman) %>
   </td>
   <td><%=referdate %>
   </td>
  </TR>
<% 
  }catch(Exception e){ 
  rs.writeLog(e.toString()); } } 
%>
</TBODY>
</TABLE>
  <wea:layout type="diycol">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("15101,356",user.getLanguage())%>' >
		<wea:item attributes="{'isTableList':'true','colspan':'full'}">
			<%
				request.getSession().setAttribute("et",et);
				String tableString =" <table datasource=\"weaver.hrm.HrmDataSource.getHrmCareerApplyReport\" sourceparams=\"\" pageId=\""+PageIdConst.Hrm_RpUseDemandDetail+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.Hrm_RpUseDemandDetail,user.getUID(),PageIdConst.HRM)+"\" tabletype=\"none\">"+
					" <sql backfields=\"*\" sqlform=\"temp\" sqlwhere=\"\"  sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"/>"+
				"	<head>";
				ExcelRow er = et.getExcelRow(0);
		  	for(int i=0;er!=null&&i<er.size();i++){
					tableString+="		<col width=\"30%\" text=\""+er.getValue(i).replace("s_","")+"\" column=\""+i+"\"/>";
			  }
				tableString+="	</head></table>";
			%>
						<input type="hidden" _showCol="false" name="pageId" id="pageId" value="<%= PageIdConst.Hrm_RpUseDemandDetail %>"/>
			<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />
		</wea:item>
	</wea:group>
</wea:layout>
 </form>
   <%if("1".equals(isDialog)){ %>
  </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
	    	</wea:item>
	   	</wea:group>
	  </wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
<script language=javascript>  
function submitData() {
 frmmain.submit();
}
</script>

</BODY>
  <SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>

