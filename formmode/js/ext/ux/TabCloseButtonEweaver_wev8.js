Ext.ux.TabCloseButtonEweaver = function(){
    this.init = function(tp){
        tp.on('activate', function(){
        	var o = document.getElementById('tabPanel__'+tp.id);
              	var btn = document.getElementById('btnTabClose');
              	var x = o.offsetLeft + o.offsetWidth - 10;
              	var leftMenuWidth = 180;//左侧菜单宽度
              	x = accordion.collapsed ? x : x + leftMenuWidth;
              	btn.style.left = x;
              	btn.style.display = 'block';
        });
    }
};