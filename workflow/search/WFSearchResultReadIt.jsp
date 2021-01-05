
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.workflow.request.WFPathUtil"%>
<jsp:useBean id="WFForwardManager" class="weaver.workflow.request.WFForwardManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page"/>
<jsp:useBean id="WFCoadjutantManager" class="weaver.workflow.request.WFCoadjutantManager" scope="page" />
<jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page"/>
<%

/*用户验证*/
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//
User user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}
//标记为已读
//int userid = Util.getIntValue(Util.null2String(request.getParameter("userid")),0);
int userid=user.getUID();                   //当前用户id
String logintype = user.getLogintype();
String usertype = "2".equals(logintype) ? "1" : "0";
String flagrd = Util.null2String(request.getParameter("flag"));
int type = -1;
if(!"".equals(flagrd)){
	if("newWf".equals(flagrd)){
		type = 0;
	}else if("rejectWf".equals(flagrd)){
		type = 14;
	}else if("overtime".equals(flagrd)){
		type = 10;
	}else if("endWf".equals(flagrd)){
		type = 1;
	}
}

String requestidall=Util.null2String(request.getParameter("requestid"));
requestidall = requestidall.substring(0, requestidall.length() - 1);

String[] arrayrequestid = null;
int requestid = 0;
if(requestidall.indexOf(",") != -1){
	arrayrequestid = requestidall.split(",");
}else{
	arrayrequestid = new String[1];
	arrayrequestid[0] = requestidall;
}
if(arrayrequestid != null){
	for(int i=0;i<arrayrequestid.length;i++){
		requestid = Util.getIntValue(arrayrequestid[i]);
		//int requestid=Util.getIntValue(Util.null2String(request.getParameter("requestid")),0);
		if(requestid!=0 && ((userid!=0 && !"".equals(usertype)) || (!"".equals(f_weaver_belongto_userid) && !"".equals(f_weaver_belongto_usertype))) && !"".equals(logintype) ){
		//System.out.println("-18--f_weaver_belongto_userid-"+f_weaver_belongto_userid);
		    WFPathUtil.executewfread(user, requestid);
		}
	}
}
%>