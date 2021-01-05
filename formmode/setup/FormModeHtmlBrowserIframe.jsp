<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<jsp:useBean id="modeLayoutUtil" class="weaver.formmode.setup.ModeLayoutUtil" scope="page" /> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
</HEAD>
<%
int modeId=Util.getIntValue(request.getParameter("modeId"),0);
int formId=Util.getIntValue(request.getParameter("formId"),0);
int type=Util.getIntValue(request.getParameter("type"),-1);
String comfrom=Util.null2String(request.getParameter("comfrom"));  //comfrom=right 是从设置权限的页面跳转过来的
int flag=Util.getIntValue(request.getParameter("flag"),-1);
String version = Util.null2String(request.getParameter("version"));

String layoutName = Util.null2String(request.getParameter("layoutName"));
String layouttype = Util.null2String(request.getParameter("layouttype"));
String searchkeyname = Util.null2String(request.getParameter("searchkeyname"));

StringBuffer layouttypeBuffer = new StringBuffer();
layouttypeBuffer.append("<select name=\"layouttype\" id=\"layouttype\">");
layouttypeBuffer.append("<option value=\"\"></option>");
if(comfrom.equals("right")){
	String layouttypeLabel = "";
	switch(type){
		case 0:
			layouttypeLabel = SystemEnv.getHtmlLabelName(89,user.getLanguage());
			break;
		case 1:
			layouttypeLabel = SystemEnv.getHtmlLabelName(82,user.getLanguage());
			break;
		case 2:
			layouttypeLabel = SystemEnv.getHtmlLabelName(93,user.getLanguage());
			break;
		case 3:
			layouttypeLabel = SystemEnv.getHtmlLabelName(665,user.getLanguage());
			break;
		case 4:
			layouttypeLabel = SystemEnv.getHtmlLabelName(257,user.getLanguage());
			break;
	}
	String selected = "";
	if(layouttype.equals(type+"")){
		selected = "selected";
	}
	layouttypeBuffer.append("<option value=\""+type+"\" "+selected+" >"+layouttypeLabel+"</option>");
}else{
	for(int i=0;i<=4;i++){
		//新建、编辑布局，只能选择新建或编辑布局
		if((type == 1 || type ==2) && (i!=1 && i!=2)){
			continue;
		}
		//监控、打印布局，只能选择显示、监控、打印布局
		if((type==3 || type==4) && (i==1 || i==2)){
			continue;
		}

		String layouttypeLabel = "";
		switch(i){
			case 0:
				layouttypeLabel = SystemEnv.getHtmlLabelName(89,user.getLanguage());
				break;
			case 1:
				layouttypeLabel = SystemEnv.getHtmlLabelName(82,user.getLanguage());
				break;
			case 2:
				layouttypeLabel = SystemEnv.getHtmlLabelName(93,user.getLanguage());
				break;
			case 3:
				layouttypeLabel = SystemEnv.getHtmlLabelName(665,user.getLanguage());
				break;
			case 4:
				layouttypeLabel = SystemEnv.getHtmlLabelName(257,user.getLanguage());
				break;
		}
		String selected = "";
		if(layouttype.equals(i+"")){
			selected = "selected";
		}
		layouttypeBuffer.append("<option value=\""+i+"\" "+selected+" >"+layouttypeLabel+"</option>");
	}
}
layouttypeBuffer.append("</select>");

int languages = user.getLanguage();
String backFields = "a.id,a.modeid,a.formid,a.type,a.layoutName,a.version,b.modeName";
String sqlFrom = "from modehtmllayout a left join modeinfo b on a.modeid=b.id";
String SqlWhere = " a.modeid= " + modeId + " and a.formid = " + formId;
String sqlorderby = "a.type,a.id";

if(!"".equals(layouttype)){
	SqlWhere += " and a.type="+layouttype;
}else{
	if(comfrom.equals("right")){
		SqlWhere += " and a.type in ('"+type+"')";
	}else{
		if(type==1 || type==2){
			SqlWhere += " and a.type in ('1','2')";
		}else if(type==3 || type==4){
			SqlWhere += " and a.type in ('0','3','4')";
		}
	}
	if(flag > 0){
		SqlWhere += " and a.type>0";
	}
}

if (!"".equals(layoutName)) {
	SqlWhere += " and a.layoutName like '%"+layoutName+"%'";
}

if (!"".equals(searchkeyname)) {
	SqlWhere += " and a.layoutName like '%"+searchkeyname+"%'";
}
if(!"".equals(version)){
	SqlWhere += " and a.version = "+version;
}

String sql = "select subCompanyId from modeinfo where id="+modeId;
RecordSet recordSet = new RecordSet();
recordSet.executeSql(sql);
int subCompanyId = -1;
if(recordSet.next()){
	subCompanyId = recordSet.getInt("subCompanyId");
}
String userRightStr = "ModeSetting:All";
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);
String subCompanyId2 = ""+subCompanyId;

%>

<BODY>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_top} " ;//搜索
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:searchReset(),_top} " ;//重新设置
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,languages)+",javascript:onCancel(),_top} " ;//取消
RCMenuHeight += RCMenuHeightStep;
if(operatelevel>1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,languages)+",javascript:submitClear(),_top} " ;//清除
	RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(82529,user.getLanguage())%>" style="font-size: 12px;cursor: pointer;"><!-- 搜索 -->
				<input class="e8_btn_top middle" onclick="javascript:submitData()" type="button" value="<%=SystemEnv.getHtmlLabelName(82529,user.getLanguage())%>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span><!-- 菜单 -->
		</wea:item>
	</wea:group>
</wea:layout>


<FORM id="SearchForm" name="SearchForm" action="FormModeHtmlBrowserIframe.jsp" method="post">
<input type="hidden" id="modeId" name="modeId" value="<%=modeId%>">
<input type="hidden" id="formId" name="formId" value="<%=formId%>">
<input type="hidden" id="type" name="type" value="<%=type%>">
<input type="hidden" id="flag" name="flag" value="<%=flag%>">
<input type="hidden" id="comfrom" name="comfrom" value="<%=comfrom%>">
<input type=hidden name=searchkeyname id="searchkeyname" value="<%=searchkeyname%>"/>
<table  width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td ></td>
	<td valign="top">
	  <TABLE class=Shadow>
		<tr>
		  <td valign="top">
			 <table class="e8_tblForm" style="margin: 10px 0;">
			   <TR>
				 <TD width=20% class="e8_tblForm_label">
				   <%=SystemEnv.getHtmlLabelName(18151,user.getLanguage()) %><!--模板名称-->
				 </TD>
				 <TD width=30% class="e8_tblForm_field"><input name=layoutName value="<%=layoutName%>" class="InputStyle"></TD>
				 <TD width=20% class="e8_tblForm_label">
				    <%=SystemEnv.getHtmlLabelName(20622,user.getLanguage()) %><!--模板类型-->
				 </TD>
				 <TD width=30% class="e8_tblForm_field">
					<%=layouttypeBuffer %>
				 </TD>
			    </TR>
			    <TR>
				 <TD width=20% class="e8_tblForm_label">
				   <%=SystemEnv.getHtmlLabelNames("19407,19071",user.getLanguage())%><!-- 布局模式 -->
				 </TD>
				 <TD width=30% class="e8_tblForm_field">
				 	<select id="version" name="version" onchange="versionChangeFun()">
						<option value=""></option>
						<option value="0" <%if("0".equals(version)){%>selected<%} %>><%=SystemEnv.getHtmlLabelName(84089,user.getLanguage())%></option>
						<option value="2" <%if("2".equals(version)){%>selected<%} %>><%="excel"+SystemEnv.getHtmlLabelNames("19071,64",user.getLanguage())%></option>
					</select>
				 </TD>
				 <TD width=20% class="e8_tblForm_label"></TD>
				 <TD width=30% class="e8_tblForm_field"></TD>
			    </TR>
			  </table>
			</td>
		  </tr>
		</TABLE>
	 </td>
	 <td></td>
  </tr>
</table>

</FORM>
<!-- 显示查询结果 -->    
<div id="splitPageContiner">  
<%
int perpage=10;
String tableString=""+
				"<table pagesize=\""+perpage+"\" tabletype=\"none\">"+
					"<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"a.id\" sqlorderby=\""+sqlorderby+"\" sqlsortway=\"Asc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(SqlWhere)+"\"/>"+
						"<head>"+ //模板名称
							"<col width=\"35%\"  text=\""+SystemEnv.getHtmlLabelName(18151,languages)+"\" column=\"layoutName\" orderkey=\"layoutName\" />"+
							//模板类型
							"<col width=\"16%\"  text=\""+SystemEnv.getHtmlLabelName(20622,languages)+"\" column=\"type\" orderkey=\"type\" otherpara=\""+languages+"\" transmethod=\"weaver.formmode.interfaces.InterfaceTransmethod.getLayoutType\"/>"+
							//布局模式
							"<col width=\"18%\"  text=\""+SystemEnv.getHtmlLabelNames("19407,19071",user.getLanguage())+"\" column=\"version\" orderkey=\"version\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.formmode.interfaces.InterfaceTransmethod.getLayoutModel\"/>"+
							//布局模式
							"<col width=\"31%\"  text=\""+SystemEnv.getHtmlLabelName(19049,languages)+"\" column=\"modeName\" orderkey=\"modeName\"/>"+
							"<col width=\"0\" name=\"version\" hide=\"true\" text=\""+SystemEnv.getHtmlLabelNames("19407,19071",user.getLanguage())+"\" column=\"version\" otherpara=\""+user.getLanguage()+"\" />"+
						"</head>"+
				"</table>";
			  %>
			  <wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" isShowTopInfo="true"/>
</div>
</BODY>
</HTML>

<script type="text/javascript">
var parentWin = parent.parent.parent.getParentWindow(parent.parent);
var dialog = parent.parent.parent.getDialog(parent.parent);

jQuery(document).ready(function(){
	$(".loading", window.document).hide();
	$("#_xTable").bind("click",BrowseTable_onclick);
	$("input[name='layoutName']").bind('keydown',function(event){
		if(event.keyCode == 13){    
			submitData();
		}
	});
	$("#layouttype").bind("change",function(){
		submitData();
	});
})

function versionChangeFun(){
	submitData();
}


function BrowseTable_onclick(e){
   var e=e||event;
   var target=e.srcElement||e.target;
   if( target.nodeName =="TD"){
   		var id = jQuery(jQuery(target).parents("tr")[0].cells[0]).find("input[type='checkbox']").val();
   		var name = jQuery(jQuery(target).parents("tr")[0].cells[1]).text();
   		var version = jQuery(target).closest("tr").find("[name='version']").text();
	 	var returnjson = {id:id,name:name,version:version};
		if(dialog){
	    	dialog.callback(returnjson);
		}else{  
	    	window.parent.parent.returnValue  = returnjson;
	    	window.parent.parent.close();
		}
	}
}
function submitClear(){
	var returnjson = {id:"",name:""};
	if(dialog){
	    dialog.callback(returnjson);
	}else{  
	    window.parent.parent.returnValue  = returnjson;
	    window.parent.parent.close();
	}
}

function setSearchName(_parent) {
	var searchNameValue="";
    if (_parent){
    	searchNameValue=_parent.document.getElementById("searchName").value;
    }else {
    	searchNameValue=document.getElementById("searchName").value;
    }
    jQuery("#searchkeyname").val(searchNameValue);
}

function clearSearchName() {
	document.getElementById("searchkeyname").value = "";
	parent.document.getElementById("searchName").value = "";
}

function onBtnSearchClick(){
	setSearchName();
	submitData();
}

function submitData(){
	document.SearchForm.submit();
}

function searchReset() {
	$("input[name='layoutName']").val("");
	//清除下拉框
    jQuery("select[name^='layouttype'][ishide!='1']").val("");
	jQuery("a[class='sbSelector']").html("");
	jQuery("#version").val("");
	submitData();
}

function onCancel(){
	if(dialog){
	    dialog.close();
	}else{  
	    window.parent.parent.close();
	}
}
</script>

