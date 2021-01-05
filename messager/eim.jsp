
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.login.TokenJSCX"%>
<%@page import="weaver.messager.MsgUtil"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%@ page import="weaver.general.*,weaver.login.TokenJSCX" %>
<%@ page import="weaver.messager.MessagerService"%>
<%@ page import="weaver.file.Prop,weaver.hrm.*,java.text.SimpleDateFormat,java.util.Date" %>
<%@ page import="java.util.*" %>
<%
String loginid = request.getParameter("loginid");
String password = request.getParameter("password");
int TokenStatus = 0 ;
int loginType = 3;
String mode = Prop.getPropValue(GCONST.getConfigFile(), "authentic");
if(mode != null && mode.equals("ldap"))
 	loginType=2;
if(loginid!=null&&password!=null){
	MessagerService ms =  new MessagerService();
	int result = ms.checkUserLogin(loginid,password,loginType);
	if(result==1){
		String strCur= password;
		String psw=strCur;
		String psw2=Util.getEncrypt(psw).toLowerCase();
		String lowerloginid = loginid.toLowerCase();
		String strSql="select count(0) from HrmMessagerAccount where userid='"+lowerloginid+"'";
		rs.executeSql(strSql);
		if(rs.next()){
			if(rs.getInt(1)>0){
				strSql="update HrmMessagerAccount set psw='"+psw2+"' where userid='"+lowerloginid+"'";
			} else {
				strSql="insert into HrmMessagerAccount(userid,psw) values('"+lowerloginid+"','"+psw2+"')";
			}
		}
		rs.executeSql(strSql);
		out.print(psw);
		TokenJSCX tj = new TokenJSCX();
		TokenStatus = tj.checkTokenkeyStatus(loginid);
		SimpleDateFormat sdf =  new SimpleDateFormat("yyyy-MM-dd");
		String date = sdf.format(new Date());
		SimpleDateFormat sdf1 =  new SimpleDateFormat("HH:mm:ss");
		String date1 = sdf1.format(new Date());
		String updatesql = "update HrmResource set lastlogindate = '"+date+"' where loginid = '"+loginid+"'";
		String useridsql = "select id from HrmResource where loginid='" + loginid + "' union select id from HrmResourcemanager where loginid='" + loginid + "'";
		int userid = 0;
		rs.executeSql(useridsql);
		if(rs.next()){
			userid = rs.getInt("id");
		}
		if(userid!=0&&TokenStatus==0){
			UserManager um = new UserManager();
			User user = um.getUserByUserIdAndLoginType(userid,"1");
			user.setPwd(password);
			session.setAttribute("weaver_user@bean", user);
			Map logmessages=(Map)application.getAttribute("logmessages");
            if(logmessages==null){
              logmessages=new HashMap();
              logmessages.put(""+user.getUID(),"");
              application.setAttribute("logmessages",logmessages);
             }

			//String ip = request.getRemoteAddr();
			String ip = weaver.messager.MsgUtil.getIpAddr(request);
			String insertsql = "insert into SysMaintenanceLog(relatedid,relatedname,operatetype,operatedesc,operateitem,operateuserid,operatedate,operatetime,clientaddress,istemplate) values("+user.getUID()+",'"+user.getLastname()+"',6,'',60,"+user.getUID()+",'"+date+"','"+date1+"','"+ip+"',0)";
			rs.executeSql(updatesql);
			rs.executeSql(insertsql);
		}
	}else{
		out.print("false");
	}
}else{
	out.print("false");
}

String strSql="select propValue from ofproperty where name='xmpp.domain'";
rs.executeSql(strSql);
if(rs.next()){
	out.print(":"+ rs.getString(1));
	out.print(":"+ TokenStatus);
	out.print(":"+ session.getId());
}
%>
	
	

