
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="weaver.conn.RecordSet"  %>
<%@page import="java.net.*"%>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:include page="/systeminfo/init_wev8.jsp"></jsp:include>
<link href='/css/Weaver_wev8.css' type=text/css rel=stylesheet>
<script type='text/javascript' src='/js/weaver_wev8.js'></script>
<%
String userLanguageId = Util.null2String(request.getParameter("userLanguageId"));
String eid = Util.null2String(request.getParameter("eid"));
String tabId = Util.null2String(request.getParameter("tabId"));
String tabTitle = "";	
tabTitle = URLDecoder.decode(tabTitle, "utf-8");

String ebaseid = Util.null2String(request.getParameter("ebaseid"));
String method = Util.null2String(request.getParameter("method"));

String value = "";
RecordSet rssRs = new RecordSet();
if (session.getAttribute(eid + "_Add") != null) {
		Hashtable tabAddList = (Hashtable) session.getAttribute(eid+ "_Add");
		
		if (tabAddList.containsKey(tabId)) {
			Hashtable tabInfo = (Hashtable) tabAddList.get(tabId);
			tabTitle = Util.null2String((String) tabInfo.get("tabTitle"));
			value = Util.null2String((String) tabInfo.get("tabWhere"));
		}
}
if("".equals(value)){
	rssRs.execute("select * from hpNewsTabInfo where eid="+eid +" and tabid="+tabId);
	if(rssRs.next()){
		tabTitle = rssRs.getString("tabTitle");
		value = rssRs.getString("sqlWhere");
	}
}

String returnStr="";		
String strAddr="";
String strMore="";
String strWidth="";
String strHeight="";
if(!"".equals(value)) {
	String flag="^,^";
	int pos1=value.indexOf(flag);
	int pos2=value.indexOf(flag, pos1+3);
	int pos3=value.indexOf(flag, pos2+3);
	
	strAddr=value.substring(0,pos1);
	strMore=value.substring(pos1+3,pos2);
	strWidth=value.substring(pos2+3,pos3);
	strHeight=value.substring(pos3+3);
}
%>
<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="portal"/>
		   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(19480,user.getLanguage()) %>"/>  
		</jsp:include>
		
		  <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
  
	  <%
	  RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),_self} " ;
	  RCMenuHeight += RCMenuHeightStep ;
	
	  %>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	
	<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td width="160px">
					</td>
					<td class="rightSearchSpan"
						style="text-align: right; width: 500px !important">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" class="e8_btn_top"
							onclick="checkSubmit();" />
						&nbsp;&nbsp;&nbsp;
						<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
		
	<wea:layout type="2Col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(33396,user.getLanguage())%>' attributes="{'class':\"e8_title e8_title_1\"}">
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(229,Util.getIntValue(userLanguageId)) %>
			</wea:item>
			<wea:item>
				<input class=inputStyle id='tabTitle_<%=eid%>' name=tabTitle_<%=eid%> type='text' value="<%=Util.toHtml2(tabTitle.replaceAll("&","&amp;")) %>" onchange='checkinput("tabTitle_<%=eid %>","tabTitleSpan_<%=eid %>")' />
				<SPAN id='tabTitleSpan_<%=eid %>'>
				<%
				if(tabTitle.equals("")){
					%>
					<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
					<% 
				}
				%>
				</SPAN>
			</wea:item>
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(20017,Util.getIntValue(userLanguageId)) %>
			</wea:item>
			<wea:item>
				<input type=text style='width:98%' class='inputstyle'  name=_whereKey_<%=eid %> value='<%=strAddr %>'><br><%=SystemEnv.getHtmlLabelName(18391,Util.getIntValue(userLanguageId)) %>
			</wea:item>
			<wea:item>
				More <%=SystemEnv.getHtmlLabelName(110,Util.getIntValue(userLanguageId)) %>
			</wea:item>
			<wea:item>
				<input type=text  style='width:98%'  class='inputstyle' name=_whereKey_<%=eid %> value='<%=strMore %>'><br><%=SystemEnv.getHtmlLabelName(18391,Util.getIntValue(userLanguageId)) %>
			</wea:item>
			
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(21568,Util.getIntValue(userLanguageId)) %>
			</wea:item>
			<wea:item>
				<input type=hidden style='width:40px' class='inputstyle' name=_whereKey_<%=eid %> value='100'>
				<input type=text style='width:40px' class='inputstyle' name=_whereKey_<%=eid %> value='<%=strHeight %>'>&nbsp;px
			</wea:item>
			</wea:group>
		</wea:layout>

	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
	     <input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();"/>
	    </wea:item>
	</wea:group>
	</wea:layout>
	</div>	
		
	<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
<script type="text/javascript">
function getNewsSettingString(eid){
	var whereKeyStr="";
	var _whereKeyObjs=document.getElementsByName("_whereKey_"+eid);
	//得到上传的SQLWhere语句
	for(var k=0;k<_whereKeyObjs.length;k++){
		var _whereKeyObj=_whereKeyObjs[k];	
		if(_whereKeyObj.tagName=="INPUT" && _whereKeyObj.type=="checkbox" &&! _whereKeyObj.checked) continue;			
		whereKeyStr+=_whereKeyObj.value+"^,^";			
	}
	if(whereKeyStr!="") whereKeyStr=whereKeyStr.substring(0,whereKeyStr.length-3);	
	//var topDocIds = document.getElementById("topdocids_"+eid).value;
	return whereKeyStr;
}

function onCancel(){
	var dialog = parent.getDialog(window);	
	dialog.close();
}

function checkSubmit(){
	var dialog = parent.getDialog(window);
	parentWin = dialog.currentWindow;
	parentWin.doTabSave('<%=eid %>','<%=ebaseid %>','<%=tabId %>','<%=method %>');
}
  
</script>

