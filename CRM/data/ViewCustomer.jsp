
<%@page import="weaver.crm.customer.CustomerShareUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="RecordSetFF" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetLog" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />

<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CoworkDAO" class="weaver.cowork.CoworkDAO" scope="page"/>

<jsp:useBean id="CustomerModifyLog" class="weaver.crm.data.CustomerModifyLog" scope="page"/>
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
	
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="CustomerStatusCount" class="weaver.crm.CustomerStatusCount" scope="page"/>
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
int item = Util.getIntValue(request.getParameter("item"),0);
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
	 // response.sendRedirect("ViewPerCustomer.jsp?"+request.getQueryString());
	  // return;
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

int sharelevel = CrmShareBase.getRightLevelForCRM(""+user.getUID(),CustomerID,""+usertype); 
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
if(!canview && !isCustomerSelf){
	
	String moduleid=Util.null2String(request.getParameter("moduleid"));
	Map<String,String> params=new HashMap<String,String>();
	params.put("logintype",logintype);
	
	Enumeration enu=request.getParameterNames();
	while(enu.hasMoreElements()){
		String paraName=(String)enu.nextElement();
		String value=request.getParameter(paraName);
	    
		params.put(paraName, value);
	}
	if(CustomerShareUtil.customerRightCheck(""+userid,CustomerID,moduleid,params)){
		onlyview=true;
	}else{
		response.sendRedirect("/notice/noright.jsp") ;
        return ;
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

<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>

<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>

<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type="text/css" />

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
String menustr="";
String queryString=request.getQueryString();
String addshow = Util.null2String(request.getParameter("addshow"),"");
//基本信息
String fromPortalStr = "";
if("true".equals(Util.null2String(request.getParameter("fromPortal")))){
	fromPortalStr="&fromPortal=true";
}
menustr+="<li id='t1361' class='current'><a href='/CRM/data/ViewCustomerBase.jsp?addshow="+addshow+"&isfromtab=true&requestid="+requestid+"&isrequest="+isrequest+"&CustomerID="+CustomerID+"&"+queryString+fromPortalStr+"' target='tabcontentframe'>"+SystemEnv.getHtmlLabelName(1361,user.getLanguage())+"</a></li>";
if(user.getLogintype().equals("2")&&!isCustomerSelf)onlyview=true;
if(!onlyview){
int count = CustomerStatusCount.getExchangeInfoCount(CustomerID,"CC",user.getUID());
String info = count==0?"":"("+count+")";

if(portalstatus2.equals("2")){ //开通门户
	//客户留言
	menustr+="<li id='crmExchange'><a href='/CRM/data/ViewMessageLog.jsp?isfromtab=true&types=CC&customerid="+CustomerID+"' target='tabcontentframe'>"+SystemEnv.getHtmlLabelName(84344,user.getLanguage())+info+"</a></li>";	
}
//客户联系
if(!isCustomerSelf){
	int countView = 0;
	rs.execute("SELECT count(*) FROM WorkPlan WHERE type_n = 3 and crmid = "+CustomerID+" AND resourceid != '"+user.getUID()+"' "+
				" AND id NOT IN ( SELECT workPlanId FROM WorkPlanViewLog WHERE userId = "+user.getUID()+")");
	rs.next();
	countView = rs.getInt(1);
	String infoView = countView <= 0?"":"<span id='contactNum'>("+countView+")<span>";
	menustr+="<li id='crmContract'><a href='/CRM/data/ViewContactLog.jsp?isfromtab=true&log=n&CustomerID="+CustomerID+"' target='tabcontentframe'>"+SystemEnv.getHtmlLabelName(6082,user.getLanguage())+infoView+"</a></li>";
}

if(canedit){
	//共享设置
	menustr+="<li id='t6070'><a href='/CRM/data/ViewCustomerShare.jsp?isfromtab=true&CustomerID="+CustomerID+"' target='tabcontentframe'>"+SystemEnv.getHtmlLabelName(2112,user.getLanguage())+"</a></li>";
	
}

//统计报告
//menustr+="<li id='t352'><a href='/CRM/data/ViewCustomerTotal.jsp?isfromtab=true&isrequest="+isrequest+"&CustomerID="+CustomerID+"' target='tabcontentframe'>"+SystemEnv.getHtmlLabelName(15296,user.getLanguage())+"</a></li>";


//修改记录
if(canviewlog){
	menustr+="<li id='t618'><a href='/CRM/data/ViewLog.jsp?isfromtab=true&log=n&CustomerID="+CustomerID+"' target='tabcontentframe'>"+SystemEnv.getHtmlLabelName(618,user.getLanguage())+"</a></li>";
}

//地址管理
menustr+="<li id='t110'><a href='/CRM/data/ViewAddress.jsp?isfromtab=true&CustomerID="+CustomerID+"&canedit="+canedit+"' target='tabcontentframe'>"+SystemEnv.getHtmlLabelName(84374,user.getLanguage())+"</a></li>";

//销售机会
if(!isCustomerSelf){
	menustr+="<li id='t2227'><a href='/CRM/sellchance/ListSellChance.jsp?isfromtab=true&CustomerID="+CustomerID+"' target='tabcontentframe'>"+SystemEnv.getHtmlLabelNames("82545",user.getLanguage())+"</a></li>";
}

//合同管理
if(!user.getLogintype().equals("2")){
	menustr+="<li id='t614'><a href='/CRM/data/ContractList.jsp?isfromtab=true&CustomerID="+CustomerID+"' target='tabcontentframe'>"+SystemEnv.getHtmlLabelName(16260,user.getLanguage())+"</a></li>";
}

if (canedit) {
	//客户价值
	menustr+="<li id='t6070'><a href='/CRM/data/GetEvaluation.jsp?isfromtab=true&CustomerID="+CustomerID+"' target='tabcontentframe'>"+SystemEnv.getHtmlLabelName(6073,user.getLanguage())+"</a></li>";
	//联系提醒
	//menustr+="<li id='t6061'><a href='/CRM/data/AddContacterLogRemind.jsp?CustomerID="+CustomerID+"' target='tabcontentframe'>"+SystemEnv.getHtmlLabelName(16403,user.getLanguage())+"</a></li>";
}
if (isCreater) {
	//客户合并
	//menustr+="<li id='t136'><a href='/CRM/data/UniteCustomer.jsp?CustomerID="+CustomerID+"' target='tabcontentframe'>"+SystemEnv.getHtmlLabelName(136,user.getLanguage())+"</a></li>";
}

//外部用户
if(canApply||user.getUID()==1){
	menustr+="<li id='t60701'><a href='/hrm/outinterface/outresourceList.jsp?isfromtab=true&crmid="+CustomerID+"' target='tabcontentframe'>"+SystemEnv.getHtmlLabelName(125931,user.getLanguage())+"</a></li>";
}
//联系人图谱
menustr+="<li id='t60701'><a href='/CRM/contacter/contacterMind.jsp?isfromtab=true&customerId="+CustomerID+"' target='tabcontentframe'>"+SystemEnv.getHtmlLabelName(572,user.getLanguage())+SystemEnv.getHtmlLabelName(82639,user.getLanguage())+"</a></li>";
}

%>
<div class="e8_box demo2" id="rightContent">
	<div class="e8_boxhead">
		<div class="div_e8_xtree" id="div_e8_xtree"></div>
        <div class="e8_tablogo" id="e8_tablogo"></div>
		<div class="e8_ultab">
			<div class="e8_navtab" id="e8_navtab">
				<span id="objName"></span>
			</div>
			<div>
				<ul class="tab_menu">
		    		<%=menustr%>	        		        
		   	 	</ul>
		    <div id="rightBox" class="e8_rightBox"></div>
			</div>
		</div>
	</div>
		
		<div class="tab_box">
		<%
		String srcurl = "/CRM/data/ViewCustomerBase.jsp?isfromtab=true&requestid="+requestid+"&isrequest="+isrequest+"&CustomerID="+CustomerID;
		Enumeration enu=request.getParameterNames();
		while(enu.hasMoreElements()){
			String paraName=(String)enu.nextElement();
			if("isfromtab".equals(paraName)
					||"requestid".equals(paraName)
					||"isrequest".equals(paraName)
					||"CustomerID".equals(paraName)){
				continue;
			}
			String value=request.getParameter(paraName);
			srcurl+="&"+paraName+"="+value;
		}
		%>
	            <iframe src="<%=srcurl%>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
        </div>
</div>
</BODY>
</HTML>

<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
		getLine : 1,
		iframe : "tabcontentframe",
		mouldID:"<%= MouldIDConst.getID("customer")%>",
		staticOnLoad:true,
		objName:"<%=SystemEnv.getHtmlLabelName(20323,user.getLanguage())%>"
	});
}); 
</script>

<script language="javascript">

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

