
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetT" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="CustomerModifyLog" class="weaver.crm.data.CustomerModifyLog" scope="page"/>
<%--客户审批参数存储类--%>
<jsp:useBean id="ApproveCustomerParameter" class="weaver.workflow.request.ApproveCustomerParameter" scope="session"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<%

FileUpload fu = new FileUpload(request);

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

String fieldName = "";		// added by lupeng for TD826

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
String PortalStatus=Util.fromScreen3(fu.getParameter("PortalStatus"),user.getLanguage());

CustomerID = Util.null2String(fu.getParameter("CustomerID"));

String TypeFrom=CurrentDate;

//部门由人力资源表中选出该经理的部门
String seclevel=Util.fromScreen3(fu.getParameter("seclevel"),user.getLanguage());

//System.out.println("method:"+method);

if(method.equals("add")){
	
	String CreditAmount=Util.fromScreen3(fu.getParameter("CreditAmount"),user.getLanguage());
	
	String fieldSql = "";
	String valueSql = "";
	String[] fieldNames ={"name","manager","status","website","email"};
	for(int i=0;i<fieldNames.length;i++){
		 fieldName= fieldNames[i];
		 String fieldValue = Util.null2String(fu.getParameter(fieldName));	
		
		 if(fieldName.equals("website") && !fieldValue.equals("")){
		 	if(fieldValue.indexOf(":")==-1){
		 		fieldValue="http://"+fieldValue.trim();
			}else{
				fieldValue=Util.StringReplace(fieldValue,"\\","/");
			}
		 }
		 
		 fieldSql += fieldName+",";
		 valueSql += "'"+fieldValue+"',";
	}
	
	fieldSql += "fincode,currency,contractlevel,creditlevel,creditoffset,"+
				"discount,invoiceacount,deliverytype,paymentterm,paymentway,"+
				"saleconfirm,typebegin,rating,createdate,province,Country,deleted,"+
				"department,subcompanyid1";
	valueSql += "0,0,0,0,0,"+
				"100,0,0,0,0,"+
				"0,'"+CurrentDate+"',0,'"+CurrentDate+"',0,0,0,"+
				"'"+ResourceComInfo.getDepartmentID(Util.null2String(fu.getParameter("manager")))+"','"+ResourceComInfo.getSubCompanyID(Util.null2String(fu.getParameter("manager")))+"'";
	String sql = "insert into CRM_CustomerInfo("+fieldSql+") values ("+valueSql+")";
	
	//System.out.println("sql:"+sql);
	
	RecordSet.execute(sql);
	
	RecordSet.execute("select max(id) from CRM_CustomerInfo where manager = "+fu.getParameter("manager")+" and createdate = '"+CurrentDate+"'");
	
	if (RecordSet.next()) {
		CustomerID = RecordSet.getString(1);
		
		//System.out.println("CustomerID:"+CustomerID);
		
		CustomerInfoComInfo.addCustomerInfoCache(CustomerID);

		//通知客户经理的经理
		String operators = ResourceComInfo.getManagerID(fu.getParameter("manager"));
    
	    //modify by xhheng @20050221 for TD 1373
	    if(operators!=null && !operators.equals("0")){
			SWFAccepter=operators;
			SWFTitle=SystemEnv.getHtmlLabelName(15006,user.getLanguage());
			SWFTitle += Util.fromScreen3(fu.getParameter("Name"),user.getLanguage());
			SWFTitle += "-"+CurrentUserName;
			SWFTitle += "-"+CurrentDate;
			SWFRemark="";
			SWFSubmiter=CurrentUser;
			SysRemindWorkflow.setCRMSysRemind(SWFTitle,Util.getIntValue(CustomerID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
			
			//系统触发流程会给客户经理的经理一个对该客户的查看权限，与下面的CrmShareBase.setDefaultShare(""+CustomerID);重复。
			RecordSet.executeSql("delete from CRM_shareinfo where relateditemid="+CustomerID);
	    }
		
	    String Manager=Util.null2String(fu.getParameter("manager"),user.getUID()+"");
        CustomerModifyLog.modify(CustomerID,user.getUID()+"",Manager);

		
		//在新的方式下添加客户默认共享，新建客户默认共享给客户经理及所有上级，客户管理员角色。
		CrmShareBase.setDefaultShare(""+CustomerID);
	    
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

	}
	
	out.println(CustomerID);
	return;
}else if(method.equals("addContacter")){
	
	String  FirstName=fu.getParameter("FirstName");
	String  Title=fu.getParameter("Title");
	String  JobTitle=fu.getParameter("JobTitle");
	String  PhoneOffice=fu.getParameter("PhoneOffice");
	String  mobilephone=fu.getParameter("mobilephone");
	String  email=fu.getParameter("email");
	
	//System.out.println("FirstNames:"+FirstName);
	
		String fieldSql = "";
		String valueSql = "";
			
		fieldSql +="FirstName,";
		valueSql += "'"+FirstName+"',";
		
		fieldSql +="Title,";
		valueSql += "'"+Title+"',";
		
		fieldSql +="JobTitle,";
		valueSql += "'"+JobTitle+"',";
		
		fieldSql +="PhoneOffice,";
		valueSql += "'"+PhoneOffice+"',";
		
		fieldSql +="mobilephone,";
		valueSql += "'"+mobilephone+"',";
		
		fieldSql +="email,";
		valueSql += "'"+email+"',";
		
		fieldSql += "customerid,LANGUAGE,manager,main,picid";
		valueSql += CustomerID+","+Util.getIntValue(fu.getParameter("language"),7)+","+fu.getParameter("manager")+",1,0";
		String sql = "insert into CRM_CustomerContacter("+fieldSql+") values ("+valueSql+")";
		RecordSet.execute(sql);
		//System.out.println("sql-2:"+sql);
}

%>
