<%@page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.file.*" %>
<%@page import="weaver.general.*" %>
<%@page import="weaver.hrm.*" %>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="java.util.*"%>
<%@page import="weaver.email.service.MailTemplateService"%>
<%@page import="weaver.email.MailCommonUtils"%>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%
    String opt = Util.null2String(request.getParameter("opt"));

    if(opt.isEmpty()) {
        return;
    }
    
    // 获取详细报错信息
    if("getErrorInfo".equals(opt)) {
        String id = Util.null2String(request.getParameter("id"));
        if(!id.isEmpty()) {
            String sql = "select errorInfo from mailWorkRemindLog where id = ?";
            rs.executeQuery(sql, id);
            if(rs.next()) {
                out.print(Util.toHtml(rs.getString("errorInfo")));
            }
        }
    }
    
    // 删除日志记录
    if("deleteErrorInfo".equals(opt)) {
        String ids = Util.null2String(request.getParameter("ids"));
        if(!ids.isEmpty()) {
            ids = MailCommonUtils.trim(ids);
            String sql = "delete from mailWorkRemindLog where " + Util.getSubINClause(ids, "id", "in");
            rs.executeUpdate(sql);
        }
    }
    
    // 清空全部
    if("deleteAll".equals(opt)) {
        String sql = "delete from mailWorkRemindLog";
        rs.executeUpdate(sql);
    }
%>