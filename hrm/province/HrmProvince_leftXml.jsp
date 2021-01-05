
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.common.util.xtree.TreeNode" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="CountryManager" class="weaver.hrm.country.CountryManager" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;

	String cid=Util.null2String(request.getParameter("cid"));
	String init=Util.null2String(request.getParameter("init"));

	boolean exist = CountryComInfo.getCountryname(cid).length() > 0;

	TreeNode envelope=new TreeNode();
	envelope.setTitle("envelope");

	if(!init.equals("")&&exist){
		TreeNode root=new TreeNode();
		String titleName=SystemEnv.getHtmlLabelNames("332,377",user.getLanguage());
		root.setTitle(titleName);
		root.setNodeId("country_0");
		root.setTarget("_self"); 
		//root.setIcon("/images/treeimages/global_wev8.gif");
		root.setHref("javascript:setCountry('country_0')");
		envelope.addTreeNode(root);
		ArrayList selectedList=new ArrayList();
		TreeNode node=new TreeNode();
		node.setNodeId("country_"+cid);
		selectedList.add(node);
		CountryManager.getCountryTree(envelope,selectedList,"");
	}else if(cid.equals("")){
		TreeNode root=new TreeNode();
		String titleName=SystemEnv.getHtmlLabelNames("332,377",user.getLanguage());
		root.setTitle(titleName);
		root.setNodeId("country_0");
		root.setTarget("_self"); 
		//root.setIcon("/images/treeimages/global_wev8.gif");
		root.setHref("javascript:setCountry('country_0')");
		envelope.addTreeNode(root);
		String rootId="0";
		CountryManager.getCountryTree(envelope,rootId,0,3,"",null,null);
	}else{
		String rootId=cid;
		CountryManager.getCountryTree(envelope,rootId,0,2,"",null,null);
	}
	//envelope.marshal(out);
	weaver.common.util.string.StringUtil.parseXml(out, envelope);
%>