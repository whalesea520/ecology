<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="weaver.general.InitServer" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.system.SystemUpgrade" %>
<%@ page import="weaver.file.FileManage" %>
<%@ page import="weaver.system.SysUpgradeCominfo" %>
<%@ page import="java.io.*" %>
<%@ page import="weaver.conn.RecordSet" %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>continueExcute</title>
<style>


.btnclass {
	margin-top:50px;
	margin-left:50px;
	widht:300px;
	height:30px;
}
</style>
</head>
<body>
<%



String skipall = Util.null2String(request.getParameter("skipall"));
if("1".equals(skipall)) {

	Thread threadSysUpgrade = null;
	threadSysUpgrade = (Thread)weaver.general.InitServer.getThreadPool().get(0);
	BaseBean baseBean = new BaseBean();
	if(!threadSysUpgrade.isAlive()){
		SysUpgradeCominfo suc=new SysUpgradeCominfo();
		int pagestatus = suc.getPagestatus();
		String sqlname = suc.getErrorFile();
		//重新计算运行比例
		String sqlpath = GCONST.getRootPath() + "sqlupgrade" + File.separatorChar;
		String datapath = GCONST.getRootPath()+"data" + File.separatorChar;
	   	RecordSet rs1 = new RecordSet();
	    boolean isoracle = (rs1.getDBType()).equals("oracle") ;
	    boolean isdb2 = (rs1.getDBType()).equals("db2") ;
	    boolean ismysql = (rs1.getDBType()).equals("mysql") ;
	    if(isoracle) {
	    	sqlpath = sqlpath + "Oracle";
	    	datapath = datapath + "Oracle";
	    } else if(isdb2) {
	    	sqlpath = sqlpath + "DB2" ;
	    	datapath = datapath + "DB2";
	    } else if(ismysql){
	    	sqlpath = sqlpath + "MySQL" ;
	    	datapath = datapath + "MySQL";
	    } else {
	    	sqlpath = sqlpath + "SQLServer";
	    	datapath = datapath + "SQLServer";
	    }
	   
	    
	    try {
	    	//拷贝整条语句
			FileManage.moveFileTo(sqlpath+File.separatorChar+sqlname,datapath+File.separatorChar+sqlname);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    File sqls = new File(sqlpath);
		SystemUpgrade.setRunFileCount(sqls.list().length);
		SystemUpgrade.setRunFile(0);
		
		if(pagestatus == 3) {
			suc.ChangeProp("0","",0,0,"","");
		} else {
			suc.ChangeProp("0","",1,0,"","");
			baseBean.writeLog("SystemUpgrade Stop.....");
		    //System.out.println("SystemUpgrade Stop.....");
		    InitServer.getThreadPool().remove(0);
		    SystemUpgrade systemupgrade = new SystemUpgrade();
			Thread u = new Thread(systemupgrade);
			InitServer.getThreadPool().add(0,u);
			u.start();
			baseBean.writeLog("SystemUpgrade Restart.....");
		    //System.out.println("SystemUpgrade Restart.....");
		}
		
	}
	
} else {
	Thread threadSysUpgrade = null;
	threadSysUpgrade = (Thread)weaver.general.InitServer.getThreadPool().get(0);
	BaseBean baseBean = new BaseBean();
	if(!threadSysUpgrade.isAlive()){
		SysUpgradeCominfo suc=new SysUpgradeCominfo();
		int errorline = suc.getErrorLine();
		String errorfile = suc.getErrorFile();
		int pagestatus = suc.getPagestatus();
		//重新计算运行比例
		String sqlpath = GCONST.getRootPath() + "sqlupgrade" + File.separatorChar;
	   	RecordSet rs1 = new RecordSet();
	    boolean isoracle = (rs1.getDBType()).equals("oracle") ;
	    boolean isdb2 = (rs1.getDBType()).equals("db2") ;
	    boolean ismysql = (rs1.getDBType()).equals("mysql") ;
	    if(isoracle) {
	    	sqlpath = sqlpath + "Oracle";
	    } else if(isdb2) {
	    	sqlpath = sqlpath + "DB2" ;
	    } else if(ismysql){
	    	sqlpath = sqlpath + "MySQL" ;
	    } else {
	    	sqlpath = sqlpath + "SQLServer";
	    }
	    File sqls = new File(sqlpath);
	    
	    //System.out.println("sqls.list().length:"+sqls.list().length);
	    if(sqls.list()==null) {
	    	SystemUpgrade.setRunFileCount(0);
	    } else {
	    	SystemUpgrade.setRunFileCount(sqls.list().length);
	    }
		
		SystemUpgrade.setRunFile(0);
		
		if(pagestatus == 3) {
			suc.ChangeProp("0","",0,0,"","");
		} else {
			suc.ChangeProp("0","",1,errorline,errorfile,"");
			baseBean.writeLog("SystemUpgrade Stop.....");
		    //System.out.println("SystemUpgrade Stop.....");
		    InitServer.getThreadPool().remove(0);
		    SystemUpgrade systemupgrade = new SystemUpgrade();
			Thread u = new Thread(systemupgrade);
			InitServer.getThreadPool().add(0,u);
			u.start();
			SysUpgradeCominfo.continueFlag = true;
			baseBean.writeLog("SystemUpgrade Restart.....");
		    //System.out.println("SystemUpgrade Restart.....");
		}
		
	}
}
%>
</body>
</html>