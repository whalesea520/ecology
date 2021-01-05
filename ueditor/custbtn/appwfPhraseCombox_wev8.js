UE.registerUI(SystemEnv.getHtmlNoteName(3452,readCookie("languageidweaver")), function(editor,uiName){
    //注册按钮执行时的command命令,用uiName作为command名字，使用命令默认就会带有回退操作
    editor.registerCommand(uiName,{
        execCommand:function(cmdName, value){
            //这里借用fontsize的命令
            //this.execCommand('fontsize',value + 'px')
            onAddPhrase(value);
            
        },
        queryCommandValue:function(){
            //这里借用fontsize的查询命令
            //return this.queryCommandValue('fontsize')
        }
    });
	//加常用短语
	var _onAddPhrase = function (phrase){
		if(phrase!=null && phrase!=""){
			$GetEle("remarkSpan").innerHTML = "";
			try{
				UE.getEditor("remark").setContent(phrase, true);
			}catch(e){
			}
		}
	}

    //创建下拉菜单中的键值对，这里我用字体大小作为例子
    var items = [];
    //for(var i= 0,ci;ci=[10, 11, 12, 14, 16, 18, 20, 24, 36][i++];){
    
    
    var phraseselect = jQuery("#phraseselect option");
    for (var i=1; i<phraseselect.length; i++) {
    	var phrasejsondata = jQuery(phraseselect[i]);
        items.push({
            //显示的条目
            label:phrasejsondata.html(),
            //选中条目后的返回值
            value:phrasejsondata.val()
        });
    }
    //创建下来框
    var combox = new UE.ui.Combox({
        //需要指定当前的编辑器实例
        editor:editor,
        //添加条目
        items:items,
        //当选中时要做的事情
        onselect:function (t, index) {
            //拿到选中条目的值
            //editor.execCommand(uiName, this.items[index].value);
            try {
            	_onAddPhrase(jQuery("#phraseselect option")[index+1].value);
            } catch (e) {
            }
            return false;
        },
        //提示
        title:uiName,
        //当编辑器没有焦点时，combox默认显示的内容
        initValue:uiName
    });

    editor.addListener('selectionchange', function (type, causeByUi, uiReady) {
        var state = editor.queryCommandState(uiName);
        if (state == -1) {
            combox.setDisabled(true);
        } else {
            combox.setDisabled(false);
        }
    });
    return combox;
},32, "remark");

