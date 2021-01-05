<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ page import="weaver.general.*"%>
<%@page import="weaver.file.FileUpload"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
	try{
		request.setCharacterEncoding("UTF-8");
		FileUpload fu = new FileUpload(request);
		String userid = Util.null2String(fu.getParameter("userid"));
		int type = Util.getIntValue(fu.getParameter("type"),1);
		if(!userid.equals("")){
			ResourceComInfo rc = new ResourceComInfo();
			rc.setTofirstRow();
			boolean ifSub = false;//当前人员是否有下属
	        while (rc.next()) {
				String supId = rc.getManagerID();
				if(supId.equals(userid) && !rc.getResourceid().equals(userid) && 
				(rc.getStatus().equals("0")||rc.getStatus().equals("1")||
				rc.getStatus().equals("2")||rc.getStatus().equals("3"))){
					ifSub = true;
					String hrmId = rc.getResourceid();
					String hrmName = rc.getLastname();			
					boolean ifHasSub = isHavaHrmChildren(hrmId);
%>
	<%if(type==2){//第二次点击下属 %>
		<tr class="subTr_<%=userid%> subTr"><td colspan="2">
	<%} %>
	<div class="listitem2">
		<table class="listTable" cellpadding="0" cellspacing="0">
			<tr id="listTr_<%=hrmId%>">
				<td><div class="hrmName" userid="<%=hrmId%>"><%=hrmName %></div></td>
				<td width="60" style="padding-left:0px !important;">
					<%if(ifHasSub){ %>
						<div class="subClick" ifShow="0" userid="<%=hrmId %>"></div>
					<%}else{ %>
						<div class="noneSubClick"></div>
					<%} %>
				</td>
			</tr>
		</table>
	</div>
	<%if(type==2){//第二次点击下属 %>
		</td></tr>
	<%} %>
<%					
				}
			}
			if(!ifSub){
				out.print("<div class='taskTips'><a href='/mobile/plugin/task/taskMain.jsp'>您还没有下属，点击这里返回</a></div>");
			}
		}else{
			out.print("<div class='taskTips'>没有获取到用户信息</div>");
		}
	}catch(Exception e){
		out.print("<div class='taskTips'>数据加载失败,请稍后再试</div>");
	}
%>

<%!public boolean isHavaHrmChildren(String hrmId){
		boolean havaSubHrmChildren=false;
		try{
			ResourceComInfo rc = new ResourceComInfo();
			rc.setTofirstRow();
			while (rc.next()) {
				String managerid = rc.getManagerID();
				if (managerid.equals(hrmId) && !rc.getResourceid().equals(hrmId)
						&& (rc.getStatus().equals("0")||rc.getStatus().equals("1")||
						rc.getStatus().equals("2")||rc.getStatus().equals("3"))){
					havaSubHrmChildren=true;
					break;
				}		
			}
		}catch(Exception e){
			
		}
		return havaSubHrmChildren;
}
%>