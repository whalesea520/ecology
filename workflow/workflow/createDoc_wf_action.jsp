<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page import="org.apache.commons.lang.StringUtils"%>

<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WeaverEditTableUtil" class="weaver.docs.util.WeaverEditTableUtil" scope="page" />

<%
User user = HrmUserVarify.getUser(request,response);

int workflowId = Util.getIntValue(request.getParameter("workflowId"),-1);
String formID = StringUtils.trimToEmpty(request.getParameter("formId"));
String isbill = StringUtils.trimToEmpty(request.getParameter("isBill"));
int tabIndex = Util.getIntValue(request.getParameter("tabIndex"),1);

String fieldSql = "";
if("1".equals(isbill)){
    fieldSql = "select distinct t.id,t2.labelname from workflow_billfield t, HtmlLabelInfo t2 where billid = "+formID+" and ((type in (9,37) and fieldhtmltype=3) or fieldhtmltype=6) and t.fieldlabel = t2.indexid and t2.languageid="+user.getLanguage();
}else{
    fieldSql = "select fieldid,fieldlable from workflow_fieldlable t where formid= "+formID+" and langurageid="+user.getLanguage()+" and fieldid in (select id from workflow_formdict where ((type in (9,37) and fieldhtmltype=3) or fieldhtmltype=6))";
}
RecordSet.executeSql(fieldSql);
if(RecordSet.next()){
    RecordSet.beforFirst();
}else{
    if("1".equals(isbill)){
        fieldSql = "select distinct t.id,t2.labelname from workflow_billfield t, HtmlLabelInfo t2 where billid = "+formID+" and ((type in (9,37) and fieldhtmltype=3) or fieldhtmltype=6) and t.fieldlabel = t2.indexid and t2.languageid=7";
    }else{
        fieldSql = "select fieldid,fieldlable from workflow_fieldlable t where formid= "+formID+" and languageid=7 and fieldid in (select id from workflow_formdict where ((type in (9,37) and fieldhtmltype=3) or fieldhtmltype=6))";
    }
    RecordSet.executeSql(fieldSql);
}
String fields = "<select name='fieldid' id='fieldid'>";
while(RecordSet.next()){
    fields += "<option value='"+RecordSet.getString(1)+"'>"+RecordSet.getString(2)+"</option>";
}
fields += "</select>";
String modes = "<select name='isnode' id='isnode' onchange='clearLinkOrNode(this)'>"+
    "<option value='1'>"+SystemEnv.getHtmlLabelName(18010,user.getLanguage())+"</option>"+
    "<option value='0'>"+SystemEnv.getHtmlLabelNames("15587,15610",user.getLanguage())+"</option>" + 
    "</select>";
String actions = "<select name='customervalue' id='customervalue'>"+
    "<option value=0>"+SystemEnv.getHtmlLabelName(19561,user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelName(220,user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"</option>"+
    "<option value=2>"+SystemEnv.getHtmlLabelName(19561,user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelName(19563,user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"</option>"+
    "<option value=3>"+SystemEnv.getHtmlLabelName(19561,user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelName(359,user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"</option>"+
    "<option value=5>"+SystemEnv.getHtmlLabelName(19561,user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelName(251,user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"</option>"+
    "<option value=6>"+SystemEnv.getHtmlLabelName(19561,user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelName(19564,user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"</option>"+
    "<option value=7>"+SystemEnv.getHtmlLabelName(19561,user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelName(15750,user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"</option>"+
    "<option value=8>"+SystemEnv.getHtmlLabelName(19561,user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelName(15358,user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"</option>" + 
    "</select>";
String rejectTriggers = "<span id='rejectTriggerSpan'><input type='checkbox' name='isTriggerReject' id='isTriggerReject' checked value='1'/></span>";
String linkOrNodes = "<span id='descript'></span><span name='objid' class='browser' completeUrl='javascript:getCompleteUrl(objid_#rowIndex#)' browserUrl='#' getBrowserUrlFn='getBrowserUrlFn' getBrowserUrlFnParams='#objid_#rowIndex#' isSingle=true linkUrl='#' hasInput=true viewType=0 isMustInput=2></span>";


RecordSet.executeSql("select * from workflow_addinoperate where workflowid="+workflowId+" and type=1");
String ajaxDatas = WeaverEditTableUtil.getInitDatas("actionList",user,RecordSet); 
%>

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<link type="text/css" href="/js/tabs/css/e8tabs6_wev8.css" rel="stylesheet" />
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<script language="javascript" src="/js/ecology8/request/e8.browser_wev8.js"></script>
<style type="text/css">
    .magic-line{
        top:21px!important;
    }
</style>

<script type="text/javascript">
    var wfJavaParamsObj_action = {
        workflowId : "<%=workflowId %>",
        formId : "<%=formID %>",
        isBill : "<%=isbill %>",
        tabIndex : "<%=tabIndex %>",
        fields : "<%=fields %>",
        actions : "<%=actions %>",
        modes : "<%=modes %>",
        linkOrNodes : "<%=linkOrNodes %>",
        rejectTriggers : "<%=rejectTriggers %>",
        msg_33331 : "<%=SystemEnv.getHtmlLabelName(33331, user.getLanguage()) %>",
        msg_19831 : "<%=SystemEnv.getHtmlLabelName(19831, user.getLanguage()) %>",
        msg_33408 : "<%=SystemEnv.getHtmlLabelName(33408, user.getLanguage()) %>",
        msg_33409 : "<%=SystemEnv.getHtmlLabelName(33409, user.getLanguage()) %>",
        msg_15097 : "<%=SystemEnv.getHtmlLabelName(15097, user.getLanguage()) %>",
        msg_33410 : "<%=SystemEnv.getHtmlLabelName(33410, user.getLanguage()) %>"
    };

    var groupAction = null;
    jQuery(document).ready(function(){
        var ajaxDatas = <%=ajaxDatas%>
        var items=[
            {width:"10%",colname:wfJavaParamsObj_action.msg_33331,itemhtml:wfJavaParamsObj_action.fields},
            {width:"15%",colname:wfJavaParamsObj_action.msg_19831,itemhtml:wfJavaParamsObj_action.actions},
            {width:"20%",colname:wfJavaParamsObj_action.msg_33408,itemhtml:wfJavaParamsObj_action.modes},
            {width:"30%",colname:wfJavaParamsObj_action.msg_33410,itemhtml:wfJavaParamsObj_action.linkOrNodes},
            {width:"20%",colname:"<input type='checkbox' onclick='checkAllRejectTrigger(this)'/>"+wfJavaParamsObj_action.msg_33409,itemhtml:wfJavaParamsObj_action.rejectTriggers}
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
            checkBoxItem:{"itemhtml":'<input name="actionChecbox" class="groupselectbox" type="checkbox" value=-1>',width:"5%"}
        };
        groupAction=new WeaverEditTable(option);
        jQuery("#actionList").append(groupAction.getContainer());
    });
    function deleteAction(){
        //top.Dialog.confirm(wfJavaParamsObj_action.msg_15097,function(){
            groupAction.deleteRows();
        //});
    }
    function getBrowserUrlFn(obj){
        var mode = jQuery(obj).closest("tr").children("td").eq(3).children("select").val();
        if(mode=="1"){
            return "/systeminfo/BrowserMain.jsp?mouldID=workflow&url=/workflow/workflow/WorkFlowNodeBrowser.jsp?wfid="+wfJavaParamsObj.workflowId;
        }else{
            return "/systeminfo/BrowserMain.jsp?mouldID=workflow&url=/workflow/workflow/WorkFlowLinkBrowser.jsp?wfid="+wfJavaParamsObj.workflowId;
        }
    }
    function getCompleteUrl(obj){
        var mode = jQuery(obj).closest("tr").children("td").eq(3).children("select").val();
        if(mode=="1"){
            return "/data.jsp?type=workflowNodeBrowser&wfid="+wfJavaParamsObj.workflowId;
        }else{
            return "/data.jsp?type=WorkflowNodePortalBrowserMulti&wfid="+wfJavaParamsObj.workflowId;
        }
    }
    function clearLinkOrNode(obj){
        var e8_os = jQuery(obj).closest("tr").children("td").eq(4).find("div.e8_os");
        var innerOs = jQuery(obj).closest("tr").children("td").eq(4).find("div.e8_innerShow");
        e8_os.find("input[type='hidden']").val("");
        e8_os.find("span.e8_showNameClass").remove();
        innerOs.find("span[name$='spanimg']").html("<img src='/images/BacoError_wev8.gif' align='absmiddle'/>");
        var span = jQuery(obj).closest("tr").children("td").eq(5).children("span");
        if(jQuery(obj).val()=="1"){
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

<div id="wfAction"  style="<%=tabIndex==8?"":"display:none;" %>" class="wfOfficalDoc">
    <wea:layout needImportDefaultJsAndCss="false">	
            <wea:group context='<%=SystemEnv.getHtmlLabelName(33407,user.getLanguage()) %>'>
            <wea:item type="groupHead">
                <input type="button" class="addbtn" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) %>" onclick="groupAction.addRow();"/>
                <input type="button" class="delbtn" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>" onclick="deleteAction();"/>
            </wea:item>
            <wea:item attributes="{'isTableList':'true','colspan':'full'}">
                <div id="actionList"></div>
            </wea:item>
        </wea:group>
    </wea:layout>
</div>