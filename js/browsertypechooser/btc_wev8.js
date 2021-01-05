function BTC(){
	/*----------------和业务有关的公用函数Start-----------------*/
	if(!window.getBTC){
		if(!window.BTCArray){
			window.BTCArray=[];
		}
		window.getBTC=(function(){
			return new Function("id","for(var i=0;i<BTCArray.length;i++){if(BTCArray[i].id == id) return BTCArray[i]}");
		})()
	}
	var typeObj = function(type){
		return new Function('o', "return Object.prototype.toString.call(o)=='[object " + type + "]'");
	};
	var isObj = typeObj("Object");
	var isArray = typeObj("Array");
	var x;
	var initAjax = function(){
		try {  
		    x = new ActiveXObject("Msxml2.XMLHTTP");//IE高版本创建XMLHTTP  
		}catch(E) {  
		    try {  
		        x = new ActiveXObject("Microsoft.XMLHTTP");//IE低版本创建XMLHTTP  
		    }  
		    catch(E) {  
		        x = new XMLHttpRequest();//兼容非IE浏览器，直接创建XMLHTTP对象  
		    }  
		}  		  
		return x;
	}
	/*----------------和业务有关的公用函数End-----------------*/
	
	/*默认显示配置及用户当前配置*/
	var dftCfg = {
		id:(function(){
			return new Date().getTime();
		})(),
		renderTo: null, //选框依附位置
		headerURL:null, //标题栏地址
		contentURL:null, //内容地址
		autoLoadContent:true, //是否初始化时加载详细
		contentHeight:null, //详细区域最大高度
		contentHandler:null,//详细内容点击事件
		needAdjustPos:true, //是否需要自动调整位置
		splitNum:4 //详细内容每多少个分词换行
	},curCfg = {};
	
	var $btc = this;
	$btc.version="1.0";
	$btc.loaded = false;
	$btc.pubDate="2014-12-9",
	/**
		 * 存储所有子字段id
		 */
		$btc.itemids = [];
		/**
		 * 存储所有分组id
		 */
		$btc.groupids = [];
	
		/**
			 * 清空字段记忆
			 */
			$btc.reset = function(){
				$this.itemids = [];
				$this.groupids = [];
				itemnames =[],itemtops=[],groups=[]; 
			}
			
			/**
			 * 过滤重复id字段
			 */
			$btc.multifilter = function(id,o){
				for(var i=0;i<o.length;i++){
					if(o[i] == id){
						return false;
					}
				}
				o.push(id);
				return true;
			}
	$btc.apply=function(o,c,d){
		if(d){
			$btc.apply(o,d);
		}
		if(o&&c&&isObj(c)){
			for( var p in c){
				o[p] = c[p];
			}
		}	
		return o;
	};
	$btc.init=function(options){		
		$btc.apply(curCfg,options,dftCfg);
		$btc.apply(this,curCfg);
		window.BTCArray.push(this);
		var _html = ["<div class='btc_container' id='container_"+curCfg.id+"'>",
		             	"<div class = 'btc-header' style='background: #f5f5f5 !important;'>",
		             	   "<table class = 'btc-header-table'>",
		             	      "<colgroup>",
		             	        "<col width='70px'>",
		             	        "<col width='*'>",
		             	      "</colgroup>",
		             	      "<tr>",
		             	         "<td style='background: #f5f5f5 !important;'>",
				             		 "<ul class = 'btc-header-ul'>",
				             		    "<li onclick=javascript:getBTC('"+curCfg.id+"').contentAjaxHandler(this) class = 'btc-header-li li-highlight'>全部分类</li>",
				             	     "</ul>",
			             	      "</td><td style='background: #f5f5f5 !important;'>",
			             	         "<ul class = 'btc-header-ul' id='btc-header-ul"+curCfg.id+"'>",			             		   
			             	         "</ul>",
			             	      "</td>",
			             	  "</tr>",
		             	   "</table>",
		                "</div>",
		                "<div class = 'btc-browser' id='btc_"+curCfg.id+"'>",
		                "</div>",
		                "</div>"
		            ];
		curCfg.renderTo.append(_html.join(''));	
		if(!!curCfg.contentHeight){
			$("#btc_"+curCfg.id).css("max-height",curCfg.contentHeight);
		}
		$btc.headAjaxHandler();
	};
	$btc.resetPosition = function(){
		if(!curCfg.needAdjustPos){
		  return;
		}
		var $currBtc = $("#container_"+curCfg.id);
	    var left = $currBtc.offset().left;
	    var top = $currBtc.offset().top;
	    var width = $currBtc.width();
	    var height = $currBtc.height();
	    var winWidth = $(document.body).offset().left+$(document.body).width();
	    var winHeight = $(document.body).offset().top+$(document.body).height();
	    if(left+width > winWidth){
	       $currBtc.animate({
	         right:0
	       },500);
	    }
	    if(top+height>winHeight){
	       $("#btc_"+curCfg.id).animate({
	         maxHeight:winHeight-top-$(".btc-header").height()-50,
	         minHeight:70
	       },500);
	       $("#btc_"+curCfg.id).niceScroll();
	    }
	    if(window.width < $("#container_"+curCfg.id).width()){
	      $("#container_"+curCfg.id).width(window.width-5);
	    }
	}
	$btc.eventList=[];
	$btc.addEvent=(function(){
		return new Function("env","fn","obj","obj=obj||document;window.attachEvent?obj.detachEvent('on'+env,fn):obj.removeEventListener(env,fn,false);window.attachEvent?obj.attachEvent('on'+env,fn):obj.addEventListener(env,fn,false);this.eventList.push([env,fn,obj]);");
	})();//事件绑定
	$btc.detachEvent=(function(){
		return new Function('env','fn','obj',"obj=obj||document;window.attachEvent?obj.detachEvent('on'+env,fn):obj.removeEventListener(env,fn,false);");
	})(); //取消事件绑定
	$btc.clickHandler = function(event){
		var e = event || window.event;
		var $container = $("#container_"+curCfg.id);
        var mousePos = [e.clientX,e.clientY];
        var containPos = [$container.offset().left,$container.offset().top];
        var $height = $container.height();
        var $width = $container.width();
        if(mousePos[0]<containPos[0]||
        		mousePos[1]<containPos[1]||
        		mousePos[0]>containPos[0]+$width||
        		mousePos[1]>containPos[1]+$height){
        	$container.remove();
        }
	}
	$btc.remove = function(){
	    $("#container_"+curCfg.id).remove();
	}
	
	$btc.setContainerStyle = function(o,c){
	   var t,s;
	   if(isArray(o)&&isArray(c)){
	      while(t = o.shift()){
	        s=c.shift();
	        $("#container_"+curCfg.id).css(t,s);
	      }
	   }
	}
	
	$btc.headAjaxHandler=function(){
		if(!curCfg.headerURL){
			return;
		}
		x = initAjax();                                //创建XMLHttpRequest对象  
	    x.open("post", curCfg.headerURL, true);  
	    x.setRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=UTF-8");
	    x.onreadystatechange = function(){
	    	if (x.readyState == 4) {  
		        if (x.status == 200) {  
		            var json = eval('('+x.responseText+')');    
		            var vk = json.map;
		            if(!isArray(vk)){
		            	return;
		            }
		            var o;
		            while(o = vk.shift()){
	            		$("#btc-header-ul"+curCfg.id).append('<li onclick=javascript:getBTC('+curCfg.id+').contentFilter(this,"'+o.key+'") class = "btc-header-li">'+o.value+'</li>');
		            }
		            if(curCfg.autoLoadContent){
		            	$btc.contentAjaxHandler();
		            }
		        }  
		    }  
	    }; //指定响应函数  
	    x.send(null);  
	};
	$btc.contentAjaxHandler=function(){
		if(!curCfg.contentURL){
			return;
		}
		x = initAjax();                                 //创建XMLHttpRequest对象  
	    x.open("post", curCfg.contentURL, true);  
	    x.setRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=UTF-8");
	    x.onreadystatechange = function(){
	    	if (x.readyState == 4) {  
		        if (x.status == 200) {  
		        	$btc.itemids = [];
		        	$("#btc_"+curCfg.id).html('');
		            var json = eval('('+x.responseText+')');    
		            var kv = json.groups;
		            if(!isArray(kv)){
		            	return;
		            }
		            var o;
		            while(o = kv.shift()){
		            	var _html = [];
		            	if(kv.length == 0){
		            		_html.push('<div id=group_'+o.groupid+' class = "btc-browser-item btc-browser-lastitem">');
		            	}else{
		            		_html.push('<div id=group_'+o.groupid+' class = "btc-browser-item">');
		            	}            	
		            	_html.push('<table align="center">');
		            	_html.push('<colgroup><col width="62px"><col width="*"></colgroup><tr>');
		            	_html.push('<td class="btc-browser-item-theader" style="background: #fff !important;width:62px !important;border-bottom:0px !important;">');
		            	_html.push('<div class="btc-head-div" title='+o.groupname+'>');
		            	_html.push(o.groupname);
		            	_html.push('</div>');
		            	_html.push('<span class="btc-browser-item-theader-span">|</span>');
		            	_html.push('</td><td style="background: #fff !important;border-bottom:0px !important;">');
	            		var p;
	            		var m=0;
	            		var mark = o.items.length;
	            		while(p = o.items.shift()){
	            			if($btc.multifilter(p.key,$btc.itemids)==false){
										continue;
							}
	            
	            			if(m%curCfg.splitNum==0&&m != 0){
	            				_html.push('<br>');
	            			}else{
	            	
		            			if(o.items.length != mark-1){
		            				_html.push('<span class="split">|</span>');
		            			}
	            			}
	            			m++;
	            			_html.push('<span class="item-to-choose" onclick="javascript:getBTC('+curCfg.id+').contentHandler('+p.key+')">'+p.value+'</span>');	            
	            		}
	            		if(o.items.length == 0){
	            			_html.push("&nbsp;");
	            		}
	            		_html.push('</td></tr></table></div>');
	            		$("#btc_"+curCfg.id).append(_html.join(''));
	            		$("#btc_"+curCfg.id).niceScroll({
	            			cursorwidth:"5px",
	            			cursorcolor:"#3574d3",
	            			horizrailenabled:false
	            		});
		            }
		            $btc.resetPosition();
		            $btc.loaded = true;
		        }  
		    } 
	    }; //指定响应函数  
	    x.send(null);   
	};
	$btc.contentFilter=function(o,k){
		if($btc.loaded == false){
		   $btc.contentAjaxHandler();
		}
		$(".btc-header-li-current").removeClass("btc-header-li-current");
		$(o).addClass("btc-header-li-current");
		var timetask = setInterval(function(){
			if($btc.loaded == true){
			   $(".btc-browser-item").each(function(){
			        $(this).hide();
			   });
			   if(!!k){
			    $("#group_"+k).show();
			    $("#group_"+k).addClass("btc-browser-lastitem");
			   }else{
			   	$(".btc-browser-item").each(function(){
			   	    $(this).show();
			   	});
			   }
			   clearInterval(timetask);
			}
		},100);
	}
}