
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
String templateid =Util.null2o(request.getParameter("templateid"));
String message = Util.null2String(request.getParameter("message"));
String closeDialog = Util.null2String(request.getParameter("closeDialog"));

String titlename = SystemEnv.getHtmlLabelName(23011,user.getLanguage());

String templatename = "";
String templatedesc = "";
String templatetype = "";
rs.executeSql("select id,templatename,templatedesc,templatetype from pagenewstemplate where id="+templateid);
if(rs.next()){
	templatename=rs.getString("templatename");
	templatedesc=rs.getString("templatedesc");
	templatetype=rs.getString("templatetype");
}

%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
   
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:dosubmit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onCancel(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


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
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="portal"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(23088,user.getLanguage())+SystemEnv.getHtmlLabelName(18596,user.getLanguage())%>"/> 
</jsp:include>
<FORM  name="frmAdd" method="post" enctype="multipart/form-data" action="operate.jsp">
	<input type="hidden"   name="method" value="add">
	<input type="hidden"   name="templateid" value="<%=templateid %>">	
	<div class="zDialog_div_content">
<wea:layout type="2Col">
     <wea:group context="" attributes="{'groupDisplay':\"none\"}">
      <wea:item><%=SystemEnv.getHtmlLabelName(22009,user.getLanguage())%></wea:item>
      <wea:item>
        <wea:required id="templatenamespan" required="true" value='<%=templatename %>'>
         <input type="text" class="inputstyle" name="templatename" id="templatename" value="<%=templatename %>" onchange="checkinput('templatename','templatenamespan');" style="width:95%" >
         </wea:required>
      </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
      <wea:item>
      	 <wea:required id="templatedescspan" required="true" value='<%=templatedesc %>'>
         <textarea name="templatedesc" id="templatedesc" onchange="checkinput('templatedesc','templatedescspan');" style='height:70px;width:95%' class=inputStyle><%=templatedesc %></textarea>
      	 </wea:required>
      </wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(22256,user.getLanguage())%></wea:item>
      <wea:item>
        <select id="templatetype" name="templatetype" >
			<option value="0" <%="0".equals(templatetype)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(33532,user.getLanguage())%></option>
			<option value="1" <%="1".equals(templatetype)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(33533,user.getLanguage())%></option>
		</select>
      </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(18493,user.getLanguage())%>(.zip)<!--文件--></wea:item>
      <wea:item>
      	 <wea:required id="templaterarspan" required="true" >
         <input type="file" style="width:95%" id="templaterar" name="templaterar" onchange="checkinput('templaterar','templaterarspan');"/>
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
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 	
</body>
</html>
<script>
	function dosubmit(){
		if(check_form(frmAdd,'templatename,templatedesc,templaterar')){
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
			parentWin.location.href="/page/maint/template/news/NewsTemplateList.jsp?e="+new Date().getTime();
			onCancel();
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
</script>
