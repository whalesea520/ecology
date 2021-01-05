
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.email.sequence.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hrm" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="crmContacter" class="weaver.crm.Maint.CustomerContacterComInfo" scope="page" />
<%
String sql = "";
String operation = Util.null2String(request.getParameter("operation"));
String groupName = Util.null2String(request.getParameter("groupName"));
String keepon = Util.null2String(request.getParameter("keepon"));
int parentId = Util.getIntValue(request.getParameter("parentId"), 0);
int userId = user.getUID();
int groupId = Util.getIntValue(request.getParameter("groupId"), 0);
int contacterId = Util.getIntValue(request.getParameter("contacterId"));
int maxGroupId = 0;
int maxContacterId = 0;

String mailUserName = Util.null2String(request.getParameter("mailUserName"));
String mailUserEmail = Util.null2String(request.getParameter("mailUserEmail"));
String mailUserDesc = Util.null2String(request.getParameter("mailUserDesc"));
String mailUserEmailP = Util.null2String(request.getParameter("mailUserEmailP"));
String mailUserTelP = Util.null2String(request.getParameter("mailUserTelP"));
String mailUserMobileP = Util.null2String(request.getParameter("mailUserMobileP"));
String mailUserIMP = Util.null2String(request.getParameter("mailUserIMP"));
String mailUserAddressP = Util.null2String(request.getParameter("mailUserAddressP"));
String mailUserTelW = Util.null2String(request.getParameter("mailUserTelW"));
String mailUserFaxW = Util.null2String(request.getParameter("mailUserFaxW"));
String mailUserCompanyW = Util.null2String(request.getParameter("mailUserCompanyW"));
String mailUserDepartmentW = Util.null2String(request.getParameter("mailUserDepartmentW"));
String mailUserPostW = Util.null2String(request.getParameter("mailUserPostW"));
String mailUserAddressW = Util.null2String(request.getParameter("mailUserAddressW"));

String mailUserType = "";
int mailUserTypeId = 0;

if(operation.equals("groupAdd")){
	int _mailgroupid = MailGroupSequence.getInstance().get();
	sql = "INSERT INTO MailUserGroup (mailgroupid, createrid, mailgroupname, parentId, subCount) VALUES ("+_mailgroupid+", "+userId+", '"+groupName+"', "+parentId+", 0)";
	rs.executeSql(sql);
	sql = "UPDATE MailUserGroup SET subCount=subCount+1 WHERE mailgroupid="+parentId+"";
	rs.executeSql(sql);

	maxGroupId = _mailgroupid;
	out.print("<script type='text/javascript'>parent.addTreeNode("+maxGroupId+", '"+groupName+"', 'group');</script>");
	return;
//=======================================================================
}else if(operation.equals("groupDelete")){
	//TODO Recursion SubGroup and contacters in the group
	sql = "DELETE FROM MailUserGroup WHERE mailgroupid="+groupId+"";
	rs.executeSql(sql);

//=======================================================================
}else if(operation.equals("groupRename")){
	//TODO Recursion SubGroup and contacters in the group
	sql = "UPDATE MailUserGroup SET mailgroupname='"+groupName+"' WHERE mailgroupid="+groupId+"";
	rs.executeSql(sql);

	out.print("<script type='text/javascript'>parent.updateTreeNode('"+groupName+"');</script>");
	return;

//=======================================================================
}else if(operation.equals("contacterCheck")){
	String mailAddress = Util.null2String(request.getParameter("mailAddress"));
	rs.executeSql("SELECT id FROM MailUserAddress WHERE mailAddress='"+mailAddress+"' AND userId="+userId+"");
	if(rs.next()){
		out.print("1");//邮件地址已存在
	}else{
		out.print("0");
	}
	return;

//=======================================================================
}else if(operation.equals("contacterAdd")){
	//Type 1:contacter 2:hrm 3:crm
	mailUserType = "1";
	maxContacterId = MailContacterSequence.getInstance().get();

	sql = "INSERT INTO MailUserAddress (id, mailgroupid, mailUserName, mailAddress, userId, mailUserType, mailUserDesc, mailUserEmailP, mailUserTelP, mailUserMobileP, mailUserIMP, mailUserAddressP, mailUserTelW, mailUserFaxW, mailUserCompanyW, mailUserDepartmentW, mailUserPostW, mailUserAddressW) VALUES ("+maxContacterId+", "+groupId+", '"+mailUserName+"', '"+mailUserEmail+"', "+userId+", '"+mailUserType+"', '"+mailUserDesc+"', '"+mailUserEmailP+"', '"+mailUserTelP+"', '"+mailUserMobileP+"', '"+mailUserIMP+"', '"+mailUserAddressP+"', '"+mailUserTelW+"', '"+mailUserFaxW+"', '"+mailUserCompanyW+"', '"+mailUserDepartmentW+"', '"+mailUserPostW+"', '"+mailUserAddressW+"')";
	rs.executeSql(sql);

	if(keepon.equals("1")){
		response.sendRedirect("MailContacterAdd.jsp?groupId="+groupId+"");
	}else{
		response.sendRedirect("MailContacter.jsp?groupId="+groupId+"");
	}
	return;

//=======================================================================
}else if(operation.equals("contacterEdit")){
	sql = "UPDATE MailUserAddress SET mailUserName='"+mailUserName+"', mailAddress='"+mailUserEmail+"', mailUserDesc='"+mailUserDesc+"', mailUserEmailP='"+mailUserEmailP+"', mailUserTelP='"+mailUserTelP+"', mailUserMobileP='"+mailUserMobileP+"', mailUserIMP='"+mailUserIMP+"', mailUserAddressP='"+mailUserAddressP+"', mailUserTelW='"+mailUserTelW+"', mailUserFaxW='"+mailUserFaxW+"', mailUserCompanyW='"+mailUserCompanyW+"', mailUserDepartmentW='"+mailUserDepartmentW+"', mailUserPostW='"+mailUserPostW+"', mailUserAddressW='"+mailUserAddressW+"' WHERE id="+contacterId+"";
	rs.executeSql(sql);
	response.sendRedirect("MailContacter.jsp?groupId="+groupId+"");
	return;

//=======================================================================
}else if(operation.equals("contacterDelete")){
	sql = "DELETE FROM MailUserAddress WHERE id="+contacterId+"";
	rs.executeSql(sql);
	response.sendRedirect("MailContacter.jsp?groupId="+groupId+"");
	return;

//=======================================================================
}else if(operation.equals("contacterBatchDelete")){
	String contacterIds = Util.null2String(request.getParameter("contacterIds"));
	if(contacterIds.endsWith(",")) contacterIds = contacterIds.substring(0, contacterIds.length()-1);
	sql = "DELETE FROM MailUserAddress WHERE id IN ("+contacterIds+")";
	rs.executeSql(sql);
	response.sendRedirect("MailContacter.jsp?groupId="+groupId+"");
	return;

//=======================================================================
}else if(operation.equals("contacterMove")){
	String contacterIds = Util.null2String(request.getParameter("contacterIds"));
	if(contacterIds.endsWith(",")) contacterIds = contacterIds.substring(0, contacterIds.length()-1);
	sql = "UPDATE MailUserAddress SET mailgroupid="+groupId+" WHERE id IN ("+contacterIds+")";
	rs.executeSql(sql);
	response.sendRedirect("MailContacter.jsp?groupId="+groupId+"");
	return;

//=======================================================================
}else if(operation.equals("move")){
	String contacterIds = Util.null2String(request.getParameter("contacterIds"));
	if(contacterIds.endsWith(",")) contacterIds = contacterIds.substring(0, contacterIds.length()-1);
	sql = "UPDATE MailUserAddress SET mailgroupid="+groupId+" WHERE id IN ("+contacterIds+")";
	rs.executeSql(sql);
	return;
//=======================================================================
}else if(operation.equals("contacterImportHRM")){
	//Type 1:contacter 2:hrm 3:crm
	mailUserType = "2";

	String contacterIds = Util.null2String(request.getParameter("resourceid"));
	if(contacterIds.endsWith(",")) contacterIds = contacterIds.substring(0, contacterIds.length()-1);
	if(contacterIds.startsWith(",")) contacterIds = contacterIds.substring(1, contacterIds.length());
	
	String[] ids = Util.TokenizerString2(contacterIds, ",");
	for(int i=0;i<ids.length;i++){
		maxContacterId = MailContacterSequence.getInstance().get();

		sql = "INSERT INTO MailUserAddress (mailgroupid, mailaddress, id, userId, mailUserName, mailUserType, mailUserDesc) VALUES ("+groupId+", '"+hrm.getEmail(ids[i])+"', "+maxContacterId+", "+user.getUID()+", '"+hrm.getResourcename(ids[i])+"', '"+mailUserType+"', '"+ids[i]+"')";
		rs.executeSql(sql);
	}
	response.sendRedirect("MailContacter.jsp?groupId="+groupId+"");
	return;

//=======================================================================
}else if(operation.equals("contacterImportCRM")){
	//Type 1:contacter 2:hrm 3:crm
	mailUserType = "3";

	String contacterIds = Util.null2String(request.getParameter("resourceid"));
	if(contacterIds.endsWith(",")) contacterIds = contacterIds.substring(0, contacterIds.length()-1);
	if(contacterIds.startsWith(",")) contacterIds = contacterIds.substring(1, contacterIds.length());
	
	String[] ids = Util.TokenizerString2(contacterIds, ",");
	for(int i=0;i<ids.length;i++){
		maxContacterId = MailContacterSequence.getInstance().get();

		sql = "INSERT INTO MailUserAddress (mailgroupid, mailaddress, id, userId, mailUserName, mailUserType, mailUserDesc) VALUES ("+groupId+", '"+crmContacter.getCustomerContacteremail(ids[i])+"', "+maxContacterId+", "+user.getUID()+", '', '"+mailUserType+"', '"+ids[i]+"')";
		rs.executeSql(sql);
	}
	response.sendRedirect("MailContacter.jsp?groupId="+groupId+"");
	return;

//=======================================================================
}else if(operation.equals("contacterImportCSV")){
	//Type 1:contacter 2:hrm 3:crm
	mailUserType = "1";

	String columnNames = Util.null2String(request.getParameter("columnNames"));
	String fieldNames = Util.null2String(request.getParameter("fieldNames"));
	columnNames = columnNames.endsWith(",") ? columnNames.substring(0, columnNames.length()-1) : columnNames;
	fieldNames = fieldNames.endsWith(",") ? fieldNames.substring(0, fieldNames.length()-1) : fieldNames;
	String[] arrayColumnNames = Util.TokenizerString2(columnNames, ",");
	String path = Util.null2String(request.getParameter("path"));
	String fullFileName = Util.null2String(request.getParameter("fullFileName"));

	//Read CSV
	try{
		java.util.Properties ps = new java.util.Properties();
		ps.put("charset",weaver.general.GCONST.PROP_UTF8);
		
		Class.forName("org.relique.jdbc.csv.CsvDriver");
		Connection conn = DriverManager.getConnection("jdbc:relique:csv:" + path, ps);
		Statement stmt = conn.createStatement();
		sql = "SELECT "+columnNames+" FROM "+fullFileName.substring(0, fullFileName.length()-4)+"";
		ResultSet results = stmt.executeQuery(sql);
		
		while(results.next()){
			String sqlValues = "";
			maxContacterId = MailContacterSequence.getInstance().get();

			for(int i=1;i<=arrayColumnNames.length;i++){
				sqlValues += "'"+Util.null2String(results.getString(i))+"'" + ",";
			}
			sqlValues = sqlValues.endsWith(",") ? sqlValues.substring(0, sqlValues.length()-1) : sqlValues;
			sql = "INSERT INTO MailUserAddress (mailgroupid,id,userId,mailUserType,"+fieldNames+") VALUES ("+groupId+","+maxContacterId+","+user.getUID()+",'"+mailUserType+"',"+sqlValues+")";
			//out.println(sql);
			//TODO Batch
			rs.executeSql(sql);
		}
		

		results.close();
		stmt.close();
		conn.close();
	}catch(Exception e){
		//TODO
	}
	response.sendRedirect("MailContacter.jsp?groupId="+groupId+"");
	return;
}

//For Ajax
out.println(maxGroupId);
%>