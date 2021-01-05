<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.meeting.Maint.MeetingTransMethod"%>
<%@page import="weaver.meeting.MeetingShareUtil"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@page import="weaver.meeting.defined.MeetingFieldManager"%>
<%@page import="org.json.JSONObject"%> 
<%@ page import="weaver.general.IsGovProj" %>
<%@page import="weaver.meeting.util.html.HtmlUtil"%> 
<%@ page import="weaver.workflow.request.RequestInfo" %>
<%@page import="java.net.*"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="meetingSetInfo" class="weaver.meeting.Maint.MeetingSetInfo" scope="page"/>
<jsp:useBean id="MeetingFieldComInfo" class="weaver.meeting.defined.MeetingFieldComInfo" scope="page"/>
<jsp:useBean id="MeetingFieldGroupComInfo" class="weaver.meeting.defined.MeetingFieldGroupComInfo" scope="page"/>
<%@ include file="/cowork/uploader.jsp" %>
 
<%
String showDiv = Util.null2String(request.getParameter("showdiv"));
String needRefresh=Util.null2String(request.getParameter("needRefresh"));
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
String userid = ""+user.getUID();
String logintype = ""+user.getLogintype();

String meetingid = Util.null2String(request.getParameter("meetingid"));
String errmsg = Util.null2String(request.getParameter("errmsg"));
errmsg=URLDecoder.decode(errmsg,"UTF-8");
if(!errmsg.isEmpty()){
	out.print("<script>window.top.Dialog.alert('"+errmsg+"');</script>");
}
String tab = Util.null2String(request.getParameter("tab"));
if(!"1".equals(tab)){
	//response.sendRedirect("/meeting/data/ViewMeetingTab.jsp?meetingid="+meetingid) ;
	out.println("<script>wfforward(\"/meeting/data/ViewMeetingTab.jsp?meetingid="+meetingid+"\");</script>");
	return;
}

RecordSet.executeProc("Meeting_SelectByID",meetingid);
RecordSet.next();
String meetingtype=RecordSet.getString("meetingtype");
String meetingname=RecordSet.getString("name");
String caller=RecordSet.getString("caller");
String contacter=RecordSet.getString("contacter");
String address=RecordSet.getString("address");
String customizeAddress=RecordSet.getString("customizeAddress");
String begindate=RecordSet.getString("begindate");
String begintime=RecordSet.getString("begintime");
String enddate=RecordSet.getString("enddate");
String endtime=RecordSet.getString("endtime");
String creater=RecordSet.getString("creater");
String createdate=RecordSet.getString("createdate");
String createtime=RecordSet.getString("createtime");
String approver=RecordSet.getString("approver");
String approvedate=RecordSet.getString("approvedate");
String approvetime=RecordSet.getString("approvetime");
String isapproved=RecordSet.getString("isapproved");
String meetingstatus=RecordSet.getString("meetingstatus");
String hrmids=RecordSet.getString("hrmmembers");
String crmids=RecordSet.getString("crmmembers");
int MeetingMemberCount="".equals(hrmids)?0:1;
String remindTypeNew=RecordSet.getString("remindTypeNew");
int repeatType = Util.getIntValue(RecordSet.getString("repeatType"),0);
String repeatbegindate=RecordSet.getString("repeatbegindate");
String repeatenddate=RecordSet.getString("repeatenddate");

int requestid = RecordSet.getInt("requestid");

//判断requestid是否有效
if(requestid>0){
	RecordSet2.execute("SELECT count(1) as c FROM workflow_requestbase where requestid="+requestid);
	RecordSet2.next();
	if(RecordSet2.getInt("c")==0){
		RecordSet2.execute("update meeting set requestid=0 where id="+meetingid);
		requestid=0;
	}
}

boolean hideAddress=true;//是否隐藏会议室
if("".equals(address)&&"".equals(customizeAddress)){
	hideAddress=false;
}	

RequestInfo rqInfo = null;
if(requestid!=0){
	rqInfo = new RequestInfo(requestid,user);
	//System.out.println("requestInfo.getWorkflowid() = "+requestInfo.getWorkflowid());
}else{
	rqInfo = new RequestInfo();
}

if(meetingstatus.equals("2")){
	//response.sendRedirect("/meeting/data/ProcessMeeting.jsp?tab=1&meetingid="+meetingid+"&meetingstatus="+meetingstatus) ;
	out.println("<script>wfforward(\"/meeting/data/ViewMeetingTab.jsp?needRefresh="+needRefresh+"&meetingid="+meetingid+"&meetingstatus="+meetingstatus+"\");</script>");
	return;
}

//标识会议已看
StringBuffer stringBuffer = new StringBuffer();
stringBuffer.append("UPDATE Meeting_View_Status SET status = '1'");		
stringBuffer.append(" WHERE meetingId = ");
stringBuffer.append(meetingid);
stringBuffer.append(" AND userId = ");
stringBuffer.append(userid);
RecordSet.executeSql(stringBuffer.toString());

boolean canedit=false;
boolean cansubmit=false;
boolean candelete=false;
boolean canview=false;
boolean canapprove=false;
boolean canschedule=false;


boolean ismanager=false;
boolean iscontacter=false;
boolean ismember=false;
boolean isservicer=false;
boolean isdecisioner=false;
String isdecision="-1";
int approvewfid = -1;

if(!"".equals(meetingtype)){
	RecordSet.executeProc("Meeting_Type_SelectByID",meetingtype);
	RecordSet.next();
	approvewfid =RecordSet.getInt("approver");
	if(repeatType>0){//周期会议,查看周期会议的审批流程
		approvewfid =RecordSet.getInt("approver1");
	}
}
if(approvewfid<0) approvewfid = 0 ;

String allUser=MeetingShareUtil.getAllUser(user);

if(MeetingShareUtil.containUser(allUser,caller)|| MeetingShareUtil.containUser(allUser,creater)||  MeetingShareUtil.containUser(allUser,contacter)&& !meetingstatus.equals("2")){
	canedit=true;
	cansubmit=true;
	candelete=true;
}

if(MeetingShareUtil.containUser(allUser,caller)|| MeetingShareUtil.containUser(allUser,contacter)|| MeetingShareUtil.containUser(allUser,creater)){
	canview=true;
}
String Sql = "";
if(RecordSet.getDBType().equals("oracle")){
	Sql="select memberid from Meeting_Member2 where meetingid="+meetingid+" and ( membermanager in ("+allUser+") " ;
	String[] belongs=allUser.split(",");
	for(int i=0;i<belongs.length;i++){
		if("".equals(belongs[i])) continue;
		Sql+=" or ','|| othermember|| ',' like '%,"+belongs[i]+",%' ";
	}
	Sql+=")";
}else{
	Sql="select memberid from Meeting_Member2 where meetingid="+meetingid+" and ( membermanager in ("+allUser+" )";
	String[] belongs=allUser.split(",");
	for(int i=0;i<belongs.length;i++){
		if("".equals(belongs[i])) continue;
		Sql+=" or ','+othermember+',' like '%,"+belongs[i]+",%' ";
	}
	Sql+=")";
}
//System.out.println("sql = "+Sql);
RecordSet.executeSql(Sql);
if(RecordSet.next()) {
	canview=true;
	ismember=true;
}

stringBuffer = new StringBuffer();
stringBuffer.append("SELECT * From Meeting, Meeting_ShareDetail");
stringBuffer.append(" WHERE Meeting.id = Meeting_ShareDetail.meetingId");
stringBuffer.append(" AND Meeting.id = ");
stringBuffer.append(meetingid);
stringBuffer.append(" AND((Meeting_ShareDetail.userid in ("+allUser+")");
stringBuffer.append(" AND Meeting_ShareDetail.shareLevel in (1, 4))");
stringBuffer.append(" OR (Meeting.meetingStatus = 4");
stringBuffer.append(" AND Meeting_ShareDetail.userId in("+allUser+") ");
stringBuffer.append("))");

RecordSet.executeSql(stringBuffer.toString());
if(RecordSet.next()){ 
	canview = true;
}
	
if(!canview){	
	/***检查是否会议室管理员****/
	rs.executeSql("select resourceid from hrmrolemembers where roleid = 11 and resourceid in ("+allUser+")") ;
	if(rs.next()){
		canview=true;
	}
}
if(!canview){
	/***检查通过审批流程查看会议***/
	rs.executeSql("select userid from workflow_currentoperator where requestid = "+requestid+" and userid in( "+allUser+")") ;
	if(rs.next()){
		canview=true;
	}
}

if(!canview){
	//response.sendRedirect("/notice/noright.jsp") ;
	out.println("<script>wfforward(\"/notice/noright.jsp\");</script>");
	return;
}

int userPrm=1;
String f_weaver_belongto_userid=user.getUID()+"";
if(MeetingShareUtil.containUser(allUser,caller)){//是召集人
	userPrm = meetingSetInfo.getCallerPrm();
	if(userPrm != 3) userPrm = 3;
	if(!userid.equals(caller)){
		f_weaver_belongto_userid=caller;
	}
}else{
	if(MeetingShareUtil.containUser(allUser,contacter)){//联系人
		   userPrm=meetingSetInfo.getContacterPrm();
	   if(userPrm==3){
		   if(!userid.equals(contacter)){
			   f_weaver_belongto_userid=contacter;
		   }
	   }
	} 
	if(MeetingShareUtil.containUser(allUser,creater)&&userPrm<3){//创建人且权限小于3
	   if(userPrm < meetingSetInfo.getCreaterPrm()){//当前权限小于创建人权限 赋创建人权限
		   userPrm=meetingSetInfo.getCreaterPrm();
	   }
	   if(userPrm==3){
		   if(!userid.equals(creater)){
			   f_weaver_belongto_userid=creater;
		   }
	   }
	}
} 

String isrejectremind="";
String ischangrejectnode="";
String isselectrejectnode="";
if(requestid>0){
	RecordSet.executeSql("select isTriDiffWorkflow,isrejectremind,ischangrejectnode,isselectrejectnode from workflow_base where id="+rqInfo.getWorkflowid());
	if(RecordSet.next()){
	    isrejectremind=Util.null2String(RecordSet.getString("isrejectremind"));
	    ischangrejectnode=Util.null2String(RecordSet.getString("ischangrejectnode"));
		  isselectrejectnode=Util.null2String(RecordSet.getString("isselectrejectnode"));
	}
}
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<script language=javascript src="/js/weaver_wev8.js"></script>
</HEAD>
<%

String titlename="";
titlename+= "<B>"+SystemEnv.getHtmlLabelName(401,user.getLanguage())+":</B>"+createdate;
/*
if(user.getLogintype().equals("1"))
titlename +=Util.toScreen(ResourceComInfo.getResourcename(creater),user.getLanguage());

titlename +="<B>"+SystemEnv.getHtmlLabelName(142,user.getLanguage())+":</B>"+approvedate+"<B> "+SystemEnv.getHtmlLabelName(623,user.getLanguage())+":</B>" ;
if(user.getLogintype().equals("1"))
titlename +=Util.toScreen(ResourceComInfo.getResourcename(approver),user.getLanguage());
*/

String imagefilename = "/images/hdMaintenance_wev8.gif";
titlename = SystemEnv.getHtmlLabelName(2103,user.getLanguage())+":"+Util.forHtml(meetingname)+"   "+titlename;
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	//编辑
	if(canedit&&!meetingstatus.equals("1") && !meetingstatus.equals("4")&& !meetingstatus.equals("5"))
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:doEdit(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;

	}
	
	//批准
	if(rqInfo.getHasright()==1&&!rqInfo.getIsend().equals("1")&&!rqInfo.getNodetype().equals("0") && !meetingstatus.equals("4")&& !meetingstatus.equals("5"))
	{
    	RCMenu += "{"+SystemEnv.getHtmlLabelName(142,user.getLanguage())+",javascript:doSubmit(this),_top} " ;
    	RCMenuHeight += RCMenuHeightStep ;
	}
	
	//提交审批
	if(rqInfo.getHasright()==1&&!rqInfo.getIsend().equals("1")&&rqInfo.getNodetype().equals("0") && !meetingstatus.equals("4")&& !meetingstatus.equals("5"))
	{
    	RCMenu += "{"+SystemEnv.getHtmlLabelName(15143,user.getLanguage())+",javascript:doSubmit2(this),_top} " ;
    	RCMenuHeight += RCMenuHeightStep ;
	}
	
	//退回
	if(rqInfo.getHasright()==1&&rqInfo.getIsreject().equals("1") && !meetingstatus.equals("4")&& !meetingstatus.equals("5"))
	{
    	RCMenu += "{"+SystemEnv.getHtmlLabelName(236,user.getLanguage())+",javascript:doReject(this),_top} " ;
    	RCMenuHeight += RCMenuHeightStep ;
	}

	//没有工作流时,提交审批
	if(requestid==0&&!meetingstatus.equals("2")&&approvewfid != 0&&canedit && !meetingstatus.equals("4")&& !meetingstatus.equals("5"))
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(15143,user.getLanguage())+",javascript:reSubmit(this),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	
	//提交
	if(requestid==0&&approvewfid==0&&canedit && !meetingstatus.equals("3")&&!meetingstatus.equals("4")&& !meetingstatus.equals("5"))
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:reSubmit2(this),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}

	//当状态为待审批、正常，召集人可取消会议
	if(("1".equals(meetingstatus) || "2".equals(meetingstatus)) && (MeetingShareUtil.containUser(allUser,caller)|| userPrm == 3))
	{
		RCMenu += "{" + SystemEnv.getHtmlLabelName(20115, user.getLanguage()) + ",javascript:cancelMeeting(this),_self}";
		RCMenuHeight += RCMenuHeightStep;
	}
	//删除
	if(candelete&&!meetingstatus.equals("1") && !meetingstatus.equals("4")&& !meetingstatus.equals("5"))
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;

	}

	//关闭
	RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:btn_cancle(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
%>
	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan"
			style="text-align: right; width: 400px !important">
			<%
				//编辑
				if(canedit&&!meetingstatus.equals("1") && !meetingstatus.equals("4")&& !meetingstatus.equals("5"))
				{
			%>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(93,user.getLanguage()) %>" class="e8_btn_top middle" onclick="doEdit()"/>
			<%
				}
			%>
			<%
				//批准
				if(rqInfo.getHasright()==1&&!rqInfo.getIsend().equals("1")&&!rqInfo.getNodetype().equals("0") && !meetingstatus.equals("4")&& !meetingstatus.equals("5"))
				{
			%>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(142,user.getLanguage()) %>" class="e8_btn_top middle" onclick="doSubmit(this)"/>
			<%
				}
				
				//提交审批
				if(rqInfo.getHasright()==1&&!rqInfo.getIsend().equals("1")&&rqInfo.getNodetype().equals("0") && !meetingstatus.equals("4")&& !meetingstatus.equals("5"))
				{
			%>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(15143,user.getLanguage()) %>" class="e8_btn_top middle" onclick="doSubmit2(this)"/>
			<%
				}
				
				//退回
				if(rqInfo.getHasright()==1&&rqInfo.getIsreject().equals("1") && !meetingstatus.equals("4")&& !meetingstatus.equals("5"))
				{
			%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage()) %>" class="e8_btn_top middle" onclick="doReject(this)"/>
			<%
				}

				//没有工作流时,提交审批
				if(requestid==0&&!meetingstatus.equals("2")&&approvewfid != 0&&canedit && !meetingstatus.equals("4")&& !meetingstatus.equals("5"))
				{
			%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(15143,user.getLanguage()) %>" class="e8_btn_top middle" onclick="reSubmit(this)"/>
			<%
				}
				
				//提交
				if(requestid==0&&approvewfid==0&&canedit && !meetingstatus.equals("3")&&!meetingstatus.equals("4")&& !meetingstatus.equals("5"))
				{

			%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(615,user.getLanguage()) %>" class="e8_btn_top middle" onclick="reSubmit2(this)"/>
			<%
				}

				//当状态为待审批、正常，召集人可取消会议
				if(("1".equals(meetingstatus) || "2".equals(meetingstatus)) && (MeetingShareUtil.containUser(allUser,caller)||userPrm == 3))
				{
			%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(20115,user.getLanguage()) %>" class="e8_btn_top middle" onclick="cancelMeeting(this)"/>
			<%
				}
				//删除
				if(candelete&&!meetingstatus.equals("1") && !meetingstatus.equals("4")&& !meetingstatus.equals("5"))
				{
			%>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>" class="e8_btn_top middle" onclick="doDelete()"/>
			<%
				}
			%>
			<span
				title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>"  class="cornerMenu middle"></span>
		</td>
	</tr>
</table>


<div id="tabDiv">
	<span style="width:10px"></span>
	<span id="hoverBtnSpan" class="hoverBtnSpan">
	</span>
</div>
<div class="zDialog_div_content" >

<div id="nomalDiv">
<wea:layout type="2col">
<%    
//遍历分组
MeetingFieldManager hfm = new MeetingFieldManager(1);
rs.executeSql("select * from "+hfm.getBase_datatable()+" where id = " + meetingid);
rs.next();
List<String> groupList=hfm.getLsGroup();
List<String> fieldList=null;
for(String groupid:groupList){
	fieldList= hfm.getUseField(groupid);
	if(fieldList!=null&&fieldList.size()>0){		
%>
<wea:group context='<%=SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldGroupComInfo.getLabel(groupid)), user.getLanguage()) %>' attributes="{'groupDisplay':''}">
	<%for(String fieldid:fieldList){
		if(repeatType > 0) {//周期会议
			if("0".equals(MeetingFieldComInfo.getIsrepeat(fieldid))) continue;
		}else{//非周期会议
			if("1".equals(MeetingFieldComInfo.getIsrepeat(fieldid))) continue;
		}
		if("0".equals(MeetingFieldComInfo.getIsused(fieldid))) continue;//没有启用,隐藏处理
		
		String fieldname = MeetingFieldComInfo.getFieldname(fieldid);
		int fieldlabel = Util.getIntValue(MeetingFieldComInfo.getLabel(fieldid));
		int fieldhtmltype = Integer.parseInt(MeetingFieldComInfo.getFieldhtmltype(fieldid));
		int type = Integer.parseInt(MeetingFieldComInfo.getFieldType(fieldid));
		String fielddbtype = MeetingFieldComInfo.getFielddbtype(fieldid);
		boolean issystem ="1".equals(MeetingFieldComInfo.getIssystem(fieldid))||"0".equals(MeetingFieldComInfo.getIssystem(fieldid));
		boolean ismand="1".equals(MeetingFieldComInfo.getIsmand(fieldid));
		String weekStr="";
		JSONObject cfg= hfm.getFieldConf(fieldid);
		String fieldValue = rs.getString(fieldname);
		
		String extendHtml="";	
		if("address".equalsIgnoreCase(fieldname)){//会议地点
			extendHtml="<div class=\"FieldDiv\" id=\"selectRoomdivb\" name=\"selectRoomdivb\" style=\"margin-right:200px;float:right;\">"+
							"<A href=\"javascript:showRooms('"+begindate+"');\" style=\"color:blue;\">"+SystemEnv.getHtmlLabelName(2193,user.getLanguage())+"</A>"+
						"</div>";
			if(("".equals(fieldValue)||"0".equals(fieldValue))&&hideAddress) continue;
		}else if("customizeAddress".equalsIgnoreCase(fieldname)){
			if("".equals(fieldValue)) continue;
		}else if("name".equalsIgnoreCase(fieldname)){
			extendHtml=new MeetingTransMethod().getMeetingStatus(meetingstatus,user.getLanguage()+"+"+enddate+"+"+endtime+"+"+isdecision+"+"+repeatenddate+"+"+repeatType);
			extendHtml="".equals(extendHtml)?"":"&nbsp;&nbsp;&nbsp;("+extendHtml+")";
		}
		
		//转成html显示
		if(fieldhtmltype==4){//check框,变成disabled
			cfg.put("disabled","disabled");
			fieldValue=HtmlUtil.getHtmlElementString(fieldValue,cfg,user);
		}else if(fieldhtmltype==6){
			cfg.put("canDelAcc",false);//是否有删除按钮
			cfg.put("canupload",false);//是否可以上传
			cfg.put("candownload",true);//是否有下载按钮
			fieldValue=HtmlUtil.getHtmlElementString(fieldValue,cfg,user);
		}else if(fieldhtmltype==3){
			fieldValue=hfm.getHtmlBrowserFieldvalue(user,Integer.parseInt(fieldid),fieldhtmltype,type,fieldValue,fielddbtype,meetingid);
		}else{
			fieldValue=hfm.getFieldvalue(user, Integer.parseInt(fieldid), fieldhtmltype, type, fieldValue, 0,fielddbtype);
		}
		
		if("remindTypeNew".equalsIgnoreCase(fieldname)){
			fieldValue="".equals(fieldValue)?SystemEnv.getHtmlLabelName(19782,user.getLanguage()):fieldValue;
		}else if("rptWeekDays".equalsIgnoreCase(fieldname)){
			weekStr=fieldValue;
		}
		
		//特殊处理字段,需要合并处理
		if("remindHoursBeforeStart".equalsIgnoreCase(fieldname)||"remindTimesBeforeStart".equalsIgnoreCase(fieldname)
				||"remindHoursBeforeEnd".equalsIgnoreCase(fieldname)||"remindTimesBeforeEnd".equalsIgnoreCase(fieldname)
				|"repeatweeks".equalsIgnoreCase(fieldname)||"rptWeekDays".equalsIgnoreCase(fieldname)
				||"repeatmonths".equalsIgnoreCase(fieldname)||"repeatmonthdays".equalsIgnoreCase(fieldname))
			continue;

		//提醒时间特殊处理		
		if("remindBeforeStart".equals(fieldname)){
	%>	
		<wea:item attributes="{'samePair':'remindtimetr'}">
		<%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%>
		</wea:item> 
		<wea:item attributes="{'samePair':'remindtimetr'}">
			<div style="float:left;">
				<%=fieldValue%>
				&nbsp;&nbsp;<span><%=SystemEnv.getHtmlLabelName(19784,user.getLanguage())%></span>
				&nbsp;<%=rs.getString("remindHoursBeforeStart")%>&nbsp;
				<span><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></span>
				&nbsp;<%=rs.getString("remindTimesBeforeStart")%>&nbsp;
				<span><%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%></span>
			</div>
		</wea:item>	
	<%		
		}else if("remindBeforeEnd".equals(fieldname)){
	%>	
		<wea:item attributes="{'samePair':'remindtimetr'}">
		<%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%>
		</wea:item> 
		<wea:item attributes="{'samePair':'remindtimetr'}">
			<div style="float:left;">
				<%=fieldValue%>
				&nbsp;&nbsp;<span><%=SystemEnv.getHtmlLabelName(19785,user.getLanguage())%></span>
				&nbsp;<%=rs.getString("remindHoursBeforeEnd")%>&nbsp;
				<span><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></span>
				&nbsp;<%=rs.getString("remindTimesBeforeEnd")%>&nbsp;
				<span><%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%></span>
			</div>
		</wea:item>	
	<%		
		}else if("remindImmediately".equalsIgnoreCase(fieldname)){
	%>	
		<wea:item attributes="{'samePair':'remindtimetr'}">
			<%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%>
		</wea:item> 
		<wea:item attributes="{'samePair':'remindtimetr'}">
			<%=fieldValue%>
		</wea:item>	
	<%		
		}else if("repeatdays".equalsIgnoreCase(fieldname)){//重复会议时间处理
		
	%>	
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(25898,user.getLanguage())%>
		</wea:item> 
		<wea:item>
			<%if(repeatType==1){
				out.println(rs.getString("repeatdays")+SystemEnv.getHtmlLabelName(1925,user.getLanguage()));
			}else if(repeatType==2){
				if("".equals(weekStr)){
					weekStr=hfm.getHtmlBrowserFieldvalue(user,11,3,268,rs.getString("rptWeekDays"),fielddbtype,meetingid);
				}
				out.println(SystemEnv.getHtmlLabelName(21977,user.getLanguage())+"&nbsp;"+rs.getString("repeatweeks")+
						"&nbsp;"+SystemEnv.getHtmlLabelName(1926,user.getLanguage())+"&nbsp;&nbsp;&nbsp;&nbsp;"+weekStr);
			}else if(repeatType==3){
				out.println(SystemEnv.getHtmlLabelName(21977,user.getLanguage())+"&nbsp;"+rs.getString("repeatmonths")+"&nbsp;"+
						SystemEnv.getHtmlLabelName(25901,user.getLanguage())+"&nbsp;"+rs.getString("repeatmonthdays")+"&nbsp;"+
						SystemEnv.getHtmlLabelName(1925,user.getLanguage()));
			} %>
		</wea:item>	
	<%	
	}else{%>		
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%>
		</wea:item> 
		<wea:item>
			<%=fieldValue%>
			<%=extendHtml%>
		</wea:item>	
	<%	}
	}%>
</wea:group>
<%}
}%>	
 
</wea:layout>
</div>
<div id="serviceDiv" style="display:none;">
	<%
		
     %>   		
	<TABLE class="ViewForm">
        <TBODY>
        <TR class="Spacing" style="height:1px!important;">
          <TD class="Line1" colspan=2></TD></TR>
        <tr>
        	<td class="Field" colspan=2>
        	<%
        	RecordSet3.execute("select * from Meeting_Service_New where meetingid="+meetingid);
        	MeetingFieldManager hfm3 = new MeetingFieldManager(3);
        	List<String> groupList=hfm3.getLsGroup();
        	List<String> fieldList=null;
        	for(String groupid:groupList){
        		fieldList= hfm3.getUseField(groupid);
        		
        		if(fieldList!=null&&fieldList.size()>0){
        			int colSize=fieldList.size();
        			
        	%>		<table id="serviceTabField" class=ListStyle  border=0 cellspacing=1>
        			  <colgroup>
        	<%		for(int i=0;i<colSize;i++){
        				out.print("<col width='"+(95/colSize)+"%'>\n");
        			}
        			out.println("</colgroup>\n");
        			out.println("<TR class=HeaderForXtalbe>\n");
        		  	
        			for(String fieldid:fieldList){
        				int fieldlabel = Util.getIntValue(MeetingFieldComInfo.getLabel(fieldid));
        				out.println("<th>"+SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())+"</th>\n");
	        
	   				}
        			out.print("</tr>\n"); 
        			
        			
        			while(RecordSet3.next()){
        				out.print("<tr class='DataLight'>\n"); 
        				for(String fieldid:fieldList){
            				String fieldname = MeetingFieldComInfo.getFieldname(fieldid);
            				String fielddbtype=MeetingFieldComInfo.getFielddbtype(fieldid);
            				int fieldhtmltype = Integer.parseInt(MeetingFieldComInfo.getFieldhtmltype(fieldid));
            				int type = Integer.parseInt(MeetingFieldComInfo.getFieldType(fieldid));
            				JSONObject cfg= hfm3.getFieldConf(fieldid);
            				String fieldValue = RecordSet3.getString(fieldname);
            				//转成html显示
            				if(fieldhtmltype==4){//check框,变成disabled
            					cfg.put("disabled","disabled");
            					fieldValue=HtmlUtil.getHtmlElementString(fieldValue,cfg,user);
            				}else if(fieldhtmltype==3){
            					fieldValue=hfm3.getHtmlBrowserFieldvalue(user,Integer.parseInt(fieldid),fieldhtmltype,type,fieldValue,fielddbtype,meetingid);
            				}else{
            					fieldValue=hfm3.getFieldvalue(user, Integer.parseInt(fieldid), fieldhtmltype, type, fieldValue, 0,fielddbtype);
            				}
            				
            				out.println("<td>"+fieldValue+"</td>\n");
    	        
    	   				}
        				out.print("</tr>\n"); 
        			}
        			out.print("</table>\n"); 
        		}
        	}
        	%>         
        </td></tr>

        </TBODY>
	  </TABLE>
</div>

  <FORM id=weaver name=weaver action="/workflow/request/BillMeetingOperation.jsp" method=post>
	<%if(requestid!=0){%>
	  <%if(rqInfo.getHasright()==1||rqInfo.getIsremark()==1){%>
			<input type=hidden name="requestid" value=<%=rqInfo.getRequestid()%>>
			<input type=hidden name="workflowid" value=<%=rqInfo.getWorkflowid()%>>
			<input type=hidden name="nodeid" value=<%=rqInfo.getNodeid()%>>
			<input type=hidden name="nodetype" value=<%=rqInfo.getNodetype()%>>
			<input type=hidden name="src">
			<input type=hidden name="iscreate" value="0">
			<input type=hidden name="formid" value=<%=rqInfo.getFormid()%>>
			<input type=hidden name="billid" value=<%=rqInfo.getBillid()%>>
			<input type=hidden name="requestname" value="<%=rqInfo.getRequestname()%>">
			<input type=hidden name="isfrommeeting" value="1">
			<input type=hidden name="isremark" value="<%=rqInfo.getIsremark()%>">
			<input type="hidden" name="MeetingID" value="<%=meetingid%>"/>
			<input type="hidden" name="approve"/>
			<input type="hidden" name="approvemeeting"/>
			<input type="hidden" name="RejectNodes" id="RejectNodes"/>
			<input type="hidden" name="RejectToNodeid" id="RejectToNodeid"/>
			<INPUT type="hidden" name="f_weaver_belongto_userid" value="<%=f_weaver_belongto_userid %>">
		<%}%>
	<%}%>

  </FORM>

<!--相关交流-->
<div id="discussDiv" style="display:none">
<% String types = "MP";
   String sortid =  meetingid;
 %>
<%@ include file="/meeting/data/MeetingDiscuss.jsp" %>
</div>
<!--议程 -->
<div id="agendaDiv" style="display:none">
	<%@ include file="/meeting/data/MeetingTopicList.jsp" %>
</div>
<!--参会情况 -->
<div id="memberDiv" style="display:none">
</div>
<!--会议决议 -->
<div id="dicisionDiv" style="display:none">
</div>
<script language=javascript>
var diag_vote;
function showDialog(url, title, w,h){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = w;
	diag_vote.Height = h;
	diag_vote.Modal = true;
	diag_vote.Title = title;
	diag_vote.URL = url;
	diag_vote.show();
}

function doEdit(){
	//var parentWin = parent.getParentWindow(window);
	//parentWin.diag_vote.close();
	//parentWin.showDlg("编辑会议", "/meeting/data/EditMeetingTab.jsp?meetingid=<%=meetingid%>",parentWin.diag_vote,parentWin);
   //location.href="/meeting/data/EditMeetingTab.jsp?meetingid=<%=meetingid%>";
   try{
   		window.parent.doEdit(<%=meetingid%>);
   }catch(e){
   	   parent.location.href="/meeting/data/EditMeetingTab.jsp?meetingid=<%=meetingid%>";
   }
}

function doDelete(){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(23069,user.getLanguage())%>?", function (){
           location.href="/meeting/data/MeetingOperation.jsp?meetingid=<%=meetingid%>&method=delete&f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>"
       });

}

function doBack(){
    history.back();
}

function opendoc(showid,versionid,docImagefileid)
{
	openFullWindowHaveBar("/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&meetingid=<%=meetingid%>&isFromAccessory=true");
}
function opendoc1(showid)
{
	openFullWindowHaveBar("/docs/docs/DocDsp.jsp?id="+showid+"&isOpenFirstAss=1&meetingid=<%=meetingid%>");
}
function downloads(files)
{
	document.location.href="/weaver/weaver.file.FileDownload?fileid="+files+"&download=1&meetingid=<%=meetingid%>";
}
function checkuse(){
    
    return false;
}
var meetingmembercount = <%=MeetingMemberCount%>;
	function doSubmit(obj){
	 // if(confirm("你确定要批准吗？")){
	    //document.weaver.approve.value='1';
		submitChkRoom(obj,"4");
	//  }
	}
	function doReject(obj){  
		<%if((isrejectremind.equals("1")&&ischangrejectnode.equals("1"))||isselectrejectnode.equals("1")){%>
			var dialog = new window.top.Dialog();
		    dialog.currentWindow = window;
		    dialog.callbackfunParam = null;
			var url=escape("/workflow/request/RejectNodeSet.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=1&requestid=<%=requestid%>&workflowid=<%=rqInfo.getWorkflowid()%>&nodeid=<%=rqInfo.getNodeid()%>&isrejectremind=<%=isrejectremind%>&ischangrejectnode=<%=ischangrejectnode%>&isselectrejectnode=<%=isselectrejectnode%>");
		    dialog.URL ="/systeminfo/BrowserMain.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=1&url="+url;
		    dialog.callbackfun = function (paramobj, id1) {
		        if(id1) {          
		            if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
		                var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
		                var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
		                var sHtml = "";
		                resourceids = resourceids.substr(0);
		                resourcename = resourcename.substr(0);
		                var val=resourcename.split("|");
		                if($G("RejectNodes")) 
		                   $G("RejectNodes").value=val[0];
					    if($G("RejectToNodeid")) 
					       $G("RejectToNodeid").value=val[1];
					     obj.disabled = true; 
						 document.weaver.src.value='reject';
						 document.weaver.submit();
		           }
	        	}
    		} ;
		    dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214, user.getLanguage())%>";
		    dialog.Height = 400 ;
		    dialog.Drag = true;
		    dialog.show();
		<%}else{%>
			window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(24247,user.getLanguage())%>？", function (){
					obj.disabled = true; 
					document.weaver.src.value='reject';
					document.weaver.submit();
			});
		<%}%>
	}
	var remind="<%=SystemEnv.getHtmlLabelName(24248,user.getLanguage())%>？";
	<%if(meetingSetInfo.getRoomConflictChk()==1&&repeatType>0){%>//开启会议室冲突提醒 并且是周期会议
		remind+="</br></br><font style='color:red;'><%=SystemEnv.getHtmlLabelName(126907, user.getLanguage())%></br><%=SystemEnv.getHtmlLabelName(126908, user.getLanguage())%></font>";
	<%}%>
	function doSubmit2(obj){
		if(meetingmembercount<=0){
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(20118,user.getLanguage())%>");
			return;
		}
		<%if(repeatType>0){%>
			window.top.Dialog.confirm(remind, function (){
				submitChkRoom(obj,"3");
			});
		<%}else{%>
			submitChkRoom(obj,"3");
		<%}%>
	}

	function reSubmit(obj){
		if(meetingmembercount<=0){
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(20118,user.getLanguage())%>");
			return;
		}
		<%if(repeatType>0){%>
			window.top.Dialog.confirm(remind, function (){
				submitChkRoom(obj,"2");
			});
		<%}else{%>
			submitChkRoom(obj,"2");
		<%}%>
		
	}

    function reSubmit2(obj){
		if(meetingmembercount<=0){
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(20118,user.getLanguage())%>");
			return;
		}
		<%if(repeatType>0){%>
			window.top.Dialog.confirm(remind, function (){
				submitChkRoom(obj,"1");
				
			});
		<%}else{%>
			submitChkRoom(obj,"1");
			
		<%}%>
		
		
	}
	
function submitChkRoom(obj,src){
	
	 var thisvalue=<%=repeatType%>;
     //当选择重复会议时，不做会议室和人员冲突校验
     if(thisvalue != 0){
     	checkRepeatMaxDay(obj,src);
		return;
     }
	
	if(<%=meetingSetInfo.getRoomConflictChk()%> == 1 ){
		forbiddenPage();
		$.post("/meeting/data/AjaxMeetingOperation.jsp?method=chkRoom",{address:'<%=address%>',begindate:'<%=begindate%>',begintime:'<%=begintime%>',enddate:'<%=enddate%>',endtime:'<%=endtime%>',requestid:'<%=requestid%>',meetingid:'<%=meetingid%>'},function(datas){
			if(datas != 0){
				<%if(meetingSetInfo.getRoomConflict() == 1){ %>
					releasePage();
					window.top.Dialog.confirm(datas.trim()+"</br><%=SystemEnv.getHtmlLabelName(19095,user.getLanguage())%>", function (){
						submitChkMbr(obj,src);
					});
				<%} else if(meetingSetInfo.getRoomConflict() == 2) {%>
					releasePage();
					Dialog.alert(datas.trim()+"</br><%=SystemEnv.getHtmlLabelName(32875,user.getLanguage())%>!");
				<%}%>
			} else {
				submitChkMbr(obj,src);
			}
		});
		
	} else {
		submitChkMbr(obj,src);
	}
}
	
function submitChkMbr(obj,src){
	 if(<%=meetingSetInfo.getMemberConflictChk()%> == 1){
		forbiddenPage();
  		$.post("/meeting/data/AjaxMeetingOperation.jsp?method=chkMember",{hrmids:'<%=hrmids%>',crmids:'<%=crmids%>',begindate:'<%=begindate%>',begintime:'<%=begintime%>',enddate:'<%=enddate%>',endtime:'<%=endtime%>',meetingid:'<%=meetingid%>'},function(datas){
				var dataObj=null;
				if(datas != ''){
					dataObj=eval("("+datas+")");
				}
				if(wuiUtil.getJsonValueByIndex(dataObj, 0) == "0"){
					submitact(obj,src);
				} else {
					<%if(meetingSetInfo.getMemberConflict() == 1){ %>
						releasePage();
			            window.top.Dialog.confirm(wuiUtil.getJsonValueByIndex(dataObj, 1)+"<%=SystemEnv.getHtmlLabelName(32873,user.getLanguage())%>?", function (){
			                submitact(obj,src);
			            },null, null, 120);
		            <%} else if(meetingSetInfo.getMemberConflict() == 2) {%>
						releasePage();
		            	Dialog.alert(wuiUtil.getJsonValueByIndex(dataObj, 1)+"<%=SystemEnv.getHtmlLabelName(32874,user.getLanguage())%>!" ,null ,400 ,150);
		            	return;
		            <%}%>
				} 
			});
       } else {
       		submitact(obj,src);
       }
}

//周期会议的情况下周期最大跨度校验
function checkRepeatMaxDay(obj,src){
	if(<%=meetingSetInfo.getZqhyzdkd()%> > 0){
		forbiddenPage();
		var endDate = "<%=repeatenddate%>";
  		var tmp = endDate.split("-",3);
  		endDate = tmp[0]+"/"+tmp[1]+"/"+tmp[2];
		var nowDate = new Date();
		//获得最大跨度之后的日期
		nowDate.setDate(nowDate.getDate() + <%=meetingSetInfo.getZqhyzdkd()%>);
		//获取最大跨度日期的年份
		var y = nowDate.getFullYear();
		//获取最大跨度日期的月份
    	var m = nowDate.getMonth()+1;
    	m = m<10?"0"+m:m;
    	//获取最大跨度日期的日
    	var d = nowDate.getDate();
    	d = d<10?"0"+d:d;
    	var maxEndDateStr = y+"/"+m+"/"+d;
    	var Datediff = (Date.parse(maxEndDateStr) - Date.parse(endDate)) / 3600 / 1000; 
    	if(Datediff >= 0){
    		submitact(obj,src);
    	}else{
    		releasePage();
           	Dialog.alert("<%=SystemEnv.getHtmlLabelName(129693,user.getLanguage())%>" ,null ,400 ,150);
           	return;
    	}
    }else{
    	submitact(obj,src);
    }
}

function submitact(obj,src){
	forbiddenPage();
	if(src == "1"){
		obj.disabled = true;
		document.location ="/meeting/data/MeetingOperation.jsp?method=submit&meetingid=<%=meetingid%>";
	}
	//以下是通过流程进行处理
	if(src == "2"){
		obj.disabled = true;
		document.location ="/workflow/request/BillMeetingOperation.jsp?src=submit&viewmeeting=1&iscreate=1&MeetingID=<%=meetingid%>&approvewfid=<%=approvewfid%>";
	}
	if(src == "3"){
		obj.disabled = true;
		document.weaver.src.value='submit';
		document.weaver.submit();
	}
	if(src == "4"){
		obj.disabled = true;
		document.weaver.approvemeeting.value='1';
		document.weaver.src.value='submit';
		document.weaver.submit();
	}
	
}
function forbiddenPage(){  
    window.parent.forbiddenPage();
}  

function releasePage(){  
    window.parent.releasePage();
}
	
 function doSave1(){
	if(check_form(document.Exchange,"ExchangeInfo")){
		document.Exchange.submit();
	}
}


function cancelMeeting(obj)
{
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(20117,user.getLanguage())%>", function (){
		obj.disabled = true;
        document.cancelMeeting.submit();
	});
	
}
 
function btn_cancle(){
	window.parent.closeDialog();
}


jQuery(document).ready(function(){
	releasePage();
	window.parent.hideMember();
	window.parent.hideDicision();

	<%if(!"".equals(showDiv)){%>
		jQuery("#nomalDiv").css("display","none");
		jQuery("#agendaDiv").css("display","none");
		jQuery("#discussDiv").css("display","none");
		jQuery("#memberDiv").css("display","none");
		jQuery("#dicisionDiv").css("display","none");
		jQuery("#<%=showDiv%>").css("display","");
	<%}%>
   <% if( repeatType != 0){ %>
	    window.parent.hideDicision();
		window.parent.hideMember();
		window.parent.hideDiscuss();
	<%} else {%>
		window.parent.showDiscuss();
    <%}%>
   
   
   //是否隐藏提醒
   if("<%=remindTypeNew%>"==''){
		hideEle("remindtimetr", true);
	}else{
		showEle("remindtimetr", true);
	}
	
	resizeDialog(document);
	
});
</script>
		</td>
		</tr>
		</TABLE>
	</td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button"
						value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
						id="zd_btn_cancle" class="zd_btn_cancle" onclick="btn_cancle()">
				</wea:item>
		</wea:group>
	</wea:layout>
</div>
<FORM id="cancelMeeting" name="cancelMeeting" action="/meeting/data/MeetingOperation.jsp" method="post" enctype="multipart/form-data">
	<INPUT type="hidden" name="method" value="cancelMeeting">
	<INPUT type="hidden" name="meetingId" value="<%=meetingid%>">
	<INPUT type="hidden" name="f_weaver_belongto_userid" value="<%=f_weaver_belongto_userid %>">
</FORM>

</body>
</html>
<script language=javascript>
function btn_cancle(){
		window.parent.closeDialog();
	}
</script>
