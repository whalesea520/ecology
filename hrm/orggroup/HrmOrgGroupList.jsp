
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>

<%
if(!HrmUserVarify.checkUserRight("GroupsSet:Maintenance", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){

	jQuery("#searchfrm").submit();
}

function doDel(id){
	if(!id){
		id = _xtable_CheckedCheckboxId();
	}
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
		var idArr = id.split(",");
		var ajaxNum = 0;
		for(var i=0;i<idArr.length;i++){
			ajaxNum++;
			jQuery.ajax({
				url:"/hrm/orggroup/HrmOrgGroupOperation.jsp?isdialog=1&operation=delete&orgGroupId="+idArr[i]+"&id="+idArr[i],
				type:"post",
				async:true,
				complete:function(xhr,status){
					ajaxNum--;
					if(ajaxNum==0){
						_table.reLoad();
					}
				}
			});
		}
	});
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function openDialog(id,cmd){
	dialog = new window.top.Dialog();
	dialog.checkDataChange = false;
	dialog.currentWindow = window;
	if(id==null)id="";
	var url = "";
	dialog.Width = 600;
	dialog.Height = 239;
	if(cmd=="hrmOrgGroupAdd"){
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,24002", user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmOrgGroupAdd";
	}else if(cmd=="hrmOrgGroupEdit"){
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("33534", user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmOrgGroupEdit&id="+id;
	}else if(cmd=="relatedSetting"){
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("24662", user.getLanguage())%>";
		dialog.Width = 800;
		dialog.Height = 600;
		url = "/hrm/HrmTab.jsp?_fromURL=HrmOrgGroupRelated&orgGroupId="+id;
	}
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function hrmOrgGroupAdd(){
	openDialog(null,"hrmOrgGroupAdd");
}

function hrmOrgGroupEdit(id){
	openDialog(id,"hrmOrgGroupEdit");
}

function relatedSetting(id){
	openDialog(id,"relatedSetting");
}

function onLog(id){
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	if(id && id!=""){
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=25 and relatedid=")%>&relatedid="+id;
	}else{
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=25")%>";
	}
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}
</script>
</head>
<%

String orgGroupName = Util.null2String(request.getParameter("orgGroupName"));
String orgGroupDesc = Util.null2String(request.getParameter("orgGroupDesc"));
String qname = Util.null2String(request.getParameter("flowTitle"));


String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(24001, user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
    
    RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javaScript:hrmOrgGroupAdd(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
    
    RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDel(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
    String sqlwhere =" where (isDelete is null or isDelete='0') ";
		if (!"".equals(qname)) {
		  sqlwhere = sqlwhere + " and orgGroupName like '%"+Util.toHtml100(qname)+"%'" ;
		}
    if (!"".equals(orgGroupName)) {
  	    sqlwhere = sqlwhere + " and orgGroupName like '%"+Util.toHtml100(orgGroupName)+"%'" ;
    }
    if (!"".equals(orgGroupDesc)) {
  	    sqlwhere = sqlwhere + " and orgGroupDesc like '%"+Util.toHtml100(orgGroupDesc)+"%'" ;
    }

String backfields = "id,orgGroupName,orgGroupDesc,showOrder";
String fromSql  = " from HrmOrgGroup ";
String orderby = " showOrder " ;
//操作字符串
String  operateString= "";
operateString = "<operates width=\"20%\">";
	       operateString+=" <popedom transmethod=\"weaver.hrm.HrmTransMethod.getHrmOrgGroupRelatedOperate\" otherpara=\""+HrmUserVarify.checkUserRight("GroupsSet:Maintenance", user)+"\" otherpara2=\""+HrmUserVarify.checkUserRight("GroupsSet:Maintenance", user)+":"+HrmUserVarify.checkUserRight("GroupsSet:Maintenance", user)+":"+HrmUserVarify.checkUserRight("GroupsSet:Maintenance", user)+"\"></popedom> ";
	       operateString+="     <operate href=\"javascript:hrmOrgGroupEdit();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
	       operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
	       operateString+="     <operate href=\"javascript:relatedSetting()\" text=\""+SystemEnv.getHtmlLabelName(24662,user.getLanguage())+"\" index=\"2\"/>";
	       operateString+="</operates>";	
String tabletype="checkbox";
if(HrmUserVarify.checkUserRight("GroupsSet:Maintenance", user)){
	tabletype = "checkbox";
}

String tableString =" <table pageId=\""+PageIdConst.HRM_OrgGroupList+"\" tabletype=\""+tabletype+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_OrgGroupList,user.getUID(),PageIdConst.HRM)+"\" >"+
								 " <checkboxpopedom showmethod=\"weaver.hrm.HrmTransMethod.getHrmOrgGroupRelatedCheckbox\"  id=\"checkbox\"  popedompara=\"column:id\" />"+
                 "	   <sql backfields=\""+Util.toHtmlForSplitPage(backfields)+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\""+orderby+"\" sqlprimarykey=\"id\"   sqlsortway=\"asc\" />"+
                 operateString+
                 "			<head>"+
                 "				<col width=\"40%\"   text=\""+SystemEnv.getHtmlLabelName(24679,user.getLanguage())+"\" column=\"orgGroupName\" orderkey=\"orgGroupName\" />"+
                 "				<col width=\"45%\"   text=\""+SystemEnv.getHtmlLabelName(24680,user.getLanguage())+"\" column=\"orgGroupDesc\" orderkey=\"orgGroupDesc\" />"+
                 //"				<col width=\"15%\"   text=\""+SystemEnv.getHtmlLabelName(24662,user.getLanguage())+"\" column=\"id\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.hrm.orggroup.SptmForOrgGroup.getRelatedSetting\" linkvaluecolumn=\"id\" linkkey=\"orgGroupId\" href=\"/hrm/orggroup/HrmOrgGroupRelated.jsp\"  target=\"_fullwindow\"/>"+
                 "				<col width=\"15%\"   text=\""+SystemEnv.getHtmlLabelName(88,user.getLanguage())+"\" column=\"showOrder\" orderkey=\"showOrder\"  />"+               
                 "			</head>"+
                 " </table>";
  %>
<TABLE class=Shadow>
<tr>
<td valign="top">
<form id="searchfrm" name="searchfrm" method="post" action="">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<%if(HrmUserVarify.checkUserRight("GroupsSet:Maintenance", user)){ %>
					<input type=button class="e8_btn_top" onclick="hrmOrgGroupAdd();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
				<%}if(HrmUserVarify.checkUserRight("GroupsSet:Maintenance", user)){ %>
					<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
				<%} %>
				<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>
							<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >	
		<wea:layout type="4col">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(24679,user.getLanguage())%></wea:item>
			<wea:item>
				<input type="text" name="orgGroupName" class="inputStyle" value=<%=orgGroupName%>>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(24680,user.getLanguage())%></wea:item>
			<wea:item>
				<input type="text" name="orgGroupDesc" class="inputStyle" value=<%=orgGroupDesc%>>
			</wea:item>
			</wea:group>
			<wea:group context="">
			<wea:item type="toolbar">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick();"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
			</wea:group>
		</wea:layout>
	</div>
	 <input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HRM_OrgGroupList %>"/>
	<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>'  mode="run" />
</form>
</td>
</tr>
</TABLE>
</BODY></HTML>