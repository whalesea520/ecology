
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page import="java.util.*" %>
<%@ page import="weaver.system.code.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="wfComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("projTemplateSetting:Maint", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<%
    String nameQuery = Util.null2String(request.getParameter("nameQuery"));
    String typedesc = Util.null2String(request.getParameter("typedesc"));
%>
<HTML><HEAD>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
</HEAD>
<%
int chkNeedAppr=0;
String wfid = "";
rs.executeSql("SELECT * FROM ProjTemplateMaint WHERE id=1");
if (rs.next()){
 chkNeedAppr=Util.getIntValue(rs.getString("isNeedAppr"),0);
	wfid =Util.null2String( rs.getInt("wfid")>0?""+rs.getInt("wfid"):"");
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
String sqlwhere = xssUtil.put("isbill=1 and (formid=152 or formid in(select formid from prj_prjwfconf where isopen='1' and wftype=3))");
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;  

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name="frmAdd" id="frmAdd" method="post" action="TempletSettingOperation.jsp">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("86",user.getLanguage())%>" class="e8_btn_top"  onclick="doSave(this)"/>
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>		
		<!-- bpf start 2013-10-29 -->
		<div class="advancedSearchDiv" id="advancedSearchDiv" >
		</div>
	




<input type="hidden" name="method" value="add">  
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'groupDisplay':''}" >
		<wea:item><%=SystemEnv.getHtmlLabelName(31449,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" name="chkNeedAppr" id="chkNeedAppr" class="inputStyle" tzCheckbox="true" value="1" <%if(chkNeedAppr==1) out.println("checked");%> onclick="checkWorkFlow()">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15058,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0"  width="200px" name="relatingFlow" browserValue='<%=wfid %>' browserSpanValue='<%=wfComInfo.getWorkflowname(""+wfid) %>'
						browserUrl=''
					  	getBrowserUrlFn='getWfBrowserUrl'
						hasInput="true" isSingle="true" hasBrowser ="true" isMustInput='1'
						completeUrl="/data.jsp?type=workflowBrowser&from=prjwf&sqlwhere=<%sqlwhere %>"
						_callback="checkWorkFlow" afterDelCallback="checkWorkFlow"/>
			<span class="e8_browserSpan"><button class="e8_browserAdd" title="<%=SystemEnv.getHtmlLabelNames("125",user.getLanguage())%>" id="wfid_addbtn" type="button" onclick="onCreateWf();"></button></span>
		</wea:item>
	</wea:group>
	
	
</wea:layout>

</form>

<SCRIPT LANGUAGE="JavaScript">
<!--
var oWF,oWFID,o;
window.onload = function(){
	o = document.getElementById("chkNeedAppr");
	oWFID = document.getElementById("relatingFlow");
	oWF = document.getElementById("relatingFlowspanimg");
	checkWorkFlow();
};
function getWfBrowserUrl(data){
	
	return "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere=<%=xssUtil.put("where isbill=1 and (formid=152 or formid in(select formid from prj_prjwfconf where isopen='1' and wftype=3))") %>";
}
function doSave(obj){
	if(o.checked && (oWFID.value=="" || oWFID.value=="-1" || oWFID.value=="0")){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
		checkWorkFlow();
		return false;
	}else{
		//obj.disabled=true;
		//frmAdd.submit();
		var form=jQuery("#frmAdd");
		var form_data=form.serialize();
		var form_url=form.attr("action");
		jQuery.ajax({
			url : form_url,
			type : "post",
			async : true,
			data : form_data,
			dataType : "html",
			contentType: "application/x-www-form-urlencoded; charset=utf-8", 
			success: function do4Success(msg){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83551",user.getLanguage())%>");
			}
		});
	}
}
function checkWorkFlow(){
	if(o.checked && (oWFID.value=="" || oWFID.value=="-1" || oWFID.value=="0")){	
		oWF.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	}
	if(!o.checked && (oWFID.value=="" || oWFID.value=="-1" || oWFID.value=="0")){
		oWF.innerHTML = "";
	}
}
function onBtnSearchClick(){
	var typename=$("input[name='flowTitle']",parent.document).val();
	$("input[name='typename']").val(typename);
	frmSearch.submit();
}
function onCreateWf() {
    try{
    	var url="/workflow/workflow/addwf.jsp?isTemplate=0&isdialog=1&ajax=1&from=prjwf";
    	var formid=0;
    	if(formid!=""){
    		url+="&prjwfformid="+formid;
    	}
    	var inputid="relatingFlow";
		showModalDialogForBrowser(event,
				url, '#', inputid, true, 2, '', 
				{name:inputid,hasInput:false,zDialog:true,needHidden:false,dialogTitle:'',arguments:'',_callback:onCreateWf_callback
				,dialogWidth:"800px",dialogHeight:"600px",maxiumnable:true
				}
			);
	}catch(ex1){
		alert(ex1);
	}
}
function onCreateWf_callback(p1,datas,fieldname,p4,p5){
	if (datas&&fieldname) {
		if(datas.id!=""){
			
		}else{
			
		}
    }
}
//-->
</SCRIPT>

</BODY>
</HTML>
