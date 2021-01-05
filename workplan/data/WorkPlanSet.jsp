
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.general.Util"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo"	class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="MouldStatusCominfo"	class="weaver.systeminfo.MouldStatusCominfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<%
	boolean canedit = false;

	if (!HrmUserVarify.checkUserRight("WorkPlan:Set", user)) {
		canedit = true;
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	int id=-1;
	int timeRangeStart=0;
	int timeRangeEnd=23;
	int amAndPm	= 0;
	String amStart="";
	String amEnd="";
	String pmStart="";
	String pmEnd="";
	int dataSplit	= 0;
	int showPerson	= 0;
	String showInfo	= "1^0^1^0";
	String tooltipInfo	= "1^1^1^1^1^0^1";
	int dataRule	= 2;
	int showRemider=1;
	int defaultRemider=1;
	int infoDoc=1;
	int infoWf=1;
	int infoCrm=1;
	int infoPrj=1;
	int infoPrjTask=1;
	int dscsDoc=1;
	int dscsWf=1;
	int dscsCrm=1;
	int dscsPrj=1;
	int infoAccessory=1;
	String infoAccessoryDir="";
	int dscsAccessory=1;
	String dscsAccessoryDir="";
	
	boolean isCrm=false;//是否启用客户模块
	boolean isProj=false;//是否启用项目模块
	if("1".equals(MouldStatusCominfo.getStatus("proj"))){
		isProj=true;
	}else{
		RecordSet.execute("update WorkPlanSet set infoPrj=0,infoPrjTask=0,dscsPrj=0");
	}
	if("1".equals(MouldStatusCominfo.getStatus("crm"))){
		isCrm=true;
	}else{
		RecordSet.execute("update WorkPlanSet set infoCrm=0,dscsCrm=0");
	}
			
	String hasChanged=Util.null2String(request.getParameter("hasChanged"));
	if("1".equals(hasChanged)){
		id	= Util.getIntValue(request.getParameter("id"), 0);
		timeRangeStart	= Util.getIntValue(request.getParameter("timeRangeStart"), 0);
		timeRangeEnd	= Util.getIntValue(request.getParameter("timeRangeEnd"), 23);
		amAndPm	= Util.getIntValue(request.getParameter("amAndPm"), 0);
		amStart	= Util.null2String(request.getParameter("amStart"));
		amEnd	= Util.null2String(request.getParameter("amEnd"));
		pmStart	= Util.null2String(request.getParameter("pmStart"));
		pmEnd	= Util.null2String(request.getParameter("pmEnd"));
		dataSplit	= Util.getIntValue(request.getParameter("dataSplit"), 0);
		showPerson	= Util.getIntValue(request.getParameter("showPerson"), 0);
		showInfo	= Util.null2String(request.getParameter("showInfo"),"1^0^1^0");
		tooltipInfo	= Util.null2String(request.getParameter("tooltipInfo"),"1^1^1^1^1^0^1");
		dataRule = Util.getIntValue(request.getParameter("dataRule"), 2);
		
		showRemider	= Util.getIntValue(request.getParameter("showRemider"), 0);
		defaultRemider	= Util.getIntValue(request.getParameter("defaultRemider"), 1);
		infoDoc	= Util.getIntValue(request.getParameter("infoDoc"), 0);
		infoWf	= Util.getIntValue(request.getParameter("infoWf"), 0);
		infoCrm	= Util.getIntValue(request.getParameter("infoCrm"), 0);
		infoPrj	= Util.getIntValue(request.getParameter("infoPrj"), 0);
		infoPrjTask	= Util.getIntValue(request.getParameter("infoPrjTask"), 0);
		infoAccessory	= Util.getIntValue(request.getParameter("infoAccessory"), 0);
		infoAccessoryDir	= Util.null2String(request.getParameter("infoAccessoryDir"));
		dscsDoc	= Util.getIntValue(request.getParameter("dscsDoc"), 0);
		dscsWf	= Util.getIntValue(request.getParameter("dscsWf"), 0);
		dscsCrm	= Util.getIntValue(request.getParameter("dscsCrm"), 0);
		dscsPrj	= Util.getIntValue(request.getParameter("dscsPrj"), 0);
		dscsAccessory	= Util.getIntValue(request.getParameter("dscsAccessory"), 0);
		dscsAccessoryDir	= Util.null2String(request.getParameter("dscsAccessoryDir"));
		String sql="update WorkPlanSet set timeRangeStart="+timeRangeStart+",timeRangeEnd="+timeRangeEnd+",amAndPm='"+amAndPm+"',amStart='"+amStart+
					"',amEnd='"+amEnd+"',pmStart='"+pmStart+"',pmEnd='"+pmEnd+"',dataSplit="+dataSplit+",showPerson="+showPerson+",showInfo='"+showInfo+
					"',tooltipInfo='"+tooltipInfo+"',dataRule="+dataRule+",showRemider="+showRemider+",defaultRemider="+defaultRemider+",infoDoc="+infoDoc+
					",infoWf="+infoWf+",infoCrm="+infoCrm+",infoPrj="+infoPrj+",infoPrjTask="+infoPrjTask+",dscsDoc="+dscsDoc+",dscsWf="+dscsWf+",dscsCrm="+dscsCrm+",dscsPrj="+dscsPrj+",infoAccessory="+infoAccessory+",infoaccessorydir='"+infoAccessoryDir+"',dscsAccessory="+dscsAccessory+",dscsaccessorydir='"+dscsAccessoryDir+"' where id="+id;
		RecordSet.execute(sql);
		SysMaintenanceLog syslog=new SysMaintenanceLog();
	    syslog.resetParameter();
		syslog.insSysLogInfo(user,id,"日程应用设置","日程应用设置","411","2",0,Util.getIpAddr(request)); 
	}else{
		RecordSet.executeSql("select * from WorkPlanSet order by id");
		if(RecordSet.next()){
			id=Util.getIntValue(RecordSet.getString("id"), 0);
			timeRangeStart	= Util.getIntValue(RecordSet.getString("timeRangeStart"), 0);
			timeRangeEnd	= Util.getIntValue(RecordSet.getString("timeRangeEnd"), 23);
			amAndPm	= Util.getIntValue(RecordSet.getString("amAndPm"), 0);
			amStart	= Util.null2String(RecordSet.getString("amStart"));
			amEnd	= Util.null2String(RecordSet.getString("amEnd"));
			pmStart	= Util.null2String(RecordSet.getString("pmStart"));
			pmEnd	= Util.null2String(RecordSet.getString("pmEnd"));
			dataSplit	= Util.getIntValue(RecordSet.getString("dataSplit"), 0);
			showPerson	= Util.getIntValue(RecordSet.getString("showPerson"), 0);
			showInfo	= Util.null2String(RecordSet.getString("showInfo"),"1^0^1^0");
			tooltipInfo	= Util.null2String(RecordSet.getString("tooltipInfo"),"1^1^1^1^1^0^1");
			dataRule = Util.getIntValue(RecordSet.getString("dataRule"), 2);
			
			showRemider	= Util.getIntValue(RecordSet.getString("showRemider"), 1);
			defaultRemider	= Util.getIntValue(RecordSet.getString("defaultRemider"), 1);
			infoDoc	= Util.getIntValue(RecordSet.getString("infoDoc"), 1);
			infoWf	= Util.getIntValue(RecordSet.getString("infoWf"), 1);
			infoCrm	= Util.getIntValue(RecordSet.getString("infoCrm"), 1);
			infoPrj	= Util.getIntValue(RecordSet.getString("infoPrj"), 1);
			infoPrjTask	= Util.getIntValue(RecordSet.getString("infoPrjTask"), 1);
			infoAccessory	= Util.getIntValue(RecordSet.getString("infoAccessory"), 1);
			infoAccessoryDir	= Util.null2String(RecordSet.getString("infoAccessoryDir"));
			
			dscsDoc	= Util.getIntValue(RecordSet.getString("dscsDoc"), 1);
			dscsWf	= Util.getIntValue(RecordSet.getString("dscsWf"), 1);
			dscsCrm	= Util.getIntValue(RecordSet.getString("dscsCrm"), 1);
			dscsPrj	= Util.getIntValue(RecordSet.getString("dscsPrj"), 1);
			dscsAccessory = Util.getIntValue(RecordSet.getString("dscsAccessory"), 1);
			dscsAccessoryDir = Util.null2String(RecordSet.getString("dscsAccessoryDir"));
		}
	}
	
	String[] showInfos=showInfo.split("\\^");
	String[] tooltipInfos=tooltipInfo.split("\\^");
%>
<html>
	<head>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<link href="/workplan/calendar/css/calendar_wev8.css" rel="stylesheet" type="text/css" />
		<link type="text/css" href="/js/tabs/css/e8tabs_wev8.css" rel="stylesheet" />
		<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
		<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
		<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
		<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<style>
 .titlecss{
	font-weight: bold;
 }
 .ui-widget-header {
	background: #85D08D;
 }
 .Clock{
 	BACKGROUND-IMAGE: url(/images/ecology8/meeting/time_wev8.png) !important;
 }
 .spanW{
 	display:-moz-inline-box;
	display:inline-block;
	width:35px;
 }
 .selftip{
 	position: absolute;
	top: -999px;
	left:-999px;
	border: 1px solid #808080;
	max-width: 350px;
	height: auto;
	background: #F6F7FB;
 }
 .{
 	
 }
</style>
</head>
<%
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(32838, user.getLanguage());
	String needfav = "1";
	String needhelp = "";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())
			+ ",javascript:submitData(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<BODY style="overflow:scroll;overflow-y:hidden">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="schedule"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelName(31811,user.getLanguage()) %>'/>
</jsp:include>
<div class="zDialog_div_content">		
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan"
			style="text-align: right; width: 400px !important">
			<input type="button" value='<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>' class="e8_btn_top_first" onclick="submitData()" />
		<span title='<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>'  class="cornerMenu middle"></span>
		</td>
	</tr>
</table>

	<FORM id=weaverA name=weaverA action="WorkPlanSet.jsp" method="post">
		<input type="hidden" name="hasChanged" value="1" />
		<input type="hidden" value='<%=id %>' name="id"/>
	<wea:layout  type="2Col">
	   <wea:group context='<%=SystemEnv.getHtmlLabelName(33976, user.getLanguage())+SystemEnv.getHtmlLabelName(68, user.getLanguage())%>' attributes="{'itemAreaDisplay':'block'}">
			<!-- 会议室日使用情况显示时间段 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(33976, user.getLanguage())%></wea:item>
			<wea:item>
				<div>
					<div id = "slider-range" style="float:left;width: 200px;"></div><div id="amount" style="float:left;margin-left:30px;"></div>
				</div>
				<input type="hidden" id="timeRangeStart" name="timeRangeStart" value='<%=timeRangeStart %>'>
				<input type="hidden" id="timeRangeEnd" name="timeRangeEnd" value='<%=timeRangeEnd %>'>
			</wea:item>
			 
		</wea:group>
	    
		<wea:group context='<%=SystemEnv.getHtmlLabelName(33959, user.getLanguage())+SystemEnv.getHtmlLabelName(68, user.getLanguage())%>' attributes="{'itemAreaDisplay':'block'}">
			<!-- 每天分上下午显示 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(33977, user.getLanguage())%></wea:item>
			<wea:item>
				 <input tzCheckbox="true" class="inputstyle" type="checkbox" onclick="checkChanged(this)" id="amAndPm" name="amAndPm" value="1" <%if(amAndPm == 1){%>checked<%}%>> &nbsp;
				 <SPAN>
			          <IMG class="remindImg" src="/wechat/images/remind_wev8.png" align=absMiddle tit='<%=SystemEnv.getHtmlLabelName(33986, user.getLanguage())%>'>
			     </SPAN>
			</wea:item>
			<wea:item  attributes="{'samePair':'amAndPm'}"><%=SystemEnv.getHtmlLabelName(33978, user.getLanguage())%></wea:item>
			<wea:item  attributes="{'samePair':'amAndPm'}">
				 
				<button type="button" class="Clock"  style="background-image: url(/images/ecology8/meeting/time_wev8.png) !important;" onclick="onShowTime1(amStartSpan,amStart)"></BUTTON>
              	<SPAN class="spanW" id="amStartSpan"><%if("".equals(amStart)){%><img align="absmiddle" src="/images/BacoError_wev8.gif"><%}else{out.print(amStart);}%></SPAN>
              	-
              	<button type="button" class="Clock" style="background-image: url(/images/ecology8/meeting/time_wev8.png) !important;" onclick="onShowTime1(amEndSpan,amEnd)"></BUTTON>
              	<SPAN class="spanW" id="amEndSpan"><%if("".equals(amEnd)){%><img align="absmiddle" src="/images/BacoError_wev8.gif"><%}else{out.print(amEnd);}%></SPAN>
              	<INPUT type="hidden" id="amStart" name="amStart" value='<%=amStart%>'>
              	<INPUT type="hidden" id="amEnd" name="amEnd" value='<%=amEnd%>'>
			</wea:item>
			<wea:item  attributes="{'samePair':'amAndPm'}"><%=SystemEnv.getHtmlLabelName(33979, user.getLanguage())%></wea:item>
			<wea:item  attributes="{'samePair':'amAndPm'}">
				<button type="button" class="Clock"  style="background-image: url(/images/ecology8/meeting/time_wev8.png) !important;" onclick="onShowTime1(pmStartSpan,pmStart)"></BUTTON>
              	<SPAN class="spanW" id="pmStartSpan"><%if("".equals(amStart)){%><img align="absmiddle" src="/images/BacoError_wev8.gif"><%}else{out.print(pmStart);}%></SPAN>
              	-
              	<button type="button" class="Clock" style="background-image: url(/images/ecology8/meeting/time_wev8.png) !important;" onclick="onShowTime1(pmEndSpan,pmEnd)"></BUTTON>
              	<SPAN class="spanW" id="pmEndSpan"><%if("".equals(amEnd)){%><img align="absmiddle" src="/images/BacoError_wev8.gif"><%}else{out.print(pmEnd);}%></SPAN>
              	<INPUT type="hidden" id="pmStart" name="pmStart" value='<%=pmStart%>'>
              	<INPUT type="hidden" id="pmEnd" name="pmEnd" value='<%=pmEnd%>'>
			</wea:item>
			<!-- 数据拆分 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(33980, user.getLanguage())%></wea:item>
			<wea:item>
				 <input tzCheckbox="true" class="inputstyle" type="checkbox" id="dataSplit" name="dataSplit" value="1" <%if(dataSplit == 1){%>checked<%}%>> &nbsp;
				 <SPAN>
			          <IMG  class="remindImg" src="/wechat/images/remind_wev8.png" align=absMiddle tit='<%=SystemEnv.getHtmlLabelName(33985, user.getLanguage())%>'>
			     </SPAN>
			</wea:item>
			<!-- 显示无日程人员 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(33981, user.getLanguage())%></wea:item>
			<wea:item>
				 <input tzCheckbox="true" class="inputstyle" type="checkbox" id="showPerson" name="showPerson" value="1" <%if(showPerson == 1){%>checked<%}%>> &nbsp;
				 <SPAN>
			          <IMG  class="remindImg" src="/wechat/images/remind_wev8.png" align=absMiddle tit='<%=SystemEnv.getHtmlLabelName(33987, user.getLanguage())%>'>
			     </SPAN>
			</wea:item>
			
			<!-- 日程显示信息-->
			<wea:item><%=SystemEnv.getHtmlLabelName(33982, user.getLanguage())%></wea:item>
			<wea:item>
				 <input class="inputstyle" type="checkbox" name="showInfos" <%if("1".equals(showInfos[0])){%>checked<%}%>> &nbsp;<%=SystemEnv.getHtmlLabelName(742, user.getLanguage())%>&nbsp;&nbsp;
				 <input class="inputstyle" type="checkbox" name="showInfos" <%if("1".equals(showInfos[1])){%>checked<%}%>> &nbsp;<%=SystemEnv.getHtmlLabelName(743, user.getLanguage())%>&nbsp;&nbsp;
				 <input class="inputstyle" type="checkbox" name="showInfos" <%if("1".equals(showInfos[2])){%>checked<%}%>> &nbsp;<%=SystemEnv.getHtmlLabelName(229, user.getLanguage())%>&nbsp;&nbsp;
				 <input class="inputstyle" type="checkbox" name="showInfos" <%if("1".equals(showInfos[3])){%>checked<%}%>> &nbsp;<%=SystemEnv.getHtmlLabelName(882, user.getLanguage())%>&nbsp;&nbsp;
				 <input type="hidden" id="showInfo" name="showInfo" value='<%=showInfo %>' >
			</wea:item>
			
			<!-- 日程浮出框提示信息 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(33983, user.getLanguage())%></wea:item>
			<wea:item>
				<input class="inputstyle" type="checkbox" name="tooltipInfos" <%if("1".equals(tooltipInfos[0])){%>checked<%}%>> &nbsp;<%=SystemEnv.getHtmlLabelName(740, user.getLanguage())%>&nbsp;&nbsp;
				<input class="inputstyle" type="checkbox" name="tooltipInfos" <%if("1".equals(tooltipInfos[1])){%>checked<%}%>> &nbsp;<%=SystemEnv.getHtmlLabelName(742, user.getLanguage())%>&nbsp;&nbsp;
				<input class="inputstyle" type="checkbox" name="tooltipInfos" <%if("1".equals(tooltipInfos[2])){%>checked<%}%>> &nbsp;<%=SystemEnv.getHtmlLabelName(741, user.getLanguage())%>&nbsp;&nbsp;
				<input class="inputstyle" type="checkbox" name="tooltipInfos" <%if("1".equals(tooltipInfos[3])){%>checked<%}%>> &nbsp;<%=SystemEnv.getHtmlLabelName(743, user.getLanguage())%>&nbsp;&nbsp;
				<input class="inputstyle" type="checkbox" name="tooltipInfos" <%if("1".equals(tooltipInfos[4])){%>checked<%}%>> &nbsp;<%=SystemEnv.getHtmlLabelName(229, user.getLanguage())%>&nbsp;&nbsp;
				<input class="inputstyle" type="checkbox" name="tooltipInfos" <%if("1".equals(tooltipInfos[5])){%>checked<%}%>> &nbsp;<%=SystemEnv.getHtmlLabelName(882, user.getLanguage())%>&nbsp;&nbsp;
				<input class="inputstyle" type="checkbox" name="tooltipInfos" <%if("1".equals(tooltipInfos[6])){%>checked<%}%>> &nbsp;<%=SystemEnv.getHtmlLabelName(15525, user.getLanguage())%>&nbsp;&nbsp;
				<input type="hidden" id="tooltipInfo" name="tooltipInfo" value='<%=tooltipInfo %>' >
			</wea:item>
			<!-- 数据过滤规则 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(33984, user.getLanguage())%></wea:item>
			<wea:item attributes="{'samePair':'memberConflictChk'}">
				<SELECT class="InputStyle" name="dataRule" id="dataRule">
				  <option <%=dataRule == 1?"selected":""%> value="1"><%=SystemEnv.getHtmlLabelName(882, user.getLanguage())%></option>
				  <option <%=dataRule == 2?"selected":""%> value="2"><%=SystemEnv.getHtmlLabelName(15525, user.getLanguage())%></option>
				</SELECT>
				<SPAN>
			          <IMG  class="remindImg" src="/wechat/images/remind_wev8.png" align=absMiddle tit='<%=SystemEnv.getHtmlLabelName(33988, user.getLanguage())%>'>
			     </SPAN>
			</wea:item>
		</wea:group>
		
		<wea:group context='<%=SystemEnv.getHtmlLabelNames("20215,68", user.getLanguage())%>' attributes="{'itemAreaDisplay':'block'}">
			<!-- 提醒控制 -->
			<wea:item><%=SystemEnv.getHtmlLabelNames("18095,15148", user.getLanguage())%></wea:item>
			<wea:item>
				 <input tzCheckbox="true" class="inputstyle" type="checkbox" onclick="checkRemider()" id="showRemider" name="showRemider" value="1" <%if(showRemider == 1){%>checked<%}%>> &nbsp;
			</wea:item>
			
			<!-- 默认提醒方式 -->
			<wea:item attributes="{'samePair':'defaultRemiderChk'}"><%=SystemEnv.getHtmlLabelNames("149,18713", user.getLanguage())%></wea:item>
			<wea:item attributes="{'samePair':'defaultRemiderChk'}">
				<SELECT class="InputStyle" name="defaultRemider" id="defaultRemider">
				  <option <%=defaultRemider == 1?"selected":""%> value="1"><%=SystemEnv.getHtmlLabelName(19782, user.getLanguage())%></option>
				  <option <%=defaultRemider == 2?"selected":""%> value="2"><%=SystemEnv.getHtmlLabelName(17586, user.getLanguage())%></option>
				  <option <%=defaultRemider == 3?"selected":""%> value="3"><%=SystemEnv.getHtmlLabelName(18845, user.getLanguage())%></option>
				</SELECT>
			</wea:item>
		</wea:group>
		
		<wea:group context='<%=SystemEnv.getHtmlLabelNames("2211,83273", user.getLanguage())%>' attributes="{'itemAreaDisplay':'block'}">
			<!-- 日程附加信息 -->
		      <!-- 流程 -->
		      <wea:item><%=SystemEnv.getHtmlLabelName(18015, user.getLanguage())%></wea:item>
		      <wea:item>
		        <input  tzCheckbox="true" class="inputstyle" type="checkbox" id="infoWf" name="infoWf" value="1" <%if(infoWf == 1){%>checked<%}%>> &nbsp;
		      </wea:item>
			  <!-- 文档 -->
			  <wea:item><%=SystemEnv.getHtmlLabelName(58, user.getLanguage())%></wea:item>
		      <wea:item>
		        <input  tzCheckbox="true" class="inputstyle" type="checkbox" id="infoDoc" name="infoDoc" value="1" <%if(infoDoc == 1){%>checked<%}%>> &nbsp;
		      </wea:item>
		      <%if(isCrm){ %>
		      <!-- 客户 -->
		      <wea:item><%=SystemEnv.getHtmlLabelName(136, user.getLanguage())%></wea:item>
		      <wea:item>
		        <input  tzCheckbox="true" class="inputstyle" type="checkbox" id="infoCrm" name="infoCrm" value="1" <%if(infoCrm == 1){%>checked<%}%>> &nbsp;
		      </wea:item>
		      <%}
		      if(isProj){
		      %>
			  <!-- 项目 -->
			  <wea:item><%=SystemEnv.getHtmlLabelName(101, user.getLanguage())%></wea:item>
			  <wea:item>
				<input tzCheckbox="true" class="inputstyle" type="checkbox" id="infoPrj" name="infoPrj" value="1" <%if(infoPrj == 1){%>checked<%}%>> &nbsp;
			  </wea:item>
			  <!-- 任务 -->
			  <wea:item><%=SystemEnv.getHtmlLabelNames("101,1332",user.getLanguage())%></wea:item>
			  <wea:item>
			     <input tzCheckbox="true" class="inputstyle" type="checkbox" id="infoPrjTask" name="infoPrjTask" value="1" <%if(infoPrjTask == 1){%>checked<%}%>> &nbsp;
			  </wea:item>
			<%} %>
			<!-- 附件 -->
			  <wea:item><%=SystemEnv.getHtmlLabelName(156, user.getLanguage())%></wea:item>
		      <wea:item>
		         <input tzCheckbox="true" class=inputstyle type="checkbox" id="infoAccessory" name="infoAccessory" onclick="accessoryChangeNew('infoAccessory', 'infoAccessoryDirSP', 'infoAccessoryDirWarn')" value="1" <%if(infoAccessory == 1){%>checked<%}%>> &nbsp;
		      </wea:item>
		      <!-- 相关附件 -->
			  <wea:item><%=SystemEnv.getHtmlLabelName(22210, user.getLanguage())%></wea:item>
		      <wea:item>
		        <%
					String infoAccessoryDirSpan = "";
					if(!infoAccessoryDir.equals("")){
						String[] categoryArr = Util.TokenizerString2(infoAccessoryDir,",");
						try{
							infoAccessoryDirSpan = SecCategoryComInfo.getAllParentName(categoryArr[2],true);
						}catch(Exception e){
							infoAccessoryDirSpan = SecCategoryComInfo.getAllParentName(infoAccessoryDir,true);
						}
					}
				 %>
				<span id="infoAccessoryDirSP">
				<brow:browser viewType="0" name="infoAccessoryDir" browserValue='<%=infoAccessoryDir%>' 
										browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp"
										hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='2' width="400px"  _callbackParams="1" afterDelParams="1"
										completeUrl="/data.jsp?type=categoryBrowser" linkUrl="#" 
										browserSpanValue='<%=infoAccessoryDirSpan %>'></brow:browser>
			</span>
				<span id="infoAccessoryDirWarn" name="infoAccessoryDirWarn" ><font color=red>(<%=SystemEnv.getHtmlLabelName(32841, user.getLanguage())%>)</font></span>
		      </wea:item>
			 
		</wea:group>
		
		
		<wea:group context='<%=SystemEnv.getHtmlLabelName(32839, user.getLanguage())%>' attributes="{'itemAreaDisplay':'block'}">
			<!-- 相关交流附加信息 -->
			<!-- 流程 -->
		      <wea:item><%=SystemEnv.getHtmlLabelName(18015, user.getLanguage())%></wea:item>
		      <wea:item>
		        <input  tzCheckbox="true" class="inputstyle" type="checkbox" id="dscsWf" name="dscsWf" value="1" <%if(dscsWf == 1){%>checked<%}%>> &nbsp;
		      </wea:item>
			  <!-- 文档 -->
			  <wea:item><%=SystemEnv.getHtmlLabelName(58, user.getLanguage())%></wea:item>
		      <wea:item>
		        <input  tzCheckbox="true" class="inputstyle" type="checkbox" id="dscsDoc" name="dscsDoc" value="1" <%if(dscsDoc == 1){%>checked<%}%>> &nbsp;
		      </wea:item>
		      <%if(isCrm){ %>
		      <!-- 客户 -->
		      <wea:item><%=SystemEnv.getHtmlLabelName(136, user.getLanguage())%></wea:item>
		      <wea:item>
		        <input  tzCheckbox="true" class="inputstyle" type="checkbox" id="dscsCrm" name="dscsCrm" value="1" <%if(dscsCrm == 1){%>checked<%}%>> &nbsp;
		      </wea:item>
			   <%}
		      if(isProj){
		      %><!-- 项目 -->
			  <wea:item><%=SystemEnv.getHtmlLabelName(101, user.getLanguage())%></wea:item>
			  <wea:item>
				<input tzCheckbox="true" class="inputstyle" type="checkbox" id="dscsPrj" name="dscsPrj" value="1" <%if(dscsPrj == 1){%>checked<%}%>> &nbsp;
			  </wea:item>
			 <%} %>
			 <!-- 附件 -->
			  <wea:item><%=SystemEnv.getHtmlLabelName(156, user.getLanguage())%></wea:item>
		      <wea:item>
		         <input tzCheckbox="true" class=inputstyle type="checkbox" id="dscsAccessory" name="dscsAccessory" onclick="accessoryChangeNew('dscsAccessory', 'dscsAccessoryDirSP', 'dscsAccessoryDirWarn')" value="1" <%if(dscsAccessory == 1){%>checked<%}%>> &nbsp;
		      </wea:item>
		      <!-- 相关附件 -->
			  <wea:item><%=SystemEnv.getHtmlLabelName(22210, user.getLanguage())%></wea:item>
		      <wea:item>
		        <%
					String dscsAccessoryDirSpan = "";
					if(!dscsAccessoryDir.equals("")){
						String[] categoryArr = Util.TokenizerString2(dscsAccessoryDir,",");
						try{
							dscsAccessoryDirSpan = SecCategoryComInfo.getAllParentName(categoryArr[2],true);
						}catch(Exception e){
							dscsAccessoryDirSpan = SecCategoryComInfo.getAllParentName(dscsAccessoryDir,true);
						}
					}
				 %>
				<span id="dscsAccessoryDirSP">
				<brow:browser viewType="0" name="dscsAccessoryDir" browserValue='<%=dscsAccessoryDir%>' 
										browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp"
										hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='2' width="400px"  _callbackParams="1" afterDelParams="1"
										completeUrl="/data.jsp?type=categoryBrowser" linkUrl="#" 
										browserSpanValue='<%=dscsAccessoryDirSpan %>'></brow:browser></span>
				<span id="dscsAccessoryDirWarn" name="dscsAccessoryDirWarn" ><font color=red>(<%=SystemEnv.getHtmlLabelName(32841, user.getLanguage())%>)</font></span>
		      </wea:item>
			 
		</wea:group>
		
     </wea:layout>
</FORM>
<div class="selftip ">
	<div id="tooltipDiv" style="padding: 2px;padding-left: 4px;padding-right: 4px"></div>
</div>

</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>   
</body>
</html>
<script type='text/javascript' src='/js/timeline/lavalamp.min_wev8.js'></script>
<script type='text/javascript' src='/js/timeline/easing_wev8.js'></script>
<script language="javascript" src="/js/ecology8/meeting/jquery-ui-1.10.2.custom_wev8.js"></script>
<script language="javascript" src="/js/ecology8/meeting/jquery-ui-timepicker-addon_wev8.js"></script>
 <SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript">
function onShowTime1(spanname,inputname){
	var dads  = document.getElementById("meizzDateLayer2").style;
	setLastSelectTime(inputname);
	var th = spanname;
	var ttop  = spanname.offsetTop; 
	var thei  = spanname.clientHeight;
	var tleft = spanname.offsetLeft; 
	var ttyp  = spanname.type;       
	while (spanname = spanname.offsetParent){
		ttop += spanname.offsetTop; 
		tleft += spanname.offsetLeft;
	}
	dads.top  = ((ttyp == "image") ? ttop + thei : ttop + thei + 22)+"px";
	dads.left = tleft+"px";
	outObject = th;
	outValue = inputname;
	outButton = (arguments.length == 1) ? null : th;
	dads.display = '';
	outType = 0;
	bShow = true;
}

function checkTimeValid(objStartName, objEndName) {
	var start = $('#'+objStartName).val();
	var end = $('#'+objEndName).val();

	if ((start == null || start == "") || (end == null || end == ""))
		return false;

	if (start > end)
		return false;

	return true;
}

function checkTimeValidValue(start, end) {
	if ((start == null || start == "") || (end == null || end == ""))
		return false;

	if (start > end)
		return false;

	return true;
}

jQuery(document).ready(function(){
	
	$( "#slider-range" ).slider({
        range: true,
        min: 0,
        max: 23,
        values: [ $( "#timeRangeStart" ).val(), $( "#timeRangeEnd" ).val() ],
        slide: function( event, ui ) {
            $( "#amount" ).html(ui.values[ 0 ]+":00" + " - " + ui.values[ 1 ]+":00" );
            $( "#timeRangeStart" ).val(ui.values[ 0 ]);
            $( "#timeRangeEnd" ).val(ui.values[ 1 ]);
        }
    });
    $( "#amount" ).html($( "#timeRangeStart" ).val() + ":00" +" - " + $( "#timeRangeEnd" ).val()+":00" );
    var amAndPm =  $GetEle("amAndPm");
	if(amAndPm.checked){
		showEle("amAndPm");
	} else {
		hideEle("amAndPm", true);
	}
	checkRemider();
	
	jQuery(".remindImg").hover(function(){
		$('#tooltipDiv').html(jQuery(this).attr("tit"));	
		var   x,y;   
		var oRect   =   this.getBoundingClientRect();   
		x=oRect.left   
		y=oRect.top   
 		if(y>$('.zDialog_div_content').height()){
 			y=$('.zDialog_div_content').height()+20;
 		}
    	$('.selftip').css("left",x+30);
    	$('.selftip').css("top",y-50);
	},function(){
		 $('#tooltipDiv').html("");	
		 $('.selftip').css("left",-999);
    	$('.selftip').css("top",-999);
	});
	accessoryChangeNew('infoAccessory', 'infoAccessoryDirSP', 'infoAccessoryDirWarn');
	accessoryChangeNew('dscsAccessory', 'dscsAccessoryDirSP', 'dscsAccessoryDirWarn');
});


function setChange(){
	jQuery("hasChanged").value="true";
}
//tooltip显示字段
function checkTooltipInfo(){
	var obj=$('input[name="tooltipInfos"]');
	var checkV="";
	var tempV=0;
	for(var key in obj){
		if(isNaN(key)) continue;
		if($(obj[key]).attr("checked")){
			tempV=1;
		}else{
			tempV=0;
		}
		checkV+=checkV==""?tempV:"^"+tempV
	}
	$('#tooltipInfo').val(checkV);
}
//日程显示信息
function checkShowInfo(){
	var obj=$('input[name="showInfos"]');
	var isCheck=false;
	var checkV="";
	var tempV=0;
	for(var key in obj){
		if(isNaN(key)) continue;
		if($(obj[key]).attr("checked")){
			isCheck=true;
			tempV=1;
		}else{
			tempV=0;
		}
		checkV+=checkV==""?tempV:"^"+tempV
	}
	$('#showInfo').val(checkV);
	return isCheck;
}

function submitData(){
	var checkfield = "";
	var amAndPm =  $GetEle("amAndPm");
	if(amAndPm.checked){
		checkfield+=",amStart,amEnd,pmStart,pmEnd";
	}
	var infoAccessory=$GetEle("infoAccessory");
	var dscsAccessory=$GetEle("dscsAccessory");
	if(infoAccessory.checked){
		checkfield+=",infoAccessoryDir";
	}
	var tpcAttch =  $GetEle("tpcAttch");
	if(dscsAccessory.checked){
		checkfield+=",dscsAccessoryDir";
	}
	if(!checkShowInfo()){
		Dialog.alert("<%=SystemEnv.getHtmlLabelName(33989, user.getLanguage())%>");
		return false;
	}
	checkTooltipInfo();
	 
    if(checkfield == ""||check_form(document.weaverA,checkfield)){
    	if(amAndPm.checked){
    	 	var timeRangeStart=$("#timeRangeStart").val();
    	 	timeRangeStart=timeRangeStart<10?"0"+timeRangeStart+":00":timeRangeStart+":00";
    	 	var timeRangeEnd=$("#timeRangeEnd").val();
    	 	timeRangeEnd=timeRangeEnd<10?"0"+timeRangeEnd+":00":timeRangeEnd+":00";
    	 	if(!checkTimeValidValue(timeRangeStart,$('#amStart').val())){
    	 		Dialog.alert("<%=SystemEnv.getHtmlLabelName(33990, user.getLanguage())%>");
    			return false;
    	 	}
    	 	if(!checkTimeValid('amStart','amEnd')){
    	 		Dialog.alert("<%=SystemEnv.getHtmlLabelName(33991, user.getLanguage())%>");
    			return false;
    	 	}
    	 	if(!checkTimeValid('amEnd','pmStart')){
    	 		Dialog.alert("<%=SystemEnv.getHtmlLabelName(33992, user.getLanguage())%>");
    			return false;
    	 	}
    	 	if(!checkTimeValid('pmStart','pmEnd')){
    	 		Dialog.alert("<%=SystemEnv.getHtmlLabelName(33993, user.getLanguage())%>");
    			return false;
    	 	}
    	 	if(!checkTimeValidValue($('#pmEnd').val(),timeRangeEnd)){
    	 		Dialog.alert("<%=SystemEnv.getHtmlLabelName(33994, user.getLanguage())%>");
    			return false;
    	 	}
    	}
		$('#weaverA').submit();
	}
}


function checkChanged(obj){
	var name = $(obj).attr("id");
	if(obj.checked){
		showEle(name);
	} else {
		hideEle(name, true);
	}
}


function checkRemider(){
	var remider =  $GetEle("showRemider");
	if(remider.checked){
		showEle("defaultRemiderChk");
	} else {
		hideEle("defaultRemiderChk", true);
	}
}

function accessoryChangeNew(inputname, brwspan, warnspan){
    var obj =  $GetEle(inputname);
    if(obj.checked){
        $("#"+brwspan).css("display","");
        $("#"+warnspan).css("display","none");
    }else{
        $("#"+brwspan).css("display","none");
        $("#"+warnspan).css("display","");
    }
}
</script>
