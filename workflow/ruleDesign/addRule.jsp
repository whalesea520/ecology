<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@page import="weaver.workflow.ruleDesign.RuleBusiness"%>
<%@page import="weaver.workflow.ruleDesign.RuleBean"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

int ruleid = Util.getIntValue(request.getParameter("ruleid"), -1);
String src = Util.null2String(request.getParameter("src"));
String titleName = ""+SystemEnv.getHtmlLabelName(579,user.getLanguage());
String ruleName = "";
String ruleDesc = "";
if (ruleid > 0) {
    RuleBean rb = RuleBusiness.getRuleBean(ruleid);
    ruleName = rb.getRulename();
    ruleDesc = rb.getRuledesc();
    titleName = ""+SystemEnv.getHtmlLabelName(579,user.getLanguage());
}

%>

<html>
  <head>
	
	<link rel="Stylesheet" type="text/css" href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" />
	<script type="text/javascript">
	
	
function saveAsVersion(a) {
	var dialog = parent.getDialog(window);
	var parentWin = parent.getParentWindow(window);
	if (check_form(weaver,'ruleName')){
		var ruleid = "<%=ruleid %>";
		var ruleName = jQuery("#ruleName").val();
		var ruleDesc = jQuery("#ruleDesc").val();
		var ajaxUrl = "/workflow/ruleDesign/addRuleOperation.jsp";
		ajaxUrl += "?token=";
		ajaxUrl += new Date().getTime();
		jQuery.ajax({
		    url: ajaxUrl,
		    dataType: "text", 
		    type: "post", 
		    data: {"name": encodeURI(ruleName), "desc": encodeURI(ruleDesc), ruleid : ruleid},
		    contentType : "application/x-www-form-urlencoded; charset=utf-8", 
		    error:function(ajaxrequest){}, 
		    success:function(data, textStatus){
		    	var newwfid = jQuery.trim(data);
		    	if(newwfid === "num")
		    	{
		    		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(84543,user.getLanguage())%>");
		    		jQuery("#savingdiv").remove();
		    		return;
		    	}
		    	jQuery("#zDialog_div_content").html("");
		    	if (!isNaN(newwfid) && parseInt(newwfid) > 0) {
		    		parentWin._table.reLoad();
		    		parentWin.closeDialog();
		    		if(a==1)
		    		{
		    			parentWin.openRuleDesin(newwfid,"3");
		    		}
		    		
		    	} else {
		    		jQuery("#zDialog_div_content").html("<br>&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(84544,user.getLanguage())%>");
		    	}
		    	jQuery("#jmodaloptcontent").html("<input type='button' value='<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>' onclick='cancelSaveAs(\"wfversionDiv\", 1);' class='zd_btn_cancle'>");
			    jQuery(".zd_btn_cancle").hover(function(){
		            jQuery(this).addClass("zd_btn_cancleHover");
		        },function(){
		            jQuery(this).removeClass("zd_btn_cancleHover");
		        });
		    }  
	    });
	    if("<%=src%>" != "rename"){
		jQuery("#zDialog_div_content").append("<div id='savingdiv' style='width:100%;height:100%;top:0px;left:0px;position:absolute;background:#fff'><br/>&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(129391, user.getLanguage())%></div>");
		}else{
		jQuery("#zDialog_div_content").append("<div id='savingdiv' style='width:100%;height:100%;top:0px;left:0px;position:absolute;background:#fff'><br/>&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(129392, user.getLanguage())%></div>");
		}
		jQuery("#btncancel").attr("disabled", true);
		jQuery("#btnok").attr("disabled", true);
	}
}

function cancelSaveAs(hideDivId, ref) {
	jQuery("#" + hideDivId).hide();
	if (ref != undefined && ref == 1) {
		parentWin.location.reload();
	}
	parentWin.closeDialog();
}

function checkval(){
	if($("#ruleName").val().length>0){
    	$("img[align=absMiddle]").hide();
    }else{
    	$("img[align=absMiddle]").show();
    }
};

	</script>
  </head>
  <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
  <%
     RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveAsVersion(),_top} " ;
     RCMenuHeight += RCMenuHeightStep;
     RCMenu += "{"+SystemEnv.getHtmlLabelName(32159,user.getLanguage())+",javascript:saveAsVersion(1),_top} " ;
     RCMenuHeight += RCMenuHeightStep;
  %>
  <body style="overflow:hidden;margin:0px;">
<FORM id="weaver" name="weaver" action="" method=post style="width:100%;">
	<div class="zDialog_div_content" id="zDialog_div_content">
	<jsp:include page="/systeminfo/commonTabHead.jsp">
	   <jsp:param name="mouldID" value="workflow"/>
	   <jsp:param name="navName" value="<%=titleName %>"/>
	</jsp:include>     	
      		
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" onclick="saveAsVersion()" class="e8_btn_top" id="btnok">	
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage()) %>" onclick="saveAsVersion(1)" class="e8_btn_top" id="btnok1">
		      			
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table> 
			<wea:layout type="twoCol">
			    <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>'>
			    	<wea:item><%=SystemEnv.getHtmlLabelName(19829,user.getLanguage())%></wea:item>
				    <wea:item>
				    	<wea:required id="ruleNameimg" required="true" value='<%=ruleName %>'>
				    		<input type="text" name="ruleName" id="ruleName" value="<%=ruleName %>" onblur="checkval()" style="width: 80%;">
				    	</wea:required>				    	
				    </wea:item>
			    	<wea:item><%=SystemEnv.getHtmlLabelName(579,user.getLanguage())+SystemEnv.getHtmlLabelName(85,user.getLanguage())%></wea:item>
			    	<wea:item><textarea style="margin-top:2px;margin-bottom:2px;margin-top: 2px;margin-bottom: 2px;resize: none;width: 80%;" rows="4" cols="20" name="ruleDesc" id="ruleDesc"><%=ruleDesc %></textarea></wea:item>
			    </wea:group>
			</wea:layout>
		<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>			    		
      </div>
      </FORM>
      <div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{groupDisplay:none}">
				<wea:item type="toolbar">
			    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getParentWindow(window).closeDialog();">
				</wea:item>
			</wea:group>
		</wea:layout>      
	  </div>
  </body>
   <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</html>
