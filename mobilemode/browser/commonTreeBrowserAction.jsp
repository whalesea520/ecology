<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sourceforge.pinyin4j.PinyinHelper" %>
<%@ page import="net.sourceforge.pinyin4j.format.HanyuPinyinCaseType" %>
<%@ page import="net.sourceforge.pinyin4j.format.HanyuPinyinOutputFormat" %>
<%@ page import="net.sourceforge.pinyin4j.format.HanyuPinyinToneType" %>
<%@ page import="weaver.hrm.company.DepartmentComInfo" %>
<%@ page import="weaver.hrm.company.SubCompanyComInfo" %>
<%@ page import="weaver.hrm.job.JobTitlesComInfo" %>
<%@ page import="weaver.hrm.resource.ResourceComInfo" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="weaver.conn.RecordSet"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@ page import = "weaver.formmode.tree.*" %>
<%
String action = Util.null2String(request.getParameter("action"));
if("getTreeData".equals(action)){
	String type = Util.null2String(request.getParameter("type"));
	String data_id = "";
	String selectedids = "";
	try {
		data_id = URLDecoder.decode(Util.null2String(request.getParameter("pid")), "utf-8");
		selectedids = URLDecoder.decode(Util.null2String(request.getParameter("selectedIds")), "utf-8");
	} catch (Exception e1) {
		e1.printStackTrace();
	}
	String showtype = Util.null2String(request.getParameter("showtype"));
	String isselsub = Util.null2String(request.getParameter("isselsub"));
	String isonlyleaf = Util.null2String(request.getParameter("isonlyleaf"));
	
    CustomTreeData CustomTreeData = new CustomTreeData();
	User user = MobileUserInit.getUser(request, response);
    CustomTreeData.setUser(user);
    
    Map map = new HashMap();
    map.put("id",type);
    map.put("init","false");
    map.put("pid",data_id);
    map.put("showtype",showtype);
    map.put("isselsub",isselsub);
    map.put("isonlyleaf","1");
    map.put("selectedids","");
    map.put("treerootnode","");
    
	JSONObject resultObj = new JSONObject();
	try {
		List<Map<String, Object>> datas = new ArrayList<Map<String,Object>>();
		JSONArray jsonArray = CustomTreeData.getTreeDataByMap(map);
		
		for (Object object : jsonArray) {
  			JSONObject o = JSONObject.fromObject(object);
    		Map<String, Object> map1 = new HashMap<String, Object>();
    		
    		map1.put("id", Util.null2String(o.get("id")));
        	map1.put("name", Util.null2String(o.get("name")));
        	map1.put("lastname", Util.null2String(o.get("name")));
        	boolean hasChild = false;
        	int childNum = Util.getIntValue(Util.null2String(o.get("childNum")));
        	if(childNum>0){
        		hasChild = true;
        	}
       	    map1.put("hasChild", hasChild);
       	    map1.put("type", type);
       	    datas.add(map1);
		}
		
		JSONArray selectedArr = new JSONArray();
		String selectedIds = selectedids.trim();	//选中的id，逗号分隔，如：1,2,3
		if(!selectedIds.equals("")){
			List<Map> list = CustomTreeData.getSelectedDatas(type,selectedIds);
			for(Map map2 :list){
				JSONObject selectedObj = new JSONObject();
				selectedObj.put("id", Util.null2String(map2.get("id")));	
				selectedObj.put("lastname", Util.null2String(map2.get("name")));
				selectedArr.add(selectedObj);
			}
		}
		resultObj.put("datas", JSONArray.fromObject(datas));
		resultObj.put("sel_datas", selectedArr);
		String refsql = "select * from mode_customtree where id =" + type;
		RecordSet rs = new RecordSet();
		rs.execute(refsql);
		if(rs.next()){
			resultObj.put("isonlyleaf", Util.null2String(rs.getString("isonlyleaf")));
		}
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
	String browserId = Util.null2String(request.getParameter("_browserId"));
	String browserName = Util.null2String(request.getParameter("_browserName"));
	JSONObject resultObj = new JSONObject();
	CustomTreeData CustomTreeData = new CustomTreeData();
	try {
		JSONArray selectedArr = new JSONArray();
		String selectedIds = Util.null2String(request.getParameter("selectedIds")).trim();	//选中的id，逗号分隔，如：1,2,3
		//System.out.println("selectedIds:"+selectedIds);
		List<Map> list = CustomTreeData.getSelectedDatas(browserName,selectedIds);
		for(Map map :list){
			JSONObject selectedObj = new JSONObject();
			selectedObj.put("id", Util.null2String(map.get("id")));	
			selectedObj.put("lastname", Util.null2String(map.get("name")));
			selectedArr.add(selectedObj);
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
}else if("getTreeInitData".equals(action)){
	String browserId = Util.null2String(request.getParameter("_browserId"));
	String browserName = Util.null2String(request.getParameter("_browserName"));
	JSONObject resultObj = new JSONObject();
	
	try {
		String refsql = "select * from mode_customtree where id =" + browserName;
		RecordSet rs = new RecordSet();
		rs.execute(refsql);
		if(rs.next()){
			resultObj.put("rootname", Util.null2String(rs.getString("rootname")));
			resultObj.put("isselsub", Util.null2String(rs.getString("isselsub")));
		}
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
