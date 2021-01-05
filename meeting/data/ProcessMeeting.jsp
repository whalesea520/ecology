<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.meeting.Maint.MeetingTransMethod"%>
<%@page import="weaver.meeting.MeetingShareUtil"%> 
<%@page import="weaver.meeting.qrcode.MeetingSignUtil"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.IsGovProj" %>
<%@page import="weaver.meeting.util.html.HtmlUtil"%>
<%@page import="weaver.meeting.defined.MeetingFieldManager"%> 
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="java.sql.Timestamp" %>
<%@page import="weaver.hrm.companyvirtual.ResourceVirtualComInfo" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="meetingSetInfo" class="weaver.meeting.Maint.MeetingSetInfo" scope="page"/>
<jsp:useBean id="ProjectTaskApprovalDetail" class="weaver.proj.Maint.ProjectTaskApprovalDetail" scope="page" />
<jsp:useBean id="MeetingFieldComInfo" class="weaver.meeting.defined.MeetingFieldComInfo" scope="page"/>
<jsp:useBean id="MeetingFieldGroupComInfo" class="weaver.meeting.defined.MeetingFieldGroupComInfo" scope="page"/>
<jsp:useBean id="MeetingTransMethod" class="weaver.meeting.Maint.MeetingTransMethod" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ include file="/cowork/uploader.jsp" %>
 
<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
String userid = ""+user.getUID();
String logintype = ""+user.getLogintype();

char flag=Util.getSeparator() ;
String ProcPara = "";
String showDiv = Util.null2String(request.getParameter("showdiv"));
String meetingid = Util.null2String(request.getParameter("meetingid"));
String tab = Util.null2String(request.getParameter("tab"));
String needRefresh = Util.null2String(request.getParameter("needRefresh"));
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
String begindate=RecordSet.getString("begindate");
String begintime=RecordSet.getString("begintime");
String enddate=RecordSet.getString("enddate");

String endtime=RecordSet.getString("endtime");
String desc=RecordSet.getString("desc_n");
String creater=RecordSet.getString("creater");
String createdate=RecordSet.getString("createdate");

String createtime=RecordSet.getString("createtime");
String approver=RecordSet.getString("approver");
String approvedate=RecordSet.getString("approvedate");
String approvetime=RecordSet.getString("approvetime");

String isapproved=RecordSet.getString("isapproved");
String isdecision=RecordSet.getString("isdecision");
String decision=RecordSet.getString("decision");
String decisiondocid=RecordSet.getString("decisiondocid");

String decisionwfids=RecordSet.getString("decisionwfids");
String decisioncrmids=RecordSet.getString("decisioncrmids");
String decisionprjids=RecordSet.getString("decisionprjids");
String decisiontskids=RecordSet.getString("decisiontskids");
String decisionatchids=RecordSet.getString("decisionatchids");

String totalmember=RecordSet.getString("totalmember");
String othermembers=RecordSet.getString("othermembers");
String othersremark=RecordSet.getString("othersremark");
String addressdesc=RecordSet.getString("addressdesc");
String remindTypeNew=RecordSet.getString("remindTypeNew");
String meetingstatus=RecordSet.getString("meetingstatus");
String qrticket=Util.null2String(RecordSet.getString("qrticket"));
if("".equals(qrticket)){
	qrticket=MeetingSignUtil.createTicket(meetingid,user);
}
int requestid = RecordSet.getInt("requestid");
int roomType = Util.getIntValue(RecordSet.getString("roomType"),-1);
if(roomType == -1){
	if(!"".equals(address)) roomType = 1;
	else roomType = 2;
}

int repeatType = Util.getIntValue(RecordSet.getString("repeatType"),0);
String repeatEndDate = RecordSet.getString("repeatEndDate");

String customizeAddress = Util.null2String(RecordSet.getString("customizeAddress"));

boolean hideAddress=true;//是否隐藏会议室
if("".equals(address)&&"".equals(customizeAddress)){
	hideAddress=false;
}	


String sqlStr="Select approveby,approvedate from bill_meeting where ApproveID="+meetingid;
rs.executeSql(sqlStr);
if(rs.next()){
approver = rs.getString("approveby");
approvedate = rs.getString("approvedate");
}
//System.out.println("approver =="+approver) ;
//System.out.println("approvedate =="+approvedate);
/*如果会议状态不为正常*/
if(!meetingstatus.equals("2")){
	//response.sendRedirect("/meeting/data/ViewMeeting.jsp?tab=1&meetingid="+meetingid+"&showdiv="+showDiv) ;
    out.println("<script>wfforward(\"/meeting/data/ViewMeetingTab.jsp?needRefresh="+needRefresh+"&meetingid="+meetingid+"&showdiv="+showDiv+"\");</script>");
	return;
}
String allUser=MeetingShareUtil.getAllUser(user);
//标识会议已看
StringBuffer stringBuffer = new StringBuffer();
stringBuffer.append("UPDATE Meeting_View_Status SET status = '1'");		
stringBuffer.append(" WHERE meetingId = ");
stringBuffer.append(meetingid);
stringBuffer.append(" AND userId in("+allUser+" )");
RecordSet.executeSql(stringBuffer.toString());

String Sql="";
boolean canview=false;
boolean ismanager=false;
boolean canJueyi = false;
boolean iscontacter=false;
boolean ismember=false;
boolean isdecisioner=false;
boolean isqrcode=false;
int userPrm=1;
String f_weaver_belongto_userid=user.getUID()+"";

if(MeetingShareUtil.containUser(allUser,caller)){
	userPrm = meetingSetInfo.getCallerPrm();
	if(userPrm != 3) userPrm = 3;
	if(!userid.equals(caller)){
		f_weaver_belongto_userid=caller;
	}
}else{
	if( MeetingShareUtil.containUser(allUser,contacter)){
		userPrm = meetingSetInfo.getContacterPrm();
	   	if(userPrm==3){
		   if(!userid.equals(contacter)){
			   f_weaver_belongto_userid=contacter;
		   }
   		}
	}
	
	if( MeetingShareUtil.containUser(allUser,creater)&&userPrm<3){
		if(userPrm < meetingSetInfo.getCreaterPrm()){
			userPrm = meetingSetInfo.getCreaterPrm();
		}
		if(userPrm==3){
			if(!userid.equals(creater)){
				f_weaver_belongto_userid=creater;
			}
		}
	}
}


 
if(userPrm == 3 || MeetingShareUtil.containUser(allUser,caller)|| MeetingShareUtil.containUser(allUser,approver)){
	canview=true;
   
}

if(userPrm == 3 || MeetingShareUtil.containUser(allUser,caller)){
 	ismanager=true;
    canJueyi = true;
}
if(MeetingShareUtil.containUser(allUser,contacter)||MeetingShareUtil.containUser(allUser,creater)){
    canview=true;
}
if(userPrm>=2||MeetingShareUtil.containUser(allUser,caller)||MeetingShareUtil.containUser(allUser,contacter)){
	isqrcode=true;
}
//modified by Charoes Huang On July 23,2004
if(meetingstatus.equals("2")){
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
}
 

/***检查通过审批流程查看会议***/
rs.executeSql("select userid from workflow_currentoperator where requestid = "+requestid+" and userid in ("+allUser+")" ) ;
if(rs.next()){
	canview=true;
}

if(!canview && (isapproved.equals("3")||isapproved.equals("4"))){
	if(RecordSet.getDBType().equals("oracle")){
		Sql="select * from Meeting_Decision where meetingid="+meetingid+" and ( hrmid02 in ("+allUser+")  ";
		String[] belongs=allUser.split(",");
		for(int i=0;i<belongs.length;i++){
			if("".equals(belongs[i])) continue;
			Sql+=" or ','|| hrmid01|| ',' like '%,"+belongs[i]+",%' ";
		}
		Sql+=")";
	}else if(RecordSet.getDBType().equals("db2")){
        Sql="select * from Meeting_Decision where meetingid="+meetingid+" and ( hrmid02 in ("+allUser+") ";
        String[] belongs=allUser.split(",");
		for(int i=0;i<belongs.length;i++){
			if("".equals(belongs[i])) continue;
			Sql+=" or concat(concat(',',hrmid01),',') like '%,"+belongs[i]+",%' ";
		}
		Sql+=")";
	}else{
		Sql="select * from Meeting_Decision where meetingid="+meetingid+" and ( hrmid02 in ("+allUser+") ";
		String[] belongs=allUser.split(",");
		for(int i=0;i<belongs.length;i++){
			if("".equals(belongs[i])) continue;
			Sql+=" or ','+hrmid01+',' like '%,"+belongs[i]+",%' ";
		}
		Sql+=")";
	}
	
	RecordSet.executeSql(Sql);
	if(RecordSet.next()) {
		canview=true;
		isdecisioner=true;
	}
}

if(MeetingShareUtil.containUser(allUser,contacter) || (userPrm==2&&(!ismember||!isdecisioner)))
    iscontacter=true;


RecordSet.executeSql("Select * From Meeting_ShareDetail WHERE meetingid="+meetingid+" and userid in ("+allUser+") and sharelevel in (1,2,3,4)");
	if(RecordSet.next()) canview = true;

//代理人在提醒流程和会议室报表中有查看会议的权限 MYQ 2007.12.10 开始
RecordSet.executeSql("Select * From workflow_agentConditionSet Where workflowid=1 and agenttype=1 and agentuid in ("+allUser+") and bagentuid in (select memberid from Meeting_Member2 where meetingid="+meetingid+")");
if(RecordSet.next()) canview = true;

if(!canview){
	/***检查是否为决议执行人****/
	String hrmids = "";
	RecordSet.executeSql("select hrmid01 from meeting_decision where meetingid = " + meetingid) ;
	while(RecordSet.next()){
		hrmids = RecordSet.getString("hrmid01");
		if(hrmids.length() > 0){
			ArrayList arrHrmids01 = Util.TokenizerString(hrmids,",");
			for(Object id:arrHrmids01){//QC260016
				if(MeetingShareUtil.containUser(allUser, (String)id)){
					canview=true;
					ismember = true;
				}
			}
		}
	}
}

if(!canview){
	/***检查是否为决议检查人****/
	String hrmids = "";
	RecordSet.executeSql("select hrmid02 from meeting_decision where meetingid = " + meetingid) ;
	while(RecordSet.next()){
		hrmids = Util.null2String(RecordSet.getString("hrmid02"));
		if(hrmids.length() > 0){
			ArrayList arrHrmids02 = Util.TokenizerString(hrmids,",");
			for(Object id:arrHrmids02){//QC260016
				if(MeetingShareUtil.containUser(allUser, (String)id)){
					canview=true;
					ismember = true;
				}
			}
		}
	}
}

//代理人在提醒流程和会议室报表中有查看会议的权限 MYQ 2007.12.10 结束
if(!canview){
	//response.sendRedirect("/notice/noright.jsp") ;
	out.println("<script>wfforward(\"/notice/noright.jsp\");</script>");
	return;
}
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<script language=javascript src="/js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(2103,user.getLanguage())+":"+Util.forHtml(meetingname);
String needfav ="1";
String needhelp ="";

titlename += "<B>"+SystemEnv.getHtmlLabelName(401,user.getLanguage())+":</B>"+createdate+"<B> "+SystemEnv.getHtmlLabelName(623,user.getLanguage())+":</B>";
if(user.getLogintype().equals("1"))
titlename +=Util.toScreen(ResourceComInfo.getResourcename(creater),user.getLanguage());
titlename +="<B>"+SystemEnv.getHtmlLabelName(142,user.getLanguage())+":</B>"+approvedate+"<B> "+SystemEnv.getHtmlLabelName(623,user.getLanguage())+":</B>" ;
if(user.getLogintype().equals("1"))
titlename +=Util.toScreen(ResourceComInfo.getResourcename(approver),user.getLanguage());

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

//System.out.println("ismember ="+ismember);


//结束的会议不允许取消 modify by MYQ 2008.3.4 start
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16);
boolean isrun = false;//会议是否进行中
boolean isover = false;//会议是否结束
//该会议的meetingstatus=2,并且结束时间不在当前时间之后或者该会议已产生会议决议，该会议即为结束
if((enddate+":"+endtime).compareTo(CurrentDate+":"+CurrentTime)<=0 || isdecision.equals("2")) isover=true;
//当前时间大于会议开始时间 小于会议结束时间 即会议正在进行中
if((begindate+":"+begintime).compareTo(CurrentDate+":"+CurrentTime)<0&&(enddate+":"+endtime).compareTo(CurrentDate+":"+CurrentTime)>0&&!isdecision.equals("2") ) isrun=true;
boolean isnotstart=false;//会议未开始
//当前时间小于会议开始时间 即会议未开始
if((begindate+":"+begintime).compareTo(CurrentDate+":"+CurrentTime)>0&&!isdecision.equals("2") ) isnotstart=true;
//状态为正常且未开始的会议 会议召集人或有会议召集人权限的会议创建人或联系人可变更会议
if(("2".equals(meetingstatus) && isnotstart) && ismanager && repeatType == 0&&meetingSetInfo.getCanChange()==1)
{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(127682, user.getLanguage())+",javascript:changeMeeting(this),_self}";
	RCMenuHeight += RCMenuHeightStep;
}
//状态为正常且已开始未结束的会议 会议召集人或有会议召集人权限的会议创建人或联系人可提前结束会议
if(("2".equals(meetingstatus) && isrun) && ismanager && repeatType == 0)
{
	RCMenu += "{" + SystemEnv.getHtmlLabelName(126003, user.getLanguage()) + ",javascript:overMeeting(this),_self}";
	RCMenuHeight += RCMenuHeightStep;
}

if((canJueyi) && (!isdecision.equals("2")) && repeatType == 0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(2194,user.getLanguage())+",javascript:onShowDecision("+meetingid+"),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	}
if(MeetingShareUtil.containUser(allUser,creater)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(77,user.getLanguage())+",javascript:copyNewMeeting("+meetingid+"),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
//当状态为待审批、正常，召集人可取消会议
if(("1".equals(meetingstatus) || ("2".equals(meetingstatus) && !isover)) && (userPrm == 3 ||MeetingShareUtil.containUser(allUser,caller)) && repeatType == 0)
{
	RCMenu += "{" + SystemEnv.getHtmlLabelName(20115, user.getLanguage()) + ",javascript:cancelMeeting(this),_self}";
	RCMenuHeight += RCMenuHeightStep;
}
if(ismanager&& repeatType == 0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(28343,user.getLanguage())+",javascript:exportExcel("+meetingid+"),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
//结束的会议不允许取消 modify by MYQ 2008.3.4 end
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:btn_cancle(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:doViewLog(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan"
			style="text-align: right; width: 400px !important">
			<%//状态为正常且未结束的会议 会议召集人或有会议召集人权限的会议创建人或联系人可提前结束会议
			if(("2".equals(meetingstatus) &&isrun) && ismanager && repeatType == 0)
			{%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(126003,user.getLanguage()) %>" class="e8_btn_top middle" onclick="overMeeting(this)"/>
			<%
			}
			
			if((canJueyi) && (!isdecision.equals("2")) && repeatType == 0){
			%>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2194,user.getLanguage()) %>" class="e8_btn_top middle" onclick="onShowDecision('<%=meetingid%>')"/>
			<%
			}
			
			if(MeetingShareUtil.containUser(allUser,creater)){
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(77,user.getLanguage()) %>" class="e8_btn_top middle" onclick="copyNewMeeting('<%=meetingid%>')"/>
			<%
			}

			//当状态为待审批、正常，召集人可取消会议
			if(("1".equals(meetingstatus) || ("2".equals(meetingstatus) && !isover)) && (userPrm == 3 ||MeetingShareUtil.containUser(allUser,caller)) && repeatType == 0)
			{
			%>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(20115,user.getLanguage()) %>" class="e8_btn_top middle" onclick="cancelMeeting(this)"/>
			<%
			}
			
			//System.out.println("ismember ="+ismember);
			if(ismanager&& repeatType == 0){%>
			<input name="exportMeetingMember"  style="display: none" type="button" value="<%=SystemEnv.getHtmlLabelName(28343,user.getLanguage()) %>" class="e8_btn_top middle" onclick="exportExcel('<%=meetingid%>')"/>
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
	//参会人员情况,需要回执处理,不显示
	fieldList= hfm.getUseField(groupid);
	//3. 参会者分组字段
	if("3".equals(groupid)&&repeatType==0){
		fieldList=hfm.getProcessUseField();
	}
	//对参会人员处理
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
		String fielddbtype = MeetingFieldComInfo.getFielddbtype(fieldid);
		int fieldlabel = Util.getIntValue(MeetingFieldComInfo.getLabel(fieldid));
		int fieldhtmltype = Integer.parseInt(MeetingFieldComInfo.getFieldhtmltype(fieldid));
		int type = Integer.parseInt(MeetingFieldComInfo.getFieldType(fieldid));
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
			extendHtml=new MeetingTransMethod().getMeetingStatus(meetingstatus,user.getLanguage()+"+"+enddate+"+"+endtime+"+"+isdecision+"+"+repeatEndDate+"+"+repeatType);
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
			if(type==16||type==152){
				fieldValue=hfm.getWFHtmlBrowserFieldvalue(user,Integer.parseInt(fieldid),fieldhtmltype,type,fieldValue,fielddbtype,meetingid);
			}else{
				fieldValue=hfm.getHtmlBrowserFieldvalue(user,Integer.parseInt(fieldid),fieldhtmltype,type,fieldValue,fielddbtype,meetingid);
			}
			
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
            				String fielddbtype = MeetingFieldComInfo.getFielddbtype(fieldid);
            				int fieldhtmltype = Integer.parseInt(MeetingFieldComInfo.getFieldhtmltype(fieldid));
            				int type = Integer.parseInt(MeetingFieldComInfo.getFieldType(fieldid));
            				JSONObject cfg= hfm3.getFieldConf(fieldid);
            				String fieldValue = RecordSet3.getString(fieldname);
            				//转成html显示
            				if(fieldhtmltype==4){//check框,变成disabled
            					cfg.put("disabled","disabled");
            					fieldValue=HtmlUtil.getHtmlElementString(fieldValue,cfg,user);
            				}else if(fieldhtmltype==3){
            					if(type==16){
	            					fieldValue=hfm3.getWFHtmlBrowserFieldvalue(user,Integer.parseInt(fieldid),fieldhtmltype,type,fieldValue,fielddbtype,meetingid);
            					}else{
            						fieldValue=hfm3.getHtmlBrowserFieldvalue(user,Integer.parseInt(fieldid),fieldhtmltype,type,fieldValue,fielddbtype,meetingid);
            					}
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
 <% if( repeatType == 0){ %>
<!--相关交流-->
<div id="discussDiv" style="display:none">
<% String types = "MP";
   String sortid =  meetingid;
 %>
<%@ include file="/meeting/data/MeetingDiscuss.jsp" %>
</div>
<%} %>
<!--议程 -->
<div id="agendaDiv" style="display:none">
	<%@ include file="/meeting/data/MeetingTopicList.jsp" %>
</div>
<% if( repeatType == 0){ %>
<!--参会情况 -->
<div id="memberDiv" style="display:none">
	<%@ include file="/meeting/data/MeetingMemberList.jsp" %>
</div>
<!-- 会议签到 -->
<div id="signDiv" style="display:none">
	<%@ include file="/meeting/data/MeetingSignList.jsp" %>
</div>
<!--会议决议 -->
<div id="dicisionDiv" style="display:none">
	<%if((isdecision.equals("1") || isdecision.equals("2")) && (ismanager || ismember || isdecisioner )){%>
		  <TABLE class="ViewForm">
			<TBODY>
			<TR>
			  <TD colspan=2> 
		  <TABLE class="ListStyle" cellspacing=1 cellpadding=1  cols=4 id="oTable">
			<COLGROUP>
			<COL width="6%">
			<COL>
			<COL>
			<COL>
			<COL width="12%">
			<COL width="12%">
			<COL width="10%">
			<TBODY>
			
			<TR class="DataDark">
			  <TD class="Field" nowrap><%=SystemEnv.getHtmlLabelName(2170,user.getLanguage())%>：</TD>
			  <TD class="Field" colspan=6><%=Util.toScreen(decision,user.getLanguage())%></TD></TR>
			<%if(meetingSetInfo.getTpcDoc() == 1) {%>
			<TR class="DataDark">
			  <TD class="Field"><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>：</TD>
			  <TD class="Field" colspan=6>
			  	<a style="cursor: pointer" onclick="opendoc1('<%=decisiondocid%>')"><%=Util.toScreen(DocComInfo.getDocname(decisiondocid),user.getLanguage())%>&nbsp;
			  </TR>
			  <%} %>
			  <%if(meetingSetInfo.getTpcWf() == 1) {%>
			<!-- 相关流程 -->
				  <tr class="DataDark">
			                    <td class="Field"><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%>：</td>
			                    <td class="Field" colspan=6>
			           <%
			       			 if(!decisionwfids.equals("")){
			       			 ArrayList wfids_muti = Util.TokenizerString(decisionwfids,",");
			            %>
			            
			                       <%for(int i=0;i<wfids_muti.size();i++){%>
										<a href="javascript:void(0)" onclick="openFullWindowForXtable('/workflow/request/ViewRequest.jsp?fromModul=meeting&modulResourceId=<%=meetingid %>&requestid=<%=wfids_muti.get(i).toString()%>');return false" class="relatedLink">
											<%=RequestComInfo.getRequestname(wfids_muti.get(i).toString())%>
										</a>
								   <%}%>	
			                    
			           <%}%>
			       		</td>
			       </tr class="DataDark">
			      <%}%>
			      <%if(meetingSetInfo.getTpcCrm() == 1) {%>
			           <!-- 相关客户 -->
			            <tr class="DataDark" <%if(isgoveproj!=0){ %>style="display: none;"<%}%>>
			                    <td class="Field"><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%>：</td>
			                    <td class="Field" colspan=6>
			            <%
			       			 if(isgoveproj==0&&!decisioncrmids.equals("")){
			       			 	String name="";
			       			 	ArrayList arrs = Util.TokenizerString(decisioncrmids,",");
			            %>
			             
			                       <%for(int i=0;i<arrs.size();i++){%>
										<a href="javascript:void(0)" onclick="openFullWindowForXtable('/CRM/data/ViewCustomer.jsp?CustomerID=<%=arrs.get(i).toString()%>');return false" class="relatedLink">
											<%=CustomerInfoComInfo.getCustomerInfoname(arrs.get(i).toString())%>
										</a>
								   <%}%>	
			                    
			           <%} %>
			           		</td>
			           </tr>
	            	<%} %>
	            	<%if(meetingSetInfo.getTpcPrj() == 1) {%>
	            		<tr class="DataDark">
			                    <td class="Field"><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%>：</td>
			                    <td class="Field" colspan=6>
			           <!-- 相关项目 -->
			           <%
			       			 if(isgoveproj==0&&!decisionprjids.equals("")){
			       			 	String name="";
			       			 	ArrayList arrs = Util.TokenizerString(decisionprjids,",");
			            %>
			              
			                       <%for(int i=0;i<arrs.size();i++){%>
										<a href="javascript:void(0)" onclick="openFullWindowForXtable('/proj/data/ViewProject.jsp?ProjID=<%=arrs.get(i).toString()%>');return false" class="relatedLink">
											<%=ProjectInfoComInfo.getProjectInfoname(arrs.get(i).toString())%>
										</a>
								   <%}%>
			           <%}%>	
			           		 </td>
			           </tr>
	           		<%}%>
	           		<%if(meetingSetInfo.getTpcTsk() == 1) {%>
	           			 <tr class="DataDark">
			                    <td class="Field"><%=SystemEnv.getHtmlLabelName(522,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1332,user.getLanguage())%>：</td>
			                    <td class="Field" colspan=6>
			           <!-- 相关任务 -->
			            <%
			       			 if(isgoveproj==0&&!decisiontskids.equals("")){
			       			 	String name="";
			       			 	ArrayList arrs = Util.TokenizerString(decisiontskids,",");
			            %>
			             
			                       <%for(int i=0;i<arrs.size();i++){%>
										<a href="javascript:void(0)" onclick="openFullWindowForXtable('/proj/process/ViewTask.jsp?taskrecordid=<%=arrs.get(i).toString()%>');return false" class="relatedLink">
											<%=Util.toScreen(ProjectTaskApprovalDetail.getTaskSuject(arrs.get(i).toString()),user.getLanguage())%>
										</a>
								   <%}%>
			           <%}%>	
			                    </td>
			               </tr>
	           		  <%}%>
	           		  <%if(meetingSetInfo.getTpcAttch() == 1) {%>
			           <!-- 相关附件 -->  
			           <tr class="DataDark">
			                	<td class="Field"><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%>：</td>
			                    <td class="Field" colspan=6>
			            <%
			       			 if(isgoveproj==0&&!decisionatchids.equals("")){
			       		%>
			             
											<%
											ArrayList darrayaccessorys = Util.TokenizerString(decisionatchids,",");
											for(int i=0;i<darrayaccessorys.size();i++)
											{
												String accessoryid = (String)darrayaccessorys.get(i);
												//System.out.println("accessoryid : "+accessoryid);
												if(accessoryid.equals(""))
												{
													continue;
												}
												rs.executeSql("select id,docsubject,accessorycount from docdetail where id="+accessoryid);
												int linknum=-1;
												if(rs.next())
												{
										  %>
										  <%
													linknum++;
													String showid = Util.null2String(rs.getString(1)) ;
													String tempshowname= Util.toScreen(rs.getString(2),user.getLanguage()) ;
													int accessoryCount=rs.getInt(3);
									
													DocImageManager.resetParameter();
													DocImageManager.setDocid(Integer.parseInt(showid));
													DocImageManager.selectDocImageInfo();
									
													String docImagefileid = "";
													long docImagefileSize = 0;
													String docImagefilename = "";
													String fileExtendName = "";
													int versionId = 0;
									
													if(DocImageManager.next())
													{
														//DocImageManager会得到doc第一个附件的最新版本
														docImagefileid = DocImageManager.getImagefileid();
														docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
														docImagefilename = DocImageManager.getImagefilename();
														fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".")+1).toLowerCase();
														versionId = DocImageManager.getVersionId();
													}
													if(accessoryCount>1)
													{
														fileExtendName ="htm";
													}
													//String imgSrc=AttachFileUtil.getImgStrbyExtendName(fileExtendName,20);
											%>
													
													<%if(accessoryCount==1 && (fileExtendName.equalsIgnoreCase("ppt")||fileExtendName.equalsIgnoreCase("pptx")||fileExtendName.equalsIgnoreCase("xls")||fileExtendName.equalsIgnoreCase("doc")||fileExtendName.equalsIgnoreCase("xlsx")||fileExtendName.equalsIgnoreCase("docx")))
													{
													%>
													<a style="cursor: pointer" onclick="opendoc('<%=showid%>','<%=versionId%>','<%=docImagefileid%>')"><%=docImagefilename%></a>&nbsp;
										  <%
													}
													else
													{
										  %>
													<a style="cursor: pointer" onclick="opendoc1('<%=showid%>')"><%=tempshowname%></a>&nbsp;
										  <%
													}
													if(accessoryCount==1)
													{
										  %>
										  		   &nbsp;<a href='javascript:void(0)'  onclick="downloads('<%=docImagefileid%>');return false;" class='relatedLink'><%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>(<%=(docImagefileSize/1000)%>K)</a></br>
											
										<%
													}
												}
											}
										%>
			           		<%}%>
			                    </td>
			               </tr>
			               <%}%>
			<TR class="header">
			  <TH  align=left><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></TH>
			  <TH  align=left><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TH>
			  <TH  align=left><%=SystemEnv.getHtmlLabelName(2172,user.getLanguage())%></TH>
			  <TH  align=left><%=SystemEnv.getHtmlLabelName(2173,user.getLanguage())%></TH>
			  <TH  align=left><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></TH>
			  <TH  align=left><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></TH>
			  <TH  align=left><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TH>
			</TR>
	<%
	RecordSet.executeProc("Meeting_Decision_SelectAll",meetingid);
	while(RecordSet.next()){
	if(ismanager || ismember || (","+RecordSet.getString("hrmid01")+",").indexOf(","+userid+",")!=-1 || RecordSet.getString("hrmid02").equals(userid)){
		String beginDate = RecordSet.getString("beginDate");
		String beginTime = RecordSet.getString("beginTime");
		String endDate = RecordSet.getString("endDate");
		String endTime = RecordSet.getString("endTime");
		int language = user.getLanguage();
		String DecisioinStatus= "";
		String status =  "";
		String currentTime = TimeUtil.getCurrentDateString() + " " + TimeUtil.getOnlyCurrentTimeString().substring(0,5);
		String statusSql = "select distinct w.status,m.isdecision from WorkPlan w,meeting m where w.meetingid = m.id and w.meetingid = '" + meetingid + "' and w.name = '"+RecordSet.getString("subject") + "' and w.resourceid = '" + RecordSet.getString("hrmid01")+"'";
		String par = beginDate + " " + beginTime + "+" + endDate + " " + endTime + "+" + language + "+"+currentTime;
		RecordSet2.execute(statusSql);
		if(RecordSet2.next()){
			if("2".equals(RecordSet2.getString("isdecision"))){
				DecisioinStatus = RecordSet2.getString("status");
				status =  MeetingTransMethod.getMeetingDecisionStatus(DecisioinStatus,par);
			}
		}

	%>
			<tr class="DataDark">
				<td class="Field"><%=RecordSet.getString("coding")%></td>
				<td class="Field"><%=RecordSet.getString("subject")%></td>
				<td class="Field">
				<%
				ArrayList hrms = Util.TokenizerString(RecordSet.getString("hrmid01"),",");
				for(int i=0;i<hrms.size();i++){
				
				%>
				<a href=javaScript:openhrm(<%=hrms.get(i)%>); onclick='pointerXY(event);'><%=ResourceComInfo.getResourcename(String.valueOf(hrms.get(i)))%></a>&nbsp;
				<%}%>
				
				
				</td>
				<td class="Field">
				<a href=javaScript:openhrm(<%=RecordSet.getString("hrmid02")%>); onclick='pointerXY(event);'><%=ResourceComInfo.getResourcename(RecordSet.getString("hrmid02"))%></a>
				</td>
				<td class="Field"><%=RecordSet.getString("begindate")%> <%=RecordSet.getString("begintime")%></td>
				<td class="Field"><%=RecordSet.getString("enddate")%> <%=RecordSet.getString("endtime")%></td>
				<td class="Field">
					<a href="/workflow/request/ViewRequest.jsp?fromModul=meeting&modulResourceId=<%=meetingid %>&requestid=<%=RecordSet.getString("requestid")%>" target=\'_blank\'><%=status %></a>
				</td>
			</tr>
	<%
	}
	}
	%>
			</TBODY>
		  </TABLE>		  
			  
			  </TD>
			</TR>
			</TBODY>
		  </TABLE>
	<%}%>
</div>
<%} %>
</td>
</tr>
</TABLE>
</td>
</tr>
<tr style="height:0px">
<td height="0"></td>
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
<script language="javascript">
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
	diag_vote.maxiumnable = true;
	diag_vote.URL = url;
	diag_vote.show();
}



function onShowDecision(meetingid){
	//showDialog("/meeting/data/MeetingDecision.jsp?meetingid="+meetingid,"<%=SystemEnv.getHtmlLabelName(2194,user.getLanguage())%>", 750, 550);
	showDialog("/meeting/data/MeetingOthTab.jsp?toflag=Decision&f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&meetingid="+meetingid,"<%=SystemEnv.getHtmlLabelName(2194,user.getLanguage())%>", 950, 550);
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
function submitData() {
window.history.back();
}
 function doSave1(){
	if(check_form(document.Exchange,"ExchangeInfo")){
		document.Exchange.submit();
	}
}
function displaydiv_1()
	{
		if(WorkFlowDiv.style.display == ""){
			WorkFlowDiv.style.display = "none";
			WorkFlowspan.innerHTML = "<a href='#' onClick=displaydiv_1()><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a>";
		}
		else{
			WorkFlowspan.innerHTML = "<a href='#' onClick=displaydiv_1()><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></a>";
			WorkFlowDiv.style.display = "";
		}
	}

function cancelMeeting(obj)
{
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(20117,user.getLanguage())%>", function (){
		obj.disabled = true;
        document.cancelMeetingForm.submit();
	});
}

function btn_cancle(){
	window.parent.closeDialog();
}

function copyNewMeeting(id){
	$.post("/meeting/data/AjaxMeetingOperation.jsp",{method:"copyMeeting",meetingid:id,f_weaver_belongto_userid:"<%=creater%>"},function(datas){
		if(datas != "-1"){
			try{
				window.parent.dataRfsh();
				window.parent.doCopyEdit(datas);
			}catch(e){
				parent.location.href="/meeting/data/EditMeetingTab.jsp?meetingid="+datas;
			}
			//wfforward("/meeting/data/EditMeetingTab.jsp?meetingid="+datas);
		} else {
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(83357,user.getLanguage())%>");
		}
	});
}

function changeMeeting(obj){
   try{
   		window.parent.doChange(<%=meetingid%>);
   }catch(e){
   	   parent.location.href="/meeting/data/ChangeMeetingTab.jsp?meetingid=<%=meetingid%>";
   }
} 

function overMeeting(obj){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(126004,user.getLanguage())%>", function (){
		obj.disabled = true;
		document.cancelMeetingForm.method.value = "overMeeting";
        document.cancelMeetingForm.submit();
	});
}

function doViewLog(){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 800;
	diag_vote.Height = 500;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(17480,user.getLanguage())%>";
	diag_vote.URL = "/systeminfo/SysMaintenanceLog.jsp?cmd=NOTCHANGE&sqlwhere=<%=xssUtil.put("where operateitem=303 and relatedid=")%>&relatedid=<%=meetingid%>";
	diag_vote.show();

    }

function exportExcel(id){
	document.location.href="/meeting/data/MeetingMemberToExcel.jsp?meetingid=<%=meetingid%>";
}

function exportSignExcel(id){
	document.location.href="/meeting/data/MeetingSignMemberToExcel.jsp?meetingid=<%=meetingid%>";
}

jQuery(document).ready(function(){
	window.parent.showMember();
	window.parent.showSign();
	<%if((isdecision.equals("1") || isdecision.equals("2")) && (ismanager || ismember || isdecisioner )){%>
	window.parent.showDicision();
	<%} else {%>
	window.parent.hideDicision();
	<%}%>

	<%if(!"".equals(showDiv)){%>
		jQuery("#nomalDiv").css("display","none");
		jQuery("#agendaDiv").css("display","none");
		jQuery("#discussDiv").css("display","none");
		jQuery("#memberDiv").css("display","none");
		jQuery("#dicisionDiv").css("display","none");
		jQuery("#<%=showDiv%>").css("display","");
	<%}%>
	<%if("dicisionDiv".equals(showDiv)){%>
		window.parent.selectDicision();
	<%}%>
	<% if( repeatType != 0){ %>
	    window.parent.hideDicision();
		window.parent.hideMember();
		window.parent.hideSign();
		window.parent.hideDiscuss();
	<%} else {%>
		window.parent.showDiscuss();
    <%}%>
    resizeDialog(document);
    
    //是否隐藏提醒
    if("<%=remindTypeNew%>"==''){
		hideEle("remindtimetr", true);
	}else{
		showEle("remindtimetr", true);
	}
});

</script>

<FORM id=cancelMeetingForm name=cancelMeetingForm action="/meeting/data/MeetingOperation.jsp" method=post enctype="multipart/form-data">
	<INPUT type="hidden" name="method" value="cancelMeeting"/>
	<INPUT type="hidden" name="meetingId" value="<%=meetingid%>"/>
	<INPUT type="hidden" name="f_weaver_belongto_userid" value="<%=f_weaver_belongto_userid %>">
</FORM>

</body>
</html>