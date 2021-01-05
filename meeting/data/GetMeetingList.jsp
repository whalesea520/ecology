
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.Timestamp" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="weaver.meeting.MeetingShareUtil"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="MeetingRoomComInfo" class="weaver.meeting.Maint.MeetingRoomComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="MeetingFieldComInfo" class="weaver.meeting.defined.MeetingFieldComInfo" scope="page"/>

<html>
<head id="Head1">
	<%
        
		int divheight = Util.getIntValue(request.getParameter("divheight"), 0);
		String curSkin=(String)session.getAttribute("SESSION_CURRENT_SKIN");
		
		String selectedUser=Util.null2String(request.getParameter("selectUser"));
		if("".equals(selectedUser)){
			selectedUser=""+user.getUID();
		}
		String selectedUserName=ResourceComInfo.getFirstname(selectedUser);
		
		String userid = ""+user.getUID();
		String logintype = ""+user.getLogintype();
		
		Calendar thisCalendar = Calendar.getInstance(); //当前日期
		Calendar selectCalendar = Calendar.getInstance(); //用于显示的日期
		Calendar currntCalendar = Calendar.getInstance();
	
		int countDays = 0; //需要显示的天数
		int offsetDays = 0; //相对显示显示第一天的偏移天数
		String thisDate = ""; //当前日期
		String selectDate = ""; //用于显示日期
	
		String beginDate = "";
		String endDate = "";
	
		String beginYear = "";
		String beginMonth = "";
		String beginDay = "";
	
		String endYear = "";
		String endMonth = "";
		String endDay = "";
	
		//参数传递
		String userId = String.valueOf(user.getUID()); //当前用户Id
		String userType = user.getLogintype(); //当前用户类型
		String selectUser = Util.null2String(request
				.getParameter("selectUser")); //被选择用户Id
		String selectedType = Util.null2String(request
				.getParameter("selectedType")); //被选择类型
		String selectedDept = Util.null2String(request
				.getParameter("selectedDept")); //被选择部门
		String selectedSub = Util.null2String(request
				.getParameter("selectedSub")); //被选择分部	
		String hasrightview = Util.null2String(request
				.getParameter("hasrightview")); //是否有权限查看	
		String viewType = request.getParameter("viewtype"); //1:日计划显示 2:周计划显示 3:月计划显示
		String selectDateString = Util.null2String(request
				.getParameter("selectdate")); //被选择日期
		String isShare = Util.null2String(request.getParameter("isShare")); //是否是共享    1：共享日程
		String selectUserNames = Util.null2String(request
				.getParameter("selectUserNames")); //查看其他人姓名
		String meetingType =  Util.null2String(request
			.getParameter("meetingType")); //会议的进行状态
		
		SimpleDateFormat SDF = new SimpleDateFormat("yyyy-MM-dd HH:mm") ;
	    Calendar calendar = Calendar.getInstance() ;
	    String currenttime = SDF.format(calendar.getTime()) ;
		
		boolean appendselectUser = false;
	
		viewType = "day".equals(viewType) ? "1"
				: ("week".equals(viewType) ? "2" : "3");
	
		if ("".equals(selectUser) || userId.equals(selectUser)) {
			appendselectUser = true;
			selectUser = userId;
		}
		selectUser = selectUser.replaceAll(",", "");
		
		String allUser=MeetingShareUtil.getAllUser(user);
		
		String thisYear = Util.add0((thisCalendar.get(Calendar.YEAR)), 4); //当前年
		String thisMonth = Util.add0(
				(thisCalendar.get(Calendar.MONTH)) + 1, 2); //当前月
		String thisDayOfMonth = Util.add0((thisCalendar
				.get(Calendar.DAY_OF_MONTH)), 2); //当前日
		thisDate = thisYear + "-" + thisMonth + "-" + thisDayOfMonth;
	
		if (!"".equals(selectDateString))
		//当选择日期
		{
			int selectYear = Util.getIntValue(selectDateString.substring(0,
					4)); //被选择年
			int selectMonth = Util.getIntValue(selectDateString.substring(
					5, 7)) - 1; //被选择月
			int selectDay = Util.getIntValue(selectDateString.substring(8,
					10)); //被选择日
			selectCalendar.set(selectYear, selectMonth, selectDay);
		}
	
		String selectYear = Util.add0((selectCalendar.get(Calendar.YEAR)),
				4); //年 
		String selectMonth = Util.add0(
				(selectCalendar.get(Calendar.MONTH)) + 1, 2); // 月
		String selectDayOfMonth = Util.add0((selectCalendar
				.get(Calendar.DAY_OF_MONTH)), 2); //日    
		String selectWeekOfYear = String.valueOf(selectCalendar
				.get(Calendar.WEEK_OF_YEAR)); //第几周
		String selectDayOfWeek = String.valueOf(selectCalendar
				.get(Calendar.DAY_OF_WEEK)); //一周第几天
		selectDate = selectYear + "-" + selectMonth + "-"
				+ selectDayOfMonth;
	
		switch (Integer.parseInt(viewType))
		//设置为显示的第一天
		{
		case 1:
			//日显示
			offsetDays = 0;
			break;
		case 2:
			//周显示
			offsetDays = Integer.parseInt(selectDayOfWeek) - 1;
			selectCalendar.add(Calendar.DAY_OF_WEEK, -1
					* Integer.parseInt(selectDayOfWeek) + 1);
			break;
		case 3:
			//月显示
			selectCalendar.set(Calendar.DATE, 1); //设置为月第一天
			int offsetDayOfWeek = selectCalendar.get(Calendar.DAY_OF_WEEK) - 1;
			offsetDays = Integer.parseInt(selectDayOfMonth) - 1
					+ offsetDayOfWeek;
			selectCalendar.add(Calendar.DAY_OF_WEEK, -1 * offsetDayOfWeek); //设置为月首日那周的第一天
			break;
		}
		beginYear = Util.add0(selectCalendar.get(Calendar.YEAR), 4); //年 
		beginMonth = Util.add0(selectCalendar.get(Calendar.MONTH) + 1, 2); // 月
		beginDay = Util.add0(selectCalendar.get(Calendar.DAY_OF_MONTH), 2); //日 
		beginDate = beginYear + "-" + beginMonth + "-" + beginDay;
		//System.out.println("viewType:" + viewType);
		switch (Integer.parseInt(viewType))
		//设置为显示的最后一天
		{
		case 1:
			//日计划显示
			countDays = 1;
			break;
		case 2:
			//周计划显示
			selectCalendar.add(Calendar.WEEK_OF_YEAR, 1);
			selectCalendar.add(Calendar.DATE, -1);
			countDays = 7;
			break;
		case 3:
			//月计划显示
			selectCalendar.add(Calendar.DATE, offsetDays);
			//System.out.println("######" + selectCalendar.get(Calendar.DATE));
			selectCalendar.set(Calendar.DATE, 1); //设置为月第一天
			selectCalendar.add(Calendar.MONTH, 1);
			selectCalendar.add(Calendar.DATE, -1);
			countDays = selectCalendar.get(Calendar.DAY_OF_MONTH); //当月天数
			int offsetDayOfWeekEnd = 7 - selectCalendar
					.get(Calendar.DAY_OF_WEEK);
			selectCalendar.add(Calendar.DAY_OF_WEEK, offsetDayOfWeekEnd); //设置为月末日那周的最后一天
			break;
		}
		endYear = Util.add0(selectCalendar.get(Calendar.YEAR), 4); //年 
		endMonth = Util.add0(selectCalendar.get(Calendar.MONTH) + 1, 2); // 月
		endDay = Util.add0(selectCalendar.get(Calendar.DAY_OF_MONTH), 2); //日
		endDate = endYear + "-" + endMonth + "-" + endDay;
		
		int userdept = user.getUserDepartment();
		int userSub = user.getUserSubCompany1();
		
		String backfields = "t1.id,t1.name,t1.address,t1.customizeAddress,t1.caller,t1.contacter,t1.begindate,t1.begintime,t1.enddate,t1.endtime,t1.meetingstatus,t1.isdecision, t3.status as status,t.id as tid, t.name as typename ";
		String fromSql = " Meeting_ShareDetail t2,   Meeting t1 left join Meeting_View_Status t3 on t3.meetingId = t1.id and t3.userId = " + userid + ", Meeting_Type  t ";
		
		String sqlWhere = " where t1.meetingtype = t.id and t1.repeatType = 0 ";

		
		Date newdate = new Date() ;
		long datetime = newdate.getTime() ;
		Timestamp timestamp = new Timestamp(datetime) ;
		String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
		String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16);
		
		if(!sqlWhere.equals(""))
		{
			sqlWhere +=" AND (";
		}
		else
		{
			sqlWhere =" WHERE (";
		}
		sqlWhere +=" (t1.id = t2.meetingId) AND ";
		//待审批，审批退回的会议，召集人 联系人 创建人  审批人都可以看
		sqlWhere +=" ((t1.meetingStatus in (1, 3) AND t2.userId in (" + allUser + ") AND t2.shareLevel in (1,4))" ;
		//草稿中的创建人可以看见
		sqlWhere +=" OR (t1.meetingStatus = 0 AND t1.creater in (" + allUser + ")  AND t2.userId in(" + allUser + ") ) ";
		//正常和取消的会议所有参会人员都可见
		sqlWhere +=" OR (t1.meetingStatus IN (2, 4) AND (t2.userId in(" + allUser + "))))";
		sqlWhere +=") ";
		StringBuffer sqlStringBuffer = new StringBuffer();
		sqlStringBuffer.append(" and (t1.cancel <> 1 or t1.cancel is null) ");
		sqlStringBuffer.append(" AND ( (t1.beginDate >= '");
		sqlStringBuffer.append(beginDate);
		sqlStringBuffer.append("' AND t1.beginDate <= '");
		sqlStringBuffer.append(endDate);
		sqlStringBuffer.append("') OR ");
		sqlStringBuffer.append(" (t1.endDate >= '");
		sqlStringBuffer.append(beginDate);
		sqlStringBuffer.append("' AND t1.endDate <= '");
		sqlStringBuffer.append(endDate);
		sqlStringBuffer.append("') OR ");
		sqlStringBuffer.append(" (t1.endDate >= '");
		sqlStringBuffer.append(endDate);
		sqlStringBuffer.append("' AND t1.beginDate <= '");
		sqlStringBuffer.append(beginDate);
		sqlStringBuffer.append("') OR ");
		sqlStringBuffer
				.append(" ((t1.endDate IS null OR t1.endDate = '') AND t1.beginDate <= '");
		sqlStringBuffer.append(beginDate);
		sqlStringBuffer.append("') )");
		
		String btimeStr = "t1.beginDate+' '+t1.begintime ";
		String etimeStr = "t1.endDate+' '+t1.endtime ";
		if ((recordSet.getDBType()).equals("oracle")) {
		 	btimeStr = "t1.beginDate||' '||t1.begintime ";
		 	etimeStr = "t1.endDate||' '||t1.endtime ";
		}
		if("1".equals(meetingType)){
			sqlStringBuffer.append(" AND ("+etimeStr+" < '"+ currenttime + "' ");
			sqlStringBuffer.append(" or t1.isdecision = 2 ) ");
		} else if("2".equals(meetingType)){
			sqlStringBuffer.append(" AND ("+btimeStr+" <= '"+ currenttime + "' ");
			sqlStringBuffer.append("   AND "+etimeStr+" >= '"+ currenttime + "' and t1.isdecision <> 2) ");
		
		} else if("3".equals(meetingType)){
			sqlStringBuffer.append(" AND "+btimeStr+" > '"+ currenttime + "'  and t1.isdecision <> 2");
		}
		if(!userId.equals(selectUser)){
			if("2".equals(selectedType)){
				//部门
				sqlStringBuffer.append(" AND ( exists (select 1 from HrmResource where t1.caller = HrmResource.id and HrmResource.departmentid = "+ selectedDept +") ) ");
			} else if("3".equals(selectedType)){
				//分部
				sqlStringBuffer.append(" AND ( exists (select 1 from HrmResource where t1.caller = HrmResource.id and HrmResource.subcompanyid1 = "+ selectedSub +") ) ");
			} else {
				//人员
				sqlStringBuffer.append(" AND ( exists ( select 1 from Meeting_Member2 where t1.id = Meeting_Member2.meetingid and Meeting_Member2.membertype = 1 and Meeting_Member2.memberid = "+ selectUser +") or t1.caller = "+ selectUser +" or t1.contacter = "+ selectUser +") ");
			}
		}
		sqlWhere += sqlStringBuffer.toString();
				
		//out.println("sql11111: select "+backfields+" from "+ fromSql + " "+sqlWhere);
	%>
    <title>	My Calendar </title>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <link href="/css/Weaver_wev8.css" rel="stylesheet" type="text/css" /> 
    <link type='text/css' rel='stylesheet'  href='/wui/common/css/w7OVFont_wev8.css' id="FONT2SYSTEMF" />
	<link type='text/css' rel='stylesheet'  href='/wui/theme/<%=curTheme %>/skins/<%=curSkin %>/wui_wev8.css'/>
    <script type="/js/jquery/ui/ui.dialog_wev8.js"  type="text/javascript"></script>
	<script type="text/javascript" src="/js/weaver_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/jquery_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/wuiform/jquery.wuiform_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/jQuery.modalDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" type="text/javascript" src="/js/init_wev8.js"></script>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>

</head>

<body scroll="no">
	<div id="tablediv" style="overflow-y: hidden;position: relative;width:100%;<%if(divheight > 0){ %><%="height:"+divheight+"px;" %><%} %>">
			<div id="tableChlddiv">
				<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.MT_MeetingCalView%>"/>
  <%

   	int  perpage=10;
    
     //if(SqlWhere.length()>1){
    //     int indx=SqlWhere.indexOf("where");
    //     if(indx>-1)
    //         SqlWhere=SqlWhere.substring(indx+5);
    // }

     String orderby = " t1.enddate ,t1.endtime , t1.id" ;
     String tableString = "";
   	tableString =" <table instanceid=\"meetingTable\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.MT_MeetingCalView,user.getUID())+"\" >"+ 
                          "	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\"  sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Desc\" />"+
                          "			<head>"+
                          "				<col width=\"24%\"  text=\""+SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel(""+2)),user.getLanguage())+"\" column=\"name\" orderkey=\"t1.name\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingName\" otherpara=\"column:id+column:status\" />"+
                          "				<col width=\"16%\"   text=\""+SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel(""+5)),user.getLanguage())+"\" column=\"address\" orderkey=\"address\" otherpara=\""+user.getLanguage()+"+column:customizeaddress\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingAddress\" />"+
                          "				<col width=\"30%\"   text=\""+SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel(""+17)),user.getLanguage())+"\" column=\"begindate\"  orderkey=\"begindate,begintime\" otherpara=\"column:begintime+column:enddate+column:endtime\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingTime\"/>"+
                          "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel(""+3)),user.getLanguage())+"\" column=\"caller\" orderkey=\"caller\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingResource\" />"+
                          "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel(""+4)),user.getLanguage())+"\" column=\"contacter\" orderkey=\"contacter\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingResource\" />"+
						  "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"meetingstatus\" otherpara=\""+user.getLanguage()+"+column:endDate+column:endTime+column:isdecision\" orderkey=\"meetingstatus\"  transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingStatus\" />"+
                          "			</head>"+
                          "</table>";
  %>
  <wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run" />
  
	</div>
 </div>
 <%@ include file="/hrm/resource/simpleHrmResource_wev8.jsp" %>
</body>
</html>
<script type="text/javascript">
function afterDoWhenLoaded(){
	window.parent.setWindowSize(window.parent.document);
}

document.oncontextmenu=function(){
	return false;
}
	
var diag_vote;
function view(id)
{
	if(id!="0" && id !=""){
		if(window.top.Dialog){
			diag_vote = new window.top.Dialog();
		} else {
			diag_vote = new Dialog();
		}
		diag_vote.currentWindow = window;
		diag_vote.Width = 800;
		diag_vote.Height = 550;
		diag_vote.Modal = true;
		diag_vote.maxiumnable = true;
		diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2103,user.getLanguage())%>";
		diag_vote.URL = "/meeting/data/ViewMeetingTab.jsp?needRefresh=false&meetingid="+id;
		diag_vote.show();
		diag_vote.CancelEvent=closeDialog;
	}
}

function closeDialog(){
	diag_vote.close();
	parent.dataRfsh4List();
}

function closeDlgARfsh(){
	dataRfsh();
	diag_vote.close();
	parent.dataRfsh4List();
	
}

function dataRfsh(){
	_table.reLoad();
}

jQuery(document).ready(function(){

		jQuery("#tablediv").perfectScrollbar();

});
	</script>
