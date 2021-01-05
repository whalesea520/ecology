<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>

<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="PrjSettingsComInfo" class="weaver.cpt.util.CptSettingsComInfo" scope="page" />

<%
User user=HrmUserVarify.getUser(request, response);
if(user==null){
	return;
}


StringBuilder sb=new StringBuilder();
sb.append(" UPDATE cpt_barcodesettings")
.append(" SET subcompanyid = -1")
.append(" ,departmentid = -1")
.append(" ,userid = -1")
.append(" ,isopen = '" + Util.null2String(request.getParameter("isopen")) + "'")
.append(" ,barType = '" + Util.null2String(request.getParameter("barType")) + "'")
.append(" ,code = '"+Util.null2String(request.getParameter("code"))+"'")
.append(" ,width = '"+Util.null2String(request.getParameter("width"))+"'")
.append(" ,height = '"+Util.null2String(request.getParameter("height"))+"'")
.append(" ,st = '"+("y".equals( Util.null2String(request.getParameter("st")))?"y":"n")+"'")
.append(" ,textFont = '"+Util.null2String(request.getParameter("textFont"))+"'")
.append(" ,fontColor = '"+Util.null2String(request.getParameter("fontColor"))+"'")
.append(" ,barColor = '"+Util.null2String(request.getParameter("barColor"))+"'")
.append(" ,backColor = '"+Util.null2String(request.getParameter("backColor"))+"'")
.append(" ,rotate = '"+Util.null2String(request.getParameter("rotate"))+"'")
.append(" ,barHeightCM = '" + Util.null2String(request.getParameter("barHeightCM")) + "'")
.append(" ,x = '"+Util.null2String(request.getParameter("x"))+"'")
.append(" ,n = '"+Util.null2String(request.getParameter("n"))+"'")
.append(" ,leftMarginCM = '"+Util.null2String(request.getParameter("leftMarginCM"))+"'")
.append(" ,topMarginCM = '"+Util.null2String(request.getParameter("topMarginCM"))+"'")
.append(" ,checkCharacter = '"+("y".equals( Util.null2String(request.getParameter("checkCharacter")))?"y":"n")+"'")
.append(" ,checkCharacterInText = '"+("y".equals( Util.null2String(request.getParameter("checkCharacterInText")))?"y":"n")+"'")
.append(" ,Code128Set = '"+Util.null2String(request.getParameter("Code128Set"))+"'")
.append(" ,UPCESytem = '"+Util.null2String(request.getParameter("UPCESytem"))+"'")
.append(" ,isopen2 = '"+Util.null2String(request.getParameter("isopen2"))+"'")
.append(" ,barType2 = '"+Util.null2String(request.getParameter("barType2"))+"'")
.append(" ,width2 = '"+Util.null2String(request.getParameter("width2"))+"'")
.append(" ,height2 = '"+Util.null2String(request.getParameter("height2"))+"'")
.append(" ,st2 = '"+Util.null2String(request.getParameter("st2"))+"'")
.append(" ,textFont2 = '"+Util.null2String(request.getParameter("textFont2"))+"'")
.append(" ,content2type = '"+Util.null2String(request.getParameter("content2type"))+"'")
.append(" ,content2 = '"+Util.null2String(request.getParameter("content2"))+"'")
.append(" ,link2 = '"+Util.null2String(request.getParameter("link2"))+"'")
.append(" WHERE id=-1")

;

rs.executeSql(sb.toString());

PrjSettingsComInfo.removeCache();


%>