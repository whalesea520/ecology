
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.performance.*" %>
<%@ page import="weaver.hrm.performance.targetplan.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="weaver.Constants" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="ar" class="weaver.general.AutoResult" scope="page" />
<jsp:useBean id="wp" class="weaver.hrm.performance.targetplan.PlanModul" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsk" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsc" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="customerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="projectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="requestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="docComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="meetingComInfo" class="weaver.meeting.Maint.MeetingComInfo" scope="page"/>
<jsp:useBean id="exchange" class="weaver.WorkPlan.WorkPlanExchange" scope="page"/>
<jsp:useBean id="ProjectTaskApprovalDetail" class="weaver.proj.Maint.ProjectTaskApprovalDetail" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="resource" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%@ page import="net.sf.json.JSONArray,net.sf.json.JSONObject"%>
<jsp:useBean id="WorkPlanSetInfo"	class="weaver.WorkPlan.WorkPlanSetInfo" scope="page" />

<HTML>
<HEAD>
	<STYLE>
		.SectionHeader 
		{
			FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
		}
	</STYLE>
	<STYLE>
		.vis1	{ visibility:visible }
		.vis2	{ visibility:hidden }
		.vis3   { display:inline}
		.vis4   { display:none }
	</STYLE>
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css"
			type="text/css" />
		<link rel="stylesheet"
			href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
		<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css"
			type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<script language="javascript" src="/js/addRowBg_wev8.js"></script>
	
<link type="text/css" href="/js/tabs/css/e8tabs_wev8.css" rel="stylesheet" />
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script src="/js/tabs/jquery.tabs_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
</HEAD>

<%
	int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);  
	String target = Util.null2String(request.getParameter("target"));

	String imagefilename = "/images/hdMaintenance_wev8.gif";
	
	String id=Util.null2String(request.getParameter("id"));
	if("".equals(id))
	{
	    id = "-1";
	}
	
	String type_n = "";  //类型 目标计划：6  工作安排：0
	
	String needfav ="1";
	String needhelp ="";
	String urgentLevel="";
	String resourceId = String.valueOf(user.getUID());	//默认为当前登录用户
	String objId=""+user.getUID();
	String type_d="3";
	String type="";
	int wakeTime = 0;
	String unitType = "1";
	String isRemind="";
	float remindValue = 0;
	String planName=user.getLastname()+SystemEnv.getHtmlLabelName(83515,user.getLanguage());
	String sqls="SELECT * from HrmPerformancePlanModul where id="+id;
	String titlename="";
	String flag="0";
	
	String workPlanTypeID = "";
	String remindType = "";
	remindType="workplan".equals(target)?WorkPlanSetInfo.getDefaultRemider()+"":"";
	String remindBeforeStart = "";//是否开始前提醒
	String remindBeforeEnd = "";//是否结束前提醒
	
	String createType = "";
	String workPlanCreateTime = "";
	String frequency = "";
	String frequencyy = "";
	String availableBeginDate = "";
	String availableEndDate = "";
	String persistentType = "";
	String persistentTimes = "";
	String timeModul = "";
	int remindDateBeforeStart = 0;//开始前提醒小时
	int remindTimeBeforeStart = 0;//开始前提醒分钟
	
    int remindDateBeforeEnd = 0;//结束前提醒小时
	int remindTimeBeforeEnd = 10;//结束前提醒分钟
	
	String remindTimesBeforeStart = ""; // 开始前提醒分钟数
	String remindTimesBeforeEnd = ""; // 结束前提醒分钟数
	int immediatetouch = 0;
	
	rs1.executeSql(sqls);
	if(rs1.next())
	{
		type_n = Util.null2String(rs1.getString("type_n"));
	    workPlanTypeID = Util.null2String(String.valueOf(rs1.getInt("workPlanTypeID")));
	    remindType = Util.null2String(rs1.getString("remindType"));
	    remindBeforeStart = Util.null2String(rs1.getString("remindBeforeStart"));
	    remindTimesBeforeStart = Util.null2String(rs1.getString("remindTimesBeforeStart"));
	    remindBeforeEnd = Util.null2String(rs1.getString("remindBeforeEnd"));
	    remindTimesBeforeEnd = Util.null2String(rs1.getString("remindTimesBeforeEnd"));
	    createType = Util.null2String(rs1.getString("createType"));
	    workPlanCreateTime = Util.null2String(rs1.getString("workPlanCreateTime"));
	    frequency = Util.null2String(String.valueOf(rs1.getInt("frequency")));
	    frequencyy = Util.null2String(String.valueOf(rs1.getInt("frequencyy")));
	    availableBeginDate = Util.null2String(rs1.getString("availableBeginDate"));
		availableEndDate = Util.null2String(rs1.getString("availableEndDate"));
		persistentType = Util.null2String(rs1.getString("persistentType"));
		persistentTimes = Util.null2String(rs1.getString("persistentTimes"));
		timeModul = Util.null2String(rs1.getString("timeModul"));
		immediatetouch = rs1.getInt("immediatetouch");
		
	}
	
	if("1".equals(remindBeforeStart))
	{	
		remindDateBeforeStart=Util.getIntValue(remindTimesBeforeStart,0)/60;
		remindTimeBeforeStart=Util.getIntValue(remindTimesBeforeStart,0)%60;
	}
	if("1".equals(remindBeforeEnd))
	{	
		remindDateBeforeEnd=Util.getIntValue(remindTimesBeforeEnd,0)/60;
		remindTimeBeforeEnd=Util.getIntValue(remindTimesBeforeEnd,0)%60;
	}
	if (ar.getResult(sqls))
	{
	    flag="1";
		titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(18220,user.getLanguage());
		wp=(PlanModul)ar.getBean(sqls,wp);
		type=wp.getCycle();
		urgentLevel=wp.getUrgentLevel();
		isRemind = Util.null2String(wp.getIsremind());
		wakeTime = Util.getIntValue(wp.getWaketime(), 0);
		
		if (isRemind.equals("2") && wakeTime > 0) 
		{
			BigDecimal b1 = new BigDecimal(wakeTime);
		
			if (wakeTime >= 1440) 
			{
				BigDecimal b2 = new BigDecimal("1440");
				remindValue = b1.divide(b2, 1, BigDecimal.ROUND_HALF_UP).floatValue();
				unitType = "2";
			} 
			else 
			{
				BigDecimal b2 = new BigDecimal("60");
				remindValue = b1.divide(b2, 1, BigDecimal.ROUND_HALF_UP).floatValue();
			}
		}		
	}
	else
	{
		titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(18220,user.getLanguage());
		wp.setId("0");
		wp.setPrincipal(objId);
	}
	
	if (!Util.null2String(wp.getName()).equals(""))
	{
	   planName=Util.null2String(wp.getName());
	}
	
	int rowIndex = 0;
	int rowIndex1 = 0;

	String navName = "";
	String mouldID = "";
	if(target.equalsIgnoreCase("workplan")){
		mouldID = "schedule";
		navName = SystemEnv.getHtmlLabelName(18220,user.getLanguage());
	}
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(),_self}";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btn_cancle(),_self}";
	RCMenuHeight += RCMenuHeightStep;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<BODY style="overflow: hidden;">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="<%=mouldID %>"/>
   <jsp:param name="navName" value="<%=navName%>"/>
</jsp:include>
<DIV id="divSave" style="display:none;position:absolute; visibility:show;right:0px;top:0px;padding:1px;background:#ffffff;border:1px solid #EEEEEE;width:160px;color:#666666;z-index:9999 ;filter:alpha(opacity=80);">
	<TABLE>
		<TR>
			<TD>
				<IMG src="/images/loading2_wev8.gif">
			</TD>
			<TD>
				<%= SystemEnv.getHtmlLabelName(19611,user.getLanguage()) %>
			</TD>
		</TR>
	</TABLE>
</DIV>

<div class="zDialog_div_content" style="overflow-y: auto;position: relative;">

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	   <td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button"
				value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"
				class="e8_btn_top middle" onclick="OnSubmit()">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<FORM name=resource id=resource action="PlanModulOperation.jsp" method=post>
	<INPUT type=hidden name=operationType value="planAdd" >
	<INPUT type=hidden name=pName value=<%=planName%> >
	<INPUT type=hidden name=id value=<%=Util.null2String(wp.getId())%> >
	<INPUT type=hidden name=type_n value=<% if("workplan".equals(target) || Util.null2String(wp.getType_n()).equals("0")) {%>0<% } else { %>6<% } %> >
	<INPUT type="hidden" id="rownum" name="rownum">
	<INPUT type="hidden" id="rownum1" name="rownum1">
	
	<!--================== 基本信息标题 ==================-->
		<wea:layout type="2col">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>' >
				<wea:item>
			<!--================== 标题 ==================-->
				<%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%>
				</wea:item>
				<wea:item>      
					<INPUT class=inputstyle  maxLength=50 size=50 name=name value="<%=planName%>" onchange='checkinput("name","nameimage")'>
					<SPAN id=nameimage></SPAN>
				</wea:item>
			
			<!--================== 类型 ==================-->
				<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
				<wea:item>
				<%
					if("workplan".equals(target) || Util.null2String(wp.getType_n()).equals("0"))
					//从日程进入(工作安排)
					{
						rs2.executeSql("SELECT * FROM WorkPlanType" + Constants.WorkPlan_Type_Query_By_Menu);
				%>
					<SELECT name="workPlanType">
					<%
						while(rs2.next())
						{
							String workPlanTypeIDOption = String.valueOf(rs2.getInt("workPlanTypeID"));
					%>
						<OPTION value=<%= workPlanTypeIDOption %> <% if(workPlanTypeID.equals(workPlanTypeIDOption)) { %> selected <% } %>><%= Util.forHtml(rs2.getString("workPlanTypeName")) %></OPTION>
					<%										  					
						}
					%>
					</SELECT>
				<%
					}
					else
					//目标绩效
					{
				%>
						<%= SystemEnv.getHtmlLabelName(18181,user.getLanguage()) %>												
				<%
					}
				%>													
				</wea:item>
			<!--================== 性质 ==================-->
				<wea:item><%=SystemEnv.getHtmlLabelName(6152,user.getLanguage())%></wea:item>
				<wea:item>
				<%
					if("workplan".equals(target) || Util.null2String(wp.getType_n()).equals("0"))
					//从日程进入(工作安排)
					{
				%>										            	
					<!--================== 工作安排性质 ==================-->									            	
					<SPAN id="property_0">
						<INPUT type="radio" value="1" name="urgentlevel" <%if (urgentLevel.equals("1")||urgentLevel.equals("")) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%>
						&nbsp;&nbsp;
						<INPUT type="radio" value="2" name="urgentlevel" <%if (urgentLevel.equals("2")) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
						&nbsp;&nbsp;
						<INPUT type="radio" value="3" name="urgentlevel" <%if (urgentLevel.equals("3")) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>
					</SPAN>
				<%
					}
					else
					{
				%>
					<!--================== 目标计划性质 ==================-->
					<SPAN id="property_6">
				<%
						rs1.execute("SELECT * from HrmPerformancePlanKindDetail order by sort");
				%>
						<SELECT class=inputStyle id=planProperty name=planProperty>
				<%
						while (rs1.next()) 
						{
				%>
							<OPTION value="<%=rs1.getString("id")%>"  <%if (Util.null2String(wp.getName()).equals(rs1.getString("id"))) {%>selected<%}%>><%=rs1.getString("planName")%></OPTION>
				<%
						}
				%>
						</SELECT>								               
					</SPAN>
				<%
					}
				%>
				</wea:item>
			<!--================== 内容 ==================-->
				<wea:item><%=SystemEnv.getHtmlLabelName(345, user.getLanguage())%></wea:item>
				<wea:item>
					<TEXTAREA class="InputStyle" name="description" rows="5" style="width:90%" ><%=Util.convertDB2Input(Util.null2String(wp.getDescription()))%></TEXTAREA>
				</wea:item>
			<!--================== 提交人 ==================-->
				<wea:item><%=SystemEnv.getHtmlLabelName(616,user.getLanguage())%></wea:item>
				<wea:item>
					<%=user.getLastname()%>
				</wea:item>
			<!--================== 负责人 ==================-->
				<wea:item><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></wea:item>
				<wea:item>
					<%
						String principalNames="";
						if (!Util.null2String(wp.getPrincipal()).equals("")) 
						{
							ArrayList hrms = Util.TokenizerString(Util.null2String(wp.getPrincipal()),",");
							for (int i = 0; i < hrms.size(); i++) 
							{
								//principalNames+="<A href='/hrm/resource/HrmResource.jsp?id="+hrms.get(i)+"' target='_blank'>"+resourceComInfo.getResourcename(""+hrms.get(i))+"</A>&nbsp;";
								principalNames+=resourceComInfo.getResourcename(""+hrms.get(i))+",";
							}
						}
					%>
					<brow:browser viewType="0" name="principal" browserValue='<%=(!"".equals(principalNames))?wp.getPrincipal():""+user.getUID()%>' temptitle='<%=SystemEnv.getHtmlLabelName(17689,user.getLanguage())%>' 
					browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" 
					hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="300px"
					completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
					browserSpanValue='<%=(!"".equals(principalNames))?principalNames:user.getLastname()%>'></brow:browser>
				</wea:item>
				<%if(!"workplan".equals(target) || WorkPlanSetInfo.getShowRemider()==1){ %>
			<!--================ 日程提醒方式  ================-->
				<wea:item><%=SystemEnv.getHtmlLabelName(19781,user.getLanguage())%></wea:item>
				<wea:item>
					<INPUT type="radio" value="1" name="remindType" onclick=showRemindTime(this) <%if(null!=remindType&&"1".equals(remindType)){ %>checked<%}else if(null==remindType||"".equals(remindType)){%>checked<%} %>><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
					<INPUT type="radio" value="2" name="remindType" onclick=showRemindTime(this) <%if(null!=remindType&&"2".equals(remindType)){ %>checked<%} %>><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%>
					<INPUT type="radio" value="3" name="remindType" onclick=showRemindTime(this) <%if(null!=remindType&&"3".equals(remindType)){ %>checked<%} %>><%=SystemEnv.getHtmlLabelName(18845,user.getLanguage())%>
				</wea:item>
				<%}else{%>
					<!-- 不开启提醒,默认不提醒 -->
				<wea:item attributes="{'display':'none','samePair':'ShowRemider'}"><%=SystemEnv.getHtmlLabelName(19781,user.getLanguage())%></wea:item>
				<wea:item attributes="{'display':'none','samePair':'ShowRemider'}">
					<INPUT type="radio" value="1" name="remindType" onclick=showRemindTime(this) checked><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
					<INPUT type="radio" value="2" name="remindType" onclick=showRemindTime(this)><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%>
					<INPUT type="radio" value="3" name="remindType" onclick=showRemindTime(this)><%=SystemEnv.getHtmlLabelName(18845,user.getLanguage())%>
				</wea:item>	
					
				<%} %>
			<!--================ 日程提醒时间  ================-->
				<wea:item attributes="{'samePair':'remindtime'}"><%=SystemEnv.getHtmlLabelName(19783,user.getLanguage())%></wea:item>
				<wea:item attributes="{'samePair':'remindtime'}">
					<INPUT type="checkbox" id="remindBeforeStart" name="remindBeforeStart" value="1" <%if(null!=remindBeforeStart&&"1".equals(remindBeforeStart)){ %>checked<%} %>>
						<%=SystemEnv.getHtmlLabelName(19784,user.getLanguage())%>
						<INPUT class="InputStyle" type="input" id="remindDateBeforeStart" name="remindDateBeforeStart"  onchange="checkint('remindDateBeforeStart')" size=5 value="<%=remindDateBeforeStart %>" style="width:30px!important">
						<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
						<INPUT class="InputStyle" type="input" id="remindTimeBeforeStart" name="remindTimeBeforeStart" onchange="checkint('remindTimeBeforeStart')" size=5 value="<%=remindTimeBeforeStart %>" style="width:30px!important">
						<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
					&nbsp&nbsp&nbsp
					<INPUT type="checkbox" id="remindBeforeEnd" name="remindBeforeEnd" value="1" <%if(null!=remindBeforeEnd&&"1".equals(remindBeforeEnd)){ %>checked<%} %>>
						<%=SystemEnv.getHtmlLabelName(19785,user.getLanguage())%>
						<INPUT class="InputStyle" type="input" id="remindDateBeforeEnd" name="remindDateBeforeEnd" onchange="checkint('remindDateBeforeEnd')" size=5 value="<%=remindDateBeforeEnd %>" style="width:30px!important">
						<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
						<INPUT class="InputStyle" type="input" id="remindTimeBeforeEnd" name="remindTimeBeforeEnd" onchange="checkint('remindTimeBeforeEnd')"  size=5 value="<%=remindTimeBeforeEnd %>" style="width:30px!important">
						<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
				</wea:item>
			<%if(!"workplan".equals(target) || WorkPlanSetInfo.getInfoCrm()==1){%>
			<!--================== 相关客户 ==================-->
				<wea:item><%=SystemEnv.getHtmlLabelName(783, user.getLanguage())%></wea:item>
				<wea:item>
						<%
					String crmNames="";
						if (!Util.null2String(wp.getCrmid()).equals("")) 
						{
							ArrayList crms = Util.TokenizerString(Util.null2String(wp.getCrmid()), ",");
							for (int i = 0; i < crms.size(); i++) 
							{
							//crmNames+="<A  href='/CRM/data/ViewCustomer.jsp?CustomerID="+crms.get(i)+"' target='_blank'>"
							//		+customerInfoComInfo.getCustomerInfoname(""+crms.get(i))+"</a>&nbsp;";
							crmNames+= customerInfoComInfo.getCustomerInfoname(""+crms.get(i))+",";
						}
					}
				%>
				<brow:browser viewType="0" name="crmid" browserValue='<%=Util.null2String(wp.getCrmid())%>' 
				browserOnClick="" browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="%>'
				hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1' width="300px"
				completeUrl="/data.jsp?type=18" linkUrl="/CRM/data/ViewCustomer.jsp?CustomerID=#id#&id=#id#" 
				browserSpanValue='<%=crmNames%>'></brow:browser>
				</wea:item>
			<%}%>
			<%if(!"workplan".equals(target) || WorkPlanSetInfo.getInfoDoc()==1){%>
			<!--================== 相关文档 ==================-->
				<wea:item><%=SystemEnv.getHtmlLabelName(857, user.getLanguage())%></wea:item>
				<wea:item>
					
					<%
					String docNames="";
					if (!Util.null2String(wp.getDocid()).equals("")) 
					{
						ArrayList docs = Util.TokenizerString(Util.null2String(wp.getDocid()), ",");
						for (int i = 0; i < docs.size(); i++) 
						{
						//docNames+="<A  href='/docs/docs/DocDsp.jsp?id="+docs.get(i)+"' target='_blank'>"
						//		+docComInfo.getDocname(""+docs.get(i))+"</a>&nbsp;";
						docNames+=docComInfo.getDocname(""+docs.get(i))+",";
					}
					}
				%>
				<brow:browser viewType="0" name="docid" browserValue='<%=Util.null2String(wp.getDocid()) %>' 
				browserOnClick="" browserUrl="/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="
				hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1' width="300px"
				completeUrl="/data.jsp?type=9" linkUrl="/docs/docs/DocDsp.jsp?id=" 
				browserSpanValue='<%=docNames %>'></brow:browser>
				</wea:item>
			<%} %>
			<%if(!"workplan".equals(target) || WorkPlanSetInfo.getInfoPrj()==1){%>
			<!--================== 相关项目 ==================-->
				<wea:item><%=SystemEnv.getHtmlLabelName(782, user.getLanguage())%></wea:item>
				<wea:item>
					<%
							String prjNames="";
						if (!Util.null2String(wp.getProjectid()).equals("")) 
						{
							ArrayList projects = Util.TokenizerString(Util.null2String(wp.getProjectid()), ",");
							for (int i = 0; i < projects.size(); i++) 
							{
									//prjNames+="<A  href='/proj/data/ViewProject.jsp?ProjID="+projects.get(i)+"' target='_blank'>"
									//		+projectInfoComInfo.getProjectInfoname(""+projects.get(i))+"</a>&nbsp;";
									prjNames+=projectInfoComInfo.getProjectInfoname(""+projects.get(i))+",";
								}
							}
						%>
						<brow:browser viewType="0" name="projectid" browserValue='<%=Util.null2String(wp.getProjectid())%>' 
						browserOnClick="" browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp?resourceids="%>'
						hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1' width="300px"
						completeUrl="/data.jsp?type=18" linkUrl="/proj/data/ViewProject.jsp?ProjID=#id#&id=#id#" 
						browserSpanValue='<%=prjNames %>'></brow:browser>
				</wea:item>
			<%}%>
			<%if(!"workplan".equals(target) || WorkPlanSetInfo.getInfoWf()==1){%>
			<!--================== 相关流程 ==================-->
				<wea:item><%=SystemEnv.getHtmlLabelName(1044, user.getLanguage())%></wea:item>
				<wea:item>
					<%
						String requestNames="";
					if (!Util.null2String(wp.getRequestid()).equals("")) 
					{
						ArrayList requests = Util.TokenizerString(Util.null2String(wp.getRequestid()), ",");
						for (int i = 0; i < requests.size(); i++) 
						{
								//requestNames+="<A  href='/workflow/request/ViewRequest.jsp?requestid="+requests.get(i)+"' target='_blank'>"
								//		+requestComInfo.getRequestname(""+requests.get(i))+"</a>&nbsp;";
								requestNames+=requestComInfo.getRequestname(""+requests.get(i))+",";
							}
						}
					%>
					<brow:browser viewType="0" name="requestid" browserValue='<%=Util.null2String(wp.getRequestid())%>' 
					browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp?resourceids="
					hasInput="false"  isSingle="false" hasBrowser = "true" isMustInput='1' width="300px" 
					completeUrl="/data.jsp" linkUrl="/workflow/request/ViewRequest.jsp?requestid==#id#&id=#id#" 
					browserSpanValue='<%=requestNames %>'></brow:browser>
				</wea:item>
			<%} %>
			<!--================== 定期模式 ==================-->      								
			
				<wea:item><%=SystemEnv.getHtmlLabelName(18221, user.getLanguage())%></wea:item>
				<wea:item> 
					<TABLE width="620px" height=100% border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td style="width:160px;padding-left: 0px!important;" class="field">
					<SELECT id="timeModul" name="timeModul" onchange="showFre(this.value)" style="width:150px!important">
						<OPTION value="9" <%if (Util.null2String(wp.getTimeModul()).equals("9")||Util.null2String(wp.getTimeModul()).equals("")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18223,user.getLanguage())%></OPTION><!--不定期建立计划-->
						<OPTION value="3" <%if (Util.null2String(wp.getTimeModul()).equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></OPTION><!--天-->
						<OPTION value="0" <%if (Util.null2String(wp.getTimeModul()).equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1926,user.getLanguage())%></OPTION><!--周-->
						<OPTION value="1" <%if (Util.null2String(wp.getTimeModul()).equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></OPTION><!--月-->
						<OPTION value="2" <%if (Util.null2String(wp.getTimeModul()).equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></OPTION><!--年-->
					</SELECT>
						</td>
						<td class="field">
					<%
						String a="vis4";
						String b="vis4";
						String c="vis4";
						String d="vis4";
						if (Util.null2String(wp.getTimeModul()).equals("0"))
						{
							a="vis3";
						}
						else if (Util.null2String(wp.getTimeModul()).equals("1"))
						{
							b="vis3";
						}
						else if (Util.null2String(wp.getTimeModul()).equals("2"))
						{
							c="vis3";
						}
						else if (Util.null2String(wp.getTimeModul()).equals("3"))
						{
							d="vis3";
						}
					%>
					<span>&nbsp;&nbsp;&nbsp;</span>
					<!--================== 天 ==================-->
					<SPAN id="show_3" class="<%=d%>" >
						<span><%=SystemEnv.getHtmlLabelName(539,user.getLanguage())%>
						&nbsp;
						</span>
						<button type="button" class=Clock onclick="onshowMeetingTime(daytimespan,dayTime)"></button>
						<span id="daytimespan"><%if("".equals(workPlanCreateTime)){ %><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}else{ %><%=workPlanCreateTime %><%} %></span>
						<input class=inputstyle type=hidden name="dayTime" id="dayTime" value="<%=workPlanCreateTime%>">
					</SPAN>
						
					<!--================== 周 ==================-->
					<SPAN id="show_0" class="<%=a%>" style="width:100%">
					<span ><%=SystemEnv.getHtmlLabelName(545,user.getLanguage())%></span>
						<SELECT name="fer_0" style="width:60px;">
							<OPTION value="1" <%if (Util.null2String(wp.getFrequency()).equals("1") && "0".equals(timeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16100, user.getLanguage())%></OPTION>
							<OPTION value="2" <%if (Util.null2String(wp.getFrequency()).equals("2") && "0".equals(timeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16101, user.getLanguage())%></OPTION>
							<OPTION value="3" <%if (Util.null2String(wp.getFrequency()).equals("3") && "0".equals(timeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16102, user.getLanguage())%></OPTION>
							<OPTION value="4" <%if (Util.null2String(wp.getFrequency()).equals("4") && "0".equals(timeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16103, user.getLanguage())%></OPTION>
							<OPTION value="5" <%if (Util.null2String(wp.getFrequency()).equals("5") && "0".equals(timeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16104, user.getLanguage())%></OPTION>
							<OPTION value="6" <%if (Util.null2String(wp.getFrequency()).equals("6") && "0".equals(timeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16105, user.getLanguage())%></OPTION>
							<OPTION value="7" <%if (Util.null2String(wp.getFrequency()).equals("7") && "0".equals(timeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16106, user.getLanguage())%></OPTION>											 				
						</SELECT>
						<span>&nbsp;</span>
						<button type="button" class=Clock onclick="onshowMeetingTime(weektimespan,weekTime)"></button>
						<span id="weektimespan"><%if("".equals(workPlanCreateTime)){ %><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}else{ %><%=workPlanCreateTime %><%} %></span>
						<input class=inputstyle type=hidden name="weekTime" id="weekTime" value="<%=workPlanCreateTime%>">
					</SPAN>
					
					<!--================== 月 ==================-->
					<SPAN id="show_1" class="<%=b%>">
						<span><%=SystemEnv.getHtmlLabelName(541,user.getLanguage())%></span>
						<SELECT name="monthType" style="width:60px!important">
							<OPTION value="0" <%if (createType.equals("0") && "1".equals(timeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18817,user.getLanguage())%></OPTION>
							<OPTION value="1" <%if (createType.equals("1") && "1".equals(timeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18816,user.getLanguage())%></OPTION>
						</SELECT>														
						<span><%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%></span>
						<SELECT name="fer_1" style="width:60px!important">
						<%
							for (int i = 1; i <= 31; i++) 
							{
						%>
							<OPTION value="<%=i%>" <%if (Util.null2String(wp.getFrequency()).equals(""+i) && "1".equals(timeModul)) {%>selected<%}%>><%=i%></OPTION>
						<%
							}
						%>
						</SELECT>
						<span><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>
						&nbsp;</span>
						<button type="button" class=Clock onclick="onshowMeetingTime(monthtimespan,monthTime)"></button>
						<span id="monthtimespan"><%if("".equals(workPlanCreateTime)){ %><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}else{ %><%=workPlanCreateTime %><%} %></span>
						<input class=inputstyle type=hidden name="monthTime" id="monthTime" value="<%=workPlanCreateTime%>">
					</SPAN>
					
					<!--================== 年 ==================-->
					<SPAN id="show_2" class="<%=c%>">
					<span><%=SystemEnv.getHtmlLabelName(546,user.getLanguage())%></span>
					<span><SELECT name="fer_2" style="width:40px!important">
						<%
							for (int i = 1; i <= 12; i++) 
							{
						%>
							<OPTION value="<%= Util.add0(i, 2) %>" <%if (Util.null2String(wp.getFrequency()).equals(""+i) && "2".equals(timeModul)) {%>selected<%}%>><%= Util.add0(i, 2) %></OPTION>
						<%
							}
						%>
						</SELECT>
					</span>
						<span><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></span>
					<span>
						<SELECT name="yearType" style="width:40px!important">														
							<OPTION value="0" <%if (createType.equals("0") && "2".equals(timeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18817,user.getLanguage())%></OPTION>
							<OPTION value="1" <%if (createType.equals("1") && "2".equals(timeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18816,user.getLanguage())%></OPTION>
						</SELECT>
					</span>
						<span><%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%></span>
					<span>
						<SELECT name="frey" style="width:40px!important">
						<%
							for (int i = 1; i <= 31; i++) 
							{
						%>
							<OPTION value="<%=i%>" <%if(frequencyy.equals(""+i) && "2".equals(timeModul)) {%>selected<%}%>><%=i%></OPTION>
						<%
							}
						%>
						</SELECT>
					</span>
						<span><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>
						<%//=Util.null2String(wp.getFrequencyy())%>
						&nbsp;</span>
						<button type="button" class=Clock onclick="onshowMeetingTime(yeartimespan,yearTime)"></button>
						<span id="yeartimespan"><%if("".equals(workPlanCreateTime)){ %><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}else{ %><%=workPlanCreateTime %><%} %></span>
						<input class=inputstyle type=hidden name="yearTime" id="yearTime" value="<%=workPlanCreateTime%>">
					</SPAN>
						</td>
					</tr>
				</table>
				</wea:item>
				<!--================ 持续时间  ================-->	
				<wea:item attributes="{'samePair':'generateSet1'}">
					<%=SystemEnv.getHtmlLabelName(19798,user.getLanguage())%>
				</wea:item>
				<wea:item attributes="{'samePair':'generateSet1'}">
					<TABLE width=100% height=100% border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td style="width:60px;padding-left: 0px!important;" class="field">
					<INPUT type=text id="times" name="times" size=5 value="<%= persistentTimes %>" onKeyPress="Count_KeyPress()" onchange="checkinput('times', 'timesSpan')" style="width:30px!important">
					<SPAN id="timesSpan" name="timesSpan">
					<%
						if(null == persistentTimes || "".equals(persistentTimes))
						{
					%>
						<IMG src='/images/BacoError_wev8.gif' align=absMiddle>
					<%
						}
					%>
					</SPAN>
							</td>
							<td class="field">
					<SELECT name=timeType style="width:60px!important">									            
						<OPTION value="1" <%if("1".equals(persistentType)) { %> selected <% } %>><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></OPTION>
						<OPTION value="2" <%if("2".equals(persistentType)) { %> selected <% } %>><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></OPTION>
						<OPTION value="3" <%if("3".equals(persistentType)) { %> selected <% } %>><%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%></OPTION>
					</SELECT>
						</td>
						</tr>
					</table>
				</wea:item>
						<!--================ 有效期  ================-->	
				<wea:item attributes="{'samePair':'generateSet1'}">
					<%=SystemEnv.getHtmlLabelName(15030,user.getLanguage())%>
				</wea:item>
				<wea:item attributes="{'samePair':'generateSet1'}">
					<%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%>
					<button type="button" class="Calendar" id="selectBeginDate" onclick="getTheDate('beginDate','beginDateSpan')"></BUTTON> 
					<SPAN id="beginDateSpan"><%= availableBeginDate %></SPAN> 
					<INPUT type="hidden" name="beginDate" value="<%= availableBeginDate %>">  
					&nbsp;&nbsp;&nbsp;
					<%=SystemEnv.getHtmlLabelName(15322,user.getLanguage())%>
					<button type="button" class="Calendar" id="selectEndDate" onclick="getTheDate('endDate','endDateSpan')"></BUTTON> 
					<SPAN id="endDateSpan"><%= availableEndDate %></SPAN> 
					<INPUT type="hidden" name="endDate" value="<%= availableEndDate %>">  
				</wea:item>
				<!--================ 有效期  ================-->	
				<wea:item attributes="{'samePair':'generateSet2'}">
					<%= SystemEnv.getHtmlLabelName(23231,user.getLanguage()) %>
				</wea:item>
				<wea:item attributes="{'samePair':'generateSet2'}">
					<INPUT type="checkbox" value="<%=immediatetouch %>" name="immediatetouch" <%if(immediatetouch==1)out.print("checked"); %> onclick="validateImmediateTouch(this);">&nbsp;															
				</wea:item>
			</wea:group>
			<% 
				if (ar.getResult(sqls) && !"0".equals(type_n))
				{
			%>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(18200, user.getLanguage())%>' >
				<wea:item attributes="{'isTableList':'true'}">
					<%	
						rsk.executeSql("SELECT * from HrmPerformancePlanKeyModul where planId="+wp.getId()+" order by viewSort" );
						JSONArray root = new JSONArray();
						
						while (rsk.next())
						{
							JSONArray node = new JSONArray();
							JSONObject nodeChld = new JSONObject();
							nodeChld.put("name","keyName");
							nodeChld.put("value",rsk.getString("keyname"));
							nodeChld.put("iseditable","true");
							nodeChld.put("type","input");
							node.add(nodeChld);
							
							nodeChld = new JSONObject();
							nodeChld.put("name","viewSort");
							nodeChld.put("value",rsk.getString("viewSort"));
							nodeChld.put("iseditable","true");
							nodeChld.put("type","input");
							node.add(nodeChld);
							
							root.add(node);
						}
					%>
				 
					<div class="listdiv"  style="width:100%"></div>
					<script>
						var rowindex = 0;
						var items=[
							{width:"80%",colname:"<%=SystemEnv.getHtmlLabelName(18201,user.getLanguage())%>",itemhtml:"<input class='inputStyle' name='keyName' value=''"},
							{width:"10%",colname:"<%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%>",itemhtml:"<input class='inputStyle' name='viewSort' value=''"}
						];
						var option= {
							 basictitle:"",
							 toolbarshow:true,
							 colItems:items,
							 openindex:true,
							 addrowtitle:true,
							 deleterowstitle:true,
							 copyrowtitle:false,
							 usesimpledata:true,
							 initdatas:eval('(<%=root.toString()%>)'),
							 addrowCallBack:function() {
								// alert("回调函数!!!");
								rowindex++;
								jQuery("#rownum").val(rowindex);
							 },
							configCheckBox:true,
							checkBoxItem:{"itemhtml":"<input type='checkbox' class='groupselectbox'><input type='hidden'  name='rowid' value='1' >",width:"3%"}
						};
						var group=new WeaverEditTable(option);
						$(".listdiv").append(group.getContainer());
					</script>
			
				</wea:item>
			</wea:group>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(18202, user.getLanguage())%>'  >
				<wea:item attributes="{'isTableList':'true'}">
					<%	
						rsc.executeSql("SELECT * from HrmPerformancePlanEffortModul where planId="+wp.getId()+" order by viewSort");
						JSONArray root1 = new JSONArray();
						
						while (rsc.next())
						{
							JSONArray node = new JSONArray();
							JSONObject nodeChld = new JSONObject();
							nodeChld.put("name","effortName");
							nodeChld.put("value",rsc.getString("effortName"));
							nodeChld.put("iseditable","true");
							nodeChld.put("type","input");
							node.add(nodeChld);
							
							nodeChld = new JSONObject();
							nodeChld.put("name","viewSort1");
							nodeChld.put("value",rsc.getString("viewSort"));
							nodeChld.put("iseditable","true");
							nodeChld.put("type","input");
							node.add(nodeChld);
							
							root1.add(node);
						}
					%>
				 
					<div class="listdiv1"  style="width:100%"></div>
					<script>
						var rowindex1 = 0;
						var items1=[
							{width:"80%",colname:"<%=SystemEnv.getHtmlLabelName(18201,user.getLanguage())%>",itemhtml:"<input class='inputStyle' name='effortName' value=''"},
							{width:"10%",colname:"<%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%>",itemhtml:"<input class='inputStyle' name='viewSort1' value=''"}
						];
						var option1= {
							 basictitle:"",
							 toolbarshow:true,
							 colItems:items1,
							 openindex:true,
							 addrowtitle:true,
							 deleterowstitle:true,
							 copyrowtitle:false,
							 usesimpledata:true,
							 initdatas:eval('(<%=root1.toString()%>)'),
							 addrowCallBack:function() {
								// alert("回调函数!!!");
								rowindex1++;
								jQuery("#rownum1").val(rowindex1);
							 },
							configCheckBox:true,
							checkBoxItem:{"itemhtml":"<input type='checkbox' class='groupselectbox'><input type='hidden'  name='rowid1' value='1' >",width:"3%"}
						};
						var group1=new WeaverEditTable(option1);
						$(".listdiv1").append(group1.getContainer());
					</script>
			
				</wea:item>
			</wea:group>
			<%}%>
		</wea:layout>

</FORM>

</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
					id="zd_btn_cancle" class="e8_btn_cancel" onclick="dialog.closeByHand();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
<SCRIPT language="JavaScript" src="/js/OrderValidator_wev8.js"></SCRIPT>
<SCRIPT language="javascript">
var dialog = parent.getDialog(window);
function validateImmediateTouch(o)
{
	if(o.checked)
	{
		o.value='1';
	}
	else
	{
		o.value='0';
	}
	if(o.checked)
	{
		var beginDate = document.resource.beginDate.value;
		var endDate = document.resource.endDate.value;
		if(endDate=="")
		{
			Dialog.alert("<%= SystemEnv.getHtmlLabelName(23232,user.getLanguage()) %>!")
		}
	}
}
function OnSubmit()
{   
    if(check_form(document.resource,"name,principal") && checkNumberValid("times")&&checkDateValidity()&& checkTimeValid()&& checkWorkPlanRemind())
	{	
		if (<%=flag=="1"%> && "0" != "<%= type_n %>") 
		{
		    //document.getElementById("rownum").value = oTable.tBodies[1].rows.length - 2;
		    //document.getElementById("rownum1").value = oTable1.tBodies[1].rows.length - 2;
		}
		var immediatetouch = document.resource.immediatetouch;
		if(immediatetouch)
		{
			immediatetouch = immediatetouch.value;
			if(immediatetouch==1)
			{
				var endDate = document.resource.endDate.value;
				if(endDate=="")
				{
					Dialog.alert("<%= SystemEnv.getHtmlLabelName(23232,user.getLanguage()) %>!");
					return;
				}
			}
		}
		forbiddenPage();
		//hideRightClickMenu();
		document.resource.submit();
		//enablemenu();
		//window.frames["rightMenuIframe"].window.event.srcElement.disabled=true;
	}
}

function checkDateValidity(){
	var isValid = true;
	var beginDate = document.resource.beginDate.value;
	var endDate = document.resource.endDate.value;
	if(beginDate!=''&&endDate!=''){
		if(compareDate(beginDate,"00:00",endDate,"00:00") == 1){
			Dialog.alert("<%= SystemEnv.getHtmlLabelName(16721,user.getLanguage()) %>");
			isValid = false;
		}
	}
	return isValid
} 

/*Check Date */
function compareDate(date1,time1,date2,time2){

	var ss1 = date1.split("-",3);
	var ss2 = date2.split("-",3);

	date1 = ss1[1]+"/"+ss1[2]+"/"+ss1[0] + " " +time1;
	date2 = ss2[1]+"/"+ss2[2]+"/"+ss2[0] + " " +time2;

	var t1,t2;
	t1 = Date.parse(date1);
	t2 = Date.parse(date2);
	if(t1==t2) return 0;
	if(t1>t2) return 1;
	if(t1<t2) return -1;

    return 0;
}

      function checkTimeValid(){
          var fff = false;
          if("3" == $GetEle("timeModul").value && ""!=$GetEle("dayTime").value ){
              fff= true;
          } else if("0" == $GetEle("timeModul").value && ""!=$GetEle("weekTime").value){
              fff =true;
          }  else if("1" == $GetEle("timeModul").value && ""!=$GetEle("monthTime").value){
              fff= true;
          } else if("2" == $GetEle("timeModul").value && ""!=$GetEle("yearTime").value){
              fff= true;
          } else if("9" == $GetEle("timeModul").value){
              fff= true;
          }
          return fff;
      }

function onNeedRemind() {
	if ($GetEle("isremind").checked) 
        $GetEle("remindspan").className = "vis1";
    else 
        $GetEle("remindspan").className = "vis2";
}
 
function showFre(mode)
{
	
	for(i = 0; i < 4; i++)
	{
		$("#show_" + i).hide();
		hideEle("generateSet", true);
		hideEle("generateSet1", true);
		hideEle("generateSet2", true);
	}
	if("9" != mode)
	{
		$("#show_" + mode).show();
		showEle("generateSet");
		showEle("generateSet1");
		showEle("generateSet2");
	}
	//resizeDialog(document);
}

function showPro(type)
{
	$GetEle("property_0").className = "vis4";	
	$GetEle("property_6").className = "vis4";
	$GetEle("workPlanTypeDIV").className = "vis4";

	if("6" == type)
	//目标计划性质
	{
		$GetEle("property_6").className = "vis3";	
	}
	else
	//工作安排性质
	{
		$GetEle("workPlanTypeDIV").className = "vis3";	
		$GetEle("property_0").className = "vis3";
	}	
}
function onShowResource(inputname,spanname){
    linkurl="javaScript:openhrm(";
    datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+$("input[name="+inputname+"]").val());
    if (datas) {
        if (datas.id&&datas.name.length > 2000){ //500为表结构文档字段的长度
            Dialog.alert("<%=SystemEnv.getHtmlLabelName(24476,user.getLanguage())%>");
            return;
        }else  if (datas.id!= "") {
            ids = datas.id.split(",");
            names =datas.name.split(",");
            sHtml = "";
            for( var i=0;i<ids.length;i++){
                if(ids[i]!=""){
                    sHtml = sHtml+"<a href=\"/hrm/resource/HrmResource.jsp?id="+ids[i]+"\"  target='_blank'>"+names[i]+"</a>&nbsp;";

                }
            }
            $("#"+spanname).html(sHtml);
            $("input[name="+inputname+"]").val(datas.id.indexOf(",")!=0?datas.id:datas.id.substring(1));
        }
        else	{
            $("#"+spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
            $("input[name="+inputname+"]").val("");
        }
    }}

var rowColor;
var rowindex = <%=rowIndex%>;
var rowindex1 = <%=rowIndex1%>;
function addRow(){
	
	var oRow = jQuery("#oTable")[0].insertRow(-1);
	var oRowIndex = oRow.rowIndex;
   
	for(j=0; j<3; j++) {
		oCell =  oRow.insertCell(-1);
		oCell.style.className="Field";
		switch(j) {
            case 0:
				var oDiv = document.createElement("DIV");
				var sHtml = "<INPUT class=inputstyle type='checkbox' id='check_node' name='check_node' value='0'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("DIV");
				var sHtml =  "<INPUT class=inputstyle style='width:100%' type=text  maxlength=50 name='keyName_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("DIV");
				var sHtml = "<INPUT class=inputstyle style='width:100%' type=text maxlength=3 name='viewSort_"+rowindex+"' onkeypress='ItemCount_KeyPress()' >";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
	jQuery("#oTable").jNice();
	var tr = jQuery("table.LayoutTable tr[class!=intervalTR]");
	tr.each(function(){
		if(!jQuery(this).hasClass("intervalTR")){
			jQuery(this).hover(function(){
				jQuery(this).addClass("Selected");
				jQuery(this).next("tr.Spacing").find("div").addClass("intervalHoverClass");		
			},function(){
				jQuery(this).removeClass("Selected");	
				jQuery(this).next("tr.Spacing").find("div").removeClass("intervalHoverClass");	
			});
		}
	});
}

function deleteRow1(){
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node'){
			if(document.forms[0].elements[i].checked==true) {
				oTable.deleteRow(rowsum1-1);	
			}
			rowsum1 -=1;
		}
	
	}
	initOrupdateOvflw(1);
}
function addRow2(){
	
	var oRow = jQuery("#oTable1")[0].insertRow(-1);
	var oRowIndex = oRow.rowIndex;
   
	for(j=0; j<3; j++) {
		oCell =  oRow.insertCell(-1);
		oCell.style.className="Field";
		switch(j) {
            case 0:
				var oDiv = document.createElement("DIV");
				var sHtml = "<INPUT class=inputstyle type='checkbox' name='check_node_1' id='check_node_1' value='0'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("DIV");
				var sHtml =  "<INPUT class=inputstyle style='width:100%' type=text maxlength=50 name='effortName_"+rowindex1+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("DIV");
				var sHtml = "<INPUT class=inputstyle style='width:100%' type=text  maxlength=3 name='viewSort1_"+rowindex1+"' onkeypress='ItemCount_KeyPress()' >";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
	jQuery("#oTable1").jNice();
	var tr = jQuery("table.LayoutTable tr[class!=intervalTR]");
	tr.each(function(){
		if(!jQuery(this).hasClass("intervalTR")){
			jQuery(this).hover(function(){
				jQuery(this).addClass("Selected");
				jQuery(this).next("tr.Spacing").find("div").addClass("intervalHoverClass");		
			},function(){
				jQuery(this).removeClass("Selected");	
				jQuery(this).next("tr.Spacing").find("div").removeClass("intervalHoverClass");	
			});
		}
	});
	initOrupdateOvflw(1);
}

function deleteRow2(){
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node_1')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node_1'){
			if(document.forms[0].elements[i].checked==true) {
				oTable1.deleteRow(rowsum1-1);	
			}
			rowsum1 -=1;
		}
	
	}
	initOrupdateOvflw(1);
}

function checkNumberValid(inputId)
{
	//var patt = /^[1-9]\d*|[1-9]\d*\.\d+|0\.\d+$/g;
	var patt = /^([1-9]\d*)$/g;
	var inputString = $G(inputId).value;

	if("9" != $GetEle("timeModul").value &&!(patt.test(inputString)))
	{
		Dialog.alert("<%= SystemEnv.getHtmlLabelName(19798, user.getLanguage())+SystemEnv.getHtmlLabelName(24475, user.getLanguage())%>");

		return false;
	}
	else
	{
		return true;
	}
}

function Count_KeyPress()
{
	if(!(window.event.keyCode >= 48 && window.event.keyCode <= 57)) 
	{
		window.event.keyCode=0;
	}
}

function onWPNOShowDate(spanname,inputname){
  var returnvalue;	  
  var oncleaingFun = function(){		 
		document.getElementById(spanname).innerHTML = "";
        document.getElementById(inputname).value = "";
	};
   WdatePicker({onpicked:function(dp){
	returnvalue = dp.cal.getDateStr();	
	$dp.$(spanname).innerHTML = returnvalue;
	$dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});
}
function showRemindTime(obj)
{
	if("1" == obj.value)
	{
		hideEle("remindtime", true);
	}
	else
	{
		showEle("remindtime");
	}
}
function checkWorkPlanRemind()
{
	if(false == document.resource.remindType[0].checked)
	{
		if(document.resource.remindBeforeStart.checked || document.resource.remindBeforeEnd.checked)
		{
			return true;			
		}
		else
		{
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(20238,user.getLanguage())%>");
			return false;
		}
	}
	else
	{
		document.resource.remindBeforeStart.checked = false;
		document.resource.remindBeforeEnd.checked = false;
		document.resource.remindTimeBeforeStart.value = 10;
		document.resource.remindTimeBeforeEnd.value = 10;
		
		return true;		
	}
}

function btn_cancle(){
	var parentWin = parent.getParentWindow(window);
	parentWin.closeDialog();
}

jQuery(document).ready(function(){
	resizeDialog(document);
	if("0"=="<%=WorkPlanSetInfo.getShowRemider()%>"){
		hideEle("ShowRemider", true);
	}
	
	var remindType=$("input[name='remindType']:checked").val();
	if("2" != remindType && "3" != remindType)
	{
		hideEle("remindtime", true);
	}
	else
	{
		showEle("remindtime");
	}
	showFre($GetEle("timeModul").value);
	//解决IE8下 查看周期日程 定期模式为周、月时 显示异常问题
	$("#show_0").css("width","100%");
	$("#show_1").css("width","100%");
});

function forbiddenPage(){
	$("<div class=\"datagrid-mask\" style=\"position:fixed;z-index:2;opacity:0.4;filter:alpha(opacity=40);BACKGROUND-COLOR:#fff;\"></div>").css({display:"block",width:"100%",height:"100%",top:0,left:0}).appendTo("body");   
    $("<div class=\"datagrid-mask-msg\" style=\"background:#fff;position:fixed;z-index:3;padding: 10px;padding-top: 6px;padding-bottom: 6px;border: 1px solid;\"></div>").html("<%=SystemEnv.getHtmlLabelName(25666,user.getLanguage())%>").appendTo("body").css({display:"block",left:($(document.body).outerWidth(true) - 190) / 2,top:($(window).height() - 45) / 2});  
}  

function releasePage(){  
    $(".datagrid-mask,.datagrid-mask-msg").hide();  
}

</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
</HTML>
