<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="TransUtil" class="weaver.wxinterface.TransUtil" scope="page" />
<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	
	User user = HrmUserVarify.getUser (request , response) ;
	if(user==null){
		return;
	}
	
	
	int type = Util.getIntValue(request.getParameter("type"),0);
	int resultstatus = Util.getIntValue(request.getParameter("resultstatus"),-1000);
	String receiveusers = Util.null2String(request.getParameter("receiveusers"));
	String content = Util.null2String(request.getParameter("content"));
	String scantime = Util.null2String(request.getParameter("scantime"));
	
	String backfields = " * ";
	String fromSql = " from WX_SCANLOG";
	String sqlWhere = " where 1=1";
	if(type!=0){
		sqlWhere += " and type="+type;
	}
	if(resultstatus!=-1000){
		sqlWhere += " and resultstatus="+resultstatus;
	}
	if(!receiveusers.equals("")){
		sqlWhere +=" and receiveusers like '%"+receiveusers+"%'";
	}
	if(!content.equals("")){
		sqlWhere +=" and content like '%"+content+"%'";
	}
	if(!scantime.equals("")){
		sqlWhere +=" and scantime like '%"+scantime+"%'";
	}
	String orderby1 = " order by scantime desc ";
	String orderby2 = " order by scantime asc ";
	String orderby3 = " order by scantime desc ";
	
	int iTotal = 0; 
	int pagesize = 20;
	rs.executeSql("select count(id) "+fromSql+sqlWhere.toString());
	if(rs.next()) iTotal = rs.getInt(1);
	
	int totalpage = iTotal / pagesize;
	if(iTotal % pagesize >0) totalpage += 1;
	int pagenum = Util.getIntValue(request.getParameter("pagenum"),1);
	if(pagenum>totalpage) pagenum=1;
	int iNextNum = pagenum * pagesize;
	int ipageset = pagesize;
	if(iTotal - iNextNum + pagesize < pagesize) ipageset = iTotal - iNextNum + pagesize;
	if(iTotal < pagesize) ipageset = iTotal;
	
	String sql = "select top " + ipageset +" A.* from (select top "+ iNextNum + backfields + fromSql + sqlWhere + orderby3 + ") A "+orderby2;
	sql = "select top " + ipageset +" B.* from (" + sql + ") B "+orderby1;
	
	if(rs.getDBType().equals("oracle")){
		//sqltemp="select * from (select * from  "+temptable1+" order by id) where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1);
		sql = "select * from  WX_SCANLOG order by scantime desc";
		sql = "select t2.*,rownum rn from (" + sql + ") t2 where rownum <= " + iNextNum;
		sql = "select t3.* from (" + sql + ") t3 where rn > " + (iNextNum - pagesize);
	}
	rs.executeSql(sql);
%>
<HTML>
	<head>
		<title>消息推送记录</title>
		
		<script type='text/javascript' src="../js/jquery-1.8.3.min.js"></script>
	 	<script type='text/javascript' src="../js/jquery.form.js"></script>
		
		<link rel="stylesheet" href="../js/showLoading/css/showLoading.css">
		<script type='text/javascript' src="../js/showLoading/js/jquery.showLoading.js"></script>
		
		<link rel="stylesheet" href="../js/zdialog/zDialog_e8.css" />
		<script type='text/javascript' src="../js/zdialog/zDialog.js"></script>
		<script type='text/javascript' src="../js/zdialog/zDrag.js"></script>
		<script type='text/javascript' src="../js/util.js"></script>
		<script src="../js/init.js"></script>
		
		<link rel="stylesheet" type="text/css" href="../css/main.css" />
		
		<link rel="stylesheet" href="../css/new.css?1" />
		<style type="text/css">
			a{
				cursor: pointer;
			}
			a:hover{
				color: blue;
			}
			.typeSpan{
				font-weight: bold;
				color: #333;
				margin-right:2px;
			}
			.flowSpan{
				color:#666;
				margin-right:2px;
			}
			.datalist{width: 100%;table-layout:fixed;}
			.datalist td{padding-left: 2px;padding-top: 8px;padding-bottom: 8px;
						line-height: 18px;vertical-align: top;
						border-bottom: 1px #F3F3F3 solid; 
						word-break: keep-all;white-space: nowrap;
						overflow:hidden;
						text-overflow: ellipsis;
						}
			.datalist tr.head td{font-weight: bold;background: #F3F3F3;}
			.pagetable{width: 100%;margin-top:10px;}
			.tobutton{width: 50px;height: 22px;background: #F5F5F5;border: 0px;cursor: pointer;}
			.tobutton_hover{background: #0080C0;color: #fff;}
			.selectDiv{
				float:left;
				margin-right:10px;
				height:26px;
				line-height:26px;
				vertical-align:middle;
			}
			.selectDiv select,input{
				height:26px;
				line-height:26px;
				border:1px solid #aecef1;
			}
		</style>
	</head>
	<body style="overflow: auto;">
		<form id="searchForm" name="searchForm" action="" method="post">
			<input type="hidden" id="pagenum" name="pagenum" value="1"/>
			<table style="width: 100%;">
				<colgroup>
					<col width="10px"/>
					<col width="*"/>
					<col width="10px"/>
				</colgroup>
				<tr>
					<td></td>
					<td>
						<div class="coboxhead" id="searchTable">
							<div class="co_tablogo"></div>
							<div class="co_ultab">
								<div class="co_navtab">消息推送记录</div>
								<div>
									<ul class="co_tab_menu" style="display: none;">
						   			</ul>
						   			<div class="co_outbox">
							   			<div class="co_rightBox">
							   				<div class="selectDiv">
							   				类型：<select name="type" id="type">
							   						<option value="0">请选择</option>
							   						<option value="1">流程</option>
													<option value="2">文档</option>
													<option value="3">消息</option>
													<option value="4">协作</option>
													<option value="5">日程</option>
													<option value="6">会议</option>
													<!-- 
													<option value="7">项目</option>
													 -->
													<option value="8">客户</option>
													<option value="9">任务</option>
													<option value="10">微博</option>
													<option value="11">邮件</option>
							   					</select>&nbsp;&nbsp;
							   				状态：<select name="resultstatus" id="resultstatus">
							   						<option value="">请选择</option>
							   						<option value="0">成功</option>
							   						<option value="-1">失败</option>
							   					</select>&nbsp;&nbsp;
							   				接收人：<input type="text" name="receiveusers" value="<%=receiveusers%>"/>	
							   				&nbsp;&nbsp;
							   				发送内容：<input type="text" name="content" value="<%=content%>"/>
							   				&nbsp;&nbsp;
							   				发送时间：<input type="text" name="scantime" value="<%=scantime%>"/>
							   				</div>
							   				<div class="co_btn" id="submitSelect">查询</div>
							   				<div class="co_btn" id="msgrule">消息推送设置</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="co_tab_box" id="co_tab_box">
							<table class="datalist" width=100% border="0" cellspacing="0" cellpadding="0">
								<colgroup>
									<col width="30px" />
									<col width="50px" />
									<col width="60px" />
									<col width="30%" />
									<col width="*" />
									<col width="60px" />
									<col width="10%" />
									<col width="160px" />
								</colgroup>
								<tr class="head">
									<td>序号</td>
									<td>类型</td>
									<td>数据ID</td>
									<td>发送内容</td>
									<td>接收人</td>
									<td>发送状态</td>
									<td>返回结果</td>
									<td>发送时间</td>
								</tr>
							<%
								int i=1;
								while(rs.next()){
									
							%>
								<tr>
									<td><%=i %></td>
									<td><%=TransUtil.getWDTypeName(Util.null2String(rs.getString("type"))) %></td>
									<td><%=Util.null2String(rs.getString("reourceid")) %></td>
									<td title="<%=Util.null2String(rs.getString("content")) %>"><%=Util.null2String(rs.getString("content")) %></td>
									<td title="<%=rs.getString("receiveusers")%>">
									<%=Util.null2String(rs.getString("receiveusers")) %></td>
									<td><%=Util.getIntValue(rs.getString("resultstatus"))==0?"成功":"失败" %></td>
									<td title="<%=Util.null2String(rs.getString("resultcontent")) %>"><%=Util.null2String(rs.getString("resultcontent")) %></td>
									<td><%=Util.null2String(rs.getString("scantime")) %></td>
								</tr>
							<%	i++;} %>
							</table>
							<table class="pagetable" cellpadding="0" cellspacing="0" border="0">
								<tr>
									<td align="right">
										&raquo; 共<%=iTotal%>条记录&nbsp&nbsp&nbsp每页<%=pagesize%>条&nbsp&nbsp&nbsp共<%=totalpage%>页&nbsp&nbsp&nbsp当前第<%=pagenum%>页&nbsp&nbsp
										<%if(pagenum > 1){%>
										<A onClick="toFirstPage()" >首页</A>
										<A onClick="toPrePage('<%=pagenum%>')">上一页</A>
										<%} else {%>
											首页  上一页
										<%}%>
										<%if(pagenum < totalpage){%>
											<A  onClick="toNextPage('<%=pagenum%>')">下一页</A>
											<A  onClick="toLastPage('<%=totalpage%>')">尾页</A>
										<%} else {%>
											下一页 尾页
										<%}%>
										&nbsp;<button class="tobutton" onClick="toGoPage('topagenum1')">转到</button>&nbsp;第<input id='topagenum1' name='' type="text" value="<%=pagenum%>" size="2" class="text" style="text-align:right"/>页
									</td>
								</tr>
							</table>
						</div>
					</td>
					<td></td>
				</tr>
			
			</table>
		</form>
		<script type="text/javascript">
			$(document).ready(function(){
				$("#type").val("<%=type%>");
				$("#resultstatus").val("<%=resultstatus%>");
				$("#submitSelect").click(function(){
					jQuery("#searchForm").submit();
				});
				$("#msgrule").click(function(){
					location.href = "MsgRuleSetting.jsp";
				});
			});
			function onSearch(){
				jQuery("#searchForm").submit();
			}
			function toFirstPage(){
				jQuery("#pagenum").val(1);
				onSearch();
			}
		 	document.onkeydown=keyListener;
			function keyListener(e){
			    e = e ? e : event;   
			    if(e.keyCode == 13){
			    	onSearch();
			    }    
			}
			function toPrePage(currentpage){
				if(currentpage == 1) {
					return;
				}
				jQuery("#pagenum").val(Number(currentpage) - 1);
				onSearch();
			}
			function toNextPage(currentpage){
				if(currentpage == <%=totalpage%>) {
					return;
				}
				jQuery("#pagenum").val(Number(currentpage) + 1);
				onSearch();
			}
			function toLastPage(lastpage){
				jQuery("#pagenum").val(lastpage);
				onSearch();
			}
			function toGoPage(topageid){
				var topage = jQuery("#"+topageid).val();
				if(topage == <%=pagenum%>) return;
				if(topage > <%=totalpage%>) 
				{
					jQuery("#pagenum").val(<%=pagenum%>);
					return;
				}
				jQuery("#pagenum").val(topage);
				onSearch();
			}
		</script>
	</body>
</html>