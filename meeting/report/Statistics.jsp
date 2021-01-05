
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="StatisticComInfo" class="weaver.meeting.search.StatisticComInfo" scope="page" />
<jsp:setProperty name="StatisticComInfo" property="timeSag" param="timeSag"/>
<jsp:setProperty name="StatisticComInfo" property="subIds" param="subIds"/>
<jsp:setProperty name="StatisticComInfo" property="depIds" param="depIds"/>
<jsp:setProperty name="StatisticComInfo" property="selectType" param="selectType"/>
<jsp:setProperty name="StatisticComInfo" property="begindate" param="begindate"/>
<jsp:setProperty name="StatisticComInfo" property="enddate" param="enddate"/>

<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<%	
	String divid = Util.null2String(request.getParameter("divid"));
	if("".equals(divid)){
		divid = "absent";
	}
	String userid = ""+user.getUID();
	//System.out.println(userid);
	//登录人员的分部和部门
	String userdept = ""+user.getUserDepartment();
	String userSub = ""+user.getUserSubCompany1();
	int selectType=Util.getIntValue(request.getParameter("selectType"),1);
	 int timeSag = Util.getIntValue(request.getParameter("timeSag"),3);
	//查询条件
	int pageParam = Util.getIntValue(request.getParameter("pageParam"), -1);
	//System.out.println("pageParam:"+pageParam); 
	//第一次进入初始化
	if(pageParam==-1&&!"1".equals(userid)){
		StatisticComInfo.setSelectType(1);
		//StatisticComInfo.setDepIds(userdept+"");
		//StatisticComInfo.setSubIds(userSub+"");
	}else{
		userdept = StatisticComInfo.getDepIds();
		userSub = StatisticComInfo.getSubIds();
	}
	
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(17625, user.getLanguage());
	String needfav ="1";
	String needhelp ="";

	//第一次进入默认显示本月的数据
    String currentTime = TimeUtil.getCurrentDateString() + " " + TimeUtil.getOnlyCurrentTimeString().substring(0,5);
     
    String queryParam="?currentTime="+currentTime+"&timeSag="+timeSag+
    "&subIds="+StatisticComInfo.getSubIds()+"&depIds="+StatisticComInfo.getDepIds()+"&selectType="+StatisticComInfo.getSelectType()+
    "&begindate="+StatisticComInfo.getBegindate()+"&enddate="+StatisticComInfo.getEnddate();
    
    String absentUrl="/meeting/report/ChartMeetingAbsent.jsp"+queryParam;
    String resolutUrl="/meeting/report/ChartMeetingResolut.jsp"+queryParam;
    String processUrl="/meeting/report/ChartMeetingProcess.jsp"+queryParam;

%>
<HTML>
  <HEAD>
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
	<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
  </HEAD>
  <BODY>
    <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(354,user.getLanguage())+",javascript:doSearchsubmit(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	%>

	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right; ">
				<input id="refress" type="button" value="<%=SystemEnv.getHtmlLabelName(354,user.getLanguage()) %>" class="e8_btn_top middle" onclick="doSearchsubmit()"/>
				<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span>
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
			</td>
		</tr>
	</table>
	<div class="advancedSearchDiv" id="advancedSearchDiv"> 
	<FORM id=weaverA name=weaverA action="Statistics.jsp" method=post  >
		<INPUT type=hidden name="pageParam"  value="1" >
		<INPUT type=hidden name="divid" id="divid"  value="<%=divid%>" >
		<wea:layout type="4col">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(20331, user.getLanguage())%>' >
				<!--范围 -->
				<wea:item><%=SystemEnv.getHtmlLabelName(19467,user.getLanguage())%></wea:item>
				<wea:item>
					<select class=InputStyle name="selectType" id="selectType" onchange="onTypeChange()" style="float:left;width:40px !important;" > 
						<option value="1" <%if(selectType==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option><!-- 分部 -->
						<option value="2" <%if(selectType==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%> </option><!-- 部门 -->
						<option value="3" <%if(selectType==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option><!-- 总部 -->
					</select> 
					<!-- 分部 -->
					<span id="subIdsSP" style="float:left;margin-left:4px;">
					<brow:browser viewType="0" name="subIds" browserValue='<%=userSub %>' 
					browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=" 
					hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  width="140px"
					completeUrl="/data.jsp?type=164" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
					browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(""+userSub) %>'></brow:browser>
					</span>
					<!-- 部门 -->
					<span id="depIdsSP" style="float:left;margin-left:4px;display:none">
					<brow:browser viewType="0" name="depIds" browserValue='<%=userdept %>' 
					browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp" 
					hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  width="140px"
					completeUrl="/data.jsp?type=4" linkUrl="/hrm/company/HrmDepartmentDsp.jsp?id=" 
					browserSpanValue='<%=DepartmentComInfo.getDepartmentname(""+userdept) %>'></brow:browser>
					</span>

					<!-- 总部,隐藏 -->
				</wea:item>
				 <!-- 时间范围 -->
				<wea:item ><%=SystemEnv.getHtmlLabelName(19482,user.getLanguage())%></wea:item>
				<wea:item>
					<span>
						<select name="timeSag" id="timeSag" onchange="changeDate(this,'meetingStartdate');" style="width:100px;">
							<option value="0" <%=timeSag==0?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
							<option value="1" <%=timeSag==1?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option><!-- 今天 -->
							<option value="2" <%=timeSag==2?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option><!-- 本周 -->
							<option value="3" <%=timeSag==3?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option><!-- 本月 -->
							<option value="4" <%=timeSag==4?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option><!-- 本季 -->
							<option value="5" <%=timeSag==5?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option><!-- 本年 -->
							<option value="6" <%=timeSag==6?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option><!-- 指定日期范围 -->
						</select>
					</span>
					<span id="meetingStartdate"  style="<%=timeSag==6?"":"display:none;" %>">
						<BUTTON class=calendar type=button id=SelectDate onclick=getDate(begindatespan,begindate)></BUTTON>&nbsp;
						<SPAN id=begindatespan ><%=StatisticComInfo.getBegindate() %></SPAN>
						<input class=inputstyle type="hidden" id="begindate" name="begindate" value="<%=StatisticComInfo.getBegindate()%>">
						－<BUTTON class=calendar type=button id=SelectDate onclick=getDate(enddatespan,enddate)></BUTTON>&nbsp;
						<SPAN id=enddatespan ><%=StatisticComInfo.getEnddate()%></SPAN>
						<input class=inputstyle type="hidden" id="enddate" name="enddate" value="<%=StatisticComInfo.getEnddate()%>">
					</span>
				</wea:item>
			</wea:group>
			<wea:group context="">
				<wea:item type="toolbar">
					<input type="button" onclick="doSearchsubmit()" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtionAVS();"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
				</wea:item>
			</wea:group>
		</wea:layout>
	</FORM>
	</div>
	<!-- 会议缺席统计 -->
	<div id="absentDiv" style="position:relative; margin:0px auto; padding:0px; height:520px; overflow: hidden;">
		<iframe id="absentUrl" frameborder="0" height="520px" width="99%;" scrolling="no"></iframe>
	</div>
	<!-- 会议决议统计 -->
	<div id="resolutDiv" style="position:relative; margin:0px auto; padding:0px; height:520px; overflow: hidden;display:none;">
		<iframe id="resolutUrl" frameborder="0" height="520px" width="99%;" scrolling="no"></iframe>
	</div>
	<!-- 会议进展统计 -->
	<div id="processDiv" style="position:relative; margin:0px auto; padding:0px; height:520px; overflow: hidden;display:none;">
		<iframe id="processUrl" frameborder="0" height="520px" width="99%;" scrolling="no"></iframe>
	</div>
	
  </BODY>
</HTML>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<SCRIPT LANGUAGE="JavaScript">

 
 $(document).ready(function () {
    //js控制iframe加载
    
    
    showTypeChange();
	if("absent" == "<%=divid%>"){
		showAbsent();
	}
	if("resolut" == "<%=divid%>"){
		showResolut();
	}
	if("process" == "<%=divid%>"){
		showProcess();
	}
	jQuery('#overFlowDiv').perfectScrollbar();
 	if (window.jQuery.client.browser == "Chrome") {
 		jQuery('#overFlowDiv').height(jQuery(window).height()-2);
		jQuery('#overFlowDiv').perfectScrollbar('update');
 	}
 
    
	
 });
 
 function showProcess(){
	jQuery("#absentDiv").css("display","none");
	jQuery("#resolutDiv").css("display","none");
	jQuery("#processDiv").css("display","");
	$('#processUrl').attr("src",'<%=processUrl%>');
 }
 
 function showResolut(){
	jQuery("#absentDiv").css("display","none");
	jQuery("#resolutDiv").css("display","");
	jQuery("#processDiv").css("display","none");
	$('#resolutUrl').attr("src",'<%=resolutUrl%>');
 }
 
 function showAbsent(){
	jQuery("#absentDiv").css("display","");
	jQuery("#resolutDiv").css("display","none");
	jQuery("#processDiv").css("display","none");
	$('#absentUrl').attr("src",'<%=absentUrl%>');
 }

function onTypeChange(){
	showTypeChange();	
}

function showTypeChange(){
	var thisvalue=jQuery("#selectType").val();
	clearBrwInEle("depIdsSP");
	clearBrwInEle("subIdsSP");
	if (thisvalue == 1) {//分部
 		jQuery($GetEle("depIdsSP")).css("display","none");
		jQuery($GetEle("subIdsSP")).css("display","");
    }
	else if (thisvalue == 2) {//部门
 		jQuery($GetEle("depIdsSP")).css("display","");
		jQuery($GetEle("subIdsSP")).css("display","none");
	}
	else if (thisvalue == 3) {//总部
 		jQuery($GetEle("depIdsSP")).css("display","none");
		jQuery($GetEle("subIdsSP")).css("display","none");
	}
}

function preDo(){
	//tabSelectChg();
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	jQuery("#hoverBtnSpan").hoverBtn();
}

function onBtnSearchClick(){
	var name=$("input[name='t_name']",parent.document).val();
	$("input[name='names']").val(name);
	doSearchsubmit();
}

function clickTab(obj){
	jQuery("#timeSag").val(jQuery(obj).attr("val"));
	doSearchsubmit();
}

function doSearchsubmit(){
	$('#weaverA').submit();
}

function onSearch(obj) {
    obj.disabled = true ;
    doSearchsubmit();
}



 
 

</SCRIPT>
