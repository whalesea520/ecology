
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

<jsp:useBean id="CustomerModifyLog" class="weaver.crm.data.CustomerModifyLog" scope="page"/>
<jsp:useBean id="CoworkDAO" class="weaver.cowork.CoworkDAO" scope="page"/>
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<%
	String customerid = Util.null2String(request.getParameter("CustomerID"));
	if("2".equals(user.getLogintype())){
		response.sendRedirect("/CRM/data/ViewCustomer.jsp?CustomerID="+customerid);
		return;
	}
	rs.executeProc("CRM_CustomerInfo_SelectByID",customerid);
	if(rs.getCounts()<=0)
	{
		response.sendRedirect("/base/error/DBError.jsp?type=FindData");
		return;
	}
	rs.first();

	boolean canview=false;
	boolean isCustomerSelf=false;
	
	String userid = user.getUID()+"";
	String logintype = ""+user.getLogintype();
	boolean isattention = false;
	
	String name = Util.toScreenToEdit(rs.getString("name"),user.getLanguage());
	String manager = Util.toScreenToEdit(rs.getString("manager"),user.getLanguage());
	String requestid = Util.toScreenToEdit(rs.getString("requestid"),user.getLanguage());
	
	
	//判断是否有查看该客户权限
	int sharelevel = CrmShareBase.getRightLevelForCRM(userid,customerid);
	if(sharelevel>0){
        canview=true;
    }

    if(manager.equals(userid)){
      	
        //客户经理为本人时删除新客户标记
    	CustomerModifyLog.deleteCustomerLog(Util.getIntValue(customerid,-1),user.getUID());
    }

    /*check right end*/

    if(!canview && !isCustomerSelf && !CoworkDAO.haveRightToViewCustomer(userid,customerid)){
        if(!WFUrgerManager.UrgerHaveCrmViewRight(Util.getIntValue(requestid),user.getUID(),Util.getIntValue(logintype),customerid) && !WFUrgerManager.getMonitorViewObjRight(Util.getIntValue(requestid),user.getUID(),customerid,"1")){
            response.sendRedirect("/notice/noright.jsp") ;
            return ;
        }
    }
	int nolog = Util.getIntValue(request.getParameter("nolog"),0);
	
	rs2.executeSql("select 1 from CRM_Common_Attention where objid="+customerid+" and operatetype=1 and operator="+userid);
	if(rs2.next()){
		isattention = true;
	}
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/> 
		<script language="javascript" src="../js/jquery-1.8.3.min_wev8.js"></script>
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<script language="javascript" src="../js/jquery.fuzzyquery.min_wev8.js"></script>
		<script language="javascript" src="../js/util_wev8.js"></script>
		<link rel="stylesheet" href="../css/Base_wev8.css" />
		<link rel="stylesheet" href="../css/Contact_wev8.css" />
		<style type="text/css">
			.viewlist{width: 95%;margin: 0px auto;}
			.viewlist td{line-height: 24px;border-bottom: 1px #E6E6FF dashed;}
			.sharebtn{width:50px;height:20px;line-height:20px;background:#676767;color:#fff;text-align:center;float:right;margin-left:5px;cursor:pointer;
				border-radius: 3px;-moz-border-radius: 3px;-webkit-border-radius: 3px;border: 1px #CCCCCC solid;
				box-shadow: 0px 0px 1px #fff;-moz-box-shadow: 0px 0px 1px #fff;-webkit-box-shadow: 0px 0px 1px #fff;margin-top: 5px;font-family: '微软雅黑';}
				
			.browser{width:20px;height:20px;float: left;margin-left: 0px;margin-top: 0px;cursor: pointer;
				background: url('../images/btn_browser_wev8.png') center no-repeat !important;}
				
			/**.item_input{height: 24px;}*/
			
			.tabmenu{width:60px;line-height: 28px;margin-left: 0px;float: left;cursor: pointer;color: #0070C0;font-family:'微软雅黑';text-align: center;}
			.tabmenu_click{font-weight: bold;}
			.infoframe{width: 100%;height: auto;display: none;margin-top: 10px;}
			
			.csmenu{width:60px;line-height: 28px;margin-left: 0px;float: left;cursor: pointer;color: #0070C0;font-family:'微软雅黑';text-align: center;}
			
			.menu_select {
				position: absolute;
				display: none;
				overflow: hidden;
				background: #fff;
				border: 1px #CCCCCC solid;
				box-shadow: 0px 0px 1px #fff;
				border-radius: 3px;
				-moz-border-radius: 3px;
				-webkit-border-radius: 3px;
			}
			.menu_option{
				min-width: 80px;
				padding-left: 10px;
				padding-right: 10px;
				line-height: 22px;
				cursor: pointer;
				font-family: '微软雅黑';
			}
			.menu_option_hover{
				background-color: #0080C0;color: #FAFAFA;
			}
		</style>
		<!--[if IE]> 
		<style type="text/css">
			input{line-height: 180%;}
			.item_input,.other_input{line-height: 20px;}
		</style>
		<![endif]-->
	</head>
	<body>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%@ include file="/CRM/manage/util/RightClickMenu.jsp" %>

		<table id="main" style="width: 100%;height: 100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td align="center" valign="top">
					<div style="width: 98%;height: 100%;margin: 0px auto;text-align: left;">
						<div style="width: auto;height: 28px;border: 1px #CCCCCC solid;margin-top: 4px;background: url('../images/title_bg_wev8.gif') repeat-x;color:#666666;">
							<div style="line-height: 28px;margin-left: 10px;font-weight: bold;float: left;">客户：</div>
							<div style="line-height: 28px;margin-left: 0px;margin-right: 20px;float: left;cursor:pointer;"
								onclick="openFullWindowHaveBar('/CRM/manage/customer/CustomerBaseView.jsp?CustomerID=<%=customerid %>')" title="<%=name %>">
								<%=Util.getMoreStr(name,12,"...") %></div>
							<div style="float: right;margin-right: 5px;">
								<%if(isattention){%>
									<div id="btnatt_" class="btn_operate btn_att" style="margin-left:8px;" title="取消关注" _special="0" _customerid="<%=customerid%>">取消关注</div>
								<%}else{ %>
									<div id="btnatt_" class="btn_operate btn_att" style="margin-left:8px;" title="标记关注" _special="1" _customerid="<%=customerid%>">标记关注</div>
								<%} %>
								<div class="btn_operate" onclick="doRemind(1)" style="margin-left:8px;" title="<%
//查找提醒
boolean isremind = false;
rs2.executeSql("select operator,operatedate,operatetime from CRM_Common_Remind where operatetype=1 and objid="+customerid+" order by operatedate desc,operatetime desc");
while(rs2.next()){isremind = true;
%><%=ResourceComInfo.getLastname(rs2.getString("operator")) + " " + Util.null2String(rs2.getString("operatedate")) + " " + Util.null2String(rs2.getString("operatetime")) %> 提醒过
<%}
%>">提醒<%if(isremind){%><img src="../images/remind_point_wev8.png" style="margin-left: 2px;margin-bottom: 3px;"/><%}%></div>
							<div onclick="parent.closeDetail()" class="btn_operate" style="width: 44px;" title="关闭">关闭</div>
		</div>
						</div>
						<div id="baseinfo" style="width: 100%;height: auto;overflow: hidden;">
						<table style="width: 100%;" cellpadding="0" cellspacing="0" border="0">
						<tr>
						<td id="righttd" valign="top" width="0px" style="width:0px;">
						<!-- 右侧联系记录开始 -->
						<div id="rightdiv" style="width: 100%;overflow: auto;">
							<table style="width: 100%;margin-top: 10px;" cellpadding="0" cellspacing="0" border="0">
								<colgroup><col width="7px"/><col width="6px"/><col width="*"/></colgroup>
								<tr>
									<td class="item_icon10"></td>
									<td></td>
									<td style="position: relative;">
										<div id="crtitle" class="item_title item_title1"></div>
										<div class="item_line item_line10"></div>
										<div id="contactdiv" style="width: 100%;height: auto;">
											<jsp:include page="DetailView.jsp">
												<jsp:param value="<%=customerid %>" name="customerid"/>
												<jsp:param value="<%=nolog %>" name="nolog"/>
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
					</div>
					
				</td>
			</tr>
		</table>
		
		<div id="transbg" style="width: 100%;height: 100%;position: absolute;top: 0px;left: 0px;background: url('../images/transbg_wev8.png') repeat;display: none;z-index: 100"></div>
		
		<!-- 提示信息 -->
		<div id="msg" style="position: fixed;width: 270px;line-height: 30px;text-align:center;left:100px;top:50px;background:#FBFDFF;color:#808080;font-size:14px;font-family:'微软雅黑';display:none;
			border: 1px #1A8CFF solid;box-shadow:0px 0px 1px #1A8CFF;-moz-box-shadow:0px 0px 1px #1A8CFF;-webkit-box-shadow:0px 0px 1px #1A8CFF;
			border-radius: 2px;-moz-border-radius: 2px;-webkit-border-radius: 2px;">操作成功！</div>	
		
		
		<script type="text/javascript">
			$.ajaxSetup ({
			    cache: false //关闭AJAX相应的缓存
			});
			<%if(isremind && manager.equals(userid)){%>
				doRemind(0);
			<%}%>
		
			var tempval = "";//用于记录原值
			var foucsobj2 = null;
			
			$(document).ready(function(){

				//关注事件绑定
				$("div.btn_att").bind("click",function() {
					var attobj = $(this);
					var _special = attobj.attr("_special");
					var customerid =  attobj.attr("_customerid");
					$.ajax({
						type: "post",
						url: "/CRM/manage/util/Operation.jsp",
					    data:{"operation":"do_attention","operatetype":1,"objid":customerid,"settype":_special}, 
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

				setPosition();

			});

			var resizeTimer = null;  
			$(window).resize(function(){
				if(resizeTimer) clearTimeout(resizeTimer);  
				resizeTimer = setTimeout("setPosition()",100);  
			});

			function setPosition(){
				var wh = $(window).height();
				
				$("#main").height(wh);
				$(".infoframe").height(wh-50);
				$("#btn_center").height(wh);
				
				var _top = $("#contactdiv").offset().top;
				$("#contactdiv").height(wh-_top-5);


			}

			//提醒操作
			function doRemind(settype){
				$.ajax({
					type: "post",
					url: "/CRM/manage/util/Operation.jsp",
				    data:{"operation":"do_remind","operatetype":1,"objid":"<%=customerid%>","settype":settype}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
					    if(settype==1) showMsg();
				    }
			    });
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
