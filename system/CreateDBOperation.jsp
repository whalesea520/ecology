<%@ page import="java.util.*,java.io.*,java.sql.*,weaver.general.*" %>
<jsp:useBean id="EditProperties" class="weaver.system.EditProperties" scope="page" />
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<BODY>
<%

String sqlFilePath = GCONST.getSqlPath() ;

String dbserver = Util.null2String(request.getParameter("dbserver"));
String dbport = Util.null2String(request.getParameter("dbport"));    
String dbname = Util.null2String(request.getParameter("dbname"));
String sidname = Util.null2String(request.getParameter("sidname"));
String username = Util.null2String(request.getParameter("username"));
String password = Util.null2String(request.getParameter("password"));
String dbtype = Util.null2String(request.getParameter("dbtype"));
String isexist = Util.null2String(request.getParameter("isexist"));
String code = Util.null2String(request.getParameter("code"));
char[]  c_code=new char[16];
new FileReader(GCONST.getRootPath()+File.separator+"WEB-INF"+File.separator+"code.key").read(c_code);
String realcode=new String(c_code).trim();
if(!realcode.equals(code)){
%>
无效的验证码！
<%return;}
if(dbtype.equals("")) dbtype="1";
String url = "" ;
String forname = "" ;
Connection conn = null ;
String message="" ;
String path = "";
String linepara = "";
String lastsqlname = "" ;
boolean isOracle12c = false;
try {

	if(dbtype.equals("1")&&sidname.equals("MSSQLSERVER")){
		url = "jdbc:sqlserver://"+dbserver+":"+dbport+";DatabaseName=master" ;
		forname = "com.microsoft.sqlserver.jdbc.SQLServerDriver" ;
		path = request.getRealPath("/data/SQLServer");
		linepara = "go" ;
	}else if(dbtype.equals("1")&&!sidname.equals("MSSQLSERVER")){
		url = "jdbc:sqlserver://"+dbserver+":"+dbport+";instanceName="+sidname+";DatabaseName=master" ;
		forname = "com.microsoft.sqlserver.jdbc.SQLServerDriver" ;
		path = request.getRealPath("/data/SQLServer");
		linepara = "go" ;
	}else if(dbtype.equals("2")){
		url = "jdbc:oracle:thin:@"+dbserver+":"+dbport+":"+dbname ;
		forname = "oracle.jdbc.OracleDriver" ;
		path = request.getRealPath("/data/Oracle");
		linepara = "/" ;
	}else if(dbtype.equals("3")){
		url = "jdbc:db2:"+dbserver+":"+dbname ;	
		forname = "COM.ibm.db2.jdbc.net.DB2Driver" ;
		path = request.getRealPath("/data/DB2");
		linepara = ";" ;
	}

	Driver driver = (Driver)Class.forName(forname).newInstance();

	DriverManager.registerDriver(driver);
	Properties props = new Properties();
	props.put("user", username);
	props.put("password", password);
	props.put("CHARSET", "ISO");
		try{
			conn = DriverManager.getConnection(url, props);
		}catch(Exception e){
			String urlTem = "";
			// 如果报错，判断是否是oracle，是：则修改url，继续 偿试用12c的方式 连接数据库
			if(dbtype.equals("2")){
				try{
					urlTem = "jdbc:oracle:thin:@"+dbserver+":"+dbport+"/"+dbname ;
					conn = DriverManager.getConnection(urlTem, props);
					isOracle12c = true;
				}catch(Exception e2){
					e2.printStackTrace();
					throw e;
				}
			}else{
				throw e;
			}
		}
	Statement st = conn.createStatement() ;
	String sqlstr = "" ;
	String sqlfile = "";
	String readline = "" ;

	if(isexist.equals("1")){
		if(dbtype.equals("1")){
			sqlstr = " use master ";
				st.executeUpdate(sqlstr) ;
			sqlstr = " use "+dbname;
				st.executeUpdate(sqlstr) ;
		}
		message="";
	}else{
		if(dbtype.equals("1")){
			sqlstr = " use master ";
				st.executeUpdate(sqlstr) ;
			//sqlstr = " create database "+dbname;
			//	st.executeUpdate(sqlstr) ;
			sqlstr = " use "+dbname;
				st.executeUpdate(sqlstr) ;
		}
		File dir = new File(path);
		String fileList[] = dir.list();

		for(int i=0;i<fileList.length;i++){
			for(int j=i+1;j<fileList.length;j++){
				if(fileList[i].compareTo(fileList[j])>0){
					String tmpfileList=fileList[i];
					fileList[i]=fileList[j];
					fileList[j]=tmpfileList;
				}
			}
		}
		for(int i=0;i<fileList.length;i++){

			sqlfile = path + "/" + fileList[i] ;

			System.out.println(TimeUtil.getCurrentTimeString()+":"+fileList[i] +" is running .... <br>") ;
//			out.flush() ;

			//out.println(fileList[i]+" ");
			readline = "" ;
			sqlstr = "" ;
			File fin = new File(sqlfile);

			BufferedReader is
				  = new BufferedReader(new InputStreamReader(new FileInputStream(fin)));
			 
			while ((readline = is.readLine()) != null)   {
				readline = readline.trim() ;
				if(!readline.equalsIgnoreCase(linepara)) sqlstr += " "+ readline ;
				else if( !(sqlstr.trim()).equals("") ) {
					message += sqlstr+"<br>" ;
					st.executeUpdate(sqlstr) ;
					sqlstr = "" ;
					message = "" ;
				} 

			}
			is.close();
			lastsqlname = fileList[i];

			System.out.println(TimeUtil.getCurrentTimeString()+":"+lastsqlname+" execute success ! <br>") ;
//			out.flush() ;
		}  
		message="";
	}
}catch(Exception e) { message += e.toString(); }
finally {
	try { conn.close() ;} catch(Exception ex) {}
}

if(message.equals("")){ 
	if(dbtype.equals("1")&&!sidname.equals("MSSQLSERVER")){
		EditProperties.editsidProp(dbserver,dbport,dbname,username,password,dbtype,sidname);
		EditProperties.editIndex();
		if(!lastsqlname.equals("")) EditProperties.editDblog(dbserver,dbname,dbtype,lastsqlname);
		message=" Success ! " ;
		message+="<br><br>请重启Resin服务，在Resin启动成功后再点击下方的登入系统！";
		message+="<br><br><a href=/index.htm target=_top>登入系统</a>";

		//response.sendRedirect("/index.htm");
	}else{
        EditProperties.editProp(dbserver,dbport,dbname,username,password,dbtype,isOracle12c);
		EditProperties.editIndex();
		if(!lastsqlname.equals("")) EditProperties.editDblog(dbserver,dbname,dbtype,lastsqlname);
		message=" Success ! " ;
		message+="<br><br>请重启Resin服务，在Resin启动成功后再点击下方的登入系统！";
		message+="<br><br><a href=/index.htm target=_top>登入系统</a>";

		//response.sendRedirect("/index.htm");
	}
}else {
	message=" error ! message is below : <br>" + message;
	message+="<br><br><a href=/system/CreateDB.jsp>返回</a>";
}

%>
<%=message%>
</BODY>
</HTML>