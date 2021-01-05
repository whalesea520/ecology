<%@page import="com.weaver.formmodel.data.model.Forminfo"%>
<%@page import="weaver.proj.util.PrjWfConfComInfo"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ProjectTransUtil" class="weaver.proj.util.ProjectTransUtil" scope="page" />
<jsp:useBean id="PrjWfConfComInfo" class="weaver.proj.util.PrjWfConfComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
String rightStr="Cpt:CusWfConfig";
if(!HrmUserVarify.checkUserRight(rightStr,user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String id = Util.null2String(request.getParameter("id"));
String wfid = "";
String formid="";
String formname="";
String wftype= "";
String isopen="1";
boolean isEdit=false;
if (Util.getIntValue(id) > 0) {
	RecordSet.executeSql("select * from uf4mode_cptwfconf where id="+id);
	if(RecordSet.next()){
		wfid = RecordSet.getString("wfid");
		wftype = RecordSet.getString("wftype");
		isopen = RecordSet.getString("isopen");
		isEdit = true;
	}

}
//不能选的wf
String notwfid="";
RecordSet.executeSql("select wfid from uf4mode_cptwfconf  ");
while(RecordSet.next()){
	String nowid=Util.null2String( RecordSet.getString("wfid"));
	if(!nowid.equals(wfid)){
		notwfid+=","+RecordSet.getString("wfid");
	}

}
String titlelabel="81726";
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));


%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
<script type="text/javascript">
var parentWin;
if("<%=isDialog %>"=="1"){
	parentWin = parent.getParentWindow(window);
}
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(2),_top} " ;
RCMenuHeight += RCMenuHeightStep;
if(!isEdit){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(32159,user.getLanguage())+",javascript:submitData(1),_top} " ;
	RCMenuHeight += RCMenuHeightStep;
}

%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
if(!isEdit){
%>	
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="proj"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelNames(titlelabel,user.getLanguage()) %>"/>
</jsp:include>
<%
}
%>

<FORM id=weaver action="/formmode/cuspage/cpt/conf/cptwfop2.jsp" method=post>
<input type="hidden" name="method" value="<%=isEdit?"edit":"add" %>" />
<input type="hidden" name="id" value="<%=id %>" />

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="submitData(2);">
<%
if(!isEdit){
	%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage())%>" class="e8_btn_top" onclick="submitData(1);">
	<%
}
%>			
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

  
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>' attributes="" >
		<wea:item><%=SystemEnv.getHtmlLabelName(18104,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="wfid" width="235px"
				browserValue='<%=""+wfid %>' 
				browserSpanValue='<%=WorkflowComInfo.getWorkflowname(wfid) %>'
				browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere= where isbill=1"
				getBrowserUrlFn="getWfBrowserUrl"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
				completeUrl="javascript:getWfCompleteUrl()" 
				_callback="getWfBrowserUrl_callback" />
<%
if(!isEdit){
	%>
			<span class="e8_browserSpan"><button class="e8_browserAdd" title="<%=SystemEnv.getHtmlLabelNames("125",user.getLanguage())%>" id="wfid_addbtn" type="button" onclick="onCreateWf();"></button></span>	
	<%
}
%>				
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(26329,user.getLanguage())%></wea:item>
		<wea:item>
			<select name="wftype" id="wftype">
				<option value="apply" <%="apply".equalsIgnoreCase(wftype)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(84362,user.getLanguage())%></option>
				<option value="fetch" <%="fetch".equalsIgnoreCase(wftype)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(886,user.getLanguage())%></option>
				<option value="move" <%="move".equalsIgnoreCase(wftype)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(883,user.getLanguage())%></option>
				<option value="lend" <%="lend".equalsIgnoreCase(wftype)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(6051,user.getLanguage())%></option>
				<option value="loss" <%="loss".equalsIgnoreCase(wftype)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(6054,user.getLanguage())%></option>
				<option value="discard" <%="discard".equalsIgnoreCase(wftype)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(6052,user.getLanguage())%></option>
				<option value="back" <%="back".equalsIgnoreCase(wftype)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(15305,user.getLanguage())%></option>
				<option value="mend" <%="mend".equalsIgnoreCase(wftype)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(22459,user.getLanguage())%></option>
			</select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(18624,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox"  tzCheckbox="true" <%="1".equals(isopen)?"checked":"" %> name="isopen" value="1" />
		</wea:item>
	</wea:group>
</wea:layout>	
	
			<!-- 对话框底下的按钮 -->
<%if("1".equals(isDialog)){ %>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>	
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentWin.closeDialog();"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout>
</div>
<script type="text/javascript">
jQuery(document).ready(function(){
	resizeDialog(document);
});
</script>
<%} %>  

</FORM>
<script language="javascript">
function submitData(type)
{
	var wftype='<%=wftype %>';
	var checkstr="wftype,wfid";
	if (check_form(weaver,checkstr)){
		//weaver.submit();
		var form=jQuery("#weaver");
		var form_data=form.serialize();
		var form_url=form.attr("action");
		var wfid=jQuery("input[name=wfid]").val();
		jQuery.ajax({
			url : form_url,
			type : "post",
			async : true,
			data : form_data,
			dataType : "json",
			contentType: "application/x-www-form-urlencoded; charset=utf-8",
			success: function do4Success(msg){
				if(<%=isEdit %>){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83551",user.getLanguage())%>");
					parent.parentWin._table.reLoad();
				}else{
					parentWin._table.reLoad();
					if(type==1&&msg.newid){
						onDetailEdit(msg.newid);
					}
					parentWin.closeDialog();
				}


			}
		});

	}
}

function onDetailEdit(id){
	var url="/formmode/cuspage/cpt/conf/cptwfedittab.jsp?isdialog=1&id="+id;
	var title="<%=SystemEnv.getHtmlLabelNames("83754",user.getLanguage())%>";
	openDialog(url,title,800,600,false,true);
}

function getWfBrowserUrl(data){
	var notwfid="-1<%=notwfid %>";
	var sqlwhere="where isbill=1 and formid<0 and exists ( select 1 from workflow_billfield t2 where t2.billid=workflow_base.formid  and workflow_base.id not in("+notwfid+") and formid not in(14,18,19,201,220,221,222,224) )";
	return "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere="+sqlwhere;
}
function getWfBrowserUrl_callback(event,datas,name,_callbackParams){
//	var newurl=window.location.href.replace("&wfid","&nouse");
//	window.location.href=newurl+"&wfid="+datas.id;
}
function getWfCompleteUrl(data){
	var notwfid="-1<%=notwfid %>";
	var sqlwhere=" isbill=1 and formid<0 and exists ( select 1 from workflow_billfield t2 where t2.billid=workflow_base.formid  and workflow_base.id not in("+notwfid+") and formid not in(14,18,19,201,220,221,222,224) )";
	return "/data.jsp?type=workflowBrowser&from=prjwf&sqlwhere="+sqlwhere;
}
function getFormBrowserUrl(data){
	var sqlwhere=" 1=1 ";
	var wfid=$("#wfid").val();
	if(wfid!=""){
		sqlwhere+=" and exists(select 1 from workflow_base where workflow_base.formid=WorkFlow_Bill.id and workflow_base.id="+wfid+") ";
	}
	return "/systeminfo/BrowserMain.jsp?url=/workflow/FormBillBrowser.jsp?from=prjwf&isbill=1&sqlwhere="+sqlwhere;
}
function getFormBrowserUrl_callback(event,datas,name,_callbackParams){
	//console.log("id:"+datas.id+",name:"+datas.name);
}
function getFormCompleteUrl(data){
	var sqlwhere="1=1 ";
	var wfid=$("#wfid").val();
	if(wfid!=""){
		sqlwhere+=" and exists(select 1 from workflow_base where workflow_base.formid=WorkFlow_Bill.id and workflow_base.id="+wfid+") ";
	}
	return "/data.jsp?type=wfFormBrowser&from=prjwf&isbill=1&sqlwhere="+sqlwhere;
}

function onCreateWf() {
    try{
    	var url="/workflow/workflow/addwf.jsp?isTemplate=0&isdialog=1&ajax=1&from=prjwf";
    	var formid=$("#formid").val();
    	if(formid!=""){
    		url+="&prjwfformid="+formid;
    	}
    	var inputid="wfid";
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
function genformcheck(){
	var prjtype=$("#prjtype").val();
	if(prjtype==""){
		window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83765",user.getLanguage())%>',function(){
			genform("-1");
		});
	}else{
		genform(prjtype);
	}
}
function genform(prjtype){
	var prjtype=$("#prjtype").val();
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Width = 330;
	dialog.Height = 88;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("83775",user.getLanguage())%>";
	dialog.URL ="/proj/conf/prjwfgenform.jsp?isdialog=0";
	dialog.OKEvent = function(){
		var formname= dialog.innerFrame.contentWindow.document.getElementById('assortmentname').value;
		if(formname==""){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage()) %>");
			return;
		}else{
			jQuery.ajax({
				url : "/proj/conf/prjwfop.jsp",
				type : "post",
				async : true,
				data : {"method":"genform","wftype":"<%=wftype %>","prjtype":prjtype,"formname":formname},
				dataType : "json",
				contentType: "application/x-www-form-urlencoded;charset=utf-8",
				success: function do4Success(data){
					if(data.errmsg){
						window.top.Dialog.alert(data.errmsg);
					}else if(data.newformid){
						var newurl=window.location.href.replace("&formid","&nouse").replace("&wfid", "&nouse").replace("&prjtype", "&nouse");
						window.location.href=newurl+"&formid="+data.newformid+"&wfid=&prjtype="+$("#prjtype").val();
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83442",user.getLanguage())%>");
						dialog.close();
					}else{
						dialog.close();
					}
					
				}
			});	
		}
		
	};
	dialog.show();
}
</script>
</BODY>
</HTML>
