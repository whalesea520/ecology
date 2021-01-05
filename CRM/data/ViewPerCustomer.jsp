
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="RecordSetFF" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetLog" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetEX" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />

<jsp:useBean id="CustomerDescComInfo" class="weaver.crm.Maint.CustomerDescComInfo" scope="page" />
<jsp:useBean id="CustomerSizeComInfo" class="weaver.crm.Maint.CustomerSizeComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ContactWayComInfo" class="weaver.crm.Maint.ContactWayComInfo" scope="page" />

<jsp:useBean id="TradeInfoComInfo" class="weaver.crm.Maint.TradeInfoComInfo" scope="page" />
<jsp:useBean id="CreditInfoComInfo" class="weaver.crm.Maint.CreditInfoComInfo" scope="page" />
<jsp:useBean id="DeliveryTypeComInfo" class="weaver.crm.Maint.DeliveryTypeComInfo" scope="page" />
<jsp:useBean id="PaymentTermComInfo" class="weaver.crm.Maint.PaymentTermComInfo" scope="page" />

<jsp:useBean id="SectorInfoComInfo" class="weaver.crm.Maint.SectorInfoComInfo" scope="page" />
<jsp:useBean id="CustomerRatingComInfo" class="weaver.crm.Maint.CustomerRatingComInfo" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>

<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page"/>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page"/>
<jsp:useBean id="ContacterTitleComInfo" class="weaver.crm.Maint.ContacterTitleComInfo" scope="page" />

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="RelatedRequestCount" class="weaver.workflow.request.RelatedRequestCount" scope="page"/>
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>

<jsp:useBean id="CoworkDAO" class="weaver.cowork.CoworkDAO" scope="page"/>

<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="page" />
<jsp:useBean id="SearchComInfo1" class="weaver.proj.search.SearchComInfo" scope="session" />

<jsp:useBean id="EvaluationLevelComInfo" class="weaver.crm.Maint.EvaluationLevelComInfo" scope="page" />

<jsp:useBean id="CustomerModifyLog" class="weaver.crm.data.CustomerModifyLog" scope="page"/>

<jsp:useBean id="ProjectTaskApprovalDetail" class="weaver.proj.Maint.ProjectTaskApprovalDetail" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<%--!
/**
 * @Date June 21,2004
 * @Author Charoes Huang
 * @Description 检测是否是个人用户
 */
	
	//xwj for td1552 on 2005-03-22
	
	private boolean isPerUser(String type){
		RecordSet rs = new RecordSet();
		String sqlStr ="Select * From CRM_CustomerType WHERE ID = "+type+" and candelete='n' and canedit='n' and fullname='个人用户'";
		rs.executeSql(sqlStr);
		if(rs.next()){
			return true;
		}
		return false;
	}
--%>

<%
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

char separator = Util.getSeparator() ;

String CustomerID = Util.null2String(request.getParameter("CustomerID"));
String message = Util.null2String(request.getParameter("message"));

int userid = user.getUID();
String logintype = ""+user.getLogintype();
int usertype = 0;
if(logintype.equals("2"))
	usertype= 1;

String Creater = "";
String CreaterType = "";
String CreateDate = "";
RecordSet.executeProc("CRM_Find_Creater",CustomerID);
if(RecordSet.first()){
	Creater = Util.toScreen(RecordSet.getString("submiter"),user.getLanguage());
	CreaterType = Util.toScreen(RecordSet.getString("submitertype"),user.getLanguage());
	CreateDate = RecordSet.getString("submitdate");
}

String Modifier = "";
String ModifierType = "";
String ModifyDate = "";
//RecordSet.executeProc("CRM_Find_LastModifier",CustomerID); Modified by xwj for td:1242 on 2005-03-16
String sqlModifier = "select submiter,submitdate,submitertype,submittime from CRM_Log " +
"where customerid ='" + CustomerID + "' and logtype <> 'n' and submitdate = (select max(submitdate) from CRM_Log where customerid ='" + CustomerID + "' and logtype <> 'n') " +
"order by submittime desc";
RecordSet.executeSql(sqlModifier);
if(RecordSet.first()){
	Modifier = Util.toScreen(RecordSet.getString("submiter"),user.getLanguage());
	ModifierType = Util.toScreen(RecordSet.getString("submitertype"),user.getLanguage());
	ModifyDate = RecordSet.getString("submitdate");
}
RecordSet.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
if(RecordSet.getCounts()<=0)
{
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
	return;
}
RecordSet.first();

String bankName = RecordSet.getString("bankName");
String accountName = RecordSet.getString("accountName");
String accounts = RecordSet.getString("accounts");
String crmCode = RecordSet.getString("crmcode");
String customerName = RecordSet.getString("name");

String type = RecordSet.getString("Type");
/*Added by Charoes Huang On June 21,2004*/

//if(isPerUser(type)){
	//response.sendRedirect("ViewPerCustomer.jsp?CustomerID="+CustomerID);
	//return;
//}


RecordSetShare.executeProc("CRM_ShareInfo_SbyRelateditemid",CustomerID);


/*check right begin*/

String useridcheck=""+user.getUID();
String customerDepartment=""+RecordSet.getString("department") ;

boolean canview=false;
boolean canedit=false;
boolean canviewlog=false;
boolean canmailmerge=false;
boolean isCustomerSelf=false;
boolean isCreater=false;
boolean canApply=false; //是否可以申请级别状态的变化
boolean canApplyPortal=false; //是否可以申请门户状态的变化
boolean canApplyPwd=false; //是否可以申请门户密码变化
boolean canApproveLevel=false; //是否可以批准级别变化
boolean canApprovePortal=false; //是否可以批准门户状态变化
boolean canApprovePwd=false; //是否可以批准门户密码变化

String levelMsg = ""; //级别申请中的显示信息
String portalMsg = ""; //门户申请中的显示信息
String portalPwdMsg = ""; //门户密码申请中的显示信息

String isrequest = Util.null2String(request.getParameter("isrequest")); //客户审批描述
String requestid = Util.null2String(request.getParameter("requestid")); //客户审批描述
requestid = requestid.equals("")?requestid="-1":requestid;
boolean hasApply = false;
boolean hasApplyPortal = false;
boolean hasApplyPwd = false;

String levelstatus = "";
String portalstatus = "";
String portalstatus2 = "";
String portalpwdstatus = "";
String levelMenu = "";
String portalMenu = "";
String portalpwdMenu = "";



RecordSetV.executeSql("select approvedesc,status from bill_ApproveCustomer where approvetype=1 and status<>'1' and status<>'0' and approveid="+CustomerID);
if(RecordSetV.next()){
    levelMsg = "（"+RecordSetV.getString("approvedesc")+"）";
    levelstatus = RecordSetV.getString("status");
    hasApply = true;
}
RecordSetV.executeSql("select approvedesc,status from bill_ApproveCustomer where approvetype=2 and status<>'1' and status<>'0' and approveid="+CustomerID);
if(RecordSetV.next()){
    portalMsg = "（"+RecordSetV.getString("approvedesc")+"）";
    portalstatus = RecordSetV.getString("status");
    hasApplyPortal = true;
}
RecordSetV.executeSql("select approvedesc,status from bill_ApproveCustomer where approvetype=3 and status<>'1' and status<>'0' and approveid="+CustomerID);
if(RecordSetV.next()){
    portalPwdMsg = "（"+RecordSetV.getString("approvedesc")+"）";
    portalpwdstatus = RecordSetV.getString("status");
    hasApplyPwd = true;
}


    if(isrequest.equals("1")){
        canApproveLevel=hasApply;
        canApprovePortal=hasApplyPortal;
        canApprovePwd=hasApplyPwd;
    }

    //取得客户审批工作流的信息
    String approveid= "" ;
    String approvetype= "" ;
    String approvevalue = "";
    String sql= "select approveid,approvevalue,approvetype from bill_ApproveCustomer where requestid="+requestid;
    RecordSetV.executeSql(sql);
    if(RecordSetV.next()){
        approveid=RecordSetV.getString("approveid");
        approvetype=RecordSetV.getString("approvetype");
        approvevalue = RecordSetV.getString("approvevalue");

    }


//String ViewSql="select * from CrmShareDetail where crmid="+CustomerID+" and usertype="+user.getLogintype()+" and userid="+user.getUID();

//RecordSetV.executeSql(ViewSql);

//if(RecordSetV.next())
//{
//	 canview=true;
//	 canviewlog=true;
//	 canmailmerge=true;
//	 if(RecordSetV.getString("sharelevel").equals("2")){
//		canedit=true;
//	 }else if (RecordSetV.getString("sharelevel").equals("3") || RecordSetV.getString("sharelevel").equals("4")){
//		canedit=true;
		
//	 }
//}

int sharelevel = CrmShareBase.getRightLevelForCRM(""+user.getUID(),CustomerID);
if(sharelevel>0){
     canview=true;
     canviewlog=true;
     canmailmerge=true;
     if(sharelevel>1) canedit=true;
}

if(user.getLogintype().equals("2") && CustomerID.equals(useridcheck)){
isCustomerSelf = true ;
}

if(useridcheck.equals(RecordSet.getString("agent"))) {
	 canview=true;
	 canedit=true;
	 canviewlog=true;
	 canmailmerge=true;
 }

if(RecordSet.getInt("status")==7 || RecordSet.getInt("status")==8){
	canedit=false;
}

if((RecordSet.getString("manager")).equals(useridcheck)){
	isCreater=true;
}

/*check right end*/



if(!canview && !isCustomerSelf && !CoworkDAO.haveRightToViewCustomer(Integer.toString(userid),CustomerID)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}



//写viewlog表
String needlog = Util.null2String(request.getParameter("log"));
if(!needlog.equals("n"))
{
char flag=Util.getSeparator() ;
String clientip=request.getRemoteAddr();
RecordSetLog.executeProc("CRM_ViewLog1_Insert",CustomerID+""+flag+userid+""+flag+user.getLogintype()+""+flag+CurrentDate+flag+CurrentTime+flag+clientip);
}


CustomerModifyLog.deleteCustomerLog(Util.getIntValue(CustomerID,-1),user.getUID());
%>


<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%@ include file="/docs/docs/DocCommExt.jsp"%>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(647,user.getLanguage())+" - "+Util.toScreen(customerName,user.getLanguage()).replace("\"","\\\"");
String newtitlename = titlename;
String temStr="";

   /* ------Modified by XWJ	for td:1242 on 2005-03-16 --------- begin ----------*/
if(!Creater.equals(""))	{
	temStr+="<B>"+SystemEnv.getHtmlLabelName(623,user.getLanguage())+":</B>"+ResourceComInfo.getClientDetailModifier(Creater,CreaterType,user.getLogintype())+"<B> "+SystemEnv.getHtmlLabelName(401,user.getLanguage())+":</B>";
	temStr+=CreateDate+"； ";
}
if(!Modifier.equals("")){
	temStr+="<B>"+SystemEnv.getHtmlLabelName(623,user.getLanguage())+":</B>"+ResourceComInfo.getClientDetailModifier(Modifier,ModifierType,user.getLogintype())+"<B> "+SystemEnv.getHtmlLabelName(103,user.getLanguage())+":</B>";
	temStr+=ModifyDate+"； ";
}

 /* ------Modified by XWJ	for td:1242 on 2005-03-16 --------- end ----------*/

titlename += "  "+temStr;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitleExt.jsp" %>
<%
	session.setAttribute("fav_pagename" , newtitlename ) ;	
%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>
<%
String requestPara = request.getQueryString(); 
String arrOtherTab="[";
arrOtherTab+="{	title:'"+SystemEnv.getHtmlLabelName(1361,user.getLanguage())+" ',url:'ViewPerCustomerBase.jsp?"+requestPara+"',id:'CustomerBase'}";
arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(352,user.getLanguage())+SystemEnv.getHtmlLabelName(351,user.getLanguage())+"',url:'ViewPerCustomerTotal.jsp?"+requestPara+"'}";
%>
<%
if(canviewlog){%>
<%
arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(103,user.getLanguage())+SystemEnv.getHtmlLabelName(264,user.getLanguage())+"',url:'/CRM/data/ViewLog.jsp?log=n&CustomerID="+CustomerID+"'}";
%><%}%>

<%if(!isCustomerSelf){
arrOtherTab+=",{id:'crmContract',title:'"+SystemEnv.getHtmlLabelName(6082,user.getLanguage())+"',url:'/CRM/data/ViewContactLog.jsp?log=n&CustomerID="+CustomerID+"&canedit="+canedit+"'}";
}
arrOtherTab+=",{id:'crmExchange',title:'"+SystemEnv.getHtmlLabelName(15153,user.getLanguage())+"',url:'/discuss/ViewExchange.jsp?types=CC&sortid="+CustomerID+"'}";
%>
<%
arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(110,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage())+"',url:'/CRM/data/ViewAddress.jsp?CustomerID="+CustomerID+"&canedit="+canedit+"'}";
%>

<!-- BUTTON class=btn  accessKey=S onclick='location.href="/sms/SmsMessageEdit.jsp?crmid=<%=RecordSetC.getString(1)%>"'><U>S</U>-发送短信</BUTTON -->
<%if(!isCustomerSelf){%>
<%
arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(2227,user.getLanguage())+"',url:'/CRM/sellchance/ListSellChance.jsp?CustomerID="+CustomerID+"'}";
%>
<%}%>
<%if(!user.getLogintype().equals("2")){%>
<%
arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(614,user.getLanguage())+"',url:'/CRM/data/ContractList.jsp?CustomerID="+CustomerID+"'}";

%>
<%}%>
<%if (canedit) {%>
<%
arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(6070,user.getLanguage())+"',url:'/CRM/data/GetEvaluation.jsp?CustomerID="+CustomerID+"'}";
arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(6061,user.getLanguage())+"',url:'/CRM/data/AddContacterLogRemind.jsp?CustomerID="+CustomerID+"'}";
%>
<%}%>
<%if (isCreater) {%>
<%
arrOtherTab+=",{title:'"+SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(216,user.getLanguage())+"',url:'/CRM/data/UniteCustomer.jsp?CustomerID="+CustomerID+"'}";
%>
<%}%>

<%
arrOtherTab+="]";
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script language=javascript>
var arrOtherTab=eval(<%=arrOtherTab%>);

function setTabPanelActive(panelId){
	
	Ext.getCmp('crmtabpanel').activate(panelId);
	
}
</script>
<script type="text/javascript" src="/js/crm/ViewCustomer_wev8.js"></script>
</BODY>
</HTML>