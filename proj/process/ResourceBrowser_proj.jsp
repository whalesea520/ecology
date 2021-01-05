<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser_wev8.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
				 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
				 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
//  String lastname = Util.toScreenToEdit(request.getParameter("searchid"),user.getLanguage(),"0");
String lastname = Util.null2String(request.getParameter("lastname"));
//String firstname = Util.null2String(request.getParameter("firstname"));
String resourcetype = Util.null2String(request.getParameter("resourcetype"));
String resourcestatus = Util.null2String(request.getParameter("resourcestatus"));
String jobtitle = Util.null2String(request.getParameter("jobtitle"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String seclevelto=Util.fromScreen(request.getParameter("seclevelto"),user.getLanguage());

if(departmentid.equals("")&&sqlwhere.equals("")) departmentid=user.getUserDepartment()+"";
if(departmentid.equals("0"))    departmentid="";

if(resourcestatus.equals(""))   resourcestatus="0" ;
if(resourcestatus.equals("-1"))   resourcestatus="" ;
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
if(!firstname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where firstname like '%" + Util.fromScreen2(firstname,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and firstname like '%" + Util.fromScreen2(firstname,user.getLanguage()) +"%' ";
}
*/
if(!seclevelto.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where HrmResource.seclevel <= '"+ seclevelto + "' ";
	}
	else
		sqlwhere += " and HrmResource.seclevel <= '"+ seclevelto + "' ";
}
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
			sqlwhere += " where (((startdate='' or startdate is  null) or '"+currentdate+"'>=startdate ) and ((enddate='' or enddate is  null) or '"+currentdate+"'<= enddate )) ";
		else
			sqlwhere += " where (((startdate<>'' and startdate is not null) and '"+currentdate+"'<=startdate) or ((enddate<>'' and enddate is not null) and '"+currentdate+"'>= enddate)) ";
	}
	else {
		if(resourcestatus.equals("0")) 
			sqlwhere += " and (((startdate='' or startdate is  null) or '"+currentdate+"'>=startdate ) and ((enddate='' or enddate is  null) or '"+currentdate+"'<= enddate )) ";
		else
			sqlwhere += " and (((startdate<>'' and startdate is not null) and '"+currentdate+"'<=startdate) or ((enddate<>'' and enddate is not null) and '"+currentdate+"'>= enddate)) ";
	}
}
if(!jobtitle.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where jobtitlename like '%" + Util.fromScreen2(jobtitle,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and jobtitlename like '%" + Util.fromScreen2(jobtitle,user.getLanguage()) +"%' ";
}

String ProjID = request.getParameter("ProjID");
String sql_mem="select members from Prj_ProjectInfo where id= "+ProjID ;
RecordSet.executeSql(sql_mem);
RecordSet.next();
String Members=RecordSet.getString("members");
Members=Members.indexOf(",")==0?Members.substring(1):Members;

String sqlstr = "select HrmResource.id,lastname,resourcetype,startdate,enddate,jobtitlename,departmentid "+
			    "from HrmResource , HrmJobTitles where  HrmResource.id in"+ "("+Members+")" ;
if(ishead ==0) sqlstr += "where HrmJobTitles.id = HrmResource.jobtitle " ;
else sqlstr += " and HrmJobTitles.id = HrmResource.jobtitle " ;
%>
<BODY>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="ResourceBrowser.jsp" method=post>
<input type=hidden name=seclevelto value="<%=seclevelto%>">
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

<TABLE ID=BrowseTable class="BroswerStyle" cellspacing="1" width="100%">
<TR class=DataHeader>
      <TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>      
	  <TH width=20%><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TH>      
      <TH width=25%><%=SystemEnv.getHtmlLabelName(357,user.getLanguage())%></TH>
      <TH width=25%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TH></tr>
	  <TR class=Line><Th colspan="4" ></Th></TR> 
<%
int i=0;
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
	String ids = RecordSet.getString("id");
	String lastnames = Util.toScreen(RecordSet.getString("lastname"),user.getLanguage());
	//String firstnames = Util.toScreen(RecordSet.getString("firstname"),user.getLanguage());
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
	<TD><%=lastnames%></TD>
	
	<TD><%=jobtitlenames%></TD>
	<TD><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentids),user.getLanguage())%></TD>
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

  <input type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
</FORM></BODY></HTML>


<SCRIPT LANGUAGE=VBS>
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
</SCRIPT>
 <script language="javascript">
 function BrowseTable_onmouseover(e){
		e=e||event;
	   var target=e.srcElement||e.target;
	   if("TD"==target.nodeName){
			jQuery(target).parents("tr")[0].className = "Selected";
	   }else if("A"==target.nodeName){
			jQuery(target).parents("tr")[0].className = "Selected";
	   }
	}
	function BrowseTable_onmouseout(e){
		var e=e||event;
	   var target=e.srcElement||e.target;
	   var p;
		if(target.nodeName == "TD" || target.nodeName == "A" ){
	      p=jQuery(target).parents("tr")[0];
	      if( p.rowIndex % 2 ==0){
	         p.className = "DataDark"
	      }else{
	         p.className = "DataLight"
	      }
	   }
	}

	function BrowseTable_onclick(e){
	   var e=e||event;
	   var target=e.srcElement||e.target;
	   if( target.nodeName =="TD"||target.nodeName =="A"  ){
		var curTr=jQuery(target).parents("tr")[0];
	     window.parent.parent.returnValue = {
	    		 id:jQuery(curTr.cells[0]).text(),
	    		 name:jQuery(curTr.cells[1]).text(),
	    		 a1:jQuery(curTr.cells[3]).text(),
	    		 a2:jQuery(curTr.cells[4]).text()};
	    

	      window.parent.parent.close();
		}
	}
	$(function(){
		$("#BrowseTable").mouseover(BrowseTable_onmouseover);
		$("#BrowseTable").mouseout(BrowseTable_onmouseout);
		$("#BrowseTable").click(BrowseTable_onclick);
		
	});
function submitClear()
{btnclear_onclick();
}
</script>
