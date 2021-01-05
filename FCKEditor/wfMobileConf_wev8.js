// JavaScript Document,weaverDefaultEditor.js



// Disable the custom Enter Key Handler. This option will be removed in version 2.5.
FCKConfig.DisableEnterKeyHandler = false ;

FCKConfig.CustomConfigurationsPath = '' ;

FCKConfig.EditorAreaCSS = FCKConfig.BasePath + 'css/fck_editorarea_wev8.css' ;
FCKConfig.ToolbarComboPreviewCSS = '' ;

FCKConfig.DocType = '' ;

FCKConfig.BaseHref = '' ;

FCKConfig.FullPage = false ;

FCKConfig.Debug = false ;
FCKConfig.AllowQueryStringDebug = true ;

FCKConfig.SkinPath = FCKConfig.BasePath + 'skins/default/' ;
FCKConfig.PreloadImages = [ FCKConfig.SkinPath + 'images/toolbar.start_wev8.gif', FCKConfig.SkinPath + 'images/toolbar.buttonarrow_wev8.gif' ] ;

FCKConfig.PluginsPath = FCKConfig.BasePath + 'plugins/' ;

// FCKConfig.Plugins.Add( 'autogrow' ) ;
FCKConfig.AutoGrowMax = 400 ;

// FCKConfig.ProtectedSource.Add( /<%[\s\S]*?%>/g ) ;	// ASP style server side code <%...%>
// FCKConfig.ProtectedSource.Add( /<\?[\s\S]*?\?>/g ) ;	// PHP style server side code
// FCKConfig.ProtectedSource.Add( /(<asp:[^\>]+>[\s|\S]*?<\/asp:[^\>]+>)|(<asp:[^\>]+\/>)/gi ) ;	// ASP.Net style tags <asp:control>

FCKConfig.AutoDetectLanguage	= false;
FCKConfig.DefaultLanguage		='zh-cn' ;
FCKConfig.ContentLangDirection	= 'ltr' ;


FCKConfig.ProcessHTMLEntities	= true ;
FCKConfig.IncludeLatinEntities	= true ;
FCKConfig.IncludeGreekEntities	= true ;

FCKConfig.ProcessNumericEntities = false ;

FCKConfig.AdditionalNumericEntities = ''  ;		// Single Quote: "'"

FCKConfig.FillEmptyBlocks	= true ;

FCKConfig.FormatSource		= true ;
FCKConfig.FormatOutput		= true ;
FCKConfig.FormatIndentator	= '    ' ;

FCKConfig.ForceStrongEm = true ;
FCKConfig.GeckoUseSPAN	= false ;
FCKConfig.StartupFocus	= false ;
FCKConfig.ForcePasteAsPlainText	= false ;
FCKConfig.AutoDetectPasteFromWord = true ;	// IE only.
FCKConfig.ForceSimpleAmpersand	= false ;
FCKConfig.TabSpaces		= 0 ;
FCKConfig.ShowBorders	= true ;
FCKConfig.SourcePopup	= false ;
FCKConfig.ToolbarStartExpanded	= true ;
FCKConfig.ToolbarCanCollapse	= true ;
FCKConfig.IgnoreEmptyParagraphValue = true ;
FCKConfig.PreserveSessionOnFileBrowser = false ;
FCKConfig.FloatingPanelsZIndex = 10000 ;

FCKConfig.TemplateReplaceAll = true ;
FCKConfig.TemplateReplaceCheckbox = true ;

FCKConfig.ToolbarLocation = 'In' ;

FCKConfig.ToolbarSets["Default"] = [
	['Source','DocProps','-','Save','NewPage','Preview','-','Templates'],
	['Cut','Copy','Paste','PasteText','PasteWord','-','Print','SpellCheck'],
	['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
	['Form','Checkbox','Radio','TextField','Textarea','Select','Button','ImageButton','HiddenField'],
	'/',
	['Bold','Italic','Underline','StrikeThrough','-','Subscript','Superscript'],
	['OrderedList','UnorderedList','-','Outdent','Indent'],
	['JustifyLeft','JustifyCenter','JustifyRight','JustifyFull'],
	['Link','Unlink','Anchor'],
	['Image','Flash','Table','Rule','Smiley','SpecialChar','PageBreak'],
	'/',
	['Style','FontFormat','FontName','FontSize'],
	['TextColor','BGColor'],
	['FitWindow','-','About']
] ;

FCKConfig.ToolbarSets["ecology"] = [
	['Bold','Italic','Underline','StrikeThrough'],
	['Cut','Copy','Paste','Undo','Redo','-','PasteText','PasteWord','SelectAll','RemoveFormat'],
	['OrderedList','UnorderedList','-','Outdent','Indent'],
	['JustifyLeft','JustifyCenter','JustifyRight','JustifyFull'],
	['Link','Unlink'],
	['CustomImage','CustomFlash',/*'Video',*/'Smiley','SpecialChar','PageBreak'],
	'/',
	['FontFormat','FontName','FontSize'],
	['TextColor','BGColor','FitWindow','Source']
];
/*Html编辑流程展现模板专用，只要图片，不要flash*/
FCKConfig.ToolbarSets["htmlLayout"] = [
	['Bold','Italic','Underline','StrikeThrough'],
	['Cut','Copy','Paste','Undo','Redo','-','PasteText','PasteWord','SelectAll','RemoveFormat'],
	['OrderedList','UnorderedList','-','Outdent','Indent'],
	['JustifyLeft','JustifyCenter','JustifyRight','JustifyFull'],
	['Link','Unlink'],
	['CustomImage','Table','Smiley','SpecialChar','FormSplitPage'],
	'/',
	['FontFormat','FontName','FontSize'],
	['TextColor','BGColor','FitWindow','Source']
];
if(typeof(window.parent.flvBrowserUrl)=="string" && window.parent.flvBrowserUrl!=""){//检测是否加载视频按钮


	var btns=FCKConfig.ToolbarSets["ecology"][5];
	FCKConfig.ToolbarSets["ecology"][5]=new Array(btns[0],btns[1],'FlashVideo',btns[2],btns[3],btns[4]);
}

FCKConfig.ToolbarSets["ecologyNoImage"] = [
	['Bold','Italic','Underline','StrikeThrough'],
	['Cut','Copy','Paste','Undo','Redo','-','PasteText','PasteWord','SelectAll','RemoveFormat'],
	['OrderedList','UnorderedList','-','Outdent','Indent'],
	['JustifyLeft','JustifyCenter','JustifyRight','JustifyFull'],
	['Link','Unlink'],
	[/*'CustomImage','CustomFlash','Video',*/'Smiley','SpecialChar','PageBreak'],
	'/',
	['FontFormat','FontName','FontSize'],
	['TextColor','BGColor','FitWindow','Source']
];

FCKConfig.ToolbarSets["Basic"] = [
	['Bold','Italic','-','OrderedList','UnorderedList','-','Link','Unlink','-','About']
] ;

FCKConfig.EnterMode = 'p' ;			// p | div | br
FCKConfig.ShiftEnterMode = 'br' ;	// p | div | br

FCKConfig.Keystrokes = [
	[ CTRL + 65 /*A*/, true ],
	[ CTRL + 67 /*C*/, true ],
	[ CTRL + 70 /*F*/, true ],
	[ CTRL + 83 /*S*/, true ],
	[ CTRL + 88 /*X*/, true ],
	[ CTRL + 86 /*V*/, 'Paste' ],
	[ SHIFT + 45 /*INS*/, 'Paste' ],
	[ CTRL + 90 /*Z*/, 'Undo' ],
	[ CTRL + 89 /*Y*/, 'Redo' ],
	[ CTRL + SHIFT + 90 /*Z*/, 'Redo' ],
	[ CTRL + 76 /*L*/, 'Link' ],
	[ CTRL + 66 /*B*/, 'Bold' ],
	[ CTRL + 73 /*I*/, 'Italic' ],
	[ CTRL + 85 /*U*/, 'Underline' ],
	[ CTRL + SHIFT + 83 /*S*/, 'Save' ],
	[ CTRL + ALT + 13 /*ENTER*/, 'FitWindow' ],
	[ CTRL + 9 /*TAB*/, 'Source' ]
] ;

//如果是手机版Html模板，则对字段属性右键菜单屏蔽，去掉 'FieldAttribute'
FCKConfig.ContextMenu = ['Generic'];//,'Link','Anchor','Image','Flash','Select','Textarea','Checkbox','Radio','TextField','HiddenField','ImageButton','Button','BulletedList','NumberedList','Table','Form'] ;
FCKConfig.BrowserContextMenuOnCtrl = false ;

FCKConfig.FontColors = '000000,993300,333300,003300,003366,000080,333399,333333,800000,FF6600,808000,808080,008080,0000FF,666699,808080,FF0000,FF9900,99CC00,339966,33CCCC,3366FF,800080,999999,FF00FF,FFCC00,FFFF00,00FF00,00FFFF,00CCFF,993366,C0C0C0,FF99CC,FFCC99,FFFF99,CCFFCC,CCFFFF,99CCFF,CC99FF,FFFFFF' ;

FCKConfig.FontNames		= 'Arial;Tahoma;Courier New;Times New Roman;Wingdings;Comic Sans MS;Verdana;宋体;新宋体;黑体;隶书;幼园;楷体_GB2312;仿宋_GB2312';
FCKConfig.FontSizes		= '1/xx-small;2/x-small;3/small;4/medium;5/large;6/x-large;7/xx-large' ;
FCKConfig.FontFormats	= 'p;div;pre;address;h1;h2;h3;h4;h5;h6' ;

FCKConfig.StylesXmlPath		= FCKConfig.EditorPath + 'fckstyles.xml' ;
FCKConfig.TemplatesXmlPath	= FCKConfig.EditorPath + 'fcktemplates.xml' ;

FCKConfig.SpellChecker			= 'ieSpell' ;	// 'ieSpell' | 'SpellerPages'
FCKConfig.IeSpellDownloadUrl	= 'http://www.iespell.com/download.php' ;
FCKConfig.SpellerPagesServerScript = 'server-scripts/spellchecker.php' ;	// Available extension: .php .cfm .pl
FCKConfig.FirefoxSpellChecker	= false ;

FCKConfig.MaxUndoLevels = 15 ;

FCKConfig.DisableObjectResizing = false ;
FCKConfig.DisableFFTableHandles = true ;

FCKConfig.LinkDlgHideTarget		= false ;
FCKConfig.LinkDlgHideAdvanced	= false ;

FCKConfig.ImageDlgHideLink		= false ;
FCKConfig.ImageDlgHideAdvanced	= false ;

FCKConfig.FlashDlgHideAdvanced	= false ;

FCKConfig.ProtectedTags = '' ;

// This will be applied to the body element of the editor
FCKConfig.BodyId = '' ;
FCKConfig.BodyClass = '' ;

FCKConfig.DefaultLinkTarget = '' ;

// The option switches between trying to keep the html structure or do the changes so the content looks like it was in Word
FCKConfig.CleanWordKeepsStructure = false ;

// The following value defines which File Browser connector and Quick Upload
// "uploader" to use. It is valid for the default implementaion and it is here
// just to make this configuration file cleaner.
// It is not possible to change this value using an external file or even
// inline when creating the editor instance. In that cases you must set the
// values of LinkBrowserURL, ImageBrowserURL and so on.
// Custom implementations should just ignore it.
var _FileBrowserLanguage	= 'asp' ;	// asp | aspx | cfm | lasso | perl | php | py
var _QuickUploadLanguage	= 'asp' ;	// asp | aspx | cfm | lasso | php


// Don't care about the following line. It just calculates the correct connector
// extension to use for the default File Browser (Perl uses "cgi").
var _FileBrowserExtension = _FileBrowserLanguage == 'perl' ? 'cgi' : _FileBrowserLanguage ;

FCKConfig.LinkBrowser = false ;
FCKConfig.LinkBrowserURL = FCKConfig.BasePath + 'filemanager/browser/default/browser.html?Connector=connectors/' + _FileBrowserLanguage + '/connector.' + _FileBrowserExtension ;
FCKConfig.LinkBrowserWindowWidth	= FCKConfig.ScreenWidth * 0.7 ;		// 70%
FCKConfig.LinkBrowserWindowHeight	= FCKConfig.ScreenHeight * 0.7 ;	// 70%

FCKConfig.ImageBrowser = false ;
FCKConfig.ImageBrowserURL = FCKConfig.BasePath + 'filemanager/browser/default/browser.html?Type=Image&Connector=connectors/' + _FileBrowserLanguage + '/connector.' + _FileBrowserExtension ;
FCKConfig.ImageBrowserWindowWidth  = FCKConfig.ScreenWidth * 0.7 ;	// 70% ;
FCKConfig.ImageBrowserWindowHeight = FCKConfig.ScreenHeight * 0.7 ;	// 70% ;

FCKConfig.FlashBrowser = false ;
FCKConfig.FlashBrowserURL = FCKConfig.BasePath + 'filemanager/browser/default/browser.html?Type=Flash&Connector=connectors/' + _FileBrowserLanguage + '/connector.' + _FileBrowserExtension ;
FCKConfig.FlashBrowserWindowWidth  = FCKConfig.ScreenWidth * 0.7 ;	//70% ;
FCKConfig.FlashBrowserWindowHeight = FCKConfig.ScreenHeight * 0.7 ;	//70% ;

FCKConfig.LinkUpload = false ;
FCKConfig.LinkUploadURL = FCKConfig.BasePath + 'filemanager/upload/' + _QuickUploadLanguage + '/upload.' + _QuickUploadLanguage ;
FCKConfig.LinkUploadAllowedExtensions	= "" ;			// empty for all
FCKConfig.LinkUploadDeniedExtensions	= ".(html|htm|php|php2|php3|php4|php5|phtml|pwml|inc|asp|aspx|ascx|jsp|cfm|cfc|pl|bat|exe|com|dll|vbs|js|reg|cgi|htaccess|asis|sh|shtml|shtm|phtm)$" ;	// empty for no one

FCKConfig.ImageUpload = false ;
FCKConfig.ImageUploadURL = FCKConfig.BasePath + 'filemanager/upload/' + _QuickUploadLanguage + '/upload.' + _QuickUploadLanguage + '?Type=Image' ;
FCKConfig.ImageUploadAllowedExtensions	= ".(jpg|gif|jpeg|png|bmp)$" ;		// empty for all
FCKConfig.ImageUploadDeniedExtensions	= "" ;							// empty for no one

FCKConfig.FlashUpload = false ;
FCKConfig.FlashUploadURL = FCKConfig.BasePath + 'filemanager/upload/' + _QuickUploadLanguage + '/upload.' + _QuickUploadLanguage + '?Type=Flash' ;
FCKConfig.FlashUploadAllowedExtensions	= ".(swf|fla)$" ;		// empty for all
FCKConfig.FlashUploadDeniedExtensions	= "" ;					// empty for no one

FCKConfig.SmileyPath	= FCKConfig.BasePath + 'images/smiley/msn/' ;
FCKConfig.SmileyImages	= ['regular_smile_wev8.gif','sad_smile_wev8.gif','wink_smile_wev8.gif','teeth_smile_wev8.gif','confused_smile_wev8.gif','tounge_smile_wev8.gif','embaressed_smile_wev8.gif','omg_smile_wev8.gif','whatchutalkingabout_smile_wev8.gif','angry_smile_wev8.gif','angel_smile_wev8.gif','shades_smile_wev8.gif','devil_smile_wev8.gif','cry_smile_wev8.gif','lightbulb_wev8.gif','thumbs_down_wev8.gif','thumbs_up_wev8.gif','heart_wev8.gif','broken_heart_wev8.gif','kiss_wev8.gif','envelope_wev8.gif'] ;
FCKConfig.SmileyColumns = 8 ;
FCKConfig.SmileyWindowWidth		= 320 ;
FCKConfig.SmileyWindowHeight	= 240 ;

var selectTag;

function LoadUserExtension(){//在FCKEdiotr.html中加载



/**** @20070821 add by yeriwei! ****/
function FCKCustomImageCommand(){//自定义插入图片命令



	this.name='CustomImage';
	this.Execute=function(){
		var sel=FCK.EditorDocument.selection.createRange();
		window.parent.FCKEditorExt.show(sel);
	};
	this.GetState=function(){return 0;};
};
function FCKVideoCommand(){//插入视频命令
	this.name='Video';
	this.Execute=function(){/*alert('CommandName:'+this.name);*/};
	this.GetState=function(){return 0;};
}
function FCKFlashVideoCommand(){//插入服务器浏览Flash视频命令
	this.name="FlashVideo";
	this.Execute=function(){
		window.parent.FCKEditorExt.flashVideoDialog();
	};
	this.GetState=function(){return 0;};
}
/*******************************************/
function FCKCustomFlashCommand(){//插入自定义Flash框命令



	this.name='CustomFlash';
	this.Execute=function(){
		var oFakeImage = FCK.Selection.GetSelectedElement() ;
		var oEmbed=null;
		if ( oFakeImage ){
			if ( oFakeImage.tagName == 'IMG' && oFakeImage.getAttribute('_fckflash') )
				oEmbed = FCK.GetRealElement( oFakeImage ) ;
			else
				oFakeImage = null ;
		}
		window.parent.FCKEditorExt.showFlashDialog(oFakeImage,oEmbed);
		/*
		var oFakeImage = FCK.Selection.GetSelectedElement() ;
		var oEmbed=null;
		if ( oFakeImage ){
			if ( oFakeImage.tagName == 'IMG' && oFakeImage.getAttribute('_fckflash') )
				oEmbed = FCK.GetRealElement( oFakeImage ) ;
			else
				oFakeImage = null ;
		}
		var fUrl=(oEmbed==null)?"":oEmbed.src;
		fUrl=prompt("请输入Flash地址，如：http://www.flash8.com/demo.swf",fUrl);
		if(fUrl==undefined || fUrl=="")return;
		else{
			oEmbed=(oEmbed==null)?FCK.EditorDocument.createElement( 'EMBED' ):oEmbed;
			oEmbed.src=fUrl;
			oFakeImage=(oFakeImage==null)?FCKDocumentProcessor_CreateFakeImage('FCK__Flash',oEmbed):oFakeImage;
			oFakeImage.setAttribute('_fckflash', 'true',0) ;
			oFakeImage	= FCK.InsertElementAndGetIt(oFakeImage);
			FCKFlashProcessor.RefreshView(oFakeImage,oEmbed);
		}
		*/
	};
	this.GetState=function(){return 0;};
}

function FCKFormSplitPageCommand(){//表单分页
	this.name='FormSplitPage';
	this.Execute=function(){
		var innerHTML = "<div class=\"formSplitPage\" align=\"center\" style=\"border-bottom:1px #A1A1A1 solid; border-top:1px #A1A1A1 solid;border-left:opx;border-right:opx;page-break-after: always\">"+FCKLang.InsertFormSplitPage+"</div>";
		window.parent.FCKEditorExt.insertHtml(innerHTML, "layouttext");
	};
	this.GetState=function(){return 0;};
}

function FCKFieldShowAttr1(){
	this.name='FieldShowAttr1';
	this.Execute=function(){
		var fieldid = selectTag.id.substr(6);
		fieldid = fieldid.substr(0, fieldid.indexOf("$"));
		var fieldShowAttr = window.parent.document.getElementById("fieldattr"+fieldid).value = "1";
		window.parent.onchangefieldattrFromFck(fieldid,"1");
	};
	this.GetState=function(){return 0;};
}
function FCKFieldShowAttr2(){
	this.name='FieldShowAttr2';
	this.Execute=function(){
		var fieldid = selectTag.id.substr(6);
		fieldid = fieldid.substr(0, fieldid.indexOf("$"));
		var fieldShowAttr = window.parent.document.getElementById("fieldattr"+fieldid).value = "2";
		window.parent.onchangefieldattrFromFck(fieldid,"2");
	};
	this.GetState=function(){return 0;};
}
function FCKFieldShowAttr3(){
	this.name='FieldShowAttr3';
	this.Execute=function(){
		var fieldid = selectTag.id.substr(6);
		fieldid = fieldid.substr(0, fieldid.indexOf("$"));
		var fieldShowAttr = window.parent.document.getElementById("fieldattr"+fieldid).value = "3";
		window.parent.onchangefieldattrFromFck(fieldid,"3");
	};
	this.GetState=function(){return 0;};
}

function FieldAttributeListener(){
	//只有字段才有SQL属性，显示名没有

	return{
		AddItems : function( menu, tag, tagName ){
			try{
				if ( tagName == 'INPUT' && ( tag.type == 'text' || tag.type == 'password' ) && tag.id.indexOf("$field")==0 && tag.id!="$field-4$"){
					menu.AddSeparator() ;
					menu.AddItem( 'FieldAttribute', FCKLang.FieldAttribute, 51 ) ;
					menu.AddItem( 'FieldAttributeMore', FCKLang.FieldAttributeMore, 51 ) ;
				}
			}catch(e){}
			try{
				var fieldid = tag.id.substr(6);
				fieldid = fieldid.substr(0, fieldid.indexOf("$"));
				var canFieldEdit = window.parent.document.getElementById("canFieldEdit").value;
				var especialFieldids = window.parent.document.getElementById("especialFieldids").value;
				var index_eFieldids = (","+especialFieldids+",").indexOf(","+fieldid+",");
				if(canFieldEdit=="1" && index_eFieldids==-1){
					if ( tagName == 'INPUT' && ( tag.type == 'text' || tag.type == 'password' ) && tag.id.indexOf("$field")==0 && tag.id!="$field-4$"){
						var fieldShowAttr = window.parent.document.getElementById("fieldattr"+fieldid).value;
						selectTag = tag;
						if(fieldShowAttr=="1"){
							menu.AddSeparator() ;
							menu.AddItem( 'FieldShowAttr1', FCKLang.FieldShowAttr1, 49 ) ;
							menu.AddItem( 'FieldShowAttr2', FCKLang.FieldShowAttr2, 1 ) ;
							menu.AddItem( 'FieldShowAttr3', FCKLang.FieldShowAttr3, 1 ) ;
						}else if(fieldShowAttr=="2"){
							menu.AddSeparator() ;
							menu.AddItem( 'FieldShowAttr1', FCKLang.FieldShowAttr1, 1 ) ;
							menu.AddItem( 'FieldShowAttr2', FCKLang.FieldShowAttr2, 49 ) ;
							menu.AddItem( 'FieldShowAttr3', FCKLang.FieldShowAttr3, 1 ) ;
						}else if(fieldShowAttr=="3"){
							menu.AddSeparator() ;
							menu.AddItem( 'FieldShowAttr1', FCKLang.FieldShowAttr1, 1 ) ;
							menu.AddItem( 'FieldShowAttr2', FCKLang.FieldShowAttr2, 1 ) ;
							menu.AddItem( 'FieldShowAttr3', FCKLang.FieldShowAttr3, 49 ) ;
						}
					}
				}
			}catch(e){}
		}
	};
}
var FCKDialogCommandNew=function(A,B,C,D,E,F,G){
	this.Name=A;
	this.Title=B;
	this.Url=C;
	this.Width=D;
	this.Height=E;
	this.GetStateFunction=F;
	this.GetStateParam=G;
	this.Resizable=false;
};
FCKDialogCommandNew.prototype.Execute=function(){
	FCKDialogNew.OpenDialog('FCKDialog_'+this.Name,this.Title,this.Url,this.Width,this.Height,null,null,this.Resizable);
};
FCKDialogCommandNew.prototype.GetState=function(){
	if (this.GetStateFunction){
		return this.GetStateFunction(this.GetStateParam);
	}else{
		return 0;
	}
};

var FCKUndefinedCommandNew=function(){
	this.Name='Undefined';
};
FCKUndefinedCommandNew.prototype.Execute=function(){
	alert(FCKLang.NotImplemented);
};
FCKUndefinedCommandNew.prototype.GetState=function(){
	return 0;
};
	
	

var FCKDialogNew={};
FCKDialogNew.OpenDialog=function(A,B,C,D,E,F,G,H){
	var I={};
	I.Title=B;
	I.Page=C;
	I.Editor=window;
	I.CustomValue=F;
	I.FrameWindow=window.parent;
	var J=FCKConfig.BasePath+'fckdialog.html';
	this.Show(I,A,J,D,E,G,H);
};
FCKDialogNew.Show=function(A,B,C,D,E,F,G){
	if (!F){
		F=window;
	}
	var H='help:no;scroll:no;status:no;resizable:'+(G?'yes':'no')+';dialogWidth:'+D+'px;dialogHeight:'+E+'px';
	FCKFocusManager.Lock();
	var I='B';
	try{
		I=F.showModalDialog(C,A,H);
	}catch(e) {};
	if ('B'===I){
		alert(FCKLang.DialogBlocked);
	}
	FCKFocusManager.Unlock();
};

FCKCommands.RegisterCommand('CustomImage',new FCKCustomImageCommand());//注册命令
FCKCommands.RegisterCommand('Video',new FCKVideoCommand());
FCKCommands.RegisterCommand('CustomFlash',new FCKCustomFlashCommand());
FCKCommands.RegisterCommand('FlashVideo',new FCKFlashVideoCommand());
/*
FCKCommands.RegisterCommand('FieldAttribute',new FCKDialogCommandNew('FieldAttribute',FCKLang.FieldAttribute,'dialog/fck_fieldattr.jsp',600,520));
FCKCommands.RegisterCommand('FieldAttributeMore',new FCKDialogCommandNew('FieldAttributeMore',FCKLang.FieldAttributeMore,'dialog/fck_fieldattrMore.jsp',600,520));
*/

FCKToolbarItems.RegisterItem('CustomImage',new FCKToolbarButton( 'CustomImage',	FCKLang.CustomImage,
																null,null, false, true, 37 ));
FCKToolbarItems.RegisterItem('Video',new FCKToolbarButton( 'Video',	FCKLang.Video,
														  null,null, false, true, 67 ));
FCKToolbarItems.RegisterItem('CustomFlash',new FCKToolbarButton( 'CustomFlash',	FCKLang.CustomFlash,
																null,null, false, true, 38 ));
FCKToolbarItems.RegisterItem('FlashVideo',new FCKToolbarButton( 'FlashVideo',	FCKLang.FlashVideo,
																null,null, false, true, 68 ));
//字段属性的右键菜单
/*
FCK.ContextMenu.RegisterListener(FieldAttributeListener());
FCKCommands.RegisterCommand('FormSplitPage',new FCKFormSplitPageCommand());
FCKToolbarItems.RegisterItem('FormSplitPage',new FCKToolbarButton( 'FormSplitPage',	FCKLang.FormSplitPage, null,null, false, true, 40 )); 
*/


//可是用右键设置字段显示属性 
/*
FCKCommands.RegisterCommand('FieldShowAttr1',new FCKFieldShowAttr1());
FCKCommands.RegisterCommand('FieldShowAttr2',new FCKFieldShowAttr2());
FCKCommands.RegisterCommand('FieldShowAttr3',new FCKFieldShowAttr3()); 
*/
}
