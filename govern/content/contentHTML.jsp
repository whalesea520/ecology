<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ include file="/systeminfo/init_wev8.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

	<!-- uEditor -->
    <script type="text/javascript" charset="utf-8" src="/ueditor/ueditor.config_wev8.js"></script>
    <script type="text/javascript" charset="utf-8" src="/ueditor/ueditor.all_wev8.js"></script>
    <script type="text/javascript" charset="utf-8" src="/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>
  
</head>
<body>
	<p>
        <textarea  name="doccontent" id="doccontent"></textarea>
    </p>
     
    <script type="text/javascript">
	    var toolbars = [[
		            'fullscreen', 'source', '|',
		            'bold', 'italic', 'underline', 'fontborder', 'strikethrough', '|', 
		            'fontfamily', 'fontsize', 'forecolor', 'backcolor','|', 
		            'insertorderedlist', 'insertunorderedlist',
		            'lineheight', 'indent','paragraph', '|',
		            'justifyleft', 'justifycenter', 'justifyright', '|',
		            'insertimage', 'inserttable', '|',
		            'link', 'unlink', 'anchor', '|', 
		            'map', 'insertframe', 'background', 'horizontal',  'spechars', '|',
		            'removeformat', 'formatmatch','pasteplain', '|',
		            'undo', 'redo', '|', 
	        ]];	        
	       
		var ue = UE.getEditor('doccontent',{
		autoFloatEnabled:false, //不保持工具栏位置
		toolbars:toolbars,
		//readonly : true,
		initialFrameHeight:400,
		initialFrameWidth:800,
		initialStyle : "p{font-family:Microsoft YaHei; font-size:12px;}",		
		});
	</script>
	
</body>
</html>