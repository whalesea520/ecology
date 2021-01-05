    <%@ page language="java" contentType="text/html; charset=GBK" %>
    <%@ page import="java.security.*,weaver.general.Util" %>
    <%@ page import="java.util.*" %>
    <%@ page import="java.io.*" %>
    <%@ page import="java.sql.*" %>
    <%@ page import="weaver.general.SessionOper" %>
    <%@ page import="weaver.hrm.performance.maintenance.TargetList" %>
    <%@ include file="/systeminfo/init.jsp" %>
    <jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
    <jsp:useBean id="rsf" class="weaver.conn.RecordSet" scope="page" />
    <jsp:useBean id="rsk" class="weaver.conn.RecordSet" scope="page" />
    <jsp:useBean id="rse" class="weaver.conn.RecordSet" scope="page" />
    <jsp:useBean id="rsd" class="weaver.conn.RecordSet" scope="page" />
    <%! /**
        保存方法
        */
     public int saves(HttpServletRequest request,User user,weaver.conn.RecordSet rsf,weaver.conn.RecordSet rse,weaver.conn.RecordSet rs)
    {
    String id=request.getParameter("id");
    String pointId=request.getParameter("pointId");
    String checkDate=request.getParameter("checkDate");
    String cycle=request.getParameter("cycle");
    String checkType=request.getParameter("checkType");
    String type_c=request.getParameter("type_c");
    String objId=request.getParameter("objId");
    
    int len=Util.getIntValue(request.getParameter("len"),0);
    String point="";
    String item=request.getParameter("item");
    String messageType="";
    String requestlevel="";
    String nodetype="";
    int nodeid=Util.getIntValue(request.getParameter("nodeid"),0);
    int createrid=0;
    int requestid=Util.getIntValue(request.getParameter("requestid"),0);
    int uid=user.getUID();
    int groupid=Util.getIntValue(request.getParameter("groupid"),0);
    String sql="";
    TargetList treelist=new TargetList();
    if (type_c.equals("1")) //更新打分明细
     {
     rs.execute("select * from HrmPerformanceCheckPointDetail where checkId="+item+" and nodePointId="+pointId);
     while (rs.next())
     {  String targetId=rs.getString("id");
        int points=Util.getIntValue(request.getParameter("points_"+targetId),0);
        if (points!=0) rsf.execute("update HrmPerformanceCheckPointDetail set point="+points+"  where id="+targetId);
     }
     }
    rs.execute("select * from HrmPerformanceNodePoint where cycle='"+cycle+"' and checkType='"+checkType+"' and objId="+objId+" and checkDate='"+checkDate+"' and nodeId="+nodeid+" and operationId="+groupid);
    //System.out.print("select * from HrmPerformanceNodePoint where cycle='"+cycle+"' and checkType='"+checkType+"' and objId="+objId+" and checkDate='"+checkDate+"' and nodeId="+nodeid+" and operationId="+groupid);
    if (rs.next())
    {
    if (type_c.equals("0")&&item.equals("0"))
    {
    for (int i=0;i<len;i++)
    {if (point.equals("")) point=request.getParameter("point_"+i);
        else point=point+","+request.getParameter("point_"+i);
    }
    sql="update HrmPerformanceNodePoint set point1='"+point+"' where cycle='"+cycle+"' and checkType='"+checkType+"' and objId="+objId+" and checkDate='"+checkDate+"' and nodeId="+nodeid+" and operationId="+groupid;
    }
    else if (type_c.equals("0")&&item.equals("1"))
    {   point=request.getParameter("point_0");
        sql="update HrmPerformanceNodePoint set point2='"+point+"' where cycle='"+cycle+"' and checkType='"+checkType+"' and objId="+objId+" and checkDate='"+checkDate+"' and nodeId="+nodeid+" and operationId="+groupid;
    }
    else if (type_c.equals("1"))
    {//point=request.getParameter("point_0");
     point=treelist.getViewTargetPoint(Util.getIntValue(item,0),pointId);
     sql="update HrmPerformanceNodePoint set point3='"+point+"' where cycle='"+cycle+"' and checkType='"+checkType+"' and objId="+objId+" and checkDate='"+checkDate+"' and nodeId="+nodeid+" and operationId="+groupid;
    }
    else if (type_c.equals("2"))
    {point=request.getParameter("point_0");
     sql="update HrmPerformanceNodePoint set point4='"+point+"' where cycle='"+cycle+"' and checkType='"+checkType+"' and objId="+objId+" and checkDate='"+checkDate+"' and nodeId="+nodeid+" and operationId="+groupid;
    }
    }
    else
    {
    if (type_c.equals("0")&&item.equals("0"))
    {
    for (int i=0;i<len;i++)
    {if (point.equals("")) point=request.getParameter("point_"+i);
        else point=point+","+request.getParameter("point_"+i);
    }
    sql="insert into HrmPerformanceNodePoint (id,cycle,objId,checkType,checkDate,point1,nodeId,operationId) values("+pointId+",'"+cycle+"',"+objId+",'"+checkType+"','"+checkDate+"','"+point+"',"+nodeid+","+groupid+")";
    }
    else if (type_c.equals("0")&&item.equals("1"))
    {point=request.getParameter("point_0"); 
    sql="insert into HrmPerformanceNodePoint (id,cycle,objId,checkType,checkDate,point2,nodeId,operationId) values("+pointId+",'"+cycle+"',"+objId+",'"+checkType+"','"+checkDate+"','"+point+"',"+nodeid+","+groupid+")";
    }
    else if (type_c.equals("1"))
    {//point=request.getParameter("point_0");
     point=treelist.getViewTargetPoint(Util.getIntValue(item,0),pointId);
    sql="insert into HrmPerformanceNodePoint (id,cycle,objId,checkType,checkDate,point3,nodeId,operationId) values("+pointId+",'"+cycle+"',"+objId+",'"+checkType+"','"+checkDate+"','"+point+"',"+nodeid+","+groupid+")";
    }
    else if (type_c.equals("2"))
    {point=request.getParameter("point_0");
    sql="insert into HrmPerformanceNodePoint (id,cycle,objId,checkType,checkDate,point4,nodeId,operationId) values("+pointId+",'"+cycle+"',"+objId+",'"+checkType+"','"+checkDate+"','"+point+"',"+nodeid+","+groupid+")";
    }
    }
     //System.out.print(sql);
     rse.execute(sql);
     return requestid;
    
    
    }
    %>
    <%
    String operationType=Util.null2String(request.getParameter("operationType"));
    //保存
    if (operationType.equals("save")){
    saves(request,user,rsf,rse,rs);
    out.print("<script>history.back(-1);</script>");
    }
    
    //提交
    if (operationType.equals("confirm"))
		    {
		    //准备流程参数
		    String src = "submit";
			String iscreate = "0";
			int requestid = saves(request,user,rsf,rse,rs);
			int workflowid = 1;
			String workflowtype = "";
			int isremark = 0;
			int formid = 0;
			int isbill = 1;
			int billid = -1;
			int nodeid =-1;
			String nodetype = "";
			String requestname = "";
			String requestlevel = "";
			String messageType = "0";
			String remark = "";
		    int createrid=0;
			 rsf.execute("select workflowid,messageType,currentnodeid,currentnodetype,requestlevel,creater from workflow_requestbase where requestid="+requestid);
			 if (rsf.next())
			 {
			 messageType=rsf.getString("messageType");
			 requestlevel=rsf.getString("requestlevel");
			 nodetype=rsf.getString("currentnodetype");
			 nodeid=rsf.getInt("currentnodeid");
			 createrid=rsf.getInt("creater");
			 workflowid=rsf.getInt("workflowid");
			 }
			 rsf.execute("select messageType,workflowtype,formid from workflow_base where id="+workflowid);
			 if (rsf.next())
			 {
			
			 workflowtype=rsf.getString("workflowtype");
			 billid=rsf.getInt("formid");
			 }
			 formid=billid;
			   //准备流程参数结束
			
			 String url="/workflow/request/BillBPMGradeOperation.jsp?"+
			 "users="+createrid+"&src="+src+"&iscreate="+iscreate+"&requestid="+requestid+"&"+
			 "workflowid="+workflowid+"&workflowtype="+workflowtype+""+
			 "&isremark="+isremark+"&formid="+formid+"&isbill="+isbill+"&billid="+billid+"&"+
			 "nodeid="+nodeid+"&requestname="+requestname+"&"+
			 "nodetype="+nodetype+"&requestlevel="+requestlevel+"&messageType="+messageType+"&remark="+remark+"&from=1";
			  response.sendRedirect(url);
			 // out.print(url);
			  return;
			
		    }
		    
    
    
  
    //保存面谈记录
    if (operationType.equals("saveInterview"))
    {   String id=request.getParameter("id");
        String memo=request.getParameter("memo");
        rs.execute("update HrmPerformanceCheckPoint set memo='"+memo+"' where id="+id);
        out.print("<script>history.back(-1);</script>");
		return;
    }
    
    %>
 