<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetS" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CptDetailColumnUtil" class="weaver.cpt.util.CptDetailColumnUtil" scope="page"/>

<%
String nameQuery = Util.null2String(request.getParameter("nameQuery"));
String rightStr = "";
if(!HrmUserVarify.checkUserRight("CptCapital:Use", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}else{
	rightStr = "CptCapital:Use";
	session.setAttribute("cptuser",rightStr);
}
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String capitalid = Util.null2String(request.getParameter("capitalid"));
String sptcount="";
String sql="";
String hrmid=Util.null2String(request.getParameter("hrmid"));

if (!capitalid.equals("")){
	sql="select sptcount from CptCapital where id="+ capitalid;
	RecordSetS.executeSql(sql);
	RecordSetS.next(); 
	sptcount = RecordSetS.getString("sptcount");
}

int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/cpt/js/validate_wev8.js"></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/interface/CptDwrUtil.js'></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>

</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(886,user.getLanguage());
String needfav ="1";
String needhelp ="";
String needcheck="";
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSubmit(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=frmain name=frmain method=post action="/cpt/capital/CapitalUseOperation.jsp"    >
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) %>" class="e8_btn_top" onclick="group1.addRow()"/>
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
 
 	 var items=<%=CptDetailColumnUtil.getDetailColumnConf("CptUse", user) %>;
     var option= {navcolor:"#00cc00",basictitle:"<%=SystemEnv.getHtmlLabelNames("83620",user.getLanguage())%>",toolbarshow:true,openindex:true,colItems:items,toolbarshow:false,optionHeadDisplay:"none"};
     var group1=new WeaverEditTable(option);
     $(".subgroupmain").append(group1.getContainer());
 </script>

<input type="hidden" name="dtinfo" id="dtinfo" value=""/>
    
</form>
<script type="text/javascript">

function onShowCapitalid(rownum) {
	// 只显示状态为库存的资产cptstateid=1
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata='2'&cptstateid=1&cptuse=1",
					"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != ""
				&& wuiUtil.getJsonValueByIndex(id, 0) != "0") {
			$GetEle("node_" + rownum + "_cptspan").innerHTML = "<a href='/cpt/capital/CptCapital.jsp?id="
					+ wuiUtil.getJsonValueByIndex(id, 0)
					+ "'>"
					+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			$GetEle("node_" + rownum + "_capitalid").value = wuiUtil
					.getJsonValueByIndex(id, 0);
			$GetEle("node_" + rownum + "_sptcount").value = wuiUtil
					.getJsonValueByIndex(id, 12);
			$GetEle("node_" + rownum + "_capitalspec").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 9);
			$GetEle("node_" + rownum + "_capitalnumspan").innerHTML = "";
			$GetEle("node_" + rownum + "_capitalnum").value = "1";
			$GetEle("node_" + rownum + "_capitalcountspan").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 7);
			$GetEle("node_" + rownum + "_capitalcount").value = wuiUtil
					.getJsonValueByIndex(id, 7);
			$GetEle("node_" + rownum + "_unitspan").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 11);
			$GetEle("node_" + rownum + "_codespan").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 8);
			$GetEle("node_" + rownum + "_ficodespan").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 5);
			$GetEle("node_" + rownum + "_location").value = wuiUtil
					.getJsonValueByIndex(id, 10);
		} else {
			$GetEle("node_" + rownum + "_cptspan").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
			$GetEle("node_" + rownum + "_capitalid").value = "";
			$GetEle("node_" + rownum + "_sptcount").value = "";
			$GetEle("node_" + rownum + "_capitalspec").innerHTML = "";
			$GetEle("node_" + rownum + "_capitalnumspan").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
			$GetEle("node_" + rownum + "_capitalnum").value = "";
			$GetEle("node_" + rownum + "_capitalcountspan").innerHTML = "";
			$GetEle("node_" + rownum + "_capitalcount").value = 0;
			$GetEle("node_" + rownum + "_unitspan").innerHTML = "";
			$GetEle("node_" + rownum + "_codespan").innerHTML = "";
			$GetEle("node_" + rownum + "_ficodespan").innerHTML = "";
			$GetEle("node_" + rownum + "_location").value = "";
		}
	}
}

</script>

<script language="javascript">
var rowindex = 0;
var totalrows=0;
var needcheck = "<%=needcheck%>";
var rowColor="" ;
var currentdate = "<%=currentdate%>";


function onSubmit()
{
	var dtinfo= group1.getTableSeriaData();	
	var dtjson= group1.getTableJson();
	enableAllmenu();
   	if(dtinfo){
   		//dtjson[0].unshift("{'test':'null'}");
   		//dtjson[0].unshift("{'test':'null'}");
   		var jsonstr= JSON.stringify(dtjson);
   		//console.log("dtinfo:"+jsonstr);
   		var dtmustidx=[2,6,7];
   		if(checkdtismust(dtjson,dtmustidx)==false){//明细必填验证
   			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage()) %>");
   			displayAllmenu();
   			return;
   		}
   		var result = checkdtifover(dtjson,6,2,function(){
			if(check_form(document.frmain,needcheck)) {
				document.frmain.dtinfo.value=jsonstr;
				document.frmain.action="CapitalUseOperation.jsp";
				document.frmain.submit();
				//obj.disabled=true;
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

function back(){
    window.history.back(-1);
}

function loadinfo(event,data,name){
	if(name){
		var cptid=$('#'+name).val();
		if(cptid!=''){
			CptDwrUtil.getCptInfoMap(cptid,function(data){
				$('#'+name).parents('td').first().next('td').next('td').find('span[id=capitalspec_span]').html(data.capitalspec)
				.end().next('td').find('span[id=code_span]').html(data.mark)
				.end().next('td').find('span[id=capitalcount_span]').html(data.availablenum)
				;
		   	});
		}else{
			$('#'+name).parents('td').first().next('td').next('td').find('span[id=capitalspec_span]').html('')
			.end().next('td').find('span[id=code_span]').html('')
			.end().next('td').find('span[id=capitalcount_span]').html('')
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

