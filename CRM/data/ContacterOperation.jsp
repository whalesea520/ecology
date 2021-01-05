
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*,
                 java.text.SimpleDateFormat" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.file.FileUpload" %>
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetT" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerContacterComInfo" class="weaver.crm.Maint.CustomerContacterComInfo" scope="page" />
<%
FileUpload fu = new FileUpload(request);
String log=Util.null2String(fu.getParameter("log"));
char flag = 2;
String ProcPara = "";
String CurrentUser = ""+user.getUID();
String ClientIP = fu.getRemoteAddr();
String SubmiterType = ""+user.getLogintype();

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

	CustomerContacterComInfo.removeCustomerContacterCache();

	//response.sendRedirect("/CRM/data/ViewCustomer.jsp?CustomerID="+CustomerID+"&log="+log);
	response.sendRedirect("/CRM/data/ViewCustomerBase.jsp?CustomerID="+CustomerID+"&log="+log);
	return;
}

String Main=Util.fromScreen(fu.getParameter("Main"),user.getLanguage());
if(!Main.equals("")) Main="1";
else Main="0";

if(method.equals("add"))
{
	if(Main.equals("1")){
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
	
	String sql = "select fieldhtmltype ,type,fieldname from CRM_CustomerDefinField "+
	" where usetable = 'CRM_CustomerContacter' and isopen = 1";
	RecordSet.execute(sql);
	if(0 == RecordSet.getCounts()){
		out.println("<script>parent.getDialog(window).close()</script>");
		return;
	}

	String fieldSql = "";
	String valueSql = "";
	while(RecordSet.next()){
		 fieldName= RecordSet.getString("fieldname");
		 String fieldValue = Util.null2String(fu.getParameter(fieldName));	
		 fieldSql += fieldName+",";
		 valueSql += "'"+fieldValue+"',";
		 if(fieldName.equals("firstname")){//全称
			 fieldSql += "fullname,";
			 valueSql += "'"+fieldValue+"',";
		 }
	}
	
	fieldSql +="customerid";
	valueSql +=CustomerID;
	sql = "insert into CRM_CustomerContacter("+fieldSql+") values ("+valueSql+")";
	RecordSet.execute(sql);
	
	RecordSet.execute("select max(id) from CRM_CustomerContacter");
	
	if (RecordSet.next()) ContacterID = RecordSet.getString("id");

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

	CustomerContacterComInfo.removeCustomerContacterCache();

	out.println("<script>parent.getParentWindow(window).closeDialog()</script>");
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