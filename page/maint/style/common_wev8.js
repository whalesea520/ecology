//切换美化checkbox是否选中
function changeCheckboxStatus4tzCheckBox(obj, checked) {
	//jQuery(obj).attr("checked", checked);
	if (obj.checked) {
		jQuery(obj).next("span.tzCheckBox").addClass("checked");
		jQuery(obj).next("span.jNiceCheckbox").addClass("jNiceChecked");
	} else {
		jQuery(obj).next("span.tzCheckBox").removeClass("checked");
		jQuery(obj).next("span.jNiceCheckbox").removeClass("jNiceChecked");
	}
}
//切换美化radio是否选中
function changeRadioStatus4tzRadio(obj, checked) {
	//jQuery(obj).attr("checked", checked);
	if (obj.checked) {
		jQuery(obj).next("span.jNiceRadio").addClass("jNiceChecked");
	} else {
		jQuery(obj).next("span.jNiceRadio").removeClass("jNiceChecked");
	}
}
//切换美化checkbox是否只读
function disOrEnableCheckbox4tzCheckBox(obj, disabled) {
	jQuery(obj).attr("disabled", disabled);
	if(!disabled){
		jQuery(obj).attr("disabled","");
		jQuery(obj).removeAttr("disabled");
	}
}

var reg = /^#([0-9a-fA-f]{3}|[0-9a-fA-f]{6})$/;
/*RGB颜色转换为16进制*/
String.prototype.colorHex = function(){
	var that = this;
	if(/^(rgb|RGB)/.test(that)){
		var aColor = that.replace(/(?:\(|\)|rgb|RGB)*/g,"").split(",");
		var strHex = "#";
		for(var i=0; i<aColor.length; i++){
			var hex = Number(aColor[i]).toString(16);
			if (hex.length == 1) {
				hex = "0" + hex;
			}
			strHex += hex;
		}
		if(strHex.length !== 7){
			strHex = that;	
		}
		return strHex;
	}else if(reg.test(that)){
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

	function  generateCss1(r_id,r_attr,color){
		var sheet = $("#divContainer").find("style")[0].sheet;
		var theRules;
		if (sheet.cssRules)
			theRules = sheet.cssRules
		else if (sheet.rules)
			theRules = sheet.rules
		//alert(theRules)
		var isheadovercheck=false;
		var hasfonthover=false,hasheadhover=false;
		if($("input[name='isbgcolopen']").get(0)!=undefined){
			isheadovercheck=$("input[name='isbgcolopen']").get(0).checked;
		}
		//底边颜色开关
        var isbtcolcheck=false;
		if($("input[name='isbtcolopen']").get(0)!=undefined){
			isbtcolcheck=$("input[name='isbtcolopen']").get(0).checked;
		}
		var addflag=false;	
		
		for( i=0;i<theRules.length;i++){
			var rule = theRules[i];
			var selector= rule.selectorText //选择器
			var value=rule.cssText;
			var replaceStr = "#item_"+styleid+" ";
			selector = selector.replace(new RegExp(replaceStr,'gm'),'');
			//alert(selector);
			
			if(r_id==='font_hover'){
				if(selector==='.font:hover'  &&  color!==''){
					hasfonthover=true;
					rule.style.setProperty('color',color,"important");
					//break;
				}else if(selector==='.font:hover'  &&  color==='')
					//alert(2);
					//alert(rule.style.color);
					rule.style.setProperty('color',"","");
					//break;
		  }
		  
		  	if(r_id==='font'){
		  		if(selector==='.font'  &&  color!==''){
		  			rule.style.setProperty('color',color,"important");
		  			//break;
		  		}
		  		
		  	}
		  if(r_id==='head_hover'){
				if(selector==='.header:hover' &&  color!==''){
					hasheadhover=true;
					rule.style.setProperty('background-color',color,"important");
					//alert(3);
					//alert(rule.style.backgroundColor);
					//break;
				}else if(selector==='.header:hover' &&  color===''){
					//alert(4);
					rule.style.setProperty('background-color',"","");
					//continue;
					//break;
			}
					
			}
			//如果鼠标背景色开关关闭,则直接继续
			if(selector==='.header:hover' && !isheadovercheck){
				//alert(5);
				//alert(rule.style.backgroundColor);
				rule.style.setProperty('background-color',"","");
			   //break;
			}
			
			if(r_id==='title'){
				if(selector==='.title'  &&  color!==''){
					//alert(r_attr+"$"+color);
			  		rule.style.setProperty(r_attr,color,"important");
			  		//$("#divContainer").find("style")[0].sheet.cssRules[i].style.setProperty("border-bottom-width","0","");
			  		//break;
				}
			}
		}
		
		if(!hasfonthover){
			generateCss();
			if($("#css").val().indexOf(".font:hover")<0){
		    	$("#divContainer").find("style").text($("#css").val()+" \n .font:hover{  color:"+color+"!important; }")
			}
		}
		

		//若无改设置,则添加标题栏鼠标样式设置
		if(!hasheadhover  && isheadovercheck===true){
			generateCss();
			if($("#css").val().indexOf(".header:hover")<0){
				$("#divContainer").find("style").text($("#css").val()+" \n .header:hover{  background-color:"+color+"!important; }")
			}
		  	/*write(".header:hover{");
            write("  background-color:"+color+";");
		    write("}");		*/
		}
	
		
		
		//generateCss();
	}
	
	//保存样式方法
	function generateCss(){
		$("#css").val("");
		if(true){
				$("#css").val("");
				var replaceStr = "#item_"+styleid;
				
				var sheet = $("#divContainer").find("style")[0].sheet;
				var theRules;
				if (sheet.cssRules)
					theRules = sheet.cssRules
				else if (sheet.rules)
					theRules = sheet.rules
				for( i=0;i<theRules.length;i++){
						var rule = theRules[i];
						var value=rule.cssText;
						var http="http://"+window.location.host+""
						$("#css").val($("#css").val()+value.replace(new RegExp(replaceStr,'gm'),'').replace(new RegExp(';','gm'),';\n').replace(new RegExp('{','gm'),'{\n').replace(new RegExp('}','gm'),'}\n').replace(new RegExp(http,'gm'),''));
				}
				//$("#css").val($("#divContainer").find("style").text().replace(new RegExp(replaceStr,'gm'),''));
				return;
		}
		var str=$("#cssBak").val();
		str=str.replace(/(\r|\n)+/g,"");
		var re = /(.*?){(.*?)}/g;
		var arr;
		var index=0;
		//鼠标背景色是否开启
		var isheadovercheck=false;
		if($("input[name='isbgcolopen']").get(0)!=undefined){
			isheadovercheck=$("input[name='isbgcolopen']").get(0).checked;
		}
		//底边颜色开关
        var isbtcolcheck=false;
		if($("input[name='isbtcolopen']").get(0)!=undefined){
			isbtcolcheck=$("input[name='isbtcolopen']").get(0).checked;
		}
		var addflag=false;

		//新增的三种设置
		var hasfonthover=false,hasheadhover=false;
		while ((arr = re.exec(str)) != null){
			var selector= $.trim(arr[1]); //选择器
			var value=arr[2]; //值
			if(selector==='.font:hover'  &&  value!==''){
				hasfonthover=true;
			}else if(selector==='.font:hover'  &&  value==='')
				 continue;
			if(selector==='.header:hover' &&  value!==''){
				hasheadhover=true;
			}else if(selector==='.header:hover' &&  value==='')
				continue;
			
			//如果鼠标背景色开关关闭,则直接继续
			if(selector==='.header:hover' && !isheadovercheck){
			   continue;
			}
			

			write(selector+"{");
			
			jQuery.each(value.split(";"),function(i,field){
				field=$.trim(field);
				if(field!=""){
					var pos=field.indexOf(":");
					field=$.trim(field.substring(0,pos));
					//如果鼠标背景色开关关闭,则直接继续
					
					writeAttr(selector,field,index);
					if(selector==='.title' && !isbtcolcheck  && !addflag ){
					    write("border-bottom-width:0px !important;");
						addflag=true;
					}else if(selector==='.title' && isbtcolcheck && field==='border-bottom-width'){
					     write("border-bottom-width:2px;");
					}
				}
			});

			if(selector==='.title' && isbtcolcheck){
				//添加底边设置属性
				if(value.indexOf("border-bottom-width")<0){
				   write("border-bottom-width:2px;");
				}
				if(value.indexOf("border-bottom-style")<0){
				   write("border-bottom-style:solid;");
				}
				if(value.indexOf("border-bottom-color")<0){
				   write("border-bottom-color:"+$("#border_bottom_color").html()+";");
				}
				
			}
			
		

            write("}");		
			index++;
		}
		//若无改设置,则添加字体鼠标样式设置
		if(!hasfonthover){
		  	write(".font:hover{");
            write("  color:"+$("#font_hover").html()+"!important;");
		    write("}");		
		}
		

		//若无改设置,则添加标题栏鼠标样式设置
		if(!hasheadhover  && isheadovercheck===true){
		  	write(".header:hover{");
            write("  background-color:"+$("#head_hover").html()+"!important;");
		    write("}");		
		}

	}
	
	function RGBToHex(rgb){ 
	   var regexp = /[0-9]{0,3}/g;  
	   var re = rgb.match(regexp);//利用正则表达式去掉多余的部分，将rgb中的数字提取
	   var hexColor = "#"; var hex = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'];  
	   for (var i = 0; i < re.length; i++) {
			var r = null, c = re[i], l = c; 
			var hexAr = [];
			while (c > 16){  
				  r = c % 16;  
				  c = (c / 16) >> 0; 
				  hexAr.push(hex[r]);  
			 } hexAr.push(hex[c]);
			 if(l < 16&&l != ""){        
				 hexAr.push(0)
			 }
		   hexColor += hexAr.reverse().join(''); 
		}  
	   //alert(hexColor)  
	   return hexColor;  
	}  

    function toHex(value){
       var items;
      if(value.indexOf("rgb")>=0){
	     value=RGBToHex(value);
       }
       return value;
    } 
    
	function writeAttr(classid,attr,index){
		try		{
			var value="";
 
			if(attr=="font-weight"){ //特殊处理
				
				var posBegin=classid.lastIndexOf(".");
				var tempClassid=classid.substring(posBegin+1);
				//alert("tempClassid:"+tempClassid)mm
				
				if($(".font-weight[r_id="+tempClassid+"]")[0].checked){
					value="bold";
				} else {
					value="normal";
				}	
				
			}  else if(classid==".header" && attr=="width"|| classid==".content" &&  attr=="width"){
				value="100%";
			}else {
				var pos=classid.indexOf(":hover");
				if(pos!=-1){
					
					 if(classid==='.font:hover'){
                         var hovercol=$("#font_hover").html();
					     value =  hovercol+"!important";
					 }else if(classid==='.header:hover'){
					     var hovercol=$("#head_hover").html();
					     value =  hovercol+"!important";
					 }else{

						//alert(index)
						var ruleId=index;
						var attrScript=getScriptStyleString(attr);
						var styleMenu=document.getElementById("styleMenu");
						var oStyleSheet=document.getElementById("styleMenu").styleSheet||document.getElementById("styleMenu").sheet;
						var rules=oStyleSheet.rules||oStyleSheet.cssRules;
						value=eval("rules["+ruleId+"].style."+attrScript);
						if(attr=='color'||attr=='font-family'){
							if(value.indexOf("important")<0){
								value =  value+"!important";
							}
						}
						var posTemp=value.indexOf("url(");
						if(posTemp!=-1){
							var posTemp2=value.indexOf(")",posTemp);
							if(posTemp2!=-1){
								value=value.substring(posTemp+4,posTemp2);
							}
							value="url("+value+")";
						}
					 }
                //字体设置
				} else if(classid==='.font'  &&  attr=='color' ){
				
				     value =  $("#font_color").html()+"!important";
				}else{		
					if(classid==='.toolbar'){
			             value=$(" .item "+classid).css(attr);	
			         }else{
					     value=$(classid).css(attr);
						 if(classid==='.title' &&  attr==='border-bottom-color'){
							 value=toHex(value);
						 }
					 }   
					if(attr=='color'||attr=='font-family' || attr==='border-bottom-color'){
						value =  value+"!important";
					}
					
				}
			}

			//以下消除image相关的http部分
			var pos=value.indexOf("http://");
			if(pos!=-1){
				var pos2=value.indexOf("/",pos+7);
				if(pos!=-1) value=value.substring(0,pos)+value.substring(pos2);
			}
			if("0"==(value+"").indexOf("rgb")){
				//alert(value)
				if(value.indexOf("important")>-1){
					value= value.replace("!important","");
					value =  value.colorHex();
					value = value+"!important";
				}else{
					value = value.colorHex();
				}
			
				//alert("￥"+value)
			}
			write("	"+attr+":"+value+";");
		}
		catch (e){			
			//alert("|"+classid+"|:|"+attr+"|"+"|"+e)
		}
		
	}
	function write(str){
		//alert($("#css").val()+"\n"+str);
		$("#css").val($("#css").val()+"\n"+str);
	}

	String.prototype.endWith=function(str){   
		if(str==null||str==""||this.length==0||str.length>this.length)   
		  return false;   
		if(this.substring(this.length-str.length)==str)   
		  return true;   
		else   
		  return false;   
		return true;   
	};
	
	function ItemCount_KeyPress()
{
	var evt = getEvent();
	var keyCode = evt.which ? evt.which : evt.keyCode;
 if(!(((keyCode>=48) && (keyCode<=57))|| keyCode==45))
  {
     if (evt.keyCode) {
     	evt.keyCode = 0;evt.returnValue=false;     
     } else {
     	evt.which = 0;evt.preventDefault();
     }
     
	 
	 
  }
} 
	$(document).ready(function(){

			//以下处理所有spin插件
			$('input.spin').bind("keypress",ItemCount_KeyPress);
			$('input.spin').spin({min:1, max:100,imageBasePath:'/js/jquery/plugins/spin/'});	

			//以下处理所有filetree插件
			$(".filetree").each(function(){
				var r_id=$(this).attr("r_id");
				var r_attr=$(this).attr("r_attr");
				var value="";
				if(r_id!=null){
					if(r_attr=="src"){
						value=$("."+r_id).attr("src");

						if(value==undefined) value="none";
						var pos=value.indexOf("http://");			
						
						if(pos!=-1) {
							var pos2=value.indexOf("/",pos+7);							
							value=value.substring(pos2);
							//alert(value)
						}
					} else {
						value=getScriptStyleValue(r_id,r_attr);
						
						var posTemp=value.indexOf("url(");
						if(posTemp!=-1){
							var posTemp2=value.indexOf(")",posTemp);
							if(posTemp2!=-1){
								value=value.substring(posTemp+4,posTemp2);
							}
						}
						
						
						var pos=value.indexOf("http://");			
						
						if(pos!=-1) {
							var pos2=value.indexOf("/",pos+7);							
							value=value.substring(pos2);
							//alert(value)
						}
						if(value==undefined) value="none";
						 pos=value.indexOf("//");							
						if(pos!=-1) {
							
							var pos2=value.indexOf("/",pos+2);
							var pos3=value.indexOf("\")",pos2);
							value=value.substring(pos2,pos3);
						}
					}

				}
				value=value.replace(/"/g, "");
				if(value.endWith("none")){
					value = "";
				}
				this.value=value;
				$(this).filetree({
					file:value,
					call:function(src){
							if(r_attr=="src"){
								$("."+r_id).attr("src",src);
							}else {
								if(src == ""){
									setScriptStyleValue(r_id,r_attr,"");
								}else{
									setScriptStyleValue(r_id,r_attr,"url('"+src+"')");
								}
								
								//$("."+r_id).css(r_attr,"url('"+src+"')");
							}
					}
				});
				$(this).bind("change",function(){
					if($(this).val() == ""){
						setScriptStyleValue(r_id,r_attr,"");
					}
				});
			});
			
			var language = readCookie("languageidweaver");
			//以下处理所有color插件
				
			
            //设置颜色
            function  setColor(obj,piccolor){
				   
				    var currentSetSpan=obj.prev();
					var value=piccolor;
					var color=piccolor;
				
					currentSetSpan.text(value);
					currentSetSpan.css("background-color",value);
					//currentSetSpan.css("color",color==""?"#fff":color);
					
					//alert($("#"+objFormId).html())

					var r_id=currentSetSpan.attr("r_id");
					var r_attr=currentSetSpan.attr("r_attr");
				   
					if(r_id==='head_hover'){
						 generateCss1(r_id,"background-color",value);
						 //$("#divContainer").find("style").html($("#css").val());
						 return;
					}else if(r_id==='font_hover'){
						 generateCss1(r_id,"color",value);
						// $("#divContainer").find("style").html($("#css").val()); 
						return;
					}else if(r_id==='font'){
						 generateCss1(r_id,"color",value);
						// $("#divContainer").find("style").html($("#css").val());
						  return;
					}else if(r_id==='title' && r_attr==='border-bottom-color'){
							  if($("input[name='isbtcolopen']").get(0).checked){
							  	  //$(".title").css('border-bottom-width','0px');
								 // $(".title").css('border-bottom-color',$("#border_bottom_color").html());
							  	   generateCss1(r_id,"border-bottom-width","2px");
							  	  generateCss1 (r_id,"border-bottom-style","solid");
								   generateCss1(r_id,"border-bottom-color",$("#border_bottom_color").html());
								  //generateCss1("title","")
							  }else{
							 		 //$(".title").css('border-bottom-style','none');
							 		  generateCss1(r_id,"border-bottom-width","0");
							 		  
							  }
							  //generateCss1(r_id,"color",value);
							 // $("#divContainer").find("style").html($("#css").val());
							 return;
						 
					}
					
					setScriptStyleValue(r_id,r_attr,value);			
			}

			$(".colorblock").each(function(){				
				    
				var r_id=$(this).attr("r_id");
				var r_attr=$(this).attr("r_attr");
				var color="#ffffff";
				if(r_id!=null){
					if(r_id==='font_hover'){
					   color=getHoverColor('.font:hover','color'); 
					   
					}else if(r_id==='head_hover'){
					   color=getHoverColor('.header:hover','background-color'); }
					 else if(r_id==='title' &&  r_attr==='border-bottom-color'){
					   color=getHoverColor('.title','border-bottom-color');   
					 }else
					 color=getScriptStyleValue(r_id,r_attr);
				}
				color=$.trim(color);
				if(color.indexOf("rgb")>-1){
					color =color.colorHex();
				}
				$(this).text(color);							
				$(this).css("background-color",color);
				
				var colorpic=$("<img src='/js/jquery/plugins/farbtastic/color_wev8.png' style='cursor:hand;margin-left:5px'  border=0/>");
                $(this).after(colorpic);
                
  
                colorpic.spectrum({
					showPalette:true,
					showInput:true,
					allowEmpty:false,
					preferredFormat: "hex",
					chooseText:SystemEnv.getHtmlNoteName(3451,language),
					cancelText:SystemEnv.getHtmlNoteName(3516,language),
					color:color,
					noclickhide:true,
					hide: function(color) {
	                		color = color.toHexString(); // #ff0000
							setColor(colorpic,color);
					},
					move: function(color) {
						    //console.dir(this);
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



				//$(this).after("<img src='/js/jquery/plugins/farbtastic/color_wev8.png' style='cursor:hand;margin-left:5px'  onclick='doColorClick(this,event)' border=0/>"); 

				if(color=="transparent") {
					//this.parentNode.style.visibility='hidden';
					$(this).text("#ffffff");
				}

				$(this).width(60);
			});	
			
			////以下处理所有背景透明的checkbox框
			$(".transparent").each(function(){
				var t_id=$(this).attr("t_id");
				var tObj=$("#"+t_id)[0];
			
				//if(tObj==undefined) break;
				var r_id=$(tObj).attr("r_id");
				var r_attr=$(tObj).attr("r_attr");

				var color="#ffffff";
				if(r_id!=null){
					color=$("."+r_id).css(r_attr);
				}
				
				//alert(color)
				if(color=="transparent") this.checked=true;

				$(this).bind("click", function(){
				  //得到所关联的对像
				  var t_id=$(this).attr("t_id");
				  var tObj=$("#"+t_id)[0];
				  var r_id=$(tObj).attr("r_id");
				  var r_attr=$(tObj).attr("r_attr");

				  if(this.checked==true){ //透明					
					$("."+r_id).css(r_attr,"transparent");//设置背景
					tObj.parentNode.style.visibility='hidden';
				  } else {//非透明
					$("."+r_id).css(r_attr,$(tObj).text());//设置背景
					$(tObj).parent()[0].style.visibility='visible';
				  }
				}); 
			});


			//字体加粗
			$(".font-weight").each(function(){
				var r_id=$(this).attr("r_id");
				var r_attr=$(this).attr("r_attr");
				var cValue=getScriptStyleValue(r_id,r_attr);
						
				//alert(cValue)
				if(cValue=="700" || cValue=="bold") this.checked=true;

				changeCheckboxStatus4tzCheckBox(this, this.checked);

				$(this).bind("click",function(){
					//alert(this.checked)
					if(this.checked)
						setScriptStyleValue(r_id,r_attr,"700");						
					else 
						setScriptStyleValue(r_id,r_attr,"400");
				});	
			});
			
			//字体样式
			$(".font-style").each(function(){
				var r_id=$(this).attr("r_id");
				var r_attr=$(this).attr("r_attr");
				var cValue=getScriptStyleValue(r_id,r_attr);
				cValue=$.trim(cValue);

				if(cValue=="italic") this.checked=true;

				changeCheckboxStatus4tzCheckBox(this, this.checked);
				
				$(this).bind("click",function(){
					if(this.checked)
						setScriptStyleValue(r_id,r_attr,"italic");							
					else 
						setScriptStyleValue(r_id,r_attr,"normal");
				});


			});	
            
			  //添加字体下边框checkbox	
			  $("input[name='isbtcolopen']").each(function(){
				  var current=$(this);
				  var btchecktitle=$("#border_bottom_color");
				  if(btchecktitle.html()!=='#ffffff' && $(".title").css("border-bottom-width")!=='0px'){
					  this.checked=true;
					  changeCheckboxStatus4tzCheckBox(this,true); 
				  }
				   current.bind("click",function(){
				     var colorobj = $(current).parents(".fieldName:first").find(".colorblock");
					  setColor(colorobj.next(),colorobj.text());
					 //  $("#divContainer").find("style").html($("#css").val());
				   
				  });
			   });	

			 $("input[name='isbgcolopen']").each(function(){
				  var current=$(this);
				  var btchecktitle=$("#head_hover").html();
				  if(getRuleStyleCssText("header:hover")!=''){
					  this.checked=true;
					  changeCheckboxStatus4tzCheckBox(this,true); 
				  }
				   current.bind("click",function(){
					   var colorobj = $(current).parents(".fieldName:first").find(".colorblock");
					  setColor(colorobj.next(),colorobj.text());
				       //$("#divContainer").find("style").html($("#css").val());
				   });
			   });	


			$(".line-style").each(function(){
				var r_id=$(this).attr("r_id");
				var r_attr=$(this).attr("r_attr");
				var cValue=$("."+r_id).css(r_attr);
				cValue=$.trim(cValue);
				for(var i=0;i<this.children.length;i++){
					var span_child=this.children[i];
					var child = $(span_child).find("input")[0];
					
					$(span_child).bind("click",function(){
						$("."+r_id).css(r_attr,$(this).find("input").val());
						setSheetStyle(r_id,r_attr,$(this).find("input").val(),'important');
					});

					if(child.value==cValue){
						child.checked=true;
						//$(child).trigger("click");
					}
					
					changeRadioStatus4tzRadio(child, child.checked);
					
				}
			});

			$(".height").each(function(){
				var r_id=$(this).attr("r_id");
				var r_attr=$(this).attr("r_attr");
				var cValue=getScriptStyleValue(r_id,r_attr);
				cValue=$.trim(cValue);
				
				if(cValue=="medium"){
					cValue=3; 
				} else {
					var tempPos=cValue.indexOf("px");
					if(tempPos!=-1) cValue=cValue.substring(0,tempPos);		
				}
				
				this.value=cValue;
				$(this).bind("change",function(){
					//alert(r_id+"^"+r_attr+"$"+this.value)
					setScriptStyleValue(r_id,r_attr,this.value);
				});
				
			});
	});	

	//获取鼠标悬浮颜色
	function getHoverColor(classname,attr){
	     
		var str=$("#cssBak").val();
		str=str.replace(/(\r|\n)+/g,"");
		var re = /(.*?){(.*?)}/g;
		var arr,fieldname,val='#000000';
		var index=0;
		while ((arr = re.exec(str)) != null){
			var selector= $.trim(arr[1]); //选择器
			if(selector===classname){
				var value=arr[2]; //值	
			    jQuery.each(value.split(";"),function(i,field){
	    			field=$.trim(field);
					if(field!=""){
						var pos=field.indexOf(":");
						fieldname=field.substring(0,pos);
						if(fieldname===attr){
							val=$.trim(field.substring(pos+1));		
							pos=val.indexOf("!important");
							if(pos>0){
							   val=val.substring(0,pos);
							}
						}
					}
		    	});
                break;
		   }
	   }
       return val;
	}

	function getScriptStyleString(str){
		var returnStr=str;
		if(str=="font-size") returnStr="fontSize";
		else if(str=="font-family") returnStr="fontFamily";
		else if(str=="font-weight") returnStr="fontWeight";
		else if(str=="font-style") returnStr="fontStyle";
		else if(str=="background-color") returnStr="backgroundColor";
		else if(str=="background-image") returnStr="backgroundImage";		
		return returnStr;
	}
	function getScriptStyleValue(r_id,r_attr){
		var returnStr="";

		var pos=r_id.indexOf("rule");
		if(pos!=-1){
			r_attr=getScriptStyleString(r_attr);			
			var ruleId=r_id.substring(pos+4);
			var styleMenu=document.getElementById("styleMenu");
			var oStyleSheet=document.getElementById("styleMenu").styleSheet||document.getElementById("styleMenu").sheet;
			var rules=oStyleSheet.rules||oStyleSheet.cssRules;
			returnStr=eval("rules["+ruleId+"].style."+r_attr);
			
			var posTemp=returnStr.indexOf("url(");
			if(posTemp!=-1){
				var posTemp2=returnStr.indexOf(")",posTemp);
				if(posTemp2!=-1){
					returnStr=returnStr.substring(posTemp+4,posTemp2);
				}
			}			
			//alert("oStyleSheet.rules["+ruleId+"].style."+r_attr+":"+returnStr)
		} else {	
			if(r_attr=='color'||r_attr=='font-family'){
				returnStr =  returnStr+"!important";
			}
			returnStr=$("."+r_id).css(r_attr);
		}
			if("0"==(returnStr+"").indexOf("rgb")){
				returnStr=returnStr.colorHex();
			}
			return returnStr;
	}
	function setScriptStyleValue(r_id,r_attr,value){
		//alert(r_id)
		if(r_attr!="font-weight" && r_attr!="font-style"){
			if(!isNaN(value)&&value!=''){
					value=value+"px"
			}
		}
		var pos=r_id.indexOf("rule");
		if(pos!=-1){
			var ruleId=r_id.substring(pos+4);
			var styleMenu=document.getElementById("styleMenu");
			var oStyleSheet=document.getElementById("styleMenu").styleSheet||document.getElementById("styleMenu").sheet;
			var rules=oStyleSheet.rules||oStyleSheet.cssRules;
		
			$(rules[ruleId]).css('cssText',$(rules[ruleId])[0].style.cssText+";"+r_attr+':'+value+'!important');
		} else {
			if(r_id=="title"||r_id=="icon"||r_id=="toolbar"){
				if(""==value){
					//还原到页面的样式
					$("."+r_id).css("font-family","");
					//alert($("."+r_id).css('cssText'));
					$("."+r_id).css('cssText',$("."+r_id)[0].style.cssText+";"+r_attr+':'+value+'!important;position:absolute');
					//alert($("."+r_id).css('cssText'));
				}else{
					//alert(r_id)
					
					setSheetStyle(r_id,r_attr,value,'important');
					setSheetStyle(r_id,"position","absolute",'');	
					//$("."+r_id).css('cssText',$("."+r_id)[0].style.cssText+";"+r_attr+':'+value+'!important;position:absolute');
				}
			}else{
					//$("."+r_id).css('cssText',$("."+r_id)[0].style.cssText+";"+r_attr+':'+value+'!important;');
				//$("."+r_id).css(r_attr,value);
					setSheetStyle(r_id,r_attr,value,'important');
					//setSheetStyle(r_id,"position","absolute",'');	
			}
			
		}
		
		
	}
	
	function setSheetStyle(r_id,attr,value,important){
			var sheet = $("#divContainer").find("style")[0].sheet;
			var theRules;
			if (sheet.cssRules)
				theRules = sheet.cssRules
			else if (sheet.rules)
				theRules = sheet.rules
			
			for( i=0;i<theRules.length;i++){
					var rule = theRules[i];
					var selector= rule.selectorText //选择器
					var replaceStr = "#item_"+styleid+" ";
					selector = selector.replace(new RegExp(replaceStr,'gm'),'');
					//var value=rule.cssText;
					
					if(selector==="."+r_id){
						
						rule.style.setProperty(attr,value,important);
						
					}
			}
	}
	
	function getRuleStyleCssText(r_id){
			var sheet = $("#divContainer").find("style")[0].sheet;
			var theRules;
			if (sheet.cssRules)
				theRules = sheet.cssRules
			else if (sheet.rules)
				theRules = sheet.rules
			
			for( i=0;i<theRules.length;i++){
					var rule = theRules[i];
					var selector= rule.selectorText //选择器
					var replaceStr = "#item_"+styleid+" ";
					selector = selector.replace(new RegExp(replaceStr,'gm'),'');
					//var value=rule.cssText;
					
					if(selector==="."+r_id){
						
						return rule.style.cssText;
					}
			}
			
			return "";
	}
	

