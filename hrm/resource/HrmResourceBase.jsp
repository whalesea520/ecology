<%
//固定页面头部增加以下代码
weaver.system.CusFormSettingComInfo CusFormSettingComInfo = new weaver.system.CusFormSettingComInfo();
weaver.system.CusFormSetting CusFormSetting= CusFormSettingComInfo.getCusFormSetting("hrm","HrmResourceBase");
if(CusFormSetting!=null){
	if(CusFormSetting.getStatus()==1){
		//原页面
	}else if(CusFormSetting.getStatus()==2){
		//自定义布局页面
		request.getRequestDispatcher("/hrm/resource/HrmResourceBaseNew.jsp").forward(request, response);
		return;
	}else if(CusFormSetting.getStatus()==3){
		//自定义页面
		String page_url = CusFormSetting.getPage_url();
		request.getRequestDispatcher(page_url).forward(request, response);
		return;
	}
}
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,
                 weaver.file.Prop,
                 weaver.login.Account,
				 				 weaver.login.VerifyLogin,
                 weaver.general.GCONST,
                 weaver.docs.docs.CustomFieldManager" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.systeminfo.sysadmin.HrmResourceManagerVO"%>
<%@ page import="weaver.systeminfo.sysadmin.HrmResourceManagerDAO"%>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@ page import="weaver.hrm.tools.HrmValidate" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="DepartmentVirtualComInfo" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page"/>
<jsp:useBean id="SubCompanyVirtualComInfo" class="weaver.hrm.companyvirtual.SubCompanyVirtualComInfo" scope="page"/>
<jsp:useBean id="CostcenterComInfo" class="weaver.hrm.company.CostCenterComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="JobGroupsComInfo" class="weaver.hrm.job.JobGroupsComInfo" scope="page"/>
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page"/>
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page"/>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="CompetencyComInfo" class="weaver.hrm.job.CompetencyComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="BankComInfo" class="weaver.hrm.finance.BankComInfo" scope="page"/>
<jsp:useBean id="ContacterTitleComInfo" class="weaver.crm.Maint.ContacterTitleComInfo" scope="page"/>
<jsp:useBean id="RelatedRequestCount" class="weaver.workflow.request.RelatedRequestCount" scope="page"/>
<jsp:useBean id="UseKindComInfo" class="weaver.hrm.job.UseKindComInfo" scope="page"/>
<jsp:useBean id="JobTypeComInfo" class="weaver.hrm.job.JobTypeComInfo" scope="page"/>
<jsp:useBean id="JobCallComInfo" class="weaver.hrm.job.JobCallComInfo" scope="page"/>
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="HrmListValidate" class="weaver.hrm.resource.HrmListValidate" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="HrmResourceFile" class="weaver.hrm.tools.HrmResourceFile" scope="page"/>
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="strUtil" class="weaver.common.StringUtil" scope="page" />
<jsp:useBean id="ResourceBelongtoComInfo" class="weaver.hrm.resource.ResourceBelongtoComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<% if(!(user.getLogintype()).equals("1")) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
String id = Util.null2String(request.getParameter("id"));
if(id.equals("")) id=String.valueOf(user.getUID());
%>
<HTML><HEAD>
<base target="_blank" />
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/hrm/css/Contacts_wev8.css" rel="stylesheet" type="text/css" />
<link href="/hrm/css/Public_wev8.css" rel="stylesheet" type="text/css" />
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language="javascript" src="/qrcode/js/jquery.qrcode-0.7.0_wev8.js"></script>
<!--[if IE]> 
<script src="/qrcode/js/html5shiv_wev8.js"></script>
<script src="/qrcode/js/excanvas.compiled_wev8.js"></script>
<![endif]-->
<script type="text/javascript">
function onLog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
		var url = "";
	if(id && id!=""){
		url = "/systeminfo/SysMaintenanceLog.jsp?cmd=NOTCHANGE&condition=hidden&sqlwhere=<%=xssUtil.put("where operateitem=29 and relatedid=")%>&relatedid="+id;
	}else{
		url = "/systeminfo/SysMaintenanceLog.jsp?cmd=NOTCHANGE&condition=hidden&sqlwhere=<%=xssUtil.put("where operateitem=29")%>";
	}
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}
</script>
<style type="text/css">
div#leftInfo {height:100%; width:251px;float:left;}
div#rightInfo {height:100%; width:100%;}
div#rightHeadInfo {height:10%; width:100%; float:left;}
div#rightContianerInfo {height:100%; width:100%; float:left;}
</style>
</head>
<%
boolean hasQRCode = HrmListValidate.isValidate(37);
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);    

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
RecordSet.executeProc("HrmResource_SelectByID",id);
RecordSet.next();

String workcode = Util.toScreenToEdit(RecordSet.getString("workcode"),user.getLanguage()) ;	/*工号*/
String lastname = Util.toScreen(RecordSet.getString("lastname"),user.getLanguage()) ;			/*姓名*/
lastname = lastname.endsWith("\\")&&!lastname.endsWith("\\\\") == true ? lastname+ "\\" :lastname;
lastname = strUtil.replace(lastname, "'", "\\\\'");
String sex = Util.toScreen(RecordSet.getString("sex"),user.getLanguage()) ;
/*
性别:
0:男性
1:女性
2:未知
*/
String loginid = Util.toScreen(RecordSet.getString("loginid"),user.getLanguage()) ;
String departmentid = Util.toScreen(RecordSet.getString("departmentid"),user.getLanguage()) ;		/*所属部门*/
String costcenterid = Util.toScreen(RecordSet.getString("costcenterid"),user.getLanguage()) ;
String subcompanyid = Util.toScreen(RecordSet.getString("subcompanyid1"),user.getLanguage()) ;
if(subcompanyid==null||subcompanyid.equals("")||subcompanyid.equalsIgnoreCase("null"))
 subcompanyid="-1";
session.setAttribute("hrm_subCompanyId",subcompanyid);
/*所属成本中心*/
String jobtitle = Util.toScreen(RecordSet.getString("jobtitle"),user.getLanguage()) ;			/*岗位*/
String joblevel = Util.toScreen(RecordSet.getString("joblevel"),user.getLanguage()) ;			/*职级*/

String jobactivitydesc = Util.toScreen(RecordSet.getString("jobactivitydesc"),user.getLanguage()) ;	/*职责描述*/
String managerid = Util.toScreen(RecordSet.getString("managerid"),user.getLanguage()) ;			/*直接上级*/
String assistantid = Util.toScreen(RecordSet.getString("assistantid"),user.getLanguage()) ;		/*助理*/
String status = Util.toScreen(RecordSet.getString("status"),user.getLanguage()) ;

String locationid = Util.toScreen(RecordSet.getString("locationid"),user.getLanguage()) ;		/*办公地点*/
String workroom = Util.toScreen(RecordSet.getString("workroom"),user.getLanguage()) ;			/*办公室*/
String telephone = Util.toScreen(RecordSet.getString("telephone"),user.getLanguage()) ;			/*办公电话*/
//String mobile = Util.toScreen(RecordSet.getString("mobile"),user.getLanguage()) ;			/*移动电话*/

String mobile = ResourceComInfo.getMobileShow(id, user) ;			/*移动电话*/

String mobilecall = Util.toScreen(RecordSet.getString("mobilecall"),user.getLanguage()) ;		/*其他电话*/
String fax = Util.toScreen(RecordSet.getString("fax"),user.getLanguage()) ;				/*传真*/
String email = Util.toScreen(RecordSet.getString("email"),user.getLanguage()) ;				/*电邮*/

String resourceimageid = Util.getFileidOut(RecordSet.getString("resourceimageid")) ;	/*照片id 由SequenceIndex表得到，和使用它的表相关联*/
int systemlanguage = Util.getIntValue(RecordSet.getString("systemlanguage"),7);
String jobcall = Util.toScreenToEdit(RecordSet.getString("jobcall"),user.getLanguage()) ;	/*现职称*/
String resourcetype = Util.toScreen(RecordSet.getString("resourcetype"),user.getLanguage()) ;
int accounttype = Util.getIntValue(RecordSet.getString("accounttype"),0);			/*账号类型*/
/*
人力资源种类:
承包商: F
职员: H
学生: D
*/
String extphone = Util.toScreen(RecordSet.getString("extphone"),user.getLanguage()) ;		/*分机电话*/
String jobgroup= Util.toScreen(RecordSet.getString("jobgroup"),user.getLanguage()) ;		/*工作类别*/
String jobactivity= Util.toScreen(RecordSet.getString("jobactivity"),user.getLanguage()) ;	/*职责*/
String createrid = Util.toScreen(RecordSet.getString("createrid"),user.getLanguage()) ;		/*创建人id*/

String createdate = Util.toScreen(RecordSet.getString("createdate"),user.getLanguage()) ;	/*创建日期*/
String lastmodid = Util.toScreen(RecordSet.getString("lastmodid"),user.getLanguage()) ;		/*最后修改人id*/
String lastmoddate = Util.toScreen(RecordSet.getString("lastmoddate"),user.getLanguage()) ;	/*修改日期*/
String lastlogindate = Util.toScreen(RecordSet.getString("lastlogindate"),user.getLanguage()) ;	/*最后登录日期*/

String jobtype = Util.toScreenToEdit(RecordSet.getString("jobtype"),user.getLanguage()) ;	/*职务类别*/
String seclevel = Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage()) ;			/*安全级别*/

String datefield[] = new String[5] ;
String numberfield[] = new String[5] ;
String textfield[] = new String[5] ;
String tinyintfield[] = new String[5] ;

for(int k=1 ; k<6;k++) datefield[k-1] = RecordSet.getString("datefield"+k) ;
for(int k=1 ; k<6;k++) numberfield[k-1] = RecordSet.getString("numberfield"+k) ;
for(int k=1 ; k<6;k++) textfield[k-1] = RecordSet.getString("textfield"+k) ;
for(int k=1 ; k<6;k++) tinyintfield[k-1] = RecordSet.getString("tinyintfield"+k) ;
char flag=2;

RecordSet.executeProc("HrmResource_SCountBySubordinat",id);
RecordSet.next();
String subordinatescount = RecordSet.getString(1) ;


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

String creatername=Util.toScreen(ResourceComInfo.getResourcename(createrid),user.getLanguage());
String lastmodidname=Util.toScreen(ResourceComInfo.getResourcename(lastmodid),user.getLanguage());
creatername=creatername.length()>6?(creatername.substring(0,6)+"..."):creatername;
lastmodidname=lastmodidname.length()>6?(lastmodidname.substring(0,6)+"..."):lastmodidname;

String titlename="<B>"+SystemEnv.getHtmlLabelName(125,user.getLanguage())+":&nbsp;</B>"+createdate+"&nbsp;&nbsp;<b>"+SystemEnv.getHtmlLabelName(271,user.getLanguage())+":&nbsp;</b><A href=HrmResource.jsp?id="+createrid+" title="+Util.toScreen(ResourceComInfo.getResourcename(createrid),user.getLanguage())+">"+creatername+"</A>&nbsp;&nbsp;<B>"+SystemEnv.getHtmlLabelName(103,user.getLanguage())+":&nbsp;</B>"+lastmoddate+"&nbsp;&nbsp;<B>"+SystemEnv.getHtmlLabelName(424,user.getLanguage())+":&nbsp;</B><A href=HrmResource.jsp?id="+lastmodid+" title='"+Util.toScreen(ResourceComInfo.getResourcename(lastmodid),user.getLanguage())+"'>"+lastmodidname+"</A>&nbsp;&nbsp;";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<form name=resource action=HrmResourceOperation.jsp method=post >
<INPUT class=inputstyle id=BCValidate type=hidden value=0 name=BCValidate>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
//老的分权管理
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


if((isSelf||operatelevel>0)&&!status.equals("10")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:doedit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

if(HrmValidate.hasEmessage(user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(127379,user.getLanguage())+",javascript:sendEmessage(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
//added by lupeng 2004-07-08
if(HrmListValidate.isValidate(31)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(16635,user.getLanguage())+",javascript:openmessage(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
//end
if(HrmListValidate.isValidate(19)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(2051,user.getLanguage())+",javascript:openemail(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

if((isSelf||operatelevel>0)&&!status.equals("10")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(28062,user.getLanguage())+",javascript:setUserIcon(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

//修改密码
String mode=Prop.getPropValue(GCONST.getConfigFile() , "authentic");
if((isSelf&&!(mode!=null&&mode.equals("ldap")))){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(17993,user.getLanguage())+",/hrm/resource/HrmResourcePassword.jsp?isfromtab=true&id="+id+"&isView=1,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
	
//日志
if(HrmUserVarify.checkUserRight("HrmResource:Log",user,departmentid) ){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog("+id+"),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
//xiaofeng

//added by lupeng 2004-07-08
if(HrmListValidate.isValidate(32)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(18481,user.getLanguage())+",javascript:doAddWorkPlan(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
//end

if(HrmListValidate.isValidate(33)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(18034,user.getLanguage())+",javascript:doAddCoWork(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
}

/** 正式系统请删除Start */
List accounts=new VerifyLogin().getAccountsById(Integer.valueOf(id).intValue());
Iterator iter=null;
if(accounts!=null)     iter=  accounts.iterator();
Account current=new Account();
while(iter!=null&&iter.hasNext()){
Account a=(Account)iter.next();
if((""+a.getId()).equals(id))
current=a;
}
/** 正式系统请删除End */	
String navName="<font style=\"font-size: 16px\">"+lastname+"</font><font style=\"font-size: 12px\">";
if(sex.equals("0")) {
	navName += " ("+SystemEnv.getHtmlLabelName(28473,user.getLanguage())+")";
}else if(sex.equals("1")) {
	navName += " ("+SystemEnv.getHtmlLabelName(28474,user.getLanguage())+")";
}
if(workcode.length()>0){
	navName += " "+workcode+"  ";
}
navName +="<img src=\"/hrm/images/unit.png\">  ";
/*
if(jobtitle.length()>0){
	navName += " <a href=\"javascript:void(0)\" onclick=\"viewJobtitle("+jobtitle+");\" >"
					+Util.toScreen(JobTitlesComInfo.getJobTitlesname(jobtitle),user.getLanguage())+"</a>";
}
*/
navName += DepartmentComInfo.getAllParentDepartmentNames(departmentid,subcompanyid);
navName +="</font>";

//request.getSession().setAttribute("HrmResourceNavName",navName);
%>

<script type="text/javascript">
jQuery(window).resize(function(){
   jQuery("#leftInfo").height(jQuery(document.body).outerHeight(true));
   //jQuery("#rightInfo").width(jQuery(document.body).width()-252);
});

function createBQCode(){
	if(jQuery("#showBQRCodeDiv").is(":hidden"))
		jQuery("#showBQRCodeDiv").show();
	else
		jQuery("#showBQRCodeDiv").hide();
}

jQuery(document).ready(function(){
	jQuery('.information_detail').perfectScrollbar();
	parent.setTabObjName({objName:'<%=navName%>',isHtml:true});
	jQuery("#leftInfo").height(jQuery(document.body).outerHeight(true));
	
	//生成二维码	
	var	txt = "BEGIN:VCARD \n"+
	"VERSION:3.0 \n"+
	"N:<%=Util.toScreen(lastname,user.getLanguage())%> \n"+
	"TEL;CELL;VOICE:<%=mobile%> \n"+ 
	"TEL;WORK;VOICE:<%=telephone%> \n"+
	"EMAIL:<%=email%> \n"+
	"TITLE:<%=Util.toScreen(jobtitle,user.getLanguage())%> \n"+
	"ROLE:<%=Util.toScreen(DepartmentComInfo.getDepartmentmark(departmentid),user.getLanguage())%> \n"+
	"ADR;WORK:<%=Util.toScreen(LocationComInfo.getLocationname(locationid),user.getLanguage())%> \n"+
	"END:VCARD";
			
	jQuery('#showBQRCodeDiv').qrcode({
		render: 'canvas',
		background:"#ffffff",
		foreground:"#000000",
		msize:0.3,
		size:120,
		mode:0,
		//mode 1,2 二维码中插入lable、mode=3或4 二维码中插入 插入，注意IE8及以下版本不支持插图及labelmode设置无效
		label:'<%=lastname%>',
		image:"/images/hrm/weixin_wev8.png",
		text: utf16to8(txt)
	});
	
	jQuery.ajax({
          type:"post",
          dataType: 'json',
          url: "HrmResourceItemData.jsp?date="+new Date(),
          data: {"resourceid":'<%=id%>'},
          success: function(data){
           	jQuery.each(data, function(){
   					jQuery("#"+this.name).html(this.value);
   					jQuery("#"+this.name).attr("href", this.url);
   					jQuery("#"+this.name).attr("traget", "_blank");
           });
         },
				error: function(err){
					console.log(err);
				}
		});
	jQuery("#showBQRCodeDiv").hide();
});

function updateTop(){
	//更改divbg top
	jQuery("#divbg").css("top",jQuery("#resourceimage").height()-35);
}

function jsonerror(){
	if(jQuery("#sex").val()==0){
		jQuery("#resourceimage").attr("src","/images/messageimages/temp/man_wev8.png");	
		jQuery("#resourceimage").parent().attr("href","/images/messageimages/temp/man_wev8.png");
	}else if(jQuery("#sex").val()==1){
		jQuery("#resourceimage").attr("src","/images/messageimages/temp/women_wev8.png");	
		jQuery("#resourceimage").parent().attr("href","/images/messageimages/temp/women_wev8.png");
	}
}

function utf16to8(str) {                                         
  var out, i, len, c;                                          
  out = "";                                                    
  len = str.length;                                            
  for(i = 0; i < len; i++) {                                   
  c = str.charCodeAt(i);                                       
  if ((c >= 0x0001) && (c <= 0x007F)) {                        
      out += str.charAt(i);                                    
  } else if (c > 0x07FF) {                                     
      out += String.fromCharCode(0xE0 | ((c >> 12) & 0x0F));  
      out += String.fromCharCode(0x80 | ((c >>  6) & 0x3F));  
      out += String.fromCharCode(0x80 | ((c >>  0) & 0x3F));  
  } else {                                                    
      out += String.fromCharCode(0xC0 | ((c >>  6) & 0x1F));  
      out += String.fromCharCode(0x80 | ((c >>  0) & 0x3F));  
  }                                                           
  }                                                           
  return out;                                                 
}  

function setUserIcon(){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = encodeURI(encodeURI("/hrm/HrmDialogTab.jsp?_fromURL=GetUserIcon&isManager=1&userId=<%=id%>&subcompanyid=<%=subcompanyid%>&loginid=<%=loginid%>"));
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(28062,user.getLanguage())%>";
	dialog.Width = 600;
	dialog.Height = 450;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function viewJobtitle(jobtitle) {
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())+SystemEnv.getHtmlLabelName(6086,user.getLanguage())%>";
	url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmJobTitlesEdit&id="+jobtitle;
	dialog.Width = 700;
	dialog.Height = 593;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function jsShowtablemore(type){
	if(type==1){
		jQuery("#tablemore").show();
		jQuery("#trmore").hide();
	}else{
		jQuery("#tablemore").hide();
		jQuery("#trmore").show();
	}
}
</script>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<input id="sex" name="sex" type="hidden" value="<%=sex %>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if((isSelf||operatelevel>0)&&!status.equals("10")){ %>
			<input type=button class="e8_btn_top" onclick="doedit();" value="<%=SystemEnv.getHtmlLabelName(93, user.getLanguage())%>"></input>
			<%}if(HrmListValidate.isValidate(31)){%>
			<!-- 
			<input type=button class="e8_btn_top" onclick="openmessage();" value="<%=SystemEnv.getHtmlLabelName(16635, user.getLanguage())%>"></input>
			 -->
			<%}if(HrmUserVarify.checkUserRight("HrmMailMerge:Merge", user)){
			if(HrmListValidate.isValidate(19)){%>
				<!-- 
						<input type=button class="e8_btn_top" onclick="sendmail();" value="<%=SystemEnv.getHtmlLabelName(2051, user.getLanguage())%>"></input>
			 -->
			<%}}if(false&&HrmListValidate.isValidate(32)){%>
			<!-- 
			<input type=button class="e8_btn_top" onclick="doAddWorkPlan();" value="<%=SystemEnv.getHtmlLabelName(18481, user.getLanguage())%>"></input>
			 -->
			<%}if(false&&HrmListValidate.isValidate(33)){%>
			<!-- 
			<input type=button class="e8_btn_top" onclick="doAddCoWork();" value="<%=SystemEnv.getHtmlLabelName(18034, user.getLanguage())%>"></input>
			 -->
			<%} %>
		  <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<table style="width: 100%">
	<tr>
		<td style="width: 251px;vertical-align: top;border-right:solid 1px gray;border-color: #E6E6E6;">
		<div id="leftInfo">
		<table style="width:100%;padding-left: 10px;padding-right: 10px;padding-top: 10px">
			<tr>
				<td>
					<%if(!resourceimageid.equals("0") && resourceimageid.length()>0&&HrmListValidate.isValidate(36)){ %>
					<a href="/weaver/weaver.file.FileDownload?fileid=<%=resourceimageid%>" target="_blank">
						<img style="width: 100%;" id=resourceimage  src="/weaver/weaver.file.FileDownload?fileid=<%=resourceimageid%>" onLoad="updateTop()" onError="jsonerror()">
					</a>
					<%}else{
						String url = "";
						if(sex.equals("0")) {
							url = "/images/messageimages/temp/man_wev8.png";
						}else if(sex.equals("1")){
							url = "/images/messageimages/temp/women_wev8.png";
						} 
					%>
						<img style="width: 100%;" id=resourceimage  src="<%=url %>" onLoad="updateTop()">
					<%} %>
					<%if(hasQRCode){ %>
					<a href="javascript:void(0)" onclick="createBQCode();" style="position:absolute;top: 19px;left: 195px"><img src="/images/messageimages/temp/hrmqcode_wev8.png" width="40" height="40" style="vertical-align:middle;cursor: pointer;"></a>
					<div id="showBQRCodeDiv"  style="text-align: left;position:absolute;top: 14px;left: 120px; " onclick="createBQCode();"></div>	
					<%} %>
					<div id='divbg' style="position:absolute;top: 243px;background-image:url('/images/messageimages/temp/divbg_wev8.png');">
					<table style="width: 227px;height: 50px;text-align: center;vertical-align: middle;">
						<tr>
							<%if(HrmValidate.hasEmessage(user)){ %>
							<td><a href="javascript:void(0);" onclick="sendEmessage();return false;" title="<%=SystemEnv.getHtmlLabelName(127379,user.getLanguage())%>"><img src="/images/messageimages/temp/msn_wev8.png" onmouseover="javascript:this.src='/images/messageimages/temp/emessage_wev8.png';" onmouseout="javascript:this.src='/images/messageimages/temp/emessage_wev8.png';"></a></td>
							<%} %>
							<%if(HrmListValidate.isValidate(31)){ %>
							<td><a href="javascript:void(0);" onclick="openmessage();return false;" title="<%=SystemEnv.getHtmlLabelName(16635,user.getLanguage())%>"><img src="/images/messageimages/temp/msn_wev8.png" onmouseover="javascript:this.src='/images/messageimages/temp/msnhot_wev8.png';" onmouseout="javascript:this.src='/images/messageimages/temp/msn_wev8.png';"></a></td>
							<%}if(HrmListValidate.isValidate(19)){ %>
							<td><a href="javascript:void(0);" onclick="openemail();return false;" title="<%=SystemEnv.getHtmlLabelName(2051,user.getLanguage())%>"><img src="/images/messageimages/temp/email_wev8.png" onmouseover="javascript:this.src='/images/messageimages/temp/emailhot_wev8.png';" onmouseout="javascript:this.src='/images/messageimages/temp/email_wev8.png';"></a></td>
							<%}if(HrmListValidate.isValidate(32)){ %>
							<td><a href="javascript:void(0);" onclick="doAddWorkPlan()return false;;" title="<%=SystemEnv.getHtmlLabelName(18481,user.getLanguage())%>"><img src="/images/messageimages/temp/workplan_wev8.png" onmouseover="javascript:this.src='/images/messageimages/temp/workplanhot_wev8.png';" onmouseout="javascript:this.src='/images/messageimages/temp/workplan_wev8.png';"></a></td>
							<%}%>
						</tr>
					</table>
				</div>
				</td>
			</tr>
		</table>
		<table style="width:100%;padding-right: 10px;padding-left: 10px;">
			<%if(weaver.general.GCONST.getMOREACCOUNTLANDING()){%>
				<tr>
				<td style="border-bottom: 1px solid;border-color: #F3F2F2;background-color:#ffffff;height: 30px;font-size: 12px"><%=SystemEnv.getHtmlLabelName(17745,user.getLanguage())%>:
        	<%= accounttype==0?SystemEnv.getHtmlLabelName(17746,user.getLanguage()):SystemEnv.getHtmlLabelName(17747,user.getLanguage())%>
       	</td>
       	</tr>
       	<%
       	List lsUser = ResourceBelongtoComInfo.getBelongtousers(""+id);
       	if(lsUser!=null && lsUser.size()>0 && current.getType()==0){%>
       	<tr>
				<td style="border-bottom: 1px solid;border-color: #F3F2F2;background-color:#ffffff;height: 30px;font-size: 12px"><%=SystemEnv.getHtmlLabelName(17747,user.getLanguage())%>:
         <a href="/system/QuickSearchOperation.jsp?searchtype=2&belongto=<%=id %>" target="_blank"><%=lsUser.size()%></a>
       	</td>
       	</tr>
       	<%} %>
				<%if(current.getType()==1){%>
        <tr>
				<td style="border-bottom: 1px solid;border-color: #F3F2F2;background-color:#ffffff;height: 30px;font-size: 12px"><%=SystemEnv.getHtmlLabelName(17746,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%>:
         <%iter=accounts.iterator();
          while(accounts.size()>1&&iter.hasNext()){
              Account a=(Account)iter.next();
              if(a.getType()==0){
                  String subcompanyname=SubCompanyComInfo.getSubCompanyname(""+a.getSubcompanyid());
                  String departmentname=DepartmentComInfo.getDepartmentname(""+a.getDepartmentid());
                  String jobtitlename=JobTitlesComInfo.getJobTitlesname(""+a.getJobtitleid());
          %>
         <a href="/hrm/resource/HrmResource.jsp?id=<%=a.getId()%>" target="_blank"><%=subcompanyname+"/"+departmentname+"/"+jobtitlename%></a>
         <%}}%>
       	</td>
       	</tr>
     	 <%}}if(ResourceComInfo.getResourcename(managerid).length()>0){ %>
			<tr>
				<td style="border-bottom: 1px solid;border-color: #F3F2F2;background-color:#ffffff;height: 30px;font-size: 12px"><%=SystemEnv.getHtmlLabelName(15709,user.getLanguage())%>:
					<A href="HrmResource.jsp?id=<%=managerid%>" target="_blank"><%=Util.toScreen(ResourceComInfo.getResourcename(managerid),user.getLanguage())%></A>
       	</td>
     	</tr>
				<%}if(!subordinatescount.equals("0")){ %>
			<tr>
				<td style="border-bottom: 1px solid;border-color: #F3F2F2;background-color:#ffffff;height: 30px;font-size: 12px"><%=SystemEnv.getHtmlLabelName(442,user.getLanguage())%>:
          <A href="/hrm/HrmTab.jsp?_fromURL=HrmResourceView&id=<%=id%>" target="_blank"><%=subordinatescount%></A>
       	</td>
       	</tr>
				<%}if(ResourceComInfo.getResourcename(assistantid).length()>0){ %>
				<tr>
				<td style="border-bottom: 1px solid;border-color: #F3F2F2;background-color:#ffffff;height: 30px;font-size: 12px"><%=SystemEnv.getHtmlLabelName(441,user.getLanguage())%>:
					<A href="HrmResource.jsp?id=<%=assistantid%>" target="_blank"><%=Util.toScreen(ResourceComInfo.getResourcename(assistantid),user.getLanguage())%></A>
       	</td>
       	</tr>
				<%}if(status.length()>0){ %>
				<tr>
				<td style="border-bottom: 1px solid;border-color: #F3F2F2;background-color:#ffffff;height: 30px;font-size: 12px"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%>:
					 <%if(status.equals("0")){%><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%><%}%>
           <%if(status.equals("1")){%><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%><%}%>
           <%if(status.equals("2")){%><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%><%}%>
           <%if(status.equals("3")){%><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%><%}%>
           <%if(status.equals("4")){%><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%><%}%>
           <%if(status.equals("5")){%><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%><%}%>
           <%if(status.equals("6")){%><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%><%}%>
           <%if(status.equals("7")){%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%><%}%>
           <%if(status.equals("10")){%><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%><%}%>
       	</td>
       	</tr>
				<%}%>
    	 	<tr>
					<td style="border-bottom: 1px solid;border-color: #F3F2F2;background-color:#ffffff;height: 30px;font-size: 12px">
					<%=SystemEnv.getHtmlLabelName(16067,user.getLanguage())%>:<%=lastlogindate%>
				  </td>
				</tr>
     	 <%if(HrmListValidate.isValidate(38)){ %>
     	 <tr id='trmore'>
     	 	<td style="color: #B8B8B8;cursor: pointer;" onclick="jsShowtablemore(1)"><%=SystemEnv.getHtmlLabelName(83704,user.getLanguage())%>&nbsp;<img src="/images/messageimages/temp/more_wev8.png" title='<%=SystemEnv.getHtmlLabelName(83704,user.getLanguage())%>'></td>
     	 </tr>
     	 <tr>
     	 	<td id='tablemore' style="display: none">
					<table style="border-spacing: 0px;" width="100%">
					 <tr>
						<td style="border-bottom: 1px solid;border-color: #F3F2F2;background-color:#ffffff;height: 30px;font-size: 12px"><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%>:
					     	 		<A href=HrmResource.jsp?id=<%=createrid %> target="_blank" title="<%=Util.toScreen(ResourceComInfo.getResourcename(createrid),user.getLanguage())%>"><%=creatername %></A>
					  </td>
					 </tr>
					 <tr>
						<td style="border-bottom: 1px solid;border-color: #F3F2F2;background-color:#ffffff;height: 30px;font-size: 12px"><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%>:
					     	 		<%=createdate%>
					  </td>
					 </tr>
									<%if(lastmodid.length()>0){ %>
					 <tr>
						<td style="border-bottom: 1px solid;border-color: #F3F2F2;background-color:#ffffff;height: 30px;font-size: 12px"><%=SystemEnv.getHtmlLabelName(3002,user.getLanguage())%>:
								<A href=HrmResource.jsp?id=<%=lastmodid %> target="_blank" title="<%=Util.toScreen(ResourceComInfo.getResourcename(lastmodid),user.getLanguage()) %>"><%=lastmodidname %></A>
					  </td>
					 </tr>
					 <%}if(lastmoddate.length()>0){ %>			     	 	
						<tr>
							<td style="border-bottom: 1px solid;border-color: #F3F2F2;background-color:#ffffff;height: 30px;font-size: 12px"><%=SystemEnv.getHtmlLabelName(19521,user.getLanguage())%>:
									<%=lastmoddate%>
							</td>
						</tr>
				   <%} %>
			     	 <tr>
			     	 	<td style="color: #B8B8B8;cursor: pointer;" onclick="jsShowtablemore(2)"><%=SystemEnv.getHtmlLabelName(83705,user.getLanguage())%>&nbsp;<img src="/images/messageimages/temp/less_wev8.png" title='<%=SystemEnv.getHtmlLabelName(83705,user.getLanguage())%>'></td>
			     	 </tr>
					</table>
     	 	</td>
     	 </tr>
     	 <%} %>
		</table>
	</div>
		</td>
		<td style="vertical-align: top;">
			<div id="rightInfo">
		<div id="rightHeadInfo">
			<table style="width: 100%;height: 113px">
				<tr style="text-align: center;">
					<td>
						<table style="width: 100%;">
							<colgroup>
								<col width="50%">
								<col width="50%">
							</colgroup>
							<tr>
								<td style="text-align: right;"><img src="/images/hrm/workflowshow_wev8.png" title="<%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%>"></td>
								<td style="vertical-align: top;">
									<table style="border-collapse:collapse;border-spacing:0;">
										<tr>
											<td style="text-align: left;vertical-align: bottom;"><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%></td>
										</tr>
										<tr>
											<td style="text-align: left;font-size: 16px;vertical-align: bottom;">
												<a id="item_workflow" href="#" target="_blank"></a>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
					<td style="width: 1px;background: url('/images/hrm/splitline_wev8.png');"></td>
					<td>
						<table style="width: 100%;">
							<colgroup>
								<col width="50%">
								<col width="50%">
							</colgroup>
							<tr>
								<td style="text-align: right;"><img src="/images/hrm/wordshow_wev8.png" title="<%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>"></td>
								<td style="vertical-align: top;">
									<table style="border-collapse:collapse;border-spacing:0;">
										<tr>
											<td style="text-align: left;vertical-align: bottom;"><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></td>
										</tr>
										<tr>
											<td style="text-align: left;font-size: 16px;vertical-align: bottom;">
												<a id="item_word" href="#" target="_blank"></a>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
					<td style="width: 1px;background: url('/images/hrm/splitline_wev8.png');"></td>
					<td>
						<table style="width: 100%;">
							<colgroup>
								<col width="50%">
								<col width="50%">
							</colgroup>
							<tr>
								<td style="text-align: right;"><img src="/images/hrm/customshow_wev8.png" title="<%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%>"></td>
								<td style="vertical-align: top;">
									<table style="border-collapse:collapse;border-spacing:0;">
										<tr>
											<td style="text-align: left;vertical-align: bottom;"><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></td>
										</tr>
										<tr>
											<td style="text-align: left;font-size: 16px;vertical-align: bottom;">
												<a id="item_custom" href="#" target="_blank"></a>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
					<td style="width: 1px;background: url('/images/hrm/splitline_wev8.png');"></td>
					<td>
						<table style="width: 100%;">
							<colgroup>
								<col width="50%">
								<col width="50%">
							</colgroup>
							<tr>
								<td style="text-align: right;"><img src="/images/hrm/projectshow_wev8.png" title="<%=SystemEnv.getHtmlLabelName(22245,user.getLanguage())%>"></td>
								<td style="vertical-align: top;">
									<table style="border-collapse:collapse;border-spacing:0;">
										<tr>
											<td style="text-align: left;vertical-align: bottom;"><%=SystemEnv.getHtmlLabelName(22245,user.getLanguage())%></td>
										</tr>
										<tr>
											<td style="text-align: left;font-size: 16px;vertical-align: bottom;">
												<a id="item_project" href="#" target="_blank"></a>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
					<td style="width: 1px;background: url('/images/hrm/splitline_wev8.png');"></td>
					<td>
						<table style="width: 100%;">
							<colgroup>
								<col width="50%">
								<col width="50%">
							</colgroup>
							<tr>
								<td style="text-align: right;"><img src="/images/hrm/cptshow_wev8.png" title="<%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%>"></td>
								<td style="vertical-align: top;">
									<table style="border-collapse:collapse;border-spacing:0;">
										<tr>
											<td style="text-align: left;vertical-align: bottom;"><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></td>
										</tr>
										<tr>
											<td style="text-align: left;font-size: 16px;vertical-align: bottom;">
												<a id="item_cpt" href="#" target="_blank"></a>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
					<td style="width: 1px;background: url('/images/hrm/splitline_wev8.png');"></td>
					<td>
						<table style="width: 100%;">
							<colgroup>
								<col width="50%">
								<col width="50%">
							</colgroup>
							<tr>
								<td style="text-align: right;"><img src="/images/hrm/coworkshow_wev8.png" title="<%=SystemEnv.getHtmlLabelName(17855,user.getLanguage())%>"></td>
								<td style="vertical-align: top;">
									<table style="border-collapse:collapse;border-spacing:0;">
										<tr>
											<td style="text-align: left;vertical-align: bottom;"><%=SystemEnv.getHtmlLabelName(17855,user.getLanguage())%></td>
										</tr>
										<tr>
											<td style="text-align: left;font-size: 16px;vertical-align: bottom;">
												<a id="item_cowork" href="#" target="_blank"></a>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
					<td style="width: 1px;background: url('/images/hrm/splitline_wev8.png');"></td>
					<td>
						<table style="width: 100%;">
							<colgroup>
								<col width="50%">
								<col width="50%">
							</colgroup>
							<tr>
								<td style="text-align: right;"><img src="/images/hrm/weiboshow_wev8.png" title="<%=SystemEnv.getHtmlLabelName(26467,user.getLanguage())%>"></td>
								<td style="vertical-align: top;">
									<table style="border-collapse:collapse;border-spacing:0;">
										<tr>
											<td style="text-align: left;vertical-align: bottom;"><%=SystemEnv.getHtmlLabelName(26467,user.getLanguage())%></td>
										</tr>
										<tr>
											<td style="text-align: left;font-size: 16px;vertical-align: bottom;">
												<a id="item_weibo" href="#" target="_blank"></a>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</div>
		<div id="rightContianerInfo">
			<table style="width:100%;margin-top: -20px">
				<tr>
					<td style="border-bottom: 1px solid;border-color: #F3F2F2;">&nbsp;</td>
				</tr>
			</table>
			<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'groupOperDisplay':none}">
					<wea:item><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></wea:item>
					<wea:item>
						<A href="javascript:void(0)" onclick="viewJobtitle(<%=jobtitle %>);return false;" ><%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(jobtitle),user.getLanguage())%></A>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%></wea:item>
					<wea:item>
						<A href="/hrm/jobactivities/HrmJobActivitiesEdit.jsp?id=<%=JobTitlesComInfo.getJobactivityid(jobtitle)%>" target="_blank"><%=Util.toScreen(JobActivitiesComInfo.getJobActivitiesname(JobTitlesComInfo.getJobactivityid(jobtitle)),user.getLanguage())%></A>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(15708,user.getLanguage())%></wea:item>
					<wea:item><%=jobactivitydesc%></wea:item>    	
					<wea:item><%=SystemEnv.getHtmlLabelName(806,user.getLanguage())%></wea:item>
					<wea:item><%=Util.toScreen(JobCallComInfo.getJobCallname(jobcall),user.getLanguage())%></wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(1909,user.getLanguage())%></wea:item>
					<wea:item><%=joblevel%></wea:item>
				</wea:group>
				<%if(HrmListValidate.isValidate(39)){ %>
				<wea:group context='<%=SystemEnv.getHtmlLabelName(32938,user.getLanguage())%>' attributes="{'groupOperDisplay':none}">
					<wea:item><%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%></wea:item>
					<wea:item><%=mobile%></wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(15713,user.getLanguage())%></wea:item>
					<wea:item><%=telephone%></wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(15714,user.getLanguage())%></wea:item>
					<wea:item><%=mobilecall%></wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></wea:item>
					<wea:item><%=fax%></wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></wea:item>
					<wea:item><A href="mailto:<%=email%>" target="_blank"><%=email%></A></wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(15712,user.getLanguage())%></wea:item>
					<wea:item>
						<A href="/hrm/location/HrmLocationEdit.jsp?id=<%=locationid%>" target="_blank"><%=Util.toScreen(LocationComInfo.getLocationname(locationid),user.getLanguage())%></A>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(420,user.getLanguage())%></wea:item>
					<wea:item><%=workroom%></wea:item>
				</wea:group>
				<%} %>
				<%if(HrmListValidate.isValidate(40)){ %>
				<wea:group context='<%=SystemEnv.getHtmlLabelName(16169,user.getLanguage()) %>' attributes="{'groupOperDisplay':none}">
					<%
					boolean hasHrmDeartmentVirtual = false;
					rs.executeSql(" select count(*) from hrmdepartmentvirtual");
					if(rs.next()){
						if(rs.getInt(1)>0)hasHrmDeartmentVirtual = true;
					}
					if(hasHrmDeartmentVirtual&&false){
					%>
					<wea:item><%=SystemEnv.getHtmlLabelName(34101,user.getLanguage()) %></wea:item>
					<wea:item>
					<%
					//显示人员所在的多维组织
					rs.executeSql(" select subcompanyid, departmentid,managerid from hrmresourcevirtual where resourceid = "+id);
					while(rs.next()){
						String fulldepartmentname = SubCompanyVirtualComInfo.getSubCompanyname(rs.getString("subcompanyid"));
						fulldepartmentname +="-->"+DepartmentVirtualComInfo.getDepartmentname(rs.getString("departmentid"));
						if(Util.null2String(rs.getString("managerid")).length()>0){
							fulldepartmentname+="("+SystemEnv.getHtmlLabelName(15709,user.getLanguage())+":"+ResourceComInfo.getLastname(rs.getString("managerid"))+")";
						}
						out.println(fulldepartmentname+"<br>");
					}
					%>
					</wea:item>
					<%} %>
					<%--显示自定义的字段 start --%>
					<%
						boolean hasFF = true;
						rs2.executeProc("Base_FreeField_Select","hr");
						if(rs2.getCounts()<=0)
							hasFF = false;
						else
							rs2.first();
						
						if(hasFF){
							for(int i=1;i<=5;i++)
							{
								if(rs2.getString(i*2+1).equals("1") && datefield[i-1].length()>0)
								{%>
									<wea:item><%=rs2.getString(i*2)%></wea:item>
									<wea:item><%=datefield[i-1]%></wea:item>
						   	<%}
							}
							for(int i=1;i<=5;i++)
							{
								if(rs2.getString(i*2+11).equals("1") && numberfield[i-1].length()>0)
								{%>
									<wea:item><%=rs2.getString(i*2+10)%></wea:item>
									<wea:item><%=numberfield[i-1]%></wea:item>
						    <%}
							}
							for(int i=1;i<=5;i++)
							{
								if(rs2.getString(i*2+21).equals("1")&&textfield[i-1].length()>0 )
								{%>
									<wea:item><%=rs2.getString(i*2+20)%></wea:item>
									<wea:item><%=textfield[i-1]%></wea:item>
						   <%}
							}
							for(int i=1;i<=5;i++)
							{
								if(rs2.getString(i*2+31).equals("1")&&tinyintfield[i-1].length()>0)
								{%>
								<wea:item>
								<%=rs2.getString(i*2+30)%>
								</wea:item>
								<wea:item>
								<%if(tinyintfield[i-1].equals("1")){
									%> 是 <%	
								}else{%> 否 <%}%>&nbsp;
								</wea:item>
			         <%}
							}
						}
%>
<%--显示自定义的字段 end--%>
<%
    int scopeId = -1;
    CustomFieldManager cfm = new CustomFieldManager("HrmCustomFieldByInfoType",scopeId);
    cfm.getCustomFields();
    cfm.getCustomData(Util.getIntValue(id,0));
    while(cfm.next()){
        String fieldvalue = cfm.getData("field"+cfm.getId());
        if(!cfm.isUse())continue;
%>
			<wea:item><%=SystemEnv.getHtmlLabelNames(cfm.getLable(),user.getLanguage())%></wea:item>
			<wea:item>
      <%
        if(cfm.getHtmlType().equals("1")||cfm.getHtmlType().equals("2")){
      %>
      <%=fieldvalue%>
      <%
        }else if(cfm.getHtmlType().equals("3")){

        String fieldtype = String.valueOf(cfm.getType());
		    String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
		    String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
		    String showname = "";                                   // 新建时候默认值显示的名称
		    String showid = "";                                     // 新建时候默认值
		    if("161".equals(fieldtype) || "162".equals(fieldtype)) {
		    	url = url + "?type=" + cfm.getDmrUrl();
		    	if(!"".equals(fieldvalue)) {
			    	Browser browser=(Browser) StaticObj.getServiceByFullname(cfm.getDmrUrl(), Browser.class);
					try{
						String[] fieldvalues = fieldvalue.split(",");
						for(int i = 0;i < fieldvalues.length;i++) {
	                        BrowserBean bb=browser.searchById(fieldvalues[i]);
	                        String desc=Util.null2String(bb.getDescription());
	                        String name=Util.null2String(bb.getName());
	                        if(!"".equals(showname)) {
		                        showname += ",";
	                        }
	                        showname += name;
						}
					}catch (Exception e){}
		    	}
		    }

            if(fieldtype.equals("2") ||fieldtype.equals("19")){
                showname=fieldvalue; // 日期时间
            }else if(!fieldvalue.equals("")&& !("161".equals(fieldtype) || "162".equals(fieldtype))) {
                String tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
                String columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
                String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段
                String sql = "";

                HashMap temRes = new HashMap();
				//System.out.println(fieldtype+"================>");
                if(fieldtype.equals("152") || fieldtype.equals("17")|| fieldtype.equals("18")||fieldtype.equals("27")||fieldtype.equals("37")||fieldtype.equals("56")||fieldtype.equals("57")||fieldtype.equals("65")||fieldtype.equals("168")||fieldtype.equals("194")) {    // 多人力资源,多客户,多会议，多文档
                    sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
                }
                else {
                    sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+fieldvalue;
                }
				//System.out.println(sql);
                RecordSet.executeSql(sql);
                while(RecordSet.next()){
                    showid = Util.null2String(RecordSet.getString(1)) ;
                    String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
                    if(!linkurl.equals(""))
                        //showname += "<a href='"+linkurl+showid+"'>"+tempshowname+"</a> " ;
                        temRes.put(String.valueOf(showid),"<a href='"+linkurl+showid+"'>"+tempshowname+"</a> ");
                    else{
                        //showname += tempshowname ;
                        temRes.put(String.valueOf(showid),tempshowname);
                    }
                }
                StringTokenizer temstk = new StringTokenizer(fieldvalue,",");
                String temstkvalue = "";
                while(temstk.hasMoreTokens()){
                    temstkvalue = temstk.nextToken();

                    if(temstkvalue.length()>0&&temRes.get(temstkvalue)!=null){
                        showname += temRes.get(temstkvalue);
                    }
                }

            }


      %>
        <%=Util.toScreen(showname,user.getLanguage())%>
       <%
        }else if(cfm.getHtmlType().equals("4")){
       %>
        <input type=checkbox value=1 name="customfield<%=cfm.getId()%>" <%=fieldvalue.equals("1")?"checked":""%> disabled >
       <%
        }else if(cfm.getHtmlType().equals("5")){
            cfm.getSelectItem(cfm.getId());
       %>
       <%
            while(cfm.nextSelect()){
                if(cfm.getSelectValue().equals(fieldvalue)){
       %>
            <%=cfm.getSelectName()%>
       <%
                    break;
                }
            }
       %>
       <%
        }else if(cfm.getHtmlType().equals("6")){
        	String[] resourceFile = HrmResourceFile.getResourceFileView(id, scopeId, cfm.getId());
       %>
       <%=resourceFile[1]%>
       <!-- <span id="customfield<%=cfm.getId()%>span"><div nowrap></div></span> -->
       	
       <%} %>
					</wea:item>
       <%
    	}
       %>		
				</wea:group>
				<%} %>
			</wea:layout>
		</div>
	</div>
		</td>
	</tr>
</table>
<input type=hidden name=operation>
<input type=hidden name=id value="<%=id%>">
</form>
<iframe id="fileDownload" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<script language=javascript>
setUserId(<%=id%>);
   function doedit(){

    if(<%=operatelevel%>>0){
      location = "/hrm/resource/HrmResourceBasicEdit.jsp?isfromtab=true&id=<%=id%>&isView=1";
    }else{
        if(<%=isSelf%>){
          location = "/hrm/resource/HrmResourceContactEdit.jsp?isfromtab=true&id=<%=id%>&isView=1";
        }
    }
  }
  function dodelete(){
    if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
    document.resource.operation.value="delete";
    document.resource.submit();
    }
  }


  function sendmail(){
    var tmpvalue = "<%=email%>";
    while(tmpvalue.indexOf(" ") == 0)
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);
	if (tmpvalue=="" || tmpvalue.indexOf("@") <1 || tmpvalue.indexOf(".") <1 || tmpvalue.length <5) {
        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18779,user.getLanguage())%>");
        return;
    }
    openFullWindowForXtable("/sendmail/HrmMailMerge.jsp?id=<%=id%>");
  }
  
  function openemail()
{  
	openFullWindowForXtable("/email/MailAdd.jsp?isInternal=1&internalto="+userid);
}


function openmessage(){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/sms/SmsMessageEditTab.jsp?hrmid=<%=id%>&add=1";
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(16444,user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}


function doAddWorkPlan() {
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/workplan/data/WorkPlan.jsp?resourceid=<%=id%>&add=1";
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(18481,user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
	
}
function doAddCoWork(){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/cowork/AddCoWork.jsp?hrmid=<%=id%>";
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(18034,user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}

function downloads(files)
{ 
	$G("fileDownload").src="/weaver/weaver.file.FileDownload?fileid="+files+"&download=1";
}
function downloadsBatch(fieldvalue)
{ 
	$G("fileDownload").src="/weaver/weaver.file.FileDownload?fieldvalue="+fieldvalue+"&download=1&downloadBatch=1";
}
function opendoc(showid,versionid,docImagefileid)
{
	openFullWindowHaveBar("/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&isrequest=0");
}

function sendEmessage(){
	
	sendMsgToPCorWeb('<%=id%>','0','','');
}
</script>
</BODY>
</HTML>

