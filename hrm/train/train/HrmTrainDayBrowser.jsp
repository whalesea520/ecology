<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
				 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
				 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
//  String lastname = Util.toScreenToEdit(request.getParameter("searchid"),user.getLanguage(),"0");
String lastname = Util.null2String(request.getParameter("lastname"));
String firstname = Util.null2String(request.getParameter("firstname"));
String resourcetype = Util.null2String(request.getParameter("resourcetype"));
String resourcestatus = Util.null2String(request.getParameter("resourcestatus"));
String jobtitle = Util.null2String(request.getParameter("jobtitle"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String seclevelto=Util.fromScreen(request.getParameter("seclevelto"),user.getLanguage());
String status = Util.null2String(request.getParameter("status"));

boolean isoracle = (RecordSet.getDBType()).equals("oracle") ;


if(departmentid.equals("")&&sqlwhere.equals("")) departmentid=user.getUserDepartment()+"";
if(departmentid.equals("0"))    departmentid="";

/*if(resourcestatus.equals(""))   resourcestatus="0" ;
if(resourcestatus.equals("-1"))   resourcestatus="" ;*/
if(status.equals("-1")) status = "";
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
if(!firstname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where firstname like '%" + Util.fromScreen2(firstname,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and firstname like '%" + Util.fromScreen2(firstname,user.getLanguage()) +"%' ";
}
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
/*
if(!resourcestatus.equals("")){
	if(ishead==0){
		ishead = 1;
		if(resourcestatus.equals("0")) 
			sqlwhere += " where (((startdate='' or startdate is  null) or '"+currentdate+"'>=startdate ) and ((enddate='' or enddate is  null) or '"+currentdate+"'<= enddate )) ";
		else {
            if( !isoracle ) 
			    sqlwhere += " where (((startdate<>'' and startdate is not null) and '"+currentdate+"'<=startdate) or ((enddate<>'' and enddate is not null) and '"+currentdate+"'>= enddate)) ";
            else 
                sqlwhere += " where ((startdate is not null and '"+currentdate+"'<=startdate) or (enddate is not null and '"+currentdate+"'>= enddate)) ";
        }
	}
	else {
		if(resourcestatus.equals("0")) 
			sqlwhere += " and (((startdate='' or startdate is  null) or '"+currentdate+"'>=startdate ) and ((enddate='' or enddate is  null) or '"+currentdate+"'<= enddate )) ";
		else {
            if( !isoracle )
			    sqlwhere += " and (((startdate<>'' and startdate is not null) and '"+currentdate+"'<=startdate) or ((enddate<>'' and enddate is not null) and '"+currentdate+"'>= enddate)) ";
            else 
                sqlwhere += " and ((startdate is not null and '"+currentdate+"'<=startdate) or (enddate is not null and '"+currentdate+"'>= enddate)) ";
        }
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

String sqlstr = "select HrmResource.id,lastname,resourcetype,startdate,enddate,jobtitlename,departmentid "+
			    "from HrmResource , HrmJobTitles " + sqlwhere ;
if(ishead ==0) sqlstr += "where HrmJobTitles.id = HrmResource.jobtitle " ;
else sqlstr += " and HrmJobTitles.id = HrmResource.jobtitle " ;
%>
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
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="ResourceBrowser.jsp" method=post>
<input class=inputstyle type=hidden name=seclevelto value="<%=seclevelto%>">
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:SearchForm.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<button type="button" class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<button type="button" class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<button type="button" class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",document.SearchForm.btnclear.click(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<button type="button" class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<table width=100% class=ViewForm>
<TR class=spacing style="height:1px;"><TD class=line1 colspan=4></TD></TR>
<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
<TD width=35% class=field><input class=inputstyle name=lastname value="<%=lastname%>"></TD>
<!--
<TD width=15%><%=SystemEnv.getHtmlLabelName(460,user.getLanguage())%></TD>
<TD width=35% class=field><input class=inputstyle name=firstname value="<%=firstname%>"></TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(461,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <input class=inputstyle name=lastname value="<%=lastname%>">
      </TD>
</TR>
<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <select class=inputstyle id=resourcetype name=resourcetype>
		  <option value=""></option>
          <option value=1 <%if(resourcetype.equalsIgnoreCase("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(130,user.getLanguage())%></option>
          <option value=2 <%if(resourcetype.equalsIgnoreCase("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(131,user.getLanguage())%></option>
          <option value=3 <%if(resourcetype.equalsIgnoreCase("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(134,user.getLanguage())%></option>
          <option value=4 <%if(resourcetype.equalsIgnoreCase("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></option>
		  <option value=5 <%if(resourcetype.equalsIgnoreCase("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1932,user.getLanguage())%></option>
        </select>
      </TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <select class=inputstyle id=resourcestatus name=resourcestatus>
          <option value="-1"></option>
          <option value=0 <% if(resourcestatus.equals("0")) { %>selected <%}%>><%=SystemEnv.getHtmlLabelName(155,user.getLanguage())%></option>
          <option value=1 <% if(resourcestatus.equals("1")) { %>selected <%}%>><%=SystemEnv.getHtmlLabelName(415,user.getLanguage())%></option>
        </select>
-->     
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
</tr>
<TR style="height:1px;"><TD class=Line colSpan=6></TD></TR> 
<tr>
<TD width=15%><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TD>
<TD width=35% class=field>
        <input class=inputstyle name=jobtitle maxlength=60 value="<%=jobtitle%>">
      </td>
<TD width=15%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <select class=inputstyle id=departmentid name=departmentid>
		<option value="0"></option>
		<% while(DepartmentComInfo.next()) {  
			String tmpdepartmentid = DepartmentComInfo.getDepartmentid() ;
		%>
          <option value=<%=tmpdepartmentid%> <% if(tmpdepartmentid.equals(departmentid)) {%>selected<%}%>>
		  <%=Util.toScreen(DepartmentComInfo.getDepartmentname(),user.getLanguage())%></option>
		<% } %>
        </select>
      </TD>
</tr>
</table>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0;width:100%">
<TR class=DataHeader>
      <TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>      
	  <TH width=20%><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TH>      
      <TH width=25%><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TH>
      <TH width=25%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TH>
      </tr><TR class=Line  style="height:1px;"><TH colspan="4" ></TH></TR>
<%
int i=0;
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
	String ids = RecordSet.getString("id");
	String lastnames = Util.toScreen(RecordSet.getString("lastname"),user.getLanguage());
	String firstnames = Util.toScreen(RecordSet.getString("firstname"),user.getLanguage());
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
	<TD><%=firstnames%> <%=lastnames%></TD>
	
	<TD><%=jobtitlenames%></TD>
	<TD><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentids),user.getLanguage())%></TD>
</TR>
<%}
%>

</TABLE>
  <input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
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
</BODY>
</HTML>
<script	language="javascript">
function replaceToHtml(str){
	var re = str;
	var re1 = "<";
	var re2 = ">";
	do{
		re = re.replace(re1,"&lt;");
		re = re.replace(re2,"&gt;");
        re = re.replace(",","，");
	}while(re.indexOf("<")!=-1 || re.indexOf(">")!=-1)
	return re;
}

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
		window.parent.parent.returnValue = {id:jQuery(curTr.cells[0]).text(),name:replaceToHtml(jQuery(curTr.cells[1]).text())};
		window.parent.parent.close();
	}
}

function btnclear_onclick(){
	window.parent.parent.returnValue = {id:"",name:""};
	window.parent.parent.close();
}

$(function(){
	$("#BrowseTable").mouseover(BrowseTable_onmouseover);
	$("#BrowseTable").mouseout(BrowseTable_onmouseout);
	$("#BrowseTable").click(BrowseTable_onclick);
	$("#btnclear").click(btnclear_onclick);
});
</script>