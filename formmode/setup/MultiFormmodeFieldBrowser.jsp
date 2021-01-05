
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="modeLinkageInfo" class="weaver.formmode.setup.ModeLinkageInfo" scope="page" />
<HTML>
<HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css />
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%
int modeId = Util.getIntValue(request.getParameter("modeId"));
int type = Util.getIntValue(request.getParameter("type"));
String fieldname = Util.null2String(request.getParameter("fieldname"));
String selfieldid = Util.null2String(request.getParameter("selfieldid"));
String check_per = Util.null2String(request.getParameter("fieldids"));
String fieldids = "" ;
String fieldnames ="";
String newfieldids="";
String viewtype="-1";
int selectfieldid=0;
int indx=selfieldid.indexOf("_");
if(indx!=-1){
    selectfieldid=Util.getIntValue(selfieldid.substring(0,indx));
    viewtype=selfieldid.substring(indx+1);
}

modeLinkageInfo.setUser(user);
if (!check_per.equals("")) {
	fieldids=","+check_per;
	String[] tempArray = Util.TokenizerString2(fieldids, ",");
	for (int i = 0; i < tempArray.length; i++) {
		String tempDocName=modeLinkageInfo.getFieldnames(Util.getIntValue(tempArray[i].substring(0,tempArray[i].indexOf("_"))));
		if(!"".equals(tempDocName)) {
			newfieldids += ","+tempArray[i];
			fieldnames += ","+tempDocName;
		}
	}
}
%>

</HEAD>

<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_top} " ;//搜索
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_top} " ;//确定
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_top} " ;//清除
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="MultiFormmodeFieldBrowser.jsp" method=post>
<input type="hidden" name="modeId" value='<%=modeId%>'>
<input type="hidden" name="type" value='<%=type%>'>
<input type="hidden" name="selfieldid" value='<%=selfieldid%>'>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
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
		<tr>
		<td valign="top" colspan="3">
<table width=100% class=ViewForm>
  <TR>
	<TD width=15%><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></TD><!-- 字段显示名 -->
	<TD class=field><input class=InputStyle id=fieldname name=fieldname value="<%=fieldname%>" ></TD>
  </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
</table> 
<tr width="100%">
<td width="50%" valign="top">
	<table class=BroswerStyle width="100%">
	  <tr class=DataHeader>
	    <TH ><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></TH><!-- 字段显示名 -->
	  </tr>
	  <TR class=Line><TH></TH></TR>
	  <TR>
		<td width="100%">
		  <div style="overflow-y:scroll;width:100%;height:400px">
			<table width="100%" id="BrowseTable" >
			<COLGROUP>
			<%
			String fieldid=null;
			String _fielddbname=null;
			String _fieldname=null;
			String _viewtype=null;
			modeLinkageInfo.setUser(user);
			modeLinkageInfo.setSearchfieldname(fieldname.trim());
			modeLinkageInfo.setModeId(modeId);
			modeLinkageInfo.setType(type);
			modeLinkageInfo.setFieldId(selectfieldid);
			modeLinkageInfo.init();
			modeLinkageInfo.setViewtype(viewtype);
			List fieldList = modeLinkageInfo.getFieldsByEdit();
			Map map = null;
			int j=0;
			for(int i=0;i<fieldList.size();i++){
				map = (Map)fieldList.get(i);
				fieldid = (String)map.get("fieldid");
				_fieldname = (String)map.get("fieldname");
                _viewtype = (String)map.get("isdetail");
                if(selfieldid.equals(fieldid+"_"+_viewtype)) continue;
                if(j==0){
					j=1;
			%> <TR class=DataLight>
			<%  }else{
					j=0;
			%> <TR class=DataDark>
			<%  }%>
				 <TD style="display:none"><A HREF=#><%=fieldid+"_"+_viewtype%></A></TD>
				 <TD style="word-break:break-all"><%=_fieldname%></TD>
			   </TR>
			<%}%>
		  	</table>
		  </div>
		</td>
	  </TR>
	</table>
</td>
<td width="10%" valign="top">
	<table  cellspacing="1" align="left" width="100%">
		<tr>
			<td align="center" valign="top" width="20%">
				<img src="/images/arrow_u_wev8.gif" style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(15084,user.getLanguage())%>" onclick="javascript:upFromList();"><!-- 上移 -->
				<br><br>
					<img src="/images/arrow_left_all_wev8.gif" style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(17025,user.getLanguage())%>" onClick="javascript:addAllToList()"><!-- 全部增加 -->
				<br><br>
				<img src="/images/arrow_right_wev8.gif"  style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="javascript:deleteFromList();"><!-- 删除 -->
				<br><br>
				<img src="/images/arrow_right_all_wev8.gif"  style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(16335,user.getLanguage())%>" onclick="javascript:deleteAllFromList();"><!-- 全部删除 -->
				<br><br>
				<img src="/images/arrow_d_wev8.gif"   style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(15085,user.getLanguage())%>" onclick="javascript:downFromList();"><!-- 下移 -->
			</td>
		</tr>
	</table>
	</td>
<td align="center" valign="top" width="40%">
		<select size="30" name="srcList" multiple="true" style="width:100%;word-wrap:break-word;height:430px" >

		</select>
	</td>
	 	</tr>
	   </TABLE>
	 </td>
  </tr>
</table>
<input type="hidden" name="fieldids" value="">
</FORM>
<script type="text/javascript">
 var resourceids ="<%=fieldids%>"
 var resourcenames = "<%=fieldnames%>"
 var dialog = parent.parent.getDialog(parent);
	
function btnclear_onclick(){
	if(dialog){
	     dialog.callback({id:"",name:""});
	 }else{  
	    window.parent.parent.returnValue = {id:"",name:""};
	    window.parent.parent.close();
     }
}


function btnok_onclick(){
	 setResourceStr();
	 if(resourceids != ''){
	 	resourceids = resourceids.substring(1);
	 	resourcenames = resourcenames.substring(1);
	 }
	 var returnjson = {id:resourceids,name:resourcenames};
	 if(dialog){
	     dialog.callback(returnjson);
	 }else{  
		 window.parent.parent.returnValue = returnjson;
		 window.parent.parent.close();
	 }
}
jQuery(document).ready(function(){
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
	jQuery("#BrowseTable").bind("mouseover",BrowseTable_onmouseover);
	jQuery("#BrowseTable").bind("mouseout",BrowseTable_onmouseout);
})
function BrowseTable_onclick(e){
	var target =  e.srcElement||e.target ;
	try{
		if(target.nodeName == "TD" || target.nodeName == "A"){
			var newEntry = $($(target).parents("tr")[0].cells[0]).text()+"~"+jQuery.trim($($(target).parents("tr")[0].cells[1]).text()) ;
			if(!isExistEntry(newEntry,resourceArray)){
				addObjectToSelect($("select[name=srcList]")[0],newEntry);
				reloadResourceArray();
			}
		}
	}catch (en) {
		alert(en.message);
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
      if( p.rowIndex % 2 ==0){
         p.className = "DataDark";
      }else{
         p.className = "DataLight";
      }
   }
}

//Load
var resourceArray = new Array();
for(var i =1;i<resourceids.split(",").length;i++){
	resourceArray[i-1] = resourceids.split(",")[i]+"~"+resourcenames.split(",")[i];
}

loadToList();
function loadToList(){
	var selectObj = $("select[name=srcList]")[0];
	for(var i=0;i<resourceArray.length;i++){
		addObjectToSelect(selectObj,resourceArray[i]);
	}
	
}

function addObjectToSelect(obj,str){
	
	if(obj.tagName != "SELECT") return;
	var oOption = document.createElement("OPTION");
	obj.options.add(oOption);
	oOption.value = str.split("~")[0];
	$(oOption).text(str.split("~")[1]);
	
}

function isExistEntry(entry,arrayObj){
	
	for(var i=0;i<arrayObj.length;i++){
		
		if(entry == arrayObj[i].toString()){
			return true;
		}
	}
	return false;
}

function upFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = 0; i <= (len-1); i++) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i>0 && destList.options[i-1] != null){
				fromtext = destList.options[i-1].text;
				fromvalue = destList.options[i-1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i-1] = new Option(totext,tovalue);
				destList.options[i-1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
     }
  }
  reloadResourceArray();
}
function addAllToList(){
	var table =$("#BrowseTable");
	$("#BrowseTable").find("tr").each(function(){
		var str=$($(this)[0].cells[0]).text()+"~"+$.trim($($(this)[0].cells[1]).text());
		if(!isExistEntry(str,resourceArray))
			addObjectToSelect($("select[name=srcList]")[0],str);
	});
	reloadResourceArray();
}

function deleteFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}
function deleteAllFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if (destList.options[i] != null) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}
function downFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i<(len-1) && destList.options[i+1] != null){
				fromtext = destList.options[i+1].text;
				fromvalue = destList.options[i+1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i+1] = new Option(totext,tovalue);
				destList.options[i+1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
     }
  }
  reloadResourceArray();
}
//reload resource Array from the List
function reloadResourceArray(){
	resourceArray = new Array();
	var destList =$("select[name=srcList]")[0];
	for(var i=0;i<destList.options.length;i++){
		resourceArray[i] = destList.options[i].value+"~"+jQuery.trim(destList.options[i].text) ;
	}
	//alert(resourceArray.length);
}

function setResourceStr(){
	
	resourceids ="";
	resourcenames = "";
	for(var i=0;i<resourceArray.length;i++){
		resourceids += ","+resourceArray[i].split("~")[0] ;
		resourcenames += ","+resourceArray[i].split("~")[1] ;
	}
	//alert(resourceids+"--"+resourcenames);
	$("input[name=resourceids]").val( resourceids.substring(1));
}

function doSearch()
{
	setResourceStr();
   $("resourceids").val(resourceids.substring(1)) ;
   document.SearchForm.submit();
}
</script>
</BODY>
</HTML>