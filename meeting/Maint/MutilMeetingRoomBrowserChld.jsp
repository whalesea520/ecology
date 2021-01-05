<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
String tabid = Util.null2String(request.getParameter("tabid"),"0");
String callbkfun = Util.null2String(request.getParameter("callbkfun"));
int from = Util.getIntValue(request.getParameter("from"), -1);
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String selectedids = Util.null2String(request.getParameter("selectedids"));
String name = Util.null2String(request.getParameter("name"));
String desc = Util.null2String(request.getParameter("desc"));

%>

<HTML><HEAD>
	<link REL="stylesheet" type="text/css" href="/css/Weaver_wev8.css" />
	<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
	<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
	<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
	<script type="text/javascript" src="/js/dragBox/rightspluingForBrowser_wev8.js"></script>
	<script type="text/javascript">
		var parentWin = null;
		var dialog = null;
		try{
			parentWin = parent.parent.parent.getParentWindow(parent.parent);
			dialog = parent.parent.parent.getDialog(parent.parent);
		}
		catch(e){}
		function showMultiDocDialog(selectids){
			var config = null;
			config= rightsplugingForBrowser.createConfig();
			config.srchead=["<%=SystemEnv.getHtmlLabelName(399,user.getLanguage()) %>","<%=SystemEnv.getHtmlLabelName(15767,user.getLanguage()) %>","<%=SystemEnv.getHtmlLabelName(124,user.getLanguage()) %>"];
			config.container =$("#colShow");
			config.searchLabel="";
			config.hiddenfield="id";
			config.saveLazy = true;//取消实时保存
			config.srcurl = "/meeting/Maint/MutilMeetingRoomBrowserAjax.jsp?src=src";
		  	config.desturl = "/meeting/Maint/MutilMeetingRoomBrowserAjax.jsp?src=dest&systemIds="+$("#systemIds").val();
		  	config.pagesize = 20;
		  	config.formId = "SearchForm";
		  	config.target = "frame1";
		  	config.searchAreaId="e8QuerySearchArea";
		  	config.parentWin = window.parent.parent;
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
		    	$("#multiArrowFrom").click();
		    });
		    jQuery("#btncancel").bind("click",function(){
		    	rightsplugingForBrowser.system_btncancel_onclick(config);
		    });
		}
		
	</script>
</HEAD>
<body scroll="no">
<div class="zDialog_div_content">
	<FORM id="SearchForm" NAME="SearchForm" STYLE="margin-bottom:0" action="" onsubmit="return false;" method=post>
		<input type="hidden" name="sqlwhere" value='<%=xssUtil.put(sqlwhere)%>'>
		<input type="hidden" name="pagenum" value=''>
		<input type="hidden" name="tabid" id="tabid" value='<%=tabid%>'>
		<input type="hidden" name="selectedids" id="selectedids" value='<%=selectedids%>'>
		<input type="hidden" name="systemIds" id="systemIds" value='<%=selectedids%>'>
		<DIV align=right style="display: none">
		<button type="button" class=btnSearch accessKey=S type=submit
			id=btnsearch onclick="javascript:showMultiDocDialog()">
			<U>S</U>-<%=SystemEnv.getHtmlLabelName(197, user.getLanguage())%></BUTTON>
		</DIV>
		<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_top"  onclick="javascript:document.SearchForm.btnsearch.click()">
			  <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<div style="overflow: auto;max-height:155px" id="e8QuerySearchArea">
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(31232, user.getLanguage())%></wea:item>
						<wea:item>
							<input type="text" class="InputStyle" id="name" name="name"
								value="<%=name%>">
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(433, user.getLanguage())%></wea:item>
						<wea:item>
							<input type="text" class="InputStyle" id="desc" name="desc"
								value="<%=desc%>">
						</wea:item>
						
		</wea:group>
	</wea:layout>
	</div>
		<div id="dialog">
			<div id='colShow'></div>
		</div>

		
	</form>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context="">
		<wea:item type="toolbar">
			<input type="button" class=zd_btn_submit accessKey=O  id=btnok onclick="SumitData()" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>"></input>
			<input type="button" class=zd_btn_submit accessKey=2  id=btnclear value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>"></input>
			<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"></input>
		</wea:item>
	</wea:group>
</wea:layout>
<script type="text/javascript">
	jQuery(document).ready(function(){
		resizeDialog(document);
	});
	
	function onSearch(){
		jQuery("#btnsearch").click();
	}
	
</script>
</div>

</body>
<SCRIPT language="javascript">
var dialog = null;
try{
	dialog = parent.parent.parent.getDialog(parent.parent);
}catch(ex1){}



function SumitData(){
	var roomids=$("#systemIds").val();
	var roomnames="";
	if(roomids!=""){
		var tmp=roomids.split(",");
		for(var i=0;i<tmp.length;i++){
			var tmpid=tmp[i];
			var name=$("#"+tmpid).parents("tr").find(".contentTitle").html();
			if(roomnames!="")roomnames+=",";
			roomnames+=name;
		}
	}
	roomnames=toHtml(roomnames);
	returnValue({id:roomids,name:roomnames});
}
//返回json格式数据
function returnValue(returnjson){
	if(1 == <%=from%>){
		<%if(!"".equals(callbkfun)){%>
			<%="parentWin." + callbkfun + "(returnjson);"%>
		<%}%>
	} else {
		if(dialog){
			try{
				  dialog.callback(returnjson);
			 }catch(e){}

			try{
				 dialog.close(returnjson);
			 }catch(e){}

		}else{ 
			window.parent.parent.returnValue  = returnjson;
			window.parent.parent.close();
		}
	}
	parentWin.closeBrwDlg();
}
function toHtml(s){ 
    var i = 0;
    var buf="";
    var ch="";
    while(i<s.length){
    	ch=s[i];
    	if (ch == '\'')
                buf+=("\''");
            else if (ch == '<')
                buf+=("&lt;");
            else if (ch == '>')
                buf+=("&gt;");
            else if (ch == '"')
                buf+=("&quot;");
            else if (ch == '\n')
                buf+=("<br>");
            else
            	buf+=(ch);
    	i++;
    }
    return buf;
}
jQuery(document).ready(function(){
	showMultiDocDialog("<%=selectedids%>");
	
});
</script>
</html>