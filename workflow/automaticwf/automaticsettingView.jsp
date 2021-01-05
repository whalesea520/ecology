
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.interfaces.datasource.DataSource"%>
<%@ page import="weaver.general.StaticObj"%>

<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="GetFormDetailInfo" class="weaver.workflow.automatic.GetFormDetailInfo" scope="page" />
<% 
if(!HrmUserVarify.checkUserRight("intergration:automaticsetting",user)) {
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}
%>
<%
String setname = "";
String workflowid = "";
String datasourceid = "";
String workflowname = "";
String outermaintable = "";
String keyfield = "";
String datarecordtype = "";
String datarecordtable = "";
String requestid = "";
String FTriggerFlag = "";
String FTriggerFlagValue = "";
String outermainwhere = "";
String successback = "";
String failback = "";
String outerdetailtables = "";
String outerdetailwheres = "";
ArrayList outerdetailtablesArr = new ArrayList();
ArrayList outerdetailwheresArr = new ArrayList();
String typename = Util.null2String(request.getParameter("typename"));
String viewid = Util.null2String(request.getParameter("viewid"));
String formid = "";
String isbill = "";
RecordSet.executeSql("select * from outerdatawfset where id="+viewid);
if(RecordSet.next()){
    setname = Util.null2String(RecordSet.getString("setname"));
    workflowid = Util.null2String(RecordSet.getString("workflowid"));
    datasourceid = Util.null2String(RecordSet.getString("datasourceid"));
    formid = WorkflowComInfo.getFormId(workflowid);
    isbill = WorkflowComInfo.getIsBill(workflowid);
    workflowname = Util.null2String(WorkflowComInfo.getWorkflowname(workflowid));
    outermaintable = Util.null2String(RecordSet.getString("outermaintable"));
    keyfield = Util.null2String(RecordSet.getString("keyfield"));
    datarecordtype = Util.null2String(RecordSet.getString("datarecordtype"));
    datarecordtable = Util.null2String(RecordSet.getString("datarecordtable"));
    requestid = Util.null2String(RecordSet.getString("requestid"));
    FTriggerFlag = Util.null2String(RecordSet.getString("FTriggerFlag"));
    FTriggerFlagValue = Util.null2String(RecordSet.getString("FTriggerFlagValue"));
    outermainwhere = Util.null2String(RecordSet.getString("outermainwhere"));
    successback = Util.null2String(RecordSet.getString("successback"));
    failback = Util.null2String(RecordSet.getString("failback"));
    outerdetailtables = Util.null2String(RecordSet.getString("outerdetailtables"));
    outerdetailwheres = Util.null2String(RecordSet.getString("outerdetailwheres"));
    outerdetailtablesArr = Util.TokenizerString(outerdetailtables,",");
    outerdetailwheresArr = Util.TokenizerString(outerdetailwheres,",");
    if("".equals(keyfield))
    	keyfield = "id";
}
if("".equals(datarecordtype))
	datarecordtype = "1";
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
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23076,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(367,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(32367,user.getLanguage())+",javascript:getTest(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",automaticsettingEdit.jsp?typename="+typename+"&viewid="+viewid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",automaticsetting.jsp?typename="+typename+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name="frmmain" method="post" action="">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32367 ,user.getLanguage()) %>" class="e8_btn_top" onclick="getTest()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(93 ,user.getLanguage()) %>" class="e8_btn_top" onclick="onBackUrl('/workflow/automaticwf/automaticsettingEdit.jsp?typename=<%=typename %>&viewid=<%=viewid %>')"/>
			<span id="advancedSearch" class="advancedSearch" style='display:none;'><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=titlename%></span> 
</div>
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'>
</div>
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
  		 <wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		 <wea:item><span><%=setname%></span></wea:item>
		 <wea:item><%=SystemEnv.getHtmlLabelName(18104,user.getLanguage())%></wea:item>
		 <wea:item>
			<span><%=workflowname%></span>
		 </wea:item>
		 <wea:item><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%></wea:item>
		 <wea:item>
			<span><%=datasourceid%></span>
		 </wea:item>
		 <wea:item><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%></wea:item>
		 <wea:item><input type=text size=35 style='width:280px!important;' class=inputstyle value='<%=outermaintable%>' disabled></wea:item>
		 <wea:item><%=SystemEnv.getHtmlLabelName(32368,user.getLanguage())%></wea:item><!-- 外部主表/视图的关键字段 -->
		 <wea:item><%=keyfield %></wea:item>
		 <wea:item><%=SystemEnv.getHtmlLabelName(32369,user.getLanguage())%></wea:item><!-- 是否回写标志到外部主表 -->
		 <wea:item>
			<%
			if("1".equals(datarecordtype)) 
				out.print(SystemEnv.getHtmlLabelName(161,user.getLanguage()));
			else if("2".equals(datarecordtype))
				out.print(SystemEnv.getHtmlLabelName(163,user.getLanguage())); 
			%>
		</wea:item>
    <%if("2".equals(datarecordtype)){ %>
		 <wea:item><%=SystemEnv.getHtmlLabelName(32370,user.getLanguage())%></wea:item><!-- 触发成功回写流程ID字段 -->
		 <wea:item><%=requestid %></wea:item>
		 <wea:item><%=SystemEnv.getHtmlLabelName(32371,user.getLanguage())%></wea:item><!-- 触发成功回写标志字段 -->
		 <wea:item><%=FTriggerFlag %>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(32372,user.getLanguage())%>&nbsp;&nbsp;:&nbsp;&nbsp;<%=FTriggerFlagValue %></wea:item>
	
	<%} %>
		<wea:item><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></wea:item>
		 <wea:item>
			<textarea cols=100 rows=4 disabled><%=outermainwhere%></textarea>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(23107,user.getLanguage())%></wea:item>
		 <wea:item>
			<%=SystemEnv.getHtmlLabelName(23108,user.getLanguage())%>:<br>
			<textarea cols=100 rows=4 disabled><%=successback%></textarea><br>
			<%=SystemEnv.getHtmlLabelName(23109,user.getLanguage())%>:<br>
			<textarea cols=100 rows=4 disabled><%=failback%></textarea>
		</wea:item>
	<%
	int detailcount = GetFormDetailInfo.getDetailNum(formid,isbill);
	for(int i=0;i<detailcount;i++){
	    String outerdetailtable = "";
	    String outerdetailwhere = "";
	    if(outerdetailtablesArr.size()>i){//数组越界
	        outerdetailtable = (String)outerdetailtablesArr.get(i);
	        outerdetailwhere = (String)outerdetailwheresArr.get(i);
	    }
	    if(outerdetailtable.equals("-")) outerdetailtable = "";
	    if(outerdetailwhere.equals("-")) outerdetailwhere = "";
	%>
		 <wea:item><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%><%=i+1%></wea:item>
		 <wea:item><input type=text size=35 class=inputstyle value='<%=outerdetailtable%>' disabled></wea:item>
	
		<wea:item><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%><%=i+1%><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></wea:item>
		 <wea:item>
			<textarea cols=100 rows=4 disabled><%=outerdetailwhere%></textarea>
		</wea:item>
	<%}%>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>' attributes="{'samePair':'RemarkInfo','groupOperDisplay':'none','itemAreaDisplay':'none'}">
		<wea:item attributes="{'colspan':'2'}">
			<font style="word-break:break-all;">
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1:<%=SystemEnv.getHtmlLabelName(23111,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(23154,user.getLanguage())%><BR>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2:<%=SystemEnv.getHtmlLabelName(23110,user.getLanguage())%><BR>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3:<%=SystemEnv.getHtmlLabelName(23152,user.getLanguage())%><BR>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4:<%=SystemEnv.getHtmlLabelName(31318,user.getLanguage())%><br>
			</font>
		</wea:item>
	</wea:group>
 </wea:layout>
</form>
</body>
</html>
<script type="text/javascript">
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle();
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#advancedSearch").bind("click", function(){
	});
});
function getTest()
{
    var datasourceid = "<%=datasourceid%>";//数据源
	var outermaintable = '<%=outermaintable%>';//外部主表
	var datarecordtype = '<%=datarecordtype%>';//
	var keyfield = '<%=keyfield%>';//
	var requestid = '<%=requestid%>';//
	var FTriggerFlag = '<%=FTriggerFlag%>';//
	var FTriggerFlagValue = '<%=outermaintable%>';//
    
    var timestamp = (new Date()).valueOf();
    var params = "operation=check&datasourceid="+datasourceid+"&outermaintable="+outermaintable+"&datarecordtype="+datarecordtype+"&keyfield="+keyfield+"&requestid="+requestid+"&FTriggerFlag="+FTriggerFlag+"&timestamp="+timestamp;
    //alert(params);
    jQuery.ajax({
        type: "POST",
        url: "/workflow/automaticwf/automaticCheck.jsp",
        data: params,
        success: function(msg){
            if(jQuery.trim(msg)=="true")
            {
            	alert("<%=SystemEnv.getHtmlLabelName(32373,user.getLanguage())%>")//测试通过，配置正确!
            }
            else
            {
            	alert("<%=SystemEnv.getHtmlLabelName(32374,user.getLanguage())%>")//测试不通过，配置不正确，请检查配置!
            }
        }
    });
}
function onBackUrl(url)
{
	document.location.href=url;
}
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



function onShowWorkFlowSerach(inputename, tdname) {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp"
			, $GetEle(tdname)
			, $GetEle(inputename)
			, true);
}
</script>
