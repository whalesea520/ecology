
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.common.StringUtil"%> 
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<style>
</style>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(378,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY style="width: 100%;">
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
Map<String,String> wfMap = new HashMap<String,String>();
List<String> wfList = new ArrayList<String>();
String sqlCount = " select count(1) wfcnt,workflowtype from workflow_base where  id in (select field001 from hrm_att_proc_set where field005 = 1) group by workflowtype order by workflowtype ";
RecordSet.executeSql(sqlCount);
while(RecordSet.next()){
	wfList.add(RecordSet.getString("workflowtype"));
	wfMap.put(RecordSet.getString("workflowtype"),RecordSet.getString("wfcnt"));
}
Map<String,List<String>> wfMapids = new HashMap<String,List<String>>();
List<String> wfListid = new ArrayList<String>();

String sql = "select id,workflowtype from workflow_base where  id in (select field001 from hrm_att_proc_set where field005 = 1) ";
RecordSet.executeSql(sql);
while(RecordSet.next()){
	String field001 = RecordSet.getString("id");
	String workflowtype = RecordSet.getString("workflowtype");
	if(wfMapids.get(workflowtype) != null){
		List<String> tmpwfListid = wfMapids.get(workflowtype);
		tmpwfListid.add(field001);
	}else{
		wfListid = new ArrayList<String>();
		wfListid.add(field001);
		wfMapids.put(workflowtype,wfListid);
	}
}


%>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div style="height: 20px;"></div>
<%
int increment=0;
int size = wfList.size();
int tdNum=0;
String[][] color={{"#166ca5","#953735","#01b0f1"},{"#767719","#f99d52","#cf39a4"}};
int colorindex=0;
%>
<div style="width: 100%;overflow: auto;">
<table  style='width:98%;border-collapse: collapse; border: 0px;table-layout: auto;' >
<%
	for(int i = 0 ; i<size; i++){
		String tmpType = wfList.get(i);
		increment++;
		if(increment%3==1){
%>
 <tr>
	<td width="25px"></td>
<%} %>
	<td style="width:30%;white-space: nowrap;text-overflow: ellipsis;word-wrap:break-word; " align="left" valign="top">
		<div class="titleitem" style="border-bottom:2px solid #e4e4e4;height: 25px;">
        	<div class="titlecontent main" style="border-bottom:2px solid <%=color[colorindex%2][tdNum]%>;height:100%;float:left;">
	        	<label title="<%=WorkTypeComInfo.getWorkTypename(tmpType) %>"><%=StringUtil.vString(WorkTypeComInfo.getWorkTypename(tmpType),10)%>
	        	<font color="#989898" style="font-weight: 400;margin-left:5px;">(<%=wfMap.get(tmpType)%>)</font>
	        	</label>
        	</div>     
		</div>
			<%
				List<String> tmpWFs = wfMapids.get(tmpType);
				for(String wfid : tmpWFs){
			%>
				<div class="fontItem" style="line-height:30px;">
					<img name="esymbol" src="/images/ecology8/request/workflowTitle_wev8.png" style="vertical-align: middle;">
					<a class="e8contentover" title="<%=WorkflowComInfo.getWorkflowname(wfid) %>" style="margin-left:8px;margin-right:10px;cursor: pointer;" onclick="javascript:onNewRequest(<%=wfid %>,0,0);">
					  <%=StringUtil.vString(WorkflowComInfo.getWorkflowname(wfid),20) %>
                    </a>
				</div>
			<%		
				}
			%>
	</td>
	<td width="25px"></td>
<%
if(increment%3==0){
%>
	<td width="25px"></td>
	</tr>
<%
	}
colorindex++;
tdNum++;
if(tdNum > 2){
	tdNum = 0;
}
}
%>	
</table>
</div>

<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
function onNewRequest(wfid,agent,beagenter){
    var redirectUrl = "/workflow/request/AddRequest.jsp?workflowid="+wfid+"&isagent="+agent+"&beagenter="+beagenter+"&f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>";
    var width = screen.availWidth-10 ;
    var height = screen.availHeight-50 ;
    var szFeatures = "top=0," ;
    szFeatures +="left=0," ;
    szFeatures +="width="+width+"," ;
    szFeatures +="height="+height+"," ;
    szFeatures +="directories=no," ;
    szFeatures +="status=yes,toolbar=no,location=no," ;
    szFeatures +="menubar=no," ;
    szFeatures +="scrollbars=yes," ;
    szFeatures +="resizable=yes" ; //channelmode
    window.open(redirectUrl,"",szFeatures) ;
}
</script>

   <%if("1".equals(isDialog)){ %>
   </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout>
			<wea:group context="">
				<wea:item type="toolbar">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
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
</BODY></HTML>
