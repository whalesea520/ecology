
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetHrm" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />


<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
char flag = 2;
String ProcPara = "";
String log = Util.null2String(request.getParameter("log"));

int MaxVersion=1;
String isActived="";

String ProjID = Util.null2String(request.getParameter("ProjID"));
RecordSet.executeProc("Prj_TaskInfo_SelectMaxVersion",ProjID);
if(RecordSet.next()){
	MaxVersion = RecordSet.getInt("version");
	isActived = RecordSet.getString("isactived"); 
}else{
	response.sendRedirect("/proj/plan/NewPlan.jsp?log=n&ProjID="+ProjID) ;
}
String logintype = ""+user.getLogintype();
/*权限－begin*/
boolean canview=false;
boolean canedit=false;
boolean iscreater=false;
boolean ismanager=false;
boolean ismanagers=false;
boolean ismember=false;
boolean isrole=false;
boolean isshare=false;
String iscustomer="0";

String ViewSql="select * from PrjShareDetail where prjid="+ProjID+" and usertype="+user.getLogintype()+" and userid="+user.getUID();

RecordSetV.executeSql(ViewSql);

if(RecordSetV.next())
{
	 canview=true;
	 if(RecordSetV.getString("usertype").equals("2")){
	 	iscustomer=RecordSetV.getString("sharelevel");
	 }else{
		 if(RecordSetV.getString("sharelevel").equals("2")){
			canedit=true;	
			ismanager=true;  
		 }else if (RecordSetV.getString("sharelevel").equals("3")){
			canedit=true;	
			ismanagers=true;
		 }else if (RecordSetV.getString("sharelevel").equals("4")){
			canedit=true;	
			isrole=true;
		 }else if (RecordSetV.getString("sharelevel").equals("5")){
			ismember=true;
		 }else if (RecordSetV.getString("sharelevel").equals("1")){
			isshare=true;
		 }	 
	 }
}

if(!canview){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
/*权限－end*/

RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
if(RecordSet.getCounts()<=0)
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
RecordSet.first();

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(407,user.getLanguage())+"-"+"<a href='/proj/data/ViewProject.jsp?log="+log+"&ProjID="+ProjID+"'>"+Util.toScreen(RecordSet.getString("name"),user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";


String Version = Util.null2String(request.getParameter("version"));
String level = Util.null2String(request.getParameter("level"));
String subject= Util.fromScreen2(request.getParameter("subject"),user.getLanguage());
String begindate01= Util.null2String(request.getParameter("begindate01"));
String begindate02= Util.null2String(request.getParameter("begindate02"));
String enddate01= Util.null2String(request.getParameter("enddate01"));
String enddate02= Util.null2String(request.getParameter("enddate02"));
String hrmid = Util.null2String(request.getParameter("hrmid"));
if(level.equals("")){
	level = "10" ;
}
if(Version.equals("")){
	Version = ""+MaxVersion ;
}

String sqlwhere="";
sqlwhere=" where prjid = "+ProjID+" and  level_n <= 10 and  version = "+Version+" and isdelete<>'1' ";
if(!subject.equals("")){
	sqlwhere+=" and subject like '%"+subject+"%' ";
}
if(!begindate01.equals("")){
	sqlwhere+=" and begindate>='"+begindate01+"'";
}
if(!begindate02.equals("")){
	sqlwhere+=" and begindate<='"+begindate02+"'";
}
if(!enddate01.equals("")){
	sqlwhere+=" and enddate>='"+enddate01+"'";
}
if(!enddate02.equals("")){
	sqlwhere+=" and enddate<='"+enddate02+"'";
}
if(!hrmid.equals("")){
	sqlwhere+=" and hrmid='"+hrmid+"'";
}

String sqlstr = " SELECT * FROM Prj_TaskInfo " +sqlwhere+ " order by parentids";
RecordSet.executeSql(sqlstr);


ProcPara = ProjID + flag + "" ;
RecordSetHrm.executeProc("Prj_Member_SumProcess",ProcPara);
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javaScript:weaver.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1338,user.getLanguage())+",/proj/process/ViewProcess.jsp?log=n&ProjID="+ProjID+",_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1297,user.getLanguage())+",/proj/report/PlanAndProcess.jsp?ProjID="+ProjID+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name=weaver method=post action="/proj/plan/ViewPlan.jsp">
  <input type="hidden" name="ProjID" value="<%=ProjID%>">
  
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

<table class=liststyle cellspacing=1 >
  <tr class=datadark>
     <td width="60"><%=SystemEnv.getHtmlLabelName(1333,user.getLanguage())%></td>
     <td class=field>&nbsp
		<select class=inputstyle  name=version size=1 class=inputstyle   onChange="weaver.submit()">
		 <%for(int i=1;i<=MaxVersion;i++){%>
			 <option value="<%=i%>" <%if(Version.equals(""+i)){%>selected<%}%>><%=i%></option>
		 <%}%>
		 </select>	 
	 </td>

     <td width="60" align=right><%=SystemEnv.getHtmlLabelName(1352,user.getLanguage())%></td>
     <td class=field>&nbsp
		<input name=subject size=15 class="InputStyle" value="<%=Util.toScreenToEdit(request.getParameter("subject"),user.getLanguage())%>">	 
	 </td>
     <TD><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></TD>
     <TD class=Field>
			  <BUTTON class=calendar id=SelectDate onclick=getProjSubDate(begindate01span,begindate01)></BUTTON>&nbsp;
			  <SPAN id=begindate01span ><%=begindate01%></SPAN>
			  <input type="hidden" name="begindate01" value="<%=begindate01%>">
			  －	&nbsp;<BUTTON class=calendar id=SelectDate onclick=getProjSubDate(begindate02span,begindate02)></BUTTON>&nbsp;
			  <SPAN id=begindate02span ><%=begindate02%></SPAN>
			  <input type="hidden" name="begindate02" value="<%=begindate02%>">
		  
	</TD>
  </tr>
  <tr class=datadark>
     <td width="60"><%=SystemEnv.getHtmlLabelName(2099,user.getLanguage())%></td>
     <td class=field>&nbsp
		<select class=inputstyle  name=level size=1 class=inputstyle   onChange="weaver.submit()">
		 <%for(int i=1;i<=10;i++){%>
			 <option value="<%=i%>" <%if(level.equals(""+i)){%>selected<%}%>><%=i%></option>
		 <%}%>
		 </select>	 
	 </td>
     <td width="60" align=right><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></td>
     <td class=field>&nbsp
		<select class=inputstyle  name=hrmid size=1 class=inputstyle   onChange="weaver.submit()">
			 <option value="" <%if(hrmid.equals("")){%>selected<%}%>></option>
		 <%while(RecordSetHrm.next()){%>
			 <option value="<%=RecordSetHrm.getString("hrmid")%>" <%if(RecordSetHrm.getString("hrmid").equals(""+hrmid)){%>selected<%}%>><%=ResourceComInfo.getResourcename(RecordSetHrm.getString("hrmid"))%></option>
		 <%}%>
		 </select>	 
	 </td>
     <TD><%=SystemEnv.getHtmlLabelName(1323,user.getLanguage())%></TD>
     <TD class=Field>
			  <BUTTON class=calendar id=SelectDate onclick=getProjSubDate(enddate01span,enddate01)></BUTTON>&nbsp;
			  <SPAN id=enddate01span ><%=enddate01%></SPAN>
			  <input type="hidden" name="enddate01" value="<%=enddate01%>">
			  －	&nbsp;<BUTTON class=calendar id=SelectDate onclick=getProjSubDate(enddate02span,enddate02)></BUTTON>&nbsp;
			  <SPAN id=enddate02span ><%=enddate02%></SPAN>
			  <input type="hidden" name="enddate02" value="<%=enddate02%>">
		  
	</TD>

  </tr>

</table>
</form>
<TABLE class=liststyle cellspacing=1 >
<TBODY>
  <colgroup>
  <col width="50%">
  <col width="10%">
  <col width="10%">
  <col width="10%">
  <col width="10%">
	    <TR class=Header>
	      <th><%=SystemEnv.getHtmlLabelName(1352,user.getLanguage())%></th>
		  <th><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></th>
		  <th><%=SystemEnv.getHtmlLabelName(1324,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(1323,user.getLanguage())%></th>

	    </TR>
</TBODY>
</TABLE>
<%
boolean isLight = false;
if(RecordSet.first()){
	ProcPara = ProjID + flag + Version;
	RecordSet2.executeProc("Prj_TaskInfo_Sum",ProcPara);
	RecordSet2.next();
%>
<TABLE class=liststyle cellspacing=1 >
<TBODY>
  <colgroup>
  <col width="50%">
  <col width="10%">
  <col width="10%">
  <col width="10%">
  <col width="10%">
	    <TR class=Header>
	      <th>Total</th>
		  <th></th>
		  <th><%=RecordSet2.getString("workday")%></th>
		  <th><%if(!RecordSet2.getString("begindate").equals("x")){%><%=RecordSet2.getString("begindate")%><%}%></th>
		  <th><%if(!RecordSet2.getString("enddate").equals("-")){%><%=RecordSet2.getString("enddate")%>		  <%}%></th>

	    </TR>
		<tr>
		<th class="Line1"></th>
		<th class="Line1"></th>
		<th class="Line1"></th>
		<th class="Line1"></th>
		<th class="Line1"></th>
		</tr>
</TBODY>
</TABLE>
<%
int prelevel=1;
String prerecid="";
do{
%>
	<%if(RecordSet.getInt("level_n")>prelevel){%>
		<%if(RecordSet.getInt("level_n")==Util.getIntValue(level)+1){%>
			<div id="taskdiv<%=prerecid%>" style="DISPLAY: none">
		<%}else{%>
			<div id="taskdiv<%=prerecid%>" style="DISPLAY: ">
		<%}%>
	<%}else if(RecordSet.getInt("level_n")<prelevel){%>
		<%for(int i=1;i<=prelevel-RecordSet.getInt("level_n");i++){%>
			</div>
		<%}%>
	<%}%>
<TABLE class=liststyle cellspacing=1 >
<TBODY>
  <colgroup>
  <col width="50%">
  <col width="10%">
  <col width="10%">
  <col width="10%">
  <col width="10%">
	<TR CLASS=<%if(isLight){%>DataLight<%}else{%>DataDark<%}%>>

          <TD>
				<%for(int i=1;i<RecordSet.getInt("level_n");i++){%>&nbsp&nbsp&nbsp&nbsp<%}%>
			<img <%if(RecordSet.getInt("level_n")==Util.getIntValue(level) && RecordSet.getInt("childnum")>0){%>src="/images/project_rank2_wev8.gif"<%}else{%>src="/images/project_rank1_wev8.gif"<%}%> class="project_rank"  onmouseup='rankclick("taskdiv<%=RecordSet.getString("id")%>")'><a href="#" ><%=RecordSet.getString("subject")%></a></TD>
          <TD><%if(user.getLogintype().equals("1")){%><a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("hrmid")%>"><%if(RecordSet.getString("hrmid").equals(""+user.getUID())){ %><font class=fontred><%}}%><%=ResourceComInfo.getResourcename(RecordSet.getString("hrmid"))%><%if(user.getLogintype().equals("1")){%><%if(RecordSet.getString("hrmid").equals(""+user.getUID())){ %></font></a><%}}%></TD>
          <TD><%=RecordSet.getString("workday")%></TD>
          <TD><%if(!RecordSet.getString("begindate").equals("x")){%><%=RecordSet.getString("begindate")%><%}%></TD>
          <TD><%if(!RecordSet.getString("enddate").equals("-")){%><%=RecordSet.getString("enddate")%>		  <%}%></TD>


    </TR>
</TBODY>
</TABLE>
<%
	isLight = !isLight;
	prelevel = RecordSet.getInt("level_n");
	prerecid = RecordSet.getString("id");
}while(RecordSet.next());
%>
		<%for(int i=1;i<=prelevel-1;i++){%>
			</div>
		<%}%>
<%
}
%>
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
<script language=javascript >
function rankclick(targetId)
{    
  
		var objSrcElement = window.event.srcElement;
    if (document.all(targetId)==null) {

           objSrcElement.src = "/images/project_rank1_wev8.gif";

	} else {
         var targetElement = document.all(targetId);

          if (targetElement.style.display == "none") 
		{
             objSrcElement.src = "/images/project_rank1_wev8.gif";
             targetElement.style.display = "";
		}
            else
		{
             objSrcElement.src = "/images/project_rank2_wev8.gif";
             targetElement.style.display = "none";
		}
	}

}
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
