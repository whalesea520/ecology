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
String isCompellentMark = StringUtils.trimToEmpty(request.getParameter("isCompellentMark"));
String isCancelCheck = StringUtils.trimToEmpty(request.getParameter("isCancelCheck"));
String isHideTheTraces = StringUtils.trimToEmpty(request.getParameter("isHideTheTraces"));
%>

<div id="wfTrace"  style="<%=tabIndex==7?"":"display:none;" %>" class="wfOfficalDoc">
    <wea:layout needImportDefaultJsAndCss="false">	
        <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
            <wea:item><%=SystemEnv.getHtmlLabelName(132414,user.getLanguage())%></wea:item>
            <wea:item>
                <input class="inputstyle" tzCheckbox="true" type="checkbox" name="isCompellentMark" onclick="onchangeIsCompellentMark()" value="1" <%if("1".equals(isCompellentMark)){%>checked<%}%> />
                <span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(21637,user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
            </wea:item>
            <wea:item><%=SystemEnv.getHtmlLabelName(132415,user.getLanguage())%></wea:item>
            <wea:item>
                <input class="inputstyle" tzCheckbox="true" type="checkbox" id="isCancelCheck" name="isCancelCheck" onclick="onchangeIsCancelCheck()" value="1" <%if("1".equals(isCompellentMark)){%>disabled<%}%> <%if("1".equals(isCancelCheck)){%>checked<%}%>/>
                <input type="hidden" name="isCancelCheckInput" value="<%if("1".equals(isCancelCheck)){%>1<%}else{%>0<%}%>" />	
                <span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(132416,user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
            </wea:item>
            <wea:item><%=SystemEnv.getHtmlLabelName(24443,user.getLanguage())%></wea:item>
            <wea:item>
                <input class="inputstyle" tzCheckbox="true" type="checkbox" name="isHideTheTraces"  value="1" <%if("1".equals(isHideTheTraces)){%>checked<%}%> />
                <span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(24444,user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
            </wea:item>
        </wea:group>
    </wea:layout>
</div>