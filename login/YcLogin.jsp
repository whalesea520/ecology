<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="YcVerifyLogin" class="weaver.login.YcVerifyLogin" scope="page" />
<%
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

String loginfile = Util.null2String(request.getParameter("loginfile")) ;
String logintype = Util.null2String(request.getParameter("logintype")) ;
String loginid = Util.null2String(request.getParameter("loginid")) ;
String logincode = Util.null2String(request.getParameter("logincode")) ;  //验证码
String userpassword = Util.null2String(request.getParameter("userpassword"));
if(logintype.equals("")) logintype="1";
if(loginfile.equals("")) loginfile="/login/Login.jsp?logintype="+logintype;
String RedirectFile = "/main.jsp" ;
if (logintype.equals("2")) RedirectFile = "/portal/main.jsp" ;
String sql="";

if(!logincode.equals(Util.getEncrypt(loginid+CurrentDate))){
	response.sendRedirect(loginfile);
}

if(!loginid.equals("")){
	//sql="select * from ycuser where loginid='"+loginid+"' and logintype='"+logintype+"'";
	//RecordSet.executeSql(sql);
	sql = "select * from ycuser where loginid=? and logintype=?" ;
	RecordSet.executeQuery(sql,loginid,logintype);
	if(RecordSet.next()){ 
		loginid=RecordSet.getString(1);
		String usercheck = YcVerifyLogin.getUserCheck(request,response,loginid,userpassword,logintype,loginfile) ; 
		if(usercheck.equals("15") || usercheck.equals("16") || usercheck.equals("17"))  response.sendRedirect(loginfile + "&message="+usercheck) ;
		else if(usercheck.equals("19")){
			response.sendRedirect("/system/InLicense.jsp?message=0") ;
		}
		else {
			response.sendRedirect(RedirectFile+"?logmessage="+usercheck) ;
		}
	}else{
		response.sendRedirect(loginfile);
	}
}else{ 
	response.sendRedirect(loginfile);
}
%>

			


