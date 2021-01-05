    <%@ page language="java" contentType="text/html; charset=GBK" %>
    <%@ page import="java.security.*,weaver.general.Util,weaver.conn.* " %>
    
    <%@ page import="java.util.*" %>
    <%@ page import="weaver.systeminfo.SystemEnv" %>
    <%@ include file="/systeminfo/init.jsp" %>
    <jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
    <jsp:useBean id="rsb" class="weaver.conn.RecordSet" scope="page" />
    <%
     String sql="";
    String type=Util.null2String(request.getParameter("type")); //0：目标 1：计划 2：报告 3：考核
    /**
    如果yearConCount="-1"表示无年提醒，其他 周期类同
    */
    String yearCondition1=Util.null2String(request.getParameter("yearCondition1"));
    String yearCondition2=Util.null2String(request.getParameter("yearCondition2"));
    int yearConCount=Util.getIntValue(request.getParameter("yearConCount"));
    int yearAlertCount=Util.getIntValue(request.getParameter("yearAlertCount"));
    String yearAlertUnit=Util.null2String(request.getParameter("yearAlertUnit"));
    int yearFrequency=Util.getIntValue(request.getParameter("yearFrequency"));
    int yearInterval=Util.getIntValue(request.getParameter("yearInterval"));
    String yFrequency=Util.null2String(request.getParameter("yFrequency"));
    
    String monthCondition1=Util.null2String(request.getParameter("monthCondition1"));
    String monthCondition2=Util.null2String(request.getParameter("monthCondition2"));
    int monthConCount=Util.getIntValue(request.getParameter("monthConCount"));
    int monthAlertCount=Util.getIntValue(request.getParameter("monthAlertCount"));
    String monthAlertUnit=Util.null2String(request.getParameter("monthAlertUnit"));
    int monthFrequency=Util.getIntValue(request.getParameter("monthFrequency"));
    int monthInterval=Util.getIntValue(request.getParameter("monthInterval"));
    String mFrequency=Util.null2String(request.getParameter("mFrequency"));
    
    String weekCondition1=Util.null2String(request.getParameter("weekCondition1"));
    String weekCondition2=Util.null2String(request.getParameter("weekCondition2"));
    int weekConCount=Util.getIntValue(request.getParameter("weekConCount"));
    int weekAlertCount=Util.getIntValue(request.getParameter("weekAlertCount"));
    String weekAlertUnit=Util.null2String(request.getParameter("weekAlertUnit"));
    int weekFrequency=Util.getIntValue(request.getParameter("weekFrequency"));
    int weekInterval=Util.getIntValue(request.getParameter("weekInterval"));
    String wFrequency=Util.null2String(request.getParameter("wFrequency"));
    
    String quarterCondition1=Util.null2String(request.getParameter("quarterCondition1"));
    String quarterCondition2=Util.null2String(request.getParameter("quarterCondition2"));
    int quarterConCount=Util.getIntValue(request.getParameter("quarterConCount"));
    int quarterAlertCount=Util.getIntValue(request.getParameter("quarterAlertCount"));
    String quarterAlertUnit=Util.null2String(request.getParameter("quarterAlertUnit"));
    int quarterFrequency=Util.getIntValue(request.getParameter("quarterFrequency"));
    int quarterInterval=Util.getIntValue(request.getParameter("quarterInterval"));
    String qFrequency=Util.null2String(request.getParameter("qFrequency"));
    yearFrequency=(yFrequency.equals("0"))?1:yearFrequency;
    weekFrequency=(wFrequency.equals("0"))?1:weekFrequency;
    monthFrequency=(mFrequency.equals("0"))?1:monthFrequency;
    quarterFrequency=(qFrequency.equals("0"))?1:quarterFrequency;
    
    
      rsb.execute("select * from HrmPerformanceAlert where type_a='"+type+"' ");
      if (!rsb.next())
      {
      
      sql=" insert into HrmPerformanceAlert (type_a, yearCondition1, yearCondition2, yearConCount, yearAlertCount, "+
      "yearAlertUnit, yearFrequency, yearInterval, monthCondition1, monthCondition2, "+
      "monthConCount, monthAlertCount, monthAlertUnit, monthFrequency, monthInterval, "+
      "quarterCondition1, quarterCondition2, quarterConCount, quarterAlertCount, "+
      "quarterAlertUnit, quarterFrequency, quarterInterval, weekCondition1, weekCondition2, "+
      "weekConCount, weekAlertCount, weekAlertUnit, weekFrequency,weekInterval) values('"+type+"', " +
     "  '"+yearCondition1+"','"+yearCondition2+"', " +
     "  "+yearConCount+","+yearAlertCount+",'"+yearAlertUnit+"',"+yearFrequency+","+yearInterval+" , " +
     "  '"+monthCondition1+"','"+monthCondition2+"',  " +
     "  "+monthConCount+","+monthAlertCount+",'"+monthAlertUnit+"',"+monthFrequency+","+monthInterval+" , " +
     "  '"+quarterCondition1+"','"+quarterCondition2+"',  " +
     "  "+quarterConCount+","+quarterAlertCount+",'"+quarterAlertUnit+"',"+quarterFrequency+","+quarterInterval+" , " +
     "  '"+weekCondition1+"','"+weekCondition2+"',  " +
     "  "+weekConCount+","+weekAlertCount+",'"+weekAlertUnit+"',"+weekFrequency+","+weekInterval+" )";
      
      rs.execute(sql); 
      }
      else
      {
     sql="update HrmPerformanceAlert set " +
      "  yearCondition1='"+yearCondition1+"',yearCondition2='"+yearCondition2+"', " +
     "  yearConCount="+yearConCount+",yearAlertCount="+yearAlertCount+",yearAlertUnit='"+yearAlertUnit+"',yearFrequency="+yearFrequency+",yearInterval="+yearInterval+" , " +
     "  monthCondition1='"+monthCondition1+"',monthCondition2='"+monthCondition2+"',  " +
     "  monthConCount="+monthConCount+",monthAlertCount="+monthAlertCount+",monthAlertUnit='"+monthAlertUnit+"',monthFrequency="+monthFrequency+",monthInterval="+monthInterval+" , " +
     "  quarterCondition1='"+quarterCondition1+"',quarterCondition2='"+quarterCondition2+"',  " +
     "  quarterConCount="+quarterConCount+",quarterAlertCount="+quarterAlertCount+",quarterAlertUnit='"+quarterAlertUnit+"',quarterFrequency="+quarterFrequency+",quarterInterval="+quarterInterval+" , " +
     "  weekCondition1='"+weekCondition1+"',weekCondition2='"+weekCondition2+"',  " +
     "  weekConCount="+weekConCount+",weekAlertCount="+weekAlertCount+",weekAlertUnit='"+weekAlertUnit+"',weekFrequency="+weekFrequency+",weekInterval="+weekInterval+" "+ 
     "where type_a='"+type+"' ";
     rs.execute(sql); 
      }
      response.sendRedirect("alertListType.jsp?type="+type);
    
    %>
 