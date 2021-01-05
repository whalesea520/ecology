<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/rightspluingForBrowserNew_wev8.js"></script>

<%
String resourceids=Util.null2String(request.getParameter("resourceids"));
%>
</HEAD>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:btnOnSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(2022,user.getLanguage())+",javascript:resetC(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="meeting"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(2157,user.getLanguage())%>"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	   <td>
	    </td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>" class="e8_btn_top middle" onclick="btnOnSearch();"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
	<span id="hoverBtnSpan" class="hoverBtnSpan">
			<span><%=SystemEnv.getHtmlLabelName(780,user.getLanguage()) %></span>
	</span>
</div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
</div>
<div class="zDialog_div_content">
<FORM NAME="SearchForm" id="SearchForm" >
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331, user.getLanguage())%>' attributes="{'groupSHBtnDisplay':'none'}">
			<!-- 名称 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(1353,user.getLanguage())%></wea:item>
			<wea:item>
              <input class=inputstyle type="text" id="itemname" name="itemname"  style="width:60%" >
			</wea:item>
			<!-- 描述 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
            <wea:item>
            	<brow:browser viewType="0" name="type" browserValue="" 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/meeting/Maint/MeetingServiceTypeBrowser.jsp" 
							hasInput="false"  isSingle="true" hasBrowser = "true" isMustInput='1' 
							completeUrl="" linkUrl="" 
							browserSpanValue=""></brow:browser>
            </wea:item>
    </wea:group>
     
	<wea:group context='<%=SystemEnv.getHtmlLabelName(320,user.getLanguage())%>' attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true'}">
			<div id="dialog" style="height: 250px;">
				<div id='colShow'></div>
			</div>
		</wea:item>
	</wea:group>
</wea:layout>
</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button" class=zd_btn_submit accessKey=O  id=btnok value="O-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>"></input>
				<input type="button" class=zd_btn_submit accessKey=2  id=btnclear value="2-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>"></input>
				<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"></input>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
<script type="text/javascript">
jQuery(document).ready(function(){
	showMultiDocDialog("<%=resourceids%>");
	resizeDialog(document);
});
 
var parentWin = null;
var dialog = null;
try{
	dialog = parent.parent.getDialog(parent);
}catch(ex1){}

function showMultiDocDialog(selectids){
	var config = null;
	config= rightsplugingForBrowser.createConfig();
    config.srchead=["<%=SystemEnv.getHtmlLabelName(2157,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(2155,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>"];
    config.container =$("#colShow");
    config.searchLabel="";
    config.hiddenfield="id";
    config.saveLazy = true;//取消实时保存
    config.srcurl = "/meeting/Maint/MeetingServiceOperation.jsp?method=src";
    config.desturl = "/meeting/Maint/MeetingServiceOperation.jsp?method=dest";
    config.pagesize = 10;
    config.formId = "SearchForm";
    config.selectids = selectids;
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
    	rightsplugingForBrowser.system_btnsearch_onclick(config);
    });
}

function btnOnSearch(){
	jQuery("#btnsearch").trigger("click");
}

function btnOnSearch(){
 jQuery("#btnsearch").trigger("click");
}


var btnok_onclick = function(){
	jQuery("#btnok").click();
}

var btnclear_onclick = function(){
	jQuery("#btnclear").click();
}

function onClose(){
	 if(dialog){
    	dialog.close()
    }else{
	    window.parent.close();
	}
}

function resetC(){
	$('#itemname').val("");
	$('#type').val("");
	$('#typespan').html("");
} 
</script>
<SCRIPT language="javascript" defer="defer" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
