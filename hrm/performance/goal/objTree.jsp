<%@ page language="java" contentType="text/xml; charset=GBK" %><%@ page import="java.util.*" %><%@ page import="weaver.general.Util" %><%@ page import="weaver.common.util.xtree.TreeNode" %><%@ page import="weaver.general.SessionOper" %><%@ page import="weaver.hrm.*,weaver.hrm.resource.*,weaver.hrm.company.*" %><jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/><?xml version="1.0" encoding="gbk"?><tree><%

response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response);
if(user == null)  return ;

String s = "";
int goalType = Util.getIntValue((String)SessionOper.getAttribute(session,"goalType"));
int rootObjId = ((Integer)SessionOper.getAttribute(session,"objId")).intValue();

/*
TD4194
modified by hubo,2006-04-19
*/
SubCompanyComInfo rsSubcompany = new SubCompanyComInfo();
DepartmentComInfo rsDepartment = new DepartmentComInfo();
ResourceComInfo rsHrm = new ResourceComInfo();
String supsubcomid = "";
String subcomid = "";
String subcomname = "";
String deptsubcompid = "";
String supdepid = "";
String departmentname = "";
String depid = "";
String hrmid = "";
String hrmname = "";
String hrmstatus = "";
String canceled = "";

switch(goalType){
	case 0:
		rsSubcompany.setTofirstRow();
		while(rsSubcompany.next()){
			supsubcomid = rsSubcompany.getSupsubcomid();
			if(!supsubcomid.equals(String.valueOf("0"))) continue;
			canceled = rsSubcompany.getCompanyiscanceled();
			if("1".equals(canceled)){
				continue;
			}
			subcomid = rsSubcompany.getSubCompanyid();
			//subcomname = rsSubcompany.getSubCompanyname(); 
			subcomname = rsSubcompany.getSubCompanyname().replaceAll("&","&amp;").replaceAll(" ","").replaceAll("<","&lt;").replaceAll(">","&gt;"); 
			s += "<tree text=\""+subcomname+"\" action=\""+subcomid+","+subcomname+",1\" icon=\"/images/treeimages/home16.gif\" />";
		}
		break;
	case 1:
		//Sub Company
		rsSubcompany.setTofirstRow();
		while(rsSubcompany.next()){
			supsubcomid = rsSubcompany.getSupsubcomid();
			if(!supsubcomid.equals(String.valueOf(rootObjId))) continue;
			canceled = rsSubcompany.getCompanyiscanceled();
			if("1".equals(canceled)){
				continue;
			}
			subcomid = rsSubcompany.getSubCompanyid();
			//subcomname = rsSubcompany.getSubCompanyname();
			subcomname = rsSubcompany.getSubCompanyname().replaceAll("&","&amp;").replaceAll(" ","").replaceAll("<","&lt;").replaceAll(">","&gt;"); 			
			s += "<tree text=\""+subcomname+"\" action=\""+subcomid+","+subcomname+",1\" icon=\"/images/treeimages/home16.gif\" />";
		}
		//Department
		rsDepartment.setTofirstRow();
		while(rsDepartment.next()){
			deptsubcompid = rsDepartment.getSubcompanyid1();
			if(!deptsubcompid.equals(String.valueOf(rootObjId))) continue;
			canceled = rsDepartment.getDeparmentcanceled();
			if("1".equals(canceled)){
				continue;
			}
			//departmentname = rsDepartment.getDepartmentname();
			departmentname = rsDepartment.getDepartmentname().replaceAll("&","&amp;").replaceAll(" ","").replaceAll("<","&lt;").replaceAll(">","&gt;");
			depid = rsDepartment.getDepartmentid();
			s += "<tree text=\""+departmentname+"\" action=\""+depid+","+departmentname+",2\" icon=\"/images/treeimages/dept16.gif\" />";
		}
		break;
	case 2:
		//Sub Department
		rsDepartment.setTofirstRow();
		while(rsDepartment.next()){
			supdepid = rsDepartment.getDepartmentsupdepid();
			if(!supdepid.equals(String.valueOf(rootObjId))) continue;
			canceled = rsDepartment.getDeparmentcanceled();
			if("1".equals(canceled)){
				continue;
			}
			//departmentname = rsDepartment.getDepartmentname();
			departmentname = rsDepartment.getDepartmentname().replaceAll("&","&amp;").replaceAll(" ","").replaceAll("<","&lt;").replaceAll(">","&gt;");
			depid = rsDepartment.getDepartmentid();
			s += "<tree text=\""+departmentname+"\" action=\""+depid+","+departmentname+",2\" icon=\"/images/treeimages/dept16.gif\" />";
		}
		//Personnel
		rsHrm.setTofirstRow();
		while(rsHrm.next()){
			depid = rsHrm.getDepartmentID();
			hrmstatus = rsHrm.getStatus();
			if(!depid.equals(String.valueOf(rootObjId)) || ("01238").indexOf(hrmstatus)==-1) continue;
			hrmid = rsHrm.getResourceid();
			//hrmname = rsHrm.getResourcename();
			hrmname = rsHrm.getResourcename().replaceAll("&","&amp;").replaceAll(" ","").replaceAll("<","&lt;").replaceAll(">","&gt;");
			s += "<tree text=\""+hrmname+"\" action=\""+hrmid+","+hrmname+",3\" icon=\"/images/treeimages/user16.gif\" />";
		}
		break;
}

out.print(s+"</tree>");
%>