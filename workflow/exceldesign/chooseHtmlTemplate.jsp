<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
	String wfid = Util.null2String(request.getParameter("wfid"));
	String formid = Util.null2String(request.getParameter("formid"));
	String isbill = Util.null2String(request.getParameter("isbill"));
	String layouttype = Util.null2String(request.getParameter("layouttype"));
	String curlayoutid = Util.null2String(request.getParameter("curlayoutid"));
	String fromwhere = Util.null2String(request.getParameter("fromwhere"));

	String search_wfid = Util.null2String(request.getParameter("search_wfid"));
	String search_layoutname = Util.null2String(request.getParameter("search_layoutname"));
	int search_active = Util.getIntValue(request.getParameter("search_active"));
	
	String sqlwhere = xssUtil.put(" and formid="+formid+" and isbill="+isbill+" ");
	String completeUrl = "/data.jsp?type=workflowBrowser&from=htmllayoutchoose&sqlwhere="+xssUtil.put(" formid="+formid+" and isbill="+isbill+" ");
%>
<html>
<head>
</head>
<body style="overflow:hidden">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:doClear(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:doClose(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>" onclick="doSearch();" class="e8_btn_top">
	      	<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form name="weaverform" method="post" action="chooseHtmlTemplate.jsp">
<wea:layout type="4col">
	<wea:group context="<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage()) %>">
		<wea:item><%=SystemEnv.getHtmlLabelName(81651,user.getLanguage()) %></wea:item>
		<wea:item attributes="{'colspan':'3'}">
			<brow:browser viewType="0" name="search_wfid" 
				browserValue="<%=search_wfid %>" getBrowserUrlFn="getWfBrowUrl" 
				hasInput="true" isSingle="true" hasBrowser="true" isMustInput="1"
				completeUrl="<%=completeUrl %>"
				browserSpanValue="<%=WorkflowComInfo.getWorkflowname(search_wfid)%>">
			</brow:browser>
	    </wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage()) %></wea:item>
		<wea:item>
			<input type="text" class="InputStyle" name="search_layoutname" value="<%=search_layoutname %>" />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("64,23247",user.getLanguage()) %></wea:item>
		<wea:item>
			<select name="search_active">
				<option value="-1" <%=search_active==-1?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %></option>
				<option value="1" <%=search_active==1?"selected":"" %>><%=SystemEnv.getHtmlLabelName(678,user.getLanguage()) %></option>
				<option value="0" <%=search_active==0?"selected":"" %>><%=SystemEnv.getHtmlLabelName(1477,user.getLanguage()) %></option>
			</select>
		</wea:item>
	</wea:group>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true'}">
		<%
			String backfields = " a.id,a.workflowid,a.layoutname,a.isactive,nb.nodename ";
			String fromSql = " workflow_nodehtmllayout a,workflow_flownode fl,workflow_nodebase nb ";
			String whereSql = " (nb.IsFreeNode is null or nb.IsFreeNode!='1') AND a.nodeid=nb.id AND fl.nodeid=nb.id "
					+" AND a.formid="+formid+" AND a.isbill="+isbill+" AND a.type="+layouttype+" AND a.id<>'"+curlayoutid+"' ";

			if(!"".equals(search_wfid))
				whereSql += " AND a.workflowid="+search_wfid+" ";
			if(search_active != -1)
				whereSql += " AND a.isactive="+search_active+" ";
			if(!"".equals(search_layoutname))
				whereSql += " AND a.layoutname like '%"+search_layoutname+"%' ";
			
			//System.err.println(whereSql);
			String orderSql = " a.workflowid asc,fl.nodeorder asc,a.isactive desc";
			String tableString = " <table instanceid=\"htmlLayoutListTable\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_CHOOSELAYOUT,user.getUID())+"\" >"+
			"       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(whereSql)+"\" sqlorderby=\""+orderSql+"\" sqlprimarykey=\"a.id\" sqlsortway=\"desc\" sqlisdistinct=\"false\" />"+
		    "       <head>"+
		    "		<col width=\"8%\" text=\""+SystemEnv.getHtmlLabelName(33144,user.getLanguage())+"ID\" column=\"id\" />"+
		    "		<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelName(18151,user.getLanguage())+"\" column=\"layoutname\" otherpara=\"column:isactive+"+user.getLanguage()+"\" transmethod=\"weaver.workflow.exceldesign.HtmlLayoutOperate.reflectLayoutName\" />"+
		    "		<col width=\"22%\" text=\""+SystemEnv.getHtmlLabelName(15070,user.getLanguage())+"\" column=\"nodename\" />"+
		    "		<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(81651,user.getLanguage())+"\" column=\"workflowid\" transmethod=\"weaver.workflow.exceldesign.HtmlLayoutOperate.reflectWorkflowname\" />"+
		    "       </head>"+                 
		    " </table>";
		%>
			<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
			<input type="hidden" name="pageId" id="pageId" _showCol="false" value="<%=PageIdConst.WF_CHOOSELAYOUT %>"/>
		</wea:item>
	</wea:group>
</wea:layout>
<input type="hidden" name="wfid" value="<%=wfid %>" />
<input type="hidden" name="formid" value="<%=formid %>" />
<input type="hidden" name="isbill" value="<%=isbill %>" />
<input type="hidden" name="layouttype" value="<%=layouttype %>" />
<input type="hidden" name="curlayoutid" value="<%=curlayoutid %>" />
<input type="hidden" name="fromwhere" value="<%=fromwhere %>" />
</form>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" class="zd_btn_cancle" onclick="doClear();" />
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="zd_btn_cancle" onclick="doClose();" />
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</body>
<script type="text/javascript">
var dialog;
jQuery(document).ready(function(){
	dialog = window.parent.parent.getDialog(window.parent);
});

function afterDoWhenLoaded(){
	var tablelist = jQuery("div#_xTable").find("table.ListStyle");
	tablelist.find("tr").each(function(){
		if(jQuery(this).is(".Spacing"))
			return true;
		jQuery(this).click(function(){
			if(dialog){
				var id = jQuery(this).find("td:eq(1)").html();
				var name = jQuery(this).find("td:eq(2)").html();
				var retJson = {"id":id, "name":name.substring(0,name.length-4)};
				if("<%=fromwhere %>" == "showModule"){
					window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(127974,user.getLanguage())%>", function(){ //确认使用选择的模板覆盖节点活动模板吗？
						window.parent.__setloaddingeffect();
						dialog.callback(retJson);
					});
				}else{
					dialog.callback(retJson);
				}
			}
		});
	});
	//页面滚动条控制
	window.setTimeout(function(){
		tablelist.parent().css("max-height","400px");
	},100);
}

function doClear(){
	if(dialog){
		var retJson = {"id":"-1", "name":""};
		if("<%=fromwhere %>" == "showModule" ){
			if("<%=curlayoutid %>" == "0"){
				dialog.close();
			}else{
				window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(127976,user.getLanguage())%>", function(){//确认清除节点活动模板吗？
					window.parent.__setloaddingeffect();
					dialog.callback(retJson);
				});
			}
		}else{
			dialog.callback(retJson);
		}
	}
}

function doSearch(){
	weaverform.submit();
}

function doClose(){
	if(dialog)
		dialog.close();
}

function getWfBrowUrl(){
	return "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowTypeBrowser.jsp?from=htmllayoutchoose&sqlwhere=<%=sqlwhere %>";
}
</script>
</html>