<%@page language="java" contentType="application/x-msdownload" pageEncoding="UTF-8"%>  
<%@page import="java.net.URLEncoder"%>
<%@page import="java.io.OutputStream"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%
  response.reset(); 
  response.setContentType("application/x-download"); 
  
  String filedisplay =SystemEnv.getHtmlLabelName(28059,user.getLanguage())+".reg";  //设置受信站点  
  filedisplay = URLEncoder.encode(filedisplay,"UTF-8");
  response.addHeader("Content-Disposition","attachment;filename=" + filedisplay);
  
  String serverName=request.getServerName();
  String registerStr="Windows Registry Editor Version 5.00 \n"
	  +"[HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\ZoneMap\\Ranges] \n"
	  +"@=\"\" \n"
	  
	  +"[HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\ZoneMap\\Ranges\\Range101] \n"
	  +"\"*\"=dword:00000001 \n"
	  //+"\":Range\"=\"www.baidu.com\""
	  +"\":Range\"=\""+serverName+"\" \n"
	  +"\"http\"=dword:00000002 \n"
	  
	  +"[HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\Zones\\2] \n"
	  +"\"2201\"=dword:00000000 \n"
	  
	  +"[HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\Zones\\2] \n"
	  +"\"1405\"=dword:00000000 \n"


	  +"[HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\Zones\\2] \n"
	  +"\"1201\"=dword:00000000 \n"


	  +"[HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\Zones\\2] \n"
	  +"\"2000\"=dword:00000000 \n"


	  +"[HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\Zones\\2] \n"
	  +"\"1004\"=dword:00000000 \n"

	  +"[HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\Zones\\2] \n"
	  +"\"1001\"=dword:00000000 \n"


	  +"[HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\Zones\\2] \n"
	  +"\"2702\"=dword:00000000 \n"


	  +"[HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\Zones\\2] \n"
	  +"\"1209\"=dword:00000000 \n"


	  +"[HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\Zones\\2] \n"
	  +"\"1208\"=dword:00000000 \n"


	  +"[HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\Zones\\2] \n"
	  +"\"1200\"=dword:00000000 \n"


	  +"[HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\Zones\\2] \n"
	  +"\"120A\"=dword:00000000 \n"


	  +"[HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\Zones\\2] \n"
	  +"\"160A\"=dword:00000000 \n"


	  +"[HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\Zones\\2] \n"
	  +"\"1809\"=dword:00000003 \n"


	  +"[HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\Zones\\2] \n"
	  +"\"2102\"=dword:00000000 \n"


	  +"[HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\Zones\\2] \n"
	  +"\"1406\"=dword:00000000\" \n";
  
  byte[] registerStrs=registerStr.getBytes();
  OutputStream output=response.getOutputStream();   
  output.write(registerStrs,0,registerStrs.length);
  output.flush(); 
  output.close(); 
%>
