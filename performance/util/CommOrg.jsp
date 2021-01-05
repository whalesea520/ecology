<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%
	String action = "";
	int type = Util.getIntValue(request.getParameter("type"), 1);
	if(type==1){
		action = "../program/ProgramView.jsp";
	}else{
		action = "../access/AccessView.jsp";
	}
	int hassub = Util.getIntValue(request.getParameter("hassub"),0);
%>
<HTML>
	<HEAD>
		<link href="../css/jquery.jscrollpane.css" rel="stylesheet" />
		<!-- script type='text/javascript' src="../js/jquery.jscrollpane.js"></script -->
		<!-- script type='text/javascript' src="../js/jquery.mousewheel.js"></script -->
	
		<link type='text/css' rel='stylesheet' href='/secondwev/tree/js/treeviewAsync/eui.tree.css' />
		<link type='text/css' rel='stylesheet' href='../css/tree.css' />
		<script type='text/javascript' src='/secondwev/tree/js/treeviewAsync/jquery.treeview.js'></script>
		<script type='text/javascript' src='/secondwev/tree/js/treeviewAsync/jquery.treeview.async.js'></script>
		
		<style type="text/css">
			.tab{width: 100%;float: left;line-height: 26px;height: 26px;text-align: center;cursor: pointer;background-color: #ECECEC;}
			.tab1{background: url('../images/org_tab1.png') center no-repeat;background-color: #ECECEC;}
			.tab1_click{background: url('../images/org_tab1_click.png') center no-repeat;background-color: #656565;color: #fff;}
			.tab2{background: url('../images/org_tab2.png') center no-repeat;background-color: #ECECEC;}
			.tab2_click{background: url('../images/org_tab2_click.png') center no-repeat;background-color: #656565;color: #fff;}
		</style>
	<%@ include file="/secondwev/common/head.jsp" %>
	</head>
	<body style="margin: 0px;overflow: hidden;">
		<div style="width: 180px;height: 100%;">
			<%
				if(hassub==1){
			%>
			<table style="width: 100%;" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td width="50%"><div id="tab1" class="tab tab1 tab1_click" _index="1"></div></td>
					<td width="50%"><div id="tab2" class="tab tab2" _index="2"></div></td>
				</tr>
			</table>
			<%	} %>
			<div class="mine"><a href="javascript:doClick(<%=user.getUID() %>,4)">本人</a></div>
			<%if(hassub==1){%>
			<div id="subOrgDiv" class="divorg" style="width: 100%;height: 100%;outline:none;"></div>
			<div id="hrmOrgDiv" class="divorg" style="width: 100%;height: 100%;outline:none;display: none;"></div>
			<%}else{%>
			<div id="hrmOrgDiv" class="divorg" style="width: 100%;height: 100%;outline:none;"></div>
			<%} %>
		</div>
		<form id="orgform" name="orgform" action="<%=action %>" method="post" target="pageRight">
			<input type="hidden" id="resourceid" name="resourceid" />
			<input type="hidden" id="resourcetype" name="resourcetype" />
		</form>
		<script type="text/javascript">
			jQuery(document).ready(function() {
				setHeight();
				<%if(hassub==1){%>
				$("div.tab").bind("click",function(){
					var _index = $(this).attr("_index");
					if(_index==1){
						$(this).addClass("tab1_click");
						$("#tab2").removeClass("tab2_click");
						$("#subOrgDiv").show();
						$("#hrmOrgDiv").hide();
					}else{
						$(this).addClass("tab2_click");
						$("#tab1").removeClass("tab1_click");
						$("#subOrgDiv").hide();
						$("#hrmOrgDiv").show();
					}
				});
				/**
				jQuery("#subOrgDiv").jScrollPane({
					autoReinitialise: true,
			        mouseWheelSpeed: 30 
			    });*/
				jQuery("#subOrgDiv").append('<ul id="subOrgTree" class="hrmOrg" style="width:100%;outline:none;"></ul>');
				jQuery("#subOrgTree").treeview({
			       url:"/secondwev/tree/hrmOrgTree.jsp",
			       root:"hrm|<%=user.getUID()%>"
			    });
				<%}%>
				/**
				jQuery("#hrmOrgDiv").jScrollPane({
					autoReinitialise: true,
			        mouseWheelSpeed: 30
			    });*/
				jQuery("#hrmOrgDiv").append('<ul id="hrmOrgTree" class="hrmOrg" style="width:100%;outline:none;"></ul>');
				jQuery("#hrmOrgTree").treeview({
			       url:"/secondwev/tree/hrmOrgTree.jsp"
			    });
			});
			function doClick(orgId, type, obj) {
				if(type==4){
					jQuery("#resourceid").val(orgId);
					jQuery("#resourcetype").val(type);
					jQuery("#orgform").submit();
					if (obj) {
						jQuery(obj).css("font-weight", "normal");
						jQuery(obj).parent().parent().find(".selected").removeClass(
								"selected");
						jQuery(obj).parent().addClass("selected");
					}
				}
			}
			jQuery(window).resize(function(){
				setHeight();
			});
			function setHeight(){
				var h = document.body.clientHeight-24;
				<%if(hassub==1){%> 
				h = document.body.clientHeight-50;
				<%}%>
				jQuery("#subOrgDiv").height(h);
				jQuery("#hrmOrgDiv").height(h);
			}
		</script>
	</body>
</html>
