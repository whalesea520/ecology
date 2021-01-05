<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser_wev8.css>
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

//if(departmentid.equals("")&&sqlwhere.equals("")) departmentid=user.getUserDepartment()+"";
//if(departmentid.equals("0"))    departmentid="";


if(resourcestatus.equals(""))   resourcestatus="0" ;
if(resourcestatus.equals("-1"))   resourcestatus="" ;

String Prj_members =Util.null2String(request.getParameter("resourceids"));

String checkfirst= "";
if(!Prj_members.equals("")){
    checkfirst= Prj_members.substring(0,1);
    if(checkfirst.equals(",")) Prj_members = Prj_members.substring(1);
}

String check_per = ","+Util.null2String(request.getParameter("resourceids"))+",";
String resourceids = "" ;
String resourcenames ="";
String strtmp = "select id,lastname from HrmResource ";
RecordSet.executeSql(strtmp);
while(RecordSet.next()){
	if(check_per.indexOf(","+RecordSet.getString("id")+",")!=-1){
		 	
		 	resourceids +="," + RecordSet.getString("id");
		 	resourcenames += ","+RecordSet.getString("lastname");
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

/*
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
*/
String ProjID = request.getParameter("ProjID");
String sql_m ="select members from Prj_ProjectInfo where id ="+ProjID;
RecordSetM.execute(sql_m);
RecordSetM.next();
String proj_members= RecordSetM.getString(1);

if(proj_members==null||proj_members.trim().equals("")){
	proj_members="0";
}
proj_members=proj_members.indexOf(",")==0?proj_members.substring(1):proj_members;
if(sqlwhere.equals("")){
    sqlwhere ="where HrmResource.id in("+proj_members+")";
}else{
    sqlwhere +="and HrmResource.id in("+proj_members+")";
}

String sqlstr = "select HrmResource.id,lastname,resourcetype,startdate,enddate,jobtitlename,departmentid "+
			    "from HrmResource , HrmJobTitles " + sqlwhere ;
if(sqlwhere.equals("")) sqlstr += "where HrmJobTitles.id = HrmResource.jobtitle " ;
else sqlstr += " and HrmJobTitles.id = HrmResource.jobtitle " ;
//out.print(sqlwhere);

%>

</HEAD>

<BODY>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<!--BUTTON class=btnSearch accessKey=S id=btnsub><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON -->
<!--BUTTON class=btn accessKey=C id=btnclear><U>C</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON -->

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="MutiResourceBrowser_proj.jsp" method=post>


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


<table width=100% class=viewform>
<TR class=spacing style="height:1px;">
<TD class=line1 colspan=6></TD></TR>
<tr> 
            <td colspan="5" height="19"> 
              <input type="checkbox" name="checkall0" onClick="CheckAll(checkall0.checked)" value="ON">
              <%=SystemEnv.getHtmlLabelName(2241,user.getLanguage())%></td>
          </tr>
     <TR class=spacing style="height:1px;"><TD class=line1 colspan=6></TD></TR>

</table>
<TABLE ID=BrowseTable class="BroswerStyle" cellspacing="1" width="100%">
<TR class=DataHeader>
      <TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>      
	 <TH width=5%></TH>  
     <TH width=20%><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TH>      
      <TH width=20%><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TH>
      <TH width=25%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TH></tr>
	  <TR class=Line><Th colspan="5" ></Th></TR> 
<%
int i=0;
//System.out.println(sqlstr);
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
	String ids = RecordSet.getString("id");
	String lastnames = Util.toScreen(RecordSet.getString("lastname"),user.getLanguage());
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
	<TD><input type=checkbox name="check_per" value="<%=ids%>" <%=ischecked%>></TD>
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
  <input type="hidden" name="resourceids" value="">
</FORM>
<SCRIPT type="text/javascript">
var resourceids = "<%=resourceids%>";
var resourcenames = "<%=resourcenames%>";
function btnclear_onclick(){
     window.parent.parent.returnValue ={id:"",name:""};
     window.parent.parent.close();
}

function BrowseTable_onclick(e){
	var target=$.event.fix(e).target;
 	if( target.nodeName =="TD"||target.nodeName =="A"||target.nodeName=="INPUT"  ){
 		var curTr=jQuery(target).parents("tr")[0];
	
 		if(target.nodeName=="INPUT"&&$(curTr).find("input")[0].checked){
 			resourceids+=","+$(curTr.cells[0]).text();
 			resourcenames+=","+$(curTr.cells[2]).text();
 	 	}
 	 	else if(target.nodeName=="INPUT"&&$(curTr).find("input")[0].checked==false){
 	 		resourceids=resourceids.replace(","+$(curTr.cells[0]).text(),"");
 	 		resourcenames=resourceids.replace(","+$(curTr.cells[2]).text(),"");
 	 	 }
 	 	else{
			if($(curTr).find("input")[0].checked){
				resourceids=resourceids.replace(","+$(curTr.cells[0]).text(),"");
	 	 		resourcenames=resourceids.replace(","+$(curTr.cells[2]).text(),"");
				$(curTr).find("input")[0].checked=false;
			}else{
				resourceids+=","+$(curTr.cells[0]).text();
	 			resourcenames+=","+$(curTr.cells[2]).text();
				$(curTr).find("input")[0].checked=true;
			}
 	 	 }
 	}
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

function btnok_onclick(){
     window.parent.parent.returnValue ={id:resourceids,name:resourcenames};
    window.parent.parent.close();
}

function btnsub_onclick(){
   $("input[name=resourceids]").value = resourceids;
    document.SearchForm.submit();
}
$(function(){
 	$("#BrowseTable").mouseover(BrowseTable_onmouseover);
 	$("#BrowseTable").mouseout(BrowseTable_onmouseout);
 	$("#BrowseTable").click(BrowseTable_onclick);
 });
</SCRIPT>

<script language="javascript">
function CheckAll(checked) {
//	alert(resourceids);
//	resourceids = "";
//	resourcenames = "";
	len = document.SearchForm.elements.length;
if(checked == true){
	var i=0;
	for( i=0; i<len; i++) {	
		if (document.SearchForm.elements[i].name=='check_per') {
			if(!document.SearchForm.elements[i].checked) {
				resourceids = resourceids + "," + document.SearchForm.elements[i].parentElement.parentElement.cells(0).innerText;
		   		resourcenames = resourcenames + "," + document.SearchForm.elements[i].parentElement.parentElement.cells(2).innerText;
		   	}
		   	document.SearchForm.elements[i].checked=(checked==true?true:false);			
		}
 	}
}else{
	resourceids = "";
	resourcenames = "";
	for( i=0; i<len; i++) {	
		document.SearchForm.elements[i].checked=false;
 	}
} 
 //	alert(resourceids);
}
</script>

 <script language="javascript">
function submitData()
{btnok_onclick();
}
</script>
</BODY></HTML>