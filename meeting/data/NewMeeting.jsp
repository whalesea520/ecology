
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.meeting.util.html.HtmlUtil"%>
<%@page import="weaver.meeting.MeetingShareUtil"%> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.file.FileUpload" %>
<%@page import="java.net.URLEncoder" %>
<%@page import="weaver.meeting.defined.MeetingFieldManager"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="meetingUtil" class="weaver.meeting.MeetingUtil" scope="page"/>
<jsp:useBean id="meetingSetInfo" class="weaver.meeting.Maint.MeetingSetInfo" scope="page"/>
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" /> 
<jsp:useBean id="MeetingFieldComInfo" class="weaver.meeting.defined.MeetingFieldComInfo" scope="page"/>
<jsp:useBean id="MeetingFieldGroupComInfo" class="weaver.meeting.defined.MeetingFieldGroupComInfo" scope="page"/>
<%
//获得当前的日期和时间
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
FileUpload fu = new FileUpload(request);
char flag=Util.getSeparator() ;
//是否新建周期会议
int isInterval = Util.getIntValue(fu.getParameter("isInterval"), 0);
String meetingtype = Util.null2String(fu.getParameter("meetingtype"));
String address = Util.null2String(fu.getParameter("roomid"));
if("".equals(address)){
	address = Util.null2String(fu.getParameter("address"));
}
String begindate = Util.null2String(fu.getParameter("begindate"));
if("".equals(begindate)){
	begindate = Util.null2String(fu.getParameter("startdate"));
}
String enddate = Util.null2String(fu.getParameter("enddate"));
String begintime = Util.null2String(fu.getParameter("begintime"));
if("".equals(begintime)){
	begintime = Util.null2String(fu.getParameter("starttime"));
}
String endtime = Util.null2String(fu.getParameter("endtime"));

String repeatbegindate = Util.null2String(fu.getParameter("repeatbegindate"));
String repeatenddate = Util.null2String(fu.getParameter("repeatenddate"));
String remindTypeNew=Util.null2String(fu.getParameter("remindTypeNew"));//新的提示方式
String remindHoursBeforeStart = Util.getIntValue(fu.getParameter("remindHoursBeforeStart"),0) +"";//开始前小时
String remindTimesBeforeStart = Util.getIntValue(fu.getParameter("remindTimesBeforeStart"),10)+"";//开始前分钟
String remindHoursBeforeEnd = Util.getIntValue(fu.getParameter("remindHoursBeforeEnd"),0)+"";//结束前小时
String remindTimesBeforeEnd = Util.getIntValue(fu.getParameter("remindTimesBeforeEnd"),10)+"";//结束前分钟

boolean isUseMtiManageDetach=ManageDetachComInfo.isUseMtiManageDetach();
if(isUseMtiManageDetach){
   session.setAttribute("detachable","1");
   session.setAttribute("meetingdetachable","1");
}else{
   session.setAttribute("detachable","0");
   session.setAttribute("meetingdetachable","0");
}
String f_weaver_belongto_userid=""+user.getUID();//操作用户
//上传目录和大小限制
String mainId = "";
String subId = "";
String secId = "";
String maxsize = "";
if(!meetingtype.equals(""))
{
	RecordSet.executeProc("Meeting_Type_SelectByID",meetingtype);
	if(RecordSet.next())
	{
		String category = Util.null2String(RecordSet.getString("catalogpath"));
	    if(!category.equals(""))
	    {
	    	String[] categoryArr = Util.TokenizerString2(category,",");
	    	mainId = categoryArr[0];
	    	subId = categoryArr[1];
	    	secId = categoryArr[2];
	    }else {
			if(!meetingSetInfo.getMtngAttchCtgry().equals("")){//如果设置了目录，则取值
				String[] categoryArr = Util.TokenizerString2(meetingSetInfo.getMtngAttchCtgry(),",");
				mainId = categoryArr[0];
				subId = categoryArr[1];
				secId = categoryArr[2];
			}
		}
    }
	if(!secId.equals(""))
	{
		RecordSet.executeSql("select maxUploadFileSize from DocSecCategory where id="+secId);
		RecordSet.next();
	    maxsize = Util.null2String(RecordSet.getString(1));
	} 
}

//召集人条件
String whereclause="";
String qswhere = "";
String caller=Util.null2String(fu.getParameter("caller"));
//生成召集人的where子句
int ishead=0 ;
int isset=0;//是否有设置召集人标识，0没有，1有
String hrmids=Util.null2String(fu.getParameter("hrmmembers"));//参会人员
String crmids=Util.null2String(fu.getParameter("crmmembers"));;//参会客户
int hrmCnt=0;//参会人员数
int crmCnt=0;//参会客户数
if(!hrmids.isEmpty()){
	hrmCnt=hrmids.split(",").length;//参会人员数
}
if(!crmids.isEmpty()){
	crmCnt=crmids.split(",").length;//参会客户数
}
if(!meetingtype.equals("")) {
	//召集人
	RecordSet.executeProc("MeetingCaller_SByMeeting",meetingtype) ;
	whereclause="where ( " ;
	qswhere = "";
	while(RecordSet.next()){
		String callertype=RecordSet.getString("callertype") ;
		int seclevel=Util.getIntValue(RecordSet.getString("seclevel"), 0) ;
		String rolelevel=RecordSet.getString("rolelevel") ;
		String thisuserid=RecordSet.getString("userid") ;
		String departmentid=RecordSet.getString("departmentid") ;
		String roleid=RecordSet.getString("roleid") ;
		String foralluser=RecordSet.getString("foralluser") ;
		String subcompanyid=RecordSet.getString("subcompanyid") ;
		int seclevelMax=Util.getIntValue(RecordSet.getString("seclevelMax"), 0) ;
		int jobtitleid=Util.getIntValue(RecordSet.getString("jobtitleid"),0) ;
		int joblevel=Util.getIntValue(RecordSet.getString("jobtitleid"),0) ;
		String joblevelvalue=RecordSet.getString("joblevelvalue");
		isset=1;
	
		if(callertype.equals("1")){
			if(ishead==0){
				whereclause+=" t1.id="+thisuserid ;
				}
			if(ishead==1){
				whereclause+=" or t1.id="+thisuserid ;
				}
		}
		if(callertype.equals("2")){
			if(ishead==0){
				whereclause+=" t1.id in (select id from hrmresource where departmentid="+departmentid+" and seclevel >="+seclevel+" and seclevel <= "+seclevelMax+" )" ;
			}
			if(ishead==1){
				whereclause+=" or t1.id in (select id from hrmresource where departmentid="+departmentid+" and seclevel >="+seclevel+" and seclevel <= "+seclevelMax+" )" ;
			 }
		}
		if(callertype.equals("3")){
			if(ishead==0){
				whereclause+=" t1.id in (select resourceid from hrmrolemembers join hrmresource on  hrmrolemembers.resourceid=hrmresource.id where roleid="+roleid+" and rolelevel >="+rolelevel+" and seclevel >="+seclevel+" and seclevel <= "+seclevelMax+")" ;
			}
			if(ishead==1){
				whereclause+=" or t1.id in (select resourceid from hrmrolemembers join hrmresource on  hrmrolemembers.resourceid=hrmresource.id where roleid="+roleid+" and rolelevel >="+rolelevel+" and seclevel >="+seclevel+" and seclevel <= "+seclevelMax+")" ;
			}
		}
		if(callertype.equals("4")){
			if(ishead==0){
				whereclause+=" t1.id in (select id from hrmresource where seclevel >="+seclevel+" and seclevel <= "+seclevelMax+" )" ;
			}
			if(ishead==1){
				whereclause+=" or t1.id in (select id from hrmresource where seclevel >="+seclevel+" and seclevel <= "+seclevelMax+" )" ;
			}
		}
		if(callertype.equals("5")){
			if(ishead==0){
				whereclause+=" t1.id in (select id from hrmresource where subcompanyid1="+subcompanyid+" and seclevel >="+seclevel+" and seclevel <= "+seclevelMax+" )" ;
			}
			if(ishead==1){
				whereclause+=" or t1.id in (select id from hrmresource where subcompanyid1="+subcompanyid+" and seclevel >="+seclevel+" and seclevel <= "+seclevelMax+" )" ;
			}
		}
		if(callertype.equals("8")){
			if(ishead==0){
				whereclause+=" t1.id in (select id from hrmresource where jobtitle="+jobtitleid;
				if(joblevel==1){
					whereclause+=" and subcompanyid1 in ("+joblevelvalue+")";
				}else if(joblevel==1){
					whereclause+=" and departmentid in ("+joblevelvalue+")";
				}	
				whereclause+=")";
			}
			if(ishead==1){
				whereclause+=" or t1.id in (select id from hrmresource where jobtitle="+jobtitleid;
				if(joblevel==1){
					whereclause+=" and subcompanyid1 in ("+joblevelvalue+")";
				}else if(joblevel==1){
					whereclause+=" and departmentid in ("+joblevelvalue+")";
				}	
				whereclause+=")";		
			}
		}
		if(ishead==0)   ishead=1;
	}

	//参会人员
	String[] membersArry  = meetingUtil.getMeetingHrmMembers(meetingtype);
	if(membersArry != null && membersArry.length > 0){
		for(String memberid:membersArry){
			String status=ResourceComInfo.getStatus(memberid);
			if(!status.equals("0")&&!status.equals("1")&&!status.equals("2")&&!status.equals("3"))
				continue;
			if((","+hrmids+",").indexOf(","+memberid+",")<0){//默认参会人不在以选择的参会人列表中，追加
				hrmids +="".equals(hrmids)?memberid:","+memberid;
				hrmCnt++;
			}
			
		}
	}
	//参会客户 	  
	RecordSet.executeProc("Meeting_Member_SelectByType",meetingtype+flag+"2");
	while(RecordSet.next()){
		if((","+crmids+",").indexOf(","+RecordSet.getString("memberid")+",")<0){//默认参会客户不在以选择的参会客户列表中，追加
			crmids +="".equals(crmids)?RecordSet.getString("memberid"):","+RecordSet.getString("memberid");
			crmCnt++;
		}
	}
	//召集人查询条件
	if(!whereclause.equals("where ( ") && whereclause.length() > 5){  
		whereclause+=" )" ;
		qswhere=whereclause.substring(5) ;
		RecordSet.execute("select t1.id from hrmresource t1,hrmdepartment t2 where t1.departmentid = t2.id and (t1.status = 0 or t1.status = 1 or t1.status = 2 or t1.status = 3) and "+qswhere);
		if(RecordSet.getCounts()==1){//只有一个预设召集人
			if(RecordSet.next()){
				caller=RecordSet.getString("id");//更新召集人为默认召集人
			}
		}else if(RecordSet.getCounts()>0){//存在预设召集人
			boolean needChange=true;
			while(RecordSet.next()){
				if(caller.equals(RecordSet.getString("id"))){//当前召集人是否在预设召集人中
					needChange=false;
					break;
				}
			}
			if(needChange){//当前召集人不在预设召集人中，清空
				caller="";
			}
		}
	}
	
	//会议类型有创建权限的人
	f_weaver_belongto_userid=MeetingShareUtil.getTypeUserPermission(meetingtype,user);
}
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script language=javascript src="/js/weaver_wev8.js"></script>

<link href="/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogressBywf_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlersBywf_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/meeting/meetingswfupload_wev8.js"></script>

</HEAD>
<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(2103,user.getLanguage());
String needfav ="1";
String needhelp ="";
int topicrows=0;
int servicerows=0;

String needcheck="";
String serviceNeedChk=""; 
String topicNeedChk=""; 
%>
<BODY style="overflow: hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(220,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSubmit(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan"
			style="text-align: right; width: 400px !important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(220,user.getLanguage()) %>" class="e8_btn_top middle" onclick="doSave(this)"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(615,user.getLanguage()) %>" class="e8_btn_top middle" onclick="doSubmit(this)"/>
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
<div class="zDialog_div_content" style="overflow:auto;">

<FORM id=weaver name=weaver action="/meeting/data/MeetingOperation.jsp" method=post>
<input class=inputstyle type="hidden" name="method" value="add">
<input class=inputstyle type="hidden" name="topicrows" value="0">
<input class=inputstyle type="hidden" name="servicerows" value="0">
<input class=inputstyle type="hidden" name="isInterval" id="isInterval" value="<%=isInterval %>">
<INPUT type="hidden" id="f_weaver_belongto_userid" name="f_weaver_belongto_userid" value="">
<%if(isInterval != 1) {%>
<input  type="hidden" name="repeatType" id="repeatType" value="0">
<%} %>
<div id="nomalDiv">
<wea:layout type="2col">
<%    
//遍历分组
MeetingFieldManager hfm = new MeetingFieldManager(1);
List<String> groupList=hfm.getLsGroup();
List<String> fieldList=null;
for(String groupid:groupList){
	fieldList= hfm.getUseField(groupid);
	if(fieldList!=null&&fieldList.size()>0){		
%>
<wea:group context='<%=SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldGroupComInfo.getLabel(groupid)), user.getLanguage()) %>' attributes="{'groupDisplay':''}">
	<%for(String fieldid:fieldList){
		if(isInterval == 1) {//周期会议
			if("0".equals(MeetingFieldComInfo.getIsrepeat(fieldid))) continue;
		}else{//非周期会议
			if("1".equals(MeetingFieldComInfo.getIsrepeat(fieldid))) continue;
		}
		
		String fieldname = MeetingFieldComInfo.getFieldname(fieldid);
		int fieldlabel = Util.getIntValue(MeetingFieldComInfo.getLabel(fieldid));
		int fieldhtmltype = Integer.parseInt(MeetingFieldComInfo.getFieldhtmltype(fieldid));
		boolean ismand="1".equals(MeetingFieldComInfo.getIsmand(fieldid));
		//会议室单独处理,是否必填
		if(!"address".equalsIgnoreCase(fieldname)&&!"customizeAddress".equalsIgnoreCase(fieldname)
				&&!"repeatdays".equalsIgnoreCase(fieldname)&&!"repeatweeks".equalsIgnoreCase(fieldname)&&!"rptWeekDays".equalsIgnoreCase(fieldname)
				&&!"repeatmonths".equalsIgnoreCase(fieldname)&&!"repeatmonthdays".equalsIgnoreCase(fieldname)){
			if(ismand){
				if(fieldhtmltype==6){
					needcheck+="".equals(needcheck)?"field"+fieldid:",field"+fieldid;
				}else{
					needcheck+="".equals(needcheck)?fieldname:","+fieldname;
				}
			}
		}
		JSONObject cfg= hfm.getFieldConf(fieldid);
		String fieldVaule="";
		fieldVaule=Util.null2String(fu.getParameter(fieldname));
		String extendHtml="";
		//上传附件,设置上次目录
		if(fieldhtmltype==6){
			cfg.put("mainId",mainId);
			cfg.put("subId",subId);
			cfg.put("secId",secId);
			cfg.put("maxsize",maxsize);
		}
		
		if("meetingtype".equalsIgnoreCase(fieldname)){//会议类型
			fieldVaule=meetingtype;
			if(!"".equals(meetingtype)){
				cfg.put("hasInput","false");  
			}
			cfg.put("getBrowserUrlFn","showMeetingType"); 
			cfg.put("callback","meetingReset");
		}else if("address".equalsIgnoreCase(fieldname)){//会议地点
			fieldVaule=address;
			cfg.put("getBrowserUrlFn","CheckOnShowAddress"); 
			cfg.put("width","60%");
			if (HrmUserVarify.checkUserRight("MeetingRoomAdd:Add", user)) {
				extendHtml+="<div class=\"FieldDiv add_btn\" onclick=\"addAddress()\"  title=\""+SystemEnv.getHtmlLabelNames("611,780",user.getLanguage())+"\"></div>";
			}
			extendHtml+="<div class=\"FieldDiv\" id=\"selectRoomdivb\" name=\"selectRoomdivb\" style=\"margin-left:10px;margin-top: 3px;float:left;\">"+
							"<A href=\"javascript:showRoomsWithDate();\" style=\"color:blue;\">"+SystemEnv.getHtmlLabelName(2193,user.getLanguage())+"</A>"+
						"</div>";
			cfg.put("callback","addressCallBack");
		}else if("customizeAddress".equalsIgnoreCase(fieldname)){//会议地点
			 
		}else if("begindate".equalsIgnoreCase(fieldname)){//开始日期
			fieldVaule=begindate;
		}else if("begintime".equalsIgnoreCase(fieldname)){//开始时间
			fieldVaule=begintime;
		}else if("enddate".equalsIgnoreCase(fieldname)){//结束日期
			fieldVaule=enddate;
		}else if("endtime".equalsIgnoreCase(fieldname)){//结束时间
			fieldVaule=endtime;
		}else if("caller".equalsIgnoreCase(fieldname)){//召集人,添加查询条件
			fieldVaule=caller;
			if(isset==1){
				cfg.put("browserUrl","/systeminfo/BrowserMain.jsp?url=/meeting/data/CallerBrowser.jsp?meetingtype="+meetingtype);
				cfg.put("completeUrl","/data.jsp?type=meetingCaller&meetingtype="+meetingtype);
			}
		}else if("repeatType".equalsIgnoreCase(fieldname)){//重复模式,添加change事件
			cfg.put("func","changeRepeatType()");
		}else if("hrmmembers".equalsIgnoreCase(fieldname)){//参会人员
			fieldVaule=hrmids;
			cfg.put("callback","countAttend");
		}else if("totalmember".equalsIgnoreCase(fieldname)){//参会人员数
			fieldVaule=""+hrmCnt;
		}else if("crmmembers".equalsIgnoreCase(fieldname)){//参会客户
			fieldVaule=crmids;
			cfg.put("callback","countAttendCRM");
		}else if("crmtotalmember".equalsIgnoreCase(fieldname)){//参会客户数
			fieldVaule=""+crmCnt;
		}else if("remindTypeNew".equalsIgnoreCase(fieldname)){//默认提醒方式
			fieldVaule=remindTypeNew;//"2,3,5";
			cfg.put("callback","onRemindType");
		}else if("contacter".equalsIgnoreCase(fieldname)){//联系人
			if(fieldVaule.isEmpty()){
				fieldVaule=""+user.getUID();
			}
		}else if("repeatbegindate".equalsIgnoreCase(fieldname)){
			fieldVaule=repeatbegindate;
		}else if("repeatenddate".equalsIgnoreCase(fieldname)){
			fieldVaule=repeatenddate;
		}
		
		if("remindHoursBeforeStart".equalsIgnoreCase(fieldname)||"remindTimesBeforeStart".equalsIgnoreCase(fieldname)
				||"remindHoursBeforeEnd".equalsIgnoreCase(fieldname)||"remindTimesBeforeEnd".equalsIgnoreCase(fieldname)
				||"repeatweeks".equalsIgnoreCase(fieldname)||"rptWeekDays".equalsIgnoreCase(fieldname)
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
				<%=HtmlUtil.getHtmlElementString(fieldVaule,cfg,user)%>
				&nbsp;&nbsp;<span><%=SystemEnv.getHtmlLabelName(19784,user.getLanguage())%></span>
				<%=HtmlUtil.getHtmlElementString(remindHoursBeforeStart,hfm.getFieldConf("25"),user)%>
				<span><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></span>
				<%=HtmlUtil.getHtmlElementString(remindTimesBeforeStart,hfm.getFieldConf("26"),user)%>
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
				<%=HtmlUtil.getHtmlElementString(fieldVaule,cfg,user)%>
				&nbsp;&nbsp;<span><%=SystemEnv.getHtmlLabelName(19785,user.getLanguage())%></span>
				<%=HtmlUtil.getHtmlElementString(remindHoursBeforeEnd,hfm.getFieldConf("27"),user)%>
				<span><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></span>
				<%=HtmlUtil.getHtmlElementString(remindTimesBeforeEnd,hfm.getFieldConf("28"),user)%>
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
			<%=HtmlUtil.getHtmlElementString(fieldVaule,cfg,user)%>
		</wea:item>	
	<%		 
		}else if("repeatdays".equalsIgnoreCase(fieldname)){//重复会议时间处理
	%>	
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(25898,user.getLanguage())%>
		</wea:item> 
		<wea:item>
			<div id="repeatType1" style="display:none" name="repeatTypeDiv">
				<%=SystemEnv.getHtmlLabelName(21977,user.getLanguage())%>&nbsp;
			    <%=HtmlUtil.getHtmlElementString("1",cfg,user)%>
				 &nbsp;<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>
			</div>
			<div id="repeatType2" style="display:none"  name="repeatTypeDiv">
				<%=SystemEnv.getHtmlLabelName(21977,user.getLanguage())%>&nbsp;
			    <% out.println(HtmlUtil.getHtmlElementString("1",hfm.getFieldConf("10"),user));%>
			    &nbsp;<%=SystemEnv.getHtmlLabelName(1926,user.getLanguage())%><br>
			 	<%out.println(HtmlUtil.getHtmlElementString("",hfm.getFieldConf("11"),user));%>
			</div>
			<div id="repeatType3" style="display:none"  name="repeatTypeDiv">
				<%=SystemEnv.getHtmlLabelName(21977,user.getLanguage())%>&nbsp;
			    <%out.println(HtmlUtil.getHtmlElementString("1",hfm.getFieldConf("12"),user));%>
			    &nbsp;<%=SystemEnv.getHtmlLabelName(25901,user.getLanguage())%>&nbsp;
			 	<%out.println(HtmlUtil.getHtmlElementString("1",hfm.getFieldConf("13"),user));%>
			 	&nbsp;<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>
			</div>
		</wea:item>	
	<%	
	}else{
	%>		
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%>
		</wea:item> 
		<wea:item>
			<%=HtmlUtil.getHtmlElementString(fieldVaule,cfg,user)%>
			<%=extendHtml%>
		</wea:item>	
	<%	}
	}%>
</wea:group>
<%}
}%>		
</wea:layout>
</div>
	
	<div id="agendaDiv" style="display:none;">
	   	<div id="topicRowSource" style="display:none;">
	   		<div name='topicRowSourceDiv' id="topicRowSource_0" fieldName="topicChk" fieldid="0">
	   			<input name="topicChk" type="checkbox" value="1" rowIndex='#rowIndex#'>
	   		</div>
	   		<%
	   		int topicColSize=1;
        	MeetingFieldManager hfm2 = new MeetingFieldManager(2);
        	List<String> groupList=hfm2.getLsGroup();
        	List<String> fieldList=null;
        	Hashtable<String,String> ht=null;
        	for(String groupid:groupList){
        		fieldList= hfm2.getUseField(groupid);
        		int i=0;
        		if(fieldList!=null&&fieldList.size()>0){
        			topicColSize=fieldList.size()+1;
        			for(String fieldid:fieldList){
        				i++;
						String fieldname = MeetingFieldComInfo.getFieldname(fieldid);
	        			String fieldVaule="";
	        			String fieldhtmltype=MeetingFieldComInfo.getFieldhtmltype(fieldid);
	        			 
	        			JSONObject cfg= hfm2.getFieldConf(fieldid);
	        			cfg.put("isdetail", 1);//明细列表显示
	        			ht=HtmlUtil.getHtmlElementHashTable(fieldVaule,cfg,user);
	        			String ismand=MeetingFieldComInfo.getIsmand(fieldid);
	        			if("1".equals(ismand)){
	        				if(topicNeedChk.length()>0){
	        					topicNeedChk+=",";
	        				}
	        				topicNeedChk+=fieldname+"_"+fieldid;
	        			}
	        %>
	       <div name='topicRowSourceDiv' id="topicRowSource_<%=i %>" fieldName="<%=fieldname %>" fieldid="<%=fieldid %>" fieldhtmltype="<%=fieldhtmltype %>">
	       		<%=ht.get("inputStr") %>
	       </div>
	       <%if(!"".equals(ht.get("jsStr"))){ %>
	       <div id="topicRowSource_js_<%=i %>">
	       		<%=ht.get("jsStr") %>
	       </div> 
	        <%}if(!"".equals(ht.get("js2Str"))){ %>
		       <div id="topicRowSource_js_<%=i %>">
	       		<%=ht.get("js2Str") %>
	       </div> 
	        <%}
	        		}
        		}
        	}
        	%>
	   	</div>
	   	<TABLE class="ViewForm">
        <TBODY>
        <tr>
        	<td class="Field" colspan=2>
        	<%
        	for(String groupid:groupList){
        		fieldList= hfm2.getUseField(groupid);
        		
        		if(fieldList!=null&&fieldList.size()>0){
        			int colSize=fieldList.size();
        			
        	%>		<div class="table-head" style="height:70px;">
        			<table class=ListStyle  border=0 cellspacing=1 style="position:fixed;z-index:99!important;padding: 0px !important;width:100%;table-layout:fixed;">
        			  
        			  <colgroup>
        			  	<col width="5%">
        	<%		for(int i=0;i<colSize;i++){
        				out.print("<col width='"+(95/colSize)+"%'>\n");
        			}
        			out.println("</colgroup>\n");
        			%>
					<TR class="Title">
	           			<Td class="Field" align=right colspan="<%=colSize+1%>" style="text-align: right;">
			            	<input class="addbtn" id="topicaddbtn" accesskey="A" onclick="addNewRow('topic');" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" type="button">
							<input class="delbtn" id="topicdelbtn" accesskey="E" onclick="deleteSelectedRow('topic');" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" type="button">
						</Td>
					</TR>
        			<%
        			out.println("<TR class=HeaderForXtalbe>\n");
        			out.println("<th><input name=\"topicChkAll\" tarObj=\"topicChk\" type=\"checkbox\" onclick=\"jsChkAll(this)\"></th>\n");
        		  	
        			for(String fieldid:fieldList){
        				int fieldlabel = Util.getIntValue(MeetingFieldComInfo.getLabel(fieldid));
        				out.println("<th  style=\"overflow: hidden;white-space:nowrap;text-overflow:ellipsis;\" title=\""+SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())+"\">"+SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())+"</th>\n");
	        
	   				}
        			out.print("</tr></table></div>\n"); 
        			%>		
					<div class="table-body">
        			<table id="topicTabField" class=ListStyle  border=0 cellspacing=1>
        			  <colgroup>
        			  	<col width="5%">
        	<%		for(int i=0;i<colSize;i++){
        				out.print("<col width='"+(95/colSize)+"%'>\n");
        			}
        			out.println("</colgroup>\n");
        			out.print("</table></div>\n"); 
        			
        		}
        	}
        	%>         
        	</td>
        </tr>
        </TBODY>
	  </TABLE>
	</div>
	
	<div id="serviceDiv" style="display:none;">
	   	<div id="serviceRowSource" style="display:none;">
	   		<div name='serviceRowSourceDiv' id="serviceRowSource_0" fieldName="serviceChk" fieldid="0">
	   			<input name="serviceChk" type="checkbox" value="1" rowIndex='#rowIndex#'>
	   		</div>
	   		<%
	   		int serviceColSize=1;
        	MeetingFieldManager hfm3 = new MeetingFieldManager(3);
        	groupList=hfm3.getLsGroup();
        	for(String groupid:groupList){
        		fieldList= hfm3.getUseField(groupid);
        		int i=0;
        		if(fieldList!=null&&fieldList.size()>0){
	        		serviceColSize=fieldList.size()+1;
        			for(String fieldid:fieldList){
        				i++;
						String fieldname = MeetingFieldComInfo.getFieldname(fieldid);
	        			String fieldVaule="";
	        			String fieldhtmltype=MeetingFieldComInfo.getFieldhtmltype(fieldid);
	        			 
	        			JSONObject cfg= hfm3.getFieldConf(fieldid);
	        			cfg.put("isdetail", 1);//明细列表显示
	        			ht=HtmlUtil.getHtmlElementHashTable(fieldVaule,cfg,user);
	        			String ismand=MeetingFieldComInfo.getIsmand(fieldid);
	        			if("1".equals(ismand)){
	        				if(serviceNeedChk.length()>0){
	        					serviceNeedChk+=",";
	        				}
	        				serviceNeedChk+=fieldname+"_"+fieldid;
	        			}
	        %>
	       <div name='serviceRowSourceDiv' id="serviceRowSource_<%=i %>" fieldName="<%=fieldname %>" fieldid="<%=fieldid %>" fieldhtmltype="<%=fieldhtmltype %>">
	       		<%=ht.get("inputStr") %>
	       </div>
	       <%if(!"".equals(ht.get("jsStr"))){ %>
	       <div id="serviceRowSource_js_<%=i %>">
	       		<%=ht.get("jsStr") %>
	       </div> 
	        <%}
	       if(!"".equals(ht.get("js2Str"))){ %>
	       <div id="serviceRowSource_js2_<%=i %>">
	       		<%=ht.get("js2Str") %>
	       </div> 
	        <%}
	       
	        		}
        		}
        	}
        	%>
	   	</div>
	   	<TABLE class="ViewForm">
        <TBODY>
        <tr>
        	<td class="Field" colspan=2>
        	<%
        	for(String groupid:groupList){
        		fieldList= hfm3.getUseField(groupid);
        		
        		if(fieldList!=null&&fieldList.size()>0){
        			int colSize=fieldList.size();
        			
        	%>		<div class="table-head" style="height:70px;">
        			<table class=ListStyle  border=0 cellspacing=1 style="position:fixed;z-index:99!important;padding: 0px !important;width:100%;table-layout:fixed;">
        			  <colgroup>
        			  	<col width="5%">
        	<%		for(int i=0;i<colSize;i++){
        				out.print("<col width='"+(95/colSize)+"%'>\n");
        			}
        			out.println("</colgroup>\n");
                	%>		
            		<TR class="Title">
    	            <Td class="Field" align=right colspan="<%=colSize+1%>" style="text-align: right;">
    	            	<input class="addbtn" id="serviceaddbtn" accesskey="A" onclick="addNewRow('service');" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" type="button">
    					<input class="delbtn" id="servicedelbtn" accesskey="E" onclick="deleteSelectedRow('service');" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" type="button">
    				</Td>
    	          </TR>	
            			
            	<%		out.println("<TR class=HeaderForXtalbe>\n");
        			out.println("<th><input name=\"serviceChkAll\" tarObj=\"serviceChk\" type=\"checkbox\" onclick=\"jsChkAll(this)\"></th>\n");
        		  	
        			for(String fieldid:fieldList){
        				int fieldlabel = Util.getIntValue(MeetingFieldComInfo.getLabel(fieldid));
        				out.println("<th style=\"overflow: hidden;white-space:nowrap;text-overflow:ellipsis;\" title=\""+SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())+"\" >"+SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())+"</th>\n");
	        
	   				}
        			out.print("</tr></table></div>\n"); 
                	%>		
        					<div class="table-body">
                			<table id="serviceTabField" class=ListStyle  border=0 cellspacing=1>
                			  <colgroup>
                			  	<col width="5%">
                	<%		for(int i=0;i<colSize;i++){
                				out.print("<col width='"+(95/colSize)+"%'>\n");
                			}
                			out.println("</colgroup>\n");
                			out.print("</table></div>\n"); 
        		}
        	}
        	%>         
        	</td>
        </tr>
        </TBODY>
	  </TABLE>
	</div>
</FORM>
</td>
</tr>
</TABLE>
</td>
</tr>
<tr>
<td height="10"></td>
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
<script language="JavaScript" src="/js/addRowBg_wev8.js" >   
</script> 
<script language="JavaScript">  
////以下是议程和服务 明细列表处理
function jsChkAll(obj)
{    
	var tar=$(obj).attr("tarObj");
   $("input[name='"+tar+"']").each(function(){
		changeCheckboxStatus(this,obj.checked);
	}); 
} 
//移除 checkbox初始美化值
function removeSourceCheck(){
	$('#serviceRowSource').find("input[type='checkbox']").each(function(){
		removeBeatyRadio(this);
	});
	$('#topicRowSource').find("input[type='checkbox']").each(function(){
		removeBeatyRadio(this);
	});
}

rowindex = "<%=topicrows%>";
serviceindex = "<%=servicerows%>";

function addNewRow(target){
	if(target=='service'){
		serviceindex = serviceindex*1 +1;
		var oRow;
		var oCell;
		oRow = jQuery("#serviceTabField")[0].insertRow(-1);
		oRow.className="DataLight";
		
		for(var i=0;i<<%=serviceColSize%>;i++){
			oCell = oRow.insertCell(-1);
			var filename=jQuery("#serviceRowSource_"+i).attr("fieldName");
			
			var fieldid=jQuery("#serviceRowSource_"+i).attr("fieldid");
			var ht=jQuery("#serviceRowSource_"+i).html();
			if(!!ht && ht.match(/#rowIndex#/)){
				ht=ht.replace(/#rowIndex#/g,serviceindex);
			}
			oCell.innerHTML =ht;
			if(i!=0){
			 
				if(jQuery("#serviceRowSource_js_"+i)&&jQuery("#serviceRowSource_js_"+i).html()!=''){
					try{
						eval("cusFun_"+fieldid+"("+serviceindex+")");
					}catch(e){}
				}
				
			}
			
		}
		
		jQuery("#serviceTabField").jNice();
		jQuery("#serviceTabField").find("select").each(function(){
			jQuery(this).attr("notBeauty","");	
		})
		jQuery("#serviceTabField").find("select").selectbox();
		changeBtnSet("service");
		
	}else if(target=='topic'){
		rowindex = rowindex*1 +1;
		var oRow;
		var oCell;
		oRow = jQuery("#topicTabField")[0].insertRow(-1);
		oRow.className="DataLight";
		
		for(var i=0;i<<%=topicColSize%>;i++){
			oCell = oRow.insertCell(-1);
			var filename=jQuery("#topicRowSource_"+i).attr("fieldName");
			var fieldid=jQuery("#topicRowSource_"+i).attr("fieldid");
			var ht=jQuery("#topicRowSource_"+i).html();
			if(!!ht && ht.match(/#rowIndex#/)){
				ht=ht.replace(/#rowIndex#/g,rowindex);
			}
			oCell.innerHTML =ht;
			if(i!=0){
				if(jQuery("#topicRowSource_js_"+i)&&jQuery("#topicRowSource_js_"+i).html()!=''){
					try{
						eval("cusFun_"+fieldid+"("+rowindex+")");
					}catch(e){}
				}
			}
		}
		jQuery("#topicTabField").jNice();
		jQuery("#topicTabField").find("select").each(function(){
			jQuery(this).attr("notBeauty","");
		})
		jQuery("#topicTabField").find("select").selectbox();
		changeBtnSet("agenda");
	}
}
	
function deleteSelectedRow(target){
	if(target=='service'){
		var table=$(jQuery("#serviceTabField")[0]);
		var selectedTrs=table.find("tr:has([name='serviceChk']:checked)");
		if(selectedTrs.size()==0){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82884,user.getLanguage())%>");
			return;
		}
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(82017,user.getLanguage())%>",function(){
			selectedTrs.each(function(){
				jQuery(this).remove();
			});
		});
		changeBtnSet("service");
	}else if(target=='topic'){
		var table=$(jQuery("#topicTabField")[0]);
		var selectedTrs=table.find("tr:has([name='topicChk']:checked)");
		if(selectedTrs.size()==0){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82884,user.getLanguage())%>");
			return;
		}
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(82017,user.getLanguage())%>",function(){
			selectedTrs.each(function(){
				jQuery(this).remove();
			});
		});
		changeBtnSet("agenda");
	}
}
////以上是议程和服务 明细列表处理
function checkLength(){
    var items = <%=servicerows%>;
    var tmpvalue;
    for(var i=0;i<items;i++){
        tmpvalue = document.getElementById("serviceother_"+i).value;
        if(realLength(tmpvalue)>255){
		Dialog.alert("<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>255(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)");
		while(true){
			tmpvalue = tmpvalue.substring(0,tmpvalue.length-1);
			if(realLength(tmpvalue)<=255){
				document.getElementById("serviceother_"+i).value = tmpvalue;
				return;
			}
		}
		break;
	   }
    }
}
</script>
<script language=javascript>
function doSave(obj){
	var thisvalue=jQuery("#repeatType").val();
	var begindate="<%=isInterval%>" == "1"?$('#repeatbegindate').val():$('#begindate').val();
	var enddate="<%=isInterval%>" == "1"?$('#repeatenddate').val():$('#enddate').val();
	var needcheck='<%=needcheck%>'
	if(thisvalue==1){
		needcheck+=",repeatdays";
	}else if(thisvalue==2){
		needcheck+=",repeatweeks,rptWeekDays";
	}else if(thisvalue==3){
		needcheck+=",repeatmonths,repeatmonthdays";
	}
	needcheck+=getDetailNeedCheckString();
	if(check_form(document.weaver,needcheck)&&checkDateValidity(begindate,$('#begintime').val(),enddate,$('#endtime').val(),"<%=SystemEnv.getHtmlLabelName(16722,user.getLanguage())%>")){
		if(checkAddress()){
			document.weaver.topicrows.value=rowindex;
			document.weaver.servicerows.value=serviceindex; 
			//document.weaver.submit();
			doUpload();
		}
	}
}

function doSubmit(obj){
	var thisvalue=jQuery("#repeatType").val();
	var begindate="<%=isInterval%>" == "1"?$('#repeatbegindate').val():$('#begindate').val();
	var enddate="<%=isInterval%>" == "1"?$('#repeatenddate').val():$('#enddate').val();
	var needcheck='<%=needcheck%>'
	if(thisvalue==1){
		needcheck+=",repeatdays";
	}else if(thisvalue==2){
		needcheck+=",repeatweeks,rptWeekDays";
	}else if(thisvalue==3){
		needcheck+=",repeatmonths,repeatmonthdays";
	}
	needcheck+=getDetailNeedCheckString();
    if(check_form(document.weaver,needcheck)&&checkDateValidity(begindate,$('#begintime').val(),enddate,$('#endtime').val(),"<%=SystemEnv.getHtmlLabelName(16722,user.getLanguage())%>")){
			if(checkAddress()){
		 	   var thisvalue=jQuery("#repeatType").val();
		        //当选择重复会议时，不做会议室和人员冲突校验
		        if(thisvalue != 0){
		        	checkRepeatMaxDay();
					return;
		        }
		        //会议室冲突校验
		        if(<%=meetingSetInfo.getRoomConflictChk()%> == 1 ){
					forbiddenPage();
		        	$.post("/meeting/data/AjaxMeetingOperation.jsp?method=chkRoom",{
		        		address:$GetEle("address").value,
		        		begindate:begindate,begintime:$('#begintime').val(),
  						enddate:enddate,endtime:$('#endtime').val()},
		        	function(datas){
						if(datas != 0){
							<%if(meetingSetInfo.getRoomConflict() == 1){ %>
								releasePage();
				            	window.top.Dialog.confirm(datas.trim()+"</br><%=SystemEnv.getHtmlLabelName(19095,user.getLanguage())%>", function (){
				                	submitChkMbr();
				            	});
				            <%} else if(meetingSetInfo.getRoomConflict() == 2) {%>
								releasePage();
				            	Dialog.alert(datas.trim()+"</br><%=SystemEnv.getHtmlLabelName(32875,user.getLanguage())%>!");
				            <%}%>
						} else {
							submitChkMbr();
						}
					});
		        	
		        } else {
		        	submitChkMbr();
		        }
			}
	}
}
//人员冲突校验
function submitChkMbr(){
	 if(<%=meetingSetInfo.getMemberConflictChk()%> == 1){
		forbiddenPage();
  		$.post("/meeting/data/AjaxMeetingOperation.jsp?method=chkMember",
  			{hrmids:$("#hrmmembers").val(),crmids:$("#crmmembers").val(),
  			begindate:$('#begindate').val(),begintime:$('#begintime').val(),
  			enddate:$('#enddate').val(),endtime:$('#endtime').val()},
  			function(datas){
				var dataObj=null;
				if(datas != ''){
					dataObj=eval("("+datas+")");
				}
				if(wuiUtil.getJsonValueByIndex(dataObj, 0) == "0"){
					submitact();
				} else {
					<%if(meetingSetInfo.getMemberConflict() == 1){ %>
						releasePage();
			            window.top.Dialog.confirm(wuiUtil.getJsonValueByIndex(dataObj, 1)+"<%=SystemEnv.getHtmlLabelName(32873,user.getLanguage())%>?", function (){
			                submitact();
			            },null, null, 120);
		            <%} else if(meetingSetInfo.getMemberConflict() == 2) {%>
						releasePage();
		            	Dialog.alert(wuiUtil.getJsonValueByIndex(dataObj, 1)+"<%=SystemEnv.getHtmlLabelName(32874,user.getLanguage())%>" ,null ,400 ,150);
		            	return;
		            <%}%>
				} 
			});
       } else {
       		submitact();
       }
}
//周期会议的情况下周期最大跨度校验
function checkRepeatMaxDay(){
	if(<%=meetingSetInfo.getZqhyzdkd()%> > 0){
		forbiddenPage();
  		var endDate = $('#repeatenddate').val();
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
    		submitact();
    	}else{
    		releasePage();
           	Dialog.alert("<%=SystemEnv.getHtmlLabelName(129693,user.getLanguage())%>" ,null ,400 ,150);
           	return;
    	}
   }else{
   		submitact();
   }
}

function submitact(){
	var remind="<%=SystemEnv.getHtmlLabelName(24248,user.getLanguage())%>？";
	<%if(meetingSetInfo.getRoomConflictChk()==1&&isInterval==1){%>//开启会议室冲突提醒 并且是周期会议
		remind+="</br></br><font style='color:red;'><%=SystemEnv.getHtmlLabelName(126907, user.getLanguage())%></br><%=SystemEnv.getHtmlLabelName(126908, user.getLanguage())%></font>";
		window.top.Dialog.confirm(remind, function (){
			forbiddenPage();
			enableAllmenu();
			document.weaver.topicrows.value=rowindex;
			document.weaver.servicerows.value=serviceindex; 
			document.weaver.method.value = "addSubmit";
			doUpload();
		},function(){
			releasePage();
		});
	<%}else{%>
		forbiddenPage();
		enableAllmenu();
		document.weaver.topicrows.value=rowindex;
		document.weaver.servicerows.value=serviceindex; 
		document.weaver.method.value = "addSubmit";
		doUpload();
	<%}%>
}

function doUpload(){
	$('#f_weaver_belongto_userid').val("<%=f_weaver_belongto_userid%>");
	//附件上传
    StartUploadAll();
    checkuploadcomplet();
}

//提交时校验会议室是否为空
function checkAddress()
{	
	if($("#customizeAddress").length>0){
		if($("#address").val()==''&&$("#customizeAddress").val()==''){
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(20393, user.getLanguage())%>");
			return false;
		}
	}else{
		if($("#address").val()==''){
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(20393, user.getLanguage())%>");
			return false;
		}
	}
	return true;
}

//检测开始时间和结束时间的前后
function checkDateValidity(begindate,begintime,enddate,endtime,errormsg){
	var isValid = true;
	var repeatVal = jQuery("#repeatType").val();
	if(compareDate(begindate,begintime,enddate,endtime) == 1){
		Dialog.alert(errormsg);
		isValid = false;
	}
	if(repeatVal != 0 && isValid){
		if(begintime > endtime){
			Dialog.alert(errormsg);
			isValid = false;
		}
	}
	return isValid;
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
//计算参会人数
function countAttend()
{
	if($('#hrmmembers').val()==''){
		if($('#totalmember').length>0){
			$('#totalmember').val(0);
		}
	}else{
		var hrmmember=$('#hrmmembers').val().split(",");
		if($('#totalmember').length>0){
			$('#totalmember').val(hrmmember.length);
		}
	}
}
//计算参会客户数
function countAttendCRM()
{	
	if($('#crmmembers').val()==''){
		if($('#crmtotalmember').length>0){
			$('#crmtotalmember').val(0);
		}
	}else{
		var crmmember=$('#crmmembers').val().split(",");
		if($('#crmtotalmember').length>0){
			$('#crmtotalmember').val(crmmember.length);
		}
	}
}

function ItemCount_KeyPress_Plus()
{
	if(!(window.event.keyCode >= 48 && window.event.keyCode <= 57))
	{
		window.event.keyCode = 0;
	}
}
</script>
</body>
</html>
<script language="javascript">

//会议选择框,判断是否存在自定义会议地点
function CheckOnShowAddress(){
	 if($('#customizeAddress').length>0&&$('#customizeAddress').val()!=""){
	 	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(82885,user.getLanguage())%>",function(){
	 		onShowAddress();	
	 	});
	 }else{
	 	onShowAddress();	
	 }
}
//打开会议室选择框
function onShowAddress(){
	var url = "/systeminfo/BrowserMain.jsp?url=/meeting/Maint/MutilMeetingRoomBrowser.jsp";
	showBrwDlg(url, "frommeeting=1&selectedids="+$('#address').val(), 500,480,"addressspan","address","addressChgCbk");
	$("#src_box_middle").css("height","400px");
}
//会议室回写处理
function addressChgCbk(datas){
		if(datas){
		if (datas!=""){
             var ids = datas.id;
             var names = datas.name;
             arrid=ids.split(",");
             arrname=names.split(",");
             var html="";
             for(var i=0;i<arrid.length;i++){
               html += "<a href='/meeting/Maint/MeetingRoom_list.jsp?id="+arrid[i]+"' target='_new' >"+arrname[i]+"</A>";
             }
             html = html.substr(0,html.length-1);
             $("#addressspan").html(html);
			 weaver.address.value = ids;
			 $("#customizeAddressspan").html("");
		}else{
			 $("#addressspan").html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			 weaver.address.value="";
			 $("#customizeAddressspan").html("<IMG src='/images/BacoError.gif' align=absMiddle>");
		}
		
		 _writeBackData("address",2,{id:jQuery("#address").val(),name:jQuery("#addressspan").html()},{
			hasInput:true,
			replace:true,
			//isSingle:true,
			isedit:true
		});
	}
	addressCallBack();
}
//会议室选择和填写后方法处理
function addressCallBack(){
	if($("#address").val()!=''){
		if($('#customizeAddress').length>0){
			$('#customizeAddress').val("")
		}
	}
	checkaddress();
}
//填写自定义会议室时,检测是否选择了会议地点 
function omd(){
	  var address = $("#address").val();
	  if(address!=''){
	  	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(82886,user.getLanguage())%>",function(){
	  		$("#address").val("");
	  		$("#addressspan").html("");
	  		$("#addressspanimg").html("<img src='/images/BacoError_wev8.gif' align='absmiddle'>");
	  		checkaddress();
	  		$('#customizeAddress').focus();
	  	});
	  }
       
}

//改变会议地点和自定义会议地点的必填标识
function checkaddress(){
	var address = $("#address").val();
	var customizeAddress=$('#customizeAddress').length>0?$('#customizeAddress').val():'';
	if(address!=''||customizeAddress!=''){
		$("#addressspanimg").html("");
		if($('#customizeAddress').length>0){
			$("#customizeAddressspan").html("");
		}
	}else{
		$("#addressspanimg").html("<img src='/images/BacoError_wev8.gif' align='absmiddle'>");
		if($('#customizeAddress').length>0){
			$("#customizeAddressspan").html("<img src='/images/BacoError_wev8.gif' align='absmiddle'>");
		}
	}
}

//修改会议重复模式
function changeRepeatType(){
	var thisvalue=jQuery("#repeatType").val();
	$('div[name="repeatTypeDiv"]').hide();
	$('#repeatType'+thisvalue).show(); 
}
 

//会议类型变更
function showMeetingType(){
	var meetingtype = jQuery("#meetingtype").val();
	 
	if(meetingtype != "" && meetingtype != null){
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(32143,user.getLanguage())%>", function (){
				meetingTypeChange();	
		});
	} else {
		meetingTypeChange();
	}
}

//重置与会议类型相关的内容
function meetingTypeChange(){
	onShowMeetingType("meetingtypespan","meetingtype",0,1,"meetingTypeChgCbk","<%=isInterval%>");
	
}
//回写会议类型,刷新页面
function meetingTypeChgCbk(datas){
	if (datas != null) {
		callBackValue(datas,"meetingtypespan","meetingtype");
		$("#weaver").attr("action", "/meeting/data/NewMeeting.jsp");
		$("#weaver").submit();
	}
}

//重置与会议类型相关的内容
function meetingReset(event,datas,name){
	if (datas != null) {
		$("#weaver").attr("action", "/meeting/data/NewMeeting.jsp");
		$("#weaver").submit();
	}
}

function forbiddenPage(){  
    window.parent.forbiddenPage();
}  

function releasePage(){  
    window.parent.releasePage();
}

function btn_cancle(){
	window.parent.closeDialog();
}

jQuery(document).ready(function(){
	resizeDialog(document);
	onRemindType();
	if("<%=isInterval%>" == "1"){
		changeRepeatType();
	}
	removeSourceCheck();
	checkaddress();
});
//显示和隐藏 提醒时间控制
function onRemindType(){
	if(!$('#remindTypeNew').val()||$('#remindTypeNew').val()==''){
		hideEle("remindtimetr", true);
	}else{
		showEle("remindtimetr", true);
	}
}
//查看会议室使用情况,传递开始日期
function showRoomsWithDate(){
	var begindate="<%=isInterval%>" == "1"?$('#repeatbegindate').val():$('#begindate').val();
	if(window.top.Dialog){
		var diag = new window.top.Dialog();
	} else {
		diag = new Dialog();
	}
	diag.currentWindow = window;
	diag.Width = 1100;
	diag.Height = 550;
	diag.Modal = true;
	diag.maxiumnable = true;
	diag.Title = "<%=SystemEnv.getHtmlLabelName(15881,user.getLanguage())%>";
	diag.URL = "/meeting/report/MeetingRoomPlan.jsp?currentdate="+begindate;
	diag.show();
}
function showDetailCustomTreeBrowser(type){
	var eve=window.event;
	var eventSource = eve.srcElement||eve.target;
	var fieldid=eventSource.id.substr(0,eventSource.id.length-11);
	showCustomTreeBrowser(fieldid,type);
	
}

function getDetailNeedCheckString(){
	var needCheckString=""; 
	//会议服务明细必填字段
	var serviceNeedCheck='<%=serviceNeedChk%>'; 
	var serviceNeedCheckList=serviceNeedCheck.split(",");
	for(var i=0;i<serviceNeedCheckList.length;i++){
		var sncname=serviceNeedCheckList[i];
		for(var j=0;j<serviceindex;j++){
			needCheckString+=","+sncname+"_"+(j+1);
		}
	}
	//会议议程明细必填字段
	var topicNeedCheck='<%=topicNeedChk%>'; 
	var topicNeedCheckList=topicNeedCheck.split(",");
	for(var i=0;i<topicNeedCheckList.length;i++){
		var tncname=topicNeedCheckList[i];
		for(var j=0;j<rowindex;j++){
			needCheckString+=","+tncname+"_"+(j+1);
		}
	}
	return needCheckString;
}
function changeBtnSet(target){
	var divh=$("#"+target+"Div").css("height").replace("px","");
	var contenth=$(".zDialog_div_content").css("height").replace("px","");
	if(target=="agenda"){
		target="topic";
	}
	if(parseInt(divh)>parseInt(contenth)){
		$("#"+target+"delbtn").css("margin-right","20px");
	}else{
		$("#"+target+"delbtn").css("margin-right","");
	}
}
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
