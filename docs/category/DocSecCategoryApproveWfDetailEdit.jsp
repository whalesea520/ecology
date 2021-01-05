
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.docs.category.security.MultiAclManager" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryApproveWfManager" class="weaver.docs.category.SecCategoryApproveWfManager" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<html><head>
<link href="/css/Weaver_wev8.css" type="text/css" rel="stylesheet">
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript >
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
	if("<%=isclose%>"=="1"){
		dialog.close();	
	}
</script>
</head>

<%
    //子目录id
	String id = Util.null2String(request.getParameter("id"));
	String approveType = Util.null2String(request.getParameter("approveType"));
	String approveWfId = Util.null2String(request.getParameter("approveWfId"));
    String approveTypeName="";
	if(approveType.equals("1")){
		approveTypeName=SystemEnv.getHtmlLabelName(19536,user.getLanguage());
	}else if(approveType.equals("2")){
		approveTypeName=SystemEnv.getHtmlLabelName(19537,user.getLanguage());
	}
	String approveWfName=WorkflowComInfo.getWorkflowname(approveWfId);


%>
<%	
	RecordSet.executeProc("Doc_SecCategory_SelectByID",id+"");
	RecordSet.next();

	String subcategoryid=RecordSet.getString("subcategoryid");

//	int mainid = Util.getIntValue(SubCategoryComInfo.getMainCategoryid(subcategoryid),0);


	boolean hasSubManageRight = false;
	boolean hasSecManageRight = false;
	MultiAclManager am = new MultiAclManager();
	int parentId = Util.getIntValue(SecCategoryComInfo.getParentId(""+id));
	if(parentId>0){
		hasSecManageRight = am.hasPermission(parentId, MultiAclManager.CATEGORYTYPE_SEC, user, MultiAclManager.OPERATION_CREATEDIR);
	}
    boolean canEdit = false ;
	if (HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit",user) || hasSecManageRight) {
		canEdit = true ;
	}


%>

<BODY >
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="onSave(this);">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
  //菜单
  if (canEdit){
	  RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_top} " ;
	  RCMenuHeight += RCMenuHeightStep ;
  }
if(!isDialog.equals("1")){
      //RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:location='/docs/category/DocSecCategoryApproveWfEdit.jsp?id="+id+"',_self}";
	      RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:location='/docs/category/DocSecCategoryApproveWfEdit.jsp?id="+id+"',_self}";
	    RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM METHOD="POST" name="frmMain" ACTION="DocSecCategoryApproveWfOperation.jsp">
<INPUT TYPE="hidden" NAME="operation">
<INPUT TYPE="hidden" NAME="id" value="<%=id%>">
<input type="hidden" name="isdialog" value="<%=isDialog%>">
<INPUT TYPE="hidden" NAME="approveType" value="<%=approveType%>">
<INPUT TYPE="hidden" NAME="approveWfId" value="<%=approveWfId%>">

		<wea:layout attributes="{'expandAllGroup':'true'}">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(18436,user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelName(19535,user.getLanguage())%></wea:item>
				<wea:item><%=approveTypeName%></wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(15058,user.getLanguage())%></wea:item>
				<wea:item><%=approveWfName%></wea:item>
			</wea:group>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(19538,user.getLanguage())%>'>
				<wea:item type="groupHead">
					<span class="e8tips" title="<ul style='padding-left:15px;'><li><%=SystemEnv.getHtmlLabelName(20297,user.getLanguage())%></li><li><%=SystemEnv.getHtmlLabelName(20298,user.getLanguage())%></li></ul>">
						<img src="/images/tooltip_wev8.png" align="absMiddle"/>
					</span>
				</wea:item>
				<wea:item attributes="{'isTableList':'true'}">
					<wea:layout type="table" needImportDefaultJsAndCss="false" attributes="{'cols':'2','cws':'30%,*'}">
						<wea:group context="" attributes="{'groupDisplay':'none'}">
							<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(19372,user.getLanguage())%></wea:item>
							<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(19539,user.getLanguage())%></wea:item>
							<%Map data = SecCategoryApproveWfManager.getApproveWfTRList(id,approveType,approveWfId,user.getLanguage(),canEdit);
								if(data!=null){
									List approveWfFieldList = (List)data.get("approveWfFieldList");
									Map approveWfDetailIdMap = (Map)data.get("approveWfDetailIdMap");
									Map docPropertyFieldIdMap = (Map)data.get("docPropertyFieldIdMap");
									Map docPropertyNameMap = (Map)data.get("docPropertyNameMap");
									for(int i=0;i<approveWfFieldList.size();i++){
										Map approveWfFieldMap=(Map)approveWfFieldList.get(i);
										String approveWfFieldId=Util.null2String(approveWfFieldMap.get("approveWfFieldId"));
										String approveWfFieldName=Util.null2String(approveWfFieldMap.get("approveWfFieldName"));
										
										//获得子流程字段对应的子流程设置明细id
										String approveWfDetailId=Util.null2String(approveWfDetailIdMap.get(approveWfFieldId));
										
										//获得流程字段对应的文档属性页字段id
										String docPropertyFieldId=Util.null2String(docPropertyFieldIdMap.get(approveWfFieldId));
										//获得流程字段对应的文档属性页字段名称        	
										String docPropertySpan="";

										if(!docPropertyFieldId.equals("")){
											String docPropertyName=Util.null2String(docPropertyNameMap.get(docPropertyFieldId));
											if(docPropertyName==null){
												docPropertyName="";
											}
											docPropertySpan=docPropertyName;
										}

								%>
									<wea:item>
										<input type='hidden' name='approveWfDetailId' value='<%=approveWfDetailId%>'><%=approveWfFieldName%><input type='hidden' name='approveWfFieldId' value='<%=approveWfFieldId%>'>
									</wea:item>
									<wea:item>
										<%String url = "/systeminfo/BrowserMain.jsp?url=/docs/category/DocSecCategoryDocPropertyBrowser.jsp?seccategory="+id+"&needDocumentCreator=1&needCurrentOperator=1&needDocShare=1";%>
										<brow:browser viewType="0" name="docPropertyFieldId" browserSpanValue='<%=docPropertySpan%>' 
												browserUrl='<%=url %>'
												hasInput="false" isSingle="false" hasBrowser = "true" isMustInput='1'
												completeUrl="/data.jsp" browserValue='<%=docPropertyFieldId %>' linkUrl="#" 
												></brow:browser>
									</wea:item>
								<%}
								}%>
						</wea:group>
					</wea:layout>
				</wea:item>
			</wea:group>
		</wea:layout>
</FORM>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
			    	<%--<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage())%>" id="zd_btn_submit_0" class="zd_btn_submit" onclick="jQuery('#isentrydetail').val('1');checkSubmit();">
			    	<span class="e8_sep_line">|</span>
			    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="jQuery('#isentrydetail').val('<%= isEntryDetail%>');checkSubmit();">
			    	<span class="e8_sep_line">|</span> --%>
			    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
			jQuery(".e8tips").wTooltip({html:true});
		});
	</script>
<%} %>
</BODY>
</HTML>

<SCRIPT LANGUAGE="javascript">

function onSave(obj){
    
	try{
		parent.disableTabBtn();
	}catch(e){}
    document.frmMain.operation.value="editApproveWfDetail";
    document.frmMain.submit();
}
 
function onCancel(){
    

    document.frmMain.operation.value="editApproveWfDetail";
    document.frmMain.submit();
}
function onDocProperty(id,obj){
//id = window.showModalDialog("DocSecCategoryDocPropertyBrowser.jsp?seccategory="&id)
	data = window.showModalDialog("DocSecCategoryDocPropertyBrowser.jsp?seccategory="+id+"&needDocumentCreator=1&needCurrentOperator=1")
//if not IsEmpty(id) then
//	obj.parentElement.children(1).innerHTML = id(1)
//	obj.parentElement.children(2).value=id(0)
//else 
//	obj.parentElement.children(1).innerHTML = empty
//	obj.parentElement.children(2).value=""    
//end if

	if(data){
	    if(wuiUtil.getJsonValueByIndex(data,0)!=0){
		    jQuery(obj).parent().find(":eq(1)").html(wuiUtil.getJsonValueByIndex(data,1));
		    jQuery(obj).parent().find(":eq(2)").val(wuiUtil.getJsonValueByIndex(data,0))
		    //obj.parentElement.children(1).innerHTML = getJsonValueByIndex(data,1)
		    //obj.parentElement.children(2).value=getJsonValueByIndex(data,0)
	    }else{
	    	jQuery(obj).parent().find(":eq(1)").html(wuiUtil.getJsonValueByIndex(data,1));
		    jQuery(obj).parent().find(":eq(2)").val(wuiUtil.getJsonValueByIndex(data,0));
		    //obj.parentElement.children(1).innerHTML = ""
		    //obj.parentElement.children(2).value=""
	    }		  
	}
}
</SCRIPT>
