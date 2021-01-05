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
String leavetype = Util.null2String(request.getParameter("leavetype"));
String sql = "";
String allsubcompanyid = SubCompanyComInfo.getSubCompanyTreeStr(subcompanyid+"");

String temp1=",";
int a[] = CheckSubCompanyRight.getSubComByUserRightId(user.getUID(),"PSLPeriod:All");
for(int j=0;j<a.length;j++) {
   temp1+=a[j]+",";
}

ArrayList rightsub = SubCompanyComInfo.getRightSubCompany(user.getUID(),"PSLBatch:All");
String temp = "";
if(rightsub!=null){
   for(int i=0;i<rightsub.size();i++){
      if((","+allsubcompanyid).indexOf(","+rightsub.get(i).toString()+",")>-1 && temp1.indexOf(","+rightsub.get(i).toString()+",")>-1 ) temp += rightsub.get(i).toString()+",";
   }
}
allsubcompanyid = temp + subcompanyid;

if(operation.equals("add")){
   if(!HrmUserVarify.checkUserRight("PSLBatch:All",user)){
      response.sendRedirect("/notice/noright.jsp");
      return;
   }
   String workingage = Util.null2String(request.getParameter("workingage"));
   String PSLdays = Util.null2String(request.getParameter("PSLdays"));
   
   sql = "select * from HrmPSLBatchProcess where workingage = '" + workingage + "' and subcompanyid = '" + subcompanyid + "' and leavetype="+leavetype;
   RecordSet.executeSql(sql);
   if(RecordSet.next()){
     response.sendRedirect("PSLBatchAdd.jsp?msgid=12&subcompanyid="+subcompanyid+"&leavetype="+leavetype);
     return;
   }
   sql = "insert into HrmPSLBatchProcess (workingage,PSLdays,subcompanyid,leavetype) values ('"+workingage+"','"+PSLdays+"','"+subcompanyid+"','"+leavetype+"')";
   RecordSet.executeSql(sql);
         
   response.sendRedirect("PSLBatchAdd.jsp?isclose=1&subcompanyid="+subcompanyid+"&leavetype="+leavetype);
}else if(operation.equals("edit")){
   if(!HrmUserVarify.checkUserRight("PSLBatch:All",user)){
      response.sendRedirect("/notice/noright.jsp");
      return;
   }
   String workingage = Util.null2String(request.getParameter("workingage"));
   String PSLdays = Util.null2String(request.getParameter("PSLdays"));
   String id = Util.null2String(request.getParameter("id"));
   
   sql = "select * from HrmPSLBatchProcess where workingage = '" + workingage + "' and id not in("+id+") and subcompanyid = '" + subcompanyid + "' and leavetype="+leavetype;
   RecordSet.executeSql(sql);
   if(RecordSet.next()){
     response.sendRedirect("PSLBatchEdit.jsp?isclose=1&msgid=12&id="+id+"&subcompanyid="+subcompanyid+"&leavetype="+leavetype);
     return;
   }
   sql = "update HrmPSLBatchProcess set workingage = '"+workingage+"',PSLdays = '" + PSLdays +"',leavetype = '" + leavetype + "' where id = " + id;
   RecordSet.executeSql(sql);

   response.sendRedirect("PSLBatchEdit.jsp?isclose=1&subcompanyid="+subcompanyid+"&leavetype="+leavetype);
}else if(operation.equals("delete")){
   if(!HrmUserVarify.checkUserRight("PSLBatch:All",user)){
      response.sendRedirect("/notice/noright.jsp");
      return;
   }
   String ids = Util.null2String(request.getParameter("ids"));
   String id = Util.null2String(request.getParameter("id"));
   if(!id.equals("")){
      sql = "delete from HrmPSLBatchProcess where id = " + id;
   }
   if(!ids.equals("")){
      ids = ids + "-1";
      sql = "delete from HrmPSLBatchProcess where id in (" + ids + ")";
   }
   RecordSet.executeSql(sql);

   response.sendRedirect("PSLBatchView.jsp?subcompanyid="+subcompanyid+"&leavetype="+leavetype);
}else if(operation.equals("syn")){
   if(!HrmUserVarify.checkUserRight("PSLBatch:All",user)){
      response.sendRedirect("/notice/noright.jsp");
      return;
   }
   String ids = Util.null2String(request.getParameter("ids")) + "-1";
   String _workingage = "";
   sql = "select * from HrmPSLBatchProcess where id in (" + ids + ")";
   RecordSet.executeSql(sql);
   while(RecordSet.next()){
      _workingage += RecordSet.getString("workingage") + ",";
   }
   _workingage += "-1";
   sql = "delete from HrmPSLBatchProcess where subcompanyid in ("+allsubcompanyid+") and subcompanyid <> " + subcompanyid + " and workingage in (" + _workingage + ") and leavetype = "+leavetype;
   RecordSet.executeSql(sql);
   String _tempsubcompanyid[] = Util.TokenizerString2(allsubcompanyid,",");
   sql = "select * from HrmPSLBatchProcess where subcompanyid = " + subcompanyid + " and id in (" + ids + ") and leavetype = "+leavetype;
   RecordSet.executeSql(sql);
   while(RecordSet.next()){
     String workingage = RecordSet.getString("workingage");
     String PSLdays = RecordSet.getString("PSLdays");
     for(int i=0;i<_tempsubcompanyid.length;i++){
         if(_tempsubcompanyid[i].equals(subcompanyid)) continue;
         sql = "insert into HrmPSLBatchProcess (workingage,PSLdays,subcompanyid,leavetype) values ('"+workingage+"','"+PSLdays+"','"+_tempsubcompanyid[i]+"','" + leavetype + "')";
         rs.executeSql(sql);        
     }
   }
   
   response.sendRedirect("PSLBatchView.jsp?subcompanyid="+subcompanyid+"&leavetype="+leavetype);   
}else if(operation.equals("syndelete")){
   if(!HrmUserVarify.checkUserRight("PSLBatch:All",user)){
      response.sendRedirect("/notice/noright.jsp");
      return;
   }
   String ids = Util.null2String(request.getParameter("ids")) + "-1";
   String _workingage = "";
   sql = "select * from HrmPSLBatchProcess where id in (" + ids + ")";
   RecordSet.executeSql(sql);
   while(RecordSet.next()){
      _workingage += RecordSet.getString("workingage") + ",";
   }
   _workingage += "-1";
   sql = "delete from HrmPSLBatchProcess where subcompanyid in ("+allsubcompanyid+") and workingage in (" + _workingage + ") and leavetype = "+leavetype;
   RecordSet.executeSql(sql);

   response.sendRedirect("PSLBatchView.jsp?subcompanyid="+subcompanyid+"&leavetype="+leavetype);
}

%>