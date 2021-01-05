   (function($)
	{
		$.extend({
			mouseCoords:function(ev){
				if(ev.pageX || ev.pageY){
					return {x:ev.pageX, y:ev.pageY};
				}
				return {
					x:ev.clientX + document.body.scrollLeft - document.body.clientLeft,
					y:ev.clientY + document.body.scrollTop  - document.body.clientTop
				};
			},
			getStyle:function(obj,styleName)
			{
				return obj.currentStyle ? obj.currentStyle[styleName] : document.defaultView.getComputedStyle(obj,null)[styleName];
			}
		});		

		$.fn.dragDrop = function(options)
		{
			var opts = $.extend({},$.fn.dragDrop.defaults,options);

			return this.each(function(){
				var bDraging = false;   
				var moveEle = $(this);
				var focuEle = opts.focuEle ? $(opts.focuEle,moveEle) : moveEle ;
				if(!focuEle || focuEle.length<=0)
				{
					return false;
				}
				
				var dragParams = {initDiffX:'',initDiffY:'',moveX:'',moveY:''};  
				moveEle.css({'position':'absolute','z-index':'9999','left':0,'top':0});
				moveEle.css({'cursor':'move'});
				if(opts.follower){
					var containercord = opts.imgInnerCord;
					var imgtop = (containercord.height - opts.origalCord.height)/2;
					if(opts.origalCord){
						var newCord = {
							'position':'absolute', 
							'z-index':'9998', 
							'left':opts.origalCord.left + 'px', 
							'top':(opts.origalCord.top+imgtop) + 'px'
						};
						opts.follower.css(newCord);
						opts.follower.data("origalCord", newCord);//缓存初始位置
					}
				}
				focuEle.bind('mousedown',function(e){				
					
					bDraging = true;
					focuEle.css('cursor', 'move');
					if(moveEle.get(0).setCapture)
					{  
						moveEle.get(0).setCapture();  
					} 
					
					dragParams.initDiffX = $.mouseCoords(e).x - moveEle[0].offsetLeft;
					dragParams.initDiffY = $.mouseCoords(e).y - moveEle[0].offsetTop;
				});

				focuEle.bind('mousemove',function(e){
					if(bDraging)
					{	
						dragParams.moveX = $.mouseCoords(e).x - dragParams.initDiffX;
						dragParams.moveY = $.mouseCoords(e).y - dragParams.initDiffY;

						
						if(opts.fixarea)
						{
							if(dragParams.moveX<opts.fixarea[0])
							{
								dragParams.moveX=opts.fixarea[0]
							}
							if(dragParams.moveX>opts.fixarea[1])
							{
								dragParams.moveX=opts.fixarea[1]
							}

							if(dragParams.moveY<opts.fixarea[2])
							{
								dragParams.moveY=opts.fixarea[2]
							}
							if(dragParams.moveY>opts.fixarea[3])
							{
								dragParams.moveY=opts.fixarea[3]
							}
						}
						
						if(opts.dragDirection=='all')
						{
							moveEle.css({'left':dragParams.moveX,'top':dragParams.moveY});
							if(opts.follower){
								opts.follower.css({'left':dragParams.moveX,'top':dragParams.moveY});
							}
						}
						else if (opts.dragDirection=='vertical')
						{
							moveEle.css({'top':dragParams.moveY});
							if(opts.follower){
								opts.follower.css({'top':dragParams.moveY});
							}
						}
						else if(opts.dragDirection=='horizontal')
						{
							moveEle.css({'left':dragParams.moveX});
							if(opts.follower){
								opts.follower.css({'left':dragParams.moveX});
							}
						}

						
						if(opts.callback)
						{
							opts.callback.call(opts.callback,dragParams);
						}
					}
				});

				focuEle.bind('mouseup',function(e){
					bDraging=false;
					moveEle.css({'cursor':'default'});
					if(moveEle.get(0).releaseCapture)
					{
						moveEle.get(0).releaseCapture();
					}
					e.stopPropagation();
					e.cancelBubble = true;
				});
			});
		};

		$.fn.dragDrop.defaults = 
		{
			focuEle:null,			
			callback:null,			
			dragDirection:'all',   
			fixarea:null			
		};

	})(jQuery);