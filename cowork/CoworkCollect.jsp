<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.general.Util"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.DateFormat"%>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%

User user = HrmUserVarify.getUser (request , response) ;
int userid =user.getUID();
String itemId = Util.null2String(request.getParameter("itemId"));//主题ID
String discussid = Util.null2String(request.getParameter("discussid"));//楼层ID
String sql="";
int collectcounts=0;
String iscollect="0";//是否收藏
JSONObject results=new JSONObject();

Date date=new Date();
DateFormat format=new SimpleDateFormat("yyyy-MM-dd");
String time=format.format(date);
DateFormat format1=new SimpleDateFormat("HH:mm:ss");
String time1=format1.format(date);

String selectsql="select * from cowork_collect where itemid="+itemId+" and userid="+userid +" and discussid="+discussid;
rs.execute(selectsql);
collectcounts=rs.getCounts();

if(0==collectcounts){
     sql="insert into  cowork_collect(itemid,userid,iscollect,discussid,createdate,createtime) values "+"("+itemId+","+userid+",'1',"+discussid+",'"+time+"','"+time1+"')";
     iscollect="1";
}else{
     sql="delete from  cowork_collect where itemId="+itemId+" and userid="+userid +" and discussid="+discussid;
     iscollect="0";
}
rs.execute(sql);

results.put("iscollect",iscollect);
out.print(results);
%>