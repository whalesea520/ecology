<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET></LINK>
<LINK href="/js/ecology8/customSelect/customSelect_wev8.css" type=text/css rel=STYLESHEET></LINK>
<script src="/js/ecology8/customSelect/customSelect_wev8.js" type="text/javascript"></script>
</head>
<%
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(92,user.getLanguage());
String urlType = Util.null2String(request.getParameter("urlType"));
String offical = Util.null2String(request.getParameter("offical"));
int officalType = Util.getIntValue(request.getParameter("officalType"),-1);
%>
<BODY style="overflow-x:none;">
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<%if(urlType.equals("6")){ %>
<script type="text/javascript">
	window.existXZtree = true;
</script>
<script type="text/javascript" src="/js/xtree_wev8.js"></script>
<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
<script type="text/javascript" src="/js/cxloadtree_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/xtree_wev8.css" />
<%} %>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" ></link>
<link type="text/css" href="/js/tabs/css/e8tabs3_wev8.css" rel="stylesheet" ></link>
<script type="text/javascript">
	window.notExecute = true;
	jQuery(document).ready(function(){
	    window.oldtree = false;
	});
</script>
<%
String _urlType = urlType;
if(_urlType.equals("14"))
    _urlType = "6";
String searchType = Util.null2String(request.getParameter("searchType")); // 0 最近更新 1 我的文档 2 查询文档 3 文档目录
String isNew = Util.null2String(request.getParameter("isNew")); 
String doccreaterid = "";
if(searchType.equals("1"))
{
    doccreaterid = user.getUID()+"";
}
%>

<div style="display:none;" id="menuStr">
	
</div>

<script type="text/javascript">
	
	function loadLeftTree(){
		e8_custom_search_for_tree("");
	}
	
	jQuery(document).ready(function(){
		<%if(urlType.equals("6")){%>
			loadLeftTree();
		<%}%>
		var urlType = "<%= urlType%>";
		var url = "DocSearchTab.jsp?urlType=<%=urlType%>&doccreaterid=<%=doccreaterid%>&<%=request.getQueryString()%>";
		url+="&offical=<%=offical%>&officalType=<%=officalType%>";
		
		jQuery("#flowFrame").attr("src",url);
	});
	
	function leftMenuClickFn(attr,level,numberType,node,options){
	
		if(<%= searchType.equals("2") || searchType.equals("3") %>){
			jQuery("#flowFrame").attr("src",attr.urlAll+"&searchType=<%= searchType %>");
		}
		else if(<%= searchType.equals("1") %>)
		{
		    jQuery("#flowFrame").attr("src",attr.urlAll+"&searchType=<%= searchType %>&doccreaterid=<%= doccreaterid %>");
		}
		else if(<%= searchType.equals("0") %>)
		{
			jQuery("#flowFrame").attr("src",attr.urlNew+"&searchType=<%= searchType %>");
		}else{
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83437,user.getLanguage())%>");
		}
	}
	
	/**
	*刷新左侧菜单栏
	*/
	function refreshLeftMenu(param,doccreaterid,urlType,url,options){
		var _options = {};
		if(options){
			options.doccreatedateselect = param;
			options.doccreaterid = doccreaterid;
			options.urlType = urlType;
			options.url = url;
		}else{
			_options.doccreatedateselect = param;
			_options.doccreaterid = doccreaterid;
			_options.urlType = urlType;
			_options.url = url;
			options = _options;
		}
		var showtype=parseInt(jQuery("#showtype").val());
		e8_custom_search_for_tree("",options);
	}
	
	function e8_custom_search_for_tree(categoryname,data){
			var expandAllFlag = !categoryname?false:true;
			if(!data){
				data = {
					categoryname:categoryname,
					url:"DocSearchTab.jsp",
					urlType:"<%=_urlType%>",
					searchType:"<%= searchType %>",
					offical:"<%=offical%>",
					officalType:"<%=officalType%>",
					doccreatedateselect:"<%=urlType.equals("0")?"0":"0"%>"
				};
			}else{
				data.categoryname = categoryname;
				data.offical = "<%=offical%>";
				data.searchType = "<%= searchType %>";
				data.officalType = "<%=officalType%>";
			}
			jQuery.ajax({
				url:"DocSearchMenu.jsp",
				type:"post",
				dataType:"json",
				data:data,
				beforeSend:function(){
					if(jQuery(".leftTypeSearch").css("display")!="none" || "<%=urlType%>"=="6")
						e8_before2();
				},
				complete:function(xhr){
					e8_after2();
				},
				success:function(data){
					var demoLeftMenus = data;
					$(".ulDiv").leftNumMenu(demoLeftMenus,{
							numberTypes:{
								docNew:{hoverColor:"#EE5F5F",color:"#EE5F5F",title:"<%=SystemEnv.getHtmlLabelName(83438,user.getLanguage())%>"},
								docAll:{hoverColor:"#A6A6A6",color:"black",title:"<%=SystemEnv.getHtmlLabelName(30898,user.getLanguage())%>"}
							},
							showZero:false,
							multiJson:true,	
							_callback:expandAllFlag?_expandAll:null,	
							clickFunction:function(attr,level,numberType,node,options){
								leftMenuClickFn(attr,level,numberType,node,options);
							}
					});
					if(data && data.seccategory){
						selectDefaultNode("categoryid",data.seccategory);
					}
				}
			});
		}
	
	
</script>
<style type="text/css">
	.topMenuTitle{
	    border-bottom: 1px solid #C0C0C0;
	    margin: 0;
	    position: relative;
	    vertical-align: middle;
	    width: 100%;
	    line-height:40px;
	   	cursor:pointer;
		}
	
	.selectedTitle {
	    background-color: #E3E1E2;
	    color: black;
	    cursor:default;
	}
	
	.cxtree
	{
	    overflow:hidden !important;
	    height:100%;
	    width:100%;
	    padding:0px 0px;
		*padding-top: 8px;
	}	
	
</style>
<input type="hidden" id="showtype" name="showtype" value="1"/>
<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;"  >
	<tr>
		<td class="leftTypeSearch">
			<div class="topMenuTitle" style="border-bottom:none;">
				<span class="leftType">
				
					<span><img style="vertical-align:middle;" src="/images/ecology8/request/alltype_wev8.png" width="18"/></span>
				<span>
					
						<span onclick="e8InitTreeSearch({ifrms:'#flowFrame,#tabcontentframe',formID:'#frmmain',conditions:'#maincategory,#subcategory,#seccategory'});"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %></span>
				</span>
				<span id="totalDoc"></span>
				</span>
				<span class="leftSearchSpan">
					<input type="text" class="leftSearchInput" style="width:110px;"/>
				</span>
			</div>
			
		</td>
		<td rowspan="2">
			<iframe src="" id="flowFrame" name="flowFrame" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
		</td>
	</tr>
	<tr>
		<td style="width:23%;" class="flowMenusTd">
			<div class="flowMenuDiv"  >
				<div style="overflow:hidden;height:300px;position:relative;" id="overFlowDiv">
					<div class="ulDiv" id="e8treeArea"></div>
				</div>
			</div>
		</td>
	</tr>
</table>
</body>
</html>