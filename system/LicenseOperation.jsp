
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.file.FileUpload"%>
<%@ page import="weaver.file.FileManage"%>
<jsp:useBean id="LN" class="ln.LN" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="FunctionUpgrade" class="com.weaver.upgrade.FunctionUpgrade" scope="page" />

<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>

<%
String message = "0" ;
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = "LICENSE" ;
String needfav ="1";
String needhelp ="";

FileUpload fu = new FileUpload(request,false);
FileManage fm = new FileManage();
String code = Util.null2String(fu.getParameter("code")).trim();
char[]  c_code=new char[16];
new FileReader(GCONST.getRootPath()+File.separator+"WEB-INF"+File.separator+"code.key").read(c_code);

String realcode=new String(c_code).trim();
if(code.equals("")){//message=7 表示code为空或者upload出错
	message = "7";
	response.sendRedirect("InLicense.jsp?message="+message+"&code="+code);
	return; 
}
if(!realcode.equals(code)&&!code.equals("")){ 
	//out.println(code);  
%> 
<%=SystemEnv.getHtmlLabelName(129308, 7)%>
<%return;
}  
int fileid = 0 ;
try {
	//message=0 表示License信息错误;message=1 表示成功;message=2 表示数据库连接或者执行出错;message=3 表示License文件上传出错;
	//message=4 表示License信息错误，License过期;message=5 表示License信息错误，注册用户数大于License申请人数;message=6 表示选择的License文件不正确
	fileid = Util.getIntValue(fu.uploadFiles("license"),0);
	
	String filename = fu.getFileName(); 
	
	String sql = "select isaesencrypt,aescode,filerealpath from imagefile where imagefileid = "+fileid;  
	boolean r1 = RecordSet.executeSql(sql);
	
	if(!r1) message="2";//message=2 表示数据库连接或者执行出错
	
	String uploadfilepath="";
	String isaesencrypt ="";
	String aescode="";
	if(RecordSet.next()){
		uploadfilepath = RecordSet.getString("filerealpath");
		isaesencrypt = RecordSet.getString("isaesencrypt");
		aescode = RecordSet.getString("aescode");
	}
	if(!uploadfilepath.equals("")){
		String cid = Util.null2String(LN.getCid());
		String licensefilepath2 = GCONST.getRootPath()+"license"+File.separatorChar+LN.OutLicensecode()+".license" ;
		String licensefilepathOriBak = GCONST.getRootPath()+"license"+File.separatorChar+LN.OutLicensecode()+"_bak.license" ;
		try{
			fm.copy(licensefilepath2,licensefilepathOriBak);
		}catch(Exception e){}
		fm.copy(uploadfilepath,licensefilepath2,isaesencrypt,aescode);
		 String ncid = LN.ReadFromFile2(licensefilepath2);
		 if(!cid.equals("") && (!ncid.equals(cid) || ncid.equals(""))){
			message = "-99";
			fm.DeleteFile(uploadfilepath);
		 }else{
			 LN.removeLicenseComInfo();
			 LN.ReadFromFile(licensefilepath2);
			 message = LN.InLicense();
		 }
		 //fm.DeleteFile(licensefilepath2);
		//System.out.println("...............................message------>"+message);
		//if(!message.equals("-99")){
		if(message.equals("1")){
			String licensefilepath = GCONST.getRootPath()+"license"+File.separatorChar+LN.OutLicensecode()+".license" ;
			fm.copy(uploadfilepath,licensefilepath,isaesencrypt,aescode);
			fm.DeleteFile(uploadfilepath);
			LN.removeLicenseComInfo();
	        LN.ReadFromFile(licensefilepath);
			message = LN.InLicense();
			
			FunctionUpgrade.doUpgrade();
		}else{
			try{
				fm.copy(licensefilepathOriBak,licensefilepath2);
			}catch(Exception e){}
			LN.removeLicenseComInfo();
	        LN.ReadFromFile(licensefilepath2);
			//message = LN.InLicense();
			if("".equals(message) || "-99".equals(message)){
				//System.out.println(".22222..............................message------>"+message);
				RecordSet.writeLog("...............................message------>"+message);
				message = "0";
			}
		}
	}
}catch(Exception e) {
	RecordSet.writeLog(e);
    message = "3" ;//message=3 表示License文件上传出错
}

response.sendRedirect("InLicense.jsp?message="+message+"&code="+new Date().getTime());

%>

