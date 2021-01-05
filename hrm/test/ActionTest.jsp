<%@page import="java.text.DecimalFormat"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="ActionXML" class="weaver.servicefiles.ActionXML" scope="page" />
<%@ page import="weaver.systeminfo.label.LabelComInfo"%><%

String cversion = "";
rs.executeSql("select * from license");
if(rs.next()){
	cversion = Util.null2String(rs.getString("cversion")).trim();
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";//通用设置
String needfav ="1";
String needhelp ="";
BaseBean bb = new BaseBean();

%>
	<wea:layout type="2col">
	    <wea:group context='检查Action相关全局设置' attributes="{'itemAreaDisplay':'display'}">
	    
			<wea:item>人力资源相关ACTION注册情况</wea:item>
			<wea:item>
				<%
				ArrayList pointArrayList = ActionXML.getPointArrayList();
				boolean hasDeduction = !pointArrayList.contains("deduction");
				boolean hasFreeze = !pointArrayList.contains("freeze");
				boolean hasRelease = !pointArrayList.contains("release");
				boolean hasHrmPaidLeaveAction = false;
				if(cversion.compareTo("8.100.0531+KB81001603") >= 0){
					hasHrmPaidLeaveAction = !pointArrayList.contains("HrmPaidLeaveAction");
				}
				boolean hasHrmScheduleShift = false;
				if(cversion.compareTo("8.100.0531+KB81001601") >= 0){
					hasHrmScheduleShift = !pointArrayList.contains("HrmScheduleShift");
				}
				boolean hasHrmResourceDismiss = !pointArrayList.contains("HrmResourceDismiss");
				boolean hasHrmResourceEntrant = !pointArrayList.contains("HrmResourceEntrant");
				boolean hasHrmResourceTry = !pointArrayList.contains("HrmResourceTry");
				boolean hasHrmResourceHire = !pointArrayList.contains("HrmResourceHire");
				boolean hasHrmResourceExtend = !pointArrayList.contains("HrmResourceExtend");
				boolean hasHrmResourceRedeploy = !pointArrayList.contains("HrmResourceRedeploy");
				boolean hasHrmResourceRetire = !pointArrayList.contains("HrmResourceRetire");
				boolean hasHrmResourceFire = !pointArrayList.contains("HrmResourceFire");
				boolean hasHrmResourceReHire = !pointArrayList.contains("HrmResourceReHire");
				
				if(hasDeduction || hasFreeze || hasRelease 
						|| hasHrmPaidLeaveAction || hasHrmScheduleShift || hasHrmResourceDismiss 
						|| hasHrmResourceEntrant || hasHrmResourceTry 
						|| hasHrmResourceHire || hasHrmResourceExtend || hasHrmResourceRedeploy 
						|| hasHrmResourceRetire || hasHrmResourceFire || hasHrmResourceReHire ){
				%>
					<img src="rejected_bg_wev8.gif"  /><span style="color:red;" >ACTION注册不全</span>
					<img src="refresh.png"  title="调整设置" style="cursor: pointer;" onclick="goNew('/integration/icontent.jsp?showtype=10')" />
					<%
				}
				
				%>
				<div class="noteinfo">
				<%
				
				boolean allTrue = true;
				if(hasDeduction){
					allTrue = false;
					%><br />
					<font >请如下配置action：请假流程扣减action<img src="remind_wev8.png" title="针对自定义请假流程进行配置，推荐配置在归档节点前附加操作" /><br /></font>
					接口动作名称：deduction<br />
					接口动作标识：deduction<br />
					接口动作类文件：weaver.hrm.attendance.action.HrmDeductionVacationAction<br />
					<%
				}
				if(hasFreeze){
					allTrue = false;
					%><br />
					<font >请如下配置action：请假流程冻结action<img src="remind_wev8.png" title="针对自定义请假流程进行配置，推荐配置在发起节点后附加操作" /><br /></font>
					接口动作名称：freeze<br />
					接口动作标识：freeze<br />
					接口动作类文件：weaver.hrm.attendance.action.HrmFreezeVacationAction<br />
					<%
				}
				if(hasRelease){
					allTrue = false;
					%><br />
					<font >请如下配置action：请假流程释放action<img src="remind_wev8.png" title="针对自定义请假流程进行配置，推荐配置在发起节点前附加操作" /><br /></font>
					接口动作名称：release<br />
					接口动作标识：release<br />
					接口动作类文件：weaver.hrm.attendance.action.HrmReleaseVacationAction<br />
					<%
				}
				if(cversion.compareTo("8.100.0531+KB81001603") >= 0){
					if(hasHrmPaidLeaveAction){
						allTrue = false;
						%><br />
						<font >请如下配置action：加班流程生成调休action<img src="remind_wev8.png" title="针对自定义加班流程进行配置，推荐配置在归档节点前附加操作" /><br /></font>
						接口动作名称：HrmPaidLeaveAction<br />
						接口动作标识：HrmPaidLeaveAction<br />
						接口动作类文件：weaver.hrm.attendance.action.HrmPaidLeaveAction<br />
						<%
					}
				}
				if(cversion.compareTo("8.100.0531+KB81001601") >= 0){
					if(hasHrmScheduleShift){
						allTrue = false;
						%><br />
						<font >请如下配置action：排班人员调班流程action<img src="remind_wev8.png" title="推荐配置在归档节点前附加操作" /><br /></font>
						接口动作名称：HrmScheduleShift<br />
						接口动作标识：HrmScheduleShift<br />
						接口动作类文件：weaver.hrm.schedule.action.HrmScheduleShiftAction<br />
						<%
					}
				}
				if(hasHrmResourceDismiss){
					allTrue = false;
					%><br />
					<font >请如下配置action：状态变更流程离职action<img src="remind_wev8.png" title="推荐配置在归档节点前附加操作" /><br /></font>
					接口动作名称：HrmResourceDismiss<br />
					接口动作标识：HrmResourceDismiss<br />
					接口动作类文件：weaver.hrm.pm.action.HrmResourceDismissAction<br />
					<%
				}
				if(hasHrmResourceEntrant){
					allTrue = false;
					%><br />
					<font >请如下配置action：状态变更流程入职action<img src="remind_wev8.png" title="推荐配置在归档节点前附加操作" /><br /></font>
					接口动作名称：HrmResourceEntrant<br />
					接口动作标识：HrmResourceEntrant<br />
					接口动作类文件：weaver.hrm.pm.action.HrmResourceEntrantAction<br />
					<%
				}
				if(hasHrmResourceTry){
					allTrue = false;
					%><br />
					<font >请如下配置action：状态变更流程试用action<img src="remind_wev8.png" title="推荐配置在归档节点前附加操作" /><br /></font>
					接口动作名称：HrmResourceTry<br />
					接口动作标识：HrmResourceTry<br />
					接口动作类文件：weaver.hrm.pm.action.HrmResourceTryAction<br />
					<%
				}
				if(hasHrmResourceHire){
					allTrue = false;
					%><br />
					<font >请如下配置action：状态变更流程转正action<img src="remind_wev8.png" title="推荐配置在归档节点前附加操作" /><br /></font>
					接口动作名称：HrmResourceHire<br />
					接口动作标识：HrmResourceHire<br />
					接口动作类文件：weaver.hrm.pm.action.HrmResourceHire<br />
					<%
				}
				if(hasHrmResourceExtend){
					allTrue = false;
					%><br />
					<font >请如下配置action：状态变更流程续签action<img src="remind_wev8.png" title="推荐配置在归档节点前附加操作" /><br /></font>
					接口动作名称：HrmResourceExtend<br />
					接口动作标识：HrmResourceExtend<br />
					接口动作类文件：weaver.hrm.pm.action.HrmResourceExtend<br />
					<%
				}
				if(hasHrmResourceRedeploy){
					allTrue = false;
					%><br />
					<font >请如下配置action：状态变更流程调动action<img src="remind_wev8.png" title="推荐配置在归档节点前附加操作" /><br /></font>
					接口动作名称：HrmResourceRedeploy<br />
					接口动作标识：HrmResourceRedeploy<br />
					接口动作类文件：weaver.hrm.pm.action.HrmResourceRedeploy<br />
					<%
				}
				if(hasHrmResourceRetire){
					allTrue = false;
					%><br />
					<font >请如下配置action：状态变更流程退休action<img src="remind_wev8.png" title="推荐配置在归档节点前附加操作" /><br /></font>
					接口动作名称：HrmResourceRetire<br />
					接口动作标识：HrmResourceRetire<br />
					接口动作类文件：weaver.hrm.pm.action.HrmResourceRetire<br />
					<%
				}
				if(hasHrmResourceFire){
					allTrue = false;
					%><br />
					<font >请如下配置action：状态变更流程解聘action<img src="remind_wev8.png" title="推荐配置在归档节点前附加操作" /><br /></font>
					接口动作名称：HrmResourceFire<br />
					接口动作标识：HrmResourceFire<br />
					接口动作类文件：weaver.hrm.pm.action.HrmResourceFire<br />
					<%
				}
				if(hasHrmResourceReHire){
					allTrue = false;
					%><br />
					<font >请如下配置action：状态变更流程返聘action<img src="remind_wev8.png" title="推荐配置在归档节点前附加操作" /><br /></font>
					接口动作名称：HrmResourceReHire<br />
					接口动作标识：HrmResourceReHire<br />
					接口动作类文件：weaver.hrm.pm.action.HrmResourceReHire<br />
					<%
				}
			
			%></div>
			<%	
				if(allTrue){
					%>
					<img src="ok.png"  />ACTION注册正常
					<%
				}
%>
			</wea:item>
	    </wea:group>
	    
	</wea:layout>