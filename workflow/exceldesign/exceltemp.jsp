
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
	<script type="text/javascript">
		jQuery(document).ready(function(){
		
		});
		function doUpdate(){
			var dlg=new window.top.Dialog();//定义Dialog对象
			dlg.Model=true;
	     	dlg.maxiumnable=true;
	　　　	dlg.Width=$(window).width()-100;//定义长度
	　　　	dlg.Height=$(window).height()-100;
			//dlg.Top=50;
	       	dlg.hideDraghandle = true;
	       	dlg.DefaultMax = false;
	       	//老表单
	       	//dlg.URL="/workflow/exceldesign/excelMain.jsp?wfid=1103&nodeid=5236&formid=33&isbill=0&modeid=0&layouttype=0";  
	     	//新表单
	     	dlg.URL="/workflow/exceldesign/excelMain.jsp?wfid=955&nodeid=4344&formid=-629&isbill=1&modeid=2256&layouttype=0";  
	　　　	dlg.Title="新版流程模式设计器";
	　　　	dlg.show();
		}
	</script>
</HEAD>
<BODY>
	<input class="e8_btn_top middle" onclick="doUpdate()" type="button" jQuery1392950000546="32" value="新版流程模式设计器"/>
</BODY>
</HTML>
