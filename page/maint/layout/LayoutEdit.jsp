
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
   
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:dosubmit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
  <jsp:param name="mouldID" value="portal"/>
  <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(19516, user.getLanguage())+SystemEnv.getHtmlLabelName(19407, user.getLanguage())%>"/> 
</jsp:include>


<html>
 <head>
 <link href="/css/Weaver_wev8.css" type="text/css" rel=stylesheet>
 <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link href="/js/jquery/ui/jquery-ui_wev8.css" type="text/css" rel=stylesheet>
<LINK href="/css/ecology8/upload_e8_Btn_wev8.css" type="text/css" rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/ecology8/portalEngine/upload_e8_Btn_wev8.js"></script>

</head>
<body  id="myBody">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<FORM  name="frmAdd" method="post" enctype="multipart/form-data" action="Operate.jsp">

    <table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td width="160px">					
			</td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="dosubmit();" />
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>

	<input type="hidden"   name="method" value="<%=method %>">
	<input type="hidden"   name="layoutid" value="<%=layoutid %>">	
	<div class="zDialog_div_content">
<wea:layout type="2Col">
     <wea:group context="" attributes="{'groupDisplay':\"none\"}">
      <wea:item><%=SystemEnv.getHtmlLabelName(22009,user.getLanguage())%></wea:item>
      <wea:item>
        <wea:required id="layoutnamespan" required="true" value='<%=layoutname %>'>
             <input type="text" class="inputstyle" name="layoutname" id="layoutname" value="<%=layoutname %>" onchange='checkinput("layoutname","layoutnamespan")' style="width:95%" >
         </wea:required>
      </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
      <wea:item>
      	 <wea:required id="layoutdescspan" required="true" value='<%=layoutdesc %>'>
         <textarea name="layoutdesc" id="layoutdesc" style='height:70px;width:95%' class=inputStyle  onchange='checkinput("layoutdesc","layoutdescspan")'><%=layoutdesc %></textarea>
      	 </wea:required>
      </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(18493,user.getLanguage())%>(.zip)<!--文件--></wea:item>
      <wea:item>
      	 <wea:required id="layoutrarspan" required="true" >
              <input type="file" style="width:95%" id="layoutrar" name="layoutrar"  onchange='checkinput("layoutrar","layoutrarspan")'/>
      	 </wea:required>
      </wea:item>
     </wea:group>
</wea:layout>		
	</div>
</FORM>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
	     <input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="dosubmit();"/>
	     <span class="e8_sep_line">|</span>
	     <input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();"/>
	    </wea:item>
	</wea:group>
	</wea:layout>
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
