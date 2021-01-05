<%@ page language="java" pageEncoding="utf-8"%>

<%@ page import="weaver.hrm.User,weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.Map,java.util.HashMap,java.util.List,java.util.ArrayList" %>
<%@page import="net.sf.json.JSONArray" %>
<jsp:useBean id="ps" class="weaver.mobile.plugin.ecology.service.PluginServiceImpl" scope="page" />
<jsp:useBean id="documentService" class="weaver.mobile.plugin.ecology.service.DocumentService" scope="page"/>
<jsp:useBean id="docManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="spopForDoc" class="weaver.splitepage.operate.SpopForDoc" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="docReply" class="weaver.docs.docs.reply.DocReplyManager" scope="page" />
<jsp:useBean id="docReplyServiceForMobile" class="weaver.docs.webservices.reply.DocReplyServiceForMobile" scope="page" />
<jsp:useBean id="docServiceForMobile" class="weaver.docs.webservices.DocServiceForMobile" scope="page" />
<jsp:useBean id="docImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="docDetailLog" class="weaver.docs.DocDetailLog" scope="page" />
<%@ page import="org.json.JSONObject"%>
<%@ page import="weaver.rdeploy.doc.MultiAclManagerNew" %>
<%@ page import="weaver.rdeploy.doc.DocShowModel" %>
<%@ page import="weaver.docs.docs.reply.PraiseInfo" %>
<%@ page import="weaver.docs.networkdisk.server.GetSecCategoryById" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.docs.pdf.docpreview.ConvertPDFUtil"%>
<%
	String sessionkey = request.getParameter("sessionkey");
	User user = HrmUserVarify.getUser(request,response);
	if(user == null){
	   Map result = ps.getCurrUser(sessionkey);
	   user = new User();
	   user.setUid(Util.getIntValue(result.get("id").toString()));
	   user.setLastname(result.get("name").toString());
	}
	
	String method = Util.null2String(request.getParameter("method"));
	JSONObject json = new JSONObject();
	if("getDocList".equals(method)){ //获取文档列表
	    String bySearch = Util.null2String(request.getParameter("bySearch")); //是否是搜索（1-是，0或其他-否）
	    String docTab = Util.null2String(request.getParameter("docTab")); //搜索类型（all-所有文档，my-我的文档，collect-我的收藏）
	    int pageSize = Util.getIntValue(request.getParameter("pageSize"),10); //每页数据条数
	    int pageNum = Util.getIntValue(request.getParameter("pageNum"),1); //页数
        List<String> conditions = new ArrayList<String>();
        if("1".equals(bySearch)){
           String keyword = Util.null2String(request.getParameter("keyword"));
          // params.put("doctitle",keyword.replaceAll("'","''"));
           conditions.add("t1.docsubject like '%"+keyword.replaceAll("'","''")+"%'");
           
        }
        Map<String,Object> results = new HashMap<String,Object>();
	    if("all".equals(docTab)){
	       results = documentService.getDocumentList2(3,user,pageNum,pageSize,-5,conditions);
	    }else if("my".equals(docTab)){
	       results = documentService.getDocumentList2(3,user,pageNum,pageSize,-4,conditions);
	    }else if("collect".equals(docTab)){
	        conditions.add("exists(select 1 from SysFavourite where favouriteObjId=t1.id and favouritetype=1 and Resourceid="+user.getUID()+")");
	        results = documentService.getDocumentList2(3, user, pageNum, pageSize, 0, conditions);
	    }
       List<Map<String,String>> docs = new ArrayList<Map<String,String>>();
       if(results != null && results.get("list") != null){
           List<Map<String, String>> list = (List<Map<String, String>>)results.get("list");
           for(Map<String,String> map : list){
               Map<String,String> doc = new HashMap<String,String>();  
               docs.add(doc);
               doc.put("docid",map.get("docid"));
	           doc.put("docTitle",map.get("docsubject"));
	           doc.put("extName",map.get("doctype"));
	           
	           doc.put("createTime",map.get("doccreatedate"));
	           doc.put("doctype",map.get("doctype"));
	           
	           String icon = "general_icon.png";
	           if("doc".equals(map.get("doctype")) || "docx".equals(map.get("doctype"))){
	               icon = "doc.png";
	           }else if("xls".equals(map.get("doctype")) || "xlsx".equals(map.get("doctype"))){
	               icon = "xls.png"; 
	           }else if("ppt".equals(map.get("doctype")) || "pptx".equals(map.get("doctype"))){
	               icon = "ppt.png";
	           }else if("pdf".equals(map.get("doctype"))){
	               icon = "pdf.png";
	           }else if("jpg".equals(map.get("doctype")) || "jpeg".equals(map.get("doctype")) || 
	                   "png".equals(map.get("doctype")) || "gif".equals(map.get("doctype")) || 
	                   "bmp".equals(map.get("doctype"))){
	               icon = "jpg.png";
	           }else if("rar".equals(map.get("doctype")) || "bar".equals(map.get("doctype")) || 
	                   "zip".equals(map.get("doctype"))){
	               icon = "rar.png";
	           }else if("txt".equals(map.get("doctype"))){
	               icon = "txt.png";
	           }else if("html".equals(map.get("doctype")) || "htm".equals(map.get("doctype"))){
	               icon = "html.png";
	           }
	           doc.put("icon",icon);
	           doc.put("userid",map.get("ownerid"));
	           doc.put("username",map.get("owner"));
               doc.put("isnew",map.get("isnew"));
	           doc.put("updateTime",map.get("docupdatedate"));
           }
       }
       
       json.put("docs",JSONArray.fromObject(docs).toString());
	}else if("getCategoryList".equals(method)){ //获取目录列表集合
	    String bySearch = Util.null2String(request.getParameter("bySearch")); //是否是搜索（1-是，0或其他-否）
	    int categoryid = Util.getIntValue(request.getParameter("categoryid"),0);
	    Map<String, String> requestMap = new HashMap<String, String>();
	    requestMap.put("categoryid", categoryid + "");
        requestMap.put("urlType", "0");
	    List<Map<String,String>> categoryList = new ArrayList<Map<String,String>>();
	    if(!"1".equals(bySearch)){
	        categoryList = GetSecCategoryById.getCategoryById(user, requestMap);
	    }
	    
	    json.put("categorys",JSONArray.fromObject(categoryList).toString());
	}else if("getCategoryDocList".equals(method)){//获取目录下文档列表集合
	    String bySearch = Util.null2String(request.getParameter("bySearch")); //是否是搜索（1-是，0或其他-否）
	    int categoryid = Util.getIntValue(request.getParameter("categoryid"),0);
	    int pageSize = Util.getIntValue(request.getParameter("pageSize"),10); //每页数据条数
	    int pageNum = Util.getIntValue(request.getParameter("pageNum"),1); //页数
	    Map<String, String> requestMap = new HashMap<String, String>();
        requestMap.put("seccategory",categoryid + "");
        requestMap.put("searchtype","adv");
	    if("1".equals(bySearch)){
	           String keyword = Util.null2String(request.getParameter("keyword"));
	           requestMap.put("doctitle",keyword.replaceAll("'","''"));
	    }
	    MultiAclManagerNew multiAclManagerNew = new MultiAclManagerNew();
	    List<DocShowModel> DocList = multiAclManagerNew.getDocList(user,requestMap,pageNum,pageSize,0);
	    
	    List<Map<String,String>> docs = new ArrayList<Map<String,String>>();
        RecordSet rs = new RecordSet();
	    for(DocShowModel docShowModel : DocList){
           Map<String,String> doc = new HashMap<String,String>();
           docs.add(doc);
           doc.put("docid",docShowModel.getDocid());
           doc.put("docTitle",docShowModel.getDoctitle());
           doc.put("extName",docShowModel.getDocExtendName());
          
           doc.put("icon",docShowModel.getDocExtendName());
           doc.put("username",docShowModel.getCreatername());
           doc.put("updateTime",docShowModel.getDocupdatedate() + " " + docShowModel.getDocupdatetime());
           String sql = "select count(0) as c from DocDetail t where t.id="+docShowModel.getDocid()+" and t.doccreaterid<>"+user.getUID()+" and not exists (select 1 from docReadTag where userid="+user.getUID()+" and docid=t.id)";
           rs.execute(sql);
           if(rs.next()&&rs.getInt("c")>0) {
               doc.put("isnew", "1");
           } else {
               doc.put("isnew", "0");
           }
       }
	   json.put("docs",JSONArray.fromObject(docs).toString());
	}else if("getDocDetail".equals(method)){ //获取文档详情
	    int docid = Util.getIntValue(request.getParameter("docid"),0);
		if(docid == 0){
		    json.put("flag","-1");
		}else{
			RecordSet rs = new RecordSet();
			rs.executeSql("select DocSubject from Docdetail where id="+docid);
			if(!rs.next()){
			    json.put("flag","-1");
			}else{
		
				//0:查看  
				boolean canReader = false;
				//1:编辑
				boolean canEdit = false;
				//2:删除
				boolean canDel = false;
				//3:共享
				boolean canShare = false ;
				
				int userid=user.getUID();
				String logintype = user.getLogintype();
				String userType = ""+user.getType();
				String userdepartment = ""+user.getUserDepartment();
				String usersubcomany = ""+user.getUserSubCompany1();
				String userSeclevel = user.getSeclevel();
				String userSeclevelCheck = userSeclevel;
				if("2".equals(logintype)){
					userdepartment="0";
					usersubcomany="0";
					userSeclevel="0";
				}
		
				docManager.resetParameter();
				docManager.setId(docid);
				docManager.getDocInfoById();
				int seccategory=docManager.getSeccategory();
				String doccontent=docManager.getDoccontent();
				String docpublishtype=docManager.getDocpublishtype();
				String docstatus=docManager.getDocstatus();
				int ishistory = docManager.getIsHistory();
				
                 int maxSize = 20;
                 int xlsSize = 15;
				//子目录信息
				rs.executeProc("Doc_SecCategory_SelectByID",seccategory+"");
				rs.next();
				String readerCanViewHistoryEdition=Util.null2String(rs.getString("readerCanViewHistoryEdition"));
				
				String userInfo=logintype+"_"+userid+"_"+userSeclevelCheck+"_"+userType+"_"+userdepartment+"_"+usersubcomany;
				List PdocList = spopForDoc.getDocOpratePopedom("" + docid,userInfo);
				
				if (((String)PdocList.get(0)).equals("true")) canReader = true ;
				if (((String)PdocList.get(1)).equals("true")) canEdit = true ;
				if (((String)PdocList.get(2)).equals("true")) canDel = true ;
				if (((String)PdocList.get(3)).equals("true")) canShare = true ;
				
				if(canReader && ((!docstatus.equals("7")&&!docstatus.equals("8")) 
		                ||(docstatus.equals("7")&&ishistory==1&&readerCanViewHistoryEdition.equals("1")))){
				  canReader = true;
				}else{
				  canReader = false;
				}
				//是否可以查看历史版本
				//具有编辑权限的用户，始终可见文档的历史版本；
				//可以设置具有只读权限的操作人是否可见历史版本；
		
				if(ishistory==1) {
					if(readerCanViewHistoryEdition.equals("1")){
				    	if(canReader && !canEdit) canReader = true;
					} else {
					    if(canReader && !canEdit) canReader = false;
					}
				}
		
				//编辑权限操作者可查看文档状态为：“审批”、“归档”、“待发布”或历史文档
				if(canEdit && ((docstatus.equals("3") || docstatus.equals("5") || docstatus.equals("6") || docstatus.equals("7")) || ishistory==1)) {
				    canReader = true;
				}
				if(canReader){
				    json.put("flag",1);
				    if(docpublishtype.equals("2")){
						int tmppos = doccontent.indexOf("!@#$%^&*");
						if(tmppos!=-1) doccontent = doccontent.substring(tmppos+8,doccontent.length());
					}
					doccontent=doccontent.replaceAll("<meta.*?/>","");
				    Map<String,Object> docInfo = new HashMap<String,Object>();
                    if( userid != docManager.getDoccreaterid() || !docManager.getUsertype().equals(logintype) ) {
	                    char flag=Util.getSeparator() ;
	                    rs.executeProc("docReadTag_AddByUser",""+docid+flag+userid+flag+logintype); 
	                    docDetailLog.resetParameter();
	                    docDetailLog.setDocId(docid);
	                    docDetailLog.setDocSubject(docManager.getDocsubject());
	                    docDetailLog.setOperateType("0");
	                    docDetailLog.setOperateUserid(user.getUID());
	                    docDetailLog.setUsertype(user.getLogintype());
	                    docDetailLog.setClientAddress(request.getRemoteAddr());
	                    docDetailLog.setDocCreater(docManager.getDoccreaterid());
	                    docDetailLog.setDocLogInfo();
                    }
					doccontent = Util.replace(doccontent, "&amp;", "&", 0);
					doccontent = doccontent.replace("<meta content=\"text/html; charset=utf-8\" http-equiv=\"Content-Type\"/>","");
					docInfo.put("canDelete",canDel);  //是否可删除
					docInfo.put("canShare",canShare); //是否可分享
					docInfo.put("docTitle",docManager.getDocsubject()); // 文档标题
					docInfo.put("doccontent",doccontent);  //文档内容
					docInfo.put("owner",resourceComInfo.getLastname(docManager.getOwnerid()+""));  //所有者 
					docInfo.put("ownerid",docManager.getOwnerid() + ""); //所有者id
					docInfo.put("updateUser",resourceComInfo.getLastname(docManager.getDoclastmoduserid() + "")); //最后更新人
					docInfo.put("updateTime",docManager.getDoclastmoddate() + " " + docManager.getDoclastmodtime());  //最后更新时间
					docInfo.put("readCount","0");  //阅读数量
					rs.executeSql("select count(1) num from DocDetailLog where docid="+docid+" and operatetype = 0");
					if(rs.next()){
					    docInfo.put("readCount",rs.getString("num")); 
					}
					docInfo.put("canReply",false);  //是否允许回复
					rs.executeSql("select replyable from DocSecCategory where id=" + seccategory);
					if(rs.next()){
					    docInfo.put("canReply","1".equals(rs.getString("replyable"))); 
					}
					
					rs.executeSql("select count(1) num from DOC_REPLY where docid='" + docid + "'");
					docInfo.put("replyCount","0"); //回复数
					if(rs.next()){
					    docInfo.put("replyCount",rs.getString("num"));     
					}
					
					PraiseInfo praiseInfo = docReply.getPraiseInfoByDocid(docid + "",user.getUID());
					docInfo.put("praiseCount","0"); //点赞数量
					docInfo.put("isPraise","0"); //是否点赞过
					if(praiseInfo.getUsers() != null){
					    docInfo.put("praiseCount",praiseInfo.getUsers().size() + "");
					    docInfo.put("isPraise",praiseInfo.getIsPraise() == 1 ? "1" : "0");
					}
					docInfo.put("isCollute","0"); //是否收藏过
					rs.executeSql("select id from SysFavourite where favouriteObjId=" + docid + " and favouritetype=1 and Resourceid="+user.getUID());
					if(rs.next()){
					    docInfo.put("isCollute","1");
					}
					boolean isUsePDFViewer = ConvertPDFUtil.isUsePDFViewer();
					//String icon = resourceComInfo.getMessagerUrls(docManager.getOwnerid() + ""); 
					 String  icon = weaver.hrm.User.getUserIcon(docManager.getOwnerid() + "");
					 String sex = resourceComInfo.getSexs(docManager.getOwnerid() + ""); 
					 String errorIcon = icon;
		             if("1".equals(sex)){
		               // icon = weaver.hrm.User.getUserIcon(docManager.getOwnerid() + "");
		                //errorIcon = "/messager/images/icon_w_wev8.jpg";
		             }else{
		              //  icon = "/messager/images/icon_m_wev8.jpg";
		                //errorIcon = "/messager/images/icon_m_wev8.jpg";
		             }
		             docInfo.put("icon",icon);//所有者头像
		             docInfo.put("errorIcon",errorIcon); // 所有者头像加载错误时加载的图片
		             //rs.executeSql("select f.imagefileid,f.imagefilename,f.filesize,df.docid from DocImageFile df,ImageFile f where df.imagefileid=f.imagefileid and df.docid=" + docid);
					 
					    int docImageId = 0;
						//DocImageManager docImageManager = new DocImageManager();
						docImageManager.resetParameter();
						docImageManager.setDocid(docid);
						docImageManager.selectDocImageInfo();					 
					 List<Map<String,String>> docAttrs = new ArrayList<Map<String,String>>(); 	
					 docInfo.put("docAttrs",docAttrs); //附件列表
					 
					 rs.executeSql("select * from DocImageFile where docid="+docid+" and (isextfile <> '1' or isextfile is null) and docfiletype <> '1' order by versionId desc");
		             if(rs.next()) {
						 Map<String,String> docAttr = new HashMap<String,String>();
						 docAttrs.add(docAttr);
						 String imfid=rs.getString("imagefileid");
						 String fname=Util.null2String(rs.getString("imagefilename"));
						 long fSize = docImageManager.getImageFileSize(Util.getIntValue(imfid));
						 String ficon = "general_icon.png";
						 
						 
						 String docImagefileSizeStr = "";
						if(fSize / (1024 * 1024) > 0) {
							docImagefileSizeStr = (fSize / 1024 / 1024) + "M";
						} else if(fSize / 1024 > 0) {
							docImagefileSizeStr = (fSize / 1024) + "K";
						} else {
							docImagefileSizeStr = fSize + "B";
						}
						String extName = fname.contains(".")? fname.substring(fname.lastIndexOf(".") + 1) : ""; 
						boolean readOnLine = false;  //是否支持在线查看
	    	            if("doc".equals(extName) || "docx".equals(extName)){
	    	                ficon = "doc.png";
                            if(fSize <= maxSize*1024*1023){
	    	                readOnLine = true;
                            }
	    	            }else if("xls".equals(extName) || "xlsx".equals(extName)){
	    	                ficon = "xls.png"; 
                            if(fSize <= xlsSize*1024*1023){
	    	                readOnLine = true;
                            }
	    	            }else if("ppt".equals(extName) || "pptx".equals(extName)){
	    	                ficon = "ppt.png";
                            if(fSize <= maxSize*1024*1023){
	    	                readOnLine = true;
                            }
	    	            }else if("pdf".equals(extName)){
	    	                ficon = "pdf.png";
	    	                readOnLine = true;
	    	            }else if("jpg".equals(extName) || "jpeg".equals(extName) || 
	    	                   "png".equals(extName) || "gif".equals(extName) || 
	    	                   "bmp".equals(extName)){
	    	                ficon = "jpg.png";
	    	            }else if("rar".equals(extName) || "bar".equals(extName) || 
	    	                   "zip".equals(extName)){
	    	                ficon = "rar.png";
	    	            }else if("txt".equals(extName)){
	    	                ficon = "txt.png";
                            if(fSize <= maxSize*1024*1023){
	    	                readOnLine = true;
                            }
	    	            }else if("html".equals(extName) || "htm".equals(extName)){
	    	                ficon = "html.png";
	    	            }
					    
	    	            if("wps".equals(extName)){
                            if(fSize <= maxSize*1024*1023){
	    	                readOnLine = true;
	     	           	}
                        }
						if(!isUsePDFViewer){
							readOnLine = false;
						}
						
						docAttr.put("imagefileid",imfid);
	    		        docAttr.put("docid",docid+"");
	    		        docAttr.put("filename",fname);
	    		        docAttr.put("ficon",ficon);
	    		        docAttr.put("fileSizeStr",docImagefileSizeStr);
	    		        docAttr.put("readOnLine",readOnLine ? "1" : "0");
						request.getSession().setAttribute("docAttr_" + user.getUID() + "_" + docAttr.get("docid") + "_" + docAttr.get("imagefileid"),"1");
					 }
					 while (docImageManager.next()) {
						 int temdiid = docImageManager.getId();
							if (temdiid == docImageId) {
								continue;
							}
							docImageId = temdiid;
		                 Map<String,String> docAttr = new HashMap<String,String>();
		                 docAttrs.add(docAttr);
					    String filename = Util.null2String(docImageManager.getImagefilename());
					    int filesize = docImageManager.getImageFileSize(Util.getIntValue(docImageManager.getImagefileid()));
					    String extName = filename.contains(".")? filename.substring(filename.lastIndexOf(".") + 1) : "";
					    String ficon = "general_icon.png";
					    boolean readOnLine = false;  //是否支持在线查看
	    	            if("doc".equals(extName) || "docx".equals(extName)){
	    	                ficon = "doc.png";
                            if(filesize <= maxSize*1024*1023){
	    	                readOnLine = true;
                            }
	    	            }else if("xls".equals(extName) || "xlsx".equals(extName)){
	    	                ficon = "xls.png"; 
                            if(filesize <= xlsSize*1024*1023){
	    	                readOnLine = true;
                            }
	    	            }else if("ppt".equals(extName) || "pptx".equals(extName)){
	    	                ficon = "ppt.png";
                            if(filesize <= maxSize*1024*1023){
	    	                readOnLine = true;
                            }
	    	            }else if("pdf".equals(extName)){
	    	                ficon = "pdf.png";
	    	                readOnLine = true;
	    	            }else if("jpg".equals(extName) || "jpeg".equals(extName) || 
	    	                   "png".equals(extName) || "gif".equals(extName) || 
	    	                   "bmp".equals(extName)){
	    	                ficon = "jpg.png";
	    	            }else if("rar".equals(extName) || "bar".equals(extName) || 
	    	                   "zip".equals(extName)){
	    	                ficon = "rar.png";
	    	            }else if("txt".equals(extName)){
	    	                ficon = "txt.png";
                            if(filesize <= maxSize*1024*1023){
	    	                readOnLine = true;
                            }
	    	            }else if("html".equals(extName) || "htm".equals(extName)){
	    	                ficon = "html.png";
	    	            }
					    
	    	            if("wps".equals(extName)){
                            if(filesize <= maxSize*1024*1023){
	    	                readOnLine = true;
                            }
	     	           	}
						if(!isUsePDFViewer){
							readOnLine = false;
						}
	    	            String fileSizeStr = "";
	    		        if(filesize / (1024 * 1024) > 0) {
	    		            fileSizeStr = (filesize / 1024 / 1024) + "M";
	    		        } else if(filesize / 1024 > 0) {
	    		            fileSizeStr = (filesize / 1024) + "K";
	    		        } else {
	    		            fileSizeStr = filesize + "B";
	    		        }
	    		        docAttr.put("imagefileid",Util.null2String(docImageManager.getImagefileid()));
	    		        docAttr.put("docid",docid+"");
	    		        docAttr.put("filename",filename);
	    		        docAttr.put("ficon",ficon);
	    		        docAttr.put("fileSizeStr",fileSizeStr);
	    		        docAttr.put("readOnLine",readOnLine ? "1" : "0");
	    		        
	    		        request.getSession().setAttribute("docAttr_" + user.getUID() + "_" + docAttr.get("docid") + "_" + docAttr.get("imagefileid"),"1");
					}
					 json.put("docInfo",docInfo);
					 json.put("flag","1");
				}else{
				    json.put("flag","0");
				}
			}
		}
	}else if("replyDoc".equals(method)){//回复
	    Map<String, Object> result = docReplyServiceForMobile.saveReply(request,user);
	    json.put("result",result);
	}else if("praiseDoc".equals(method)){ //点赞、取消点赞
	    int docid = Util.getIntValue(request.getParameter("docid"),0);
	    int replyid = Util.getIntValue(request.getParameter("replyid"),0);
	    String isPraise = Util.null2String(request.getParameter("isPraise"));
	    int replyType = 1;
	    if(replyid == 0){
	        replyType = 0;
	        replyid = docid;
	    }
	    Map<String,Object> result = null;
	    if(isPraise.equals("1")){ //取消点赞
	        result = docReplyServiceForMobile.unPraise(replyid,replyType,user,docid + "");
	    }else{ //点赞
	        result = docReplyServiceForMobile.praise(replyid,replyType,user,docid + "");
	    }
	    json.put("result",result);
	    json.put("userid",user.getUID());
	    
	}else if("coluteDoc".equals(method)){//收藏、取消收藏
	    int docid = Util.getIntValue(request.getParameter("docid"),0);
	    String isCollute = Util.null2String(request.getParameter("isCollute"));
	    Map<String,Object> result = null;
	    if("1".equals(isCollute)){//取消收藏
	        result = docServiceForMobile.undoCollect(docid + "",user);
	    }else{ //收藏
	        result = docServiceForMobile.doCollect(docid + "",user); 
	    }
	    json.put("result",result);
	}else if("getReply".equals(method)){//回复列表
	    int docid = Util.getIntValue(request.getParameter("docid"),0);
		int lastId = Util.getIntValue(request.getParameter("lastId"),0);
		int pageSize = Util.getIntValue(request.getParameter("pageSize"),10);
		int childrenSize = Util.getIntValue(request.getParameter("childrenSize"),5);
		int mainId = Util.getIntValue(request.getParameter("mainId"),0);
		String result = "[]";
		if(mainId > 0){ //获取更多子回复
		    result = docReplyServiceForMobile.getResidueReplysForReply(lastId + "",mainId + "",docid + "",user,childrenSize) ;
		    json.put("isChild","1");
		    json.put("mainId",mainId);
		}else{
		    result = docReplyServiceForMobile.getDocReply(docid + "",user,lastId,pageSize,childrenSize);
		    json.put("isChild","0");
		}
		json.put("replyList",result);
	}else if("deleteDoc".equals(method)){//删除文档
	    int docid = Util.getIntValue(request.getParameter("docid"),0);	
	    Map<String,Object> result = docServiceForMobile.deleteDoc(docid + "",user);
	    json.put("result",result);
	}
	out.println(json);
%>