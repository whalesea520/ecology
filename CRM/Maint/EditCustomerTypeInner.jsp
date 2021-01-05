
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<%
boolean canedit_share = HrmUserVarify.checkUserRight("EditCustomerType:Edit",user);
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page"/>
<%
	String id = Util.null2String(request.getParameter("id"));
	String isclose = Util.null2String(request.getParameter("isclose"));
	//which tab 基本信息;显示字段名 add by Dracula @2014-1-28
	String winfo = Util.null2String(request.getParameter("winfo"));
	String workflowid = "";
	String crmtypename = "";
	if(!"1".equals(isclose))
	{
		RecordSet.executeProc("CRM_CustomerType_SelectByID",id);
	
		if(RecordSet.getFlag()!=1)
		{
			response.sendRedirect("/CRM/DBError.jsp?type=FindData");
			return;
		}
		if(RecordSet.getCounts()<=0)
		{
			response.sendRedirect("/CRM/DBError.jsp?type=FindData");
			return;
		}
		RecordSet.first();
		
		workflowid = RecordSet.getString("workflowid");
		crmtypename = RecordSet.getString(2);
	
		RecordSetShare.executeProc("CRM_T_ShareInfo_SbyRelateid",id);
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script type="text/javascript">
function openDialog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/CRM/data/AddTypeShare.jsp?itemtype=2&typeid=<%=id%>&crmtypename=<%=crmtypename %>";
	dialog.Title = "添加共享";
	dialog.Width = 420;
	dialog.Height = 300;
	
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function checkSubmit(){
    if(check_form(weaver,'name')){
        weaver.submit();
    }
}
var parentWin = parent.parent.getParentWindow(parent.window);
if("<%=isclose%>"=="1"){
	parentWin.location = "ListCustomerTypeInner.jsp";
	parentWin.closeDialog();
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

//批量删除
    function delMutli()
    {
    	var id = _xtable_CheckedCheckboxId();
    	if(!id){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>!");
			return;
		}
		if(id.match(/,$/)){
			id = id.substring(0,id.length-1);
		}
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
			var idArr = id.split(",");
			for(var i=0;i<idArr.length;i++){
				jQuery.ajax({
					url:"/CRM/data/TypeShareOperation.jsp?method=delete&id="+idArr[i]+"&typeid=<%=id%>",
					type:"post",
					async:true,
					complete:function(xhr,status){
						_table.reLoad();
					}
				});
			}
		});
		
    }
</script>
</HEAD>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);

// modified by lupeng 2004-8-7 for TD772
boolean canedit = (HrmUserVarify.checkUserRight("EditCustomerType:Edit",user) && !(Util.null2String(RecordSet.getString(5))).equals("n"));
// end.

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
// added by lupeng 2004-8-6 for TD767
if (canedit)
	titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":&nbsp;"
			+SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(63,user.getLanguage());
else
	titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+":&nbsp;"
			+SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(63,user.getLanguage());
// end.
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0" >
	<tr>
		<td class="rightSearchSpan">
			<%if(winfo.equals("2") && canedit_share){ %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(18645,user.getLanguage())%>" class="e8_btn_top" style='margin-top:8px' onclick="openDialog()"/>&nbsp;&nbsp;
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(18646,user.getLanguage())%>" class="e8_btn_top" style='margin-top:8px' onclick="delMutli()"/>&nbsp;&nbsp;
			<%} %>
			
			<%if(winfo.equals("1")){ %>
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"  class="e8_btn_top" onclick="checkSubmit();">
	    	<%}%>
	    	<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table> 

<div class="zDialog_div_content" style="height:300px;">
<%if(winfo.equals("1")){ %>
<FORM id=weaver name="weaver" action="/CRM/Maint/CustomerTypeOperation.jsp" method=post >
<input type="hidden" name="method" value="edit">
<input type="hidden" name="id" value="<%=id%>">

<wea:layout>
	<wea:group context='<%= SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{groupDisplay:none}">
		<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="nameimage">
				<% if(canedit) {%><INPUT class=InputStyle maxLength=150 style="width: 300px;" size=45 name="name" value="<%=Util.toScreenToEdit(RecordSet.getString(2),user.getLanguage())%>" onchange='checkinput("name","nameimage")' >
				<%}else {%><INPUT class=InputStylet type=hidden maxLength=50 size=20 name="name" onchange='checkinput("name","nameimage")' 
					value="<%=Util.toScreenToEdit(RecordSet.getString(2),user.getLanguage())%>">
				<%=Util.toScreen(RecordSet.getString(2),user.getLanguage())%><%}%>
			</wea:required>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
		<wea:item>
			<% if(canedit) {%><INPUT class=InputStyle maxLength=150 style="width: 300px;" size=45 name="desc" value="<%=Util.toScreenToEdit(RecordSet.getString(3),user.getLanguage())%>">
			<%}else {%><INPUT class=InputStyle type=hidden maxLength=150 size=50 name="desc" 
				 value="<%=Util.toScreenToEdit(RecordSet.getString(3),user.getLanguage())%>">
			<%=Util.toScreen(RecordSet.getString(3),user.getLanguage())%><%}%>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(15057,user.getLanguage())%></wea:item>
		<wea:item>
			<% if(HrmUserVarify.checkUserRight("EditCustomerType:Edit", user)) {
				String browserUrl = "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere="+xssUtil.put("where isbill=1 and formid=79");
				%>
            	<brow:browser viewType="0" name="workflowid" 
                	browserOnClick="" browserUrl="<%=browserUrl%>"
                	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
                	completeUrl="" width="267px"
                	browserSpanValue='<%=Util.toScreen(WorkflowComInfo.getWorkflowname(workflowid),user.getLanguage()) %>' browserValue='<%=workflowid%>' >
        		</brow:browser>
            <%}else{%>
            	<%=Util.toScreen(WorkflowComInfo.getWorkflowname(workflowid),user.getLanguage()) %>
            <%}%>
		</wea:item>
	</wea:group>
</wea:layout>
</FORM>
<%} %>

<!--共享信息begin-->
<%if(winfo.equals("2")){ %>

<%
	//原始页面未采用分页控件，现在改成分页控件 add by Dracula @2014-1-23
	String otherpara = "column:id+column:description";
	String tableString = "";
	String backfields = " t1.id,t1.relateditemid,t1.sharetype,t1.seclevel,t1.seclevelMax,t1.rolelevel,t1.sharelevel,t1.userid,t1.departmentid,t1.roleid,t1.foralluser,t1.crmid,t1.subcompanyid,t1.jobtitleid,t1.joblevel,t1.scopeid ";
	String fromSql = " from CRM_T_ShareInfo t1 ";
	String orderkey = " t1.sharetype ";
	String sqlWhere = " 1=1 and t1.relateditemid ="+id;
	String fullnamepara = "column:fullname";
	String popedomUserpara = String.valueOf(user.getUID());
	String checkpara = "column:id+"+popedomUserpara;
	String popedomColpara = "column:sharetype+column:userid+column:departmentid+column:roleid+column:subcompanyid+column:jobtitleid+column:joblevel+column:scopeid";
	
	tableString = " <table instanceid=\"MaintContacterTitleListTable\"  tabletype=\"checkbox\" pagesize=\"10\" >"
	+ " <checkboxpopedom  id=\"checkbox\"  popedompara=\""+checkpara+"\" showmethod=\"weaver.crm.Maint.CRMTransMethod.getCRMCustomerTypeShareResultCheckbox\" />"
	+ "	<sql backfields=\"" + backfields 
	+ "\" sqlform=\"" + fromSql 
	+ "\" sqlwhere=\"" + Util.toHtmlForSplitPage(sqlWhere) 
	+ "\"  sqlorderby=\"" + orderkey
	+ "\"  sqlprimarykey=\"t1.id\" sqlsortway=\"asc\" sqlisdistinct=\"true\" />" ;
	
	tableString += " <head>"; 
	tableString += " <col width=\"10%\"  text=\"" + SystemEnv.getHtmlLabelName(21956,user.getLanguage())
	+ "\" column=\"sharetype\" orderkey=\"t1.sharetype\" transmethod=\"weaver.crm.Maint.CRMTransMethod.getCRMCustomShareforType\" otherpara=\""+popedomUserpara+"\" />";
	tableString += " <col width=\"20%\"  text=\"" + SystemEnv.getHtmlLabelName(106,user.getLanguage())
	+ "\" column=\"departmentid\" transmethod=\"weaver.crm.Maint.CRMTransMethod.getCRMCustomShareforObject\" otherpara=\""+popedomColpara+"\"/>";
	tableString += " <col width=\"10%\"  text=\"" + SystemEnv.getHtmlLabelName(683,user.getLanguage())
	+ "\" column=\"seclevel\" orderkey=\"t1.seclevel\" transmethod=\"weaver.crm.Maint.CRMTransMethod.getCRMCustomShareforSafe\" otherpara=\"column:sharetype+column:rolelevel+column:seclevelMax+"+user.getLanguage()+"+column:joblevel+column:scopeid\"/>";
	tableString += " <col width=\"10%\"  text=\"" + SystemEnv.getHtmlLabelName(3005,user.getLanguage())
	+ "\" column=\"sharelevel\" orderkey=\"t1.sharelevel\" transmethod=\"weaver.crm.Maint.CRMTransMethod.getCRMCustomShareforShare\" otherpara=\""+popedomUserpara+"\"/>";
	
	tableString += " </head>" + "</table>";
%>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />

<%} %>
</div>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentWin.closeDialog();">
	    	</wea:item>
		</wea:group>
	</wea:layout>
</div>

</BODY>
</HTML>
