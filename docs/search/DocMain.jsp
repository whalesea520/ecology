
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.rdeploy.portal.PortalUtil" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET></LINK>
<LINK href="/js/ecology8/customSelect/customSelect_wev8.css" type=text/css rel=STYLESHEET></LINK>
<script src="/js/ecology8/customSelect/customSelect_wev8.js" type="text/javascript"></script>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(92,user.getLanguage());
String needfav ="1";
String needhelp ="";

/**
* 0：最新文档
* 1：最多阅读
* 2：最多回复
* 3：评分最高
* 4：下载量最高
* 5：我的文档
* 6：文档目录
* 14：查询文档  
* 7:订阅历史
* 8:订阅审批
* 9： 订阅收回
* 10:批量添加共享
* 13:批量添加共享查询页
* 11：批量调整共享
* 12:文档弹出窗口设置
* 16:文档中心
* -99: 发文库
* 20:新建文档
* 22-23:文档回收站
*/
String urlType = Util.null2String(request.getParameter("urlType"));
String offical = Util.null2String(request.getParameter("offical"));
int officalType = Util.getIntValue(request.getParameter("officalType"),-1);
String subcompanyId = Util.null2String(request.getParameter("subcompanyId"));
if(urlType.equals(""))urlType="0";

boolean isuserdeploy = PortalUtil.isuserdeploy();
if(isuserdeploy)
{
    String _url = "";
    String doccreaterid = Util.null2String(request.getParameter("doccreaterid"));
   	if(!doccreaterid.isEmpty() || urlType.equals("5"))
    {
        _url = "/rdeploy/doc/search/DocMain.jsp?urlType=6&searchType=1";
    	
    } else if(urlType.equals("6"))
    {
        _url = "/rdeploy/doc/search/DocMain.jsp?urlType=6&searchType=3";
    }
    else if(urlType.equals("14"))
    {
        _url = "/rdeploy/doc/search/DocMain.jsp?urlType=14&searchType=2";
    }
    else if(urlType.equals("0"))
    {
        _url = "/rdeploy/doc/search/DocMain.jsp?urlType=6&searchType=0&isNew=yes";
    }
    
    
    response.sendRedirect(_url);
	return;
}


String docdetachable="0";
String isDetach=Util.null2String(request.getParameter("isDetach"));
boolean isUseDocManageDetach=ManageDetachComInfo.isUseDocManageDetach();
String hasRightSub="";
if(isUseDocManageDetach){
   docdetachable="1";
   session.setAttribute("detachable","1");
   session.setAttribute("docdetachable",docdetachable);
   hasRightSub=SubCompanyComInfo.getRightSubCompany(user.getUID(),"DocShareRight:all",-1);
   session.setAttribute("docdftsubcomid",hasRightSub);
}else{
   docdetachable="0";
   session.setAttribute("detachable","0");
   session.setAttribute("docdetachable",docdetachable);
   session.setAttribute("docdftsubcomid","0");

}
//如果开启人力资源模块管理分权显示左边的组织机构树
if("1".equals(docdetachable)&&urlType.equals("15")&&!isDetach.equals("3")){
    response.sendRedirect("DocDetach_frm.jsp?"+request.getQueryString());
    return;
}
if(urlType.equals("22")||urlType.equals("23")){
	RecordSet.executeSql("select propvalue from   doc_prop  where propkey='docsrecycle'");
	RecordSet.next();
	int docsrecycleIsOpen=Util.getIntValue(RecordSet.getString("propvalue"),0);
	if(docsrecycleIsOpen!=1){
		int isEnglish=user.getLanguage();
		if((isEnglish+"").equals("8")||isEnglish==8){
			response.sendRedirect("/docs/docs/DocRecycleRemindEng.jsp");
		}else{
			response.sendRedirect("/docs/docs/DocRecycleRemind.jsp");
		}
	}
}
if(urlType.equals("23")){
	if(!user.getLoginid().equalsIgnoreCase("sysadmin")){
		if(!HrmUserVarify.checkUserRight("DocumentRecycle:All", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
		}
	}
}
if("1".equals(docdetachable)&&urlType.equals("23")&&!isDetach.equals("3")){
    response.sendRedirect("DocRecycleDetach_frm.jsp?"+request.getQueryString());
    return;
}

String displayUsage=Util.null2o(request.getParameter("displayUsage"));
String showtype = Util.null2o(request.getParameter("showtype"));
int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
int infoId = Util.getIntValue(request.getParameter("infoId"),0);
String selectedContent = Util.null2String(request.getParameter("selectedContent"));
String selectArr = "";

LeftMenuInfoHandler infoHandler = new LeftMenuInfoHandler();
LeftMenuInfo info = infoHandler.getLeftMenuInfo(infoId);
if(info!=null){
	selectArr = info.getSelectedContent();
}
if(!"".equals(selectedContent))
{
	selectArr = selectedContent;
}
selectArr+="|";

String inMainCategoryStr = "";
String inSubCategoryStr = "";
String[] docCategoryArray = null;

%>
<BODY style="overflow-x:none;">
<%@ include file="/docs/common.jsp" %>

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
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%


String _urlType = urlType;
if(_urlType.equals("13"))_urlType = "10";
if(_urlType.equals("14"))_urlType = "6";
if(_urlType.equals("15"))_urlType = "11";
String doccreaterid = Util.null2String(request.getParameter("doccreaterid"));
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div style="display:none;" id="menuStr">
	
</div>
<% if(!urlType.equals("7") && !urlType.equals("8") && !urlType.equals("9")){ 
%>
<script type="text/javascript">
	
	function loadLeftTree(){
		e8_custom_search_for_tree("");
	}
	
	jQuery(document).ready(function(){
		<%if(!urlType.equals("0")&&!urlType.equals("5")&&!urlType.equals("2")&&!urlType.equals("14")&&!offical.equals("1")&&!urlType.equals("15")){%>
			loadLeftTree();
		<%}%>
		var urlType = "<%= urlType%>";
		var url = "DocSearchTab.jsp?urlType=<%=urlType%>&doccreaterid=<%=doccreaterid%>&<%=request.getQueryString()%>";
		if(urlType=="0"){
			url += "&isNew=yes";
		}
		if(urlType=="6"){
			url+= "&ishow=true";
		}else{
			url+="&ishow=false";
		}
		url+="&offical=<%=offical%>&officalType=<%=officalType%>";
		jQuery("#flowFrame").attr("src",url);
	});
	
	function leftMenuClickFn(attr,level,numberType,node,options){
		if(numberType==null){
			jQuery("#flowFrame").attr("src",attr.urlAll);
		}else if(numberType=="docNew"){
			jQuery("#flowFrame").attr("src",attr.urlNew);
		}else if(numberType=="docAll"){
			jQuery("#flowFrame").attr("src",attr.urlAll);
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
		if(showtype==2){
			//e8_initTree("DocSearchByOrgLeft.jsp?rightStr=Car:Maintenance");
		}else{
			e8_custom_search_for_tree("",options);
		}
	}
	
	function e8_custom_search_for_tree(categoryname,data){
			var expandAllFlag = !categoryname?false:true;
			if(!data){
				data = {
					categoryname:categoryname,
					url:"DocSearchTab.jsp",
					urlType:"<%=_urlType%>",
					offical:"<%=offical%>",
					officalType:"<%=officalType%>",
					fromadvancedmenu:"<%=fromAdvancedMenu%>",
					infoId:"<%=infoId%>",
					selectedContent:"<%=selectedContent%>",
                    subCompanyId:"<%=subcompanyId%>",
					doccreatedateselect:"<%=urlType.equals("0")?"0":"0"%>"
				};
			}else{
				data.categoryname = categoryname;
				data.offical = "<%=offical%>";
				data.officalType = "<%=officalType%>";
			}
			<%if(urlType.equals("20")){%>
				data.operationcode = <%=MultiAclManager.OPERATION_CREATEDOC%>;
			<%}%>
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
	
	
	function changeShowType(obj,showtype){
		//window.location.href='DocLatest.jsp?showtype='+showtype;
		//jQuery("#topMenuTitileTree").children("div").removeClass("selectedTitle");
		//jQuery(obj).addClass("selectedTitle");
		jQuery("#optionSpan").html(jQuery(obj).find(".e8text").html());
		jQuery("#showtype").val(showtype);
		if(showtype==2){
			jQuery("#leftTree").css("background-color",jQuery(".leftTypeSearch").css("background-color"));
			jQuery("#currentorg").removeClass("e8imgSel");
			jQuery("#currentdoc").addClass("e8imgSel");
			jQuery("#currentImg").attr("src","/images/ecology8/doc/org_wev8.png");
			showE8TypeOption();
			window.oldtree = true;
			e8_initTree("DocSearchByOrgLeft.jsp?rightStr=Car:Maintenance");
		}else{
			jQuery("#leftTree").css("background-color","");
			jQuery("#currentorg").addClass("e8imgSel");
			jQuery("#currentdoc").removeClass("e8imgSel");
			jQuery("#currentImg").attr("src","/images/ecology8/doc/doc_wev8.png");
			showE8TypeOption();
			window.oldtree = false;
			e8_custom_search_for_tree(jQuery(".leftSearchInput").val());
		}
	}
	
</script>
<%} %>
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

<%if(urlType.equals("6")){ %>
	.flowsTable td.flowMenusTd,td.leftTypeSearch{
		display:table-cell;
	}
<%} %>		
</style>
<input type="hidden" id="showtype" name="showtype" value="1"/>
<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;"  >
	<tr>
		<% if(!urlType.equals("7") && !urlType.equals("8") && !urlType.equals("9")){ %>
		<td class="leftTypeSearch">
			<div class="topMenuTitle" style="border-bottom:none;">
				<span class="leftType">
				<%if(urlType.equals("6")){ %>
					<span><img id="currentImg" style="vertical-align:middle;" src="/images/ecology8/doc/doc_wev8.png" width="16"/></span>
				<%}else{ %>
					<span><img style="vertical-align:middle;" src="/images/ecology8/request/alltype_wev8.png" width="18"/></span>
				<%} %>
				<span>
					<%if(urlType.equals("6")){ %>
						<div  id="e8typeDiv" style="width:auto;height:auto;position:relative;">
							<span id="optionSpan" onclick="e8InitTreeSearch({ifrms:'#flowFrame,#tabcontentframe',formID:'#frmmain',conditions:'#maincategory,#subcategory,#seccategory'});"><%=SystemEnv.getHtmlLabelName(16398,user.getLanguage())%></span>
							<span style="width:16px;height:16px;padding-left:8px;cursor:pointer;" onclick="showE8TypeOption();">
								<img id="e8typeImg" src="/images/ecology8/doc/down_wev8.png"/>
							</span>
						</div>
					<%}else{ %>
						<span onclick="e8InitTreeSearch({ifrms:'#flowFrame,#tabcontentframe',formID:'#frmmain',conditions:'#maincategory,#subcategory,#seccategory'});"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %></span>
					<%} %>
				</span>
				<span id="totalDoc"></span>
				</span>
				<span class="leftSearchSpan">
					<input type="text" class="leftSearchInput" style="width:110px;"/>
				</span>
			</div>
			
		</td>
		<%} %>
		<td rowspan="<%=(!urlType.equals("7") && !urlType.equals("8") && !urlType.equals("9"))?"2":"3" %>">
			<iframe src="<%=(!urlType.equals("7") && !urlType.equals("8") && !urlType.equals("9"))?"":"DocSearchTab.jsp?urlType="+urlType+"&ishow=false&"+request.getQueryString() %>" id="flowFrame" name="flowFrame" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
		</td>
	</tr>
	<%if(!urlType.equals("7") && !urlType.equals("8") && !urlType.equals("9")){ %>
	<tr>
		<td style="width:23%;" class="flowMenusTd">
			<div class="flowMenuDiv"  >
				<!--<div class="flowMenuAll"><span class="allText">全部&nbsp;</span></div>-->
				<div style="overflow:hidden;height:300px;position:relative;" id="overFlowDiv">
					<div class="ulDiv" id="e8treeArea"></div>
				</div>
			</div>
		</td>
	</tr>
	<%} %>
</table>

<%if(urlType.equals("6")){ %>
	<ul id="e8TypeOption" class="e8TypeOption">
		<li onclick="changeShowType(this,0);">
			<span id="currentdoc" class="e8img"><img src="/images/ecology8/doc/current_wev8.png"/></span>
			<span class="e8img"><img src="/images/ecology8/doc/doc_sel_wev8.png"/></span>
			<span class="e8text"><%=SystemEnv.getHtmlLabelName(16398,user.getLanguage())%></span>
		</li>
		<li onclick="changeShowType(this,2);">
			<span id="currentorg" class="e8img  e8imgSel"><img src="/images/ecology8/doc/current_wev8.png"/></span>
			<span class="e8img"><img src="/images/ecology8/doc/org_sel_wev8.png"/></span>
			<span class="e8text"><%=SystemEnv.getHtmlLabelName(25332,user.getLanguage()) %></span>
		</li>
	</ul>
<%} %>

<script language="JavaScript">

function onShowDepartment(){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+$("input[name=departmentid]").val());
	if (datas) {
        if (datas.id!=""){
			$("#departmentspan").html(datas.name);
			$("input[name=departmentid]").val(datas.id);
        }
		else{
			$("#departmentspan").html("");
			$("input[name=departmentid]").val("");
		}
	}
}
function onShowResource(){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	if(datas){
        if( datas.id!= "" ){
        	
			$("#ownerspan").html( "<a href='javaScript:openhrm("+datas.id+");' onclick='pointerXY(event);'>"+datas.name+"</a>");
			$("#owner").val(datas.id);
        }else{
        	$("#ownerspan").html("");
			$("#owner").val("");
		}
	}
}

function treeView(){
	location.href="/docs/search/DocSummary.jsp?showtype=1&displayUsage=<%=displayUsage%>&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&selectedContent=<%=selectedContent%>";
}

function viewbyOrganization(){
	location.href="/docs/search/DocSummary.jsp?showtype=2&displayUsage=<%=displayUsage%>&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&selectedContent=<%=selectedContent%>";
}

function viewByTreeDocField(){
	location.href="/docs/search/DocSummary.jsp?showtype=3";
}

</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>