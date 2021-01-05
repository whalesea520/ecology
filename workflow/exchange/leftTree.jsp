<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>

<%
String companyid = Util.null2String(request.getParameter("companyid"));
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
int operatelevel = 0 ;
String wftypeid = Util.null2String(request.getParameter("wftypeid"));
int detachable = -2;
boolean isUseWfManageDetach = manageDetachComInfo.isUseWfManageDetach();
if(isUseWfManageDetach){
	detachable = 1;
}
String tempurl = "detachable="+detachable+"&companyid="+companyid+"&subcompanyid="+subcompanyid+"&departmentid="+departmentid;
%>
<!DOCTYPE html>
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
				<span class="leftType" onclick="reload()">
				<span><img style="vertical-align:middle;" src="/images/ecology8/request/alltype_wev8.png" width="18" /></span>
				<span><%=SystemEnv.getHtmlLabelName(21979,user.getLanguage())%></span>
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
		<td style="width:246px;" class="flowMenusTd">
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
	var optFrame=$("#wfmainFrame",parent.document);
	var src=optFrame.attr("src")+"";
	if(src.indexOf("?")!=-1){
		src = src.substr(0,src.indexOf("?"));
	}
	optFrame.attr("src",src+"?1=1");
	//optFrame.attr("src",src.replace("&wfid","&nouse"));
	//optFrame.attr("src",src.replace("&wftypeid","&nouse1"));
	//optFrame.attr("src",src.replace("&workflowid","&nouse2"));
}

jQuery(document).ready(function(){
	var demoLeftMenus="/workflow/exchange/TreeData.jsp?<%=tempurl%>&urlType=";
	$(".ulDiv").leftNumMenu(demoLeftMenus,{
		numberTypes:{
			indatacount:{hoverColor:"#EDCEAF",color:"black",title:"<%=SystemEnv.getHtmlLabelName(84584,user.getLanguage())%>"},
			outdatacount:{hoverColor:"#C0D8B8",color:"black",title:"<%=SystemEnv.getHtmlLabelName(84585,user.getLanguage())%>"}
		},
		showZero:true,
		selectFirst:'',
		
		clickFunction:function(attr,level,numberType,node){
			leftMenuClickFn(attr,level,numberType,node);
		},
		expand:{
			url:function(attr,level){
			void(0);
			},
			done:function(children,attr,level){
				void(0);
				//$('#overFlowDiv').perfectScrollbar();
			}
		},
		
	});
	
});

			
function leftMenuClickFn(attr,level,numberType,node){
	if(attr.workflowid){
		var rightFrame=window.parent.document.getElementById('wfmainFrame');
		var src=rightFrame.src;
		src = src.replace("&wftypeid","&nouse");
		if(src.indexOf("wfid")>-1){
			src=src.substring(0, src.indexOf("wfid"))+"wfid="+attr.workflowid;
		}else{
			src+="&wfid="+attr.workflowid+"&wftypeid="+attr.workflowtype;
		}
		rightFrame.src=src;
	}else{
		var rightFrame=window.parent.document.getElementById('wfmainFrame');
		var src=rightFrame.src;
		src = src.replace("&wfid","&nouse");
		if(src.indexOf("wftypeid")>-1){
			src=src.substring(0, src.indexOf("wftypeid"))+"wftypeid="+attr.typeid;
		}else{
			src+="&wftypeid="+attr.typeid;
		}
		rightFrame.src=src;
	}
}

</script>
</body>
</HTML>
