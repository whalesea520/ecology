/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._crm._data;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import java.util.*;
import weaver.hrm.*;
import weaver.systeminfo.*;
import weaver.general.StaticObj;
import weaver.general.Util;
import weaver.hrm.settings.RemindSettings;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import java.sql.Timestamp;
import weaver.file.FileUpload;
import java.io.*;

public class _customeroperation__jsp extends com.caucho.jsp.JavaPage
{
  private static final java.util.HashMap<String,java.lang.reflect.Method> _jsp_functionMap = new java.util.HashMap<String,java.lang.reflect.Method>();
  private boolean _caucho_isDead;
  
  public void
  _jspService(javax.servlet.http.HttpServletRequest request,
              javax.servlet.http.HttpServletResponse response)
    throws java.io.IOException, javax.servlet.ServletException
  {
    javax.servlet.http.HttpSession session = request.getSession(true);
    com.caucho.server.webapp.WebApp _jsp_application = _caucho_getApplication();
    javax.servlet.ServletContext application = _jsp_application;
    com.caucho.jsp.PageContextImpl pageContext = _jsp_application.getJspApplicationContext().allocatePageContext(this, _jsp_application, request, response, null, session, 8192, true, false);
    javax.servlet.jsp.PageContext _jsp_parentContext = pageContext;
    javax.servlet.jsp.JspWriter out = pageContext.getOut();
    final javax.el.ELContext _jsp_env = pageContext.getELContext();
    javax.servlet.ServletConfig config = getServletConfig();
    javax.servlet.Servlet page = this;
    response.setContentType("text/html; charset=UTF-8");
    request.setCharacterEncoding("UTF-8");
    try {
      out.write(_jsp_string0, 0, _jsp_string0.length);
      
	
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	

	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	Log logger= LogFactory.getLog(this.getClass());
	String isIE = (String)session.getAttribute("browser_isie");

      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.general.Util Util;
      Util = (weaver.general.Util) pageContext.getAttribute("Util");
      if (Util == null) {
        Util = new weaver.general.Util();
        pageContext.setAttribute("Util", Util);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      weaver.conn.RecordSet rs;
      rs = (weaver.conn.RecordSet) pageContext.getAttribute("rs");
      if (rs == null) {
        rs = new weaver.conn.RecordSet();
        pageContext.setAttribute("rs", rs);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      weaver.conn.RecordSet RecordSet;
      RecordSet = (weaver.conn.RecordSet) pageContext.getAttribute("RecordSet");
      if (RecordSet == null) {
        RecordSet = new weaver.conn.RecordSet();
        pageContext.setAttribute("RecordSet", RecordSet);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      weaver.conn.RecordSet RecordSetT;
      RecordSetT = (weaver.conn.RecordSet) pageContext.getAttribute("RecordSetT");
      if (RecordSetT == null) {
        RecordSetT = new weaver.conn.RecordSet();
        pageContext.setAttribute("RecordSetT", RecordSetT);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      weaver.conn.RecordSet RecordSetAD;
      RecordSetAD = (weaver.conn.RecordSet) pageContext.getAttribute("RecordSetAD");
      if (RecordSetAD == null) {
        RecordSetAD = new weaver.conn.RecordSet();
        pageContext.setAttribute("RecordSetAD", RecordSetAD);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      weaver.crm.Maint.CustomerInfoComInfo CustomerInfoComInfo;
      CustomerInfoComInfo = (weaver.crm.Maint.CustomerInfoComInfo) pageContext.getAttribute("CustomerInfoComInfo");
      if (CustomerInfoComInfo == null) {
        CustomerInfoComInfo = new weaver.crm.Maint.CustomerInfoComInfo();
        pageContext.setAttribute("CustomerInfoComInfo", CustomerInfoComInfo);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      weaver.system.SysRemindWorkflow SysRemindWorkflow;
      SysRemindWorkflow = (weaver.system.SysRemindWorkflow) pageContext.getAttribute("SysRemindWorkflow");
      if (SysRemindWorkflow == null) {
        SysRemindWorkflow = new weaver.system.SysRemindWorkflow();
        pageContext.setAttribute("SysRemindWorkflow", SysRemindWorkflow);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      weaver.hrm.resource.ResourceComInfo ResourceComInfo;
      ResourceComInfo = (weaver.hrm.resource.ResourceComInfo) pageContext.getAttribute("ResourceComInfo");
      if (ResourceComInfo == null) {
        ResourceComInfo = new weaver.hrm.resource.ResourceComInfo();
        pageContext.setAttribute("ResourceComInfo", ResourceComInfo);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      weaver.hrm.city.CityComInfo CityComInfo;
      CityComInfo = (weaver.hrm.city.CityComInfo) pageContext.getAttribute("CityComInfo");
      if (CityComInfo == null) {
        CityComInfo = new weaver.hrm.city.CityComInfo();
        pageContext.setAttribute("CityComInfo", CityComInfo);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      weaver.crm.data.CustomerModifyLog CustomerModifyLog;
      CustomerModifyLog = (weaver.crm.data.CustomerModifyLog) pageContext.getAttribute("CustomerModifyLog");
      if (CustomerModifyLog == null) {
        CustomerModifyLog = new weaver.crm.data.CustomerModifyLog();
        pageContext.setAttribute("CustomerModifyLog", CustomerModifyLog);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      weaver.crm.customermap.BaiduMapUtil BaiduMapUtil;
      BaiduMapUtil = (weaver.crm.customermap.BaiduMapUtil) pageContext.getAttribute("BaiduMapUtil");
      if (BaiduMapUtil == null) {
        BaiduMapUtil = new weaver.crm.customermap.BaiduMapUtil();
        pageContext.setAttribute("BaiduMapUtil", BaiduMapUtil);
      }
      out.write(_jsp_string3, 0, _jsp_string3.length);
      weaver.workflow.request.ApproveCustomerParameter ApproveCustomerParameter;
      synchronized (pageContext.getSession()) {
        ApproveCustomerParameter = (weaver.workflow.request.ApproveCustomerParameter) pageContext.getSession().getAttribute("ApproveCustomerParameter");
        if (ApproveCustomerParameter == null) {
          ApproveCustomerParameter = new weaver.workflow.request.ApproveCustomerParameter();
          pageContext.getSession().setAttribute("ApproveCustomerParameter", ApproveCustomerParameter);
        }
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      weaver.crm.CrmShareBase CrmShareBase;
      CrmShareBase = (weaver.crm.CrmShareBase) pageContext.getAttribute("CrmShareBase");
      if (CrmShareBase == null) {
        CrmShareBase = new weaver.crm.CrmShareBase();
        pageContext.setAttribute("CrmShareBase", CrmShareBase);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      

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
String approvedesc = Util.null2String(fu.getParameter("approvedesc")); //\u5ba2\u6237\u5ba1\u6279\u63cf\u8ff0
String requestid = Util.null2String(fu.getParameter("requestid")); //\u5ba2\u6237\u5ba1\u6279\u63cf\u8ff0

String Remark=Util.fromScreen3(fu.getParameter("Remark"),user.getLanguage());
String RemarkDoc=Util.fromScreen3(fu.getParameter("RemarkDoc"),user.getLanguage());
String Status=Util.fromScreen3(fu.getParameter("Status"),user.getLanguage());
String PortalStatus=Util.fromScreen3(fu.getParameter("PortalStatus"),user.getLanguage());

CustomerID = Util.null2String(fu.getParameter("CustomerID"));

if(method.equals("delete"))// \u79c1\u4eba\u7528\u6237\u548c\u4f01\u4e1a\u7528\u6237\u5171\u7528\u8be5\u65b9\u6cd5
{
	/*\u6743\u9650\u5224\u65ad\uff0d\uff0dBegin*/
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
	/*\u6743\u9650\u5224\u65ad\uff0d\uff0dEnd*/
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

//\u90e8\u95e8\u7531\u4eba\u529b\u8d44\u6e90\u8868\u4e2d\u9009\u51fa\u8be5\u7ecf\u7406\u7684\u90e8\u95e8
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
	
	//\u67e5\u51fa\u6240\u6709\u975e\u8054\u7cfb\u4eba\u7684\u5b57\u6bb5\u4fe1\u606f
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
		 if(RecordSet.getInt("fieldhtmltype")== 1 && RecordSet.getInt("type")== 3){//\u6d6e\u70b9\u6570
			 fieldValue = fieldValue.equals("")?"0":fieldValue;
		 }
		
		 if(fieldName.equals("website") && !fieldValue.equals("")){
		 	if(fieldValue.indexOf(":")==-1){
		 		fieldValue="http://"+fieldValue.trim();
			}else{
				fieldValue=Util.StringReplace(fieldValue,"\\","/");
			}
		 }
		 if(fieldName.equals("status") && fieldValue.equals("")){//\u5982\u679c\u6ca1\u6709\u8bbe\u5b9a\u5ba2\u6237\u7c7b\u578b\uff0c\u9ed8\u8ba4\u4e3a\u65e0\u6548\u5ba2\u6237
			 fieldValue = "1";
		 }
		 if(fieldName.equals("language") ){//\u5982\u679c\u6ca1\u6709\u8bbe\u5b9a\u8bed\u8a00\u5219\u9ed8\u8ba4\u8bbe\u7f6e\u4e3a\u4e2d\u6587
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
		
		//\u83b7\u53d6\u63d0\u9192\u914d\u7f6e
		RecordSet.executeSql("select * from crm_customerSettings where id=-1");
		RecordSet.first();
		String CRM_addRemind=Util.null2String(RecordSet.getString("crm_rmd_create"));//\u662f\u5426\u5f00\u542f\u521b\u5efa\u5ba2\u6237\u63d0\u9192\u3002             Y\uff1a\u5f00\u542f\uff0c    N\uff1a\u5173\u95ed
    	String CRM_addRemindTo=Util.null2String(RecordSet.getString("crm_rmd_create2"));//\u521b\u5efa\u5ba2\u6237\u63d0\u9192\u5bf9\u8c61\u3002            1\uff1a\u76f4\u63a5\u4e0a\u7ea7\uff0c2\uff1a\u6240\u6709\u4e0a\u7ea7
		if("Y".equals(CRM_addRemind)){
			//\u901a\u77e5\u5ba2\u6237\u63d0\u9192\u5bf9\u8c61
			String operators = ResourceComInfo.getManagerID(fu.getParameter("manager"));//\u9ed8\u8ba4\u63d0\u9192\u76f4\u63a5\u4e0a\u7ea7
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
				
				//\u7cfb\u7edf\u89e6\u53d1\u6d41\u7a0b\u4f1a\u7ed9\u5ba2\u6237\u7ecf\u7406\u7684\u7ecf\u7406\u4e00\u4e2a\u5bf9\u8be5\u5ba2\u6237\u7684\u67e5\u770b\u6743\u9650\uff0c\u4e0e\u4e0b\u9762\u7684CrmShareBase.setDefaultShare(""+CustomerID);\u91cd\u590d\u3002
				RecordSet.executeSql("delete from CRM_shareinfo where relateditemid="+CustomerID);
		    }
		}

		
		
	    String Manager=Util.null2String(fu.getParameter("manager"),user.getUID()+"");
        CustomerModifyLog.modify(CustomerID,user.getUID()+"",Manager);

		
		//\u5728\u65b0\u7684\u65b9\u5f0f\u4e0b\u6dfb\u52a0\u5ba2\u6237\u9ed8\u8ba4\u5171\u4eab\uff0c\u65b0\u5efa\u5ba2\u6237\u9ed8\u8ba4\u5171\u4eab\u7ed9\u5ba2\u6237\u7ecf\u7406\u53ca\u6240\u6709\u4e0a\u7ea7\uff0c\u5ba2\u6237\u7ba1\u7406\u5458\u89d2\u8272\u3002
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

		
		//\u67e5\u627e\u51fa\u8054\u7cfb\u4eba\u4fe1\u606f
		sql = "select fieldhtmltype ,type,fieldname from CRM_CustomerDefinField "+
		" where usetable = 'CRM_CustomerInfo' and isopen = 1 and groupid =4 ";
		RecordSet.execute(sql);
		if(0 == RecordSet.getCounts()){
			out.println("<script>parent.location.href='/CRM/data/ViewCustomer.jsp?addshow=1&log=n&CustomerID="+CustomerID+"';</script>");
			return;
		}
		
		if(!fu.getParameter("firstname").trim().equals("")){//\u8054\u7cfb\u4eba\u59d3\u540d\u4e3a\u7a7a\u5219\u4e0d\u4fdd\u5b58\u8054\u7cfb\u4eba\u4fe1\u606f
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

		RecordSet.executeProc("CRM_ContactLog_Insert",ProcPara);//\u5ba2\u6237\u8054\u7cfb\u4fe1\u606f
		
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
	           //\u67e5\u8be2\u5750\u6807
	           Map<String,String> map = BaiduMapUtil.getCoordinateByAddress(address1);
	           if(map.size()==2){
	               String lng = map.get("lng");
	               String lat = map.get("lat");
	               
	               adrsParmSql += ",lng1='"+lng+"'";
	               adrsParmSql += ",lat1='"+lat+"'";
	           }
	        }
	        if(!"".equals(address2)){
	            //\u67e5\u8be2\u5750\u6807
	            Map<String,String> map = BaiduMapUtil.getCoordinateByAddress(address2);
	            if(map.size()==2){
	                String lng = map.get("lng");
	                String lat = map.get("lat");
	                
	                adrsParmSql += ",lng2='"+lng+"'";
	                adrsParmSql += ",lat2='"+lat+"'";
	            }
	        }
	        if(!"".equals(address3)){
	            //\u67e5\u8be2\u5750\u6807
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
	
	//\u6dfb\u52a0\u5ba2\u6237\u65f6\uff0c\u5982\u679c\u4e2d\u4ecb\u673a\u6784\u4e0d\u4e3a\u7a7a\uff0c\u5219\u7ed9CRM_ShareInfo\u4e2d\u52a0\u5165\u76f8\u5e94\u6743\u9650        \u5f00\u59cb
	String agent = Util.null2String(fu.getParameter("agent"));
	if(!"".equals(agent)){
		String agentSql = "insert into CRM_ShareInfo (relateditemid,sharetype,sharelevel,crmid,contents,deleted) values ('"+CustomerID+"',9,1,0,'"+agent+"',0)";
		RecordSet.executeSql(agentSql);
	}
	//\u6dfb\u52a0\u5ba2\u6237\u65f6\uff0c\u5982\u679c\u4e2d\u4ecb\u673a\u6784\u4e0d\u4e3a\u7a7a\uff0c\u5219\u7ed9CRM_ShareInfo\u4e2d\u52a0\u5165\u76f8\u5e94\u6743\u9650        \u5f00\u59cb
	
	out.println("<script>parent.location.href='/CRM/data/ViewCustomer.jsp?addshow=1&log=n&CustomerID="+CustomerID+"';</script>");
	return;
}


      out.write(_jsp_string2, 0, _jsp_string2.length);
      
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



    //\u63d0\u9192\u5ba2\u6237\u7ecf\u7406\uff0c\u4ee5\u53ca\u5176\u7ecf\u7406
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

	if(PortalStatus.equals("2")){//\u6279\u51c6\u5f00\u653e\u5ba2\u6237\u95e8\u6237\uff0c\u5ba2\u6237\u53ef\u901a\u8fc7\u767b\u5f55OA\u6839\u636e\u6743\u9650\u521b\u5efa\u6d41\u7a0b
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

//2005-04-28 Modify by guosheng for TD1709 CRM\u7f13\u5b58\u91c7\u7528\u65b0\u65b9\u5f0f\u7684addCustomerInfoCache\u7c7b\u578b\u53d8\u4e86\u9700\u8981\u91cd\u65b0\u7f16\u8bd1\u672cjsp\u6240\u6709\u5728\u8fd9\u8fb9\u52a0\u4e2a\u6ca1\u6709\u4efb\u4f55\u529f\u80fd\u4e0a\u6539\u52a8\u7684\u7248\u672c\u4ee5\u8ba9resin \u91cd\u65b0\u7f16\u8bd1

//\u4fee\u6539\u5ba2\u6237\u767b\u5f55\u8d26\u53f7\u7684\u5bc6\u7801\u4fe1\u606f
if(method.equals("updatePassword")){
	String crmid = Util.null2String(request.getParameter("crmid"));//\u4eba\u5458\u4e3b\u952e
	String passwordnew = Util.null2String(request.getParameter("passwordnew"));
	String sql = "UPDATE CRM_CustomerInfo SET PortalPassword = '"+passwordnew+"' WHERE id = "+crmid;
 	RecordSet.executeSql(sql);
}

      out.write(_jsp_string2, 0, _jsp_string2.length);
    } catch (java.lang.Throwable _jsp_e) {
      pageContext.handlePageException(_jsp_e);
    } finally {
      _jsp_application.getJspApplicationContext().freePageContext(pageContext);
    }
  }

  private java.util.ArrayList _caucho_depends = new java.util.ArrayList();

  public java.util.ArrayList _caucho_getDependList()
  {
    return _caucho_depends;
  }

  public void _caucho_addDepend(com.caucho.vfs.PersistentDependency depend)
  {
    super._caucho_addDepend(depend);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  public boolean _caucho_isModified()
  {
    if (_caucho_isDead)
      return true;
    if (com.caucho.server.util.CauchoSystem.getVersionId() != 1886798272571451039L)
      return true;
    for (int i = _caucho_depends.size() - 1; i >= 0; i--) {
      com.caucho.vfs.Dependency depend;
      depend = (com.caucho.vfs.Dependency) _caucho_depends.get(i);
      if (depend.isModified())
        return true;
    }
    return false;
  }

  public long _caucho_lastModified()
  {
    return 0;
  }

  public java.util.HashMap<String,java.lang.reflect.Method> _caucho_getFunctionMap()
  {
    return _jsp_functionMap;
  }

  public void init(ServletConfig config)
    throws ServletException
  {
    com.caucho.server.webapp.WebApp webApp
      = (com.caucho.server.webapp.WebApp) config.getServletContext();
    super.init(config);
    com.caucho.jsp.TaglibManager manager = webApp.getJspApplicationContext().getTaglibManager();
    com.caucho.jsp.PageContextImpl pageContext = new com.caucho.jsp.PageContextImpl(webApp, this);
  }

  public void destroy()
  {
      _caucho_isDead = true;
      super.destroy();
  }

  public void init(com.caucho.vfs.Path appDir)
    throws javax.servlet.ServletException
  {
    com.caucho.vfs.Path resinHome = com.caucho.server.util.CauchoSystem.getResinHome();
    com.caucho.vfs.MergePath mergePath = new com.caucho.vfs.MergePath();
    mergePath.addMergePath(appDir);
    mergePath.addMergePath(resinHome);
    com.caucho.loader.DynamicClassLoader loader;
    loader = (com.caucho.loader.DynamicClassLoader) getClass().getClassLoader();
    String resourcePath = loader.getResourcePathSpecificFirst();
    mergePath.addClassPath(resourcePath);
    com.caucho.vfs.Depend depend;
    depend = new com.caucho.vfs.Depend(appDir.lookup("CRM/data/CustomerOperation.jsp"), 8698013971587828197L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("page/maint/common/initNoCache.jsp"), 3270256153856711871L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  private final static char []_jsp_string2;
  private final static char []_jsp_string3;
  static {
    _jsp_string0 = "\r\n \r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string2 = "\r\n".toCharArray();
    _jsp_string3 = "\r\n\r\n".toCharArray();
  }
}
