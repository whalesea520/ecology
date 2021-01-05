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
    
    if (edittype.equals("basic")){
    String minPoint=Util.null2o(request.getParameter("minPoint"));
    String maxPoint=Util.null2o(request.getParameter("maxPoint"));
    String pointMethod=Util.null2o(request.getParameter("pointMethod"));
    String pointModul=Util.null2o(request.getParameter("pointModul"));
    String pointModify=Util.null2o(request.getParameter("pointModify"));
    rse.execute("select * from HrmPerformancePointRule");
    if (rse.next())
    {
     rs.execute("update HrmPerformancePointRule set minPoint="+minPoint+",maxPoint="+maxPoint+",pointMethod='"+pointMethod+"',pointModul='"+pointModul+"',pointModify='"+pointModify+"' ");
    }
    else
    {
    rs.execute("insert into HrmPerformancePointRule values("+minPoint+","+maxPoint+",'"+pointMethod+"','"+pointModul+"','"+pointModify+"' )" );
    }
    response.sendRedirect("RuleView.jsp");
    }
    
    //HrmPerformanceAppendRuleµÄinsert
    if (inserttype.equals("detail")){
    String ruleName=Util.fromScreen(request.getParameter("ruleName"),user.getLanguage());
    String memo=Util.fromScreen(request.getParameter("memo"),user.getLanguage());
    String status=Util.fromScreen(request.getParameter("status"),user.getLanguage());
    String formula=Util.null2String(request.getParameter("formula"));
    String conditions=Util.null2String(request.getParameter("conditions"));
    String formulasum=Util.null2String(request.getParameter("formulasum"));
    String conditionsum=Util.null2String(request.getParameter("conditionsum"));
    String deptId=Util.null2String(request.getParameter("deptId"));
    String hrmId=Util.null2String(request.getParameter("hrmId"));
    String postId=Util.null2String(request.getParameter("postId"));
    String formulaDeptId=Util.null2String(request.getParameter("formulaDeptId"));
    String formulaPostId=Util.null2String(request.getParameter("formulaPostId"));
    String formulaHrmId=Util.null2String(request.getParameter("formulaHrmId"));
    rs.execute("insert into HrmPerformanceAppendRule(ruleName,memo,status,formula,conditions,formulasum,conditionsum,deptId,hrmId,postId,formulaDeptId,formulaPostId,formulaHrmId) values('"+ruleName+"','"+memo+"','"+status+"','"+formula+"','"+conditions+"','"+formulasum+"','"+conditionsum+"','"+deptId+"','"+hrmId+"','"+postId+"','"+formulaDeptId+"','"+formulaPostId+"','"+formulaHrmId+"') ");
    response.sendRedirect("RuleView.jsp");
    }
    
    //HrmPerformanceAppendRuleµÄupdate
    if (edittype.equals("detail")){
    String ruleName=Util.fromScreen(request.getParameter("ruleName"),user.getLanguage());
    String memo=Util.fromScreen(request.getParameter("memo"),user.getLanguage());
    String status=Util.fromScreen(request.getParameter("status"),user.getLanguage());
    String formula=Util.null2String(request.getParameter("formula"));
    String conditions=Util.null2String(request.getParameter("conditions"));
    String formulasum=Util.null2String(request.getParameter("formulasum"));
    String conditionsum=Util.null2String(request.getParameter("conditionsum"));
    String deptId=Util.null2String(request.getParameter("deptId"));
    String hrmId=Util.null2String(request.getParameter("hrmId"));
    String postId=Util.null2String(request.getParameter("postId"));
    String formulaDeptId=Util.null2String(request.getParameter("formulaDeptId"));
    String formulaPostId=Util.null2String(request.getParameter("formulaPostId"));
    String formulaHrmId=Util.null2String(request.getParameter("formulaHrmId"));
    String id=Util.null2String(request.getParameter("id"));
    rs.execute("update HrmPerformanceAppendRule set ruleName='"+ruleName+"',memo='"+memo+"',status='"+status+"',formula='"+formula+"',conditions='"+conditions+"',formulasum='"+formulasum+"',conditionsum='"+conditionsum+"',deptId='"+deptId+"',hrmId='"+hrmId+"',postId='"+postId+"',formulaDeptId='"+formulaDeptId+"',formulaPostId='"+formulaPostId+"',formulaHrmId='"+formulaHrmId+"' where id="+id);
    response.sendRedirect("RuleView.jsp");
    }
    
    //HrmPerformanceAppendRuleµÄÉ¾³ý
    if (deltype.equals("detaildel"))
    {
   
    String id=Util.null2String(request.getParameter("id"));
   
    rs.execute("delete from  HrmPerformanceAppendRule where id="+id);
    response.sendRedirect("RuleView.jsp");
    }
    %>
 