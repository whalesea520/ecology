jQuery(document).ready(function(){
	//屏蔽右键菜单
	document.oncontextmenu = function(){
		return false;
	};
	
	var dialog = parent.getDialog(window);   //dialog对象
	var parentWin = parent.getParentWindow(window);   //父窗口对象
	
	//确定按钮的事件
	jQuery("#btnsubmit").bind("click",function(){
		if(!check_form(favform,"pagename,dirid,favouritetype")){
			return;
		}
		
		jQuery(this).unbind("click");  //清除点击事件，避免重复提交
		var postData = {};
		var pagename = jQuery("#pagename").val();
		var dirid = jQuery("#dirid").val();
		var favouritetype = jQuery("#favouritetype").val();
		var favid = jQuery("#favid").val();
		
		postData.pagename = pagename;
		postData.dirid = dirid;
		postData.favouritetype = favouritetype;
		postData.favid = favid;
		postData.action = "edit";
		jQuery.post("/favourite/FavouriteOp.jsp",postData,function(data){
			dialog.close(data);
		});
	});
	
	//取消按钮的事件
	jQuery("#btncancel").bind("click",function(){
		dialog.close();
	});
});