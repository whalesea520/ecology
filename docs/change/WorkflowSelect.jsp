
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="DocFTPConfigComInfo" class="weaver.docs.category.DocFTPConfigComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("DocChange:Setting", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<script language=javascript >
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);

function onSave(){
	if(check_form(weaver,'wfid')){
       jQuery.ajax({
       	url:"/workflow/workflow/officalwf_operation.jsp",
       	dataType:"json",
       	type:"post",
       	data:{
       		wfid:jQuery("#wfid").val(),
       		operation:"addChangeWf"
       	},
       	beforeSend:function(xhr){
       		e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(23278,user.getLanguage())%>",true);
       	},
       	complete:function(xhr){
       		e8showAjaxTips("",false);
       	},
       	success:function(data){
       		if(data.result==1){
       			try{
     				parentWin._table.reLoad();
     			}catch(e){}
       			dialog.close();
       		}else{
       			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83409,user.getLanguage())%>");
       		}
       	}
       });
    }
}

</script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(65,user.getLanguage());
String needfav ="1";
String needhelp ="";

int errorcode = Util.getIntValue(request.getParameter("errorcode"),0);
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(!"1".equals(isDialog)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>



<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" class="e8_btn_top" onclick="onSave();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<FORM id=weaver action="offcialwf_operation.jsp" method=post onSubmit="return check_form(this,'wfid')">
	<wea:layout>
		<wea:group context='<%= SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(18104,user.getLanguage())%>
			</wea:item>
			<wea:item>
				<span>
			        <brow:browser viewType="0" name="wfid" browserValue="" 
			                browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser_frm.jsp?isWorkflowDoc=1"
			                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="2"
			                language='<%=""+user.getLanguage() %>'
			                completeUrl="/data.jsp?type=workflowChangeBrowser"  temptitle='<%= SystemEnv.getHtmlLabelName(18104,user.getLanguage())%>'
			                browserSpanValue="">
			        </brow:browser>
			    </span>
			</wea:item>
		</wea:group>
	</wea:layout>

			<input type="hidden" name="isdialog" value="<%=isDialog%>">
          <input type=hidden value="addChangeWf" name="operation">
</FORM>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
			    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
</BODY></HTML>

