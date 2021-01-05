<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.CategoryUtil" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%

//编辑权限验证
if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

int categoryid = Util.getIntValue(request.getParameter("categoryid"),0);
int categorytype = Util.getIntValue(request.getParameter("categorytype"),0);
int operationcode = Util.getIntValue(request.getParameter("operationcode"),0);
String isclose = Util.null2String(request.getParameter("isclose"));
if (!CategoryUtil.checkCategoryExistence(categorytype, categoryid)) {
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
	return;
}


%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<style type="text/css">
	div.ac_results{
		max-height:85px!important;

	}
	.sbHolder{
		height:35px;
		background-color:#f7f7fa;
		border:1px solid #d7d9e0;
	}
	.e8_innerShowContent{
		border:1px solid #d7d9e0;
	}
	.ac_input{
		height: 33px !important;
		display: inline!important;
	}
	.sbSelector{
		height:35px;
		top:4px;
		color:#52626a!important;
	}
	
	.sbToggle{
		height:35px;
		top:4px;
	}
	.sbOptions li, .asOptions li{
		height:35px;
		line-height:20px;
	}
	.sbOptions li:hover{
		background-color:#5d9ffe;
	}
	.e8_innerShow{
		min-height:35px;
		width:14px;
		margin-left:0px;
	}
	.e8_innerShowContent div{
		height:35px;
	}
	.e8_spanFloat{
		position:absolute;
		top:8px;
	}
	.e8_showNameClass{
		
	}
</style>
<script type="text/javascript">
	var parentWin = parent.getParentWindow(window);
	var dialog = parent.getDialog(window);
	if("<%=isclose%>"=="1"){
			var url = "/rdeploy/doc/DocSecCategoryRightEdit.jsp?id=<%=categoryid%>";
			parentWin.location = url;
		dialog.close();	
	}
	jQuery(document).ready(function(){
		jQuery($GetEle("showrolelevel")).css("display","none");
		jQuery($GetEle("showusertype")).css("display","none");
		resizeDialog(document);
	});
</script>
</HEAD>
<BODY style="overflow:hidden;">


<FORM id=mainform name=mainform action="ShareOperation.jsp" method=post onsubmit='return check_by_permissiontype()'>
  <input type="hidden" name="method" value="add">
  <input type="hidden" name="categoryid" value="<%=categoryid%>">
  <input type="hidden" name="secid" value="<%=categoryid%>">
  <input type="hidden" name="categorytype" value="<%=categorytype%>">
  <input type="hidden" name="operationcode" value="<%=operationcode%>">
	<input type="hidden" name="operategroup" value="3">	
  <input type="hidden" name="mutil" value="1">
   <input type="hidden" name="sharelevel" value="1">
   <input type="hidden" name="relatedshareid" id="relatedshareid" value="">


<div class="zDialog_div_content" style="position:absolute;bottom:48px;top:0px;width: 100%;">
			<table width="100%" height="100%" cellpadding="0px" cellspacing="0px" border="0px">
				<colgroup>
					<col width="20%"/>
					<col width="80%"/>
				</colgroup>
				<tr>
					<td style="text-align:right;color:#52626a;"><%= SystemEnv.getHtmlLabelName(19910,user.getLanguage()) %></td> <!-- 19910 共享范围 -->
					<td valign="middle" align="center">
						<div style="margin-left:12px;">
						<span style="font-size:12px;">
							<SELECT style="width:80px;float:left;" class=InputStyle name="sharetype" id="sharetype" onchange="onChangePermissionType()">
							  <option value="5"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage()) %></option> <!-- 1340 所有人 -->
							  <option value="1" selected><%=SystemEnv.getHtmlLabelName(23122,user.getLanguage()) %></option> <!-- 23122 指定人 -->
							</SELECT>
						</span>
						<span id="showuser" style="display:none;">
						   <brow:browser viewType="0" name="userid" browserValue=""  width="300px"
							browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=#id#"
							hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
							completeUrl="/data.jsp"
							></brow:browser>
						</span>
						</div>
		</td>
				</tr>
			</table>


<script language=javascript>
onChangePermissionType();

function check_by_permissiontype() {
    if (document.mainform.sharetype.value == 5) {
		jQuery("#relatedshareid").val("0");
        return true;
    } else if (document.mainform.sharetype.value == 1) {
		jQuery("#relatedshareid").val(jQuery("#userid").val())
        return check_form(mainform, "relatedshareid");
    } else {
        return false;
    }
}

function doSave(obj) {
    if (check_by_permissiontype()) {
    	obj.disabled=true;
	    document.mainform.submit();
	}
}
//改变操作人类型
function onChangePermissionType() {
	thisvalue=$("#sharetype").val();
	if (thisvalue == 1) {
 		jQuery($GetEle("showuser")).css("display","");
    }
	else if (thisvalue == 5) {
 		jQuery($GetEle("showuser")).css("display","none");
	}
}
</script>
	</div>
	</FORM>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="doSave(this);">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</BODY>
</HTML>
