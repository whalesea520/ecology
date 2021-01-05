
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

//新建、编辑获得途径 add by Dracula @2014-1-24
function openDialog(id){
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/CRM/Maint/AddContactWay.jsp";
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32613,user.getLanguage()) %>";
	if(!!id){//编辑
		url = "/CRM/Maint/EditContactWay.jsp?id="+id;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(32614,user.getLanguage()) %>";
	}
	dialog.Width = 420;
	dialog.Height = 220;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

//打开单条记录的日志
function doLog(id)
{
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/systeminfo/SysMaintenanceLog.jsp?soperateitem="+145;
	if(id)
		url+="&relatedid="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(31709,user.getLanguage()) %>";
	dialog.Width = 600;
	dialog.Height =550;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}

//编辑 add by Dracula @2014-1-23
function doEdit(id)
{
	openDialog(id);
}
//删除 add by Dracula @2014-1-23
function doDel(id,fullname)
{
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
		
		jQuery.post("/CRM/Maint/ContactWayOperation.jsp",{"method":"delete","id":id,"name":fullname},function(){
			 _table.reLoad()
		});
	});
	
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
				jQuery.post("/CRM/Maint/ContactWayOperation.jsp",{"method":"delete","id":idArr[i]},function(){
					_table.reLoad()
				});
			}
		});
		
    }
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(569,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("AddContactWay:add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog(),''} " ;
RCMenuHeight += RCMenuHeightStep ;
}

if(HrmUserVarify.checkUserRight("ContactWay:Log", user)){
    if(rs.getDBType().equals("db2")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)="+145+",_self} " ;
    }else{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:doLog(),_self} " ;
    }
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0" >
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan">
			<%if(HrmUserVarify.checkUserRight("AddContactWay:add", user)){ %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82, user.getLanguage()) %>" class="e8_btn_top"  onclick="openDialog()"/>&nbsp;&nbsp;
			<%}if(HrmUserVarify.checkUserRight("EditContactWay:Delete", user)){ %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(23777, user.getLanguage()) %>" class="e8_btn_top" onclick="delMutli()"/>&nbsp;&nbsp;
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table> 
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0"  id="contacteWayTable">
	<tr>
		<td valign="top">
			<TABLE class=Shadow>
				<tr>
					<td valign="top">
						<TABLE width="100%" cellspacing="0" cellpadding="0">
							<tr>
								<td valign="top" class="_xTableOuter">
								<%
									//原始页面未采用分页控件，现在改成分页控件 add by Dracula @2014-1-24
									String otherpara = "column:id+column:description";
									String tableString = "";
									String backfields = " t1.id, t1.fullname, t1.description, t1.orderkey ";
									String fromSql = " from crm_contactway  t1 ";
									String orderkey = " t1.orderkey ";
									String sqlWhere = " 1=1 ";
									String fullnamepara = "column:fullname";
									String popedomUserpara = String.valueOf(user.getUID());
									String checkpara = "column:id+"+popedomUserpara;
									String operateString = "";
									operateString = " <operates>";
									operateString +=" <popedom transmethod=\"weaver.crm.Maint.CRMTransMethod.getCRMContactWayListOperation\"  otherpara=\""+popedomUserpara+"\" ></popedom> ";
									operateString +="     <operate href=\"javascript:doEdit();\" text=\"" + SystemEnv.getHtmlLabelName(93, user.getLanguage()) + "\"  index=\"0\"/>";
									operateString +="     <operate href=\"javascript:doDel();\" text=\"" + SystemEnv.getHtmlLabelName(23777, user.getLanguage()) + "\" otherpara=\""+fullnamepara+"\" index=\"1\"/>";
					 	       		operateString +="     <operate href=\"javascript:doLog();\" text=\"" + SystemEnv.getHtmlLabelName(83, user.getLanguage()) + "\"  index=\"2\"/>";
					 	       		operateString +=" </operates>";
									tableString = " <table instanceid=\"MaintContacterTitleListTable\"  tabletype=\"checkbox\" pageId=\""+PageIdConst.CRM_ContactWay+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_ContactWay,user.getUID(),PageIdConst.CRM)+"\" >"
									+ " <checkboxpopedom  id=\"checkbox\" popedompara=\""+checkpara+"\" showmethod=\"weaver.crm.Maint.CRMTransMethod.getCRMContactWayResultCheckbox\" />"
									+ "	<sql backfields=\"" + backfields 
									+ "\" sqlform=\"" + fromSql 
									+ "\" sqlwhere=\"" + Util.toHtmlForSplitPage(sqlWhere) 
									+ "\"  sqlorderby=\"" + orderkey
									+ "\"  sqlprimarykey=\"t1.id\" sqlsortway=\"asc\" sqlisdistinct=\"true\" />" ;
									
									tableString +=  operateString;
									tableString += " <head>"; 
									tableString += " <col width=\"25%\"  text=\"" + SystemEnv.getHtmlLabelName(195, user.getLanguage())
									+ "\" column=\"fullname\" orderkey=\"t1.fullname\"  linkkey=\"t1.id\" linkvaluecolumn=\"t1.id\" transmethod=\"weaver.crm.Maint.CRMTransMethod.getCRMContacterLinkWithTitle\" otherpara=\""
									+ otherpara + "\" />";
									tableString += " <col width=\"75%\"  text=\"" + SystemEnv.getHtmlLabelName(433, user.getLanguage())
									+ "\" column=\"description\" orderkey=\"t1.description\"/>";
									
									tableString += " </head>" + "</table>";
								%>
									<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.CRM_ContactWay%>">
									<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" isShowBottomInfo ="true" />
								</td>
							</tr>
						</TABLE>
					</td>
				</tr>
			</TABLE>
		</td>
	</tr>	
</table>
</BODY>
</HTML>
