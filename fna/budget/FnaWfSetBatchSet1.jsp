<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("CostControlProcedure:set", user)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(33075,user.getLanguage());
String needfav ="1";
String needhelp ="";

String ids = Util.null2String(request.getParameter("ids")).trim();

StringBuffer FnaWfSetMultiIds = new StringBuffer();
StringBuffer FnaWfSetMultiNames = new StringBuffer();
String sql = "select a.id, b.workflowname  \n" +
		" from fnaFeeWfInfo a \n" +
		" join workflow_base b on a.workflowid = b.id \n" +
		" where a.id in ("+ids+"-1)";
rs.executeSql(sql);
while(rs.next()){
	if(FnaWfSetMultiIds.length() > 0){
		FnaWfSetMultiIds.append(",");
		FnaWfSetMultiNames.append(",");
	}
	FnaWfSetMultiIds.append(Util.null2String(rs.getString("id")).trim());
	FnaWfSetMultiNames.append(Util.null2String(rs.getString("workflowname")).trim());
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
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(31259, user.getLanguage())
			+ ",javascript:doSave(1),_self} ";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{" + SystemEnv.getHtmlLabelName(31260, user.getLanguage())
			+ ",javascript:doSave(2),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="fna"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(33190,user.getLanguage()) %>"/>
</jsp:include>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr><td>&nbsp;</td>
				<td class="rightSearchSpan" style="text-align: right;">
		    		<input class="e8_btn_top" type="button" id="btnSave1" onclick="doSave(1);" 
		    			value="<%=SystemEnv.getHtmlLabelName(31259,user.getLanguage())%>"/><!-- 追加 -->
		    		<input class="e8_btn_top" type="button" id="btnSave2" onclick="doSave(2);" 
		    			value="<%=SystemEnv.getHtmlLabelName(31260,user.getLanguage())%>"/><!-- 覆盖 -->
					<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		
		
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(23753,user.getLanguage())%></wea:item><!-- 流程名称 -->
		<wea:item>
	        <brow:browser viewType="0" name="FnaWfSetMulti" browserValue='<%=FnaWfSetMultiIds+"" %>' 
	                browserUrl="/systeminfo/BrowserMain.jsp?url=/fna/browser/fnaWfSet/FnaWfSetBrowserMulti.jsp%3Fselectids=#id#"
	                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput="2"
	                completeUrl="/data.jsp?type=FnaWfSetMulti"  temptitle='<%= SystemEnv.getHtmlLabelName(23753,user.getLanguage())%>'
	                browserSpanValue='<%=FnaWfSetMultiNames.toString() %>' width="90%" 
	                >
	        </brow:browser>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(33071,user.getLanguage())%></wea:item><!-- 费控方案 -->
		<wea:item>
	        <brow:browser viewType="0" name="fnaControlSchemeIds" browserValue="" 
	                browserUrl="/systeminfo/BrowserMain.jsp?url=/fna/browser/fnaControlSchemeSet/FnaControlSchemeSetMulti.jsp%3Fselectids=#id#"
	                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
	                completeUrl="/data.jsp?type=FnaControlSchemeSetMulti"  temptitle='<%=SystemEnv.getHtmlLabelName(33071,user.getLanguage()) %>'
	                browserSpanValue="" width="90%" 
	                >
	        </brow:browser>
		</wea:item>
	</wea:group>
</wea:layout>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
		    <wea:group context="">
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

function workflowid_callback(){
	
}

//快速（高级）搜索事件
function onBtnSearchClick(from_advSubmit){
}

//关闭
function doClose(){
	var parentWin = parent.getParentWindow(window);
	parentWin.closeDialog();
}

//保存
function doSave(saveType){
	var FnaWfSetMulti = null2String(jQuery("#FnaWfSetMulti").val());
	var fnaControlSchemeIds = null2String(jQuery("#fnaControlSchemeIds").val());
	if(FnaWfSetMulti==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage()) %>");//必填信息不完整
		return;
	}
	if(saveType==1){
		if(fnaControlSchemeIds==""){
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage()) %>");//必填信息不完整
			return;
		}
	}
	hideRightMenuIframe();
	try{
		var _data = "operation=FnaWfSetBatchSet1&FnaWfSetMulti="+FnaWfSetMulti+"&fnaControlSchemeIds="+fnaControlSchemeIds+"&saveType="+saveType;

		openNewDiv_FnaBudgetViewInner1(_Label33574);
		jQuery.ajax({
			url : "/fna/budget/FnaWfSetEditOp.jsp",
			type : "post",
			cache : false,
			processData : false,
			data : _data,
			dataType : "json",
			success: function do4Success(_json){
			    try{
			    	try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
					if(_json.flag){
						top.Dialog.alert(_json.msg,function(){
							onCancel2();
						});
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
	var dialog = parent.getDialog(window);	
	dialog.closeByHand();
}

function onCancel2(){
	var dialog = parent.getDialog(window);	
	dialog.close();
}

</script>
</BODY>
</HTML>
