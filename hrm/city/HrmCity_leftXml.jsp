
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.common.util.xtree.TreeNode" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="ProvinceManager" class="weaver.hrm.province.ProvinceManager" scope="page" />
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;

	String pid=Util.null2String(request.getParameter("pid"));
	String init=Util.null2String(request.getParameter("init"));

	boolean exist = ProvinceComInfo.getProvincename(pid).length() > 0;

	TreeNode envelope=new TreeNode();
	envelope.setTitle("envelope");

	if(!init.equals("")&&exist){
		TreeNode root=new TreeNode();
		root.setTitle(SystemEnv.getHtmlLabelNames("332,800",user.getLanguage()));
		root.setNodeId("province_0");
		root.setTarget("_self"); 
		root.setHref("javascript:setCountry('province_0')");
		envelope.addTreeNode(root);
		ArrayList selectedList=new ArrayList();
		TreeNode node=new TreeNode();
		node.setNodeId("province_"+pid);
		selectedList.add(node);
		ProvinceManager.getCountryTree(envelope,selectedList,"");
	}else if(pid.equals("")){
		TreeNode root=new TreeNode();
		root.setTitle(SystemEnv.getHtmlLabelNames("332,800",user.getLanguage()));
		root.setNodeId("province_0");
		root.setTarget("_self");
		root.setHref("javascript:setProvince('province_0')");
		envelope.addTreeNode(root);
		ProvinceManager.getCountryTree(envelope,"0","",null,null);
	}
	//envelope.marshal(out);
	weaver.common.util.string.StringUtil.parseXml(out, envelope);
%>