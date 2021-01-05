<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#frmmain").submit();
}
var parentDialog = parent.parent.getDialog(parent);
var dialog = parent.parent.getDialog(parent);
dialog.checkDataChange = false
function excel(){
	window.location.href="/weaver/weaver.file.ExcelOut";
}
</script>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(15997,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

float resultpercent=0;
int total = 0;
int linecolor=0;
String filename = SystemEnv.getHtmlLabelName(15998,user.getLanguage());
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String newdepartmentParam = Util.null2String(request.getParameter("departmentid"));

String fromdateselect = Util.null2String(request.getParameter("fromdateselect"));
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
if(!fromdateselect.equals("") && !fromdateselect.equals("0")&& !fromdateselect.equals("6")){
	fromdate = TimeUtil.getDateByOption(fromdateselect,"0");
	enddate = TimeUtil.getDateByOption(fromdateselect,"1");
}
String olddepartment=Util.fromScreen(request.getParameter("olddepartment"),user.getLanguage());
String newdepartment=Util.fromScreen(request.getParameter("newdepartment"),user.getLanguage());

String oldjobtitle=Util.fromScreen(request.getParameter("oldjobtitle"),user.getLanguage());
String newjobtitle=Util.fromScreen(request.getParameter("newjobtitle"),user.getLanguage());
String joblevelfrom=Util.fromScreen(request.getParameter("joblevelfrom"),user.getLanguage());
String joblevelto=Util.fromScreen(request.getParameter("joblevelto"),user.getLanguage());

String newjoblevelfrom=Util.fromScreen(request.getParameter("newjoblevelfrom"),user.getLanguage());
String newjoblevelto=Util.fromScreen(request.getParameter("newjoblevelto"),user.getLanguage());

String sqlwhere = "";
/*
Calendar todaycal = Calendar.getInstance ();
String year = Util.add0(todaycal.get(Calendar.YEAR), 4);
if(fromdate.equals("")&&enddate.equals("")){
enddate = year+"-12-31";
fromdate = year+"-01-01";
}*/
if(!fromdate.equals("")){
	sqlwhere+=" and t1.changedate>='"+fromdate+"'";
	filename +=fromdate;
}
if(!enddate.equals("")){
	sqlwhere+=" and (t1.changedate<='"+enddate+"')";
	filename += "--"+enddate;
}
if(!joblevelfrom.equals("")){
	sqlwhere+=" and t1.oldjoblevel>="+joblevelfrom+" ";
}
if(!joblevelto.equals("")){
	sqlwhere+=" and (t1.oldjoblevel<="+joblevelto+") ";
}
if(!newjoblevelfrom.equals("")){
	sqlwhere+=" and t1.newjoblevel>="+newjoblevelfrom+" ";
}
if(!newjoblevelto.equals("")){
	sqlwhere+=" and (t1.newjoblevel<="+newjoblevelto+") ";
}
if(!oldjobtitle.equals("")){
	sqlwhere+=" and t1.oldjobtitleid ="+oldjobtitle+" ";
}
if(!newjobtitle.equals("")){
	sqlwhere+=" and t1.newjobtitleid ="+newjobtitle+" ";
}
if(!olddepartment.equals("")){
	sqlwhere+=" and t1.olddepartmentid = "+olddepartment+" ";
}
if(!newdepartment.equals("")){
	sqlwhere+=" and t1.newDepartmentId = "+newdepartment+" ";
}
if(!"".equals(newdepartmentParam)) {
	sqlwhere+=" and t1.newDepartmentId = "+newdepartmentParam+" ";
}
String sql = "";
//if(!oldjobtitle.equals("")||!newjobtitle.equals("")||!olddepartment.equals("")||!newdepartment.equals("")){
//   sql = "select count(t1.id) from HrmStatusHistory t1,HrmJobtitles t2 where type_n = 4 "+sqlwhere;
//}else{
   sql = "select count(t1.id) from HrmStatusHistory t1 where type_n = 4 AND t1.newDepartmentId IS NOT NULL "+sqlwhere;
//}
//out.println(sql);
rs.executeSql(sql);
rs.next();
total = rs.getInt(1);

String sqlstr = "select t1.* from HrmStatusHistory t1 where type_n = 4 and t1.newSubcompanyId IS NOT NULL "+sqlwhere+" order by changedate desc";

rs.executeSql(sqlstr);
%>
<body>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onBtnSearchClick(),_self} " ;
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
		<!-- 
		<input type=button class="e8_btn_top" onclick="onBtnSearchClick();" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
		 -->
			<input type=button class="e8_btn_top" onclick="excel();" value="<%=SystemEnv.getHtmlLabelName(28343, user.getLanguage())%>"></input>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
<form id=frmmain name=frmmain method=post action="HrmRpRedeployDetail.jsp">
	<input name="isdialog" type="hidden" value="1">
	<wea:layout type="4col">
	  <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'> 
    <wea:item><%=SystemEnv.getHtmlLabelName(15481,user.getLanguage())%></wea:item>
    <wea:item>
    	<brow:browser viewType="0" name="olddepartment" browserValue='<%=olddepartment%>' 
      browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/DepartmentBrowser.jsp?selectedids="
      hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
      browserSpanValue='<%=Util.toScreen(DepartmentComInfo.getDepartmentname(olddepartment),user.getLanguage())%>'
      completeUrl="/data.jsp?type=4">
      </brow:browser>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15480,user.getLanguage())%></wea:item>
    <wea:item>
      <brow:browser viewType="0" name="newdepartment" browserValue='<%=newdepartment%>' 
      browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/DepartmentBrowser.jsp?selectedids="
      hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
      browserSpanValue='<%=Util.toScreen(DepartmentComInfo.getDepartmentname(newdepartment),user.getLanguage())%>'
      completeUrl="/data.jsp?type=4">
      </brow:browser>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15999,user.getLanguage())%></wea:item>
    <wea:item>
      <brow:browser viewType="0" name="oldjobtitle" browserValue='<%=oldjobtitle%>' 
      browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp"
      hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
      browserSpanValue='<%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(oldjobtitle),user.getLanguage())%>'
      completeUrl="/data.jsp?type=hrmjobtitles">
      </brow:browser>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(16000,user.getLanguage())%></wea:item>
    <wea:item>
      <brow:browser viewType="0" name="newjobtitle" browserValue='<%=newjobtitle%>' 
      browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp"
      hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
      browserSpanValue='<%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(newjobtitle),user.getLanguage())%>'
      completeUrl="/data.jsp?type=hrmjobtitles">
      </brow:browser>
    </wea:item>   
    <wea:item><%=SystemEnv.getHtmlLabelName(15993,user.getLanguage())%></wea:item>
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
    <wea:item><%=SystemEnv.getHtmlLabelName(15994,user.getLanguage())%>:</wea:item>
    <wea:item>
      <INPUT class=inputStyle maxLength=20 size=6 style="width: 60px" name="joblevelfrom"    onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("joblevelfrom")' value="<%=joblevelfrom%>">--
      <INPUT class=inputStyle maxLength=20 size=6 style="width: 60px" name="joblevelto"    onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("joblevelto")' value="<%=joblevelto%>">
    </wea:item>     
    <wea:item><%=SystemEnv.getHtmlLabelName(15995,user.getLanguage())%>:</wea:item>
    <wea:item>
      <INPUT class=inputStyle maxLength=20 size=6 style="width: 60px" name="newjoblevelfrom"    onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("joblevelfrom")' value="<%=newjoblevelfrom%>">--
      <INPUT class=inputStyle maxLength=20 size=6 style="width: 60px" name="newjoblevelto"    onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("joblevelto")' value="<%=newjoblevelto%>">
    </wea:item>
	</wea:group>
	<wea:group context="">
		<wea:item type="toolbar">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick();"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		</wea:item>
	</wea:group>
</wea:layout>
</form>
</div>

<table class=ListStyle cellspacing=1 style="display: none">
<tbody>
  <tr class=header>
    <td><%=SystemEnv.getHtmlLabelName(16001,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(15481,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(15999,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(15480,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(16000,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(6111,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(15994,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(15995,user.getLanguage())%></td>
  </tr>
  <%
   ExcelFile.init ();
   ExcelFile.setFilename(""+filename) ;

   // 下面建立一个头部的样式, 我们系统中的表头都采用这个样式!
   ExcelStyle es = ExcelFile.newExcelStyle("Header") ;
   es.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
   es.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
   es.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
   es.setAlign(ExcelStyle.WeaverHeaderAlign) ;
   
   ExcelSheet et = ExcelFile.newExcelSheet(Util.toScreen(filename,user.getLanguage())) ;

   // 下面设置每一列的宽度, 如果不设置, 将按照excel默认的宽度  
   et.addColumnwidth(4000) ;
   et.addColumnwidth(6000) ;
   et.addColumnwidth(4000) ;
   et.addColumnwidth(6000) ;
   et.addColumnwidth(4000) ;
   et.addColumnwidth(4000) ;
   
   ExcelRow er = null ;

   er = et.newExcelRow() ;
   er.addStringValue( SystemEnv.getHtmlLabelName(16001,user.getLanguage()) , "Header" ) ;  
   er.addStringValue( SystemEnv.getHtmlLabelName(15481,user.getLanguage()) , "Header" ) ;  
   er.addStringValue( SystemEnv.getHtmlLabelName(15999,user.getLanguage()) , "Header" ) ;  
   er.addStringValue( SystemEnv.getHtmlLabelName(15480,user.getLanguage()) , "Header" ) ;  
   er.addStringValue( SystemEnv.getHtmlLabelName(16000,user.getLanguage()) , "Header" ) ;  
   er.addStringValue( SystemEnv.getHtmlLabelName(6111,user.getLanguage()) , "Header" ) ;  
   er.addStringValue( SystemEnv.getHtmlLabelName(15994,user.getLanguage()) , "Header" ) ;  
   er.addStringValue( SystemEnv.getHtmlLabelName(15995,user.getLanguage()) , "Header" ) ;  
  
   if(total!=0){
     while(rs.next()){
     //String departmentid = JobTitlesComInfo.getDepartmentid(rs.getString("oldjobtitleid"));	
     //String newdepartmentid = DepartmentComInfo.getDepartmentname(rs.getString("newDepartmentId"));
     String resourcename = Util.toScreen(ResourceComInfo.getResourcename(rs.getString("resourceid")),user.getLanguage());	
     String olddepartnemtname = Util.toScreen(DepartmentComInfo.getDepartmentname(rs.getString("oldDepartmentId")),user.getLanguage());
     String oldjobtitlename = Util.toScreen(JobTitlesComInfo.getJobTitlesname(rs.getString("oldjobtitleid")),user.getLanguage());
     String newdepartmentname = Util.toScreen(DepartmentComInfo.getDepartmentname(rs.getString("newDepartmentId")),user.getLanguage());
     String newjobtitlename = Util.toScreen(JobTitlesComInfo.getJobTitlesname(rs.getString("newjobtitleid")),user.getLanguage());
     String changedate = Util.toScreen(rs.getString("changedate"),user.getLanguage());
     String oldjoblevel = rs.getString("oldjoblevel");
     String newjoblevel = rs.getString("newjoblevel");
     
     er = et.newExcelRow() ;
     er.addStringValue(resourcename) ;
     er.addStringValue(olddepartnemtname) ;
     er.addStringValue(oldjobtitlename) ;
     er.addStringValue(newdepartmentname) ;
     er.addStringValue(newjobtitlename) ;
     er.addStringValue(changedate) ;
     er.addStringValue(oldjoblevel) ;
     er.addStringValue(newjoblevel) ;
   %>
  <TR <%if(linecolor==0){%>class=datalight <%} else {%> class=datadark <%}%>>
    <TD><a href="/hrm/resource/HrmResource.jsp?id=<%=rs.getString("resourceid")%>"> <%=resourcename%></a></TD>
    <TD><a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=rs.getString("oldDepartmentId")%>"> <%=olddepartnemtname%></a></TD>
    <TD><a href="/hrm/jobtitles/HrmJobTitlesEdit.jsp?id=<%=rs.getString("oldjobtitleid")%>"> <%=oldjobtitlename%></a></TD>
    <TD><a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=rs.getString("newDepartmentId")%>"> <%=newdepartmentname%></a></TD>
    <TD><a href="/hrm/jobtitles/HrmJobTitlesEdit.jsp?id=<%=rs.getString("newjobtitleid")%>"> <%=newjobtitlename%></a></TD>
    <TD><%=changedate%></TD>    
    <TD><%=oldjoblevel%></TD>
    <TD><%=newjoblevel%></TD>
    </TR>
    <%		if(linecolor==0) linecolor=1;
    		else	linecolor=0;
    		}
	} %>  
</table>
<%
String tableString=""+
"<table instanceid=\"BrowseTable\" pageId=\""+PageIdConst.HRM_Select+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_Select,user.getUID(),PageIdConst.HRM)+"\"  datasource=\"weaver.hrm.HrmDataSource.getHrmRpRedeployDetailList\" sourceparams=\"sqlstr:"+Util.toHtmlForSplitPage(sqlstr)+"\" tabletype=\"none\">"+
"<sql backfields=\"*\"  sqlform=\"temp\" sqlorderby=\"changedate\"  sqlprimarykey=\"changedate\" sqlsortway=\"desc\"  />"+
"<head>";
	tableString+=	 "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(16001,user.getLanguage())+"\" column=\"resourcename\" orderkey=\"resourcename\"/>";
	tableString+=	 "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(15481,user.getLanguage())+"\" column=\"olddepartnemtname\" orderkey=\"olddepartnemtname\"/>";
	tableString+=  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15999,user.getLanguage())+"\" column=\"oldjobtitlename\" orderkey=\"oldjobtitlename\"/>";
	tableString+=  "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(15480,user.getLanguage())+"\" column=\"newdepartmentname\" orderkey=\"newdepartmentname\"/>";
	tableString+=	 "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(16000,user.getLanguage())+"\" column=\"newjobtitlename\" orderkey=\"newjobtitlename\"/>";
	tableString+=	 "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(6111,user.getLanguage())+"\" column=\"changedate\" orderkey=\"changedate\"/>";
	tableString+=  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15994,user.getLanguage())+"\" column=\"oldjoblevel\" orderkey=\"oldjoblevel\"/>";
	tableString+=  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15995,user.getLanguage())+"\" column=\"newjoblevel\" orderkey=\"newjoblevel\"/>"+
"</head>"+
"</table>";      
%>
<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.HRM_Select %>"/>
<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/> 

<%if("1".equals(isDialog)){ %>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
    <wea:group context="">
    	<wea:item type="toolbar">
    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentDialog.closeByHand();">
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
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
