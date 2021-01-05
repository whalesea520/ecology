
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@page import="weaver.hrm.companyvirtual.DepartmentVirtualComInfo"%>
<%@page import="weaver.hrm.companyvirtual.SubCompanyVirtualComInfo"%>
<%@page import="weaver.hrm.roles.RolesComInfo"%>
<%@page import="weaver.hrm.check.JobComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="PermissionTransferMgr"
	class="weaver.workflow.transfer.PermissionTransferMgr" scope="page" />

<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

String gids = Util.null2String(request.getParameter("gids"));

if ("".equals(gids)) {
	return;
}
int optflag = Util.getIntValue(request.getParameter("optflag"), 0);
String objtype = Util.null2String(request.getParameter("objtype"));
int objid = Util.getIntValue(request.getParameter("objid"),0);
int rlcobjid = Util.getIntValue(request.getParameter("rlcobjid"),0);
 

String objidspanvalue = "";
String rlcobjidspanvalue = "";
if ("1".equals(objtype)) {
    ResourceComInfo resourceComInfo = new ResourceComInfo();
    objidspanvalue =PermissionTransferMgr.getHrmOperator(gids,objid+"");
    rlcobjidspanvalue = resourceComInfo.getLastname(rlcobjid+"");
} else if ("4".equals(objtype)) {
	DepartmentComInfo dc = new DepartmentComInfo() ;
    DepartmentVirtualComInfo dvc = new DepartmentVirtualComInfo();
    if(objid < 0)
    	objidspanvalue = dvc.getDepartmentname(objid+"");
    else
    	objidspanvalue = dc.getDepartmentname(objid+"");
    if(rlcobjid < 0)
    	rlcobjidspanvalue = dvc.getDepartmentname(rlcobjid+"");
    else
    	rlcobjidspanvalue = dc.getDepartmentname(rlcobjid+"");
} else if ("65".equals(objtype)) {
    RolesComInfo rc = new RolesComInfo();
    objidspanvalue = rc.getRolesname(objid+"");
    rlcobjidspanvalue = rc.getRolesname(rlcobjid+"");
} else if ("164".equals(objtype)) {
	SubCompanyComInfo sc = new SubCompanyComInfo() ;
    SubCompanyVirtualComInfo svc = new SubCompanyVirtualComInfo();
    if(objid < 0)
    	objidspanvalue = svc.getSubCompanyname(objid+"");
    else
    	objidspanvalue = sc.getSubCompanyname(objid+"");
    if(rlcobjid < 0)
    	rlcobjidspanvalue = svc.getSubCompanyname(rlcobjid+"");
    else
    	rlcobjidspanvalue = sc.getSubCompanyname(rlcobjid+"");
}else if ("58".equals(objtype)) {
	JobComInfo jobComInfo = new JobComInfo();
    objidspanvalue = jobComInfo.getJobName(""+objid);
    rlcobjidspanvalue = jobComInfo.getJobName(""+rlcobjid);
}

String optvalue = "";
String optdisplayvalue = "";
//替换
if (optflag == 0) {
    optvalue = ""+ SystemEnv.getHtmlLabelName(84563,user.getLanguage());
    optdisplayvalue = "<span style='color:red;'>" + objidspanvalue + "</span><span>&nbsp;"+SystemEnv.getHtmlLabelName(83020,user.getLanguage())+"&nbsp;</span><span style='color:red;'>" + rlcobjidspanvalue + "</span>";
} else if (optflag == 1) { //复制 
    optvalue = ""+SystemEnv.getHtmlLabelName(77,user.getLanguage());
    optdisplayvalue = "<span style='color:red;'>" + objidspanvalue + "</span><span>&nbsp;"+SystemEnv.getHtmlLabelName(125350, user.getLanguage())+"&nbsp;</span><span style='color:red;'>" + rlcobjidspanvalue + "</span>";
} else if (optflag == 2) { //删除
    optvalue = ""+SystemEnv.getHtmlLabelName(23777,user.getLanguage());
    optdisplayvalue = "<span>&nbsp;"+SystemEnv.getHtmlLabelName(91, user.getLanguage())+"&nbsp;</span><span style='color:red;'>" + objidspanvalue + "</span>";
}
//workflow/transfer/permissionExecute.jsp?gids=1071&optflag=1&objtype=1&objid=91&rlcobjid=90&date=1389691996271
//System.out.println("objtype=" + objtype);
//System.out.println("objidspanvalue=" + objidspanvalue);
//System.out.println("rlcobjidspanvalue=" + rlcobjidspanvalue);        
        
int count = 0;
String countSql = "SELECT count(1) as count from workflow_groupdetail where id in (" + gids + ")";
RecordSet rs = new RecordSet();
rs.executeSql(countSql);
if (rs.next()) {
    count = Util.getIntValue(rs.getString("count"), 0);
}
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
	
function execute() {
	//var targetwfid = <%=gids %>;
	var ajaxUrl = "/workflow/transfer/permissionExecuteOperation.jsp";
	ajaxUrl += "?token=";
	ajaxUrl += new Date().getTime();
	jQuery.ajax({
	    url: ajaxUrl,
	    dataType: "text", 
	    type: "post", 
	    data: {"optflag": <%=optflag %>, "gids": "<%=gids%>", "rlcobjid" : "<%=rlcobjid%>", "objtype" : "<%=objtype%>", "objid" : "<%=objid%>"},
	    contentType : "application/x-www-form-urlencoded; charset=utf-8", 
	    error:function(ajaxrequest){}, 
	    success:function(data, textStatus){
	    	var result = jQuery.trim(data);
	    	jQuery("#zDialog_div_content").html("");
	    	if (!isNaN(result) && parseInt(result) > 0) {
	    		jQuery("#zDialog_div_content").html('<div style="height:20x;">&nbsp;</div><div style="width:100%;text-align:center;font-size:15px;"><%=optvalue %><%=SystemEnv.getHtmlLabelName(84565,user.getLanguage())%><span></div>');	
	    	} else {
	    		jQuery("#zDialog_div_content").html('<div style="height:20x;">&nbsp;</div><div style="width:100%;text-align:center;font-size:15px;"><%=optvalue %><%=SystemEnv.getHtmlLabelName(84566,user.getLanguage())%><span></div>');
	    	}
	    	jQuery("#jmodaloptcontent").html("<input type='button' value='<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>' onclick='cancelOpt(\"wfversionDiv\", 1);' class='zd_btn_cancle'>");
		    jQuery(".zd_btn_cancle").hover(function(){
	            jQuery(this).addClass("zd_btn_cancleHover");
	        },function(){
	            jQuery(this).removeClass("zd_btn_cancleHover");
	        });
	        
	        parentWin.flushData();
	    }  
    });
	jQuery("#zDialog_div_content").html('<div style="height:20x;">&nbsp;</div><div style="width:100%;text-align:center;font-size:15px;"><%=SystemEnv.getHtmlLabelName(84567,user.getLanguage())%><span></div>');
	
	jQuery("#btncancel").attr("disabled", true);
	jQuery("#btnok").attr("disabled", true);
}

function cancelOpt(hideDivId, ref) {
	jQuery("#" + hideDivId).hide();
	if (ref != undefined && ref == 1) {
		//parentWin.location.reload();
	}
	parentWin.closeDialog();
}
	
	</script>
  </head>
  
  <body style="overflow:hidden;margin:0px;">
      <div class="zDialog_div_content" id="zDialog_div_content">
      	  <div style="height:20x;">&nbsp;</div>
          <div style="width:100%;text-align:center;font-size:15px;">
          	<%=optdisplayvalue %>
          </div>
          <div style="height:20x;">&nbsp;</div>
          <div style="width:100%;text-align:center;font-size:15px;">
          	<span><%=SystemEnv.getHtmlLabelName(124955, user.getLanguage())%>：<%=count %><%=SystemEnv.getHtmlLabelName(26302, user.getLanguage())%></span>
          </div>
          <div style="height:20x;">&nbsp;</div>
          <div style="width:100%;text-align:center;font-size:15px;">
          	<span><%=Util.replaceString(SystemEnv.getHtmlLabelName(129415, user.getLanguage()),"${0}",optvalue)%><span>
          </div>
          <div style="height:20x;">&nbsp;</div>
      </div>
      <div id="zDialog_div_bottom" class="zDialog_div_bottom">
          <table width="100%">
		      <tr><td style="text-align:center;" colspan="3" id="jmodaloptcontent">
		          <input type="button" value="<%=SystemEnv.getHtmlLabelName(83446,user.getLanguage())%>" onclick="execute()" class="zd_btn_submit" id="btnok">
		          <input type="button" value="<%=SystemEnv.getHtmlLabelName(32694,user.getLanguage())%>" onclick="cancelOpt('wfversionDiv');" class="zd_btn_cancle" id="btncancel">
		      </td></tr>
		  </table>
	  </div>
  </body>
</html>
