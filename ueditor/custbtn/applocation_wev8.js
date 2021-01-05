UE.registerUI('wflocatebutton',function(editor,uiName){
    //注册按钮执行时的command命令，使用命令默认就会带有回退操作

    editor.registerCommand(uiName,{
        execCommand:function(){
           var dlg=new window.top.Dialog();//定义Dialog对象
          // dlg.Title = '请选择';//"<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";
           dlg.Model=true;
           dlg.Width=900;//定义长度
           dlg.Height=600;
           var posiData = jQuery('#remarkLocation').val();
           var lng="";
           var lat="";
           var addr="";
           if(posiData !="" && posiData !=null){
          		var datas = posiData.split(",");
          		lng = datas[1];
          		lat = datas[2];
          		addr = datas[3];
           }
           dlg.URL="/systeminfo/BrowserMain.jsp?url=" + escape("/workflow/ruleDesign/showLocateOnline.jsp?useType=1&lng="+lng+"&lat="+lat+"&addr="+encodeURI(addr));
           dlg.Title=SystemEnv.getHtmlNoteName(3418,readCookie("languageidweaver"));
		   dlg.callback=function(data){
				if(data){
					var timeStamp = (new Date()).getTime();	
					var initData = timeStamp +","+ data.jingdu +","+ data.weidu +","+ data.addr;
					jQuery('#remarkLocation').val(initData);
					//alert(sHtml);
					//editor.execCommand('inserthtml', sHtml); 
					_targetobj = jQuery(".edui-for-wflocatebutton").children("div").children("div").children("div").children(".edui-box");
					_targetobj.addClass("wflocate2");
					_targetobj.removeClass("edui-metro");
					_targetobj.removeClass("wflocate1");					
					
				}else{
					_targetobj = jQuery(".edui-for-wflocatebutton").children("div").children("div").children("div").children(".edui-box");
					_targetobj.addClass("wflocate1");
					_targetobj.removeClass("edui-metro");
					_targetobj.removeClass("wflocate2");
					jQuery('#remarkLocation').val("");
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
        title:SystemEnv.getHtmlNoteName(4082,readCookie("languageidweaver")),
        //需要添加的额外样式，指定icon图标，这里默认使用一个重复的icon
        cssRules :'background-image: url(/ueditor/custbtn/images/positionSmall.png) !important;background-position: 0px 1px;',
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
}, 99, "remark"/*index 指定添加到工具栏上的那个位置，默认时追加到最后,editorId 指定这个UI是那个编辑器实例上的，默认是页面上所有的编辑器都会添加这个按钮*/);
