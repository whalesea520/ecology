<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileReader" %>
<%@ page import="java.io.FileNotFoundException" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.RandomAccessFile" %>
<!--
	qc:271653日志监测
-->
<%!
public  String readLastLine(File file, String charset,int limitLineCount){
	  if (!file.exists() || file.isDirectory() || !file.canRead()) {
	    return null;
	  }
	  RandomAccessFile raf = null;
	  try {
	    raf = new RandomAccessFile(file, "r");
	    long len = raf.length();
	    if (len == 0L) {
	      return "";
	    } else {
	      long pos = len - 1;
	      int linecount=1;
	      while (pos > 0) {
	        pos--;
	        raf.seek(pos);
	        if (raf.readByte() == '\n') {
	        	if(linecount == limitLineCount) {
	        		break;
	        	}
	        	linecount++;
	        }
	      }
	      if (pos == 0) {
	        raf.seek(0);
	      }
	      byte[] bytes = new byte[(int) (len - pos)];
	      raf.read(bytes);
	      if (charset == null) {
	        return new String(bytes);
	      } else {
	        return new String(bytes, charset);
	      }
	    }
	  } catch (Exception e) {
	  } finally {
	    if (raf != null) {
	      try {
	        raf.close();
	      } catch (Exception e2) {
	      }
	    }
	  }
	  return null;
	}
%>
<%
if(!HrmUserVarify.checkUserRight("tail:log",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

int lines = Integer.parseInt(request.getParameter("lines"));
String module = request.getParameter("module");
String seldate = request.getParameter("seldate");
String strs="";
String basePath = request.getRealPath("/");//取得当前目录的路径

String path = (basePath+"/log/"+module+ ("".equals(seldate)?"":"_"+seldate+".log")).replace("\\","/").replace("\\\\","/").replace("//","/");

String charset="gbk";
File f = new File(path);
if (f.exists())
{
	strs="<b>"+readLastLine(f, charset, lines).replace("\n", "</b></td></tr><tr><td colspan=\"4\"><b>") ;
	out.println( strs);
} else
{
	//文件不存在
	out.println( SystemEnv.getHtmlLabelName(18493,user.getLanguage())+path+SystemEnv.getHtmlLabelName(23084,user.getLanguage()) );
}
%>
