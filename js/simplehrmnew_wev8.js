function pointerXY(event)  
{    
      event = event || window.event;
	 //if(event.pageX||event.pageY)
     //{
     //	bodySize[0] = event.pageX;
    // 	bodySize[1] = event.pageY;
    // 	clickSize[0] = event.pageX;
    // 	clickSize[1] = event.pageY;
    // }
    // else
    // {
     	bodySize[0] = event.clientX;
     	bodySize[1] = event.clientY;
     	clickSize[0] = event.clientX;
     	clickSize[1] = event.clientY;
    // }
} 

function getWin()
{
    
    W = jQuery('#maindiv').width();
	//H = jQuery('#maindiv').height();
	H = $(document).height() > $(window).height()?$(window).height():$(document).height();
}

function changehrm()
{
   var mainsupports = M("mainsupports");   
   var bodySize = getBodySize();
   var clickSize = getClickSize();
   var wi = W-clickSize[0];
   var hi = H-clickSize[1];
   if(wi<372)
   {
   		wi=bodySize[0]+wi-372;
   }
   else
   {
   		wi = bodySize[0]
   }
   if(hi<230)
   {
   		hi= $(document).scrollTop() + bodySize[1]+hi-230 - 95;
		//hi = clickSize[1]
   }
   else
   {
		//hi = clickSize[1] 
   		hi = $(document).scrollTop() + bodySize[1] - 95;
   }

   showIframe(mainsupports,hi,wi);
}