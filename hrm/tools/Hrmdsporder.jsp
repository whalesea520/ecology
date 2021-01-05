<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>

<%
if(!HrmUserVarify.checkUserRight("Hrmdsporder:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>

<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =  SystemEnv.getHtmlLabelName(15513,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

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
int userid=user.getUID();


int perpage = 10;
//String perpage     ="";
RecordSet.executeProc("HrmUserDefine_SelectByID",""+userid);
if(RecordSet.next()){
perpage     =Integer.parseInt(RecordSet.getString("dspperpage")); 

}
/*分页*/
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
//int	perpage=50;



String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String departmentid=Util.null2String(request.getParameter("departmentid")) ;
String subcompanyid1 = Util.null2String(request.getParameter("subcompanyid1")) ;
/**String resourcename = Util.null2String(request.getParameter("resourcename"));
String flag = Util.null2String(request.getParameter("flag"));
if (flag.equals("1")) resourcename = Util.null2String((String)session.getAttribute("resourcenameAAA"));
*/
String method=Util.null2String(request.getParameter("method"));
if(method.equals("empty"))
{
	 departmentid="";
	 subcompanyid1 = "";
}

String sql = "";
if(!subcompanyid1.equals("")){
		sqlwhere += "and subcompanyid1="+subcompanyid1+" ";
}

if(!departmentid.equals("")){
		sqlwhere += "and departmentid="+departmentid+" ";
}
/**if(!resourcename.equals("")){
		sqlwhere+= "and lastname like '%"+resourcename +"%' ";
}
*/
if(RecordSet.getDBType().equals("oracle")){
 sql =" (select * from (select id,lastname,dsporder,departmentid,subcompanyid1 from hrmresource where 1=1 "+ sqlwhere +"  and (status=0 or status = 1 or status = 2 or status = 3) order by dsporder asc,id asc) where rownum<"+ (pagenum*perpage+1)+"    order by dsporder desc ,lastname desc,id desc)s";
}else{
 sql = " (select top "+(pagenum*perpage)+" * from (select distinct top "+(pagenum*perpage)+" id,lastname,dsporder,departmentid,subcompanyid1 from hrmresource where 1=1 "+ sqlwhere+" and (status=0 or status = 1 or status = 2 or status = 3) order by dsporder,id asc)as s order by dsporder desc ,lastname desc,id desc) as t ";
}

%>
<form  id="frmmain" name="frmmain" action="HrmdsporderOperation.jsp" method=post >
<table class=Viewform>
<colgroup> <col width="10%"> <col width="20%"> <col width="10%"> <col width="25%"><col width="10%"> 
<col width="25%"><tbody> 
 <tr>
	<td><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></td>
	<td class=field>

	<input class="wuiBrowser" name=subcompanyid1 value="<%=subcompanyid1%>" type=hidden
	_url="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
	_displayText="<%=SubCompanyComInfo.getSubCompanyname(subcompanyid1)%>">
    </td>
    <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
    <td class=field>

    <input class="wuiBrowser" name="departmentid" value="<%=departmentid%>" type=hidden 
	_url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
	_displayText="<%=DepartmentComInfo.getDepartmentname(departmentid)%>">
    </td>
  </tr>
</table>

<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="10%">
  <COL width="25%">
  <COL width="20%">	
  <COL width="25%">
  <COL width="20%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=5><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TH></TR>
   <TR class=Header>
    <td></td>
    <TD><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
	<TD><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
	<TD><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TD>
  </TR>  

<%
boolean islight=true ;
RecordSet.executeSql("Select count(id) RecordSetCounts from "+sql);
boolean hasNextPage=false;
int RecordSetCounts = 0;
int RecordSetCounts1 = 0;
if(RecordSet.next()){
	RecordSetCounts = RecordSet.getInt("RecordSetCounts");
}
RecordSet2.executeSql("select count(id) as total from hrmresource where 1=1 "+sqlwhere+"  and (status=0 or status = 1 or status = 2 or status = 3) ");
if(RecordSet2.next()) RecordSetCounts1 = RecordSet2.getInt("total");
if(RecordSetCounts1>pagenum*perpage){
	hasNextPage=true;
}

String sqltemp="";
int topnum = (RecordSetCounts-(pagenum-1)*perpage);

if(topnum<0){
	topnum = 0;
}
if(RecordSet.getDBType().equals("oracle")){
	sqltemp="select * from (select * from  "+sql+") where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1)+"  order by dsporder asc,lastname asc,id asc";

}else{
	sqltemp=" select top "+topnum+" * from ( select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+sql+") as m  order by dsporder asc,lastname asc,id asc";

}
//System.out.println("sqltemp-----:"+sqltemp);
RecordSet.executeSql(sqltemp);


//RecordSet.executeSql(sql);
boolean cansave = false;
String lastname = "";
String ids = "";
String deptid ="";
String dsporder = "";
String dsporderdb = "";
String subtid = "";
while(RecordSet.next()){
	 cansave =true;
     lastname=RecordSet.getString("lastname");
	 String tempid = RecordSet.getString("id");
     ids+=tempid+",";
     deptid=RecordSet.getString("departmentid");
	 subtid = DepartmentComInfo.getSubcompanyid1(deptid);
	 String tempdsporder =  Util.null2String(RecordSet.getString("dsporder"));
	 if(!tempdsporder.equals("")){
		dsporderdb+=tempdsporder+",";
	 }else{
		dsporderdb+=tempid+",";
	 }
	 if(tempdsporder.equals("")){
		 RecordSet1.executeSql("update hrmresource set dsporder =id where dsporder is null") ;
		tempdsporder = tempid;
	 }
%>
    <tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
        <td><a href="javascript:this.openFullWindowForXtable('HrmdsporderEdit.jsp?id=<%=tempid%>&departmentidselect=<%=departmentid%>&subcompanyid1select=<%=subcompanyid1%>')">>>></a></td>
        <td><a href="/hrm/resource/HrmResource.jsp?id=<%=tempid%>" target=_blank><%=Util.toScreen(lastname,user.getLanguage())%></a></td>
		<td><%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(subtid),user.getLanguage())%></td>
        <td><%=Util.toScreen(DepartmentComInfo.getDepartmentname(deptid),user.getLanguage())%></td>
		<td class=field><input maxLength=7 class=inputstyle name="dsporder_<%=tempid%>" size=7 value="<%=tempdsporder%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)'></td>
    </tr>
<%
    islight=!islight;
}
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
if(HrmUserVarify.checkUserRight("Hrmdsporder:Add",user)) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onGoSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",javascript:onClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
if(cansave){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_top} " ;
RCMenuHeight += RCMenuHeightStep;
}
if(pagenum>1){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:prePage(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
}

if(hasNextPage){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:nextPage(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
}
%>

  </tbody>
</TABLE>
  <input class=inputstyle name="ids" type=hidden value="<%=ids%>">
  <input type="hidden" name="method" value="SaveOrder">
  <input type="hidden" name="dsporderdb" value="<%=dsporderdb%>">
  <input type="hidden" name="departmentspan" value="<%=departmentid%>">	
  <input type="hidden" name="subcompanyid1span" value="<%=subcompanyid1%>">
  <input class=inputstyle type=hidden name=pagenum >
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
</form>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script language=vbs>
sub onShowSubcompanyid()
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="&frmmain.subcompanyid1.value)
	if NOT isempty(id) then
	    if id(0)<> 0 then
		subcompanyid1span.innerHtml = id(1)
		frmmain.subcompanyid1.value=id(0)
		else
		subcompanyid1span.innerHtml = ""
		frmmain.subcompanyid1.value=""
		end if
	end if
	
end sub
sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmmain.departmentid.value)
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	departmentspan.innerHtml = id(1)
	frmmain.departmentid.value=id(0)
	else
	departmentspan.innerHtml = ""
	frmmain.departmentid.value=""
	end if
	end if
end sub

</script>

<script language=javascript>
function onGoSearch(){
	frmmain.action="Hrmdsporder.jsp"
	frmmain.submit();
}

function onSave(obj){
		obj.disabled = true ;
		frmmain.submit(); 
}
function onClear(){
	//document.getElementById("subcompanyid1").value="";
	//subcompanyid1span.innerHTML="";

	//document.getElementById("departmentid").value="";
	//departmentspan.innerHTML="";

	//document.getElementById("resourcename").value="";
	//resourcename.innerHTML="";
	document.frmmain.method.value="empty";
	frmmain.action="Hrmdsporder.jsp"
	frmmain.submit();
}
function nextPage(){
    document.frmmain.pagenum.value="<%=pagenum+1%>";
    document.frmmain.action="Hrmdsporder.jsp";
    document.frmmain.submit();
}

function prePage(){
    document.frmmain.pagenum.value="<%=pagenum-1%>";
    document.frmmain.action="Hrmdsporder.jsp";
    document.frmmain.submit();
}
</script>
</BODY>
</HTML>
