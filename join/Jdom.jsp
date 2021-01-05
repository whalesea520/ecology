
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.List" %>
<%@ page import="java.net.URL" %>
<%@ page import="org.jdom.Attribute" %>
<%@ page import="org.jdom.Document" %>
<%@ page import="org.jdom.Element" %>
<%@ page import="org.jdom.input.SAXBuilder" %>
<%@ page import="org.jdom.output.Format" %>
<%@ page import="org.jdom.output.XMLOutputter" %>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>
<%
String strUrl="http://www.ecologydev.com/join/NewsList.jsp?npid=8";  //把此URL修改成你所需的URL就可以了

try {
	 URL url=new URL(strUrl) ;
	 SAXBuilder builder= new SAXBuilder();
	 Document xmlDo = builder.build(url);
     Element rootNode = xmlDo.getRootElement();
	out.println("title:"+rootNode.getChild("channel").getChildTextTrim("title"));
	out.println("<br>");
	out.println("description:"+rootNode.getChild("channel").getChildTextTrim("description"));
	out.println("<br>");
	out.println("language:"+rootNode.getChild("channel").getChildTextTrim("language"));
	out.println("<br>");
	out.println("generator:"+rootNode.getChild("channel").getChildTextTrim("generator"));
	out.println("<br>");
	out.println("count:"+rootNode.getChild("channel").getChildTextTrim("count"));
	out.println("<br>");
	out.println("<br>");

	 List itemList=rootNode.getChildren("item");
	 for (Iterator iter = itemList.iterator(); iter.hasNext();) {
			Element item = (Element) iter.next();
			out.println(item.getChildTextTrim("newsid"));
			out.println("<br>");

			out.println(item.getChildTextTrim("title"));
			out.println("<br>");

			out.println(item.getChildTextTrim("link"));
			out.println("<br>");

			out.println(item.getChildTextTrim("pubDate"));
			out.println("<br>");

			out.println(item.getChildTextTrim("description"));
			out.println("<br>");

			out.println(item.getChildTextTrim("author"));
			out.println("<br>");

			out.println("====================================");
			out.println("<br>");
	 }

} catch (Exception ex) {   
	 out.println(ex);          
}    

 %>