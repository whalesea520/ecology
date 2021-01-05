(function($){
    $.fn.iedrag = function(option){
    
        /*参数*/
        var para = jQuery.extend({
            handle: '.title'        
        }, option);        
        
        /*执行*/
        $(this).each(function(){
            var $this = $(this);
            var $handle=$(this).find(para.handle);            
            $handle.css("cursor","move");
            
            var posX=0;
            var posY=0;
            $handle[0].onmousedown=function(){
				var srcItemHead=event.srcElement;
				if(event.button!=1) return;	 
				
				if(srcItemHead.tagName=="IMG") return;		
				if(srcItemHead.className=="operate") return;		
				
				$this.css({ position:"absolute"});
				posX=event.clientX;
				posY=event.clientY;				
				event.srcElement.dragDrop();
				
			}
            $handle[0].ondrag=function(){
            	var srcItemHead=event.srcElement;     
            	
            	/*if($this.css("left")=="auto"){
            		var right=parseInt($this.css("right"))-parseInt((event.clientX-posX));
            		
	            	var bottom=parseInt($this.css("bottom"))-parseInt((event.clientY-posY));	                
	            	$this.css({right:right,bottom:bottom});  
            	} else {   */         		
	            	var left=parseInt($this.css("left"))+parseInt((event.clientX-posX));
	            	var top=parseInt($this.css("top"))+parseInt((event.clientY-posY));	 
	            	if(top<0) top=0;
	            	if(left<0) left=0;
	            	$this.css({left:left,top:top});  
            	//}
            	
            	posX=event.clientX;
				posY=event.clientY;
				
				//Debug.log('posY:'+posY)
				
				//if(posY<0) posY=0;
			}
            $handle[0].ondragend=function(){
            	
			}          
        });       
    };
})(jQuery);