
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String sellchanceId=Util.null2String(request.getParameter("sellchanceId"));
	String settype=Util.null2String(request.getParameter("settype"));
	if(!sellchanceId.equals("")){
		rs.executeSql("delete from CRM_SellChance_Attention where userId="+user.getUID()+" and sellchanceId="+sellchanceId);
		if(settype.equals("1")){
			rs.executeSql("insert into CRM_SellChance_Attention (userId,sellchanceId) values("+user.getUID()+","+sellchanceId+")");
		}
	}
%>
