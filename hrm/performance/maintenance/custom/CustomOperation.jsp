    <%@ page language="java" contentType="text/html; charset=GBK" %>
    <%@ page import="java.security.*,weaver.general.Util" %>
    <%@ page import="java.util.*" %>
    <%@ include file="/systeminfo/init.jsp" %>
    <jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
    <jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
    <%
    String inserttype=Util.null2String(request.getParameter("inserttype"));
    String edittype=Util.null2String(request.getParameter("edittype"));
    if (inserttype.equals("basic")){
    char separator = Util.getSeparator() ;
    String unitName=Util.fromScreen(request.getParameter("unitName"),user.getLanguage());
    String memo=Util.fromScreen(request.getParameter("memo"),user.getLanguage());
    String status=Util.null2String(request.getParameter("status"));
    if (status.equals("")) status="1";
    rs.execute("select * from HrmPerformanceCustom where unitName='"+unitName+"'");
    if (rs.next())
    {
     out.print("<script>alert('"+SystemEnv.getHtmlLabelName(195,user.getLanguage())+SystemEnv.getHtmlLabelName(18082,user.getLanguage())+"')</script>"); 
     out.print("<script>history.back(-1);</script>");
     return;
    }
    rs.execute("insert into HrmPerformanceCustom (unitName,memo,status) values('"+unitName+"','"+memo+"','"+status+"')");
    response.sendRedirect("CustomList.jsp");
    }
    
    if (edittype.equals("basic")){
    String id=Util.null2String(request.getParameter("mainid"));
    String unitName=Util.fromScreen(request.getParameter("unitName"),user.getLanguage());
    String memo=Util.fromScreen(request.getParameter("memo"),user.getLanguage());
    String status=Util.null2String(request.getParameter("status"));
    if (status.equals("")) status="1";
    if (status.equals("1"))
    {
    rs.execute("select unit  from HrmPerformanceTargetDetail where unit='"+id+"' ");
    rs1.execute("select unit  from HrmPerformanceGoal where unit='"+id+"' ");
   
    if (rs.next()||rs1.next())
    {
     out.print("<script>alert('"+SystemEnv.getHtmlLabelName(18588,user.getLanguage())+"')</script>"); 
     out.print("<script>history.back(-1);</script>");
     return;
    
    }
    }
    
    rs.execute("select * from HrmPerformanceCustom where unitName='"+unitName+"' and id!="+id);
    if (rs.next())
    {
     out.print("<script>alert('"+SystemEnv.getHtmlLabelName(195,user.getLanguage())+SystemEnv.getHtmlLabelName(18082,user.getLanguage())+"')</script>"); 
     out.print("<script>history.back(-1);</script>");
     return;
    }
    rs.execute("update HrmPerformanceCustom set unitName='"+unitName+"',memo='"+memo+"',status='"+status+"' where id="+id);
    response.sendRedirect("CustomEdit.jsp?id="+id);
    }
    
    %>
 