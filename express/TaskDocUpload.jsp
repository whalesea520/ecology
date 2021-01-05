
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ include file="/express/task/util/uploader.jsp" %>
<jsp:useBean id="cmutil" class="weaver.task.CommonTransUtil" scope="page"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
   <script language="javascript" src="/js/jquery/jquery_wev8.js"></script>
   <style>
   	  html,body{-webkit-text-size-adjust:none;margin: 0px;overflow: hidden;}
	 *{font-size: 12px;font-family: Arial,'微软雅黑';outline:none;}
  	 .datatable td.title{font-family: 微软雅黑;color: #999999;vertical-align: top;padding-top: 7px;padding-bottom: 7px;padding-left: 20px;background: #F6F6F6;border-top: 1px #F6F6F6 solid;border-bottom: 1px #F6F6F6 solid;}
   	 .datatable td.data{vertical-align: middle;border-top: 1px #fff solid;border-bottom: 1px #fff solid;}
   	 .flash{width:280px !important;position:absolute}
   </style>
   <script>
    $(document).ready(function(){
    	bindUploaderDiv($("#uploadDiv"),"relatedacc","");
    });
    function uploadFile(){
    	var oUploader=window[jQuery("#uploadDiv").attr("oUploaderIndex")];
	    try{
	       if(oUploader.getStats().files_queued==0) //如果没有选择附件则直接提交
	         alert("请选择文件!");
	       else 
	     	 oUploader.startUpload();
		}catch(e){
		     oUploader.startUpload();
		 }
	}
	
	function closeDialog(){
		alert("上传成功");
		$("#uploadDiv").html("");
		parentDialog.close();
	}
	
   </script>
</head>
<body>
	<table class="datatable" style="width: 100%" cellpadding="0" cellspacing="0" border="0" align="center">
				<TBODY>		
				<tr>
					<td class="title" width="90px">上传文档</TD>
					<td class="data" width="300px">
				  		<div id="uploadDiv" class="upload" mainId="19" subId="41" secId="56" maxsize="60" uploadType="uploaddoc"></div>
				  	</td>
				</tr>
			</TBODY>
  	</table>
</body>
</html>