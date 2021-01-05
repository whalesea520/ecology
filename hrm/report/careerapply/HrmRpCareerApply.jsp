<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.teechart.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CareerApplyManager" class="weaver.hrm.report.RpCareerApplyManager" scope="session"/>
<jsp:useBean id="CareerPlanComInfo" class="weaver.hrm.career.CareerPlanComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function openDialog(cmd){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "";
	if(cmd=="HrmCareerApplyReport"){
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(33535,user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmCareerApplyReport&isdialog=1";
		dialog.Width = 800;
		dialog.Height = 603;
	}else if(cmd=="HrmRpCareerApplySearch"){
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(15729,user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmRpCareerApplySearch&isdialog=1";
		dialog.Width = 1000;
		dialog.Height = 603;
	}
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function HrmCareerApplyReport(){
	openDialog("HrmCareerApplyReport");
}
function HrmRpCareerApplySearch(){
	openDialog("HrmRpCareerApplySearch");
}
</script>
</head>
<%
String year = Util.null2String(request.getParameter("year"));
String month = Util.null2String(request.getParameter("month"));
if(year.equals("")){
Calendar todaycal = Calendar.getInstance ();
year = Util.add0(todaycal.get(Calendar.YEAR), 4);
month = Util.add0(todaycal.get(Calendar.MONTH)+1, 2);
}

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(15885,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(15938,user.getLanguage());
String needfav ="1";
String needhelp ="";

float resultpercent=0;
int total = 0;
int linecolor=0;

String fromdateselect = Util.null2String(request.getParameter("fromdateselect"));
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
if(!fromdateselect.equals("") && !fromdateselect.equals("0")&& !fromdateselect.equals("6")){
	fromdate = TimeUtil.getDateByOption(fromdateselect,"0");
	enddate = TimeUtil.getDateByOption(fromdateselect,"1");
}
String planid=Util.fromScreen(request.getParameter("planid"),user.getLanguage());
int space=Util.getIntValue(request.getParameter("space"));
int content=Util.getIntValue(request.getParameter("content"),1);
if(content == 4){
  space=Util.getIntValue(request.getParameter("space"),10000);
}
if(content == 5){
  space=Util.getIntValue(request.getParameter("space"),1);
}
String salaryfrom=Util.fromScreen(request.getParameter("salaryfrom"),user.getLanguage());
String salaryto=Util.fromScreen(request.getParameter("salaryto"),user.getLanguage());
String worktimefrom=Util.fromScreen(request.getParameter("worktimefrom"),user.getLanguage());
String worktimeto=Util.fromScreen(request.getParameter("worktimeto"),user.getLanguage());

String sqlwhere = "";
boolean ischange = false;
if(fromdate.equals("")&&enddate.equals("")){
//  fromdate = year+"-"+month+"-01";
//  enddate = year+"-"+month+"-31";
}
if(!fromdate.equals("")){
	sqlwhere+=" and createdate>='"+fromdate+"'";
}
if(!enddate.equals("")){
  if(rs.getDBType().equals("oracle")){
	sqlwhere+=" and (createdate<='"+enddate+"' and createdate is not null)";
  }else{
    sqlwhere+=" and (createdate<='"+enddate+"' and createdate is not null and createdate <> '')";
  }
}
if(!planid.equals("")){
  ischange = true;
  sqlwhere += " and t1.careerinviteid = t3.id and t3.careerplanid = "  +planid;
}
if(!salaryfrom.equals("")){
  sqlwhere += " and t2.salaryneed >= "  +salaryfrom;
}
if(!salaryto.equals("")){
  sqlwhere += " and t2.salaryneed <= "  +salaryto;
}
if(!worktimefrom.equals("")){
  sqlwhere += " and t2.worktime >= "  +worktimefrom;
}
if(!worktimeto.equals("")){
  sqlwhere += " and t2.worktime <= "  +worktimeto;
}
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(33535,user.getLanguage())+",javascript:HrmCareerApplyReport(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15729,user.getLanguage())+",javascript:HrmRpCareerApplySearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="submitData()" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
			<input type=button class="e8_btn_top" onclick="HrmCareerApplyReport()" value="<%=SystemEnv.getHtmlLabelName(33535,user.getLanguage())%>"></input>
			<input type=button class="e8_btn_top" onclick="HrmRpCareerApplySearch()" value="<%=SystemEnv.getHtmlLabelName(15729,user.getLanguage())%>"></input>
		  <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form name=frmmain method=post action="HrmRpCareerApply.jsp">
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
    <wea:item><%=SystemEnv.getHtmlLabelName(1855,user.getLanguage())%></wea:item>
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
    <wea:item><%=SystemEnv.getHtmlLabelName(6132,user.getLanguage())%></wea:item>
    <wea:item>
	   	<brow:browser viewType="0" name="planid" browserValue='<%=planid %>' 
	      browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/career/careerplan/CareerPlanBrowser.jsp" hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
	      completeUrl="/data.jsp?type=164" width="250px"
	      browserSpanValue='<%=CareerPlanComInfo.getCareerPlantopic(planid)%>'>
	   	</brow:browser>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15673,user.getLanguage())%></wea:item>
    <wea:item>
      <INPUT  class=inputstyle maxLength=6 size=6 name="salaryfrom" style="width: 100px"  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("salaryfrom")' value="<%=salaryfrom%>">－
      <INPUT  class=inputstyle maxLength=6 size=6 name="salaryto" style="width: 100px" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("salaryto")' value="<%=salaryto%>">
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(1844,user.getLanguage())%></wea:item>
    <wea:item>
      <INPUT  class=inputstyle maxLength=6 size=6 name="worktimefrom" style="width: 100px" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("worktimefrom")' value="<%=worktimefrom%>">－
      <INPUT  class=inputstyle maxLength=6 size=6 name="worktimeto" style="width: 100px" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("worktimeto")' value="<%=worktimeto%>">
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15935,user.getLanguage())%></wea:item>
    <wea:item>
       <select class=inputstyle name="content" value="<%=content%>" onChange="dosubmit()">
         <option value=1 <%if(content == 1){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15671,user.getLanguage())%> </option>
         <option value=2 <%if(content == 2){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15931,user.getLanguage())%> </option>
         <option value=3 <%if(content == 3){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%> </option>
         <option value=4 <%if(content == 4){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15673,user.getLanguage())%> </option>
         <option value=5 <%if(content == 5){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1844,user.getLanguage())%> </option>
       </select>
    </wea:item>
		<%if(content == 4 || content == 5){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(15932,user.getLanguage())%></wea:item>
    <wea:item>
      <INPUT  class=inputstyle maxLength=6 size=6 name="space"  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("space")' value="<%=space%>">
    </wea:item>
		<%}%>
	</wea:group>
</wea:layout>
<wea:layout type="diycol">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("15101,356",user.getLanguage())%>' >
		<wea:item attributes="{'isTableList':'true','colspan':'full'}">
			<%
				String title_name = "";
				if(content==1){title_name = SystemEnv.getHtmlLabelName(15671,user.getLanguage());}
				if(content==2){title_name = SystemEnv.getHtmlLabelName(15931,user.getLanguage());}
				if(content==3){title_name = SystemEnv.getHtmlLabelName(818,user.getLanguage());}
				if(content==4){title_name = SystemEnv.getHtmlLabelName(15673,user.getLanguage());}
				if(content==5){title_name = SystemEnv.getHtmlLabelName(1844,user.getLanguage());}
				String tableString =" <table datasource=\"weaver.hrm.HrmDataSource.getHrmRpCareerApply\" sourceparams=\"planid:"+planid+"+sqlwhere:"+Util.toHtmlForSplitPage(sqlwhere)+"+space:"+space+"+content:"+content+"\" pageId=\""+PageIdConst.Hrm_RpCareerApply+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.Hrm_RpCareerApply,user.getUID(),PageIdConst.HRM)+"\" tabletype=\"none\">"+
					" <sql backfields=\"*\" sumColumns=\"resultcount\" sqlform=\"temp\" sqlwhere=\"\"  sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"/>"+
				"	<head>"+
				"		<col width=\"30%\" text=\""+title_name+"\" column=\"name\" orderkey=\"name\" />"+
				"		<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(1859,user.getLanguage())+"\" column=\"resultcount\" orderkey=\"resultcount\" />"+
				"		<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelName(336,user.getLanguage())+"\" column=\"resultcount\" orderkey=\"resultcount\" algorithmdesc=\"resultpercent\" molecular=\"resultcount\" denominator=\"total\" />"+
				"	</head></table>";
			%>
			<input type="hidden" _showCol="false" name="pageId" id="pageId" value="<%= PageIdConst.Hrm_RpCareerApply %>"/>
			<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />
		</wea:item>
	</wea:group>
</wea:layout>
</form>
<script language=javascript>
function submitData() {
	if(validateDate()){
 		frmmain.submit();		
	}
}
function validateDate(){
	var fromdateselect = jQuery("#fromdateselect").val();
	if('6'==fromdateselect){
		var fromdate = jQuery("input[name=fromdate]").val();
		var enddate = jQuery("input[name=enddate]").val();
		if(fromdate!=""&&enddate!=""){
			if(fromdate>enddate){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(1855,user.getLanguage())
							+SystemEnv.getHtmlLabelName(32530,user.getLanguage())
							+SystemEnv.getHtmlLabelName(16721,user.getLanguage())%>");
				return false;
			}
		}
	}
	return true;
}
</script>
<script language=javascript>
  function dosubmit(){
    frmmain.submit();
  }
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
