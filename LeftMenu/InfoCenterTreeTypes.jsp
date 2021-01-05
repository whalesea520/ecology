<%@ page language="java" contentType="text/xml; charset=UTF-8" %><%@ page import="java.util.*,java.lang.reflect.Method" %><%@ page import="weaver.hrm.*,weaver.general.*,weaver.systeminfo.*,weaver.systeminfo.menuconfig.*" %><jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/><%
    response.setHeader("Cache-Control","no-store");
    response.setHeader("Pragrma","no-cache");
    response.setDateHeader("Expires",0);
    User user = HrmUserVarify.getUser(request,response);
    if(user == null)  return ;
    String strOut="<tree>";
    rs.executeSql("select * from newstype order by dspnum,id");
    while (rs.next()){
        strOut+="<tree text=\""+rs.getString("typename")+"\" action=\"javascript:void(0)\" src=\"/LeftMenu/InfoCenterTreeNews1.jsp?typeid="+rs.getString("id")+"\"></tree>";
    }
    strOut+="<tree text=\""+SystemEnv.getHtmlLabelName(811,7)+"\" action=\"javascript:void(0)\" src=\"/LeftMenu/InfoCenterTreeNews1.jsp?typeid=0\"></tree>";
    strOut+="</tree>";
    out.clear();
    out.print(strOut);
%>