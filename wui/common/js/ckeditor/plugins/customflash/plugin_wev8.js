(function(){
    //Section 1 : 按下自定义按钮时执行的代码
    var command= {
        exec:function(editor){
            CkeditorExt.showFlashDialog();
        }
    },
    //Section 2 : 创建自定义按钮、绑定方法
    name='customflash';
    CKEDITOR.plugins.add(name,{
        init:function(editor){
            editor.addCommand(name,command);
            editor.ui.addButton(name,{
                label:'Flash',
                icon: this.path + 'icon_flash_wev8.gif',
                command:name
            });
        }
    });
})();