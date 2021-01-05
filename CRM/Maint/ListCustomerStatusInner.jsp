
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$("#topTitle").topMenuTitle({searchFn:searchTitle});
});
//搜索采用固定列的查找方式，列不能变化，如变化，需要修改此搜索高亮逻辑
//add by Dracula @2014-1-28
function searchTitle()
{
	var value=$("input[name='customerStatus']",parent.document).val();
	if(value.length > 0)
	{
		//还原第二列的值
		$(".ListStyle").find("tbody tr").children("td:nth-child(2)").each(function(){
			$(this).children("a").html($(this).attr("title"));
		});
		//还原第三列的值
		$(".ListStyle").find("tbody tr").children("td:nth-child(3)").each(function(){
			$(this).html($(this).attr("title"));
		});
		//搜索第二列的值
		$(".ListStyle").find("tbody tr").children("td:nth-child(2)").each(function(){
			$(this).children("a").html(eachColor($(this).children("a"),value));
		});
		//搜索第三列的值
		$(".ListStyle").find("tbody tr").children("td:nth-child(3)").each(function(){
			$(this).html(eachColor($(this),value));
		});
	}
}

function eachColor(p,t){
    var nt = '<label class="textHighLight">'+t+'</label>';
    var reg = RegExp(t,"g");
    return  p.text().replace(reg,nt);
}
var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

//新建、编辑客户状况 add by Dracula @2014-1-28
function openDialog(id,isshowname){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/CRM/Maint/AddCustomerStatus.jsp";
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(82 ,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(602 ,user.getLanguage()) %>";
	if(!!id){//编辑
		url = "/CRM/Maint/EditCustomerStatus.jsp?id="+id;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(93 ,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(602 ,user.getLanguage()) %>";
		if(!!isshowname)
		{
			url = "/CRM/Maint/EditCustomerStatus.jsp?id="+id+"&ishowname="+isshowname;
		}
	}
	dialog.Width = 420;
	dialog.Height = 240;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

//打开单条记录的日志
function openLogDialog(id)
{
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/systeminfo/SysMaintenanceLog.jsp?operateitem="+109;
	if(id!=0)
		url+="&relatedid="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(31709,user.getLanguage()) %>";
	dialog.Width = 600;
	dialog.Height =550;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}

//编辑 add by Dracula @2014-1-28
function doEdit(id)
{
	openDialog(id);
}
//显示编辑名
function doShowName(id)
{
	openDialog(id,"2");
}
//删除 add by Dracula @2014-1-28
function doDel(id,fullname)
{
	if(isdel())
		location.href="/CRM/Maint/CustomerStatusOperation.jsp?method=delete&id="+id+"&name="+fullname;
}

//日志 add by Dracula @2014-1-28
function doLog(id)
{
	openLogDialog(id)
}
    
    //批量删除
    function delMutli()
    {
    	var id = _xtable_CheckedCheckboxId();
    	if(!id){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
			return;
		}
		if(id.match(/,$/)){
			id = id.substring(0,id.length-1);
		}
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
			var idArr = id.split(",");
			for(var i=0;i<idArr.length;i++){
				jQuery.ajax({
					url:"/CRM/Maint/CustomerStatusOperation.jsp?method=delete&id="+idArr[i],
					type:"post",
					async:true,
					complete:function(xhr,status){
						if(i==idArr.length-1){
							_table.reLoad();
						}
					}
				});
			}
		});
		
    }
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(602,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("CustomerStatus:Log", user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:openLogDialog(0),_self} " ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<%
	//原始页面未采用分页控件，现在改成分页控件 add by Dracula @2014-1-23
	String otherpara = "column:id+column:description";
	String tableString = "";
	String backfields = " t1.id, t1.fullname, t1.description, t1.orderkey,t1.usname,t1.cnname,t1.twname ";
	String fromSql = " from crm_customerstatus t1 ";
	String orderkey = " t1.orderkey ";
	String sqlWhere = " 1=1 ";
	String popedomUserpara = String.valueOf(user.getUID());
	String operateString = "";
	operateString = " <operates>";
	operateString +=" <popedom transmethod=\"weaver.crm.Maint.CRMTransMethod.getCRMCustomerStatusListOperation\"  otherpara=\""+popedomUserpara+"\" ></popedom> ";
	operateString +="     <operate href=\"javascript:doEdit();\" text=\"" + SystemEnv.getHtmlLabelName(93, user.getLanguage()) + "\"  index=\"0\"/>";
	operateString +="     <operate href=\"javascript:doShowName();\" text=\"" + SystemEnv.getHtmlLabelName(15450, user.getLanguage()) + "\" index=\"1\"/>";
	     		operateString +="     <operate href=\"javascript:doLog();\" text=\"" + SystemEnv.getHtmlLabelName(83, user.getLanguage()) + "\"  index=\"2\"/>";
	     		operateString +=" </operates>";
	tableString = " <table instanceid=\"MaintContacterTitleListTable\"  tabletype=\"none\" pageId=\""+PageIdConst.CRM_StatusSet+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_StatusSet,user.getUID(),PageIdConst.CRM)+"\" >"
	+ "	<sql backfields=\"" + backfields 
	+ "\" sqlform=\"" + fromSql 
	+ "\" sqlwhere=\"" + Util.toHtmlForSplitPage(sqlWhere) 
	+ "\"  sqlorderby=\"" + orderkey
	+ "\"  sqlprimarykey=\"t1.id\" sqlsortway=\"asc\" sqlisdistinct=\"true\" />" ;
	
	tableString +=  operateString;
	tableString += " <head>"; 
	tableString += " <col width=\"25%\"  text=\"" + SystemEnv.getHtmlLabelName(602,user.getLanguage()) + SystemEnv.getHtmlLabelName(195,user.getLanguage())
	+ "\" column=\"fullname\" orderkey=\"t1.fullname\"  linkkey=\"t1.id\" linkvaluecolumn=\"t1.id\" transmethod=\"weaver.crm.Maint.CRMTransMethod.getCRMContacterLinkWithTitle\" otherpara=\""
	+ otherpara + "\" />";
	tableString += " <col width=\"75%\"  text=\"" + SystemEnv.getHtmlLabelName(602,user.getLanguage()) + SystemEnv.getHtmlLabelName(433,user.getLanguage())
	+ "\" column=\"description\" orderkey=\"t1.description\"/>";
	
	tableString += " </head>" + "</table>";
%>
<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.CRM_StatusSet%>">
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" isShowBottomInfo ="true" />
								

</BODY>
</HTML>
