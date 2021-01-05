<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="weaver.file.FileUpload"%>
<%@page import="weaver.mobile.ding.MobileDing"%>
<%@page import="weaver.social.SocialUtil"%>
<%@page import="weaver.social.SocialUtil"%>
<%@page import="weaver.mobile.ding.DingReply"%>
<%@page import="weaver.general.TimeUtil"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="weaver.mobile.ding.DingReciver"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="MobileDingService" class="weaver.mobile.ding.MobileDingService" scope="page" />
<%
String userid=""+user.getUID();
FileUpload fu = new FileUpload(request);

String operation=Util.null2String(fu.getParameter("operation"));

if(operation.equals("doConfirm")){
	String dingid=Util.null2String(fu.getParameter("dingid"));
	MobileDing ding=MobileDingService.updateDingConfirm(dingid,user);
	MobileDingService.notity(ding,user);
	int replyCount=ding.getDingReplys().size();
	out.println(replyCount);
}else if(operation.equals("doReply")){
	String dingid=Util.null2String(fu.getParameter("dingid"));
	String content=Util.null2String(fu.getParameter("content"));
	String createtime=TimeUtil.getCurrentTimeString();
	DingReply dingReply=new DingReply();
	dingReply.setDingid(dingid);
	dingReply.setUserid(userid);
	dingReply.setContent(content);
	dingReply.setOperate_date(createtime);
	MobileDing ding=MobileDingService.addDingReply(dingReply);
	
	MobileDingService.notity(ding,user);
	
	String result="{'userid':'"+userid+"','username':'"+SocialUtil.getUserName(userid)+"','dingid':'"+dingid+"'"+
				  ",'content':'"+content+"','createtime':'"+createtime+"','imageurl':'"+SocialUtil.getUserHeadImage(userid)+"'}";
	//int replyCount=ding.getDingReplys().size();
	out.println(result);
}else if(operation.equals("doSave")){
	
	String receiver=Util.null2String(fu.getParameter("receiver"));
	String content=Util.null2String(fu.getParameter("content"));
	String remindType=Util.null2String(fu.getParameter("remindType"));
	
	String messageid=Util.null2String(fu.getParameter("msgid"));
	MobileDing ding = null;
	if("".equals(messageid)){
		ding=MobileDingService.saveMobileDing(userid,receiver,content,remindType);
	}
	else{
		String scopeid = Util.null2String(fu.getParameter("scopeid"));
		ding = new MobileDing();
		String udid = UUID.randomUUID().toString();
		List<DingReciver> list = new ArrayList<DingReciver>();
		String[] drs = receiver.split(",");
		for(int i =0;i<drs.length;i++){
			if(drs[i]!=null&&!"".equals(drs[i])){
				int uid=Integer.parseInt(drs[i]);
				DingReciver dr = new DingReciver();
				dr.setDingid(udid); 
				dr.setUserid(uid+"");
				dr.setConfirm("false");
				list.add(dr);
			}
		}
		ding.setDingRecivers(list);
		ding.setSendid(user.getUID()+"");
		ding.setUdid(udid);
		ding.setContent(content);
		ding.setScopeid(scopeid);
		ding.setMessageid(messageid);
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String curDate = sdf.format(new Date());
		ding.setOperateDate(curDate);
		ding = MobileDingService.saveMobileDing(ding);
		MobileDingService.notity(ding,user);
		MobileDingService.notityPush(ding);
		if(remindType.equals("1")){
			MobileDingService.sendSms(ding);
		}
	}
	
	out.print(ding == null?"":ding.getId());
}else if(operation.equals("getdinginfo")){			//获取必达信息
	String dingid = Util.null2String(fu.getParameter("dingid"));
	MobileDing ding = MobileDingService.getMobileDing(dingid);
	String result="{'sendid':'"+ding.getSendid()+"'"+
		",'sendname':'"+SocialUtil.getUserName(ding.getSendid())+"'"+
		",'content':'"+ding.getContent()+"'"+
		",'operateDate':'"+ding.getOperateDate()+"'"+
	  	",'replyUpdate':'"+ding.getReplyUpdate()+"'";
	String dingRecivers = JSONArray.fromObject(ding.getDingRecivers()).toString();
	String dingReplys = JSONArray.fromObject(ding.getDingReplys()).toString();
	result += ",'dingRecivers':"+dingRecivers+"";
	result += ",'dingReplys':"+dingReplys+"}";
	out.print(result.replaceAll("'","\""));
}

%>

