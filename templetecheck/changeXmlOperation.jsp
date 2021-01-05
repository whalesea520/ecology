<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="org.dom4j.*" %>
<%@ page import="org.dom4j.io.*"%>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="weaver.templetecheck.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
FileUtil fileUtil = new FileUtil();
String isdelete = Util.null2String(request.getParameter("delete"));
String autoconfig = Util.null2String(request.getParameter("autoconfig"));
String path = Util.null2String(request.getParameter("path"));
String tabtype = Util.null2String(request.getParameter("tabtype"));
String ruleid = Util.null2String(request.getParameter("ruleid"));
String content = "";

//System.out.println("ruleid:"+ruleid);
CheckUtil checkutil = new CheckUtil();
List<Map<String,String>> rulemap = checkutil.getRuleById(tabtype, ruleid,"","");

if("1".equals(isdelete)) {//删除配置
	try {
		String res = "ok";
		String filepath = path;
		if(rulemap.size() > 0) {
			Map<String,String> map = rulemap.get(0);
			content = map.get("replacecontent");
			String xpath = map.get("xpath");
			if(xpath != null) {
				selectXmlNodeUtil selectXmlNodeUtil = new selectXmlNodeUtil(filepath);
				xpath = selectXmlNodeUtil.changeStr2(xpath);
				content = selectXmlNodeUtil.changeStr2(content);
				res = selectXmlNodeUtil.deleteConfig(content,filepath,xpath);
			}
		}
		if("ok".equals(res)) {
			out.print("{\"status\":\"ok\"}") ;
		} else {
			out.print("{\"status\":\"no\"}") ;
		}
		return;
	} catch(Exception e) {
		e.printStackTrace();
		out.print("{\"status\":\"no\"}") ;
		return;
	}

	
} else if("1".equals(autoconfig)){//批量配置
	FileOutputStream fw = null;
	XMLWriter writer = null;
	try {
		selectXmlNodeUtil selectXmlNodeUtil = new selectXmlNodeUtil();
		Document document = null;
		List<Map<String,String>> rules = new ArrayList<Map<String,String>>();
		//如果没有选择规则   默认配置所有规则
		if("".equals(ruleid)) {
			rules = checkutil.getAllFileRules(tabtype,"","");
		} else {
			rules = rulemap;
		}
		String fileencode = "";
		String filepath = path;
		if(document == null) {
			 ReadXml readXml = new ReadXml();
			 document = readXml.read(filepath);
			 fileencode = readXml.getFileEncode();
		}
        //高版本和低版本修改相同的配置 
		//判断是否已包含这些规则  如果已包含 可以忽略
		Set<String> rulecontainsets = new HashSet<String>(); 
		ArrayList<String> autoconfigres = new ArrayList<String>();
		boolean haschange  = false;//判断document是否改变 没改变不重复写入文件
	    for(int i = 0; i < rules.size(); i++) {
	    	Map<String,String> map = rules.get(i);
	    	String replacecontent = map.get("replacecontent");
			String xpath = map.get("xpath");
			String version = map.get("version");
			//System.out.println("version:"+version);
			//判断是否已包含这个xapth 如果已包含，忽略这个规则
			if(!rulecontainsets.contains(xpath)) {
				rulecontainsets.add(xpath);
			} else {
				continue;
			}
			
			String requisite = map.get("requisite");
			if(xpath != null && !"".equals(xpath) && document != null && replacecontent != null) {
				//如果没有选择规则   默认配置所有规则；此时只自动配置必须配置的配置项
				if(("".equals(ruleid) && "1".equals(requisite))||!"".equals(ruleid)) {
					xpath = selectXmlNodeUtil.changeStr2(xpath);
					//System.out.println("===xpath:"+xpath);
					replacecontent = selectXmlNodeUtil.changeStr2(replacecontent);
					//自动配置
					
					String configres = selectXmlNodeUtil.autoConfig(xpath,document,replacecontent);
					if("ok".equals(configres)) {
						haschange = true;
					}
					//获得有问题的xpath
					if(configres != null && !"".equals(configres) && !"ok".equals(configres) && !"error".equals(configres)) {
						autoconfigres.add(configres);
					}
				}
			}
	    }
	    //判断document是否改变 没改变不重复写入文件
	    if(document != null && haschange) {
	    	//内部无法去掉xml  直接在写入前转化了
	     	document = selectXmlNodeUtil.transformDocument(document);
			fw = new FileOutputStream(fileUtil.getPath(filepath)); 
	        OutputFormat format = OutputFormat.createPrettyPrint();   
	        format.setEncoding(fileencode);   
	        format.setIndent(true);      
	        format.setIndent("    ");   
	        writer = new XMLWriter(fw,format);  
	        writer.write(document); 
	    }
	    //判断是否存在有问题的xpath
		if(autoconfigres.size() > 0) {
			JSONObject object = new JSONObject();
			for(int i = 0; i < autoconfigres.size(); i++) {
				String xpath = autoconfigres.get(i);
				object.put(""+i,xpath);
				out.print(object.toString());
				return;
			}
		} else {
			out.print("{\"status\":\"ok\"}") ;
			return;
		}
	} catch(Exception e) {
		e.printStackTrace();
		out.print("{\"status\":\"no\"}") ;
		return;
	} finally {
		if(writer != null&&fw != null) {
			fw.flush();
			writer.flush();
		}
		if(writer != null) {
            writer.close();
		}
		if(fw != null) {
            fw.close();
		}
	}

}


%>