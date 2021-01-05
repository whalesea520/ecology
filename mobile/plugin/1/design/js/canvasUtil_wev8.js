/**
 * 将Image loadding，完成后调用callback
 */
function loadImage(source, callback) {
	var image = new Image();
	image.src = source;
	image.onload = callback;
}

function draw17(context, text, x, y) {
	context.fillStyle = "#EEEEFF";
    context.fillRect(x, y, 70, 20);
    context.fillStyle = "#00f";

    context.font = "normal 13px Microsoft YaHei";
    //context.textBaseline = 'top';
    //context.textAlign = "left";
    //填充字符串
    context.fillText(text, x, y);
    //var length=context.measureText(txt);
    //context.fillText("长" + length.width + "px", 0, 50);
}


//-------------------------------------
//圆角矩形
function roundRect(ctx, x, y, w, h, r, outborder, outborderfill, outborderfill2, innerborder, innerfillImg, lineImg, label1, label2, color) {
	if (w < 2 * r) r = w / 2;
	if (h < 2 * r) r = h / 2;
	
	var lineImage = new Image();
	lineImage.src = lineImg;
	lineImage.onload = function () {
		var image = new Image();
		image.src = innerfillImg;
		image.onload = function () {
			var linear = ctx.createLinearGradient(x, y, x+50, y+50);
			linear.addColorStop(0, outborderfill);
			linear.addColorStop(1, outborderfill2);
			ctx.fillStyle = linear; //把渐变赋给填充样式
		    ctx.strokeStyle = outborder;
		    ctx.lineWidth = 1;
			
			ctx.beginPath();
			ctx.moveTo(x+r, y);
			ctx.arcTo(x+w, y, x+w, y+h, r);
			ctx.arcTo(x+w, y+h, x, y+h, r);
			ctx.arcTo(x, y+h, x, y, r);
			ctx.arcTo(x, y, x+w, y, r);
			ctx.closePath();
			ctx.stroke();
			ctx.fill();
			
			ctx.strokeStyle = innerborder;
		    ctx.lineWidth = 1;
			
			x = x + 3;
			y = y + 3;
			w = w - 6;
			h = h - 6;
			ctx.beginPath();
			ctx.moveTo(x+r, y);
			ctx.arcTo(x+w, y, x+w, y+h, r);
			ctx.arcTo(x+w, y+h, x, y+h, r);
			ctx.arcTo(x, y+h, x, y, r);
			ctx.arcTo(x, y, x+w, y, r);
			ctx.closePath();
			
			var pp = ctx.createPattern(image, 'repeat');
			ctx.fillStyle = pp;
			ctx.drawImage(this, x, y, w, h, x, y, 0, 0);
			
			ctx.stroke()
			ctx.fill();
			
			//ctx.strokeStyle = "none";
		    ctx.lineWidth = 2;
			//ctx.beginPath();
			
			//ctx.moveTo(x, y + y/2);
			//ctx.lineTo(x + w, y + y/2);
			//ctx.closePath();
			//var pp = ctx.createPattern(lineImage, 'repeat-x');
			//ctx.fillStyle = pp;
			//ctx.drawImage(this, x, y, w, h, x, y, 0, 0);
			ctx.drawImage(lineImage, x + 10, y + h/2, 80, 2);
			
			ctx.fillStyle = color;
			drawText(ctx, label1, 'normal 13px Microsoft YaHei', x + 6 + (110 - 70)/2 - 10, y-4 + 70/2 - 2, 70);
			drawText(ctx, label2, 'normal 13px Microsoft YaHei', x + 6 + (110 - 70)/2 - 10, y-4 + 70/2 + 15, 70);
		}
	}
}

//圆角菱形
function diamond(ctx, x, y, w, h, r, outborder, outborderfill, outborderfill2, innerborder, innerfillImg, lineImg, label1, label2, color) {
	
	var leftPoint = new Point(0 + x, h/2 + y);
	var topPoint = new Point(w/2 + x, 0 + y);
	var rightPoint = new Point(w + x, h/2 + y);
	var bottomPoint = new Point(w/2 + x, h + y);
	
	var leftPointInner = new Point(4 + x, h/2 + y);
	var topPointInner = new Point(w/2 + x, 4 + y);
	var rightPointInner = new Point(w - 4 + x, h/2 + y);
	var bottomPointInner = new Point(w/2 + x, h - 4 + y);
	
	var lineImage = new Image();
	lineImage.src = lineImg;
	lineImage.onload = function () {
	
		var image = new Image();
	
		image.src = innerfillImg;
		image.onload = function () {
			var linear = ctx.createLinearGradient(x, y, x+50, y+50);
			linear.addColorStop(0, outborderfill);
			linear.addColorStop(1, outborderfill2);
			ctx.fillStyle = linear; //把渐变赋给填充样式
			
			//this.fillStyle = outborderfill;
		    ctx.strokeStyle = outborder;
		    ctx.lineWidth = 1;
			
			ctx.beginPath();
			
			ctx.moveTo(leftPoint.x + 4, leftPoint.y + 3);
			ctx.bezierCurveTo(leftPoint.x + 4, leftPoint.y + 3, leftPoint.x, leftPoint.y, leftPoint.x + 4, leftPoint.y - 3);
			ctx.lineTo(topPoint.x - 4, topPoint.y + 3);
			ctx.bezierCurveTo(topPoint.x - 4, topPoint.y + 3, topPoint.x, topPoint.y, topPoint.x + 4, topPoint.y + 3);
			ctx.lineTo(rightPoint.x - 4, rightPoint.y - 3)
			ctx.bezierCurveTo(rightPoint.x - 4, rightPoint.y - 3, rightPoint.x, rightPoint.y, rightPoint.x - 4, rightPoint.y + 3);
			ctx.lineTo(bottomPoint.x + 4, bottomPoint.y -3);
			ctx.bezierCurveTo(bottomPoint.x + 4, bottomPoint.y -3, bottomPoint.x, bottomPoint.y, bottomPoint.x - 4, bottomPoint.y -3);
			
			
			ctx.closePath();
			ctx.stroke()
			ctx.fill();
			
		    ctx.strokeStyle = innerborder;
		    ctx.lineWidth = 1;
		    
			ctx.beginPath();
		
					
			ctx.moveTo(leftPointInner.x + 4, leftPointInner.y + 3);
			ctx.bezierCurveTo(leftPointInner.x + 4, leftPointInner.y + 3, leftPointInner.x, leftPointInner.y, leftPointInner.x + 4, leftPointInner.y - 3);
			ctx.lineTo(topPointInner.x - 4, topPointInner.y + 3);
			ctx.bezierCurveTo(topPointInner.x - 4, topPointInner.y + 3, topPointInner.x, topPointInner.y, topPointInner.x + 4, topPointInner.y + 3);
			ctx.lineTo(rightPointInner.x - 4, rightPointInner.y - 3);
			ctx.bezierCurveTo(rightPointInner.x - 4, rightPointInner.y - 3, rightPointInner.x, rightPointInner.y, rightPointInner.x - 4, rightPointInner.y + 3);
			ctx.lineTo(bottomPointInner.x + 4, bottomPointInner.y -3);
			ctx.bezierCurveTo(bottomPointInner.x + 4, bottomPointInner.y -3, bottomPointInner.x, bottomPointInner.y, bottomPointInner.x - 4, bottomPointInner.y -3);
			ctx.closePath();
			//ctx.clip();//剪裁
			var pp = ctx.createPattern(image, 'repeat');
			ctx.fillStyle = pp;
			ctx.drawImage(this, x, y, w, h, x, y, 0, 0);
			ctx.stroke()
			ctx.fill();
			
		    ctx.lineWidth = 2;
			ctx.drawImage(lineImage, x + 20, y + 52, 70, 2);
			
			ctx.fillStyle = color;
			drawText(ctx, label1, 'normal 13px Microsoft YaHei', x + (110 - 70)/2, y + 100/2 - 2, 70);
			drawText(ctx, label2, 'normal 13px Microsoft YaHei', x + (110 - 70)/2, y + 100/2 + 16, 70);
		}
	}
}


//----------------------------------------

function loadImage(source, callback) {
		var image = new Image();
		image.src = source;
		image.onload = callback;
	}
	
/**
 * @param a 弧形的前一个或者后一个点
 * @param b 弧形中心点
 * 
 * -----
 */
function calCenterPoint(a, b) {
	var point = new Point();
	if (a.x == b.x) {
		var t_y = Math.abs((a.y - b.y))/2;
		if (a.y > b.y ) {
		
			if (a.y - b.y <= 10) {
				point = new Point(a.x, a.y - t_y);
			} else {
				point = new Point(a.x, b.y + 10);
			}
		} else {
			if (b.y - a.y <= 10) {
				point = new Point(a.x, a.y + t_y);
			} else {
				point = new Point(a.x, b.y - 10);
			}
			//point = new Point(a.x, b.y - 10);
		}
	} else if (a.y == b.y) {
		var t_x = Math.abs((a.x - b.x))/2;
		if (a.x > b.x ) {
			if (a.x - b.x <= 10) {
				point = new Point(a.x - t_x, b.y);
			} else {
				point = new Point(b.x + 10, b.y);
			}
		} else {
			if (b.x - a.x <= 10) {
				point = new Point(a.x + t_x, b.y);
			} else {
				point = new Point(b.x - 10, b.y);
			}
		}				
	}
	return point;
}

		
/**
 * 根据起点坐标与结束节点坐标画箭头,
 */
function drawArrow(ctx, sp, ep) {
	//var linecolor:uint = this._color;
	var radius = 5;
	var tmpx=ep.x - sp.x;
	var tmpy=ep.y - sp.y;
	
	var angle= Math.atan2(tmpy,tmpx)*(180/Math.PI);
	
	var centerX = ep.x - radius * Math.cos(angle*(Math.PI/180));
	var centerY = ep.y - radius * Math.sin(angle*(Math.PI/180));
	var topX = ep.x;
	var topY = ep.y;
	var leftX = centerX + radius * Math.cos((angle+120)*(Math.PI/180));
	var leftY = centerY + radius * Math.sin((angle+120)*(Math.PI/180));
	var rightX = centerX + radius * Math.cos((angle+240)*(Math.PI/180));
	var rightY = centerY + radius * Math.sin((angle+240)*(Math.PI/180));
	
	ctx.moveTo(topX,topY);
	ctx.lineTo(leftX,leftY);
	ctx.lineTo(centerX,centerY);
	ctx.lineTo(rightX,rightY);
	ctx.lineTo(topX,topY);
	
}


function drawText(cxt, text, style, x, y, maxWidth) {
	var temp_text = text; 
	cxt.font = style; 
	var met = cxt.measureText(temp_text); 
	
	if (met.width > maxWidth) {
		while (met.width + 3 >= maxWidth) {
			temp_text = temp_text.substring(0, temp_text.length - 1);
			met = cxt.measureText(temp_text); 
		}
		temp_text += "...";
	} else if (met.width < maxWidth) {
		while (met.width < maxWidth) {
			temp_text = " " + temp_text + " ";
			met = cxt.measureText(temp_text); 
		}
	}
	// met.width 即为绘制后文字的宽度 
	cxt.fillText(temp_text, x, y, maxWidth); 
}

function getTextHeight(text) {
	
	var lineHeight = 15;
	
	return text.length*15;
	/*
	for ( var int = 0; int < text.length; int++) {
		
	}
	*/
}

function drawText2(cxt, text, style, x, y, maxWidth) {
	var temp_text = text; 
	cxt.font = style; 
	var met = cxt.measureText(temp_text); 
	if (getTextHeight(temp_text) > maxWidth) {
		while (getTextHeight(temp_text) + getTextHeight("...") >= maxWidth) {
			temp_text = temp_text.substring(0, temp_text.length - 1);
		}
		temp_text += "...";
	} else if (getTextHeight(temp_text) < maxWidth) {
		while (getTextHeight(temp_text) < maxWidth) {
			temp_text = " " + temp_text + " ";
		}
	}
	
	for (var i=0; i<temp_text.length; i++) {
		cxt.fillText(temp_text[i], 5, y + i*15, maxWidth); 
	}
	// met.width 即为绘制后文字的宽度 
	
}

function drawText4H(cxt, text, style, x, y, maxWidth) {
cxt.rotate(-90);
	var temp_text = text; 
	cxt.font = style; 
	var met = cxt.measureText(temp_text); 
	
	if (met.width > maxWidth) {
		while (met.width + 3 >= maxWidth) {
			temp_text = temp_text.substring(0, temp_text.length - 1);
			met = cxt.measureText(temp_text); 
		}
		temp_text += "...";
	} else if (met.width < maxWidth) {
		while (met.width < maxWidth) {
			temp_text = " " + temp_text + " ";
			met = cxt.measureText(temp_text); 
		}
	}
	// met.width 即为绘制后文字的宽度 
	cxt.fillText(temp_text, x, y, maxWidth); 
}
//--------------------------------------------------------------------------

/*

function drawImageClip() {
	Ca();
	var canvas = draw();
	var image = new Image();
	canvas.save();//保存当前画布
	image.onload = function () {
		canvas.beginPath();
		canvas.arc(220, 100, 100, 0, 2 * Math.PI, true);//创建圆形剪裁路径
		canvas.clip();//剪裁
		canvas.drawImage(image, 180, 20, 100, 60, 50, 25, 379, 80);
	};
	image.src = "_image_wev8.png";
}

*/

function dottedLine(x, y, x2, y2, dotArray, lineWidth, ctx){
	ctx.lineWidth = lineWidth;
    ctx.lineCap = 'round';
    ctx.beginPath();
    var context   = ctx || this,
        dashCount = dotArray.length,
        dx = (x2 - x), dy = (y2 - y),
        xSlope = dx > dy,
        slope = (xSlope) ? dy / dx : dx / dy;
    if(slope > 9999) {
        slope = 9999;
    }
    else if(slope < -9999) {
        slope = -9999;
    }
    var distRemaining = Math.sqrt(dx * dx + dy * dy);
    var dashIndex = 0, draw = true;
    while(distRemaining >= 0.1 && dashIndex < 10000) {
        var dashLength = dotArray[dashIndex++ % dashCount];
        if(dashLength === 0) {
            dashLength = 0.001;
        }
        if(dashLength > distRemaining) {
            dashLength = distRemaining;
        }
        var step = Math.sqrt(dashLength * dashLength / (1 + slope * slope));
        if(xSlope) {
            x += dx < 0 && dy < 0 ? step * -1 : step;
            y += dx < 0 && dy < 0 ? slope * step * -1 : slope * step;
        } else {
            x += dx < 0 && dy < 0 ? slope * step * -1 : slope * step;
            y += dx < 0 && dy < 0 ? step * -1 : step;
        }
        context[draw ? 'lineTo' : 'moveTo'](x, y);
        distRemaining -= dashLength;
        draw = !draw;
    }
    context.moveTo(x2, y2);
    
    context.closePath();
	context.stroke();
}

function drawCurve(aPoint, bPoint, cPoint, cxt) {
	cxt.lineWidth = 2;
	cxt.beginPath();
	cxt.moveTo(aPoint.x, aPoint.y);
	cxt.bezierCurveTo(aPoint.x, aPoint.y, bPoint.x, bPoint.y, cPoint.x, cPoint.y);
	cxt.stroke();
}

function dashRect(x, y, width, height, rectname, context) {
    var spacerLength = 15;
	var curveLength = 10
	var x1 = x + width;
	var y1 = y + height;
	
    dottedLine(x + spacerLength - 10, y, x1 - spacerLength, y, [10, 5] ,2, context);
	dottedLine(x + spacerLength - 10, y1, x1 - spacerLength, y1, [10, 5] ,2, context);
	dottedLine(x, y + spacerLength - 10, x, y1 - spacerLength, [10, 5] ,2, context);
	dottedLine(x1, y + spacerLength - 10, x1, y1 - spacerLength, [10, 5] ,2, context);
	
	drawCurve(new Point(x + curveLength, y), new Point(x, y), new Point(x, y + curveLength) ,context);
	drawCurve(new Point(x1 - curveLength, y), new Point(x1, y), new Point(x1, y + curveLength) ,context);
	drawCurve(new Point(x, y1 - curveLength), new Point(x, y1), new Point(x + curveLength, y1) ,context);
	drawCurve(new Point(x1, y1 - curveLength), new Point(x1, y1), new Point(x1 - curveLength, y1) ,context);
	
	drawText(context, rectname, 'normal 13px Microsoft YaHei', x, y + 15, width);
}

function drawBlock(dir, x, y, width, height, blockName, cxt) {
	cxt.strokeStyle = "#B7BABC";
	cxt.lineWidth = 1;
	//cxt.fillStyle = "#ffffff";
	cxt.beginPath();
	cxt.moveTo(x, y);
	if (dir == 0) {
		cxt.strokeRect(x, y, 30, height);
	} else {
		cxt.strokeRect(x, y, width, 30);
	}
	cxt.closePath();
	cxt.stroke();
	
	if (dir == 0) {
		dottedLine(x, y + height, x+width, y + height, [10, 5] ,1, cxt);
		dottedLine(x, y, x + width, y, [10, 5] ,1, cxt);
		drawText2(cxt, blockName, 'normal 13px Microsoft YaHei', x, y+20, height - 20);
	} else {
		dottedLine(x + width, y, x+width, y + height + 100, [10, 5] ,1, cxt);
		dottedLine(x, y, x, y + height + 100, [10, 5] ,1, cxt);
		drawText(cxt, blockName, 'normal 13px Microsoft YaHei', x, y + 20, width);
	}
}
