<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<%
	String taskId = Util.null2String(request.getParameter("taskId"));
	int right = cmutil.getGoalRight(taskId,user);
	if(right>0){
		response.sendRedirect("DetailView.jsp?taskId="+taskId);
		return;
	}
	rs.executeSql("select id,principalid,creater from GM_GoalInfo where id="+taskId+" and (deleted=0 or deleted is null)");
	if(rs.getCounts()==0) return;
	rs.next();
	String principalid = Util.null2String(rs.getString("principalid"));
	String creater = Util.null2String(rs.getString("creater"));
%>
<style type="text/css">
	#rightinfo a,#rightinfo a:active,#rightinfo a:visited{text-decoration: none;color: #000000;}
	#rightinfo a:hover{text-decoration: underline;color: #0080FF;}
</STYLE>
<div id="rightinfo" style="width: 100%;height: 100%;position: relative;overflow: hidden;">
	<div style="width: 100%;height: 30px;background: #F2F2F2;position: relative;
	background:-webkit-gradient(linear, 0 0, 0 bottom, from(#F2F2F2), to(#F6F6F6)) !important;
    	background:-moz-linear-gradient(#F2F2F2, #D7D7D7) !important;
    	-pie-background:linear-gradient(#F2F2F2, #D7D7D7) !important;">
		<div style="position: absolute;top: 3px;left:0px;height: 23px;width: 100%;">
			<div style="margin-left: 10px;font-weight: bold;width: 65px;background: url('../images/warn.png') left center no-repeat;text-align: center;">
				提示</div>
		</div>
	</div>
	<div id="maininfo" style="width:100%;height: auto;position:absolute;top:30px;left:0px;bottom:0px;
		line-height: 40px;font-size: 14px;" class="scroll1" align="center">
		很抱歉，您暂时没有权限查看此目标！<br>
		可联系目标创建人：<%=cmutil.getPerson(creater) %>
		<%if(!principalid.equals("") && !principalid.equals(creater)){ %>
		或目标负责人：<%=cmutil.getPerson(principalid) %>
		<%} %>进行分享！
	</div>
</div>

