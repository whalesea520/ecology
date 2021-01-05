
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.mobile.sign.*" %>

<jsp:useBean id="scheduleService" class="weaver.mobile.plugin.ecology.service.ScheduleService" scope="page"/>
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

String module = Util.null2String(fu.getParameter("module"));
String scope = Util.null2String(fu.getParameter("scope"));
String operation = Util.null2String(fu.getParameter("operation"));
Map result = new HashMap();
if("create".equals(operation)) {
	try{
		MobileSign ms = new MobileSign();
		String latitudeLongitude = Util.null2String(fu.getParameter("latitudeLongitude"));
		String address = Util.null2String(fu.getParameter("address"));
		String remark = Util.null2String(fu.getParameter("remark"));
		String attachmentIds = Util.null2String(fu.getParameter("attachmentIds"));
		if(!latitudeLongitude.equals("")){
			String[]  ll = latitudeLongitude.split(",");
			ms.setLatitude(ll[0]);
			ms.setLongitude(ll[1]);
		}else{
			ms.setLatitude("0");
			ms.setLongitude("0");
		}
		Date curDate =  new Date();
		SimpleDateFormat myFmt=new SimpleDateFormat("yyyy-MM-dd");
		String dateStr = myFmt.format(curDate);
		SimpleDateFormat myFmt1=new SimpleDateFormat("HH:mm:ss");
		String timeStr = myFmt1.format(curDate);
		ms.setOperaterId(user.getUID()+"");
		ms.setOperateType(SignType.MOBILE_SIGN);
		ms.setOperateDate(dateStr);
		ms.setOperateTime(timeStr);
		ms.setRemark(remark);
		ms.setAddress(address);
		ms.setAttachmentIds(attachmentIds);
		ms.save();
		result.put("result", "1");
	}catch(Exception e){
		e.printStackTrace();
		result.put("result", "0");
	}
}else if("getList".equals(operation)){
		String pageindex = Util.null2String(fu.getParameter("pageindex"));
		String pagesize = Util.null2String(fu.getParameter("pagesize"));
		String beginQueryDate = Util.null2String(fu.getParameter("beginQueryDate"));
		String endQueryDate = Util.null2String(fu.getParameter("endQueryDate"));
		String operaterId = Util.null2String(fu.getParameter("operaterId"));
		String signType = Util.null2String(fu.getParameter("signType"));
		String tempOperaterId = "";
		if("".equals(operaterId)){
			tempOperaterId = user.getUID()+"";
		}else{
			tempOperaterId = operaterId;
		}
		if("".equals(pagesize)){
			pagesize = "15";
		}
	  	result = SignService.getSign(tempOperaterId,beginQueryDate,endQueryDate,Integer.parseInt(pageindex),Integer.parseInt(pagesize),signType);
}
JSONObject jo = JSONObject.fromObject(result);
//System.out.println("######"+jo.toString());
out.println(jo);
%>