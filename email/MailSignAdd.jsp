
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(24266, user.getLanguage())+":" + SystemEnv.getHtmlLabelName(611, user.getLanguage());
	String needfav = "1";
	String needhelp = "";
	String showTop = Util.null2String(request.getParameter("showTop"));
%>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<!--引入ueditor相关文件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.config_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.all_wev8.js"> </script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/imgupload_wev8.js"></script>

<%@ include file="/cowork/uploader.jsp" %>
<jsp:include page="MailUtil.jsp"></jsp:include>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
<script language="javascript" type="text/javascript">
var lang=<%=(user.getLanguage() == 8) ? "true" : "false"%>;
jQuery(document).ready(function(){
	highEditor("signContent");
});

function doSubmit(){
	
	if(check_form(fMailSign,'signName')){
	with(document.getElementById("fMailSign")){
		if("0" == signType) { 
			changeImgToEmail("signContent");
			var remarkValue=getRemarkHtml("signContent");
			$("textarea[name=signContent]").val(remarkValue);
		}else{
			updateIndexs();
		}
		
		submit();
	}}
}

var signType = 0;
function selectSignType(selObj){
	signType = selObj.value;
	if(selObj.value == 1) {
		jQuery('#signContentdiv').hide()
		jQuery('#signEleContentdiv').show();
	}else {
		jQuery('#signContentdiv').show()
		jQuery('#signEleContentdiv').hide();
		
	}
}

function addIconCallback(url){
	jQuery('#headimg').attr('src', url);
	jQuery('#headimghid').val(url);
	jQuery('#isheadimghid').val("0");
    dialog.close();
}

</script>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ",javascript:doSubmit(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<html>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="mail"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(24266,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="doSubmit()" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form method="post" action="MailSignOperation.jsp" id="fMailSign" name="fMailSign">
<input type="hidden" name="operation" value="add" />
<input type="hidden" id="headimghid" name="headimg" value="<%=request.getParameter("headimg")%>" />
<input type="hidden" id="isheadimghid" name="isheadimghid" value="1" />
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(20148, user.getLanguage())%><!-- 签名 --></wea:item>
		<wea:item>
			<wea:required id="signNameSpan" required="true">
				<input type="text" name="signName" class="inputstyle" style="width:30%" 
					onChange="checkinput('signName','signNameSpan')" />
			</wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("20148,63",user.getLanguage())%></wea:item>
		<wea:item>
			<span style="float:left;margin-right:10px;">
				<SELECT  class=InputStyle name="signType" id="signType"  style="width: 120px;" onchange="selectSignType(this)">
				  	  <option value="0" selected='selected'><%=SystemEnv.getHtmlLabelNames("608,20148",user.getLanguage()) %></option>
					  <option value="1" ><%=SystemEnv.getHtmlLabelNames("83063,20148",user.getLanguage()) %></option>
				</SELECT>
			</span>
		</wea:item> 
		<wea:item><%=SystemEnv.getHtmlLabelName(83064, user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="isActive" id="isActive" value="1" class="inputstyle" />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(85, user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" name="signDesc" class="inputstyle" style="width:30%" />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(345, user.getLanguage())%></wea:item>
		<wea:item>
			<div id='signContentdiv' style="width:98%">
				<textarea id="signContent" _editorid="signContent" _editorName="signContent" style="width:100%;height:250px;border:1px solid #C7C7C7;"></textarea>
			</div>
			<div id='signEleContentdiv' style='display: none;position:relative;height: 320px' >
				<jsp:include page="/email/new/MailEleSign.jsp" flush="true">     
     				<jsp:param name="userid" value="<%=user.getUID() %>"/> 
     				<jsp:param name="isedit" value="1" />
				</jsp:include> 
			</div>
		</wea:item>
	</wea:group>
</wea:layout>
</form>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>

</html>
