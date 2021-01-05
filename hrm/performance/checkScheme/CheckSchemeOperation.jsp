    <%@ page language="java" contentType="text/html; charset=GBK" %>
    <%@ page import="java.security.*,weaver.general.Util" %>
    <%@ page import="java.util.*" %>
    <%@ include file="/systeminfo/init.jsp" %>
    <jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
    <jsp:useBean id="rse" class="weaver.conn.RecordSet" scope="page" />
    <%
    String deltype=Util.null2String(request.getParameter("type"));
    String inserttype=Util.null2String(request.getParameter("inserttype"));
    String edittype=Util.null2String(request.getParameter("edittype"));
 
    //HrmPerformanceCheckScheme的insert
    if (inserttype.equals("basic")){
    String schemeName=Util.fromScreen(request.getParameter("schemeName"),user.getLanguage());
    String memo=Util.fromScreen(request.getParameter("memo"),user.getLanguage());
    String status=Util.fromScreen(request.getParameter("status"),user.getLanguage());
    String checkDeptId=Util.null2String(request.getParameter("checkDeptId"));
    String checkBranchId=Util.null2String(request.getParameter("checkBranchId"));
    String checkPostId=Util.null2String(request.getParameter("checkPostId"));
    String checkHrmId=Util.null2String(request.getParameter("checkHrmId"));
    String viewSuperiorId=Util.null2String(request.getParameter("viewSuperiorId"));
    String viewHrmId=Util.null2String(request.getParameter("viewHrmId"));
    String viewPostId=Util.null2String(request.getParameter("viewPostId"));
    String viewSeSuperiorId=Util.null2String(request.getParameter("viewSeSuperiorId"));
    String id="";
    String para="checkschemeid";
    rse.executeProc("GetMaxId_PRO",para);
    if (rse.next())
    {
    id=rse.getString(1);
    }
    rs.execute("insert into HrmPerformanceCheckScheme(id,schemeName,memo,status,checkDeptId,checkBranchId,checkPostId,checkHrmId,viewSuperiorId,viewSeSuperiorId,viewPostId,viewHrmId) values("+id+",'"+schemeName+"','"+memo+"','"+status+"','"+checkDeptId+"','"+checkBranchId+"','"+checkPostId+"','"+checkHrmId+"','"+viewSuperiorId+"','"+viewSeSuperiorId+"','"+viewPostId+"','"+viewHrmId+"') ");
    response.sendRedirect("CheckSchemeEdit.jsp?id="+id);
    }
    
    //HrmPerformanceCheckScheme的update
    if (edittype.equals("basic")){
    String schemeName=Util.fromScreen(request.getParameter("schemeName"),user.getLanguage());
    String memo=Util.fromScreen(request.getParameter("memo"),user.getLanguage());
    String status=Util.fromScreen(request.getParameter("status"),user.getLanguage());
    String checkDeptId=Util.null2String(request.getParameter("checkDeptId"));
    String checkBranchId=Util.null2String(request.getParameter("checkBranchId"));
    String checkPostId=Util.null2String(request.getParameter("checkPostId"));
    String checkHrmId=Util.null2String(request.getParameter("checkHrmId"));
    String viewSuperiorId=Util.null2String(request.getParameter("viewSuperiorId"));
    String viewHrmId=Util.null2String(request.getParameter("viewHrmId"));
    String viewPostId=Util.null2String(request.getParameter("viewPostId"));
    String viewSeSuperiorId=Util.null2String(request.getParameter("viewSeSuperiorId"));
    String id=Util.null2String(request.getParameter("id"));
    String cycle=Util.null2String(request.getParameter("cycle"));
    rs.execute("update HrmPerformanceCheckScheme set schemeName='"+schemeName+"',memo='"+memo+"',status='"+status+"',checkDeptId='"+checkDeptId+"',checkPostId='"+checkPostId+"',checkHrmId='"+checkHrmId+"',checkBranchId='"+checkBranchId+"',viewSeSuperiorId='"+viewSeSuperiorId+"',viewSuperiorId='"+viewSuperiorId+"',viewHrmId='"+viewHrmId+"',viewPostId='"+viewPostId+"' where id="+id);
    response.sendRedirect("CheckSchemeEdit.jsp?id="+id+"&cycle="+cycle);
    }
    //HrmPerformanceSchemeContent的新增
     if (inserttype.equals("content")){
     String type_c0=Util.null2String(request.getParameter("type_c0"));
     String type_c1=Util.null2String(request.getParameter("type_c1"));
     String type_c2=Util.null2String(request.getParameter("type_c2"));
     String percent_n0=Util.null2String(request.getParameter("percent_n0"));
     String percent_n1=Util.null2String(request.getParameter("percent_n1"));
     String percent_n2=Util.null2String(request.getParameter("percent_n2"));
     String mainId=Util.null2String(request.getParameter("mainId"));
     String cycle=Util.null2String(request.getParameter("cycle"));
    
      if (!type_c0.equals(""))
      {
    //  out.print("select * from HrmPerformanceSchemeContent where schemeId="+mainId+" and cycle='"+cycle+"' and type_c='0' ");
      rse.execute("select * from HrmPerformanceSchemeContent where schemeId="+mainId+" and cycle='"+cycle+"' and type_c='0' ");
      if (rse.next())
      {
      rs.execute("update HrmPerformanceSchemeContent set percent_n='"+percent_n0+"' where schemeId="+mainId+" and cycle='"+cycle+"' and type_c='0'");
      }
      else
      {
      rs.execute("insert into HrmPerformanceSchemeContent(schemeId,type_c,percent_n,cycle) values("+mainId+",'0','"+percent_n0+"','"+cycle+"') ");
      }
      }
      else
      {
      rs.execute("delete from HrmPerformanceSchemeContent where schemeId="+mainId+" and cycle='"+cycle+"' and type_c='0' ");
      }
      
      if (!type_c1.equals(""))
      {
     // out.print("select * from HrmPerformanceSchemeContent where schemeId="+mainId+" and cycle='"+cycle+"' and type_c='1' ");
      rse.execute("select * from HrmPerformanceSchemeContent where schemeId="+mainId+" and cycle='"+cycle+"' and type_c='1' ");
      if (rse.next())
      {
     // out.print("update HrmPerformanceSchemeContent set percent_n="+percent_n1+" where schemeId="+mainId+" and cycle='"+cycle+"' and type_c='1'");
      rs.execute("update HrmPerformanceSchemeContent set percent_n='"+percent_n1+"' where schemeId="+mainId+" and cycle='"+cycle+"' and type_c='1'");
      }
      else
      {
      rs.execute("insert into HrmPerformanceSchemeContent(schemeId,type_c,percent_n,cycle) values("+mainId+",'1','"+percent_n1+"','"+cycle+"') ");
      }
      }
      else
      {
      {
      rs.execute("delete from HrmPerformanceSchemeContent where schemeId="+mainId+" and cycle='"+cycle+"' and type_c='1' ");
      }
      }
       if (!type_c2.equals(""))
       {
       rse.execute("select * from HrmPerformanceSchemeContent where schemeId="+mainId+ " and cycle='"+cycle+"' and type_c='2' ");
      if (rse.next())
      {
      rs.execute("update HrmPerformanceSchemeContent set percent_n='"+percent_n2+"' where schemeId="+mainId+" and cycle='"+cycle+"' and type_c='2'");
      }
      else
      {
      rs.execute("insert into HrmPerformanceSchemeContent(schemeId,type_c,percent_n,cycle) values("+mainId+",'2','"+percent_n2+"','"+cycle+"') ");
      }
      }
      else
      {
      rs.execute("delete from HrmPerformanceSchemeContent where schemeId="+mainId+ " and cycle='"+cycle+"' and type_c='2' ");
      }
      response.sendRedirect("CheckSchemeContent.jsp?id="+mainId+"&cycle="+cycle);
     }
      //HrmPerformanceSchemeDetail的新增
     if (inserttype.equals("detail")){
     String contentId=Util.null2String(request.getParameter("contentId"));
     String cycle=Util.null2String(request.getParameter("cycle"));
     String type=Util.null2String(request.getParameter("type"));
     String item=Util.null2String(request.getParameter("item"));
     String percent_n=Util.null2String(request.getParameter("percent_n"));
     String checkFlow=Util.null2String(request.getParameter("checkFlow"));
     String mainid=Util.null2String(request.getParameter("mainid"));
     String id="";
     String para="schemedetailid";
     rse.executeProc("GetMaxId_PRO",para);
     if (rse.next())
     {
     id=rse.getString(1);
     }
     if (type.equals("1"))
     {
     item=Util.null2String(request.getParameter("checkItem"));
     }
      if (type.equals("2"))
     {
     item=Util.null2String(request.getParameter("docItem"));
     item="-1";
     }
     //年/年中/季度考核，同一周期月计划和月考核必须唯一，例如不能有2个月计划考核
     if (type.equals("0"))
     {
      rse.execute("select * from HrmPerformanceSchemeDetail where contentId="+contentId+" and item='"+item+"' ");
      if (rse.next())
      {
      out.print("<script>alert("+SystemEnv.getHtmlLabelName(18241,user.getLanguage())+");</script>");
      out.print("<script>history.back(-1);</script>");
      return;
      }
      }
      rs.execute("insert into HrmPerformanceSchemeDetail(id,contentId,item,percent_n,checkFlow) values("+id+","+contentId+","+item+",'"+percent_n+"','"+checkFlow+"')  ");
      response.sendRedirect("SchemeDetailEdit.jsp?mainid="+mainid+"&id="+id+"&type="+type+"&cycle="+cycle+"&contentId="+contentId);
     }
      //HrmPerformanceSchemeDetail的更新
     if (edittype.equals("detail")){
     String contentId=Util.null2String(request.getParameter("contentId"));
     String cycle=Util.null2String(request.getParameter("cycle"));
     String type=Util.null2String(request.getParameter("type"));
     String item=Util.null2String(request.getParameter("item"));
     String percent_n=Util.null2String(request.getParameter("percent_n"));
     String checkFlow=Util.null2String(request.getParameter("checkFlow"));
     String id=Util.null2String(request.getParameter("id"));;
     String mainid=Util.null2String(request.getParameter("mainid"));
     String downnode=Util.null2String(request.getParameter("downnode"));
     String percent_nv="";
     String nodeId="";
     String groupId="";
     if (type.equals("1"))
     {
     item=Util.null2String(request.getParameter("checkItem"));
     
     }
      if (type.equals("2"))
     {
     item=Util.null2String(request.getParameter("docItem"));
     item="-1";
     }
     //年/年中/季度考核，同一周期月计划和月考核必须唯一，例如不能有2个月计划考核
     if (type.equals("0"))
     {
      rse.execute("select * from HrmPerformanceSchemeDetail where contentId="+contentId+" and item='"+item+"' and id!="+id );
      if (rse.next())
      {
      out.print("<script>alert("+SystemEnv.getHtmlLabelName(18241,user.getLanguage())+");</script>");
      out.print("<script>history.back(-1);</script>");
      return;
      }
      }
     rs.execute("update HrmPerformanceSchemeDetail set item="+item+",percent_n='"+percent_n+"'  where id="+id  );
     int nodelength=Util.getIntValue(request.getParameter("nodelength"));
     int dnodelength=Util.getIntValue(request.getParameter("dnodelength"));
     int grouplength=0;
     int i=0,j=0;
     rs.execute("delete from HrmPerformanceSchemePercent where itemId="+id);
     for ( i=1;i<=nodelength;i++)  //无下游
     {j=0;
     nodeId=request.getParameter("nodeId_"+i);
     percent_nv=request.getParameter("percent_n"+i);
     grouplength=Util.getIntValue(request.getParameter("nodeId_"+i+"_grouplength"));
     out.print(grouplength);
     //type_n :0:节点，1：操作着 2：下游 ;type_d 是否含下游  0：否，1：是
     rs.execute("insert into HrmPerformanceSchemePercent (itemId,nodeId,percent_n,type_n,type_d) values("+id+","+nodeId+",'"+percent_nv+"','0','0')");
     for ( j=1;j<=grouplength;j++)
     {
      groupId=request.getParameter("nodeId_"+i+"_groupId_"+j);
      percent_nv=request.getParameter("nodeId_"+i+"_percent_ng"+j);
      out.print("insert into HrmPerformanceSchemePercent (itemId,nodeId,groupId,percent_n,type_n,type_d) values("+id+","+nodeId+","+groupId+",'"+percent_nv+"','1','0') ");
      rs.execute("insert into HrmPerformanceSchemePercent (itemId,nodeId,groupId,percent_n,type_n,type_d) values("+id+","+nodeId+","+groupId+",'"+percent_nv+"','1','0') ");
     }
     }
     if (type.equals("0"))
     {
     for ( i=1;i<=dnodelength;i++)   //含下游
     {j=0;
     nodeId=request.getParameter("dnodeId_"+i);
     percent_nv=request.getParameter("dpercent_n"+i);
     grouplength=Util.getIntValue(request.getParameter("dnodeId_"+i+"_grouplength"));
     //type_n :0:节点，1：操作着 2：下游 ;type_d 是否含下游  0：否，1：是
     rs.execute("insert into HrmPerformanceSchemePercent (itemId,nodeId,percent_n,type_n,type_d) values("+id+","+nodeId+",'"+percent_nv+"','0','1')");
     for ( j=1;j<=grouplength;j++)  
     {
      groupId=request.getParameter("dnodeId_"+i+"_groupId_"+j);
      percent_nv=request.getParameter("dnodeId_"+i+"_percent_ng"+j);
      rs.execute("insert into HrmPerformanceSchemePercent (itemId,nodeId,groupId,percent_n,type_n,type_d) values("+id+","+nodeId+","+groupId+",'"+percent_nv+"','1','1') ");
     }
     }
     //下游节点
     rs.execute("insert into HrmPerformanceSchemePercent (itemId,nodeId,groupId,percent_n,type_n,type_d) values("+id+",0,0,'"+downnode+"','2','1')");
     }
     response.sendRedirect("CheckSchemeEdit.jsp?id="+mainid+"&cycle="+cycle);
     }
    //HrmPerformanceAppendRule的删除
    if (deltype.equals("detaildel"))
    {
   
    String id=Util.null2String(request.getParameter("id"));
   
    rs.execute("delete from  HrmPerformanceSchemeDetail where id="+id);
    out.print("<script>history.back(-1);</script>");
    }
    %>
 