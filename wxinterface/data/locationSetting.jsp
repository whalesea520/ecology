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
	
	String name= Util.null2String(request.getParameter("name"));

	String backfields = "id,address,distance,resourceids,resourcetype,lat,lng,ifforce,createtime";
	String fromSql = " WX_LocationSetting";
	String sqlWhere = " where 1=1";
	
	String sql = "select "+ backfields + " from " + fromSql + sqlWhere + " order by createtime desc";
	
%>
<HTML>
	<head>
		<title>微信考勤地理位置设置</title>
		
		<script type='text/javascript' src="../js/jquery-1.8.3.min.js"></script>
	 	<script type='text/javascript' src="../js/jquery.form.js"></script>
		
		<link rel="stylesheet" href="../js/showLoading/css/showLoading.css">
		<script type='text/javascript' src="../js/showLoading/js/jquery.showLoading.js"></script>
		
		<link rel="stylesheet" href="../js/zdialog/zDialog_e8.css" />
		<script type='text/javascript' src="../js/zdialog/zDialog.js"></script>
		<script type='text/javascript' src="../js/zdialog/zDrag.js"></script>
		<script type='text/javascript' src="../js/util.js"></script>
		<script charset="utf-8" src="http://map.qq.com/api/js?v=1"></script>
		
		<link rel="stylesheet" type="text/css" href="../css/main.css" />
		
		<link rel="stylesheet" href="../css/new.css?1" />
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
		</style>
	</head>
	<body style="overflow: auto;">
		<form id="searchForm" name="searchForm" action="" method="post">
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
								<div class="co_navtab">考勤地理位置设置</div>
								<div>
									<ul class="co_tab_menu" style="display: none;">
						   			</ul>
						   			<div class="co_outbox">
						   				<div class="co_leftBox" style="color:red;">提示：请在【e-Bridge-外部系统集成-考勤设置】中进行设置</div>
							   			<div class="co_rightBox">
								   			<div style="float:left;">
								   				<!-- 
												<div class="co_btn" id="newAgent">新建</div>
												<div class="co_btn" id="allDelete">批量删除</div>
												 -->
												<div class="co_btn" id="msgRule">消息推送设置</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="co_tab_box" id="co_tab_box">
							<table class="datalist" width=100% border="0" cellspacing="0" cellpadding="0">
								<tr class="head">
									<td style="text-align: center;width:20px;"><input type="checkbox" id="checkall" onclick="checkAll()"/></td>
									<td>类型</td>
									<td>分部/部门</td>
									<td>地理位置</td>
									<td>经度</td>
									<td>纬度</td>
									<td>距离</td>
									<td>是否强制</td>
								</tr>
							<%
								rs.executeSql(sql);
								while(rs.next()){
									int ifForce = Util.getIntValue(rs.getString("ifforce"),0);
									String text = "否";
									if(ifForce==1){
										text = "是";
									}
							%>
								<tr>
									<td style="text-align: center;"><input type="checkbox" class="check" _val="<%=Util.null2String(rs.getString("id")) %>"/></td>
									<td><%=TransUtil.getResourceType(Util.null2String(rs.getString("resourcetype"))) %></td>
									<td><%=TransUtil.getResourceNames(Util.null2String(rs.getString("resourcetype")),Util.null2String(rs.getString("resourceids"))) %></td>
									<td><%=Util.null2String(rs.getString("address")) %></td>
									<td><%=Util.null2String(rs.getString("lng")) %></td>
									<td><%=Util.null2String(rs.getString("lat")) %></td>
									<td><%=Util.null2String(rs.getString("distance")) %>米</td>
									<td><%=text %></td>
									<!-- 
									<td><a href='javascript:doUpdate(<%=Util.null2String(rs.getString("id")) %>)'>编辑</a></td>
									 -->
								</tr>
							<%	} %>
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
					<div class="co_navtab">考勤地理位置设置</div>
					<div>
						<ul class="co_tab_menu" style="width:453px;display: none;"></ul>
			   			<div class="co_outbox">
				   			<div class="co_rightBox">
					   			<div>
									<div class="co_btn saveMConfig">保存</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="co_tab_box" id="openDiv" style="overflow:auto;height:auto;">
				<form action="locationOperate.jsp" method="post" id="addForm">
				<input type="hidden" name="operate" value="addOrUpdateLS"/>
				<input type="hidden" name="lsid" id="lsid" value=""/>
				<div class="addTableDiv">
					<table class="co_tblForm">
						<colgroup><col width="25%" /><col width="75%" /></colgroup>
						<tr>
							<td class="title">地址位置:</td>
							<td class="data">
						  		<input type="text" id="address" class="input_def" name="address" placeholder="请输入地理位置(包含省市)"/>
						  		<div style="line-height: 24px;color: green;padding-left: 2px;">提示：输入地理位置后系统会自动获取经纬度信息同时在下面地图中标注，可根据需要对标注进行拖动调整！</div>
						  	</td>
						</tr>
						<tr>
							<td class="title">经度:</td>
							<td class="data">
						  		<input type="text" id="lng" class="input_def" name="lng" placeholder="请输入经度"/>
						  	</td>
						</tr>
						<tr>
							<td class="title">纬度:</td>
							<td class="data">
						  		<input type="text" id="lat" class="input_def" name="lat" placeholder="请输入纬度"/>
						  	</td>
						</tr>
						<tr>
							<td class="title">距离设置:</td>
							<td class="data">
						  		<input type="text" id="distance" class="input_def" name="distance" placeholder="请输入地址位置限制(单位:米),设为0则表示不限制距离"/>
						  	</td>
						</tr>
						<tr>
							<td class="title">数据类型:</td>
							<td class="data">
								<select id="resourcetype" name="resourcetype">
									<option value="0">全部</option>
									<option value="1">分部</option>
									<option value="2">部门</option>
								</select>
								<div style="line-height: 24px;color: green;padding-left: 2px;">提示：数据类型优先判断部门,其次分部,最后判断全部！</div>
						  	</td>
						</tr>
						<tr id="resourceTr" style="display:none;">
							<td class="title">选择数据</td>
							<td class="data">
								<input type="hidden" id="resourceids" name="resourceids" value=""/>
								<div class="mcBrowser" style="display: inline-block;"></div>
								<span id="resourcenames"></span>
							</td>
						</tr>
						<tr>
							<td class="title">是否强制:</td>
							<td class="data">
								<select id="ifforce" name="ifforce">
									<option value="0">否</option>
									<option value="1">是</option>
								</select>
								<div style="line-height: 24px;color: green;padding-left: 2px;">
								如果选择【是】那么指定范围内的人员强制用该规则进行判断是否在地里范围内，如果该人员在多条强制规则内优先级规则为部门、分部、全部
								</div>
						  	</td>
						</tr>
					</table>
				</div>
				</form>
			</div>
			<div style="width:1024px;height:300px;text-align:center" id="container"></div>
			<div class="co_dialog_bottom">
				<table width="100%">
					<tr>
						<td align="right">
							<div class="co_dig_btn saveMConfig">保存</div>
						</td >
						<td align="left">
							<div class="co_dig_btn" id="closeDialog">关闭</div>
						</td>
					</tr>
				</table>
			</div>
		</div>
		
		<script type="text/javascript">
			var geocoder,map,marker = null;
			$(document).ready(function(){
			    var center = new soso.maps.LatLng(39.916527,116.397128);
			    map = new soso.maps.Map(document.getElementById('container'),{
			        center: center,
			        zoomLevel: 15
			    });
                marker = new soso.maps.Marker({
                    map: map,
                    draggable:true,
                    position:center
                });
			    geocoder = new soso.maps.Geocoder();
				var ADDRESS = "";
				$("#newAgent").click(function(){
					reset();
					openDialog("新建设置","",1,"addMConfigDiv","","",true);
				});
				
				$("#resourcetype").change(function(){
					var value = $(this).val();
					$("#resourceids").val("");
					$("#resourcenames").html("");
					if(value==0){
						$("#resourceTr").hide();
					}else{
						$("#resourceTr").show();
					}
				});
				
				soso.maps.Event.addListener(marker,"dragend",function(){
			        var p = marker.getPosition();
			        map.moveTo(p);
			        var rl = p+"";
	        		var l = rl.split(",");
		            $("#lng").val($.trim(l[1]));
					$("#lat").val($.trim(l[0]));
			    });
				
				$("#address").blur(function(){
					var address = $.trim($(this).val());
					if(address!=ADDRESS){
						ADDRESS = address;
						geocoder.geocode({'address': address}, function(results, status){
					        if (status == soso.maps.GeocoderStatus.OK) {
					        	if(results.location){
					        		map.moveTo(results.location);
					        		marker.setPosition(results.location);
					        		var rl = results.location+"";
					        		var l = rl.split(",");
						            $("#lng").val($.trim(l[1]));
									$("#lat").val($.trim(l[0]));
					        	}
					        } else {
					            $("#lng").val("");
								$("#lat").val("");
					        }
					    });
					}
				});
				  
				$("#allDelete").click(function(){//全部删除按钮触发操作
					deleteBatch();
				});
				
				
				$(".mcBrowser").click(function(){
					var resourceids = $("#resourceids").val();
					var resourcetype = $("#resourcetype").val();
					openDialog2(resourcetype==1?"选择分部":"选择部门",
					"/wxinterface/data/selectResource.jsp?resourceids="+resourceids+"&resourcetype="+resourcetype,0);
					
				});
				
				$(".saveMConfig").click(function(){
					var address = $.trim($("#address").val());
					if(address==""){
						CoDialog.alert("请输入地理位置");
						return false;
					}
					if(getLength(address)>500){
						CoDialog.alert("地址位置不能大于500个字符");
						return false;
					}
					var lat = $.trim($("#lat").val());
					var lng = $.trim($("#lng").val());
					if(lat==""){
						CoDialog.alert("请输入纬度");
						return false;
					}
					if(isNaN(lat)){
						CoDialog.alert("纬度必须是数字");
						return false;
					}
					if(lng==""){
						CoDialog.alert("请输入经度");
						return false;
					}
					if(isNaN(lng)){
						CoDialog.alert("经度必须是数字");
						return false;
					}
					var distance = $.trim($("#distance").val());
					if(distance==""){
						CoDialog.alert("请输入距离设置");
						return false;
					}
					var r = /^[0-9]*[0-9][0-9]*$/;
					if(isNaN(distance)||!r.test(distance)){
						CoDialog.alert("距离必须是正整数");
						return false;
					}
					var resourcetype = $("#resourcetype").val(); 
					var resourceids = $("#resourceids").val();
					if(resourcetype!=0&&resourceids==""){
						CoDialog.alert("请选择分部或者部门");
						return false;
					}
					$("#addMConfigDiv").showLoading();
					$("#addForm").ajaxSubmit({
						dataType:"json",
						success:function(data){
							if(data.status==0){
								CoDialog.alert("保存成功");
								reset();
								dlg.close();
								onRefresh();
							}else{
								CoDialog.alert(data.msg);
							}
						},
						complete:function(){
							$("#addMConfigDiv").hideLoading();
						}
					});
				});
				
				$("#msgRule").click(function(){
					location.href = "MsgRuleSetting.jsp";
				});
			});
			
			function checkAll(){
				if($("#checkall").attr("checked")){
					$(".check").attr("checked",true);
				}else{
					$(".check").attr("checked",false);
				}
			}
			function onRefresh(){
				//_table.refresh();
				window.location.reload();
			}
			function reset(){
				$("#lsid").val("");
				$("#address").val("");
				$("#lng").val("");
				$("#lat").val("");
				$("#distance").val("");
				$("#resourcetype").val("0").change();
				$("#ifforce").val("0");
				$("#resourceids").val("");
				$("#resourcenames").val("");
			}
			
			
			function doUpdate(id) {
				reset();
				$.ajax({
					url:"locationOperate.jsp",
					data:{"id":id,"operate":"getLocationSetting"},
					dataType:"json",
					success:function(data){
						if(data.status==0){
							$("#lsid").val(data.id);
							$("#address").val(data.address);
							$("#lng").val(data.lng);
							$("#lat").val(data.lat);
							$("#distance").val(data.distance);
							$("#resourcetype").val(data.resourcetype).change();
							$("#resourceids").val(data.resourceids);
							$("#resourcenames").html(data.resourcenames);
							$("#ifforce").val(data.ifforce);
							openDialog("编辑设置","",1,"addMConfigDiv","","",true);
							var l = new soso.maps.LatLng(data.lat, data.lng);
			        		map.setCenter(l);
			        		marker.setPosition(l);
						}else{
							CoDialog.alert(data.msg);
						}
					}
				});
			}
			
			
			function getLength(value){
				var length = value.length;
			 	for ( var i = 0; i < value.length; i++) {
			 		if (value.charCodeAt(i) > 127) {
			 			length++;
			 		}
			 	}
			 	return length;
			}	
			
			function doDelete(ids) {
				CoDialog.confirm("确定删除该设置吗?",function(){
					$("#co_tab_box").showLoading();
					jQuery.ajax({
						type: "post",
						url: "locationOperate.jsp",
					    data:{"operate":"delLoactionSetting","ids":ids},
					    dataType:"json",
					    success:function(data){
					    	if(data.status==0){
					    		onRefresh();
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
					CoDialog.alert("请选择要删除的数据!");
					return;
				}else{
					selectedIds = selectedIds.substring(1);
				}
				doDelete(selectedIds);
			}
			
			var dlg2=null;
			function openDialog2(title,url,type,eid,width,height) {
				dlg2 = new CoDialog();
				dlg2.currentWindow = window;
				dlg2.Model=true;
				if(typeof(width)=="undefined"){
					dlg2.Width=500;//定义长度
				}else{
					dlg2.Width=width;//定义长度
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