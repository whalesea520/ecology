<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.teechart.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
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
	if(cmd=="HrmUseDemandReport"){
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(33815,user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmUseDemandReport&isdialog=1";
	}else if(cmd=="HrmRpUseDemandDetail"){
		var fromdateselect = jQuery("#fromdateselect").val();
		var fromdatetoselect = jQuery("#fromdatetoselect").val();
		var fromdate=jQuery("#fromdate").val();
		var enddate=jQuery("#enddate").val();
		var fromdateto=jQuery("#fromdateto").val();
		var enddateto=jQuery("#enddateto").val();

		dialog.Title = "<%=SystemEnv.getHtmlLabelName(15729,user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmRpUseDemandDetail&isdialog=1&fromdateselect="+fromdateselect+"&fromdatetoselect="+fromdatetoselect+"&fromdate="+fromdate+"&enddate="+enddate+"&fromdateto="+fromdateto+"&enddateto="+enddateto;
	}
	dialog.Width = 800;
	dialog.Height = 603;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function HrmUseDemandReport(){
	openDialog("HrmUseDemandReport");
}
function HrmRpUseDemandDetail(){
	openDialog("HrmRpUseDemandDetail");
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
String titlename = SystemEnv.getHtmlLabelName(16060,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(15938,user.getLanguage()) ;
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
String fromdatetoselect = Util.null2String(request.getParameter("fromdatetoselect"));
String fromdateto=Util.fromScreen(request.getParameter("fromdateto"),user.getLanguage());
String enddateto=Util.fromScreen(request.getParameter("enddateto"),user.getLanguage());
if(!fromdatetoselect.equals("") && !fromdatetoselect.equals("0")&& !fromdatetoselect.equals("6")){
	fromdateto = TimeUtil.getDateByOption(fromdatetoselect,"0");
	enddateto = TimeUtil.getDateByOption(fromdatetoselect,"1");
}

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


%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(33815,user.getLanguage())+",javascript:HrmUseDemandReport(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15729,user.getLanguage())+",javascript:HrmRpUseDemandDetail(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="submitData()" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
			<input type=button class="e8_btn_top" onclick="HrmUseDemandReport()" value="<%=SystemEnv.getHtmlLabelName(33815,user.getLanguage())%>"></input>
			<input type=button class="e8_btn_top" onclick="HrmRpUseDemandDetail()" value="<%=SystemEnv.getHtmlLabelName(15729,user.getLanguage())%>"></input>
		  <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form name=frmmain method=post action="HrmRpUseDemand.jsp">
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
		<wea:item><%=SystemEnv.getHtmlLabelName(15935,user.getLanguage())%></wea:item>
    <wea:item>
       <select class=inputstyle name="content" value="<%=content%>" onChange="dosubmit()">                
         <option value=1 <%if(content == 1){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%> </option>
         <option value=2 <%if(content == 2){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%> </option>
         <option value=3 <%if(content == 3){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(6152,user.getLanguage())%> </option>
         <option value=4 <%if(content == 4){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%> </option>         
       </select>
    </wea:item> 
	</wea:group>  
</wea:layout> 
<wea:layout type="diycol">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("15101,356",user.getLanguage())%>' >
		<wea:item attributes="{'isTableList':'true','colspan':'full'}">
			<%
				String title_name = "";
				if(content==1){title_name = SystemEnv.getHtmlLabelName(124,user.getLanguage());}
				if(content==2){title_name = SystemEnv.getHtmlLabelName(6086,user.getLanguage());}
				if(content==3){title_name = SystemEnv.getHtmlLabelName(6152,user.getLanguage());}
				if(content==4){title_name = SystemEnv.getHtmlLabelName(818,user.getLanguage());}
				String tableString =" <table datasource=\"weaver.hrm.HrmDataSource.getHrmRpUseDemand\" sourceparams=\"content:"+content+"+sqlwhere:"+Util.toHtmlForSplitPage(sqlwhere)+"\" pageId=\""+PageIdConst.Hrm_RpUseDemand+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.Hrm_RpUseDemand,user.getUID(),PageIdConst.HRM)+"\" tabletype=\"none\">"+
					" <sql backfields=\"*\" sumColumns=\"resultcount\" sqlform=\"temp\" sqlwhere=\"\"  sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"/>"+
				"	<head>"+
				"		<col width=\"30%\" text=\""+title_name+"\" column=\"name\" orderkey=\"name\" />"+
				"		<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(1859,user.getLanguage())+"\" column=\"resultcount\" orderkey=\"resultcount\" />"+
				"		<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelName(336,user.getLanguage())+"\" column=\"resultcount\" orderkey=\"resultcount\" algorithmdesc=\"resultpercent\" molecular=\"resultcount\" denominator=\"total\" />"+
				"	</head></table>";
			%>
			<input type="hidden" _showCol="false" name="pageId" id="pageId" value="<%= PageIdConst.Hrm_RpUseDemand %>"/>
			<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />
		</wea:item>
	</wea:group>
</wea:layout>
</form>
<script language=javascript>
  function dosubmit(){
    document.frmmain.submit();
  }
 function submitData() {
 frmmain.submit();
}
 </script>
</body>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
