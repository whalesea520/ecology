<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="weaver.general.*" %>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.email.WeavermailUtil"%>
<%@page import="weaver.splitepage.transform.SptmForMail"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.email.MailSend"%>
<%@page import="java.io.File"%>
<%@page import="weaver.email.service.MailManagerService"%>
<%@page import="org.apache.commons.lang.StringUtils"%> 
<%@ include file="/page/maint/common/initNoCache.jsp" %>

<jsp:useBean id="mrs" class="weaver.email.service.MailResourceService" scope="page" />
<jsp:useBean id="mss" class="weaver.email.service.MailSettingService" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%!
	public String getBelongMailIds(int userId, String mailIds) {
	    // 获得这个用户下可删除的邮件ID，放置变更用户后更改mailIds攻击
	    List<String> ids = new ArrayList<String>();
	    try {
	        RecordSet recordSet = new RecordSet();
		    String resourceids = MailManagerService.getAllResourceids(String.valueOf(userId));
		    String sql = "SELECT id FROM MailResource WHERE (" + Util.getSubINClause(resourceids, "resourceid", "in") + ") AND (" +  Util.getSubINClause(mailIds, "id", "in") + ")";
		    recordSet.executeQuery(sql);
		    while(recordSet.next()) {
		        ids.add(recordSet.getString("id"));
		    }
	    } catch(Exception e) {
	        ids.clear(); //如果出错，则 认为没有可操作的mailid
	        new BaseBean().writeLog(e);
	    }
	    
	    return ids.isEmpty() ? "" : StringUtils.join(ids, ",");
	}
%>

<%
	String operation = Util.null2String(request.getParameter("operation"));
	String[] mailsId = Util.null2String(request.getParameter("mailsId")).split(",");
	String mailId = Util.null2String(request.getParameter("mailId"));
	String mailIds = Util.null2String(request.getParameter("mailIds"));
	String lableId = Util.null2String(request.getParameter("lableId"));
	String star = Util.null2String(request.getParameter("star"));
	String movetoFolder = Util.null2String(request.getParameter("movetoFolder"));
	String status = Util.null2String(request.getParameter("status"));
	String folderid = Util.null2String(request.getParameter("folderid"));
	String replycontent = Util.fromScreen(Util.null2String(request.getParameter("replycontent")), user.getLanguage());  //快捷回复为纯文本内容，转义防止html代码等问题漏洞
	
	if(operation.equals("getMailcontent")){     
		JSONObject json = new JSONObject();
		json.put("mailcontent", (String)session.getAttribute("mailcontent"));
		session.removeAttribute("mailcontent");
		out.println(json);
	}
    
    else if(operation.equals("checkEml")) {
		String sql = "select haseml, emlpath, emlName, subject from MailResource where id in (" + mailIds + ")";
		boolean emlexist = false;
		try{
			rs.execute(sql);
			while(rs.next()) {
				String emlpath = Util.null2String(rs.getString("emlpath"));
                if(new File(emlpath).exists()) {
                	emlexist = true;
                    break;
                }
			}
		}catch(Exception e){
			logger.error(e);
		}
		out.print(emlexist);
		return;
	}
	
    else if(operation.equals("addLable")) {
        String finalMailIds = getBelongMailIds(user.getUID(), StringUtils.join(mailsId, ","));
        if(!finalMailIds.isEmpty()) {
			mrs.addLable(Util.TokenizerString2(finalMailIds, ","), lableId);
        }
	} 
    
    else if(operation.equals("removeLable")) {
        String finalMailIds = getBelongMailIds(user.getUID(), mailId);
        if(!finalMailIds.isEmpty()) {
            mrs.removeLable(finalMailIds, lableId);
        }
	} 
    
    else if(operation.equals("updateStar")) {
        String finalMailIds = getBelongMailIds(user.getUID(), mailId);
        if(!finalMailIds.isEmpty()) {
            mrs.updateStar(finalMailIds, star);
        }
	}
    
    else if(operation.equals("move")){
        String finalMailIds = getBelongMailIds(user.getUID(), mailId);
        if(!finalMailIds.isEmpty()) {
            mrs.moveMailToFolder(finalMailIds, movetoFolder);
        }
	}
    
    else if(operation.equals("delete")){
		 String emlPath=application.getRealPath("")+"email\\eml\\";
		 mrs.deleteMail(mailId, user.getUID(), emlPath);
		 rs.execute("select totalspace, occupyspace from hrmresource where id = "+user.getUID());
		 float totalspace = 0f;
		 float occupyspace = 0f; 
		 while(rs.next()){
		     totalspace = Util.getFloatValue(rs.getString("totalspace"), 0f);
			 occupyspace = Util.getFloatValue(rs.getString("occupyspace"), 0f); 
		 }
		 out.println(occupyspace+","+totalspace);
	}
    
    else if(operation.equals("updateStatus")){
		mrs.updateMailResourceStatus(status,mailId,user.getUID());
		//update mail.readdate
		if("1".equals(status)){
		    String finalMailIds = getBelongMailIds(user.getUID(), mailId);
	        if(!finalMailIds.isEmpty()) {
	            mrs.updateMailResourceReaddate(finalMailIds);
	        }
			
		}
	}
    
    else if(operation.equals("editLayout")){
		String layout  = Util.null2String(request.getParameter("layout"));
		mss.updateLayout(user.getUID(), layout);
	}
    
    else if (operation.equals("deleteAll")){
		 String emlPath=application.getRealPath("")+"email\\eml\\";
		 mrs.deleteFolderMail(folderid, user.getUID(), emlPath);
	}
    
    else if (operation.equals("cancelLabel")){
        String finalMailIds = getBelongMailIds(user.getUID(), StringUtils.join(mailsId, ","));
        if(!finalMailIds.isEmpty()) {
            String[] finalMailIdsArr = Util.TokenizerString2(finalMailIds, ",");
            for(int i=0;i<finalMailIdsArr.length;i++){
    			mrs.removeALLLable(finalMailIdsArr[i], lableId);
    		}
        }
	}
    
    else if (operation.equals("getAllTO")){ //获取所有发件人
		String mailaddress  = Util.null2String(request.getParameter("mailaddress"));
		SptmForMail sptmForMail = new SptmForMail(); 
		String mailAddressStr=sptmForMail.getNameByEmailTOP(mailaddress,""+user.getUID(),"all");
		mailAddressStr+="&nbsp;&nbsp;<a href='javascript:void(0)' style='color:blue' onclick=\"hideALL(this)\">[收缩]</a>";
		out.println(mailAddressStr);
	}
    
    else if(operation.equals("recall")){//撤回操作
		String flag = "true";
    
    	String finalMailId = getBelongMailIds(user.getUID(), mailId);
    	if(finalMailId.isEmpty()) {
    	    out.println("false");
    	    return;
    	}
    	
		try{
			//update MailResource
			String sb = SystemEnv.getHtmlLabelName(32063, user.getLanguage());  //发信方已撤回邮件
			String ct = SystemEnv.getHtmlLabelName(32064, user.getLanguage());  //该邮件已经被发送者撤回
			String sql = "";
			if("oracle".equals(rs.getDBType())){
				sql = "update MailResource set subject =concat('"+sb+":',subject) "+
				" , content = '"+ct+"' , attachmentNumber = 0 where originalMailId ="+mailId+
				" AND id NOT IN(SELECT id FROM MailResource WHERE subject LIKE '%"+sb+":%')";
				rs.execute("update mailcontent set mailcontent = '"+ct+"' where mailid in (select id from mailresource where originalMailId = "+mailId+")");
			}else{
				sql = "update MailResource set subject ='"+sb+":'+subject "+
				" , content = '"+ct+"' , attachmentNumber = 0 where originalMailId ="+mailId+
				" AND id NOT IN(SELECT id FROM MailResource WHERE subject LIKE '%"+sb+":%')";
			}
			rs.execute(sql);
			
			//delete MailResourceFile
			sql = "DELETE FROM MailResourceFile WHERE mailid IN (SELECT id FROM MailResource WHERE originalMailId = "+mailId+" )";
			rs.execute(sql);
			
			//update mailresource recallstate
			sql = "update MailResource set recallState = 1 where id ="+mailId;
			rs.execute(sql);
			
			rs.execute("select subject from MailResource where id = "+mailId);
			rs.next();
			int totalsize = (rs.getString("subject")+sb).getBytes().length+ct.getBytes().length;
			sql = "UPDATE MailResource SET size_n = '"+totalsize+"' WHERE originalMailId = '"+mailId+"'";
			rs.execute(sql);
			
			rs.execute("select resourceid from MailResource where originalMailId = "+mailId);
			RecordSet childSet = new RecordSet();
			while(rs.next()){
				sql = "UPDATE HrmResource SET occupySpace = " +
					  " round((select sum(size_n) from MailResource where resourceid = "+rs.getString("resourceid")+" and canview=1)*1.0/(1024*1024),2)" +
					  " WHERE id = "+ rs.getString("resourceid");
				childSet.execute(sql);
			}
		}catch(Exception e){
			flag = "false";
			new BaseBean().writeLog(e);
		}
		out.println(flag);
	}
    
    else if(operation.equals("fastReply")){
        String finalMailId = getBelongMailIds(user.getUID(), mailId);
    	if(!finalMailId.isEmpty()) {
    	    MailSend mailSend = new MailSend();
    		String state = mailSend.fastReply(mailId ,replycontent ,user,"fastReply");
    		out.println(state);
    	} else {
    	    out.println("false");
    	}
	}
    
    else if(operation.equals("receiveNeedReceipt")){
        String finalMailId = getBelongMailIds(user.getUID(), mailId);
    	if(!finalMailId.isEmpty()) {
    	    rs.execute("update MailResource set receiveNeedReceipt = 2 WHERE id="+mailId);
    		MailSend mailSend = new MailSend();
    		String state = mailSend.fastReply(mailId ,SystemEnv.getHtmlLabelName(83116,user.getLanguage()) ,user,"receiveNeedReceipt");
    		out.println(state);
    	} else {
    	    out.println("false");
    	}
	}
    
    else if(operation.equals("readReceipt")) {
        String finalMailId = getBelongMailIds(user.getUID(), mailId);
    	if(!finalMailId.isEmpty()) {
    	    rs.execute("update MailResource set receiveNeedReceipt = 2 WHERE id="+mailId);
    	}
	}
%>