
/*RGB颜色转换为16进制*/
String.prototype.colorHex = function(){
	var that = this;
	if(/^(rgb|RGB)/.test(that)){
		var aColor = that.replace(/(?:\(|\)|rgb|RGB)*/g,"").split(",");
		var strHex = "#";
		for(var i=0; i<aColor.length; i++){
			var hex = Number(aColor[i]).toString(16);
			if(hex === "0"){
				hex += hex;	
			}
			strHex += hex;
		}
		if(strHex.length !== 7){
			strHex = that;	
		}
		return strHex;
	}else if(/^#([0-9a-fA-f]{3}|[0-9a-fA-f]{6})$/.test(that)){
		var aNum = that.replace(/#/,"").split("");
		if(aNum.length === 6){
			return that;	
		}else if(aNum.length === 3){
			var numHex = "#";
			for(var i=0; i<aNum.length; i+=1){
				numHex += (aNum[i]+aNum[i]);
			}
			return numHex;
		}
	}else{
		return that;	
	}
};

//设置颜色
function  setColor(obj,piccolor){
    var currentSetSpan = jQuery(obj).prev();
    jQuery(currentSetSpan).text(piccolor);
    jQuery(currentSetSpan).css("background-color",piccolor);
}

function initColor(obj){
	var language = readCookie("languageidweaver");
	var defaultcolor = jQuery(obj).attr("defaultcolor");
	var color = defaultcolor || "#000000";
	jQuery(obj).text(color);							
	jQuery(obj).css("background-color",color);
	
	var colorpic=$("<img src='/js/jquery/plugins/farbtastic/color_wev8.png' style='cursor:pointer;margin-left:3px;vertical-align: middle;'  border=0/>");
    jQuery(obj).after(colorpic);

    colorpic.spectrum({
		//showPalette:true,
		showButtons:false,
		showInitial:true,
		showInput:true,
		allowEmpty:false,
		//showNoColorBtn:true,
		preferredFormat: "hex",
		chooseText:SystemEnv.getHtmlNoteName(3451,language),
		cancelText:SystemEnv.getHtmlNoteName(3516,language),
		//clearText:"清除",
		color:color,
		noclickhide:true,
		move: function(color) {
				color = color.toHexString(); // #ff0000
				setColor(colorpic,color);
				
		},
		palette: [
				["#000","#444","#666","#999","#ccc","#eee","#f3f3f3","#fff"],
				["#f00","#f90","#ff0","#0f0","#0ff","#00f","#90f","#f0f"],
				["#f4cccc","#fce5cd","#fff2cc","#d9ead3","#d0e0e3","#cfe2f3","#d9d2e9","#ead1dc"],
				["#ea9999","#f9cb9c","#ffe599","#b6d7a8","#a2c4c9","#9fc5e8","#b4a7d6","#d5a6bd"],
				["#e06666","#f6b26b","#ffd966","#93c47d","#76a5af","#6fa8dc","#8e7cc3","#c27ba0"],
				["#c00","#e69138","#f1c232","#6aa84f","#45818e","#3d85c6","#674ea7","#a64d79"],
				["#900","#b45f06","#bf9000","#38761d","#134f5c","#0b5394","#351c75","#741b47"],
				["#600","#783f04","#7f6000","#274e13","#0c343d","#073763","#20124d","#4c1130"]
		]
	});

	if(color=="transparent") {
		jQuery(obj).text("#ffffff");
	}

	//jQuery(obj).width(60);
}