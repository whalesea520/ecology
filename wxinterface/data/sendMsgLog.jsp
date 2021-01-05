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
	String backfields = " * ";
	String fromSql = " from WX_SENDMSGLOG";
	String sqlWhere = " where 1=1";
	//if(user.getUID()!=1){
		sqlWhere = " where senduserid = "+user.getUID();
	//}
	String orderby1 = " order by createtime desc ";
	String orderby2 = " order by createtime asc ";
	String orderby3 = " order by createtime desc ";
	
	int iTotal = 0; 
	int pagesize = 10;
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
		sql = "select * from  WX_SENDMSGLOG order by createtime desc";
		sql = "select t2.*,rownum rn from (" + sql + ") t2 where rownum <= " + iNextNum;
		sql = "select t3.* from (" + sql + ") t3 where rn > " + (iNextNum - pagesize);
	}
	rs.executeSql(sql);
%>
<HTML>
	<head>
		<title>发送微信消息记录</title>
		
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
			.datalist td{padding-left: 2px;padding-top: 8px;padding-bottom: 8px;line-height: 18px;vertical-align: top;
				border-bottom: 1px #F3F3F3 solid; }
			.datalist tr.head td{font-weight: bold;background: #F3F3F3;}
			.pagetable{width: 100%;margin-top:10px;}
			.tobutton{width: 50px;height: 22px;background: #F5F5F5;border: 0px;cursor: pointer;}
			.tobutton_hover{background: #0080C0;color: #fff;}
			.content{
				width:100%;
				height:80px;
				overflow:auto; 
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
								<div class="co_navtab">发送微信消息记录</div>
								<div>
									<ul class="co_tab_menu" style="display: none;">
						   			</ul>
						   			<div class="co_outbox">
							   			<div class="co_rightBox">
							   				<div class="co_btn" id="sendMsg">发送消息</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="co_tab_box" id="co_tab_box">
							<table class="datalist" width=100% border="0" cellspacing="0" cellpadding="0">
								<tr class="head">
									<td width="100">发送人</td>
									<td width="25%">接收人</td>
									<td width="100">文档类型</td>
									<td width="25%">发送内容</td>
									<td width="100">是否发送成功</td>
									<td width="*">失败原因</td>
									<td width="120">发送时间</td>
								</tr>
							<%
								while(rs.next()){
									int sendType = Util.getIntValue(rs.getString("sendtype"),1);
									String typeNames = "文字消息";
									if(sendType==13){
										typeNames = "文档群发";
									}else if(sendType==12){
										typeNames = "微信新闻群发";
									}
									String receiveUsers = Util.null2String(rs.getString("receiveuserids"));
									if(receiveUsers.equalsIgnoreCase("@all")){
										receiveUsers = "所有微信用户";
									}else if(receiveUsers.equalsIgnoreCase("@alldepart")){
										receiveUsers = "所有OA员工";
									}else{
										receiveUsers = TransUtil.getHrm(receiveUsers);
									}
							%>
								<tr>
									<td><%=TransUtil.getHrm(Util.null2String(rs.getString("senduserid"))) %></td>
									<td>
										<div class="content"><%=receiveUsers %></div>
									</td>
									<td><%=typeNames %></td>
									<td><div class="content"><%=Util.null2String(rs.getString("content")) %></div></td>
									<td><%=Util.getIntValue(rs.getString("ifsend"))==0?"否":"是" %></td>
									<td><%=Util.null2String(rs.getString("errormsg")) %></td>
									<td><%=Util.null2String(rs.getString("createtime")) %></td>
								</tr>
							<%	} %>
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
				$("#sendMsg").click(function(){
					location.href="sendMsg.jsp";
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