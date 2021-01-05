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
<jsp:useBean id="updaters" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="coworkshare" class="weaver.cowork.CoworkShareManager" scope="page"/>
<%

User user = HrmUserVarify.getUser (request , response) ;
int userid =user.getUID();
String itemId = Util.null2String(request.getParameter("itemId"));//主题ID
String sql="";
JSONObject results=new JSONObject();

Date date=new Date();
DateFormat format=new SimpleDateFormat("yyyy-MM-dd");
String time=format.format(date);
DateFormat format1=new SimpleDateFormat("HH:mm:ss");
String time1=format1.format(date);

//往退出表中加入记录
rs.execute("select *from cowork_quiter where itemid="+itemId+"and userid="+userid);

if(rs.getCounts()==0){
sql="insert into  cowork_quiter(itemid,userid,quitdate,quittime) values "+"("+itemId+","+userid+",'"+time+"','"+time1+"')";
}

rs.execute(sql);

//删除当前退出人在参与表中的记录
rs.execute("select content,id from coworkshare where sourceid="+itemId +"and srcfrom=1 and content like '%,"+userid+",%'" );
while (rs.next()){
    String newcontent=rs.getString("content").replace(userid+"","");
    String id=rs.getString("id");
    String updatesql="update coworkshare set content='"+newcontent+"' where sourceid="+itemId +"and srcfrom=1 and id ="+id ;
    updaters.execute(updatesql);
}

//删除退出协作人的已读信息
rs.execute("delete from cowork_read where coworkid="+itemId +"and userid="+userid);

//删除参与人等缓存信息
coworkshare.deleteCache("parter",itemId);
coworkshare.deleteCache("typemanager",itemId);

out.print(results);
%>