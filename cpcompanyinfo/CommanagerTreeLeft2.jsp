<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String urlType = Util.null2String(request.getParameter("urlType"));

String id=Util.null2String(request.getParameter("paraid"));
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "
http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML>
<HEAD>

<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	
<link rel="stylesheet" href="/css/ecology8/request/leftNumMenu_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/leftNumMenu_wev8.js"></script>
</HEAD>
<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<script type="text/javascript">
rightMenu.style.visibility='hidden';
</script>

<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;height:100%;"  >
	<tr>
		<td class="leftTypeSearch" >
			<div>
				<span class="leftType" onclick="">
				<span><img style="vertical-align:middle;" src="/images/ecology8/request/alltype_wev8.png" width="18" /></span>
				<span><%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(6105,user.getLanguage()) %></span>
				<span id="totalDoc"></span>
				</span>
				<span class="leftSearchSpan">
					<input type="text" class="leftSearchInput"/>
				</span>
			</div>
		</td>
		<td rowspan="2">
		</td>
	</tr>
	<tr>
		<td style="width:220px;" class="flowMenusTd">
			<div class="flowMenuDiv"  >
				<div style="overflow:hidden;height:1000px;position:relative;" id="overFlowDiv">
					<div class="ulDiv" ></div>
				</div>
			</div>
		</td>
	</tr>
</table>
<script type="text/javascript">
function reload(){
	e8InitTreeSearch({ifrms:'',formID:'',conditions:''});
	var optFrame=$("#optFrame",parent.document);
	var src=optFrame.attr("src");
	//alert(src);
	optFrame.attr("src",src.replace("&paraid","&nouse"));
}

jQuery(document).ready(function(){
	var demoLeftMenus="/cpcompanyinfo/CommanagerTreeLeft2Data.jsp?urlType=<%=urlType %>";
	$(".ulDiv").leftNumMenu(demoLeftMenus,{
		numberTypes:{
			data2count:{hoverColor:"#A6A6A6",color:"black",title:"<%=SystemEnv.getHtmlLabelNames("83860",user.getLanguage())%>"}
		},
		showZero:false,
		clickFunction:function(attr,level,numberType,node){
			leftMenuClickFn(attr,level,numberType,node);
		},
		expand:{
			url:function(attr,level){void(0);},
			done:function(children,attr,level){
				void(0);
				//$('#overFlowDiv').perfectScrollbar();
			}
		},
		
	});
	
});

function leftMenuClickFn(attr,level,numberType,node){
	if(attr.groupid){
		
		var targetContent=$("#optFrame",parent.document).contents().find("iframe[name=tabcontentframe]");
		if(attr.groupid>0){
			targetContent.attr("src","/cpcompanyinfo/Comcheckright.jsp?comid="+attr.groupid);
			//console.log();
		}else{
			targetContent.attr("src","/cpcompanyinfo/CommanagerTreeRightTab.jsp");
		}
	}
}

</script>
</body>
</HTML>
