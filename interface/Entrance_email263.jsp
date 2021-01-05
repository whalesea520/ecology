
<%@page import="weaver.interfaces.outter.CheckIpNetWork"%>
<%@page import="weaver.interfaces.outter.OutterUtil"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.lang.reflect.*" %>
<%@page import="weaver.outter.OutterDisplayHelper"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%

	String sysid = Util.null2String(request.getParameter("id"));//系统标识
	
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
	//String password = "";
	String logintype = "1";//访问类型
	String requesttype = "";//请求方式
	String encrypttype = "";//加密算法
	String baseparam1 = "";//账号参数名
	String baseparam2 = "";//密码参数名
	
	String encryptclass = "";
	String encryptmethod = "";
	Object object = null;
	Method method = null;
	
	

	int basetype1 = 0;//是否使用ecology账号
	int basetype2 = 0;//是否使用ecology密码

	String autologinflag="";  //是否内外网自动登录
	
	String cid="";
	String domain="";
	String uid="";
	String key="";

	
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
		
		
		baseparam2 = Util.null2String(RecordSet.getString("baseparam2"));
		
		
		basetype1 = Util.getIntValue(RecordSet.getString("basetype1"),0);
		basetype2 = Util.getIntValue(RecordSet.getString("basetype2"),0);
		iurl = Util.null2String(RecordSet.getString("iurl"));
		ourl = Util.null2String(RecordSet.getString("ourl"));
		
		
		typename = Util.null2String(RecordSet.getString("typename"));
		
		autologinflag = Util.null2String(RecordSet.getString("autologin"));  //内外网自动登录
		
		cid = Util.null2String(RecordSet.getString("email263_cid"));  //
		domain = Util.null2String(RecordSet.getString("email263_domain"));  //
		key = Util.null2String(RecordSet.getString("email263_key"));  //
	}

	RecordSet.executeSql("select account,password,logintype from outter_account where sysid='"+ sysid + "' and userid=" + user.getUID());
	if (RecordSet.next()) {
		account = RecordSet.getString("account");
		
		if (basetype1 == 1) {//使用ecology账号
			account = user.getLoginid();
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
			String password = (String) session.getAttribute("password");
			//插入数据
			String date = TimeUtil.getCurrentDateString();
			String time = TimeUtil.getOnlyCurrentTimeString();
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
	
	if (serverurl.indexOf("AccountSetting.jsp") > -1) {
		response.sendRedirect(serverurl);
		return;
	}
	
	String requesttypestr = requesttype;
 
	String sign = "";  //sign = 32位MD5 （ cid=单点登录接口账号&domain=邮箱域名&uid=用户ID&key=单点登录接口密钥 ） 
	String param_get = "";

	    sign=Util.getEncrypt("cid="+cid+"&domain="+domain+"&uid="+account+"&key="+key);
		param_get+=(param_get.length()==0?"":"&")+"cid"+"="+cid+"";
		param_get+=(param_get.length()==0?"":"&")+"domain"+"="+domain+"";
		param_get+=(param_get.length()==0?"":"&")+"uid"+"="+account+"";
		param_get+=(param_get.length()==0?"":"&")+"sign"+"="+sign+"";
	
		
				String url = "";
				if(serverurl.indexOf("?")>-1){
				url=serverurl+"&"+param_get;
				}else{
				url=serverurl+"?"+param_get;
				}
				//new weaver.general.BaseBean().writeLog("sso url : " + url) ;
				out.println("<script language='javascript'>");
				out.println("window.location.href='"+url+"'");
				out.println("</script>");
				
			
		
	
	
%>





