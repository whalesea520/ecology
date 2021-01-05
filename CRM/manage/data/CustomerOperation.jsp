
<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ include file="/systeminfo/init_wev8.jsp" %><%@ page import="java.util.*" %><%@ page import="java.sql.Timestamp" %><%@ page import="weaver.file.FileUpload" %><%@ page import="weaver.cs.util.CustomerOperationUtil" %><%@ page import="weaver.conn.ConnStatement" %><jsp:useBean id="Util" class="weaver.general.Util" scope="page" /><jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/><jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page"/><jsp:useBean id="RecordSetP" class="weaver.conn.RecordSet" scope="page"/><jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" /><jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" /><jsp:useBean id="RecordSetT" class="weaver.conn.RecordSet" scope="page" /><jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" /><jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" /><jsp:useBean id="SendMail" class="weaver.crm.Maint.SendMail" scope="page" /><jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" /><jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/><jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/><jsp:useBean id="CrmViewer" class="weaver.crm.CrmViewer" scope="page"/><jsp:useBean id="ContractViewer" class="weaver.crm.ContractViewer" scope="page"/><jsp:useBean id="CustomerModifyLog" class="weaver.crm.data.CustomerModifyLog" scope="page"/><jsp:useBean id="TimeUtil" class="weaver.general.TimeUtil" scope="page" /><%--客户审批参数存储类--%><jsp:useBean id="ApproveCustomerParameter" class="weaver.workflow.request.ApproveCustomerParameter" scope="session"/><jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<%
FileUpload fu = new FileUpload(request);
char flag = 2; 
String ProcPara = "";
String strTemp = "";
String strTempmanager = "";
String CurrentUser = ""+user.getUID();
String CurrentUserName = ""+user.getUsername();
String SubmiterType = ""+user.getLogintype();
String ClientIP = request.getRemoteAddr();
String CustomerID = "";
String PortalLoginid = "";
String PortalPassword = "";
String SWFTitle="";
String SWFRemark="";
String SWFSubmiter="";
String SWFAccepter="";
String fieldName = "";// added by lupeng for TD826

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);
String method = Util.null2String(fu.getParameter("method"));
boolean isfromtab =  Util.null2String(fu.getParameter("isfromtab")).equals("true")?true:false;
String approvedesc = Util.null2String(fu.getParameter("approvedesc")); //客户审批描述
String requestid = Util.null2String(fu.getParameter("requestid")); //客户审批描述

String Remark=Util.fromScreen3(fu.getParameter("Remark"),user.getLanguage());
String RemarkDoc=Util.fromScreen3(fu.getParameter("RemarkDoc"),user.getLanguage());
String Status=Util.fromScreen3(fu.getParameter("Status"),user.getLanguage());
String Rating=Util.fromScreen3(fu.getParameter("Rating"),user.getLanguage());
String PortalStatus=Util.fromScreen3(fu.getParameter("PortalStatus"),user.getLanguage());

String CustomerStatus=Util.null2String(fu.getParameter("CustomerStatus"));//客户状态
String principalIds = Util.fromScreen3(fu.getParameter("principalIds"),user.getLanguage());
String exploiterIds = Util.fromScreen3(fu.getParameter("exploiterIds"),user.getLanguage());

if(method.equals("delete"))// 私人用户和企业用户共用该方法
{
	/*权限判断－－Begin*/
	CustomerID = Util.null2String(fu.getParameter("CustomerID"));
    String sql="SELECT * FROM CRM_CustomerInfo WHERE id = "+CustomerID;
	rs.executeSql(sql);
	String useridcheck=""+user.getUID();
	String customerDepartment=""+rs.getString("department") ;
	boolean canedit=false;
	boolean isCustomerSelf=false;

	if(!HrmUserVarify.checkUserRight("EditCustomer:Delete",user,customerDepartment)) { 
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
	}
	/*权限判断－－End*/
	RecordSet.executeProc("CRM_CustomerInfo_Delete",""+CustomerID+flag+"1");
	ProcPara = CustomerID;
	ProcPara += flag+"d";
	ProcPara += flag+RemarkDoc;
	ProcPara += flag+Remark;
	ProcPara += flag+CurrentDate;
	ProcPara += flag+CurrentTime;
	ProcPara += flag+CurrentUser;
	ProcPara += flag+SubmiterType;
	ProcPara += flag+ClientIP;
	RecordSet.executeProc("CRM_Log_Insert",ProcPara);

    CustomerModifyLog.deleteCustomerLog(CustomerID);

	response.sendRedirect("/CRM/search/CRMCategory.jsp");
	return;
}
String Name=Util.fromScreen3(fu.getParameter("Name"),user.getLanguage());
String crmCode = Util.fromScreen3(fu.getParameter("crmcode"),user.getLanguage());
String Abbrev=Util.fromScreen3(fu.getParameter("Abbrev"),user.getLanguage());
String Address1=Util.fromScreen3(fu.getParameter("Address1"),user.getLanguage());
String Address2=Util.fromScreen3(fu.getParameter("Address2"),user.getLanguage());
String Address3=Util.fromScreen3(fu.getParameter("Address3"),user.getLanguage());
String Zipcode=Util.fromScreen3(fu.getParameter("Zipcode"),user.getLanguage());
String City=Util.fromScreen3(fu.getParameter("City"),user.getLanguage());
String citytwoCode=Util.fromScreen3(fu.getParameter("citytwoCode"),user.getLanguage());

String Country=Util.fromScreen3(fu.getParameter("Country"),user.getLanguage());
String Province= CityComInfo.getCityprovinceid(City);
String county=Util.fromScreen3(fu.getParameter("citytwoCode"),user.getLanguage());
String Language=Util.fromScreen3(fu.getParameter("Language"),user.getLanguage());
String Phone=Util.fromScreen3(fu.getParameter("Phone"),user.getLanguage());
String Fax=Util.fromScreen3(fu.getParameter("Fax"),user.getLanguage());
String Email=Util.fromScreen3(fu.getParameter("Email"),user.getLanguage());
String Website=Util.fromScreen3(fu.getParameter("Website"),user.getLanguage());
String bankName=Util.fromScreen3(fu.getParameter("bankname"),user.getLanguage());
String accountName = Util.fromScreen3(fu.getParameter("accountname"),user.getLanguage());
String accounts=Util.fromScreen3(fu.getParameter("accounts"),user.getLanguage());
String introduction= Util.fromScreen3(fu.getParameter("introduction"),user.getLanguage());//介绍

// added by lupeng 2004-8-9 for TD826.
if (Province.equals(""))
	Province = "0";
// end.
if(Website.indexOf(":")==-1){
   Website="http://"+Website.trim();
}else{
   Website=Util.StringReplace(Website,"\\","/");
}
String Type=Util.null2String(fu.getParameter("Type")); //客户类型
String TypeFrom=CurrentDate;
String Description=Util.fromScreen3(fu.getParameter("Description"),user.getLanguage());
String Size=Util.fromScreen3(fu.getParameter("Size"),user.getLanguage());
String Source=Util.fromScreen3(fu.getParameter("Source"),user.getLanguage());
String Sector=Util.fromScreen3(fu.getParameter("Sector"),user.getLanguage());
String Manager=Util.fromScreen3(fu.getParameter("Manager"),user.getLanguage());
//部门由人力资源表中选出该经理的部门
String Department= ResourceComInfo.getDepartmentID(Manager);
String Subcompanyid1=DepartmentComInfo.getSubcompanyid1(Department);
String Agent=Util.fromScreen3(fu.getParameter("Agent"),user.getLanguage());
String Parent=Util.fromScreen3(fu.getParameter("Parent"),user.getLanguage());
String Document=Util.fromScreen3(fu.getParameter("Document"),user.getLanguage());
String seclevel=Util.fromScreen3(fu.getParameter("seclevel"),user.getLanguage());
String Photo=Util.fromScreen3(fu.getParameter("Photo"),user.getLanguage());
String introductionDocid=Util.fromScreen3(fu.getParameter("introductionDocid"),user.getLanguage());
String CreditAmount=Util.fromScreen3(fu.getParameter("CreditAmount"),user.getLanguage());
String CreditTime=Util.fromScreen3(fu.getParameter("CreditTime"),user.getLanguage());

String customerimageid = "";//联系人照片
try
{
	customerimageid = Util.null2String(fu.uploadFiles("photoid"));//联系人照片
}
catch(Exception e)
{
	customerimageid = "";
}

String creditLevel = "0";

if(CreditAmount!=null&&!CreditAmount.trim().equals("")){
	RecordSet.executeProc("Sales_CRM_CreditInfo_Select" , CreditAmount+"");
	if (RecordSet.next()){
		creditLevel = RecordSet.getString(1);
	}
}

if(introductionDocid.equals("")) introductionDocid = "0";
if(Photo.equals("")) Photo = "0";

String dff01=Util.null2String(fu.getParameter("dff01"));
String dff02=Util.null2String(fu.getParameter("dff02"));
String dff03=Util.null2String(fu.getParameter("dff03"));
String dff04=Util.null2String(fu.getParameter("dff04"));
String dff05=Util.null2String(fu.getParameter("dff05"));

boolean isOracle = (RecordSet.getDBType()).equals("oracle");

String nff01=Util.null2String(fu.getParameter("nff01"));
if(nff01.equals(""))
	if (isOracle)
		nff01="0";
	else
		nff01="0.0";

String nff02=Util.null2String(fu.getParameter("nff02"));
if(nff02.equals(""))
	if (isOracle)
		nff02="0";
	else
		nff02="0.0";

String nff03=Util.null2String(fu.getParameter("nff03"));
if(nff03.equals(""))
	if (isOracle)
		nff03="0";
	else
		nff03="0.0";

String nff04=Util.null2String(fu.getParameter("nff04"));
if(nff04.equals(""))
	if (isOracle)
		nff04="0";
	else
		nff04="0.0";

String nff05=Util.null2String(fu.getParameter("nff05"));
if(nff05.equals(""))
	if (isOracle)
		nff05="0";
	else
		nff05="0.0";

String tff01=Util.fromScreen3(fu.getParameter("tff01"),user.getLanguage());
String tff02=Util.fromScreen3(fu.getParameter("tff02"),user.getLanguage());
String tff03=Util.fromScreen3(fu.getParameter("tff03"),user.getLanguage());
String tff04=Util.fromScreen3(fu.getParameter("tff04"),user.getLanguage());
String tff05=Util.fromScreen3(fu.getParameter("tff05"),user.getLanguage());

String bff01=Util.null2String(fu.getParameter("bff01"));
if(bff01.equals("")) bff01="0";
String bff02=Util.null2String(fu.getParameter("bff02"));
if(bff02.equals("")) bff02="0";
String bff03=Util.null2String(fu.getParameter("bff03"));
if(bff03.equals("")) bff03="0";
String bff04=Util.null2String(fu.getParameter("bff04"));
if(bff04.equals("")) bff04="0";
String bff05=Util.null2String(fu.getParameter("bff05"));
if(bff05.equals("")) bff05="0";

if(method.equals("add"))
{
	ProcPara = Name;
	ProcPara += flag+Language;
	ProcPara += flag+Abbrev;
	ProcPara += flag+Address1;
	ProcPara += flag+Address2;
	ProcPara += flag+Address3;
	ProcPara += flag+Zipcode;
	ProcPara += flag+City;
	ProcPara += flag+Country;
	ProcPara += flag+Province;
	ProcPara += flag+citytwoCode;
	ProcPara += flag+Phone;
	ProcPara += flag+Fax;
	ProcPara += flag+Email;
	ProcPara += flag+Website;
	ProcPara += flag+Source;
	ProcPara += flag+Sector;
	ProcPara += flag+Size;
	ProcPara += flag+Manager;
	ProcPara += flag+Agent;
	ProcPara += flag+Parent;
	ProcPara += flag+Department;
	ProcPara += flag+Subcompanyid1;
	ProcPara += flag+"0";
	ProcPara += flag+"0";
	ProcPara += flag+"0";
	ProcPara += flag+creditLevel;
	ProcPara += flag+"0";
	ProcPara += flag+"100";
	ProcPara += flag+"";
	ProcPara += flag+"";
	ProcPara += flag+"0";
	ProcPara += flag+"0";
	ProcPara += flag+"0";
	ProcPara += flag+"0";
	ProcPara += flag+"0";
	ProcPara += flag+"";
	ProcPara += flag+"";
	ProcPara += flag+Document;
	ProcPara += flag+seclevel;
	ProcPara += flag+Photo;
	ProcPara += flag+Type;
	ProcPara += flag+TypeFrom;
	ProcPara += flag+Description;
	ProcPara += flag+CustomerStatus;//status
	ProcPara += flag+"0";//rating
	ProcPara += flag+introductionDocid;
	ProcPara += flag+CreditAmount;
	ProcPara += flag+CreditTime;
	ProcPara += flag+dff01;
	ProcPara += flag+dff02;
	ProcPara += flag+dff03;
	ProcPara += flag+dff04;
	ProcPara += flag+dff05;
	ProcPara += flag+nff01;
	ProcPara += flag+nff02;
	ProcPara += flag+nff03;
	ProcPara += flag+nff04;
	ProcPara += flag+nff05;
	ProcPara += flag+tff01;
	ProcPara += flag+tff02;
	ProcPara += flag+tff03;
	ProcPara += flag+tff04;
	ProcPara += flag+tff05;
	ProcPara += flag+bff01;
	ProcPara += flag+bff02;
	ProcPara += flag+bff03;
	ProcPara += flag+bff04;
	ProcPara += flag+bff05;
	ProcPara += flag+CurrentDate;
    ProcPara += flag+bankName;
	ProcPara += flag+accountName;
    ProcPara += flag+accounts;
    ProcPara += flag+crmCode;
    ProcPara += flag+introduction;//介绍的参数
//	out.print(ProcPara);
	RecordSet.writeLog(accountName);

	boolean insertSuccess = false ;
	insertSuccess = RecordSet.executeProc("CRM_CustomerInfo_Insert",ProcPara);
	if (insertSuccess) {
		RecordSet.executeProc("CRM_CustomerInfo_InsertID","");
		RecordSet.first();
		CustomerID = RecordSet.getString(1);
		CustomerInfoComInfo.addCustomerInfoCache(CustomerID);

	//客户与客服负责人关联
	CustomerOperationUtil.saveCustomerPrincipal(CustomerID,principalIds);
	//客户与开拓人员关联
	CustomerOperationUtil.saveCustomerExploiter(CustomerID,exploiterIds);
	//客户跟进关键信息
	//CustomerOperationUtil.saveSellInfo(CustomerID,user,fu);

		//通知客户经理的经理
		String operators = ResourceComInfo.getManagerID(Manager);
    
    //modify by xhheng @20050221 for TD 1373
    if(operators!=null && !operators.equals("0")){
    		/**
			SWFAccepter=operators;
			SWFTitle=SystemEnv.getHtmlLabelName(15006,user.getLanguage());
			SWFTitle += Name;
			SWFTitle += "-"+CurrentUserName;
			SWFTitle += "-"+CurrentDate;
			SWFRemark="";
			SWFSubmiter=CurrentUser;
			SysRemindWorkflow.setCRMSysRemind(SWFTitle,Util.getIntValue(CustomerID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
			*/
			//系统触发流程会给客户经理的经理一个对该客户的查看权限，与下面的CrmShareBase.setDefaultShare(""+CustomerID);重复。
			RecordSet.executeSql("delete from CRM_shareinfo where relateditemid="+CustomerID);
    }

		ProcPara = CustomerID;
		ProcPara += flag+"n";
		ProcPara += flag+RemarkDoc;
		ProcPara += flag+Remark;
		ProcPara += flag+CurrentDate;
		ProcPara += flag+CurrentTime;
		ProcPara += flag+CurrentUser;
		ProcPara += flag+SubmiterType;
		ProcPara += flag+ClientIP;
		RecordSet.executeProc("CRM_Log_Insert",ProcPara);

    String Title=Util.fromScreen3(fu.getParameter("Title"),user.getLanguage());
		String LastName=Util.fromScreen3(fu.getParameter("LastName"),user.getLanguage());
		String FirstName=Util.fromScreen3(fu.getParameter("FirstName"),user.getLanguage());
		String JobTitle=Util.fromScreen3(fu.getParameter("JobTitle"),user.getLanguage());
		String CEmail=Util.fromScreen3(fu.getParameter("CEmail"),user.getLanguage());
		String PhoneOffice=Util.fromScreen3(fu.getParameter("PhoneOffice"),user.getLanguage());
		String PhoneHome=Util.fromScreen3(fu.getParameter("PhoneHome"),user.getLanguage());
		String Mobile=Util.fromScreen3(fu.getParameter("Mobile"),user.getLanguage());

		String interest=Util.fromScreen3(fu.getParameter("interest"),user.getLanguage());
		String hobby=Util.fromScreen3(fu.getParameter("hobby"),user.getLanguage());
		String managerstr=Util.fromScreen3(fu.getParameter("managerstr"),user.getLanguage());
		String subordinate=Util.fromScreen3(fu.getParameter("subordinate"),user.getLanguage());
		String strongsuit=Util.fromScreen3(fu.getParameter("strongsuit"),user.getLanguage());
		String age=Util.fromScreen3(fu.getParameter("age"),user.getLanguage());
		String birthday=Util.fromScreen3(fu.getParameter("birthday"),user.getLanguage());
		String home=Util.fromScreen3(fu.getParameter("home"),user.getLanguage());
		String school=Util.fromScreen3(fu.getParameter("school"),user.getLanguage());
		String speciality=Util.fromScreen3(fu.getParameter("speciality"),user.getLanguage());
		String nativeplace=Util.fromScreen3(fu.getParameter("nativeplace"),user.getLanguage());
		String experience=Util.fromScreen3(fu.getParameter("experience"),user.getLanguage());
		

		ProcPara = CustomerID;
		ProcPara += flag+Title;
		ProcPara += flag+FirstName;
		ProcPara += flag+LastName;
		ProcPara += flag+FirstName;
		ProcPara += flag+JobTitle;
		ProcPara += flag+CEmail;
		ProcPara += flag+PhoneOffice;
		ProcPara += flag+PhoneHome;
		ProcPara += flag+Mobile;
		ProcPara += flag+"";
		ProcPara += flag+Language;
		ProcPara += flag+Manager;
		ProcPara += flag+"1";
		ProcPara += flag+"0";

		ProcPara += flag+interest;
		ProcPara += flag+hobby;
		ProcPara += flag+managerstr;
		ProcPara += flag+subordinate;
		ProcPara += flag+strongsuit;
		ProcPara += flag+age;
		ProcPara += flag+birthday;
		ProcPara += flag+home;
		ProcPara += flag+school;
		ProcPara += flag+speciality;
		ProcPara += flag+nativeplace;
		ProcPara += flag+experience;

		ProcPara += flag+"";
		ProcPara += flag+"";
		ProcPara += flag+"";
		ProcPara += flag+"";
		ProcPara += flag+"";
		ProcPara += flag+"0.0";
		ProcPara += flag+"0.0";
		ProcPara += flag+"0.0";
		ProcPara += flag+"0.0";
		ProcPara += flag+"0.0";
		ProcPara += flag+"";
		ProcPara += flag+"";
		ProcPara += flag+"";
		ProcPara += flag+"";
		ProcPara += flag+"";
		ProcPara += flag+"0";
		ProcPara += flag+"0";
		ProcPara += flag+"0";
		ProcPara += flag+"0";
		ProcPara += flag+"0";

		ProcPara += flag+""+flag+""+flag+"";
		ProcPara += flag+Util.fromScreen3(fu.getParameter("imcode"),user.getLanguage());
		ProcPara += flag+Util.fromScreen3(fu.getParameter("status"),user.getLanguage());
		ProcPara += flag+Util.fromScreen3(fu.getParameter("isneedcontact"),user.getLanguage());
		ProcPara += flag+Util.fromScreen3(fu.getParameter("projectrole"),user.getLanguage());
		ProcPara += flag+Util.fromScreen3(fu.getParameter("attitude"),user.getLanguage());
		ProcPara += flag+Util.fromScreen3(fu.getParameter("attention"),user.getLanguage());
		RecordSet.executeProc("CRM_CustomerContacter_Insert",ProcPara);//联系人部分
		RecordSet.executeSql("SELECT MAX(id) as id from CRM_CustomerContacter");
		if(RecordSet.next()){
			String ContacterID = RecordSet.getString("id");
			RecordSet.executeSql("update CRM_CustomerContacter set creater="+user.getUID()+",createdate='"+CurrentDate+"',createtime='"+CurrentTime+"' where id = " + ContacterID);
			/**
			//记录日志
			ProcPara = "";
			ProcPara = CustomerID+""+flag+"2"+flag+ContacterID+flag+"0";
			ProcPara += flag+FirstName+flag+CurrentDate+flag+CurrentTime+flag+""+flag+"";
			ProcPara += flag+Manager+flag+"1"+flag+ClientIP;
			RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
				
			ProcPara = CustomerID+"";
			ProcPara += flag+"nc";
			ProcPara += flag+"";
			ProcPara += flag+"";
			ProcPara += flag+CurrentDate;
			ProcPara += flag+CurrentTime;
			ProcPara += flag+Manager;
			ProcPara += flag+"1";
			ProcPara += flag+ClientIP;
			RecordSet.executeProc("CRM_Log_Insert",ProcPara);
			*/
		 }
		
		/**添加客户联系人相片**/
		if(!"".equals(customerimageid)){
			rs.executeSql("update CRM_CustomerContacter set contacterimageid = "+customerimageid+" where customerid = "+CustomerID);
		}
		ProcPara = CustomerID;
		ProcPara += flag + "1";
		ProcPara += flag + "30";
		ProcPara += flag + "0";
		RecordSet.executeProc("CRM_ContacterLog_R_Insert",ProcPara);

		ProcPara = CustomerID;
		ProcPara += flag+"0";
		ProcPara += flag+CurrentUser;
		ProcPara += flag+"0";
		ProcPara += flag+"0";
		ProcPara += flag+"3";
		ProcPara += flag+"Create";
		ProcPara += flag+"0";
		ProcPara += flag+CurrentDate;
		ProcPara += flag+CurrentTime;
		ProcPara += flag+CurrentDate;
		ProcPara += flag+CurrentTime;
		ProcPara += flag+"";
		ProcPara += flag+"0";
		ProcPara += flag+CurrentDate;
		ProcPara += flag+CurrentTime;
		ProcPara += flag+"0";
		ProcPara += flag+"0";
		ProcPara += flag+"1";

		RecordSet.executeProc("CRM_ContactLog_Insert",ProcPara);//客户联系信息

		//RecordSet.executeProc("CRM_ShareInfo_Update",Type+flag+CustomerID);
		//CRM_ShareInfo
        CustomerModifyLog.modify(CustomerID,user.getUID()+"",Manager);
		//CrmViewer.setCrmShareByCrm(""+CustomerID);
		//在新的方式下添加客户默认共享，新建客户默认共享给客户经理及所有上级，客户管理员角色。
		CrmShareBase.setDefaultShare(""+CustomerID);
	}
	if(!isfromtab)
		response.sendRedirect("/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+CustomerID);
	else
		response.sendRedirect("/CRM/data/ViewCustomerBase.jsp?log=n&CustomerID="+CustomerID);
	
	return;
}

String Fincode=Util.fromScreen3(fu.getParameter("Fincode"),user.getLanguage());
String Currency=Util.fromScreen3(fu.getParameter("Currency"),user.getLanguage());
String ContractLevel=Util.fromScreen3(fu.getParameter("ContractLevel"),user.getLanguage());
String CreditLevel=Util.fromScreen3(fu.getParameter("CreditLevel"),user.getLanguage());
String CreditOffset=Util.fromScreen3(fu.getParameter("CreditOffset"),user.getLanguage());
if(CreditOffset.equals("")) CreditOffset="0";
String Discount=Util.fromScreen3(fu.getParameter("Discount"),user.getLanguage());
if(Discount.equals("")) Discount="100";
String TaxNumber=Util.fromScreen3(fu.getParameter("TaxNumber"),user.getLanguage());
String BankAccount=Util.fromScreen3(fu.getParameter("BankAccount"),user.getLanguage());
String InvoiceAcount=Util.fromScreen3(fu.getParameter("InvoiceAcount"),user.getLanguage());
String DeliveryType=Util.fromScreen3(fu.getParameter("DeliveryType"),user.getLanguage());
String PaymentTerm=Util.fromScreen3(fu.getParameter("PaymentTerm"),user.getLanguage());
String PaymentWay=Util.fromScreen3(fu.getParameter("PaymentWay"),user.getLanguage());
String SaleConfirm=Util.fromScreen3(fu.getParameter("SaleConfirm"),user.getLanguage());
String Credit=Util.fromScreen3(fu.getParameter("Credit"),user.getLanguage());
String CreditExpire=Util.fromScreen3(fu.getParameter("CreditExpire"),user.getLanguage());

CustomerID = Util.null2String(fu.getParameter("CustomerID"));
RecordSet.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
RecordSet.first();

if(method.equals("edit"))
{
	/*权限判断－－Begin*/
	String sql="SELECT * FROM CRM_CustomerInfo WHERE id = "+CustomerID;
	rs.executeSql(sql);
	String useridcheck=""+user.getUID();
	String customerDepartment=""+rs.getString("department") ;
	boolean canedit=false;
	boolean isCustomerSelf=false;
	int sharelevel = CrmShareBase.getRightLevelForCRM(""+user.getUID(),CustomerID);
	if(sharelevel>1) canedit=true;

if(user.getLogintype().equals("2") && CustomerID.equals(useridcheck)){
isCustomerSelf = true ;
}
if(useridcheck.equals(RecordSet.getString("agent"))){ 
	 canedit=true;
 }

if(rs.getInt("status")==7 || rs.getInt("status")==8){
	canedit=false;
}
	if(!canedit && !isCustomerSelf) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
 }	
	/*权限判断－－End*/
    //王金永 记录客户经理修改信息（完成新客户显示的功能）
    CustomerModifyLog.modify2(CustomerID,Manager);

	boolean bNeedUpdate = false;
	boolean bShareUpdate = false;

	strTemp = RecordSet.getString("name");
	if(!Name.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(195,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Name;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("engname");
	if(!Abbrev.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(399,user.getLanguage()) + "(" + SystemEnv.getHtmlLabelName(642,user.getLanguage()) + ")";
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Abbrev;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("address1");
	if(!Address1.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(110,user.getLanguage()) + "1";
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Address1;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("address2");
	if(!Address2.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(110,user.getLanguage()) + "2";
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Address2;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("address3");
	if(!Address3.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(110,user.getLanguage()) + "3";
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Address3;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("zipcode");
	if(!Zipcode.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(479,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Zipcode;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("city");
	if(!City.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(493,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+City;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("country");
	if(!Country.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(377,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Country;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("province");
	if(!Province.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(643,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Province;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("county");
	if(!county.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(644,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+county;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("language");
	if(!Language.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(231,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Language;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("phone");
	if(!Phone.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(421,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Phone;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("fax");
	if(!Fax.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(494,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Fax;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("email");
	if(!Email.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(477,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Email;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("website");
	if(!Website.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(76,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Website;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("type");
	if(!Type.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(63,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Type;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);

		//ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		//ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+RecordSet.getString("typebegin")+flag+CurrentDate;
		//ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		//RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("description");
	if(!Description.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(433,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Description;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("status");
	if(!Status.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(602,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Status;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("rating");
	if(!strTemp.equals("") && !strTemp.equals("0") && !Rating.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(139,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Rating;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
		//通知客户经理的经理
		/**
		String operators = ResourceComInfo.getManagerID(Manager);
		SWFAccepter=operators;
		SWFTitle=SystemEnv.getHtmlLabelName(15158,user.getLanguage());
		SWFTitle += Name;
		SWFTitle += "-"+CurrentUserName;
		SWFTitle += "-"+CurrentDate;
		SWFRemark="";
		SWFSubmiter=CurrentUser;
		SysRemindWorkflow.setCRMSysRemind(SWFTitle,Util.getIntValue(CustomerID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
		*/
	}

	strTemp = RecordSet.getString("size_n");
	if(!Size.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(576,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Size;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("source");
	if(!Source.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(645,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Source;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("sector");
	if(!Sector.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(575,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Sector;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("manager");
	if(!Manager.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(144,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Manager;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
		bShareUpdate = true;
		
		/*客户经理各级上级都有编辑权限在CrmShareBase.setDefaultShare中做
      // add the manager of the customer's manager "edit" right.
      // 客户经理各级上级都有编辑权限，开始
      String tempOperator = ResourceComInfo.getManagerID(Manager);
      String listOfOperator = "";
      int forFisrt = 1;//防止上下级设定是有循环
			while(!tempOperator.equals("")&&!tempOperator.equals("0")&&listOfOperator.indexOf(tempOperator)<0){
				RecordSet.executeProc("CRM_ShareEditToManager", CustomerID + flag + tempOperator);
				if(forFisrt==1){
					listOfOperator = tempOperator;
				}else{
					listOfOperator += ","+tempOperator;
				}
				tempOperator = ResourceComInfo.getManagerID(tempOperator);
				forFisrt = forFisrt + 1;
			}
			// 客户经理各级上级都有编辑权限， 结束
		*/

		//通知变更前后的客户经理
		String operators = Manager;
		/**
		SWFAccepter=operators;
		SWFTitle=SystemEnv.getHtmlLabelName(15159,user.getLanguage());
		SWFTitle += Name;
		SWFTitle += "-"+CurrentUserName;
		SWFTitle += "-"+CurrentDate;
		SWFRemark="";
		SWFSubmiter=CurrentUser;
		SysRemindWorkflow.setCRMSysRemind(SWFTitle,Util.getIntValue(CustomerID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
		*/
		//系统触发流程会给客户经理的经理一个对该客户的查看权限，与下面的CrmShareBase.setDefaultShare(""+CustomerID);重复。
		RecordSetT.executeSql("delete from CRM_shareinfo where contents="+operators+" and sharetype=1 and relateditemid="+CustomerID);

	}

	strTemp = RecordSet.getString("department");
	if(!Department.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(124,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Department;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
		bShareUpdate = true;
	}

	strTemp = RecordSet.getString("agent");
	if(!Agent.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(132,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Agent;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("parentid");
	if(!Parent.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(591,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Parent;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("documentid");
	if(!Document.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(58,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Document;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("seclevel");
	if(!seclevel.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(683,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+seclevel;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("picid");
	if(!Photo.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(74,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Photo;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("currency");
	if(!Currency.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(649,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Currency;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("contractlevel");
	if(!ContractLevel.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(581,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+ContractLevel;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("creditlevel");
	if(!CreditLevel.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(580,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+CreditLevel;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}


	strTemp = RecordSet.getString("creditoffset");
	if(!CreditOffset.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(650,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+CreditOffset;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("discount");
	if(!Discount.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(651,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Discount;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("taxnumber");
	if(!TaxNumber.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(653,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+TaxNumber;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("bankacount");
	if(!BankAccount.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(654,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+BankAccount;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("invoiceacount");
	if(!InvoiceAcount.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(655,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+InvoiceAcount;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("deliverytype");
	if(!DeliveryType.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(657,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+DeliveryType;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("paymentterm");
	if(!PaymentTerm.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(658,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+PaymentTerm;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("paymentway");
	if(!PaymentWay.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(652,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+PaymentWay;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("saleconfirm");
	if(!SaleConfirm.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(646,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+SaleConfirm;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("creditcard");
	if(!Credit.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(487,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Credit;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("creditexpire");
	if(!CreditExpire.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(488,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+CreditExpire;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("introductionDocid");
	if(!introductionDocid.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(6069,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+introductionDocid;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("datefield1");
	if(!dff01.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(97,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "1";
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+dff01;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("datefield2");
	if(!dff02.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(97,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "2";
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+dff02;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("datefield3");
	if(!dff03.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(97,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "3";
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+dff03;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("datefield4");
	if(!dff04.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(97,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "4";
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+dff04;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("datefield5");
	if(!dff05.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(97,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "5";
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+dff05;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("numberfield1");
	if(!nff01.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(607,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "1";
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+nff01;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("numberfield2");
	if(!nff02.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(607,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "2";
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+nff02;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("numberfield3");
	if(!nff03.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(607,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "3";
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+nff03;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("numberfield4");
	if(!nff04.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(607,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "4";
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+nff04;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("numberfield5");
	if(!nff05.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(607,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "5";
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+nff05;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("textfield1");
	if(!tff01.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(608,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "1";
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+tff01;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("textfield2");
	if(!tff02.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(608,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "2";
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+tff02;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("textfield3");
	if(!tff03.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(608,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "3";
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+tff03;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("textfield4");
	if(!tff04.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(608,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "4";
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+tff04;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("textfield5");
	if(!tff05.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(608,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "5";
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+tff05;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("tinyintfield1");
	if(!bff01.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(607,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "1";
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+bff01;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("tinyintfield2");
	if(!bff02.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(607,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "2";
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+bff02;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("tinyintfield3");
	if(!bff03.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(607,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "3";
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+bff03;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("tinyintfield4");
	if(!bff04.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(607,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "4";
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+bff04;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("tinyintfield5");
	if(!bff05.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(607,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "5";
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+bff05;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}
		ProcPara = CustomerID;
		ProcPara += flag+Name;
		ProcPara += flag+Language;
		ProcPara += flag+Abbrev;
		ProcPara += flag+Address1;
		ProcPara += flag+Address2;
		ProcPara += flag+Address3;
		ProcPara += flag+Zipcode;
		ProcPara += flag+City;
		ProcPara += flag+Country;
		ProcPara += flag+Province;
		ProcPara += flag+county;
		ProcPara += flag+Phone;
		ProcPara += flag+Fax;
		ProcPara += flag+Email;
		ProcPara += flag+Website;
		ProcPara += flag+Source;
		ProcPara += flag+Sector;
		ProcPara += flag+Size;
		ProcPara += flag+Manager;
		ProcPara += flag+Agent;
		ProcPara += flag+Parent;
		ProcPara += flag+Department;
		ProcPara += flag+Subcompanyid1;
		ProcPara += flag+Fincode;
		ProcPara += flag+Currency;
		ProcPara += flag+ContractLevel;
		ProcPara += flag+creditLevel;
		ProcPara += flag+CreditOffset;
		ProcPara += flag+Discount;
		ProcPara += flag+TaxNumber;
		ProcPara += flag+BankAccount;
		ProcPara += flag+InvoiceAcount;
		ProcPara += flag+DeliveryType;
		ProcPara += flag+PaymentTerm;
		ProcPara += flag+PaymentWay;
		ProcPara += flag+SaleConfirm;
		ProcPara += flag+Credit;
		ProcPara += flag+CreditExpire;
		ProcPara += flag+Document;
		ProcPara += flag+seclevel;
		ProcPara += flag+Photo;
		ProcPara += flag+Type;
		ProcPara += flag+TypeFrom;
		ProcPara += flag+Description;
		ProcPara += flag+Status;
		ProcPara += flag+Rating;
		ProcPara += flag+introductionDocid;
		ProcPara += flag+CreditAmount;
		ProcPara += flag+CreditTime;
		ProcPara += flag+dff01;
		ProcPara += flag+dff02;
		ProcPara += flag+dff03;
		ProcPara += flag+dff04;
		ProcPara += flag+dff05;
		ProcPara += flag+nff01;
		ProcPara += flag+nff02;
		ProcPara += flag+nff03;
		ProcPara += flag+nff04;
		ProcPara += flag+nff05;
		ProcPara += flag+tff01;
		ProcPara += flag+tff02;
		ProcPara += flag+tff03;
		ProcPara += flag+tff04;
		ProcPara += flag+tff05;
		ProcPara += flag+bff01;
		ProcPara += flag+bff02;
		ProcPara += flag+bff03;
		ProcPara += flag+bff04;
		ProcPara += flag+bff05;
        ProcPara += flag+bankName;
		ProcPara += flag+accountName;
        ProcPara += flag+accounts;
        ProcPara += flag+crmCode;
        ProcPara += flag+introduction;//介绍的参数
		boolean updateSuccess = false ;
		updateSuccess =	RecordSet.executeProc("CRM_CustomerInfo_Update",ProcPara);
		CustomerInfoComInfo.updateCustomerInfoCache(CustomerID);
		
		//客户与客服负责人关联
		CustomerOperationUtil.editCustomerPrincipal(CustomerID,principalIds);
		//客户与开拓人员关联
		CustomerOperationUtil.editCustomerExploiter(CustomerID,exploiterIds);
		//客户跟进关键信息
		//CustomerOperationUtil.editSellInfo(CustomerID,user,fu,request);

		
		if (updateSuccess) {
			//CustomerInfoComInfo.updateCustomerInfoCache(CustomerID);
			ProcPara = CustomerID;
			ProcPara += flag+"m";
			ProcPara += flag+RemarkDoc;
			ProcPara += flag+Remark;
			ProcPara += flag+CurrentDate;
			ProcPara += flag+CurrentTime;
			ProcPara += flag+CurrentUser;
			ProcPara += flag+SubmiterType;
			ProcPara += flag+ClientIP;
			RecordSet.executeProc("CRM_Log_Insert",ProcPara);
		}
	strTempmanager = RecordSet.getString("manager");
	if(!Manager.equals(strTempmanager)){//修改客户经理，重新设置客户默认共享
	    //CrmShareBase.setDefaultShare(""+CustomerID);
	    CrmShareBase.setCRM_WPShare_newCRMManager(""+CustomerID);
	}
	if(bShareUpdate)
	{
		//CrmViewer.setCrmShareByCrm(""+CustomerID);
		ContractViewer.setContractShareByCrmId(""+CustomerID);/*2003-11-07杨国生 客户全同*/
	}
	response.sendRedirect("/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+CustomerID);
	return;

}
%>
<%
if(method.equals("apply"))
{
	RecordSet.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
	RecordSet.first();
	strTemp = RecordSet.getString("status");
	String Manager2 = RecordSet.getString("manager");
	String name = RecordSet.getString("name");
	String tmpType = RecordSet.getString("type");

    int workflowid = 0;
    String sql = "select workflowid from CRM_CustomerType where id="+tmpType;
    //System.out.println("sql = " + sql);
    RecordSet.executeSql(sql);
    if(RecordSet.next()){
        workflowid = RecordSet.getInt("workflowid");
    }
   // System.out.println("workflowid = " + workflowid);
    if(workflowid==-1){
    	if(!isfromtab){
    		response.sendRedirect("ViewCustomer.jsp?CustomerID="+CustomerID+"&message=1");
    	}else{
        	response.sendRedirect("ViewCustomerBase.jsp?CustomerID="+CustomerID+"&message=1");
    	}
        return;
    }
    ApproveCustomerParameter.resetParameter();
    ApproveCustomerParameter.setWorkflowid(workflowid);
    ApproveCustomerParameter.setNodetype("0");
    ApproveCustomerParameter.setApproveid(Util.getIntValue(CustomerID,0));
    ApproveCustomerParameter.setApprovevalue(Status);
    ApproveCustomerParameter.setApprovetype("1");
    ApproveCustomerParameter.setRequestname(approvedesc);
    ApproveCustomerParameter.setManagerid(Util.getIntValue(Manager2,0));
    if(!isfromtab)
		 ApproveCustomerParameter.setGopage("/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+CustomerID);
	else
		 ApproveCustomerParameter.setGopage("/CRM/data/ViewCustomerBase.jsp?log=n&CustomerID="+CustomerID);
    //ApproveCustomerParameter.setBackpage(backpage);
    String redirectPage = "/workflow/request/BillApproveCustomerOperation.jsp?src=submit&iscreate=1&notneedsave=1";
    RecordSet.executeSql("select b.requestid from bill_ApproveCustomer a,workflow_requestbase b where a.requestid=b.requestid and b.currentnodetype='0' and a.approvetype=1 and a.approveid="+CustomerID);
    if(RecordSet.next()){
        String temprequestid = RecordSet.getString("requestid");
        redirectPage = "/workflow/request/BillApproveCustomerOperation.jsp?src=submit&iscreate=0&isfromcrm=1&requestid="+temprequestid;
    }
    response.sendRedirect(redirectPage);
    return;
}
if(method.equals("ApproveLevel"))
{
    RecordSet.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
    RecordSet.first();
    strTemp = RecordSet.getString("status");
    String Manager2 = RecordSet.getString("manager");
    String name = RecordSet.getString("name");

    //提醒客户经理，以及其经理
    ArrayList operators =new ArrayList();
    operators.add(Manager2);
    operators.add(ResourceComInfo.getManagerID(Manager2));
    int i = 0 ;
    for (i = 0; i<operators.size();i++ ) {
        if (!((String)operators.get(i)).equals(CurrentUser)) {
            SWFAccepter=(String)operators.get(i);
            SWFTitle=SystemEnv.getHtmlLabelName(15157,user.getLanguage());
            SWFTitle += name;
            SWFTitle += "-"+CurrentUserName;
            SWFTitle += "-"+CurrentDate;
            SWFRemark="";
            SWFSubmiter=CurrentUser;	SysRemindWorkflow.setCRMSysRemind(SWFTitle,Util.getIntValue(CustomerID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
        }
    }
	if(!isfromtab)
    	ApproveCustomerParameter.setGopage("/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+CustomerID);
	else
		ApproveCustomerParameter.setGopage("/CRM/data/ViewCustomerBase.jsp?log=n&CustomerID="+CustomerID);
    //ApproveCustomerParameter.setBackpage(backpage);
    response.sendRedirect("/workflow/request/BillApproveCustomerOperation.jsp?src=submit&iscreate=0&isneedsave=notneedsave&requestid="+requestid+"&isfromcrm=1");

	return;
}

if(method.equals("RejectLevel"))
{
	if(!isfromtab)
    	ApproveCustomerParameter.setGopage("/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+CustomerID);
	else
		ApproveCustomerParameter.setGopage("/CRM/data/ViewCustomerBase.jsp?log=n&CustomerID="+CustomerID);
    //ApproveCustomerParameter.setBackpage(backpage);
    response.sendRedirect("/workflow/request/BillApproveCustomerOperation.jsp?src=reject&iscreate=0&isneedsave=notneedsave&requestid="+requestid+"&isfromcrm=1");

	return;
}

if(method.equals("portal"))
{
	RecordSet.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
	RecordSet.first();
	strTemp = RecordSet.getString("status");
	String Manager2 = RecordSet.getString("manager");
	String name = RecordSet.getString("name");
	String tmpType = RecordSet.getString("type");

	seclevel = RecordSet.getString("seclevel");
    int workflowid = 0;
    String sql = "select workflowid from CRM_CustomerType where id="+tmpType;
    //System.out.println("sql = " + sql);
    RecordSet.executeSql(sql);
    if(RecordSet.next()){
        workflowid = RecordSet.getInt("workflowid");
    }
    if(workflowid==-1){
        response.sendRedirect("ViewCustomerBase.jsp?CustomerID="+CustomerID+"&message=1");
        return;
    }
    ApproveCustomerParameter.resetParameter();
    ApproveCustomerParameter.setWorkflowid(workflowid);
    ApproveCustomerParameter.setNodetype("0");
    ApproveCustomerParameter.setApproveid(Util.getIntValue(CustomerID,0));
    ApproveCustomerParameter.setApprovevalue(PortalStatus);
    ApproveCustomerParameter.setApprovetype("2");
    ApproveCustomerParameter.setSeclevel(seclevel);
    ApproveCustomerParameter.setRequestname(approvedesc);
    ApproveCustomerParameter.setManagerid(Util.getIntValue(Manager2,0));
    if(!isfromtab)
		 ApproveCustomerParameter.setGopage("/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+CustomerID);
	else
		 ApproveCustomerParameter.setGopage("/CRM/data/ViewCustomerBase.jsp?log=n&CustomerID="+CustomerID);
    //ApproveCustomerParameter.setBackpage(backpage);
    
    String redirectPage = "/workflow/request/BillApproveCustomerOperation.jsp?src=submit&iscreate=1&notneedsave=1";
    RecordSet.executeSql("select b.requestid from bill_ApproveCustomer a,workflow_requestbase b where a.requestid=b.requestid and b.currentnodetype='0' and a.approvetype=2 and a.approveid="+CustomerID);
    if(RecordSet.next()){
        String temprequestid = RecordSet.getString("requestid");
        redirectPage = "/workflow/request/BillApproveCustomerOperation.jsp?src=submit&iscreate=0&isfromcrm=1&requestid="+temprequestid;
    }
    response.sendRedirect(redirectPage);
    return;
}


if(method.equals("ApprovePortal"))
{
	CustomerID = Util.null2String(fu.getParameter("CustomerID"));

	RecordSet.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
	RecordSet.first();
	strTemp = RecordSet.getString("PortalStatus");
	String Manager2 = RecordSet.getString("manager");
	String name = RecordSet.getString("name");
	String operators = ResourceComInfo.getManagerID(Manager2);
	//ProcPara = CustomerID;
	//ProcPara += flag+PortalStatus;
    //
	//RecordSet.executeProc("CRM_CustomerInfo_Portal",ProcPara);
	if(PortalStatus.equals("1")){


		SWFAccepter=operators;
		SWFTitle=SystemEnv.getHtmlLabelName(15155,user.getLanguage());
		SWFTitle += name;
		SWFTitle += "-"+CurrentUserName;
		SWFTitle += "-"+CurrentDate;
		SWFRemark="";
		SWFSubmiter=CurrentUser;
		SysRemindWorkflow.setCRMSysRemind(SWFTitle,Util.getIntValue(CustomerID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);

	}
	else {

		SWFAccepter=operators;
		SWFTitle=SystemEnv.getHtmlLabelName(15156,user.getLanguage());
		SWFTitle += name;
		SWFTitle += "-"+CurrentUserName;
		SWFTitle += "-"+CurrentDate;
		SWFRemark="";
		SWFSubmiter=CurrentUser;
		SysRemindWorkflow.setCRMSysRemind(SWFTitle,Util.getIntValue(CustomerID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);

	}

	if(PortalStatus.equals("2")){//批准开放客户门户，客户可通过登录OA根据权限创建流程
		if (CustomerID.length()<5){
		   PortalLoginid = "U" + Util.add0(Util.getIntValue(CustomerID),5);
		}else{
		   PortalLoginid = "U" + CustomerID;
		}
		PortalPassword = Util.getPortalPassword();

		ProcPara = CustomerID;
		ProcPara += flag+PortalLoginid;
		ProcPara += flag+PortalPassword;

		RecordSet.executeProc("CRM_CustomerInfo_PortalPasswor",ProcPara);
		/*开放客户门户的添加客户信息到流程路径设置中门户相关的创建节点表workflow_createrlist中，凡是门户开放的客户可以根据权限新建相应的流程
		begin
		*/
		/**
		String iscustomsql = "select * from workflow_base where iscust = 1 ";//查询所有门户工作流
		RecordSet.executeSql(iscustomsql);
		String Procpara = "";
		while(RecordSet.next()){//workflow_createrlist:usertype字段即 客户安全级别
			Procpara=RecordSet.getInt("id")+"" + flag + CustomerID + flag  + "1" + flag  + seclevel;
			//System.out.println(" Procpara :"+Procpara);
			RecordSetV.executeProc("workflow_createrlist_Insert",Procpara);
		}*/
		//end
/*
		RecordSet.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
		RecordSet.next();
		String subject ="Portal Access -- "+RecordSet.getString("name");
		String from ="sales@weaver.com.cn";
		String sendto = RecordSet.getString("email");
		String content = RecordSet.getString("name");
		content += "<br><br>Weaver Ecology Portal Access: <a href=http://portal.weaver.8866.org>http://portal.weaver.8866.org</a>";
		content += "<br><br>" + "Loginid: " + PortalLoginid ;
		content += "<br><br>" + "Password: " + PortalPassword ;
		SendMail.SendSingleMail(request,from,sendto,subject,content);
*/
	}

	ProcPara = CustomerID;
	ProcPara += flag+"p";
	ProcPara += flag+RemarkDoc;
	ProcPara += flag+Remark;
	ProcPara += flag+CurrentDate;
	ProcPara += flag+CurrentTime;
	ProcPara += flag+CurrentUser;
	ProcPara += flag+SubmiterType;
	ProcPara += flag+ClientIP;
	RecordSet.executeProc("CRM_Log_Insert",ProcPara);

	fieldName = SystemEnv.getHtmlLabelName(23249,user.getLanguage());

	ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
	ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+PortalStatus;
	ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
	RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);

	 if(!isfromtab)
		 ApproveCustomerParameter.setGopage("/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+CustomerID);
	else
		 ApproveCustomerParameter.setGopage("/CRM/data/ViewCustomerBase.jsp?log=n&CustomerID="+CustomerID);
    //ApproveCustomerParameter.setBackpage(backpage);
    response.sendRedirect("/workflow/request/BillApproveCustomerOperation.jsp?src=submit&iscreate=0&isneedsave=notneedsave&requestid="+requestid+"&isfromcrm=1");

	return;
}

if(method.equals("RejectPortal"))
{
	if(!isfromtab)
		 ApproveCustomerParameter.setGopage("/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+CustomerID);
	else
		 ApproveCustomerParameter.setGopage("/CRM/data/ViewCustomerBase.jsp?log=n&CustomerID="+CustomerID);
    //ApproveCustomerParameter.setBackpage(backpage);
    response.sendRedirect("/workflow/request/BillApproveCustomerOperation.jsp?src=reject&iscreate=0&isneedsave=notneedsave&requestid="+requestid+"&isfromcrm=1");
	return;
}

if(method.equals("portalPwd"))
{
	RecordSet.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
	RecordSet.first();
	strTemp = RecordSet.getString("status");
	String Manager2 = RecordSet.getString("manager");
	String name = RecordSet.getString("name");
	String tmpType = RecordSet.getString("type");

    int workflowid = 0;
    String sql = "select workflowid from CRM_CustomerType where id="+tmpType;
    //System.out.println("sql = " + sql);
    RecordSet.executeSql(sql);
    if(RecordSet.next()){
        workflowid = RecordSet.getInt("workflowid");
    }
    if(workflowid==-1){
    	if(!isfromtab)
        	response.sendRedirect("ViewCustomer.jsp?CustomerID="+CustomerID+"&message=1");
    	else
    		response.sendRedirect("ViewCustomerBase.jsp?CustomerID="+CustomerID+"&message=1");
        return;
    }
    ApproveCustomerParameter.resetParameter();
    ApproveCustomerParameter.setWorkflowid(workflowid);
    ApproveCustomerParameter.setNodetype("0");
    ApproveCustomerParameter.setApproveid(Util.getIntValue(CustomerID,0));
    ApproveCustomerParameter.setApprovevalue(PortalStatus);
    ApproveCustomerParameter.setApprovetype("3");
    ApproveCustomerParameter.setRequestname(approvedesc);
    ApproveCustomerParameter.setManagerid(Util.getIntValue(Manager2,0));
    if(!isfromtab)
		 ApproveCustomerParameter.setGopage("/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+CustomerID);
	else
		 ApproveCustomerParameter.setGopage("/CRM/data/ViewCustomerBase.jsp?log=n&CustomerID="+CustomerID);
    //ApproveCustomerParameter.setBackpage(backpage);
    
    String redirectPage = "/workflow/request/BillApproveCustomerOperation.jsp?src=submit&iscreate=1&notneedsave=1";
    RecordSet.executeSql("select b.requestid from bill_ApproveCustomer a,workflow_requestbase b where a.requestid=b.requestid and b.currentnodetype='0' and a.approvetype=3 and a.approveid="+CustomerID);
    if(RecordSet.next()){
        String temprequestid = RecordSet.getString("requestid");
        redirectPage = "/workflow/request/BillApproveCustomerOperation.jsp?src=submit&iscreate=0&isfromcrm=1&requestid="+temprequestid;
    }
    response.sendRedirect(redirectPage);
    return;
}
if(method.equals("ApprovePwd"))
{
	CustomerID = Util.null2String(fu.getParameter("CustomerID"));

	RecordSet.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
	RecordSet.first();
	strTemp = RecordSet.getString("PortalStatus");
	String Manager2 = RecordSet.getString("manager");
	String name = RecordSet.getString("name");
	String operators = ResourceComInfo.getManagerID(Manager2);
	//ProcPara = CustomerID;
	//ProcPara += flag+PortalStatus;
    //
	//RecordSet.executeProc("CRM_CustomerInfo_Portal",ProcPara);
	if(PortalStatus.equals("1")){


		SWFAccepter=operators;
		SWFTitle=SystemEnv.getHtmlLabelName(15155,user.getLanguage());
		SWFTitle += name;
		SWFTitle += "-"+CurrentUserName;
		SWFTitle += "-"+CurrentDate;
		SWFRemark="";
		SWFSubmiter=CurrentUser;
		SysRemindWorkflow.setCRMSysRemind(SWFTitle,Util.getIntValue(CustomerID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);

	}
	else {

		SWFAccepter=operators;
		SWFTitle=SystemEnv.getHtmlLabelName(15156,user.getLanguage());
		SWFTitle += name;
		SWFTitle += "-"+CurrentUserName;
		SWFTitle += "-"+CurrentDate;
		SWFRemark="";
		SWFSubmiter=CurrentUser;
		SysRemindWorkflow.setCRMSysRemind(SWFTitle,Util.getIntValue(CustomerID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);

	}
	if(!isfromtab)
		 ApproveCustomerParameter.setGopage("/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+CustomerID);
	else
		 ApproveCustomerParameter.setGopage("/CRM/data/ViewCustomerBase.jsp?log=n&CustomerID="+CustomerID);
    //ApproveCustomerParameter.setBackpage(backpage);
    response.sendRedirect("/workflow/request/BillApproveCustomerOperation.jsp?src=submit&iscreate=0&isneedsave=notneedsave&requestid="+requestid+"&isfromcrm=1");

	return;
}

if(method.equals("RejectPwd"))
{
	if(!isfromtab)
		 ApproveCustomerParameter.setGopage("/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+CustomerID);
	else
		 ApproveCustomerParameter.setGopage("/CRM/data/ViewCustomerBase.jsp?log=n&CustomerID="+CustomerID);
    //ApproveCustomerParameter.setBackpage(backpage);
    response.sendRedirect("/workflow/request/BillApproveCustomerOperation.jsp?src=reject&iscreate=0&isneedsave=notneedsave&requestid="+requestid+"&isfromcrm=1");

	return;
}

if(method.equals("checkCusName")) {
	out.print("begin");
	String cusnametemp = Util.null2String(request.getParameter("name"));
	if(!"".equals(cusnametemp)){
		RecordSet.executeSql("SELECT id FROM CRM_CustomerInfo where name = '"+cusnametemp+"'");
		if(RecordSet.next()){
			out.write("1");
		}else{
			out.write("0");
		}
	}else{
		out.write("0");
	}
}
//2005-04-28 Modify by guosheng for TD1709 CRM缓存采用新方式的addCustomerInfoCache类型变了需要重新编译本jsp所有在这边加个没有任何功能上改动的版本以让resin 重新编译
%>