
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.text.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />


<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

char flag = 2;
String ProcPara = "";
String ProjID = Util.null2String(request.getParameter("ProjID"));

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

String log = Util.null2String(request.getParameter("log"));
String Version = Util.null2String(request.getParameter("version"));
int MaxVersion = 0 ;
RecordSet.executeProc("Prj_TaskInfo_SelectMaxVersion",ProjID);
if(!RecordSet.next()){
	response.sendRedirect("/proj/plan/NewPlan.jsp?log=n&ProjID="+ProjID) ;
}else{
	MaxVersion = RecordSet.getInt("version");
}
if(Version.equals("")){
	Version = ""+MaxVersion;
}
RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
if(RecordSet.getCounts()<=0)
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
RecordSet.first();

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1297,user.getLanguage())+"-"+"<a href='/proj/data/ViewProject.jsp?log="+log+"&ProjID="+RecordSet.getString("id")+"'>"+Util.toScreen(RecordSet.getString("name"),user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";

String sqlwhere="";
sqlwhere=" where prjid = "+ProjID+" and isdelete<>'1' ";

String sqlstr = " SELECT * FROM Prj_TaskProcess " +sqlwhere+ " order by parentids";
RecordSet.executeSql(sqlstr);

String CurrentUser = ""+user.getUID();
int usertype = 0;
if(logintype.equals("2"))
	usertype= 1;

ArrayList taskids=new ArrayList();
ArrayList hrmids=new ArrayList();
ArrayList workdays=new ArrayList();
ArrayList begindates=new ArrayList();
ArrayList enddates=new ArrayList();

sqlwhere=" where prjid = "+ProjID+" and  level_n = '1' and isdelete<>'1' and version='"+Version+"'";
sqlstr = " SELECT * FROM Prj_TaskInfo " +sqlwhere+ " order by parentids";
RecordSetC.executeSql(sqlstr);
while(RecordSetC.next()){
		taskids.add(RecordSetC.getString("taskid"));
		hrmids.add(RecordSetC.getString("hrmid"));
		workdays.add(RecordSetC.getString("workday"));
		begindates.add(RecordSetC.getString("begindate"));
		enddates.add(RecordSetC.getString("enddate"));
}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/proj/report/PlanAndProcess.jsp?log=n&ProjID="+ProjID+",_self} " ;
RCMenuHeight += RCMenuHeightStep;

%>

<DIV>
<form name=weaver method=post action="/proj/report/TaskCompare.jsp">
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

<table class=viewform>
  <tr>
  
     <th width="118" align=left><%=SystemEnv.getHtmlLabelName(15286,user.getLanguage())%></th>
     	    <td>
			<%RCMenu += "{-}";
	 RCMenu += "{"+SystemEnv.getHtmlLabelName(15286,user.getLanguage())+",/proj/report/TaskCompare.jsp?log=n&ProjID="+ProjID+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15287,user.getLanguage())+",/proj/report/TaskNotBegin.jsp?log=n&ProjID="+ProjID+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15288,user.getLanguage())+",/proj/report/TaskDoing.jsp?log=n&ProjID="+ProjID+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15289,user.getLanguage())+",/proj/report/TaskFinish.jsp?log=n&ProjID="+ProjID+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15290,user.getLanguage())+",/proj/report/TaskExNotBegin.jsp?log=n&ProjID="+ProjID+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15291,user.getLanguage())+",/proj/report/TaskExNotFinish.jsp?log=n&ProjID="+ProjID+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
	 
	 %>
			 </td>
  </tr>
    <tr>
  
     <td width="60"><%=SystemEnv.getHtmlLabelName(1333,user.getLanguage())%></td>
     <td class=field>&nbsp
		<select class=inputstyle  name=version size=1 class=inputstyle   onChange="weaver.submit()">
		 <%for(int i=1;i<=MaxVersion;i++){%>
			 <option value="<%=i%>" <%if(Version.equals(""+i)){%>selected<%}%>><%=i%></option>
		 <%}%>
		 </select>
		  
	 </td>
  </tr>
</table>
</form>

<TABLE class=liststyle cellspacing=1 >
<TBODY>
  <colgroup>
  <col width="20%">
  <col width="15%">
  <col width="6%">
  <col width="15%">  
  <col width="10%">
  <col width="15%">
  <col width="15%">

	    <TR class=Header>
	      <th><%=SystemEnv.getHtmlLabelName(1352,user.getLanguage())%></th>
	      <th nowrap colspan=2><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%></th>
		  <th nowrap><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15292,user.getLanguage())%></th>

		  <th nowrap><%=SystemEnv.getHtmlLabelName(1324,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15292,user.getLanguage())%></th>
	      <th nowrap><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15292,user.getLanguage())%></th>
	      <th nowrap><%=SystemEnv.getHtmlLabelName(1323,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15292,user.getLanguage())%></th>
	    </TR>
		<tr class="Line">
		<th ></th>
		<th></th>
		<th ></th>
		<th ></th>
		<th ></th>
		<th ></th>
		</tr>
<%
boolean isLight = false;
if(RecordSet.first()){

do{
	boolean isResponser=false;
	if( RecordSet.getString("parenthrmids").indexOf(","+user.getUID()+"|")!=-1 && user.getLogintype().equals("1") ){
	  isResponser=true;
	}

	String temptaskid="";
	String temphrmid="";
	String tempworkday="0.0";
	String tempbegindate="";
	String tempenddate="";
	for(int i=0;i<taskids.size();i++){
			temptaskid=(String) taskids.get(i);
			if(temptaskid.equals(RecordSet.getString("id"))) {
				temphrmid=(String) hrmids.get(i);
				tempworkday=(String) workdays.get(i);
				tempbegindate=(String) begindates.get(i);
				tempenddate=(String) enddates.get(i);
				break;
			}
	}
%>
	<TR CLASS=<%if(isLight){%>DataLight<%}else{%>DataDark<%}%>>

          <TD>
				<%for(int i=1;i<RecordSet.getInt("level_n");i++){%>&nbsp&nbsp&nbsp&nbsp<%}%>
			<img src="/images/project_rank_wev8.gif"><a href="/proj/process/ViewTask.jsp?taskrecordid=<%=RecordSet.getString("id")%>" ><%=RecordSet.getString("subject")%></a></TD>
          <td height="100%">
            <%if((RecordSet.getString("finish")).equals("0")){%>               
            <%}else{%>
                <TABLE height="100%" cellSpacing=0 
                    <%if(Util.getIntValue(RecordSet.getString("finish"),0)==100){%>
                    class=redgraph 
                    <%}else{%>
                    class=greengraph 
                    <%}%>
                  width="<%=RecordSet.getString("finish")%>%">
                <TBODY>
                <TR>
                  <TD width="100%" height="100%"><img src="/images/ArrowUpGreen_wev8.gif" width=1 height=1></td>
                 </TR>
                 </TBODY>
                 </TABLE>
            <%}%>
              </td>  
                  <td>
                      <%if(Util.getIntValue(RecordSet.getString("finish"),0)==100){%>
                      <font class=fontred><%=Util.getIntValue(RecordSet.getString("finish"),0)%>%</font>
                      <%}else{%>
                      <%=Util.getIntValue(RecordSet.getString("finish"),0)%>%
                      <%}%>
                  </TD>
          <TD nowrap>
				<a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("hrmid")%>" <%if(!RecordSet.getString("hrmid").equals(temphrmid)){%>class=fontred<%}%>><%=ResourceComInfo.getResourcename(RecordSet.getString("hrmid"))%></a> / 
				<a href="/hrm/resource/HrmResource.jsp?id=<%=temphrmid%>" <%if(!RecordSet.getString("hrmid").equals(temphrmid)){%>class=fontred<%}%>><%=ResourceComInfo.getResourcename(temphrmid)%></a>
		  
		  </TD>

			<TD nowrap <%if(RecordSet.getString("workday").compareTo(tempworkday)>0){%>class=fontred<%}%>><%=RecordSet.getString("realManDays")%> / <%=RecordSet.getString("workday")%></TD>
          <TD nowrap <%if(RecordSet.getString("begindate").compareTo(tempbegindate)>0){%>class=fontred<%}%>>
			  <%if(!RecordSet.getString("actualBeginDate").equals("x")){%>
				 	<%=RecordSet.getString("actualBeginDate")%>
			  <%}%> / 
			   <%if(!RecordSet.getString("begindate").equals("x")){%>
				 	<%=RecordSet.getString("begindate")%>
			  <%}%>
		  </TD>
          <TD nowrap <%if(RecordSet.getString("enddate").compareTo(tempenddate)>0){%>class=fontred<%}%>>
			    <%if(!RecordSet.getString("actualEndDate").equals("-")){%>
				  <%=RecordSet.getString("actualEndDate")%>
			  <%}%> /
			<%if(!RecordSet.getString("enddate").equals("-")){%>
				  <%=RecordSet.getString("enddate")%>
			  <%}%>
		  </TD>

    </TR>
<%
	isLight = !isLight;
}while(RecordSet.next());
}
%>
</TBODY>
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

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY>
</HTML>