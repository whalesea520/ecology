
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="ContacterTitleComInfo" class="weaver.crm.Maint.ContacterTitleComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<%
	String userid = user.getUID()+"";
	String contacterid = Util.null2String(request.getParameter("ContacterID"));
	if("2".equals(user.getLogintype())){
		response.sendRedirect("/CRM/data/ViewContacter.jsp?ContacterID="+contacterid);
		return;
	}
	rs.executeProc("CRM_CustomerContacter_SByID", contacterid);
	if (rs.getCounts() <= 0) {
		response.sendRedirect("/base/error/DBError.jsp?type=FindData");
		return;
	}
	rs.first();
	String customerid = rs.getString(2);

	boolean canedit = false;
	if(!customerid.equals("")){
		//判断此客户是否存在
		rs2.executeProc("CRM_CustomerInfo_SelectByID",customerid);
		if(!rs2.next()){
			response.sendRedirect("/base/error/DBError.jsp?type=FindDataVCL");
			return;
		}
		//判断是否有查看该客户商机权限
		int sharelevel = CrmShareBase.getRightLevelForCRM(userid,customerid);
		if(sharelevel<1){
			response.sendRedirect("/notice/noright.jsp") ;
			return;
		}
		//判断是否有编辑该客户商机权限
		if(sharelevel>1){
			canedit = true;
		}
		if(rs2.getInt("status")==7 || rs2.getInt("status")==8){
			canedit = false;
		}
	}
	
	String firstname = Util.toScreenToEdit(rs.getString("firstname"),user.getLanguage());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>查看联系人-<%=firstname %></title>
		<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
		<script language="javascript" src="../js/jquery-1.8.3.min_wev8.js"></script>
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<script language="javascript" src="../js/jquery.fuzzyquery.min_wev8.js"></script>
		<script language="javascript" src="../js/util_wev8.js"></script>
		<script language="javascript" src="../js/jquery.ui.core_wev8.js"></script>
		<script language="javascript" src="../js/jquery.ui.widget_wev8.js"></script>
		<script language="javascript" src="../js/jquery.ui.datepicker_wev8.js"></script>
		<link rel="stylesheet" href="../css/ui/jquery.ui.all_wev8.css" />
		<link rel="stylesheet" href="../css/Base_wev8.css" />
		<link rel="stylesheet" href="../css/Contact_wev8.css" />
		<style type="text/css">
			.input_select{width: 98px !important;}
		</style>
		<!--[if IE]> 
		<style type="text/css">
			input{line-height: 180%;}
			.item_input,.other_input{line-height: 20px;}
		</style>
		<![endif]-->
	</head>
	<body>
		<table id="main" style="width: 100%;height: 100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td align="center" valign="top">
					<div style="width: 98%;height: 100%;margin: 0px auto;text-align: left;">
						<div style="width: 100%;height: 28px;margin-top: 4px;background: url('../images/title_bg_wev8.gif') repeat-x;color:#666666;border: 1px #CCCCCC solid;">
							<div style="line-height: 28px;margin-left: 10px;font-weight: bold;float: left;">联系人：</div>
							<div style="line-height: 28px;margin-left: 0px;float: left;cursor:pointer;"
							onclick="openFullWindowHaveBar('/CRM/manage/contacter/ContacterView.jsp?ContacterID=<%=contacterid %>')" title="<%=firstname %>">
								<%=Util.getMoreStr(firstname,12,"...") %>
							</div>
							<div class="logtxt" style="float: right;margin-right: 5px;">
								<div onclick="parent.closeDetail()" class="btn_operate" style="width: 44px;" title="关闭">关闭</div>
							</div>
						</div>
						<table style="width: 100%;" cellpadding="0" cellspacing="0" border="0">
						<tr>
						<td id="righttd" valign="top" width="100%">
						<!-- 右侧联系记录开始 -->
						<div id="rightdiv" style="width: 100%;overflow: auto;">
							<table style="width: 100%;margin-top: 20px;" cellpadding="0" cellspacing="0" border="0">
								<colgroup><col width="7px"/><col width="6px"/><col width="*"/></colgroup>
								<tr>
									<td class="item_icon10"></td>
									<td></td>
									<td style="position: relative;">
										<div class="item_title item_title1">联系记录</div>
										<div class="item_line item_line10"></div>
										<div id="contactdiv" style="width: 100%;height: auto;">
											<jsp:include page="DetailView.jsp">
												<jsp:param value="<%=contacterid %>" name="contacterid"/>
												<jsp:param value="1" name="hidetitle"/>
											</jsp:include>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<!-- 右侧联系记录结束 -->
						</td>
						</tr>
						</table>
					</div>
				</td>
			</tr>
		</table>
		
		<!-- 提示信息 -->
		<div id="msg" style="position: fixed;width: 270px;line-height: 30px;text-align:center;left:100px;top:50px;background:#FBFDFF;color:#808080;font-size:14px;font-family:'微软雅黑';display:none;
			border: 1px #1A8CFF solid;box-shadow:0px 0px 1px #1A8CFF;-moz-box-shadow:0px 0px 1px #1A8CFF;-webkit-box-shadow:0px 0px 1px #1A8CFF;
			border-radius: 2px;-moz-border-radius: 2px;-webkit-border-radius: 2px;">操作成功！</div>	
		
		<script type="text/javascript">
			$.ajaxSetup ({
			    cache: false //关闭AJAX相应的缓存
			});
			
			var tempval = "";//用于记录原值
			var foucsobj2 = null;
			
			$(document).ready(function(){
				
				//关注事件绑定
				$("div.btn_att").bind("click",function() {
					var attobj = $(this);
					var _special = attobj.attr("_special");
					var contacterid =  attobj.attr("_contacterid");
					$.ajax({
						type: "post",
						url: "/CRM/manage/util/Operation.jsp",
					    data:{"operation":"do_attention","operatetype":3,"objid":contacterid,"settype":_special}, 
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    complete: function(data){ 
					    	if(_special==1){
								attobj.attr("title","取消关注").attr("_special","0").html("取消关注");
							}else{
								attobj.attr("title","标记关注").attr("_special","1").html("标记关注");
							}
					    	showMsg();
					    }
				    });
				});

				//收缩展开绑定
				$("#btn_center").bind("mouseover",function(){
					$(this).addClass("btn_right");
				}).bind("mouseout",function(){
					$(this).removeClass("btn_right");
				}).bind("click",function(){
					var _status = $(this).attr("_status");
					if(_status==0){
						$(this).attr("_status",1).attr("title","展开").addClass("btn_left");
						$("#righttd").width(0).hide();
						//$("#leftdiv").width("99%");
					}else{
						$(this).attr("_status",0).attr("title","收缩").removeClass("btn_left");
						$("#righttd").width("29%").show();
						//$("#leftdiv").width("70%");
					}
					setPosition();
				});

				$("div.roletype").bind("mouseover",function(){
					$(this).addClass("roletype_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("roletype_hover");
				}).bind("click",function(){
					if($(this).hasClass("roletype_select")){
						$(this).removeClass("roletype_select");
					}else{
						$(this).addClass("roletype_select");
					}
				});

				setPosition();
				setRemarkHeight("experience");
				setRemarkHeight("remark");
			});

			var resizeTimer = null;  
			$(window).resize(function(){
				if(resizeTimer) clearTimeout(resizeTimer);  
				resizeTimer = setTimeout("setPosition()",100);  
			});

			function setPosition(){
					var wh = $(window).height();
					$("#main").height(wh);
					$("#btn_center").height(wh);
					
					var _top = $("#contactdiv").offset().top;
					$("#contactdiv").height(wh-_top-5);
			}
			function setRemarkHeight(remarkid){
				if($("#"+remarkid).length>0){
					$("#"+remarkid).height("auto");
					var h= document.getElementById(remarkid).scrollHeight; 
					//h = $("#"+remarkid).height();
					//alert(h);alert(document.getElementById(remarkid).clientHeight);
					//alert($("#"+remarkid).val().indexOf("\n"))
					if(h>70){
						$("#"+remarkid).height(70);
						//$("#"+remarkid).height(textarea.scrollHeight);
					}else if(h<20 || ($("#"+remarkid).val().indexOf("\n")<0 && h==34)){
						$("#"+remarkid).height(20);
					}else{
						$("#"+remarkid).height(h);
					}
				}
			}

			//提醒操作
			function doRemind(settype){
				$.ajax({
					type: "post",
					url: "/CRM/manage/util/Operation.jsp",
				    data:{"operation":"do_remind","operatetype":3,"objid":"<%=contacterid%>","settype":settype}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
					    if(settype==1) showMsg();
				    }
			    });
			}
			function setLastUpdate(){
				
				var currentdate = new Date();
				datestr = currentdate.format("yyyy-MM-dd hh:mm:ss");
				$("#lastupdate").html("由 <a href='/hrm/resource/HrmResource.jsp?id=<%=user.getUID()%>' target='_blank'><%=ResourceComInfo.getLastname(user.getUID()+"")%></a> 于 "+datestr+" 最后修改");
				
				showMsg();
			}
			function showMsg(){
				var _left = Math.round(($(window).width()-$("#msg").width())/2);
				$("#msg").css({"left":_left,"top":60}).show().animate({top:30},500,null,function(){
					$(this).fadeOut(800);
				});
			}
		</script>
	</body>
</html>
<%@ include file="/CRM/manage/util/uploader.jsp" %>
