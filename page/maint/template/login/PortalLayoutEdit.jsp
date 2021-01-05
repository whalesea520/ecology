
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
String styleid =Util.null2String(request.getParameter("styleid"));	
String type = Util.null2String(request.getParameter("type"));
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23140,user.getLanguage());
String needfav ="1";
String needhelp ="";
String message = Util.null2String(request.getParameter("message"));
StyleMaint sm=new StyleMaint(user);
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
   
	RCMenu += "{"+SystemEnv.getHtmlLabelName(16388,user.getLanguage())+",javascript:onAdd(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>



<html>
 <head>
 <link href="/css/Weaver_wev8.css" type="text/css" rel=stylesheet>
 <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link href="/js/jquery/ui/jquery-ui_wev8.css" type="text/css" rel=stylesheet>

<!--For Dialog-->
<SCRIPT language="javascript" src="/js/jquery/jquery_wev8.js"></script>
<script type="text/javascript" src="/js/jquery/ui/ui.core_wev8.js"></script>
<script type="text/javascript" src="/js/jquery/ui/ui.draggable_wev8.js"></script>
<script type="text/javascript" src="/js/jquery/ui/ui.resizable_wev8.js"></script>
<script type="text/javascript" src="/js/jquery/ui/ui.dialog_wev8.js"></script>
</head>
<body  id="myBody">

	<%
	//得到pageNum 与 perpage
	int perpage =10;
	//设置好搜索条件
	String tableString="<table  pagesize=\""+perpage+"\" tabletype=\"checkbox\" valign=\"top\">"
	  + "<sql backfields=\" id,templatename,templatedesc,templatetype,templateusetype,dir,zipName \" sqlform=\" from pagetemplate \" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\" sqlwhere=\"\" sqlisdistinct=\"false\" />"+
		"<head >"+
			"<col width=\"5%\"   text=\"ID\"   column=\"id\"/>"+
			"<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(22009,user.getLanguage())+"\"   column=\"templatename\"/>"+
			"<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\"   column=\"templatedesc\"/>"+
			"<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(22256,user.getLanguage())+"\"   column=\"templatetype\" otherpara=\""+user.getLanguage()+"+column:id+column:dir+column:zipName\" transmethod=\"weaver.splitepage.transform.SptmForPortalLayout.getTempalteUseType\"/>"+
		"</head>"
		 + "<operates><popedom otherpara=\"column:id\" transmethod=\"weaver.splitepage.transform.SptmForPortalLayout.getOperate\"></popedom> "
		 + "<operate href=\"javascript:onPriview();\" text=\""+SystemEnv.getHtmlLabelName(221,user.getLanguage())+"\" target=\"_self\"  index=\"0\"/>"
		 + "<operate href=\"javascript:onDownload();\" text=\""+SystemEnv.getHtmlLabelName(31156,user.getLanguage())+"\" target=\"_self\"  index=\"1\"/>"
		 + "<operate href=\"javascript:onEdit();\" text=\""+SystemEnv.getHtmlLabelName(26473,user.getLanguage())+"\" target=\"_self\"  index=\"2\"/>"
		 + "<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_self\"  index=\"3\"/>"
		 + "</operates></table>";						
	%>
	<TABLE width="100%">
		<TR>
			<TD valign="top">
				<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"   />
			</TD>
		</TR>
	</TABLE>
						<table class="liststyle" cellspacing=1  style="display:none">						
							<TR class="header">
								<TH width="5%">ID</TH>
								<TH width="25%"><%=SystemEnv.getHtmlLabelName(22009,user.getLanguage())%><!--名称--></TH>
								<!--<TH width="40%"><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>描述</TH>-->
								<TH width="15%"><%=SystemEnv.getHtmlLabelName(22256,user.getLanguage())%><!--类型--></TH>
								<TH width="15%"><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%><!--预览--></TH>
							</TR>

							<%
							rs.executeSql("select * from pagetemplate order by id");
							int index=0;

							String dirTemplate=pc.getConfig().getString("template.path");
							while(rs.next()){							
								index++;
							%>
							<TR class="<%=index%2==0?"datadark":"datalight"%>">
								<TD><%=rs.getString("id")%></TD>
								<TD><%=rs.getString("templatename")%></TD>
								<TD style="display:none"><%=rs.getString("templatedesc")%></TD>
								<TD><%="cus".equals(rs.getString("templatetype"))?SystemEnv.getHtmlLabelName(19516,user.getLanguage()):SystemEnv.getHtmlLabelName(468,user.getLanguage())%></TD>
								<TD>
								<a href="<%=dirTemplate+rs.getString("dir")%>index.htm" target="_blank"><%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%><!--预览--></a>
								&nbsp;<a href="<%=dirTemplate+"zip/"+rs.getString("zipName")%>"><%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%><!--下载--></a>
								&nbsp;<a href="#" onclick="onEdit(this)"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%><!--编辑--></a>
								&nbsp;<a href="#" onclick="onDel(this)"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><!--删除--></a>
								</TD>
							</TR>
							<%}%>
						</table>
<div id="divTemplate" title="<%=SystemEnv.getHtmlLabelName(23140,user.getLanguage())%>">
	<FORM  name="frmAdd" method="post" enctype="multipart/form-data" action="Operate.jsp" onSubmit="return actionCheck();">
	<input type="hidden"   name="method" value="add">
	<input type="hidden"   name="templateid">
	<table class="viewform">
		<tr>
			<td width="30%"><%=SystemEnv.getHtmlLabelName(22009,user.getLanguage())%><!--名称--></td>
			<td class="field" width="70%">
				<input type="text" class="inputstyle" name="templatename" id="templatename" style="width:95%" onchange='checkinput("templatename","templatenamespan")'>
				<SPAN id=templatenamespan>
	               <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
	             </SPAN>
			</td>
		</tr>
		<tr style="height:1px;"><td colspan=2 class="line"></td></tr>
		<tr>
			<td width="30%" ><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%><!--描述--></td>
			<td class="field" width="70%"><textarea name="templatedesc" id="templatedesc" style='height:70px;width:95%' class=inputStyle onchange='checkinput("templatedesc","templatedescspan")'></textarea>
			<SPAN id=templatedescspan>
	               <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
	             </SPAN>
			</td>
		</tr>
		<tr style="height:1px;"><td colspan=2 class="line"></td></tr>
	</table>
	<table class="viewform" id="tblFile">
		<tr>
			<td width="30%"><%=SystemEnv.getHtmlLabelName(18493,user.getLanguage())%>(.zip)<!--文件--></td>
			<td class="field" width="70%">
				<input type="file"  class="inputstyle" name="templaterar" id="templaterar" style="width:95%" onchange='checkinput("templaterar","templaterarspan")' >
				<SPAN id=templaterarspan>
	               <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
	             </SPAN>
			</td>
			
		</tr>
			<!--
		<tr style="height:1px;"><td colspan=2 class="line"></td></tr>

		<tr>
			<td width="30%"><%=SystemEnv.getHtmlLabelName(275,user.getLanguage()) %></td>
			<td class="field" width="70%" height='25'>
			  <a href=javascript:openFullWindowForXtable('/page/maint/help/help.jsp?type=template')><%=SystemEnv.getHtmlLabelName(15593,user.getLanguage())%></a>
				<a href="#"><%=SystemEnv.getHtmlLabelName(15593,user.getLanguage())%></a>
			</td>
		</tr>
-->
	</table>
	</FORM>
</div>

</body>
</html>
<script>
	function onAdd(){
		frmAdd.method.value="add";
		$("#templatename").val('');
		$("#templatedesc").val('');
		$("#templatenamespan").children().show();
		$("#templatedescspan").children().show();
		$("#templaterarspan").children().show();
		$("#tblFile").show()
		$("#divTemplate").dialog('open');
	}
	
	function onEdit(templateid){		
		frmAdd.method.value="edit";
		frmAdd.templateid.value=templateid;
		$("#templatename").val($("#template_"+templateid).parents("tr:first").find("td:nth-child(3)").html());
		$("#templatenamespan").children().hide();
		$("#templatedesc").val($("#template_"+templateid).parents("tr:first").find("td:nth-child(4)").html().replace(new RegExp("<BR>","gm"),"\r\n"));
		$("#templatedescspan").children().hide();
		$("#templaterarspan").children().hide();
		//$("#tblFile").hide()
		$("#divTemplate").dialog('open');	
	}

	function onDel(templateid){
		if(isdel()){
			var action  = frmAdd.action;
			$.post(action,{method:'del',templateid:templateid},function(data){
				window.location.reload();
			}); 
		}
	}	

	$(document).ready(function(){
		$("#divTemplate").dialog({
			autoOpen: false,
			resizable:false,
			width:350,
			buttons: {
				"<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>": function() {
					
					if(frmAdd.method.value=='add'){
						if(check_form(frmAdd,'templatename,templatedesc,templaterar')){
							if(checkFileName()){
								frmAdd.submit();
							}
						}
					}else if(frmAdd.method.value=='edit'){
						if(check_form(frmAdd,'templatename,templatedesc')){
							if(checkFileName()){
								frmAdd.submit();
							}
						}
					}
				} 
			} 
		});	
		
		if('<%=message%>'=='1'){
			alert("<%=SystemEnv.getHtmlLabelName(104,user.getLanguage())+SystemEnv.getHtmlLabelName(498,user.getLanguage())%>")
			//window.location.href = "List.jsp"
		}
	});
	
	//判断文件后缀名是否为.zip文件和是否包含中文字符
	function checkFileName(){
		var fileName = document.getElementById("templaterar").value;
		if(fileName!=''){
			fileName=fileName.toLowerCase();   
			var lens=fileName.length;   
			var extname=fileName.substring(lens-4,lens);   
			if(extname!=".zip")   
			{   
			  alert("<%=SystemEnv.getHtmlLabelName(23942,user.getLanguage())%>");  
			  return false;
			} 
			if(/.*[\u4e00-\u9fa5]+.*$/.test(fileName.substr(fileName.lastIndexOf('\\')+1))){
		    	 alert("<%=SystemEnv.getHtmlLabelName(23984,user.getLanguage())%>");  
		    	return false;
		    }
		    
		    return true; 
	    }else{
	    	return true;
	    } 
	}
	//提交判断必填项是否为空
	function actionCheck(){
		var txtName = document.getElementById("templatename").value;
		var descName = document.getElementById("templatedesc").value;
		var rarName = document.getElementById("templaterar").value;
		if(frmAdd.method.value=="add"){
			if(txtName==''||descName==''||rarName==''){
				alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
				return false;
			}
		}else if (frmAdd.method.value=="edit"){
			if(txtName==''||descName==''){
				alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
				return false;
			}
		}
		return true;
	}
</script>
