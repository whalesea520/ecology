
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="esc" class="weaver.page.style.ElementStyleCominfo" scope="page"/>
<jsp:useBean id="mhsc" class="weaver.page.style.MenuHStyleCominfo" scope="page" />
<jsp:useBean id="mvsc" class="weaver.page.style.MenuVStyleCominfo" scope="page" />
<jsp:useBean id="su" class="weaver.page.style.StyleUtil" scope="page" />
<jsp:useBean id="sppb" class="weaver.general.SplitPageParaBean" scope="page"/>
<jsp:useBean id="spu" class="weaver.general.SplitPageUtil" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<html>
  <head>
    <LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
	<STYLE TYPE="text/css">
.item a{
	text-decoration: none!important;
}
.header{
	background-position:left center;
}
.toolbar{
	display:block;
}
.styleContainer{
	margin:9px 9px 9px 9px;
	position:relative;
}
.hoverDiv{
	width: 100%;
	height: 0px; 
	line-height: 43px; 
	border-top:1px solid #c8c8c8;
	bottom:0px;
	background:#f1f1f1;
	opacity:0.9;
	position: absolute;
}

.styleToolBar{
	margin: auto;
	height: 43px;
	list-style-type:none;
	width: 220px;
	
}
.styleToolBar li{
	float: left;
	width: 33px;
	padding-left:10px;
	padding-right:10px;
}
.edit{
	background: url('/images/ecology8/homepage/element/style/edit_wev8.png') center center no-repeat;
	cursor: pointer;
}

.saveAs{
	background: url('/images/ecology8/homepage/element/style/saveAs_wev8.png') center center no-repeat;
	cursor: pointer;
}
.download{
	background: url('/images/ecology8/homepage/element/style/download_wev8.png') center center no-repeat;
	cursor: pointer;
}

.del{
	background: url('/images/ecology8/homepage/element/style/del_wev8.png') center center no-repeat;
	cursor: pointer;
}


.weaverTableCurrentPageBg {
	/*
	background:url(table/pageNumBg_wev8.png) repeat-x;
	
	background-color:#D9D9D9;
	*/
	background-color:#5b5b5b;
	color:#fff !important;
}




.weaverTablePrevPage {
	/*background:url(table/prev_wev8.png) 0 0 no-repeat;*/

}

.weaverTablePrevSltPage {
	background:url(/wui/theme/ecology8/skins/default/table/prev_slt_wev8.png) 0 0 no-repeat;
	
}


.weaverTablePrevPageOfDisabled {
	background:url(/wui/theme/ecology8/skins/default/table/prev_none_wev8.png) 0 0 no-repeat;
	
}

.weaverTableNextPage {
	background:url(/wui/theme/ecology8/skins/default/table/next_wev8.png) 0 0 no-repeat;
	
}

.weaverTableNextSltPage {
	background:url(/wui/theme/ecology8/skins/default/table/next_slt_wev8.png) 0 0 no-repeat;
	
}

.weaverTableNextPageOfDisabled {
	background:url(/wui/theme/ecology8/skins/default/table/next_none_wev8.png) 0 0 no-repeat;
	
}



</STYLE>
  </head>  
  <%
	if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String titlename="";
	String sqlWhere=" menustyletype='element'"; 
  	String stylename = Util.null2String(request.getParameter("styleName"));
  	sqlWhere += "".equals(stylename)?"":" and menustylename like '%"+stylename+"%'";
%>


<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:onAdd(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<form id="searchStyleForm" name="searchStyleForm" method="post" action="ElementStyleList.jsp">
	<input type="hidden" id="operate" name="operate" value=""/>
	<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td width="75px">					
			</td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%>" class="e8_btn_top" onclick="onAdd();" />
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%>" class="e8_btn_top" onclick="onImp();" />
				<input type="text" class="searchInput" name="styleName"/>
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
						//设置好搜索条件
						/*String tableString="<table  pagesize=\""+perpage+"\" tabletype=\"checkbox\" valign=\"top\" >"
						  + "<checkboxpopedom popedompara=\"column:styleid\" showmethod=\"weaver.splitepage.transform.SptmForMenuStyle.getStyleDel\"/>"
						  + "<sql backfields=\" styleid,menustylename,menustyledesc,menustyletype,menustylecreater,menustylelastdate \" sqlform=\" from hpMenuStyle \" sqlorderby=\"styleid\"  sqlprimarykey=\"styleid\" sqlsortway=\"asc\" sqlwhere=\""+sqlWhere+"\" sqlisdistinct=\"false\" />"+
							"<head >"+
								"<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(19621,user.getLanguage())+"\"   column=\"menustylename\" otherpara=\"column:styleid+column:menustyletype\" transmethod=\"weaver.splitepage.transform.SptmForMenuStyle.getMenuStyleName\"/>"+
								"<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(23036,user.getLanguage())+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\"   column=\"menustyledesc\"/>"+
								"<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(19054,user.getLanguage())+"\"   column=\"menustyletype\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.splitepage.transform.SptmForMenuStyle.getMenuType\"/>"+
								"<col width=\"15%\"   text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\"   column=\"menustylecreater\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getLastname\"/>"+
								"<col width=\"25%\"   text=\""+SystemEnv.getHtmlLabelName(19520,user.getLanguage())+"\"   column=\"menustylelastdate\"/>"+
							"</head>"
							 + "<operates><popedom otherpara=\"column:styleid\" transmethod=\"weaver.splitepage.transform.SptmForMenuStyle.getOperate\"></popedom> "
							 + "<operate href=\"javascript:onPriview();\" text=\""+SystemEnv.getHtmlLabelName(221,user.getLanguage())+"\" target=\"_self\"  index=\"0\"/>"
							 + "<operate href=\"javascript:onEdit();\" text=\""+SystemEnv.getHtmlLabelName(26473,user.getLanguage())+"\" target=\"_blank\"  index=\"1\"/>"
							 + "<operate href=\"javascript:saveNew();\" text=\""+SystemEnv.getHtmlLabelName(350,user.getLanguage())+"\" target=\"_self\"  index=\"2\"/>"
							 + "<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_self\"  index=\"3\"/>"
							 + "</operates></table>"*/;						
						%>
<%
	int perpage =9;
	int pageIndex = Util.getIntValue(request.getParameter("pageIndex"));
	
	sppb.setBackFields(" styleid,menustylename,menustyledesc,menustyletype,menustylecreater,menustylelastdate ");
	sppb.setPrimaryKey("styleid");
	sppb.setDistinct(true);
	//sppb.setIsPrintExecuteSql(true);
	sppb.setSqlFrom(" from hpMenuStyle");
	sppb.setSqlWhere(sqlWhere); 
	sppb.setSqlOrderBy("styleid");
	sppb.setSortWay(sppb.ASC);
	
	spu.setSpp(sppb);				
	
	int sum = spu.getRecordCount();
	int max = (sum/perpage)+((sum%perpage)>0?1:0);
	pageIndex = (pageIndex<0)?1:pageIndex;
	pageIndex = (max<pageIndex)?max:pageIndex;
	int count=1;
	int br = 1;
	
	rs=spu.getCurrentPageRs(pageIndex,perpage);
	StringBuffer estyleStr = new StringBuffer();
	estyleStr.append("<table width=\"100%\" style='table-layout:fixed'><tbody><tr>");
	while(rs.next()){
		String styleid = rs.getString("styleid");
		estyleStr.append("<td width='33%'>");
		estyleStr.append("<div class='styleContainer' _titleState='").append(esc.getTitleState(styleid)).append("' _toolbarstate='").append(esc.getSettingState(styleid)).append("'>");
		estyleStr.append(su.getContainerForStyle(styleid));
		if("footer".equals(esc.getMoreLocal(styleid))){
			estyleStr.append("<div class=\"footerDiv\" style=\"height:10px;float:right;clear:both;\" id=\"footerDiv_"+styleid+"\" ><a href=\"#\"><img class=\"iconMore\" border=\"0\" src=\"").append(esc.getIconMore(styleid))
			.append("\"></a></div>");
		}
		estyleStr.append("<div class=\"hoverDiv\" id=\"hoverDiv_"+styleid+"\" >");
		
		estyleStr.append("<ul class=\"styleToolBar\" styleid='"+styleid+"' >");
		estyleStr.append("<li class='edit' title='"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"'>");
		estyleStr.append("&nbsp;");
		estyleStr.append("</li>");
		estyleStr.append("<li class='saveAs' title='"+SystemEnv.getHtmlLabelName(350,user.getLanguage())+"'>");
		estyleStr.append("&nbsp;");
		estyleStr.append("</li>");
		estyleStr.append("<li class='download' title='"+SystemEnv.getHtmlLabelName(31156,user.getLanguage())+"'>");
		estyleStr.append("&nbsp;");
		estyleStr.append("</li>");
		if(!"template".equals(styleid)){
			estyleStr.append("<li class='del' title='"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"'>");
			estyleStr.append("&nbsp;");
			estyleStr.append("</li>");
		}
		estyleStr.append("</ul>");
		estyleStr.append("</div>");
		estyleStr.append("</td>");
		if(count/3==br){
			estyleStr.append("<td width='1%'>&nbsp;</td></tr><tr class=\"sparator\" style=\"height:1px\" height=\"1px\"><td style=\"padding:0px\" colspan=\"4\"></td></tr><tr>");
			br++;
		}
		count++;
	}
	if(count/3!=br)estyleStr.append("</tr>");
	estyleStr.append("</tbody><table>");
	out.print(estyleStr.toString());
%>
<form name="splitPageForm" action="ElementStyleList.jsp">
<input type="hidden" name="pageIndex" id="pageIndex" value="<%=pageIndex %>"/>
<table width="100%"><tbody><tr><td style="padding-left: 10px;">
&nbsp;</td><td>
<div align="right">
<span style="TEXT-DECORATION:none;height:21px;padding-top:2px;">
&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(18609,user.getLanguage()) %><%=sum%><%=SystemEnv.getHtmlLabelName(24683,user.getLanguage()) %>&nbsp;&nbsp;&nbsp;
<%=SystemEnv.getHtmlLabelName(265,user.getLanguage()) %><%=perpage%><%=SystemEnv.getHtmlLabelName(18256,user.getLanguage()) %>
</span>
<span class="weaverTablePrevPageOfDisabled" onclick="goPage(<%=pageIndex==1?1:pageIndex-1 %>);" style="display:inline-block;cursor:pointer;TEXT-DECORATION:none;height:21px;margin-right:5px;width:21px;">&nbsp;</span>
<%for(int i=1;i<=max;i++){ %>
<span style="display:inline-block;cursor:pointer;TEXT-DECORATION:none;height:19px;border:1px solid #BCBCBC;margin-right:5px;padding:0 5px 0 5px;" onclick="goPage(<%=i %>);" <%=i==pageIndex?"class=\"weaverTableCurrentPageBg\"":""%>><%=i %></span>
<%} %>
<span class="weaverTableNextPageOfDisabled" onclick="goPage(<%=pageIndex==max?pageIndex:pageIndex+1 %>);" style="display:inline-block;cursor:pointer;TEXT-DECORATION:none;height:21px;margin-right:5px;width:21px;">&nbsp;</span>
<span style="TEXT-DECORATION:none;height:21px;line-height:21px;">
<%=SystemEnv.getHtmlLabelName(15323,user.getLanguage()) %>&nbsp;</span>
<input id="-weaverTable-0_XTABLE_GOPAGE_buttom" type="text" value="<%=pageIndex %>" size="3" class="text" onmouseover="this.select()" style="text-align:right;line-height:20px;height:20px;widht:30px;border:1px solid #BCBCBC;background:none;margin-right:5px;padding-right:2px;">
<span style="TEXT-DECORATION:none;height:21px;line-height:21px;">
<%=SystemEnv.getHtmlLabelName(23161,user.getLanguage()) %></span>
<span id="-weaverTable-0-goPage" onclick="goPage(0);" style="display:inline-block;line-height:21px;cursor:pointer;height:21px;width:30px;margin-right:5px;text-align:center;border:1px solid #BCBCBC;background-color:#D9D9D9;">
<%=SystemEnv.getHtmlLabelName(30911,user.getLanguage()) %></span>
</div></td></tr></tbody></table>
</form>
</body>
</html>

<!--For zDialog-->
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css"type="text/css"/>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
	var curIndex = <%=pageIndex%>;
	var maxIndex = <%=max%>;
	function goPage(pageIndex){
		if(pageIndex==0)pageIndex=jQuery("#-weaverTable-0_XTABLE_GOPAGE_buttom").val();
		jQuery("#pageIndex").val(pageIndex);
		if(pageIndex<1||curIndex==pageIndex||pageIndex>maxIndex) return;
		splitPageForm.submit();
	}

	function onAdd(){
	 	var title = "<%=SystemEnv.getHtmlLabelName(365,user.getLanguage()) %>"; 
	 	var url = "/page/maint/style/MenuStyleEdit.jsp?type=element";
	 	showDialog(title,url,500,260,false);
	}
	
	function onImp(){
	 	var title = "<%=SystemEnv.getHtmlLabelName(18596,user.getLanguage()) %>"; 
	 	var url = "/page/maint/style/StyleImp.jsp?type=element";
	 	showDialog(title,url,500,200,false);
	}
	
	function onDownload(styleid){
	 	var stylepath = "/page/maint/style/StyleDownload.jsp?type=element&styleid="+styleid;
	 	window.open(stylepath);
	}
	
	function onEdit(styleid){
		var url="/page/maint/style/ElementStyleEdit.jsp?type=element&styleid="+styleid;
		var title = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage()) %>";
		showDialog(title,url,800,500,true);
	}
	
	function showDialog(title,url,width,height,showMax){
		var Show_dialog = new window.top.Dialog();
		Show_dialog.currentWindow = window;   //传入当前window
	 	Show_dialog.Width = width;
	 	Show_dialog.Height = height;
	 	Show_dialog.maxiumnable=showMax;
	 	Show_dialog.Modal = true;
	 	Show_dialog.Title = title;
	 	Show_dialog.URL = url;
	 	Show_dialog.show();
	}
	
	function onDel(styleid){
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
			jQuery.post("MenuStyleOprate.jsp?operate=delStyle&type=element&styleid="+styleid,
			function(data){if(data.indexOf("OK")!=-1) location.reload();});
		});
	}
	
	function onPriview(styleid){
		var url = "MenuStylePriviewE.jsp?styleid="+styleid+"&type=element";
		var title = "<%=SystemEnv.getHtmlLabelName(221,user.getLanguage()) %>";
		showDialog(title,url,500,300,true);
	}
	
	function saveNew(styleid){
		var url="/page/maint/style/MenuStyleEdit.jsp?operate=saveNew&styleid="+styleid+"&type=element";
		var title = "<%=SystemEnv.getHtmlLabelName(350,user.getLanguage()) %>";
		showDialog(title,url,500,200,false);
	}
	
	$(document).ready(function(){	
		jQuery("#topTitle").topMenuTitle({searchFn:onSearch});
		jQuery(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
		jQuery("#tabDiv").remove();
		
		jQuery(".content").css("padding",0);
	
		
		jQuery(".styleContainer").hover(function(){
			var showBtn = jQuery("#hoverDiv_"+jQuery(this).find(".item").attr("eid"));
			jQuery(showBtn).animate({height:"43px"})
		},function(){
			var showBtn = jQuery("#hoverDiv_"+jQuery(this).find(".item").attr("eid"));
			jQuery(showBtn).animate({height:"0px"})
		})
		
		jQuery(".styleToolBar").find("li").bind("click",function(){
			if($(this).hasClass("edit")){
				onEdit($(this).parent().attr("styleid"));
			}
			if($(this).hasClass("download")){
				onDownload($(this).parent().attr("styleid"));
			}
			if($(this).hasClass("saveAs")){
				saveNew($(this).parent().attr("styleid"));
			}
			if($(this).hasClass("del")){
				onDel($(this).parent().attr("styleid"));
			}
		});
		
		jQuery(".styleToolBar").find("li").hover(function(){
			var type = $(this).attr("class");
			$(this).css("background-image","url(/images/ecology8/homepage/element/style/"+type+"Over_wev8.png)")
		},function(){
			var type = $(this).attr("class");
			$(this).css("background-image","url(/images/ecology8/homepage/element/style/"+type+"_wev8.png)")
		
		});
		$('.styleContainer[_titlestate=hidden]').find('.toolbar').hide();
		$('.styleContainer[_toolbarstate=hidden]').find('.toolbar').hide();
		$('.toolbar').find('img[display=none]').parent().parent().hide();
	});
	
	function onSearch(){
		searchStyleForm.submit();		
	}
//-->
</SCRIPT>