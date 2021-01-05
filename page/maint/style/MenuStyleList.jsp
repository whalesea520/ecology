
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="esc" class="weaver.page.style.ElementStyleCominfo" scope="page"/>
<jsp:useBean id="mhsc" class="weaver.page.style.MenuHStyleCominfo" scope="page" />
<jsp:useBean id="mvsc" class="weaver.page.style.MenuVStyleCominfo" scope="page" />

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<html>
  <head>
    <LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
  </head>  
  <%
	if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
   // 添加样式数据
  	rs.executeSql("select count(styleid) from hpMenuStyle");
  	rs.next();
  	if(rs.getInt(1)==0){
	  	String date = new SimpleDateFormat("yyyy-MM-dd").format(new Date()).toString();
	  	String time = new SimpleDateFormat("HH:mm:ss").format(new Date()).toString();
  		esc.setTofirstRow();						
		while(esc.next()){//元素样式
			rs.executeSql("INSERT INTO hpMenuStyle (styleid,menustylename,menustyledesc,menustyletype,menustylecreater,menustylemodifyid,menustylelastdate,menustylelasttime,menustylecite)"
						+"VALUES('"+esc.getId()+"','"+esc.getTitle()+"','"+esc.getDesc()+"','element','1','1','"+date+"','"+time+"','template')");
		}
		mhsc.setTofirstRow();						
		while(mhsc.next()){//横向菜单
			rs.executeSql("INSERT INTO hpMenuStyle (styleid,menustylename,menustyledesc,menustyletype,menustylecreater,menustylemodifyid,menustylelastdate,menustylelasttime,menustylecite)"
					+"VALUES('"+mhsc.getId()+"','"+mhsc.getTitle()+"','"+mhsc.getDesc()+"','menuh','1','1','"+date+"','"+time+"','template')");
		}
		mvsc.setTofirstRow();						
		while(mvsc.next()){//纵向菜单
			rs.executeSql("INSERT INTO hpMenuStyle (styleid,menustylename,menustyledesc,menustyletype,menustylecreater,menustylemodifyid,menustylelastdate,menustylelasttime,menustylecite)"
					+"VALUES('"+mvsc.getId()+"','"+mvsc.getTitle()+"','"+mvsc.getDesc()+"','menuv','1','1','"+date+"','"+time+"','template')");
		}
  	}
  	String styleType = Util.null2String(request.getParameter("styleType"));
	styleType = "".equals(styleType)?"menuh":styleType;
	String titlename="";
	String sqlWhere=" menustyletype='"+styleType+"'"; 
  	String stylename = Util.null2String(request.getParameter("stylename"));
  	sqlWhere += "".equals(stylename)?"":" and menustylename like '%"+stylename+"%'";
%>


<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(1014,user.getLanguage())+",javascript:onAdd(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(18596,user.getLanguage())+",javascript:onImp(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:onDelAll(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<form id="searchStyleForm" name="searchStyleForm" method="post" action="MenuStyleList.jsp">
	<input type="hidden" id="operate" name="operate" value=""/>
	<input type="hidden" id="styleType" name="styleType" value="<%=styleType%>"/>
	<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td width="75px">					
			</td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(1014,user.getLanguage())%>" class="e8_btn_top" onclick="onAdd();" />
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%>" class="e8_btn_top" onclick="onImp();" />
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>" class="e8_btn_top" onclick="onDelAll();"/>				
				<input type="text" class="searchInput" name="stylename"  value="<%=stylename%>"/>
				<span title='<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>' class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<div class="advancedSearchDiv" id="advancedSearchDiv">
	</div>
	</form>
	<%
		//得到pageNum 与 perpage
		int perpage =10;
		//设置好搜索条件
		String tableString="<table  pagesize=\""+perpage+"\" tabletype=\"checkbox\" valign=\"top\" >"
		  + "<checkboxpopedom popedompara=\"column:styleid\" showmethod=\"weaver.splitepage.transform.SptmForMenuStyle.getStyleDel\"/>"
		  + "<sql backfields=\" styleid,menustylename,menustyledesc,menustyletype,menustylecreater,menustylelastdate \" sqlform=\" from hpMenuStyle \" sqlorderby=\"menustylelastdate,menustylelasttime\"  sqlprimarykey=\"styleid\" sqlsortway=\"desc\" sqlwhere=\""+sqlWhere+"\" sqlisdistinct=\"false\" />"+
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
			 + "</operates></table>";						
		%>
	<TABLE width="100%">
		<TR>
			<TD valign="top">
				<wea:SplitPageTag  tableString="<%=tableString%>"  mode="run"   />
			</TD>
		</TR>
	</TABLE>
</body>
</html>
<!--For zDialog-->
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css"type="text/css"/>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
	function onSearch(){
		searchStyleForm.submit();		
	}
	
	function onAdd(){
	 	var title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(1014,user.getLanguage())%>"; 
	 	var url ="/page/maint/style/MenuStyleEdit.jsp?type=<%=styleType%>";
	 	showDialogWin(title,url,500,260,false);
	}
	
	function onImp(){
	 	var title = "<%=SystemEnv.getHtmlLabelName(18596,user.getLanguage()) %>"; 
	 	var url = "/page/maint/style/StyleImp.jsp?type=<%=styleType%>";
	 	showDialogWin(title,url,500,200,false);
	}
	
	function onEdit(styleid){
		var type = jQuery(jQuery.getSelectedRow()).find("td:eq(1) input").attr("menutype");
		var url="";
		if(jQuery("#"+styleid+type).val()!=undefined){
			url = "/page/maint/style/"+jQuery("#"+styleid+type).val();
		}
		if(url=="")return;
	 	var title = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>"; 
	 	showDialogWin(title,url,750,800,true);
	}
	
	
	function saveNew(styleid){
		var type = jQuery(jQuery.getSelectedRow()).find("td:eq(1) input").attr("menutype");
		
	 	var title = "<%=SystemEnv.getHtmlLabelName(350,user.getLanguage())%>"; 
	 	var url = "/page/maint/style/MenuStyleEdit.jsp?operate=saveNew&styleid="+styleid+"&type="+type;
	 	showDialogWin(title,url,500,200,false);
	}
	
	function showDialogWin(title,url,width,height,showMax){
		alert(1)
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
			var type = '<%=styleType%>'
			
			jQuery.post("/page/maint/style/MenuStyleOprate.jsp?operate=delStyle&styleid="+styleid+"&type="+type,
			function(data){if(data.indexOf("OK")!=-1) location.reload();});
		});
	}
	
	function onDelAll(){
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){		
			var styleids = "";
			var types = "";
			jQuery("input[name='chkInTableTag']").each(function(){
				if(jQuery(this).attr("checked")){	
					if(jQuery("#"+$(this).attr("checkboxid")+"menuh").val()!=undefined){
						types = types + "menuh,";
					}else if(jQuery("#"+$(this).attr("checkboxid")+"menuv").val()!=undefined)	{
						types = types + "menuv,";
					}
					styleids = styleids +jQuery(this).attr("checkboxid")+",";
				}
			});
			
			jQuery.post("/page/maint/style/MenuStyleOprate.jsp?operate=delAllStyle&styleid="+styleids+"&type="+types,
			function(data){if(data.indexOf("OK")!=-1) location.reload();});
		});
	}
	
	function onPriview(styleid){
		var type = jQuery(jQuery.getSelectedRow()).find("td:eq(1) input").attr("menutype");
		var url="";
		var height=300;
		if(type=="menuh"){
			url = "/page/maint/style/MenuStylePriviewH.jsp?styleid="+styleid+"&type=menuh";
		}else if(type=="menuv")	{
			url = "/page/maint/style/MenuStylePriviewV.jsp?styleid="+styleid+"&type=menuv";
			height=460;
		}
		if(url=="")return;
	 	var title = "<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>"; 
	 	showDialogWin(title,url,500,height,false);
	}
	
	function showDialogWin(title,url,width,height,showMax){
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
		
	$(document).ready(function(){	
		jQuery("#topTitle").topMenuTitle({searchFn:onSearch});
		jQuery(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
		jQuery("#tabDiv").remove();
		
	});
//-->
</SCRIPT>