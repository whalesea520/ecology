<%@page import="weaver.conn.RecordSet"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@page import="weaver.hrm.User"%>
<%@page import="java.io.IOException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.*"%>
<%@page import="net.sf.json.JSONObject"%>
<%
User user = MobileUserInit.getUser(request, response);
if(user == null){
	out.print("{\"status\":\"0\", \"errMsg\":\"用户失效,请请重新登录\"}");
	return;
}
String userid = String.valueOf(user.getUID());
String action = Util.null2String(request.getParameter("action"));
if("saveSellChance".equals(action)){
	JSONObject resultObj = new JSONObject();
	try {
		RecordSet rs = new RecordSet();
		String subject = Util.null2String(request.getParameter("subject"));//商机名称
		String selltypesid = Util.null2String(request.getParameter("selltypesid"));	//商机类型
		String customerid = Util.null2String(request.getParameter("customerid"));//客户id
		String predate = Util.null2String(request.getParameter("predate"));//销售预期
		String preyield = Util.null2String(request.getParameter("preyield"));//预期收益
		String sellstatusid = Util.null2String(request.getParameter("sellstatusid"));//商机状态
		String probability = Util.null2String(request.getParameter("probability"));//可能性
		//String comefromid = Util.null2String(request.getParameter("comefromid"));//商机来源
		String sufactor = Util.null2String(request.getParameter("sufactor"));//成功因素
		if(!"".equals(customerid)){
			String fields = "subject,selltypesid,customerid,creater,endtatusid";//comefromid,
			String values = "'"+subject+"','"+selltypesid+"','"+customerid+"',"+userid+",0";//'"+comefromid+"',
			if(!"".equals(predate)){
				fields+=",predate";
				values+=",'"+predate+"'";
			}
			if(!"".equals(preyield)){
				fields+=",preyield";
				values+=","+preyield;
			}	
			if(!"".equals(sellstatusid)){
				fields+=",sellstatusid";
				values+=","+sellstatusid;
			}
			if(!"".equals(probability)){
				fields+=",probability";
				values+=","+probability;
			}
			if(!"".equals(sufactor)){
				fields+=",sufactor";
				values+=","+sufactor;
			}
			String sql = "insert into CRM_SellChance ("+fields+") values("+values+")";
			rs.executeSql(sql);
			resultObj.put("status", "1");
		}else{
			resultObj.put("status", "0");
			resultObj.put("errMsg", "无客户信息！");
		}
	}catch(Exception ex) {
		ex.printStackTrace();
		resultObj.put("status", "0");
		resultObj.put("errMsg", ex.getMessage());
	}finally{
		try{
			out.print(resultObj.toString());
			out.flush();
		}catch(IOException ex){
			ex.printStackTrace();
		}
	}	
}
%>
