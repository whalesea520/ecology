
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.page.maint.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}	
%>

<%
String message = Util.null2String(request.getParameter("message"));
String titlename = SystemEnv.getHtmlLabelName(23011,user.getLanguage());
String layoutname = Util.null2String(request.getParameter("flowTitle"));
String sqlWhere ="";
if(!"".equals(layoutname)) sqlWhere += " layoutname like '%"+layoutname+"%'"; 
%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
   
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(19407,user.getLanguage())+",javascript:onAdd(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(75,user.getLanguage())+SystemEnv.getHtmlLabelName(19407,user.getLanguage())+",javascript:onupload(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<html>
 <head>
 <link href="/css/Weaver_wev8.css" type="text/css" rel=stylesheet>
 <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link href="/js/jquery/ui/jquery-ui_wev8.css" type="text/css" rel=stylesheet>

<!-- For zDialog -->
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css"type="text/css"/>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<style  id="thisStyle">
input.smallInput{
border:1 solid #fff;
FONT-SIZE: 9pt; 
FONT-STYLE: normal; 
FONT-VARIANT: normal; 
FONT-WEIGHT: normal; 
HEIGHT: 28px;
WIDTH:50; 
BACKGROUND-COLOR:#4f81bd;
LINE-HEIGHT: normal;
}
.layouttable {
    width: 150px;
    border-collapse: collapse;
    height: 100%;
    table-layout: fixed;
    cursor: pointer;
    height: 150px !important;
    margin: auto;
    margin-top: 22px;
}
.layouttable thead tr{
    height:1px;
}
.layouttable thead th{
    height:0px;
}
.layouttable tr {
    height: 25%;
}
 .layouttable  thead tr{
    height: 0;
}
  .layouttable td {
	border: 1px dashed #EEE6E6;
	vertical-align: middle !important;
	text-align: center !important;
	font-weight: bold;
	color: #ff9701 !important;
}
.e8ThumbnailImg{
    padding: 1px;
    margin: 0 auto;
    position: relative;
    width: 187px;
    height:192px;
}

.e8ThumbnailImg div{
    margin-bottom: 0px;
	text-align: center;
	padding-top: 10px;
	font-weight: bold;
	color: #3F3B3B;
}

.opcontainer{
	 display:none;
	 position:absolute;
	 right:0;
	 top:0;
	 line-height: 0;
     padding-top: 5px !important;
}
.opcontainer  img{
  margin-right: 15px;
  margin-top:2px;
}

.e8ThumbnailImg:hover .opcontainer{
   display:block;
}


</style>

</head>
<body  id="myBody">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<form action="LayoutList.jsp" method="post" name="LayoutForm">
	<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td width="160px">					
			</td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(19407,user.getLanguage()) %>" class="e8_btn_top" onclick="onAdd();" />
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(75,user.getLanguage())+SystemEnv.getHtmlLabelName(19407,user.getLanguage()) %>" class="e8_btn_top" onclick="onupload();" />
				<input type="text" class="searchInput" name="flowTitle"/>
				&nbsp;&nbsp;&nbsp;
				<input type="hidden" value="<%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%>" class="advancedSearch" onclick="jQuery('#advancedSearchDiv').toggle('fast');return false;"/>
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<div class="advancedSearchDiv" id="advancedSearchDiv">
	</div>
</form>
<%
String tableString="<table pagesize=\"12\" tabletype=\"thumbnailNoCheck\">"+
	"<browser imgurl=\"/weaver/weaver.splitepage.transform.SptmForLayoutThumbnail\" linkkey=\"id\" linkvaluecolumn=\"id\" path=\"\" />"+
	"<sql backfields=\"  id,layoutname,layoutdesc,layoutimage,layouttype,zipname  \" sqlform=\" pagelayout \" sqlprimarykey=\"id\" sqlsortway=\"asc\" sqlorderby=\"id\" sqlwhere=\""+sqlWhere+"\" />"+
	"<head>"+
		"<col width=\"100%\" text=\"\" column=\"layoutname\" orderkey=\"layoutname\" transmethod=\"weaver.splitepage.transform.SptmForLayoutThumbnail.getHref\" otherpara=\"column:id+column:layoutname+column:layoutimage+column:layouttype+column:zipname\" />"+
	"</head>"+
	"</table>";
%>
<TABLE width="100%">
	<tr><td>&nbsp;</td></tr>
	<TR>
		<TD valign="top">
			<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="false" isShowThumbnail="1" imageNumberPerRow="4"/>
		</TD>
	</TR>
</TABLE>	
</body>
</html>
<script>
   
    var lettersall = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];

  
	$(document).ready(function(){
		jQuery("#topTitle").topMenuTitle({searchFn:onSearch});
		jQuery(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
		jQuery("#tabDiv").remove();
		
		if('<%=message%>'=='1'){
			alert("<%=SystemEnv.getHtmlLabelName(104,user.getLanguage())+SystemEnv.getHtmlLabelName(498,user.getLanguage())%>")
		}
	});

	//展示布局
    function  showLayout(fid,table){
		if($("#layoutthumbnail_"+fid).length===0)
		{
			setTimeout(function(){
			   showLayout(fid,table); 
			},500);
		    return;
		}
		var tablestr=table.tableinfo;
		var container,layout,tds,td,tdtemp,inputitem,imgcontainer;
		inputitem=$("#layoutthumbnail_"+fid);
		container=inputitem.parent().parent().prev();
		if(tablestr!==undefined && tablestr!==''){
            layout=$(tablestr);
			tds=layout.find("td");
			var count=0;
			for(var i=0;i<tds.length;i++){
				 tdtemp=$(tds[i]);
				 if(tdtemp.css("display")!=='none'){
					tdtemp.html(lettersall[count]);
					count++;
				 }
			 }
            container.css("line-height","0px");
			container.html("");
			container.append(layout);
		}
		imgcontainer=$("<div class='opcontainer'></div>");
	    //添加编辑图标
	    imgcontainer.append(inputitem.nextAll(".layoutedit"));	
		//添加删除图表
        imgcontainer.append(inputitem.nextAll(".layoutdelte"));	
        //添加下载图标
        imgcontainer.append(inputitem.nextAll(".layoutdown")); 
       
	    container.next("div").css("text-align","center");
	    container.next("div").css("padding-top","10px");
	    container.next("div").css("font-weight","bold");

		container.append(imgcontainer);	
	
	}

	function onSearch(){
		LayoutForm.submit();
	}
	
	function onDownload(layoutid,layoutpath){
		layoutpath = "/page/layout/zip/"+layoutpath;
		//layoutpath = layoutpath.substring(0,layoutpath.lastIndexOf("/"))+".zip";
		window.open(layoutpath);
	}
	
	function oprateLayout(layoutid,e){
		var evt = e?e:(window.event?window.event:null);
		var op_div = document.createElement("DIV");
		op_div.id="op_div";
		op_div.style.position = "absolute";
		op_div.innerHTML = 
			"<input type='button' class='smallInput' onclick=\"onEdit('"+layoutid+"');\" value='<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())%>'/>"
			+"<input type='button' class='smallInput' onclick=\"onDel('"+layoutid+"');\" value='<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>'/>"
		if(document.getElementById("op_div")) document.body.removeChild(document.getElementById("op_div"));
		document.body.appendChild(op_div);
		op_div.style.left = evt.clientX;
		op_div.style.top = evt.clientY;
	}
	
	function onupload(){
		var layout_dialog = new window.top.Dialog();
		layout_dialog.currentWindow = window;   //传入当前window
	 	layout_dialog.Width = 560;
	 	layout_dialog.Height = 300;
	 	layout_dialog.Modal = true;
	 	layout_dialog.Title = "<%=SystemEnv.getHtmlLabelName(75,user.getLanguage())+SystemEnv.getHtmlLabelName(19407,user.getLanguage()) %>"; 
	 	layout_dialog.URL = "/page/maint/layout/LayoutEdit.jsp?method=add&date=" + new Date().getTime();
	 	layout_dialog.show();

	}
	
	
	function onAdd(){
		var layout_dialog = new window.top.Dialog();
		layout_dialog.currentWindow = window;   //传入当前window
	 	layout_dialog.Width = 800;
	 	layout_dialog.Height = 600;
	 	layout_dialog.Modal = true;
		layout_dialog.maxiumnable=true;
	 	layout_dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(19407,user.getLanguage()) %>"; 
	 	layout_dialog.URL = "/page/layoutdesign/pages/layoutdesign.jsp?layoutid=";
		layout_dialog.OKEvent=function(){
		    //存储模板
			layout_dialog.innerWin.submitData();
			 //   console.dir(layout_dialog);
				  
		}
		layout_dialog.show();
		layout_dialog.okButton.value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>";

	}
	
	function onEdit(layoutid,layoutpath){
		var layout_dialog = new window.top.Dialog();
		layout_dialog.currentWindow = window;   //传入当前window
	 	layout_dialog.Width = 800;
	 	layout_dialog.Height = 600;
	 	layout_dialog.Modal = true;
		layout_dialog.maxiumnable=true;
	 	layout_dialog.Title = "<%=SystemEnv.getHtmlLabelName(82136,user.getLanguage())%>"; 
	 	layout_dialog.URL = "/page/layoutdesign/pages/layoutdesign.jsp?layoutid="+layoutid+"&date=" + new Date().getTime();
	 	layout_dialog.OKEvent=function(){
		    //存储模板
			layout_dialog.innerWin.submitData();
			 //   console.dir(layout_dialog);
				  
		}
		layout_dialog.show();
		layout_dialog.okButton.value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>";

	}


	function onDel(layoutid,layoutpath){
		if(isdel()){
			jQuery.post("/page/maint/layout/Operate.jsp?method=del&layoutid="+layoutid,
				function(data){
					if(data.indexOf("OK")){location.reload();}
					else{Dialog.alert("<div style='color:red'><%=SystemEnv.getHtmlLabelName(28664,user.getLanguage())%></div>");}
			});			
		}
	}
</script>
