/**
 * Created with JetBrains WebStorm.
 * User: lsj
 * Date: 14-2-10
 * Time: 下午8:09
 * To change this template use File | Settings | File Templates.
 */
/**
 * settings结构  {itemheght:''，itemmaxlength:'',,itempositionx:'',positiony:'',entercallback:function(){},muticheckcallback:function(){}}
 * itemheght每个条目的高度条目数(超出部分用滚动条滚动展示)
 * itemmaxlength 最多显示的
 * positionx:控件展示的x坐标   positiony:控件展示的y坐标    entercallback: 回车键选中回调函数     muticheckcallback:多选确定按钮
 * @param settings
 */
(function()
{
		//每个li高度为25px
        var  ITEM_PERHEIGHT=30;
        var  CONTAINER_POSITIONX=0;
        var  CONTAINER_POSITIONY=0;
        var  ITEM_LENGTH=10;
       //默认配置信息
        var defaultConfig={
            itemheght:ITEM_PERHEIGHT,
            positionx:CONTAINER_POSITIONX,
            positiony: CONTAINER_POSITIONY,
            itemmaxlength:ITEM_LENGTH,
            autoitems:[],
            entercallback:function(){

                alert('entercallback!!!');

            },
            muticheckcallback:function(){

                alert('muticheckcallback!!!');
            }
        }
        //完善设置信息
        function mergeValue(settings)
        {

            for(var item in defaultConfig)
            {
                if(!settings.hasOwnProperty(item))
                {
                    settings[item]=defaultConfig[item];
                }
            }
        }
       //自动提示对象
       this.WeaverAutoComplete=function(settings)
       {
           if(!settings)
               settings={};
           //绘制自动提示插件界面
           var autocontainer=jQuery("<div></div>");
           autocontainer.addClass("filtercontainer");

           autocontainer.click(function(e){
		   
                
		         e.stopPropagation();
		   });

           //搜索框
           var atsearch=jQuery("<div></div>");

           atsearch.addClass("filteritem");


           var  leftitem=jQuery("<div style='float: left;margin:1px;margin-left:3px'></div>");

           var searchinput=jQuery("<span style='border:1px #e1e1e1 solid;width:140px;float:right;background:#fff;'><span style='padding-right:15px' class='at_search_btn'></span><input name='at_search' id='at_search' style='border:0px;height:25px' size='16'></span><span class='e8tips' title='"+SystemEnv.getHtmlNoteName(3652 ,languageid)+"' style='position:absolute;right:8px;top:3px;'><img src='/images/tooltip_wev8.png' align='absMiddle' style='vertical-align:middle;'/></span>");

           leftitem.append(searchinput);
           
           var multicheckbutton=jQuery("<input type='button' class='e8_btn_submit' style='width:55px !important;height:30px !important;' value='"+SystemEnv.getHtmlNoteName(3451 ,languageid)+"'>");
           var multicheckcancell=jQuery("<input type='button' class='e8_btn_submit' style='width:55px !important;height:30px !important;' value='"+SystemEnv.getHtmlNoteName(3516 ,languageid)+"'>");

          // var rightitem=jQuery("<div style='float: left;'></div>");

           

     

           //生成查询框
           atsearch.append(leftitem);
           autocontainer.append(atsearch);

           //所有条目
           var autoitems=jQuery("<div><ol></ol></div>");
           autoitems.addClass("autoitems");
           autoitems.css('clear','left');
           autocontainer.append(autoitems);



           return {
               generateItems:function(items,checked)
               {
                   var length=items.length;
                   var li;
                 //  if(length>0)
                   autoitems.find("ol").html("");
                   var ul=autoitems.find("ol");
                   for(var i= 0;i<length;i++)
                   {
                       li=jQuery("<li><input type='checkbox' class=InputStyle style='vertical-align:middle;' "+checked+" _uid=" + items[i].uid + " _uname=" + items[i].data + "><span class='data' datapy="+items[i].datapy+">"+items[i].data+"</span></li>");
                       li.attr("index",i+1);
					   li.attr("uid",items[i].uid);
                       ul.append(li);
                   }
                   if(length>settings.itemmaxlength)
                   {
                   	   autoitems.css("height",133+"px");
                       autoitems.css("overflow","auto");
                   }else
                   {
                       autoitems.css("height",(length*settings.itemheght)+"px");
                   }
                   if(length>0)
                       autoitems.find("ol li").eq(0).addClass("on");

                   autoitems.scroll(function(e){
				       e.stopPropagation();
				   });
               },
              //初始化外部容器
               initAutoContainer:function()
               {
                   autocontainer.css("left",settings.positionx);
                   autocontainer.css("top",settings.positiony);

               },
               //初始化选择条目
               initAutoItems:function()
               {
                   var items=settings.autoitems;
                   this.generateItems(items);

				  
               },
               registerEvents:function()
               {
                   var that=this;

                   var hideordisplay=true;
                   autocontainer.mouseover(function(){

                       hideordisplay=true;

                   });
                   autocontainer.mouseout(function(){

                       hideordisplay=false;
                   });

                   jQuery(document).click(function(){
                       if(!hideordisplay)
                       {
                          that.destroy();
                          hideordisplay=true;
                       }
                   });

                  


                  //注册滚动条滚动事件,带动自动提示框
                  function  filterScroll()
				   {
				  
				    	if(jQuery(".filtercontainer").length>0)
					    {
                           if(settings.relativeItem)
						   {
                           var el=settings.relativeItem;
                           var px=jQuery(el).offset().left;
			               var py=jQuery(el).offset().top;
                           jQuery(".filtercontainer").css("left",px);
                           jQuery(".filtercontainer").css("top",py);
						  }
			        }
				  
				  }

                  if(window.attachEvent)
				  {
				    window.attachEvent('onscroll',filterScroll);
				  }else if(window.addEventListener)
				  {
				    window.addEventListener('scroll',filterScroll);				  
				  }

   

                 
                   //注册事件 (输入框动态索引)
                   searchinput.keyup(function(){
                        var val=jQuery("#at_search").val();
                        var items=[];
                        var autoitems=settings.autoitems;
                        for(var i= 0,length=autoitems.length;i<length;i++)
                        {
                           if(val===''  ||  autoitems[i].data.indexOf(val)>-1||autoitems[i].datapy.toLowerCase().indexOf(val.toLowerCase())>-1)
                           {
                               items.push(autoitems[i]);
                           }
                        }
                       that.generateItems(items);
					   autocontainer.jNice(); 
                   });

                   multicheckbutton.click(function(){
                       var checkitems = null;
                       if (!!settings && !!settings.isfromuedit && settings.isfromuedit == 1) {
                           checkitems=autoitems.find("input:checkbox:checked");
                       } else { 
                           checkitems=autoitems.find("ol").find(".jNiceChecked");
                       }
                       
                       if(checkitems.length===0)
                       {
                           alert("请至少选择一个!!!");
                           return;
                       }
                       settings.muticheckcallback.call(checkitems);
                       that.destroy();

                   });
                   multicheckcancell.click(function(){

                       that.destroy();
                   });
                   autoitems.find("ol").delegate( "li", "mouseover", function() {
                       autoitems.find("ol li.on").removeClass("on");
                       jQuery(this).addClass("on");
                   });

                   autoitems.find("ol").delegate( "input[type='checkbox']", "click",function(e){
                        e.stopPropagation();
                   });

                   autoitems.find("ol").delegate( "li", "click",function(){
                       settings.entercallback.call(jQuery(this));
                       that.destroy();
                   });

                   /**
                    * 按键按下
                    * @param e
                    */
                   function  keydown(e)
                   {
                       var keycode= e.which;
                       var current;
                       e.stopPropagation();
                       function scrollTo(li)
                       {

                           autoitems.find("ol").unbind("mouseover");
                           //需向上向下移动
                           if(settings.autoitems.length>settings.itemmaxlength)
                           {
                               var index=li.attr("index");
                               var itemheight=settings.itemmaxlength*settings.itemheght;
                               var currentlength=index*settings.itemheght;
                               var scrollength=currentlength-itemheight;
                               if(scrollength<0)
                               {
                                   autoitems.scrollTop(0);

                               }else
                               {
                                   autoitems.scrollTop(scrollength);
                               }

                           }
                           li.addClass("on");

                           //注意:主要防止通过上下箭头移动item的时候触发mouseover事件
                           autoitems.find("ol").mousemove(function(){

                               autoitems.find("ol").delegate( "li", "mouseover", function() {
                                   autoitems.find("ol li.on").removeClass("on");
                                   jQuery(this).addClass("on");
                               });
                               autoitems.find("ol").unbind("mousemove");
                           });


                       }
                       //向上
                       if(keycode===38)
                       {
                       	   jQuery("#at_search").blur();
                           searchinput.blur();
                           if(jQuery("li.on").prev("li").length===1)
                           {
                               e.preventDefault();
                               current=jQuery("li.on");
                               scrollTo(jQuery("li.on").prev("li"));
                               current.removeClass("on");

                           }


                       }
                       //向下
                       else if(keycode===40)
                       {
                       	   jQuery("#at_search").blur();
                           searchinput.blur();
                           if(jQuery("li.on").next("li").length===1)
                           {
                               e.preventDefault();
                               current=jQuery("li.on");
                               scrollTo(jQuery("li.on").next("li"));
                               current.removeClass("on");

                           }

                       }else if(keycode===13)
                       {
                           var iteminfo=jQuery("li.on");

                           settings.entercallback.call(iteminfo);

                           that.destroy();


                       }

                   }
                   jQuery(document).keydown(keydown);

               },
               init:function()
               {
                   mergeValue(settings);
                   //初始化外部容器
                   this.initAutoContainer();
                   //初始化选择条目
                   this.initAutoItems();

				   autocontainer.jNice(); 
                   //注册事件
                   this.registerEvents();
                   var btngroup=jQuery("<table style='border-top:1px solid #efefef;background:#fcfcfc'><tr><td width=86px></td><td style='color:#dadada'>|</td><td width=86px></td></tr><table>");
              
				   btngroup.find("td:eq(0)").append(multicheckbutton);
				   btngroup.find("td:eq(2)").append(multicheckcancell);
                   autocontainer.append(btngroup);
                   jQuery(document.body).append(autocontainer);

                   autocontainer.css("top",autocontainer.offset().top-5);
                   searchinput.focus();
               },
               //销毁容器
               destroy:function()
               {

                  autocontainer.remove();
                  jQuery(document).unbind("keydown");



               }
             }

       }

})();