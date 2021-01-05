
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="cmutil" class="weaver.cs.util.CommonTransUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String userId = "" + user.getUID();
	String customerId = Util.fromScreen3(request.getParameter("customerId"), user.getLanguage());
	//判断是否有查看该客户权限
	int sharelevel = CrmShareBase.getRightLevelForCRM(userId,customerId);
	if(sharelevel<1){
		response.sendRedirect("/notice/noright.jsp") ;
        return ;
	}
	boolean canEdit = true;
	if(sharelevel<2){
		canEdit = false;
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<script language="javascript" src="../js/jquery-1.8.3.min_wev8.js"></script>
		<link rel="stylesheet" href="../css/Base_wev8.css" />
		<style type="">
			*{font-family: '微软雅黑';}
			.div_add{width: 300px;height: 26px;float: left;border: 1px #CCCCCC solid;}
			.input_add{width: 298px;line-height: 24px;height: 24px;border: 0px;}
			.input_add_hover{border: 1px #CCCCCC solid;}
			.input_add_click{border: 1px #1A8CFF solid;}
			.botton_add{width: 65px;line-height: 28px;float: left;background: #CCCCCC;text-align: center;color: #fff;cursor: pointer;}
			.botton_add_hover{background: #5581DA;}
			.item_input{width: 500px;float: left;}
			td.data{padding-left: 0px !important;height: 30px;}
			.btn_delete{width: 18px;height: 26px;float: left;margin-left: 5px;background: url('../images/log_btn_close_wev8.png') center no-repeat;cursor: pointer;display: none;}
		</style>
	</head>
	<body>
		<input type="hidden" id="operation" name="operation" value="init"/>
		<input type="hidden" name="customerId" value="<%=customerId %>"/>
		<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="10" />
				<col width="*" />
				<col width="10" />
			</colgroup>
				<tr>
					<td></td>
					<td valign="top">
						<div class="item_title item_title1">客户签约名称</div>
						<div class="item_line item_line1"></div>
						<%if(canEdit){ %>
						<div style="width:100%;height: 30px;margin-top: 10px;">
							<div class="div_add">
								<input type="text" class="input_add" id="addname" name="addname" value=""/>
							</div>
							<div class="botton_add" onclick="addName()">添加</div>
						</div>
						<%} %>
						<table id="item_table" class="item_table" style="margin-top: 10px;" cellpadding="0" cellspacing="0" border="0">
							
							<tbody>
								<%
									rs.executeSql("select id,customername from CRM_OtherName where customerid = "+customerId+" and nametype=2 order by id "); 
									while(rs.next()){
								%>
								<tr id="tr_<%=rs.getString("id") %>">
									<td class="data">
										<%if(canEdit){ %>
											<input type="text" class="item_input"  _id="<%=rs.getString("id") %>" value="<%=Util.toScreen(rs.getString("customername"),user.getLanguage()) %>"/>
											<div class="btn_delete" _id="<%=rs.getString("id") %>"></div>
										<%}else{ %>
											<%=Util.toScreen(rs.getString("customername"),user.getLanguage()) %>
										<%} %>
									</td>
								</tr>
								<%} %>
							</tbody>
						</table>
					</td>
					<td></td>
				</tr>
				<tr style="height: 10px;">
					<td height="10" colspan="3"></td>
				</tr>
		</table>
		<!-- 提示信息 -->
		<div id="msg" style="position: fixed;width: 270px;line-height: 30px;text-align:center;left:100px;top:50px;background:#FBFDFF;color:#808080;font-size:14px;font-family:'微软雅黑';display:none;
			border: 1px #1A8CFF solid;box-shadow:0px 0px 1px #1A8CFF;-moz-box-shadow:0px 0px 1px #1A8CFF;-webkit-box-shadow:0px 0px 1px #1A8CFF;
			border-radius: 2px;-moz-border-radius: 2px;-webkit-border-radius: 2px;">操作成功！</div>	
		<script type="text/javascript">
		<%if(canEdit){ %>
			var tempval = "";//用于记录原值
			var foucsobj2 = null;
			$(document).ready(function(){
				
				$(".botton_add").bind("mouseover",function(){
					$(this).addClass("botton_add_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("botton_add_hover");
				});
				
				$(".item_input").live("focus",function(){
					$(this).addClass("item_input_focus");
					tempval = $(this).val();
					foucsobj2 = this;
				}).live("blur",function(){
					$(this).removeClass("item_input_focus");
					editName(this);
				});

				$("div.btn_delete").live("click",function(){
					var _id = $(this).attr("_id");
					deleteName(_id);
				});
	
				//表格行背景效果及操作按钮控制绑定
				$("table.item_table").find("td.data").live("click mouseenter",function(){
					$(this).children(".item_input").addClass("item_input_hover");
					$(this).children(".btn_delete").show();
				}).live("mouseleave",function(){
					$(this).children(".item_input").removeClass("item_input_hover");
					$(this).children(".btn_delete").hide();
				});

				//页面点击及回车事件绑定
				$(document).bind("keydown",function(e){
					e = e ? e : event;   
				    if(e.keyCode == 13){
						var target=$.event.fix(e).target;
						if($(target).hasClass("item_input")){
				    		$(foucsobj2).blur();  
				    	}
						if($(target).hasClass("input_add")){
							addName();  
				    	}
				    }
				});
				
			});
			function addName(){
				var addname = $("#addname").val();
				$.ajax({
					type: "post",
				    url: "Operation.jsp",
				    data:{"operation":"add_signname","customerid":<%=customerId%>,"addname":filter(encodeURI(addname))}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
					    var txt = $.trim(data.responseText);
					    showMsg();
					    $("#item_table").append(txt);
					    $("#addname").val("");
					}
			    });
			}
			function editName(obj){
				var editname = $(obj).val();
				if(tempval==editname) return;
				var editid = $(obj).attr("id");
				$.ajax({
					type: "post",
				    url: "Operation.jsp",
				    data:{"operation":"edit_signname","customerid":<%=customerId%>,"editid":editid,"editname":filter(encodeURI(editname))}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
					    //var txt = $.trim(data.responseText);
					    showMsg()
					}
			    });
				tempval = editname;
			}
			function deleteName(id){
				if(confirm("确定删除？")){
					$.ajax({
						type: "post",
					    url: "Operation.jsp",
					    data:{"operation":"delete_signname","customerid":<%=customerId%>,"deleteid":id}, 
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    complete: function(data){ 
						    //var txt = $.trim(data.responseText);
						    $("#tr_"+id).remove();
						    showMsg();
						}
				    });
				}
			}
			function showMsg(){
				var _left = Math.round(($(window).width()-$("#msg").width())/2);
				$("#msg").css({"left":_left,"top":60}).show().animate({top:30},500,null,function(){
					$(this).fadeOut(800);
				});
			}
			//替换ajax传递特殊符号
			function filter(str){
				str = str.replace(/\+/g,"%2B");
			    str = str.replace(/\&/g,"%26");
				return str;	
			}
		<%} %>
		</script>
	</body>
</html>