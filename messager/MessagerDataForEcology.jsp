<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.system.License"%>
<%@ page import="weaver.hrm.settings.RemindSettings" %>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<%@ page import="weaver.email.*"%>
<%@ page import="java.net.URLDecoder"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="MessagerDataForEcology" class="weaver.messager.MessagerDataForEcology" scope="page" />
<jsp:useBean id="SMSSaveAndSend" class="weaver.sms.SMSSaveAndSend" scope="page" />
<jsp:useBean id="PluginUserCheck" class="weaver.license.PluginUserCheck" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.*" %>
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

response.setContentType("application/x-json;charset=UTF-8");

request.setCharacterEncoding("utf-8");
//User user = HrmUserVarify.getUser (request , response) ;
//if(user == null)  return ;
Log logger= LogFactory.getLog(this.getClass());

String method=Util.null2String(request.getParameter("method"));
if("getOrganization".equals(method)){
	String organType=Util.null2String(request.getParameter("organType"));
	String value=Util.null2String(request.getParameter("value"));

	StringBuffer dataBuffer=new StringBuffer();
	dataBuffer.append("[");
	try {	
	 if("company".equals(organType)){	
		 dataBuffer.append(MessagerDataForEcology.getDeptBySubcompanyId(value));
		 dataBuffer.append(MessagerDataForEcology.getSubcompanyBySubcompanyId(value));
	 } else  if("dept".equals(organType)){
		 dataBuffer.append(MessagerDataForEcology.getDeptByDeptId(value));
		 dataBuffer.append(MessagerDataForEcology.getHrmByDeptId(value));
	 }
	} catch (Exception e) {				
		e.printStackTrace();
	}
	dataBuffer.append("]");	
	
	
	String dataStr=dataBuffer.toString();
	out.println(dataStr);	 
} else if("getDeptUser".equals(method)||"getRecentlyUser".equals(method)||"search".equals(method)){
	String loginid=Util.null2String(request.getParameter("loginid"));
	String returnStr="";	
	String strSql="";
	if("getDeptUser".equals(method)){
		strSql="select id,loginid,lastname,sex,departmentid,telephone,mobile,mobilecall,email,messagerurl from hrmresource  where departmentid=(select departmentid from hrmresource  where loginid='"+loginid+"') and loginid !='' and loginid!='"+loginid+"' order by lastname";
	} else if ("getRecentlyUser".equals(method)){	
		  if (rs.getDBType().equals("oracle")) {
			  strSql="select * from (select  h1.id,h1.loginid,lastname,sex,departmentid,telephone,mobile,mobilecall,email,messagerurl,h2.lastContactTime from hrmresource h1 left join  HrmMessagerContact h2 on  h1.loginid=h2.contactLoginid where  h2.loginid='"+loginid+"' and h2.contactLoginid!='"+loginid+"'  order by lastContactTime desc) where rownum<=20";	
           }else{
        	   strSql="select top 20 h1.id,h1.loginid,lastname,sex,departmentid,telephone,mobile,mobilecall,email,messagerurl,h2.lastContactTime from hrmresource h1 left join  HrmMessagerContact h2 on  h1.loginid=h2.contactLoginid where  h2.loginid='"+loginid+"' and h2.contactLoginid!='"+loginid+"'  order by lastContactTime desc";	
          } 
	} else if ("search".equals(method)){
		String key=Util.null2String(request.getParameter("key"));
		key=URLDecoder.decode(java.net.URLDecoder.decode(key,"utf-8"),"utf-8");
		strSql="select id,loginid,lastname,sex,departmentid,telephone,mobile,mobilecall,email,messagerurl from hrmresource  where  (lastname like '%"+key+"%' or loginid='"+key+"') and loginid !='' and loginid!='"+loginid+"'  order by lastname";		
	}
	rs.executeSql(strSql);

	List allowUserIds = PluginUserCheck.getPluginAllUserId("messager");
	
	while(rs.next()){
		String userid = Util.null2String(rs.getString("id"));
		if(allowUserIds.indexOf(userid)==-1) continue;
		
		returnStr+="{";
		returnStr+="userid:'"+Util.null2String(rs.getString("id"))+"',";
		returnStr+="loginid:'"+Util.null2String(rs.getString("loginid"))+"',";
		returnStr+="lastname:'"+Util.null2String(rs.getString("lastname"))+"',";
		returnStr+="sex:'"+Util.null2String(rs.getString("sex"))+"',";
		returnStr+="departmentid:'"+Util.null2String(rs.getString("departmentid"))+"',";
		returnStr+="departmentname:'"+DepartmentComInfo.getDepartmentname(rs.getString("departmentid"))+"',";
		returnStr+="telephone:'"+Util.null2String(rs.getString("telephone"))+"',";
		returnStr+="mobile:'"+Util.null2String(rs.getString("mobile"))+"',";
		returnStr+="mobilecall:'"+Util.null2String(rs.getString("mobilecall"))+"',";
		returnStr+="email:'"+Util.null2String(rs.getString("email"))+"',";
		returnStr+="messagerurl:'"+Util.null2String(rs.getString("messagerurl"))+"'";		
		returnStr+="},";
	}	
	if(!returnStr.equals("")) returnStr=returnStr.substring(0,returnStr.length()-1);

	out.println("{items:["+returnStr+"]}");	
} else if("addRecentlyContact".equals(method)){
	String loginid=Util.null2String(request.getParameter("loginid"));
	String contactLoginid=Util.null2String(request.getParameter("contactLoginid"));
	String lastContactTime=TimeUtil.getCurrentTimeString();
	
	boolean isHavaRecord=false;
	String strSql="select count(id) from  HrmMessagerContact where loginid='"+loginid+"' and contactLoginid='"+contactLoginid+"'";
	rs.executeSql(strSql);
	if(rs.next()){
		isHavaRecord=rs.getInt(1)>0;
	} 
	
	if(isHavaRecord){
		strSql="update HrmMessagerContact set lastContactTime='"+lastContactTime+"' where loginid='"+loginid+"' and contactLoginid='"+contactLoginid+"'";
	}	else {
		strSql="insert into HrmMessagerContact(loginid,contactLoginid,lastContactTime) values ('"+loginid+"','"+contactLoginid+"','"+lastContactTime+"')";
	}
	rs.executeSql(strSql);
	strSql="select id,loginid,lastname,sex,departmentid,telephone,mobile,mobilecall,email,messagerurl from hrmresource  where  loginid='"+contactLoginid+"'";
	rs.executeSql(strSql);
	String returnStr="";
	if(rs.next()){
		returnStr+="{";
		returnStr+="userid:'"+Util.null2String(rs.getString("id"))+"',";
		returnStr+="loginid:'"+Util.null2String(rs.getString("loginid"))+"',";
		returnStr+="lastname:'"+Util.null2String(rs.getString("lastname"))+"',";
		returnStr+="sex:'"+Util.null2String(rs.getString("sex"))+"',";
		returnStr+="departmentid:'"+Util.null2String(rs.getString("departmentid"))+"',";
		returnStr+="departmentname:'"+DepartmentComInfo.getDepartmentname(rs.getString("departmentid"))+"',";
		returnStr+="telephone:'"+Util.null2String(rs.getString("telephone"))+"',";
		returnStr+="mobile:'"+Util.null2String(rs.getString("mobile"))+"',";
		returnStr+="mobilecall:'"+Util.null2String(rs.getString("mobilecall"))+"',";
		returnStr+="email:'"+Util.null2String(rs.getString("email"))+"',";
		returnStr+="messagerurl:'"+Util.null2String(rs.getString("messagerurl"))+"'";		
		returnStr+="},";
	}	
	if(!returnStr.equals("")) returnStr=returnStr.substring(0,returnStr.length()-1);

	out.println("{items:["+returnStr+"]}");
}  else if("getUserIcon".equals(method)){
	String loginid=Util.null2String(request.getParameter("loginid"));
	String strSql="select messagerurl from  hrmresource where loginid='"+loginid+"'";
	rs.executeSql(strSql);
	if(rs.next()){
		out.println(rs.getString("messagerurl"));
	}	
}else if("saveMsg".equals(method)){
	String jidCurrent=Util.null2String(request.getParameter("jidCurrent"));
	String sendTo=Util.null2String(request.getParameter("sendTo"));
	
	
	String msg=Util.null2String(request.getParameter("msg"));
	msg=URLDecoder.decode(java.net.URLDecoder.decode(msg,"utf-8"),"utf-8");
	msg=Util.replace(msg,"'","''",0);
	String strTime=TimeUtil.getCurrentTimeString();
	
	if(jidCurrent.indexOf("@")!=-1){
		jidCurrent=jidCurrent.substring(0,jidCurrent.indexOf("@"));
	}	
	if(sendTo.indexOf("@")!=-1){
		sendTo=sendTo.substring(0,sendTo.indexOf("@"));
	}
	
	
	String strSql="select  id,loginid from hrmresource where loginid ='"+jidCurrent+"' or loginid='"+sendTo+"' ";
	rs.executeSql(strSql);
	while(rs.next()){
		if(Util.null2String(rs.getString("loginid")).equals(jidCurrent)) jidCurrent=rs.getString("id");
		else if (Util.null2String(rs.getString("loginid")).equals(sendTo)) sendTo=rs.getString("id");
	}
	
	strSql="insert into HrmMessagerMsg(jidCurrent,sendTo,msg,strTime) values('"+jidCurrent+"','"+sendTo+"','"+msg+"','"+strTime+"')";
	rs.executeSql(strSql);
} else if("getLoginid".equals(method)){
	String userid=Util.null2String(request.getParameter("userid"));
	String strSql="select  loginid from hrmresource where id ="+userid;
	rs.executeSql(strSql);
	while(rs.next()){
		String loginid=Util.null2String(rs.getString("loginid"));
		out.println(loginid);
	}
}else if("setMsgStyle".equals(method)){
	String loginid=Util.null2String(request.getParameter("loginid"));
	String msgStyle=Util.null2String(request.getParameter("msgStyle"));
	
	String strSql="update hrmresource set msgstyle='"+msgStyle+"' where loginid='"+loginid+"'";
	
	rs.executeSql(strSql);
} else if("getAllTempMsg".equals(method)){
	String loginid=Util.null2String(request.getParameter("loginid"));
	String strSql="	select * from HrmMessagerTempMsg where loginid='"+loginid+"' ";
	
	rs.executeSql(strSql);
	String returnStr="";
	while(rs.next()){
		String body=Util.replace(Util.null2String(rs.getString("body")),"'","\\\\'",0);
		returnStr+="{";
		returnStr+="loginid:'"+Util.null2String(rs.getString("loginid"))+"',";
		returnStr+="fromJid:'"+Util.null2String(rs.getString("fromJid"))+"',";
		returnStr+="body:'"+body+"',";
		returnStr+="receiveTime:'"+Util.null2String(rs.getString("receiveTime"))+"'";
		returnStr+="},";
	}	
	if(!returnStr.equals("")) returnStr=returnStr.substring(0,returnStr.length()-1);
	//1. 
	out.println("{items:["+returnStr+"]}");
	
	//2. 
	strSql="delete from HrmMessagerTempMsg where loginid='"+loginid+"' ";
	rs.executeSql(strSql);
	
}else if("getSomBodyTempMsg".equals(method)){
	String loginid=Util.null2String(request.getParameter("loginid"));
	String fromJid=Util.null2String(request.getParameter("fromJid"));
	String strSql="	select * from HrmMessagerTempMsg where loginid='"+loginid+"' and fromJid='"+fromJid+"'";
	
	rs.executeSql(strSql);
	String returnStr="";
	while(rs.next()){
		returnStr+="{";
		returnStr+="loginid:'"+Util.null2String(rs.getString("loginid"))+"',";
		returnStr+="fromJid:'"+Util.null2String(rs.getString("fromJid"))+"',";
		returnStr+="body:'"+Util.null2String(rs.getString("body"))+"',";
		returnStr+="receiveTime:'"+Util.null2String(rs.getString("receiveTime"))+"'";
		returnStr+="},";
	}	
	if(!returnStr.equals("")) returnStr=returnStr.substring(0,returnStr.length()-1);
	//1. 
	out.println("{items:["+returnStr+"]}");
	
	//2. 
	strSql="delete from HrmMessagerTempMsg where loginid='"+loginid+"'  and fromJid='"+fromJid+"'";
	rs.executeSql(strSql);
	
}else if("getTempMsgCount".equals(method)){
	String loginid=Util.null2String(request.getParameter("loginid"));
	String strSql="	select count(*) from HrmMessagerTempMsg where loginid='"+loginid+"' ";
	
	rs.executeSql(strSql);
	String returnStr="0";
	if(rs.next()){
		returnStr=Util.null2String(rs.getString(1));		
	}	
	out.println(returnStr);
}else if("sendMail".equals(method)){
	String mailAccountId = Util.null2String(request.getParameter("mailAccountId"));
	String receiver = Util.null2String(request.getParameter("receiver"));
	String mailSubject = Util.null2String(request.getParameter("mailSubject"));
	String mouldtext = Util.null2String(request.getParameter("mouldtext"));
	String priority = Util.null2String(request.getParameter("priority"));
	
	String sendfrom = "";
	String accountPwd = "";
	String accountId = "";
	String accountSMTPServer = "";
	boolean needAuthentication = false;
	String encryption = "";
	String needSSL = "";
	String smtpServerPort = "";
	
    String CC="" ;
    String BCC="" ;
    String TO="" ;
    String subject="" ;
    String content = "" ;

    String sendstatus = "false";
    
    if(!"".equals(mailAccountId)&&!"".equals(receiver)) {
    
	    SendMail sm = new SendMail();
		rs.executeSql("SELECT * FROM MailAccount WHERE id="+mailAccountId+"");
		if(rs.next()){
			sendfrom = rs.getString("accountMailAddress");
			accountPwd = rs.getString("accountPassword");
			accountId = rs.getString("accountId");
			accountSMTPServer = rs.getString("smtpServer");
			needAuthentication = Util.null2String(rs.getString("needCheck")).equals("1") ? true : false;
			encryption = Util.null2String(rs.getString("encryption"));
			needSSL = rs.getString("sendneedSSL");
			smtpServerPort = rs.getString("smtpServerPort");
	
			if(encryption.equals("1")) accountPwd = EmailEncoder.DecoderPassword(accountPwd);
			
	        sendfrom = Util.fromBaseEncoding2(sendfrom,user.getLanguage()) ;
	        CC = Util.fromBaseEncoding2(CC,user.getLanguage()) ;
	        BCC = Util.fromBaseEncoding2(BCC,user.getLanguage()) ;
	        TO = Util.fromBaseEncoding2(receiver,user.getLanguage()) ;
	        subject = Util.fromBaseEncoding2(mailSubject,user.getLanguage()) ;
	        content = Util.fromBaseEncoding2(mouldtext,user.getLanguage()) ;
			
			sm.setUsername(accountId);
	        sm.setPassword(accountPwd);
			sm.setMailServer(accountSMTPServer);
			sm.setNeedauthsend(needAuthentication);
			sm.setNeedSSL(needSSL);
			sm.setSmtpServerPort(smtpServerPort);
	
			sendstatus = String.valueOf(sm.send(sendfrom, TO, CC, BCC, subject, content,priority));
		}
    } else {
    	sendstatus = "false";
    }
    
	out.println(sendstatus);
}else if("sendSMS".equals(method)){
	String message = request.getParameter("message");
    String recievenumber = Util.null2String(request.getParameter("recievenumber"));
	String recievehrmid = Util.null2String(request.getParameter("recievehrmid"));
	
    String sendnumber = Util.null2String(request.getParameter("sendnumber"));
	
    int userid = user.getUID();
    String usertype = user.getLogintype();
    int requestid = 0;
    
    String sendstatus = "false";
    
    SMSSaveAndSend.reset();
    SMSSaveAndSend.setMessage(message + "-" + user.getUsername() + "(" + user.getUID() + ")");
    SMSSaveAndSend.setRechrmnumber(recievenumber);
    SMSSaveAndSend.setRechrmids(recievehrmid);
    SMSSaveAndSend.setReccrmids("");
	SMSSaveAndSend.setReccrmnumber("");
	SMSSaveAndSend.setCustomernumber("");
    SMSSaveAndSend.setSendnumber(sendnumber);
    SMSSaveAndSend.setRequestid(requestid);
    SMSSaveAndSend.setUserid(userid);
    SMSSaveAndSend.setUsertype(usertype);
    
    sendstatus = String.valueOf(SMSSaveAndSend.send());

    out.println(sendstatus);
}
%>

