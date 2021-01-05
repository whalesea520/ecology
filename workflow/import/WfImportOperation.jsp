
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.*,javax.servlet.jsp.JspWriter" %>
<%@ page import="weaver.workflow.workflow.WorkflowVersion" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowDataService" class="weaver.workflow.imports.services.WorkflowDataService" scope="page" />
<%!
String getImportTitle(int type,User user){
	String title = "";
	switch(type){
		case 0:
			title = "htmllabel";
			break;
		case 1:
			title = SystemEnv.getHtmlLabelName(82315, user.getLanguage());
			break;
		case 2:
			title = SystemEnv.getHtmlLabelName(82316, user.getLanguage());
			break;
		case 3:
			title = SystemEnv.getHtmlLabelName(82317, user.getLanguage());
			break;
		case 4:
			title = SystemEnv.getHtmlLabelName(82318, user.getLanguage());
			break;
		case 5:
			title = "select" +SystemEnv.getHtmlLabelName(15601, user.getLanguage());
			break;
		case 6:
			title = SystemEnv.getHtmlLabelName(82319, user.getLanguage());
			break;
		case 7:
			title = SystemEnv.getHtmlLabelName(82320, user.getLanguage());
			break;
		case 8:
			title = SystemEnv.getHtmlLabelName(16579, user.getLanguage());
			break;
		case 9:
			title = SystemEnv.getHtmlLabelName(129258, user.getLanguage());
			break;
		case 10:
			title = SystemEnv.getHtmlLabelName(129261, user.getLanguage());
			break;
		case 11:
			title = SystemEnv.getHtmlLabelName(129262, user.getLanguage());
			break;
		case 12:
			title = SystemEnv.getHtmlLabelName(17750, user.getLanguage());
			break;
		case 13:
			title = SystemEnv.getHtmlLabelName(21393, user.getLanguage());
			break;
		case 14:
			title = SystemEnv.getHtmlLabelName(129264, user.getLanguage());
			break;
		case 15:
			title = SystemEnv.getHtmlLabelName(18010, user.getLanguage());
			break;
		case 16:
			title = SystemEnv.getHtmlLabelName(129266, user.getLanguage());
			break;
		case 17:
			title = SystemEnv.getHtmlLabelName(129267, user.getLanguage());
			break;
		case 18:
			title = "html" +SystemEnv.getHtmlLabelName(129269, user.getLanguage());
			break;
		case 19:
			title = SystemEnv.getHtmlLabelName(129270, user.getLanguage());
			break;
		case 20:
			title = SystemEnv.getHtmlLabelName(129271, user.getLanguage());
			break;
		case 21:
			title = SystemEnv.getHtmlLabelName(34068, user.getLanguage());
			break;
		case 22:
			title = SystemEnv.getHtmlLabelName(15606, user.getLanguage());
			break;
		case 23:
			title = SystemEnv.getHtmlLabelName(18361, user.getLanguage());
			break;
		case 24:
			title = SystemEnv.getHtmlLabelName(18812, user.getLanguage());
			break;
		case 25:
			title = SystemEnv.getHtmlLabelName(19501, user.getLanguage());
			break;
		case 26:
			title = SystemEnv.getHtmlLabelName(19502, user.getLanguage());
			break;
		case 27:
			title = SystemEnv.getHtmlLabelName(21220, user.getLanguage());
			break;
		case 28:
			title = SystemEnv.getHtmlLabelName(19331, user.getLanguage());
			break;
		case 29:
			title = SystemEnv.getHtmlLabelName(19344, user.getLanguage());
			break;
		case 30:
			title = SystemEnv.getHtmlLabelName(22118, user.getLanguage());
			break;
		case 31:
			title = SystemEnv.getHtmlLabelName(24086, user.getLanguage());
			break;
		case 32:
			title = SystemEnv.getHtmlLabelName(22231, user.getLanguage());
			break;
		case 33:
			title = SystemEnv.getHtmlLabelName(21684, user.getLanguage());	
			break;
		case 34:
			title = SystemEnv.getHtmlLabelName(21848, user.getLanguage());
			break;
		case 35:
			title = SystemEnv.getHtmlLabelName(129365, user.getLanguage());
			break;
		default:
			title = "";
			break;
	}
	return title;
		
}
%>
<%
String status = "";
String acceptlanguage = request.getHeader("Accept-Language");
if(!"".equals(acceptlanguage))
	acceptlanguage = acceptlanguage.toLowerCase();

if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
FileUpload fu = new FileUpload(request,false);
FileManage fm = new FileManage();

String xmlfilepath="";
int fileid = 0 ;
String remoteAddr = fu.getRemoteAddr();
fileid = Util.getIntValue(fu.uploadFiles("filename"),0);
String type = Util.null2String(fu.getParameter("type"));
String filename = fu.getFileName();

List<String> allowFileTypes = new ArrayList<String>();
allowFileTypes.add(".xml");
if(FileType.validateFileExt(filename,allowFileTypes)) {
String sql = "select filerealpath,isaesencrypt,aescode from imagefile where imagefileid = "+fileid;
RecordSet.executeSql(sql);
String uploadfilepath="";
String isaesencrypt = "";
String aescode = "";
if(RecordSet.next()){
	uploadfilepath =  RecordSet.getString("filerealpath");
	isaesencrypt = Util.null2String(RecordSet.getString("isaesencrypt"));
	aescode = Util.null2String(RecordSet.getString("aescode"));
}
String exceptionMsg ="";
if(!uploadfilepath.equals(""))
{
	try
	{
		filename = System.currentTimeMillis() + ".xml";
		xmlfilepath = GCONST.getRootPath()+"workflow/import"+File.separatorChar+filename ;
		//System.out.println("xmlfilepath : "+xmlfilepath);
		File oldfile = new File(xmlfilepath);
		if(oldfile.exists())
		{
			oldfile.delete();
		}
		fm.copy(uploadfilepath,xmlfilepath);
	}
	catch(Exception e)
	{
		exceptionMsg = SystemEnv.getHtmlLabelName(82340, user.getLanguage());
	}
}
WorkflowDataService.setRemoteAddr(remoteAddr);
WorkflowDataService.setUser(user);
WorkflowDataService.setType(type);
if(isaesencrypt.equals("1")){
	WorkflowDataService.importWorkflowByXml(xmlfilepath,isaesencrypt,aescode);
}else{
	WorkflowDataService.importWorkflowByXml(xmlfilepath);
}
String workflowid = WorkflowDataService.getWorkflowid();
String formid = WorkflowDataService.getFormid();
String isbill = WorkflowDataService.getIsbill();
Map fieldMap = WorkflowDataService.getFieldMap();
Map nodeMap = WorkflowDataService.getNodeMap();
List oldFieldIds = new ArrayList();
List newFieldIds = new ArrayList();
if(null!=fieldMap)
{
	Set oldIds = fieldMap.keySet();
	for(Iterator it = oldIds.iterator();it.hasNext();)
	{
		String fieldid = (String)it.next();
		
		oldFieldIds.add(fieldid);
		newFieldIds.add(fieldMap.get(fieldid));
	}
}

List oldNodeIds = new ArrayList();
List newNodeIds = new ArrayList();
if(null!=nodeMap){
	Set oldIds = nodeMap.keySet();
	for(Iterator it = oldIds.iterator();it.hasNext();){
		String nodeid = (String)it.next();
		
		oldNodeIds.add(nodeid);
		newNodeIds.add(nodeMap.get(nodeid));
	}
}

//导入成功后，将流程id记录到版本信息中
WorkflowVersion wv=new WorkflowVersion();
wv.saveWorkflowVersionInfo(workflowid);
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>  
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<%if(acceptlanguage.indexOf("zh-tw")>-1||acceptlanguage.indexOf("zh-hk")>-1){%>
<script language=javascript src="/workflow/mode/chinaexcelweb_tw_wev8.js"></script>
<%}else{%>
<script language=javascript src="/workflow/mode/chinaexcelweb_wev8.js"></script>
<%} %>
<script language=javascript>
function displayExcel(){
	var divs = document.getElementsByTagName("div");
	if(divs){
		divs[0].style.display="none";
	}
}
var oldFieldIds = new Array();
var newFieldIds = new Array();

<%
for(int i=0;i<oldFieldIds.size();i++){
	String id = (String)oldFieldIds.get(i);
%>
	oldFieldIds.push(<%=id%>);
<%
}
%>
<%
for(int i=0;i<newFieldIds.size();i++){
	String id = (String)newFieldIds.get(i);
%>
	newFieldIds.push(<%=id%>);
<%
}
%>
var oldNodeIds = new Array();
var newNodeIds = new Array();
<%
for(int i=0;i<oldNodeIds.size();i++){
	String id = (String)oldNodeIds.get(i);
%>
	oldNodeIds.push(<%=id%>);
<%
}
%>
<%
for(int i=0;i<newNodeIds.size();i++){
	String id = (String)newNodeIds.get(i);
%>
	newNodeIds.push(<%=id%>);
<%
}
%>
function getIndex(newids,oldids,oldid){
	var newid = "";
	var index = -1;
	try{
		for (i = 0; i < oldids.length; i++){
	   		var tempoldid = oldids[i];
	   		if(oldid==tempoldid){
	   			index = i;
	   		}
	   	}
	   	if(index>-1){
	   		newid = newids[index];
	   	}
   	}
   	catch(e){}
   	return newid;
}
function readmode(){
<%
RecordSet.executeSql("select * from workflow_formmode where formid="+formid+" and isbill="+isbill);
int selectSize = RecordSet.getCounts();
while(RecordSet.next()){
	String modeid = RecordSet.getString("id");
	String isprint = RecordSet.getString("isprint");
%>
	CellWeb1.ReadHttpFile("/workflow/mode/ModeReader.jsp?modeid=<%=modeid%>&isform=<%=isbill%>");
	//CellWeb1.ReadHttpFile("/workflow/mode/ModeReader.jsp?modeid=<%=modeid%>&isform=1");
    var Cols = CellWeb1.GetMaxCol();
    var Rows = CellWeb1.GetMaxRow();
    
    for(var i = 1;i<=Cols;i++){
    	for(var j = 1;j<=Rows;j++){
    		var isProtect = CellWeb1.IsCellProtect(j,i);
    		CellWeb1.SetCellProtect(j,i,j,i,false);
    		var cellvalue = CellWeb1.GetCellUserStringValue(j,i);
    		cellvalue = cellvalue.replace(/(^\s*)|(\s*$)/g, "");
    		if(cellvalue.length>1){
    			if(cellvalue.indexOf("field")==0){
    				var oldid = cellvalue.substring(5,cellvalue.indexOf("_"));
    				
    				var newid = getIndex(newFieldIds,oldFieldIds,oldid);
    				if(newid!=""){
    					cellvalue = cellvalue.replace("field"+oldid+"_","field"+newid+"_")
    					CellWeb1.SetCellUserStringValue(j,i,j,i,cellvalue);
    				}
    			}else if(cellvalue.indexOf("wfl")==0){
    				var oldid = cellvalue.substring(cellvalue.indexOf("_")+1,cellvalue.length);
    				var newid = getIndex(newNodeIds,oldNodeIds,oldid);
    				if(newid!="")
    				{
    					//cellvalue = cellvalue.replace("_"+oldid,"_"+newid)
    					cellvalue = "wfl<%=workflowid%>_"+newid;
    					CellWeb1.SetCellUserStringValue(j,i,j,i,cellvalue);
    				}
    			}
    		}
    		CellWeb1.SetCellProtect(j,i,j,i,isProtect);
    	}
    }
    var modestring = CellWeb1.SaveDataAsZipText();
    //saveNewMode('<%=modeid%>','<%=isprint%>',modestring);
    saveNewMode('<%=modeid%>','<%=isprint%>',modestring,"<%=isbill%>");
<%
selectSize--;
}
RecordSet.executeSql("select * from workflow_nodemode where workflowid = "+workflowid+" and formid="+formid);
selectSize = RecordSet.getCounts();
while(RecordSet.next()){
	String modeid = RecordSet.getString("id");
	String nodeid = RecordSet.getString("nodeid");
	String isprint = RecordSet.getString("isprint");
	
%>
	
    CellWeb1.ReadHttpFile("/workflow/mode/ModeReader.jsp?modeid=<%=modeid%>&nodeid=<%=nodeid%>&isform=0");
    var Cols = CellWeb1.GetMaxCol();
    var Rows = CellWeb1.GetMaxRow();
    for(var i = 1;i<=Cols;i++){
    	for(var j = 1;j<=Rows;j++){
    		var isProtect = CellWeb1.IsCellProtect(j,i);
    		CellWeb1.SetCellProtect(j,i,j,i,false);
    		var cellvalue = CellWeb1.GetCellUserStringValue(j,i);
    		cellvalue = cellvalue.replace(/(^\s*)|(\s*$)/g, "");
    		if(cellvalue.length>1){
    			if(cellvalue.indexOf("field")==0){
    				var oldid = cellvalue.substring(5,cellvalue.indexOf("_"));
    				
    				var newid = getIndex(newFieldIds,oldFieldIds,oldid);
    				if(newid!=""){
    					cellvalue = cellvalue.replace("field"+oldid+"_","field"+newid+"_");
    					CellWeb1.SetCellUserStringValue(j,i,j,i,cellvalue);
    				}
    			}else if(cellvalue.indexOf("wfl")==0){
    				var oldid = cellvalue.substring(cellvalue.indexOf("_")+1,cellvalue.length);
    				var newid = getIndex(newNodeIds,oldNodeIds,oldid);
    				if(newid!=""){
    					//cellvalue = cellvalue.replace("_"+oldid,"_"+newid)
    					cellvalue = "wfl<%=workflowid%>_"+newid;
    					CellWeb1.SetCellUserStringValue(j,i,j,i,cellvalue);
    				}
    			}
    		}
    		CellWeb1.SetCellProtect(j,i,j,i,isProtect);
    	}
    }
    var modestring = CellWeb1.SaveDataAsZipText();
    //saveNewMode('<%=modeid%>','<%=isprint%>',modestring);
    saveNewMode('<%=modeid%>','<%=isprint%>',modestring,"0");
<%
selectSize--;
}
%>
}
function saveNewMode(modeid,isprint,modestring,isform){
	var xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
	xmlHttp.onreadystatechange = function(){
		if (xmlHttp.readyState == 4){
	    }
	}
	xmlHttp.open("POST", "/workflow/export/wf_operationxml.jsp", true);
	xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	modestring = escape(modestring).replace(/\+/g, '%2B').replace(/\"/g,'%22').replace(/\'/g, '%27').replace(/\//g,'%2F')
	//xmlHttp.send("src=savemode&modeid="+modeid+"&isprint="+isprint+"&modestring="+modestring);
	xmlHttp.send("src=savemode&isform="+isform+"&modeid="+modeid+"&isprint="+isprint+"&modestring="+modestring);
}
</script>
</head>
<BODY onload="displayExcel();">
<div>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(33659,user.getLanguage()) %>"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		    <input type="button" value='<%=SystemEnv.getHtmlLabelNames("33564,15069",user.getLanguage()) %>' class="e8_btn_top" onclick="viewWfBaseData();"/>
		    <script>
		    	function viewWfBaseData(){
		    		window.open("/system/basedata/basedata_workflow.jsp?wfid=<%=workflowid %>","_blank");
		    	}
		    </script>
		</td>
	</tr>
</table>
<wea:layout type="2col">
	<wea:group context="<%=SystemEnv.getHtmlLabelName(82341, user.getLanguage())%>">
		<wea:item>
			<table class=ListStyle cellspacing=0 id="result">
				<COLGROUP>
					<COL width="25%">
					<COL width="25%">
					<COL width="30%">
					<COL width="15%">
					<COL width="5%">
				</COLGROUP>
				<tr class=header>
					<td><%=SystemEnv.getHtmlLabelName(31830, user.getLanguage())%>id</td>
					<td><%=SystemEnv.getHtmlLabelName(21900, user.getLanguage())%></td>
					<td><%=SystemEnv.getHtmlLabelName(104, user.getLanguage())%></td>
					<td><%=SystemEnv.getHtmlLabelName(433, user.getLanguage())%></td>
					<td><%=SystemEnv.getHtmlLabelName(82342, user.getLanguage())%></td>
				</tr>
<%
	exceptionMsg = Util.null2String(WorkflowDataService.getExceptionMsg());
	Map MsgMap = WorkflowDataService.getMsgMap();
	
	if(MsgMap!=null){
	    if (MsgMap.size() > 0) {
	    	List MsgList = new ArrayList(); 
	    	Map msg = new HashMap();
	    	String title = "";
	    	for(int i = 0;i<35;i++){
	    		MsgList = (List)MsgMap.get(""+i);
	    		if(MsgList!=null){
	    			if(MsgList.size()>0){
	    				title = getImportTitle(i,user);
	    				out.println("<TR class=Title><TH colSpan=5 align='center'>"+title+"</TH></TR>");
	    				for(int j=0;j<MsgList.size();j++){
		                	msg.clear();
		                	msg = (Map)MsgList.get(j);
		                	status = (String)msg.get("status");
		                	if(status.equals("1")){
		                		status = "成功";
		                	}else{
		                		status = "失败";
		                	}
		    	            out.println("<tr class='DataLight'>");
		    	            out.println("<td>"+msg.get("key")+"</td>");
		    	            out.println("<td>"+msg.get("tablename")+"</td>");
		    	            out.println("<td style='word-break:break-all;'>"+msg.get("msgname")+"</td>");
		    	            out.println("<td style='word-break:break-all;'>"+msg.get("desc")+"</td>");
		    	            out.println("<td>"+status+"</td>");
		    	            out.println("</tr>");
		                }
	    			}
	    		}
	    	}
	    }
    }		
%>
			</table>
		</wea:item>
	</wea:group>
<% 
	if(!exceptionMsg.equals("")){
%>
	<wea:group context="<%=SystemEnv.getHtmlLabelName(129366, user.getLanguage())%>" attributes="{'itemAreaDisplay':'block'}">
		<wea:item><%=exceptionMsg %></wea:item>
	</wea:group>
<% 
	}
%>
</wea:layout>
</div>
<%} %>
<script type="text/javascript">
jQuery(document).ready(function(){
	try{
		readmode();		//chrome下报错
	}catch(e){}
	if("<%=status%>" === "成功")
		window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(33970,user.getLanguage())%>');
	else
		window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(33971,user.getLanguage())%>');
});
</script>
</BODY>
</HTML>