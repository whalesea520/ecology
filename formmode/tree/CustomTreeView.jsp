<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.interfaces.workflow.action.Action" %>
<%@ page import="weaver.general.StaticObj" %>
<jsp:useBean id="InterfaceTransmethod" class="weaver.formmode.interfaces.InterfaceTransmethod" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<style>
		#loading{
		    position:absolute;
		    left:45%;
		    background:#ffffff;
		    top:40%;
		    padding:8px;
		    z-index:20001;
		    height:auto;
		    border:1px solid #ccc;
		}
	</style>
</HEAD>
<body>
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(30208,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(1361,user.getLanguage());//树形设置:基本信息
	String needfav ="1";
	String needhelp ="";
	
	String sql = "";
	int id = Util.getIntValue(Util.null2String(request.getParameter("id")),0);
	String modeid=Util.null2String(request.getParameter("modeid"));
	String treename = Util.null2String(request.getParameter("treename"));
	String rootname = Util.null2String(request.getParameter("rootname"));
	String treedesc = Util.null2String(request.getParameter("treedesc"));
	String rooticon = Util.null2String(request.getParameter("rooticon"));
	String defaultaddress = Util.null2String(request.getParameter("defaultaddress"));
	String expandfirstnode = Util.null2String(request.getParameter("expandfirstnode"));
	sql = "select * from mode_customtree where id = " + id;
	rs.executeSql(sql);
	while(rs.next()){
		treename = Util.null2String(rs.getString("treename"));
		rootname = Util.null2String(rs.getString("rootname"));
		treedesc = Util.null2String(rs.getString("treedesc"));
		rooticon = Util.null2String(rs.getString("rooticon"));
		defaultaddress = Util.null2String(rs.getString("defaultaddress"));
		expandfirstnode = Util.null2String(rs.getString("expandfirstnode"));
	}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(30215,user.getLanguage())+",javaScript:AddTreeNode(),_self} " ;//新建树节点
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javaScript:doEdit(),_self} " ;//编辑
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:doBack(),_self} " ;//返回
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javaScript:doDel(),_self} " ;//删除
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(221,user.getLanguage())+",javaScript:doPreview(),_self} " ;//预览
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(28493,user.getLanguage())+",javascript:createmenu(),_self} " ;//创建菜单
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(28624,user.getLanguage())+",javascript:viewmenu(),_self} " ;//查看菜单地址
RCMenuHeight += RCMenuHeightStep;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
</colgroup>
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
<td></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
	<form name="frmSearch" method="post" action="/formmode/tree/CustomTreeOperation.jsp" enctype="multipart/form-data">
		<input type="hidden" id="operation" name="operation" value="del">
		<input type="hidden" id="id" name="id" value="<%=id%>">
		<table class="ViewForm">
			<COLGROUP>
				<COL width="15%">
				<COL width="85%">
			</COLGROUP>
			<TR>
				<TD colSpan=2><B><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></B></TD><!-- 基本信息 -->
			</TR>
			<tr style="height:1px"><td colspan=4 class=Line1></td></tr>

			<tr>
				<td>
					<!-- 树形名称 -->
					<%=SystemEnv.getHtmlLabelName(30209,user.getLanguage())%>
				</td>
				<td class=Field>
					<input class="inputstyle" id="treename" name="treename" type="hidden" value="<%=treename%>" size="30" maxlength="100" onblur="checkinput2('treename','treenamespan',1)">
					<span id="treenamespan">
						<%=treename%>
					</span>
				</td>
			</tr>
			<tr style="height:1px"><td colspan=4 class=Line></td></tr>
			
			<tr>
				<td>
					<!-- 描述 -->
					<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>
				</td>
				<td class=Field>
					<input class="inputstyle" id="treedesc" name="treedesc" type="hidden" value="<%=treedesc%>" size="30" maxlength="100">
					<span id="treenamespan">
					<%=treedesc%>
					</span>
				</td>
			</tr>
			<tr style="height:1px"><td colspan=4 class=Line></td></tr>
			
			<tr>
				<td>
					<!-- 根节点名称-->
					<%=SystemEnv.getHtmlLabelName(30210,user.getLanguage())%>
				</td>
				<td class=Field>
					<input class="inputstyle" id="rootname" name="rootname" type="hidden" value="<%=rootname%>" size="30" maxlength="100" onblur="checkinput2('rootname','rootnamespan',1)">
					<span id="rootnamespan">
						<%=rootname%>
					</span>
				</td>
			</tr>
			<tr style="height:1px"><td colspan=4 class=Line></td></tr>
			
			<tr>
				<td>
					<!-- 根节点图标-->
					<%=SystemEnv.getHtmlLabelName(30211,user.getLanguage())%>
				</td>
				<td class=Field>
					<input class="inputstyle" id="treeicon" name="treeicon" type="hidden" value="<%=rooticon%>" size="30" maxlength="100">
					<span id="oldimg">
						<%
							if(!rooticon.equals("")&&!rooticon.equals("0")) {
						%>
								<img src="/weaver/weaver.file.FileDownload?fileid=<%=rooticon%>">
						<%
							}
						%>
					</span>
				</td>
			</tr>
			<tr style="height:1px"><td colspan=4 class=Line></td></tr>
			
			<tr>
				<td>
					<!-- 根节点链接地址-->
					<%=SystemEnv.getHtmlLabelName(81440,user.getLanguage())%>
				</td>
				<td class=Field>
					<input class="inputstyle" id="defaultaddress" name="defaultaddress" type="hidden" value="<%=defaultaddress%>" size="30" maxlength="1000">
					<span id="defaultaddressspan"><%=defaultaddress%>
					</span>
				</td>
			</tr>
			<tr style="height:1px"><td colspan=4 class=Line></td></tr>
			
			<tr>
				<td>
					<!-- 是否默认展开一级节点-->
					<%=SystemEnv.getHtmlLabelName(81441,user.getLanguage())%>
				</td>
				<td class=Field>
					<input class="inputstyle" id="expandfirstnode" name="expandfirstnode" type="checkbox" value="1" <%if(expandfirstnode.equals("1")){out.println("checked");} %> disabled>
					<span id="expandfirstnodespan">
					</span>
				</td>
			</tr>
			<tr style="height:1px"><td colspan=4 class=Line></td></tr>
			
		</table>
	</form>
	
<%
String SqlWhere = " where mainid = " + id;

String perpage = "10";
String backFields = "id,mainid,nodename,nodedesc,sourcefrom,sourceid,tablename,tablekey,tablesup,showfield,hreftype,hrefid,hreftarget,hrefrelatefield,nodeicon,supnode,supnodefield,nodefield,showorder";
String sqlFrom = "from mode_customtreedetail";
//out.println("select " + backFields + "	"+sqlFrom + "	"+ SqlWhere);
String tableString=""+
	"<table  pagesize=\""+perpage+"\" tabletype=\"none\">"+
		"<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"id\" sqlsortway=\"asc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(SqlWhere)+"\"/>"+
			"<head>"+                     //名称        
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"nodename\" orderkey=\"nodename\" target=\"_self\" linkkey=\"id\" linkvaluecolumn=\"id\" href=\"/formmode/tree/CustomTreeNodeEdit.jsp\"/>"+
				//描述
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"nodedesc\"/>"+
				//数据来源
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(28006,user.getLanguage())+"\" column=\"sourcefrom\" orderkey=\"sourcefrom\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.formmode.tree.CustomTreeUtil.getSourceFrom\"/>"+
				//数据来源名称
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(30231,user.getLanguage())+"\" column=\"sourceid\" orderkey=\"sourcefrom\" otherpara=\"column:sourcefrom\" transmethod=\"weaver.formmode.interfaces.InterfaceTransmethod.getHrefName\"/>"+
				//表名
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(21900,user.getLanguage())+"\" column=\"tablename\" orderkey=\"tablename\"/>"+
				//链接目标来源
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(30174,user.getLanguage())+"\" column=\"hreftype\" orderkey=\"hreftype\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.formmode.interfaces.InterfaceTransmethod.getHrefType\"/>"+
				//链接目标
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(30181,user.getLanguage())+"\" column=\"hrefid\" orderkey=\"hrefid\" otherpara=\"column:hreftype\" transmethod=\"weaver.formmode.interfaces.InterfaceTransmethod.getHrefName\"/>"+
				//链接目标地址
				"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(30178,user.getLanguage())+"\" column=\"hreftarget\" orderkey=\"hreftarget\"/>"+
				//显示顺序
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"showorder\" orderkey=\"showorder\"/>"+
			"</head>"+
	"</table>";
%>

<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/>

</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
<script type="text/javascript">
    function doSubmit(){
		if(check_form(document.frmSearch,"treename,rootname")){
	        enableAllmenu();
	        document.frmSearch.submit();			
		}
    }
    function doEdit(){
    	enableAllmenu();
    	location.href="/formmode/tree/CustomTreeEdit.jsp?id=<%=id%>";
	}
    function doPreview(){
    	window.open("/formmode/tree/ViewCustomTree.jsp?id=<%=id%>");	
    }
    function createmenu(){
    	var url = "/formmode/tree/ViewCustomTree.jsp?id=<%=id%>";
    	window.open("/formmode/menu/CreateMenu.jsp?menuaddress="+escape(url));
    }
    function viewmenu(){
    	var url = "/formmode/tree/ViewCustomTree.jsp?id=<%=id%>";
    	prompt("<%=SystemEnv.getHtmlLabelName(28624,user.getLanguage())%>",url);//查看菜单地址
    }
	function AddTreeNode(){
		location.href = "/formmode/tree/CustomTreeNodeAdd.jsp?mainid=<%=id%>";
		//window.open("/formmode/tree/CustomTreeNodeAdd.jsp?mainid=<%=id%>");
	}
    function doBack(){
		enableAllmenu();
        location.href="/formmode/tree/CustomTreeList.jsp";
    }
    function doDel(){
    	if(isdel()){
        	enableAllmenu();
        	document.frmSearch.operation.value = "del";
        	document.frmSearch.submit();
    	}
	}

    function onShowCondition(spanName){
		if("<%=id%>"<=0){
			//请先保存页面数据，再进行该设置
			alert("<%=SystemEnv.getHtmlLabelName(30183,user.getLanguage())%>");
			return;
		}		
	}

	function detailSet(){
		if("<%=id%>"<=0){
			//请先保存页面数据，再进行该设置
			alert("<%=SystemEnv.getHtmlLabelName(30183,user.getLanguage())%>");
			return;
		}
		
		var hreftype = jQuery("select[name=hreftype]").val();
		var hrefid = jQuery("input[name=hrefid]").val();
		var modeid = jQuery("input[name=modeid]").val();
		url = "/formmode/interfaces/ModePageExpandRelatedFieldSet.jsp?modeid="+modeid+"&hreftype="+hreftype+"&hrefid="+hrefid;
    	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+escape(url));
    	if (datas){
    	    if(datas.id!=""){
    		    $(inputName).val(datas.id);
    			if ($(inputName).val()==datas.id){
    		    	$(spanName).html(datas.name);
    			}
    	    }else{
    		    $(inputName).val("");
    			$(spanName).html("");
    		}
    	}
	}
    
    function onShowModeSelect(inputName, spanName){
    	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp");
    	if (datas){
    	    if(datas.id!=""){
    		    $(inputName).val(datas.id);
    			if ($(inputName).val()==datas.id){
    		    	$(spanName).html(datas.name);
    			}
    	    }else{
    		    $(inputName).val("");
    			$(spanName).html("");
    		}
    	} 
    }
    
    function onShowHrefTarget(inputName, spanName){
        var url = "/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp";
		var hreftype = jQuery("select[name=hreftype]").val();
		var hrefid = jQuery("input[name=hrefid]").val();
		if(hreftype=="1"){//模块
			url = "/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp";
		}else if(hreftype=="3"){//模块查询列表
			url = "/systeminfo/BrowserMain.jsp?url=/formmode/search/CustomSearchBrowser.jsp";
		} 
    	var datas = window.showModalDialog(url);
    	if (datas){
    	    if(datas.id!=""){
    		    $(inputName).val(datas.id);
   		    	$(spanName).html(datas.name);
    	    }else{
    		    $(inputName).val("");
    			$(spanName).html("");
    		}
    	    getHrefTarget();
    	} 
    }
    
	function getHrefTarget(){
		var hreftype = jQuery("select[name=hreftype]").val();
		var hrefid = jQuery("input[name=hrefid]").val();
		if(hreftype!=""&&hrefid!=""){
			var url = "/formmode/interfaces/ModePageExpandAjax.jsp?hrefid="+hrefid+"&hreftype="+hreftype;
			jQuery.ajax({
				url : url,
				type : "post",
				processData : false,
				data : "",
				dataType : "text",
				async : true,
				success: function do4Success(msg){
					var returnurl = jQuery.trim(msg);
					jQuery("#hreftarget").val(returnurl);
					if(returnurl==""){
						jQuery("#hreftargetspan").html("<img align=\"absMiddle\" src=\"/images/BacoError_wev8.gif\"/>");
					}else{
						jQuery("#hreftargetspan").html("");
					}
				}
			});
		}else{
			jQuery("#hreftarget").val("");
			jQuery("#hreftargetspan").html("<img align=\"absMiddle\" src=\"/images/BacoError_wev8.gif\"/>");
		}
	}
	
	function onShowTypeChange(){
		var showtype = jQuery("#showtype").val();
		var hreftype = jQuery("#hreftype").val();
		if(showtype=="1"){
			jQuery("#opentype").hide();
			jQuery("#opentypetr").hide();
			jQuery("#opentypelinetr").hide();
			jQuery("#relatedfieldtr").show();
			jQuery("#relatedfieldtrline").show();
		}else if(showtype=="2"){
			jQuery("#opentype").show();
			jQuery("#opentypetr").show();
			jQuery("#opentypelinetr").show();
			if(hreftype=="2"){
				jQuery("#relatedfieldtr").hide();
				jQuery("#relatedfieldtrline").hide();
			}
		}
	}
	
	function onHrefTypeChange(){
		var hreftype = jQuery("#hreftype").val();
		if(hreftype=="1"){
			jQuery("#hrefidtr").show();
			jQuery("#hrefidlinetr").show();
			jQuery("#relatedfieldtr").show();
			jQuery("#relatedfieldtrline").show();
		}else if(hreftype=="2"){
			jQuery("#hrefidtr").hide();
			jQuery("#hrefidlinetr").hide();
			jQuery("#hrefid").val("");
			jQuery("#hrefidspan").html("");
			jQuery("#relatedfieldtr").hide();
			jQuery("#relatedfieldtrline").hide();
		}else if(hreftype=="3"){
			jQuery("#relatedfieldtr").show();
			jQuery("#relatedfieldtrline").show();
		}
	}
	
	$(document).ready(function(){//onload事件
		onShowTypeChange();
		onHrefTypeChange();
		$(".loading", window.parent.document).hide(); //隐藏加载图片
	})
</script>

</BODY>
</HTML>
