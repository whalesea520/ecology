<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.file.Prop" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	/*if("false".equals(isIE)){
		request.setAttribute("labelid","27969");
		request.getRequestDispatcher("/wui/common/page/sysRemind.jsp").forward(request,response);
		return;
	}*/
    int languageId = user.getLanguage();
	int wfid = Util.getIntValue(request.getParameter("wfid"), 0);
	int formid = Util.getIntValue(request.getParameter("formid"), 0);
	int nodeid = Util.getIntValue(request.getParameter("nodeid"), 0);
	int isbill = Util.getIntValue(request.getParameter("isbill"), -1);
	int layouttype = Util.getIntValue(request.getParameter("layouttype"), -1);
	
	int modeid = Util.getIntValue(request.getParameter("modeid"), 0);
	int isform = Util.getIntValue(request.getParameter("isform"), 0);
	
	//打开明细所需的参数
	String isDetail = Util.null2String(request.getParameter("isDetail"));		
	String d_Identy = Util.null2String(request.getParameter("d_identy")).replace("detail_","");		//明细表唯一标识
	String d_num = Util.null2String(request.getParameter("d_num"));
	String detaillimit = Util.null2String(request.getParameter("detaillimit"));
	
	int nodetype = -1;
	if(nodeid > 0 ){
		String nodetypesql = "select nodetype from workflow_flownode where nodeid="+nodeid;
		RecordSet.executeSql(nodetypesql);
		if(RecordSet.first())
			nodetype = Util.getIntValue(RecordSet.getString("nodetype"),-1);
	}
%>
<HTML>
<HEAD>
	<link type="text/css" rel="stylesheet" href="/workflow/exceldesign/css/excel_wev8.css"/>
	<script type="text/javascript" src="/workflow/exceldesign/js/jquery.msDropDown_wev8.js"></script>
	<script type="text/javascript" src="/js/ecology8/spectrum/spectrum_wev8.js"></script>
	
	<link type="text/css" rel="stylesheet" href="/workflow/exceldesign/css/jquery.msDropDown_wev8.css"/>
	<link type="text/css" rel="stylesheet" href="/js/ecology8/spectrum/spectrum_wev8.css"/>
	
	<!-- 右键 -->
	<script type="text/javascript" src="/workflow/exceldesign/js/excelRightClick_wev8.js"></script>
	<script type="text/javascript" src="/workflow/exceldesign/js/excelRightClickOperat_wev8.js"></script>
	<link type="text/css" rel="stylesheet" href="/workflow/exceldesign/css/contextmenu_wev8.css"/>
	<!-- 表格基础操作 -->
	<script type="text/javascript" src="/workflow/exceldesign/js/baseOperate_wev8.js"></script>
	<script type="text/javascript" src="/workflow/exceldesign/js/designOperate_wev8.js"></script>
	<script type="text/javascript" src="/workflow/exceldesign/js/initializeJSON_wev8.js"></script>
	<script type="text/javascript" src="/workflow/exceldesign/js/eConfig_wev8.js"></script>
	<script type="text/javascript" src="/workflow/exceldesign/js/tabpage_wev8.js"></script>
	<link type="text/css" rel="stylesheet" href="/workflow/exceldesign/css/tabPage_wev8.css"/>
	<!-- 表格 Start -->
	<script type="text/javascript" src="/workflow/exceldesign/js/jquery-ui_wev8.js"></script>
	<script type="text/javascript" src="/workflow/exceldesign/js/jquery-ui-1.9.1.custom.min_wev8.js"></script>
	<!-- <script type="text/javascript" src="/workflow/exceldesign/js/excelTool.min_wev8.js"></script> -->
	<script type="text/javascript" src="/workflow/exceldesign/js/jquery.wijmo.wijspread.all.3.20142.13_wev8.js"></script>
	<link href="/workflow/exceldesign/css/jquery.wijmo.wijspread.3.20142.13_wev8.css" rel="stylesheet" type="text/css" />
	<!-- <link href="/workflow/exceldesign/css/excelTool.min_wev8.css" rel="stylesheet" type="text/css" /> -->
	<!-- 表格 End -->
	<script type="text/javascript">
		var _excel_reminder_1 = "<%=SystemEnv.getHtmlLabelName(127984,languageId)%>"; //不能对合并单元格部分更改。
		var _excel_reminder_2 = "<%=SystemEnv.getHtmlLabelName(127985,languageId)%>";
		var _excel_reminder_3 = "<%=SystemEnv.getHtmlLabelName(127986,languageId)%>";
		var _excel_reminder_4 = "<%=SystemEnv.getHtmlLabelName(127987,languageId)%>";
		var _excel_reminder_5 = "<%=SystemEnv.getHtmlLabelName(127988,languageId)%>";
		var _excel_reminder_6 = "<%=SystemEnv.getHtmlLabelName(127989,languageId)%>";
	    var isDetail = "<%=isDetail%>";
		var detailIdenty = "<%=d_Identy%>";
		var storage;	//本地存储
		var storageKey = "weaver_excel_SheetJson_<%=nodeid%>_<%=modeid%>";
		var wfinfo = {				//全局的流程相关参数
			"wfid" : "<%=wfid %>",
			"nodeid" : "<%=nodeid %>",
			"nodetype" : "<%=nodetype %>",
			"formid" : "<%=formid %>",
			"isbill" : "<%=isbill %>",
			"layouttype" : "<%=layouttype %>",	//0:显示 1：打印，2：mobile
			"isform" : "<%=isform %>",
			"modeid" : "<%=modeid %>"
		};
		
		//屏蔽系统右键
	    $(document).unbind("contextmenu").bind("contextmenu", function (e) {
	        return false;
	    });
	    //ctrl+s/S 保存
		document.onkeydown = function(event){
		   	if (!isDetail && (event.ctrlKey) && (event.keyCode==115 || event.keyCode==83)){
		   		checkServer(formOperate.saveLayoutWindowFace,'saveLayout');
		    	event.returnValue=false;
		    	return;
		   	}
	  	}
	  	
		jQuery(document).ready(function(){
			//明细窗口的wfinfo对象取主表的
			if(isDetail==="on" && wfinfo){
				wfinfo = parent.getParentWindow(window).wfinfo;
			}
			var dlgdiv = window.top.getDialog(window).getDialogDiv();
			var dlgtd = $(dlgdiv).children("table").find("tr").eq(1).children("td");
			$(dlgtd).css("border-color","transparent");
			$("#loadingdiv").hide();
			$(".excelBody").show();
			$(".excelSet").height(($("body").height()-130)+"px");
			$(".excelSet").show();
			bindShrinkEvent();
			
			if(window.localStorage){
			 	storage = window.localStorage;
			 	if(!storage.getItem(storageKey));
		 		else{
		 			if(!isDetail)
			 		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(127990,languageId)%>",function(){
			 			formOperate.importTemplateFace(storage.getItem(storageKey), "impCache");
		 				storage.removeItem(storageKey);
		 			},function(){
		 				storage.removeItem(storageKey);
		 			});
		 		}
			};
			$(".survey_container").height($(window).height()-$(".editor_nav").height());
			$(".excelBody").width(($(window).width()-230)+"px");
			$(".moduleRightContainer").width($(".moduleContainer").width()-$(".moduleLeftMenu").width()-$(".moduleLeftMenuSplitLine").width());
			var excelDiv = jQuery("#excelDiv"); 			//excelBody.excelDiv
			var operatpanel = jQuery(".excelHeadContent");	//excelHeadBG.excelHeadTable
			baseOperate.bindOperateBtnEventFace(operatpanel,excelDiv);		//绑定操作事件			
			if(!isDetail){		//恢复主表需先恢复全局缓存、绑定Tab页事件
				formOperate.resumeLayoutCacheFace();
				tabOperate.bindTabEventFace();
			}
			baseOperate.initPanelRightMenuFace();	//初始化 右键菜单
		});
		
		//改变窗体的大小
		function changeWinSize(obj){
			//还原
			if($(obj).is(".restore")){
				$(obj).removeClass("restore").addClass("maxwin");
			}else{ 	//最大化
				$(obj).removeClass("maxwin").addClass("restore");
			}
			parentDialog.maxOrRecoveryWindow(obj);
			var dlgdiv = window.top.getDialog(window).getDialogDiv();
			$(dlgdiv).find("div[id^=_Container_]").css("height",($(dlgdiv).find("div[id^=_Container_]").height()+30)+"px");
			if($("div.excelSet").is(":hidden"))
				$("div.excelBody").css("width",($(window).width()-10)+"px");
			else
				$("div.excelBody").css("width",($(window).width()-230)+"px");
			jQuery("#excelDiv").css("height",($(window).height()-132)+"px");
				
			$(".moduleRightContainer").width($(".moduleContainer").width()-$(".moduleLeftMenu").width()-$(".moduleLeftMenuSplitLine").width());
			$(".survey_container").height($(window).height()-$(".editor_nav").height());
			$('#showModule').contents().find(".moduleContent").css("height",($(window).height()-25-14-40)+"px");
			
			var _fh = $(".excelSet").height();
			$(".excelSet").css("height",($(window).height()-$(".editor_nav").height()-$(".excelHeadBG").height())+"px");
			var _ch = $(".excelSet").height();
			$(".excelSet .tableBody").css("height",($(".excelSet .tableBody").height()+(_ch-_fh))+"px");
			if(isDetail != "on"){
				if($(".tabdiv").css("display") == "block"){
					var tabarea_height = $(".tabdiv").height() + $(".tabSplitLine").height();
					$(".tabdiv .tableft").width($(".tabdiv").width()-$(".tabdiv .tabright").width());
					$("#excelDiv").css("height", $("#excelDiv").height()-tabarea_height);
					$(".excelSet").css("height", $(".excelSet").height()-tabarea_height);
					$(".excelSet .tableBody").css("height", $(".excelSet .tableBody").height()-tabarea_height);
				}
			}
		}
		
		//重新加载
		function reloadExcelMain(nodeid, layouttype, layoutid){
			window.location = "/workflow/exceldesign/excelMain.jsp?wfid=<%=wfid%>&nodeid="+nodeid+"&formid=<%=formid%>&isbill=<%=isbill%>&layouttype="+layouttype+"&modeid="+layoutid;
		}
	</script>
</HEAD>
<body style="overflow:hidden">
<!-- 提交loading -->
<div id="submitloaddingdiv_out" style="display:none;position:absolute;width:100%;height:100%;top:0px;left:0px;background:#000;z-index:999999;filter:alpha(opacity=20);-moz-opacity:0.2;opacity:0.2;"></div>
<span id="submitloaddingdiv" style="display:none;height:48px;border:1px solid #9cc5db;background:#ebf8ff;color:#4c7c9f;line-height:48px;width:217px;position:absolute;z-index:9999;font-size:12px;">
	<img src="/images/ecology8/workflow/multres/cg_lodding_wev8.gif" height="27px" width="57px" style="vertical-align:middle;"/><span style="margin-left:22px;"><%=SystemEnv.getHtmlLabelName(84041,languageId)%></span>
	<div style="display:none;"><img src="/wui/theme/ecology8/skins/default/rightbox/icon_query_wev8.png" /></div>
</span>

<!-- 顶部页签切换 -->
<div class="editor_nav">
    <div class="container">
        <div class="btns">
        	<span title="<%=SystemEnv.getHtmlLabelName(19944,languageId)%>" class="maxwin" onclick="changeWinSize(this)"> </span>&nbsp;
            <span title="<%=SystemEnv.getHtmlLabelName(309,languageId)%>" class="close" onclick="checkServer(closeDesignWin,'close')"> </span>&nbsp;
        </div>
         <div class="nav">
         	<span class="excel_opitem s_module" class="" style="<%=(isDetail.equals("on"))?"display:none":"" %>" ><%=SystemEnv.getHtmlLabelName(64,languageId)%></span>
            <span class="excel_opitem s_format <%=(isDetail.equals("on"))?"":"current" %>" name="parts"><%=SystemEnv.getHtmlLabelName(15196,languageId)%></span>
            <span class="excel_opitem s_insert" ><%=SystemEnv.getHtmlLabelName(30615,languageId)%></span>
            <span class="excel_opitem s_filed" ><%=SystemEnv.getHtmlLabelName(82113,languageId)%></span>
            <span class="excel_opitem s_detail <%=(isDetail.equals("on"))?"current":"" %>"><%=SystemEnv.getHtmlLabelName(19325,languageId)%></span>
            <span class="excel_opitem s_style" style="<%=(isDetail.equals("on"))?"display:none":"" %>" ><%=SystemEnv.getHtmlLabelName(1014,languageId)%></span>
        </div>
    </div>
</div>

<!-- 除模板页签 外 所有的菜单 -->
<div class="survey_container" style="width:100%;height:100%">
<!-- 表单头部操作栏 -->
<div class="excelHeadBG">
	<jsp:include page="/workflow/exceldesign/excelOperatHead.jsp">
		<jsp:param name="isDetail" value="<%=isDetail %>" />
		<jsp:param name="d_identy" value="<%=d_Identy %>" />
		<jsp:param name="d_num" value="<%=d_num %>" />
		<jsp:param name="layouttype" value="<%=layouttype %>" />
		<jsp:param name="nodetype" value="<%=nodetype %>" />
	</jsp:include>
</div>

<!-- 打开loading -->
<div id="loadingdiv" style="font-size:14px; text-align:center; line-height:600px;">
	<span style="border: 1px solid #e1e1e1;text-align: center;color: #59627c;padding:9px;padding-left:15px;padding-right:15px;">
		<img src="/workflow/exceldesign/image/shortBtn/onload_wev8.png" border="no" style="position: relative;top: 3px;margin-right: 10px;" /> 
		<span><%=SystemEnv.getHtmlLabelName(128943 ,user.getLanguage()) %></span>
	</span>
</div>

<!-- 表格主体 -->
<div class="excelBody" style="display:none; position:relative">
	<jsp:include page="/workflow/exceldesign/excelBody.jsp">
		<jsp:param name="isDetail" value="<%=isDetail %>" />
		<jsp:param name="d_identy" value="<%=d_Identy %>" />
		<jsp:param name="language_id" value="<%=user.getLanguage() %>" />
	</jsp:include>
</div>
<div class="shrinkBtn hideShrinkBtn" style="display:none;" onclick="javascript:shrinkClick()"></div>
<div class="excelSet" style="display:none;">
	<%if(!"on".equals(isDetail)){ %>
	<jsp:include page="/workflow/exceldesign/excelSet.jsp">
		<jsp:param name="wfid" value="<%=wfid %>" />
		<jsp:param name="formid" value="<%=formid %>" />
		<jsp:param name="nodeid" value="<%=nodeid %>" />
		<jsp:param name="isbill" value="<%=isbill %>" />
		<jsp:param name="layouttype" value="<%=layouttype %>" />
		<jsp:param name="modeid" value="<%=modeid %>" />
		<jsp:param name="isform" value="<%=isform %>" />
	</jsp:include>
	<%}else{ %>
	<jsp:include page="/workflow/exceldesign/excelSetDetail.jsp">
		<jsp:param name="formid" value="<%=formid %>" />
		<jsp:param name="isbill" value="<%=isbill %>" />
		<jsp:param name="d_identy" value="<%=d_Identy %>" />
		<jsp:param name="detaillimit" value="<%=detaillimit %>" />
		<jsp:param name="layouttype" value="<%=layouttype %>" />
		<jsp:param name="nodetype" value="<%=nodetype %>" />
		<jsp:param name="languageid" value="<%=user.getLanguage() %>" />
	</jsp:include>
	<%} %>
</div>
<div id="formulaMasking1" class="formulamask" style="display:none; width:100%; top:0px;"></div>
<div id="formulaMasking2" class="formulamask" style="display:none; width:220px; right:0px;"></div>
<!-- 编辑面板遮罩层 -->
<div id="excelMasking" class="formulamask" style="display:none; left:0px;"></div>
<!-- 标签头部遮罩层 -->
<div id="tabHeadMasking" class="formulamask" style="display:none; width:100%; left:0px;"></div>

<!-- tab页 模板 -->
<div class="moduleContainer">
	<div class="moduleLeftMenu">
		<div id="import" class="moduleLeftBtn importBtn"><%=SystemEnv.getHtmlLabelName(34243,languageId)%></div>
		<div id="export" class="moduleLeftBtn exportBtn"><%=SystemEnv.getHtmlLabelName(128951,languageId)%></div>
		<div style="width:70%;height:1px;background:#C1D3DC;margin-left: 20px;margin-top: 20px;"></div>
		<div id="show" target="0" class="moduleLeftBtn showBtn"><%=SystemEnv.getHtmlLabelName(16450,languageId)%></div>
		<div id="print" target="1" class="moduleLeftBtn printBtn"><%=SystemEnv.getHtmlLabelName(128952,languageId)%></div>
		<%
			boolean isHaveMessager=Prop.getPropValue("Mobile","IsUseMobileHtmlLayout").equalsIgnoreCase("1");
			if(isHaveMessager){
		%>
			<div id="mobile" target="2" class="moduleLeftBtn mobileBtn"><%=SystemEnv.getHtmlLabelName(125554,languageId)%></div>
		<% } %>
	</div>
	<div class="moduleLeftMenuSplitLine"></div>
	<div class="moduleRightContainer">
		 <iframe id="showModule" frameborder=0 scrolling=no width="100%" height="100%"></iframe>
	</div>
</div>
</div>
<ul id="excelRightMenu" class="contextMenu menu2"></ul>
<ul id="mainDetailMenu" class="contextMenu menu2"></ul>
<ul id="tabRightMenu" class="contextMenu menu2"></ul>

<iframe id="exportifram" name="exportifram" style="display: none"></iframe>
<form id="exportForm" name="exportForm" target="exportifram" action="/workflow/exceldesign/excelExport.jsp" method="post">
	<textarea id="exportJson" name="exportJson" style="display:none"></textarea>
	<input type="hidden" name="nodeid" value="<%=nodeid%>" />
</form>
 
</BODY>
</HTML>
