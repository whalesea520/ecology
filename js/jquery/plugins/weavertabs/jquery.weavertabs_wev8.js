/*Hunk Zeng 2009-4-23*/
;(function($) { 
	$.fn.weavertabs = function(option) {
		var param = jQuery.extend({			
			selected:0,
			call:null
		}, option);		

		$(this).each(function() {
		
			$(this).children("table").children("tbody").children("tr").children("td").each(function(i,n){
				$(this).bind("click",function(){			
					if($(this).css("background")!="#FFFFFF"){
						$(this).parent().children().css("background","url('/js/jquery/plugins/weavertabs/tab_wev8.gif') repeat-x");
						$(this).css("background","#FFFFFF");

						
						$("#"+$(this).attr("target")).parent().children().hide();
						$("#"+$(this).attr("target")).show();

						if(param.call!=null){						
							var call=eval(param.call);
							call($(this).attr("target"));
						}
					}
				})
				if(i==param.selected) {
					$(this).css("background","#FFFFFF");	
					$("#"+$(this).attr("target")).show();

					if(param.call!=null){						
						var call=eval(param.call);
						call($(this).attr("target"));
					}
				}else{
					//$(this).css("background","#FFFFFF");
					$(this).css("background","url('/js/jquery/plugins/weavertabs/tab_wev8.gif') repeat-x");
					$("#"+$(this).attr("target")).hide();
				}
			});
		});
		
	};
})(jQuery);