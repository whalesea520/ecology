
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.common.util.xtree.TreeNode" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	
	TreeNode tree = new TreeNode();
	tree.setTitle("Tree");
	
    rs.execute("select * from worktask_base order by orderid");
    TreeNode node = null;
 	while(rs.next()){
 		node = new TreeNode();
		node.setTitle(rs.getString("name"));
		node.setNodeId(rs.getString("id"));
		node.setHref("javascript:setCategory('" + node.getNodeId() + "')");
		node.setTarget("_self");
		tree.addTreeNode(node);
 	}
 	if(node == null){
 		node = new TreeNode();
		node.setTitle(SystemEnv.getHtmlLabelName(83553,user.getLanguage())+"！");
		node.setNodeId("0");
		node.setHref("javascript:setCategory('0')");
		node.setTarget("_self");
		tree.addTreeNode(node);
 	}
	
	weaver.common.util.string.StringUtil.parseXml(out, tree);
%>