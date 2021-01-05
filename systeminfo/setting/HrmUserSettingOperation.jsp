
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.setting.HrmUserSettingHandler" %>
<%@ page import="weaver.systeminfo.setting.HrmUserSetting" %>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.systeminfo.setting.HrmUserSettingComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%

int userid=0;
userid=user.getUID();

int id = Util.getIntValue(request.getParameter("id"));
String rtxOnload = Util.null2String(request.getParameter("rtxOnload"));
String isPageAutoWrap = Util.null2String(request.getParameter("isPageAutoWrap"));
String belongtoshow = Util.null2String(request.getParameter("belongtoshow"));

String isCoworkHead = Util.null2String(request.getParameter("isCoworkHead"));

cutoverWay = Util.null2String(request.getParameter("cutoverWay"));
transitionTime = Util.null2String(request.getParameter("TransitionTime"));
transitionWay = Util.null2String(request.getParameter("TransitionWay"));

rtxOnload=rtxOnload.equals("1")?"1":"0";
isPageAutoWrap=isPageAutoWrap.equals("1")?"1":"0";
belongtoshow=belongtoshow.equals("1")?"1":"0";
isCoworkHead=isCoworkHead.equals("1")?"1":"0";

String sql="update HrmUserSetting set belongtoshow="+belongtoshow+", isPageAutoWrap="+isPageAutoWrap+", rtxOnload="+rtxOnload+",isCoworkHead="+isCoworkHead + ", cutoverWay='" + cutoverWay + "', transitionTime='" + transitionTime + "', transitionWay='" + transitionWay + "' where id="+id;

RecordSet recordSet=new RecordSet();
recordSet.execute(sql);

//删除缓存
HrmUserSettingComInfo userSetting=new HrmUserSettingComInfo();
userSetting.removeHrmUserSettingComInfoCache();

response.sendRedirect("HrmUserSettingEdit.jsp");
%>
