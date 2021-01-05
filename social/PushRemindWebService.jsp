<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="net.sf.json.*"%>
<%@ page import="weaver.file.*"%>
<%@ page import="weaver.general.*"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<jsp:useBean id="SocialIMClient" class="weaver.social.im.SocialIMClient" scope="page" />
<jsp:useBean id="SocialIMService" class="weaver.social.service.SocialIMService" scope="page" />
<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("application/json;charset=UTF-8");
	FileUpload fu = new FileUpload(request); 
	/**
	 * 外部（自定义）消息推送
	 * @param title 窗口标题
	 * @param requesttitle 标题
	 * @param requestdetails 详情信息（标签文本）
	 * @param requesturl 外部链接
	 * @param extra 消息体扩展字段
	 * @param receiverIds 接收人id
	 */
	 Boolean flag = false;
	 JSONObject result = new JSONObject();
	String method=Util.null2String(fu.getParameter("method"));
	if(method.equals("pushExternal")){
		String title = Util.null2String(fu.getParameter("title"));
		String requesttitle = Util.null2String(fu.getParameter("requesttitle"));
		String requestdetails = Util.null2String(fu.getParameter("requestdetails"));
		String requesturl = Util.null2String(fu.getParameter("requesturl"));
		String extra = Util.null2String(fu.getParameter("extra"));
		String receiverIdsStr = Util.null2String(fu.getParameter("receiverIds"));
		String key = Util.null2String(fu.getParameter("key"));
		String[]  receiverIds = receiverIdsStr.split(",");
		if(title.equals(""))title = null;
		if(key.equals("3d0786ea-13df-44cb-9d23-e0412658ebd5")&&receiverIds.length>0){
			SocialIMClient.pushExternal(title, requesttitle, requestdetails, requesturl, extra, Arrays.asList(receiverIds));
			flag = true;
		}else{
		if(!key.equals("3d0786ea-13df-44cb-9d23-e0412658ebd5")){
				result.put("key", "key不正确");
			}
			if(receiverIds.length==0){
				result.put("receiverIds", "接收用户不存在！");
			}
		}
	}else if(method.equals("pushExternalbyLoginid")){
		String title = Util.null2String(fu.getParameter("title"));
		String requesttitle = Util.null2String(fu.getParameter("requesttitle"));
		String requestdetails = Util.null2String(fu.getParameter("requestdetails"));
		String requesturl = Util.null2String(fu.getParameter("requesturl"));
		String extra = Util.null2String(fu.getParameter("extra"));
		String receiverIdsStr = Util.null2String(fu.getParameter("receiverIds"));
		String key = Util.null2String(fu.getParameter("key"));
		List<String> loginids = SocialIMService.getUseridsbyLoginids(receiverIdsStr.split(","));
		if(title.equals(""))title = null;
		if(key.equals("3d0786ea-13df-44cb-9d23-e0412658ebd5")&&loginids.size()>0){
			SocialIMClient.pushExternal(title, requesttitle, requestdetails, requesturl, extra, loginids);
			flag = true;
		}else{
			if(!key.equals("3d0786ea-13df-44cb-9d23-e0412658ebd5")){
				result.put("key", "key不正确");
			}
			if(loginids.size()==0){
				result.put("receiverIds", "接收用户不存在！");
			}
		}
		
	}
	result.put("result", flag);
		out.println(flag);
	
%>