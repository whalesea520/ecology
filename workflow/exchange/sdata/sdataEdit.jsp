<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.exchange.ExchangeUtil"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="GetFormDetailInfo" class="weaver.workflow.automatic.GetFormDetailInfo" scope="page" />
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />

<%
if(!HrmUserVarify.checkUserRight(ExchangeUtil.WFEC_SETTING_RIGHTSTR, user))
{
	response.sendRedirect("/notice/noright.jsp");    	
	return;
}
%>
<%

boolean isUseWfManageDetach = manageDetachComInfo.isUseWfManageDetach();
int tempsubcomid = -1 ;
if(isUseWfManageDetach){
	RecordSet.executeSql("select wfdftsubcomid from SystemSet");
	RecordSet.next();
	tempsubcomid = Util.getIntValue(RecordSet.getString(1),0);
}

int detachable = Util.getIntValue(request.getParameter("detachable"),0);
int operatelevel = -1  ;
if(isUseWfManageDetach){
    detachable = 1 ;
}
if(detachable==1){
    int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"),0);
    if(request.getParameter("subcompanyid")==null){
        subcompanyid=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")),0);
    }
    if(subcompanyid == -1){
        subcompanyid = user.getUserSubCompany1();
    }
    operatelevel = CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),ExchangeUtil.WFEC_SETTING_RIGHTSTR,subcompanyid);
    if(operatelevel < 0 ){
        response.sendRedirect("/notice/noright.jsp");       
        return;
    }
}

String setname = "";
String datasourceid = "";
String workflowname = "";
String outermaintable = "";
String outerdetailtables = "";
String iscallback = "";
String periodvalue = "";
String status = "";
ArrayList outerdetailtablesArr = new ArrayList();

String viewid = Util.null2String(request.getParameter("viewid"));
String workflowid = Util.null2String(request.getParameter("workFlowId"));
String operate = Util.null2String(request.getParameter("operate"));
int subcompanyid = -1;

String wftypeid = Util.null2String(request.getParameter("wftypeid"));
String wfid = Util.null2String(request.getParameter("wfid"));
String _subcomid = Util.null2String(request.getParameter("subcompanyid"));
String formID = "";
String isbill = "";

if(operate.equals("reedit")){//编辑时重新选择流程
    setname = Util.null2String(request.getParameter("name"));
    workflowid = Util.null2String(request.getParameter("workFlowId"));
    datasourceid = Util.null2String(request.getParameter("datasourceid"));
    subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"));
}else{
    RecordSet.executeSql("select * from wfec_indatawfset where id="+viewid);
    if(RecordSet.next()){
        setname = Util.null2String(RecordSet.getString("name"));
        workflowid = Util.null2String(RecordSet.getString("workflowid"));
        datasourceid = Util.null2String(RecordSet.getString("datasourceid"));
        outermaintable = Util.null2String(RecordSet.getString("outermaintable"));

        outerdetailtables = Util.null2String(RecordSet.getString("outerdetailtables"));
        subcompanyid = Util.getIntValue(RecordSet.getString("subcompanyid"));
        periodvalue = Util.null2String(RecordSet.getString("periodvalue"));
        status = Util.null2String(RecordSet.getString("status"));
        outerdetailtablesArr = Util.TokenizerString(outerdetailtables,",");

    }
}
boolean isexist = false;
ArrayList pointArrayList = DataSourceXML.getPointArrayList();
for(int i=0;i<pointArrayList.size();i++){
    String pointid = (String)pointArrayList.get(i);
    if(datasourceid.equals(pointid)){
        isexist = true;
    }
}
if(!isexist)
{
	datasourceid  = "";
}

if(!"".equals(workflowid))
{
	workflowname = Util.null2String(WorkflowComInfo.getWorkflowname(workflowid));
	isbill = Util.null2String(WorkflowComInfo.getIsBill(workflowid));
	formID = Util.null2String(WorkflowComInfo.getFormId(workflowid));
	//wftypeid = WorkflowComInfo.getWorkflowtype(workflowid);
}
int detailcount = GetFormDetailInfo.getDetailNum(formID,isbill);
if(isUseWfManageDetach){
	if(subcompanyid<=0){
		subcompanyid = tempsubcomid ;
		if(subcompanyid<=0){
			subcompanyid = 0 ;
		}
	}
}
%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />
<script type="text/javascript" src="/wui/common/jquery/plugin/jQuery.modalDialog_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/wuiform/jquery.wuiform_wev8.js"></script>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23076,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(367,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body id='setbody'>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDel("+viewid+",1),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onshowlog("+viewid+"),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name="frmmain" method="post" action="sdataOperation.jsp">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" id="submitData" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="submitData()"/>
			<input type="button" id="submitData" value="<%=SystemEnv.getHtmlLabelName(91 ,user.getLanguage()) %>" class="e8_btn_top" onclick="onDel(<%=viewid %>,1)"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<input type="hidden" id="operate" name="operate" value="edit">
<input type="hidden" id="viewid" name="viewid" value="<%=viewid%>">
<input type="hidden" id="wftypeid" name="wftypeid" value="<%=wftypeid %>" />
<input type="hidden" id="wfid" name="wfid" value="<%=wfid %>" />
<input type="hidden" id="subcomid" name="subcomid" value="<%=_subcomid %>" />
<input type="hidden" id="wftypeid" name="wftypeid" value="<%=wftypeid %>" />
<input type="hidden" id="detailcount" name="detailcount" value="<%=detailcount%>">
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
	  		<wea:item><%=SystemEnv.getHtmlLabelName(82504,user.getLanguage())%></wea:item>
			<wea:item>
				<wea:required id="setnamespan" required="true" value='<%=setname%>'>
				<input type="text" size="35" class="inputstyle" style='width:280px!important;' id="setname" name="setname" value="<%=setname%>" onChange="checkinput('setname','setnamespan')">
				</wea:required>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
			<wea:item>
				<INPUT type="checkbox" tzCheckbox="true" class=InputStyle id="status" name="status" value="1" <%if(status.equals("1")){%> checked <%} %>>
			</wea:item>
	  		<wea:item><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></wea:item>
			<wea:item>
				<!-- input id="workFlowId" class="wuiBrowser" name="workFlowId" _url="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp" _scroll="no" _callBack="" value="<%=workflowid %>" _displayText="<%=workflowname %>" _displayTemplate="" _required="yes"/ -->
				<brow:browser viewType="0" name="workFlowId" browserValue='<%= ""+workflowid %>' 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser_frm.jsp?isTemplate=0&iswfec=1"
					hasInput="true" isSingle="true" hasBrowser="true" isMustInput='2' hasAdd="false"
					completeUrl="/data.jsp?type=workflowBrowser&isTemplate=0&iswfec=1" linkUrl=""
					browserSpanValue='<%=workflowname %>' width='300px' _callBack=""></brow:browser>
			</wea:item>
			<%if(isUseWfManageDetach){ %>
			<wea:item><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
			<wea:item >
				<brow:browser name="subcompanyid" viewType="0" hasBrowser="true" hasAdd="false" 
                  browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr="+ ExchangeUtil.WFEC_SETTING_RIGHTSTR +"&isedit=1" %>' 
                  isMustInput="2" 
                  isSingle="true" 
                  hasInput="true"
                  completeUrl="/data.jsp?type=164"  width="300px" 
                  browserValue='<%=String.valueOf(subcompanyid)%>' 
                  browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(String.valueOf(subcompanyid))%>'/> 
			</wea:item>
			<%} %>
			<wea:item><%=SystemEnv.getHtmlLabelName(82505,user.getLanguage())%></wea:item>
			<wea:item >
				<select name="_type" disabled="true" >
					<option value=""></option>
					<option value="0"><%=SystemEnv.getHtmlLabelName(84587,user.getLanguage())%></option>
					<option value="1" selected><%=SystemEnv.getHtmlLabelName(84586,user.getLanguage())%></option>
				</select>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%></wea:item>
			<wea:item attributes="{id:'nomv'}">
				<span>
				<select id="datasourceid" name="datasourceid" style='width:120px!important;' onchange="ChangeDatasource(this,datasourceidspan)">
					<option></option>
					<%
					for(int i=0;i<pointArrayList.size();i++){
					    String pointid = (String)pointArrayList.get(i);
					    String isselected = "";
					    if(datasourceid.equals(pointid)){
					        isexist = true;
					        isselected = "selected";
					    }
					%>
					<option value="<%=pointid%>" <%=isselected%>><%=pointid%></option>
					<%    
					}
					%>
				</select>
				</span>
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" value="<%=SystemEnv.getHtmlLabelName(84600,user.getLanguage())%>" onClick="CreateDataTable();" class="e8_btn_top"/>
				&nbsp;&nbsp;
				<span class='e8tips' title='<%=SystemEnv.getHtmlLabelName(84589,user.getLanguage())%>'>
				<img src='/images/tooltip_wev8.png' align='absMiddle'/>
				</span>
			</wea:item>
				<%
				ArrayList<String> tablenamelist = new ArrayList<String>();
				String tab_sql = "";
				String maintablename = "";
				if(isbill.equals("0")){
					maintablename = "workflow_form" ;
					tab_sql = "select  groupid from workflow_formfield where isdetail=1 and formid="+formID+" group by groupid";
					RecordSet.executeSql(tab_sql);
					while(RecordSet.next()){
						tablenamelist.add("workflow_formdetail");
					}
				}else{
					//主表
					tab_sql = "select tablename from workflow_bill where id="+formID+"";
					RecordSet.executeSql(tab_sql);
					if(RecordSet.next()){
						maintablename = RecordSet.getString(1);
					}
					//明细表
					tab_sql = "select tablename from workflow_billdetailtable where billid="+formID+" order by orderid";
					RecordSet.executeSql(tab_sql);
					while(RecordSet.next()){
						tablenamelist.add(RecordSet.getString(1));
					}
				}
				%>
				<wea:item attributes="{'colspan':'2','isTableList':'true'}">
				<wea:layout type="fourCol" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
				<wea:group context="" attributes="{'samePair':'TabInfo','groupDisplay':'none','groupSHBtnDisplay':'none'}">
				<wea:item><%=SystemEnv.getHtmlLabelName(26421,user.getLanguage())%></wea:item>
				<wea:item><%=maintablename %></wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(84596,user.getLanguage())%></wea:item>
				<wea:item>
					<wea:required id="outermaintablespan" required="true" value='<%=outermaintable%>'>
						<input type=text size=35 class=inputstyle style='width:280px!important;' id="outermaintable" name="outermaintable" value="<%=outermaintable%>" onchange="checkinput('outermaintable','outermaintablespan')">
					</wea:required>
				</wea:item>
				<%
				for(int i=0;i<detailcount;i++){
				    String outerdetailtable = "";
				    String outerdetailwhere = "";
				    if(!operate.equals("reedit")){
				        if(outerdetailtablesArr.size()>i){
				            outerdetailtable = (String)outerdetailtablesArr.get(i);
				            if(outerdetailtable.equals("-")) outerdetailtable = "";
				        }
				    }
				%>	
					<wea:item><%=SystemEnv.getHtmlLabelName(84595,user.getLanguage())%><%=i+1 %></wea:item>
					<wea:item><%=tablenamelist.get(i) %></wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(84597,user.getLanguage())%><%=i+1 %></wea:item>
					<wea:item><input type="text" size="35" class="inputstyle" id="outerdetailtable<%=i%>" name="outerdetailtable<%=i%>" value='<%=outerdetailtable %>' ></wea:item>
				<%
				}
				%>
				</wea:group>
				</wea:layout>
				</wea:item>
				
			</wea:group>
			
	</wea:layout>
</form>
</body>
</html>
<script language="javascript">
window.onbeforeunload = function protectManageBillFlow(event){
  	if(!checkDataChange())//added by cyril on 2008-06-10 for TD:8828
        return "<%=SystemEnv.getHtmlLabelName(18407,user.getLanguage())%>";
}
$(document).ready(function(){
	wuiform.init();
	jQuery(".e8tips").wTooltip({html:true});
	jQuery("input[type=checkbox]").each(function(){
		if(jQuery(this).attr("tzCheckbox")=="true"){
		  jQuery(this).tzCheckbox({labels:['','']});
		}
	});
	jQuery("#nomv").unbind();
	jQuery($GetEle("setbody")).attr("onbeforeunload", "");
});
function submitData(){
	
	var fieldchecks = "setname,workFlowId,outermaintable";
    if(check_form($GetEle("frmmain"),fieldchecks)){
    	jQuery($GetEle("setbody")).attr("onbeforeunload", "");
    	e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(25666,user.getLanguage())%>",true,"xTable_message");
        $GetEle("frmmain").submit();
    }
}

function CreateDataTable(){
	var fieldchecks = "setname,workFlowId";
	document.frmmain.operate.value = "createtable";
    if(check_form($GetEle("frmmain"),fieldchecks)){
    	jQuery($GetEle("setbody")).attr("onbeforeunload", "");
    	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(84677,user.getLanguage())%>", function (){
    		e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(25666,user.getLanguage())%>",true,"xTable_message");
			$GetEle("frmmain").submit();
		}, function () {}, 320, 90,true);
    }
}

function ChangeDatarecordType(objvalue)
{
	var type = objvalue;
	if(type=="1")
	{
		hideEle("datarecord");
	}
	else if(type=="2")
	{
		showEle("datarecord");
	}
}
function onShowTableField(type){
	var fieldname = "";
	var datasource = frmmain.datasourceid.value;
	var tablename = frmmain.outermaintable.value;
	//alert("type : "+type+" datasource : "+datasource+" tablename2 : "+tablename2)
   	if(tablename=="")
   	{
   		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32253,user.getLanguage())%>");//对应表名未填写，请填写！
   		return "";
   	}
	var urls = "/systeminfo/BrowserMain.jsp?mouldID=workflow&dmltablename="+tablename+"&datasourceid="+datasource+"&url=/workflow/dmlaction/dmlTableFieldsBrowser.jsp";
	//alert(urls);
	return urls;
	/*var id_t = showModalDialog(urls);
	if(id_t){
		if(id_t.id != ""&& typeof id_t!='undefined'){
			fieldname = wuiUtil.getJsonValueByIndex(id_t, 0);
		}else{
			fieldname = "";
		}
	}
	//alert("fieldname : "+fieldname+" obj : "+obj)
	obj.nextSibling.value=fieldname;
	$(obj.nextSibling).change();
	*/
}
function setTableField(event,data,name,paras,tg){
	//Dialog.alert("event : "+event);
	var obj = null;
	//alert(typeof(tg)+"  event : "+event);
	if(typeof(tg)=='undefined'){
		obj= event.target || event.srcElement;
	}
	else
	{
		obj = tg;
	}
	var fieldname = "";
	if(data){
		if(data.id != ""&& typeof data!='undefined'){
			fieldname = data.name;
		}else{
			fieldname = "";
		}
	}
	//alert("fieldname : "+fieldname+" obj : "+obj)
	obj.nextSibling.value=fieldname;
	$(obj.nextSibling).change();
}

$(document).ready(function(){
	
});
function ChangeDatasource(obj,datasourceidspan){
    if(obj.value!=""&&obj.value!=null) datasourceidspan.innerHTML = "";
    else datasourceidspan.innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
}
function onBackUrl(url)
{
	jQuery($GetEle("setbody")).attr("onbeforeunload", "");
	document.location.href=url;
}
</script>
<script type="text/javascript">
function disModalDialog(url, spanobj, inputobj, need, curl) {

	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			} else {
				spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			}
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}

function onDel(id,type){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
		/*
			jQuery.ajax({
				url:'/workflow/exchange/sdata/sdataOperation.jsp',
				data:{id:id,operate:'delete',temp:Math.random()},
				dataType:'text',
				success:function(data){
					if(data==1){
		      			top.Dialog.alert("数据删除成功！");
		      			window.parent.close();
		      		}else{
		      			top.Dialog.alert("数据删除失败！");
		      		}
				}
			});
	   */
	   document.frmmain.operate.value = "delete";	
	   $GetEle("frmmain").submit();	
	}, function () {}, 320, 90,true);
}

function onshowlog(id){
	dialog = new top.Dialog();
	dialog.currentWindow = window; 
	var url = "/systeminfo/SysMaintenanceLog.jsp?_fromURL=&wflog=1&isdialog=1&sqlwhere=<%=xssUtil.put("where operateitem=199 and relatedid=")%>&relatedid="+id;
	if(id==0){
		url = "/systeminfo/SysMaintenanceLog.jsp?_fromURL=&wflog=1&isdialog=1&sqlwhere=<%=xssUtil.put("where operateitem=199 ")%>&temp=";
	}
	
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(31709,user.getLanguage()) %>";
	dialog.Width = jQuery(top.window).width()-100;
	dialog.Height = jQuery(top.window).height()-100;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}
</script>
</script>
<script language=javascript src="/js/checkData_wev8.js"></script>
