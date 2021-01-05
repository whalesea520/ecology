<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.file.Prop"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	try{
		String wxsysurl = Util.null2String(Prop.getPropValue("wxinterface","meetingsysurl"));//从配置文件读取会务系统地址
		String gotourl = Util.null2String(request.getParameter("gotourl"));//点击后需要跳转的页面
		String outsysid = Util.null2String(Prop.getPropValue("wxinterface","meetingoutsysid"));//获取配置文件中的外部系统ID
		String token = UUID.randomUUID().toString().replaceAll("-","");//生成一个随机的token
		String userid = user.getUID()+"";
		String sql = "select 1 from wx_token where userid='"+userid+"'";
		rs.execute(sql);
		if(rs.next()){
			sql = "update wx_token set token = '"+token+"',createdate='"+TimeUtil.getCurrentTimeString()+"',loginid='"+user.getLoginid()+"',userdbid="+user.getUID()+" where userid='"+userid+"'";
		}else{
			sql = "insert into wx_token (userid,userdbid,loginid,token,createdate) values ('"+userid+"',"+user.getUID()+",'"+user.getLoginid()+"','"+token+"','"+TimeUtil.getCurrentTimeString()+"')";
		}
		rs.executeSql(sql);
		String tourl = wxsysurl+"/eb/login/ecLoginMeeting?outsysid="+outsysid+"&token="+token+"&userid="+userid+"&gotourl="+gotourl;
%>
<script>
	window.location.href="<%=tourl%>";
</script>
<%		
	}catch(Exception e){
		e.printStackTrace();
	}
%>