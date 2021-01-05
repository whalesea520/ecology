<%@ page language="java" pageEncoding="utf-8"%>

<%@ page import="weaver.hrm.User,weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.Map,java.util.HashMap,java.util.List,java.util.ArrayList" %>
<%@page import="weaver.rdeploy.doc.PrivateSeccategoryManager"%>
<%@page import="weaver.general.TimeUtil"%>
<jsp:useBean id="privateSeccategoryManager" class="weaver.rdeploy.doc.PrivateSeccategoryManager" scope="page" />
<jsp:useBean id="privateSearchManager" class="weaver.rdeploy.doc.PrivateSearchManager" scope="page" />
<jsp:useBean id="shareSearchManager" class="weaver.rdeploy.doc.ShareSearchManager" scope="page" />
<%@ page import="weaver.rdeploy.doc.SeccategoryShowModel" %>
<jsp:useBean id="multiAclManager" class="weaver.rdeploy.doc.MultiAclManagerNew" scope="page" />
<%@page import="net.sf.json.JSONArray" %>
<jsp:useBean id="ps" class="weaver.mobile.plugin.ecology.service.PluginServiceImpl" scope="page" />
<%@ page import="org.json.JSONObject"%>
<%@page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.docs.networkdisk.server.PublishNetWorkFile"%>
<%@ page import="weaver.docs.networkdisk.server.NetworkFileLogServer"%>
<%@ page import="weaver.docs.networkdisk.server.NetWorkDiskFileOperateServer"%>
<%@ page import="weaver.docs.networkdisk.tools.ImageFileUtil"%>
<%@ page import="weaver.docs.networkdisk.bean.DocAttachment" %>
<%@ page import="weaver.docs.networkdisk.server.UploadFileServer" %>
<%@ page import="weaver.file.FileUpload" %>

<%
	String sessionkey = request.getParameter("sessionkey");
	User user = HrmUserVarify.getUser(request,response);
	if(user == null){
	   Map result = ps.getCurrUser(sessionkey);
	   user = new User();
	   user.setUid(Util.getIntValue(result.get("id").toString()));
	   user.setLastname(result.get("name").toString());
	}
	String method = request.getParameter("method");
	FileUpload fu = null;
	if(method == null){
	    fu = new FileUpload(request);
	    method = fu.getParameter("method");
	}
	
	String reqid = Util.null2String(request.getParameter("folderid"));
	int folderid = 0;
	if(!reqid.isEmpty()){
	   folderid = Util.getIntValue(reqid,0);
	}
	
	String keyword = Util.null2String(request.getParameter("keyword"));
	keyword = keyword.replaceAll("'","''");

	JSONObject json = new JSONObject();
    PrivateSeccategoryManager seccategoryManager = new PrivateSeccategoryManager();
	
	if("getDataList".equals(method)){ //获取目录
	    
	    RecordSet rs0 = new RecordSet();
        
        String rootname = user.getUID()+"_"+user.getLastname();
        String sql0 = "select id from DocPrivateSecCategory where categoryname = '" + rootname + "' and parentid = 0";
        rs0.executeSql(sql0);
        int rootid = 0;
        if(rs0.next()){
            rootid = rs0.getInt("id");
        }
        
        String sql = "";
        boolean isoracle = (rs0.getDBType()).equals("oracle") ;
        if(isoracle){
            sql = "select id from DocPrivateSecCategory where id=" + rootid + " start with id=" + folderid + " connect by nocycle prior parentid=id";
        }else{
             sql = "with alldata as " +
                     "(select * from DocPrivateSecCategory where id=" + rootid + " and parentid=0 union all select d.* " +
                     "from alldata a,DocPrivateSecCategory d where a.parentid=d.id)" +
                     "select *from alldata where id=" + rootid;
        }
        
        rs0.executeSql(sql);
        if(!rs0.next()){
            json.put("folders","[]");
            json.put("files","[]");
            out.println(json);
            return ; 
        }
	    
	    
		String bySearch = Util.null2String(request.getParameter("bySearch")); // 1-搜索
	 //   String isFirst = request.getParameter("isFirst");
	    String view = Util.null2String(request.getParameter("view")); //disk,myShare,shareMy
	    view = "disk".equals(view) ? "privateAll" : view;
	    
		List<Map<String,String>> dataList = new ArrayList<Map<String,String>>();
		if("1".equals(bySearch)){ // 搜索
		    int type = 0;
		    if("privateAll".equals(view)){
			    int pageSize = Util.getIntValue(request.getParameter("pageSize"),10);
			    int pageNum = Util.getIntValue(request.getParameter("pageNum"),1);
			    dataList = privateSearchManager.searchPrivateDocsByKeyword(user,keyword,pageNum,pageSize,"","desc");
		    }else{
		        type = 1;
		        dataList = shareSearchManager.getShareForFolderAndDocs(user,view.toLowerCase(),keyword,"","desc");
		    }
		
		    /**添加搜索日志start*/
		      if(!keyword.isEmpty()){
	           String searchdate=TimeUtil.getCurrentDateString();
	           String searchtime=TimeUtil.getOnlyCurrentTimeString();
	           String checksql = "select id from HistorySearch where userid = '"+user.getUID()+"' and searchtext = '"+keyword+"' and searchtype=" + type ;
	           RecordSet rs = new RecordSet();
	           rs.executeSql(checksql);
	          // String sql = "";
	           if(rs.next()){
	               sql = "update HistorySearch set searchdate='"+searchdate+"',searchtime='"+searchtime+"' where userid = '"+user.getUID()+"' and searchtext = '"+keyword+"' and searchtype=" + type ;
	           }
	           else{
	               sql = "insert into HistorySearch(userid,searchtext,searchdate,searchtime,searchtype) " + 
	               "values('"+user.getUID()+"','"+keyword+"','"+searchdate+"','"+searchtime+"',"+type+")";
	           }
	           rs.executeSql(sql);
		      }
	           /**添加搜索日志end*/
		}else{
		    if("privateAll".equals(view) || folderid > 0){
		        if(folderid == 0){
			        folderid = seccategoryManager.getUserPrivateCategoryId(user);
			    }
			    dataList = privateSearchManager.getFolderAndDocsForPrivateByCategoryid(folderid,"","desc");
		    }else{
			    dataList = shareSearchManager.getShareForFolderAndDocs(user,view.toLowerCase(),"","","desc");
		    }
		}
		
		List<Map<String,String>> folderList = new ArrayList<Map<String,String>>();
		List<Map<String,String>> fileList = new ArrayList<Map<String,String>>();
		//if("privateAll".equals(view)){
	    for(Map<String,String> data : dataList){
            Map<String,String> map = new HashMap<String,String>();
	        if("folder".equals(data.get("type"))){
	            map.put("id",data.get("id"));
	            map.put("name",data.get("categoryname"));
	            map.put("pid", data.get("parentid")); 
	            map.put("pid","");
	            map.put("icon","2.png");  
	            map.put("size","");
	            map.put("datetime", "");
	            
	            if(!"privateAll".equals(view)){ //分享
	                if("1".equals(bySearch) || folderid == 0){  //搜索 或者 根目录 
			            if(data.get("username") != null){
			                map.put("username",data.get("username"));
			            }
			            if(data.get("shareid") != null){
			                map.put("shareid",data.get("shareid"));
			            }
			            if(data.get("sharetime") != null){
			                map.put("datetime",data.get("sharetime"));
			            }
	                }else{  //分享目录 子目录 
	                    if("shareMy".equals(view)){
	                        map.put("username",Util.null2String(request.getParameter("sharefrom")));
	                    }
	                    map.put("datetime",Util.null2String(request.getParameter("sharetime")));
	                }
	            }
	            
	            
	            folderList.add(map);
	        }else if("1".equals(bySearch) || "doc".equals(data.get("type"))){
	            map.put("id",data.get("imagefileId"));
	            map.put("name",data.get("fullName"));
	            map.put("icon",data.get("docExtendName"));
	            map.put("size",data.get("fileSize"));
	            map.put("datetime", data.get("datetime"));
	            if(!"privateAll".equals(view)){ //分享
	                if("1".equals(bySearch) || folderid == 0){  //搜索 或者 根目录 
			            if(data.get("username") != null){
			                map.put("username",data.get("username"));
			            }
			            if(data.get("shareid") != null){
			                map.put("shareid",data.get("shareid"));
			            }
			            if(data.get("sharetime") != null){
			                map.put("datetime",data.get("sharetime"));
			            }
	                }else{  //分享目录 子目录 
	                    if("shareMy".equals(view)){
	                        map.put("username",Util.null2String(request.getParameter("sharefrom")));
	                    }
	                    map.put("datetime",Util.null2String(request.getParameter("sharetime")));
	                }
	            }
	            fileList.add(map);
	        }
	    }
		//}
		
	    json.put("folders",JSONArray.fromObject(folderList).toString());
	    json.put("files",JSONArray.fromObject(fileList).toString());
	    
	}else if("getCategorys".equals(method)){//公共目录
	    String categoryid = request.getParameter("category");
	    String category = multiAclManager.getPermittedTree(user,categoryid);
	    json.put("category",category);
	}else if("getPrivateCategorys".equals(method)){
	    
	    RecordSet rs = new RecordSet();
	    String rootname = user.getUID()+"_"+user.getLastname();
	    String sql = "select id from DocPrivateSecCategory where categoryname = '" + rootname + "' and parentid = 0";
        rs.executeSql(sql);
        int rootid = 0;
        if(rs.next()){
            rootid = rs.getInt("id");
        }else{
            SeccategoryShowModel model = seccategoryManager.createSeccategory(user,rootname,0); 
            rootid = Util.getIntValue(model.getSid(),0);
        }
	    
        String categoryname = Util.null2String(request.getParameter("categoryname"));
        
        boolean isoracle = (rs.getDBType()).equals("oracle") ;
        if(isoracle){
            if(categoryname.isEmpty()){
                sql = "select *from DocPrivateSecCategory start with id=" + rootid + "connect by nocycle prior id=parentid";
                		
            }else{
                sql = "select distinct * from DocPrivateSecCategory start with categoryname like '%" + categoryname + "%' connect by nocycle prior parentid=id";
            }
        }else{
			if(categoryname.isEmpty()){
                sql = "with alldata as " +
		                "(select * from DocPrivateSecCategory where id=" + rootid + " and parentid=0 union all select d.* " +
		                "from alldata a,DocPrivateSecCategory d where d.parentid=a.id)" +
		                "select *from alldata";
            }else{
                sql = "with alldata as " +
                "(select * from DocPrivateSecCategory where categoryname like '%" + categoryname + "%' union all select d.* " +
                "from alldata a,DocPrivateSecCategory d where d.id=a.parentid)" +
                "select distinct * from alldata";
            } 
        }
        rs.executeSql(sql);
        Map<String,Map<String,String>> map = new HashMap<String,Map<String,String>>();
        while(rs.next()){
            if(rs.getInt("id") == rootid) continue;
            Map<String,String> m = new HashMap<String,String>();
            m.put("id",Util.null2String(rs.getString("id")));
            m.put("name",Util.null2String(rs.getString("categoryname")));
            m.put("pid",rs.getInt("parentid") == rootid ? "0" : Util.null2String(rs.getString("parentid")));
            map.put(m.get("id"),m);
        }
       json.put("data",map);
	    
	}else if("public".equals(method)){//发布到系统
	    PublishNetWorkFile publishNetWorkFile = new PublishNetWorkFile();
	    String fileids = Util.null2String(request.getParameter("fileids"));
	    String folderids = Util.null2String(request.getParameter("folderids"));
	    int category = Util.getIntValue(request.getParameter("category"),0);
	    if(category > 0){
		    List<Map<String,String>> files = new ArrayList<Map<String,String>>();
		    if(!folderids.isEmpty()){
		        files = ImageFileUtil.getAllFileByFolder(folderids,true);
		    }
		    String []fileIds1 = fileids.split(",");
		    List<Integer> ids = new ArrayList<Integer>();
		   	for(String id : fileIds1){
		   		ids.add(Util.getIntValue(id,0));
		   	}
		   	for(Map<String,String> file : files){
		   	    ids.add(Util.getIntValue(file.get("fileid"),0));
		   	}
			List<DocAttachment> attInfos = publishNetWorkFile.publishNetWorkFile(ids,category,user,0);
			if(attInfos!=null){
				String docids = "";
			    for(DocAttachment attInfo : attInfos){
			        if(attInfo.getReturnStatus().equals(DocAttachment.STATUS_SUCCESS)){
			        	docids += "," + attInfo.getDocid();
			        }
				}
			    if(!docids.isEmpty()){
			        docids = docids.substring(1);
			        RecordSet rs = new RecordSet();
			    	rs.executeSql("update DocDetail set docstatus=1 where id in(" + docids + ") and docstatus=-1");
			    	json.put("flag",1);
			    }
			}
	    }
	    
	}else if("cancelShare".equals(method)){//取消分享
	  // String shareid = Util.null2String(request.getParameter("shareid"));
	   String fileids = Util.null2String(request.getParameter("fileids"));
	   String folderids = Util.null2String(request.getParameter("folderids"));
		if(!fileids.isEmpty() || !folderids.isEmpty()){ 
			NetworkFileLogServer nfs= new NetworkFileLogServer();
			List<Map<String,String>> mesList = new ArrayList<Map<String,String>>();
			boolean result = nfs.cancelShare(user,fileids,folderids,mesList);
		    json.put("mesList",mesList);
			if(result){
			    json.put("flag","1");
			}
		}
		
	}else if("save2Disk".equals(method)){//保存到网盘
	   String fileids = Util.null2String(request.getParameter("fileids"));
	   String folderids = Util.null2String(request.getParameter("folderids"));
	 //  String shareids = Util.null2String(request.getParameter("shareids"));
	   if(folderid == 0){
	       folderid = seccategoryManager.getUserPrivateCategoryId(user);
	   }
	   
	   String from = request.getParameter("from");
		boolean b = true;
		if("saveFromMsg".equals(from)){ //来自于 message 的保存
		   int fileid = Util.getIntValue(fileids,0);
		   int _folderid = Util.getIntValue(folderids,0);
		   if(fileid > 0 || folderid > 0){
			   NetworkFileLogServer networkFileLogServer = new NetworkFileLogServer();
			  int flag = networkFileLogServer.checkShareMy(fileid,_folderid,folderid,user);
			  if(flag == 1){
			  }else if(flag == 2){
			      json.put("flag","-1");
			     json.put("msg",fileid > 0 ? "文件已删除!" : "目录已删除!"); 
			     b = false; 
			  }else if(flag == 3){
			      json.put("flag","-2");
			     json.put("msg","共享已取消!"); 
			      b = false; 
			  }else if(flag == 4){
			      json.put("flag","-4");
			      json.put("msg",fileid > 0 ? "已存在该文件名!" : "已存在该文件夹名!"); 
			      b = false;  
			  }else{
			      json.put("flag","-3");
			     json.put("msg","数据异常!"); 
			      b = false;  
			  }
		   }else{
		       b = false;
		       json.put("flag","-3");
		       json.put("msg","数据异常!");
		   }
		}
	   if(b){
	    NetWorkDiskFileOperateServer ndfo= new NetWorkDiskFileOperateServer();
			Map<String ,Map<String,String>> result = ndfo.saveToNetwork(user,"",folderids,fileids,folderid);
			if(result!=null&&result.size()>0){
				json.put("flag","1");
				json.put("msg","保存成功!");
			}else{
				json.put("flag","0");
				json.put("msg","保存失败!");
			}
	   }
	}else if("createFolder".equals(method)){//新建目录
	    RecordSet rs = new RecordSet();  
	  String name =  Util.null2String(request.getParameter("name"));
	  if(folderid <= 0){
        String sql = "select id from DocPrivateSecCategory where categoryname = '"+user.getUID()+"_"+user.getLastname()+"' and parentid = 0";
          rs.executeSql(sql);
          if(rs.next()){
              folderid = rs.getInt("id");
          }
      }
	   String sql = "select id from DocPrivateSecCategory where categoryname = '" + name + "' and parentid = " + folderid;	
	   rs.execute(sql);
	   if(rs.next()){
	       json.put("flag",-1);
	   }else{
	       SeccategoryShowModel seccategoryShowModel = privateSeccategoryManager.createSeccategory(user,name,folderid);
	       Map<String,String> map = new HashMap<String,String>();
	       map.put("id",seccategoryShowModel.getSid());
	       map.put("name",seccategoryShowModel.getSname());
	       map.put("pid",seccategoryShowModel.getPid());
	       map.put("icon", "2.png");
           map.put("size", "");
           map.put("datetime", "");
   	       json.put("flag",1);
   	       json.put("folder",map);
	   }
	
	}else if("getPublicPid".equals(method)){ //获取上级id(公共目录)
	    RecordSet rs = new RecordSet();
	    rs.executeSql("select c.id,c.parentid pid,p.parentid ppid from docseccategory c left join docseccategory p where c.parentid=p.id and c.id=" + folderid);
		if(rs.next()){
		    json.put("pid",Util.getIntValue(rs.getString("ppid"),0) == 0 ? 0 : Util.getIntValue(rs.getString("pid")));
		}
	}else if("delete".equals(method)){
	    String folderids = Util.null2String(request.getParameter("folderids"));
	    String fileids = Util.null2String(request.getParameter("fileids"));
	    
	    boolean canDelete = true;
	    if(!folderids.isEmpty()){
	        RecordSet rs = new RecordSet();
	        rs.executeSql("select sum(num) num from ("
	                + "select count(1) num from imagefileref f where f.categoryid" 
	                + (folderids.contains(",") ? (" in(" + folderids + ")") : ("=" + folderids))
	            	+ " union select count(1) num from DocPrivateSecCategory s where s.parentid"  
	            	+ (folderids.contains(",") ? (" in(" + folderids + ")") : ("=" + folderids))
	            	+ ") t");
	        if(rs.next() && rs.getInt("num") > 0){
	            json.put("flag",-1);
	            canDelete = false;
	        }
	    }
	    if(canDelete){
		    NetWorkDiskFileOperateServer ndfo= new NetWorkDiskFileOperateServer();
		    ndfo.delete(folderids,fileids);
		    json.put("flag",1);
	    }
	}else if("move".equals(method)){
	    if(folderid == 0){
	       folderid = seccategoryManager.getUserPrivateCategoryId(user);
	    }
	    String folderids = Util.null2String(request.getParameter("folderids"));
	    String fileids = Util.null2String(request.getParameter("fileids"));
	    NetWorkDiskFileOperateServer ndfo= new NetWorkDiskFileOperateServer();
	    ndfo.move(folderids,fileids,folderid + "");
	    json.put("flag",1);
	}else if("upload".equals(method)){
	    
	}else if("share".equals(method)){
	    String userids = Util.null2String(request.getParameter("userids"));
	    String groupids = Util.null2String(request.getParameter("groupids"));
		String folderids = Util.null2String(request.getParameter("folderids"));
	    String fileids = Util.null2String(request.getParameter("fileids"));
	    String date = TimeUtil.getCurrentDateString();
	    String time = TimeUtil.getOnlyCurrentTimeString();
	    RecordSet rs = new RecordSet();
		if(!fileids.isEmpty()){
			if(!userids.isEmpty()){
			   for(String fileid : fileids.split(",")){
			       if(fileid.isEmpty()) continue;
			       String fileMes = Util.null2String(request.getParameter("file_" + fileid));
			       for(String userid : userids.split(",")){
					   if(userid.isEmpty()) continue;
			           rs.executeSql("insert into Networkfileshare(fileid,sharerid,tosharerid,sharedate,sharetime,sharetype,filetype,msgId) values(" +
			                   fileid + "," + user.getUID() + ",'" + userid + "','" + date + "','" + time + "',1,1,'" + fileMes + "')");
			       }
			   }
			}
			if(!groupids.isEmpty()){
			    for(String fileid : fileids.split(",")){
			       if(fileid.isEmpty()) continue;
			       String fileMes = Util.null2String(request.getParameter("file_" + fileid));
			       for(String groupid : groupids.split(",")){
					   if(groupid.isEmpty()) continue;
			           rs.executeSql("insert into Networkfileshare(fileid,sharerid,tosharerid,sharedate,sharetime,sharetype,filetype,msgId) values(" +
			                   fileid + "," + user.getUID() + ",'" + groupid + "','" + date + "','" + time + "',2,1,'" + fileMes + "')");
			       }
			   } 
			}
		}
		if(!folderids.isEmpty()){
			if(!userids.isEmpty()){
			    for(String fid : folderids.split(",")){
			       if(fid.isEmpty()) continue;
			       String folderMes = Util.null2String(request.getParameter("folder_" + fid));
			       for(String userid : userids.split(",")){
					   if(userid.isEmpty()) continue;
			           rs.executeSql("insert into Networkfileshare(fileid,sharerid,tosharerid,sharedate,sharetime,sharetype,filetype,msgId) values(" +
			                   fid + "," + user.getUID() + ",'" + userid + "','" + date + "','" + time + "',1,2,'" + folderMes + "')");
			       }
			   }
			}
			if(!groupids.isEmpty()){
			    for(String fid : folderids.split(",")){
			       if(fid.isEmpty()) continue;
			       String folderMes = Util.null2String(request.getParameter("folder_" + fid));
			       for(String groupid : groupids.split(",")){
					   if(groupid.isEmpty()) continue;
			           rs.executeSql("insert into Networkfileshare(fileid,sharerid,tosharerid,sharedate,sharetime,sharetype,filetype,msgId) values(" +
			                   fid + "," + user.getUID() + ",'" + groupid + "','" + date + "','" + time + "',2,2,'" + folderMes + "')");
			       }
			   }
			}
		}
		json.put("flag",1);
	}else if("uploadAsExist".equals(method)){
	    if(folderid == 0){
	       folderid = seccategoryManager.getUserPrivateCategoryId(user);
	    }
		String fileid = request.getParameter("fileids");
		UploadFileServer uploadFileServer = new UploadFileServer();
		uploadFileServer.addImageFileRefForOuter(user, fileid,folderid+"");
	    json.put("flag",1);
	}else if("rename".equals(method)){
	    String renameType = Util.null2String(request.getParameter("renameType"));
	    if("file".equals(renameType)){
		    String fileName_new = Util.null2String(request.getParameter("fileName")).trim();
			int imagefileid=Util.getIntValue(Util.null2String(request.getParameter("imagefileid")),0);
			int categoryid=Util.getIntValue(Util.null2String(request.getParameter("categoryid")),-1);
			String uid = Util.null2String(request.getParameter("uid")).trim();
			RecordSet rs = new RecordSet();
			if(imagefileid<=0||fileName_new.isEmpty()){
				json.put("result", "fail");//文件id错误或新文件名为空,结束
			}else{
				if(categoryid <= 0)
		        {
		          String sql = "select id from DocPrivateSecCategory where categoryname = '"+user.getUID()+"_"+user.getLastname()+"' and parentid = 0";
		            rs.executeSql(sql);
		            if(rs.next())
		            {
		                categoryid = rs.getInt("id");
		            }
		        }
				if(categoryid>0){
					rs.executeSql("select filename from imagefileref where imagefileid = " + imagefileid + " and categoryid="+categoryid);
					if(rs.next())
					{
						String fileName_old=Util.null2String(rs.getString("filename"));
						if(fileName_new.equals(fileName_old)){
						    json.put("result", "success");//新旧文件名相同,结束
						}else{
							String sql = "select id from imagefileref where filename = '"+fileName_new+"' and categoryid = " + categoryid + " and imagefileid <> " +imagefileid;
							rs.executeSql(sql);
							if(rs.next())
							{
							    json.put("result", "exist");
							}else{
							    
							    boolean flag = rs.executeSql("update imagefileref set filename='" + fileName_new + "' where imagefileid=" + imagefileid + " and categoryid=" + categoryid);
								if(flag){
								    flag = rs.executeSql("update imagefile set imagefilename='" + fileName_new + "' where imagefileid=" + imagefileid);
								}
							    if(flag){
							        json.put("result", "success");
								}else{
								    json.put("result", "fail");
								}
							}
						}
					}else{
					    json.put("result", "fail");//根据文件id找不到文件,结束
					}
				}else{
				    json.put("result", "fail");
				}
			}
	    }else if("folder".equals(renameType)){
			String categoryname = Util.null2String(request.getParameter("categoryname"));
			
			int categoryid=Util.getIntValue(Util.null2String(request.getParameter("categoryid")),-1);
	        if(categoryname.isEmpty()){
	            json.put("result", "fail");
			}else{
				RecordSet rs = new RecordSet();	
			    rs.executeSql("select categoryname,parentid from DocPrivateSecCategory where  id = " +categoryid);
				if(rs.next()){
					String categoryname_old = Util.null2String(rs.getString("categoryname"));
					int pid = Util.getIntValue(Util.null2String(rs.getString("parentid")),-1);
					if(categoryname_old.equals(categoryname)){
					    json.put("result", "success");//相同
					}else if(!categoryname_old.equals(categoryname)&&pid==-1){
					    json.put("result", "fail");
					}else {
						String sql = "select id from DocPrivateSecCategory where categoryname = '"+categoryname+"' and parentid = " + pid + " and id <> " +categoryid;
						rs.executeSql(sql);
						if(rs.next())
						{
						    json.put("result", "exist");
						}
						else
						{
							boolean flag  = privateSeccategoryManager.renameSeccategory(user,categoryid,categoryname,pid);
							if(flag){
							    json.put("result", "success");
							}else{
							    json.put("result", "fail");
							}
						}
					}
				}else{
				    json.put("result", "fail");
				}
			}
	    }
		//out.println(map);
	}else if("getShareObj".equals(method)){
		int fileid = Util.getIntValue(request.getParameter("fileid"),-1);
		String sharername = Util.null2String(request.getParameter("objname"));
		sharername = sharername.replaceAll("'","''");
		
		List<Map<String,String>> shareObjs = privateSeccategoryManager.getShareObjects(user,fileid,folderid,sharername);
		
		json.put("dataList",shareObjs);
	}else if("deleteShareObj".equals(method)){
	    String shareids = Util.null2String(request.getParameter("shareids"));
	    
	    
	    
	    NetworkFileLogServer networkFileLogServer = new NetworkFileLogServer();
	    boolean b = false;
	    if(!shareids.isEmpty()){
	        List<Map<String,String>> mesList = new ArrayList<Map<String,String>>();
		    b = networkFileLogServer.cancelShareObj(shareids,"","","","",user,mesList);
		    json.put("mesList",mesList);
	    }else{ //mobile端调用取消分享(mobile调用，不能直接通过request获取)
	        String fileids = Util.null2String(fu.getParameter("fileids"));
		 	String folderids = Util.null2String(fu.getParameter("folderids"));
	        String toSharerid = Util.null2String(fu.getParameter("toSharerid"));
	        String mgsId = Util.null2String(fu.getParameter("mgsId"));
	        List<Map<String,String>> mesList = new ArrayList<Map<String,String>>();
	        b = networkFileLogServer.cancelShareObj("",toSharerid,fileids,folderids,mgsId,user,mesList);
	    }
	    
	    if(b)
	        json.put("flag","1");
	    
	}else if("checkShare".equals(method)){ //mobile检测共享文件 是否删除 、是否已取消分享
	    String foldertype = Util.null2String(fu.getParameter("sharetype"));
	    String fid = Util.null2String(fu.getParameter("fid"));
	    String sharer = Util.null2String(fu.getParameter("sharer"));
	    String targetid = Util.null2String(fu.getParameter("targetid"));
	    
		NetworkFileLogServer networkFileLogServer = new NetworkFileLogServer();
	    
	    int flag = networkFileLogServer.checkShare(foldertype,sharer,targetid,fid,user);
	    if(flag == 1){
	        json.put("flag","1"); 
	    }else if(flag == 2){
	        json.put("flag","2"); 
	    }else if(flag == 3){
	        json.put("flag","3"); 
	    }
	}
	out.println(json);
%>
