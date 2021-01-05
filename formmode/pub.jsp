<%@ include file="/formmode/pub_init.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html>
<head>
	<script type="text/javascript" src="/formmode/js/jquery/jquery-1.8.3.min_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/FormmodeUtil_wev8.js"></script>
	<script type="text/javascript" src="/js/weaver_wev8.js"></script>
	<LINK type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />	<!-- for right menu -->
	
	<link type="text/css" rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css"/>
	<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
	
	<script language="javascript" type="text/javascript" src="/js/init_wev8.js"></script>
	<script type="text/javascript" src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js"></script>
	<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
	
	
	<LINK type="text/css" rel="stylesheet" href="/formmode/css/pub_wev8.css?d=20140616" />
	<script type="text/javascript" >
	function isdel(){
	  var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";//确定要删除吗?
      if(!confirm(str)){
        return false;
      }
        return true;
    } 

   function issubmit(){
	 var str = "<%=SystemEnv.getHtmlLabelName(22161,user.getLanguage())%>";//确定要提交吗?
     if(!confirm(str)){
       return false;
     }
       return true;
   } 
   
   function checkFieldValue(ids){
		var idsArr = ids.split(",");
		for(var i=0;i<idsArr.length;i++){
			var obj = document.getElementById(idsArr[i]);
			if(obj&&obj.value==""){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>",function(){displayAllmenu();});//必要信息不完整！
				return false;
			}
		}
		return true;
    }
	</script>
</head>
	
</html>