<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="workTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="session"/>
<%
String titlename = SystemEnv.getHtmlLabelName(21740,user.getLanguage());

String selectedids = Util.null2String(request.getParameter("selectedids"));
String groupid = Util.null2String(request.getParameter("groupid"));
String isbill = Util.null2String(request.getParameter("isbill"));
String formid = Util.null2String(request.getParameter("formid"));
String backfields = "";
String sqlfrom = "";
String sqlwhere = "";
String sqlorderby = "";

if(isbill.equals("0")){
	if(groupid.equals("0")){
		backfields += " wfdd.id as id , wfl.fieldlable as name, 0 viewtype,0 groupid,wfdd.type ";
		sqlfrom += " workflow_formdict wfdd,workflow_formfield wff,workflow_fieldlable wfl ";
		sqlwhere += " wfl.isdefault=1 and wfl.formid = wff.formid  " +
					" and wfl.fieldid = wff.fieldid " +
					" and wff.fieldid= wfdd.id and wfdd.fieldhtmltype=3 " +
					" and (wfdd.type = 4 or wfdd.type=57 or wfdd.type = 167 or wfdd.type=168 or wfdd.type = 164 or wfdd.type=194 or wfdd.type = 169 or wfdd.type=170) " +
					" and (wff.isdetail<>'1' or wff.isdetail is null) " +
					" and wff.formid=" + formid ;
		sqlorderby = " viewtype,groupid ";
	}else{
		backfields += " wfdd.id AS id,wfl.fieldlable AS name,1 viewtype,wff.groupId + 1,wfdd.type ";
		sqlfrom += " workflow_formdictdetail wfdd,workflow_formfield wff,workflow_fieldlable wfl ";
		sqlwhere += " wfl.isdefault = 1 and wfl.formid = wff.formid " +
					" and wfl.fieldid = wff.fieldid and wff.fieldid = wfdd.id " + 
					" and wfdd.fieldhtmltype = 3 and (wfdd.type = 4 OR wfdd.type = 57 OR wfdd.type = 167 OR wfdd.type = 168 OR wfdd.type = 164 OR wfdd.type = 194 OR wfdd.type = 169 OR wfdd.type = 170) " +
					" and wff.isdetail = '1' and wff.formid = " + formid + " and wff.groupId = " + (Integer.parseInt(groupid)-1);
		sqlorderby = " viewtype,groupid ";
	}
}else{
	if(groupid.equals("0")){
		backfields += " wfdd.id as id , fieldlabel as name,0 viewtype,0 groupid,type ";
		sqlfrom += " workflow_billfield wfdd ";
		sqlwhere += " billid="+ formid +
					" and fieldhtmltype = '3' and (type=4 or type=57 or type=167 or type=168 or type=164 or type=194 or type=169 or type=170) and viewtype = 0 ";
		sqlorderby = " viewtype,groupid ";
	}else{
		backfields += " wfdd.id as id, fieldlabel as name,1 viewtype,b.orderid groupid,type ";
		sqlfrom += " workflow_billfield wfdd,Workflow_billdetailtable b ";
		sqlwhere += " wfdd.billid = b.billid and wfdd.detailtable = b.tablename " +
					" and fieldhtmltype = '3' and (type=4 or type=57 or type=167 or type=168 or type=164 or type=194 or type=169 or type=170) and viewtype = 1 " +
					" and wfdd.billid=" + formid + " and b.orderid = " + groupid;
		sqlorderby = " viewtype,groupid ";
	}
}

%>
<html>
<head>	
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
jQuery(document).ready(function () {
  	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
  	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
  	$("#tabDiv").remove();		
 });
  
function onBtnSearchClick(){
	var workflowname = jQuery("input[name='workflowname1']").val();
	jQuery("input[name='workflowname']").val(workflowname);
	document.SearchForm.submit();
}
	
var parentWin = null;
var dialog = null;
try{
	parentWin = parent.parent.getParentWindow(parent.window);
	dialog =parent.parent.getDialog(parent.window);
}catch(e){}

function onClose(){
	dialog.close();
}

function afterDoWhenLoaded(){
	//hideTH();
	jQuery(".ListStyle").children("tbody").find("tr[class!='Spacing']").bind("click",function(){
		var returnjson = {
			id:$($(this).children()[4]).text(),
			fieldName:$($(this).children()[1]).text(),
		};
		if(dialog){
		    dialog.callback(returnjson);
		}else{  
		    window.parent.returnValue  = returnjson;
		    window.parent.close();
		}
	});

}

</script>
</head>
<body>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div class="zDialog_div_content" style="height: 100%!important;">
<FORM id="SearchForm" name="SearchForm" action="wfSubProcessListTab.jsp" method="post">
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_WORKFLOW_FORMFIELD%>"/>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>	

</FORM>

<%

//String sqlWhere = "";
String tableString = "";

tableString =   " <table tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_FORMFIELD,user.getUID())+"\" >"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+sqlfrom+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\""+sqlorderby+"\"  sqlprimarykey=\"wfdd.id\" sqlsortway=\"ASC\" sqlisdistinct=\"false\" />"+
                "       <head>"+
                " 			<col width=\"35%\"  text=\""+SystemEnv.getHtmlLabelName(685,user.getLanguage())+"\" column=\"name\" orderkey=\"name\" otherpara=\""+isbill+"+"+user.getLanguage()+"\" transmethod=\"weaver.workflow.workflow.WorkFlowUtil.getWorkflowFieldName\" />"+
                " 			<col width=\"35%\"  text=\""+SystemEnv.getHtmlLabelName(686,user.getLanguage())+"\" column=\"type\" orderkey=\"type\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.workflow.workflow.WorkFlowUtil.getWorkflowFieldType\" />"+
                " 			<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(17997,user.getLanguage())+"\" column=\"groupid\" orderkey=\"groupid\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.workflow.workflow.WorkFlowUtil.getWorkflowFieldPosition\" />"+
                " 			<col width=\"0%\"  hide=\"true\"  text=\"\" column=\"id\"/>"+
                "       </head>"+
                "		<operates>"+
                //otherpara=\"column:subworkflowid+column:typename\"
				"		</operates>"+  
                " </table>";

%>
<TABLE width="100%" cellspacing=0>
    <tr>
        <td valign="top">  
            <wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" />
        </td>
    </tr>
</TABLE>

</div>

</body>
</html>