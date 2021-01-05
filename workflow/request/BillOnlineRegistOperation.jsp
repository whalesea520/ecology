<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetT" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmViewer" class="weaver.crm.CrmViewer" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SendMail" class="weaver.general.SendMail" scope="page" />
<jsp:useBean id="SystemComInfo" class="weaver.system.SystemComInfo" scope="page" />
<%
int userid = 0;
int language = 7;
String logintype = "2";
String userName = "" ;

userid = user.getUID();
logintype = user.getLogintype();
language = user.getLanguage() ;
userName =  user.getUsername() ;

String src = Util.null2String(request.getParameter("src"));
String iscreate = Util.null2String(request.getParameter("iscreate"));
int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
int workflowid = Util.getIntValue(request.getParameter("workflowid"),-1);
String workflowtype = Util.null2String(request.getParameter("workflowtype"));
int isremark = Util.getIntValue(request.getParameter("isremark"),-1);
int formid = Util.getIntValue(request.getParameter("formid"),-1);
int isbill = Util.getIntValue(request.getParameter("isbill"),-1);
int billid = Util.getIntValue(request.getParameter("billid"),-1);
int nodeid = Util.getIntValue(request.getParameter("nodeid"),-1);
String nodetype = Util.null2String(request.getParameter("nodetype"));
String requestname = Util.fromScreen(request.getParameter("requestname"),language);
String requestlevel = Util.fromScreen(request.getParameter("requestlevel"),language);
String messageType =  Util.fromScreen(request.getParameter("messageType"),user.getLanguage());
String remark = Util.null2String(request.getParameter("remark"));

if( src.equals("") || workflowid == -1 || formid == -1 || isbill == -1 || nodeid == -1 || nodetype.equals("") ) {
    //response.sendRedirect("/notice/RequestError.jsp");
    out.print("<script>wfforward('/notice/RequestError.jsp');</script>");
    return ;
}



RequestManager.setSrc(src) ;
RequestManager.setIscreate(iscreate) ;
RequestManager.setRequestid(requestid) ;
RequestManager.setWorkflowid(workflowid) ;
RequestManager.setWorkflowtype(workflowtype) ;
RequestManager.setIsremark(isremark) ;
RequestManager.setFormid(formid) ;
RequestManager.setIsbill(isbill) ;
RequestManager.setBillid(billid) ;
RequestManager.setNodeid(nodeid) ;
RequestManager.setNodetype(nodetype) ;
RequestManager.setRequestname(requestname) ;
RequestManager.setRequestlevel(requestlevel) ;
RequestManager.setRemark(remark) ;
RequestManager.setRequest(request) ;
RequestManager.setUser(user) ;
//add by xhheng @ 2005/01/24 for 消息提醒 Request06
RequestManager.setMessageType(messageType) ;

boolean savestatus = RequestManager.saveRequestInfo() ;
requestid = RequestManager.getRequestid() ;
if( !savestatus ) {
    if( requestid != 0 ) {
        //response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1");
        out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1');</script>");
        return ;
    }
    else {
        //response.sendRedirect("/workflow/request/RequestView.jsp?message=1");
        out.print("<script>wfforward('/workflow/request/RequestView.jsp?message=1');</script>");
        return ;
    }
}

boolean flowstatus = RequestManager.flowNextNode() ;
if( !flowstatus ) {
	//response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2");
	out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2');</script>");
	return ;
}

boolean logstatus = RequestManager.saveRequestLog() ;


if( RequestManager.getNextNodetype().equals("3") ) {


	char flag = 2;
	String ProcPara = "";
	String strTemp = "";
	String CurrentUser = ""+userid;
	String CurrentUserName = ""+userName;

	String SubmiterType = ""+logintype;
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
	String sqlTemp = "select * from bill_onlineRegist where id = " + billid ;
	rs.executeSql(sqlTemp) ;
	if (rs.next()) {

		String journal = Util.null2String(rs.getString("journal"));
		String password=Util.null2String(rs.getString("password"));
		String Remark="";
		String RemarkDoc="";
		String Name=Util.null2String(rs.getString("Name"));
		String Abbrev=Util.null2String(rs.getString("engname"));
		String Address1=Util.null2String(rs.getString("address1"));
		String Address2="";
		String Address3="";
		String Zipcode="";
		String City=Util.null2String(rs.getString("city"));
		String Country= CityComInfo.getCitycountryid(City);
		//String Province=Util.fromScreen(request.getParameter("Province"),language);
		String Province= CityComInfo.getCityprovinceid(City);
		String county="";
		String Language=""+language;
		String Phone=Util.null2String(rs.getString("phone"));
		String Fax="";
		String Email=Util.null2String(rs.getString("email"));
		String Website=Util.null2String(rs.getString("website"));
		if(Website.indexOf(":")==-1){
		   Website="http://"+Website.trim();
		}else{
		   Website=Util.StringReplace(Website,"\\","/");
		}

		String Type=Util.null2String(rs.getString("type_n")); //客户类型
		String TypeFrom=CurrentDate;
		String Description=Util.null2String(rs.getString("description"));
		String Size=Util.null2String(rs.getString("size_n"));
		String Source="1";
		String Sector=Util.null2String(rs.getString("sector"));
		String Manager=Util.null2String(rs.getString("crmmanager"));;
		//部门由人力资源表中选出该经理的部门
		//String Department=Util.fromScreen(request.getParameter("Department"),language);
		String Department= ResourceComInfo.getDepartmentID(Manager);
		String Subcompanyid1=DepartmentComInfo.getSubcompanyid1(Department);
		String Agent="";
		String Parent="";
		String Document="";
		String seclevel="0";
		String Photo="";
		String introductionDocid="";
		String CreditAmount="1000000.00";
		String CreditTime="30";

		if(introductionDocid.equals("")) introductionDocid = "0";
		if(Photo.equals("")) Photo = "0";

		String dff01="";
		String dff02="";
		String dff03="";
		String dff04="";
		String dff05="";

		String nff01="";
		if(nff01.equals("")) nff01="0.0";
		String nff02="";
		if(nff02.equals("")) nff02="0.0";
		String nff03="";
		if(nff03.equals("")) nff03="0.0";
		String nff04="";
		if(nff04.equals("")) nff04="0.0";
		String nff05="";
		if(nff05.equals("")) nff05="0.0";

		String tff01="";
		String tff02="";
		String tff03="";
		String tff04="";
		String tff05="";

		String bff01="";
		if(bff01.equals("")) bff01="0";
		String bff02="";
		if(bff02.equals("")) bff02="0";
		String bff03="";
		if(bff03.equals("")) bff03="0";
		String bff04="";
		if(bff04.equals("")) bff04="0";
		String bff05="";
		if(bff05.equals("")) bff05="0";

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
		ProcPara += flag+"0";
		ProcPara += flag+"0";
		ProcPara += flag+"0";
		ProcPara += flag+"0";
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
		ProcPara += flag+"1";
		ProcPara += flag+"0";
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

	//	out.print(ProcPara);

		boolean insertSuccess = false ;
		insertSuccess = RecordSet.executeProc("CRM_CustomerInfo_Insert",ProcPara);
		if (insertSuccess) {			
			RecordSet.executeProc("CRM_CustomerInfo_InsertID","");
			RecordSet.first();
			CustomerID = RecordSet.getString(1);
			if (CustomerID.length()<5){
			   PortalLoginid = "U" + Util.add0(Util.getIntValue(CustomerID),5);
			}else{
			   PortalLoginid = "U" + CustomerID;
			}
			sqlTemp = "update CRM_CustomerInfo set status = 4 , PortalLoginid = '"+PortalLoginid+"' , PortalPassword = '"+password+"' , PortalStatus = 2 where id = " + CustomerID ;
			CustomerInfoComInfo.addCustomerInfoCache(CustomerID);
			RecordSet.executeSql(sqlTemp);
			//通知客户经理的经理
			String operators = ResourceComInfo.getManagerID(Manager);

				SWFAccepter=operators;
				SWFTitle=Util.toScreen(SystemEnv.getHtmlLabelName(15006,user.getLanguage())+":",language,"0");
				SWFTitle += Name;
				SWFTitle += "-"+CurrentUserName;
				SWFTitle += "-"+CurrentDate;
				SWFRemark="";
				SWFSubmiter=CurrentUser;
				SysRemindWorkflow.setCRMSysRemind(SWFTitle,Util.getIntValue(CustomerID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);	

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

			String Title=Util.null2String(rs.getString("contacterTitle"));
			String LastName="";
			String FirstName=Util.null2String(rs.getString("contacterName"));
			String JobTitle=Util.null2String(rs.getString("contacterJobTitle"));
			String CEmail="";
			String PhoneOffice="";
			String PhoneHome="";
			String Mobile="";

			String interest="";
			String hobby="";
			String managerstr="";
			String subordinate="";
			String strongsuit="";
			String age="";
			String birthday="";
			String home="";
			String school="";
			String speciality="";
			String nativeplace="";
			String experience="";

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

			RecordSet.executeProc("CRM_CustomerContacter_Insert",ProcPara);

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

			RecordSet.executeProc("CRM_ContactLog_Insert",ProcPara);

			RecordSet.executeProc("CRM_ShareInfo_Update",Type+flag+CustomerID);
			//CRM_ShareInfo

			CrmViewer.setCrmShareByCrm(""+CustomerID);

			//自动发送mail通知客户_______Begin

			String defmailfrom = SystemComInfo.getDefmailfrom() ;
			String subject = ""+SystemEnv.getHtmlLabelName(84489,user.getLanguage()) ;
			String bodyText = ""+SystemEnv.getHtmlLabelName(84490,user.getLanguage()) ;
				   bodyText	+= ""+SystemEnv.getHtmlLabelName(83594,user.getLanguage())+"：" + PortalLoginid + "   " ;	
				   bodyText	+= ""+SystemEnv.getHtmlLabelName(83865,user.getLanguage())+"：" + password + "   " ;	
			if ((!defmailfrom.equals(""))&&(!Email.equals("")))
			{
				SendMail.send(defmailfrom,Email,"","",subject,bodyText,"3");
			}

			//自动发送mail通知客户_______End
			
			//把客户加入相应的邮件列表的用户中去_________Begin
			if (!journal.equals(""))
			{
				String mailListTemp = "" ;
				String mailListUserTemp1 = "" ;
				String mailListUserTemp2 = "" ;
				String CustomerIDTemp=","+CustomerID+"," ;
				ArrayList journalStr=Util.TokenizerString(journal,",");
				for (int ii=0 ; ii<journalStr.size() ; ii++)
				{
					mailListUserTemp1 = "" ;
					mailListUserTemp2 = "" ;
					sqlTemp = "select userList from webMailList where id = " + (String)journalStr.get(ii) ;
					RecordSet.executeSql(sqlTemp);
					if (RecordSet.next())
						mailListUserTemp1 = Util.null2String(RecordSet.getString("userList"));
					mailListUserTemp1 = mailListUserTemp2 ;
					if (!mailListUserTemp1.equals("")) 
					{
						mailListUserTemp1 ="," + mailListUserTemp1 + "," ;
						mailListUserTemp2 += "," ;
					}
					if (mailListUserTemp1.indexOf(CustomerIDTemp)==-1)
					{
						mailListUserTemp2 += CustomerID ;
						sqlTemp = "update webMailList set userList = '"+mailListUserTemp2+"' where id = " + (String)journalStr.get(ii) ;
						RecordSet.executeSql(sqlTemp);
					}
				}
			}
			//把客户加入相应的邮件列表的用户中去_________End
		}
	}
}


	//response.sendRedirect("/workflow/request/RequestView.jsp");
	out.print("<script>wfforward('/workflow/request/RequestView.jsp');</script>");

%>