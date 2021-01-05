
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />


<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
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
String titlename = Util.toScreen("分析报告",user.getLanguage(),"0")+"-"+"<a href='/proj/data/ViewProject.jsp?log="+log+"&ProjID="+RecordSet.getString("id")+"'>"+Util.toScreen(RecordSet.getString("name"),user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>


<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(407,user.getLanguage())+",/proj/plan/ViewPlan.jsp?log=n&ProjID="+ProjID+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1338,user.getLanguage())+",/proj/process/ViewProcess.jsp?log=n&ProjID="+ProjID+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<form name=weaver method=post action="/proj/report/PlanAndProcess.jsp">
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
     <td width="60"><%=SystemEnv.getHtmlLabelName(1333,user.getLanguage())%></td>
     <td class=field width=45>&nbsp
		<select class=inputstyle  name=version size=1 class=inputstyle   onChange="weaver.submit()">
		 <%for(int i=1;i<=MaxVersion;i++){%>
			 <option value="<%=i%>" <%if(Version.equals(""+i)){%>selected<%}%>><%=i%></option>
		 <%}%>
		 </select>	 
	 </td>
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
</table>
</form>

<%
float workday01 = 0;
String begindate01 = "";
String enddate01 = "";
float workday02 = 0;
String begindate02 = "";
String enddate02 = "";
float workday03 = 0;
String begindate03 = "";
String enddate03 = "";
String finish = "0";
float workday04 = 0;
String begindate04 = "";
String enddate04 = "";
float workday05 = 0;
String begindate05 = "";
String enddate05 = "";

ProcPara = ProjID + flag + '1' ;
RecordSet2.executeProc("Prj_TaskInfo_Sum",ProcPara);
if(RecordSet2.next()){
	workday01 = Util.getFloatValue(RecordSet2.getString("workday"),0);
	if(!RecordSet2.getString("begindate").equals("x")) begindate01 = RecordSet2.getString("begindate");
	if(!RecordSet2.getString("enddate").equals("-")) enddate01 = RecordSet2.getString("enddate");
}

ProcPara = ProjID + flag + Version ;
RecordSet2.executeProc("Prj_TaskInfo_Sum",ProcPara);
if(RecordSet2.next()){
	workday02 = Util.getFloatValue(RecordSet2.getString("workday"),0);
	if(!RecordSet2.getString("begindate").equals("x")) begindate02 = RecordSet2.getString("begindate");
	if(!RecordSet2.getString("enddate").equals("-")) enddate02 = RecordSet2.getString("enddate");
}

ProcPara = ProjID;
RecordSet2.executeProc("Prj_TaskProcess_Sum",ProcPara);
if(RecordSet2.next()){
	workday03 = Util.getFloatValue(RecordSet2.getString("workday"),0);
	if(!RecordSet2.getString("begindate").equals("x")) begindate03 = RecordSet2.getString("begindate");
	if(!RecordSet2.getString("enddate").equals("-")) enddate03 = RecordSet2.getString("enddate");
	finish = RecordSet2.getString("finish");
}

SimpleDateFormat sdf= new SimpleDateFormat("yyyy-MM-dd");
Date bd03;
Date ed03;
Date bd01;
Date ed01;
Date bd02;
Date ed02;
if(!begindate03.equals("")){
 bd03=sdf.parse(begindate03);
}else{
 bd03=new Date();
}
if(!enddate03.equals("")){
 ed03=sdf.parse(enddate03);
}else{
 ed03=new Date();
}
if(!begindate02.equals("")){
 bd02=sdf.parse(begindate02);
}else{
 bd02=new Date();
}
if(!enddate02.equals("")){
 ed02=sdf.parse(enddate02);
}else{
 ed02=new Date();
}
if(!begindate01.equals("")){
 bd01=sdf.parse(begindate01);
}else{
 bd01=new Date();
}
if(!enddate01.equals("")){
 ed01=sdf.parse(enddate01);
}else{
 ed01=new Date();
}

workday04 = workday03-workday01;
begindate04 = "" + (bd03.getTime()-bd01.getTime())/(24*3600*1000);
enddate04 = "" + (ed03.getTime()-ed01.getTime())/(24*3600*1000);

workday05 = workday03-workday02;
begindate05 = "" + (bd03.getTime()-bd02.getTime())/(24*3600*1000);
enddate05 =  "" + (ed03.getTime()-ed02.getTime())/(24*3600*1000);
%>
<TABLE class=liststyle cellspacing=1 >
<TBODY>
	    <TR class=Header>
	      <TH align=left><%=SystemEnv.getHtmlLabelName(1354,user.getLanguage())%></th>
		  <TH align=left><%=SystemEnv.getHtmlLabelName(1355,user.getLanguage())%></th>
	      <TH align=left><%=SystemEnv.getHtmlLabelName(1356,user.getLanguage())%></th>
	      <TH align=left><%=SystemEnv.getHtmlLabelName(628,user.getLanguage())%></th>
	      <TH align=left><%=SystemEnv.getHtmlLabelName(1357,user.getLanguage())%></th>
	      <TH align=left><%=SystemEnv.getHtmlLabelName(1358,user.getLanguage())%></th>
	    </TR>
		<tr class="line">
		<th ></th>
		<th ></th>
		<th ></th>
		<th ></th>
		<th ></th>
		<th ></th>
		</tr>
	    <TR class=datalight>
	      <TH align=left><%=SystemEnv.getHtmlLabelName(1324,user.getLanguage())%></TH>
		  <TD><%=workday01%></TD>
		  <TD><%=workday02%></TD>
          <TD><%=workday03%></TD>
			 <%
			 //===========================================================
			 //TD2508
			 //modified by hubo,2006-03-17
			 %>
          <TD><%=Util.getPointValue2(String.valueOf(workday04),1)%></TD>
          <TD><%=Util.getPointValue2(String.valueOf(workday05),1)%></TD>
			 <%//=========================================================%>
	    </TR>
	    <TR class=datadark>
	      <TH align=left><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></TH>
		  <TD><%=begindate01%></TD>
		  <TD><%=begindate02%></TD>
          <TD><%=begindate03%></TD>
		  <TD><%=begindate04%></TD>
          <TD><%=begindate05%></TD>
	    </TR>
	    <TR class=datalight>
	      <TH align=left><%=SystemEnv.getHtmlLabelName(1323,user.getLanguage())%></TH>
		  <TD><%=enddate01%></TD>
		  <TD><%=enddate02%></TD>
          <TD><%=enddate03%></TD>
		  <TD><%=enddate04%></TD>
          <TD><%=enddate05%></TD>
	    </TR>
	    <TR class=datalight>
	      <TH align=left><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%></TH>
		  <TD></TD>
		  <TD></TD>
         <TD height="100%">
         <%
         int finish_0 = (int)(Util.getDoubleValue(RecordSet2.getString("finish")));
         if( finish_0==0){%> 
         0%
         <%}else{%>
          <TABLE height="100%" cellSpacing=0 width="100%">
            <TBODY>
         <TR>
          <TD 
         
          <%        
           
          if(finish.equals("100")){%>
          class=redgraph
          <%}else{%>
          class=greengraph
          <%}%>
          width="<%=finish%>%"></td><td><%=(int)(Util.getDoubleValue(RecordSet2.getString("finish")))%>%</TD>         
          <TD  width="100%" height="100%"><img src="/images/ArrowUpGreen_wev8.gif" width=1 height=1></TD></TR></TBODY></TABLE>
              <%}%>
          
          
         </TD>
		  <TD></TD>
          <TD></TD>
	    </TR>
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
