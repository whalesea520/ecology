<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
String groupname=Util.null2String(request.getParameter("groupname"));
String groupdesc=Util.null2String(request.getParameter("groupdesc"));
String mailgroupid=Util.null2String(request.getParameter("mailgroupid"));
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
int ishead = 0;
String sqlwhere = " ";
int userid=user.getUID() ;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}
if(!mailgroupid.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where mailgroupid =" + mailgroupid ;
	}
	else 
		sqlwhere += " and mailgroupid =" + mailgroupid ;
}
if(!groupname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where mailgroupname like '%" + Util.fromScreen2(groupname,user.getLanguage()) +"%' ";
	}
	else 
		sqlwhere += " and mailgroupname like '%" + Util.fromScreen2(groupname,user.getLanguage()) +"%' ";
}
if(!groupdesc.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where operatedesc like '%" + Util.fromScreen2(groupdesc,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and operatedesc like '%" + Util.fromScreen2(groupdesc,user.getLanguage()) +"%' ";
}

if(ishead==0){
	ishead = 1;
	sqlwhere += " where createrid =" + userid ;
}
else
	sqlwhere += " and createrid =" + userid ;
		
String sqlstr = "select * from MailUserGroup" + sqlwhere ;
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="MailUserGroupBrowser.jsp" method=post>
<input type=hidden name=mailgroupid >
<input type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere1)%>">
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

			<table width=100% class=ViewForm>
			<TR class=Spacing><TD class=Line1 colspan=4></TD></TR>
			<TR>
			<TD width=20%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
			<TD width=30% class=field><input name=groupname value="<%=groupname%>" class="InputStyle"></TD>
			<TD width=20%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
			<TD width=30% class=field><input name=groupdesc value="<%=groupdesc%>" class="InputStyle"></TD>
			</TR>
			<TR class=Spacing><TD class=Line1 colspan=4></TD></TR>
			</table>
            <TABLE ID=BrowseTable class=BroswerStyle cellspacing=1 STYLE="margin-top:0">
            <TR class=DataHeader>
                 <TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>      
                 <TH width=40%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>      
                  <TH width=60%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH>
                 </TR>
                <TR class=Line><TH colspan="4" ></TH></TR> 
            <%	
            int i=0;
            RecordSet.executeSql(sqlstr);
            while(RecordSet.next()){
                String tmpmailgroupid=RecordSet.getString("mailgroupid");
                String mailgroupname=RecordSet.getString("mailgroupname");
                String operatedesc=RecordSet.getString("operatedesc");
                String usermails="";
                String emailsql="select t1.email from hrmresource t1,mailuser t2 where t1.id=t2.resourceid and t2.mailgroupid="+tmpmailgroupid ;
                rs.executeSql(emailsql) ;
                while(rs.next()){
                    String tmpmail=rs.getString("email");
                    if(!tmpmail.equals("")){
                        if(usermails.equals(""))    usermails=tmpmail ;
                        else    usermails+=","+tmpmail;
                    }
                }
                emailsql="select mailaddress from MailUserAddress where mailgroupid="+tmpmailgroupid ;
                rs.executeSql(emailsql) ;
                while(rs.next()){
                    String tmpmail=rs.getString("mailaddress");
                    if(!tmpmail.equals("")){
                        if(usermails.equals(""))    usermails=tmpmail ;
                        else    usermails+=","+tmpmail;
                    }
                }
                if(i==0){
                    i=1;
            %>
            <TR class=DataLight>
            <%
                }else{
                    i=0;
            %>
            <TR class=DataDark>
            <%
            }
            %>
                <TD style="display:none"><A HREF=#><%=usermails%></A></TD>
                <Td width=30%><%=Util.toScreen(mailgroupname,user.getLanguage())%></Td>      
                <Td width=50%><%=Util.toScreen(operatedesc,user.getLanguage())%></Td>
            </TR>
            <%}
            %>
            </TABLE>
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

</FORM>
</BODY>
</HTML>

<script language=javascript>
function onview(objval1){
	SearchForm.mailgroupid.value=objval1;
	SearchForm.submit();
}
</script>

<SCRIPT LANGUAGE=VBS>
resourceids = ""
resourcenames = ""
Sub btnclear_onclick()
     window.parent.returnvalue = Array("","")
     window.parent.close
End Sub
Sub BrowseTable_onclick()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then   	
     window.parent.returnvalue = Array(e.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText)
      window.parent.Close
   ElseIf e.TagName = "A" Then
      window.parent.returnvalue = Array(e.parentelement.parentelement.cells(0).innerText,e.parentelement.parentelement.cells(1).innerText)
      window.parent.Close
   End If
End Sub
Sub BrowseTable_onmouseover()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then
      e.parentelement.className = "Selected"
   ElseIf e.TagName = "A" Then
      e.parentelement.parentelement.className = "Selected"
   End If
End Sub
Sub BrowseTable_onmouseout()
   Set e = window.event.srcElement
   If e.TagName = "TD" Or e.TagName = "A" Then
      If e.TagName = "TD" Then
         Set p = e.parentelement
      Else
         Set p = e.parentelement.parentelement
      End If
      If p.RowIndex Mod 2 Then
         p.className = "DataLight"
      Else
         p.className = "DataDark"
      End If
   End If
End Sub
Sub BrowseTable1_onclick()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then   	
   	set obj = e.parentelement.cells(1).all("check_per")
   	if obj.checked then
   		obj.checked = false
   		resourceids = replace(resourceids,","&e.parentelement.cells(0).innerText,"")
   		resourcenames = replace(resourcenames,","&e.parentelement.cells(2).innerText,"")
   	else
   		obj.checked = true
   		resourceids = resourceids & "," & e.parentelement.cells(0).innerText
   		resourcenames = resourcenames & "," & e.parentelement.cells(2).innerText
   	end if
   ElseIf e.TagName = "A" Then
   	set obj = e.parentelement.cells(1).all("check_per")
   	if obj.checked then
   		obj.checked = false
   		resourceids = replace(resourceids,","&e.parentelement.parentelement.cells(0).innerText,"")
   		resourcenames = replace(resourcenames,","&e.parentelement.parentelement.cells(2).innerText,"")
   	else
   		obj.checked = true
   		resourceids = resourceids & "," & e.parentelement.parentelement.cells(0).innerText
   		resourcenames = resourcenames & "," & e.parentelement.parentelement.cells(2).innerText
   	end if
   ElseIf e.TagName = "INPUT" Then
   	if e.checked then 
	   	resourceids = resourceids & "," & e.parentelement.parentelement.cells(0).innerText
	   	resourcenames = resourcenames & "," & e.parentelement.parentelement.cells(2).innerText
	 else
	 	resourceids = replace(resourceids,","&e.parentelement.parentelement.cells(0).innerText,"")
   		resourcenames = replace(resourcenames,","&e.parentelement.parentelement.cells(2).innerText,"")
   	end if
   End If
End Sub
Sub BrowseTable1_onmouseover()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then
      e.parentelement.className = "Selected"
   ElseIf e.TagName = "A" Then
      e.parentelement.parentelement.className = "Selected"
   End If
End Sub
Sub BrowseTable1_onmouseout()
   Set e = window.event.srcElement
   If e.TagName = "TD" Or e.TagName = "A" Then
      If e.TagName = "TD" Then
         Set p = e.parentelement
      Else
         Set p = e.parentelement.parentelement
      End If
      If p.RowIndex Mod 2 Then
         p.className = "DataLight"
      Else
         p.className = "DataDark"
      End If
   End If
End Sub

Sub btnok_onclick()
	if resourceids<>"" then
	        resourceids=Mid(resourceids,2,len(resourceids))
	end if
    window.parent.returnvalue = Array(resourceids,resourcenames)
    window.parent.close
End Sub
</SCRIPT>
<script language="javascript">
function onClear()
{
	btnclear_onclick() ;
}
function onSubmit()
{
	SearchForm.submit();
}
function doSubmit()
{
	btnok_onclick() ;
}
</script>