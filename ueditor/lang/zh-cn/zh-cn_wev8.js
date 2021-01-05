/**
 * Created with JetBrains PhpStorm.
 * User: taoqili
 * Date: 12-6-12
 * Time: 下午5:02
 * To change this template use File | Settings | File Templates.
 */
UE.I18N['zh-cn'] = {};

function __initUEditorLang__(){
	try{
		 UE.I18N['zh-cn'] = {
			'labelMap':{
				'anchor':SystemEnv.getHtmlNoteName(3664), 'undo':SystemEnv.getHtmlNoteName(3665), 'redo':SystemEnv.getHtmlNoteName(3666), 'bold':SystemEnv.getHtmlNoteName(3667), 'indent':SystemEnv.getHtmlNoteName(3668), 'snapscreen':SystemEnv.getHtmlNoteName(3669),
				'italic':SystemEnv.getHtmlNoteName(3670), 'underline':SystemEnv.getHtmlNoteName(3672), 'strikethrough':SystemEnv.getHtmlNoteName(3673), 'subscript':SystemEnv.getHtmlNoteName(3674),'fontborder':SystemEnv.getHtmlNoteName(3684),
				'superscript':SystemEnv.getHtmlNoteName(3703), 'formatmatch':SystemEnv.getHtmlNoteName(3705), 'source':SystemEnv.getHtmlNoteName(3708), 'blockquote':SystemEnv.getHtmlNoteName(3709),
				'pasteplain':SystemEnv.getHtmlNoteName(3710), 'selectall':SystemEnv.getHtmlNoteName(3443), 'print':SystemEnv.getHtmlNoteName(3711), 'preview':SystemEnv.getHtmlNoteName(3712),
				'horizontal':SystemEnv.getHtmlNoteName(3713), 'removeformat':SystemEnv.getHtmlNoteName(3714), 'time':SystemEnv.getHtmlNoteName(3706), 'date':SystemEnv.getHtmlNoteName(3715),
				'unlink':SystemEnv.getHtmlNoteName(3716), 'insertrow':SystemEnv.getHtmlNoteName(3717), 'insertcol':SystemEnv.getHtmlNoteName(3718), 'mergeright':SystemEnv.getHtmlNoteName(3719), 'mergedown':SystemEnv.getHtmlNoteName(3720),
				'deleterow':SystemEnv.getHtmlNoteName(3576), 'deletecol':SystemEnv.getHtmlNoteName(3721), 'splittorows':SystemEnv.getHtmlNoteName(3721),
				'splittocols':SystemEnv.getHtmlNoteName(3726), 'splittocells':SystemEnv.getHtmlNoteName(3735),'deletecaption':SystemEnv.getHtmlNoteName(3736),'inserttitle':SystemEnv.getHtmlNoteName(3737),
				'mergecells':SystemEnv.getHtmlNoteName(3738), 'deletetable':SystemEnv.getHtmlNoteName(3739), 'cleardoc':SystemEnv.getHtmlNoteName(3740),'insertparagraphbeforetable':SystemEnv.getHtmlNoteName(3741),'insertcode':SystemEnv.getHtmlNoteName(3742),
				'fontfamily':SystemEnv.getHtmlNoteName(3743), 'fontsize':SystemEnv.getHtmlNoteName(3744), 'paragraph':SystemEnv.getHtmlNoteName(3745), 'simpleupload':SystemEnv.getHtmlNoteName(3746), 'insertimage':SystemEnv.getHtmlNoteName(3747),'edittable':SystemEnv.getHtmlNoteName(3748),'edittd':SystemEnv.getHtmlNoteName(3749), 'link':SystemEnv.getHtmlNoteName(3750),
				'emotion':SystemEnv.getHtmlNoteName(3751), 'spechars':SystemEnv.getHtmlNoteName(3752), 'searchreplace':SystemEnv.getHtmlNoteName(3753), 'map':SystemEnv.getHtmlNoteName(3754), 'gmap':SystemEnv.getHtmlNoteName(3755),
				'insertvideo':SystemEnv.getHtmlNoteName(3756), 'help':SystemEnv.getHtmlNoteName(3757), 'justifyleft':SystemEnv.getHtmlNoteName(3758), 'justifyright':SystemEnv.getHtmlNoteName(3759), 'justifycenter':SystemEnv.getHtmlNoteName(3760),
				'justifyjustify':SystemEnv.getHtmlNoteName(3761), 'forecolor':SystemEnv.getHtmlNoteName(3762), 'backcolor':SystemEnv.getHtmlNoteName(3763), 'insertorderedlist':SystemEnv.getHtmlNoteName(3764),
				'insertunorderedlist':SystemEnv.getHtmlNoteName(3765), 'fullscreen':SystemEnv.getHtmlNoteName(3766), 'directionalityltr':SystemEnv.getHtmlNoteName(3767), 'directionalityrtl':SystemEnv.getHtmlNoteName(3768),
				'rowspacingtop':SystemEnv.getHtmlNoteName(3769), 'rowspacingbottom':SystemEnv.getHtmlNoteName(3770),  'pagebreak':SystemEnv.getHtmlNoteName(3771), 'insertframe':SystemEnv.getHtmlNoteName(3772), 'imagenone':SystemEnv.getHtmlNoteName(3773),
				'imageleft':SystemEnv.getHtmlNoteName(3774), 'imageright':SystemEnv.getHtmlNoteName(3775), 'attachment':SystemEnv.getHtmlNoteName(3776), 'imagecenter':SystemEnv.getHtmlNoteName(3777), 'wordimage':SystemEnv.getHtmlNoteName(3778),
				'lineheight':SystemEnv.getHtmlNoteName(3779),'edittip' :SystemEnv.getHtmlNoteName(3780),'customstyle':SystemEnv.getHtmlNoteName(3781), 'autotypeset':SystemEnv.getHtmlNoteName(3782),
				'webapp':SystemEnv.getHtmlNoteName(3783),'touppercase':SystemEnv.getHtmlNoteName(3784), 'tolowercase':SystemEnv.getHtmlNoteName(3785),'background':SystemEnv.getHtmlNoteName(3786),'template':SystemEnv.getHtmlNoteName(3788),'scrawl':SystemEnv.getHtmlNoteName(3789),
				'music':SystemEnv.getHtmlNoteName(3789),'inserttable':SystemEnv.getHtmlNoteName(3791),'drafts': SystemEnv.getHtmlNoteName(3792), 'charts': SystemEnv.getHtmlNoteName(3793)
			},
			'insertorderedlist':{
				'num':'1,2,3...',
				'num1':'1),2),3)...',
				'num2':'(1),(2),(3)...',
				'cn':'一,二,三....',
				'cn1':'一),二),三)....',
				'cn2':'(一),(二),(三)....',
				'decimal':'1,2,3...',
				'lower-alpha':'a,b,c...',
				'lower-roman':'i,ii,iii...',
				'upper-alpha':'A,B,C...',
				'upper-roman':'I,II,III...'
			},
			'insertunorderedlist':{
				'circle':'○ '+SystemEnv.getHtmlNoteName(3791),
				'disc':'● '+SystemEnv.getHtmlNoteName(3795),
				'square':'■  '+SystemEnv.getHtmlNoteName(3796),
				'dash' :'— '+SystemEnv.getHtmlNoteName(3797),
				'dot':' 。 '+SystemEnv.getHtmlNoteName(3798)
			},
			'paragraph':{'p':SystemEnv.getHtmlNoteName(3799), 'h1':SystemEnv.getHtmlNoteName(3534)+' 1', 'h2':SystemEnv.getHtmlNoteName(3534)+' 2', 'h3':SystemEnv.getHtmlNoteName(3534)+' 3', 'h4':SystemEnv.getHtmlNoteName(3534)+' 4', 'h5':SystemEnv.getHtmlNoteName(3534)+' 5', 'h6':SystemEnv.getHtmlNoteName(3534)+' 6'},
			'fontfamily':{
				'fangsonggb2312':SystemEnv.getHtmlNoteName(3800),
				'songti':SystemEnv.getHtmlNoteName(3801),
				'kaiti':SystemEnv.getHtmlNoteName(3802),
				'heiti':SystemEnv.getHtmlNoteName(3803),
				'lishu':SystemEnv.getHtmlNoteName(3804),
				'yahei':SystemEnv.getHtmlNoteName(3805),
				'andaleMono':'andale mono',
				'arial': 'arial',
				'arialBlack':'arial black',
				'comicSansMs':'comic sans ms',
				'impact':'impact',
				'timesNewRoman':'times new roman',
				'Helvetica':'Helvetica',
				'Times':'Times',
				'Verdana':'Verdana',
				'xinsongti':SystemEnv.getHtmlNoteName(3806),
				'kaitigb2312':SystemEnv.getHtmlNoteName(3807)
			},
			'customstyle':{
				'tc':SystemEnv.getHtmlNoteName(3808),
				'tl':SystemEnv.getHtmlNoteName(3809),
				'im':SystemEnv.getHtmlNoteName(3810),
				'hi':SystemEnv.getHtmlNoteName(3811)
			},
			'autoupload': {
				'exceedSizeError': SystemEnv.getHtmlNoteName(3812),
				'exceedTypeError': SystemEnv.getHtmlNoteName(3813),
				'jsonEncodeError': SystemEnv.getHtmlNoteName(3814),
				'loading':SystemEnv.getHtmlNoteName(3815),
				'loadError':SystemEnv.getHtmlNoteName(3816),
				'errorLoadConfig': SystemEnv.getHtmlNoteName(3817)
			},
			'simpleupload':{
				'exceedSizeError': SystemEnv.getHtmlNoteName(3812),
				'exceedTypeError': SystemEnv.getHtmlNoteName(3813),
				'jsonEncodeError': SystemEnv.getHtmlNoteName(3814),
				'loading':SystemEnv.getHtmlNoteName(3815),
				'loadError':SystemEnv.getHtmlNoteName(3816),
				'errorLoadConfig': SystemEnv.getHtmlNoteName(3817)
			},
			'elementPathTip':SystemEnv.getHtmlNoteName(3818),
			'wordCountTip':SystemEnv.getHtmlNoteName(3819),
			'wordCountMsg':'当前已输入{#count}个字符, 您还可以输入{#leave}个字符。 ',
			'wordOverFlowMsg':'<span style="color:red;">'+SystemEnv.getHtmlNoteName(3820)+'</span>',
			'ok':SystemEnv.getHtmlNoteName(3821),
			'cancel':SystemEnv.getHtmlNoteName(3516),
			'closeDialog':SystemEnv.getHtmlNoteName(3822),
			'tableDrag':SystemEnv.getHtmlNoteName(3823),
			'autofloatMsg':SystemEnv.getHtmlNoteName(3824),
			'loadconfigError': SystemEnv.getHtmlNoteName(3825),
			'loadconfigFormatError': SystemEnv.getHtmlNoteName(3826),
			'loadconfigHttpError': SystemEnv.getHtmlNoteName(3827),
			'snapScreen_plugin':{
				'browserMsg':SystemEnv.getHtmlNoteName(3828),
				'callBackErrorMsg':SystemEnv.getHtmlNoteName(3829),
				'uploadErrorMsg':SystemEnv.getHtmlNoteName(3830)
			},
			'insertcode':{
				'as3':'ActionScript 3',
				'bash':'Bash/Shell',
				'cpp':'C/C++',
				'css':'CSS',
				'cf':'ColdFusion',
				'c#':'C#',
				'delphi':'Delphi',
				'diff':'Diff',
				'erlang':'Erlang',
				'groovy':'Groovy',
				'html':'HTML',
				'java':'Java',
				'jfx':'JavaFX',
				'js':'JavaScript',
				'pl':'Perl',
				'php':'PHP',
				'plain':'Plain Text',
				'ps':'PowerShell',
				'python':'Python',
				'ruby':'Ruby',
				'scala':'Scala',
				'sql':'SQL',
				'vb':'Visual Basic',
				'xml':'XML'
			},
			'confirmClear':SystemEnv.getHtmlNoteName(3831),
			'contextMenu':{
				'delete':SystemEnv.getHtmlNoteName(3519),
				'selectall':SystemEnv.getHtmlNoteName(3443),
				'deletecode':SystemEnv.getHtmlNoteName(3832),
				'cleardoc':SystemEnv.getHtmlNoteName(3740),
				'confirmclear':SystemEnv.getHtmlNoteName(3831),
				'unlink':SystemEnv.getHtmlNoteName(3833),
				'paragraph':SystemEnv.getHtmlNoteName(3745),
				'edittable':SystemEnv.getHtmlNoteName(3748),
				'aligntd':SystemEnv.getHtmlNoteName(3834),
				'aligntable':SystemEnv.getHtmlNoteName(3835),
				'tableleft':SystemEnv.getHtmlNoteName(3774),
				'tablecenter':SystemEnv.getHtmlNoteName(3836),
				'tableright':SystemEnv.getHtmlNoteName(3775),
				'edittd':SystemEnv.getHtmlNoteName(3749),
				'setbordervisible':SystemEnv.getHtmlNoteName(3837),
				'justifyleft':SystemEnv.getHtmlNoteName(3758),	
				'justifyright':SystemEnv.getHtmlNoteName(3759), 
				'justifycenter':SystemEnv.getHtmlNoteName(3760),
				'justifyjustify':SystemEnv.getHtmlNoteName(3761),
				'table':SystemEnv.getHtmlNoteName(3838),	  
				'inserttable':SystemEnv.getHtmlNoteName(3791),
				'deletetable':SystemEnv.getHtmlNoteName(3739), 
				'insertparagraphbefore':SystemEnv.getHtmlNoteName(3839),
				'insertparagraphafter':SystemEnv.getHtmlNoteName(3840),
				'deleterow':SystemEnv.getHtmlNoteName(3841),
				'deletecol':SystemEnv.getHtmlNoteName(3842),
				'insertrow':SystemEnv.getHtmlNoteName(3717),
				'insertcol':SystemEnv.getHtmlNoteName(3843),
				'insertrownext':SystemEnv.getHtmlNoteName(3844),
				'insertcolnext':SystemEnv.getHtmlNoteName(3845),
				'insertcaption':SystemEnv.getHtmlNoteName(3846),
				'deletecaption':SystemEnv.getHtmlNoteName(3847),
				'inserttitle':SystemEnv.getHtmlNoteName(3848),
				'deletetitle':SystemEnv.getHtmlNoteName(3849),
				'inserttitlecol':SystemEnv.getHtmlNoteName(3850),
				'deletetitlecol':SystemEnv.getHtmlNoteName(3851),
				'averageDiseRow':SystemEnv.getHtmlNoteName(3852),
				'averageDisCol':SystemEnv.getHtmlNoteName(3853),
				'mergeright':SystemEnv.getHtmlNoteName(3854),
				'mergeleft':SystemEnv.getHtmlNoteName(3855),
				'mergedown':SystemEnv.getHtmlNoteName(3856),
				'mergecells':SystemEnv.getHtmlNoteName(3858),
				'splittocells':SystemEnv.getHtmlNoteName(3735),
				'splittocols':SystemEnv.getHtmlNoteName(3726),
				'splittorows':SystemEnv.getHtmlNoteName(3722),	
				'tablesort':SystemEnv.getHtmlNoteName(3859),
				'enablesort':SystemEnv.getHtmlNoteName(3860),
				'disablesort':SystemEnv.getHtmlNoteName(3861),
				'reversecurrent':SystemEnv.getHtmlNoteName(3862),
				'orderbyasc':SystemEnv.getHtmlNoteName(3863),
				'reversebyasc':SystemEnv.getHtmlNoteName(3864),
				'orderbynum':SystemEnv.getHtmlNoteName(3865),
				'reversebynum':SystemEnv.getHtmlNoteName(3866),
				'borderbk':SystemEnv.getHtmlNoteName(3867),
				'setcolor':SystemEnv.getHtmlNoteName(3868),
				'unsetcolor':SystemEnv.getHtmlNoteName(3869),
				'setbackground':SystemEnv.getHtmlNoteName(3871),
				'unsetbackground':SystemEnv.getHtmlNoteName(3870),
				'redandblue':SystemEnv.getHtmlNoteName(3872),
				'threecolorgradient':SystemEnv.getHtmlNoteName(3873),
				'copy':SystemEnv.getHtmlNoteName(3874)+'(Ctrl + c)',
				'copymsg': SystemEnv.getHtmlNoteName(3875),
				'paste':SystemEnv.getHtmlNoteName(3876)+'(Ctrl + v)',
				 'pastemsg': SystemEnv.getHtmlNoteName(3877)
			},
			'copymsg': SystemEnv.getHtmlNoteName(3875),
			'pastemsg': SystemEnv.getHtmlNoteName(3877),
			'anthorMsg':SystemEnv.getHtmlNoteName(3878),
			'clearColor':SystemEnv.getHtmlNoteName(3879),
			'standardColor':SystemEnv.getHtmlNoteName(3880),
			'themeColor':SystemEnv.getHtmlNoteName(3881),
			'property':SystemEnv.getHtmlNoteName(3882),
			'default':SystemEnv.getHtmlNoteName(3773),
			'modify':SystemEnv.getHtmlNoteName(3883),
			'justifyleft':SystemEnv.getHtmlNoteName(3758),	
			'justifyright':SystemEnv.getHtmlNoteName(3759), 
			'justifycenter':SystemEnv.getHtmlNoteName(3760),
			'justify':SystemEnv.getHtmlNoteName(3773),
			'clear':SystemEnv.getHtmlNoteName(3704),	
			'anchorMsg':SystemEnv.getHtmlNoteName(3664),	
			'delete':SystemEnv.getHtmlNoteName(3519),
			'clickToUpload':SystemEnv.getHtmlNoteName(3884),
			'unset':SystemEnv.getHtmlNoteName(3885),
			't_row':SystemEnv.getHtmlNoteName(3886),
			't_col':SystemEnv.getHtmlNoteName(3887),
			'more':SystemEnv.getHtmlNoteName(3888),
			'pasteOpt':SystemEnv.getHtmlNoteName(3889),
			'pasteSourceFormat':SystemEnv.getHtmlNoteName(3890),
			'tagFormat':SystemEnv.getHtmlNoteName(3891),
			'pasteTextFormat':SystemEnv.getHtmlNoteName(3892),
			'autoTypeSet':{
				'mergeLine':SystemEnv.getHtmlNoteName(3893),
				'delLine':SystemEnv.getHtmlNoteName(3894),
				'removeFormat':SystemEnv.getHtmlNoteName(3714),
				'indent':SystemEnv.getHtmlNoteName(3668),
				'alignment':SystemEnv.getHtmlNoteName(3895),	 
				'imageFloat':SystemEnv.getHtmlNoteName(3896),
				'removeFontsize':SystemEnv.getHtmlNoteName(3897),
				'removeFontFamily':SystemEnv.getHtmlNoteName(3898),
				'removeHtml':SystemEnv.getHtmlNoteName(3899),
				'pasteFilter':SystemEnv.getHtmlNoteName(3900),
				'run':SystemEnv.getHtmlNoteName(3901),
				'symbol':SystemEnv.getHtmlNoteName(3902),
				'bdc2sb':SystemEnv.getHtmlNoteName(3903),
				'tobdc':SystemEnv.getHtmlNoteName(3904)
			},

			'background':{
				'static':{
					'lang_background_normal':SystemEnv.getHtmlNoteName(3905),
					'lang_background_local':SystemEnv.getHtmlNoteName(3906),
					'lang_background_set':SystemEnv.getHtmlNoteName(3907),
					'lang_background_none':SystemEnv.getHtmlNoteName(3908),
					'lang_background_colored':SystemEnv.getHtmlNoteName(3909),
					'lang_background_color':SystemEnv.getHtmlNoteName(3910),
					'lang_background_netimg':SystemEnv.getHtmlNoteName(3911),
					'lang_background_align':SystemEnv.getHtmlNoteName(3895),
					'lang_background_position':SystemEnv.getHtmlNoteName(3912),
					'repeatType':{'options':[SystemEnv.getHtmlNoteName(3777), SystemEnv.getHtmlNoteName(3913), SystemEnv.getHtmlNoteName(3914), SystemEnv.getHtmlNoteName(3915),SystemEnv.getHtmlNoteName(3916)]}

				},
				'noUploadImage':SystemEnv.getHtmlNoteName(3917),
				'toggleSelect':SystemEnv.getHtmlNoteName(3918)
			},
			//===============dialog i18N=======================
			'insertimage':{
				'static':{
					'lang_tab_remote':SystemEnv.getHtmlNoteName(3919), //节点
					'lang_tab_upload':SystemEnv.getHtmlNoteName(3920),
					'lang_tab_online':SystemEnv.getHtmlNoteName(3921),
					'lang_tab_search':SystemEnv.getHtmlNoteName(3922),
					'lang_input_url':SystemEnv.getHtmlNoteName(3923),
					'lang_input_size':SystemEnv.getHtmlNoteName(3924),
					'lang_input_width':SystemEnv.getHtmlNoteName(3925),
					'lang_input_height':SystemEnv.getHtmlNoteName(3926),
					'lang_input_border':SystemEnv.getHtmlNoteName(3927),
					'lang_input_vhspace':SystemEnv.getHtmlNoteName(3928),
					'lang_input_title':SystemEnv.getHtmlNoteName(3929),
					'lang_input_align':SystemEnv.getHtmlNoteName(3930),
					'lang_imgLoading':SystemEnv.getHtmlNoteName(3931),
					'lang_start_upload':SystemEnv.getHtmlNoteName(3932),
					'lock':{'title':SystemEnv.getHtmlNoteName(3933)}, //属性
					'searchType':{'title':SystemEnv.getHtmlNoteName(3934), 'options':[SystemEnv.getHtmlNoteName(3935), SystemEnv.getHtmlNoteName(3936), SystemEnv.getHtmlNoteName(3751), SystemEnv.getHtmlNoteName(3937)]}, //select的option
					'searchTxt':{'value':SystemEnv.getHtmlNoteName(3938)},
					'searchBtn':{'value':SystemEnv.getHtmlNoteName(3939)},
					'searchReset':{'value':SystemEnv.getHtmlNoteName(3940)},
					'noneAlign':{'title':SystemEnv.getHtmlNoteName(3941)},
					'leftAlign':{'title':SystemEnv.getHtmlNoteName(3774)},	
					'rightAlign':{'title':SystemEnv.getHtmlNoteName(3775)},
					'centerAlign':{'title':SystemEnv.getHtmlNoteName(3942)}
				},
				'uploadSelectFile':SystemEnv.getHtmlNoteName(3943),
				'uploadAddFile':SystemEnv.getHtmlNoteName(3944),
				'uploadStart':SystemEnv.getHtmlNoteName(3932),
				'uploadPause':SystemEnv.getHtmlNoteName(3945),
				'uploadContinue':SystemEnv.getHtmlNoteName(3946),
				'uploadRetry':SystemEnv.getHtmlNoteName(3947),
				'uploadDelete':SystemEnv.getHtmlNoteName(3519),	 
				'uploadTurnLeft':SystemEnv.getHtmlNoteName(3948),
				'uploadTurnRight':SystemEnv.getHtmlNoteName(3949),
				'uploadPreview':SystemEnv.getHtmlNoteName(3950),
				'uploadNoPreview':SystemEnv.getHtmlNoteName(3951),
				'updateStatusReady': SystemEnv.getHtmlNoteName(3952),
				'updateStatusConfirm': SystemEnv.getHtmlNoteName(3953),
				'updateStatusFinish': SystemEnv.getHtmlNoteName(3954),
				'updateStatusError': SystemEnv.getHtmlNoteName(3955),
				'errorNotSupport': SystemEnv.getHtmlNoteName(3956),
				'errorLoadConfig': SystemEnv.getHtmlNoteName(3817), 
				'errorExceedSize':SystemEnv.getHtmlNoteName(3812),  
				'errorFileType':SystemEnv.getHtmlNoteName(3813),
				'errorInterrupt':SystemEnv.getHtmlNoteName(3957),
				'errorUploadRetry':SystemEnv.getHtmlNoteName(3958),
				'errorHttp':SystemEnv.getHtmlNoteName(3959),
				'errorServerUpload':SystemEnv.getHtmlNoteName(3960),
				'remoteLockError':SystemEnv.getHtmlNoteName(3961),
				'numError':SystemEnv.getHtmlNoteName(3962),
				'imageUrlError':SystemEnv.getHtmlNoteName(3963),
				'imageLoadError':SystemEnv.getHtmlNoteName(3964),
				'searchRemind':SystemEnv.getHtmlNoteName(3938), 
				'searchLoading':SystemEnv.getHtmlNoteName(3965),
				'searchRetry':SystemEnv.getHtmlNoteName(3966)
			},
			'attachment':{
				'static':{
					'lang_tab_upload': SystemEnv.getHtmlNoteName(3967),
					'lang_tab_online': SystemEnv.getHtmlNoteName(3968),
					'lang_start_upload':SystemEnv.getHtmlNoteName(3932),	
					'lang_drop_remind':SystemEnv.getHtmlNoteName(3969)
				},
				'uploadSelectFile':SystemEnv.getHtmlNoteName(3943),
				'uploadAddFile':SystemEnv.getHtmlNoteName(3944),
				'uploadStart':SystemEnv.getHtmlNoteName(3932),
				'uploadPause':SystemEnv.getHtmlNoteName(3945),
				'uploadContinue':SystemEnv.getHtmlNoteName(3946),
				'uploadRetry':SystemEnv.getHtmlNoteName(3947),
				'uploadDelete':SystemEnv.getHtmlNoteName(3519),	 
				'uploadTurnLeft':SystemEnv.getHtmlNoteName(3948),
				'uploadTurnRight':SystemEnv.getHtmlNoteName(3949),
				'uploadPreview':SystemEnv.getHtmlNoteName(3950),
				'uploadNoPreview':SystemEnv.getHtmlNoteName(3951),
				'updateStatusReady': SystemEnv.getHtmlNoteName(3952),
				'updateStatusConfirm': SystemEnv.getHtmlNoteName(3953),
				'updateStatusFinish': SystemEnv.getHtmlNoteName(3954),
				'updateStatusError': SystemEnv.getHtmlNoteName(3955),
				'errorNotSupport': SystemEnv.getHtmlNoteName(3956),
				'errorLoadConfig': SystemEnv.getHtmlNoteName(3817), 
				'errorExceedSize':SystemEnv.getHtmlNoteName(3812),  
				'errorFileType':SystemEnv.getHtmlNoteName(3813),
				'errorInterrupt':SystemEnv.getHtmlNoteName(3957),
				'errorUploadRetry':SystemEnv.getHtmlNoteName(3958),
				'errorHttp':SystemEnv.getHtmlNoteName(3959),
				'errorServerUpload':SystemEnv.getHtmlNoteName(3960),
				'remoteLockError':SystemEnv.getHtmlNoteName(3961),
				'numError':SystemEnv.getHtmlNoteName(3962),
				'imageUrlError':SystemEnv.getHtmlNoteName(3963),
				'imageLoadError':SystemEnv.getHtmlNoteName(3964),
				'searchRemind':SystemEnv.getHtmlNoteName(3938), 
				'searchLoading':SystemEnv.getHtmlNoteName(3965),
				'searchRetry':SystemEnv.getHtmlNoteName(3966)
			},
			'insertvideo':{
				'static':{
					'lang_tab_insertV':"插入视频",
					'lang_tab_searchV':"搜索视频",
					'lang_tab_uploadV':"上传视频",
					'lang_video_url':"视频网址",
					'lang_video_size':"视频尺寸",
					'lang_videoW':"宽度",
					'lang_videoH':"高度",
					'lang_alignment':"对齐方式",
					'videoSearchTxt':{'value':"请输入搜索关键字！"},
					'videoType':{'options':["全部", "热门", "娱乐", "搞笑", "体育", "科技", "综艺"]},
					'videoSearchBtn':{'value':"百度一下"},
					'videoSearchReset':{'value':"清空结果"},

					'lang_input_fileStatus':' 当前未上传文件',
					'startUpload':{'style':"background:url(upload_wev8.png) no-repeat;"},

					'lang_upload_size':"视频尺寸",
					'lang_upload_width':"宽度",
					'lang_upload_height':"高度",
					'lang_upload_alignment':"对齐方式",
					'lang_format_advice':"建议使用mp4格式."

				},
				'numError':"请输入正确的数值，如123,400",
				'floatLeft':"左浮动",
				'floatRight':"右浮动",
				'"default"':"默认",
				'block':"独占一行",
				'urlError':"输入的视频地址有误，请检查后再试！",
				'loading':" &nbsp;视频加载中，请等待……",
				'clickToSelect':"点击选中",
				'goToSource':'访问源视频',
				'noVideo':" &nbsp; &nbsp;抱歉，找不到对应的视频，请重试！",

				'browseFiles':'浏览文件',
				'uploadSuccess':'上传成功!',
				'delSuccessFile':'从成功队列中移除',
				'delFailSaveFile':'移除保存失败文件',
				'statusPrompt':' 个文件已上传！ ',
				'flashVersionError':'当前Flash版本过低，请更新FlashPlayer后重试！',
				'flashLoadingError':'Flash加载失败!请检查路径或网络状态',
				'fileUploadReady':'等待上传……',
				'delUploadQueue':'从上传队列中移除',
				'limitPrompt1':'单次不能选择超过',
				'limitPrompt2':'个文件！请重新选择！',
				'delFailFile':'移除失败文件',
				'fileSizeLimit':'文件大小超出限制！',
				'emptyFile':'空文件无法上传！',
				'fileTypeError':'文件类型不允许！',
				'unknownError':'未知错误！',
				'fileUploading':'上传中，请等待……',
				'cancelUpload':'取消上传',
				'netError':'网络错误',
				'failUpload':'上传失败!',
				'serverIOError':'服务器IO错误！',
				'noAuthority':'无权限！',
				'fileNumLimit':'上传个数限制',
				'failCheck':'验证失败，本次上传被跳过！',
				'fileCanceling':'取消中，请等待……',
				'stopUploading':'上传已停止……',

				'uploadSelectFile':'点击选择文件',
				'uploadAddFile':'继续添加',
				'uploadStart':'开始上传',
				'uploadPause':'暂停上传',
				'uploadContinue':'继续上传',
				'uploadRetry':'重试上传',
				'uploadDelete':'删除',
				'uploadTurnLeft':'向左旋转',
				'uploadTurnRight':'向右旋转',
				'uploadPreview':'预览中',
				'updateStatusReady': '选中_个文件，共_KB。',
				'updateStatusConfirm': '成功上传_个，_个失败',
				'updateStatusFinish': '共_个(_KB)，_个成功上传',
				'updateStatusError': '，_张上传失败。',
				'errorNotSupport': 'WebUploader 不支持您的浏览器！如果你使用的是IE浏览器，请尝试升级 flash 播放器。',
				'errorLoadConfig': '后端配置项没有正常加载，上传插件不能正常使用！',
				'errorExceedSize':'文件大小超出',
				'errorFileType':'文件格式不允许',
				'errorInterrupt':'文件传输中断',
				'errorUploadRetry':'上传失败，请重试',
				'errorHttp':'http请求错误',
				'errorServerUpload':'服务器返回出错'
			},
			'webapp':{
				'tip1':"本功能由百度APP提供，如看到此页面，请各位站长首先申请百度APPKey!",
				'tip2':"申请完成之后请至ueditor.config.js中配置获得的appkey! ",
				'applyFor':"点此申请",
				'anthorApi':"百度API"
			},
			'template':{
				'static':{
					'lang_template_bkcolor':'背景颜色',
					'lang_template_clear' : '保留原有内容',
					'lang_template_select' : '选择模板'
				},
				'blank':"空白文档",
				'blog':"博客文章",
				'resume':"个人简历",
				'richText':"图文混排",
				'sciPapers':"科技论文"


			},
			'scrawl':{
				'static':{
					'lang_input_previousStep':"上一步",
					'lang_input_nextsStep':"下一步",
					'lang_input_clear':'清空',
					'lang_input_addPic':'添加背景',
					'lang_input_ScalePic':'缩放背景',
					'lang_input_removePic':'删除背景',
					'J_imgTxt':{title:'添加背景图片'}
				},
				'noScarwl':"尚未作画，白纸一张~",
				'scrawlUpLoading':"涂鸦上传中,别急哦~",
				'continueBtn':"继续",
				'imageError':"糟糕，图片读取失败了！",
				'backgroundUploading':'背景图片上传中,别急哦~'
			},
			'music':{
				'static':{
					'lang_input_tips':"输入歌手/歌曲/专辑，搜索您感兴趣的音乐！",
					'J_searchBtn':{value:'搜索歌曲'}
				},
				'emptyTxt':'未搜索到相关音乐结果，请换一个关键词试试。',
				'chapter':'歌曲',
				'singer':'歌手',
				'special':'专辑',
				'listenTest':'试听'
			},
			'anchor':{
				'static':{
					'lang_input_anchorName':SystemEnv.getHtmlNoteName(3971)
				}
			},
			'charts':{
				'static':{
					'lang_data_source':'数据源：',
					'lang_chart_format': '图表格式：',
					'lang_data_align': '数据对齐方式',
					'lang_chart_align_same': '数据源与图表X轴Y轴一致',
					'lang_chart_align_reverse': '数据源与图表X轴Y轴相反',
					'lang_chart_title': '图表标题',
					'lang_chart_main_title': '主标题：',
					'lang_chart_sub_title': '子标题：',
					'lang_chart_x_title': 'X轴标题：',
					'lang_chart_y_title': 'Y轴标题：',
					'lang_chart_tip': '提示文字',
					'lang_cahrt_tip_prefix': '提示文字前缀：',
					'lang_cahrt_tip_description': '仅饼图有效， 当鼠标移动到饼图中相应的块上时，提示框内的文字的前缀',
					'lang_chart_data_unit': '数据单位',
					'lang_chart_data_unit_title': '单位：',
					'lang_chart_data_unit_description': '显示在每个数据点上的数据的单位， 比如： 温度的单位 ℃',
					'lang_chart_type': '图表类型：',
					'lang_prev_btn': '上一个',
					'lang_next_btn': '下一个'
				}
			},
			'emotion':{
				'static':{
					'lang_input_choice':'精选',
					'lang_input_Tuzki':'兔斯基',
					'lang_input_BOBO':'BOBO',
					'lang_input_lvdouwa':'绿豆蛙',
					'lang_input_babyCat':'baby猫',
					'lang_input_bubble':'泡泡',
					'lang_input_youa':'有啊'
				}
			},
			'gmap':{
				'static':{
					'lang_input_address':SystemEnv.getHtmlNoteName(3972),
					'lang_input_search':SystemEnv.getHtmlNoteName(3973),
					'address':{value:SystemEnv.getHtmlNoteName(3974)}
				},
				searchError:SystemEnv.getHtmlNoteName(3975)
			},
			'help':{
				'static':{
					'lang_input_about':'关于UEditor',
					'lang_input_shortcuts':'快捷键',
					'lang_input_introduction':'UEditor是由百度web前端研发部开发的所见即所得富文本web编辑器，具有轻量，可定制，注重用户体验等特点。开源基于BSD协议，允许自由使用和修改代码。',
					'lang_Txt_shortcuts':'快捷键',
					'lang_Txt_func':'功能',
					'lang_Txt_bold':'给选中字设置为加粗',
					'lang_Txt_copy':'复制选中内容',
					'lang_Txt_cut':'剪切选中内容',
					'lang_Txt_Paste':'粘贴',
					'lang_Txt_undo':'重新执行上次操作',
					'lang_Txt_redo':'撤销上一次操作',
					'lang_Txt_italic':'给选中字设置为斜体',
					'lang_Txt_underline':'给选中字加下划线',
					'lang_Txt_selectAll':'全部选中',
					'lang_Txt_visualEnter':'软回车',
					'lang_Txt_fullscreen':'全屏'
				}
			},
			'insertframe':{
				'static':{
					'lang_input_address':SystemEnv.getHtmlNoteName(3977),
					'lang_input_width':SystemEnv.getHtmlNoteName(3555),   
					'lang_input_height':SystemEnv.getHtmlNoteName(3556),
					'lang_input_isScroll':SystemEnv.getHtmlNoteName(3986),
					'lang_input_frameborder':SystemEnv.getHtmlNoteName(3987),
					'lang_input_alignMode':SystemEnv.getHtmlNoteName(3988),
					'align':{title:SystemEnv.getHtmlNoteName(3988), options:[SystemEnv.getHtmlNoteName(3773), SystemEnv.getHtmlNoteName(3758), SystemEnv.getHtmlNoteName(3759), SystemEnv.getHtmlNoteName(3777)]}
				},
				'enterAddress':SystemEnv.getHtmlNoteName(3989) 
			},
			'link':{
				'static':{
					'lang_input_text':SystemEnv.getHtmlNoteName(3976),
					'lang_input_url':SystemEnv.getHtmlNoteName(3977),	 
					'lang_input_title':SystemEnv.getHtmlNoteName(3978),
					'lang_input_target':SystemEnv.getHtmlNoteName(3979)
				},
				'validLink':SystemEnv.getHtmlNoteName(3980),
				'httpPrompt':SystemEnv.getHtmlNoteName(3981)
			},
			'map':{
				'static':{
					lang_city:SystemEnv.getHtmlNoteName(3982),
					lang_address:SystemEnv.getHtmlNoteName(3972), 
					city:{value:SystemEnv.getHtmlNoteName(3974)},  
					lang_search:SystemEnv.getHtmlNoteName(3973),	
					lang_dynamicmap:SystemEnv.getHtmlNoteName(3983)
				},
				cityMsg:SystemEnv.getHtmlNoteName(3984),
				errorMsg:SystemEnv.getHtmlNoteName(3985)
			},
			'searchreplace':{
				'static':{
					lang_tab_search:"查找",
					lang_tab_replace:"替换",
					lang_search1:"查找",
					lang_search2:"查找",
					lang_replace:"替换",
					lang_searchReg:'支持正则表达式，添加前后斜杠标示为正则表达式，例如“/表达式/”',
					lang_searchReg1:'支持正则表达式，添加前后斜杠标示为正则表达式，例如“/表达式/”',
					lang_case_sensitive1:"区分大小写",
					lang_case_sensitive2:"区分大小写",
					nextFindBtn:{value:"下一个"},
					preFindBtn:{value:"上一个"},
					nextReplaceBtn:{value:"下一个"},
					preReplaceBtn:{value:"上一个"},
					repalceBtn:{value:"替换"},
					repalceAllBtn:{value:"全部替换"}
				},
				getEnd:"已经搜索到文章末尾！",
				getStart:"已经搜索到文章头部",
				countMsg:"总共替换了{#count}处！"
			},
			'snapscreen':{
				'static':{
					lang_showMsg:"截图功能需要首先安装UEditor截图插件！ ",
					lang_download:"点此下载",
					lang_step1:"第一步，下载UEditor截图插件并运行安装。",
					lang_step2:"第二步，插件安装完成后即可使用，如不生效，请重启浏览器后再试！"
				}
			},
			'spechars':{
				'static':{},
				tsfh:SystemEnv.getHtmlNoteName(3752), 
				lmsz:SystemEnv.getHtmlNoteName(3990), 
				szfh:SystemEnv.getHtmlNoteName(3991),
				rwfh:SystemEnv.getHtmlNoteName(3992),
				xlzm:SystemEnv.getHtmlNoteName(3993),
				ewzm:SystemEnv.getHtmlNoteName(3994),
				pyzm:SystemEnv.getHtmlNoteName(3995),
				yyyb:SystemEnv.getHtmlNoteName(3996),
				zyzf:SystemEnv.getHtmlNoteName(3997)
			},
			'edittable':{
				'static':{
					'lang_tableStyle':'表格样式',
					'lang_insertCaption':'添加表格名称行',
					'lang_insertTitle':'添加表格标题行',
					'lang_insertTitleCol':'添加表格标题列',
					'lang_orderbycontent':"使表格内容可排序",
					'lang_tableSize':'自动调整表格尺寸',
					'lang_autoSizeContent':'按表格文字自适应',
					'lang_autoSizePage':'按页面宽度自适应',
					'lang_example':'示例',
					'lang_borderStyle':'表格边框',
					'lang_color':'颜色:'
				},
				captionName:'表格名称',
				titleName:'标题',
				cellsName:'内容',
				errorMsg:'有合并单元格，不可排序'
			},
			'edittip':{
				'static':{
					lang_delRow:'删除整行',
					lang_delCol:'删除整列'
				}
			},
			'edittd':{
				'static':{
					lang_tdBkColor:'背景颜色:'
				}
			},
			'formula':{
				'static':{
				}
			},
			'wordimage':{
				'static':{
					lang_resave:"转存步骤",
					uploadBtn:{src:"upload_wev8.png",alt:"上传"},
					clipboard:{style:"background: url(copy_wev8.png) -153px -1px no-repeat;"},
					lang_step:"1、点击顶部复制按钮，将地址复制到剪贴板；2、点击添加照片按钮，在弹出的对话框中使用Ctrl+V粘贴地址；3、点击打开后选择图片上传流程。"
				},
				'fileType':"图片",
				'flashError':"FLASH初始化失败，请检查FLASH插件是否正确安装！",
				'netError':"网络连接错误，请重试！",
				'copySuccess':"图片地址已经复制！",
				'flashI18n':{} //留空默认中文
			},
			'autosave': {
				'saving':'保存中...',
				'success':'本地保存成功'
			}
		};
	}catch(e){
		setTimeout(function(){
			__initUEditorLang__();
		},500);
	}
}

__initUEditorLang__();