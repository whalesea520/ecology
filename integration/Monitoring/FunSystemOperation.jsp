<%@page import="weaver.general.GCONST"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileWriter"%>
<%@page import="java.io.BufferedWriter"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>

<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	  StringBuffer sb=new StringBuffer();
	   response.setContentType("text/html;charset=UTF-8"); 
		try {   
	          String encoding = "UTF-8"; // 字符编码(可解决中文乱码问题 )   
	          File file = new File(GCONST.getRootPath()+"integration\\Monitoring\\FunMonitoring.jsp");   
	          if (file.isFile() && file.exists()) {   
	              InputStreamReader read = new InputStreamReader(new FileInputStream(file), encoding);   
	              BufferedReader bufferedReader = new BufferedReader(read);   
	              String lineTXT = null;   
	              while ((lineTXT = bufferedReader.readLine()) != null) {   
	                   String s=lineTXT.toString().trim();   
	                    sb.append(s);
	               }   
	              read.close();   
	           }else{   
	              out.println(SystemEnv.getHtmlLabelName(31641,user.getLanguage())+"!");   
	           }   
	       } catch (Exception e) {   
	          out.println(SystemEnv.getHtmlLabelName(31642,user.getLanguage())+"!");   
	          e.printStackTrace();   
	   		}   
	   		out.clear();
	   		String bor="border=\'1\'";
	   		String bor02="border=\'0\'";
	   		String temps=sb.toString().replace(bor, bor02);
	   		temps=temps.replace("Index:", ""+SystemEnv.getHtmlLabelName(31643,user.getLanguage())+":&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
	   		temps=temps.replace("Name:", ""+SystemEnv.getHtmlLabelName(31644,user.getLanguage())+":");
	   		temps=temps.replace("Type:", ""+SystemEnv.getHtmlLabelName(686,user.getLanguage())+":");
	   		temps=temps.replace("Size:", ""+SystemEnv.getHtmlLabelName(31645,user.getLanguage())+":");
	   		temps=temps.replace("Offset:", ""+SystemEnv.getHtmlLabelName(31646,user.getLanguage())+":");
	   		temps=temps.replace("Decimals:", ""+SystemEnv.getHtmlLabelName(15212,user.getLanguage())+":");
	   		temps=temps.replace("Value:", ""+SystemEnv.getHtmlLabelName(19113,user.getLanguage())+":");
	   		temps=temps.replace("Input Parameters", ""+SystemEnv.getHtmlLabelName(28245,user.getLanguage())+"");
	   		temps=temps.replace("Output Parameters", ""+SystemEnv.getHtmlLabelName(28255,user.getLanguage())+"");
	   		temps=temps.replace("Table Parameters", ""+SystemEnv.getHtmlLabelName(31647,user.getLanguage())+"");
	   		//temps=temps.replace("#CDCDBE", "#F5FAFA");
	   		temps=temps.replace("#F5F4E7", "#F5FAFA");
	   		//temps=temps.replace("#8D8D80", "white");
	   		temps=temps.replace("</table>", "</table><br>");
	   		temps=temps.replace("bgcolor=\'white\'", "class='ListStyle' cellspacing='1' ");
	   		//temps=temps.replace("bgcolor='#8D8D80'", "class='ListStyle' cellspacing='1' ");
	   		
	   		//Input Parameters
	   		out.println(temps);
%>