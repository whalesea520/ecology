
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="weaver.meeting.MeetingShareUtil"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page"/>
<jsp:useBean id="meetingSetInfo" class="weaver.meeting.Maint.MeetingSetInfo" scope="page"/>
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" /> 
<jsp:useBean id="MeetingFieldComInfo" class="weaver.meeting.defined.MeetingFieldComInfo" scope="page"/>
<html >
<head id="Head1">
	<%
	
		String curSkin=(String)session.getAttribute("SESSION_CURRENT_SKIN");
		int bywhat = Util.getIntValue(request.getParameter("bywhat"),4);
		String userid=user.getUID()+"" ;
		String allUser=MeetingShareUtil.getAllUser(user);
		String datenow = Util.null2String(request.getParameter("datenow"));
		boolean cancelRight = HrmUserVarify.checkUserRight("Canceledpermissions:Edit",user);
		int subids = Util.getIntValue(request.getParameter("subids"), -1);
		String content = Util.null2String(request.getParameter("content"));
		int roomid = Util.getIntValue(request.getParameter("roomid"), 0);
		String canEdit = Util.null2String(request.getParameter("canEdit"));
		boolean isUseMtiManageDetach=ManageDetachComInfo.isUseMtiManageDetach();
		int detachable=0;
		if(isUseMtiManageDetach){
			detachable=1;
		   session.setAttribute("detachable","1");
		   session.setAttribute("meetingdetachable","1");
		}else{
			detachable=0;
		   session.setAttribute("detachable","0");
		   session.setAttribute("meetingdetachable","0");
		}
		
		String sqlwhere = "";

		if(subids > 0){
			 sqlwhere = "and a.subCompanyId = "+ subids ;
		}
		if(roomid > 0){
			sqlwhere = "and a.id = " + roomid ;
		} else {
			if(!"".equals(content.trim())){
				sqlwhere = "and a.name like '%" + content + "%' ";
			}
			sqlwhere += " and (a.status=1 or a.status is null ) ";
		}
		
		int contacterPrm=meetingSetInfo.getContacterPrm();
		int createrPrm=meetingSetInfo.getCreaterPrm();
		
		
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


</head>
<body scroll="no">
<div id="listdiv">
  <%

   	 String returnStr = "" ;   
        switch (bywhat) {
            case 2 :                  
                returnStr=" and  (t1.meetingstatus=2 or t1.meetingstatus=1) and ('"+datenow+"'" +
                        " between SUBSTRING(t1.begindate,1,7) and SUBSTRING(t1.enddate,1,7)) and (t1.isdecision<2)" ;
                break ;
            case 3 :
                returnStr=" and  (t1.meetingstatus=2 or t1.meetingstatus=1) and ( "   ;   
                for (int h = -1;h<6;h++){                 
                    String newTempDate = TimeUtil.dateAdd(datenow,h) ;
                    returnStr +="('"+newTempDate+"' between t1.begindate and t1.enddate) or" ;         
                }
                returnStr = returnStr.substring(0,returnStr.length()-2);
                returnStr += ") and (t1.isdecision<2) " ;
                break ;                
            case 4 : 
                returnStr = " and  (t1.meetingstatus=2 or t1.meetingstatus=1) and ('"+datenow+"' " +
                        " between t1.begindate and t1.enddate)  and (t1.isdecision<2) " 
						+ " and ( (t1.endtime between '"+Util.add0(meetingSetInfo.getTimeRangeStart(),2)+"' and '"+Util.add0(meetingSetInfo.getTimeRangeEnd(),2)+":59') or (t1.begintime between '"+Util.add0(meetingSetInfo.getTimeRangeStart(),2)+"' and '"+Util.add0(meetingSetInfo.getTimeRangeEnd(),2)+":59'))";
                break ;      
        }
        
        if ((RecordSet.getDBType()).equals("oracle")) {
            returnStr = Util.StringReplace(returnStr,"SUBSTRING","substr");   
        }
        
        sqlwhere = MeetingShareUtil.getRoomShareSql(user) + sqlwhere;
        if(sqlwhere.length() > 4) {
        	if("oracle".equals(RecordSet.getDBType())){
        		returnStr += " and exists (select 1 from MeetingRoom a  where ','||t1.address||',' like '%,'||to_char(a.id)||',%' "+ sqlwhere + ") ";
        	}else{
        		returnStr += " and exists (select 1 from MeetingRoom a  where ','+t1.address+',' like '%,'+convert(varchar,a.id)+',%' "+ sqlwhere + ") ";
        	}
        }
		String backfields = "t1.id,t1.name,t1.address,t1.customizeAddress,t1.caller,t1.contacter,t1.begindate,t1.cancel,t1.begintime,t1.enddate,t1.endtime,t1.meetingstatus,t1.isdecision,t1.description,t1.repeattype, t3.status as status,t.id as tid, t.name as typename,t1.creater ";
		String fromSql = "  Meeting t1 left join Meeting_View_Status t3 on t3.meetingId = t1.id and t3.userId = " + userid + ", Meeting_Type  t ";
		
		String whereSql = " where t1.meetingtype = t.id  and t1.repeatType = 0 "+((RecordSet.getDBType()).equals("oracle")?"and t1.endtime is not null ":" and t1.endtime is not null and datalength(t1.endtime)<>0 ") + returnStr;
   	int  perpage=5;
   	RecordSet.executeSql("select pageSize from ecology_pagesize where pageId = '"+PageIdConst.MT_MeetingRoomPlan+"' and userId="+user.getUID());
   	if(RecordSet.next()){
   		perpage=Util.getIntValue(RecordSet.getString("pageSize"), 5);
   	}
   	//meetingSetInfo.writeLog("sql111:select "+ backfields + " from "+ fromSql + whereSql);
     String orderby = " t1.begindate ,t1.begintime , t1.id" ;
     String tableString = "";
   	tableString =" <table instanceid=\"meetingTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+ 
                          "	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\"  sqlwhere=\""+Util.toHtmlForSplitPage(whereSql)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Desc\" />"+
                          "			<head>"+
                          "				<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("2")),user.getLanguage())+"\" column=\"name\" orderkey=\"t1.name\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingName\" otherpara=\"column:id+column:status\" />"+
                          "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("3")),user.getLanguage())+"\" column=\"caller\" orderkey=\"caller\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingResource\" />"+
                          "				<col width=\"13%\"   text=\""+SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("1")),user.getLanguage())+"\" column=\"typename\" orderkey=\"typename\"  />"+
                          "				<col width=\"17%\"   text=\""+SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("5")),user.getLanguage())+"\" column=\"address\" orderkey=\"address\" otherpara=\""+user.getLanguage()+"+column:customizeaddress\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingAddress\" />"+
           				  "				<col width=\"15%\"   text=\""+SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("17")),user.getLanguage())+"\" column=\"begindate\"  orderkey=\"begindate,begintime\" otherpara=\"column:begintime\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingDateTime\"/>"+
                          "				<col width=\"15%\"   text=\""+SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("19")),user.getLanguage())+"\" column=\"enddate\"  orderkey=\"enddate,endtime\" otherpara=\"column:endtime\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingDateTime\"/>"+
                          "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"meetingstatus\" otherpara=\""+user.getLanguage()+"+column:endDate+column:endTime+column:isdecision\" orderkey=\"meetingstatus\"  transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingStatus\" />"+
                          "			</head>"+
                          "		<operates>"+
						  "		  <popedom column=\"id\" otherpara=\"column:caller+"+allUser+"+"+cancelRight+"+column:cancel+column:meetingstatus+column:enddate+column:endtime+column:isdecision+column:contacter+column:creater+"+contacterPrm+"+"+createrPrm+"+column:begindate+column:begintime+column:repeattype+column:address\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.checkMtnCnclOperate\"></popedom> "+
						  "		  <operate href=\"javascript:doCancel();\" text=\""+SystemEnv.getHtmlLabelName(201,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
						  "		  <operate href=\"javascript:doOver();\" text=\""+SystemEnv.getHtmlLabelName(126003,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
						  "		</operates>"+
                          "</table>";
  %>
  <input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.MT_MeetingRoomPlan%>"/>
  <wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run" />
</div>
</body>
</html>
<script type="text/javascript">
jQuery(document).ready(function(){
	setTimeout(function(){
		window.parent.setWindowSize(window.parent.document);
	},200);
});

function pointerXY(event,doc)  
{  

} 

function openhrm(tempuserid)
{
	openFullWindowForXtable("/hrm/HrmTab.jsp?_fromURL=HrmResource&id="+tempuserid);
}


function afterDoWhenLoaded(){
	setTimeout(function(){
		window.parent.setWindowSize(window.parent.document);
	},200);
}
document.oncontextmenu=function(){
	   return false;
	}
	
function doCancel(id){
	window.parent.doCancel(id);
}

function doOver(id){
	window.parent.doOver(id);
}

function view(id)
{
    window.parent.view(id);
}


function closeDialog(){
	window.parent.closeDialog();
}

function closeDlgARfsh(){
	window.parent.closeDlgARfsh();
}

function dataRfsh(){
	window.parent.dataRfsh();
}
</script>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
