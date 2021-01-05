function getElement(id){   
     return document.getElementById(id);   
};
//Amplifier.init('source','dest',jQuery("select#speed").val());//调用放大镜
var Amplifier = {
	source: null,   
	dest: null,     
	scale: 1,    
	init: function(source, dest,scale){   
		this.source = getElement(source);  
		this.dest = getElement(dest);   
		//放大倍数
		this.scale = scale||2;  		
		//创建显示大图片的位置
		var borderBox = document.createElement("div");
		//绑定大图片的id
		borderBox.setAttribute("id","chooseArea");   
		//设置鼠标周围的拖动层
		borderBox.style.height = parseInt(this.source.style.height)/scale+"px";   
		borderBox.style.width = parseInt(this.source.style.width)/scale+"px";   
		//设置鼠标周围的拖动层样式
		borderBox.style.border = "solid red 1px";   
		borderBox.style.position = "relative";   
		borderBox.style.top =(-parseInt(this.source.style.height) - 2)+"px";   
		borderBox.style.left =0+"px"; 
		//追加鼠标周围的拖动层到界面
		this.source.appendChild(borderBox);
		//创建层的显示img
		var destImg = document.createElement('img');   
		destImg.style.position = "relative";  
		//绑定图片的src
		destImg.src = this.source.getElementsByTagName('img')[0].src;   
		//绑定图片到层
		this.dest.appendChild(destImg);
	//	console.log("Hello World");
		destImg.height = parseInt(this.source.style.height)*scale;   
		destImg.width = parseInt(this.source.style.width)*scale;
		this.source.onmousemove = function(e){
			
						//	console.log("你好周氏周子龙---------------------------------------------------------");
								if(Amplifier.getEvent(e).offsetX>parseInt(borderBox.style.width)/2 && (parseInt(this.style.width)- Amplifier.getEvent(e).offsetX)>parseInt(borderBox.style.width)/2){   
									borderBox.style.left = Amplifier.getEvent(e).offsetX - parseInt(borderBox.style.width)/2+"px"; 
								}   
								else if(Amplifier.getEvent(e).offsetX<parseInt(borderBox.style.width)/2){   
									borderBox.style.left = 0+"px"; 
								}   
								else{   
									borderBox.style.left = parseInt(this.style.width) - parseInt(borderBox.style.width)+"px"; 
								} 
								
								if(Amplifier.getEvent(e).offsetY>parseInt(borderBox.style.height)/2 - 1 && (parseInt(this.style.height)- Amplifier.getEvent(e).offsetY)>parseInt(borderBox.style.height)/2){   
									borderBox.style.top =( -parseInt(this.style.height) + Amplifier.getEvent(e).offsetY - parseInt(borderBox.style.height)/2 - 2)+"px"; 
								}   
								else if(Amplifier.getEvent(e).offsetY<parseInt(borderBox.style.height)/2){   
									borderBox.style.top = -parseInt(this.style.height) - 2+"px"; 
								}   
								else{   
									borderBox.style.top = -parseInt(borderBox.style.height) - 2+"px"; 
								}   
								
								destImg.style.left = -Math.abs(parseInt(borderBox.style.left)*scale) + 0.5+"px"; 
								destImg.style.top = -( parseInt(this.style.height) - Math.abs(parseInt(borderBox.style.top)) )*scale - 3.5+"px"; 
		};   
	},   
	getEvent: function(e){   
		if (typeof e == 'undefined'){   
			e = window.event||event;   
		}   
		/*alert(ee);
			//alert(e.x?e.x : e.layerX);   
		if(typeof e.x == 'undefined'){   
			ee.offsetX = e.layerX;   
		}   
		if(typeof e.y == 'undefined'){   
 			ee.offsetX = e.layerY;   
		}   */
		return e;   
	}   
};