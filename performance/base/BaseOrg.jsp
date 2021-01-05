<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<html>
<HEAD>
<link type='text/css' rel='stylesheet'  href='/secondwev/tree/js/treeviewAsync/eui.tree.css'/>
<link type='text/css' rel='stylesheet' href='../css/tree.css' />
<script language='javascript' type='text/javascript' src='/secondwev/tree/js/treeviewAsync/jquery.treeview.js'></script>
<script language='javascript' type='text/javascript' src='/secondwev/tree/js/treeviewAsync/jquery.treeview.async.js'></script>

<link href="../css/jquery.jscrollpane.css" rel="stylesheet" />
<!-- script type='text/javascript' src="../js/jquery.jscrollpane.js"></script -->
		<!-- script type='text/javascript' src="../js/jquery.mousewheel.js"></script -->
<%@ include file="/secondwev/common/head.jsp" %>
	</head>
<body style="overflow: hidden;margin: 0px;">
	<div style="width:100%;border-top:1px solid  #D6D6D6;line-height:1px"></div>
	<div id="hrmOrgDiv" class="divorg" class="scroll-pane" style="width: 100%;height: 100%;overflow: auto;"></div>
	<FORM id="orgform" name="orgform" action="BaseSetting.jsp" method="post" target="pageRight">
		<input type="hidden" id="resourceid" name="resourceid"/>
		<input type="hidden" id="resourcetype" name="resourcetype"/>
	</FORM>
	<script>
		jQuery(document).ready(function(){
			//jQuery("#hrmOrgDiv").jScrollPane();
			jQuery("#hrmOrgDiv").append('<ul id="hrmOrgTree" class="hrmOrg" style="width:100%"></ul>');
			jQuery("#hrmOrgTree").treeview({
		       url:"/secondwev/tree/hrmOrgTree.jsp?ifShowHrm=0"
		    });
		});

		function doClick(orgId,type,obj){
			if(type==1){
				jQuery("#orgform").attr("action","BaseInit.jsp");
				jQuery("#orgform").submit();
			}else{
				jQuery("#orgform").attr("action","BaseSetting.jsp");
				jQuery("#resourceid").val(orgId);
				jQuery("#resourcetype").val(type);
				jQuery("#orgform").submit();
			}
			if(obj){
				jQuery(obj).css("font-weight","normal");
				jQuery(obj).parent().parent().find(".selected").removeClass("selected");
				jQuery(obj).parent().addClass("selected");
			}
		}
	</script>
</body>
</html>
