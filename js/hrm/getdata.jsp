<%@page import="weaver.hrm.passwordprotection.dao.HrmResourceDao"%>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="weaver.common.StringUtil"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.hrm.passwordprotection.domain.HrmResource"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.passwordprotection.manager.HrmPasswordProtectionSetManager"%>
<%@page import="weaver.hrm.passwordprotection.manager.HrmResourceManager"%>
<%@page import="weaver.hrm.passwordprotection.manager.HrmResourceManagerManager"%>
<%@page import="weaver.hrm.common.Constants"%>
<%@page import="weaver.common.MessageUtil"%>
<%@page import="weaver.hrm.passwordprotection.domain.HrmPasswordProtectionQuestion"%>
<%@page import="weaver.hrm.passwordprotection.manager.HrmPasswordProtectionQuestionManager"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="weaver.common.DateUtil"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.common.Tools"%>
<%@page import="weaver.hrm.common.AjaxManager"%>
<%@page import="ln.LN"%>
<%@page import="java.util.List"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONException"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.file.Prop"%>
<%@page import="weaver.general.GCONST"%>
<%@page import="weaver.ldap.LdapUtil"%>
<%@page import="java.util.Random"%>

<%@page import="java.util.Calendar"%>


<%!
public static boolean ifEqlTarget(String val, String target) {
	if(val == null || val.equals("")) {
		return false;
	}
	if(!val.equals(target)) {
		return false;
	}
	return true;
}

private static String checkLoginIdMsg(String id, String resourceid, boolean needJson,String type,int languageid){
		RecordSet RS = new RecordSet();
		StringBuffer sql = new StringBuffer("select id,lastname,loginid,{fEmail},mobile,(select COUNT(id) from hrm_protection_question where user_id = {tName}.id and delflag = 0) as qCount from {tName} where loginid = ? ");
		//.append(StringUtil.vString(id)).append("' ");
		if(StringUtil.isNotNull(resourceid)){
			sql.append(" and id != ? ");
			//.append(resourceid);
		}
		String message = "";
		String _sql = StringUtil.replace(sql.toString(), "{fEmail}", "email");
		_sql = StringUtil.replace(_sql, "{tName}", "HrmResource");
		String needJsonSql = (needJson ? " and (accounttype = 0 or accounttype is null) " : "");
		_sql += needJsonSql;
		if(StringUtil.isNotNull(resourceid)){
			RS.executeQuery(_sql,StringUtil.vString(id),resourceid);
		}else{
			RS.executeQuery(_sql,StringUtil.vString(id));
		}
		StringBuffer result = new StringBuffer();
		HrmResource resource = new HrmResource();
		int qCount = 0;
		if(RS.next()){
			resource.setId(RS.getInt(1));
			resource.setLastname(StringUtil.vString(RS.getString(2)));
			resource.setLoginid(StringUtil.vString(RS.getString(3)));
			resource.setEmail(StringUtil.vString(RS.getString(4)));
			resource.setMobile(StringUtil.vString(RS.getString(5)));
			qCount = RS.getInt("qCount");
		}
		if(resource.getId().intValue() == 0){
			_sql = StringUtil.replace(sql.toString(), "{fEmail}", "'' as email");
			_sql = StringUtil.replace(_sql, "{tName}", "HrmResourceManager");
			
			if(StringUtil.isNotNull(resourceid)){
				RS.executeQuery(_sql,StringUtil.vString(id),resourceid);
			}else{
				RS.executeQuery(_sql,StringUtil.vString(id));
			}
			if(RS.next()){
				resource.setId(RS.getInt(1));
				resource.setLastname(StringUtil.vString(RS.getString(2)));
				resource.setLoginid(StringUtil.vString(RS.getString(3)));
				resource.setEmail(StringUtil.vString(RS.getString(4)));
				resource.setMobile(StringUtil.vString(RS.getString(5)));
				qCount = RS.getInt("qCount");
			}
		}
		int rid = Util.getIntValue(resource.getId()+"",0);
		int typeid = Util.getIntValue(type,0);
		String email = StringUtil.vString(resource.getEmail());
		String mobile = StringUtil.vString(resource.getMobile());
		
		String ret = "0";
		String mode=Prop.getPropValue(GCONST.getConfigFile() , "authentic");
		if(mode.equals("ldap")){
			RecordSet rs = new RecordSet();
			//rs.executeSql("select isADAccount from hrmresource where id="+rid);
			rs.executeQuery("select isADAccount from hrmresource where id= ? ",rid);
			if(rs.next() &&  "1".equals(Util.null2String(rs.getString("isADAccount")))){
				ret = "1";
			}
		} 
	if(!ret.equals("1")){
		if(rid == 0){
			message = SystemEnv.getHtmlLabelName(127829, languageid);
		} else {
			if(typeid == 0 && mobile == ""){
				message = SystemEnv.getHtmlLabelName(81618, languageid);
			}else if(typeid == 1 && qCount == 0){
				message = SystemEnv.getHtmlLabelName(125970, languageid);
			}else if(typeid == 2 && email == ""){
				message = SystemEnv.getHtmlLabelName(125971, languageid);
			}
		}
	}else{
		//QC273665  Ldap用户支持忘记密码功能 START  对输入用户名后onblur事件的改造，AD账号，可以修改密码  
		RecordSet rs = new RecordSet();
	    String retsql = "select l.needSynPassword,l.isuseldap from ldapset l";
	    rs.executeSql(retsql);
	    String istrue = "";
	   // String isuseldap = "";
	    if(rs.next()){
	        istrue = Util.null2String(rs.getString("needSynPassword"));
	        //isuseldap = Util.null2String(rs.getString("isuseldap"));
	    }
		if(!("".equals(istrue)||null==istrue)){	       	
			LdapUtil ldap = LdapUtil.getInstance();
			String certificate = ldap.judgeAdCertificate();//验证证书是否可用
			if(certificate.indexOf("ok") > -1){			
				if(typeid == 0 && mobile == ""){
					message = SystemEnv.getHtmlLabelName(81618, languageid);
				}else if(typeid == 1 && qCount == 0){
					message = SystemEnv.getHtmlLabelName(125970, languageid);
				}else if(typeid == 2 && email == ""){
					message = SystemEnv.getHtmlLabelName(125971, languageid);
				}
			}else{
				message = SystemEnv.getHtmlLabelNames("33268,126690", languageid);
			}
		}else{
			message = SystemEnv.getHtmlLabelNames("33268,126690", languageid);
		}
		//QC273665  Ldap用户支持忘记密码功能 END 
	}
		if("".equals(message)){
			message = rid+"";
		}else{
			//统一返回的错误消息，以防恶意猜测攻击。
			if(!message.equals(SystemEnv.getHtmlLabelName(127829, languageid))){
				//System.out.println(message);
				message = SystemEnv.getHtmlLabelName(127829, languageid);
			}
		}
		
		return message;
	}

	private static String getReceiverByLoginid(String loginid,String type){
		RecordSet RS = new RecordSet();
		String receiver = "";
		//String sql = "select * from HrmResource where loginid='"+loginid+"' and (accounttype = 0 or accounttype is null)";
		String sql = "select * from HrmResource where loginid= ? and (accounttype = 0 or accounttype is null)";
		RS.executeQuery(sql,loginid);
		String mobile="",email="";
		if(RS.next()){
			mobile = RS.getString("mobile");
			email = RS.getString("email");
		}
		if("sendSMS".equals(type)){
			receiver = mobile;
		}else if("sendEmail".equals(type)){
			receiver = email;
		}
		return receiver;
	}
	
	public static String getData(String str, String param){
		RecordSet RS = new RecordSet();
		String result = "";
		str = StringUtil.vString(str);
		param = StringUtil.vString(param);
		String[] params = param.split(";");
		if(params == null || params.length != 2) return "";
		String cmd = StringUtil.vString(params[0]);
		String data = StringUtil.vString(params[1]);
		if(cmd.equals("getHrmChoiceImage")){
			String[] dataArray = StringUtil.split(data,"+");
			StringBuffer sb = new StringBuffer();
			for(String _d : dataArray){
				sb.append(_d);
			}
			String[] allDate = sb.toString().split(",");
			if(allDate.length == 2){
				String currentdate = DateUtil.getCurrentDate();
				if((currentdate.compareTo(dataArray[0])>=0 || StringUtil.isNull(dataArray[0])) && (currentdate.compareTo(dataArray[1])<=0 || StringUtil.isNull(dataArray[1]))){
					result = "<img src='/images/BacoCheck.gif'>";
				}
			}
			if(HrmUserVarify.isUserOnline(str)) {
				result += "<img src='/images/State_LoggedOn.gif'>";
			}
		} else if(cmd.equals("getTResourceName")){
			RS.executeQuery("select 1 from HrmResourceManager where loginid = ?",str);
			if(RS.next()) result = "HrmResourceManager";
			
			result = Tools.vString(result, data);
		} else if(cmd.equals("getAccountType")){
			//RS.executeSql("select accounttype from HrmResource where id = "+str);
			RS.executeQuery("select accounttype from HrmResource where id = ?",str);
			if(RS.next()) result = RS.getString(1);
			
			result = Tools.vString(result, data);
		} else if(cmd.equals("getLnScCount")){
			result = getLnScResult(data);
		}
		return result;
	}
	
	private static String getLnScResult(String param){
		RecordSet RS = new RecordSet();
		final int F_Y = 0;
		final int F_N = 1;
		int type = F_N;
		int count = 0;
		LN license = new LN();
		license.InLicense();
		type = StringUtil.parseToInt(license.getScType(), F_N);
		count = StringUtil.parseToInt(license.getScCount(), 0);
		count = type == F_Y ? (count < 0 ? 0 : count) : 0;
		
		String result = "";
		if(param.equals("ct")){
			result = String.valueOf(count);
		} else if(param.equals("mf")){
			int allSubCompany = 0;
			RS.executeSql("select COUNT(id) from HrmSubCompany where supsubcomid = 0 and (canceled is null or canceled != '1')");
			if(RS.next()) 
				allSubCompany = RS.getInt(1);
			result = String.valueOf(count == 0 || allSubCompany < count);
		}
		return result;
	}
	
	private static String checkLoginId(String id, String resourceid, boolean needJson){
		RecordSet RS = new RecordSet();
		StringBuffer sql = new StringBuffer("select id,lastname,loginid,{fEmail},mobile,(select COUNT(id) from hrm_protection_question where user_id = {tName}.id and delflag = 0) as qCount from {tName} where loginid = '")
		.append(StringUtil.vString(id)).append("' ");
		if(StringUtil.isNotNull(resourceid)){
			sql.append(" and id != ").append(resourceid);
		}
		String _sql = StringUtil.replace(sql.toString(), "{fEmail}", "email");
		_sql = StringUtil.replace(_sql, "{tName}", "HrmResource");
		RS.executeSql(_sql + (needJson ? " and (accounttype = 0 or accounttype is null) " : ""));
		StringBuffer result = new StringBuffer();
		HrmResource resource = new HrmResource();
		int qCount = 0;
		if(RS.next()){
			resource.setId(RS.getInt(1));
			resource.setLastname(StringUtil.vString(RS.getString(2)));
			resource.setLoginid(StringUtil.vString(RS.getString(3)));
			resource.setEmail(StringUtil.vString(RS.getString(4)));
			resource.setMobile(StringUtil.vString(RS.getString(5)));
			qCount = RS.getInt("qCount");
		}
		if(resource.getId().intValue() == 0){
			_sql = StringUtil.replace(sql.toString(), "{fEmail}", "'' as email");
			_sql = StringUtil.replace(_sql, "{tName}", "HrmResourceManager");
			RS.executeSql(_sql);
			if(RS.next()){
				resource.setId(RS.getInt(1));
				resource.setLastname(StringUtil.vString(RS.getString(2)));
				resource.setLoginid(StringUtil.vString(RS.getString(3)));
				resource.setEmail(StringUtil.vString(RS.getString(4)));
				resource.setMobile(StringUtil.vString(RS.getString(5)));
				qCount = RS.getInt("qCount");
			}
		}
		if(needJson){
			JSONObject obj = new JSONObject();
			try {
				obj.put("id", resource.getId());
			} catch (JSONException e) {}
			
			result.append(obj.toString());
		} else {
			result.append(resource.getId().intValue() != 0 ? "1" : "0");
		}
		return result.toString();
	}
	
 %>
<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=UTF-8");
	response.setHeader("Cache-Control", "no-cache");
	java.io.PrintWriter pout = response.getWriter();
	try{
		StringBuffer result = new StringBuffer();
		String id = StringUtil.getURLDecode(request.getParameter("id"));
		String cmd = StringUtil.getURLDecode(request.getParameter("cmd"));
		if(cmd.equalsIgnoreCase("forgotPasswordCheckMsg")){
			String loginid = StringUtil.getURLDecode(request.getParameter("loginid"));
			String type = StringUtil.getURLDecode(request.getParameter("type"));
			int languageid = Util.getIntValue(StringUtil.getURLDecode(request.getParameter("languageid")), 7) ;
			String validatecode = StringUtil.getURLDecode(request.getParameter("validatecode"));
            String validateRand="";
            validateRand=Util.null2String((String)request.getSession(true).getAttribute("validateRand"));
			System.out.println("validateRand>>"+validateRand+">>validatecode>>"+validatecode);
            if(!validateRand.toLowerCase().equals(validatecode.trim().toLowerCase()) || "".equals(validatecode.trim().toLowerCase()) ){
				result.append(SystemEnv.getHtmlLabelName(127829, languageid));
            }else{
    			result.append(checkLoginIdMsg(loginid, null, true,type,languageid));
            }
            
		}else if(cmd.equalsIgnoreCase("checkValicateCode")){
		
			String loginid = StringUtil.getURLDecode(request.getParameter("loginid"));
			String validatecode = StringUtil.getURLDecode(request.getParameter("validatecode"));
            String validateRand="";
            validateRand=Util.null2String((String)request.getSession(true).getAttribute("validateRand"));
            if(!validateRand.toLowerCase().equals(validatecode.trim().toLowerCase()) || "".equals(validatecode.trim().toLowerCase()) ){
				result.append("");
            }else{
				result.append(new Random().nextInt()+"");
            }
            
		}else if(cmd.equalsIgnoreCase("checkSMSCode")){
		
			String loginid = StringUtil.getURLDecode(request.getParameter("loginid"));
			String validatecode = StringUtil.getURLDecode(request.getParameter("validatecode"));
			String phoneCodeInp = StringUtil.getURLDecode(request.getParameter("phoneCode"));
		
			HttpSession session1 = request.getSession(true);
			Map<String,String> sessionMap = (Map<String,String>)session.getAttribute("phoneSessionMap");
			sessionMap = sessionMap==null? new HashMap<String,String>():sessionMap;
			if(sessionMap.get(loginid) == null){
				result.append("");
			}else{
				String nowtime = DateUtil.getFullDate();
				String sixtyTime = sessionMap.get(loginid);
				if(nowtime.compareTo(sixtyTime) > 0 ){
					result.append("");
					sessionMap.remove(loginid);
					request.getSession(true).removeAttribute("phoneCode");
					return ;
				}
	            String validateRand="";
	            validateRand=Util.null2String((String)request.getSession(true).getAttribute("validateRand"));
	            String phoneCode="";
	            phoneCode=Util.null2String((String)request.getSession(true).getAttribute("phoneCode"));	
	            if(!validateRand.toLowerCase().equals(validatecode.trim().toLowerCase()) || "".equals(validatecode.trim().toLowerCase()) ){
					result.append("");
	            }else{
		            if("".equals(phoneCodeInp.trim().toLowerCase())){
							result.append("");
		            }else{
			            if(!phoneCode.toLowerCase().equals(phoneCodeInp.trim().toLowerCase())){
							result.append("");
			            }else{
						request.getSession(true).setAttribute("validateLoginid",loginid);
							result.append(new Random().nextInt()+"");
			            }
		            }
	            }
            }
            
		}else if(cmd.equalsIgnoreCase("checkEmailCode")){
		
			String loginid = StringUtil.getURLDecode(request.getParameter("loginid"));
			String validatecode = StringUtil.getURLDecode(request.getParameter("validatecode"));
			String emailCodeInp = StringUtil.getURLDecode(request.getParameter("emailCode"));
			
			HttpSession session1 = request.getSession(true);
			Map<String,String> sessionMap = (Map<String,String>)session.getAttribute("emailSessionMap");
			sessionMap = sessionMap==null? new HashMap<String,String>():sessionMap;
			
			if(sessionMap.get(loginid) == null){
				result.append("");
			}else{
				String nowtime = DateUtil.getFullDate();
				String sixtyTime = sessionMap.get(loginid);
				if(nowtime.compareTo(sixtyTime) > 0 ){
					result.append("");
					sessionMap.remove(loginid);
					request.getSession(true).removeAttribute("emailCode");
					return ;
				}
	            String validateRand="";
	            validateRand=Util.null2String((String)request.getSession(true).getAttribute("validateRand"));
	            String emailCode="";
	            emailCode=Util.null2String((String)request.getSession(true).getAttribute("emailCode"));
	            if(!validateRand.toLowerCase().equals(validatecode.trim().toLowerCase()) || "".equals(validatecode.trim().toLowerCase()) ){
					result.append("");
	            }else{
		            if("".equals(emailCodeInp.trim().toLowerCase())){
							result.append("");
		            }else{
			            if(!emailCode.toLowerCase().equals(emailCodeInp.trim().toLowerCase())){
							result.append("");
			            }else{
						request.getSession(true).setAttribute("validateLoginid",loginid);
							result.append(new Random().nextInt()+"");
			            }
		            }
	            }
			}
            
		}else if(cmd.equalsIgnoreCase("sendSMS")){

		}else if(cmd.equalsIgnoreCase("sendSMSCode")){
			String content = StringUtil.getURLDecode(request.getParameter("content"));
			String loginid = StringUtil.getURLDecode(request.getParameter("loginid"));
			String validatecode = StringUtil.getURLDecode(request.getParameter("validatecode"));
			String receiver = getReceiverByLoginid(loginid,"sendSMS");
//			if(StringUtil.isNotNull(receiver)) receiver = StringUtil.decode(receiver);

			HttpSession session1 = request.getSession(true);
			Map<String,String> sessionMap = (Map<String,String>)session.getAttribute("phoneSessionMap");
			sessionMap = sessionMap==null? new HashMap<String,String>():sessionMap;
			if(sessionMap.get(loginid) != null ){
				String nowtime = DateUtil.getFullDate();
				String sixtyTime = sessionMap.get(loginid);
				if(nowtime.compareTo(sixtyTime) > 0 ){
					sessionMap.remove(loginid);
					request.getSession(true).removeAttribute("phoneCode");
				} else {
					result.append("outoftime_");
				}
			}
			
			if(sessionMap.get(loginid) != null ){
				result.append("");
			}else{
				String newPassword = "";
				boolean isChange = false;
	             String validateRand="";
	             validateRand=Util.null2String((String)request.getSession(true).getAttribute("validateRand"));
	             if(!validateRand.toLowerCase().equals(validatecode.trim().toLowerCase()) || "".equals(validatecode.trim().toLowerCase()) ){
						result.append("");
	             }else{
					HrmPasswordProtectionSetManager manager = new HrmPasswordProtectionSetManager();
					if(StringUtil.isNotNull(id) && !id.equals("0")){
						newPassword = StringUtil.randomString(6, 0);//很对get方法提交的时候特殊字符导致数据传输有误的问题，把验证码取值内容写死成6位随机数字
						content = StringUtil.replace(Constants.PHONECODE_MESSSAGE, "{pswd}", newPassword);
						isChange = true;
					}
					String phone = "";
					boolean bool = MessageUtil.sendSMS(receiver, content);
				
				
					if(bool && isChange){
						//manager.changePassword(id, loginid, newPassword);
						if(receiver.length() - 4 > 0){
							phone = receiver.substring(0, receiver.length() - 4);
						}
						phone += "****";
					}
					if(!phone.equals("")){
						try {
						   if(!"".equals(newPassword)){
								// 将手机验证码存入session
								session1.setAttribute("phoneCode", newPassword);
						        Calendar cal = DateUtil.getCalendar(DateUtil.getFullDate());
						        cal.add(Calendar.SECOND, Constants.SessionSec);
								String sixtyTime = DateUtil.getFullDate(cal.getTime());
								sessionMap.put(loginid,sixtyTime);
								session.setAttribute("phoneSessionMap",sessionMap);
						   }
						}catch (Exception e) {
					  	}	
					}
					result.append(phone);
	             }
			}
		} else if(cmd.equalsIgnoreCase("sendEmailCode")){
			String subject = StringUtil.getURLDecode(request.getParameter("subject"));
			String content = StringUtil.getURLDecode(request.getParameter("content"));
			String loginid = StringUtil.getURLDecode(request.getParameter("loginid"));
			String validatecode = StringUtil.getURLDecode(request.getParameter("validatecode"));
			String receiver = getReceiverByLoginid(loginid,"sendEmail");
			
			HttpSession session1 = request.getSession(true);
			Map<String,String> sessionMap = (Map<String,String>)session.getAttribute("emailSessionMap");
			sessionMap = sessionMap==null? new HashMap<String,String>():sessionMap;
			if(sessionMap.get(loginid) != null ){
				String nowtime = DateUtil.getFullDate();
				String sixtyTime = sessionMap.get(loginid);
				if(nowtime.compareTo(sixtyTime) > 0 ){
					sessionMap.remove(loginid);
					request.getSession(true).removeAttribute("emailCode");
				} else {
					result.append("outoftime_");
				}
			}

			if(sessionMap.get(loginid) != null){
				result.append("");
			}else{
				if(StringUtil.isNull(subject)) subject = "E-cology密码找回";
				String newPassword = "";
				boolean isChange = false;
	             String validateRand="";
	             validateRand=Util.null2String((String)request.getSession(true).getAttribute("validateRand"));
	             if(!validateRand.toLowerCase().equals(validatecode.trim().toLowerCase()) || "".equals(validatecode.trim().toLowerCase()) ){
						result.append("");
	             }else{
					HrmPasswordProtectionSetManager manager = new HrmPasswordProtectionSetManager();
					if(StringUtil.isNotNull(id) && !id.equals("0")){
						newPassword = StringUtil.randomString(6, 0);//很对get方法提交的时候特殊字符导致数据传输有误的问题，把验证码取值内容写死成6位随机数字
						content = StringUtil.replace(Constants.EMAILCODE_MESSSAGE, "{pswd}", newPassword);
						isChange = true;
					}
					boolean bool = MessageUtil.sendEmail(receiver, subject, content);
					String email = "";
					if(bool && isChange) {
						//manager.changePassword(id, loginid, newPassword);
						if(receiver.length() - 4 > 0){
							email = receiver.substring(0, receiver.length() - 4);
						}
						email += "****";
					}
					if(!email.equals("")){
						try {
						   if(!"".equals(newPassword)){
								
								// 将邮箱验证码存入session
								session1.setAttribute("emailCode", newPassword);
						        Calendar cal = DateUtil.getCalendar(DateUtil.getFullDate());
						        cal.add(Calendar.SECOND, Constants.SessionSec);
								String sixtyTime = DateUtil.getFullDate(cal.getTime());
								sessionMap.put(loginid,sixtyTime);
								session.setAttribute("emailSessionMap",sessionMap);
						   }
						}catch (Exception e) {
					  	}	
					}
					result.append(email);
	             }
             }
		}else if(cmd.equalsIgnoreCase("sendEmail")){

		} else if(cmd.equalsIgnoreCase("verifyQuestion")){
			String loginid = StringUtil.getURLDecode(request.getParameter("loginid"));
			String qid = StringUtil.getURLDecode(request.getParameter("qid"));
			String answer = StringUtil.getURLDecode(request.getParameter("answer"));
			HrmPasswordProtectionQuestionManager manager = new HrmPasswordProtectionQuestionManager();
			Map<String, Comparable> map = new HashMap<String, Comparable>();
			map.put("sql_userId", "and t.user_id in (select id from "+getData(loginid, "getTResourceName;HrmResource")+" where loginid = '"+loginid+"') ");
			map.put("id", qid);
			map.put("answer", answer);
			List<HrmPasswordProtectionQuestion> list = manager.find(map);
			if(list != null && list.size() > 0&&((HrmPasswordProtectionQuestion)list.get(0)).getUserId()>0){
				request.getSession(true).setAttribute("validateLoginid",loginid);
			}
//			result.append(list != null && list.size() > 0);
			result.append((list != null && list.size() > 0)?((HrmPasswordProtectionQuestion)list.get(0)).getUserId():("false"));
		}else if(cmd.equalsIgnoreCase("forgotPasswordCheck")){
			String loginid = StringUtil.getURLDecode(request.getParameter("loginid"));
			result.append(checkLoginId(loginid, null, true));
		}else if(cmd.equalsIgnoreCase("saveNewPassword")){
			RecordSet rs = new RecordSet();
			String loginid = StringUtil.getURLDecode(request.getParameter("loginid"));
			String type = StringUtil.getURLDecode(request.getParameter("type"));
			//QC273665 start  Ldap用户支持忘记密码功能 ，保存新密码
			String ret = "0";
			String mode=Prop.getPropValue(GCONST.getConfigFile(), "authentic");
			if(mode.equals("ldap")){
				rs.executeQuery("select isADAccount from hrmresource where loginid= ? ",loginid);
				if(rs.next() &&  "1".equals(Util.null2String(rs.getString("isADAccount")))){
					ret = "1";
				}
			}
			//QC273665 end   Ldap用户支持忘记密码功能 ，保存新密码

			    String validateLoginid=Util.null2String((String)request.getSession(true).getAttribute("validateLoginid"));
			  	try {
					   request.getSession(true).removeAttribute("validateLoginid");
					}catch (Exception e) {}	
			    if(validateLoginid.length()==0 || !validateLoginid.toLowerCase().equals(loginid.trim().toLowerCase())){
			    	response.sendRedirect("/Refresh.jsp?loginfile=/login/Login.jsp?logintype=1");
						return;
			    }
		    
			// String newPassword = StringUtil.getURLDecode(request.getParameter("newpswd"));
			String newPassword = request.getParameter("newpswd");
			rs.executeSql("select id from "+AjaxManager.getData(loginid, "getTResourceName;HrmResource")+" where loginid='"+loginid+"'");
			rs.next();
			String userid = StringUtil.vString(rs.getString("id"),"0");
			String qid = StringUtil.vString(request.getParameter("qid"),"0");
    		if(!"".equals(type)){
    		//QC273665 start Ldap用户支持忘记密码功能 
    		    //System.out.println("QC273665 TYPE is null saveNewPassword ISAD===" + ret);
	    		if(ret.equals("1")){
						LdapUtil ldap=LdapUtil.getInstance();
						java.util.HashMap map=ldap.updateUserInfo(loginid,"","",newPassword,"","1");
						String isSuccess = (String)map.get("isSuccess");
						if("false".equals(isSuccess)){
							result.append("false");
						}
						//System.out.println("QC273665 saveNewPassword=====isSuccess---"+isSuccess);					
				}else{
					new HrmPasswordProtectionSetManager().changePassword(null, loginid, newPassword);
				}
				//QC273665 end Ldap用户支持忘记密码功能 
			}else{
				rs.executeSql("select 1 from hrm_protection_question where user_id="+userid+" and id in("+qid+")");
				if(rs.next()){
				//QC273665 start Ldap用户支持忘记密码功能 
					//System.out.println("QC273665 TYPE is not null saveNewPassword ISAD===" + ret);
					if(ret.equals("1")){
						LdapUtil ldap=LdapUtil.getInstance();
						java.util.HashMap map=ldap.updateUserInfo(loginid,"","",newPassword,"","1");
						String isSuccess = (String)map.get("isSuccess");
						if("false".equals(isSuccess)){
							result.append("false");
						}
						//System.out.println("QC273665 TYPE is not nullsaveNewPassword=====isSuccess---"+isSuccess);					
					}else{
						new HrmPasswordProtectionSetManager().changePassword(id, loginid, newPassword);
					}
				//QC273665 end Ldap用户支持忘记密码功能 
				}else{
					response.sendRedirect("/hrm/password/forgotPassword.jsp");
				}
			}
		} else if(cmd.equalsIgnoreCase("ppset")){
			User user = HrmUserVarify.getUser (request , response) ;
			if(user == null){
				response.sendRedirect("/login/Login.jsp");
				return ;
			}else if(!id.equals(""+user.getUID())){
	    	response.sendRedirect("/Refresh.jsp?loginfile=/login/Login.jsp?logintype=1");
				return;
	    }
			HrmPasswordProtectionSetManager manager = new HrmPasswordProtectionSetManager();
			String checked = StringUtil.getURLDecode(request.getParameter("checked"));
			manager.set(StringUtil.parseToLong(id), Boolean.valueOf(checked));
		} else if(cmd.equalsIgnoreCase("insertQuestion")){
			User user = HrmUserVarify.getUser (request , response) ;
			if(user == null){
				response.sendRedirect("/login/Login.jsp");
				return ;
			}else{
				long userid = StringUtil.parseToLong(user.getUID()+"");
				HrmPasswordProtectionQuestion bean = null;
				Map<String, HrmPasswordProtectionQuestion> qmap = new LinkedHashMap<String, HrmPasswordProtectionQuestion>();
				Enumeration enu = request.getParameterNames();
				int maxSize = 0;
				String indexs = "";
				while(enu.hasMoreElements()){  
					String paraName = StringUtil.vString(enu.nextElement());  
					if(paraName.equalsIgnoreCase("userid") || paraName.equalsIgnoreCase("cmd")) continue;
					String[] params = paraName.split("_"); 
					if(params == null || params.length != 2) continue;
					String key = "q"+params[1];
					if(qmap.containsKey(key)){
						bean = qmap.get(key);
					} else {
						bean = new HrmPasswordProtectionQuestion();
						qmap.put(key, bean);
						maxSize++;
						indexs += (indexs.length()==0?"":",") +params[1];
					}
					if(params[0].equalsIgnoreCase("question")){
						bean.setQuestion(StringUtil.getURLDecode(request.getParameter(paraName)));
					} else if(params[0].equalsIgnoreCase("answer")){
						bean.setAnswer(StringUtil.getURLDecode(request.getParameter(paraName)));
					}
				}
				HrmPasswordProtectionQuestionManager manager = new HrmPasswordProtectionQuestionManager();
				Map<String, Long> map = new HashMap<String, Long>();
				map.put("userId", userid);
				manager.delete(map);
				
				String[] indexArray = indexs.split(",");
				int[] iArray = new int[indexArray.length];
				for(int i=0; i<indexArray.length; i++){
					iArray[i] = StringUtil.parseToInt(indexArray[i]);
				}
				Arrays.sort(iArray);
				for(int i=0; i<iArray.length; i++){
					if(qmap.containsKey("q"+iArray[i])){
						bean = (HrmPasswordProtectionQuestion)qmap.get("q"+iArray[i]);
						bean.setUserId(userid);
						manager.insert(bean);
					}
				}
			}
		}else if(cmd.equalsIgnoreCase("verifyPswd")){
			session.setAttribute("verifyPswd",null);
			JSONObject obj = new JSONObject();
			User user = HrmUserVarify.getUser (request , response) ;
			if(user == null){
				obj.put("result", "false");
				result.append(obj.toString());
			}else{
				boolean isExsit = true;
				RecordSet rs = new RecordSet();
				String isADAccount = "";
		        //String isADAccountSql = "select isADAccount from HrmResource where id = "+id;
		        String isADAccountSql = "select isADAccount from HrmResource where id = ?";
		        rs.executeQuery(isADAccountSql,id);
		        if(rs.next()) {
		        	isADAccount = rs.getString("isADAccount");
		        }
		        String isUseLdap = Prop.getPropValue(GCONST.getConfigFile(), "authentic");    
	            if (ifEqlTarget(isUseLdap, "ldap") && ifEqlTarget(isADAccount, "1") && !"1".equals(id)) {
	            	LdapUtil util = LdapUtil.getInstance();
	            	isExsit = util.authentic(user.getLoginid(), request.getParameter("pswd"));
	            }else{
	            	String pswd = Util.getEncrypt(request.getParameter("pswd"));
					Map<String, Comparable> map = new HashMap<String, Comparable>();
					map.put("id", id);
					map.put("password", pswd);
					isExsit = new HrmResourceManager().get(map) != null;
					if(!isExsit){
						isExsit = new HrmResourceManagerManager().get(map) != null;
					}
	            }
				try {
					if(isExsit){
						session.setAttribute("verifyPswd",user);
					}
					obj.put("result", String.valueOf(isExsit));
				} catch (JSONException e) {}
				result.append(obj.toString());
			}
		}else if(cmd.equalsIgnoreCase("verifyIsADAccount")){
			String ret = "0";
			String mode=Prop.getPropValue(GCONST.getConfigFile() , "authentic");
			if(mode.equals("ldap")){
				RecordSet rs = new RecordSet();
				//rs.executeSql("select isADAccount from hrmresource where id="+id);
				rs.executeQuery("select isADAccount from hrmresource where id=?",id);
				if(rs.next() &&  "1".equals(Util.null2String(rs.getString("isADAccount")))){
					ret = "1";
				}
			}  
			result.append(ret);
		}else if(cmd.equalsIgnoreCase("checkBatchNewDeptUsers")){
			String resourceid = Util.null2o(request.getParameter("resourceid")) ;
			String newDeptid = Util.null2o(request.getParameter("arg")) ;
			String subId = "";
			
			RecordSet rst = new RecordSet();
			
			try {
				subId = new DepartmentComInfo().getSubcompanyid1(newDeptid);
			} catch (Exception e) {}
			
			int _subId = Integer.parseInt(subId) ;
			
			String limitSql = "select a.limitUsers from HrmSubCompany a where a.id ="+subId ;
			rst.execute(limitSql) ;
			int limits = 0 ;
			if(rst.next()){
				limits = rst.getInt("limitUsers") ;
			}
			boolean flag = false ;
			if(limits > 0){
				// current has
				HrmResourceDao resourceDao = new HrmResourceDao();
				int count = resourceDao.count(0, _subId) ;
				
				// current move
				String moveSql = "select count(1) as cnt from hrmresource where id in ("+resourceid+") and subcompanyid1 !="+subId +" and (loginid is not null or loginid !='') ";
				int moveCnt = 0 ;
				rst.executeSql(moveSql) ;
				if(rst.next()){
					moveCnt = rst.getInt("cnt") ;
				}
				flag = 	moveCnt+count > limits ; // over limit
			}
			
			result.append(flag) ;
		}else if(cmd.equalsIgnoreCase("checkValidatecode")){
			String validatecode = Util.null2o(request.getParameter("validatecode")) ;
            String validateRand=Util.null2String((String)request.getSession(true).getAttribute("validateRand"));
            if(!validateRand.toLowerCase().equals(validatecode.trim().toLowerCase()) || "".equals(validatecode.trim().toLowerCase()) ){
				result.append("");
            }else{
				result.append(new Random().nextLong()) ;
            }
		}else{
			result.append(weaver.hrm.common.AjaxManager.getData(request, application));
		}
		pout.print(result.toString());
		
	} catch (Exception e) {
		pout.print(e.toString());
	}
%>
