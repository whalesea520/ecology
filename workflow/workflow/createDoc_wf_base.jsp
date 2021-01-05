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
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />

<%
User user = HrmUserVarify.getUser(request,response);

int workflowId = Util.getIntValue(request.getParameter("workflowId"),-1);
String formID = StringUtils.trimToEmpty(request.getParameter("formId"));
String isbill = StringUtils.trimToEmpty(request.getParameter("isBill"));
int tabIndex = Util.getIntValue(request.getParameter("tabIndex"),1);
int flowDocField = Util.getIntValue(request.getParameter("flowDocField"),-1);
int documentTitleField = Util.getIntValue(request.getParameter("documentTitleField"),-1);
int flowDocCatField = Util.getIntValue(request.getParameter("flowDocCatField"),-1);
String defaultView = StringUtils.trimToEmpty(request.getParameter("defaultView"));
String newTextNodes = StringUtils.trimToEmpty(request.getParameter("newTextNodes"));
int flowCodeField = Util.getIntValue(request.getParameter("flowCodeField"),-1);
int extfile2doc = Util.getIntValue(request.getParameter("extfile2doc"),0);
int keywordFieldId = Util.getIntValue(request.getParameter("keywordFieldId"),-1);
int titleFieldId = Util.getIntValue(request.getParameter("titleFieldId"),0);
String onlyCanAddWord = StringUtils.trimToEmpty(request.getParameter("onlyCanAddWord"));
String ifVersion = StringUtils.trimToEmpty(request.getParameter("ifVersion"));
String isWorkflowDraft = StringUtils.trimToEmpty(request.getParameter("isWorkflowDraft"));
String defaultDocType = StringUtils.trimToEmpty(request.getParameter("defaultDocType"));
String openTextDefaultNode = StringUtils.trimToEmpty(request.getParameter("openTextDefaultNode"));
String openTextDefaultNodes = StringUtils.trimToEmpty(request.getParameter("openTextDefaultNodes"));
String cleanCopyNodes = StringUtils.trimToEmpty(request.getParameter("cleanCopyNodes"));
String cleanCopyNodesName = StringUtils.trimToEmpty(request.getParameter("cleanCopyNodesName"));
String isTextInForm = StringUtils.trimToEmpty(request.getParameter("isTextInForm"));

String SQL = "";
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
String SQLCreateDocument = null;
if("1".equals(isbill)){
    SQLCreateDocument = SQL + " and formField.fieldHtmlType = '3' and formField.type = 9 order by formField.dspOrder";
}else{
    SQLCreateDocument = SQL + " and formDict.fieldHtmlType = '3' and formDict.type = 9 order by formField.fieldorder";
}
String SQLWorkFlowCoding = "";
if("1".equals(isbill)){
    SQLWorkFlowCoding = SQL + " and formField.fieldHtmlType = '1' and formField.type = 1 order by formField.dspOrder";
}else{
    SQLWorkFlowCoding = SQL + " and formDict.fieldHtmlType = '1' and formDict.type = 1 order by formField.fieldorder";
}
String SQLDocumentLocation = "";
if("1".equals(isbill)){
    SQLDocumentLocation = SQL + " and formField.fieldHtmlType = '5' and not exists ( select * from workflow_selectitem where (docCategory is null or docCategory = '') and isAccordToSubCom='0' and formField.ID = workflow_selectitem.fieldid and isBill='1' )order by formField.dspOrder";
}else{
    SQLDocumentLocation = SQL + " and formDict.fieldHtmlType = '5' and not exists ( select * from workflow_selectitem where (docCategory is null or docCategory = '') and isAccordToSubCom='0' and formDict.ID = workflow_selectitem.fieldid and isBill='0') order by formField.fieldorder";
}

String pathCategoryDocumentURL = "/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp";
String isUseDefaultDocType = Util.null2String(BaseBean.getPropValue("weaver_defaultdoctype","ISUSEDEFAULTDOCTYPE"));
String attrs = "{'samePair':'titleFieldId','display':'"+((keywordFieldId <= 0)?"none":"")+"'}";

int tempFieldId = 0;
String tempFieldLabel ="";
String setDefaultTabUrl= "";
String chooseNodesUrl = "";


%>
<html>
    <head>
        <title>createDoc_wf_base.jsp</title>
        <link href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET" />
        <link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type="text/css" rel="STYLESHEET" />
        <link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
        <link type="text/css" href="/js/tabs/css/e8tabs6_wev8.css" rel="stylesheet" />
        <style type="text/css">
        .magic-line{
            top:21px!important;
        }
        </style>
        <script type="text/javascript" src="/js/ecology8/jquery_wev8.js"></script>
        <script type="text/javascript" src="/js/weaver_wev8.js"></script>
        <script type="text/javascript" src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
        <script type="text/javascript" src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
        <script type="text/javascript" src="/js/ecology8/request/e8.browser_wev8.js"></script>
        <script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
        
        <script type="text/javascript">
        var wfJavaParamsObj_base = {
            newTextNodes : "<%=newTextNodes %>"
        };
        
        jQuery(document).ready(function(){
            if("1" == wfJavaParamsObj_base.newTextNodes) {
                jQuery("input[name='onlyCanAddWord']").parent().parent().hide();
            }
            jQuery("input[name='newTextNodes']").click(function(){
                if(jQuery("input[name='newTextNodes']")[0].checked){
                    jQuery("input[name='onlyCanAddWord']").parent().parent().hide();
                }else{
                    jQuery("input[name='onlyCanAddWord']").parent().parent().show();
                }
            });
        });  

        </script>
    </head>
    <body>
        <div id="wfBaseInfo" class="wfOfficalDoc" style="<%=tabIndex==1?"":"display:none;" %>">
            <wea:layout>
                <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
                    <wea:item><%=SystemEnv.getHtmlLabelNames("1265,261",user.getLanguage())%></wea:item>
                    <wea:item>
                        <select class="inputstyle" name="createDocument">
                            <option value=-1></option>
                        <%
                            RecordSet.executeSql(SQLCreateDocument);
                            while(RecordSet.next()) {
                                tempFieldId = RecordSet.getInt("ID");
                                tempFieldLabel = RecordSet.getString("fieldLable");
                        %>
                            <option value="<%=tempFieldId %>" <% if(tempFieldId == flowDocField) { %> selected <% } %> ><%=tempFieldLabel %></option>
                        <% } %>
                        </select>
                        <span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(21100,user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>		
                    </wea:item>
                    <wea:item><%=SystemEnv.getHtmlLabelNames("1265,229",user.getLanguage())%></wea:item>
                    <wea:item>
                        <select class="inputstyle" name="documentTitleField">
                            <option value="-1"></option>
                            <option value="-3" <% if(documentTitleField == -3) { %> selected <% } %>><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></option>
                        <%                                                
                            RecordSet.executeSql(SQLWorkFlowCoding);
                            while(RecordSet.next()){
                                tempFieldId = RecordSet.getInt("ID");
                                tempFieldLabel = RecordSet.getString("fieldLable");
                        %>
                            <option value=<%=tempFieldId %> <% if(tempFieldId == documentTitleField) { %> selected <% } %> ><%=tempFieldLabel %></option>
                        <%}%>
                        </select>
                        <span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(21101,user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
                    </wea:item>
                    <wea:item><%=SystemEnv.getHtmlLabelName(33319,user.getLanguage())%></wea:item>
                    <wea:item>
                        <brow:browser name="pathCategoryDocument" viewType="0" hasBrowser="true" hasAdd="false" idKey="id" nameKey="path"
                            browserUrl='<%=pathCategoryDocumentURL %>' isMustInput="2" isSingle="true" hasInput="true"
                            temptitle='<%= SystemEnv.getHtmlLabelName(33319,user.getLanguage())%>' language='<%=""+user.getLanguage() %>'
                            completeUrl="/data.jsp?type=categoryBrowser" _callback="onShowCatalogData" width="300px" browserValue='<%=defaultView%>' browserSpanValue='<%=defaultView%>' />
                    </wea:item>

                    <wea:item><%=SystemEnv.getHtmlLabelNames("690,19214", user.getLanguage())%></wea:item>
                        <wea:item>
                            <select class="inputstyle" name="documentLocation" id="documentLocation"  >
                                <option value="-1"></option>
                            <%
                                RecordSet.executeSql(SQLDocumentLocation);  
                                while(RecordSet.next()) {
                                    tempFieldId = RecordSet.getInt("ID");
                                    tempFieldLabel = RecordSet.getString("fieldLable");
                            %>
                                 <option value=<%=tempFieldId %> <% if(tempFieldId == flowDocCatField) { %> selected <% } %> ><%=tempFieldLabel %></option>
                            <%  }   %>
                            </select>
                            <span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(21102,user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
                        </wea:item>
                </wea:group>
                <wea:group context='<%=SystemEnv.getHtmlLabelName(20824,user.getLanguage())%>'>	
                    <wea:item><%=SystemEnv.getHtmlLabelName(33382,user.getLanguage())%></wea:item>
                    <wea:item>
                        <select class="inputstyle" name="workFlowCoding">
                            <option value="-1"></option>
                        <%          
                            RecordSet.executeSql(SQLWorkFlowCoding);
                            while(RecordSet.next()){
                                tempFieldId = RecordSet.getInt("ID");
                                tempFieldLabel = RecordSet.getString("fieldLable");
                        %>
                            <option value=<%=tempFieldId %> <% if(tempFieldId == flowCodeField) { %> selected <% } %> ><%=tempFieldLabel %></option>
                        <% } %>
                        </select>
                        <span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(21099,user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
                    </wea:item>
                    <wea:item><%=SystemEnv.getHtmlLabelName(33320,user.getLanguage())%></wea:item>
                    <wea:item>
                        <input class="inputstyle" tzCheckbox="true" type="checkbox" name="newTextNodes" value="1" <% if("1".equals(newTextNodes)){ %> checked <%} %>/>
                        <span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(21635,user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
                    </wea:item>           
                    <wea:item><%=SystemEnv.getHtmlLabelName(131221,user.getLanguage())%></wea:item>
                    <wea:item>
                        <input class="inputstyle" tzCheckbox="true" type="checkbox" name="onlyCanAddWord" value="1" <% if("1".equals(onlyCanAddWord)){ %> checked <%} %>/>
                        <span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(131222,user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
                    </wea:item>
                    <wea:item><%=SystemEnv.getHtmlLabelName(33321,user.getLanguage())%></wea:item>
                    <wea:item>
                        <input class="inputstyle" tzCheckbox="true" type="checkbox" name="ifVersion"  value="1" <%if("1".equals(ifVersion)){%>checked<%}%> />
                        <span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(21722,user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
                    </wea:item>
                    <wea:item><%=SystemEnv.getHtmlLabelName(33322,user.getLanguage())%></wea:item>
                    <wea:item>
                        <input class="inputstyle" tzCheckbox="true" type="checkbox" name="isWorkflowDraft"  value="1" <%if("1".equals(isWorkflowDraft)){%>checked<%}%> />
                        <span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(21732,user.getLanguage())+"&nbsp;&nbsp;&nbsp;&nbsp;<font color='red'>"+SystemEnv.getHtmlLabelName(21733,user.getLanguage())+"</font>" %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
                    </wea:item>
                    <wea:item><%=SystemEnv.getHtmlLabelName(33324,user.getLanguage())%></wea:item>
                    <wea:item>
                        <input class="inputstyle" tzCheckbox="true" type="checkbox" id="extfile2doc" name="extfile2doc"  value="1" <%if(extfile2doc==1){%>checked<%}%> />
                        <span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(24009,user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
                    </wea:item>
        <% if(isUseDefaultDocType.equals("1")) { %>
                    <wea:item><%=SystemEnv.getHtmlLabelName(22358,user.getLanguage())%></wea:item>
                    <wea:item>
                        <select class="inputstyle" name="defaultDocType">
                            <option value="1" <% if(defaultDocType.equals("1")){%> selected <%}%> >Office Word</option>
                            <option value="2" <% if(defaultDocType.equals("2")){%> selected <% }%> ><%=SystemEnv.getHtmlLabelName(22359,user.getLanguage())%></option>
                        </select>		
                    </wea:item>
        <% } %>	
                <wea:item><%=SystemEnv.getHtmlLabelName(382048,user.getLanguage())%></wea:item>
                <wea:item>
                    <input class="inputstyle" tzCheckbox="true" type="checkbox" name="isTextInForm"  value="1" <%if("1".equals(isTextInForm)){%>checked<%}%> />
                    <span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(382013,user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
                </wea:item>
                    <wea:item><%=SystemEnv.getHtmlLabelName(21516,user.getLanguage())%></wea:item>
                    <wea:item>
                        <select name="keywordFieldId" onchange="toggleTitleFieldId(this);">
                            <option value="-1"></option>
                        <%
                            RecordSet.executeSql(SQLWorkFlowCoding);
                            while(RecordSet.next()){
                                tempFieldId = RecordSet.getInt("ID");
                                tempFieldLabel = RecordSet.getString("fieldLable");
                        %>
                            <option value="<%=tempFieldId %>" <% if(tempFieldId == keywordFieldId) { %> selected <% } %> ><%=tempFieldLabel %></option>
                        <%  }   %>
                        </select>
                    </wea:item>		
                    <wea:item attributes='<%=attrs %>'><%=SystemEnv.getHtmlLabelName(19501,user.getLanguage())%></wea:item>
                    <wea:item attributes='<%=attrs %>'>
                        <select name="titleFieldId">
                            <option value="-1"></option>
                            <option value="-3" <%if (titleFieldId==-3) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></option>
                        <%
                            RecordSet.executeSql(SQLWorkFlowCoding);
                            while(RecordSet.next()){
                                tempFieldId = RecordSet.getInt("ID");
                                tempFieldLabel = RecordSet.getString("fieldLable");
                        %>
                            <option value="<%=tempFieldId %>" <% if(tempFieldId == titleFieldId) { %> selected <% } %> ><%=tempFieldLabel %></option>
                        <%  }   %>
                        </select>
                    </wea:item>
                    <!-- 默认打开正文的节点 -->	
                    <wea:item><%=SystemEnv.getHtmlLabelName(128306,user.getLanguage())%></wea:item>
                    <wea:item>
                        <% 
                            setDefaultTabUrl="/data.jsp?type=fieldBrowser&wfid="+workflowId; 
                            chooseNodesUrl = "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/flowNodes.jsp?option=2&workflowId="+workflowId+"&oldNodeIds="+openTextDefaultNode;
                        %>
                        <brow:browser name="openTextDefaultNode" viewType="0" hasBrowser="true" hasAdd="false" 
                            browserUrl='<%=chooseNodesUrl %>' isMustInput="1" isSingle="false" hasInput="true"
                            completeUrl='<%=setDefaultTabUrl %>' isAutoComplete="false" width="300px" browserValue='<%=openTextDefaultNode %>' 
                            browserSpanValue='<%=openTextDefaultNodes %>' nameSplitFlag="," />
                    </wea:item>
                    <!-- 清稿节点-->
                    <wea:item><%=SystemEnv.getHtmlLabelName(129588,user.getLanguage())%></wea:item>
                    <wea:item>
                        <% 
                            setDefaultTabUrl="/data.jsp?type=fieldBrowser&wfid="+workflowId; 
                            chooseNodesUrl = "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/flowNodes.jsp?option=2&workflowId="+workflowId+"&oldNodeIds="+cleanCopyNodes+"&tilteName=129588";
                        %>
                        <brow:browser name="cleanCopyNodes" viewType="0" hasBrowser="true" hasAdd="false" 
                            browserUrl='<%=chooseNodesUrl %>' isMustInput="1" isSingle="false" hasInput="true"
                            completeUrl='<%=setDefaultTabUrl %>' isAutoComplete="false" width="300px" browserValue='<%=cleanCopyNodes %>' 
                            browserSpanValue='<%=cleanCopyNodesName %>' nameSplitFlag="," /> 	
                        <span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(129892,user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>			
                    </wea:item>			
                </wea:group>
            </wea:layout>
        </div>
    </body>
</html>









