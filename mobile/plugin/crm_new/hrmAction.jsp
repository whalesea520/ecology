<%@page import="weaver.hrm.company.CompanyComInfo"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@page import="weaver.hrm.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sourceforge.pinyin4j.PinyinHelper" %>
<%@ page import="net.sourceforge.pinyin4j.format.HanyuPinyinOutputFormat" %>
<%@ page import="net.sourceforge.pinyin4j.format.HanyuPinyinToneType" %>
<%@ page import="weaver.hrm.company.DepartmentComInfo" %>
<%@ page import="weaver.hrm.company.SubCompanyComInfo" %>
<%@ page import="weaver.hrm.job.JobTitlesComInfo" %>
<%@ page import="weaver.hrm.resource.ResourceComInfo" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.net.URLDecoder" %>

<%!
private List<Map<String, Object>> hrmList = null;
	
private void initHrmList(){
	if(hrmList == null){
		synchronized (Object.class) {
			if(hrmList == null){
				try{
					hrmList = new ArrayList<Map<String,Object>>();
					ResourceComInfo resourceComInfo = new ResourceComInfo();
					DepartmentComInfo departmentComInfo = new DepartmentComInfo();
					SubCompanyComInfo subCompanyComInfo = new SubCompanyComInfo();
					JobTitlesComInfo jobTitlesComInfo = new JobTitlesComInfo();
					HanyuPinyinOutputFormat pinyinOutputFormat = new HanyuPinyinOutputFormat();
					pinyinOutputFormat.setToneType(HanyuPinyinToneType.WITHOUT_TONE);
					while(resourceComInfo.next()){
						Map<String, Object> hrmMap = new HashMap<String, Object>();
						String id = resourceComInfo.getResourceid();	//id
						
						String status = resourceComInfo.getStatus();	//状态
						if(!status.equals("0") && !status.equals("1") && !status.equals("2") && !status.equals("3"))continue;	//过滤掉状态异常的人员
						
						String lastname = resourceComInfo.getLastname();	//姓名
						String lastname_py = "";	//拼音
						char[] lastnameArr = lastname.toCharArray();
						if(lastnameArr.length > 0){
							String[] pinyin = PinyinHelper.toHanyuPinyinStringArray(lastnameArr[0], pinyinOutputFormat);
							if(pinyin != null){
								// 只取一个发音，如果是多音字，仅取第一个发音
								lastname_py = pinyin[0];
							}else{
								// 如果c不是汉字，toHanyuPinyinStringArray会返回null
								lastname_py = Character.toString(lastnameArr[0]);
							}
							if(lastname_py.length() > 0){
								lastname_py = Character.toString(lastname_py.charAt(0)).toUpperCase();
							}
						}
						if(!lastname_py.matches("[A-Z]")){
							lastname_py = "#";
						}
						
						String subCompanyID = resourceComInfo.getSubCompanyID();	//分部id
						String subCompanyName = subCompanyComInfo.getSubCompanyname(subCompanyID);	//分部名称
						
						String departmentID = resourceComInfo.getDepartmentID();	//部门id
						String departmentName = departmentComInfo.getDepartmentname(departmentID);	//部门名称
						
						String jobTitle = resourceComInfo.getJobTitle();	//岗位id
						String jobTitlesName = jobTitlesComInfo.getJobTitlesname(jobTitle);	//岗位名称
						
						String shortname = "";
						if(lastname.length() > 2){
							shortname = lastname.substring(lastname.length() - 2);
						}else{
							shortname = lastname;
						}
						
						String mobile = resourceComInfo.getMobile();
						String email = resourceComInfo.getEmail();
						String managerid = resourceComInfo.getManagerID();
						
						hrmMap.put("id", id);	//id
						hrmMap.put("lastname", lastname);	//姓名
						hrmMap.put("shortname", shortname);	
						hrmMap.put("lastname_py", lastname_py);	//拼音
						//hrmMap.put("subCompanyID", subCompanyID);	//分部id
						hrmMap.put("subCompanyName", subCompanyName);	//分部名称
						hrmMap.put("departmentID", departmentID);	//部门id
						hrmMap.put("departmentName", departmentName);	//部门名称
						//hrmMap.put("jobTitle", jobTitle);	//岗位id
						hrmMap.put("jobTitlesName", jobTitlesName);	//岗位名称
						hrmMap.put("mobile", mobile);	//手机
						hrmMap.put("email", email);	//邮箱
						hrmMap.put("managerid", managerid);	//上级id
						hrmList.add(hrmMap);
						
					}
					Collections.sort(hrmList, new Comparator<Map<String, Object>>() {
						@Override
						public int compare(Map<String, Object> o1,
								Map<String, Object> o2) {
							int result;
							String lastname_py1 = Util.null2String(o1.get("lastname_py"));
							String lastname_py2 = Util.null2String(o2.get("lastname_py"));
							
							//特殊处理#
							if(lastname_py1.equals("#") && !lastname_py2.equals("#")){
								return 1;
							}else if(!lastname_py1.equals("#") && lastname_py2.equals("#")){
								return -1;
							}
							
							result = lastname_py1.compareTo(lastname_py2);
							if(result == 0){
								int id1 = Util.getIntValue(Util.null2String(o1.get("id")));
								int id2 = Util.getIntValue(Util.null2String(o2.get("id")));
								result = id1 -id2;
							}
							return result;
						}
					});
				}catch(Exception ex){
					ex.printStackTrace();
					throw new RuntimeException(ex);
				}
			}
		}
	}
}

private void clearCache(){
	if(hrmList != null){
		hrmList.clear();
		hrmList = null;
	}
}

private List<Map<String,Object>> queryHrms(String type, String searchKey, User user){
	initHrmList();
	
	List<Map<String,Object>> queryHrmList = new ArrayList<Map<String,Object>>();
	for(int i = 0; i < hrmList.size(); i++){
		Map<String, Object> hrmMap = hrmList.get(i);
		String lastname = (String)hrmMap.get("lastname");
		if(!searchKey.trim().equals("") && !lastname.contains(searchKey)){
			continue;
		}
		if(type.equals("dept")){
			String d = String.valueOf(user.getUserDepartment());
			String d2 = (String)hrmMap.get("departmentID");
			if(!d.equals(d2)){
				continue;
			}
		}else if(type.equals("my")){
			String u = String.valueOf(user.getUID());
			String u2 = (String)hrmMap.get("managerid");
			if(!u.equals(u2)){
				continue;
			}
		}
		queryHrmList.add(hrmMap);
	}
	return queryHrmList;
}

private List<Map<String, Object>> getSubCompanyByTree(String pid) throws Exception{
	List<Map<String, Object>> result = new ArrayList<Map<String,Object>>();
	
	SubCompanyComInfo subCompanyComInfo = new SubCompanyComInfo();
	while(subCompanyComInfo.next()){
		String supsubcomid = subCompanyComInfo.getSupsubcomid();
		String canceled = subCompanyComInfo.getCompanyiscanceled();
		if(!supsubcomid.equals(pid) || "1".equals(canceled)){
			continue;
		}
		String id = subCompanyComInfo.getSubCompanyid();
        String name = subCompanyComInfo.getSubCompanyname();
        
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("id", id);
        map.put("name", name);
        boolean hasChild = hasChildSubCompany(id) || hasChildDepartment("0", id);
        map.put("hasChild", hasChild);
        map.put("type", "2");
        result.add(map);
	}
	return result;
}

private boolean hasChildSubCompany(String pid) throws Exception{
	SubCompanyComInfo subCompanyComInfo = new SubCompanyComInfo();
	while(subCompanyComInfo.next()){
		String supsubcomid = subCompanyComInfo.getSupsubcomid();
		String canceled = subCompanyComInfo.getCompanyiscanceled();
		if(supsubcomid.equals(pid) && (!"1".equals(canceled))){
			return true;
		}
	}
	return false;
}

private List<Map<String, Object>> getDepartmentByTree(String pid, String _subcompanyid1) throws Exception{
	List<Map<String, Object>> result = new ArrayList<Map<String,Object>>();
	
	DepartmentComInfo departmentComInfo = new DepartmentComInfo();
	while(departmentComInfo.next()){
		String supdepid = departmentComInfo.getDepartmentsupdepid();	//上级部门id
		String subcompanyid1 = departmentComInfo.getSubcompanyid1();	//分部id
		String canceled = departmentComInfo.getDeparmentcanceled();
		if(!(supdepid.equals(pid) && (_subcompanyid1 == null || subcompanyid1.equals(_subcompanyid1)))
				|| "1".equals(canceled)){
			continue;
		}
		String id = departmentComInfo.getDepartmentid();
        String name = departmentComInfo.getDepartmentname();
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("id", id);
        map.put("name", name);
        boolean hasChild = hasChildDepartment(id, _subcompanyid1) || hasChildResource(id);
        map.put("hasChild", hasChild);
        map.put("type", "3");
        result.add(map);
	}
	
	return result;
}

private boolean hasChildDepartment(String pid, String _subcompanyid1) throws Exception{
	DepartmentComInfo departmentComInfo = new DepartmentComInfo();
	while(departmentComInfo.next()){
		String supdepid = departmentComInfo.getDepartmentsupdepid();	//上级部门id
		String subcompanyid1 = departmentComInfo.getSubcompanyid1();	//分部id
		String canceled = departmentComInfo.getDeparmentcanceled();
		if((supdepid.equals(pid) && (_subcompanyid1 == null || subcompanyid1.equals(_subcompanyid1)))
				&& (!"1".equals(canceled))){
			return true;
		}
	}
	return false;
}

private List<Map<String, Object>> getResourceByTree(String deptId) throws Exception{
	List<Map<String, Object>> result = new ArrayList<Map<String,Object>>();
	ResourceComInfo resourceComInfo = new ResourceComInfo();
	DepartmentComInfo departmentComInfo = new DepartmentComInfo();
	SubCompanyComInfo subCompanyComInfo = new SubCompanyComInfo();
	JobTitlesComInfo jobTitlesComInfo = new JobTitlesComInfo();
	while(resourceComInfo.next()){
        String departmentId = resourceComInfo.getDepartmentID();
        if(!departmentId.equals(deptId)) continue;
        String status = resourceComInfo.getStatus();
        if(status.equals("0") || status.equals("1") || status.equals("2") || status.equals("3")){
            String id = resourceComInfo.getResourceid();
            String name = resourceComInfo.getResourcename();
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("id", id);
            map.put("name", name);
            map.put("type", "4");
            
            
            String subCompanyID = resourceComInfo.getSubCompanyID();	//分部id
			String subCompanyName = subCompanyComInfo.getSubCompanyname(subCompanyID);	//分部名称
			
			String departmentID = resourceComInfo.getDepartmentID();	//部门id
			String departmentName = departmentComInfo.getDepartmentname(departmentID);	//部门名称
			
			String jobTitle = resourceComInfo.getJobTitle();	//岗位id
			String jobTitlesName = jobTitlesComInfo.getJobTitlesname(jobTitle);	//岗位名称
			
			String mobile = resourceComInfo.getMobile();
			String email = resourceComInfo.getEmail();
			
			map.put("lastname", name);
			map.put("subCompanyName", subCompanyName);	//分部名称
			map.put("departmentName", departmentName);	//部门名称
			map.put("jobTitlesName", jobTitlesName);	//岗位名称
			map.put("mobile", mobile);	//手机
			map.put("email", email);	//邮箱
            result.add(map);
        }
    }
	return result;
}

private boolean hasChildResource(String deptId) throws Exception{
	ResourceComInfo resourceComInfo = new ResourceComInfo();
	while(resourceComInfo.next()){
        String departmentId = resourceComInfo.getDepartmentID();
        String status = resourceComInfo.getStatus();
        if(departmentId.equals(deptId) && 
        		(status.equals("0") || status.equals("1") || status.equals("2") || status.equals("3"))){
        	return true;
        }
    }
	return false;
}
	
%>
<%
User user = MobileUserInit.getUser(request, response);
if(user == null){
	out.print("{\"status\":\"0\", \"errMsg\":\"用户失效,请请重新登录\"}");
	return;
}
String action = Util.null2String(request.getParameter("action"));
if("getListData".equals(action)){
	JSONObject resultObj = new JSONObject();
	try {
		//long curr = System.currentTimeMillis();
		String searchKey = "";
		try {
			searchKey = URLDecoder.decode(Util.null2String(request.getParameter("searchKey")), "utf-8");
		} catch (Exception e1) {
			e1.printStackTrace();
		}
		int pageNo = Util.getIntValue(request.getParameter("pageNo"), 1);
		int pageSize = Util.getIntValue(request.getParameter("pageSize"), 100);
		
		String type = Util.null2String(request.getParameter("type"));
		List<Map<String,Object>> queryHrmList = queryHrms(type, searchKey, user);
		
		int fromIndex = (pageNo - 1) * pageSize;
		int toIndex = pageNo * pageSize;
		if(toIndex > queryHrmList.size()){
			toIndex = queryHrmList.size();
		}
		List<Map<String,Object>> datas = queryHrmList.subList(fromIndex, toIndex);

		int totalSize = queryHrmList.size();

		//long curr2 = System.currentTimeMillis() - curr;
		
		
		//resultObj.put("time", curr2);
		resultObj.put("totalSize", totalSize);
		resultObj.put("datas", JSONArray.fromObject(datas));
		resultObj.put("status", "1");
	} catch (Exception ex) {
		ex.printStackTrace();
		resultObj.put("status", "0");
		resultObj.put("errMsg", ex.getMessage());
	}finally{
		try{
			out.print(resultObj.toString());
			out.flush();
		}catch(IOException ex){
			ex.printStackTrace();
		}
	}
}else if("clearCache".equals(action)){
	try {
		clearCache();
		out.println("Clear Cache Success!");
	} catch (IOException e) {
		e.printStackTrace();
	}
}else if("getTreeData".equals(action)){
	JSONObject resultObj = new JSONObject();
	try {
		
		String type = Util.null2String(request.getParameter("type"));	//1.公司 , 2分部, 3.部门, 4.人员
		String pid = Util.null2String(request.getParameter("pid"));
		
		List<Map<String, Object>> datas = new ArrayList<Map<String,Object>>();
		
		if(type.equals("1")){
			pid = "0";
			datas.addAll(getSubCompanyByTree(pid));
		}else if(type.equals("2")){
			datas.addAll(getSubCompanyByTree(pid));
			datas.addAll(getDepartmentByTree("0", pid));
		}else if(type.equals("3")){
			datas.addAll(getResourceByTree(pid));
			datas.addAll(getDepartmentByTree(pid, null));
		}
		
		resultObj.put("datas", JSONArray.fromObject(datas));
		resultObj.put("status", "1");
		
	}  catch (Exception ex) {
		ex.printStackTrace();
		resultObj.put("status", "0");
		resultObj.put("errMsg", ex.getMessage());
	}finally{
		try{
			out.print(resultObj.toString());
			out.flush();
		}catch(IOException ex){
			ex.printStackTrace();
		}
	}
}else if("getSelectedDatas".equals(action)){
	JSONObject resultObj = new JSONObject();
	try {
		JSONArray selectedArr = new JSONArray();
		String selectedIds = Util.null2String(request.getParameter("selectedIds")).trim();	//选中的id，逗号分隔，如：1,2,3
		if(!selectedIds.equals("")){
			ResourceComInfo resourceComInfo = new ResourceComInfo();
			DepartmentComInfo departmentComInfo = new DepartmentComInfo();
			SubCompanyComInfo subCompanyComInfo = new SubCompanyComInfo();
			JobTitlesComInfo jobTitlesComInfo = new JobTitlesComInfo();
			
			String[] selectedIdArr = selectedIds.split(",");
			for(String selectedId : selectedIdArr){
				if(!selectedId.trim().equals("")){
					
					String lastname = resourceComInfo.getLastname(selectedId);	//姓名
					String subCompanyID = resourceComInfo.getSubCompanyID(selectedId);	//分部id
					String subCompanyName = subCompanyComInfo.getSubCompanyname(subCompanyID);	//分部名称
					
					String departmentID = resourceComInfo.getDepartmentID(selectedId);	//部门id
					String departmentName = departmentComInfo.getDepartmentname(departmentID);	//部门名称
					
					String jobTitle = resourceComInfo.getJobTitle(selectedId);	//岗位id
					String jobTitlesName = jobTitlesComInfo.getJobTitlesname(jobTitle);	//岗位名称
					
					JSONObject selectedObj = new JSONObject();
					selectedObj.put("id", selectedId);	//id
					selectedObj.put("lastname", lastname);	//姓名
					selectedObj.put("subCompanyName", subCompanyName);	//分部名称
					selectedObj.put("departmentName", departmentName);	//部门名称
					selectedObj.put("jobTitlesName", jobTitlesName);	//岗位名称
					selectedArr.add(selectedObj);
				}
			}
		}
		resultObj.put("datas", selectedArr);
		resultObj.put("status", "1");
	} catch (Exception ex) {
		ex.printStackTrace();
		resultObj.put("status", "0");
		resultObj.put("errMsg", ex.getMessage());
	}finally{
		try{
			out.print(resultObj.toString());
			out.flush();
		}catch(IOException ex){
			ex.printStackTrace();
		}
	}
}else if("getCurrUser".equals(action)){
	JSONObject resultObj = new JSONObject();
	try {
		ResourceComInfo resourceComInfo = new ResourceComInfo();
		JSONObject dataObj = new JSONObject();
		dataObj.put("id", user.getUID());
		dataObj.put("lastname", user.getLastname());
		dataObj.put("avator", resourceComInfo.getMessagerUrls(""+user.getUID()));
		resultObj.put("data", dataObj);
		resultObj.put("status", "1");
	} catch (Exception ex) {
		ex.printStackTrace();
		resultObj.put("status", "0");
		resultObj.put("errMsg", ex.getMessage());
	}finally{
		try{
			out.print(resultObj.toString());
			out.flush();
		}catch(IOException ex){
			ex.printStackTrace();
		}
	}
}else if("getCompanyname".equals(action)){
	JSONObject resultObj = new JSONObject();
	try {
		CompanyComInfo companyComInfo = new CompanyComInfo();
		String companyname = companyComInfo.getCompanyname("1");	//公司名称
		JSONObject dataObj = new JSONObject();
		dataObj.put("companyname", companyname);
		resultObj.put("data", dataObj);
		resultObj.put("status", "1");
	} catch (Exception ex) {
		ex.printStackTrace();
		resultObj.put("status", "0");
		resultObj.put("errMsg", ex.getMessage());
	}finally{
		try{
			out.print(resultObj.toString());
			out.flush();
		}catch(IOException ex){
			ex.printStackTrace();
		}
	}
}

%>
