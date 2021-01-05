<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,weaver.hrm.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String inputid = ""+Util.getIntValue(request.getParameter("inputid"),0);
String crmid = ""+Util.getIntValue(request.getParameter("crmid"),0);
String contacterid = ""+Util.getIntValue(request.getParameter("contactid"),0);
String sql = "" ;

Calendar todaycal = Calendar.getInstance ();
String date = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;
String inprepid = "" ;
int countfade=0;
boolean sendok = false;
sql = "select inprepid from T_ResearchTable where inputid="+inputid ;
rs.executeSql(sql) ;
if(rs.next()) inprepid = rs.getString("inprepid") ;

char separator = Util.getSeparator() ;
String para = crmid + separator + inprepid + separator + contacterid + separator + inputid + separator + date ;
sendok=rs.executeProc("T_FadeBespeak_Insert",para);

sql = " UPDATE T_InceptForm SET state=3 WHERE inputid="+inputid+" and crmid ="+crmid+ " and contacterid="+contacterid ;
rs.executeSql(sql);

sql = " select countfade from T_ResearchTable where inputid ="+inputid ; 
rs1.executeSql(sql) ;
if(rs1.next()) countfade = Util.getIntValue(rs1.getString("countfade"),0) ;
countfade = countfade + 1 ;

sql = " UPDATE T_ResearchTable SET countfade="+""+countfade+ " WHERE inputid="+inputid ;
rs.executeSql(sql);

if(sendok){
    response.sendRedirect("/CRM/investigate/OkCancel.htm");    
}else{
    response.sendRedirect("/CRM/investigate/BaulkCancel.htm");
}    
%>