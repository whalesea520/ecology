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
String secCategory = Util.getIntValue(request.getParameter("secCategory"),-1) + "";
int flowDocCatField = Util.getIntValue(request.getParameter("flowDocCatField"),-1);

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
String sql = "select 1 from workflow_mould where mouldType=3 and workflowid = "+workflowId;
RecordSet.executeSql(sql);
if(!RecordSet.next()){
    //将该子目录关联的文档插入到中间表中
    RecordSet.executeSql("SELECT docMould.ID, docMould.mouldName FROM DocSecCategoryMould docSecCategoryMould, DocMouldFile docMould WHERE docSecCategoryMould.mouldID = docMould.ID AND docSecCategoryMould.mouldType in(4,8) AND docSecCategoryMould.mouldBind = 2 AND docSecCategoryMould.secCategoryID = " + secCategory);
    if(RecordSet.next()){
        RecordSet.beforFirst();
        while(RecordSet.next()){
            RecordSet.executeSql("insert into workflow_mould(workflowid,mouldId,mouldType,visible,seccategory) values("+workflowId+","+RecordSet.getString("ID")+",3,1,"+secCategory+")");
        }
    }else{
        RecordSet.executeSql("SELECT docMould.ID, docMould.mouldName FROM DocSecCategoryMould docSecCategoryMould, DocMouldFile docMould WHERE docSecCategoryMould.mouldID = docMould.ID AND docSecCategoryMould.mouldType in(4,8) AND docSecCategoryMould.mouldBind = 1 AND docSecCategoryMould.secCategoryID = " + secCategory);
        while(RecordSet.next()){
            RecordSet.executeSql("insert into workflow_mould(workflowid,mouldId,mouldType,visible,seccategory) values("+workflowId+","+RecordSet.getString("ID")+",3,1,"+secCategory+")");
        }
    }
}
sql = "SELECT docMould.ID, docMould.mouldName FROM DocSecCategoryMould docSecCategoryMould, DocMouldFile docMould WHERE docMould.ID in (select mouldid from workflow_mould where visible=1 and mouldType=3 and workflowid = "+workflowId+") and docSecCategoryMould.mouldID = docMould.ID AND docSecCategoryMould.mouldType in(4,8) AND docSecCategoryMould.mouldBind = 2 AND docSecCategoryMould.secCategoryID = " + secCategory;
RecordSet.executeSql(sql);
String ajaxDatas = "";
if(RecordSet.next()){
    RecordSet.beforFirst();
}else{
    RecordSet.executeSql("SELECT docMould.ID, docMould.mouldName FROM DocSecCategoryMould docSecCategoryMould, DocMouldFile docMould WHERE docMould.ID in (select mouldid from workflow_mould where visible=1 and seccategory="+secCategory+" and mouldType=3 and workflowid = "+workflowId+") and docSecCategoryMould.mouldID = docMould.ID AND docSecCategoryMould.mouldType in(4,8) AND docSecCategoryMould.mouldBind = 1 AND docSecCategoryMould.secCategoryID = " + secCategory);
}
WeaverEditTableUtil.setWorkflowid(workflowId+"");
ajaxDatas = WeaverEditTableUtil.getInitDatas("editMould",user,RecordSet);


String groupAttrsEdit = "{'groupDisplay':'"+(flowDocCatField<=0?"none":"")+"','itemAreaDisplay':'"+(flowDocCatField<=0?"none":"")+"'}";
String groupAttrs1 = "{'groupDisplay':'"+(flowDocCatField<=0?"none":"")+"','itemAreaDisplay':'"+(flowDocCatField<=0?"none":"")+"','samePair':'selectEditMouldSetting'}";

int tempFieldId = 0;
String tempFieldLabel ="";

%>
<script type="text/javascript">

var wfJavaParamsObj_em = {
    workflowId : "<%=workflowId %>",
    formId : "<%=formID %>",
    isBill : "<%=isbill %>",
    msg_149 : "<%=SystemEnv.getHtmlLabelName(149, user.getLanguage()) %>",
    msg_21449 : "<%=SystemEnv.getHtmlLabelName(21449, user.getLanguage()) %>",
    msg_25126 : "<%=SystemEnv.getHtmlLabelName(25126, user.getLanguage()) %>",
    msg_33338 : "<%=SystemEnv.getHtmlLabelName(33338, user.getLanguage()) %>",
    msg_28052 : "<%=SystemEnv.getHtmlLabelName(28052, user.getLanguage()) %>"
};

var editGroup = null;
jQuery(document).ready(function(){
    var ajaxDatas = <%=ajaxDatas%>
    var items=[
        {width:"30%",colname:wfJavaParamsObj_em.msg_28052,itemhtml:"<span type='span' name='defaultMould'></span>"},
        {width:"65%",colname:wfJavaParamsObj_em.msg_33338,itemhtml:"<span type='span' name='operate'></span>"},
        {width:"15%",colname:wfJavaParamsObj_em.msg_149,itemhtml:"<input type='radio' name='setDefEdit' _normalraido='true'  />"}
        ];
    var option = {
        basictitle:"",
        optionHeadDisplay:"none",
        colItems:items,
        container:"#defaultEditMouldList",
        toolbarshow:false,
        configCheckBox:true,
        usesimpledata:true,
        openindex:false,
        addrowCallBack:setDefEdit,
        initdatas:ajaxDatas,
        checkBoxItem:{"itemhtml":'<input name="mouldId" class="groupselectbox" type="checkbox" >',width:"5%"}
    };
    editGroup=new WeaverEditTable(option);
    jQuery("#defaultEditMouldList").append(editGroup.getContainer());
});
</script>
<div id="wfEditMould"  style="<%=tabIndex==3?"":"display:none;" %>" class="wfOfficalDoc">
	<wea:layout needImportDefaultJsAndCss="false">
        <wea:group context='<%=SystemEnv.getHtmlLabelName(33325,user.getLanguage()) %>'>
            <wea:item type="groupHead">
                <input type="button" class="addbtn" title="<%= SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onclick="attachRelative('defaultEditMouldList');"/>
                <input type="button" class="delbtn" title="<%= SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="detachRelative('defaultEditMouldList');"/>
            </wea:item>
            <wea:item attributes="{'isTableList':'true'}">
                <div id="defaultEditMouldList"></div>
            </wea:item>
        </wea:group>
			
        <wea:group context='<%=SystemEnv.getHtmlLabelName(23039,user.getLanguage())%>'attributes="<%=groupAttrsEdit %>">
            <wea:item><%=SystemEnv.getHtmlLabelName(22755,user.getLanguage())%></wea:item>
            <wea:item>
            <%
                RecordSet.executeSql(SQLDocumentLocation);  
                while(RecordSet.next()) {
                    tempFieldId = RecordSet.getInt("ID");
                    tempFieldLabel = RecordSet.getString("fieldLable");
                    if(tempFieldId == flowDocCatField) { 
            %>
                <span ><%=tempFieldLabel %></span>
                <a href="#" class="weihu"> <span class="middle e8_btn_top_first" ><%=SystemEnv.getHtmlLabelName(60,user.getLanguage()) %></span></a>		
            <%
                    }
                }
            %>
            </wea:item>
        </wea:group>
        <wea:group context='<%=SystemEnv.getHtmlLabelNames("23039,30747",user.getLanguage())%>' attributes="<%=groupAttrs1 %>">
            <wea:item attributes="{'isTableList':'true'}">
                <div id="editSelectMould"></div>
            </wea:item>
        </wea:group>
    </wea:layout>
</div>