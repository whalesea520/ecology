(function(){
    //Section 1 : 按下自定义按钮时执行的代码
    var command= {
        exec:function(editor){
            CkeditorExt.show(editor);
        }
    },
    //Section 2 : 创建自定义按钮、绑定方法
    name='customimage';
    CKEDITOR.plugins.add(name,{
        init:function(editor){
            editor.addCommand(name,command);
            editor.ui.addButton(name,{
                label:'插入图片',
                icon: this.path + 'insert-image_wev8.png',
                command:name
            });
        }
    });
})();