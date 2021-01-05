<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.general.Util"%>
<%@page import="net.sf.json.JSONObject"%>


<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page"/>
<%

User user = HrmUserVarify.getUser (request , response) ;
int userid =user.getUID();
String status = Util.null2String(request.getParameter("status"));//踩赞
String itemId = Util.null2String(request.getParameter("itemId"));//主题ID
String discussid = Util.null2String(request.getParameter("discussid"));//楼层ID
String sql="";
int votetype=0;//踩赞类型
JSONObject results=new JSONObject();

String selectsql="select * from cowork_votes where itemId="+itemId+" and userid="+userid +" and status="+status+" and discussid="+discussid;
rs.execute(selectsql);
int votes=rs.getCounts();

if(0==votes){
     sql="insert into  cowork_votes(itemid,userid,status,discussid) values "+"("+itemId+","+userid+","+status+","+discussid+")";
     if("0".equals(status)){
         votetype=0;
     }else{
         votetype=1;
     }
}else{
     sql="delete from  cowork_votes where itemId="+itemId+" and userid="+userid +" and status="+status+" and discussid="+discussid;
     votetype=2;
}
rs1.execute(sql);
rs2.execute("select *  from cowork_votes where itemId="+itemId +" and status=0 and discussid="+discussid);
rs3.execute("select *  from cowork_votes where itemId="+itemId +" and status=1 and discussid="+discussid);


int agreevote=rs2.getCounts();
int disagreevote=rs3.getCounts();


results.put("votetype",votetype);
results.put("agreevote",agreevote);
results.put("disagreevote",disagreevote);


out.print(results);
%>