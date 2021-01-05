
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>


<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

<%
String id=request.getParameter("id");
String hrmid=request.getParameter("hrmid");
String Sql=("select lastname from HrmResource where id="+hrmid);
RecordSet.executeSql(Sql);
RecordSet.next();
String name = RecordSet.getString("lastname");
String loginid="";
String password="";

int msgid = Util.getIntValue(request.getParameter("msgid"),-1);

int sign = Util.getIntValue(request.getParameter("sign"),-1);
boolean change=false;
if(sign!=-1){
    String thesql="select loginid,password from HrmResource where id="+hrmid;
    RecordSet.executeSql(thesql);
    RecordSet.next();
    loginid=Util.null2String(RecordSet.getString("loginid"));
    password=Util.null2String(RecordSet.getString("password"));
    if(password.equals("")){
        change=false;
    }else change=true;
}
else{
loginid=Util.null2String(request.getParameter("loginid"));
}

String emailpassword="";
String email="";
String textfile1="";
String textfile2="";
String telephone="";
String businesscard="";
boolean change_email=false;

String sql_email="select password from MailPassword where resourceid="+hrmid;
RecordSet.executeSql(sql_email);
RecordSet.next();
emailpassword=Util.null2String(RecordSet.getString("password"));
if(emailpassword.equals("")){
    change_email=false;
}else{
    change_email=true;
}


RecordSet.executeProc("Employee_SelectByID",hrmid);
if(RecordSet.next()){
    email=Util.null2String(RecordSet.getString("email"));
    textfile1=Util.null2String(RecordSet.getString("textfield1"));
    textfile2=Util.null2String(RecordSet.getString("textfield2"));
    telephone=Util.null2String(RecordSet.getString("telephone"));
    businesscard=Util.null2String(RecordSet.getString("tinyintfield1"));   
}



%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(2225,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(id.equals("1")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}else{
if(id.equals("2")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave_1(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/employee/EmployeeManage.jsp?hrmid="+hrmid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<%
/*登录名冲突*/
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>

<FORM id=resource name=resource action="/hrm/employee/EmployeeOperation.jsp" method=post >
<TABLE class=viewform>
  <COLGROUP>
  <COL width="100%">
  <TBODY>
  <TR>
    <TD vAlign=top>
      <TABLE class=viewForm>
      <COLGROUP>
  	<COL width="20%">
  	<COL width="80%">
        <TBODY>
        <TR class=title>
            <TH><%=SystemEnv.getHtmlLabelName(15798,user.getLanguage())%></TH>
          </TR>
        <TR class=spacing>
          <TD class=line1 colSpan=2></TD></TR>
        <TR>
      <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
      <td class=field>
       <%=name%>
      <input class=inputstyle type=hidden name=hrmid value="<%=hrmid%>">
       </td>      
      </TR>
      <TR><TD class=Line colSpan=2></TD></TR> 
        <%if(id.equals("1")){%>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(571,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=30 name="loginid" value="<%=loginid%>" onchange='checkinput("loginid","loginidimage")'><SPAN id=loginidimage></SPAN></TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></td>
            <td class=Field> 
              <input class=InputStyle maxlength=20 
            onchange='checkinput("password","passwordimage")' size=15 
            name=password type="password"  <%if(change){%> value="novalue$1" <%}%>>
              <span id=passwordimage><img 
            src="/images/BacoError_wev8.gif" align=absMiddle></span></td>
          </tr>
         <TR><TD class=Line colSpan=2></TD></TR> 
           <tr> 
            <td><%=SystemEnv.getHtmlLabelName(501,user.getLanguage())%></td>
            <td class=Field> 
              <input class=InputStyle maxlength=20 
            onChange='checkinput("confirmpassword","confirmpasswordimage")' size=15 
            name=confirmpassword type="password"  <%if(change){%> value="novalue$1" <%}%>>
              <span id=confirmpasswordimage><img 
            src="/images/BacoError_wev8.gif" align=absMiddle></span></td>
          </tr>
        <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
          <input class=inputstyle type="hidden" name="method" value="login">
        <%}%>
        <%if(id.equals("2")){%>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(15799,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=30 name="email" value="<%=email%>" onchange='checkinput("email","emailimage")'><SPAN id=emailimage></SPAN></TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></td>
            <td class=Field> 
              <input class=InputStyle maxlength=20 
            onchange='checkinput("emailpassword","emailpasswordimage")' size=15 
            name=emailpassword type="password" <%if(change_email){%> value="novalue$1" <%}%>  >
              <span id=emailpasswordimage><img 
            src="/images/BacoError_wev8.gif" align=absMiddle></span></td>
          </tr>
         <TR><TD class=Line colSpan=2></TD></TR> 
          <input class=inputstyle type="hidden" name="method" value="email">
            <tr> 
            <td><%=SystemEnv.getHtmlLabelName(501,user.getLanguage())%></td>
            <td class=Field> 
              <input class=InputStyle maxlength=20 
            onChange='checkinput("emailconfirmpassword","emailconfirmpasswordimage")' size=15 
            name=emailconfirmpassword type="password"  <%if(change_email){%> value="novalue$1" <%}%> >
              <span id=emailconfirmpasswordimage><img 
            src="/images/BacoError_wev8.gif" align=absMiddle></span></td>
          </tr>
        <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
        <%}%>
        <%if(id.equals("3")){%>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(15800,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=30 name="textfile1" value="<%=textfile1%>" onchange='checkinput("textfile1","textfile1image")'><SPAN id=textfile1image></SPAN></TD>
           <input class=inputstyle type="hidden" name="method" value="cardedit">
        </TR>
       <TR><TD class=Line colSpan=2></TD></TR> 
        <%}%>      
        <%if(id.equals("4")){%>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(15801,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=30 name="textfile2" value="<%=textfile2%>" onchange='checkinput("textfile2","textfile2image")'><SPAN id=textfile2image></SPAN></TD>
            <input class=inputstyle type="hidden" name="method" value="seatnum">
        </TR>
      <TR><TD class=Line colSpan=2></TD></TR> 
        <%}%>     
        <%if(id.equals("7")){%>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(15802,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=30 name="telephone" value="<%=telephone%>" onchange='checkinput("telephone","telephoneimage")'><SPAN id=telephoneimage></SPAN></TD>
               <input class=inputstyle type="hidden" name="method" value="telephoneset">
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        <%}%> 
        <%if(id.equals("9")){%>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(1023,user.getLanguage())%></TD>
           <TD class=Field>
		  	<select class=InputStyle id=businesscard 
              name=businesscard>
                <option value=1 <%if(businesscard.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
                <option value=0 <%if(businesscard.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
		    </select>
                <input class=inputstyle type="hidden" name="method" value="businesscardset">
		  </TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        <%}%> 

        </TBODY>
        </TABLE>
        </TD>
    </TR>
    </TBODY>
    </TABLE>
</FORM>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>
<script language=javascript>  
function submitData() {
 frmMain.submit();
}

function doSave() {
	if(check_form(document.resource,'loginid,password,email,textfile1,textfile2,telephone,businesscard')) {   
		    if(document.resource.password.value != document.resource.confirmpassword.value)  {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15803,user.getLanguage())%>!") ;
			return ;
		    }
      
		document.resource.submit() ;
	}
}

function doSave_1() {
	if(check_form(document.resource,'loginid,password,email,emailpassword,textfile1,textfile2,telephone,businesscard')) {   
		    if(document.resource.emailpassword.value != document.resource.emailconfirmpassword.value)  {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15803,user.getLanguage())%>!") ;
			return ;
		    }
      
		document.resource.submit() ;
	}
}
</script>
</BODY>
</HTML>