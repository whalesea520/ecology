<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.formmode.exceldesign.HtmlLayoutOperate"%>
<%
	HtmlLayoutOperate htmlLayoutOperate = new HtmlLayoutOperate();
	RecordSet rs = new RecordSet();
	
	int modeid = Util.getIntValue(request.getParameter("modeid"));
	int formid = Util.getIntValue(request.getParameter("formid"), 0);
	int layouttype = Util.getIntValue(request.getParameter("layouttype"), 0);
	int isdefault = Util.getIntValue(request.getParameter("isdefault"), 0);
	String layoutname = Util.null2String(request.getParameter("searchVal"));
	
	String sql = "select id from modehtmllayout where modeid = "+modeid+" and type = "+layouttype+" and version = 2";
	
	rs.executeSql(sql);
	int mhlnum = rs.getCounts();
	
	String backfields=" id,layoutname,type,isdefault";
	String sqlform=" (select id,layoutname,type,modeid,version";
	if("sqlserver".equals(rs.getDBType())){
		sqlform += ",isnull(isdefault,0) isdefault ";
	}else{
		sqlform += ",nvl(isdefault,0) isdefault ";
	}
	sqlform += " from modehtmllayout) mhl ";
	String sqlwhere=" modeid="+modeid+" and type="+layouttype + " and version = 2";
	if(!layoutname.equals("")) sqlwhere += " and lower(layoutname) like '%"+layoutname.toLowerCase()+"%'";
	String sqlorder=" isdefault desc,id desc ";
	String 	tableString=""+
	   "<table instanceid=\"module\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_SHOWMODULE,user.getUID())+"\" >"+ 
	   "<sql backfields=\""+backfields+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlform=\""+Util.toHtmlForSplitPage(sqlform)+"\" sqlorderby=\""+sqlorder+"\"  sqlprimarykey=\"id\" sqlsortway=\"desc\"  sqlisdistinct=\"false\" />"+
	   "<head>"
			 + "<col width=\"130px\" text=\"布局信息\" column=\"type\" "
			 + " transmethod=\"weaver.formmode.exceldesign.HtmlLayoutOperate.transLayoutImgInfo\" otherpara=\"column:layoutname\" />"
			 + "<col width=\"*\" text=\"模板信息\" column=\"id\"  "
			 + " transmethod=\"weaver.formmode.exceldesign.HtmlLayoutOperate.transLayoutInfo\" otherpara=\""+layouttype+"+"+user.getLanguage()+"\" />"
			 + "<col width=\"510px\" text=\"操作\" column=\"id\" "
			 + " transmethod=\"weaver.formmode.exceldesign.HtmlLayoutOperate.transOperBtn\" />"+
	   "</head>"+
	   "</table>";
%>
<html>
	<head>
	<link type="text/css" rel="stylesheet" href="/formmode/exceldesign/css/showModule_wev8.css?<%=System.currentTimeMillis() %>" />
	<script type="text/javascript">
	var sourceLayouttype = <%=layouttype%>;
	$(document).unbind("contextmenu").bind("contextmenu", function (e) {
		return false;
	});
	
	$(document).ready(function(){
		<%
			if(mhlnum==0){
			%>
				controlOperArea()
			<%
			}
		%>
	})
	    
	function afterDoWhenLoaded(){		//分页控件加载完成回调方法
		$("table.ListStyle").find(".HeaderForXtalbe").remove();
		$("table.ListStyle").find("td").attr("title", "");
		var winheight = $(window).height();
		$(".layoutContent").css("height",(winheight-25-14)+"px");
		
		//编辑节点展开历史模板
		var editing_layoutid = window.parent.wfinfo.layoutid;
		jQuery("[name='layoutid'][value='"+editing_layoutid+"']").closest("tr").find("div.nodeimg").trigger("click");
		
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
		setEditingMark();
		controlOperArea();
	}
	
	//编辑中模板加标示
	function setEditingMark(){
		if(jQuery(".layoutediting").size() > 0)
			return;
		var editing_layoutid = window.parent.wfinfo.layoutid;
		var layoutinput = jQuery("[name='layoutid'][value='"+editing_layoutid+"']");
		var editing='<div class="layoutediting"><img src="/formmode/exceldesign/image/shortBtn/module/editing_wev8.png"/><span>编辑中...</span></div>';
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
			var isdefault = parseInt(vthis.closest("tr").find("[name='isdefault']").val());
			if(version != 2){
				vthis.find("div.oper_edit").attr("onclick", "")
					.find("div").removeClass("operbtn_edit").addClass("operbtn_editdisabled");
				vthis.find("div.oper_sync").attr("onclick", "")
					.find("div").removeClass("operbtn_sync").addClass("operbtn_syncdisabled");
			}
			if(sourceLayouttype == 3 || sourceLayouttype ==4){
				vthis.find("div.oper_sync").attr("onclick", "")
					.find("div").removeClass("operbtn_sync").addClass("operbtn_syncdisabled");
			}
			if(layoutid <= 0 || isdefault == 1){
				vthis.find("div.oper_delete").attr("onclick", "")
					.find("div").removeClass("operbtn_delete").addClass("operbtn_deletedisabled");
				vthis.find("div.operbtn_setactive").attr("onclick", "").removeClass("operbtn_setactive");
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
		switchEditLayout("0");
	}
	
	//编辑模板
	function editBtnClick(vthis){
		var layoutid = parseInt(jQuery(vthis).closest("tr").find("[name='layoutid']").val());
		var version = parseInt(jQuery(vthis).closest("tr").find("[name='version']").val());
		if(layoutid<=0 || version!=2)
			return;
		var editing_layoutid = window.parent.wfinfo.layoutid;
		if(layoutid == editing_layoutid){
			//只是切换tab页
			parent.changeTab4SameModeid();
		}else{
			switchEditLayout(layoutid);
		}
	}
	
	//模板切换
	function switchEditLayout(layoutid){
		if(parent.judgeDesignHasModify()){
			window.top.Dialog.confirm("模板内容尚未保存，确定离开吗？",function(){
				//重新加载
				parent.reloadExcelMain("<%=layouttype%>", layoutid);
			});
		}else{
			parent.reloadExcelMain("<%=layouttype%>", layoutid);
		}
	}
	
	//选择
	function chooseBtnClick(vthis){
		var layoutid = jQuery(vthis).closest("tr").find("input[name='layoutid']").val();
		
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/formmode/exceldesign/chooseHtmlTemplateTab.jsp?modeid=<%=modeid %>&formid=<%=formid %>&choosetype=<%=layouttype %>&curlayoutid="+layoutid+"&fromwhere=showModule";
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage()) %>";
		dialog.Width = 750;
		dialog.Height = 650;
		dialog.maxiumnable = false;
		dialog.URL = url;
		dialog.callback = function(datas){
			if(datas.id){
				jQuery.ajax({
					type: "post",
					url: "/formmode/exceldesign/excelAjaxData.jsp",
					data: {src:"saveChooseLayout", modeid:"<%=modeid %>", formid:"<%=formid %>", layoutid:layoutid, layouttype:"<%=layouttype %>", choose_layoutid:datas.id, operuser:"<%=user.getUID() %>", languageid:"<%=user.getLanguage() %>"},
					dataType: "JSON",
					success: function(result){
						if(result.trim() == "success"){
							dialog.close();
							switchEditLayout(layoutid);
						}
					}
				});
			}
		}
		dialog.show();
	}
	
	//删除
	function deleteBtnClick(vthis){
		window.top.Dialog.confirm("确认删除该模板吗？",function(){
			var layoutid = jQuery(vthis).closest("tr").find("[name='layoutid']").val();
			jQuery.ajax({
				type: "post",
				url: "/formmode/exceldesign/excelAjaxData.jsp",
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
		var layoutid = jQuery(vthis).closest("tr").find("input[name='layoutid']").val();
		var url =  "/formmode/exceldesign/importExcelTemplate.jsp?modeid=<%=modeid%>&formid=<%=formid%>&layouttype=<%=layouttype%>&layoutid="+layoutid+"&isdefault=<%=isdefault%>";
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
		var layoutid=jQuery(vthis).closest("tr").find("[name='layoutid']").val();
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/formmode/exceldesign/excelInitModule.jsp?modeid=<%=modeid%>&formid=<%=formid%>&layouttype=<%=layouttype%>&layoutid="+layoutid+"&isdefault=<%=isdefault%>";
		dialog.Title = "设置单元格格式";
		dialog.Width = 810;
		dialog.Height = 570;
		dialog.maxiumnable=true;
		dialog.hideDraghandle = true;
		dialog.URL = url;
		dialog.show();
	}
	
	//同步布局
	function syncBtnClick(vthis){
		var version=jQuery(vthis).closest("tr").find("[name='version']").val();
		if(version != "2"){
			window.top.Dialog.alert("此模板为老Html模板，无法同步到其它节点");
			return;
		}
		var layoutid=jQuery(vthis).closest("tr").find("[name='layoutid']").val();
		var dlg=new window.top.Dialog();
		dlg.currentWindow=window;
		dlg.Model=true;
	　　	dlg.Width=450;
	　　 	dlg.Height=550;
	    dlg.URL="/formmode/exceldesign/syncLayoutsBrowser.jsp?modeid=<%=modeid%>&layouttype=<%=layouttype%>&from_layoutid="+layoutid+"&isdefault=<%=isdefault%>";
		dlg.Title="同步到其它类型布局";
	　　	dlg.show();
	}
	
	//设为活动模板
	function setLayoutToActive(vthis){
		var layoutid = jQuery(vthis).closest("tr").find("[name='layoutid']").val();
		jQuery.ajax({
			type: "post",
			url: "/formmode/exceldesign/excelAjaxData.jsp",
			data: {src:"setLayoutToActive", modeid:"<%=modeid %>", layouttype:"<%=layouttype %>", layoutid:layoutid},
			dataType: "JSON",
			success: function(result){
				if(result.trim() == "success"){
					window.top.Dialog.confirm("是否编辑该模板？",function(){
						//重新加载
						parent.reloadExcelMain("<%=layouttype%>", layoutid);
					},function(){
						window.location.reload();
					});
				}
			}
		});
	}
	
	//初始化模板 dialog[excelInitModule.jsp] 中的回调方法
	function setInitModule(styleid, layoutid){
		var isInit = 1;	//如果 isInit = 1，那么 模板将被覆盖
		parent.reloadExcelMain("<%=layouttype%>", layoutid);
	}
	
	function searchTable(){
		weaverform.submit();
	}	
	
</script>
	</head>
	<body>
		<form id="weaverform" name="weaverform" style="height:100%;" method="post" action="/formmode/exceldesign/showModule.jsp">
		<input type="hidden" name="modeid" value="<%=modeid %>" />
		<input type="hidden" name="formid" value="<%=formid %>" />
		<input type="hidden" name="layouttype" value="<%=layouttype %>" />
		<div class="topsearch">布局名称：
			<span class="searchInputSpan" style="background: #fff; margin-top: 2px;"> 
				<input type="text" class="searchInput" name="searchVal" value="<%=layoutname %>"
						onkeypress="if(event.keyCode==13) {searchTable();}" />
				</input> 
				<span>
					<img src="/images/ecology8/request/search-input_wev8.png" onclick="searchTable()"></img>
				</span>
			</span>
		</div>
		<div class="layoutContent">
		<%
			if(mhlnum==0){
			%>
			<table style="table-layout: fixed;" class="ListStyle" cellspacing="0">
				<colgroup>
					<col style="width: 130px;" width="1%" _itemid="1" _systemid="80269" />
					<col />
					<col style="width: 510px;" width="1%" _itemid="3" _systemid="80271" />
				</colgroup>
				<tr style="vertical-align: middle;">
					<td style="height: 30px; vertical-align: middle; word-break: break-all; word-wrap: break-word;"
						title="" align="left">
						<%=htmlLayoutOperate.transLayoutImgInfo(layouttype+"","")%>
					</td>
					<td
						style="height: 30px; vertical-align: middle; word-break: break-all; word-wrap: break-word;"
						title="" align="left">
						<%=htmlLayoutOperate.transLayoutInfo(0+"",layouttype+"+"+user.getLanguage())%>
					</td>
					<td
						style="height: 30px; vertical-align: middle; word-break: break-all; word-wrap: break-word;"
						title="" align="left">
						<%=htmlLayoutOperate.transOperBtn(0+"")%>
					</td>
				</tr>
				<tr style="height: 1px !important;" class="Spacing">
					<td class="paddingLeft0Table" title="" colspan="3">
						<div class="intervalDivClass"></div>
					</td>
				</tr>
				</tbody>
			</table>
			<%
			}else{
			%>
				<wea:SplitPageTag isShowTopInfo="false" tableString="<%=tableString%>" mode="run" />
			<%
			}
		%>
		</div>
		</form>
	</body>
</html>