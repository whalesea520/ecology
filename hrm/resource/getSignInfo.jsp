<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.common.DateUtil"%> 
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.hrm.attendance.manager.*" %>
<%@ page import="weaver.hrm.attendance.domain.*" %>
<%@ page import="weaver.hrm.attendance.domain.HrmScheduleSign.*" %>
<%@ page import="weaver.hrm.report.schedulediff.*" %>
<%@	page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="net.sf.json.*,java.text.*" %>
<%!
public String getWeekOfDate(Date dt,int languageid) {
  int[] weekDays = {398, 392, 393, 394, 395, 396, 397};
  Calendar cal = Calendar.getInstance();
  cal.setTime(dt);
  int w = cal.get(Calendar.DAY_OF_WEEK) - 1;
  if (w < 0)
      w = 0;
  return SystemEnv.getHtmlLabelName(weekDays[w],languageid);
}
%>
<%
	out.clear();
	User user = HrmUserVarify.getUser(request,response);
	String[] signInfo = HrmScheduleDiffUtil.getSignInfo(user);
	String isNeedSign = signInfo[0];
	String signType = signInfo[2];
	String type = Util.null2String(request.getParameter("type"));
	if(type.equals("ischeck")){
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("isNeedSign",isNeedSign);
		jsonObj.put("signType",signType);
		out.println(jsonObj.toString());
		return;
	}
	String FORMAT_DATE = "MM-dd";
	if(user.getLanguage()==7){
		FORMAT_DATE = "MM月dd日";
	}
	String currentDate = DateUtil.getCurrentDate();
	String currentFullTime = DateUtil.getFullDate();
	SimpleDateFormat df = new SimpleDateFormat(FORMAT_DATE);
	HrmScheduleSignManager signManager = new HrmScheduleSignManager();
	HrmScheduleSign bean = signManager.getSignData(user.getUID());//传递用户ID
	List<ScheduleSignButton> signButtons = bean.getSignButtons();	
	List<ScheduleSignButton> currentButtons = bean.getCurrentSignButtons();	
	//如果开启非工作日考勤，非工作日提供一个默认考勤按钮
	if(bean.isSchedulePerson()){
		Map list = new HashMap();
		for(int i=0;i<currentButtons.size();i++){
			ScheduleSignButton ssb = currentButtons.get(i);
			list.put(ssb.getTime(),ssb.getTime());
		}
		for(int i=0;i<signButtons.size();i++){
		    ScheduleSignButton ssb = signButtons.get(i);
		    boolean isSign = ssb.isSign();
		    if(list.get(ssb.getTime())!=null){ //当前签到签退组
		    		if(ssb.getType().endsWith("On")){//签到
						if(!isSign){ //未签到
							ssb.setIsEnable("true");
							break;
						}
					}
					if(ssb.getType().endsWith("Off")){//签退
						ScheduleSignButton ssbam = signButtons.get(i-1);
						boolean isOnSign = ssbam.isSign();
						if(isOnSign){//已签到即显示签退按钮，支持多次签退
							ssb.setIsEnable("true");
							break;
						}
					}
			}
		}
	}else{
		if(bean.isWorkDay()||!bean.getSignSet().isOnlyWorkday()){
			//工作日或者允许非工作日考勤，提供一个默认签到签退按钮
			for(int i=0;i<signButtons.size();i++){
		    	ScheduleSignButton ssb = signButtons.get(i);
		   		boolean isSign = ssb.isSign();
		    	if(ssb.getType().endsWith("On")){//签到
					if(!isSign) {//未签到
						ssb.setIsEnable("true");
						break;
					}
				}
				if(ssb.getType().endsWith("Off")){//签退
					ScheduleSignButton ssbam = signButtons.get(i-1);
					boolean isOnSign = ssbam.isSign();
					if(isOnSign){//已签到即显示签退按钮，支持多次签退
						ssb.setIsEnable("true");
						break;
					}
				}
			}
		}
	}
%>
		<div id="mainContent" class="mainContent" style="overflow:none;background-color: #fff;border-radius: 4px;">
			<table style="width: 100%" cellpadding="0" cellspacing="0">
				<tr>
				   <td valign="top" width="*" style="max-width: 800px;">
						<div>
							<div class="reportBody" id="reportBody" style="background-color: inherit !important; ">
									<div style="height: 16px"></div>
									<div class="signItem">
										<table width="100%" style="TABLE-LAYOUT: fixed;" cellpadding="0" cellspacing="0" >
											<tbody>
												<tr>
													<td colspan="2" valign="middle" width="30px" nowrap="nowrap">
														<div class="dateArea"></div> 
														<div class="time img001"  style="left: 20px"></div>
														<div class="dateinfo"  style="left: 30px"><%=df.format(DateUtil.getToday()) %><span style="padding-left: 12px;"></span><%=getWeekOfDate(DateUtil.getToday(),user.getLanguage()) %></div>
														<div class="discussline" style="margin-top: 41px;"></div>
													</td>
												</tr>
												<tr>
													<td colspan="2" height="22px" valign="bottom"><div class="dotedLine" style="margin-left:0px;"></div></td>
												</tr>
												<tr>
													<td valign="top" width="30px" nowrap="nowrap">
														<div class="emptyRow"></div>
													</td>
													<td valign="top"></td>
												</tr>
											</tbody>
										</table>
									</div>
								<%
								for(int i=0;i<signButtons.size();i++){
							    ScheduleSignButton ssb = signButtons.get(i);
									String beginTime = currentDate + " " + ssb.getBeginSignTime() + ":00";
									String endTime = currentDate + " " + ssb.getEndSignTime() + ":00";
									boolean cansign = true;
									//if (DateUtil.timeInterval(beginTime, currentFullTime) < 0) cansign = false;
									//else if (DateUtil.timeInterval(currentFullTime, endTime) < 0) cansign = false;
									if(null!=ssb.getType()&&ssb.getType().contains("On")){
							  %>
								<div class="signItem">
									<table width="100%" style="TABLE-LAYOUT: fixed;" cellpadding="0" cellspacing="0" >
										<tbody>
											<tr>
												<td valign="top" width="30px" nowrap="nowrap">
													<div class="dateArea"></div> 
													<div class="state img003"></div>
													<div class="discussline"></div>
												</td>
												<td valign="top" class="item_td">
													<div class="discussitem">
														<div class="discussView">
															<div class="sortInfo">
															   <div style="float: left;">
																	<div class="signtype"><%=SystemEnv.getHtmlLabelName(21974,user.getLanguage())%></div>
																	<div class="worktime">&nbsp;<%=ssb.getTime() %>&nbsp;</div>
																	<%
																		if(Util.null2String(ssb.getIsEnable()).equals("true")&&cansign){
																	%>
																	<div class="signtype1">
																		<input name="btnsign" type="button"
																		style="border: 1px solid #1b82e3;background-color:#1b82e3;width: 82px;height: 28px;margin-top: -5px;color: #fff;font-size: 13px;cursor:pointer;"
																		 value="<%=SystemEnv.getHtmlLabelName(20032,user.getLanguage()) %>" onclick="signInOrSignOut(1);">
																	</div>
																	<%}else{
																		if(null==ssb.getDetail()){
																	%>
																	<div class="signtype1">
																		<input name="btnsign" type="button"
																		style="border: 1px solid #d7dbde;background-color:#d7dbde;width: 82px;height: 28px;margin-top: -5px;color: #fff;font-size: 13px;cursor:pointer;"
																		 value="<%=SystemEnv.getHtmlLabelName(20032,user.getLanguage()) %>" onclick="return false;">
																	</div>
																	<%}else{ %>
																	<div class="signtype1" style="color: #bbbcbf;<%=user.getLanguage()==8?"margin-left:8px;":"" %>"><%=SystemEnv.getHtmlLabelName(129011,user.getLanguage()) %>(<%=ssb.getDetail().getSignTime() %>)</div>
																	<%}}%>
																	<div class="clear"></div>
																</div>
																<div class="clear"></div>
															</div>
														</div>
													</div>
													<div style="height: 44px;"></div>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
								<%}else if(null!=ssb.getType()&&ssb.getType().contains("Off")){ %>
								<div class="signItem">
									<table width="100%" style="TABLE-LAYOUT: fixed;" cellpadding="0" cellspacing="0" >
										<tbody>
											<tr>
												<td valign="top" width="30px" nowrap="nowrap">
													<div class="dateArea"></div> 
													<div class="state img004"></div>
													<div class="discussline" style="height: 50px"></div>
												</td>
												<td valign="top" class="item_td">
													<div class="discussitem">
														<div class="discussView">
															<div class="sortInfo">
															   <div style="float: left;">
																	<div style="float: left;">
																	<div class="signtype"><%=SystemEnv.getHtmlLabelName(21975,user.getLanguage())%></div>
																	<div class="worktime">&nbsp;<%=ssb.getTime() %>&nbsp;</div>
																	<%if(null!=ssb.getDetail()){%>
																	<div class="signtype2" style="color: #bbbcbf;<%=user.getLanguage()==8?"margin-left:8px;":"" %>"><%=SystemEnv.getHtmlLabelName(129013,user.getLanguage()) %>(<%=ssb.getDetail().getSignTime() %>)</div>
																	<%} %>	
																	<%
																		if(Util.null2String(ssb.getIsEnable()).equals("true")&&cansign){
																	%>
																	<div class="signtype2">
																		<input name="btnsign" type="button"
																		style="border: 1px solid #0abf50;background-color:#0abf50;width: 82px;height: 28px;<%=null!=ssb.getDetail()?"margin-top: 5px;":"margin-top: -5px;" %>color: #fff;font-size: 13px;cursor:pointer;"
																		 value="<%=SystemEnv.getHtmlLabelName(20033,user.getLanguage()) %>" onclick="signInOrSignOut(2);">
																	</div>
																	<%}else{%>
																	<div class="signtype2">
																	<input name="btnsign" type="button"
																	style="border: 1px solid #d7dbde;background-color:#d7dbde;width: 82px;height: 28px;<%=null!=ssb.getDetail()?"margin-top: 5px;":"margin-top: -5px;" %>color: #fff;font-size: 13px;cursor:pointer;"
																	 value="<%=SystemEnv.getHtmlLabelName(20033,user.getLanguage()) %>" onclick="return false;">
																</div>
																<%}%>
																	<div class="clear"></div>
																</div>
															</div>
														</div>
													</div>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
								<%} 
							  if(signButtons.size()>3&&i>0&&i/2==0){
							  %>
							 	<div class="dotedLine"></div>
								<div class="signItem">
										<table width="100%" style="TABLE-LAYOUT: fixed;" cellpadding="0" cellspacing="0" >
											<tbody>
												<tr>
													<td valign="top" width="30px" nowrap="nowrap">
														<div class="dateArea"></div> 
														<div class="splitstate img005"></div>
														<div class="discussline" style="top:0px"></div>
													</td>
													<td valign="top"></td>
												</tr>
											</tbody>
										</table>
									</div>
							  <% } 
								}%>
							</div>
						</div>
				   </td>
			   </tr>
			</table>
			<div class="clear"></div>
		</div>