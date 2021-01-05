/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.plugins.add('uicolor',{requires:['dialog'],lang:['en','he'],init:function(a){if(CKEDITOR.env.ie6Compat)return;a.addCommand('uicolor',new CKEDITOR.dialogCommand('uicolor'));a.ui.addButton('UIColor',{label:a.lang.uicolor.title,command:'uicolor',icon:this.path+'uicolor_wev8.gif'});CKEDITOR.dialog.add('uicolor',this.path+'dialogs/uicolor_wev8.js');CKEDITOR.scriptLoader.load(CKEDITOR.getUrl('plugins/uicolor/yui/yui_wev8.js'));a.element.getDocument().appendStyleSheet(CKEDITOR.getUrl('plugins/uicolor/yui/assets/yui_wev8.css'));}});
