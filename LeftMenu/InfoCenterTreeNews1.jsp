<%@ page language="java" contentType="text/xml; charset=UTF-8" %><%@ page import="java.util.*,java.lang.reflect.Method" %><%@ page import="weaver.hrm.*,weaver.general.*,weaver.systeminfo.*,weaver.systeminfo.menuconfig.*" %><jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/><%
	response.setHeader("Cache-Control","no-store");response.setHeader("Pragrma","no-cache");
	response.setDateHeader("Expires",0);
	User user = HrmUserVarify.getUser(request,response);
	if(user == null)  return ;
	int typeid=Util.getIntValue(request.getParameter("typeid"),0);
	String strOut="<tree>";
	String strSql="";
	if(typeid==0) {
		strSql="select id,frontpagename from DocFrontpage where isactive='1' and publishtype=1 and (newstypeid=0 or newstypeid is null) order by typeordernum,id";
	} else {
		strSql="select  id,frontpagename from DocFrontpage where isactive='1' and publishtype=1 and newstypeid="+typeid+" order by typeordernum,id";
	}
	//System.out.println(strSql);
        rs.executeSql(strSql);
        while (rs.next()){
		    strOut+="<tree text=\""+rs.getString("frontpagename")+"\" action=\"/docs/news/NewsDsp.jsp?id="+rs.getString("id")+"\" ></tree>";
        }
        strOut+="</tree>";
        out.println(strOut);
    %>