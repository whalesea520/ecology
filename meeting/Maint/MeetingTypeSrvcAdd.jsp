
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo"
	class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo"
	class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight"
	class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
	String dialog = Util.null2String(request.getParameter("dialog"));
	String isclose = Util.null2String(request.getParameter("isclose"));
	String mid = Util.null2String(request.getParameter("mid"));
	String method = Util.null2String(request.getParameter("method"));
	String operate = Util.null2String(request.getParameter("operate"));
	
	String id = Util.null2String(request.getParameter("id"));
	String name = "";
	int hrmid = -1;
	String desc = "";
	if("srvcEdit".equals(operate) ){
		if(!"".equals(id)){
			RecordSet.executeSql("select id, name, meetingtype, hrmid, desc_n from Meeting_Service where id = "+id);
			if(RecordSet.next()){
				mid = Util.null2String(RecordSet.getString("meetingtype"));
				name = Util.null2String(RecordSet.getString("name"));
				desc = Util.null2String(RecordSet.getString("desc_n"));
				hrmid = Util.getIntValue(RecordSet.getString("hrmid"), -1);
			}
		} else {
			dialog = "0";
			isclose = "1";
		}
	} else {
		operate = "srvcAdd";
	}
%>
<html>
	<head>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<LINK href="/js/ecology8/meeting/meetingbase_wev8.css" type=text/css rel=STYLESHEET>
		<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css"
			type="text/css" />
		<link rel="stylesheet"
			href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
		<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css"
			type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	</head>
	<%
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(780, user
				.getLanguage());
		String needfav = "1";
		String needhelp = "";
	%>
	<BODY style="overflow: hidden;">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())
					+ ",javascript:saveData(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
			
			RCMenu += "{" + SystemEnv.getHtmlLabelName(309, user.getLanguage())
					+ ",javascript:btn_cancle(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
			   <td>
				</td>
				<td class="rightSearchSpan" style="text-align:right; ">
					<input type="button"
						value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"
						class="e8_btn_top middle" onclick="saveData()">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
				</td>
			</tr>
		</table>
		<div id="tabDiv" >
			<span id="hoverBtnSpan" class="hoverBtnSpan">
					<span></span>
			</span>
		</div>
		<div class="advancedSearchDiv" id="advancedSearchDiv">
		</div>
		<%
		if ("1".equals(dialog)) {
		%>
		<div class="zDialog_div_content">
		<%
			}
		%>
			<FORM id=weaverA name=weaverA action="MeetingTypeOperation.jsp"
				method="post">
				<input type="hidden" value="false" name="hasChanged"
					id="hasChanged" />
				<input class=inputstyle type="hidden" name="method" id="method"
					value="<%=operate %>" />
				<input type="hidden" value="<%=dialog%>" name="dialog"
					id="dialog" />
				<input type="hidden" value="" name="forwd" id="forwd" />
				<input type="hidden" value="<%=mid %>" name="mid" id="mid" />
				<input type="hidden" value="<%=id %>" name="id" id="id" />
				<wea:layout type="2col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>' >
						<!-- 服务类型 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(2155, user.getLanguage())%></wea:item>
						<wea:item>
							<input name="name" id="name" class="InputStyle" style="width:300px;" onchange='checkinput("name","nameimage")' value="<%=name %>">
							<SPAN id=nameimage>
							<%if("".equals(name)) {%>
							<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
							<%}%>
							</SPAN>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(2156,user.getLanguage())%></wea:item>
						<wea:item>
						<% 
						 	String hrmidspan = "";
						 	if(hrmid > -1){
						 		hrmidspan += "<a href=\'javascript:openhrm(" + hrmid
											+ ")\' onclick=\'pointerXY(event)\'>"
											+ ResourceComInfo.getResourcename("" + hrmid)
											+ "</a>&nbsp";
						 	}
						%>					        
						  <brow:browser viewType="0" name="hrmid" browserValue='<%=(hrmid > 0?(""+hrmid):"")%>' 
						   browserOnClick="" browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"%>'
						   hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='2' width="300px"
						   completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
						   browserSpanValue='<%=ResourceComInfo.getResourcename("" + hrmid)%>'></brow:browser>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(2157,user.getLanguage())%></wea:item>
						<wea:item>
							<span style="height:23;display:inline-block;float:none;"><input id="temp_desc" class="InputStyle" style="width:300px;vertical-align:text-bottom;" value=""><a class="add_btn" href="javascript:void(0);" style="" title="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(2157,user.getLanguage())%>" onclick="addDevice('temp_desc','show_desc','descs',255,'<%=SystemEnv.getHtmlLabelName(2157,user.getLanguage())%>')">&nbsp;+&nbsp;</a></span><br>
							<span>
								<span id="show_desc">
									<%String[] descs=desc.trim().split(",");
										for(int i=0;i<descs.length;i++){
											if(!"".equals(descs[i])){
										%>	 
											<span class="mp_showNameClass" name="descs" val="<%=descs[i] %>">&nbsp;<%=descs[i] %><span class="mp_delClass" onclick="delsp(this,1);">&nbsp;x&nbsp;</span></span>
										<%
										}
									}
								 	%>
								</span>
							</span>
							<input type="hidden" id="desc" name="desc"/>
						</wea:item>
					</wea:group>
				</wea:layout>
			</FORM>
			<%
				if ("1".equals(dialog)) {
			%>
		</div>
		<%
			}
		%>
		<%
			if ("1".equals(dialog)) {
		%>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<wea:layout type="2col">
				<wea:group context="">
					<wea:item type="toolbar">
						<input type="button"
							value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
							id="zd_btn_cancle" class="zd_btn_cancle" onclick="btn_cancle()">
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>
		<%
			}
		%>
	</body>
</html>

<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<script type="text/javascript">
if("<%=dialog%>"=="1"){
	var bodyheight = document.body.offsetHeight;
	var bottomheight = $(".zDialog_div_bottom").css("height");
	if(bottomheight.indexOf("px")>0){
		bottomheight = bottomheight.substring(0,bottomheight.indexOf("px"));
	}
	if(isNaN(bottomheight)){
		bottomheight = 0;
	}
	$(".zDialog_div_content").css("height",bodyheight-bottomheight);
	var dialog = parent.parent.getDialog(window.parent);
	var parentWin = parent.parent.getParentWindow(window.parent);
	function btn_cancle(){
		parentWin.closeDialog();
	}
}

if("<%=isclose%>"=="1"){
	var dialog = parent.parent.getDialog(window.parent);
	var parentWin = parent.parent.getParentWindow(window.parent);
	parentWin.location="/meeting/Maint/MeetingTypeEdit.jsp?id=<%=mid %>&method=service";
	parentWin.closeDlgARfsh();	
}
function setChange(){
	jQuery("hasChanged").value="true";
}

function saveData(){
	
	if (check_form(weaverA, "name,hrmid")) {
		//拼接设备
		var aa=$("span[name='descs']");
		var eq="";
		for(var key=0;key<aa.size();key++){
			eq+=eq==""?$(aa[key]).attr("val"):","+$(aa[key]).attr("val");
		}
		$('#desc').val(eq);
		if($('#desc').val() == ""){
			Dialog.alert('<%=SystemEnv.getHtmlLabelNames("2157,82241",user.getLanguage())%>');
			return;
		}
		$('#weaverA').submit();
	}
}
$(document).ready(function() {
	resizeDialog();
});
</script>
