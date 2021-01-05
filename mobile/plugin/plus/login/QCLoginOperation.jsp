<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="java.lang.reflect.Method" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.wxinterface.InterfaceUtil" %>
<jsp:useBean id="qrCode" class="weaver.wxinterface.WxQRCodeComInfo" scope="page"/>
<%
/*用户验证*/
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
	response.getWriter().write("0");
    return;
}
String loginkey = request.getParameter("loginkey");
String checkUserid = request.getParameter("userid");//微信传过来的外部系统用户唯一标识 
if(!checkUserid.equals(user.getUID()+"")){
	new BaseBean().writeLog("传入的用户数据库ID:"+checkUserid
			+",扫码登录OA系统发生账号不匹配,通过sessionkey得到的用户为,数据库ID:"+user.getUID()+",登录账号:"+user.getLoginid()
			+",姓名："+user.getLastname()+",二维码key为："+loginkey);
	response.getWriter().write("0");
	return;
}
String ifNew = request.getParameter("ifNew")==null?"":request.getParameter("ifNew");
if (loginkey != null && !"".equals(loginkey)) {
	try{
		if(ifNew.equals("1")){//扫描的是微信这边开发的二维码界面
			qrCode.insertUserToDb(loginkey, user);//将用户信息放入数据库
		}else{
			//try{
			//	//E8正式系统采用此方式记录用户信息
			//	Class qrcode = Class.forName("weaver.mobile.plugin.ecology.QRCodeComInfo");
			//	Method m = qrcode.getDeclaredMethod("addQRCodeComInfo",String.class,Object.class);
			//	m.invoke(qrcode.newInstance(),loginkey,user);
			//}catch(Exception e){
				
			//}
			try{
				//E8客户使用此方式记录
				Class qrcode = Class.forName("weaver.mobile.plugin.ecology.QRCodeComInfo");
				Method m2 = qrcode.getDeclaredMethod("insertUserToDb",String.class,User.class);
				m2.invoke(qrcode.newInstance(),loginkey,user);
			}catch(Exception e){
				
			}
		}
		application.setAttribute(loginkey, user);//兼容以前版本 防止云桥升级了,但是EC标准没有升级
		response.getWriter().write("1");
	}catch(Exception e){
		response.getWriter().write("0");
	}
} else {
	response.getWriter().write("0");
}
%>
