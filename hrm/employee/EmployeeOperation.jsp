<%@ page import="java.security.*,weaver.general.Util" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%

String signed = Util.null2String(request.getParameter("signed"));//判断是否是任务总监点击完成，结束任务
String hrmid = request.getParameter("hrmid");

if(signed.equals("1")){
    //如果是任务总监点击完成，那么先判断数据库中是否所有的项已经设置成功。若不是，那么说明是总监误点，应该返回并提示。
    //如果确实已经所有的项目都设置成功，则状态项设置为1。这样在新员工中就不会有该员工。
     RecordSet.executeProc("Employee_SetAll",hrmid); 
     RecordSet.next();
     String isfinish = RecordSet.getString(1);
     if(isfinish.equals("-1")){
        response.sendRedirect("/hrm/employee/EmployeeManage.jsp?isfinish=30&hrmid="+hrmid);
     }
     else{
         response.sendRedirect("/hrm/employee/EmployeeView.jsp?hrmid="+hrmid);
     }
}
else{
char flag = 2;
String ProcPara = "";
String method = request.getParameter("method");


String loginid = Util.fromScreen(request.getParameter("loginid"),user.getLanguage());
String password = Util.fromScreen(request.getParameter("password"),user.getLanguage());
if(!password.equals("novalue$1")){
password= Util.getEncrypt(Util.fromScreen(request.getParameter("password"),user.getLanguage()));
}

//设置个人帐户和密码

String email = Util.fromScreen(request.getParameter("email"),user.getLanguage());
String emailpassword = Util.fromScreen(request.getParameter("emailpassword"),user.getLanguage());
//设置邮件帐户和密码

String textfile1=Util.fromScreen(request.getParameter("textfile1"),user.getLanguage());
String textfile2=Util.fromScreen(request.getParameter("textfile2"),user.getLanguage());
String telephone=Util.fromScreen(request.getParameter("telephone"),user.getLanguage());
String businesscard=Util.fromScreen(request.getParameter("businesscard"),user.getLanguage());

if (method.equals("login"))
{
	ProcPara =  loginid;
	ProcPara += flag + password;
    ProcPara += flag + hrmid;

    RecordSet.executeProc("Employee_LoginUpdate",ProcPara);
    RecordSet.next();
    String idadd = RecordSet.getString(1);
    //response.sendRedirect("/hrm/employee/EmployeeManage.jsp?hrmid="+hrmid);
    //登陆名冲突
    if(idadd.equals("-1")){
     response.sendRedirect("/hrm/employee/EmployeeEdit.jsp?msgid=30&id=1&hrmid="+hrmid+"&loginid="+loginid);
    }
}
if (method.equals("email"))
{
	ProcPara =  email;
	ProcPara += flag +  emailpassword;
	ProcPara += flag + hrmid;
	RecordSet.executeProc("Employee_EmaiUpdate",ProcPara);   
}
if (method.equals("cardedit"))
{
	ProcPara =  textfile1;
	ProcPara += flag + hrmid;
	RecordSet.executeProc("Employee_CardUpdate",ProcPara); 
}
if (method.equals("seatnum"))
{
	ProcPara =  textfile2;
	ProcPara += flag + hrmid;
	RecordSet.executeProc("Employee_SeatUpdate",ProcPara); 
}
if (method.equals("telephoneset"))
{
	ProcPara =  telephone;
	ProcPara += flag + hrmid;
	RecordSet.executeProc("Employee_TeleUpdate",ProcPara); 
}
if (method.equals("businesscardset"))
{
	ProcPara =  businesscard;
	ProcPara += flag + hrmid;
	RecordSet.executeProc("Employee_BusiCardUpdate",ProcPara); 

}
if (method.equals("cpt"))
{
    String id = request.getParameter("id");
	ProcPara =  id;
    ProcPara += flag + hrmid;
	RecordSet.executeProc("Employee_CptUpdate",ProcPara); 
}

response.sendRedirect("/hrm/employee/EmployeeManage.jsp?hrmid="+hrmid);

}//else 即：if(!(signed.equals("1")))
%>