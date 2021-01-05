<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
 <%@ taglib uri="/browserTag" prefix="brow"%>
 <%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="subCompInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%
	if (!HrmUserVarify.checkUserRight("WorkflowMonitor:All", user))
	{
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	int userid=user.getUID();

	int monitorhrmid=Util.getIntValue(request.getParameter("monitorhrmid"),0);
	String typeid = Util.null2String(request.getParameter("typeid"));
	int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"),0);
	String isclose = Util.null2String(request.getParameter("isclose"));
	//System.out.println("isclose = "+isclose);
	typeid = (Util.getIntValue(typeid,0)<=0)?"":typeid;
	int monitor=userid;
	if(monitorhrmid>0) monitor=monitorhrmid;
	String imagefilename = "/images/hdHRM_wev8.gif";
	String titlename = "";
	String needfav = "1";
	String needhelp = "";
	String typename = "";
	if(Util.getIntValue(typeid,0)>0)
	{
		rs.executeSql("select * from Workflow_MonitorType where id = "+typeid);
		if(rs.next())
		{
			typename = rs.getString("typename");
		}
	}
	//是否分权系统，如不是，则不显示框架，直接转向到列表页面
	int detachable = 0;
	boolean isUseWfManageDetach = manageDetachComInfo.isUseWfManageDetach();
	if(isUseWfManageDetach){
		detachable = 1;
		session.setAttribute("detachable","1");
	}
	//if (detachable == 0){
	//	response.sendRedirect("/system/systemmonitor/workflow/systemMonitorSet.jsp?monitorhrmid="+monitorhrmid+"&subcompanyid="+subcompanyid+"&typeid="+typeid);
	//	return;
	//}
%>
<HTML>
	<HEAD>
			<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
		<script language="JavaScript">
		var dialog = null;
		var parentWin = null;
		try{
			 dialog = parent.parent.getDialog(parent);
			 parentWin = parent.parent.getParentWindow(parent);
			}catch(e){}

		if("<%=isclose%>"==1){
			parentWin.location="/system/systemmonitor/workflow/systemMonitorStatic.jsp?typeid=<%=typeid%>";
			dialog.close();
		}
		
		function closecancle(){
			var newdialog = parent.getDialog(window);
			newdialog.close();
		}
		
		function getParentHeight() {
			if(parent.parent.window.document.getElementById('leftFrame') == null) {
			  	return "100%";
			}else {
				return parent.parent.window.document.getElementById('leftFrame').scrollHeight;
			}
		}
		if (window.jQuery.client.browser == "Firefox") {
		jQuery(document).ready(function () {
			jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
			window.onresize = function () {
				jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
			};
		});
	}
		function doSave(){
			var isCheck = false;
			var len = document.contentframe.frmmain.elements.length;
			
		    var i=0;
		    for( i=0; i<len; i++) {
		        //if (document.frmmain.elements[i].name.indexOf('w')==0) {
		    		if(document.contentframe.frmmain.elements[i].checked==true) {
		        		//alert(document.frmmain.elements[i].name);
		        		isCheck = true;
		        		break;
		    		}
		        //}
		    }
		   if(!isCheck) {
			   top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(22442,user.getLanguage())%>!');
			   return;
		   }
		   var checkfields = "";
		   <% if(detachable==1){ %>
				checkfields = 'inputt1,inputt2,subcompanyid';
		   <%}else{%>
				checkfields = 'inputt1,inputt2';
		   <%}%>
			if (check_form(frmmain,checkfields)){
				var str1 = $("input[name='inputt1']").val();
				//var str1 = spanval1.substring(0,spanval1.length-3);
				var str2 = $("input[name='inputt2']").val();
				//var str2 = spanval2.substring(0,spanval2.length-3);
				$('#contentframe').contents().find("#monitorhrmid").val(str1); 
				$('#contentframe').contents().find("#monitortypeid").val(str2);
				frames["contentframe"].document.forms["frmmain"].submit();
				
				//$("input[name='monitorhrmid']").val(str1);
				//$("input[name='monitortypeid']").val(str2);

				//document.getElementById("contentframe").contextWindow.document.frmmain.submit();
				
				//obj.disabled = true;
			}
		}
		
		function expendAll(){
			  //showGroup("groupShow");
			//frames["contentframe"].document.forms["frmmain"].goexpandall();
			contentframe.window.goexpandall();

		}
		
		function contractionAll(){
			  //hideGroup("groupShow");
			  //frames["contentframe"].document.forms["frmmain"].tree.collapseAll();
			  contentframe.window.docollapseall();
		}
		</script>
	</HEAD>
	<body scroll="no">
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(16216,user.getLanguage())+",javascript:expendAll(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(18466,user.getLanguage())+",javascript:contractionAll(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="新建监控"/>
</jsp:include>

<FORM id="weaver" name="frmmain" action="/system/systemmonitor/workflow/systemMonitorOperation.jsp" method=post>
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
    			<input type="button" value="保存" id="zd_btn_submit" class="e8_btn_top"  onclick="doSave()">
				<input type="button" value="全部展开" class="e8_btn_top" onclick="expendAll()"/>
				<input type="button" value="全部收缩" class="e8_btn_top" onclick="contractionAll()"/>
				<span title="菜单" class="cornerMenu"></span>
			</td>
		</tr>
</table>
	<div style="width:100%;height:100%;">
	<wea:layout type="2Col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(665,user.getLanguage())%>' attributes="{'samePair':'groupShow','itemAreaDisplay':'block'}">
			<wea:item><%=SystemEnv.getHtmlLabelName(665,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser name="inputt1" viewType="0" hasBrowser="true" hasAdd="false" 
          					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" isMustInput="2" isSingle="true" hasInput="true"
           					completeUrl="/data.jsp"  width="150px" browserValue='<%=monitor+""%>' browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(String.valueOf(monitor)),user.getLanguage())%>'/>
           					
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(2239,user.getLanguage())%></wea:item>
			<wea:item>
			<brow:browser name="inputt2" viewType="0" hasBrowser="true" hasAdd="false" 
           				browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/monitor/monitortypeBrowser.jsp" isMustInput="2" isSingle="true" hasInput="true"
            				completeUrl="/data.jsp?type=monitortypeBrowser"  width="150px" browserValue='<%=typeid%>' browserSpanValue='<%=Util.toScreen(typename,user.getLanguage())%>'/> 
            				
			</wea:item>
		</wea:group>
		<wea:group context="监控流程" attributes="{'samePair':'groupShow','itemAreaDisplay':'block'}" >
			<wea:item attributes="{'colspan':'2','isTableList':'true'}">
				<div style="width:100%;height:100%;">
				<TABLE class=viewform   id=oTable1 style="height:100%;width:100%;"  cellpadding="0px" cellspacing="0px">
					<TBODY>
						<tr>
						<%if (detachable == 1){ %>
							<td  height="662px" id=oTd1 name=oTd1 width="220px" style=’padding:0px’>
								<IFRAME name=leftframe id=leftframe src="/system/systemmonitor/workflow/managemonitor_newleft.jsp?rightStr=WorkflowMonitor:All&monitorhrmid=<%=monitorhrmid %>&subcompanyid=<%=subcompanyid %>&typeid=<%=typeid %>" width="100%" height="100%" frameborder=no scrolling="no">
									浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。
								</IFRAME>
							</td>
							<%} %>
							<td height="662px" id=oTd2 name=oTd2 width="*" style=’padding:0px’>
								<IFRAME name=contentframe id=contentframe src="/system/systemmonitor/workflow/systemMonitorSet.jsp?monitorhrmid=<%=monitorhrmid %>&subcompanyid=<%=subcompanyid %>&typeid=<%=typeid %>" width="100%" height="100%" frameborder=no scrolling=yes>
									浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。
								</IFRAME>
							</td>
						</tr>
					</TBODY>
				</TABLE>
				</div>
			</wea:item>
		</wea:group>
	</wea:layout>
	</div>
</form>

</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="closecancle();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
	</body>
</html>
