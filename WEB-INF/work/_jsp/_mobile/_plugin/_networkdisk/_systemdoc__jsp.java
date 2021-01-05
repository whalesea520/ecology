/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._mobile._plugin._networkdisk;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.hrm.User;
import weaver.hrm.HrmUserVarify;
import weaver.general.Util;
import java.util.Map;
import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;
import net.sf.json.JSONArray;
import org.json.JSONObject;
import weaver.rdeploy.doc.MultiAclManagerNew;
import weaver.rdeploy.doc.DocShowModel;
import weaver.docs.docs.reply.PraiseInfo;
import weaver.docs.networkdisk.server.GetSecCategoryById;
import weaver.conn.RecordSet;
import weaver.docs.pdf.docpreview.ConvertPDFUtil;

public class _systemdoc__jsp extends com.caucho.jsp.JavaPage
{
  private static final java.util.HashMap<String,java.lang.reflect.Method> _jsp_functionMap = new java.util.HashMap<String,java.lang.reflect.Method>();
  private boolean _caucho_isDead;
  
  public void
  _jspService(javax.servlet.http.HttpServletRequest request,
              javax.servlet.http.HttpServletResponse response)
    throws java.io.IOException, javax.servlet.ServletException
  {
    javax.servlet.http.HttpSession session = request.getSession(true);
    com.caucho.server.webapp.WebApp _jsp_application = _caucho_getApplication();
    javax.servlet.ServletContext application = _jsp_application;
    com.caucho.jsp.PageContextImpl pageContext = _jsp_application.getJspApplicationContext().allocatePageContext(this, _jsp_application, request, response, null, session, 8192, true, false);
    javax.servlet.jsp.PageContext _jsp_parentContext = pageContext;
    javax.servlet.jsp.JspWriter out = pageContext.getOut();
    final javax.el.ELContext _jsp_env = pageContext.getELContext();
    javax.servlet.ServletConfig config = getServletConfig();
    javax.servlet.Servlet page = this;
    response.setContentType("text/html");
    response.setCharacterEncoding("UTF-8");
    request.setCharacterEncoding("UTF-8");
    try {
      out.write(_jsp_string0, 0, _jsp_string0.length);
      weaver.mobile.plugin.ecology.service.PluginServiceImpl ps;
      ps = (weaver.mobile.plugin.ecology.service.PluginServiceImpl) pageContext.getAttribute("ps");
      if (ps == null) {
        ps = new weaver.mobile.plugin.ecology.service.PluginServiceImpl();
        pageContext.setAttribute("ps", ps);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.mobile.plugin.ecology.service.DocumentService documentService;
      documentService = (weaver.mobile.plugin.ecology.service.DocumentService) pageContext.getAttribute("documentService");
      if (documentService == null) {
        documentService = new weaver.mobile.plugin.ecology.service.DocumentService();
        pageContext.setAttribute("documentService", documentService);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.docs.docs.DocManager docManager;
      docManager = (weaver.docs.docs.DocManager) pageContext.getAttribute("docManager");
      if (docManager == null) {
        docManager = new weaver.docs.docs.DocManager();
        pageContext.setAttribute("docManager", docManager);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.splitepage.operate.SpopForDoc spopForDoc;
      spopForDoc = (weaver.splitepage.operate.SpopForDoc) pageContext.getAttribute("spopForDoc");
      if (spopForDoc == null) {
        spopForDoc = new weaver.splitepage.operate.SpopForDoc();
        pageContext.setAttribute("spopForDoc", spopForDoc);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.hrm.resource.ResourceComInfo resourceComInfo;
      resourceComInfo = (weaver.hrm.resource.ResourceComInfo) pageContext.getAttribute("resourceComInfo");
      if (resourceComInfo == null) {
        resourceComInfo = new weaver.hrm.resource.ResourceComInfo();
        pageContext.setAttribute("resourceComInfo", resourceComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.docs.docs.reply.DocReplyManager docReply;
      docReply = (weaver.docs.docs.reply.DocReplyManager) pageContext.getAttribute("docReply");
      if (docReply == null) {
        docReply = new weaver.docs.docs.reply.DocReplyManager();
        pageContext.setAttribute("docReply", docReply);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.docs.webservices.reply.DocReplyServiceForMobile docReplyServiceForMobile;
      docReplyServiceForMobile = (weaver.docs.webservices.reply.DocReplyServiceForMobile) pageContext.getAttribute("docReplyServiceForMobile");
      if (docReplyServiceForMobile == null) {
        docReplyServiceForMobile = new weaver.docs.webservices.reply.DocReplyServiceForMobile();
        pageContext.setAttribute("docReplyServiceForMobile", docReplyServiceForMobile);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.docs.webservices.DocServiceForMobile docServiceForMobile;
      docServiceForMobile = (weaver.docs.webservices.DocServiceForMobile) pageContext.getAttribute("docServiceForMobile");
      if (docServiceForMobile == null) {
        docServiceForMobile = new weaver.docs.webservices.DocServiceForMobile();
        pageContext.setAttribute("docServiceForMobile", docServiceForMobile);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.docs.docs.DocImageManager docImageManager;
      docImageManager = (weaver.docs.docs.DocImageManager) pageContext.getAttribute("docImageManager");
      if (docImageManager == null) {
        docImageManager = new weaver.docs.docs.DocImageManager();
        pageContext.setAttribute("docImageManager", docImageManager);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.docs.DocDetailLog docDetailLog;
      docDetailLog = (weaver.docs.DocDetailLog) pageContext.getAttribute("docDetailLog");
      if (docDetailLog == null) {
        docDetailLog = new weaver.docs.DocDetailLog();
        pageContext.setAttribute("docDetailLog", docDetailLog);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      
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
	if("getDocList".equals(method)){ //\u83b7\u53d6\u6587\u6863\u5217\u8868
	    String bySearch = Util.null2String(request.getParameter("bySearch")); //\u662f\u5426\u662f\u641c\u7d22\uff081-\u662f\uff0c0\u6216\u5176\u4ed6-\u5426\uff09
	    String docTab = Util.null2String(request.getParameter("docTab")); //\u641c\u7d22\u7c7b\u578b\uff08all-\u6240\u6709\u6587\u6863\uff0cmy-\u6211\u7684\u6587\u6863\uff0ccollect-\u6211\u7684\u6536\u85cf\uff09
	    int pageSize = Util.getIntValue(request.getParameter("pageSize"),10); //\u6bcf\u9875\u6570\u636e\u6761\u6570
	    int pageNum = Util.getIntValue(request.getParameter("pageNum"),1); //\u9875\u6570
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
	}else if("getCategoryList".equals(method)){ //\u83b7\u53d6\u76ee\u5f55\u5217\u8868\u96c6\u5408
	    String bySearch = Util.null2String(request.getParameter("bySearch")); //\u662f\u5426\u662f\u641c\u7d22\uff081-\u662f\uff0c0\u6216\u5176\u4ed6-\u5426\uff09
	    int categoryid = Util.getIntValue(request.getParameter("categoryid"),0);
	    Map<String, String> requestMap = new HashMap<String, String>();
	    requestMap.put("categoryid", categoryid + "");
        requestMap.put("urlType", "0");
	    List<Map<String,String>> categoryList = new ArrayList<Map<String,String>>();
	    if(!"1".equals(bySearch)){
	        categoryList = GetSecCategoryById.getCategoryById(user, requestMap);
	    }
	    
	    json.put("categorys",JSONArray.fromObject(categoryList).toString());
	}else if("getCategoryDocList".equals(method)){//\u83b7\u53d6\u76ee\u5f55\u4e0b\u6587\u6863\u5217\u8868\u96c6\u5408
	    String bySearch = Util.null2String(request.getParameter("bySearch")); //\u662f\u5426\u662f\u641c\u7d22\uff081-\u662f\uff0c0\u6216\u5176\u4ed6-\u5426\uff09
	    int categoryid = Util.getIntValue(request.getParameter("categoryid"),0);
	    int pageSize = Util.getIntValue(request.getParameter("pageSize"),10); //\u6bcf\u9875\u6570\u636e\u6761\u6570
	    int pageNum = Util.getIntValue(request.getParameter("pageNum"),1); //\u9875\u6570
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
	}else if("getDocDetail".equals(method)){ //\u83b7\u53d6\u6587\u6863\u8be6\u60c5
	    int docid = Util.getIntValue(request.getParameter("docid"),0);
		if(docid == 0){
		    json.put("flag","-1");
		}else{
			RecordSet rs = new RecordSet();
			rs.executeSql("select DocSubject from Docdetail where id="+docid);
			if(!rs.next()){
			    json.put("flag","-1");
			}else{
		
				//0:\u67e5\u770b  
				boolean canReader = false;
				//1:\u7f16\u8f91
				boolean canEdit = false;
				//2:\u5220\u9664
				boolean canDel = false;
				//3:\u5171\u4eab
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
				//\u5b50\u76ee\u5f55\u4fe1\u606f
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
				//\u662f\u5426\u53ef\u4ee5\u67e5\u770b\u5386\u53f2\u7248\u672c
				//\u5177\u6709\u7f16\u8f91\u6743\u9650\u7684\u7528\u6237\uff0c\u59cb\u7ec8\u53ef\u89c1\u6587\u6863\u7684\u5386\u53f2\u7248\u672c\uff1b
				//\u53ef\u4ee5\u8bbe\u7f6e\u5177\u6709\u53ea\u8bfb\u6743\u9650\u7684\u64cd\u4f5c\u4eba\u662f\u5426\u53ef\u89c1\u5386\u53f2\u7248\u672c\uff1b
		
				if(ishistory==1) {
					if(readerCanViewHistoryEdition.equals("1")){
				    	if(canReader && !canEdit) canReader = true;
					} else {
					    if(canReader && !canEdit) canReader = false;
					}
				}
		
				//\u7f16\u8f91\u6743\u9650\u64cd\u4f5c\u8005\u53ef\u67e5\u770b\u6587\u6863\u72b6\u6001\u4e3a\uff1a\u201c\u5ba1\u6279\u201d\u3001\u201c\u5f52\u6863\u201d\u3001\u201c\u5f85\u53d1\u5e03\u201d\u6216\u5386\u53f2\u6587\u6863
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
					docInfo.put("canDelete",canDel);  //\u662f\u5426\u53ef\u5220\u9664
					docInfo.put("canShare",canShare); //\u662f\u5426\u53ef\u5206\u4eab
					docInfo.put("docTitle",docManager.getDocsubject()); // \u6587\u6863\u6807\u9898
					docInfo.put("doccontent",doccontent);  //\u6587\u6863\u5185\u5bb9
					docInfo.put("owner",resourceComInfo.getLastname(docManager.getOwnerid()+""));  //\u6240\u6709\u8005 
					docInfo.put("ownerid",docManager.getOwnerid() + ""); //\u6240\u6709\u8005id
					docInfo.put("updateUser",resourceComInfo.getLastname(docManager.getDoclastmoduserid() + "")); //\u6700\u540e\u66f4\u65b0\u4eba
					docInfo.put("updateTime",docManager.getDoclastmoddate() + " " + docManager.getDoclastmodtime());  //\u6700\u540e\u66f4\u65b0\u65f6\u95f4
					docInfo.put("readCount","0");  //\u9605\u8bfb\u6570\u91cf
					rs.executeSql("select count(1) num from DocDetailLog where docid="+docid+" and operatetype = 0");
					if(rs.next()){
					    docInfo.put("readCount",rs.getString("num")); 
					}
					docInfo.put("canReply",false);  //\u662f\u5426\u5141\u8bb8\u56de\u590d
					rs.executeSql("select replyable from DocSecCategory where id=" + seccategory);
					if(rs.next()){
					    docInfo.put("canReply","1".equals(rs.getString("replyable"))); 
					}
					
					rs.executeSql("select count(1) num from DOC_REPLY where docid='" + docid + "'");
					docInfo.put("replyCount","0"); //\u56de\u590d\u6570
					if(rs.next()){
					    docInfo.put("replyCount",rs.getString("num"));     
					}
					
					PraiseInfo praiseInfo = docReply.getPraiseInfoByDocid(docid + "",user.getUID());
					docInfo.put("praiseCount","0"); //\u70b9\u8d5e\u6570\u91cf
					docInfo.put("isPraise","0"); //\u662f\u5426\u70b9\u8d5e\u8fc7
					if(praiseInfo.getUsers() != null){
					    docInfo.put("praiseCount",praiseInfo.getUsers().size() + "");
					    docInfo.put("isPraise",praiseInfo.getIsPraise() == 1 ? "1" : "0");
					}
					docInfo.put("isCollute","0"); //\u662f\u5426\u6536\u85cf\u8fc7
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
		             docInfo.put("icon",icon);//\u6240\u6709\u8005\u5934\u50cf
		             docInfo.put("errorIcon",errorIcon); // \u6240\u6709\u8005\u5934\u50cf\u52a0\u8f7d\u9519\u8bef\u65f6\u52a0\u8f7d\u7684\u56fe\u7247
		             //rs.executeSql("select f.imagefileid,f.imagefilename,f.filesize,df.docid from DocImageFile df,ImageFile f where df.imagefileid=f.imagefileid and df.docid=" + docid);
					 
					    int docImageId = 0;
						//DocImageManager docImageManager = new DocImageManager();
						docImageManager.resetParameter();
						docImageManager.setDocid(docid);
						docImageManager.selectDocImageInfo();					 
					 List<Map<String,String>> docAttrs = new ArrayList<Map<String,String>>(); 	
					 docInfo.put("docAttrs",docAttrs); //\u9644\u4ef6\u5217\u8868
					 
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
						boolean readOnLine = false;  //\u662f\u5426\u652f\u6301\u5728\u7ebf\u67e5\u770b
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
					    boolean readOnLine = false;  //\u662f\u5426\u652f\u6301\u5728\u7ebf\u67e5\u770b
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
	}else if("replyDoc".equals(method)){//\u56de\u590d
	    Map<String, Object> result = docReplyServiceForMobile.saveReply(request,user);
	    json.put("result",result);
	}else if("praiseDoc".equals(method)){ //\u70b9\u8d5e\u3001\u53d6\u6d88\u70b9\u8d5e
	    int docid = Util.getIntValue(request.getParameter("docid"),0);
	    int replyid = Util.getIntValue(request.getParameter("replyid"),0);
	    String isPraise = Util.null2String(request.getParameter("isPraise"));
	    int replyType = 1;
	    if(replyid == 0){
	        replyType = 0;
	        replyid = docid;
	    }
	    Map<String,Object> result = null;
	    if(isPraise.equals("1")){ //\u53d6\u6d88\u70b9\u8d5e
	        result = docReplyServiceForMobile.unPraise(replyid,replyType,user,docid + "");
	    }else{ //\u70b9\u8d5e
	        result = docReplyServiceForMobile.praise(replyid,replyType,user,docid + "");
	    }
	    json.put("result",result);
	    json.put("userid",user.getUID());
	    
	}else if("coluteDoc".equals(method)){//\u6536\u85cf\u3001\u53d6\u6d88\u6536\u85cf
	    int docid = Util.getIntValue(request.getParameter("docid"),0);
	    String isCollute = Util.null2String(request.getParameter("isCollute"));
	    Map<String,Object> result = null;
	    if("1".equals(isCollute)){//\u53d6\u6d88\u6536\u85cf
	        result = docServiceForMobile.undoCollect(docid + "",user);
	    }else{ //\u6536\u85cf
	        result = docServiceForMobile.doCollect(docid + "",user); 
	    }
	    json.put("result",result);
	}else if("getReply".equals(method)){//\u56de\u590d\u5217\u8868
	    int docid = Util.getIntValue(request.getParameter("docid"),0);
		int lastId = Util.getIntValue(request.getParameter("lastId"),0);
		int pageSize = Util.getIntValue(request.getParameter("pageSize"),10);
		int childrenSize = Util.getIntValue(request.getParameter("childrenSize"),5);
		int mainId = Util.getIntValue(request.getParameter("mainId"),0);
		String result = "[]";
		if(mainId > 0){ //\u83b7\u53d6\u66f4\u591a\u5b50\u56de\u590d
		    result = docReplyServiceForMobile.getResidueReplysForReply(lastId + "",mainId + "",docid + "",user,childrenSize) ;
		    json.put("isChild","1");
		    json.put("mainId",mainId);
		}else{
		    result = docReplyServiceForMobile.getDocReply(docid + "",user,lastId,pageSize,childrenSize);
		    json.put("isChild","0");
		}
		json.put("replyList",result);
	}else if("deleteDoc".equals(method)){//\u5220\u9664\u6587\u6863
	    int docid = Util.getIntValue(request.getParameter("docid"),0);	
	    Map<String,Object> result = docServiceForMobile.deleteDoc(docid + "",user);
	    json.put("result",result);
	}
	out.println(json);

    } catch (java.lang.Throwable _jsp_e) {
      pageContext.handlePageException(_jsp_e);
    } finally {
      _jsp_application.getJspApplicationContext().freePageContext(pageContext);
    }
  }

  private java.util.ArrayList _caucho_depends = new java.util.ArrayList();

  public java.util.ArrayList _caucho_getDependList()
  {
    return _caucho_depends;
  }

  public void _caucho_addDepend(com.caucho.vfs.PersistentDependency depend)
  {
    super._caucho_addDepend(depend);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  public boolean _caucho_isModified()
  {
    if (_caucho_isDead)
      return true;
    if (com.caucho.server.util.CauchoSystem.getVersionId() != 1886798272571451039L)
      return true;
    for (int i = _caucho_depends.size() - 1; i >= 0; i--) {
      com.caucho.vfs.Dependency depend;
      depend = (com.caucho.vfs.Dependency) _caucho_depends.get(i);
      if (depend.isModified())
        return true;
    }
    return false;
  }

  public long _caucho_lastModified()
  {
    return 0;
  }

  public java.util.HashMap<String,java.lang.reflect.Method> _caucho_getFunctionMap()
  {
    return _jsp_functionMap;
  }

  public void init(ServletConfig config)
    throws ServletException
  {
    com.caucho.server.webapp.WebApp webApp
      = (com.caucho.server.webapp.WebApp) config.getServletContext();
    super.init(config);
    com.caucho.jsp.TaglibManager manager = webApp.getJspApplicationContext().getTaglibManager();
    com.caucho.jsp.PageContextImpl pageContext = new com.caucho.jsp.PageContextImpl(webApp, this);
  }

  public void destroy()
  {
      _caucho_isDead = true;
      super.destroy();
  }

  public void init(com.caucho.vfs.Path appDir)
    throws javax.servlet.ServletException
  {
    com.caucho.vfs.Path resinHome = com.caucho.server.util.CauchoSystem.getResinHome();
    com.caucho.vfs.MergePath mergePath = new com.caucho.vfs.MergePath();
    mergePath.addMergePath(appDir);
    mergePath.addMergePath(resinHome);
    com.caucho.loader.DynamicClassLoader loader;
    loader = (com.caucho.loader.DynamicClassLoader) getClass().getClassLoader();
    String resourcePath = loader.getResourcePathSpecificFirst();
    mergePath.addClassPath(resourcePath);
    com.caucho.vfs.Depend depend;
    depend = new com.caucho.vfs.Depend(appDir.lookup("mobile/plugin/networkdisk/systemDoc.jsp"), -156661019614785554L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  private final static char []_jsp_string2;
  static {
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
    _jsp_string2 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
  }
}
