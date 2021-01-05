
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*,
                 java.text.SimpleDateFormat" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.conn.RecordSetTrans" %>
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetT" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetP" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerContacterComInfo" class="weaver.crm.Maint.CustomerContacterComInfo" scope="page" />
<%
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;

FileUpload fu = new FileUpload(request);
String log=Util.null2String(fu.getParameter("log"));
char flag = 2;
String ProcPara = "";
String strTemp = "";
String CurrentUser = ""+user.getUID();
String ClientIP = fu.getRemoteAddr();
String SubmiterType = ""+user.getLogintype();

String frombase = Util.null2String(fu.getParameter("frombase"));

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);
String method = Util.null2String(fu.getParameter("method"));

String CustomerID=Util.null2String(fu.getParameter("CustomerID"));

String ContacterID=Util.null2String(fu.getParameter("ContacterID"));

String Remark=Util.fromScreen(fu.getParameter("Remark"),user.getLanguage());
String RemarkDoc= "" + Util.getIntValue(fu.getParameter("RemarkDoc"),0);
String fieldName = "";		// added by xys for TD2031
fieldName = SystemEnv.getHtmlLabelName(388,user.getLanguage());
if(method.equals("delete"))
{
	RecordSet.executeProc("CRM_CustomerContacter_SByID",ContacterID);
	if(RecordSet.getCounts()<=0)
	{
		response.sendRedirect("/CRM/data/EditContacter.jsp?ContacterID="+ContacterID+"&flag=true");
		return;
	}
	RecordSet.first();
	CustomerID = RecordSet.getString(2);

	RecordSet.executeProc("CRM_Find_CustomerContacter",CustomerID);
	if(RecordSet.getCounts()<=1)
	{
		//response.sendRedirect("/CRM/data/DeleteContacterError.jsp?CustomerID="+CustomerID+"&code=1");
		response.sendRedirect("/CRM/data/EditContacter.jsp?ContacterID="+ContacterID+"&flag=no");
		return;
	}
	RecordSet.first();
	if(RecordSet.getString(1).equals(ContacterID))
	{
		RecordSetT.executeProc("CRM_CustomerContacter_Delete",ContacterID);
		RecordSet.next();

		ProcPara = CustomerID+flag+"2"+flag+RecordSet.getString(1)+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+"0"+flag+"1";
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		RecordSetT.executeProc("CRM_CustomerContacter_UMain",RecordSet.getString(1)+flag+"1");
	}
	else
		RecordSetT.executeProc("CRM_CustomerContacter_Delete",ContacterID);

	ProcPara = CustomerID;
	ProcPara += flag+"dc";
	ProcPara += flag+RemarkDoc;
	ProcPara += flag+Remark;
	ProcPara += flag+CurrentDate;
	ProcPara += flag+CurrentTime;
	ProcPara += flag+CurrentUser;
	ProcPara += flag+SubmiterType;
	ProcPara += flag+ClientIP;
	RecordSet.executeProc("CRM_Log_Insert",ProcPara);

	//CustomerContacterComInfo.removeCustomerContacterCache();
	if(frombase.equals("1")){
%>
	<script type="text/javascript">
		if(opener != null && opener.onRefresh != null){opener.onRefresh();}
		window.close();
	</script>
<%	}else{
		response.sendRedirect("/CRM/data/ViewCustomer.jsp?CustomerID="+CustomerID+"&log="+log);
	}
	//response.sendRedirect("/CRM/data/ViewCustomerBase.jsp?CustomerID="+CustomerID+"&log="+log);
	return;
}

String Title=Util.fromScreen(fu.getParameter("Title"),user.getLanguage());
String LastName=Util.fromScreen(fu.getParameter("LastName"),user.getLanguage());
String FirstName=Util.fromScreen(fu.getParameter("FirstName"),user.getLanguage());
String JobTitle=Util.fromScreen(fu.getParameter("JobTitle"),user.getLanguage());
String CEmail=Util.fromScreen(fu.getParameter("CEmail"),user.getLanguage());
String PhoneOffice=Util.fromScreen(fu.getParameter("PhoneOffice"),user.getLanguage());
String PhoneHome=Util.fromScreen(fu.getParameter("PhoneHome"),user.getLanguage());
String Mobile=Util.fromScreen(fu.getParameter("Mobile"),user.getLanguage());
String CFax=Util.fromScreen(fu.getParameter("CFax"),user.getLanguage());
String Language=Util.fromScreen(fu.getParameter("Language"),user.getLanguage());
String Manager=Util.fromScreen(fu.getParameter("Manager"),user.getLanguage());
String Main=Util.fromScreen(fu.getParameter("Main"),user.getLanguage());
if(!Main.equals("")) Main="1";
else Main="0";
String Photo=Util.fromScreen(fu.getParameter("Photo"),user.getLanguage());
if(Photo.equals("")) Photo="0";

String interest=Util.fromScreen(fu.getParameter("interest"),user.getLanguage());
String hobby=Util.fromScreen(fu.getParameter("hobby"),user.getLanguage());
String managerstr=Util.fromScreen(fu.getParameter("managerstr"),user.getLanguage());
String subordinate=Util.fromScreen(fu.getParameter("subordinate"),user.getLanguage());
String strongsuit=Util.fromScreen(fu.getParameter("strongsuit"),user.getLanguage());
String age=Util.fromScreen(fu.getParameter("age"),user.getLanguage());
String birthday=Util.fromScreen(fu.getParameter("birthday"),user.getLanguage());
String home=Util.fromScreen(fu.getParameter("home"),user.getLanguage());
String school=Util.fromScreen(fu.getParameter("school"),user.getLanguage());
String speciality=Util.fromScreen(fu.getParameter("speciality"),user.getLanguage());
String nativeplace=Util.fromScreen(fu.getParameter("nativeplace"),user.getLanguage());
String IDCard=Util.fromScreen(fu.getParameter("IDCard"),user.getLanguage());
String isBirthdayNotify=Util.null2String(fu.getParameter("isbirthdaynotify"));
int birthdayNotifyDays=Util.getIntValue(fu.getParameter("birthdaynotifydays"),0);
String experience=Util.fromScreen(fu.getParameter("experience"),user.getLanguage());

String imcode = Util.fromScreen(fu.getParameter("imcode"),user.getLanguage());
String status = Util.fromScreen(fu.getParameter("status"),user.getLanguage());
String isneedcontact = Util.fromScreen(fu.getParameter("isneedcontact"),user.getLanguage());
String principalIds = Util.fromScreen3(fu.getParameter("principalIds"),user.getLanguage());
//转化客服负责人ID
ArrayList principalIdList = new ArrayList();
principalIdList = Util.TokenizerString(principalIds, ",");

String projectrole = Util.fromScreen3(fu.getParameter("projectrole"),user.getLanguage());//项目角色
String attitude = Util.fromScreen3(fu.getParameter("attitude"),user.getLanguage());//意向判断
String attention = Util.fromScreen3(fu.getParameter("attention"),user.getLanguage());//关注点
String department = Util.fromScreen3(fu.getParameter("department"),user.getLanguage());//部门

String dff01=Util.null2String(fu.getParameter("dff01"));
String dff02=Util.null2String(fu.getParameter("dff02"));
String dff03=Util.null2String(fu.getParameter("dff03"));
String dff04=Util.null2String(fu.getParameter("dff04"));
String dff05=Util.null2String(fu.getParameter("dff05"));

String nff01=Util.null2String(fu.getParameter("nff01"));
if(nff01.equals("")) nff01="0.0";
String nff02=Util.null2String(fu.getParameter("nff02"));
if(nff02.equals("")) nff02="0.0";
String nff03=Util.null2String(fu.getParameter("nff03"));
if(nff03.equals("")) nff03="0.0";
String nff04=Util.null2String(fu.getParameter("nff04"));
if(nff04.equals("")) nff04="0.0";
String nff05=Util.null2String(fu.getParameter("nff05"));
if(nff05.equals("")) nff05="0.0";

String tff01=Util.fromScreen(fu.getParameter("tff01"),user.getLanguage());
String tff02=Util.fromScreen(fu.getParameter("tff02"),user.getLanguage());
String tff03=Util.fromScreen(fu.getParameter("tff03"),user.getLanguage());
String tff04=Util.fromScreen(fu.getParameter("tff04"),user.getLanguage());
String tff05=Util.fromScreen(fu.getParameter("tff05"),user.getLanguage());

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
	if(Main.equals("1"))
	{
		RecordSet.executeProc("CRM_Find_CustomerContacter",CustomerID);
		if(RecordSet.getCounts()>0)
		{
			RecordSet.first();

			ProcPara = CustomerID+flag+"2"+flag+RecordSet.getString(1)+flag+"0";
			ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+"1"+flag+"0";
			ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
			RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
			RecordSetT.executeProc("CRM_CustomerContacter_UMain",RecordSet.getString(1)+flag+"0");
		}
	}

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
	ProcPara += flag+CFax;
	ProcPara += flag+Language;
	ProcPara += flag+Manager;
	ProcPara += flag+Main;
	ProcPara += flag+Photo;

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
	ProcPara += flag+IDCard;
	ProcPara += flag+isBirthdayNotify;
	ProcPara += flag+""+birthdayNotifyDays;

	String resourceimageid = Util.null2String(fu.uploadFiles("photoid"));
	if (resourceimageid.equals("")) resourceimageid="0";
	
	RecordSet.executeProc("CRM_CustomerContacter_Insert",ProcPara);
	RecordSet.executeSql("SELECT MAX(id) as id from CRM_CustomerContacter");
	if (RecordSet.next()) ContacterID = RecordSet.getString("id");
	RecordSet.executeSql("update CRM_CustomerContacter set remark = '" + Remark + "' , remarkDoc = " + RemarkDoc + ",contacterimageid="+resourceimageid+
						  ",projectrole='"+projectrole+"',attitude='"+attitude+"',attention='"+attention+"',department='"+department+"',imcode='"+imcode+"' where id = " + ContacterID);

	//添加联系人与负责人关联
	//客户与客服负责人关联
	//删除原关联
		//RecordSetP.executeSql("delete from CS_CustomerPrincipal where customerId = " + CustomerID);
	for (int i = 0; i < principalIdList.size(); i++) {
		String principalId = (String) principalIdList.get(i);
		String principalSql = "insert into CS_ContacterPrincipal (contacterId,principalId) values (" + ContacterID + ","+ principalId +")";
		RecordSetTrans rst = new RecordSetTrans();
		rst.setAutoCommit(false);
		try {
			rst.executeSql(principalSql);
			rst.commit();
		} catch (Exception e) {
			rst.rollback();
			e.printStackTrace();
		}
	}
	
	ProcPara = CustomerID;
	ProcPara += flag+"nc";
	ProcPara += flag+RemarkDoc;
	ProcPara += flag+Remark;
	ProcPara += flag+CurrentDate;
	ProcPara += flag+CurrentTime;
	ProcPara += flag+CurrentUser;
	ProcPara += flag+SubmiterType;
	ProcPara += flag+ClientIP;
	RecordSet.executeProc("CRM_Log_Insert",ProcPara);
	
	//快速添加
	if("1".equals(fu.getParameter("quickadd"))){
%>
	<script type="text/javascript">
		parent.quickcomplete("<%=ContacterID%>");
	</script>
<%
		return;
	}

	if(frombase.equals("1")){
%>
	<script type="text/javascript">
		if(opener != null && opener.onRefresh != null){opener.onRefresh();}
		window.location="/CRM/data/ViewContacter.jsp?log=n&ContacterID=<%=ContacterID%>&canedit=true&frombase=1";
	</script>
<%	
		return;
	}
	//CustomerContacterComInfo.removeCustomerContacterCache();

	//response.sendRedirect("/CRM/data/ViewCustomerBase.jsp?log=n&CustomerID="+CustomerID);
	response.sendRedirect("/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+CustomerID);
	return;
}

if(method.equals("edit"))
{
	RecordSet.executeProc("CRM_CustomerContacter_SByID",ContacterID);
	if(RecordSet.getCounts()<=0)
	{
		response.sendRedirect("/base/error/DBError.jsp?type=FindData");
		return;
	}
	RecordSet.first();
	CustomerID = RecordSet.getString(2);

	boolean bNeedUpdate = false;
	
	strTemp = RecordSet.getString("title");
	if(!Title.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(17061,user.getLanguage())+"ID";
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Title;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("lastname");
	if(!LastName.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(612,user.getLanguage());
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+LastName;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("firstname");
	if(!FirstName.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(461,user.getLanguage());
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+FirstName;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("jobtitle");
	if(!JobTitle.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(1915,user.getLanguage());
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+JobTitle;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("email");
	if(!CEmail.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(477,user.getLanguage());
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+CEmail;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("phoneoffice");
	if(!PhoneOffice.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(661,user.getLanguage());
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+PhoneOffice;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("phonehome");
	if(!PhoneHome.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(1969,user.getLanguage());
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+PhoneHome;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("mobilephone");
	if(!Mobile.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(620,user.getLanguage());
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Mobile;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("fax");
	if(!CFax.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(494,user.getLanguage());
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+CFax;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("language");
	if(!Language.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(462,user.getLanguage())+SystemEnv.getHtmlLabelName(231,user.getLanguage())+"ID";
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Language;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("manager");
	if(!Manager.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(1507,user.getLanguage())+"ID";
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Manager;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("picid");
	if(!Photo.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(74,user.getLanguage())+"ID";
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Photo;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("interest");
	if(!interest.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(6066,user.getLanguage());
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+interest;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("hobby");
	if(!hobby.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(6067,user.getLanguage());
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+hobby;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("managerstr");
	if(!managerstr.equals(strTemp))
	{	
		fieldName = SystemEnv.getHtmlLabelName(23248,user.getLanguage());
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+managerstr;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("subordinate");
	if(!subordinate.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(442,user.getLanguage());
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+subordinate;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("strongsuit");
	if(!strongsuit.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(6068,user.getLanguage());
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+strongsuit;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	/*strTemp = RecordSet.getString("age");
	if(!age.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(671,user.getLanguage());
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+age;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}*///不存在,bug TD2234

	strTemp = RecordSet.getString("birthday");
	if(!birthday.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(1884,user.getLanguage());
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+birthday;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("home");
	if(!home.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(1967,user.getLanguage());
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+home;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("school");
	if(!school.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(1518,user.getLanguage());
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+school;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("speciality");
	if(!speciality.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(803,user.getLanguage());
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+speciality;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("nativeplace");
	if(!nativeplace.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(1900,user.getLanguage());
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+nativeplace;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

    //增加身份证号码 add by 王金永
	strTemp = RecordSet.getString("IDCard");
	if(!IDCard.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(1887,user.getLanguage());
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+IDCard;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

    //增加生日提醒 add by 王金永
	strTemp = RecordSet.getString("isbirthdaynotify");
	if(!isBirthdayNotify.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(17534,user.getLanguage());
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+isBirthdayNotify;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

    strTemp = RecordSet.getString("birthdaynotifydays");
    if(!String.valueOf(birthdayNotifyDays).equals(strTemp))
    {
				fieldName = SystemEnv.getHtmlLabelName(15792,user.getLanguage());
        ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
        ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+birthdayNotifyDays;
        ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
        RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
        bNeedUpdate = true;

    }

	strTemp = RecordSet.getString("experience");
	if(!experience.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(812,user.getLanguage());
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+experience;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}




	String resourceimageid= Util.null2String(fu.uploadFiles("photoid"));
	if (resourceimageid.equals("")) resourceimageid="0";
	strTemp = RecordSet.getString("datefield1");
	if(!dff01.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(97,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "1";
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+dff01;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("datefield2");
	if(!dff02.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(97,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "2";
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+dff02;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("datefield3");
	if(!dff03.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(97,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "3";
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+dff03;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("datefield4");
	if(!dff04.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(97,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "4";
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+dff04;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("datefield5");
	if(!dff05.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(97,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "5";
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+dff05;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("numberfield1");
	if(!nff01.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(607,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "1";
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+nff01;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("numberfield2");
	if(!nff02.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(607,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "2";
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+nff02;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("numberfield3");
	if(!nff03.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(607,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "3";
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+nff03;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("numberfield4");
	if(!nff04.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(607,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "4";
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+nff04;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("numberfield5");
	if(!nff05.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(607,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "5";
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+nff05;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("department");
	if(!tff01.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(608,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "1";
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+tff01;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("textfield2");
	if(!tff02.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(608,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "2";
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+tff02;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("textfield3");
	if(!tff03.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(608,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "3";
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+tff03;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("textfield4");
	if(!tff04.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(608,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "4";
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+tff04;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("textfield5");
	if(!tff05.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(608,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "5";
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+tff05;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("tinyintfield1");
	if(!bff01.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(607,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "1";
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+bff01;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("tinyintfield2");
	if(!bff02.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(607,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "2";
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+bff02;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("tinyintfield3");
	if(!bff03.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(607,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "3";
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+bff03;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("tinyintfield4");
	if(!bff04.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(607,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "4";
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+bff04;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("tinyintfield5");
	if(!bff05.equals(strTemp))
	{
		fieldName = SystemEnv.getHtmlLabelName(607,user.getLanguage()) + SystemEnv.getHtmlLabelName(261,user.getLanguage()) + "5";
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+bff05;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}
	
	strTemp = RecordSet.getString("imcode");
	if(!imcode.equals(strTemp))
	{
		fieldName = "IM号码";
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+imcode;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}
	
	strTemp = RecordSet.getString("status");
	if(!status.equals(strTemp))
	{
		fieldName = "状态";
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+status;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}
	
	strTemp = RecordSet.getString("isneedcontact");
	if(!isneedcontact.equals(strTemp))
	{
		fieldName = "是否需要联系";
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+isneedcontact;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}
	
	strTemp = RecordSet.getString("projectrole");
	if(!projectrole.equals(strTemp))
	{
		fieldName = "项目角色";
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+isneedcontact;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}
	
	strTemp = RecordSet.getString("attitude");
	if(!attitude.equals(strTemp))
	{
		fieldName = "意向判断";
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+isneedcontact;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}
	
	strTemp = RecordSet.getString("attention");
	if(!attention.equals(strTemp))
	{
		fieldName = "关注点";
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+isneedcontact;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("main");
	RecordSet.executeProc("CRM_Find_CustomerContacter",CustomerID);
	if(RecordSet.getCounts()<=1)
		Main="1";
	RecordSet.first();
	if(RecordSet.getString(1).equals(ContacterID))
		Main="1";
	if(!Main.equals(strTemp))
	{	
		fieldName = SystemEnv.getHtmlLabelName(1262,user.getLanguage());
		ProcPara = CustomerID+flag+"2"+flag+ContacterID+flag+"0";
		ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Main;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
		bNeedUpdate = true;

		if(strTemp.equals("0"))
		{
			ProcPara = CustomerID+flag+"2"+flag+RecordSet.getString(1)+flag+"0";
			ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+Main+flag+strTemp;
			ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
			RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
			RecordSetT.executeProc("CRM_CustomerContacter_UMain",RecordSet.getString(1)+flag+"0");
		}
		else
		{
			RecordSet.next();
			ProcPara = CustomerID+flag+"2"+flag+RecordSet.getString(1)+flag+"0";
			ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+Main+flag+strTemp;
			ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
			RecordSetT.executeProc("CRM_Modify_Insert",ProcPara);
			RecordSetT.executeProc("CRM_CustomerContacter_UMain",RecordSet.getString(1)+flag+"1");
		}
	}

	if(bNeedUpdate)
	{
		ProcPara = ContacterID;
		ProcPara += flag+Title;
		ProcPara += flag+FirstName;
		ProcPara += flag+LastName;
		ProcPara += flag+FirstName;
		ProcPara += flag+JobTitle;
		ProcPara += flag+CEmail;
		ProcPara += flag+PhoneOffice;
		ProcPara += flag+PhoneHome;
		ProcPara += flag+Mobile;
		ProcPara += flag+CFax;
		ProcPara += flag+Language;
		ProcPara += flag+Manager;
		ProcPara += flag+Main;
		ProcPara += flag+Photo;

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

		ProcPara += flag+IDCard;
        ProcPara += flag+isBirthdayNotify;
        ProcPara += flag+""+birthdayNotifyDays;
        ProcPara += flag+imcode;
        ProcPara += flag+""+status;
        ProcPara += flag+""+isneedcontact;
        ProcPara += flag+projectrole;
    	ProcPara += flag+attitude;
    	ProcPara += flag+attention;

		//CustomerContacterComInfo.removeCustomerContacterCache();

		RecordSet.executeProc("CRM_CustomerContacter_Update",ProcPara);
		ProcPara = CustomerID;
		ProcPara += flag+"mc";
		ProcPara += flag+RemarkDoc;
		ProcPara += flag+Remark;
		ProcPara += flag+CurrentDate;
		ProcPara += flag+CurrentTime;
		ProcPara += flag+CurrentUser;
		ProcPara += flag+SubmiterType;
		ProcPara += flag+ClientIP;
		RecordSet.executeProc("CRM_Log_Insert",ProcPara);

	}
	
	String resourceoldimageid = Util.null2String(fu.getParameter("oldresourceimage"));	
	if(!"".equals(resourceoldimageid)){
	   resourceimageid = resourceoldimageid;
	}
	if("".equals(resourceoldimageid) && "".equals(resourceimageid)){
	   resourceimageid = "0";
	}
	
	if(!"".equals(Remark))  Remark = Remark.replace("<br>","");
	
	RecordSet.executeSql("update CRM_CustomerContacter set remark = '" + Remark + "', remarkDoc = " + RemarkDoc + ",contacterimageid="+resourceimageid+" where id = " + ContacterID);	
	
	//添加联系人与负责人关联
	//客户与客服负责人关联
	//删除原关联
	RecordSetP.executeSql("delete from CS_ContacterPrincipal where contacterId = " + ContacterID);
	for (int i = 0; i < principalIdList.size(); i++) {
		String principalId = (String) principalIdList.get(i);
		String principalSql = "insert into CS_ContacterPrincipal (contacterId,principalId) values (" + ContacterID + ","+ principalId +")";
		RecordSetTrans rst = new RecordSetTrans();
		rst.setAutoCommit(false);
		try {
			rst.executeSql(principalSql);
			rst.commit();
		} catch (Exception e) {
			rst.rollback();
			e.printStackTrace();
		}
	}
	if(frombase.equals("1")){
%>
			<script type="text/javascript">
				if(opener != null && opener.onRefresh != null){opener.onRefresh();}
				window.location="/CRM/data/ViewContacter.jsp?log=<%=log%>&ContacterID=<%=ContacterID%>&frombase=1";
			</script>
<%	
		return;
	}
	response.sendRedirect("/CRM/data/ViewContacter.jsp?ContacterID="+ContacterID+"&log="+log);
	return;
}
if(method.equals("delpic"))
{
	RecordSet.executeSql("update CRM_CustomerContacter set remark = '" + Remark + "' , remarkDoc = " + RemarkDoc + ",contacterimageid=0 where id = " + ContacterID);
	response.sendRedirect("/CRM/data/ViewContacter.jsp?ContacterID="+ContacterID+"&log="+log);
	return;
}
%>
<p><%=SystemEnv.getHtmlLabelName(15127,user.getLanguage())%>！</p>