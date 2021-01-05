
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="SubCompanyComInfo"	class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<%
	boolean canedit = false;

	int detachable = Util.getIntValue(String.valueOf(session.getAttribute("meetingdetachable")), 0);
	int subcompanyid = -1;
	//分权模式下参数传过来的选中的分部
	int subid = Util.getIntValue(request.getParameter("subCompanyId"));
	if (subid < 0) {
		subid = user.getUserSubCompany1();
	}
	ArrayList subcompanylist = SubCompanyComInfo.getRightSubCompany(
			user.getUID(), "meetingmanager:all");
	int operatelevel = CheckSubCompanyRight
			.ChkComRightByUserRightCompanyId(user.getUID(),
					"meetingmanager:all", subid);
	if (detachable == 1) {
		if (subid != 0 && operatelevel < 1) {
			canedit = false;
		} else {
			canedit = true;
		}
		subcompanyid = subid;
	} else {
		if (HrmUserVarify.checkUserRight("meetingmanager:all", user)) {
			canedit = true;
		}
	}
	if (!canedit) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	
	int id	= -1;
	int dscsDoc	= -1;
	int dscsWf	= -1;
	int dscsCrm	= -1;
	int dscsPrj	= -1;
	int dscsTsk	= -1;
	int dscsAttch	= -1;
	String dscsAttchCtgry	= "";
	int tpcDoc	= -1;
	int tpcWf	= -1;
	int tpcCrm	= -1;
	int tpcPrj	= -1;
	int tpcTsk	= -1;
	int tpcAttch	= -1;
	String tpcAttchCtgry	= "";
	String mtngAttchCtgry	= "";
	int callerPrm	= -1;
	int contacterPrm	= -1;
	int createrPrm	= -1;
	int roomConflictChk	= -1;
	int roomConflict	= -1;
	int memberConflictChk	= -1;
	int memberConflict	= -1;
	int timeRangeStart=0;
	int timeRangeEnd=24;
	int tpcprjflg = 0;
	int tpccrmflg = 0;
	int days = 2;
	int zqhyzdkd = 0;
	
	int recArrive=0;
	int recBook=0;
	int recReturn=0;
	int recRemark=0; 
	int dspUnit=1;  
	
	int createMeetingRemindChk=1;
	int cancelMeetingRemindChk=1;
	int reMeetingRemindChk=1;
	int canChange=0;
	RecordSet.executeSql("select * from MeetingSet order by id");
	if(RecordSet.next()){
		id	= RecordSet.getInt("id");
		dscsDoc	= Util.getIntValue(RecordSet.getString("dscsDoc"), 1);
		dscsWf	= Util.getIntValue(RecordSet.getString("dscsWf"), 1);
		dscsCrm	= Util.getIntValue(RecordSet.getString("dscsCrm"), 1);
		dscsPrj	= Util.getIntValue(RecordSet.getString("dscsPrj"), 1);
		dscsTsk	= Util.getIntValue(RecordSet.getString("dscsTsk"), 1);
		dscsAttch	= Util.getIntValue(RecordSet.getString("dscsAttch"), 1);
		dscsAttchCtgry	= Util.null2String(RecordSet.getString("dscsAttchCtgry"));
		tpcDoc	= Util.getIntValue(RecordSet.getString("tpcDoc"), 1);
		tpcWf	= Util.getIntValue(RecordSet.getString("tpcWf"), 1);
		tpcCrm	= Util.getIntValue(RecordSet.getString("tpcCrm"), 1);
		tpcPrj	= Util.getIntValue(RecordSet.getString("tpcPrj"), 1);
		tpcTsk	= Util.getIntValue(RecordSet.getString("tpcTsk"), 1);
		tpcAttch	= Util.getIntValue(RecordSet.getString("tpcAttch"), 1);
		tpcAttchCtgry	= Util.null2String(RecordSet.getString("tpcAttchCtgry"));
		mtngAttchCtgry	= Util.null2String(RecordSet.getString("mtngAttchCtgry"));
		callerPrm	= Util.getIntValue(RecordSet.getString("callerPrm"), 1);
		contacterPrm	= Util.getIntValue(RecordSet.getString("contacterPrm"), 1);
		createrPrm	= Util.getIntValue(RecordSet.getString("createrPrm"), 1);
		roomConflictChk	= Util.getIntValue(RecordSet.getString("roomConflictChk"), 1);
		roomConflict	= Util.getIntValue(RecordSet.getString("roomConflict"), 1);
		memberConflictChk	= Util.getIntValue(RecordSet.getString("memberConflictChk"), 1);
		memberConflict	= Util.getIntValue(RecordSet.getString("memberConflict"), 1);
		timeRangeStart	= Util.getIntValue(RecordSet.getString("timeRangeStart"), 0);
		timeRangeEnd	= Util.getIntValue(RecordSet.getString("timeRangeEnd"), 23);
		tpcprjflg = Util.getIntValue(RecordSet.getString("tpcprjflg"), 0);
		tpccrmflg = Util.getIntValue(RecordSet.getString("tpccrmflg"), 0);
		days = Util.getIntValue(RecordSet.getString("days"), 2);
		recArrive = Util.getIntValue(RecordSet.getString("recArrive"), 0);
		recBook = Util.getIntValue(RecordSet.getString("recBook"), 0);
		recReturn = Util.getIntValue(RecordSet.getString("recReturn"), 0);
		recRemark = Util.getIntValue(RecordSet.getString("recRemark"), 0);
		dspUnit = Util.getIntValue(RecordSet.getString("dspUnit"), 1);
		createMeetingRemindChk = Util.getIntValue(RecordSet.getString("createMeetingRemindChk"), 1);
		cancelMeetingRemindChk = Util.getIntValue(RecordSet.getString("cancelMeetingRemindChk"), 1);
		reMeetingRemindChk = Util.getIntValue(RecordSet.getString("reMeetingRemindChk"), 1);
		zqhyzdkd = Util.getIntValue(RecordSet.getString("zqhyzdkd"), 0);
		canChange = Util.getIntValue(RecordSet.getString("canChange"), 0);
	}
%>
<html>
	<head>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link type="text/css" href="/js/tabs/css/e8tabs_wev8.css" rel="stylesheet" />
		<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
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
		</style>
	</head>
	<%
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(32838, user.getLanguage());
		String needfav = "1";
		String needhelp = "";
	%>
	<BODY >
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())
					+ ",javascript:submitData(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
						<tr>
							<td>/
							</td>
							<td class="rightSearchSpan"
								style="text-align: right; width: 400px !important">
								<input type="button"
									value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"
									class="e8_btn_top middle" onclick="submitData()" />
								<span
									title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>"  class="cornerMenu middle"></span>
							</td>
						</tr>
					</table>
					<div id="tabDiv">
						<span style="width:10px"></span>
						<span id="hoverBtnSpan" class="hoverBtnSpan"> 
							<span id="edit" onclick="" class="selectedTitle" ><%=SystemEnv.getHtmlLabelName(31811, user.getLanguage())%></span>
						</span>
					</div>
					    <div id="rightBox" class="e8_rightBox">
					    </div>
						<FORM id=weaverA name=weaverA action="MeetingSetOperation.jsp" method="post">
							<input type="hidden" value="false" name="hasChanged" id="hasChanged" />
							<input type="hidden" value="<%=id%>" name="id" id="id" />
							<INPUT class=inputstyle id=subid type=hidden name=subid value="<%=subid%>" />
							<wea:layout  type="2Col">
								
								<wea:group context='<%=SystemEnv.getHtmlLabelNames("2103,32687", user.getLanguage())%>' attributes="{'class':\"e8_title e8_title_1\"}">
								  <!-- 附件上传目录 -->
								  <wea:item><%=SystemEnv.getHtmlLabelName(22210, user.getLanguage())%></wea:item>
							      <wea:item>
							        <%
									String mtngAttchCtgryspan = "";
									if(!mtngAttchCtgry.equals("")){
									         String[] categoryArr = Util.TokenizerString2(mtngAttchCtgry,",");
									         try{
										        /* mtngAttchCtgryspan += "/"+MainCategoryComInfo.getMainCategoryname(categoryArr[0]);
										         mtngAttchCtgryspan += "/"+SubCategoryComInfo.getSubCategoryname(categoryArr[1]);
										         mtngAttchCtgryspan += "/"+SecCategoryComInfo.getSecCategoryname(categoryArr[2]);
										         */
									        	 mtngAttchCtgryspan = SecCategoryComInfo.getAllParentName(categoryArr[2],true);
									         }catch(Exception e){
									        	 mtngAttchCtgryspan = SecCategoryComInfo.getAllParentName(mtngAttchCtgry,true);
									         }
										}
									 %>
									    <brow:browser viewType="0" name="mtngAttchCtgry" browserValue='<%=mtngAttchCtgry %>' 
										browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp"
										hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1' width="400px"  _callback="showCalaogCallBk" _callbackParams="0" afterDelCallback="showCalaogAftCallBk" afterDelParams="0"
										completeUrl="/data.jsp?type=categoryBrowser" linkUrl="#" 
										browserSpanValue='<%=mtngAttchCtgryspan %>'></brow:browser>
									<!-- 
										<button type=button  class=Browser onClick="onShowCatalog('mtngAttchCtgryspan','mtngAttchCtgry', 0)"></BUTTON>
									    <span id="mtngAttchCtgryspan" name="mtngAttchCtgryspan"><%=mtngAttchCtgryspan %></span>
									    <input type=hidden id='mtngAttchCtgry' name='mtngAttchCtgry' value="<%=mtngAttchCtgry %>">
									  -->
							      </wea:item>
							     <wea:item><%=SystemEnv.getHtmlLabelNames("115,127682", user.getLanguage()) %></wea:item>
							      <wea:item>
							      		<input tzCheckbox="true" class=inputstyle type="checkbox" onclick="checkChanged(this)" id="canChange" name="canChange" value="1" <%if(canChange == 1){%>checked<%}%>> &nbsp;<%=SystemEnv.getHtmlLabelName(128673,user.getLanguage()) %>
								  </wea:item>
							    </wea:group>
							   
							    <wea:group context='<%=SystemEnv.getHtmlLabelName(32844, user.getLanguage())%>' attributes="{'class':\"e8_title e8_title_1\",'itemAreaDisplay':\"block\"}">
								  <!-- 会议召集人 -->
								  <!--
									<SELECT class=InputStyle name="callerPrm" id="callerPrm">
									  <option value="1"><%=SystemEnv.getHtmlLabelName(32845, user.getLanguage())%></option>
									  <option value="2"><%=SystemEnv.getHtmlLabelName(32846, user.getLanguage())%></option>
									  <option selected  value="3"><%=SystemEnv.getHtmlLabelName(18934, user.getLanguage())%></option>
									</SELECT>
								  -->
							      <!-- 会议联系人 -->
							      <wea:item><%=SystemEnv.getHtmlLabelName(32847, user.getLanguage())%></wea:item>
							      <wea:item>
							        <SELECT class=InputStyle name="contacterPrm" id="contacterPrm">
									  <option <% if(contacterPrm == 1) {%>selected <%} %> value="1"><%=SystemEnv.getHtmlLabelName(32845, user.getLanguage())%></option>
									  <option <% if(contacterPrm == 3) {%>selected <%} %> value="3"><%=SystemEnv.getHtmlLabelName(18934, user.getLanguage())%></option>
									</SELECT>
							      </wea:item>
								  <!-- 会议创建人 -->
							      <wea:item><%=SystemEnv.getHtmlLabelName(32848, user.getLanguage())%></wea:item>
							      <wea:item>
							        <SELECT class=InputStyle name="createrPrm" id="createrPrm">
									 <option <% if(createrPrm == 1) {%>selected <%} %> value="1"><%=SystemEnv.getHtmlLabelName(32845, user.getLanguage())%></option>
									  <option <% if(createrPrm == 2) {%>selected <%} %> value="2"><%=SystemEnv.getHtmlLabelName(32846, user.getLanguage())%></option>
									  <option <% if(createrPrm == 3) {%>selected <%} %> value="3"><%=SystemEnv.getHtmlLabelName(18934, user.getLanguage())%></option>
									</SELECT>
							      </wea:item>
							    </wea:group>
								<wea:group context='<%=SystemEnv.getHtmlLabelName(32849, user.getLanguage())%>' attributes="{'class':\"e8_title e8_title_1\",'itemAreaDisplay':\"block\"}">
									<!-- 会议室冲突提醒 -->
									<wea:item><%=SystemEnv.getHtmlLabelName(32850, user.getLanguage())%></wea:item>
									<wea:item>
										<input tzCheckbox="true" class=inputstyle type="checkbox" onclick="checkChanged(this)" id="roomConflictChk" name="roomConflictChk" value="1" <%if(roomConflictChk == 1){%>checked<%}%>> &nbsp;
									</wea:item>
									<!-- 冲突时处理方式 -->
									<wea:item attributes="{'samePair':\"roomConflictChk\"}"><%=SystemEnv.getHtmlLabelName(32851, user.getLanguage())%></wea:item>
									<wea:item attributes="{'samePair':\"roomConflictChk\"}">
										<SELECT class=InputStyle name="roomConflict" id="roomConflict">
										  <option <% if(roomConflict == 1) {%>selected <%} %> value="1"><%=SystemEnv.getHtmlLabelName(32852, user.getLanguage())%></option>
										  <option <% if(roomConflict == 2) {%>selected <%} %> value="2"><%=SystemEnv.getHtmlLabelName(32853, user.getLanguage())%></option>
										</SELECT>
									</wea:item>
									<!-- 参会人冲突提醒 -->
									<wea:item><%=SystemEnv.getHtmlLabelName(32854, user.getLanguage())%></wea:item>
									<wea:item>
										 <input tzCheckbox="true" class=inputstyle type="checkbox" onclick="checkChanged(this)" id="memberConflictChk" name="memberConflictChk" value="1" <%if(memberConflictChk == 1){%>checked<%}%>> &nbsp;
									</wea:item>
									<!-- 冲突时处理方式 -->
									<wea:item attributes="{'samePair':\"memberConflictChk\"}"><%=SystemEnv.getHtmlLabelName(32851, user.getLanguage())%></wea:item>
									<wea:item attributes="{'samePair':\"memberConflictChk\"}">
										<SELECT class=InputStyle name="memberConflict" id="memberConflict">
										  <option <% if(memberConflict == 1) {%>selected <%} %> value="1"><%=SystemEnv.getHtmlLabelName(32852, user.getLanguage())%></option>
										  <option <% if(memberConflict == 2) {%>selected <%} %> value="2"><%=SystemEnv.getHtmlLabelName(32853, user.getLanguage())%></option>
										</SELECT>
									</wea:item>
								</wea:group>
								
								<wea:group context='<%=SystemEnv.getHtmlLabelNames("15881,33549", user.getLanguage())%>' attributes="{'itemAreaDisplay':\"block\"}">
									<!-- 会议室日使用情况显示时间段 -->
									<wea:item><%=SystemEnv.getHtmlLabelName(124949, user.getLanguage())%></wea:item>
									<wea:item>
										<div>
											<div id = "slider-range" style="float:left;width: 200px;"></div><div id="amount" style="float:left;margin-left:30px;"></div>
										</div>
										<input type="hidden" id="timeRangeStart" name="timeRangeStart" value="<%=timeRangeStart %>">
										<input type="hidden" id="timeRangeEnd" name="timeRangeEnd" value="<%=timeRangeEnd %>">
									</wea:item>
									<wea:item><%=SystemEnv.getHtmlLabelName(124950, user.getLanguage())%></wea:item>
									<wea:item>
										<INPUT type="radio" value="1" name="dspUnit" <%if (dspUnit==1) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(124951,user.getLanguage())%>
										&nbsp;&nbsp;
										<INPUT type="radio" value="2" name="dspUnit" <%if (dspUnit==2) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(124952,user.getLanguage())%>
									</wea:item>
									
									 
								</wea:group>
								<wea:group context='<%=SystemEnv.getHtmlLabelNames("33277,68", user.getLanguage())%>' attributes="{'itemAreaDisplay':\"block\"}">
									<!-- 周期会议生成的提前天数 -->
									<wea:item><%=SystemEnv.getHtmlLabelNames("33277,15413", user.getLanguage())%></wea:item>
									<wea:item>
										<%=SystemEnv.getHtmlLabelName(17548, user.getLanguage())%>
										<input style="width:40px" class="inputStyle" type=text name="days" id="days" size=5 onKeyPress="ItemCount_KeyPress_Plus()" value="<%=days %>" onBlur="checkDays(this);" />
										<%=SystemEnv.getHtmlLabelName(82896, user.getLanguage())%>
									</wea:item>
									<wea:item><%=SystemEnv.getHtmlLabelName(129691, user.getLanguage())%></wea:item>
									<wea:item>
										<input style="width:40px" class="inputStyle" type=text name="zqhyzdkd" id="zqhyzdkd" size=5 onKeyPress="ItemCount_KeyPress_Plus()" value="<%=zqhyzdkd %>" onBlur="checkDays(this);" />
										<%=SystemEnv.getHtmlLabelName(32751, user.getLanguage())%>
									</wea:item>
									 
								</wea:group>
								<wea:group context='<%=SystemEnv.getHtmlLabelName(126015, user.getLanguage())%>' attributes="{'itemAreaDisplay':\"block\"}">
									<!-- 会议建立提醒 -->
									<wea:item><%=SystemEnv.getHtmlLabelName(126012, user.getLanguage())%></wea:item>
									<wea:item>
										<input tzCheckbox="true" class=inputstyle type="checkbox" onclick="checkChanged(this)" id="createMeetingRemindChk" name="createMeetingRemindChk" value="1" <%if(createMeetingRemindChk == 1){%>checked<%}%>> &nbsp;<%=SystemEnv.getHtmlLabelName(126023, user.getLanguage())%>
									</wea:item>
									<!-- 会议取消提醒 -->
									<wea:item><%=SystemEnv.getHtmlLabelName(126013, user.getLanguage())%></wea:item>
									<wea:item>
										<input tzCheckbox="true" class=inputstyle type="checkbox" onclick="checkChanged(this)" id="cancelMeetingRemindChk" name="cancelMeetingRemindChk" value="1" <%if(cancelMeetingRemindChk == 1){%>checked<%}%>> &nbsp;<%=SystemEnv.getHtmlLabelName(126024, user.getLanguage())%>
									</wea:item>
									<!-- 会议回执提醒 -->
									<wea:item><%=SystemEnv.getHtmlLabelName(126014, user.getLanguage())%></wea:item>
									<wea:item>
										<input tzCheckbox="true" class=inputstyle type="checkbox" onclick="checkChanged(this)" id="reMeetingRemindChk" name="reMeetingRemindChk" value="1" <%if(reMeetingRemindChk == 1){%>checked<%}%>> &nbsp;<%=SystemEnv.getHtmlLabelName(126025, user.getLanguage())%>
									</wea:item>
									 
								</wea:group>
								<wea:group context='<%=SystemEnv.getHtmlLabelName(32842, user.getLanguage())%>' attributes="{'class':\"e8_title e8_title_1\"}">
								  <!-- 文档 -->
								  <wea:item><%=SystemEnv.getHtmlLabelName(58, user.getLanguage())%></wea:item>
							      <wea:item>
							        <input  tzCheckbox="true" class=inputstyle type="checkbox" id="tpcDoc" name="tpcDoc" value="1" <%if(tpcDoc == 1){%>checked<%}%>> &nbsp;
							      </wea:item>
							      <!-- 流程 -->
							      <wea:item><%=SystemEnv.getHtmlLabelName(18015, user.getLanguage())%></wea:item>
							      <wea:item>
							        <input  tzCheckbox="true" class=inputstyle type="checkbox" id="tpcWf" name="tpcWf" value="1" <%if(tpcWf == 1){%>checked<%}%>> &nbsp;
							      </wea:item>
							      <!-- 客户 -->
							      <wea:item><%=SystemEnv.getHtmlLabelName(136, user.getLanguage())%></wea:item>
							      <wea:item>
							        <input  tzCheckbox="true" class=inputstyle type="checkbox" id="tpcCrm" name="tpcCrm" value="1" <%if(tpcCrm == 1){%>checked<%}%>> &nbsp;
							      </wea:item>
								  <!-- 项目 -->
								  <wea:item><%=SystemEnv.getHtmlLabelName(101, user.getLanguage())%></wea:item>
								  <wea:item>
									<input tzCheckbox="true" class=inputstyle type="checkbox" id="tpcPrj" name="tpcPrj" value="1" <%if(tpcPrj == 1){%>checked<%}%>> &nbsp;
								  </wea:item>
								  <!-- 任务 -->
								  <wea:item><%=SystemEnv.getHtmlLabelName(1332, user.getLanguage())%></wea:item>
								  <wea:item>
								     <input tzCheckbox="true" class=inputstyle type="checkbox" id="tpcTsk" name="tpcTsk" value="1" <%if(tpcTsk == 1){%>checked<%}%>> &nbsp;
								  </wea:item>
								  
								  <!-- 附件 -->
								  <wea:item><%=SystemEnv.getHtmlLabelName(156, user.getLanguage())%></wea:item>
								  <wea:item>
									 <input tzCheckbox="true" class=inputstyle type="checkbox" id="tpcAttch" name="tpcAttch" onclick="attchChangeNew('tpcAttch', 'tpcAttchBrwSP', 'tpcAttchWarn')" value="1" <%if(tpcAttch == 1){%>checked<%}%>> &nbsp;
								  </wea:item>
								  <!-- 附件上传目录 -->
								  <wea:item><%=SystemEnv.getHtmlLabelName(22210, user.getLanguage())%></wea:item>
								  <wea:item>
									<%
									String tpcAttchCtgryspan = "";
									if(!tpcAttchCtgry.equals("")){
									         String[] categoryArr = Util.TokenizerString2(tpcAttchCtgry,",");
									         try{
										         /*tpcAttchCtgryspan += "/"+MainCategoryComInfo.getMainCategoryname(categoryArr[0]);
										         tpcAttchCtgryspan += "/"+SubCategoryComInfo.getSubCategoryname(categoryArr[1]);
										         tpcAttchCtgryspan += "/"+SecCategoryComInfo.getSecCategoryname(categoryArr[2]);
										         */
									        	 tpcAttchCtgryspan = SecCategoryComInfo.getAllParentName(categoryArr[2],true);
									         }catch(Exception e){
									        	 tpcAttchCtgryspan = SecCategoryComInfo.getAllParentName(tpcAttchCtgry,true);
									         }
									   	}
									 %>
									 	<span id="tpcAttchBrwSP">
									    <brow:browser viewType="0" name="tpcAttchCtgry" browserValue='<%=tpcAttchCtgry %>' 
										browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp"
										hasInput="true"  isSingle="true" hasBrowser ="true" isMustInput='2' width="400px"  _callback="showCalaogCallBk" _callbackParams="1"  afterDelCallback="showCalaogAftCallBk" afterDelParams="1"
										completeUrl="/data.jsp?type=categoryBrowser" linkUrl="#" 
										browserSpanValue='<%=tpcAttchCtgryspan %>'></brow:browser>
										</span>
									    <span id="tpcAttchWarn" name="tpcAttchWarn" ><font color=red>(<%=SystemEnv.getHtmlLabelName(32841, user.getLanguage())%>)</font></span>
								 </wea:item>
							    </wea:group>
								
								<wea:group context='<%=SystemEnv.getHtmlLabelName(32839, user.getLanguage())%>' attributes="{'class':\"e8_title e8_title_1\"}">
								  <!-- 文档 -->
								  <wea:item><%=SystemEnv.getHtmlLabelName(58, user.getLanguage())%></wea:item>
							      <wea:item>
							        <input  tzCheckbox="true" class=inputstyle type="checkbox"  id="dscsDoc" name="dscsDoc" value="1" <%if(dscsDoc == 1){%>checked<%}%>> &nbsp;
							      </wea:item>
							      <!-- 流程 -->
							      <wea:item><%=SystemEnv.getHtmlLabelName(18015, user.getLanguage())%></wea:item>
							      <wea:item>
							        <input  tzCheckbox="true" class=inputstyle type="checkbox" id="dscsWf" name="dscsWf" value="1" <%if(dscsWf == 1){%>checked<%}%>> &nbsp;
							      </wea:item>
							      <!-- 客户 -->
							      <wea:item><%=SystemEnv.getHtmlLabelName(136, user.getLanguage())%></wea:item>
							      <wea:item>
							        <input  tzCheckbox="true" class=inputstyle type="checkbox" id="dscsCrm" name="dscsCrm" value="1" <%if(dscsCrm == 1){%>checked<%}%>> &nbsp;
							      </wea:item>
								  <!-- 项目 -->
								  <wea:item><%=SystemEnv.getHtmlLabelName(101, user.getLanguage())%></wea:item>
								  <wea:item>
									<input tzCheckbox="true" class=inputstyle type="checkbox" id="dscsPrj" name="dscsPrj" value="1" <%if(dscsPrj == 1){%>checked<%}%>> &nbsp;
								  </wea:item>
								  <!-- 任务 -->
								  <wea:item><%=SystemEnv.getHtmlLabelName(1332, user.getLanguage())%></wea:item>
								  <wea:item>
								     <input  tzCheckbox="true" class=inputstyle type="checkbox" id="dscsTsk" name="dscsTsk" value="1" <%if(dscsTsk == 1){%>checked<%}%>> &nbsp;
								  </wea:item>
								  
								  <!-- 附件 -->
								  <wea:item><%=SystemEnv.getHtmlLabelName(156, user.getLanguage())%></wea:item>
								  <wea:item>
									 <input  tzCheckbox="true" class=inputstyle type="checkbox" id="dscsAttch" onclick="attchChangeNew('dscsAttch', 'dscsAttchBrwSP',  'dscsAttchWarn')" name="dscsAttch" value="1" <%if(dscsAttch == 1){%>checked<%}%>> &nbsp;
								  </wea:item>
								  <!-- 附件上传目录 -->
								  <wea:item><%=SystemEnv.getHtmlLabelName(22210, user.getLanguage())%></wea:item>
								  <wea:item>
									<%
									String dscsAttchCtgryspan = "";
									if(!dscsAttchCtgry.equals("")){
									         String[] categoryArr = Util.TokenizerString2(dscsAttchCtgry,",");
									         try{
										         /*dscsAttchCtgryspan += "/"+MainCategoryComInfo.getMainCategoryname(categoryArr[0]);
										         dscsAttchCtgryspan += "/"+SubCategoryComInfo.getSubCategoryname(categoryArr[1]);
										         dscsAttchCtgryspan += "/"+SecCategoryComInfo.getSecCategoryname(categoryArr[2]);
										         */
									        	 dscsAttchCtgryspan = SecCategoryComInfo.getAllParentName(categoryArr[2],true);
											}catch(Exception e){
												dscsAttchCtgryspan = SecCategoryComInfo.getAllParentName(dscsAttchCtgry,true);
											}
										}
									 %>
									 <!-- 
										<button id="dscsAttchBrw" name="dscsAttchBrw" type=button  class=Browser onClick="onShowCatalog('dscsAttchCtgryspan','dscsAttchCtgry', 1)" ></BUTTON>
									    <span id="dscsAttchCtgryspan" name="dscsAttchCtgryspan"><%if(!"".equals(dscsAttchCtgry)){%><%=dscsAttchCtgryspan %><%} else { %> <IMG src="/images/BacoError_wev8.gif" align=absMiddle><%} %></span>
									    <input type=hidden id='dscsAttchCtgry' name='dscsAttchCtgry' value='<%=dscsAttchCtgry %>'/>
									    -->
									    <span id="dscsAttchBrwSP">
									    <brow:browser viewType="0" name="dscsAttchCtgry" browserValue='<%=dscsAttchCtgry %>' 
										browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp"
										hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='2' width="400px" _callback="showCalaogCallBk" _callbackParams="1"  afterDelCallback="showCalaogAftCallBk" afterDelParams="1"
										completeUrl="/data.jsp?type=categoryBrowser" linkUrl="#" 
										browserSpanValue='<%=dscsAttchCtgryspan %>'></brow:browser>
										</span>
									    <span id="dscsAttchWarn" name="dscsAttchWarn" ><font color=red>(<%=SystemEnv.getHtmlLabelName(32841, user.getLanguage())%>)</font></span>
								 </wea:item>
							   </wea:group>
							   <wea:group context='<%=SystemEnv.getHtmlLabelName(2160, user.getLanguage())%>' attributes="{'class':'e8_title e8_title_1'}">
								  <!-- 到达时间 -->
								  <wea:item><%=SystemEnv.getHtmlLabelName(2196, user.getLanguage())%></wea:item>
							      <wea:item>
							        <input  tzCheckbox="true" class=inputstyle type="checkbox"  id="recArrive" name="recArrive" value="1" <%if(recArrive == 1){%>checked<%}%>> &nbsp;
							      </wea:item>
							      <!-- 订房信息 -->
							      <wea:item><%=SystemEnv.getHtmlLabelName(82460, user.getLanguage())%></wea:item>
							      <wea:item>
							        <input  tzCheckbox="true" class=inputstyle type="checkbox" id="recBook" name="recBook" value="1" <%if(recBook == 1){%>checked<%}%>> &nbsp;
							      </wea:item>
							      <!-- 回程信息 -->
							      <wea:item><%=SystemEnv.getHtmlLabelName(82461, user.getLanguage())%></wea:item>
							      <wea:item>
							        <input  tzCheckbox="true" class=inputstyle type="checkbox" id="recReturn" name="recReturn" value="1" <%if(recReturn == 1){%>checked<%}%>> &nbsp;
							      </wea:item>
								  <!-- 备注信息 -->
								  <wea:item><%=SystemEnv.getHtmlLabelName(22265, user.getLanguage())%></wea:item>
								  <wea:item>
									<input tzCheckbox="true" class=inputstyle type="checkbox" id="recRemark" name="recRemark" value="1" <%if(recRemark == 1){%>checked<%}%>> &nbsp;
								  </wea:item>
							   </wea:group>
                            </wea:layout>
						</FORM>
	</body>
</html>
<script src="/js/tabs/jquery.tabs_wev8.js"></script>

<script type='text/javascript' src='/js/timeline/lavalamp.min_wev8.js'></script>
<script type='text/javascript' src='/js/timeline/easing_wev8.js'></script>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<script language="javascript" src="/js/ecology8/meeting/jquery-ui-1.10.2.custom_wev8.js"></script>
<script language="javascript" src="/js/ecology8/meeting/jquery-ui-timepicker-addon_wev8.js"></script>
 
<script type="text/javascript">
jQuery(document).ready(function(){
	
	//attchChange('dscsAttch', 'dscsAttchBrw', 'dscsAttchCtgryspan', 'dscsAttchWarn');
	//attchChange('tpcAttch', 'tpcAttchBrw','tpcAttchCtgryspan', 'tpcAttchWarn');
	attchChangeNew('dscsAttch', 'dscsAttchBrwSP',  'dscsAttchWarn');
	attchChangeNew('tpcAttch', 'tpcAttchBrwSP', 'tpcAttchWarn');
	
	checkChanged($GetEle("roomConflictChk"));
	checkChanged($GetEle("memberConflictChk"));
	
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

});


function setChange(){
	jQuery("hasChanged").value="true";
}

function submitData(){
	var checkfield = "";
	var dscsAttch =  $GetEle("dscsAttch");
	if(dscsAttch.checked){
		checkfield+=",dscsAttchCtgry";
	}
	var tpcAttch =  $GetEle("tpcAttch");
	if(tpcAttch.checked){
		checkfield+=",tpcAttchCtgry";
	}
    if(checkfield == ""||check_form(document.weaverA,checkfield)){
		$('#weaverA').submit();
	}
}

function attchChange(inputname,brwname,brwspan, warnspan){
    var obj =  $GetEle(inputname);
    if(obj.checked){
        $("#"+brwname).css("display","");
        $("#"+brwspan).css("display","");
        $("#"+warnspan).css("display","none");
    }else{
        $("#"+brwname).css("display","none");
        $("#"+brwspan).css("display","none");
        $("#"+warnspan).css("display","");
    }
} 

function attchChangeNew(inputname, brwspan, warnspan){
    var obj =  $GetEle(inputname);
    if(obj.checked){
        $("#"+brwspan).css("display","");
        $("#"+warnspan).css("display","none");
    }else{
        $("#"+brwspan).css("display","none");
        $("#"+warnspan).css("display","");
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

function checkDays(obj){
  if(obj.value!=""&&(isNaN(obj.value)||parseInt(obj.value)<0||parseInt(obj.value)>365||obj.value!=parseInt(obj.value)))
     obj.value="0";
}

function ItemCount_KeyPress_Plus()
{
	if(!(window.event.keyCode >= 48 && window.event.keyCode <= 57))
	{
		window.event.keyCode = 0;
	}
}
</script>