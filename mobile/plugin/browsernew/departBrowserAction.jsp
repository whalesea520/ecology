<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="weaver.general.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="weaver.hrm.company.DepartmentComInfo" %>
<%@ page import="weaver.hrm.company.SubCompanyComInfo" %>
<%@ page import="weaver.hrm.appdetach.AppDetachComInfo" %>
<%
String action = Util.null2String(request.getParameter("action"));
JSONObject json = new JSONObject();
int status = 1;String msg = "";
try{
	if("getTreeData".equals(action)){
		int type = Util.getIntValue(request.getParameter("type"),1);//1.公司 , 2分部, 3.部门, 4.人员
		int selectType = Util.getIntValue(request.getParameter("selectType"),1);//1.部门  2分部
		String pid = Util.null2String(request.getParameter("pid"));
		List<Map<String, Object>> datas = new ArrayList<Map<String,Object>>();
		if(type==1){
			pid = "0";
			datas.addAll(getSubCompanyByTree(pid,selectType,user));
		}else if(type==2){
			datas.addAll(getSubCompanyByTree(pid,selectType,user));
			if(selectType==1){
				datas.addAll(getDepartmentByTree("0", pid,user));
			}
		}else if(type==3&&selectType==1){
			datas.addAll(getDepartmentByTree(pid, null,user));
		}
		json.put("datas", JSONArray.fromObject(datas));
		status = 0;
	}else if("getSelectedDatas".equals(action)){
		String selectedIds = Util.null2String(request.getParameter("selectedIds"));
		int selectType = Util.getIntValue(request.getParameter("selectType"),1);//1.部门  2分部
		DepartmentComInfo departmentComInfo = new DepartmentComInfo();
		SubCompanyComInfo sci = new SubCompanyComInfo();
		JSONArray selectedArr = new JSONArray();
		String[] selectedIdArr = selectedIds.split(",");
		for(String selectedId : selectedIdArr){
			if(!selectedId.trim().equals("")){
				String name = "";
				if(selectType==1){
					name = departmentComInfo.getDepartmentname(selectedId);//名称
				}else{
					name = sci.getSubCompanyname(selectedId);
				}
				JSONObject selectedObj = new JSONObject();
				selectedObj.put("id", selectedId);	//id
				selectedObj.put("name", name);//名称
				selectedArr.add(selectedObj);
			}
		}
		json.put("datas", selectedArr);
		status = 0;
	}
}catch(Exception e){
	msg = "操作失败:"+e.getMessage();
}
json.put("status", status);
json.put("msg", msg);
//System.out.println(json.toString());
out.print(json.toString());
%>
<%!
private List<Map<String, Object>> getSubCompanyByTree(String pid,int selectType,User user) throws Exception{
	List<Map<String, Object>> result = new ArrayList<Map<String,Object>>();
	SubCompanyComInfo subCompanyComInfo = new SubCompanyComInfo();
	AppDetachComInfo adci = new AppDetachComInfo();
	while(subCompanyComInfo.next()){
		String supsubcomid = subCompanyComInfo.getSupsubcomid();
		String canceled = subCompanyComInfo.getCompanyiscanceled();
		if(!supsubcomid.equals(pid) || "1".equals(canceled)){
			continue;
		}
		String id = subCompanyComInfo.getSubCompanyid();
		if(adci.checkUserAppDetach(id,"2",user)==0) continue;
        String name = subCompanyComInfo.getSubCompanyname();
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("id", id);
        map.put("name", name);
        boolean hasChild = hasChildSubCompany(id,user,adci);
        if(selectType==1){//需要展示部门的话
        	hasChild = hasChild||hasChildDepartment("0", id,user,adci);
        }
        map.put("hasChild", hasChild);
        map.put("type", "2");
        result.add(map);
	}
	return result;
}
private List<Map<String, Object>> getDepartmentByTree(String pid, String _subcompanyid1,User user) throws Exception{
	List<Map<String, Object>> result = new ArrayList<Map<String,Object>>();
	
	DepartmentComInfo departmentComInfo = new DepartmentComInfo();
	AppDetachComInfo adci = new AppDetachComInfo();
	while(departmentComInfo.next()){
		String supdepid = departmentComInfo.getDepartmentsupdepid();	//上级部门id
		String subcompanyid1 = departmentComInfo.getSubcompanyid1();	//分部id
		String canceled = departmentComInfo.getDeparmentcanceled();
		if(!(supdepid.equals(pid) && (_subcompanyid1 == null || subcompanyid1.equals(_subcompanyid1)))
				|| "1".equals(canceled)){
			continue;
		}
		String id = departmentComInfo.getDepartmentid();
		if(adci.checkUserAppDetach(id,"3",user)==0) continue;
        String name = departmentComInfo.getDepartmentname();
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("id", id);
        map.put("name", name);
        boolean hasChild = hasChildDepartment(id, _subcompanyid1,user,adci);
        map.put("hasChild", hasChild);
        map.put("type", "3");
        result.add(map);
	}
	return result;
}
private boolean hasChildSubCompany(String pid,User user,AppDetachComInfo adci) throws Exception{
	SubCompanyComInfo subCompanyComInfo = new SubCompanyComInfo();
	while(subCompanyComInfo.next()){
		String supsubcomid = subCompanyComInfo.getSupsubcomid();
		String canceled = subCompanyComInfo.getCompanyiscanceled();
		String id = subCompanyComInfo.getSubCompanyid();
		if(supsubcomid.equals(pid) && (!"1".equals(canceled))&&adci.checkUserAppDetach(id,"2",user)!=0){
			return true;
		}
	}
	return false;
}
private boolean hasChildDepartment(String pid, String _subcompanyid1,User user,AppDetachComInfo adci) throws Exception{
	DepartmentComInfo departmentComInfo = new DepartmentComInfo();
	while(departmentComInfo.next()){
		String supdepid = departmentComInfo.getDepartmentsupdepid();	//上级部门id
		String subcompanyid1 = departmentComInfo.getSubcompanyid1();	//分部id
		String canceled = departmentComInfo.getDeparmentcanceled();
		String id = departmentComInfo.getDepartmentid();
		if((supdepid.equals(pid) && (_subcompanyid1 == null || subcompanyid1.equals(_subcompanyid1)))
				&& (!"1".equals(canceled))&&adci.checkUserAppDetach(id,"3",user)!=0){
			return true;
		}
	}
	return false;
}
%>