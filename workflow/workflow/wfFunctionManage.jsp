<!DOCTYPE html>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@page import="weaver.workflow.workflow.UserWFOperateLevel"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="BillComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="FormFieldMainManager" class="weaver.workflow.form.FormFieldMainManager" scope="page" />
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<jsp:useBean id="WFNodeFieldMainManager" class="weaver.workflow.workflow.WFNodeFieldMainManager" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="WFNodePortalMainManager" class="weaver.workflow.workflow.WFNodePortalMainManager" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page" />
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="wfrm" class="weaver.workflow.workflow.WfRightManager" scope="page" />
<%
    String ajax=Util.null2String(request.getParameter("ajax"));
	int wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
	boolean haspermission = wfrm.hasPermission3(wfid, 0, user, WfRightManager.OPERATION_CREATEDIR);
	if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%@ include file="/workflow/workflow/addwf_checktetachable.jsp" %>
<html>
<%
	String wfname="";
	String wfdes="";
	String title="";
	String isbill = "";
	String iscust = "";	
	int formid=0;
	title="edit";
	WFManager.setWfid(wfid);
	WFManager.getWfInfo();
	wfname=WFManager.getWfname();
	wfdes=WFManager.getWfdes();
	formid = WFManager.getFormid();
	isbill = WFManager.getIsBill();
	iscust = WFManager.getIsCust();
	int typeid = 0;
	typeid = WFManager.getTypeid();
	int rowsum=0;
    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int subCompanyId= Util.getIntValue(Util.null2String(session.getAttribute(wfid+"subcompanyid")),-1);
    int operatelevel=UserWFOperateLevel.checkUserWfOperateLevel(detachable,subCompanyId,user,haspermission,"WorkflowManage:All");
	boolean isoverrb = false ; //归档可强制收回
	boolean isoveriv = false ; //归档可干预
	RecordSet.executeSql("select isoverrb,isoveriv from workflow_base where id="+wfid);
	if(RecordSet.next()){
		isoverrb = RecordSet.getString("isoverrb").equals("1")?true:false;
		isoveriv = RecordSet.getString("isoveriv").equals("1")?true:false;
	}
	
	
	


%>
<head>
<link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(259,user.getLanguage());
String needfav ="";
String needhelp ="";
%>
</head>

<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
 if(operatelevel>0){
    if(!ajax.equals("1"))
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:selectall(),_self} " ;
    else
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:wfmsave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
    if(!ajax.equals("1")) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",addwf.jsp?src=editwf&wfid="+wfid+",_self} " ;

RCMenuHeight += RCMenuHeightStep;
    }
%>
<!--add by xhheng @ 2004/12/08 for TDID 1317-->
<%
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="wfmForm" name="wfmForm" method=post action="wfFunctionManageOp.jsp" >
<%
if(ajax.equals("1")){
%>
<input type="hidden" name="ajax" value="1">
<%}%>
<wea:layout type="2col">
	<%if(!ajax.equals("1")){%>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(2079,user.getLanguage())%></wea:item>
		<wea:item><%=wfname%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15433,user.getLanguage())%></wea:item>
		<wea:item><%=WorkTypeComInfo.getWorkTypename(""+typeid)%></wea:item>
		<%if(isPortalOK){%>
		<wea:item><%=SystemEnv.getHtmlLabelName(15588,user.getLanguage())%></wea:item>
		<wea:item>
			<%if(iscust.equals("0")){%><%=SystemEnv.getHtmlLabelName(15589,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(15554,user.getLanguage())%><%}%>
		</wea:item>
		<%}%>
		<wea:item><%=SystemEnv.getHtmlLabelName(15600,user.getLanguage())%></wea:item>
	    <%if(isbill.equals("0")){%>
	    <wea:item><%=FormComInfo.getFormname(""+formid)%></wea:item>
	    <%}else if(isbill.equals("1")){
	    	int labelid = Util.getIntValue(BillComInfo.getBillLabel(""+formid));
	    %>
	    <wea:item><%=SystemEnv.getHtmlLabelName(labelid,user.getLanguage())%></wea:item>
	    <%}else{%>
	    <wea:item> </wea:item>
	    <%}%>
	    <wea:item><%=SystemEnv.getHtmlLabelName(15594,user.getLanguage())%></wea:item>
	    <wea:item><%=wfdes%></wea:item>
	</wea:group>
	<%}%>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("251,633",user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelNames("115,18359",user.getLanguage())%></wea:item>
		<wea:item>
		<INPUT type="checkbox" tzCheckbox="true" class=InputStyle id="isoverrb" name="isoverrb" value="1" <%if(isoverrb){%> checked <%} %>  onclick="changeselect(this)">
		&nbsp;&nbsp;&nbsp;<SPAN class=".e8tips" style="CURSOR: hand" id="remind" title="<%=SystemEnv.getHtmlLabelName(84168,user.getLanguage())%>"><IMG id=ext-gen124 align=absMiddle src="/images/remind_wev8.png"></SPAN>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("115,18913",user.getLanguage())%></wea:item>
		<wea:item><INPUT type="checkbox" tzCheckbox="true" class=InputStyle id="isoveriv" name="isoveriv" value="1" <%if(isoveriv){%> checked <%} %>></wea:item>
	</wea:group>	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(124793,user.getLanguage())%>'><!--% =SystemEnv.getHtmlLabelName(18361,user.getLanguage()) %-->
		<wea:item attributes="{'isTableList':'true'}">
		<table class=ListStyle cellspacing=0>
			<colgroup>
				<col width="30%">
				<col width="45%">
				<col width="25%">
			</colgroup>
			<tr class=header>
				<td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(388,user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(18359,user.getLanguage())%></td>
				<td><input type="checkbox" name="ov" onClick="CheckAll(this.checked,this.name)"><%=SystemEnv.getHtmlLabelName(18360,user.getLanguage())%></td>
			</tr>
		
		<%
			String rb = "";
			String isDeleSubWf = "";
			String ov = "";
			
			RecordSet.executeSql("select * from workflow_function_manage where workflowid = " + wfid + " and operatortype = -1");
			if(RecordSet.next()){
				rb = RecordSet.getString("retract");
				ov = RecordSet.getString("pigeonhole");
			}
		%>
			<tr class="Spacing" style="height:1px!important;"><td colspan="3" class="paddingLeft18"><div class="intervalDivClass"></div></td></tr>
		
		<%
			int colorcount=0;
			//int nodeid = -1;
			int nodeid = 0;
			String nodename = "";
			String nodetype = "";
			ArrayList nodeids=WFLinkInfo.getCannotDrowBackNode(wfid);
			WFNodeMainManager.setWfid(wfid);
			WFNodeMainManager.selectWfNode();
			int jfreenode = 0;
			for(int i = 0; WFNodeMainManager.next() || jfreenode++ == 0; i++){
				nodeid = WFNodeMainManager.getNodeid();
				nodename = WFNodeMainManager.getNodename();
				nodetype = WFNodeMainManager.getNodetype();
				
				if (jfreenode == 1) {
				    nodeid = -9;
				    nodename = SystemEnv.getHtmlLabelName(83284, user.getLanguage());
				    nodetype = "-1";
				}
				    
				
				rb = "";
				ov = "";
				
				RecordSet.executeSql("select * from workflow_function_manage where workflowid = " + wfid + " and operatortype = " + nodeid);
				if(RecordSet.next()){
					rb = RecordSet.getString("retract");
					isDeleSubWf =  RecordSet.getString("isDeleSubWf");
					ov = RecordSet.getString("pigeonhole");
				}
				
				String spanId = "isDeleSubWfSpan_" + i;
		%>
			<tr>
				<td  height="23">
					<%if(!"0".equals(nodetype)){%>
					<%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%>
					<%}else{%>
					<%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%>
					<%}%>
					(<%=nodename%>)
					<input type="hidden" name="nodetype_<%=nodetype%>_<%=nodeid%>" id="nodetype_<%=nodetype%>_<%=nodeid%>" value="<%=nodetype%>" />
				</td>
				<td height="23">
					<select class=inputstyle  id="node<%=nodeid%>_rb" name="node<%=nodeid%>_rb" <%if(nodeids.indexOf(""+nodeid)>-1){%> disabled<%}%> onchange='retractChange(this,"<%=spanId%>")'>
					<option value="0" <%if("0".equals(rb)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18364,user.getLanguage())%></option>
					<option value="1" <%if("1".equals(rb)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18365,user.getLanguage())%></option>
					<option value="2" <%if("2".equals(rb)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18366,user.getLanguage())%></option>        
					</select>
					
					<%
						String display = "display:none;";
						String checked = "";
						if( rb.equals("1") ||  rb.equals("2")){
							display = "display:inline;";
							if(isDeleSubWf.equals("1")){
								checked = "checked";
							}
						}
					%>
					
					<span id='<%=spanId%>' style='<%=display %>padding-left:10px;'>
						<div style="display:none;">
						<input type='checkbox' id='isDeleSubWf' name='node<%=nodeid %>_isDeleSubWf' <%=checked %> value='1' tzCheckbox='true'/>
						<%=SystemEnv.getHtmlLabelName(32789, user.getLanguage())%>
						</div>
					</span>
				</td>  
				<td  height="23">
					<input type="checkbox" name="node<%=nodeid%>_ov" value="1" <%if("1".equals(ov)){%>checked<%}%> <%if(nodetype.equals("3")){ %> disabled<%} %>>
				</td>
			</tr>
			<%
			if (jfreenode == 1) {
			    %>
			    <tr style="height:1px!important;display:;" class="Spacing"><td class="paddingLeft0" colspan="3"><div class="intervalDivClass"></div></td></tr>
			    <%
			} else {
			%>
				<tr class="Spacing" style="height:1px!important;"><td colspan="3" class="paddingLeft18"><div class="intervalDivClass"></div></td></tr>
			<%
			}
			%>
		<%
		rowsum+=1;
		}
		%>
		</table>		
		</wea:item>
	</wea:group>
</wea:layout>

<input type="hidden" value="<%=wfid%>" name="wfid">
</form>
<%if(!ajax.equals("1")){%>
<script language="JavaScript" src="/js/addRowBg_wev8.js" ></script>
<script language=javascript>
var rowColor="" ;
rowindex = "<%=rowsum%>";
delids = "";

function selectall(){
	document.forms[0].nodessum.value=rowindex;
	document.forms[0].delids.value=delids;

	window.document.portform.submit();
}


</script>
<%}else{%>
<div id=portrowsum style="display:none;"><%=rowsum%></div>
<script type="text/javascript">
function wfmsave(obj){
    obj.disabled=true;
    document.forms[0].submit();
}
</script>
<%}%>
<script type="text/javascript">
$(document).ready(function(){
	$(".liststyle").find("tr[class=Spacing]:last").find("td").removeClass("paddingLeft18").addClass("paddingLeft0");
	jQuery("span[id^=remind]").wTooltip({html:true});
	changeselect();
});

function retractChange(me, spanId){
	var retract = jQuery(me).val();
	if( retract != 0 ){
		jQuery('#' + spanId).fadeIn();
		jQuery('#' + spanId).find('input[type=checkbox]').removeAttr('checked');
		jQuery('#' + spanId).find('span[class^=tzCheckBox]').attr('class', 'tzCheckBox');
	}else{
		jQuery('#' + spanId).fadeOut();
		jQuery('#' + spanId).find('input[type=checkbox]').removeAttr('checked');
		jQuery('#' + spanId).find('span[class^=tzCheckBox]').attr('class', 'tzCheckBox');
	}
}

function CheckAll(haschecked,flag) {
	if(haschecked){
		$("input[name*=_"+flag+"]").each(function(){
			var ck = $(this);
				ck.attr("checked",true);
				ck.next().addClass("jNiceChecked");
		});
	}else{
		$("input[name*=_"+flag+"]").each(function(){
			var ck = $(this);
				ck.attr("checked",false);
				ck.next().removeClass("jNiceChecked");
		});
	}
}

function changeselect(){
	var obj = jQuery("#isoverrb");
	if(obj.attr("checked")=='true'||obj.attr("checked")==true){
	//解锁
		jQuery("input[id^='nodetype_3_']").each(function(i){
			var nodeid = jQuery(this).attr("name").split("_")[2];				
			jQuery("#node"+nodeid+"_rb").selectbox("enable");
			//jQuery("#node"+nodeid+"_rb").removeAttr("disabled");
			//alert(i+"/"+nodeid);
		});
	}else{
	//加锁
		jQuery("input[id^='nodetype_3_']").each(function(i){
			var nodeid = jQuery(this).attr("name").split("_")[2];	
			//jQuery("#node"+nodeid+"_rb").attr("disabled","disabled");
			jQuery("#node"+nodeid+"_rb").selectbox("disable");
			//alert(i+"//"+nodeid);
		});
	}
}
</script>
</body>
</html>
