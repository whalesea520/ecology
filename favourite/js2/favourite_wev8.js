jQuery(document).ready(function(){
	//屏蔽右键菜单
	document.oncontextmenu = function(){
		return false;
	};
	var dialog = parent.getDialog(window);   //dialog对象
	var parentWin = parent.getParentWindow(window);   //父窗口对象
	
	//确定按钮的事件
	jQuery("#btnsubmit").bind("click",function(){
		onsubmit(dialog,this);
	});
	
	//取消按钮的事件
	jQuery("#btncancel").bind("click",function(){
		dialog.close();
	});
});


function onsubmit(dialog,obj){
	if(!check_form(favform,"favouritename")){
		return;
	}
	
	jQuery(obj).unbind("click");  //清除点击事件，避免重复提交
	var postData = {};
	var favouritename = jQuery("#favouritename").val();
	var favouritedesc = jQuery("#favouritedesc").val();
	var favouriteorder = jQuery("#favouriteorder").val();
	var action = jQuery("#action").val();
	
	postData.favouritename = favouritename;
	postData.favouritedesc = favouritedesc;
	postData.favouriteorder = favouriteorder;
	postData.action = action;
	if("edit" == action){  //编辑
		var favouriteid = jQuery("#favouriteid").val();
		postData.favouriteid = favouriteid;
	}
	jQuery.post("/favourite/FavDirOperation.jsp",postData,function(data){
		var robj = null;
		try{
			robj = eval("(" + data + ")");
		}catch(e){
			robj = jQuery(data);
		}
		var checkResult = jQuery.isPlainObject(robj);
		if(checkResult){
			var success = robj.success;
			if(!success){   //IE8下，isPlainObject检测有误，返回的html标签，也认为是对象
				dialog.close(data);
			}else if(success == "2"){
				top.Dialog.alert(favourite.favouritepanel.addexist);   //目录名存在
				jQuery(obj).bind("click",function(){   //重新绑定点击的事件
					onsubmit(dialog,this);
				});
			}
		}else{
			dialog.close(data);
		}
	});
}