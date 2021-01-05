<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.performance.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="weaver.hrm.performance.targetplan.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsk" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsc" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ar" class="weaver.general.AutoResult" scope="page" />
<jsp:useBean id="wp" class="weaver.hrm.performance.targetplan.WorkPlan" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="customerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="projectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="requestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="docComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="meetingComInfo" class="weaver.meeting.Maint.MeetingComInfo" scope="page"/>
<jsp:useBean id="exchange" class="weaver.WorkPlan.WorkPlanExchange" scope="page"/>
<jsp:useBean id="ProjectTaskApprovalDetail" class="weaver.proj.Maint.ProjectTaskApprovalDetail" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<% // if (!Rights.getRights("","","","")){//权限判断
	//response.sendRedirect("/notice/noright.jsp") ;
	//return ;
  // }
%>
<HTML><HEAD>
<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<STYLE>
	.vis1	{ visibility:"visible" }
	.vis2	{ visibility:"hidden" }
</STYLE>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<%
//GeneratePro.createAll("workPlan");
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(18181,user.getLanguage());
String type=Util.null2String(request.getParameter("type"));  //周期
String planDate=Util.null2String(request.getParameter("planDate"));  
String needfav ="1";
String needhelp ="";
String sum="0";
String id=Util.null2String(request.getParameter("id"));
String resourceId = String.valueOf(user.getUID());	//默认为当前登录用户
String objId=Util.null2String((String)SessionOper.getAttribute(session,"hrm.objId"));
String planName="";
String percent_n="";
String isremind="";
String waketime="";
String planProperty="";
String oppositeGoal="";
String cowork="";
String principal="";
String upPrincipal="";
String downPrincipal="";
String rteamRequest="";
String begindate="";
String begintime="";
String rBeginDate="";
String rBeginTime="";
String enddate="";
String endtime="";
String rEndTime="";
String rEndDate="";
String docId="";
String projectId="";
String crmId="";
String description="";
String requestId="";

String sqls="select * from workPlan where id="+id;

wp=(WorkPlan)ar.getBean(sqls,wp);

//rs2.executeSql("select * from workPlan where id="+id);
//if (rs2.next())
//{}
int lenu=0;
int lend=0;
ArrayList hrmIds;
ArrayList hrmIdds;
Vector vcdu=new Vector();
Vector vhdu=new Vector();
Vector vcdn=new Vector();
Vector vhdn=new Vector();
String upHrm=wp.getUpPrincipal();
if (!upHrm.equals("")) {
String upHrms="";
String upHrmTemp="";
hrmIds=Util.TokenizerString(upHrm,",");
lenu=hrmIds.size();
for (int j=0;j<hrmIds.size();j++)
	 {
	upHrmTemp=(String)hrmIds.get(j);
	int upL=upHrmTemp.indexOf("/");
	vcdu.add(""+upHrmTemp.substring(0,upL));
	vhdu.add(""+upHrmTemp.substring(upL+1,upHrmTemp.length()));
	}
	}	
String dnHrm=wp.getDownPrincipal();
if (!dnHrm.equals("")) {
String dnHrms="";
String dnHrmTemp="";
hrmIdds=Util.TokenizerString(dnHrm,",");
lend=hrmIdds.size();
for (int j=0;j<hrmIdds.size();j++)
	 {
	dnHrmTemp=(String)hrmIdds.get(j);
	int upL=dnHrmTemp.indexOf("/");
	vcdn.add(""+dnHrmTemp.substring(0,upL));
	vhdn.add(""+dnHrmTemp.substring(upL+1,dnHrmTemp.length()));
	}
	}		
%>
<BODY onload="init()">

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
String from=Util.null2String(request.getParameter("from"));
RCMenu += "{"+SystemEnv.getHtmlLabelName(119,user.getLanguage())+",javascript:doShare(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if (from.equals(""))
{
RCMenu += "{"+SystemEnv.getHtmlLabelName(15033,user.getLanguage())+",javaScript:window.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:window.history.back(-1),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
}
else if (from.equals("2"))
{
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:window.history.go(-2),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
else if (from.equals("1"))
{
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:onGo(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

%>	

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
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

<FORM name=resource id=resource action="PlanOperation.jsp" method=post>

   <TABLE class=ViewForm>
    <COLGROUP> 
    <COL width="50%"> 
    <COL width="50%"> 
    <TBODY> 
  
    <TR> 
      <TD vAlign=top> 
      <TABLE width="100%">
          <COLGROUP> <COL width=90%> <COL width=10%> <TBODY> 
          <TR class=title> 
            <TH><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
            <th style="text-align:right;cursor:hand"><span class="spanSwitch1" onclick="doSwitchx('showobj','<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>')"><img src='/images/up.jpg' style='cursor:hand' title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>"></span></th>
          </TR>
          <TR class=spacing> 
            <TD class=line1 colSpan=2></TD>
          </TR>
          </TBODY></TABLE>
          <!--基本信息-->
         <div id="showobj">
        <TABLE width="100%">
          <COLGROUP> <COL width=10%> <COL width=70%> <TBODY> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=wp.getName()%>
			
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(6071,user.getLanguage())%></TD>
            <TD class=Field> 
            <%=wp.getPercent_n()%>%
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
            <TD class=Field> 
            <%=SystemEnv.getHtmlLabelName(18181,user.getLanguage())%>
              <input class=inputstyle name=type_n type="hidden" value="6">
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18191,user.getLanguage())%></TD>
            <TD class=Field> 
             <%rs1.execute("select * from HrmPerformanceGoal where id="+wp.getOppositeGoal());
           %>
            <span 
            id=targetidspan>
            <%if (rs1.next()) {%>
            <a href='/hrm/performance/goal/myGoalView.jsp?id=<%=rs1.getString("id")%>'><%=rs1.getString("goalName")%></a>
            <%}%>
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
         
         <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(6152,user.getLanguage())%></TD>
            <TD class=Field> 
             <%rs1.execute("select * from HrmPerformancePlanKindDetail order by sort");%>
              <select class=inputStyle id=planProperty 
              name=planProperty disabled>
              <option value="0" <%if (wp.getPlanProperty().equals("0")) {%> selected <%}%>> </option>
              <%while (rs1.next()) {%>
                <option value="<%=rs1.getString("id")%>"  <%if (wp.getPlanProperty().equals(rs1.getString("id"))) {%> selected <%}%> ><%=rs1.getString("planName")%></option>
               <%}%></select>
               <!--计划性质-->
      
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        <%String isRemind = Util.null2String(wp.getIsremind());
	           int wakeTime = Util.getIntValue(wp.getWaketime(), 0);
	           String unitType="1";
	           float remindValue=0;
		        if (isRemind.equals("2") && wakeTime > 0) {
				BigDecimal b1 = new BigDecimal(wakeTime);
		
				if (wakeTime >= 1440) {
					BigDecimal b2 = new BigDecimal("1440");
					remindValue = b1.divide(b2, 1, BigDecimal.ROUND_HALF_UP).floatValue();
					unitType = "2";
				} else {
					BigDecimal b2 = new BigDecimal("60");
					remindValue = b1.divide(b2, 1, BigDecimal.ROUND_HALF_UP).floatValue();
				}
			}
        %>
        <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(17478,user.getLanguage())%></TD>
            <TD class=Field> 
               <INPUT disabled type="checkbox" name="isremind" onclick="onNeedRemind()" value="1" <%if (wp.getIsremind().equals("1")) {%>checked<%}%> >
				<%if (wp.getIsremind().equals("2")) {%>
				<SPAN id="remindspan" class="vis1">&nbsp;&nbsp;
				<%}else{%>
				<SPAN id="remindspan" class="vis2">&nbsp;&nbsp;
				<%}%>
				<INPUT name="waketime" maxlength="10" size="5" onKeyPress="ItemNum_KeyPress()" class="InputStyle" value="<%=wp.getWaketime()%>">&nbsp;
				<SELECT name="unittype" disabled>
				<OPTION value="1" <%if (unitType.equals("1")) {%>selected <%}%>><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></OPTION>
				<OPTION value="2" <%if (unitType.equals("2")) {%>selected <%}%>><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></OPTION>
				</SELECT>
				</SPAN>
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(616,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=user.getLastname()%>
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TD>
            <TD class=Field> 
              
			  <span 
              id=hrmidspan>
              <A href="/hrm/resource/HrmResource.jsp?id=<%=resourceId%>">
		      <%=Util.toScreen(resourceComInfo.getResourcename(wp.getPrincipal()),user.getLanguage())%></A></span> 
              <INPUT class=inputStyle id=principal 
            type=hidden name=principal value="<%=wp.getPrincipal()%>">
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        
         <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18188,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(16936,user.getLanguage())%></TD>
            <TD class=Field> 
               
			  <span 
              id=coworkidspan>
              <%
			if (!wp.getCowork().equals("")) {
				ArrayList hrms = Util.TokenizerString(wp.getCowork(),",");
				for (int i = 0; i < hrms.size(); i++) {
		%><A href='/hrm/resource/HrmResource.jsp?id=<%=""+hrms.get(i)%>' target="mainFrame"><%=resourceComInfo.getResourcename(""+hrms.get(i))%></A>&nbsp;
		<%		}
			}
		%>
              </span> 
              <INPUT class=inputStyle id=cowork 
            type=hidden name=cowork value="<%=wp.getCowork()%>">
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18183,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TD>
            <TD class=Field> 
            <!--新增上下游部门/负责人-->
            <input type="hidden" name="upPrincipals" value="<%=wp.getUpPrincipal()%>">
         
            <table Class=listStyle cols=2 id="oTable1" width="50%">
	      	<COLGROUP> 
	      	<COL width="10%"><COL width="90%">
	      
	    	</table>
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
         <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18184,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TD>
            <TD class=Field> 
              <!--新增上下游部门/负责人-->
             <input type="hidden" name="downPrincipals" value="<%=wp.getDownPrincipal()%>">
           
            <table Class=listStyle cols=2 id="oTable2" width="50%">
	      	<COLGROUP> 
	      	<COL width="10%"><COL width="90%">
	       
	    	</table>
             
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18192, user.getLanguage())%></TD>
            <TD class=Field> 
              <textarea class=inputstyle name=teamRequest  rows="5" style="width:98%"><%=wp.getTeamRequest()%></textarea>
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
          <TR>         
	<TD><%=SystemEnv.getHtmlLabelName(18182, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(740, user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277, user.getLanguage())%></TD>
	  <TD class="Field">
	
		  <SPAN id="rbegindatespan">
		  <%=wp.getRbeginDate()%></SPAN> 
		  <INPUT type="hidden" name="rbegindate" value="<%=wp.getRbeginDate()%>">  
		  &nbsp;&nbsp;&nbsp;
		 
		  <SPAN id="rbegintimespan"><%=wp.getRbeginTime()%></SPAN>
		  <INPUT type="hidden" name="rbegintime" value="<%=wp.getRbeginTime()%>"></TD>
	</TR>
	<TR><TD class="Line" colSpan="2"></TD></TR>

	<TR>
	  <TD><%=SystemEnv.getHtmlLabelName(18182, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1035, user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277, user.getLanguage())%></TD>
	  <TD class="Field">
	  
		  <SPAN id="renddatespan"><%=wp.getRendDate()%></SPAN> 
		  <INPUT type="hidden" name="renddate" value=<%=wp.getRendDate()%>>  
		  &nbsp;&nbsp;&nbsp;
		  
		  <SPAN id="rendtimespan"><%=wp.getRendTime()%></SPAN>
		  <INPUT type="hidden" name="rendtime" value=<%=wp.getRendTime()%>></TD>
	</TR>
	<TR><TD class="Line" colSpan="2"></TD></TR> 
        <TR>          
	<TD><%=SystemEnv.getHtmlLabelName(740, user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277, user.getLanguage())%></TD>
	  <TD class="Field">
	
		  <SPAN id="begindatespan">
		    <%=wp.getBegindate()%></SPAN> 
		  <INPUT type="hidden" name="begindate" value="<%=wp.getBegindate()%>">  
		  &nbsp;&nbsp;&nbsp;
		
		  <SPAN id="begintimespan"><%=wp.getBegintime()%></SPAN>
		  <INPUT type="hidden" name="begintime" value="<%=wp.getBegintime()%>"></TD>
	</TR>
	<TR><TD class="Line" colSpan="2"></TD></TR>

	<TR>
	  <TD><%=SystemEnv.getHtmlLabelName(405, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97, user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277, user.getLanguage())%></TD>
	  <TD class="Field">
	  
		  <SPAN id="enddatespan"><%=wp.getEnddate()%></SPAN> 
		  <INPUT type="hidden" name="enddate" value="<%=wp.getEnddate()%>">  
		  &nbsp;&nbsp;&nbsp;
		
		  <SPAN id="endtimespan"><%=wp.getEndtime()%></SPAN>
		  <INPUT type="hidden" name="endtime" value="<%=wp.getEndtime()%>"></TD>
	</TR>
	<TR><TD class="Line" colSpan="2"></TD></TR> 
	 <TR>
	  <TD><%=SystemEnv.getHtmlLabelName(783, user.getLanguage())%></TD>
	  <TD class="Field">
		
		<SPAN id="crmspan">
		<%
		if (!wp.getCrmid().equals("")) {
			ArrayList crms = Util.TokenizerString(wp.getCrmid(), ",");
			for (int i = 0; i < crms.size(); i++) {
				%><A href='/CRM/data/ViewCustomer.jsp?CustomerID=<%=""+crms.get(i)%>' target="mainFrame"><%=customerInfoComInfo.getCustomerInfoname(""
								+ crms.get(i))%></A>&nbsp;
		<%
			}
		}
		%>
		</SPAN> 
		<INPUT type="hidden" name="crmid" value="<%=wp.getCrmid()%>" >
	  </TD>
	</TR>
	<TR><TD class="Line" colSpan="2"></TD></TR> 
	<TR>
	  <TD><%=SystemEnv.getHtmlLabelName(857, user.getLanguage())%></TD>
	  <TD class="Field">
	   
	  <SPAN id="docspan">
	  <%
		if (!wp.getDocid().equals("")) {
			ArrayList docs = Util.TokenizerString(wp.getDocid(), ",");
			for (int i = 0; i < docs.size(); i++) {
				%><A href='/docs/docs/DocDsp.jsp?id=<%=""+docs.get(i)%>' target="mainFrame"><%=docComInfo.getDocname("" + docs.get(i))%></A>&nbsp;
		<%
			}
		}
		%>
	  </SPAN>
	  <INPUT type="hidden" name="docid" value="<%=wp.getDocid()%>" ></TD>
	</TR>
	<TR><TD class="Line" colSpan="2"></TD></TR> 
	<TR>
		<TD><%=SystemEnv.getHtmlLabelName(782, user.getLanguage())%></TD>
		 <TD class="Field">
		     
		<SPAN id="projectspan"><%
		if (!wp.getProjectid().equals("")) {
			ArrayList projects = Util.TokenizerString(wp.getProjectid(), ",");
			for (int i = 0; i < projects.size(); i++) {
				%><A href='/proj/data/ViewProject.jsp?ProjID=<%=""+projects.get(i)%>' target="mainFrame"><%=projectInfoComInfo.getProjectInfoname(""
								+ projects.get(i))%></A>&nbsp;
		<%
			}
		}
		%></SPAN>
		<INPUT type="hidden" name="projectid" value="<%=wp.getProjectid()%>"></TD>
	</TR>
	<TR><TD class="Line" colSpan="2"></TD></TR>
	<TR>
		<TD><%=SystemEnv.getHtmlLabelName(1044, user.getLanguage())%></TD>
		 <TD class="Field">
		     
		<SPAN id="requestspan"><%
		if (!wp.getRequestid().equals("")) {
			ArrayList requests = Util.TokenizerString(wp.getRequestid(), ",");
			for (int i = 0; i < requests.size(); i++) {
				%><A href="/workflow/request/ViewRequest.jsp?requestid=<%=requests.get(i)%>" target="mainFrame"><%=requestComInfo.getRequestname("" + requests.get(i))%></A>&nbsp;
		<%
			}
		}
		%></SPAN>
		<INPUT type="hidden" name="requestid" value="<%=wp.getRequestid()%>" ></TD>
	</TR>
	<TR><TD class="Line" colSpan="2"></TD></TR>
	<TR>
	  <TD><%=SystemEnv.getHtmlLabelName(345, user.getLanguage())%></TD>
	  <TD class="Field"><TEXTAREA class="InputStyle" name="description" rows="5" style="width:98%" ><%=wp.getDescription()%></TEXTAREA>
      </TD>
	</TR>
	<TR><TD class="Line" colSpan="2"></TD></TR> 
          </TBODY> 
        </TABLE>
        </div>
        <!--基本信息结束  -->
        <!--工作关键点  -->
        <TABLE width="100%">
          <COLGROUP> <COL width=90%> <COL width=10%> <TBODY> 
          <TR class=title> 
            <TH><%=SystemEnv.getHtmlLabelName(18200,user.getLanguage())%></TH>
            <th style="text-align:right;cursor:hand"><span class="spanSwitch1" onclick="doSwitchx('showobjk','<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>')"><img src='/images/up.jpg' style='cursor:hand' title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>"></span></th>
          </TR>
          <TR class=spacing> 
            <TD class=line1 colSpan=2></TD>
          </TR>
          </TBODY></TABLE>
          <div id=showobjk>
        <TABLE width="100%" class=liststyle>
          <COLGROUP> <COL width=5%> <COL width=80%> <COL width=5%> <COL width=10%>  <TBODY> 
          <TR class=header> 
            <TH>ID</TH>
            <TH><%=SystemEnv.getHtmlLabelName(18201,user.getLanguage())%></TH>
            <TH><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TH>
            <TH>
    
            </TH>
          </TR>
          <TR class=spacing> 
            <TD class=line1 colSpan=4></TD>
          </TR>
          <%boolean isLight = false;
           int i=1;
          rsk.executeSql("select * from HrmPerformancePlanKey where planId="+wp.getId()+" order by viewSort" );
          while (rsk.next())
          {
           if(isLight = !isLight)
				{%>	
				<TR CLASS=DataLight>
			<%		}else{%>
				<TR CLASS=DataDark>
			<%		}%>
            <Td><%=i%></Td>
            <Td><a href="PlanKeyView.jsp?did=<%=rsk.getString("id")%>&id=<%=wp.getId()%>&type=<%=type%>&planDate=<%=planDate%>"><%=Util.toScreen(rsk.getString("keyName"),user.getLanguage())%></a></Td>
            <Td><%=Util.toScreen(rsk.getString("viewSort"),user.getLanguage())%></Td>
            <Td>
        
            </Td>
          </TR>
          <%i++;}
          %>
          </TBODY></TABLE>  
          </div>
        <!--成果要求  -->
        <TABLE width="100%">
          <COLGROUP> <COL width=90%> <COL width=10%> <TBODY> 
          <TR class=title> 
            <TH><%=SystemEnv.getHtmlLabelName(18202,user.getLanguage())%></TH>
            <th style="text-align:right;cursor:hand"><span class="spanSwitch1" onclick="doSwitchx('showobja','<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>')"><img src='/images/up.jpg' style='cursor:hand' title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>"></span></th>
          </TR>
          <TR class=spacing> 
            <TD class=line1 colSpan=2></TD>
          </TR>
          </TBODY></TABLE>
          <div id=showobja>
        <TABLE width="100%" class=liststyle>
          <COLGROUP> <COL width=5%> <COL width=80%> <COL width=5%> <COL width=10%>  <TBODY> 
          <TR class=header> 
            <TH>ID</TH>
            <TH><%=SystemEnv.getHtmlLabelName(18201,user.getLanguage())%></TH>
            <TH><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TH>
            <TH>

            </TH>
          </TR>
          <TR class=spacing> 
            <TD class=line1 colSpan=4></TD>
          </TR>
          <%
          i=1;
          rsc.executeSql("select * from HrmPerformancePlanEffort where planId="+wp.getId()+" order by viewSort");
          while (rsc.next())
          {
           if(isLight = !isLight)
				{%>	
				<TR CLASS=DataLight>
			<%		}else{%>
				<TR CLASS=DataDark>
			<%		}%> 
            <Td><%=i%></Td>
            <Td><a href="PlanEffortView.jsp?did=<%=rsc.getString("id")%>&id=<%=wp.getId()%>&type=<%=type%>&planDate=<%=planDate%>"><%=Util.toScreen(rsc.getString("effortName"),user.getLanguage())%></a></Td>
            <Td><%=Util.toScreen(rsc.getString("viewSort"),user.getLanguage())%></Td>
            <Td>

            </Td>
          </TR>
          <%i++;}
          %>
          </TBODY></TABLE>  
          </div>    
      </TD>
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

<SCRIPT language="javascript">

function onNeedRemind() {
	if (document.all("isremind").checked) 
        document.all("remindspan").className = "vis1";
    else 
        document.all("remindspan").className = "vis2";
}
 

rowindex1 = 0 ;
rowindex2 = 0 ;
function init()
{
	
	ncol = oTable1.cols;
	<% 
	int l1=lenu;
	int k=0;
	String du="";
	String hu="";
	String dun="";
	String hun="";
	for (k=0;k<l1;k++)
	{ du=""+vcdu.get(k);
	  hu=""+vhdu.get(k);
	  dun=DepartmentComInfo.getDepartmentname(du);
	  hun=resourceComInfo.getLastname(hu);
	%>
	oRow = oTable1.insertRow();
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
		oCell.style.height=24;
		oCell.style.background= "#efefef";
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = ""; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
			    
				var oDiv = document.createElement("div"); 
				var sHtml = "" ;
                sHtml=sHtml+"<span id='upPrincipalidspan_"+rowindex1+"'><a href='/hrm/company/HrmDepartmentDsp.jsp?id=<%=du%>'><%=dun%></a></span> "
			    sHtml=sHtml+"<INPUT class=inputStyle id='upPrincipal_"+rowindex1+"' value='<%=du%>'  type=hidden name='upPrincipal_"+rowindex1+"'>";
				sHtml=sHtml+"";
                sHtml=sHtml+"<span id='upPrincipalidspanhrm_"+rowindex1+"'><a href='/hrm/resource/HrmResource.jsp?id=<%=hu%>'><%=hun%></a></span>";
                sHtml=sHtml+"<INPUT class=inputStyle id='upPrincipalhrm_"+rowindex1+"' value='<%=hu%>' type=hidden name='upPrincipalhrm_"+rowindex1+"'>";
				oDiv.innerHTML = sHtml;      
				oCell.appendChild(oDiv);  
				break;
			
			
			
		}
	}
	
	rowindex1 = rowindex1*1 +1;
	
<%}%>
    ncol = oTable2.cols;
    <% 
	int l11=lend;
	int k1=0;
	String du1="";
	String hu1="";
	String dun1="";
	String hun1="";
	for (k1=0;k1<l11;k1++)
	{ du1=""+vcdn.get(k1);
	  hu1=""+vhdn.get(k1);
	  dun1=DepartmentComInfo.getDepartmentname(du1);
	  hun1=resourceComInfo.getLastname(hu1);
	%>
	oRow = oTable2.insertRow();
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
		oCell.style.height=24;
		oCell.style.background= "#efefef";
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = ""; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "" ;
                sHtml=sHtml+"<span id='downPrincipalidspan_"+rowindex2+"'><a href='/hrm/company/HrmDepartmentDsp.jsp?id=<%=du1%>'><%=dun1%></a></span> "
			    sHtml=sHtml+"<INPUT class=inputStyle id='downPrincipal_"+rowindex2+"' value='<%=du1%>' type=hidden name='downPrincipal_"+rowindex2+"'>";
				sHtml=sHtml+"";
                sHtml=sHtml+"<span id='downPrincipalidspanhrm_"+rowindex2+"'><a href='/hrm/resource/HrmResource.jsp?id=<%=hu1%>'><%=hun1%></a></span>";
                sHtml=sHtml+"<INPUT class=inputStyle id='downPrincipalhrm_"+rowindex2+"'  value='<%=hu1%>' type=hidden name='downPrincipalhrm_"+rowindex2+"'>";
				oDiv.innerHTML = sHtml;      
				oCell.appendChild(oDiv);  
				break;
			
			
			
		}
	}
	rowindex2 = rowindex2*1 +1;
	<%}%>
	
	
}
function  onGo()
{
location.href="/workplan/data/WorkPlanView.jsp";
}
function doShare() {
	document.resource.action = "/workplan/share/WorkPlanShare.jsp?planid=<%=id%>";
	document.resource.submit();
	enablemenu();
}
</script>
</BODY>
</HTML
>