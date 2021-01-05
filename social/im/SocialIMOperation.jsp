<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.*" %>
<%@page import="java.net.URLDecoder"%>
<%@page import="weaver.social.SocialUtil"%>
<%@page import="weaver.social.po.*"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.hrm.resource.ResourceUtil"%>
<%@page import="weaver.mobile.rong.*"%>
<%@page import="weaver.social.im.SocialIMClient"%>
<%@page import="weaver.social.im.SocialImLogin"%>
<%@page import="weaver.social.im.OpenfireMessage"%>
<%@page import="weaver.social.service.SocialOpenfireUtil"%>
<%@page import="weaver.mobile.plugin.ecology.service.HrmResourceService"%>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.conn.ConnStatement"%>
<%@page import="weaver.general.BaseBean"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SocialIMService" class="weaver.social.service.SocialIMService" scope="page" />
<%
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	String userid =""+user.getUID();
    FileUpload fu = new FileUpload(request);
	String operation=Util.null2String(fu.getParameter("operation"));
	
	if(operation.equals("getUserInfo")){
		String resourceid=Util.null2String(fu.getParameter("resourceid"));
		String jsonStr=SocialIMService.getUserInfoJSON(user, resourceid);
		out.print(jsonStr);
	}else if(operation.equals("insertnote")) {
		String senderid = Util.null2String(fu.getParameter("senderid"));
		String acceptid = Util.null2String(fu.getParameter("acceptid"));
		String content = Util.null2String(fu.getParameter("content"));
		
		GroupNotice gn = new GroupNotice();
		gn.setSendid(senderid);
		gn.setContent(content);
		gn.setTargetid(acceptid);
		String creDate = Util.date(2);
		gn.setDate(Util.date(2));
		String id =RongService.addGroupNotice(gn); 
		Map result = new HashMap();
		if(!"".equals(id)){		//返回数据
			result.put("noteId", id);
			result.put("creDate", creDate.substring(0, 16));
		}else{
			result.put("noteId", -1);
		}
		out.print(JSONObject.fromObject(result));
	}else if(operation.equals("getnotelist")){
		SimpleDateFormat dateFormat = new SimpleDateFormat("MM-dd HH:mm");
		SimpleDateFormat dateFormat1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String targetid = Util.null2String(fu.getParameter("acceptid"));
		List<GroupNotice> gnList =  RongService.getGroupNoticeList(targetid);
		GroupNotice[] gnAry = new GroupNotice[gnList.size()];
		gnAry = gnList.toArray(gnAry);
		Map result = new HashMap();
		List lst = new ArrayList();
		ResourceUtil ru = new ResourceUtil();
		for(int i = 0; i < gnAry.length; ++i){
			Map tensh = new HashMap();
			String senderid=gnAry[i].getSendid(); 
			tensh.put("noteId", gnAry[i].getId());
			tensh.put("content",gnAry[i].getContent());
			tensh.put("creDate",dateFormat1.format(dateFormat1.parse(gnAry[i].getDate())));
			tensh.put("senderId",gnAry[i].getSendid());
			tensh.put("targetId",gnAry[i].getTargetid());
			tensh.put("senderName",ru.getHrmShowName(gnAry[i].getSendid()));
			tensh.put("hasOpRight", senderid.equals(userid)?"1":"0");
			lst.add(tensh);
		}
		result.put("res", lst);
		out.print(JSONObject.fromObject(result));
		lst.clear();
		lst = null;
	}else if(operation.equals("deletenote")){
		String id = Util.null2String(fu.getParameter("noteId"));
		boolean bSuccess = RongService.delGroupNotice(id);
		out.print(bSuccess?1:0);
	}else if(operation.equals("editIMSetting")){
		
		String targetid = Util.null2String(fu.getParameter("targetid"));
		String targetType = Util.null2String(fu.getParameter("targetType"));
		String remindType = Util.null2String(fu.getParameter("remindType"));
		SocialIMService.editIMSetting(userid,targetid,targetType,remindType);
		
		out.print("{targetid:'"+targetid+"',remindType:"+remindType+"}");
	}else if(operation.equals("getSettingInfo")){
		
		String result="";
		List<Map<String,String>> settingList=SocialIMService.getImSettingList(userid);
		for(int i=0;i<settingList.size();i++){
			Map<String,String> map=settingList.get(i);
			String targetid=map.get("targetid");
			String remindType=map.get("remindType");
			result+=",{targetid:'"+targetid+"',remindType:'"+remindType+"'}";
		}
		result=result.length()>0?result.substring(1):result;
		result="["+result+"]";
		out.print(result);
	}else if(operation.equals("addIMFile")){
		
		String targetid = Util.null2String(fu.getParameter("targetid"));
		String targetType = Util.null2String(fu.getParameter("targetType"));
		String fileid = Util.null2String(fu.getParameter("fileId"));
		String memberids = Util.null2String(fu.getParameter("memberids"));
		String resourcetype = Util.null2String(fu.getParameter("resourcetype"));
		
		SocialIMService.addIMFileByFileid(userid,fileid,targetid,memberids,resourcetype);
	}else if(operation.equals("delIMFile")){
		
		String fileid = Util.null2String(fu.getParameter("fileId"));
		SocialIMService.delIMFileByFileid(userid, fileid);
	}else if(operation.equals("delFileShare")){
		String fileid = Util.null2String(fu.getParameter("fileId"));
		//RecordSet.execute("delete from social_IMFileShare where userid = '"+userid+"' and fileId = '"+fileid+"' ");
		RecordSet.execute("delete from social_IMFileShare where fileId = '"+fileid+"' ");
	}else if(operation.equals("getIMFileList")){
		
		String targetid = Util.null2String(fu.getParameter("targetid"));
		String targetType = Util.null2String(fu.getParameter("targetType"));
		String keyword = Util.null2String(fu.getParameter("keyword"));
		String pageno = Util.null2String(fu.getParameter("pageno"));
		String pagesize = Util.null2String(fu.getParameter("pagesize"));
		int iPageno = Util.getIntValue(pageno);
		int iPagesize = Util.getIntValue(pagesize);
		iPageno = iPageno == -1 ? 1 : iPageno;
		iPagesize = iPagesize == -1 ? SocialIMService.getPAGESIZE(): iPagesize;
		keyword = java.net.URLDecoder.decode(keyword, "UTF-8");
		List<SocialIMFile> imFileList=SocialIMService.
			getIMFileList(""+userid,targetid,targetType,"1",keyword,iPageno, iPagesize);
		Map result=new HashMap();
		result.put("fileList",imFileList);
		result.put("fileCount",imFileList.size());
		result.put("hasnext", imFileList.size() == iPagesize ? true : false);
		result.put("pageno", iPageno);
		out.print(JSONObject.fromObject(result));
		
	}else if(operation.equals("publishMessage")){
		
		String params = Util.null2String(fu.getParameter("params"));
		JSONObject msgObject=JSONObject.fromObject(params);
		List<String> toUserids=new ArrayList<String>();
		String toUserid=msgObject.getString("toUserid");
		toUserids.add(toUserid);
		
		JSONObject msgExtraObj=JSONObject.fromObject(msgObject.get("extra"));
		//logger.error("publishMessage_msg_id:"+msgExtraObj.get("msg_id"));
		SocialIMClient.publishSyncMessage("syncUser",toUserids,msgObject);    
		
	}else if(operation.equals("initMsgRead")){
		
		String msgid = Util.null2String(fu.getParameter("msgid"));
		String resourceids = Util.null2String(fu.getParameter("resourceids"));
		
		Map<String, String> result=SocialIMService.getMsgUnReadCountList(msgid,resourceids,userid);
		
		JSONObject jObject=JSONObject.fromObject(result);
		out.print(jObject.toString());
		
	}else if(operation.equals("addRelatedMsg")){ //添加保存@提醒记录
		
		String hrmids = Util.null2String(fu.getParameter("hrmids"));
		String targetType = Util.null2String(fu.getParameter("targetType"));
		String targetid = Util.null2String(fu.getParameter("targetid"));
		String content = Util.null2String(fu.getParameter("content"));
		
		
	}else if(operation.equals("addOrDelGroupBook")){//添加或删除到通讯录


		String discussid = Util.null2String(fu.getParameter("discussid"));
		String resourceids = Util.null2String(fu.getParameter("resourceids"));
		String opt = Util.null2String(fu.getParameter("opt"));
		
		if(opt.equals("add")) {
            RongService.addGroupBook(discussid, resourceids);	    
            int isopenfire = Util.getIntValue(fu.getParameter("isopenfire"), 0);
            RongService.updateGroupBaseOn(discussid, isopenfire);
            SocialIMService.addGroupBook(resourceids,discussid,isopenfire);
        } else {
			RongService.delGroupBook(user, discussid);
			//删除群聊关系
			SocialIMService.delGroupBook(userid,discussid);
        }   
	}else if(operation.equals("getGroupBookStatus")){ //获取通讯录状态
		String discussid = Util.null2String(fu.getParameter("discussid"));
		boolean isAdded = SocialIMService.getGroupStatus(user, discussid);
		out.print(isAdded?"1":"0");
	}else if(operation.equals("getImageIds")){		//获取聊天记录图片
		/*
		String senderid = Util.null2String(fu.getParameter("senderid"));//发送者id
		String targetid = Util.null2String(fu.getParameter("targetid"));//聊天对象
		String targettype = Util.null2String(fu.getParameter("targettype"));//聊天类型
		String ids = SocialIMService.getHistoryImgIds(senderid, targetid, targettype); 
		out.print(ids);
		*/
	}else if(operation.equals("getChatRecords")){  //获取聊天记录
		String senderid = Util.null2String(fu.getParameter("senderid"));//发送者id
		if(!userid.equals(senderid)){
			out.print("");
		}else{
			String targetid = Util.null2String(fu.getParameter("targetid"));//聊天对象
			//targetid="9b8dfc5a-03dd-4356-84f0-4aa64dc83134";
			String targettype = Util.null2String(fu.getParameter("targettype"));//聊天类型
			String pageNo = Util.null2String(fu.getParameter("pageNo"));//页码 
			String begindate = Util.null2String(fu.getParameter("begindate"));//发送者id
			String enddate = Util.null2String(fu.getParameter("enddate"));//聊天对象
			String content = Util.null2String(fu.getParameter("content"));//聊天类型
			content = URLDecoder.decode(content, "utf-8");
			//senderid="819";
			//targetid="94205e76-411a-43a5-a9db-0a7794d7bc16";
			//targettype="2";
			
			Map<String,String> conditions=new HashMap<String,String>();
			conditions.put("begindate",begindate);
			conditions.put("enddate",enddate);
			conditions.put("content",content);
			
			Map result =SocialIMService.getIMChatRecords(senderid, targetid, targettype, Integer.parseInt(pageNo),conditions);
			JSONArray js = JSONArray.fromObject(result.get("recList"));
			int totalPage = Integer.parseInt(result.get("totalPage").toString());
			JSONObject res = new JSONObject();
			res.put("totalPage", totalPage);
			res.put("recList", js.toString());
			if(totalPage != -1 && js != null) res.put("isSuccess", true);
			else res.put("isSuccess", false);
			out.print(res.toString());
		}
	}else if(operation.equals("updateRecent")){  //更新最近列表


		String targetid = Util.null2String(fu.getParameter("targetid"));//聊天对象
		String targettype = Util.null2String(fu.getParameter("targettype"));//聊天类型
		SocialIMService.updateRecent(userid, targetid, targettype);
	}else if(operation.equals("deleteRecent")){  //删除R版通讯录最近列表


		String targetid = Util.null2String(fu.getParameter("targetid"));//聊天对象
		String targettype = Util.null2String(fu.getParameter("targettype"));//聊天类型
		SocialIMService.deleteRecent(userid, targetid, targettype); 

	}else if(operation.equals("updateImAttention")){  //更新会话关注
		String targetid = Util.null2String(fu.getParameter("targetid"));//聊天对象
		String targettype = Util.null2String(fu.getParameter("targettype"));//聊天类型
		String isOn = Util.null2String(fu.getParameter("isOn"));//聊天类型
		SocialIMService.updateAttention(userid, targetid, targettype, "1".equals(isOn)?true:false);
	}else if(operation.equals("getIMAttention")){  //查询会话关注
		String targetids = Util.null2String(fu.getParameter("targetids"));//聊天对象
		String targettypes = Util.null2String(fu.getParameter("targettypes"));//聊天类型
		Map aMap = SocialIMService.getAttentionMap(userid, targetids, targettypes);
		out.print(JSONObject.fromObject(aMap));
	}else if(operation.equals("getMsgUnreadCount")){ //统计消息未读状态


		String messageids = Util.null2String(fu.getParameter("messageids"));
		String receiverids = Util.null2String(fu.getParameter("receiverids"));
		Map<String, String> result=SocialIMService.getMsgUnReadCountList(messageids,receiverids,userid);
		JSONObject jObject=JSONObject.fromObject(result);
		out.print(jObject.toString());
	}else if(operation.equals("updateMsgUnreadCount")){ //更新消息未读状态


		String messageid = Util.null2String(fu.getParameter("messageid"));
		String receiverid = Util.null2String(fu.getParameter("receiverid"));
		String sendtime = Util.null2String(fu.getParameter("sendtime"));
		String msgFrom = Util.null2String(fu.getParameter("msgFrom"));
         	SocialIMService.updateMsgUnReadCount(messageid,receiverid,userid,sendtime);//更新阅读状态


		boolean isInit=SocialIMService.checkMsgIsInit(messageid);
		int count=0;
		if(isInit){
			count=SocialIMService.getMsgUnReadCount(messageid);
		}else{
			//统计已读的数目会出现一个bug 如果手机消息先来的话就不会去更新数据库了
			count=SocialIMService.getMsgReadCount(messageid);
		}
		String result="{\"messageid\":\""+messageid+"\",\"count\":"+count+",\"isInit\":"+isInit+"}";
		out.print(result);
	}else if(operation.equals("markMsgRead")){ //收到消息将消息标记为已读
		
		String messageid = Util.null2String(fu.getParameter("messageid")); //消息id
		String receiverid = Util.null2String(fu.getParameter("receiverid")); //消息接收人


		String senderid = Util.null2String(fu.getParameter("senderid")); //消息发送人，所属人
		
		SocialIMService.updateMsgUnReadCount(messageid,receiverid,senderid,"");//更新阅读状态


		
	}else if(operation.equals("sendCountMsg")){ //更新消息未读状态


		String messageid = Util.null2String(fu.getParameter("messageid"));
		
		//logger.error("sendCountMessage_msg_id:"+messageid);
		
	}else if(operation.equals("getConvers")){  //获取本地会话
		List<Map<String, String>> mapList = SocialIMService.getConvers(userid);
		JSONArray res = new JSONArray();
		res = JSONArray.fromObject(mapList.toArray());
		out.print(res.toString());
	}else if(operation.equals("syncConvers")){  //同步会话到本地


		String convers = Util.null2String(fu.getParameter("convers"));
        int isBaseOnOpenfire = 0;  //是否是基于openfire服务器，0：非 1：是
        String iboo = Util.null2String(fu.getParameter("IS_BASE_ON_OPENFIRE"));
        if("true".equals(iboo)) {
            isBaseOnOpenfire = 1;
        }
        if(convers.indexOf("\"targettype\":\"4\",") > 0) {
            convers = URLDecoder.decode(convers, "UTF-8");
        }
		int count = weaver.social.service.SocialIMService.syncConversToDb(userid, convers, isBaseOnOpenfire);//更新本地会话
	}else if(operation.equals("delLocalConver")){
		String targetid = Util.null2String(fu.getParameter("targetid"));
		String targettype = Util.null2String(fu.getParameter("targettype"));
		boolean isdeled = SocialIMService.delConver(userid, targetid,targettype);
		out.print(isdeled);
	}else if(operation.equals("checkServerStatus")){ //检查服务器状态
		out.print("1");
	}else if(operation.equals("saveSyncMsg")){ //保存同步消息
		String msgid = Util.null2String(fu.getParameter("msgid"));
		String message = Util.null2String(fu.getParameter("message"));
		SocialIMClient.saveSyncMsg(msgid,message,"200","receive");
	}else if(operation.equals("sendMsgBack")){ //转发消息
		String toids = Util.null2String(fu.getParameter("toids"));
		String content = Util.null2String(fu.getParameter("content"));
		SocialIMClient.sendMsgBack(userid, toids, content);
	}
	else if(operation.equals("AddMsgTag")){  //添加消息标记
		String tag = Util.null2String(fu.getParameter("tag"));
		String shareid = Util.null2String(fu.getParameter("shareid"));
		String msgid = Util.null2String(fu.getParameter("msgid"));
		JSONObject resInfo = SocialIMService.addMsgTag(msgid, tag, shareid); 
		boolean issuccess = resInfo.optBoolean("issuccess", true);
		JSONObject result = new JSONObject();
		result.put("issuccess", issuccess);
		result.put("resinfo", resInfo);
		out.print(result);
	}else if(operation.equals("getMsgTags")){  //获取消息标记
		String msgids = Util.null2String(fu.getParameter("msgids"));
		JSONArray msgtags = SocialIMService.getMsgTags(msgids);
		out.print(msgtags);
	}else if(operation.equals("checkPCLogin")){  //检查登陆状态
		String from = Util.null2String(fu.getParameter("from"));
		String sessionkey = Util.null2String(fu.getParameter("sessionkey"));		
		if(!sessionkey.isEmpty()&&from.equals("pc")){
		  RecordSet.executeQuery("select * from social_IMSessionkey where userid = ? and sessionkey = ?", userid, sessionkey);
		  if(RecordSet.next()){
		  	out.print("1");
		  }else{
		  	out.print("RepeatLanding");
		  }
		}else{
			String websessionkey = Util.null2String(fu.getParameter("websessionkey"));
			int status=SocialImLogin.isExistSeesionKey(websessionkey)==user.getUID()?user.getUID():-1; 
			if(status==-1){
				RecordSet.executeQuery("select * from social_IMSessionkey where userid = ? and loginStatus =2", userid);
	    	    if(RecordSet.next()){
	    	    	 status = 2;
	    	     }
			}			
			out.print(status);
		}
		
	}else if(operation.equals("isRemindPupup")){  //流程登是否已被处理


		String moduleNo = Util.null2String(fu.getParameter("moduleNo"));
		String requestid = Util.null2String(fu.getParameter("requestid"));
		String type = "-1";
		if(moduleNo.equals("1")){ //流程
			type = "0";
		}else if(moduleNo.equals("18")){ //邮件
			type = "15";
		}
		boolean ifPupup = SocialIMService.isRemindPupup(type, requestid);
		JSONObject result = new JSONObject();
		result.put("isNeedRemind", ifPupup?1:0);
		out.print(result);
	}else if(operation.equals("getHeadIcon")){	//获取头像
		out.print(SocialUtil.getUserHeadImage(userid));
	}else if(operation.equals("getLocalUserInfo")){  //获取人员信息
		String localUserInfo=SocialIMService.getLocalUserInfo(user, userid);
		out.print(localUserInfo);
	}else if(operation.equals("saveUserAppSetting")){  //保存客户端自定义管理设置
		String readyToDelIds = Util.null2String(fu.getParameter("readyToDelIds"));
		String readyToAddIds = Util.null2String(fu.getParameter("readyToAddIds"));
		String showindexs = Util.null2String(fu.getParameter("showindexs"));
		String userId = Util.null2String(fu.getParameter("userId"));
		//check userid
		boolean issuccess = false;
		if(userId.equals(user.getUID()+"")){
			issuccess = SocialIMService.saveUserAppSetting(userId, readyToDelIds, readyToAddIds, showindexs);
		}
		out.print(issuccess?"1":"0");
	}
    // 强制pc用户下线
	else if("forcedOfflineUsers".equals(operation)) {
        List<String> receiverIds = null;
        String ids = Util.null2String(request.getParameter("ids"));
        if(!ids.isEmpty()) {
            receiverIds = Arrays.asList(ids.split(","));
        }
        int clearType = Util.getIntValue(request.getParameter("clearType"), 0);  // 默认只是清理缓存
        boolean result = SocialIMService.forcedOfflineUsers(receiverIds, clearType);
        out.print(result ? "1" : "0");
    }
    // 发送给指定用用户发起对应聊天

	else if("openPCconversation".equals(operation)) {
		JSONObject json = new JSONObject();
        List<String> receiverIdsList = new ArrayList<String>();
        List<String> conventionersList =new ArrayList<String>();
        //String receiverIds = Util.null2String(request.getParameter("receiverIds"));
		String receiverIds = userid;
        String conventioners = Util.null2String(request.getParameter("conventioners"));
        String groupName = Util.null2String(request.getParameter("groupName"));
        String extra = Util.null2String(request.getParameter("extra")); 
        int result = 0;
		int pcStatus=0;
		int webStatus=0; 
		int socket = SocialImLogin.checkSocketStatus(user.getUID());
		pcStatus=socket==1?1:0;
		webStatus=socket==2?1:0; 
		if(pcStatus ==1 ||webStatus ==1){
				if(!conventioners.isEmpty()) {
				conventionersList = Arrays.asList(conventioners.split(","));
			}
			if(!receiverIds.isEmpty()) {
				receiverIdsList = Arrays.asList(receiverIds.split(","));
				result = SocialIMService.openPCconversation(receiverIdsList, conventionersList, Util.getIntValue(request.getParameter("openType"), -1)+"",groupName,extra);
			}
		} 
		json.put("pcStatus", pcStatus);
		json.put("webStatus", webStatus);
		json.put("result", result);
        out.print(json.toString());
    }
    // 检测用户PC端在线状态 0:不在线，1：在线
    else if ("isPcClientOnline".equals(operation)){
        int result = 0;
		String checkId = Util.null2String(request.getParameter("checkId"), "");
		if(!"".equals(checkId)) {
			ResourceComInfo rci = new ResourceComInfo();
			result=SocialImLogin.CheckpcOnline(checkId,rci.getLastname(userid),rci.getMessagerUrls(userid))?1:0;
		}
        out.print(result);
    }
    // 通过openfire发送消息
    else if("sendMsgByOpenfire".equals(operation)) {
        String fromUserId = Util.null2String(request.getParameter("fromUserId"));
        String userIdArray = Util.null2String(request.getParameter("userIdArray"));
        String objectName = Util.null2String(request.getParameter("objectName"));
        String content = URLDecoder.decode(Util.null2String(request.getParameter("content")), "UTF-8");
        String extra = Util.null2String(request.getParameter("extra"));
        OpenfireMessage ofm = new OpenfireMessage(objectName, content, extra);
        List<String> list = Arrays.asList(userIdArray.split(","));
        SocialOpenfireUtil.getInstanse().sendMessageToUser(fromUserId, list, ofm.toString());
    }
    // 获得openfire token
    else if("getTokenOfOpenfire".equals(operation)) {
    	String username = "" + user.getLastname();
		String messageUrl = SocialUtil.getUserHeadImage(userid);
		boolean reFreshToken = Util.null2String(request.getParameter("reFreshToken")).equals("1")?true:false;
        String udid = RongService.getRongConfig().getAppUDIDNew().toLowerCase();
        String token = SocialOpenfireUtil.getInstanse().getToken(userid + "|" + udid, username, messageUrl,reFreshToken);
        out.print(token);
    }
    
    else if("getUserTokenOfRong".equals(operation)) {
        JSONObject json = new JSONObject();
        HrmResourceService hrs = new HrmResourceService();
        User tempUser = hrs.getUserById(Integer.parseInt(request.getParameter("userid")));
        if(tempUser != null) {
            String username = ""+tempUser.getLastname();
            //String messageUrl = new ResourceComInfo().getMessagerUrls(tempUser.getUID() + "");
			String messageUrl = SocialUtil.getUserHeadImage(tempUser.getUID() + "");
            WeaverRongUtil rongUtil = WeaverRongUtil.getInstanse();
            Map<String,String> rongConfig = rongUtil.getRongConfig(tempUser.getUID() + "", username, messageUrl);
            String TOKEN = rongConfig.get("TOKEN");  //应用token
            String APPKEY = rongConfig.get("APPKEY");  //应用key
            String UDID = rongConfig.get("UDID");  //用户区分标识
            json.put("TOKEN", TOKEN);
            json.put("APPKEY", APPKEY);
            json.put("UDID", UDID);
        }
        out.print(json.toString());
    }
    else if("saveGroupInfos".equals(operation)) {
        String groupId = Util.null2String(request.getParameter("groupId"));
        RecordSet.executeQuery("select id from Social_AllGroupInfos where groupId = '" + groupId + "'");
        if(RecordSet.getCounts() == 0) {
            String groupName = URLDecoder.decode(Util.null2String(request.getParameter("groupName")), "UTF-8");
            String createUserId = Util.null2String(request.getParameter("createUserId"));
            String members = Util.null2String(request.getParameter("members"));
            
            String sql = "insert into Social_AllGroupInfos(groupId, groupName, createUserId, members) values (?, ?, ?, ?)";
            RecordSet.executeUpdate(sql, groupId, groupName, createUserId, members);
        }
    }
    else if("getTime".equals(operation)){
    	out.print(System.currentTimeMillis()+"");
    }
    else if(operation.equals("getUserDeptID")){	
		String acceptid = Util.null2String(fu.getParameter("acceptid"));
		if(acceptid.equals("")){
			out.print("");
		}else
		{
			String deptid=new ResourceComInfo().getDepartmentID(acceptid);
			out.print(deptid);
		}	
		
	}
    else if(operation.equals("saveWithdraw")){
    	String msgId = Util.null2String(request.getParameter("msgId"));
    	String targetId = Util.null2String(request.getParameter("targetId"));
        RecordSet.executeQuery("select id from Social_WithdrawMsg where msgid = '" + msgId + "'");
        if(!RecordSet.next()) {
            String sql = "insert into Social_WithdrawMsg(msgid, targetid, userid) values (?, ?, ?)";
            RecordSet.executeUpdate(sql, msgId, targetId, userid);
        }
        out.print(msgId);
    }
    else if(operation.equals("getWithdrawMsg")){
    	RecordSet.executeQuery("select distinct msgid, targetid from Social_WithdrawMsg where userid = '" + userid + "'");
    	JSONObject ret = new JSONObject();
        while(RecordSet.next()) {
            ret.put(RecordSet.getString("msgid"), RecordSet.getString("targetid"));
        }
        out.print(ret.toString());
    }else if(operation.equals("addNewDiscussList")){
    	String name =Util.null2String(java.net.URLDecoder.decode(request.getParameter("discussListName"),"UTF-8"));
    	new BaseBean().writeLog("socailimoperation----addNewDiscussList----name="+name);
    	String isopenfire = Util.null2String(request.getParameter("isopenfire"),"");
    	ConnStatement statement = new ConnStatement();
    	String sql = "select * from social_ImGroup where name ='"+name+"' and (createuserid ='"+userid+"' or createuserid='ALL')";
    	RecordSet.executeQuery(sql);
    	if(RecordSet.next()){
    		//存在同名群组
    		out.print("1");
    		return;
    	}
    	sql = "insert into social_ImGroup(name,createuserid) values(?,?)";
    	try{
    	  statement.setStatementSql(sql);
	      statement.setString(1,name);
	      statement.setString(2,userid);
	      statement.executeUpdate();
    	}catch(Exception e) {
    		//新建群组失败
    		out.print("2");
    		new BaseBean().writeLog("socailimoperation----addNewDiscussList----name----err="+e.getLocalizedMessage());
		}
		    finally {
		    	try { 
		    	  if(statement!=null) statement.close();
		    	 }catch(Exception ex) {
		    	  new BaseBean().writeLog("socailimoperation----addNewDiscussList----name----err="+ex.getLocalizedMessage());
		      }
		    }
    	//新建群组成功
    	out.print("3");  	
    }else if(operation.equals("deleteDiscussList")){
    	String name =Util.null2String(java.net.URLDecoder.decode(request.getParameter("name"),"UTF-8"));
    	String isopenfire = Util.null2String(request.getParameter("isopenfire"),"");
    	ConnStatement statement = new ConnStatement();
    	String sql = "select id from social_ImGroup where createuserid = '"+userid+"' and name = '"+name+"'";
    	RecordSet.executeQuery(sql);
    	String id="";
    	if(RecordSet.next()){
        	id = RecordSet.getInt("id")+"";
    	}else{
    		out.print("当前用户不具有这个群聊分组");
    		return;
    	}
    	//System.out.print(id);
    	sql = "select id as main_id from social_ImGroup where createuserid = 'ALL' and name = '我的群聊'";
    	RecordSet.executeQuery(sql);
    	String main_id ="";
    	if(RecordSet.next()){
    		main_id = RecordSet.getInt("main_id")+"";
    	}
    	//System.out.print(main_id);
        try{
        	//更新群聊关系组
       		sql = "update social_ImGroup_rel set rel_id = "+main_id+" where rel_id = "+id+" and isopenfire ="+isopenfire;
        	statement.setStatementSql(sql);
        	statement.executeUpdate();
        	//删除该分组
    		sql = "delete from social_ImGroup where name = '"+name+"' and createuserid = '"+userid+"'";
    		statement.setStatementSql(sql);
        	statement.executeUpdate();      
    	}catch(Exception e) {
    		out.print("删除群聊分组失败,请稍后重试");
    		new BaseBean().writeLog("socailimoperation----deleteDiscussList----name----err="+e.getLocalizedMessage());
    		return;
		}finally {
			try {
				if(statement!=null) statement.close();
				//out.print("删除群聊分组成功");
			}catch(Exception ex) {
					new BaseBean().writeLog("socailimoperation----deleteDiscussList----name----err="+ex.getLocalizedMessage());
			}		      
		}
        
    }else if(operation.equals("renameDiscussList")){
    	String name =Util.null2String(java.net.URLDecoder.decode(request.getParameter("discussListName"),"UTF-8"));
    	//String name = Util.null2String(fu.getParameter("discussListName"));
    	String orgName =Util.null2String(java.net.URLDecoder.decode(request.getParameter("orgName"),"UTF-8"));
    	ConnStatement statement = new ConnStatement();
    	String sql = "select * from social_ImGroup where name ='"+name+"' and (createuserid ='"+userid+"' or createuserid='ALL')";
    	RecordSet.executeQuery(sql);
    	if(RecordSet.next()){
    		//存在同名群组
    		out.print("4");
    		return;
    	}
    	sql = "update social_ImGroup set name = '"+name+"' where name = '"+orgName+"' and createuserid ='"+userid+"'";
    	try{
    	  statement.setStatementSql(sql);
    	  statement.executeUpdate();
    	}catch(Exception e) {
    		//重命名群聊分组失败
    		out.print("5");
		  }
		    finally {
		      try { if(statement!=null) statement.close();}catch(Exception ex) {}
		      //重命名群聊分组成功
		      out.print("6");
		    }
    	
    	
    }else if(operation.equals("updateDiscussName")){
    	//更新一下群聊关系表
    	ConnStatement statement = new ConnStatement();
    	String isopenfire = Util.null2String(fu.getParameter("isopenfire"),"");
    	String discussid = Util.null2String(fu.getParameter("discussid"));
    	String newDiscussName =Util.null2String(java.net.URLDecoder.decode(request.getParameter("newDiscussName"),"UTF-8"));
        String sql = "update social_ImGroup_Rel set groupName = '"+newDiscussName+"' where groupId = '"+discussid+"' and isOpenFire = "+isopenfire;
        try{
        	statement.setStatementSql(sql);
        	statement.executeUpdate();
        }catch(Exception e) {
    		//更新群聊名称失败
    		out.print("更新群聊名称失败");
		  }
		    finally {
		      try { if(statement!=null) statement.close();}catch(Exception ex) {}
		      //重命名群聊分组成功
		      out.print("更新群聊名称成功");
		    }
    }else if(operation.equals("getSocialGroupList")){
    	JSONObject groupObject = new JSONObject();
    	JSONArray groupArray = new JSONArray();
    	String sql = "select id,name,createuserid from social_ImGroup where createUserid = '"+userid +"' or createUserid = 'ALL'";
    	RecordSet.executeQuery(sql);
    	while(RecordSet.next()){
    		String name = RecordSet.getString("name");
    		String id = RecordSet.getInt("id")+"";
    		String createUserId = RecordSet.getString("createuserid");
    		groupObject.put("name", name);
    		groupObject.put("id", id);
    		groupObject.put("createUserId", createUserId);
    		groupArray.add(groupObject);
    	}
    	out.print(groupArray);
    }else if(operation.equals("changeGroupList")){
    	String id = Util.null2String(fu.getParameter("id"),"");
    	String groupName =Util.null2String(java.net.URLDecoder.decode(request.getParameter("groupName"),"UTF-8"));
    	String rel_id = Util.null2String(fu.getParameter("rel_id"),"");
    	String group_id = Util.null2String(fu.getParameter("group_id"),"");
    	String sql = "update social_ImGroup_rel set rel_id = ? where rel_id = ? and userid=? and groupid = ?" ;
    	ConnStatement statement = new ConnStatement();
    	try{
      	  	statement.setStatementSql(sql);
      	  	statement.setString(1,id);
	      	statement.setString(2,rel_id);
	      	statement.setString(3,userid);
	      	statement.setString(4,group_id);
      	  	statement.executeUpdate();
      	}catch(Exception e) {
     		//切换分组失败
     		out.print("切换群分组失败，请稍后重试");
     		new BaseBean().writeLog("socailimoperation----changeGroupList----exec sql is err----");
 		}finally {
  		    try { if(statement!=null) statement.close();}catch(Exception ex) {}
  		}
    }else if(operation.equals("getDiscussGroup")){ 	
    	int isopenfire = Util.getIntValue(request.getParameter("isopenfire"), 0);
    	out.print(SocialIMService.getDiscussTree(userid,isopenfire,user));    	
    }else if(operation.equals("checkUserPwd")){
        out.print(SocialImLogin.checkUserPwd(userid));
    }else if(operation.equals("deleteDiscussRel")){
    	String group_id = Util.null2String(fu.getParameter("group_id"),"");
    	//删除群聊关系
		String sql = "delete from social_ImGroup_rel where groupid='"+group_id+"' and userid= '"+userid+"'";
		RecordSet.executeUpdate(sql);
  }else if(operation.equals("addConversation")){
  	String targetid = Util.null2String(fu.getParameter("targetid"),"");
    String targetname = Util.null2String(fu.getParameter("targetname"),"");
    String isopenfire = Util.null2String(fu.getParameter("isopenfire"),"");
    String senderid = Util.null2String(fu.getParameter("senderid"),"");
    String targettype = Util.null2String(fu.getParameter("targettype"),"");
  	String insertSql = "insert into social_IMConversation " +
						   "(userid, targetid, targettype,targetname,senderid,isopenfire) " +
						   "values (?,?,?,?,?,?)";
		RecordSet.executeUpdate(insertSql,userid,targetid,targettype,targetname,senderid,isopenfire);
  }else if(operation.equals("getBeforeAfterChatRecords")){
    	String senderid = Util.null2String(fu.getParameter("senderid"));//发送者id
		String targetid = Util.null2String(fu.getParameter("targetid"));//聊天对象
		String targettype = Util.null2String(fu.getParameter("targettype"));//聊天类型
		String id = Util.null2String(fu.getParameter("id"),"");
		Map<String,String> conditions=new HashMap<String,String>();
		conditions.put("begindate","");
		conditions.put("enddate","");
		conditions.put("content","");
		int pageNO = SocialIMService.getPageNO(senderid, targetid, targettype,id);		
		Map result =SocialIMService.getIMChatRecords(senderid, targetid, targettype, pageNO,conditions);
		JSONArray js = JSONArray.fromObject(result.get("recList"));
		int totalPage = Integer.parseInt(result.get("totalPage").toString());
		JSONObject res = new JSONObject();
		res.put("totalPage", totalPage);
		res.put("pageNO",pageNO);
		res.put("recList", js.toString());
		if(totalPage != -1 && js != null) res.put("isSuccess", true);
		else res.put("isSuccess", false);
		out.print(res.toString());
	}else if(operation.equals("getIMSignInfos")){
	    
		JSONObject res = SocialIMService.getIMSignInfos(user);
		out.print(res.toString());
	}else if(operation.equals("insertSignatures")){
	    
		try{
		String signatures =Util.null2String(java.net.URLDecoder.decode(request.getParameter("signatures"),"UTF-8"));
		//转化一下在写入
		//signatures=Util.toHtml(signatures);
		//判断一下是否含有反斜杠，单引号，双引号
		if(signatures.indexOf('\\')>=0||signatures.indexOf('\'')>=0||signatures.indexOf('\"')>=0){
			out.print("2");
		}
		SocialUtil.insertSignatures(userid,signatures);
		}catch(Exception e){
			out.print("0");
		}
		out.print("1");
	}else if(operation.equals("updateSignature")){
		String targetid = Util.null2String(fu.getParameter("userid"));
		out.print(SocialUtil.getSignatures(targetid));
	}else if(operation.equals("updateCardInfo")){
		String userids = Util.null2String(fu.getParameter("userids"));
		String[] useridList = Util.TokenizerString2(userids, ",");
		boolean isBatch = useridList.length > 1;
		JSONObject msItem = new JSONObject(), ret = new JSONObject();
		ResourceComInfo rci = SocialUtil.getResourceComInfo();
		for(String uid : useridList){
			msItem.put(uid, rci.getMobileShow(uid, user));
		}
		ret.put("mobileshow", msItem);
		String sig = SocialUtil.getSignatures(userids);
		ret.put("signature", isBatch?sig: "{'"+userids+"':'"+sig+"'}");
		
		out.print(ret.toString());
	}else if(operation.equals("getUnreadId")){
		String messageid = Util.null2String(fu.getParameter("messageid"));
		String fromuserid = Util.null2String(fu.getParameter("userid"));
		String sql="select distinct receiverid from (select * from social_IMMsgRead where msgid='"+messageid+"' and status=1) a where receiverid <> '"+fromuserid+"'";
		RecordSet.executeQuery(sql);
		StringBuffer sb = new StringBuffer("");
		int i=0;
		int count= RecordSet.getCounts();
    	while(RecordSet.next()){
    		String id = RecordSet.getInt("receiverid")+"";
			sb.append(id);
			i++;
			if(i<count){
				sb.append(",");
			}
    	}
		if(sb.toString().equals("")){
			out.print("0");
		}else{
			out.print(sb.toString());
		}
	}else if(operation.equals("getMobileShow")){
        String targetid = Util.null2String(fu.getParameter("userid"),"");
        //String mobile = new ResourceComInfo().getMobileShow(targetid, targetid);
        String mobile = SocialUtil.getResourceComInfo().getMobileShow(targetid, user);
        out.print(mobile);
    }else if(operation.equals("getAccountBelongTO")){
		JSONArray accountArray = new JSONArray();
		if(SocialClientProp.getPropValue(SocialClientProp.MULTIACCOUNTMSG).equals("1")){
			accountArray = JSONArray.fromObject(SocialUtil.getAccountBelongtoMap());
		}
		out.print(accountArray.toString());
	}else if(operation.equals("checkFileDelete")){
		try{
			String ids =Util.null2String(request.getParameter("ids"));
			JSONObject result = new JSONObject();
			String[] idList = Util.TokenizerString2(ids, ",");
			HashSet<String> set = new HashSet<String>();
			if(SocialClientProp.getPropValue(SocialClientProp.ISOPENDELETEFILETASK).equals("1")){
				String sqlWhere = SocialUtil.getSubINClauseWithQuote(ids, "imagefileid", "in");
				RecordSet.execute("select imagefileid from imagefile where " + sqlWhere);
				while(RecordSet.next()) {
					set.add(RecordSet.getString(1));
				}
			}else{
					set = new HashSet<String>(Arrays.asList(idList));
			}	
			for(String id : idList){
				if(set.contains(id)){
					result.put(id, "0");
				}else{
					result.put(id, "1");
				}
			}
			out.print(result.toString());
		}catch(Exception e){
			
		}
	}else if(operation.equals("getConversByTargetType")){
		//通过targettyp获取会话
		String targetType = fu.getParameter("targetType");
		List<Map<String, String>> mapList = SocialIMService.getConversByTargetType(userid,targetType);
		JSONArray res = new JSONArray();
		res = JSONArray.fromObject(mapList.toArray());
		out.print(res.toString());
	}else if(operation.equals("deletePrivateChatRecords")){//删除密聊消息
		String msgids = Util.null2String(fu.getParameter("msgids"));
		String sqlWhere = SocialUtil.getSubINClauseWithQuote(msgids, "msgid", "in");
		boolean flag   = RecordSet.executeUpdate("update  HistoryMsgRecently set targetType ='-1'  where "+ sqlWhere);
		JSONObject result = new JSONObject();
		result.put("msgids", msgids);
		result.put("flag", flag);
		out.print(result.toString());
	}else if(operation.equals("delPrivateConver")){
		String targetids = Util.null2String(fu.getParameter("targetids"));
		String targettype = Util.null2String(fu.getParameter("targettype"));
		boolean flag = SocialIMService.delPrivateConver(userid, targetids,targettype);
		JSONObject result = new JSONObject();
		result.put("targetids", targetids);
		result.put("flag", flag);
		out.print(result.toString());
	}else if(operation.equals("getDocid")){
	    String fileid = Util.null2String(fu.getParameter("fileid"));
	    String sql="select docid from DocImageFile where imagefileid = "+fileid;
        RecordSet.executeQuery(sql);
        String docid = "";
        while(RecordSet.next()) {
            docid = RecordSet.getString(1);
        }
        out.print(docid);
	}else if(operation.equals("updateConverSationTime")){
		String sendtime = Util.null2String(fu.getParameter("sendtime"));
		String content = Util.null2String(fu.getParameter("content"));
		String id = Util.null2String(fu.getParameter("userid"));
		String querySql = "select t2.* from social_IMRecentConver  t1 left join social_IMConversation t2 on t1.targetid=t2.targetid where t1.userid="+id+" and t1.targetid=t2.targetid and lasttime > " + sendtime;
		boolean isBingForbit = "1".equals(SocialClientProp.getPropValue(SocialClientProp.FORBIT_BING));
		boolean isGroupChatForbit = "1".equals(SocialClientProp.getPropValue(SocialClientProp.FORBIT_GROUPCHAT));
		boolean isBroadcastForbit = "1".equals(SocialClientProp.getPropValue(SocialClientProp.FORBIT_SYSBROARDCAST));
		boolean isForbitPrivateChat = "1".equals(SocialClientProp.getPropValue(SocialClientProp.FORBIT_PRIVATECHAT));
		querySql += "and t2.targettype <> '8' ";
		if(isBingForbit){
			querySql += "and t2.targettype <> '3' ";
		}
		if(isGroupChatForbit){
			querySql += "and t2.targettype <> '1' ";
		}
		if(isBroadcastForbit){
			querySql += "and t2.targettype <> '4' ";
		}
		if(isForbitPrivateChat){
			querySql += "and t2.targettype <> '7' ";
		}
		RecordSet.executeQuery(querySql);
		JSONArray res = new JSONArray();
		while (RecordSet.next()) {
			JSONObject result = new JSONObject();
			result.put("msgcontent", RecordSet.getString("msgcontent"));
			result.put("sendtime", RecordSet.getString("lasttime"));
			String targetid = RecordSet.getString("targetid");
			String targettype = RecordSet.getString("targettype");
			result.put("targettype", targettype);
			if (targettype.equals("0")) {
				String[] targtids = targetid.split(",");
				if (userid.equals(targtids[0])) {
					targetid = targtids[1];
				} else {
					targetid = targtids[0];
				}
			}
			result.put("targetid", targetid);
			result.put("msgid", RecordSet.getString("msgid"));
			result.put("userid", RecordSet.getString("userid"));
			res.add(result);
		}
		out.print(res.toString());
    }else if(operation.equals("changeWebXml")){
        //String type = Util.null2String(fu.getParameter("type"));
        out.print(SocialUtil.changeWebXmlByDom4j());  
    }else if(operation.equals("deleteEmessageWrongIcon")){
        out.print(SocialUtil.deleteEmessageWrongIcon()?1:0);
    }
	
%>
