<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page import="org.apache.commons.lang.StringUtils"%>

<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.PageIdConst" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
User user = HrmUserVarify.getUser(request,response);

int workflowId = Util.getIntValue(request.getParameter("workflowId"),-1);
String formID = StringUtils.trimToEmpty(request.getParameter("formId"));
String isbill = StringUtils.trimToEmpty(request.getParameter("isBill"));
int tabIndex = Util.getIntValue(request.getParameter("tabIndex"),1);

String sqlWhere = "workflowId="+workflowId;
String intanceid="";			
String tabletype = "checkbox";
String operateString ="";
operateString += "<operates width=\"20%\">";
operateString+=" <popedom column=\"id\" transmethod=\"weaver.splitepage.operate.SpopForDoc.getPDFOpt\"></popedom> ";
operateString+="     <operate href=\"javascript:editPDFSet()\"  text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
operateString+="     <operate href=\"javascript:delPDFSet2()\"  text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
operateString+="</operates> ";
String tableString=""+
    "<table pageId=\"wf_pdf\" instanceid=\""+intanceid+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_SECCATEGORDEAULTRIGHT,user.getUID(),PageIdConst.DOC)+"\" tabletype=\""+tabletype+"\">"+
    "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlform=\"workflow_texttopdfconfig\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" /> ";
    tableString += operateString;
    tableString += "<head>";
    tableString += "<col width=\"20%\" transmethod=\"weaver.splitepage.operate.SpopForDoc.getNodename\"     text=\""+SystemEnv.getHtmlLabelName(19346,user.getLanguage())+"\" column=\"topdfnodeid\" otherpara=\""+user.getLanguage()+"\"  orderkey=\"topdfnodeid\"/>"+
        "<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(19347,user.getLanguage())+"\" column=\"operationtype\"  transmethod=\"weaver.splitepage.operate.SpopForDoc.getOperationtype\"  otherpara=\""+user.getLanguage()+"\"     orderkey=\"operationtype\"/>"+
        "<col width=\"20%\"  column=\"checktype\" text=\""+SystemEnv.getHtmlLabelName(1025,user.getLanguage())+"\"  transmethod=\"weaver.splitepage.operate.SpopForDoc.getChecktype\"  otherpara=\""+user.getLanguage()+"\"     orderkey=\"checktype\"/>"+
        "<col width=\"20%\" transmethod=\"weaver.splitepage.operate.SpopForDoc.getSavepath\" text=\""+SystemEnv.getHtmlLabelName(125966,user.getLanguage())+"\" column=\"catalogtype2\" otherpara=\""+user.getLanguage()+"+"+isbill+"+"+formID+"+column:pdfsavesecid+column:selectcatalog2\"  orderkey=\"catalogtype2\"/>"+
        "<col width=\"20%\" transmethod=\"weaver.splitepage.operate.SpopForDoc.getPdffieldName\"  otherpara=\""+user.getLanguage()+"+"+isbill+"+"+formID+"\" text=\""+SystemEnv.getHtmlLabelName(125967,user.getLanguage())+"\" column=\"pdffieldid\"   orderkey=\"pdffieldid\"/>"+
        "<col width=\"20%\" transmethod=\"weaver.splitepage.operate.SpopForDoc.getPdfdocstatus\" text=\""+SystemEnv.getHtmlLabelName(126111,user.getLanguage())+"\" column=\"pdfdocstatus\" otherpara=\""+user.getLanguage()+"+column:pdfdocstatus\"    orderkey=\"pdfdocstatus\"/>";
tableString +=	"</head>" + "</table>"; 
%> 

<div id="wfPDF" style="<%=tabIndex==9?"":"display:none;" %>" class="wfOfficalDoc">
    <wea:layout type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
        <wea:group context='<%=SystemEnv.getHtmlLabelName(125964,user.getLanguage())%>'>
			<wea:item type="groupHead">
				<input type="button" class="addbtn" onclick="addPDFSet(<%=formID %>,<%=isbill %>);"  title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
				<input type="button" class="delbtn" onclick="delPDFSet();" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
			</wea:item>
            <wea:item attributes="{\"isTableList\":\"true\"}">
                <input type="hidden" name="pageId" id="pageId" value="wf_pdf"/>
                <wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString %>' mode="run"  />
            </wea:item>
        </wea:group>
    </wea:layout>
</div>