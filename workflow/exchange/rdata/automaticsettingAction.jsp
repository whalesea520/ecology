<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.exchange.rdata.RDataUtil"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.interfaces.datasource.DataSource"%>
<%@ page import="weaver.general.StaticObj"%>
<%@ page import="weaver.workflow.exchange.ExchangeUtil"%>

<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="GetFormDetailInfo" class="weaver.workflow.automatic.GetFormDetailInfo" scope="page" />
<jsp:useBean id="RDataUtil" class="weaver.workflow.exchange.rdata.RDataUtil" scope="page" />
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("WFEC:SETTING", user))
{
    response.sendRedirect("/notice/noright.jsp");       
    return;
}
boolean isUseWfManageDetach = manageDetachComInfo.isUseWfManageDetach();
int tempsubcomid = -1 ;
if(isUseWfManageDetach){
    RecordSet.executeSql("select wfdftsubcomid from SystemSet");
    RecordSet.next();
    tempsubcomid = Util.getIntValue(RecordSet.getString(1),0);
}
int detachable = Util.getIntValue(request.getParameter("detachable"),0);
int operatelevel = -1  ;
if(isUseWfManageDetach){
    detachable = 1 ;
}
if(detachable==1){
    int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"),0);
    if(request.getParameter("subcompanyid")==null){
        subcompanyid=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")),0);
    }
    if(subcompanyid == -1){
        subcompanyid = user.getUserSubCompany1();
    }
    operatelevel = CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),ExchangeUtil.WFEC_SETTING_RIGHTSTR,subcompanyid);
    if(operatelevel < 0 ){
        response.sendRedirect("/notice/noright.jsp");       
        return;
    }
}
%>
<%
String setname = "";
String workflowid = "";
String datasourceid = "";
String workflowname = "";
String outermaintable = "";
String keyfield = "";
String datarecordtype = "";
String datarecordtable = "";
String requestid = "";
String FTriggerFlag = "";
String FTriggerFlagValue = "";
String outermainwhere = "";
String successback = "";
String failback = "";
String outerdetailtables = "";
String outerdetailwheres = "";
ArrayList outerdetailtablesArr = new ArrayList();
ArrayList outerdetailwheresArr = new ArrayList();
String typename = Util.null2String(request.getParameter("typename"));
String viewid = Util.null2String(request.getParameter("viewid"));
String formid = "";
String isbill = "";
RecordSet.executeSql("select * from wfec_outdatawfset where id="+viewid);
if(RecordSet.next()){
    setname = Util.null2String(RecordSet.getString("setname"));
    workflowid = Util.null2String(RecordSet.getString("workflowid"));
    datasourceid = Util.null2String(RecordSet.getString("datasourceid"));
    formid = WorkflowComInfo.getFormId(workflowid);
    isbill = WorkflowComInfo.getIsBill(workflowid);
    workflowname = Util.null2String(WorkflowComInfo.getWorkflowname(workflowid));
    outermaintable = Util.null2String(RecordSet.getString("outermaintable"));
    keyfield = Util.null2String(RecordSet.getString("keyfield"));
    datarecordtype = Util.null2String(RecordSet.getString("datarecordtype"));
    datarecordtable = Util.null2String(RecordSet.getString("datarecordtable"));
    requestid = Util.null2String(RecordSet.getString("requestid"));
    FTriggerFlag = Util.null2String(RecordSet.getString("FTriggerFlag"));
    FTriggerFlagValue = Util.null2String(RecordSet.getString("FTriggerFlagValue"));
    outermainwhere = Util.null2String(RecordSet.getString("outermainwhere"));
    successback = Util.null2String(RecordSet.getString("successback"));
    failback = Util.null2String(RecordSet.getString("failback"));
    outerdetailtables = Util.null2String(RecordSet.getString("outerdetailtables"));
    outerdetailwheres = Util.null2String(RecordSet.getString("outerdetailwheres"));
    outerdetailtablesArr = Util.TokenizerString(outerdetailtables,",");
    outerdetailwheresArr = Util.TokenizerString(outerdetailwheres,",");
    if("".equals(keyfield))
        keyfield = "id";
}
if("".equals(datarecordtype)){
    datarecordtype = "1";
}

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(33085, user.getLanguage());
String needfav ="1";
String needhelp ="";

String fieldSql = "";

String modes = "<select name='isnode' id='isnode' onchange='clearLinkOrNode(this)'>"+
    "<option value=1>"+SystemEnv.getHtmlLabelName(18010,user.getLanguage())+"</option>"+
    "<option value=0>"+SystemEnv.getHtmlLabelNames("15587,15610",user.getLanguage())+"</option>";
String actions = "<select name='customervalue' id='customervalue'>"+
    "<option value='ExchangeApprovalAgree'>"+SystemEnv.getHtmlLabelName(129039, user.getLanguage())+"</option>"+
    "<option value='ExchangeApprovalDisagree'>"+SystemEnv.getHtmlLabelName(129040, user.getLanguage())+"</option>";

String linkOrNodes = "<span id='descript'></span><span name='objid' class='browser' completeUrl='javascript:getCompleteUrl(objid_#rowIndex#)' browserUrl='#' getBrowserUrlFn='getBrowserUrlFn' getBrowserUrlFnParams='#objid_#rowIndex#' isSingle=true linkUrl='#' hasInput=true viewType=0 isMustInput=2></span>";


%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
    <tr>
        <td></td>
        <td class="rightSearchSpan" style="text-align:right; width:500px!important">
            <input type="button" id="doSubmit" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="doSubmit()"/>
            <span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
        </td>
    </tr>
</table>
<form name="frmmain" method="post" action="automaticOperation.jsp">
<input type="hidden" id="operate" name="operate" value="saveActionList" />
<input type="hidden" id="wfid" name="wfid" value="<%=workflowid %>" />
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'>
</div>
<wea:layout>    
            <wea:group context='<%=SystemEnv.getHtmlLabelName(33407,user.getLanguage())%>'>
            <wea:item type="groupHead">
                <input type="button" class="addbtn" title="<%= SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onclick="groupAction.addRow();"/>
                <input type="button" class="delbtn" title="<%= SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="deleteAction();"/>
            </wea:item>
            <wea:item attributes="{'isTableList':'true','colspan':'full'}">
                <div id="actionList"></div>
                <%  
                    int initrows = 0 ;
                    RecordSet.executeSql("select * from workflowactionset where workflowid="+workflowid+" and interfacetype=3 and interfaceid in ('ExchangeApprovalAgree','ExchangeApprovalDisagree')");//3:Action接口
                    initrows = RecordSet.getCounts() ;
                    String ajaxDatas = RDataUtil.getIntDatas("actionList",user,RecordSet); 
                %>
                <input type="hidden" id="rowNum" name="rowNum" value="0" />
                <input type="hidden" id="actiondeleterows" name="actiondeleterows" />
                <input type="hidden" id="allrows" name="allrows" value="<%=initrows %>"/>
                <input type="hidden" id="addrows" name="addrows" value="0"/>
                
                <script type="text/javascript">
                    var groupAction = null;
                    jQuery(document).ready(function(){
                        var ajaxDatas = <%=ajaxDatas%>
                        var itemhtml = "<input class=\"inputstyle\" tzCheckbox=\"true\" type=checkbox id=\"isused\" name=\"isused\" value=\"1\" />";
                        var items=[
                            {width:"10%",display:"",colname:"<%=SystemEnv.getHtmlLabelNames("19831",user.getLanguage())%>",itemhtml:"<%=actions%>"},
                            {width:"20%",colname:"<%=SystemEnv.getHtmlLabelNames("33408",user.getLanguage())%>",itemhtml:"<%=modes%>"},
                            {width:"40%",colname:"<%=SystemEnv.getHtmlLabelNames("33410",user.getLanguage())%>",itemhtml:"<%=linkOrNodes%>"},
                            {width:"20%",colname:"<%=SystemEnv.getHtmlLabelNames("18624",user.getLanguage())%>",itemhtml:itemhtml}
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
                            addrowCallBack:addrowcallback,
                            checkBoxItem:{"itemhtml":'<input name="actionChecbox" class="groupselectbox" type="checkbox" value="-1">',width:"5%"}
                        };
                        groupAction=new WeaverEditTable(option);
                        jQuery("#actionList").append(groupAction.getContainer());
                    });
                    function deleteAction(){
                        //top.Dialog.confirm("<%=SystemEnv.getHtmlLabelNames("15097",user.getLanguage())%>",function(){
                            groupAction.deleteRows();
                            
                            jQuery("#actiondeleterows").val(groupAction.deleteRowIds);
                            
                        //});
                    }
                    function getBrowserUrlFn(obj){
                        var mode = jQuery(obj).closest("tr").children("td").eq(2).children("select").val();
                        
                        if(mode=="1"){
                            return "/systeminfo/BrowserMain.jsp?mouldID=workflow&url=/workflow/workflow/WorkFlowNodeBrowser.jsp?wfid=<%=workflowid%>";
                        }else{
                            return "/systeminfo/BrowserMain.jsp?mouldID=workflow&url=/workflow/workflow/WorkFlowLinkBrowser.jsp?wfid=<%=workflowid%>";
                        }
                    }
                    function getCompleteUrl(obj){
                        var mode = jQuery(obj).closest("tr").children("td").eq(3).children("select").val();
                        if(mode=="1"){
                            return "/data.jsp?type=workflowNodeBrowser&wfid=<%=workflowid%>";
                        }else{
                            return "/data.jsp?type=WorkflowNodePortalBrowserMulti&wfid=<%=workflowid%>";
                        }
                    }
                    function clearLinkOrNode(obj){
                        var e8_os = jQuery(obj).closest("tr").children("td").eq(3).find("div.e8_os");
                        var innerOs = jQuery(obj).closest("tr").children("td").eq(3).find("div.e8_innerShow");
                        e8_os.find("input[type='hidden']").val("");
                        e8_os.find("span.e8_showNameClass").remove();
                        innerOs.find("span[name$='spanimg']").html("<img src='/images/BacoError_wev8.gif' align='absmiddle'/>");
                        /*
                        var span = jQuery(obj).closest("tr").children("td").eq(4).children("span");
                        if(jQuery(obj).val()=="1"){
                            span.show();
                        }else{
                            span.hide();
                        }
                        */
                        
                    }
                    
                    function addrowcallback($this,tr){
                        try{
                            jQuery("#allrows").val(groupAction.count);
                            var addidx = jQuery("#addrows").val();
                            jQuery("#addrows").val(addidx+","+groupAction.count);
                            var idx = groupAction.count - 1 ;
                            jQuery("input[name=isused_"+idx+"]").attr("checked",true);
                        }catch(e){
                        
                        }
                        reshowCheckBox();
                        return ;
                    }
                    
                </script>
            </wea:item>
        </wea:group>
    </wea:layout>
</form>
</body>
</html>
<script type="text/javascript">
jQuery(document).ready(function () {
    $("#topTitle").topMenuTitle();
    $(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
    $("#tabDiv").remove();
    $("#advancedSearch").bind("click", function(){
    });
    reshowCheckBox();
});

function reshowCheckBox()
{
    jQuery("input[type=checkbox]").each(function(){
        if(jQuery(this).attr("tzCheckbox")=="true"){
            jQuery(this).tzCheckbox({labels:['','']});
        }
    });
}

function doSubmit(){
        var lastTR = jQuery("#actionList").find("table.grouptable tbody tr[class='contenttr']:last");
        var name = lastTR.children("td:first").find("input[type='checkbox']").attr("name");
        try{
            var idx = "-1";
            try{
                idx = name.substring(name.lastIndexOf("_")+1,name.length);
            }catch(e){
                idx = "-1";
            }
            var actionData = {
                    wfid:<%=workflowid%>,
                    operate:"saveActionList",
                    
                    actiondeleterows:jQuery("#__weaverDeleteRows").val(),
                    allrows:jQuery("#allrows").val(),
                    addrows:jQuery("#addrows").val()
                };
            var params = jQuery("#actionList").find("input[type='hidden'],input[type='checkbox'],select");
            params.each(function(){
                var pv = "" ;
                if(jQuery(this).attr("type")=="checkbox" && !jQuery(this).hasClass("groupselectbox")){
                    pv = jQuery(this).attr("checked")?"1":"0";
                }else{
                    if(jQuery(this).attr("name").indexOf("isused")!=-1){
                        pv = jQuery(this).attr("checked")?"1":"0";
                    }else{
                        pv = jQuery(this).val();
                    }
                }
                actionData[jQuery(this).attr("name")] = pv
            });
            
            jQuery.ajax({
                url:"automaticOperation.jsp",
                dataType:"text",
                type:"post",
                async:false,
                data:actionData,
                success:function(data){
                    if(data==1){
                        top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83551",user.getLanguage())%>");//83280
                    }else{
                        top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83280",user.getLanguage())%>");//83280
                    }
                    window.location.reload() ;
                }
             });
        }catch(e){
            top.Dialog.alert(e.message);
        }
}
</script>
