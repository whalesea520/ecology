<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util,weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetCT" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetCustomer" class="weaver.conn.RecordSet" scope="page" />

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
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="ProjectTaskApprovalDetail" class="weaver.proj.Maint.ProjectTaskApprovalDetail" scope="page"/>
	
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<!--<jsp:useBean id="WorkPlanShareBase" class="weaver.WorkPlan.WorkPlanShareBase" scope="page"/>-->
<%!
/**
 * @Date June 21,2004
 * @Author Charoes Huang
 * @Description 检测是否是个人用户
 */
	private boolean isPerUser(String type){
		RecordSet rs = new RecordSet();
		String sqlStr ="Select * From CRM_CustomerType WHERE ID = "+type+" and candelete='n' and canedit='n' and fullname='个人用户'";
		rs.executeSql(sqlStr);
		if(rs.next()){
			return true;
		}
		return false;
	}
%>

<%


Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

char separator = Util.getSeparator() ;

String CustomerID = Util.null2String(request.getParameter("CustomerID"));
int custoridss = 1;
//TD5394
String mailAddress = "";
String mailAddressContacter = "";
RecordSet.executeSql("SELECT email FROM CRM_CustomerContacter WHERE customerid="+CustomerID+"");
while(RecordSet.next()){
	mailAddressContacter = Util.null2String(RecordSet.getString("email"));
	if(!mailAddressContacter.equals("")){
		mailAddress += mailAddressContacter + ",";
	}
}


String message = Util.null2String(request.getParameter("message"));

int userid = user.getUID();
String logintype = ""+user.getLogintype();
logintype="1";  //表WorkPlanShareDetail usertype字段都是为1，所以，如果客户门户登陆的话，永远查询不到数据

int usertype = 0;
if(logintype.equals("2"))
	usertype= 1;
//get doc count


/*DocSearchComInfo.resetSearchInfo();
DocSearchComInfo.addDocstatus("1");
DocSearchComInfo.addDocstatus("2");
DocSearchComInfo.addDocstatus("5");
DocSearchComInfo.setCrmid(CustomerID);
String whereclause = " where " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;
DocSearchManage.getSelectResultCount(whereclause,user) ;
String doccount=""+DocSearchManage.getRecordersize();*/

//get cowork count
/*
int allCount = CoworkDAO.getAllCoworkCountByCustomerID(CustomerID);
int canViewCount = CoworkDAO.getCoworkCountByCustomerID(userid,CustomerID);
*/

//get request count
/*
int tempid=Util.getIntValue(CustomerID,0);
RelatedRequestCount.resetParameter();
RelatedRequestCount.setUserid(userid);
RelatedRequestCount.setUsertype(usertype);
RelatedRequestCount.setRelatedid(tempid);
RelatedRequestCount.setRelatedtype("crm");
RelatedRequestCount.selectRelatedCount();
*/

//get crm count
SearchComInfo1.resetSearchInfo();
SearchComInfo1.setcustomer(CustomerID);

/*String Prj_SearchSql="";
String prjcount="0";
Prj_SearchSql = "select count(*) from Prj_ProjectInfo  t1,PrjShareDetail t2 "+SearchComInfo1.FormatSQLSearch(user.getLanguage()) +" and t1.id = t2.prjid and t2.usertype="+user.getLogintype()+" and t2.userid="+user.getUID();
RecordSet.executeSql(Prj_SearchSql);
if(RecordSet.next()){
	prjcount = ""+RecordSet.getInt(1);
}*/

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

//TD5394
mailAddress = RecordSet.getString("email") +","+ mailAddress;
if(mailAddress.endsWith(",")) mailAddress=mailAddress.substring(0, mailAddress.length()-1);


String type = RecordSet.getString("Type");
/*Added by Charoes Huang On June 21,2004*/
if(type!=""){
  if(isPerUser(type)){
	   response.sendRedirect("ViewPerCustomerBase.jsp?CustomerID="+CustomerID);
	   return;
   }
}


RecordSetShare.executeProc("CRM_ShareInfo_SbyRelateditemid",CustomerID);


/*check right begin*/

String useridcheck=""+user.getUID();
String customerDepartment=""+RecordSet.getString("department") ;

boolean canview=false;
boolean canedit=false;
boolean canviewlog=false;
boolean canmailmerge=false;
boolean canapprove=false;
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
    //System.out.println("sql = " + sql);
    RecordSetV.executeSql(sql);
    if(RecordSetV.next()){
        approveid=RecordSetV.getString("approveid");
        approvetype=RecordSetV.getString("approvetype");
        approvevalue = RecordSetV.getString("approvevalue");

    }
    //System.out.println("approvevalue = " + approvevalue);


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
//		canapprove=true;
//	 }
//}

int sharelevel = CrmShareBase.getRightLevelForCRM(""+user.getUID(),CustomerID);
if(sharelevel>0){
     canview=true;
     canviewlog=true;
     canmailmerge=true;
     if(sharelevel==2) canedit=true;
     if(sharelevel==3||sharelevel==4){
         canedit=true;
         canapprove=true;
     }
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

if((RecordSet.getString("manager")).equals(""+ResourceComInfo.getManagerID(RecordSet.getString("manager")))){
	canapprove=true;
}


if((RecordSet.getString("manager")).equals(useridcheck)){
	isCreater=true;
    if(!hasApply){
        canApply=true; //只有客户的经理才可以申请升级、降级以及冻结和解冻操作
    }
    if(!hasApplyPortal){
        canApplyPortal = true; //只有客户的经理才可以申请开放门户、以及冻结和解冻操作
    }
    if(!hasApplyPwd){
        canApplyPwd = true; //只有客户的经理才可以申请重新生成密码
    }
}

/*check right end*/

portalstatus2 =  Util.getIntValue(RecordSet.getString("PortalStatus"),0)+"";
boolean onlyview=false;
if(!canview && !isCustomerSelf && !CoworkDAO.haveRightToViewCustomer(Integer.toString(userid),CustomerID)){
    if(!WFUrgerManager.UrgerHaveCrmViewRight(Util.getIntValue(requestid),userid,Util.getIntValue(logintype),CustomerID) && !WFUrgerManager.getMonitorViewObjRight(Util.getIntValue(requestid),userid,""+CustomerID,"1")){
        response.sendRedirect("/notice/noright.jsp") ;
        return ;
    }else{
        onlyview=true;
    }
}

RecordSetCT.executeProc("CRM_Find_CustomerContacter",CustomerID);

boolean hasFF = true;
RecordSetFF.executeProc("Base_FreeField_Select","c1");
if(RecordSetFF.getCounts()<=0)
	hasFF = false;
else
	RecordSetFF.first();

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


<%@page import="java.net.URLEncoder"%>
<HTML>
<HEAD>
<base target="_blank" />
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>

<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(647,user.getLanguage())+" - "+Util.toScreen(customerName,user.getLanguage());

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

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>


<%

String topage= URLEncoder.encode("/CRM/data/ViewCustomer.jsp?CustomerID="+CustomerID);
if(!onlyview){
if(canedit || isCustomerSelf){%>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:doEdit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

}%>

<%
if(canedit){
RCMenu += "{"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+SystemEnv.getHtmlLabelName(6082,user.getLanguage())+",/docs/docs/DocList.jsp?crmid="+CustomerID+"&isExpDiscussion=y,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>

<%if(!isCustomerSelf){%>
<%if(canmailmerge){%>
<%//TD5394
RCMenu += "{"+SystemEnv.getHtmlLabelName(2029,user.getLanguage())+",javascript:doAddEmail(),_top} " ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1226,user.getLanguage())+",javascript:urlSubmit(this,\\\"/sendmail/CrmMailMerge.jsp?customerid="+CustomerID+"\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%><%}%>
<%}%>
<%
if(levelstatus.equals("2")){
    levelMenu = SystemEnv.getHtmlLabelName(142,user.getLanguage())+"->"+SystemEnv.getHtmlLabelName(17288,user.getLanguage()); //批准->级别申请
}else{
    levelMenu = SystemEnv.getHtmlLabelName(615,user.getLanguage())+"->"+SystemEnv.getHtmlLabelName(17288,user.getLanguage()); //提交->级别申请
}
if(portalstatus.equals("2")){
    portalMenu = SystemEnv.getHtmlLabelName(142,user.getLanguage())+"->"+SystemEnv.getHtmlLabelName(1234,user.getLanguage()); //批准->门户申请
}else{
    portalMenu = SystemEnv.getHtmlLabelName(615,user.getLanguage())+"->"+SystemEnv.getHtmlLabelName(1234,user.getLanguage()); //提交->门户申请
}
if(portalpwdstatus.equals("2")){
    portalpwdMenu = SystemEnv.getHtmlLabelName(142,user.getLanguage())+"->"+SystemEnv.getHtmlLabelName(17289,user.getLanguage()); //批准->重设密码
}else{
    portalpwdMenu = SystemEnv.getHtmlLabelName(615,user.getLanguage())+"->"+SystemEnv.getHtmlLabelName(17289,user.getLanguage()); //提交->重设密码
}


%>
<%if(canApproveLevel && RecordSet.getInt("status")==1&&approvevalue.equals("2")){%>
<%
RCMenu += "{"+levelMenu+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&requestid="+requestid+"&method=ApproveLevel&Status=2&Rating=1\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%}%>
<%if(canApply && RecordSet.getInt("status")==1){%>
<%
RecordSetC.executeSql("select fullname from CRM_CustomerStatus where id = 2");
RecordSetC.next();
    //申请->基础客户
RCMenu += "{"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+RecordSetC.getString(1)+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&approvedesc="+customerName+":"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+RecordSetC.getString(1)+"&method=apply&Status=2&Rating=1\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>


<%if(canApproveLevel && RecordSet.getInt("status")==2&&approvevalue.equals("3")){%>
<%
RCMenu += "{"+levelMenu+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&requestid="+requestid+"&method=ApproveLevel&Status=3&Rating=1\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>
<%if(canApply && RecordSet.getInt("status")==2){%>
<%
RecordSetC.executeSql("select fullname from CRM_CustomerStatus where id = 3");
RecordSetC.next();
    //申请->潜在客户
RCMenu += "{"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+RecordSetC.getString(1)+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&approvedesc="+customerName+":"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+RecordSetC.getString(1)+"&method=apply&Status=3&Rating=1\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>


<%if(canApproveLevel && RecordSet.getInt("status")==3&&approvevalue.equals("4")){%>
<%
RCMenu += "{"+levelMenu+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&requestid="+requestid+"&method=ApproveLevel&Status=4&Rating=1\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>
<%if(canApply && RecordSet.getInt("status")==3){%>
<%
RecordSetC.executeSql("select fullname from CRM_CustomerStatus where id = 4");
RecordSetC.next();
    //申请->成功客户
RCMenu += "{"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+RecordSetC.getString(1)+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&approvedesc="+customerName+":"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+RecordSetC.getString(1)+"&method=apply&Status=4&Rating=1\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>


<%if(canApproveLevel && RecordSet.getInt("status")==4&&approvevalue.equals("5")){%>
<%
RCMenu += "{"+levelMenu+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&requestid="+requestid+"&method=ApproveLevel&Status=5&Rating="+RecordSet.getString("rating")+"\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>
<%if(canApproveLevel && RecordSet.getInt("status")==4&&approvevalue.equals("6")){%>
<%
RCMenu += "{"+levelMenu+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&requestid="+requestid+"&method=ApproveLevel&Status=6&Rating="+RecordSet.getString("rating")+"\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>
<%if(canApply && RecordSet.getInt("status")==4){%>
<%
RecordSetC.executeSql("select fullname from CRM_CustomerStatus where id = 5");
RecordSetC.next();
    //申请->试点客户
RCMenu += "{"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+RecordSetC.getString(1)+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&approvedesc="+customerName+":"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+RecordSetC.getString(1)+"&method=apply&Status=5&Rating="+RecordSet.getString("rating")+"\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RecordSetC.executeSql("select fullname from CRM_CustomerStatus where id = 6");
RecordSetC.next();
    //申请->典型客户
RCMenu += "{"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+RecordSetC.getString(1)+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&approvedesc="+customerName+":"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+RecordSetC.getString(1)+"&method=apply&Status=6&Rating="+RecordSet.getString("rating")+"\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>


<%if(canApproveLevel && RecordSet.getInt("status")==5&&approvevalue.equals("6")){%>
<%
RCMenu += "{"+levelMenu+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&requestid="+requestid+"&method=ApproveLevel&Status=6&Rating="+RecordSet.getString("rating")+"\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>
<%if(canApply && RecordSet.getInt("status")==5){%>
<%
RecordSetC.executeSql("select fullname from CRM_CustomerStatus where id = 6");
RecordSetC.next();
    //申请->典型客户
RCMenu += "{"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+RecordSetC.getString(1)+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&approvedesc="+customerName+":"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+RecordSetC.getString(1)+"&method=apply&Status=6&Rating="+RecordSet.getString("rating")+"\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>


<%if(canApproveLevel && RecordSet.getInt("status")==3&&approvevalue.equals("7")){%>
<%
RCMenu += "{"+levelMenu+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&requestid="+requestid+"&method=ApproveLevel&Status=7&Rating="+RecordSet.getString("rating")+"\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>
<%if(canApply && RecordSet.getInt("status")==3){%>
<%
    //申请->冻结
RCMenu += "{"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+SystemEnv.getHtmlLabelName(1232,user.getLanguage())+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&approvedesc="+customerName+":申请->冻结&method=apply&Status=7&Rating="+RecordSet.getString("rating")+"\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>


<%if(canApproveLevel && ( RecordSet.getInt("status")==4 || RecordSet.getInt("status")==5  || RecordSet.getInt("status")==6)&&approvevalue.equals("8")){%>
<%
RCMenu += "{"+levelMenu+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&requestid="+requestid+"&method=ApproveLevel&Status=8&Rating="+RecordSet.getString("rating")+"\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>
<%if(canApply && ( RecordSet.getInt("status")==4 || RecordSet.getInt("status")==5  || RecordSet.getInt("status")==6)){%>
<%
    //申请->冻结
RCMenu += "{"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+SystemEnv.getHtmlLabelName(1232,user.getLanguage())+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&approvedesc="+customerName+":申请->冻结&method=apply&Status=8&Rating="+RecordSet.getString("rating")+"\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>


<%if(canApproveLevel && RecordSet.getInt("status")==7&&approvevalue.equals("3")){%>
<%
RCMenu += "{"+levelMenu+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&requestid="+requestid+"&method=ApproveLevel&Status=3&Rating="+RecordSet.getString("rating")+"\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>
<%if(canApply && RecordSet.getInt("status")==7){%>
<%
    //申请->解冻
RCMenu += "{"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+SystemEnv.getHtmlLabelName(1233,user.getLanguage())+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&approvedesc="+customerName+":申请->解冻&method=apply&Status=3&Rating="+RecordSet.getString("rating")+"\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>


<%if(canApproveLevel && RecordSet.getInt("status")==8&&approvevalue.equals("4")){%>
<%
RCMenu += "{"+levelMenu+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&requestid="+requestid+"&method=ApproveLevel&Status=4&Rating="+RecordSet.getString("rating")+"\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>
<%if(canApply && RecordSet.getInt("status")==8){%>
<%
    //申请->解冻
RCMenu += "{"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+SystemEnv.getHtmlLabelName(1233,user.getLanguage())+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&approvedesc="+customerName+":申请->解冻&method=apply&Status=4&Rating="+RecordSet.getString("rating")+"\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>


<%//状态倒回%>
<%if(canApproveLevel && RecordSet.getInt("status")==2&&approvevalue.equals("1")){%>
<%
RCMenu += "{"+levelMenu+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&requestid="+requestid+"&method=ApproveLevel&Status=1&Rating=1\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>
<%if(canApply && RecordSet.getInt("status")==2){%>
<%
RecordSetC.executeSql("select fullname from CRM_CustomerStatus where id = 1");
RecordSetC.next();
    //申请->无效客户
RCMenu += "{"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+RecordSetC.getString(1)+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&approvedesc="+customerName+":"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+RecordSetC.getString(1)+"&method=apply&Status=1&Rating=1\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>


<%if(canApproveLevel && RecordSet.getInt("status")==3&&approvevalue.equals("2")){%>
<%
RCMenu += "{"+levelMenu+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&requestid="+requestid+"&method=ApproveLevel&Status=2&Rating=1\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>
<%if(canApply && RecordSet.getInt("status")==3){%>
<%
RecordSetC.executeSql("select fullname from CRM_CustomerStatus where id = 2");
RecordSetC.next();
    //申请->基础客户
RCMenu += "{"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+RecordSetC.getString(1)+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&approvedesc="+customerName+":"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+RecordSetC.getString(1)+"&method=apply&Status=2&Rating=1\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>
<%--退回菜单--%>
<%if(canApproveLevel&&levelstatus.equals("2")){%>
<%
    //退回->级别申请
RCMenu += "{"+SystemEnv.getHtmlLabelName(236,user.getLanguage())+"->"+SystemEnv.getHtmlLabelName(17288,user.getLanguage())+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&requestid="+requestid+"&method=RejectLevel\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>

<%if(isPortalOK){%><!--portal begin-->
<%if(canApprovePortal && portalstatus2.equals("0") && RecordSet.getInt("status")>=3){%>
<%
    //门户批准
RCMenu += "{"+portalMenu+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&requestid="+requestid+"&method=ApprovePortal&PortalStatus=2\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>
<%if(canApplyPortal && portalstatus2.equals("0") && RecordSet.getInt("status")>=3){%>
<%
    //门户申请
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1234,user.getLanguage())+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&approvedesc="+customerName+":门户申请&method=portal&PortalStatus=2\\\"),_top} " ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1234,user.getLanguage())+",javascript:applyPortalManager(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&approvedesc="+customerName+":门户申请&method=portal&PortalStatus=2\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>



<%if(canApprovePortal && portalstatus2.equals("2") && RecordSet.getInt("status")>=3){%>
<%
RCMenu += "{"+portalMenu+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&requestid="+requestid+"&method=ApprovePortal&PortalStatus=3\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>
<%if(canApplyPortal && portalstatus2.equals("2") && RecordSet.getInt("status")>=3){%>
<%
    //申请->门户冻结
RCMenu += "{"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+SystemEnv.getHtmlLabelName(1236,user.getLanguage())+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&approvedesc="+customerName+":申请->门户冻结&method=portal&PortalStatus=3\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>


<%if(canApprovePortal && portalstatus2.equals("3") && RecordSet.getInt("status")>=3){%>
<%
RCMenu += "{"+portalMenu+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&requestid="+requestid+"&method=ApprovePortal&PortalStatus=2\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>
<%if(canApplyPortal && portalstatus2.equals("3") && RecordSet.getInt("status")>=3){%>
<%
    //申请->门户激活
RCMenu += "{"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+SystemEnv.getHtmlLabelName(1237,user.getLanguage())+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&approvedesc="+customerName+":申请->门户激活&method=portal&PortalStatus=2\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>
<%--退回菜单--%>
<%if(canApprovePortal&&portalstatus.equals("2")){%>
<%
    //退回->门户申请
RCMenu += "{"+SystemEnv.getHtmlLabelName(236,user.getLanguage())+"->"+SystemEnv.getHtmlLabelName(1234,user.getLanguage())+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&requestid="+requestid+"&method=RejectPortal\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>

<%if(canApprovePwd && portalstatus2.equals("2") && RecordSet.getInt("status")>=3){%>
<%
RCMenu += "{"+portalpwdMenu+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&requestid="+requestid+"&method=ApprovePwd&PortalStatus=2\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>
<%if(canApplyPwd && portalstatus2.equals("2") && RecordSet.getInt("status")>=3){%>
<%
    //申请->重设密码
//RCMenu += "{"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+SystemEnv.getHtmlLabelName(17289,user.getLanguage())+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&approvedesc="+customerName+":申请->重设密码&method=portalPwd&PortalStatus=2\\\"),_top} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>
<%--退回菜单--%>
<%if(canApprovePwd&&portalpwdstatus.equals("2")){%>
<%
    //退回->重设密码
RCMenu += "{"+SystemEnv.getHtmlLabelName(236,user.getLanguage())+"->"+SystemEnv.getHtmlLabelName(17289,user.getLanguage())+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+CustomerID+"&requestid="+requestid+"&method=RejectPwd\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>
<%}%><!--portal end-->

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1239,user.getLanguage())+",javascript:document.workflow.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
if(!isCustomerSelf){
RCMenu += "{"+SystemEnv.getHtmlLabelName(17859,user.getLanguage())+",javascript:document.addCoWork.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
}
%>
<!-- BUTTON class=btn  accessKey=S onclick='location.href="/sms/SmsMessageEdit.jsp?crmid=<%=RecordSetC.getString(1)%>"'><U>S</U>-发送短信</BUTTON -->
<%if(!isCustomerSelf){%>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(2227,user.getLanguage())+",javascript:location.href='/CRM/sellchance/ListSellChance.jsp?CustomerID="+CustomerID+"',_top} " ;
//RCMenuHeight += RCMenuHeightStep ;

%>
<%}%>
<%if(!user.getLogintype().equals("2")){%>
<% 
//RCMenu += "{"+SystemEnv.getHtmlLabelName(614,user.getLanguage())+",javascript:location.href='/CRM/data/ContractList.jsp?CustomerID="+CustomerID+"',_top} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>

<%
if(!isCustomerSelf){
RCMenu += "{"+SystemEnv.getHtmlLabelName(16426,user.getLanguage())+",javascript:doAddWorkPlan(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
}
}
%>

<%
	
/**
 * 修改密码，前提条件：客户开启了客户门户且操作者为客户经理
 **/
String customerInfoSql = "SELECT PortalStatus  , Manager FROM CRM_CustomerInfo WHERE id = "+CustomerID;
RecordSetCustomer.executeSql(customerInfoSql);
RecordSetCustomer.next();
int PortalStatus = RecordSetCustomer.getInt("PortalStatus");
int Manager = RecordSetCustomer.getInt("Manager");

if(2 == PortalStatus &&  userid == Manager){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(17993,user.getLanguage())+",javascript:editPassword(0),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<div id="divBase">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE width="100%">
<tr>
<td valign="top">

<form name=workflow method=post action ="/workflow/request/RequestType.jsp">
	<input type=hidden name=topage value='<%=topage%>'>
	<input type=hidden name=crmid value='<%=CustomerID%>'>

</form>
<form name=addCoWork method=post action ="/cowork/AddCoWork.jsp">
	<input type=hidden name=CustomerID value='<%=CustomerID%>'>

</form>
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="49%">
  <COL width=10>
  <COL width="49%">
  <TBODY>
  <TR>

	<TD vAlign=top>

	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2>
            <%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%>
            <%if(message.equals("1")){%>
            <font color=red>此客户类型没有相关的审批流程</font>
            <%}%>
            </TH>
          </TR>
        <TR class=Spacing  style="height: 1px">
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <!--add CRM CODE by lupeng 2004.03.30-->
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(17080,user.getLanguage())%></TD>
          <TD class=Field><%=Util.toScreenToEdit(crmCode, user.getLanguage())%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(642,user.getLanguage())%>）</TD>
          <TD class=Field><%=Util.toScreen(RecordSet.getString("engname"),user.getLanguage())%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>1</TD>
          <TD class=Field><%=Util.toScreen(RecordSet.getString("address1"),user.getLanguage())%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>2&nbsp;</TD>
          <TD class=Field><%=Util.toScreen(RecordSet.getString("address2"),user.getLanguage())%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>3&nbsp;</TD>
          <TD class=Field><%=Util.toScreen(RecordSet.getString("address3"),user.getLanguage())%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(479,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></TD>
          <TD class=Field><%=RecordSet.getString("zipcode")%>  <%=CityComInfo.getCityname(RecordSet.getString("city"))%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(643,user.getLanguage())%></TD>
          <TD class=Field><%=CountryComInfo.getCountrydesc(RecordSet.getString("country"))%>  <%=ProvinceComInfo.getProvincename(RecordSet.getString("province"))%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(644,user.getLanguage())%></TD>
          <TD class=Field><%=Util.toScreen(RecordSet.getString("county"),user.getLanguage())%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%></TD>
          <TD class=Field><%=Util.toScreen(LanguageComInfo.getLanguagename(RecordSet.getString("language")),user.getLanguage())%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></TD>
          <TD class=Field><%=RecordSet.getString("phone")%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></TD>
          <TD class=Field><%=RecordSet.getString("fax")%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></TD>
          <TD class=Field><a href="mailto:<%=RecordSet.getString("email")%>"><%=Util.toScreen(RecordSet.getString("email"),user.getLanguage())%></a></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(76,user.getLanguage())%></TD>
          <TD class=Field><a href="<%=RecordSet.getString("website")%>"><%=Util.toScreen(RecordSet.getString("website"),user.getLanguage())%></a></TD>
        </TR>
          <tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <!-- 介绍 -->
         <TR>
          <TD><%=SystemEnv.getHtmlLabelName(634,user.getLanguage())%></TD>
        
          <TD class=Field  ><%=RecordSet.getString("introduction")%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <!-- /介绍 -->
        
        
        
     
        </TBODY>
	  </TABLE>
	   <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=Title>
            <TH colspan = 2><%=SystemEnv.getHtmlLabelName(15125,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing  style="height: 1px">
          <TD class=Line1 colSpan=2></TD></TR>
<%if(!user.getLogintype().equals("2")){%>
        <TR>
		<TD><%=SystemEnv.getHtmlLabelName(6097,user.getLanguage())%></TD>
		<TD class=Field><%=RecordSet.getString("CreditAmount")%></TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(6098,user.getLanguage())%></TD>
		<TD class=Field><%=RecordSet.getString("CreditTime")%></TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>

		<%
		String sqlStr = "select sum(t1.payPrice-t1.factPrice) from CRM_ContractPayMethod t1 , CRM_Contract t2 where t1.contractId = t2.id and t2.crmId = " + CustomerID + " and t2.status = 2 and t1.typeId = 1 and t1.isFinish = 1 and t1.payDate <= '" + CurrentDate + "'";
		 RecordSetM.executeSql(sqlStr);
		 RecordSetM.next();
		 double	passCreditAmount = 0;
		 passCreditAmount = Util.getDoubleValue(RecordSetM.getString(1),0);
		 //out.print(sqlStr+"<BR>");

		 if (passCreditAmount>0) {%>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(15162,user.getLanguage())%></TD>
		<TD class=Field><%if(passCreditAmount > Util.getDoubleValue(RecordSet.getString("CreditAmount"),0)) {%><span class=fontred><%=passCreditAmount%></span><%} else {%><%=passCreditAmount%><%}%></TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<%}%>

		<%

		if(RecordSet.getDBType().equals("oracle")){
			sqlStr = "select * from (select t1.* from CRM_ContractPayMethod t1 , CRM_Contract t2 where t1.contractId = t2.id and t2.crmId = " + CustomerID + " and t2.status = 2 and t1.typeId = 1 and t1.isFinish = 1 and t1.payDate <= '" + CurrentDate + "' order by t1.payDate asc ) where rownum=1";
		}else if(RecordSet.getDBType().equals("db2")){
			sqlStr = "select t1.* from CRM_ContractPayMethod t1 , CRM_Contract t2 where t1.contractId = t2.id and t2.crmId = " + CustomerID + " and t2.status = 2 and t1.typeId = 1 and t1.isFinish = 1 and t1.payDate <= '" + CurrentDate + "' order by t1.payDate asc fetch first 1 rows only";
		}else{
			sqlStr = "select top 1 t1.* from CRM_ContractPayMethod t1 , CRM_Contract t2 where t1.contractId = t2.id and t2.crmId = " + CustomerID + " and t2.status = 2 and t1.typeId = 1 and t1.isFinish = 1 and t1.payDate <= '" + CurrentDate + "' order by t1.payDate asc";
		}
		 RecordSetM.executeSql(sqlStr);
		 if (RecordSetM.next()) {

			String payDateTemp01 = RecordSetM.getString("payDate");
			Calendar Todaydate = Calendar.getInstance();
			int ThisYear = Util.getIntValue(payDateTemp01.substring(0,4));
			int ThisMonth = Util.getIntValue(payDateTemp01.substring(5,7))-1;
			int ThisDay = Util.getIntValue(payDateTemp01.substring(8,10));
			Todaydate.set(ThisYear,ThisMonth,ThisDay);
			Todaydate.add(Calendar.DATE,Util.getIntValue(RecordSet.getString("CreditTime"),0));
			String payDateTemp02=Util.add0(Todaydate.get(Calendar.YEAR), 4) +"-"+
			Util.add0(Todaydate.get(Calendar.MONTH) + 1, 2) +"-"+
			Util.add0(Todaydate.get(Calendar.DAY_OF_MONTH), 2) ;

		%>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(15163,user.getLanguage())%></TD>
		<TD class=Field><%if (payDateTemp02.compareTo(CurrentDate)<0) {%><span class=fontred><%=payDateTemp01%></span><%} else {%><%=payDateTemp01%><%}%></TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<%}%>

<%}%>
         <TR>
          <TD><%=SystemEnv.getHtmlLabelName(17084,user.getLanguage())%></TD>
          <TD class=Field><%=Util.toScreen(bankName,user.getLanguage())%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(571,user.getLanguage())%></TD>
          <TD class=Field><%=Util.toScreen(accountName,user.getLanguage())%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(17085,user.getLanguage())%></TD>
          <TD class=Field><%=Util.toScreen(accounts,user.getLanguage())%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
</TABLE>
	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="60%">
  		<COL width="10%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=3><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing  style="height: 1px">
          <TD class=Line1 colSpan=3></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></TD>
          <TD class=Field>
		  <%
		  if(RecordSetCT.next()){
		  %>
			  <a href="/CRM/data/ViewContacter.jsp?log=n&ContacterID=<%=RecordSetCT.getString(1)%>&canedit=<%=canedit%>"><%=Util.toScreen(RecordSetCT.getString(3),user.getLanguage())%></a> <%=Util.toScreen(ContacterTitleComInfo.getContacterTitlename(RecordSetCT.getString("title")),user.getLanguage())%>－ <%=Util.toScreen(RecordSetCT.getString(4),user.getLanguage())%>
		  <%}%>
		  </TD>
          <TD class=Field><%if(canedit || isCustomerSelf){%><a href="/CRM/data/AddContacter.jsp?isfromtab=true&CustomerID=<%=CustomerID%>" target="_self"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a><%}%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=3></td></tr>
<%while(RecordSetCT.next()){%>
        <TR>
          <TD></TD>
		  <TD class=Field colSpan=2> <a href="/CRM/data/ViewContacter.jsp?log=n&ContacterID=<%=RecordSetCT.getString(1)%>&canedit=<%=canedit%>"><%=Util.toScreen(RecordSetCT.getString(3),user.getLanguage())%></a> <%=Util.toScreen(ContacterTitleComInfo.getContacterTitlename(RecordSetCT.getString("title")),user.getLanguage())%>－ <%=Util.toScreen(RecordSetCT.getString(4),user.getLanguage())%></TD>
       </TR><TR  style="height: 1px"><TD class=Line colSpan=3></TD></TR>
<%}%>
        </TBODY>
	  </TABLE>

<!--修改记录显示取消
<%if(!user.getLogintype().equals("2")){%>
	  <TABLE class=ListStyle>
        <COLGROUP>
		<COL width="30%">
  		<COL width="30%">
  		<COL width="40%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=3><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing  style="height: 1px">
          <TD class=Line1 colSpan=3></TD></TR>
	    <TR class=Header>
	      <th><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(616,user.getLanguage())%></th>
	    </TR>
	    <TR class=Header>
	      <th>IP Address</th>
	      <th><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(191,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></th>
	    </TR>
<%
boolean isLight = false;
int nLogCount=0;
RecordSetC.executeProc("CRM_Find_RecentRemark",CustomerID);
while(RecordSetC.next())
{
	nLogCount++;
		if(isLight)
		{%>
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
          <TD><%=RecordSetC.getString("submitdate")%></TD>
          <TD><%=RecordSetC.getString("submittime")%></TD>
          <TD>
	<%if(!user.getLogintype().equals("2")) {%>
		<%if(!RecordSetC.getString("submitertype").equals("2")) {%>
			<a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSetC.getString("submiter")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetC.getString("submiter")),user.getLanguage())%></a>
		<%}else{%>
			<a href="/CRM/data/ViewLog.jsp?CustomerID=<%=RecordSetC.getString("submiter")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSetC.getString("submiter")),user.getLanguage())%></a>
		<%}%>
	<%}else{%>
		<%if(!RecordSetC.getString("submitertype").equals("2")) {%>
			<%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetC.getString("submiter")),user.getLanguage())%>
		<%}else{%>
			<a href="/CRM/data/ViewLog.jsp?CustomerID=<%=RecordSetC.getString("submiter")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSetC.getString("submiter")),user.getLanguage())%></a>
		<%}%>
	<%}%>
		 </TD>
        </TR>
<%		if(isLight)
		{%>
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
          <TD><%=RecordSetC.getString("clientip")%></TD>
		  <TD>
<%
	String strTemp1 = Util.toScreen(RecordSetC.getString("logtype"),user.getLanguage());
	String strTemp2 = "";
	if(strTemp1.substring(0,1).equals("n"))
	{
		%><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%><%
	}
	else if(strTemp1.substring(0,1).equals("d"))
	{
		%>删除<%
	}
	else if(strTemp1.substring(0,1).equals("a"))
	{
		%>状态<%
	}
	else if(strTemp1.substring(0,1).equals("p"))
	{
		%>门户<%
	}
	else
	{
		%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%><%
	}
	if(strTemp1.length()>1)
	{
		if(strTemp1.substring(1).equals("c"))
		{
			%>: <%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%><%
		}
	}
		%>&nbsp;<%
%>
		  </TD>
<%%>
		  <TD><a href="/docs/docs/DocDsp.jsp?id=<%=RecordSetC.getString("documentid")%>"><%=Util.toScreen(DocComInfo.getDocname(RecordSetC.getString("documentid")),user.getLanguage())%></TD>
        </TR>
<%		if(isLight)
		{%>
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
          <TD colSpan=3><%if(RecordSetC.getString("logcontent").equals("")){%>no<%}%><%=Util.toScreen(RecordSetC.getString("logcontent"),user.getLanguage())%></TD>
        </TR>
<%
	isLight = !isLight;
}
if(nLogCount>=3)
{%>
        <TR>
          <TD> </TD>
          <TD> </TD>
          <TD align=right><A href="/CRM/data/ViewLog.jsp?CustomerID=<%=CustomerID%>"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a></TD>
        </TR>
<%}%>
        </TBODY>
	  </TABLE>
<%}%>
-->

<!--联系情况快速入口－Begin-->
<%if(!isCustomerSelf){%>
	  <TABLE class="ListStyle" cellspacing="1">
      <COLGROUP>
			<COL width="25%">
  		<COL width="25%">
  		<COL width="25%">
  		<COL width="25%">
      <TBODY>
		<FORM id=weaver ="/CRM/data/ContactLogOperation.jsp?log=n" method=post onsubmit='return check_form(this,"ContactInfo")'>
		<input type="hidden" name="method" value="addquick">
		<input type="hidden" name="ParentID" value="0">
		<input type="hidden" name="isSub" value="0">
		<input type="hidden" name="CustomerID" value="<%=CustomerID%>">
		<input type="hidden" name="Subject" value="客户联系">
		<input type="hidden" name="isfinished" value="1">
		<input type="hidden" name="isPassive" value="3">
		<input type="hidden" name="isprocessed" value="1">
		<input type="hidden" name="ContactDate" value="<%=CurrentDate%>">
		<INPUT type="hidden" name="ContactTime" value="<%=CurrentTime%>">
		<%if(!user.getLogintype().equals("2")) {%>
		<INPUT type=hidden name=ResourceID value="<%=user.getUID()%>">
		<%}else{%>
		<INPUT type=hidden name=AgentID value="<%=user.getUID()%>">
		<%}%>
        <TR class=header>
            <TH colSpan=3><%=SystemEnv.getHtmlLabelName(6082,user.getLanguage())%></TH>
            <td align=right><span id='crmContractSpan'><a href="javascript:doSaveCrmContract()"  target="_self"><%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></a>&nbsp&nbsp</span></td>
        </TR>
       <TR  style="height: 1px"><TD class=Line colSpan=4 style="padding: 0"></TD></TR>
		<TR>
		  <TD colspan=4><TEXTAREA class=InputStyle wrap="hard" NAME=ContactInfo id="ContactInfo" ROWS=5 STYLE="width:100%"></TEXTAREA>
		  </TD>
		</TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())+SystemEnv.getHtmlLabelName(1332,user.getLanguage())%></td>
      <td class=Field colspan=3>
      <input type=hidden class="wuiBrowser" 
      _url="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiTaskBrowser.jsp" _param="resourceids"
      _displayTemplate="<a href='/proj/process/ViewTask.jsp?taskrecordid=#b{id}'>#b{name}</a>&nbsp"
      name="relatedprj" value="0">
      </td>
    </tr>
    <TR  style="height: 1px"><TD class=Line colspan=4 style="padding: 0"></TD></TR> 
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></td>
      <td class=Field colspan=3>
      <input type=hidden  class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp"
       _param="resourceids" _displayText="<%=Util.toScreen(customerName,user.getLanguage())%>"
       _displayTemplate="<a href='/CRM/data/ViewCustomer.jsp?CustomerID=#b{id}'>#b{name}</a>&nbsp"
       name="relatedcus" value="<%=CustomerID%>">
      
      </td>
    </tr>
    <TR  style="height: 1px"><TD class=Line colspan=4 style="padding: 0"></TD></TR> 
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
      <td class=Field colspan=3>
      <input type=hidden  class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp" _param="resourceids"
      _displayTemplate="<a href='/workflow/request/ViewRequest.jsp?requestid=#b{id}'>#b{name}</a>&nbsp"
      name="relatedwf" value="0">
      
      </td>
    </tr>
    <TR  style="height: 1px"><TD class=Line colspan=4 style="padding: 0"></TD></TR> 
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
      <td class=Field colspan=3>
      <input type=hidden class="wuiBrowser" _url="/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp" _param="documentids"
      _displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}'>#b{name}</a>&nbsp"
       name="relateddoc" value="0">
      </td>
    </tr>
    <TR  style="height: 1px"><TD class=Line colspan=4 style="padding: 0"></TD></TR> 
    <TR><TD  colspan=4>	    
		<div id='divCrmContract'>
			<table width="100%">
				<tr>
					<td colspan="4">
					
					<table class=ListStyle>
						<COLGROUP>
						<COL width="25%">
			  		<COL width="25%">
			  		<COL width="25%">
			  		<COL width="*">
		<%
		boolean isLight = false;
		//String temptable = WorkPlanShareBase.getTempTable(""+user.getUID());
		int nLogCount = 0;
		if(CoworkDAO.haveRightToViewCustomer(Integer.toString(userid),CustomerID)){//fix TD2536
			if (RecordSetC.getDBType().equals("oracle"))
				sql = " SELECT * FROM ( SELECT id, begindate, begintime, resourceid, description, createrid, createrType, taskid, crmid, requestid, docid"
					+ " FROM WorkPlan WHERE id IN ( "
				    + " SELECT DISTINCT a.id FROM WorkPlan a "
					+ " where (CONCAT(CONCAT(',',a.crmid),',')) LIKE '%," + CustomerID + ",%'"
					+ " AND a.type_n = '3') ORDER BY createdate DESC, createtime DESC) where rownum <= 3";
			else if (RecordSetC.getDBType().equals("db2"))
			sql = " SELECT id, begindate, begintime, resourceid, description, createrid, createrType, taskid, crmid, requestid, docid"
				+ " FROM WorkPlan WHERE id IN ( "
			    + " SELECT DISTINCT a.id FROM WorkPlan a "
				+ " where (CONCAT(CONCAT(',',a.crmid),',')) LIKE '%," + CustomerID + ",%'"
				+ " AND a.type_n = '3') ORDER BY createdate DESC, createtime DESC fetch first 3 rows only";
			else
				sql = "SELECT TOP 3 id, begindate , begintime, resourceid, description, createrid, createrType, taskid, crmid, requestid, docid"
					+ " FROM WorkPlan WHERE id IN ("
				    + "SELECT DISTINCT a.id FROM WorkPlan a"
					+ " where (',' + a.crmid + ',') LIKE '%," + CustomerID + ",%'"
					+ " AND a.type_n = '3') ORDER BY createdate DESC, createtime DESC";
		}else{
			if (RecordSetC.getDBType().equals("oracle"))
				sql = " SELECT * FROM ( SELECT id, begindate, begintime, resourceid, description, createrid, createrType, taskid, crmid, requestid, docid"
					+ " FROM WorkPlan WHERE id IN ( "
				    + " SELECT DISTINCT a.id FROM WorkPlan a, WorkPlanShareDetail b "
			        + " WHERE a.id = b.workid"
					+ " AND (CONCAT(CONCAT(',',a.crmid),',')) LIKE '%," + CustomerID + ",%'"
					+ " AND b.usertype = "+logintype + " AND b.userid = " + String.valueOf(userid)
					+ " AND a.type_n = '3') ORDER BY createdate DESC, createtime DESC) where rownum <= 3";
			else if (RecordSetC.getDBType().equals("db2"))
			    sql = "SELECT id, begindate , begintime, resourceid, description, createrid, createrType,taskid, crmid, requestid, docid"
					+ " FROM WorkPlan WHERE id IN ("
				    + "SELECT DISTINCT a.id FROM WorkPlan a,  WorkPlanShareDetail b WHERE a.id = b.workid"
					+ " AND (',' + a.crmid + ',') LIKE '%," + CustomerID + ",%'"
					+ " AND b.usertype = " + logintype + " AND b.userid = " + String.valueOf(userid)
					+ " AND a.type_n = '3') ORDER BY createdate DESC, createtime DESC fetch first 3 rows only ";
			else
				sql = "SELECT TOP 3 id, begindate , begintime, resourceid, description, createrid, createrType, taskid, crmid, requestid, docid"
					+ " FROM WorkPlan WHERE id IN ("
				    + "SELECT DISTINCT a.id FROM WorkPlan a,  WorkPlanShareDetail b WHERE a.id = b.workid"
					+ " AND (',' + a.crmid + ',') LIKE '%," + CustomerID + ",%'"
					+ " AND b.usertype = " + logintype + " AND b.userid = " + String.valueOf(userid)
					+ " AND a.type_n = '3') ORDER BY createdate DESC, createtime DESC";
		}
		//RecordSetC.writeLog(sql);
		String m_beginDate = "";
		String m_beginTime = "";
		String m_memberId = "";
		String m_createrType = "";
		String m_description = "";
		RecordSetC.executeSql(sql);
		while (RecordSetC.next()) {
			m_beginDate = Util.null2String(RecordSetC.getString("begindate"));
			m_beginTime = Util.null2String(RecordSetC.getString("begintime"));
			m_memberId = Util.null2String(RecordSetC.getString("createrid"));
			m_createrType = Util.null2String(RecordSetC.getString("createrType"));
			m_description = Util.null2String(RecordSetC.getString("description"));
			String relatedprj = Util.null2String(RecordSetC.getString("taskid"));
			String relatedcus = Util.null2String(RecordSetC.getString("crmid"));
			String relatedwf = Util.null2String(RecordSetC.getString("requestid"));
			String relateddoc = Util.null2String(RecordSetC.getString("docid"));
			ArrayList relatedprjList = Util.TokenizerString(relatedprj, ",");
			ArrayList relatedcusList = Util.TokenizerString(relatedcus, ",");
			ArrayList relatedwfList = Util.TokenizerString(relatedwf, ",");
			ArrayList relateddocList = Util.TokenizerString(relateddoc, ",");
		
			nLogCount++;
		
			if (nLogCount > 2)
				break;
		%>
		  <tr class="Header">
		    <td colspan="4">
			    <%
					if (m_createrType.equals("1")) {
						if (!m_memberId.equals("")) {
					%>
							<%if (!logintype.equals("2")) {%><A href="/hrm/resource/HrmResource.jsp?id=<%=m_memberId%>"><%}%>
							<%=ResourceComInfo.getResourcename(m_memberId)%></A>&nbsp;
					<%
						}
					} else {
						if (!m_memberId.equals("")) {
					%>
							<A href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=m_memberId%>">
							<%=CustomerInfoComInfo.getCustomerInfoname(m_memberId)%></A>&nbsp;
					<%
						}
					}
					%>
					<%=" "+m_beginDate+" "+m_beginTime%>
					</td>
		  </tr>
			<%if(isLight){%>	
			<TR CLASS=DataLight>
			<%}else{%>
			<TR CLASS=DataDark>
			<%}%>
				<TD style="word-break:break-all"  colSpan=4>
				<%=Util.toScreen(m_description,user.getLanguage())%>
				</TD>
			</TR>
			<tr  style="height: 1px"><td class=Line colspan=4 style="padding: 0"></td></tr>
			<%if(isLight){%>	
			<TR CLASS=DataLight>
			<%}else{%>
			<TR CLASS=DataDark>
			<%}%>
		    <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
		    <td><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())+SystemEnv.getHtmlLabelName(1332,user.getLanguage())%></td>
		    <td><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></td>
		    <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
		  </tr>
		  <tr  style="height: 1px"><td class=Line colspan=4 style="padding: 0"></td></tr>
		  <%if(relateddocList.size()+relatedprjList.size()+relatedcusList.size()+relatedwfList.size()!=0){%>
			<%if(isLight){%>	
			<TR CLASS=DataLight>
			<%}else{%>
			<TR CLASS=DataDark>
			<%}%>
		    <td>
				<%for(int i=0;i<relateddocList.size();i++){%>
					<a href="/docs/docs/DocDsp.jsp?id=<%=relateddocList.get(i).toString()%>">
					<%=DocComInfo.getDocname(relateddocList.get(i).toString())%><br>
					</a>
				<%}%>
				</td>
		    <td>
				<%for(int i=0;i<relatedprjList.size();i++){%>
					<a href="/proj/process/ViewTask.jsp?taskrecordid=<%=relatedprjList.get(i).toString()%>">
					<%=ProjectTaskApprovalDetail.getTaskSuject(relatedprjList.get(i).toString())%><br>
					</a>
				<%}%>
				</td>
		    <td>
				<%for(int i=0;i<relatedcusList.size();i++){%>
					<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=relatedcusList.get(i).toString()%>">
					<%=CustomerInfoComInfo.getCustomerInfoname(relatedcusList.get(i).toString())%><br>
					</a>
				<%}%>		
				</td>
		    <td>
				<%for(int i=0;i<relatedwfList.size();i++){%>
					<a href="/workflow/request/ViewRequest.jsp?requestid=<%=relatedwfList.get(i).toString()%>">
					<%=RequestComInfo.getRequestname(relatedwfList.get(i).toString())%><br>
					</a>
				<%}%>		
				</td>
		  </tr>
		  <tr  style="height: 1px"><td class=Line colspan=4 style="padding: 0"></td></tr>
			<%}
		isLight=!isLight;
		}
		%>
					</table>
					
				</td>
			</tr>
		<%
		if (nLogCount > 2) {
		%>
		        <TR  class=header>
		          <TD align=right colspan=4><a href="#" onClick= "parent.setTabPanelActive('crmContract')"  target="_self">
				  <%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a>&nbsp;&nbsp;</TD>
		        </TR>
		<%}%>
			</table>	
		</div>
    </TD></TR>       
        </TBODY>
	  </TABLE>
	  </Form>
<%}%>
<!--联系情况快速入口－End-->
	</TD>

    <TD></TD>

	<TD vAlign=top style="word-break: break-all;">

	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(574,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing  style="height: 1px">
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></TD>
          <TD class=Field><span  class=fontred><%=Util.toScreen(CustomerStatusComInfo.getCustomerStatusname(RecordSet.getString("status")),user.getLanguage())%> </span> <%=Util.toScreen(RecordSet.getString("rating"),user.getLanguage())%><%=levelMsg%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
<%if(!isCustomerSelf){%>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(6073,user.getLanguage())%></TD>
          <TD class=Field><span  class=fontred>
          <%
			String evaId = Util.null2String(RecordSet.getString("evaluation"));
			if (!evaId.equals("")) {
		  %>
		  <%=EvaluationLevelComInfo.getEvaluationLevelname(evaId)%>
		  <%}%>
		  </span></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
<%}%>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
          <TD class=Field><%=Util.toScreen(CustomerTypeComInfo.getCustomerTypename(RecordSet.getString("type")),user.getLanguage())%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          <TD class=Field><%=Util.toScreen(CustomerDescComInfo.getCustomerDescname(RecordSet.getString("description")),user.getLanguage())%></TD>
         </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>

        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(576,user.getLanguage())%></TD>
          <TD class=Field><%=Util.toScreen(CustomerSizeComInfo.getCustomerSizedesc(RecordSet.getString("size_n")),user.getLanguage())%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(645,user.getLanguage())%></TD>
          <TD class=Field><%=Util.toScreen(ContactWayComInfo.getContactWayname(RecordSet.getString("source")),user.getLanguage())%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(575,user.getLanguage())%></TD>
          <TD class=Field>
          <%
          String seclist = "";
          String tmpsecid = RecordSet.getString("sector");
          String tmpparid = SectorInfoComInfo.getSectorInfoParentid(tmpsecid);
         while(!tmpsecid.equals("0")&&!tmpparid.equals("")){
         	if(seclist.equals(""))
         		seclist = SectorInfoComInfo.getSectorInfoname(tmpsecid) + seclist;
         	else
         		seclist = SectorInfoComInfo.getSectorInfoname(tmpsecid) +"->"+ seclist;

          tmpsecid = tmpparid;
          tmpparid = SectorInfoComInfo.getSectorInfoParentid(tmpsecid);
         }
          %>
          <%=seclist%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
<%if(!user.getLogintype().equals("2")) {%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></TD>
          <TD class=Field><a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("manager")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("manager")),user.getLanguage())%></a></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
          <TD class=Field><a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=RecordSet.getString("department")%>"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSet.getString("department")),user.getLanguage())%></a></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
<%} else {%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></TD>
          <TD class=Field><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("manager")),user.getLanguage())%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
          <TD class=Field><%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSet.getString("department")),user.getLanguage())%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
<%}%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(132,user.getLanguage())%></TD>
          <TD class=Field>
          <a href="/CRM/data/Viewcustomer.jsp?CustomerID=<%=RecordSet.getString("agent")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("agent")),user.getLanguage())%></a>
          </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(591,user.getLanguage())%></TD>
          <TD class=Field><a href="/CRM/data/Viewcustomer.jsp?CustomerID=<%=RecordSet.getString("parentid")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("parentid")),user.getLanguage())%></a>
          </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TD>
          <TD class=Field><a href="/docs/docs/DocDsp.jsp?id=<%=RecordSet.getString("documentid")%>"><%=Util.toScreen(DocComInfo.getDocname(RecordSet.getString("documentid")),user.getLanguage())%></a>
          </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		 <TR>
          <TD><%=SystemEnv.getHtmlLabelName(6069,user.getLanguage())%></TD>
          <TD class=Field><a href="/docs/docs/DocDsp.jsp?id=<%=RecordSet.getString("introductionDocid")%>"><%=Util.toScreen(DocComInfo.getDocname(RecordSet.getString("introductionDocid")),user.getLanguage())%></a>
          </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
<%if(isPortalOK){%><!--portal begin-->
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1240,user.getLanguage())%></TD>
          <TD class=Field>
		  <span class=fontred>
			  <%if(portalstatus2.equals("0")){%>
				 <%=SystemEnv.getHtmlLabelName(1241,user.getLanguage())%>
			  <%}else if(portalstatus2.equals("1")) {%>
				 <%=SystemEnv.getHtmlLabelName(1242,user.getLanguage())%>
			  <%}else if(portalstatus2.equals("2")) {%>
				 <%=SystemEnv.getHtmlLabelName(1280,user.getLanguage())%>
			  <%}else if(portalstatus2.equals("3")) {%>
				 <%=SystemEnv.getHtmlLabelName(1232,user.getLanguage())%>
			  <%}%>
		  </span>
			<%if(canedit && portalstatus2.equals("2") && RecordSet.getInt("status")>=3){%>
				&nbsp<%=SystemEnv.getHtmlLabelName(2024,user.getLanguage())%>:<%=RecordSet.getString("PortalLoginid")%>&nbsp<%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%>:******<!--<%=RecordSet.getString("PortalPassword")%> -->
			<%}%>
            <%=portalMsg%><%=portalPwdMsg%>
          </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
<%}%><!--portal end-->
	<%if(!user.getLogintype().equals("2")){%>
        <TR>
		  <TD><%=SystemEnv.getHtmlLabelName(120,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></TD>
		  <TD class=Field><%=RecordSet.getString("seclevel")%>
		  </TD>
	    </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
	<%}%>
    <!--    <TR>
          <TD>图片</TD>
          <TD class=Field><%=RecordSet.getString("picid")%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
      -->  </TBODY>
	  </TABLE>

     
<!--共享信息begin-->
<%if(!user.getLogintype().equals("2")) {%>
	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="60%">
  		<COL width="10%">
        <TBODY>
        <TR class=Title>
            <TH><%=SystemEnv.getHtmlLabelName(2112,user.getLanguage())%></TH>
			<TD align=right colspan=2>
			<%if(canedit){%>
			<a href="/CRM/data/AddShare.jsp?isfromtab=true&itemtype=2&CustomerID=<%=CustomerID%>&customername=<%=RecordSet.getString("name")%>&isfromCrmTab=true" target="_self"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a>
			<%}%>
			</TD>
          </TR>
        <TR class=Spacing  style="height: 1px">
          <TD class=Line1 colSpan=3></TD></TR>
<%
int index=0;
if(RecordSetShare.first()){
do{
	index++;
	if(RecordSetShare.getInt("sharetype")==1)	{
%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
		  <TD class=Field>
			<a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSetShare.getString("userid")%>" target="_blank"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetShare.getString("userid")),user.getLanguage())%></a>/<% if(RecordSetShare.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
			<% if(RecordSetShare.getInt("sharelevel")>=2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
		  </TD>
		  <TD class=Field  id="tdDel_<%=index%>">
			<%if(canedit){%>
			<a href="#" onClick="onDel('/CRM/data/ShareOperation.jsp?method=delete&id=<%=RecordSetShare.getString("id")%>&CustomerID=<%=CustomerID%>',this,<%=index%>)" target="_self"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
		<%}%>
		  </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=3></td></tr>
	<%}else if(RecordSetShare.getInt("sharetype")==2)	{%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
		  <TD class=Field>
			<a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=RecordSetShare.getString("departmentid")%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSetShare.getString("departmentid")),user.getLanguage())%></a>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSetShare.getString("seclevel"),user.getLanguage())%>/<% if(RecordSetShare.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
			<% if(RecordSetShare.getInt("sharelevel")>=2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
		  </TD>
		  <TD class=Field id="tdDel_<%=index%>">
			<%if(canedit){%>
			<a href="#" onClick="onDel('/CRM/data/ShareOperation.jsp?method=delete&id=<%=RecordSetShare.getString("id")%>&CustomerID=<%=CustomerID%>',this,<%=index%>)" target="_self"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
			<%}%>
		  </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=3></td></tr>
	<%}else if(RecordSetShare.getInt("sharetype")==3)	{%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TD>
		  <TD class=Field>
			<%=Util.toScreen(RolesComInfo.getRolesRemark(RecordSetShare.getString("roleid")),user.getLanguage())%>/<% if(RecordSetShare.getInt("rolelevel")==0)%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%><% if(RecordSetShare.getInt("rolelevel")==1)%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%><% if(RecordSetShare.getInt("rolelevel")==2)%><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%> /<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSetShare.getString("seclevel"),user.getLanguage())%> /<% if(RecordSetShare.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>	<% if(RecordSetShare.getInt("sharelevel")>=2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
		  </TD>
		  <TD class=Field id="tdDel_<%=index%>">
			<%if(canedit){%>
			<a href="#" onClick="onDel('/CRM/data/ShareOperation.jsp?method=delete&id=<%=RecordSetShare.getString("id")%>&CustomerID=<%=CustomerID%>',this,<%=index%>)" target="_self"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
			<%}%>
		  </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=3></td></tr>
	<%}else if(RecordSetShare.getInt("sharetype")==4)	{%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></TD>
		  <TD class=Field>
			<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSetShare.getString("seclevel"),user.getLanguage())%>/<% if(RecordSetShare.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
			<% if(RecordSetShare.getInt("sharelevel")>=2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
		  </TD>
		  <TD class=Field id="tdDel_<%=index%>">
			<%if(canedit){%>
			<a href="#" onClick="onDel('/CRM/data/ShareOperation.jsp?method=delete&id=<%=RecordSetShare.getString("id")%>&CustomerID=<%=CustomerID%>',this,<%=index%>)" target="_self"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
			<%}%>
		  </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=3></td></tr>
	<%}%>
 <%}while(RecordSetShare.next());
}
%>
        </TBODY>
	  </TABLE>
<%}%>
<!--共享信息end-->

<%if(RecordSet.getInt("status")>=4 && 0!=0){ //0!=0屏蔽到财务信息%>

	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=Title>
            <TH><%=SystemEnv.getHtmlLabelName(189,user.getLanguage())%></TH>
            <td align=right><a href="/CRM/ledger/CustomerLedgerList.jsp?customerid=<%=CustomerID%>"><%=SystemEnv.getHtmlLabelName(585,user.getLanguage())%></a></td>
          </TR>
        <TR class=Spacing  style="height: 1px">
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(189,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(590,user.getLanguage())%></TD>
          <TD class=Field><%=RecordSet.getString("fincode")%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(649,user.getLanguage())%></TD>
          <TD class=Field><%=Util.toScreen(CurrencyComInfo.getCurrencyname(RecordSet.getString("currency")),user.getLanguage())%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(581,user.getLanguage())%></TD>
          <TD class=Field><%=Util.toScreen(TradeInfoComInfo.getTradeInfoname(RecordSet.getString("contractlevel")),user.getLanguage())%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(580,user.getLanguage())%></TD>
          <TD class=Field><%=Util.toScreen(CreditInfoComInfo.getCreditInfoname(RecordSet.getString("creditlevel")),user.getLanguage())%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(650,user.getLanguage())%></TD>
          <TD class=Field><%=Util.toScreen(RecordSet.getString("creditoffset"),user.getLanguage())%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(651,user.getLanguage())%>(%)</TD>
          <TD class=Field><%=RecordSet.getString("discount")%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(653,user.getLanguage())%></TD>
          <TD class=Field><%=RecordSet.getString("taxnumber")%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(654,user.getLanguage())%></TD>
          <TD class=Field><%=RecordSet.getString("bankacount")%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(655,user.getLanguage())%></TD>
          <TD class=Field><a href="ViewCustomer.jsp?CustomerID=<%=RecordSet.getString("invoiceacount")%>">
          <%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("invoiceacount")),user.getLanguage())%></a></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(657,user.getLanguage())%></TD>
          <TD class=Field><%=Util.toScreen(DeliveryTypeComInfo.getDeliveryTypename(RecordSet.getString("deliverytype")),user.getLanguage())%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(658,user.getLanguage())%></TD>
          <TD class=Field><%=Util.toScreen(PaymentTermComInfo.getPaymentTermname(RecordSet.getString("paymentterm")),user.getLanguage())%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(652,user.getLanguage())%></TD>
          <TD class=Field>
          <%
          int paymentway=Util.getIntValue(RecordSet.getString("paymentway"),0);
          switch(paymentway){
          	case 1:%><%=SystemEnv.getHtmlLabelName(1243,user.getLanguage())%><% break;
          	case 2:%><%=SystemEnv.getHtmlLabelName(185,user.getLanguage())%><% break;
          	case 3:%><%=SystemEnv.getHtmlLabelName(1246,user.getLanguage())%><% break;
          	case 4:%><%=SystemEnv.getHtmlLabelName(1244,user.getLanguage())%><% break;
          	case 5:%><%=SystemEnv.getHtmlLabelName(1247,user.getLanguage())%><% break;
          	case 6:%><%=SystemEnv.getHtmlLabelName(1248,user.getLanguage())%><% break;
          	case 7:%><%=SystemEnv.getHtmlLabelName(1249,user.getLanguage())%><% break;
          	case 8:%><%=SystemEnv.getHtmlLabelName(1250,user.getLanguage())%><% break;
          	case 9:%>BACS<% break;
          	case 10:%><%=SystemEnv.getHtmlLabelName(1251,user.getLanguage())%><% break;
          	case 11:%><%=SystemEnv.getHtmlLabelName(1252,user.getLanguage())%><% break;
          	case 12:%><%=SystemEnv.getHtmlLabelName(1245,user.getLanguage())%><% break;
          	case 13:%><%=SystemEnv.getHtmlLabelName(1253,user.getLanguage())%><% break;
          	case 14:%><%=SystemEnv.getHtmlLabelName(1254,user.getLanguage())%><% break;
          }%>
          </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(646,user.getLanguage())%></TD>
          <TD class=Field>
          <%
          int saleconfirm=Util.getIntValue(RecordSet.getString("saleconfirm"),0);
          switch(saleconfirm){
          	case 1:%>Always sales order confirmation<% break;
          	case 2:%>Only for back orders<% break;
          	case 3:%>No sales order confirmation<% break;
          }%>
          </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(487,user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(488,user.getLanguage())%></TD>
          <TD class=Field><%=RecordSet.getString("creditcard")%> , <%=RecordSet.getString("creditexpire")%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        </TBODY>
	  </TABLE>
<%}%>
	  <TABLE class=ListStyle cellspacing=1>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=header>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%></TH>
          </TR>
<TR class=Line  style="height: 1px"><TD colSpan=2></TD></TR>
<%
if(hasFF)
{
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+1).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2)%></TD>
          <TD class=Field><%=RecordSet.getString("datefield"+i)%></TD>
        </TR>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+11).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2+10)%></TD>
          <TD class=Field><%=RecordSet.getString("numberfield"+i)%></TD>
        </TR>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+21).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2+20)%></TD>
          <TD class=Field><%=Util.toScreen(RecordSet.getString("textfield"+i),user.getLanguage())%></TD>
        </TR>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+31).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2+30)%></TD>
          <TD class=Field>
          <INPUT type=checkbox  value=1 <%if(RecordSet.getString("tinyintfield"+i).equals("1")){%> checked <%}%> disabled >
          </TD>
        </TR>
		<%}
	}
}
%>
        </TBODY>
	  </TABLE>


<BR>
	<FORM id=Exchange name=Exchange ="/discuss/ExchangeOperation.jsp" method=post>
	 <input type="hidden" name="method1" value="add">
     <input type="hidden" name="types" value="CC">

	 <input type="hidden" name="sortid" value="<%=CustomerID%>">
   <TABLE class=ListStyle cellspacing=1  >
      <TR class=header>
       <TH ><%=SystemEnv.getHtmlLabelName(15153,user.getLanguage())%></TH>
       <Td align=right >
        <span id='crmExchangeSpan'><a href="javascript:doSaveCrmExchange()" target="_self"><%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></a>&nbsp&nbsp</span>
      </Td>
      </TR>
<TR class=Line  style="height: 1px"><TD colSpan=2 style="padding: 0"></TD></TR>

	   <TR >
    	  <TD class=Field colSpan="2">
		  <TEXTAREA class=InputStyle NAME=ExchangeInfo id="ExchangeInfo" ROWS=3 STYLE="width:100%"></TEXTAREA>
		 </TD>
	   </TR>
       
	 </TABLE>

  <TABLE class=ViewForm>
  <tbody>
        <COLGROUP>
        <COL width="30%">
        <COL width="70%">
        </COLGROUP>
        <tr class=Header>
          <TD class=title><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></TD>
          <TD class=field>
          	
			<input type=hidden class="wuiBrowser" _url="/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp" _param="documentids"
      _displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}'>#b{name}</a>&nbsp"
       name="docids" value="0">
           
		  </TD>
        </tr>
  </tbody>
  </table>
  <div id='divCrmExchange'>
  <TABLE class=ListStyle cellspacing=1>
        <COLGROUP>
		<COL width="30%">
  		<COL width="30%">
  		<COL width="40%">
        <TBODY>
	    <TR class=Header>
	      <th><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(616,user.getLanguage())%></th>

	    </TR>
        <TR class=Line  style="height: 1px"><TD colSpan=3 style="padding: 0"></TD></TR>
<%
boolean isLight = false;
char flag=2;
int nLogCount=0;
RecordSetEX.executeProc("ExchangeInfo_SelectBID",CustomerID+flag+"CC");
while(RecordSetEX.next())
{
nLogCount++;
if (nLogCount==2) {
%>
</tbody></table>
<div  id=WorkFlowDiv style="display:none">
    <table class=ListStyle cellspacing=1>
           <COLGROUP>
		<COL width="30%">
  		<COL width="30%">
  		<COL width="40%">
    <tbody>
<%}
		if(isLight)
		{%>
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
          <TD><%=RecordSetEX.getString("createDate")%></TD>
          <TD><%=RecordSetEX.getString("createTime")%></TD>
          <TD>
			<%if(Util.getIntValue(RecordSetEX.getString("creater"))>0){%>
			<a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSetEX.getString("creater")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetEX.getString("creater")),user.getLanguage())%></a>
			<%}else{%>
			<A href='/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSetEX.getString("creater").substring(1)%>'><%=CustomerInfoComInfo.getCustomerInfoname(""+RecordSetEX.getString("creater").substring(1))%></a>
			<%}%>
		  </TD>

        </TR>
<%		if(isLight)
		{%>
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
          <TD colSpan=3  style="word-break:break-all" ><%=Util.toScreen(RecordSetEX.getString("remark"),user.getLanguage())%></TD>
        </TR>

<%		if(isLight)
		{%>
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
<%
        String docids_0=  Util.null2String(RecordSetEX.getString("docids"));
        String docsname="";
        if(!docids_0.equals("")){

            ArrayList docs_muti = Util.TokenizerString(docids_0,",");
            int docsnum = docs_muti.size();

            for(int i=0;i<docsnum;i++){
                docsname= docsname+"<a href=/docs/docs/DocDsp.jsp?id="+docs_muti.get(i)+">"+Util.toScreen(DocComInfo.getDocname(""+docs_muti.get(i)),user.getLanguage())+"</a>" +" ";
            }
        }

 %>
     <td  colSpan=3 ><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>:  <%=docsname%>
         </TR>
<%
	isLight = !isLight;
}
%>	  </TBODY>
	  </TABLE>
<% if (nLogCount>=2) { %> </div> <%}%>
        <table class=ListStyle cellspacing=1>
        <COLGROUP>
		<COL width="30%">
  		<COL width="30%">
  		<COL width="40%">
          <tbody>
           <% if (nLogCount>=2) { %>
          <tr class=header>
           
            <td align=right colspan=3><SPAN id=WorkFlowspan><a href="#" onClick= "parent.setTabPanelActive('crmExchange')" target="_self"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a></span></td>
           
          </tr>
           <%}%>
         </tbody>
        </table>

</div>
		</td>
		</tr>
		</TABLE>


</td>
</tr>
</TABLE>
</td>

</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>
</FORM>
</div>

<script language=vbs>

sub onShowMDoc(spanname,inputename)
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="&tmpids)
         if (Not IsEmpty(id1)) then
				if id1(0)<> "" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.all(inputename).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a href=/docs/docs/DocDsp.jsp?id="&curid&">"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href=/docs/docs/DocDsp.jsp?id="&resourceids&">"&resourcename&"</a>&nbsp"
					document.all(spanname).innerHtml = sHtml

				else
					document.all(spanname).innerHtml =""
					document.all(inputename).value=""
				end if
        end if
end sub
</script>

<script type="text/javascript" src="/js/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="/js/extjs/ext-all.js"></script>  
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog.js"></script>  
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag.js"></script>


<script language=javascript>

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

function urlSubmit(obj,url){
    obj.disabled= true;
    location=url;
}

function doAddWorkPlan() {
	window.open("/workplan/data/WorkPlan.jsp?crmid=<%=CustomerID%>&add=1")
}

//门户申请
var applyPortalUrl = null;
var applyPortalObj = null;
function applyPortalManager(obj ,url){

	applyPortalUrl = url;
	applyPortalObj = obj;
	editPassword(1);//先进行密码设定，然后进行门户申请
}

/***
*修改密码
* state 为1表示需要调用门户申请，为0表示不需要
**/
var diag = new Dialog();
function editPassword(state){
	
	diag.Width = 400;
	diag.Height = 200;
	diag.Title = "设置密码";
	diag.ShowButtonRow=true;
	diag.URL = "/CRM/data/ManagerUpdatePassword.jsp?crmid=<%=CustomerID%>&type=manager";
	
	diag.OKEvent=function(){
		
		diag.innerFrame.contentWindow.checkpassword();
		var doc=diag.innerFrame.contentWindow.document;
		var verifyFlag = doc.forms[0].verifyFlag.value;//1表示验证成功，0表示验证失败
		if(0 == verifyFlag){
			return;
		}
		jQuery.post("/CRM/data/CustomerOperation.jsp",
			{"method":"updatePassword","crmid":<%=CustomerID%>,"passwordnew":doc.forms[0].passwordnew.value},
				function(){
					diag.close();
					if(1 == state){//保存成功，发起申请流程
					  urlSubmit(applyPortalObj , applyPortalUrl);
					}
			
				
		});
  		
	}
	
	diag.show();
	jQuery("body").trigger("click");
	
}

function closeWin(){
  diag.close();
  if(applyPortalStatus){
  	applyPortalStatus = false;
  	urlSubmit(applyPortalObj , applyPortalUrl);
  }
}


function doAddEmail(){
	window.open("/email/MailAdd.jsp?to=<%=mailAddress%>")
}
function URLencode(sStr) 
{
    return escape(sStr).replace(/\+/g, '%2B').replace(/\"/g,'%22').replace(/\'/g, '%27').replace(/\//g,'%2F');
}

function getFormElements(name){
	var form = document.getElementById(name);
	var para ='';
		
	for(i=0;i<form.elements.length;i++)
	{

		if(form.elements[i].name!= ''&&form.elements[i].name!="ContactInfo"){
		    
			if(form.elements[i].value.indexOf('\n')>0){
				para+='&'+form.elements[i].name+'='+URLencode(form.elements[i].value);
			}else{
				para+='&'+form.elements[i].name+'='+URLencode(form.elements[i].value);
			}
		}
	}
	
	return para;

}
if(document.getElementById('crmContractSpan')!=null){
	var crmContractSpan = document.getElementById('crmContractSpan').innerHTML;
}
var crmExchangeSpan = document.getElementById('crmExchangeSpan').innerHTML;

function doSaveCrmContract(){
	if(check_form(weaver,'ContactInfo')){ 

		
		document.getElementById('crmContractSpan').innerHTML = "<img src='/images/loadingext.gif' align=absMiddle>";
		var paras = getFormElements('weaver');
		var ContactInfo=jQuery("#ContactInfo").val();
		jQuery.ajax({
			type: "post",
		    url: "/CRM/data/ContactLogOperation.jsp?log=n&"+paras,
		    data:{'ContactInfo':encodeURI(ContactInfo)},
		    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		    complete: function(){ 
				getCrmContract();
			}
	    });
		//jQuery.post("/CRM/data/ContactLogOperation.jsp?log=n&"+paras,null,function(data){
		//	getCrmContract();
		//})
		//alert(paras)
		/*var xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
		xmlHttp.onreadystatechange = function(){
			if (xmlHttp.readyState == 4) {
				getCrmContract();
		    }
		}
		xmlHttp.open("POST", '/CRM/data/ContactLogOperation.jsp?log=n', true);
		xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		
		xmlHttp.send(paras);*/
	}
}
function getCrmContract(){
	
	Ext.Ajax.request({
					url : '/CRM/data/ext/CrmContractExt.jsp?CustomerID=<%=CustomerID%>', 					
					method: 'POST',
					success: function ( result, request) {						
						document.getElementById('divCrmContract').innerHTML=result.responseText.replace(/(^\s*)|(\s*$)/g, "");
						document.getElementById('crmContractSpan').innerHTML = crmContractSpan;	
						document.getElementById('ContactInfo').value='';				
					},
					failure: function ( result, request) { 
						//Ext.MessageBox.alert('Failed', 'Failed posted form: '+result); 
					} 
	});		
}

function doSaveCrmExchange(){
	if(check_form(Exchange,'ExchangeInfo'))
	{
		document.getElementById('crmExchangeSpan').innerHTML = "&nbsp;<img src='/images/loadingext.gif' align=absMiddle>&nbsp;&nbsp;&nbsp;";
		var paras = getFormElements('Exchange');
		jQuery.post("/discuss/ExchangeOperation.jsp?"+paras,null,function(data){
			getCrmExchange();
		})
		/*var xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
		xmlHttp.onreadystatechange = function(){
			if (xmlHttp.readyState == 4) {
				getCrmExchange();
		    }
		}
		xmlHttp.open("POST", '/discuss/ExchangeOperation.jsp?', true);
		xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	
		xmlHttp.send(paras);*/
	}
}
function getCrmExchange(){
	Ext.Ajax.request({
					url : '/CRM/data/ext/CrmExchangeExt.jsp?CustomerID=<%=CustomerID%>', 					
					method: 'POST',
					success: function ( result, request) {												
						document.getElementById('divCrmExchange').innerHTML=result.responseText.replace(/(^\s*)|(\s*$)/g, "");
						document.getElementById('crmExchangeSpan').innerHTML = crmExchangeSpan;	
						document.getElementById('ExchangeInfo').value='';				
					},
					failure: function ( result, request) { 
						//alert(result.responseText);
						//Ext.MessageBox.alert('Failed', 'Failed posted form: '+result); 
					} 
	});		
}

function onDel(url,obj,index){	
	

	if(isdel()){		
		obj.parentNode.innerHTML="<img src='/images/loadingext.gif' align=absMiddle>";
		Ext.Ajax.request({
						url : url, 					
						method: 'POST',
						success: function ( result, request) {
							var trObj=document.getElementById("tdDel_"+index).parentNode;
							var trObjNext=trObj.nextSibling;
							trObj.parentNode.removeChild(trObjNext);
							trObj.parentNode.removeChild(trObj);
							
							//alert(trObj.tagName);	
							//this.obj.parentNode.parentNode.parentNode.removeChild(this.obj.parentNode.parentNode);
						},
						failure: function ( result, request) { 
							//alert(result.responseText);
							//Ext.MessageBox.alert('Failed', 'Failed posted form: '+result); 
						} 
		});		
	}
}

function doEdit(){
	parent.location='/CRM/data/EditCustomer.jsp?isfromtab=true&CustomerID=<%=CustomerID%>';
}

</script>
</BODY>
</HTML>




