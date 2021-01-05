var selectedTag;
(function() { 
    CKEDITOR.plugins.add('layoutmenu', { 
        init: function(editor) { 
            editor.addCommand('layoutmenu_read', o);
            editor.addCommand('layoutmenu_edit', o2);
            editor.addCommand('layoutmenu_req', o3); 
			editor.addCommand('layoutmenu_hidden', o7); 
            editor.addCommand('layoutmenu_attr', o4); 
			
            //editor.addCommand('layoutmenu_moreattr', o5); 
           
            if (editor.addMenuItems) {
            	editor.addMenuItem("layoutmenu_attr", {
            		label: '字段属性', 
            		icon: this.path + 'newplugin_wev8.png', 
            		command: 'layoutmenu_attr', 
            		group: 'clipboard', 
            		order: 9
            	}); 
            	
            	/*
            	editor.addMenuItem("layoutmenu_moreattr", {
            		label: '更多属性', 
            		icon: this.path + 'newplugin_wev8.png', 
            		command: 'layoutmenu_moreattr', 
            		group: 'clipboard', 
            		order: 10
            	}); */
            
            	editor.addMenuItem("layoutmenu_read", {
            		label: '只读', 
            		icon: this.path + 'newplugin_wev8.png', 
            		command: 'layoutmenu_read', 
            		group: 'clipboard', 
            		order: 11 
            	}); 
            	editor.addMenuItem("layoutmenu_edit", {
            		label: '可编辑', 
            		icon: this.path + 'newplugin_wev8.png', 
            		command: 'layoutmenu_edit', 
            		group: 'clipboard', 
            		order: 12 
            	}); 
            	editor.addMenuItem("layoutmenu_req", {
            		label: '必填', 
            		icon: this.path + 'newplugin_wev8.png', 
            		command: 'layoutmenu_req', 
            		group: 'clipboard', 
            		order: 13
            	}); 
				editor.addMenuItem("layoutmenu_hidden", {
            		label: '隐藏', 
            		icon: this.path + 'newplugin_wev8.png', 
            		command: 'layoutmenu_hidden', 
            		group: 'clipboard', 
            		order: 14
            	}); 
            
            }
            
            if (editor.contextMenu) {
            	editor.contextMenu.addListener(function(element, selection) {
	            	if (!element || !element.is('input')) return null;
	            	//window.console.log(element);
	            	
	            	var displaymenu = {};
	            	
	            	try{
						if (( element.$.type == 'text' || element.$.type == 'password' ) && element.$.id.indexOf("$field") == 0 && element.$.id != "$field-4$") {
							selectedTag = element;
							displaymenu['layoutmenu_attr'] = CKEDITOR.TRISTATE_OFF;
							displaymenu['layoutmenu_moreattr'] = CKEDITOR.TRISTATE_OFF;
						}
					}catch(e){}
					try{
						var fieldid = element.$.id.substr(6);
						fieldid = fieldid.substr(0, fieldid.indexOf("$"));
						var canFieldEdit = window.parent.document.getElementById("canFieldEdit").value;
						var especialFieldids = window.parent.document.getElementById("especialFieldids").value;
						var index_eFieldids = (","+especialFieldids+",").indexOf(","+fieldid+",");
						if(canFieldEdit=="1" && index_eFieldids==-1){
							if (( element.$.type == 'text' || element.$.type == 'password' ) && element.$.id.indexOf("$field") == 0 && element.$.id != "$field-4$") {
								var fieldShowAttr = window.parent.document.getElementById("fieldattr"+fieldid).value;
//								selectTag = tag;
								selectedTag = element;
								if(fieldShowAttr=="1"){
									//displaymenu['layoutmenu_read'] = CKEDITOR.TRISTATE_OFF;
									displaymenu['layoutmenu_edit'] = CKEDITOR.TRISTATE_OFF;
									displaymenu['layoutmenu_req'] = CKEDITOR.TRISTATE_OFF;
									displaymenu['layoutmenu_hidden'] = CKEDITOR.TRISTATE_OFF;
								}else if(fieldShowAttr=="2"){
									displaymenu['layoutmenu_read'] = CKEDITOR.TRISTATE_OFF;
									//displaymenu['layoutmenu_edit'] = CKEDITOR.TRISTATE_OFF;
									displaymenu['layoutmenu_req'] = CKEDITOR.TRISTATE_OFF;
									displaymenu['layoutmenu_hidden'] = CKEDITOR.TRISTATE_OFF;
								}else if(fieldShowAttr=="3"){
									displaymenu['layoutmenu_read'] = CKEDITOR.TRISTATE_OFF;
									displaymenu['layoutmenu_edit'] = CKEDITOR.TRISTATE_OFF;
									//displaymenu['layoutmenu_req'] = CKEDITOR.TRISTATE_OFF;
									displaymenu['layoutmenu_hidden'] = CKEDITOR.TRISTATE_OFF;
								}else if(fieldShowAttr=="4"||fieldShowAttr=="0"){
									displaymenu['layoutmenu_read'] = CKEDITOR.TRISTATE_OFF;
									displaymenu['layoutmenu_edit'] = CKEDITOR.TRISTATE_OFF;
									displaymenu['layoutmenu_req'] = CKEDITOR.TRISTATE_OFF;
									//displaymenu['layoutmenu_hidden'] = CKEDITOR.TRISTATE_OFF;
								}

							}
						}
					}catch(e){}
					
					return displaymenu;
	            }); 
            	/*
	            editor.contextMenu.addListener(function(element, selection) {
	            	if (!element || !element.is('input')) return null;
	            	
	            	
	            	
	            	
	            	
	            	
	            	
	            	
	            	selectedTag = element;
	                return { "layoutmenu_read": CKEDITOR.TRISTATE_OFF
	                         , "layoutmenu_edit": CKEDITOR.TRISTATE_OFF
	                         , "layoutmenu_req": CKEDITOR.TRISTATE_OFF }; 
	            }); 
	            */
	           
            }
        } 
    }); 
})();
var o = { 
	exec: function(obj) { 
    	var fieldid = selectedTag.$.id.substr(6);
		fieldid = fieldid.substr(0, fieldid.indexOf("$"));
		var fieldShowAttr = window.parent.document.getElementById("fieldattr"+fieldid).value = "1";
		window.parent.onchangefieldattrFromFck(fieldid, "1");
	} 
}; 
   
var o2 = { 
	exec: function(obj) { 
		var fieldid = selectedTag.$.id.substr(6);
		fieldid = fieldid.substr(0, fieldid.indexOf("$"));
		var fieldShowAttr = window.parent.document.getElementById("fieldattr"+fieldid).value = "2";
		window.parent.onchangefieldattrFromFck(fieldid, "2");
	} 
}; 
var o3 = { 
	exec: function(obj) { 
		var fieldid = selectedTag.$.id.substr(6);
		fieldid = fieldid.substr(0, fieldid.indexOf("$"));
		var fieldShowAttr = window.parent.document.getElementById("fieldattr"+fieldid).value = "3";
		window.parent.onchangefieldattrFromFck(fieldid, "3");
	} 
}; 
var o7 = { 
	exec: function(obj) { 
		var fieldid = selectedTag.$.id.substr(6);
		fieldid = fieldid.substr(0, fieldid.indexOf("$"));
		var fieldShowAttr = window.parent.document.getElementById("fieldattr"+fieldid).value = "4";
		window.parent.onchangefieldattrFromFck(fieldid, "4");
	} 
}; 
    
//字段sql属性
var o4 = { 
	exec: function(obj) { 
     	//var ckdialog = new FCKDialogCommandNew('FieldAttribute','字段属性','/FCKEditor/editor/dialog/fck_fieldattr.jsp',600,520)
		//ckdialog.exec();
		
		var op = {editor: obj, selected :selectedTag.$};
		//window.console.log(obj);
		var url = '/formmode/setup/ck_fieldattr.jsp';
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
	    dialog.callbackfunParam = null;
		dialog.URL = url;
		dialog.callbackfunParam = op;
		dialog.callbackfun = function (paramobj, id1) {
		} ;
		dialog.Title = '字段属性';
		dialog.Height = 600 ;
		dialog.Width = 520 ;
		dialog.Drag = true;
		dialog.show();
		
	} 
}; 
    
 //字段sql属性
 var o5 = { 
     exec: function(obj) { 
     	//var ckdialog = new FCKDialogCommandNew('FieldAttributeMore', '更多属性','/FCKEditor/editor/dialog/fck_fieldattrMore.jsp',600,520);
		//ckdialog.exec();
    	 var op = {editor: obj, selected :selectedTag.$};
		var url = '/workflow/html/ck_fieldattrMore.jsp';
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
	    dialog.callbackfunParam = null;
		dialog.URL = url;
		dialog.callbackfunParam = op;
		dialog.callbackfun = function (paramobj, id1) {
			
		} ;
		dialog.Title = '更多属性';
		dialog.Height = 600 ;
		dialog.Width = 520 ;
		dialog.Drag = true;
		dialog.show();
    } 
 };
 
