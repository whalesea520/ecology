<%@page import="com.weaver.formmodel.mobile.utils.MobileUpload"%>
<%@page import="weaver.file.FileUpload"%>
<%@page import="weaver.conn.ConnStatement"%>
<%@page import="weaver.formmode.dao.BaseDao"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util"%>
<%@page import="com.weaver.formmodel.util.DateHelper"%>
<%@page import="weaver.hrm.User"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.weaver.formmodel.base.model.PageModel"%>
<%@page import="com.weaver.formmodel.data.dao.FormdataDao"%>
<%
out.clear();

User user = MobileUserInit.getUser(request,response);

String action = Util.null2String(request.getParameter("action"));

if(action.equalsIgnoreCase("getCommentData")){

	String billid = Util.null2String(request.getParameter("billid"));
	
	int pageno = Util.getIntValue(request.getParameter("pageno"), 1);
	int pageSize = Util.getIntValue(request.getParameter("pageSize"), 10);
	
	String sql = "select a.* from uf_ktree_discussion a, uf_ktree_document b where a.versionid=b.versionId and a.functionid=b.functionId and a.tabid=b.tabId and b.id = " + billid;
	
	FormdataDao formdataDao = new FormdataDao();
	
	PageModel pageModel = formdataDao.pageQuery(sql, null, pageno, pageSize);
	
	int totalPageCount = pageModel.getTotalPageCount();
	
	int totalSize = pageModel.getTotalSize();
	
	List<Map<String, Object>> dataList = (List<Map<String,Object>>)pageModel.getResult();
	
	JSONArray jsonArray = new JSONArray();
	
	ResourceComInfo resourceComInfo = new ResourceComInfo();
	
	for(int i = 0; i < dataList.size(); i++){
		JSONObject jsonObject = new JSONObject();
		
		Map<String, Object> dataMap = dataList.get(i);
		String creator = Util.null2String(dataMap.get("creator"));
		String creatorAvtor = resourceComInfo.getMessagerUrls(creator);
		String creatorName = Util.toScreen(resourceComInfo.getResourcename(creator),user.getLanguage());
		String time = Util.null2String(dataMap.get("createdate")) + " " + Util.null2String(dataMap.get("createtime"));
		String content = Util.null2String(dataMap.get("content"));
		
		jsonObject.put("creator", creator);
		jsonObject.put("creatorAvtor", creatorAvtor);
		jsonObject.put("creatorName", creatorName);
		jsonObject.put("time", time);
		jsonObject.put("content", content);
		
		jsonArray.add(jsonObject);
	}
	
	JSONObject resultObj = new JSONObject();
	resultObj.put("totalPageCount", totalPageCount);
	resultObj.put("totalSize", totalSize);
	resultObj.put("datas", jsonArray.toString());
	
	out.print(resultObj.toString());
}else if(action.equalsIgnoreCase("saveComment")){
	JSONObject resultObj = new JSONObject();
	ConnStatement statement = new ConnStatement();
	try{
		FileUpload fileUpload = new FileUpload(request,"UTF-8",false);
		String billid = Util.null2String(fileUpload.getParameter("billid"));
		String sql = "select a.versionid,a.functionid,a.tabid from uf_ktree_document a where a.id = " + billid;
		//System.out.println(sql);
		BaseDao baseDao = new BaseDao();
		Map<String, Object> dataMap = baseDao.getResultByMap(sql);
		String versionid = Util.null2String(dataMap.get("versionid"));
		String functionid = Util.null2String(dataMap.get("functionid"));  	
		String tabid = Util.null2String(dataMap.get("tabid"));
		String commentContent = Util.null2String(fileUpload.getParameter("commentContent"));
		int replayid = Util.getIntValue(fileUpload.getParameter("replayid"),0);//被回复的留言id
		String relatefiles =Util.fromScreen(fileUpload.getParameter("relatedacc"),user.getLanguage());  //相关附件
		String createdate = DateHelper.getCurrentDate();
		String createtime = DateHelper.getCurrentTime().substring(0,5);
		
		//处理手机端选择的图片
		String imgContent = "";
		MobileUpload mobileUpload = new MobileUpload(request); 
		int imageCount = Util.getIntValue(fileUpload.getParameter("imageCountCommentImg"), 0);
		for(int i = 1; i <= imageCount; i++){
			String uploaddata = Util.null2String(fileUpload.getParameter("uploaddata_CommentImg_"+i)).trim();
			if(!uploaddata.equals("")){
				String uploadname = Util.null2String(fileUpload.getParameter("uploadname_CommentImg_"+i));
				String imagePath = mobileUpload.upload(uploadname, uploaddata, "/mobilemode/upload/mpc/photo");
				if(!imagePath.equals("")){
					imgContent += "<img src=\""+imagePath+"\"/>";
				}
			}
		}
		commentContent += imgContent;
		
		//处理手机端的语音操作
		String soundContent = Util.null2String(fileUpload.getParameter("soundContent"));
		if(!soundContent.trim().equals("")){
			String soundPath = mobileUpload.upload("record.mp3", soundContent, "/mobilemode/upload/mpc/sound");
			String soundHtml = "<audio controls>"
								  +"<source src=\""+soundPath+"\" type=\"audio/mpeg\">"
								  +"<embed height=\"35\" width=\"100\" src=\""+soundPath+"\">"
							  +"</audio>";
			commentContent += soundHtml;
		}
		
		//处理手机端的LBS操作
		String lbsHtml = Util.null2String(fileUpload.getParameter("lbsHtml"));
		commentContent += lbsHtml;
		
		Map<String, Object> dataMap2 = baseDao.getResultByMap("select max(floorNum)+1 as floornum from uf_ktree_discussion where versionid="+versionid+" and functionid="+functionid+" and tabid="+tabid);
		int floornum = Util.getIntValue(Util.null2String(dataMap2.get("floornum")),1);
		
		String sql2 = "insert into uf_ktree_discussion(versionid,functionid,tabId,content,files,floornum,replayid,creator,createdate,createtime,isnewread) values(?,?,?,?,?,?,?,?,?,?,?)";
		statement.setStatementSql(sql2);
		statement.setString(1, versionid);
		statement.setString(2, functionid);
		statement.setString(3, tabid);
		statement.setString(4, commentContent);
		statement.setString(5, relatefiles);
		statement.setString(6, String.valueOf(floornum));
		statement.setString(7, String.valueOf(replayid));
		statement.setString(8, String.valueOf(user.getUID()));
		statement.setString(9, createdate);
		statement.setString(10, createtime);
		statement.setString(11, replayid==0?"1":"0");
		statement.executeUpdate();
		
		resultObj.put("status", "1");
	}catch(Exception e){
		e.printStackTrace();
		resultObj.put("status", "0");
	}finally{
		statement.close();
	}
	out.print("<script type=\"text/javascript\">parent.commentServerSaved("+resultObj.toString()+");</script>");
}

out.flush();
out.close();
%>	