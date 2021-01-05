<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util"%>
<%
	int wfid = Util.getIntValue(request.getParameter("wfid"));
	int formid = Util.getIntValue(request.getParameter("formid"), 0);
	int isbill = Util.getIntValue(request.getParameter("isbill"), -1);
	int layouttype = Util.getIntValue(request.getParameter("layouttype"), 0);
	String nodename = Util.null2String(request.getParameter("searchVal"));
	
	String backfields=" fn.nodeid,nb.nodename,fn.nodetype ";
	String sqlform=" workflow_flownode fn,workflow_nodebase nb ";
	String sqlwhere=" nb.id=fn.nodeid and fn.workflowid="+wfid+" and (nb.IsFreeNode is null or nb.IsFreeNode!='1') ";
	if(!nodename.equals("")) sqlwhere += " and nb.nodename like '%"+nodename+"%'";
	String sqlorder=" fn.nodetype, fn.nodeorder ";
	String 	tableString=""+
	   "<table instanceid=\"module\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_SHOWMODULE,user.getUID())+"\" >"+
	   "<sql backfields=\""+backfields+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlform=\""+Util.toHtmlForSplitPage(sqlform)+"\" sqlorderby=\""+sqlorder+"\"  sqlprimarykey=\"nodeid\" sqlsortway=\"asc\"  sqlisdistinct=\"false\" />"+
	   "<head>"		
			 + "<col width=\"130px\" text=\""+SystemEnv.getHtmlLabelName(15615, user.getLanguage())+"\" column=\"nodetype\" "
			 + " transmethod=\"weaver.workflow.exceldesign.HtmlLayoutOperate.transNodeInfo\" otherpara=\"column:nodename\" />"
			 + "<col width=\"*\" text=\""+SystemEnv.getHtmlLabelName(19853, user.getLanguage())+"\" column=\"nodeid\"  "
			 + " transmethod=\"weaver.workflow.exceldesign.HtmlLayoutOperate.transLayoutInfo\" otherpara=\""+wfid+"+"+layouttype+"+"+user.getLanguage()+"\" />"
			 + "<col width=\"510px\" text=\""+SystemEnv.getHtmlLabelName(104, user.getLanguage())+"\" column=\"nodeid\" "
			 + " transmethod=\"weaver.workflow.exceldesign.HtmlLayoutOperate.transOperBtn\" otherpara=\""+wfid+"+"+layouttype+"+"+user.getLanguage()+"\" />"+
	   "</head>"+
	   "</table>";
%>
<html>
	<head>
	<link type="text/css" rel="stylesheet" href="/workflow/exceldesign/css/showModule_wev8.css" />
	<script type="text/javascript">
	$(document).unbind("contextmenu").bind("contextmenu", function (e) {
		return false;
	});
	    
	function afterDoWhenLoaded(){		//分页控件加载完成回调方法
		$("table.ListStyle").find(".HeaderForXtalbe").remove();
		$("table.ListStyle").find("td").attr("title", "");
		var winheight = $(window).height();
		$(".layoutContent").css("height",(winheight-25-14)+"px");
		
		//编辑节点展开历史模板
		var editing_nodeid = window.parent.wfinfo.nodeid;
		jQuery("[name='nodeid'][isactive='1'][value='"+editing_nodeid+"']").closest("tr").find("div.nodeimg").trigger("click");
		
		controlOperArea();
	}
	
	//展开对应节点历史模板
	function extendHistoryLayout(vthis){
		var tablelist = jQuery(vthis).closest("table");
		var spacingObj = tablelist.find("tr.Spacing").first();
		var curTrObj = jQuery(vthis).closest("tr");
		var nodeid = curTrObj.find("[name='nodeid']").val();
		var extendRow = tablelist.find("tr[extendRow='y'][extendNodeid='"+nodeid+"']");
		if(extendRow.size() > 0){
			extendRow.remove();
			return;
		}
		jQuery.ajax({
			type: "post",
			url: "/workflow/exceldesign/excelAjaxData.jsp",
			data: {src:"getHistoryLayout", wfid:"<%=wfid %>", nodeid:nodeid, layouttype:"<%=layouttype %>", languageid:"<%=user.getLanguage() %>"},
			dataType: "JSON",
			success: function(result){
				var datas = JSON.parse(result);
				if(window.console)	console.dir(datas);
				for(var i=0; i<datas.length; i++){
					var extendTrObj = curTrObj.clone();
					extendTrObj.removeClass("Selected");
					extendTrObj.find("td").html("");
					extendTrObj.find("td:eq(2)").html(datas[i].layoutInfo);
					extendTrObj.find("td:eq(3)").html(datas[i].operArea);
					var extendSpacing = spacingObj.clone();
					extendSpacing.attr("class", spacingObj.attr("class")).attr("style", spacingObj.attr("style"));
					
					extendTrObj.add(extendSpacing).attr("extendRow", "y").attr("extendNodeid", nodeid);
					curTrObj.after(extendTrObj).after(extendSpacing);
				}
				setEditingMark();
				controlOperArea();
			}
		});
	}
	
	//编辑中模板加标示
	function setEditingMark(){
		if(jQuery(".layoutediting").size() > 0)
			return;
		var editing_layoutid = window.parent.wfinfo.modeid;
		var layoutinput = jQuery("[name='layoutid'][value='"+editing_layoutid+"']");
		var editing='<div class="layoutediting"><img src="/workflow/exceldesign/image/shortBtn/module/editing_wev8.png"/><span><%=SystemEnv.getHtmlLabelName(128079, user.getLanguage())%></span></div>';
		layoutinput.closest("td").find("div.layoutname").append(editing);
		layoutinput.closest("tr").find("div.oper_delete").attr("onclick", "")
			.find("div").removeClass("operbtn_delete").addClass("operbtn_deletedisabled");
	}
	
	//控制按钮区
	function controlOperArea(){
		jQuery("div.operarea[hasBind!='y']").each(function(){
			var vthis = jQuery(this);
			var version = parseInt(vthis.closest("tr").find("[name='version']").val());
			var layoutid = parseInt(vthis.closest("tr").find("[name='layoutid']").val());
			if(version != 2){
				vthis.find("div.oper_edit").attr("onclick", "")
					.find("div").removeClass("operbtn_edit").addClass("operbtn_editdisabled");
				vthis.find("div.oper_sync").attr("onclick", "")
					.find("div").removeClass("operbtn_sync").addClass("operbtn_syncdisabled");
			}
			if(layoutid <= 0){
				vthis.find("div.oper_delete").attr("onclick", "")
					.find("div").removeClass("operbtn_delete").addClass("operbtn_deletedisabled");
			}
			vthis.closest("tr").mouseover(function(){
				vthis.show();
			}).mouseout(function(){
				vthis.hide();
			});
			vthis.attr("hasBind", "y");
		});
	}
	
	//新建
	function createBtnClick(vthis){
		var nodeid=jQuery(vthis).closest("tr").find("[name='nodeid']").val();
		switchEditLayout(nodeid, "0");
	}
	
	//编辑模板
	function editBtnClick(vthis){
		var layoutid = parseInt(jQuery(vthis).closest("tr").find("[name='layoutid']").val());
		var version = parseInt(jQuery(vthis).closest("tr").find("[name='version']").val());
		if(layoutid<=0 || version!=2)
			return;
		var editing_layoutid = window.parent.wfinfo.modeid;
		if(layoutid == editing_layoutid){
			//只是切换tab页
			parent.changeTab4SameModeid();
		}else{
			var nodeid=jQuery(vthis).closest("tr").find("[name='nodeid']").val();
			switchEditLayout(nodeid, layoutid);
		}
	}
	
	//模板切换
	function switchEditLayout(nodeid, layoutid){
		if(parent.judgeDesignHasModify()){
			window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(128080, user.getLanguage())%>",function(){
				//重新加载
				parent.reloadExcelMain(nodeid, "<%=layouttype%>", layoutid);
			});
		}else{
			parent.reloadExcelMain(nodeid, "<%=layouttype%>", layoutid);
		}
	}
	
	//选择
	function chooseBtnClick(vthis){
		var nodeid = jQuery(vthis).closest("tr").find("input[name='nodeid']").val();
		var layoutid = jQuery(vthis).closest("tr").find("input[name='layoutid']").val();
		
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/workflow/exceldesign/chooseHtmlTemplateTab.jsp?wfid=<%=wfid %>&formid=<%=formid %>&isbill=<%=isbill %>&choosetype=<%=layouttype %>&curlayoutid="+layoutid+"&fromwhere=showModule";
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage()) %>";
		dialog.Width = 750;
		dialog.Height = 650;
		dialog.maxiumnable = false;
		dialog.URL = url;
		dialog.callback = function(datas){
			if(datas.id){
				jQuery.ajax({
					type: "post",
					url: "/workflow/exceldesign/excelAjaxData.jsp",
					data: {src:"saveChooseLayout", wfid:"<%=wfid %>", nodeid:nodeid, formid:"<%=formid %>", isbill:"<%=isbill %>", layouttype:"<%=layouttype %>", choose_layoutid:datas.id, operuser:"<%=user.getUID() %>", languageid:"<%=user.getLanguage() %>"},
					dataType: "JSON",
					success: function(result){
						if(result.trim() == "success"){
							dialog.close();
							window.location.reload();
						}
					}
				});
			}
		}
		dialog.show();
	}
	
	//删除
	function deleteBtnClick(vthis){
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(128081, user.getLanguage())%>",function(){
			var layoutid = jQuery(vthis).closest("tr").find("[name='layoutid']").val();
			jQuery.ajax({
				type: "post",
				url: "/workflow/exceldesign/excelAjaxData.jsp",
				data: {src:"deleteLayout", layoutid:layoutid},
				dataType: "JSON",
				success: function(result){
					if(result.trim() == "success");
						window.location.reload();
				}
			});
		});
	}
	
	//Excel导入
	function excelimpBtnClick(vthis){
		if("<%=isbill %>"!="1"){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129028, user.getLanguage())%>");
			return;
		}
		var nodeid = jQuery(vthis).closest("tr").find("[name='nodeid']").val();
		var url =  "/workflow/exceldesign/importExcelTemplate.jsp?wfid=<%=wfid%>&nodeid="+nodeid+"&formid=<%=formid%>&isbill=<%=isbill%>&layouttype=<%=layouttype%>";
		var dlg=new window.top.Dialog();
		dlg.currentWindow=window;
		dlg.Model=true;
		dlg.Width=550;
		dlg.Height=400;
		dlg.URL=url;
		dlg.Title="导入Excel模板";
		dlg.show();
	}
	
	//初始化模板
	function initBtnClick(vthis){
		var nodeid=jQuery(vthis).closest("tr").find("[name='nodeid']").val();
		var layoutid=jQuery(vthis).closest("tr").find("[name='layoutid']").val();
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/workflow/exceldesign/excelInitModule.jsp?wfid=<%=wfid%>&layouttype=<%=layouttype%>&nodeid="+nodeid+"&modeid="+layoutid;
		dialog.Title = '<%=SystemEnv.getHtmlLabelNames("68,128003",user.getLanguage()) %>';
		dialog.Width = 810;
		dialog.Height = 570;
		dialog.maxiumnable=true;
		dialog.hideDraghandle = true;	
		dialog.URL = url;
		dialog.show();
	}
	
	//同步节点
	function syncBtnClick(vthis){
		var version=jQuery(vthis).closest("tr").find("[name='version']").val();
		if(version != "2"){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(128082, user.getLanguage())%>");
			return;
		}
		var nodeid=jQuery(vthis).closest("tr").find("[name='nodeid']").val();
		var layoutid=jQuery(vthis).closest("tr").find("[name='layoutid']").val();
		var dlg=new window.top.Dialog();
		dlg.currentWindow=window;
		dlg.Model=true;
	　　 dlg.Width=450;
	　　 dlg.Height=550;
	    dlg.URL="/workflow/exceldesign/syncNodesBrowser.jsp?wfid=<%=wfid%>&layouttype=<%=layouttype%>&from_nodeid="+nodeid+"&from_modeid="+layoutid;  
		dlg.Title="<%=SystemEnv.getHtmlLabelName(129029, user.getLanguage())%>";
	　　 dlg.show();
	}
	
	//设为活动模板
	function setLayoutToActive(vthis){
		var nodeid = jQuery(vthis).closest("tr").find("[name='nodeid']").val();
		var layoutid = jQuery(vthis).closest("tr").find("[name='layoutid']").val();
		jQuery.ajax({
			type: "post",
			url: "/workflow/exceldesign/excelAjaxData.jsp",
			data: {src:"setLayoutToActive", wfid:"<%=wfid %>", nodeid:nodeid, layouttype:"<%=layouttype %>", layoutid:layoutid},
			dataType: "JSON",
			success: function(result){
				if(result.trim() == "success");
					window.location.reload();
			}
		}); 
	}
	
	//初始化模板 dialog[excelInitModule.jsp] 中的回调方法
	function setInitModule(styleid, nodeid, layoutid){
		var isInit = 1;	//如果 isInit = 1，那么 模板将被覆盖
		parent.reloadExcelMain(nodeid, "<%=layouttype%>", layoutid);
	}
	
	function searchTable(){
		weaverform.submit();
	}	
	
</script>
	</head>
	<body>
		<form id="weaverform" name="weaverform" style="height:100%;" method="post" action="/workflow/exceldesign/showModule.jsp">
		<input type="hidden" name="wfid" value="<%=wfid %>" />
		<input type="hidden" name="formid" value="<%=formid %>" />
		<input type="hidden" name="isbill" value="<%=isbill %>" />
		<input type="hidden" name="layouttype" value="<%=layouttype %>" />
		<div class="topsearch"><%=SystemEnv.getHtmlLabelName(15070, user.getLanguage())%>：
			<span class="searchInputSpan" style="background: #fff; margin-top: 2px;"> 
				<input type="text" class="searchInput" name="searchVal" value="<%=nodename %>"
						onkeypress="if(event.keyCode==13) {searchTable();}" />
				</input> 
				<span>
					<img src="/images/ecology8/request/search-input_wev8.png" onclick="searchTable()"></img>
				</span>
			</span>
		</div>
		<div class="layoutContent">
			<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.WF_WORKFLOW_SHOWMODULE%>" />
			<wea:SplitPageTag isShowTopInfo="false" tableString="<%=tableString%>" mode="run" />
		</div>
		</form>
	</body>
</html>