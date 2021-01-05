
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.PageManagerUtil " %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="recordSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="recordSet3" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav = "1";
String needhelp = "";

int from = Util.getIntValue(request.getParameter("from"), -1);
String callbkfun = Util.null2String(request.getParameter("callbkfun"));

int tabId = Util.getIntValue(request.getParameter("tabId"), 3);
String optFrame3 = "/fna/browser/dataSet/dataSetMultiQuery.jsp";
String optFrame = "";
String type = "";
if(tabId==3){
	type = "query";
	optFrame = optFrame3;
}

String selectids = Util.null2String(request.getParameter("selectids"));

%>
<HTML><HEAD>
	<link REL="stylesheet" type="text/css" href="/css/Weaver_wev8.css" />
	<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
	<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
	<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>
	<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
	<script type="text/javascript" src="/js/dragBox/rightspluingForBrowser_wev8.js"></script>
</head>
<body scroll="no">
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage())+",javascript:btnsearchClick(),_self} ";
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{" + SystemEnv.getHtmlLabelName(826, user.getLanguage())+",javascript:btnokClick(),_self} ";
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{" + SystemEnv.getHtmlLabelName(311, user.getLanguage())+",javascript:btnclearClick(),_self} ";
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{" + SystemEnv.getHtmlLabelName(201, user.getLanguage())+",javascript:btncancelClick(),_self} ";
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr><td>&nbsp;</td>
		<td class="rightSearchSpan" style="text-align: right;">
    		<input class="e8_btn_top" type="button" id="btnQry" onclick="btnsearchClick();" 
    			value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<script type="text/javascript">
function btnsearchClick(){
	jQuery("#btnsearch").click();
}
function btnokClick(){
	jQuery("#btnok").click();
}
function btnclearClick(){
	jQuery("#btnclear").click();
}
function btncancelClick(){
	jQuery("#btncancel").click();
}
</script>

<div class="zDialog_div_content">
	<FORM id="weaver" NAME="SearchForm" STYLE="margin-bottom:0" action="" onsubmit="return false;" method=post>
		<input type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
		<input type="hidden" name="pagenum" value=''>
		<input type="hidden" name="from" id="from" value='<%=from%>'>
		<input type="hidden" name="callbkfun" id="callbkfun" value='<%=callbkfun%>'>
		<input type="hidden" name="type" id="type" value="<%=type %>" />
		
		<input type="hidden" name="changeQueryType" id="changeQueryType" value="" />
		<input type="hidden" name="name" id="name" value="" />
		
		<IFRAME name=optFrame id=optFrame src="<%=optFrame %>" width="100%" height="180px" frameborder=no scrolling=yes>
		//浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
		<div id="dialog" style="height: 250px;">
			<div id='colShow'></div>
		</div>
	</form>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	    <wea:group context="">
	    	<wea:item type="toolbar">
				<input type="button" class="zd_btn_submit" id=btnok value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" />
				<input type="button" class="zd_btn_submit" id=btnclear value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" />
		        <input type="button" class="zd_btn_submit" id=btncancel value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" />
	    	</wea:item>
	    </wea:group>
</wea:layout>
</div>
<input type="button" style="display: none;" class="e8_btn_top" id=btnsearch value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" />
<input type="button" style="display: none;" class="e8_btn_top" id=btnclear2 value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" />
<input type="button" style="display: none;" class="e8_btn_top" id=btncancel2 value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" />

</body>
<SCRIPT language="javascript">
var parentWin = null;
var dialog = null;
try{
	dialog = parent.parent.parent.getDialog(parent.parent);
}catch(ex1){}

function quickQry(qname){
	//alert("quickQry qname="+qname);
}

jQuery(document).ready(function(){
	resizeDialog(document);
	showMultiDialog("<%=selectids %>");
});

function changeQueryType(tabId){
	jQuery("#name").val("");
	
	if(tabId==3){
		jQuery("#type").val("query");
		document.getElementById("optFrame").src = "<%=optFrame3 %>";
	}
}

function showMultiDialog(selectids){
	var config = null;
	config= rightsplugingForBrowser.createConfig();
	config.srchead=["<%=SystemEnv.getHtmlLabelName(33162,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(33163,user.getLanguage())%>"];//方案名称 方案编码
	config.container =jQuery("#colShow");
    config.searchLabel="";
    config.hiddenfield="id";
    config.saveLazy = true;
    config.srcurl = "/fna/browser/dataSet/dataSetMultiAjax.jsp?src=src";
    config.desturl = "/fna/browser/dataSet/dataSetMultiAjax.jsp?src=dest";
    config.pagesize = 10;
    config.formId = "weaver";
	try{
		config.dialog = dialog;
	}catch(e){
	
	}
    config.selectids = selectids;
    jQuery("#colShow").html("");
    rightsplugingForBrowser.createRightsPluing(config);
    
    jQuery("#btnok").bind("click",function(){
    	rightsplugingForBrowser.system_btnok_onclick(config);
    });
    jQuery("#btnclear").bind("click",function(){
    	rightsplugingForBrowser.system_btnclear_onclick(config);
    });
    jQuery("#btncancel").bind("click",function(){
    	rightsplugingForBrowser.system_btncancel_onclick(config);
    });
    jQuery("#btnsearch").bind("click",function(){
    	initQuery();
		rightsplugingForBrowser.system_btnsearch_onclick(config);
    });

    jQuery("#btnclear2").bind("click",function(){
    	rightsplugingForBrowser.system_btnclear_onclick(config);
    });
    jQuery("#btncancel2").bind("click",function(){
    	rightsplugingForBrowser.system_btncancel_onclick(config);
    });
}

function initQuery(){
	var type = jQuery("#type").val();
	
	var name = optFrame.jQuery("#name").val();
	
	jQuery("#name").val(name);
}

function btnOnSearch(){
	jQuery("#btnsearch").trigger("click");
}

function submitOk(){
	var dest = jQuery("#colShow").find("table.e8_box_target tbody tr");
	var ids = jQuery("#colShow").find("#systemIds").val();
	var names = "";
	if(!!ids){
		dest.each(function(){
			var name = jQuery(this).children("td").eq(1).text();
			if(names==""){
				names = name;
			}else{
				names=names + ","+name;
			}
		});
	}
	var returnjson = {"id":ids,"name":names};
	returnValue(returnjson);
}

function submitClear(){
	var returnjson = {id:"",name:""};
	returnValue(returnjson);
}

function returnValue(returnjson){
	if(dialog){
		try{
			dialog.callback(returnjson);
		}catch(e){}
		try{
			dialog.close(returnjson);
		}catch(e){}
	}else{ 
		window.parent.parent.returnValue = returnjson;
		window.parent.parent.close();
	}
}

</script>
</html>