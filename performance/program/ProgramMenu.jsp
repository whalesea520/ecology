<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="OperateUtil" class="weaver.gp.util.OperateUtil" scope="page" />
<%
	int type = Util.getIntValue(request.getParameter("type"),1);
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
<HTML>
	<HEAD>
		<LINK rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css">
		<style type="text/css">
			.tab{width: 125px;float: left;line-height: 30px;text-align: center;cursor: pointer;font-size: 13px;margin-top: 0px;}
			.tab_hover{background: #F3F3F3;color: #000;}
			.tab_click{background: #ECECEC;color: #000;}
		</style>
	</HEAD>
	<BODY style="overflow: hidden;">
		<form id="menuform" name="menuform" action="" method="post" target="pageBottom">
		</form>
		<div style="width: 100%;height: 30px;border-bottom:2px #ECECEC solid;font-size: 14px;font-weight: bold;margin-bottom: 0px;">
			<div class="tab <%if(type==1){ %>tab_click<%} %>" _url="ProgramFrame.jsp">我的考核方案</div>
			<div class="tab <%if(type==2){ %>tab_click<%} %>" _url="ProgramAudit.jsp">待审核方案<%if(auditamount>0){ %><font style="color: red;">(<%=auditamount %>)</font><%} %></div>
			<div class="tab <%if(type==3){ %>tab_click<%} %>" _url="ProgramList.jsp">方案设置查询<%if(nosetamount>0){ %><font style="color: red;">(<%=nosetamount %>)</font><%} %></div>
		</div>
		
		<script type="text/javascript">
			$(document).ready(function(){
				$("div.tab").bind("mouseover",function(){
					$(this).addClass("tab_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("tab_hover");
				}).bind("click",function(){
					$("div.tab").removeClass("tab_click");
					$(this).addClass("tab_click");
					var _url = $(this).attr("_url");
					$("#menuform").attr("action",_url);
					$("#menuform").submit();
				});	
			});
		</script>
	</BODY>
</HTML>