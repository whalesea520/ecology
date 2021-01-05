 /**
			 * @description
			 * word文档上传:点击按钮,直接选择文件上传
			 * @author Jinqn
			 * @date 2014-03-31
			 */
			UE.plugin.register('docupload', function (){
				var me = this,
					isLoaded = false,
					containerBtn, domUtils = UE.dom.domUtils, utils = UE.utils;

				function initUploadBtn(){
					var w = containerBtn.offsetWidth || 20,
						h = containerBtn.offsetHeight || 20,
						btnIframe = document.createElement('iframe'),
						btnStyle = 'display:block;width:' + w + 'px;height:' + h + 'px;overflow:hidden;border:0;margin:0;padding:0;position:absolute;top:0;left:0;filter:alpha(opacity=0);-moz-opacity:0;-khtml-opacity: 0;opacity: 0;cursor:pointer;';

					domUtils.on(btnIframe, 'load', function(){

						var timestrap = (+new Date()).toString(36),
							wrapper,
							btnIframeDoc,
							btnIframeBody;

						btnIframeDoc = (btnIframe.contentDocument || btnIframe.contentWindow.document);
						btnIframeBody = btnIframeDoc.body;
						wrapper = btnIframeDoc.createElement('div');
						var title = "word "+SystemEnv.getHtmlNoteName(3569,readCookie("languageidweaver"));
						wrapper.innerHTML = '<form id="edui_form_' + timestrap + '" target="edui_iframe_' + timestrap + '" method="POST" enctype="multipart/form-data" action="/ueditor/custbtn/wordtohtml.jsp" ' +
						'style="' + btnStyle + '">' +
						'<input id="edui_input_' + timestrap + '" title="'+title+'" type="file"  name="' + me.options.imageFieldName + '" ' +
						'style="' + btnStyle + '">' +
						'</form>' +
						'<iframe id="edui_iframe_' + timestrap + '" name="edui_iframe_' + timestrap + '" style="display:none;width:0;height:0;border:0;margin:0;padding:0;position:absolute;"></iframe>';

						wrapper.className = 'edui-' + me.options.theme;
						wrapper.id = me.ui.id + '_iframeupload';
						btnIframeBody.style.cssText = btnStyle;
						btnIframeBody.style.width = w + 'px';
						btnIframeBody.style.height = h + 'px';
						btnIframeBody.appendChild(wrapper);

						if (btnIframeBody.parentNode) {
							btnIframeBody.parentNode.style.width = w + 'px';
							btnIframeBody.parentNode.style.height = w + 'px';
						}

						var form = btnIframeDoc.getElementById('edui_form_' + timestrap);
						var input = btnIframeDoc.getElementById('edui_input_' + timestrap);
						var iframe = btnIframeDoc.getElementById('edui_iframe_' + timestrap);

						domUtils.on(input, 'change', function(){
							if(!input.value) return;
							var loadingId = 'loading_' + (+new Date()).toString(36);
							var params = utils.serializeParam(me.queryCommandValue('serverparam')) || '';

							var imageActionUrl = me.getActionUrl(me.getOpt('imageActionName'));
							//var allowFiles = me.getOpt('imageAllowFiles');
							var allowFiles = [".doc",".docx"];
							me.focus();
							me.execCommand('inserthtml', '<img class="loadingclass" id="' + loadingId + '" src="' + me.options.themePath + me.options.theme +'/images/spacer_wev8.gif" title="' + (me.getLang('simpleupload.loading') || '') + '" >');
                            
							function callback(){
								try{
									var link, json, loader,
										body = (iframe.contentDocument || iframe.contentWindow.document).body;
									//alert(iframe.contentWindow.data.state);
									var result = iframe.contentWindow.data;
									if(result.state == 'SUCCESS') {
										loader = me.document.getElementById(loadingId);
										jQuery(loader).remove();
										//me.execCommand('inserthtml',result.html.replace(/&ldquo;/g,"\"").replace(/&rdquo;/g,"\"").replace(/&lsquo;/g,"'").replace(/&rsquo;/g,"'"));
										var resulthtml=result.html;
										resulthtml=resulthtml.replace(/&ldquo;/g,"“");
										resulthtml=resulthtml.replace(/&rdquo;/g,"”");
										resulthtml=resulthtml.replace(/&lsquo;/g,"‘");
										resulthtml=resulthtml.replace(/&rsquo;/g,"’");
										resulthtml=resulthtml.replace(/&mdash;/g,"—");
										resulthtml=resulthtml.replace(/&middot;/g,"·");
										resulthtml=resulthtml.replace(/&bull;/g,"·");
										resulthtml=resulthtml.replace(/<title>((.|\n)*?)<\/title>/g,"");
										
										me.execCommand('inserthtml',resulthtml);
									} else {
										showErrorLoader && showErrorLoader(json.state);
									}
								}catch(er){
									showErrorLoader && showErrorLoader(me.getLang('simpleupload.loadError'));
								}
								form.reset();
								domUtils.un(iframe, 'load', callback);
							}
							function showErrorLoader(title){
								if(loadingId) {
									var loader = me.document.getElementById(loadingId);
									loader && domUtils.remove(loader);
									me.fireEvent('showmessage', {
										'id': loadingId,
										'content': title,
										'type': 'error',
										'timeout': 4000
									});
								}
							}

							/* 判断后端配置是否没有加载成功 */
							//if (!me.getOpt('imageActionName')) {
							//	errorHandler(me.getLang('autoupload.errorLoadConfig'));
							//	return;
						//	}
							// 判断文件格式是否错误
							var filename = input.value,
								fileext = filename ? filename.substr(filename.lastIndexOf('.')):'';
							if (!fileext || (allowFiles && (allowFiles.join('') + '.').indexOf(fileext.toLowerCase() + '.') == -1)) {
								showErrorLoader(me.getLang('simpleupload.exceedTypeError'));
								return;
							}

							domUtils.on(iframe, 'load', callback);
							//form.action = utils.formatUrl(imageActionUrl + (imageActionUrl.indexOf('?') == -1 ? '?':'&') + params);
							form.action = utils.formatUrl("/ueditor/custbtn/wordtohtml.jsp");
							form.submit();
						});

						var stateTimer;
						me.addListener('selectionchange', function () {
							clearTimeout(stateTimer);
							stateTimer = setTimeout(function() {
								var state = me.queryCommandState('docupload');
								if (state == -1) {
									input.disabled = 'disabled';
								} else {
									input.disabled = false;
								}
							}, 400);
						});
						isLoaded = true;
					});

					btnIframe.style.cssText = btnStyle;
					containerBtn.appendChild(btnIframe);
				}

				return {
					bindEvents:{
						'ready': function() {
							//设置loading的样式
							utils.cssRule('loading',
								'.loadingclass{display:inline-block;cursor:default;background: url(\''
								+ this.options.themePath
								+ this.options.theme +'/images/loading_wev8.gif\') no-repeat center center transparent;border:1px solid #cccccc;margin-right:1px;height: 22px;width: 22px;}\n' +
								'.loaderrorclass{display:inline-block;cursor:default;background: url(\''
								+ this.options.themePath
								+ this.options.theme +'/images/loaderror_wev8.png\') no-repeat center center transparent;border:1px solid #cccccc;margin-right:1px;height: 22px;width: 22px;' +
								'}',
								this.document);
								
						},
						/* 初始化简单上传按钮 */
						'docuploadbtnready': function(type, container) {
							containerBtn = container;
							initUploadBtn();
							//me.afterConfigReady(initUploadBtn);
						}
					},
				//	outputRule: function(root){
				//		utils.each(root.getNodesByTagName('img'),function(n){
				//			if (/\b(loaderrorclass)|(bloaderrorclass)\b/.test(n.getAttr('class'))) {
				//				n.parentNode.removeChild(n);
				//			}
				//		});
				//	},
					commands: {
						'docupload': {
							queryCommandState: function () {
								return isLoaded ? 0:-1;
							}
						}
					}
				}
			});

           //注册并生成改按钮            
			UE.registerUI('docupload',function(editor,uiName){


				//注册按钮执行时的command命令，使用命令默认就会带有回退操作
				editor.registerCommand(uiName,{
					execCommand:function(){
						//alert('execCommand:' + uiName)
					}
				});

				//创建一个button
				var btn = new UE.ui.Button({
					//按钮的名字
					name:uiName,
					//提示
					title:'word '+SystemEnv.getHtmlNoteName(3569,readCookie("languageidweaver")),
					//需要添加的额外样式，指定icon图标，这里默认使用一个重复的icon
					/*cssRules :'background-position: -660px -40px;',*/
					//点击时执行的命令
					onclick:function () {
						//这里可以不用执行命令,做你自己的操作也可
					   editor.execCommand(uiName);
					}
				});
                //word上传并转接html
                editor.addListener('ready', function() {
					var b = btn.getDom('body'),
						iconSpan = b.children[0];
					editor.fireEvent('docuploadbtnready', iconSpan);
				});

				//当点到编辑内容上时，按钮要做的状态反射
				editor.addListener('selectionchange', function () {
				//	var state = editor.queryCommandState(uiName);
				//	if (state == -1) {
				//		btn.setDisabled(true);
				//		btn.setChecked(false);
				//	} else {
				//		btn.setDisabled(false);
				//		btn.setChecked(state);
				//	}
				});

				//因为你是添加button,所以需要返回这个button
				return btn;
			},99/*index 指定添加到工具栏上的那个位置，默认时追加到最后,editorId 指定这个UI是那个编辑器实例上的，默认是页面上所有的编辑器都会添加这个按钮*/);