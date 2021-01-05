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
    String gradeNmae=Util.fromScreen(request.getParameter("gradeName"),user.getLanguage());
    String memo=Util.fromScreen(request.getParameter("memo"),user.getLanguage());
    String source=Util.null2String(request.getParameter("source"));
    String status=Util.null2String(request.getParameter("status"));
    if (status.equals("")) status="1";

    String para="gradeid";
    String id="";
    rs.executeProc("GetMaxId_PRO",para);   
    if (rs.next()){
    id = ""+rs.getInt(1);
   }
    rs.execute("select * from HrmPerformanceGrade where gradeName='"+gradeNmae+"'");
    if (rs.next())
    {
     out.print("<script>alert('"+SystemEnv.getHtmlLabelName(195,user.getLanguage())+SystemEnv.getHtmlLabelName(18082,user.getLanguage())+"')</script>"); 
     out.print("<script>history.back(-1);</script>");
     return;
    }
    rs.execute("insert into HrmPerformanceGrade (id,gradeName,memo,source,status) values("+id+",'"+gradeNmae+"','"+memo+"','"+source+"','"+status+"')");
    response.sendRedirect("GradeEdit.jsp?id="+id);
    }
    
    if (edittype.equals("basic")){
    String id=Util.null2String(request.getParameter("mainid"));
    String name=Util.fromScreen(request.getParameter("gradeName"),user.getLanguage());
    String memo=Util.fromScreen(request.getParameter("memo"),user.getLanguage());
    String status=Util.null2String(request.getParameter("status"));
    String source=Util.null2String(request.getParameter("source"));
    if (status.equals("")) status="1";
    rs.execute("select * from HrmPerformanceGrade where gradeName='"+name+"' and id!="+id);
    if (rs.next())
    {
     out.print("<script>alert('"+SystemEnv.getHtmlLabelName(195,user.getLanguage())+SystemEnv.getHtmlLabelName(18082,user.getLanguage())+"')</script>"); 
     out.print("<script>history.back(-1);</script>");
     return;
    }
    rs.execute("update HrmPerformanceGrade set gradeName='"+name+"',memo='"+memo+"',status='"+status+"',source='"+source+"' where id="+id);
    response.sendRedirect("GradeEdit.jsp?id="+id);
    }
    
    if (inserttype.equals("detail")){
    String grade=Util.fromScreen(request.getParameter("grade"),user.getLanguage());
    String condition1=Util.null2String(request.getParameter("condition1"));
    String condition2=Util.null2String(request.getParameter("condition2"));
    String id=Util.null2String(request.getParameter("mainid"));

    rs.execute("select * from HrmPerformanceGradeDetail where gradeId="+id+" and condition1="+condition1+" and condition2="+condition2);

    if (rs.next())
    {
    out.print("<script>alert('"+SystemEnv.getHtmlLabelName(18400,user.getLanguage())+"');</script>");
    out.print("<script>history.back(-1);</script>");
    return; 
    }
    rs.execute("insert into HrmPerformanceGradeDetail(gradeId,grade,condition1,condition2) values("+id+",'"+grade+"',"+condition1+","+condition2+") ");
    if (from.equals("1"))
    {
    response.sendRedirect("GradeEdit.jsp?id="+id);
    }
    else
    {
    response.sendRedirect("GradeDetailList.jsp?mainid="+id);
    }
    }
    
    if (edittype.equals("detail")){
    String grade=Util.fromScreen(request.getParameter("grade"),user.getLanguage());
    String condition1=Util.null2String(request.getParameter("condition1"));
    String condition2=Util.null2String(request.getParameter("condition2"));
    String mainid=Util.null2String(request.getParameter("mainid"));
    String id=Util.null2String(request.getParameter("id"));
    rs.execute("update  HrmPerformanceGradeDetail set grade='"+grade+"',condition1="+condition1+",condition2="+condition2+" where id="+id );
    if (from.equals("1"))
    {
    response.sendRedirect("GradeEdit.jsp?id="+mainid);
    }
    else
    {
    response.sendRedirect("GradeDetailList.jsp?mainid="+mainid);
    }
    }
    if (deltype.equals("detaildel"))
    {
    String id=Util.null2String(request.getParameter("id"));
    String mainid=Util.null2String(request.getParameter("mainid"));
    rs.execute("delete from  HrmPerformanceGradeDetail where id="+id);
    if ((from.equals("1")||(Util.null2String(request.getParameter("from"))).equals("1")))
    {
    response.sendRedirect("GradeEdit.jsp?id="+mainid);
    }
    else
    {
    response.sendRedirect("GradeDetailList.jsp?mainid="+mainid);
    }
    }
    %>
 