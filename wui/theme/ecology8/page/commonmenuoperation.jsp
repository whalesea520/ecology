
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.hrm.*,weaver.general.*"%>
<jsp:useBean id="rst" class="weaver.conn.RecordSetTrans" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
User user = HrmUserVarify.getUser(request,response);
if(user == null)  return ;

	String method = request.getParameter("method");
	if("save".equals(method)){
		String msg = "OK";
		String[] menushowids = Util.TokenizerStringNew(Util.null2String(request.getParameter("menushowids")),",");
		rst.setAutoCommit(false);
		try{
			rst.execute("delete from UserCommonMenu where userid="+user.getUID());
			for(int i=0;i<menushowids.length;i++){
				//rst.executeSql("insert into UserCommonMenu (userid,menuid) values("+user.getUID()+",'"+menushowids[i]+"')");
				rst.executeUpdate("insert into UserCommonMenu (userid,menuid) values(?,?)",user.getUID(), menushowids[i]);
			}
			rst.commit();
		}catch(Exception e){
			rst.rollback();
			rst.writeLog(e);
			msg = "error";
		}
		out.println(msg);
	}else if("del".equals(method)){
			String menuid = request.getParameter("menuid");
			
			//rs.executeSql("delete from UserCommonMenu where userid="+user.getUID()+" and menuid='"+menuid+"'");
			//rs.executeSql("delete from UserCommonMenu where userid="+user.getUID()+" and menuid='"+menuid+"'");
			rs.executeUpdate("delete from UserCommonMenu where userid=? and menuid=?", user.getUID(),menuid);
			
			//rs.executeSql("SELECT parentid FROM LeftMenuInfo WHERE id = 12");
			
	}else if("clear".equals(method)){
		//String menuid = request.getParameter("menuid");
		
		//rs.executeSql("delete from UserCommonMenu where userid="+user.getUID());
		rs.executeUpdate("delete from UserCommonMenu where userid=?",user.getUID());
		//rs.executeSql("SELECT parentid FROM LeftMenuInfo WHERE id = 12");
		
}
	
	
	

%>