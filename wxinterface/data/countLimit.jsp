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
	if(user==null||user.getUID()!=1){
		return;
	}
	
	String backfields = " * ";
	String fromSql = " from WX_SignCountLimit";
	String sqlWhere = " where 1=1";
	
	String orderby1 = " order by createtime desc ";
	String orderby2 = " order by createtime asc ";
	String orderby3 = " order by createtime desc ";
	
	int iTotal = 0; 
	int pagesize = 15;
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
		sql = "select "+backfields + fromSql + sqlWhere + orderby3;
		sql = "select t2.*,rownum rn from (" + sql + ") t2 where rownum <= " + iNextNum;
		sql = "select t3.* from (" + sql + ") t3 where rn > " + (iNextNum - pagesize);
	}
	rs.executeSql(sql);
%>
<HTML>
	<head>
		<title>΢�ſ��ڴ�������</title>
		
		<script type='text/javascript' src="../js/jquery-1.8.3.min.js"></script>
	 	<script type='text/javascript' src="../js/jquery.form.js"></script>
		
		<link rel="stylesheet" href="../js/showLoading/css/showLoading.css">
		<script type='text/javascript' src="../js/showLoading/js/jquery.showLoading.js"></script>
		
		<link rel="stylesheet" href="../js/zdialog/zDialog_e8.css" />
		<script type='text/javascript' src="../js/zdialog/zDialog_wev8.js"></script>
		<script type='text/javascript' src="../js/zdialog/zDrag_wev8.js"></script>
		<script type='text/javascript' src="../js/util.js?100"></script>
		<script type='text/javascript' src="../js/init_wev8.js"></script>
		
		<link rel="stylesheet" type="text/css" href="../css/main_wev8.css" />
		
		<style type="text/css">
			.typeSpan{
				font-weight: bold;
				color: #333;
				margin-right:2px;
			}
			.flowSpan{
				color:#666;
				margin-right:2px;
			}
			.datalist{width: 100%;}
			.datalist td{padding-left: 2px;padding-top: 8px;padding-bottom: 8px;line-height: 18px;vertical-align: top;
				border-bottom: 1px #F3F3F3 solid; }
			.datalist tr.head td{font-weight: bold;background: #F3F3F3;}
			.scroll{max-height: 100px;overflow: auto;}
			.pagetable{width: 100%;margin-top:10px;}
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
								<div class="co_navtab">΢�ſ��ڴ�������</div>
								<div>
									<ul class="co_tab_menu" style="display: none;">
						   			</ul>
						   			<div class="co_outbox">
						   				<div class="co_leftBox" style="color:red;"></div>
							   			<div class="co_rightBox">
								   			<div style="float:left;">
												<div class="co_btn" id="newAgent">�½�</div>
												<div class="co_btn" id="allDelete">����ɾ��</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="co_tab_box" id="co_tab_box">
							<table class="datalist" width=100% border="0" cellspacing="0" cellpadding="0">
								<tr class="head">
									<td style="text-align: center;"><input type="checkbox" id="checkall" onclick="checkAll()"/></td>
									<td>���</td>
									<td>��������</td>
									<td>����ID</td>
									<td>���ƴ���</td>
									<td>����ʱ��</td>
									<td>����</td>
								</tr>
							<%
								int i=1;
								while(rs.next()){
							%>
								<tr>
									<td style="text-align: center;"><input type="checkbox" class="check" _val="<%=Util.null2String(rs.getString("id")) %>"/></td>
									<td><%=i %></td>
									<td><%=TransUtil.getResourceType(Util.null2String(rs.getString("resourcetype"))) %></td>
									<td><%=TransUtil.getResourceNames(Util.null2String(rs.getString("resourcetype")),Util.null2String(rs.getString("resourceids"))) %></td>
									<td><%=Util.null2String(rs.getString("countlimit")) %></td>
									<td><%=Util.null2String(rs.getString("createtime")) %></td>
									<td><a href='javascript:doUpdate(<%=Util.null2String(rs.getString("id")) %>)'>�༭</a></td>
								</tr>
							<%	i++;} %>
							</table>
							<table class="pagetable" cellpadding="0" cellspacing="0" border="0">
								<tr>
									<td align="right">
										&raquo; ��<%=iTotal%>����¼&nbsp&nbsp&nbspÿҳ<%=pagesize%>��&nbsp&nbsp&nbsp��<%=totalpage%>ҳ&nbsp&nbsp&nbsp��ǰ��<%=pagenum%>ҳ&nbsp&nbsp
										<%if(pagenum > 1){%>
										<A onClick="toFirstPage()" >��ҳ</A>
										<A onClick="toPrePage('<%=pagenum%>')">��һҳ</A>
										<%} else {%>
											��ҳ  ��һҳ
										<%}%>
										<%if(pagenum < totalpage){%>
											<A  onClick="toNextPage('<%=pagenum%>')">��һҳ</A>
											<A  onClick="toLastPage('<%=totalpage%>')">βҳ</A>
										<%} else {%>
											��һҳ βҳ
										<%}%>
										&nbsp;<button class="tobutton" onClick="toGoPage('topagenum1')">ת��</button>&nbsp;��<input id='topagenum1' name='' type="text" value="<%=pagenum%>" size="2" class="text" style="text-align:right"/>ҳ
									</td>
								</tr>
							</table>
						</div>
					</td>
					<td></td>
				</tr>
			
			</table>
		</form>
		<div id="addMConfigDiv" style="position:relative ;display:none;">
			<div class="coboxhead">
				<div class="co_tablogo"></div>
				<div class="co_ultab">
					<div class="co_navtab">�½�����</div>
					<div>
						<ul class="co_tab_menu" style="width:453px;display: none;"></ul>
			   			<div class="co_outbox">
				   			<div class="co_rightBox">
					   			<div>
									<div class="co_btn saveMConfig">����</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="co_tab_box" id="openDiv" style="overflow:auto;height:300px;">
				<form action="countLimitOperation.jsp" method="post" id="addForm">
				<input type="hidden" name="operation" value="addCountLimit"/>
				<input type="hidden" name="clid" id="clid" value=""/>
				<div class="addTableDiv">
					<table class="co_tblForm">
						<colgroup><col width="25%" /><col width="75%" /></colgroup>
						<tr>
							<td class="title">��������</td>
							<td class="data">
								<select id="resourcetype" name="resourcetype">
									<option value="1">�ֲ�</option>
									<option value="2">����</option>
								</select>
						  	</td>
						</tr>
						<tr>
							<td class="title">����ID</td>
							<td class="data" >
								<input type="hidden" id="resourceids" name="resourceids"/>
								<span class="mcBrowser" style="display: inline-block;"></span>
								<span id="resourcenames"></span>
							</td>
						</tr>
						<tr>
							<td class="title">����΢��ǩ������</td>
							<td class="data" >
								<input type="text" name="countlimit" id="countlimit" class="input_def"/>
							</td>
						</tr>
					</table>
				</div>
				</form>
			</div>
			<div class="co_dialog_bottom">
				<table width="100%">
					<tr>
						<td align="right">
							<div class="co_dig_btn saveMConfig">����</div>
						</td>
						<td align="left">
							<div class="co_dig_btn" id="closeDialog">�ر�</div>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<script type="text/javascript">
			$(document).ready(function(){
				$("#newAgent").click(function(){
					reset();
					openDialog("�½�����","",1,"addMConfigDiv");
				});
				$("#resourcetype").change(function(){
					$("#resourceids").val("");
					$("#resourcenames").html("");
				});
				$(".mcBrowser").click(function(){
					var type = $("#resourcetype").val();
					var resourceids = $("#resourceids").val();
					openDialog2(type==1?"ѡ��ֲ�":"ѡ����",
							"/wxinterface/data/selectResource.jsp?resourceids="+resourceids+"&resourcetype="+type,0);
				});
				$(".saveMConfig").click(function(){
					var resourceids = $.trim($("#resourceids").val());
					if(resourceids==""){
						CoDialog.alert("��ѡ��ֲ����߲���");
						return false;
					}
					var countlimit = $("#countlimit").val();
					if(countlimit==""){
						CoDialog.alert("������΢��ǩ����������");
						return false;
					}
					var r = /^[0-9]*[0-9][0-9]*$/;
					if(isNaN(countlimit)||!r.test(countlimit)){
						CoDialog.alert("΢��ǩ���������Ʊ���������");
						return false;
					}
					$("#addMConfigDiv").showLoading();
					$("#addForm").ajaxSubmit({
						dataType:"json",
						success:function(data){
							if(data.status==0){
								CoDialog.alert("����ɹ�");
								reset();
								dlg.close();
								window.location.reload();
							}else{
								CoDialog.alert(data.msg);
							}
						},
						complete:function(){
							$("#addMConfigDiv").hideLoading();
						}
					});
				});
				$("#allDelete").click(function(){//ȫ��ɾ����ť��������
					deleteBatch();
				});
			});
			function doUpdate(id) {
				reset();
				$.ajax({
					url:"countLimitOperation.jsp",
					data:{"id":id,"operation":"getCl"},
					dataType:"json",
					success:function(data){
						if(data.status==0){
							$("#clid").val(data.id);
							$("#resourcetype").val(data.resourcetype).change();
							$("#resourceids").val(data.resourceids);
							$("#resourcenames").html(data.resourcenames);
							$("#countlimit").val(data.countlimit);
							openDialog("�༭����","",1,"addMConfigDiv");
						}else{
							CoDialog.alert(data.msg);
						}
					}
				});
			}
			function doDelete(ids) {
				CoDialog.confirm("ȷ��ɾ����������?",function(){
					$("#co_tab_box").showLoading();
					jQuery.ajax({
						type: "post",
						url: "countLimitOperation.jsp",
					    data:{"operation":"delCl","ids":ids},
					    dataType:"json",
					    success:function(data){
					    	if(data.status==0){
					    		window.location.reload();
					    	}else{
					    		CoDialog.alert(data.msg);
					    	}
					    },
					    complete: function(data){
						    $("#co_tab_box").hideLoading();
					    }
				    });
				});
			}
			
			function deleteBatch(){
				var selectedIds = "";
				$(".check:checked").each(function(){
					if($(this).attr("_val")!=""){
						selectedIds += "," + $(this).attr("_val");
					}
				});
				if(selectedIds == ""){
					CoDialog.alert("��ѡ��Ҫɾ��������!");
					return;
				}else{
					selectedIds = selectedIds.substring(1);
				}
				doDelete(selectedIds);
			}
			function checkAll(){
				if($("#checkall").attr("checked")){
					$(".check").attr("checked",true);
				}else{
					$(".check").attr("checked",false);
				}
			}
			function reset(){
				$("#clid").val("");
				$("#resourcetype").val("1").change();
				$("#resourceids").val("");
				$("#resourcenames").val("");
				$("#countlimit").val("");
			}
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
			var dlg2=null;
			function openDialog2(title,url,type,eid,width,height) {
				dlg2 = new CoDialog();
				dlg2.currentWindow = window;
				dlg2.Model=true;
				if(typeof(width)=="undefined"){
					dlg2.Width=500;//���峤��
				}else{
					dlg2.Width=width;//���峤��
				}
				if(typeof(height)=="undefined"){
					dlg2.Height=400;
				}else{
					dlg2.Height=height;
				}
				if(type==0){
					dlg2.URL=url;
				}else{
					dlg2.InvokeElementId=eid;
				}
				dlg2.Title=title;
				dlg2.maxiumnable=true;
				dlg2.show();
			}
		</script>
	</body>
</html>