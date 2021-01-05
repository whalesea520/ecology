<%@ page language="java" contentType="application/json" pageEncoding="GBK"%>
<%@ page import="java.net.*"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.*" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="org.apache.commons.lang.*" %>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.login.Account" %>
<%@ page import="weaver.wxinterface.InterfaceUtil" %>
<%@ page import="weaver.wxinterface.WxInterfaceInit"%>
<%@ page import="weaver.wxinterface.MsgRuleSetting" %>
<%@ page import="weaver.hrm.report.schedulediff.HrmScheduleDiffUtil"%>
<%@ page import="weaver.mobile.webservices.workflow.*" %>
<%@ page import="java.lang.reflect.Method"%>
<%@ page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ page import="weaver.hrm.company.DepartmentComInfo"%>
<%@ page import="weaver.hrm.company.SubCompanyComInfo" %>
<%@ page import="weaver.conn.RecordSet"%>
<jsp:useBean id="ps" class="weaver.mobile.plugin.ecology.service.PluginServiceImpl" scope="page" />
<jsp:useBean id="hrs" class="weaver.mobile.plugin.ecology.service.HrmResourceService" scope="page" />
<jsp:useBean id="hrs2" class="weaver.wxinterface.HrmResourceService" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="VerifyLogin" class="weaver.login.VerifyLogin" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="wsi" class="weaver.mobile.webservices.workflow.WorkflowServiceImpl" scope="page"/>
<jsp:useBean id="sms" class="weaver.sms.SMSManager" scope="page"/>
<jsp:useBean id="cci" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="sci" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="dci" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="rci" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="docNewsComInfo" class="weaver.docs.news.DocNewsComInfo" scope="page" />
<jsp:useBean id="secCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="docTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<jsp:useBean id="docComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<%	
	out.clearBuffer();
	if(!this.isutf8()){
		request.setCharacterEncoding("GBK");
		response.setContentType("application/json;charset=GBK");
	}else{
		request.setCharacterEncoding("UTF-8");
		response.setContentType("application/json;charset=UTF-8");
	}
	//response.setContentType("application/json;charset=UTF-8");
	FileUpload fu = new FileUpload(request); 
	
	
	String operation = Util.null2String(fu.getParameter("operation"));
	
	Map result = new HashMap();
	
	//微信平台登录e-cology系统
	if(operation.equals("login")){
		String identifier = Util.null2String(fu.getParameter("identifier"));//用户标识
		String identifierType = Util.null2String(fu.getParameter("identifierType"));//标识类型 0表示id 1表示loginid
		String language = Util.null2String(fu.getParameter("language"));//语言
		String ipaddress = Util.null2String(fu.getParameter("ipaddress"));//IP地址
		if(ipaddress.equals("")) ipaddress = fu.getRemoteAddr();
		String clienttype = Util.null2String(fu.getParameter("clienttype"));//app类型
		String ticket = Util.null2String(fu.getParameter("ticket"));//用票据验证是否来源于微信平台
		if(!identifier.equals("") && !ticket.equals("")) {
			
			//通过访问微信平台接口验证票据是否有效
			boolean wxcheck = InterfaceUtil.wxCheckLogin(ticket);
			if(wxcheck){
				String userid = identifier;
				if(identifierType.equals("1")){//传入的是loginid,需要进行转换
					userid = InterfaceUtil.transUserId(identifier,0);
				}else{
					rs.executeSql("select t1.id from HrmResource t1 where t1.status in (0,1,2,3) and t1.id="+Util.getIntValue(userid,0));
					if(!rs.next()){
						String demouserid = Util.null2String(Prop.getPropValue("wxinterface", "demouserid"));
						if(!"".equals(demouserid)){
							userid = demouserid;
						}
					}
				}
				
				String loginid = InterfaceUtil.transUserId(userid,1);//登录账号
				
				boolean issubaccount = false;
				String maccount = "";//主账号
				//启用的主次账号
				if(weaver.general.GCONST.getMOREACCOUNTLANDING()){
					rs.executeSql("select t2.id as mainid,t2.loginid as mainloginid,t2.account as mainaccount from HrmResource t1,HrmResource t2"
							+" where t1.belongto=t2.id and t1.status in (0,1,2,3) and t1.status != 10 and t1.accounttype=1"
							+" and t2.status in (0,1,2,3) and t2.status != 10 and (t2.accounttype=0 or t2.accounttype is null) and t1.id="+Util.getIntValue(userid));
					if(rs.next()){
						maccount = Util.null2String(rs.getString("mainid"));
						
						if(InterfaceUtil.getUserkeytype().equals("loginid")){//转化为登录名
							maccount = InterfaceUtil.transUserId(Util.null2String(rs.getString("mainloginid")), Util.null2String(rs.getString("mainaccount")));
						}
						issubaccount = true;
					}else{
						maccount = identifier;
					}
				}else{
					maccount = identifier;
				}
						
				if("".equals(loginid) && !issubaccount){//无账号人员不允许登录 并且是主账号
					result.put("message","4");
				}else{
					result = ps.login(userid, language, ipaddress);
					//登录成功返回此账号的主账号
					if("1".equals(result.get("message"))){
						result.put("maccount",maccount);
						result.put("userId",userid);//outuserid
						result.put("outsysuserid",identifier);//云桥选择的唯一标识
						result.put("outsysloginid",loginid);//OA的登录账号
						result.put("seclevel",ResourceComInfo.getSeclevel(userid));
						//获取所有上级部门已经上级分部
						String deptid = ResourceComInfo.getDepartmentID(userid);
						String alldeptids = getAllSupDepartment(deptid,null,1,deptid);
						result.put("alldeptids", alldeptids);
						String subid = ResourceComInfo.getSubCompanyID(userid);
						String allsubids = getAllSupSubCompany(subid,null,1,subid);
						result.put("allsubids", allsubids);
						//记录登录日志
						InterfaceUtil.writeLoginLog(userid,ipaddress,clienttype);
					}
				}
			}else{
				result.put("message","3");//验证票据无效
			}
		}	
	}
	else if(operation.equals("updateEbUrl")){
		String ticket = Util.null2String(fu.getParameter("ticket"));//用票据验证是否来源于微信平台
		String ebUrl = Util.null2String(fu.getParameter("ebUrl"));
		if(!"".equals(ebUrl)){
			InterfaceUtil.setWxsysurl(ebUrl);//设置新的云桥地址
			//通过访问微信平台接口验证票据是否有效
			boolean wxcheck = InterfaceUtil.wxCheckLogin(ticket);
			if(wxcheck){
				Map propmap = new HashMap();
				propmap.put("wxsysurl", ebUrl);
				boolean flag = InterfaceUtil.updateProp(propmap);
				if(flag){
					result.put("status","0");
				}else{
					result.put("status","3");
					result.put("message","执行更新云桥基本设置SQL失败");
				}
			}else{
				InterfaceUtil.loadProp();//把内部地址改成之前的
				result.put("status","1");//验证票据无效
				result.put("message","ticket验证失败!云桥内部地址["+ebUrl+"]OA系统无法访问或者不是云桥内部地址");//验证票据无效
			}
		}else{
			result.put("status","2");//验证票据无效
			result.put("message","地址为空");//验证票据无效
		}
	}
	//修改EC端配置文件
	else if(operation.equals("setprop")){
		String sessionkey = Util.null2String(fu.getParameter("sessionkey"));
		boolean wxcheck = ps.verify(sessionkey);
		String msg = "";
		//System.out.println("sessionkey:"+sessionkey+"-----"+wxcheck);
		if(wxcheck){
			User user = HrmUserVarify.checkUser (request , response);
			if(user!=null){
				String wxsysurl = Util.null2String(fu.getParameter("wxsysurl"));//微信集成平台访问地址
				String accesstoken = Util.null2String(fu.getParameter("accesstoken"));//访问秘钥
				String userkeytype = Util.null2String(fu.getParameter("userkeytype"));//用户标识类型 id 或者 loginid
				String outsysid = Util.null2String(fu.getParameter("outsysid"));//微信集成平台端存储的外部系统ID（本EC系统）
				String uuid = Util.null2String(fu.getParameter("uuid"));//该系统唯一标识
				
				Map propmap = new HashMap();
				propmap.put("wxsysurl", wxsysurl);
				propmap.put("accesstoken", accesstoken);
				propmap.put("userkeytype", userkeytype);
				propmap.put("outsysid", outsysid);
				propmap.put("uuid", uuid);
				msg = InterfaceUtil.updateProp2(propmap);
				if(msg.equals("")){
					msg = "1";
				}
			}else{
				msg = "请检查ecology/WEB-INF/web.xml中是否配置了MobileFilter过滤器";
			}
		}else{
			msg = "sessionkey验证失败,请检查emobileLoginKey表中是否有新生成的sessionkey";
		}
		result.put("message",msg);
	}
	
	//修改EC端配置文件
	else if(operation.equals("getprop")){
		String sessionkey = Util.null2String(fu.getParameter("sessionkey"));
		boolean wxcheck = ps.verify(sessionkey);
		//System.out.println("sessionkey:"+sessionkey+"-----"+wxcheck);
		if(wxcheck){
			String outsysid = InterfaceUtil.getOutsysid();//微信集成平台端存储的外部系统ID（本EC系统）
			String accesstoken = InterfaceUtil.getToken();//访问秘钥
			
			Map propmap = new HashMap();
			result.put("outsysid", outsysid);
			result.put("accesstoken", accesstoken);
			result.put("message", "1");
			
		}else{
			result.put("message","3");//操作失败
		}
	}
	
	//修改EC端其他相关配置
	else if(operation.equals("setotherprop")){
		String sessionkey = Util.null2String(fu.getParameter("sessionkey"));
		boolean wxcheck = ps.verify(sessionkey);
		//System.out.println("sessionkey:"+sessionkey+"-----"+wxcheck);
		if(wxcheck){
			String isShowTerminal = Util.null2String(fu.getParameter("isShowTerminal"));//修改流程签字意见是否显示“来源于”
			boolean flag = false;
			try{			
				Class PluginServiceImpl = Class.forName("weaver.mobile.plugin.ecology.service.PluginServiceImpl");
				Method m = PluginServiceImpl.getDeclaredMethod("saveMobileProp",String.class,String.class);
				flag = (Boolean)m.invoke(PluginServiceImpl.newInstance(), "isShowTerminal",isShowTerminal);
				application.removeAttribute("emobile_config_isShowTerminal");
			}
			catch (Exception e){
				flag = false;
				e.printStackTrace();
			}
			if(flag){
				result.put("message","1");//操作成功
			}else{
				result.put("message","2");//操作失败
			}
		}else{
			result.put("message","3");//操作失败
		}
	}
	
	//修改EC端其他相关配置
	else if(operation.equals("getotherprop")){
		String sessionkey = Util.null2String(fu.getParameter("sessionkey"));
		boolean wxcheck = ps.verify(sessionkey);
		//System.out.println("sessionkey:"+sessionkey+"-----"+wxcheck);
		if(wxcheck){
			int isShowTerminal = 1;

			rs.executeSql("select propValue from mobileProperty where name='isShowTerminal'");
			if(rs.next()){
				isShowTerminal = Util.getIntValue(rs.getString(1), 0);
			}
			result.put("isShowTerminal", isShowTerminal);
			result.put("message","1");//操作成功
		}else{
			result.put("message","3");//操作失败
		}
	}
	
	//获取EC系统中的组织人员信息，用于企业号通讯录同步（暂时只用到 人员、部门、分部）
	else if(operation.equals("syncdata")){
		User user = HrmUserVarify.checkUser (request , response) ;
		if(user==null) {
			//未登录或登录超时
			result.put("error", "005");
			
			JSONObject jro = new JSONObject(result);
			out.println(jro);
			return;
		}
		String type = Util.null2String(fu.getParameter("type"));
		if("HrmResource".equalsIgnoreCase(type) || "HrmResourceList".equalsIgnoreCase(type)) {
			String condstr = Util.null2String(fu.getParameter("condstr"));
			boolean isalluser = Util.null2String(fu.getParameter("isalluser")).equals("1");//是否包含无账号人员
			//System.out.println("condstr:"+condstr);
			List auths = new ArrayList();
			if(!"".equals(condstr)){
				try{
					JSONArray ja = new JSONArray(condstr);

					for(int i=0;ja!=null&&i<ja.length();i++) {
						
						JSONObject jao = ja.getJSONObject(i);
						
						Map map = new HashMap();
						
						String authtype="";
						if(jao.has("authtype")) authtype = jao.getString("authtype");
						
						String authvalue="";
						if(jao.has("authvalue")) authvalue = jao.getString("authvalue");
						
						String authseclevel="";
						if(jao.has("authseclevel")) authseclevel = jao.getString("authseclevel");

						map.put("authtype", authtype);
						map.put("authvalue", authvalue);
						map.put("authseclevel", authseclevel);
						
						auths.add(map);
						
						//System.out.println("authtype:"+authtype+"--authvalue:"+authvalue+"--authseclevel:"+authseclevel);
					}
				}catch(Exception e){
					
				}
			} 
			if("HrmResource".equalsIgnoreCase(type)){
				result = hrs2.getAllUser(user,auths,isalluser);  
			}else{
				int pageIndex = Util.getIntValue(fu.getParameter("pageIndex"), 1);
				int pageSize = Util.getIntValue(fu.getParameter("pageSize"), 20);
				int hrmorder = Util.getIntValue(fu.getParameter("hrmorder"), 0);
				String detailid = Util.null2String(fu.getParameter("detailid"));
				String keywordurl = Util.null2String(fu.getParameter("keyword"));
				String keyword = URLDecoder.decode(keywordurl, "GBK");
				List conditions = new ArrayList();
				if(StringUtils.isNotEmpty(keyword)) {
					conditions.add(" (lastname like '%"+keyword+"%' or pinyinlastname like '%"+keyword+"%' or workcode like '%"+keyword+"%' or mobile like '%"+keyword+"%' or telephone like '%"+keyword+"%') ");
				}
				
				if(StringUtils.isNotEmpty(detailid)) {
					conditions.add(" (id = "+detailid+") ");
				}
				result = hrs2.getUserList(user, auths, isalluser, pageIndex, pageSize, hrmorder, conditions); 
			}
			
		} else if("HrmDepartment".equalsIgnoreCase(type)) { 
			String conddeptids = Util.null2String(fu.getParameter("conddeptids"));
			String condsubids = Util.null2String(fu.getParameter("condsubids"));
			result = hrs2.getAllDepartment(user,conddeptids,condsubids);
		} else if("HrmSubCompany".equalsIgnoreCase(type)) {
			String condsubids = Util.null2String(fu.getParameter("condsubids"));
			result = hrs2.getAllSubCompany(user,condsubids);
		} else if("HrmCompany".equalsIgnoreCase(type)) {
			result = hrs2.getAllCompany(user);
		} else if("HrmGroup".equalsIgnoreCase(type)) {
			result = hrs2.getUserGroups(user);
		} else if("HrmGroupMember".equalsIgnoreCase(type)) {
			result = hrs2.getGroupMember(user);
		} else if("WorkPlanType".equalsIgnoreCase(type)) {
			result = hrs2.getWorkPlanType(user);
		} else if("WorkFlowType".equalsIgnoreCase(type)) {
			result = hrs2.getWorkFlowType(user);
		} else if("getBlackWorkFlow".equalsIgnoreCase(type)) {
			result = hrs2.getBlackWorkFlow(user); 
		} else if("setBlackWorkFlow".equalsIgnoreCase(type)) {
			String workflows = fu.getParameter("workflow");
			result = hrs2.setBlackWorkFlow(user, workflows);
		} else if("getHideModule".equalsIgnoreCase(type)) {
			result = hrs2.getHideModule(user);
		} else if("setHideModule".equalsIgnoreCase(type)) {
			String hidemodule = fu.getParameter("hidemodule");
			result = hrs2.setHideModule(user, hidemodule);
		} else if("getHrmSubCompanyTree".equalsIgnoreCase(type)) {
			result = hrs2.getHrmSubCompanyTree(user);
		} else {
			String[] tablenames = fu.getParameters("tablename");
			String[] timestamps = fu.getParameters("timestamp");
			result = hrs2.getTableStatus(tablenames, timestamps);
		}
		//System.out.println(result+"\n===============\n");
	}
	
	//扫描二维码绑定EC账号 验证token和有效期
	else if(operation.equals("checkToken")){
		String token=Util.null2String(fu.getParameter("token"));
		int status = 1;
		String userid = "",loginid = "",userdbid="";
		if(!"".equals(token)){
			try{
				String sql = "select * from wx_token where token='"+token+"'";
				rs.execute(sql);
				if(rs.next()){
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					long nowTime = System.currentTimeMillis();
					String createdate = rs.getString("createdate");
					long cTime = sdf.parse(createdate).getTime();
					if(nowTime-cTime<300000){//有效期5分钟 否则token超时
						userid = Util.null2String(rs.getString("userid"));
						loginid = Util.null2String(rs.getString("loginid"));
						userdbid = Util.null2String(rs.getString("userdbid"));
						result.put("companyname",CompanyComInfo.getCompanyname("1"));//公司名称
						result.put("deptname",DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(userdbid)));//部门名称
						result.put("jobtitle",JobTitlesComInfo.getJobTitlesname(ResourceComInfo.getJobTitle(userdbid)));//职位名称
						result.put("username",ResourceComInfo.getLastname(userdbid));//用户姓名
						result.put("mobile",ResourceComInfo.getMobile(userdbid));//手机号
						result.put("email",ResourceComInfo.getEmail(userdbid));//邮箱
						
						status = 0;
					}
				}
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		result.put("userid",userid);
		result.put("loginid",loginid);
		result.put("userdbid",userdbid);
		result.put("status",status);
	}
	
	//获取EC中已经关注公众号的粉丝信息
	else if(operation.equals("getFollowerList")){
		String publicid = Util.null2String(fu.getParameter("publicid"));
		String token = Util.null2String(fu.getParameter("token"));
		int status = 1;String msg = "";
		JSONArray ja = new JSONArray();
		try{
			if(!"".equals(publicid)&&!"".equals(token)){
				boolean ifAuth = InterfaceUtil.wxCheckLogin(token);//验证token
				if(ifAuth){
					rs.execute("select openid,userid from wechat_band where publicid = '"+publicid+"' and openid is not null");
					String userkeytype = Prop.getPropValue("wxinterface","userkeytype");//获取配置文件中的用户类型
					boolean ifAccount = false;
					if(!userkeytype.equals("ID")){
						String mode=Prop.getPropValue(GCONST.getConfigFile() , "authentic");
						if(mode!=null&&mode.equals("ldap")){
							ifAccount = true;
						}
					}
					while(rs.next()){
						JSONObject jo = new JSONObject();
						jo.put("openid",rs.getString("openid"));
						String userid = rs.getString("userid");
						String loginid = ResourceComInfo.getLoginID(userid);
						String account = ResourceComInfo.getAccount(userid);
						jo.put("userid",userid);
						if(ifAccount){
							jo.put("loginid",account);
						}else{
							jo.put("loginid",loginid);
						}
						ja.put(jo);
					}
					result.put("followerList", ja);
					result.put("userkeytype",userkeytype);
					status = 0;
				}else{
					msg = "token验证失败";
				}
			}else{
				msg = "没有获取到公众号ID";
			}
		}catch(Exception e){
			e.printStackTrace();
			msg = e.getMessage();
		}
		result.put("status", status);
		result.put("msg", msg);
	
	}else if(operation.equals("checkUser")){//手动输入账号密码绑定微信和Ecology账号
		String ticket = Util.null2String(fu.getParameter("ticket"));//用票据验证是否来源于微信平台
		if(InterfaceUtil.wxCheckLogin(ticket)){
			String loginid = Util.null2String(fu.getParameter("loginid"));
			String password = Util.null2String(fu.getParameter("password"));
			String ipaddress = Util.null2String(fu.getParameter("ipaddress"));//IP地址
			String clienttype = Util.null2String(fu.getParameter("clienttype"));//app类型
			String language = Util.null2String(fu.getParameter("language"));//语言
			int status = 1;String msg = "";
			String outuserid = "";//ec系统的用户id 唯一标识
			if(!"".equals(loginid)&&!"".equals(password)){
				try{
					int ifFdSSo = Util.getIntValue(Prop.getPropValue("fdcsdev","ifFdSSo"),0);
					if(ifFdSSo==1){//是复地SSO验证
						try{
							Class hrsClass = Class.forName("weaver.mobile.plugin.ecology.service.HrmResourceService");
							Method m = hrsClass.getMethod("checkFdSSOLogin",String.class,String.class); 		
							loginid = (String)m.invoke(hrsClass.newInstance(),loginid,password);
							if(!"".equals(loginid)){
								outuserid = InterfaceUtil.transUserId(loginid, 0);//将loginid转化为用户ID
							}else{
								msg = "账号密码验证失败";
							}
						}catch(Exception e){
							e.printStackTrace();
							msg = "SSO校验程序出现异常";
						}
					}else{
						Map<String,String> map = InterfaceUtil.userVerify(loginid, password);
						if("1".equals(map.get("result"))){
							loginid = map.get("loginid");
							outuserid = InterfaceUtil.transUserId(loginid, 0);//将loginid转化为用户ID
						}else{
							msg = map.get("msg");
						}
					}
					if(!"".equals(outuserid)){
						//执行登录操作
						int dologin = Util.getIntValue(fu.getParameter("dologin"),0);
						if(dologin==1){
							Map loginres = ps.login(outuserid, language, ipaddress);
							result.put("sessionkey", Util.null2String((String)loginres.get("sessionkey")));
							//记录登录日志
							InterfaceUtil.writeLoginLog(outuserid,ipaddress,clienttype);
						}
						
						//获取配置文件中的用户标识
						String userkeytype = Util.null2String(InterfaceUtil.getUserkeytype());
						if(userkeytype.equalsIgnoreCase("id")){
							loginid = outuserid;//outsysuserid 外部系统userkey
						}
						//获取所有上级部门已经上级分部
						String deptid = ResourceComInfo.getDepartmentID(outuserid);
						String alldeptids = getAllSupDepartment(deptid,null,1,deptid);
						if(alldeptids.equals("")){
							alldeptids = ResourceComInfo.getDepartmentID(outuserid);
						}
						result.put("alldeptids", alldeptids);
						String subid = ResourceComInfo.getSubCompanyID(outuserid);
						String allsubids = getAllSupSubCompany(subid,null,1,subid);
						if(allsubids.equals("")){
							allsubids = ResourceComInfo.getSubCompanyID(outuserid);
						}
						result.put("allsubids", allsubids);
						result.put("seclevel",ResourceComInfo.getSeclevel(outuserid));
						result.put("outuserid", outuserid);
						result.put("outsysuserid", loginid);
						status = 0;
					}else if(msg.equals("")){
						msg = "当前账号在OA系统中不存在";
					}
				}catch(Exception e){
					msg = "Ecology端验证账号密码程序异常:"+e.getMessage();
				}
			}
			result.put("status", status);
			result.put("msg", msg);
		}else{
			result.put("status", 1);
			result.put("msg", "ticket无效");
		}
		
	}else if(operation.equals("checkFdUser")){//验证是否是复星的钉钉账号
		String ticket = Util.null2String(fu.getParameter("ticket"));//用票据验证是否来源于微信平台
		String ifFdUser = "0";String msg = "";
		if(InterfaceUtil.wxCheckLogin(ticket)){
			String dduserid = Util.null2String(fu.getParameter("dduserid"));//传入的钉钉的唯一标识
			String ipaddress = Util.null2String(fu.getParameter("ipaddress"));//IP地址
			String clienttype = Util.null2String(fu.getParameter("clienttype"));//app类型
			String language = Util.null2String(fu.getParameter("language"));//语言
			String apptype = Util.null2String(fu.getParameter("apptype"));//apptype jcyzj
			if(!"".equals(dduserid)){
				try{
					String oaUserDbId = "";
					int ifqsmf = Util.getIntValue(Prop.getPropValue("qsmfcsdev","ifqsmf"),0);
					if(ifqsmf==1){//是全时蜜蜂客户 上汽开发
						ifFdUser = "1";
						rs.executeSql("select id from HrmResource where email = '"+dduserid+"'");
						if(rs.next()){
							oaUserDbId = rs.getString(1);//OA系统数据库ID
						}
					}else if(apptype.equals("jcyzj")){
						rs.executeSql("select id from HrmResource where mobile = '"+dduserid+"'");
						if(rs.next()){
							ifFdUser = "1";
							oaUserDbId = rs.getString(1);//OA系统数据库ID
						}
					}else{
						String field = Util.null2String(Prop.getPropValue("fdcsdev","field"));
						rs.executeSql("select id from cus_fielddata where field"+field+" = '"+dduserid+"'");
						if(rs.next()){
							ifFdUser = "1";
							oaUserDbId = rs.getString(1);//OA系统数据库ID
						}
					}
					if(!oaUserDbId.equals("")){
						Map loginres = ps.login(oaUserDbId, language, ipaddress);
						result.put("sessionkey", Util.null2String((String)loginres.get("sessionkey")));
						result.put("seclevel",ResourceComInfo.getSeclevel(oaUserDbId));
						result.put("outuserid", oaUserDbId);//OA系统数据库ID
						String deptid = ResourceComInfo.getDepartmentID(oaUserDbId);
						String alldeptids = getAllSupDepartment(deptid,null,1,deptid);
						result.put("alldeptids", alldeptids);
						String subid = ResourceComInfo.getSubCompanyID(oaUserDbId);
						String loginid = oaUserDbId;//OA系统唯一标识(id or loginid)
						String userkeytype = Util.null2String(InterfaceUtil.getUserkeytype());//获取配置文件中的用户标识类型
						if(!userkeytype.equalsIgnoreCase("id")){
							loginid = ResourceComInfo.getLoginID(oaUserDbId);
						}
						result.put("outsysuserid", loginid);//OA系统唯一标识(id or loginid)
						result.put("maccount", loginid);//主账号
						result.put("outsysloginid", ResourceComInfo.getLoginID(oaUserDbId));//登录账号
						//记录登录日志
						InterfaceUtil.writeLoginLog(oaUserDbId,ipaddress,clienttype);
					}else{
						msg = "没有在OA查询到对应的账号";
					}
				}catch(Exception e){
					msg = "Ecology端验证账号密码程序异常:"+e.getMessage();
				}
			}else{
				msg = "没有取到钉钉标识";
			}
		}else{
			msg = "ticket无效";
		}
		result.put("msg", msg);
		result.put("ifFdUser",ifFdUser);
	}else if(operation.equals("getVersion")||operation.equals("")){
		rs.execute("select cversion from license");
		String cVersion = "";
		if(rs.next()){
			cVersion = rs.getString("cversion");
		}
		String wVersion = Prop.getPropValue("wxinterfaceversion","version");
		result.put("cversion", cVersion);
		result.put("wversion", wVersion);
		//查询是否存在wx_basesetting表
		boolean ifTableExist = false;
		if("oracle".equals(rs.getDBType())){
			rs.executeSql("select 1 from user_tables where table_name = 'WX_BASESETTING'");
		}else{
			rs.executeSql("select 1 from sysobjects where id = object_id('wx_basesetting')");
		}
		if(rs.next()){
			ifTableExist = true;
		}
		if(ifTableExist){
			result.put("msg", "wx_basesetting表存在");
		}else{
			result.put("msg", "wx_basesetting表不存在,请检查脚本升级是否有问题");
		}
	}else if(operation.equals("getSignInfo")){
		try{
			String ticket = Util.null2String(fu.getParameter("ticket"));//用票据验证是否来源于微信平台
			if(InterfaceUtil.wxCheckLogin(ticket)){
			//if(true){	
				String identifierType = Util.null2String(fu.getParameter("identifierType"));//用户标识
				String identifier = Util.null2String(fu.getParameter("identifier"));
				JSONObject signIn = null;
				JSONObject signOut = null;
				int buttonType = 1;//当前应该显示签到或者签退 1：签到 2：签退 3:非工作日 4:没有获取到用户ID
				String comment = "";
				if(!identifier.equals("")&&!identifierType.equals("")){
					if(!identifierType.equalsIgnoreCase("ID")){
						identifier = InterfaceUtil.transUserId(identifier,0);
					}
					int uid = Util.getIntValue(identifier,0);
					if(uid!=0){
						String currentdate = TimeUtil.getCurrentDateString();//当天日期
						User user = new User();//构造用户对象
						user.setUid(uid);
						user.setUserSubCompany1(Util.getIntValue(ResourceComInfo.getSubCompanyID(identifier)));
						user.setUserDepartment(Util.getIntValue(ResourceComInfo.getDepartmentID(identifier)));
						user.setLogintype("1");
						//构造判断是否是工作日和上下班时间的类
						HrmScheduleDiffUtil HrmScheduleDiffUtil = new HrmScheduleDiffUtil();
						HrmScheduleDiffUtil.setUser(user);
						boolean isWorkday = HrmScheduleDiffUtil.getIsWorkday(currentdate);
						if(!isWorkday&&WxInterfaceInit.isIsutf8()){//今天不是工作日判断是否允许在非工作日签到
							rs.executeSql("select * from HrmkqSystemSet");
							if(rs.next()){
								int onlyworkday = Util.getIntValue(rs.getString("onlyworkday"),0);//1表示只能在工作日签到 
								if(onlyworkday!=1){
									isWorkday = true;
								}
							}
						}
						if(!isWorkday){
							buttonType = 3;
						}else{
							boolean ifOpenSecondSignIn = false;//是否开启两次签到
							String secondTime = "",secondDate = "";
							Map onDutyAndOffDutyTimeMap = HrmScheduleDiffUtil.getOnDutyAndOffDutyTimeMap(currentdate, user.getUserSubCompany1());
							if(onDutyAndOffDutyTimeMap.containsKey("signType")){
								String signType2 = Util.null2String((String)onDutyAndOffDutyTimeMap.get("signType"));
								if(signType2.equals("2")){
									ifOpenSecondSignIn = true;
								}
							}
							if(onDutyAndOffDutyTimeMap.containsKey("signStartTime")){
								secondTime = Util.null2String((String)onDutyAndOffDutyTimeMap.get("signStartTime"));
								secondDate = currentdate+" "+secondTime+":00";
							}
							boolean ifSigned = false;//当天是否有签到
							String sql = "SELECT * FROM HrmScheduleSign where userId="+identifier+" and signDate='"+currentdate+"' and isInCom = 1";
							rs.execute(sql);
							SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
							while(rs.next()){
								try{
									String signType = rs.getString("signType");
									String signDate = rs.getString("signDate");
									String signTime = rs.getString("signTime");
									String clientAddress = rs.getString("clientAddress");
									String address = Util.null2String(rs.getString("ADDR"));
									String wxsignaddress = Util.null2String(rs.getString("wxsignaddress"));
									comment = rs.getString("comment");
									if(!wxsignaddress.equals("")){
										address = wxsignaddress;
									}
									JSONObject jo = new JSONObject();
									jo.put("signType", signType);
									jo.put("signDate", signDate);
									jo.put("signTime", signTime);
									jo.put("clientAddress", address.equals("")?clientAddress:address);
									Date thisDate = sdf.parse(signDate+" "+signTime);
									if(signType.equals("1")){//签到
										ifSigned = true;
										if(signIn==null){
											signIn = jo;
										}else{
											Date signInDate = sdf.parse(signIn.getString("signDate")+" "+signIn.getString("signTime"));
											if(thisDate.getTime()>signInDate.getTime()){//取当天最后一次签到时间作为上一次签到时间
												signIn = jo;
											}
										}
									}else{//签退
										if(signOut==null){
											signOut = jo;
										}else{
											Date signOutDate = sdf.parse(signOut.getString("signDate")+" "+signOut.getString("signTime"));
											if(thisDate.getTime()>signOutDate.getTime()){//取当天最后一次签退时间作为最后一次签退时间
												signOut = jo;
											}
										}
									}
								}catch(Exception e){
									e.printStackTrace();
								}
							}
							if(onDutyAndOffDutyTimeMap.containsKey("onDutyTimeAMButton")){//是否是射阳农商行客户
							//if(true){	
								String onDutyTimeAM = Util.null2String((String) onDutyAndOffDutyTimeMap.get("onDutyTimeAM"))+":00";
								String offDutyTimeAM = Util.null2String((String) onDutyAndOffDutyTimeMap.get("offDutyTimeAM"))+":00";
								String onDutyTimePM = Util.null2String((String) onDutyAndOffDutyTimeMap.get("onDutyTimePM"))+":00";
								String offDutyTimePM = Util.null2String((String) onDutyAndOffDutyTimeMap.get("offDutyTimePM"))+":00";
								String onDutyTimeAMButton = Util.null2String((String) onDutyAndOffDutyTimeMap.get("onDutyTimeAMButton"))+":00";
								String offDutyTimeAMButton = Util.null2String((String) onDutyAndOffDutyTimeMap.get("offDutyTimeAMButton"))+":00";
								String onDutyTimePMButton = Util.null2String((String) onDutyAndOffDutyTimeMap.get("onDutyTimePMButton"))+":00";
								String offDutyTimePMButton = Util.null2String((String) onDutyAndOffDutyTimeMap.get("offDutyTimePMButton"))+":00";
								String currenttime = TimeUtil.getOnlyCurrentTimeString();//当天时间
								if(currenttime.compareTo(offDutyTimeAM)<0){//上午下班之前
									if(ifSigned){//已经签过到显示签退
										buttonType = 2;
									}
								}else if(currenttime.compareTo(offDutyTimeAM)>=0&&currenttime.compareTo(onDutyTimePMButton)<0){
									//上午下班到下午开始签到时间内显示签退
									buttonType = 2;
								}else if(currenttime.compareTo(onDutyTimePMButton)>=0&&currenttime.compareTo(offDutyTimePM)<0){
									//下午签到时间到下午下班时间内 如果签过到并且是在上面的时间内签到的 显示签退
									if(ifSigned&&signIn.getString("signTime").compareTo(onDutyTimePMButton)>0
											&&signIn.getString("signTime").compareTo(offDutyTimePM)<0){
										buttonType = 2;
									}
								}else{//下午下班后都显示签退
									buttonType = 2;
								}
							}else{
								if(ifOpenSecondSignIn){//开启两次签到
									String nowtime = TimeUtil.getCurrentTimeString();//当前时间
									if(TimeUtil.timeInterval(secondDate,nowtime)>0){//当前时间在第二次签到之后
										if(null!=signIn){
											String lastSignInDate = signIn.getString("signDate")+" "+signIn.getString("signTime");
											if(TimeUtil.timeInterval(secondDate,lastSignInDate)>0){//最后一次签到时间在第二次签到时间之后
												buttonType = 2;//应该显示签退
											}
										}
									}else{//当前时间在第二次签到之前
										if(ifSigned){//如果之前签过到则应该显示签退
											buttonType = 2;
										}
									}
								}else{//没有开启两次签到
									if(ifSigned){//当天已经签过到
										buttonType = 2;
									}
								}
							}
						}
					}else{
						buttonType = 4;
					}
				}else{
					buttonType = 4;
			     }
				//冯晓辉   铁道学院客户开发，新增签到 备注字段
				result.put("comment", comment);
				result.put("buttonType", buttonType);
				result.put("signIn", signIn);
				result.put("signOut", signOut);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}else if(operation.equals("getSignList")){
		String ticket = Util.null2String(fu.getParameter("ticket"));//用票据验证是否来源于微信平台
		if(InterfaceUtil.wxCheckLogin(ticket)){
			String identifierType = Util.null2String(fu.getParameter("identifierType"));//用户标识类型
			String identifier = Util.null2String(fu.getParameter("identifier"));//用户标识
			String currentdate = Util.null2String(fu.getParameter("currentdate"));//需要查询的日期
			//type 0:查此日期前一个星期记录 1：查此日期本月的记录 2：查此日期上月的记录
			String type = Util.null2String(fu.getParameter("type"));
			int status = 1;String msg = "";
			if(!identifier.equals("")&&!identifierType.equals("")&&!currentdate.equals("")&&!"".equals(type)){
				if(!identifierType.equalsIgnoreCase("ID")){
					identifier = InterfaceUtil.transUserId(identifier,0);
				}
				int uid = Util.getIntValue(identifier,0);
				if(uid==0){
					msg = "用户不存在";
				}
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				Calendar calendar = Calendar.getInstance();
				try{
					calendar.setTime(sdf.parse(currentdate));
				}catch(Exception e){
					msg = "日期格式错误";
				}
				String beginDate = "",endDate = "";
				if(msg.equals("")){
					if(type.equals("0")){//最近7天
						calendar.add(Calendar.DAY_OF_YEAR,-6);
						beginDate = sdf.format(calendar.getTime());
						endDate = currentdate;
					}else if(type.equals("1")){//本月
						calendar.set(GregorianCalendar.DAY_OF_MONTH,1); 
						beginDate = sdf.format(calendar.getTime());
						endDate =  currentdate;
					}else if(type.equals("2")){//上月
						calendar.add(Calendar.MONTH,-1);
						calendar.set(GregorianCalendar.DAY_OF_MONTH,1); 
						beginDate = sdf.format(calendar.getTime());
						calendar.roll(Calendar.DATE,-1);
						endDate =  sdf.format(calendar.getTime());
					}else{
						msg = "无效查询类型";
					}
				}
				if(msg.equals("")){
					if(!"".equals(beginDate)&&!"".equals(endDate)){
						try{
							User user = new User();//构造用户对象
							user.setUid(uid);
							user.setUserSubCompany1(Util.getIntValue(ResourceComInfo.getSubCompanyID(identifier)));
							user.setUserDepartment(Util.getIntValue(ResourceComInfo.getDepartmentID(identifier)));
							user.setLogintype("1");
							//构造判断是否是工作日和上下班时间的类
							HrmScheduleDiffUtil HrmScheduleDiffUtil = new HrmScheduleDiffUtil();
							HrmScheduleDiffUtil.setUser(user);
							
							JSONArray signInArray = new JSONArray();
							JSONArray signOutArray = new JSONArray();
							Map<String,List<JSONObject>> signInMap = new HashMap<String,List<JSONObject>>();
							Map<String,List<JSONObject>> signOutMap = new HashMap<String,List<JSONObject>>();
							String sql = "SELECT a.* FROM HrmScheduleSign a WHERE a.userId = "+identifier+
								" and a.signDate >= '"+beginDate+"' and a.signDate <='"+endDate+"' and a.isInCom = 1 order by a.id";
							rs.executeSql(sql);
							while(rs.next()){//将查询时间段内的所有签到和签退数据分别装入map中
								JSONObject json = new JSONObject();
								String signType = Util.null2String(rs.getString("signType"));
								String signDate = Util.null2String(rs.getString("signDate"));
								String signTime = Util.null2String(rs.getString("signTime"));
								String clientAddress = Util.null2String(rs.getString("clientAddress"));
								String address = Util.null2String(rs.getString("ADDR"));
								String wxsignaddress = Util.null2String(rs.getString("wxsignaddress"));
								if(!wxsignaddress.equals("")){
									address = wxsignaddress;
								}
								json.put("signType", signType);
								json.put("signDate", signDate);
								json.put("signTime", signTime);
								json.put("clientAddress", address.equals("")?clientAddress:address);
								List<JSONObject> jos = null;
								if(signType.equals("1")){//签到
									if(signInMap.containsKey(signDate)){
										jos = signInMap.get(signDate);
									}
								}else{
									if(signOutMap.containsKey(signDate)){
										jos = signOutMap.get(signDate);
									}
								}
								if(jos==null){
									jos = new ArrayList<JSONObject>();
								}
								jos.add(json);
								if(signType.equals("1")){//签到
									signInMap.put(signDate, jos);
								}else{
									signOutMap.put(signDate, jos);
								}
							}
							//判断非工作日是否可以考勤
							int onlyworkday = 0;//0非工作日也可以签到
							if(WxInterfaceInit.isIsutf8()){//今天不是工作日判断是否允许在非工作日签到
								rs.executeSql("select onlyworkday from HrmkqSystemSet");
								if(rs.next()){
									onlyworkday = Util.getIntValue(rs.getString("onlyworkday"),0);//1表示只能在工作日签到 
								}
							}
							//获取开始日期和结束日期的时间间隔
							int dateSize = TimeUtil.dateInterval(beginDate,endDate);
							Calendar c = Calendar.getInstance();
							c.setTime(sdf.parse(beginDate));//从开始日期开始循环
							for(int i=0;i<=dateSize;i++){
								String date = sdf.format(c.getTime());
								
								Map onDutyAndOffDutyTimeMap = HrmScheduleDiffUtil.getOnDutyAndOffDutyTimeMap(date, user.getUserSubCompany1());
								String onDutyTimeAM = Util.null2String((String) onDutyAndOffDutyTimeMap.get("onDutyTimeAM"));
								String offDutyTimeAM = Util.null2String((String) onDutyAndOffDutyTimeMap.get("offDutyTimeAM"));
								String onDutyTimePM = Util.null2String((String) onDutyAndOffDutyTimeMap.get("onDutyTimePM"));
								String offDutyTimePM = Util.null2String((String) onDutyAndOffDutyTimeMap.get("offDutyTimePM"));
								boolean ifOpenSecondSignIn = false;//是否开启两次签到
								String secondTime = "";
								if(onDutyAndOffDutyTimeMap.containsKey("signType")){
									String signType2 = Util.null2String((String)onDutyAndOffDutyTimeMap.get("signType"));
									if(signType2.equals("2")){
										ifOpenSecondSignIn = true;
									}
								}
								if(onDutyAndOffDutyTimeMap.containsKey("signStartTime")){
									secondTime = Util.null2String((String)onDutyAndOffDutyTimeMap.get("signStartTime"));
									if(onDutyAndOffDutyTimeMap.containsKey("onDutyTimePMButton")){//射阳农商行的二次签到时间需要提前
										secondTime =  Util.null2String((String) onDutyAndOffDutyTimeMap.get("onDutyTimePMButton"));
									}
								}
								
								List<JSONObject> signInList = null;
								List<JSONObject> signOutList = null;
								if(signInMap.containsKey(date)){
									signInList = signInMap.get(date);
								}else{
									signInList = new ArrayList<JSONObject>();
								}
								if(signOutMap.containsKey(date)){
									signOutList = signOutMap.get(date);
								}else{
									signOutList = new ArrayList<JSONObject>();
								}
								JSONObject[] jos = null,jos2 = null;//某天的签到或者签退数组（开启两次签到则数组长度为2否则为1）
								if(ifOpenSecondSignIn){
									jos = new JSONObject[2];
									jos2 = new JSONObject[2];
								}else{
									jos = new JSONObject[1];
									jos2 = new JSONObject[1];
								}
								for(int j=0;j<signInList.size();j++){//循环当天所有的签到数据 取出其中的一到两条
									JSONObject jo = signInList.get(j);
									if(null!=jo){
										String signDateTime = jo.getString("signDate")+" "+jo.getString("signTime");
										if(ifOpenSecondSignIn){//开启两次签到
											String thisSecondTime = jo.getString("signDate")+" "+secondTime+":00";
											if(TimeUtil.timeInterval(signDateTime,thisSecondTime)>0){//第一次签到
												jo.put("signFlag", 1);
												if(jos[0]==null){
													jos[0] = jo;
												}else{
													String lastSignDateTime = jos[0].getString("signDate")+" "+jos[0].getString("signTime");
													if(TimeUtil.timeInterval(signDateTime,lastSignDateTime)>0){//取最早的签到记录
														jos[0] = jo;
													}
												}
											}else{
												jo.put("signFlag", 2);
												if(jos[1]==null){
													jos[1] = jo;
												}else{
													String lastSignDateTime = jos[1].getString("signDate")+" "+jos[1].getString("signTime");
													if(TimeUtil.timeInterval(signDateTime,lastSignDateTime)>0){//取最早的签到记录
														jos[1] = jo;
													}
												}
											}
										}else{
											jo.put("signFlag",1);
											if(jos[0]==null){
												jos[0] = jo;
											}else{
												String lastSignDateTime = jos[0].getString("signDate")+" "+jos[0].getString("signTime");
												if(TimeUtil.timeInterval(signDateTime,lastSignDateTime)>0){
													jos[0] = jo;
												}
											}
										}
									}
								}
								boolean isWorkday = HrmScheduleDiffUtil.getIsWorkday(date);
								for(int j=0;j<jos.length;j++){
									if(jos[j]==null){
										jos[j] = new JSONObject();
										jos[j].put("signType","1");
										jos[j].put("signFlag",j==0?"1":"2");
										jos[j].put("signDate",date);
										jos[j].put("signTime", "");
										jos[j].put("clientAddress", "");
									}
									jos[j].put("ifOpenSecondSignIn", ifOpenSecondSignIn);
									int signStatus = 0;
									if(isWorkday){//工作日
										String signInTime = jos[j].getString("signTime");
										if(signInTime.equals("")){
											signStatus = 1;//未签到
										}else{
											int signFlag = jos[j].getInt("signFlag");//1 第一次签到 2第二次签到
											String compareTime = "";
											if(signFlag==1){
												compareTime = onDutyTimeAM;
											}else if(signFlag==2){
												compareTime = onDutyTimePM;
											}
											if(!compareTime.equals("")&&signInTime.compareTo(compareTime) > 0){
												signStatus = 2;//迟到
											}
										}
									}else{
										if(onlyworkday==0){//非工作日允许签到
											String signInTime = jos[j].getString("signTime");
											if(signInTime.equals("")){
												signStatus = 1;//未签到
											}else{
												signStatus = 0;
											}
										}else{//非工作日并且不允许签到
											signStatus = 3;
										}
									}
									jos[j].put("signStatus", signStatus);
								}
								signInArray.put(jos);
								
								for(int j=0;j<signOutList.size();j++){//循环当天所有的签退数据 取出其中的一到两条
									JSONObject jo = signOutList.get(j);
									if(null!=jo){
										String signDateTime = jo.getString("signDate")+" "+jo.getString("signTime");
										if(ifOpenSecondSignIn){//开启两次签到
											String thisSecondTime = jo.getString("signDate")+" "+onDutyTimePM+":00";//下午上班时间
											if(onDutyAndOffDutyTimeMap.containsKey("offDutyTimeAMButton")){//射阳农商行的二次签到时间需要提前
												thisSecondTime =  jo.getString("signDate")+" "+
													Util.null2String((String) onDutyAndOffDutyTimeMap.get("offDutyTimeAMButton"))+":00";
											}
											if(TimeUtil.timeInterval(signDateTime,thisSecondTime)>0){//第一次签退
												jo.put("signFlag", 1);
												if(jos2[0]==null){
													jos2[0] = jo;
												}else{
													String lastSignDateTime = jos2[0].getString("signDate")+" "+jos2[0].getString("signTime");
													if(TimeUtil.timeInterval(lastSignDateTime,signDateTime)>0){//取最后一次签退记录
														jos2[0] = jo;
													}
												}
											}else{
												jo.put("signFlag", 2);
												if(jos2[1]==null){
													jos2[1] = jo;
												}else{
													String lastSignDateTime = jos2[1].getString("signDate")+" "+jos2[1].getString("signTime");
													if(TimeUtil.timeInterval(lastSignDateTime,signDateTime)>0){//取最后一次签退记录
														jos2[1] = jo;
													}
												}
											}
										}else{
											jo.put("signFlag",1);
											if(jos2[0]==null){
												jos2[0] = jo;
											}else{
												String lastSignDateTime = jos2[0].getString("signDate")+" "+jos2[0].getString("signTime");
												if(TimeUtil.timeInterval(lastSignDateTime,signDateTime)>0){
													jos2[0] = jo;
												}
											}
										}
									
									}
								}
								for(int j=0;j<jos2.length;j++){
									if(jos2[j]==null){
										jos2[j] = new JSONObject();
										jos2[j].put("signType","2");
										jos2[j].put("signFlag",j==0?"1":"2");
										jos2[j].put("signDate",date);
										jos2[j].put("signTime", "");
										jos2[j].put("clientAddress", "");
									}
									jos2[j].put("ifOpenSecondSignIn",ifOpenSecondSignIn);
									int signStatus = 0;
									if(isWorkday){//今天是工作日
										String signInTime = jos2[j].getString("signTime");
										if(signInTime.equals("")){
											signStatus = 1;//未签退
										}else{
											int signFlag = jos2[j].getInt("signFlag");//1 第一次签退 2第二次签退
											String compareTime = "";
											if(ifOpenSecondSignIn&&signFlag==1){//开启两次签到并且是第一次签退
												compareTime = offDutyTimeAM;
											}else{
												compareTime = offDutyTimePM;
											}
											if(!compareTime.equals("")&&signInTime.compareTo(compareTime) < 0){
												signStatus = 2;//早退
											}
										}
									}else{//今天非工作日
										if(onlyworkday==0){//非工作日允许签到
											String signInTime = jos2[j].getString("signTime");
											if(signInTime.equals("")){
												signStatus = 1;//未签退
											}else{
												signStatus = 0;
											}
										}else{//非工作日并且不允许签到
											signStatus = 3;
										}
									}
									jos2[j].put("signStatus", signStatus);
								}
								signOutArray.put(jos2);
								c.add(Calendar.DAY_OF_YEAR,1);
							}
							result.put("signInArray", signInArray);
							result.put("signOutArray", signOutArray);
							result.put("ifOpenSecondSignIn", false);
							status = 0;
						}catch(Exception e){
							msg = "执行数据查询并封装程序出错";
						}
					}else{
						msg = "根据查询类型获取开始日期和结束日期错误";
					}
				}
			}else{
				msg = "相关参数不完整";
			}
			result.put("status", status);
			result.put("msg", msg);
		}else{
			result.put("status", 1);
			result.put("msg", "ticket无效");
		}
	}else if(operation.equals("getSignTotal")){//获取考勤记录统计
		
	}else if(operation.equals("getSignDetail")){//获取考勤某种类型的明细
		
	}
	//获取主从账号信息
	else if(operation.equals("getaccounts")){
		
		//判断编码
		if(this.isutf8()){
			response.setContentType("application/json;charset=UTF-8");
		}
		
		int status = 0;
		String msg = "";
		
		User user = HrmUserVarify.checkUser (request , response) ;
		if(user==null) {
			status = 0;
			msg = "用户登录失败";
		}
		
		if(weaver.general.GCONST.getMOREACCOUNTLANDING()){
			List accounts = VerifyLogin.getAccountsById(user.getUID());
		    if(accounts != null && accounts.size()>1){
		    	JSONArray accountlist = new JSONArray();
		    	JSONObject account = null;
		    	Iterator iter=accounts.iterator();
			    while(iter.hasNext()){
			    	Account a = (Account)iter.next();
			    	account = new JSONObject();
			    	
			    	String subcompanyname = SubCompanyComInfo.getSubCompanyname(""+a.getSubcompanyid());
			        String departmentname = DepartmentComInfo.getDepartmentname(""+a.getDepartmentid());
			        String jobtitlename = JobTitlesComInfo.getJobTitlesname(""+a.getJobtitleid());     
			        
			        account.put("id", a.getId());
			        account.put("loginid", InterfaceUtil.transUserId(a.getId()+"", 1));
			        //account.put("loginid", a.getAccount()); 
			        account.put("showname", subcompanyname+"/"+departmentname+"/"+jobtitlename);
			        
			        //当前账号标志
			        if(a.getId()==user.getUID()){
			        	result.put("cuserid", a.getId());
			        }
			        
			        accountlist.put(account);
			    }
			    
			    result.put("accountlist", accountlist);
			    result.put("userkeytype", InterfaceUtil.getUserkeytype());
			    
			    status = 1;
			}else{
				status = 0;
				msg = "没有设置多账号无需进行切换";
			}
		}else{
			status = 0;
			msg = "未启用多账号登录";
		}
		result.put("status", 1);
		result.put("msg", "");
	}else if(operation.equals("getMsgRuleList")){
		String ticket = Util.null2String(fu.getParameter("ticket"));//用票据验证是否来源于微信平台
		if(InterfaceUtil.wxCheckLogin(ticket)){
			rs.executeSql("select * from WX_MsgRuleSetting order by type,id");
			JSONArray ja = new JSONArray();
			while(rs.next()){
				JSONObject jo = new JSONObject();
				jo.put("id",Util.null2String(rs.getString("id")));
				jo.put("name",Util.null2String(rs.getString("name")));
				jo.put("type",Util.null2String(rs.getString("type")));
				jo.put("ifrepeat",Util.null2String(rs.getString("ifrepeat")));
				jo.put("typeids",Util.null2String(rs.getString("typeids")));
				jo.put("flowsordocs",Util.null2String(rs.getString("flowsordocs")));
				jo.put("names",Util.null2String(rs.getString("names")));
				jo.put("msgtpids",Util.null2String(rs.getString("msgtpids")));
				jo.put("msgtpnames",Util.null2String(rs.getString("msgtpnames")));
				jo.put("freqtime",Util.null2String(rs.getString("freqtime")));
				jo.put("isenable",Util.null2String(rs.getString("isenable")));
				jo.put("iftoall",Util.null2String(rs.getString("iftoall")));
				jo.put("ifcover",Util.null2String(rs.getString("ifcover")));
				jo.put("lastscantime",Util.null2String(rs.getString("lastscantime")));
				jo.put("wfsettype",Util.getIntValue(rs.getString("wfsettype"),0)+"");
				jo.put("flowtype",Util.getIntValue(rs.getString("flowtype"),0)+"");
				jo.put("ifwftodo",Util.getIntValue(rs.getString("ifwftodo"),0)+"");
				jo.put("ifwffinish",Util.getIntValue(rs.getString("ifwffinish"),0)+"");
				jo.put("ifwftimeout",Util.getIntValue(rs.getString("ifwftimeout"),0)+"");
				jo.put("ifwfreject",Util.getIntValue(rs.getString("ifwfreject"),0)+"");
				jo.put("requestlevel",Util.null2String(rs.getString("requestlevel")));
				jo.put("startdate",Util.null2String(rs.getString("startdate")));
				jo.put("startcentext",Util.null2String(rs.getString("startcentext")));
				jo.put("enddate",Util.null2String(rs.getString("enddate")));
				jo.put("endcentext",Util.null2String(rs.getString("endcentext")));
				jo.put("resourcetype",Util.null2String(rs.getString("resourcetype")));
				jo.put("resourceids",Util.null2String(rs.getString("resourceids")));
				jo.put("resourceNames",Util.null2String(rs.getString("resourceNames")));
				jo.put("ifsendsub",Util.getIntValue(rs.getString("ifsendsub"),1)+"");
				ja.put(jo);
			}
			result.put("msgRuleList",ja);
		}
	}else if(operation.equals("getWorkPlanTypeList")){
		String ticket = Util.null2String(fu.getParameter("ticket"));//用票据验证是否来源于微信平台
		if(InterfaceUtil.wxCheckLogin(ticket)){
			rs.executeSql("select * from WorkPlantype WHERE available = '1' ORDER BY displayOrder ASC");
			JSONArray ja = new JSONArray();
			while(rs.next()){
				JSONObject jo = new JSONObject();
				jo.put("id",Util.null2String(rs.getString("workPlanTypeID")));
				jo.put("name",Util.null2String(rs.getString("workPlanTypeName")));
				ja.put(jo);
			}
			result.put("workPlanTypeList",ja);
		}
	}else if("saveMsgRule".equals(operation)){
		String ticket = Util.null2String(fu.getParameter("ticket"));//用票据验证是否来源于微信平台
		if(InterfaceUtil.wxCheckLogin(ticket)){
			String status = "1";String msg = "";
			String param = Util.null2String(fu.getParameter("param"));
			//System.out.println("param======="+param);
			try{
				if(!param.equals("")){
					JSONObject json = new JSONObject(param);
					String fdid = Util.null2String(json.getString("id"));
					String name = Util.null2String(json.getString("name"));
					int type = Util.getIntValue(json.getString("type"), 1);
					int ifrepeat = Util.getIntValue(json.getString("ifrepeat"), 1);
					int iftoall = Util.getIntValue(json.getString("iftoall"), 2);
					int ifcover = Util.getIntValue(json.getString("ifcover"), 1);
					int freqtime = Util.getIntValue(json.getString("freqtime"), 1);
					String msgtpids = Util.null2String(json.getString("msgtpids"));
					String msgtpnames = Util.null2String(json.getString("msgtpnames"));
					String types = Util.null2String(json.getString("typeids"));
					String flows = Util.null2String(json.getString("flowsordocs"));
					String names = Util.null2String(json.getString("names"));
					
					int isenable = Util.getIntValue(json.getString("isenable"),1);
					int flowtype = Util.getIntValue(json.getString("flowtype"),0);//流程内容设置类型 0包含 1排除
					
					int remindtype = Util.getIntValue(json.getString("remindtype"), 1);//会议日程提醒方式
					int timeBefore = Util.getIntValue(json.getString("timeBefore"), 1);//会议日程提前多长时间通知 单位:分钟
					String remindTypeForXz = Util.null2String(json.getString("rtfx"));//协作提醒方式
					
					int wfsettype = Util.getIntValue(json.getString("wfsettype"),0);//流程归档提醒设置 默认不提醒归档(20160721之后无效)
					
					int ifwftodo = Util.getIntValue(json.getString("ifwftodo"),0);//是否推送待办流程（含抄送）
					int ifwffinish = Util.getIntValue(json.getString("ifwffinish"),0);//是否推送归档流程
					int ifwftimeout = Util.getIntValue(json.getString("ifwftimeout"),0);//是否推送超时流程
					int ifwfreject = Util.getIntValue(json.getString("ifwfreject"),0);//是否推送退回流程
					String requestlevel = Util.null2String(json.getString("requestlevel"));//流程紧急程度类型
					
					
					String startDate = Util.null2String(json.getString("startdate")); //开始时间
					String startCentext = Util.null2String(json.getString("startcentext")); //开始内容
					String endDate = Util.null2String(json.getString("enddate")); //结束时间
					String endCentext = Util.null2String(json.getString("endcentext")); //结束内容
					String resourceids = Util.null2String(json.getString("resourceids")); //部门或分部id
					String resourceNames = Util.null2String(json.getString("resourceNames"));  //部门或者分部名称
					String resourcetype = Util.null2String(json.getString("resourcetype"));  //选择了分部还是部门
					
					int ifsendsub = Util.getIntValue(json.getString("ifsendsub"), 1);//消息接收人同时包含主次账号时，次账号是否推送
					
					MsgRuleSetting mrs = new MsgRuleSetting();
					String [] r = mrs.saveOrUpdateMsgRule(fdid, name, type, ifrepeat, iftoall, freqtime, 
							msgtpids, msgtpnames, types, flows, names, isenable, remindtype, timeBefore,
							remindTypeForXz,true,ifcover,wfsettype,flowtype,ifwftodo,ifwffinish,ifwftimeout,ifwfreject,requestlevel,startDate,startCentext,endDate,endCentext,resourceids,resourceNames,resourcetype,
							ifsendsub);
					status = r[0];
					msg = r[1];
				}else{
					msg = "没有获取到要保存的数据";
				}
			}catch(Exception e){
				msg = "ECOLOGY端执行保存程序出现异常:"+e.getMessage();
			}
			result.put("status", status);
			result.put("msg", msg);
		}else{
			result.put("status", "1");
			result.put("msg", "ticket无效");
		}
	}else if(operation.equals("delMsgRule")){
		String ticket = Util.null2String(fu.getParameter("ticket"));//用票据验证是否来源于微信平台
		if(InterfaceUtil.wxCheckLogin(ticket)){
			int status = 1;String msg = "Ecolog端没有获取到要删除的消息推送设置的ID";
			String ids = Util.null2String(fu.getParameter("ids"));
			if(!ids.equals("")){
				String sql = "delete from WX_MsgRuleSetting where id in (" + ids + ")";
				boolean flag = rs.execute(sql);
				if (flag) {
					WxInterfaceInit.initFlowAndDoc();//更新缓存
					status = 0;msg = "";
				} else {
					msg = "执行删除SQL失败";
				}
			}
			result.put("status", status);
			result.put("msg", msg);
		}else{
			result.put("status", 1);
			result.put("msg", "ticket无效");
		}
	}else if(operation.equals("getMsgRuleLog")){
		String ticket = Util.null2String(fu.getParameter("ticket"));//用票据验证是否来源于微信平台
		if(InterfaceUtil.wxCheckLogin(ticket)){
			int type = Util.getIntValue(fu.getParameter("type"),0);
			int resultstatus = Util.getIntValue(fu.getParameter("resultstatus"),-1000);
			String receiveusers = Util.null2String(fu.getParameter("receiveusers"));
			String reourceid = Util.null2String(fu.getParameter("reourceid"));
			String content = Util.null2String(fu.getParameter("content"));
			String startDate = Util.null2String(fu.getParameter("startDate"));
			String endDate = Util.null2String(fu.getParameter("endDate"));
			//System.out.println("content========="+content);
			String backfields = " * ";
			String fromSql = " from WX_SCANLOG";
			String sqlWhere = " where 1=1 ";
			if(type!=0){
				if(type==16){
					sqlWhere +=" and type >="+type;
				}else{
					sqlWhere += " and type="+type;
				}
			}
			if(resultstatus!=-1000){
				sqlWhere += " and resultstatus="+resultstatus;
			}
			if(!receiveusers.equals("")){
				sqlWhere +=" and receiveusers like '%"+receiveusers+"%'";
			}
			if(!content.equals("")){
				sqlWhere +=" and content like '%"+content+"%'";
			}
			if(!startDate.equals("")){
				sqlWhere +=" and scantime  >= '"+startDate+"'";
			}
			if(!endDate.equals("")){
				sqlWhere +=" and scantime  <= '"+endDate+"'";
			}
			if(!reourceid.equals("")){
				sqlWhere +=" and reourceid  = '"+reourceid+"'";
			}
			String orderby1 = " order by id desc ";
			String orderby2 = " order by id asc ";
			String orderby3 = " order by id desc ";
			int iTotal = 0; 
			int pagesize = Util.getIntValue(fu.getParameter("pagesize"),20);;
			rs.executeSql("select count(id) "+fromSql+sqlWhere.toString());
			if(rs.next()) iTotal = rs.getInt(1);
			
			int totalpage = iTotal / pagesize;
			if(iTotal % pagesize >0) totalpage += 1;
			int pagenum = Util.getIntValue(fu.getParameter("pagenum"),1);
			if(pagenum>totalpage) pagenum=1;
			int iNextNum = pagenum * pagesize;
			int ipageset = pagesize;
			if(iTotal - iNextNum + pagesize < pagesize) ipageset = iTotal - iNextNum + pagesize;
			if(iTotal < pagesize) ipageset = iTotal;
			
			String sql = "select top " + ipageset +" A.* from (select top "+ iNextNum + backfields + fromSql + sqlWhere + orderby3 + ") A "+orderby2;
			sql = "select top " + ipageset +" B.* from (" + sql + ") B "+orderby1;
			
			if(rs.getDBType().equals("oracle")){
				sql = "select "+backfields+fromSql+sqlWhere+orderby3;
				sql = "select t2.*,rownum rn from (" + sql + ") t2 where rownum <= " + iNextNum;
				sql = "select t3.* from (" + sql + ") t3 where rn > " + (iNextNum - pagesize);
			}
			rs.executeSql(sql);
			//System.out.println("sql==============\n"+sql);
			JSONArray ja = new JSONArray();
			while(rs.next()){
				JSONObject jo = new JSONObject();
				jo.put("id",Util.null2String(rs.getString("id")));
				jo.put("type",Util.null2String(rs.getString("type")));
				jo.put("othertypes",Util.null2String(rs.getString("othertypes")));
				jo.put("reourceid",Util.null2String(rs.getString("reourceid")));
				jo.put("otherid",Util.null2String(rs.getString("otherid")));
				jo.put("scantime",Util.null2String(rs.getString("scantime")));
				jo.put("receiveusers",Util.null2String(rs.getString("receiveusers")));
				jo.put("content",Util.null2String(rs.getString("content")));
				jo.put("resultstatus",Util.null2String(rs.getString("resultstatus")));
				jo.put("resultcontent",Util.null2String(rs.getString("resultcontent")));
				ja.put(jo);
			}
			//System.out.println("返回的数据为:\n"+ja.toString());
			result.put("total",iTotal);
			result.put("msgRuleLogList",ja);
		}
	}else if(operation.equals("delMsgRuleLog")){
		String ticket = Util.null2String(fu.getParameter("ticket"));//用票据验证是否来源于微信平台
		int status = 1;String msg = "";
		if(InterfaceUtil.wxCheckLogin(ticket)){
			rs.executeSql("select count(1) from WX_SCANLOG");
			if(rs.next()){
				if(rs.getInt(1)>=10000){
					Calendar calendar = Calendar.getInstance();
					calendar.add(Calendar.MONTH,-1);
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
					String lastMonthDate = sdf.format(calendar.getTime());
					rs.executeSql("delete from WX_SCANLOG where scantime <'"+lastMonthDate+"'");
					status = 0;
				}else{
					msg = "日志记录不足1万条";
				}
			}
		}else{
			msg = "票据验证失败";
		}
		result.put("status", status);
		result.put("msg", msg);
	}else if(operation.equals("getSetMsgLog")){//获取云之家设置已办操作日志
		String ticket = Util.null2String(fu.getParameter("ticket"));//用票据验证是否来源于微信平台
		if(InterfaceUtil.wxCheckLogin(ticket)){
			int msgcode = Util.getIntValue(fu.getParameter("msgcode"),-1000);
			String userstrs = Util.null2String(fu.getParameter("userstrs"));
			String requestid = Util.null2String(fu.getParameter("requestid"));
			String workflowid = Util.null2String(fu.getParameter("workflowid"));
			String startDate = Util.null2String(fu.getParameter("startDate"));
			String endDate = Util.null2String(fu.getParameter("endDate"));
			String backfields = " * ";
			String fromSql = " from WX_SETMSGLOG";
			String sqlWhere = " where 1=1";
			if(msgcode!=-1000){
				sqlWhere += " and msgcode="+msgcode;
			}
			if(!userstrs.equals("")){
				sqlWhere +=" and userstrs like '%"+userstrs+"%'";
			}
			if(!startDate.equals("")){
				sqlWhere +=" and createtime  >= '"+startDate+"'";
			}
			if(!endDate.equals("")){
				sqlWhere +=" and createtime  <= '"+endDate+"'";
			}
			if(!requestid.equals("")){
				sqlWhere +=" and requestid  = '"+requestid+"'";
			}
			if(!workflowid.equals("")){
				sqlWhere +=" and workflowid  = '"+workflowid+"'";
			}
			String orderby1 = " order by id desc ";
			String orderby2 = " order by id asc ";
			String orderby3 = " order by id desc ";
			int iTotal = 0; 
			int pagesize = Util.getIntValue(fu.getParameter("pagesize"),20);;
			rs.executeSql("select count(id) "+fromSql+sqlWhere.toString());
			if(rs.next()) iTotal = rs.getInt(1);
			
			int totalpage = iTotal / pagesize;
			if(iTotal % pagesize >0) totalpage += 1;
			int pagenum = Util.getIntValue(fu.getParameter("pagenum"),1);
			if(pagenum>totalpage) pagenum=1;
			int iNextNum = pagenum * pagesize;
			int ipageset = pagesize;
			if(iTotal - iNextNum + pagesize < pagesize) ipageset = iTotal - iNextNum + pagesize;
			if(iTotal < pagesize) ipageset = iTotal;
			
			String sql = "select top " + ipageset +" A.* from (select top "+ iNextNum + backfields + fromSql + sqlWhere + orderby3 + ") A "+orderby2;
			sql = "select top " + ipageset +" B.* from (" + sql + ") B "+orderby1;
			
			if(rs.getDBType().equals("oracle")){
				sql = "select "+backfields+fromSql+sqlWhere+orderby3;
				sql = "select t2.*,rownum rn from (" + sql + ") t2 where rownum <= " + iNextNum;
				sql = "select t3.* from (" + sql + ") t3 where rn > " + (iNextNum - pagesize);
			}
			rs.executeSql(sql);
			//System.out.println("sql==============\n"+sql);
			JSONArray ja = new JSONArray();
			while(rs.next()){
				JSONObject jo = new JSONObject();
				jo.put("id",Util.null2String(rs.getString("id")));
				jo.put("requestid",Util.null2String(rs.getString("requestid")));
				jo.put("workflowid",Util.null2String(rs.getString("workflowid")));
				jo.put("createtime",Util.null2String(rs.getString("createtime")));
				jo.put("userstrs",Util.null2String(rs.getString("userstrs")));
				jo.put("msgcode",Util.null2String(rs.getString("msgcode")));
				jo.put("errormsg",Util.null2String(rs.getString("errormsg")));
				ja.put(jo);
			}
			//System.out.println("返回的数据为:\n"+ja.toString());
			result.put("total",iTotal);
			result.put("setMsgLogList",ja);
		}
	}else if(operation.equals("reSetMsg")){//获取云之家设置已办操作日志
		String ticket = Util.null2String(fu.getParameter("ticket"));//用票据验证是否来源于微信平台
		if(InterfaceUtil.wxCheckLogin(ticket)){
			String ids = Util.null2String(fu.getParameter("msgids"));
			if(!ids.equals("")){
				int successCount = 0,errorCount = 0;
				String[] idss = ids.split(",");
				for(String id:idss){
					if(!id.equals("")){
						Map<String,String> map = InterfaceUtil.setMsgFlag(Util.getIntValue(id,0));
						if(map!=null){
							if("0".equals(map.get("msgcode"))){
								successCount++;
							}else{
								errorCount++;
							}
						}else{
							errorCount++;
						}
					}
				}
				result.put("msg","成功发送"+successCount+"条,失败"+errorCount+"条");
			}else{
				result.put("msg","没有获取到需要操作的数据");
			}
		}else{
			result.put("msg","ticket验证失败");
		}
	}else if(operation.equals("updateMsgRuleAll")){//更新所有推送设置为不启用
		String ticket = Util.null2String(fu.getParameter("ticket"));//用票据验证是否来源于微信平台
		//通过访问微信平台接口验证票据是否有效
		boolean wxcheck = InterfaceUtil.wxCheckLogin(ticket);
		if(wxcheck){
			String sql = "update WX_MsgRuleSetting set isenable = 0";
			if(rs.executeSql(sql)){
				WxInterfaceInit.initFlowAndDoc();//更新缓存
				result.put("status","0");
			}else{
				result.put("status","1");
			}
		}else{
			result.put("status","2");
		}
	}
	//获取联系人
	else if(operation.equals("getContacts")){
		//判断编码
		if(this.isutf8()){
			response.setContentType("application/json;charset=UTF-8");
		}
		
		int status = 0;
		String msg = "";
		
		User user = HrmUserVarify.checkUser (request , response) ;
		if(user==null) {
			status = 0;
			msg = "用户登录失败";
		} else {
			String module = Util.null2String(fu.getParameter("module"));
			String scope = Util.null2String(fu.getParameter("scope"));
			String detailid = Util.null2String(fu.getParameter("detailid"));
			String pageindex = Util.null2String(fu.getParameter("pageindex"));
			String pagesize = Util.null2String(fu.getParameter("pagesize"));
	
			String keywordurl = Util.null2String(fu.getParameter("keyword"));
			String keyword = URLDecoder.decode(keywordurl, "GBK");
	
			String sessionkey = Util.null2String(fu.getParameter("sessionkey"));
			String setting = Util.null2String(fu.getParameter("setting"));
			String mconfig = Util.null2String(fu.getParameter("config"));
			int hrmorder = Util.getIntValue(fu.getParameter("_hrmorder_"), 0);
	
			//因客户端使用GBK编码，故需要转码。
			//keyword = new String(keyword.getBytes("iso8859-1"), "GBK");
	
			//if(ps.verify(sessionkey)) {
				List conditions = new ArrayList();
				
				if(StringUtils.isNotEmpty(keyword)) {
					conditions.add(" (lastname like '%"+keyword+"%' or pinyinlastname like '%"+keyword+"%' or workcode like '%"+keyword+"%' or mobile like '%"+keyword+"%' or telephone like '%"+keyword+"%') ");
				}
				
				if(StringUtils.isNotEmpty(detailid)) {
					conditions.add(" (id = "+detailid+") ");
				}
				try{
					Class pvm = Class.forName("weaver.hrm.appdetach.AppDetachComInfo");
					Method m = pvm.getDeclaredMethod("getScopeSqlByHrmResourceSearch",String.class);
					String sql = (String)m.invoke(pvm.newInstance(),user.getUID()+"");
					if(!sql.equals("")){
						conditions.add(" "+sql);
					}
				}catch(Exception e){
					//e.printStackTrace();
				}
				
				result = hrs2.getUserList(conditions, Util.getIntValue(pageindex), Util.getIntValue(pagesize), hrmorder, user);
				
				if(result!=null&&result.get("list")!=null) {
					List<Map<String,Object>> list = (List<Map<String,Object>>) result.get("list");
					
					List<Map<String,Object>> newlist = new ArrayList<Map<String,Object>>();
					for(Map<String,Object> d:list) {
						Map<String,Object> newdata = new HashMap<String,Object>();
						
						String time = "";
						String image = StringUtils.defaultIfEmpty((String) d.get("msgerurl"),"");
						String id = StringUtils.defaultIfEmpty((String) d.get("id"),"");
						String isnew = "";
						String subject = StringUtils.defaultIfEmpty((String) d.get("lastname"),"");
						String description = "" +
											 " [" + StringUtils.defaultIfEmpty((String) d.get("jobtitle"),"") + "]" +
											 " " + StringUtils.defaultIfEmpty((String) d.get("dept"),"") + " / " +
											 "" + StringUtils.defaultIfEmpty((String) d.get("subcom"),"");
						String jobtitle = StringUtils.defaultIfEmpty((String) d.get("jobtitle"),"");
						String dept = StringUtils.defaultIfEmpty((String) d.get("dept"),"");
						String subcom = StringUtils.defaultIfEmpty((String) d.get("subcom"),"");
						String pinyinlastname = StringUtils.defaultIfEmpty((String) d.get("pinyinlastname"),"");
						
						newdata.put("time", time);
						newdata.put("image", image);
						newdata.put("id", id);
						newdata.put("isnew", isnew);
						newdata.put("subject", subject);
						newdata.put("description", description);
						newdata.put("jobtitle", jobtitle);
						newdata.put("dept", dept);
						newdata.put("subcom", subcom);
						newdata.put("pinyinlastname", pinyinlastname);
						newlist.add(newdata);
					}
					result.put("list",newlist);
				}
				status = 1;
			//}
		}
		
		result.put("status", status);
		result.put("msg", msg);
	}
	//获取可用流程
	else if(operation.equals("getAvailableWorkflows")){
		//判断编码
		if(this.isutf8()){
			response.setContentType("application/json;charset=UTF-8");
		}
		
		int status = 0;
		String msg = "";
		
		User user = HrmUserVarify.checkUser (request , response) ;
		if(user==null) {
			status = 0;
			msg = "用户登录失败";
		} else {
			String keywordurl = Util.null2String(fu.getParameter("keyword"));
			String keyword = URLDecoder.decode(keywordurl, "GBK");
			String setting = Util.null2String(fu.getParameter("setting"));
			
			String[] conditions = new String[2];
			conditions[0] = keyword;
			conditions[1] = weaver.mobile.plugin.ecology.RequestOperation.AVAILABLE_WORKFLOW;
			
			WorkflowBaseInfo[] wbis = wsi.getCreateWorkflowList(0, 99999999, 0, user.getUID(), 0, conditions);
			
			if ("".equals(setting)) {
				result.put("list", net.sf.json.JSONArray.fromObject(wbis).toString());
				//result.put("list", JSON.toJSONString(wbis));
			} else {
				String allwfids = setting;
				try{			
					Class WorkflowVersion = Class.forName("weaver.workflow.workflow.WorkflowVersion");
					Method m = WorkflowVersion.getMethod("getAllVersionStringByWFIDs", String.class); 
					allwfids = (String)m.invoke(WorkflowVersion, allwfids);
				}
				catch (Exception e){
					//e.printStackTrace();
					allwfids = setting;
				}
				List<WorkflowBaseInfo> wbiList = new ArrayList<WorkflowBaseInfo>();
				String settings = "," + allwfids + ",";
				for (int i = 0; i < wbis.length; i++) {
					if (settings.indexOf("," + wbis[i].getWorkflowId() + ",") != -1)
						wbiList.add(wbis[i]);
				}
				result.put("list", net.sf.json.JSONArray.fromObject(wbiList).toString());
				//result.put("list", JSON.toJSONString(wbiList));
			}
			status = 1;
		}
		
		result.put("status", status);
		result.put("msg", msg);
	}
	//获取地理位置设置
	else if(operation.equals("getLocationSetList")){
		String ticket = Util.null2String(fu.getParameter("ticket"));//用票据验证是否来源于微信平台
		if(InterfaceUtil.wxCheckLogin(ticket)){
			rs.executeSql("select * from WX_LocationSetting order by id desc");
			Map<String,String> map = new HashMap<String,String>();
			while(rs.next()){
				map.put(Util.null2String(rs.getString("id")), Util.null2String(rs.getString("name")));
			}
			rs.executeSql("select * from wx_locations order by id desc");
			JSONArray ja = new JSONArray();
			while(rs.next()){
				JSONObject jo = new JSONObject();
				jo.put("id",Util.null2String(rs.getString("id")));
				jo.put("resourcetype",Util.null2String(rs.getString("resourcetype")));
				jo.put("resourceids",Util.null2String(rs.getString("resourceids")));
				jo.put("resourceNames",Util.null2String(rs.getString("resourceNames")));
				String addressids = Util.null2String(rs.getString("addressids"));
				jo.put("addressids",addressids);
				if(!addressids.equals("-1")){
					String addids[] = addressids.split(",");
					String addressNames = "";
					for(String aid:addids){
						if(!aid.equals("")&&map.containsKey(aid)){
							addressNames +=",<a href='javascript:;' class='editAddress' addid='"+aid+"'>"+map.get(aid)+"</a>";
						}
					}
					if(!addressNames.equals("")){
						addressNames = addressNames.substring(1);
					}
					jo.put("addressNames",addressNames);
				}else{
					jo.put("addressNames","任意位置");
				}
				jo.put("createtime",Util.null2String(rs.getString("createtime")));
				jo.put("isenable",Util.null2String(rs.getString("isenable")));
				ja.put(jo);
			}
			result.put("locationList",ja);
		}
	}
	//获取地理位置规则
	else if(operation.equals("getAddressRuleList")){
		String ticket = Util.null2String(fu.getParameter("ticket"));//用票据验证是否来源于微信平台
		if(InterfaceUtil.wxCheckLogin(ticket)){
			rs.executeSql("select * from WX_LocationSetting order by id desc");
			JSONArray ja = new JSONArray();
			while(rs.next()){
				JSONObject jo = new JSONObject();
				jo.put("id",Util.null2String(rs.getString("id")));
				jo.put("name",Util.null2String(rs.getString("name")));
				jo.put("lat",Util.null2String(rs.getString("lat")));
				jo.put("lng",Util.null2String(rs.getString("lng")));
				jo.put("address",Util.null2String(rs.getString("address")));
				jo.put("distance",Util.null2String(rs.getString("distance")));
				jo.put("createtime",Util.null2String(rs.getString("createtime")));
				ja.put(jo);
			}
			result.put("addressRuleList",ja);
		}
	}
	else if("saveOrUpdateLocation".equals(operation)){
		String status = "1";String msg = "";
		String ticket = Util.null2String(fu.getParameter("ticket"));//用票据验证是否来源于微信平台
		if(InterfaceUtil.wxCheckLogin(ticket)){
			String param = Util.null2String(fu.getParameter("param"));
			try{
				if(!param.equals("")){
					JSONObject json = new JSONObject(param);
					String id = Util.null2String(json.getString("id"));
					String resourcetype = Util.null2String(json.getString("resourcetype"));
					String resourceids = Util.null2String(json.getString("resourceids"));
					String resourceNames = Util.null2String(json.getString("resourceNames"));
					String addressids = Util.null2String(json.getString("addressids"));
					String addressNames = Util.null2String(json.getString("addressNames"));
					int isenable = Util.getIntValue(json.getString("isenable"),1);
					StringBuffer sql = new StringBuffer();
					String nowtime = TimeUtil.getCurrentTimeString();//当天日期和时间
					if(id.equals("")){
						sql.append("insert into wx_locations (resourcetype,resourceids,resourceNames,addressids");
						sql.append(",addressNames,isenable,createtime)");
						sql.append(" values ('"+resourcetype+"','"+resourceids+"','"+resourceNames+"','"+addressids);
						sql.append("','',"+isenable+",'"+nowtime+"')");
					}else{
						sql.append("update wx_locations set ");
						sql.append("resourcetype='"+resourcetype+"',resourceids='"+resourceids+"'");
						sql.append(",resourceNames='"+resourceNames+"',addressids='"+addressids+"'");
						sql.append(",addressNames='',isenable="+isenable+" where id = "+id);
					}
					rs.execute(sql.toString());
					status = "0";
				}else{
					msg = "没有获取到要保存的数据";
				}
			}catch(Exception e){
				msg = "ECOLOGY端执行保存程序出现异常:"+e.getMessage();
			}
			
		}else{
			msg = "ticket无效";
		}
		result.put("status", status);
		result.put("msg", msg);
	}else if(operation.equals("delLocation")){
		int status = 1;String msg = "Ecolog端没有获取到要删除的考勤规则设置的ID";
		String ticket = Util.null2String(fu.getParameter("ticket"));//用票据验证是否来源于微信平台
		if(InterfaceUtil.wxCheckLogin(ticket)){
			
			String ids = Util.null2String(fu.getParameter("ids"));
			if (!"".equals(ids)) {
				String sql = "delete from wx_locations where id in (" + ids + ")";
				boolean flag = rs.execute(sql);
				if (flag) {
					status = 0;
				} else {
					msg = "执行删除SQL失败";
				}
			}
		}else{
			msg = "ticket无效";
		}
		result.put("status", status);
		result.put("msg", msg);
	}
	else if("saveOrUpdateAddress".equals(operation)){
		String status = "1";String msg = "";
		String ticket = Util.null2String(fu.getParameter("ticket"));//用票据验证是否来源于微信平台
		if(InterfaceUtil.wxCheckLogin(ticket)){
			String param = Util.null2String(fu.getParameter("param"));
			try{
				if(!param.equals("")){
					JSONObject json = new JSONObject(param);
					String id = Util.null2String(json.getString("id"));
					String name = Util.null2String(json.getString("name"));
					String address = Util.null2String(json.getString("address"));
					String lat = Util.null2String(json.getString("lat"));
					String lng = Util.null2String(json.getString("lng"));
					String distance = Util.null2String(json.getString("distance"));
					StringBuffer sql = new StringBuffer();
					String nowtime = TimeUtil.getCurrentTimeString();//当天日期和时间
					if(id.equals("")){
						sql.append("insert into WX_LocationSetting (name,address,distance,lat,lng,createtime)");
						sql.append(" values ('"+name+"','"+address+"',"+distance);
						sql.append(",'"+lat+"','"+lng+"','"+nowtime+"')");
					}else{
						sql.append("update WX_LocationSetting set ");
						sql.append("name='"+name+"',address='"+address+"',distance="+distance);
						sql.append(",lat='"+lat+"',lng='"+lng+"' where id = "+id);
					}
					rs.executeSql(sql.toString());
					String newId = "";
					if(id.equals("")){
						rs.executeSql("select max(id) from WX_LocationSetting");
						if(rs.next()){
							newId = rs.getString(1);
						}
					}
					result.put("newId", newId);
					status = "0";
				}else{
					msg = "没有获取到要保存的数据";
				}
			}catch(Exception e){
				msg = "ECOLOGY端执行保存程序出现异常:"+e.getMessage();
			}
		}else{
			msg = "ticket无效";
		}
		result.put("status", status);
		result.put("msg", msg);
	}else if(operation.equals("delAddress")){
		int status = 1;String msg = "Ecolog端没有获取到要删除的考勤位置设置的ID";
		String ticket = Util.null2String(fu.getParameter("ticket"));//用票据验证是否来源于微信平台
		if(InterfaceUtil.wxCheckLogin(ticket)){
			String ids = Util.null2String(fu.getParameter("ids"));
			if (!"".equals(ids)) {
				String sql = "delete from WX_LocationSetting where id in (" + ids + ")";
				boolean flag = rs.execute(sql);
				if (flag) {
					status = 0;
				} else {
					msg = "执行删除SQL失败";
				}
			}
		}else{
			msg = "ticket无效";
		}
		result.put("status", status);
		result.put("msg", msg);
		
	}else if(operation.equals("getAddressById")){
		int status = 1;String msg = "Ecolog端没有获取到要编辑的考勤位置设置的ID";
		String ticket = Util.null2String(fu.getParameter("ticket"));//用票据验证是否来源于微信平台
		if(InterfaceUtil.wxCheckLogin(ticket)){
			String id = Util.null2String(fu.getParameter("id"));
			if(!id.equals("")){
				rs.executeSql("select * from WX_LocationSetting where id = "+id);
				if(rs.next()){
					JSONObject jo = new JSONObject();
					jo.put("id",Util.null2String(rs.getString("id")));
					jo.put("name",Util.null2String(rs.getString("name")));
					jo.put("lat",Util.null2String(rs.getString("lat")));
					jo.put("lng",Util.null2String(rs.getString("lng")));
					jo.put("address",Util.null2String(rs.getString("address")));
					jo.put("distance",Util.null2String(rs.getString("distance")));
					jo.put("createtime",Util.null2String(rs.getString("createtime")));
					result.put("jo", jo);
					status = 0;
				}
			}
		}else{
			msg = "ticket无效";
		}
		result.put("status", status);
		result.put("msg", msg);
	}else if(operation.equals("systemcheck")){//系统检测
		
		String token = Util.null2String(fu.getParameter("token"));
		String ticket = Util.null2String(fu.getParameter("ticket"));
		
		/* 
		1、是否配置的mobile过滤器
		2、是否配置了wxinterface
		3、是否设置了流程类的消息提醒
		4、是否设置了文档类的消息提醒
		5、是否设置了xxx类的消息提醒
		。。。。
		6、微信接口版本号
		7、OA版本号 
		*/
		//是否配置mobile过滤器
		int ismobilefilter = 0;
		//是否配置mobile路径
		int ismobile = 0;
		//是否配置了wxinterfaceinit
		int iswxinit = 0;
		//是否配置了移动建模
		int ismobilemode = 0;
		BufferedReader br = null; 
		try{
			br = new BufferedReader(new FileReader(GCONST.getRootPath()+"WEB-INF"+File.separatorChar+"web.xml"));
			String line = null;
			while ((line = br.readLine()) != null) {  
				if(line.indexOf("weaver.mobile.plugin.ecology.MobileFilter")>-1){
					ismobilefilter = 1;
				}else if(line.indexOf("weaver.wxinterface.WxInterfaceInit")>-1){
					iswxinit = 1;
				}else if(line.indexOf("<url-pattern>/mobilemode")>-1){
					ismobilemode = 1;
				}else if(line.indexOf("<url-pattern>/mobile/")>-1){
					ismobile = 1;
				}
			}
		}catch(Exception e){
			
	 	} finally {  
	        // 关闭流  
	        if (br != null) {  
	        	try {  
	        		br.close();  
	            } catch (IOException e) {  
	            	br = null;  
	            }  
	        } 
	  }  
	  ismobile = (ismobilefilter==1 && ismobile==1)?1:0;
	  ismobilemode = (ismobilefilter==1 && ismobilemode==1)?1:0;
		result.put("ismobile", ismobile);
		result.put("iswxinit", iswxinit);
		result.put("ismobilemode", ismobilemode);
		
		//查询推送配置
		rs.executeSql("select * from WX_MsgRuleSetting where isenable=1 order by type,id");
		JSONArray ja = new JSONArray();
		while(rs.next()){
			JSONObject jo = new JSONObject();
			jo.put("id",Util.null2String(rs.getString("id")));
			jo.put("name",Util.null2String(rs.getString("name")));
			jo.put("type",Util.null2String(rs.getString("type")));
			jo.put("ifrepeat",Util.null2String(rs.getString("ifrepeat")));
			jo.put("typeids",Util.null2String(rs.getString("typeids")));
			jo.put("flowsordocs",Util.null2String(rs.getString("flowsordocs")));
			//jo.put("names",Util.null2String(rs.getString("names")));
			jo.put("msgtpids",Util.null2String(rs.getString("msgtpids")));
			//jo.put("msgtpnames",Util.null2String(rs.getString("msgtpnames")));
			jo.put("freqtime",Util.null2String(rs.getString("freqtime")));
			jo.put("iftoall",Util.null2String(rs.getString("iftoall")));
			jo.put("ifcover",Util.null2String(rs.getString("ifcover")));
			jo.put("lastscantime",Util.null2String(rs.getString("lastscantime")));
			ja.put(jo);
		}
		result.put("msgRuleList",ja);
		
		//读取接口信息
		result.put("wxsysurl", InterfaceUtil.getWxsysurl());
		result.put("outsysid", InterfaceUtil.getOutsysid());
		result.put("istoken", token.equals(InterfaceUtil.getToken())?1:0);
		
		//读取版本号
		rs.execute("select cversion from license");
		String cVersion = "";
		if(rs.next()){
			cVersion = Util.null2String(rs.getString("cversion"));
		}
		String wVersion = Util.null2String(Prop.getPropValue("wxinterfaceversion","version"));
		result.put("cversion", cVersion);
		result.put("wversion", wVersion);
		
		//判断PoppupRemindInfoUtil文件是否修改
		int ispop = 0;
		File popfile = new File(GCONST.getRootPath()+"classbean"+File.separatorChar+"weaver"+File.separatorChar+"workflow"+File.separatorChar+"msg"+File.separatorChar+"PoppupRemindInfoUtil.class");
		if(!popfile.exists()){
			popfile = new File(GCONST.getRootPath()+"WEB-INF"+File.separatorChar+"classes"+File.separatorChar+"weaver"+File.separatorChar+"workflow"+File.separatorChar+"msg"+File.separatorChar+"PoppupRemindInfoUtil.class");
		}
		if(popfile.exists()){
			long modifytime = popfile.lastModified();
			Date d = new Date(modifytime);
			Format simpleFormat = new SimpleDateFormat("yyyy'-'MM'-'dd");
			String modifydate = simpleFormat.format(d);
			if(TimeUtil.dateInterval("2015-03-17", modifydate)>=0) ispop = 1;
			//80版本特殊处理一下
			if(ispop==0){
				if(cVersion.startsWith("8")){
					if(TimeUtil.dateInterval("2014-12-22", modifydate)>=0) ispop = 1;
				}
			}
		}
		result.put("ispop", ispop);
		
		//检测是否可访问集成平台
		int isaccesswx = 0;
		if(!ticket.equals("")) {
			//通过访问微信平台接口验证票据是否有效
			boolean wxcheck = InterfaceUtil.wxCheckLogin(ticket);
			if(wxcheck) isaccesswx = 1;
		}
		result.put("isaccesswx", isaccesswx);
		
		//ecology是否集群
		result.put("iscluster", WxInterfaceInit.isCluster()?1:0);
	}else if(operation.equals("getDataList")){//获取流程文档等数据，采用调整模式解决60版本下中文乱码问题
		request.getRequestDispatcher("/mobile/plugin/ComponentList.jsp?"+request.getQueryString()).forward(request, response);
		return;
	}
	//获取下属人员
	else if(operation.equals("getSubUsers")){
		//判断编码
		if(this.isutf8()){
			response.setContentType("application/json;charset=UTF-8");
		}
		String userid = Util.null2String(fu.getParameter("userid"));
		int status = 1;
		String msg = "";
		JSONArray ja = new JSONArray();
		User user = HrmUserVarify.checkUser (request , response) ;
		if(user==null) {
			msg = "用户登录失败";
		}else{
			//默认取当前用户
			if("".equals(userid)) userid = user.getUID()+"";
			try{
				rs.executeSql("select id,lastname from HrmResource where managerid="+userid+" and (status = 0 or status = 1 or status = 2 or status = 3) and status != 10"
						+" and (accounttype is null or accounttype=0) "
						+" and " + ((!"oracle".equals(rs.getDBType()))?" loginid<>'' and ":"")+" loginid is not null order by dsporder,id");
				JSONObject jo = null;
				while(rs.next()){
					jo = new JSONObject();
					jo.put("userid",Util.null2String(rs.getString("id")));
					jo.put("username",Util.null2String(rs.getString("lastname")));
					ja.put(jo);
				}
				result.put("userList", ja);
				status = 0;
			}catch(Exception e){
				e.printStackTrace();
				msg = e.getMessage();
			}
		}
		result.put("status", status);
		result.put("msg", msg);
	}else if(operation.equals("sendMsg")){
		int status = 1;String msg = "";JSONObject jo = new JSONObject();
		try{
			String ticket = Util.null2String(fu.getParameter("ticket"));
			String mobiles = Util.null2String(fu.getParameter("mobiles"));
			String content = Util.null2String(fu.getParameter("content"));
			if(!ticket.equals("")&&!"".equals(mobiles)&&!"".equals(content)){
				boolean wxcheck = InterfaceUtil.wxCheckLogin(ticket);
				//wxcheck = true;
				if(wxcheck){
					String[] mobiless = mobiles.split(",");
					for(String mobile:mobiless){
						if(!mobile.equals("")){
							jo.put(mobile, sms.sendSMS(mobile, content));
						}
					}
					status = 0;
				}else{
					msg = "token验证失败";
				}
			}else{
				msg = "相关参数不完整";
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		result.put("status", status);
		result.put("msg", msg);
		result.put("result", jo);
	}
	//获取组织架构
	else if(operation.equals("loadOrganization")){
		User user = HrmUserVarify.checkUser (request , response) ;
		if(user==null){
			return;	
		}
		if(this.isutf8()){
			response.setContentType("application/json;charset=UTF-8");
		}
		
		List<Map<String, String>> cData = new ArrayList<Map<String, String>>();
		List<Map<String, String>> sData = new ArrayList<Map<String, String>>();
		List<Map<String, String>> dData = new ArrayList<Map<String, String>>();
		List<Map<String, String>> rData = new ArrayList<Map<String, String>>();
		int o = Util.getIntValue(Util.null2String(fu.getParameter("o")));
		int ot = Util.getIntValue(Util.null2String(fu.getParameter("ot")));

		String name = "";
		String type = "";
		String id = "";
		String mobile = "";
		String tel = "";
		String mail = "";

		if(ot==0&&o==0) {
			cci.setTofirstRow();
			cci.next();

			Map<String, String> data = new HashMap<String, String>();
			data.put("type", "0");
			data.put("name", cci.getCompanyname());
			data.put("id", cci.getCompanyid());
			cData.add(data);
		} else if(ot==0&&o>0) {
			sci.setTofirstRow();
			
			Map<String, String> data = null;
			while(sci.next()) {
				if(Util.getIntValue(sci.getCompanyid())!=o || Util.getIntValue(sci.getSupsubcomid(), 0)!=0 || Util.getIntValue(sci.getCompanyiscanceled())==1) continue;
				
				data = new HashMap<String, String>();
				data.put("type", "1");
				data.put("name", sci.getSubCompanyname());
				data.put("id", sci.getSubCompanyid());
				sData.add(data);
			}
		} else if(ot==1&&o>0) {
			
			Map<String, String> data = null;
			getUserList(user,ot,o,rData);
			
			dci.setTofirstRow();
			while(dci.next()) {
				int departmentsupdepid = Util.getIntValue(dci.getDepartmentsupdepid(), 0);
				if(departmentsupdepid > 0) {
					int supdepididx = dci.getIdIndexKey(""+departmentsupdepid);
					if(supdepididx == -1) departmentsupdepid = 0;
				}
				
				if(Util.getIntValue(dci.getSubcompanyid1())!=o || departmentsupdepid!=0 || Util.getIntValue(dci.getDeparmentcanceled())==1) continue;
				
				data = new HashMap<String, String>();
				data.put("type", "2");
				data.put("name", dci.getDepartmentname());
				data.put("id", dci.getDepartmentid());
				dData.add(data);
			}
			
			sci.setTofirstRow();
			while(sci.next()) {
				
				if(Util.getIntValue(sci.getSupsubcomid())!=o || Util.getIntValue(sci.getSupsubcomid(), 0)==0 || Util.getIntValue(sci.getCompanyiscanceled())==1) continue;
				
				data = new HashMap<String, String>();
				data.put("type", "1");
				data.put("name", sci.getSubCompanyname());
				data.put("id", sci.getSubCompanyid());
				sData.add(data);
			}
		} else if(ot==2&&o>0) {
			
			Map<String, String> data = null;
			getUserList(user,ot,o,rData);
			
			dci.setTofirstRow();
			while(dci.next()) {
				if(Util.getIntValue(dci.getDepartmentsupdepid())!=o || Util.getIntValue(dci.getDepartmentsupdepid(), 0)==0 || Util.getIntValue(dci.getDeparmentcanceled())==1) continue;

				data = new HashMap<String, String>();
				data.put("type", "2");
				data.put("name", dci.getDepartmentname());
				data.put("id", dci.getDepartmentid());
				dData.add(data);
			}
		}
		
		result.put("cdata", cData);
		result.put("sdata", sData);
		result.put("ddata", dData);
		result.put("rdata", rData);
	}else if(operation.equals("getBirthdayUserList")){//获取过生日的人员列表
		int status = 1;String msg = "";
		String ticket = Util.null2String(fu.getParameter("ticket"));//用票据验证是否来源于微信平台
		if(InterfaceUtil.wxCheckLogin(ticket)){
			try{
				int remindType = Util.getIntValue(fu.getParameter("remindType"),1);//1当天 2提前几天
				int beforeDay = Util.getIntValue(fu.getParameter("beforeDay"),0);//提前几天
				String nowDate = TimeUtil.getCurrentDateString();
				if(remindType!=1){
					nowDate = TimeUtil.dateAdd(nowDate, beforeDay);
				}
				if(null!=nowDate&&!nowDate.equals("")){
					nowDate = nowDate.substring(5);
					rs.executeSql("select id,loginid,lastname,departmentid,subcompanyid1 from HrmResource where birthday like '%"+nowDate+"' and (status =0 or status =1 or status =2 or status =3) order by dsporder,id");
					String userdbids = "",userids = "",usernames = "",shownames = "",departids = "",subcompanyids = "";
					while(rs.next()){
						String id = Util.null2String(rs.getString("id"));
						userdbids += ","+id;
						if(InterfaceUtil.getUserkeytype().equals("loginid")){
							id = Util.null2String(InterfaceUtil.transUserId(id,1));
						}
						userids +=","+id;
						String lastname = Util.null2String(rs.getString("lastname"));
						usernames += ","+lastname;
						String subcompanyid = Util.null2String(rs.getString("subcompanyid1"));
						subcompanyids += ","+subcompanyid;
						String departid = Util.null2String(rs.getString("departmentid"));
						departids += ","+departid;
						String deptName = dci.getDepartmentname(departid);
						shownames += ","+lastname+"-"+deptName;
					}
					if(!userdbids.equals("")){
						userdbids = userdbids.substring(1);
					}
					if(!userids.equals("")){
						userids = userids.substring(1);
					}
					if(!usernames.equals("")){
						usernames = usernames.substring(1);
					}
					if(!shownames.equals("")){
						shownames = shownames.substring(1);
					}
					if(!subcompanyids.equals("")){
						subcompanyids = subcompanyids.substring(1);
					}
					if(!departids.equals("")){
						departids = departids.substring(1);
					}
					result.put("userdbids", userdbids);
					result.put("userids", userids);
					result.put("usernames", usernames);
					result.put("shownames", shownames);
					result.put("subcompanyids", subcompanyids);
					result.put("departids", departids);
					status = 0;
				}else{
					msg = "获取的生日日期为null或者为空";
				}
			}catch(Exception e){
				e.printStackTrace();
				msg = "获取OA中过生日人员程序出现异常:"+e.getMessage();
			}
		}else{
			msg = "ticket无效";
		}
		result.put("status", status);
		result.put("msg", msg);
		
	}else if(operation.equals("getUserByTag")){//根据手机号/账号 查询OA人员
		String ticket = Util.null2String(fu.getParameter("ticket"));//用票据验证是否来源于微信平台
		if(InterfaceUtil.wxCheckLogin(ticket)){
			
			String tagvalue = Util.null2String(fu.getParameter("tagvalue"));
			int bindtype = Util.getIntValue(fu.getParameter("bindtype"),1);
			String ipaddress = Util.null2String(fu.getParameter("ipaddress"));//IP地址
			String clienttype = Util.null2String(fu.getParameter("clienttype"));//app类型
			int status = 1;String msg = "";
			String outuserid = "";//ec系统的用户id 唯一标识
			String outsysuserid = "";
			String outsysloginid = "";
			if(!"".equals(tagvalue)){
				try{
					//获取配置文件中的用户标识
					String userkeytype = Util.null2String(InterfaceUtil.getUserkeytype());
					if(bindtype==1){//手机号查询
						rs.executeSql("select id from HrmResource where (status = 0 or status = 1 or status = 2 or status = 3) and status != 10 and (accounttype is null or accounttype=0) and mobile='"+tagvalue+"' order by id");
						if(rs.next()){
							outuserid = Util.null2String(rs.getString("id"));
							outsysloginid = InterfaceUtil.transUserId(outuserid, 1);
							//执行登录操作
							int dologin = Util.getIntValue(fu.getParameter("dologin"),0);
							if(dologin==1){
								Map loginres = ps.login(outuserid, "zh_cn", ipaddress);
								result.put("sessionkey", Util.null2String((String)loginres.get("sessionkey")));
								
								//记录登录日志
								InterfaceUtil.writeLoginLog(outuserid,ipaddress,clienttype);
							}
			
							if(userkeytype.equalsIgnoreCase("id")){
								outsysuserid = outuserid;//outsysuserid 外部系统userkey
							}else{
								outsysuserid = outsysloginid;
							}
							status = 0;
						}else{
							msg = "找不到OA人员";
						}
					}else if(bindtype==2){//账号查找
						outuserid = InterfaceUtil.transUserId(tagvalue, 0);
						if(!"".equals(outuserid)){
							outsysloginid = InterfaceUtil.transUserId(outuserid, 1);
							if(userkeytype.equalsIgnoreCase("id")){
								outsysuserid = outuserid;//outsysuserid 外部系统userkey
							}else{
								outsysuserid = outsysloginid;
							}
							status = 0;
						}else{
							msg = "找不到OA人员";
						}
					}else if(bindtype==3){//数据库id查找
						outsysloginid = InterfaceUtil.transUserId(tagvalue, 1);
						if(!"".equals(outsysloginid)){
							outuserid = InterfaceUtil.transUserId(outsysloginid, 0);
							if(userkeytype.equalsIgnoreCase("id")){
								outsysuserid = outuserid;//outsysuserid 外部系统userkey
							}else{
								outsysuserid = outsysloginid;
							}
							status = 0;
						}else{
							msg = "找不到OA人员";
						}
					}
					
				}catch(Exception e){
					msg = "Ecology端查找人员出现异常:"+e.getMessage();
				}
			}else{
				msg = "tagvalue值为空";
			}
			//获取所有上级部门已经上级分部
			String deptid = ResourceComInfo.getDepartmentID(outuserid);
			String alldeptids = getAllSupDepartment(deptid,null,1,deptid);
			result.put("alldeptids", alldeptids);
			String subid = ResourceComInfo.getSubCompanyID(outuserid);
			String allsubids = getAllSupSubCompany(subid,null,1,subid);
			result.put("allsubids", allsubids);
			result.put("seclevel",ResourceComInfo.getSeclevel(outuserid));
			result.put("outuserid", outuserid);
			result.put("outsysloginid", outsysloginid);
			result.put("outsysuserid", outsysuserid);
			result.put("status", status);
			result.put("msg", msg);
		}else{
			result.put("status", 1);
			result.put("msg", "ticket无效");
		}
		
	} else if(operation.equals("getDocNames")) {
		//if(this.isutf8()){
			response.setContentType("application/json;charset=UTF-8");
		//}
		String selectids = fu.getParameter("selectids");
		String from = "";
		String fromids = "";
		String showstr = "";
		String includereplay = "";

		if(!"".equals(selectids)) {
			String[] t = new String[]{"","",""};
			//t = Util.TokenizerString2(selectids,"|");
			t = selectids.split("\\|", -1);
			if(t==null||t.length==0) t = new String[]{"","",""};
			if(t.length>2) {
				from = t[0];           //文档类型
				fromids = t[1];        //文档id
				//includereplay = t[2];  //是否包含回复
			}
			showstr = ",";

			if(fromids!=null&&!"".equals(fromids)){
				String[] tid = Util.TokenizerString2(fromids,",");
				for(int i=0;tid!=null&&i<tid.length;i++){
					if(tid[i]==null||"".equals(tid[i])) continue;
					if("1".equals(from)){
						showstr = showstr + docNewsComInfo.getDocNewsname(tid[i]) +",";
					} else if("2".equals(from)){
						showstr = showstr + secCategoryComInfo.getSecCategoryname(tid[i])+",";
					} else if("3".equals(from)){
						showstr = showstr + docTreeDocFieldComInfo.getTreeDocFieldName(tid[i])+",";
					} else if("4".equals(from)){
						showstr = showstr + docComInfo.getDocname(tid[i])+",";
					}
				}
			}
			result.put("success", true);
			result.put("docNames", showstr.substring(1));
		} else {
			result.put("success", false);
			result.put("message", "selectids参数为空");
		}
	}
	
	JSONObject jro = null;
	if(result!=null){
		jro = new JSONObject(result);
	}
	out.println(jro);
%>
<%!
	public boolean isutf8(){
		/* //判断编码
		 File bf = new File(GCONST.getRootPath()+"systeminfo"+File.separatorChar+"init_wev8.jsp");
		if(bf.exists()){
			return true;
		}
		return false;  */
		
		return WxInterfaceInit.isIsutf8();
	}
	public void getUserList(User user,int type,int pid,List<Map<String,String>> rData){
		try{
			String sql = "";//加入分权控制
			try{
				Class pvm = Class.forName("weaver.hrm.appdetach.AppDetachComInfo");
				Method m = pvm.getDeclaredMethod("getScopeSqlByHrmResourceSearch",String.class);
				sql = (String)m.invoke(pvm.newInstance(),user.getUID()+"");
			}catch(Exception e){
				
			}
			if(sql.equals("")){//没有分权 从缓存获取人员
				ResourceComInfo resourceComInfo = new ResourceComInfo();
				resourceComInfo.setTofirstRow();
				DepartmentComInfo dci = new DepartmentComInfo();
				while(resourceComInfo.next()){
					if(type==1){
						if(Util.getIntValue(resourceComInfo.getSubCompanyID())!=pid||
								dci.getIdIndexKey(resourceComInfo.getDepartmentID())>-1||
								(Util.getIntValue(resourceComInfo.getStatus())!=0&&Util.getIntValue(resourceComInfo.getStatus())!=1&&
								Util.getIntValue(resourceComInfo.getStatus())!=2&&Util.getIntValue(resourceComInfo.getStatus())!=3)) 
							continue;
					}else if(type==2){
						if(Util.getIntValue(resourceComInfo.getDepartmentID())!=pid||
								(Util.getIntValue(resourceComInfo.getStatus())!=0&&Util.getIntValue(resourceComInfo.getStatus())!=1&&
								Util.getIntValue(resourceComInfo.getStatus())!=2&&Util.getIntValue(resourceComInfo.getStatus())!=3)) 
							continue;
					}
					String id = Util.null2String(resourceComInfo.getResourceid());
					String lastname = Util.null2String(resourceComInfo.getLastname());
					String mobile = Util.null2String(resourceComInfo.getMobile()).trim();
					String tel = Util.null2String(resourceComInfo.getTelephone()).trim();
					String mail = Util.null2String(resourceComInfo.getEmail()).trim();
					getUserInfo(3,id,lastname,mobile,tel,mail,rData);
				}
			}else{
				RecordSet rs = new RecordSet();
				String sql2 = "select * from HrmResource where (status =0 or status =1 or status =2 or status =3)";
				if(type==1){
					sql2+=" and subcompanyid1 = "+pid+" and (departmentid = '' or departmentid is null)";
				}else if(type==2){
					sql2+=" and departmentid = "+pid;
				}
				sql2+=" and "+sql+" order by dsporder asc,id asc";
				rs.executeSql(sql2);
				while(rs.next()){
					String id = Util.null2String(rs.getString("id"));
					String lastname = Util.null2String(rs.getString("lastname"));
					String mobile = Util.null2String(rs.getString("mobile"));
					String tel = Util.null2String(rs.getString("telephone"));
					String mail = Util.null2String(rs.getString("email"));
					getUserInfo(3,id,lastname,mobile,tel,mail,rData);
				}
			}
		}catch(Exception e){
			
		}
	}
	
	public void getUserInfo(int type,String id,String name,String mobile,String tel,String mail,List<Map<String,String>> rData){
		Map<String,String> data = new HashMap<String, String>();
		data.put("type",type+"");
		data.put("name",name);
		data.put("id",id);
		data.put("mobile",mobile);
		data.put("tel", tel);
		data.put("mail",mail);
		rData.add(data);
	}
	private String getAllSupDepartment(String subId,DepartmentComInfo rs,int loopLevel,String str){
	    try{
		    if(rs==null){
		        rs = new DepartmentComInfo();
		    }
		    String depid = rs.getDepartmentsupdepid(subId);
		    if (depid==null||depid.equals("") || depid.equals("0")||depid.equals(subId)
		    		||(","+str+",").indexOf(","+depid+",")>-1||loopLevel>1000)
		        return str;
		    str += ","+depid;
		    loopLevel++;
		    str = getAllSupDepartment(depid,rs,loopLevel,str);
		}catch(Exception e){
			
		}
	    return str;
	}
	private String getAllSupSubCompany(String subId,SubCompanyComInfo rs,int loopLevel,String str){
	    try{
		    if(rs==null){
		        rs = new SubCompanyComInfo();
		    }
		    String subpid = rs.getSupsubcomid(subId);
		    if (subpid==null||subpid.equals("") || subpid.equals("0")||subpid.equals(subId)
		    		||(","+str+",").indexOf(","+subpid+",")>-1||loopLevel>10000)
		        return str;
		    str += ","+subpid;
		    loopLevel++;
		    str = getAllSupSubCompany(subpid,rs,loopLevel,str);
		}catch(Exception e){
			
		}
	    return str;
	}
	
	 public static String stampToDate(String s){
	        String res;
	        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
	        long lt = new Long(s);
	        Date date = new Date(lt);
	        res = simpleDateFormat.format(date);
	        return res;
	 }
	 public static String stampToTime(String s){
	        String res;
	        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("HH:mm:ss");
	        long lt = new Long(s);
	        Date date = new Date(lt);
	        res = simpleDateFormat.format(date);
	        return res;
	 }
%>
