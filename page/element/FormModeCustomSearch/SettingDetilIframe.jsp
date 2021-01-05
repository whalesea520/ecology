<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.formmode.service.AppInfoService"%>
<%@ page import="weaver.formmode.setup.ModeTreeFieldComInfo"%>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ include file="/formmode/pub.jsp"%>
<%
//User user = HrmUserVarify.getUser (request , response) ;
String id = Util.null2String(request.getParameter("id"));//查询id
String eid = Util.null2String(request.getParameter("eid"));
RecordSet rs_common = new RecordSet();
String sql="select * from formmodeelement where id="+id+" and eid="+eid;
rs_common.executeSql(sql);
String reportId = "";
String fields = "";
String fieldsWidth="";
String isshowunread="";
String disorder="1.0";
String searchtitle="";
String isautoomit="";
String isshowassingle = "";
String morehref = "";
//modify by huguomin 20170825 QC:263819 start
boolean flgdelete = false;
//modify by huguomin 20170825 QC:263819 end
while(rs_common.next()){
	id = Util.null2String(rs_common.getString("id"));
	reportId = Util.null2String(rs_common.getString("reportId"));
	fields = Util.null2String(rs_common.getString("fields"));
	fieldsWidth = Util.null2String(rs_common.getString("fieldsWidth"));
	isshowunread = Util.null2String(rs_common.getString("isshowunread"));
	disorder = Util.null2String(rs_common.getString("disorder"));
	searchtitle = Util.null2String(rs_common.getString("searchtitle"));
	isautoomit = Util.null2String(rs_common.getString("isautoomit"));
	isshowassingle = Util.null2String(rs_common.getString("isshowassingle"));
	morehref = Util.null2String(rs_common.getString("morehref"));
}
//formmodeelement
String fieldId = "";
String fieldLabel = "";
HashMap hmFields = new HashMap();
String sqlBizListSetting = "";
String ebaseid="";

if(fields==null||fields.equals("")){
	fields = "''";
}
//获取已选字段显示名称
sqlBizListSetting = "select a.id, a.fieldname, b.labelname from workflow_billfield a left join HtmlLabelInfo b on a.fieldlabel=b.indexid ";
sqlBizListSetting+= "where a.id in ("+fields+") and b.languageid="+user.getLanguage()+" ";
rs_common.executeSql(sqlBizListSetting);
while(rs_common.next()){
	hmFields.put(rs_common.getString("id"), rs_common.getString("labelname"));
}
hmFields.put("-1", SystemEnv.getHtmlLabelName(722,user.getLanguage()));
hmFields.put("-2", SystemEnv.getHtmlLabelName(882,user.getLanguage()));
%>
<html>
<head>
<title></title>
<script type='text/javascript' src='/dwr/interface/DocTreeDocFieldUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>	
<script language=javascript src="/js/weaver_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<LINK href="/wui/theme/ecology8/templates/default/css/default2_wev8.css" rel="stylesheet"  type="text/css"> 	  
<SCRIPT src="/wui/theme/ecology8/templates/default/js/default_wev8.js" type="text/javascript"></SCRIPT>
<link rel="stylesheet" href="/js/jquery-clockpicker/assets/css/bootstrap.min_wev8.css" />
<link rel="stylesheet" href="/page/element/FormModeCustomSearch/multiselect-master/lib/google-code-prettify/prettify_wev8.css" />
<link rel="stylesheet" href="/page/element/FormModeCustomSearch/multiselect-master/css/style_wev8.css" />
<script type="text/javascript" src="/js/jquery-clockpicker/assets/js/bootstrap.min_wev8.js"></script>
<script type="text/javascript" src="/page/element/FormModeCustomSearch/multiselect-master/js/multiselect.min_wev8.js"></script>
	
<style>
textarea{
	vertical-align:middle;
}
*{
	font: 12px Microsoft YaHei;
}
html,body{
	overflow: hidden;
}
.e8_tblForm{
	width: 100%;
	margin: 0 0;
	border-collapse: collapse;
}
.e8_tblForm .e8_tblForm_label{
	vertical-align: top;
	border-bottom: 1px solid #e6e6e6;
	padding: 5px 5px 5px 10px;
}
.e8_tblForm .e8_tblForm_field{
	border-bottom: 1px solid #e6e6e6;
	padding: 5px 7px;
	background-color: #f8f8f8;
}
.e8_label_desc{
	color: #aaa;
}
a{
	text-decoration: none !important;
}
</style>
<script type="text/javascript">
jQuery(document).ready(function ($) {
	try{
		document.getElementById("searchtitle").focus();
	}catch(e){}
});
function onSave() {
	hideRightClickMenu();
	if(checkFieldValue("searchtitle,disorder,reportId")){
		formApp.submit();
	}
}
function onClose(){
	parent.dialog.closeByHand();
}
function checkFieldValue(ids){
	var idsArr = ids.split(",");
	for(var i=0;i<idsArr.length;i++){
		var obj = document.getElementById(idsArr[i]);
		if(obj&&obj.value==""){
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>",function(){displayAllmenu();});//必要信息不完整！
			return false;
		}
	}
	return true;
}

</script>
</head>
<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;//保存
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_top} " ;//取消
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form id="formApp" name="formApp" method="post" action="/page/element/FormModeCustomSearch/SettingDetilIframeOperation.jsp?action=add">
<input name="id" value="<%=id%>" type="hidden">
<input name="eid" value="<%=eid%>" type="hidden">
<table id="topTitle" cellpadding="0" cellspacing="0" style="display:none;">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="onSave()">
				<span title="<%=SystemEnv.getHtmlLabelName(81804, user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
</table>
<table class="e8_tblForm">
<colgroup>
<col width="160px"/>
<col width="*"/>
</colgroup>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%><!-- 标题 --></td>
	<td class="e8_tblForm_field"><input type="text" id="searchtitle" name="searchtitle" style="width:80%;" value="<%=searchtitle %>" onblur="searchtitlechange(this)" /> 
		<span id="searchtitleImage">
			<img src="/images/BacoError_wev8.gif"/>
		</span>
	</td>
</tr>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(320,user.getLanguage())%><!-- 列表 --></td>
	<td class="e8_tblForm_field">
	<%
	String reportName = "";
	String retrieveReportNameSql = "select c.customname from mode_customsearch c,modeTreeField f where c.id = " + reportId + "and c.appid=f.id and (f.isdelete<>1 or f.isdelete is null) order by c.customname";
	rs_common.executeSql(retrieveReportNameSql);
	if(rs_common.next()){
 		reportName = Util.null2String(rs_common.getString("customname"));
 	}
	String browserid = "reportId";
	String browserUrl = "/page/element/FormModeCustomSearch/custom_search_browser.jsp?eid="+eid+"&reportId="+reportId+"&ebaseid="+ebaseid+"&method=";
	%>
	
	<brow:browser viewType='0' id='<%=browserid %>' name='<%=browserid %>' browserValue='<%=reportId%>' 
  		 				browserUrl='<%=browserUrl %>'
						hasInput='false' isSingle='true' hasBrowser='true' isMustInput='2'
						completeUrl='/data.jsp' linkUrl=''  width='228px'
						browserDialogWidth='510px'
						browserSpanValue='<%=reportName %>'
						></brow:browser> &nbsp;<span style='display:none'>
<%=SystemEnv.getHtmlLabelName(82641,user.getLanguage())%><input type="checkbox" name="isshowunread" id="isshowunread" onclick="isshowunreadclick()" value="<%=isshowunread %>" <%=(isshowunread.equals("1")?"checked":"") %>>
</span>
	</td>
</tr>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())+SystemEnv.getHtmlLabelName(338,user.getLanguage())%></td>
	<td class="e8_tblForm_field"><input type="text" tyle="width:80%;" name="disorder" id="disorder" value="<%=disorder %>" onblur="disorderchange(this)" >
	<span id="disorderImage">
		
	</span>
	</td>
</tr>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(127912,user.getLanguage())%></td>
	<td class="e8_tblForm_field"><input type="checkbox" name="isautoomit" id="isautoomit" value="1" <%if("1".equals(isautoomit)){%>checked<%}%>></td>
</tr>

<!-- more链接地址 -->
<tr>
	<td class="e8_tblForm_label">
		<!-- more链接地址 -->
		<%="more"+SystemEnv.getHtmlLabelName(16208,user.getLanguage())%>
	</td>
	<td class="e8_tblForm_field" valign="top">
		<textarea id="morehref" name="morehref" class="inputstyle" rows="3" style="width:80%" ><%=morehref%></textarea>
		<span title='<%=SystemEnv.getHtmlLabelName(82350,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82351,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82352,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82462,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82463,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82464,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82465,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(382960,user.getLanguage())%>&#10;8.输入“$customid$”表示当前查询id' id="remind">
			<img align="absMiddle" src="/images/remind_wev8.png">
		</span>
	</td>
</tr>

<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(83842,user.getLanguage())%></td>
	<td class="e8_tblForm_field">
	<div class="row">
	    <div class="col-xs-3" >
	        <select name="reportFields" id="reportFields" class="form-control" style="height: 200px" size="10" multiple="multiple">
	        </select>
	    </div>
	    
	    <div class="col-xs-1" style="height:200px;width:50px;text-align:center;margin:0px; padding:0px; ">
	    	<table style="height:100%;width:100%;"><tr><td style="height:100%;width:100%;text-align:center;vertical-align:middle">
	        <button type="button" id="undo_redo_rightSelected" class="btn btn-default btn-block"><i class="glyphicon glyphicon-chevron-right"></i></button>
	        <button type="button" id="undo_redo_leftSelected" class="btn btn-default btn-block"><i class="glyphicon glyphicon-chevron-left"></i></button>
	        </td></tr>
	        </table>
	    </div>
	    
	    <div class="col-xs-3">
	        <select name="reportFieldsSelected" id="reportFieldsSelected" style="height: 200px" class="form-control" size="10" multiple="multiple">
	        <%
			String sql2 = "select a.fieldid, b.fieldname from mode_CustomDspField a left join workflow_billfield b on a.fieldid=b.id  ";
			sql2+= "where a.customid='"+reportId+"' and isshow=1 ";
			rs_common.executeSql(sql2);
			String showfieldids = "";
			String noshowfieldindexs="";
			String newselectfield="";
			String newselectfieldwidth="";
			while(rs_common.next()){
				showfieldids += rs_common.getInt("fieldid")+",";
			}
			ArrayList arrayLisFields = Util.TokenizerString(fields, ",");
			//modify by huguomin 20170825 QC:263819 start
			ArrayList linelist = new ArrayList();;
			//modify by huguomin 20170825 QC:263819 end
			if(arrayLisFields.size()>0){
				for(int i=0;i<arrayLisFields.size();i++){
					fieldId = Util.null2String(""+arrayLisFields.get(i));
					fieldLabel = Util.null2String(""+hmFields.get(fieldId));
					if(showfieldids.indexOf(fieldId+",")==-1){
						noshowfieldindexs+=i+",";
						continue;
					}else{
						//modify by huguomin 20170825 QC:263819 start
						if(fieldLabel!=null&&!fieldLabel.equals("")&&!"null".equals(fieldLabel)){
							newselectfield+=","+fieldId;							
						out.println("<option value='"+fieldId+"'>"+fieldLabel+"</option>");						
						}else{
							linelist.add(i);
							flgdelete = true;
							out.println("<option style=color:red value='"+fieldId+"'>"+fieldId+"被删除</option>");	
						}
						//modify by huguomin 20170825 QC:263819 end
					}
				}
				if(newselectfield.length()>0){
					newselectfield=newselectfield.substring(1);
				}
			}
			%>
	        </select>
	    </div>
	    <div class="col-xs-2">
	        <select name="reportFieldsWidth" id="reportFieldsWidth" style="height: 200px" class="form-control" size="10" multiple="multiple">
	        <%
				ArrayList arrayLisFieldsWidth = Util.TokenizerString(fieldsWidth, ",");
				if(arrayLisFieldsWidth.size()>0){
					for(int i=0;i<arrayLisFieldsWidth.size();i++){
						if(noshowfieldindexs.indexOf(i+",")>-1){
							continue;
						}else{
							//modify by huguomin 20170825 QC:263819  start
							if(linelist.contains(i)){
								out.println("<option style=color:red value='"+arrayLisFieldsWidth.get(i)+"'>"+arrayLisFieldsWidth.get(i)+"</option>");
							}else{
								newselectfieldwidth+=","+arrayLisFieldsWidth.get(i);
								out.println("<option value='"+arrayLisFieldsWidth.get(i)+"'>"+arrayLisFieldsWidth.get(i)+"</option>");
							}
							//modify by huguomin 20170825 QC:263819 end
						}						
					}
					if(newselectfieldwidth.length()>0){
						newselectfieldwidth=newselectfieldwidth.substring(1);
					}
				}
				%>
	        </select>
	    </div>
	    <div class="col-xs-1"  style="height:200px;width:50px;margin-left:auto;margin-right:auto;margin:0px; padding:0px; ">
	    	<table style="height:100%;width:100%;">
	    		<tr>
	    			<td style="height:100%;width:100%;vertical-align:middle">
	    	<button type="button" id="Up" onclick="sortField(-1) " class="btn btn-default btn-block"><i class="glyphicon glyphicon-chevron-up"></i></button>
	        <button type="button" id="Down" onclick="sortField(1) " class="btn btn-default btn-block"><i class="glyphicon glyphicon-chevron-down"></i></button>
	        		</td>
	        	</tr>
	        </table>
	    </div>
	</div>
</td>
</tr>
</table>
	</td>
</tr>

</table>
<%
//modify by huguomin 20170825 QC:263819 start
	if(flgdelete){
%>
<span>
	<label style=color:red for="msg">保存后被删除字段会被清除</label>
</span>
<%
	}
//modify by huguomin 20170825 QC:263819 end
%>	

<input id="fields" name="fields" type="hidden" value="<%=newselectfield%>" />
<input id="fieldsWidth" name="fieldsWidth" type="hidden" value="<%=newselectfieldwidth%>" />
</form>
<script type="text/javascript">
function changesetting(){
	showDailog('<%=eid%>','','','<%="/page/element/FormModeCustomSearch/custom_search_browser.jsp?eid=" + eid + "&reportId=" + reportId%>','<%=ebaseid %>')
}
if (navigator.userAgent.indexOf("MSIE")>0) {  
	document.getElementById("reportId").attachEvent('onpropertychange', loadReportFieldsHandler);
}else{	
  	//document.getElementById("reportId").addEventListener('input', loadReportFieldsHandler, false);
}
jQuery(document).ready(function(){
	searchtitlechange(jQuery("#searchtitle"));
	disorderchange(jQuery("#disorder"));
})
function searchtitlechange(obj){
	if(jQuery(obj).val()==''){
		jQuery("#searchtitleImage").show();
	}else{
		jQuery("#searchtitleImage").hide();
	}
}

function disorderchange(obj){
	try{
		var re = /^\d+(\.\d+)?$/ ; 
		if(!re.test(jQuery(obj).val())){
			jQuery(obj).val('');
		}
	}catch(e){
		jQuery(obj).val('');
	}
	if(jQuery(obj).val()==''){
		jQuery("#disorderImage").show();
	}else{
		jQuery("#disorderImage").hide();
	}
}

function isshowtitlechange_<%=eid %>(ele,eid){
	if(ele.checked){
		document.getElementById("isshowtitle_"+eid).value="1";
	}else{
		document.getElementById("isshowtitle_"+eid).value="0";
	}
}

function loadReportFieldsHandler() {
	$("#reportFieldsSelected").empty();
	$("#reportFieldsWidth").empty();
	loadReportFields(document.getElementById("reportId").value);
}

$(function(){
	<%if(!"".equals(reportId)){%>
		loadReportFields("<%=reportId%>");
	<%}%>
	//加载报表字段
	//$("#reportId").bind("propertychange", function() {
	//	$("#reportFieldsSelected").empty();
	//	$("#reportFieldsWidth").empty();
	//	loadReportFields($(this).val());
	//});
	//调整字段宽度
	$("#reportFieldsWidth").dblclick(function(){
		var b = this;
		if (typeof(b.selectedIndex) == "undefined" || b.options.length <= 0) {
			return;
		}
		var a = b.options[b.selectedIndex];
		var c = a.value;
		c = prompt("<%=SystemEnv.getHtmlLabelName(83844,user.getLanguage())%>:", c, c);
		if (c) {
			a.value = c;
			a.text = c
		}
		setSelectedFields();
	});
});
function loadReportFields(reportId){
	$.ajax({
		url: "/page/element/FormModeCustomSearch/FormModeCustomSearchOperation.jsp?esharelevel=2&optMode=getModeReportField&eid=<%=eid%>&reportid="+reportId,
		dataType: "json",
		cache: false,
		success: function(d){
			$("#reportFields").empty();
			var selectedstr="";
			$("#reportFieldsSelected option").each(function(i,val){
				selectedstr+=$(val).val()+",";
			})
			$.each(d, function(key, val){
			    if(selectedstr==""||selectedstr.indexOf(val.fieldid)==-1){
			    	$("#reportFields").append( "<option value='"+val.fieldid+"'>"+val.fieldlabel+"</option>");   
			    }
			});
			
			if($("#reportId").val()==""){
				$("#reportIdspanimg").html("<img align='absMiddle' src='/images/BacoError_wev8.gif' complete='complete'/>");
			}else{
				$("#reportIdspanimg").html("");
			}
		}
	});
}

//
function setSelectedFields(){
	var str = "";
	//已选字段
	$("#reportFieldsSelected option").each(function(){
		str += str=="" ? $(this).val() : ","+$(this).val();
	});
	$("#fields").val(str);
	//已选字段显示宽度
	str = "";
	$("#reportFieldsWidth option").each(function(){
		str += str=="" ? $(this).val() : ","+$(this).val();
	});
	$("#fieldsWidth").val(str);
}
//调整字段顺序
function sortField(c) {
    if(c>0){
    	Down();
    }else{
    	Up();
    }
    /*
	var f = document.getElementById("reportFieldsSelected");
	var b = document.getElementById("reportFieldsWidth");
	var a = f.selectedIndex;
	if (typeof(a) == "undefined") {
		return;
	}
	var d = f.options;
	var e = b.options;
	if (a + c >= 0 && d[a + c] && d[a]) {
		d[a + c].swapNode(d[a]);
		if ((a + c) <= e.length) {
			e[a + c].swapNode(e[a]);
		}
	}
*/
	//
	setSelectedFields();
}
//排序：向上移动
function Up(){   
    var sel=document.getElementById("reportFieldsSelected");  //获取select 
    var nIndex =  sel.selectedIndex;   //需要进行操作的select 项的索引 
    var nLen   =   sel.length;   //select 总共项目数 
    if((nLen<1)||(nIndex==0))   return;    
    if(nIndex<0) {    
       alert("<%=SystemEnv.getHtmlLabelName(83853,user.getLanguage())%>");    
       return;   
    }else if($("#reportFieldsSelected option:selected").length>1){
       alert("<%=SystemEnv.getHtmlLabelName(83856,user.getLanguage())%>");
       return;
    }
    var sValue=sel.options[nIndex].value;    
    var sHTML=sel.options[nIndex].innerHTML;    
    sel.options[nIndex].value=sel.options[nIndex-1].value;    
    sel.options[nIndex].innerHTML=sel.options[nIndex-1].innerHTML;    
    sel.options[nIndex-1].value=sValue;    
    sel.options[nIndex-1].innerHTML=sHTML;    
    sel.selectedIndex=nIndex-1;
    
    var sel2=document.getElementById("reportFieldsWidth");  //获取select
    var sValue=sel2.options[nIndex].value;    
    var sHTML=sel2.options[nIndex].innerHTML;    
    sel2.options[nIndex].value=sel2.options[nIndex-1].value;    
    sel2.options[nIndex].innerHTML=sel2.options[nIndex-1].innerHTML;    
    sel2.options[nIndex-1].value=sValue;    
    sel2.options[nIndex-1].innerHTML=sHTML;    
    sel2.selectedIndex=nIndex-1;
}   

//排序：向下移动    
function Down(){    
    var sel=document.getElementById("reportFieldsSelected");    
    var nIndex = sel.selectedIndex;    
    var nLen = sel.length;    
    if((nLen<1)||(nIndex==nLen-1))   return;    
    if(nIndex<0){
      alert("<%=SystemEnv.getHtmlLabelName(83853,user.getLanguage())%>");    
      return;
    }else if($("#reportFieldsSelected option:selected").length>1){
       alert("<%=SystemEnv.getHtmlLabelName(83856,user.getLanguage())%>");
       return;
    }
    var sValue=sel.options[nIndex].value;    
    var sHTML=sel.options[nIndex].innerHTML;    
    sel.options[nIndex].value=sel.options[nIndex+1].value;    
    sel.options[nIndex].innerHTML=sel.options[nIndex+1].innerHTML;    
    sel.options[nIndex+1].value=sValue;    
    sel.options[nIndex+1].innerHTML=sHTML;    
    sel.selectedIndex=nIndex+1;
    
    var sel2=document.getElementById("reportFieldsWidth");  //获取select
    var sValue=sel2.options[nIndex].value;    
    var sHTML=sel2.options[nIndex].innerHTML;    
    sel2.options[nIndex].value=sel2.options[nIndex+1].value;    
    sel2.options[nIndex].innerHTML=sel2.options[nIndex+1].innerHTML;    
    sel2.options[nIndex+1].value=sValue;    
    sel2.options[nIndex+1].innerHTML=sHTML;    
    sel2.selectedIndex=nIndex+1;    
}

function showDailog(eid,method,tabId,url,ebaseid){
	// 更换弹出窗口为zDialog
	var tab_dialog = new window.top.Dialog();
	tab_dialog.currentWindow = window;   //传入当前window
	tab_dialog.Width = 630;
	tab_dialog.Height = 500;
	tab_dialog.Modal = true;
	tab_dialog.Title = "<%=SystemEnv.getHtmlLabelName(19480,user.getLanguage()) %>"; 
	tab_dialog.URL = url+"&ebaseid="+ebaseid+"&method="+method;
	tab_dialog.show();
	
}

function isshowunreadclick(){
	if(jQuery("#isshowunread").attr("checked")){
		jQuery("#isshowunread").val("1");
	}else{
		jQuery("#isshowunread").val("0");
	}
}

</script>
<script type="text/javascript">
jQuery(document).ready(function($) {
    $('#reportFields').multiselect({
    	right: '#reportFieldsSelected',
        rightSelected: '#undo_redo_rightSelected',
        leftSelected: '#undo_redo_leftSelected',
        moveToRight: function(Multiselect, $options, event, silent, skipStack) {
            var $left_options = Multiselect.$left.find('> option:selected');
            jQuery($left_options).each(function (i,val){
            	Multiselect.$right.eq(0).append(val);
            	$("#reportFieldsWidth").append("<option value='20%' >20%</option>");
            })
            setSelectedFields();
        },
        beforeMoveToLeft: function($left, $right, $options) { 
        	var $right_options = $right.eq(0).find('> option:selected');
        	var optionArray=[];
        	var m=0;
            jQuery($right_options).each(function (i,val){
            	var optionindex = getOptionIndex(jQuery("#reportFieldsSelected"),val);
            	$("#reportFieldsWidth option").each(function(i,val){
            		if(i==optionindex){
            			optionArray[m]=val;
            			m++;
            		}
            	});
            })
            $(optionArray).each(function(i,val){
            	$(val).remove();
            })
            
            return true;
        },
        afterMoveToLeft: function($left, $right, $options) {
        	setSelectedFields();
        },
		sort:function(t,e){
			return 0;
		}
    });
});
function getOptionIndex(selectObj,optionObj){
	var selectindex=-1;
	$(selectObj).find("option").each(function(i,val){
		if($(optionObj).val()==$(val).val()){
			selectindex=i;
			return false;
		}
	})
	return selectindex;
}
</script>
</body>
</html>
