<%@page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="net.sf.json.*"%>
<%@page import="weaver.file.*" %>
<%@page import="weaver.general.*" %>
<%@page import="weaver.hrm.*" %>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="java.util.*"%>
<%@page import="weaver.email.service.MailTemplateService"%>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%
    String opt = Util.null2String(request.getParameter("opt"));

    if(opt.isEmpty()) {
        return;
    }
    
    // 获得个人可用模版信息
    if("getTemplList".equals(opt)) {
        JSONArray jArray = new JSONArray();
        MailTemplateService mts = new MailTemplateService();
        mts.selectMailTemplateInfos(user.getUID());
        while(mts.next()){
            JSONObject jObject = new JSONObject();
            jObject.put("templId", mts.getId());
            jObject.put("templName", Util.getMoreStr(mts.getTemplateName(),14,"..."));
            jObject.put("templType", mts.getType());
            jArray.add(jObject);
        }
        out.print(jArray.toString());
        return;
    }
    
    // 查询邮件阅读状态，返回1已读，0或-1未读
    if("isMailReaded".equals(opt)) {
        int result = 0;
        String mailId = Util.null2String(request.getParameter("mailId"));
        if(!mailId.isEmpty()) {
            String sql = "select status from MailResource where id = " + mailId;
            rs.executeQuery(sql);
            if(rs.next()) {
                result = rs.getInt("status");
            }
        }
        out.println(result);
        return;
    }
    
    // 获取前台自动接收配置信息
    if("getMailReceiveConfig".equals(opt)) {
		rs.execute("select outterMail,innerMail,outterMail,autoreceive,timecount from MailConfigureInfo");
		int autoreceive = 0;
		int outterMail = 0;
		int timecount = 1800000; // 30分钟
		while(rs.next()){
			outterMail = Util.getIntValue(Util.null2String(rs.getString("outterMail")), 0);
			autoreceive = Util.getIntValue(Util.null2String(rs.getString("autoreceive")), 0);
			timecount = Util.getIntValue(Util.null2String(rs.getString("timecount")), 1800000);
		}
        JSONObject result = new JSONObject();
        result.put("autoreceive", autoreceive);
        result.put("outterMail", outterMail);
        result.put("timecount", timecount);
        
        out.println(result);
        return;
    }
%>