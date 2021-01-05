<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/web/inc/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<%
String sqlStr = "" ;
String sqlTemp = "" ;
String method = Util.null2String(request.getParameter("method"));

String webIDs[]=request.getParameterValues("webIDs");
if(method.equals("save"))
{

	String CustomerIDTemp= ","+user.getUID()+",";
	String idTemp = "" ;
	String userListTemp = "" ;
	String mailListTemp = "" ;
	String mailListUserTemp1 = "" ;
	String mailListUserTemp2 = "" ;
	sqlStr = "select id,userList from webMailList order by id " ;
	rs.executeSql(sqlStr);
	while(rs.next())
	{
		userListTemp = "" ;
		idTemp = Util.null2String(rs.getString("id"));
		userListTemp = Util.null2String(rs.getString("userList"));
		if (!userListTemp.equals("")) 
		{
			userListTemp ="," + userListTemp + "," ;
			userListTemp = Util.StringReplaceOnce(userListTemp,CustomerIDTemp,",");
			userListTemp.trim();
			if (userListTemp.equals(",")) userListTemp = "" ;
			else 
				{
				userListTemp = userListTemp.substring(1,(userListTemp.length()-1)) ;
				}
			sqlTemp = "update webMailList set userList = '"+userListTemp+"' where id = " +  idTemp;
			RecordSet.executeSql(sqlTemp);
		}		
	}

	if(webIDs != null)
	{
		for(int i=0;i<webIDs.length;i++)
		{
            mailListUserTemp1 = "" ;
			mailListUserTemp2 = "" ;
			sqlTemp = "select userList from webMailList where id = " +  webIDs[i];
			RecordSet.executeSql(sqlTemp);
			if (RecordSet.next())
				mailListUserTemp1 = Util.null2String(RecordSet.getString("userList"));
			mailListUserTemp2 = mailListUserTemp1 ;
			if (!mailListUserTemp1.equals("")) 
			{
				mailListUserTemp1 ="," + mailListUserTemp1 + "," ;
				mailListUserTemp2 += "," ;
			}
			if (mailListUserTemp1.indexOf(CustomerIDTemp)==-1)
			{
				mailListUserTemp2 += "" + user.getUID() ;
				sqlTemp = "update webMailList set userList = '"+mailListUserTemp2+"' where id = " +  webIDs[i];
				RecordSet.executeSql(sqlTemp);
			}		
		}

	}

}
%>

<script>
    alert("系统提示：重新选择邮件列表操作成功!");
    window.location = "/web/mailList/MailListForCRM.jsp";
</script>