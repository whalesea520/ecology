<%@ page import="weaver.general.Util" %><%@ page import="weaver.common.util.xtree.TreeNode" %><%@ page import="java.util.*" %><%@ page import="weaver.hrm.*" %><%@ page language="java" contentType="text/xml ; charset=UTF-8" %><%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
%><jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" /><jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" /><jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" /><jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" /><%
String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String subid=Util.null2String(request.getParameter("subid"));
boolean onlyselfdept=Util.null2String(request.getParameter("onlyselfdept")).equals("true")?true:false;
int deptlevel = Util.getIntValue(request.getParameter("deptlevel"),2);
TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");
int beagenter = Util.getIntValue((String)session.getAttribute("beagenter_"+user.getUID()));
if(beagenter <= 0){
	beagenter = user.getUID();
}
SubCompanyComInfo.getSubCompanyTreeListByDecRight(beagenter,"Departments:decentralization",onlyselfdept);
if(id.equals("")){
TreeNode root=new TreeNode();
String companyname =CompanyComInfo.getCompanyname("1");
root.setTitle(companyname);
root.setNodeId("com_0");
root.setCheckbox("Y");
root.setValue("0");
root.setOncheck("check(com_0)");
root.setTarget("_self");
root.setIcon("/images/treeimages/global_wev8.gif");
envelope.addTreeNode(root);
if(onlyselfdept){
    SubCompanyComInfo.getSubCompanyTreeListByDecRight(root,"0",0,99,true,"departmentMulti",null,null,onlyselfdept);
}else{
    SubCompanyComInfo.getSubCompanyTreeListByDecRight(root,"0",0,3,true,"departmentMulti",null,null,onlyselfdept);
}
}else{
  int leve=2;
  if(deptlevel!=0){
	  leve=deptlevel;
	}
  if(onlyselfdept){
      leve=99;
  }
  if(type.equals("com"))
    SubCompanyComInfo.getSubCompanyTreeListByDecRight(envelope,id,0,leve,true,"departmentMulti",null,null,onlyselfdept);
  else
    SubCompanyComInfo.getDepartTreeListByDec(envelope,subid,id,0,leve,"departmentMulti",null,null,onlyselfdept);
}
envelope.marshal(out);
%>
