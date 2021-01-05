    <%@ page language="java" contentType="text/html; charset=GBK" %>
    <%@ page import="java.security.*,weaver.general.Util" %>
    <%@ page import="java.util.*" %>
    <%@ page import="weaver.systeminfo.SystemEnv" %>
    <%@ include file="/systeminfo/init.jsp" %>
    <jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
    <jsp:useBean id="rsb" class="weaver.conn.RecordSet" scope="page" />
    <%
  
    String dtype=Util.null2String(request.getParameter("operationtype"));
    
    if (dtype.equals("insert")){
   
    String relatingFlow=Util.null2String(request.getParameter("relatingFlow"));
    String type_1=Util.null2String(request.getParameter("type_1"));
    rsb.execute("select * from HrmPerformanceFlow where type_1='"+type_1+"' ");
    if (rsb.next())
    {
    out.print("<script>alert('"+SystemEnv.getHtmlLabelName(18105,user.getLanguage())+"');history.back(-1);</script>");
    
    }
    else
    {
    rs.execute("insert into HrmPerformanceFlow (type_1,relatingFlow) values('"+type_1+"',"+relatingFlow+")");
    response.sendRedirect("FlowList.jsp");
    }
    
    }
  
    if (dtype.equals("edit")){
     String id=Util.null2String(request.getParameter("id"));
    String relatingFlow=Util.null2String(request.getParameter("relatingFlow"));
    String type_1=Util.null2String(request.getParameter("type_1"));
    rsb.execute("select * from HrmPerformanceFlow where type_1='"+type_1+"' and id!="+id);
    if (rsb.next())
    {
    out.print("<script>alert('"+SystemEnv.getHtmlLabelName(18105,user.getLanguage())+"');history.back(-1);</script>");
    
    }
    else
    {
    rs.execute("update HrmPerformanceFlow set type_1='"+type_1+"',relatingFlow="+relatingFlow+" where id="+id);
    response.sendRedirect("FlowList.jsp");
    }
    
    }
    
 
    
    
    %>
 