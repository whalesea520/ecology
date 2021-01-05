<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
</head>
<%
if(!HrmUserVarify.checkUserRight("intergration:formactionsetting",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(32338 ,user.getLanguage());//"流程流转集成"
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
String fromtype = Util.null2String(request.getParameter("fromtype"));
String namesimple = Util.null2String(request.getParameter("namesimple"));
String actionname = Util.null2String(request.getParameter("actionname"));
String sworkFlowId = Util.null2String(request.getParameter("sworkFlowId"));
String interfacename = Util.null2String(request.getParameter("interfacename"));
String workflowname = "";

String sqlwhere = "where a.workflowid=b.id ";
String innersqlwhere = " where 1=1 ";
if(!"".equals(fromtype))
	innersqlwhere += " where d.fromtype="+fromtype;
if(!"".equals(namesimple))
	sqlwhere += " and workflowname like '%"+namesimple+"%'";
if(!"".equals(actionname))
	innersqlwhere += " and d.actionname like '%"+actionname+"%'";
String tableString="";
if(!"".equals(sworkFlowId))
{
	workflowname = WorkflowComInfo.getWorkflowname(sworkFlowId);
	sqlwhere +=" and b.id="+sworkFlowId;
}
if(!"".equals(interfacename))
{
	if(rs1.getDBType().equals("oracle"))
	{
		sqlwhere +=" and exists (select 1 from (select k.id, k.dmlactionname as actionname from formactionset k "+
				   "	union all select s.id, s.actionname from wsformactionset s) r, "+
				   "	workflowactionset d where (r.actionname like '%"+interfacename+"%' or d.interfaceid like '%"+interfacename+"%') and "+ 
				   "	d.interfaceid=to_char(r.id) and a.workflowid=d.workflowid) ";
	}
	else
	{
		sqlwhere +=" and exists (select 1 from (select k.id, k.dmlactionname as actionname from formactionset k "+
				   "	union all select s.id, s.actionname from wsformactionset s) r, "+
				   "	workflowactionset d where (r.actionname like '%"+interfacename+"%' or d.interfaceid like '%"+interfacename+"%') and "+ 
				   "	d.interfaceid=cast(r.id as varchar(2000)) and a.workflowid=d.workflowid) ";
	}
}
String backfields=" a.*,b.workflowname,b.formid,b.isbill " ;
String perpage="10";
String sqlorderby = "";

String fromSql=" (select distinct d.workflowId"+
				 " from workflowactionset d "+innersqlwhere+") a,workflow_base b"; 
//System.out.println("select "+backfields+" from "+fromSql+" "+sqlwhere);
String PageConstId = "DMLNewList_gxh";
tableString =  " <table instanceid=\"ListTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageConstId,user.getUID())+"\" >";
tableString += " <checkboxpopedom  popedompara=\"column:a.workflowId\" showmethod=\"weaver.general.SplitPageTransmethod.getCheckBox\" />"+
		 " <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\""+sqlorderby+"\"  sqlprimarykey=\"a.workflowId\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
         "       <head>"+
         "           <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(18104 ,user.getLanguage())+"\" column=\"workflowname\" orderkey=\"workflowname\" transmethod=\"weaver.general.SplitPageTransmethod.getDMLLink1\" otherpara=\"column:workflowId\" target=\"_self\" />"+
         "           <col width=\"70%\"  text=\""+SystemEnv.getHtmlLabelName(83000 ,user.getLanguage())+"\" column=\"workflowId\" transmethod=\"weaver.general.SplitPageTransmethod.getDMLLink2\" otherpara=\""+user.getLanguage()+"+column:formid+column:isbill\" />"+
		 //"           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(19346 ,user.getLanguage())+"/"+SystemEnv.getHtmlLabelName(15587 ,user.getLanguage())+"\" column=\"workFlowId\" transmethod=\"weaver.general.SplitPageTransmethod.getDMlMethod\" otherpara=\"column:nodeid+column:nodelinkid\" />"+
		// "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(104 ,user.getLanguage())+"\" column=\"id\" transmethod=\"weaver.general.SplitPageTransmethod.getDMLDelete\"  otherpara=\"column:fromtype\" />"+
		 "       </head>"+
		 "<operates width=\"20%\">"+
		 " <popedom transmethod=\"weaver.general.SplitPageTransmethod.getOpratePopedom2\" otherpara=\"2\"></popedom> "+
		 "     <operate href=\"javascript:editById1()\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_fullwindow\" index=\"0\"/>"+
		 "     <operate href=\"javascript:doDeleteById1()\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_fullwindow\" index=\"1\"/>"+      
		 "</operates>"+
         " </table>";
//RCMenu += "{"+SystemEnv.getHtmlLabelName(197 ,user.getLanguage())+",javascript:doRefresh(),_self} " ;  QC277382 去除搜索菜单
RCMenuHeight += RCMenuHeightStep ;
if(HrmUserVarify.checkUserRight("intergration:formactionsetting", user))
{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:add(1),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:del(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
}

%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="/integration/dmllist.jsp" method="post" name="frmmain" id="datalist">
<input id="workflowid" name="workflowid" value="" type="hidden" />
<input type="hidden" id="operate" name="operate" value="">
<input type="hidden" id="workflowids" name="workflowids" value="">
<input type="hidden" id="fromintegration" name="fromintegration" value="1">

<div class="advancedSearchDiv" id="advancedSearchDiv">
	<wea:layout type="4col">
		<wea:group context='<%= SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(18104 ,user.getLanguage()) %></wea:item>
		    <wea:item>
				<input  type="text" name="namesimple" value="<%=namesimple%>">
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(83001 ,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		    <wea:item>
				<input  type="text" name="actionname" value="<%=actionname%>">
			</wea:item>
		</wea:group>
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<!--QC:270808   [80][90]流程流转集成-调整高级搜索中按钮样式，以保持统一 e8_btn_submit-->
				<input type="submit" value="<%=SystemEnv.getHtmlLabelName(197 ,user.getLanguage()) %>" class="e8_btn_submit"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022 ,user.getLanguage()) %>" class="e8_btn_cancel" onclick="resetCondtion();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201 ,user.getLanguage()) %>" class="zd_btn_cancle" id="cancel"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:630px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82 ,user.getLanguage()) %>" class="e8_btn_top" onclick="add(1)"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" class="e8_btn_top" onclick="del()"/>
			<input type="text" class="searchInput" name="namesimple" value="<%=namesimple%>"/>
			&nbsp;&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;">&nbsp;</span> 
</div>

<div class="cornerMenuDiv"></div>
<TABLE width="100%">
    <tr>
        <td valign="top">  
        	<input type="hidden" name="pageId" id="pageId" value="<%=PageConstId %>"/>
           	<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
        </td>
    </tr>
</TABLE>
</form>

<!--QC 286651  [80][90]流程流转集成-流程接口部署新建/编辑窗口中流程接口部署窗口建议加【关闭】按钮 Start-->
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
				<input type="button" accessKey=T  id=btncancel value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"
					   id="zd_btn_cancle"  class="zd_btn_cancle" onclick="closeDialog1();">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">

        var dialogTest = null;
        try{
            dialogTest = parent.parent.getDialog(parent);
        }catch(e){}

        jQuery(document).ready(function(){
            if(!dialogTest){
                $("#zDialog_div_bottom").css("display","none");
            }
            resizeDialog(document);
        });

        function closeDialog1(){
            if(dialogTest){
                dialogTest.close();
            }
        }
	</script>
</div>
<!--QC 286651  [80][90]流程流转集成-流程接口部署新建/编辑窗口中流程接口部署窗口建议加【关闭】按钮 End-->
</BODY>
</HTML>
<script type="text/javascript">
var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}
function openDialog(url,title,width,height){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = url;
	dialog.Title = title;
	dialog.Width = width||750;
	dialog.Height = height||596;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.maxiumnable=true;//允许最大化
	dialog.show();
}
function add(type)
{
	var url = "/integration/integrationTab.jsp?urlType=25&isdialog=1&fromintegration=1&operate=addws&webservicefrom=1";
	var title = "<%=SystemEnv.getHtmlLabelNames("83981,83319",user.getLanguage())%>";
	openDialog(url,title);
	//document.location = "/workflow/action/WorkflowActionEditSet.jsp?fromintegration=1&operate=addws&webservicefrom=1";
}
function doDeleteById1(id)
{
//	if(id=="") return ;
//	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
//		var url = "/workflow/action/WorkflowActionEditOperation.jsp?fromintegration=1&workflowid="+id+"&operate=delete";
//		document.location = url;
//	}, function () {}, 320, 90);	
// QC291290  [80][90]流程流转集成-流程接口部署，点击行操作菜单【删除】按钮点击后，页面显示空白问题   --start
	if(id=="")
	{
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage()) %>");
		return ;
	}
	else
	{
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
			var url = "/workflow/action/WorkflowActionEditOperation.jsp?fromintegration=1&workflowids="+id+"&operate=delete";
			document.location = url;
		}, function () {}, 320, 90);
	}
	// QC291290  [80][90]流程流转集成-流程接口部署，点击行操作菜单【删除】按钮点击后，页面显示空白问题   --end
}
function editById1(id)
{
	if(id=="") return ;
	var url = "/integration/integrationTab.jsp?urlType=26&isdialog=1&fromintegration=1&workflowid="+id;
	var title = "<%=SystemEnv.getHtmlLabelNames("26473,83319",user.getLanguage())%>";
	openDialog(url,title);
	//var url = "/workflow/action/WorkflowActionEditSet.jsp?fromintegration=1&workflowid="+id;
	//document.location = url;
}
function editbyParam(urlType,paramStr,title){
	var url = "/integration/integrationTab.jsp?urlType="+urlType+"&isdialog=1";
	url = url + "&" + paramStr;
	
	openDialog(url,title);
}
function resetCondtion()
{
	$('input[name=namesimple]').each(function(){
		this.value='';
	});
	frmmain.actionname.value = "";
}
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:doRefresh});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#advancedSearch").bind("click", function(){
	  $(".searchInput").val('');
	});
});
function del()
{
	var ids = "";
	if(!ids){
		ids = _xtable_CheckedCheckboxId();
	}
	if(ids.match(/,$/)){
		ids = ids.substring(0,ids.length-1);
	}
	//alert("ids : "+ids);
	if(ids=="")
	{
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage()) %>");
		return ;
	}
	else
	{
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
			var url = "/workflow/action/WorkflowActionEditOperation.jsp?fromintegration=1&workflowids="+ids+"&operate=delete";
			//alert(url);
			document.location = url;
		}, function () {}, 320, 90);
	}		
}
function doRefresh()
{
	document.frmmain.action = "/integration/dmllist.jsp";
	$("#datalist").submit(); 
}
</script>
