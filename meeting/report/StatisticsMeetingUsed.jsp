
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="StatisticComInfo" class="weaver.meeting.search.StatisticComInfo" scope="page" />
<jsp:setProperty name="StatisticComInfo" property="subIds" param="subIds"/>
<jsp:setProperty name="StatisticComInfo" property="begindate" param="begindate"/>
<jsp:setProperty name="StatisticComInfo" property="enddate" param="enddate"/>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%	
	StatisticComInfo.setTimeSag(6);
	String userid = ""+user.getUID();
	//System.out.println(userid);
	//登录人员的分部
	String userSub = ""+user.getUserSubCompany1();
	int timeSag = Util.getIntValue(request.getParameter("timeSag"),6);
	int mode = Util.getIntValue(request.getParameter("mode"),1);
	//查询条件
	int pageParam = Util.getIntValue(request.getParameter("pageParam"), -1);
	mode=pageParam==-1?(mode==0?1:0):mode;
	
	//第一次进入初始化,管理员默认全部
	if(pageParam==-1&&!"1".equals(userid)){
		StatisticComInfo.setSubIds(userSub+"");
	}else{
		userSub = StatisticComInfo.getSubIds();
	}
	
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(17625, user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	List<String> addressLst = new ArrayList<String>();
 	List<String> nameLst = new ArrayList<String>();
 	List<String> subCompanyIdLst = new ArrayList<String>();
 	String otherwhere = "";
    String name="";
 	String searchSql = "";
 	//计算总次数
    int totalTimes=0;
 	String searchAddressSql = "select id,name,subcompanyid from MeetingRoom  where (status=1 or status is null ) ";
 	otherwhere = StatisticComInfo.getMeetingUsedSql(1);
 	String groupSql=" group by id,name,subcompanyid ";
 	rs.executeSql(searchAddressSql + otherwhere + groupSql);
 	while(rs.next()){
 			otherwhere = StatisticComInfo.getMeetingUsedSql(2);
 	 		if(rs1.getDBType().equals("oracle")){
 	 			searchSql="SELECT count(1) as times from  meeting where  ','||address||',' like  '%,"+rs.getString("id")+",%' and repeatType=0";
 	 	 	}else{
 	 			searchSql="SELECT count(1) as times from  meeting where  ','+address+',' like  '%,"+rs.getString("id")+",%' and repeatType=0";
 	 	 	}
 	 		rs1.execute(searchSql + otherwhere);
 	 		rs1.next();
 	 		totalTimes += rs1.getInt("times");
 	}
    
    
 	String beginDate = "".equals(StatisticComInfo.getBegindate())?"empty":StatisticComInfo.getBegindate();
 	String endDate = "".equals(StatisticComInfo.getEnddate())?"empty":StatisticComInfo.getEnddate();
   	
    String url="/meeting/report/ChartMeetingRoomUsed.jsp?total="+
    totalTimes+"&mode="+mode+"&timeSag=6&subIds="+StatisticComInfo.getSubIds()+
    "&begindate="+StatisticComInfo.getBegindate()+"&enddate="+StatisticComInfo.getEnddate();
	
	String lb=SystemEnv.getHtmlLabelName(320,user.getLanguage())+SystemEnv.getHtmlLabelName(32559,user.getLanguage());
	String tb=SystemEnv.getHtmlLabelName(22899,user.getLanguage())+SystemEnv.getHtmlLabelName(32559,user.getLanguage());
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

    RCMenu += "{"+SystemEnv.getHtmlLabelName(364, user.getLanguage())+",javascript:onSearch(this)',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
    
    RCMenu += "{"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+"EXCEL,javascript:_xtable_getAllExcel()',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;

	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right; ">
				<input id="changeMode" type="button" value="<%=mode==0?lb:tb %>" class="e8_btn_top middle" onclick="changeMode()"/>
				<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span>
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
			</td>
		</tr>
	</table>
	<div class="advancedSearchDiv" id="advancedSearchDiv"> 
	<FORM id=weaverA name=weaverA action="StatisticsMeetingUsed.jsp" method=post  >
		<input type="hidden" name="timeSag" id="timeSag" value="6">
		<INPUT type=hidden name="pageParam"  value="1" >
		<input type="hidden" name="mode" id="mode" value="<%=mode %>">
		<wea:layout type="4col">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(20331, user.getLanguage())%>' >
				<!-- 时间范围 -->
				<wea:item><%=SystemEnv.getHtmlLabelName(19482,user.getLanguage())%></wea:item>
				<wea:item>
				  <BUTTON class=calendar type=button id=SelectDate onclick=getDate(begindatespan,begindate)></BUTTON>&nbsp;
				  <SPAN id=begindatespan ><%=StatisticComInfo.getBegindate() %></SPAN>
				  <input class=inputstyle type="hidden" id="begindate" name="begindate" value="<%=StatisticComInfo.getBegindate()%>">
				  －<BUTTON class=calendar type=button id=SelectDate onclick=getDate(enddatespan,enddate)></BUTTON>&nbsp;
				  <SPAN id=enddatespan ><%=StatisticComInfo.getEnddate()%></SPAN>
				  <input class=inputstyle type="hidden" id="enddate" name="enddate" value="<%=StatisticComInfo.getEnddate()%>">
				</wea:item>
				<!-- 分部 -->
				<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
				<wea:item>  
					<brow:browser viewType="0" name="subIds" browserValue='<%=userSub %>' 
					browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?show_virtual_org=-1&selectedids=" 
					hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  width="200px"
					completeUrl="/data.jsp?type=164&show_virtual_org=-1" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
					browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(""+userSub) %>'></brow:browser>
				</wea:item>
			</wea:group>
			<wea:group context="">
				<wea:item type="toolbar">
					<input type="button" onclick="doSearchsubmit();" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtionAVS();"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
				</wea:item>
			</wea:group>
		</wea:layout>
	</FORM>
	</div>

	<!-- 图表视图 -->
	<TABLE width="100%" id="mode_0" style="display:none">
		<tr>
		  <td valign="top">
				<iframe id="usedDiv" src="<%=mode==0?url:"" %>" class="flowFrame" frameborder="0" height="600px" width="100%;" scrolling="no"></iframe>
		  <br></td>
		</tr>
	</TABLE>
	  
	<!-- 列表视图 -->
	<TABLE width="100%" id="mode_1" style="display:none">
		<tr>
		  <td valign="top">
			  <%

				int  perpage=10;
				String searchFiled=" id,name,subcompanyid,hrmid ";
				String sqlform=" MeetingRoom ";
				String sqlWhere=" status=1 or status is null ";
				String orderby = " id " ;
				//out.print(sqlform);
				String tableString = " <table instanceid=\"meetingUsedTable\" tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+
									 "	   <sql backfields=\""+searchFiled+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlform)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\"/>"+
									 "			<head>"+
									 "				<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(780,user.getLanguage())+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"name\" />"+
									 "				<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(17868,user.getLanguage())+"\" column=\"subcompanyid\" orderkey=\"subcompanyid\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingSubCompany\" />"+	 
									 "				<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(2156,user.getLanguage())+"\" column=\"hrmid\"  transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingResource\"/>"+
									 "				<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(23711,user.getLanguage())+"\" column=\"id\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingRoomTimes\" otherpara=\""+beginDate+"+"+endDate+"\"/>"+
									 "				<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(32527,user.getLanguage())+"\" column=\"id\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingUsedPercentage\" otherpara=\""+totalTimes+"+"+beginDate+"+"+endDate+"\"/>"+
									 "			</head>"+
									 "</table>";
			 %>
			 <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"/>
		  </td>
		</tr>
	  </TABLE>
  </BODY>
</HTML>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<script type="text/javascript" src="/js/highcharts/highcharts_wev8.js"></script>
<SCRIPT LANGUAGE="JavaScript">
 var initMode=false;
 $(document).ready(function () {
 	changeMode();       
 	 
 });
 
 
 function changeMode(){
 	 
 	if(!initMode){//第一次进入或刷新页面
 		initMode=true;
 		changeModeDiv($('#mode').val());	
 	}else{//页面切换
	 	//当前mode 0 图表 1列表
		var val = $('#mode').val();
		$('#mode').val(val==0?1:0);
		val = $('#mode').val();
	   	changeModeDiv(val)
 	}
 }
 //改变列表图层
 function changeModeDiv(val){
 	if(val == 0){//当前列表模式 切换到图表显示
 		hideRightClickMenu();
   		$('#mode_0').show();
   		$('#mode_1').hide();
   		if($('#usedDiv').attr("src")==''){
   			$('#usedDiv').attr("src",'<%=url%>');
   		}
   		$('#changeMode',parent.document).val('<%=lb%>');
   		//$('#changeMode',parent.document).attr('title','切换到列表视图');
   		//$('#menuItemDivId1',window.frames["rightMenuIframe"].document).hide();
   	} else {//当前图表模式 切换到列表显示
   		jQuery('#mode_0').hide();
   		jQuery('#mode_1').show();
   		$('#changeMode',parent.document).val('<%=tb%>');
   		//$('#changeMode',parent.document).attr('title','切换到图表视图');
   		$('#menuItemDivId1',window.frames["rightMenuIframe"].document).show();
   	}
 }
 
function resetCondtion(){
	jQuery("#begindate").val("");
	jQuery("#begindatespan").html("");
	jQuery("#enddate").val("");
	jQuery("#enddatespan").html("");
	jQuery("#subIds").val("");
	jQuery("#subidsSpan").html("");
	jQuery("#depIds").val("");
	jQuery("#departmentidSpan").html("");
	
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
