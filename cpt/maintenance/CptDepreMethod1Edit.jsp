<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepreRatioCal" class="weaver.cpt.maintenance.DepreRatioCal" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("CptDepreMethodEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}

int id = Util.getIntValue(request.getParameter("id"),0);
 rs.executeProc("CptDepreMethod1_SelectByID",""+id);
 
	String name = "";
	String description = "";
	String timelimit = "";
	String startunit = "";
	String endunit = "";
	String deprefunc = "";
 if(rs.next()){
	name = Util.toScreenToEdit(rs.getString("name"),user.getLanguage());
	description = Util.toScreenToEdit(rs.getString("description"),user.getLanguage());
	timelimit = Util.toScreenToEdit(rs.getString("timelimit"),user.getLanguage());
	startunit = Util.toScreenToEdit(rs.getString("startunit"),user.getLanguage());
	endunit = Util.toScreenToEdit(rs.getString("endunit"),user.getLanguage());
	deprefunc = Util.toScreenToEdit(rs.getString("deprefunc"),user.getLanguage());
	}
/*for test*/
/*
DepreRatioCal.setDepre(""+id);
float f = DepreRatioCal.getDepreRatio((float)0.1);
out.print("aaa:"+f);
DepreRatioCal.clearDepre();
*/

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(835,user.getLanguage())+":"+name;
String needfav ="1";
String needhelp ="";
boolean canEdit = false;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%
int wrongfunc = Util.getIntValue(request.getParameter("wrongfunc"),0);
if(wrongfunc==-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(30,user.getLanguage())%>
</font>
</DIV>
<%
deprefunc = "";
}%>
<FORM id=weaver name=frmMain action="DepreMethod1Operation.jsp" method=post>
<DIV class=HdrProps></DIV>
<%
if(HrmUserVarify.checkUserRight("CptDepreMethod1Edit:Edit", user)){
	canEdit = true;
%>
<BUTTON class=btnSave accessKey=S onclick="onSave()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
<%
}
if(HrmUserVarify.checkUserRight("CptDepreMethod1Add:Add", user)){
%>
<BUTTON language=VBS class=BtnNew id=button1 accessKey=N name=button1 onclick="location='CptDepreMethod1Add.jsp'"><U>N</U>-<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></BUTTON>
<%
}
if(HrmUserVarify.checkUserRight("CptDepreMethod1Edit:Delete", user)){
%>
<BUTTON class=btnDelete id=Delete accessKey=D onclick="onDelete()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
<%
}
%>
<table>
    <COLGROUP> <COL width="60%"> <COL width="40%"> <TBODY> 
    <tr><td align=center valign = up>
 <TABLE class=form>
    <COLGROUP> <COL width="20%"> <COL width="80%"> <TBODY> 
    <TR class=Section> 
      <TH colSpan=2><%=SystemEnv.getHtmlLabelName(835,user.getLanguage())%></TH>
    </TR>
    <TR class=separator> 
      <TD class=Sep1 colSpan=2 ></TD>
    </TR>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
      <TD class=Field> 
        <INPUT type=text size=40  maxlength=60 name="name" value="<%=name%>" onchange='checkinput("name","nameimage")'>
        <SPAN id=nameimage></TD>
    </TR>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
      <TD class=Field> 
        <INPUT type=text size=40  maxlength=200  name="description" value="<%=description%>" onchange='checkinput("description","descriptionimage")'>
        <SPAN id=descriptionimage></SPAN></TD>
    </TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(1430,user.getLanguage())%></td>
      <td class=Field> 
        <input type=text size=10  maxlength=18 value="<%=timelimit%>" name="timelimit" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("timelimit");checkinput("timelimit","timelimitimage")'>
        <span id=timelimitimage></td>
    </tr>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(1431,user.getLanguage())%></td>
      <td class=Field> 
        <input type=text size=10  maxlength=5 id=startunit value="<%=startunit%>" name=startunit onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("startunit");checkinput("startunit","startunitimage")'>
        <span id=startunitimage></span></td>
    </tr>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(1432,user.getLanguage())%></td>
      <td class=Field> 
        <input type=text size=10  maxlength=5 id=endunit value="<%=endunit%>" name=endunit onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("endunit");checkinput("endunit","endunitimage")'>
        <span id=endunitimage></td>
    </tr>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(1433,user.getLanguage())%></td>
      <td class=Field> 
        <input type=text size=40 maxlength=200 name="deprefunc" value="<%=deprefunc%>" onChange='checkinput("deprefunc","deprefuncimage")'>
        <span id=deprefuncimage></td>
    </tr>
    <input type="hidden" name=operation>
	 <input type=hidden name=id value="<%=id%>">
    </TBODY> 
  </TABLE>
  </td><td>
  <center>
 <img src = "/weaver/weaver.cpt.maintenance.ShowDepreMethod?depreid=<%=id%>" border=0>
</center>
</td>
</tr>
</table>
 </form> 
 
 <script language=javascript>
 function onSave(){
	 if(check_form(this,'name,description,timelimit,startunit,endunit,deprefunc'))
	{	
		
		if(((document.all("startunit").value)>0)&&((document.all("startunit").value)<=1)&&((document.all("endunit").value)>=0)&&((document.all("endunit").value)<1)&&((document.all("startunit").value)>=(document.all("endunit").value))){
			document.frmMain.operation.value="edit";
			document.frmMain.submit();
		}
		else{
		 alert("数字校验错");
		}
	}
 }
 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmMain.operation.value="delete";
			document.frmMain.submit();
		}
}
 </script>
</BODY></HTML>
