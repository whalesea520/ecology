
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

String targetwfid = Util.null2String(request.getParameter("targetwfid"));
String thisworkflowid = Util.null2String(request.getParameter("thisworkflowid"));

if ("".equals(targetwfid)) {
	return;
}
WorkflowVersion wfversion = new WorkflowVersion(targetwfid);
String currentVersionID = wfversion.getVersionID() + "";
String verionDesc = wfversion.getVersionDesc();
%>

<html>
  <head>
	<link rel="Stylesheet" type="text/css" href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" />
	<style type="text/css">
	
	* {
		font-size:12px;
	}
	</style>
  </head>
  
  <body style="overflow:hidden;margin:0px;">
       <div class="zDialog_div_content" id="zDialog_div_content">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
      <TABLE class="viewform">
      <COLGROUP>
  	<COL width="30%">
  	<COL width="70%">
        <TBODY>
        <TR class="Spacing" style="height:1px;">
          <TD class="Line" colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(22186,user.getLanguage()) %></TD>
          <TD class=Field>V<%=Integer.parseInt(currentVersionID) %></TD>
        </TR> <TR class="Spacing" style="height:1px;">
          <TD class="Line" colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(125122,user.getLanguage()) %></TD>
          <TD class=Field>
          	<textarea rows="4" name="versionDesc" id="versionDesc" style="width:270px;"><%=verionDesc %></textarea></TD>
         </TR>   <TR class="Spacing" style="height:1px;">
          <TD class="Line" colSpan=2></TD></TR>
          <TR>
          <TD><%=SystemEnv.getHtmlLabelName(125123,user.getLanguage()) %></TD>
          <TD class=Field>
          <input type="checkbox" name="activeStatus" id="activeStatus" value="1" <%=wfversion.isActive() ? " checked='true' disabled='disabled'" : "" %>></TD>
         </TR>
         <TR class="Spacing" style="height:1px;">
          <TD class="Line" colSpan=2 ></TD></TR>
        </TBODY></TABLE>
	</td>
		</tr>
		</TABLE>
      </div>
       <div id="zDialog_div_bottom" class="zDialog_div_bottom">
          <table width="100%">
              <tr><td style="text-align:center;" colspan="3" id="jmodaloptcontent">
                  <input type="button" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" onclick="saveAsVersion()" class="zd_btn_submit" id="btnok">
                <input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>" onclick="cancelSaveAs('wfversionDiv');" class="zd_btn_cancle" id="btncancel">
              </td></tr>
          </table>
      </div>
  </body>
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
var thisworkflowid = '<%=thisworkflowid%>';
function saveAsVersion() {
	var targetwfid = <%=targetwfid %>;
	var versionDesc = jQuery("#versionDesc").val();
	var ajaxUrl = "/workflow/workflow/wfVersionOperation.jsp";
	ajaxUrl += "?token=";
	ajaxUrl += new Date().getTime();
	var activeStatus = "";
	var activeDisabled = jQuery("#activeStatus").attr("disabled");
	if (!activeDisabled) {
		activeStatus = jQuery("#activeStatus").attr("checked");
	}
	jQuery.ajax({
	    url: ajaxUrl,
	    dataType: "text", 
	    type: "post", 
	    data: {"targetwfid": targetwfid, "versionDesc": encodeURI(versionDesc), "src":"edit", "status" : activeStatus},
	    contentType : "application/x-www-form-urlencoded; charset=utf-8", 
	    error:function(ajaxrequest){}, 
	    success:function(data, textStatus){
	    	var newwfid = jQuery.trim(data);
	    	jQuery("#zDialog_div_content").html("");
	    	if (!isNaN(newwfid) && parseInt(newwfid) > 0) {
	    		jQuery("#zDialog_div_content").html("<br>&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(125124,user.getLanguage()) %>!");	
	    	} else {
	    		jQuery("#zDialog_div_content").html("<br>&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(125125,user.getLanguage()) %>！");
	    	}
	    	jQuery("#jmodaloptcontent").html("<input type='button' value='<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>' onclick='cancelSaveAsNew(\"wfversionDiv\", 1);' class='zd_btn_cancle'>");
	    	if(thisworkflowid != null && thisworkflowid != '' && thisworkflowid > 0){
	    	    try{
                    var $isvalidSelect = jQuery("#isvalid",window.parent.window.document.getElementsByName("basicsetiframe")[0].contentWindow.document);
                    if(activeStatus){
	                    if(thisworkflowid == targetwfid){
	                        var isvalidHtml = '<option value="0" ><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option>';
	                        isvalidHtml += '<option value="1" selected ><%=SystemEnv.getHtmlLabelName(2246,user.getLanguage())%></option>';
	                        isvalidHtml += '<option value="2"><%=SystemEnv.getHtmlLabelName(25496,user.getLanguage())%></option>';
	                        $isvalidSelect.html(isvalidHtml);
	                        var $tabcontentframe_box = jQuery(window.parent.window.parent.window.parent.window.document.getElementById("wfmainFrame").contentWindow.document.getElementById("tabcontentframe_box"));
                            if($tabcontentframe_box.find(".e8_btn_top_first").attr("id") != "newVersionButton"){
                                $tabcontentframe_box.find(".e8_btn_top_first").hide();
                            }
	                    }else{
	                        var isvalidHtml = '<option value="3" selected ><%=SystemEnv.getHtmlLabelName(18500,user.getLanguage())%></option>';
	                        $isvalidSelect.html(isvalidHtml);
	                    }
                    }else if(activeStatust == false && hisworkflowid == targetwfid){
                        var isvalidHtml = '<option value="3" selected ><%=SystemEnv.getHtmlLabelName(18500,user.getLanguage())%></option>';
                        $isvalidSelect.html(isvalidHtml);
                    }
                    if($isvalidSelect.next()[0].tagName == "SPAN"){
                        $isvalidSelect.next().remove();
                    }
                    __jNiceNamespace__.beautySelect($isvalidSelect);
                    if($isvalidSelect.next()[0].tagName == "SPAN"){
                        $isvalidSelect.next().css("display","block");
                        $isvalidSelect.next().width(95);
	                    $isvalidSelect.next().show();
	                    $isvalidSelect.next().children().show();
                    }
	    	    }catch(e){}
	    	}
	    	jQuery(".zd_btn_cancle").hover(function(){
	            jQuery(this).addClass("zd_btn_cancleHover");
	        },function(){
	            jQuery(this).removeClass("zd_btn_cancleHover");
	        });
	    }  
    });
	jQuery("#zDialog_div_content").html("<br>&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(125126,user.getLanguage()) %>");
	jQuery("#btncancel").attr("disabled", true);
    jQuery("#btnok").attr("disabled", true);
}

function cancelSaveAs(hideDivId, ref) {
	jQuery("#" + hideDivId).hide();
	window.parent.outEditVersion2();
}
function cancelSaveAsNew(hideDivId, ref) {
	window.parent.parent.location.reload();
}
	
	</script>  
</html>
