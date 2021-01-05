<%@page import="weaver.proj.util.PrjWfUtil"%>
<%@page import="weaver.proj.util.PrjWfConfComInfo"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ProjectTransUtil" class="weaver.proj.util.ProjectTransUtil" scope="page" />
<jsp:useBean id="PrjWfConfComInfo" class="weaver.proj.util.PrjWfConfComInfo" scope="page" />
<jsp:useBean id="PrjWfUtil" class="weaver.proj.util.PrjWfUtil" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
String wftype = Util.null2String(request.getParameter("wftype"));
String rightStr="3".equals(wftype)?"projTemplateSetting:Maint":"Prj:WorkflowSetting";
if(!HrmUserVarify.checkUserRight(rightStr,user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String id = Util.null2String(request.getParameter("id"));
String wfid = "";
String formid="";
String formname="";
String prjtype="";
String isopen="1";
boolean isEdit=false;
if(Util.getIntValue(id)>0){
	wfid= PrjWfConfComInfo.getWfid(id);
	formid=WorkflowComInfo.getFormId(wfid);
	formname=ProjectTransUtil.getWorkflowformname(wfid, ""+user.getLanguage()) ;
	prjtype=PrjWfConfComInfo.getPrjtype(id);
	isopen=PrjWfConfComInfo.getIsopen(id);
	isEdit=true;
}else{
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

if(request.getParameter("wfid")!=null&&Util.getIntValue(request.getParameter("wfid"))>0){
	wfid=Util.null2String(request.getParameter("wfid"));
	formid=WorkflowComInfo.getFormId(wfid);
	formname=ProjectTransUtil.getWorkflowformname(wfid, ""+user.getLanguage()) ;
} 
if(request.getParameter("formid")!=null&&Util.getIntValue(request.getParameter("formid"))<0){
	formid=request.getParameter("formid");
	RecordSet.executeSql("select namelabel from workflow_bill where id="+formid);
	if(RecordSet.next()){
		formname=SystemEnv.getHtmlLabelNames(""+RecordSet.getString("namelabel"), user.getLanguage()) ;
	}
}


String titlelabel="1".equals(wftype)?"81937":"2".equals(wftype)?"81938":"3".equals(wftype)?"18374":"";
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));


/*================单文档、多文档、附件上传字段=============*/
String modes = "<select name='isnode' id='isnode' "+("1".equals(wftype)?"notBeauty=true":"")+" onchange='clearLinkOrNode(this)'>"+
	"<option value=2>"+SystemEnv.getHtmlLabelName(18009,user.getLanguage())+"</option>"+
	"<option value=1>"+SystemEnv.getHtmlLabelName(18010,user.getLanguage())+"</option>"+
	"<option value=0>"+SystemEnv.getHtmlLabelNames("15587,15610",user.getLanguage())+"</option>";
String actions ="";
if("2".equals( wftype)){
	actions = "<select name='customervalue' id='customervalue'>";
	while(ProjectStatusComInfo.next()){
		String statusid= ProjectStatusComInfo.getProjectStatusid();
		String statuslabel=ProjectStatusComInfo.getProjectStatusname();
		actions +="<option value="+statusid+">"+SystemEnv.getHtmlLabelName(19561,user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelNames(statuslabel,user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"</option>";
	}
}else if("3".equals(wftype)){
	actions = "<select name='customervalue' id='customervalue'>";
	actions +="<option value='"+0+"'>"+SystemEnv.getHtmlLabelName(19561,user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelNames("220",user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"</option>";
	actions +="<option value='"+2+"'>"+SystemEnv.getHtmlLabelName(19561,user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelNames("2242",user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"</option>";
	actions +="<option value='"+1+"'>"+SystemEnv.getHtmlLabelName(19561,user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelNames("225",user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"</option>";
}


String rejectTriggers = "<span id='rejectTriggerSpan'><input type='checkbox' name='isTriggerReject' id='isTriggerReject' checked value='1'/></span>";
String linkOrNodes = "<span id='descript'></span><span name='objid' class='browser' completeUrl=\\\"javascript:getCompleteUrl('#objid_#rowIndex#')\\\" browserUrl='#' getBrowserUrlFn='getBrowserUrlFn' getBrowserUrlFnParams='#objid_#rowIndex#' isSingle=true linkUrl='#' hasInput=true viewType=0 isMustInput=2></span>";

/*================ 编辑信息 ================*/

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
<SCRIPT language="javascript" src="/cpt/js/validate_wev8.js"></script>
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<style type="text/css">
	select{
		/*width:300px!important;*/
	}
</style>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData("+wftype+"),_top} " ;
RCMenuHeight += RCMenuHeightStep;

%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=weaver action="/proj/conf/prjwfop.jsp" method=post>
<input type="hidden" name="method" value="saveact" />
<input type="hidden" name="wftype" value="<%=wftype %>" />
<input type="hidden" name="id" value="<%=id %>" />

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="submitData(<%=wftype %>);">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<%
if("2".equals(wftype)||"3".equals(wftype)){
	%>
<div id="wfAction"  class="wfOfficalDoc">
	<wea:layout >	
			<wea:group context='<%=SystemEnv.getHtmlLabelName(33407,user.getLanguage())%>'>
			<wea:item type="groupHead">
				<input type="button" class="addbtn" title="<%= SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onclick="groupAction.addRow();"/>
				<input type="button" class="delbtn" title="<%= SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="deleteAction();"/>
			</wea:item>
			<wea:item attributes="{'isTableList':'true','colspan':'full'}">
				<div id="actionList"></div>
				<%  RecordSet.executeSql("select * from prj_prjwfactset where mainid="+id+" order by id ");
					String ajaxDatas = PrjWfUtil.getInitDatas("actionList",user,RecordSet); 
				%>
				<script type="text/javascript">
					var groupAction = null;
					jQuery(document).ready(function(){
						var ajaxDatas = <%=ajaxDatas%>
						var items=[
							{width:"10%",display:"none",colname:"<%=SystemEnv.getHtmlLabelNames("33331",user.getLanguage())%>",itemhtml:"<%="" %>"},
							{width:"15%",colname:"<%=SystemEnv.getHtmlLabelNames("19831",user.getLanguage())%>",itemhtml:"<%=actions%>"},
							{width:"20%",colname:"<%=SystemEnv.getHtmlLabelNames("33408",user.getLanguage())%>",itemhtml:"<%=modes%>"},
							{width:"30%",colname:"<%=SystemEnv.getHtmlLabelNames("33410",user.getLanguage())%>",itemhtml:"<%=linkOrNodes%>"},
							{width:"20%",colname:"<input type='checkbox' onclick='checkAllRejectTrigger(this)'/><%=SystemEnv.getHtmlLabelNames("33409",user.getLanguage())%>",itemhtml:"<%=rejectTriggers%>"}
							];
						var option = {
							basictitle:"",
							optionHeadDisplay:"none",
							colItems:items,
							container:"#actionList",
							toolbarshow:false,
							openindex:true,
							configCheckBox:true,
							usesimpledata:true,
							initdatas:ajaxDatas,
							addrowCallBack:initRejectTriiger,
            				checkBoxItem:{"itemhtml":'<input name="actionChecbox" class="groupselectbox" type="checkbox" >',width:"5%"}
						};
						groupAction=new WeaverEditTable(option);
						jQuery("#actionList").append(groupAction.getContainer());
					});
					function deleteAction(){
						top.Dialog.confirm("<%=SystemEnv.getHtmlLabelNames("15097",user.getLanguage())%>",function(){
							groupAction.deleteRows();
						});
					}
					function getBrowserUrlFn(obj){
						var mode = jQuery(obj).closest("tr").children("td").eq(3).children("select").val();
						if(mode=="1"||mode=="2"){
							return "/systeminfo/BrowserMain.jsp?mouldID=workflow&url=/workflow/workflow/WorkFlowNodeBrowser.jsp?wfid=<%=wfid %>";
						}else{
							return "/systeminfo/BrowserMain.jsp?mouldID=workflow&url=/workflow/workflow/WorkFlowLinkBrowser.jsp?wfid=<%=wfid %>";
						}
					}
					function getCompleteUrl(obj){
						var mode = jQuery(obj).closest("tr").children("td").eq(3).children("select").val();
						//console.log(jQuery(obj).closest("tr").children("td").eq(3).children("select"));
						if(mode=="1"||mode=="2"){
							return "/data.jsp?type=workflowNodeBrowser&wfid=<%=wfid %>";
						}else{
							return "/data.jsp?type=WorkflowNodePortalBrowserMulti&wfid=<%=wfid %>";
						}
					}
					function clearLinkOrNode(obj){
						var e8_os = jQuery(obj).closest("tr").children("td").eq(4).find("div.e8_os");
						var innerOs = jQuery(obj).closest("tr").children("td").eq(4).find("div.e8_innerShow");
						e8_os.find("input[type='hidden']").val("");
						e8_os.find("span.e8_showNameClass").remove();
						innerOs.find("span[name$='spanimg']").html("<img src='/images/BacoError_wev8.gif' align='absmiddle'/>");
						var span = jQuery(obj).closest("tr").children("td").eq(5).children("span");
						if(jQuery(obj).val()=="1"||jQuery(obj).val()=="2"){
							span.show();
						}else{
							span.hide();
						}
					}
					
					function initRejectTriiger($this,tr){
						var checkbox = $this.children("td").eq(5).find("input[type='checkbox']");
						var isnode = $this.children("td").eq(3).find("select").val();
						if(isnode=="0"){
							checkbox.parent().parent().hide();
							return;
						}
						if(checkbox.val()=="1"){
						}else{
							changeCheckboxStatus(checkbox,false);
						}
					}
					
					function checkAllRejectTrigger(obj){
						var trs = jQuery(obj).closest("table").find("tbody").children("tr.contenttr");
						var checked = false;
						if(jQuery(obj).attr("checked")){
							checked = true;
						}
						trs.each(function(){
							var checkbox = jQuery(this).children("td").eq(5).find("input[type='checkbox']");
							changeCheckboxStatus(checkbox,checked);
						});
					}
				</script>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>	
	<%
}else if("1".equals(wftype)){
	String sql11="select t1.*,t2.isTriggerReject from workflowactionset t1 left outer join workflow_addinoperate t2 "+
			" on t2.workflowid=t1.workflowid and ( (t2.isnode=1 and t2.objid=t1.nodeid) or (t2.isnode=0 and t2.objid=t1.nodelinkid ) ) "+
	" where t1.workflowid="+wfid+" and t1.interfaceid='PrjGenerateAction' ";
	String objid_1="";
	String objname_1="";
	String isTriggerReject_1="";
	String isnode_1="";
	String ispreadd_1="";
	RecordSet.executeSql(sql11);
	if(RecordSet.next()){
		int nodeid1= Util.getIntValue( RecordSet.getString("nodeid"),0);
		int nodelinkid1= Util.getIntValue( RecordSet.getString("nodelinkid"),0);
		int ispreoperator1= Util.getIntValue( RecordSet.getString("ispreoperator"),0);
		int isTriggerReject1= Util.getIntValue( RecordSet.getString("isTriggerReject"),0);
		if(nodeid1>0&&nodelinkid1<=0){//节点
			isnode_1="1";
			objid_1=""+nodeid1;
			isTriggerReject_1=""+isTriggerReject1;
			ispreadd_1=""+ispreoperator1;
			if(ispreoperator1==1){
				isnode_1="2";
			}
			objname_1=PrjWfUtil.getNodeOrLinkName(objid_1, isnode_1);
		}else if(nodelinkid1>0&&nodeid1<=0){//出口
			isnode_1="0";
			objid_1=""+nodelinkid1;
			isTriggerReject_1="0";
			ispreadd_1="0";
			objname_1=PrjWfUtil.getNodeOrLinkName(objid_1, isnode_1);
		}

	}
	
	
	%>
<table class="ListStyle" cols=4  border=0 cellspacing=1 style="">
    <COLGROUP>
		<COL width="25%">
		<COL width="25%">
		<COL width="25%">
		<COL width="25%">
          <tr class=header>
            <td nowrap><%=SystemEnv.getHtmlLabelNames("19831",user.getLanguage())%></td>
            <td nowrap><%=SystemEnv.getHtmlLabelNames("33408",user.getLanguage())%></td>
            <td nowrap><%=SystemEnv.getHtmlLabelNames("33410",user.getLanguage())%></td>
            <td nowrap><%=SystemEnv.getHtmlLabelNames("33409",user.getLanguage())%></td>
          </tr>
          <tr class=DataLight>
            <td nowrap><%=SystemEnv.getHtmlLabelNames("83753",user.getLanguage())%></td>
            <td nowrap>
            	<%=modes %>
            	</select>
            </td>
            <td nowrap id="td_browobj">
            	<brow:browser viewType="0" name="objid" width="235px"
				browserValue='<%=objid_1 %>' 
				browserSpanValue='<%=objname_1 %>'
				getBrowserUrlFn="getBrowserUrlFn"
				browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/Maint/ProjectTypeBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
				completeUrl="javascript:getCompleteUrl()"  />
            </td>
            <td nowrap>
            	<input type="checkbox" value="1"  name="isTriggerReject" <%="1".equals( isTriggerReject_1)?"checked":"" %> id="isTriggerReject" />
            </td>
          </tr>
</table>	
<script>
function getBrowserUrlFn(obj){
	var mode = jQuery("select[name=isnode]").val();
	if(mode=="1"||mode=="2"){
		return "/systeminfo/BrowserMain.jsp?mouldID=workflow&url=/workflow/workflow/WorkFlowNodeBrowser.jsp?wfid=<%=wfid %>";
	}else{
		return "/systeminfo/BrowserMain.jsp?mouldID=workflow&url=/workflow/workflow/WorkFlowLinkBrowser.jsp?wfid=<%=wfid %>";
	}
}
function getCompleteUrl(obj){
	var mode = jQuery("select[name=isnode]").val();
	if(mode=="1"||mode=="2"){
		return "/data.jsp?type=workflowNodeBrowser&wfid=<%=wfid %>";
	}else{
		return "/data.jsp?type=WorkflowNodePortalBrowserMulti&wfid=<%=wfid %>";
	}
}
function clearLinkOrNode(obj){
	var e8_os = jQuery("#td_browobj").find("div.e8_os");
	var innerOs = jQuery("#td_browobj").find("div.e8_innerShow");
	e8_os.find("input[type='hidden']").val("");
	e8_os.find("span.e8_showNameClass").remove();
	innerOs.find("span[name$='spanimg']").html("<img src='/images/BacoError_wev8.gif' align='absmiddle'/>");
	var span = jQuery(obj).closest("tr").find("span.jNiceWrapper");
	if(jQuery(obj).val()=="1"||jQuery(obj).val()=="2"){
		span.show();
	}else{
		span.hide();
	}
	
}
$(function(){
	var mode="<%=isnode_1 %>";//2,节点前;1,节点后;0,出口
	jQuery("select[name=isnode]").val(mode);
	if(mode=="0"){
		var span = jQuery("select[name=isnode]").closest("tr").find("span.jNiceWrapper");
		span.hide();
	}
});
</script>	
	<%
}
%>
  



</FORM>
<script language="javascript">
function submitData(type)
{
	
	if(type==2||type==3){
		var dtinfo= groupAction.getTableSeriaData();	
		var dtjson= groupAction.getTableJson();
   		var jsonstr= JSON.stringify(dtjson);
   		//console.log("dtinfo:"+jsonstr);
   		var dtmustidx=[1];
   		if(checkdtismust(dtjson,dtmustidx)==false){//明细必填验证
   			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage()) %>");
   			return;
   		}
   		var form=jQuery("#weaver");
   		var form_url=form.attr("action");
   		var keepidval="";
   		$("input[type=checkbox][name^=actionChecbox]").each(function(){
   			keepidval+=$(this).val()+",";
   		});
   		jQuery.ajax({
   			url : form_url,
   			type : "post",
   			async : true,
   			data : {"method":"saveact","mainid":"<%=id %>","wftype":"<%=wftype %>","prjtype":'<%=prjtype %>',"wfid":"<%=wfid %>","dtinfo":jsonstr,"keepgroupids":keepidval},
   			dataType : "json",
   			contentType: "application/x-www-form-urlencoded; charset=utf-8", 
   			success: function do4Success(data){
   				if(!data.errmsg){
   					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83551",user.getLanguage())%>");
   				}
   			}
   		});
	}else if(type==1){
		if (check_form(weaver,"objid")){
			var form=jQuery("#weaver");
			var form_data=form.serialize();
			var form_url=form.attr("action");
			var objid=jQuery("#objid").val();
			var isnode=$("#isnode").val();
			var isTriggerReject="";
			if(	$("#isTriggerReject").attr("checked")){
				isTriggerReject="1";
			}
			jQuery.ajax({
				url : form_url,
				type : "post",
				async : true,
				data : {"method":"saveact","wftype":"<%=wftype %>","prjtype":'<%=prjtype %>',"wfid":"<%=wfid %>","objid":objid,"isnode":isnode,"isTriggerReject":isTriggerReject},
				dataType : "json",
				contentType: "application/x-www-form-urlencoded; charset=utf-8", 
				success: function do4Success(data){
					if(!data.errmsg){
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83551",user.getLanguage())%>");
					}
					
				}
			});
		}
	}
	
	
}
</script>
</BODY>
</HTML>
