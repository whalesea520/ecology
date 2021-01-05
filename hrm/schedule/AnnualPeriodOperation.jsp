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
String sql = "";
String allsubcompanyid = SubCompanyComInfo.getSubCompanyTreeStr(subcompanyid+"")+subcompanyid;
ArrayList rightsub = SubCompanyComInfo.getRightSubCompany(user.getUID(),"AnnualPeriod:All");

String temp1=",";
int a[] = CheckSubCompanyRight.getSubComByUserRightId(user.getUID(),"AnnualPeriod:All");
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
   if(!HrmUserVarify.checkUserRight("AnnualPeriod:All" , user)) {
	  response.sendRedirect("/notice/noright.jsp") ; 
	  return ; 
   }
   String annualyear = Util.null2String(request.getParameter("annualyear"));
   String startdate = Util.null2String(request.getParameter("startdate"));
   String enddate = Util.null2String(request.getParameter("enddate"));
   
   sql = "select * from hrmannualperiod where annualyear = '" + annualyear + "' and subcompanyid='"+subcompanyid+"'";
   RecordSet.executeSql(sql);
   if(RecordSet.next()){
     response.sendRedirect("AnnualPeriodAdd.jsp?msgid=12&subcompanyid="+subcompanyid);
     return;
   }
   sql = "insert into hrmannualperiod (annualyear,startdate,enddate,subcompanyid) values ('" + annualyear + "','" + startdate + "','" + enddate + "','" + subcompanyid + "')";
   RecordSet.executeSql(sql);
         
   response.sendRedirect("AnnualPeriodAdd.jsp?isclose=1&subcompanyid="+subcompanyid);
}else if(operation.equals("edit")){
   if(!HrmUserVarify.checkUserRight("AnnualPeriod:All" , user)) {
	  response.sendRedirect("/notice/noright.jsp") ; 
	  return ; 
   }
   String annualyear = Util.null2String(request.getParameter("annualyear"));
   String startdate = Util.null2String(request.getParameter("startdate"));
   String enddate = Util.null2String(request.getParameter("enddate"));
   String id = Util.null2String(request.getParameter("id"));
   
   sql = "select * from hrmannualperiod where annualyear = '" + annualyear + "' and id not in("+id+") and subcompanyid = '" + subcompanyid + "'";
   RecordSet.executeSql(sql);
   if(RecordSet.next()){
     response.sendRedirect("AnnualPeriodEdit.jsp?isclose=1&msgid=12&id="+id+"&subcompanyid="+subcompanyid);
     return;
   }
   sql = "update hrmannualperiod set annualyear = '"+annualyear+"',startdate = '" + startdate +"',enddate = '" + enddate + "' where id = " + id;
   RecordSet.executeSql(sql);

   response.sendRedirect("AnnualPeriodEdit.jsp?isclose=1&id="+id+"&subcompanyid="+subcompanyid);
}else if(operation.equals("delete")){
   if(!HrmUserVarify.checkUserRight("AnnualPeriod:All" , user)) {
	  response.sendRedirect("/notice/noright.jsp") ; 
	  return ; 
   }
   String id = Util.null2String(request.getParameter("id"));
   String ids = Util.null2String(request.getParameter("ids"));
   if(!id.equals("")){
      sql = "delete from hrmannualperiod where id = " + id;
   }
   if(!ids.equals("")){
      ids = ids + "-1";
      sql = "delete from hrmannualperiod where id in (" + ids + ")";
   }
   RecordSet.executeSql(sql);

   response.sendRedirect("AnnualPeriodView.jsp?subcompanyid="+subcompanyid);
}else if(operation.equals("syn")){
   if(!HrmUserVarify.checkUserRight("AnnualPeriod:All" , user)) {
	  response.sendRedirect("/notice/noright.jsp") ; 
	  return ; 
   }
   String ids = request.getParameter("ids");
   if(ids.length()==0)ids="-1";
   String _annualyear = "";
   sql = "select * from hrmannualperiod where id in (" + ids + ")";
   RecordSet.executeSql(sql);
   while(RecordSet.next()){
      _annualyear += RecordSet.getString("annualyear") + ","; 
   }
   _annualyear += "-1";
   
   sql = "delete from hrmannualperiod where subcompanyid in ("+allsubcompanyid+") and subcompanyid <> " + subcompanyid + " and annualyear in (" + _annualyear + ")";
   RecordSet.executeSql(sql);
   String _tempsubcompanyid[] = Util.TokenizerString2(allsubcompanyid,",");
   sql = "select * from hrmannualperiod where subcompanyid = " + subcompanyid + " and id in (" + ids + ")";
   RecordSet.executeSql(sql);
   while(RecordSet.next()){
  	 String annualyear = RecordSet.getString("annualyear");
     String startdate = RecordSet.getString("startdate");
     String enddate = RecordSet.getString("enddate");
     for(int i=0;i<_tempsubcompanyid.length;i++){
         if(_tempsubcompanyid[i].equals(subcompanyid)) continue;
         sql = "insert into hrmannualperiod (annualyear,startdate,enddate,subcompanyid) values ('" + annualyear + "','" + startdate + "','" + enddate + "','" + _tempsubcompanyid[i] + "')";
         rs.executeSql(sql);        
     }
   }
   
   response.sendRedirect("AnnualPeriodView.jsp?subcompanyid="+subcompanyid);   
}else if(operation.equals("syndelete")){
   if(!HrmUserVarify.checkUserRight("AnnualPeriod:All" , user)) {
	  response.sendRedirect("/notice/noright.jsp") ; 
	  return ; 
   }
   String ids = request.getParameter("ids") + "-1";
   String _annualyear = "";
   sql = "select * from hrmannualperiod where id in (" + ids + ")";
   RecordSet.executeSql(sql);
   while(RecordSet.next()){
      _annualyear += RecordSet.getString("annualyear") + ","; 
   }
   _annualyear += "-1";
   sql = "delete from hrmannualperiod where subcompanyid in ("+allsubcompanyid+") and annualyear in (" + _annualyear + ")";
   RecordSet.executeSql(sql);

   response.sendRedirect("AnnualPeriodView.jsp?subcompanyid="+subcompanyid);
}

%>