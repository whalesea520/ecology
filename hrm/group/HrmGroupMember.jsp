<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.StaticObj"%>
<%@page import="weaver.splitepage.transform.SptmForHR"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
/*
if(!HrmUserVarify.checkUserRight("CustomGroup:Edit", user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}*/
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(31978, user.getLanguage());
String needfav ="1";
String needhelp ="";

int groupid = Util.getIntValue(request.getParameter("groupid"),0);

String qname = Util.null2String(request.getParameter("flowTitle"));
String resourcename = Util.null2String(request.getParameter("resourcename"));
if(resourcename.length()==0&&qname.length()>0){
	resourcename = qname;
}
if(qname.length()==0 && resourcename.length() > 0){
	qname = resourcename;
}
String subId = Util.null2String(request.getParameter("subId"));
String depId = Util.null2String(request.getParameter("depId"));
String jobtitle = Util.null2String(request.getParameter("jobtitle"));

SptmForHR sptmForHR = new SptmForHR();

String shownameHrm = "";
String shownameDep = "";
String shownameSub = "";

if (!"".equals(subId)) {
	shownameSub = sptmForHR.getContent(subId, 2+"");
}
if (!"".equals(depId)) {
	shownameDep = sptmForHR.getContent(depId, 3+"");
} 
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick1(){
	jQuery("input[name='flowTitle'").val('');
	onBtnSearchClick();
}
function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}
			
			var dialog = null;
			var dWidth = 500;
			var dHeight = 350;
			
			var parentDialog = parent.parent.getDialog(parent);
			var parentWin = parent.parent.getParentWindow(parent);
			
			var id = "<%=groupid%>";
			function closeDialog(){
				if(dialog)
					dialog.close();
				window.location.href="/hrm/group/HrmGroupMember.jsp?isdialog=1&groupid="+id;
			}
		
			function doOpen(url,title,_dWidth,_dHeight,_callBack){
				if(dialog==null){
					dialog = new window.top.Dialog();
				}
				dialog.currentWindow = window;
				dialog.Title = title;
				dialog.Width = _dWidth ? _dWidth : dWidth;
				dialog.Height = _dHeight ? _dHeight : dHeight;
				dialog.Drag = true;
				dialog.maxiumnable = true;
				dialog.URL = url;
				dialog.callback = _callBack;
				dialog.show();
			}
			
			function showDatas(data){
				try {
					if(data.id){
						jQuery.ajax({
							type: "post",
							url: "/hrm/group/HrmGroupMemberOperation.jsp",
							data: {method:"addMemebers", groupid:id, memebers:data.id},
							dataType: "JSON",
							success: function(result){
								_table.reLoad();
								parentWin.jsChangeRemindImg();
							}
						});
					}
				} catch(ex) {
				}
			}
			function reloadParWin(){
				parentWin.jsChangeRemindImg();
			}
			function doAdd(){
				doOpen("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?selectedids=","<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>",650,600,showDatas);
			}
			
			function doEdit(id){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=HrmGroupMemberEdit&id="+id,"<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(19910,user.getLanguage())%>");
			}
			
			function doImp(id){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=HrmGroupMemberDataImport&importtype=groupmember&groupid=<%=groupid%>","<%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%>");
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
							url:"HrmGroupMemberOperation.jsp?isdialog=1&method=delete&groupid=<%=groupid%>&id="+idArr[i],
							type:"post",
							async:true,
							complete:function(xhr,status){
								ajaxNum--;
								if(ajaxNum==0){
									_table.reLoad();
								}
								parentWin.jsChangeRemindImg();
							}
						});
					}
				});
			}
			function doSaveDsporder(id){
				jQuery("input[name=method]").val("saveDsporder");
				jQuery("#searchfrm").attr("action","HrmGroupMemberOperation.jsp");
				searchfrm.submit(); 
			}
var pluginId = {
		type:"hidden",
		name:"id",
		addIndex:false
	};			
			
var pluginDsporder = {
		type:"input",
		name:"dsporder",
		bind:[
			{type:"keyup",fn:function(){
				checknumberJd(this);
			}}
		],
		addIndex:false
	};
	
function checknumberJd(obj){
	if(isNaN(obj.value)== true){
		$(obj).attr("value","");
	}
	if($(obj).val()==""){
		$(obj).attr("value","0.0");
	}
}
</script>
</head>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSaveDsporder(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:doAdd(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18596,user.getLanguage())+",javascript:doImp(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDel(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="searchfrm" name="searchfrm" method="post" action="HrmGroupMember.jsp">
<input id="groupid" name="groupid" value="<%=groupid %>" type="hidden" />
<input id="method" name="method"  type="hidden" />
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSaveDsporder()"/><!-- 添加 -->
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" class="e8_btn_top" onclick="doAdd()"/><!-- 添加 -->
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%>" class="e8_btn_top" onclick="doImp()"/><!-- 导入 -->
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>" class="e8_btn_top" onclick="doDel()"/><!-- 批量删除 -->
			<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>" onchange="setKeyword('flowTitle','resourcename','searchfrm');" />
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="菜单" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></wea:item>
			<wea:item>
		        <INPUT type="text" class=inputstyle id=resourcename name=resourcename style="width: 165px" size=20 value='<%=resourcename%>'>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
			<wea:item>
		        <brow:browser viewType="0" name="subId" browserValue='<%=subId %>' 
		                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?show_virtual_org=-1&selectedids="
		                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
		                completeUrl="/data.jsp?show_virtual_org=-1&type=194"  temptitle='<%= SystemEnv.getHtmlLabelName(141,user.getLanguage())%>'
		                browserSpanValue='<%=(shownameSub) %>' width="60%" >
		        </brow:browser>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
			<wea:item>
			        <brow:browser viewType="0" name="depId" browserValue='<%=depId %>' 
			                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MultiDepartmentBrowserByOrder.jsp?show_virtual_org=-1&selectedids="
			                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
			                completeUrl="/data.jsp?show_virtual_org=-1&type=57"  temptitle='<%= SystemEnv.getHtmlLabelName(124,user.getLanguage())%>'
			                browserSpanValue='<%=(shownameDep) %>' width="60%" >
	                </brow:browser>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></wea:item>
			<wea:item>
			    	<input type="text" class=inputstyle id=jobtitle name=jobtitle maxlength=60 style="width:177px" value="<%=jobtitle %>">
			</wea:item>
		</wea:group>
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick1();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<%
String backfields = " a.id,a.groupid,a.userid,b.subcompanyid1,a.dsporder,b.departmentid,b.jobtitle,b.lastname,c.jobtitlename "; 
String fromSql  = " HrmGroupMembers a left join hrmresource b on a.userid = b.id left join HrmJobTitles c on b.jobtitle= c.id ";
String sqlWhere = " where a.groupid =  "+groupid;
String orderby = " a.dsporder " ;
String tableString = "";
String  operateString= "";

if(!"".equals(qname)){
	sqlWhere += " and (b.lastname like '%"+qname+"%' or pinyinlastname like '%"+qname+"%') ";
}

if (!"".equals(resourcename)) {
	sqlWhere += " and (b.lastname like '%"+resourcename+"%' or pinyinlastname like '%"+resourcename+"%')  ";
}
if (!"".equals(subId)) {
	sqlWhere += " and b.subcompanyid1 in("+subId+")  ";
}

if (!"".equals(depId)) {
	sqlWhere += " and b.departmentid in("+depId+")  ";
}

if (!"".equals(jobtitle)) {
	sqlWhere += " and c.jobtitlename like '%"+jobtitle+"%'  ";
}
operateString = "<operates width=\"20%\">";
 	       operateString+=" <popedom transmethod=\"weaver.hrm.HrmTransMethod.getGroupMemberOperate\" otherpara=\"true\"></popedom> ";
 	       operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"0\"/>";
 	       operateString+="</operates>";	
 
tableString =" <table pageId=\""+PageIdConst.Hrm_GroupMember+"\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.Hrm_GroupMember,user.getUID(),PageIdConst.HRM)+"\" >"+
		" <checkboxpopedom showmethod=\"weaver.hrm.HrmTransMethod.getGroupMemberCheckbox\"  id=\"checkbox\"  popedompara=\"column:id\" />"+
		"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"Asc\" sqlisdistinct=\"false\"/>"+
    operateString+
    "			<head>"+
    "				<col width=\"0%\" hide=\"true\" editPlugin=\"pluginId\" text=\"\" column=\"id\"/>"+
    "				<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(413,user.getLanguage())+"\" column=\"lastname\" orderkey=\"lastname\" />"+
    "				<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(141,user.getLanguage())+"\" column=\"subcompanyid1\" orderkey=\"subcompanyid1\" transmethod=\"weaver.hrm.company.SubCompanyComInfo.getSubCompanyname\" />"+
    "				<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"\" column=\"departmentid\" orderkey=\"b.departmentid\" transmethod=\"weaver.hrm.company.DepartmentComInfo.getDepartmentname\" />"+
    "				<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(2120,user.getLanguage())+"\" column=\"userid\" orderkey=\"userid\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmGroupMembersMan\" />"+
    "				<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(6086,user.getLanguage())+"\" column=\"jobtitlename\" orderkey=\"jobtitlename\"  />"+
    "				<col width=\"30%\" editPlugin=\"pluginDsporder\" text=\""+SystemEnv.getHtmlLabelName(338,user.getLanguage())+"\" column=\"dsporder\" orderkey=\"dsporder\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmGroupDsporder\" />"+
    "			</head>"+
    " </table>";
%>
<div class="zDialog_div_content">
	<wea:SplitPageTag isShowTopInfo="false" tableString="<%=tableString%>" mode="run" />
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
    	<wea:item type="toolbar">
    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="parentDialog.closeByHand();">
    	</wea:item>
    </wea:group>
</wea:layout>
</div>
</form>
</BODY>
</HTML>