<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
    String ajax=Util.null2String(request.getParameter("ajax"));
    String isdialog = Util.null2String(request.getParameter("isdialog"));
    String isclose = Util.null2String(request.getParameter("isclose"));
%>
<%

if(!HrmUserVarify.checkUserRight("WorkFlowTitleSet:ALL", user)){
		response.sendRedirect("/notice/noright.jsp");
    		return;
	}

%>
<html>
<%
	String isbill = "";
	int wfid=0;
	int formid=0;
	wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
	String sql="";
	WFManager.reset();
	WFManager.setWfid(wfid);
	WFManager.getWfInfo();
	formid = WFManager.getFormid();
	isbill = WFManager.getIsBill();
    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int subCompanyId= -1;
    int operatelevel=0;

    if(detachable==1){
        if(request.getParameter("subCompanyId")==null){
            subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")),-1);
        }else{
            subCompanyId=Util.getIntValue(request.getParameter("subCompanyId"),-1);
        }
        if(subCompanyId == -1){
            subCompanyId = user.getUserSubCompany1();
        }
        session.setAttribute("managefield_subCompanyId",String.valueOf(subCompanyId));
        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"WorkflowManage:All",subCompanyId);
    }else{
        if(HrmUserVarify.checkUserRight("WorkflowManage:All", user))
            operatelevel=2;
    }
   
   if (isbill.equals("0"))
  	{
   	sql="select workflow_formfield.fieldid, workflow_fieldlable.fieldlable from workflow_formfield,workflow_fieldlable where workflow_formfield.fieldid=workflow_fieldlable.fieldid and workflow_fieldlable.formid=workflow_formfield.formid  and workflow_fieldlable.formid="+formid+" and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and langurageid="+user.getLanguage();
   	//TD8709
   	sql += " order by workflow_formfield.isdetail desc, workflow_formfield.groupid, workflow_formfield.fieldorder";
  	}
 	else
 	{
 	sql="select id,fieldlabel from workflow_billfield where viewtype=0 and billid="+formid;
 	//TD8709
 	sql += " order by viewtype,detailtable,dsporder";
 	}  				
%>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(259,user.getLanguage());
String needfav ="";
String needhelp ="";
%>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<style type="text/css">
#simpleTooltip { padding: 7px; border: 1px solid #A6A7AB!important; background: #F2F3F5!important; }
</style>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>

<body>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
String saveMethodName = "";
if(operatelevel>0){
	if(!ajax.equals("1")){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:selectall(),_self} ";
		saveMethodName = "selectall()";
	}else{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:flowTitleSave2(this),_self} ";
		saveMethodName = "flowTitleSave2(this)";
	}
	RCMenuHeight += RCMenuHeightStep;

    if(!ajax.equals("1")) {
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",addwf.jsp?src=editwf&wfid="+wfid+",_self} " ;
		RCMenuHeight += RCMenuHeightStep;
    }

	if(!ajax.equals("1")){
		if(RecordSet.getDBType().equals("db2")){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)=88 and relatedid="+wfid+",_self} " ;
		}else{
			RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=88 and relatedid="+wfid+",_self} " ;
		}
		RCMenuHeight += RCMenuHeightStep ;
	}
}
%>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(19501,user.getLanguage())%>"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
    			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit" class="e8_btn_top" onclick="<%=saveMethodName%>">
				<span title="鑿滃崟" class="cornerMenu"></span>
			</td>
		</tr>
</table> 
<%if(!ajax.equals("1")){%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%}else{%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%}%>
<form id="flowTitleForm" name="flowTitleForm" method=post action="WorkFlowTitleSetOperation.jsp" >
<%
if(ajax.equals("1")){
%>
<input type="hidden" name="ajax" value="1">
<%}%>

			<%
			String fieldid="";
			RecordSet.execute("select * from workflow_TitleSet where flowid="+wfid +" order by gradation");
			while(RecordSet.next()){
				fieldid += RecordSet.getString("fieldid")+",";  
			}
			%>
			<%if(!ajax.equals("1")){%>
			<table class=ListStyle cellspacing=1  id="oTable" style="width:100%;">
			<%}else{%>
			<table class=ListStyle cellspacing=1  id="oTable4port" style="width:100%;">
			<%}%>
				<tr class=header>
					<td align=center class=field style="width:50%;cursor:default;"><%=SystemEnv.getHtmlLabelName(129513, user.getLanguage())%></td>
					<td align=center class=field style="width:50px;cursor:default;"><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>    
					<td align=center class=field style="width:50%;cursor:default;"><%=SystemEnv.getHtmlLabelName(15448,user.getLanguage())%></td>
				</tr>
				<tr>
					<td vaglin="middle" style="height:270px;">
						<select class=inputstyle  size="15" name="srcList" multiple style="width:100%;height:100%;" onchange="childshowtitle(event)" ondblclick="childaddSrcToDestListTit()">
							<%
							RecordSet.execute(sql);
							while(RecordSet.next()){
								if(fieldid.indexOf(RecordSet.getString(1))==-1){
							%>
							<option class="vtip" title="<%if(isbill.equals("0")){%><%=RecordSet.getString(2)%><%}else{%><%=SystemEnv.getHtmlLabelName(RecordSet.getInt(2),user.getLanguage())%><%}%>" value=<%=RecordSet.getString(1)%>><%if(isbill.equals("0")){%><%=RecordSet.getString(2)%><%}else{%><%=SystemEnv.getHtmlLabelName(RecordSet.getInt(2),user.getLanguage())%><%}%></option>
							<%
							    }
							}
							%>
						</select>
					</td>
					<td align=center style="height:270px;">
						<img class="rightimg" src="/js/dragBox/img/4_wev8.png"  title="<%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%>" onclick="javascript:childaddSrcToDestListTit();">					
						<br><br>
						<img class="leftimg" src="/js/dragBox/img/5_wev8.png" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onClick="javascript:childdeleteFromDestListTit();">					
					</td>
					<td align=center style="height:270px;">
						<select class=inputstyle  size=15 name="destList" multiple style="width:100%;height:100%;" onchange="childshowtitle(event)" ondblclick="childdeleteFromDestListTit()">
						<%
						ArrayList fieldids = Util.TokenizerString(fieldid,",");
						RecordSet.execute(sql);
						if(fieldids!=null && fieldids.size()>0){
							for(int i=0;i<fieldids.size();i++){
								while(RecordSet.next()){
									if(fieldids.get(i).toString().equals(RecordSet.getString(1))){
						%>
										<option class="vtip" title="<%if(isbill.equals("0")){%><%=RecordSet.getString(2)%><%}else{%><%=SystemEnv.getHtmlLabelName(RecordSet.getInt(2),user.getLanguage())%><%}%>" value=<%=RecordSet.getString(1)%>><%if(isbill.equals("0")){%><%=RecordSet.getString(2)%><%}else{%><%=SystemEnv.getHtmlLabelName(RecordSet.getInt(2),user.getLanguage())%><%}%></option>
						<%
									}
								}
								RecordSet.beforFirst();
							}
						}
						%>
						</select>
					 </td>
				</tr> 
			</table>
			<div id="zDialog_div_bottom" class="zDialog_div_bottom">
				<wea:layout needImportDefaultJsAndCss="true">
					<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
						<wea:item type="toolbar">
						    <%
						    if(!ajax.equals("1")){
                            %>
                            <input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit"  class="zd_btn_submit" onclick="javascript:selectall()">
                            <%
							}else{
				            %>
				            <input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit"  class="zd_btn_submit" onclick="javascript:flowTitleSave2(this)">
				            <%
							}
						    %>
				    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="doClose()">
						</wea:item>
					</wea:group>
				</wea:layout>
			</div>		
<br>
<center>
<input type="hidden" value="<%=wfid%>" name="wfid">
<input type="hidden" value="" name="postvalues">
<input type="hidden" value="<%=isdialog %>" name="isdialog">
</center>
</form>


<%if(!ajax.equals("1")){%>
<script language="JavaScript" src="/js/addRowBg_wev8.js" ></script>
<script language=javascript>

function selectall(){
	setPreSpanInner();
	window.document.flowTitleForm.submit();
}

var dialog = parent.getDialog(window);
var parentWin = parent.getParentWindow(window);

function childshowtitle(event){
	parentWin.showtitle(event);
}
function childaddSrcToDestListTit(){
	parentWin.addSrcToDestListTit();
}

function childdeleteFromDestListTit(){
	parentWin.deleteFromDestListTit();
}
</script>
<%}%>
<script language=javascript>
jQuery(document).ready(function(){
	initUDLR();
});

function initUDLR(){
	jQuery(".leftimg").hover(function(){
		jQuery(this).attr("src","/js/dragBox/img/5-h_wev8.png");
	},function(){
		jQuery(this).attr("src","/js/dragBox/img/5_wev8.png");
	});
	
	jQuery(".rightimg").hover(function(){
		jQuery(this).attr("src","/js/dragBox/img/4-h_wev8.png");
	},function(){
		jQuery(this).attr("src","/js/dragBox/img/4_wev8.png");
	});	
}

var dialog = parent.getDialog(window);
var parentWin = parent.getParentWindow(window);

function childshowtitle(event){
	parentWin.showtitle(event);
}
function childaddSrcToDestListTit(){
	addSrcToDestListTit();
}

function childdeleteFromDestListTit(){
	deleteFromDestListTit();
}

function addSrcToDestListTit() {
	destList = window.document.flowTitleForm.destList;
	srcList = window.document.flowTitleForm.srcList;
	txtArray = new Array();
	valArray = new Array();
	var len = destList.length;
	for (var i = srcList.length-1; i > -1; i--) {
		if ((srcList.options[i] != null) && (srcList.options[i].selected)) {
			txtArray.push(srcList.options[i].text);
			valArray.push(srcList.options[i].value);
			srcList.options[i]=null;
		}
	}
	var arrayLength = txtArray.length||valArray.length;
	for(var i=0;i<arrayLength;i++){
		destList.options[len] = new Option(txtArray.pop(),
			valArray.pop());
		len++;
	}
	jQuery(".vtip").simpletooltip("click");
       if($.browser.msie){
   		jQuery(".vtip").attr("title","");
   	}
}
	
function deleteFromDestListTit() {
	var destList = window.document.flowTitleForm.destList;
	var srcList = window.document.flowTitleForm.srcList;
	var len = destList.options.length;
	for ( var i = (len - 1); i >= 0; i--) {
		if ((destList.options[i] != null)
				&& (destList.options[i].selected == true)) {
			srcList.add(new Option(destList.options[i].text,
						destList.options[i].value),srcList.options[0]);
			destList.options[i] = null;
		}
	}
}
function flowTitleSave2(obj) {
	setPreSpanInner();
	var rowindex4op = "";
	var sel = document.flowTitleForm.destList;
	for ( var i = 0; i < sel.options.length; i++) {
		if (sel.options[i] != null) {
			rowindex4op += sel.options[i].value + ",";
		}
	}
	flowTitleForm.postvalues.value = rowindex4op;
	flowTitleForm.submit();
	obj.disabled = true;
}
function doClose(){
	parent.getDialog(window).close();
}

function setPreSpanInner(){
	var destList = window.document.flowTitleForm.destList;
	if(destList.length>0){
		jQuery("#btnMessageSetting",parentWin.document).next().remove();
		jQuery("#btnMessageSetting",parentWin.document).after("<img src=\"/images/ecology8/checkright_wev8.png\" width=\"16\" height=\"17\" border=\"0\">");
    }else{
    	jQuery("#btnMessageSetting",parentWin.document).next().remove();
    }
}

if("<%=isclose%>"==1){
	parentWin.cancelsaveAsWorkflow();
}

</script>
<script language=javascript src="/js/jquery/plugins/tooltip/jquery.tooltip_wev8.js"></script>
<LINK href="/js/jquery/plugins/tooltip/simpletooltip_wev8.css" type=text/css rel=STYLESHEET>
</body>
</html>