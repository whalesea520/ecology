
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<script language="javascript" src="/js/Cookies_wev8.js"></script>
<script language="javascript" src="/wui/common/jquery/jquery_wev8.js"></script>
<script language="javascript" src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>
<script type="text/javascript">	

window.onload=function(){
	var iMenuWidth=134;
	var iLeftMenuFrameWidth=Cookies.get("iLeftMenuFrameWidth");
	//alert(iLeftMenuFrameWidth);	
	if(iLeftMenuFrameWidth!=null) iMenuWidth=iLeftMenuFrameWidth;
	if($.client.browser!="Chrome") {
		mainFrameSet.cols=iMenuWidth+",*";
	}
	
	//alert($.client.browser)
	$("#mainFrameSet").css("height",document.body.clientHeight);
	
}

function onLoadComplete(ifm){
	if(ifm.readyState=="complete") {   
		if(ifm.contentWindow.location.href.indexOf("Homepage.jsp")!=-1){
			return;
		}
        try{
			 if( ifm.contentWindow.document.body.clientHeight==0 ||  ifm.contentWindow.document.body.clientHeight>document.body.clientHeight){
				  ifm.style.height = document.body.clientHeight;
			 }else{
				  ifm.style.height = ifm.contentWindow.document.body.clientHeight;		 
			 }
		 }catch(e){}
 	}
}

</script>
     <%
	String isIE = (String)session.getAttribute("browser_isie");

	%>
<FRAMESET id="mainFrameSet" framespacing="10" style="border-color:#b1d4d9" <%if(isIE.equals("true")){ %> frameborder="0"<%} %> name="mainFrameSet" ROWS="*" bordercolor="#b1d4d9"  COLS="160,*" >
	<FRAME      frameborder="0"  SRC="leftMenu/left.jsp" scrolling="NO" id="LeftMenuFrame" NAME="LeftMenuFrame" target="mainFrame"></FRAME>
	<FRAME  frameborder="0" SRC="" id="mainFrame"   NAME="mainFrame" onload="onLoadComplete(this)" style="padding-top:3px;background: #fff!important;"></FRAME>
</FRAMESET>

