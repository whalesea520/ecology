
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.*" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>  
<jsp:useBean id="ebc" class="weaver.page.element.ElementBaseCominfo" scope="page"/>
<jsp:useBean id="esc" class="weaver.page.style.ElementStyleCominfo" scope="page" />
<jsp:useBean id="hpec" class="weaver.homepage.cominfo.HomepageElementCominfo" scope="page" />
<jsp:useBean id="eu" class="weaver.page.element.ElementUtil" scope="page" />
<jsp:useBean id="pm" class="weaver.page.PageCominfo" scope="page" />
<jsp:useBean id="wp" class="weaver.admincenter.homepage.WeaverPortal" scope="page"/>
<%
String pagetype = Util.null2String(request.getParameter("pagetype"));
String ebaseid = Util.null2String(request.getParameter("ebaseid"));
String eid = Util.null2String(request.getParameter("eid"));
String styleid = hpec.getStyleid(eid);
String hpid = Util.null2String(request.getParameter("hpid"));
int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"));
String eShare = pm.getConfig().getString("template.share");
StringBuffer strBuffer = new StringBuffer();
strBuffer.append("<div class=\"setting\" id=\"setting_");
strBuffer.append(eid);
strBuffer.append("\" operationurl=\"");
strBuffer.append(ebc.getOperation(ebaseid));
strBuffer.append("\">");
strBuffer.append("\n");
strBuffer.append("<div  class=\"weavertabs\">");
strBuffer.append("\n");
strBuffer.append("<table  class=\"weavertabs-nav\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">");
strBuffer.append("\n");
strBuffer.append("<tr>");
strBuffer.append("\n");
strBuffer.append("<td target=\"weavertabs-content-");
strBuffer.append(eid);
strBuffer.append("\">");
strBuffer.append(SystemEnv.getHtmlLabelName(345, user.getLanguage()));
strBuffer.append("</td>");
strBuffer.append("\n");
strBuffer.append("<td target=\"weavertabs-style-");
strBuffer.append(eid);
strBuffer.append("\">");
strBuffer.append(SystemEnv.getHtmlLabelName(1014, user.getLanguage()));
strBuffer.append("</td>");
strBuffer.append("\n");
if("true".equals(eShare)&&!pagetype.equals("loginview")){
strBuffer.append("<td target=\"weavertabs-share-");
strBuffer.append(eid);
strBuffer.append("\">");
strBuffer.append(SystemEnv.getHtmlLabelName(119, user.getLanguage()));
strBuffer.append("</td>");
}
strBuffer.append("\n");
strBuffer.append("</tr>");
strBuffer.append("\n");
strBuffer.append("</table>");
strBuffer.append("\n");
strBuffer.append("<div  class=\"weavertabs-content\">");
strBuffer.append("\n");
strBuffer.append("<div id=\"weavertabs-content-");
strBuffer.append(eid);
strBuffer.append("\" url=\"");
strBuffer.append(eu.getSetting(ebaseid,eid,styleid,hpid,subcompanyid,"content"));
strBuffer.append("\"></div>");
strBuffer.append("\n");
strBuffer.append("<div id=\"weavertabs-style-");
strBuffer.append(eid);
strBuffer.append("\" url=\"");
strBuffer.append(eu.getSetting(ebaseid,eid,styleid,hpid,subcompanyid,"style"));
strBuffer.append("\"></div>");
strBuffer.append("\n");
if("true".equals(eShare)&&!pagetype.equals("loginview")){
strBuffer.append("<div id=\"weavertabs-share-");
strBuffer.append(eid);
strBuffer.append("\" url=\"");
strBuffer.append(eu.getSetting(ebaseid,eid,styleid,hpid,subcompanyid,"share"));
strBuffer.append("\"></div>");
strBuffer.append("\n");
}
strBuffer.append("</div>");

strBuffer.append("\n");
strBuffer.append("<div class=\"setting_button_row\" align=\"center\">");
strBuffer.append("\n");
strBuffer.append("<A HREF=\"javascript:onUseSetting('");
strBuffer.append(eid);
strBuffer.append("','");
strBuffer.append(ebaseid);
strBuffer.append("')\">");
strBuffer.append(SystemEnv.getHtmlLabelName(19565, user.getLanguage()));
strBuffer.append("</A>");
strBuffer.append("\n");
strBuffer.append("&nbsp;&nbsp;&nbsp;");
strBuffer.append("\n");
strBuffer.append("<A HREF=\"javascript:onNoUseSetting('");
strBuffer.append(eid);
strBuffer.append("','");
strBuffer.append(ebaseid);
strBuffer.append("')\">");
strBuffer.append(SystemEnv.getHtmlLabelName(19566, user.getLanguage()));
strBuffer.append("</A>");
strBuffer.append("\n");
strBuffer.append("</div>");
strBuffer.append("\n");
strBuffer.append("</div>");
strBuffer.append("\n");
strBuffer.append("</div>");
//strBuffer.append("\n");
out.print(wp.getElementSetting(request));
%>

	