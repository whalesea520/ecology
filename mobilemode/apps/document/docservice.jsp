<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.docs.docs.DocImageManager"%>
<%@ page import="weaver.docs.webservices.DocServiceImpl"%>
<%@ page import="weaver.docs.webservices.DocInfo"%>
<%@ page import="weaver.file.FileUpload" %>
<jsp:useBean id="DocServiceForMobile" class="weaver.docs.webservices.DocServiceForMobile" scope="page" />
<jsp:useBean id="docManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%!
/**
 * @param extendName - 文件扩展名
 * @return 根据扩展名返回相应文件类型的图标路径 
 * 
 * 根据扩展名返回相应文件类型的图标路径
 * 
 */
public static String getIconPathByExtendName(String extendName) {
    String returnValue="universal_icon_wev8.png";
    RecordSet rs = new RecordSet();
    
    rs.executeSql("select iconPath from workflow_filetypeicon where extendName='"+extendName.toLowerCase()+"'"); 
    if (rs.next())
    	returnValue=rs.getString(1);           
    
    return returnValue;
}
%>
<%

FileUpload fu = new FileUpload(request); 
String opt = fu.getParameter("opt");
int userid = Util.getIntValue(fu.getParameter("userid"));
UserManager userManager = new UserManager();
User user = userManager.getUserByUserIdAndLoginType(userid, "1");

if("getDocJSON".equalsIgnoreCase(opt)){
	String documentid = Util.null2String(fu.getParameter("documentid"));
	Map result = DocServiceForMobile.getDoc(documentid,user);
	result.put("docid",documentid);
	String accStr="";
	try{
		List attachmentlist = (ArrayList)result.get("attachmentlist");
		if(attachmentlist!=null&&attachmentlist.size()>0){
			for(int i=0;i<attachmentlist.size();i++){
				Map attachment = (Map)attachmentlist.get(i);
				long imagefilesize = Long.valueOf(Util.null2String(attachment.get("imagefilesize")));
				String filesize = "";
				if(imagefilesize / (1024 * 1024) > 0) {
					filesize = (imagefilesize / 1024 / 1024) + "M";
	            } else if(imagefilesize / 1024 > 0) {
	            	filesize = (imagefilesize / 1024) + "K";
	            } else {
	            	filesize = imagefilesize + "B";
	            }
	            String imagefileid = Util.null2String(attachment.get("imagefileid"));
				String docImagefilename = Util.null2String(attachment.get("imagefilename"));
				String fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".") + 1);
				String iconpath = getIconPathByExtendName(fileExtendName);
				if(i==0){
					accStr +="<a href='javascript:void(0)'  onclick=\"downloads('"+imagefileid+"','','"+docImagefilename+"');return false;\" class='relatedLink'>"+docImagefilename+"("+filesize+")</a>";
				}else{
					accStr +="<br><a href='javascript:void(0)'  onclick=\"downloads('"+imagefileid+"','','"+docImagefilename+"');return false;\" class='relatedLink'>"+docImagefilename+"("+filesize+")</a>";
				}
			}
		}
	}catch(Exception e){
		result.put("attacherror", e.toString());
	}
	docManager.resetParameter();
	docManager.setId(Util.getIntValue(documentid));
	docManager.getDocInfoById();
	String doccontent=docManager.getDoccontent();
	String docpublishtype=docManager.getDocpublishtype();
	if(docpublishtype.equals("2")){
		int tmppos = doccontent.indexOf("!@#$%^&*");
		if(tmppos!=-1) doccontent = doccontent.substring(tmppos+8,doccontent.length());
	}

	doccontent = Util.replace(doccontent, "&amp;", "&", 0);
	result.put("doccontent",doccontent);
	result.put("docimagefile", accStr);
	JSONObject jsonObject = JSONObject.fromObject(result);
	out.println(jsonObject);
}else if("getReplyJSON".equalsIgnoreCase(opt)){
	
	Map<String, Object> detail = new HashMap<String, Object>();
	List datas = new ArrayList();
	int currentpage = Util.getIntValue(fu.getParameter("currentpage"),0);
	int pagesize = Util.getIntValue(fu.getParameter("pagesize"),0);
	String docid = Util.null2String(fu.getParameter("documentid"));
	JSONArray jo = DocServiceForMobile.getDocReply(docid,user);
	JSONArray joall = new JSONArray();
	for(int i=jo.length()-1;i>=0;i--){
		org.json.JSONObject jsontemp = jo.getJSONObject(i);
		if(!jsontemp.isNull("children")){
			JSONArray jatmep = (JSONArray)jsontemp.get("children");
			for(int j=jatmep.length()-1;j>=0;j--){
				joall.put(jatmep.get(j));
			} 
		}
	}
	
	int iTotal =joall.length(); 
	//System.out.println("iTotal:"+iTotal+" currentpage:"+currentpage);
	int startnum = (currentpage-1)*pagesize;
	int endnum = currentpage * pagesize;
	if(iTotal < endnum) endnum = iTotal;
	
	//System.out.println("joall.size():"+joall.length()+" startnum:"+startnum+" endnum:"+endnum);
	for(int i=startnum;i<endnum;i++){
		Map map = new HashMap();
		org.json.JSONObject jsontemp = joall.getJSONObject(i);
		String documentid = Util.null2String(jsontemp.get("documentid"));
		String doccontent = "";
		map.put("documentid", documentid);
		map.put("docsubject", Util.null2String(jsontemp.get("docsubject")));
		map.put("ownername", Util.null2String(jsontemp.get("ownername")));
		map.put("ownerid", Util.null2String(jsontemp.get("ownerid")));
		map.put("ownerurl", Util.null2String(jsontemp.get("ownerurl")));
		map.put("doccreatedate", Util.null2String(jsontemp.get("doccreatedate")));
		map.put("doccreatetime", Util.null2String(jsontemp.get("doccreatetime")));
		rs.execute("select doccontent from DocDetail where id="+documentid);
		if(rs.next()){
			doccontent= Util.null2String(rs.getString("doccontent"));
		}	
		map.put("doccontent", doccontent);
		datas.add(map);
	}
	//System.out.println("datas:"+datas);
	detail.put("datas", datas);
	detail.put("totalSize", iTotal);
	if(iTotal == 0){
		out.print("{\"totalSize\":0, \"datas\":[]}");
		return;
	}
	JSONObject json = JSONObject.fromObject(detail);
	out.print(json.toString());
}else if("replaydoc".equalsIgnoreCase(opt)){
	JSONObject json = new JSONObject();
	Map<String, Object> result = new HashMap<String, Object>();
	int docId=-1;
	try{
		if(user==null){
			json.put("status", "0");
			json.put("errMsg", "未登录或登录超时");
			out.print(json.toString());
			return ;
		}
		if(request==null){
			json.put("status", "0");
			json.put("errMsg", "提交请求数据为空");
			out.print(json.toString());
			return ;
		}			
		
		
		
		String doccontent = Util.null2String(fu.getParameter("content"));
		String replydocid = Util.null2String(fu.getParameter("extendField"));
		String docsubject = "";
		String seccategory = "";
		String maincategory = "";
		String subcategory = "";
		int replaydoccount=0;
		String parentids="";
		if(!replydocid.equals("")){
			rs.execute("select seccategory,maincategory,subcategory,parentids,replaydoccount,docsubject from DocDetail  where id= "+replydocid);
			if(rs.next()){
				docsubject ="Re:"+ Util.null2String(rs.getString("docsubject"));
				maincategory = Util.null2String(rs.getString("maincategory"));
				subcategory = Util.null2String(rs.getString("subcategory"));
				seccategory=Util.null2String(rs.getString("seccategory"));
				parentids=Util.null2String(rs.getString("parentids"));
				replaydoccount=Util.getIntValue(rs.getString("replaydoccount"),0);					
			}					
		}
		if(seccategory.trim().equals("")){
			json.put("status", "0");
			json.put("errMsg", "文档标题为空或者文档子目录为空");
			out.print(json.toString());
			return ;
		}				
		DocServiceImpl docServiceImpl=new DocServiceImpl();
		DocInfo doc=new DocInfo();
		doc.setDocSubject(docsubject);
		doc.setDoccontent(doccontent);
		doc.setMaincategory(Util.getIntValue(maincategory,-1));
		doc.setSubcategory(Util.getIntValue(subcategory,-1));
		doc.setSeccategory(Util.getIntValue(seccategory,-1));
		doc.setReplydocid(Util.getIntValue(replydocid,-1));
		if(!replydocid.equals("")){
			doc.setIsreply("1");
			doc.setParentids(parentids);
		}else{
			doc.setIsreply("0");			
		}
		docId=docServiceImpl.createDocByUser(doc, user);
		
        if(!replydocid.equals("")&&docId>0){
        	replaydoccount++;
        	rs.executeSql("update DocDetail set replaydoccount="+replaydoccount+" where id= "+replydocid);
        }
	}catch(Exception ex){
		ex.printStackTrace();
	}
	
	if(docId>0){
		json.put("status", "1");					
	}else{
		json.put("status", "0");
		json.put("errMsg", "回复异常");				
	}
	out.print(json.toString());
}
%>