<%@page import="java.text.DecimalFormat"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.common.DateUtil"%>
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

//考勤非标功能开关检查--001
boolean check001 = true;
String isSign = Util.null2String(bb.getPropValue("issigninorsignout","ISSIGNINORSIGNOUT"),"");
if(!"1".equals(isSign)){
	check001 = false;
}
//开启在线签到签退功能--002
//老开关

String needSign="",onlyworkday="",signTimeScope="",signIpScope="";
String sql002 = "select needSign, onlyworkday, signTimeScope, signIpScope from HrmKqSystemSet";
rs.executeSql(sql002);
if(rs.next()){
	needSign = rs.getString("needSign");
	onlyworkday = rs.getString("onlyworkday");
	signTimeScope = rs.getString("signTimeScope");
	signIpScope = rs.getString("signIpScope");
}
//新开关
Map<String,String> mapDetail = new HashMap<String,String>();
String newDetail = "";
String needSignNew="",onlyworkdayNew="",signTimeScopeNew="",signIpScopeNew="",relatedid="",Scheduletype="";
String validedateto = "";
String currentDate = DateUtil.getCurrentDate();
//检查所有的一般工作时间是否存在有效期内的--004
boolean check004 = true; //true表示不在有效期内
sql002 = "select needSign, onlyworkday, signTimeScope, signIpScope,relatedid,Scheduletype,validedateto from HrmSchedule order by validedateto desc";
rs.executeSql(sql002);
while(rs.next()){
	needSignNew = rs.getString("needSign");
	relatedid = rs.getString("relatedid");
	Scheduletype = rs.getString("Scheduletype");
	validedateto = rs.getString("validedateto");
	if("1".equals(needSignNew)){
		if("3".equals(Scheduletype)){
			newDetail +="总部;";
		}
		if("4".equals(Scheduletype)){
			newDetail +="分部:"+SubCompanyComInfo.getSubCompanyname(relatedid)+";";
		}
	}
	mapDetail.put(relatedid,Scheduletype);
	if(!"".equals(validedateto) && validedateto.compareTo(currentDate) >= 0){
		check004 = false;
	}
}

//排班设置--003
boolean check003 = false;
String sql003 = "select * from hrm_schedule_set_detail";
rs.executeSql(sql003);
if(rs.getCounts() > 0){
	check003 = true;
}
%>
	<wea:layout type="2col">
	    <wea:group context='检查考勤相关全局设置' attributes="{'itemAreaDisplay':'display'}">
	<%
		if(check001){
	%>	
			<wea:item>考勤非标功能开关检查<img src="remind_wev8.png" title="【001考勤签到】非标功能" /></wea:item>
			<wea:item>
				<img src="ok.png"  />开启了考勤非标
			</wea:item>
			<wea:item>在线签到签退功能检查(老开关<img src="remind_wev8.png" title="引用E7的开关" />)</wea:item>
			<wea:item>
			<%
				if("1".equals(needSign)){
			%>	
				<img src="ok.png"  />开启在线签到签退功能 <img src="refresh.png"  title="调整设置" style="cursor: pointer;" onclick="goNew('/hrm/HrmTab.jsp?_fromURL=HrmOnlineKqSystemSet')" />
			<%
				}else{
%>				
					<img src="rejected_bg_wev8.gif"  />未开启在线签到签退功能 <img src="refresh.png"  title="调整设置" style="cursor: pointer;" onclick="goNew('/hrm/HrmTab.jsp?_fromURL=HrmOnlineKqSystemSet')" />
	<%
				}
			 %>
			</wea:item>
			<wea:item>在线签到签退功能检查(新开关<img src="remind_wev8.png" title="可以在[一般工作时间]里设置分部的在线签到考勤" />)</wea:item>
			<wea:item>
			<%
				if(!"".equals(newDetail)){
			%>	
				<img src="ok.png"  /><p style="display:inline; color: blue;" ><%=newDetail %></p>已经开启在线签到签退功能 <img src="refresh.png"  title="调整设置" style="cursor: pointer;" onclick="goNew('/hrm/schedule/HrmDefaultSechedule_frm.jsp')" />
			<%
				}else{
			%>	
					<img src="rejected_bg_wev8.gif"  />未开启在线签到签退功能 <img src="refresh.png"  title="调整设置" style="cursor: pointer;" onclick="goNew('/hrm/schedule/HrmDefaultSechedule_frm.jsp')" />
				<%
				}
			 %>
			</wea:item>
			<wea:item>一般工作时间设置检查<img src="remind_wev8.png" title="未设置一般工作时间会导致请假天数无法计算，考勤报表不显示等问题" /></wea:item>
			<wea:item>
			<%
				if(!mapDetail.isEmpty()){
				%>
			<%
				if(mapDetail.containsValue("3")){//是不是设置了总部的一般工作时间
				
					Calendar today = Calendar.getInstance();
					String currentdate = Util.add0(today.get(Calendar.YEAR),4)+"-"+Util.add0(today.get(Calendar.MONTH)+1,2)+"-"+Util.add0(today.get(Calendar.DATE),2) ;
				%>		
					<img src="ok.png"  /><p style="display:inline; color: blue;" >已经设置了总部的一般工作时间</p>
					<img src="refresh.png"  title="调整设置" style="cursor: pointer;" onclick="goNew('/hrm/schedule/HrmDefaultSechedule_frm.jsp')" /><br/>
			<br/>
				<%
				}else{
				%>	
				<img src="rejected_bg_wev8.gif"  />总部的一般工作时间未开启，会导致<a href="javascript:void(0);" onclick="goNew('/hrm/HrmTab.jsp?_fromURL=HrmPubHoliday')" style="color:red;" >工作日期调整</a>显示有问题 <img src="refresh.png"  title="调整设置" style="cursor: pointer;" onclick="goNew('/hrm/schedule/HrmDefaultSechedule_frm.jsp')" /><br/>
				
				<%}
				
					String cfrelatedid = "";
					boolean hasMultiSchedule = false;
					String cfSql = "select relatedid,COUNT(1) from hrmschedule group by relatedid having COUNT(1) >1"; 
					rs.executeSql(cfSql);
					if(rs.next()){
						hasMultiSchedule = true;
						cfrelatedid = rs.getString("relatedid");
					}
					if(hasMultiSchedule){
						String  relatedName = "";
						if("0".equals(cfrelatedid)){
							relatedName = "总部";
						}else{
							relatedName = SubCompanyComInfo.getSubCompanyname(cfrelatedid);
						}
%>
<img src="rejected_bg_wev8.gif"  /><p style="display:inline; color: red;" >设置了多个【<%=relatedName%>】一般工作时间</p><img src="remind_wev8.png" title="不同KB版本下这样设置会导致请假天数计算为0或者考勤报表计算为0" /><br/>
				<%						
					if(cversion.compareTo("8.100.0531+KB81001612") >= 0){
%>
					<img src="e8bghover_wev8.png"  />当前版本下考勤报表查询的时候不能跨一般工作时间，比如一般工作时间设置的是1990-01-01到1990-09-30和1990-10-01到1990-12-31,当你考勤报表查询的时候，查询条件是1990-09-29到1990-10-02交叉这两个一般工作时段，考勤报表数据会有问题<br/>				
<%					}else{
					 %>
					 <img src="e8bghover_wev8.png"  />当前版本下请假天数和考勤报表计算的时候只会取id排序最大的一般工作时间，最好的解决方法是申请KB81001612以上版本或者只保留一个总部类型的一般工作时间
					<img src="refresh.png"  title="调整设置" style="cursor: pointer;" onclick="goNew('/hrm/schedule/HrmDefaultSechedule_frm.jsp')" /><br/>	
				<%	 
					} %>
<%					
					}
				%>
				
				<% 
				if(check004){
				%>
				<img src="e8bghover_wev8.png"  />一般工作时间的有效期设置有疑问<img src="remind_wev8.png" title="当前最大的一般工作时间有效期是<%=validedateto %>" />
				<img src="refresh.png"  title="调整设置" style="cursor: pointer;" onclick="goNew('/hrm/schedule/HrmDefaultSechedule_frm.jsp')" /><br/>
				<%
				}else{
				%>
				<img src="ok.png"  /><p style="display:inline; color: blue;" >一般工作时间的有效期设置正常</p>
				<img src="refresh.png"  title="调整设置" style="cursor: pointer;" onclick="goNew('/hrm/schedule/HrmDefaultSechedule_frm.jsp')" /><br/>
			<%
				}
				 %>
				
			<%	}else{
			%>	
				<img src="rejected_bg_wev8.gif"  />未设置一般工作时间 <img src="refresh.png"  title="调整设置" style="cursor: pointer;" onclick="goNew('/hrm/schedule/HrmDefaultSechedule_frm.jsp')" /><br/>
			<%	}
			 %>
			</wea:item>
			<wea:item>排班设置检查<img src="remind_wev8.png" title="排班具备和一般工作时间一样的设置上下班的功能，可以针对到人，但是当前的排班功能不支持排班时段中加入中午休息时间" /></wea:item>
			<wea:item>
						<%
					if(cversion.compareTo("8.100.0531+KB81001601") >= 0){
						if(check003){
						
				 %>
					<img src="ok.png"  />已经设置排班<img src="refresh.png"  title="调整设置" style="cursor: pointer;" onclick="goNew('/hrm/schedule/hrmScheduleSet/home.jsp')" />
				 <%
				 	}else{
				 %>
					<img src="e8bghover_wev8.png"  />未设置排班<img src="refresh.png"  title="调整设置" style="cursor: pointer;" onclick="goNew('/hrm/schedule/hrmScheduleSet/home.jsp')" />
				 <%
					}
				 }else{
				 %>
				 <img src="rejected_bg_wev8.gif"  />当前KB版本没有排班功能，联系客服或者项目人员申请KB81001601以上版本
				<% }
				  %>
			</wea:item>
			<wea:item>签到签退功能检查<img src="remind_wev8.png" title="在线签到开启是签到签退按钮显示的前提" /></wea:item>
			<wea:item>
			
			<%
				if("1".equals(needSign) || !"".equals(newDetail)){
			%>		
			<img src="ok.png"  />已开启在线签到签退功能 <img src="refresh.png"  title="调整设置" style="cursor: pointer;" onclick="goNew('/hrm/HrmTab.jsp?_fromURL=HrmOnlineKqSystemSet')" /><br/>
			<%
				if(cversion.compareTo("8.100.0531+KB81001601") >= 0){
					if(mapDetail.isEmpty() && !check003){
						
					%>
						<img src="rejected_bg_wev8.gif"  />未设置一般工作时间 <img src="refresh.png"  title="调整设置" style="cursor: pointer;" onclick="goNew('/hrm/schedule/HrmDefaultSechedule_frm.jsp')" />也没有设置排班<img src="refresh.png"  title="调整设置" style="cursor: pointer;" onclick="goNew('/hrm/schedule/hrmScheduleSet/home.jsp')" /><br/>
				
				<%	}else{
					if(!mapDetail.isEmpty()){
			%>		
					<img src="e8bghover_wev8.png"  />设置了一般工作时间，如果还不能签到签退<img src="refresh.png"  title="调整设置" style="cursor: pointer;" onclick="goNew('/hrm/schedule/HrmDefaultSechedule_frm.jsp')" />,需要注意：<br/>
					<div class="noteinfo">
						1、签到签退日期是否在一般工作时间的生效日内<br/>
						2、签到签退人所属分部是否设置了一般工作时间或者总部类型的一般工作时间是否设置<br/>
						3、是否设置了调配工作日，签到日为非工作日<br/>
						4、如果是PC端签到签退正常，mobile端签到签退有问题，需要查看mobile客户端是不是设置了地理位置控制<br/>
					</div>
		<%			}
					if(check003){
			 %>		
			 <img src="e8bghover_wev8.png"  />设置了排班数据，如果还不能签到签退<img src="refresh.png"  title="调整设置" style="cursor: pointer;" onclick="goNew('/hrm/schedule/HrmDefaultSechedule_frm.jsp')" />,需要注意：<br/>
			 	<div class="noteinfo">
						1、签到签退人在对应日期下是否设置了排班<br/>
						2、签到签退日期当天是不是设置了调配工作日，当前版本的排班不支持排班设置调配工作日<br/>
						3、如果是PC端签到签退正常，mobile端签到签退有问题，需要查看KB版本是否得到KB1604以上<span style="color: red;" >(微信企业号不支持排班人员签到签退功能)</span><br/>
						4、注意签到签退人当天排班的工作时段<img src="refresh.png"  title="调整设置" style="cursor: pointer;" onclick="goNew('/hrm/schedule/hrmScheduleWorktime/tab.jsp?topage=list')" />,工作时段有签到开始时间和最晚签退时间，比如<br/>
						工作时间设置是：上班时间10:00，下班时间18:00，签到开始时间是30分钟，最晚签退时间是30分钟，则是从09:30开始可以签到，且在18:30之后就不能签退了
					</div>	
		<%					}
				%>
				
			<%	}
				}else{
					if(mapDetail.isEmpty()){
						
					%>
						<img src="rejected_bg_wev8.gif"  />未开启在线签到签退功能 <img src="refresh.png"  title="调整设置" style="cursor: pointer;" onclick="goNew('/hrm/schedule/HrmDefaultSechedule_frm.jsp')" /><br/>
				
				<%	}
				
				}
				 %>
			
				<%
				}else{
%>				
					<img src="rejected_bg_wev8.gif"  />未开启在线签到签退功能 <img src="refresh.png"  title="调整设置" style="cursor: pointer;" onclick="goNew('/hrm/HrmTab.jsp?_fromURL=HrmOnlineKqSystemSet')" />
	<%
				}
			 %>
				
			</wea:item>
	<%
	}else{
	%>
			<wea:item>考勤非标功能开关检查</wea:item>
			<wea:item>
					<img src="rejected_bg_wev8.gif"  />考勤非标功能没有打<img src="remind_wev8.png" title="如何打考勤非标,可以咨询项目或者客服人员" />
			</wea:item>
<%
	}
	 %>
	    </wea:group>
	    
	</wea:layout>