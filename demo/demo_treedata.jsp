<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.general.Util" %>
<%@page import="java.util.*,java.util.Map.*,"%>
<%@page import="weaver.common.util.xtree.TreeNode"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%
ArrayList lists = new ArrayList();
lists.add("{ id:\"q_0\", pId:\"\", name:\"Root0\",isParent:true,open:true}");
lists.add("{ id:\"q_1\", pId:\"q_0\", name:\"Root1\",isParent:false}");
lists.add("{ id:\"q_2\", pId:\"q_0\", name:\"Root2\",isParent:false}");
lists.add("{ id:\"q_3\", pId:\"q_0\", name:\"Root3\",isParent:false}");
lists.add("{ id:\"q_4\", pId:\"q_1\", name:\"Root4\",isParent:false}");
lists.add("{ id:\"q_5\", pId:\"q_2\", name:\"Root5\",isParent:false}");
lists.add("{ id:\"q_6\", pId:\"q_3\", name:\"Root6\",isParent:false}");
out.println("["+StringUtils.join(lists,",")+"]");
%>
