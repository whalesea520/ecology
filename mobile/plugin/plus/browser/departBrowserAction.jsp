<%@ page language="java" contentType="text/html;charset=GBK" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="java.lang.reflect.Method" %>
<%@ page import="java.lang.reflect.Constructor" %>
<%@ page import="weaver.hrm.company.DepartmentComInfo" %>
<%@ page import="weaver.hrm.company.SubCompanyComInfo" %>
<%@ page import="weaver.wxinterface.WxInterfaceInit"%>
<%@ page import="weaver.wxinterface.FormatMultiLang"%>
<%
//�жϱ���
if(WxInterfaceInit.isIsutf8()){
	response.setContentType("application/json;charset=UTF-8");
}
String action = Util.null2String(request.getParameter("action"));
JSONObject json = new JSONObject();
int status = 1;String msg = "";
try{
	if("getTreeData".equals(action)){
		int type = Util.getIntValue(request.getParameter("type"),1);//1.��˾ , 2�ֲ�, 3.����, 4.��Ա
		int selectType = Util.getIntValue(request.getParameter("selectType"),1);//1.����  2�ֲ�
		String pid = Util.null2String(request.getParameter("pid"));
		List<Map<String, Object>> datas = new ArrayList<Map<String,Object>>();
		//��������˷�Ȩ ��Ȩ�޵ķֲ��Ϳ��Բ鿴�ķֲ�  ��Ȩ�޵Ĳ��źͿ��Բ鿴�Ĳ��� �ַ����ö��ŷָ�
		String alllowsubcompanystr = "",alllowsubcompanyviewstr = "",alllowdepartmentstr = "",alllowdepartmentviewstr = "";
		boolean useAppDetach = false;//�Ƿ����÷�Ȩ
		try{
			Class pvm = Class.forName("weaver.hrm.appdetach.AppDetachComInfo");
			Constructor constructor = pvm.getConstructor(User.class);
			Object AppDetachComInfo = constructor.newInstance(user);
			Method m = pvm.getDeclaredMethod("isUseAppDetach");
			useAppDetach = (Boolean)m.invoke(AppDetachComInfo);
			if(useAppDetach){
				Method m1 = pvm.getDeclaredMethod("getAlllowsubcompanyviewstr");
				alllowsubcompanyviewstr = (String)m1.invoke(AppDetachComInfo);
				Method m2 = pvm.getDeclaredMethod("getAlllowdepartmentviewstr");
				alllowdepartmentviewstr = (String)m2.invoke(AppDetachComInfo);
				Method m3 = pvm.getDeclaredMethod("getAlllowsubcompanystr");
				alllowsubcompanystr = (String)m3.invoke(AppDetachComInfo);
				Method m4 = pvm.getDeclaredMethod("getAlllowdepartmentstr");
				alllowdepartmentstr = (String)m4.invoke(AppDetachComInfo);
			}
		}catch(Exception e){
			//e.printStackTrace();
		}
		if(type==1){
			pid = "0";
			datas.addAll(getSubCompanyByTree(pid,selectType,user,alllowsubcompanystr,alllowdepartmentstr,alllowsubcompanyviewstr,alllowdepartmentviewstr));
		}else if(type==2){
			if(selectType==1){
				datas.addAll(getDepartmentByTree("0", pid,user,alllowdepartmentstr,alllowdepartmentviewstr));
			}
			datas.addAll(getSubCompanyByTree(pid,selectType,user,alllowsubcompanystr,alllowdepartmentstr,alllowsubcompanyviewstr,alllowdepartmentviewstr));
		}else if(type==3&&selectType==1){
			datas.addAll(getDepartmentByTree(pid, null,user,alllowdepartmentstr,alllowdepartmentviewstr));
		}
		json.put("datas", JSONArray.fromObject(datas));
		status = 0;
	}else if("getSelectedDatas".equals(action)){
		String selectedIds = Util.null2String(request.getParameter("selectedIds"));
		int selectType = Util.getIntValue(request.getParameter("selectType"),1);//1.����  2�ֲ�
		DepartmentComInfo departmentComInfo = new DepartmentComInfo();
		SubCompanyComInfo sci = new SubCompanyComInfo();
		JSONArray selectedArr = new JSONArray();
		String[] selectedIdArr = selectedIds.split(",");
		for(String selectedId : selectedIdArr){
			if(!selectedId.trim().equals("")){
				String name = "";
				if(selectType==1){
					name = departmentComInfo.getDepartmentname(selectedId);//����
				}else{
					name = sci.getSubCompanyname(selectedId);
				}
				JSONObject selectedObj = new JSONObject();
				selectedObj.put("id", selectedId);	//id
				selectedObj.put("name", FormatMultiLang.formatByUserid(name,user.getUID()+""));//����
				selectedArr.add(selectedObj);
			}
		}
		json.put("datas", selectedArr);
		status = 0;
	}
}catch(Exception e){
	msg = "����ʧ��:"+e.getMessage();
}
json.put("status", status);
json.put("msg", msg);
//System.out.println(json.toString());
out.print(json.toString());
%>
<%!
private List<Map<String, Object>> getSubCompanyByTree(String pid,int selectType,User user,String alllowsubcompanystr,String alllowdepartmentstr,
		String alllowsubcompanyviewstr,String alllowdepartmentviewstr) throws Exception{
	List<Map<String, Object>> result = new ArrayList<Map<String,Object>>();
	SubCompanyComInfo subCompanyComInfo = new SubCompanyComInfo();
	subCompanyComInfo.setTofirstRow();
	while(subCompanyComInfo.next()){
		String supsubcomid = subCompanyComInfo.getSupsubcomid();
		if(supsubcomid==null||supsubcomid==""){
			supsubcomid = "0";
		}
		String canceled = subCompanyComInfo.getCompanyiscanceled();
		if(!supsubcomid.equals(pid) || "1".equals(canceled)){
			continue;
		}
		String id = subCompanyComInfo.getSubCompanyid();
		if((alllowsubcompanystr.length()>0 || alllowsubcompanyviewstr.length()>0)){
			if((","+alllowsubcompanystr+",").indexOf(","+id+",")==-1&&
				(","+alllowsubcompanyviewstr+",").indexOf(","+id+",")==-1) continue;
		}
        String name = subCompanyComInfo.getSubCompanyname();
        
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("id", id);
        map.put("name", FormatMultiLang.formatByUserid(name,user.getUID()+""));
        boolean hasChild = hasChildSubCompany(id,user,alllowsubcompanystr,alllowsubcompanyviewstr);
        if(selectType==1){//��Ҫչʾ���ŵĻ�
        	hasChild = hasChild||hasChildDepartment("0", id,user,alllowdepartmentstr,alllowdepartmentviewstr);
        }
        map.put("hasChild", hasChild);
        map.put("type", "2");
        result.add(map);
	}
	return result;
}
private List<Map<String, Object>> getDepartmentByTree(String pid, String _subcompanyid1,User user,String alllowdepartmentstr,String alllowdepartmentviewstr) throws Exception{
	List<Map<String, Object>> result = new ArrayList<Map<String,Object>>();
	DepartmentComInfo departmentComInfo = new DepartmentComInfo();
	departmentComInfo.setTofirstRow();
	while(departmentComInfo.next()){
		String supdepid = departmentComInfo.getDepartmentsupdepid();	//�ϼ�����id
		if(supdepid==null||supdepid.equals("")){
			supdepid = "0";
		}
		String subcompanyid1 = departmentComInfo.getSubcompanyid1();	//�ֲ�id
		String canceled = departmentComInfo.getDeparmentcanceled();
		if(!(supdepid.equals(pid) && (_subcompanyid1 == null || subcompanyid1.equals(_subcompanyid1)))
				|| "1".equals(canceled)){
			continue;
		}
		String id = departmentComInfo.getDepartmentid();
		if((alllowdepartmentstr.length()>0||alllowdepartmentviewstr.length()>0) ){
			if((","+alllowdepartmentstr+",").indexOf(","+id+",")==-1&&
					(","+alllowdepartmentviewstr+",").indexOf(","+id+",")==-1) continue;
		}
        String name = departmentComInfo.getDepartmentname();
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("id", id);
        map.put("name", FormatMultiLang.formatByUserid(name,user.getUID()+""));
        boolean hasChild = hasChildDepartment(id, _subcompanyid1,user,alllowdepartmentstr,alllowdepartmentviewstr);
        map.put("hasChild", hasChild);
        map.put("type", "3");
        result.add(map);
	}
	return result;
}
private boolean hasChildSubCompany(String pid,User user,String alllowsubcompanystr,String alllowsubcompanyviewstr) throws Exception{
	SubCompanyComInfo subCompanyComInfo = new SubCompanyComInfo();
	subCompanyComInfo.setTofirstRow();
	while(subCompanyComInfo.next()){
		String id = subCompanyComInfo.getSubCompanyid();
		if((alllowsubcompanystr.length()>0 || alllowsubcompanyviewstr.length()>0)){
			if((","+alllowsubcompanystr+",").indexOf(","+id+",")==-1&&
				(","+alllowsubcompanyviewstr+",").indexOf(","+id+",")==-1) continue;
		}
		String supsubcomid = subCompanyComInfo.getSupsubcomid();
		if(supsubcomid==null||supsubcomid==""){
			supsubcomid = "0";
		}
		String canceled = subCompanyComInfo.getCompanyiscanceled();
		if(supsubcomid.equals(pid) && (!"1".equals(canceled))){
			return true;
		}
	}
	return false;
}
private boolean hasChildDepartment(String pid, String _subcompanyid1,User user,String alllowdepartmentstr,String alllowdepartmentviewstr) throws Exception{
	DepartmentComInfo departmentComInfo = new DepartmentComInfo();
	departmentComInfo.setTofirstRow();
	while(departmentComInfo.next()){
		String id = departmentComInfo.getDepartmentid();
		if((alllowdepartmentstr.length()>0||alllowdepartmentviewstr.length()>0) ){
			if((","+alllowdepartmentstr+",").indexOf(","+id+",")==-1&&
					(","+alllowdepartmentviewstr+",").indexOf(","+id+",")==-1) continue;
		}
		String supdepid = departmentComInfo.getDepartmentsupdepid();	//�ϼ�����id
		if(supdepid==null||supdepid.equals("")){
			supdepid = "0";
		}
		String subcompanyid1 = departmentComInfo.getSubcompanyid1();	//�ֲ�id
		String canceled = departmentComInfo.getDeparmentcanceled();
		if((supdepid.equals(pid) && (_subcompanyid1 == null || subcompanyid1.equals(_subcompanyid1)))
				&& (!"1".equals(canceled))){
			return true;
		}
	}
	return false;
}
%>