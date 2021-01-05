
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
	String userid = user.getUID()+"";
	String sellchanceid = Util.null2String(request.getParameter("id"));
	if("2".equals(user.getLogintype())){
		response.sendRedirect("/CRM/sellchance/ViewSellChance.jsp?id="+sellchanceid);
		return;
	}
	String contact = Util.null2String(request.getParameter("contact"));
	String customerid = "";
	String subject = "";
	String manager = "";
	boolean isattention = false;
	rs.executeSql("select t.subject,t.customerid,t.creater,t.content,t.source,t.predate,t.preyield,t.probability,t.fileids,t.fileids2,t.fileids3,t.remark,t.sellstatusid,t.endtatusid,t.selltype,t.createuserid,t.createdate,t.createtime,t.updateuserid,t.updatedate,t.updatetime,t.description,t.producttype,t.ploytype,t.ploydesc,t.opptid,t.opptname"
			+",sa.id as att"
			+" from CRM_SellChance t left join CRM_Common_Attention sa on t.id=sa.objid and sa.operatetype=2 and sa.operator="+userid
			+" where t.id="+sellchanceid);
	if(rs.next()){
		customerid = Util.null2String(rs.getString("customerid"));
		subject = Util.null2String(rs.getString("subject"));
		customerid = Util.null2String(rs.getString("customerid"));
		manager = Util.null2String(rs.getString("creater"));
		if(!Util.null2String(rs.getString("att")).equals("")){
			isattention = true;
		}
	}else{
		response.sendRedirect("/base/error/DBError.jsp?type=FindDataVCL");
		return;
	}
	if(!customerid.equals("")){
		//判断此客户是否存在
		rs.executeProc("CRM_CustomerInfo_SelectByID",customerid);
		if(!rs.next()){
			response.sendRedirect("/base/error/DBError.jsp?type=FindDataVCL");
			return;
		}
		//判断是否有查看该客户商机权限
		int sharelevel = CrmShareBase.getRightLevelForCRM(userid,customerid);
		if(sharelevel<1){
			response.sendRedirect("/notice/noright.jsp") ;
			return;
		}
	}
	
	int nolog = Util.getIntValue(request.getParameter("nolog"),0);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>查看销售商机-<%=subject %></title>
		<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
		<script language="javascript" src="/workrelate/js/jquery-1.8.3.min_wev8.js"></script>
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<script language="javascript" src="../js/jquery.fuzzyquery.min_wev8.js"></script>
		<script language="javascript" src="../js/util_wev8.js"></script>
		<script src="/workrelate/js/jquery.ui.core_wev8.js"></script>
		<script src="/workrelate/js/jquery.ui.widget_wev8.js"></script>
		<script src="/workrelate/js/jquery.ui.datepicker_wev8.js"></script>
		<link rel="stylesheet" href="/workrelate/css/ui/jquery.ui.all_wev8.css" />
		<link rel="stylesheet" href="../css/Base_wev8.css" />
		<link rel="stylesheet" href="../css/Contact_wev8.css" />
		<style type="text/css">
			<%if(contact.equals("0")){ %>
			.logtxt a,.logtxt a:active,.logtxt a:visited {text-decoration: none;color: #fff;}
			.logtxt a:hover {text-decoration: underline;color: #fff;}
			.btn_operate{background: #F0F0F0;}
			<%}%>
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
					<div style="<%if(contact.equals("0")){ %>width: 100%;<%}else{ %>width: 98%;<%} %>height: 100%;margin: 0px auto;text-align: left;">
						<div style="width: 100%;height: 28px;margin-top: 4px;<%if(contact.equals("0")){%>background:#E46D0A;color:#fff;<%}else{%>background: url('../images/title_bg_wev8.gif') repeat-x;color:#666666;border: 1px #CCCCCC solid;<%}%>">
							<div style="line-height: 28px;margin-left: 10px;font-weight: bold;float: left;">商机：</div>
							<div style="line-height: 28px;margin-left: 0px;float: left;cursor:pointer;"
							  onclick="openFullWindowHaveBar('/CRM/manage/sellchance/SellChanceView.jsp?id=<%=sellchanceid %>')" title="<%=subject %>">
								<%=Util.getMoreStr(subject,12,"...") %>
							</div>
							<div class="logtxt" style="float: right;margin-right: 5px;overflow: hidden;">
								<%if(isattention){%>
									<div id="btnatt_<%=sellchanceid%>" class="btn_operate btn_att" title="取消关注" _special="0" _sellchanceid="<%=sellchanceid%>">取消关注</div>
								<%}else{ %>
									<div id="btnatt_<%=sellchanceid%>" class="btn_operate btn_att" title="标记关注" _special="1" _sellchanceid="<%=sellchanceid%>">标记关注</div>
								<%} %>
								<div class="btn_operate" onclick="doRemind(1)" title="<%
//查找提醒
boolean isremind = false;
rs.executeSql("select operator,operatedate,operatetime from CRM_Common_Remind where operatetype=2 and objid="+sellchanceid+" order by operatedate desc,operatetime desc");
while(rs.next()){isremind = true;
%><%=ResourceComInfo.getLastname(rs.getString("operator")) + " " + Util.null2String(rs.getString("operatedate")) + " " + Util.null2String(rs.getString("operatetime")) %> 提醒过
<%}
%>">提醒<%if(isremind){%><img src="../images/remind_point_wev8.png" style="margin-left: 2px;margin-bottom: 3px;"/><%}%></div>
								<div onclick="parent.closeDetail()" class="btn_operate" style="width: 44px;" title="关闭">关闭</div>
		</div>
								
						</div>
						<table style="width: 100%;" cellpadding="0" cellspacing="0" border="0">
						<tr>
						
						<td id="righttd" valign="top" width="29%">
						<!-- 右侧联系记录开始 -->
						<div id="rightdiv" style="width: 100%;overflow: auto;">
							<table style="width: 100%;margin-top: 10px;" cellpadding="0" cellspacing="0" border="0">
								<colgroup><col width="7px"/><col width="6px"/><col width="*"/></colgroup>
								<tr>
									<td class="item_icon10"></td>
									<td></td>
									<td style="position: relative;">
										<div class="item_title item_title1">联系记录</div>
										<div class="item_line item_line10"></div>
										<div id="contactdiv" style="width: 100%;height: auto;">
											<jsp:include page="/CRM/manage/sellchance/DetailView.jsp">
												<jsp:param value="<%=sellchanceid %>" name="sellchanceid"/>
												<jsp:param value="<%=subject %>" name="sellchancename"/>
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
			<%if(isremind && manager.equals(userid)){%>
				doRemind(0);
			<%}%>
		
			var tempval = "";//用于记录原值
			var foucsobj2 = null;
			var relinfomap = new Map();
			var description = "请描述客户方的决策流程、以及内部关系，和如何赢得这些客户方关键人的支持";
			var otherinfomap = new Map();
			
			$(document).ready(function(){
				//关注事件绑定
				$("div.btn_att").bind("click",function() {
					var attobj = $(this);
					var _special = attobj.attr("_special");
					var sellchanceid =  attobj.attr("_sellchanceid");
					$.ajax({
						type: "post",
						url: "/CRM/manage/util/Operation.jsp",
					    data:{"operation":"do_attention","operatetype":2,"objid":sellchanceid,"settype":_special}, 
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
					//if(wh2<wh){wh=wh2;}
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
				    data:{"operation":"do_remind","operatetype":2,"objid":"<%=sellchanceid%>","settype":settype}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
					    if(settype==1) showMsg();
				    }
			    });
			}
			function setLastUpdate(){
				
				var currentdate = new Date();
				var datestr = currentdate.format("yyyy-MM-dd");
				var timestr = currentdate.format("hh:mm:ss");
				$("#lastupdate").html("<a href='/hrm/resource/HrmResource.jsp?id=<%=user.getUID()%>' target='_blank'><%=ResourceComInfo.getLastname(user.getUID()+"")%></a> <font title='"+timestr+"'>"+datestr+"</font> 修改");
				
				<%if(contact.equals("0")){%>
					if(parent!=null && parent.showMsg!= null) parent.showMsg();
				<%}else{%>
					var _left = Math.round(($(window).width()-$("#msg").width())/2);
					$("#msg").css({"left":_left,"top":60}).show().animate({top:30},500,null,function(){
						$(this).fadeOut(800);
					});
				<%}%>
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
