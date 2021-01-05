<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 TRANSITIONAL//EN">
<html>
<head>
<title></title>
<meta name="generator" content="editplus">
<meta name="author" content="">
<meta name="keywords" content="">
<meta name="description" content="">

<script language="javascript" src="/js/Cookies_wev8.js"></script>
</head>


     
<FRAMESET id="mainFrameSet" name="mainFrameSet" ROWS="," COLS="134,*" frameborder="no" border="2">
	<FRAME SRC="left.jsp" scrolling="NO" id="LeftMenuFrame" NAME="LeftMenuFrame" target="mainFrame">
	<FRAME SRC="" id="mainFrame" NAME="mainFrame" onload="onLoadComplete(this)">

</FRAMESET>
</html>
<script type="text/javascript">	

window.onload=function(){
        
	var iMenuWidth=134;
	var iLeftMenuFrameWidth=Cookies.get("iLeftMenuFrameWidth");
	//alert(iLeftMenuFrameWidth);	
	if(iLeftMenuFrameWidth!=null) iMenuWidth=iLeftMenuFrameWidth;
	mainFrameSet.cols=iMenuWidth+",*";
};

function onLoadComplete(ifm){
 if(ifm.readyState=="complete")
{   
                try{
		if(ifm.contentWindow.location.href.indexOf("Homepage.jsp")!=-1){
			return;
		}
                }catch(e){}

        try{
			 if( ifm.contentWindow.document.body.clientHeight>document.body.clientHeight){
				  ifm.style.height = document.body.clientHeight;
			 }else{
				  ifm.style.height = ifm.contentWindow.document.body.clientHeight;		 
			 }
		 }catch(e){}
 }
}
</script>