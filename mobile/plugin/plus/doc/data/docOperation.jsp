<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="weaver.general.*"%>
<%@ page import="net.sf.json.*"%>
<%@ page import="org.jsoup.*" %>
<%@ page import="weaver.file.Prop" %>
<%@ page import="org.jsoup.safety.*" %>
<%@ page import="weaver.hrm.resource.ResourceComInfo" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="java.lang.reflect.Method" %>
<%@ page import="weaver.hrm.company.DepartmentComInfo" %>
<%@ page import="weaver.hrm.company.SubCompanyComInfo" %>
<%@ page import="weaver.hrm.job.JobTitlesComInfo" %>
<jsp:useBean id="docManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="docDetailLog" class="weaver.docs.DocDetailLog" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="docImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="spopForDoc" class="weaver.splitepage.operate.SpopForDoc" scope="page"/>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DocMark" class="weaver.docs.docmark.DocMark" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="dc" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="DocViewer" class="weaver.docs.docs.DocViewer" scope="page"/>
<%
	int status = 1;String msg = ""; 
	JSONObject json = new JSONObject();
	request.setCharacterEncoding("UTF-8");
	response.setContentType("application/json;charset=UTF-8");
	String operate = Util.null2String(request.getParameter("operate"));
	int userid=user.getUID();
	//int userid=1;
	try{
		if(operate.equals("getDocById")){//根据ID获取文档信息
			int docid = Util.getIntValue(request.getParameter("docid"),0);
			if(docid!=0){
				JSONObject doc = new JSONObject();
				//从文档缓存获取文档
				docManager.resetParameter();
				docManager.setId(docid);
				docManager.getDocInfoById();
				String docstatus=docManager.getDocstatus();
				String parentids = docManager.getParentids();
				int ishistory = docManager.getIsHistory();
				//判断权限
				String userType = ""+user.getType();
				String userdepartment = ""+user.getUserDepartment();
				String usersubcomany = ""+user.getUserSubCompany1();
				String logintype = user.getLogintype();
				String userSeclevel = user.getSeclevel();
				String userSeclevelCheck = userSeclevel;
				if("2".equals(logintype)){
					userdepartment="0";
					usersubcomany="0";
					userSeclevel="0";
				}
				int maincategory=docManager.getMaincategory();
				int subcategory=docManager.getSubcategory();
				int seccategory=docManager.getSeccategory();
				recordSet.executeProc("Doc_SecCategory_SelectByID",seccategory+"");
				recordSet.next();
				String readerCanViewHistoryEdition=Util.null2String(recordSet.getString("readerCanViewHistoryEdition"));

				String userInfo=logintype+"_"+userid+"_"+userSeclevelCheck+"_"+userType+"_"+userdepartment+"_"+usersubcomany;
				List PdocList = spopForDoc.getDocOpratePopedom(""+docid,userInfo);
				//0:查看  
				boolean canReader = false;
				//1:编辑
				boolean canEdit = false;
				//2:删除
				boolean canDel = false;
				//3:共享
				boolean canShare = false ;
				//4:日志
				boolean canViewLog = false;
				//5:可以回复
				boolean canReplay = false;
				//6:打印
				boolean canPrint = false;
				//7:发布
				boolean canPublish = false;
				//8:失效
				boolean canInvalidate = false;
				//9:归档
				boolean canArchive = false;
				//10:作废
				boolean canCancel = false;
				//11:重新打开
				boolean canReopen = false;
				//签出
				boolean canCheckOut = false;
				//签入
				boolean canCheckIn = false;
				//强制签入
				boolean canCheckInCompellably =false ;
				//新建工作流
				boolean cannewworkflow = true;
				//TD12005不可下载
				boolean canDownloadFromShare = false;

				if (((String)PdocList.get(0)).equals("true")) canReader = true ;
				if (((String)PdocList.get(1)).equals("true")) canEdit = true ;
				if (((String)PdocList.get(2)).equals("true")) canDel = true ;
				if (((String)PdocList.get(3)).equals("true")) canShare = true ;
				if (((String)PdocList.get(4)).equals("true")) canViewLog = true ;
				if (((String)PdocList.get(5)).equals("true")) canDownloadFromShare = true ;//TD12005

				if(canReader && ((!docstatus.equals("7")&&!docstatus.equals("8")) 
				                  ||(docstatus.equals("7")&&ishistory==1&&readerCanViewHistoryEdition.equals("1"))
								  )){
				    canReader = true;
				}else{
				    canReader = false;
				}

				//是否可以查看历史版本
				//具有编辑权限的用户，始终可见文档的历史版本；
				//可以设置具有只读权限的操作人是否可见历史版本；

				if(ishistory==1) {
					//if(SecCategoryComInfo.isReaderCanViewHistoryEdition(seccategory)){
					if(readerCanViewHistoryEdition.equals("1")){
				    	if(canReader && !canEdit) canReader = true;
					} else {
					    if(canReader && !canEdit) canReader = false;
					}
				}	

				//编辑权限操作者可查看文档状态为：“审批”、“归档”、“待发布”或历史文档
				if(canEdit && ((docstatus.equals("3") || docstatus.equals("5") || docstatus.equals("6") || docstatus.equals("7")) || ishistory==1)) {
					//canEdit = false;
				    canReader = true;
				}
				if(!canReader){//zhw20170929 没有查看权限,判断是否从日程点击过来的文档(后续补充当前人是否有权限查看该日程)
					int workplanid = Util.getIntValue(request.getParameter("workplanid"),0);
					if(workplanid!=0){
						String sdocid = "";
						if(!"oracle".equals(rs.getDBType())){
							sdocid = "(','+docid+',')";
						}else{
							sdocid = "(,||docid||,)";
						}
						rs.executeSql("select 1 from WorkPlan where id = "+workplanid+" and "+sdocid+" like '%,"+docid+",%' ");
						if(rs.next()){
							canReader = true;
						}
					}
				}
				//System.out.println(canReader+"===============");
				if(canReader){
					String docsubject=docManager.getDocsubject();//文档标题
					String doccontent=docManager.getDoccontent();//文档内容
					String docpublishtype=docManager.getDocpublishtype();//发布类型
					if(docpublishtype.equals("2")){
						int tmppos = doccontent.indexOf("!@#$%^&*");
						if(tmppos!=-1) doccontent = doccontent.substring(tmppos+8,doccontent.length());
					}
					doccontent = Util.replace(doccontent, "&amp;", "&", 0);
					doccontent = doccontent.replaceAll("<title>((.|\n)*?)</title>", "");//处理word导入中带入的title
					doccontent = doccontent.replaceAll("\u3000", "#SBCnbsp;");//处理全角空格丢失问题
					
					Whitelist user_content_filter = Whitelist.relaxed();

					user_content_filter.addTags("embed","object","param","span","div","video");
					user_content_filter.addAttributes(":all", "style", "class", "id", "name");
					user_content_filter.addAttributes("object", "width", "height","classid","codebase");	
					user_content_filter.addAttributes("param", "name", "value");
					user_content_filter.addAttributes("embed", "src","quality","width","height","allowFullScreen","allowScriptAccess","flashvars","name","type","pluginspage");
					user_content_filter.addAttributes("video", "src", "style", "controls", "autoplay", "loop", "preload");
					
					String placeholderUri = "http://WeaverReservedURL";
					int isJsonp = Util.getIntValue(Prop.getPropValue("wx_docset","isJsonp"),0);
					if(isJsonp==1){//是否需要经过JSONP处理
						doccontent = Jsoup.clean(doccontent, placeholderUri, user_content_filter);
					}
					doccontent = doccontent.replace(placeholderUri, "");
					doccontent = doccontent.replace("#SBCnbsp;", "\u3000");//处理全角空格丢失问题
					doccontent = translateMarkup(doccontent);
					
					//增加查看日志记录
					int doccreaterid=docManager.getDoccreaterid();
					
					//String logintype = "1";
					String usertype=docManager.getUsertype();
					char flag=Util.getSeparator();
					if(userid != doccreaterid || !usertype.equals(logintype)){
					    rs.executeProc("docReadTag_AddByUser",""+docid+flag+userid+flag+logintype); 
					    docDetailLog.resetParameter();
					    docDetailLog.setDocId(docid);
					    docDetailLog.setDocSubject(docsubject);
					    docDetailLog.setOperateType("0");
					    docDetailLog.setOperateUserid(userid);
					    docDetailLog.setUsertype(logintype);
					    docDetailLog.setClientAddress(request.getRemoteAddr());
					    docDetailLog.setDocCreater(doccreaterid);
					    docDetailLog.setDocLogInfo();
					}
					String lastModifyer = resourceComInfo.getLastname(docManager.getDoclastmoduserid()+"");
					String lastModfyTime = docManager.getDoclastmoddate()+"&nbsp;"+docManager.getDoclastmodtime();
					String creater = resourceComInfo.getLastname(docManager.getDoccreaterid()+"");
					String createTime = docManager.getDoccreatedate()+"&nbsp;"+docManager.getDoccreatetime();
					String owner = resourceComInfo.getLastname(docManager.getOwnerid()+"");
					
					doc.put("doccontent", doccontent);
					doc.put("docsubject", docsubject);
					//doc.put("ifHasNew", ifHasNew);
					doc.put("lastModifyer", lastModifyer);
					doc.put("lastModfyTime", lastModfyTime);
					doc.put("creater", creater);
					doc.put("createrImg", resourceComInfo.getMessagerUrls(docManager.getDoccreaterid()+""));
					doc.put("createTime", createTime);
					doc.put("createDate", docManager.getDoccreatedate());
					doc.put("owner", owner);
					//获取附件
					JSONArray js = new JSONArray();
					int docImageId = 0;
					String oldCurimgid = "";
					rs.executeSql("select * from DocImageFile where docid="+docid+" and (isextfile <> '1' or isextfile is null) and docfiletype <> '1' order by versionId desc");
					if(rs.next()) {
				        String curimgid = rs.getString("imagefileid");
				        oldCurimgid = curimgid;
				        long docImagefileSize = docImageManager.getImageFileSize(Util.getIntValue(curimgid));
				        String docImagefilename = Util.null2String(rs.getString("imagefilename"));
				        String docImagefileSizeStr = "";
				        if(docImagefileSize / (1024 * 1024) > 0) {
				        	docImagefileSizeStr = (docImagefileSize / 1024 / 1024) + "M";
				        } else if(docImagefileSize / 1024 > 0) {
				        	docImagefileSizeStr = (docImagefileSize / 1024) + "K";
				        } else {
				        	docImagefileSizeStr = docImagefileSize + "B";
				        }
				        int idx = docImagefilename.length() - 200;
				        String urlfilename = (idx > 0) ? docImagefilename.substring(idx, docImagefilename.length()) : docImagefilename;
				        urlfilename = java.net.URLEncoder.encode(urlfilename,"UTF-8");
				        JSONObject fj = new JSONObject();
				        fj.put("name", docImagefilename);
				        fj.put("urlfilename", urlfilename);
				        fj.put("size", docImagefileSizeStr);
				        fj.put("fileid", curimgid);
				        js.add(fj);
					}
				    docImageManager.resetParameter();
				    docImageManager.setDocid(docid);
				    docImageManager.selectDocImageInfo();
				    while (docImageManager.next()) {
				        int temdiid = docImageManager.getId();
				        if (temdiid == docImageId) {
				            continue;
				        }
				        docImageId = temdiid;
				        String curimgid = docImageManager.getImagefileid();
				        if(oldCurimgid.equals(curimgid)){
				        	continue;
				        }
				       
				        String curimgname = docImageManager.getImagefilename();
				        String docFileType = docImageManager.getDocfiletype();
				        long docImagefileSize = docImageManager.getImageFileSize(Util.getIntValue(curimgid));
				        String docImagefilename = Util.null2String(docImageManager.getImagefilename());
				        String docImagefileSizeStr = "";
				        if(docImagefileSize / (1024 * 1024) > 0) {
				        	docImagefileSizeStr = (docImagefileSize / 1024 / 1024) + "M";
				        } else if(docImagefileSize / 1024 > 0) {
				        	docImagefileSizeStr = (docImagefileSize / 1024) + "K";
				        } else {
				        	docImagefileSizeStr = docImagefileSize + "B";
				        }
				        
				        int idx = docImagefilename.length() - 200;
				        String urlfilename = (idx > 0) ? docImagefilename.substring(idx, docImagefilename.length()) : docImagefilename;
				        urlfilename = java.net.URLEncoder.encode(urlfilename,"UTF-8");
				        JSONObject fj = new JSONObject();
				        fj.put("name", docImagefilename);
				        fj.put("urlfilename", urlfilename);
				        fj.put("size", docImagefileSizeStr);
				        fj.put("fileid", curimgid);
				        js.add(fj);
					}
				    doc.put("fj",js);
				    doc.put("canDownload",canDownloadFromShare);
				    //获取文档回复 判断是否启用了新版本的回复
				    boolean isUseNewReply = false;
				    try{
						Class mcu = Class.forName("weaver.docs.docs.reply.DocReplyUtil");
						Method m = mcu.getMethod("isUseNewReply"); 		
						isUseNewReply = (Boolean)m.invoke(mcu);
					}catch(Exception e){
						//e.printStackTrace();
					}
				    doc.put("isUseNewReply", isUseNewReply);//true启用了新版本的回复功能
				    if(isUseNewReply){//如果启用了新版本的回复功能
				    	//获取点赞数据
				    	String sql = "SELECT ID,USERID,PRAISE_ID,PRAISE_TYPE,PRAISE_DATE,PRAISE_TIME FROM PRAISE_INFO "+
				    			"WHERE PRAISE_TYPE = 0 AND DOCID = " + docid+" order by PRAISE_DATE desc,PRAISE_TIME desc";
			            rs.executeSql(sql);
			            int praiseCount = 0;//点赞总数
			            JSONObject praise = new JSONObject();
			            JSONArray praiseList = new JSONArray();
			            DepartmentComInfo departmentComInfo = new DepartmentComInfo();
			    		SubCompanyComInfo subCompanyComInfo = new SubCompanyComInfo();
			    		JobTitlesComInfo jobTitlesComInfo = new JobTitlesComInfo();
			    		boolean ifMyPraise = false;
			            while(rs.next()){
			            	praiseCount++;
			            	JSONObject p = new JSONObject();
			            	String praiseUserid = Util.null2String(rs.getString("USERID"));
			            	if(praiseUserid.equals(userid+"")){
			            		ifMyPraise = true;
			            	}
			            	p.put("userid", praiseUserid);
			            	p.put("userName", resourceComInfo.getLastname(praiseUserid));
			            	p.put("userimg", resourceComInfo.getMessagerUrls(praiseUserid));
			            	p.put("praiseDate", Util.null2String(rs.getString("PRAISE_DATE")));
			            	p.put("praiseTime", Util.null2String(rs.getString("PRAISE_TIME")));
			            	String subCompanyID = resourceComInfo.getSubCompanyID(praiseUserid);//分部id
							String departmentID = resourceComInfo.getDepartmentID(praiseUserid);//部门id
							String jobTitle = resourceComInfo.getJobTitle(praiseUserid);//岗位id
							String subCompanyName = subCompanyComInfo.getSubCompanyname(subCompanyID);//分部名称
							String departmentName = departmentComInfo.getDepartmentname(departmentID);//部门名称
							String jobTitlesName = jobTitlesComInfo.getJobTitlesname(jobTitle);	//岗位名称
			            	p.put("userDepart", departmentName);
			            	p.put("userSubCompany", subCompanyName);
			            	p.put("userJobTitle", jobTitlesName);
			            	praiseList.add(p);
			            }
			            praise.put("ifMyPraise", ifMyPraise);
			            praise.put("count", praiseCount);
			            praise.put("praiseList", praiseList);
			            doc.put("praise",praise);
			            //同步历史回复数据
			            String csql = "select count(docid) as c from syn_old_reply where docid="+docid;
			            rs.executeSql(csql);
			            if(rs.next()){
			                if(rs.getInt("c") <= 0){
			                	try{
									Class drm = Class.forName("weaver.docs.docs.reply.DocReplyManager");
									Method m = drm.getMethod("synOldReplyData",String.class); 		
									m.invoke(drm.newInstance(),docid+"");
								}catch(Exception e){
									//e.printStackTrace();
								}
			                }
			            }
				    }
				    int readCount = 0;
				    String sql_readCount="select count(id)  from DocDetailLog where operatetype = 0 and docid =" + docid ;
		            if( user.getUID() != docManager.getDoccreaterid()|| !docManager.getUsertype().equals(user.getLogintype()) ) {
		                sql_readCount ="select count(id)+1  from DocDetailLog where operatetype = 0 and docid =" + docid ;
		            }
				    //String sql_readCount ="select sum(readCount) from docreadtag where (userid<>"+docManager.getDoccreaterid()+
				    //		" or usertype<>"+docManager.getUsertype()+") and docid =" + docid ;
		            //System.out.println(sql_readCount);
				    rs.execute(sql_readCount);
		            if(rs.next()){
		                readCount = Util.getIntValue(rs.getString(1),0) ;
		            }
				    doc.put("readCount", readCount);//阅读数量
				    doc.put("replyCount", docManager.getReplaydoccount());//回复数量
				  	//获取回复数据
				    doc.put("comment",getDocReply(docid+"",resourceComInfo,"desc",isUseNewReply,(isUseNewReply?"-1":docid+""),userid));
				    String docreplyable=SecCategoryComInfo.getSecReplyAbles(""+seccategory);
				    doc.put("ifCanReply", docreplyable.equals("1")?true:false);
				    //获取文档评分详情
				    JSONObject mark = new JSONObject();
					boolean ifCanMark = DocMark.isAllowMark(seccategory+"");
				    if(ifCanMark){
				    	int docMarkCount = DocMark.getDocMarkCount(docid+""); //打分的个数
						int docMarkSum = DocMark.getDocMarkSum(docid+"");   //总分
						double docMarkAve =MathUtil.round(DocMark.getDocMarkAve(docid+""),2);  //平均分
						mark.put("markCount",docMarkCount);
						mark.put("markSum",docMarkSum);
						mark.put("markAverage",docMarkAve);
						String strSql ="select * from docmark where docid="+docid+" and markHrmId="+userid;
						rs.executeSql(strSql);
						int myMark = 0;
						if(rs.next()){
							myMark = Util.getIntValue(rs.getString("mark"),0);
						}
						mark.put("myMark",myMark);
				    }
				    mark.put("ifCanMark", ifCanMark);
					doc.put("mark",mark);
					//获取回复表单所需要的信息
					JSONObject reply = new JSONObject();
					reply.put("docsubject", "RE:"+docsubject);
					reply.put("replydocid",docid);
					reply.put("usertype", logintype);
					reply.put("maincategory", maincategory);
					reply.put("subcategory", subcategory);
					reply.put("seccategory",seccategory );
					reply.put("docdepartmentid", userdepartment);
					reply.put("doclangurage", user.getLanguage());
					reply.put("parentids", parentids);
					reply.put("ownerid", user.getUID());
					doc.put("reply", reply);
					//是否是复地客户
					int ifFdSSo = Util.getIntValue(Prop.getPropValue("fdcsdev","ifFdSSo"),0);
					if(ifFdSSo==1){//是复地客户 增加自定义属性
						String gsbm = "",csdw = "",zsdw = "",wzzy = "";
						rs.executeSql("select gsbm,csdw,zsdw,wzzy from cus_fielddata where id = "+docid+" and scope = 'DocCustomFieldBySecCategory'");
						if(rs.next()){
							gsbm = Util.null2String(rs.getString("gsbm"));
							csdw = Util.null2String(rs.getString("csdw"));
							zsdw = Util.null2String(rs.getString("zsdw"));
							wzzy = Util.null2String(rs.getString("wzzy"));
						}
						doc.put("gsbm", gsbm);
						doc.put("csdw", csdw);
						doc.put("zsdw", zsdw);
						doc.put("wzzy", wzzy);
					}
					json.put("doc",doc);
					status = 0;
				}else{
					msg = "您无权查看此文档或数据已被删除!";
				}
			}else{
				msg = "没有获取到文档ID";
			}
		}else if(operate.equals("docReply")){
			int isUseNewReply = Util.getIntValue(request.getParameter("isUseNewReply"),0);
			if(isUseNewReply==1){//启用新的回复功能
				try{
					//request中必须包含以下参数
					//documentid 文档ID 
					//replyid 当前被回复的节点ID,如果是对文档回复则为-1
					//replytype 对文档回复为0 对文档的回复进行回复为1
					//rownerid 被回复人的ID 如张三对李四的文档或者李四的回复进行回复 这里就为李四的userid
					//replymainid: 主回复id 如果是回复文档则为空 否则为当前这条回复的parentid
					//docsubject 回复的内容
					Class docReply = Class.forName("weaver.docs.webservices.reply.DocReplyServiceForMobile");
					Method m = docReply.getDeclaredMethod("saveReply",HttpServletRequest.class,User.class);
					Map<String, Object> result = (Map<String, Object>)m.invoke(docReply.newInstance(),request,user);
					JSONObject jo = JSONObject.fromObject(result);
					if(jo.containsKey("result")&&jo.getString("result").equals("success")){
						status = 0;
					}else{
						msg = jo.containsKey("error")?jo.getString("error"):"操作返回数据格式错误";
					}
				}catch(Exception e){
					msg = "操作失败:"+e.getMessage();
				}
			}else{
				docManager.resetParameter();
				docManager.setClientAddress(this.getIpAddr(request));
				docManager.setUserid(user.getUID());
				docManager.setLanguageid(user.getLanguage());
				docManager.setUsertype(""+user.getLogintype());	 
				String message = docManager.UploadDoc(request);
				int docId=docManager.getId();
				dc.addDocInfoCache(""+docId);
				DocViewer.setDocShareByDoc(""+docId);
				rs.executeSql("update DocDetail set docStatus='1' where id="+docId);
				status = 0;
			}
		}else if(operate.equals("markDoc")){
			String docId = Util.null2String(request.getParameter("docid"));
			if(!docId.equals("")){
				String rdoMark = Util.null2String(request.getParameter("rdoMark"));//评分1-5
				String remark = Util.fromScreen(Util.null2String(request.getParameter("remark")),7);//评论   
				String currentDateStr = DocMark.getCurrentDayStr();
			    String marker = ""+user.getUID();            
			    String markId = DocMark.getMarkId(user,docId);
			    char flag = 2 ;
			    String ProcPara = "";  
		        if ("".equals(markId)){
		             ProcPara = docId;
		             ProcPara += flag  + ""+user.getLogintype() ;
		             ProcPara += flag  + ""+marker;
		             ProcPara += flag  + ""+rdoMark ;
		             ProcPara += flag  + ""+remark ;
		             ProcPara += flag  + ""+currentDateStr ;
		             rs.executeProc("DocMark_Insert",ProcPara);
		        }else{
		             ProcPara = markId ;
		             ProcPara += flag  + ""+docId ;
		             ProcPara += flag  + ""+user.getLogintype() ;
		             ProcPara += flag  + ""+marker ;
		             ProcPara += flag  + ""+rdoMark ;
		             ProcPara += flag  + ""+remark ;
		             ProcPara += flag  + ""+currentDateStr ;
		             rs.executeProc("DocMark_update",ProcPara);         
		        }
		        status = 0;
			}else{
				msg = "没有获取到要评分的文档ID";
			}
		}else if(operate.equals("getFileHtmlId")){//文档在线查看  返回解析成HTML页面的附件ID
			int fileid = Util.getIntValue(request.getParameter("fileid"),0);
			int docid = Util.getIntValue(request.getParameter("docid"),0);
			if(fileid!=0){
				String imageFileName="";int fileSize = 0;
				rs.executeSql("select imagefilename,fileSize from ImageFile where imagefileid="+fileid);
				if(rs.next()){
					imageFileName = Util.null2String(rs.getString("imagefilename"));
					fileSize = Util.getIntValue(rs.getString("fileSize"),0);
				}
				if(imageFileName.toLowerCase().endsWith(".doc")||imageFileName.toLowerCase().endsWith(".docx")
						||imageFileName.toLowerCase().endsWith(".xls")||imageFileName.toLowerCase().endsWith(".xlsx")
						||imageFileName.toLowerCase().endsWith(".pdf")){
					int maxFileSize = Util.getIntValue(rs.getPropValue("docpreview","maxFileSize"),5);
					if(fileSize>maxFileSize*1024*1024){
						msg = "您查看的文档过大，请下载文档后查看。";
					}else{
						try{
							int versionId = 0;
							
							rs.executeSql("select * from DocImageFile where imagefileid="+fileid+""+((docid!=0)?(" and docid="+docid):"")+" order by versionId desc") ;
							if(rs.next()){
								versionId = Util.getIntValue(rs.getString("versionId"),0);
								if(docid==0) docid = Util.getIntValue(rs.getString("docid"),0);
							}
							Class pvm = Class.forName("weaver.docs.docpreview.DocPreviewHtmlManager");
							Method m = pvm.getDeclaredMethod("doFileConvert",int.class,String.class,String.class,int.class,int.class);
							Object htmlFileid = m.invoke(pvm.newInstance(),fileid,null,null,docid,versionId);
							json.put("htmlFileid",htmlFileid);
							json.put("imageFileName",imageFileName);
							//增加下载日志
							char flag=Util.getSeparator();
							String logintype = user.getLogintype();
							docManager.resetParameter();
							docManager.setId(docid);
							docManager.getDocInfoById();
						    rs.executeProc("docReadTag_AddByUser",""+docid+flag+userid+flag+logintype); 
						    docDetailLog.resetParameter();
						    docDetailLog.setDocId(docid);
						    docDetailLog.setDocSubject(docManager.getDocsubject());
						    docDetailLog.setOperateType("0");
						    docDetailLog.setOperateUserid(userid);
						    docDetailLog.setUsertype(logintype);
						    docDetailLog.setClientAddress(request.getRemoteAddr());
						    docDetailLog.setDocCreater(docManager.getDoccreaterid());
						    docDetailLog.setDocLogInfo();
							status = 0;
						}catch(Exception e){
							e.printStackTrace();
							msg = "文档在线预览目前只支持E8系统，E7系统暂时无法使用";
						}
					}
				}else{
					msg = "该文档格式不支持在线预览，请下载后查看";
				}
			}else{
				msg = "没有获取到要转换为HTML格式的附件ID或文档ID";
			}
		}else if(operate.equals("praise")||operate.equals("unpraise")){//点赞和取消点赞
			String docid = Util.null2String(request.getParameter("docid"));//文档ID
			int replyid = Util.getIntValue(request.getParameter("replyid"));//点赞的节点ID 如果是对文档点赞则为文档ID否则是文档回复的ID
			int replytype = Util.getIntValue(request.getParameter("replytype"));//对文档点赞为0 对回复点赞为1
			try{
				//weaver.docs.webservices.reply.DocReplyServiceForMobile d = new weaver.docs.webservices.reply.DocReplyServiceForMobile();
				//Map<String, Object> result = d.praise(replyid, replytype, user, docid);
				Class docReply = Class.forName("weaver.docs.webservices.reply.DocReplyServiceForMobile");
				Method m = null;
				if(operate.equals("praise")){
					m = docReply.getMethod("praise",int.class,int.class,User.class,String.class);
				}else{
					m = docReply.getDeclaredMethod("unPraise",int.class,int.class,User.class,String.class);
				}
				Map<String, Object> result = (Map<String, Object>)m.invoke(docReply.newInstance(),replyid,replytype,user,docid);
				JSONObject jo = JSONObject.fromObject(result);
				if(jo.containsKey("result")&&jo.getString("result").equals("success")){
					status = 0;
				}else{
					msg = jo.containsKey("error")?jo.getString("error"):"操作返回数据格式错误";
				}
			}catch(Exception e){
				msg = "操作失败:"+e.getMessage();
			}
		}
	}catch(Exception e){
		e.printStackTrace();
		msg = e.getMessage();
	}
	json.put("status",status);
	json.put("msg",msg);
	//System.out.println(json.toString());
	out.println(json.toString());
%>
<%! 
	public JSONArray getDocReply(String docid,ResourceComInfo rc,String order,boolean isUseNewReply,String replyid,int userid){
		RecordSet rs = new RecordSet();
		StringBuffer sb = new StringBuffer();
		if(isUseNewReply){
			String rpSql = "(r.reply_parentid = '"+replyid+"'";
			if(replyid.equals("-1")){
				rpSql+=" or r.reply_parentid = '"+docid+"'";
			}
			rpSql+=")";
			sb.append("select r.id,r.content as doccontent,r.userid as doccreaterid,r.replydate as doccreatedate,");
			sb.append("r.replytime as doccreatetime,r.parentid as parentids,");
			sb.append("(select count(id) from PRAISE_INFO p where p.PRAISE_ID = r.id) as praisecount,");
			sb.append("(select max(id) from PRAISE_INFO p2 where p2.PRAISE_ID = r.id and p2.userid = "+userid+") as mypraiseid ");
			sb.append("from doc_reply r ");
			sb.append("where r.docid = '"+docid+"' and "+rpSql+" order by r.id "+order);
		}else{
			if(rs.getDBType().equals("oracle")){//oracle数据库 图文内容存放在DocDetailContent
				sb.append("select a.id,b.doccontent,a.doccreaterid,a.doccreatedate,a.doccreatetime,a.parentids from DOCDETAIL a,");
				sb.append("DocDetailContent b where a.id = b.docid and a.isreply = 1 and replydocid="+replyid);
				sb.append(" and (a.docstatus = 1 or a.docstatus = 2) order by a.id "+order);
				rs.executeSql(sb.toString());
			}else{
				sb.append("select id,doccontent,doccreaterid,doccreatedate,doccreatetime,parentids "+
						" from DocDetail where (docstatus = 1 or docstatus = 2) and isreply = 1 and replydocid="+replyid+" order by id "+order);
			}
		}
		rs.executeSql(sb.toString());
		//System.out.println(sb.toString());
		JSONArray ja = new JSONArray();
		while(rs.next()){
			String id = rs.getString("id");
			String doccreaterid = rs.getString("doccreaterid");
			String doccontent = Util.null2String(rs.getString("doccontent"));
			String parentids = Util.null2String(rs.getString("parentids"));
			String date = rs.getString("doccreatedate")+" "+rs.getString("doccreatetime");
			JSONObject comment = new JSONObject();
			comment.put("id", id);//评论ID
			comment.put("doccreaterid", doccreaterid);//评论创建人ID
			comment.put("doccontent", doccontent);//评论内容
			comment.put("doccreatedate", date);//评论时间
			comment.put("userimg", rc.getMessagerUrls(doccreaterid));//评论人头像
			comment.put("username", rc.getLastname(doccreaterid));//评论人名称
			comment.put("parentids", parentids);//旧版本回复 这里为此回复所有上级的ID包括自己 新版本回复这里为当前回复的顶级回复 如果当前回复是对文档回复此值为空
			if(isUseNewReply){
				comment.put("praisecount", Util.getIntValue(rs.getString("praisecount")));//新版本该评论的点赞数量
				comment.put("mypraiseid", Util.getIntValue(rs.getString("mypraiseid"),0));//新版本我对该评论点赞的ID 没有点赞过则为0
			}
			comment.put("subCommentList", getDocReply(docid,rc,"asc",isUseNewReply,id,userid));
			ja.add(comment);
		}
		return ja;
	}

	public String getIpAddr(HttpServletRequest request) {      
    String ip = request.getHeader("x-forwarded-for");      
    if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {      
        ip = request.getHeader("Proxy-Client-IP");      
    }      
    if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {      
        ip = request.getHeader("WL-Proxy-Client-IP");      
    }      
    if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {      
        ip = request.getRemoteAddr();      
    }   
    if ((ip.indexOf(",") >= 0)){
        ip = ip.substring(0 , ip.indexOf(","));
    }
    return ip;      
}
/**
 * 转码为可在手机上完整显示的html
 * 
 * @param bedHtml
 *            待转码的html
 * @return 转码后的html
 */
public static String translateMarkup(String bedHtml) {
	boolean isHtml = false;
	if (bedHtml == null || bedHtml.trim().equals("")) {
		return "";
	}

	StringBuffer sbfrtnRst = new StringBuffer();

	bedHtml = java.util.regex.Pattern.compile("<!--[^(-->)]+-->",
			java.util.regex.Pattern.CASE_INSENSITIVE).matcher(bedHtml)
			.replaceAll("");

	String regExHtml = "<[^>]+>";

	int mtchEndIdx = 0;

	java.util.regex.Pattern mainPattern = java.util.regex.Pattern.compile(
			regExHtml, java.util.regex.Pattern.CASE_INSENSITIVE);
	java.util.regex.Matcher mainMacher = mainPattern.matcher(bedHtml);

	while (mainMacher.find()) {
		isHtml = true;
		sbfrtnRst.append(tagConversion(bedHtml, mainMacher.group(),
				mainMacher.start(), mtchEndIdx));
		mtchEndIdx = mainMacher.end();
	}

	if (!isHtml){
		return bedHtml;
	}

	String imgresizeScript = "<SCRIPT type=\"text/javascript\">function image_resize(_this) {var innerWidth = window.innerWidth;var imgWidth = $(_this).width();if (imgWidth >= innerWidth) {$(_this).width(\"100%\");$(_this).removeAttr(\"height\");$(_this).css(\"height\", \"\");}}</SCRIPT>";
	if (!sbfrtnRst.toString().trim().equals("")) {
		return sbfrtnRst.toString() + "\r\n" + imgresizeScript;
	}
	
	return sbfrtnRst.toString();
}
/**
 * 对html中的标签进行转码
 * 
 * @param bedHtml
 *            待转码的html
 * @param mainMacher
 *            已根据
 * @param lastMatchEndIdx
 * @return
 */
private static String tagConversion(String bedHtml, String tagString,
		int tagStartIdx, int lastMatchEndIdx) {
	String rtnRst = null;
	// 标签开始下标
	int startidx = tagStartIdx;
	// 适合小设备显示的html标签
	String sedTag = tagConversion4Rule(tagString);

	// 标签之间的内容
	String mtcContnt = bedHtml.substring(lastMatchEndIdx, startidx);

	rtnRst = mtcContnt + sedTag;

	return rtnRst;
}
private static String tagConversion4Rule(String convertTag) {
	// 返回值
	String rtnRst = "";
	// 标签名称
	String tagName = "";
	// 标签属性
	String tagAttr = "";
	// 转换后的标签属性
	String newTagAttr = "";
	// style开始下标
	int styleIdx = -1;

	// 是否是结束标签
	int startTag = convertTag.charAt(1) == '/' ? 2
			: convertTag.charAt(1) != '!' ? 1 : 0;
	// 获取标签名称
	int tagNameEndIdx = convertTag.indexOf(" ");
	if (tagNameEndIdx != -1) {
		tagName = convertTag.substring(startTag, tagNameEndIdx);
	} else {
		tagName = convertTag.substring(startTag, convertTag.length() - 1);
	}

	String[] regexSplitBs = new String[] { "width=[^ ]+",
			"nowrap=\"[^\"]+\"", "width:[^;]+[; ]",
			"padding[ ]{0,}:[^;]+[; ]", "padding-top[ ]{0,}:[^;]+[; ]",
			"padding-right[ ]{0,}:[^;]+[; ]",
			"padding-bottom[ ]{0,}:[^;]+[; ]",
			"padding-left[ ]{0,}:[^;]+[; ]", "margin[ ]{0,}:[^;]+[; ]",
			"margin-top[ ]{0,}:[^;]+[; ]", "margin-right[ ]{0,}:[^;]+[; ]",
			"margin-bottom[ ]{0,}:[^;]+[; ]",
			"margin-left[ ]{0,}:[^;]+[; ]", "text-indent[ ]{0,}:[^;]+[; ]",
			"white-space[ ]{0,}:[ ]{0,}nowrap[ ]{0,}[; ]" };

	String[] regexSplitFh = new String[] { "width[ ]{0,}:[^\"^;]+[\"]",
			"padding[ ]{0,}:[^\"^;]+[\"]",
			"padding-top[ ]{0,}:[^\"^;]+[\"]",
			"padding-right[ ]{0,}:[^\"^;]+[\"]",
			"padding-bottom[ ]{0,}:[^\"^;]+[\"]",
			"padding-left[ ]{0,}:[^\"^;]+[\"]",
			"margin[ ]{0,}:[^\"^;]+[\"]", "margin-top[ ]{0,}:[^\"^;]+[\"]",
			"margin-right[ ]{0,}:[^\"^;]+[\"]",
			"margin-bottom[ ]{0,}:[^\"^;]+[\"]",
			"margin-left[ ]{0,}:[^\"^;]+[\"]",
			"text-indent[ ]{0,}:[^\"^;]+[\"]",
			"white-space[ ]{0,}:[ ]{0,}nowrap[ ]{0,}[\"]" };

	// 如果是开始标签
	if (startTag == 1) {
		// 此标签无属性
		if (tagNameEndIdx != -1) {
			tagAttr = convertTag.substring(tagNameEndIdx + 1, convertTag
					.length() - 1);
			newTagAttr = tagAttr;

			for (String srex : regexSplitBs) {
				newTagAttr = java.util.regex.Pattern.compile(srex,
						java.util.regex.Pattern.CASE_INSENSITIVE).matcher(
						newTagAttr).replaceAll("");
			}

			for (String srex : regexSplitFh) {
				newTagAttr = java.util.regex.Pattern.compile(srex,
						java.util.regex.Pattern.CASE_INSENSITIVE).matcher(
						newTagAttr).replaceAll("\"");
			}
			newTagAttr = " " + newTagAttr + " ";
			styleIdx = newTagAttr.toLowerCase().indexOf("style");
		} else {
			tagAttr = " ";
		}

		if (tagName.equalsIgnoreCase("table")) {
			
			if (styleIdx != -1) {
				newTagAttr = " " + newTagAttr.substring(0, styleIdx + 7)
						+ "table-layout: fixed;"
						+ newTagAttr.substring(styleIdx + 7)
						+ " width=\"100%\" ";
			} else {
				newTagAttr += " style=\"table-layout: fixed;\" width=\"100%\" ";
			}
		} else if (tagName.equalsIgnoreCase("td")) {
			if (styleIdx != -1) {
				newTagAttr = " " + newTagAttr.substring(0, styleIdx + 7)
						+ "word-break:break-all;word-wrap:break-word;"
						+ newTagAttr.substring(styleIdx + 7)
						+ " width=\"auto\" ";
			} else {
				newTagAttr += " style=\"word-break:break-all;word-wrap:break-word;\" width=\"auto\" ";
			}
		} else if (tagName.equalsIgnoreCase("img")) {
			newTagAttr += " onload=\"image_resize(this);\" onresize=\"image_resize(this);\" ";
		}
	}

	if (startTag == 1) {
		rtnRst = "<" + tagName + newTagAttr + ">";
	} else if (startTag == 2) {
		rtnRst = "</" + tagName + ">";
	} else if (startTag == 0) {
		rtnRst = convertTag;
	}

	return rtnRst;
}
%>