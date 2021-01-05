<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="weaver.hrm.performance.*" %>
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
<% 
     // if (!Rights.getRights("","","","")){//权限判断
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
<script language="javascript" src="/js/addRowBg.js"></script>
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
String from=Util.null2String(request.getParameter("from"));
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
String type_d=Util.null2String((String)SessionOper.getAttribute(session,"hrm.type_d"));
if (from.equals("list"))
{
type_d=Util.null2String(request.getParameter("type_d")); 
objId=Util.null2String(request.getParameter("objId"));
}
if (rs1.getDBType().equals("oracle"))
rs1.executeSql("select sum(percent_n) from workPlan where objId="+objId+" and cycle='"+type+"' and  planType='"+type_d+"' and planDate='"+planDate+"' and type_n='6' and id!="+id);
else if  (rs1.getDBType().equals("db2"))
rs1.executeSql("select sum(double(percent_n)) from workPlan where objId="+objId+" and cycle='"+type+"' and  planType='"+type_d+"' and planDate='"+planDate+"' and type_n='6' and id!="+id);
else
rs1.executeSql("select sum(convert(float,percent_n)) from workPlan where objId="+objId+" and cycle='"+type+"' and  planType='"+type_d+"' and planDate='"+planDate+"' and type_n='6' and id!="+id);
if (rs1.next())
{
sum=Util.null2o(rs1.getString(1));
}
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
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
String urls="MyPlan.jsp?type="+type;
    if (type.equals("0"))
	{
	String years=planDate.substring(0,4);
	urls=urls+"&years="+years;
	}
	else if (type.equals("2"))
	{
	String years=planDate.substring(0,4);
	String months=planDate.substring(4,planDate.length());
	urls=urls+"&years="+years+"&months="+months;
	}
	else if (type.equals("1"))
	{
	String years=planDate.substring(0,4);
	String quarters=planDate.substring(4,planDate.length());
	urls=urls+"&years="+years+"&quarters="+quarters;
	
	}
	else if (type.equals("3"))
	{
	String years=planDate.substring(0,4);
	String weeks=planDate.substring(4,planDate.length());
	urls=urls+"&years="+years+"&weeks="+weeks;
	
	}
if (from.equals("list"))
{
urls="PlanList.jsp?id="+wp.getGroupId();
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+","+urls+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
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
<input type=hidden name=operationType value="planEdit" >
<input type=hidden name=nodesumd>
<input type=hidden name=from value=<%=from%>>
<input type=hidden name=id value=<%=id%>>
<input type=hidden name=nodesumu>
<input type=hidden name=sum value=<%=sum%>>
<input type=hidden name=planDate value=<%=planDate%> >
<input type=hidden name=groupId value=<%=wp.getGroupId()%> >
<input type=hidden name=type value=<%=type%> >
<input type="hidden" id="rownum" name="rownum">
<input type="hidden" id="rownum1" name="rownum1">
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
            <th style="text-align:right;cursor:hand"><span class="spanSwitch1" onclick="doSwitchx('showobj')"><img src='/images/up.jpg'></span></th>
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
            <%if (wp.getName().equals(""))
            planName=request.getParameter("planName");
            else
            planName=wp.getName();
            %>
              <input class=inputstyle  maxLength=50 size=50 
            name=name value="<%=planName%>" onchange='checkinput("name","nameimage")'>
			<SPAN id=nameimage>
			<%if (planName.equals("")) {%><IMG src='/images/BacoError.gif' align=absMiddle><%}%>
			</SPAN>
            </TD>
          </TR>
        <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR>  
        <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(6071,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle  maxLength=4 size=4 
            name=percent_n  value="<%=wp.getPercent_n()%>" onchange='checknumber("percent_n");checkinput("percent_n","pimage")'>%
			<SPAN id=pimage>
			<%if (wp.getPercent_n().equals("")) {%><IMG src='/images/BacoError.gif' align=absMiddle><%}%>
			</SPAN>
            </TD>
          </TR>
        <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
            <TD class=Field> 
            <%=SystemEnv.getHtmlLabelName(18181,user.getLanguage())%>
              <input class=inputstyle name=type_n type="hidden" value="6">
            </TD>
          </TR>
        <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR>  
        
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18191,user.getLanguage())%></TD>
            <TD class=Field>
           <BUTTON type="button" class=Browser id=SelectTargetID onClick="onShowTarget('oppositeGoal','targetidspan','<%=wp.getCycle()%>','<%=wp.getPlanDate()%>')"></BUTTON> 
           <%rs1.execute("select * from HrmPerformanceGoal where id="+wp.getOppositeGoal());
           %>
            <span 
            id=targetidspan>
            <%if (rs1.next()) {%>
            <a href='/hrm/performance/goal/myGoalView.jsp?id=<%=rs1.getString("id")%>'><%=rs1.getString("goalName")%></a>
            <%}else{%>
             <IMG src='/images/BacoError.gif' align=absMiddle>
             <%}%> 
            </span> 
              <INPUT class=inputStyle id=oppositeGoal 
            type=hidden name=oppositeGoal value="<%=wp.getOppositeGoal()%>">
            </TD>
          </TR>
        <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR>  
         
         <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(6152,user.getLanguage())%></TD>
            <TD class=Field> 
             <%rs1.execute("select * from HrmPerformancePlanKindDetail order by sort");%>
              <select class=inputStyle id=planProperty 
              name=planProperty>
              <option value="0" <%if (wp.getPlanProperty().equals("0")) {%> selected <%}%>> </option>
              <%while (rs1.next()) {%>
                <option value="<%=rs1.getString("id")%>"  <%if (wp.getPlanProperty().equals(rs1.getString("id"))) {%> selected <%}%> ><%=rs1.getString("planName")%></option>
               <%}%></select>
               <!--计划性质-->
      
            </TD>
          </TR>
        <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR>  
        <TR> <%String isRemind = Util.null2String(wp.getIsremind());
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
            <TD><%=SystemEnv.getHtmlLabelName(17478,user.getLanguage())%></TD>
            <TD class=Field> 
               <INPUT type="checkbox" name="isremind" onclick="onNeedRemind()" value="2" <%if (isRemind.equals("2")) {%>checked<%}%> >
				<%if (isRemind.equals("2")) {%>
				<SPAN id="remindspan" class="vis1">&nbsp;&nbsp;
				<%}else{%>
				<SPAN id="remindspan" class="vis2">&nbsp;&nbsp;
				<%}%>
				<INPUT name="waketime" maxlength="10" size="5" onKeyPress="ItemNum_KeyPress()" class="InputStyle" value="<%=remindValue%>">&nbsp;
				<SELECT name="unittype">
				<OPTION value="1" <%if (unitType.equals("1")) {%>selected <%}%>><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></OPTION>
				<OPTION value="2" <%if (unitType.equals("2")) {%>selected <%}%>><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></OPTION>
				</SELECT>
				</SPAN>
            </TD>
          </TR>
        <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR>  
        <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(616,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=user.getLastname()%>
            </TD>
          </TR>
        <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR>  
        <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TD>
            <TD class=Field> 
              <BUTTON type="button" class=Browser style="display:" onClick="onShowMultiHrmResourceNeeded('principal','hrmidspan','true')" name=showresource></BUTTON> 
			  <span 
              id=hrmidspan>
               <%
			  if (!wp.getPrincipal().equals("")) {
				ArrayList hrms = Util.TokenizerString(wp.getPrincipal(),",");
				for (int i = 0; i < hrms.size(); i++) {
				%><A href='/hrm/resource/HrmResource.jsp?id=<%=""+hrms.get(i)%>' target="mainFrame"><%=resourceComInfo.getResourcename(""+hrms.get(i))%></A>&nbsp;
				<%		}
					}
				%>
             </span> 
              <INPUT class=inputStyle id=principal 
            type=hidden name=principal value="<%=wp.getPrincipal()%>">
            </TD>
          </TR>
        <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR>  
        
         <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18188,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(16936,user.getLanguage())%></TD>
            <TD class=Field> 
              <BUTTON type="button" class=Browser style="display:" onClick="onShowMultiHrmResourceNeeded('cowork','coworkidspan','false')" name=showresource></BUTTON> 
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
        <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR>  
        <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18183,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TD>
            <TD class=Field> 
            <!--新增上下游部门/负责人-->
            <input type="hidden" name="upPrincipals" value="<%=wp.getUpPrincipal()%>">
           
            <BUTTON type="button"  class="WorkPlan" type=button accessKey=A onclick="addRow1()"><U>A</U><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
            <BUTTON type="button"  class="WorkPlan"  type=button accessKey=E onclick="deleteRow1()"><U>E</U><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
          
            <table Class=listStyle cols=2 id="oTable1" width="50%">
	      	<COLGROUP> 
	      	<COL width="10%"><COL width="90%">
	      
	    	</table>
            </TD>
          </TR>
        <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR>  
         <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18184,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TD>
            <TD class=Field> 
              <!--新增上下游部门/负责人-->
             <input type="hidden" name="downPrincipals" value="<%=wp.getDownPrincipal()%>">
          
            <BUTTON type="button"  class="WorkPlan" type=button accessKey=Q onclick="addRow2()"><U>Q</U><%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%></BUTTON>
            <BUTTON type="button"  class="WorkPlan" type=button accessKey=W onclick="deleteRow2()"><U>W</U><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
            
            <table Class=listStyle cols=2 id="oTable2" width="50%">
	      	<COLGROUP> 
	      	<COL width="10%"><COL width="90%">
	       
	    	</table>
             
            </TD>
          </TR>
        <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR>  
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18192, user.getLanguage())%></TD>
            <TD class=Field> 
              <textarea class=inputstyle name=teamRequest  rows="5" style="width:98%" ><%=wp.getTeamRequest()%></textarea>
            </TD>
          </TR>
        <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR>  
          <TR>         
	<TD><%=SystemEnv.getHtmlLabelName(18182, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(740, user.getLanguage())%></TD>
	  <TD class="Field"><BUTTON type="button" class="Calendar" id="rSelectBeginDate" onclick="getDate('rbegindatespan','rbegindate')"></BUTTON> 
		  <SPAN id="rbegindatespan">
		  <%=wp.getRbeginDate()%></SPAN> 
		  <INPUT type="hidden" name="rbegindate" value="<%=wp.getRbeginDate()%>">  
		  &nbsp;&nbsp;&nbsp;
		  <%=SystemEnv.getHtmlLabelName(277, user.getLanguage())%><BUTTON type="button" class="Clock" id="rSelectBeginTime" onclick="onShowTime(rbegintimespan,rbegintime)"></BUTTON>
		  <SPAN id="rbegintimespan"><%=wp.getRbeginTime()%></SPAN>
		  <INPUT type="hidden" name="rbegintime" value="<%=wp.getRbeginTime()%>"></TD>
	</TR>
	<TR style="height: 1px;"><TD class="Line" colSpan=2></TD></TR>

	<TR>
	  <TD><%=SystemEnv.getHtmlLabelName(18182, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1035, user.getLanguage())%></TD>
	  <TD class="Field"><BUTTON type="button" class="Calendar" id="rSelectEndDate" onclick="getDate('renddatespan','renddate')"></BUTTON> 
		  <SPAN id="renddatespan"><%=wp.getRendDate()%></SPAN> 
		  <INPUT type="hidden" name="renddate" value=<%=wp.getRendDate()%>>  
		  &nbsp;&nbsp;&nbsp;
		  <%=SystemEnv.getHtmlLabelName(277, user.getLanguage())%><BUTTON type="button" class="Clock" id="rSelectEndTime" onclick="onShowTime(rendtimespan,rendtime)"></BUTTON>
		  <SPAN id="rendtimespan"><%=wp.getRendTime()%></SPAN>
		  <INPUT type="hidden" name="rendtime" value=<%=wp.getRendTime()%>></TD>
	</TR>
	<TR style="height: 1px;"><TD class="Line" colSpan=2></TD></TR>
        <TR>          
	<TD><%=SystemEnv.getHtmlLabelName(740, user.getLanguage())%></TD>
	  <TD class="Field"><BUTTON type="button" class="Calendar" id="SelectBeginDate" onclick="getDate('begindatespan','begindate')"></BUTTON> 
		  <SPAN id="begindatespan">
		    <%=wp.getBegindate()%></SPAN> 
		  <INPUT type="hidden" name="begindate" value="<%=wp.getBegindate()%>">  
		  &nbsp;&nbsp;&nbsp;
		  <%=SystemEnv.getHtmlLabelName(277, user.getLanguage())%><BUTTON type="button" class="Clock" id="SelectBeginTime" onclick="onShowTime(begintimespan,begintime)"></BUTTON>
		  <SPAN id="begintimespan"><%=wp.getBegintime()%></SPAN>
		  <INPUT type="hidden" name="begintime" value="<%=wp.getBegintime()%>"></TD>
	</TR>
	<TR style="height: 1px;"><TD class="Line" colSpan="2"></TD></TR>

	<TR>
	  <TD><%=SystemEnv.getHtmlLabelName(405, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97, user.getLanguage())%></TD>
	  <TD class="Field"><BUTTON type="button" class="Calendar" id="SelectEndDate" onclick="getDate('enddatespan','enddate')"></BUTTON> 
		  <SPAN id="enddatespan"><%=wp.getEnddate()%></SPAN> 
		  <INPUT type="hidden" name="enddate" value="<%=wp.getEnddate()%>">  
		  &nbsp;&nbsp;&nbsp;
		  <%=SystemEnv.getHtmlLabelName(277, user.getLanguage())%><BUTTON type="button" class="Clock" id="SelectEndTime" onclick="onShowTime(endtimespan,endtime)"></BUTTON>
		  <SPAN id="endtimespan"><%=wp.getEndtime()%></SPAN>
		  <INPUT type="hidden" name="endtime" value="<%=wp.getEndtime()%>"></TD>
	</TR>
	<TR style="height: 1px;"><TD class="Line" colSpan=2></TD></TR>
	 <TR>
	  <TD><%=SystemEnv.getHtmlLabelName(783, user.getLanguage())%></TD>
	  <TD class="Field">
		<BUTTON type="button" class="Browser" id="SelectCrm" onclick="onShowMultiCustomer('crmid','crmspan')"></BUTTON>		
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
	<TR style="height: 1px;"><TD class="Line" colSpan=2></TD></TR>
	<TR>
	  <TD><%=SystemEnv.getHtmlLabelName(857, user.getLanguage())%></TD>
	  <TD class="Field"><BUTTON type="button" class="Browser" id="SelectMultiDoc" onclick="onShowMultiDocs('docid','docspan')"></BUTTON>    
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
	<TR style="height: 1px;"><TD class="Line" colSpan=2></TD></TR>
	<TR>
		<TD><%=SystemEnv.getHtmlLabelName(782, user.getLanguage())%></TD>
		 <TD class="Field">
		 <BUTTON type="button" class="Browser" id="SelectMultiProject" onclick="onShowMultiProject('projectid','projectspan')"></BUTTON>      
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
	<TR style="height: 1px;"><TD class="Line" colSpan="2"></TD></TR>
	<TR>
		<TD><%=SystemEnv.getHtmlLabelName(1044, user.getLanguage())%></TD>
		 <TD class="Field">
		 <BUTTON type="button" class="Browser" id="SelectMultiRequest" onclick="onShowMultiRequest('requestid','requestspan')"></BUTTON>      
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
	<TR style="height: 1px;"><TD class="Line" colSpan="2"></TD></TR>
	<TR>
	  <TD><%=SystemEnv.getHtmlLabelName(345, user.getLanguage())%></TD>
	  <TD class="Field"><TEXTAREA class="InputStyle" name="description" rows="5" style="width:98%" ><%=wp.getDescription()%></TEXTAREA>
      </TD>
	</TR>
	<TR style="height: 1px;"><TD class="Line" colSpan=2></TD></TR>
          </TBODY> 
        </TABLE>
        </div>
        <!--基本信息结束  -->
        <!--工作关键点  -->
        <TABLE width="100%" class=ListStyle>
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
       <TABLE width="100%" id="oTable3" class=ListStyle cellspacing=1>
			<thead>
			<TR>
				<td colspan="3">
					<table style="width:100%;border-collapse:collapse;" cellpadding="0">
					<tr>

						<Td align=right>
						<BUTTON type="button" class=btnNew accessKey=A onClick="addRow3();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(551,user.getLanguage())%></BUTTON>
						<BUTTON type="button" class=btnDelete accessKey=D onClick="javascript:deleteRow3();"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
						</Td>
					</tr>
					</table>
				</td>
			</TR>
			</thead>
			<TR><TD style="height:2px;background-color:#A1A1A1" colSpan=3></TD></TR>
			<tbody>
			<tr class=Header>
				 <tH width="5%"></td>
				 
	             <TH width="80%"><%=SystemEnv.getHtmlLabelName(18201,user.getLanguage())%></TH>
	             <TH width="10%"><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TH>
			</tr>
			<TR class=Line><TD colspan="3" ></TD></TR>
			<%  int rowIndex3=0;
			    int rowIndex4=0;
				String bgColor = "";
				
				rsk.executeSql("select * from HrmPerformancePlanKey where planId="+wp.getId()+" order by viewSort" );
				 while (rsk.next())
				      {
					bgColor = (rowIndex3%2)==0 ? "#E7E7E7" : "#F5F5F5";
				%>
				<tr style="background-color:<%=bgColor%>">
				<td><div><input class=inputstyle type='checkbox' name='check_node' value='0'></div></td>
				<td><div><input class=inputstyle style='width:100%' type=text maxlength=50 name='keyName_<%=rowIndex3%>' value="<%=rsk.getString("keyName")%>"></div></td>
				<td><div><input class=inputstyle style='width:100%' type=text  maxlength=3 name='viewSort_<%=rowIndex3%>' value='<%=rsk.getString("viewSort")%>'></div></td>
				</tr>
				<%rowIndex3++;}%>
			</tbody>
			<tbody></tbody>
		</table>
          </div>
        <!--成果要求  -->
        <TABLE width="100%" class=ListStyle>
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
        <TABLE width="100%" id="oTable4" class=ListStyle cellspacing=1>
			<thead>
			<TR>
				<td colspan="3">
					<table style="width:100%;border-collapse:collapse;" cellpadding="0">
					<tr>

						<Td align=right>
						<BUTTON type="button" class=btnNew accessKey=Q onClick="addRow4();"><U>Q</U>-<%=SystemEnv.getHtmlLabelName(551,user.getLanguage())%></BUTTON>
						<BUTTON type="button" class=btnDelete accessKey=W onClick="javascript:deleteRow4();"><U>W</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
						</Td>
					</tr>
					</table>
				</td>
			</TR>
			</thead>
			<TR><TD style="height:2px;background-color:#A1A1A1" colSpan=3></TD></TR>
			<tbody>
			<tr class=Header>
				 <tH width="5%"></td>
				 
	             <TH width="80%"><%=SystemEnv.getHtmlLabelName(18201,user.getLanguage())%></TH>
	             <TH width="10%"><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TH>
			</tr>
			<TR class=Line><TD colspan="3" ></TD></TR>
			  <%
			   bgColor = "";
			 
			  rsc.executeSql("select * from HrmPerformancePlanEffort where planId="+wp.getId()+" order by viewSort");
	          while (rsc.next())
	          {bgColor = (rowIndex4%2)==0 ? "#E7E7E7" : "#F5F5F5";
	          %>
			  <tr style="background-color:<%=bgColor%>">
				<td><div><input class=inputstyle type='checkbox' name='check_node_1' value='0'></div></td>
				<td><div><input class=inputstyle style='width:100%' type=text maxlength=50 name='effortName_<%=rowIndex4%>' value="<%=rsc.getString("effortName")%>"></div></td>
				<td><div><input class=inputstyle style='width:100%' type=text maxlength=3 name='viewSort1_<%=rowIndex4%>' value='<%=rsc.getString("viewSort")%>'></div></td>
				</tr>
				<%
				rowIndex4++;
				}%>
			</tbody>
			<tbody></tbody>
		</table>
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

<SCRIPT language="JavaScript" src="/js/browser/CustomerMultiBrowser_wev8.js"></SCRIPT>
<SCRIPT language="JavaScript" src="/js/browser/DocsMultiBrowser_wev8.js"></SCRIPT>
<SCRIPT language="JavaScript" src="/js/browser/ProjectMultiBrowser_wev8.js"></SCRIPT>
<SCRIPT language="JavaScript" src="/js/browser/RequestMultiBrowser_wev8.js"></SCRIPT>
<SCRIPT language="JavaScript" src="/js/browser/HrmResourceMultiBrowser_wev8.js"></SCRIPT>

<SCRIPT language="JavaScript" src="/js/OrderValidator.js"></SCRIPT>
<SCRIPT language="javascript">
function onShowDepartment(inputname, spanname){
	var inputids=inputname.split("_");
	var inputid=inputids[0];
	var inputid_id=inputids[1];
	var inputnamehrm=inputid+"hrm_"+inputid_id;
	var inputnamehrmspan=inputid+"idspanhrm_"+inputid_id;
	var oldValue=$("input[name="+inputname+"]").val();
	var retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+oldValue);
	
	if(retValue){
		if (retValue.id!= "") {
			$("#"+spanname).html("<A target='_blank' href='/hrm/company/HrmDepartmentDsp.jsp?id="+retValue.id+"'>"+retValue.name+"</A>");
			$("input[name="+inputname+"]").val(retValue.id);
			if(oldValue!=retValue.id){
				$("#"+inputnamehrmspan).html("");
				$("input[name="+inputnamehrm+"]").val("");
			}
		}else{
			$("#"+spanname).html("");
			$("input[name="+inputname+"]").val("");
			$("#"+inputnamehrmspan).html("");
			$("input[name="+inputnamehrm+"]").val("");
		}
	}
	
	
}

function onShowResource(inputname,spanname){
	var o=window.event.srcElement.id
	var os=o.split("_");
	var name=os[0];
	var index1=os[1];
	var heads="";
	if(name=="upPrincipalhrmid"){
		heads="upPrincipal";
	}else{
		heads="downPrincipal";
	}
	heads+="_"+index1;
	var tmpids=$("input[name="+heads+"]").val();
	
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/performance/ResourceBrowser.jsp?departmentId="+tmpids)
	if (datas){
		if (datas[0]!=''){
			$("#"+spanname).html("<A target='_blank' href='/hrm/resource/HrmResource.jsp?id="+datas[0]+"'>"+datas[1]+"</A>");
			$("input[name="+inputname+"]").val(datas[0]);
		}else {
			$("#"+spanname).html("");
			$("input[name="+inputname+"]").val("");
		}
	}
	
}
</SCRIPT>
<SCRIPT language="javascript">
function OnSubmit(){
      
    
    if(check_form(document.resource,"name,percent_n,principal,begindate,rbegindate,oppositeGoal")&&checkall()&&checkp()&&compareDate())
	{	document.getElementById("rownum").value = oTable3.tBodies[1].rows.length - 2;
	    document.getElementById("rownum1").value = oTable4.tBodies[1].rows.length - 2;
		document.resource.submit();
		
		enablemenu();
		//window.frames["rightMenuIframe"].window.event.srcElement.disabled=true;
	}
}
function compareDate()
{
d1=document.resource.begindate.value;
d2=document.resource.enddate.value;
d3=document.resource.rbegindate.value;
d4=document.resource.renddate.value;
if (d1=="") d1="0000-00-00";
if (d2=="") d2="2222-01-01";
if (d3=="") d3="0000-00-00";
if (d4=="") d4="2222-01-01";

if (d1>d2||d3>d4) 
{
alert("<%=SystemEnv.getHtmlLabelName(16721,user.getLanguage())%>");
return false;
}
return true;
}
function checkp()
{
 if ((parseFloat(document.resource.percent_n.value)+parseFloat(document.resource.sum.value))>100) 
	     {
	     alert("<%=SystemEnv.getHtmlLabelName(18196,user.getLanguage())%>"+"<%=SystemEnv.getHtmlLabelName(15223,user.getLanguage())%>"+100);
	     return false;
	     }
	     return true; 
}
function checkall()
{
    document.all("nodesumd").value=document.getElementsByName("check_type2").length;
    document.all("nodesumu").value=document.getElementsByName("check_type").length;
    
    document.all("upPrincipals").value="";
    document.all("downPrincipals").value="";
     for(i=0;i<rowindex1;i++)
    {   
       if ((document.all("upPrincipal_"+i).value!="")&&(document.all("upPrincipalhrm_"+i).value==""))
       {
          alert("<%=SystemEnv.getHtmlLabelName(18193,user.getLanguage())%>");
          document.all("upPrincipals").value="";
          return false;
       }
       if ((document.all("upPrincipal_"+i).value=="")&&(document.all("upPrincipalhrm_"+i).value==""))
       {
          alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>");
          document.all("upPrincipals").value="";
          return false;
       }
       if ((document.all("upPrincipal_"+i).value=="")&&(document.all("upPrincipalhrm_"+i).value!=""))
       {
          alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>");
          document.all("upPrincipals").value="";
          return false;
       }
       document.all("upPrincipals").value=document.all("upPrincipals").value+document.all("upPrincipal_"+i).value+"/"+document.all("upPrincipalhrm_"+i).value+",";
   
    }
      for(j=0;j<rowindex2;j++)
    {
       if ((document.all("downPrincipal_"+j).value!="")&&(document.all("downPrincipalhrm_"+j).value==""))
       {
          alert("<%=SystemEnv.getHtmlLabelName(18193,user.getLanguage())%>");
          document.all("downPrincipals").value="";
          return false;
       }
       if ((document.all("downPrincipal_"+j).value=="")&&(document.all("downPrincipalhrm_"+j).value==""))
       {
          alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>");
          document.all("upPrincipals").value="";
          return false;
       }
       if ((document.all("downPrincipal_"+j).value=="")&&(document.all("downPrincipalhrm_"+j).value!=""))
       {
          alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>");
          document.all("upPrincipals").value="";
          return false;
       }
     document.all("downPrincipals").value=document.all("downPrincipals").value+document.all("downPrincipal_"+j).value+"/"+document.all("downPrincipalhrm_"+j).value+",";  
    }
     
     return true;
}
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
	
	ncol = jQuery('#oTable1').attr("cols");
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
				var sHtml = "<input type='checkbox' name='check_type' value='0'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
			    
				var oDiv = document.createElement("div"); 
				var sHtml = "<BUTTON type='button' id='upPrincipalid_"+rowindex1+"' class=Browser onClick=onShowDepartment('upPrincipal_"+rowindex1+"','upPrincipalidspan_"+rowindex1+"')></BUTTON>" ;
                sHtml=sHtml+"<span id='upPrincipalidspan_"+rowindex1+"'><a href='/hrm/company/HrmDepartmentDsp.jsp?id=<%=du%>'><%=dun%></a></span>"
			    sHtml=sHtml+"<INPUT class=inputStyle id='upPrincipal_"+rowindex1+"' value='<%=du%>'  type=hidden name='upPrincipal_"+rowindex1+"'>";
				sHtml=sHtml+"<BUTTON type='button' id='upPrincipalhrmid_"+rowindex1+"' class=Browser  onClick=onShowResource('upPrincipalhrm_"+rowindex1+"','upPrincipalidspanhrm_"+rowindex1+"')></BUTTON>";
                sHtml=sHtml+"<span id='upPrincipalidspanhrm_"+rowindex1+"'><a href='/hrm/resource/HrmResource.jsp?id=<%=hu%>'><%=hun%></a></span>";
                sHtml=sHtml+"<INPUT class=inputStyle id='upPrincipalhrm_"+rowindex1+"' value='<%=hu%>' type=hidden name='upPrincipalhrm_"+rowindex1+"'>";
				oDiv.innerHTML = sHtml;      
				oCell.appendChild(oDiv);  
				break;
			
			
			
		}
	}
	
	rowindex1 = rowindex1*1 +1;
	
<%}%>
    ncol = jQuery('#oTable2').attr("cols");
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
				var sHtml = "<input type='checkbox' name='check_type2' value='0'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<BUTTON type='button' id='downPrincipalid_"+rowindex2+"' class=Browser onClick=onShowDepartment('downPrincipal_"+rowindex2+"','downPrincipalidspan_"+rowindex2+"')></BUTTON>" ;
                sHtml=sHtml+"<span id='downPrincipalidspan_"+rowindex2+"'><a href='/hrm/company/HrmDepartmentDsp.jsp?id=<%=du1%>'><%=dun1%></a></span>"
			    sHtml=sHtml+"<INPUT class=inputStyle id='downPrincipal_"+rowindex2+"' value='<%=du1%>' type=hidden name='downPrincipal_"+rowindex2+"'>";
				sHtml=sHtml+"<BUTTON type='button' id='downPrincipalhrmid_"+rowindex2+"' class=Browser  onClick=onShowResource('downPrincipalhrm_"+rowindex2+"','downPrincipalidspanhrm_"+rowindex2+"')></BUTTON>";
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
function addRow1()
{	
	ncol = jQuery('#oTable1').attr("cols");
	oRow = oTable1.insertRow();
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
		oCell.style.height=24;
		oCell.style.background= "#efefef";
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_type' value='0'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<BUTTON type='button' id='upPrincipalid_"+rowindex1+"' class=Browser onClick=onShowDepartment('upPrincipal_"+rowindex1+"','upPrincipalidspan_"+rowindex1+"')></BUTTON>" ;
                sHtml=sHtml+"<span id='upPrincipalidspan_"+rowindex1+"'></span>"
			    sHtml=sHtml+"<INPUT class=inputStyle id='upPrincipal_"+rowindex1+"'  type=hidden name='upPrincipal_"+rowindex1+"'>";
				sHtml=sHtml+"<BUTTON type='button' id='upPrincipalhrmid_"+rowindex1+"' class=Browser  onClick=onShowResource('upPrincipalhrm_"+rowindex1+"','upPrincipalidspanhrm_"+rowindex1+"')></BUTTON>";
                sHtml=sHtml+"<span id='upPrincipalidspanhrm_"+rowindex1+"'></span>";
                sHtml=sHtml+"<INPUT class=inputStyle id='upPrincipalhrm_"+rowindex1+"'  type=hidden name='upPrincipalhrm_"+rowindex1+"'>";
				oDiv.innerHTML = sHtml;      
				oCell.appendChild(oDiv);  
				break;
			
			
			
		}
	}
	rowindex1 = rowindex1*1 +1;
	
	
}

function deleteRow1()
  
{   
    if(jQuery("input[name='check_type']:checked").length>0&&window.confirm("<%=SystemEnv.getHtmlLabelName(23069,user.getLanguage())%>?")){
    len = document.forms[0].elements.length;
	for(i=len-1; i >= 0;i--){		
		if(document.forms[0].elements[i].name=='check_type'){
			if(document.forms[0].elements[i].checked==true) {
				delRowIndex = document.forms[0].elements[i].parentNode.parentNode.parentNode.rowIndex;
				oTable1.deleteRow(delRowIndex);
				rowindex1--;
			}
		}
	}
	}
}




function addRow2()
{	
	ncol = jQuery('#oTable2').attr("cols");
	oRow = oTable2.insertRow();
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
		oCell.style.height=24;
		oCell.style.background= "#efefef";
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_type2' value='0'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<BUTTON type='button' id='downPrincipalid_"+rowindex2+"' class=Browser onClick=onShowDepartment('downPrincipal_"+rowindex2+"','downPrincipalidspan_"+rowindex2+"')></BUTTON>" ;
                sHtml=sHtml+"<span id='downPrincipalidspan_"+rowindex2+"'></span>"
			    sHtml=sHtml+"<INPUT class=inputStyle id='downPrincipal_"+rowindex2+"'  type=hidden name='downPrincipal_"+rowindex2+"'>";
				sHtml=sHtml+"<BUTTON type='button' id='downPrincipalhrmid_"+rowindex2+"' class=Browser  onClick=onShowResource('downPrincipalhrm_"+rowindex2+"','downPrincipalidspanhrm_"+rowindex2+"')></BUTTON>";
                sHtml=sHtml+"<span id='downPrincipalidspanhrm_"+rowindex2+"'></span>";
                sHtml=sHtml+"<INPUT class=inputStyle id='downPrincipalhrm_"+rowindex2+"'  type=hidden name='downPrincipalhrm_"+rowindex2+"'>";
				oDiv.innerHTML = sHtml;      
				oCell.appendChild(oDiv);  
				break;
			
			
			
		}
	}
	rowindex2 = rowindex2*1 +1;
}
function deleteRow2()
{
    if(jQuery("input[name='check_type2']:checked").length>0&&window.confirm("<%=SystemEnv.getHtmlLabelName(23069,user.getLanguage())%>?")){
    len = document.forms[0].elements.length;
	for(i=len-1; i >= 0;i--){		
		if(document.forms[0].elements[i].name=='check_type2'){
			if(document.forms[0].elements[i].checked==true) {
				delRowIndex = document.forms[0].elements[i].parentNode.parentNode.parentNode.rowIndex;
				oTable2.deleteRow(delRowIndex);
				rowindex2--;
			}
		}
	}
	}
}

function deldetail(ids,ctype)
{
if (isdel())
{
location.href="PlanOperation.jsp?id="+ids+"&operationType=detaildel&ctype="+ctype+"&type=<%=type%>&planDate=<%=planDate%>";
}
}

var rowColor;
var rowindex3 = <%=rowIndex3%>;
var rowindex4 = <%=rowIndex4%>;
function addRow3(){
	
	rowColor = getRowBg();
	var oTbody = oTable3.tBodies[1];
	var ncol = 3;
	var oRow = oTbody.insertRow();
	var rowindex3 = oRow.rowIndex - 4;
   
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell();
		oCell.style.height = 24;
		oCell.style.background= rowColor;
		switch(j) {
            case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox' name='check_node' value='0'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml =  "<input class=inputstyle style='width:100%' type=text  maxlength=50 name='keyName_"+rowindex3+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle style='width:100%' type=text maxlength=3 name='viewSort_"+rowindex3+"' onkeypress='ItemCount_KeyPress()' >";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
}

function deleteRow3(){
	len = document.forms[0].elements.length;
	for(i=len-1; i >= 0;i--){		
		if(document.forms[0].elements[i].name=='check_node'){
			if(document.forms[0].elements[i].checked==true) {
				delRowIndex = document.forms[0].elements[i].parentNode.parentNode.parentNode.rowIndex;
				oTable3.deleteRow(delRowIndex);
			}
		}
	}
}
function addRow4(){
	
	rowColor = getRowBg();
	var oTbody = oTable4.tBodies[1];
	var ncol = 3;
	var oRow = oTbody.insertRow();
	var rowindex4 = oRow.rowIndex - 4;
   
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell();
		oCell.style.height = 24;
		oCell.style.background= rowColor;
		switch(j) {
            case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox' name='check_node_1' value='0'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml =  "<input class=inputstyle style='width:100%' type=text maxlength=50 name='effortName_"+rowindex4+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle style='width:100%' type=text maxlength=3 name='viewSort1_"+rowindex4+"' onkeypress='ItemCount_KeyPress()' >";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
}

function deleteRow4(){
	len = document.forms[0].elements.length;
	for(i=len-1; i >= 0;i--){		
		if(document.forms[0].elements[i].name=='check_node_1'){
			if(document.forms[0].elements[i].checked==true) {
				delRowIndex = document.forms[0].elements[i].parentNode.parentNode.parentNode.rowIndex;
				oTable4.deleteRow(delRowIndex);
			}
		}
	}
}

function onShowTarget(inputname,spanname,types,pd){
    var cycle="";
    if(types=="0"){
    	cycle="3"
    }else if(types=="1"){
        cycle="1"
    }else if(types=="2"){
         cycle="0"
	}else if(types=="3"){
         cycle="0"
    }  
    var planDate=pd;
    var temp=planDate+"||"+cycle+"-"+types
    var id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/performance/goal/myGoalBrowserForPlan.jsp?temp="+temp);
        if (id1) {
        if (id1.id!="") {
          $("#"+spanname).html(id1.name);
		  $("input[name="+inputname+"]").val(id1.id);
        }else{
          $("#"+spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
		  $("input[name="+inputname+"]").val("");
        }
      }
}
</script>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</BODY>
</HTML>