
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
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="ProjectTaskApprovalDetail" class="weaver.proj.Maint.ProjectTaskApprovalDetail" scope="page"/>
	
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
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

String requestPara = request.getQueryString(); 

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

char separator = Util.getSeparator() ;

String CustomerID = Util.null2String(request.getParameter("CustomerID"));

/****解决客户合并后从客户不能查看，只能查看主客户*****/
String customername = Util.null2String(CustomerInfoComInfo.getCustomerInfoname(CustomerID));
RecordSet.executeSql("select id from CRM_CustomerInfo where deleted = '1' and id ="+CustomerID);
if(RecordSet.next() && !"".equals(customername)){
	String logcontentname = "";
	RecordSet.executeSql("select customerid,logcontent from CRM_Log where logtype = 'u' and logcontent like '%"+customername+"%'");
	while(RecordSet.next()){
		logcontentname = (RecordSet.getString("logcontent").substring(RecordSet.getString("logcontent").indexOf(":")+1,RecordSet.getString("logcontent").length())).trim();
	    if((customername+" ,").equals(logcontentname)){
	    	CustomerID = RecordSet.getString("customerid");
	    	customername = Util.null2String(CustomerInfoComInfo.getCustomerInfoname(CustomerID));
	    	out.print("\n<script>\n <!--\n var unitemp = window.confirm('"+SystemEnv.getHtmlLabelName(23227,user.getLanguage())+customername+","+SystemEnv.getHtmlLabelName(23228,user.getLanguage())+"')\n;if(!unitemp){\n window.opener=null; \n window.open('','_self'); \n window.close();\n } \n--> \n</script>\n");	    	
	    }
	}	
}

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
int usertype = 0;
if(logintype.equals("2"))
	usertype= 1;
//get doc count
/*
DocSearchComInfo.resetSearchInfo();
DocSearchComInfo.addDocstatus("1");
DocSearchComInfo.addDocstatus("2");
DocSearchComInfo.addDocstatus("5");
DocSearchComInfo.setCrmid(CustomerID);
String whereclause = " where " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;
DocSearchManage.getSelectResultCount(whereclause,user) ;
String doccount=""+DocSearchManage.getRecordersize();
*/
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
/*
SearchComInfo1.resetSearchInfo();
SearchComInfo1.setcustomer(CustomerID);
String Prj_SearchSql="";
String prjcount="0";
Prj_SearchSql = "select count(*) from Prj_ProjectInfo  t1,PrjShareDetail t2 "+SearchComInfo1.FormatSQLSearch(user.getLanguage()) +" and t1.id = t2.prjid and t2.usertype="+user.getLogintype()+" and t2.userid="+user.getUID();
RecordSet.executeSql(Prj_SearchSql);
if(RecordSet.next()){
	prjcount = ""+RecordSet.getInt(1);
}
*/
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
	  response.sendRedirect("ViewPerCustomer.jsp?"+request.getQueryString());
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



RecordSetV.executeSql("select approvedesc,status from bill_ApproveCustomer where approvetype=1 and status<>'1' and approveid="+CustomerID);
if(RecordSetV.next()){
    levelMsg = "（"+RecordSetV.getString("approvedesc")+"）";
    levelstatus = RecordSetV.getString("status");
    hasApply = true;
}
RecordSetV.executeSql("select approvedesc,status from bill_ApproveCustomer where approvetype=2 and status<>'1' and approveid="+CustomerID);
if(RecordSetV.next()){
    portalMsg = "（"+RecordSetV.getString("approvedesc")+"）";
    portalstatus = RecordSetV.getString("status");
    hasApplyPortal = true;
}
RecordSetV.executeSql("select approvedesc,status from bill_ApproveCustomer where approvetype=3 and status<>'1' and approveid="+CustomerID);
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
if(!canview && isrequest.equals("1")){
	RecordSetV.executeSql("insert into CRM_ShareInfo (relateditemid,sharetype,seclevel,sharelevel,userid,Contents) values ("+CustomerID+",1,"+user.getSeclevel()+",1,"+user.getUID()+","+user.getUID()+")");
	canview = true;
}
if(!canview && !isCustomerSelf && !CoworkDAO.haveRightToViewCustomer(Integer.toString(userid),CustomerID)){
    if(!WFUrgerManager.UrgerHaveCrmViewRight(Util.getIntValue(requestid),userid,Util.getIntValue(logintype),CustomerID) && !WFUrgerManager.getMonitorViewObjRight(Util.getIntValue(requestid),userid,""+CustomerID,"1")){
        response.sendRedirect("/notice/noright.jsp") ;
        return ;
    }else{
        onlyview=true;
    }
}

RecordSetC.executeProc("CRM_Find_CustomerContacter",CustomerID);

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


<HTML>
<HEAD>
<title><%=CustomerInfoComInfo.getCustomerInfoname(CustomerID)%></title>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

<script type="text/javascript" src="/js/jquery/jquery-1.4.2.min_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(647,user.getLanguage())+" - "+Util.toScreen(customerName,user.getLanguage());
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
<BODY scroll="no">
<%
	session.setAttribute("fav_pagename" , newtitlename ) ;	
%>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>

<%

String arrOtherTab="[";
arrOtherTab+="{tid:'t1361',	title:'"+SystemEnv.getHtmlLabelName(1361,user.getLanguage())+" ',url:'/CRM/data/ViewCustomerBase.jsp?requestid="+requestid+"&isrequest="+isrequest+"&CustomerID="+CustomerID+"'}";
arrOtherTab+=",{tid:'t352',title:'"+SystemEnv.getHtmlLabelName(352,user.getLanguage())+SystemEnv.getHtmlLabelName(351,user.getLanguage())+"',url:'/CRM/data/ViewCustomerTotal.jsp?isrequest="+isrequest+"&CustomerID="+CustomerID+"'}";

if(!onlyview){

if(canviewlog){%>
<%

arrOtherTab+=",{tid:'t618',title:'"+SystemEnv.getHtmlLabelName(618,user.getLanguage())+"',url:'/CRM/data/ViewLog.jsp?log=n&CustomerID="+CustomerID+"'}";

%><%}%>
<%if(!isCustomerSelf){
arrOtherTab+=",{tid:'t6082',id:'crmContract',title:'"+SystemEnv.getHtmlLabelName(6082,user.getLanguage())+"',url:'/CRM/data/ViewContactLog.jsp?log=n&CustomerID="+CustomerID+"'}";
}
arrOtherTab+=",{tid:'t15153',id:'crmExchange',title:'"+SystemEnv.getHtmlLabelName(15153,user.getLanguage())+"',url:'/discuss/ViewExchange.jsp?types=CC&sortid="+CustomerID+"'}";
%>

<%
arrOtherTab+=",{tid:'t110',title:'"+SystemEnv.getHtmlLabelName(110,user.getLanguage())+"',url:'/CRM/data/ViewAddress.jsp?CustomerID="+CustomerID+"&canedit="+canedit+"'}";
%>


<!-- BUTTON class=btn  accessKey=S onclick='location.href="/sms/SmsMessageEdit.jsp?crmid=<%=RecordSetC.getString(1)%>"'><U>S</U>-发送短信</BUTTON -->
<%if(!isCustomerSelf){%>
<%

arrOtherTab+=",{tid:'t2227',title:'"+SystemEnv.getHtmlLabelName(2227,user.getLanguage())+"',url:'/CRM/sellchance/ListSellChance.jsp?CustomerID="+CustomerID+"'}";

%>
<%}%>
<%if(!user.getLogintype().equals("2")){%>
<%

arrOtherTab+=",{tid:'t614',title:'"+SystemEnv.getHtmlLabelName(614,user.getLanguage())+"',url:'/CRM/data/ContractList.jsp?CustomerID="+CustomerID+"'}";
%>
<%}%>
<%if (canedit) {%>
<%
arrOtherTab+=",{tid:'t6070',title:'"+SystemEnv.getHtmlLabelName(6070,user.getLanguage())+"',url:'/CRM/data/GetEvaluation.jsp?CustomerID="+CustomerID+"'}";
arrOtherTab+=",{tid:'t6061',title:'"+SystemEnv.getHtmlLabelName(6061,user.getLanguage())+"',url:'/CRM/data/AddContacterLogRemind.jsp?CustomerID="+CustomerID+"'}";
%>
<%}%>
<%if (isCreater) {%>
<%
arrOtherTab+=",{tid:'t136',title:'"+SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(216,user.getLanguage())+"',url:'/CRM/data/UniteCustomer.jsp?CustomerID="+CustomerID+"'}";
%>
<%}%>

<%



}

arrOtherTab+="]";
%>
<script language=javascript>
	var arrOtherTab=eval(<%=arrOtherTab%>);
	var tablist="";
	var fistTabItem="";
	var iframeList="";
	for(var item=0;item<arrOtherTab.length;item++){
		if(item==0){
			
			tablist+="<li id='"+arrOtherTab[item].id+"' sid='"+arrOtherTab[item].tid+"'  first=yes url='"+arrOtherTab[item].url+"&isfromtab=true"+"'><div class=\"tab-selected tab-item\" ><a  href='javascript:void(0)'  >"+arrOtherTab[item].title+"</a></div><li>";
			iframeList+=" <iframe src='"+arrOtherTab[item].url+"'  id='iframepage'  frameBorder=0 scrolling=auto width=100% onload='iFrameHeight(\"iframepage\")'  style='display:block;'></iframe>";
			
		} else{
			tablist+="<li id='"+arrOtherTab[item].id+"' sid='"+arrOtherTab[item].tid+"'   url='"+arrOtherTab[item].url+"&isfromtab=true"+"'><div class=\"tab-item\" ><a  href='javascript:void(0)'>"+arrOtherTab[item].title+"</a></div><li>";
			//iframeList+=" <iframe src=''  id='"+arrOtherTab[item].id+"'  frameBorder=0 scrolling=no width='100%' onload='iFrameHeight()'  style='display:none;'></iframe>";
		}
	}
	
</script>
<table width="100%" style="min-width:820px;">
	<colgroup>
		<col width="5">
		<col width="">
		<col width="5">
	</colgroup>
	<tr>
		<td colspan="3" height="0px"></td>
	</tr>
	<tr>
		<td></td>
		<td>
		
		<table cellpadding="0" cellspacing="0" width="100%" border="0">
  	<tr>
  		<td width="6px" height="28px;" style="">
			<div id="tab-left" class="tab-left-selected" style="">
				
			</div>
		</td>
		<td>
			<div id="tab-center" >
				<ul>
					<script>
						document.write(tablist);
					</script>
				</ul>
			</div>
		</td>
		<td width="6px" style="">
			<div id="tab-right" style=""></div>
		</td>
  	</tr>
  </table>
    <div style="height:10px;"></div>
  <div id="content">
				<script>
					 document.write(iframeList);
				</script>

  </div>
		
		</td>
		<td></td>
			
	</tr>
</table>
</BODY>
</HTML>
<script language="javascript">
var arrOtherTab=eval(<%=arrOtherTab%>);
function iFrameHeight(id) {   
	var ifm= document.getElementById(id);   
	var subWeb = document.frames ? document.frames[id].document : ifm.contentDocument;   
	/*if(ifm != null && subWeb != null) {
	   ifm.height = subWeb.body.scrollHeight;
	}   

	ifm.height=(document.body.clientHeight-ifm.offsetTop-20);
	if(ifm != null && subWeb != null) {
	   ifm.height = subWeb.body.scrollHeight;
	} */
	ifm.height=document.body.clientHeight-getElementTop(ifm)-3;
}   

function setTabPanelActive(id){
	jQuery("#"+id).trigger("click");
}

$("#tab-left").addClass("tab-left-selected");
$(function(){
	initMenuWidth();
	$("#tab-center li").click(function(){
		$("#tab-center li .tab-selected").removeClass("tab-selected");
		$(this).children("div").addClass("tab-selected");
		$("#content iframe").css("display","none");
		var temid=$(this).attr("sid");
		if($(this).attr("first")=="yes"){
			$("#tab-left").removeClass("tab-left-unselected");
			$("#tab-left").addClass("tab-left-selected");
			
			$("#iframepage").css("display","block");
		}else{
			$("#tab-left").removeClass("tab-left-selected");
			$("#tab-left").addClass("tab-left-unselected");
			if($("#"+$(this).attr("sid")).attr("src")==undefined){
			  $("#content").append(	" <iframe src=''  id='"+$(this).attr("sid")+"'  frameBorder=0 scrolling=auto width='100%' onload='iFrameHeight(\""+temid+"\")'  style='display:none;'></iframe>");
			  $("#"+$(this).attr("sid")).attr("src",$(this).attr("url")).load(function(){});

			}
		}
	
		
			$("#"+$(this).attr("sid")).css("display","block");
	});
		window.onresize=function(){
			var ifms=document.getElementsByTagName("iframe");
			for(var i=0;i<ifms.length;i++ ){
				ifms[i].height=document.body.clientHeight-getElementTop(ifms[i])-3;
			}
		}
	});
	function getElementTop(element){
	　　　　var actualTop = element.offsetTop;
	　　　　var current = element.offsetParent;

	　　　　while (current !== null){
	　　　　　　actualTop += current.offsetTop;
	　　　　　　current = current.offsetParent;
	　　　　}

	　　　　return actualTop;
	　　}
	function initMenuWidth(){
		var tabWidth=0;
		$("#tab-center li").each(function(e,e2){
			tabWidth+=$(e2).width();
		});
		$("#tab-center ul").css("width",tabWidth+10);
	}
</script>

