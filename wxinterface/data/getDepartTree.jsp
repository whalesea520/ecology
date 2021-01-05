<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.*" %>
<%@ page import="net.sf.json.*"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.hrm.company.CompanyComInfo"%>
<%
	User user = HrmUserVarify.getUser (request , response) ;
	if(user==null||user.getUID()!=1){
		return;
	}
%>
<%
	response.setContentType("text/html;charset=GBK");
	int resourcetype = Util.getIntValue(request.getParameter("resourcetype"),1);
	String resourceids = Util.null2String(request.getParameter("resourceids"));
	JSONArray js = new JSONArray();
	try{
		CompanyComInfo companyInfo = new CompanyComInfo();
		JSONObject json = new JSONObject();
		json.put("id",0);
		json.put("pId",-1);
		json.put("name",companyInfo.getCompanyname("1"));
		json.put("open",true);
		json.put("nocheck", true);
		js.add(json);
		getDepartList(0,1,resourceids,resourcetype,js);
	}catch(Exception e){
		e.printStackTrace();
	}
	out.println(js.toString());
%>

<%!
public void getDepartList(int pid,int type,String resourceids,int resourcetype,JSONArray ja){
	RecordSet rs = new RecordSet();
	String getOrgSql = "";
	int ecorgtype = 1;
	if(type==1){//分部
		getOrgSql="select t1.id,t1.subcompanyname,t1.showorder from HrmsubCompany t1 "+
				  " where t1.supsubcomid ="+pid+" and (t1.canceled is null or t1.canceled !=1) order by t1.showorder";
	}else if(type==2){//分部下的部门
		ecorgtype=2;
		getOrgSql = "select t1.id,t1.departmentname,t1.showorder from HrmDepartment t1 "+
					" where t1.subcompanyid1 ="+pid+" and t1.supdepid not in (select id from HrmDepartment h2 where h2.subcompanyid1 ="+pid+") "+
					" and (t1.canceled is null or t1.canceled !=1)  order by t1.showorder";
	}else if(type==3){//部门下的部门
		ecorgtype=2;
		getOrgSql="select t1.id,t1.departmentname,t1.showorder from HrmDepartment t1 "+
				  " where t1.supdepid="+pid+" and (t1.canceled is null or t1.canceled !=1)  order by t1.showorder";
	}
	rs.execute(getOrgSql);
	while(rs.next()){
		int subid = rs.getInt(1);
		String orgName=rs.getString(2);
		int showorder = rs.getInt(3);
		JSONObject json = new JSONObject();
		String jsonid = "";
		if(ecorgtype==1){
			jsonid = subid+"";
		}else{
			jsonid = "dept_"+subid;
		}
		json.put("id",jsonid);
		json.put("subid",subid);
		if(type==3){
			json.put("pId", "dept_"+pid);
		}else{
			json.put("pId", pid);
		}
		json.put("ecorgtype", ecorgtype);
		json.put("name",orgName);
		json.put("showorder",showorder);
		if(null!=resourceids&&!resourceids.equals("")){
			if(resourceids.indexOf(","+subid+",")>-1){
				json.put("checked",true);
				json.put("open",true);
			}else{
				json.put("checked",false);
			}
		}
		if(resourcetype==2&&type==1){
			json.put("nocheck", true);
		}
		
		ja.add(json);
		if(resourcetype==2){//选择部门
			if(type==1){
				getDepartList(subid,2,resourceids,resourcetype,ja);
				getDepartList(subid,1,resourceids,resourcetype,ja);
			}else{
				getDepartList(subid,3,resourceids,resourcetype,ja);
			}
		}else{
			getDepartList(subid,1,resourceids,resourcetype,ja);
		}
	}
}
%>