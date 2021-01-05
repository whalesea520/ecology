<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("fnaControlScheme:set", user)){
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
String code = "";
int fnayearid = 0;
int fnayearidEnd = 0;
int enabled = 0;

sql = "select * from fnaControlScheme a where a.id = "+id;
rs.executeSql(sql);
while(rs.next()){
	name = Util.null2String(rs.getString("name")).trim();
	code = Util.null2String(rs.getString("code")).trim();
	fnayearid = rs.getInt("fnayearid");
	fnayearidEnd = rs.getInt("fnayearidEnd");
	enabled = rs.getInt("enabled");
}

StringBuffer FeeWfInfoIds = new StringBuffer();
StringBuffer FeeWfInfoNames = new StringBuffer();

sql = "select a.fnaFeeWfInfoId, c.workflowname\n" +
	" from fnaControlScheme_FeeWfInfo a \n" +
	" join fnaFeeWfInfo b on a.fnaFeeWfInfoId = b.id \n" +
	" join workflow_base c on b.workflowid = c.id \n" +
	" where a.fnaControlSchemeId = "+id;
rs.executeSql(sql);
while(rs.next()){
	int fnaFeeWfInfoId = rs.getInt("fnaFeeWfInfoId");
	String workflowname = Util.null2String(rs.getString("workflowname")).trim();
	
	if(FeeWfInfoIds.length() > 0){
		FeeWfInfoIds.append(",");
		FeeWfInfoNames.append(", ");
	}
	FeeWfInfoIds.append(fnaFeeWfInfoId);
	FeeWfInfoNames.append(workflowname);
}

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
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
			<wea:item><%=SystemEnv.getHtmlLabelName(33162,user.getLanguage())%></wea:item><!-- 方案名称 -->
			<wea:item>
				<wea:required id="namespan" required="true">
					<input id="name" name="name" value="<%=FnaCommon.escapeHtml(name) %>" style="width: 202px;" onblur="checkinput('name','namespan');" class="inputstyle" />
				</wea:required>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(33163,user.getLanguage())%></wea:item><!-- 方案编码 -->
			<wea:item>
				<input id="code" name="code" value="<%=FnaCommon.escapeHtml(code) %>" style="width: 202px;" class="inputstyle" />
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(15365,user.getLanguage())%></wea:item><!-- 预算年度 -->
			<wea:item>
		        <select class="inputstyle" id="fnayearid" name="fnayearid" style="width: 60px;">
				<%
				sql = "select a.id, a.fnayear from FnaYearsPeriods a WHERE a.status in (1, -1) ORDER BY a.fnayear DESC ";
				rs.executeSql(sql);
				while(rs.next()){
					int _id = rs.getInt("id");
					int _fnayear = rs.getInt("fnayear");
				%>
					<option value="<%=_id %>" <% if(_id == fnayearid){%>selected<%}%>><%=_fnayear%></option>
				<%
				}
				%>
		        </select>
		        ~
		        <select class="inputstyle" id="fnayearidEnd" name="fnayearidEnd" style="width: 60px;">
					<option value=""></option>
				<%
				rs.beforFirst();
				rs.executeSql(sql);
				while(rs.next()){
					int _id = rs.getInt("id");
					int _fnayear = rs.getInt("fnayear");
				%>
					<option value="<%=_id %>" <% if(_id == fnayearidEnd){%>selected<%}%>><%=_fnayear%></option>
				<%
				}
				%>
		        </select>
				<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
					title="<%=SystemEnv.getHtmlLabelName(33187,user.getLanguage()) %>" /><!-- 起始年份~结束年份(不选表示始终有效) -->
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(33164,user.getLanguage())%></wea:item><!-- 启用方案 -->
			<wea:item>
    			<input id="enabled" name="enabled" value="1" type="checkbox" tzCheckbox="true" <%=(enabled==1)?"checked":"" %> />
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
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...

jQuery(document).ready(function(){
	resizeDialog(document);
});
checkinput("name","namespan");

function workflowid_callback(){
	
}

//快速（高级）搜索事件
function onBtnSearchClick(from_advSubmit){
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
	var code = null2String(jQuery("#code").val());
	var fnayearid = null2String(jQuery("#fnayearid").val());
	var fnayearidEnd = null2String(jQuery("#fnayearidEnd").val());
	var enabled = jQuery("#enabled").attr("checked")?1:0;
	var FeeWfInfoIds = null2String(jQuery("#FeeWfInfoIds").val());
	
	if(name==""||fnayearid==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage()) %>");//必填信息不完整
		return;
	}

	var fnayearidText = jQuery("#fnayearid").find("option:selected").text();
	var fnayearidEndText = jQuery("#fnayearidEnd").find("option:selected").text();
	
	if(fnayearidEnd!="" && parseInt(fnayearidText) > parseInt(fnayearidEndText)){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(33188,user.getLanguage()) %>");//预算年度起始年份不能大于结束年份
		return;
	}

	openNewDiv_FnaBudgetViewInner1(_Label33574);
	hideRightMenuIframe();
	try{
		var _data = "operation=edit&id="+id+"&name="+encodeURI(name)+"&code="+encodeURI(code)+"&fnayearid="+fnayearid+"&fnayearidEnd="+fnayearidEnd+"&enabled="+enabled+"&FeeWfInfoIds="+FeeWfInfoIds;
		
		jQuery.ajax({
			url : "/fna/budget/FnaControlSchemeSetOp.jsp",
			type : "post",
			cache : false,
			processData : false,
			data : _data,
			dataType : "json",
			success: function do4Success(_json){
			    try{
			    	try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
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
			    	showRightMenuIframe();
			    }catch(e1){
			    	showRightMenuIframe();
			    }
			}
		});	
	}catch(e1){
		showRightMenuIframe();
	}
}

function onCancel(){
	var dialog = parent.parent.getDialog(parent.window);	
	dialog.closeByHand();
}


</script>
</BODY>
</HTML>
