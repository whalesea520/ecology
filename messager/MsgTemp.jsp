
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
 <TABLE class="viewform">
 		  
 
 <%
 	String loginid = Util.null2String(request.getParameter("loginid"));
 	String strSql="	select h1.id,h1.lastname,h1.messagerurl,h2.fromjid,h2.countnum from hrmresource h1,"+
		"(select fromJid,count(fromjid) as countnum from HrmMessagerTempMsg where loginid='"+loginid+"' group by fromjid) h2 "+
			"where h1.loginid=h2.fromjid";
 	//out.println(strSql);
 	rs.executeSql(strSql);
 	while(rs.next()){
 		String  userid=Util.null2String(rs.getString("id"));
 		String  lastname=Util.null2String(rs.getString("lastname"));
 		String  messagerurl=Util.null2String(rs.getString("messagerurl"));
 		String  fromjid=Util.null2String(rs.getString("fromjid"));
 		String  countnum=Util.null2String(rs.getString("countnum"));
 		if("".equals(messagerurl)) {
 			messagerurl="/messager/images/icon-blue_wev8.gif";
 		} else {
 			messagerurl="/messager/usericon/"+messagerurl;
 		}
%>
		 <TR>
 			<TD><img src="<%=messagerurl%>"></TD>
 			<TD><%=lastname%></TD>
 			<TD><a href="#"><%=countnum%></a></TD>
 		  </TR>
 		 <tr><td class="line" colspan="3"></td></tr>
<% 	
	} 	
 %>
 </TABLE>