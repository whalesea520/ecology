
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.util.*,java.net.URLDecoder,weaver.login.TokenJSCX,weaver.hrm.*,weaver.file.Prop,weaver.general.*,weaver.messager.MessagerService,java.text.SimpleDateFormat"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
	String loginid = request.getParameter("loginid");
	String tokenKeyCode = request.getParameter("tokenKeyCode");
	if(tokenKeyCode!=null)//老认证方式
		String useridsql = "select tokenkey from HrmResource where loginid='" + loginid + "'";
		String tokenkey = "";
		rs.executeSql(useridsql);
		if(rs.next()){
			tokenkey = rs.getString("tokenkey");
		}
		if(tokenkey!=null&&tokenKeyCode!=null){
			TokenJSCX tj = new TokenJSCX();
			boolean token = tj.checkDLKey(tokenkey,tokenKeyCode);
			out.print(token);
		}else{
			out.print("false");
		}
		return;
	}else{
		String password = request.getParameter("password");
		String newtokenKeyCode = request.getParameter("newtokenKeyCode");
		int loginType = 3;
		String mode = Prop.getPropValue(GCONST.getConfigFile(), "authentic");
		if(mode != null && mode.equals("ldap"))
		 	loginType=2;
		if(loginid!=null&&password!=null){
			MessagerService ms =  new MessagerService();
			int result = ms.checkUserLogin(loginid,password,loginType);
			//System.out.println("@@@@@@@@@@@@@"+result);
			if(result==1){
				String usertokensql = "select tokenkey from HrmResource where loginid='" + loginid + "'";
				String tokenkey = "";
				rs.executeSql(usertokensql);
				if(rs.next()){
					tokenkey = rs.getString("tokenkey");
				}
				if(tokenkey!=null&&newtokenKeyCode!=null){
					TokenJSCX tj = new TokenJSCX();
					boolean token = tj.checkDLKey(tokenkey,newtokenKeyCode);
					if(token){
						String useridsql = "select id from HrmResource where loginid='" + loginid + "' union select id from HrmResourcemanager where loginid='" + loginid + "'";
						int userid = 0;
						rs.executeSql(useridsql);
						if(rs.next()){
							userid = rs.getInt("id");
						}
						if(userid!=0){
							UserManager um = new UserManager();
							User user = um.getUserByUserIdAndLoginType(userid,"1");
							user.setPwd(password);
							session.setAttribute("weaver_user@bean", user);
							String ip = request.getRemoteAddr();
							SimpleDateFormat sdf =  new SimpleDateFormat("yyyy-MM-dd");
							String date = sdf.format(new Date());
							SimpleDateFormat sdf1 =  new SimpleDateFormat("HH:mm:ss");
							String date1 = sdf1.format(new Date());
							String updatesql = "update HrmResource set lastlogindate = '"+date+"' where loginid = '"+loginid+"'";
							String insertsql = "insert into SysMaintenanceLog(relatedid,relatedname,operatetype,operatedesc,operateitem,operateuserid,operatedate,operatetime,clientaddress,istemplate) values("+user.getUID()+",'"+user.getLastname()+"',6,'',60,"+user.getUID()+",'"+date+"','"+date1+"','"+ip+"',0)";
							rs.executeSql(updatesql);
							rs.executeSql(insertsql);
							out.print(":"+session.getId());
							return;
						}
					}
					out.print(token);
					
				}else{
					out.print("false");
				}
			}else{
				out.print("false");
			}
			
		}else{
			out.print("false");
		}
	}
       
%>

	

