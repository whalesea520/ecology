
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
String layoutid =Util.null2o(request.getParameter("layoutid"));	
String method = Util.null2String(request.getParameter("method"));
String message = Util.null2String(request.getParameter("message"));
String closeDialog = Util.null2String(request.getParameter("closeDialog"));

String titlename = SystemEnv.getHtmlLabelName(23011,user.getLanguage());

String layoutname = "";
String layoutdesc = "";
rs.executeSql("select id,layoutname,layoutdesc from pagelayout where id="+layoutid);
if(rs.next()){
	layoutname=rs.getString("layoutname");
	layoutdesc=rs.getString("layoutdesc");
}

%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
   
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(19407,user.getLanguage())+",javascript:onAdd(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<html>
 <head>
 <link href="/css/Weaver_wev8.css" type="text/css" rel=stylesheet>
 <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link href="/js/jquery/ui/jquery-ui_wev8.css" type="text/css" rel=stylesheet>

</head>
<body  id="myBody">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<FORM  name="frmAdd" method="post" enctype="multipart/form-data" action="Operate.jsp">
	<input type="hidden"   name="method" value="<%=method %>">
	<input type="hidden"   name="layoutid" value="<%=layoutid %>">	
	<div class="zDialog_div_content">	
	      <TABLE class="viewform">
	      <COLGROUP>
	  	<COL width="20%">
	  	<COL width="80%">
	        <TBODY>
	        <TR class="Spacing" style="height:1px;">
	          <TD class="Line" colSpan=2></TD></TR>
	        <TR>
	          <td width="30%"><%=SystemEnv.getHtmlLabelName(22009,user.getLanguage())%><!--名称--></td>
				<td class="field" width="70%">
					<input type="text" class="inputstyle" name="layoutname" id="layoutname" value="<%=layoutname %>" style="width:95%" onchange='checkinput("layoutname","layoutnamespan")'>
					<%="".equals(layoutname)?"<SPAN id=layoutnamespan><IMG src=\"/images/BacoError_wev8.gif\" align=absMiddle></SPAN>":""%>
				</td>
	        </TR> <TR class="Spacing" style="height:1px;">
	          <TD class="Line" colSpan=2></TD></TR>
	          <tr>
				<td width="30%"><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%><!--描述--></td>
					<td class="field" width="70%"><textarea name="layoutdesc" id="layoutdesc" style='height:70px;width:95%' class=inputStyle onchange='checkinput("layoutdesc","layoutdescspan")'><%=layoutdesc %></textarea>
					<%="".equals(layoutdesc)?"<SPAN id=layoutnamespan><IMG src=\"/images/BacoError_wev8.gif\" align=absMiddle></SPAN>":""%>
					</td>
				</td>
			</tr>
	          </TR> <TR class="Spacing" style="height:1px;">
	          <TD class="Line" colSpan=2></TD></TR>
	          <tr>
				<td width="30%"><%=SystemEnv.getHtmlLabelName(18493,user.getLanguage())%>(.zip)<!--文件--></td>
				<td class="field" width="70%">
					<input type="file"  class="inputstyle" name="layoutrar" id="layoutrar" style="width:95%" onchange='checkinput("layoutrar","layoutrarspan")'>
					<SPAN id=layoutrarspan>
		               <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
		             </SPAN>
				</td>
			</tr>
	           </TR> <TR class="Spacing" style="height:1px;">
	          <TD class="Line" colSpan=2></TD></TR>
	        </TBODY></TABLE>
	</div>
</FORM>

	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<table width="100%">
	    <tr><td style="text-align:center;" colspan="3">
	     <input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="dosubmit();"/>
	     <input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();"/>
	    </td></tr>
	</table>
	</div>	

</body>
</html>
<script>
	function dosubmit(){
		if(check_form(frmAdd,'layoutname,layoutdesc,layoutrar')){
			if(checkFileName()){
				frmAdd.submit();
			}
		}
	}
	
	function onCancel(){
		var dialog = parent.getDialog(window);   //弹出窗口的引用，用于关闭页面
		dialog.close();
	}

	$(document).ready(function(){
		if('<%=message%>'=='1'){
			alert("<%=SystemEnv.getHtmlLabelName(104,user.getLanguage())+SystemEnv.getHtmlLabelName(498,user.getLanguage())%>")
			//window.location.href = "LayoutList.jsp"
		}
		if("<%=closeDialog%>"=="close"){			
			var parentWin = parent.getParentWindow(window);
			parentWin.location.href="/page/maint/layout/LayoutList.jsp?e="+new Date().getTime();
			onCancel();
		}
	});
	
	//判断文件后缀名是否为.zip文件和是否包含中文字符
	function checkFileName(){
		var fileName = document.getElementById("layoutrar").value;
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
</script>