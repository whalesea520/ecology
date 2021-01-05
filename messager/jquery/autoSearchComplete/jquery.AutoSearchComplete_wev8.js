/*东平 2009-12-30*/
;
(function($){
    $.fn.autoSearchComplete = function(option){
    
        /*参数*/
        var para = jQuery.extend({
            text: 'Search For Hunk',
            url: ''
        }, option);
        
        
        /*执行*/
        $(this).each(function(){
            var $this = $(this);
            //var width = parseInt($(this).width());   
            $(this).append(				
	            '<div class="autoSearchComplete_search_content" style="width:160px">' +
	            '	<input style="width:158px;border:0px"/>' +
	            '</div>' +
	            '<div  class="autoSearchComplete_search_cancel"></div>' +
				'<div class="autoSearchComplete_search"></div>' +
	            '<div style="clear:both"/>'+
	            '<div class="divSearchResult" style="display:\'none\';border:1px solid gray;position:absolute;padding:2px;background:#ffffff;height:180px;overflow:auto">'+
	            '<div class="divLoading"><img src="tree/themes/default/throbber_wev8.gif"> Loading...</div>'+
	            '</div>'
			);
            
            init($this);
            
            
            $(this).find("input").focus(function(){
                if ($(this).val() == para.text) {
                    $(this).val('');
                    $(this).css("color", "#000000");
                    $this.find(".autoSearchComplete_search_cancel").show();
                }
            });
			
			 $(this).find("input").blur(function(){
                if ($.trim($(this).val()) == '') {
					init($this);
                }
            });
            
            $(this).find(".autoSearchComplete_search_cancel").click(function(){
                if (this.style.display != 'none') {
                    init($this)
                }
            });
			

			$(this).find(".autoSearchComplete_search").click(function(){
                $this.find("input").trigger("keydown",true);
            });

           var isLoadding=false;
		    $(this).find("input").bind("keydown",function(e,isFromSearchButton){
				
            	//记录当前的TABID
            	//Page.changeTab("search");
                var code = (e.keyCode ? e.keyCode : e.which);
                if (code == 13||isFromSearchButton==true) {//enter
                	$this.find(".divSearchResult").css({
                		top:$(this).position().top+16,
                		left:$(this).position().left-1,
                		width: $this.width()+2              		
                	});
                	$this.find(".divSearchResult .divLoading").prevAll().remove();
            		$this.find(".divSearchResult").show();
            		$this.find(".divSearchResult .divLoading").show();
            		
            		            		
                	$.getJSON(para.url,{key:$.trim(this.value)},function(json){                		
                		
                		
                		if(json.items.length==0){
                			$this.find(".divSearchResult .divLoading").before("<div>"+rMsg.autoSearchCompleteNotFound+"</div>")
                		}
                		
                		$.each(json.items,function(i,n){
                			var para={				
                				userid:n.userid,
                				loginid:n.loginid,
                				lastname:n.lastname,
                				sex:n.sex,
                				departmentid:n.departmentid,
                				departmentname:n.departmentname,
                				telephone:n.telephone,
                				mobile:n.mobile,
                				mobilecall:n.mobilecall,
                				email:n.email,
                				messagerurl:n.messagerurl
                			};
                			
                			var mu=new MessageUser(para);                			
                			mu.showTo("divSearchResult");
                			
                		})             		
                	});
                    //locked statue					
                    isLoadding=true;					
                    //loadding
                    //$this.find(".autoSearchComplete_search_cancel img").attr("src","autosearchcomplete/icon-loadding_wev8.gif");  
                   
                    $this.find(".divSearchResult .divLoading").hide();
                    return false;
                }

			})
        });
        /*Function*/
        function init($this){
            /*做INPUT相关初始化*/
            var input = $this.find("input");
            with (input) {
                val(para.text)
                css("color", "rgb(128, 128, 128)")
            }
            $this.find(".autoSearchComplete_search_cancel").hide();
            $this.find(".divSearchResult").hide();
            /*Page.changeTab(tabCurrent);*/           
        }
    };
})(jQuery);
