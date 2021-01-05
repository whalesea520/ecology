<%@ page import="weaver.general.Util"%><%@ page import="weaver.conn.*"%>
<%@ page import="weaver.workflow.ruleDesign.RuleBusiness"%>
<%@ page import="weaver.hrm.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%><%
  	int nodelinkid  =  Util.getIntValue(request.getParameter("nodelinkid")); //出口id
  	int workflowid =  Util.getIntValue(request.getParameter("workflowid")); //流程id
  	//System.out.println("workflowid=" + workflowid);
  	//System.out.println("nodelinkid=" + nodelinkid);
  	//int  nodelinkid  =  4543; //出口id
  	//int workflowid = 713; //流程id
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
User user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
  String allcondition=RuleBusiness.getConditionCnGz(nodelinkid, 1, user);
  %>
<%=allcondition %>