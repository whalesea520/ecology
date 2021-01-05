<%@page import="weaver.login.LoginMsg"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util,weaver.hrm.User,
                 weaver.rtx.RTXExtCom,
				 weaver.rtx.RTXConfig,
                 weaver.hrm.settings.BirthdayReminder,
                 weaver.hrm.settings.RemindSettings,
                 weaver.systeminfo.setting.HrmUserSettingHandler,
                 weaver.systeminfo.setting.HrmUserSetting,
                 weaver.general.TimeUtil,
				 weaver.login.Account" %>
<%@ page import="java.net.*" %>
<%@ page import="java.util.*,HT.HTSrvAPI,java.math.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.file.Prop" %>
<%@page import="java.io.FileInputStream"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="TestWorkflowCheck1" class="weaver.workflow.workflow.TestWorkflowCheck" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rtxClient" class="weaver.rtx.RTXClientCom" scope="page" />
<jsp:useBean id="autoPlan" class="weaver.hrm.performance.targetplan.AutoPlan" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="session" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="HrmScheduleDiffUtil" class="weaver.hrm.report.schedulediff.HrmScheduleDiffUtil" scope="page" />
<jsp:useBean id="PluginUserCheck" class="weaver.license.PluginUserCheck" scope="page" />
<jsp:useBean id="MouldStatusCominfo" class="weaver.systeminfo.MouldStatusCominfo" scope="page" />
<jsp:useBean id="rsExtend" class="weaver.conn.RecordSet" scope="page" />
<%
	if(true){
		String params = request.getQueryString();
		if(params==null){
			response.sendRedirect("/wui/main.jsp");
		}else{
			response.sendRedirect("/wui/main.jsp?"+params);
		}
		return;
	}
%>

<%if("false".equals(isIE)){ 
  //当前非浏览器不支持Ecology经典主题
  request.setAttribute("labelid","27889");
  request.getRequestDispatcher("/wui/common/page/sysRemind.jsp").forward(request,response);
}else{ %>
<%@ include file="/systeminfo/template/templateCss.jsp" %>
<%@ include file="/docs/common.jsp" %>
<!--网上调查部分-- 开始No blank -->
<script language="javascript" src="/wui/theme/ecology7/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology7/jquery/js/zDrag_wev8.js"></script>
<SCRIPT LANGUAGE="javascript">
 var voteids="";
</script>
<% 
String acceptlanguage = request.getHeader("Accept-Language");
if(!"".equals(acceptlanguage))
	acceptlanguage = acceptlanguage.toLowerCase();
boolean NoCheck=false;
RecordSet.executeSql("select NoCheckPlugin from SysActivexCheck where NoCheckPlugin='1' and logintype='1' and userid="+user.getUID());
if(RecordSet.next()) NoCheck=true;
if(!NoCheck){
%>
<script language="javascript" src="/js/activex/ActiveX_wev8.js"></script>

<SCRIPT LANGUAGE="javascript">

function getOuterLanguage()
{
	return '<%=acceptlanguage%>';
}
checkWeaverActiveX(<%=user.getLanguage()%>);
</script>
<%
}
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16);
HrmScheduleDiffUtil.setUser(user);
	boolean isSyadmin=false;
	//判断分权管理员
	RecordSet.executeSql("select loginid from hrmresourcemanager where loginid = '"+user.getLoginid()+"'");
	if(RecordSet.next()){
		isSyadmin = true;
	}
	
		if(!isSyadmin){
		RecordSet.executeSql("select loginid from hrmresource where loginid = '"+user.getLoginid()+"'");
		if(RecordSet.next()){
		   isSyadmin = false;
		} else {
		   isSyadmin = true;
		}
	}

	String isSignInOrSignOut="0";//是否启用前到签退功能  
	String onlyworkday = "1";//只在工作日签到
	RecordSet.executeSql("select needsign,onlyworkday from hrmkqsystemSet ");
	if(RecordSet.next()){
		isSignInOrSignOut = ""+RecordSet.getInt("needsign");
		onlyworkday = ""+RecordSet.getInt("onlyworkday");
	}  
	
	boolean isWorkday = HrmScheduleDiffUtil.getIsWorkday(CurrentDate);
  if(onlyworkday.equals("0"))isWorkday=true;//如果非工作日也要签到
	
	//判断当前用户当天有没有签到
	String signType="1";

String sql=""; 
sql="select distinct t1.id from voting t1,VotingShareDetail t2 where t1.id=t2.votingid and t2.resourceid="+user.getUID()+" and t1.status=1 "+ 
" and t1.id not in (select distinct votingid from votingresource where resourceid ="+user.getUID()+")" 
+" and (t1.beginDate<'"+CurrentDate+"' or (t1.beginDate='"+CurrentDate+"' and (t1.beginTime is null or t1.beginTime='' or t1.beginTime<='"+CurrentTime+"'))) "
; 
RecordSet.executeSql(sql); 
while(RecordSet.next()){ 
String votingid = RecordSet.getString("id"); 
%> 
<script language=javascript> 

    if(voteids == ""){
      voteids = '<%=votingid%>';
   }else{
      voteids =voteids + "," +  '<%=votingid%>';
   }
</script> 
<%}%> 

<script language=javascript> 

    function showVote(){
     if(voteids !=""){
	     var arr = voteids.split(",");
		 for(i=0;i<arr.length;i++){
		    var diag_vote = new Dialog();
			diag_vote.Width = 800;
			diag_vote.Height = 600;
			diag_vote.Modal = false;
			diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(17599,user.getLanguage())%>";
			diag_vote.URL = "/voting/VotingPoll.jsp?votingid="+arr[i];
			diag_vote.show();
		 }
	 }
  } 
  jQuery(document).ready(function() {
   showVote();
   });
</script> 

<!--网上调查部分-- 结束 -->

<%
boolean checkchattemp = false;
String chatserver = Util.null2String(weaver.general.GCONST.getCHATSERVER());//检测即时通讯是否开启
if(!"".equals(chatserver)) checkchattemp = true;


//String frommain = Util.null2String(request.getParameter("frommain")) ;
RemindSettings settings=(RemindSettings)application.getAttribute("hrmsettings");
String birth_valid = settings.getBirthvalid();
String birth_remindmode = settings.getBirthremindmode();
BirthdayReminder birth_reminder = new BirthdayReminder();
if(birth_valid!=null&&birth_valid.equals("1")&&birth_remindmode!=null&&birth_remindmode.equals("0")){
  String today = TimeUtil.getCurrentDateString();
 if( application.getAttribute("birthday")==null||application.getAttribute("birthday")!=today){
   application.setAttribute("birthday",today);
   ArrayList birthEmployers=birth_reminder.getBirthEmployerNames(user);
   application.setAttribute("birthEmployers",birthEmployers);
   }
 ArrayList birthEmployers=(ArrayList)application.getAttribute("birthEmployers");
 
 if(birthEmployers.size()>0){    
%>
<script>
var chasm = screen.availWidth;
var mount = screen.availHeight;
function openCenterWin(url,w,h) {
   window.open(url,'','scrollbars=yes,resizable=no,width=' + w + ',height=' + h + ',left=' + ((chasm - w - 10) * .5) + ',top=' + ((mount - h - 30) * .5));
}
openCenterWin('/hrm/setting/Birthday.jsp',516,420);
</script>
<%}}%>
<%
String username = ""+user.getUsername() ;
String userid = ""+user.getUID() ;
String usertype = "" ;
if(user.getLogintype().equals("1")) usertype = "1" ;
else  usertype = ""+(-1*user.getType()) ;

char separator = Util.getSeparator() ;

Calendar today = Calendar.getInstance();
String currentyear = Util.add0(today.get(Calendar.YEAR), 4) ;
String currentmonth = Util.add0(today.get(Calendar.MONTH)+1, 2) ;
String currentdate = Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
String currenthour = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) ;

String initsrcpage = "" ;
String logintype = Util.null2String(user.getLogintype()) ;
String Customertype = Util.null2String(""+user.getType()) ;
int targetid = Util.getIntValue(request.getParameter("targetid"),0) ;
//String loginfile = Util.null2String(request.getParameter("loginfile")) ;
String loginfile = Util.getCookie(request , "loginfileweaver") ;
String message = Util.null2String(request.getParameter("message")) ;
String logmessage = Util.null2String((String)session.getAttribute("logmessage")) ;
//自动生成个人计划
//autoPlan.autoSetPlanDay(""+user.getUID(),user);
if(targetid == 0) {
	if(!logintype.equals("2")){
		//initsrcpage="/workspace/WorkSpace.jsp";
        initsrcpage="/homepage/HomepageRedirect.jsp";
	}else{
		initsrcpage="/docs/news/NewsDsp.jsp";
	}
}

String gopage = Util.null2String(request.getParameter("gopage"));
String frompage = Util.null2String(request.getParameter("frompage"));
if(!gopage.equals("")){
	gopage=URLDecoder.decode(gopage);
	if(!"".equals(frompage)){
		BaseBean.writeLog(frompage);
		initsrcpage = gopage+"&message=1&id="+user.getUID();
	}else{
		initsrcpage = gopage;
	}
}
else {
	username = user.getUsername() ;
	userid = ""+user.getUID() ;
	if(logintype.equals("2")){
		switch(targetid) {
			case 1:													// 文档  - 新闻
				initsrcpage = "/docs/news/NewsDsp.jsp?id=1" ;
				break ;
			case 2:													// 人力资源 - 新闻
				initsrcpage = "/docs/news/NewsDsp.jsp?id=2" ;
				break ;
			case 3:													// 财务 - 组织结构
				initsrcpage = "/org/OrgChart.jsp?charttype=F" ;
				break ;
			case 4:													// 物品 - 搜索页面
				initsrcpage = "/lgc/catalog/LgcCatalogsView.jsp" ;
				break ;
			case 5:													// CRM - 我的客户
				initsrcpage = "/CRM/data/ViewCustomer.jsp?CustomerID="+userid ;
				break ;
			case 6:													// 项目 - 我的项目
				initsrcpage = "/proj/search/SearchOperation.jsp" ;
				break ;
			case 7:													// 工作流 - 我的工作流
				initsrcpage = "/workflow/request/RequestView.jsp" ;
				break ;
			case 8:													// 工作流 - 我的工作流
				initsrcpage = "/system/SystemMaintenance.jsp" ;
				break ;
			case 9:													// 工作流 - 我的工作流
				initsrcpage = "/cpt/CptMaintenance.jsp" ;
				break ;

		}
	}else{
		switch(targetid) {
			case 1:													// 文档  - 新闻
				initsrcpage = "/docs/report/DocRp.jsp" ;
				break ;
			case 2:													// 人力资源 - 新闻
				initsrcpage = "/hrm/report/HrmRp.jsp" ;
				break ;
			case 3:													// 财务 - 组织结构
				initsrcpage = "/fna/report/FnaReport.jsp" ;
				break ;
			case 4:													// 物品 - 搜索页面
				initsrcpage = "/lgc/report/LgcRp.jsp" ;
				break ;
			case 5:													// CRM - 我的客户
				initsrcpage = "/CRM/CRMReport.jsp" ;
				break ;
			case 6:													// 项目 - 我的项目
				initsrcpage = "/proj/ProjReport.jsp" ;
				break ;
			case 7:													// 工作流 - 我的工作流
				initsrcpage = "/workflow/WFReport.jsp" ;
				break ;
			case 8:													// 工作流 - 我的工作流
				initsrcpage = "/system/SystemMaintenance.jsp" ;
				break ;
			case 9:													// 工作流 - 我的工作流
				initsrcpage = "/cpt/report/CptRp.jsp" ;
				break ;

		}
	}
}
if(!relogin0.equals("1")&&frommain.equals("yes")){
logmessages=(Map)application.getAttribute("logmessages");
logmessages.put(""+user.getUID(),logmessage);
}

logmessages=(Map)application.getAttribute("logmessages");
logmessages.put(""+user.getUID(),logmessage);

if(!relogin0.equals("1")&&!frommain.equals("yes")&&!logmessage.equals("")){

session.setAttribute("frommain","true");
%>
<script language=javascript>
	flag=confirm("<%=SystemEnv.getHtmlLabelName(16643,user.getLanguage())%>!\n<%=SystemEnv.getHtmlLabelName(2023,user.getLanguage())%>:"+"<%=logmessage%>");
	if(flag)
	//window.location="/main.jsp?frommain=yes&gopage=<%=gopage%>"
	else
	window.location="/login/Login.jsp"
</script>
<%}%>

<%if(relogin0.equals("1")&&!logmessage.equals("")){
	boolean is_relogin_open=Prop.getPropValue("hrm_mfstyle","is_relogin_open").equalsIgnoreCase("true");
	if(is_relogin_open){
%>
<script language=javascript>
	alert("<%=SystemEnv.getHtmlLabelName(16643,user.getLanguage())%>!\n<%=SystemEnv.getHtmlLabelName(27892,user.getLanguage())+SystemEnv.getHtmlLabelName(2023,user.getLanguage())%>:"+"<%=LoginMsg.getLastLoginInfo(""+user.getUID()) %>");
</script>
<%}
}%>
<script language=javascript>
function goMainFrame(o){
	o.contentWindow.document.frames[1].document.location.href = "<%=initsrcpage%>";    
}
function window.onload()
{
  //document.getElementById("leftFrame").contentWindow.document.frames[1].document.location.href = "<%=initsrcpage%>";
}
</script>

<html>
<head>
<title><%=templateTitle%> - <%=username%></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="/css/Weaver_wev8.css" type="text/css">
<LINK href="/js/jquery/jquery_dialog_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" language="javascript" src="/js/jquery/jquery_dialog_wev8.js"></script>
<script type="text/javascript" language="javascript">
function ReloadOpenerByDialogClose() {
    <%out.println(TestWorkflowCheck1.ReloadByDialogClose(request));%>
}
var glbreply = true;
</script>
<%
if(needusb0==1&&"2".equals(usbtype0)){  
	String randLong = ""+Math.random()*1000000000;
	String serialNo = user.getSerial();
	HTSrvAPI htsrv = new HTSrvAPI();
	String sharv = "";
	sharv = htsrv.HTSrvSHA1(randLong, randLong.length());
	sharv = sharv + "04040404";
	String ServerEncData = htsrv.HTSrvCrypt(0, serialNo, 0, sharv);
%>
<script language="JavaScript"  src="/js/htusbjs_wev8.js"></script>
<script language="vbs"  src="/js/htusb.vbs"></script>
<OBJECT id="htactx" name="htactx" classid="clsid:FB4EE423-43A4-4AA9-BDE9-4335A6D3C74E" codebase="HTActX.cab#version=1,0,0,1" style="HEIGHT: 0px; WIDTH: 0px;display:none"></OBJECT>
<script language="JavaScript">
var usbuserloginid = "<%=user.getLoginid()%>";
var usblanguage = "<%=user.getLanguage()%>";
var ServerEncData = "<%=ServerEncData%>";
var randLong = "<%=randLong%>";
var password = "<%=user.getPwd()%>";
checkusb();
</script>
<%
}%>
<style id="popupmanager">
#arrowBoxUp{
	text-align:center;
	border-left: 1px solid #666666;
	border-right: 1px solid #666666;
	border-top:1px solid #666666;
	background-color: #F9F8F7;
	display:none;
}
#arrowBoxDown{
	text-align:center;
	border-left: 1px solid #666666;
	border-right: 1px solid #666666;
	border-bottom:1px solid #666666;
	background-color: #F9F8F7;
	display:none;
}
.popupMenu{
	width: 234px;
	border-left: 1px solid #666666;
	border-right: 1px solid #666666;
	background-color: #F9F8F7;
	padding: 1px;
}
.popupMenuTable{
	/*background-image: url(/images/popup_bg_menu_wev8.gif);*/
	background-repeat: repeat-y;
}
.popupMenuTable TD{
	font-family:MS Shell Dlg;
	font-size: 12px;
	cursor: default;
}
.popupMenuRow{
	height: 21px;
	padding: 1px;
}
.popupMenuRowHover{
	height: 21px;
	border: 1px solid #0A246A;
	background-color: #B6BDD2;
}
.popupMenuSep{
	background-color: #A6A6A6;
	height:1px;
	width: expression(parentElement.offsetWidth-10);
	position: relative;
	left: 10;
}
</style>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/js/jquery/jquery_wev8.js"></script>
</head>
<body id="mainBody" style="overflow:auto" bgcolor="#FFFFFF" text="#000000" oncontextmenu="return false;">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%@ include file="/favourite/FavouriteShortCut.jsp" %>
<script>   



  var con=null;
  window.onbeforeunload=function(){	
	  if(typeof(isMesasgerUnavailable) == "undefined") {
		     isMesasgerUnavailable = true; 
	  }  
	  if(!isMesasgerUnavailable && glbreply == true){
	  	return "<%=SystemEnv.getHtmlLabelName(24985,user.getLanguage())%>";
	  }	 
	  var e=getEvent();
	  var n = e.screenX - window.screenLeft;
	  var b = n > document.documentElement.scrollWidth-20;  
	  if(b && e.clientY < 0 || e.altKey){
	  	  e.returnValue = "<%=SystemEnv.getHtmlLabelName(16628,user.getLanguage())%>"; 
	  }
  }  
  window.onunload=function(){	 
	  <%
		boolean isHaveMessager=Prop.getPropValue("Messager","IsUseWeaverMessager").equalsIgnoreCase("1");
	  	boolean isHaveEMessager=Prop.getPropValue("Messager2","IsUseEMessager").equalsIgnoreCase("1");
		int isHaveMessagerRight = PluginUserCheck.checkPluginUserRight("messager",user.getUID()+"");
		if(isHaveMessager&&!userid.equals("1")&&isHaveMessagerRight==1){%>
			logoutForMessager();
		<%}%>
  }
  </script>

<table width="100%"  height="100%" border="0" cellspacing="0" cellpadding="0">
<tr height="60" id="topMenu" name="topMenu" style="DISPLAY:''">
<td >
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr id="topMenuLogo" height="32">
		<td>
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			<tr class="topBg">
				<td width ="198">
				<%
				String templateLogo = "/images/StyleGray/ecologyLogoA_wev8.jpg";
				if( !logo.equals("")&&!logo.equals("0") )
					templateLogo = "/TemplateFile/"+logo;
				%><img src="<%=templateLogo%>"/></td>
				<td width="*" valign="bottom" align="center">
					<%if(isShowMainMenu.equals("1")){%>
					<iframe name="apXPDropDown" BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE height=20 width=700 SCROLLING=no SRC=ApXPDropDown.jsp></iframe>
					<%}else{%>
					&nbsp;
					<%}%>
				</td>
			</tr>
			</table>
		</td>
	</tr>

	<tr>
		<td height="28" class="templateToolbarBg">
		<table width="100%"  height="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<%String templateLogoBottom = "/images/StyleGray/ecologyLogoB_wev8.jpg";
		if(!logoBottom.equals("")&&!logoBottom.equals("0"))
			templateLogoBottom = "/TemplateFile/"+logoBottom;
		%>
		<%
		if(logo.equals("0")||logo.equals("")){
			%>
			<%
		}else{
			if(!logoBottom.equals("")&&!logoBottom.equals("0")){
				%>
				
			<%
			}
		}	
		%>
		<td width="185" style="background-repeat: no-repeat;background-image: url('<%=templateLogoBottom%>')">
		
		</td>
		
		
			<td width=23 align="center">
				<%if(!logintype.equals("2")){%>
				<iframe BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE width=0 height=0 SCROLLING=no SRC=/system/SysRemind.jsp></iframe>
				<%}%>
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/BP_Hide_wev8.gif" id="LeftHideShow" onclick="javascript:mnToggleleft()" title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>"></td></tr></table>
			</td>
			<td width=23 align="center">
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/BP2_Hide_wev8.gif" id="TopHideShow" onclick="javascript:mnToggletop()" title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>"></td></tr></table>
			</td>
			<td width=10 align="center">
				<img src="/images_face/ecologyFace_1/VLine_1_wev8.gif" border=0>
			</td>
			<td style="width:23px;height:28px;" align="center" valign="middle">
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/LogOut_wev8.gif" onclick="javascript:toolBarLogOut()" title="<%=SystemEnv.getHtmlLabelName(1205,user.getLanguage())%>"></td></tr></table><!--退出-->
			</td>
			<td width=10 align="center">
				<img src="/images_face/ecologyFace_1/VLine_1_wev8.gif" border=0>
			</td>
			<td style="width:23px;height:28px;" align="center" valign="middle">
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Back_wev8.gif" onclick="javascript:toolBarBack()" title="<%=SystemEnv.getHtmlLabelName(15122,user.getLanguage())%>"></td></tr></table><!--后退-->
			</td>
			<td style="width:23px;height:28px;" align="center" valign="middle">
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Pre_wev8.gif" onclick="javascript:toolBarForward()" title="<%=SystemEnv.getHtmlLabelName(15123,user.getLanguage())%>"></td></tr></table><!---->
			</td>
			<td style="width:23px;height:28px;" align="center" valign="middle">
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Refur_wev8.gif" onclick="javascript:toolBarRefresh()" title="<%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%>"></td></tr></table><!--刷新-->
			</td>
			<!-- <td style="width:23px;height:28px;" align="center" valign="middle">
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Favourite_wev8.gif" onclick="javascript:toolBarFavourite()" title="<%=SystemEnv.getHtmlLabelName(2081,user.getLanguage())%>"></td></tr></table>
			</td> --><!--收藏夹-->
			<td style="width:23px;height:28px;" align="center" valign="middle">
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Print_wev8.gif" onclick="javascript:toolBarPrint()" title="<%=SystemEnv.getHtmlLabelName(257,user.getLanguage())%>"></td></tr></table><!--打印-->
			</td>
			<%if(weaver.general.GCONST.getMOREACCOUNTLANDING()){%>
			<%//多账号%>
			<%List accounts =(List)session.getAttribute("accounts");
                if(accounts!=null&&accounts.size()>1){
                 
                    Iterator iter=accounts.iterator();

                %>
                <td style="width:23px;height:28px;" align="center" valign="middle">
            <table class="toolbarMenu"><tr>
            <td><select id="accountSelect" name="accountSelect" onchange="onCheckTime(this);"  disabled>
                    <% while(iter.hasNext()){Account a=(Account)iter.next();
                    String subcompanyname=SubCompanyComInfo.getSubCompanyname(""+a.getSubcompanyid());
                    String departmentname=DepartmentComInfo.getDepartmentname(""+a.getDepartmentid());
                    String jobtitlename=JobTitlesComInfo.getJobTitlesname(""+a.getJobtitleid());                       
                    %>
                    <option <%if((""+a.getId()).equals(userid)){%>selected<%}%> value=<%=a.getId()%>><%=subcompanyname+"/"+departmentname+"/"+jobtitlename%></option>
                    <%}%>
                </select></td></tr></table></td>
            	<%}%>
			<%}%>
			<td width=10 align="center">
				<img src="/images_face/ecologyFace_1/VLine_1_wev8.gif" border=0>
			</td>
			<td width="50px" id="favouriteshortcutid"><span style="cursor:hand;width:100%;color:#172971"><script>mb.write();</script></span></td>
			<td width=10 align="center">
				<img src="/images_face/ecologyFace_1/VLine_1_wev8.gif" border=0>
			</td>
			<td>
				<table border="0" cellspacing="0" cellpadding="0">
				<form name="search" method="post" action="/system/QuickSearchOperation.jsp" target="mainFrame">
				<tr>
					<td nowrap>
						<select name="searchtype" style="width:60px">
						<option value=1><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></option>
						<option value=2><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option>
						<%if(isgoveproj==0){%>
						<%if((Customertype.equals("3") || Customertype.equals("4") || !logintype.equals("2"))&&("1".equals(MouldStatusCominfo.getStatus("crm"))||"".equals(MouldStatusCominfo.getStatus("crm")))){%> 
						<option value=3><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></option>
						<%}%>
						<%}%>
						<%if((!logintype.equals("2")) && software.equals("ALL")&&("1".equals(MouldStatusCominfo.getStatus("cpt"))||"".equals(MouldStatusCominfo.getStatus("cpt")))){%>
						<option value=4><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></option>
						<%}%>
						<option value=5><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%></option>
						<%if(isgoveproj==0&&("1".equals(MouldStatusCominfo.getStatus("proj"))||"".equals(MouldStatusCominfo.getStatus("proj")))){%>
						<option value=6><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></option>
						<%}%>
						<%if("1".equals(MouldStatusCominfo.getStatus("message"))||"".equals(MouldStatusCominfo.getStatus("message"))) {%>
						<option value=7><%=SystemEnv.getHtmlLabelName(71,user.getLanguage())%></option>
						<%} %>
						</select>
					</td>
					<td nowrap style="padding:0 3px 0 5px"><input name="searchvalue" size="14" class="InputStyle_1" onMouseOver="this.select()"></td>
					<td nowrap>
					<img alt="<%=SystemEnv.getHtmlLabelName(16646,user.getLanguage())%>" src="/images_face/ecologyFace_1/search_dot_wev8.gif" border="0" onclick="search.submit()" style="CURSOR:HAND;vertical-align:middle">&nbsp;
					</td>
<!--add by fanggsh 20081203 for TD9286 begin-->

<%

if(isSignInOrSignOut.equals("1")&&isWorkday&&!isSyadmin){
    String currentYearMonthDate=currentyear+"-"+currentmonth+"-"+currentdate;

	RecordSet.executeSql("SELECT 1 FROM HrmScheduleSign where userId="+user.getUID()+" and  userType='"+user.getLogintype()+"' and signDate='"+currentYearMonthDate+"' and signType='1'  and isInCom='1'");
	if(RecordSet.next()){
		signType="2";
	}

%>
					<td nowrap>
					  <span id=signInOrSignOutSpan>
					      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						      <BUTTON onclick="signInOrSignOut(<%=signType%>)">
							  <div   style="cursor:hand;color:blue">
<%
if(signType.equals("1")){
	out.println(SystemEnv.getHtmlLabelName(20032,user.getLanguage()));
}else{
	out.println(SystemEnv.getHtmlLabelName(20033,user.getLanguage()));
}
%>						      </div>
                              </BUTTON>

					  </span>
					</td>
<%
}
%>
<!--add by fanggsh 20081203 for TD9286 end-->

				</tr>
				</table>
			</td>
		<td align="right" style="">
		<table height=100% border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td width=23 align="center">
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Home_wev8.gif" onclick="javascript:goUrl('/homepage/HomepageRedirect.jsp')" title="<%=SystemEnv.getHtmlLabelName(1500,user.getLanguage())%>"></td></tr></table><!--首页-->
			</td>
			
			<!-- 页面模板选择开始-->
			<%!
				private Map getProperties(String propertyPath) {
					Map skinConfig = new HashMap();
					
					Properties config = new Properties();
					try {
						config.load(new FileInputStream(propertyPath));
					} catch (Exception e) {
						e.printStackTrace();
						return skinConfig;
					} 
					
					Enumeration enumeration = config.propertyNames();
					
					while (enumeration.hasMoreElements()) {
						String key = (String)enumeration.nextElement();
						String value = config.getProperty(key, "");
						skinConfig.put(key, value);
					}
					return skinConfig;
				}
			%>
			<%
				weaver.systeminfo.template.UserTemplate  userTemplate = new weaver.systeminfo.template.UserTemplate();
				userTemplate.getTemplateByUID(user.getUID(),user.getUserSubCompany1());
	
				int extendtempletvalueid = userTemplate.getExtendtempletvalueid();
				rsExtend.executeSql("select * from extandHpThemeItem where extandHpThemeId=(select id from extandHpTheme where id=" + extendtempletvalueid + ") and isopen=1");
				
			%>
		    <td style="width:10;height:28px;"></td>
            <td style="width:100;height:28px;display:none" align="left" valign="middle" id="templateSelect" >
				<select id="templateSelect" name="templateSelect" onchange="templatechange(this);" >
				 <option  value=/main.jsp align="center" selected>-<%=SystemEnv.getHtmlLabelName(83803,user.getLanguage())%>-</option>
				 <%
				   while(rsExtend.next()){
					   String theme = Util.null2String(rsExtend.getString("theme"));
					   String skin = Util.null2String(rsExtend.getString("skin"));
					   String themeUrl="/wui/theme/ecology7/page/skinSetting.jsp?skin="+skin+"&theme=" +theme;
					   String projectPath = this.getServletConfig().getServletContext().getRealPath("/");
						if (projectPath.lastIndexOf("/") != (projectPath.length() - 1) && projectPath.lastIndexOf("\\") != (projectPath.length() - 1)) {
							projectPath += "/";
						}
					   Map skinConfig = getProperties(projectPath + "wui/theme/" + theme + "/skins/" + skin + "/config.properties");
					   String name = (String)skinConfig.get("name");
				 %>
				   <option  value="<%=themeUrl%>" align="center" >&nbsp;&nbsp;<%=theme %>-<%=name %></option>
				 <%}%>

			</select>
				  
			<div id="warmPrompt" style="filter:alpha(opacity=0);position:absolute;width:223px;z-index:1;">
				<span id="toolbarMoreBlockTop" style="overflow:hidden;width:223px;background:url(/wui/theme/ecologyBasic/page/images/warmPrompt/warmPromptTopL_wev8.png) no-repeat;height:10px;"></span>
				<TABLE cellpadding="0" cellspacing="0" align="center" style="margin:0;" width="100%" style="background:url(/wui/theme/ecologyBasic/page/images/warmPrompt/warmPromptCenter_wev8.png) repeat-y;"">
					<tr>
						<td width="213px">
						</td>
						<td width="15px" height="11px">
						</td>
					</tr>
					<tr>
						<td colspan="2" style="padding-left:10px;padding-right:5px;color:#0b5367;">
							<span>
								<b><%=SystemEnv.getHtmlLabelName(81500,user.getLanguage())%></b>：<%=SystemEnv.getHtmlLabelName(83805,user.getLanguage())%> 
								<span style="display:block;overflow:hidden;height:5px;"></span>
								<span style="display:block;float:left;">
								<input type="checkbox" name="warmPrompt" value="1"><span style="color:#2295aa;"><%=SystemEnv.getHtmlLabelName(83806,user.getLanguage())%> </span>
								</span>	
								<span style="width:46px;height:21px;position:relative;right:10px;display:block;float:right;padding-top:2px;cursor:hand;background:url(/wui/theme/ecologyBasic/page/images/warmPrompt/closeBg_wev8.png) no-repeat;text-align:center;" onclick="closeWarmPrompt();">
									<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>
								</span>										
							</span>
							
						</td>
						
					</tr>
				</TABLE>
				<TABLE cellpadding="0px" cellspacing="0px" height="10px" width="100%" style=""><tr><td height="10px"><span class="toolbarBgSpan" style="display:block;overflow:hidden;width:100%;height:10px;background:url(/wui/theme/ecologyBasic/page/images/warmPrompt/warmPromptBottom_wev8.png) no-repeat;"></span></td></tr></TABLE>
			</div>
			<script type="text/javascript">
				$(document).ready(function() {
					$("#warmPrompt").css("top", $("#templateSelect").offset().top + 26);
    				$("#warmPrompt").css("left", $("#templateSelect").offset().left + 20);
					
			        $("#warmPrompt").hide();
			        //提示
			        var stwflg = getCookie("<%=user.getLoginid() %>6WarmPrompt");
			        if (stwflg == undefined || stwflg == "" || stwflg != "true") {
			        	setTimeout(showWarmPrompt, 2500);
			        }
				});
				
				function toolbarMore() {
					$("#toolbarMore").toggle();
				}
				
				function closeWarmPrompt() {
					addCookie("<%=user.getLoginid() %>6WarmPrompt", $("input[name='warmPrompt']").attr("checked"), 720);
					$("#warmPrompt").hide();
				}
				
				function showWarmPrompt() {
					$("#warmPrompt").css("filter", "");
					$("#warmPrompt").show();
				}
				
			    function addCookie(objName,objValue,objHours){//添加cookie
				    var str = objName + "=" + escape(objValue);
				    if(objHours > 0){//为0时不设定过期时间，浏览器关闭时cookie自动消失
					    var date = new Date();
					    var ms = 10*365*24*60*60*1000;
					    date.setTime(date.getTime() + ms);
					    str += "; expires=" + date.toGMTString();
			    	}
			    	document.cookie = str;
			    }
			  
			   function getCookie(objName){//获取指定名称的cookie的值
			       var arrStr = document.cookie.split("; ");
				   for(var i = 0;i < arrStr.length;i ++){
					   var temp = arrStr[i].split("=");
					   if(temp[0] == objName) return unescape(temp[1]);
				   }
			   }
			   
			   function templatechange(obj){
				  if (obj.value=="mobile"){
						window.open('/interface/Entrance.jsp?id=webmobile','','width=300,height=350,top=100,left=450,scrollbars=yes');
					    obj.selectedIndex=0;
				   }else{
					    window.location =obj.value;
				   }
				}
			</script>
			
		</td>
         <!-- 页面模板选择结束-->
			<td width=10 align="center">
				<img src="/images_face/ecologyFace_1/VLine_1_wev8.gif" border=0>
			</td>
			
			<%
			if((isHaveMessager&&!userid.equals("1")&&isHaveMessagerRight==1)||isHaveEMessager){ 
			%>
				<td width="23" align="center">
					<!--  <div id="divMessagerState"/>-->
					<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';" id="tdMessageState"></td></tr></table><!--首页-->
				</td>	
				<!-- 		
				<td width=10 align="center">
					<img src="/images_face/ecologyFace_1/VLine_1_wev8.gif" border=0>
				</td>
				 -->
			<%}%>
			<%
			  if(checkchattemp){
			%>
			<td width=23 align="center">
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/msn_wev8.gif" onclick="javascript:showHrmChatTree('')" title="<%=SystemEnv.getHtmlLabelName(23525,user.getLanguage())%>"></td></tr></table><!---->
			</td>
			<%}%>
			<%if("1".equals(MouldStatusCominfo.getStatus("scheme"))||"".equals(MouldStatusCominfo.getStatus("scheme"))){ %>
            <td width=23 align="center">
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Plan_wev8.gif" onclick="javascript:goUrl('/workplan/data/WorkPlan.jsp?resourceid=<%=user.getUID()%>')" title="<%=SystemEnv.getHtmlLabelName(18480,user.getLanguage())%>"></td></tr></table><!--我的计划-->
			</td>
			<%}%>
			<%if("1".equals(MouldStatusCominfo.getStatus("message"))||"".equals(MouldStatusCominfo.getStatus("message"))){ %>
			<td width=23 align="center">
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Mail_wev8.gif" onclick="javascript:goUrl('/email/MailFrame.jsp?act=add')" title="<%=SystemEnv.getHtmlLabelName(2029,user.getLanguage())%>"></td></tr></table><!--新建邮件-->
			</td>
	    <%}%>
			<%if("1".equals(MouldStatusCominfo.getStatus("doc"))||"".equals(MouldStatusCominfo.getStatus("doc"))){ %>
        <td width=23 align="center">
				 <table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Doc_wev8.gif" onclick="javascript:goUrl('/docs/docs/DocList.jsp')" title="<%=SystemEnv.getHtmlLabelName(1986,user.getLanguage())%>"></td></tr></table><!--新建文档-->
			  </td>
			<%} %>
			<%if("1".equals(MouldStatusCominfo.getStatus("workflow"))||"".equals(MouldStatusCominfo.getStatus("workflow"))){ %>
	      <td width=23 align="center">
					<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/WorkFlow_wev8.gif" onclick="goUrl('/workflow/request/RequestType.jsp?needPopupNewPage=true')" title="<%=SystemEnv.getHtmlLabelName(16392,user.getLanguage())%>"></td></tr></table><!--新建流程-->
				</td>
			<%} %>	
			<%if(isgoveproj==0){%>
            <%if(software.equals("ALL") || software.equals("CRM")){%>
      <%if("1".equals(MouldStatusCominfo.getStatus("crm"))||"".equals(MouldStatusCominfo.getStatus("crm"))){ %>      
      <td width=23 align="center">
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/CRM_wev8.gif" onclick="javascript:goUrl('/CRM/data/AddCustomerExist.jsp')" title="<%=SystemEnv.getHtmlLabelName(15006,user.getLanguage())%>"></td></tr></table><!---->
			</td>
			<%}%>
			<%if("1".equals(MouldStatusCominfo.getStatus("proj"))||"".equals(MouldStatusCominfo.getStatus("proj"))){ %>
            <td width=23 align="center">
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/PRJ_wev8.gif" onclick="javascript:goUrl('/proj/data/AddProject.jsp')" title="<%=SystemEnv.getHtmlLabelName(15007,user.getLanguage())%>"></td></tr></table><!---->
			</td>
			<%}%>
            <%}%>
			<%}%>
			<%if("1".equals(MouldStatusCominfo.getStatus("meeting"))||"".equals(MouldStatusCominfo.getStatus("meeting"))){ %>
            <td width=23 align="center">
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Meeting_wev8.gif" onclick="javascript:goUrl('/meeting/data/AddMeeting.jsp')" title="<%=SystemEnv.getHtmlLabelName(15008,user.getLanguage())%>"></td></tr></table><!---->
			</td>
			<%}%>			
			<td width=23 align="center">
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Org_wev8.gif" onclick="javascript:goUrl('/org/OrgChart.jsp?charttype=H')" title="<%=SystemEnv.getHtmlLabelName(16455,user.getLanguage())%>"></td></tr></table><!--组织结构-->
			</td>		
			<td width=23 align="center">
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Plugin_wev8.gif" onclick="javascript:goopenWindow('/weaverplugin/PluginMaintenance.jsp')" title="<%=SystemEnv.getHtmlLabelName(7171,user.getLanguage())%>"></td></tr></table><!--插件-->
			</td>
         <%if(rtxClient.isValidOfRTX()){
			 RTXConfig rtxConfig = new RTXConfig();
			 String RtxOrElinkType = (Util.null2String(rtxConfig.getPorp(RTXConfig.RtxOrElinkType))).toUpperCase();
			 if("ELINK".equals(RtxOrElinkType)  && !RTXConfig.isSystemUser(user.getLoginid())){ 
		 %>
			<td width=23 align="center">
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/favicon_wev8.jpg" onclick="javascript:openEimClient()" title="打开OCS客户端"></td></tr></table><!---->
			</td>
			<%} else if(!RTXConfig.isSystemUser(user.getLoginid())){%>
			<td width=23 align="center">
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/rtx_wev8.gif" onclick="javascript:openRtxClient()" title="打开RTX客户端"></td></tr></table><!---->
			</td>
			
			<%}%>
         <%}%>
         <td width=23 align="center">
				<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Version_wev8.gif" onclick="javascript:showVersion()" title="<%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%>"></td></tr></table><!--版本-->
				
			</td>
			</tr>
		</table>
		</td>
		<td width="10"></td>
		</tr>
		</table>
		</td>
	</tr>
	</table>
</td>
</tr>

<tr><td style="height:1px;background-color:white"></td></tr>
<tr>
	<td>
		<table width="100%"  height="100%" border="0" cellspacing="0" cellpadding="0" id="mainTable" name="mainTable">
		<tr>
		<!--
		   <td width="160" valign="top" id="leftMenu" name="leftMenu" style="DISPLAY:''">
				<iframe id="leftFrame" name="leftFrame" BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE height="100%" width="100%" scrolling="NO" src="left.jsp" target="mainFrame">
				</iframe>&nbsp;
			</td>
			<td>
				<iframe id="mainFrame" name="mainFrame" BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE height="100%" width="100%" SCROLLING=yes SRC="<%=initsrcpage%>"></iframe>&nbsp;
			</td>
		-->
		<td style="padding-top:3px;position:relative"><iframe id="leftFrame" name="leftFrame" BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE height="100%" width="100%" scrolling="NO" src="leftFrame.jsp" onload="goMainFrame(this)"/></td>
		</tr>
		</table>
	</td>
</tr>
</table>
<%
if(checkchattemp){
%>
<iframe name="hrmChat" src="/chat/chat.jsp" width="50px" height="50px"></iframe>  
<%}%>
<%
    HrmUserSettingHandler handler = new HrmUserSettingHandler();
    HrmUserSetting setting = handler.getSetting(user.getUID());

	boolean rtxOnload = setting.isRtxOnload();

    if(rtxClient.isValidOfRTX() && rtxOnload){
		String rtxorelinkurl = "";
		RTXConfig rtxConfig = new RTXConfig();
		String RtxOrElinkType = (Util.null2String(rtxConfig.getPorp(RTXConfig.RtxOrElinkType))).toUpperCase();
		if("ELINK".equals(RtxOrElinkType)){ 
			rtxorelinkurl = "EimClientOpen.jsp";
		} else {
			rtxorelinkurl = "RTXClientOpen.jsp";
		}
%>
<iframe name="rtxClient" src="<%=rtxorelinkurl%>" style="display:none"></iframe>
<%  }else{                                                                       %>
<iframe name="rtxClient" src="" style="display:none"></iframe>
<%  }                                                                            %>
<script>
document.oncontextmenu=""
search.searchvalue.oncontextmenu=showRightClickMenu1

function showRightClickMenu1(){
	var o = document.getElementById("leftFrame").contentWindow.document.getElementById("mainFrame");
    if(o.workSpaceLeft!=null)
		o.workSpaceLeft.rightMenu.style.visibility="hidden";
    if(o.workSpaceInfo!=null)
        o.workSpaceInfo.rightMenu.style.visibility="hidden";
    if(o.workSpaceRight!=null)
		o.workSpaceRight.rightMenu.style.visibility="hidden";
    if(o.workplanLeft!=null)
        o.workplanLeft.rightMenu.style.visibility="hidden";
    if(o.workplanRight!=null)
		o.workplanRight.rightMenu.style.visibility="hidden";
        showRightClickMenu();
}
</script>
<div id='divShowSignInfo' style='background:#FFFFFF;padding:0px;width:100%;display:none' valign='top'>
</div>

<div id='message_Div' style='display:none'>
</div>
</body>
<!--文档弹出窗口-- 开始-->
<% 
String docsid = "";
String pop_width = "";
String pop_hight = "";
String is_popnum = "";
String popupsql = "select docid,pop_num,pop_hight,pop_width,is_popnum from DocDetail  t1, "+tables+"  t2,DocPopUpInfo t3 where t1.id=t2.sourceid and t1.id = t3.docid and (t1.ishistory is null or t1.ishistory = 0) and (t3.pop_startdate <= '"+CurrentDate+"' and t3.pop_enddate >= '"+CurrentDate+"') and pop_num > is_popnum";
RecordSet.executeSql(popupsql); 
while(RecordSet.next()){ 
docsid = RecordSet.getString("docid");
pop_hight = RecordSet.getString("pop_hight");
pop_width = RecordSet.getString("pop_width");
is_popnum = RecordSet.getString("is_popnum");
if("".equals(pop_hight)) pop_hight = "500";
if("".equals(pop_width)) pop_width = "600";
%>
<script language=javascript> 
  var is_popnum = <%=is_popnum%>;
  var docsid = <%=docsid%>;
  var pop_hight = <%=pop_hight%>;
  var pop_width = <%=pop_width%>;
  var docid_num = docsid +"_"+ is_popnum;
  window.open("/docs/docs/DocDsp.jsp?popnum="+docid_num,"","height="+pop_hight+",width="+pop_width+",scrollbars,resizable=yes,status=yes,Minimize=yes,Maximize=yes");
</script> 
<%}%>
<!--文档弹出窗口-- 结束-->
<SCRIPT language=javascript>
function openEimClient(){
    document.all("rtxClient").src="EimClientOpen.jsp";
}

function openRtxClient(){
    document.all("rtxClient").src="RTXClientOpen.jsp?notify=true";
}

function mnToggleleft(){
	var o = document.getElementById("leftFrame").contentWindow.document.frames["mainFrameSet"];
	if(o.cols=="0,*"){
		var iMenuWidth=134;
		var iLeftMenuFrameWidth=Cookies.get("iLeftMenuFrameWidth");	
		if(iLeftMenuFrameWidth!=null) iMenuWidth=iLeftMenuFrameWidth;
		try{
			if(o.firstChild.contentWindow.document.getElementById("divMenuBox")){
				o.firstChild.contentWindow.document.getElementById("divMenuBox").style.display = "block";
			}
			
			o.cols = iMenuWidth+",*";

			document.getElementById("leftFrame").contentWindow.document.getElementById("mainFrame").noResize = false;
			document.getElementById("leftFrame").contentWindow.document.getElementById("LeftMenuFrame").noResize = false;
			
			LeftHideShow.title = "<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>";//隐藏
		}catch(e){
			window.status = e;
		}		
	}else{		
		try{
			if(o.firstChild.contentWindow.document.getElementById("divMenuBox")){
				o.firstChild.contentWindow.document.getElementById("divMenuBox").style.display = "none";
			}
			o.cols = "0,*";
			document.getElementById("leftFrame").contentWindow.document.getElementById("mainFrame").noResize = true;
			document.getElementById("leftFrame").contentWindow.document.getElementById("LeftMenuFrame").noResize = true;
			
			LeftHideShow.title = "<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>";//显示
			
		}catch(e){
			window.status = e;
		}
		
	}
	//add by lupeng 2004.04.27 for TD315
	//leftFrame.location.reload();//重新load左边按钮
	//end
}

function mnToggletop(){
	if(topMenuLogo.style.display == ""){
		if(document.getElementById("logoBottom")!=null){
			logoBottom.style.display = "none";
		}
		topMenuLogo.style.display = "none";
		topMenu.style.height = "28px";
		TopHideShow.title = "<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>";//显示

	}
	else{
		if(document.getElementById("logoBottom")!=null){
			logoBottom.style.display = "block";
		}
		topMenuLogo.style.display = "";
		TopHideShow.title = "<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>";//隐藏
	}
	//leftFrame.location.reload();//重新load左边按钮
}

function newSelect()	//新建跳转
{
	var sendRedirect  = document.all("NewBuildSelect").value ;
	if (sendRedirect!="") mainFrame.location.href = sendRedirect ;
}

function favouriteSelect() //收藏夹跳转
{
	var sendRedirect  = document.all("FavouriteSelect").value ;
	if (sendRedirect!="") mainFrame.location.href = sendRedirect ;
}

function toolBarBack() //后退
{
	window.history.back();
}

function toolBarForward() //前进
{
	window.history.forward();
}
var begintimeresh = new Date().getTime();
function toolBarRefresh(){
	try{
		var endtimeresh = new Date().getTime();
		var timesnow = 15 -Math.round((endtimeresh-begintimeresh)/1000);
		if((endtimeresh-begintimeresh) < 15000 && timesnow > 0){
				alert( "<%=SystemEnv.getHtmlLabelName(26046,user.getLanguage())%>"+timesnow+"<%=SystemEnv.getHtmlLabelName(26047,user.getLanguage())%>");
			//alert("");
		}else{
			document.getElementById("leftFrame").contentWindow.document.getElementById("mainFrame").contentWindow.document.location.reload();
			begintimeresh = new Date().getTime();

		}
	}catch(exception){}
}

function toolBarStop()
{
    document.getElementById("leftFrame").contentWindow.document.frames[1].document.execCommand('Stop')
}

function toolBarFavourite() //收藏夹
{
	if( typeof (document.getElementById("leftFrame").contentWindow.document.frames[1].contentWindow) == undefined );
	return false;
	var o = document.getElementById("leftFrame").contentWindow.document.frames[1].document.all("BacoAddFavorite");
	if(o!=null)	o.click();
	//杨国生2003-09-26 由于收藏无法直接得到mainFrame中的页面名称，所以采用折衷办法，把TopTile.jsp中的原收藏按钮类型改为hidden,然后直接调用该按钮的onclick()事件。
}

function toolBarPrint() //打印
{
    parent.frames["leftFrame"].frames["mainFrame"].focus();
    parent.frames["leftFrame"].frames["mainFrame"].print();
}

function goUrl(url){
	document.getElementById("leftFrame").contentWindow.document.getElementById("mainFrame").src = url;
}

var chatwindforward;


function goUrlPopup(o){
	var url = o.getAttribute("url");
	parent.document.getElementById("leftFrame").contentWindow.document.getElementById("mainFrame").src = url;
}
function goopenWindow(url){
  var chasm = screen.availWidth;
  var mount = screen.availHeight;
  if(chasm<650) chasm=650;
  if(mount<700) mount=700;
  window.open(url,"PluginCheck","scrollbars=yes,resizable=no,width=690,Height=650,top="+(mount-700)/2+",left="+(chasm-650)/2);
}
function isConfirm(LabelStr){
if(!confirm(LabelStr)){
   return false;
}
   return true;
}

function toolBarLogOut() //退出
{
	var LabelStr= "<%=SystemEnv.getHtmlLabelName(16628,user.getLanguage())%>" ;
	<%/* TD4406 modified by hubo,2006-07-10 */%>
	//if(isConfirm(LabelStr)) location.href="/login/Logout.jsp";
	<%/* TD5713 modified by fanggsh,2007-01-09 */%>
	if(isConfirm(LabelStr)){ 
		//mainBody.onbeforeunload=null;
		mainBody.onunload=null;
		location.href="/login/Logout.jsp";
	}

}


var sRepeat=null;
var oPopup;
try{
    oPopup = window.createPopup();
}catch(e){}
function GetPopupCssText()
{
	var styles = document.styleSheets;
	var csstext = "";
	for(var i=0; i<styles.length; i++)
	{
		if (styles[i].id == "popupmanager")
			csstext += styles[i].cssText;
	}
	return csstext;
}
function mouseout(){
  try{
	var x = oPopup.document.parentWindow.event.clientX;
	var y = oPopup.document.parentWindow.event.clientY
	if(x<0 || y<0) oPopup.hide();
	sRepeat = null;
  }catch(e){}	
}

function doScrollerIE(dir, src, amount) {	
 try{
	if (amount==null) {amount=10}	
	if (dir=="up"){
		oPopup.document.all[src].scrollTop-=amount;
	}else{
		oPopup.document.all[src].scrollTop+=amount;
	}
	if (sRepeat==null) {sRepeat = setInterval("doScrollerIE('"+dir+"','" + src + "'," + amount + ")",150)}	
	return false;
  }catch(e){}	
}

function doClearInterval(){
	clearInterval(sRepeat);
}

function ajaxInit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}

function signInOrSignOut(signType){
	if(signType==1){
		signInOrSignOutSpan.innerHTML='&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<BUTTON><div   style="color:blue"><%=SystemEnv.getHtmlLabelName(20032,user.getLanguage())%></div></BUTTON>';
	}else{
		signInOrSignOutSpan.innerHTML='&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<BUTTON><div   style="color:blue"><%=SystemEnv.getHtmlLabelName(20033,user.getLanguage())%></div></BUTTON>';
	}

    var ajax=ajaxInit();
    ajax.open("POST", "/hrm/schedule/HrmScheduleSignXMLHTTP.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("signType="+signType);
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
            showPromptForShowSignInfo(ajax.responseText);
			signInOrSignOutSpan.innerHTML='&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<BUTTON onclick="signInOrSignOut(2)"><div   style="cursor:hand;color:blue"><%=SystemEnv.getHtmlLabelName(20033,user.getLanguage())%></div>';

            }catch(e){
			
			}

        }
    }

}

var showTableDiv  = document.getElementById('divShowSignInfo');
var oIframe = document.createElement('iframe');


//type  1:显示提示信息
//      2:显示返回的历史动态情况信息
function showPromptForShowSignInfo(content){

    //showTableDiv.style.display='';

    var message_Div = document.getElementById('message_Div');
     message_Div.id="message_Div";
     message_Div.className="xTable_message";
     showTableDiv.appendChild(message_Div);

     message_Div.style.display="inline";
     message_Div.innerHTML=content;

	 pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
     pLeft= document.body.offsetWidth/2-250;

     message_Div.style.position="absolute"
     message_Div.style.posTop=pTop;
     message_Div.style.posLeft=pLeft;
     message_Div.style.zIndex=1002;


     oIframe.id = 'HelpFrame';
     showTableDiv.appendChild(oIframe);
     oIframe.frameborder = 0;
     oIframe.style.position = 'absolute';
     oIframe.style.top = pTop;
     oIframe.style.left = pLeft;
     oIframe.style.zIndex = message_Div.style.zIndex - 1;
     oIframe.style.width = parseInt(message_Div.offsetWidth);
     oIframe.style.height = parseInt(message_Div.offsetHeight);
     oIframe.style.display = 'block';

     showTableDiv.style.posTop=pTop;
     showTableDiv.style.posLeft=pLeft;
     showTableDiv.style.display='';
}

function onCloseDivShowSignInfo(){
	divShowSignInfo.style.display='none';
	message_Div.style.display='none';
	document.all.HelpFrame.style.display='none'
}
var firstTime = new Date().getTime();
function onCheckTime(obj){
	window.onbeforeunload=function(){	}
	window.location = "/login/IdentityShift.jsp?shiftid="+obj.value;
}
function setAccountSelect(){
	var nowTime = new Date().getTime();
	if((nowTime-firstTime) < 10000){
		setTimeout(function(){setAccountSelect();},1000);
	}else{
		try{
			document.getElementById("accountSelect").disabled = false;
		}catch(e){}
	}
}
setAccountSelect();
</SCRIPT>
<script language="vbs">
sub showVersion()
	about=window.showModalDialog("/systeminfo/version.jsp",,"dialogHeight:376px;dialogwidth:466px;help:no")
end sub
</script>

<script language=javascript>

<%if(isSignInOrSignOut.equals("1")&&isWorkday&&!isSyadmin&&"1".equals(signType)){%>
if(confirm("<%=SystemEnv.getHtmlLabelName(21415,user.getLanguage())%>")){
	signInOrSignOut(<%=signType%>);
}
<%}%>
</script> 

</html>
<script language="javascript" src="/js/Cookies_wev8.js"></script>

<script language=javascript>
var FTime = new Date().getTime();
         
function  document.onkeydown(){  
	  try{
		  var STime = new Date().getTime();  
		  var Rematimenow = 15 -Math.round((STime-FTime)/1000);
		     if   ((event.keyCode==116)||(event.ctrlKey && event.keyCode==82)){   //Ctrl+R、禁止用F5键 
		  	   if((STime-FTime) < 15000 && Rematimenow > 0){
		  		 alert( "<%=SystemEnv.getHtmlLabelName(26046,user.getLanguage())%>"+Rematimenow+"<%=SystemEnv.getHtmlLabelName(26047,user.getLanguage())%>");
		             event.keyCode  =  0;          
		             event.cancelBubble   =  true;     
		           return   false;   
		      	   }        
		   		 } 
	 }catch(exception){}
}
</script>
<script language="javascript">
//定时接收邮件
window.setInterval(function (){
	jQuery.post("/email/MailTimingDateReceiveOperation.jsp?"+new Date().getTime());
  },1000 * 60 * 5);
</script>
<%
if(isHaveEMessager){
%>
	<%@ include file="/messager/joinEMessage.jsp"%>
<%
}else{
	if((user.getUID()!=1)&&isHaveMessagerRight==1){ 
%>
	<%@ include file="/messager/join.jsp" %>
<%}}%>

<%} %>
