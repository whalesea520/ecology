<%@page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="weaver.crm.card.CardManager"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="weaver.crm.CrmShareBase"%>
<%@page import="weaver.file.FileUpload"%>
<%@page import="java.util.UUID"%>
<%@page import="java.io.File"%>
<%@page import="com.weaver.formmodel.mobile.MobileFileUpload"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@page import="weaver.hrm.User"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="weaver.general.Util"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="weaver.crm.Maint.CustomerInfoComInfo"%>
<%
User user = MobileUserInit.getUser(request, response);
//此模版为：移动建模表单控件服务端业务处理的页面，仅供参考。
FileUpload fileUpload = new MobileFileUpload(request,"UTF-8",false);
out.clear();
String action=StringHelper.null2String(fileUpload.getParameter("action"));//需要在表单控件提交URL中传递action的值
if("savedata".equalsIgnoreCase(action)){
	JSONObject result = new JSONObject();
	try{
		Date newdate = new Date() ;
		long datetime = newdate.getTime() ;
		Timestamp timestamp = new Timestamp(datetime) ;
		String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
		
		String fullname = StringHelper.null2String(fileUpload.getParameter("fieldname_fullname"));
		String jobtitle = StringHelper.null2String(fileUpload.getParameter("fieldname_jobtitle"));
//		String textfield1 = StringHelper.null2String(fileUpload.getParameter("fieldname_textfield1"));
		String customerid = StringHelper.null2String(fileUpload.getParameter("fieldname_customerid"));
		String customername = StringHelper.null2String(fileUpload.getParameter("fieldname_customername"));
		String phoneoffice = StringHelper.null2String(fileUpload.getParameter("fieldname_phoneoffice"));
		String email = StringHelper.null2String(fileUpload.getParameter("fieldname_email"));
		RecordSet rs = new RecordSet();
		String sql = "";
		boolean dif = false;
		if(!"".equals(customerid)){
			CustomerInfoComInfo com = new CustomerInfoComInfo();
			String name = com.getCustomerInfoname(customerid);
			if(!customername.equals(name)){
				dif = true;
			}
		}
		
		
		//匹配到客户，则新增联系人。否则新建客户和联系人
		if("".equals(customerid)||dif){
			sql = " insert into crm_customerinfo (name,manager,createdate,deleted,status) values ('"+customername+"',"+user.getUID()+",'"+CurrentDate+"',0,2)";
			boolean bl = rs.executeSql(sql);
			if(bl){
				sql = " select max(id) as id from crm_customerinfo where manager="+user.getUID()+" and createdate='"+CurrentDate+"'";
				rs.executeSql(sql);
				if(rs.first())
					customerid=rs.getString("id");
				CrmShareBase crmShareBase = new CrmShareBase();
				crmShareBase.setDefaultShare(""+customerid);
				CustomerInfoComInfo customerInfoComInfo = new CustomerInfoComInfo();
				customerInfoComInfo.addCustomerInfoCache(customerid);
			}
		}
		sql = " insert into crm_customercontacter (customerid,fullname,firstname,jobtitle,phoneoffice,email,manager) values ('"+customerid+"','"+fullname+"','"+fullname+"','"+jobtitle+"','"+phoneoffice+"','"+email+"','"+user.getUID()+"')";
		rs.executeSql(sql);
		rs.executeSql("SELECT MAX(id) as id from CRM_CustomerContacter");
		if(rs.first()){
			String contacterId = rs.getString("id");
			result.put("contacterId",contacterId);
		}
		result.put("customerid",customerid);
		result.put("status", "1");
	}catch(Exception ex){
		new BaseBean().writeLog(ex.getMessage());
		result.put("status", "0");//失败
		String errMsg = "处理异常，请联系管理员";//错误信息
		result.put("errMsg", errMsg);
	}
	
	out.print(result.toString());
	
}else if("savecard".equalsIgnoreCase(action)){
	JSONObject result = new JSONObject();
	try{
		int status = 1;//  状态码：  0:失败     1:成功
		String errMsg = "您的请求未被服务端处理";
		
		boolean flag = true;
		//调用名片识别接口
		String card_front = StringHelper.null2String(fileUpload.getParameter("fieldname_img1"));//获取title字段的值
		String card_back = StringHelper.null2String(fileUpload.getParameter("fieldname_img2"));//获取title字段的值
		//String language = StringHelper.null2String(fileUpload.getParameter("fieldname_language"));//获取title字段的值
		CardManager card = new CardManager();
		String filePath = CardManager.TARGET_PATH+File.separatorChar+UUID.randomUUID()+".jpg";
		if(StringHelper.isNotEmpty(card_front)){
			flag = card.decodeBase64ToImage(card_front.substring(23,card_front.length()),filePath);
			JSONObject obj = card.cardRecognize(filePath);
			if("1".equals(obj.get("status"))){
				/**上传处理后的名片**/
				String frontid = card.uploadCard(new File(obj.getString("cardPath")));
				/**删除处理前的名片**/
				new File(filePath).delete();
				//根据frontid
				String cardInfo = obj.getString("cardInfo");
				
				if(!"".equals(frontid)){
					result.put("frontid",frontid);
				}
				result.put("cardInfo",cardInfo);
			}else{
				result.put("status","0");
				result.put("errMsg",errMsg);
				out.print(result.toString());
				return;
			}
			
			
		}else{
			flag = false;
			errMsg = "请上传名片正面";
		}
		if(StringHelper.isNotEmpty(card_back)){
			card.decodeBase64ToImage(card_back.substring(23,card_back.length()),filePath);
			card.cardRecognize(filePath);
			/**上传处理后的名片**/
			String backid = card.uploadCard(new File(filePath));
			//flag = new RecordSet().execute("update CRM_CustomerContacter set card_back = '"+backid+"' where customerid = '"+customerid +"'");
			//new File(filePath).delete();
			//new BaseBean().writeLog("customerid == "+customerid+"backid == "+backid+" && flag == "+flag);
			if(StringHelper.isNotEmpty(backid) ){
				if(!"".equals(backid)){
					result.put("backid",backid);
				}
				//flag = true;
				//new File(filePath).delete();
			}else{
				flag = false;
				errMsg = "名片反面识别失败";
			}
		}
		if(flag){
			status = 1;//业务执行成功，必须把此状态改为1
		}else{
			status = 0;//失败
		}
		//***********自定义业务逻辑代码区域，仅供参考***********
		result.put("status", status);//必须返回状态码
		if(status==0){//执行失败时，必须同时返回对应的错误信息
			result.put("errMsg", errMsg);
		}
	}catch(Exception ex){
		new BaseBean().writeLog(ex.getMessage());
		result.put("status", "0");//失败
		String errMsg = "处理异常，请联系管理员";//错误信息
		result.put("errMsg", errMsg);
	}
	
	out.print(result.toString());
	
}else if("queryCustomerByName".equalsIgnoreCase(action)){
	JSONObject result = new JSONObject();
	try{
		String name = StringHelper.null2String(fileUpload.getParameter("searchKey"));//客户名称
		RecordSet rs = new RecordSet();
		String id = "";
		CrmShareBase crmShareBase = new CrmShareBase();
		String userid = user.getUID()+"";
		rs.execute("select id from crm_customerinfo where name='"+name+"' and (deleted=0 or deleted is null) order by id desc");
		while(rs.next()){
			int sharelevel = crmShareBase.getRightLevelForCRM(userid,rs.getString("id"));
			if(sharelevel>0){
				id = rs.getString("id");
				break;
			}
		}
		result.put("datas",id);
		result.put("status","1");
	}catch(Exception ex){
		new BaseBean().writeLog(ex.getMessage());
		result.put("status", "0");//失败
		String errMsg = "处理异常，请联系管理员";//错误信息
		result.put("errMsg", errMsg);
	}
	out.print(result.toString());
}

out.flush();
out.close();
%>

