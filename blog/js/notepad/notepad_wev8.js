var notepad=function(objtag){
    	
    	var init=function(){
    		var eleShare =jQuery("#imgSinaShare");
	    	if(eleShare.length==0){
	    		var newNode = document.createElement("span");
			    newNode.innerHTML ='<img id="imgSinaShare" class="img_sina_share"  style="display:none; position:absolute; cursor:pointer;" title="将选中内容发送到微博便签" src="/blog/images/blog_notes_wev8.png" width="24" />';
			    document.body.appendChild(newNode);
			    eleShare =jQuery("#imgSinaShare");
			    
			    eleShare.click(function() {
					var txt = funGetSelectTxt();
					if (txt) {
						window.top.Dialog.confirm("确定将选中内容发送到微博便签？",function(){
							jQuery.post("/blog/blogOperation.jsp",{'operation':'saveNotepad','content':txt,'saveType':'append'},function(data){
								window.top.Dialog.alert("发送成功");
								eleShare.hide();  
								window.getSelection ? window.getSelection().removeAllRanges() : document.selection.empty();
					        });
						});
					}
		       });
		   
			   eleShare.hover(function(){
			       jQuery(this).attr("src","/blog/images/blog_notes_over_wev8.png");
			   },function(){
			       jQuery(this).attr("src","/blog/images/blog_notes_wev8.png");
			   });
    		}
    	};
           
		var funGetSelectTxt = function() {
			var txt = "";
			if(document.selection) {
				txt = document.selection.createRange().htmlText;	// IE
			} else {
				var range=window.getSelection().getRangeAt(0);
	            var container = document.createElement('div');
	            container.appendChild(range.cloneContents());
	            txt=container.innerHTML;
			}
			var txtdiv=jQuery("<div>"+txt+"</div>");
			if(txtdiv.find(objtag).length>0){
				txt="";
				txtdiv.find(objtag).each(function(){
				   txt=txt+this.innerHTML+"<br>"; 
				});
			}
			return txt;
		};
	   
	   init();	
	   //var eleContainer =$(this);
	   $(objtag).die().live('mouseup',function(e){
			e = e || window.event;
			var target=e.srcElement||e.target;
			if(target.id=="imgSinaShare")
			   return ;
			var txt = funGetSelectTxt(), sh = window.pageYOffset ||document.body.scrollTop||document.documentElement.scrollTop || document.body.scrollTop || 0;
			var left = (e.clientX - 10 < 0) ? e.clientX + 10 : e.clientX -10, top = (e.clientY - 35 < 0) ? e.clientY + sh + 20 : e.clientY + sh - 35;
			var eleShare = document.getElementById("imgSinaShare");
			if (txt) {
				eleShare.style.display = "inline";
				eleShare.style.left = left + "px";
				eleShare.style.top = top + "px";
			} else {
				eleShare.style.display = "none";
			}
	   });
	   /*
       eleContainer.each(function(){
		   this.onmouseup=function(e) {
			e = e || window.event;
			var target=e.srcElement||e.target;
			if(target.id=="imgSinaShare")
			   return ;
			var txt = funGetSelectTxt(), sh = window.pageYOffset ||document.body.scrollTop||document.documentElement.scrollTop || document.body.scrollTop || 0;
			var left = (e.clientX - 10 < 0) ? e.clientX + 10 : e.clientX -10, top = (e.clientY - 35 < 0) ? e.clientY + sh + 20 : e.clientY + sh - 35;
			var eleShare = document.getElementById("imgSinaShare");
			if (txt) {
				eleShare.style.display = "inline";
				eleShare.style.left = left + "px";
				eleShare.style.top = top + "px";
			} else {
				eleShare.style.display = "none";
			}
		   };
       });
		*/
	   }
	
