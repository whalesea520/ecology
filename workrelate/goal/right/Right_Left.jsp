<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
<HEAD>
	<link type='text/css' rel='stylesheet'  href='/secondwev/tree/js/treeviewAsync/eui.tree.css'/>
	<script language='javascript' type='text/javascript' src='/secondwev/tree/js/treeviewAsync/jquery.treeview.js'></script>
	<script language='javascript' type='text/javascript' src='/secondwev/tree/js/treeviewAsync/jquery.treeview.async.js'></script>
	
	<style type="text/css">
		.hrmOrg span.company { background: url(../images/company.png) 0 0 no-repeat; }
		.hrmOrg span.subcompany { background: url(../images/sub.png) 0 0 no-repeat; }
		.hrmOrg span.department { background: url(../images/depat.png) 0 0 no-repeat; }
		.hrmOrg span.person { background: url(../images/person.png) 0 0 no-repeat; }
		.mine{line-height:24px;padding-left:20px;background: url(../images/person.png) left center no-repeat;font-size:12px;cursor:pointer;}
		.divorg{
			overflow-y: auto;
			overflow-x: hidden;
			SCROLLBAR-DARKSHADOW-COLOR: #EEEEEE;
			SCROLLBAR-ARROW-COLOR: #F6F6F6;
			SCROLLBAR-3DLIGHT-COLOR: #EEEEEE;
			SCROLLBAR-SHADOW-COLOR: #EEEEEE;
			SCROLLBAR-HIGHLIGHT-COLOR: #EEEEEE;
			SCROLLBAR-FACE-COLOR: #EEEEEE;
			scrollbar-track-color: #F6F6F6;
		}
		
		::-webkit-scrollbar-track-piece {
			background-color: #F6F6F6;
			-webkit-border-radius: 0;
		}
		
		::-webkit-scrollbar {
			width: 12px;
			height: 8px;
		}
		
		::-webkit-scrollbar-thumb {
			height: 50px;
			background-color: #EEEEEE;
			-webkit-border-radius: 1px;
			outline: 0px solid #fff;
			outline-offset: -2px;
			border: 0px solid #fff;
		}
		
		::-webkit-scrollbar-thumb:hover {
			height: 50px;
			background-color: #D5D5D5;
			-webkit-border-radius: 1px;
		}
		
		.menu{width: 100%;line-height: 26px;height: 26px;cursor: pointer;background-color: #ECECEC;font-size: 13px;}
		.menu_hover{background-color: #C3C3C3;color: #fff;}
		.menu_click{background-color: #656565;color: #fff;}
	</style>
<%@ include file="/secondwev/common/head.jsp" %>
	</head>
<body style="margin: 0px;overflow: hidden;">
	<div style="width: 200px;height: 100%;">
		<div style="width:100%;border-top:1px solid #D6D6D6;line-height:1px"></div>
		<div id="menu1" class="menu menu_click" _index="1">基础设置</div>
		<div id="menu2" class="menu" _index="2">负责人设置</div>
		<div id="hrmOrgDiv" class="divorg" style="width: 100%;height: 100%;outline: none;"></div>
	</div>
	<FORM id=SearchForm name=SearchForm action="RightSetting.jsp" method=post target="pageRight">
		<input type="hidden" id="orgId" name="orgId"/>
		<input type="hidden" id="type" name="type"/>
	</FORM>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			$("div.menu").bind("mouseover",function(){
				jQuery(this).addClass("menu_hover");
			}).bind("mouseout",function(){
				jQuery(this).removeClass("menu_hover");
			}).bind("click",function(){
				jQuery("div.menu").removeClass("menu_click");
				jQuery(this).addClass("menu_click");
				var _index = $(this).attr("_index");
				if(_index==1){
					jQuery("#SearchForm").attr("action","BaseSetting.jsp").submit();
				}else{
					jQuery("#SearchForm").attr("action","InitPage.jsp").submit();
				}
			});
			
			jQuery("#hrmOrgDiv").append('<ul id="hrmOrgTree" class="hrmOrg" style="width:100%"></ul>');
			jQuery("#hrmOrgTree").treeview({
		       url:"/secondwev/tree/hrmOrgTree.jsp"
		    });
			setHeight();
		});
		function doClick(orgId,type,obj){
			jQuery("div.menu").removeClass("menu_click");
			jQuery("#menu2").addClass("menu_click");
			jQuery("#orgId").val(orgId);
			jQuery("#type").val(type);
			jQuery("#SearchForm").attr("action","RightSetting.jsp").submit();
			if(obj){
				jQuery(obj).css("font-weight","normal");
				jQuery(obj).parent().parent().find(".selected").removeClass("selected");
				jQuery(obj).parent().addClass("selected");
			}
		}
		jQuery(window).resize(function(){
			setHeight();
		});
		function setHeight(){
			var h = document.body.clientHeight-52;
			jQuery("#hrmOrgDiv").height(h);
		}
	</script>
</body>
</html>
