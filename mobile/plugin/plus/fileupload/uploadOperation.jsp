<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.file.FileUpload"%>
<%@ page import="weaver.wxinterface.InterfaceUtil"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="weaver.docs.docs.*"%>
<jsp:useBean id="deu" class="weaver.docs.docs.DocExtUtil" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<%
	//微信流程附件上传处理
	request.setCharacterEncoding("UTF-8");
	int status = 1;String msg = "";
	FileUpload fu = new FileUpload(request);
	String operation = Util.null2String(fu.getParameter("operation"));
	//System.out.println("operation:"+operation);
	Map result = new HashMap();
	
	try{
		if(operation.equals("upload")){
			
			User user = HrmUserVarify.checkUser (request , response) ;
			if(user!=null) {
				String docCategory = "";
				String workflowid = Util.null2String(fu.getParameter("workflowid"));
				rs.executeSql("select docCategory from workflow_base where id="+workflowid);
				if(rs.next()){
					docCategory = Util.null2String(rs.getString("docCategory"));
				}
				if(!"".equals(docCategory)){
					//int secid = Util.getIntValue(docCategory.substring(docCategory.lastIndexOf(",")+1),-1);
					int mainId = Util.getIntValue(docCategory.substring(0,docCategory.indexOf(',')),0);
					int subId = Util.getIntValue(docCategory.substring(docCategory.indexOf(',')+1,docCategory.lastIndexOf(',')),0);
					int secId = Util.getIntValue(docCategory.substring(docCategory.lastIndexOf(',')+1,docCategory.length()),0);
					
					JSONArray ja = new JSONArray();
					
					String uploadfields = Util.null2String(fu.getParameter("uploadfields"));
					
					//System.out.println("uploadfields:"+uploadfields);
					List fieldlist = Util.TokenizerString(uploadfields, ",");
					for(int m=0;m<fieldlist.size();m++){
						String fieldid = Util.null2String((String)fieldlist.get(m));
						String olddocids = Util.null2String(fu.getParameter(fieldid));//原始值
						String docids = "";
						String delids = Util.null2String(fu.getParameter("filedel"+fieldid));//删除值
						if(!olddocids.equals("")){//删除处理
							List docidlist = Util.TokenizerString(olddocids, ",");
							String oldid = "";
							for(int n=0;n<docidlist.size();n++){
								oldid = Util.null2String((String)docidlist.get(n));
								if((","+delids+",").indexOf(","+oldid+",")<0){
									docids += "," + oldid;
								}
							}
							
							//删除附件文档
							if(!"".equals(delids)){
								List delidlist = Util.TokenizerString(delids, ",");
								String delid = "";
								for(int n=0;n<delidlist.size();n++){
									delid = Util.null2String((String)delidlist.get(n));
									if(!"".equals(delid)){
										DocManager dm = new DocManager();
										dm.setId(Util.getIntValue(delid,0));
										dm.setUserid(user.getUID());
										dm.DeleteDocInfo();
									}
								}
							}
						}
						
						int filenum = Util.getIntValue(fu.getParameter("file"+fieldid+"_index"),0);
						//System.out.println("filenum:"+filenum);
						for(int i=0;i<filenum;i++){
							//String fileid = Util.null2String(fu.uploadFiles("file"+fieldid+"_"+i));
							String filename = Util.null2String(fu.getParameter2("filename"+fieldid+"_"+i));
							filename = Util.null2String(new String(filename.getBytes("ISO-8859-1"), "utf-8"));
							//System.out.println("filename:"+filename);
							if(!filename.equals("") && filename.indexOf(",")>-1) filename = filename.substring(0,filename.indexOf(","));
							if(!filename.equals("")){
								String docid = deu.uploadDocToImg(fu,user, "file"+fieldid+"_"+i,mainId,subId,secId,filename,"") + "";
								//new BaseBean().writeLog("TEST:"+"file"+fieldid+"_"+i+"-----------"+mainId+"---"+subId+"---"+secId+"---"+docid);
								if(!"".equals(docid)){
									
									if("-1".equals(docid)) status=0;
									else docids += "," + docid;
								}
							}
						}
						if(!"".equals(docids)) docids = docids.substring(1);
						
						JSONObject jo = new JSONObject();
						jo.put("fieldid",fieldid);
						jo.put("docids",docids);
						ja.put(jo);
					}
					result.put("docvaluelist", ja);
				}else{
					msg = "流程没有设置文件存放路径";
				}
			}else{
				msg = "获取用户信息失败";
			}
			
		}else if(operation.equals("fileupload")){
			User user = HrmUserVarify.checkUser (request , response) ;
			if(user!=null) {
				String fileids = "";
				int filecount = Util.getIntValue(fu.getParameter("filecount"));
				for(int i=0;i<filecount;i++){
					try{
						String fileid = Util.null2String(fu.uploadFiles("file"+i));
						if(!"".equals(fileid)) fileids += "," + fileid;
	 				}catch(Exception e){
						
					}
				}
				if(!"".equals(fileids)) fileids = fileids.substring(1); 
				result.put("fileids", fileids);
				//System.out.println("fileids:"+fileids);
			}else{
				msg = "获取用户信息失败";
			}
		}else if(operation.equals("fileuploadForFace")){
			String ticket = Util.null2String(fu.getParameter("ticket"));
			if(InterfaceUtil.wxCheckLogin(ticket)){
				String fileids = "";
				int filecount = Util.getIntValue(fu.getParameter("filecount"));
				for(int i=0;i<filecount;i++){
					try{
						String fileid = Util.null2String(fu.uploadFiles("file"+i));
						if(!"".equals(fileid)) fileids += "," + fileid;
	 				}catch(Exception e){
						
					}
				}
				if(!"".equals(fileids)) fileids = fileids.substring(1); 
				result.put("fileids", fileids);
			}
		}else if(operation.equals("docfileupload")){
			User user = HrmUserVarify.checkUser (request , response) ;
			if(user!=null) {
				String docCategory = "";
				String workflowid = Util.null2String(fu.getParameter("workflowid"));
				rs.executeSql("select docCategory from workflow_base where id="+workflowid);
				if(rs.next()){
					docCategory = Util.null2String(rs.getString("docCategory"));
				}
				
				String docids = "";
				if(!"".equals(docCategory)){
					//int secid = Util.getIntValue(docCategory.substring(docCategory.lastIndexOf(",")+1),-1);
					int mainId = Util.getIntValue(docCategory.substring(0,docCategory.indexOf(',')),0);
					int subId = Util.getIntValue(docCategory.substring(docCategory.indexOf(',')+1,docCategory.lastIndexOf(',')),0);
					int secId = Util.getIntValue(docCategory.substring(docCategory.lastIndexOf(',')+1,docCategory.length()),0);
					
					
					int filecount = Util.getIntValue(fu.getParameter("filecount"));
					for(int i=0;i<filecount;i++){
						try{
							String filetype = Util.null2String(fu.getParameter("filetype"+i));
							String filename = "F"+System.currentTimeMillis()+(!"".equals(filetype)?("."+filetype):"");
							String docid = deu.uploadDocToImg(fu,user, "file"+i,mainId,subId,secId,filename,"") + "";
							if(!"".equals(docid)) docids += "," + docid;
		 				}catch(Exception e){
							
						}
					}
				}
				
				if(!"".equals(docids)) docids = docids.substring(1); 
				result.put("docids", docids);
			}else{
				msg = "获取用户信息失败";
			}
		}else if(operation.equals("meetingfileupload")){
			User user = HrmUserVarify.checkUser (request , response) ;
			if(user!=null) {
				String meetingtype = Util.null2String(fu.getParameter("meetingtype"));
				if(!meetingtype.equals("")){
					int mainId = 0;
					int subId = 0;
					int secId = 0;
					rs.executeProc("Meeting_Type_SelectByID",meetingtype);
					if(rs.next()){
						String category = Util.null2String(rs.getString("catalogpath"));
					    if(!category.equals("")){
					    	String[] categoryArr = Util.TokenizerString2(category,",");
					    	mainId = Util.getIntValue(categoryArr[0]);
					    	subId = Util.getIntValue(categoryArr[1]);
					    	secId = Util.getIntValue(categoryArr[2]);
					    }else{//如果设置了目录，则取值
					    	rs2.executeSql("select * from MeetingSet order by id");
					    	if(rs2.next()){
					    		String mtngAttchCtgry = Util.null2String(rs2.getString("mtngAttchCtgry"));
					    		if(!"".equals(mtngAttchCtgry)){
					    			String[] categoryArr = Util.TokenizerString2(mtngAttchCtgry,",");
									mainId = Util.getIntValue(categoryArr[0]);
									subId = Util.getIntValue(categoryArr[1]);
									secId = Util.getIntValue(categoryArr[2]);
					    		}
					    	}
						}
				    }
				    String fileName = Util.null2String(fu.getParameter("fileName"));
					String docid = deu.uploadDocToImg(fu,user,"accessorys",mainId,subId,secId,fileName,"")+"";
					result.put("docid", docid);
					status = 0;
				}
			}else{
				msg = "获取用户信息失败";
			}
		}
	}catch(Exception e){
		e.printStackTrace();
	}
	result.put("status", status);
	result.put("msg", msg);
	JSONObject jro = null;
	if(result!=null){
		jro = new JSONObject(result);
	}
	out.println(jro);
%>
