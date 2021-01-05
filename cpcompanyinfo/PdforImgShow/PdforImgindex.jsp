
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<script type="text/javascript" src="/js/jquery/jquery_wev8.js"></script>
<script type="text/javascript" src="ddpowerzoomer_wev8.js"></script>
<script type="text/javascript">
jQuery(document).ready(function($){ //fire on DOM ready
	$('img#gallerya').addpowerzoom({magnifiersize:[150,150]})
	//$('img.gallery').addpowerzoom({powerrange:[2,5]})
})
</script>
<body style="padding: 5px;margin: 0px;background-color: #585858">
		<%
			String imgid=Util.null2String(request.getParameter("imgid"));
			String sjdata=Util.null2String(request.getParameter("sjdata"));
			String ispdf=Util.null2String(request.getParameter("ispdf"));
			//System.out.println("imgid="+imgid);
			if("1".equals(ispdf)){
		%>
		
				<embed width="400" height="290" src="/weaver/weaver.file.FileDownload?fileid=<%=imgid%>"> </embed> 
		<%
			}else if("0".equals(ispdf)){
		%>
			<img id="gallerya"  src="/weaver/weaver.file.FileDownload?fileid=<%=imgid%>&sjdata=<%=sjdata %>" style="height: 290px;width: 390px;overflow: auto;"/>
		<%	
			}
		%>
</body>
</html>
