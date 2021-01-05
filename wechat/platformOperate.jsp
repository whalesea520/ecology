
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.wechat.cache.*"%>
<%@page import="weaver.wechat.bean.*"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%
	String operate=request.getParameter("operate");
	User user = HrmUserVarify.getUser(request, response);
	if("state".equals(operate)){//禁用,启用
		String state=request.getParameter("state");
		String id=request.getParameter("id");
		if("0".equals(state)){//启用公众平台
			//判断账号等是否正常
			WeChatBean wc=PlatFormCache.getWeChatBeanById(id);
			if(PlatFormCache.refreshToken(wc)){//令牌更新成功
				String temStr = "update wechat_platform set state='0' where id = "+id;
				SysMaintenanceLog.resetParameter();
				SysMaintenanceLog.insSysLogInfo(user,Util.getIntValue(id),"启用微信公众号","微信公众平台管理-启用公众平台","214","26",0,Util.getIpAddr(request));
				if(rs.executeSql(temStr)){
					out.print(true);
				}else{
					out.print(false);
				}
			}else{
				wc=PlatFormCache.getWeChatBeanById(id);
				out.print(wc.getDesc());
			}
		}else{
			String temStr = "update wechat_platform set state='1' where id = "+id;
			if(rs.executeSql(temStr)){
				SysMaintenanceLog.resetParameter();
				SysMaintenanceLog.insSysLogInfo(user,Util.getIntValue(id),"禁用微信公众号","微信公众平台管理-禁用公众平台","214","25",0,Util.getIpAddr(request));
				
				out.print(true);
			}else{
				out.print(false);
			}
		}
	}else if("delReceiveEvent".equals(operate)){
		String temStr = "delete wechat_receive_event";
		if(rs.executeSql(temStr)){
			out.print(true);
		}else{
			out.print(false);
		}
	} 
%>
