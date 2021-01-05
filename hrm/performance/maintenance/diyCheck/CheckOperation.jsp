    <%@ page language="java" contentType="text/html; charset=GBK" %>
    <%@ page import="java.security.*,weaver.general.Util" %>
    <%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
    <%@ include file="/systeminfo/init.jsp" %>
    <jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
    <jsp:useBean id="rsp" class="weaver.conn.RecordSet" scope="page" />
    <jsp:useBean id="rsd" class="weaver.conn.RecordSet" scope="page" />
    <%
    String from=Util.null2String((String)session.getAttribute("from"));
    String deltype=Util.null2String(request.getParameter("type"));
    String inserttype=Util.null2String(request.getParameter("inserttype"));
    String edittype=Util.null2String(request.getParameter("edittype"));
   
   //HrmPerformanceCheckRule的insert
   
    if (inserttype.equals("basic")){
    char separator = Util.getSeparator() ;
    String ruleName=Util.fromScreen(request.getParameter("ruleName"),user.getLanguage());
    String memo=Util.fromScreen(request.getParameter("memo"),user.getLanguage());
    String status=Util.null2String(request.getParameter("status"));
    if (status.equals("")) status="1";
    String para="checkruleid";
    String id="";
    rs.executeProc("GetMaxId_PRO",para);   
    if (rs.next()){
    id = ""+rs.getInt(1);
    }
    rs.execute("select * from HrmPerformanceCheckRule where ruleName='"+ruleName+"'");
    if (rs.next())
    {
     out.print("<script>alert('"+SystemEnv.getHtmlLabelName(195,user.getLanguage())+SystemEnv.getHtmlLabelName(18082,user.getLanguage())+"')</script>"); 
     out.print("<script>history.back(-1);</script>");
     return;
    }
    
    rs.execute("insert into HrmPerformanceCheckRule (id,ruleName,memo,status) values("+id+",'"+ruleName+"','"+memo+"','"+status+"')");
    response.sendRedirect("CheckEdit.jsp?id="+id);
    }
    //HrmPerformanceCheckRule的update
    if (edittype.equals("basic")){
    String id=Util.null2String(request.getParameter("mainid"));
    String ruleName=Util.fromScreen(request.getParameter("ruleName"),user.getLanguage());
    String memo=Util.fromScreen(request.getParameter("memo"),user.getLanguage());
    String status=Util.null2String(request.getParameter("status"));
    if (status.equals("")) status="1";
    rs.execute("select * from HrmPerformanceCheckRule where ruleName='"+ruleName+"' and id!="+id);
    
    if (rs.next())
    {
     out.print("<script>alert('"+SystemEnv.getHtmlLabelName(195,user.getLanguage())+SystemEnv.getHtmlLabelName(18082,user.getLanguage())+"')</script>"); 
     out.print("<script>history.back(-1);</script>");
     return;
    }
    rs.execute("update HrmPerformanceCheckRule set ruleName='"+ruleName+"',memo='"+memo+"',status='"+status+"' where id="+id);
    response.sendRedirect("CheckEdit.jsp?id="+id);
    }
    //HrmPerformanceCheckDetail的insert
    if (inserttype.equals("detail")){
    String targetName=Util.fromScreen(request.getParameter("targetName"),user.getLanguage());
    String percent_n=Util.null2o(request.getParameter("percent_n"));
    String mid=Util.null2String(request.getParameter("mainid"));
    String parentId=Util.null2o(request.getParameter("parentId")); //如果为0，表示无上级
    String targetId=Util.fromScreen(request.getParameter("targetIdf"),user.getLanguage()); //如果为空表示不是从指标直接倒入的
    float sum=0;
    int levels=1; //节点级别（1为第一级节点）
    String depath=""; //节点深度(父节点的depath+"-"+id，如果是第一级节点为id)
    String para="checkdetailid";
    String id="";
    rs.executeProc("GetMaxId_PRO",para);   
    if (rs.next()){
    id = ""+rs.getInt(1);
    }
    depath=id;
    String sql="";
    if (!parentId.equals("0")) 
    {
    rsp.execute("select * from HrmPerformanceCheckDetail where id="+parentId);
    if (rsp.next())
    {
    levels+=rsp.getInt("levels");
    depath=rsp.getString("depath")+"-"+id;
    sum=0;
    if (rs.getDBType().equals("oracle"))
    rs.execute("select sum(percent_n) from HrmPerformanceCheckDetail where parentId="+parentId+" and checkId="+mid);
    else if (rs.getDBType().equals("db2"))
       rs.execute("select sum(double(percent_n)) from HrmPerformanceCheckDetail where parentId="+parentId+" and checkId="+mid);
    else
        rs.execute("select sum(convert(float,percent_n)) from HrmPerformanceCheckDetail where parentId="+parentId+" and checkId="+mid);
    //out.print("select sum(percent_n) from HrmPerformanceCheckDetail where parentId="+parentId+" and checkId="+mid);
    //相同parentId的percent_n和应该是100
     if (rs.next()) sum=rs.getFloat(1);

     if ((sum+Float.parseFloat(percent_n))>100)  //判断parentID为0的percent_n和应该是100
     {
     out.print("<script>alert('"+SystemEnv.getHtmlLabelName(18123,user.getLanguage())+"')</script>"); 
     out.print("<script>history.back(-1);</script>");
     return;
     }
    }
    }
    else
    {
     if (rsp.getDBType().equals("oracle"))
    rsp.execute("select sum(percent_n) from HrmPerformanceCheckDetail where parentId=0 and checkId="+mid);
    else if (rsp.getDBType().equals("db2"))
       rsp.execute("select sum(double(percent_n)) from HrmPerformanceCheckDetail where parentId=0 and checkId="+mid);
    else
       rsp.execute("select sum(convert(float,percent_n)) from HrmPerformanceCheckDetail where parentId=0 and checkId="+mid);
    //out.print("select sum(percent_n) from HrmPerformanceCh
     if (rsp.next()) sum=rsp.getFloat(1);
    
     
     if ((sum+Float.parseFloat(percent_n))>100)  //判断parentID为0的percent_n和应该是100
     {
     out.print("<script>alert('"+SystemEnv.getHtmlLabelName(18123,user.getLanguage())+"')</script>"); 
     out.print("<script>history.back(-1);</script>");
     return;
     }
    }
    rs.execute("select *  from  HrmPerformanceCheckDetail where checkId="+mid+" and parentId="+parentId+" and targetName='"+targetName+"'");
    if (rs.next())
    {
     out.print("<script>alert('"+SystemEnv.getHtmlLabelName(195,user.getLanguage())+SystemEnv.getHtmlLabelName(18082,user.getLanguage())+"')</script>"); 
     out.print("<script>history.back(-1);</script>");
     return;
    }
    rs.execute("insert into HrmPerformanceCheckDetail(id,checkId,targetName,percent_n,parentId,levels,depath) values("+id+","+mid+",'"+targetName+"','"+percent_n+"',"+parentId+","+levels+",'"+depath+"') ");
    if (!targetId.equals(""))
    {
    rsd.execute("select * from HrmPerformanceTargetStd where targetDetailId="+targetId);
    while (rsd.next())
    {
    rs.execute("insert into HrmPerformanceCheckStd (checkDetailId,stdName,point) values("+id+",'"+Util.null2String(rsd.getString("stdName"))+"',"+Util.null2String(rsd.getString("point"))+")");
    }
    
    }
    response.sendRedirect("TargetDetailEdit.jsp?id="+id+"&mainid="+mid);
    }
    
    //HrmPerformanceCheckDetail的insert的update
    if (edittype.equals("detail")){
    String targetName=Util.fromScreen(request.getParameter("targetName"),user.getLanguage());
    String percent_n=Util.null2o(request.getParameter("percent_n"));
    String mid=Util.null2String(request.getParameter("mainid"));
    String id=Util.null2String(request.getParameter("id"));
    String parentId=Util.null2o(request.getParameter("parentId")); //如果为0，表示无上级
    float sum=0;
    if (rsp.getDBType().equals("oracle"))
     rsp.execute("select sum(percent_n) from HrmPerformanceCheckDetail where id!="+id+" and parentId="+parentId+" and  checkId="+mid);
    else if (rsp.getDBType().equals("db2"))
     rsp.execute("select sum(double(percent_n)) from HrmPerformanceCheckDetail where id!="+id+" and parentId="+parentId+"  and checkId="+mid);
    else{
    rsp.execute("select sum(convert(float,percent_n)) from HrmPerformanceCheckDetail where id!="+id+" and parentId="+parentId+"  and checkId="+mid);
    //out.print("select sum(convert(float,percent_n)) from HrmPerformanceCheckDetail where id!="+id+" and parentId="+parentId+"  and checkId="+mid);
    }
    //相同parentId的percent_n和应该是100
     if (rsp.next()) sum=rsp.getFloat(1);
     
     if ((sum+Float.parseFloat(percent_n))>100)  //判断parentID为0的percent_n和应该是100
     {
     out.print("<script>alert('"+SystemEnv.getHtmlLabelName(18123,user.getLanguage())+"')</script>");
     out.print("<script>history.back(-1);</script>");
     return;
     }
    rs.execute("select *  from  HrmPerformanceCheckDetail where checkId="+mid+" and id!="+id+" and parentId="+parentId+" and targetName='"+targetName+"'");
    if (rs.next())
    {
     out.print("<script>alert('"+SystemEnv.getHtmlLabelName(195,user.getLanguage())+SystemEnv.getHtmlLabelName(18082,user.getLanguage())+"')</script>"); 
     out.print("<script>history.back(-1);</script>");
     return;
    }
    rs.execute("update  HrmPerformanceCheckDetail set targetName='"+targetName+"',percent_n='"+percent_n+"'  where id="+id);
    //out.print("update  HrmPerformanceCheckDetail set targetName='"+targetName+"',percent_n="+percent_n+"  where id="+id);
    response.sendRedirect("TargetDetailEdit.jsp?mainid="+mid+"&id="+id);
    }
    
    //HrmPerformanceCheckDetail的insert的update
    if (edittype.equals("modul")){
    String targetName=Util.fromScreen(request.getParameter("targetName"),user.getLanguage());
    String id=Util.null2String(request.getParameter("id"));
    String mid=Util.null2String(request.getParameter("mainid"));
    String para="targetdetailid";
    String iid="";
    rs.executeProc("GetMaxId_PRO",para);   
    if (rs.next()){
    iid = ""+rs.getInt(1);
    }
    String para1="targettypeid";
    String mmid="";
    rs.executeProc("GetMaxId_PRO",para1);   
    if (rs.next()){
    mmid = ""+rs.getInt(1);
    }
    rs.execute("insert into HrmPerformanceTargetType (id,targetName,memo) values("+mmid+",'"+SystemEnv.getHtmlLabelName(18397,user.getLanguage())+"','"+SystemEnv.getHtmlLabelName(18398,user.getLanguage())+"')");
    rs.execute("insert into HrmPerformanceTargetDetail(id,targetId,targetName,type_l,type_t,cycle,memo) values("+iid+","+mmid+",'"+targetName+"','0','0','3','"+SystemEnv.getHtmlLabelName(18398,user.getLanguage())+"') ");
    rsd.execute("select stdName,point from hrmPerformanceCheckStd where checkDetailId="+id);
    while (rsd.next()){
    rs.execute("insert into HrmPerformanceTargetStd (targetDetailId,stdName,point) values("+iid+",'"+rsd.getString(1)+"',"+rsd.getString(2)+")");
   }
    response.sendRedirect("TargetDetailEdit.jsp?mainid="+mid+"&id="+id);
    }
    
    //HrmPerformanceCheckStd的insert
   if (inserttype.equals("std")){
    String stdName=Util.fromScreen(request.getParameter("stdName"),user.getLanguage());
    String point=Util.null2o(request.getParameter("point"));
    String mainid=Util.null2String(request.getParameter("mainid"));
    String id=Util.null2String(request.getParameter("id"));
    rs.execute("insert into HrmPerformanceCheckStd(checkDetailId,stdName,point) values("+id+",'"+stdName+"',"+point+") ");
    response.sendRedirect("TargetDetailEdit.jsp?mainid="+mainid+"&id="+id);
    }
    //HrmPerformanceCheckStd的edit
     if (edittype.equals("std")){
    String stdName=Util.fromScreen(request.getParameter("stdName"),user.getLanguage());
    String point=Util.null2o(request.getParameter("point"));
    String mainid=Util.null2String(request.getParameter("mainid"));
    String id=Util.null2String(request.getParameter("id"));
    String tid=Util.null2String(request.getParameter("tid"));
    rs.execute("update HrmPerformanceCheckStd set stdName='"+stdName+"',point="+point+" where id="+id );
    response.sendRedirect("TargetDetailEdit.jsp?mainid="+mainid+"&id="+tid);
    }
    
    //HrmPerformanceCheckStd的删除
    if (deltype.equals("detaildelstd"))
    {
    String mainid=Util.null2String(request.getParameter("mainid"));
    String id=Util.null2String(request.getParameter("id"));
    String tid=Util.null2String(request.getParameter("tid"));
    rs.execute("delete from  HrmPerformanceCheckStd where id="+id);
    response.sendRedirect("TargetDetailEdit.jsp?mainid="+mainid+"&id="+tid);
    }
     //HrmPerformanceCheckDetail的删除
    if (deltype.equals("detaildel"))
    {
    String mainid=Util.null2String(request.getParameter("mainid"));
    String id=Util.null2String(request.getParameter("id"));
    String tid=Util.null2String(request.getParameter("tid"));
    String depth="";
    rs.execute("select * from HrmPerformanceCheckDetail where id="+id);
    if (rs.next())
    {
    depth=rs.getString("depath")+"-";
    
    }
    rs.execute("delete from  HrmPerformanceCheckDetail where depath like '"+depth+"%' ");
    rs.execute("delete from  HrmPerformanceCheckDetail where id="+id);
    out.print("<script>history.back(-1);</script>");
    }
    %>
 