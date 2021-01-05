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
<%@ page import="weaver.hrm.report.schedulediff.HrmScheduleDiffUtil"%>
<%@page import="weaver.hrm.common.Tools"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/systeminfo/template/templateCss.jsp" %>
<%@ include file="/docs/common.jsp" %>
<%@ include file="/times.jsp" %>
<jsp:useBean id="rspop" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rspopuser" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rtxClient" class="weaver.rtx.RTXClientCom" scope="page" />
<jsp:useBean id="autoPlan" class="weaver.hrm.performance.targetplan.AutoPlan" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="session" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="PluginUserCheck" class="weaver.license.PluginUserCheck" scope="page" />
<jsp:useBean id="MouldStatusCominfo" class="weaver.systeminfo.MouldStatusCominfo" scope="page" />
<jsp:useBean id="templateBean" class="weaver.systeminfo.template.UserTemplate" scope="page" />
<jsp:useBean id="signRs" class="weaver.conn.RecordSet" scope="page"/>
<%@ page import="weaver.systeminfo.setting.HrmUserSettingComInfo" %>
<%@page import="weaver.social.service.SocialIMService"%>
<jsp:useBean id="VotingManager" class="weaver.voting.VotingManager" scope="page" />	
<%
Map pageConfigKv = getPageConfigInfo(session, user);

String logoTop = "";
String logoBtm = "";
String islock = (String)pageConfigKv.get("islock");
String bodyBg = Util.null2String((String)pageConfigKv.get("bodyBg"));
String topBgImage = Util.null2String((String)pageConfigKv.get("topBgImage"));
String toolbarBgColor = Util.null2String((String)pageConfigKv.get("toolbarBgColor"));

templateBean.getTemplateByUID(user.getUID(),user.getUserSubCompany1());
logoTop =  templateBean.getLogo();
logoBtm = templateBean.getLogoBottom();

RecordSet.execute("SELECT templateid FROM SystemTemplateSubComp WHERE subcompanyid="+user.getUserSubCompany1()+"");
boolean hasSubTemplate = false;//分部有模板则为指定了模板
if(RecordSet.next() && RecordSet.getString("templateid") != null && !"".equals(RecordSet.getString("templateid")) && !"-1".equals(RecordSet.getString("templateid"))){
	hasSubTemplate = true;
}
//判断是否有微搜功能
boolean microSearch=weaver.fullsearch.util.RmiConfig.isOpenMicroSearch();

if (bodyBg.equals("")) {
	bodyBg = "/wui/theme/ecologyBasic/page/images/bodyBg_wev8.png";
}

if (topBgImage.equals("")) {
	topBgImage = "/wui/theme/ecologyBasic/page/images/headBg_wev8.jpg";
}

if (toolbarBgColor.equals("")) {
	toolbarBgColor = "/wui/theme/ecologyBasic/page/images/toolbarBg_wev8.png";
}

%>
<!--网上调查部分-- 开始No blank -->
<SCRIPT LANGUAGE="javascript">
var eBirth = false;//判断是否有人过生日
</SCRIPT>
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
<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
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

	//------------------------------------
	//签到部分 Start
	//------------------------------------
	String[] signInfo = HrmScheduleDiffUtil.getSignInfo(user);
	boolean isNeedSign = Boolean.parseBoolean(signInfo[0]);
	String sign_flag = signInfo[1];
	String signType = signInfo[2];
	//------------------------------------
	//签到部分 End
	//------------------------------------
%>
	<SCRIPT LANGUAGE="javascript">
	var voteids = "";//网上调查的id
	var voteshows = "";//网上调查是否弹出
	var votefores = "";//网上调查---> 强制调查
	</SCRIPT>


<%

    HrmUserSettingComInfo userSetting=new HrmUserSettingComInfo();
    String belongtoshow = userSetting.getBelongtoshowByUserId(user.getUID()+""); 
	String belongtoids = user.getBelongtoids();
	String account_type = user.getAccount_type();


boolean isSys=true;
RecordSet.executeSql("select 1 from hrmresource where id="+user.getUID());
if(RecordSet.next()){
	isSys=false;
}	

Date votingnewdate = new Date() ;
long votingdatetime = votingnewdate.getTime() ;
Timestamp votingtimestamp = new Timestamp(votingdatetime) ;
String votingCurrentDate = (votingtimestamp.toString()).substring(0,4) + "-" + (votingtimestamp.toString()).substring(5,7) + "-" +(votingtimestamp.toString()).substring(8,10);
String votingCurrentTime = (votingtimestamp.toString()).substring(11,13) + ":" + (votingtimestamp.toString()).substring(14,16);
String votingsql=""; 
if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")){
belongtoids +=","+user.getUID();

votingsql="select distinct t1.id,t1.autoshowvote,t1.forcevote from voting t1 where t1.status=1 "+ 
        " and (t1.beginDate<'"+votingCurrentDate+"' or (t1.beginDate='"+votingCurrentDate+"' and (t1.beginTime is null or t1.beginTime='' or t1.beginTime<='"+votingCurrentTime+"'))) "; 
	votingsql +=" and (";
	
  String[] votingshareids=Util.TokenizerString2(belongtoids,",");
	for(int i=0;i<votingshareids.length;i++){
		User tmptUser=VotingManager.getUser(Util.getIntValue(votingshareids[i]));
		String seclevel=tmptUser.getSeclevel();
		int subcompany1=tmptUser.getUserSubCompany1();
		int department=tmptUser.getUserDepartment();
		String  jobtitles=tmptUser.getJobtitle();
	     	
		String tmptsubcompanyid=subcompany1+"";
		String tmptdepartment=department+"";
		RecordSet.executeSql("select subcompanyid,departmentid from HrmResourceVirtual where resourceid="+tmptUser.getUID());
		while(RecordSet.next()){
			tmptsubcompanyid +=","+Util.null2String(RecordSet.getString("subcompanyid"));
			tmptdepartment +=","+Util.null2String(RecordSet.getString("departmentid"));
		}
		
		if(i==0){
			votingsql += " ( id not in (select votingid from VotingRemark where resourceid="+tmptUser.getUID()+")" +
			" and id in(select votingid from VotingShare t"+i+" where ((sharetype=1 and resourceid="+tmptUser.getUID()+") or (sharetype=2 and subcompanyid in("+tmptsubcompanyid+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=3 and departmentid in("+tmptdepartment+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=5 and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=6 and ( (joblevel=0 and jobtitles='"+jobtitles+"' ) or (joblevel=1 and jobtitles='"+jobtitles+"' and jobsubcompany in("+tmptsubcompanyid+")) or (joblevel=2 and jobtitles='"+jobtitles+"' and jobdepartment in("+tmptdepartment+") )) ) or (sharetype=4 and exists(select 1 from HrmRoleMembers where roleid=t"+i+".roleid and rolelevel>=t"+i+".rolelevel and resourceid="+tmptUser.getUID()+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) )) )";	
		} else {
			votingsql += " or ( id not in (select votingid from VotingRemark where resourceid="+tmptUser.getUID()+")" +
			" and id in(select votingid from VotingShare t"+i+" where ((sharetype=1 and resourceid="+tmptUser.getUID()+") or (sharetype=2 and subcompanyid in("+tmptsubcompanyid+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=3 and departmentid in("+tmptdepartment+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=5 and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+"))  or (sharetype=6 and ( (joblevel=0 and jobtitles='"+jobtitles+"' ) or (joblevel=1 and jobtitles='"+jobtitles+"' and jobsubcompany in("+tmptsubcompanyid+")) or (joblevel=2 and jobtitles='"+jobtitles+"' and jobdepartment in("+tmptdepartment+") )) ) or (sharetype=4 and exists(select 1 from HrmRoleMembers where roleid=t"+i+".roleid and rolelevel>=t"+i+".rolelevel and resourceid="+tmptUser.getUID()+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) )) )";	
		}
		
		  		
	}
	votingsql +=")";

}else{
	String seclevel=user.getSeclevel();
	int subcompany1=user.getUserSubCompany1();
	int department=user.getUserDepartment();
	String  jobtitles=user.getJobtitle();
	  		
	String tmptsubcompanyid=subcompany1+"";
	String tmptdepartment=department+"";
	RecordSet.executeSql("select subcompanyid,departmentid from HrmResourceVirtual where resourceid="+user.getUID());
	while(RecordSet.next()){
		tmptsubcompanyid +=","+Util.null2String(RecordSet.getString("subcompanyid"));
		tmptdepartment +=","+Util.null2String(RecordSet.getString("departmentid"));
	}
	
	votingsql="select distinct t1.id,t1.autoshowvote,t1.forcevote from voting t1 where t1.status=1 "+
	" and t1.id not in (select distinct votingid from VotingRemark where resourceid ="+user.getUID()+")"+
	" and (t1.beginDate<'"+votingCurrentDate+"' or (t1.beginDate='"+votingCurrentDate+"' and (t1.beginTime is null or t1.beginTime='' or t1.beginTime<='"+votingCurrentTime+"')))"+
	" and t1.id in(select votingid from VotingShare t where ((sharetype=1 and resourceid="+user.getUID()+") or (sharetype=2 and subcompanyid in("+tmptsubcompanyid+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=3 and departmentid in("+tmptdepartment+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=5 and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+"))  or (sharetype=6 and ( (joblevel=0 and jobtitles='"+jobtitles+"' ) or (joblevel=1 and jobtitles='"+jobtitles+"' and jobsubcompany in("+tmptsubcompanyid+")) or (joblevel=2 and jobtitles='"+jobtitles+"' and jobdepartment in("+tmptdepartment+") )) )  or (sharetype=4 and exists(select 1 from HrmRoleMembers where roleid=t.roleid and rolelevel>=t.rolelevel and resourceid="+user.getUID()+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) ))"; 
}
if(isSys){
	votingsql +=" and 1=2";
}
signRs.executeSql(votingsql);
while(signRs.next()){ 
String votingid = signRs.getString("id");
String voteshow = signRs.getString("autoshowvote"); 
String forcevote = signRs.getString("forcevote"); 

%>

	<script language=javascript>  
	   if(voteids == ""){
	      voteids = '<%=votingid%>';
	      voteshows = '<%=voteshow%>';
	      forcevotes = '<%=forcevote%>';
	   }else{
	      voteids =voteids + "," +  '<%=votingid%>';
	      voteshows =voteshows + "," +  '<%=voteshow%>';
	      forcevotes =forcevotes + "," +  '<%=forcevote%>';
	   }

	</script> 
	<%
	}
	//------------------------------------
	//网上调查部分 End
	//------------------------------------
	%> 

<%
boolean checkchattemp = false;
//String chatserver = Util.null2String(weaver.general.GCONST.getCHATSERVER());//检测即时通讯是否开启
//if(!"".equals(chatserver)) checkchattemp = true;


//String frommain = Util.null2String(request.getParameter("frommain")) ;
RemindSettings settings=(RemindSettings)application.getAttribute("hrmsettings");
String birth_valid = settings.getBirthvalid();
String birth_remindmode = settings.getBirthremindmode();
BirthdayReminder birth_reminder = new BirthdayReminder();
if(birth_valid!=null&&birth_valid.equals("1")&&birth_remindmode!=null&&birth_remindmode.equals("0")){
  String today = TimeUtil.getCurrentDateString();
 if(application.getAttribute("birthday")==null||application.getAttribute("birthday")!=today){
   application.setAttribute("birthday",today);
   ArrayList birthEmployers=birth_reminder.getBirthEmployerNames(user);
   application.setAttribute("birthEmployers",birthEmployers);
   }
 ArrayList birthEmployers=(ArrayList)application.getAttribute("birthEmployers");
 
 if(birthEmployers.size()>0){ 
%>
<script>
/*
var chasm = screen.availWidth;
var mount = screen.availHeight;
function openCenterWin(url,w,h) {
   window.open(url,'','scrollbars=yes,resizable=no,width=' + w + ',height=' + h + ',left=' + ((chasm - w - 10) * .5) + ',top=' + ((mount - h - 30) * .5));
}
*/

eBirth = true;


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
		//initsrcpage="/homepage/HomepageRedirect.jsp?hpid=1&subCompanyId=1&isfromportal=0&isfromhp=0";
	}else{
		initsrcpage="/docs/news/NewsDsp.jsp";
	}
}

String gopage = Util.null2String(request.getParameter("gopage"));
String frompage = Util.null2String(request.getParameter("frompage"));
if(!gopage.equals("")){
	gopage=URLDecoder.decode(gopage);
	if(!"".equals(frompage)){
		//System.out.println(frompage);
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
	//alert("<%=SystemEnv.getHtmlLabelName(16643,user.getLanguage())%>!\n<%=SystemEnv.getHtmlLabelName(27892,user.getLanguage())+SystemEnv.getHtmlLabelName(2023,user.getLanguage())%>:"+"<%=logmessage%>");
	jQuery(function () {
		Dialog.alert("<%=SystemEnv.getHtmlLabelName(16643,user.getLanguage())%>!<br><%=SystemEnv.getHtmlLabelName(27892,user.getLanguage())+SystemEnv.getHtmlLabelName(2023,user.getLanguage())%>:"+"<%=LoginMsg.getLastLoginInfo(""+user.getUID()) %>"
			,function(){}, 372, 70, false
		);
	});
</script>
<%}
}%>
<script language=javascript>
function goMainFrame(o){
	//jQuery(o).o.contentWindow.document.location.href = "<%=initsrcpage%>"; 
	jQuery("#mainFrame",o.contentWindow.document).attr("src","<%=initsrcpage%>"); 
	//o.contentWindow.document.frames[1].document.location.href = "<%=initsrcpage%>";    
}

function showBirth(){
	if (eBirth) {
	 	var diag_bir = new Dialog();
		diag_bir.Width = 475;
		diag_bir.Height = 475;
		diag_bir.AutoClose=6;
		diag_bir.Modal = false;
		diag_bir.Title = "<%=SystemEnv.getHtmlLabelName(17534,user.getLanguage())%>";
		diag_bir.URL = "/hrm/setting/Birthday.jsp?theme=ecology7";
		diag_bir.show();
	}
}

function showVote(){
     if(voteids !=""){
	     var arr = voteids.split(",");
	     var autoshowarr = voteshows.split(",");
	     var forcevotearr = forcevotes.split(",");
		 for(i=0;i<arr.length;i++){
		    //判断是否弹出调查
		    if(autoshowarr[i] !='' || forcevotearr[i] !=''){//弹出
			    var diag_vote = new Dialog();
				diag_vote.Width = 960;
				diag_vote.Height = 800;
				diag_vote.Modal = false;
				diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(17599,user.getLanguage())%>";
				diag_vote.URL = "/voting/VotingPoll.jsp?votingid="+arr[i];
				if(forcevotearr[i] !=''){//强制调查
				  diag_vote.ShowCloseButton=false; 
				}
				diag_vote.show();
			}
		 }
	 }
}

jQuery(document).ready(function (){
	//生日提醒与网上调查
	showBirth();
	showVote();
});
</script>

<html>
<head>
<title><%=templateTitle%> - <%=username%></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="/css/Weaver_wev8.css" type="text/css">

<script language=javascript>
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
<script type="text/javascript" src="/js/jquery/jquery_wev8.js"></script>
<script language="JavaScript"  src="/js/htusbjs_wev8.js"></script>
<script language="JavaScript"  src="/js/htusb_wev8.js"></script>
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
#rightMenu{
	display:none;
}
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
	width: 100px;
	border: 1px solid #666666;
	background-color: #F9F8F7;
	padding: 1px;
}
.popupMenuTable{
	background-image: url(/images/popup/bg_menu_wev8.gif);
	background-repeat: repeat-y;
}
.popupMenuTable TD{
	font-family:MS Shell Dlg;
	font-size: 12px;
	cursor: default;
}
.popupMenuRow{
	height: 18px!important;
	
}
.popupMenuRowHover{
	height: 18px!important;
	
	background-color: #B6BDD2;
}
.popupMenuSep{
	background-color: #A6A6A6;
	height:1px;
	width: 70;
	position: relative;
	left: 28;
}
</style>


<style type="text/css">
/* 搜索控件用css */
.searchkeywork {width: 74px;font-size: 12px;height:22px;margin-top:1;margin-left:-2px;background:none;border:none;color:#333;top:0;margin:0;padding:1;padding-top:3px;}
.dropdown {margin-left:5px; font-size:11px; color:#000;height:23px;margin:0;padding:0;padding-top:2px;}
.selectContent, .selectTile, .dropdown ul { margin:0px; padding:0px; }
.selectContent { position:relative;z-index:6; }
.dropdown a, .dropdown a:visited { color:#816c5b; text-decoration:none; outline:none;}
.dropdown a:hover { color:#5d4617;}
.selectTile a:hover { color:#5d4617;}
.selectTile a {background:none; display:block;width:40px;margin-left:4px;margin-top:1px;}
.selectTile a span {cursor:pointer; display:block; padding:0 0 0 0;background:none;}
.selectContent ul { background:#fff none repeat scroll 0 0; border:1px solid #828790; color:#C5C0B0; display:none;left:0px; position:absolute; top:2px; width:auto; min-width:50px; list-style:none;}
.dropdown span.value { display:none;}
.selectContent ul li a { padding:0px 0 0px 2px; display:block;margin:0;width:60px;}
.selectContent ul li a:hover { background-color:#3399FF;}
.selectContent ul li a img {border:none;vertical-align:middle;margin-left:2px;}
.selectContent ul li a span {margin-left:5px;}
.flagvisibility { display:none;}
</style>

<script type="text/javascript">
// 搜索控件用js
jQuery(document).ready(function() {
		jQuery(".dropdown img.flag").addClass("flagvisibility");

        jQuery(".selectTile a").click(function() {
            jQuery(".selectContent ul").toggle();
        });
                    
        jQuery(".selectContent ul li a").click(function() {
            var text = jQuery(this).children("span").html();
            jQuery("#basicSearchrTypeText").html(text);
            jQuery("input[name='searchtype']").val(jQuery(this).children("span").attr("searchType"));
            jQuery(".selectContent ul").hide();
        });
                    
        function getSelectedValue(id) {
            return jQuery("#" + id).find("selectContent a span.value").html();
        }

        jQuery(document).bind('click', function(e) {
            var $clicked = jQuery(e.target);
            if (! $clicked.parents().hasClass("dropdown"))
                jQuery(".selectContent ul").hide();
        });


        jQuery("#flagSwitcher").click(function() {
            jQuery(".dropdown img.flag").toggleClass("flagvisibility");
        });
});		

window.onresize = function winResize() {
	if (jQuery("#mainBody").width() <= 1024 ) {
		jQuery("#topMenuTbl").css("width", "1019px");
	} else {
		jQuery("#topMenuTbl").css("width", jQuery("#mainBody").width() - 5);
	}
}
var common = new MFCommon();
var uid = "<%=String.valueOf(user.getUID())%>";
var isAdmin = "<%=String.valueOf(user.isAdmin())%>";
function checkUserOffline(){
	var result = "";
	try{
		result = common.ajax("cmd=isOffline&uid="+uid);
	}catch(e){}
	if(result === "-1" || result === "0"){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81908,user.getLanguage())%>", function(){
			window.location = '/login/Login.jsp';
		});
		return;
	}
	setTimeout("checkUserOffline()",3000);
}
jQuery(document).ready(function(){
	//if(isAdmin === "false") checkUserOffline();
	jQuery("#mainBody").css("background","url(<%=bodyBg %>) repeat-y");
});

</script>


	<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag_wev8.js"></script>
	<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog_wev8.js"></script>

<script language=javascript> 

function showThemeListDialog(){
	showSkinListDialog();
}


</script> 
	
<script language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<body id="mainBody"  text="#000000"  style="" scroll="no" oncontextmenu="return false;">

<%if(SocialIMService.isOpenIM()){%>
	<jsp:include page="/social/im/SocialIMInclude.jsp"></jsp:include>
<%}%>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%@ include file="/favourite/FavouriteShortCut.jsp" %>
<script>   
  var con=null;
  window.onbeforeunload=function(e){	
	  if(typeof(isMesasgerUnavailable) == "undefined") {
		     isMesasgerUnavailable = true; 
	  }  
	  if(!isMesasgerUnavailable && glbreply == true){
	  	return "<%=SystemEnv.getHtmlLabelName(24985,user.getLanguage())%>";
	  }	
	  e=getEvent(); 
	  var n = e.screenX - e.screenLeft;
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
<iframe id="downLoadReg" style="display: none;"></iframe>  
<div id='divShowSignInfo' style='background:#FFFFFF;padding:0px;width:100%;display:none' valign='top'>
</div>

<div id='message_Div' style='display:none'>
</div>
<table width="100%"  height="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="71px" id="topMenuTd">
		<Table id="topMenuTbl" height="100%" width="100%" cellspacing="0" cellpadding="0" style="background:url(<%=topBgImage %>) repeat-x;">
			<tr id="topMenuLogo" height="43px">
				<td  width="198px" height="43px" style="position:relative;background:url(<%=(logoTop == null || logoTop.equals("")) ? "/wui/theme/ecologyBasic/page/images/logo_up_wev8.png" : logoTop %>) no-repeat;">
				&nbsp;
				</td>
				<td width="*">
				</td>
			</tr>
			<%
					String logoBtmImgSrc="";
		            if (logoBtm == null || logoBtm.equals("")) {
		            	logoBtmImgSrc = "/wui/theme/ecologyBasic/page/images/logo_down_wev8.png";
		           
		            } else {
		            	logoBtmImgSrc = logoBtm;
					
		            }
					%>
			<tr height="28px">
				<td height="28px" width="198px" style="background:url(<%=logoBtmImgSrc %>) no-repeat;">
					
					
				
					
				</td>
				<td width="*" height="28px" style="">
					
					<table height="28px" width="100%"  cellspacing="0" cellpadding="0" style='background:url(<%=toolbarBgColor %>) repeat-x'>
						<tr>
							<td height="100%" width="680px" align="left">
								<table  height=100% border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width=23 align="center" >
											<%if(!logintype.equals("2")){%>
											<iframe BORDER=0 FRAMEBORDER=no style="display:none" NORESIZE=NORESIZE width=0 height=0 SCROLLING=no SRC=/system/SysRemind.jsp></iframe>
											<%}%>
											<table class="toolbarMenu" style="position:relative;"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><span class="toolbarBgSpan" style="display:block;width:16px;height:16px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/BP_Hide_wev8.png) no-repeat;" id="LeftHideShow" onclick="javascript:mnToggleleft()" title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>"></span></td></tr></table>
										</td>
											<td width=23 align="center">
											<table class="toolbarMenu" style="position:relative;"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><span class="toolbarBgSpan" style="display:block;width:16px;height:16px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/BP2_Hide_wev8.png) no-repeat;" id="TopHideShow" onclick="javascript:mnToggletop()" title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>"></span></td></tr></table>
										</td>
										<td width="10px" align="center" style="position:relative;">
											<img src="/images_face/ecologyFace_1/VLine_1_wev8.gif" border=0 style="margin-top:5px;">
										</td>
										<td style="width:23px;height:28px;" align="center" valign="middle">
											<table class="toolbarMenu" style="position:relative;"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><span class="toolbarBgSpan" style="display:block;width:16px;height:16px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/LogOut_wev8.png) no-repeat;" onclick="javascript:toolBarLogOut()" title="<%=SystemEnv.getHtmlLabelName(1205,user.getLanguage())%>"></span></td></tr></table><!--退出-->
										</td>
										<td width="10px" align="center" style="position:relative;">
											<img src="/images_face/ecologyFace_1/VLine_1_wev8.gif" border=0 style="margin-top:5px;">
										</td>
										<td style="width:23px;height:28px;" align="center" valign="middle">
											<table class="toolbarMenu"  style="position:relative;"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><span class="toolbarBgSpan" style="display:block;width:16px;height:16px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/Back_wev8.png) no-repeat" onclick="javascript:toolBarBack()" title="<%=SystemEnv.getHtmlLabelName(15122,user.getLanguage())%>"></span></td></tr></table><!--后退-->
										</td>
										<td style="width:23px;height:28px;" align="center" valign="middle" >
											<table style="position:relative;" class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><span class="toolbarBgSpan" style="display:block;width:16px;height:16px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/Pre_wev8.png) no-repeat;" onclick="javascript:toolBarForward()" title="<%=SystemEnv.getHtmlLabelName(15123,user.getLanguage())%>"></span></td></tr></table><!---->
										</td>
										<td style="width:23px;height:28px;" align="center" valign="middle">
											<table class="toolbarMenu" style="position:relative;"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><span class="toolbarBgSpan" style="display:block;width:16px;height:16px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/Refur_wev8.png) no-repeat;" onclick="javascript:toolBarRefresh()" title="<%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%>"></span></td></tr></table><!--刷新-->
										</td>
										<!-- <td style="width:23px;height:28px;" align="center" valign="middle">
											<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/wui/theme/ecologyBasic/page/images/toolbar/Favourite_wev8.gif" onclick="javascript:toolBarFavourite()" title="<%=SystemEnv.getHtmlLabelName(2081,user.getLanguage())%>"></td></tr></table>
										</td> --><!--收藏夹-->
										<td style="width:23px;height:28px;" align="center" valign="middle">
											<table style="position:relative;" class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><span class="toolbarBgSpan" style="display:block;width:16px;height:16px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/Print_wev8.png) no-repeat;" onclick="javascript:toolBarPrint()" title="<%=SystemEnv.getHtmlLabelName(257,user.getLanguage())%>"></span></td></tr></table><!--打印-->
										</td>
										<%if(weaver.general.GCONST.getMOREACCOUNTLANDING()){%>
										<%//多账号%>
										<%List accounts =(List)session.getAttribute("accounts");
							                if(accounts!=null&&accounts.size()>1){
							                    Iterator iter=accounts.iterator();
							                %>
							            <td width="10px" align="center" style="position:relative;">
											<img src="/images_face/ecologyFace_1/VLine_1_wev8.gif" border=0 style="margin-top:5px;">
										</td>
							            <td style="width:200px;height:28px;" align="center" valign="middle" style="position:relative;">
								            <table class="toolbarMenu"><tr>
								            <td style="width:200px;"><select id="accountSelect" name="accountSelect" onchange="onCheckTime(this);"   style="width:200px;">
								                    <% while(iter.hasNext()){Account a=(Account)iter.next();
								                    String subcompanyname=SubCompanyComInfo.getSubCompanyname(""+a.getSubcompanyid());
								                    String departmentname=DepartmentComInfo.getDepartmentname(""+a.getDepartmentid());
								                    String jobtitlename=JobTitlesComInfo.getJobTitlesname(""+a.getJobtitleid());                       
								                    %>
								                    <option <%if((""+a.getId()).equals(userid)){%>selected<%}%> value=<%=a.getId()%>><%=subcompanyname+"/"+departmentname+"/"+jobtitlename%></option>
								                    <%}%>
								                </select></td></tr></table>
								        </td>
								            	<%}%>
											<%}%>
										<td width="10px" align="center" style="position:relative;">
											<img src="/images_face/ecologyFace_1/VLine_1_wev8.gif" border=0 style="margin-top:5px;">
										</td>
										<td width="50px" id="favouriteshortcutid" style="position:relative;padding-top:8px">
											<span id="favouriteshortcutSpan" style="color:#fff;text-align:center;border:none">
												<%=SystemEnv.getHtmlLabelName(2081,user.getLanguage()) %>
											</span>
											<span class="toolbarBgSpan" style="position:absolute;width:10px;height:6px;border:none;margin-top:5px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/favorites_slt_wev8.png) no-repeat;">
											</span>
										</td>
										<td width="10px" align="center" style="position:relative;">
											<img src="/images_face/ecologyFace_1/VLine_1_wev8.gif" border=0 style="margin-top:5px;">
										</td>
										<!-- 搜索block start -->			
										<td width="143px" style="padding-top:2px;">
											
					                        <form name="searchForm" method="post" action="/system/QuickSearchOperation.jsp" target="mainFrame">
								            <TABLE cellpadding="0px" cellspacing="0px" height="23px" width="100%" align="right" style="position:relative;z-index:6;" id="searchBlockTBL">
								                <tr height="100%" style="background: url(/wui/theme/ecologyBasic/page/images/toolbar/search/searchBg_wev8.png) center repeat;">
								                    <td width="40px" height="100%" style="margin:0;padding:0;">
								                        <input type="hidden" name="searchtype" value="<%=microSearch?9:2%>">
								                        <div id="sample" class="dropdown" style="position:relative;top:1px;">
								                            <div class="selectTile" style="height: 100%;vertical-align: middle;">
									                            <a href="#"><span style="float:left;width:25px;display:block;" id="basicSearchrTypeText">
											<%=microSearch?
												SystemEnv.getHtmlLabelName(31953,user.getLanguage()):
												SystemEnv.getHtmlLabelName(30042,user.getLanguage())%>
																	</span>
																	<TABLE cellpadding="0px" cellspacing="0px" height="4px" width="8px" align="center">
																		<tr>
																			<td width="8px" height="4px" valign="middle" >
																			
																				<div style="position:absolute;overflow:hidden;display:block;width:8px;top:10px;left:36px;height:8px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/search/searchSlt_wev8.png) no-repeat;" class="toolbarSplitLine"></div>
																			
																			</td>
																		</tr>
																	</TABLE>
																</a>
															</div>
								                            <div class="selectContent">
								                                <ul id="searchBlockUl">
								                                <% if(microSearch){ %>
																		<li><a href="#"><img src="/wui/theme/ecology8/page/images/toolbar/ws_wev8.png"/><span searchType="9"><%=SystemEnv.getHtmlLabelName(31953,user.getLanguage())%></span></a></li>
																		<%}%>
																		<li><a href="#"><img src="/wui/theme/ecology7/page/images/toolbar/hr_wev8.png"/><span searchType="2"><%=SystemEnv.getHtmlLabelName(30042,user.getLanguage())%></span></a></li>
																		<li><a href="#"><img src="/wui/theme/ecology7/page/images/toolbar/wl_wev8.png"/><span searchType="5"><%=SystemEnv.getHtmlLabelName(30045,user.getLanguage())%></span></a></li>
																		
																		<li><a href="#"><img src="/wui/theme/ecology7/page/images/toolbar/doc_wev8.gif"/><span searchType="1"><%=SystemEnv.getHtmlLabelName(30041,user.getLanguage())%></span></a></li>
																	<%if(isgoveproj==0){%>
																		<%if((Customertype.equals("3") || Customertype.equals("4") || !logintype.equals("2"))&&("1".equals(MouldStatusCominfo.getStatus("crm"))||"".equals(MouldStatusCominfo.getStatus("crm")))){%> 
																		<li><a href="#"><img src="/wui/theme/ecology7/page/images/toolbar/crm_wev8.gif"/><span searchType="3"><%=SystemEnv.getHtmlLabelName(30043,user.getLanguage())%></span></a></li>
																		<%
																		}
																	}
																		%>
																		<%if("1".equals(MouldStatusCominfo.getStatus("cwork"))||"".equals(MouldStatusCominfo.getStatus("cwork"))) {%>
																		<li><a href="#"><img src="/wui/theme/ecology7/page/images/toolbar/xz_wev8.gif"/><span searchType="8"><%=SystemEnv.getHtmlLabelName(30047,user.getLanguage())%></span></a></li>
																	<%} %>
																	
																		<li><a href="#"><img src="/wui/theme/ecology7/page/images/toolbar/mail_wev8.gif"/><span searchType="7"><%=SystemEnv.getHtmlLabelName(71,user.getLanguage())%></span></a></li>
																	
																	<%
																	if(isgoveproj==0&&("1".equals(MouldStatusCominfo.getStatus("proj"))||"".equals(MouldStatusCominfo.getStatus("proj")))){%>
																		<li><a href="#"><img src="/wui/theme/ecology7/page/images/toolbar/p_wev8.gif"/><span searchType="6"><%=SystemEnv.getHtmlLabelName(30046,user.getLanguage())%></span></a></li>
																	<%
																	}
																	%>
																	<%
																	if((!logintype.equals("2")) && software.equals("ALL")&&("1".equals(MouldStatusCominfo.getStatus("cpt"))||"".equals(MouldStatusCominfo.getStatus("cpt")))){%>
																		<li><a href="#"><img src="/wui/theme/ecology7/page/images/toolbar/zc_wev8.gif"/><span searchType="4"><%=SystemEnv.getHtmlLabelName(30044,user.getLanguage())%></span></a></li>
																	<%
																	}
																	%>
								                                </ul>
								                            </div>
								                        </div>
								                    </td>
								                  
								                   
								                      <td width="74px">
								                        <input type="text" name="searchvalue" onMouseOver="this.select()" class="searchkeywork"  style="border:0px"/>
								                    </td>
								                    <td width="22px" style="position:relative;">
								                        <span onclick="searchForm.submit()" id="searchbt" style="top:4px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/search/searchBt_wev8.png)  no-repeat;display:block;width:16px;height:16px;overflow:hidden;cursor:hand;"></span>
								                    </td>
								                </tr>
								            </table>
								            </form>
					                    </td>
										<!-- 搜索block end -->
										<td width="10px">
										</td>
										
										<td id="tdSignInfo" <%=isNeedSign?"":"style='display: none'" %> >
										    <div id="signInOrSignOutSpan" onclick="signInOrSignOut(jQuery(this).attr('_signType'))" _signType="<%=signType%>" style="display:block;height:21px;width:56px;text-align:center;padding-top:1px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/sign_wev8.gif) no-repeat;cursor:hand;color:blue;Vertical-align:middle;position:relative;overflow:hidden;">
												<%
												if(signType.equals("1")){
													out.println(SystemEnv.getHtmlLabelName(20032,user.getLanguage()));
												}else{
													out.println(SystemEnv.getHtmlLabelName(20033,user.getLanguage()));
												}
												%>						      
										    </div>
										</td>
										
									</tr>
								</table>
							</td>
							
							
							
							<td align="right" style="">
		<table height=100% border="0" cellspacing="0" cellpadding="0" >
			<tr>
			<td width="23px" align="center" >
				<table class="toolbarMenu" style="position:relative;"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><span class="toolbarBgSpan" style="display:block;width:16px;height:16px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/Home_wev8.png) no-repeat;" onclick="javascript:goUrl('/homepage/HomepageRedirect.jsp')" title="<%=SystemEnv.getHtmlLabelName(1500,user.getLanguage())%>"></span></td></tr></table><!--首页-->
			</td>
			
         <!-- 页面模板选择开始-->
		<td style="width:10px;height:28px;"></td>
	    <%
	    if (islock == null || !"1".equals(islock)) {
	    %>
	    <td style="width:23px;height:28px;z-index:1;" align="left" valign="middle">
	    	<div style="position:relative;">
			<table class="toolbarMenu" >
			<tr>
			<td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';" onclick="javascript:showThemeListDialog();"><span class="toolbarBgSpan" style="top:6px;left:4px;display:block;width:16px;height:16px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/ThemeSlt_wev8.png) no-repeat;" title="<%=SystemEnv.getHtmlLabelName(84105,user.getLanguage()) %>"></span>
			</td>
			</tr>
			</table><!--皮肤-->
			
			</div>
		</td>
		<%
	    }
		%>
         <!-- 页面模板选择结束-->

			<td width="10px" align="center" style="position:relative;">
				<img src="/images_face/ecologyFace_1/VLine_1_wev8.gif" border=0 style="margin-top:5px;">
			</td>
			
			<%
			if((isHaveMessager&&!userid.equals("1")&&isHaveMessagerRight==1)||isHaveEMessager){ 
			%>
				<td width="23" align="center" style="position:relative;">
					<!--  <div id="divMessagerState"/>-->
					<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';" id="tdMessageState"></td></tr></table>
				</td>	
				<td width="10px" align="center" style="position:relative;">
					<img src="/images_face/ecologyFace_1/VLine_1_wev8.gif" border=0 style="margin-top:5px;">
				</td>
			<%}%>
			
			
			<script type="text/javascript">
				jQuery(document).ready(function() {
					jQuery("#toolbarMore").css("filter", "");
					jQuery("#toolbarMore").hide();
					
					jQuery("#toolbarMore").hover(function() {
			        }, function() {
			        	jQuery("#toolbarMore").hide();
			        });
			        jQuery("#toolbarMore td").bind("click", function() {
			        	jQuery("#toolbarMore").hide();
			        });
				});
				
				function toolbarMore() {
					jQuery("#toolbarMore").toggle();
				}
			</script>
			<td width=30 align="center" style="z-index:1;">
						<div style="position:relative;">
						<table class="toolbarMenu"><tr><td onclick="javascript:toolbarMore();" onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><span class="toolbarBgSpan" style="left:4;top:4px;display:block;width:23px;height:22px;background:url(/wui/theme/ecologyBasic/page/images/toolbar/toolbarMore_wev8.png) no-repeat;" title="<%=SystemEnv.getHtmlLabelName(17499,user.getLanguage())%>"></span></td></tr></table>
			        	<div id="toolbarMore" style="display:none;position:absolute;width:184px;right:8px;top:25px;">
			        		<div id="toolbarMoreBlockTop" style="overflow:hidden;width:184px;background-image:url(/wui/theme/ecologyBasic/page/images/toolbar/toolbarMoreTop_wev8.png);height:11px;"></div>
			        		<TABLE cellpadding="2" cellspacing="0" align="center" width="100%" style="margin:0;background-image:url(/wui/theme/ecologyBasic/page/images/toolbar/toolbarMoreCenter_wev8.jpg);background-repeat: repeat-y;">
			        			<tr><td colspan="5" height="5px"></td></tr>
				    	    	<tr align="center">
				    	    			<td width="5px"></td>
				    	    			<%
										if(checkchattemp){
										%>
										<td width="25px" align="center">
											<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/msn_wev8.gif" onclick="javascript:showHrmChatTree('')" title="<%=SystemEnv.getHtmlLabelName(23525,user.getLanguage())%>"></td></tr></table><!---->
										</td>
										<%}%>
										<%if("1".equals(MouldStatusCominfo.getStatus("scheme"))){ %>
							            <td width=25px align="center">
											<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Plan_wev8.gif" onclick="javascript:goUrl('/workplan/data/WorkPlan.jsp?resourceid=<%=user.getUID()%>')" title="<%=SystemEnv.getHtmlLabelName(18480,user.getLanguage())%>"></td></tr></table><!--我的计划-->
										</td>
										<%}%>
										<%if("1".equals(MouldStatusCominfo.getStatus("message"))){ %>
										<td width=25px align="center">
											<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Mail_wev8.gif" onclick="javascript:goUrl('/email/MailFrame.jsp?act=add')" title="<%=SystemEnv.getHtmlLabelName(2029,user.getLanguage())%>"></td></tr></table><!--新建邮件-->
										</td>
								    	<%}%>
										<%if("1".equals(MouldStatusCominfo.getStatus("doc"))){ %>
							        	<td width=25px align="center">
											 <table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Doc_wev8.gif" onclick="javascript:goUrl('/docs/docs/DocList.jsp')" title="<%=SystemEnv.getHtmlLabelName(1986,user.getLanguage())%>"></td></tr></table><!--新建文档-->
										</td>
										<%} %>
										<%if("1".equals(MouldStatusCominfo.getStatus("workflow"))){ %>
								        <td width=23px align="center">
										    <table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/WorkFlow_wev8.gif" onclick="goUrl('/workflow/request/RequestType.jsp?needPopupNewPage=true')" title="<%=SystemEnv.getHtmlLabelName(16392,user.getLanguage())%>"></td></tr></table><!--新建流程-->
										</td>
										<%} %>	
								</tr>
								<tr align="center">
										<td width="5px"></td>
										<%if(isgoveproj==0){%>
							            <%if(software.equals("ALL") || software.equals("CRM")){%>
							      		<%if("1".equals(MouldStatusCominfo.getStatus("crm"))){ %>      
							      		<td width=25px align="center">
											<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/CRM_wev8.gif" onclick="javascript:goUrl('/CRM/data/AddCustomerExist.jsp')" title="<%=SystemEnv.getHtmlLabelName(15006,user.getLanguage())%>"></td></tr></table><!---->
										</td>
										<%}%>
										<%if("1".equals(MouldStatusCominfo.getStatus("proj"))){ %>
							            <td width=25px align="center">
											<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/PRJ_wev8.gif" onclick="javascript:goUrl('/proj/data/AddProject.jsp')" title="<%=SystemEnv.getHtmlLabelName(15007,user.getLanguage())%>"></td></tr></table><!---->
										</td>
										<%}%>
							            <%}%>
										<%}%>
										<%if("1".equals(MouldStatusCominfo.getStatus("meeting"))){ %>
							            <td width=25px align="center">
											<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Meeting_wev8.gif" onclick="javascript:goUrl('/meeting/data/AddMeeting.jsp')" title="<%=SystemEnv.getHtmlLabelName(15008,user.getLanguage())%>"></td></tr></table><!---->
										</td>
										<%}%>			
										<td width=23px align="center">
											<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Org_wev8.gif" onclick="javascript:goUrl('/org/OrgChart.jsp?charttype=H')" title="<%=SystemEnv.getHtmlLabelName(16455,user.getLanguage())%>"></td></tr></table><!--组织结构-->
										</td>	
									</tr>
									<tr align="center">	
										<td width="5px"></td>
										<td width=25px align="center">
											<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Plugin_wev8.gif" onclick="javascript:goopenWindow('/weaverplugin/PluginMaintenance.jsp')" title="<%=SystemEnv.getHtmlLabelName(7171,user.getLanguage())%>"></td></tr></table><!--插件-->
										</td>
							         	<%if(rtxClient.isValidOfRTX()){
											RTXConfig rtxConfigtmp = new RTXConfig();
											String RtxOrElinkType = (Util.null2String(rtxConfigtmp.getPorp(RTXConfig.RtxOrElinkType))).toUpperCase();
											if("ELINK".equals(RtxOrElinkType) && !RTXConfig.isSystemUser(user.getLoginid())){ 
										%>
                                        <td width=23px align="center">
											<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/favicon_wev8.jpg" onclick="javascript:openEimClient()" title="<%=SystemEnv.getHtmlLabelName(27463,user.getLanguage())%>"></td></tr></table><!---->
										</td>
										<%} else if(!RTXConfig.isSystemUser(user.getLoginid())){%>
										<td width=23px align="center">
											<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/rtx_wev8.gif" onclick="javascript:openRtxClient()" title="<%=SystemEnv.getHtmlLabelName(83530,user.getLanguage())%>"></td></tr></table><!---->
										</td>
							         	<%}}%>
							         	<td width=25px align="center">
											<table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/Version_wev8.gif" onclick="javascript:showVersion()" title="<%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%>"></td></tr></table><!--版本-->
										</td>
										<td width=25px align="center">
										    <table class="toolbarMenu"><tr><td onmouseover="this.className='toolbarMenuOver';" onmouseout="this.className='toolbarMenuOut';"><img src="/images_face/ecologyFace_1/toolBarIcon/safeSite_wev8.png" width="15px" onclick="javascript:setSafeSite()" title="Ecology<%=SystemEnv.getHtmlLabelName(28422,user.getLanguage())%>"></td></tr></table><!--版本-->
										</td>
										<td>
										</td>
							    	</tr>
							   
							    <tr><td colspan="5" height="5px"></td></tr>
			        		</TABLE>
			        		<TABLE cellpadding="0px" cellspacing="0px" height="5px" width="100%" style="background:url(/wui/theme/ecologyBasic/page/images/toolbar/toolbarMoreBottom_wev8.png) no-repeat;"><tr><td height="5px"></td></tr></TABLE>
						</div>
						</div>
			        </td>
			
			</tr>
		</table>
		</td>
						</tr>
					</table>
				</td>
			</tr>
		</Table>
		<div id="divFavContent" style="position: absolute;z-index: 1000; bottom:10;left:100">
	<div class="popupMenu">
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%" class="popupMenuTable">
		<tr height="26">
			<td class="popupMenuRow" onmouseover="this.className='popupMenuRowHover';" onmouseout="this.className='popupMenuRow';" id="popupWin_Menu_Setting">
				<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
					<tr>
						<td width="28">&nbsp;</td>
						<td onclick="goSetting()"><%=SystemEnv.getHtmlLabelName(18166,user.getLanguage())%></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr height="3">
			<td>
				<div class="popupMenuSep"><img height="1px"></div>
			</td>
		</tr>
	</table>
	</div>
</div>
	</td>	
</tr>
<tr>
	<td style="padding:0px 0px 0px 0px;">
		
		<iframe id="leftFrame" name="leftFrame" BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE height="100%" width="99%" scrolling="NO" src="/wui/theme/ecologyBasic/page/leftFrame.jsp" onload="goMainFrame(this)" style="margin-left: 5px;"/>	
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
<iframe name="rtxClient" src="/<%=rtxorelinkurl%>" style="display:none"></iframe>
<%  }else{                                                                       %>
<iframe name="rtxClient" src="" style="display:none"></iframe>
<%  }                                                                            %>
<script>
$("#leftFrame").css("height",document.body.clientHeight-78);

document.oncontextmenu=""
//search.searchvalue.oncontextmenu=showRightClickMenu1

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
</body>
<!--文档弹出窗口-- 开始-->
<% 



String docsid = "";
String pop_width = "";
String pop_hight = "";
String is_popnum = "";
String pop_type = "";
String popupsql ="";
String pop_num ="";


String checktype="select docid,pop_type,pop_hight,pop_width,is_popnum, pop_num from DocDetail  t1, "+tables+"  t2,DocPopUpInfo t3 where t1.id=t2.sourceid and t1.id = t3.docid and t1.docstatus in ('1','2','5') and (t1.ishistory is null or t1.ishistory = 0) and (t3.pop_startdate <= '"+CurrentDate+"' and t3.pop_enddate >= '"+CurrentDate+"') ";
rspop.executeSql(checktype);
while(rspop.next()){
	pop_type=Util.null2String(rspop.getString("pop_type"));
	docsid = Util.null2String(rspop.getString("docid"));
    pop_hight =Util.null2String(rspop.getString("pop_hight"));
    pop_width = Util.null2String(rspop.getString("pop_width"));
    is_popnum = Util.null2String(rspop.getString("is_popnum"));
	pop_num = Util.null2String(rspop.getString("pop_num"));
	
	if("".equals(pop_hight)) pop_hight = "500";
    if("".equals(pop_width)) pop_width = "600";
	if(pop_type.equals("1")||pop_type.equals("")){
	  popupsql = "select 1 from DocDetail  t1, "+tables+"  t2,DocPopUpInfo t3 where t1.id=t2.sourceid and t1.id = t3.docid and (t1.ishistory is null or t1.ishistory = 0) and (t3.pop_startdate <= '"+CurrentDate+"' and t3.pop_enddate >= '"+CurrentDate+"') and pop_num > is_popnum and docid="+docsid;
	  RecordSet.executeSql(popupsql); 
	  if(RecordSet.next()){
		   RecordSet.executeSql("update DocPopUpInfo set is_popnum = "+(Util.getIntValue(is_popnum,0)+1)+" where docid = "+docsid);
%>
<script language=javascript> 
  var is_popnum = <%=is_popnum%>;
  var docsid = <%=docsid%>;
  var pop_hight = <%=pop_hight%>;
  var pop_width = <%=pop_width%>;
   var docid_num = docsid +"_"+ is_popnum;
  window.open("/docs/docs/DocDsp.jsp?popnum="+docid_num,"","height="+pop_hight+",width="+pop_width+",scrollbars,resizable=yes,status=yes,Minimize=yes,Maximize=yes");
</script> 


<%
        
	  }
	} else {
      rspopuser.executeSql("select * from DocPopUpUser where userid="+user.getUID()+" and docid="+docsid);

	  if(rspopuser.next()){
	  is_popnum = Util.null2String(rspopuser.getString("haspopnum"));
	  if(Util.getIntValue(is_popnum,0) <Util.getIntValue(pop_num,0)){
		 RecordSet.executeSql("update DocPopUpUser set haspopnum = "+(Util.getIntValue(is_popnum,0)+1)+" where docid = "+docsid+" and userid="+user.getUID());
		
%>
<script language=javascript> 
  var is_popnum = <%=is_popnum%>;
  var docsid = <%=docsid%>;
  var pop_hight = <%=pop_hight%>;
  var pop_width = <%=pop_width%>;
  var docid_num = docsid +"_"+ is_popnum;
  window.open("/docs/docs/DocDsp.jsp?popnum="+docid_num,"","height="+pop_hight+",width="+pop_width+",scrollbars,resizable=yes,status=yes,Minimize=yes,Maximize=yes");
</script> 


<%      
        
	   }
	
	  }else{
		  if(Util.getIntValue(pop_num,0)>0){
		   RecordSet.executeSql("insert into DocPopUpUser(userid,docid,haspopnum) values ("+user.getUID()+","+docsid+",1 )");	
%>
<script language=javascript> 
  var is_popnum = <%=is_popnum%>;
  var docsid = <%=docsid%>;
  var pop_hight = <%=pop_hight%>;
  var pop_width = <%=pop_width%>;
  var docid_num = docsid +"_0";
  window.open("/docs/docs/DocDsp.jsp?popnum="+docid_num,"","height="+pop_hight+",width="+pop_width+",scrollbars,resizable=yes,status=yes,Minimize=yes,Maximize=yes");
</script> 
<%
	  
		  }
	  
	  }
	}

}



%>
<!--文档弹出窗口-- 结束-->
<SCRIPT language=javascript>

jQuery(document).ready(function(){

	jQuery("#favouriteshortcutSpan").load("/wui/theme/ecologyBasic/page/FavouriteShortCut.jsp?data="+new Date().getTime());
	
})

function showFav(obj){
	var popupX = 0;
	var popupY = 0;
	//alert(jQuery("#divFavContent").html())
	//jQuery("#divFavContent",parent.parent.document).css("position","absolute");
	var offset = jQuery(obj).offset();
	//alert(offset.left)
	jQuery("#divFavContent").css({left:offset.left+26,bottom:offset.bottom});
	
	jQuery("#divFavContent").show();
	//parent.parent.showFav(obj);
}
//jQuery("#divFavContent")[0].onmouseover=onmove;


jQuery("#divFavContent").bind('mouseout',function(e){
	if(isMouseLeaveOrEnter(e, this)) {hideLeftMoreMenu(e);}
	
});

function isMouseLeaveOrEnter(e, handler) {
	e = jQuery.event.fix(e); 
    if (e.type != 'mouseout' && e.type != 'mouseover') return false;
    var reltg = e.relatedTarget ? e.relatedTarget : e.type == 'mouseout' ? e.toElement : e.fromElement;
    while (reltg && reltg != handler)  {
        reltg = reltg.parentNode;
     }
    return (reltg != handler);
}

function hideLeftMoreMenu(){	
	jQuery("#divFavContent").hide();
	return false;
}
function goSetting(){
	jQuery("#mainFrame",jQuery("#leftFrame")[0].contentWindow.document)[0].src='/systeminfo/menuconfig/CustomSetting.jsp'
	//jQuery("#mainFrame",)
}



function insertToPopupMenu(o){
	//alert(o.src)
	var tbl,tbl2,tr,td;
	tbl = document.createElement("table");
	
	tbl.cellspacing = 0;
	tbl.cellpadding = 0;
	tbl.width = "100%";
	tbl.height = "100%";
	tr = tbl.insertRow(-1);
	td = tr.insertCell(-1);
	td.width = 20;
	td.innerHTML = "<img src='"+o.src+"' width='16' heigh='16'/>";
	td = tr.insertCell(-1);
	//td.algin='left';
	td.innerHTML = o.getAttribute("menuname");
	//alert(jQuery(".popupMenuTable").length)
	tbl2 = jQuery(".popupMenuTable").get(0);
	//alert(tbl2.tagName)
	tr = tbl2.insertRow(-1);
	//tr.height="21px";
	td = tr.insertCell(-1);
	tr.height = 21;
	td.onclick = function(){slideFolder(this);};
	td.onmouseover = function(){this.className='popupMenuRowHover';};
	td.onmouseout = function(){this.className='popupMenuRow';};
	td.className = "popupMenuRow";
	td.setAttribute("menuid",o.getAttribute("menuid"));
	td.appendChild(tbl);
}
function openRtxClient(){
    document.all("rtxClient").src="/RTXClientOpen.jsp?notify=true";
}
function openEimClient(){
	document.all("rtxClient").src="/EimClientOpen.jsp";
}

function mnToggleleft(){
	var o = document.getElementById("leftFrame").contentWindow.document.getElementById("mainFrameSet");
	if(o.cols=="0,*"){
		var iMenuWidth=200;
		var iLeftMenuFrameWidth=Cookies.get("iLeftMenuFrameWidth");	
		if(iLeftMenuFrameWidth!=null) iMenuWidth=iLeftMenuFrameWidth;
		try{
			if(jQuery(o).find("frame")[0].contentWindow.document.getElementById("divMenuBox")){
				jQuery(jQuery(o).find("frame")[0].contentWindow.document.getElementById("divMenuBox")).show();
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
			if(jQuery(o).find("frame")[0].contentWindow.document.getElementById("divMenuBox")){
		    	jQuery(o).find("frame")[0].contentWindow.document.getElementById("divMenuBox").style.display = "none";
			}
			document.getElementById("leftFrame").contentWindow.document.getElementById("mainFrame").noResize = true;
			document.getElementById("leftFrame").contentWindow.document.getElementById("LeftMenuFrame").noResize = true;
			
			o.cols = "0,*";
			LeftHideShow.title = "<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>";//显示
		}catch(e){
			alert(e)
			window.status = e;
		}
	}
	//add by lupeng 2004.04.27 for TD315
	//leftFrame.location.reload();//重新load左边按钮
	//end
}

function mnToggletop(){
	if(topMenuLogo.style.display == ""){
		jQuery("#topMenuTd").height(28);
		if(document.getElementById("logoBottom")!=null){
			logoBottomSpan.style.display = "block";
			logoBottom.style.display = "none";
			jQuery("#bgy").css("top", jQuery("#bgy").offset().top - 43);
			jQuery("#toolbarBg").css("top", 0);
		}
		topMenuLogo.style.display = "none";
		topMenu.style.height = "28px";
		TopHideShow.title = "<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>";//显示

	}
	else{
		jQuery("#topMenuTd").height(71);
		if(document.getElementById("logoBottom")!=null){
			logoBottomSpan.style.display = "none";
			logoBottom.style.display = "block";
			jQuery("#bgy").css("top", jQuery("#bgy").offset().top + 43);
			jQuery("#toolbarBg").css("top", 43);
		}
		topMenuLogo.style.display = "";
		TopHideShow.title = "<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>";//隐藏
	}
	//leftFrame.location.reload();//重新load左边按钮
}

function slideFolder(o){

	//jQuery("#leftFrame").contentWindow.document.getElementById("mainFrame")
	jQuery("#LeftMenuFrame",jQuery("#leftFrame")[0].contentWindow.document)[0].contentWindow.slideFolder(o);
	
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

function toolBarRefresh(){
	try{
	document.getElementById("leftFrame").contentWindow.document.getElementById("mainFrame").contentWindow.document.location.reload();
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
	
	
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16628,user.getLanguage())%>",function(){
		//mainBody.onbeforeunload=null;
		mainBody.onunload=null;
		location.href="/login/Logout.jsp";
	})
}



/*先注释掉，功能不明
var sRepeat=null;
var oPopup = window.createPopup();
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
	var x = oPopup.document.parentWindow.event.clientX;
	var y = oPopup.document.parentWindow.event.clientY
	if(x<0 || y<0) oPopup.hide();
	sRepeat = null;
}

function doScrollerIE(dir, src, amount) {	
	if (amount==null) {amount=10}	
	if (dir=="up"){
		oPopup.document.all[src].scrollTop-=amount;
	}else{
		oPopup.document.all[src].scrollTop+=amount;
	}
	if (sRepeat==null) {sRepeat = setInterval("doScrollerIE('"+dir+"','" + src + "'," + amount + ")",150)}	
	return false;
}

function doClearInterval(){
	clearInterval(sRepeat);
}
*/
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
    if(signType != 1){
	    var ajaxUrl = "/wui/theme/ecology7/page/getSystemTime.jsp";
		ajaxUrl += "?field=";
		ajaxUrl += "HH";
		ajaxUrl += "&token=";
		ajaxUrl += new Date().getTime();
		
		jQuery.ajax({
		    url: ajaxUrl,
		    dataType: "text", 
		    contentType : "charset=UTF-8", 
		    error:function(ajaxrequest){}, 
		    success:function(content){
		    	var isWorkTime = jQuery.trim(content);
		    	if (isWorkTime == "true") {
		       window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(26273, user.getLanguage())%>',function(){
		       	writeSignStatus(signType);
		       },function(){
		       	return;
		       })     
		      }else{
		      	writeSignStatus(signType);
		      }
		    }  
	    });
    } else {
    	writeSignStatus(signType);
    }
}

function writeSignStatus(signType) {
	var ajax=ajaxInit();
    ajax.open("POST", "/hrm/schedule/HrmScheduleSignXMLHTTP.jsp?t="+Math.random(), true); 
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("signType="+signType);
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
            	signInOrSignOutSpan.innerHTML='<%=SystemEnv.getHtmlLabelName(20033,user.getLanguage())%>';
                showPromptForShowSignInfo(ajax.responseText, signType);
                jQuery("#signInOrSignOutSpan").attr("_signType", 2);
            }catch(e){
            }
        }
    }
}


var showTableDiv  = document.getElementById('divShowSignInfo');
var oIframe = document.createElement('iframe');


//type  1:显示提示信息
//      2:显示返回的历史动态情况信息
function showPromptForShowSignInfo(content, signType){
    var targetSrc = "";
	content = jQuery.trim(content).replace(/&nbsp;/g, "");
	var confirmContent = "<div style=\"margin-left:5px;margin-right:5px;\">" + content.substring(content.toUpperCase().indexOf('<TD VALIGN="TOP">') + 17, content.toUpperCase().indexOf("<BUTTON"));
	
    var checkday="";
	if(signType==1) checkday="prevWorkDay";
	if(signType==2) checkday="today";
	jQuery.post("/blog/blogOperation.jsp?operation=signCheck&checkday="+checkday,"",function(data){
		var dataJson=eval("("+data+")");
		if (dataJson.isSignRemind==1){
		    if(!dataJson.prevWorkDayHasBlog&&signType==1){
				confirmContent += "<br><br><span style=\"color:red;\"><%=SystemEnv.getHtmlLabelName(26987,user.getLanguage())%></span>";
				targetSrc = "/blog/blogView.jsp?menuItem=myBlog";
			}else if(!dataJson.todayHasBlog&&signType==2){
				confirmContent += "<br><br><span style=\"color:red;\"><%=SystemEnv.getHtmlLabelName(26983,user.getLanguage())%></span>";
				targetSrc = "/blog/blogView.jsp?menuItem=myBlog";
			}
			
			confirmContent += "</div>";
			if (targetSrc != undefined && targetSrc != null && targetSrc != "") {
				Dialog.confirm(
					confirmContent, function (){
						window.open(targetSrc);
					}, function () {}, 520, 90,false
			    );
			} else {
				Dialog.alert(confirmContent, function() {}, 520, 60,false);
			}
			
		    return ;
		}
		confirmContent += "</div>";
		Dialog.alert(confirmContent, function() {}, 520, 60,false);
    });
}

function onCloseDivShowSignInfo(){
	divShowSignInfo.style.display='none';
	message_Div.style.display='none';
	document.all.HelpFrame.style.display='none'
}
var firstTime = new Date().getTime();
function onCheckTime(obj){
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

//设置受信站点
function setSafeSite(){
  //jQuery("#downLoadReg").attr("src","/weaverplugin/safeSite.jsp");
  jQuery("#downLoadReg").attr("src","/weaverplugin/EcologyPlugin.zip");
}

function showSkinListDialog(){
	var hasSubTemplate = '<%=hasSubTemplate%>';
	if(hasSubTemplate == 'true'){
		Dialog.alert("<%=SystemEnv.getHtmlLabelName(126325, user.getLanguage())%>");
		return;	
	}
	var diag_xx = new Dialog();
	diag_xx.Width = 600;
	diag_xx.Height = 500;
	
	diag_xx.ShowCloseButton=true;
	diag_xx.Title = "<%=SystemEnv.getHtmlLabelName(27714, user.getLanguage())%>";//"主题中心";
	diag_xx.Modal = true;
	diag_xx.opacity=0;
	diag_xx.URL = "/wui/theme/ecology8/page/skinTabs.jsp";
	diag_xx.show();
}
</SCRIPT>
<script language="javascript">
function showVersion(){	
	var dlg=new window.top.Dialog();//定义Dialog对象
	var url = "/systeminfo/version.jsp";
	var title = "<%=SystemEnv.getHtmlLabelName(16900,user.getLanguage()) %>e-cology";
	dlg.currentWindow = window;
	dlg.Model=true;
	dlg.Width=630;//定义长度
	dlg.Height=400;
	dlg.URL=url;
	dlg.Title=title;
	dlg.show();
} 
</script>

<script language=javascript>

if("<%=String.valueOf(isNeedSign && "1".equals(signType))%>" == "true"){
window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(21415,user.getLanguage())%>",function(){
	signInOrSignOut(<%=signType%>);
});
}
var needRemind = true;
function canSign(){
	if(!needRemind)return;
	try{
		jQuery.ajax({
			url:"/hrm/ajaxData.jsp",
			type:"POST",
			dataType:"json",
			async:false,
			data:{
				cmd:"isNeedSign",
			},
			success:function(data){
				if(data.isNeedSign){
					window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(21415,user.getLanguage())%>",function(){
						signInOrSignOut(data.signType);
						needRemind = false;
						jQuery("#tdSignInfo").show();
					},function(){
						needRemind = false;
					  try{
					  	jQuery("#tdSignInfo").show();
            	jQuery("#signInOrSignOutSpan").text("<%=SystemEnv.getHtmlLabelName(20032,user.getLanguage())%>");
                showPromptForShowSignInfo(ajax.responseText, signType);
                jQuery("#signInOrSignOutSpan").attr("_signType", 1);
            }catch(e){}
					})
				}else{
					setTimeout('canSign()', 20*1*1000);
				}
			}
		});
	}catch(e){}
}
<%
//判断此人今天是否需要签到提醒 判断依据 在线签到功能开启 工作日 不是管理员 在签到时间范围外
String isSignInOrSignOut="0";//是否启用前到签退功能  
String onlyworkday = "1";//只在工作日签到
String signTimeScope = "";//签到是时间范围  
boolean isWorkday=false;//是否工作日
boolean isSyadmin=false;//是否管理员
boolean inSignTimeScope = true;

//判断分权管理员
signRs.executeSql("select loginid from hrmresourcemanager where loginid = '"+user.getLoginid()+"'");
if(signRs.next()){
   isSyadmin = true;
}

signRs.executeSql("select needsign,onlyworkday, signTimeScope from hrmkqsystemSet ");
if(signRs.next()){
	isSignInOrSignOut = ""+signRs.getInt("needsign");
	onlyworkday = ""+signRs.getInt("onlyworkday");
	signTimeScope = ""+signRs.getString("signTimeScope");
}  	
HrmScheduleDiffUtil hrmScheduleDiffUtil = new HrmScheduleDiffUtil();
hrmScheduleDiffUtil.setUser(user);
isWorkday = hrmScheduleDiffUtil.getIsWorkday(CurrentDate);
if(onlyworkday.equals("0"))isWorkday=true;//如果非工作日也要签到

//签到时间范围
String begin_time =null;
String end_time =null;
if(signTimeScope.length()>0){
	String[] str = signTimeScope.split("-");
	begin_time = Tools.getCurrentDate()+" "+str[0]+":00";
	end_time = Tools.getCurrentDate()+" "+str[1]+":00";
	
	//判断是否在签到时间段内
	if(sign_flag.equals("2")){
		//任意时间都可以签退
	}else{
		if(TimeUtil.timeInterval(begin_time, nowtime)<0)inSignTimeScope=false;
		if(TimeUtil.timeInterval(nowtime, end_time)<0)inSignTimeScope=false;
	}
}
//System.out.println("isSignInOrSignOut=="+isSignInOrSignOut);
//System.out.println("isWorkday=="+isWorkday);
//System.out.println("isSyadmin=="+isSyadmin);
//System.out.println("inSignTimeScope=="+inSignTimeScope);
if(isSignInOrSignOut.equals("1")&&isWorkday&&!isSyadmin&&!inSignTimeScope&&ll<0){
%>
canSign();
<%}%>
</script> 
<script language="javascript">
//定时接收邮件
window.setInterval(function (){
	<%
	String isTimeOutLogin = Prop.getPropValue("Others","isTimeOutLogin");
	if("2".equals(isTimeOutLogin)){
	%>
	return false;
	<%}%>
	jQuery.post("/email/MailTimingDateReceiveOperation.jsp?"+new Date().getTime());
  },1000 * 60 * 5);
</script>
</html>
<script language="javascript" src="/js/Cookies_wev8.js"></script>

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



<!--[if IE 6]>
	<script type='text/javascript' src='/wui/common/jquery/plugin/8a-min_wev8.js'></script>
<![endif]-->
<!--[if IE 6]>	
	<script languange="javascript">
		DD_belatedPNG.fix('.toolbarBgSpan,.toolbarSplitLine,#searchbt,.searchBlockBgDiv,#toolbarMoreBlockTop,#toolbarBg,#tdMessageState img,background');
		//DD_belatedPNG.fix('#toolbarMoreBlockTop,background');
		jQuery("#tdMessageState").css("padding-top", "6px");
	</script>  
	<STYLE TYPE="text/css">
		
	</script>

<![endif]-->