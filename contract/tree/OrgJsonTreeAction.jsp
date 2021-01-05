<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.*"%>
<%@page import="java.util.*"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="treeOperate" class="weaver.contractn.serviceImpl.TreeOperateServiceImpl" scope="page" />

<%
String action = Util.null2String(request.getParameter("action"));//行为
String pid = Util.null2String(request.getParameter("pid"),"0");//相关id
if("".equals(action)){
	return ;
}
String sql = "";
//获取指定分部下的分部id
if(action.equals("getAllChildSubcompanyId")){
	JSONObject resultObj = new JSONObject();
	try{
		JSONArray datas = new JSONArray();
		JSONObject data = new JSONObject();
		if(pid.equals("0")){//一级分部
			sql = "select id from HrmSubCompany where companyid=1 and (supsubcomid=0 or supsubcomid is null) and (canceled<>1 or canceled is null) order by supsubcomid asc,showorder asc,subcompanyname asc";
		}else{//一级以后分部
			sql = "select id from HrmSubCompany where supsubcomid = "+pid+" and (canceled<>1 or canceled is null) order by supsubcomid asc,showorder asc,subcompanyname asc";
		}
		rs.executeSql(sql);
		while (rs.next()){
			String id = rs.getString("id");//子分部id
			data.put("id",id);
			data.put("name",SubCompanyComInfo.getSubCompanyname(id));
			
			//判断是否有子分部或部门--start
			boolean haschild = true;
			String childStr = Util.null2String(SubCompanyComInfo.getAllChildSubcompanyId(id,""),"");//子分部字符串
			if(!childStr.equals("")){//如果没有子分部，则去看是否有部门
				haschild = false;
			}else{
				rs1.executeSql("select id from HrmDepartment where subcompanyid1="+id+" and supdepid = 0 and (canceled = '0' or canceled is null)");
				if(rs1.next()){
					haschild = false;
				}
			}
			data.put("isLeaf",haschild);
			data.put("isDept",false);
			//判断是否有子分部或部门--end
			datas.add(data);
		}
		resultObj.put("status","1");
		resultObj.put("companyname",CompanyComInfo.getCompanyname("1"));
		resultObj.put("datas",datas);
	}catch(Exception e){
		e.printStackTrace();
		resultObj.put("status","0");
	}finally{
		out.print(resultObj.toString());
		out.flush();
	}
}else if(action.equals("getAllChildDepartmentIdBySubcompany")){//获取指定分部下的一级部门id
	JSONObject resultObj = new JSONObject();
	try{
		JSONArray datas = new JSONArray();
		JSONObject data = new JSONObject();
		sql = "select id from HrmDepartment where subcompanyid1="+pid+" and supdepid = 0 and (canceled = '0' or canceled is null) order by departmentname asc";
		rs.executeSql(sql);
		while (rs.next()){
			String id = rs.getString(1);
			data.put("id",id);
			data.put("name",DepartmentComInfo.getDepartmentname(id));
			//判断是否有子部门--start
			boolean haschild = true;
			String childStr = Util.null2String(DepartmentComInfo.getAllChildDepartId(id,""));
			if(!"".equals(childStr)) haschild = false;
			data.put("isLeaf",haschild);
			data.put("isDept",true);
			//判断是否有子部门--end
			datas.add(data);
		}
		
		/*增加查询下级分部信息 add by zl*/
		sql = "select id,subcompanyname from HrmSubCompany where (canceled = '0' or canceled is null) and supsubcomid = "+pid;
		rs.executeSql(sql);
		while(rs.next()){
			String id = rs.getString("id");
			String name = rs.getString("subcompanyname");
			data.put("id",id);
			data.put("name",name);
			//根据分部获取所有分部
			List<String> sub = treeOperate.queryAllSubCompanyIdStrBySubId(id);
			//获取分部获取部门
			List<String> dept = treeOperate.queryDetpIdStrBySubCompanyId(id);
			//treeOperate.queryTreeListById("org","sub_7");
			if(sub.size() == 0 && dept.size() == 0){
				data.put("isLeaf",true);
			}else{
				data.put("isLeaf",false);
			}
			data.put("isDept",false);
			datas.add(data);
		}
		resultObj.put("status","1");
		resultObj.put("datas",datas);
	}catch(Exception e){
		e.printStackTrace();
		resultObj.put("status","0");
	}finally{
		out.print(resultObj.toString());
		out.flush();
	}
}else if(action.equals("getAllChildDepartmentIdByDepartment")){//获取指定部门下的部门id
	JSONObject resultObj = new JSONObject();
	try{
		JSONArray datas = new JSONArray();
		JSONObject data = new JSONObject();
		sql = "select id from HrmDepartment where supdepid="+pid+" and (canceled = '0' or canceled is null) order by departmentname asc";
		rs.executeSql(sql);
		while(rs.next()){
			String id = rs.getString(1);
			data.put("id",id);
			data.put("name",DepartmentComInfo.getDepartmentname(id));
			//判断是否有子部门--start
			boolean haschild = true;
			String childStr = Util.null2String(DepartmentComInfo.getAllChildDepartId(id,""));
			if(!"".equals(childStr)) haschild = false;
			data.put("isLeaf",haschild);
			data.put("isDept",true);
			//判断是否有子部门--end
			datas.add(data);
		}
		resultObj.put("status","1");
		resultObj.put("datas",datas);
	}catch(Exception e){
		e.printStackTrace();
		resultObj.put("status","0");
	}finally{
		out.print(resultObj.toString());
		out.flush();
	}
}
%>
