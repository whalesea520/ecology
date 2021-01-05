
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<%
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
				 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
				 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String lastname = Util.null2String(request.getParameter("lastname"));
String resourcetype = Util.null2String(request.getParameter("resourcetype"));
String resourcestatus = Util.null2String(request.getParameter("resourcestatus"));
String jobtitle = Util.null2String(request.getParameter("jobtitle"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String status = Util.null2String(request.getParameter("status"));

if(departmentid.equals("")&&sqlwhere.equals("")) departmentid=user.getUserDepartment()+"";
if(departmentid.equals("0"))    departmentid="";

if(resourcestatus.equals(""))   resourcestatus="0" ;
if(resourcestatus.equals("-1"))   resourcestatus="" ;

String check_per = ","+Util.null2String(request.getParameter("resourceids"))+",";

String resourceids = "" ;
String resourcenames ="";
String mobilenumbers = "";
String strtmp = "select id,lastname,mobile from HrmResource ";
RecordSet.executeSql(strtmp);
while(RecordSet.next()){
	if(check_per.indexOf(","+RecordSet.getString("id")+",")!=-1){

        resourceids +="," + RecordSet.getString("id");
        resourcenames += ","+RecordSet.getString("lastname");
        mobilenumbers += ","+RecordSet.getString("mobile");
	}
}

int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!lastname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where lastname like '%" + Util.fromScreen2(lastname,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and lastname like '%" + Util.fromScreen2(lastname,user.getLanguage()) +"%' ";
}
/*
if(!resourcetype.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where resourcetype = '"+ resourcetype + "' ";
	}
	else
		sqlwhere += " and resourcetype = '"+ resourcetype + "' ";
}
if(!resourcestatus.equals("")){
	if(ishead==0){
		ishead = 1;
		if(resourcestatus.equals("0"))
			sqlwhere += " where ((startdate='' or '"+currentdate+"'>=startdate or startdate is null) and (enddate='' or '"+currentdate+"'<= enddate or enddate is null)) ";
		else
			sqlwhere += " where (((startdate!='' and startdate is not null) and '"+currentdate+"'<=startdate) or ((enddate!='' or enddate is not null) and '"+currentdate+"'>= enddate)) ";
	}
	else {
		if(resourcestatus.equals("0"))
			sqlwhere += " and ((startdate='' or '"+currentdate+"'>=startdate or startdate is null) and (enddate='' or '"+currentdate+"'<= enddate or enddate is null)) ";
		else
			sqlwhere += " and (((startdate!='' and startdate is not null) and '"+currentdate+"'<=startdate) or ((enddate!='' or enddate is not null) and '"+currentdate+"'>= enddate)) ";
	}
}
*/
if(!jobtitle.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where jobtitle in(select id from HrmJobTitles where jobtitlename like '%" + Util.fromScreen2(jobtitle,user.getLanguage()) +"%') ";
	}
	else
		sqlwhere += " and jobtitle in(select id from HrmJobTitles where jobtitlename like '%" + Util.fromScreen2(jobtitle,user.getLanguage()) +"%') ";
}
if(!departmentid.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where departmentid =" + departmentid +" " ;
	}
	else
		sqlwhere += " and departmentid =" + departmentid +" " ;
}
if(!status.equals("")&&!status.equals("9")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where status =" + status +" " ;
	}
	else
		sqlwhere += " and status =" + status +" " ;
}
if(status.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where (status =0 or status = 1 or status = 2 or status = 3) " ;
	}
	else
		sqlwhere += " and (status =0 or status = 1 or status = 2 or status = 3) ";
}
/*
if(ishead==0){
		ishead = 1;
		sqlwhere += " where HrmResource.id >2 and status != 10 " ;
}else{
	sqlwhere += " and HrmResource.id > 2 and status != 10 ";
}
*/
String sqlstr = "select HrmResource.id,HrmResource.mobile,lastname,resourcetype,startdate,enddate,jobtitlename,departmentid "+
			    "from HrmResource , HrmJobTitles " + sqlwhere ;
if(ishead ==0) sqlstr += "where HrmJobTitles.id = HrmResource.jobtitle order by lastname" ;
else sqlstr += " and HrmJobTitles.id = HrmResource.jobtitle order by lastname " ;

%>

</HEAD>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
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
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="MutiResourceBrowser_1.jsp" method=post>
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:SearchForm.btnok.click(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=O id=btnok><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:SearchForm.btnclear.click(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<table width=100% class=ViewForm>
<TR class=Spacing>
<TD class=Line1 colspan=4></TD></TR>
<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <input class=inputstyle name=lastname value="<%=lastname%>">
      </TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <select class=inputstyle id=status name=status value="<%=status%>">
          <option value=9 <% if(status.equals("0")) { %>selected <%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
          <option value=""<% if(status.equals("")) { %>selected <%}%>><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%></option>
          <option value=0 <% if(status.equals("0")) { %>selected <%}%>><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></option>
          <option value=1 <% if(status.equals("1")) { %>selected <%}%>><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></option>
          <option value=2 <% if(status.equals("2")) { %>selected <%}%>><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></option>
          <option value=3 <% if(status.equals("3")) { %>selected <%}%>><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></option>
          <option value=4 <% if(status.equals("4")) { %>selected <%}%>><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%></option>
          <option value=5 <% if(status.equals("5")) { %>selected <%}%>><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%></option>
          <option value=6 <% if(status.equals("6")) { %>selected <%}%>><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%></option>
          <option value=7 <% if(status.equals("7")) { %>selected <%}%>><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option>
        </select>
      </TD>
<!--
<TD width=15%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <select class=inputstyle id=resourcetype name=resourcetype>
		  <option value=""></option>
          <option value=F <%if(resourcetype.equalsIgnoreCase("f")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(131,user.getLanguage())%></option>
          <option value=H <%if(resourcetype.equalsIgnoreCase("h")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(130,user.getLanguage())%></option>
          <option value=D <%if(resourcetype.equalsIgnoreCase("d")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(134,user.getLanguage())%></option>
          <option value=T <%if(resourcetype.equalsIgnoreCase("t")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></option>
        </select>
      </TD>
-->
</tr>
<TR><TD class=Line colSpan=6></TD></TR>
<tr>
<TD width=15%><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TD>
<TD width=35% class=field>
        <input class=inputstyle name=jobtitle maxlength=60 value="<%=jobtitle%>">
      </td>
<TD width=15%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <select class=inputstyle id=departmentid name=departmentid>
		<option value="0"><%=SystemEnv.getHtmlLabelName(16138,user.getLanguage())%></option>
		<% while(DepartmentComInfo.next()) {
			String tmpdepartmentid = DepartmentComInfo.getDepartmentid() ;
		%>
          <option value=<%=tmpdepartmentid%> <% if(tmpdepartmentid.equals(departmentid)) {%>selected<%}%>>
		  <%=Util.toScreen(DepartmentComInfo.getDepartmentname(),user.getLanguage())%></option>
		<% } %>
        </select>
      </TD>
</tr>
<TR><TD class=Line colSpan=6></TD></TR>
<tr>
            <td colspan="5" height="19">
              <input class=inputstyle type="checkbox" name="checkall0" onClick="CheckAll(checkall0.checked)" value="ON">
              <%=SystemEnv.getHtmlLabelName(2241,user.getLanguage())%></td>
          </tr>
     <TR class=Spacing><TD class=Line1 colspan=4></TD></TR>

</table>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0">
<TR class=DataHeader>
      <TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
	 <TH width=5%></TH>
     <TH width=20%><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TH>
     <TH width=20%><%=SystemEnv.getHtmlLabelName(422,user.getLanguage())%></TH>
      <TH width=20%><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TH>
      <TH width=25%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TH>
      </tr><TR class=Line><TH colspan="8" ></TH></TR>
<%
int i=0;
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
	String ids = RecordSet.getString("id");
	String lastnames = Util.toScreen(RecordSet.getString("lastname"),user.getLanguage());
    String mobiles = Util.toScreen(RecordSet.getString("mobile"),user.getLanguage());
	String resourcetypes = RecordSet.getString("resourcetype");
	String startdates = RecordSet.getString("startdate");
	String enddates = RecordSet.getString("enddate");
	String jobtitlenames = Util.toScreen(RecordSet.getString("jobtitlename"),user.getLanguage());
	String departmentids = RecordSet.getString("departmentid");
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
<TD style="display:none"><A HREF=#><%=ids%></A></TD>
<%
	 String ischecked = "";
	 if(check_per.indexOf(","+ids+",")!=-1){
         ischecked = " checked ";
	 }%>
	<TD><input class=inputstyle type=checkbox name="check_per" value="<%=ids%>" <%=ischecked%>></TD>
	<TD><%=lastnames%></TD>
    <TD><%=mobiles%></TD>
	<TD><%=jobtitlenames%></TD>	<TD><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentids),user.getLanguage())%></TD>
</TR>
<%}
%>

</TABLE>
  <input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
  <input class=inputstyle type="hidden" name="resourceids" value="">
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<SCRIPT LANGUAGE=VBS>
resourceids = "<%=resourceids%>"
resourcenames = "<%=resourcenames%>"
mobilenumbers = "<%=mobilenumbers%>"
Sub btnclear_onclick()
     window.parent.returnvalue = Array("","","")
     window.parent.close
End Sub
Sub BrowseTable_onclick()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then
   	set obj = e.parentelement.cells(1).all("check_per")
   	if obj.checked then
   		obj.checked = false
       	resourceids = replace(resourceids&",",","&e.parentelement.cells(0).innerText&",",",")
   		resourcenames = replace(resourcenames&",",","&e.parentelement.cells(2).innerText&",",",")
        mobilenumbers = replace(mobilenumbers&",",","&e.parentelement.cells(3).innerText&",",",")
        resourceids = Mid(resourceids,1,Len(resourceids)-1)
        resourcenames = Mid(resourcenames,1,Len(resourcenames)-1)
        mobilenumbers = Mid(mobilenumbers,1,Len(mobilenumbers)-1)
   	else
   		obj.checked = true
   		resourceids = resourceids & "," & e.parentelement.cells(0).innerText
   		resourcenames = resourcenames & "," & e.parentelement.cells(2).innerText
        mobilenumbers = mobilenumbers & "," & e.parentelement.cells(3).innerText
   	end if
  '   window.parent.returnvalue = Array(e.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText)
   '   window.parent.Close
   ElseIf e.TagName = "A" Then
   	set obj = e.parentelement.cells(1).all("check_per")
   	if obj.checked then
   		obj.checked = false
   		resourceids = replace(resourceids&",",","&e.parentelement.parentelement.cells(0).innerText&",",",")
   		resourcenames = replace(resourcenames&",",","&e.parentelement.parentelement.cells(2).innerText&",",",")
        mobilenumbers = replace(mobilenumbers&",",","&e.parentelement.parentelement.cells(3).innerText&",",",")
           resourceids = Mid(resourceids,1,Len(resourceids)-1)
        resourcenames = Mid(resourcenames,1,Len(resourcenames)-1)
        mobilenumbers = Mid(mobilenumbers,1,Len(mobilenumbers)-1)
   	else
   		obj.checked = true
   		resourceids = resourceids & "," & e.parentelement.parentelement.cells(0).innerText
   		resourcenames = resourcenames & "," & e.parentelement.parentelement.cells(2).innerText
        mobilenumbers = mobilenumbers & "," & e.parentelement.parentelement.cells(3).innerText
   	end if
    '  window.parent.returnvalue = Array(e.parentelement.parentelement.cells(0).innerText,e.parentelement.parentelement.cells(1).innerText)
     ' window.parent.Close
   ElseIf e.TagName = "INPUT" Then
   	if e.checked then
	   	resourceids = resourceids & "," & e.parentelement.parentelement.cells(0).innerText
	   	resourcenames = resourcenames & "," & e.parentelement.parentelement.cells(2).innerText
        mobilenumbers = mobilenumbers & "," & e.parentelement.parentelement.cells(3).innerText
	 else
	    resourceids = replace(resourceids&",",","&e.parentelement.parentelement.cells(0).innerText&",",",")
   		resourcenames = replace(resourcenames&",",","&e.parentelement.parentelement.cells(2).innerText&",",",")
        mobilenumbers = replace(mobilenumbers&",",","&e.parentelement.parentelement.cells(3).innerText&",",",")
        resourceids = Mid(resourceids,1,Len(resourceids)-1)
        resourcenames = Mid(resourcenames,1,Len(resourcenames)-1)
        mobilenumbers = Mid(mobilenumbers,1,Len(mobilenumbers)-1)
   	end if
    '  window.parent.returnvalue = Array(e.parentelement.parentelement.cells(0).innerText,e.parentelement.parentelement.cells(1).innerText)
     ' window.parent.Close

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

Sub btnok_onclick()
     window.parent.returnvalue = Array(resourceids,resourcenames,mobilenumbers)
    window.parent.close
End Sub

Sub btnsub_onclick()
    document.all("resourceids").value = resourceids
    document.SearchForm.submit
End Sub
</SCRIPT>

<script language="javascript">

function CheckAll(checked) {
//	alert(resourceids);
//	resourceids = "";
//	resourcenames = "";
	len = document.SearchForm.elements.length;
	var i=0;
	for( i=0; i<len; i++) {
		if (document.SearchForm.elements[i].name=='check_per') {
			if(!document.SearchForm.elements[i].checked) {
				resourceids = resourceids + "," + document.SearchForm.elements[i].parentElement.parentElement.cells(0).innerText;
		   		resourcenames = resourcenames + "," + document.SearchForm.elements[i].parentElement.parentElement.cells(2).innerText;
		   		mobilenumbers = mobilenumbers + "," + document.SearchForm.elements[i].parentElement.parentElement.cells(3).innerText;

		   	}
		   	document.SearchForm.elements[i].checked=(checked==true?true:false);
		}
 	}
 //	alert(resourceids);
}
function doSearch()
{
    document.all("resourceids").value = resourceids ;
    document.SearchForm.submit();
}
</script>
</BODY>
</HTML>