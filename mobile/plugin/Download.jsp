<%@ page language="java" contentType="application/x-download" pageEncoding="UTF-8"%><%@ 
page import="java.net.URLEncoder"%><%@ 
page import="java.net.URLDecoder"%><%@ 
page import="net.sf.json.*"%><%@ 
page import="java.util.*" %><%@ 
page import="java.util.zip.*" %><%@ 
page import="java.io.*" %><%@ 
page import="weaver.general.*" %><%@ 
page import="weaver.file.*" %><%@
page import="DBstep.iMsgServer2000" %><%@  
page import="weaver.hrm.*" %><%@ 
page import="weaver.mobile.plugin.ecology.service.EMessageService" %><%@ 
page import="weaver.WorkPlan.WorkPlanService,weaver.blog.BlogDao,weaver.cowork.CoworkDAO,weaver.meeting.MeetingUtil,weaver.workflow.request.WFUrgerManager,weaver.social.service.SocialIMService"%><%@ 
page import="weaver.conn.*" %><%@ page import="weaver.file.ImageFileManager" %><%@ page import="weaver.docs.pdf.docpreview.ConvertPDFTools" %><%@ page import="weaver.docs.pdf.docpreview.ConvertPDFUtil"%><%@ page import="weaver.docs.category.SecCategoryComInfo" %><%@ page import="weaver.splitepage.operate.SpopForDoc" %><%@ page import="weaver.docs.docs.DocManager" %><%@ page import="weaver.docs.networkdisk.server.NetworkFileLogServer"%><jsp:useBean 
id="ps" class="weaver.mobile.plugin.ecology.service.PluginServiceImpl" scope="page" /><%
//上面这句话的<%一定不要敲到下面来，否则会导致输出的附件打不开或内容乱码
String userid = Util.null2String(request.getParameter("userid"));
String markId = Util.null2String(request.getParameter("markId"));
String url = Util.null2String(request.getParameter("url"));
String sessionkey = Util.null2String(request.getParameter("sessionkey"));
//来自于手机版的邮件附件下载
String form_email= Util.null2String(request.getParameter("form_email"));

String from= Util.null2String(request.getParameter("from"));

FileUpload fu = new FileUpload(request);
if(from.isEmpty()){
	from = Util.null2String(fu.getParameter("from"));
}
//是否缩略图
String thumbnail= Util.null2String(request.getParameter("thumbnail"));
int shareFlag = 1;

String filepath = "";
String iszip = "";
String filename = "";
String contenttype = "";
String markType = "";
String isaesencrypt="";
String aescode = "";
InputStream is = null;

if(ps.verify(sessionkey)) {
	if("networkdisk".equals(from)) {
	    
	    String fileid = Util.null2String(request.getParameter("fileid"));
	    String type = Util.null2String(request.getParameter("type"));
	    String targetid = Util.null2String(request.getParameter("targetid"));
	    
	    type = type.equals("myshare") ? "myShare" : type;
	  	type = type.equals("shareme") ? "shareMy" : type;
	    
	    if(!targetid.isEmpty() && ("myShare".equals(type) || "shareMy".equals(type))){
		    NetworkFileLogServer networkFileLogServer = new NetworkFileLogServer();
		    User user = new User();
		    Map map = ps.getCurrUser(sessionkey);
		    user.setUid(Util.getIntValue(Util.null2String(map.get("id"))));
		    
		    RecordSet rs = new RecordSet();
		    rs.executeSql("select createrid from ImageFileRef where imagefileid=" + fileid);
		    String sharerid = "";
		    if(rs.next()){
		        sharerid = Util.null2String(rs.getString("createrid"));
		    }
		    
		    
		    shareFlag = networkFileLogServer.checkShare("pdoc",sharerid,targetid,fileid,user);
	    }else if("document".equals(type)){
			shareFlag = 1;
		}
		
	    if(shareFlag == 1){
	            ImageFileManager imageFileManager=new ImageFileManager();
	            imageFileManager.getImageFileInfoById(Util.getIntValue(fileid));
	            is = imageFileManager.getInputStream();
	            filename = imageFileManager.getImageFileName();
				int pdfFileId = 0;
				String file2pdf = Util.null2String(request.getParameter("file2pdf"));
				if("1".equals(file2pdf)){
						boolean isUsePDFViewer = ConvertPDFUtil.isUsePDFViewer();
				
					if(isUsePDFViewer){		
						if(filename.endsWith(".doc") || filename.endsWith(".docx") || filename.endsWith(".xls") || filename.endsWith(".xlsx") ||
							filename.endsWith(".ppt") || filename.endsWith(".pptx") || filename.endsWith(".wps") || filename.endsWith(".txt")){
							RecordSet rs = new RecordSet();
							rs.executeSql("select * from pdf_imagefile where imagefileid="+fileid);
							if(rs.next()){
								pdfFileId = Util.getIntValue(rs.getString("pdfimagefileid"),0);
							}else{
								try{
									ConvertPDFTools convertPDFTools = new ConvertPDFTools();
									pdfFileId= convertPDFTools.conertToPdf(fileid+"");
								}catch(Exception e){}
							}
							
							filename += ".pdf";
						}else if(filename.endsWith(".pdf")){
							filename += ".pdf";
						}
						if(pdfFileId > 0){
							imageFileManager.getImageFileInfoById(pdfFileId);
							is = imageFileManager.getInputStream();
						}
					}
				
				}else{
					String extName = "";
					if(filename.indexOf(".") > -1){
						int bx = filename.lastIndexOf(".");
						extName = filename.substring(bx+1, filename.length());
					}					
					if("xls".equalsIgnoreCase(extName) || "doc".equalsIgnoreCase(extName) || "ppt".equalsIgnoreCase(extName)
							|| "xlsx".equalsIgnoreCase(extName) || "docx".equalsIgnoreCase(extName) || "pptx".equalsIgnoreCase(extName)
							|| "wps".equalsIgnoreCase(extName) || "et".equalsIgnoreCase(extName)) {
						//正文的处理
						ByteArrayOutputStream bout = null;
						try {
							int byteread = 0;
							byte[] rbs = new byte[2048];
							bout = new ByteArrayOutputStream();
							while((byteread = is.read(rbs)) != -1) {
								bout.write(rbs, 0, byteread);
								bout.flush();
							}
							byte[] fileBody = bout.toByteArray();
							iMsgServer2000 MsgObj = new DBstep.iMsgServer2000();
							MsgObj.MsgFileBody(fileBody);			//将文件信息打包
							fileBody = MsgObj.ToDocument(MsgObj.MsgFileBody());    //通过iMsgServer200 将pgf文件流转化为普通Office文件流
							is = new ByteArrayInputStream(fileBody);
							bout.close();
						}
						catch(Exception e) {
							if(bout!=null) {
								bout.close();
							}
						}
					}
				}
	    }
		
	}
	else if("emessage".equals(from)) {
		filename = url;
		filepath = EMessageService.getCachePath() + File.separator + filename;
		
		if("1".equals(thumbnail)) {
			int pos = url.lastIndexOf('.');
			filename = (pos == -1) ? url : url.substring(0, pos);
			filename += ".jpg";
			filepath = EMessageService.getCachePath() + File.separator + "thumbnail" + File.separator + filename;
		}
		
		File file = new File(filepath);
		if(file.exists() && file.getCanonicalPath().startsWith(EMessageService.getCachePath())) {
			is = new BufferedInputStream(new FileInputStream(file));
		}
	} else if("1".equals(form_email)){//手机邮件的附件
			String emlsql ="select isaesencrypt,aescode,filerealpath,iszip,filename,filetype  from mailresourcefile where id="+url;
		 	RecordSet rs = new RecordSet();
		     	rs.executeSql(emlsql);
			if(rs.next()) {
				filepath = rs.getString("filerealpath");
				iszip = rs.getString("iszip");
				filename = rs.getString("filename");
				contenttype = rs.getString("filetype");
				isaesencrypt = rs.getString("isaesencrypt");
				aescode = rs.getString("aescode");
				

				//邮件附件目前还没有存放到阿里云
				File file = new File(filepath);
				if (Util.getIntValue(iszip) > 0) {
					ZipInputStream zin = new ZipInputStream(new FileInputStream(file));
					if (zin.getNextEntry() != null)
						is = new BufferedInputStream(zin);
				} else {
					is = new BufferedInputStream(new FileInputStream(file));
				}
				
				if(isaesencrypt.equals("1")){
					is = AESCoder.decrypt(is,aescode);
				}
				/*
				ImageFileManager imageFileManager=new ImageFileManager();
                imageFileManager.getImageFileInfoById(Util.getIntValue(url,0));
                is=imageFileManager.getInputStream();
				*/
			
			}
	}else if("onlyForward".equals(from)){	//表单设计器二维码、条形码
		String forwardurl = Util.null2String(request.getParameter("forwardurl"));
		request.getRequestDispatcher(forwardurl).forward(request, response);
		return;
	}else{

				if (markId!=""&&userid!="") {
					//电子签章的前端显示改用其它地址。
					return;
				} else {
					if(Util.getIntValue(url)>0) {
						
						RecordSet rs = new RecordSet();
						
					boolean needUser = true;
					
					if(needUser){
							int docId = 0;
							String docIdsForOuterNews = "";
							String strSql = "select id from DocDetail where exists (select 1 from docimagefile where imagefileid=" + url + " "
									+ "and docId=DocDetail.id) and ishistory <> 1 and (docPublishType='2' or docPublishType='3')";
							rs.executeSql(strSql);
							while (rs.next()) {
								docId = rs.getInt("id");
								if (docId > 0) {
									docIdsForOuterNews += "," + docId;
								}
							}
							if (!docIdsForOuterNews.equals("")) {
								docIdsForOuterNews = docIdsForOuterNews.substring(1);
							}
							if (!docIdsForOuterNews.equals("")) {
								String newsClause = "";
								String sqlDocExist = " select 1 from DocDetail where id in(" + docIdsForOuterNews + ") ";
								String sqlNewsClauseOr = "";
								boolean hasOuterNews = false;
								rs.executeSql("select newsClause from DocFrontPage where publishType='0'");
								while (rs.next()) {
									hasOuterNews = true;
									newsClause = Util.null2String(rs.getString("newsClause"));
									if (newsClause.equals("")) {
										needUser = false;
										break;
									}
									if (!newsClause.trim().equals("")) {
										sqlNewsClauseOr += " ^_^ (" + newsClause + ")";
									}
								}
								ArrayList newsArr = new ArrayList();
								if (!sqlNewsClauseOr.equals("") && needUser) {
									String[] newsPage = Util.TokenizerString2(sqlNewsClauseOr, "^_^");
									int i = 0;
									String newsWhere = "";
									for (; i < newsPage.length; i++) {
										if (i % 10 == 0) {
											newsArr.add(newsWhere);
											newsWhere = "";
											newsWhere += newsPage[i];
										} else
											newsWhere += " or " + newsPage[i];
									}
									newsArr.add(newsWhere);
								}
								if (hasOuterNews && needUser) {
									for (int j = 1; j < newsArr.size(); j++) {
										String newsp = newsArr.get(j).toString();
										if (j == 1)
											newsp = newsp.substring(newsp.indexOf("or") + 2);
										sqlDocExist += "and(" + newsp + ")";
										rs.executeSql(sqlDocExist);
										sqlDocExist = " select 1 from DocDetail where id in(" + docIdsForOuterNews + ") ";
										if (rs.next()) {
											needUser = false;
											break;
										}
									}
								}
							}
							//处理外网查看默认图片
							rs.executeSql("SELECT * FROM DocPicUpload  WHERE  Imagefileid=" + url);
							if (rs.next()) {
								needUser = false;
							}
					
					}
					//needUser = false;
					
					boolean hasRight = false;
				    User user = HrmUserVarify.getUser (request , response) ;
				    if(user == null) return;
				    if (needUser) {
						hasRight=getWhetherHasRight(url,user);
					} else {
						hasRight = true;
					}
					
					rs.executeSql("select  docId from docImageFile where imageFileId="+url);
					boolean hasDoc = false;
					int docid = 0;
					if(rs.next()){
					    hasDoc = true;
					    docid = rs.getInt("docid");
					}
					
					if(hasDoc && !hasRight){
						//流程判断
						String logintype = user.getLogintype();
						int requestid = Util.getIntValue(request.getParameter("requestid"));
				        if(!hasRight && requestid > 0){
				            WFUrgerManager wfu = new WFUrgerManager();
				            hasRight=wfu.OperHaveDocViewRight(requestid,user.getUID(),Util.getIntValue(logintype,1),""+docid);
				            
				            //另外一种情况,子流程触发的,当前流程创建人可以查看文档
				            if(!hasRight) {
				                rs.executeQuery("SELECT 1 FROM workflow_requestbase WHERE requestid="+requestid+" and creater="+userid);
				                if(rs.next()) {
				                    hasRight=true;
				                }
				            }
				            
				            if(!hasRight){
				                rs.writeLog("^^^^^^ E8流程判断文档没权限(" + docid + ")^^^^^^^^requestid=" + requestid);
				            }
				        }
				        
				        
				        //日程
				        boolean noMeetingDocRight = true;
				        int meetingid = Util.getIntValue(request.getParameter("meetingid"));
				        if(meetingid > 0 && !hasRight){
				            MeetingUtil mu = new MeetingUtil();
				            noMeetingDocRight = !mu.UrgerHaveMeetingDocViewRight(""+meetingid,user,Util.getIntValue(logintype),""+docid);
				            if(!noMeetingDocRight)
				            {
				                hasRight=true;
				            }
				            
				            if(!hasRight){
				               rs.writeLog("^^^^^^ 日程判断文档没权限(" + docid + ")^^^^^^^^meetingid=" + meetingid);
				            }
				        }
				        //计划
				        int workplanid = Util.getIntValue(request.getParameter("workplanid"));
				        boolean noWorkplanDocRight = true;
				        if(workplanid > 0 && !hasRight)
				        {
				            WorkPlanService workplanService = new WorkPlanService();
				            noWorkplanDocRight = !workplanService.UrgerHaveWorkplanDocViewRight(""+workplanid,user,Util.getIntValue(logintype),""+docid);
				            if(!noWorkplanDocRight)
				            {
				                hasRight=true;
				            }
				            if(!hasRight){
				                rs.writeLog("^^^^^^ 计划判断文档没权限(" + docid + ")^^^^^^^^workplanid=" + workplanid);
				            }
				        }
	
				        //工作微博点击查看文档
				        int blogDiscussid = Util.getIntValue(request.getParameter("blogDiscussid"),-1);
				        if(!hasRight && blogDiscussid != 0){
				            //工作微博记录id
				            BlogDao bd = new BlogDao();
				            if(bd.appViewRight("doc",""+userid,docid,blogDiscussid)){   
				                CoworkDAO cd = new CoworkDAO();
				                cd.shareCoworkRelateddoc(Util.getIntValue(logintype),docid,user.getUID());
				                hasRight=true;
				            }
				            if(!hasRight){
				                rs.writeLog("^^^^^^ 微博判断文档没权限(" + docid + ")^^^^^^^^blogDiscussid=" + blogDiscussid);
				            }
				        }
	
				        //协作区点击查看文档
				        int coworkid = Util.getIntValue(request.getParameter("coworkid"),-1);
				        if(!hasRight && coworkid != 0){
				            CoworkDAO cd = new CoworkDAO();
				            if(cd.haveViewCoworkDocRight(""+userid,""+coworkid,""+docid)) {
				               cd.shareCoworkRelateddoc(Util.getIntValue(logintype),docid,user.getUID());
				               hasRight=true;
				            }
				            if(!hasRight){
				                rs.writeLog("^^^^^^ 协作判断文档没权限(" + docid + ")^^^^^^^^coworkid=" + coworkid);
				            }
				        }
					}
					
			        //检查社交平台附加权限
		            hasRight = SocialIMService.checkFileRight(user, url, hasDoc, hasRight);
		            if(!hasRight){
                          rs.writeLog("^^^^^^ 社交平台判断没权限(" + url + ")^^^^^^^^hasDoc=" + hasDoc);
                     }
					
					if (hasRight) {
						//正常
						String sql = "select b.docid,a.isaesencrypt,a.aescode,a.imagefilename,a.imagefiletype,a.filerealpath,a.iszip from imagefile a LEFT join docimagefile b ON a.imagefileid = b.imagefileid where a.imagefileid = " + url;
						
						rs.executeSql(sql);
						
						if(rs.next()) {
							String docId=rs.getString("docid");
							filepath = rs.getString("filerealpath");
							iszip = rs.getString("iszip");
							filename = rs.getString("imagefilename");
							contenttype = rs.getString("imagefiletype");
							isaesencrypt = rs.getString("isaesencrypt");
							aescode = rs.getString("aescode");
							
							if(docId != null && !"".equals(docId)){
								RecordSet record = new RecordSet();
								record.executeSql("select usertype,doccreaterid from docdetail where id="+docId+"");
								if(record.next()){
									String usertype=Util.null2String(record.getString("usertype"));
									int doccreaterid = record.getInt(2);
									
									int uuid=user.getUID();
									String logintype = user.getLogintype();
									if(uuid != doccreaterid || !usertype.equals(logintype)){
										char flag=Util.getSeparator() ;
										record.executeProc("docReadTag_AddByUser",""+docId+flag+uuid+flag+logintype);
									}
								}
							}
							String extName = "";
							if(filename.indexOf(".") > -1){
								int bx = filename.lastIndexOf(".");
								extName = filename.substring(bx+1, filename.length());
							}
							
							ImageFileManager imageFileManager=new ImageFileManager();
                            imageFileManager.getImageFileInfoById(Util.getIntValue(url,0));
                            is=imageFileManager.getInputStream();
							if("xls".equalsIgnoreCase(extName) || "doc".equalsIgnoreCase(extName) || "ppt".equalsIgnoreCase(extName)
									|| "xlsx".equalsIgnoreCase(extName) || "docx".equalsIgnoreCase(extName) || "pptx".equalsIgnoreCase(extName)
									|| "wps".equalsIgnoreCase(extName) || "et".equalsIgnoreCase(extName)) {
								//正文的处理
								ByteArrayOutputStream bout = null;
								try {
									int byteread = 0;
									byte[] rbs = new byte[2048];
									bout = new ByteArrayOutputStream();
					                while((byteread = is.read(rbs)) != -1) {
					                    bout.write(rbs, 0, byteread);
					                    bout.flush();
					                }
					                byte[] fileBody = bout.toByteArray();
					                iMsgServer2000 MsgObj = new DBstep.iMsgServer2000();
									MsgObj.MsgFileBody(fileBody);			//将文件信息打包
									fileBody = MsgObj.ToDocument(MsgObj.MsgFileBody());    //通过iMsgServer200 将pgf文件流转化为普通Office文件流
					                is = new ByteArrayInputStream(fileBody);
					                bout.close();
								}
								catch(Exception e) {
									if(bout!=null) {
										bout.close();
									}
								}
							}
						
						}
						}
					} else {
						Enumeration enumeration = request.getParameterNames();
						while (enumeration.hasMoreElements()) {
							String parameterName = (String) enumeration.nextElement();
							if(parameterName.equals("sessionkey")) continue;
							if(parameterName.equals("url")) continue;
							String urlSeparator = "&";
							if(url.indexOf("?")==-1) urlSeparator = "?";
							if(url.indexOf(parameterName)==-1) {
								Object parameterValue = request.getParameter(parameterName);
								String value = parameterValue.toString();
								url += urlSeparator + parameterName + "=" + value;
							}
						}
						request.getRequestDispatcher(url).forward(request, response);
						return;
					}
				}
	}
}//end ps.verify(sessionkey)
else{//外网查看图片支持，无需用户，qc：411981
	if(Util.getIntValue(url)>0) {
		
		RecordSet rs = new RecordSet();
		
		boolean needUser = true;
		
		if(needUser){
			int docId = 0;
			String docIdsForOuterNews = "";
			String strSql = "select id from DocDetail where exists (select 1 from docimagefile where imagefileid=" + url + " "
					+ "and docId=DocDetail.id) and ishistory <> 1 and (docPublishType='2' or docPublishType='3')";
			rs.executeSql(strSql);
			while (rs.next()) {
				docId = rs.getInt("id");
				if (docId > 0) {
					docIdsForOuterNews += "," + docId;
				}
			}
			if (!docIdsForOuterNews.equals("")) {
				docIdsForOuterNews = docIdsForOuterNews.substring(1);
			}
			if (!docIdsForOuterNews.equals("")) {
				String newsClause = "";
				String sqlDocExist = " select 1 from DocDetail where id in(" + docIdsForOuterNews + ") ";
				String sqlNewsClauseOr = "";
				boolean hasOuterNews = false;
				rs.executeSql("select newsClause from DocFrontPage where publishType='0'");
				while (rs.next()) {
					hasOuterNews = true;
					newsClause = Util.null2String(rs.getString("newsClause"));
					if (newsClause.equals("")) {
						needUser = false;
						break;
					}
					if (!newsClause.trim().equals("")) {
						sqlNewsClauseOr += " ^_^ (" + newsClause + ")";
					}
				}
				ArrayList newsArr = new ArrayList();
				if (!sqlNewsClauseOr.equals("") && needUser) {
					String[] newsPage = Util.TokenizerString2(sqlNewsClauseOr, "^_^");
					int i = 0;
					String newsWhere = "";
					for (; i < newsPage.length; i++) {
						if (i % 10 == 0) {
							newsArr.add(newsWhere);
							newsWhere = "";
							newsWhere += newsPage[i];
						} else
							newsWhere += " or " + newsPage[i];
					}
					newsArr.add(newsWhere);
				}
				if (hasOuterNews && needUser) {
					for (int j = 1; j < newsArr.size(); j++) {
						String newsp = newsArr.get(j).toString();
						if (j == 1)
							newsp = newsp.substring(newsp.indexOf("or") + 2);
						sqlDocExist += "and(" + newsp + ")";
						rs.executeSql(sqlDocExist);
						sqlDocExist = " select 1 from DocDetail where id in(" + docIdsForOuterNews + ") ";
						if (rs.next()) {
							needUser = false;
							break;
						}
					}
				}
			}
			//处理外网查看默认图片
			rs.executeSql("SELECT * FROM DocPicUpload  WHERE  Imagefileid=" + url);
			if (rs.next()) {
				needUser = false;
			}
		}
		if(needUser){
			return;
		}
	
		//正常
		String sql = "select b.docid,a.isaesencrypt,a.aescode,a.imagefilename,a.imagefiletype,a.filerealpath,a.iszip from imagefile a LEFT join docimagefile b ON a.imagefileid = b.imagefileid where a.imagefileid = " + url;
		
		rs.executeSql(sql);
		
		if(rs.next()) {
			String docId=rs.getString("docid");
			filepath = rs.getString("filerealpath");
			iszip = rs.getString("iszip");
			filename = rs.getString("imagefilename");
			contenttype = rs.getString("imagefiletype");
			isaesencrypt = rs.getString("isaesencrypt");
			aescode = rs.getString("aescode");
			
			String extName = "";
			if(filename.indexOf(".") > -1){
				int bx = filename.lastIndexOf(".");
				extName = filename.substring(bx+1, filename.length());
			}
			if("jpg".equalsIgnoreCase(extName) || "jpeg".equalsIgnoreCase(extName) 
					|| "png".equalsIgnoreCase(extName) || "gif".equalsIgnoreCase(extName) || "bmp".equalsIgnoreCase(extName)) {
				ImageFileManager imageFileManager=new ImageFileManager();
	            imageFileManager.getImageFileInfoById(Util.getIntValue(url,0));
	            is=imageFileManager.getInputStream();
			}
		}
	}
}
	if(is != null) {
		
			try {
				
				response.setHeader("Content-disposition","attachment; filename=" + URLEncoder.encode(filename,"UTF-8"));
				String prefix=filename.substring(filename.lastIndexOf(".")+1);
				if(!"".equals(prefix)){
					response.setContentType("application/"+prefix);	
				}

				byte[] rbs = new byte[2048];
				OutputStream outp = response.getOutputStream();
				int len = 0;
				while (((len = is.read(rbs)) > 0)) {
					outp.write(rbs, 0, len);
				}

				outp.flush();
				//out.clear();
				out = pageContext.pushBody();

			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				if (is != null) {
					is.close();
					is = null;
				}
			}
			return;
	} else {
	    if(shareFlag == 2){ //文件已删除
	       // request.getRequestDispatcher("/mobile/plugin/networkdisk/shareMessage.jsp?shareFlag=2").forward(request, response);
	        //response.sendError(-1);
	        //response.sendError()
	        out.print("{\"status\":-1,\"msg\":\"文件已删除\"}");
	    }else if(shareFlag == 3){//共享已取消
	       // response.sendError(-2);
	        out.print("{\"status\":-2,\"msg\":\"共享已取消\"}");
	      //  request.getRequestDispatcher("/mobile/plugin/networkdisk/shareMessage.jsp?shareFlag=3").forward(request, response);
	    }else{
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
	    }
	}
%>
<%!
private boolean getWhetherHasRight(String fileId,User user)  throws Exception{
		//安全性检查
	        if(fileId==null||fileId.trim().equals("")){
	            return false;
	        }
	        RecordSet rs = new RecordSet();
	        //是否必须授权     1：是   0或其他：否
	        String mustAuth=Util.null2String(rs.getPropValue("FileDownload","mustAuth"));           
	        boolean hasRight=true; 
	        if(mustAuth.equals("1")){
	            hasRight=false;
	        }       
	        boolean isDocFile=false;
	        //文档模块  附件查看权限控制  开始
	        String docId=null;
	        List docIdList=new ArrayList();
			RecordSet rs2 = new RecordSet();
			rs2.executeSql("select  imagefilename from ImageFile where imageFileId="+fileId);
			String extName="";
			boolean isExtfile=false;
			if(rs2.next()){
	    		 String  filename = Util.null2String(rs2.getString("imagefilename"));			       	    	
					if(filename.indexOf(".") > -1){
						int bx = filename.lastIndexOf(".");
						if(bx>=0){
							extName = filename.substring(bx+1, filename.length());						
						}
					}						
			}
			if( "xls".equalsIgnoreCase(extName)||"xlsx".equalsIgnoreCase(extName) || "doc".equalsIgnoreCase(extName)|| "docx".equalsIgnoreCase(extName)||"wps".equalsIgnoreCase(extName)||"ppt".equalsIgnoreCase(extName)||"pptx".equalsIgnoreCase(extName)) {		
			isExtfile=true;
			}
	        rs.executeSql("select  docId from docImageFile where imageFileId="+fileId);
	        while(rs.next()){
	            hasRight=false;
	            docId=rs.getString(1);
	            if(docId!=null&&!docId.equals("")){
	                docIdList.add(docId);
	            }
	        }
	        String comefrom="";     
	        if(docIdList.size()==0){
	            int fileId_related=0;
	            int docId_related=0;
	            boolean hasDocId=false;
	            rs.executeSql("select comefrom from ImageFile where imageFileId="+fileId);
	            if(rs.next()){
	                comefrom=Util.null2String(rs.getString("comefrom"));
	            }   
	            String comefrom_noNeedLogin=Util.null2String(rs.getPropValue("FileDownload","comefrom_noNeedLogin"));           
	            if((","+comefrom_noNeedLogin+",").indexOf(","+comefrom+",")>=0){
	                hasRight=true;
	                return hasRight;
	            }   
	            
	            if(comefrom.equals("DocPreview")||comefrom.equals("DocPreviewHistory")){
	                rs.executeSql("select imageFileId,docId from "+comefrom+"  where (pdfFileId="+fileId+" or swfFileId="+fileId+") order by id desc");
	                if(rs.next()){
	                    fileId_related=Util.getIntValue(rs.getString("imageFileId"),0);
	                    docId_related=Util.getIntValue(rs.getString("docId"),0);                
	                }
	                if(docId_related>0){
	                    docIdList.add(""+docId_related);
	                    hasDocId=true;
	                }
	            }else if(comefrom.equals("DocPreviewHtml")||comefrom.equals("DocPreviewHtmlHistory")){
	                rs.executeSql("select imageFileId,docId from "+comefrom+"  where  htmlFileId="+fileId+" order by id desc");
	                if(rs.next()){
	                    fileId_related=Util.getIntValue(rs.getString("imageFileId"),0);
	                    docId_related=Util.getIntValue(rs.getString("docId"),0);                
	                }
	                if(docId_related>0){
	                    docIdList.add(""+docId_related);
	                    hasDocId=true;
	                }               
	            }else if(comefrom.equals("DocPreviewHtmlImage")){
	                rs.executeSql("select imageFileId,docId from DocPreviewHtmlImage  where  picFileId="+fileId+"  order by id desc");
	                if(rs.next()){
	                    fileId_related=Util.getIntValue(rs.getString("imageFileId"),0);
	                    docId_related=Util.getIntValue(rs.getString("docId"),0);                
	                }
	                if(docId_related>0){
	                    docIdList.add(""+docId_related);
	                    hasDocId=true;
	                }                   
	            }
	            if(!hasDocId&&fileId_related>0){
	                rs.executeSql("select  docId from docImageFile where imageFileId="+fileId_related);
	                while(rs.next()){
	                    docId=rs.getString(1);
	                    if(docId!=null&&!docId.equals("")){
	                        docIdList.add(docId);
	                    }
	                }               
	            }

	        }
	        if(docIdList.size()>0){
	            hasRight=false;         
	        }
	        String mustLogin=Util.null2String(rs.getPropValue("FileDownload","mustLogin"));
	        if(user==null){
	            if(mustLogin.equals("1")){
	                hasRight=false; 
	            }
	            return hasRight;
	        }
	        String comefrom_noNeedAuth=Util.null2String(rs.getPropValue("FileDownload","comefrom_noNeedAuth"));
	        if((","+comefrom_noNeedAuth+",").indexOf(","+comefrom+",")>=0){
	            hasRight=true;
	            return hasRight;
	        }       
	        DocManager docManager=new DocManager();
	        String docStatus="";
	        int isHistory=0;
	        int secCategory=0;
	        String docPublishType="";//文档发布类型  1:正常(不发布)  2:新闻  3:标题新闻
	        for(int i=0;i<docIdList.size()&&!hasRight;i++){
	            docId=(String)docIdList.get(i);
	            isDocFile=true;
	            if(docId==null||docId.trim().equals("")){
	                continue;
	            }
	            docManager.resetParameter();
	            docManager.setId(Integer.parseInt(docId));
	            try {
					docManager.getDocInfoById();
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
	            docStatus=docManager.getDocstatus();            
	            isHistory = docManager.getIsHistory();
	            secCategory=docManager.getSeccategory();    
	            docPublishType=docManager.getDocpublishtype();
	            if(docPublishType!=null&&(docPublishType.equals("2")||docPublishType.equals("3"))){
	                String newsClause="";
	                String sqlDocExist=" select 1 from DocDetail where id="+docId+" "; 
	                String sqlNewsClauseOr="";
	                boolean hasOuterNews=false;             
	                rs.executeSql("select newsClause from DocFrontPage where publishType='0'");
	                while(rs.next()){
	                    hasOuterNews=true;                  
	                    newsClause=Util.null2String(rs.getString("newsClause"));
	                    if (newsClause.equals(""))
	                    {
	                        hasRight=true;
	                        break;
	                    }
	                    if(!newsClause.trim().equals("")){
	                        sqlNewsClauseOr+=" ^_^ ("+newsClause+")";                       
	                    }
	                }
	                ArrayList newsArr = new ArrayList();
	                if(!sqlNewsClauseOr.equals("")&&!hasRight){
	                    String[] newsPage = Util.TokenizerString2(sqlNewsClauseOr,"^_^");
	                    int k = 0;
	                    String newsWhere = "";                  
	                    for(;k<newsPage.length;k++){
	                        if(k%10==0){
	                            newsArr.add(newsWhere);
	                            newsWhere="";
	                            newsWhere+=newsPage[k];
	                        }else
	                            newsWhere+=" or "+newsPage[k];  
	                    }
	                    newsArr.add(newsWhere);
	                }
	                if(hasOuterNews&&!hasRight){
	                    for(int j=1;j<newsArr.size();j++){  
	                        String newsp = newsArr.get(j).toString();                       
	                        if(j==1)
	                            newsp = newsp.substring(newsp.indexOf("or")+2);
	                        sqlDocExist+="and("+newsp+")";
	                        rs.executeSql(sqlDocExist);
	                        sqlDocExist = " select 1 from DocDetail where id="+docId+" "; 
	                        if(rs.next()){
	                            hasRight=false;
	                            break;
	                        }
	                    }
	                }               
	            }
	            if(user==null){
	                continue;
	            }
	            String userId=""+user.getUID();
	            String loginType = user.getLogintype();
	            String userSeclevel = user.getSeclevel();
	            String userType = ""+user.getType();
	            String userDepartment = ""+user.getUserDepartment();
	            String userSubComany = ""+user.getUserSubCompany1();
	            String userInfo=loginType+"_"+userId+"_"+userSeclevel+"_"+userType+"_"+userDepartment+"_"+userSubComany;
	            ArrayList PdocList = null;
	            SpopForDoc  spopForDoc=new SpopForDoc();
	            PdocList = spopForDoc.getDocOpratePopedom(""+docId,userInfo);               
	            SecCategoryComInfo secCategoryComInfo=new SecCategoryComInfo();
	            //0:查看  
	            boolean canReader = false;
	            //1:编辑
	    		boolean canEdit = false;
	    		//5:下载
	            if (((String)PdocList.get(0)).equals("true")) {canReader = true ;}
	    		if (((String)PdocList.get(1)).equals("true")) {canEdit = true ;}
	    		if (((String)PdocList.get(5)).equals("true")) {hasRight = true ;}//TD12005
	            String readerCanViewHistoryEdition=secCategoryComInfo.isReaderCanViewHistoryEdition(secCategory)?"1":"0";
	            if(canReader && ((!docStatus.equals("7")&&!docStatus.equals("8")) 
	                    ||(docStatus.equals("7")&&isHistory==1&&readerCanViewHistoryEdition.equals("1"))
	                  )){
	                canReader = true;
	            }else{
	                canReader = false;
	            }
	            if(isHistory==1) {
	                if(secCategoryComInfo.isReaderCanViewHistoryEdition(secCategory)){
	                    if(canReader && !canEdit) canReader = true;
	                } else {
	                    if(canReader && !canEdit) canReader = false;
	                }
	            }   
	            if(canEdit && ((docStatus.equals("3") || docStatus.equals("5") || docStatus.equals("6") || docStatus.equals("7")) || isHistory==1)) {
	                canEdit = false;
	                canReader = true;
	            }
	            if(canEdit && (docStatus.equals("0") || docStatus.equals("1") || docStatus.equals("2") || docStatus.equals("7")) && (isHistory!=1))
	                canEdit = true;
	            else
	                canEdit = false;
	    		if(canReader){//手机端暂时无法在线预览，有查看权限就应该允许下载
	                hasRight=true;
	            }
	        }
	        //文档模块  附件查看权限控制  结束        
	        return hasRight;
}
%>