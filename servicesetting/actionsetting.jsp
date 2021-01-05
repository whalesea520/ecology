
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ActionXML" class="weaver.servicefiles.ActionXML" scope="page" />
<HTML><HEAD>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
</head>
<%
if(!HrmUserVarify.checkUserRight("ServiceFile:Manage",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23662,user.getLanguage());
String needfav ="1";
String needhelp ="";


String paraactionid = Util.null2String(request.getParameter("actionid"));

ArrayList pointArrayList = ActionXML.getPointArrayList();
Hashtable dataHST = ActionXML.getDataHST();
//Hashtable datasetHST = ActionXML.getDatasetHST();
String moduleid = ActionXML.getModuleId();
String classname = "";

String checkString = "";
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/servicesetting/actionsettingnew.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) %>" class="e8_btn_top" onclick="add()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>" class="e8_btn_top" onclick="onDelete()"/>
			<span id="advancedSearch" class="advancedSearch" style='display:none;'><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"></span> 
</div>
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'>
</div>

<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="actionsetting.jsp">
<input type="hidden" id="operation" name="operation">
<input type="hidden" id="method" name="method">
<input type="hidden" id="atnums" name="atnums" value="<%=pointArrayList.size()%>">

<TABLE class="ListStyle" cellspacing=1>
<COLGROUP> 
	<COL width="4%"> 
	<COL width="10%"> 
	<COL width="50%">
	<TBODY>
	<TR class=header>
	  <td><INPUT type="checkbox" name="chkAll" onClick="chkAllClick(this)"></td>
	  <td><nobr><%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></nobr></td>
	  <td><nobr><%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(23681,user.getLanguage())%></nobr></td>
	</TR>
				
	<%
	int colorindex = 0;
	int rowindex = 0;
	for(int i=0;i<pointArrayList.size();i++){
	    String pointid = (String)pointArrayList.get(i);
	    if(pointid.equals("")) continue;
	    checkString += "actionid_"+rowindex+",";
	    classname = (String)dataHST.get(pointid);
	    //Hashtable setvalues = (Hashtable)datasetHST.get(pointid);
	    if(colorindex==0){
	    %>
	    <tr class="DataDark">
	    <%
	        colorindex=1;
	    }else{
	    %>
	    <tr class="DataLight">
	    <%
	        colorindex=0;
	    }%>
	    <td><input type="checkbox" id="del_<%=rowindex%>" name="del_<%=rowindex%>" value="0" onchange="if(this.checked){this.value=1;}else{this.value=0;}"></td>
	    <td>
	    	
	    	<a href="/servicesetting/actionsettingnew.jsp?pointid=<%=pointid%>"><%=pointid %></a>
	    	<input type=hidden id="actionid_<%=rowindex%>" name="actionid_<%=rowindex%>" value="<%=pointid%>">
	    </td>
	    <td>
	    	<%=classname %>
	    </td>
	    </tr>
	<%
	    rowindex++;
	}
	%>
				
	</TBODY>
</TABLE>
<br>
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>' attributes="{'samePair':'RemarkInfo','groupOperDisplay':'none','itemAreaDisplay':'block'}">
	  <wea:item attributes="{'colspan':'2'}">
		1.<%=SystemEnv.getHtmlLabelName(23951,user.getLanguage())%>；
		<BR>
		2.<%=SystemEnv.getHtmlLabelName(23952,user.getLanguage())%>。
	</wea:item>
  </wea:group>
</wea:layout>
  </FORM>
</BODY>

<script language="javascript">
function chkAllClick(obj)
{
    var atnums = document.getElementById("atnums").value;
    for(var i=0;i<atnums;i++){
        var chk = document.getElementById("del_"+i);;
        if(chk)
        {
	        chk.checked = obj.checked;
	        if(chk.checked)
	        {
	        	chk.value = "1";
	        }
	        else
	        {
	        	chk.value = "0";
	        }
	        try
           	{
           		if(chk.checked)
           			jQuery(chk.nextSibling).addClass("jNiceChecked");
           		else
           			jQuery(chk.nextSibling).removeClass("jNiceChecked");
           	}
           	catch(e)
           	{
           	}
        }
    }
}
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle();
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
});
function add()
{
	document.location = "/servicesetting/actionsettingnew.jsp";
}
function onSubmit(){
    if(check_form(frmMain,"<%=checkString%>")){
        frmMain.action="/servicesetting/XMLFileOperation.jsp";
        frmMain.operation.value="action";
        frmMain.method.value="edit";
        frmMain.submit();
    }
}

function onDelete(){
    top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
    	var atnums = document.getElementById("atnums").value;
	    for(var i=0;i<atnums;i++){
	        var chk = document.getElementById("del_"+i);;
	        if(chk.checked)
	        {
	        	chk.value = "1";
	        }
	        else
	        {
	        	chk.value = "0";
	        }
	    }
        frmMain.action="/servicesetting/XMLFileOperation.jsp";
        frmMain.operation.value="action";
        frmMain.method.value="delete";
        frmMain.submit();
    }, function () {}, 320, 90);
}
function checkATName(thisvalue,rowindex){
    atnums = document.getElementById("atnums").value;
    if(thisvalue!=""){
        for(var i=0;i<atnums;i++){
            if(i!=rowindex){
                otherdsname = document.getElementById("actionid_"+i).value;
                if(thisvalue==otherdsname){
                    top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(23991,user.getLanguage())%>");//该action已存在！
                    document.getElementById("actionid_"+rowindex).value = "";
                }
            }
        }
    }
}
</script>

</HTML>
