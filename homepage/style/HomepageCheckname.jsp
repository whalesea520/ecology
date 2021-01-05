
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page"/>
<%
	User user = HrmUserVarify.getUser (request , response);
	if(user == null)  return ;
	String method = Util.null2String(request.getParameter("method"));	
	String name = Util.null2String(request.getParameter("name"));
	String hpid = Util.null2String(request.getParameter("hpid"));	
	String styleid = Util.null2String(request.getParameter("styleid"));	
	String subCompanyId = Util.null2String(request.getParameter("subcompanyid"));
	//baseBean.writeLog("method: "+method);
	//baseBean.writeLog("name: "+name);
	
	if("checkname".equals(method)){
		rs.executeSql("select id from hpstyle where stylename='"+name+"' and id!="+styleid);
		if(rs.next()) out.println("use");
		else  out.println("no use");
	} else 	if("checkHomepagename".equals(method)){
		if(!"".equals(hpid) && !"0".equals(hpid)){
		   rs.executeSql("select id from hpinfo where infoname='"+name+"' and id!="+hpid +" and subcompanyid="+subCompanyId);
		   baseBean.writeLog("select id from hpinfo where infoname='"+name+"' and id!="+hpid +" and subcompanyid="+subCompanyId);
		}else{
		   rs.executeSql("select id from hpinfo where infoname='"+name+"' and subcompanyid="+subCompanyId);
		   baseBean.writeLog("select id from hpinfo where infoname='"+name+"' and subcompanyid="+subCompanyId);
		}
		if(rs.next()) out.println("use");
		else  out.println("no use");
	}
%>