    <%@ page language="java" contentType="text/html; charset=GBK" %>
    <%@ page import="java.security.*,weaver.general.Util" %>
    <%@ page import="java.util.*" %>
    <%@ include file="/systeminfo/init.jsp" %>
    <jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
    <%
    String from=Util.null2String((String)session.getAttribute("from"));
    String deltype=Util.null2String(request.getParameter("type"));
    String inserttype=Util.null2String(request.getParameter("inserttype"));
    String edittype=Util.null2String(request.getParameter("edittype"));
    if (inserttype.equals("basic")){
    char separator = Util.getSeparator() ;
    String planName=Util.fromScreen(request.getParameter("planName"),user.getLanguage());
    String sort=Util.null2o(request.getParameter("sort"));
    String headers=Util.fromScreen(request.getParameter("headers"),user.getLanguage());
    String para="planid";
    String id="";
    rs.executeProc("GetMaxId_PRO",para);   
    if (rs.next()){
    id = ""+rs.getInt(1);
   }
    rs.execute("select * from HrmPerformancePlanKind where planName='"+planName+"' ");
    if (rs.next())
    {
     out.print("<script>alert('"+SystemEnv.getHtmlLabelName(195,user.getLanguage())+SystemEnv.getHtmlLabelName(18082,user.getLanguage())+"')</script>"); 
     out.print("<script>history.back(-1);</script>");
     return;
    }
    rs.execute("insert into HrmPerformancePlanKind (id,headers,planName,sort) values("+id+",'"+headers+"','"+planName+"',"+sort+")");
    response.sendRedirect("PlanEdit.jsp?id="+id);
    }
    
    if (edittype.equals("basic")){
    String planName=Util.fromScreen(request.getParameter("planName"),user.getLanguage());
    String sort=Util.null2o(request.getParameter("sort"));
    String id=Util.null2String(request.getParameter("mainid"));
    String headers=Util.fromScreen(request.getParameter("headers"),user.getLanguage());
     rs.execute("select * from HrmPerformancePlanKind where planName='"+planName+"' and id!="+id);
    if (rs.next())
    {
     out.print("<script>alert('"+SystemEnv.getHtmlLabelName(195,user.getLanguage())+SystemEnv.getHtmlLabelName(18082,user.getLanguage())+"')</script>"); 
     out.print("<script>history.back(-1);</script>");
     return;
    }
    rs.execute("update HrmPerformancePlanKind set headers='"+headers+"',planName='"+planName+"',sort="+sort+" where id="+id);
    response.sendRedirect("PlanEdit.jsp?id="+id);
    }
    
    if (inserttype.equals("detail")){
    String planName=Util.fromScreen(request.getParameter("planName"),user.getLanguage());
    String sort=Util.null2o(request.getParameter("sort"));
    String headers=Util.fromScreen(request.getParameter("headers"),user.getLanguage());
    String id=Util.null2String(request.getParameter("mainid"));
     rs.execute("select * from HrmPerformancePlanKindDetail where planName='"+planName+"' and  PlanId="+id);
    if (rs.next())
    {
     out.print("<script>alert('"+SystemEnv.getHtmlLabelName(195,user.getLanguage())+SystemEnv.getHtmlLabelName(18082,user.getLanguage())+"')</script>"); 
     out.print("<script>history.back(-1);</script>");
     return;
    }
    
    rs.execute("insert into HrmPerformancePlanKindDetail(PlanId,headers,planName,sort) values("+id+",'"+headers+"','"+planName+"',"+sort+") ");
    if (from.equals("1"))
    {
    response.sendRedirect("PlanEdit.jsp?id="+id);
    }
    else
    {
    response.sendRedirect("PlanDetailList.jsp?mainid="+id);
    }
    }
    
    if (edittype.equals("detail")){
    String planName=Util.fromScreen(request.getParameter("planName"),user.getLanguage());
    String sort=Util.null2o(request.getParameter("sort"));
    String headers=Util.fromScreen(request.getParameter("headers"),user.getLanguage());
    String mainid=Util.null2String(request.getParameter("mainid"));
    String id=Util.null2String(request.getParameter("id"));
    rs.execute("select * from HrmPerformancePlanKindDetail where planName='"+planName+"' and  PlanId="+mainid+" and id!="+id);
    if (rs.next())
    {
     out.print("<script>alert('"+SystemEnv.getHtmlLabelName(195,user.getLanguage())+SystemEnv.getHtmlLabelName(18082,user.getLanguage())+"')</script>"); 
     out.print("<script>history.back(-1);</script>");
     return;
    }
    rs.execute("update  HrmPerformancePlanKindDetail set headers='"+headers+"',planName='"+planName+"',sort="+sort+" where id="+id );
    if (from.equals("1"))
    {
    response.sendRedirect("PlanEdit.jsp?id="+mainid);
    }
    else
    {
    response.sendRedirect("planDetailList.jsp?mainid="+mainid);
    }
    }
    if (deltype.equals("detaildel"))
    {
    String id=Util.null2String(request.getParameter("id"));
    String mainid=Util.null2String(request.getParameter("mainid"));
    rs.execute("delete from  HrmPerformancePlanKindDetail where id="+id);
    if ((from.equals("1")||(Util.null2String(request.getParameter("from"))).equals("1")))
    {
    response.sendRedirect("PlanEdit.jsp?id="+mainid);
    }
    else
    {
    response.sendRedirect("PlanDetailList.jsp?mainid="+mainid);
    }
    }
    %>
 