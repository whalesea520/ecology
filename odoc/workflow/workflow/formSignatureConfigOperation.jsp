<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="java.lang.*"%>
<%@ page import="java.util.*"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="org.apache.commons.lang.math.NumberUtils"%>

<%@ page import="weaver.odoc.workflow.workflow.beans.FormSignatueConfigInfo" %>
<%@ page import="weaver.odoc.workflow.workflow.beans.ShortCutButtonConfigInfo" %>

<jsp:useBean id="FormSignatureConfigUtil" class="weaver.odoc.workflow.workflow.utils.FormSignatureConfigUtil" scope="page" />

<%
    
    int id = NumberUtils.toInt(request.getParameter("id"),0);
    int workflowId = NumberUtils.toInt(request.getParameter("workflowId"),0);
    int nodeId = NumberUtils.toInt(request.getParameter("nodeId"),0);
    String synchAllNodes = StringUtils.trimToEmpty(request.getParameter("synchAllNodes"));
    int formSignatureWidth = NumberUtils.toInt(request.getParameter("formSignatureWidth"),512);
    int formSignatureHeight = NumberUtils.toInt(request.getParameter("formSignatureHeight"),200);
    String autoResizeSignImage = StringUtils.trimToEmpty(request.getParameter("autoResizeSignImage"));
    String defaultSignType = StringUtils.trimToEmpty(request.getParameter("defaultSignType"));
    String defaultOpenSignType = StringUtils.trimToEmpty(request.getParameter("defaultOpenSignType"));
    String defaultColor = StringUtils.trimToEmpty(request.getParameter("defaultColor"));
    String defaultFontWidth = StringUtils.trimToEmpty(request.getParameter("defaultFontWidth"));
	int defaultFont = NumberUtils.toInt(request.getParameter("defaultFont"),1);
    int defaultFontSize = NumberUtils.toInt(request.getParameter("defaultFontSize"),59);
    String defaultSignSource = StringUtils.trimToEmpty(request.getParameter("defaultSignSource"));
    String shortCutButtonConfig = StringUtils.trimToEmpty(request.getParameter("shortCutButtonConfig"));
    
    FormSignatueConfigInfo formSignatueConfig = new FormSignatueConfigInfo();
    formSignatueConfig.setId(id);
    formSignatueConfig.setWorkflowId(workflowId);
    formSignatueConfig.setNodeId(nodeId);
    formSignatueConfig.setSynchAllNodes("true".equals(synchAllNodes));
    formSignatueConfig.setFormSignatureWidth(formSignatureWidth);
    formSignatueConfig.setFormSignatureHeight(formSignatureHeight);
    formSignatueConfig.setAutoResizeSignImage("true".equals(autoResizeSignImage));
    formSignatueConfig.setDefaultSignType(defaultSignType);
    formSignatueConfig.setDefaultOpenSignType(defaultOpenSignType);
    formSignatueConfig.setDefaultColor(defaultColor);
    formSignatueConfig.setDefaultFontWidth(defaultFontWidth);
    formSignatueConfig.setDefaultFont(defaultFont);
    formSignatueConfig.setDefaultFontSize(defaultFontSize);
    formSignatueConfig.setDefaultSignatureSource(defaultSignSource);
    formSignatueConfig.setShortCutButtonConfig((List<ShortCutButtonConfigInfo>)JSONArray.toCollection(JSONArray.fromObject(shortCutButtonConfig), ShortCutButtonConfigInfo.class));
    
    boolean ret = FormSignatureConfigUtil.saveFormSignatueConfig(formSignatueConfig);
    JSONObject obj = new JSONObject();
    obj.put("res", ret ? "1" : "0");
    out.print(obj.toString());

%>