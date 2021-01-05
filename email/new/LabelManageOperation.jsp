<%@page import="org.apache.commons.lang.time.DateUtils"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>

<%@ page language="java" contentType="text/html; charset=utf-8" %> 
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="lms" class="weaver.email.service.LabelManagerService" scope="page" />
	<jsp:useBean id="mrs" class="weaver.email.service.MailResourceService" scope="page" />

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
	
	
	String labelname = Util.null2String(request.getParameter("labelname"));
	String labelcolor = Util.null2String(request.getParameter("labelcolor"));
	String labelid = Util.null2String(request.getParameter("labelid"));
	String method = Util.null2String(request.getParameter("method"));
	String mailsId = Util.null2String(request.getParameter("mailsId"));
	if(method.equals("add")){
		boolean flag = lms.checkRepeatName(user.getUID(),labelname);
		if(!flag){
			lms.createLabel(user.getUID(),labelname,labelcolor);
		}else{
			out.clearBuffer();
			out.print("repeat");
		}
	}else if(method.equals("edit")){
		boolean flag = lms.checkRepeatName(user.getUID(),labelname,labelid);
		if(!flag){
			lms.updateLabel(user.getUID(),labelid,labelname,labelcolor);
		}else{
			out.clearBuffer();
			out.print("repeat");
		}
		
	}else if(method.equals("del")){
		lms.delLabel(user.getUID(),labelid);
	}else if(method.equals("clear")){
		int tempLabelId = Util.getIntValue(labelid, -1);
		mrs.removeLable(tempLabelId);
	}else if(method.equals("LabelCreate")){
		boolean flag = lms.checkRepeatName(user.getUID(),labelname);
		String newlabid="";
		if(!flag){
				//创建新的标签，并且得到该标签的id
					if(rs.execute("insert into email_label (accountid,name,color,createdate,createtime) values ('"
					+ user.getUID()
					+ "','"
					+ labelname
					+ "','"
					+ labelcolor
					+ "','"
					+ TimeUtil.getCurrentDateString()
					+ "','"
					+ TimeUtil.getOnlyCurrentTimeString() + "')")){
						if(rs.execute("select MAX(id) m from email_label ")&&rs.next()){
								newlabid=rs.getString("m");
						}
					}
					//绑定改标签的id到邮件
					//mailsId
					if(!"".equals(mailsId)&&!"".equals(newlabid)){
							String szmailsid[]=mailsId.split(",");
							for(int i=0;i<szmailsid.length;i++){
								if(!"".equals(szmailsid[i])){
									rs.execute("insert into email_label_detail(mailid,labelid)values('"+szmailsid[i]+"','"+newlabid+"')");
								}
							}
					}
		}else{
				out.clearBuffer();
				out.print("repeat");
		}
		
	}
%>