<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="org.dom4j.*" %>
<%@ page import="java.util.regex.*"%>
<%@ page import="weaver.templetecheck.CheckUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String name = Util.null2String(request.getParameter("name"));
String ishtml = Util.null2String(request.getParameter("ishtml"));
String description = Util.null2String(request.getParameter("description"));
String content = Util.null2String(request.getParameter("content"));
String flageid = Util.null2String(request.getParameter("flageid"));
String delflageids = Util.null2String(request.getParameter("delflageids"));
String replacecontent = Util.null2String(request.getParameter("replacecontent"));

String method = Util.null2String(request.getParameter("method"));
String tabtype = Util.null2String(request.getParameter("tabtype"));
String version = Util.null2String(request.getParameter("version"));
String xpath = Util.null2String(request.getParameter("xpath"));
String requisite = Util.null2String(request.getParameter("requisite"));
String ruletype = Util.null2String(request.getParameter("ruletype"));

//System.out.println("replacecontent:"+replacecontent);

CheckUtil checkutil = new CheckUtil();
if("delete".equals(method)) {
	boolean res = false;
	res = checkutil.deleteRule(delflageids,tabtype);
	if(res) {
		out.print("{\"status\":\"ok\"}");
	} else {
		out.print("{\"status\":\"no\"}");
	}
} else {
	
	CheckUtil.Rule rule  = checkutil.new Rule();
	rule.setName(checkutil.changeStr(name.trim()));
	rule.setDescription(checkutil.changeStr(description.trim()));
	rule.setContent(checkutil.changeStr(content.trim()));
	rule.setXpath(checkutil.changeStr(xpath.trim()));
	rule.setRequisite(checkutil.changeStr(requisite));
	
	if("1".equals(ishtml)||"2".equals(ishtml)) {
		try {
			//判断输入的xml配置项是否有</a>333<a>这种情况
      		Pattern p = Pattern.compile("((</.*?>)[\\s]*?[^<\\s]+)");
     		
     		Matcher m = p.matcher(replacecontent);
     		if(m.find()){
     			out.print("{\"status\":\"xmlerror\"}");
    			return;
     		}
			if(replacecontent != null && !"".equals(replacecontent)) {
				Document doc = DocumentHelper.parseText("<myroot>"+replacecontent+"</myroot>");
			}
		} catch(Exception e) {
			out.print("{\"status\":\"xmlerror\"}");
			return;
		}
		
		//验证版本号是否正确
		String sysversion = "";
		rs.execute("select cversion from license");
		if(rs.next()) {
			sysversion = rs.getString("cversion");
		}
		
		String[] versions = sysversion.split("\\+");
		if(versions.length == 2) {
			String basicversion = versions[0];
			String tempsysversion = versions[1].replace("KB","");
			//非KB补丁包  则是E8 的基础版本8.100.0531
			if(version.indexOf("KB")<0) {
				if(!basicversion.equals(version)) {
					out.print("{\"status\":\"versionerror\"}");
	    			return;
				}
			} else {
   				String tempversion = version.replace("KB","");
   				
   				try {
   	   				long v1 = Long.valueOf(tempsysversion);
   	   				long v2 = Long.valueOf(tempversion);
   	   				if(v1<v2) {
   	   					out.print("{\"status\":\"versionerror\"}");
   		    			return;
   	   				}
   				} catch(Exception e) {
   					out.print("{\"status\":\"versionerror\"}");
		    		return;
   				}

			}
		} else  {
			String tempversion = version.replace("KB","");
			String tempsysversion = versions[0];
			if(!tempversion.equals(tempsysversion)) {
				out.print("{\"status\":\"versionerror\"}");
    			return;
			}
		}
	}
	rule.setReplacecontent(checkutil.changeStr(replacecontent));
	rule.setVersion(checkutil.changeStr(version));
	
	rule.setFlageid(checkutil.changeStr(flageid));
	rule.setRuletype(ruletype);
	boolean res = false;
	if("add".equals(method)) {
		res =  checkutil.saveRule(rule,tabtype);
	} else {
		res =  checkutil.updateRule(rule,tabtype);
	}
	if(res) {
		out.print("{\"status\":\"ok\"}");
	} else {
		if("add".equals(method)){
			out.print("{\"status\":\"adderror\"}");
		} else {
			out.print("{\"status\":\"updateerror\"}");
		}
	}
}


%>