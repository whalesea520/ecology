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
	
	int year = Util.getIntValue(TimeUtil.getCurrentDateString().substring(0,4));
	int month = Util.getIntValue(TimeUtil.getCurrentDateString().substring(5,7));
	
	List accessitem = new ArrayList();
	List descitem = new ArrayList();
	List duplitem = new ArrayList();
	List accessitem2 = new ArrayList();
	//读取当前月的考核项
	rs.executeSql("select id from GP_AccessScore where isvalid=1 and userid="+userid+" and year="+year+" and type1=1 and type2="+month);
	if(rs.next()){
		String scoreid = Util.null2String(rs.getString(1));
		rs.executeSql("select accessitemid,description from GP_AccessScoreDetail where scoreid="+scoreid);
		String accessitemid = "";
		//double target = 0;
		//double result = 0;
		while(rs.next()){
			accessitemid = Util.null2String(rs.getString("accessitemid"));
			if("2".equals(AccessItemComInfo.getType(accessitemid))){
				if(accessitem.indexOf(accessitemid)>-1) duplitem.add(accessitemid);
				accessitem.add(accessitemid);
				descitem.add(rs.getString("description"));
			}else if("1".equals(AccessItemComInfo.getType(accessitemid))){
				accessitem2.add(rs.getString("description"));
			}
		}
	}
	if(accessitem.size()>0) hasitem = true;
	
	
	boolean hasremind = false;
	
	
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
			.tab1{width: 80px;line-height:26px;text-align:center;float: left;cursor: pointer;border-top:2px #fff solid;font-size: 12px;
				border-right: 1px #EBEBEB solid;font-weight: bold; }
			.tab1_hover{border-top-color: #F9F9F9;background: #F9F9F9;}
			.tab1_click{border-top-color: #3C75D2;background: #F6F6F6;}
			
			.tab2{width: auto;padding-left:4px;padding-right:4px;height:26px;line-height:26px;text-align:left;cursor: pointer;font-size: 12px;color: #999999;
				empty-cells: show;word-break: keep-all;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;}
			.tab2_hover{color: #8B8B8B;}
			.tab2_click{font-weight: bold;color: #4B6EB8;}
		
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
			.list{width: 100%;height: auto;overflow: hidden;padding-left: 20px;padding-top: 5px;margin-top: 2px;}
			.list li{margin-left: 5px;line-height: 24px;color: #555555;}
		</style>
	<%@ include file="/secondwev/common/head.jsp" %>
	</head>
	<body style="overflow: hidden;">
		<div style="width: auto;height: 298px;border: 0px #EBEBEB solid;overflow: hidden;">
			<div style="width: 100%;height: 28px;background: #fff;border-bottom: 1px #EBEBEB solid;display: none;">
				<%if(hasitem){%><div id="tab1_1" class="tab1" _index="1" title="近六个月定量指标目标及完成统计">定量指标</div><%}%>
				<div id="tab1_2" class="tab1" _index="2" title="考核提醒数据">考核提醒</div>
				<div id="tab1_3" class="tab1 tab1_click" _index="3" title="近六个月考核结果">历史绩效</div>
				<div style="width: 60px;line-height: 22px;float: right;text-align: center;color: #8C8C8C;font-weight: bold;display: none;">目标绩效</div>
			</div>
			<%if(hasitem){%>
			<div id="show1" class="show" style="width: 100%;height: auto;">
				<div id="tabdiv" style="width: 100%;height: auto;background: #F6F6F6;border-bottom: 1px #EBEBEB solid;table-layout: fixed">
					<table id="tabtable" class="tabtable" style="width:auto;" cellpadding="0" cellspacing="0" border="0">
						<tr>
							<%for(int i=0;i<accessitem.size();i++){%>
								<td class="tab2" _itemid="<%=accessitem.get(i) %>"
								 <%if(duplitem.indexOf(accessitem.get(i))>-1){ %> _desc="<%=descitem.get(i) %>" <%}else{ %> _desc="-1" <%} %>
								 title="<%=Util.convertDB2Input((String)descitem.get(i)) %>">
									<%=AccessItemComInfo.getName((String)accessitem.get(i)) %>
								</td>
							<%}%>
						</tr>
					</table>
				</div>
				<div id="showreport" style="width: 100%;height: 155px;margin-top: 4px;"></div>
			</div>
			<%} %>
			
			<div id="tabdiv" style="width: 100%;height: auto;background: #F6F6F6;border-bottom: 1px #EBEBEB solid;border-top: 1px #EBEBEB solid;table-layout: fixed">
				<table id="tabtable" class="tabtable" style="width:auto;" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td class="tab2">定性指标</td>
					</tr>
				</table>
			</div>
			<div style="width: 100%;height: <%if(hasitem){%>80px<%}else{ %>270px<%} %>;overflow: auto;overflow-x: hidden;" class="show">
			<ul class="list" onclick="">
			<%
				for(int i=0;i<accessitem2.size();i++){
			%>
				<li title="<%=Util.convertDB2Input((String)accessitem2.get(i))%>">
					<%=Util.getMoreStr(Util.convertDB2Input((String)accessitem2.get(i)), 30, "...") %>
				</li>
			<%	} %>
			</ul>
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
				
				$("td.tab2").bind("mouseover",function(){
					$(this).addClass("tab2_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("tab2_hover");
				}).bind("click",function(){
					$("td.tab2").removeClass("tab2_click");
					$(this).addClass("tab2_click");
					var _itemid = $(this).attr("_itemid");
					var _desc = $(this).attr("_desc");
					$("#showreport").load("/performance/util/Report.jsp?accessitemid="+_itemid+"&itemdesc="+_desc);

					if($("#tabtable").width()>$("#tabdiv").width()){
						$("#tabtable").width("100%").css("table-layout","fixed");
					}
				});

				<%if(hasitem){%>
					$("td.tab2")[0].click();
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