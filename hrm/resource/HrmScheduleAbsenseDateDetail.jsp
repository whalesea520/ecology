<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.attendance.domain.HrmMFScheduleDiff"%>
<%@page import="weaver.hrm.User"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="strUtil" class="weaver.common.StringUtil" scope="page" />
<jsp:useBean id="diffUtil" class="weaver.hrm.report.schedulediff.HrmScheduleDiffUtil" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="monthAttManager" class="weaver.hrm.attendance.manager.HrmScheduleDiffMonthAttManager" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%
	String curDate = strUtil.vString(request.getParameter("curDate"));
	List sList = new ArrayList();
	List fList = new ArrayList();
	boolean showFList =  false;
	Map map = null;
	if(!curDate.equals("")){

		String resourceId = strUtil.vString(request.getParameter("resourceId"));
		User tmpUsers = User.getUser(strUtil.parseToInt(resourceId),0);
		diffUtil.setUser(tmpUsers);
		monthAttManager.setUser(tmpUsers);
		int subCompanyId = strUtil.parseToInt(resourceComInfo.getSubCompanyID(resourceId));
		Map timeMap = diffUtil.getOnDutyAndOffDutyTimeMap(curDate, subCompanyId);
		
		HrmMFScheduleDiff diffBean = new HrmMFScheduleDiff();
		diffBean.setCurrentDate(curDate);
		diffBean.setResourceId(resourceId);
		diffBean.setSubCompanyId(subCompanyId);
		diffBean.setOffDutyTimeAM(strUtil.vString(timeMap.get("offDutyTimeAM")));
		diffBean.setOffDutyTimePM(strUtil.vString(timeMap.get("offDutyTimePM")));
		diffBean.setOnDutyTimeAM(strUtil.vString(timeMap.get("onDutyTimeAM")));
		diffBean.setOnDutyTimePM(strUtil.vString(timeMap.get("onDutyTimePM")));
		diffBean.setSignStartTime(strUtil.vString(timeMap.get("signStartTime")));
		diffBean.setSignType(strUtil.vString(timeMap.get("signType"), "1"));
		diffBean.setFlag(true);
		monthAttManager.setResourceAbsense(true);
		sList = monthAttManager.getScheduleList(curDate, resourceId, diffBean);
		fList = monthAttManager.getScheduleList(curDate, curDate, resourceId);
		showFList = fList!=null && fList.size() > 0;
	}
%>
	<wea:layout type="table" attributes="{'cols':'6','cws':'18%,15%,12%,18%,15%,15%','formTableId':'oTable4op'}">
		<wea:group context='<%=SystemEnv.getHtmlLabelNames("15880,17463",user.getLanguage())%>' attributes="{'samePair':'hrmStatus','groupDisplay':''}">
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></wea:item>
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></wea:item>
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(125799,user.getLanguage())%></wea:item>
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(20035,user.getLanguage())%></wea:item>
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(20039,user.getLanguage())%></wea:item>
			<%
				if(sList.size() > 0){
					for(int i=0; i<sList.size(); i++){
						map = (Map)sList.get(i);
			%>
			<wea:item>
											<%=strUtil.vString(map.get("departmentName"))%>
			</wea:item>
			<wea:item>
											<%=strUtil.vString(map.get("resourceName"))%>
			</wea:item>
			<wea:item>
											<%=strUtil.vString(map.get("signDate"))%>
			</wea:item>
			<wea:item>
											<%=strUtil.vString(map.get("scheduleName"))%>
			</wea:item>
			<wea:item>
											<%=strUtil.vString(map.get("signInTime"))%>
			</wea:item>
			<wea:item>
											<%=strUtil.vString(map.get("signOutTime"))%>
			</wea:item>
			<%		
				}
					%>
			<%
				}else{
			%>	
			<wea:item attributes="{'colspan':'full'}"  >
			<span style="width: 100%;display: block;text-align: center;">
			<%=SystemEnv.getHtmlLabelName(382099,user.getLanguage())%>
			</span>
			</wea:item>
<%	}
%>
</wea:group>
	</wea:layout>
	
<%if(showFList){
%>
	<wea:layout type="table" attributes="{'cols':'5','cws':'20%,20%,20%,15%,25%','formTableId':'fTable4op'}">
		<wea:group context='<%=SystemEnv.getHtmlLabelNames("15880,18015",user.getLanguage())%>' attributes="{'samePair':'flowStatus','groupDisplay':''}">
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(16070,user.getLanguage())%></wea:item>
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></wea:item>
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></wea:item>
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelNames("21551,81913,1925,81914",user.getLanguage())%></wea:item>
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></wea:item>
			<%
			for(int i=0; i<fList.size(); i++){
				map = (Map)fList.get(i);
				String tmpType = strUtil.vString(map.get("dType"));
				String oneDayInfo = "";
				boolean hasOneDayInfo = false;
				if(SystemEnv.getHtmlLabelName(6151, user.getLanguage()).equals(tmpType)){
					oneDayInfo = strUtil.vString(map.get("oneDayHour"))+SystemEnv.getHtmlLabelName(391,user.getLanguage())+"/"+SystemEnv.getHtmlLabelName(1925,user.getLanguage());
					hasOneDayInfo = true;
				}
			%>
			<wea:item>
									<%=strUtil.vString(map.get("dType"))%>
			</wea:item>
			<wea:item>
									<%=strUtil.vString(map.get("startTime"))%>
			</wea:item>
			<wea:item>
									<%=strUtil.vString(map.get("endTime"))%>
			</wea:item>
			<wea:item>
									<%=strUtil.vString(map.get("days"))%>
									<%
									if(hasOneDayInfo){
									%>
									<img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=oneDayInfo%>" />
									<%
									}
									 %>
			</wea:item>
			<wea:item>
									<%=strUtil.vString(map.get("reqLinkName"))%>
			</wea:item>
			<%	
			}
			%>
</wea:group>
	</wea:layout>
<%}%>
