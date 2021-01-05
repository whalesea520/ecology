<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="net.sf.json.*"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@	page import="weaver.hrm.settings.RemindSettings"%>
<%@	page import="weaver.hrm.settings.BirthdayReminder"%>
<%@	page import="weaver.conn.RecordSet"%>
<%@	page import="java.net.URLDecoder"%>
<%@	page import="weaver.login.CheckIpNetWork"%>
<%@	page import="weaver.login.VerifyLogin"%>
<%@	page import="weaver.hrm.settings.HrmSettingsComInfo"%>
<%@page import="weaver.general.GCONST"%>
<jsp:useBean id="LoginUtil" class="weaver.login.LoginUtil" scope="page" />

<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
Map<String,String> result = new HashMap<String,String>();

String requestMethod = Util.null2String(request.getMethod());
if(requestMethod.equalsIgnoreCase("GET")){
	result.put("status","非法登录方式");
	JSONObject jo = JSONObject.fromObject(result);
	out.print(jo.toString());
	return;
}

RemindSettings settings=(RemindSettings)application.getAttribute("hrmsettings");
if(settings==null){
  BirthdayReminder birth_reminder = new BirthdayReminder();
  settings=birth_reminder.getRemindSettings();
  if(settings==null){
      out.println("Cann't create connetion to database,please check your database.");
      return;
  }
  application.setAttribute("hrmsettings",settings);
}

String type = Util.null2String(request.getParameter("type"));

if(type.equals("checklogin")){
	String[] usercheck = LoginUtil.checkLogin(application,request,response);
	RecordSet rs = new RecordSet();
	String loginid = Util.null2String(request.getParameter("loginid"));
	//String sql = "select sumpasswordwrong from hrmresource where loginid='"+loginid+"'";
	rs.executeQuery("select sumpasswordwrong from hrmresource where loginid= ? ",loginid);
   if(rs.next()){
   	usercheck[3]=""+Util.getIntValue(rs.getString(1));
   }else{
   	usercheck[3]="0";
   }
	result.put("loginstatus",usercheck[0]);
	result.put("msgcode",usercheck[1]);
	result.put("msg",usercheck[2]);
	result.put("sumpasswordwrong",usercheck[3]);
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo.toString());
}else if(type.equals("logout")){
	LoginUtil.checkLogout(application,request,response);
}else if(type.equals("hrmsetting")){
	int needvalidate=settings.getNeedvalidate();	//启用验证码  1 ：是 0：否
	int numvalidatewrong=settings.getNumvalidatewrong();	//输入密码错误几次后出现验证码
	int validatetype=settings.getValidatetype();
	int showDynamicPwd = settings.getNeeddynapass();	//启用动态密码  1 ：是 0：否
	int isMulti = 0;
	int enLanguage = GCONST.getENLANGUAGE();
	int twLanguage = GCONST.getZHTWLANGUAGE();
	if(enLanguage==0 && twLanguage==0) {
		isMulti = 0;
	} else {
		isMulti = 1;
	}
	result.put("multilang",""+isMulti);
	result.put("needvalidate",""+needvalidate);
	result.put("numvalidatewrong",""+numvalidatewrong);
	result.put("validatetype",""+validatetype);
	result.put("showDynamicPwd",""+showDynamicPwd);
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo.toString());
}else if("checkTokenKey".equals(type)){
	String loginid=URLDecoder.decode(request.getParameter("loginid"),"utf-8"); 
	RecordSet recordSet = new RecordSet();
	recordSet.executeQuery("select sumpasswordwrong from hrmresource where loginid=? ",loginid);
	if(recordSet.next()){
		result.put("sumpasswordwrong",""+Util.getIntValue(recordSet.getString(1)));
	}else{
		result.put("sumpasswordwrong","0");
	}
	
	String tableName = "hrmresource";
	//recordSet.executeSql("select id from HrmResourcemanager where loginid='"+loginid+"'");
	recordSet.executeQuery("select id from HrmResourcemanager where loginid= ? ",loginid);
	if(recordSet.next()){
		tableName = "HrmResourcemanager";
	}
	String sysNeedusb=Util.null2String(settings.getNeedusb());
	String needusbHt=Util.null2String(settings.getNeedusbHt());
	String needusbDt=Util.null2String(settings.getNeedusbDt());
	sysNeedusb = (needusbHt.equals("1") || needusbDt.equals("1")) ? "1" : "0";
	String usbType =Util.null2String(settings.getUsbType());
	String userNeedusb="0";
	String userUsbType="";
	String tokenkey="";
	String usbstate = "";
	String id="0";
	if("HrmResourcemanager".equals(tableName)){
		//recordSet.executeSql("select id,userUsbType,tokenkey,usbstate from HrmResourcemanager where loginid='"+loginid+"'");
		recordSet.executeQuery("select id,userUsbType,tokenkey,usbstate from HrmResourcemanager where loginid= ? ",loginid);
		if(recordSet.next()){
			id=recordSet.getString("id");
		    userUsbType=recordSet.getString("userUsbType");
		    tokenkey=recordSet.getString("tokenkey");
			usbstate = recordSet.getString("usbstate");
		}   
	}else{
		//recordSet.executeSql("select id,needusb,userUsbType,tokenkey,usbstate from hrmresource where loginid='"+loginid+"'");
		recordSet.executeQuery("select id,needusb,userUsbType,tokenkey,usbstate from hrmresource where loginid= ? ",loginid);
		if(recordSet.next()){
			id=recordSet.getString("id");
		    userNeedusb=recordSet.getString("needusb");
		    userUsbType=recordSet.getString("userUsbType");
		    tokenkey=recordSet.getString("tokenkey");
			usbstate = recordSet.getString("usbstate");
		}   
	}
	
	if(userUsbType.equals(""))
		userUsbType=usbType;    
	
	/**检测是否启用usb网段策略开始**/
	CheckIpNetWork checkipnetwork = new CheckIpNetWork();
	String clientIP = request.getRemoteAddr();
	boolean checktmp = checkipnetwork.checkIpSeg(clientIP);//true表示在网段之外,false表示在网段之内
	/**检测是否启用usb网段策略结束**/
	if(sysNeedusb.equals("1")&&(userNeedusb.equals("1")||"HrmResourcemanager".equals(tableName)) && (usbstate.equals("0") || (usbstate.equals("2")&&checktmp))){
		VerifyLogin verifylogin = new VerifyLogin();
	 		boolean isNeedIp = true;
		HrmSettingsComInfo sci = new HrmSettingsComInfo();
	 		int forbidLogin = Util.getIntValue(sci.getForbidLogin(), 0);
	 		if(forbidLogin == 0){
	 			isNeedIp = false;
	 			if(usbstate.equals("2")&&!checktmp) isNeedIp = true;
	 		}else{
	 			isNeedIp = verifylogin.checkIpSegByForbidLogin(request, loginid);
	 		}
		//动态令牌 网段策略-->网段内不需弹出
		if(isNeedIp){
			result.put("status","0");
			JSONObject jo = JSONObject.fromObject(result);
			out.print(jo.toString());
		}else{
			if(userUsbType.equals("3") ){
				//String sql="select * from tokenJscx WHERE tokenKey='"+tokenkey+"'";
				String sql="select * from tokenJscx WHERE tokenKey= ? ";
				recordSet.executeQuery(sql, tokenkey);
				if(tokenkey.equals("")||!recordSet.next()){ //令牌未绑定或者未初始化
					result.put("status","0");
					JSONObject jo = JSONObject.fromObject(result);
					out.print(jo.toString());
				}else{
					result.put("status",userUsbType);
					JSONObject jo = JSONObject.fromObject(result);
					out.print(jo.toString());
				}
			}else{
				result.put("status",userUsbType);
				JSONObject jo = JSONObject.fromObject(result);
				out.print(jo.toString());
			}
		}
	}else{
		result.put("status","0");
		JSONObject jo = JSONObject.fromObject(result);
		out.print(jo.toString());
	}
}else if("checkIsBind".equals(type)){
	String userid=Util.null2String(request.getParameter("userid"));
	String requestFrom=Util.null2String(request.getParameter("requestFrom"));
	String loginid=Util.null2String(request.getParameter("loginid"));
	String tokenKey=Util.null2String(request.getParameter("tokenKey"));
	
	String sysNeedusb=Util.null2String(settings.getNeedusb());
	String needusbHt=Util.null2String(settings.getNeedusbHt());
	String needusbDt=Util.null2String(settings.getNeedusbDt());
	sysNeedusb = (needusbHt.equals("1") || needusbDt.equals("1")) ? "1" : "0";
	String usbType =Util.null2String(settings.getUsbType());
	String userNeedusb="0";
	String userUsbType="";
	String tempUserid="0";
	if(sysNeedusb.equals("1")){
	RecordSet recordSet=new RecordSet();
	if(!requestFrom.equals("system")){ //检查用户是否启用usbkey
		//recordSet.execute("select id,loginid,needusb,userUsbType from hrmresource WHERE loginid='"+loginid+"'");
		recordSet.executeQuery("select id,loginid,needusb,userUsbType from hrmresource WHERE loginid= ? ",loginid);	
		if(recordSet.next()){
			userNeedusb=Util.null2String(recordSet.getString("needusb"));
			userUsbType=Util.null2String(recordSet.getString("userUsbType"));
		}
	}else{
		userNeedusb="1";
		userUsbType="3";
	}
	if(userNeedusb.equals("1")&&userUsbType.equals("3")){
	//检查令牌是否已经绑定过
	boolean isBind=false; //是否绑定过
	String stauts="";     //被绑定人状态
	String tempLoginid="";//被绑定人id
	//String sql="select * from tokenJscx  WHERE tokenKey='"+tokenKey+"'";
	String sql="select * from tokenJscx  WHERE tokenKey= ? ";
	recordSet.executeQuery(sql,tokenKey);
	if(recordSet.next()){
		isBind=true;
		//查询当前串号被绑定的用户
		sql="select id,loginid,needusb,status from hrmresource where tokenKey=? ";
		recordSet.executeQuery(sql,tokenKey);
		if(recordSet.next()){
			tempUserid=recordSet.getString("id");
			stauts=recordSet.getString("status");
			tempLoginid=recordSet.getString("loginid");
		}
	}
	if(requestFrom.equals("system")){
	  sql="select id,loginid,needusb,status,tokenKey from hrmresource WHERE id=?"; //检查当前用户是否已经绑定过
	  recordSet.executeQuery(sql,userid);
	}else{
		sql="select id,loginid,needusb,status,tokenKey from hrmresource WHERE loginid=?"; //检查当前用户是否已经绑定过
		recordSet.executeQuery(sql,loginid);
	}	
	
	String bindTokenkey=Util.null2String(recordSet.getString("tokenKey"));
	
	if(isBind){
		if((!requestFrom.equals("system")&&loginid.equals(tempLoginid))||(requestFrom.equals("system")&&userid.equals(tempUserid))){
			result.put("status","0");//被绑定人和当前用户是同一个人
			JSONObject jo = JSONObject.fromObject(result);
			out.print(jo.toString());
		}else{
			if(stauts.equals("0")||stauts.equals("1")||stauts.equals("2")||stauts.equals("3")){
				result.put("status","1"); //被绑定的用户属于正常状态用户,不能再绑定给其他用户
				JSONObject jo = JSONObject.fromObject(result);
				out.print(jo.toString());
			}else{
				if(!bindTokenkey.equals("")){
					result.put("status","5");//当前用户已经绑定过，但需要提醒用户确认令牌串号
					JSONObject jo = JSONObject.fromObject(result);
					out.print(jo.toString());
				}else{
					result.put("status","2");//令牌已经被激活，更改用户需要验证令牌口令
					JSONObject jo = JSONObject.fromObject(result);
					out.print(jo.toString());
				}
			}
		}
	}else{
	      if(bindTokenkey.equals(tokenKey)){
	      	result.put("status","7"); //令牌已经绑定给用户但还未初始化
	      	JSONObject jo = JSONObject.fromObject(result);
	      	out.print(jo.toString());
	      }else if(bindTokenkey.equals("")){
	      	result.put("status","3"); //当前令牌还未绑定过
	      	JSONObject jo = JSONObject.fromObject(result);
	      	out.print(jo.toString());
	      }else{
	      	result.put("status","4"); //当前用户已经绑定过，但需要提醒用户确认令牌串号
	      	JSONObject jo = JSONObject.fromObject(result);
	      	out.print(jo.toString());
	      }
	}
	}else{
		result.put("status","6"); //用户未启用usbkey验证，则不需要进行绑定
		JSONObject jo = JSONObject.fromObject(result);
		out.print(jo.toString());
	}}else{ 
		result.put("status","6"); //系统未启用usbkey验证，则不需要进行绑定
		JSONObject jo = JSONObject.fromObject(result);
		out.print(jo.toString());
	}
}else if("checkIsUsed".equals(type)){ //检查令牌是否绑定给其他用户
 String tokenKey=Util.null2String(request.getParameter("tokenKey"));
 String userid=Util.null2String(request.getParameter("userid"));
 String sql="select id,lastname from hrmresource where id <>? and tokenkey=? and status in(0,1,2,3)";
 RecordSet recordSet=new RecordSet();
 recordSet.executeQuery(sql,userid,tokenKey);
 if(recordSet.next()){  //令牌已经被使用
	String lastname=recordSet.getString("lastname");
  result.put("status","1");
  result.put("lastname",lastname);
 	JSONObject jo = JSONObject.fromObject(result);
	out.print(jo.toString());
 }else{
	 result.put("status","0");
	 result.put("lastname","");
	 JSONObject jo = JSONObject.fromObject(result);
	out.print(jo.toString());
 }
}
%>