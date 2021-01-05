<%@page import="weaver.general.TimeUtil"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="RecordSetS" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CptDetailColumnUtil" class="weaver.cpt.util.CptDetailColumnUtil" scope="page"/>
<%
String nameQuery = Util.null2String(request.getParameter("nameQuery"));
if(!HrmUserVarify.checkUserRight("CptCapital:Return", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
String capitalid = Util.null2String(request.getParameter("capitalid"));
String sptcount="";
String sql="";
if (!capitalid.equals("")){
	sql="select sptcount from CptCapital where id="+ capitalid;
	RecordSetS.executeSql(sql);
	RecordSetS.next(); 
	sptcount = RecordSetS.getString("sptcount");
}
String currentdate = TimeUtil.getCurrentDateString();
%>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
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
<script type="text/javascript">
var parentWin;
if("<%=isDialog %>"=="1"){
	parentWin = parent.parent.getParentWindow(parent.window);
	var parentDialog = parent.parent.getDialog(parent);
}
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(535,user.getLanguage())+SystemEnv.getHtmlLabelName(1384,user.getLanguage());
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

var items=<%=CptDetailColumnUtil.getDetailColumnConf("CptBack", user) %>;
var option= {navcolor:"#00cc00",basictitle:"<%=SystemEnv.getHtmlLabelNames("83565",user.getLanguage())%>",toolbarshow:true,openindex:true,colItems:items,toolbarshow:false,optionHeadDisplay:"none"};
var group1=new WeaverEditTable(option);
$(".subgroupmain").append(group1.getContainer());
</script>
<input type="hidden" name="dtinfo" id="dtinfo" value=""/>
 </form>
 
 <script type="text/javascript">
function disModalDialog(url, spanobj, inputobj, need, curl) {

	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			} else {
				spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			}
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}



function onShowUseRequest() {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp?isrequest=1"
			, $GetEle("userequestspan")
			, $GetEle("userequest")
			, false);
}

function onShowCapitalid() {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata='2'&cptstateid=2,3,4"
			, $GetEle("capitalidspan")
			, $GetEle("capitalid")
			, true);
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
		var dtmustidx=[3];
		var jsonstr= JSON.stringify(dtjson);
		//console.log("dtinfo:"+jsonstr);
		if(checkdtismust(dtjson,dtmustidx)==false){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage()) %>");
			displayAllmenu();
			return;
		}
		var result = checkdtifover(dtjson,3,-1,function(){
			if(check_form(document.weaver,'backdate')) {
				document.weaver.dtinfo.value=jsonstr;
				document.weaver.action="CptCapitalBackOperation.jsp";
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

 </script>
 <script language="javascript">
 function back()
{
	window.history.back(-1);
}

function loadinfo(event,data,name){
	try{
		if(name){
			var cptid=$('#'+name).val();
			if(cptid!=""){
				CptDwrUtil.getCptInfoMap(cptid,function(data){
					$('#'+name).parents('td').first().next('td').find('span[id=curdept_span]').html(data.blongdepartmentname)
					.end().next('td').find('span[id=capitalspec_span]').html(data.capitalspec)
					.end().next('td').find('span[id=status_span]').html(data.statename)
					.end().next('td').find('span[id=curresource_span]').html(data.resourcename)
					;
			   	});
			}else{
				$('#'+name).parents('td').first().next('td').find('span[id=curdept_span]').html('')
				.end().next('td').find('span[id=capitalspec_span]').html('')
				.end().next('td').find('span[id=status_span]').html('')
				.end().next('td').find('span[id=curresource_span]').html('')
				;
			}
		}
	}catch(e){}
}
$(function(){
	setTimeout(" group1.addRow();",100);
});
</script>

<%
if("1".equals(isDialog)){
	%>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentDialog.closeByHand();"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout>
</div>	
	
	<%
}
%>

</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
