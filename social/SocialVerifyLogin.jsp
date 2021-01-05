<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="net.sf.json.*"%>
<%@page import="weaver.mobile.plugin.ecology.service.HrmResourceService"%>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.hrm.settings.*" %>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.social.service.SocialIMService"%>
<%@page import="weaver.social.im.SocialImLogin"%>
<%@page import="weaver.social.SocialUtil"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="java.util.*"%>
<%@page import="weaver.login.VerifyPasswdCheck"%>
<%@page import="weaver.login.VerifyLogin"%>
<%@page import="weaver.login.CheckIpNetWork"%>
<%@page import="weaver.conn.ConnStatement"%>
<%@page import="weaver.general.BaseBean"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%!
    // 检测系统是否支持language类型语言
    public boolean judgeLanguage(int language) {
        RecordSet rs = new RecordSet();
        rs.executeQuery("select language, activable from syslanguage where activable = 1 and id = " + language);
        return rs.next();
    }
%>

<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("application/json;charset=UTF-8");

    String method = Util.null2String(request.getParameter("method"));
    if(method.isEmpty()) {
        method = "login";  // 默认是采用登录方法
    }
    BaseBean log = new BaseBean();
    
    
    // 用户登录
    if("login".equals(method)) {
    	FileUpload fu = new FileUpload(request); 
    	
    	String loginId = Util.null2String(fu.getParameter("loginid"));
    	String password = Util.null2String(fu.getParameter("password"));
        
    	String dynapass = Util.null2String(fu.getParameter("dynapass"));
    	String tokenpass = Util.null2String(fu.getParameter("tokenpass"));
    	int language = Util.getIntValue(fu.getParameter("language"), 7);
    	String ipaddress = Util.null2String(fu.getParameter("ipaddress"));
    	int policy = Util.getIntValue(Util.null2String(fu.getParameter("policy")), 0);
    	String auth = Util.null2String(fu.getParameter("auth"));
    	JSONObject result = new JSONObject();
        Map<String, String> map = SocialImLogin.getBuildVersion();
        result.put("buildversion", map.get("buildversion"));
        result.put("osxBuildVersion", map.get("osxBuildVersion"));
        result.put("xpbuildVersion", map.get("xpbuildVersion"));
        result.put("runtimeVersion", map.get("runtimeVersion"));
        
    	if(loginId == null || "".equals(loginId) || password == null || "".equals(password)){
    		result.put("error", "no loginid or password!");
    	}
        if(!judgeLanguage(language)&& language != 7) {
            result.put("status", 999);
    		result.put("errorMsg", "系统不支持该语言，请选择其他语言");
        }
    	else{
    	    HrmResourceService hrs = new HrmResourceService();
    		String userid = "" + hrs.getUserId(loginId);

    	    boolean forbitLogin = SocialImLogin.checkForbitLogin(userid);
    	    boolean isAllowNewWin = SocialImLogin.checkAllowWindowDepart(userid);
    	    int isAllowNewWinNum = (isAllowNewWin==true?1:0);
    	    
    		if(!forbitLogin){
    			result.put("status", -1);  //禁止登录
    			result.put("errorMsg","当前账号已被禁止登录e-message");
    		}else{
   			HrmSettingsComInfo sci = new HrmSettingsComInfo();
   			String needdynapass_sys = sci.getNeeddynapass();
   			String needtokenpass_sys = sci.getNeedusbDt();
   			String validitySec = sci.getValiditySec();
   			String openPasswordLock = Util.null2String(sci.getOpenPasswordLock());
            // 检查登录类型
    		rs.executeQuery("select userUsbType, usbstate, status, needdynapass, needusb from hrmresource where loginid =?",loginId );
            if(rs.next()){
                String userUsbType = Util.null2String(rs.getString("userUsbType"));
                String usbstate = Util.null2String(rs.getString("usbstate"));
                String status = Util.null2String(rs.getString("status"));
                String needdynapass_user = Util.null2String(rs.getString("needdynapass"));
                String needtokenpass_user = Util.null2String(rs.getString("needusb"));
                // 屏蔽离职人员
                if(status.equals("4") || status.equals("5") || status.equals("6") || status.equals("7")) {
                	result.put("status", -1);  //禁止登录
        			result.put("errorMsg","账号已被禁止登录");
	        		out.println(result);
	        		return;
                }
                // log.writeLog("socialVerfylogin----userUsbType---"+userUsbType);
                // log.writeLog("socialVerfylogin----usbstate---"+usbstate);
                if(!userUsbType.isEmpty() && (usbstate.equals("0") || usbstate.equals("2"))) {
                	// userUsbType 2 海泰key 3 动态令牌 4 动态密码 其他表示未开启辅助校验
                	// 手机接口policy 0 不启用 1 验证码 2 动态密码 3 动态令牌
                    if(userUsbType.equals("4")) {
                    	policy = 2;
                    }
                    if(userUsbType.equals("3")) {
                    	policy = 3;
                    }
                    
                }
                
             	// 判断动态密码是否开启
                if(policy == 2) {
                	// 总开关未开启
                	// log.writeLog("socialVerfylogin----needdynapass_sys---"+needdynapass_sys);
                	if(needdynapass_sys != null && needdynapass_sys.equals("0")) {
                		policy = 0;
                	}
                	// 个人开关未开启
                	// log.writeLog("socialVerfylogin----needdynapass_user---"+needdynapass_user);
                	if(!needdynapass_user.equals("1")) {
                		policy = 0;
                	}
                }
                
                // 判断动态令牌是否开启, 总开关可以同时开启两种校验，但个人只能设置一种
                if(policy == 3) {
                	// 总开关未开启
                	// log.writeLog("socialVerfylogin----needtokenpass_sys---"+needtokenpass_sys);
                	if(needtokenpass_sys != null && needtokenpass_sys.equals("0")) {
                		policy = 0;
                	}
                	// 个人开关未开启
                	// log.writeLog("socialVerfylogin----needtokenpass_user---"+needtokenpass_user);
                	if(!needtokenpass_user.equals("1")) {
                		policy = 0;
                	}
                }
                
                // 判断网段策略的情况： usbstate: 0 启用 1 禁用 2 网段策略 
                // 只需考虑动态密码和动态令牌的情况
                if(usbstate.equals("2") && (policy == 2 || policy == 3)) {
                	String clientIP = Util.getIpAddr(request);
                	// log.writeLog("socialVerfylogin----clientIP---"+clientIP);
                	CheckIpNetWork checkipnetwork = new CheckIpNetWork();
                	boolean checkOutter = checkipnetwork.checkIpSeg(clientIP);
                	// 网段内跳过辅助校验
                	// log.writeLog("socialVerfylogin----checkOutter---"+checkOutter);
                	if(!checkOutter) {
                		policy = 0;
                	}
                }
    		}
			// 检查密码锁定
    		boolean isWhite = false;
			rs.executeQuery("select passwordlock from hrmresource where passwordlock>0 and loginid=?",loginId);
			//先判定该用户密码是否已被锁定
			if(rs.next()){
				//获取白名单参数，是否开启白名单
				String isopen = Prop.getPropValue("EMobileWhiteList", "WhiteListOpen");
				if(isopen != null && "true".equals(isopen)){
					String iplist = Prop.getPropValue("EMobileWhiteList", "ips");
					if(iplist != null && iplist.length() > 0){
						String[] ips = iplist.split(",");
						for(int i=0;i<ips.length;i++){
							if(ipaddress.equals(ips[i])){
								isWhite=true;
								break;
							}
						}
					}
				}
				
				if(!isWhite && openPasswordLock.equals("1")){
					result.put("status", 2);
	        		result.put("errorMsg", SystemEnv.getHtmlLabelName(24594,7));
	        		out.println(result);
	        		return;
				}
			}
    		// 检查密码锁定-end
    		// log.writeLog("socialVerfylogin----loginId---"+loginId);
    		// log.writeLog("socialVerfylogin----password---"+password);
    		// log.writeLog("socialVerfylogin----dynapass---"+dynapass);
    		// log.writeLog("socialVerfylogin----tokenpass---"+tokenpass);
    		// log.writeLog("socialVerfylogin----policy---"+policy);
            int status = hrs.checkLogin(loginId, password, dynapass, tokenpass, policy);
			BirthdayReminder birth_reminder = new BirthdayReminder();
    		RemindSettings settings=birth_reminder.getRemindSettings();
            String userHead = "";
            String userName = "";
    		if(status == 1){
				if(settings==null){
    			    	result.put("status", status);
    	        		result.put("errorMsg", SocialIMService.getErrorMsg(status, 7));
    			}
				String OpenPasswordLock = settings.getOpenPasswordLock();
    			if("1".equals(OpenPasswordLock)){
					RecordSet rsPwd = new RecordSet();				
					String updatepwdSql = "update HrmResource set sumpasswordwrong=? where loginid=?";
					rsPwd.executeUpdate(updatepwdSql,0,loginId);
				}
                // 校验license是否正确
                int checkLicense = SocialImLogin.checkLience();
                User user = hrs.getUserById(hrs.getUserId(loginId));
                // 授权信息不正确 或者 不是pc其他地点登录，不允许登录
                if(checkLicense == 1 || (checkLicense == 6 && SocialImLogin.checkOnlineStatus(user.getUID(), SocialImLogin.CLIENT_TYPE_PC) == 1)) {
        			user.setLanguage(language);
        			session.setAttribute("weaver_user@bean",user);
                       //添加密码到缓存中
					try {
						HashMap<Integer, String> socialUserpwdCache = new HashMap<Integer, String>();
						Object pwdObject = StaticObj.getInstance().getObject("socialUserpwdCache");
						if (pwdObject != null) {
							socialUserpwdCache = (HashMap<Integer, String>) pwdObject;
						}
						socialUserpwdCache.put(user.getUID(), password);
						StaticObj.getInstance().putObject("socialUserpwdCache", socialUserpwdCache);
					} catch (Exception e) {
						log.writeLog("socialUserpwdCache 添加失败" + e.getMessage());
					}
        			//将用户id保存到cookie
        			//Util.setCookie(response, "loginidweaver", userid);
        			//userHead=ResourceComInfo.getMessagerUrls(userid);
                    userHead = SocialUtil.getUserHeadImage(user.getUID()+"");
                    userName = ResourceComInfo.getLastname(user.getUID()+"");
                    
                    String sessionKey = session.getId();
                    SocialImLogin.recordSocialIMSessionkey(user.getUID(), sessionKey, SocialImLogin.CLIENT_TYPE_PC);
                    SocialImLogin.updateLoginTime(user.getUID(), SocialImLogin.CLIENT_TYPE_PC);
                    SocialImLogin.setSysLogInfo(request, response);
                    //检查用户是否需要修改OA密码
                    //if(SocialImLogin.checkIsNeedResetPassword(Integer.parseInt(userid))) {
                    //    result.put("status", -2);  //需要用户修改密码后才能登陆
                	//	result.put("errorMsg", "请您提高密码强度，密码不少于8位（并需含字母，数字及特殊字符）！");
                    //    result.put("url", "/hrm/HrmTab.jsp?_fromURL=HrmResourcePassword");
                    //    result.put("sessionkey", sessionKey);
                    //} else {
                        result.put("userName",userName);
                		result.put("userHead",userHead);
                		result.put("status", status);
                		result.put("errorMsg", SocialIMService.getErrorMsg(status, 7));
                		result.put("sessionkey", sessionKey);
                		result.put("isAllowNewWin", isAllowNewWinNum);
                    //}
                } else {
                    result.put("status", -1);  //license错误
            		result.put("errorMsg",SocialImLogin.getCheckLienceMsg(checkLicense, 7));
                }
    		} else {
    			// ‘登录密码不正确’, ‘用户名或密码错误’, ‘用户不存在’的提示统一成‘用户名或密码错误’, status统一成2
    			// log.writeLog("socialVerfylogin----status---"+status);
    			if(status == 3 || status == 4) {
    			//用户名不存在
    				// log.writeLog("socialVerfylogin----status---"+status);
    				result.put("status", status);
	        		result.put("errorMsg", SocialIMService.getErrorMsg(status, 7));
	        		out.println(result);
	        		return;
    			}
    			
    			// 检查密码锁定
            	String errorMsg = "";
    			if(status==2 && !isWhite){
    				RecordSet rs2 = new RecordSet();
    				RecordSet rs1 = new RecordSet();
    				  				
    			    if(settings==null){
    			    	result.put("status", status);
    	        		result.put("errorMsg", SocialIMService.getErrorMsg(status, 7));
    			    }
    			    String OpenPasswordLock = settings.getOpenPasswordLock();
    			    if("1".equals(OpenPasswordLock)){
    				    rs2.executeQuery("select id from HrmResourceManager where loginid=?",loginId);
    				    if(!rs2.next()){
							// log.writeLog("socialVerfylogin----sumpasswordwrong---check--start--");
    						String sql = "select sumpasswordwrong from hrmresource where loginid=?";
							// log.writeLog("socialVerfylogin----sumpasswordwrong---sql="+sql);
    						rs1.executeQuery(sql,loginId);
							int sumpasswordwrong = 0;
							if(rs1.next()) sumpasswordwrong = Util.getIntValue(rs1.getString(1));   						
							// log.writeLog("socialVerfylogin----sumpasswordwrong---sumpasswordwrong="+sumpasswordwrong);
    						int sumPasswordLock = Util.getIntValue(settings.getSumPasswordLock(),3);
							// log.writeLog("socialVerfylogin----sumpasswordwrong---sumPasswordLock="+sumPasswordLock);
    						int leftChance = sumPasswordLock-sumpasswordwrong;
							// log.writeLog("socialVerfylogin----sumpasswordwrong---leftChance="+leftChance);
    						ConnStatement statement = new ConnStatement();
    						if(leftChance==1){
    							String updateSql = "update HrmResource set passwordlock=1,sumpasswordwrong=0 where loginid=?";
								// log.writeLog("socialVerfylogin----sumpasswordwrong---updateSql="+updateSql);
    							try{
									statement.setStatementSql(updateSql);
									statement.setString(1,loginId);
									statement.executeUpdate();
								}catch(Exception e) {
									// log.writeLog("socialVerfylogin----sumpasswordwrong--更新失败--");
    	    				  	}finally {
									try { 
									if(statement!=null) statement.close();
									// log.writeLog("socialVerfylogin----statement.close--");
									}catch(Exception ex) {}
								}
    							status = 19;
    						}else{
    							String updateSql = "update HrmResource set sumpasswordwrong=? where loginid=?";
								// log.writeLog("socialVerfylogin----sumpasswordwrong---updateSql="+updateSql);
    							try{
									statement.setStatementSql(updateSql);
									int setPasswd =sumpasswordwrong +1 ;
									statement.setInt(1,setPasswd);
									statement.setString(2,loginId);
									statement.executeUpdate();
								}catch(Exception e) {
									// log.writeLog("socialVerfylogin----sumpasswordwrong--更新失败--");
    	    				  	}finally {
									try { 
										if(statement!=null) statement.close(); 
										// log.writeLog("socialVerfylogin----statement.close--");
									}catch(Exception ex) {}
								}
    							errorMsg = SystemEnv.getHtmlLabelName(24466,language) + (leftChance-1) + SystemEnv.getHtmlLabelName(24467,language);
    						}
    						
    					}
    			    }    
    			} 
    			// 检查密码锁定--end
    		    result.put("status", status);
        		result.put("errorMsg", errorMsg.isEmpty()?SocialIMService.getErrorMsg(status, 7):errorMsg);
        		if(status == 0){
        			result.put("validitySec", validitySec);
        		}
            }
        }
    }

        String callback = Util.null2String(request.getParameter("callback"));
        if(callback.isEmpty()) {
        	out.println(result);
        } else {
            out.println(callback + "(" + result.toString() + ")");
        }
    }
    
    // 扫码登陆后，获得版本和sessionkey
    else if("afterQRLogin".equals(method)) {
        JSONObject result = new JSONObject();
        User user = HrmUserVarify.checkUser(request, response);
        
        boolean forbitLogin = SocialImLogin.checkForbitLogin(user.getUID()+"");
		if(!forbitLogin){
			result.put("status", -1);  //禁止登录
			result.put("errorMsg","当前账号已被禁止登录e-message");
		}else{
        
        if(user != null) {
            // 校验license是否正确
            int checkLicense = SocialImLogin.checkLience();
            // 授权信息不正确 或者 不是pc其他地点登录，不允许登录
            if(checkLicense == 1 || (checkLicense == 6 && SocialImLogin.checkOnlineStatus(user.getUID(), SocialImLogin.CLIENT_TYPE_PC) == 1)) {
                int userid = user.getUID();
                SocialImLogin.recordSocialIMSessionkey(userid, session.getId(), SocialImLogin.CLIENT_TYPE_PC);
                SocialImLogin.updateLoginTime(user.getUID(), SocialImLogin.CLIENT_TYPE_PC);
                SocialImLogin.setSysLogInfo(request, response);
                
                //检查用户是否需要修改OA密码
                //if(SocialImLogin.checkIsNeedResetPassword(userid)) {
                //    result.put("status", -2);  //需要用户修改密码后才能登陆
            	//	result.put("errorMsg", "请您提高密码强度，密码不少于8位（并需含字母，数字及特殊字符）！");
            	//	result.put("url", "/hrm/HrmTab.jsp?_fromURL=HrmResourcePassword");
            	//	result.put("sessionkey", session.getId());
                //} else {
                    //String userHead=ResourceComInfo.getMessagerUrls(String.valueOf(userid));
                    String userHead = SocialUtil.getUserHeadImage(String.valueOf(userid));
                    String userName = ResourceComInfo.getLastname(String.valueOf(userid));
                    boolean isAllowNewWin = SocialImLogin.checkAllowWindowDepart(String.valueOf(userid));
                    int isAllowNewWinNum = (isAllowNewWin==true?1:0);
                    result.put("userName",userName);
            		result.put("userHead",userHead);
            		result.put("status", 1);
            		result.put("errorMsg", SocialIMService.getErrorMsg(1, 7));
            		result.put("sessionkey", session.getId());
            		result.put("isAllowNewWin", isAllowNewWinNum);
                //}
            } else {
                result.put("status", -1);  //license错误
        		result.put("errorMsg",SocialImLogin.getCheckLienceMsg(checkLicense, 7));
            }
        } else {
            result.put("status", 999);
    		result.put("errorMsg", "服务器处理扫码登录异常");
        }
		}
        Map<String, String> map = SocialImLogin.getBuildVersion();
    	result.put("buildversion", map.get("buildversion"));
    	result.put("osxBuildVersion", map.get("osxBuildVersion"));
    	result.put("xpbuildVersion", map.get("xpbuildVersion"));
    	result.put("runtimeVersion", map.get("runtimeVersion"));
    	String callback = Util.null2String(request.getParameter("callback"));
        if(callback.isEmpty()) {
        	out.println(result);
        } else {
            out.println(callback + "(" + result.toString() + ")");
        }
    }else if("getLanguage".equals(method)){
    	RecordSet recordSet = new RecordSet();
    	recordSet.execute("select language, id from syslanguage where activable = 1");
    	JSONArray lanAry = new JSONArray();
    	JSONObject lanObj = null;
    	while(recordSet.next()){
    		lanObj = new JSONObject();
    		lanObj.put("value",recordSet.getString("id"));
    		lanObj.put("text",recordSet.getString("language"));
    		lanAry.add(lanObj);
    	}
    	out.write(lanAry.toString());
    }else if("checkPwd".equals(method)){
    	FileUpload fu = new FileUpload(request);
        String loginId = Util.null2String(fu.getParameter("loginid"));
    	String sessionKey = Util.null2String(fu.getParameter("sessionKey"));
    	
        HrmResourceService hrs = new HrmResourceService();
        //获取到oa的id,这个方法不能再标准实现
        /*
		String Oaloginid=hrs.getOaloginid();
        if(!loginId.equals(Oaloginid))
        	loginId = Oaloginid;
		*/
		int id = hrs.getUserId(loginId);
    	User user = hrs.getUserById(id);
    	//int id = user.getUID;
    	String userid = "" + id;
    	JSONObject result = new JSONObject();
       	ChgPasswdReminder reminder=new ChgPasswdReminder();
    	RemindSettings settings=reminder.getRemindSettings();
    	
    	String loginMustUpPswd = Util.null2String(settings.getLoginMustUpPswd());
    	String PasswordChangeReminderstr = Util.null2String(settings.getPasswordChangeReminder());
    	// log.writeLog("===========================loginMustUpPswd===="+loginMustUpPswd);
    	// log.writeLog("===========================PasswordChangeReminderstr===="+PasswordChangeReminderstr);
    	boolean PasswordChangeReminder = false;
    	if("1".equals(PasswordChangeReminderstr)){
    		PasswordChangeReminder = true;
    	}
    	int passwdReminder = 0;
    	if(PasswordChangeReminder){
    		passwdReminder = 1;
    	}
    	result.put("passwdReminder",passwdReminder+"");
    	String ChangePasswordDays = settings.getChangePasswordDays();
    	String DaysToRemind = settings.getDaysToRemind();
    	//User user= new User(id);
    	//设置session
    	//request.getSession(true).setAttribute("weaver_user@bean",user);
    	//设置sessionKey
    	//SocialImLogin.recordSocialIMSessionkey(id,sessionKey,1);
    	String passwdchgdate = "";
    	int passwdchgeddate = 0;
    	int passwdreminddatenum = 0;
    	int passwdelse = 0;
    	String passwdreminddate = "";
    	String canpass = "0";
    	String canremind = "0";
    	
    	boolean isUpPswd = false;
    	RecordSet recordSet = new RecordSet();
    	//判断是否开启强制修改密码
    	if("1".equals(loginMustUpPswd)){
    		//String loginSql="select COUNT(id) from HrmSysMaintenanceLog where relatedid = "+id+" and operatetype = 6 and operateitem = 60 and exists (select 1 from HrmResource where id = "+id+") and CAST(operatedesc as varchar"+(recordSet.getDBType().equals("oracle")?"2":"")+"(100)) = 'y'";
    		String loginSql = "select count(*) from hrmresource where haschangepwd = 'y' and id = "+id;
    		// log.writeLog("===========================loginSql===="+loginSql);
    		recordSet.executeSql(loginSql);
    		if(recordSet.next()) isUpPswd = recordSet.getInt(1) <= 0;
    	}
    	
    	if(isUpPswd){
    		result.put("isUpPswd","1");	
    	}else
    	{
    		result.put("isUpPswd","0");
    	}

    	if(user.isAdmin()){
    		result.put("isAdmin","1");
    	}else{
    		result.put("isAdmin","0");	
    	}
    	
    	String isadaccount="";
    	RecordSet recordSet1 = new RecordSet();
    	recordSet1.executeSql("select isadaccount from HrmResource where id = "+id);
    	if(recordSet1.next()){
    		isadaccount=Util.null2String(recordSet1.getString("isadaccount"));
    	}
    	if(isadaccount.equals("1")){  //ad用户 不用提醒
    		result.put("isAdaccount","1");
    	}else{
    		result.put("isAdaccount","0");
    	}
    	
    	if(!isUpPswd){
    		if(PasswordChangeReminder){
    			RecordSet recordSet2 = new RecordSet();
    			recordSet2.executeSql("select passwdchgdate from hrmresource where id = "+id);
    			if(recordSet2.next()){
    				passwdchgdate = recordSet2.getString(1);
    				passwdchgeddate = TimeUtil.dateInterval(passwdchgdate,TimeUtil.getCurrentDateString());
    				
    				if(passwdchgeddate < Integer.parseInt(ChangePasswordDays)){
    					canpass = "1";
    					result.put("canpass","1");
    				}
    				passwdreminddate = TimeUtil.dateAdd(passwdchgdate,Integer.parseInt(ChangePasswordDays)-Integer.parseInt(DaysToRemind));
    				try {
    					passwdreminddatenum = TimeUtil.dateInterval(passwdreminddate,TimeUtil.getCurrentDateString());
    				} catch(Exception ex) {
    					passwdreminddatenum = 0;
    				}
    				passwdelse = Integer.parseInt(DaysToRemind) - passwdreminddatenum;
    				result.put("passwdelse",passwdelse);
    				if(passwdreminddatenum >= 0){
    					canremind = "1";
    					result.put("canremind","1");				
    				}
    			}else{
    				result.put("canremind","0");
    				result.put("canpass","0");
    				result.put("passwdelse","0");
    			}
    		}else{
    			result.put("canremind","0");
    			result.put("canpass","0");
    			result.put("passwdelse","0");
    		}
    	}
    	out.println(result);  	
    }
%>
