
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ReportComInfo" class="weaver.workflow.report.ReportComInfo" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String operation = Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator() ;
String currentdate = TimeUtil.getCurrentDateString();
String currenttime = TimeUtil.getOnlyCurrentTimeString();

if(operation.equals("customadd")){
	String sql = "";
    String Customname = "" + Util.null2String(request.getParameter("Customname"));
    String Customdesc = "" + Util.fromScreen3(request.getParameter("Customdesc"),user.getLanguage());
    
	RecordSet.executeSql("INSERT INTO mode_custompage(customname,customdesc,creater,createdate,createtime) VALUES ('" + Customname + "','"+Customdesc+"',"+user.getUID()+",'"+currentdate+"','"+currenttime+"')");
    RecordSet.executeSql("select max(id) as id from mode_custompage where customname = '"+Customname+"' and creater = " + user.getUID());
    RecordSet.next();
    String id = RecordSet.getString("id");
    int rowno = Util.getIntValue(request.getParameter("rowno"),0);
    for(int i=0;i<rowno;i++){
    	String hrefname = Util.null2String(request.getParameter("hrefname_"+i));
    	String hreftitle = Util.null2String(request.getParameter("hreftitle_"+i));
    	String hrefdesc = Util.null2String(request.getParameter("hrefdesc_"+i));
    	String hrefaddress = Util.null2String(request.getParameter("hrefaddress_"+i));
    	double disorder = Util.getDoubleValue(request.getParameter("disorder_"+i),0);
    	if(!hrefname.equals("")&&!hrefaddress.equals("")){
    		sql = "insert into mode_custompagedetail(mainid,hrefname,hreftitle,hrefdesc,hrefaddress,disorder) values ("+id+",'"+hrefname+"','"+hreftitle+"','"+hrefdesc+"','"+hrefaddress+"',"+disorder+")";
    		RecordSet.executeSql(sql);
    	}
    }
    
	response.sendRedirect("/formmode/custompage/CustomPageEdit.jsp?id="+id);
} else if(operation.equals("customedit")) {//
	String id = ""+Util.getIntValue(request.getParameter("id"), 0);
	if(!id.equals("")&&!id.equals("0")){
	    String Customname = "" + Util.null2String(request.getParameter("Customname"));
	    String Customdesc = "" + Util.fromScreen3(request.getParameter("Customdesc"),user.getLanguage());
		String modeid = Util.null2String(request.getParameter("modeid"));//如果模式id修改了，而且表单不一样，则删除原先的数据。
		String sql = "";
		sql = "update mode_custompage set Customname = '"+Customname+"',Customdesc = '"+Customdesc+"' where id = "+id;
		rs.executeSql(sql);
		sql = "delete from mode_custompagedetail where mainid = " + id;
		rs.executeSql(sql);
	    
		int rowno = Util.getIntValue(request.getParameter("rowno"),0);
	    for(int i=0;i<rowno;i++){
	    	String hrefname = Util.null2String(request.getParameter("hrefname_"+i));
	    	String hreftitle = Util.null2String(request.getParameter("hreftitle_"+i));
	    	String hrefdesc = Util.null2String(request.getParameter("hrefdesc_"+i));
	    	String hrefaddress = Util.null2String(request.getParameter("hrefaddress_"+i));
	    	double disorder = Util.getDoubleValue(request.getParameter("disorder_"+i),0);
	    	if(!hrefname.equals("")&&!hrefaddress.equals("")){
	    		sql = "insert into mode_custompagedetail(mainid,hrefname,hreftitle,hrefdesc,hrefaddress,disorder) values ("+id+",'"+hrefname+"','"+hreftitle+"','"+hrefdesc+"','"+hrefaddress+"',"+disorder+")";
	    		rs.executeSql(sql);
	    	}
	    }
	}
	response.sendRedirect("/formmode/custompage/CustomPageEdit.jsp?id="+id);
} else if(operation.equals("customdelete")) {
  	int id = Util.getIntValue(request.getParameter("id"));
  	String sql = "";
  	sql = "delete from mode_custompage where id=" + id;
  	rs.execute(sql);
	sql = "delete from mode_custompagedetail where customid = " + id;
	rs.executeSql(sql);    
    response.sendRedirect("/formmode/custompage/CustomList.jsp");
}
%>