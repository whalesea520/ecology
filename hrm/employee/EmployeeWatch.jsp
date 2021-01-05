
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
int sign = Util.getIntValue(request.getParameter("sign"),-1);
if(sign!=-1){
    String thesql="select loginid from HrmResource where id="+hrmid;
    RecordSet.executeSql(thesql);
    RecordSet.next();
    loginid=Util.null2String(RecordSet.getString("loginid"));
}
else{
loginid=Util.null2String(request.getParameter("loginid"));
}
String password="";
String emailpassword="";
String email="";
String textfile1="";

String textfile2="";
String telephone="";
String tinyintfield1="";
String businesscard="";

RecordSet.executeProc("Employee_SelectByID",hrmid);
if(RecordSet.next()){
    email=Util.null2String(RecordSet.getString("email"));
    textfile1=Util.null2String(RecordSet.getString("textfield1"));
    textfile2=Util.null2String(RecordSet.getString("textfield2"));
    telephone=Util.null2String(RecordSet.getString("telephone"));
    tinyintfield1=Util.null2String(RecordSet.getString("tinyintfield1"));
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
<FORM id=weaver action="/hrm/employee/EmployeeOperation.jsp" method=post >
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
      <input type=hidden name=hrmid value="<%=hrmid%>">
       </td>      
      </TR>
      <TR><TD class=Line colSpan=2></TD></TR> 
        <%if(id.equals("1")){%>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(571,user.getLanguage())%></TD>
          <TD class=Field><%=loginid%></TD>
        </TR>     
        <TR><TD class=Line colSpan=2></TD></TR> 
        <%}%>
        <%if(id.equals("2")){%>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(15799,user.getLanguage())%></TD>
          <TD class=Field><%=email%></TD>
        </TR>    
        <TR><TD class=Line colSpan=2></TD></TR> 
        <%}%>
        <%if(id.equals("3")){%>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(15800,user.getLanguage())%></TD>
          <TD class=Field><%=textfile1%></TD>         
        </TR>
        <%}%>      
        <%if(id.equals("4")){%>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(15801,user.getLanguage())%></TD>
          <TD class=Field><%=textfile2%></TD>           
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        <%}%>     
        <%if(id.equals("7")){%>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(15802,user.getLanguage())%></TD>
          <TD class=Field><%=telephone%></TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        <%}%> 
        <%if(id.equals("9")){%>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(1023,user.getLanguage())%></TD>
           <TD class=Field>
            <%if(tinyintfield1.equals("0")){%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%>
            <%if(tinyintfield1.equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}%>
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
</BODY>
</HTML>
