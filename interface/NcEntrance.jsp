<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.lang.reflect.*" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.net.URLConnection" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="sun.misc.BASE64Decoder" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.net.InetAddress"%>
<%@ page import="java.net.UnknownHostException"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<%@page import="weaver.interfaces.outter.CheckIpNetWork"%>
<%@page import="weaver.interfaces.outter.OutterUtil"%>	
	
<%
    String sysid = Util.null2String(request.getParameter("id"));//系统标识
	String account = "";
	String password = "";
	String logintype = "1";//访问类型
	String requesttype = "";//请求方式
	String encrypttype = "";//加密算法
	String baseparam1 = "username";//账号参数名
	String baseparam2 = "password";//密码参数名
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
	String autologinflag="";  //是否内外网自动登录
	RecordSet.executeSql("select t1.*,t2.encryptclass as encryptclass1,t2.encryptmethod as encryptmethod1 from outter_sys t1 LEFT JOIN outter_encryptclass t2 on t1.encryptclassId=t2.id where sysid='"+ sysid + "'");
	String serverurl = "AccountSetting.jsp?sysid=" + sysid;
	String iurl = "";
	String ourl = "";
	String ncaccountcode = "";
	if (RecordSet.next()) {
		requesttype = RecordSet.getString("requesttype");
		if(requesttype.equals("")||requesttype==null){
			requesttype="POST";
		}
		encrypttype = RecordSet.getString("encrypttype");
		
		encryptclass = RecordSet.getString("encryptclass1");
		encryptmethod = RecordSet.getString("encryptmethod1");
		baseparam1 = RecordSet.getString("baseparam1");
		urlparaencrypt1 = RecordSet.getString("urlparaencrypt1");//是否加密
		encryptcode1 = RecordSet.getString("encryptcode1");//加密密钥
		baseparam2 = RecordSet.getString("baseparam2");
		urlparaencrypt2 = RecordSet.getString("urlparaencrypt2");//是否加密
		encryptcode2 = RecordSet.getString("encryptcode2");//加密密钥
		basetype1 = Util.getIntValue(RecordSet.getString("basetype1"),0);
		basetype2 = Util.getIntValue(RecordSet.getString("basetype2"),0);
		iurl = RecordSet.getString("iurl");
		ourl = RecordSet.getString("ourl");
		ncaccountcode = RecordSet.getString("ncaccountcode");
		urlparaencrypt = RecordSet.getString("urlparaencrypt");//是否加密
		encryptcode = RecordSet.getString("encryptcode");//加密密钥
		autologinflag = Util.null2String(RecordSet.getString("autologin"));  //内外网自动登录
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
        if(!password.equals("")){
        password=SecurityHelper.decryptSimple(password);
        }
		if (basetype1 == 1) {//使用ecology账号
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
	}
	
	if (serverurl.indexOf("AccountSetting.jsp") > -1) {
		response.sendRedirect(serverurl);
		return;
	}
	
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
	}else if("3".equals(encrypttype)&&"1".equals(urlparaencrypt1)&&!"".equals(account))
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
	String strParam = "";
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
			if (RecordSet1.next()) {
				paramvalue = RecordSet1.getString("paramvalue");
			}
		} else if (paramtype == 2) {//分部
			paramvalue = "" + user.getUserSubCompany1();
		} else if (paramtype == 3) {//部门
			paramvalue = "" + user.getUserDepartment();
		}else if(paramtype == 4){  //表达式
			OutterUtil tu=new OutterUtil();
			paramvalue = tu.getExpressionValue(paramvalue,sysid,user,(String)session.getAttribute("password"));
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
		strParam += "&" + paramname + "=" + paramvalue;
	}

	String value=request.getRequestedSessionId();
	String ncnode=Util.null2String(request.getParameter("tourl"));
	String key =value;
		
    SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
	String workdate = f.format(new Date());

	URL url = new URL(serverurl+"/service/RegisterServlet?key="+key+"&accountcode="+ncaccountcode+"&workdate="+workdate+"&language=simpchn&usercode="+account+"&pwd="+password+strParam);
	URLConnection uc = url.openConnection();

	uc.setConnectTimeout(24000);
	uc.setReadTimeout(24000);
	uc.setDoOutput(true);
	
	HttpURLConnection httpconn = (HttpURLConnection) uc;
	String str_return = httpconn.getResponseMessage();

	if (str_return.equals("OK")) {
		response.sendRedirect(serverurl+"/login.jsp?key="+key+"&ncnode="+ncnode);
	}
%>