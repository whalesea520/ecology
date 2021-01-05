<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%

String operation = Util.null2String(request.getParameter("operation"));
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String leavetype = Util.null2String(request.getParameter("leavetype"));
String sql = "";
String allsubcompanyid = SubCompanyComInfo.getSubCompanyTreeStr(subcompanyid+"")+subcompanyid;
ArrayList rightsub = SubCompanyComInfo.getRightSubCompany(user.getUID(),"PSLPeriod:All");

String temp1=",";
int a[] = CheckSubCompanyRight.getSubComByUserRightId(user.getUID(),"PSLPeriod:All");
for(int j=0;j<a.length;j++) {
   temp1+=a[j]+",";
}

String temp = "";
if(rightsub!=null){
   for(int i=0;i<rightsub.size();i++){
      if((","+allsubcompanyid).indexOf(","+rightsub.get(i).toString()+",")>-1 && temp1.indexOf(","+rightsub.get(i).toString()+",")>-1 ) temp += rightsub.get(i).toString()+",";
   }
}
allsubcompanyid = temp + subcompanyid;

if(operation.equals("add")){
   if(!HrmUserVarify.checkUserRight("PSLPeriod:All" , user)) {
	  response.sendRedirect("/notice/noright.jsp") ; 
	  return ; 
   }
   String PSLyear = Util.null2String(request.getParameter("PSLyear"));
   String startdate = Util.null2String(request.getParameter("startdate"));
   String enddate = Util.null2String(request.getParameter("enddate"));
   
   sql = "select * from HrmPSLPeriod where PSLyear = '" + PSLyear + "' and subcompanyid='"+subcompanyid+"' and leavetype="+leavetype;
   RecordSet.executeSql(sql);
   if(RecordSet.next()){
     response.sendRedirect("PSLPeriodAdd.jsp?msgid=12&subcompanyid="+subcompanyid+"&leavetype="+leavetype);
     return;
   }
   sql = "insert into HrmPSLPeriod (PSLyear,startdate,enddate,subcompanyid,leavetype) values ('" + PSLyear + "','" + startdate + "','" + enddate + "','" + subcompanyid + "','" + leavetype + "')";
   RecordSet.executeSql(sql);
         
   response.sendRedirect("PSLPeriodAdd.jsp?isclose=1&subcompanyid="+subcompanyid+"&leavetype="+leavetype);
}else if(operation.equals("edit")){
   if(!HrmUserVarify.checkUserRight("PSLPeriod:All" , user)) {
	  response.sendRedirect("/notice/noright.jsp") ; 
	  return ; 
   }
   String PSLyear = Util.null2String(request.getParameter("PSLyear"));
   String startdate = Util.null2String(request.getParameter("startdate"));
   String enddate = Util.null2String(request.getParameter("enddate"));
   String id = Util.null2String(request.getParameter("id"));
   
   sql = "select * from HrmPSLPeriod where PSLyear = '" + PSLyear + "' and id not in("+id+") and subcompanyid = '" + subcompanyid + "'and leavetype="+leavetype;
   RecordSet.executeSql(sql);
   if(RecordSet.next()){
     response.sendRedirect("PSLPeriodEdit.jsp?msgid=12&isclose=1&id="+id+"&subcompanyid="+subcompanyid);
     return;
   }
   sql = "update HrmPSLPeriod set PSLyear = '"+PSLyear+"',startdate = '" + startdate +"',enddate = '" + enddate + "',leavetype = '" + leavetype + "' where id = " + id;
   RecordSet.executeSql(sql);

   response.sendRedirect("PSLPeriodEdit.jsp?isclose=1&id="+id+"&subcompanyid="+subcompanyid+"&leavetype="+leavetype);
}else if(operation.equals("delete")){
   if(!HrmUserVarify.checkUserRight("PSLPeriod:All" , user)) {
	  response.sendRedirect("/notice/noright.jsp") ; 
	  return ; 
   }
   String id = Util.null2String(request.getParameter("id"));
   sql = "delete from HrmPSLPeriod where id = " + id;
   RecordSet.executeSql(sql);

   response.sendRedirect("PSLPeriodView.jsp?subcompanyid="+subcompanyid+"&leavetype="+leavetype);
}else if(operation.equals("syn")){
   if(!HrmUserVarify.checkUserRight("PSLPeriod:All" , user)) {
	  response.sendRedirect("/notice/noright.jsp") ; 
	  return ; 
   }
   String ids = request.getParameter("ids");
   String _PSLyear = "";
   sql = "select * from HrmPSLPeriod where id in (" + ids + ")";
   RecordSet.executeSql(sql);
   while(RecordSet.next()){
      _PSLyear += RecordSet.getString("PSLyear") + ","; 
   }
   _PSLyear += "-1";
   sql = "delete from HrmPSLPeriod where subcompanyid in ("+allsubcompanyid+") and subcompanyid <> " + subcompanyid + " and PSLyear in (" + _PSLyear + ") and leavetype = "+leavetype;
   RecordSet.executeSql(sql);
   String _tempsubcompanyid[] = Util.TokenizerString2(allsubcompanyid,",");
   sql = "select * from HrmPSLPeriod where subcompanyid = " + subcompanyid + " and id in (" + ids + ") and leavetype = "+leavetype;
   RecordSet.executeSql(sql);
   while(RecordSet.next()){
     String PSLyear = RecordSet.getString("PSLyear");
     String startdate = RecordSet.getString("startdate");
     String enddate = RecordSet.getString("enddate");
     for(int i=0;i<_tempsubcompanyid.length;i++){
         if(_tempsubcompanyid[i].equals(subcompanyid)) continue;
         sql = "insert into HrmPSLPeriod (PSLyear,startdate,enddate,subcompanyid,leavetype) values ('" + PSLyear + "','" + startdate + "','" + enddate + "','" + _tempsubcompanyid[i] + "','" + leavetype + "')";
         rs.executeSql(sql);        
     }
   }
   
   response.sendRedirect("PSLPeriodView.jsp?subcompanyid="+subcompanyid+"&leavetype="+leavetype);   
}else if(operation.equals("syndelete")){
   if(!HrmUserVarify.checkUserRight("PSLPeriod:All" , user)) {
	  response.sendRedirect("/notice/noright.jsp") ; 
	  return ; 
   }
   String ids = request.getParameter("ids") + "-1";
   String _PSLyear = "";
   sql = "select * from HrmPSLPeriod where id in (" + ids + ")";
   RecordSet.executeSql(sql);
   while(RecordSet.next()){
      _PSLyear += RecordSet.getString("PSLyear") + ","; 
   }
   _PSLyear += "-1";
   sql = "delete from HrmPSLPeriod where subcompanyid in ("+allsubcompanyid+") and PSLyear in (" + _PSLyear + ") and leavetype = "+leavetype;
   RecordSet.executeSql(sql);

   response.sendRedirect("PSLPeriodView.jsp?subcompanyid="+subcompanyid+"&leavetype="+leavetype);
}

%>