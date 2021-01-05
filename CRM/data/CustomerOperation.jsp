
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="java.io.*" %>
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetT" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetAD" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="CustomerModifyLog" class="weaver.crm.data.CustomerModifyLog" scope="page"/>
<jsp:useBean id="BaiduMapUtil" class="weaver.crm.customermap.BaiduMapUtil" scope="page"/>
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

if(method.equals("delete"))// 私人用户和企业用户共用该方法
{
	/*权限判断－－Begin*/
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


String TypeFrom=CurrentDate;

//部门由人力资源表中选出该经理的部门
String seclevel=Util.fromScreen3(fu.getParameter("seclevel"),user.getLanguage());

if(method.equals("add")){
	
	String CreditAmount=Util.fromScreen3(fu.getParameter("CreditAmount"),user.getLanguage());
	String creditLevel = "0";
	if(CreditAmount!=null && !CreditAmount.trim().equals("")){
		RecordSet.executeProc("Sales_CRM_CreditInfo_Select" , CreditAmount+"");
		if (RecordSet.next()){
			creditLevel = RecordSet.getString(1);
		}
	}
	
	String city=Util.fromScreen3(fu.getParameter("city"),user.getLanguage());
	String province = "0";
	String Country = "0";
	if(!"".equals(city)){
		province =CityComInfo.getCityprovinceid(city);
		Country = CityComInfo.getCitycountryid(city);
	}
	
	//查出所有非联系人的字段信息
	String sql = "select fieldhtmltype ,type,fieldname from CRM_CustomerDefinField "+
		" where usetable = 'CRM_CustomerInfo' and isopen = 1 and groupid !=4 ";
	RecordSet.execute(sql);
	if(0 == RecordSet.getCounts()){
		out.println("<script>parent.location.href='/CRM/data/ViewCustomer.jsp?addshow=1&log=n&CustomerID="+CustomerID+"';</script>"); 
		return;
	}
	
	String fieldSql = "";
	String valueSql = "";
	boolean islanguage = false;
	while(RecordSet.next()){
		 fieldName= RecordSet.getString("fieldname");
		 String fieldValue = Util.null2String(fu.getParameter(fieldName));	
		 if(RecordSet.getInt("fieldhtmltype")== 1 && RecordSet.getInt("type")== 3){//浮点数
			 fieldValue = fieldValue.equals("")?"0":fieldValue;
		 }
		
		 if(fieldName.equals("website") && !fieldValue.equals("")){
		 	if(fieldValue.indexOf(":")==-1){
		 		fieldValue="http://"+fieldValue.trim();
			}else{
				fieldValue=Util.StringReplace(fieldValue,"\\","/");
			}
		 }
		 if(fieldName.equals("status") && fieldValue.equals("")){//如果没有设定客户类型，默认为无效客户
			 fieldValue = "1";
		 }
		 if(fieldName.equals("language") ){//如果没有设定语言则默认设置为中文
			 if(("".equals(fieldValue)||"0".equals(fieldValue)||fieldValue == null)) {
				 fieldValue = "7";
			 }
		 	 islanguage = true;
		 }
		 fieldSql += fieldName+",";
		 valueSql += "'"+fieldValue+"',";
	}
	
	if(!islanguage) {
		fieldSql += "language,";
		valueSql += "'7',";
	}
		
	fieldSql += "fincode,currency,contractlevel,creditlevel,creditoffset,"+
				"discount,invoiceacount,deliverytype,paymentterm,paymentway,"+
				"saleconfirm,typebegin,rating,createdate,province,Country,deleted,"+
				"department,subcompanyid1";
	valueSql += "0,0,0,'"+creditLevel+"',0,"+
				"100,0,0,0,0,"+
				"0,'"+TypeFrom+"',0,'"+CurrentDate+"',"+province+","+Country+",0,"+
				"'"+ResourceComInfo.getDepartmentID(Util.null2String(fu.getParameter("manager")))+"','"+ResourceComInfo.getSubCompanyID(Util.null2String(fu.getParameter("manager")))+"'";
	sql = "insert into CRM_CustomerInfo("+fieldSql+") values ("+valueSql+")";
	RecordSet.execute(sql);
	
	RecordSet.execute("select max(id) from CRM_CustomerInfo where manager = "+fu.getParameter("manager")+" and createdate = '"+CurrentDate+"'");
	
	if (RecordSet.next()) {
		CustomerID = RecordSet.getString(1);
		CustomerInfoComInfo.addCustomerInfoCache(CustomerID);
		
		//获取提醒配置
		RecordSet.executeSql("select * from crm_customerSettings where id=-1");
		RecordSet.first();
		String CRM_addRemind=Util.null2String(RecordSet.getString("crm_rmd_create"));//是否开启创建客户提醒。             Y：开启，    N：关闭
    	String CRM_addRemindTo=Util.null2String(RecordSet.getString("crm_rmd_create2"));//创建客户提醒对象。            1：直接上级，2：所有上级
		if("Y".equals(CRM_addRemind)){
			//通知客户提醒对象
			String operators = ResourceComInfo.getManagerID(fu.getParameter("manager"));//默认提醒直接上级
			if("2".equals(CRM_addRemindTo))
				operators = ResourceComInfo.getManagersIDs(fu.getParameter("manager"));
			
		    if(operators!=null && !operators.equals("0")){
				SWFAccepter=operators;
				SWFTitle=SystemEnv.getHtmlLabelName(15006,user.getLanguage());
				SWFTitle += Util.fromScreen3(fu.getParameter("Name"),user.getLanguage());
				SWFTitle += "-"+CurrentUserName;
				SWFTitle += "-"+CurrentDate;
				SWFRemark="";
				SWFSubmiter=CurrentUser;
				if("2".equals(user.getLogintype())){
					SWFSubmiter=fu.getParameter("manager");
				}
				SysRemindWorkflow.setCRMSysRemind(SWFTitle,Util.getIntValue(CustomerID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
				
				//系统触发流程会给客户经理的经理一个对该客户的查看权限，与下面的CrmShareBase.setDefaultShare(""+CustomerID);重复。
				RecordSet.executeSql("delete from CRM_shareinfo where relateditemid="+CustomerID);
		    }
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

		
		//查找出联系人信息
		sql = "select fieldhtmltype ,type,fieldname from CRM_CustomerDefinField "+
		" where usetable = 'CRM_CustomerInfo' and isopen = 1 and groupid =4 ";
		RecordSet.execute(sql);
		if(0 == RecordSet.getCounts()){
			out.println("<script>parent.location.href='/CRM/data/ViewCustomer.jsp?addshow=1&log=n&CustomerID="+CustomerID+"';</script>");
			return;
		}
		
		if(!fu.getParameter("firstname").trim().equals("")){//联系人姓名为空则不保存联系人信息
			fieldSql = "";
			valueSql = "";
			while(RecordSet.next()){
				 fieldName= RecordSet.getString("fieldname");
				 String fieldValue = Util.null2String(fu.getParameter(fieldName));
				 if(fieldName.equals("contacteremail")){
					 fieldName = "email";
				 }
				 if(fieldName.equals("firstname")){
					 fieldSql += "fullname,";
					 valueSql += "'"+fieldValue+"',";
				 }
				 fieldSql += fieldName+",";
				 valueSql += "'"+fieldValue+"',";
			}
			
			fieldSql += "customerid,LANGUAGE,manager,main,picid";
			valueSql += CustomerID+","+Util.getIntValue(fu.getParameter("language"),7)+","+fu.getParameter("manager")+",1,0";
			sql = "insert into CRM_CustomerContacter("+fieldSql+") values ("+valueSql+")";
			RecordSet.execute(sql);
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
		
		try{
	        RecordSetAD.execute("select id,address1,address2,address3 from CRM_CustomerInfo where id = '"+CustomerID+"'");
	        String address1 = "";
            String address2 = "";
            String address3 = "";
            String custmid = "";
	        while(RecordSetAD.next()){
	            address1 = Util.null2String(RecordSetAD.getString("address1"));
	            address2 = Util.null2String(RecordSetAD.getString("address2"));
	            address3 = Util.null2String(RecordSetAD.getString("address3"));
	            custmid = Util.null2String(RecordSetAD.getString("id"));
           }
	        String updateCoordinateSql = "UPDATE CRM_CustomerInfo SET ";
	        String adrsParmSql = "";
	        if(!"".equals(address1)){
	           //查询坐标
	           Map<String,String> map = BaiduMapUtil.getCoordinateByAddress(address1);
	           if(map.size()==2){
	               String lng = map.get("lng");
	               String lat = map.get("lat");
	               
	               adrsParmSql += ",lng1='"+lng+"'";
	               adrsParmSql += ",lat1='"+lat+"'";
	           }
	        }
	        if(!"".equals(address2)){
	            //查询坐标
	            Map<String,String> map = BaiduMapUtil.getCoordinateByAddress(address2);
	            if(map.size()==2){
	                String lng = map.get("lng");
	                String lat = map.get("lat");
	                
	                adrsParmSql += ",lng2='"+lng+"'";
	                adrsParmSql += ",lat2='"+lat+"'";
	            }
	        }
	        if(!"".equals(address3)){
	            //查询坐标
	            Map<String,String> map = BaiduMapUtil.getCoordinateByAddress(address3);
	            if(map.size()==2){
	                String lng = map.get("lng");
	                String lat = map.get("lat");
	                
	                adrsParmSql += ",lng3='"+lng+"'";
	                adrsParmSql += ",lat3='"+lat+"'";
	            }
	        }
	        if(!"".equals(adrsParmSql)) RecordSetAD.execute(updateCoordinateSql + adrsParmSql.substring(1) + " WHERE id="+custmid);
	    }catch(Exception e){}   
		
	}
	
	//添加客户时，如果中介机构不为空，则给CRM_ShareInfo中加入相应权限        开始
	String agent = Util.null2String(fu.getParameter("agent"));
	if(!"".equals(agent)){
		String agentSql = "insert into CRM_ShareInfo (relateditemid,sharetype,sharelevel,crmid,contents,deleted) values ('"+CustomerID+"',9,1,0,'"+agent+"',0)";
		RecordSet.executeSql(agentSql);
	}
	//添加客户时，如果中介机构不为空，则给CRM_ShareInfo中加入相应权限        开始
	
	out.println("<script>parent.location.href='/CRM/data/ViewCustomer.jsp?addshow=1&log=n&CustomerID="+CustomerID+"';</script>");
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
    RecordSet.executeSql(sql);
    if(RecordSet.next()){
        workflowid = RecordSet.getInt("workflowid");
    }
    if(workflowid==-1||workflowid==0){
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
    RecordSet.executeSql(sql);
    if(RecordSet.next()){
        workflowid = RecordSet.getInt("workflowid");
    }
    if(workflowid==-1||workflowid==0){
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
    RecordSet.executeSql(sql);
    if(RecordSet.next()){
        workflowid = RecordSet.getInt("workflowid");
    }
    if(workflowid==-1||workflowid==0){
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

//修改客户登录账号的密码信息
if(method.equals("updatePassword")){
	String crmid = Util.null2String(request.getParameter("crmid"));//人员主键
	String passwordnew = Util.null2String(request.getParameter("passwordnew"));
	String sql = "UPDATE CRM_CustomerInfo SET PortalPassword = '"+passwordnew+"' WHERE id = "+crmid;
 	RecordSet.executeSql(sql);
}
%>
