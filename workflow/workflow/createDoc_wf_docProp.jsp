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

<% 
User user = HrmUserVarify.getUser(request,response);

int workflowId = Util.getIntValue(request.getParameter("workflowId"),-1);
String formID = StringUtils.trimToEmpty(request.getParameter("formId"));
String isbill = StringUtils.trimToEmpty(request.getParameter("isBill"));
int tabIndex = Util.getIntValue(request.getParameter("tabIndex"),1);
String secCategory = Util.getIntValue(request.getParameter("secCategory"),-1) + "";
int flowDocCatField = Util.getIntValue(request.getParameter("flowDocCatField"),-1);
int useTempletNode = Util.getIntValue(request.getParameter("useTempletNode"),-1);
String isDialog = StringUtils.trimToEmpty(request.getParameter("isDialog"));
String defaultView = StringUtils.trimToEmpty(request.getParameter("defaultView"));

RecordSet.executeSql("select isuser,e8number from DocSecCategory where id="+secCategory);
String isuser = "";
String number = "";
if(RecordSet.next()){
    isuser = Util.null2String(RecordSet.getString("isuser"));
    number = Util.null2String(RecordSet.getString("e8number"));
}

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

String groupAttrs =  "{'groupDisplay':'"+(flowDocCatField<=0?"none":"")+"','itemAreaDisplay':'"+(flowDocCatField<=0?"none":"")+"'}";
String groupAttrs2 = "{'groupDisplay':'"+((useTempletNode<=0||flowDocCatField<=0)?"none":"")+"','itemAreaDisplay':'"+(flowDocCatField<=0?"none":"")+"','samePair':'propSetting'}";

int tempFieldId = 0;
String tempFieldLabel ="";

%>

<form name="docPropDetailForm" id="docPropDetailForm" method="post" action="WorkflowDocPropDetailOperation.jsp">
	<input type="hidden" id='isdialog' name='isdialog' value=<%=isDialog %>>        
	<div id="wfDocProp"  style="<%=tabIndex==4?"":"display:none;" %>" class="wfOfficalDoc">
		<wea:layout needImportDefaultJsAndCss="false" attributes="{'expandAllGroup':'true'}">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(33328,user.getLanguage()) %>'>
				<wea:item><%=SystemEnv.getHtmlLabelName(33319,user.getLanguage()) %></wea:item>
				<wea:item>
					<%=defaultView %>
					<input type="hidden" name="isuser" value="<%=isuser %>"/>	
					<input type="hidden" name="number" value="<%=number %>"/>
				</wea:item>
			</wea:group>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(33329,user.getLanguage())%>'>
				<wea:item attributes="{'isTableList':'true'}">
					<div id="docPropDetailDiv"></div>
				</wea:item>
			</wea:group>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(19214,user.getLanguage())%>' attributes="<%=groupAttrs %>">
			<wea:item><%=SystemEnv.getHtmlLabelName(22755,user.getLanguage())%></wea:item>
			<wea:item>
            <%
                RecordSet.executeSql(SQLDocumentLocation);  
                while(RecordSet.next()) {
                    tempFieldId = RecordSet.getInt("ID");
                    tempFieldLabel = RecordSet.getString("fieldLable");
                    if(tempFieldId == flowDocCatField) { 
            %>
                <span><%=tempFieldLabel %></span>
                <a href="#" class="weihu"><span class="middle e8_btn_top_first"><%=SystemEnv.getHtmlLabelName(60,user.getLanguage()) %></span></a>
            <%
                    }
                }
            %>
			</wea:item>
		</wea:group>
		<wea:group context='<%=SystemEnv.getHtmlLabelNames("33403",user.getLanguage())%>' attributes="<%=groupAttrs2 %>">
			<wea:item attributes="{'isTableList':'true'}">
				<div id="selectPropDiv"></div>
			</wea:item>
		</wea:group>
		</wea:layout>
	</div>
</form>