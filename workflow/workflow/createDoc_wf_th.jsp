<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page import="org.apache.commons.lang.StringUtils"%>

<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.Prop" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WeaverEditTableUtil" class="weaver.docs.util.WeaverEditTableUtil" scope="page" />

<%
User user = HrmUserVarify.getUser(request,response);

int workflowId = Util.getIntValue(request.getParameter("workflowId"),-1);
String formID = StringUtils.trimToEmpty(request.getParameter("formId"));
String isbill = StringUtils.trimToEmpty(request.getParameter("isBill"));
int tabIndex = Util.getIntValue(request.getParameter("tabIndex"),1);
int useTempletNode = Util.getIntValue(request.getParameter("useTempletNode"),-1);
int flowDocCatField = Util.getIntValue(request.getParameter("flowDocCatField"),-1);
String secCategory = Util.getIntValue(request.getParameter("secCategory"),-1) + "";
boolean canBeSet = "true".equals(request.getParameter("canBeSet"));

String SQL = "";
if("1".equals(isbill)) {
    SQL = "select formField.id,fieldLable.labelName as fieldLable "
            + "from HtmlLabelInfo  fieldLable ,workflow_billfield  formField "
            + "where fieldLable.indexId=formField.fieldLabel "
            + "  and formField.billId= " + formID
            + "  and formField.viewType=0 "
            + "  and fieldLable.languageid =" + user.getLanguage();
} else {
    SQL = "select formDict.ID, fieldLable.fieldLable "
            + "from workflow_fieldLable fieldLable, workflow_formField formField, workflow_formdict formDict "
            + "where fieldLable.formid = formField.formid and fieldLable.fieldid = formField.fieldid and formField.fieldid = formDict.ID and (formField.isdetail<>'1' or formField.isdetail is null) "
            + "and formField.formid = " + formID
            + " and fieldLable.langurageid = " + user.getLanguage();
}
String SQLDocumentLocation = null;
if("1".equals(isbill)){
    SQLDocumentLocation = SQL + " and formField.fieldHtmlType = '5' and not exists ( select * from workflow_selectitem where (docCategory is null or docCategory = '') and isAccordToSubCom='0' and formField.ID = workflow_selectitem.fieldid and isBill='1' )order by formField.dspOrder";
}else{
    SQLDocumentLocation = SQL + " and formDict.fieldHtmlType = '5' and not exists ( select * from workflow_selectitem where (docCategory is null or docCategory = '') and isAccordToSubCom='0' and formDict.ID = workflow_selectitem.fieldid and isBill='0') order by formField.fieldorder";
}

// 设置是否使用二维条码
String isUse="0";
RecordSet.executeSql("select * from Workflow_BarCodeSet where workflowId="+workflowId);
if(RecordSet.next()){
    isUse = Util.null2String(RecordSet.getString("isUse"));
}
int isUseBarCode = Util.getIntValue(Prop.getPropValue("weaver_barcode", "ISUSEBARCODE"),0);
String groupAttrs = "{'groupDisplay':'"+(useTempletNode<=0?"none":"")+"','itemAreaDisplay':'"+(useTempletNode<=0?"none":"")+"','samePair':'defaultMouldSetting'}";
String groupAttrs1 = "{'groupDisplay':'"+((useTempletNode<=0||flowDocCatField<=0)?"none":"")+"','itemAreaDisplay':'"+((useTempletNode<=0||flowDocCatField<=0)?"none":"")+"','samePair':'selectMouldSetting'}";
String groupAttrsTaoH = "{'groupDisplay':'"+((useTempletNode<=0||flowDocCatField<=0)?"none":"")+"','itemAreaDisplay':'"+((useTempletNode<=0||flowDocCatField<=0)?"none":"")+"'}";
String sqlUseTempletNode =  " select b.id as nodeId,b.nodeName from workflow_flownode a,workflow_nodebase b where (b.IsFreeNode is null or b.IsFreeNode!='1') and a.nodetype!=3 and a.nodeId=b.id and  a.workFlowId= "+workflowId+"  order by a.nodeType,a.nodeId";

int tempFieldId = 0;
String tempFieldLabel ="";
int tempNodeId = 0;
String tempNodeName ="";

String sql = "select 1 from workflow_mould where mouldType=0 and workflowid = "+workflowId;
RecordSet.executeSql(sql);
if(!RecordSet.next()){
    //将该子目录关联的文档插入到中间表中
    RecordSet.executeSql("SELECT docMould.ID, docMould.mouldName FROM DocSecCategoryMould docSecCategoryMould, DocMould docMould WHERE docSecCategoryMould.mouldID = docMould.ID AND docSecCategoryMould.mouldType in(3,7) AND docSecCategoryMould.mouldBind = 2 AND docSecCategoryMould.secCategoryID = " + secCategory);
    if(RecordSet.next()){
        RecordSet.beforFirst();
        while(RecordSet.next()){
            RecordSet.executeSql("insert into workflow_mould(workflowid,mouldId,mouldType,visible,seccategory) values("+workflowId+","+RecordSet.getString("ID")+",0,1,"+secCategory+")");
        }
    }else{
        RecordSet.executeSql("SELECT docMould.ID, docMould.mouldName FROM DocSecCategoryMould docSecCategoryMould, DocMould docMould WHERE docSecCategoryMould.mouldID = docMould.ID AND docSecCategoryMould.mouldType in(3,7) AND docSecCategoryMould.mouldBind = 1 AND docSecCategoryMould.secCategoryID = " + secCategory);
        while(RecordSet.next()){
            RecordSet.executeSql("insert into workflow_mould(workflowid,mouldId,mouldType,visible,seccategory) values("+workflowId+","+RecordSet.getString("ID")+",0,1,"+secCategory+")");
        }
    }
}
sql = "SELECT docMould.ID, docMould.mouldName FROM DocSecCategoryMould docSecCategoryMould, DocMould docMould WHERE docMould.ID in (select mouldid from workflow_mould where visible=1 and mouldType=0 and workflowid = "+workflowId+") and docSecCategoryMould.mouldID = docMould.ID AND docSecCategoryMould.mouldType in(3,7) AND docSecCategoryMould.mouldBind = 2 AND docSecCategoryMould.secCategoryID = " + secCategory;
RecordSet.executeSql(sql);
String ajaxDatas = "";
if(RecordSet.next()){
    RecordSet.beforFirst();
}else{
    RecordSet.executeSql("SELECT docMould.ID, docMould.mouldName FROM DocSecCategoryMould docSecCategoryMould, DocMould docMould WHERE docMould.ID in (select mouldid from workflow_mould where visible=1 and seccategory="+secCategory+" and mouldType=0 and workflowid = "+workflowId+") and docSecCategoryMould.mouldID = docMould.ID AND docSecCategoryMould.mouldType in(3,7) AND docSecCategoryMould.mouldBind = 1 AND docSecCategoryMould.secCategoryID = " + secCategory);
}
WeaverEditTableUtil.setWorkflowid(workflowId+"");
ajaxDatas = WeaverEditTableUtil.getInitDatas("viewMould",user,RecordSet);

%>

<html>
    <head>
        <title>createDoc_wf_th.jsp</title>
        <script type="text/javascript">
            var wfJavaParamsObj_th = {
                workflowId : "<%=workflowId %>",
                formId : "<%=formID %>",
                isBill : "<%=isbill %>",
                msg_149 : "<%=SystemEnv.getHtmlLabelName(149, user.getLanguage()) %>",
                msg_21449 : "<%=SystemEnv.getHtmlLabelName(21449, user.getLanguage()) %>",
                msg_25126 : "<%=SystemEnv.getHtmlLabelName(25126, user.getLanguage()) %>",
                msg_33338 : "<%=SystemEnv.getHtmlLabelName(33338, user.getLanguage()) %>"
            };

            var group = null;
            jQuery(document).ready(function(){
                var ajaxDatas = <%=ajaxDatas %>;
                var items = [
                    {width:"30%",colname:wfJavaParamsObj_th.msg_25126,itemhtml:"<span type='span' name='defaultMould'></span>"},
                    {width:"55%",colname:wfJavaParamsObj_th.msg_33338,itemhtml:"<span type='span' name='operate'></span>"},
                    {width:"15%",colname:wfJavaParamsObj_th.msg_149,itemhtml:"<input type='radio' name='setDef' _normalraido='true' onclick='setDef()' />"}
                ];
                var option = {
                    basictitle:"",
                    optionHeadDisplay:"none",
                    colItems:items,
                    container:"#defaultMouldList",
                    toolbarshow:false,
                    configCheckBox:true,
                    openindex:false,
                    usesimpledata:true,
                    addrowCallBack:setDef,
                    initdatas:ajaxDatas,
                    checkBoxItem:{"itemhtml":'<input name="mouldId" class="groupselectbox" type="checkbox" >',width:"5%"}
                };
                group=new WeaverEditTable(option);
                jQuery("#defaultMouldList").append(group.getContainer());
            });

            // 设置 【二维码设置】按钮  显示或隐藏
            function openqr() {
                if(jQuery("#isUse").attr("checked")) {
                    jQuery("#setqrCode").show();
                } else {
                    jQuery("#setqrCode").hide();
                }
            }

            // 弹出 二维条码设置 页面
            function setqrCode(){
                if(window.top.Dialog){
                    diag_vote = new window.top.Dialog();
                } else {
                    diag_vote = new Dialog();
                }
                diag_vote.currentWindow = window;
                diag_vote.Width = 850;
                diag_vote.Height = 750;
                diag_vote.Modal = true;
                diag_vote.maxiumnable = true;
                diag_vote.Title = wfJavaParamsObj_th.msg_21449;
                diag_vote.URL = "/workflow/workflow/WFSetqrCode.jsp?workflowId="+wfJavaParamsObj_th.workflowId+"&formId="+wfJavaParamsObj_th.formId+"&isBill="+wfJavaParamsObj_th.isBill;
                diag_vote.show();
            }
        </script>
    </head>
    <body>
        <div id="wfTaoHong" style="<%=tabIndex==2?"":"display:none;" %>" class="wfOfficalDoc">
            <input type="hidden" name="from" id="from" value="attachMould"/>
        <% if(canBeSet){ //单据不允许配置 %>	
                <wea:layout needImportDefaultJsAndCss="false">
                    <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
                        <wea:item><%=SystemEnv.getHtmlLabelName(20229,user.getLanguage())%></wea:item>
                        <wea:item>
                            <select class="inputstyle" id="useTempletNode" name="useTempletNode" onchange="toggleGroup(this);">
                                <option value="-1"></option>
                            <%
                                RecordSet.executeSql(sqlUseTempletNode);	            
                                while(RecordSet.next()){
                                    tempNodeId = RecordSet.getInt("nodeId");
                                    tempNodeName = RecordSet.getString("nodeName");
                            %>
                                <option value="<%=tempNodeId %>" <% if(tempNodeId == useTempletNode) { %> selected <% } %> ><%=tempNodeName %></option>
                            <% } %>
                            </select>		
                        </wea:item>
                    <% if(1 == isUseBarCode) { %>
                        <!-- 20160629 huangj 二维条码设置 -->
                        <wea:item><%=SystemEnv.getHtmlLabelName(127769,user.getLanguage())%></wea:item> 
                        <wea:item>
                            <input type="checkbox" name="isUse" id="isUse" tzCheckbox="true" onclick="openqr()" value="1" <% if("1".equals(isUse)) {%> checked <%}%> />
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                            <span id="setqrCode" <% if(!"1".equals(isUse)) {%>style="display: none" <%} %>>
                                <a href="#" onclick="setqrCode()" style="color:blue;TEXT-DECORATION:none">
                                    <%=SystemEnv.getHtmlLabelName(21449,user.getLanguage())%>
                                </a>
                            </span> 
                        </wea:item>
                    <% } %>
                    </wea:group>
                    <wea:group context='<%=SystemEnv.getHtmlLabelName(33325,user.getLanguage())%>' attributes="<%=groupAttrs %>">
                        <wea:item type="groupHead">
                            <input type="button" class="addbtn" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onclick="attachRelative('defaultMouldList');"/>
                            <input type="button" class="delbtn" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="detachRelative('defaultMouldList');"/>
                        </wea:item>
                        <wea:item attributes="{'isTableList':'true'}">
                            <div id="defaultMouldList"></div>
                        </wea:item>
                    </wea:group>
                    <wea:group context='<%=SystemEnv.getHtmlLabelName(23039,user.getLanguage())%>' attributes="<%=groupAttrsTaoH %>">
                        <wea:item><%=SystemEnv.getHtmlLabelName(22755,user.getLanguage())%></wea:item>
                        <wea:item>
                        <%
                            RecordSet.executeSql(SQLDocumentLocation);  
                            while(RecordSet.next()) {
                                tempFieldId = RecordSet.getInt("ID");
                                tempFieldLabel = RecordSet.getString("fieldLable");
                                if(tempFieldId == flowDocCatField) {
                                    // flag = flowDocCatField;
                            
                        %>
                            <span><%=tempFieldLabel %></span>&nbsp;
                            <a href="#" class="weihu"><span class="middle e8_btn_top_first" ><%=SystemEnv.getHtmlLabelName(60,user.getLanguage()) %></span></a>
                        <%     
                                }
                            }
                        %>
                        </wea:item>
                    </wea:group>
                    <wea:group context='<%=SystemEnv.getHtmlLabelNames("23039,30747",user.getLanguage()) %>' attributes="<%=groupAttrs1 %>">
                        <wea:item attributes="{'isTableList':'true'}">
                            <div id="defaultSelectMould"></div>
                        </wea:item>
                    </wea:group>
                </wea:layout>
        <%  } %>
        </div>
    </body>
</html>

