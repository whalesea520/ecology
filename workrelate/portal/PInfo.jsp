<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.file.Prop" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="AccessItemComInfo" class="weaver.gp.cominfo.AccessItemComInfo" scope="page" />
<jsp:useBean id="cmutil" class="weaver.gp.util.TransUtil" scope="page" />
<jsp:useBean id="cmutil2" class="weaver.pr.util.TransUtil" scope="page" />
<jsp:useBean id="OperateUtil" class="weaver.gp.util.OperateUtil" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<%
	//是否启用计划报告
	boolean isplan = Util.null2String(Prop.getPropValue("workrelate", "isplan")).equals("1")?true:false;

	String userid = user.getUID() + "";
	String currentdate = TimeUtil.getCurrentDateString();
	
	boolean hasitem = false;
	String sql = "";
	
	int year = Util.getIntValue(TimeUtil.getCurrentDateString().substring(0,4));
	int month = Util.getIntValue(TimeUtil.getCurrentDateString().substring(5,7));
	
	
	boolean hasremind = false;
	
	//查询当前周期未设置方案数量
	int[] amounts = OperateUtil.getNoProgramCount(userid);
	int amount1 = amounts[0];
	int amount2 = amounts[1];
	int amount3 = amounts[2];
	int amount4 = amounts[3];
	
	//查找待审批方案
	int audit_p = 0;
	rs.executeSql("select count(*) from GP_AccessProgram t1,GP_AccessProgramAudit t2 where t1.id=t2.programid and t2.userid=" + userid);
	if (rs.next())
		audit_p = Util.getIntValue(rs.getString(1), 0);

	//查找待评分成绩
	int score = 0;
	rs.executeSql("select count(*) from GP_AccessScore t,HrmResource h where t.userid=h.id and h.status in (0,1,2,3) and h.loginid is not null and h.loginid<>'' and t.isvalid=1 and (t.status=0 or t.status=2) and t.operator=" + userid + " and t.startdate<='" + currentdate + "' and t.enddate>='"+currentdate+"'");
	if (rs.next())
		score = Util.getIntValue(rs.getString(1), 0);

	//查找待审批成绩
	int audit_s = 0;
	rs.executeSql("select count(*) from GP_AccessScore t,HrmResource h where t.userid=h.id and h.status in (0,1,2,3) and h.loginid is not null and h.loginid<>'' and t.isvalid=1 and t.status=1 and exists(select 1 from GP_AccessScoreAudit aa where aa.scoreid=t.id and aa.userid=" + userid + ") and t.startdate<='" + currentdate + "' and t.enddate>='"+currentdate+"'");
	if (rs.next())
		audit_s = Util.getIntValue(rs.getString(1), 0);

	//查找已完成考核
	String finishsql2 = "select t.id,t.scorename,t.year,t.type1,t.type2 from GP_AccessScore t where t.isvalid=1 and t.status=3 and t.userid=" + userid + " and not exists(select 1 from GP_AccessScoreLog l where l.scoreid=t.id and l.operatetype=0 and l.operator=" + userid + " and (l.operatedate>t.finishdate or (l.operatedate=t.finishdate and l.operatetime>=t.finishtime)))";
	
	//查找未读反馈
	String noreadsql2 = "select t.id,t.scorename,t.userid,t.year,t.type1,t.type2 from GP_AccessScore t where t.isvalid=1 and (t.userid="+userid+" or t.remindids like '%,"+userid+",%' or (exists(select 1 from GP_AccessScorecheck t4 where t4.scoreid=t.id and t4.userid="+userid+" and t4.status in (1,2))))"
		+" and (select top 1 t3.operatedate+' '+t3.operatetime from GP_AccessScoreExchange t3 where t3.scoreid=t.id and t3.operator<>"+userid+" order by t3.operatedate desc,t3.operatetime desc)"
		+" >(select top 1 t2.operatedate+' '+t2.operatetime from GP_AccessScoreLog t2 where t2.scoreid=t.id and t2.operatetype=0 and t2.operator="+userid+" order by t2.operatedate desc,t2.operatetime desc)";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 transitional//EN" "http://www.w3.org/tr/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>目标绩效提醒</title>
		<link rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css" />
		<script type="text/javascript" src="/wui/common/jquery/jquery.js"></script>
		<script language="javascript" src="/performance/js/highcharts.src.js"></script>
		<style type="text/css">
			body{margin: 0px;padding:0px;}
			*{font-family:微软雅黑;font-size:12px;}
			.tab1{width: 80px;line-height:26px;text-align:center;float: left;cursor: pointer;border-top:0px #fff solid;font-size: 12px;
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
				overflow-y: auto; 
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
		<div style="width: auto;height: 208px;border: 0px #EBEBEB solid;overflow: hidden;">
			<div style="width: 100%;height: 26px;background: #fff;border-bottom: 1px #EBEBEB solid;">
				<div id="tab1_3" class="tab1 tab1_click" _index="3" title="近六个月考核结果">历史绩效</div>
				<div id="tab1_2" class="tab1" _index="2" title="考核提醒数据">考核提醒</div>
				<div style="width: 60px;line-height: 22px;float: right;text-align: center;color: #8C8C8C;font-weight: bold;display: none;">目标绩效</div>
			</div>
			<div id="show2" class="show" style="width: 100%;height: 180px;display: none;">
				<div style="width: 100%;height: 2px;background: #F6F6F6;border-bottom: 1px #EBEBEB solid;"></div>
				<table class="list" style="width: 100%;margin-top: 6px;" cellpadding="0" cellspacing="0" border="0">
					<%
						if (audit_p > 0) {
							hasremind = true;
					%>
					<tr>
						<td>
							<a href="javascript:openFullWindowHaveBar('/performance/program/ProgramMain.jsp?type=2')">您有<%=audit_p%>个待审批考核方案</a>
						</td>
					</tr>
					<%
						}
					%>
					<%
						if (score > 0) {
							hasremind = true;
					%>
					<tr>
						<td>
							<a href="javascript:openFullWindowHaveBar('/performance/access/AccessList.jsp?showtype=1')">您有<%=score%>个待评分绩效考核</a>
						</td>
					</tr>
					<%
						}
					%>
					<%
						if (audit_s > 0) {
							hasremind = true;
					%>
					<tr>
						<td>
							<a href="javascript:openFullWindowHaveBar('/performance/access/AccessList.jsp?showtype=2')">您有<%=audit_s%>个待审批绩效考核</a>
						</td>
					</tr>
					<%
						}
					%>
		
					<%
						rs.executeSql(finishsql2);
						while (rs.next()) {
							hasremind = true;
					%>
					<tr>
						<td>
							<a href="javascript:openFullWindowHaveBar('/performance/access/AccessView.jsp?scoreid=<%=rs.getString("id")%>')" onclick="removeObj(this)">
								您的<%=cmutil.getYearType(rs.getString("year") + "+" + rs.getString("type1") + "+" + rs.getString("type2"))%>绩效考核已完成</a>
						</td>
					</tr>
					<%
						}
					%>
					<%
						rs.executeSql(noreadsql2);
						while (rs.next()) {
							hasremind = true;
					%>
					<tr>
						<td>
							<a href="javascript:openFullWindowHaveBar('/performance/access/AccessView.jsp?scoreid=<%=rs.getString("id")%>')" onclick="removeObj(this)">
								<%=userid.equals(rs.getString("userid"))?"您的":ResourceComInfo.getLastname(rs.getString("userid")) %><%=cmutil.getYearType(rs.getString("year") + "+" + rs.getString("type1") + "+" + rs.getString("type2"))%>绩效考核有新反馈</a>
						</td>
					</tr>
					<%
						}
					%>
					
					<%if(amount1>0 || amount2>0 || amount3>0 || amount4>0){ 
						hasremind = true;
					%>
					<tr>
						<td>
							<a href="javascript:openFullWindowHaveBar('/performance/program/ProgramMain.jsp?type=3')">考核方案未设置</a>(
								<%if(amount1>0){ %>年度:<a href="javascript:openFullWindowHaveBar('/performance/program/ProgramMain.jsp?type=3&nofyear=1')"><%=amount1%></a>&nbsp;<%} %>
								<%if(amount2>0){ %>半年:<a href="javascript:openFullWindowHaveBar('/performance/program/ProgramMain.jsp?type=3&nohyear=1')"><%=amount2%></a>&nbsp;<%} %>
								<%if(amount3>0){ %>季度:<a href="javascript:openFullWindowHaveBar('/performance/program/ProgramMain.jsp?type=3&noquarter=1')"><%=amount3%></a>&nbsp;<%} %>
								<%if(amount4>0){ %>月度:<a href="javascript:openFullWindowHaveBar('/performance/program/ProgramMain.jsp?type=3&nomonth=1')"><%=amount4%></a><%} %>
							)
						</td>
					</tr>	
					<%} %>
					
					<%if(!hasremind){ %>
					<tr>
						<td style="color: #ADADAD;font-style: italic;">
							暂无提醒
						</td>
					</tr>
					<%} %>
				</table>
			</div>
			
			<%
				int yearto = Util.getIntValue(TimeUtil.getCurrentDateString().substring(0,4));
				int monthto = Util.getIntValue(TimeUtil.getCurrentDateString().substring(5,7));
				
				int yearfrom = yearto;
				int monthfrom = monthto-5;
				
				if(monthfrom<=0){
					yearfrom = yearfrom - 1;
					monthfrom = 12 + monthfrom;
				}
				
				sql = "select t1.id,t1.year,t1.type2,t1.result,t1.status,t1.startdate,t1.enddate from GP_AccessScore t1 where t1.isvalid=1 and t1.type1=1 and t1.userid="+userid;
				if(yearfrom==yearto){
					sql += " and t1.year="+yearfrom+" and t1.type2>="+monthfrom+" and t1.type2<="+ monthto;
				}else{
					sql += " and ((t1.year="+yearfrom+" and t1.type2>="+monthfrom+") or (t1.year="+yearto+" and t1.type2<="+ monthto+"))";
				}
				sql += " order by t1.year,t1.type2";
				//System.out.println(sql);
				rs.executeSql(sql);
				Map scoremap = new HashMap();
				String scoreid = "";
				String result = "";
				String status = "";
				String startdate = "";
				String enddate = "";
				String showinfo = "";
				String showtype = "0";
				while(rs.next()){ 
					year = Util.getIntValue(rs.getString("year"));
					month = Util.getIntValue(rs.getString("type2"));
					scoreid = Util.null2String(rs.getString("id"));
					result = Util.null2String(rs.getString("result"));
					status = Util.null2String(rs.getString("status"));
					startdate = Util.null2String(rs.getString("startdate"));
					enddate = Util.null2String(rs.getString("enddate"));
					showtype = "0";
					if(TimeUtil.dateInterval(currentdate, startdate)>0){
						showinfo = "未开始";
					}else if(status.equals("3")){
						showinfo = result;
						showtype = "1";
					}else{
						if(TimeUtil.dateInterval(enddate, currentdate)>0){
							showinfo = "已过期";
						}else{
							if("0".equals(status) || "2".equals(status)){
								showinfo = "考核中";
							}else{
								showinfo = "审批中";
							}
						}
					}
					String[] ss = {scoreid,showinfo,showtype};
					scoremap.put(year+"-"+((month<10)?"0"+month:month),ss);
				}
				
				
			%>
			<div id="show3" class="show" style="width: 100%;height: 190px;">
				<table class="history" cellpadding="0" cellspacing="5" border="0">
					<colgroup><col width="33%"/><col width="33%"/><col width="34%"/></colgroup>
					<tr>
					<% 
					int index = 0;
					String ymstr = "";
					String info = "";
					String infoid = "";
					if(yearfrom!=yearto){
						for(int i=monthfrom;i<=12;i++){
							ymstr = yearfrom+"-"+((i<10)?"0"+i:i);
							String[] infos = (String[])scoremap.get(ymstr);
							if(infos==null){ 
								infoid = "";
								info = "无数据";
							}else{
								infoid = infos[0];
								info = infos[1];
							}
					%>
						<%if(index==3){ %><tr><%} %>
						<td class="<%if(infos!=null){ %>htd<%} %>" _scoreid="<%=infoid %>">
							<font class="<%if(infos!=null && infos[2].equals("1")){ %>font1<%}else{ %>font3<%} %>"><%=info %></font><br>
							<font class="font2"><%=ymstr %></font>
						</td>
						<%if(index==2){ %></tr><%} %>
					<%
							index++;
						}
						for(int i=1;i<=monthto;i++){
							ymstr = yearto+"-"+((i<10)?"0"+i:i);
							String[] infos = (String[])scoremap.get(ymstr);
							if(infos==null){ 
								infoid = "";
								info = "无数据";
							}else{
								infoid = infos[0];
								info = infos[1];
							}
					%>
						<%if(index==3){ %><tr><%} %>
						<td class="<%if(infos!=null){ %>htd<%} %>" _scoreid="<%=infoid %>">
							<font class="<%if(infos!=null && infos[2].equals("1")){ %>font1<%}else{ %>font3<%} %>"><%=info %></font><br>
							<font class="font2"><%=ymstr %></font>
						</td>
						<%if(index==2){ %></tr><%} %>
					<%
							index++;
						}
					}else{
						for(int i=monthfrom;i<=monthto;i++){
							ymstr = yearto+"-"+((i<10)?"0"+i:i);
							String[] infos = (String[])scoremap.get(ymstr);
							if(infos==null){ 
								infoid = "";
								info = "无数据";
							}else{
								infoid = infos[0];
								info = infos[1];
							}
					%>
						<%if(index==3){ %><tr><%} %>
						<td class="<%if(infos!=null){ %>htd<%} %>" _scoreid="<%=infoid %>">
							<font class="<%if(infos!=null && infos[2].equals("1")){ %>font1<%}else{ %>font3<%} %>"><%=info %></font><br>
							<font class="font2"><%=ymstr %></font>
						</td>
						<%if(index==2){ %></tr><%} %>
							
					<%
							index++;
						}
					}	
					%>
					</tr>
					<tr>
						<td colspan="3" class="htd" style="height: 30px;" _scoreid="0">更多</td>
					</tr>
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
					$("div.tab1").removeClass("tab1_click");
					$(this).addClass("tab1_click");
					var _index = $(this).attr("_index");
					$("div.show").hide();
					$("#show"+_index).show();
					if(_index==1){
						$("td.tab2")[0].click();
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

				$("td.htd").bind("mouseover",function(){
					$(this).addClass("htd_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("htd_hover");
				}).bind("click",function(){
					var scoreid = $(this).attr("_scoreid");
					if(scoreid!=""){
						if(scoreid=="0"){
							openFullWindowHaveBar("/performance/access/ResultFrame.jsp");
						}else{
							openFullWindowHaveBar("/performance/access/AccessView.jsp?scoreid="+scoreid);
						}
					}
				});

				<%if(hasremind){%>
					//$("#tab1_2").click();
				<%}%>
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

			function removeObj(obj){
				$(obj).parent().parent("tr").remove();
			}
		</script>
	</body>
</html>