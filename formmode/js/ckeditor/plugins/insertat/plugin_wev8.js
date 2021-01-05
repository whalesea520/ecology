(function(){
    //Section 1 : 按下自定义按钮时执行的代码
	var language = readCookie("languageidweaver");
	var msg = SystemEnv.getHtmlNoteName(3449,language);;
	var labelname = "@";
    var command= {
        exec:function(editor){
    		
             var el=jQuery(".cke_button_insertat");

                      

             var px=el.offset().left;
			 var py=el.offset().top;
            

			 var setting=
                   {
                    itemmaxlength:4,
                    positionx:px,
                    positiony:py,
                    autoitems:atitems,
                    relativeItem:el,
                    entercallback:function()
                    {
                      var  itemdata=this.find(".data").html();
                      var str="<a href='/hrm/HrmTab.jsp?_fromURL=HrmResource&id=" + this.attr("uid")+"' target='_new' atsome='@"+this.attr("uid")+"' contenteditable='false'  style='cursor:pointer;color:#000000;text-decoration:none !important;margin-right:8px;' target='_blank'>@"+itemdata+"</a>&nbsp;";
			          // editor.insertElement(new CKEDITOR.dom.element.createFromHtml(str, editor.document));
                       FCKEditorExt.insertHtml(str,"remark");
                    },muticheckcallback:function()
                   {
                       var checkitems=this;
                       var astr="";
                       var itemvalue="";
					   var  liitem;
                       for(var i= 0,length=checkitems.length;i<length;i++)
                       {
                           liitem=jQuery(checkitems[i]).parent().next();
						   itemvalue=liitem.html();
                           //contenteditable="false"
                           astr=astr+"<a href='/hrm/HrmTab.jsp?_fromURL=HrmResource&id=" + liitem.parent().attr("uid") + "' contenteditable='false' atsome='@"+liitem.parent().attr("uid")+"' style='cursor:pointer;text-decoration:none !important;margin-right:8px;' target='_blank'>@"+itemvalue+"</a>&nbsp;";
						   //editor.insertElement(new CKEDITOR.dom.element.createFromHtml(astr, editor.document));
                    
                       }
					   FCKEditorExt.insertHtml(astr, "remark");
                     }
                   }

                new WeaverAutoComplete(setting).init();

    		        
			 //var str="<a href='/proj/data/ViewProject.jsp?ProjID="+tempid+"' contenteditable='false' unselectable='off'  //style='cursor:pointer;text-decoration:underline !important;margin-right:8px' target='_blank'>"+tempname+"</a>";
			 //editor.insertElement(new CKEDITOR.dom.element.createFromHtml(str, editor.document));
     		          
    		 
           
        }
    },
    //Section 2 : 创建自定义按钮、绑定方法
    name='insertat';
    CKEDITOR.plugins.add(name,{
        init:function(editor){
            editor.addCommand(name,command);
            editor.ui.addButton(name,{
                label:labelname,
                icon: this.path + 'app-at_wev8.png',
                command:name
            });
        }
    });
})();