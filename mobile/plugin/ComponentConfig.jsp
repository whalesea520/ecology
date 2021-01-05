
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@page import="weaver.conn.*"%>
<%@ page import="java.util.*" %>
<%
	response.setContentType("application/json;charset=UTF-8");

	/*
	 * 1:待办
	 * 2:新闻
	 * 3:公告
	 * 4:日程
	 * 5:会议
	 * 6:通讯录
	 * 7:办结
	 * 8:已办
	 * 9:我的请求
	 * 10:抄送
	 * 11:微博
	 * 12:微信
	 * 13:邮件
	 * 14:协作
	 * 15:客户
	 * 16:微搜
	 */
	final String[] componentids = new String[] {"1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","-128"};
	Map result = new HashMap();
	result.put("componentids", componentids);
	
	//获取EMessage服务器地址
	RecordSet rs = new RecordSet();
	rs.executeSql("select 1 from ofProperty where name='weixin'");
	if(rs.next()){
		rs.executeSql("select propValue from ofProperty where name='xmpp.domain'");
		if(rs.next()){
			String ip = rs.getString("propValue");
			result.put("emessageServer", ip+"|true");
		}
	}
	
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo.toString());
%>
