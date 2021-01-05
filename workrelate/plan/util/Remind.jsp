<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.TimeUtil"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="cmutil" class="weaver.pr.util.TransUtil" scope="page" />
<jsp:useBean id="OperateUtil" class="weaver.gp.util.OperateUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
	String userid = user.getUID() + "";
	String currentdate = TimeUtil.getCurrentDateString();
	
	boolean hasremind = false;
	
	
	//查找待提交报告
	StringBuffer submitplan = new StringBuffer();
	int score = 0;
	String basedate = "";
	String basedate2 = "";
	String startdate = "";
	String enddate = "";
	int month = Util.getIntValue(currentdate.substring(5,7));//当前月份
	int year = Util.getIntValue(currentdate.substring(0,4));//当前年份
	int week = TimeUtil.getWeekOfYear(new Date());//当前周
	int type2 = 0;
	int prevyear = year;
	int prevtype2 = 0;
	String titlestr = "";
	String sql = "";
	for(int type1=1;type1<3;type1++){
		if(type1==1){
			titlestr = "月";
			type2 = month;
			if(type2==1){
				prevyear = year -1;
				prevtype2 = 12;
			}else{
				prevtype2 = type2-1;
			}
			try{
				basedate = TimeUtil.getYearMonthEndDay(prevyear, prevtype2);
				basedate2 = TimeUtil.getYearMonthEndDay(year, month);
			}catch(Exception e){}
			sql = "select mstarttype,mstartdays,mendtype,menddays,ismonth from PR_BaseSetting where ismonth=1 and ismremind=1 and resourcetype=2 and resourceid="+ResourceComInfo.getSubCompanyID(userid);
		}else if(type1==2){
			titlestr = "周";
			type2 = week;
			if(type2==1){
				prevyear = year -1;
				prevtype2 = TimeUtil.getMaxWeekNumOfYear(prevyear);
			}else{
				prevtype2 = type2-1;
			}
			try{
    			basedate = TimeUtil.getDateString(TimeUtil.getLastDayOfWeek(prevyear,prevtype2));
    			basedate2 = TimeUtil.getDateString(TimeUtil.getLastDayOfWeek(year,type2));
    		}catch(Exception e){}
    		sql = "select wstarttype,wstartdays,wendtype,wenddays,isweek from PR_BaseSetting where isweek=1 and iswremind=1 and resourcetype=2 and resourceid="+ResourceComInfo.getSubCompanyID(userid);
		}
		rs.executeSql(sql);
		if(rs.next()){
			//判断现在是否处于上一个周期
			startdate = TimeUtil.dateAdd(basedate, Util.getIntValue(rs.getString(1), 1)*Util.getIntValue(rs.getString(2), 0));
			enddate = TimeUtil.dateAdd(basedate, Util.getIntValue(rs.getString(3), 1)*Util.getIntValue(rs.getString(4), 0));
			if(TimeUtil.dateInterval(startdate, currentdate)>=0 && TimeUtil.dateInterval(enddate, currentdate)<=0){
				rs.executeSql("select count(id) from PR_PlanReport where isvalid=1 and userid="+userid+" and year="+prevyear+" and type1="+type1+" and type2="+prevtype2+" and (status=1 or status=3)");
				if(rs.next() && rs.getInt(1)==0){
					submitplan.append("<tr><td>请提交：<a href=\"javaScript:openFullWindowHaveBar('/workrelate/plan/data/PlanView.jsp?resourceid="+userid+"&year="+prevyear+"&type1="+type1+"&type2="+prevtype2+"')\">"+prevyear+"年"+prevtype2+titlestr+"工作总结</a><font style='font-style: italic;color:#999999' title='提交截止日期:"+enddate+"'>["+enddate+"]</td></tr>");
				}
			}
			//当前周期的数据
			startdate = TimeUtil.dateAdd(basedate2, Util.getIntValue(rs.getString(1), 1)*Util.getIntValue(rs.getString(2), 0));
			enddate = TimeUtil.dateAdd(basedate2, Util.getIntValue(rs.getString(3), 1)*Util.getIntValue(rs.getString(4), 0));
			if(TimeUtil.dateInterval(startdate, currentdate)>=0 && TimeUtil.dateInterval(enddate, currentdate)<=0){
				rs.executeSql("select count(id) from PR_PlanReport where isvalid=1 and userid="+userid+" and year="+year+" and type1="+type1+" and type2="+type2+" and (status=1 or status=3)");
				if(rs.next() && rs.getInt(1)==0){
					submitplan.append("<tr><td>请提交：<a href=\"javaScript:openFullWindowHaveBar('/workrelate/plan/data/PlanView.jsp?resourceid="+userid+"&year="+year+"&type1="+type1+"&type2="+type2+"')\">"+year+"年"+type2+titlestr+"工作总结</a><font style='font-style: italic;color:#999999' title='提交截止日期:"+enddate+"'>["+enddate+"]</td></tr>");
				}
			}
		}
	}

	//查找待审批成绩
	int audit_s = 0;
	rs.executeSql("select count(t.id) from PR_PlanReport t,HrmResource h where t.userid=h.id and h.status in (0,1,2,3) and h.loginid is not null and h.loginid<>'' and t.isvalid=1 and t.status=1 and exists(select 1 from PR_PlanReportAudit aa where aa.planid=t.id and aa.userid=" + userid + ") and t.startdate<='" + currentdate + "' and t.enddate>='"+currentdate+"'");
	if (rs.next())
		audit_s = Util.getIntValue(rs.getString(1), 0);

	//查找已完成考核
	rs.executeSql("select t.id,t.planname,t.year,t.type1,t.type2 from PR_PlanReport t where t.isvalid=1 and t.status=3 and t.userid=" + userid + " and not exists(select 1 from PR_PlanReportLog l where l.planid=t.id and l.operatetype=0 and l.operator=" + userid + " and (l.operatedate>t.finishdate or (l.operatedate=t.finishdate and l.operatetime>=t.finishtime)))");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 transitional//EN" "http://www.w3.org/tr/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>计划报告提醒</title>
		<link rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css" />
		<script type="text/javascript" src="/wui/common/jquery/jquery.js"></script>
		<style type="text/css">
			body{margin: 0px;padding:0px;}
			*{font-family:微软雅黑;font-size:12px;}
			.tab1{width: 80px;line-height:26px;text-align:center;float: left;cursor: pointer;border-top:2px #fff solid;font-size: 12px;
				border-right: 1px #EBEBEB solid;font-weight: bold; }
			.tab1_hover{border-top-color: #F9F9F9;background: #F9F9F9;}
			.tab1_click{border-top-color: #3C75D2;background: #F6F6F6;}
			
			.tab2{width: auto;padding-left:4px;padding-right:4px;height:26px;line-height:26px;text-align:left;cursor: pointer;font-size: 12px;color: #999999;
				empty-cells: show;word-break: keep-all;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;}
			.tab2_hover{color: #8B8B8B;}
			.tab2_click{font-weight: normal;color: #4B6EB8;}
		
			.list{width: 100%;}
			.list td{line-height: 22px;padding-left:4px;}
			.list td a,.list td a.link{color: #333333 !important;text-decoration: none;}
			.list tr.hover td{background: #FAFAFA;}
			
			
			.history{width: 100%;}
			.history td{height: 66px;text-align: center;background: #F9F9F9;}
			.ntd{}
			.htd{cursor: pointer;color: #676767}
			.htd_hover{background: #0094DB !important;color: #fff !important;}
			.htd_hover font{color: #fff !important;}
			.font1{color: #3f3f3f;font-size: 16px;line-height: 22px;font-weight: bold;font-family: Arial !important;}
			.font3{color: #676767;font-size: 12px;line-height: 22px;}
			.font2{color: #d4d4d4;line-height: 22px;}
			
			.show{
				SCROLLBAR-DARKSHADOW-COLOR: #EBEBEB;
				SCROLLBAR-ARROW-COLOR: #F7F7F7;
				SCROLLBAR-3DLIGHT-COLOR: #EBEBEB;
				SCROLLBAR-SHADOW-COLOR: #EBEBEB;
				SCROLLBAR-HIGHLIGHT-COLOR: #EBEBEB;
				SCROLLBAR-FACE-COLOR: #EBEBEB;
				scrollbar-track-color: #F7F7F7;
				overflow-x: hidden; 
			}
			
			::-webkit-scrollbar-track-piece {
				background-color: #E2E2E2;
				-webkit-border-radius: 0;
			}
			
			::-webkit-scrollbar {
				width: 12px;
				height: 8px;
			}
			
			::-webkit-scrollbar-thumb {
				height: 50px;
				background-color: #CDCDCD;
				-webkit-border-radius: 1px;
				outline: 0px solid #fff;
				outline-offset: -2px;
				border: 0px solid #fff;
			}
			
			::-webkit-scrollbar-thumb:hover {
				height: 50px;
				background-color: #BEBEBE;
				-webkit-border-radius: 1px;
			}
		</style>
	<%@ include file="/secondwev/common/head.jsp" %>
	</head>
	<body style="overflow: hidden;">
		<div style="width: auto;height: 120px;border: 1px #EBEBEB solid;overflow: hidden;">
			<div style="width: 100%;height: 28px;background: #fff;border-bottom: 1px #EBEBEB solid;">
				<div id="tab1_2" class="tab1 tab1_click" _index="2" title="计划报告提醒">报告提醒</div>
				<div id="tab1_3" class="tab1" _index="3" title="近六个月考核结果">我的报告</div>
				<div style="width: 60px;line-height: 22px;float: right;text-align: center;color: #8C8C8C;font-weight: bold;display: none;">计划报告</div>
			</div>
			<div style="width: 100%;height: 2px;background: #F6F6F6;border-bottom: 1px #EBEBEB solid;"></div>
			<div id="show2" class="show" style="width: 100%;height: 90px;overflow: auto;">
				<table class="list" style="width: 100%;margin-top: 6px;" cellpadding="0" cellspacing="0" border="0">
					<%
						if (audit_s > 0) {
							hasremind = true;
					%>
					<tr>
						<td>
							<a href="javascript:openFullWindowHaveBar('/workrelate/plan/data/AuditFrame.jsp')">您有<%=audit_s%>个待审批工作总结</a>
						</td>
					</tr>
					<%
						}
					%>
					<%if(submitplan.length()>0){ 
						hasremind = true;
					%>
						<%=submitplan.toString() %>
					<%} %>
					<%
						while (rs.next()) {
							hasremind = true;
					%>
					<tr>
						<td>
							<a href="javascript:openFullWindowHaveBar('/workrelate/plan/data/PlanView.jsp?planid=<%=rs.getString("id")%>')">
								您的<%=cmutil.getYearType(rs.getString("year") + "+" + rs.getString("type1") + "+" + rs.getString("type2"))%>工作总结已通过</a>
						</td>
					</tr>
					<%
						}
					%>
					
					<%if(!hasremind){ %>
					<tr>
						<td style="color: #ADADAD;font-style: italic;">
							暂无提醒
						</td>
					</tr>
					<%} %>
				</table>
			</div>
		</div>
		
		<script type="text/javascript">
			$.ajaxSetup ({
			    cache: false //关闭AJAX相应的缓存
			});
			$(document).ready(function(){
				$("table.list").find("tr").bind("mouseover",function(){
					$(this).addClass("hover");
				}).bind("mouseout",function(){
					$(this).removeClass("hover");
				});
				
				$("div.tab1").bind("mouseover",function(){
					$(this).addClass("tab1_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("tab1_hover");
				}).bind("click",function(){
					var _index = $(this).attr("_index");
					if(_index==3){
						openFullWindowHaveBar("/workrelate/plan/data/PlanFrame.jsp");
					}else{
						$("div.tab1").removeClass("tab1_click");
						$(this).addClass("tab1_click");
						$("div.show").hide();
						$("#show"+_index).show();
					}
				});

				$("td.tab2").bind("mouseover",function(){
					$(this).addClass("tab2_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("tab2_hover");
				}).bind("click",function(){
					$("td.tab2").removeClass("tab2_click");
					$(this).addClass("tab2_click");
					var _itemid = $(this).attr("_itemid");
					var _desc = $(this).attr("_desc");
					$("#showreport").load("Report.jsp?accessitemid="+_itemid+"&itemdesc="+_desc);

					if($("#tabtable").width()>$("#tabdiv").width()){
						$("#tabtable").width("100%").css("table-layout","fixed");
					}
				});
			});

			function openFullWindowHaveBar(url){
				  var redirectUrl = url ;
				  var width = screen.availWidth-10 ;
				  var height = screen.availHeight-50 ;
				  //if (height == 768 ) height -= 75 ;
				  //if (height == 600 ) height -= 60 ;
				   var szFeatures = "top=0," ;
				  szFeatures +="left=0," ;
				  szFeatures +="width="+width+"," ;
				  szFeatures +="height="+height+"," ;
				  szFeatures +="directories=no," ;
				  szFeatures +="status=yes,toolbar=no,location=no," ;
				  szFeatures +="menubar=no," ;
				  szFeatures +="scrollbars=yes," ;
				  szFeatures +="resizable=yes" ; //channelmode
				  window.open(redirectUrl,"",szFeatures) ;
			}
		</script>
	</body>
</html>