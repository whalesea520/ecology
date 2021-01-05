<!DOCTYPE html>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@page import="weaver.workflow.workflow.UserWFOperateLevel"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />

<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocMouldComInfo" class="weaver.docs.mould.DocMouldComInfo" scope="page" />		
<jsp:useBean id="wfrm" class="weaver.workflow.workflow.WfRightManager" scope="page" />

<HTML>
<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = "";
    String needfav = "";
    String needhelp = "";
    String isDialog = Util.null2String(request.getParameter("isdialog"));
    int tabIndex = Util.getIntValue(request.getParameter("tabIndex"),1);
%>
    <HEAD>
        <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
        <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
        <script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs6_wev8.css" rel="stylesheet" />
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<style type="text/css">
	.magic-line{
		top:21px!important;
	}
	.noticeinfo{line-height:22px;color: red}
	.noticediv1{margin-top:4px}
</style>
		<script type="text/javascript">
			
			
		</script>
    </HEAD>
<BODY>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="savewftopdf(this)" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:savewftopdf(this),_self}";
    RCMenuHeight += RCMenuHeightStep;        
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
    int workflowId = Util.getIntValue(request.getParameter("wfid"),-1);
    String formID = request.getParameter("formid");
    String isbill = request.getParameter("isbill");
    int topdfnodeid=0;//正文转PDF节点id
    int pdfsavesecid=0;//PDF存放目录id
    String catalogtype2="0";//PDF存放目录类型  
    int selectcatalog2=0;//PDF存放选择目录
	int pdfdocstatus=9;//PDF文档状态
    int pdffieldid=0;//PDF存放字段
    int decryptpdfsavesecid=0;//脱密PDF存放目录id
    String decryptcatalogtype2="0";//脱密PDF存放目录类型  
    int decryptselectcatalog2=0;//脱密PDF存放选择目录
	int decryptpdfdocstatus=9;//脱密PDF文档状态
    int decryptpdffieldid=0;//脱密PDF存放字段
    String sqlSelectCatalog=null;
	int tempFieldId=0;
	String SQLCreateDocument = null;

    int detachable = Util.getIntValue(String.valueOf(session.getAttribute("detachable")), 0);
	int subCompanyID= Util.getIntValue(Util.null2String(session.getAttribute(workflowId+"subcompanyid")),-1);
	boolean haspermission = wfrm.hasPermission3(workflowId, 0, user, WfRightManager.OPERATION_CREATEDIR);
    int operateLevel = UserWFOperateLevel.checkUserWfOperateLevel(detachable,subCompanyID,user,haspermission,"WorkflowManage:All");

    if(operateLevel < 1) {
        response.sendRedirect("/notice/noright.jsp");
        return;
    }
				
				if(formID==null||formID.trim().equals("")){
					formID=WorkflowComInfo.getFormId(""+workflowId);
				}
	 			if(isbill==null||isbill.trim().equals("")){
					isbill=WorkflowComInfo.getIsBill(""+workflowId);
				}
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

        /*================ 编辑信息 ================*/
       
        RecordSet.executeSql("select * from workflow_texttopdfconfig where workflowid="+workflowId);
      	if(RecordSet.next()){
      		topdfnodeid=Util.getIntValue(RecordSet.getString("topdfnodeid"),0);
      		pdfsavesecid=Util.getIntValue(RecordSet.getString("pdfsavesecid"),0);
      		catalogtype2=Util.null2String(RecordSet.getString("catalogtype2"));
      		selectcatalog2=Util.getIntValue(RecordSet.getString("selectcatalog2"),0);
      		pdfdocstatus=Util.getIntValue(RecordSet.getString("pdfdocstatus"),0);
      		pdffieldid=Util.getIntValue(RecordSet.getString("pdffieldid"),0);
      		decryptpdfsavesecid=Util.getIntValue(RecordSet.getString("decryptpdfsavesecid"),0);
      		decryptcatalogtype2=Util.null2String(RecordSet.getString("decryptcatalogtype2"));
      		decryptselectcatalog2=Util.getIntValue(RecordSet.getString("decryptselectcatalog2"),0);
      		decryptpdfdocstatus=Util.getIntValue(RecordSet.getString("decryptpdfdocstatus"),0);
      		decryptpdffieldid=Util.getIntValue(RecordSet.getString("decryptpdffieldid"),0);
      	}
        
			  String docPath = "";
			  String decryptdocPath = "";
			  
			  if(pdfsavesecid>0){
				  docPath = SecCategoryComInfo.getAllParentName(""+pdfsavesecid,true);
			  }
			  if(decryptpdfsavesecid>0){
				  decryptdocPath = SecCategoryComInfo.getAllParentName(""+decryptpdfsavesecid,true);
			  }
    
        /*================ 显示字段查询基SQL ================*/
				String SQL = null;

				if("1".equals(isbill)){
					SQL = "select formField.id,fieldLable.labelName as fieldLable "
		                    + "from HtmlLabelInfo  fieldLable ,workflow_billfield  formField "
		                    + "where fieldLable.indexId=formField.fieldLabel "
		                    + "  and formField.billId= " + formID
		                    + "  and formField.viewType=0 "
		                    + "  and fieldLable.languageid =" + user.getLanguage();
				}else{
					SQL = "select formDict.ID, fieldLable.fieldLable "
		                    + "from workflow_fieldLable fieldLable, workflow_formField formField, workflow_formdict formDict "
		                    + "where fieldLable.formid = formField.formid and fieldLable.fieldid = formField.fieldid and formField.fieldid = formDict.ID and (formField.isdetail<>'1' or formField.isdetail is null) "
		                    + "and formField.formid = " + formID
		                    + " and fieldLable.langurageid = " + user.getLanguage();
				}
%>



<FORM name="formtopdf" method="post" action="TextToPdfOperation.jsp" >

    <div id="wfBaseInfo" class="wfOfficalDoc" style="<%=tabIndex==1?"":"display:none;" %>">
	<wea:layout >
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(19346, user.getLanguage())%></wea:item>
        <wea:item>
		 <SELECT class=inputstyle name="topdfnodeid">
                                              
                                            <%
                                                String sqlUseTempletNode =  " select b.id as nodeId,b.nodeName from workflow_flownode a,workflow_nodebase b where (b.IsFreeNode is null or b.IsFreeNode!='1') and a.nodeId=b.id and b.isend<>1 and  a.workFlowId= "+workflowId+"  order by a.nodeType,a.nodeId";
                                                
                                                RecordSet.executeSql(sqlUseTempletNode);
                                                
                                                while(RecordSet.next())
                                                {
                                                    String tempNodeId = RecordSet.getString("nodeId");
                                            %>
                                                <option value=<%= tempNodeId %> ><%= RecordSet.getString("nodeName") %></option>
                                            <%
                                                }
                                            %>
                                            </select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(19347, user.getLanguage())%></wea:item>
		<wea:item>
		<select  id=operationtype   name=operationtype  style="float: left;">
    <option value=0 ><%=SystemEnv.getHtmlLabelName(126333,user.getLanguage())%></option>
    <option value=1 ><%=SystemEnv.getHtmlLabelName(126334,user.getLanguage())%></option>
    </select>&nbsp;
		
		</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("126326,68", user.getLanguage())%>'>
	    <wea:item><%=SystemEnv.getHtmlLabelName(1025, user.getLanguage())%></wea:item>
		<wea:item>
		<INPUT class=InputStyle type=checkbox checked  value=1 id=checktypea  name="checktypea" onclick="showarea(1)" ><%=SystemEnv.getHtmlLabelNames("126326,21819", user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<INPUT class=InputStyle  type=checkbox  value=1 id=checktypeb  name="checktypeb" onclick="showarea(2)"  ><%=SystemEnv.getHtmlLabelName(126344, user.getLanguage())%> <span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(126352,user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
		</wea:item>

		<wea:item attributes="{'samePair':'1seclevel_td','display':''}"><%=SystemEnv.getHtmlLabelName(126336, user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'1seclevel_td','display':''}">
			<select  id=catalogtype2   name=catalogtype2 onchange="switchCataLogType2(this.value,'#checktype0','#checktype1')" style="float: left;">
    <option value=0 ><%=SystemEnv.getHtmlLabelName(19213,user.getLanguage())%></option>
    <option value=1 ><%=SystemEnv.getHtmlLabelName(19214,user.getLanguage())%></option>
    </select>&nbsp;
<%

	if("1".equals(isbill)){
		sqlSelectCatalog = "select formField.id,fieldLable.labelName as fieldLable "
			                         + "from HtmlLabelInfo  fieldLable ,workflow_billfield  formField "
			                         + "where fieldLable.indexId=formField.fieldLabel "
			                         + "  and formField.billId= " + formID
			                         + "  and formField.viewType=0 "
			                         + "  and fieldLable.languageid =" + user.getLanguage()
						             + "  and formField.fieldHtmlType = '5' and not exists ( select * from workflow_selectitem where (docCategory is null or docCategory = '') and formField.ID = workflow_selectitem.fieldid and isBill='1' and isAccordToSubCom='0' )order by formField.dspOrder";
	}else{
		sqlSelectCatalog = "select formDict.ID, fieldLable.fieldLable "
			                         + "from workflow_fieldLable fieldLable, workflow_formField formField, workflow_formdict formDict "
			                         + "where fieldLable.formid = formField.formid and fieldLable.fieldid = formField.fieldid and formField.fieldid = formDict.ID and (formField.isdetail<>'1' or formField.isdetail is null) "
			                         + "and formField.formid = " + formID
			                         + " and fieldLable.langurageid = " + user.getLanguage()
						             + " and formDict.fieldHtmlType = '5' and not exists ( select * from workflow_selectitem where (docCategory is null or docCategory = '') and formDict.ID = workflow_selectitem.fieldid and isBill='0' and isAccordToSubCom='0') order by formField.fieldorder";
	}
%>
 <span name=checktype1 id=checktype1 style="display:none">
    <select  id=selectcatalog2 name=selectcatalog2 >
	
    <%
	
	RecordSet.executeSql(sqlSelectCatalog);
	while(RecordSet.next()){
		tempFieldId = RecordSet.getInt("ID");
%>
        <option value=<%= tempFieldId %>  ><%= RecordSet.getString("fieldLable") %></option>
    <%

    	}
    %>
    </select>&nbsp;
	</span>
  <span name=checktype0 id=checktype0   >
    <span name=mypath2 id=mypath2 >
	
		
	<brow:browser  name="browser1" viewType="0" hasBrowser="true" hasAdd="false" 
			               browserUrl="#" getBrowserUrlFn="getBrowserUrlFn"  isMustInput="2" isSingle="true" hasInput="true"
			                completeUrl="/data.jsp?type=categoryBrowser" _callback="onShowCatalogData2" width="300px" browserValue="" browserSpanValue="" />	
	</span>
	</span>
		</wea:item>

		<wea:item attributes="{'samePair':'1seclevel_td','display':''}"><%=SystemEnv.getHtmlLabelNames("126337,126338", user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'1seclevel_td','display':''}">
			<SELECT  name="pdffieldid" id="pdffieldid"  onchange="checkSelect1(1)">
                                               <OPTION value=-1 ></OPTION>
                                            <%
									            								if("1".equals(isbill)){
																								SQLCreateDocument = SQL + " and formField.fieldHtmlType = '3' and formField.type = 37 order by formField.dspOrder";
																							}else{
																								SQLCreateDocument = SQL + " and formDict.fieldHtmlType = '3' and formDict.type = 37 order by formField.fieldorder";
																							}
																							RecordSet.executeSql(SQLCreateDocument);
                                              while(RecordSet.next()) {
                                              	String formDictID = RecordSet.getString("ID");
                                            %>
                                                <OPTION value=<%= formDictID %> ><%= RecordSet.getString("fieldLable") %></OPTION>
                                            <%
                                              }
                                            %>
                                            </SELECT><span id="pdffieldidspan"><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>
			<span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(128752,user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
		</wea:item>
		<wea:item attributes="{'samePair':'1seclevel_td','display':''}"><%=SystemEnv.getHtmlLabelNames("126337,19544", user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'1seclevel_td','display':''}">
			<SELECT  name="pdfdocstatus" id="pdfdocstatus">  
			                                    <OPTION value=9 ><%=SystemEnv.getHtmlLabelName(21556,user.getLanguage())%></OPTION>
                                                <OPTION value=0  ><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%></OPTION>
                                                <OPTION value=1 ><%=SystemEnv.getHtmlLabelName(19563,user.getLanguage())%></OPTION>
                                                <OPTION value=3 ><%=SystemEnv.getHtmlLabelName(359,user.getLanguage())%></OPTION>
                                                <OPTION value=5 ><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></OPTION>
                                                <OPTION value=6 ><%=SystemEnv.getHtmlLabelName(19564,user.getLanguage())%></OPTION>
                                                <OPTION value=7 ><%=SystemEnv.getHtmlLabelName(15750,user.getLanguage())%></OPTION>
                                                <OPTION value=8 ><%=SystemEnv.getHtmlLabelName(15358,user.getLanguage())%></OPTION>
												<OPTION value=-1 ></OPTION>
                                               
			</SELECT>
		</wea:item>
		
		<wea:item attributes="{'samePair':'seclevel_td1','display':'none'}"><%=SystemEnv.getHtmlLabelNames("126343,126336", user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'seclevel_td1','display':'none'}">
			<select  id=decryptcatalogtype2   name=decryptcatalogtype2 onchange="switchCataLogType2(this.value,'#decryptchecktype0','#decryptchecktype1')"  style="float: left;">
             <option value=0 ><%=SystemEnv.getHtmlLabelName(19213,user.getLanguage())%></option>
             <option value=1 ><%=SystemEnv.getHtmlLabelName(19214,user.getLanguage())%></option>
          </select>

 <span name=decryptchecktype1 id=decryptchecktype1  style="display:none">
    <select  id=decryptselectcatalog2 name=decryptselectcatalog2>
    <%
	
	RecordSet.executeSql(sqlSelectCatalog);
	while(RecordSet.next()){
		tempFieldId = RecordSet.getInt("ID");
%>
        <option value=<%= tempFieldId %>  ><%= RecordSet.getString("fieldLable") %></option>
    <%

    	}
    %>
    </select>&nbsp;
	</span>
  <span name=decryptchecktype0 id=decryptchecktype0 >
		
    <span name=decryptmypath2 id=decryptmypath2 >
	
	<brow:browser  name="browser2" viewType="0" hasBrowser="true" hasAdd="false" 
			               browserUrl="#" getBrowserUrlFn="getBrowserUrlFn"  isMustInput="2" isSingle="true" hasInput="true"
			                completeUrl="/data.jsp?type=categoryBrowser" _callback="onShowCatalogData2" width="300px" browserValue="" browserSpanValue="" />
	</span>
  </span>
		</wea:item>
		<wea:item attributes="{'samePair':'seclevel_td1','display':'none'}"><%=SystemEnv.getHtmlLabelNames("126343,126337,126338", user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'seclevel_td1','display':'none'}" >

			<SELECT  name="decryptpdffieldid" id="decryptpdffieldid" onchange="checkSelect1(2)" > 
                                              <OPTION value=-1 ></OPTION>
                                            <%
                                              RecordSet.executeSql(SQLCreateDocument);
                                              while(RecordSet.next()) {
                                              	String formDictID = RecordSet.getString("ID");
                                            %>
                                                <OPTION value=<%= formDictID %> ><%= RecordSet.getString("fieldLable") %></OPTION>
                                            <%
                                              }
                                            %>
                                            </SELECT><span id=decryptpdffieldidspan><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>
			<span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(128752,user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
		</wea:item>
		<wea:item attributes="{'samePair':'seclevel_td1','display':'none'}"><%=SystemEnv.getHtmlLabelNames("126343,126337,19544", user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'seclevel_td1','display':'none'}">
			<SELECT  name="decryptpdfdocstatus" id="decryptpdfdocstatus">  
			                                    <OPTION value=9 ><%=SystemEnv.getHtmlLabelName(21556,user.getLanguage())%></OPTION>
                                                <OPTION value=0  ><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%></OPTION>
                                                <OPTION value=1 ><%=SystemEnv.getHtmlLabelName(19563,user.getLanguage())%></OPTION>
                                                <OPTION value=3 ><%=SystemEnv.getHtmlLabelName(359,user.getLanguage())%></OPTION>
                                                <OPTION value=5 ><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></OPTION>
                                                <OPTION value=6 ><%=SystemEnv.getHtmlLabelName(19564,user.getLanguage())%></OPTION>
                                                <OPTION value=7 ><%=SystemEnv.getHtmlLabelName(15750,user.getLanguage())%></OPTION>
                                                <OPTION value=8 ><%=SystemEnv.getHtmlLabelName(15358,user.getLanguage())%></OPTION>
												<OPTION value=-1 ></OPTION>
                                             
			</SELECT>
		</wea:item>
       <wea:item><%=SystemEnv.getHtmlLabelName(126339, user.getLanguage())%></wea:item>
		<wea:item>
		<INPUT class=InputStyle tzCheckbox="true" type=checkbox  value=1 name="filetopdffile" >
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(126340, user.getLanguage())%></wea:item>
		<wea:item>
		<INPUT class=InputStyle tzCheckbox="true" type=checkbox  value=1 name="filetopdf"  onclick="showfiletopdfdec()"> <span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(126347,user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span> <span id=filetopdfdec style="display:none" ><INPUT class=InputStyle type=text  value=5 name="filemaxsize" style="width:50px" ><%=SystemEnv.getHtmlLabelName(126342, user.getLanguage())%></sapn>
		</wea:item>

	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>'>
		<wea:item>
			<p class="noticeinfo noticediv1">1、<%=SystemEnv.getHtmlLabelName(128753,user.getLanguage()) %>。</p>
			<p class="noticeinfo">2、<%=SystemEnv.getHtmlLabelName(128823,user.getLanguage()) %>。</p>
		</wea:item>
	</wea:group>
   </wea:layout>
   </div>
                    <INPUT type=hidden id='method' name='method' value=add>
                    <INPUT type=hidden id='workflowId' name='workflowId' value=<%= request.getParameter("wfid") %>>
                    <INPUT type=hidden id='formID' name='formID' value=<%= formID %>>
                    <INPUT type=hidden id='isbill' name='isbill' value=<%= isbill %>>
                    <INPUT type=hidden id='pdfsavesecid' name='pdfsavesecid' value="">
                    <INPUT type=hidden id='decryptpdfsavesecid' name='decryptpdfsavesecid' value="">    
</FORM>
</BODY>
</HTML>
<script>
function showarea(type){
if(type=='1'){
   if($GetEle("checktypea").checked){  
	   showEle('1seclevel_td');
	}else{
		hideEle('1seclevel_td');
	}

}else if(type=='2'){
   if($GetEle("checktypeb").checked){  
     
	  showEle('seclevel_td1');
	
	}else{
		hideEle('seclevel_td1');
	}

}

}
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
function onShowCatalog2(spanName,inputName) {
	var urls = "/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp";
    var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.URL = urls;
	dialog.callbackfun = function (paramobj, result) {
		if (result) {
	        if (result.tag>0)  {
	           $G(spanName).innerHTML = "<a href='#"+result.id+"'>"+result.path+"</a>";
	           $G(inputName).value=result.id;
	        }else{
	           $G(spanName).innerHTML = "";
	           $G(inputName).value="";
	        }
	    }
	} ;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(125058, user.getLanguage())%>";
	dialog.Width = 550 ;
	dialog.Height = 550 ;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.show();
}

function onShowCatalogData2(event,datas,name,paras){
	var ids = datas.id;

	var idarr= new Array();
	idarr=ids.split(","); 
	if(name=="browser2"){
		if(idarr.length>=3){
			$G("decryptpdfsavesecid").value=idarr[2];	
		}else{
			$G("decryptpdfsavesecid").value=ids;	
		}
	}else if(name=="browser1"){
		if(idarr.length>=3){
			$G("pdfsavesecid").value=idarr[2];	
		}else{
			$G("pdfsavesecid").value=ids;	
		}
	}

}
function checkSelect1(type){
  if(type=="1"){
    var val=$("#pdffieldid option:selected").val();
	if(val=="-1"){
		 jQuery("#pdffieldidspan").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
		 
		 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
		 return false;
	}else{
	   jQuery("#pdffieldidspan").html("");
	    return true;
	}
  }else if(type=="2"){
      var val=$("#decryptpdffieldid option:selected").val();
	if(val=="-1"){
		 jQuery("#decryptpdffieldidspan").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
		 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
		 return false;
	}else{
	   jQuery("#decryptpdffieldidspan").html("");
	    return true;
	}
  
  }

}

function savewftopdf(obj) {
	var checktype="0_0";
     if($GetEle("checktypea").checked&&$GetEle("checktypeb").checked){
	   checktype="1_1";
	 }else if($GetEle("checktypea").checked&&!$GetEle("checktypeb").checked){
	  checktype="1_0";
	 }else if(!$GetEle("checktypea").checked&&$GetEle("checktypeb").checked){
	  checktype="0_1";
	 }else {
	  checktype="0_0";
	 }
  if(!$GetEle("checktypea").checked&&!$GetEle("checktypeb").checked){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(126345,user.getLanguage())%>");
		return;
  }
  if($GetEle("checktypea").checked){
	
	  var val2=$("#catalogtype2 option:selected").val();
	  if(!checkSelect1(1)){
	   return ;
	  }
	  if(val2=="0"){
	  if(!check_form(document.formtopdf,'browser1')) {
       return ;
      }
	  }
  }
  if($GetEle("checktypeb").checked){
	
	   var val2=$("#decryptcatalogtype2 option:selected").val();
	   if(!checkSelect1(2)){
	   return ;
	  }
	  if(val2=="0"){
	  if(!check_form(document.formtopdf,'browser2')) {
       return ;
      }
	  }
  }

    if(!$GetEle("checktypea").checked){

		        $G("pdfsavesecid").value="";
				$G("selectcatalog2").value="";
				$G("catalogtype2").value="";
				$G("pdfdocstatus").value="-1";
				$G("pdffieldid").value="";	
	
	}

	if(!$GetEle("checktypeb").checked){
	            $G("decryptpdfsavesecid").value="";
				$G("decryptselectcatalog2").value="";
				$G("decryptcatalogtype2").value="";
				$G("decryptpdfdocstatus").value="-1";
				$G("decryptpdffieldid").value="";
	}
   if($GetEle("filetopdffile").checked){
	 $G("filetopdffile").value="1";
	}else{
	 $G("filetopdffile").value="0";
	}
	if($GetEle("filetopdf").checked){
	 $G("filetopdf").value="1";
	}else{
	 $G("filetopdf").value="0";
	}

 jQuery("#browser1span").html("");
 jQuery("#browser2span").html("");
   jQuery.ajax({
			url:"TextToPdfOperation.jsp",			
			type:"post",
			beforeSend:function(){
				e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(33113,user.getLanguage())%>",true);
			},
			complete:function(){
				e8showAjaxTips("",false);
			},
			data:{
				method:"add",
				workflowId:<%=workflowId%>,
				topdfnodeid:$G("topdfnodeid").value,
				pdfsavesecid: $G("pdfsavesecid").value,
				selectcatalog2:$G("selectcatalog2").value,
				catalogtype2:$G("catalogtype2").value,
				pdfdocstatus:$G("pdfdocstatus").value,
				pdffieldid:$G("pdffieldid").value,				
				decryptpdfsavesecid: $G("decryptpdfsavesecid").value,
				decryptselectcatalog2:$G("decryptselectcatalog2").value,
				decryptcatalogtype2:$G("decryptcatalogtype2").value,
				decryptpdfdocstatus:$G("decryptpdfdocstatus").value,
				decryptpdffieldid:$G("decryptpdffieldid").value,
				operationtype:$G("operationtype").value,
				filetopdffile:$G("filetopdffile").value,
				filetopdf:$G("filetopdf").value,
				filemaxsize:$G("filemaxsize").value,
				checktype:checktype
				
			
			},
			success:function(data){
				 dialog.close();
		         parentWin._table.reLoad();
				
			}

		   });
  
		  
}

function switchCataLogType2(objval,checktype0,checktype1){
    if(objval == 0){
		jQuery(checktype0).show();
		jQuery(checktype1).hide();
    }else{
		jQuery(checktype0).hide();
		jQuery(checktype1).show();
	
    }
}

	
function getBrowserUrlFn(){

		return "/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp?resourceids=";

}
function showfiletopdfdec(){
  if($GetEle("filetopdf").checked){
  jQuery("#filetopdfdec").show();
  
  }else{
    jQuery("#filetopdfdec").hide();
  }

}


</script>