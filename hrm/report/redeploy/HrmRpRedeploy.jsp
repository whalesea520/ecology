<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.teechart.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<%
String year = Util.null2String(request.getParameter("year"));
if(year.equals("")){
Calendar todaycal = Calendar.getInstance ();
year = Util.add0(todaycal.get(Calendar.YEAR), 4);
}

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(15991,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

String fromdateselect = Util.null2String(request.getParameter("fromdateselect"));
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
if(!fromdateselect.equals("") && !fromdateselect.equals("0")&& !fromdateselect.equals("6")){
	fromdate = TimeUtil.getDateByOption(fromdateselect,"0");
	enddate = TimeUtil.getDateByOption(fromdateselect,"1");
}
String joblevelfrom=Util.fromScreen(request.getParameter("joblevelfrom"),user.getLanguage());
String joblevelto=Util.fromScreen(request.getParameter("joblevelto"),user.getLanguage());
String newjoblevelfrom=Util.fromScreen(request.getParameter("newjoblevelfrom"),user.getLanguage());
String newjoblevelto=Util.fromScreen(request.getParameter("newjoblevelto"),user.getLanguage());
String newsubcompanyid=Util.fromScreen(request.getParameter("newsubcompanyid"),user.getLanguage());
%>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#frmmain").submit();
}

function reloadPage(){
	onBtnSearchClick();
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}
function openDialog(cmd,id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "";
	if(cmd=="HrmRpRedeployTime"){
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(15992,user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmRpRedeployTime&isdialog=1";
	}else if(cmd=="HrmRedeployReport"){
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(15989,user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmRedeployReport&isdialog=1";
	}else if(cmd=="HrmRpRedeployDetail"){
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(15729,user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmRpRedeployDetail&isdialog=1";
	}else if(cmd=="DepartmentDetail"){
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(15729,user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmRpRedeployDetail&isdialog=1&departmentid="+id
		+"&joblevelfrom=<%=joblevelfrom %>&joblevelto=<%=joblevelto %>&fromdateselect=<%=fromdateselect %>"+
		"&fromdate=<%=fromdate %>&enddate=<%=enddate %>&newjoblevelfrom=<%=newjoblevelfrom %>&newjoblevelto=<%=newjoblevelto %>"+
		"&newsubcompanyid=<%=newsubcompanyid %>";
	}
	dialog.Width = 800;
	dialog.Height = 603;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function HrmRpRedeployTime(){
	openDialog("HrmRpRedeployTime");
}
function HrmRedeployReport(){
	openDialog("HrmRedeployReport");
}
function HrmRpRedeployDetail(){
	openDialog("HrmRpRedeployDetail");
}

function HrmDepartmentDetail(id){
	openDialog("DepartmentDetail",id);
}
</script>
</head>

<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15992,user.getLanguage())+",javascript:HrmRpRedeployTime(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15989,user.getLanguage())+",javascript:HrmRedeployReport(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15729,user.getLanguage())+",javascript:HrmRpRedeployDetail(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name=frmmain id="frmmain" method=post action="HrmRpRedeploy.jsp">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="HrmRpRedeployTime();" value="<%=SystemEnv.getHtmlLabelName(15992,user.getLanguage())%>"></input>
			<input type=button class="e8_btn_top" onclick="HrmRedeployReport();" value="<%=SystemEnv.getHtmlLabelName(15989,user.getLanguage())%>"></input>
			<input type=button class="e8_btn_top" onclick="HrmRpRedeployDetail();" value="<%=SystemEnv.getHtmlLabelName(15729,user.getLanguage())%>"></input>
		  <span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
		  <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>   
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
    <wea:item><%=SystemEnv.getHtmlLabelName(15994,user.getLanguage())%></wea:item>
    <wea:item>
      <INPUT class=inputStyle maxLength=20 size=6 name="joblevelfrom" style="width: 60px" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("joblevelfrom")' value="<%=joblevelfrom%>">--
      <INPUT class=inputStyle maxLength=20 size=6 name="joblevelto" style="width: 60px" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("joblevelto")' value="<%=joblevelto%>">
    </wea:item>     
    <wea:item><%=SystemEnv.getHtmlLabelName(15995,user.getLanguage())%></wea:item>
    <wea:item>
      <INPUT class=inputStyle maxLength=20 size=6 name="newjoblevelfrom" style="width: 60px" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("joblevelfrom")' value="<%=newjoblevelfrom%>">--
      <INPUT class=inputStyle maxLength=20 size=6 name="newjoblevelto" style="width: 60px" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("joblevelto")' value="<%=newjoblevelto%>">
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(33517 ,user.getLanguage())%></wea:item>
    <wea:item>
     <%String browserUrl = "/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser.jsp?excludeid="+newsubcompanyid +"&selectedids=";%>
   	<brow:browser viewType="0" name="newsubcompanyid" browserValue='<%=newsubcompanyid %>' 
      browserUrl='<%= browserUrl %>' hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
      completeUrl="/data.jsp?type=164" width="250px"
      browserSpanValue='<%=newsubcompanyid.length()>0?Util.toScreen(SubCompanyComInfo.getSubcompanynames(newsubcompanyid+""),user.getLanguage()):""%>'>
   	</brow:browser>
    </wea:item> 
	</wea:group>
	<wea:group context="">
		<wea:item type="toolbar">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick();"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		</wea:item>
	</wea:group>
</wea:layout>
</div>
</form>
<% 
	String sqlwhere = " where t1.type_n = 4 and t1.newSubcompanyId IS NOT NULL ";
	
	if(!fromdate.equals("")){
		sqlwhere+=" and t1.changedate>='"+fromdate+"'";
	}
	if(!enddate.equals("")){
		sqlwhere+=" and (t1.changedate<='"+enddate+"')";
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
	if(!newsubcompanyid.equals("")){
		sqlwhere+=" and t1.newSubcompanyId ="+newsubcompanyid;
	}

	String denominator = " select count(t1.id) from HrmStatusHistory t1 "+sqlwhere;
	String tabletype="none";
	String backfields=" t1.newDepartmentId as departmentid, COUNT(*) as molecular, ("+ denominator +") as denominator";
	String sqlform = " HrmStatusHistory t1 ";
	String groupby = " t1.newDepartmentId ";
	String tableString=""+
	   "<table pageId=\""+PageIdConst.HRM_RpRedeployReport+"\" instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_RpRedeployReport,user.getUID(),PageIdConst.HRM)+"\" tabletype=\""+tabletype+"\">"+
	   "<sql backfields=\""+Util.toHtmlForSplitPage(backfields)+"\" sumColumns=\"molecular\"  sqlform=\""+sqlform+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" sqlorderby=\"t1.newDepartmentId\" sqlsortway=\"asc\" sqlgroupby=\""+groupby+"\" sqlprimarykey=\"t1.newDepartmentId\" sqldistinct=\"true\" />"+
	   "<head>"+							 
			 "<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(15480,user.getLanguage())+"\" column=\"departmentid\" orderkey=\"departmentid\" transmethod=\"weaver.hrm.company.DepartmentComInfo.getDepartmentname\" />"+
			 "<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(1859,user.getLanguage())+"\" column=\"molecular\" orderkey=\"molecular\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmChangeStatus\" otherpara=\"column:departmentid\"/>"+
			 "<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelName(31143,user.getLanguage())+"\" column=\"molecular\" algorithmdesc=\""+SystemEnv.getHtmlLabelName(336,user.getLanguage())+"="+SystemEnv.getHtmlLabelName(1859,user.getLanguage())+"/"+SystemEnv.getHtmlLabelName(523,user.getLanguage())+"\" molecular=\"molecular\" denominator=\"denominator\" />"+
	   "</head>"+
	   "</table>";
%>
<input type="hidden" _showCol="false" name="pageId" id="pageId" value="<%= PageIdConst.HRM_RpRedeployReport %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
