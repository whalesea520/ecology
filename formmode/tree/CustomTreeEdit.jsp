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
	String titlename = SystemEnv.getHtmlLabelName(30208,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(93,user.getLanguage());//树形设置编辑
	String needfav ="1";
	String needhelp ="";
	
	String sql = "";
	int id = Util.getIntValue(Util.null2String(request.getParameter("id")),0);
	String modeid=Util.null2String(request.getParameter("modeid"));
	String modename = "";
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javaScript:doSubmit(),_self} " ;//保存
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:doBack(),_self} " ;//返回
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
		<input type="hidden" id="operation" name="operation" value="edit">
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
					<input class="inputstyle" id="treename" name="treename" type="text" value="<%=treename%>" size="30" maxlength="100" onblur="checkinput2('treename','treenamespan',1)">
					<span id="treenamespan">
						<%
							if(treename.equals("")) {
						%>
								<img align="absMiddle" src="/images/BacoError_wev8.gif"/>
						<%
							}
						%>
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
					<input class="inputstyle" id="treedesc" name="treedesc" type="text" value="<%=treedesc%>" size="30" maxlength="2000">
					<span id="treedescspan">
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
					<input class="inputstyle" id="rootname" name="rootname" type="text" value="<%=rootname%>" size="30" maxlength="50" onblur="checkinput2('rootname','rootnamespan',1)">
					<span id="rootnamespan">
						<%
							if(treename.equals("")) {
						%>
								<img align="absMiddle" src="/images/BacoError_wev8.gif"/>
						<%
							}
						%>
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
					<input class="inputstyle" id="oldrooticon" name="oldrooticon" type="hidden" value="<%=rooticon%>">
					<input class="inputstyle" id="rooticon" name="rooticon" type="file" value="<%=rooticon%>" size="30" onchange="selectImg(this)">
					(16 * 16)
					<span id="oldimg">
						<%
							if(!rooticon.equals("")&&!rooticon.equals("0")) {
						%>
								<img src="/weaver/weaver.file.FileDownload?fileid=<%=rooticon%>">
						<%
							}
						%>
					</span>
					&nbsp;
					<span id="delspan">
						<a href="javascript:void(0)" onclick="javascript:delRootIcon()"><%=SystemEnv.getHtmlLabelName(30228,user.getLanguage())%></a>
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
					<input class="inputstyle" id="defaultaddress" name="defaultaddress" type="text" value="<%=defaultaddress%>" size="60" maxlength="1000">
					<span id="defaultaddressspan">
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
					<input class="inputstyle" id="expandfirstnode" name="expandfirstnode" type="checkbox" value="1" <%if(expandfirstnode.equals("1")){out.println("checked");} %>>
					<span id="expandfirstnodespan">
					</span>
				</td>
			</tr>
			<tr style="height:1px"><td colspan=4 class=Line></td></tr>
			
		</table>
	</form>

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
    function doBack(){
		enableAllmenu();
        location.href="/formmode/tree/CustomTreeView.jsp?id=<%=id%>";
    }
    function doDelete(){
    	if(isdel()){
        	enableAllmenu();
        	document.frmSearch.operation.value = "del";
        	document.frmSearch.submit();
    	}
    }
    function delRootIcon(){
    	$("#oldimg").html("");
    	$("#oldrooticon").val("");
    	var objFile = document.getElementById('rooticon');
    	objFile.outerHTML=objFile.outerHTML.replace(/(value=\").+\"/i,"$1\""); 
	}

    function selectImg(obj){
		if(obj.value==""){
			$("#oldimg").html("");
		}else{
			$("#oldimg").html("<img border=0 src="+obj.value+">");
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
	
	$(document).ready(function(){//onload事件
		$(".loading", window.parent.document).hide(); //隐藏加载图片
	})
</script>

</BODY>
</HTML>
