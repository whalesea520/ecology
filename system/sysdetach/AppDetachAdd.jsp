<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("AppDetach:All", user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/ecology8/hrm/e8Common_wev8.js"></script>
	</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelNames("33062,24327", user.getLanguage());
String needfav = "1";
String needhelp = "";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())+",javascript:onAdd(2),_self} ";
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{" + SystemEnv.getHtmlLabelName(32159, user.getLanguage())+",javascript:onAdd(1),_self} ";
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="resource"/>
   <jsp:param name="navName" value="<%=titlename %>"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr><td>&nbsp;</td>
		<td class="rightSearchSpan" style="text-align: right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="onAdd(2);">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159, user.getLanguage()) %>" id="zd_btn_submit_0" class="e8_btn_top" onclick="onAdd(1);">
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<wea:layout type="2Col" >
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></wea:item><!-- 名称 -->
		<wea:item>
			<wea:required id="namespan" required="true">
				<input class="inputstyle" id="name" name="name" maxlength="25" value="" style="width: 120px;" onblur="checkinput('name','namespan');" />
			</wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(433, user.getLanguage())%></wea:item><!-- 描述 -->
		<wea:item>
			<input class="inputstyle" id="description" name="description" maxlength="100" value="" style="width: 90%;" />
		</wea:item>
	</wea:group>
</wea:layout>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
		    <wea:group context="">
		    	<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage()) %>" id="zd_btn_cancle" class="zd_btn_cancle" onclick="onCancel();">
		    	</wea:item>
		    </wea:group>
		</wea:layout>
</div>
<script type="text/javascript">
resizeDialog(document);
//页面初始化事件
checkinput("name","namespan");
	
function checkvalue() {
	var name=jQuery("#name").val();
	if(name==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30933, user.getLanguage())%>");//必填信息不完整!
		return false ;
	}
	return true ;
}
//type:1.人员 2. 分部 3.部门 4.角色
//sourcetype:
function onAdd(_type){
	if(checkvalue()){
		var name=jQuery("#name").val();
		var description=jQuery("#description").val();
		jQuery.ajax({
			url : "/system/sysdetach/AppDetachOperation.jsp",
			type : "post",
			async : true,
			processData : false,
			data : "operation=add&name="+encodeURI(name)+"&description="+encodeURI(description),
			dataType : "json",
			success: function do4Success(msg){
				if(msg.__result__ && msg.__result__ == "false"){
					top.Dialog.alert(msg.__msg__);
					return;
				}
				if(msg.flag){
					var parentWin = parent.getParentWindow(window);
					var dialog = parent.getDialog(parentWin);
					if(_type == 1){
						parentWin.doEdit(msg.id, null, null, 1, parentWin);
					}else{
						parentWin.onBtnSearchClick();
						onCancel2();
					}
				}else{
					top.Dialog.alert(msg.msg);
				}
			}
		});
	}
}

function onCancel(){
	var dialog = parent.getDialog(window);	
	dialog.closeByHand();
}

function onCancel2(){
	var dialog = parent.getDialog(window);	
	dialog.close();
}

//关闭
function doClose(){
	var parentWin = parent.getParentWindow(window);
	parentWin.closeDialog();
}
</script>
	</BODY>
</HTML>
