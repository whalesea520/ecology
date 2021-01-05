
<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FormModeRightInfo" class="weaver.formmode.search.FormModeRightInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<style>
*{
	font: 12px Microsoft YaHei;
}
.e8_tblForm{
	width: 100%;
	margin: 0 0;
	border-collapse: collapse;
}
.e8_tblForm .e8_tblForm_label{
	vertical-align: top;
	border-bottom: 1px solid #e6e6e6;
	padding: 5px 2px;
}
.e8_tblForm .e8_tblForm_field{
	border-bottom: 1px solid #e6e6e6;
	padding: 5px 7px;
	background-color: #f8f8f8;
}
.e8_label_desc{
	color: #aaa;
}
</style>
<script language=javascript src="/js/weaver_wev8.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("FORMMODEAPP:ALL", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
int pageid = Util.getIntValue(request.getParameter("id"),0);
String imagefilename = "/images/hdMaintenance_wev8.gif";
//自定义查询:权限设置
String titlename = SystemEnv.getHtmlLabelName(20773,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(16526,user.getLanguage());
String needfav ="";
String needhelp ="";

String subCompanyIdsql = "SELECT b.subcompanyid FROM mode_customsearch a,modeTreeField b WHERE a.appid=b.id AND a.id="+pageid;
RecordSet recordSet = new RecordSet();
recordSet.executeSql(subCompanyIdsql);
int subCompanyId = -1;
if(recordSet.next()){
	subCompanyId = recordSet.getInt("subCompanyId");
}
String userRightStr = "FORMMODEAPP:ALL";
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<BODY> 
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doback(this),_top} " ;//返回
//RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%

int formId = Util.getIntValue(Util.null2String(request.getParameter("formId")));
int modeId = Util.getIntValue(Util.null2String(request.getParameter("modeId")));
//QC:365739 勾选无权限列表时批量修改不显示
String norightlist=Util.toScreen(Util.null2String(request.getParameter("norightlist")),user.getLanguage());
FormModeRightInfo.setUser(user);
FormModeRightInfo.setPageid(pageid);

Map allRightMap = FormModeRightInfo.getAllRightList();			//所有权限
List viewRightList = FormModeRightInfo.getViewRightList();		//查看权限
List monitorRightList = FormModeRightInfo.getMonitorRightList();//监控权限
List editRightList = FormModeRightInfo.getEditRightList();//批量修改权限

%>

			<FORM id=weaver name=weaver action="ModeCommonRightOperation.jsp" method=post>
				<input type=hidden name="method" value="addNew">
				<input type=hidden name=pageid value="<%=pageid %>">
				<input type=hidden name=formId value="<%=formId %>">
				<input type=hidden name=modeId value="<%=modeId %>">
				<input type=hidden name=mainids >

<table class="e8_tblForm">
<tr><td colspan="2" style="height:8px;"></td></tr>
										<TR>
							            	<td  colspan="2" style="padding-bottom: 8px;color: #888888;">
							            		<%=SystemEnv.getHtmlLabelName(31851,user.getLanguage())%><!-- 在此页面设置查看或监控权限后，模块中设置的共享或监控权限将不能访问对应的菜单页面 -->
							            	</td>
							          	</TR>
							          	<tr><td colspan="2" style="border-bottom:1px solid #e6e6e6;"></td></tr>
										<TR>
							            	<td style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(18932,user.getLanguage())%></td><!-- 查看权限 -->
							    			<td align=right>
							    			<%if(operatelevel>1){%>
							    		  		<input type="checkbox" name="chkPermissionAll1" onclick="chkAllClick(this,1)">(<%=SystemEnv.getHtmlLabelName(2241,user.getLanguage())%>)<!-- 全部选中 -->
							    			<%} %>
							    			<%if(operatelevel>0){%>
							    		  		<a href="CustomSearchShareAdd.jsp?righttype=1&pageid=<%=pageid%>&formId=<%=formId%>&modeId=<%=modeId%>"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a><!-- 添加 -->
							    			<%} %>
							    			<%if(operatelevel>1){%>
							    		  		<a href="javascript:void(0);" onclick="javaScript:doDelShare(1);"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> <!-- 删除 -->   
							    			<%} %>
							            	</td>
							          	</TR>
										<tr><td colspan="2" style="border-bottom:1px solid #e6e6e6;"></td></tr>
							          	<%
								            Map datamap = null;
								            for(int i=0 ;i < viewRightList.size();i++){
								          	  datamap = (Map)viewRightList.get(i);
								          	  String rightid = (String)datamap.get("rightId");
								          	  String sharetypetext = (String)datamap.get("sharetypetext");
								          	  String detailText = (String)datamap.get("detailText");
							          	%>
							          	<tr>
							            	<td class="e8_tblForm_label" width="20%"><input type="checkbox" name="rightid1" id="rightid1" value="<%=rightid %>"></td>
							            	<td class="e8_tblForm_field"><%=sharetypetext %> <%=detailText%></td>
							          	</tr>
							          	<%
							          		}
							          	%>
							          	
							          	<tr><td colspan="2" style="height:8px;"></td></tr>
							          	<TR style="display: <%=VirtualFormHandler.isVirtualForm(formId)?"none":""%>">
							            	<td style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(20305,user.getLanguage())%></td><!-- 监控权限 -->
							    			<td align=right>
								    			<%if(operatelevel>1){%>
								    		  		<input type="checkbox" name="chkPermissionAll4" onclick="chkAllClick(this,4)">(<%=SystemEnv.getHtmlLabelName(2241,user.getLanguage())%>)<!-- 全部选中 -->
								    			<%} %>
								    			<%if(operatelevel>0){%>
								    		  		<a href="CustomSearchShareAdd.jsp?righttype=4&pageid=<%=pageid%>&formId=<%=formId%>&modeId=<%=modeId%>"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a><!-- 添加 -->
								    			<%} %>
								    			<%if(operatelevel>1){%>
								    		  		<a href="javascript:void(0);" onclick="javaScript:doDelShare(4);"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>    <!-- 删除 -->
								    			<%} %>
							            	</td>
							          	</TR>
							          	<tr style="display: <%=VirtualFormHandler.isVirtualForm(formId)?"none":""%>"><td colspan="2" style="border-bottom:1px solid #e6e6e6;"></td></tr>
							          	<%
								 
								            for(int i=0 ;i < monitorRightList.size();i++){
								          	  datamap = (Map)monitorRightList.get(i);
								          	  String rightid = (String)datamap.get("rightId");
								          	  String sharetypetext = (String)datamap.get("sharetypetext");
								          	  String detailText = (String)datamap.get("detailText");
							          	%>
							          	<tr>
							            	<td class="e8_tblForm_label" width="20%"><input type="checkbox" name="rightid4" id="rightid4" value="<%=rightid %>"></td>
							            	<td class="e8_tblForm_field"><%=sharetypetext %> <%=detailText%></td>
							          	</tr>
							          	<%
							          		}
							          	%>
							          	
							          	<tr><td colspan="2" style="height:8px;"></td></tr>
							          	<TR style="display: <%=VirtualFormHandler.isVirtualForm(formId) || "1".equals(norightlist)?"none":""%>">
							            	<td style="font-weight: bold;"><%=SystemEnv.getHtmlLabelNames("25465,385",user.getLanguage())%></td><!-- 批量修改 -->
							    			<td align=right>
								    			<%if(operatelevel>1){%>
								    		  		<input type="checkbox" name="chkPermissionAll2" onclick="chkAllClick(this,2)">(<%=SystemEnv.getHtmlLabelName(2241,user.getLanguage())%>)<!-- 全部选中 -->
								    			<%} %>
								    			<%if(operatelevel>0){%>
								    		  		<a href="CustomSearchShareAdd.jsp?righttype=2&pageid=<%=pageid%>&formId=<%=formId%>&modeId=<%=modeId%>"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a><!-- 添加 -->
								    			<%} %>
								    			<%if(operatelevel>1){%>
								    		  		<a href="javascript:void(0);" onclick="javaScript:doDelShare(2);"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>    <!-- 删除 -->
								    			<%} %>
							            	</td>
							          	</TR>
							          	<tr style="display: <%=VirtualFormHandler.isVirtualForm(formId) || "1".equals(norightlist)?"none":""%>"><td colspan="2" style="border-bottom:1px solid #e6e6e6;"></td></tr>
							          	<%
								 
								            for(int i=0 ;i < editRightList.size();i++){
								          	  datamap = (Map)editRightList.get(i);
								          	  String rightid = (String)datamap.get("rightId");
								          	  String sharetypetext = (String)datamap.get("sharetypetext");
								          	  String detailText = (String)datamap.get("detailText");
							          	%>
							          	<tr style="display: <%=VirtualFormHandler.isVirtualForm(formId) || "1".equals(norightlist)?"none":""%>">
							            	<td class="e8_tblForm_label" width="20%"><input type="checkbox" name="rightid2" id="rightid2" value="<%=rightid %>"></td>
							            	<td class="e8_tblForm_field"><%=sharetypetext %> <%=detailText%></td>
							          	</tr>
							          	<%
							          		}
							          	%>
						          	</TBODY>
								</TABLE>

			</form>

<script language="javascript">
$(document).ready(function(){//onload事件
	$(".loading", window.parent.document).hide(); //隐藏加载图片
})

function onSave(){
	weaver.submit();
}

function chkAllClick(obj,types){
    var chks = document.getElementsByName("rightid"+types);    
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        changeCheckboxStatus(chk, obj.checked);
    }     
}

function doback(){
	location.href = "/formmode/search/CustomSearchEdit.jsp?id=<%=pageid%>";
}

function doDelShare(type){
	var mainids = "";
    var chks = document.getElementsByName("rightid"+type);    
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        if(chk.checked)
        	mainids = mainids + "," + chk.value;
    }
    if(mainids == '') {
    	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22346,user.getLanguage())%>",function(){displayAllmenu();});//请选择要删除的信息
		return false;
    }else{
    	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
			weaver.method.value="delete";
	    	weaver.mainids.value=mainids;
	    	weaver.action="CustomShareOperation.jsp";
	    	weaver.submit();
		});
	}
}
function onSelectChange(obj1,obj2){
     var selectValue = obj1.value;
     if (selectValue!=99) obj2.style.display="";
     else  obj2.style.display="none";           
}
</script>
</BODY></HTML>