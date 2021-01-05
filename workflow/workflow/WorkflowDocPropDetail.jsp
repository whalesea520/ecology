<!DOCTYPE html>
<%@page import="weaver.workflow.workflow.WfRightManager"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="ktm" class="weaver.general.KnowledgeTransMethod" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>

<HTML>
<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(19332,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(21569,user.getLanguage()) ;
    String needfav = "";
    String needhelp = "";
    String isclose = Util.null2String(request.getParameter("isclose"));
    String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
    <HEAD>
        <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
        <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
        <script type="text/javascript">
			var dialog = parent.parent.getDialog(parent); 
			if("<%=isclose%>"=="1"){
				dialog.close();
			}
		</script>
    </HEAD>
<BODY>
<div class="zDialog_div_content">

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="saveDocPropDetail(this)" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%

    String ajax=Util.null2String(request.getParameter("ajax"));

        int objId=Util.getIntValue(request.getParameter("objId"),-1);
        String objType=Util.null2String(request.getParameter("objType"));
	    if(objType.equals("")){
		    objType="0";
	    }
%>

<%if(objId==-1){%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%}%>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveDocPropDetail(this),_self}";
    RCMenuHeight += RCMenuHeightStep;      
    
   // RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:cancelDocPropDetail(this),_self}";
   // RCMenuHeight += RCMenuHeightStep;  
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
    int detachable = Util.getIntValue(String.valueOf(session.getAttribute("detachable")), 0);
    int workflowId=Util.getIntValue(request.getParameter("workflowId"),-1);
	WfRightManager wfrm = new WfRightManager();
	boolean haspermission = wfrm.hasPermission3(workflowId, 0, user, WfRightManager.OPERATION_CREATEDIR);
    int subCompanyID = -1;
    int operateLevel = 0;

    if(1 == detachable)
    {  
        if(null == request.getParameter("subCompanyID"))
        {
            subCompanyID=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")), -1);
        }
        else
        {
            subCompanyID=Util.getIntValue(request.getParameter("subCompanyID"),-1);
        }
        if(-1 == subCompanyID)
        {
            subCompanyID = user.getUserSubCompany1();
        }
        
        session.setAttribute("managefield_subCompanyId", String.valueOf(subCompanyID));
        
        operateLevel= checkSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "WorkflowManage:All", subCompanyID);
    }
    else
    {
        if(HrmUserVarify.checkUserRight("WorkflowManage:All", user))
        {
            operateLevel=2;
        }
    }
    
    if(operateLevel<=0 && haspermission){
    	operateLevel = 2;
    }     

    if(operateLevel > 0){
       
        int docPropId=Util.getIntValue(request.getParameter("docPropId"),-1);
        int selectItemId=Util.getIntValue(request.getParameter("selectItemId"),-1);
        int fieldId=Util.getIntValue(request.getParameter("fieldId"),-1);
        String pathCategory = Util.null2String(request.getParameter("pathCategory"));
        int secCategoryId=Util.getIntValue(request.getParameter("secCategoryId"),-1);
		RecordSet.executeSql("select isuser,e8number from DocSecCategory where id="+secCategoryId);
		String isuser = "";
		String number = "";
		if(RecordSet.next()){
			isuser = Util.null2String(RecordSet.getString("isuser"));
			number = Util.null2String(RecordSet.getString("e8number"));
		}
        String formID = request.getParameter("formID");
		if(formID==null||formID.trim().equals("")){
			formID=WorkflowComInfo.getFormId(""+workflowId);
		}

        String isbill = WorkflowComInfo.getIsBill(""+workflowId);
		if(formID==null||formID.trim().equals("")||isbill==null||isbill.trim().equals("")){
			RecordSet.executeSql("select formid,isbill from workflow_base where id="+workflowId);
			if(RecordSet.next()){
				formID = Util.null2String(RecordSet.getString("formid"));
				isbill = Util.null2String(RecordSet.getString("isbill"));
			}
		}

		if(!"1".equals(isbill)){
			isbill="0";
		}

		if(pathCategory.equals("")){
			String innerSecCategory = String.valueOf(secCategoryId);
			//String innerSubCategory = SecCategoryComInfo.getSubCategoryid(innerSecCategory);
			//String innerMainCategory = SubCategoryComInfo.getMainCategoryid(innerSubCategory);

				pathCategory = SecCategoryComInfo.getAllParentName(innerSecCategory,true);
		     //pathCategory = "/" + MainCategoryComInfo.getMainCategoryname(innerMainCategory) + "/" + SubCategoryComInfo.getSubCategoryname(innerSubCategory) + "/" + SecCategoryComInfo.getSecCategoryname(innerSecCategory);     
		}

        if(docPropId<=0){
		    RecordSet.executeSql("select id from  Workflow_DocProp where workflowId="+workflowId+" and selectItemId="+selectItemId+" and secCategoryid="+secCategoryId+" and objId="+objId+" and objType="+objType);
		    if(RecordSet.next()){
			    docPropId=Util.getIntValue(RecordSet.getString("id"),0);
		    }
		}
		
		RecordSet.executeSql("select selectName from workflow_SelectItem where id = " + fieldId);
		
		String selectName = "";
		if(RecordSet.next()){
			selectName = RecordSet.getString(1);
		}
		
        /*================ 下拉框信息 ================*/
        List formDictIDList = new ArrayList();
        List formDictLabelList = new ArrayList();
		String SQL = null;
		if("1".equals(isbill)){
			SQL = "select formField.id,fieldLable.labelName as fieldLable "
                    + "from HtmlLabelInfo  fieldLable ,workflow_billfield  formField "
                    + "where fieldLable.indexId=formField.fieldLabel "
                    + "  and formField.billId= " + formID
                    + "  and formField.viewType=0 "
                    + "  and fieldLable.languageid =" + user.getLanguage()
                    + "  order by formField.dspOrder  asc ";
		}else{			
			SQL = "select formDict.ID, fieldLable.fieldLable "
                    + "from workflow_fieldLable fieldLable, workflow_formField formField, workflow_formdict formDict "
                    + "where fieldLable.formid = formField.formid and fieldLable.fieldid = formField.fieldid and formField.fieldid = formDict.ID and (formField.isdetail<>'1' or formField.isdetail is null) "
                    + "and formField.formid = " + formID
                    + "and fieldLable.langurageid = " + user.getLanguage()
                    + " order by formField.fieldorder";
		}                      
        RecordSet.executeSql(SQL);
        
        while(RecordSet.next()){
            formDictIDList.add(RecordSet.getString("ID"));
            formDictLabelList.add(RecordSet.getString("fieldLable"));
        }  

	int i = 0;              
%>

<FORM name="docPropDetailForm" method="post" action="WorkflowDocPropDetailOperation.jsp" >
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1478,user.getLanguage())%>'>
		<%if(objId<=0){ %>
			<wea:item><%=SystemEnv.getHtmlLabelName(1025,user.getLanguage())%></wea:item>
			<wea:item><%= selectName %></wea:item>
		<%}else{ %>
			<wea:item><%=SystemEnv.getHtmlLabelName(26505,user.getLanguage())%></wea:item>
			<wea:item><%= objType.equals("0")?DepartmentComInfo.getDepartmentName(""+objId):SubCompanyComInfo.getSubCompanyname(""+objId) %></wea:item>
		<%} %>
		<wea:item><%=SystemEnv.getHtmlLabelName(19360,user.getLanguage())%></wea:item>
		<wea:item>
			<%= pathCategory %>
			<%if(isDialog.equals("0")){ %>
				<input type="hidden" name="isuser" value="<%=isuser%>"/>	
				<input type="hidden" name="number" value="<%=number%>"/>
			<%} %>
		</wea:item>
		<%if(!isDialog.equals("0")){ %>
			<wea:item><%=SystemEnv.getHtmlLabelName(26608,user.getLanguage())%></wea:item>
			<% 
				String sql = "select * from DocSecCategoryDocProperty where isCustom = 1 and secCategoryId="+secCategoryId+" and fieldid in (select id from cus_formdict where fieldhtmltype=3 and type=1)";//单人力资源字段
				RecordSet.executeSql(sql);
			%>
			<wea:item>
				<select name="isuser" id="isuser">
					<option value=""></option>
					<%while(RecordSet.next()){ %>
						<option value="<%=RecordSet.getString("id") %>" <%=isuser.equals(RecordSet.getString("id"))?"selected":"" %>><%=ktm.getPropName(RecordSet.getString("id"),""+user.getLanguage(),false) %></option>
					<%} %>
				</select>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(26609,user.getLanguage())%></wea:item>
			<% 
				sql = "select * from DocSecCategoryDocProperty where isCustom = 1 and secCategoryId="+secCategoryId+" and fieldid in (select id from cus_formdict where fieldhtmltype=1 and type=1)";//单行文本字段
				RecordSet.executeSql(sql);
			%>
			<wea:item>
				<select name="number" id="number">
					<option value=""></option>
					<%while(RecordSet.next()){ %>
						<option value="<%=RecordSet.getString("id") %>" <%=number.equals(RecordSet.getString("id"))?"selected":"" %>><%=ktm.getPropName(RecordSet.getString("id"),""+user.getLanguage(),false) %></option>
					<%} %>
				</select>
			</wea:item>
		<%} %>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("33197,30747",user.getLanguage())%>'>
		<wea:item attributes="{'isTableList':'true'}">
			<div id="docPropDetailDiv"></div>
		</wea:item>
	</wea:group>
</wea:layout>
</FORM>

<script type="text/javascript">
jQuery(document).ready(function(){
	initDefaultDocProp();
});
function saveDocPropDetail(obj){
	docPropDetailForm.submit();	
	obj.disabled=true;
}

function cancelDocPropDetail(obj){
	window.location = "/workflow/workflow/CreateDocumentByWorkFlow.jsp?ajax=1&wfid=<%=workflowId%>&formid=<%=formID%>&isbill=<%=isbill%>";
}

function initDefaultDocProp(){
	jQuery.ajax({
		url:"WorkflowDocPropDetailAjax.jsp",
		type:"post",
		dataType:"html",
		data:{
			docPropId:<%=docPropId%>,
			workflowId:<%=workflowId%>,
			selectItemId:<%=selectItemId%>,
			objId:<%=objId%>,
			objType:<%=objType%>,
			secCategoryId:<%=secCategoryId%>,
			ajax:"<%=ajax%>"
		},
		success:function(data){
			jQuery("#docPropDetailDiv").html(data);
			initLayoutForCss();
			beautySelect();
		}
	});
}

</script>
<%
}else{
    response.sendRedirect("/notice/noright.jsp");
    return;
}
%>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
				</wea:item>
			</wea:group>
		</wea:layout>
</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</BODY>
</HTML>
