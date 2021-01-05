
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.mobile.ding.*" %>
<%@ page import="weaver.mobile.plugin.ecology.service.*" %>

<%
request.setCharacterEncoding("UTF-8");
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
	Map result = new HashMap();
	//未登录或登录超时
	result.put("error", "remote server session time out");
	
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
	
	return;
}

response.setContentType("application/json;charset=UTF-8");

FileUpload fu = new FileUpload(request);

String operation = Util.null2String(fu.getParameter("method"));

Map result = new HashMap();
if("create".equals(operation)) {
	String content = Util.null2String(fu.getParameter("content"));
	String dingRecivers = Util.null2String(fu.getParameter("dingRecivers"));
	String scopeid = Util.null2String(fu.getParameter("scopeid"));
	String messageid = Util.null2String(fu.getParameter("messageid"));
	String noticetype = Util.null2String(fu.getParameter("noticetype"));
	MobileDing md = new MobileDing();
	String udid = UUID.randomUUID().toString();
	List<DingReciver> list = new ArrayList<DingReciver>();
	String[] drs = dingRecivers.split(",");
	for(int i =0;i<drs.length;i++){
		if(drs[i]!=null&&!"".equals(drs[i])){
			int userid=Integer.parseInt(drs[i]);
			DingReciver dr = new DingReciver();
			dr.setDingid(udid); 
			dr.setUserid(userid+"");
			dr.setConfirm("false");
			list.add(dr);
		}
	}
	md.setDingRecivers(list);
	md.setSendid(user.getUID()+"");
	md.setUdid(udid);
	md.setContent(content);
	md.setScopeid(scopeid);
	md.setMessageid(messageid);
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String curDate = sdf.format(new Date());
	md.setOperateDate(curDate);
	md = MobileDingService.saveMobileDing(md);
	MobileDingService.notity(md,user);
	MobileDingService.notityPush(md);
	if(noticetype.equals("1")){
		MobileDingService.sendSms(md);
	}
	result.put("ding", md);
	result.put("sucessce", "1");
}else if("addreplay".equals(operation)){
	DingReply dr =new DingReply();
	String dingid = Util.null2String(fu.getParameter("dingid"));
	dr.setDingid(dingid);
	String content = Util.null2String(fu.getParameter("content"));
	dr.setContent(content);
	dr.setUserid(user.getUID()+"");
	MobileDing md = MobileDingService.addDingReply(dr);
	
	MobileDingService.notity(md,user);
	result.put("sucessce", "1");
	result.put("ding", md);
}else if("confirm".equals(operation)){
	String dingid = Util.null2String(fu.getParameter("dingid"));
	MobileDing md = MobileDingService.updateDingConfirm(dingid,user);
	MobileDingService.notity(md,user);
	result.put("sucessce", "1");
	result.put("ding", md);
}else if("getDingHistory".equals(operation)){
	List<MobileDing> list = MobileDingService.getMobileDingList(user.getUID()+""); 
	result.put("list", list);
}else{
	return;
}

JSONObject jo = JSONObject.fromObject(result);
out.println(jo);

%>