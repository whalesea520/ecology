(function(){
    //Section 1 : 按下自定义按钮时执行的代码
	var labelname = "附件上传";
    var command= {
        exec:function(editor){

        }
    },
    //Section 2 : 创建自定义按钮、绑定方法
    name='swfupload';
    CKEDITOR.plugins.add(name,{
        init:function(editor){
            editor.addCommand(name,command);
            editor.ui.addButton(name,{
                label:labelname,
                icon: this.path + 'swf_wev8.png',
                command:name
            });
        }
    });
})();