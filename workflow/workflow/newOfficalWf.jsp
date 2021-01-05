
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="DocFTPConfigComInfo" class="weaver.docs.category.DocFTPConfigComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("DocMainCategoryAdd:add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String isEntryDetail = Util.null2String(request.getParameter("isentrydetail"));
String id = Util.null2String(request.getParameter("id"));
if(isEntryDetail.equals(""))isEntryDetail = "0";
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<script language=javascript >
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);

function onSave(isEnterDetail){
	jQuery('#isentrydetail').val(isEnterDetail);
	if(check_form(weaver,'wfid')){
       jQuery.ajax({
       	url:"officalwf_operation.jsp",
       	dataType:"json",
       	type:"post",
       	data:{
       		wfid:jQuery("#wfid").val(),
       		operation:"setOfficalWf"
       	},
       	success:function(data){
       		if(data.result==1){
       			try{
     				parentWin._table.reLoad();
     			}catch(e){}
       			if(isEnterDetail==1){
       				parentWin.closeDialog(jQuery("#wfid").val());
       			}else{
       				dialog.close();
       			}
       		}else{
       			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83409, user.getLanguage())%>");
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
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave("+isEntryDetail+"),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(32159,user.getLanguage())+",javascript:onSave(1),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>



<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(20873,user.getLanguage())%>" class="e8_btn_top" onclick="onSave(<%= isEntryDetail%>);">
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("20873,33685",user.getLanguage())%>" class="e8_btn_top" onclick="onSave(1);">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<FORM id=weaver action="offcialwf_operation.jsp" method=post onSubmit="return check_form(this,'officalType,workflowname,typeid')">
	<wea:layout>
		<wea:group context='<%= SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(18104,user.getLanguage())%>
			</wea:item>
			<wea:item>
					<select name="officalType" id="officalType">
						<option value="1"><%=SystemEnv.getHtmlLabelName(26528,user.getLanguage()) %></option>
						<option value="2"><%=SystemEnv.getHtmlLabelName(33682,user.getLanguage()) %></option>
						<option value="3"><%=SystemEnv.getHtmlLabelName(33683,user.getLanguage()) %></option>
					</select>
			</wea:item>
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(18104,user.getLanguage())%>
			</wea:item>
			<wea:item>
				<wea:required id="workflownamespan" required="true">
					<input type="text" class="InputStyle" name="workflowname" id="workflowname" onchange="checkinput('workflowname','workflownamespan');"/>
				</wea:required>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(16579,user.getLanguage())%></wea:item>
			    <wea:item>
			    	<wea:required id="typeidspan" required="true">
					   	<select class=inputstyle  name=typeid id="typeid" onchange="checkinput('typeid','typeidspan')">
				    	  	<option value="">&nbsp;</option>
				    	  	<%
						    while(WorkTypeComInfo.next()){
							%>
							<option value="<%=WorkTypeComInfo.getWorkTypeid()%>"><%=WorkTypeComInfo.getWorkTypename()%></option>
							<%}%>
			    	    </select>
			    	 </wea:required>
			    </wea:item>
		</wea:group>
	</wea:layout>

			<input type="hidden" name="isdialog" value="<%=isDialog%>">
		<input type="hidden" id = "isentrydetail" name="isentrydetail" value="">
		<input type="hidden" id = "isWorkflowDoc" name="isWorkflowDoc" value="1">
          <input type=hidden value="newOfficalWf" name="operation">
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

