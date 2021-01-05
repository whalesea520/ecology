UE.registerUI('docbutton',function(editor,uiName){
    //注册按钮执行时的command命令，使用命令默认就会带有回退操作
    editor.registerCommand(uiName,{
        execCommand:function(){
           
		   var dlg=new window.top.Dialog();//定义Dialog对象
           dlg.Model=true;
           dlg.Width=800;//定义长度
           dlg.Height=560;
           dlg.URL="/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/docs/MutiDocBrowser.jsp?documentids=";
           dlg.Title=SystemEnv.getHtmlNoteName(3455,readCookie("languageidweaver"));
		   dlg.callbackfun=function(params,data){
				if(data){
					if(data.id){
						var ids = data.id.split(",");
						var names = data.name.split(",");
						var sHtml = "";
						for(var i=0;i<ids.length;i++){
							var id = ids[i];
							var name = names[i];
							sHtml = sHtml+"<a href='javascript:void(0)'  linkid="+id+" linkType='doc' onclick=\"try{return openAppLink(this,"+id+");}catch(e){}\" ondblclick='return false;'  unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:underline !important;margin-right:8px'>"+name+"</a>&nbsp;";
						}
						editor.execCommand('inserthtml', sHtml); 
					}
				}
		   }
           dlg.show();

        }
    });

    //创建一个button
    var btn = new UE.ui.Button({
        //按钮的名字
        name:uiName,
        //提示
        title:SystemEnv.getHtmlNoteName(3561,readCookie("languageidweaver")),
        //需要添加的额外样式，指定icon图标，这里默认使用一个重复的icon
        cssRules :'background-image: url(/ueditor/custbtn/images/app-doc_wev8.png) !important;background-position: 0px 1px;',
        //点击时执行的命令
        onclick:function () {
            //这里可以不用执行命令,做你自己的操作也可
           editor.execCommand(uiName);
        }
    });

    //当点到编辑内容上时，按钮要做的状态反射
    editor.addListener('selectionchange', function () {
        var state = editor.queryCommandState(uiName);
        if (state == -1) {
            btn.setDisabled(true);
            btn.setChecked(false);
        } else {
            btn.setDisabled(false);
            btn.setChecked(state);
        }
    });

    //因为你是添加button,所以需要返回这个button
    return btn;
},56/*index 指定添加到工具栏上的那个位置，默认时追加到最后,editorId 指定这个UI是那个编辑器实例上的，默认是页面上所有的编辑器都会添加这个按钮*/);