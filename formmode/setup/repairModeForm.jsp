
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="FormManager" class="weaver.workflow.form.FormManager" scope="session"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ModeSetUtil" class="weaver.formmode.setup.ModeSetUtil" scope="page" />
<html>
<HEAD>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />  
	<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
	<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
	<link href="/mobilemode/css/mec/handler/Navigation_wev8.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
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
<style type="text/css">
.checkSuccess{
	background: url('/images/BacoCheck_wev8.gif') no-repeat;
	padding-left: 20px;
	background-position: left 2px;
}
</style>
<%
	if(!HrmUserVarify.checkUserRight("FormManage:All", user))
	{
		response.sendRedirect("/notice/noright.jsp");
    	
		return;
	}
	String navName = SystemEnv.getHtmlLabelName(82191,user.getLanguage());//表单字段修复
%>
<script type="text/javascript">

  	  	var parentWin = null;
		var dialog = null;
		try{
			parentWin = parent.getParentWindow(window);
			dialog = parent.getDialog(window);
		}catch(e){}

		$(function(){
		    $('.e8_box').Tabs({
		        getLine:1,
		        mouldID:"<%= MouldIDConst.getID("formmode")%>",
		        iframe:"tabcontentframe",
		        staticOnLoad:true,
		        objName:"<%=navName%>"
		   	});
		}); 
	</script>

</head>
<%
int formid = Util.getIntValue(request.getParameter("formid"),-1);
String dialog = Util.null2String(request.getParameter("dialog"),"1");
List<Integer> notExistFieldList = ModeSetUtil.getDatabaseNotExistField(formid);
String fieldIdsForSQL = "";
for(int i = 0; i < notExistFieldList.size(); i++){
	fieldIdsForSQL += "'" + notExistFieldList.get(i) + "'";
	if(i != (notExistFieldList.size() - 1)){
		fieldIdsForSQL += ",";
	}
}

%>  
<body>
<div class="e8_box demo2" style="overflow:auto;">
		  <div class="e8_boxhead">
		         <div class="div_e8_xtree" id="div_e8_xtree"></div>
	             <div class="e8_tablogo" id="e8_tablogo"></div>
			     <div class="e8_ultab">
				  <div class="e8_navtab" id="e8_navtab">
					 <span id="objName"></span>
				  </div>
			  <div>
		    <ul class="tab_menu">
	   				        		        
		    </ul>
	    <div id="rightBox" class="e8_rightBox">
	    </div>
	     </div>
		</div>
	</div> 

<div class="table" align="center" style="border-top:1px solid #DADADA;">
	<table class="ListStyle" cellspacing="1" style="width: 98%;">
		<thead>
			<tr class="HeaderForXtalbe">
				<th width="15%" style="height: 38px;"><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%><!-- 字段名称 -->&nbsp;</th>
				<th width="15%" style="height: 38px;"><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%><!-- 字段显示名 -->&nbsp;</th>
				<th width="14%" style="height: 38px;"><%=SystemEnv.getHtmlLabelName(17997,user.getLanguage())%><!-- 字段位置 -->&nbsp;</th>
				<th width="14%" style="height: 38px;"><%=SystemEnv.getHtmlLabelName(687,user.getLanguage())%><!-- 表现形式 -->&nbsp;</th>
				<th width="15%" style="height: 38px;"><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%><!-- 字段类型 -->&nbsp;</th>
				<th width="15%" style="height: 38px;"><%=SystemEnv.getHtmlLabelName(82255,user.getLanguage())%><!-- 问题原因 -->&nbsp;</th>
				<th width="12%" style="height: 38px;"><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%><!-- 操作 -->&nbsp;</th>
			</tr>
		</thead>
		<tbody>
			<%
				FormFieldTransMethod formFieldTransMethod = new FormFieldTransMethod();
				String sql = "select * from workflow_billfield where id in ("+fieldIdsForSQL+") order by viewtype,dsporder,id";
				RecordSet.executeSql(sql);
				int i = 1;
				while(RecordSet.next()){
					String fieldid = RecordSet.getString("id");
					String fieldlabel = RecordSet.getString("fieldlabel");
					String viewtype = RecordSet.getString("viewtype");
					String fieldhtmltype = RecordSet.getString("fieldhtmltype");
					String type = RecordSet.getString("type");
			%>
				<tr class="<%if(i%2 == 0){%>DataDark<%}else{%>DataLight<%} %>" style="vertical-align: middle;">
					<td align="left" style="height: 38px;"><%=RecordSet.getString("fieldname") %></td>
					<td align="left" style="height: 38px;"><%=formFieldTransMethod.getFieldname(fieldlabel, String.valueOf(user.getLanguage())) %></td>
					<td align="left" style="height: 38px;"><%=formFieldTransMethod.getViewType(viewtype, String.valueOf(user.getLanguage())) %></td>
					<td align="left" style="height: 38px;"><%=formFieldTransMethod.getHTMLType(fieldhtmltype, String.valueOf(user.getLanguage())) %></td>
					<td align="left" style="height: 38px;"><%=formFieldTransMethod.getFieldType(type, fieldhtmltype + "+" + fieldid + "+" + String.valueOf(user.getLanguage())) %></td>
					<td align="left" style="height: 38px;"><%=SystemEnv.getHtmlLabelName(82256,user.getLanguage())%><!-- 数据库表中不存在此列 --></td>
					<td align="left" style="height: 38px;">
						<%-- <button id="addFieldToDBBtn_<%=fieldid %>" class="btn" accesskey="N" onclick="javascript:addFieldToDB(<%=fieldid %>);" type="button"><u>N</u>-创建</button> --%>
						<div id="addFieldToDBBtn_<%=fieldid %>"  class="MADN_SaveBtn"accesskey="N"  onclick="javascript:addFieldToDB(<%=fieldid %>);" style="margin-left:0px;left;0;width:104px;position:relative;float:left;"><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%><!-- 创建 --></div>
						<span id="optSpan_<%=fieldid %>"></span>
					</td>
				</tr>
			<%	
					i++;
				}
			%>
		</tbody>
	</table>
</div>
</div> 
<%if("1".equals(dialog)){%>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom" style="padding:0!important;">
		<div style="padding: 5px 0;">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar"><!-- 关闭 -->
			    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()" style="width: 60px!important;">
				</wea:item>
			</wea:group>
		</wea:layout>
		</div>
	</div>
	
	<style type="text/css">
	.tab_box {
		bottom:30px;
	}
	</style>
	<%}%>

<script language="javascript">
function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}

function addFieldToDB(fieldid){
	var btn = document.getElementById("addFieldToDBBtn_"+fieldid);
	btn.innerHTML = "<%=SystemEnv.getHtmlLabelName(82257,user.getLanguage())%>";//正在创建...
	btn.disabled=true;
	var optSpan = document.getElementById("optSpan_"+fieldid);
	optSpan.innerHTML = "";
    var ajax=ajaxinit();
    ajax.open("POST", "repairModeFormXml.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("src=addFieldToDB&fieldid="+fieldid);
    ajax.onreadystatechange = function() {
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
            	if(ajax.responseText == "success"){
            		btn.parentNode.innerHTML = "<div class=\"checkSuccess\"><%=SystemEnv.getHtmlLabelName(82258,user.getLanguage())%></div>";//已修复
            	}else if(ajax.responseText == "error"){
            		btn.innerHTML = "<u>N</u>-<%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%>";//创建
            		btn.disabled=false;
            		optSpan.innerHTML = "<br/><font color='red'><%=SystemEnv.getHtmlLabelName(82259,user.getLanguage())%></font>";//创建失败
            	}else{
            		btn.innerHTML = "<u>N</u>-<%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%>";//创建
            		btn.disabled=false;
            	}
            }catch(e){}
        }
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

jQuery(document).ready(function(){

})
jQuery(document).ready(function(){
	jQuery(window).resize();
}) 
</script>
<SCRIPT language="javascript">
 
   
	function viewSourceUrl(){
    prompt("",location);
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
    	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(18688,user.getLanguage())%>", function (){
    		allcalexp.deleteRow(jQuery(obj).parent().parent().parent()[0].rowIndex);
		}, function () {}, 320, 90,true);
	    //if(confirm('<%=SystemEnv.getHtmlLabelName(18688,user.getLanguage())%>')){
	    //    allcalexp.deleteRow(jQuery(obj).parent().parent().parent()[0].rowIndex);
	    //}
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
jQuery(document).ready(function(){

})
jQuery(document).ready(function(){
	jQuery(window).resize();
}) 
</script>
</body>
</html>