
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
   
    <title>元素开发</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles_wev8.css">
	-->
		<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
		<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
  </head>
  <LINK href="ElementTab_wev8.css" type="text/css" rel=STYLESHEET>
  <LINK href="/css/ecology8/upload_e8_Btn_wev8.css" type="text/css" rel=STYLESHEET>
  <SCRIPT language="javascript" src="/js/ecology8/portalEngine/upload_e8_Btn_wev8.js"></script>
  <body>
  	<%
		String titlename = "";
  	    String msg = Util.null2String(request.getParameter("msg"));
	%>

	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td width="300px">					
			</td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<input type="button" value="生成模板" class="e8_btn_top" onclick="doSaveTemp();"/>
				<input type="button" value="下一步" class="e8_btn_top" onclick="onNext();" />
				<input type="hidden" value="<%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%>" class="advancedSearch" onclick="jQuery('#advancedSearchDiv').toggle('fast');return false;"/>
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<div class="advancedSearchDiv" id="advancedSearchDiv">

	</div>
	
<form id="elementModel" name="elementModel" method="post" enctype="multipart/form-data" action="/weaver/weaver.admincenter.homepage.ElementCustomServlet">
	<div id="modelDiv" style="width:100%;">
		<input type="hidden" id="e_type" name="e_type" value="3"/>
		<input type="hidden" id="e_isuse" name="e_isuse" value="0"/>
<wea:layout type="2Col">
     <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())+"："%>' attributes="{'class':\"e8_title e8_title_1\"}">
      <wea:item>元素标识(字母或数字)</wea:item>
      <wea:item>
        <wea:required id="e_idspan" required="true">
         <input type="text" name="e_id" id="e_id" onchange='checkinput("e_id","e_idspan");this.value=trim(this.value)'/>
        </wea:required>
      </wea:item>
      <wea:item>元素名称(中文)</wea:item>
      <wea:item>
	  	<wea:required id="e_titlespan" required="true">
         <input type="text" name="e_title" id="e_title" onchange='checkinput("e_title","e_titlespan");this.value=trim(this.value)'/>
        </wea:required>
      </wea:item>
      <wea:item>元素名称(English)</wea:item>
      <wea:item><input type="text" id="e_titleEN" name="e_titleEN"/></wea:item>
      <wea:item>元素名称(繁體)</wea:item>
      <wea:item><input type="text" id="e_titleTHK" name="e_titleTHK"/></wea:item>
      <wea:item>元素描述</wea:item>
      <wea:item><input type="text" id="e_desc" name="e_desc"/></wea:item>
      <wea:item>元素类别</wea:item>
      <wea:item>
       <select id="e_loginview" name="e_loginview" style="width:136px;margin-left:2px;">
			<option value="0">登录后元素</option>
			<option value="1">登录前元素</option>
			<option value="2"> 元 素 </option>
		</select>
      </wea:item>
      <wea:item>元素图标</wea:item>
      <wea:item>
		<div class="ui-upload-filepath"> 
			<input type="text" class="ui-upload-filepathtxt" id="icon_filepathtxt"/>
			<input type="hidden" id="e_icon_imgpath" name="e_icon_imgpath"/>
		</div>
		<div class="ui-upload-holder" >
			<div class="ui-upload-txt">上传</div>
			<input type="file" class="ui-upload-input" id="e_icon" name="e_icon"  onchange="changeImgPath('e_icon','icon_filepathtxt','e_icon_imgpath');"/>
		</div>
		<div class="ui-upload-image-holder" >
			<div class="ui-upload-image-txt" onclick="showImgBrowser('e_icon','icon_filepathtxt','e_icon_imgpath');">浏览图库</div>
		</div>
	  </wea:item>
	  <wea:item>链接方式</wea:item>
      <wea:item>
       <select id="e_linkMode" name="e_linkMode" style="width:136px;margin-left:2px;">
			<option value="-1">无</option>
			<option value="1">默认窗口</option>
			<option value="2">弹出窗口</option>
		</select>
      </wea:item>
      <wea:item>默认显示条数</wea:item>
      <wea:item><input type="text" id="e_perpage" name="e_perpage"/></wea:item>
      <wea:item>资源文件(JS)</wea:item>
      <wea:item>
	  	<div class="ui-upload-filepath"> 
			<input type="text" class="ui-upload-filepathtxt" id="privateJS_filepathtxt"/> 
		</div> 
		<div class="ui-upload-holder" > 
			<div class="ui-upload-txt">上传</div> 
			<input type="file" class="ui-upload-input" id="e_privateJSList" name="e_privateJSList" onchange="changefilePath('e_privateJSList','privateJS_filepathtxt');"/> 
		</div>
	  </wea:item>
     </wea:group>
</wea:layout>
<div id="oShowTable"></div>
<div id="oSettingTable"></div>
</form>
<div id="rightMenuDiv">
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
		RCMenu += "{生成模版,javascript:doSaveTemp();,_self}";
		RCMenuHeight += RCMenuHeightStep; 
		RCMenu += "{开发指南,javascript:onHelp()',_self}";
		RCMenuHeight += RCMenuHeightStep; 
		RCMenu += "{下一步,javascript:onNext()',_self}";
		RCMenuHeight += RCMenuHeightStep;
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</div>	
</body>
</html>
<SCRIPT type="text/javascript" src="/js/addRowBg_wev8.js"></script>
<!-- for zDiaolg -->
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css"type="text/css"/>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<!--checkbox组件-->
<link href="/js/ecology8/jNice/jNice/jNice_wev8.css" type=text/css rel=stylesheet>
<script language=javascript src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
<!-- 下拉框美化组件-->
<link href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type=text/css rel=stylesheet>
<script language=javascript src="/js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js"></script>
<!-- 泛微可编辑表格组件-->
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<script type="text/javascript">
var showitems=[
{width:"15%",colname:"显示名称",itemhtml:"<input class=inputstyle type=text  name='showtitle_' /><span class='mustinput'></span>"},
{width:"15%",colname:"显示类型",itemhtml:"CHECKBOX<input class=inputstyle type=hidden value='checkbox'  name='showtype_'/>"},
{width:"15%",colname:"字段名称",itemhtml:"<input class=inputstyle type=text  name='showname_' /><span class='mustinput'></span>"},
{width:"15%",colname:"是否控制字数",itemhtml:"<select name='showdatatype_'><option value='1'>是</option><option value='0'>否</option></select>"},
{width:"15%",colname:"显示顺序",itemhtml:"<input class=inputstyle type=text  name='showdatalength_' value=''/>"}
];
var option= {
  openindex:true,
  navcolor:"#003399",
  basictitle:"显示字段：",
  toolbarshow:true,
  colItems:showitems,
  //addrowCallBack:function() {
     // alert("回调函数!!!");
  //},
  configCheckBox:true,
  checkBoxItem:{"itemhtml":'<input class="groupselectbox" type="checkbox" >',width:"3%"}
};
var group=new WeaverEditTable(option);
jQuery("#oShowTable").append(group.getContainer());

var settingitems=[
{width:"15%",colname:"显示名称",itemhtml:"<input class=inputstyle type=text  name='settingtitle_' /><span class='mustinput'></span>"},
{width:"15%",colname:"内容来源",itemhtml:"<select name='settingtype_'><option value='DataSource'>外部数据源</option><option value='DataPage'>数据页面</option></select>"},
{width:"15%",colname:"字段名称",itemhtml:"<input class=inputstyle type=text  name='settingname_'  /><span class='mustinput'></span>"},
{width:"15%",colname:"数据类型",itemhtml:"<select name='settingdatatype_"+settingrowindex+"'>"
						+"<option value='SQL'>数据库+SQL语句</option>"
						+"<option value='XML'>XML</option>"
						//+"<option value='RSS'>RSS</option>"
						+"<option value='JSON'>JSON</option>"
						//+"<option value='WebService'>webservice</option>"
						+"</select>"},
{width:"15%",colname:"显示方式",itemhtml:"<select name='settingdatalength_"+settingrowindex+"'>"
						+"<option value='showList'>列表式</option>"
						//+"<option value='showTop'>上图式</option>"
						//+"<option value='showLeft'>左图式</option>"
						+"</select>"}
];
option.basictitle="设置字段：";
option.colItems=settingitems;
group=new WeaverEditTable(option);
jQuery("#oSettingTable").append(group.getContainer());

var msg = "<%=msg%>";
var checkField = "e_id,e_title";
var checkshowField = "";
var checksettingField = "";
	jQuery(document).ready(function(){
		jQuery("#topTitle").topMenuTitle();
		jQuery(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
		jQuery("#tabDiv").remove();		
		
		if(msg=="1") jQuery("#customMessage").html("已存在元素标识相同的元素");
		else jQuery("#customMessage").html("");
		
		jQuery("#ele_custom_ul li span").each(function(){
			jQuery(this).bind("click",function(){
				jQuery("#ele_custom_ul li").removeClass("selectColor")
				window.location.hash=jQuery(this).attr("href");
				jQuery(this).parent().addClass("selectColor");
			})
		});
		
		jQuery("#ele_table").height(jQuery(window).height()-jQuery("#topTitle").height());
	});
	
	function onNext(){
		parent.location.href="/admincenter/portalEngine/ElementTabs.jsp?curUrl=register";
	}
	
	function onHelp(){
		var help_dialog = new Dialog();
		help_dialog.currentWindow = window;   //传入当前window
	 	help_dialog.Width = 500;
	 	help_dialog.Height = 300;
	 	help_dialog.Modal = false;
	 	help_dialog.Title = "开发指南"; 
	 	help_dialog.URL = "/admincenter/portalEngine/ElementCustomHelp.jsp";
	 	help_dialog.show();
	}
		
	function doSaveTemp(){
		if(group&&group.isValid()){
			alert("必填");
			return;
		}
		if(check_form(document.elementModel,"e_id,e_title"))
			elementModel.submit();
	}
	var showrowindex = 0;
	function addShowRow()
	{
		ncol = jQuery(oShowTable).find("tr:nth-child(4)").find("td").length;
		oRow = oShowTable.insertRow(-1);
		rowColor = getRowBg();
		for(j=0; j<ncol; j++) {
			oCell = oRow.insertCell(-1);
			oCell.style.height=24;
			oCell.style.background= rowColor;
			switch(j) {
	            case 0:
					var oDiv = document.createElement("div");
					var sHtml = "<input class=inputstyle type='checkbox' name='check_shownode' value='"+showrowindex+"'/>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
				case 1:
					var oDiv = document.createElement("div");
					var sHtml =  "<input class=inputstyle type=text  name='showtitle_"+showrowindex+"' onchange=\"checkinput('showtitle_"+showrowindex+"','showtitle_"+showrowindex+"span');this.value=trim(this.value)\"/>"
						+"<span id=\"showtitle_"+showrowindex+"span\"><IMG src=\"/images/BacoError_wev8.gif\" align=\"absMiddle\"></span>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
				case 2:
					var oDiv = document.createElement("div");
					var sHtml = "CHECKBOX<input class=inputstyle type=hidden value='checkbox'  name='showtype_"+showrowindex+"'/>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
				case 3:
					var oDiv = document.createElement("div");
					var sHtml = "<input class=inputstyle type=text  name='showname_"+showrowindex+"' onchange=\"checkinput('showname_"+showrowindex+"','showname_"+showrowindex+"span');this.value=trim(this.value)\"/>"
						+"<span id=\"showname_"+showrowindex+"span\"><IMG src=\"/images/BacoError_wev8.gif\" align=\"absMiddle\"></span>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
	            case 4:
					var oDiv = document.createElement("div");
					var sHtml = "<select name='showdatatype_"+showrowindex+"'>"
						+"<option value='1'>是</option>"
						+"<option value='0'>否</option>"
						+"</select>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
			    case 5:
					var oDiv = document.createElement("div");
					var sHtml = "<input class=inputstyle type=text  name='showdatalength_"+showrowindex+"' value='"+(showrowindex+1)+"'/>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
			}
		}
		showrowindex = showrowindex*1 +1;
		jQuery("input[name=showrownum]").val(showrowindex);
	}
	
	function deleteShowRow()
	{
		if(!isdel())return;
	   	len = document.forms[0].elements.length;
		var i=0;
		var rowsum1 = 1;
	    for(i=len-1; i >= 0;i--) {
			if (document.forms[0].elements[i].name=='check_shownode')
				rowsum1 += 1;
		}
		var delrow = 0;
		for(i=len-1; i >= 0;i--) {
			if (document.forms[0].elements[i].name=='check_shownode'){
				if(document.forms[0].elements[i].checked==true) {
					oShowTable.deleteRow(rowsum1+2);
					delrow+=1;
				}
				rowsum1 -=1;
			}
		}
		if(delrow)
			jQuery("input[name=showrownum]").val(jQuery("input[name=showrownum]").val()-delrow);
	}
	
	var settingrowindex = 0;
	function addSettingRow()
	{
		if(jQuery("input[name=check_settingnode]").length>0) return;
		ncol = jQuery(oSettingTable).find("tr:nth-child(4)").find("td").length;
		oRow = oSettingTable.insertRow(-1);
		rowColor = getRowBg();
		for(j=0; j<ncol; j++) {
			oCell = oRow.insertCell(-1);
			oCell.style.height=24;
			oCell.style.background= rowColor;
			switch(j) {
	            case 0:
					var oDiv = document.createElement("div");
					var sHtml = "<input class=inputstyle type='checkbox' name='check_settingnode' value='0'/>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
				case 1:
					var oDiv = document.createElement("div");
					var sHtml =  "<input class=inputstyle type=text  name='settingtitle_"+settingrowindex+"' onchange=\"checkinput('settingtitle_"+settingrowindex+"','settingtitle_"+settingrowindex+"span');this.value=trim(this.value)\"/>"
						+"<span id=\"settingtitle_"+settingrowindex+"span\"><IMG src=\"/images/BacoError_wev8.gif\" align=\"absMiddle\"></span>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
				case 2:
					var oDiv = document.createElement("div");
					var sHtml = "<select name='settingtype_"+settingrowindex+"'>"
						+"<option value='DataSource'>外部数据源</option>"
						+"<option value='DataPage'>数据页面</option>"
						+"</select>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
				case 3:
					var oDiv = document.createElement("div");
					var sHtml = "<input class=inputstyle type=text  name='settingname_"+settingrowindex+"' onchange=\"checkinput('settingname_"+settingrowindex+"','settingname_"+settingrowindex+"span');this.value=trim(this.value)\"/>"
						+"<span id=\"settingname_"+settingrowindex+"span\"><IMG src=\"/images/BacoError_wev8.gif\" align=\"absMiddle\"></span>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
	            case 4:
					var oDiv = document.createElement("div");
					var sHtml = "<select name='settingdatatype_"+settingrowindex+"'>"
						+"<option value='SQL'>数据库+SQL语句</option>"
						+"<option value='XML'>XML</option>"
						//+"<option value='RSS'>RSS</option>"
						+"<option value='JSON'>JSON</option>"
						//+"<option value='WebService'>webservice</option>"
						+"</select>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
			    case 5:
					var oDiv = document.createElement("div");
					var sHtml = "<select name='settingdatalength_"+settingrowindex+"'>"
						+"<option value='showList'>列表式</option>"
						//+"<option value='showTop'>上图式</option>"
						//+"<option value='showLeft'>左图式</option>"
						+"</select>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
			}
		}
		settingrowindex = settingrowindex*1 +1;
		jQuery("input[name=settingrownum]").val(settingrowindex);
	}
	
	function deleteSettingRow()
	{
		if(!isdel())return;
	   	len = document.forms[0].elements.length;
		var i=0;
		var rowsum1 = 1;
	    for(i=len-1; i >= 0;i--) {
			if (document.forms[0].elements[i].name=='check_settingnode')
				rowsum1 += 1;
		}
		var delrow = 0;
		for(i=len-1; i >= 0;i--) {
			if (document.forms[0].elements[i].name=='check_settingnode'){
				if(document.forms[0].elements[i].checked==true) {
					oSettingTable.deleteRow(rowsum1+2);
					delrow+=1;
				}
				rowsum1 -=1;
			}
		}
		if(delrow)
			jQuery("input[name=settingrownum]").val(jQuery("input[name=settingrownum]").val()-delrow);
	}
</script>
