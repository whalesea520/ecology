<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.conn.ConnStatement"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

/*用户验证*/
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}

int eid = Util.getIntValue(Util.null2String(request.getParameter("eid")));


String id = request.getParameter("id");
String noticeimgsrc = request.getParameter("noticeimgsrc");
String noticetitle = request.getParameter("noticetitle");
String noticeconent = request.getParameter("noticeconent");
boolean isinsert = true;
boolean isdel = Util.null2String(request.getParameter("isdel")).equals("true");
String delids = Util.null2String(request.getParameter("delids"));
int isfromlist = Util.getIntValue(Util.null2String(request.getParameter("isfromlist")), 0);

if (!"".equals(noticetitle) && !"".equals(noticeimgsrc) && !isdel) {
    ConnStatement statement = null;
    try{
        statement=new ConnStatement();
    if (!"".equals(id)) {
    	RecordSet rs = new RecordSet();
    	rs.executeSql("select 1 from hpElement_notice where id=" + id);
    	if (rs.next()) {
    	    isinsert = false;
    	}
    }
    //System.out.println("isinsert=" + isinsert + ", id=" + id);
    if (isinsert) {
        statement.setStatementSql("insert into hpElement_notice(title, content, imgsrc, creator, creatortype, createdate, createtime, lastupdatedate, lastupdatetime) values (?, ?, ?, ?, ?, ?, ?, ?, ?)");    
    } else {
        statement.setStatementSql("update hpElement_notice set title=?, content=?, imgsrc=?,creator=?, creatortype=?, lastupdatedate=?, lastupdatetime=? where id=" + id);    
    }
    Calendar today = Calendar.getInstance();
    String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" + Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" + Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
	String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" + Util.add0(today.get(Calendar.MINUTE), 2) + ":" + Util.add0(today.get(Calendar.SECOND), 2);
	
    statement.setString(1, noticetitle);
    statement.setString(2, noticeconent);
    statement.setString(3, noticeimgsrc);
    statement.setInt(4, user.getUID());
    statement.setString(5, (Util.getIntValue(user.getLogintype()) - 1) + "");
    statement.setString(6, currentdate);
    statement.setString(7, currenttime);
    if (isinsert) {
        statement.setString(8, currentdate);
        statement.setString(9, currenttime);
    }
    
    statement.executeUpdate();
    statement.close();
}catch(Exception e){
    }finally {
        statement.close();
    }
}

if (isdel) {
    RecordSet rs = new RecordSet();
    rs.executeSql("delete from hpElement_notice where id in (" + delids + "-1)");
    response.getWriter().write("1");
	return;
}

if (isfromlist == 1) { 
    response.getWriter().write("1");
	return;
}
%>
<script>
try {
parent.parentWin.onRefresh('<%=eid %>','newNotice');

} catch (e) {}
try {
	parent.parentWin._table.reLoad();
} catch (e) {}

parent.cancle();
</script>