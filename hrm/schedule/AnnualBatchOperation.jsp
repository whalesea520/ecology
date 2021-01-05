<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%

String operation = Util.null2String(request.getParameter("operation"));
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String sql = "";
String allsubcompanyid = SubCompanyComInfo.getSubCompanyTreeStr(subcompanyid+"");

String temp1=",";
int a[] = CheckSubCompanyRight.getSubComByUserRightId(user.getUID(),"AnnualPeriod:All");
for(int j=0;j<a.length;j++) {
   temp1+=a[j]+",";
}

ArrayList rightsub = SubCompanyComInfo.getRightSubCompany(user.getUID(),"AnnualBatch:All");
String temp = "";
if(rightsub!=null){
   for(int i=0;i<rightsub.size();i++){
      if((","+allsubcompanyid).indexOf(","+rightsub.get(i).toString()+",")>-1 && temp1.indexOf(","+rightsub.get(i).toString()+",")>-1 ) temp += rightsub.get(i).toString()+",";
   }
}
allsubcompanyid = temp + subcompanyid;

if(operation.equals("add")){
   if(!HrmUserVarify.checkUserRight("AnnualBatch:All",user)){
      response.sendRedirect("/notice/noright.jsp");
      return;
   }
   String workingage = Util.null2String(request.getParameter("workingage"));
   String annualdays = Util.null2String(request.getParameter("annualdays"));
   
   sql = "select * from HrmAnnualBatchProcess where workingage = '" + workingage + "' and subcompanyid = '" + subcompanyid + "'";
   RecordSet.executeSql(sql);
   if(RecordSet.next()){
     response.sendRedirect("AnnualBatchAdd.jsp?msgid=12&subcompanyid="+subcompanyid);
     return;
   }
   sql = "insert into HrmAnnualBatchProcess (workingage,annualdays,subcompanyid) values ('"+workingage+"','"+annualdays+"','"+subcompanyid+"')";
   RecordSet.executeSql(sql);
         
   response.sendRedirect("AnnualBatchAdd.jsp?isclose=1&subcompanyid="+subcompanyid);
}else if(operation.equals("edit")){
   if(!HrmUserVarify.checkUserRight("AnnualBatch:All",user)){
      response.sendRedirect("/notice/noright.jsp");
      return;
   }
   String workingage = Util.null2String(request.getParameter("workingage"));
   String annualdays = Util.null2String(request.getParameter("annualdays"));
   String id = Util.null2String(request.getParameter("id"));
   
   sql = "select * from HrmAnnualBatchProcess where workingage = '" + workingage + "' and id not in("+id+") and subcompanyid = '" + subcompanyid + "'";
   RecordSet.executeSql(sql);
   if(RecordSet.next()){
     response.sendRedirect("AnnualBatchEdit.jsp?isclose=1&msgid=12&id="+id+"&subcompanyid="+subcompanyid);
     return;
   }
   sql = "update HrmAnnualBatchProcess set workingage = '"+workingage+"',annualdays = '" + annualdays +"' where id = " + id;
   RecordSet.executeSql(sql);

   response.sendRedirect("AnnualBatchEdit.jsp?isclose=1&id="+id+"subcompanyid="+subcompanyid);
}else if(operation.equals("delete")){
   if(!HrmUserVarify.checkUserRight("AnnualBatch:All",user)){
      response.sendRedirect("/notice/noright.jsp");
      return;
   }
   String ids = Util.null2String(request.getParameter("ids"));
   String id = Util.null2String(request.getParameter("id"));
   if(!id.equals("")){
      sql = "delete from HrmAnnualBatchProcess where id = " + id;
   }
   if(!ids.equals("")){
      ids = ids + "-1";
      sql = "delete from HrmAnnualBatchProcess where id in (" + ids + ")";
   }
   RecordSet.executeSql(sql);

   response.sendRedirect("AnnualBatchView.jsp?subcompanyid="+subcompanyid);
}else if(operation.equals("syn")){
   if(!HrmUserVarify.checkUserRight("AnnualBatch:All",user)){
      response.sendRedirect("/notice/noright.jsp");
      return;
   }
   String ids = Util.null2String(request.getParameter("ids")) + "-1";
   String _workingage = "";
   sql = "select * from HrmAnnualBatchProcess where id in (" + ids + ")";
   RecordSet.executeSql(sql);
   while(RecordSet.next()){
      _workingage += RecordSet.getString("workingage") + ",";
   }
   _workingage += "-1";
   sql = "delete from HrmAnnualBatchProcess where subcompanyid in ("+allsubcompanyid+") and subcompanyid <> " + subcompanyid + " and workingage in (" + _workingage + ")";
   RecordSet.executeSql(sql);
   String _tempsubcompanyid[] = Util.TokenizerString2(allsubcompanyid,",");
   sql = "select * from HrmAnnualBatchProcess where subcompanyid = " + subcompanyid + " and id in (" + ids + ")";;
   RecordSet.executeSql(sql);
   while(RecordSet.next()){
     String workingage = RecordSet.getString("workingage");
     String annualdays = RecordSet.getString("annualdays");
     for(int i=0;i<_tempsubcompanyid.length;i++){
         if(_tempsubcompanyid[i].equals(subcompanyid)) continue;
         sql = "insert into HrmAnnualBatchProcess (workingage,annualdays,subcompanyid) values ('"+workingage+"','"+annualdays+"','"+_tempsubcompanyid[i]+"')";
         rs.executeSql(sql);        
     }
   }
   
   response.sendRedirect("AnnualBatchView.jsp?subcompanyid="+subcompanyid);   
}else if(operation.equals("syndelete")){
   if(!HrmUserVarify.checkUserRight("AnnualBatch:All",user)){
      response.sendRedirect("/notice/noright.jsp");
      return;
   }
   String ids = Util.null2String(request.getParameter("ids")) + "-1";
   String _workingage = "";
   sql = "select * from HrmAnnualBatchProcess where id in (" + ids + ")";
   RecordSet.executeSql(sql);
   while(RecordSet.next()){
      _workingage += RecordSet.getString("workingage") + ",";
   }
   _workingage += "-1";
   sql = "delete from HrmAnnualBatchProcess where subcompanyid in ("+allsubcompanyid+") and workingage in (" + _workingage + ")";
   RecordSet.executeSql(sql);

   response.sendRedirect("AnnualBatchView.jsp?subcompanyid="+subcompanyid);
}

%>