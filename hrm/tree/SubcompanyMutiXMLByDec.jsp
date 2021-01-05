<%@ page import="weaver.general.Util" %><%@ page import="weaver.common.util.xtree.TreeNode" %><%@ page import="java.util.*" %><%@ page import="weaver.hrm.*" %><%@ page language="java" contentType="text/xml; charset=UTF-8" %><%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
%><jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" /><jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" /><jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" /><jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" /><jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" /><%
String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String subid=Util.null2String(request.getParameter("subid"));
boolean onlyselfdept=Util.null2String(request.getParameter("onlyselfdept")).equals("true")?true:false;

int isdetail = Util.getIntValue(request.getParameter("isdetail"),0);
int isbill = Util.getIntValue(request.getParameter("isbill"),0);
int fieldid = Util.getIntValue(request.getParameter("fieldid"),0);
int detachable = Util.getIntValue(request.getParameter("detachable"),0);

SubCompanyComInfo.setDetachable(detachable);
SubCompanyComInfo.setIsbill(isbill);
SubCompanyComInfo.setFieldid(fieldid);
SubCompanyComInfo.setIsdetail(isdetail);

TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");
int beagenter = Util.getIntValue((String)session.getAttribute("beagenter_"+user.getUID()));
if(beagenter <= 0){
	beagenter = user.getUID();
}
String isruledesign = Util.null2String(request.getParameter("isruledesign"));
boolean isadmin = false;
String adminsql = "select * from HrmResourceManager where id = " + beagenter;
RecordSet.executeSql(adminsql);
if(RecordSet.next()){
	isadmin = true;
}

if(isadmin && "true".equals(isruledesign)){
	beagenter = 1;
}

SubCompanyComInfo.getSubCompanyTreeListByDecRight(beagenter,"Subcompanys:decentralization",onlyselfdept);
TreeNode root=new TreeNode();
String companyname =CompanyComInfo.getCompanyname("1");
root.setTitle(companyname);
root.setNodeId("root_0");
root.setCheckbox("Y");
root.setOncheck("check(root_0)");
//root.setHref("javascript:setCompany(0)");
root.setTarget("_self");
root.setIcon("/images/treeimages/global_wev8.gif");
envelope.addTreeNode(root);
SubCompanyComInfo.getSubCompanyTreeListByDecRight(root,"0",0,20,false,"subcompanyMuti",null,null,onlyselfdept);
envelope.marshal(out);
%>