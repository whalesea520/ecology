<%@ page import="weaver.general.Util,
                 weaver.sms.SMSSaveAndSend" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SMSSaveAndSend" class="weaver.sms.SMSSaveAndSend" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CommunicateLog" class="weaver.sms.CommunicateLog" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%@ page import="weaver.sms.*" %>
<%
//String message = new String(request.getParameter("message").getBytes("8859_1"));
    String message = request.getParameter("message");
    String isdialog = Util.null2String(request.getParameter("isdialog"));
    String rechrmnumber = Util.null2String(request.getParameter("recievenumber1"));
    String reccrmnumber = Util.null2String(request.getParameter("recievenumber2"));

    String customernumber = Util.null2String(request.getParameter("customernumber"));

    String rechrmids = Util.null2String(request.getParameter("hrmids02"));
    String reccrmids = Util.null2String(request.getParameter("crmids02"));

    String sendnumber = Util.fromScreen(request.getParameter("sendnumber"), user.getLanguage());
    if (!HrmUserVarify.checkUserRight("CreateSMS:View", user)) {
    	out.println("<script>wfforward(\"/notice/noright.jsp\");</script>");
    	return;
   	}
    
    
    int requestid = 0;
    int userid = user.getUID();
    String usertype = user.getLogintype();

    SMSSaveAndSend.reset();
    
    SmsSetBean wc=SmsCache.getSmsSet();
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
    //处理人力资源及手机号码  开始
    String[] rechrmidss= rechrmids.split(",");
    String temphrmids="";
    String tempId="";
    String temphrmnumber="";
    for(int i=0;i<rechrmidss.length;i++){
    	tempId=rechrmidss[i];
    	if("".equals(tempId)) continue;
    	temphrmids+="".equals(temphrmids)?tempId:","+tempId;
    	temphrmnumber+="".equals(temphrmnumber)?ResourceComInfo.getMobile(tempId):","+ResourceComInfo.getMobile(tempId);
    }
    rechrmids=temphrmids;
    rechrmnumber=temphrmnumber;
    //处理人力资源及手机号码  结束
    SMSSaveAndSend.setMessage(message);
    SMSSaveAndSend.setRechrmnumber(rechrmnumber);
    SMSSaveAndSend.setReccrmnumber(reccrmnumber);
    SMSSaveAndSend.setCustomernumber(customernumber);
    //System.out.println("customernumber = " + customernumber);
	
    SMSSaveAndSend.setRechrmids(rechrmids);
    SMSSaveAndSend.setReccrmids(reccrmids);
    SMSSaveAndSend.setSendnumber(sendnumber);
    SMSSaveAndSend.setRequestid(requestid);
    SMSSaveAndSend.setUserid(userid);
    SMSSaveAndSend.setUsertype(usertype);
    CommunicateLog.resetParameter();
    CommunicateLog.insSysLogInfo(user,0,"发送短信","页面发送短信","396","1",1,Util.getIpAddr(request));
    if (SMSSaveAndSend.pageSend()) {
        response.sendRedirect("/sms/SmsMessageSuccess.jsp?isdialog="+isdialog);
   	} else {
        response.sendRedirect("/sms/SmsMessageError.jsp?isdialog="+isdialog);
    }
%>