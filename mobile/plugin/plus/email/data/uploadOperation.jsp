<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.file.FileUpload"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="java.lang.reflect.Constructor"%>
<%
	//微信邮件附件上传处理
	request.setCharacterEncoding("UTF-8");
	int status = 1;
	//FileUpload fu = new FileUpload(request,"utf-8",false,"1");
	FileUpload fu = null;
	try{			
		Class FileUpload = Class.forName("weaver.file.FileUpload");
		Constructor constructor = FileUpload.getConstructor(HttpServletRequest.class,String.class,Boolean.class,String.class);
		fu = (FileUpload)constructor.newInstance(request,"utf-8",false,"1");
	}
	catch (Exception e){
		fu = new FileUpload(request,"utf-8",false);
	}
	
	String operation = Util.null2String(fu.getParameter("operation"));
	Map result = new HashMap();
	
	try{
		if(operation.equals("upload")){
			
			User user = HrmUserVarify.getUser (request , response) ;
			if(user!=null) {
				JSONArray ja = new JSONArray();
				
				String uploadfields = Util.null2String(fu.getParameter("uploadfields"));
				
				//System.out.println("uploadfields:"+uploadfields);
				List fieldlist = Util.TokenizerString(uploadfields, ",");
				for(int m=0;m<fieldlist.size();m++){
					String fieldid = Util.null2String((String)fieldlist.get(m));
					String olddocids = Util.null2String(fu.getParameter(fieldid));//原始值
					String docids = "";
					String delids = Util.null2String(fu.getParameter("del"+fieldid));//删除值
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
						/* if(!"".equals(delids)){
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
						} */
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
							String docid = fu.uploadFilesToEmail("file"+fieldid+"_"+i);
							
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
			}
		}
			
	}catch(Exception e){
		
	}
	
	result.put("status", status);
	JSONObject jro = null;
	if(result!=null){
		jro = new JSONObject(result);
	}
	out.println(jro);
%>
