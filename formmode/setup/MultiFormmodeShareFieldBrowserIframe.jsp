
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
<HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css />
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%
int modeId = Util.getIntValue(request.getParameter("modeId"));
String selfieldid = Util.null2String(request.getParameter("selectedids"));
//out.println(modeId+"	"+selfieldid);
String searchfieldname = Util.null2String(request.getParameter("searchfieldname"));
int type = Util.getIntValue(request.getParameter("type"));

String formtype =  Util.null2String(request.getParameter("formtype"));

String isRoleLimited = Util.null2String(request.getParameter("isRoleLimited"),"0");//1:表示角色受作用域控制时选择字段
String minbillid = "";
if(isRoleLimited.equals("1")){
	String minSql = "select min(id) as minid from workflow_billfield";
	rs.executeSql(minSql);
	if(rs.next()){
		minbillid = rs.getString("minid");
	}
}

int formid = 0;
String sql = "select formid from modeinfo where id = " + modeId;
rs.executeSql(sql);
while(rs.next()){
	formid = rs.getInt("formid");
}

HashMap hm = new HashMap();
String fieldsql = "select a.fieldlabel,a.id,a.fieldname,a.fieldhtmltype,a.type,a.detailtable from workflow_billfield a "; 
fieldsql += "where billid = "+formid+"  "; 
fieldsql += "and a.fieldhtmltype = 3 ";
if(type==1){//人员
	fieldsql += " and a.type in (166,165,17,1) ";	
	if(isRoleLimited.equals("1")){
		fieldsql += " union all select 882 as fieldlabel,-101 as id,'modedatacreater' as fieldname,'3' as fieldhtmltype,-1 as type,'' as detailtable from workflow_billfield where id="+minbillid;
	}
}else if(type==2){//部门
	fieldsql += " and a.type in (168,167,57,4) ";
	if(isRoleLimited.equals("1")){
		fieldsql += " union all select 19225 as fieldlabel,-102 as id,'modedatacreaterDept' as fieldname,'3' as fieldhtmltype,-1 as type,'' as detailtable from workflow_billfield where id="+minbillid;
	}
}else if(type==3){//分部
	fieldsql += " and a.type in (170,169,164,194) ";
	if(isRoleLimited.equals("1")){
		fieldsql += " union all select 22788 as fieldlabel,-103 as id,'modedatacreaterSubc' as fieldname,'3' as fieldhtmltype,-1 as type,'' as detailtable from workflow_billfield where id="+minbillid;
	}
}else if(type==4){//岗位
	fieldsql += " and a.type in (24,278) ";
} 

if(formtype != null && !formtype.equals("")){
	if(formtype.equals("0")){
		fieldsql += " and a.viewtype=0 ";
	}
}


fieldsql = "select distinct * from ( "+fieldsql+" ) t order by t.type,t.detailtable";

rs.executeSql(fieldsql);
while(rs.next()){
	int fieldlabel = Util.getIntValue(rs.getString("fieldlabel"),0);
	String indexdesc = SystemEnv.getHtmlLabelName(fieldlabel, user.getLanguage());
	String id = Util.null2String(rs.getString("id"));
	String fieldname = Util.null2String(rs.getString("fieldname"));
	String detailtable = Util.null2String(rs.getString("detailtable"));
	String tableindex="";
	if(!detailtable.equals("")){
		tableindex="("+SystemEnv.getHtmlLabelName(84496,user.getLanguage())+detailtable.substring(detailtable.lastIndexOf("_dt")+3)+")";
	}
	hm.put(id,indexdesc+tableindex);
}



String resourceids ="";
String resourcenames = "";

if (!selfieldid.equals("")) {
	String[] tempArray = Util.TokenizerString2(selfieldid, ",");
	for (int i = 0; i < tempArray.length; i++) {
		String tempname = Util.null2String((String)hm.get(tempArray[i]));
		if(!"".equals(tempname)) {
			resourceids += ","+tempArray[i];
			resourcenames += ","+tempname;
		}
	}
}
//out.println("<br>"+resourceids+"	"+resourcenames);

%>

</HEAD>

<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_top} " ;//搜索
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_top} " ;//确定
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_top} " ;//清除
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id="SearchForm" NAME=SearchForm STYLE="margin-bottom:0;height: 100%;" action="MultiFormmodeShareFieldBrowserIframe.jsp" method=post>
<input type="hidden" name="modeId" value='<%=modeId%>'>
<input type="hidden" name="selfieldid" value='<%=selfieldid%>'>
<input type="hidden" name="type" value='<%=type%>'>
<input type="hidden" name="isRoleLimited" value='<%=isRoleLimited%>'>
<table id="topTitle" cellpadding="0" cellspacing="0" style="display:none;">
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
		<tr style="height: 35px;">
		<td valign="top" colspan="2">
<table width=100% class=ViewForm>
  <TR>
	<TD width=15%><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></TD><!-- 字段显示名 -->
	<TD width=35% class=field><input class=InputStyle id=searchfieldname name=searchfieldname value="<%=searchfieldname%>" ></TD>
  </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
</table> 
</td>
</tr>
<tr width="100%">
<td width="60%" valign="top">
	<table class=BroswerStyle style="width: 100%;height: 100%;">
	  <tr class=DataHeader>
	    <TH ><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></TH><!-- 字段显示名 -->
	  </tr>
	  <TR class=Line><TH></TH></TR>
	  <TR>
		<td width="100%" valign="top">
		  <div style="overflow-y:auto;width:100%;height:100%;">
			<table width="100%" id="BrowseTable" >
			<COLGROUP>
			<%
			rs.executeSql(fieldsql);
			int j=0;
			while(rs.next()) {
				int fieldLabel = Util.getIntValue(rs.getString("fieldlabel"),0);
				String indexdesc = SystemEnv.getHtmlLabelName(fieldLabel, user.getLanguage());
				String id = Util.null2String(rs.getString("id"));
				String fieldname = Util.null2String(rs.getString("fieldname"));
				String detailtable = Util.null2String(rs.getString("detailtable"));
				if(formtype != null && !formtype.equals("")){
					if(!detailtable.equals("")){
						
						if(!detailtable.substring(detailtable.length()-1).equals(formtype)){
							
							continue;
						}
					}
				}
				String tableindex="";
				if(!detailtable.equals("")){
					tableindex="("+SystemEnv.getHtmlLabelName(84496,user.getLanguage())+detailtable.substring(detailtable.lastIndexOf("_dt")+3)+")";
				}
				if(indexdesc.toUpperCase().indexOf(searchfieldname.toUpperCase())<0){
					continue;
				}
                if(j==0){
					j=1;
			%> <TR class=DataLight>
			<%  }else{
					j=0;
			%> <TR class=DataDark>
			<%  }%>
				 <TD style="display:none"><A HREF=#><%=id%></A></TD>
				 <TD style="word-break:break-all"><%=indexdesc+tableindex%></TD>
			   </TR>
			<%}%>
		  	</table>
		  </div>
		</td>
	  </TR>
	</table>
</td>
<td width="40%" valign="top">
	<table  cellspacing="1" align="left" width="100%" height="100%">
		<tr>
			<td align="center" valign="top" width="20%" style="border-left: 1px solid #e6e6e6;border-right: 1px solid #e6e6e6;">
				<div class="imgWarpDiv">
					<img src="/js/dragBox/img/up_wev8.png" onmouseover="changeImg(this,'up-h_wev8.png','needcheck')" onmouseout="changeImg(this,'up_wev8.png')" title="<%=SystemEnv.getHtmlLabelName(15084,user.getLanguage())%>" onclick="javascript:upFromList();"><!-- 上移 -->
				</div>
				<div class="imgWarpDiv">
					<img src="/js/dragBox/img/6_wev8.png" onmouseover="changeImg(this,'6-h_wev8.png')" onmouseout="changeImg(this,'6_wev8.png')" title="<%=SystemEnv.getHtmlLabelName(17025,user.getLanguage())%>" onClick="javascript:addAllToList()"><!-- 全部增加 -->
				</div>
				<div class="imgWarpDiv">
					<img src="/js/dragBox/img/5_wev8.png" onmouseover="changeImg(this,'5-h_wev8.png','needcheck')" onmouseout="changeImg(this,'5_wev8.png')"  title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="javascript:deleteFromList(this);"><!-- 删除 -->
				</div>
				<div class="imgWarpDiv">
					<img src="/js/dragBox/img/7_wev8.png" onmouseover="changeImg(this,'7-h_wev8.png','needcheck_del')" onmouseout="changeImg(this,'7_wev8.png')"  title="<%=SystemEnv.getHtmlLabelName(16335,user.getLanguage())%>" onclick="javascript:deleteAllFromList(this);"><!-- 全部删除 -->
				</div>
				<div class="imgWarpDiv">
					<img src="/js/dragBox/img/down_wev8.png"   onmouseover="changeImg(this,'down-h_wev8.png','needcheck')" onmouseout="changeImg(this,'down_wev8.png')"  title="<%=SystemEnv.getHtmlLabelName(15085,user.getLanguage())%>" onclick="javascript:downFromList();"><!-- 下移 -->
				</div>
			</td>
			<td align="center" valign="top" width="80%">
				<select  name="srcList" multiple="true" style="width:100%;word-wrap:break-word;height: 100%;border: 0px;" >

				</select>
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

function changeImg(obj,imgname,type){
	var f = true;
	if(type&&type=='needcheck'){
		var val = $("[name=srcList]").val();
		if(!val){
			f = false;
		}
	}else if(type&&type=='needcheck_del'){
		var destList  = $("select[name=srcList]")[0];
		var len = destList.options.length;
		if(len==0){
			f = false;
		}
	}
	if(f){
		$(obj).attr("src","/js/dragBox/img/"+imgname);
	}
}

var resourceids ="<%=resourceids%>"
var resourcenames = "<%=resourcenames%>"
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
	
function btnclear_onclick(){
    var returnjson = {id:"",name:""};
    closeWin(returnjson);
}


function btnok_onclick(){
	 setResourceStr();
	 if(resourceids != ''){
	 	resourceids = resourceids.substring(1);
	 	resourcenames = resourcenames.substring(1);
	 }
	 var returnjson =  {id:resourceids,name:resourcenames};
	 closeWin(returnjson);
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

function deleteFromList(obj){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			destList.options[i] = null;
		}
	}
	reloadResourceArray();
	$(obj).trigger("mouseout");
}
function deleteAllFromList(obj){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
		if (destList.options[i] != null) {
			destList.options[i] = null;
		}
	}
	reloadResourceArray();
	$(obj).trigger("mouseout");
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
	$("input[name=selectedids]").val( resourceids.substring(1));
}

function doSearch()
{
	setResourceStr();
   $("selectedids").val(resourceids.substring(1)) ;
   document.SearchForm.submit();
}
</script>
</BODY>
</HTML>