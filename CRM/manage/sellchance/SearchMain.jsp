
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="ContacterTitleComInfo" class="weaver.crm.Maint.ContacterTitleComInfo" scope="page"/>
<jsp:useBean id="cmutil" class="weaver.cs.util.CommonTransUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
	<HEAD>
		<title>商机列表</title>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<link type='text/css' rel='stylesheet'  href='/tree/js/treeviewAsync/eui.tree_wev8.css'/>
		<script language='javascript' type='text/javascript' src='/tree/js/treeviewAsync/jquery.treeview_wev8.js'></script>
		<script language='javascript' type='text/javascript' src='/tree/js/treeviewAsync/jquery.treeview.async_wev8.js'></script>
		<style type="text/css">
			.item{width: 43px;height:24px;line-height:24px;text-align: center;margin-left: 5px;margin-top: 8px;float: left;cursor: pointer;font-weight: bold;}
			.item_select{background: #ffffff;}
			.listitem{width: 100%;height:28px;line-height:28px;text-align: left;padding-left: 15px;margin-top: 0px;cursor: pointer;border-bottom: 1px #E3F4F4 solid;}
			.listitem_select{background: #E3F4F4;}
		</style>
	</head>
	<%
		String imagefilename = "/images/hdReport_wev8.gif";
	%>
	<BODY  style="overflow: hidden">
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form name="frmMain" action="ContacterList.jsp" method="post">
		<input type="hidden" name="init" value="0" />
		<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td valign="top" id="itmeList" width="200px">
					<table style="width: 100%;height: 100%;" cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td style="height: 32px;">
								<div style="width: 100%;height: 32px;background: #CEECEB">
									<div class="item item_select" _type="1">本人</div>
									<div class="item" _type="2">下属</div>
									<div class="item" _type="3">组织</div>
									<div class="item" _type="4">状态</div>
								</div>
							</td>
						</tr>
						<tr>
					   		<td style="height: 5px !important;padding: 0px;"></td>
						</tr>
						<tr>
							<td>
								<div id="condition" style="width: 100%;height: 100%;overflow: auto;">
									<div class="listitem listitem_select" onclick="doSearch(this,'creater','<%=user.getUID() %>')">我的商机</div>
									<div class="listitem" onclick="doSearch(this,'attention','1')">关注商机</div>
									<div class="listitem" onclick="doSearch(this,'subcompanyId','<%=user.getUserSubCompany1() %>')">所在分部</div>
									<div class="listitem" onclick="doSearch(this,'deptId','<%=user.getUserDepartment() %>')">所在部门</div>
								</div>
							</td>
						</tr>
					</table>
					
				</td>
				<td align=left valign=middle width="8px" height=100% id="frmCenter" style="background:#B1D4D9;cursor:e-resize;">
				     <div id="frmCenterImg" onclick="mnToggleleft(this)" class="frmCenterImgOpen" style="height: 100%" _status="1"></div>
                </td>
				<td valign="top">
					<iframe id="listframe" style="width: 100%;height: 100%" frameborder="0" scrolling="no" src="SearchList.jsp?creater=<%=user.getUID() %>"></iframe>
				</td>
			</tr>
		</table>
		</form>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				jQuery(".item").bind("click",function(){
					jQuery("#condition").html("<div style='width:100%;line-height: 40px;text-align: center;font-size: 12px;color: #808080'>正在获取数据,请稍等...</div>");
					jQuery(".item").removeClass("item_select");
					jQuery(this).addClass("item_select");
					var url = "SearchCondition.jsp?listType="+jQuery(this).attr("_type");
					jQuery.post(url,function(data){
			            jQuery("#condition").html(data);	
					});
				});
			});
			$(window).resize(function(){
				document.getElementById("listframe").contentWindow.setHeight();
			});
			function doSearch(obj,parm,value){
				if(obj!=null){
					jQuery(".listitem").removeClass("listitem_select");
					jQuery(obj).addClass("listitem_select");
				}
				jQuery("#listframe").attr("src","SearchList.jsp?"+parm+"="+value);
			}
			/*收缩左边栏*/
			function mnToggleleft(obj){
				var _status = jQuery(obj).attr("_status");
				if(_status==0){
					jQuery("#frmCenterImg").removeClass("frmCenterImgClose");
				    jQuery("#frmCenterImg").addClass("frmCenterImgOpen");
					jQuery("#itmeList").show();
					jQuery(obj).attr("_status",1);
				}else{
				    jQuery("#frmCenterImg").removeClass("frmCenterImgOpen");
				    jQuery("#frmCenterImg").addClass("frmCenterImgClose"); 
					jQuery("#itmeList").hide();
					jQuery(obj).attr("_status",0);
				}
			}
		</script>
	</BODY>
</HTML>