<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("AppDetach:All", user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(33071,user.getLanguage());
String needfav ="1";
String needhelp ="";


Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
		Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
		Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);

String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
		Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
		Util.add0(today.get(Calendar.SECOND), 2);

String currentYear = Util.add0(today.get(Calendar.YEAR), 4);

String sql = "";


String id = Util.null2String(request.getParameter("id")).trim();
String name = "";
String description = "";

sql = "select * from SysDetachInfo a where a.id = "+id;
rs.executeSql(sql);
while(rs.next()){
	name = Util.null2String(rs.getString("name")).trim();
	description = Util.null2String(rs.getString("description")).trim();
}

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script language="javascript" src="/js/ecology8/hrm/e8Common_wev8.js?r=1"></script>
</head>
<BODY style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())
			+ ",javascript:doSave(false),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
    		<input class="e8_btn_top" type="button" id="btnSave" onclick="doSave(false);" 
    			value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"/><!-- 保存 -->
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>


<input id="id" name="id" value="<%=id %>" type="hidden" />
<div class="zDialog_div_content">
	<wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></wea:item><!-- 名称 -->
			<wea:item>
				<wea:required id="namespan" required="true">
					<input class="inputstyle" id="name" name="name" maxlength="25" value="<%=name %>" style="width: 120px;" onblur="checkinput('name','namespan');" />
				</wea:required>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(433, user.getLanguage())%></wea:item><!-- 描述 -->
			<wea:item>
				<input class="inputstyle" id="description" name="description" maxlength="100" value="<%=description %>" style="width: 90%;" />
			</wea:item>
		</wea:group>
</wea:layout>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="submit" id="btnClose" onclick="onCancel();" 
    			value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/><!-- 取消 -->
    	</wea:item>
    </wea:group>
</wea:layout>
</div>
<script language=javascript>

jQuery(document).ready(function(){
	resizeDialog(document);
});
checkinput("name","namespan");

function workflowid_callback(){
	
}

//快速（高级）搜索事件
function onBtnSearchClick(from_advSubmit){
	document.frmMain.action="/system/sysdetach/AppDetachEditBase.jsp";
	document.frmMain.submit();
}

//关闭
function doClose(){
	var parentWin = parent.parent.getParentWindow(parent.window);
	parentWin.closeDialog();
}

//保存
function doSave(_openEditPage){
	var id = null2String(jQuery("#id").val());
	var name = null2String(jQuery("#name").val());
	var description = null2String(jQuery("#description").val());
	
	if(name==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage()) %>");//必填信息不完整
		return;
	}
	
	try{
		var _data = "operation=editBase&id="+id+"&name="+encodeURI(name)+"&description="+encodeURI(description);
		jQuery.ajax({
			url : "/system/sysdetach/AppDetachOperation.jsp",
			type : "post",
			async : true,
			cache : false,
			processData : false,
			data : _data,
			dataType : "json",
			success: function do4Success(_json){
			    try{
			    	if(_json.__result__ && _json.__result__ == "false"){
						top.Dialog.alert(_json.__msg__);
						return;
					}
					if(_json.flag){
						var parentWin = parent.parent.getParentWindow(parent.window);
						var dialog = parent.parent.getDialog(parentWin);
						if(_openEditPage){
							parentWin.openEditPage(_json.id, null, null, 2, parentWin);
						}else{
							parentWin.onBtnSearchClick();
							onCancel();
						}
					}else{
						top.Dialog.alert(_json.msg);
					}
			    }catch(e1){
			    }
			}
		});	
	}catch(e1){
	}
}

function onCancel(){
	var dialog = parent.parent.getDialog(parent.window);	
	dialog.closeByHand();
}


</script>
</BODY>
</HTML>
