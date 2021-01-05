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
String signatureNodes = StringUtils.trimToEmpty(request.getParameter("signatureNodes"));
int tabIndex = Util.getIntValue(request.getParameter("tabIndex"),1);

int tempNodeId = 0;
String tempNodeName ="";
%>

<div id="wfSignature"  style="<%=tabIndex==5?"":"display:none;" %>" class="wfOfficalDoc">
    <wea:layout type="table" needImportDefaultJsAndCss="false" attributes="{'cols':'2','cws':'30%,70%'}">
        <wea:group context="" attributes="{'groupDisplay':'none'}">
            <wea:item type="thead"><%=SystemEnv.getHtmlLabelNames("15070",user.getLanguage())%></wea:item>
            <wea:item type="thead"><%=SystemEnv.getHtmlLabelNames("26472,21650",user.getLanguage())%></wea:item>
        <%
            RecordSet.executeQuery("select a.nodeId,b.nodeName,a.nodeType from  workflow_flownode a,workflow_nodebase b where (b.IsFreeNode is null or b.IsFreeNode!='1') and a.nodeId=b.id and a.workflowId=? and a.nodeType!=3 order by a.nodeType asc,a.nodeId asc", workflowId);
            while(RecordSet.next()){ 
                tempNodeId = RecordSet.getInt("nodeId");
                tempNodeName = StringUtils.trimToEmpty(RecordSet.getString("nodeName"));
        %>
            <wea:item><%=tempNodeName %></wea:item>
            <wea:item><input name="signatureNodes" <%=(","+signatureNodes+",").indexOf(""+tempNodeId)!=-1?"checked":"" %> type="checkbox" tzCheckbox="true" value='<%=tempNodeId %>'/></wea:item>
        <%
            } 
        %>
        </wea:group>
    </wea:layout>
</div>