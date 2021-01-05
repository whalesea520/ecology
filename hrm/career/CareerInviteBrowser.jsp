
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.*" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="CareerPlanComInfo" class="weaver.hrm.career.CareerPlanComInfo" scope="page"/>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
String jobtitle = Util.null2String(request.getParameter("jobtitle"));
String tempcareerdesc = Util.null2String(request.getParameter("careerdesc"));

String  sqlwhere ="";
if (!jobtitle.equals("")){ 
	sqlwhere = " where careername ='"+Util.fromScreen2(jobtitle,user.getLanguage())+"' ";
if (!tempcareerdesc.equals(""))
		sqlwhere +=" and careerdesc like '%"+Util.fromScreen2(tempcareerdesc,user.getLanguage())+"%' ";
}
else{
	if (!tempcareerdesc.equals(""))
		sqlwhere +=" where careerdesc like '%"+Util.fromScreen2(tempcareerdesc,user.getLanguage())+"%' ";
}
String sqlstr = "select * from HrmCareerInvite " + sqlwhere ;

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(366,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
</colgroup>
<tr style="height:1px;">
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="CareerInviteBrowser.jsp" method=post>
<input class=inputstyle type=hidden name=sqlwhere value="">
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onclick="window.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<BUTTON class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<table width=100% class=ViewForm>
<TR class= Spacing style="height:2px"><TD class=Line1 colspan=4></TD></TR>
<TR>
<TD width=10%><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></TD>
<TD width=30% class=field>
  <input class=inputstyle name=topic value="">
</TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(15668,user.getLanguage())%></TD>
<TD width=45% class=field>
  <BUTTON class=Calendar type="button" id=selectdate onclick="getDate(datespan,startdate)"></BUTTON> 
  <SPAN id=datespan ></SPAN>-- 
  <BUTTON class=Calendar type="button" id=selectdateto onclick="getDate(datetospan,startdateto)"></BUTTON> 
  <SPAN id=datetospan ></SPAN> 
  <input class=inputstyle type="hidden" id="startdateto" name="startdateto" value="">   
  <input class=inputstyle type="hidden" id="startdate" name="startdate" value=""> 
</TD>
</TR>
<TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
<TR>
<TD width=10%><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TD>
<TD width=30% class=field>
 
  <input class="wuiBrowser" id=jobtitle type=hidden name=principalid value=""
  _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
  _displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>">                          
</TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(15669,user.getLanguage())%></TD>
<TD width=45% class=field>

  <input class="wuiBrowser" id=jobtitle type=hidden name=informmanid value=""
    _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
  _displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>">
</TD>
</TR>

<TR class= Spacing style="height:2px"><TD class=Line1 colspan=4></TD></TR>
</table>
<BR>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="width:100%;margin-top:0">

  <COLGROUP>  
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <TR class=DataHeader>
    <TH  colspan=7><%=SystemEnv.getHtmlLabelName(366,user.getLanguage())%></TH>
  </TR>
  <TR class=DataHeader>    
	<TH><%=SystemEnv.getHtmlLabelName(357,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(1859,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(1860,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(1861,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(1862,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(6132,user.getLanguage())%></TH>
	</tr><TR class=Line><TH colspan="8" ></TH></TR>

<%
int i= 0;
rs.executeSql(sqlstr);
while(rs.next()) {
	String id = rs.getString("id") ;
	String careername = Util.toScreen(rs.getString("careername"),user.getLanguage()) ;
	String careerpeople = Util.null2String(rs.getString("careerpeople")) ;
	String careersex = Util.null2String(rs.getString("careersex")) ; 
	String careeredu = Util.null2String(rs.getString("careeredu")) ;
	String createrid = Util.null2String(rs.getString("createrid")) ;
	String createdate = Util.null2String(rs.getString("createdate"));
	String planid = Util.null2String(rs.getString("careerplanid")) ;
	String careersexstr="";
	String careeredustr="";
	if (careersex.equals("0")) careersexstr = SystemEnv.getHtmlLabelName(417,user.getLanguage());
	else if	(careersex.equals("1")) careersexstr = SystemEnv.getHtmlLabelName(418,user.getLanguage());
	else if (careersex.equals("2")) careersexstr = SystemEnv.getHtmlLabelName(763,user.getLanguage());
	if (careeredu.equals("0")) careeredustr = SystemEnv.getHtmlLabelName(764,user.getLanguage());
	else if	(careeredu.equals("1")) careeredustr = SystemEnv.getHtmlLabelName(765,user.getLanguage());
	else if (careeredu.equals("2")) careeredustr = SystemEnv.getHtmlLabelName(766,user.getLanguage());
	else if (careeredu.equals("3")) careeredustr = SystemEnv.getHtmlLabelName(767,user.getLanguage());
	else if (careeredu.equals("4")) careeredustr = SystemEnv.getHtmlLabelName(768,user.getLanguage());
	else if (careeredu.equals("5")) careeredustr = SystemEnv.getHtmlLabelName(769,user.getLanguage());	
	else if (careeredu.equals("6")) careeredustr = SystemEnv.getHtmlLabelName(763,user.getLanguage());	

    // 刘煜修改，为了和以前的相一致
    String thecareername = careername ;
    if( Util.getIntValue(thecareername) != -1 ) thecareername = JobTitlesComInfo.getJobTitlesname(thecareername) ;

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
   <TD style="display:none"><a href='#'><%=id%></a></TD>
	<TD><%=thecareername%> </TD>
	<TD style="display:none"><%=careername%></TD>
	<TD><%=careerpeople%></TD>
	<TD><%=careersexstr%></TD>
	<TD><%=careeredustr%></TD>
	<TD><%=Util.toScreen(ResourceComInfo.getResourcename(createrid),user.getLanguage())%></TD>
	<TD><%=createdate%></TD>
	<TD><%=CareerPlanComInfo.getCareerPlantopic(planid)%></TD>
    </TR>
<%}%>
  </TABLE>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="0" colspan="3"></td>
</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>

<SCRIPT LANGUAGE="JavaScript">
jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
			//alert(jQuery(this).find("td:nth-child(2)").text())
		window.parent.parent.returnValue = {"id":jQuery(this).find("td:first").text(),"name":jQuery(this).find("td:nth-child(2)").text(),other1:jQuery(this).find("td:nth-child(3)").text(),other2:jQuery(this).find("td:nth-child(9)").text()};
			
				window.parent.parent.close();
		})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
			jQuery(this).addClass("Selected")
		})
		jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
			jQuery(this).removeClass("Selected")
		})

})


function submitClear()
{
	window.parent.returnValue = {id:"0",name:""};
	window.parent.parent.close()
}
</SCRIPT>