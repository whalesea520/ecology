
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.Prop,
				weaver.general.GCONST" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<%
String selectids=Util.null2String(request.getParameter("selectids"));
String tabId=Util.null2String(request.getParameter("tabId"));
%>
<HTML><HEAD>
	<link REL="stylesheet" type="text/css" href="/css/Weaver_wev8.css" />
	<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
	<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
	<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
	<script type="text/javascript" src="/js/dragBox/rightspluingForBrowser_wev8.js"></script>
</HEAD>
<BODY>


<div class="zDialog_div_content">
	<FORM id="SearchForm" NAME="SearchForm" STYLE="margin-bottom:0" action="" onsubmit="return false;" method=post>
		<input type="hidden" name="pagenum" value=''>
		<input type="hidden" name="selectids" id="selectids" value='<%=selectids%>'>
		<input type="hidden" name="tabId" id="tabId">
		<input type="hidden" name="subcompanyid" id="subcompanyid">
		<input type="hidden" name="departmentid" id="departmentid">		
		<input type="hidden" name="lastname" id="lastname">
		<input type="hidden" name="jobtitle" id="jobtitle">
		<input type="hidden" name="status" id="status">
		<input type="hidden" name="roleid" id="roleid">	
		<input type="hidden" name="groupid" id="groupid">
		<div id="dialog" style="height: 250px;">
			<div id='colShow'></div>
		</div>
	</form>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context="">
		<wea:item type="toolbar">
			<input type="button" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
			<input type="button" class=zd_btn_submit accessKey=O  id=btnok value="O-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>"></input>
			<input type="button" class=zd_btn_submit accessKey=2  id=btnclear value="2-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>"></input>
			<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"></input>
		</wea:item>
	</wea:group>
</wea:layout>
</div>
			

<script type="text/javascript">
	jQuery(document).ready(function(){
		resizeDialog(document);
	});
 
var parentWin = null;
var dialog = null;
try{
	dialog = parent.parent.parent.getDialog(parent.parent);
}catch(ex1){}

jQuery(document).ready(function(){
	showMultiDocDialog("<%=selectids%>");
	if("<%=tabId%>"=="3"){
		$("#btnsearch").show();
		if($("#btnsearch").next().attr("class")=="e8_sep_line"){
			$("#btnsearch").next().show();
		}
	}else{
		$("#btnsearch").hide();
		if($("#btnsearch").next().attr("class")=="e8_sep_line"){
			$("#btnsearch").next().hide();
		}
	}
});
var config = null;
function showMultiDocDialog(selectids){
	
	config= rightsplugingForBrowser.createConfig();
    config.srchead=["<%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(422,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>"];
    config.container =$("#colShow");
    config.searchLabel="";
    config.hiddenfield="id";
    config.saveLazy = true;//取消实时保存
    config.srcurl = "MutiResourceBrowserAjax.jsp?src=src";
    config.desturl = "MutiResourceBrowserAjax.jsp?src=dest";
    config.pagesize = 10;
    config.formId = "SearchForm";
    config.selectids = selectids;
   	config.okCallbackFn=okCallbackFn;
	try{
		config.dialog = dialog;
	}catch(e){
		alert(e)
	}
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
    	parent.frame1.btnsub_onclick();
    });
}

function okCallbackFn(config,destMap,json,destMapKeys){
	 var ids="";
	 var names="";
	 var mobiles="";
	 for(var i=0;destMapKeys&&i<destMapKeys.length;i++){
		var key = destMapKeys[i];
		var dataitem = destMap[key];
		var name = dataitem.lastname;
		var mobile=dataitem.mobile;
		if(mobile!=""){
     		if(names==""){
     			ids=key;
     			names = name;
     			mobiles=mobile;
     		}else{
     			ids=ids+","+key;
     			names=names + ","+name;
     			mobiles=mobiles + ","+mobile;
     		}
   		}
	}
	try{
		if(config.dialog){
			config.dialog.callback({id:ids,name:names,mobile:mobiles});
		}else{
			window.parent.returnValue = {id:ids,name:names,mobile:mobiles};
			window.parent.close();
		}
	}catch(e){
		window.parent.returnValue = {id:ids,name:names,mobile:mobiles};
		window.parent.close();
	}
}

function btnOnSearch(){
	rightsplugingForBrowser.system_btnsearch_onclick(config);
}

function setSearchCondition1(companyid,subcompanyid,departmentid){
	$('#tabId').val(1);
	$('#subcompanyid').val(subcompanyid);
	$('#departmentid').val(departmentid);
	btnOnSearch();
}

function setSearchCondition2(groupid){
	$('#tabId').val(2);
	$('#groupid').val(groupid);
	btnOnSearch();
}

function setSearchCondition3(lastname,jobtitle,status,subcompanyid,departmentid,roleid){
	$('#tabId').val(3);
	$('#lastname').val(lastname);
	$("#jobtitle").val(jobtitle);
	$("#status").val(status);
	$('#subcompanyid').val(subcompanyid);
	$('#departmentid').val(departmentid);
	$('#roleid').val(roleid);
	btnOnSearch();
}

function resetCondition(tabId,isSearch){
	$('#tabId').val(tabId);
	$('#subcompanyid').val("");
	$('#departmentid').val("");
	$('#groupid').val("");
	$('#lastname').val("");
	$("#jobtitle").val("");
	$("#status").val("");
	$('#subcompanyid').val("");
	$('#departmentid').val("");
	$('#roleid').val("");
	$('#groupid').val("");
	if(isSearch) btnOnSearch();
	
}


</script>


</BODY>
</HTML>
