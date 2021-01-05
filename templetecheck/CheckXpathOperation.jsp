<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="org.dom4j.*" %>
<%@ page import="org.dom4j.io.*"%>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="org.json.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="weaver.templetecheck.IgnoreDTDEntityResolver" %>
<%
String content = request.getParameter("contentarea");
String xpath = request.getParameter("xpath");
//System.out.println("content:"+content);
JSONObject object = new JSONObject();
try {
	//部分元素根据xpath查询失败 好像是有不符合什么规范 改成SAXReader来初始化成document
	SAXReader saxReader = new SAXReader(); 
	saxReader.setEntityResolver(new IgnoreDTDEntityResolver()); // ignore dtd
	Document document = saxReader.read(new ByteArrayInputStream(content.getBytes("UTF-8")));
	//Document document = DocumentHelper.parseText(content);
	//System.out.println("content:"+document.asXML());
	//System.out.println("xpath:"+xpath);
	List elements = document.selectNodes(xpath);
	for(int i= 0; i < elements.size(); i++) {
		//System.out.println("elements.size():"+elements.size());
		Element ele = (Element)elements.get(i);
		object.put(""+i,ele.asXML());
	}
	out.print(object.toString());
} catch(DocumentException e) {
	e.printStackTrace();
	object.put("status","error1");
	out.print(object.toString());
} catch(InvalidXPathException e) {
	e.printStackTrace();
	object.put("status","error2");
	out.print(object.toString());
} catch(XPathException e) {
	e.printStackTrace();
	object.put("status","error2");
	out.print(object.toString());
} catch(Exception e) {
	e.printStackTrace();
	object.put("status","error");
	out.print(object.toString());
}
return;
%>