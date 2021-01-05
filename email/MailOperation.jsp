
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.docs.docs.*" %>
<%@ page import="weaver.email.WeavermailComInfo" %>
<%@ page import="weaver.docs.category.SecCategoryComInfo" %>
<%@ page import="java.util.*, javax.mail.*"%>
<%@ page import="javax.mail.internet.*"%>
<%@ page import="javax.activation.*"%>
<%@ page import="java.net.*,java.io.*,oracle.sql.CLOB"%>
<%@ page import="weaver.system.SysCreateWF" %>

<%@ page import="weaver.email.MailDeleteFile" %>

<jsp:useBean id="mailAction" class="weaver.email.MailAction" scope="page"/>
<jsp:useBean id="workPlanViewer" class="weaver.WorkPlan.WorkPlanViewer" scope="page"/>
<jsp:useBean id="fm" class="weaver.file.FileManage" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ImageFileIdUpdate" class="weaver.docs.docs.ImageFileIdUpdate" scope="page" />
<jsp:useBean id="VersionIdUpdate" class="weaver.docs.docs.VersionIdUpdate" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
String operation = Util.null2String(request.getParameter("operation"));
String from = Util.null2String(request.getParameter("from"));
int folderId = Util.getIntValue(request.getParameter("folderId"));
int toFolderId = Util.getIntValue(request.getParameter("toFolderId"));
String sql = "";
String mailIds = Util.null2String(request.getParameter("mailIds"));;
String crmIds = Util.null2String(request.getParameter("crmIds"));
String url = "";
url = from.equals("search") ? "MailSearch.jsp?folderId=" : "MailInboxList.jsp?folderId="+folderId+"";
if(operation.equals("saveblacklist")) {    //添加黑名单
	boolean isinsert =false;
	try{
		int userId = user.getUID();
		String mailaddress = Util.null2String(request.getParameter("mailaddress"), "");
		String sqlString = "";
		if(mailaddress.indexOf('@') == -1)
			sqlString = "insert into MailBlacklist(userid , postfix) values ("+userId+",'"+mailaddress+"')";
		else
			sqlString = "insert into MailBlacklist(userid , name) values ("+userId+",'"+mailaddress+"')";
		isinsert = rs.execute(sqlString);
		String sql2 = " update MailResource set folderId = -3 where sendfrom  like '%"+mailaddress+"%' and resourceid = "+user.getUID();
		RecordSet rs2 = new RecordSet();
		rs2.execute(sql2);
	}catch(Exception e){
		e.printStackTrace();
		out.println(String.valueOf(isinsert));
	}
	out.println(String.valueOf(isinsert));
	return;
	
}else if(operation.equals("deleteblacklist")) {    //删除黑名单
	String bids = Util.null2String(request.getParameter("bids"), "");
	if(bids.endsWith(",")){
		bids = bids.substring(0, bids.length()-1);
	}
	boolean isdel =false;
	try{
		isdel = rs.execute("delete from MailBlacklist where id in (" + bids + ")");
	}catch(Exception e){
		e.printStackTrace();
		out.println(String.valueOf(isdel));
	}
	out.println(String.valueOf(isdel));
	return;
}
if(mailIds.endsWith(",")){
	mailIds = mailIds.substring(0, mailIds.length()-1);
}

//添加黑名单
if(operation.equals("addblacklist")) {
	try{
		String sqlString = "insert into MailBlacklist(userid , name)  select "+user.getUID()+", sendfrom from MailResource where id in ("+mailIds+") and sendfrom like '%@%' ";
		rs.execute(sqlString);
		String sql2 = " update MailResource set folderId = -3 where sendfrom in (select sendfrom from MailResource where id in ("+mailIds+") and sendfrom like '%@%' ) and resourceid = "+user.getUID();
		RecordSet rs2 = new RecordSet();
		rs2.execute(sql2);
	}catch(Exception e){
		e.printStackTrace();
	}
	return;
}

//移动到垃圾箱
if(operation.equals("movetodustbin")) {
	try{
		String sql2 = " update MailResource set folderId = -3 where  id in ("+mailIds+") ";
		rs.execute(sql2);
	}catch(Exception e){
		e.printStackTrace();
	}
	return;
}

if(mailIds.equals("") && !operation.equals("clear")){
	response.sendRedirect(url);
	return;
}

String[] arrayMailIds = Util.TokenizerString2(mailIds, ",");


//Delete Attachment 
//==========================================================================================================
if(operation.equals("deleteAttachment")){
	String flag = Util.null2String(request.getParameter("flag"));
	String attachmentId = Util.null2String(request.getParameter("attachmentId"));
	WeavermailComInfo wmc = (WeavermailComInfo)session.getAttribute("WeavermailComInfo") ;
    wmc.removeFile(attachmentId);
	url = "MailAdd.jsp?flag="+flag;

//UnRead 
//==========================================================================================================
}else if(operation.equals("unRead")){
	sql = "UPDATE MailResource SET status='0' WHERE resourceid="+user.getUID()+" AND id IN ("+mailIds+")";
	rs.executeSql(sql);
	//url += "&refreshTreeMenu=true";
	return;

//Readed 
//==========================================================================================================
}else if(operation.equals("readed")){
	sql = "UPDATE MailResource SET status='1' WHERE resourceid="+user.getUID()+" AND id IN ("+mailIds+")";
	rs.executeSql(sql);
	//url += "&refreshTreeMenu=true";
	return;

//Delete 
//==========================================================================================================
}else if(operation.equals("delete")){
	sql = "UPDATE MailResource SET folderId=-3 WHERE resourceid="+user.getUID()+" AND id IN ("+mailIds+")";
	rs.executeSql(sql);
	//url += "&refreshTreeMenu=true";
	return;

//Remove 
//==========================================================================================================
}else if(operation.equals("remove")){
    //增加删除附件和eml文件
    String emlPath=request.getRealPath("")+"eml\\";
    MailDeleteFile mdf=new MailDeleteFile();
    mdf.deleteFile(emlPath,mailIds,user.getUID());
   

    
	sql = "DELETE FROM MailResource WHERE resourceid="+user.getUID()+" AND id IN ("+mailIds+")";
	rs.executeSql(sql);
	sql = "DELETE FROM MailResourceFile WHERE mailid IN ("+mailIds+")";
	rs.executeSql(sql);
	//url += "&refreshTreeMenu=true";
	return;

//Clear 
//==========================================================================================================
}else if(operation.equals("clear")){
	sql = "DELETE FROM MailResource WHERE resourceid="+user.getUID()+" AND folderId=-3";
	rs.executeSql(sql);
	//url += "&refreshTreeMenu=true";
	return;

//Copy 
//==========================================================================================================
}else if(operation.equals("copy")){
	int mailId = 0;
	String fileRealPath = "";
	String copyFileRealPath = "";
	int currentMailId = 0;
	for(int i=0;i<arrayMailIds.length;i++){
		int _attachmentNum = 0;
		mailId = Util.getIntValue(arrayMailIds[i]);
		if(mailId<=0) continue;
		sql = "INSERT INTO MailResource (resourceid, priority, sendfrom, sendcc, sendbcc, sendto, senddate, size_n, subject, content, mailtype, hasHtmlImage, status, folderId, mailAccountId) ";
		sql += "SELECT "+user.getUID()+", priority, sendfrom, sendcc, sendbcc, sendto, senddate, size_n, subject, content, mailtype, hasHtmlImage, status, "+toFolderId+", mailAccountId FROM MailResource WHERE id="+mailId+"";
		rs.executeSql(sql);
		//TODO Sync
		rs.executeSql("SELECT MAX(id) FROM MailResource");
		rs.next();
		currentMailId = rs.getInt(1);
		//Copy Attachments >>>
		sql = "SELECT * FROM MailResourceFile WHERE mailid="+mailId+"";
		rs.executeSql(sql);
		RecordSet rs2 = new RecordSet();
		while(rs.next()){
			String _filename = rs.getString("filename");
			String _filetype = rs.getString("filetype");
			String _fRealPath = rs.getString("filerealpath");
			String _iszip = rs.getString("iszip");
			String _isencrypt = rs.getString("isencrypt");
			String _isfileattrachment = rs.getString("isfileattrachment");
			String _fileContentId = rs.getString("fileContentId");
			String _isEncoded = rs.getString("isEncoded");
			String _filesize = rs.getString("filesize");

			if("1".equals(_isfileattrachment)) _attachmentNum++;

			String _fRealPath_new = _fRealPath.substring(0, _fRealPath.length()-String.valueOf(mailId).length()) + "" + currentMailId;
			try{
				fm.copy(_fRealPath, _fRealPath_new);
			}catch(Exception e){
				rs2.writeLog("FileNotFound!");
				continue;
			}

			sql = "INSERT INTO MailResourceFile (mailid,filename,filetype,filerealpath,iszip,isencrypt,isfileattrachment,fileContentId,isEncoded,filesize) VALUES";
			sql+= "("+currentMailId+",'"+_filename+"','"+_filetype+"','"+_fRealPath_new+"','"+_iszip+"','"+_isencrypt+"','"+_isfileattrachment+"','"+_fileContentId+"','"+_isEncoded+"',"+_filesize+")";
			rs2.executeSql(sql);
		}
		//Update attachment number >>>
		rs.executeSql("UPDATE MailResource SET attachmentNumber="+_attachmentNum+" WHERE id="+currentMailId+"");
		//Copy EML >>>
		rs.executeSql("SELECT emlName FROM MailResource WHERE id="+mailId+"");
		if(rs.next()){
			String _emlPath = request.getRealPath("") + "eml" + File.separatorChar + Util.null2String(rs.getString("emlName")) + ".eml";
			String _emlPath_new = request.getRealPath("") + "eml" + File.separatorChar + Util.null2String(rs.getString("emlName")) + currentMailId + ".eml";
			try{
				fm.copy(_emlPath, _emlPath_new);
				rs2.executeSql("UPDATE MailResource SET emlName='"+Util.null2String(rs.getString("emlName"))+currentMailId+"' WHERE id="+currentMailId+"");
			}catch(Exception e){
				rs2.writeLog("EMLFileNotFound!");
			}
		}

		if("oracle".equals(rs.getDBType())){
			sql="insert into MailContent select "+currentMailId+", MAILCONTENT from MailContent where mailid="+mailId+"";
			rs.executeSql(sql);
		}
	}

	url += "&refreshTreeMenu=true";

//Move 
//==========================================================================================================
}else if(operation.equals("move")){
	sql = "UPDATE MailResource SET folderId="+toFolderId+" WHERE resourceid="+user.getUID()+" AND id IN ("+mailIds+")";
	rs.executeSql(sql);
	url += "&refreshTreeMenu=true";

//Export to Contacts 
//==========================================================================================================
}else if(operation.equals("exportContacts")){
	//int crmSecId = Util.getIntValue(request.getParameter("crmSecId"));
	mailAction.exportToCRMContract(crmIds, user, mailIds, request);
	
//Export to Docs 
//==========================================================================================================
}else if(operation.equals("exportDocs")){
	DocExtUtil docUtil = new DocExtUtil();
	SecCategoryComInfo scc = new SecCategoryComInfo();
	DocComInfo dc = new DocComInfo();
	DocManager dm = new  DocManager();
	DocViewer dv = new DocViewer();
	SysCreateWF sysCreateWF = new SysCreateWF();
	int mailId = 0;
	int docId=0, mainId=0, subId=0, secId=0;
	String docSubject="", docContent="", hasHtmlImage="";
	String now="", date="", time="";
	int imageId = 0;
	int versionId = 0;
	String docFileType = "";
	int docImageFileId = 0;

	//Get DocCategory
	mainId = Util.getIntValue(request.getParameter("mainId"));
	subId = Util.getIntValue(request.getParameter("subId"));
	secId = Util.getIntValue(request.getParameter("secId"));
	if(mainId==-1 && subId==-1 && secId==-1){
		rs.executeSql("SELECT mainId, subId, secId FROM MailSetting WHERE userId="+user.getUID()+"");
		rs.next();
		mainId = rs.getInt("mainId");
		subId = rs.getInt("subId");
		secId = rs.getInt("secId");
		if(mainId<=0 && subId<=0 && secId<=0){
			response.sendRedirect(url);
			return;
		}
	}
	
	rs.executeSql("select isOpenApproveWf,validityApproveWf,invalidityApproveWf from DocSecCategory where id="+secId);
	String isOpenApproveWf="";
	String validityApproveWf="";
	ArrayList infos = new ArrayList();
	if(rs.next()){
		isOpenApproveWf=rs.getString("isOpenApproveWf");
		validityApproveWf=rs.getString("validityApproveWf");
	}

	for(int i=0;i<arrayMailIds.length;i++){
		mailId = Util.getIntValue(arrayMailIds[i]);
		if(mailId<=0) continue;
		//Get Mail
		rs.executeSql("SELECT subject, content, hasHtmlImage FROM MailResource WHERE id="+mailId+"");
		rs.next();
		docSubject = SystemEnv.getHtmlLabelName(71,user.getLanguage()) + "-" + Util.null2String(rs.getString("subject"));
		docContent = Util.null2String(rs.getString("content"));

		if("oracle".equals(rs.getDBType())){
			ConnStatement statement=new ConnStatement();
			try{
			statement.setStatementSql("SELECT mailcontent FROM MailContent WHERE mailid="+mailId+"");
			statement.executeQuery();
			if(statement.next()){
				CLOB theclob = statement.getClob("mailcontent");
				String readline = "";
				StringBuffer clobStrBuff = new StringBuffer("");
				BufferedReader clobin = new BufferedReader(theclob.getCharacterStream());
				while ((readline = clobin.readLine()) != null) clobStrBuff = clobStrBuff.append(readline);
				clobin.close() ;
				docContent = clobStrBuff.toString();
			}
			}finally{
				statement.close();
			}
		}

		docContent = Util.replace(docContent, "==br==", "\n", 0);

		hasHtmlImage = Util.null2String(rs.getString("hasHtmlImage"));
		if("1".equals(hasHtmlImage)){
			rs.executeSql("select id ,isfileattrachment,fileContentId from MailResourceFile where mailid="+mailId+" and isfileattrachment=0");
			int thefilenum = 0;
			while(rs.next()){ 
				String isfileattrachment = rs.getString("isfileattrachment");
				thefilenum++;
				String imgId = rs.getString("id");
				String thecontentid = rs.getString("fileContentId");
				String oldsrc = "cid:" + thecontentid ;
				String newsrc = "http://"+Util.getRequestHost(request)+"/weaver/weaver.email.FileDownloadLocation?fileid="+imgId;
				docContent = Util.StringReplaceOnce(docContent , oldsrc , newsrc ) ;
			}
		}

		//Get DateTime
		now = TimeUtil.getCurrentTimeString() ;
		int pos = now.indexOf(" ");
		if (pos!=-1){
			date = now.substring(0,pos);
			time = now.substring(pos+1,now.length());
		}
		String defaultDummyCata = "";
		rs.executeProc("Doc_SecCategory_SelectByID",""+secId);
		if(rs.next()){
			defaultDummyCata = Util.null2String(rs.getString("defaultDummyCata"));
		}
		
		
		//Add DocDetail
		docId = dm.getNextDocId(rs);
		dm.setId(docId);
		dm.setMaincategory(mainId);
		dm.setSubcategory(subId);
		dm.setSeccategory(secId);
		dm.setDummycata(defaultDummyCata);
		dm.setLanguageid(user.getLanguage());
		dm.setDoccontent(docContent);
		if("1".equals(isOpenApproveWf)){
			dm.setDocstatus("3");
		}else{
			dm.setDocstatus("1");
		}
		dm.setDocsubject(Util.toHtml2(docSubject));
		dm.setDoccreaterid(user.getUID());
		dm.setUsertype(user.getLogintype());
		dm.setOwnerid(user.getUID());
		dm.setDoclastmoduserid(user.getUID()); 
		dm.setDoccreatedate(date);
		dm.setDoclastmoddate(date);            
		dm.setDoccreatetime(time);
		dm.setDoclastmodtime(time);
		dm.setDoclangurage(user.getLanguage());
		dm.setKeyword(Util.toHtml2(docSubject));            
		dm.setIsapprover("0");            
		dm.setIsreply("");
		dm.setDocdepartmentid(user.getUserDepartment());
		dm.setDocreplyable("1");
		
		int accessorycount=0;
		rs.executeSql("SELECT COUNT(*) FROM MailResourceFile WHERE mailId="+mailId+" AND isfileattrachment='1'");
		
		if(rs.next()){
			accessorycount = rs.getInt(1);
		}
		
		dm.setAccessorycount(accessorycount);
		dm.setParentids(""+docId);
		dm.setOrderable(""+scc.getSecOrderable(secId));
		dm.setClientAddress(request.getRemoteAddr());
		dm.setUserid (user.getUID());
		dm.AddDocInfo();
		
		RecordSet rs2 = new RecordSet();
		if("oracle".equals(rs.getDBType())){           //Oracle处理大字段    TD20387
			ConnStatement statement=new ConnStatement();
		    try{
			sql = "UPDATE DocDetailContent SET doccontent=empty_clob() WHERE docid= ? ";
			statement.setStatementSql(sql);
			statement.setInt(1, docId);
			statement.executeUpdate();
			sql = "select doccontent from DocDetailContent where docid = " + docId;
			statement.setStatementSql(sql, false);
			statement.executeQuery();
			statement.next();
			CLOB theclob = statement.getClob(1);
			String doccontenttemp = docContent; 
			char[] contentchar = doccontenttemp.toCharArray();
			Writer contentwrite = theclob.getCharacterOutputStream();
			contentwrite.flush();
			contentwrite.write(contentchar);
			contentwrite.close();
		    }finally{
		    	statement.close();
		    }
			//sql = "UPDATE DocDetailContent SET doccontent='"+docContent+"' WHERE docid="+docId+"";
			//rs2.executeSql(sql);
		}

		//================================================================
		//TD6597 文档模块增加字段导致bug
		rs2.executeSql("UPDATE DocDetail SET docpublishtype='1',usertype='1',maindoc="+docId+",docvaliduserid="+user.getUID()+",docvaliddate='"+date+"',docvalidtime='"+time+"',docCreaterType='1',docLastModUserType='1',docValidUserType='1',ownerType='1' WHERE id="+docId+"");
		//================================================================

		//Add DocAttachments
		rs.executeSql("SELECT * FROM MailResourceFile WHERE mailId="+mailId+" AND isfileattrachment='1'");
		while(rs.next()){
			//Get ImageFileId
			//rs2.executeProc("SequenceIndex_SelectFileid" , "");
			//if(rs2.next())	imageId = Util.getIntValue(rs2.getString(1));
			imageId=ImageFileIdUpdate.getImageFileNewId();

			//Add ImageFile
			//需要复制附件
			String _temppath = Util.null2String(rs.getString("filerealpath"));
			String filename = System.currentTimeMillis() + "";

			String _fRealPath_new = _temppath.substring(0, _temppath.length()-String.valueOf(mailId).length()) + "" + filename;
			try{
				fm.copy(_temppath, _fRealPath_new);
				_temppath = _fRealPath_new;
			}catch(Exception e){
				
			}
			
			sql = "INSERT INTO ImageFile (imagefileid, imagefilename, imagefiletype, imagefile, imagefileused, filerealpath, iszip, isencrypt, fileSize, downloads) VALUES ";
			sql += "("+imageId+", '"+rs.getString("filename")+"', '"+rs.getString("filetype")+"', '"+rs.getString("attachfile")+"', 1, '"+_temppath+"', '"+rs.getString("iszip")+"', '"+rs.getString("isencrypt")+"', "+rs.getString("filesize")+", 0)";
			rs2.executeSql(sql);
			//Get VersionId
			//rs2.executeProc("SequenceIndex_SelectVersionId", "") ;
			//if(rs2.next())	versionId = Util.getIntValue(rs2.getString(1));
			versionId=VersionIdUpdate.getVersionNewId();

			//Get ImageFileType
			docFileType = docUtil.getFileExt(rs.getString("filename"));
			if(docFileType.equalsIgnoreCase("doc")){
				docFileType = "3";
            }else if(docFileType.equalsIgnoreCase("xls")){
                docFileType = "4";
            }else {
                docFileType = "2";
            }
			//Get DocImageFileId
			rs2.executeProc("SequenceIndex_SelectDocImageId", "") ;
            if(rs2.next()) docImageFileId = Util.getIntValue(rs2.getString(1));
			//Add DocImageFile
			sql = "INSERT INTO DocImageFile (id, docid, imagefileid, imagefilename, docfiletype, versionId) VALUES";
			sql += "("+docImageFileId+", "+docId+", "+imageId+", '"+rs.getString("filename")+"', '"+docFileType+"', "+versionId+")";
			rs2.executeSql(sql);
		}
		//Add Share
		dm.AddShareInfo();
		dc.addDocInfoCache(""+docId);
		dv.setDocShareByDoc(""+docId);
		 
		if("1".equals(isOpenApproveWf)){
			RecordSet rs3 = new RecordSet();
			String sql3 = "select formid,workflowtype,isbill from workflow_base where id="+validityApproveWf;
			rs3.executeSql(sql3);
			int formid = 0;
			String workflowtype = ""; 
			int isbill = 0;
			if(rs3.next()){
				formid = rs3.getInt("formid");
				workflowtype = rs3.getString("workflowtype");
				isbill = rs3.getInt("isbill");
				//messageType = RecordSet.getInt("messageType");
			}
			
			if(isbill==0){
				sql3 = "select workflow_formfield.fieldid as id,fieldname as name,workflow_fieldlable.fieldlable as label,workflow_formdict.fieldhtmltype as htmltype,workflow_formdict.type as type,workflow_formdict.fielddbtype from workflow_formfield,workflow_formdict,workflow_fieldlable where workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.isdefault = 1 and workflow_fieldlable.fieldid =workflow_formfield.fieldid and workflow_formdict.id = workflow_formfield.fieldid and workflow_formfield.formid="+formid;
			}else if(isbill==1){
				sql3 = "select id as id,fieldname as name,fieldlabel as label,fieldhtmltype as htmltype,type as type,fielddbtype from workflow_billfield where viewtype=0 and billid = "+formid + " order by dsporder ";
			}
			rs3.executeSql(sql3);
			boolean docFlog=true;
			while(rs3.next()){
				String fieldhtmltype = Util.null2String(rs3.getString("htmltype"));
				String fieldtype = Util.null2String(rs3.getString("type"));
				if(fieldhtmltype.equals("3") && (fieldtype.equals("37") || fieldtype.equals("9")) && docFlog){
					infos.add(docId);
					docFlog=false;
				}else{
					infos.add("");
				}
			}
			sysCreateWF.setWorkflowInfo(Util.getIntValue(validityApproveWf),"邮件导出文档审批-"+docSubject,user.getUID(),infos);
		}
	}
}

response.sendRedirect(url);
%>
