<!DOCTYPE html>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubComanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("WorkflowCustomManage:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
} 
%>
<HTML><HEAD>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(20773,user.getLanguage())+SystemEnv.getHtmlLabelName(19653,user.getLanguage());
String needfav ="1";
String needhelp ="";
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
String subcompanyid=Util.null2String(session.getAttribute("customquery_subcompanyid"));
String otype=Util.null2String(session.getAttribute("customquery_otype"));
String otypename = "";
if(!"".equals(otype)){
    RecordSet.executeQuery("select typename from workflow_customQuerytype where id = ?",otype);
    if(RecordSet.next()){
        otypename = RecordSet.getString(1);
    }
}
subcompanyid = (Util.getIntValue(subcompanyid,0)<=0)?"":subcompanyid;
if("".equals(subcompanyid)){
    //系统管理员
    if(user.getUID() == 1 ){
         RecordSet.executeProc("SystemSet_Select","");
         if(RecordSet.next()){
             subcompanyid = RecordSet.getString("wfdftsubcomid");
         }
   }else{
	   String hasRightSub = SubCompanyComInfo.getRightSubCompany(user.getUID(),"WorkflowManage:All",0);
	   if(!"".equals(hasRightSub)){
	       subcompanyid = hasRightSub.split(",")[0];
	   }
   }
}
String Querytypeid=Util.null2String(request.getParameter("Querytypeid"));
Querytypeid = (Util.getIntValue(Querytypeid,0)<=0)?"":Querytypeid;

String dialog = Util.null2String(request.getParameter("dialog"));
String isclose = Util.null2String(request.getParameter("isclose"));
%>
<BODY style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(!"1".equals(dialog)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doback(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<iframe id="workFlowIFrame" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<%if("1".equals(dialog)){ %>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=titlename %>"/>
</jsp:include>
<%}%>
<FORM id=weaver name=frmMain action="CustomOperation.jsp" method=post >
<input type="hidden" name="otype" value="<%=otype%>" />
<%
String name="";
if(!Querytypeid.equals("")){
	RecordSet.executeSql("select * from workflow_customQuerytype where id="+Querytypeid);         	
	while(RecordSet.next()){
		name=RecordSet.getString("typename");
	}
}
%>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" id="zd_btn_submit" class="e8_btn_top" onclick="submitData()">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(32694,user.getLanguage())%>" id="zd_btn_cancle"  class="e8_btn_top" onclick="btn_cancle()">				
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="twoCol">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
    	<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
	    <wea:item>
	    	<wea:required id="Customnameimage" required="true">
	    		<input type=text class=Inputstyle size=30 name="Customname" onchange='checkinput("Customname","Customnameimage")' value="" style="width: 60%">
	    	</wea:required>
	    </wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(716,user.getLanguage())%></wea:item>
    	<wea:item>
			<brow:browser name="Querytypeid" viewType="0" hasBrowser="true" hasAdd="false" 
		             	browserUrl="/systeminfo/BrowserMain.jsp?mouldID=workflow&url=/workflow/workflow/QueryTypeBrowser.jsp" isMustInput="2" isSingle="true" hasInput="true"
		              	completeUrl="/data.jsp?type=queryTypeBrowser"  
		              	linkUrl ="/workflow/workflow/CustomQueryTypeEdit.jsp"
		              	width="60%" browserValue="<%=otype %>" browserSpanValue="<%=otypename %>"/>    		
    	</wea:item>
    	<% if(detachable==1){ %>
    	<wea:item><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
    	<wea:item>
    		<brow:browser name="subcompanyid" viewType="0" hasBrowser="true" hasAdd="false" 
             	browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowCustomManage:All&isedit=1&selectedids=" isMustInput="2" isSingle="true" hasInput="true"
              	completeUrl="/data.jsp?type=164&show_virtual_org=-1"  width="60%" browserValue='<%=subcompanyid%>' browserSpanValue="<%=SubCompanyComInfo.getSubCompanyname(String.valueOf(subcompanyid)) %>"/> 
    	</wea:item>
    	<% } %>
    	<wea:item><%=SystemEnv.getHtmlLabelName(15451,user.getLanguage())%></wea:item>
    	<wea:item>
    		<brow:browser name="formID" viewType="0" hasBrowser="true" hasAdd="false" 
                  browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/FormBillBrowser.jsp" 
                  _callback="showFlowDiv" isMustInput="2" isSingle="true" hasInput="true"
                  completeUrl="/data.jsp?type=wfFormBrowser"  width="60%" browserValue="" browserSpanValue="" />
    		<input type="hidden" id="isBill" name="isBill" value="">
    	</wea:item>
		<wea:item attributes="{'samePair':'workFlowIDDIV','display':'none'}"><%=SystemEnv.getHtmlLabelName(15295,user.getLanguage())%></wea:item> 
		<wea:item attributes="{'samePair':'workFlowIDDIV','display':'none'}">
			<brow:browser name="workflowids" viewType="0" hasBrowser="true" hasAdd="false" 
						getBrowserUrlFn="onShowWorkFlow"
		             	isMustInput="1" isSingle="false" hasInput="true"
		              	completeUrl="javascript:getWfUrl();"  width="60%" browserValue="" browserSpanValue=""/>
		   &nbsp;&nbsp;
		   <span><a href='#'  title="<%=SystemEnv.getHtmlLabelName(23801,user.getLanguage()) %>"><IMG border="0" src="/wechat/images/remind_wev8.png" align=absMiddle ></a></span> 		
		</wea:item> 
		<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>  	
		<wea:item><textarea rows="4" cols="70" name="Customdesc" class=Inputstyle style="resize:none;margin-top: 2px;margin-bottom: 2px;"></textarea></wea:item>  	
    </wea:group>
</wea:layout>

<input type="hidden" name=operation value=customadd>
<input type="hidden" name="dialog" value="<%=dialog%>">
 </form>
<%if("1".equals(dialog)){ %>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<%} %>
<SCRIPT LANGUAGE="javascript">
var dialog = parent.getDialog(window);
var parentWin = parent.getParentWindow(window);
function showFlowDiv(event,datas,name,paras){
	if($("#formIDspan").html()!=""){
		var isBill = datas.isBill;
		if (isBill == null) {
			isBill = datas.isbill;
		}
		$("#isBill").val(isBill);
		showDiv("1");
	}else{
		showDiv("0")
	}
}
function _userDelCallback(text,name){
	if(name=="formID"){
		showDiv("0");
	}
}
function onShowQuerytype(inputName,spanName){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/QueryTypeBrowser.jsp");
	if (datas){
		if (datas.id!=""){
			$(inputName).val(datas.id);
			$(spanName).html(datas.name);			
		}else{
			$(spanName).html( "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			$(inputName).val( "");
		}
	}
}
function onShowSubcompany(inputName,spanName){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowCustomManage:All&isedit=1");
	if (datas){
		if (datas.id!=""){
			$(inputName).val(datas.id);
			$(spanName).html(datas.name);			
		}else{
			$(spanName).html( "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			$(inputName).val( "");
		}
	}
}

function btn_cancle(){
	parentWin.closeDialog();
}

if("<%=isclose%>"==1){
	var dialog = parent.getDialog(window);
	var parentWin = parent.getParentWindow(window);
	parentWin.location="/workflow/workflow/CustomQuerySet.jsp?otype=<%=otype%>";
	parentWin.closeDialog();	
}

function onShowSubcompany(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowCustomManage:All&isedit=1&selectedids="+weaver.subcompanyid.value)
	var issame = false
	if (data){
		if (data.id!="0"){
			if (data.id == weaver.subcompanyid.value){
				issame = true
			}
			subcompanyspan.innerHTML = data.name
			weaver.subcompanyid.value=data.id
		}else{
			subcompanyspan.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			weaver.subcompanyid.value=""
		}
	}
}

function onShowFormOrBill(isBill, inputName, spanName){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/FormBillBrowser.jsp")
	
	if (data){
		if(data.id!=""){
			isBill.value = data.isBill;
			inputName.value = data.id;
			spanName.innerHTML = data.name;
			showDiv("1")
			document.all("workflowids").value = ""
			document.all("workflowIDsSpan").innerHTML = "<font color=red><%=SystemEnv.getHtmlLabelName(23801,user.getLanguage())%></font>"
		}else{
			spanName.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			isBill.value = ""
			inputName.value = ""
			showDiv("0")
		}
	}
}

function onShowWorkFlow(workflowIDHidden, workflowIDSpan){
	var isBill = $G("isBill").value
	var formID = $G("formID").value
	var workflowids = $G("workflowids").value
	var	url = "/systeminfo/BrowserMain.jsp?url=/workflow/report/WorkFlowofFormBrowser.jsp?value=" + isBill + "_" + formID + "_" + workflowids;
	return url;
}


function submitData()
{
	var checkfields = "";
	<% if(detachable==1){ %>
		checkfields = 'Customname,Querytypeid,formID,subcompanyid';
	<%}else{%>
		checkfields = 'Customname,Querytypeid,formID';
	<%}%>
	if (check_form(frmMain,checkfields)){
	   if("<%=dialog%>"!="1"){
	   	 enableAllmenu();
	   }       
        frmMain.submit();
    }
}

function submitIFrame()
{
	document.all("workFlowIFrame").src = "WorkFlowofFormIFrame.jsp?isBill=" + document.all("isBill").value + "&formID=" + document.all("formID").value;
}

function showDiv(isShow)
{
	if("1" == isShow)
	{
		showEle("workFlowIDDIV");
	}
	else
	{
		hideEle("workFlowIDDIV");
	}
}
function doback(){
    enableAllmenu();
    <%if(detachable==1){%>
    location.href="/workflow/workflow/CustomQuerySet.jsp?otype=<%=Querytypeid%>&subcompanyid=<%=subcompanyid%>";
    <%}else{%>
    location.href="/workflow/workflow/CustomQuerySet.jsp?otype=<%=Querytypeid%>";
    <%}%>
}

$("#zd_btn_submit").hover(function(){
	$(this).addClass("zd_btn_submit_hover");
},function(){
	$(this).removeClass("zd_btn_submit_hover");
});

$("#zd_btn_cancle").hover(function(){
	$(this).addClass("zd_btn_cancleHover");
},function(){
	$(this).removeClass("zd_btn_cancleHover");
});

function getWfUrl(){
	var isBill = $("#isBill").val();
	var formID = $("#formID").val();
	var url = "/data.jsp?type=reportform&formid="+formID+"&isbill="+isBill;
	return url;
}
</SCRIPT>

</BODY></HTML>
