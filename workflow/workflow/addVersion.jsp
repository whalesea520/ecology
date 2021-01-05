
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

String targetwfid = Util.null2String(request.getParameter("targetwfid"));

if ("".equals(targetwfid)) {
	return;
}
WorkflowVersion wfversion = new WorkflowVersion(targetwfid);
String lastVersionID = wfversion.getLastVersionID() + "";
%>

<html>
  <head>
	
	<link rel="Stylesheet" type="text/css" href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" />
	<style type="text/css">
	
	* {
		font-size:12px;
	}
	</style>
	<script type="text/javascript">
	
	
	jQuery(function () {
	
		jQuery(".zd_btn_submit").hover(function(){
			jQuery(this).addClass("zd_btn_submit_hover");
		},function(){
			jQuery(this).removeClass("zd_btn_submit_hover");
		});
		
		jQuery(".zd_btn_cancle").hover(function(){
			jQuery(this).addClass("zd_btn_cancleHover");
		},function(){
			jQuery(this).removeClass("zd_btn_cancleHover");
		});
	});
	
	var dialog = parent.getDialog(window);
	var parentWin = parent.getParentWindow(window);
	
function saveAsVersion() {
	var targetwfid = <%=targetwfid %>;
	var versionDesc = jQuery("#versionDesc").val();
	var ajaxUrl = "/workflow/workflow/wfVersionOperation.jsp";
	ajaxUrl += "?token=";
	ajaxUrl += new Date().getTime();
	jQuery.ajax({
	    url: ajaxUrl,
	    dataType: "text", 
	    type: "post", 
	    data: {"targetwfid": targetwfid, "versionDesc": encodeURI(versionDesc)},
	    contentType : "application/x-www-form-urlencoded; charset=utf-8", 
	    error:function(ajaxrequest){}, 
	    success:function(data, textStatus){
	    	var newwfid = jQuery.trim(data);
	    	jQuery("#zDialog_div_content").html("");
	    	if (!isNaN(newwfid) && parseInt(newwfid) > 0) {
	    		jQuery("#zDialog_div_content").html("<br>&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(129419, user.getLanguage())%>");	
	    	} else {
	    		jQuery("#zDialog_div_content").html("<br>&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(129420, user.getLanguage())%>");
	    	}
	    	jQuery("#jmodaloptcontent").html("<input type='button' value='<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>' onclick='cancelSaveAs(\"wfversionDiv\", 1);' class='zd_btn_cancle'>");
		    jQuery(".zd_btn_cancle").hover(function(){
	            jQuery(this).addClass("zd_btn_cancleHover");
	        },function(){
	            jQuery(this).removeClass("zd_btn_cancleHover");
	        });
	    }  
    });
	jQuery("#zDialog_div_content").html("<br>&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(129421, user.getLanguage())%>");
	
	jQuery("#btncancel").attr("disabled", true);
	jQuery("#btnok").attr("disabled", true);
}

function cancelSaveAs(hideDivId, ref) {
	jQuery("#" + hideDivId).hide();
	if (ref != undefined && ref == 1) {
		if (!!parentWin.parent) {
			parentWin.parent.location.reload();
		} else {
			parentWin.location.reload();
		}
	}
	parentWin.cancelsaveAsWorkflow();
}
	
	</script>
  </head>
  
  <body style="overflow:hidden;margin:0px;">
      <div class="zDialog_div_content" id="zDialog_div_content">
          <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <colgroup><col width="20px"><col width="20%"><col width="*"></colgroup>
              <tr><td colspan="2" style="height:10px;"></td></tr>
              <tr>
                  <td></td><td><%=SystemEnv.getHtmlLabelName(22186, user.getLanguage())%></td>
                  <td>V<%=Integer.parseInt(lastVersionID) + 1 %></td>
              </tr>
              <tr><td colspan="3" style="height:2px;"></td></tr>
              <tr>
                  <td></td><td><%=SystemEnv.getHtmlLabelName(125122, user.getLanguage())%></td>
                  <td><textarea rows="4" name="versionDesc" id="versionDesc" style="width:270px;"></textarea></td>
              </tr>
          </table>
      </div>
      <div id="zDialog_div_bottom" class="zDialog_div_bottom">
          <table width="100%">
		      <tr><td style="text-align:center;" colspan="3" id="jmodaloptcontent">
		          <input type="button" value="<%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%>" onclick="saveAsVersion()" class="zd_btn_submit" id="btnok">
		          <input type="button" value="<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>" onclick="cancelSaveAs('wfversionDiv');" class="zd_btn_cancle" id="btncancel">
		      </td></tr>
		  </table>
	  </div>
  </body>
</html>
