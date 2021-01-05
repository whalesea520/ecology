<!DOCTYPE html>
<%@ page import="weaver.general.Util,weaver.workflow.exchange.ExchangeUtil,org.apache.commons.lang3.*" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browser" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="workflowcominfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="exchangeUtil" class="weaver.workflow.exchange.ExchangeUtil" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
</head>
<%
if(!HrmUserVarify.checkUserRight(ExchangeUtil.WFEC_SETTING_RIGHTSTR, user))
{
	response.sendRedirect("/notice/noright.jsp");    	
	return;
}
%>
<%
boolean isedit = true;
boolean isUseWfManageDetach = manageDetachComInfo.isUseWfManageDetach();
int tempsubcomid = -1 ;
if(isUseWfManageDetach){
	rs.executeSql("select wfdftsubcomid from SystemSet");
	rs.next();
	tempsubcomid = Util.getIntValue(rs.getString(1),0);
	rs.executeSql("update wfec_indatawfset set subcompanyid="+tempsubcomid+" where (subcompanyid is null or subcompanyid=0 or subcompanyid='')");
	rs.executeSql("update wfec_outdatawfset set subcompanyid="+tempsubcomid+" where (subcompanyid is null or subcompanyid=0 or subcompanyid='')");
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82487,user.getLanguage());
String needfav ="1";
String needhelp ="";

String shortName = Util.null2String(request.getParameter("shortName"));
String _wfid = Util.null2String(request.getParameter("_wfid"));
String _type = Util.null2String(request.getParameter("_type"));
String _status = Util.null2String(request.getParameter("_status"));
String _datasourceid = Util.null2String(request.getParameter("_datasourceid"));
String workflowid = Util.null2String(request.getParameter("workflowid"));

String wftypeid = Util.null2String(request.getParameter("wftypeid"));
String wfid = Util.null2String(request.getParameter("wfid"));
int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"),0);
int detachable = Util.getIntValue(request.getParameter("detachable"),0);
int operatelevel = -1  ;
if(isUseWfManageDetach){
	detachable = 1 ;
}
ArrayList ids = new ArrayList();
 
if(detachable==1){
	if(request.getParameter("subcompanyid")==null){
		subcompanyid=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")),0);
	}
	if(subcompanyid == -1){
		subcompanyid = user.getUserSubCompany1();
	}
	session.setAttribute("managefield_subCompanyId",String.valueOf(subcompanyid));
	operatelevel = CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),ExchangeUtil.WFEC_SETTING_RIGHTSTR,subcompanyid);
	int[] rightids = CheckSubCompanyRight.getSubComByDecUserRightId(user.getUID(),ExchangeUtil.WFEC_SETTING_RIGHTSTR) ;
	for(int sid :rightids){
		ids.add(sid+"");
	}
}else{
	operatelevel = 2 ;
}
String tempwhere = "wfid="+wfid+"&wftypeid="+wftypeid+"&subcompanyid="+subcompanyid ;

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

if(isedit)
{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javaScript:newDialog(2,0),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javaScript:deltype(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javaScript:onshowlog(0),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<TABLE class=Shadow>
<tr>
<td valign="top">
<form name="frmSearch" id="frmSearch" method="post" action="managelist.jsp">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" class="e8_btn_top" onclick="newDialog(2,0)"/>			
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>" class="e8_btn_top" onclick="deltype()"/>
			<input type="text" class="searchInput" name="flowTitle" value="<%=shortName%>"/>
			&nbsp;&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<!-- bpf start 2013-10-29 -->
<div class="advancedSearchDiv" id="advancedSearchDiv">
<wea:layout type="fourCol">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(20550,user.getLanguage())%>'>
    	<wea:item><%=SystemEnv.getHtmlLabelName(82504,user.getLanguage())%></wea:item>
	    <wea:item><input type="text" name="shortName" class="inputStyle" value='<%=shortName%>'></wea:item>
	    
	    <wea:item><%=SystemEnv.getHtmlLabelName(18077,user.getLanguage())%></wea:item>
	    <wea:item>
 			<brow:browser name="_wfid" viewType="1" 
 					hasBrowser="true" hasAdd="false" 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser_frm.jsp?isTemplate=0&iswfec=1" 
					isMustInput="1" 
					isSingle="true" 
					hasInput="true"
 					completeUrl="/data.jsp?type=workflowBrowser&isTemplate=0" 
 					width="250px" 
					browserValue='<%=_wfid %>' 
 					browserSpanValue='<%=workflowcominfo.getWorkflowname(_wfid) %>' /> 			
	    </wea:item>
	    
	    <wea:item><%=SystemEnv.getHtmlLabelName(82505,user.getLanguage())%></wea:item>
	    <wea:item>
	    	<select name="_type">
				<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				<option value="0" <% if(_type.equals("0")){%> selected <% }%>><%=SystemEnv.getHtmlLabelName(84587,user.getLanguage())%></option>
				<option value="1" <% if(_type.equals("1")){%> selected <% }%>><%=SystemEnv.getHtmlLabelName(84586,user.getLanguage())%></option>
			</select>
	    </wea:item>
	    
	    <wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
	    <wea:item>
	    	<select name="_status">
	    		<option value=''><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
	    		<option value='0'  <% if(_status.equals("0")){%> selected <% }%>><%=SystemEnv.getHtmlLabelName(18096,user.getLanguage())%></option>
	    		<option value='1'  <% if(_status.equals("1")){%> selected <% }%>><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></option>
	    	</select>
	    </wea:item>
	    <wea:item><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%></wea:item>
	    <wea:item>
	    	<select name="_datasourceid">
	    		<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
	    		<%
	    		ArrayList pointArrayList = DataSourceXML.getPointArrayList();
	    		for(int i=0;i<pointArrayList.size();i++){
					    String pointid = (String)pointArrayList.get(i);
					    String isselected = "";
					    if(_datasourceid.equals(pointid)){
					        isselected = "selected";
					    }
				%>
				<option value="<%=pointid%>" <%=isselected %>><%=pointid%></option>
				<%    
				}
				%>
	    	</select>
	    </wea:item>
    </wea:group>
    <wea:group context="">
    	<wea:item type="toolbar">
    		<input class="e8_btn_submit" type="submit" name="submit" value="<%=SystemEnv.getHtmlLabelName(527,user.getLanguage())%>"/>
    		<input class="e8_btn_cancel" type="button" name="reset" onclick="onReset()" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>"/>
    		<input class="e8_btn_cancel" type="button" id="cancel" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout>
</div>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_WORKFLOW_CUSTOMQUERYTYPETAB %>"/>
</form>
<%
String sqlWhere = " where 1=1 ";
if(!"".equals(wftypeid)){
	sqlWhere += " and workflowid in (select id from workflow_base where workflowtype="+wftypeid+")" ;
}

if(!"".equals(shortName)){
	sqlWhere += " and name like '%"+shortName+"%' ";
}
if(!"".equals(_wfid)){
	sqlWhere += " and workflowid ="+_wfid;
}

if(!"".equals(_type)){
	sqlWhere += " and type ="+_type;
}

if(!"".equals(_status)){
	sqlWhere += " and status ="+_status;
}
if(!"".equals(_datasourceid)){
	sqlWhere += " and datasourceid='"+_datasourceid+"' " ;
}
if(!workflowid.equals("")){
	sqlWhere += " and workflowid = "+workflowid ;
}
if(!wfid.equals("")){
	sqlWhere += " and workflowid = "+wfid  ;
}

sqlWhere += ExchangeUtil.getDetachablesqlwhere(detachable,tempsubcomid+"",StringUtils.join(ids,","),subcompanyid,operatelevel);
//只取正常的流程
sqlWhere += " and EXISTS (select 1 from workflow_base WHERE isvalid='1' and id=workflowid )" ;
	
String orderby =" name ";
String tableString = "";                       
String backfields = " id,name,workflowid,datasourceid,subcompanyid,status,type ";
String fromSql  = " wfex_view ";
tableString =   " <table instanceid=\"wfec_tablelist\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_CUSTOMQUERYTYPETAB,user.getUID())+"\" >"+
				" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod=\"weaver.workflow.exchange.ExchangeUtil.getCanDele\" />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"asc\" sqlisdistinct=\"false\" />"+
                "       <head>"+
                "           <col width=\"1%\"  text=\"\" column=\"type\" hide=\"true\" />"+
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(82504,user.getLanguage())+"\" column=\"name\" otherpara=\"column:id+"+isedit+"+column:type\" orderkey=\"name\" transmethod=\"weaver.workflow.exchange.ExchangeUtil.getNameLink\"/>"+
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(18077,user.getLanguage())+"\" column=\"workflowid\" orderkey=\"workflowid\" transmethod=\"weaver.workflow.exchange.ExchangeUtil.getWorkflowname\" />";
               if(detachable==1){
            	   tableString += "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(17868,user.getLanguage())+"\" column=\"subcompanyid\" orderkey=\"subcompanyid\" transmethod=\"weaver.hrm.company.SubCompanyComInfo.getSubCompanyname\" />";
               }
 tableString += "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(82505,user.getLanguage())+"\" column=\"type\" otherpara=\""+user.getLanguage()+"\" orderkey=\"type\" transmethod=\"weaver.workflow.exchange.ExchangeUtil.getTypeName\" />"+
                "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(18076,user.getLanguage())+"\" column=\"datasourceid\" orderkey=\"datasourceid\" />"+
                "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"status\" otherpara=\""+user.getLanguage()+"\" orderkey=\"status\" transmethod=\"weaver.workflow.exchange.ExchangeUtil.getStatusName\" />"+
                "       </head>"+
                "		<operates>"+
                "		<popedom column=\"id\" otherpara=\"column:type\" transmethod=\"weaver.workflow.exchange.ExchangeUtil.getCanDeleList\"></popedom> "+
                "		<operate href=\"javascript:onenable(1);\" text=\""+SystemEnv.getHtmlLabelName(18095,user.getLanguage())+"\" otherpara=\"column:type\" linkvaluecolumn=\"id\" linkkey=\"id\" target=\"_self\" index=\"0\"/>"+
                "		<operate href=\"javascript:onforbidden(0);\" text=\""+SystemEnv.getHtmlLabelName(18096,user.getLanguage())+"\" otherpara=\"column:type\" linkvaluecolumn=\"id\" linkkey=\"id\" target=\"_self\" index=\"1\"/>"+
				"		<operate href=\"javascript:showpage(1);\" text=\""+SystemEnv.getHtmlLabelName(82506,user.getLanguage())+"\" otherpara=\"column:type\" target=\"_self\" index=\"2\"/>"+
				"		<operate href=\"javascript:onEditForwfDoc();\" text=\""+SystemEnv.getHtmlLabelName(21954,user.getLanguage())+"\" otherpara=\"column:workflowid\" target=\"_self\" index=\"3\"/>"+
				"		<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" otherpara=\"column:type\" target=\"_self\" index=\"4\"/>"+
				"		<operate href=\"javascript:onshowlog();\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" otherpara=\"column:type\" target=\"_self\" index=\"5\"/>"+
				"		</operates>"+  
                " </table>";
%>

<TABLE width="100%" cellspacing=0>
    <tr>
        <td valign="top">  
            <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
        </td>
    </tr>
</TABLE>
</td>
</tr>
</TABLE>
<script type="text/javascript">
    function doSubmit(){
        enableAllmenu();
        document.frmSearch.submit();
    }
    function donewQueryType(){
        enableAllmenu();
        location.href="/workflow/exchange/ExchangeSetAdd.jsp?temp="+Math.random()+"&<%=tempwhere %>";        
    }
</script>

</BODY>
<script type="text/javascript">
var diag_vote;
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();	
	//parent.document.getElementById("tabcontentframe").contentWindow.location.href ;
});
function newDialog(type,id,changetype){
	var title = "";
	var url = "";
	if(type==1){
		title = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(82506,user.getLanguage())%>";
		url="/workflow/exchange/ExchangeSetEdit.jsp?dialog=1&changetype="+changetype+"&id="+id+"&<%=tempwhere %>";
	}else{
		title = "<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(82659,user.getLanguage())%>";
		url="/workflow/exchange/ExchangeSetAdd.jsp?dialog=1&isUseWfManageDetach=<%=isUseWfManageDetach%>&<%=tempwhere %>";
	}
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 600;
	diag_vote.Height = 300;
	diag_vote.Modal = true;
	diag_vote.Title = title;
	diag_vote.URL = url;
	diag_vote.isIframe=false;
	diag_vote.show();
}

function showpage(idx,id,type){
	var title = "";
	var url = "";
	title = "<%=SystemEnv.getHtmlLabelName(84606,user.getLanguage())%>";
	if(type==0){
		url="/workflow/exchange/ExchangeSetTab.jsp?dialog=1&mainid="+id+"&<%=tempwhere %>";
	}else{
		url="/workflow/exchange/ExchangeSetTab1.jsp?dialog=1&mainid="+id+"&<%=tempwhere %>";
	}
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Modal = true;
	diag_vote.Title = title;
	
	diag_vote.Width = jQuery(top.window).width()-330;
	diag_vote.Height = jQuery(top.window).height()-330;
	diag_vote.maxiumnable = true;
	diag_vote.URL = url;
	diag_vote.show();
}

function closeDialog(){
	diag_vote.close();
}

 function deltype(){
	var typeids = "";
	var type = "";
	$("input[name='chkInTableTag']").each(function(){
	if($(this).attr("checked"))	{
			type = $(this).parent().parent().next(0).html();//attr("title") ;		
			typeids += $(this).attr("checkboxId")+"."+type+",";
		}
	});
	if(typeids=="") {
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24244,user.getLanguage())%>");
		return ;
	}
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
						window.location="/workflow/exchange/ExchangeSetOperation.jsp?operation=deletes&typeids="+typeids+"&<%=tempwhere %>";
				}, function () {}, 320, 90,true);
}

function onDel(id,type){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
			window.location="/workflow/exchange/ExchangeSetOperation.jsp?operation=delete&type="+type+"&id="+id+"&<%=tempwhere %>";
	}, function () {}, 320, 90,true);
}

function onenable(status,id,type){
	onstatus(id,status,type) ;
}
function onforbidden(status,id,type){
	onstatus(id,status,type) ;
}
function onstatus(id,status,type){
	var msg = ""
	if(status==1){
		msg = "<%=SystemEnv.getHtmlLabelName(26545,user.getLanguage())%>";
	}else{
		msg = "<%=SystemEnv.getHtmlLabelName(32690,user.getLanguage())%>";
	}
	top.Dialog.confirm(msg, function (){
			window.location="/workflow/exchange/ExchangeSetOperation.jsp?operation=changestatus&status="+status+"&type="+type+"&id="+id+"&<%=tempwhere %>";
	}, function () {}, 320, 90,true);
}

function onBtnSearchClick(){
	var typename=$("input[name='flowTitle']",parent.document).val();
		try{
		typename = encodeURI(typename);
	}catch(e){
		if(window.console)console.log(e)
	 }
	$("input[name='shortName']").val(typename);
	window.location="/workflow/exchange/managelist.jsp?shortName="+typename;
}

function onReset() {
	jQuery('input[name="flowTitle"]', parent.document).val('');
	jQuery('input[name="shortName"]').val('');
}

function onEditForwfDoc(id,wfid){
	if(!wfid){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(84675,user.getLanguage())%>");
		return;
	}
	dialog = new top.Dialog();
	dialog.currentWindow = window; 
	var url = "/workflow/workflow/addwf.jsp?wfid="+wfid+"&src=editwf&iscreate=0";
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("21954",user.getLanguage())%>";
	dialog.Width = jQuery(top.window).width()-330;
	dialog.Height = jQuery(top.window).height()-330;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}

function onshowlog(id,type){
	dialog = new top.Dialog();
	dialog.currentWindow = window;
	var url = '' ;
	if(type=='0'){
		url = "/systeminfo/SysMaintenanceLog.jsp?_fromURL=&wflog=1&isdialog=1&sqlwhere=<%=xssUtil.put("where operateitem=199 and relatedid=")%>&relatedid="+id;
	}else{
		url = "/systeminfo/SysMaintenanceLog.jsp?_fromURL=&wflog=1&isdialog=1&sqlwhere=<%=xssUtil.put("where operateitem=200 and relatedid=")%>&relatedid="+id;
	}
	if(id==0){
		url = "/systeminfo/SysMaintenanceLog.jsp?_fromURL=&wflog=1&isdialog=1&sqlwhere=<%=xssUtil.put("where operateitem in (199,200)  ")%>&temp=";
	}
	
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(31709,user.getLanguage()) %>";
	dialog.Width = jQuery(top.window).width()-100;
	dialog.Height = jQuery(top.window).height()-100;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}
function onReset() {
		try{
			jQuery('#frmSearch .e8_os input[type="hidden"]').each(function() {
				cleanBrowserValue(jQuery(this).attr('name'));
			});
			jQuery('#frmSearch input:text').val('');
			jQuery('#frmSearch select').each(function() {
				setSelectBoxValue(this);
			});
		}catch(e){
		}
}
function setSelectBoxValue(selector, value) {
		if (value == null) {
			value = jQuery(selector).find('option').first().val();
		}
		jQuery(selector).selectbox('change',value,jQuery(selector).find('option[value="'+value+'"]').text());
}

function cleanBrowserValue(name) {
	_writeBackData(name, 1, {id:'',name:''});
}
</script>
</HTML>
