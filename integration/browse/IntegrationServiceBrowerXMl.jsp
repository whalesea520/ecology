<%@ page import="weaver.general.Util" %><%@ page import="weaver.common.util.xtree.TreeNode" %><%@ page import="java.util.*" %><%@ page import="weaver.hrm.*" %><%@ page import="weaver.hrm.company.CompanyTreeNode"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.systeminfo.*" %>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
%><jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" /><jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" /><jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" /><%

	//System.out.print("deptlevel"+deptlevel);
	TreeNode envelope=new TreeNode();
	envelope.setTitle("envelope");
	boolean exist=false;
    TreeNode root=new TreeNode();
    String companyname =CompanyComInfo.getCompanyname("1");
    root.setTitle(SystemEnv.getHtmlLabelName(30624 ,user.getLanguage()));
    root.setNodeId("com_0");
    root.setValue("");
    root.setTarget("_self"); 
    root.setIcon("/images/treeimages/global_wev8.gif");
    envelope.addTreeNode(root);
	RecordSet rs=new RecordSet();
	RecordSet rs02=new RecordSet();
	//1中间表的方式----dml数据源
	rs.execute("select * from dml_datasource ");
	while(rs.next())
	{
		//得到所有的数据源
		TreeNode jobTitleNode = new TreeNode();
		jobTitleNode.setTitle(rs.getString("sourcename"));
		jobTitleNode.setNodeId("1_"+rs.getString("hpid")+"" + "_"+rs.getString("id")+"_"+"0");
		jobTitleNode.setIcon("/images/treeimages/subCopany_Colse_wev8.gif");
		jobTitleNode.setValue(rs.getString("datasourceDes"));
		jobTitleNode.setOncheck("check(" + jobTitleNode.getNodeId() + ")");
		
		rs02.execute("select * from dml_service where poolid="+rs.getString("id"));
		while(rs02.next())
		{
			TreeNode jobTitleNode02 = new TreeNode();
			jobTitleNode02.setTitle(rs02.getString("regname"));
			jobTitleNode02.setNodeId("1_"+rs.getString("hpid")+"" + "_"+rs.getString("id")+"_"+rs02.getString("id"));
			jobTitleNode02.setIcon("/images/treeimages/subCopany_Colse_wev8.gif");
			jobTitleNode02.setCheckbox("Y");
			jobTitleNode02.setValue(rs02.getString("serdesc"));
			jobTitleNode02.setOncheck("check(" + jobTitleNode02.getNodeId() + ")");
			jobTitleNode.addTreeNode(jobTitleNode02);
		}
		root.addTreeNode(jobTitleNode);
	}
	
	//2webservice的方式--webservice数据源
	//查出该产品下的数据源
	rs.execute("select * from ws_datasource ");
	while(rs.next())
	{
		//得到所有的数据源
		TreeNode jobTitleNode = new TreeNode();
		jobTitleNode.setTitle(rs.getString("poolname"));
		jobTitleNode.setNodeId("2_"+rs.getString("hpid")+"" + "_"+rs.getString("id")+"_"+"0");
		jobTitleNode.setIcon("/images/treeimages/subCopany_Colse_wev8.gif");
		jobTitleNode.setValue(rs.getString("pooldesc"));
		jobTitleNode.setOncheck("check(" + jobTitleNode.getNodeId() + ")");
		rs02.execute("select * from ws_service where poolid="+rs.getString("id"));
		while(rs02.next())
		{
			TreeNode jobTitleNode02 = new TreeNode();
			jobTitleNode02.setTitle(rs02.getString("poolname"));
			jobTitleNode02.setNodeId("2_"+rs.getString("hpid")+"" + "_"+rs.getString("id")+"_"+rs02.getString("id"));
			jobTitleNode02.setIcon("/images/treeimages/subCopany_Colse_wev8.gif");
			jobTitleNode02.setCheckbox("Y");
			jobTitleNode02.setValue(rs02.getString("serdesc"));
			jobTitleNode02.setOncheck("check(" + jobTitleNode02.getNodeId() + ")");
			jobTitleNode.addTreeNode(jobTitleNode02);
		}
		root.addTreeNode(jobTitleNode);
	}
	
	//3RFC的方式---sap的数据源
	//查出该产品下的数据源
	rs.execute("select * from sap_datasource ");
	while(rs.next())
	{
		//得到所有的数据源
		TreeNode jobTitleNode = new TreeNode();
		jobTitleNode.setTitle(rs.getString("poolname"));
		jobTitleNode.setNodeId("3_"+rs.getString("hpid")+"" + "_"+rs.getString("id")+"_"+"0");
		jobTitleNode.setIcon("/images/treeimages/subCopany_Colse_wev8.gif");
		jobTitleNode.setValue(rs.getString("datasourceDes"));
		jobTitleNode.setOncheck("check(" + jobTitleNode.getNodeId() + ")");
		rs02.execute("select * from sap_service where poolid="+rs.getString("id"));
		while(rs02.next())
		{
			TreeNode jobTitleNode02 = new TreeNode();
			jobTitleNode02.setTitle(rs02.getString("regname"));
			jobTitleNode02.setNodeId("3_"+rs.getString("hpid")+"" + "_"+rs.getString("id")+"_"+rs02.getString("id"));
			jobTitleNode02.setIcon("/images/treeimages/subCopany_Colse_wev8.gif");
			jobTitleNode02.setCheckbox("Y");
			jobTitleNode02.setValue(rs02.getString("serdesc"));
			jobTitleNode02.setOncheck("check(" + jobTitleNode02.getNodeId() + ")");
			jobTitleNode.addTreeNode(jobTitleNode02);
		}
		root.addTreeNode(jobTitleNode);
	}
weaver.common.util.string.StringUtil.parseXml(out, envelope);
%>