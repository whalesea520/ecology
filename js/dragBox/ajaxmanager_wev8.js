
/**
 * 通用ajax入口
 * @param url  请求url
 * @param data 请求数据
 * @param handler  请求处理器
 * @param dataType  数据类型
 */
function  ajaxHandler(url,data,handler,dataType)
{
   ajaxHandler(url,data,handler,dataType,true);
}

/**
 * 通用ajax入口
 * @param url  请求url
 * @param data 请求数据
 * @param handler  请求处理器
 * @param dataType  数据类型
 * @param async    是否异步
 */
var ajaxNum = 0;
function  ajaxHandler(url,data,handler,dataType,async)
{	
	if(!url || url.match(/^#/))return;
    $.ajax({
        type: "POST",
        url: url,
        async: async,
        data: data,
        beforeSend:function(e){
        	ajaxNum++;
        	e8showAjaxTips(SystemEnv.getHtmlNoteName(3403,readCookie("languageidweaver")),true,"xTable_message");
        },
        success: function(data){
        	if(data.__result__===false){
        		top.Dialog.alert(data.__msg__);
        	}else{
        		handler(data);
        	}
        	ajaxNum--;
        	if(ajaxNum==0)
        		e8showAjaxTips(SystemEnv.getHtmlNoteName(3514,readCookie("languageidweaver")),false);
        },
        dataType: dataType});
}


