<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="OperateUtil" class="weaver.gp.util.OperateUtil" scope="page" />
<%
	int type = Util.getIntValue(request.getParameter("type"),1);
	String defaultpage = "ProgramFrame.jsp";
	if(type==2){
		defaultpage = "ProgramAudit.jsp";
	}else if(type==3){
		int nofyear = Util.getIntValue(request.getParameter("nofyear"),0);
		int nohyear = Util.getIntValue(request.getParameter("nohyear"),0);
		int noquarter = Util.getIntValue(request.getParameter("noquarter"),0);
		int nomonth = Util.getIntValue(request.getParameter("nomonth"),0);
		defaultpage = "ProgramList.jsp?nofyear="+nofyear+"&nohyear="+nohyear+"&noquarter="+noquarter+"&nomonth="+nomonth;
	}
	//查询待审核方案个数
	int auditamount = 0;
	String sql = "select count(t1.id) as amount"
		+" from GP_AccessProgram t1,GP_AccessProgramAudit t2 "
		+" where t1.id=t2.programid and t2.userid="+user.getUID();
	rs.executeSql(sql);
	if(rs.next()){
		auditamount = Util.getIntValue(rs.getString(1),0);
	}
	
	//查询未设置方案个数
	int[] amounts = OperateUtil.getNoProgramCount(user.getUID()+"");
	int amount1 = amounts[0];
	int amount2 = amounts[1];
	int amount3 = amounts[2];
	int amount4 = amounts[3];
	int nosetamount = amount1+amount2+amount3+amount4;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh-CN" lang="zh-CN">
	<head>
		<title>绩效考核方案</title>
		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET />
		<style type="text/css">
			.tab{width: 125px;float: left;line-height: 30px;text-align: center;cursor: pointer;font-size: 13px;margin-top: 0px;}
			.tab_hover{background: #F3F3F3;color: #000;}
			.tab_click{background: #ECECEC;color: #000;}
		</style>
	<%@ include file="/secondwev/common/head.jsp" %>
	</head>
	<BODY style="overflow: hidden;">
		<div id="dtab" style="width: 100%;height: 30px;border-bottom:2px #ECECEC solid;font-size: 14px;font-weight: bold;margin-bottom: 0px;">
			<div class="tab <%if(type==1){ %>tab_click<%} %>" _url="ProgramFrame.jsp">我的考核方案</div>
			<div class="tab <%if(type==2){ %>tab_click<%} %>" _url="ProgramAudit.jsp">待审核方案<%if(auditamount>0){ %><font style="color: red;">(<%=auditamount %>)</font><%} %></div>
			<div class="tab <%if(type==3){ %>tab_click<%} %>" _url="ProgramList.jsp">方案设置查询<%if(nosetamount>0){ %><font style="color: red;">(<%=nosetamount %>)</font><%} %></div>
		</div>
		<div id="view" style="width:100%;height:100%;background: #fff;">
			<iframe id="dataframe" name="pageTop" src="<%=defaultpage %>" style="width: 100%;height:100%;" scrolling="auto" frameborder="0"></iframe>
		</div>
		<script type="text/javascript">
			$(document).ready(function(){
			    $("#view").height($("BODY").height()-$("#dtab").height());
			
				$("div.tab").bind("mouseover",function(){
					$(this).addClass("tab_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("tab_hover");
				}).bind("click",function(){
					$("div.tab").removeClass("tab_click");
					$(this).addClass("tab_click");
					var _url = $(this).attr("_url");
					$("#dataframe").attr("src",_url);
				});	
			});
		</script>
	</BODY>
</html>