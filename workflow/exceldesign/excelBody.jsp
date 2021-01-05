<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%
	String isDetail = Util.null2String(request.getParameter("isDetail"));
	int language_id = Util.getIntValue(request.getParameter("language_id"), 7);
%>
<html>
<head>
<script type="text/javascript">
	jQuery(document).ready(function(){
		var excelDiv = jQuery("#excelDiv");
		jQuery("#excelDiv").css("height",($(window).height()-132)+"px");
		if(isDetail === "on"){		//恢复 明细
			if(parentWin_Main.globalSheet.hasCache("detail_"+detailIdenty+"_sheet")){
				commonGridCreate(excelDiv,"1");	//1是恢复
				formOperate.resumeWindowFace("detail_"+detailIdenty);
			}else{ 
				//新建明细表 初始化
				commonGridCreate(excelDiv,"0");
				formOperate.initWindowFace("detail_"+detailIdenty);
			}
		}else{
			var sheetJson = getSheetJson();
			if(!sheetJson || "" === sheetJson || "null" === sheetJson ){
				//新建主表 初始化
				commonGridCreate(excelDiv,"0");
				formOperate.initWindowFace("main");
			}else{
				commonGridCreate(excelDiv,"1");
				formOperate.resumeWindowFace("main");
			}
			//初始化隐藏的面板excelDiv_hidden，用于保存
			commonGridCreate(jQuery("#excelDiv_hidden"), "2");
			//初始化多字段面板
			commonGridCreate(jQuery("#excelDiv_mc"), "2");
			//jQuery("div#excelDiv_mcvp").parent().parent().next().remove();		//去除横向滚动条
		}
	});
	
	function commonGridCreate(container, initnr) {
		container.wijspread({sheetCount:1});
        if ($.browser.msie && parseInt($.browser.version, 10) < 9) {		//run for ie7/8
            var spread = container.wijspread("spread");
            spread.bind("SpreadsheetObjectLoaded", function () {
                initSpreadGrid(container, initnr);
            });
        }else{
            initSpreadGrid(container, initnr);
        }
    }
       
    function initSpreadGrid(container, initnr){
    	var spread = container.wijspread("spread");
        spread.useWijmoTheme = false;
        var sheet = spread.getActiveSheet();
        sheet.autoGenerateColumns = false;
        if(initnr==="0"){		//绑定事件
        	spread.fromJSON(templteStrModel);
        	baseOperate.bindSpreadEventFace(spread);
       	}
    }
</script>
</head>
<body>
	<div id="excelDiv" excelid="main-4bf07297-65b2-45ca-b905-6fc6f2f39158" style="width:100%;height:495px;overflow:hidden;padding-right:5px;padding-bottom:5px;"></div>
	<%if(!"on".equals(isDetail)){ %>
		<!-- 隐藏的面板，只用于保存时切换 -->
		<div id="excelDiv_hidden" excelid="main-panel-hidden" style="display:none"></div>
		<!-- 多内容编辑窗口 -->
		<div id="mcDiv" class="mcDiv" style="display:none;">
			<div id="excelDiv_mc" excelid="more-content-panel" style="width:320px; height:260px; "></div>
			<div class="mcOper">
				<div id="mc_confirm" class="mcBtn" onclick="mcOperate.confirmFace();" style="border-right:2px solid #e6efef;">
					<img src="/workflow/exceldesign/image/shortBtn/morecontent/confirm_wev8.png"/>
					<span><%=SystemEnv.getHtmlLabelName(83446, language_id) %></span>
				</div>
				<div id="mc_cancel" class="mcBtn" onclick="mcOperate.cleanFace();">
					<img src="/workflow/exceldesign/image/shortBtn/morecontent/cancel_wev8.png"/>
					<span><%=SystemEnv.getHtmlLabelName(311, language_id) %></span>
				</div>
			</div>
			<input type="hidden" id="mcpoint" name="mcpoint"/>
		</div>
	<%} %>
</body>
</html>
