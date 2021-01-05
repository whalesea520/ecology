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
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="secCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />

<%
User user = HrmUserVarify.getUser(request,response);

int workflowId = Util.getIntValue(request.getParameter("workflowId"),-1);
String formID = StringUtils.trimToEmpty(request.getParameter("formId"));
String isbill = StringUtils.trimToEmpty(request.getParameter("isBill"));
int tabIndex = Util.getIntValue(request.getParameter("tabIndex"),1);
String isDialog = StringUtils.trimToEmpty(request.getParameter("isDialog"));

int tracefieldid=0;
int tracesavesecid=0;
int tracedocownertype=0;
int tracedocownerfieldid=0;
int tracedocowner=0;
String tracesavesecidspan="";
RecordSet.executeSql("select traceFieldId,traceSaveSecId,traceDocOwnerType,traceDocOwnerFieldId,traceDocOwner from workflow_base where id="+workflowId);
if(RecordSet.next()){
    tracefieldid = Util.getIntValue(RecordSet.getString("traceFieldId"),0);
    tracesavesecid = Util.getIntValue(RecordSet.getString("traceSaveSecId"),0);
    tracedocownertype = Util.getIntValue(RecordSet.getString("traceDocOwnerType"),0);
    tracedocownerfieldid = Util.getIntValue(RecordSet.getString("traceDocOwnerFieldId"),0);
    tracedocowner = Util.getIntValue(RecordSet.getString("traceDocOwner"),0);		  
}
String tracesavesecpath="-1,-1,"+tracesavesecid;
String tracedocownerstr=""+tracedocowner;
String tracedocownerspan = ResourceComInfo.getLastname(tracedocownerstr);

if(tracesavesecid>0){
    tracesavesecidspan = secCategoryComInfo.getAllParentName(String.valueOf(tracesavesecid),true);     
    tracesavesecidspan = tracesavesecidspan.replaceAll("<", "＜").replaceAll(">", "＞").replaceAll("&lt;", "＜").replaceAll("&gt;", "＞");
}
String sql_tmp = "";

%>

<script type="text/javascript">

jQuery(document).ready(function(){
	getDocProperties(<%=tracesavesecid %>,true);
});

</script>

<form name="tracePropDetailForm" id="tracePropDetailForm" method="post" action="WorkflowtracePropDetailOperation.jsp">
	<input type="hidden" id='isdialog' name='isdialog' value="<%=isDialog %>" />        
	<div id="wfTraceProp" style="<%=tabIndex==10?"":"display:none;" %>" class="wfOfficalDoc">
		<wea:layout needImportDefaultJsAndCss="false" attributes="{'expandAllGroup':'true'}">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(82751,user.getLanguage()) %>'>
				<wea:item><%=SystemEnv.getHtmlLabelNames("32712",user.getLanguage()) %></wea:item>
				<wea:item>
					<brow:browser name="tracesavesecpath" idKey="id" nameKey="path" viewType="0" hasBrowser="true" hasAdd="false" 
                        browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp" isMustInput="1" isSingle="true" hasInput="true" language='<%=""+user.getLanguage() %>'
                        temptitle='<%=SystemEnv.getHtmlLabelName(22220,user.getLanguage()) %>'
                        completeUrl="/data.jsp?type=categoryBrowser" _callback="onShowCatalogData_trace"  width="300px" browserValue='<%=tracesavesecpath %>' browserSpanValue='<%=tracesavesecidspan%>' />
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(129068,user.getLanguage())%></wea:item>
				<wea:item>
					<select id="tracedocownertype" name="tracedocownertype" onchange="onchangetracedocownertype(this.value)" style="float: left;">
						<option value="0"></option>
						<option value="1" <%if("1".equals(""+tracedocownertype)){out.println("selected");}%> ><%=SystemEnv.getHtmlLabelName(23122,user.getLanguage())%></option>
						<option value="2" <%if("2".equals(""+tracedocownertype)){out.println("selected");}%> ><%=SystemEnv.getHtmlLabelName(15549,user.getLanguage())%></option>
					</select>
					<span id="selecttracedocowner" name="selecttracedocowner" style="display:<%if(!"1".equals(""+tracedocownertype)){out.println("none");}%>">
						<brow:browser name="tracedocowner" viewType="0" hasBrowser="true" hasAdd="false" 
                            temptitle='<%=SystemEnv.getHtmlLabelName(179,user.getLanguage()) %>' language='<%=""+user.getLanguage() %>'
                            browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" isMustInput="1" isSingle="true" hasInput="true"
                            completeUrl="/data.jsp"  width="300px" browserValue='<%=tracedocownerstr %>' browserSpanValue='<%=tracedocownerspan %>' />
					</span>
					<select id="tracedocownerfieldid" name="tracedocownerfieldid" style="display:<%if(!"2".equals(""+tracedocownertype)){out.println("none");}%>">
						<%
                        
                        if("1".equals(isbill)){
                            sql_tmp = "select formField.id,fieldLable.labelName as fieldLable "
                                    + "from HtmlLabelInfo  fieldLable ,workflow_billfield  formField "
                                    + "where fieldLable.indexId=formField.fieldLabel "
                                    + "  and formField.billId= " + formID
                                    + "  and formField.viewType=0 "
                                    + "  and fieldLable.languageid =" + user.getLanguage()
                                    + " and formField.fieldHtmlType='3' and formField.type=1 order by formField.id";
                        }else{
                            sql_tmp = "select formDict.id, fieldLable.fieldLable "
                                    + "from workflow_fieldLable fieldLable, workflow_formField formField, workflow_formdict formDict "
                                    + "where fieldLable.formid = formField.formid and fieldLable.fieldid = formField.fieldid and formField.fieldid = formDict.ID and (formField.isdetail<>'1' or formField.isdetail is null) "
                                    + "and formField.formid = " + formID
                                    + " and fieldLable.langurageid = " + user.getLanguage()
                                    + " and formDict.fieldHtmlType='3' and formDict.type=1 order by formDict.id";
                        }
						RecordSet.executeSql(sql_tmp);
						while(RecordSet.next()){
							String fieldid_tmp = Util.null2String(RecordSet.getString("id"));
							String fieldlabel_tmp = Util.null2String(RecordSet.getString("fieldLable"));
							String selectedStr = "";
							if(!"".equals(""+tracedocownerfieldid) && fieldid_tmp.equals(""+tracedocownerfieldid)){
								selectedStr = " selected ";
							}
							out.println("<option value=\""+fieldid_tmp+"\" "+selectedStr+">"+fieldlabel_tmp+"</option>\n");
						}%>
					</select>    	
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelNames("129070",user.getLanguage()) %></wea:item>
				<wea:item>
					<select id="tracefieldid" name="tracefieldid" >
						<option value="0"></option>
						<%
						if("1".equals(isbill)){
							sql_tmp = "select formField.id,fieldLable.labelName as fieldLable "
									+ "from HtmlLabelInfo  fieldLable ,workflow_billfield  formField "
									+ "where fieldLable.indexId=formField.fieldLabel "
									+ "  and formField.billId= " + formID
									+ "  and formField.viewType=0 "
									+ "  and fieldLable.languageid =" + user.getLanguage()
									+ " and formField.fieldHtmlType='3' and formField.type=37 order by formField.id";
						}else{
							sql_tmp = "select formDict.id, fieldLable.fieldLable "
									+ "from workflow_fieldLable fieldLable, workflow_formField formField, workflow_formdict formDict "
									+ "where fieldLable.formid = formField.formid and fieldLable.fieldid = formField.fieldid and formField.fieldid = formDict.ID and (formField.isdetail<>'1' or formField.isdetail is null) "
									+ "and formField.formid = " + formID
									+ " and fieldLable.langurageid = " + user.getLanguage()
									+ " and formDict.fieldHtmlType='3' and formDict.type=37 order by formDict.id";
						}
						RecordSet.executeSql(sql_tmp);
						while(RecordSet.next()){
							String fieldid_tmp = Util.null2String(RecordSet.getString("id"));
							String fieldlabel_tmp = Util.null2String(RecordSet.getString("fieldLable"));
							String selectedStr = "";
							if(!"".equals(""+tracefieldid) && fieldid_tmp.equals(""+tracefieldid)){
								selectedStr = " selected ";
							}
							out.println("<option value=\""+fieldid_tmp+"\" "+selectedStr+">"+fieldlabel_tmp+"</option>\n");
						}%>
					</select> 
					<span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(128752,user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>		
				</wea:item>
			</wea:group>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(33329,user.getLanguage()) %>'>
				<wea:item attributes="{'isTableList':'true'}">
					<div id="tracePropDetailDiv"></div>
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
</form>