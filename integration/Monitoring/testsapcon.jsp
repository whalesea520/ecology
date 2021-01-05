
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.util.Properties"%>
<%@page import="com.sap.mw.jco.JCO"%>
<%
			//该界面功能主要用于调试而用,所以不用加init.jsp
		   String	 sapclient = "800";//sap客服端
		   String userid = "Weaver_Dev";//用户名
		   String password = "654321";//用户密码
		   String hostname = "192.168.0.26";
		   String systemnumber = "00";//系统编号
		   String Language = "ZH";//客服端语言
		   String sapRouter ="";//系统SAP router字符串
			if(!"".equals(sapRouter)) {
	    		hostname = sapRouter + hostname;
	    	}
		   /*  获得一个到SAP系统的连接  START   */
	        Properties logonProperties = new Properties();
	        logonProperties.put("jco.client.ashost",hostname); //系的IP地址
	        logonProperties.put("jco.client.client",sapclient);           //要登录的客户端
	        logonProperties.put("jco.client.sysnr",systemnumber);             //系统编号
	        logonProperties.put("jco.client.user",userid);         //登录用户名
	        logonProperties.put("jco.client.passwd",password);      //用户登录口令
	        logonProperties.put("jco.client.lang", Language);//系统语言
	        //用上述条件创建一个连接对象
	        JCO.Client myConnection = JCO.createClient( logonProperties );
	        /*  获得一个到SAP系统的连接  END     */
	        myConnection.connect();       //进行实际连接
	        //如果连接不为null并且处于活动状态
	        if (myConnection != null && myConnection.isAlive()) {
	            //从连接获得一个逻辑意义上的“仓库”对象（Repository）
	        	out.println("<%=SystemEnv.getHtmlLabelName(83766,user.getLanguage()) %>！");
	        }else{
	        	out.println("<%=SystemEnv.getHtmlLabelName(83780,user.getLanguage()) %>!");
	        }
	        //断开连接
            myConnection.disconnect(); 
 %>

