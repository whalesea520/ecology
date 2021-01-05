
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.Util"%>
<jsp:useBean id="SaveAndSendWechat" class="weaver.wechat.SaveAndSendWechat" scope="page" />
<%@ page import="weaver.hrm.*"%>
<%@ page import="weaver.wechat.util.*"%>
<%@ page import="java.net.*" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<%@ page import="weaver.wechat.bean.*,weaver.wechat.cache.*" %>
<jsp:useBean id="CommunicateLog" class="weaver.sms.CommunicateLog" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;

String userid=Utils.null2String(request.getParameter("userid"));
String usertype=Utils.null2String(request.getParameter("usertype"));
String hrmid = Utils.null2String(request.getParameter("hrmid"));
String publicid = Utils.null2String(request.getParameter("publicid"));
String message = URLDecoder.decode(Utils.null2String(request.getParameter("message")),"UTF-8");;
int isNews = Utils.getIntValue(Utils.null2String(request.getParameter("isNews")),0);

SaveAndSendWechat.setHrmid(hrmid);
SaveAndSendWechat.setPublicid(publicid);
SaveAndSendWechat.setUserid(Integer.parseInt(userid));
SaveAndSendWechat.setUsertype(Integer.parseInt(usertype));
SaveAndSendWechat.setIsNews(isNews);
if(isNews==1){
	String news = Utils.null2String(request.getParameter("news"));
	SaveAndSendWechat.setMsg(news);
}else{

	WechatSetBean wc=WechatSetCache.getWechatSet();
	String sign="";
	if("1".equals(wc.getUsername())){
		sign+="-"+user.getUsername();
	}
	if("1".equals(wc.getUserid())){
		sign+="("+user.getUID()+")";
	}
	if("1".equals(wc.getDept())){
		String dept=DepartmentComInfo.getDepartmentname(user.getUserDepartment()+"");
		if(!"".equals(dept)){
			sign+="-"+dept;
		}
	}
	if("1".equals(wc.getSubcomp())){
		String subcomp=SubCompanyComInfo.getSubCompanyname(user.getUserSubCompany1()+"");
		if(!"".equals(subcomp)){
			sign+="-"+subcomp;
		}
	}
	if("1".equals(wc.getSignPostion())){//署名在后面
		message=!"".equals(sign)?sign.indexOf("-")==0?message+sign:message+"-"+sign:message;
	}else{
		message=!"".equals(sign)?sign.indexOf("-")==0?sign.substring(1)+"-"+message:sign+"-"+message:message;
	}
	SaveAndSendWechat.setMsg(message);
}
CommunicateLog.resetParameter();
CommunicateLog.insSysLogInfo(user,0,"发送微信","页面发送微信","398","1",1,Util.getIpAddr(request));

out.print(SaveAndSendWechat.send());
//if(SaveAndSendWechat.send()){
//	response.sendRedirect("wechatResult.jsp?type=success");
//}else{
//	response.sendRedirect("wechatResult.jsp?type=error");
//}
%>