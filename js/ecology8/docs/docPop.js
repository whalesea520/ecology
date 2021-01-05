
function docPop(){

     var docsids = "";//
     var is_popnums = "";//
     var pop_hights = "";//
	 var pop_widths = "";//
	 var docid_num = "";//
     var params ={"ids":"1"};
	  jQuery.ajax({
	         url : "/docs/docs/DocPop.jsp",
	         data :params,
	         dataType : "json",
	         type : "post",
	         success : function(data){
	                    if(data){
	                      docsids=data["docsids"];	
			
						  is_popnums=data["is_popnums"];
						  pop_hights=data["pop_hights"];
						  pop_widths=data["pop_widths"];
						  if(docsids !=""){
							 
	                       var docsid = docsids.split(",");
						  
	                       var is_popnum = is_popnums.split(",");
	                       var pop_hight = pop_hights.split(",");
						   var pop_width = pop_widths.split(",");
		                   for(i=0;i<docsid.length;i++){		                  
                            var docid_num = docsid[i] +"_"+ is_popnum[i];                        
						    window.open("/docs/docs/DocDsp.jsp?popnum="+docid_num,"","height="+pop_hight[i]+",width="+pop_width[i]+",scrollbars,resizable=yes,status=yes,Minimize=yes,Maximize=yes");
		                 }
	                 }
	               }



	           }
	        });

    
  }

$(document).ready(function(){

	docPop()//弹出框相关
	//var addButtonKey ="addButton"//模块key
	//var addButtonHtmlStr = '<div  class="plugin_check_div"><div class="leftColor" onclick="signInOrSignOut(jQuery(this).attr(\'_signFlag\'))" style="overflow:hidden;text-overflow:ellipsis;cursor:pointer;" _signflag="1" id="sign_dispan">插件</div><img onclick="jQuery(this).next().trigger(\'click\')" src="/wui/theme/ecology8/page/images/signIn_wev8.png" style="cursor:pointer;"></div>' 
	//generatePluginAreaHtml(addButtonHtmlStr,addButtonKey);//向门户右上角添加按钮

})
