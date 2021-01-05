
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetT" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SendMail" class="weaver.crm.Maint.SendMail" scope="page" />
<jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="CrmViewer" class="weaver.crm.CrmViewer" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="ContractViewer" class="weaver.crm.ContractViewer" scope="page"/>
<jsp:useBean id="CustomerModifyLog" class="weaver.crm.data.CustomerModifyLog" scope="page"/>
<%--客户审批参数存储类--%>
<jsp:useBean id="ApproveCustomerParameter" class="weaver.workflow.request.ApproveCustomerParameter" scope="session"/>


<%
char flag = 2;
String ProcPara = "";
String strTemp = "";
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

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);
String method = Util.null2String(request.getParameter("method"));

String approvedesc = Util.null2String(request.getParameter("approvedesc")); //客户审批描述
String requestid = Util.null2String(request.getParameter("requestid")); //客户审批描述

String Remark=Util.fromScreen3(request.getParameter("Remark"),user.getLanguage());
String RemarkDoc=Util.fromScreen3(request.getParameter("RemarkDoc"),user.getLanguage());
String Status=Util.fromScreen3(request.getParameter("Status"),user.getLanguage());
String Rating=Util.fromScreen3(request.getParameter("Rating"),user.getLanguage());
String PortalStatus=Util.fromScreen3(request.getParameter("PortalStatus"),user.getLanguage());

String CustomerStatus=Util.null2String(request.getParameter("CustomerStatus"));//客户状态



if(method.equals("delete"))// 私人用户和企业用户共用该方法
{
	CustomerID = Util.null2String(request.getParameter("CustomerID"));
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

String Name=Util.fromScreen3(request.getParameter("Name"),user.getLanguage());
String crmCode = Util.fromScreen3(request.getParameter("crmcode"),user.getLanguage());
String Abbrev=Util.fromScreen3(request.getParameter("Abbrev"),user.getLanguage());
String Address1=Util.fromScreen3(request.getParameter("Address1"),user.getLanguage());
String Address2=Util.fromScreen3(request.getParameter("Address2"),user.getLanguage());
String Address3=Util.fromScreen3(request.getParameter("Address3"),user.getLanguage());
String Zipcode=Util.fromScreen3(request.getParameter("Zipcode"),user.getLanguage());
String City=Util.fromScreen3(request.getParameter("City"),user.getLanguage());
String Country=Util.fromScreen3(request.getParameter("Country"),user.getLanguage());
//String Province=Util.fromScreen3(request.getParameter("Province"),user.getLanguage());
String Province= CityComInfo.getCityprovinceid(City);
String county=Util.fromScreen3(request.getParameter("County"),user.getLanguage());
String Language=Util.fromScreen3(request.getParameter("Language"),user.getLanguage());
String Phone=Util.fromScreen3(request.getParameter("Phone"),user.getLanguage());
String Fax=Util.fromScreen3(request.getParameter("Fax"),user.getLanguage());
String Email=Util.fromScreen3(request.getParameter("Email"),user.getLanguage());
String Website=Util.fromScreen3(request.getParameter("Website"),user.getLanguage());
String bankName=Util.fromScreen3(request.getParameter("bankname"),user.getLanguage());
String accountName = Util.fromScreen3(request.getParameter("accountname"),user.getLanguage());
String accounts=Util.fromScreen3(request.getParameter("accounts"),user.getLanguage());


// added by lupeng 2004-8-9 for TD826.
if (Province.equals(""))
	Province = "0";
// end.

if(Website.indexOf(":")==-1){
   Website="http://"+Website.trim();
}else{
   Website=Util.StringReplace(Website,"\\","/");
}

String Type=Util.null2String(request.getParameter("Type")); //客户类型
String TypeFrom=CurrentDate;
String Description=Util.fromScreen3(request.getParameter("Description"),user.getLanguage());
String Size=Util.fromScreen3(request.getParameter("Size"),user.getLanguage());
String Source=Util.fromScreen3(request.getParameter("Source"),user.getLanguage());
String Sector=Util.fromScreen3(request.getParameter("Sector"),user.getLanguage());
String Manager=Util.fromScreen3(request.getParameter("Manager"),user.getLanguage());
String sector = Util.fromScreen3(request.getParameter("Sector"),user.getLanguage());
//部门由人力资源表中选出该经理的部门
//String Department=Util.fromScreen3(request.getParameter("Department"),user.getLanguage());
String Department= ResourceComInfo.getDepartmentID(Manager);
String Subcompanyid1=DepartmentComInfo.getSubcompanyid1(Department);
String Agent=Util.fromScreen3(request.getParameter("Agent"),user.getLanguage());
String Parent=Util.fromScreen3(request.getParameter("Parent"),user.getLanguage());
String Document=Util.fromScreen3(request.getParameter("Document"),user.getLanguage());
String seclevel=Util.fromScreen3(request.getParameter("seclevel"),user.getLanguage());
String Photo=Util.fromScreen3(request.getParameter("Photo"),user.getLanguage());
String introductionDocid=Util.fromScreen3(request.getParameter("introductionDocid"),user.getLanguage());
String CreditAmount=Util.fromScreen3(request.getParameter("CreditAmount"),user.getLanguage());
String CreditTime=Util.fromScreen3(request.getParameter("CreditTime"),user.getLanguage());

String creditLevel = "0";
RecordSet.executeProc("Sales_CRM_CreditInfo_Select" , CreditAmount+"");
if (RecordSet.next())
	creditLevel = RecordSet.getString(1);

if(introductionDocid.equals("")) introductionDocid = "0";
if(Photo.equals("")) Photo = "0";

String dff01=Util.null2String(request.getParameter("dff01"));
String dff02=Util.null2String(request.getParameter("dff02"));
String dff03=Util.null2String(request.getParameter("dff03"));
String dff04=Util.null2String(request.getParameter("dff04"));
String dff05=Util.null2String(request.getParameter("dff05"));

boolean isOracle = (RecordSet.getDBType()).equals("oracle");

String nff01=Util.null2String(request.getParameter("nff01"));
if(nff01.equals(""))
	if (isOracle)
		nff01="0";
	else
		nff01="0.0";

String nff02=Util.null2String(request.getParameter("nff02"));
if(nff02.equals(""))
	if (isOracle)
		nff02="0";
	else
		nff02="0.0";

String nff03=Util.null2String(request.getParameter("nff03"));
if(nff03.equals(""))
	if (isOracle)
		nff03="0";
	else
		nff03="0.0";

String nff04=Util.null2String(request.getParameter("nff04"));
if(nff04.equals(""))
	if (isOracle)
		nff04="0";
	else
		nff04="0.0";

String nff05=Util.null2String(request.getParameter("nff05"));
if(nff05.equals(""))
	if (isOracle)
		nff05="0";
	else
		nff05="0.0";

String tff01=Util.fromScreen3(request.getParameter("tff01"),user.getLanguage());
String tff02=Util.fromScreen3(request.getParameter("tff02"),user.getLanguage());
String tff03=Util.fromScreen3(request.getParameter("tff03"),user.getLanguage());
String tff04=Util.fromScreen3(request.getParameter("tff04"),user.getLanguage());
String tff05=Util.fromScreen3(request.getParameter("tff05"),user.getLanguage());

String bff01=Util.null2String(request.getParameter("bff01"));
if(bff01.equals("")) bff01="0";
String bff02=Util.null2String(request.getParameter("bff02"));
if(bff02.equals("")) bff02="0";
String bff03=Util.null2String(request.getParameter("bff03"));
if(bff03.equals("")) bff03="0";
String bff04=Util.null2String(request.getParameter("bff04"));
if(bff04.equals("")) bff04="0";
String bff05=Util.null2String(request.getParameter("bff05"));
if(bff05.equals("")) bff05="0";

String Fincode=Util.fromScreen3(request.getParameter("Fincode"),user.getLanguage());
String Currency=Util.fromScreen3(request.getParameter("Currency"),user.getLanguage());
String ContractLevel=Util.fromScreen3(request.getParameter("ContractLevel"),user.getLanguage());
String CreditLevel=Util.fromScreen3(request.getParameter("CreditLevel"),user.getLanguage());
String CreditOffset=Util.fromScreen3(request.getParameter("CreditOffset"),user.getLanguage());
if(CreditOffset.equals("")) CreditOffset="0";
String Discount=Util.fromScreen3(request.getParameter("Discount"),user.getLanguage());
if(Discount.equals("")) Discount="100";
String TaxNumber=Util.fromScreen3(request.getParameter("TaxNumber"),user.getLanguage());
String BankAccount=Util.fromScreen3(request.getParameter("BankAccount"),user.getLanguage());
String InvoiceAcount=Util.fromScreen3(request.getParameter("InvoiceAcount"),user.getLanguage());
String DeliveryType=Util.fromScreen3(request.getParameter("DeliveryType"),user.getLanguage());
String PaymentTerm=Util.fromScreen3(request.getParameter("PaymentTerm"),user.getLanguage());
String PaymentWay=Util.fromScreen3(request.getParameter("PaymentWay"),user.getLanguage());
String SaleConfirm=Util.fromScreen3(request.getParameter("SaleConfirm"),user.getLanguage());
String Credit=Util.fromScreen3(request.getParameter("Credit"),user.getLanguage());
String CreditExpire=Util.fromScreen3(request.getParameter("CreditExpire"),user.getLanguage());

CustomerID = Util.null2String(request.getParameter("CustomerID"));
if(!CustomerID.equals("")){
RecordSet.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
RecordSet.first();
}


/*Added By Charoes Huang On June 21,2004,个人客户的增加*/
if("addPer".equals(method)){
  // 一般信息
	//String PortalLoginID1 = Util.null2String(request.getParameter("PortalLoginID"));
	//String PortalPassword1 = Util.null2String(request.getParameter("PortalPassword"));
	String Email1 = Util.null2String(request.getParameter("Email"));
	String Name1 = Util.null2String(request.getParameter("Name"));
	String Sex1 = Util.null2String(request.getParameter("Sex"));
	String IDCardNo1 = Util.null2String(request.getParameter("IDCardNo"));
	String City1 = Util.null2String(request.getParameter("City"));
	String Phone1 = Util.null2String(request.getParameter("Phone"));
	String Address11 = Util.null2String(request.getParameter("Address1"));
	// 分类信息
	String Type1 = Util.null2String(request.getParameter("Type"));
	String Manager1 = Util.null2String(request.getParameter("Manager"));
	String secLevel1 = Util.null2String(request.getParameter("seclevel"));
	
	String source1 = Util.null2String(request.getParameter("Source"));//added by xwj for td1552 on 2005-03-22


	//String PortalStatus1 = "2";
	if("".equals(Sex1)){
		Sex1 = "0";
	}
	if("".equals(City1)){
		City1= "0";
	}

  String sqlStr="";
	
	
	/*检测 相同 登录名
	sqlStr = "Select COUNT(*) FROM CRM_CustomerInfo WHERE Type="+Type1+" and PortalLoginID='"+PortalLoginID1+"'";
	RecordSet.executeSql(sqlStr);
	if(RecordSet.next()){
		if(RecordSet.getInt(1) > 0){
			out.println("<font color=\"red\">登录名"+PortalLoginID1+"重复</font>，");
			out.println("点击<a href=\"javascript:history.back()\">返回</a>重新填写！");
			return;
		}
	}
	*/
	/*检测相同电子邮件
	sqlStr = "Select COUNT(*) FROM CRM_CustomerInfo WHERE Type="+Type1+" and Email='"+Email1+"'";
	RecordSet.executeSql(sqlStr);
	if(RecordSet.next()){
		if(RecordSet.getInt(1) > 0){
			out.println("<font color=\"red\">电子邮件"+Email1+"重复</font>，");
			out.println("点击<a href=\"javascript:history.back()\">返回</a>重新填写！");
			return;
		}
	}
  */
  
  /*插入新记录 Modified by xwj for td1552 on 2005-03-22*/
	if(Subcompanyid1 == null || "".equals(Subcompanyid1)){
	    Subcompanyid1 = "0"; //客户经理为默认的系统管理员时, Subcompanyid1为空, 数据库插入 '0'
	}
	if(source1 == null || "".equals(source1)){
	    source1 = "0";
	}
	if(CreditAmount == null || "".equals(CreditAmount)){
	    CreditAmount = "0";
	}
		if(CreditTime == null || "".equals(CreditTime)){
	    CreditTime = "0";
	}
	
	if(City1 == null || "".equals(City1)){
	    City1 = "0";
	}
		if(Description == null || "".equals(Description)){
	    Description = "0";
	}
		if(source1 == null || "".equals(source1)){
	    source1 = "0";
	}
			if(CreditAmount == null || "".equals(CreditAmount)){
	    CreditAmount = "0";
	}
		if(CreditTime == null || "".equals(CreditTime)){
	    CreditTime = "0";
	}
			if(Type1 == null || "".equals(Type1)){
	    Type1 = "0";
	}
			if(Manager1 == null || "".equals(Manager1)){
	    Manager1 = "1";
	}
			if(secLevel1 == null || "".equals(secLevel1)){
	    secLevel1 = "0";
	}

	if(sector == null || "".equals(sector)){
	    sector = "0";
	}
		if(Department == null || "".equals(Department)){
	    Department = "-1";
	}
	
		if(Language == null || "".equals(Language)){
			Language = "7";
	}
	
	//sqlStr ="INSERT INTO CRM_CustomerINFO (description,status,rating,Email,Name,Sex,IDCardNo,City,Phone,Address1,Type,Manager,secLevel,Deleted,Department,Subcompanyid1,source) VALUES ("+Description+",1,0,'"+Email1+"','"+Name1+"',"+Sex1+",'"+IDCardNo1+"',"+City1+",'"+Phone1+"','"+Address11+"',"+Type1+","+Manager1+","+secLevel1+",0,"+Department+","+Subcompanyid1+","+source1+")";
   sqlStr ="INSERT INTO CRM_CustomerINFO (sector,datefield1, datefield2, datefield3, datefield4, datefield5,numberfield1, numberfield2, numberfield3, numberfield4, numberfield5,textfield1, textfield2, textfield3, textfield4, textfield5,tinyintfield1, tinyintfield2, tinyintfield3, tinyintfield4, tinyintfield5,crmCode,createdate,CreditAmount,CreditTime,bankName,accountName,accounts,description,status,rating,Email,Name,Sex,IDCardNo,City,Phone,Address1,Type,Manager,secLevel,Deleted,Department,Subcompanyid1,source,language,agent) VALUES ("+sector+",'"+dff01+"','"+dff02+"','"+dff03+"','"+dff04+"','"+dff05+"',"+nff01+","+nff02+","+nff03+","+nff04+","+nff05+",'"+tff01+"','"+tff02+"','"+tff03+"','"+tff04+"','"+tff05+"',"+bff01+","+bff02+","+bff03+","+bff04+","+bff05+",'"+crmCode+"','"+CurrentDate+"',"+CreditAmount+","+CreditTime+",'"+bankName+"','"+accountName+"','"+accounts+"',"+Description+",'"+CustomerStatus+"',0,'"+Email1+"','"+Name1+"',"+Sex1+",'"+IDCardNo1+"',"+City1+",'"+Phone1+"','"+Address11+"',"+Type1+","+Manager1+","+secLevel1+",0,"+Department+","+Subcompanyid1+","+source1+","+Language+","+Agent+")";
  	
  
	boolean insertSuccess = false ;


	insertSuccess = RecordSet.executeSql(sqlStr);


	if (insertSuccess) {
		RecordSet.executeProc("CRM_CustomerInfo_InsertID","");
		RecordSet.first();
		CustomerID = RecordSet.getString(1);
		
		
		CustomerInfoComInfo.addCustomerInfoCache(CustomerID);
		
		/*-- added by xwj for td1552 on 2005-03-22 begin ---*/
		String operators = ResourceComInfo.getManagerID(Manager1);
		
		
    if(operators!=null && !operators.equals("0")){
			SWFAccepter=operators;
			SWFTitle=SystemEnv.getHtmlLabelName(15006,user.getLanguage());
			SWFTitle += Name1;
			SWFTitle += "-"+CurrentUserName;
			SWFTitle += "-"+CurrentDate;
			SWFRemark="";
			SWFSubmiter=CurrentUser;
			SysRemindWorkflow.setCRMSysRemind(SWFTitle,Util.getIntValue(CustomerID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
      //RecordSet.executeProc("CRM_ShareEditToManager", CustomerID + flag + operators);
			//系统触发流程会给客户经理的经理一个对该客户的查看权限，与下面的CrmShareBase.setDefaultShare(""+CustomerID);重复。
			RecordSet.executeSql("delete from CRM_shareinfo where relateditemid="+CustomerID); 
    }
    /*-- added by xwj for td1552 on 2005-03-22 end ---*/

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

    
    
    String Title=Util.fromScreen3(request.getParameter("Title"),user.getLanguage());
		String LastName=Util.fromScreen3(request.getParameter("LastName"),user.getLanguage());
		String FirstName=Util.fromScreen3(request.getParameter("FirstName"),user.getLanguage());
		String JobTitle=Util.fromScreen3(request.getParameter("JobTitle"),user.getLanguage());
		String CEmail=Util.fromScreen3(request.getParameter("CEmail"),user.getLanguage());
		String PhoneOffice=Util.fromScreen3(request.getParameter("PhoneOffice"),user.getLanguage());
		String PhoneHome=Util.fromScreen3(request.getParameter("PhoneHome"),user.getLanguage());
		String Mobile=Util.fromScreen3(request.getParameter("Mobile"),user.getLanguage());

		String interest=Util.fromScreen3(request.getParameter("interest"),user.getLanguage());
		String hobby=Util.fromScreen3(request.getParameter("hobby"),user.getLanguage());
		String managerstr=Util.fromScreen3(request.getParameter("managerstr"),user.getLanguage());
		String subordinate=Util.fromScreen3(request.getParameter("subordinate"),user.getLanguage());
		String strongsuit=Util.fromScreen3(request.getParameter("strongsuit"),user.getLanguage());
		String age=Util.fromScreen3(request.getParameter("age"),user.getLanguage());
		String birthday=Util.fromScreen3(request.getParameter("birthday"),user.getLanguage());
		String home=Util.fromScreen3(request.getParameter("home"),user.getLanguage());
		String school=Util.fromScreen3(request.getParameter("school"),user.getLanguage());
		String speciality=Util.fromScreen3(request.getParameter("speciality"),user.getLanguage());
		String nativeplace=Util.fromScreen3(request.getParameter("nativeplace"),user.getLanguage());
		String experience=Util.fromScreen3(request.getParameter("experience"),user.getLanguage());
    
		
		ProcPara = CustomerID;
		ProcPara += flag+Title;
		ProcPara += flag+Name1;//直接将个人客户卡片上得到的 "姓名" 存放到联系人表中去  xwj for td1552 on 2005-04-16
		ProcPara += flag+LastName;
		ProcPara += flag+Name1;//直接将个人客户卡片上得到的 "姓名" 存放到联系人表中去  xwj for td1552 on 2005-04-16
		ProcPara += flag+JobTitle;
		ProcPara += flag+CEmail;
		ProcPara += flag+PhoneOffice;//直接将个人客户卡片上得到的 "电话" 存放到联系人表中去  xwj for td1552 on 2005-04-16
		ProcPara += flag+PhoneHome;
		ProcPara += flag+Mobile;
		ProcPara += flag+"";
		ProcPara += flag+Language;
		ProcPara += flag+Manager1;
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

		ProcPara += flag+"";
		ProcPara += flag+"";
		ProcPara += flag+"";
		RecordSet.executeProc("CRM_CustomerContacter_Insert",ProcPara);//联系人部分

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
		
		
		/*修改共享，插入日志信息*/
		//RecordSet.executeProc("CRM_ShareInfo_Update",Type1+flag+CustomerID);
		//CRM_ShareInfo
        CustomerModifyLog.modify(CustomerID,user.getUID()+"",Manager1);

		//CrmViewer.setCrmShareByCrm(""+CustomerID);
		CrmShareBase.setDefaultShare(""+CustomerID);
	}
	response.sendRedirect("/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+CustomerID);
	return;
}

if("editPer".equals(method)){

	CustomerID = Util.null2String(request.getParameter("CustomerID"));
	//String PortalLoginID1 = Util.null2String(request.getParameter("PortalLoginID"));
	//String PortalPassword1 = Util.null2String(request.getParameter("PortalPassword"));
	String Email1 = Util.null2String(request.getParameter("Email"));
	String Name1 = Util.null2String(request.getParameter("Name"));
	String Sex1 = Util.null2String(request.getParameter("Sex"));
	String IDCardNo1 = Util.null2String(request.getParameter("IDCardNo"));
	String City1 = Util.null2String(request.getParameter("City"));
	String Phone1 = Util.null2String(request.getParameter("Phone"));
	String Address11 = Util.null2String(request.getParameter("Address1"));
	
	String Type1 = Util.null2String(request.getParameter("Type"));
	String Manager1 = Util.null2String(request.getParameter("Manager"));
	String secLevel1 = Util.null2String(request.getParameter("seclevel"));
	
	String Source1 = Util.null2String(request.getParameter("Source"));//added by xwj for td1552 on 2005-03-22
	String Status1=Util.fromScreen3(request.getParameter("Status"),user.getLanguage());//added by xwj for td1552 on 2005-03-22
  String Rating1=Util.fromScreen3(request.getParameter("Rating"),user.getLanguage());//added by xwj for td1552 on 2005-03-22

	String PortalStatus1 = "2";
	if("".equals(Sex1)){
		Sex1 = "0";
	}
	if("".equals(City1)){
		City1= "0";
	}

	String sqlStr="";
	
	/*检测 相同 登录名
	sqlStr = "Select COUNT(*) FROM CRM_CustomerInfo WHERE Type="+Type1+" and PortalLoginID='"+PortalLoginID1+"' and id<>"+CustomerID;
	RecordSet.executeSql(sqlStr);
	if(RecordSet.next()){
		if(RecordSet.getInt(1) > 0){
			out.println("<font color=\"red\">登录名"+PortalLoginID1+"重复</font>，");
			out.println("点击<a href=\"javascript:history.back()\">返回</a>重新填写！");
			return;
		}
	}
	/*检测相同电子邮件
	sqlStr = "Select COUNT(*) FROM CRM_CustomerInfo WHERE Type="+Type1+" and Email='"+Email1+"' and ID<>"+CustomerID;
	RecordSet.executeSql(sqlStr);
	if(RecordSet.next()){
		if(RecordSet.getInt(1) > 0){
			out.println("<font color=\"red\">电子邮件"+Email1+"重复</font>，");
			out.println("点击<a href=\"javascript:history.back()\">返回</a>重新填写！");
			return;
		}
	}
	*/
	
	/* added by xwj for td1552 on 2005-03-22 begin*/
	
	CustomerModifyLog.modify2(CustomerID,Manager1);//记录客户经理修改信息（完成新客户显示的功能）
	
	boolean bNeedUpdate = false;
	boolean bShareUpdate = false;
	String fieldName = "";
	RecordSet.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
  RecordSet.first();
	strTemp = RecordSet.getString("name");
	if(!Name1.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(195,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Name1;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}
	strTemp = RecordSet.getString("address1");
	if(!Address11.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(110,user.getLanguage()) + "1";
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Address11;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}
	
	strTemp = RecordSet.getString("city");
	if(!City1.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(493,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+City1;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	
	strTemp = RecordSet.getString("phone");
	if(!Phone1.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(421,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Phone1;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}
	
	strTemp = RecordSet.getString("email");
	if(!Email1.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(477,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Email1;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}
	
	strTemp = RecordSet.getString("type");
	if(!Type1.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(63,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Type1;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);

		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+RecordSet.getString("typebegin")+flag+CurrentDate;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}
	strTemp = RecordSet.getString("status");
	if(!Status1.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(602,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Status1;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("rating");
	if(!strTemp.equals("") && !strTemp.equals("0") && !Rating1.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(139,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Rating1;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	
		String operators = ResourceComInfo.getManagerID(Manager1);
		SWFAccepter=operators;
		SWFTitle=SystemEnv.getHtmlLabelName(15158,user.getLanguage());
		SWFTitle += Name1;
		SWFTitle += "-"+CurrentUserName;
		SWFTitle += "-"+CurrentDate;
		SWFRemark="";
		SWFSubmiter=CurrentUser;
		SysRemindWorkflow.setCRMSysRemind(SWFTitle,Util.getIntValue(CustomerID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);

	}
	
	strTemp = RecordSet.getString("source");
	if(!Source1.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(645,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Source1;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}
	
	strTemp = RecordSet.getString("manager");
	if(!Manager1.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(144,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Manager1;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
		bShareUpdate = true;
		
		String operators = Manager1;
		SWFAccepter=operators;
		SWFTitle=SystemEnv.getHtmlLabelName(15159,user.getLanguage());
		SWFTitle += Name1;
		SWFTitle += "-"+CurrentUserName;
		SWFTitle += "-"+CurrentDate;
		SWFRemark="";
		SWFSubmiter=CurrentUser;
		SysRemindWorkflow.setCRMSysRemind(SWFTitle,Util.getIntValue(CustomerID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);

	}
	
	strTemp = RecordSet.getString("seclevel");
	if(!secLevel1.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(683,user.getLanguage());
		ProcPara = CustomerID+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+secLevel1;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
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
	/* added by xwj for td1552 on 2005-03-22 end*/
	
 /*更新记录*/ //Modified by xwj for tyd1552 on 2005-03-22
 	if(Subcompanyid1 == null || "".equals(Subcompanyid1)){
	    Subcompanyid1 = "0"; //客户经理为默认的系统管理员时, Subcompanyid1为空, 数据库插入 '0'
	}
		if(CreditAmount == null || "".equals(CreditAmount)){
	    CreditAmount = "0";
	}
		if(CreditTime == null || "".equals(CreditTime)){
	    CreditTime = "0";
	}

  if(City1 == null || "".equals(City1)){
	    City1 = "0";
	}
		if(Description == null || "".equals(Description)){
	    Description = "0";
	}
		if(Source1 == null || "".equals(Source1)){
	    Source1 = "0";
	}
		if(CreditAmount == null || "".equals(CreditAmount)){
	    CreditAmount = "0";
	}
		if(CreditTime == null || "".equals(CreditTime)){
	    CreditTime = "0";
	}
				if(Type1 == null || "".equals(Type1)){
	    Type1 = "0";
	}
			if(Manager1 == null || "".equals(Manager1)){
	    Manager1 = "0";
	}
			if(secLevel1 == null || "".equals(secLevel1)){
	    secLevel1 = "0";
	}
	
	if(sector == null || "".equals(sector)){
	    sector = "0";
	}
			if(Department == null || "".equals(Department)){
	    Department = "-1";
	}
	sqlStr = "update CRM_CustomerInfo Set Email='"+Email1+"',"+
										  "Name='"+Name1+"',"+
										  "Sex='"+Sex1+"',"+
										  "IDCardNo='"+IDCardNo1+"',"+
										  "City="+City1+","+
										  "Phone='"+Phone1+"',"+
										  "Address1='"+Address11+"',"+
										  "Type='"+Type1+"',"+
										  "Manager='"+Manager1+"',"+
										  "seclevel='"+secLevel1+"', "+
										  "Department="+Department+","+
										  "Subcompanyid1='"+Subcompanyid1+"', "+
										  "rating='"+Rating1+"', "+
										  "source="+Source1+", "+ 
										  "sector="+sector+", "+ 
										  "Description="+Description+", "+ 
										  "datefield1='"+dff01+"', "+
										  "datefield2='"+dff02+"', "+
										  "datefield3='"+dff03+"', "+
										  "datefield4='"+dff04+"', "+
										  "datefield5='"+dff05+"', "+
										  "numberfield1="+nff01+", "+
										  "numberfield2="+nff02+", "+
										  "numberfield3="+nff03+", "+
										  "numberfield4="+nff04+", "+
										  "numberfield5="+nff05+", "+
										  "textfield1='"+tff01+"', "+
										  "textfield2='"+tff02+"', "+
										  "textfield3='"+tff03+"', "+
										  "textfield4='"+tff04+"', "+
										  "textfield5='"+tff05+"', "+
										  "tinyintfield1="+bff01+", "+
										  "tinyintfield2="+bff02+", "+
										  "tinyintfield3="+bff03+", "+
										  "tinyintfield4="+bff04+", "+
										  "tinyintfield5="+bff05+", "+
										  "bankName='"+bankName+"', "+
										  "accountName='"+accountName+"', "+
										  "accounts='"+accounts+"', "+
										  "CreditAmount="+CreditAmount+", "+
										  "CreditTime="+CreditTime+
										  " WHERE ID="+CustomerID ;

	    boolean updateSuccess = false ;
		updateSuccess =	RecordSet.executeSql(sqlStr);
		if (updateSuccess) {
			CustomerInfoComInfo.updateCustomerInfoCache(CustomerID);
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

    if(bShareUpdate)//added by xwj fr td1552 on 2005-03-22
	{
		//CrmViewer.setCrmShareByCrm(""+CustomerID);
		CrmShareBase.setDefaultShare(""+CustomerID);
		ContractViewer.setContractShareByCrmId(""+CustomerID);/*2003-11-07杨国生 客户全同*/
  }
	response.sendRedirect("/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+CustomerID);
	return;
}
%>

