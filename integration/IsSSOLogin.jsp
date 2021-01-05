<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="org.jsoup.nodes.Document" %>
<%@ page import="weaver.integration.logging.Logger"%>
<%@ page import="weaver.integration.logging.LoggerFactory"%>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="sso" class="weaver.ldap.SSOOperation" scope="page"/>

<%
	response.setContentType("text/html;charset=utf-8");
	request.setCharacterEncoding("utf-8");
	Logger log = LoggerFactory.getLogger();//新建日志对象                            
	String isSSOLogin = Util.null2String(request.getParameter("isSSOLogin"));

	String fromFile = request.getSession().getServletContext().getRealPath("/")+"index.htm";//源文件路径
	String toFile = request.getSession().getServletContext().getRealPath("/")+"index_backup.htm";//目标文件路径
	String SSOFile = request.getSession().getServletContext().getRealPath("/")+"index.htm.ldap";//SSO登录文件
	//log.info("=============根目录:"+request.getSession().getServletContext().getRealPath("/")+"================");
	//log.info("=============fromFile:"+fromFile+"================");
	//log.info("=============toFile:"+toFile+"================");
	
	if("1".equals(isSSOLogin)){//开启SSO登录
		try{
			boolean isExist = sso.checkFileExist(toFile);//检查备份文件存在与否
			if(!isExist){//备份文件不存在先备份，然后修改源文件
				sso.copyFile(fromFile, toFile);//备份index.htm到同目录下的index_backup.htm
				//sso.operationFile(fromFile);
				sso.copyFile(SSOFile, fromFile);//用SSO登录文件替换index.htm
				log.info("=============成功开启SSO登录================");
			}else{//备份文件存在，说明已经开启了，那么无法再次开启
				log.info("=============已开启过SSO登录================");
			}
			response.getWriter().println(true); 
		}catch (Exception e) {
			log.info("=============开启SSO登录异常================");
			e.printStackTrace();
			response.getWriter().println(false);
		}		
	}else{//关闭SSO登录
		try{
			boolean isExist = sso.checkFileExist(toFile);//检查备份文件存在与否
			if(isExist){//备份文件存在则先回写给源文件，再删除
				sso.copyFile(toFile,fromFile);//还原index.htm	
				sso.deleteFile(toFile);
				log.info("=============成功关闭SSO登录================");
			}else{
				log.info("=============已关闭过SSO登录================");
			}
			response.getWriter().println(true);
		}catch (Exception e) {
			log.info("=============关闭SSO登录异常================");
			e.printStackTrace();
			response.getWriter().println(false);
		}
	}
%>