<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="weaver.general.*" %>
<%@page import="weaver.conn.*"%>
<%@page import="java.io.File"%>
<%@page import="com.alibaba.fastjson.JSONArray"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="com.alibaba.fastjson.JSONObject"%>
<%@page import="weaver.file.FileUpload"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
	String opt = Util.null2String(request.getParameter("opt"));

	FileUpload fu = new FileUpload(request);
	
	if("dptStat".equals(opt)) {
	    String ids = Util.null2String(fu.getParameter("ids"));
	    String workdate = Util.null2s(fu.getParameter("workdate"), TimeUtil.getCurrentDateString());
	    Map<String, Object> resultMap = getStatistics(ids, workdate);
	    resultMap.put("workdate", workdate);
	    
	    out.print(JSONObject.toJSONString(resultMap));
	}


%>

<%!

public Map<String, Object> getStatistics(String ids, String workdate) {
    Map<String, Object> resultMap = new HashMap<String, Object>();
    
    RecordSet rs = new RecordSet();
    
    Set<String> allUsers = new LinkedHashSet<String>();
    allUsers.addAll(Util.TokenizerString(ids, ","));
    resultMap.put("total", allUsers.size());  //总人数

    Set<String> writtenUsers = new HashSet<String>();
    String sql = "select userid from blog_discuss where workdate = ? and " + Util.getSubINClause(ids, "userid", "in");
    rs.executeQuery(sql, workdate);
    while(rs.next()) {
        writtenUsers.add(rs.getString("userid"));
    }
    
    allUsers.removeAll(writtenUsers);
    Set<String> unWrittenUsers = allUsers;
    
    resultMap.put("writtenCount", writtenUsers.size());
    resultMap.put("writtenUsers", getUserInfos(writtenUsers));
    resultMap.put("unRrittenCount", unWrittenUsers.size());
    resultMap.put("unRrittenUsers", getUserInfos(unWrittenUsers));
    
    return resultMap;
}

public List<Object> getUserInfos(Set<String> userSet) {
    List<Object> list = new ArrayList<Object>();
    
    ResourceComInfo rsi = null;
    try {
        rsi = new ResourceComInfo();
    }catch (Exception e) {
        e.printStackTrace();
    }
    
    for(String userid : userSet) {
        Map<String, String> map = new HashMap<String, String>();
        map.put("id", userid);
        map.put("lastname", rsi.getLastname(userid));
        list.add(map);
    }
    
    return list;
}
%>
