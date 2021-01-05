
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("WorkflowReportManage:All", user)){
	 	response.sendRedirect("/notice/noright.jsp");
	 	return;
	}
%>
<%
String id = Util.null2String(request.getParameter("id"));
String reportType = Util.null2String(request.getParameter("reportType"));

String wfid = Util.null2String(request.getParameter("wfid"));
String isbill = Util.null2String(request.getParameter("isbill"));

String isfrom = Util.null2String(request.getParameter("isfrom"));
RecordSet.executeProc("Workflow_Report_SelectByID",id);
RecordSet.next();
String formID = Util.null2String(RecordSet.getString("formID"));
String url = "";
//权限控制
int operatelevel = 0;
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
if(detachable == 1){
	String subcompanyid= Util.null2String(RecordSet.getString("subcompanyid"));
	operatelevel = checkSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "WorkflowReportManage:All", Util.getIntValue(subcompanyid,0));
}else{
    operatelevel = 2;
}

if("reportShare".equals(isfrom)){
	url = "/workflow/report/ReportShare.jsp?id="+id+"&operatelevel="+operatelevel;
}else if("listform".equals(isfrom)){
	url = "/workflow/report/ReportShare.jsp?id="+id+"&operatelevel="+operatelevel;
}else{
	url = "/workflow/report/ReportEdit.jsp?id="+id+"&operatelevel="+operatelevel;
}
String isBill = Util.null2String(RecordSet.getString("isBill"));
%>
<html>
<head>	
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
    <style type="text/css">
    	.tablenameCheckLoading{
    		background: url('/images/messageimages/loading_wev8.gif') no-repeat;
    		padding-left: 18px;
    	}
		.tablenameCheckSuccess{
			background: url('/images/BacoCheck_wev8.gif') no-repeat;
			padding-left: 18px;
			background-position: left 2px;
		}
		.tablenameCheckError{
			background: url('/images/BacoCross_wev8.gif') no-repeat;
			padding-left: 18px;
			color: red;
			background-position: left 2px;
		}
	</style> 
<% 
String navName = ""+SystemEnv.getHtmlLabelName(15514 ,user.getLanguage());  
%>	
    <script type="text/javascript">
    var parentWin = null;
		var dialog = null;
		try{
			parentWin = parent.getParentWindow(window);
			dialog =parent.getDialog(window);
		}catch(e){}
    
    
	$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        mouldID:"<%=MouldIDConst.getID("workflow")%>",
        iframe:"tabcontentframe",
        staticOnLoad:true,
        objName:"<%=navName%>"
   	 });
	}); 
	</script>
</head>
<body>

	<div class="e8_box demo2">
		  <div class="e8_boxhead">
		         <div class="div_e8_xtree" id="div_e8_xtree"></div>
	             <div class="e8_tablogo" id="e8_tablogo"></div>
			     <div class="e8_ultab">
				  <div class="e8_navtab" id="e8_navtab">
					 <span id="objName"></span>
				  </div>
			  <div>
		    <ul class="tab_menu">
	   		
	   		<%if("listform".equals(isfrom)){ %>
	   			<li>
	        		<a onclick="settab1()" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%></a>
	       		</li>
	       		<li>
		        	<a onclick="settab2()" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(15101, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(33331, user.getLanguage())%></a>
		        </li>	
				<li class="current">
		        	<a onclick="settab3()" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(19910, user.getLanguage())%></a>
		        </li>
	       	<%}else if("reportShare".equals(isfrom)){ %>
	       		<li >
	        		<a onclick="settab1()" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%></a>
	       		</li>
	       		<li >
		        	<a onclick="settab2()" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(15101, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(33331, user.getLanguage())%></a>
		        </li>	
				<li class="current">
		        	<a onclick="settab3()" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(19910, user.getLanguage())%></a>
		        </li>
	       	<%}else{ %>
	       		<li class="current">
	        		<a onclick="settab1()" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%></a>
	       		</li>
	       		<li>
		        	<a onclick="settab2()" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(15101, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(33331, user.getLanguage())%></a>
		        </li>	
				<li>
		        	<a onclick="settab3()" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(19910, user.getLanguage())%></a>
		        </li>
	       	<%} %>
		    </ul>
	    <div id="rightBox" class="e8_rightBox">
	    </div>
	     </div>
		</div>
	</div> 
	 <div class="tab_box">
	        <div>
	            <iframe src="<%=url %>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div> 
	
	
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
			    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="cancleClose()" style="width: 60px!important;">
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>

	<style type="text/css">
	.tab_box {
		bottom:30px;
	}
	</style>

</body>
</html>
<SCRIPT language="javascript">
 
   
	function viewSourceUrl(){
    prompt("",location);
	}
	
	function settab1(){
		$("#tabcontentframe").attr("src","/workflow/report/ReportEdit.jsp?id=<%=id%>&operatelevel=<%=operatelevel%>");
	}
	function settab2(){
		$("#tabcontentframe").attr("src","/workflow/report/ReportFieldAdd.jsp?id=<%=id%>&isBill=<%=isBill%>&formID=<%=formID%>&dbordercount=0&operatelevel=<%=operatelevel%>");
	}
	function settab3(){
		$("#tabcontentframe").attr("src","/workflow/report/ReportShare.jsp?id=<%=id%>&operatelevel=<%=operatelevel%>");
	}
	
	function addformtabsubmit0(obj){
		if(check_form(addformtabspecial,'formname,subcompanyid')){
            obj.disabled=true;
			doPost(addformtabspecial,tab1);
		}
	}
	function deleteform(){
	    if(isdel()){
	        addformtabspecial.action = "/workflow/form/delforms.jsp";
	        addformtabspecial.ajax.value="0";
	        addformtabspecial.submit();
	    }
	}
	
	function cancleClose(){
		if("<%=isfrom%>" == "listform" || "<%=isfrom%>" == "listform1"){
			parentWin.location="/workflow/workflow/ListFormByWorkflow.jsp?ajax=1&wfid=<%=wfid%>&formid=<%=formID%>&isbill=<%=isbill%>";
			dialog.close();
		}else{
			parentWin.location="/workflow/report/ReportManage.jsp?otype=<%=reportType%>";
			dialog.close();
		}
	}

	function addformtabretun(){
		//history.back(-1);
		//if("" == '1'){
		//	window.parent.close();
		//}else{
		//	document.location = "manageform.jsp";
		//}
	}
	
	var fieldid = new Array();
	var fieldlable = new Array();
	var curindex = 0;
	var currowcalexp = "";
	var groups="";
	
	function clearexp(){
	    currowcalexp = "";
	    groups="";
	    curindex=0;
		fieldid = new Array();
		fieldlable = new Array();

	    $G("rowcalexp").innerHTML="";		
		$G("curindex").value=curindex;				
	}
	
	function deleteRowcal(obj){
	    //alert(obj.parentElement.parentElement.parentElement.rowIndex);
	    if(confirm('<%=SystemEnv.getHtmlLabelName(18688,user.getLanguage())%>')){
	        allcalexp.deleteRow(jQuery(obj).parent().parent().parent()[0].rowIndex);
	    }
	}
	
	function rowsaveRole(){
		doPost(rowcalfrm,tab4);
	}
	function rowsaveRole1(){
		clearexp();
	    rowsaveRole();
	}
	function colsaveRole(){
		doPost(colcalfrm,tab5);
	}
	function setChange(fieldid){
		$G("checkitems").value += "field_"+fieldid+"_CN,"
		var changefieldids = $G("changefieldids").value;
		if(changefieldids.indexOf(fieldid)<0)
			$G("changefieldids").value = changefieldids + fieldid + ",";
	}
	function fieldlablesall(){
		if(document.fieldlabelfrm.fieldSize.value!="0")
			document.fieldlabelfrm.formfieldlabels.value=document.fieldlabelfrm.selectlangids.value;
		doPost(fieldlabelfrm,tab3);
	}
	function fieldlablesall0(){
		var checks = $G("checkitems").value;
		if(check_form(fieldlabelfrm,checks)){
			doPost(fieldlabelfrm,tab3);
		}else{
			return;
		}		
	}

var helpURL = "workflow/form/editform.jsp";	
function setHelpURL(url){
    helpURL = url;
}
function showHelp()
{
    var pathKey = helpURL;
    //alert(pathKey);
    
    var operationPage = "http://help.e-cology.com.cn/help/RemoteHelp.jsp";

    var screenWidth = window.screen.width*1;
    var screenHeight = window.screen.height*1;

    window.open(operationPage+"?pathKey="+pathKey,"_blank","top=0,left="+(screenWidth-800)/2+",height="+(screenHeight-90)+",width=800,status=no,scrollbars=yes,toolbar=yes,menubar=no,location=no");

}

function fieldlabeldelRow()
{
    if (isdel()){
    var selectlangids = document.fieldlabelfrm.selectlangids.value;
	len = document.fieldlabelfrm.elements.length;
    rownum=parseInt(document.fieldlabelfrm.rownum.value);
    var i=0;
	var temps="";;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.fieldlabelfrm.elements[i].name=='check_lang')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.fieldlabelfrm.elements[i].name=='check_lang'){
			if(document.fieldlabelfrm.elements[i].checked==true) {
//				if(document.fieldlabelfrm.elements[i].value!='0')
//					delids +=","+ document.fieldlabelfrm.elements[i].value;
				var tmp = document.fieldlabelfrm.elements[i].value + ',';
				if (temps!="")
				temps= temps+","+document.fieldlabelfrm.elements[i].value;
				else
				temps= document.fieldlabelfrm.elements[i].value;
				selectlangids=selectlangids.replace(tmp, '');
				//alert(selectlangids+" "+tmp+" "+selectlangids);
				

			}
			rowsum1 -=1;
		}

	}
	
	if (temps!="")
	{
	temparray=temps.split(",");
	for (l=0;l<temparray.length;l++)
	{
	var m=0;
	var tempss=temparray[l];
    if(oTable.rows[0].cells.length>1)
	{
	for (k=0;k<oTable.rows[0].cells.length;k++)
		{
	     if (oTable.rows[0].cells[k].innerHTML.indexOf(tempss)>0&&oTable.rows[0].cells[k].innerHTML.indexOf("checkbox")>0)
			{
		      m=k;
		    }
	    }
	}
	for(j=0;j<oTable.rows.length;j++)
		{
			if(oTable.rows[j].cells.length>1)
			{ 
				oTable.rows[j].deleteCell(m);
			}
		}
	}
	}
    document.fieldlabelfrm.selectlangids.value=selectlangids;
    }
}

jQuery('.e8_boxhead').bind('contextmenu',function(){
	return false;
});

</script>
