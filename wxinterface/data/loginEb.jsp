<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.file.Prop"%>
<%@ page import="weaver.wxinterface.InterfaceUtil"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	try{
		String wxsysurl = request.getParameter("wxsysurl");
		if(wxsysurl==null||"".equals(wxsysurl)){
			wxsysurl = InterfaceUtil.getWxsysurl();//获取配置文件中的微信系统地址
		}
		String gotourl = Util.null2String(request.getParameter("gotourl"));
		String outsysid = InterfaceUtil.getOutsysid();//获取配置文件中的外部系统ID
		String userkeytype = InterfaceUtil.getUserkeytype();//获取配置文件中的微信系统地址
		String token = UUID.randomUUID().toString().replaceAll("-","");//生成一个随机的token
		String userid = user.getUID()+"";
		if(!userkeytype.equals("ID")){
			String mode=Prop.getPropValue(GCONST.getConfigFile() , "authentic");
	    	if(mode!=null&&mode.equals("ldap")){
	    		userid = user.getAccount();
	    	}else{
	    		userid = user.getLoginid();
	    	}
		}
		String sql = "select 1 from wx_token where userid='"+userid+"'";
		rs.execute(sql);
		if(rs.next()){
			sql = "update wx_token set token = '"+token+"',createdate='"+TimeUtil.getCurrentTimeString()+"',loginid='"+user.getLoginid()+"',userdbid="+user.getUID()+" where userid='"+userid+"'";
		}else{
			sql = "insert into wx_token (userid,userdbid,loginid,token,createdate) values ('"+userid+"',"+user.getUID()+",'"+user.getLoginid()+"','"+token+"','"+TimeUtil.getCurrentTimeString()+"')";
		}
		rs.executeSql(sql);
		String tourl = wxsysurl+"/login/ecLogin?outsysid="+outsysid+"&token="+token+"&userid="+userid+"&gotourl="+gotourl;
%>
<script>
	window.location.href="<%=tourl%>";
</script>
<%		
	}catch(Exception e){
		e.printStackTrace();
	}
%>