<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String urlType = Util.null2String(request.getParameter("urlType"));
String subcompanyid1 = Util.null2String(request.getParameter("subcompanyid1"));
String isdata = Util.null2String(request.getParameter("isdata"));
String from = Util.null2String(request.getParameter("from"));
if(urlType.equals(""))urlType="0";

    String cptdata1_maintenance=Util.null2String(request.getParameter("cptdata1_maintenance"));//来自资产资料维护页面
    String cpt_mycapital=Util.null2String(request.getParameter("cpt_mycapital"));//来自我的资产页面
    String cpt_search=Util.null2String(request.getParameter("cpt_search"));//来自查询资产页面
    String id=Util.null2String(request.getParameter("paraid"));
    String checktype=Util.null2String(request.getParameter("checktype"));  //radio or not
    String onlyendnode=Util.null2String(request.getParameter("onlyendnode")); //如果需要check是否仅仅只是没有孩子的节点
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "
http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML>
<HEAD>

<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	
<link rel="stylesheet" href="/css/ecology8/request/leftNumMenu_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/leftNumMenu_wev8.js"></script>
<script type="text/javascript">
var cptdata1_maintenance="<%=cptdata1_maintenance %>";
var cpt_mycapital="<%=cpt_mycapital %>";
var cpt_search="<%=cpt_search %>";
var linkUrl=cptdata1_maintenance==1?"/cpt/capital/CptCapMain_data1tab.jsp"
		:cpt_mycapital==1?"/cpt/search/CptMyCapitaltab.jsp"
		:cpt_search==1?"/cpt/search/CptSearchtab.jsp"
				:"/cpt/maintenance/CptAssortmentTab.jsp";


</script>
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
				<span class="leftType" onclick="reload()">
				<span><img style="vertical-align:middle;" src="/images/ecology8/request/alltype_wev8.png" width="18" /></span>
				<span><%=SystemEnv.getHtmlLabelNames("831",user.getLanguage())%></span>
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
jQuery(document).ready(function(){
	initTree();
});

function reload(){
	e8InitTreeSearch({ifrms:'',formID:'',conditions:''});
	//initTree();
	var optFrame=$("#optFrame",parent.document);
	var src=optFrame.attr("src");
	src= src.replace("&paraid=","&nouse=");
	
	//console.log("reload src:"+src);
	optFrame.attr("src",src);
}

function initTree(){
	var isdata='<%=isdata %>';
	var from='<%=from %>';
	var numbertypes={};
	if(from!='cptassortment'){
		numbertypes={hoverColor:"#A6A6A6",color:"black",title:(isdata==1?"<%=SystemEnv.getHtmlLabelNames("83674",user.getLanguage())%>":"<%=SystemEnv.getHtmlLabelNames("83675",user.getLanguage())%>")};
	}
	
	var demoLeftMenus="/cpt/maintenance/CptAssortmentTree2Data.jsp?from=<%=from %>&isdata=<%=isdata %>&cpt_mycapital=<%=cpt_mycapital %>&subcompanyid1=<%=subcompanyid1 %>";
	$(".ulDiv").leftNumMenu(demoLeftMenus,{
		numberTypes:{
			data2count:numbertypes
		},
		showZero:false,
		clickFunction:function(attr,level,numberType,node){
			leftMenuClickFn(attr,level,numberType,node);
		},
		expand:{
			url:function(attr,level){
					//void(0);
				},
			done:function(children,attr,level){
				//void(0);
				//$('#overFlowDiv').perfectScrollbar();
			}
		},
		
	});
}


function leftMenuClickFn(attr,level,numberType,node){
	if(attr.groupid){
		
		var from='<%=from %>';
		if('cptassortment'==from){
			var optFrame=$("#optFrame",parent.document);
			var src=optFrame.attr("src");
			
			if(src.indexOf("&paraid=")>-1){
				src= src.replace("&paraid=","&nouse=")+"&paraid="+attr.groupid;
			}else{
				src=src+"&paraid="+attr.groupid;
			}
			if(src.indexOf("&subcompanyid1=")>-1){
				src= src.replace("&subcompanyid1=","&nouse=")+"&subcompanyid1=<%=subcompanyid1 %>";
			}else{
				src=src+"&subcompanyid1=<%=subcompanyid1 %>";
			}
			//console.log("optFrame src:"+src);
			optFrame.attr("src",src);
			
		}else{
		   	var targetContent=$("#optFrame",parent.document).contents().find("iframe[name=tabcontentframe]").contents();
		   	targetContent.find("input[name=paraid]").val(attr.groupid);
		   	targetContent.find("input[type=submit]").trigger("click");
		}
		
	}
}

</script>

</body>
</HTML>
