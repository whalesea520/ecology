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
String rightStr="Cpt:CusWfConfig";
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
	String wftype = "";
boolean isEdit=false;
if(Util.getIntValue(id)>0){
	RecordSet.executeSql("select * from uf4mode_cptwfconf where id="+id);
	if(RecordSet.next()){
		wfid = RecordSet.getString("wfid");
		wftype = RecordSet.getString("wftype");
		isopen = RecordSet.getString("isopen");
		isEdit = true;
	}
}else{
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}



String titlelabel="";
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));


/*================单文档、多文档、附件上传字段=============*/
String modes = "<select name='isnode' id='isnode' "+("1".equals(wftype)?"notBeauty=true":"")+" onchange='clearLinkOrNode(this)'>"+
	"<option value=2>"+SystemEnv.getHtmlLabelName(18009,user.getLanguage())+"</option>"+
	"<option value=1>"+SystemEnv.getHtmlLabelName(18010,user.getLanguage())+"</option>"+
	"<option value=0>"+SystemEnv.getHtmlLabelNames("15587,15610",user.getLanguage())+"</option>";
	String actions ="<select name='customervalue' id='customervalue'>";
	String actionLabel="";
	if("apply".equals(wftype)){
		actionLabel="125353";
	}else if("fetch".equals(wftype)){
		actionLabel="886";
	}else if("move".equals(wftype)){
		actionLabel="883";
	}else if("lend".equals(wftype)){
		actionLabel="6051";
	}else if("loss".equals(wftype)){
		actionLabel="6054";
	}else if("back".equals(wftype)){
		actionLabel="15305";
	}else if("discard".equals(wftype)){
		actionLabel="6052";
	}else if("mend".equals(wftype)){
		actionLabel="22459";
	}
	actions +="<option value='"+1+"'>"+SystemEnv.getHtmlLabelNames(actionLabel, user.getLanguage())+"</option>";
	if (!"apply".equalsIgnoreCase(wftype)) {
		actions +="<option value='"+2+"'>"+SystemEnv.getHtmlLabelNames("125354", user.getLanguage())+"</option>";
		actions +="<option value='"+3+"'>"+SystemEnv.getHtmlLabelNames("125355", user.getLanguage())+"</option>";
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_top} " ;
RCMenuHeight += RCMenuHeightStep;

%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=weaver action="/formmode/cuspage/cpt/conf/cptwfop2.jsp" method=post>
<input type="hidden" name="method" value="saveact" />
<input type="hidden" name="wftype" value="<%=wftype %>" />
<input type="hidden" name="id" value="<%=id %>" />

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

<div id="wfAction"  class="wfOfficalDoc">
	<wea:layout >	
			<wea:group context='<%=SystemEnv.getHtmlLabelName(33407,user.getLanguage())%>'>
			<wea:item type="groupHead">
				<input type="button" class="addbtn" title="<%= SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onclick="groupAction.addRow();"/>
				<input type="button" class="delbtn" title="<%= SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="deleteAction();"/>
			</wea:item>
			<wea:item attributes="{'isTableList':'true','colspan':'full'}">
				<div id="actionList"></div>
				<%  RecordSet.executeSql("select * from uf4mode_cptwfactset where mainid="+id+" order by id ");
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


</FORM>
<script language="javascript">
function submitData()
{
	var type="<%=wftype %>";
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
		data : {"method":"saveact","mainid":"<%=id %>","wftype":"<%=wftype %>","wfid":"<%=wfid %>","dtinfo":jsonstr,"keepgroupids":keepidval},
		dataType : "json",
		contentType: "application/x-www-form-urlencoded; charset=utf-8",
		success: function do4Success(data){
			if(!data.errmsg){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83551",user.getLanguage())%>");
			}
		}
	});

	
}
</script>
</BODY>
</HTML>
