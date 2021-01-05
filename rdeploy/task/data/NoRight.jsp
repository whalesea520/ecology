<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<%
	String taskId = Util.null2String(request.getParameter("taskId"));
	rs.executeSql("select principalid,creater from TM_TaskInfo where id="+taskId+" and (deleted=0 or deleted is null)");
	//if(rs.getCounts()==0) return;
	String principalid = "";
	String creater = "";
	boolean ifExits = false;
	if(rs.next()){
		principalid = Util.null2String(rs.getString("principalid"));
		creater = Util.null2String(rs.getString("creater"));
		ifExits = true;
	}
	
%>
<style type="text/css">
	#rightinfo a,#rightinfo a:active,#rightinfo a:visited{text-decoration: none;color: #000000;}
	#rightinfo a:hover{text-decoration: underline;color: #0080FF;}
	.warnning{
		padding-left:20px;
		background: #8d9598;
		color:#fff;
		height:34px;
		line-height:34px;
	}
	.warnimg{
		margin-top:7px;
		height:34px;
		width:34px;
		float:left;
	}
	.lock{
		margin:35px auto;
		text-align:center;
	}
</STYLE>
<div id="rightinfo" style="width: 100%;height: 100%;position: relative;overflow: hidden;">
	<div style="position:absolute;top:0px;left:0px;width:100%;height:34px;">
		<div class="warnning">
		<div class="warnimg"><img src="../img/warn.png" width="18"/></div>
		<div style="float:left;">无权限</div></div>
	</div>
	<div id="maininfo" style="width:100%;height: auto;position:absolute;top:30px;left:0px;bottom:0px;
		line-height: 40px;font-size: 14px;" class="scroll1" align="center">
		<div class="lock"><img src="../img/lock.png" width="70"/></div>
		<div>
		<%if(ifExits){ %>
			很抱歉，您暂时没有权限查看此任务！<br>
			可联系任务创建人：<%=cmutil.getPerson(creater) %>
			<%if(!principalid.equals("") && !principalid.equals(creater)){ %>
			或任务负责人：<%=cmutil.getPerson(principalid) %>
			<%} %>进行分享！
		<%}else{ %>
			很抱歉，您查看的任务不存在或已经被删除！
		<%} %>
		</div>
	</div>
</div>

