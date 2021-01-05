<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="org.apache.commons.lang.StringUtils"%> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rst" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="mailResourceService" class="weaver.email.service.MailResourceService" scope="page" />
<%
    if(!HrmUserVarify.checkUserRight("Email:monitor",user)){
    	response.sendRedirect("/notice/noright.jsp") ;
    }
%>
<%
	try{
		String ids = request.getParameter("ids");
		String clientIP = request.getRemoteAddr();
		String currentDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
		
        // 记录userid和删除的邮件
        Map<String, List<String>> map = new HashMap<String, List<String>>();
		rs.execute("select id ,subject ,resourceid from MailResource where " + Util.getSubINClause(ids, "id", "in"));
        String sql = "insert into MailLog(submiter, submitdate, logtype, clientip, subject) values (?, ?, ?, ?, ?)";
		while(rs.next()){
			rst.executeUpdate(sql, user.getUID(), currentDate, 0, clientIP, rs.getString("subject"));
            String resourceid = rs.getString("resourceid");
            String mailid = rs.getString("id");
            List<String> list = map.containsKey(resourceid) ? map.get(resourceid) : new ArrayList<String>();
			list.add(mailid);
            map.put(resourceid, list);
		}
		for(Map.Entry<String, List<String>> entry : map.entrySet()) {
            int userid =  Integer.parseInt(entry.getKey());
            String mailids = StringUtils.join(entry.getValue(), ",");
            mailResourceService.deleteMail(mailids, userid, "");
        }
	}catch(Exception e){
		logger.error(e);
	}
%>