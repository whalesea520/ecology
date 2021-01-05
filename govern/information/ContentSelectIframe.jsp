
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="com.alibaba.fastjson.JSON"%>
<%@ page import="com.alibaba.fastjson.serializer.SerializerFeature"%>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
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
.pageBtn{
	max-width: 100px; 
	overflow: hidden; 
	text-overflow: ellipsis; 
	white-space: nowrap;
}
</style>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%
String fwid = Util.null2String(request.getParameter("fwid"));
String laiwen = Util.null2String(request.getParameter("selectedIds"));
String kx = Util.null2String(request.getParameter("kx"));
String loadFormTop = Util.null2String(request.getParameter("loadFormTop"));
boolean needLoad = !("1".equals(loadFormTop));
System.out.println(needLoad);
String formId = "";
rs.executeSql("select * from workflow_bill where tablename='uf_xxcb_pbInfo'");
if(rs.next()){
	formId = Util.null2String(rs.getString("id"));
}

String fieldid = "";
rs.executeSql("select * from workflow_billfield where billid="+formId+" and fieldname='dbxx' and (detailtable = '' or detailtable is null)");
if(rs.next()){
	fieldid = Util.null2String(rs.getString("id"));
}
String kxfieldid = "";
rs.executeSql("select * from workflow_billfield where billid="+formId+" and fieldname='journal' and (detailtable = '' or detailtable is null)");
if(rs.next()){
	kxfieldid = Util.null2String(rs.getString("id"));
}

Map<String,Map<String,String>> allMap = new HashMap<String,Map<String,String>>();

String sql = "select p.dbxx id,u.zw content,u.bt title,u.bsdw unit,u.lm typeid,l.name type from uf_xxcb_pbInfo_dt1 p left join uf_xxcb_dbInfo u on p.dbxx=u.id left join uf_xxcb_kxSet_dt1 l on p.lanmu=l.id where p.mainid='"+fwid+"' order by p.showOrder";

rs.executeSql(sql);

//int m = 0;
while(rs.next()){
	String id = Util.null2String(rs.getString("id"));
	String title = Util.null2String(rs.getString("title"));
	String unit = Util.null2String(rs.getString("unit"));
	String typeid = Util.null2String(rs.getString("typeid"));
	String type = Util.null2String(rs.getString("type"));
	String content = Util.null2String(rs.getString("content"));
	
	title = title.replaceAll("&nbsp;"," ").replaceAll("<br>","\n");
	content = content.replaceAll("&nbsp;"," ").replaceAll("<br>","\n");
	Map<String,String> map = new HashMap<String,String>();
	//map.put("index",m+"");
	map.put("id",id);
	map.put("title",title);
	map.put("unitid",unit);
	map.put("unit",SubCompanyComInfo.getSubCompanyname(unit));
	map.put("typeid",typeid);
	map.put("type",type);
	map.put("content",content);
	
	allMap.put(id,map);
	//list.add(map);
	//m++;
}

String[] lwa = laiwen.split(",");
List<Map<String,String>> list = new ArrayList<Map<String,String>>();
if(needLoad){
	for(int i=0;i<lwa.length;i++){
		if(!"".equals(lwa[i])){
			Map<String,String> map = allMap.get(lwa[i]);
			map.put("index",i+"");
			list.add(map);
		}
	}
}
String json = JSON.toJSONString(list,SerializerFeature.DisableCircularReferenceDetect);
%>

</HEAD>

<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_top} " ;//确定
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id="SearchForm" NAME=SearchForm STYLE="margin-bottom:0;height: 100%;" action="MultiFormmodeShareFieldBrowserIframe.jsp" method=post>
<input type="hidden" name="formid" id="formid" value="<%=formId %>" _hasinit="true">
<input type="hidden" name="field<%=fieldid %>" id="field<%=fieldid %>" value="<%=laiwen %>" _hasinit="true">
<input type="hidden" name="field<%=kxfieldid %>" id="field<%=kxfieldid %>" value="<%=kx %>" _hasinit="true">

<table id="topTitle" cellpadding="0" cellspacing="0" style="display:none">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(33703, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="btnok_onclick();">
				<span title="<%=SystemEnv.getHtmlLabelName(81804, user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
</table>
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
<td width="90%" valign="top">
	<table class=BroswerStyle style="width: 100%;height: 100%;">
	  <tr class=DataHeader>
	  	<TH width="1%">
	  		<input id="checkall" name ="checkall" value="" type="checkbox"></input>
		</TH>
	    <TH width="33%">标题</TH>
	    <TH width="33%">来问单位</TH>
	    <TH width="33%">栏目</TH>
	  </tr>
	  <TR class=Line><TH></TH></TR>
	  <TR>
		<td width="100%" valign="top" colspan="4">
		  <div style="overflow-y:auto;overflow-x:hidden;width:100%;height:100%;">
			<table width="100%" id="BrowseTable" >
			<COLGROUP>
			<col width="1%">
			<col width="33%">
        	<col width="33%">
        	<col width="33%">
        	</COLGROUP>
			<%
			if(needLoad){
				for(int i=0;i<list.size();i++){
					Map<String,String> map1 = list.get(i);
					%> <TR class=DataLight tagid="<%=map1.get("index") %>" sourceid="<%=map1.get("id") %>">
					 <TD style="word-break:break-all">
					 	<input id="check<%=map1.get("id") %>" name ="check<%=map1.get("id") %>" value="" type="checkbox"></input>
					 </TD>
					 <TD style="word-break:break-all"><%=map1.get("title") %></TD>
					 <TD style="word-break:break-all"><%=map1.get("unit") %></TD>
					 <TD style="word-break:break-all"><%=map1.get("type") %></TD>
				   </TR>
				<%}
			}%>
		  	</table>
		  </div>
		</td>
	  </TR>
	</table>
</td>
<td width="10%" valign="top">
	<table  cellspacing="1" align="left" width="100%" height="100%">
		<tr>
			<td align="center" valign="top" width="20%" style="background-color: #f6f6f6;border-left: 1px solid #e6e6e6;border-right: 1px solid #e6e6e6;">
				<div class="imgWarpDiv">
					<input type="button" value="追加" id="zd_btn_add" class="e8_btn_top_first pageBtn" title="追加" onclick="javascript:addFromList();">
					<!-- <img src="/govern/information/img/add3.jpg" style="height:34px" title="追加" onclick="javascript:addFromList();"><!-- 上移 -->				
				</div>
				<div class="imgWarpDiv">
					<input type="button" value="删除" id="zd_btn_delete" class="e8_btn_top_first pageBtn" title="删除" onclick="javascript:deleteFromList();">
				</div>
				<div class="imgWarpDiv">
					<input type="button" value="上移" id="zd_btn_up" class="e8_btn_top_first pageBtn" title="上移" onclick="javascript:upFromList();">
				</div>
				<div class="imgWarpDiv">
					<input type="button" value="下移" id="zd_btn_down" class="e8_btn_top_first pageBtn" title="下移" onclick="javascript:downFromList();">
				</div>
				<div class="imgWarpDiv">
					<input type="button" value="修改" id="zd_btn_edit" class="e8_btn_top_first pageBtn" title="修改" onclick="javascript:editFromList();">
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
var parentWin = null;
try{
	parentWin = parent.parent.parent.getParentWindow(parent.parent);
	dialog = parent.parent.parent.getDialog(parent.parent);
}catch(e){}

function closeWin(returnjson){
	if(dialog){
		try{
			var billid = <%=fwid%>
			<%if(needLoad){%>
			var data = {list:dataArray};
			jQuery.ajax({    
		    	type:'post',    
		    	url:'/govern/information/ContentSelectOperation.jsp?action=onDetailChange',
		    	cache:false,    
		    	dataType:'json',
		    	data:{jsonData:JSON.stringify(data),billid:billid},
		    	async : true,
		    	success:function(data){
				}
			});
			<%}%>
			dialog.callback(returnjson);
			dialog.close(returnjson);
			
		}catch(e){console.log(e)}
	}else{
		window.parent.parent.parent.returnValue=returnjson;
		window.parent.parent.parent.close();
	}
}	

function btnok_onclick(){
	//getReturn()
	var returnJo = getReturn();
	if(returnJo.msg == "needPrompt"){
		top.Dialog.alert("有来文未指定栏目，无法自动排版到期刊中。请修改！");
	}else{
		closeWin(returnJo);
	}
	
}

jQuery(document).ready(function(){
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
	jQuery("#BrowseTable").bind("mouseover",BrowseTable_onmouseover);
	jQuery("#BrowseTable").bind("mouseout",BrowseTable_onmouseout);
	jQuery(jQuery("#checkall").parents("th")[0]).bind("click",BrowseTable_checkAll);
})

var selectedRow = [];
<%if(needLoad){%>
	var dataArray = <%=json%>;
<%}else{%>
	var dataArray = [];
<%}%>
$(function(){
	<%if(!needLoad){%>
		var pw = parent.parent.parent.getParentWindow(parent.parent);
		var listData = pw.listData;
		for(var i=0;i<listData.length;i++){
			var obj = jQuery.extend(true, {}, listData[i]);
			//var index0 = obj.index;
			obj.index = i;
			dataArray.push(obj);
			var value = jQuery("#field<%=fieldid%>").val();
			var _value = value?(value + "," + obj.id):obj.id
			jQuery("#field<%=fieldid%>").val(_value);
			jQuery("#BrowseTable").append("<TR class=DataLight tagid=\""+i+"\" sourceid=\""+obj.id+"\">"+getIndexHtml(obj)+"<TR>");
		}
	<%}%>
})
function getReturn(){
	var returnStr = "";
	var returnMap = {}
	var returnList = [];
	var needPrompt = false;
	for(var i=0;i<dataArray.length;i++){
		var obj = jQuery.extend(true, {}, dataArray[i]);
		var typeid = obj.typeid;
		if(!typeid)
            needPrompt = true;
		var type = obj.type;
		var dataMap = returnMap[typeid] ? returnMap[typeid] : {};
		var list = returnMap[typeid] ? dataMap.data : [];
		if(!returnMap[typeid]){
			dataMap.id = typeid;
			dataMap.name = type;
		}
		obj.index = list.length;
		obj.groupIndex = typeid + "-" + list.length;
		
		list.push(obj);
		returnStr += ","+obj.id;
		dataMap.data = list;
		returnList.push(obj);
		returnMap[typeid] = dataMap;
	}
	console.log("returnMap" , returnMap);
	console.log("returnList" , returnList);
	if(needPrompt){
		return {msg:"needPrompt"}
	}
	return {returnMap : returnMap , returnList : returnList , returnStr : returnStr.substring(1)};
}

function BrowseTable_checkAll(){
	if(selectedRow.length<dataArray.length){
		for(var i=0;i<dataArray.length;i++){
			var index = dataArray[i].index;
			if(!contain(selectedRow,index)){
        		rowSelected(index,true);
        		selectedRow.push(index);
      		}
		}
		selectedRow.sort(compare);
	}else{
		for(var i=0;i<dataArray.length;i++){
			var index = dataArray[i].index;
        	rowSelected(index,false);
		}
		selectedRow = [];
	}
}

function BrowseTable_onclick(e){
	var e=e||event;
	var target =  e.srcElement||e.target ;
	try{
		if(target.nodeName == "TD" || target.nodeName == "A" || target.nodeName == "INPUT" || target.nodeName == "SPAN"){
			var newEntry = jQuery(target).parents("tr")[0];
			var tagId = jQuery(newEntry).attr("tagId");
			if(contain(selectedRow,tagId)){
				rowSelected(tagId,false);
				selectedRow = removeObj(selectedRow,tagId);
			}else{
				rowSelected(tagId,true);
				selectedRow.push(tagId);
				selectedRow.sort(compare);
			}
		}
	}catch (en) {
		console.log(en.message);
	}
}

function rowSelected(indexId,flag){
	try{
		if(indexId || indexId==0){
			if(flag){
				jQuery("tr[tagid='"+indexId+"']")[0].className = "Selected";
				jQuery(jQuery("tr[tagid='"+indexId+"']")[0]).find("input[type='checkbox']").val("1");
				jQuery(jQuery(jQuery("tr[tagid='"+indexId+"']")[0]).find(".jNiceWrapper")[0]).find("span")[0].className="jNiceCheckbox jNiceChecked";
			}else{
				jQuery("tr[tagid='"+indexId+"']")[0].className = "DataLight";
				jQuery(jQuery("tr[tagid='"+indexId+"']")[0]).find("input[type='checkbox']").val("0");
				jQuery(jQuery(jQuery("tr[tagid='"+indexId+"']")[0]).find(".jNiceWrapper")[0]).find("span")[0].className="jNiceCheckbox";
			}
		}
	}catch(e){
		console.log(e);
	}
}

function BrowseTable_onmouseover(e){
	var e=e||event;
   	var target=e.srcElement||e.target;
   	if("TD"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   	}else if("A"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   	}
}

function BrowseTable_onmouseout(e){
    var e=e||event;
    var target=e.srcElement||e.target;
    var p;
	if(target.nodeName == "TD" || target.nodeName == "A" ){
        p=jQuery(target).parents("tr")[0];
        if(!contain(selectedRow, jQuery(p).attr("tagId"))){
        	p.className = "DataLight";
      	}
   	}
}

function checkSelected(){
	if(selectedRow.length==0){
		alert("请选择操作目标！");
		return false;
	}else{
		return true;
	}
}

function addFromList(){
	var url = "/systeminfo/BrowserMain.jsp?url=/interface/MultiCommonBrowser.jsp?type=browser.xxcb_dbxx&formmodefieldid=";
	url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));	
	onShowBrowser2(url,1);
}

function deleteFromList(){
	if(checkSelected()){
		top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("17048", user.getLanguage())%>', function() {
			try{
				var value = jQuery("#field<%=fieldid%>").val();
				if(value){
					var _value = ","+value+",";
					for(var j=0;j<selectedRow.length;j++){
						try{
							var id = dataArray[selectedRow[j]].id;
							if(_value.indexOf(","+id+",")>=0){
								_value = _value.replace(","+id+",",",");
							}
						}catch(e){
							console.log(e);
						}
					}
					_value = _value.substring(1,_value.length);
					if(_value){
						_value = _value.substring(0,_value.length-1);
					}
					jQuery("#field<%=fieldid%>").val(_value);
				}
				
				for(var j=selectedRow.length;j>0;j--){
					var _index = selectedRow[j-1];
					jQuery(jQuery("tr[tagid='"+_index+"']")[0]).remove();
					var index = parseInt(_index);
					var _dataArray = [];
					for(var i=0;i<dataArray.length;i++){
						if(i<index){
							_dataArray.push(jQuery.extend(true, {}, dataArray[i]));
						}else if(i>index){
							var a = jQuery.extend(true, {}, dataArray[i]);
							a.index = (i-1)+"";
							_dataArray.push(a);
							jQuery(jQuery("tr[tagid='"+i+"']")[0]).attr("tagid",(i-1)+"");
						}
					}
					dataArray = _dataArray;
				}
				selectedRow = [];
			}catch(e){
				console.log(e);
			}
		});
	}
} 

function upFromList(){
	if(checkSelected() && selectedRow.length<dataArray.length){
		try{
			for(var j=0;j<selectedRow.length;j++){
				var _index = selectedRow[j];
				var index = parseInt(_index);
				if(selectedRow[j] != dataArray[j].index){
					var index1 = index-1;
					var a = jQuery.extend(true, {}, dataArray[index]);
					a.index = index1+"";
					var b = jQuery.extend(true, {}, dataArray[index1]);
					b.index = index+"";
					dataArray[index1] = a;
					dataArray[index] = b;

					jQuery(jQuery("tr[tagid='"+index1+"']")[0]).html(getIndexHtml(a));
					jQuery(jQuery("tr[tagid='"+index1+"']")[0]).attr("sourceid",a.id);
					rowSelected(index1,true);
					jQuery(jQuery("tr[tagid='"+index+"']")[0]).html(getIndexHtml(b));
					jQuery(jQuery("tr[tagid='"+index+"']")[0]).attr("sourceid",b.id);
					rowSelected(index,false);
					
					selectedRow = replaceArr(selectedRow,index+"",index1+"");
				}
			}
		}catch(e){
			console.log(e);
		}
	}
}

function downFromList(){
	if(checkSelected() && selectedRow.length<dataArray.length){
		try{
			for(var j=selectedRow.length;j>0;j--){
				var _index = selectedRow[j-1];
				var index = parseInt(_index);
				if(selectedRow[j-1] != dataArray[dataArray.length - 1 - (selectedRow.length - j)].index){
					var index1 = index+1;
					
					var a = jQuery.extend(true, {}, dataArray[index]);
					a.index = index1+"";
					var b = jQuery.extend(true, {}, dataArray[index1]);
					b.index = index+"";
					dataArray[index1] = a;
					dataArray[index] = b;
					
					jQuery(jQuery("tr[tagid='"+index1+"']")[0]).html(getIndexHtml(a));
					jQuery(jQuery("tr[tagid='"+index1+"']")[0]).attr("sourceid",a.id);
					rowSelected(index1,true);
					jQuery(jQuery("tr[tagid='"+index+"']")[0]).html(getIndexHtml(b));
					jQuery(jQuery("tr[tagid='"+index+"']")[0]).attr("sourceid",b.id);
					rowSelected(index,false);
					
					selectedRow = replaceArr(selectedRow,index+"",index1+"");
				}
			}
		}catch(e){
			console.log(e);
		}
	}
}

function editFromList(){
	if(checkSelected()){
		var url = '/systeminfo/BrowserMain.jsp?url=/interface/CommonBrowser.jsp?type=browser.xxcb_lanmuSearch1'
		onShowBrowser2(url,2);
	}
}

function getIndexHtml(data){
	var html = "";
	if(data){
		html = 
			"<TD style=\"word-break:break-all\">" +
			"<span class=\"jNiceWrapper\"><input id=\"check"+data.id+"\" name=\"check"+data.id+"\""+
			"value=\"\" type=\"checkbox\" class=\"jNiceHidden\" style=\"opacity: 0;\">" +
			"<span class=\"jNiceCheckbox\"></span></span>"+
			"</TD>" +
			"<TD style=\"word-break:break-all\">"+data.title+"</TD>" +
			"<TD style=\"word-break:break-all\">"+data.unit+"</TD>" +
			"<TD style=\"word-break:break-all\">"+data.type+"</TD>";
	}
	return html;
}
function addById(ids){
	jQuery.ajax({    
    	type:'post',    
    	url:'/govern/information/ContentSelectOperation.jsp?action=getTextById',
    	cache:false,    
    	dataType:'json',
    	data:{ids:ids,selectedId:""},
    	async : false,
    	success:function(data){
			if(data){
				var index = dataArray.length;
				var _dataArray = data.data;
				for(var i=0;i<_dataArray.length;i++){
					var obj = _dataArray[i];
					var index0 = index+i;
					obj.index = index0;
					dataArray.push(jQuery.extend(true, {}, obj));
					var value = jQuery("#field<%=fieldid%>").val();
					var _value = value?(value + "," + obj.id):obj.id
					jQuery("#field<%=fieldid%>").val(_value);
					jQuery("#BrowseTable").append("<TR class=DataLight tagid=\""+index0+"\" sourceid=\""+obj.id+"\">"+getIndexHtml(obj)+"<TR>");
				}
			}
		}
	});
}

function editType(id,name){
	for(var i=0;i<selectedRow.length;i++){
		var index = parseInt(selectedRow[i]);
		dataArray[index].typeid=id;
		dataArray[index].type=name;
		jQuery(jQuery(jQuery("tr[tagid='"+index+"']")[0]).find("td")[3]).html(name);
	}
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
var compare = function (x, y) {
    if (parseInt(x) > parseInt(y)) {
        return 1;
    } else if (parseInt(x) < parseInt(y)) {
        return -1;
    } else {
        return 0;
    }
}
</script>
</BODY>
</HTML>