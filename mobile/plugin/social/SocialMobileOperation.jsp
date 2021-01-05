
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.mobile.plugin.ecology.service.PluginServiceImpl"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.UUID"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@page import="java.util.Enumeration"%>
<%@page import="weaver.file.FileUpload"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="weaver.general.Util"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="weaver.rdeploy.task.TaskUtil"%>
<%@page import="weaver.general.TimeUtil"%>
<%@page import="weaver.favourite.FavouriteInfo" %>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<%@page import="weaver.social.rdeploy.im.IMService" %>
<%@page import="weaver.social.im.SocialIMClient"%>
<jsp:useBean id="SocialIMService" class="weaver.social.service.SocialIMService" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SocialIMFavourate" class="weaver.social.service.SocialIMFavourate" scope="page" /> 
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");
FileUpload fu=new FileUpload(request);
PluginServiceImpl ps = new PluginServiceImpl();
Map<String,Object> param=new HashMap<String, Object>();
User user = HrmUserVarify.getUser(request, response);
if (user == null) return;
String userid = user.getUID()+"";
//String userid = Util.null2String(fu.getParameter("userid"));//"462";//lx4
//获取所有请求参数
Enumeration enu=fu.getParameterNames();
while(enu.hasMoreElements()){
	String paraName=(String)enu.nextElement();
	String value=Util.null2String(fu.getParameter(paraName));
    
	if(!paraName.equals("request")&&!paraName.equals("response")&&!paraName.equals("sessionkey"))
		param.put(paraName, value);
	if(paraName.equals("content")){
		param.put("content",URLDecoder.decode(value,"utf-8"));
	}
}

String uid=Util.null2String((String)fu.getParameter("userid"));
String operation=Util.null2String((String)fu.getParameter("operation"));

Log logger= LogFactory.getLog(this.getClass());

Map result=new HashMap();
if(operation.equals("doShareIMFile")){ //分享附件
	
	String shareid = Util.null2String(fu.getParameter("shareid"));
	String targetid = Util.null2String(fu.getParameter("targetid"));
	String fileid = Util.null2String(fu.getParameter("fileid"));
	String resourceids = Util.null2String(fu.getParameter("resourceids"));
	String resourcetype = Util.null2s(fu.getParameter("resourcetype"), "1");
	boolean status=SocialIMService.addIMFileByFileid(shareid,fileid,targetid,resourceids,resourcetype);
	//boolean status_0 = ChatResourceShareManager.addShare(resourcetype, shareid, uid, targetType.equals("1")?targetid:"", resourceids);
	//boolean status_0=IMService.saveChatResource(uid,targetType.equals("1")?targetid:"",Integer.parseInt(shareid),0, resourceids);
	result.put("status",status?"1":"0");
	
}
else if(operation.equals("savefavourate")){				//收藏
	String favInfo = Util.null2String(fu.getParameter("favInfo"));
	uid = Util.null2String(fu.getParameter("userid"));
	//userid 验证
	if(userid.equals(uid)){
		JSONObject fav = null;
		try{
			favInfo = favInfo.replaceAll("\r","").replaceAll("\n","");
			fav = JSONObject.fromObject(favInfo);
			String favid = fav.optString("favid"); 
		}catch(Exception e){
			logger.error("!!savefavourate error!!"+e.toString());
		}
		String msg = SocialIMFavourate.saveFavourate(uid, fav); 
		//JSONObject result = new JSONObject();
		int sIndex = msg.indexOf("|");
		if(msg.startsWith("|")){
			result.put("issuccess",1);
			result.put("id", msg.substring(sIndex+1, msg.length()));
		}else{
			result.put("issuccess",0);
			result.put("errormsg", msg.substring(0, sIndex));
		}
	}else{
		result.put("issuccess",0);
		result.put("errormsg", "bad userid!");
	}
}
else if(operation.equals("getfavourate")){					//获取我的收藏
	uid = Util.null2String(fu.getParameter("userid"));
	if(userid.equals(uid)){
		String pageno = Util.null2String(fu.getParameter("page"));
		String pagesize = Util.null2String(fu.getParameter("pagesize"));
		//搜索标题
		String keyWord = Util.null2String(fu.getParameter("key_word"));
		//搜索类型 0表示全部，1表示消息类型，2表示图片类型
		String style = Util.null2String(fu.getParameter("style"));
		//重要级别 0表示全部 1 
		String importantLevel = Util.null2String(fu.getParameter("important_level"));
		//目录ID
		String location = Util.null2String(fu.getParameter("location"));
		Map<String, String> condis = new HashMap<String,String>();
		condis.put("pagename", keyWord);
		condis.put("style", style);
		condis.put("importlevel", importantLevel);
		condis.put("favouriteids", location);
		if("".equals(uid)){
			uid = userid;
		}
		//查询我的收藏
		List<Map<String, String>> favList = SocialIMFavourate.getFavourate(uid,pageno,pagesize,condis);
		//JSONObject result = new JSONObject();
		String totalPage;
		if(favList.size() <= 0){
			result.put("favlist", "");
			
		}else{
			Map<String, String> map = favList.get(0);
			if(map.containsKey("totalPage")){
				totalPage = map.get("totalPage");
				favList.remove(0);
			}
			JSONArray favjsary = JSONArray.fromObject(favList);
			favList.clear();
			favList = null;
			result.put("favlist", favjsary);
			//result.put("favinfos", JSONObject.fromObject(favinfos));
		}
	}else{
		result.put("errormsg", "bad userid!");
	}
}
else if(operation.equals("addtask")){		//创建任务
	String tasktitle = Util.null2String(fu.getParameter("tasktitle"));
	String taskid = TaskUtil.addTask(tasktitle, Integer.parseInt(userid));
	String shareids = Util.null2String(fu.getParameter("shareids"));
	int sPos = taskid.lastIndexOf("|");
	taskid = taskid.substring(sPos+1, taskid.length());
	TaskUtil.addShare(Integer.parseInt(taskid), shareids);
	Map taskInfo = TaskUtil.getTaskInfo(Integer.parseInt(taskid));
	result.put("taskid", taskid);
	result.put("creatorid", taskInfo.get("createrID"));
	result.put("createdate", taskInfo.get("createdate"));
	result.put("status", taskInfo.get("status"));
}else if(operation.equals("istaskcomplete")){		//任务是否完成
	String taskid = Util.null2String(fu.getParameter("taskid"));
	boolean isComplete = TaskUtil.ifComplete(Integer.parseInt(taskid));
	result.put("isComplete", isComplete);
}else if(operation.equals("istaskdeleted")){		//任务是否删除
	String taskid = Util.null2String(fu.getParameter("taskid"));
	boolean ifDelete = TaskUtil.ifDelete(Integer.parseInt(taskid));
	result.put("ifDelete", ifDelete);
}else if(operation.equals("completeTask")){			//完成任务
	String taskid = Util.null2String(fu.getParameter("taskid"));
	String msg = "";
	try{
		Map taskInfo = TaskUtil.getTaskInfo(Integer.parseInt(taskid));
		//操作权限过滤
		String creatorid = taskInfo.get("createrID").toString();
		String principalid = taskInfo.get("principalid").toString();
		if(userid.equals(creatorid) || userid.equals(principalid)){
			msg = TaskUtil.completeTask(Integer.parseInt(taskid), "2", Integer.parseInt(userid));
		}
	}catch(Exception e){
		e.printStackTrace();
	}
	result.put("isSuccess", msg.equals(""));
	result.put("error", msg);
}else if(operation.equals("gettaskinfo")){			//获取任务信息
	String taskid = Util.null2String(fu.getParameter("taskid"));
	Map info = TaskUtil.getTaskInfo(Integer.parseInt(taskid));
	if(info != null && info.size() > 0){
		result.put("creator", info.get("creater"));
		result.put("createdate", info.get("createdate"));
		result.put("creatorid", info.get("createrID"));
		result.put("principalid", info.get("principalid"));
		result.put("status", info.get("status"));
		result.put("deleted", info.get("deleted"));
	}
	
}else if(operation.equals("getMsgReaderIdList")){			//根据时间段和消息所有人的所有已阅读此消息的人员id集合
	String dateTime = Util.null2String(fu.getParameter("dateTime"));
	Map res = SocialIMService.getMsgReaderIdList(userid, dateTime);
	result.put("res", res);
}else if(operation.equals("sendBroadcast")){			//发送系统广播
	String msgId = UUID.randomUUID().toString().trim();
	String plainText = Util.null2String(fu.getParameter("plaintext"));
	String fromUserId = userid;
	String sendtime = System.currentTimeMillis()+"";
	String receiverIds = Util.null2String(fu.getParameter("receiverIds"));
	String imageids = Util.null2String(fu.getParameter("imageids"));	
	String accids = Util.null2String(fu.getParameter("accids"));	
	String wfids = Util.null2String(fu.getParameter("wfids"));	
	String docids = Util.null2String(fu.getParameter("docids"));	
	String accnames = Util.null2String(fu.getParameter("accnames"));	
	String accsizes = Util.null2String(fu.getParameter("accsizes"));	
	String wfnames = Util.null2String(fu.getParameter("wfnames"));	
	String docnames = Util.null2String(fu.getParameter("docnames"));
	JSONObject requestObjs = new JSONObject();
	//{'imageids':[...], 'accids': [], 'wfids': [], 'docids': []}
	requestObjs.put("imageids", imageids);
	requestObjs.put("accids", accids);
	requestObjs.put("accnames", accnames);
	requestObjs.put("accsizes", accsizes);
	requestObjs.put("wfids", wfids);
	requestObjs.put("wfnames", wfnames);
	requestObjs.put("docids", docids);
	requestObjs.put("docnames", docnames);
	if((","+receiverIds+",").indexOf(","+fromUserId+",") == -1){
		receiverIds += ","+fromUserId;
	}
	SocialIMClient.sendBroadCast(msgId, plainText, fromUserId, requestObjs, sendtime, receiverIds);
	result.put("issuccess", true);
}else if(operation.equals("getBroadcast")){			//获取系统广播
	String pagesize = Util.null2String(fu.getParameter("pagesize"));
	String pageindex = Util.null2String(fu.getParameter("pageindex"));
	String content = Util.null2String(fu.getParameter("content"));
	String timestart = Util.null2String(fu.getParameter("timestart"));
	String timeend = Util.null2String(fu.getParameter("timeend"));
	String senderid = Util.null2String(fu.getParameter("senderid"));
	//pagesize, pageindex, timestart, timeend, senderid, content
	HashMap<String, String> params = new HashMap<String, String>();
	params.put("pagesize", pagesize);
	params.put("pageindex", pageindex);
	params.put("content", content);
	params.put("timestart", timestart);
	params.put("timeend", timeend);
	params.put("senderid", senderid);
	JSONArray resList = SocialIMService.getBroadcastList(Util.getIntValue(userid), params);
	result.put("res", resList);
	result.put("hasnext", resList.size() == Util.getIntValue(pagesize));
}
if(result!=null){
	JSONObject jsonResult = JSONObject.fromObject(result);
	out.print(jsonResult);
}
%>