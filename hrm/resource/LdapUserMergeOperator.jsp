
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<html>
<% 
if(!HrmUserVarify.checkUserRight("intergration:ldapsetting",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
//ldap用户id
int ldapUserId = Util.getIntValue(request.getParameter("ldapUserId"),0); 
String ldapUserAccount = Util.null2String(request.getParameter("ldapUserAccount")); 

//oa用户id
int resourceid = Util.getIntValue(request.getParameter("resourceid"),0); 

//System.out.println("ldapUserId="+ldapUserId+", ldapUserAccount="+ldapUserAccount+", resourceid="+resourceid);
String sql = "update HrmResource set loginid='"+ldapUserAccount+"',isADAccount= '1' where id="+resourceid;
boolean flag = rs.executeSql(sql);
if(flag){
	sql = "delete HrmResource where id="+ldapUserId;
	rs.executeSql(sql);

    //删除同步的人员，更改成更新状态。QC：256124，解决账号合并后，再批量指定人员部门列表中依然可以找到之前进行账号合并的AD账号
    // SJZ 2017-03-16
    rs.executeSql("update  HrmResourceTemp set isADAccount= '2' where loginid='"+ldapUserAccount+"'");

}
String message = flag?SystemEnv.getHtmlLabelName(33271,user.getLanguage()):SystemEnv.getHtmlLabelName(33272,user.getLanguage());

ResourceComInfo.removeResourceCache();

response.sendRedirect("/hrm/resource/LdapUserMerge.jsp?isclose=1&id="+ldapUserId);
%>
