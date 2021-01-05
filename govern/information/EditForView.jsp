
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
body{
    overflow:  hidden;
}
.Selected{
	background-color:#fff;
	height: 35px;
	font-size: 13px;
}
/* .Selected :hover{
	color:#2e6ad9!important;
	background-color:red !important;
}  */
/* tr :hover{
	color:#2e6ad9!important;
	background-color:red !important;
}  */
.rrr{
	background-color:green !important;
}
.pageBtn{
	max-width: 100px; 
	overflow: hidden; 
	text-overflow: ellipsis; 
	white-space: nowrap;
}
TABLE.ListStyle TR.HeaderForXtalbe TH,
TABLE.ListStyle TR.header TH,
TABLE.ListStyle TR.header TD,
TABLE.BroswerStyle TR.DataHeader TH  {
	*height:40px !important;
	height:30px !important;
	line-height:30px;
	/* padding: 0px 5px 0px 12px; */
	cursor: pointer;
    color:#000;
    background-color:rgb(248,248,248);
    font-weight:normal;
    border-bottom:2px solid #B7E0FE;
    border-collapse:collapse;
    text-align:left;
    font-size:16px;
    padding-left: 3px;
}
TABLE.ListStyle TR.DataDark TD, TABLE.ListStyle TR.DataLight TD, TABLE.BroswerStyle TR.DataDark TD, TABLE.BroswerStyle TR.DataLight TD {
    BACKGROUND-COLOR: #FFFFFF;
    color: #242424;
    height: 20px;
    border-bottom: 1px solid #E6E6E6;
    font-size: 13px;
}
TABLE.BroswerStyle TR.DataLight  {
	height: 35px;
}
.imgWarpDiv input{
	width: 100px;
    border-radius: 3px;
    height: 27px;
}
TABLE.BroswerStyle TR.DataLight:hover TD{
	color:#000;
	height:35px;
	BACKGROUND-COLOR:#f5fafb!important;
	border-bottom:1px solid #E6E6E6;
}
TABLE.BroswerStyle TR.Selected td{
	BACKGROUND-COLOR: #F0F0F0 !important;
    color: #242424;
    height: 20px;
    font-size: 13px;
	height: 20px;
    border-bottom: 1px solid #75bbf4;
}
</style>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%
String sid = Util.null2String(request.getParameter("sid"));
String billid = Util.null2String(request.getParameter("billid"));
String kx = Util.null2String(request.getParameter("kx"));
String lm = Util.null2String(request.getParameter("lm"));
String modeType = Util.null2String(request.getParameter("type"));
String title1 = Util.null2String(request.getParameter("title1"));
title1 = java.net.URLDecoder.decode(title1,"UTF-8");
String kxname = Util.null2String(request.getParameter("name"));
kxname = java.net.URLDecoder.decode(kxname,"UTF-8");
String defalutPeriods = Util.null2String(request.getParameter("defalutPeriods"));
String edittype = Util.null2String(request.getParameter("edittype"));
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

String lmfieldid = "";
rs.executeSql("select * from workflow_billfield where billid="+formId+" and fieldname='bs_lm' and (detailtable = '' or detailtable is null)");
if(rs.next()){
	lmfieldid = Util.null2String(rs.getString("id"));
}
String lmStr = "";
if(!"".equals(lm)&&!"0".equals(lm)){
	lmStr = " and lm='"+lm+"'";
}
String gwid = "";
rs.execute("select * from uf_xxcb_pbInfo where id="+billid);
if(rs.next()){
	gwid = Util.null2String(rs.getString("gwid"));
}

List<Map<String,String>> list = new ArrayList<Map<String,String>>();
//rs.executeSql("select u.id id,u.zw content,u.bt title,u.unit unit,u.section typeid,l.name type from uf_communication u right join uf_traffic_section l on u.section=l.id where u.id in ("
//		+sid+")");
String sql = "select u.id id,u.zw content,u.bt title,u.bsdw unit,u.lm typeid,l.name type from uf_xxcb_dbInfo u left join uf_xxcb_kxSet_dt1 l on u.lm=l.id where u.id in ("+sid+")"+lmStr+" order by id";
if(!"".equals(billid)){
	sql = "select p.dbxx id,u.zw content,u.bt title,u.bsdw unit,u.lm typeid,l.name type from uf_xxcb_pbInfo_dt1 p left join uf_xxcb_dbInfo u on p.dbxx=u.id left join uf_xxcb_kxSet_dt1 l on p.lanmu=l.id where p.mainid='"+billid+"' order by p.showOrder";
	//sql = "select u.id id,u.zw content,u.bt title,u.bsdw unit,u.lm typeid,l.name type from uf_xxcb_dbInfo u left join uf_xxcb_kxSet_dt1 l on u.lm=l.id where id in ("+sid+")"+lmStr;	
	rs.execute("select * from uf_xxcb_pbInfo where id="+billid);
	if(rs.next()){
		sid = rs.getString("dbxx");
		
	}
}
rs.executeSql(sql);
int m = 0;
String fId = "";
while(rs.next()){
	String id = Util.null2String(rs.getString("id"));
	if("".equals(fId))
		fId = id;
	String title = Util.null2String(rs.getString("title"));
	String unit = Util.null2String(rs.getString("unit"));
	String typeid = Util.null2String(rs.getString("typeid"));
	String type = Util.null2String(rs.getString("type"));
	String content = Util.null2String(rs.getString("content"));
	title = title.replaceAll("&nbsp;"," ").replaceAll("<br>","\n");
	
	Map<String,String> map = new HashMap<String,String>();
	map.put("index",m+"");
	map.put("id",id);
	map.put("title",title);
	map.put("unitid",unit);
	map.put("unit",SubCompanyComInfo.getSubCompanyname(unit));
	map.put("typeid",typeid);
	map.put("type",type);
	map.put("content",content);
	list.add(map);
	m++;
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
<div style="border-radius: 3px; padding-bottom: 10px;background-color: #fff;">

	<div style="position:  relative;height: 50px;background-color: #fff;border-top-left-radius: 6px;border-top-right-radius: 6px;">
		<div style="height: 100%;padding-top: 10px;padding-left: 10px;position: absolute;">
			<!--  <img alt="图片" src="/js/tabs/images/nav/formmode_wev8.png" style="width: 20px;height: 20px;margin: 10px 0 0 50px;">-->
			<span id="tltleSpan" style="font-family: inherit;font-weight: bold;padding-top: -10px;font-size: 14pt!important;">
			<%=kxname%>&nbsp;第<%=defalutPeriods%>期<%=title1 %>
			</span>
		</div>
		<div style="float: right;margin-right: 69px;width: 300px;text-align:  center;position: absolute;right:  30px;margin-top: 20px;">选择所属子栏目：
	<select class=inputstyle  id="lm" name="lm"  onchange="changelevel()"  >
		<option value="0" <%if("".equals(lm)||"0".equals(lm)){%> selected <%}%>>全部</option>
		<%
			rs.execute("select * from uf_xxcb_kxSet_dt1 where mainid='"+kx+"'");
			while(rs.next()){
				String lmid = Util.null2String(rs.getString("id"));
				String name = Util.null2String(rs.getString("name"));
				if(!"".equals(lmid)&&!"".equals(name)){
			%>
				<option value="<%=lmid %>" <%if(lmid.equals(lm)){%> selected <%}%>><%=name %></option>
			<%}
			}%>
		</select>
		<!--  <button  style="
		width: 80px;
		height:  25px;
		margin-left:  20px;
		top: 1px;
		position:  absolute;
		border-radius:  3px;
		background-color: #30b5ff;
		color:  white;">按钮</button>-->
	</div>
	</div>
	<div style="height: 2px;background-color: #e9edf4;"></div>
	<FORM id="SearchForm" NAME=SearchForm STYLE="margin-bottom:0;height: 100%;" action="MultiFormmodeShareFieldBrowserIframe.jsp" method=post>
			<input type="hidden" name="formid" id="formid" value="<%=formId %>" _hasinit="true">
			<input type="hidden" name="field<%=fieldid %>" id="field<%=fieldid %>" value="<%=sid %>" _hasinit="true">
			<input type="hidden" name="field<%=kxfieldid %>" id="field<%=kxfieldid %>" value="<%=kx %>" _hasinit="true">
			<input type="hidden" name="field<%=lmfieldid %>" id="field<%=lmfieldid %>" value="" _hasinit="true">
			<table id="topTitle" cellpadding="0" cellspacing="0" style="display:none">
					<tr>
						<td></td>
						<td class="rightSearchSpan" style="text-align:right; width:500px!important">
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(33703, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="btnok_onclick();">
							<span title="<%=SystemEnv.getHtmlLabelName(81804, user.getLanguage()) %>" class="cornerMenu"></span>
						</td>
					</tr>
			</table>
			<table style="width: 100%;height: 100%;padding: 10px 20px;" border="0" cellspacing="0" cellpadding="0">
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
					<TH width="2%">
						<input id="checkall" name ="checkall" value="" type="checkbox"></input>
					</TH>
					<TH width="60%">标题</TH>
					<TH width="19%" style="text-align: center">报送单位</TH>
					<TH width="19%" style="text-align: center">栏目</TH>
				</tr>
				<TR class=Line><TH></TH></TR>
				<TR>
					<td width="100%" valign="top" colspan="4">
					<div style="overflow-y:auto;overflow-x:hidden;width:100%;height:201px">
						<table width="100%" id="BrowseTable" cellspacing="0">
						<COLGROUP>
						<col width="2%">
						<col width="60%">
						<col width="19%" align="center">
						<col width="19%" align="center">
						</COLGROUP>
						<%
						for(int i=0;i<list.size();i++){
							Map<String,String> map1 = list.get(i);
							%> <TR class=DataLight tagid="<%=map1.get("index") %>" sourceid="<%=map1.get("id") %>">
							<TD style="word-break:break-all" >
								<input id="check<%=map1.get("id") %>" name ="check<%=map1.get("id") %>" value="" type="checkbox"></input>
								<input type="hidden" class="typeStore" id="typeid_<%=map1.get("id") %>" name="typeid_<%=map1.get("id") %>" value="<%=map1.get("typeid") %>">
							</TD>
							<TD style="word-break:break-all"><%=map1.get("title") %></TD>
							<TD style="word-break:break-all" align="center"><%=map1.get("unit") %></TD>
							<TD style="word-break:break-all" align="center"><%=map1.get("type") %></TD>
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
						<td align="center" valign="top" width="20%" style="background-color: #e9edf4;border-left: 1px solid #e6e6e6;border-right: 1px solid #e6e6e6;">
							<div class="imgWarpDiv">
								<input <%if("0".equals(edittype)||!"".equals(gwid)){%>disabled="disabled" style="background-color: #d2d2d2;border: 1px solid #d2d2d2;"<%}else{%><%}%> type="button" value="追加" id="zd_btn_add" class="e8_btn_top_first pageBtn" title="追加" onclick="javascript:addFromList();">
								<!-- <img src="/govern/information/img/add3.jpg" style="height:34px" title="追加" onclick="javascript:addFromList();"><!-- 上移 -->				
							</div>
							<div class="imgWarpDiv">
								<input <%if("0".equals(edittype)||!"".equals(gwid)){%>disabled="disabled" style="background-color: #d2d2d2;border: 1px solid #d2d2d2;"<%}else{%><%}%> type="button" value="删除" id="zd_btn_delete" class="e8_btn_top_first pageBtn" title="删除" onclick="javascript:deleteFromList();">
							</div>
							<div class="imgWarpDiv">
								<input <%if("0".equals(edittype)||!"".equals(gwid)){%>disabled="disabled" style="background-color: #d2d2d2;border: 1px solid #d2d2d2;"<%}else{%><%}%> type="button" value="上移" id="zd_btn_up" class="e8_btn_top_first pageBtn" title="上移" onclick="javascript:upFromList();">
							</div>
							<div class="imgWarpDiv">
								<input <%if("0".equals(edittype)||!"".equals(gwid)){%>disabled="disabled" style="background-color: #d2d2d2;border: 1px solid #d2d2d2;"<%}else{%><%}%> type="button" value="下移" id="zd_btn_down" class="e8_btn_top_first pageBtn" title="下移" onclick="javascript:downFromList();">
							</div>
							<div class="imgWarpDiv">
								<input <%if("0".equals(edittype)||!"".equals(gwid)){%>disabled="disabled" style="background-color: #d2d2d2;border: 1px solid #d2d2d2;"<%}else{%><%}%> type="button" value="修改" id="zd_btn_edit" class="e8_btn_top_first pageBtn" title="修改" onclick="javascript:editFromList();">
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
</div>

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
	//getReturn()
	closeWin(getReturn());
}

jQuery(document).ready(function(){
	jQuery(".DataLight TD").bind("mouseover",BrowseTable_hover);/* lsx */
	jQuery(".DataLight TD").bind("mouseout",BrowseTable_out);/* lsx */
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
	jQuery("#BrowseTable").bind("mouseover",BrowseTable_onmouseover);
	jQuery("#BrowseTable").bind("mouseout",BrowseTable_onmouseout);
	jQuery(jQuery("#checkall").parents("th")[0]).bind("click",BrowseTable_checkAll);
	<%if("0".equals(modeType)||"1".equals(modeType)){%>
		try{
			parent.changeEditUtl("<%=fId%>");
		}catch(e){
			console.log(e);
		}
	<%}%>
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
	return {returnMap : returnMap , returnList : returnList};
}

function BrowseTable_checkAll(){
	/*jQuery.ajax({    
    	type:'post',    
    	url:'/govern/information/ContentSelectOperation.jsp?action=getKxSet',
    	cache:false,    
    	dataType:'json',
    	data:{id:id},
    	async : false,
    	success:function(data){
            var ss = data.name
        }
    });*/
	if(old_typeid == "" || old_typeid == "0"){
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
	}else{
		if(selectedRow.length<typeCount){
			for(var i=0;i<dataArray.length;i++){
				var typeid = dataArray[i].typeid;
				var index = dataArray[i].index;
				if(old_typeid!=typeid)
					continue;
				
				if(!contain(selectedRow,index)){
	        		rowSelected(index,true);
	        		selectedRow.push(index);
	      		}
			}
			selectedRow.sort(compare);
		}else{
			for(var i=0;i<dataArray.length;i++){
				var typeid = dataArray[i].typeid;
				var index = dataArray[i].index;
				if(old_typeid!=typeid)
					continue;
	        	rowSelected(index,false);
			}
			selectedRow = [];
		}
	}
}
/*  
入叁：元素ele
出参：ele所有兄弟元素组成的数组
author: lsx
*/
function siblings(elm) {
var a = [];
var p = elm.parentNode.children;
for(var i =0,pl= p.length;i<pl;i++) {
	if(p[i] !== elm) a.push(p[i]);
}
a.push(elm);
return a;
}
function BrowseTable_hover(e){
	var e=e||event;
	var target =  e.srcElement||e.target ;	//td
	//console.log(target);
	var len=siblings(target).length;
	for(var i=0;i<len;i++){
		siblings(target)[i].style.color="#75bbf4";
	}
}
function BrowseTable_out(e){
	var e=e||event;
	var target =  e.srcElement||e.target ;
	var len=siblings(target).length;
	for(var i=0;i<len;i++){
		siblings(target)[i].style.color="#000";
	}	
}
function BrowseTable_onclick(e){
	var e=e||event;
	var target =  e.srcElement||e.target ;
	try{
		if(target.nodeName == "TD" || target.nodeName == "A" || target.nodeName == "INPUT" || target.nodeName == "SPAN"){
			var newEntry = jQuery(target).parents("tr")[0];
			var tagId = jQuery(newEntry).attr("tagId");
			var sourceid = jQuery(newEntry).attr("sourceid");
			if(contain(selectedRow,tagId)){
				rowSelected(tagId,false);
				selectedRow = removeObj(selectedRow,tagId);
			}else{
				if(sourceid){
					try{
						parent.changeEditUtl(sourceid);
					}catch(e){
						console.log(e);
					}
				}
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
		var len=siblings(target).length;
		for(var i=0;i<len;i++){
			siblings(target)[i].style.color="#75bbf4";
		}
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
		var len=siblings(target).length;
		for(var i=0;i<len;i++){
			siblings(target)[i].style.color="#000";
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
	var browser = "browser.xxcb_dbxx";
	if(old_typeid != "" && old_typeid != "0")
		browser = "browser.xxcb_dbxxlm";
	var url = "/systeminfo/BrowserMain.jsp?url=/interface/MultiCommonBrowser.jsp?type="+browser+"&formmodefieldid=";
	url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));	
	onShowBrowser2(url,1);
}

function deleteFromList(){
	if(checkSelected()){
		top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("17048", user.getLanguage())%>', function() {
			try{
				selectedRow = selectedRow.sort(compare);
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
					lindex--;
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
				var eflag = (old_typeid == "" || old_typeid == "0") 
						? (selectedRow[j] != dataArray[j].index)
							:(selectedRow[j] != dataArray[j+findex].index)
				if(eflag){
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
				if((old_typeid == "" || old_typeid == "0") 
						? (selectedRow[j-1] != dataArray[dataArray.length - 1 - (selectedRow.length - j)].index)
							:(selectedRow[j-1] != dataArray[lindex - (selectedRow.length - j)].index)){
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

function checkType(){//如果选中了显示某一个子栏目 调整顺序时候先把对应的子栏目的内容调整到一起。
	var _selectedRow = [];
	findex = -1;
    lindex = -1;
	var count = 0;
	var lcount = 0;
	for(var j=0;j<dataArray.length;j++){
		var typeid = dataArray[j].typeid;
		if(typeid == old_typeid){
			if(findex == -1){
				findex = j;
			}else{
				if(count>0){
					if(contain(selectedRow,j)){
						rowSelected(j,false);
						rowSelected(j-count,true);
						_selectedRow.push((j-count)+"");
					}
					for(var i=0;i<count;i++){
						var index = j-i;
						var index1 = index-1;
						var a = jQuery.extend(true, {}, dataArray[index]);
						a.index = index1+"";
						var b = jQuery.extend(true, {}, dataArray[index1]);
						b.index = index+"";
						dataArray[index1] = a;
						dataArray[index] = b;
						jQuery(jQuery("tr[tagid='"+index1+"']")[0]).html(getIndexHtml(a));
						jQuery(jQuery("tr[tagid='"+index1+"']")[0]).attr("sourceid",a.id);
						jQuery(jQuery("tr[tagid='"+index+"']")[0]).html(getIndexHtml(b));
						jQuery(jQuery("tr[tagid='"+index+"']")[0]).attr("sourceid",b.id);
					}
				}
				//count = 0;
			}
			lcount++;
		}else{
			if(findex != -1){
				count++;
			}
		}
	}
	lindex = findex+lcount;
	selectedRow = _selectedRow;
	changed = true;
	//old_typeid
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
			"<input type=\"hidden\" class=\"typeStore\" id=\"typeid_"+data.id+"\" name=\"typeid_"+data.id+"\""+
			" value=\""+data.typeid+"\">"+
			"</TD>" +
			"<TD style=\"word-break:break-all\">"+data.title+"</TD>" +
			"<TD style=\"word-break:break-all\" align=\"center\">"+data.unit+"</TD>" +
			"<TD style=\"word-break:break-all\" align=\"center\">"+data.type+"</TD>";
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
					if(old_typeid != "" && old_typeid != "0"){
						var count = dataArray.length-1;
						var aindex = dataArray.length-1;;
						for(var i=0;i<count-lindex;i++){
							var index = count-i;
							var index1 = index-1;
							aindex = index1;
							var a = jQuery.extend(true, {}, dataArray[index]);
							a.index = index1+"";
							var b = jQuery.extend(true, {}, dataArray[index1]);
							b.index = index+"";
							dataArray[index1] = a;
							dataArray[index] = b;
							jQuery(jQuery("tr[tagid='"+index1+"']")[0]).html(getIndexHtml(a));
							jQuery(jQuery("tr[tagid='"+index1+"']")[0]).attr("sourceid",a.id);
							jQuery(jQuery("tr[tagid='"+index+"']")[0]).html(getIndexHtml(b));
							jQuery(jQuery("tr[tagid='"+index+"']")[0]).attr("sourceid",b.id);
						}
						jQuery(jQuery("tr[tagid='"+aindex+"']")[0]).css('display','');
						jQuery(jQuery("tr[tagid='"+count+"']")[0]).css('display','none');
						lindex++;
					}
				}
			}
		}
	});
}
var findex = -1;
var lindex = -1;
var old_typeid = "";
var changed = true;
var typeCount = 0;
function changelevel(){
	typeCount = 0;
	var typeid = jQuery("#lm").val();
	jQuery("#field<%=lmfieldid %>").val(typeid);
	if(typeid != old_typeid){
		selectedRow = [];
		old_typeid = typeid;
		checkType();
		jQuery(".typeStore").each(function(){
			var _typeid = jQuery(this).val();
			var obj = jQuery(jQuery(this).parents("tr")[0]);
			obj.css('display',(typeid == "" || typeid == "0") ? "" : (typeid == _typeid ? "" : "none")); 
			var tagId = obj.attr("tagId");
			if(typeid != "" && typeid != "0" && typeid == _typeid)
				typeCount++;
			rowSelected(tagId,false);
			jQuery("#checkall").val(0);
			jQuery(jQuery("#checkall").parents("span")[0]).find("span")[0].className="jNiceCheckbox";
		})
	}
}

function editType(id,name){
	for(var i=0;i<selectedRow.length;i++){
		var index = parseInt(selectedRow[i]);
		var data = dataArray[index];
		var _id = data.id;
		dataArray[index].typeid=id;
		dataArray[index].type=name;
		jQuery(jQuery(jQuery("tr[tagid='"+index+"']")[0]).find("td")[3]).html(name);
		jQuery("#typeid_"+_id).val(id);
	}
}

function updateDbxx(id,dwid,dwmc,bt){
	for(var i=0;i<dataArray.length;i++){
		if(dataArray[i].id == id){
			var index = dataArray[i].index;
			jQuery(jQuery("tr[tagid='"+index+"']").find("td")[1]).html(bt);
			jQuery(jQuery("tr[tagid='"+index+"']").find("td")[2]).html(dwmc);
			dataArray[i].unitid = dwid;
			dataArray[i].unit = dwmc;
			dataArray[i].title = bt;
		}
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