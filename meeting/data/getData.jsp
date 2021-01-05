
<%@page import="java.util.Date"%>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.systeminfo.*" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ page import="weaver.general.Util" %>
<%@page import="weaver.meeting.MeetingShareUtil"%>

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="MeetingRoomComInfo" class="weaver.meeting.Maint.MeetingRoomComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="MeetingFieldComInfo" class="weaver.meeting.defined.MeetingFieldComInfo" scope="page"/>
<%

String method = Util.null2String(request.getParameter("method"));
String showdate = Util.null2String(request.getParameter("showdate"));
String timezone = Util.null2String(request.getParameter("timezone"));
String viewtype = Util.null2String(request.getParameter("viewtype"));

if("list".equals(method)){
	request.getRequestDispatcher("/meeting/data/CalendarData.jsp").forward(request,response);
} else if("getNextMeeting".equals(method)){
	weaver.hrm.User user = weaver.hrm.HrmUserVarify.getUser(request, response);
	String userid = Util.null2String(request.getParameter("userid"));
	String divname = Util.null2String(request.getParameter("divname"));
	if("".equals(userid)){
		userid = ""+user.getUID();
	}
	String allUser=MeetingShareUtil.getAllUser(user);
	Date newdate = new Date() ;
	long datetime = newdate.getTime() ;
	Timestamp timestamp = new Timestamp(datetime) ;
	String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
	String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16);
				
	StringBuffer sqlStringBuffer = new StringBuffer();
	sqlStringBuffer.append("select t1.id,t1.name,t1.address,t1.customizeAddress,t1.caller,t1.contacter,t1.begindate,t1.begintime,t1.enddate,t1.endtime,t1.meetingstatus,t1.isdecision ");
	sqlStringBuffer.append(" from Meeting_ShareDetail t2,   Meeting t1 , Meeting_Type  t ");
	
	sqlStringBuffer.append(" WHERE ");
	sqlStringBuffer.append(" (t1.id = t2.meetingId) AND t1.isdecision <> 2 and t1.repeatType = 0");
	sqlStringBuffer.append(" and (t1.meetingStatus IN (2, 4) AND (t2.userId in(" + allUser + ")) )");
	sqlStringBuffer.append(" and t1.meetingStatus > 1 and (t1.cancel <> 1 or t1.cancel is null) ");
	sqlStringBuffer.append(" AND ((t1.begindate > '");
	sqlStringBuffer.append(CurrentDate);
	sqlStringBuffer.append("') OR (t1.beginDate = '");
	sqlStringBuffer.append(CurrentDate);
	sqlStringBuffer.append("' And t1.begintime > = '");
	sqlStringBuffer.append(CurrentTime);
	sqlStringBuffer.append("' ) ) ");
	sqlStringBuffer.append(" AND ( exists ( select 1 from Meeting_Member2 where t1.id = Meeting_Member2.meetingid and Meeting_Member2.memberid in ("+ allUser +")) or t1.caller in ("+ allUser+") or t1.contacter in( "+allUser +") ) ");
	sqlStringBuffer.append(" order by t1.beginDate, t1.begintime,t1.id ");
	//System.out.println("sql2:"+sqlStringBuffer.toString());
	recordSet.executeSql(sqlStringBuffer.toString());
	String startDate = "";
	String startTime = "";
	String endDate = "";
	String endTime = "";
	String sdt = "";
	String edt = "";
	String sTime = "";
	String meetingRoom = "";
	String meetingname = "";
	String caller = "";
	String members = "";
	if(recordSet.next()){
		startDate = recordSet.getString("beginDate");
		startTime = recordSet.getString("begintime");
		endDate = recordSet.getString("endDate");
		endTime = recordSet.getString("endtime");
		SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy HH:mm");
		SimpleDateFormat format2 = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		//System.out.println("startTime:"+startTime);
		Date sDate = format2.parse(startDate.trim()	+ " " + startTime.trim());
		sTime = format.format(sDate);
		sdt = startDate.trim()	+ " " + startTime.trim();
		edt = endDate.trim()	+ " " + endTime.trim();
		//System.out.println("sTime:"+sTime);
		meetingRoom = MeetingRoomComInfo.getMeetingRoomInfoname(Util.null2String(recordSet.getString("address")));
		if(meetingRoom == null || "".equals(meetingRoom)){
			meetingRoom = Util.null2String(recordSet.getString("customizeAddress")+"("+SystemEnv.getHtmlLabelName(19516,user.getLanguage())+")");
		}
		meetingname = recordSet.getString("name");
		caller = ResourceComInfo.getLastname(Util.null2String(recordSet.getString("caller")));
		int id = recordSet.getInt("id");
		rs.executeSql("select memberid, membertype from Meeting_Member2 where  meetingid ="+ id + " order by membertype,id");
		String mname = "";
		while(rs.next()){
			int mbrtype = rs.getInt("membertype");
			if(mbrtype == 1){
				mname = ResourceComInfo.getLastname(Util.null2String(rs.getString("memberid")));
				members += ("".equals(mname))?"":(mname+" ");
			} else if(mbrtype == 2){
				mname = CustomerInfoComInfo.getCustomerInfoname(Util.null2String(rs.getString("memberid")));
				members += ("".equals(mname))?"":(mname+" ");
			}
		}
		
		
	%>
	  <table height=100% border="0" cellspacing="0" cellpadding="0">
		<COLGROUP>
		<COL width="10px">
		<COL width="182px">
		<COL width="10px">
		<tr style="vertical-align: top;">
			<td>&nbsp;&nbsp;&nbsp;</td>
			<td>
				<div style="overflow:hidden;width:148px;color:#000;margin-top:15px;min-height:34px;margin-bottom:15px;padding-left: 30px;background-image: url(/images/ecology8/meeting/mt-3_wev8.png); background-position: 0px 50%; background-repeat: no-repeat;"> 
				<p style="word-break: break-all;"><%=SystemEnv.getHtmlLabelName(82888,user.getLanguage())%><span id="showTime"  ></span><%=SystemEnv.getHtmlLabelName(82889,user.getLanguage())%></p></div>
			</td>
			<td>&nbsp;&nbsp;&nbsp;</td>
		</tr>
		<tr style="height:1px;">
			<td></td>
			<td class="Lineblack" >
			</td>
			<td></td>
		</tr>
		<tr style="vertical-align: top;">
			<td></td>
			<td>
				<div class="spanhead" style="color:#929292;margin-top:15px;margin-bottom:1px;padding-left: 18px;background-image: url(/images/ecology8/meeting/mt-2-1_wev8.png); background-position: 0px 50%; background-repeat: no-repeat;"><%=SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("2")),user.getLanguage()) %></div>
				<div style="overflow:hidden;width:163px;color:#000;margin-top:0px;margin-bottom:15px;padding-left: 15px;" title="<%=meetingname%>"><p style="word-break: break-all;"><%=meetingname%></p></div>
			</td>
			<td></td>
		</tr>
		<tr style="height:1px;">
			<td></td>
			<td class="Lineblack" >
			</td>
			<td></td>
		</tr>
		<tr style="vertical-align: top;">
			<td></td>
			<td>
				<div class="spanhead" style="color:#929292;margin-top:15px;margin-bottom:1px;padding-left: 18px;background-image: url(/images/ecology8/meeting/mt-2-2_wev8.png); background-position: 0px 50%; background-repeat: no-repeat;"><%=SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("5")),user.getLanguage()) %></div>
				<div style="overflow:hidden;width:163px;color:#000;margin-top:0px;margin-bottom:15px;padding-left: 15px;" title="<%=meetingRoom%>"><p style="word-break: break-all;"><%=meetingRoom%></p></div>
			</td>
			<td></td>
		</tr>
		<tr style="height:1px;">
			<td></td>
			<td class="Lineblack" >
			</td>
			<td></td>
		</tr>
		<tr style="vertical-align: top;">
			<td></td>
			<td>
				<div class="spanhead" style="color:#929292;margin-top:15px;margin-bottom:10px;padding-left: 18px;background-image: url(/images/ecology8/meeting/mt-2-4_wev8.png); background-position: 0px 50%; background-repeat: no-repeat;"><%=SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("3")),user.getLanguage()) %></div>
				<div style="overflow:hidden;width:163px;color:#000;margin-top:0px;margin-bottom:15px;padding-left: 15px;" ><p style="word-break: break-all;"><%=caller%></p></div>
			</td>
			<td></td>
		</tr>
		<tr style="height:1px;">
			<td></td>
			<td class="Lineblack" >
			</td>
			<td></td>
		</tr>
		<tr style="vertical-align: top;">
			<td></td>
			<td>
				<div class="spanhead" style="color:#929292;margin-top:10px;margin-bottom:10px;padding-left: 18px;background-image: url(/images/ecology8/meeting/mt-2-3_wev8.png); background-position: 0px 50%; background-repeat: no-repeat;"><%=SystemEnv.getHtmlLabelName(277,user.getLanguage()) %></div>
				<div style="overflow:hidden;width:163px;color:#000;margin-top:0px;margin-bottom:15px;padding-left: 15px;" title="<%=sdt+" ~ "+ edt%>"><p style="word-break: break-all;"><%=sdt+" ~ "+ edt%></p></div>
			</td>
			<td></td>
		</tr>
		<tr style="height:1px;">
			<td></td>
			<td class="Lineblack" >
			</td>
			<td></td>
		</tr>
		<tr style="vertical-align: top;">
			<td></td>
			<td>
				<div class="spanhead" style="color:#929292;margin-top:10px;margin-bottom:10px;padding-left: 18px;background-image: url(/images/ecology8/meeting/mt-2-5_wev8.png); background-position: 0px 50%; background-repeat: no-repeat;"><%=SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("29")),user.getLanguage()) %></div>
				<div style="overflow:hidden;width:163px;color:#000;margin-top:0px;margin-bottom:15px;padding-left: 15px;"><p style="word-break: break-all;"><%=members%></p></div>
			</td>
			<td></td>
		</tr>
		</table>
	  <input id="sTime" name="sTime" type="hidden" value="<%=sTime %>" />
	<%
	} else {
	
		out.print(SystemEnv.getHtmlLabelName(82887,user.getLanguage()));
	
	}
}else if("getSubordinate".equals(method)){
	request.getRequestDispatcher("/workplan/calendar/data/WorkPlanViewOperation.jsp").forward(request,response);
}


 %> 