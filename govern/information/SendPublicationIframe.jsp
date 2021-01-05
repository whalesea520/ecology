<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="com.alibaba.fastjson.JSON"%>
<%@ page import="weaver.hrm.User"%>

<%@ page import="com.alibaba.fastjson.serializer.SerializerFeature"%>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="JobComInfo" class="weaver.hrm.check.JobComInfo" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.file.*,java.util.*,java.text.*,weaver.common.DataBook" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<%
User user_new = (User)request.getSession(true).getAttribute("weaver_user@bean");
String lastname = user_new.getLastname();
String kx = Util.null2String(request.getParameter("kx"));
String fwid = Util.null2String(request.getParameter("fwid"));
rs.execute("select * from uf_xxcb_pbInfo where id="+fwid);
String sp_zt = "";
int kw_zt = 0;
String sp_operator = "";
if(rs.next()){
	kw_zt = Util.getIntValue(rs.getString("kw_zt"),0);
	sp_zt = Util.null2String(rs.getString("sp_zt"));
	sp_operator = Util.null2String(rs.getString("sp_operator"));
}else{
	response.sendRedirect("/notice/noright.jsp");
	return;
}
if(!"".equals(sp_zt) && !(user.getUID()+"").equals(sp_operator)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
List<String> optionList = new ArrayList<String>();
if(kw_zt==0){
	optionList.add("0,送审核");
	optionList.add("1,送签发");
	optionList.add("2,送定稿");
}else{
	if("0".equals(sp_zt)){
		optionList.add("1,送签发");
		optionList.add("2,送定稿");
	}else if("1".equals(sp_zt)){
		optionList.add("2,送定稿");
	}else{
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
}
List<Map<String,String>> list = new ArrayList<Map<String,String>>();
String settingField = "";
String operator = "";
settingField = "".equals(sp_zt)?"lgshuser":("0".equals(sp_zt)?"lgqfuser":"lgdguser");
rs.execute("select * from uf_xxcb_sysSet where id=1");
if(rs.next()){
	operator = Util.null2String(rs.getString(settingField));
}
String[] operators = operator.split(",");
if("".equals(sp_zt))
	sp_zt = "0";
%>
<HTML>
<HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css />
<style>
.Selected{
	background-color:#e2f4f5;
}
.Selected td{
	background-color:#e2f4f5;
}
.test_box {
    width: 92%; 
    min-height: 120px; 
    max-height: 300px;
    _height: 98%; 
    margin-left: auto; 
    margin-right: auto; 
    padding: 3px; 
    outline: 0; 
    border: 1px solid #a0b3d6; 
    font-size: 12px; 
    word-wrap: break-word;
    overflow-x: hidden;
    overflow-y: auto;
    -webkit-user-modify: read-write-plaintext-only;
}
.e8_box_middle {
	overflow: hidden;
	position: relative;
	border: 1px solid #dadedb;
	border-bottom: 0px;
}
.e8_box_slice{
	width: 57px;
	vertical-align: middle;
}
.e8_first_arrow{
	margin-top: 135px;
}
.e8_box_topmenu thead td {
	text-overflow: ellipsis;
	white-space: nowrap;
}
.hrmTr{
	height: 32px;
}
.hrmTd{
	width: 28px;
	display:none;
}
.hrmTd1{
	width:80px;
	max-width: 80px;
}
.hrmTd2{
	width:144px;
	max-width:144px;
	color:#929390;
}
</style>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

</HEAD>

<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id="SearchForm" NAME=SearchForm STYLE="margin-bottom:0;height: 100%;" action="MultiFormmodeShareFieldBrowserIframe.jsp" method=post>
 
<input type="hidden" id="operator" name="operator" value="">

<table style="width: 100%;height: 100%;" border="0" cellspacing="0" cellpadding="0">
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
	  <TABLE class=Shadow>
	 
<tr width="100%">
<td width="90%" valign="top" >
	<table class=BroswerStyle style="width: 100%;height: 80%; " >
	  <tr style="width:100%; height:40%;">
	  	<td align="left" style="width:30%; " >
	  		<div style="padding-bottom: 10px;">环节名称:&nbsp;&nbsp;
				<select class=inputstyle  id="hj" name="hj"  onchange="changelevel()"  >
					<%for(int i=0;i<optionList.size();i++){
						String id = optionList.get(i).split(",")[0];
						String name = optionList.get(i).split(",")[1];
					%>
					<option value="<%=id%>"><%=name %></option>
					<% } %>
				</select>
			</div>
	  		
	  	</td>
	  	<td align="left" style="width:70%; ">
	  	</td>
	  	</tr>
	  	<tr>
	  		<td>
		  		<div class="e8_box_middle ps-container" id="src_box_middle" style="width: 346px; height: 490px; overflow-y: auto; outline: none;" tabindex="5002">
		  			<table id="e8_box_source" class="e8_box_source" style="border-collapse: collapse;width: 100%">
		  				<tbody id="selectBody">
		  					<%for(int i=0;i<operators.length;i++){%>
			  					<tr class="hrmTr" resourceId="<%=operators[i] %>">
			  						<td class="hrmTd1">
			  							<%=ResourceComInfo.getLastname(operators[i]) %>
			  						</td>
			  						<td class="hrmTd2">
			  							<%=JobComInfo.getJobName(ResourceComInfo.getJobTitle(operators[i])) %>
			  						</td>
			  					</tr>	
		  					<%} %>
	  					</tbody>
	  				</table>
	  			</div>
	  		</td>
	  		<td>
	  			<div class="e8_box_middle ps-container" id="dest_box_middle" style="width: 261px; height: 490px; overflow-y: hidden; outline: none;" tabindex="5003">
					<table id="e8_dest_table" class="e8_box_target" style="border-collapse: collapse;">
						<tbody id="ui-sortable" class="ui-sortable">
							
						</tbody>
					</table>
				</div>
	  		</td>
	  	</tr>
	</table>
</td>
	 	</tr>
	   </TABLE>
	 </td>
  </tr>
</table>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context="">
		<wea:item type="toolbar">
			<input type="button" class=zd_btn_submit id=btnok val="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" onclick="btnok_fk()"></input>
			<input type="button" class=zd_btn_cancle id=btncancel value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" onclick="parent.dialog.closeByHand()"></input>
		</wea:item>
	</wea:group>
</wea:layout>
<input type="text" name="selectedids" value="" style="display: none;">
</FORM>

<style>
.imgWarpDiv{padding: 10px;}
.imgWarpDiv img{cursor: pointer;}
</style>

<script type="text/javascript">
window.console = window.console || (function () {
    var c ={}; 
　　 c.log = c.warn = c.debug = c.info = c.error = c.time = c.dir = c.profile= c.clear = c.exception = c.trace = c.assert = function(){};
    return c;
})();
var dialog = null;
try{
	parentWin = parent.parent.parent.getParentWindow(parent.parent);
	dialog = parent.parent.parent.getDialog(parent.parent);
}catch(e){}

var operator = "";
var nodeid = jQuery("#hj").val();
function btnok_cencle(){
	top.Dialog.getInstance('oazjm').cancelButton.onclick.apply(top.Dialog.getInstance('oazjm').cancelButton,[]);
	return;
}
function btnok_fk(){
	if(!operator){
		top.Dialog.alert("请选择操作者");
	}else{
		jQuery.ajax({  
			type:'post',    
		    url:'/govern/information/ContentSelectOperation.jsp?action=selectOperators',
		    cache:false,    
		   	dataType:'json',
		   	data:{operator:operator,fwid:"<%=fwid%>",hj:nodeid},
		   	async : false,
		    success:function(data){
		   		if(data.flag){
		   			alert("已提交");
		    		top.window.location.reload();
		   		}else{
		   			alert(message+" 提交失败 请联系管理员");
		   		}
		    }
		});
	}
		
}
function closeWin(returnjson){
	if(dialog){
		try{
			dialog.callback(returnjson);
			dialog.close(returnjson);
		}catch(e){}
	}else{
		window.parent.parent.parent.returnValue=returnjson;
		window.parent.parent.parent.close();
	}
}	

function btnok_onclick(){
	getReturn()
	//closeWin(getReturn());
}

function getReturn(){
	return {operator : operator};
}


function changelevel(){
	var hj = jQuery("#hj").val();
	if(nodeid != hj){
		jQuery.ajax({  
			type:'post',    
		    url:'/govern/information/ContentSelectOperation.jsp?action=getOperators',
		    cache:false,    
		   	dataType:'json',
		   	data:{hj:hj},
		   	async : false,
		    success:function(msg){
		   		jQuery("#selectBody").html("");
		    	var data = msg.data;
		    	for(var i=0;i<data.length;i++){
		    		addForList(data[i]);
		    	}
		    	jQuery("#ui-sortable").html("");
		    	operator="";
		    }
		});
		jQuery("#ui-sortable").html("");
		operator = "";
		jQuery("#operator").val("");
		nodeid = hj;
	}
}

function addForList(obj){
	jQuery("#selectBody").append(
		"<tr class=\"hrmTr\" resourceId="+obj.id+">"+
		"<td class=\"hrmTd1\">"+
		obj.lastName+
		"</td>"+
		"<td class=\"hrmTd2\">" +
		obj.jobTitle+
		"</td>"+
		"</tr>"	
	)	
}

jQuery(document).ready(function(){
	jQuery("#e8_box_source").bind("click",BrowseTable_onclick);
})



function BrowseTable_onclick(e){
	var e=e||event;
	var target =  e.srcElement||e.target ;
	try{
		if(target.nodeName =="IMG" || target.nodeName == "TD" || target.nodeName == "A" || target.nodeName == "INPUT" || target.nodeName == "SPAN"){
			var newEntry = jQuery(target).parents("tr")[0];
			var resourceId = jQuery(newEntry).attr("resourceId");
			addSelect(resourceId);
		}
	}catch (en) {
		console.log(en.message);
	}
}

function addSelect(resourceId){
	var html = "<tr height=\"32px\" class=\"\">"
			+jQuery(jQuery("tr[resourceId='"+resourceId+"']")[0]).html()
			+"</tr>";
	jQuery("#ui-sortable").html(html);
	operator = resourceId;
	jQuery("#operator").val(resourceId);
	
	
}

function onShowBrowser2(url,type) {
	var dialogurl = url;
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.URL = dialogurl;
	dialog.callbackfun = function (paramobj, id1) {
		if (id1 != undefined && id1 != null) {
			if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0" ) {
				var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
				var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
				if(type == 1){
					addById(resourceids);
				}else if(type == 2){
					editType(resourceids,resourcename);
				}
			}
		}
	} ;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";//请选择
	dialog.Width = 550 ;
	if(url.indexOf("/MutiResourceBrowser.jsp")!=-1){ 
		dialog.Width=648; 
	}
	dialog.Height = 600;
	dialog.Drag = true;
	//dialog.maxiumnable = true;
	dialog.show();
}

function removeObj(arr,obj){
	try{
		var returnData = [];
		for(var i=0;i<arr.length;i++){
			if(arr[i] != obj){
				returnData.push(arr[i]);
			}
		}
		return returnData;
	}catch(e){
		console.log(e);
	}
	return arr;
}
function contain(arr,obj){
	try{
		for(var i=0;i<arr.length;i++){
			if(arr[i] == obj)
				return true;
		}
	}catch(e){
		console.log(e);
	}
	return false;
}

function replaceArr(arr,obj1,obj2){
	try{
		var returnData = [];
		for(var i=0;i<arr.length;i++){
			returnData.push(arr[i] == obj1 ? obj2 : arr[i]);
		}
		return returnData;
	}catch(e){
		console.log(e);
	}
	return arr;
}
</script>
</BODY>
</HTML>