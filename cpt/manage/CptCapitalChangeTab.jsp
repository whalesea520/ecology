<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page import="weaver.general.Util" %>
<jsp:useBean id="CptDetailColumnUtil" class="weaver.cpt.util.CptDetailColumnUtil" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("CptCapital:Change", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<!-- browser 相关 -->
<script type="text/javascript" src="/formmode/js/modebrow_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>

<SCRIPT language="javascript" src="/cpt/js/validate_wev8.js"></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/interface/CptDwrUtil.js'></script>
<script type="text/javascript">
var parentWin;
if("<%=isDialog %>"=="1"){
	parentWin = parent.parent.getParentWindow(parent.window);
	var parentDialog = parent.parent.getDialog(parent);
}
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6055,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:group1.addRow(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:group1.deleteRows(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(77,user.getLanguage())+",javascript:group1.copyRows(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=weaver name=weaver action="/cpt/manage/CapitalChangeOperation.jsp" method="post">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) %>" class="e8_btn_top"  onclick="group1.addRow()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>" class="e8_btn_top"  onclick="group1.deleteRows()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(77,user.getLanguage()) %>" class="e8_btn_top"  onclick="group1.copyRows()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="e8_btn_top"  onclick="onSubmit(this)"/>
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelName(347,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>		
<div class="advancedSearchDiv" id="advancedSearchDiv">
</div>
<div class="subgroupmain" style="width: 100%;margin-left:0px;"></div>
<script>
var items=<%=CptDetailColumnUtil.getDetailColumnConf("CptChange", user) %>;
var option= {navcolor:"#00cc00",basictitle:"<%=SystemEnv.getHtmlLabelName(129974,user.getLanguage())%>",toolbarshow:true,openindex:true,colItems:items,toolbarshow:false,optionHeadDisplay:"none"};
var group1=new WeaverEditTable(option);
$(".subgroupmain").append(group1.getContainer());
</script>
<input type="hidden" name="dtinfo" id="dtinfo" value=""/>
</form>
<script language="javascript">

function onSubmit() {
	var dtinfo= group1.getTableSeriaData();	
	var dtjson= group1.getTableJson();
	enableAllmenu();
	if(dtinfo){
		var dtmustidx=[10];
		var jsonstr= JSON.stringify(dtjson);
		if(checkdtismust(dtjson,dtmustidx)==false){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage()) %>");
			displayAllmenu();
			return;
		}
		document.weaver.dtinfo.value=jsonstr;
		//资产编码重复性校验
		var checkStatus = true;
		$("input[name^='mark']").each(function(i) {
			var mark = $(this).val();
			var id = $("#capitalid_"+$(this).attr("name").split("_")[1]).val();
			 
			jQuery.ajax({
			url : "/cpt/capital/CptCapitalOperation.jsp",
			type : "post",
			async : true,
			processData : true,
			data : {"operation":"checkmark","mark":mark,"isdata":"2","id":id},
			dataType : "json",
			success: function do4Success(data){
					if(data.msg=="false"){
						checkStatus=false;
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("15323",user.getLanguage())%>"+(i+1)+"<%=SystemEnv.getHtmlLabelNames("18620",user.getLanguage())%><%=SystemEnv.getHtmlLabelNames("18082",user.getLanguage())%>");
						return;
					}
				}
			}); 
		});
		if(checkStatus){
				document.weaver.submit();
		}else{
				displayAllmenu();
		}
	}else{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(33027,user.getLanguage()) %>");
		displayAllmenu();
	}
}
</script>
<script language="javascript">
function back() {
	window.history.back(-1);
}

function loadinfo(event,data,name){
	try{
		if(name){
			var cptid=$('#'+name).val();
			if(cptid!=""){
				CptDwrUtil.getCptInfoMap(cptid,function(data){
					$('#'+name).parents('tr').find('td').eq(2).find('input[id^=mark]').val(data.mark).trigger('blur');
					if (data.capitalgroupid && data.capitalgroupname_) {
						var capitalgroupname = wrapshowhtml(data.capitalgroupname_,data.capitalgroupid,1);
						$('#'+name).parents('tr').find('td').eq(3).find('input[id^=capitalgroupid]').val(data.capitalgroupid).next('span').html(capitalgroupname);
						hoverShowNameSpan(".e8_showNameClass");
						//字段联动触发完毕后，手动触发触发目标对象的change事件
					    try{
					    	$('#'+name).parents('tr').find('td').eq(3).find('input[id^=capitalgroupid]').attr("onafterpaste","");
					    	$('#'+name).parents('tr').find('td').eq(3).find('input[id^=capitalgroupid]').trigger("change");
					    	$('#'+name).parents('tr').find('td').eq(3).find('input[id^=capitalgroupid]').focus();
					    	$('#'+name).parents('tr').find('td').eq(3).find('input[id^=capitalgroupid]').blur();
					    }catch(e1){
					        if(window.console) console.log("E1 Error : "+e1.message);
					    }
					}
					if (data.resourceid && data.resourcename_) {
						var resourcename = wrapshowhtml(data.resourcename_,data.resourceid,1);
						$('#'+name).parents('tr').find('td').eq(4).find('input[id^=resourceid]').val(data.resourceid).next('span').html(resourcename);
						hoverShowNameSpan(".e8_showNameClass");
						//字段联动触发完毕后，手动触发触发目标对象的change事件
					    try{
					    	$('#'+name).parents('tr').find('td').eq(4).find('input[id^=resourceid]').attr("onafterpaste","");
					    	$('#'+name).parents('tr').find('td').eq(4).find('input[id^=resourceid]').trigger("change");
					    	$('#'+name).parents('tr').find('td').eq(4).find('input[id^=resourceid]').focus();
					    	$('#'+name).parents('tr').find('td').eq(4).find('input[id^=resourceid]').blur();
					    }catch(e1){
					        if(window.console) console.log("E1 Error : "+e1.message);
					    }
					}
					$('#'+name).parents('tr').find('td').eq(5).find('input[id^=capitalspec]').val(data.capitalspec).trigger('blur');
					$('#'+name).parents('tr').find('td').eq(6).find('input[id^=stockindate]').val(data.stockindate).next().next('span').html(data.stockindate);
					$('#'+name).parents('tr').find('td').eq(7).find('input[id^=location]').val(data.location).trigger('blur');
					$('#'+name).parents('tr').find('td').eq(8).find('input[id^=startprice]').val(data.startprice).trigger('blur');
					$('#'+name).parents('tr').find('td').eq(9).find('input[id^=capitalnum]').val(data.capitalnum).trigger('blur');
					if (data.blongdepartmentid && data.blongdepartmentname_) {
						var blongdepartmentname = wrapshowhtml(data.blongdepartmentname_,data.blongdepartmentid,1)
						$('#'+name).parents('tr').find('td').eq(10).find('input[id^=blongdepartment]').val(data.blongdepartmentid).next('span').html(blongdepartmentname);
						hoverShowNameSpan(".e8_showNameClass");
						//字段联动触发完毕后，手动触发触发目标对象的change事件
					    try{
					    	$('#'+name).parents('tr').find('td').eq(10).find('input[id^=blongdepartment]').attr("onafterpaste","");
					    	$('#'+name).parents('tr').find('td').eq(10).find('input[id^=blongdepartment]').trigger("change");
					    	$('#'+name).parents('tr').find('td').eq(10).find('input[id^=blongdepartment]').focus();
					    	$('#'+name).parents('tr').find('td').eq(10).find('input[id^=blongdepartment]').blur();
					    }catch(e1){
					        if(window.console) console.log("E1 Error : "+e1.message);
					    }
					}
			   	});
			}else{
				$('#'+name).parents('tr').find('td').eq(2).find('input[id^=mark]').val('');
				$('#'+name).parents('tr').find('td').eq(3).find('input[id^=capitalgroupid]').val('').next('span').html('');
				$('#'+name).parents('tr').find('td').eq(4).find('input[id^=resourceid]').val('').next('span').html('');
				$('#'+name).parents('tr').find('td').eq(5).find('input[id^=capitalspec]').val('');
				$('#'+name).parents('tr').find('td').eq(6).find('input[id^=stockindate]').val('').next().next('span').html('');
				$('#'+name).parents('tr').find('td').eq(7).find('input[id^=location]').val('');
				$('#'+name).parents('tr').find('td').eq(8).find('input[id^=startprice]').val('');
				$('#'+name).parents('tr').find('td').eq(9).find('input[id^=capitalnum]').val('');
				$('#'+name).parents('tr').find('td').eq(10).find('input[id^=blongdepartment]').val('').next('span').html('');
			}
		}
	}catch(e){}
}
$(function(){
	setTimeout(" group1.addRow();",100);
});
function checknumber_change(objectname) {
	var valuechar = document.getElementsByName(objectname)[0].value.split("") ;
	var isnumber = true ;
	for(i=0 ; i<valuechar.length ; i++) { 
		var charnumber = parseInt(valuechar[i]) ; 
		if( isNaN(charnumber)&& valuechar[i]!="." && valuechar[i]!="-") 
			isnumber = false ;
	}
	if(!isnumber) {
		document.getElementsByName(objectname)[0].value = "" ;
	} else {
		var capitalnum = $('#'+objectname).val();
		var cptid = $('#'+objectname).parents('tr').find('td').eq(1).find('input[id^=capitalid]').val();
		if (cptid) {
			jQuery.ajax({
				type:"post",
				url: "/cpt/manage/validate.jsp?sourcestring=validateNum",
				data: {capitalid:cptid,capitalnum:capitalnum},
				async: false, 
				dataType: "text",
				success: function(msg){
					if (msg&&msg.trim()){
						alert("修改的数量不能小于冻结数量，冻结数："+msg.trim());
						 $('#'+objectname).val("");
						 $('#'+objectname).focus();
					}
				}
			});
		}
	}
}
</script>

<%if("1".equals(isDialog)){%>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentDialog.closeByHand();"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout>
</div>	
<%}%>

</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
