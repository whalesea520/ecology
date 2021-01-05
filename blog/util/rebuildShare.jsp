<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="weaver.general.*" %>
<%@page import="weaver.conn.*"%>
<%@page import="weaver.blog.BlogCommonUtils"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%
	
	String opt = Util.null2String(request.getParameter("opt"));

    RecordSet rs = new RecordSet();
    RecordSet rs2 = new RecordSet();
    
    if("blog_share".equals(opt)) {
        String s = "update blog_share set content = ? where id = ? ";
        
        rs.executeQuery("select id, content from blog_share where type = 7");
        while(rs.next()) {
            String id = rs.getString("id");
            String content = rs.getString("content");
            content = "," + BlogCommonUtils.trimExtraComma(content) + ",";
            
            rs2.executeUpdate(s, content, id);
        }
    }
    
    if("blog_tempShare".equals(opt)) {
        String s = "update blog_tempShare set content = ? where id = ? ";
        
        rs.executeQuery("select id, content from blog_tempShare");
        while(rs.next()) {
            String id = rs.getString("id");
            String content = Util.null2String(rs.getString("content"));
            if(!content.startsWith(",")) {
            	content = BlogCommonUtils.formatComma(content);
            }
            
            rs2.executeUpdate(s, content, id);
        }
    }
%>
