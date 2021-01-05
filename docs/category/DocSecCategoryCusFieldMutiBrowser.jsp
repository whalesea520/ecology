<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<%
String check_per = Util.null2String(request.getParameter("selectids"));
String secCategoryId = Util.null2String(request.getParameter("secCategoryId"));
String scope = Util.null2String(request.getParameter("scope"));
%>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/rightspluingForBrowserNew_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/docs/multiSecCategoryCusFieldBrowser_wev8.js"></script>
<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>
<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("17037",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e);
	}
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}
	
	function htmltypeChange(obj){
	if(obj.value==1){
		jQuery("#typeDiv").html(jQuery("#ftype1").html());
		jQuery("#type").removeAttr("notBeauty");
		beautySelect("#type");
		hideGroup("selectItemArea")
		showEle("type");
	}else if(obj.value==2||obj.value==4){
		jQuery("#typeDiv").html("");
		hideEle("type");
		hideGroup("selectItemArea")
	}else if(obj.value==3){
		jQuery("#typeDiv").html(jQuery("#ftype2").html());
		showEle("type");
		jQuery("#type").removeAttr("notBeauty");
		beautySelect("#type");
		hideGroup("selectItemArea")
	}else if(obj.value==5){
		showGroup("selectItemArea")
		hideEle("type");
	}
	
}

function onClose(){
	jQuery("#btncancel").click();
}

function onReset(){
	resetCondition("#queryCondition");
}

function btnok_onclick(){
	jQuery("#okBtn").click();
}

function saveCusField(){
	var scope = "<%=scope%>";
	jQuery.ajax({
		url:"/docs/category/docajax_operation.jsp",
		dataType:"html",
		type:"post",
		beforeSend:function(){
			e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(33592,user.getLanguage())%>",true);
		},
		complete:function(){
			e8showAjaxTips("",false);
		},
		data:{
			secCategoryId:<%=secCategoryId%>,
			src:"attachSecCategory",
			scope:"<%=scope%>",
			fieldids:jQuery("#systemIds").val()
		},
		success:function(data){
			if(scope=="DocCustomFieldBySecCategory"){
				parentWin._selectids = jQuery("#systemIds").val();
			}
			parentWin._table.reLoad();
			dialog.close();
		}
	});
}

</script>
</HEAD>
<BODY>
<div class="zDialog_div_content">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" onclick="btnOnSearch()" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:btnOnSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<FORM NAME=SearchForm id="SearchForm" STYLE="margin-bottom:0" action="DocMainCategoryMutiBrowser.jsp"  onsubmit="btnOnSearch();return false;" method=post>

<%--added by XWJ on 2005-03-16 for td:1549--%>

<input type=hidden name="selectids" id="selectids" value="<%=check_per%>">
<input type=hidden name="scope" id="scope" value="<%=scope%>">
<div style="max-height:155px;overflow:hidden;" id="e8QuerySearchArea">
<wea:layout type="4col" attributes="{'formTableId':'queryCondition'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>' attributes="{'groupSHBtnDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(30828,user.getLanguage())%></wea:item>
		<wea:item><input type="text"  class=InputStyle id="fieldlabel"  name="fieldlabel"></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(23241,user.getLanguage())%></wea:item>
		<wea:item><input type="text"  class=InputStyle id="fieldname"  name="fieldname"></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(687,user.getLanguage())%></wea:item>
		<wea:item>
		<select size="1" name="fieldhtmltype" onChange = "htmltypeChange(this)">
			<option value="" ></option>
			<option value="1" ><%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%></option>
			<option value="2"><%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%></option>
			<option value="3"><%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%></option>
			<option value="4"><%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%></option>
			<option value="5"><%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%></option>
	    </select>
    </wea:item>
    <%String typeAttr = "{'samePair':'type','display':'none'}"; %>
    <wea:item attributes='<%=typeAttr %>'><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
	<wea:item attributes='<%=typeAttr %>'>
		<span id="typeDiv">
			<select size=1 name="type">
				<option value="" ></option>
				<option value="1"><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
				<option value="2"><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
				<option value="3"><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
			</select>
		</span>
	</wea:item>
	</wea:group>
</wea:layout>
</div>
<div id="dialog">
	<div id='colShow'></div>
</div>
<div style="width:0px;height:0px;overflow:hidden;">
	<button accessKey=T id=myfun1   type=button onclick="resetCondtion();"><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
	<button type=submit></BUTTON>
</div>
</FORM>
<div style="DISPLAY: none" id="ftype1">
	<select notBeauty="true" size=1 id="type" name=type onChange = "typeChange(this)" >
		<option value="" ></option>
		<option value="1"><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
		<option value="2"><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
		<option value="3"><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
	</select>
	<input name=definebroswerType type=hidden value="">
</div>

<div style="DISPLAY: none" id="ftype2">
	<select notBeauty="true" size=1 id="type" name=type onChange = "broswertypeChange(this)" >
    <option value="" ></option>
    <%while(BrowserComInfo.next()){
    		 	 if(("226".equals(BrowserComInfo.getBrowserid()))||"227".equals(BrowserComInfo.getBrowserid())||"224".equals(BrowserComInfo.getBrowserid())||"225".equals(BrowserComInfo.getBrowserid())){
	        	 //屏蔽集成浏览按钮-zzl
				continue;
			}
    %>
		<option value="<%=BrowserComInfo.getBrowserid()%>" ><%=SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(),0),7)%></option>
    <%}%>
	</select>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
			<input type="button" onclick="saveCusField();return false;" class=zd_btn_submit accessKey=O  id=okBtn value="O-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>"></input>
	        <input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"></input>
		</wea:item>
	</wea:group>
</wea:layout>
<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
<script type="text/javascript">

jQuery(document).ready(function(){
	showMultiDocDialog("<%=check_per%>");
});


</SCRIPT>
</BODY></HTML>
