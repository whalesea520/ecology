
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.BaseBean"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	try{
		String groupName=Util.null2String(request.getParameter("groupName"));
		String arr[]=request.getParameterValues("id");
		String uid=user.getUID()+"";
		String checkSql = "select name from HrmGroup where name='"+ groupName +"' and owner=" + user.getUID();
		String sql="insert into HrmGroup(name,type,owner)values('"+groupName+"',0,'"+uid+"')";
		if(rs.execute(checkSql) && !rs.next()) {
			if(rs.execute(sql)){
				if(rs.execute("select MAX(id) m from HrmGroup where name = '"+groupName+"'") && rs.next()){
					String 	maxid=rs.getString("m");
					for(int i=0;i<arr.length;i++){
						if(!"".equals(arr[i])){
							sql="insert into HrmGroupMembers(groupid,userid,usertype)values("+maxid+",'"+arr[i]+"','')";
							rs.execute(sql);
						}
					}
				}
			}
		} else {
			out.println("3");; //私人组重复
			return;
		}
	}catch(Exception e){
		new BaseBean().writeLog(e);
		e.printStackTrace();
		out.println("0");
		return;
	}
	out.println("1");
%>
