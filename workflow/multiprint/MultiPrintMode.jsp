
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,weaver.general.BaseBean" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/css/rp_wev8.css" rel="STYLESHEET" type="text/css">
<script language=javascript src="/js/weaver_wev8.js"></script>
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
BaseBean bb_printmode = new BaseBean();
int urm_printmode = 1;
try{
	urm_printmode = Util.getIntValue(bb_printmode.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}
RCMenu += "{"+SystemEnv.getHtmlLabelName(20756,user.getLanguage())+",javascript:doPrintSet(),_top}" ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(257,user.getLanguage())+",javascript:doPrint(),_top}" ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<BODY id="flowbody" style="overflow:auto">
<input type="hidden" id="nPrintOrient" name="nPrintOrient" value="1">
<iframe id="setprinttypeiframe" name="setprinttypeiframe" src="" style="display:none"></iframe>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class="viewform">
		<tr>
		<td width="100%" height=100% valign="top" align="center">
<table class="viewform" width="100%">
<%
String multirequestid = Util.null2String(request.getParameter("multirequestid"));
if("".equals("multirequestid")){
%>
	<script language=javascript>
	alert("<%=SystemEnv.getHtmlLabelName(26427,user.getLanguage())%>");
	window.close();
	</script>
<%
	return;
}
int workflowid = 0;
int nodeid = 0;
int isbill = 0;
String formid = "";
int billid = 0;
String ismode="";
int modeid=0;
int isform=0;
int printdes=0;

//标识是否有可打印的流程
boolean hasPrintModeWf = false;

ArrayList requestidList = new ArrayList();
ArrayList wfidList = new ArrayList();
String passrequestids = "";
rs.executeSql("select * from workflow_requestbase where requestid in ("+multirequestid+"0) order by requestid");
while(rs.next()){
	int requestid = Util.getIntValue(rs.getString("requestid"), 0);
	if(requestid == 0){
		continue;
	}
	workflowid = Util.getIntValue(rs.getString("workflowid"), 0);
	requestidList.add(""+requestid);
	wfidList.add(""+workflowid);
}

if(requestidList.size()<1){
%>
<script language=javascript>
	alert("<%=SystemEnv.getHtmlLabelName(26427,user.getLanguage())%>");
	window.close();
	</script>
<%
	return;
}
int userid=user.getUID();                   //当前用户id
String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
for(int i=0; i<requestidList.size(); i++){
	int requestid = Util.getIntValue((String)requestidList.get(i), 0);
	if(!requestidList.contains(""+requestid)){
		continue;
	}
	nodeid = WFLinkInfo.getCurrentNodeid(requestid,userid,Util.getIntValue(logintype,1));               //节点id
	workflowid = Util.getIntValue((String)wfidList.get(i));
	RecordSet.execute("select * from workflow_base where id="+workflowid);
	if(RecordSet.next()){
		isbill = Util.getIntValue(RecordSet.getString("isbill"), 0);
		formid = Util.null2String(RecordSet.getString("formid"));
	}
	if(isbill == 1){
		RecordSet.executeProc("workflow_form_SByRequestid", requestid+"");
		if(RecordSet.next()){
			billid = Util.getIntValue(RecordSet.getString("billid"));
		}
	}
	RecordSet.executeSql("select ismode,printdes,toexcel from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
	if(RecordSet.next()){
	    ismode=Util.null2String(RecordSet.getString("ismode"));
	    printdes=Util.getIntValue(Util.null2String(RecordSet.getString("printdes")),0);
	}
	if(printdes!=1){
	    RecordSet.executeSql("select id from workflow_nodemode where isprint='1' and workflowid="+workflowid+" and nodeid="+nodeid);
	    if(RecordSet.next()){
	        modeid=RecordSet.getInt("id");
	    }else{
	        RecordSet.executeSql("select id from workflow_formmode where formid="+formid+" and isbill='"+isbill+"' order by isprint desc");
	        while(RecordSet.next()){
	            if(modeid<1){
	                modeid=RecordSet.getInt("id");
	                isform=1;
	            }
	        }
	    }
	}
	if(modeid<1){
		continue;
	}
	//只要有一个可打印的流程，则改变此flag 的状态
	hasPrintModeWf = true;
%>
<tr>
<td align="center" width="100%">
<iframe id="requestiframe<%=requestid%>" name="requestiframe<%=requestid%>" scrolling="no" marginheight="0" marginwidth="0" allowTransparency="true" frameborder="0" style="overflow-x:visible;overflow-y:visible;" src="/workflow/request/PrintMode.jsp?requestid=<%=requestid%>&isbill=<%=isbill%>&workflowid=<%=workflowid%>&formid=<%=formid%>&nodeid=<%=nodeid%>&billid=<%=billid%>&fromFlowDoc=1&passrequestids=<%=passrequestids%>&ismultiprintmode=1"></iframe>
</td>
</tr>
<%
passrequestids += (requestid+",");
}%>
</table>

</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
</body>

<script type="text/javascript">

if (<%=!hasPrintModeWf%> || <%=!"true".equals((String)session.getAttribute("browser_isie"))%>) {
	alert("<%=SystemEnv.getHtmlLabelName(84014 ,user.getLanguage())%>");
	window.close();
}

</script>

<script language="javascript">
function doPrint(){
	//1：纵向；2：横向
	var nPrintOrient = document.getElementById("nPrintOrient").value;
	var intvalue = 1;
	if(nPrintOrient=="1"){
		intvalue = 1;
	}else{
		intvalue = 2;
	}
	<%
	for(int i=0; i<requestidList.size(); i++){
		int requestid = Util.getIntValue((String)requestidList.get(i), 0);
		if(!requestidList.contains(""+requestid)){
			continue;
		}
	%>
	try{
		var frameObj = document.getElementById("requestiframe<%=requestid%>").contentWindow;
		frameObj.document.frmmain.ChinaExcel.SetPrintOrient(intvalue);
		frameObj.document.frmmain.ChinaExcel.PrintFile();
	}catch(e){
	}
	<%}%>
	 
	document.getElementById("setprinttypeiframe").src = "/workflow/multiprint/Setprinttypeiframe.jsp?multirequestid=<%=passrequestids%>";
}
function doPrintSet(){
	var url = "/workflow/workflow/BrowserMain.jsp?url=/workflow/multiprint/MultiPrintSet.jsp";
	var con = window.showModalDialog(url);
	if(con != undefined){
		document.getElementById("nPrintOrient").value = con;
	}
}
</script>
</html>