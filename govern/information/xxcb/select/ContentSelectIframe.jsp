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
</style>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%
String dataids = Util.null2String(request.getParameter("dataids"));

List<Map<String,String>> list = new ArrayList<Map<String,String>>();


String[] dataid = dataids.split(",");
for(int i=0;i<dataid.length;i++){
	rs.executeSql("select * from uf_xxcb_sbInfo where id="+dataid[i]);
	if(rs.next()){
		String id = Util.null2String(rs.getString("id"));
		String bt = Util.null2String(rs.getString("bt"));
		String bsdw = Util.null2String(rs.getString("bsdw"));
		
		Map<String,String> map = new HashMap<String,String>();
		map.put("index",i+"");
		map.put("id",id);
		map.put("bt",bt);
		map.put("dwname",SubCompanyComInfo.getSubcompanyname(bsdw));
		list.add(map);
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

<table id="topTitle" cellpadding="0" cellspacing="0" style="display:none">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<input type="button" value=" 确 认 " id="zd_btn_submit" class="e8_btn_top" onclick="btnok_onclick();">
				<span title="菜单" class="cornerMenu"></span>
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
	  		<!--input id="checkall" name ="checkall" value="" type="checkbox"></input-->
		</TH>
	    <TH width="10%" align="center">序号</TH>
	    <TH width="60%" align="center">标题</TH>
	    <TH width="29%" align="center">投稿单位</TH>
	  </tr>
	  <TR class=Line><TH></TH></TR>
	  <TR>
		<td width="100%" valign="top" colspan="4">
		  <div style="overflow-y:auto;width:100%;height:100%;">
			<table width="100%" id="BrowseTable" >
				<COLGROUP>
					<col width="1%">
					<col width="10%">
		      <col width="60%">
		      <col width="29%">
        </COLGROUP>
			<%
			for(int i=0;i<list.size();i++){
				Map<String,String> map1 = list.get(i);
				%> 
					<TR class=DataLight tagid="<%=map1.get("index") %>" sourceid="<%=map1.get("id") %>">
					 <TD style="word-break:break-all">
					 	<input id="check<%=map1.get("id") %>" name ="check<%=map1.get("id") %>" value="" type="checkbox"></input>
					 </TD>
					 <TD style="word-break:break-all"><%=map1.get("index") %></TD>
					 <TD style="word-break:break-all"><%=map1.get("bt") %></TD>
					 <TD style="word-break:break-all"><%=map1.get("dwname") %></TD>
			    </TR>
			<%}%>
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
				<!--div class="imgWarpDiv">
					<img src="/govern/information/img/add3.jpg" style="height:34px" title="追加" onclick="javascript:addFromList();"><!-- 追加 -->
				</div-->
				<div class="imgWarpDiv">
					<!--img src="/govern/information/img/delete2.jpg" style="width:34px;height:34px" title="删除" onclick="javascript:deleteFromList();"--><!-- 删除 -->
					<input type="button" value=" 删除 " class="e8_btn_top_first" title=" 删除 "  onclick="javascript:deleteFromList();" style="max-width: 100px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
				</div>
				<div class="imgWarpDiv">
					<!--img src="/govern/information/img/upWith.jpg" style="height:34px" title="上移" onclick="javascript:upFromList();"--><!-- 上移 -->
					<input type="button" value=" 上移 " class="e8_btn_top_first" title=" 上移" "  onclick="javascript:upFromList();" style="max-width: 100px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
				</div>
				<div class="imgWarpDiv">
					<!--img src="/govern/information/img/downWith.jpg" style="height:34px" title="下移" onclick="javascript:downFromList();"--><!-- 下移 -->
					<input type="button" value=" 下移 " class="e8_btn_top_first" title=" 下移 "  onclick="javascript:downFromList();" style="max-width: 100px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
				</div>
				<!--div class="imgWarpDiv">
					<img src="/govern/information/img/edit3.jpg" style="height:32px;width:32px" title="修改栏目" onclick="javascript:editFromList();"><!-- 修改栏目 -->
				</div-->
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
try{
	//parentWin = parent.parent.getParentWindow(parent.parent);
	//dialog = parent.parent.getDialog(parent.parent);
	parentWin = window.parent.parent.getParentWindow(window.parent);
	dialog = window.parent.parent.getDialog(window.parent);
}catch(e){}

function closeWin(returnjson){
	if(dialog){
		try{
			dialog.callback(returnjson);
			dialog.close(returnjson);
		}catch(e){}
	}else{
		window.parent.parent.returnValue=returnjson;
		window.parent.parent.close();
	}
}	

function btnok_onclick(){
	//获取刊型 子栏目信息
	var kx = jQuery("#kxSelect",parent.document).val();
	if(kx==''){
		Dialog.alert("请选择刊型");   
		return false;
	}	
	var lm = jQuery("#lmSelect",parent.document).val();
  //alert(kx+" - "+lm);
  
	var allids = "";
	jQuery(".DataLight,.Selected").each(function(){
	  allids += jQuery(this).attr("sourceid")+",";
	});
	//alert("allids="+allids);
	//alert("ContentSelectOperation.jsp?kx="+kx+"&lm="+lm+"&ids="+allids);
	
  jQuery.ajax({
	type:'get',
	url:"ContentSelectOperation.jsp?kx="+kx+"&lm="+lm+"&ids="+allids,
	dataType : "json",
	async:false,
	success:function do4Success (obj){ 
		//alert(obj.result);
		Dialog.alert("操作成功");   
		closeWin(getReturn());
		
	}, 
		error:function (){ 
		top.Dialog.alert("Error");
		} 
	});
  
  //window.parent.parent.getDialog(window.parent).close();   //关闭弹出窗
	
	//getReturn();
	
}

jQuery(document).ready(function(){
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
	jQuery("#BrowseTable").bind("mouseover",BrowseTable_onmouseover);
	jQuery("#BrowseTable").bind("mouseout",BrowseTable_onmouseout);
	jQuery(jQuery("#checkall").parents("th")[0]).bind("click",BrowseTable_checkAll);
})

var selectedRow = [];
var dataArray = <%=json%>;

function getReturn(){
	var returnMap = {}
	var returnList = []
	for(var i=0;i<dataArray.length;i++){
		var obj = jQuery.extend(true, {}, dataArray[i]);
		var typeid = obj.typeid;
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
		dataMap.data = list;
		returnList.push(obj);
		returnMap[typeid] = dataMap;
	}
	console.log("returnMap" , returnMap);
	console.log("returnList" , returnList);
	return {returnMap : returnMap , returnList : returnList};
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
		selectedRow.sort();
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
				selectedRow.sort();
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
	var url = "/systeminfo/BrowserMain.jsp?url=/interface/MultiCommonBrowser.jsp?type=browser.sblw&formmodefieldid=";
	url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));	
	onShowBrowser2(url,1);
}

function deleteFromList(){
	if(checkSelected()){
		top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("17048", user.getLanguage())%>', function() {
			try{
				var value = "";
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
					//jQuery("#field<%//=fieldid%>").val(_value);
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

//上移
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
	var url = '/systeminfo/BrowserMain.jsp?url=/interface/CommonBrowser.jsp?type=browser.lwlm'
	onShowBrowser2(url,2);
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
			"<TD style=\"word-break:break-all\">"+data.index+"</TD>" +
			"<TD style=\"word-break:break-all\">"+data.bt+"</TD>" +
			"<TD style=\"word-break:break-all\">"+data.dwname+"</TD>";
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
					
					
					//var value = jQuery("#field<%//=fieldid%>").val();
					
					
					var _value = value?(value + "," + obj.id):obj.id
					
					
					//jQuery("#field<%//=fieldid%>").val(_value);
					
					
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
</script>
</BODY>
</HTML>