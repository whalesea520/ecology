
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
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
String titlename = SystemEnv.getHtmlLabelName(23088,user.getLanguage());
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
<TABLE width=100% height=100% border="0" cellspacing="0">
    <colgroup>
    <col width="10">
    <col width="">
    <col width="10">
    <tr>
      <td height="10" colspan="3"></td>
    </tr>
    <tr>
        <td></td>
        <td valign="top">
			<table class="Shadow">
				<colgroup>
				<col width="1">
				<col width="">
				<col width="10">
				<tr>
					<TD></TD>		
					<td valign="top">
						<table class="liststyle" cellspacing=1>						
							<TR class="header">
								<TH width="5%">ID</TH>
								<TH width="25%"><%=SystemEnv.getHtmlLabelName(22009,user.getLanguage())%><!--名称--></TH>
								<!--<TH width="40%"><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>描述</TH>-->
								<TH width="15%"><%=SystemEnv.getHtmlLabelName(22256,user.getLanguage())%><!--类型--></TH>
								<TH width="15%"><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%><!--操作--></TH>
							</TR>

							<%
							rs.executeSql("select * from pagenewstemplate order by id");
							int index=0;

							String dirtemplate=pc.getConfig().getString("news.path");
							while(rs.next()){							
								index++;
							%>
							<TR class="<%=index%2==0?"datadark":"datalight"%>">
								<TD><%=rs.getString("id")%></TD>
								<TD><%=rs.getString("templatename")%></TD>
								<TD style="display:none"><%out.print(rs.getString("templatedesc"));%></TD>
								<TD><%="0".equals(rs.getString("templatetype"))?SystemEnv.getHtmlLabelName(1994,user.getLanguage()):SystemEnv.getHtmlLabelName(1995,user.getLanguage())%></TD>
								<TD>
							
								<a href="<%=dirtemplate+rs.getString("templatedir")%>index.htm" target="_blank"><%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%><!--预览--></a>
								&nbsp;<a href="<%=dirtemplate+"zip/"+rs.getString("zipName")%>"><%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%><!--下载--></a>
								&nbsp;<a href="#" onclick="onEdit(this)"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%><!--编辑--></a>
								<!--&nbsp;<a href="javascript:onSetting(<%=rs.getString("id")%>,'<%=rs.getString("templatetype") %>')"><%=SystemEnv.getHtmlLabelName(22250,user.getLanguage())%>设置--></a>
								&nbsp;<a href="#" onclick="onDel(this)"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><!--删除--></a>
								
								</TD>
							</TR>
							<%}%>
						</table>
					</td>
				</tr><TR  style="height:1px;"><TD class=line colspan=3></TD></TR><tr>
				</tr>
				<tr>
					<td height="10" colspan="3"></td>
				</tr>
			</table>
			</form>
	    </td>
		<td></td>
	</tr>
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
</TABLE>

<div id="divtemplate" title="<%=SystemEnv.getHtmlLabelName(23088,user.getLanguage())%>">
	<FORM  name="frmAdd" method="post" enctype="multipart/form-data" action="operate.jsp" onSubmit="return actionCheck();">
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
		<tr  style="height:1px;"><td colspan=2 class="line"></td></tr>
		<tr>
			<td width="30%"><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%><!--描述--></td>
			<td class="field" width="70%"><textarea name="templatedesc" id="templatedesc" style='height:70px;width:95%' class=inputStyle onchange='checkinput("templatedesc","templatedescspan")' ></textarea>
				<SPAN id=templatedescspan>
		               <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
		        </SPAN>
			</td>
		</tr>
		<tr  style="height:1px;"><td colspan=2 class="line"></td></tr>
				<tr>
			<td width="30%"><%=SystemEnv.getHtmlLabelName(22256,user.getLanguage())%><!--类型--></td>
			<td class="field" width="70%">
			<select id="templatetype" name="templatetype">
			<option value="0" selected><%=SystemEnv.getHtmlLabelName(1994,user.getLanguage())%></option>
			<option value="1"><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%></option>
			</select>
			</td>
		</tr>
		<tr  style="height:1px;"><td colspan=2 class="line"></td></tr>
	</table>
	<table class="viewform" id="tblFile">
		<tr>
			<td width="30%"><%=SystemEnv.getHtmlLabelName(18493,user.getLanguage())%>(.zip)<!--文件--></td>
			<td class="field" width="70%">
				<input type="file"  class="inputstyle" name="templaterar" id="templaterar" style="width:95%" onchange='checkinput("templaterar","templaterarspan")'>
				<SPAN id=templaterarspan>
	               <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
	             </SPAN>
			</td>
		</tr>
		<!--
		<tr  style="height:1px;"><td colspan=2 class="line"></td></tr>

		<tr>
			<td width="30%"><%=SystemEnv.getHtmlLabelName(275,user.getLanguage()) %></td>
			<td class="field" width="70%" height='25'>
				 <a href=javascript:openFullWindowForXtable('/page/maint/help/help.jsp?type=newstemplate')><%=SystemEnv.getHtmlLabelName(15593,user.getLanguage())%></a> 
				<a href="#"><%=SystemEnv.getHtmlLabelName(15593,user.getLanguage())%></a>
			</td>
		</tr>
-->
	</table>
	</FORM>
</div>
<form id="settingForm" action="newstemplate.jsp" method="post">

<input type="hidden" name="templateid" id="templateid">
<input type="hidden" name="templatetypesetting" id="templatetypesetting">
<input type="hidden" name="pagetype" id="pagetype" >
<input type="hidden" name="isSetting" id="isSetting" value="true" >
</form>
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
		$("#divtemplate").dialog('open');	
	}
	
	function onEdit(obj){
		frmAdd.method.value="edit";
		frmAdd.templateid.value=obj.parentNode.parentNode.childNodes[0].innerHTML;
		$("#templatename").val(obj.parentNode.parentNode.childNodes[1].innerHTML);
		$("#templatedesc").val($($(obj).parents("tr")[0]).find("td")[2].innerHTML.replace(new RegExp("<BR>","gm"),"\r\n"));
		$("#templatenamespan").children().hide();
		$("#templatedescspan").children().hide();
		$("#templaterarspan").children().hide();
		
		if($($(obj).parents("tr")[0].cells[3]).text()=="<%=SystemEnv.getHtmlLabelName(1994,user.getLanguage())%>"){
			$("#templatetype").attr("value",0);
		}else{
			$("#templatetype").attr("value",1);
		}
		//$("#tblFile").hide()
		$("#divtemplate").dialog('open');		
	}

	function onDel(obj){
		if(isdel()){
			var action  = frmAdd.action;
			var templateid=$($(obj).parents("tr")[0]).find("td")[0].innerHTML;
			$.post(action,{method:'del',templateid:templateid},function(data){
				window.location.reload();
			}); 
		}
	}	

	function onSetting(id,type){
		$("#templateid").val(id);
		$("#templatetypesetting").val(type)
		if(type=="0"){
			$("#pagetype").val("")
		}else{
			$("#pagetype").val("loginview");
		}
		settingForm.submit();
	}
	
	$(document).ready(function(){
		$("#divtemplate").dialog({
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
			//window.location.href = "list.jsp"
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
		if(frmAdd.method.value=='add'){
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