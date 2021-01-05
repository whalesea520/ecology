<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.formmode.excel.ImpExcelServer"%>
<%@page import="java.util.Map"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.general.Util"%>
<%@page import="java.util.Date"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>

<%
out.clear();
request.setCharacterEncoding("UTF-8");
User user = HrmUserVarify.getUser(request,response);
String action = Util.null2String(request.getParameter("action"));
int modeid = Util.getIntValue(request.getParameter("modeid"),0);
String tempkey = Util.null2String(request.getParameter("tempkey"));
String key = user.getUID()+"_"+modeid+"_"+tempkey;
JSONObject jsonObject = new JSONObject();
if("getImpStatus".equals(action)){
	Map map = ImpExcelServer.progressMap;
	if(map.containsKey("msg_"+key)){
		int step = 0;
		int s = 1;
		String msg = Util.null2String(map.get("msg_"+key));
		String status = Util.null2String(map.get("status_"+key));
		step = Util.getIntValue(Util.null2String(map.get("step_"+key)));
		if(map.containsKey("starttime_"+key)&&map.containsKey("endtime_"+key)){
			long starttime = Long.parseLong(Util.null2String(map.get("starttime_"+key)));
			long endtime= Long.parseLong(Util.null2String(map.get("endtime_"+key)));
			if(starttime>endtime){//还未结束
				ImpExcelServer.progressMap.put("status_"+key, "0");
				if(step==6){
					step = 0;
					msg = "";
					s = 0;
					ImpExcelServer.progressMap.put("step_"+key, "0");
				}
				map = ImpExcelServer.progressMap;
			}
		}
		String errmsg = "";
		String time = "";
		if(status.equals("-1")){
			errmsg = Util.null2String(map.get("errmsg_"+key));
			time = Util.null2String(map.get("time_"+key));
			if(!StringHelper.isEmpty(errmsg)){
				errmsg = errmsg.replace("\\n","<br />");
			}
		}
		jsonObject.put("s",s);
		jsonObject.put("msg",msg);
		jsonObject.put("status",status);
		jsonObject.put("errmsg",errmsg);
		jsonObject.put("time",time);
		jsonObject.put("step",step);
	}else{
		jsonObject.put("s",0);
	}
}else if("getTime".equals(action)){
	long now = new Date().getTime();
	Map map = ImpExcelServer.progressMap;
	int isimport = 0;
	if(map.containsKey("starttime_"+key)&&map.containsKey("endtime_"+key)){
		long starttime = Long.parseLong(Util.null2String(map.get("starttime_"+key)));
		long endtime= Long.parseLong(Util.null2String(map.get("endtime_"+key)));
		if(starttime>endtime){//正在导入
			isimport = 1;
		}
	}
	if(isimport==0){
		ImpExcelServer.progressMap.put("starttime_"+key, now+"");
	}
	jsonObject.put("t",new Date().getTime()+"");
	jsonObject.put("isimport",isimport+"");
}
response.getWriter().write(jsonObject.toString());
%>

