<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,java.io.*,org.dom4j.io.*" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="org.dom4j.*" %>
<%@ page import="weaver.templetecheck.*"%>
<%@ page import="weaver.general.GCONST"%>
<%@ page import="weaver.hrm.*,weaver.general.*" %>
<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	
	User user = HrmUserVarify.getUser(request,response);
	if(user == null)  return ;
	
	String from = request.getParameter("from");
	ConfigBakUtil fileBakUtil = new ConfigBakUtil();
	FileUtil fileUtil = new FileUtil();
	if("updateConfig".equals(from)){
		String nodeid = request.getParameter("nodeid");
		String tabtype = request.getParameter("tabtype");
		String content = "";
		String ruleid = request.getParameter("ruleid");
		String path = request.getParameter("path");

		if(!"".equals(tabtype)&&!"".equals(ruleid)) {
			CheckUtil checkutil = new CheckUtil();
			List<Map<String,String>> rulemap = checkutil.getRuleById(tabtype, ruleid,"","");
			if(rulemap.size() > 0) {
				Map<String,String> map = rulemap.get(0);
				content = map.get("replacecontent");
				content = content.replaceAll("&lt;","<");
				content = content.replaceAll("&gt;",">");
				content = content.replaceAll("&quot;","\"");
				content = content.replaceAll("&apos;","'");
				content = content.replaceAll("&nbsp;"," ");
				content = content.replaceAll("\\\\r|\\\\n","");
			}
		}else{
			String detailid = request.getParameter("detailid");
			RecordSet rs = new RecordSet();
			String sql = "select a.attrvalue,b.filepath from configXmlFile a,configFileManager b where a.configfileid = b.id and a.id="+detailid+" and a.attrvalue is not null "+(rs.getDBType().equals("oracle")?"":" and a.attrvalue <>'' ")+" order by b.filepath";
			rs.execute(sql);
			if(rs.next()) {
				content = rs.getString("attrvalue");
				path = rs.getString("filepath");
			}
		}
		
		if(!"".equals(tabtype)&&!"".equals(ruleid)) {
			
		} else {
			path = GCONST.getRootPath() + path;//配置文件信息维护检测配置，地址存放的是相对路径，需要添加项目路径
		}
		
		//备份即将修改的文件
		String targetPath = fileBakUtil.getBakRootPath()+path;
		String sourcePath = GCONST.getRootPath() + path;
		fileBakUtil.copyFile(sourcePath, targetPath);
		
		selectXmlNodeUtil xml2ArrayList = new selectXmlNodeUtil(path);
		String res = xml2ArrayList.addNode(nodeid,content);
		out.print(res);
	}


if("autoChangeXmlNodeConfig".equals(from)){
	String detailid = Util.null2String(request.getParameter("detailid"));
	String operate = Util.null2String(request.getParameter("operate"));
	String path =  "";//文件路径
	String content = "";//配置内容
	String xpath = "";//配置路径
	FileOutputStream fw = null;
	XMLWriter writer = null;
	 ReadXml readXml = new ReadXml();
	try{
		RecordSet rs = new RecordSet();
		String sql = "select a.attrvalue,a.xpath,b.filepath from configXmlFile a,configFileManager b where a.configfileid = b.id and a.id="+detailid+" and a.attrvalue is not null "+(rs.getDBType().equals("oracle")?"":" and a.attrvalue <>'' ")+" order by b.filepath";
	//	        String sql = "select a.attrvalue,b.filepath from configXmlFile a,configFileManager b where a.configfileid = b.id and a.issystem = '1' and a.id="+detailid+" and a.attrvalue is not null "+(rs.getDBType().equals("oracle")?"":" and a.attrvalue <>'' ")+" order by b.filepath";
		rs.execute(sql);
		if(rs.next()) {
			content = rs.getString("attrvalue");
			path = rs.getString("filepath");
			xpath = rs.getString("xpath").replace("'","\'");
		}else{
			out.print("{\"status\":\"no\"}") ;
			return;
		}
		selectXmlNodeUtil util = new selectXmlNodeUtil(GCONST.getRootPath() +path);
		Document doc = null;
		File file = null;
		try {
			if(doc == null) {
				 doc = readXml.read(GCONST.getRootPath() + path);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		//备份即将修改的文件
		String targetPath = fileBakUtil.getBakRootPath()+path;
		String sourcePath = GCONST.getRootPath() + path;
		fileBakUtil.copyFile(sourcePath, targetPath);
		
		String handleResult="";
		// 	content = content.replaceAll("\r|\n","").replaceAll(">\\s+",">").replaceAll("\\s+<","<").replaceAll("\\s\\s+"," ");
		content = util.changeStr2(content);
	 	if(operate.equals("2")){
	 		handleResult = util.deleteConfig(content,GCONST.getRootPath() + path,xpath);
	 	} else{
	 		handleResult = util.autoConfig(xpath,doc,content);
	 		 if(doc != null) {
	 		 		//替换空命名空间
					doc = util.transformDocument(doc);
					fw = new FileOutputStream(fileUtil.getPath(GCONST.getRootPath() +path)); 
			        OutputFormat format = OutputFormat.createPrettyPrint(); 
			        String fileEncoding =  readXml.getFileEncode().equals("")?"UTF-8":readXml.getFileEncode();
			        format.setEncoding(fileEncoding);  
			        format.setIndent(true);      
 			        format.setIndent("    ");   
			        writer = new XMLWriter(fw,format);  
			        writer.write(doc); 
			  }
	 	}
		 
		if("ok".equals(handleResult)){
			out.print("{\"status\":\"ok\"}") ;
		}else{
			out.print("{\"status\":\"no\"}");	
		}
			return ;
	} catch(Exception e) {
		e.printStackTrace();
		out.print("{\"status\":\"no\"}") ;
		return;
	} finally {
		if(writer != null) {
			writer.flush();
		}
		if(fw != null){
			fw.flush();
		}
		if(writer != null) {
	        writer.close();
		}
		if(fw != null) {
	        fw.close();
		}
	}
}
if("needRestart".equals(from)){
	String detailid = Util.null2String(request.getParameter("detailid"));
	if(detailid==null){
		out.print("{\"status\":\"no\",\"msg\":\"无法获取记录的id\"}");
		return;
	}
	if(detailid.endsWith(",")){
		detailid = detailid.substring(0,detailid.length()-1);
	}
	boolean needRestart = false;
	RecordSet rs = new RecordSet();
	String sql1 = "select b.filename from configXmlFile a left join configFileManager b on a.configfileid = b.id where a.id in ("+detailid+")";
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