/* 
[Embed(source="assets/magnify.pbj", mimeType="application/octet-stream")]
private var shaderObj:Class;

private var shader:Shader;

private var shaderFilter:ShaderFilter;
///////////////////////////////////////////////////////////////////////////////////
// 放大镜功能
///////////////////////////////////////////////////////////////////////////////////

private var useMagnifier:Boolean = false;
*/
private function magnifierTool():void{
	/*if(!shader){ 
		initShader();
	}
	if(useMagnifier){
		useMagnifier = false;
		magnifier.toolTip = "打开放大镜";
		
		stage.removeEventListener( Event.ENTER_FRAME, onEnterFrame);
		orgChartContainer.filters = [];
		
		
		if(resizeEffect.isPlaying){
			resizeEffect.stop();
		}
		resizeEffect.heightTo = 0;
		resizeEffect.play([settingContainer]);
	}else{
		useMagnifier = true;
		magnifier.toolTip = "关闭放大镜";

		stage.addEventListener( Event.ENTER_FRAME, onEnterFrame, false, 0, true );
		
		if(resizeEffect.isPlaying){
			resizeEffect.stop();
		}
		resizeEffect.heightTo = 130;
		resizeEffect.play([settingContainer]);
	}*/
}

/*
private function initShader():void{
	// create the shader
	shader = new Shader( new shaderObj() );
	shader.data.center.value = [orgChartContainer.width/2, orgChartContainer.height/2];
	//setShader();
}


private function onEnterFrame( event:Event ):void{
	setShader();
}

private function setShader():void{
	var centerX:Number = orgChartContainer.mouseX;
	var centerY:Number = orgChartContainer.mouseY;
	if( centerX < 0 || centerY < 0 || centerX > orgChartContainer.width || centerY > orgChartContainer.height )
	{
		var currentX:Number = shader.data.center.value[0];
		var currentY:Number = shader.data.center.value[1]
		centerX = currentX + ((orgChartContainer.width / 2)-currentX) / 2;
		centerY = currentY + ((orgChartContainer.height / 2)-currentY) / 2;
	}

	shader.data.center.value = [centerX, centerY];
	shader.data.innerRadius.value = [innerRadiusSlider.value];
	shader.data.outerRadius.value = [outerRadiusSlider.value];
	shader.data.magnification.value = [magnificationSlider.value];
	shaderFilter = new ShaderFilter( shader );
	orgChartContainer.filters = [shaderFilter];
}
 */