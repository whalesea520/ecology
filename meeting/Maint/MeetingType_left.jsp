
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
boolean canedit=false;

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("meetingdetachable")),0);
int subcompanyid=-1;
int subid=Util.getIntValue(request.getParameter("subCompanyId"));
String SelectSubCompany = "";
SelectSubCompany=Util.null2String(request.getParameter("SelectSubCompany"));
if("".equals(SelectSubCompany) && subid > 0){
	SelectSubCompany = ""+subid;
}
if(subid<0){
        subid=user.getUserSubCompany1();
}
if(subid>0){
	subcompanyid=subid;
}
ArrayList subcompanylist=SubCompanyComInfo.getRightSubCompany(user.getUID(),"MeetingType:Maintenance");
int operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"MeetingType:Maintenance",subid);
if(detachable==1){
	if(subid!=0 && operatelevel<1){
		canedit=false;
	}else{
		canedit=true;
	}
	subcompanyid = subid;
}else{
	if(HrmUserVarify.checkUserRight("MeetingType:Maintenance",user)) {
	canedit=true;
	}
}
//System.out.println(canedit);
String name=Util.null2String(request.getParameter("names"));
int approver=Util.getIntValue(request.getParameter("approvers"), -1);
int approver1=Util.getIntValue(request.getParameter("approvers1"), -1);

String subcompanyspan = "";
if(!SelectSubCompany.equals("")){
	ArrayList SelectSubCompanys = Util.TokenizerString(SelectSubCompany,",");
	SelectSubCompany = "";
	for(int i=0;i<SelectSubCompanys.size();i++){
		//subcompanyspan += "<a href=\'javascript:void(0)\' onclick=\'openFullWindowForXtable(\"/hrm/company/HrmSubCompanyDsp.jsp?id="+SelectSubCompanys.get(i) +"\")\'>"+SubCompanyComInfo.getSubCompanyname(""+SelectSubCompanys.get(i))+"</a>&nbsp;";
 		SelectSubCompany +=","+SelectSubCompanys.get(i);
		subcompanyspan += SubCompanyComInfo.getSubCompanyname(""+SelectSubCompanys.get(i))+",";
 	}
	 if(subcompanyspan.length() > 1) {
		 SelectSubCompany = SelectSubCompany.substring(1);
	 	 subcompanyspan = subcompanyspan.substring(0, subcompanyspan.length() - 1);
	 }
 }
String SelectSubCompanySql= SelectSubCompany;
String sqlwhere = "";
if(!"".equals(name)) sqlwhere += "and name like '%" +  name + "%' ";
if(!"".equals(SelectSubCompanySql) && !"-1".equals(SelectSubCompanySql)) sqlwhere += "and subcompanyid in (" +  SelectSubCompanySql + ") ";
if(approver > 0) sqlwhere += "and approver = " +  approver+" ";
if(approver1 > 0) sqlwhere += "and approver1="+approver1+" ";

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
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(780,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:add(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:delN(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;


%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
		 
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) %>" class="e8_btn_top middle" onclick="add()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>" class="e8_btn_top middle" onclick="delN()"/>
			<input type="text" class="searchInput" id="t_name" name="t_name" />
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
	<span class="toggleLeft" id="toggleLeft" onclick="toggleLeft()" title="<%=SystemEnv.getHtmlLabelName(18890,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(19652,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(17871,user.getLanguage()) %>"><%=SystemEnv.getHtmlLabelName(26505,user.getLanguage()) %></span>
	<span id="hoverBtnSpan" class="hoverBtnSpan">
		<span id="ALL"  style="WIDTH: 100px;" class="selectedTitle" ><%=SystemEnv.getHtmlLabelName(16616,user.getLanguage())%></span>
	</span>
</div>

<div class="advancedSearchDiv" id="advancedSearchDiv">
<FORM id=weaverA name=weaverA action="MeetingType_left.jsp" method=post  >
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331, user.getLanguage())%>' >
			<!-- 会议类型 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(2104,user.getLanguage())%></wea:item>
			<wea:item>
              <input class=inputstyle type="text" id="names" name="names"  style="width:60%" value="<%if(!name.equals("")){%><%=Util.forHtml(name)%><%}%>">
              <INPUT class=inputstyle id=subCompanyId type=hidden name=subCompanyId value="<%=subcompanyid%>">
              <INPUT class=inputstyle id=subid type=hidden name=subid value="<%=subid%>">
			</wea:item>
			<!-- 审批工作流 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(15057,user.getLanguage())%></wea:item>
            <wea:item>
            	<brow:browser viewType="0" name="approvers" browserValue='<%=(approver > 0?(""+approver):"")%>' 
				browserOnClick="" browserUrl='<%=browserUrl%>' 
				hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  width="150px"
				completeUrl='<%=completeUrl%>' linkUrl="/workflow/workflow/addwf.jsp?src=editwf&isTemplate=0&wfid=#id#&id=#id#" 
				browserSpanValue='<%=WorkflowComInfo.getWorkflowname(""+approver)%>'></brow:browser>
            </wea:item>
            <!-- 审批工作流 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(82441,user.getLanguage())%></wea:item>
            <wea:item>
            	<brow:browser viewType="0" name="approvers1" browserValue='<%=(approver1 > 0?(""+approver1):"")%>' 
				browserOnClick="" browserUrl='<%=browserUrl%>' 
				hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  width="150px"
				completeUrl='<%=completeUrl%>' linkUrl="/workflow/workflow/addwf.jsp?src=editwf&isTemplate=0&wfid=#id#&id=#id#" 
				browserSpanValue='<%=WorkflowComInfo.getWorkflowname(""+approver1)%>'></brow:browser>

            </wea:item>
            <!-- 所属机构 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
            <wea:item>
              
                	<brow:browser viewType="0" name="SelectSubCompany" browserValue='<%=SelectSubCompany%>' 
					browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?show_virtual_org=-1&selectedids=" 
					hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1'  width="200px"
					completeUrl="/data.jsp?type=164&show_virtual_org=-1" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
					browserSpanValue='<%=subcompanyspan %>'></brow:browser>
            </wea:item>
		</wea:group>
		<wea:group context="">
	    	<wea:item type="toolbar">
				<input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"/>

				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtionAVS();"/>

				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
	    	</wea:item>
	    </wea:group>
	</wea:layout>
</FORM>
</div>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.MT_MeetingType%>"/>
	<%String orderby =" dsporder, name ";
	String tableString = "";
	int perpage=10;
	//System.out.println("["+sqlwhere+"]");                          
	String backfields = " id,name,approver,approver1,desc_n,subcompanyid, catalogpath, dsporder ";
	String fromSql  = " Meeting_Type ";
	tableString =   " <table instanceid=\"\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.MT_MeetingType,user.getUID())+"\" >"+
		 			" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:subcompanyid+"+user.getUID()+"+"+detachable+"\" showmethod=\"weaver.meeting.Maint.MeetingTransMethod.getTypeCheckbox\"  />"+
	 				"       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\"  sqlwhere=\""+(sqlwhere.length() > 3?Util.toHtmlForSplitPage(sqlwhere.substring(3)):"")+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"ASC\" sqlisdistinct=\"true\" />"+
					"       <head>"+
					"           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(2104,user.getLanguage())+"\" column=\"name\" orderkey=\"name\" otherpara=\"column:id+onEdit\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getClickMethod\"/>"+
					"           <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(17868, user.getLanguage())+"\" column=\"subcompanyid\" orderkey=\"subcompanyid\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingSubCompany\" />"+
					"           <col width=\"17%\"  text=\""+SystemEnv.getHtmlLabelName(15057, user.getLanguage())+"\" column=\"approver\" orderkey=\"approver\" transmethod=\"weaver.workflow.workflow.WorkflowComInfo.getWorkflowname\" />"+
					"           <col width=\"17%\"  text=\""+SystemEnv.getHtmlLabelName(82441, user.getLanguage())+"\" column=\"approver1\" orderkey=\"approver1\" transmethod=\"weaver.workflow.workflow.WorkflowComInfo.getWorkflowname\" />"+
					"           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+"\" column=\"catalogpath\" orderkey=\"catalogpath\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getCategorypath\" />"+
					"			<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"dsporder\" orderkey=\"dsporder\" />"+
					"       </head>";
	 
	tableString +=  "		<operates>"+
					"		<popedom column=\"id\" otherpara=\"6+column:subcompanyid+"+user.getUID()+"+"+detachable+"\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.checkTypeOperate\"></popedom> "+
					"		<operate href=\"javascript:onEdit();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
					"		<operate href=\"javascript:onDelN();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
					"		<operate href=\"javascript:onShare();\" text=\""+SystemEnv.getHtmlLabelName(19910,user.getLanguage())+"\" target=\"_self\" index=\"2\"/>"+
					"		<operate href=\"javascript:onMember();\" text=\""+SystemEnv.getHtmlLabelName(149,user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(2106,user.getLanguage())+"\" target=\"_self\" index=\"3\"/>"+
					"		<operate href=\"javascript:onCaller();\" text=\""+SystemEnv.getHtmlLabelName(2152,user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(19467,user.getLanguage())+"\" target=\"_self\" index=\"5\"/>"+
					"		</operates>";
	                 
	tableString +=  " </table>";
	//System.out.println(tableString);
	%>
	<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />


</body>
</html>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<script type="text/javascript">
var diag_vote;
var dlg;
if(window.top.Dialog){
	dlg = window.top.Dialog;
} else {
    dlg = Dialog;
}

function tableReload(){
	_table. reLoad();
}

function closeDialog(){
	//diag_vote.close();
	diag_vote.close();
}

function closeDlgARfsh(){
	//diag_vote.close();
	diag_vote.close();
	doSearchsubmit();
}

function doSearchsubmit(){
	$('#weaverA').submit();
}

function add(){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 600;
	diag_vote.Height = 350;
	diag_vote.Modal = true;
	diag_vote.checkDataChange = false;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(2104,user.getLanguage())%>";
	diag_vote.URL = "/meeting/Maint/MeetingTypeAddTab.jsp?dialog=1&subCompanyId="+<%=subid%>;
	diag_vote.show();
}

//删除
function onDelN(id){
	delN(id);
}

function delN(id){
	var ids = "";
	if(id==null ||id=="" || id == "NULL" || id == "Null" || id == "null"){
		$("input[name='chkInTableTag']").each(function(){
			if($(this).attr("checked"))			
				ids = ids +$(this).attr("checkboxId")+",";
		});
	} else {
		ids = id+",";
	}
	if(ids=="") { 
		Dialog.alert("<%=SystemEnv.getHtmlLabelName(32859,user.getLanguage())%>!") ;
	} else {
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(32860,user.getLanguage())%>？", function (){
					doDeleteType(ids);	
			});
	}
}

function doDeleteType(ids){
	$.post("/meeting/Maint/MeetingTypeCheck.jsp",{checkType:"delete",ids:ids},function(datas){
		var dataObj=null;
		if(datas != ''){
			dataObj=eval("("+datas+")");
		}
		if(wuiUtil.getJsonValueByIndex(dataObj, 0) == "0"){
			$.post("/meeting/Maint/MeetingTypeOperation.jsp",{method:"delete",ids:ids,subid:"<%=subid%>"},function(datas){
				doSearchsubmit();
			});
		} else {
			Dialog.alert(wuiUtil.getJsonValueByIndex(dataObj, 1)) ;
		}
	});
}


function resetCondtion(){
	jQuery("#names").val("");
	jQuery("#approvers").val("");
	jQuery("#approversspan").html("");
}

function preDo(){
	//tabSelectChg();
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#hoverBtnSpan").hoverBtn();
}


//$(".searchImg").bind("click",function(){
//     onBtnSearchClick();
//});

function onBtnSearchClick(){
	var name=$("input[name='t_name']",parent.document).val();
	$("input[name='names']").val(name);
	doSearchsubmit();
}

function toggleLeft(){
	var f = window.parent.document.getElementById("oTd1").style.display;

	if (f != null) {
		if (f==''){
			window.parent.document.getElementById("oTd1").style.display='none'; 
		}else{ 
			window.parent.document.getElementById("oTd1").style.display=''; 
		}
	}
}

function onEdit(id){
    url = "/meeting/Maint/MeetingTypeEditTab.jsp?dialog=1&id="+id+"&method=edit";
	showDialog(url);
}

function onShare(id){
    url = "/meeting/Maint/MeetingTypeEditTab.jsp?dialog=1&id="+id+"&method=share";
	showDialog(url);
}

function onMember(id){
    url = "/meeting/Maint/MeetingTypeEditTab.jsp?dialog=1&id="+id+"&method=member";
	showDialog(url);
}

function onService(id){
    url = "/meeting/Maint/MeetingTypeEditTab.jsp?dialog=1&id="+id+"&method=service";
	showDialog(url);
}

function onCaller(id){
    url = "/meeting/Maint/MeetingTypeEditTab.jsp?dialog=1&id="+id+"&method=caller";
	showDialog(url);
}

function showDialog(url){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	};
	diag_vote.currentWindow = window;
	diag_vote.Width = 650;
	diag_vote.Height = 550;
	diag_vote.Modal = true;
	diag_vote.checkDataChange = false;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(32861,user.getLanguage())%>";
	diag_vote.maxiumnable = true;
	diag_vote.URL = url;
	diag_vote.show();
}

</script>
 
