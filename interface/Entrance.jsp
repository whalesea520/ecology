
<%@page import="weaver.interfaces.outter.CheckIpNetWork"%>
<%@page import="weaver.interfaces.outter.OutterUtil"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.lang.reflect.*" %>
<%@page import="weaver.outter.OutterDisplayHelper"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%

	String sysid = Util.null2String(request.getParameter("id"));//系统标识
	String gopage = Util.null2String(request.getParameter("gopage"));//登陆后直接显示哪个页面
	//权限判断
	//得到有权限查看的集成登录
OutterDisplayHelper ohp=new OutterDisplayHelper();
String sqlright=ohp.getShareOutterSql(user);
String sql="select sysid from outter_sys a where sysid='"+sysid+"' and EXISTS (select 1 from ("+sqlright+") b where a.sysid=b.sysid )";
RecordSet.executeSql(sql);

if(RecordSet.getCounts()<1){
	response.sendRedirect("/notice/noright.jsp");
 	return;
}

	String account = "";
	String password = "";
	String logintype = "1";//访问类型
	String requesttype = "";//请求方式
	String encrypttype = "";//加密算法
	String baseparam1 = "";//账号参数名
	String baseparam2 = "";//密码参数名
	
	String encryptclass = "";
	String encryptmethod = "";
	Object object = null;
	Method method = null;
	
	String urlparaencrypt1 = "";//是否加密账号参数名
	String encryptcode1 = "";//加密密钥
	String urlparaencrypt2 = "";//是否加密密码参数名
	String encryptcode2 = "";//加密密钥
	String urlparaencrypt = "";//是否加密参数串加密
	String encryptcode = "";//加密密钥

	int basetype1 = 0;//是否使用ecology账号
	int basetype2 = 0;//是否使用ecology密码
	String urlencodeflag="";  //是否编码
	String autologinflag="";  //是否内外网自动登录
	String encryptclassId="";  //自定义加密算法id
	String encodeflag =""; //登录系统编码方式

	
	RecordSet.executeSql("select t1.*,t2.encryptclass as encryptclass1,t2.encryptmethod as encryptmethod1 from outter_sys t1 LEFT JOIN outter_encryptclass t2 on t1.encryptclassId=t2.id where sysid='"+ sysid + "'");
	String serverurl = "AccountSetting.jsp?sysid=" + sysid;
	String iurl = "";
	String ourl = "";
	String typename = "";
	if (RecordSet.next()) {
		requesttype = Util.null2String(RecordSet.getString("requesttype"));
			if(requesttype.equals("")||requesttype==null){
			requesttype="POST";
		}
		encrypttype = Util.null2String(RecordSet.getString("encrypttype"));
		
		encryptclass = Util.null2String(RecordSet.getString("encryptclass1"));
		encryptmethod = Util.null2String(RecordSet.getString("encryptmethod1"));
		
		baseparam1 = Util.null2String(RecordSet.getString("baseparam1"));
		urlparaencrypt1 = Util.null2String(RecordSet.getString("urlparaencrypt1"));//是否加密
		encryptcode1 = Util.null2String(RecordSet.getString("encryptcode1"));//加密密钥
		
		baseparam2 = Util.null2String(RecordSet.getString("baseparam2"));
		urlparaencrypt2 = Util.null2String(RecordSet.getString("urlparaencrypt2"));//是否加密
		encryptcode2 = Util.null2String(RecordSet.getString("encryptcode2"));//加密密钥
		
		basetype1 = Util.getIntValue(RecordSet.getString("basetype1"),0);
		basetype2 = Util.getIntValue(RecordSet.getString("basetype2"),0);
		iurl = Util.null2String(RecordSet.getString("iurl"));
		ourl = Util.null2String(RecordSet.getString("ourl"));
		urlparaencrypt = Util.null2String(RecordSet.getString("urlparaencrypt"));//是否加密
		encryptcode = Util.null2String(RecordSet.getString("encryptcode"));//加密密钥
		
		typename = Util.null2String(RecordSet.getString("typename"));
		urlencodeflag = Util.null2String(RecordSet.getString("urlencodeflag"));
		autologinflag = Util.null2String(RecordSet.getString("autologin"));  //内外网自动登录
		encodeflag = Util.null2String(RecordSet.getString("encodeflag"));  //内外网自动登录
		//encryptclassId = Util.null2String(RecordSet.getString("encryptclassId"));  //自定义加密算法id
	}
	
	// 集成登录日志
	String date = TimeUtil.getCurrentDateString();
	String time = TimeUtil.getOnlyCurrentTimeString();
	RecordSet.executeSql("insert into outter_entrance_log(userid,sysid,createdate,createtime) values("+user.getUID()+",'"+sysid+"','"+date+"','"+time+"')") ;
	
	if("7".equals(typename)) {  //263邮箱
		response.sendRedirect("Entrance_email263.jsp?id="+sysid);
		return;
	}
    if("8".equals(typename)) {  //coremail邮箱
		response.sendRedirect("Entrance_CoreMail.jsp?id="+sysid);
		return;
	}
	if(!"".equals(encryptclass)&&!"".equals(encryptmethod))
	{
		try
		{
			Class clazz = Class.forName(encryptclass);
			object = clazz.newInstance();
			Class [] paramtype = new Class[1];
			paramtype[0] = java.lang.String.class;
			method = clazz.getMethod(encryptmethod, paramtype);
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	RecordSet.executeSql("select account,password,logintype from outter_account where sysid='"+ sysid + "' and userid=" + user.getUID());
	if (RecordSet.next()) {
		account = RecordSet.getString("account");
		password = RecordSet.getString("password");
		//解密
			String password_new="";
        if(!password.equals("")){
        	password_new=SecurityHelper.decryptSimple(password);
        }
        if(!password_new.equals("")){
        	password=password_new;
        }
		if (basetype1 == 1) {//使用ecology账号
			//account = user.getLoginid();
			//RecordSet rs_loginid = new RecordSet();
			//rs_loginid.executeSql("select loginid from hrmresource where id='"+user.getUID()+"'");
			//rs_loginid.next();
			//account = Util.null2String(rs_loginid.getString(1));
			account = user.getLoginid();
			
		}
		if (basetype2 == 1) {//使用ecology密码
			password = (String) session.getAttribute("password");
		}
		if(autologinflag.equals("1"))  //开启内外网自动登录
		{
			CheckIpNetWork checkipnetwork = new CheckIpNetWork();
			String clientIP = request.getRemoteAddr();
			boolean checktmp = checkipnetwork.checkIpSeg(clientIP,sysid);//true表示在网段之外,false表示在网段之内
			if(checktmp){//true表示在网段之外
				serverurl = ourl;
			}else{
				serverurl = iurl;//false表示在网段之内
			}
		}else{
		logintype = RecordSet.getString("logintype");
		if (logintype.equals("1"))
			serverurl = iurl;
		else
			serverurl = ourl;
		}
	}else{//对于使用ecology账号和使用ecology密码，自动在outter_account中加入数据，避免用户进入配置页面
		//使用ecology账号、使用ecology密码，或者同时没有参数名
		if ((basetype1 == 1 && basetype2 == 1 && !baseparam1.equals("") && !baseparam2.equals("")) 
			|| (baseparam1.equals("") && baseparam2.equals(""))
			|| (baseparam1.equals("") && basetype2 == 1 && !baseparam2.equals(""))
			|| (baseparam2.equals("") && basetype1 == 1 && !baseparam1.equals(""))
		) {
			//参数明细表中参数类型为用户录入的参数数量为0，自动添加数据才可启用
			RecordSet.executeSql("select * from outter_sysparam where paramtype=1 and sysid='"+ sysid + "' order by indexid");
			if(RecordSet.getCounts()==0){
			account = user.getLoginid();
			password = (String) session.getAttribute("password");
			//插入数据
			RecordSet1.executeSql("insert into outter_account(sysid,userid,logintype,createdate,createtime,modifydate,modifytime) values('"+sysid+"',"+user.getUID()+","+logintype+",'"+date+"','"+time+"','"+date+"','"+time+"')") ;
			//返回地址
			if(autologinflag.equals("1"))  //开启内外网自动登录
		  	{
			CheckIpNetWork checkipnetwork = new CheckIpNetWork();
			String clientIP = request.getRemoteAddr();
			boolean checktmp = checkipnetwork.checkIpSeg(clientIP,sysid);//true表示在网段之外,false表示在网段之内
			if(checktmp){//true表示在网段之外
				serverurl = ourl;
			}else{
				serverurl = iurl;//false表示在网段之内
			}
		}else{
			if (logintype.equals("1")){
				serverurl = iurl;
			}else{
				serverurl = ourl;
			}
			}
		}
		}
	}
	if("6".equals(typename)) {
		response.sendRedirect("EntranceQQEmail.jsp?id="+sysid);
		return;
	}
	//[80][90][客户]集成登录-解决不设置账号、密码参数名选择用户录入单点登录会跳转到账号设置页面的问题
	if((!baseparam1.equals("")&&basetype1 == 0&&"".equals(account))||(!baseparam2.equals("")&&basetype2 == 0&&"".equals(password))){
		 serverurl = "AccountSetting.jsp?sysid=" + sysid;
	}
	if (serverurl.indexOf("AccountSetting.jsp") > -1) {
		response.sendRedirect(serverurl);
		return;
	}
	
	if(encodeflag.equals("1")){  //GBK编码
		response.sendRedirect("/interface/Entrance_gbk.jsp?id="+sysid);
		return;
	}
	
	if("1".equals(typename)) {
		response.sendRedirect("NcEntrance.jsp?id="+sysid);
		return;
	}
	if("5".equals(typename)){//NC6系列单点登录
		response.sendRedirect("Nc6Entrance.jsp?id="+sysid);
		return;
	}
	
	String requesttypestr = requesttype;
	if("1".equals(encrypttype)&&"1".equals(urlparaencrypt1)&&!"".equals(account))
	{
		encryptcode1 = "".equals(encryptcode1)?"ecology":encryptcode1;
		account = SecurityHelper.encrypt(encryptcode1,account);
	}
	else if("2".equals(encrypttype)&&"1".equals(urlparaencrypt1)&&!"".equals(account))
	{
		if(null!=object&&null!=method)
		{
			try
			{
				Object [] paramvalue = new Object[1];
				paramvalue[0] = account;
				account = (String)method.invoke(object, paramvalue);
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
		}
	}else if("3".equals(encrypttype)&&"1".equals(urlparaencrypt1)&&!"".equals(account))  //标准MD5加密
	{
		account = OutterMD5.encrypt(account,"UTF-8");
	}
	if("1".equals(encrypttype)&&"1".equals(urlparaencrypt2)&&!"".equals(password))
	{
		encryptcode2 = "".equals(encryptcode2)?"ecology":encryptcode2;
		password = SecurityHelper.encrypt(encryptcode2,password);
	}
	else if("2".equals(encrypttype)&&"1".equals(urlparaencrypt2)&&!"".equals(password))
	{
		if(null!=object&&null!=method)
		{
			try
			{
				Object [] paramvalue = new Object[1];
				paramvalue[0] = password;
				password = (String)method.invoke(object, paramvalue);
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
		}
	}else if("3".equals(encrypttype)&&"1".equals(urlparaencrypt2)&&!"".equals(password))
	{
		password = OutterMD5.encrypt(password,"UTF-8");
	}
	String param_get = "";
	if(serverurl.indexOf("ftp://")>-1){
		String ftpurl = "ftp://" + account + ":" + password + "@" + serverurl.substring(6);
		response.sendRedirect(ftpurl);
		return;
	}else{
		String str = "<html><body>\n"
				+ "<form name=Loginform action='"
				+ serverurl
				+ "' method="+requesttypestr+" target='_self'><INPUT type='hidden' NAME='gopage' VALUE='"
				+ gopage + "'>";
				
		OutterUtil tu1=new OutterUtil();//qc344968 [80][90][客户]集成登录-解决表达式中采用时间戳参数时，每次均会有毫秒级误差的问题
		Map nametoValue =tu1.expressionValueMap(sysid,user,(String)session.getAttribute("password"));		
		RecordSet.executeSql("select * from outter_sysparam where sysid='"+ sysid + "' order by indexid");
		while (RecordSet.next()) {
			int paramtype = Util.getIntValue(RecordSet.getString("paramtype"), 0);
			String paramname = RecordSet.getString("paramname");
			String paramvalue = RecordSet.getString("paramvalue");
			String dparaencrypt = RecordSet.getString("paraencrypt");//是否加密
			String dencryptcode = RecordSet.getString("encryptcode");//加密密钥
			if (paramtype == 0) {//固定值
				;
			} else if (paramtype == 1) {//用户输入
				RecordSet1.executeSql("select * from outter_params where sysid='"
								+ sysid
								+ "' and userid="
								+ user.getUID()
								+ " and paramname='" + paramname + "'");
				if (RecordSet1.next())
					paramvalue = RecordSet1.getString("paramvalue");
	
			} else if (paramtype == 2) {//分部
				paramvalue = "" + user.getUserSubCompany1();
			} else if (paramtype == 3) {//部门
				paramvalue = "" + user.getUserDepartment();
			}else if(paramtype == 4){  //表达式
				
				OutterUtil tu=new OutterUtil();
				paramvalue = tu.getExpressionValue(paramvalue,sysid,user,(String)session.getAttribute("password"),nametoValue);//qc344968 [80][90][客户]集成登录-解决表达式中采用时间戳参数时，每次均会有毫秒级误差的问题
			}else if(paramtype == 5){ //表达式参数
				continue;  
			}
			if("1".equals(encrypttype)&&"1".equals(dparaencrypt)&&!"".equals(paramvalue))
			{
				dencryptcode = "".equals(dencryptcode)?"ecology":dencryptcode;
				paramvalue = SecurityHelper.encrypt(dencryptcode,paramvalue);
			}
			else if("2".equals(encrypttype)&&"1".equals(dparaencrypt)&&!"".equals(paramvalue))
			{
				if(null!=object&&null!=method)
				{
					try
					{
						Object [] paramvalue1 = new Object[1];
						paramvalue1[0] = paramvalue;
						paramvalue = (String)method.invoke(object, paramvalue1);
					}
					catch(Exception e)
					{
						e.printStackTrace();
					}
				}
			}else if("3".equals(encrypttype)&&"1".equals(dparaencrypt)&&!"".equals(paramvalue))
			{
				paramvalue = OutterMD5.encrypt(paramvalue,"UTF-8");
			}
			str += "<INPUT type='hidden' NAME='" + paramname + "' VALUE='"+  paramvalue+ "'>";
			param_get+=(param_get.length()==0?"":"&")+paramname+"="+encodestr(paramvalue,urlencodeflag);
		}
		if(!"".equals(baseparam1)){
			str += "<INPUT type='hidden' NAME='" + baseparam1 + "' VALUE='" + account+ "'>" ;
			param_get+=(param_get.length()==0?"":"&")+baseparam1+"="+encodestr(account,urlencodeflag)+"";
		}
		if(!"".equals(baseparam2)){
			str += "<INPUT type='hidden' NAME='" + baseparam2 + "' VALUE='" + password + "'>";
			param_get+=(param_get.length()==0?"":"&")+baseparam2+"="+encodestr(password,urlencodeflag)+"";
		}
			Enumeration em = request.getParameterNames();
		if(null!=em)
		{
					while(em.hasMoreElements())
			{
							String temppname = Util.null2String((String)em.nextElement());
				if(!"id".equals(temppname)&&!"gopage".equals(temppname))
							{
									String temppvalue = Util.null2String(request.getParameter(temppname));
									str += "<INPUT type='hidden' NAME='" + temppname + "' VALUE='"+ temppvalue + "'>";
				//	param_get+=(param_get.length()==0?"":"&")+temppname+"="+encodestr(temppvalue,urlencodeflag)+"";
				}
			}
		}
		if (sysid.equals("1")) {
			//todo,add yourselves html fields
			str += "</form></body></html>"
					+ "<script>Loginform.submit();</script>";
			out.print(str);
		} else if (sysid.equals("2")) {
			//todo,add yourselves html fields
			str += "</form></body></html>"
					+ "<script>Loginform.submit();</script>";
			out.print(str);
		} else {
			if(requesttypestr.equalsIgnoreCase("POST")){
				str += "</form></body></html>"
					+ "<script>Loginform.submit();</script>";
					RecordSet.writeLog(str);
				out.print(str);
			}else if(requesttypestr.equalsIgnoreCase("GET")){
			    if (typename.equals("9")) {
			        response.sendRedirect("K3CloudEntrance.jsp?id="+sysid+"&uid="+user.getUID());
                }
				String url = "";
				if(serverurl.indexOf("?")>-1){
				url=serverurl+"&"+param_get;
				}else{
					//System.out.println(param_get);
					if(param_get!=""&&param_get!=null){
						 url=serverurl+"?"+param_get;
					 }else{
					 	url=serverurl;
					 	}
				}
				//new weaver.general.BaseBean().writeLog("sso url : " + url) ;
				out.println("<script language='javascript'>");
				/*if(urlencodeflag.equals("1")){
				out.println("window.location.href=encodeURI('"+url+"')");
				}else{*/
				out.println("window.location.href='"+url+"'");
				//}
				out.println("</script>");
			}
		}
	}
	
%>
<%!
public String encodestr(String str,String flag){
if(flag.equals("1")){
	return java.net.URLEncoder.encode(str);
}else{
	return str;
	}
}
 %>




