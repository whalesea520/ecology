$(document).ready(function () { 
	$('a.btn-ok, #dialog-overlay, #dialog-box').click(function () { 
		$('#dialog-overlay, #dialog-box').hide(); 
		return false; 
	}); 
	$(window).resize(function () { 
		if (!$('#dialog-box').is(':hidden')) popup(); 
	}); 
}); 
function popup(e, message, t, l) { 
	var ev = e ? e : event;
	var position = getPointerPosition(ev);
	
	var maskHeight = $(document).height(); 
	var maskWidth = $(window).width(); 
	var dialogTop = position.top;//t + 45;//(maskHeight/3) - ($('#dialog-box').height()); 
	var dialogLeft = position.left;//l + 20;//(maskWidth/2) - ($('#dialog-box').width()/2); 
	
	//alert(position.top);
	//alert(position.left);
	//$('#dialog-overlay').css({height:maskHeight, width:maskWidth}).show(); 
	$('#dialog-box').css({top:dialogTop, left:dialogLeft}).show(); 
	$('#dialog-message').html(message); 
}

function getPointerPosition(e){
 

       var obj = e.currentTarget||document.activeElement;
       var position = {
              left:e.pageX || (e.clientX + (document.documentElement.scrollLeft || document.body.scrollLeft)),
              top:e.pageY || (e.clientY + (document.documentElement.scrollTop || document.body.scrollTop))
           };
       return position;
}

function drawLine(context, lineWidth, lineColor, x1, y1, x2, y2) {
	context.beginPath();
	context.lineWidth = lineWidth;
	context.strokeStyle = lineColor;
	context.moveTo(x1, y1);
	context.lineTo(x2, y2);
	context.stroke(); 
}
