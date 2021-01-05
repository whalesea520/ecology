if(languageid==9){
//繁体	
(function (KE, undefined) {
KE.langType = 'zh_TW';
KE.lang = {
	source : '原始碼',
	undo : '復原(Ctrl+Z)',
	redo : '重複(Ctrl+Y)',
	cut : '剪下(Ctrl+X)',
	copy : '複製(Ctrl+C)',
	paste : '貼上(Ctrl+V)',
	plainpaste : '貼為純文字格式',
	wordpaste : '自Word貼上',
	selectall : '全選',
	justifyleft : '靠左對齊',
	justifycenter : '置中',
	justifyright : '靠右對齊',
	justifyfull : '左右對齊',
	insertorderedlist : '編號清單',
	insertunorderedlist : '項目清單',
	indent : '增加縮排',
	outdent : '減少縮排',
	subscript : '下標',
	superscript : '上標',
	title : '標題',
	fontname : '字體',
	fontsize : '文字大小',
	textcolor : '文字顏色',
	bgcolor : '背景顏色',
	bold : '粗體',
	italic : '斜體',
	underline : '底線',
	strikethrough : '刪除線',
	removeformat : '清除格式',
	image : '影像',
	flash : '插入Flash',
	media : '插入多媒體',
	table : '插入表格',
	hr : '插入水平線',
	emoticons : '插入表情',
	link : '超連結',
	unlink : '移除超連結',
	fullscreen : '最大化',
	about : '關於',
	print : '列印',
	fileManager : '瀏覽伺服器',
	advtable : '表格',
	yes : '確定',
	no : '取消',
	close : '關閉',
	editImage : '影像屬性',
	deleteImage : '刪除影像',
	editLink : '超連結屬性',
	deleteLink : '移除超連結',
	tableprop : '表格屬性',
	tableinsert : '插入表格',
	tabledelete : '刪除表格',
	tablecolinsertleft : '向左插入列',
	tablecolinsertright : '向右插入列',
	tablerowinsertabove : '向上插入欄',
	tablerowinsertbelow : '下方插入欄',
	tablecoldelete : '删除列',
	tablerowdelete : '删除欄',
	noColor : '自動',
	invalidImg : "請輸入有效的URL。\n只允許jpg,gif,bmp,png格式。",
	invalidMedia : "請輸入有效的URL。\n只允許swf,flv,mp3,wav,wma,wmv,mid,avi,mpg,asf,rm,rmvb格式。",
	invalidWidth : "寬度必須是數字。",
	invalidHeight : "高度必須是數字。",
	invalidBorder : "邊框必須是數字。",
	invalidUrl : "請輸入有效的URL。",
	invalidRows : '欄數是必須輸入項目，只允許輸入大於0的數字。',
	invalidCols : '列數是必須輸入項目，只允許輸入大於0的數字。',
	invalidPadding : '內距必須是數字。',
	invalidSpacing : '間距必須是數字。',
	invalidBorder : '边框必须为数字。',
	pleaseInput : "請輸入內容。",
	invalidJson : '伺服器發生故障。',
	cutError : '您的瀏覽器安全設置不允許使用剪下操作，請使用快捷鍵(Ctrl+X)完成。',
	copyError : '您的瀏覽器安全設置不允許使用剪下操作，請使用快捷鍵(Ctrl+C)完成。',
	pasteError : '您的瀏覽器安全設置不允許使用剪下操作，請使用快捷鍵(Ctrl+V)完成。'
};

var plugins = KE.lang.plugins = {};

plugins.about = {
	version : KE.version,
	title : 'HTML可視化編輯器'
};

plugins.plainpaste = {
	comment : '請使用快捷鍵(Ctrl+V)把內容貼到下方區域裡。'
};

plugins.wordpaste = {
	comment : '請使用快捷鍵(Ctrl+V)把內容貼到下方區域裡。'
};

plugins.link = {
	url : 'URL',
	linkType : '打開類型',
	newWindow : '新窗口',
	selfWindow : '本頁窗口'
};

plugins.flash = {
	url : 'URL',
	width : '寬度',
	height : '高度'
};

plugins.media = {
	url : 'URL',
	width : '寬度',
	height : '高度',
	autostart : '自動播放'
};

plugins.image = {
	remoteImage : '影像URL',
	localImage : '上傳影像',
	remoteUrl : '影像URL',
	localUrl : '影像URL',
	size : '影像大小',
	width : '寬度',
	height : '高度',
	resetSize : '原始大小',
	align : '對齊方式',
	defaultAlign : '未設定',
	leftAlign : '向左對齊',
	rightAlign : '向右對齊',
	imgTitle : '影像說明',
	viewServer : '瀏覽...'
};

plugins.file_manager = {
	emptyFolder : '空文件夾',
	moveup : '至上一級文件夾',
	viewType : '顯示方式：',
	viewImage : '縮略圖',
	listImage : '詳細信息',
	orderType : '排序方式：',
	fileName : '名稱',
	fileSize : '大小',
	fileType : '類型'
};

plugins.advtable = {
	cells : '儲存格數',
	rows : '欄數',
	cols : '列數',
	size : '表格大小',
	width : '寬度',
	height : '高度',
	percent : '%',
	px : 'px',
	space : '內距間距',
	padding : '內距',
	spacing : '間距',
	align : '對齊方式',
	alignDefault : '未設定',
	alignLeft : '向左對齊',
	alignCenter : '置中',
	alignRight : '向右對齊',
	border : '表格邊框',
	borderWidth : '邊框',
	borderColor : '顏色',
	backgroundColor : '背景顏色'
};

plugins.title = {
	h1 : '標題 1',
	h2 : '標題 2',
	h3 : '標題 3',
	h4 : '標題 4',
	p : '一般'
};

plugins.fontname = {
	fontName : {
		'MingLiU' : '細明體',
		'PMingLiU' : '新細明體',
		'DFKai-SB' : '標楷體',
		'SimSun' : '宋體',
		'NSimSun' : '新宋體',
		'FangSong' : '仿宋體',
		'Arial' : 'Arial',
		'Arial Black' : 'Arial Black',
		'Times New Roman' : 'Times New Roman',
		'Courier New' : 'Courier New',
		'Tahoma' : 'Tahoma',
		'Verdana' : 'Verdana'
	}
};

})(KindEditor);
//英文
}else if(languageid==8){
  	
 (function (KE, undefined) {

KE.langType = 'en';

KE.lang = {
	source : 'Source',
	undo : 'Undo(Ctrl+Z)',
	redo : 'Redo(Ctrl+Y)',
	cut : 'Cut(Ctrl+X)',
	copy : 'Copy(Ctrl+C)',
	paste : 'Paste(Ctrl+V)',
	plainpaste : 'Paste as plain text',
	wordpaste : 'Paste from Word',
	selectall : 'Select all',
	justifyleft : 'Align left',
	justifycenter : 'Align center',
	justifyright : 'Align right',
	justifyfull : 'Align full',
	insertorderedlist : 'Ordered list',
	insertunorderedlist : 'Unordered list',
	indent : 'Increase indent',
	outdent : 'Decrease indent',
	subscript : 'Subscript',
	superscript : 'Superscript',
	title : 'Paragraph format',
	fontname : 'Font family',
	fontsize : 'Font size',
	textcolor : 'Text color',
	bgcolor : 'Highlight color',
	bold : 'Bold',
	italic : 'Italic',
	underline : 'Underline',
	strikethrough : 'Strikethrough',
	removeformat : 'Remove format',
	image : 'Image',
	flash : 'Insert Flash',
	media : 'Insert embeded media',
	table : 'Insert table',
	hr : 'Insert horizontal line',
	emoticons : 'Insert emoticon',
	link : 'Link',
	unlink : 'Unlink',
	fullscreen : 'Toggle fullscreen mode',
	about : 'About',
	print : 'Print',
	fileManager : 'File Manager',
	advtable : 'Table',
	yes : 'OK',
	no : 'Cancel',
	close : 'Close',
	editImage : 'Image properties',
	deleteImage : 'Delete image',
	editLink : 'Link properties',
	deleteLink : 'Unlink',
	tableprop : 'Table properties',
	tableinsert : 'Insert table',
	tabledelete : 'Delete table',
	tablecolinsertleft : 'Insert column left',
	tablecolinsertright : 'Insert column right',
	tablerowinsertabove : 'Insert row above',
	tablerowinsertbelow : 'Insert row below',
	tablecoldelete : 'Delete column',
	tablerowdelete : 'Delete row',
	noColor : 'Default',
	invalidImg : "Please type valid URL.\nAllowed file extension: jpg,gif,bmp,png",
	invalidMedia : "Please type valid URL.\nAllowed file extension: swf,flv,mp3,wav,wma,wmv,mid,avi,mpg,asf,rm,rmvb",
	invalidWidth : "The width must be number.",
	invalidHeight : "The height must be number.",
	invalidBorder : "The border must be number.",
	invalidUrl : "Please type valid URL.",
	invalidRows : 'Invalid rows.',
	invalidCols : 'Invalid columns.',
	invalidPadding : 'The padding must be number.',
	invalidSpacing : 'The spacing must be number.',
	invalidBorder : 'The border width must be number.',
	pleaseInput : "Please type content.",
	invalidJson : 'Invalid JSON string.',
	cutError : 'Currently not supported by your browser, use keyboard shortcut(Ctrl+X) instead.',
	copyError : 'Currently not supported by your browser, use keyboard shortcut(Ctrl+C) instead.',
	pasteError : 'Currently not supported by your browser, use keyboard shortcut(Ctrl+V) instead.'
};

var plugins = KE.lang.plugins = {};

plugins.about = {
	version : KE.version,
	title : 'WYSIWYG Editor'
};

plugins.plainpaste = {
	comment : 'Use keyboard shortcut(Ctrl+V) to paste the text into the window.'
};

plugins.wordpaste = {
	comment : 'Use keyboard shortcut(Ctrl+V) to paste the text into the window.'
};

plugins.link = {
	url : 'Link URL',
	linkType : 'Target',
	newWindow : 'New window',
	selfWindow : 'Same window'
};

plugins.flash = {
	url : 'Flash URL',
	width : 'Width',
	height : 'Height'
};

plugins.media = {
	url : 'Media URL',
	width : 'Width',
	height : 'Height',
	autostart : 'Auto start'
};

plugins.image = {
	remoteImage : 'Insert URL',
	localImage : 'Upload',
	remoteUrl : 'Image URL',
	localUrl : 'Image File',
	size : 'Dimensions',
	width : 'Width',
	height : 'Height',
	resetSize : 'Reset dimensions',
	align : 'Align',
	defaultAlign : 'Default',
	leftAlign : 'Left',
	rightAlign : 'Right',
	imgTitle : 'Title',
	viewServer : 'Browse'
};

plugins.file_manager = {
	emptyFolder : 'Blank',
	moveup : 'Parent folder',
	viewType : 'Display: ',
	viewImage : 'Thumbnails',
	listImage : 'List',
	orderType : 'Sorting: ',
	fileName : 'By name',
	fileSize : 'By size',
	fileType : 'By type'
};

plugins.advtable = {
	cells : 'Cells',
	rows : 'Rows',
	cols : 'Columns',
	size : 'Dimensions',
	width : 'Width',
	height : 'Height',
	percent : '%',
	px : 'px',
	space : 'Space',
	padding : 'Padding',
	spacing : 'Spacing',
	align : 'Align',
	alignDefault : 'Default',
	alignLeft : 'Left',
	alignCenter : 'Center',
	alignRight : 'Right',
	border : 'Border',
	borderWidth : 'Width',
	borderColor : 'Color',
	backgroundColor : 'Background'
};

plugins.title = {
	h1 : 'Heading 1',
	h2 : 'Heading 2',
	h3 : 'Heading 3',
	h4 : 'Heading 4',
	p : 'Normal'
};

plugins.fontname = {
	fontName : {
		'Arial' : 'Arial',
		'Arial Black' : 'Arial Black',
		'Comic Sans MS' : 'Comic Sans MS',
		'Courier New' : 'Courier New',
		'Garamond' : 'Garamond',
		'Georgia' : 'Georgia',
		'Tahoma' : 'Tahoma',
		'Times New Roman' : 'Times New Roman',
		'Trebuchet MS' : 'Trebuchet MS',
		'Verdana' : 'Verdana'
	}
};

})(KindEditor);	
	
	
}else{
//中文
(function (KE, undefined) {

KE.langType = 'zh_CN';

KE.lang = {
	source : 'HTML代码',
	undo : '后退(Ctrl+Z)',
	redo : '前进(Ctrl+Y)',
	cut : '剪切(Ctrl+X)',
	copy : '复制(Ctrl+C)',
	paste : '粘贴(Ctrl+V)',
	plainpaste : '粘贴为无格式文本',
	wordpaste : '从Word粘贴',
	selectall : '全选',
	justifyleft : '左对齐',
	justifycenter : '居中',
	justifyright : '右对齐',
	justifyfull : '两端对齐',
	insertorderedlist : '编号',
	insertunorderedlist : '项目符号',
	indent : '增加缩进',
	outdent : '减少缩进',
	subscript : '下标',
	superscript : '上标',
	title : '标题',
	fontname : '字体',
	fontsize : '文字大小',
	textcolor : '文字颜色',
	bgcolor : '文字背景',
	bold : '粗体',
	italic : '斜体',
	underline : '下划线',
	strikethrough : '删除线',
	removeformat : '删除格式',
	image : '图片',
	flash : '插入Flash',
	media : '插入多媒体',
	table : '插入表格',
	hr : '插入横线',
	emoticons : '插入表情',
	link : '超级链接',
	unlink : '取消超级链接',
	fullscreen : '全屏显示',
	about : '关于',
	print : '打印',
	fileManager : '浏览服务器',
	advtable : '表格',
	yes : '确定',
	no : '取消',
	close : '关闭',
	editImage : '图片属性',
	deleteImage : '删除图片',
	editLink : '超级链接属性',
	deleteLink : '取消超级链接',
	tableprop : '表格属性',
	tableinsert : '插入表格',
	tabledelete : '删除表格',
	tablecolinsertleft : '左侧插入列',
	tablecolinsertright : '右侧插入列',
	tablerowinsertabove : '上方插入行',
	tablerowinsertbelow : '下方插入行',
	tablecoldelete : '删除列',
	tablerowdelete : '删除行',
	noColor : '无颜色',
	invalidImg : "请输入有效的URL地址。\n只允许jpg,gif,bmp,png格式。",
	invalidMedia : "请输入有效的URL地址。\n只允许swf,flv,mp3,wav,wma,wmv,mid,avi,mpg,asf,rm,rmvb格式。",
	invalidWidth : "宽度必须为数字。",
	invalidHeight : "高度必须为数字。",
	invalidBorder : "边框必须为数字。",
	invalidUrl : "请输入有效的URL地址。",
	invalidRows : '行数为必选项，只允许输入大于0的数字。',
	invalidCols : '列数为必选项，只允许输入大于0的数字。',
	invalidPadding : '边距必须为数字。',
	invalidSpacing : '间距必须为数字。',
	invalidBorder : '边框必须为数字。',
	pleaseInput : "请输入内容。",
	invalidJson : '服务器发生故障。',
	cutError : '您的浏览器安全设置不允许使用剪切操作，请使用快捷键(Ctrl+X)来完成。',
	copyError : '您的浏览器安全设置不允许使用复制操作，请使用快捷键(Ctrl+C)来完成。',
	pasteError : '您的浏览器安全设置不允许使用粘贴操作，请使用快捷键(Ctrl+V)来完成。'
};

var plugins = KE.lang.plugins = {};

plugins.about = {
	version : KE.version,
	title : 'HTML可视化编辑器'
};

plugins.plainpaste = {
	comment : '请使用快捷键(Ctrl+V)把内容粘贴到下面的方框里。'
};

plugins.wordpaste = {
	comment : '请使用快捷键(Ctrl+V)把内容粘贴到下面的方框里。'
};

plugins.link = {
	url : 'URL地址',
	linkType : '打开类型',
	newWindow : '新窗口',
	selfWindow : '当前窗口'
};

plugins.flash = {
	url : 'Flash地址',
	width : '宽度',
	height : '高度'
};

plugins.media = {
	url : '媒体文件地址',
	width : '宽度',
	height : '高度',
	autostart : '自动播放'
};

plugins.image = {
	remoteImage : '远程图片',
	localImage : '本地上传',
	remoteUrl : '图片地址',
	localUrl : '图片地址',
	size : '图片大小',
	width : '宽',
	height : '高',
	resetSize : '重置大小',
	align : '对齐方式',
	defaultAlign : '默认方式',
	leftAlign : '左对齐',
	rightAlign : '右对齐',
	imgTitle : '图片说明',
	viewServer : '浏览...'
};

plugins.file_manager = {
	emptyFolder : '空文件夹',
	moveup : '移到上一级文件夹',
	viewType : '显示方式：',
	viewImage : '缩略图',
	listImage : '详细信息',
	orderType : '排序方式：',
	fileName : '名称',
	fileSize : '大小',
	fileType : '类型'
};

plugins.advtable = {
	cells : '单元格数',
	rows : '行数',
	cols : '列数',
	size : '表格大小',
	width : '宽度',
	height : '高度',
	percent : '%',
	px : 'px',
	space : '边距间距',
	padding : '边距',
	spacing : '间距',
	align : '对齐方式',
	alignDefault : '默认',
	alignLeft : '左对齐',
	alignCenter : '居中',
	alignRight : '右对齐',
	border : '表格边框',
	borderWidth : '边框',
	borderColor : '颜色',
	backgroundColor : '背景颜色'
};

plugins.title = {
	h1 : '标题 1',
	h2 : '标题 2',
	h3 : '标题 3',
	h4 : '标题 4',
	p : '正 文'
};

plugins.fontname = {
	fontName : {
		'SimSun' : '宋体',
		'NSimSun' : '新宋体',
		'FangSong_GB2312' : '仿宋_GB2312',
		'KaiTi_GB2312' : '楷体_GB2312',
		'SimHei' : '黑体',
		'Microsoft YaHei' : '微软雅黑',
		'Arial' : 'Arial',
		'Arial Black' : 'Arial Black',
		'Times New Roman' : 'Times New Roman',
		'Courier New' : 'Courier New',
		'Tahoma' : 'Tahoma',
		'Verdana' : 'Verdana'
	}
};

})(KindEditor);	
	
}		