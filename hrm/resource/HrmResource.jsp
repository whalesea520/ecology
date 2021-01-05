
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.text.DateFormat"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,
                 weaver.file.Prop,
                 weaver.login.Account,
				 weaver.login.VerifyLogin,
                 weaver.general.GCONST" %>
<%@ page import="java.util.*" %>

<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.systeminfo.sysadmin.HrmResourceManagerVO"%>
<%@ page import="weaver.systeminfo.sysadmin.HrmResourceManagerDAO"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RelatedRequestCount" class="weaver.workflow.request.RelatedRequestCount" scope="page"/>
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="HrmListValidate" class="weaver.hrm.resource.HrmListValidate" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="MouldStatusCominfo" class="weaver.systeminfo.MouldStatusCominfo"></jsp:useBean>
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<% if(!(user.getLogintype()).equals("1")) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }

String id = Util.null2String(request.getParameter("id"));
if(id.equals("")) id=String.valueOf(user.getUID());

//如果不是来自HrmTab页，增加页面跳转
if(!Util.null2String(request.getParameter("fromHrmTab")).equals("1")){
	String url = "/hrm/HrmTab.jsp?_fromURL=HrmResource&id="+id;
	response.sendRedirect(url.toString()) ;
	return;
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/js/jquery/jquery-1.4.2.min_wev8.js"></script>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$('.e8_box').Tabs({
	  getLine:1,
	  iframe:"tabcontentframe"
	});	
});
function loading(){
  $("#loading").hide();
}
</script>
<style>
	#loading {
	Z-INDEX: 20001; BORDER-BOTTOM: #ccc 1px solid; POSITION: absolute; BORDER-LEFT: #ccc 1px solid; PADDING-BOTTOM: 8px; PADDING-LEFT: 8px; PADDING-RIGHT: 8px; BACKGROUND: #ffffff; HEIGHT: auto; BORDER-TOP: #ccc 1px solid; BORDER-RIGHT: #ccc 1px solid; PADDING-TOP: 8px; TOP: 40%; LEFT: 45%
}

</style>
</head>

<%
//int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);    
int isgoveproj = 0;   
if( id.equals("1") ) {
    if( user.getUID() == 1) {
        response.sendRedirect("/hrm/HrmTab.jsp?_fromURL=HrmSysAdminBasic") ;
        return ;
    }
    else {
        response.sendRedirect("/notice/hrmsystem.jsp") ;
        return ;
    }
}

//update by fanggsh TD4233 begin
HrmResourceManagerDAO dao = new HrmResourceManagerDAO();
HrmResourceManagerVO vo = dao.getHrmResourceManagerByID(id);

if(vo.getId()!=null&&!(vo.getId()).equals(""))
{
	if(vo.getId().equals(String.valueOf(id))){
        response.sendRedirect("/hrm/hrmTab.jsp?_fromURL=HrmResourcePassword&id="+id) ;
        return ;
	}else{
        response.sendRedirect("/notice/hrmsystem.jsp") ;
        return ;
	}
}
//update by fanggsh TD4233 end

//get request count
/*int tempid=Util.getIntValue(id,0);
RelatedRequestCount.resetParameter();
RelatedRequestCount.setUserid(user.getUID());
RelatedRequestCount.setUsertype(0);
RelatedRequestCount.setRelatedid(tempid);
RelatedRequestCount.setRelatedtype("hrmresource");
RelatedRequestCount.selectRelatedCount();
*/
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
RecordSet.executeProc("HrmResource_SelectByID",id);
RecordSet.next();


/*
性别:
0:男性
1:女性
2:未知
*/
String departmentid = Util.toScreen(RecordSet.getString("departmentid"),user.getLanguage()) ;		/*所属部门*/
String costcenterid = Util.toScreen(RecordSet.getString("costcenterid"),user.getLanguage()) ;
String subcompanyid = Util.toScreen(RecordSet.getString("subcompanyid1"),user.getLanguage()) ;
String lastname = Util.toScreen(RecordSet.getString("lastname"),user.getLanguage()) ;			/*姓名*/
if(subcompanyid==null||subcompanyid.equals("")||subcompanyid.equalsIgnoreCase("null"))
 subcompanyid="-1";
session.setAttribute("hrm_subCompanyId",subcompanyid);



/*
人力资源种类:
承包商: F
职员: H
学生: D
*/


String createrid = Util.toScreen(RecordSet.getString("createrid"),user.getLanguage()) ;		/*创建人id*/

String createdate = Util.toScreen(RecordSet.getString("createdate"),user.getLanguage()) ;	/*创建日期*/
String lastmodid = Util.toScreen(RecordSet.getString("lastmodid"),user.getLanguage()) ;		/*最后修改人id*/
String lastmoddate = Util.toScreen(RecordSet.getString("lastmoddate"),user.getLanguage()) ;	/*修改日期*/
String lastlogindate = Util.toScreen(RecordSet.getString("lastlogindate"),user.getLanguage()) ;	/*最后登录日期*/

String jobtype = Util.toScreenToEdit(RecordSet.getString("jobtype"),user.getLanguage()) ;	/*职务类别*/
String seclevel = Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage()) ;			/*安全级别*/


/*显示权限判断*/
int userid = user.getUID();

boolean isSelf		=	false;
boolean isManager	=	false;
boolean displayAll	=	false;
boolean isHr = false;

boolean isSys = ResourceComInfo.isSysInfoView(userid,id);
boolean isFin = ResourceComInfo.isFinInfoView(userid,id);
boolean isCap = ResourceComInfo.isCapInfoView(userid,id);
//boolean isCreater = ResourceComInfo.isCreaterOfResource(userid,id);

AllManagers.getAll(id);
if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user,departmentid)){
  isHr = true;
}
if(HrmUserVarify.checkUserRight("HrmResource:Display",user))  {
	displayAll		=	true;
}
/*
if(!((currentdate.compareTo(startdate)>=0 || startdate.equals(""))&& (currentdate.compareTo(enddate)<=0 || enddate.equals("")))){
	if (!displayAll){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
}
*/

if (id.equals(""+user.getUID()) ){
	isSelf = true;
}

while(AllManagers.next()){
	String tempmanagerid = AllManagers.getManagerID();
	if (tempmanagerid.equals(""+user.getUID())) {
		isManager = true;
	}
}

// 判定是否可以查看该人预算
boolean canviewbudget = HrmUserVarify.checkUserRight("FnaBudget:All",user, departmentid) ;
boolean caneditbudget =  HrmUserVarify.checkUserRight("FnaBudgetEdit:Edit", user) &&  (""+user.getUserDepartment()).equals(departmentid) ;
boolean canapprovebudget = HrmUserVarify.checkUserRight("FnaBudget:Approve",user) ;

boolean canlinkbudget = canviewbudget || caneditbudget || canapprovebudget || isSelf ;

// 判定是否可以查看该人收支
boolean canviewexpense = HrmUserVarify.checkUserRight("FnaTransaction:All",user, departmentid) ;
boolean canlinkexpense = canviewexpense || isSelf ;

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage());

titlename="<B>"+SystemEnv.getHtmlLabelName(125,user.getLanguage())+":&nbsp;</B>"+createdate+"&nbsp;&nbsp;<b>"+SystemEnv.getHtmlLabelName(271,user.getLanguage())+":&nbsp;</b><A href=HrmResource.jsp?id="+createrid+">"+Util.toScreen(ResourceComInfo.getResourcename(createrid),user.getLanguage())+"</A>&nbsp;&nbsp;<B>"+SystemEnv.getHtmlLabelName(103,user.getLanguage())+":&nbsp;</B>"+lastmoddate+"&nbsp;&nbsp;<B>"+SystemEnv.getHtmlLabelName(424,user.getLanguage())+":&nbsp;</B><A href=HrmResource.jsp?id="+lastmodid+">"+Util.toScreen(ResourceComInfo.getResourcename(lastmodid),user.getLanguage())+"</A>&nbsp;&nbsp;";
String needfav ="1";
String needhelp ="";
String newtitlename = SystemEnv.getHtmlLabelName(411,user.getLanguage())+":"+lastname;
%>
<BODY scroll="no"> 
<DIV style="" id=loading><SPAN><IMG align=absMiddle src="/images/loading2_wev8.gif"></SPAN> <SPAN id=loading-msg><%=SystemEnv.getHtmlLabelName(19945,user.getLanguage())%></SPAN> </DIV>
<%
	session.setAttribute("fav_pagename" , newtitlename ) ;	
%>
<%
//name-->url
LinkedHashMap<String,String> tabInfo = new LinkedHashMap<String,String>();

tabInfo.put(SystemEnv.getHtmlLabelName(1361,user.getLanguage()), "/hrm/resource/HrmResourceBase.jsp?isfromtab=true&id="+id);
tabInfo.put(SystemEnv.getHtmlLabelName(30804,user.getLanguage()), "/hrm/resource/HrmResourceTotal.jsp?isfromtab=true&id="+id);


/*
int detachable=0;
if(session.getAttribute("detachable")!=null){
    detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
}else{
    rs.executeSql("select detachable from SystemSet");
    if(rs.next()){
        detachable=rs.getInt("detachable");
        session.setAttribute("detachable",String.valueOf(detachable));
    }
}
*/

//人力资源模块是否开启了管理分权，如不是，则不显示框架，直接转向到列表页面(新的分权管理)
int hrmdetachable=0;
if(session.getAttribute("hrmdetachable")!=null){
    hrmdetachable=Util.getIntValue(String.valueOf(session.getAttribute("hrmdetachable")),0);
}else{
	boolean isUseHrmManageDetach=ManageDetachComInfo.isUseHrmManageDetach();
	if(isUseHrmManageDetach){
	   hrmdetachable=1;
	   session.setAttribute("detachable","1");
	   session.setAttribute("hrmdetachable",String.valueOf(hrmdetachable));
	}else{
	   hrmdetachable=0;
	   session.setAttribute("detachable","0");
	   session.setAttribute("hrmdetachable",String.valueOf(hrmdetachable));
	}
}

int operatelevel=-1;
if(hrmdetachable==1){
    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmResourceEdit:Edit",Integer.parseInt(subcompanyid));
}else{
    if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user))
        operatelevel=2;
}
int operatelevelnew = -1;
if(hrmdetachable==1){
	operatelevelnew=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"ResourcesInformationSystem:All",Integer.parseInt(subcompanyid));
}else{
    if(HrmUserVarify.checkUserRight("ResourcesInformationSystem:All", user))
    	operatelevelnew=2;
}

//xiaofeng
String mode=Prop.getPropValue(GCONST.getConfigFile() , "authentic");
if(isSelf&&HrmListValidate.isValidate(16)&&!(mode!=null&&mode.equals("ldap"))){
	tabInfo.put(SystemEnv.getHtmlLabelName(409,user.getLanguage()), "/hrm/resource/HrmResourcePassword.jsp?isfromtab=true&id="+id+"&isView=1");
	//arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(409,user.getLanguage())+"',url:'/hrm/resource/HrmResourcePassword.jsp?id="+id+"',id:'t409'}";
}
if(software.equals("ALL") || software.equals("HRM")){
     if((isSelf||operatelevel>=0)&&HrmListValidate.isValidate(11)){
    	 //arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(15687,user.getLanguage())+"',url:'/hrm/resource/HrmResourcePersonalView.jsp?id="+id+"',id:'t15687'}";
    	 tabInfo.put(SystemEnv.getHtmlLabelName(15687,user.getLanguage()), "/hrm/resource/HrmResourcePersonalView.jsp?isfromtab=true&id="+id);
     }
if((isSelf||isManager||operatelevel>=0)&&HrmListValidate.isValidate(12)){
	//arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(15688,user.getLanguage())+"',url:'/hrm/resource/HrmResourceWorkView.jsp?id="+id+"',id:'t15688'}";
	tabInfo.put(SystemEnv.getHtmlLabelName(15688,user.getLanguage()), "/hrm/resource/HrmResourceWorkView.jsp?isfromtab=true&id="+id);
 }
if(isgoveproj==0){
if((isSelf||operatelevel>=0||isFin || isManager)&&HrmListValidate.isValidate(13)){
	//arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(16480,user.getLanguage())+"',url:'/hrm/resource/HrmResourceFinanceView.jsp?id="+id+"&isView=1',id:'t16480'}";
	tabInfo.put(SystemEnv.getHtmlLabelName(16480,user.getLanguage()), "/hrm/resource/HrmResourceFinanceView.jsp?isfromtab=true&id="+id+"&isView=1");
}
}
if((isSelf||operatelevel>=0 || isCap)&&HrmListValidate.isValidate(14)&&"1".equals(MouldStatusCominfo.getStatus("cpt"))){
	//arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(15806,user.getLanguage())+"',url:'/cpt/search/SearchOperation.jsp?resourceid="+id+"&isdata=2',id:'t15806'}";
	tabInfo.put(SystemEnv.getHtmlLabelName(15806,user.getLanguage()), "/cpt/search/SearchOperation.jsp?resourceid="+id+"&isdata=2");
}
}
if((isSelf||operatelevelnew>=0||isSys)&&HrmListValidate.isValidate(15)){
	//arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(15804,user.getLanguage())+"',url:'/hrm/resource/HrmResourceSystemView.jsp?id="+id+"&isView=1',id:'t15804'}";
	tabInfo.put(SystemEnv.getHtmlLabelName(15804,user.getLanguage()), "/hrm/resource/HrmResourceSystemView.jsp?isfromtab=true&id="+id+"&isView=1");
}
if((isSelf || isManager || HrmUserVarify.checkUserRight("HrmResource:Workflow",user,departmentid))&&HrmListValidate.isValidate(17)){
	//arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(259,user.getLanguage())+"',url:'/workflow/request/RequestView.jsp?resourceid="+id+"',id:'t259'}";
	tabInfo.put(SystemEnv.getHtmlLabelName(259,user.getLanguage()), "/workflow/request/RequestView.jsp?resourceid="+id);
}
if((isSelf || isManager || HrmUserVarify.checkUserRight("HrmResource:Plan",user,departmentid))&&HrmListValidate.isValidate(18) ) {
	
	//arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(407,user.getLanguage())+"',url:'/workplan/data/WorkPlan.jsp?resourceid="+id+"',id:'t407'}";
	tabInfo.put(SystemEnv.getHtmlLabelName(407,user.getLanguage()), "/workplan/data/WorkPlan.jsp?resourceid="+id);
}
//added by lupeng 2004-07-08


if(HrmUserVarify.checkUserRight("HrmResource:Log",user,departmentid) ){
	if(HrmListValidate.isValidate(23)){
	    if(rs.getDBType().equals("db2")){
	        //arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"',url:'/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)=29 and relatedid="+id+"',id:'t83'}";
	        tabInfo.put(SystemEnv.getHtmlLabelName(83,user.getLanguage()), "/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)=29 and relatedid="+id );
	    }else{
			
			//arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"',url:'/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=29 and relatedid="+id+"',id:'t83'}";
			tabInfo.put(SystemEnv.getHtmlLabelName(83,user.getLanguage()), "/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=29 and relatedid="+id );
	    }
	}
	}
	if(isgoveproj==0){
		if(software.equals("ALL") || software.equals("HRM")){
		    if(isSelf || isManager || HrmUserVarify.checkUserRight("HrmResource:Absense",user,departmentid)) {
		        if(HrmListValidate.isValidate(20)){
							//arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(15880,user.getLanguage())+"',url:'/hrm/resource/HrmResourceAbsense.jsp?resourceid="+id+"',id:'t15880'}";
							tabInfo.put(SystemEnv.getHtmlLabelName(15880,user.getLanguage()), "/hrm/resource/HrmResourceAbsense.jsp?resourceid="+id);
		        }
		    }
		if(isSelf||isManager||HrmUserVarify.checkUserRight("HrmResource:TrainRecord",user)) {
			if(HrmListValidate.isValidate(21)){
				//arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(816,user.getLanguage())+"',url:'/hrm/resource/HrmResourceTrainRecord.jsp?resourceid="+id+"',id:'t816'}";
				tabInfo.put(SystemEnv.getHtmlLabelName(816,user.getLanguage()), "/hrm/resource/HrmResourceTrainRecord.jsp?resourceid="+id);
			}
		}
		if(isSelf||isManager||HrmUserVarify.checkUserRight("HrmResource:RewardsRecord",user)) {
			if(HrmListValidate.isValidate(22)){
				tabInfo.put(SystemEnv.getHtmlLabelName(16065,user.getLanguage()), "/hrm/resource/HrmResourceRewardsRecordView.jsp?id="+id);
				//arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(16065,user.getLanguage())+"',url:'HrmResourceRewardsRecord.jsp?resourceid="+id+"',id:'t16065'}";
			}
		}
	}
}
	


//判断该用户对编辑人员机构是否具有的角色维护权限(TD19119)
boolean rolesmanage = false;
int varifylevel=-1;
if(hrmdetachable==1){
    varifylevel = CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "HrmRolesEdit:Edit", Integer.parseInt(subcompanyid));
		if(varifylevel > 0) {
	   if(HrmUserVarify.checkUserRight("HrmRolesEdit:Edit", user)){
		   varifylevel=2;       
	   } else {
	       varifylevel=-1;
	   }
	}
}else{
    if(HrmUserVarify.checkUserRight("HrmRolesEdit:Edit", user))
        varifylevel=2;
}
if(varifylevel > 0) {
	rolesmanage = true;
}

if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user) && rolesmanage){
	//arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(16527,user.getLanguage())+"',url:'/hrm/roles/HrmResourceNewRoles.jsp?resourceid="+id+"',id:'t16527'}";
	tabInfo.put(SystemEnv.getHtmlLabelName(16527,user.getLanguage()), "/hrm/roles/HrmResourceNewRoles.jsp?resourceid="+id );
}

//取自定义标签页
String sql = " select id,name,tab_url from HrmListValidate "
					 + " where tab_type= 2 and validate_n = 1 "
					 + " order by tab_index asc " ;
rs.execute(sql);
while(rs.next())
{
	tabInfo.put(rs.getString("name"), rs.getString("tab_url")+"?id="+id);
}
%>
 <div class="e8_box">
      <ul class="tab_menu">
          <li class="e8_tree">
          <!-- 
          <a onclick="javascript:refreshTab();"><%=SystemEnv.getHtmlLabelName(20694,user.getLanguage()) %></a>
           -->
           
          </li>
          <%
					Iterator<Map.Entry<String,String>> iter = tabInfo.entrySet().iterator();
          String currentUrl = "";
          int index = 0;
					while (iter.hasNext()) {
					Map.Entry<String,String> entry = iter.next();
					String name = entry.getKey();
					String url = entry.getValue();
					if(index++==0)currentUrl=url;
          %>
           <li <%=index==1?"class=\"current\"":"" %>)>
            <a href="<%=url %>" target="tabcontentframe" onclick="$('#loading').show();">
             <%=name %>
             <span id="test"></span>
            </a>
           </li>
           <%} %>
      </ul>
     <div id="rightBox" class="e8_rightBox">
     </div>
     <div class="tab_box" style="padding-top: 2px">
         <div>
             <iframe src="<%=currentUrl %>" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;" onload="loading()"></iframe>
         </div>
     </div>
 </div>  
 <table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">

				<input type=button class="e8_btn_top" onclick="onSave(this);" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>

				<input type=button class="e8_btn_top" onclick="openDialog2(<%=id %>);" value="<%=SystemEnv.getHtmlLabelName(18418,user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</BODY>
</HTML>