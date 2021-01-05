
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="java.util.List"%>
<%@ page import="java.io.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.general.GCONST"%>
<jsp:useBean id="ConfigInfo" class="com.weaver.function.ConfigInfo" scope="page"/>
<%@ page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.general.BaseBean"%>
<%@ page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@ page import="weaver.hrm.company.CompanyTreeNode"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/jsp/systeminfo/init_wev8.jsp"%> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML>
<HEAD>
<style>
* {
font-size:18px;
line-height:20px;
}
</style>

</HEAD>
<%
BaseBean base = new BaseBean();
String message = Util.null2String(request.getParameter("message"));
String id = Util.null2String(request.getParameter("id"));
String label = Util.null2String(request.getParameter("label"));
String ishistory  = Util.null2String(request.getParameter("ishistory"));
String values = "";
String close = "false";
if("content".equals(message)) {

	String contentpath = "";
	String contentdoc = "";
	File f = null;
	String name = "";
	if("0".equals(label)) {
		String date = base.getPropValue("package","package");
		contentpath = GCONST.getRootPath()+"packagedescription"+File.separatorChar+
				"tongyong"+File.separatorChar+date+File.separatorChar+"content"+File.separatorChar;
		f = new File(contentpath);
		name = name+date;
	} else {
		contentpath = GCONST.getRootPath()+"packagedescription"+File.separatorChar+
				label+File.separatorChar+"content"+File.separatorChar;
		f = new File(contentpath);
		name = name+label;
	}
	String downloadpath = contentpath;
	String[] flist = f.list();
	if(flist==null) {
		return;
	}
	if(flist.length==1) {
		contentdoc = ""+flist[0];
		name = contentdoc;
		
		//downloadpath= java.net.URLEncoder.encode(downloadpath);
		if(!contentdoc.endsWith(".txt")) {
			name = URLEncoder.encode(name,"UTF-8");
			response.sendRedirect("/downloadfile.do?label="+label+"&name="+name+"&message="+message);
			return;
		} else {
			downloadpath= downloadpath+contentdoc;
			//FileReader file = new FileReader(downloadpath);
			//BufferedReader buffer = new BufferedReader(file);
			BufferedReader buffer = new BufferedReader(new InputStreamReader(new FileInputStream(downloadpath), "UTF-8"));  
			String line = "";
			while((line = buffer.readLine())!=null) {
				values  = values + line +"<br>";
			}
		}
	} else if(flist.length>1){
		response.sendRedirect("/downloadfile.do?label="+label+"&name=content.zip"+"&message="+message);
		return;
	}
	

	//String path =ConfigInfo.getEcologypath()+ File.separatorChar + "packagedescription"+File.separatorChar+label+File.separatorChar;
	//File f = new File(path);
	//File[] files = f.list(new DirFilter(".txt"));
	//String line = ;
	//for(int i= 0;i < files.length;i++) {
	//	//FileInputStream stream = new FileInputStream(files[i]);
	////	FileReader reader = new FileReader(files[i]);
	//	BufferedReader buffer = new BufferedReader(reader);
	//	while((line = buffer.readLine())!=null) {
	//		values = values + line + "<br>";
	//	}
	//}
	
	
} else if("config".equals(message)){
	
	
	String configpath = "";
	String configdoc = "";
	String name = "";
	File f = null;
	if("0".equals(label)) {
		String date = base.getPropValue("package","package");
		configpath = GCONST.getRootPath()+"packagedescription"+File.separatorChar+
				"tongyong"+File.separatorChar+date+File.separatorChar+"configuration"+File.separatorChar;
		f = new File(configpath);	
		name = name+date;
	} else {
		configpath = GCONST.getRootPath()+"packagedescription"+File.separatorChar+
				label+File.separatorChar+"configuration"+File.separatorChar;
		f = new File(configpath);
		name = name+label;
	}
	String downloadpath = configpath;	
	String[] flist = f.list();
	if(flist==null) {
		return;
	}
	if(flist.length==1) {
		configdoc = ""+flist[0];
		name = configdoc;
		
		if(!configdoc.endsWith(".txt")) {
			name = URLEncoder.encode(name,"UTF-8");
			response.sendRedirect("/downloadfile.do?label="+label+"&name="+name+"&message="+message);
			return;
		} else {
			downloadpath= downloadpath+configdoc;
			//FileReader file = new FileReader(downloadpath);
			BufferedReader buffer = new BufferedReader(new InputStreamReader(new FileInputStream(downloadpath), "UTF-8"));  
			//BufferedReader buffer = new BufferedReader(file);
			String line = "";
			while((line = buffer.readLine())!=null) {
				values  = values + line +"<br>";
			}
		} 
	} else if(flist.length>1) {
		response.sendRedirect("/downloadfile.do?label="+label+"&name=configuration.zip&message="+message);
		return;
	}
	
} else if("detail".equals(message)) {
	RecordSet.execute(" select * from ecologypackageinfo where id="+id);
	if(RecordSet.next()) {
		String type1 = "";
		if(RecordSet.getString("type").equals("0")) {
			type1 = "需求";
		} else{
			type1 = "通用";
		}
		values = "名称："+RecordSet.getString("name");
		values = values + "<br>" +"类型："+ type1;
		values = values + "<br>" + "升级包时间："+RecordSet.getString("lastDate");
		values = values + "<br>" + "内容："+RecordSet.getString("content");
	}
	
} else {
	String currentDate = TimeUtil.getCurrentDateString();
	StringBuffer buffer = new StringBuffer();
   	String logfile = GCONST.getRootPath() + "sysupgradelog" + File.separatorChar+currentDate+".log" ;
	try {
		//System.out.println(logfile);
		File log = new File(logfile);
		if(log.exists()) {
		       BufferedReader input=new BufferedReader(new FileReader(logfile));
		       String line = "";
			   while((line=input.readLine())!=null){
				   buffer.append(""+line+"<br>");
			   }
		}
		values = buffer.toString();
	} catch(Exception e) {
		e.printStackTrace();
	}
}

values = values.replaceAll("<p>","");
values = values.replaceAll("</p>","");
values = values.replaceAll("<br>","\n");
values = values.replaceAll("<","&lt;");
values = values.replaceAll(">","&gt;");
//System.out.println("values:"+values); 
%>
<script type="text/javascript">
var dialog = null;
try{
	dialog = parent.parent.getDialog(parent);
}catch(e){}


function close() {
	if(dialog){
		dialog.close();
	}else{
		window.parent.close();
	} 
}

</script>
<BODY>
<pre>
<code>
<%=values %>
</code>
</pre>
</BODY>
</HTML>

