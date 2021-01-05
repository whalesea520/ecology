<%@ page import="weaver.general.Util,java.io.*,weaver.file.ExcelFile" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.templetecheck.*" %>
<%@ page import="java.io.File,weaver.conn.RecordSet" %>
<%@page import="weaver.general.GCONST"%>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
	FileUtil fileUtil = new FileUtil();
	String delflageids = Util.null2String(request.getParameter("delflageids"));
	String delids = Util.null2String(request.getParameter("delids"));
	String method = Util.null2String(request.getParameter("method"));
	
	
	String filename =  Util.null2String(request.getParameter("filename"));
	String filepath =  Util.null2String(request.getParameter("filepath"));
	String fileinfo =  Util.null2String(request.getParameter("fileinfo"));
	int filetype =  Util.getIntValue(Util.null2String(request.getParameter("filetype")));
	String kbversion =  Util.null2String(request.getParameter("kbversion"));
	String sqlwhere  =Util.null2String(request.getParameter("sqlwhere")); 
	String qcnumber  =Util.null2String(request.getParameter("qcnumber")); 
	int issystem = 0;	//客户添加配置文件维护默认为非系统文件，可以删除

	// CheckUtil checkutil = new CheckUtil();
	ConfigOperation configOperation = new ConfigOperation();
	if("getdelids".equals(method)) {
		String newdelids = configOperation.getDelIds(delids);
		
		if(!delids.equals("")) {
			out.print("{\"status\":\"ok\",\"delids\":\""+newdelids+"\"}");
		} else {
			out.print("{\"status\":\"no\"}");
		}
	}
	
	if("delete".equals(method)) {
		boolean res = false;
		res = configOperation.deleteConfig(delflageids);
		if(res) {
			out.print("{\"status\":\"ok\"}");
		} else {
			out.print("{\"status\":\"no\"}");
		}
	}
	
	if("add".equals(method)){
		boolean res = false;
		res = configOperation.addConfig(filename,filepath,fileinfo,kbversion,filetype,qcnumber);
		if(res) {
			out.print("{\"status\":\"ok\"}");
		} else {
			out.print("{\"status\":\"no\"}");
		}
	}
	
	if("edit".equals(method)){
		int id =  Util.getIntValue(request.getParameter("id"));
		boolean res = false;
		res = configOperation.editConfig(id,filename,filepath,fileinfo,kbversion,filetype,qcnumber);
		if(res) {
			out.print("{\"status\":\"ok\"}");
		} else {
			out.print("{\"status\":\"no\"}");
		}
	}
	
	
	//检查路径是否存在
	if ("checkpath".equals(method)) {
		String fp = filepath.substring(0, filepath.lastIndexOf("\\"));
		String fn = filepath.substring(filepath.lastIndexOf("\\") + 1, filepath.length());
			File dir = new File(fileUtil.getPath(GCONST.getRootPath() + filepath));
			File fpdir = new File(fileUtil.getPath(GCONST.getRootPath() + fp));
			if (fn.toLowerCase().indexOf(".xml") != -1 || fn.toLowerCase().indexOf(".properties") != -1) {
				if (fpdir.exists()) {
					if (dir.exists()) {
						out.print("{\"status\":\"ok\"}");
					} else {
						out.print("{\"status\":\"no\",\"errorinfo\":\"文件路径下不存在该文件\"}");
					}
				} else {
					out.print("{\"status\":\"no\",\"errorinfo\":\"文件路径不正确\"}");
				}
			} else {
				if (fpdir.exists()) {
					out.print("{\"status\":\"ok\"}");
				} else {
					out.print("{\"status\":\"no\"}");
				}
			}
		}


	if ("checklocalfile".equals(method)) {
		CheckConfigFile checkConf = new CheckConfigFile();
		Map<String, String> map = null;
		String checkids = Util.null2String(request.getParameter("checklocalids"));
		if (checkids != "" && !checkids.replaceAll(",", "").equals("")) {
			map = checkConf.getDiffIds(checkids);
		}
		String proCheckIds = map.get("1");
		String xmlCheckIds = map.get("2");
		RecordSet rs = new RecordSet();
		String notExsitFiles = "";
		String errorFiles="";
		if (xmlCheckIds != null && xmlCheckIds != "") {
			XMLUtil xmlutil = new XMLUtil();
			String sql = "select filepath,filename from configFileManager where isdelete=0 and id in(" + xmlCheckIds + ")";
			rs.execute(sql);
			while (rs.next()) {
				String path = GCONST.getRootPath() + rs.getString("filepath");
				String name = rs.getString("filename");
				File file = new File(fileUtil.getPath(path));
				if (!file.exists()) {
					notExsitFiles = notExsitFiles + name + ",";
					continue;
				} 
				
				
				xmlutil = new XMLUtil(path);
				String xmlstr = xmlutil.getXMLString();
				if (xmlstr == null || xmlstr.equals("")) {
					errorFiles = errorFiles + name + ",";
				}
			}
		}
		if (proCheckIds != null && proCheckIds != "") {
			String sql = "select filepath,filename from configFileManager where isdelete=0 and id in(" + proCheckIds + ")";
			rs.execute(sql);
			while (rs.next()) {
				String path = GCONST.getRootPath() + rs.getString("filepath");
				String name = rs.getString("filename");
	
				File file = new File(fileUtil.getPath(path));
				if (!file.exists()) {
					notExsitFiles = notExsitFiles + name + ",";
				} 
			}
		}
		if (notExsitFiles.endsWith(",")) {
			notExsitFiles = notExsitFiles.substring(0, notExsitFiles.length() - 1);
		}
		if (errorFiles.endsWith(",")) {
			errorFiles = errorFiles.substring(0, errorFiles.length() - 1);
		}
		
		String errorMsg="";
		if (!notExsitFiles.replaceAll(",", "").equals("")) {
			errorMsg+="--检测到本地以下文件不存在:\\n" + notExsitFiles+"\\n";
		} 
		
		if (!errorFiles.replaceAll(",", "").equals("")) {
			errorMsg += "--检测到本地以下Xml文件不规范:\\n" + errorFiles ;
		} 
		if(!errorMsg.equals("")){
			out.print("{\"status\":\"no\",\"msg\":\""+errorMsg + "\"}");//检查配置文件中
			return;
		}else{
			out.print("{\"status\":\"ok\"}");
			return;
		}
	}
	
	if("oneKeyConfig".equals(method)){
		String checkids = Util.null2String(request.getParameter("checklocalconfigids"));
		if(checkids.equals("")){
			out.print("{\"status\":\"no\",\"msg\":\"无法获取记录的id\"}");
			return;
		}
		if(checkids.endsWith(",")){
			checkids = checkids.substring(0,checkids.length()-1);
		}
		//单个文件检查时做一下校验
		if(checkids.split(",").length==1){
			RecordSet rs = new RecordSet();
			String sql = "select filepath from configFileManager where isdelete=0 and id ="+checkids;
			rs.execute(sql);
			if(rs.next()){
				String path = GCONST.getRootPath() + rs.getString("filepath");
				File file = new File(fileUtil.getPath(path));
				if (!file.exists()) {
					out.print("{\"status\":\"no\",\"msg\":\"一键配置失败，本地找不到该文件\"}");
					return ;
				} 
			}
		}
		String result = configOperation.oneKeyConfig(checkids);
		if (result == null||result.equals("")) {
			out.print("{\"status\":\"ok\",\"msg\":\"一键配置修改成功\"}");
			return;
		} else if(checkids.indexOf(",")!=-1) {
			out.print("{\"status\":\"no\",\"msg\":\"以下"+result.split(",").length+"个文件批量一键配置完成，请逐个在\\\"检查配置\\\"中查看失败项：<br>"+  result.replace(",", "<br>") +"\"}");
			return;
		}else{
			out.print("{\"status\":\"no\",\"msg\":\"一键配置修改完成，请在\\\"检查配置\\\"中查看失败项\"}");
			return;
		}
	}
	if("needRestart".equals(method)){
		String checkids = Util.null2String(request.getParameter("checklocalconfigids"));
		if(checkids==null){
			out.print("{\"status\":\"no\",\"msg\":\"无法获取记录的id\"}");
			return;
		}
		if(checkids.endsWith(",")){
			checkids = checkids.substring(0,checkids.length()-1);
		}
		boolean needRestart = false;
		RecordSet rs = new RecordSet();
		String sql1 = "select filename from configFileManager where isdelete=0 and id in ("+checkids+")";
		rs.execute(sql1);
		while(rs.next()){
			if(Util.null2String(rs.getString("filename")).toLowerCase().endsWith("web.xml")){
				needRestart = true;
				break;
			}
		}
		if(needRestart){
			out.print("{\"status\":\"ok\"}");
			return;
		}else{
			out.print("{\"status\":\"no\"}");
			return;
		}
	}
%>
