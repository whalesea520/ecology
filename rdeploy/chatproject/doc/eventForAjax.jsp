<%@ page language="java" pageEncoding="utf-8"%>

<%@ page import="org.json.JSONObject"%>
<%@ page import="weaver.general.Util,weaver.general.TimeUtil" %>
<%@ page import="weaver.hrm.User,weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.conn.RecordSetTrans" %>
<%@ page import="weaver.docs.category.DocTreeDocFieldComInfo" %>
<%@ page import="weaver.rdeploy.doc.MultiAclManagerNew,weaver.rdeploy.doc.DocShowModel" %>
<%@ page import="java.util.Map,java.util.HashMap,java.util.List,java.util.ArrayList" %>
<%@ page import="weaver.docs.networkdisk.server.NetWorkDiskFileOperateServer"%>
<%@ page import="weaver.docs.networkdisk.server.PublishNetWorkFile"%>
<%@ page import="weaver.docs.networkdisk.tools.ImageFileUtil"%>
<%@ page import="weaver.docs.networkdisk.bean.DocAttachment" %>
<%@ page import="weaver.docs.networkdisk.server.NetworkFileLogServer" %>
<%@ page import="weaver.rdeploy.doc.PrivateSeccategoryManager" %>
<%@ page import="weaver.rdeploy.doc.SeccategoryShowModel" %>


<%
	User user = HrmUserVarify.getUser(request,response);

	String type = request.getParameter("type");

    int categoryid = Util.getIntValue(request.getParameter("categoryid"),0);
	String uid = Util.null2String(request.getParameter("uid"));
    String folderids = Util.null2String(request.getParameter("folderid"));
    String fileids = Util.null2String(request.getParameter("fileid"));
    
   
	JSONObject obj = new JSONObject();
	NetWorkDiskFileOperateServer netWorkDiskFileOperateServer = new NetWorkDiskFileOperateServer();
	PrivateSeccategoryManager seccategoryManager = new PrivateSeccategoryManager();
	
	if("deleteUploadIng".equals(type)){
		RecordSet rs = new RecordSet();
		String uploadfile_uid = Util.null2String(request.getParameter("uploadfile_uid"));
	    String sql = "delete imagefilereftemp where uploadfileguid = '" + uploadfile_uid + "'";
		rs.execute(sql);
		obj.put("flag","1");
	}
	else if("move".equals(type)){
	    Map<String,String> rmap = netWorkDiskFileOperateServer.move(folderids,fileids,categoryid + "");
	    obj.put("flag",rmap.get("flag"));
	    obj.put("folders",rmap.get("folders"));
	    obj.put("files",rmap.get("files"));
	}else if("delete".equals(type)){
	    netWorkDiskFileOperateServer.delete(folderids,fileids);
	    obj.put("flag","1");
	}else if("paste".equals(type)){
		RecordSet rs = new RecordSet();
		boolean validate=true;
		if(categoryid==0)
		{
			categoryid = seccategoryManager.getUserPrivateCategoryId(user);
		}
		
		List<Map<String,String>> existList = new ArrayList<Map<String,String>>();
		
		if(!folderids.isEmpty()){
		    String sql = "select t2.id,t2.categoryname from DocPrivateSecCategory t1,DocPrivateSecCategory t2 " +
		    	"where t1.parentid=" + categoryid + " and t2.id in(" + folderids + ") and t1.categoryname=t2.categoryname";
		    rs.executeSql(sql);
		    while(rs.next()){
		        Map<String,String> existMap = new HashMap<String,String>();
		        existMap.put("id",rs.getString("id"));
		        existMap.put("type","folder");
		        existMap.put("name",rs.getString("categoryname"));
		        existList.add(existMap);
		    }
		}
		
		if(!fileids.isEmpty()){
		    String sql = "select t2.imagefileid,t2.filename from imagefileref t1,imagefileref t2 " +
	    		"where t1.categoryid=" + categoryid + " and t2.imagefileid in(" + fileids + ") and t1.filename=t2.filename";
	    	rs.executeSql(sql);
		    while(rs.next()){
		        Map<String,String> existMap = new HashMap<String,String>();
		        existMap.put("id",rs.getString("imagefileid"));
		        existMap.put("type","file");
		        existMap.put("name",rs.getString("filename"));
		        existList.add(existMap);
		    }
		}
		
		if(existList.size() > 0){
		    for( Map<String,String> existMap : existList){
		        if("folder".equals(existMap.get("type"))){
		            String nid = "";
		            for(String id : folderids.split(",")){
		                if(id.equals(existMap.get("id"))) continue;
		                nid += "," + id;
		            }
		            nid = nid.contains(",") ? nid.substring(1) : nid;
		            folderids = nid;
		        }else if("file".equals(existMap.get("type"))){
		            String nid = "";
		            for(String id : fileids.split(",")){
		                if(id.equals(existMap.get("id"))) continue;
		                nid += "," + id;
		            }
		            nid = nid.contains(",") ? nid.substring(1) : nid;
		            fileids = nid;
		        }
		    }
		    obj.put("existList",existList);
		}
		
		
		if(!folderids.isEmpty()){
			String startIdSql = folderids.contains(",") ? ("id in(" + folderids + ")") : ("id=" + folderids);
			boolean isoracle = (rs.getDBType()).equals("oracle");
			String exceptsql="";
			if(isoracle){
				exceptsql="select id from DocPrivateSecCategory start with "+startIdSql +" connect by prior id = parentid";
				exceptsql="select id from DocPrivateSecCategory where id in ("+exceptsql+") and id="+categoryid;
			}else{
				exceptsql="WITH CategoryInfo AS(SELECT id,parentid FROM DocPrivateSecCategory WHERE "+startIdSql+
				" UNION ALL SELECT a.id,a.parentid FROM DocPrivateSecCategory AS a,CategoryInfo AS b WHERE a.parentid = b.id) SELECT id FROM CategoryInfo where id="+categoryid;
			}
			rs.execute(exceptsql);
			if(rs.next()){
				validate = false;
			}
		}
		if(validate){
			String shareids = Util.null2String(request.getParameter("shareid"));
			NetWorkDiskFileOperateServer ndfo= new NetWorkDiskFileOperateServer();
			Map<String ,Map<String,String>> result = ndfo.saveToNetwork(user,shareids,folderids,fileids,categoryid);
			if(result!=null&&result.size()>0){
				obj.put("flag","1");
				obj.put("result",result);
			}	
		}else{
			obj.put("flag","2");
		}
	    
	}else if("public".equals(type)){
	    
		if(categoryid > 0){
		    PublishNetWorkFile publishNetWorkFile = new PublishNetWorkFile();
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
		   	//file2Doc(ids,categoryid,user);
		   	List<DocAttachment> attInfos = publishNetWorkFile.publishNetWorkFile(ids,categoryid,user,0);
		   	
		   	List<Map<String,String>> dataList = new ArrayList<Map<String,String>>();
			if(attInfos!=null){
				for(DocAttachment attInfo : attInfos){
					Map<String,String> data = new HashMap<String,String>();
					data.put("status",attInfo.getReturnStatus());
					data.put("imagefileid",attInfo.getImageFileId());
					data.put("oldfileid",attInfo.getOtherParams().get("imagefileid").toString());
					data.put("docid",attInfo.getDocid());
					dataList.add(data);
				}
		   	}
		    obj.put("flag","1");
		    obj.put("needShare",publishNetWorkFile.isOpenShare(categoryid));
		    obj.put("dataList",dataList);
		}	    
	}else if("share".equals(type)){
	   String docids = Util.null2String(request.getParameter("docids"));
	   if(!docids.isEmpty()){
	       RecordSet rs = new RecordSet();
	       boolean b = rs.executeSql("update DocDetail set docstatus=(case docstatus when -1 then 1 when -3 then 3 when -6 then 6 else docstatus end) where id" + 
	               (docids.contains(",") ? (" in ("+ docids + ")") : ("=" + docids)));
	       if(b){
	           obj.put("flag","1");
	       }
	   }
	    
	}else if("parents".equals(type)){
	   List<Map<String,String>> dataList = netWorkDiskFileOperateServer.getAllParents(categoryid,user);
	   obj.put("flag","1");
	   obj.put("dataList",dataList);
	    
	}else if("clearAllfileLog".equals(type)){
		NetworkFileLogServer nfs= new NetworkFileLogServer();
		String optype = Util.null2String(request.getParameter("optype"));
		int isSystemDoc = Util.getIntValue(request.getParameter("isSystemDoc"),0);
		boolean result = nfs.clearAllFileLogBytype(user,optype,uid,isSystemDoc);
		if(result){
			obj.put("flag","1");
		}
	}else if("clearSinglefileLog".equals(type)){
		int id = Util.getIntValue(request.getParameter("id"),0);
		NetworkFileLogServer nfs= new NetworkFileLogServer();
		boolean result = nfs.clearFileLogById(user,uid,id);
		if(result){
			obj.put("flag","1");
		}
	}else if("doview".equals(type)){
		NetworkFileLogServer nfs= new NetworkFileLogServer();
		boolean result = false;
		if(!fileids.isEmpty()){
			 result = nfs.doViewById(user,fileids);
		}else if(categoryid>0){
			 result = nfs.doViewByCategory(user,categoryid);
		}
		if(result){
			obj.put("flag","1");
		}
	}else if("cancelShare".equals(type)){
		//String shareids = Util.null2String(request.getParameter("shareid"));
		if(!fileids.isEmpty() || !folderids.isEmpty()){ 
			NetworkFileLogServer nfs= new NetworkFileLogServer();
			List<Map<String,String>> mesList = new ArrayList<Map<String,String>>();
			boolean result = nfs.cancelShare(user,fileids,folderids,mesList);
			obj.put("mesList",mesList);
			if(result){
				obj.put("flag","1");
				obj.put("msg","取消成功!");
			}else{
			    obj.put("flag","0");
				obj.put("msg","取消失败!");
			}
		}
	}else if("save2Disk".equals(type)){
		//String shareids = Util.null2String(request.getParameter("shareid"));
		
		if(categoryid == 0){
		    seccategoryManager.getUserPrivateCategoryId(user);
		}
		
		String from = request.getParameter("from");
		boolean b = true;
		if("pc".equals(from)){ //来自于 message 的保存
		   int fileid = Util.getIntValue(fileids,0);
		   int folderid = Util.getIntValue(folderids,0);
		   if(fileid > 0 || folderid > 0){
			   NetworkFileLogServer networkFileLogServer = new NetworkFileLogServer();
			  int flag = networkFileLogServer.checkShareMy(fileid,folderid,categoryid,user);
			  if(flag == 1){
			  }else if(flag == 2){
			     obj.put("flag","-1");
				 obj.put("msg",fileid > 0 ? "文件已删除!" : "目录已删除!"); 
			     b = false; 
			  }else if(flag == 3){
			     obj.put("flag","-2");
				 obj.put("msg","共享已取消!"); 
			      b = false; 
			  }else if(flag == 4){
			      obj.put("flag","-4");
			      obj.put("msg",fileid > 0 ? "已存在该文件名!" : "已存在该文件夹名!"); 
			      b = false;  
			  }else{
			     obj.put("flag","-3");
				 obj.put("msg","数据异常!"); 
			      b = false;  
			  }
		   }else{
		       b = false;
		       obj.put("flag","-3");
			   obj.put("msg","数据异常!");
		   }
		}
		
		if(b){
			NetWorkDiskFileOperateServer ndfo= new NetWorkDiskFileOperateServer();
			Map<String ,Map<String,String>> result = ndfo.saveToNetwork(user,"",folderids,fileids,categoryid);
			if(result!=null&&result.size()>0&&(!result.get("folder").isEmpty() || !result.get("fileid").isEmpty())){
				obj.put("flag","1");
				obj.put("msg","保存成功!");
				obj.put("result",result);
			}else{
			    obj.put("flag","0");
				obj.put("msg","保存失败!");
			}
		}
	}else if("doDownloadBatch".equals(type)&&!fileids.isEmpty()){
		RecordSet rs = new RecordSet();
		rs.executeSql("select a.id,a.docsubject,b.imagefileid,b.imagefilename from DocDetail a,DocImageFile b where a.id=b.docid and a.id in ("+fileids+") and b.versionId = (select MAX(c.versionId) from DocImageFile c where c.id=b.id ) order by a.id asc");
		int counts=rs.getCounts();
		if(counts<=0){
			obj.put("flag","0");
		}else{
			obj.put("flag","1");
		}
	}else if("publicParents".equals(type)){
	    RecordSet rs = new RecordSet();
	    boolean isoracle = (rs.getDBType()).equals("oracle") ;
        String sql = "";
        
        if(isoracle){
            sql = "select * from DocSecCategory  start with id=" + categoryid + " connect by nocycle prior parentid=id";
        }else{
            sql = "with alldata as " +
                    "(select * from DocSecCategory where id=" + categoryid + " union all select d.* " +
                    "from alldata a,DocSecCategory d where d.id=a.parentid)  " +
                    "select id,parentid,categoryname from alldata ";
        }
        rs.executeSql(sql);
        List<Map<String, String>> dataList = new ArrayList<Map<String,String>>();
        MultiAclManagerNew multiAclManagerNew = new MultiAclManagerNew();
        while(rs.next()){
            Map<String, String> map = new HashMap<String,String>();
            dataList.add(map);
            map.put("sid",rs.getString("id"));
            map.put("pid",rs.getString("parentid"));
            map.put("sname",rs.getString("categoryname"));
	        Map<String,SeccategoryShowModel> canCreaterDoc = multiAclManagerNew.packageCategorys(user,rs.getString("parentid"),0,0);
            if(canCreaterDoc.get(map.get("sid")) != null){
                map.put("canCreateDoc","true");
            }
        }
        obj.put("flag","1");
 	    obj.put("dataList",dataList);
	}else if ("docSubcribe".equals(type)&&!fileids.isEmpty()){
		String searchCase = Util.null2String(request.getParameter("searchCase"));
		String subscribeDesc = Util.fromScreen(request.getParameter("subscribeDesc"),7);
		NetWorkDiskFileOperateServer ndfo= new NetWorkDiskFileOperateServer();
		boolean result=ndfo.docSubcribe(user,fileids,searchCase,subscribeDesc);
		if(result){
			obj.put("flag","1");
		}
	}else if("importDummy".equals(type)){
	    String docids = "";
	    if(categoryid > 0){ 
	        MultiAclManagerNew multiAclManager = new MultiAclManagerNew();
	    	Map<String,String> params = new HashMap<String,String>();
	    	params.put("seccategory",categoryid + "");
	    	params.put("searchtype","adv");
	    	List<DocShowModel> docList = multiAclManager.getDocList(user,params,0,0,0);
	    	for(DocShowModel doc : docList){
	    	    docids += doc.getDocid() + ",";
	    	}
	    }else if(!fileids.isEmpty()){ 
	        docids = fileids; 
	    }
	    String dummyIds = Util.null2String(request.getParameter("dummyIds"));
	    if(!docids.isEmpty() && !dummyIds.isEmpty()){
	        String importdate=TimeUtil.getCurrentDateString();
	    	String importtime=TimeUtil.getOnlyCurrentTimeString();
	        RecordSetTrans rst = new RecordSetTrans();
	        DocTreeDocFieldComInfo dfc = new DocTreeDocFieldComInfo();
	        rst.setAutoCommit(false);
	        for(String dummyId : dummyIds.split(",")){
	            if(dummyId.isEmpty()) continue;
		        for(String docid : docids.split(",")){
		            if(docid.isEmpty() || dfc.isHaveSameOne(dummyId,docid)) continue;
			    	rst.execute("insert into DocDummyDetail(catelogid,docid,importdate,importtime) values ("+dummyId+","+docid+",'"+importdate+"','"+importtime+"')");
		        }
	        }
	        obj.put("flag","1");
	        	rst.commit();
	        try{
	            rst.rollbackOnly();
	        }catch(Exception e){
		        obj.put("flag","0");
	            rst.writeLog(e);
	        }
	    }
	}else if("cancelShareObj".equals(type)){
	    String shareids = Util.null2String(request.getParameter("shareids"));
	    String toSharerid = Util.null2String(request.getParameter("tosharerid"));
	    String msgId = Util.null2String(request.getParameter("msgid"));
	    NetworkFileLogServer networkFileLogServer = new NetworkFileLogServer();
	    List<Map<String,String>> mesList = new ArrayList<Map<String,String>>();
	    boolean b = networkFileLogServer.cancelShareObj(shareids,toSharerid,fileids,folderids,msgId,user,mesList);
	    obj.put("mesList",mesList);
	    if(b){
	        obj.put("flag","1");
	        obj.put("msg","取消成功!");
	    }else{
	        obj.put("flag","0");
	        obj.put("msg","取消失败!");
	    }
	}else if("checkShare".equals(type)){
	    String foldertype = Util.null2String(request.getParameter("sharetype"));
	    String fid = Util.null2String(request.getParameter("fid"));
	    String sharer = Util.null2String(request.getParameter("sharer"));
	    String targetid = Util.null2String(request.getParameter("targetid"));
	    
	    NetworkFileLogServer networkFileLogServer = new NetworkFileLogServer();
	    
	    int flag = networkFileLogServer.checkShare(foldertype,sharer,targetid,fid,user);
	    if(flag == 1){
	        obj.put("flag","1"); 
	    }else if(flag == 2){
	        obj.put("flag","2"); 
	    }else if(flag == 3){
	        obj.put("flag","3"); 
	    }
	}else if("cateExist".equals(type)){
	    int fileid = Util.getIntValue(request.getParameter("fileid"),0);
	    int isSystemDoc = Util.getIntValue(request.getParameter("isSystemDoc"),0);
	    if(fileid > 0){
	       RecordSet rs = new RecordSet();
	       if(isSystemDoc == 1){
	           rs.executeSql("select d.seccategory from DocDetail d,DocImageFile f where d.id=f.docid and f.imagefileid=" + fileid);
	           if(rs.next()){
	               obj.put("categoryid",rs.getString("seccategory"));
		           obj.put("flag","1");
	           }else{
	               obj.put("flag","2"); 
	           }
	       }else{
		       rs.executeSql("select categoryid from imagefileref i,DocPrivateSecCategory d where i.categoryid=d.id and i.imagefileid=" + fileid);
		       if(rs.next()){
		           obj.put("categoryid",rs.getString("categoryid"));
		           obj.put("flag","1");
		       }else{
		           obj.put("flag","2"); 
		       }
	       }
	    }else{
	        obj.put("flag","2");
	    }
	}else if("getUploadSize".equals(type)){
	    String id = Util.null2String(request.getParameter("id"));
	    String _uid = Util.null2String(request.getParameter("uid"));
	    RecordSet rs = new RecordSet();
	    rs.executeSql("select uploadSize from ImageFileReftemp where filepathmd5='" + _uid + "' and uploadfileguid='" + id + "'");
	    int size = 0;
	    if(rs.next()){
	        size = rs.getInt("uploadSize");
	    }
        obj.put("size",size);
	}else if("checkShareByMsgId".equals(type)){
	    String msgid = Util.null2String(request.getParameter("msgid"));
	    
	    RecordSet rs = new RecordSet();
	    rs.executeSql("select id from  Networkfileshare where msgId='" + msgid + "'");
	    obj.put("msgid",msgid);
	    if(rs.next()){
	        obj.put("flag","1");
	    }else{
	        obj.put("flag","0");
	    }
	}else if("getDocIdByFileid".equals(type)){
	    int imagefileid = Util.getIntValue(request.getParameter("imagefileid"),0);
	    if(imagefileid > 0){
	        RecordSet rs = new RecordSet();
	        rs.executeSql("select docid from DocImageFile where imagefileid=" + imagefileid);
	        if(rs.next()){
	            obj.put("flag","1");
	            obj.put("docid",rs.getString("docid"));
	        }
	    }
	}
	
	
	
	out.println(obj.toString());
	
%>

