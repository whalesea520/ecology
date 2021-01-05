
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
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
	boolean canedit = false;

	//String mid = Util.null2String(request.getParameter("mid"));
	//String from = Util.null2String(request.getParameter("from"));
	String dialog = Util.null2String(request.getParameter("dialog"));
	String isclose = Util.null2String(request.getParameter("isclose"));
	int detachable = Util.getIntValue(String.valueOf(session
			.getAttribute("meetingdetachable")), 0);
	int subcompanyid = -1;
	//分权模式下参数传过来的选中的分部
	int subid = Util.getIntValue(request.getParameter("subCompanyId"));
	if (subid < 0) {
		subid = user.getUserSubCompany1();
	}
	int operatelevel = CheckSubCompanyRight
			.ChkComRightByUserRightCompanyId(user.getUID(),
					"MeetingType:Maintenance", subid);
	if (detachable == 1) {
		if (subid != 0 && operatelevel < 1) {
			subid=0;
		} else {
			subcompanyid = subid;
		}
	} else {
		subcompanyid = subid;
	}
	if (HrmUserVarify.checkUserRight("MeetingType:Maintenance", user)) {
		canedit = true;
	}
//out.print("subcompanyid:"+subcompanyid);
	if (!canedit) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	
	String formids="85";
	RecordSet.execute("select DISTINCT billid from meeting_bill where billid<>85");
	while(RecordSet.next()){
		String billid=RecordSet.getString("billid");
		if(!"".equals(billid)){
			formids+=","+billid;
		}
	}
	String browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere="+xssUtil.put(" where isbill=1 and formid in("+formids+")");
	String completeUrl="/data.jsp?type=-99991&whereClause="+xssUtil.put(" isbill=1 and formid in("+formids+") and isvalid=1 ");
%>
<html>
	<head>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css"
			type="text/css" />
		<link rel="stylesheet"
			href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
		<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css"
			type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<style>
		    .add_btn{
		        background: url("/wui/theme/ecology8/skins/default/general/browserAdd_wev8.png");
		        float:left;
		        cursor: pointer;
		        width:16px;
		        height:17px;
		        margin-left:5px;
		        margin-top:3px;
		    }
		    .add_btn:hover{
		        background: url("/wui/theme/ecology8/skins/default/general/browserAdd_hover_wev8.png");
		    }
		</style>
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
			
			RCMenu += "{"+SystemEnv.getHtmlLabelName(32159, user.getLanguage())+",javascript:submitData(),_self} ";
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
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159, user.getLanguage())%>"
						 class="e8_btn_top middle"
						onclick="submitData()">
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
					value="add" />
				<input type="hidden" value="<%=dialog%>" name="dialog"
					id="dialog" />
				<input type="hidden" value="" name="forwd" id="forwd" />
				<INPUT class=inputstyle id=subid type=hidden name=subid
					value="<%=subid%>" />
				<wea:layout type="2col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>' >
						<wea:item><%=SystemEnv.getHtmlLabelName(2104,user.getLanguage())%></wea:item>
						<wea:item>
						       <input id=name name=name class="InputStyle" style="width:300px;" value="" onblur="onblurCheckName()" onchange='checkinput("name","nameimage")'><SPAN id=nameimage><IMG src="/images/BacoError_wev8.gif" align="absMiddle"></SPAN><SPAN id=checknameinfo style='color:red'>&nbsp;</SPAN>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
						<wea:item>
							<%
							if (detachable == 1) {
							%>
							<brow:browser viewType="0" name="subCompanyId" browserValue='<%=(subcompanyid > 0?(""+subcompanyid):"")%>'
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser4.jsp?rightStr=MeetingType:Maintenance" 
							hasInput="false"  isSingle="true" hasBrowser = "true" isMustInput='2'  width="300px"
							completeUrl="/data.jsp?type=164" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
							browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname("" + subcompanyid)%>'></brow:browser>
							<%
							} else {
							%>
							
							<brow:browser viewType="0" name="subCompanyId" browserValue='<%=(subcompanyid > 0?(""+subcompanyid):"")%>' 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?show_virtual_org=-1&selectedids=" 
							hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='2'  width="300px"
							completeUrl="/data.jsp?type=164&show_virtual_org=-1" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
							browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname("" + subcompanyid)%>'></brow:browser>
							<%
							}
							%>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(15057,user.getLanguage())%></wea:item>
						<wea:item>
						<brow:browser viewType="0" name="approver" browserValue="" 
						browserOnClick="" browserUrl='<%=browserUrl %>'
						hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  width="300px"
						completeUrl='<%=completeUrl %>' linkUrl="/workflow/workflow/addwf.jsp?src=editwf&isTemplate=0&wfid=#id#&id=#id#" 
						browserSpanValue=""></brow:browser>
						<div class="add_btn" onclick="addwf('<%=SystemEnv.getHtmlLabelNames("611,15057",user.getLanguage())%>')"  title='<%=SystemEnv.getHtmlLabelNames("611,15057",user.getLanguage())%>' ></div>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(82441,user.getLanguage())%></wea:item>
						<wea:item>
						<brow:browser viewType="0" name="approver1" browserValue="" 
						browserOnClick="" browserUrl='<%=browserUrl %>' 
						hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  width="300px"
						completeUrl='<%=completeUrl %>' linkUrl="/workflow/workflow/addwf.jsp?src=editwf&isTemplate=0&wfid=#id#&id=#id#" 
						browserSpanValue=""></brow:browser>
						<div class="add_btn" onclick="addwf('<%=SystemEnv.getHtmlLabelNames("611,82441",user.getLanguage())%>')"  title='<%=SystemEnv.getHtmlLabelNames("611,82441",user.getLanguage())%>' ></div>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(92,user.getLanguage())%></wea:item>
						<wea:item>
						         	<brow:browser viewType="0" name="catalogpath" browserValue="" 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp"
							hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1' width="300px"  _callback="showCalaogCallBk" _callbackParams="0"
							completeUrl="/data.jsp?type=categoryBrowser" linkUrl="#" 
							browserSpanValue=""></brow:browser>
						</wea:item>
						<!-- 显示顺序 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(15513, user.getLanguage())%></wea:item>
						<wea:item>
							<input class="InputStyle"  type="text" size="10"
								maxlength=6 id='dsporder' name="dsporder" value="1"
								onKeyPress="ItemNum_KeyPress(this.name)"
								onchange="setChange()"
								onblur="checknumber('dsporder');checkDigit('dsporder',4,1)"
								style="text-align: right;width:80px;" />
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
var dlg;
if(window.top.Dialog){
	dlg = window.top.Dialog;
} else {
    dlg = Dialog;
}
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
		//parentWin.closeDialog();
		dialog.closeByHand();
	}
}

if("<%=isclose%>"=="1"){
	var dialog = parent.parent.getDialog(window.parent);
	var parentWin = parent.parent.getParentWindow(window.parent);
	parentWin.location="/meeting/Maint/MeetingType_left.jsp?subCompanyId=<%=subid%>";
	parentWin.closeDlgARfsh();
	
}
function setChange(){
	jQuery("hasChanged").value="true";
}
function onblurCheckName() {
	var tname = $("#name").val();
	if(tname==null ||tname=="" || tname == "NULL" || tname == "Null" || tname == "null"){
		$("#checknameinfo").hide();
		return;
	}
	$.post("/meeting/Maint/MeetingTypeCheck.jsp",{tname:encodeURIComponent(tname)},function(datas){ 							 
		if (datas.indexOf("exist") > 0){
			$("#checknameinfo").show();						 	
			$("#checknameinfo").text("<%=SystemEnv.getHtmlLabelName(2104,user.getLanguage())%> [ "+tname+" ] <%=SystemEnv.getHtmlLabelName(24943,user.getLanguage())%>");
		} else { 
			$("#checknameinfo").hide();
		}
	});
		
}
var issubmit=false;
function doSave(){
	if(!check_form(weaverA,'name,subCompanyId')){
		return;
	}

	var tname = $("#name").val();
	if(tname==null ||tname=="" || tname == "NULL" || tname == "Null" || tname == "null"){
		$("#checknameinfo").hide();
		check_form(weaverA,"name");
		return;
	}
	if(!issubmit){
	issubmit=true;	
	$.post("/meeting/Maint/MeetingTypeCheck.jsp",{tname:encodeURIComponent(tname)},function(datas){ 							 
		if (datas.indexOf("exist") > 0){
			dlg.alert("<%=SystemEnv.getHtmlLabelName(2104,user.getLanguage())%> [ "+tname+" ] <%=SystemEnv.getHtmlLabelName(24943,user.getLanguage())%>!") ;
			issubmit=false;
		} else {
			$('#weaverA').submit();		
		}
	});
	}
}
function submitData(){
	$('#forwd').val("edit");
	doSave();
}
function saveData(){
	$('#forwd').val("add");
	doSave();
}
function addwf(title){
    var parentWin = parent.parent.getParentWindow(window.parent);
    var w= parentWin.document.body.offsetWidth-50;
    var h= parentWin.document.body.offsetHeight-50
    if(window.top.Dialog){
        dlg = new window.top.Dialog();
    } else {
        dlg = new Dialog();
    };
    dlg.currentWindow = window;
    dlg.Width = w;
    dlg.Height = h;
    dlg.Modal = true;
    dlg.Title = title;
    dlg.URL = "/workflow/workflow/addwf.jsp?isTemplate=0&iscreat=1&&isdialog=1";
    dlg.show();
}
</script>
