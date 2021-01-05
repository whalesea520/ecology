<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.lang.Runtime" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.directory.InitialDirContext" %>
<%@ page import="weaver.ldap.LdapUtil" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.AES" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="javax.naming.directory.ModificationItem" %>
<%@ page import="javax.naming.directory.BasicAttribute" %>
<%@ page import="javax.naming.directory.DirContext" %>
<%@page import="java.util.ArrayList"%>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
request.setCharacterEncoding("UTF-8");
LdapUtil ldaputil = LdapUtil.getInstance();
String ldapserverurl2 = "";
String	ldaparea = "";
String factoryclass = "";
String ldapuser = Util.null2String(request.getParameter("ldapuser"));
String ldappasswd = Util.null2String(request.getParameter("ldappasswd"));
String needSynOrg = "";
String passingCert = "";
String sql = "select * from ldapset";
rs.executeSql(sql);
if(rs.next()) {
	needSynOrg = Util.null2String(rs.getString("needSynOrg"));
	ldapserverurl2 = Util.null2String(rs.getString("ldapserverurl2"));
	ldaparea = Util.null2String(rs.getString("ldaparea"));
	factoryclass = Util.null2String(rs.getString("factoryclass"));
	passingCert = Util.null2String(rs.getString("passingCert"));
	//ldapuser = Util.null2String(rs.getString("ldapuser"));
	//ldappasswd = Util.null2String(rs.getString("ldappasswd"));
}
String res = "";
String name = "";
String[] ldaparealist = ldaparea.split(",");
String keystorepath = request.getParameter("keystorepath");
String keystorepassword = request.getParameter("keystorepassword");

//String password=new BaseBean().getPropValue("AESpassword", "pwd");
//if(password.equals("")){//缺省加密密码
//	password="1";
//}
//ldappasswd=weaver.general.AES.decrypt(ldappasswd,password);
Hashtable env = new Hashtable();
env.put(Context.INITIAL_CONTEXT_FACTORY, factoryclass);
env.put(Context.PROVIDER_URL, ldapserverurl2);
env.put(Context.SECURITY_PROTOCOL, "ssl");
env.put(Context.SECURITY_AUTHENTICATION, "simple");
env.put("com.sun.jndi.ldap.connect.pool", "false");
//new BaseBean().writeLog("keystorepath:"+keystorepath);
//new BaseBean().writeLog("keystorepassword:"+keystorepassword);
System.clearProperty("javax.net.ssl.trustStore");
System.clearProperty("javax.net.ssl.trustStorePassword");
//System.out.println("javax.net.ssl.trustStore:"+System.getProperty("javax.net.ssl.trustStorePassword"));
//System.out.println("javax.net.ssl.trustStorePassword:"+System.getProperty("javax.net.ssl.trustStorePassword"));

//是否绕过证书
if(passingCert.equalsIgnoreCase("y")){
	env.put("java.naming.ldap.factory.socket", "weaver.ldap.passingCert.DummySSLSocketFactory");
}else{
	System.setProperty("javax.net.ssl.trustStore", keystorepath); 
	System.setProperty("javax.net.ssl.trustStorePassword", keystorepassword);
}
ldapuser = ldaputil.buildPrincipal(ldapuser);//处理账号中的特殊字符

String domain = Util.null2String(ldaparea);
domain = ldaputil.changeStr(domain);
domain = ldaputil.buildDomain(domain);

ArrayList<String> array = new ArrayList<String>();
if("y".equals(needSynOrg)) {
	rs.executeSql("select * from ldapsetdetail");
	while(rs.next()) {
		array.add(rs.getString("subcompanydomain"));
	}
} else {
	String[] arr_baseDN = Util.TokenizerString2(domain, "|");
	for(int j = 0; j < arr_baseDN.length; j++) {
		array.add(arr_baseDN[j]);
	}
}
String baseDN = "";
InitialDirContext initialContext = null;
for (int i = 0; i < array.size(); i++) {
	try {
		if(array.get(i) == null || "".equals(array.get(i))) {
			continue;
		}
		//是否绕过证书
		if(!passingCert.equalsIgnoreCase("y")){
		if(keystorepassword == null || "".equals(keystorepassword)) {
			res = res + "no,";
			continue;
		}
		}
		baseDN = array.get(i).substring(array.get(i).toUpperCase().indexOf("DC"));
		baseDN = ldaputil.buildDomain(baseDN);//处理domain中的特殊字符
	    if(ldapuser.toUpperCase().indexOf("CN=")<0&&ldapuser.toUpperCase().indexOf(",OU=")<0
	    	&&ldapuser.toUpperCase().indexOf(",DC=")<0){  //原来的配置，默认在users组下
	    	env.put(Context.SECURITY_PRINCIPAL, "cn=" + ldapuser + ",cn=users," + baseDN);
	    	name = "cn=" + ldapuser + ",cn=users," + baseDN;
	    } else{
	    	env.put(Context.SECURITY_PRINCIPAL, ldapuser);
	    	name = ldapuser;
		}
	env.put(Context.SECURITY_CREDENTIALS, ldappasswd);
	initialContext = new InitialDirContext(env);
	String newQuotedPassword = "\"" + ldappasswd + "\"";
	byte[] pwd;
	pwd = newQuotedPassword.getBytes("UTF-16LE");
	ModificationItem modificationItem[] = new ModificationItem[1];
	modificationItem[0] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, new BasicAttribute("unicodePwd", pwd));
	//System.out.println(pwd+"-----userDN:"+name);
	initialContext.modifyAttributes(name,modificationItem);
	res = res + "ok,";

	initialContext.close();

	break;
} catch(Exception e) {
	if(e.toString().indexOf("timestamp check failed") > -1) {
		res = res + "1,";
	} else if(e.toString().indexOf("java.security.InvalidAlgorithmParameterException") > -1) {
		res = res + "2,";
	} else if(e.toString().indexOf("java.security.NoSuchAlgorithmException") > -1) {
		res = res + "3,";
	} else {
		res = res + "no,";
	}

	try {

		if(initialContext != null) {
			initialContext.close();
		}
	} catch(Exception e1) {
		e1.printStackTrace();
	}
	e.printStackTrace();
	continue;
}
}
out.print(res);



%>
