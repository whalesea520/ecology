<%@ page import="weaver.general.Util" %><%@ page import="weaver.common.util.xtree.TreeNode" %><%@ page import="java.util.*" %><%@ page import="weaver.hrm.*" %><%@ page language="java" contentType="text/html; charset=UTF-8" %><%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
%><jsp:useBean id="SubCompanyVirtualComInfo" class="weaver.hrm.companyvirtual.SubCompanyVirtualComInfo" scope="page" /><jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" /><jsp:useBean id="DepartmentVirtualComInfo" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page" /><%
String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String nodeids=Util.null2String(request.getParameter("nodeids"));
String init=Util.null2String(request.getParameter("init"));
String subid=Util.null2String(request.getParameter("subid"));
String virtualtype=Util.null2String(request.getParameter("virtualtype"));
int deptlevel = Util.getIntValue(request.getParameter("deptlevel"),2);
if(deptlevel==0){
	deptlevel=2;
}
TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");
String companyname = CompanyComInfo.getCompanyname("1");
TreeNode root=new TreeNode();
root.setTitle(companyname);
root.setNodeId("com_"+virtualtype);
root.setIcon("/images/treeimages/global_wev8.gif");
root.setCheckbox("Y");
root.setValue("0");
root.setOncheck("check(com_"+virtualtype+")");

String[] tmpids=Util.TokenizerString2(nodeids,"|");
nodeids = "";
for(int i=0;i<tmpids.length;i++){
	if(tmpids[i].indexOf("dept")>-1){
		String depid = tmpids[i].substring(tmpids[i].lastIndexOf("_")+1);
		if(Util.getIntValue(depid)<-1){
			if(nodeids.length()>0)nodeids+="|";
			nodeids+=tmpids[i];
		}
	}
}

if(id.equals("")&&nodeids.equals("")){
envelope.addTreeNode(root);
SubCompanyVirtualComInfo.getAppDetachSubCompanyTreeList(root,virtualtype,"0",0,deptlevel,true,"departmentMulti",null,null,user);
}else if(!nodeids.equals("")){
envelope.addTreeNode(root);
ArrayList l=new ArrayList();
String[] ids=Util.TokenizerString2(nodeids,"|");
for(int i=0;i<ids.length;i++){
boolean exist=false;
if(ids[i].indexOf("dept")>-1){
String deptname=DepartmentVirtualComInfo.getDepartmentname(ids[i].substring(ids[i].lastIndexOf("_")+1));
String subcom=DepartmentVirtualComInfo.getSubcompanyid1(ids[i].substring(ids[i].lastIndexOf("_")+1));
    if(!deptname.equals("")&&subcom.equals(ids[i].substring(ids[i].indexOf("_")+1,ids[i].lastIndexOf("_"))))
       exist=true;
    else
      exist=false;
}
if(exist){
//System.out.println("ids:"+ids[i]);
TreeNode node=new TreeNode();
node.setNodeId(ids[i]);
l.add(node);
}
}
SubCompanyVirtualComInfo.getAppDetachSubCompanyTreeList(root,virtualtype,true,"departmentMulti",l,user); 

}else{
  if(type.equals("com")){
    SubCompanyVirtualComInfo.getAppDetachSubCompanyTreeList(envelope,virtualtype,id,0,deptlevel,true,"departmentMulti",null,null,user);
  }else{
    SubCompanyVirtualComInfo.getAppDetachDepartTreeList(envelope,subid,id,0,deptlevel,"departmentMulti",null,null,user);
  }
}
//envelope.marshal(out);
weaver.common.util.string.StringUtil.parseXml(out, envelope);
%>
