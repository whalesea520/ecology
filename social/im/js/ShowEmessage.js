$(document).ready(function(){
    checkE4Ready(function(htmlstr){
        $(htmlstr).prependTo($('body'));
    });

});

function checkE4Ready(cb){
    $.post("/social/im/SocialIMInclude.jsp", function(ret){
        ret = $.trim(ret);
        if(ret == ''){
            console.error("!!license为空或不是e4版本!!");
            return;
        }
        if(ret.indexOf('/social/im/SocialIMMain.jsp')>-1 && typeof cb === 'function'){
            cb(ret);
        }
    });
}
