import mx.effects.easing.Bounce;

//////////////////////////////////////////////////////////
// 处理放大缩小
// Zoom in and Zoom out
//////////////////////////////////////////////////////////
private var currentZoom:Number = 1;

private function initZoom():void{
	//addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
}
private function onMouseWheel(e:MouseEvent):void{
	if(e.delta > 0){
		zoomInChart();	
	}else{
		zoomOutChart();		
	}
}
private function zoomInChart():void{
	 if(oc.scaleX < 2){
		oc.scaleX += .05;
		oc.scaleY += .05; 
		} 
	 /*if(currentZoom < 3){
		currentZoom += .1;
		playZoomEffect(currentZoom);
	}  */
}
private function zoomOutChart():void{
	if(oc.scaleX > .2){
		oc.scaleX -= .05;
		oc.scaleY -= .05;
	} 
	/* if(currentZoom > .1){
		currentZoom -= .1;
		playZoomEffect(currentZoom);
	}  */
}
private function playZoomEffect(toZoom:Number):void{
	zoomEffect.zoomHeightTo = toZoom;
	zoomEffect.zoomWidthTo = toZoom;
	//zoomEffect.easingFunction = Bounce.easeOut;
		
	if(zoomEffect.isPlaying){
		zoomEffect.end();
	}
	zoomEffect.play();
}
private function resetZoom():void{
	oc.scaleX = 1;
	oc.scaleY = 1; 
	//playZoomEffect(1);
}