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
    //HrmPerformanceTargetType的insert
    if (inserttype.equals("basic")){
    char separator = Util.getSeparator() ;
    String targetName=Util.fromScreen(request.getParameter("targetName"),user.getLanguage());
    String memo=Util.fromScreen(request.getParameter("memo"),user.getLanguage());
    String para="targettypeid";
    String id="";
    rs.executeProc("GetMaxId_PRO",para);   
    if (rs.next()){
    id = ""+rs.getInt(1);
   }
    rs.execute("select * from HrmPerformanceTargetType where targetName='"+targetName+"'");
    if (rs.next())
    {
     out.print("<script>alert('"+SystemEnv.getHtmlLabelName(195,user.getLanguage())+SystemEnv.getHtmlLabelName(18082,user.getLanguage())+"')</script>"); 
     out.print("<script>history.back(-1);</script>");
     return;
    }
    rs.execute("insert into HrmPerformanceTargetType (id,targetName,memo) values("+id+",'"+targetName+"','"+memo+"')");
    response.sendRedirect("TargetTypeList.jsp");
    }
    //HrmPerformanceTargetType的update
    if (edittype.equals("basic")){
    String targetName=Util.fromScreen(request.getParameter("targetName"),user.getLanguage());
    String memo=Util.fromScreen(request.getParameter("memo"),user.getLanguage());
    String id=Util.null2String(request.getParameter("id"));
    rs.execute("select * from HrmPerformanceTargetType where id!="+id+" and targetName='"+targetName+"'");
    if (rs.next())
    {
     out.print("<script>alert('"+SystemEnv.getHtmlLabelName(195,user.getLanguage())+SystemEnv.getHtmlLabelName(18082,user.getLanguage())+"')</script>"); 
     out.print("<script>history.back(-1);</script>");
     return;
    }
    rs.execute("update HrmPerformanceTargetType set targetName='"+targetName+"',memo='"+memo+"' where id="+id);
    response.sendRedirect("TargetTypeList.jsp");
    }
    //HrmPerformanceTargetDetail的insert
    if (inserttype.equals("detail")){
    String targetName=Util.fromScreen(request.getParameter("targetName"),user.getLanguage());
    String targetCode=Util.fromScreen(request.getParameter("targetCode"),user.getLanguage());
    String type_1=Util.null2String(request.getParameter("type_1"));
    String type_t=Util.null2String(request.getParameter("type_t"));
    String cycle=Util.null2String(request.getParameter("cycle"));
    String memo=Util.fromScreen(request.getParameter("memo"),user.getLanguage());
    String unit=Util.null2String(request.getParameter("unit"));
    String previewValue=Util.null2o(request.getParameter("previewValue"));
    String targetValue=Util.null2o(request.getParameter("targetValue"));
    String mid=Util.null2String(request.getParameter("mainid"));
    String para="targetdetailid";
    String id="";
    rs.executeProc("GetMaxId_PRO",para);   
    if (rs.next()){
    id = ""+rs.getInt(1);
    }
     rs.execute("select * from HrmPerformanceTargetDetail where targetId="+mid+" and targetName='"+targetName+"'");
    if (rs.next())
    {
     out.print("<script>alert('"+SystemEnv.getHtmlLabelName(195,user.getLanguage())+SystemEnv.getHtmlLabelName(18082,user.getLanguage())+"')</script>"); 
     out.print("<script>history.back(-1);</script>");
     return;
    }
    if (type_t.equals("0")) unit="";
    rs.execute("insert into HrmPerformanceTargetDetail(id,targetId,targetName,targetCode,type_l,type_t,unit,cycle,targetValue,previewValue,memo) values("+id+","+mid+",'"+targetName+"','"+targetCode+"','"+type_1+"','"+type_t+"','"+unit+"','"+cycle+"',"+targetValue+","+previewValue+",'"+memo+"') ");
    response.sendRedirect("TargetDetailEdit.jsp?mainid="+mid+"&id="+id);
    }
     //HrmPerformanceTargetStd的insert
    if (inserttype.equals("std")){
    String stdName=Util.fromScreen(request.getParameter("stdName"),user.getLanguage());
    String point=Util.null2o(request.getParameter("point"));
    String mainid=Util.null2String(request.getParameter("mainid"));
    String id=Util.null2String(request.getParameter("id"));
    rs.execute("select * from HrmPerformanceTargetStd where targetDetailId="+id+"  and stdName='"+stdName+"'");
   
    if (rs.next())
    {
     out.print("<script>alert('"+SystemEnv.getHtmlLabelName(18092,user.getLanguage())+SystemEnv.getHtmlLabelName(18082,user.getLanguage())+"')</script>"); 
     out.print("<script>history.back(-1);</script>");
     return;
    }
    rs.execute("insert into HrmPerformanceTargetStd(targetDetailId,stdName,point) values("+id+",'"+stdName+"',"+point+") ");
    response.sendRedirect("TargetDetailEdit.jsp?mainid="+mainid+"&id="+id);
    }
    //HrmPerformanceTargetStd的update
     if (edittype.equals("std")){
    String stdName=Util.fromScreen(request.getParameter("stdName"),user.getLanguage());
    String point=Util.null2o(request.getParameter("point"));
    String mainid=Util.null2String(request.getParameter("mainid"));
    String id=Util.null2String(request.getParameter("id"));
    String tid=Util.null2String(request.getParameter("tid"));
    rs.execute("select * from HrmPerformanceTargetStd where targetDetailId="+tid+"  and id!="+id+" and stdName='"+stdName+"'");
    if (rs.next())
    {
     out.print("<script>alert('"+SystemEnv.getHtmlLabelName(18092,user.getLanguage())+SystemEnv.getHtmlLabelName(18082,user.getLanguage())+"')</script>"); 
     out.print("<script>history.back(-1);</script>");
     return;
    }
    rs.execute("update HrmPerformanceTargetStd set stdName='"+stdName+"',point="+point+" where id="+id );
    response.sendRedirect("TargetDetailEdit.jsp?mainid="+mainid+"&id="+tid);
    }
    //HrmPerformanceTargetDetail的update
    if (edittype.equals("detail")){
    String targetName=Util.fromScreen(request.getParameter("targetName"),user.getLanguage());
    String targetCode=Util.fromScreen(request.getParameter("targetCode"),user.getLanguage());
    String type_1=Util.null2String(request.getParameter("type_1"));
    String type_t=Util.null2String(request.getParameter("type_t"));
    String cycle=Util.null2String(request.getParameter("cycle"));
    String memo=Util.fromScreen(request.getParameter("memo"),user.getLanguage());
    String unit=Util.null2String(request.getParameter("unit"));
    String previewValue=Util.null2o(request.getParameter("previewValue"));
    String targetValue=Util.null2o(request.getParameter("targetValue"));
    String mid=Util.null2String(request.getParameter("mainid"));
    String id=Util.null2String(request.getParameter("id"));
    rs.execute("select * from HrmPerformanceTargetDetail where targetId="+mid+"  and id!="+id+" and targetName='"+targetName+"'");
    if (rs.next())
    {
     out.print("<script>alert('"+SystemEnv.getHtmlLabelName(195,user.getLanguage())+SystemEnv.getHtmlLabelName(18082,user.getLanguage())+"')</script>"); 
     out.print("<script>history.back(-1);</script>");
     return;
    }
    if (type_t.equals("0")) unit="";
    rs.execute("update  HrmPerformanceTargetDetail set targetName='"+targetName+"',targetCode='"+targetCode+"',type_l='"+type_1+"',type_t='"+type_t+"',unit='"+unit+"',cycle='"+cycle+"',targetValue="+targetValue+",previewValue="+previewValue+",memo='"+memo+"'  where id="+id);
    response.sendRedirect("TargetDetailEdit.jsp?mainid="+mid+"&id="+id);
    }
    
    //HrmPerformanceTargetStd的删除
    if (deltype.equals("detaildel"))
    {
    String mainid=Util.null2String(request.getParameter("mainid"));
    String id=Util.null2String(request.getParameter("id"));
    String tid=Util.null2String(request.getParameter("tid"));
    rs.execute("delete from  HrmPerformanceTargetStd where id="+id);
    response.sendRedirect("TargetDetailEdit.jsp?mainid="+mainid+"&id="+tid);
    }
    %>
 