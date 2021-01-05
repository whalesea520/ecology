<%@page import="weaver.general.TimeUtil"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CptDetailColumnUtil" class="weaver.cpt.util.CptDetailColumnUtil" scope="page"/>
<%
String nameQuery = Util.null2String(request.getParameter("nameQuery"));
String rightStr = "";
if(!HrmUserVarify.checkUserRight("CptCapital:Lend", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}else{
		rightStr = "CptCapital:Lend";
		session.setAttribute("cptuser",rightStr);
	}
//String capitalid = request.getParameter("capitalid");
String currentdate = TimeUtil.getCurrentDateString();
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>

<SCRIPT language="javascript" src="/cpt/js/validate_wev8.js"></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/interface/CptDwrUtil.js'></script>
</head>
<%
// added by lupeng 2004-07-26 for TD577.
int msgid = Util.getIntValue(request.getParameter("msgid"), 0);
String borrowedCptId = "";
rs.executeSql("SELECT cptId FROM CptBorrowBuffer");
while (rs.next())
    borrowedCptId += Util.null2String(rs.getString(1)) + ",";
// end.

String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6051,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelNames("611",user.getLanguage())+",javascript:group1.addRow(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelNames("91",user.getLanguage())+",javascript:group1.deleteRows(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelNames("77",user.getLanguage())+",javascript:group1.copyRows(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=weaver name=weaver method=post >

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) %>" class="e8_btn_top"  onclick="group1.addRow()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>" class="e8_btn_top"  onclick="group1.deleteRows()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(77,user.getLanguage()) %>" class="e8_btn_top"  onclick="group1.copyRows()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="e8_btn_top"  onclick="onSubmit(this)"/>
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>		
<div class="advancedSearchDiv" id="advancedSearchDiv">
</div>

 
<div class="subgroupmain" style="width: 100%;margin-left:0px;"></div>
<script>

  var items=<%=CptDetailColumnUtil.getDetailColumnConf("CptLend", user) %>;
   var option= {navcolor:"#00cc00",basictitle:"<%=SystemEnv.getHtmlLabelNames("83592",user.getLanguage())%>",toolbarshow:true,openindex:true,colItems:items,toolbarshow:false,optionHeadDisplay:"none"};
   var group1=new WeaverEditTable(option);
   $(".subgroupmain").append(group1.getContainer());
</script>
<input type="hidden" name="dtinfo" id="dtinfo" value=""/>
 </form>
 
 <script type="text/javascript">
 function onShowCrmID() {
		var id = window.showModalDialog(
						"/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
						, ""
						, "dialogWidth:550px;dialogHeight:550px;");
		if (id != null) {
			if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
				$GetEle("crmidspan").innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
				$GetEle("crmid").value = wuiUtil.getJsonValueByIndex(id, 0);
			} else {
				$GetEle("crmidspan").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
				$GetEle("crmid").value = "";
			}
		}
	}


	function onShowUseRequest() {
		var id = window.showModalDialog(
						"/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp?isrequest=1"
						, ""
						, "dialogWidth:550px;dialogHeight:550px;");
		if (id != null) {
			if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
				$GetEle("userequestspan").innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
				$GetEle("userequest").value = wuiUtil.getJsonValueByIndex(id, 0);
			} else {
				$GetEle("userequestspan").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
				$GetEle("userequest").value = "";
			}
		}
	}

	function onShowCapitalid() {
		var id = window.showModalDialog(
						"/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata='2'&cptstateid=1&cptsptcount=1"
						, ""
						, "dialogWidth:550px;dialogHeight:550px;");
		if (id != null) {
			if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
				$GetEle("capitalidspan").innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
				$GetEle("capitalid").value = wuiUtil.getJsonValueByIndex(id, 0);
			} else {
				$GetEle("capitalidspan").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
				$GetEle("capitalid").value = "";
			}
		}
	}

	function onShowResource() {
		var id = window.showModalDialog(
						"/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
						, ""
						, "dialogWidth:550px;dialogHeight:550px;");
		if (id != null) {
			if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
				$GetEle("viewerspan").innerHTML = "<A href='/hrm/resource/HrmResource.jsp?id=" + wuiUtil.getJsonValueByIndex(id, 0) + "'>" + wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
				$GetEle("hrmid").value = wuiUtil.getJsonValueByIndex(id, 0);
			} else {
				$GetEle("viewerspan").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
				$GetEle("hrmid").value = "";
			}
		}
	}


	function ShowDeparment() {
		var id = window.showModalDialog(
						"/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids=" + $GetEle("departmentid").value
						, ""
						, "dialogWidth:550px;dialogHeight:550px;");
		if (id != null) {
			if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
				$GetEle("FromDeparment").innerHTML = "<A href='/hrm/company/HrmDepartmentDsp.jsp?id=" + wuiUtil.getJsonValueByIndex(id, 0) + "'>" + wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
				$GetEle("departmentid").value = wuiUtil.getJsonValueByIndex(id, 0);
			} else {
				$GetEle("FromDeparment").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
				$GetEle("departmentid").value = "";
			}
		}
	}
	 
 
 </script>
 <script language="javascript">

function onSubmit()
{
	var dtinfo= group1.getTableSeriaData();	
	var dtjson= group1.getTableJson();
	enableAllmenu();
	if(dtinfo){
		//dtjson[0].unshift("{'test':'null'}");
		var dtmustidx=[4,6];
		var jsonstr= JSON.stringify(dtjson);
		//console.log("dtinfo:"+jsonstr);
		if(checkdtismust(dtjson,dtmustidx)==false){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage()) %>");
			displayAllmenu();
			return;
		}
		var result = checkdtifover(dtjson,6,-1,function(){
			if(check_form(document.weaver,'hrmid,departmentid,lenddate')) {
				document.weaver.dtinfo.value=jsonstr;
				document.weaver.action="CapitalLendOperation.jsp";
				document.weaver.submit();
			}else{
				displayAllmenu();
			}
		});
   		if(result==false){
   			displayAllmenu();
   		}	
		
	}else{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(33027,user.getLanguage()) %>");
		displayAllmenu();
	}
}

// added by lupeng 2004-07-26 for TD577
var borrowedCptId = "<%=borrowedCptId%>";

function checkValid(cptId) {
    if (borrowedCptId.indexOf(cptId+",") != -1) {
        alert("<%=SystemEnv.getErrorMsgName(36,user.getLanguage())%>");
        return false;
    }

    return true;
}
// end.

function back()
{
	window.history.back(-1);
}
function loadinfo(event,data,name){
	if(name){
		var cptid=$('#'+name).val();
		if(cptid!=""){
			CptDwrUtil.getCptInfoMap(cptid,function(data){
				$('#'+name).parents('td').first().next('td').find('span[id=curdept_span]').html(data.blongdepartmentname)
				.end().next('td').find('span[id=curresource_span]').html(data.resourcename)
				.end().next('td').find('span[id=capitalspec_span]').html(data.capitalspec)
				;
		   	});
		}else{
			$('#'+name).parents('td').first().next('td').find('span[id=curdept_span]').html('')
			.end().next('td').find('span[id=curresource_span]').html('')
			.end().next('td').find('span[id=capitalspec_span]').html('')
			;
		}
	}
}
$(function(){
	setTimeout("group1.addRow();",100);
});
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
