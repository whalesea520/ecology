<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<HTML>
<%
if(!HrmUserVarify.checkUserRight("HrmArrangeShiftMaintance:Maintance", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16749 , user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HEAD>
  <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
  <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
  <script type="text/javascript">
	var parentWin = parent.parent.getParentWindow(parent);
	var dialog = parent.parent.getDialog(parent);
	if("<%=isclose%>"=="1"){
		parentWin.onBtnSearchClick();
		parentWin.closeDialog();	
	}
  </script>
<script type="text/javascript">
	function jsSharetype(){
		var type = jQuery("#sharetype").val();
		jQuery("input[name=relatedId]").val("");
		jQuery("input[name=relatedname]").val("");
		hideEle("item_subcompany");
		hideEle("item_department");
		hideEle("item_resource");
		hideEle("item_role");
		hideEle("item_level");
		if(type == "1"){
			showEle("item_subcompany");
			showEle("item_level");
		}else if(type == "2"){
			showEle("item_department");
			showEle("item_level");
		}else if(type == "3"){
			showEle("item_resource");
		}else if(type == "4"){
			showEle("item_role");
			showEle("item_level");
		}else if(type == "5"){
			showEle("item_level");
		}
	}
	
	function jsSetRelate(e, data, name) {
		if (data!=""&&data.id != "") {
			jQuery("input[name=relatedId]").val(data.id);
			jQuery("input[name=relatedname]").val(data.name);
		}
	}
</script>
</HEAD>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>    
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="submitData();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=frmmain name=frmmain action="HrmArrangeShiftSetOperation.jsp" method=post>
<input id=operation name=operation type=hidden value="">
<input id=relatedId name=relatedId type=hidden value="">
<input id=relatedname name=relatedname type=hidden value="">
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361 , user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(106 , user.getLanguage())%></wea:item>
   	<wea:item>
			<select id="sharetype" name="sharetype" onchange="jsSharetype()">
				<option value="1"><%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%></option>
				<option value="2"><%=SystemEnv.getHtmlLabelName(27511 , user.getLanguage())%></option>
				<option value="3"><%=SystemEnv.getHtmlLabelName(179 , user.getLanguage())%></option>
				<option value="4"><%=SystemEnv.getHtmlLabelName(122 , user.getLanguage())%></option>
				<option value="5"><%=SystemEnv.getHtmlLabelName(1340 , user.getLanguage())%></option>
			</select>
   	</wea:item>
   	<wea:item attributes="{'samePair':'item_subcompany'}"><%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%></wea:item>
   	<wea:item attributes="{'samePair':'item_subcompany'}">
	  	<brow:browser viewType="0" name="subcompany" browserValue=""
      browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
      hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
      completeUrl="/data.jsp?type=164" _callback="jsSetRelate" browserSpanValue="">
      </brow:browser>
   	</wea:item>
   	<wea:item attributes="{'samePair':'item_department'}"><%=SystemEnv.getHtmlLabelName(27511 , user.getLanguage())%></wea:item>
   	<wea:item attributes="{'samePair':'item_department'}">
   		<brow:browser viewType="0"  name="department" browserValue=""
      browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/DepartmentBrowser.jsp?selectedids="
      hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
      completeUrl="/data.jsp?type=4" _callback="jsSetRelate" browserSpanValue="">
      </brow:browser>
   	</wea:item>
   	<wea:item attributes="{'samePair':'item_resource'}"><%=SystemEnv.getHtmlLabelName(179 , user.getLanguage())%></wea:item>
   	<wea:item attributes="{'samePair':'item_resource'}">
   		<brow:browser viewType="0"  name="resource" browserValue=""
      browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?selectedids="
      hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
      completeUrl="/data.jsp" _callback="jsSetRelate" browserSpanValue="">
      </brow:browser>
   	</wea:item>
   	<wea:item attributes="{'samePair':'item_role'}"><%=SystemEnv.getHtmlLabelName(122 , user.getLanguage())%></wea:item>
   	<wea:item attributes="{'samePair':'item_role'}">
   		<brow:browser viewType="0"  name="role" browserValue=""
      browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/roles/HrmRolesBrowser.jsp?selectedids="
      hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
      completeUrl="/data.jsp?type=65" _callback="jsSetRelate" browserSpanValue="">
      </brow:browser>
   	</wea:item>
	 	<wea:item attributes="{'samePair':'item_level'}"><%=SystemEnv.getHtmlLabelName(683 , user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'item_level'}">
			<input name="level_from" type="text" value="" style="width: 60px">&nbsp;
			-&nbsp;<input name="level_to" type="text" value="" style="width: 60px">
		</wea:item>
	</wea:group>
</wea:layout>
 <%if("1".equals(isDialog)){ %>
 </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<table width="100%">
	    <tr>
		    <td style="text-align:center;" colspan="3">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
		    </td>
	    </tr>
	</table>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
			jsSharetype();
		});
	</script>
<%} %>
</FORM>
</BODY>
<script language=javascript>  
function submitData() {
	var type = jQuery("#sharetype").val();
	if(type == 5 || (jQuery("#sharetype").val()!="" && jQuery("#relatedId").val()!="")){
		frmmain.operation.value="add";
		frmmain.submit();
	}else{
		window.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
	}
}
</script>
</HTML>
