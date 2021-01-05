
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.hrm.attendance.manager.*" %>
<%@ page import="weaver.hrm.attendance.domain.*" %>
<%@ page import="weaver.hrm.attendance.domain.HrmScheduleSign.*" %>
<%@ page import="weaver.hrm.report.schedulediff.*" %>




<jsp:useBean id="ps" class="weaver.mobile.plugin.ecology.service.PluginServiceImpl" scope="page" />
<%
response.setContentType("application/json;charset=UTF-8");

Map result = new HashMap();
User user = HrmUserVarify.getUser(request, response);
if(user==null) {
	//未登录或登录超时
	result.put("error", "005");
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
	return;
}
FileUpload fu = new FileUpload(request);
String type = Util.null2String(fu.getParameter("type"));//"checkin":签到,"checkout":签退
String ipaddr = Util.null2String(fu.getParameter("ipaddr"));//ip地址,eg:192.168.1.5
String latlng = Util.null2String(fu.getParameter("latlng"));//经纬度,eg:31.253313,121.241581
String addr = Util.null2String(fu.getParameter("addr"));//经纬度对应地址
boolean inCom = "1".equals(fu.getParameter("inCompany"));//是否在公司
//int signType = bean.getSignType();
//List<String> signTimes = bean.getSignTimes();
if(type.equals("getStatus")){
	HrmScheduleSignManager signManager = new HrmScheduleSignManager();
	HrmScheduleSign bean = signManager.getSignData(user.getUID());//传递用户ID
	List<ScheduleSignButton> signButtons =  bean.getSignButtons(); 
	List<ScheduleSignButton> currentButtons = bean.getCurrentSignButtons();	
	//如果是排班人员、工作日、还有允许非工作日签到，提供考勤按钮
	if(bean.isSchedulePerson() || bean.isWorkDay()||!bean.getSignSet().isOnlyWorkday()){
		
		Map list = new HashMap();
		for(int i=0;i<currentButtons.size();i++){
			ScheduleSignButton ssb = currentButtons.get(i);
			list.put(ssb.getTime(),ssb.getTime());
		}
		for(int i=0;i<signButtons.size();i++){
		    ScheduleSignButton ssb = signButtons.get(i);
		    boolean isSign = ssb.isSign();
		    if(list.get(ssb.getTime())!=null){ //当前签到签退组
		    		if(ssb.getType().endsWith("On")){//签到
						if(!isSign){ //未签到
							ssb.setIsEnable("true");
							break;
						}
					}
					if(ssb.getType().endsWith("Off")){//签退
						ScheduleSignButton ssbam = signButtons.get(i-1);
						boolean isOnSign = ssbam.isSign();
						if(isOnSign){//已签到即显示签退按钮，支持多次签退
							ssb.setIsEnable("true");
							break;
						}
					}
			}
		}
	}
		
	result.put("signbtns", signButtons);
}else{
    result = ps.checkIn(user, type, ipaddr, latlng, addr, inCom);
}

if(result!=null) {
	JSONObject jo = JSONObject.fromObject(result);

	out.println(jo);
}
%>
