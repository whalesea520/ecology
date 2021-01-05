<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.email.MailReciveStatusUtils"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.email.EmailEncoder"%>
<%@page import="weaver.system.SystemComInfo"%>
<%@page import="weaver.file.FileUpload"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SystemComInfo" class="weaver.system.SystemComInfo" scope="page" />
<%
	String method = Util.null2String(request.getParameter("method"));

	//邮件系统设置 --> 基本设置
	if("basesetting".equals(method)){
		try{
			String innerMail = Util.null2String(request.getParameter("innerMail"),"0");
			String outterMail = Util.null2String(request.getParameter("outterMail"),"0");
			String autoReceive = Util.null2String(request.getParameter("autoReceive"),"0");
			int isAll = Integer.parseInt(Util.null2String(request.getParameter("isAll"),"0"));
			
			String emlpath = Util.null2String(request.getParameter("emlpath"), "");
			if("".equals(emlpath)) {
				emlpath = request.getSession().getServletContext().getRealPath("/") + "email\\eml\\"; 
			}
			int isEml = Integer.parseInt(Util.null2String(request.getParameter("isEml"),"0"));
			int emlPeriod = Integer.parseInt(Util.null2String(request.getParameter("emlPeriod"),"30"));
			
			int dimissionEmpTime = Integer.parseInt(Util.null2String(request.getParameter("dimissionEmpTime"),"0"));
			int clearTime = Integer.parseInt(Util.null2String(request.getParameter("clearTime"),"0"));
			int timecount = 0;
			if(autoReceive.equals("1")){
				timecount = Integer.parseInt(Util.null2String(request.getParameter("timecount"),"300000"));
			//	timecount = Util.getIntValue(request.getParameter("timecount"),300000);
			}
			int isClear = Integer.parseInt(Util.null2String(request.getParameter("isClear"),"0"));
            int isRecordSuccessMailRemindLog = Util.getIntValue(request.getParameter("isRecordSuccessMailRemindLog"), 0);
            int clearMailRemindLogTimelimit = Util.getIntValue(request.getParameter("clearMailRemindLogTimelimit"), 15);
			
			rs.execute("select * from MailConfigureInfo");
			if(rs.next()){
				rs.executeUpdate("update MailConfigureInfo set innerMail = ?, outterMail = ?, isAll = ?, isEml = ?, emlPeriod = ?, emlpath = ?, isClear = ?, clearTime = ?, dimissionEmpTime = ?," 
				        + " autoReceive = ?, timecount = ?, isRecordSuccessMailRemindLog= ?, clearMailRemindLogTimelimit= ?" , 
				        innerMail, outterMail, isAll, isEml, emlPeriod, emlpath, isClear, clearTime, dimissionEmpTime, autoReceive, timecount, isRecordSuccessMailRemindLog, clearMailRemindLogTimelimit
				);
				
			}else{
				rs.executeUpdate("insert into MailConfigureInfo(innerMail , outterMail, isAll, isEml , emlPeriod, emlpath, isClear, clearTime , dimissionEmpTime,autoReceive,timecount, " + 
				         " isRecordSuccessMailRemindLog, clearMailRemindLogTimelimit) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
				         innerMail, outterMail, isAll, isEml, emlPeriod, emlpath, isClear, clearTime, dimissionEmpTime, autoReceive, timecount, isRecordSuccessMailRemindLog, clearMailRemindLogTimelimit
				);
				
			}
            
            // 刷新 后台 应用中心 邮件基本设置配置 缓存信息
            MailReciveStatusUtils.rebuildMailconfigureinfo();
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return;
	}
	
	//邮件系统设置 --> 提醒设置
	if("remindSetting".equals(method)) {
		try{
			String rid = Util.null2String(request.getParameter("rid"), "0");
			String enable = Util.null2String(request.getParameter("enable"), "0");
			String content = Util.null2String(request.getParameter("content"), "");
			rs.execute(" update MailReceiveRemind set enable = " + enable + ", content='"+content +"'  where id = "+ rid);
		}catch(Exception e){
			e.printStackTrace();
		}
		return;
	}
	
	//邮件系统设置 --> 群发参数设置
	if("systemset".equals(method)){
		try{
			String defmailserver = Util.null2String(request.getParameter("smtpServer"));
			String needSSL = Util.null2String(request.getParameter("sendneedSSL"));
			String smtpServerPort = Util.null2String(request.getParameter("smtpServerPort"));
			String defneedauth = Util.null2String(request.getParameter("needCheck"));
			String defmailfrom = Util.null2String(request.getParameter("accountMailAddress"));
			String defmailuser = Util.null2String(request.getParameter("accountId"));
			String defmailpassword = Util.null2String(request.getParameter("accountPassword"));
			defmailpassword = EmailEncoder.EncoderPassword(defmailpassword);
            String mailAccountName = Util.null2String(request.getParameter("mailAccountName"));
            String mailIsStartTls = Util.null2o(request.getParameter("isStartTls"));
			
			rs.execute("select * from SystemSet");
			String sql = "";
			if(rs.next()){
				sql = "update SystemSet set defmailserver = '"+defmailserver+"' ,smtpServerPort = '"+smtpServerPort+"' , needSSL = '"+needSSL+"' , defneedauth = '"+defneedauth+"' , "+
                " defmailfrom = '"+defmailfrom+"' , defmailuser = '"+defmailuser+"' , defmailpassword = '"+defmailpassword+"' , encryption = 1, mailAccountName = '" + mailAccountName + "', mailIsStartTls='" + mailIsStartTls + "'";
				rs.execute(sql);
			}else{
                sql = "insert into SystemSet (defmailserver , needSSL ,smtpServerPort , defneedauth, defmailfrom , defmailuser , defmailpassword , encryption, mailAccountName, mailIsStartTls) values ("+
                       "'"+defmailserver+"','"+needSSL+"', '"+smtpServerPort+"', '"+defneedauth+"','"+defmailfrom+"','"+defmailuser+"','"+defmailpassword+"' , 1, '" + mailAccountName + "', '" + mailIsStartTls + "')";
				rs.execute(sql);
			}
			SystemComInfo.removeSystemCache() ;
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return;
	}
	
	//邮件系统设置 --> 附件设置
	if("mailAttachment".equals(method)){
		try{
			String filePath = Util.null2String(request.getParameter("filePath"));
			String totalAttachmentSize = Util.null2String(request.getParameter("totalAttachmentSize"),"0");
			String perAttachmentSize = Util.null2String(request.getParameter("perAttachmentSize"),"0");
			String attachmentCount = Util.null2String(request.getParameter("attachmentCount"),"0");
			rs.execute("select * from MailConfigureInfo");
			if(rs.next()){
				rs.executeUpdate("update MailConfigureInfo set filePath = ?, totalAttachmentSize = ?, perAttachmentSize = ?, attachmentCount = ?", filePath, totalAttachmentSize, perAttachmentSize, attachmentCount);
			}else{
				rs.executeUpdate("insert into MailConfigureInfo(filePath, totalAttachmentSize, perAttachmentSize, attachmentCount) values (?, ?, ?, ?)", filePath, totalAttachmentSize, perAttachmentSize, attachmentCount);
			}
            
			// 刷新 后台 应用中心 邮件基本设置配置 缓存信息
            MailReciveStatusUtils.rebuildMailconfigureinfo();
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return;
	}
	
	//企业邮箱管理 -- 》添加操作
	if("addEnterprise".equals(method)){
		try{
			String DOMAIN_ID = Util.null2String(request.getParameter("DOMAIN_ID"));
			String DOMAIN = Util.null2String(request.getParameter("DOMAIN"));
			String POP_SERVER = Util.null2String(request.getParameter("POP_SERVER"));
			String SMTP_SERVER = Util.null2String(request.getParameter("SMTP_SERVER"));
			String IS_SMTP_AUTH = Util.null2String(request.getParameter("IS_SMTP_AUTH"),"0");
			String POP_PORT = Util.null2String(request.getParameter("POP_PORT"),"110");
			String SMTP_PORT = Util.null2String(request.getParameter("SMTP_PORT"),"25");
			String IS_SSL_POP = Util.null2String(request.getParameter("IS_SSL_POP"),"0");
			String IS_SSL_SMTP = Util.null2String(request.getParameter("IS_SSL_SMTP"),"0");
			String IS_POP = Util.null2String(request.getParameter("IS_POP"),"1");
			String NEED_SAVE = Util.null2String(request.getParameter("NEED_SAVE"),"0");
			String AUTO_RECEIVE = Util.null2String(request.getParameter("AUTO_RECEIVE"),"0");
			String RECEIVE_SCOPT = Util.null2String(request.getParameter("receiveScope"),"1");
            String IS_START_TLS = Util.null2String(request.getParameter("IS_START_TLS"));
			String sql = "";
			if(DOMAIN_ID.equals("")){
				rs.execute("SELECT max(DOMAIN_ID) FROM webmail_domain");
				rs.next();
				int id = Util.getIntValue(rs.getString(1),0)+1;
                sql = "insert into webmail_domain(DOMAIN_ID , DOMAIN,POP_SERVER,SMTP_SERVER,IS_SMTP_AUTH,POP_PORT,SMTP_PORT,IS_SSL_POP,IS_SSL_SMTP,IS_POP,NEED_SAVE,AUTO_RECEIVE,RECEIVE_SCOPT,IS_START_TLS) values("+
						"'"+id+"' ,'"+DOMAIN+"' ,'"+POP_SERVER+"' , '"+SMTP_SERVER+"' ,'"+IS_SMTP_AUTH+"' , '"+POP_PORT+"','"+SMTP_PORT+"',"+
                        "'"+IS_SSL_POP+"' , '"+IS_SSL_SMTP+"' , '"+IS_POP+"' , '"+NEED_SAVE+"' , '"+AUTO_RECEIVE+"' , '"+RECEIVE_SCOPT+"', '"+IS_START_TLS+"')";
				rs.execute(sql);
			}else{
				sql = "update webmail_domain set DOMAIN = '"+DOMAIN+"' , POP_SERVER = '"+POP_SERVER+"' ,SMTP_SERVER = '"+SMTP_SERVER+"' , "+
						" IS_SMTP_AUTH = '"+IS_SMTP_AUTH+"' , POP_PORT = '"+POP_PORT+"' , SMTP_PORT = '"+SMTP_PORT+"' , "+
						" IS_SSL_POP = '"+IS_SSL_POP+"' , IS_SSL_SMTP = '"+IS_SSL_SMTP+"' , IS_POP = '"+IS_POP+"' , "+
                    	" NEED_SAVE = '"+NEED_SAVE+"' , AUTO_RECEIVE = '"+AUTO_RECEIVE+"' , RECEIVE_SCOPT = '"+RECEIVE_SCOPT+"', IS_START_TLS='"+IS_START_TLS+"'"+
						" where DOMAIN_ID = "+DOMAIN_ID;
				rs.execute(sql);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return;
		
	}
	
	//企业邮箱管理 -- 》删除操作
	if("delEnterprise".equals(method)){
		try{
			String DOMAIN_IDS = Util.null2String(request.getParameter("DOMAIN_IDS"));
			rs.execute("delete from webmail_domain where DOMAIN_ID in ("+DOMAIN_IDS+")");
		}catch(Exception e){
			e.printStackTrace();
		}
		return;
	}
	
	//邮箱空间管理 -- 》批量设置
	if("addMailSpace".equals(method)){
		
		try{
			String type = Util.null2String(request.getParameter("type"));
			String resource = Util.null2String(request.getParameter("resource"));
			String subcompany = Util.null2String(request.getParameter("subcompany"));
			String department = Util.null2String(request.getParameter("department"));
			String jobtitle = Util.null2String(request.getParameter("jobtitle"));
			int beginLevel = Util.getIntValue(request.getParameter("beginLevel"),0);
			int endLevel = Util.getIntValue(request.getParameter("endLevel"),0);
			String totalspace = Util.null2String(request.getParameter("totalspace"));
			
			String sql = "";
			
			if("1".equals(type)){
				sql = "update HrmResource set totalspace = "+totalspace+
					" where id in ("+resource+")";
			}
			
			if("2".equals(type)){
				sql = "update HrmResource set totalspace = "+totalspace+
					" where subcompanyid1 in ("+subcompany+") and seclevel BETWEEN "+Math.min(beginLevel,endLevel)+"  AND  "+Math.max(beginLevel,endLevel);
			}
			
			if("3".equals(type)){
				sql = "update HrmResource set totalspace = "+totalspace+
					" where departmentid in ("+department+") and seclevel BETWEEN "+Math.min(beginLevel,endLevel)+"  AND  "+Math.max(beginLevel,endLevel);
			}
			
			if("4".equals(type)){
				sql = "update HrmResource set totalspace = "+totalspace+
					" where seclevel BETWEEN "+Math.min(beginLevel,endLevel)+"  AND  "+Math.max(beginLevel,endLevel);
			}
			rs.execute(sql);
		}catch(Exception e){
		    logger.error("邮箱空间管理 -- 》批量设置 错误");
            logger.error(e);
		}
		return;
	}
	
	//邮箱空间管理 -- 》修改可用空间
	if("editMailSpace".equals(method)){
		try{
			String id = Util.null2String(request.getParameter("id"));
			String totalspace = Util.null2String(request.getParameter("totalspace"));
			String sql = "update HrmResource set totalspace = "+totalspace+" where id =" + id;
			rs.execute(sql);
		}catch(Exception e){
			logger.error("邮箱空间管理,修改可用空间错误");
            logger.error(e);
		}
		return;
	}
%>
