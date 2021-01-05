if(typeof(Mobile_NS) == 'undefined'){
	Mobile_NS = {};
}

Mobile_NS.FButton = {};

Mobile_NS.FButton.onload = function(p){
	var formid = p["formid"];
	var fbutton_datas = p["fbutton_datas"];
	for(var i=0; i < fbutton_datas.length; i++){
		var fbutton_data = fbutton_datas[i];
		var id = fbutton_data["id"];
		var action = fbutton_data["action"];
		var actionvalue = fbutton_data["actionvalue"];
		var callbackfunction = fbutton_data["callbackfunction"];
		
		var $btn = $("#"+id);
		if($btn.length == 0){
			continue;
		}
		
		if(action == "1"){//提交
			$btn.click((function(callbackfunction) {
				return function(){
					var $that = $(this);
					var reminder = $that.attr("reminder");
					Mobile_NS.formSubmit(formid, function(billid){
						var res = {"id" : billid}; /*兼容老的获取billid的方法*/
						(function(){eval(callbackfunction);}).call($that[0]);
					}, reminder);
				};
			})(callbackfunction));
		}else if(action == "2"){//重置
			$btn.click(function(){
				Mobile_NS.Form.reset(formid);
			});
		}else if(action == "3"){//手动输入
			$btn.click((function(actionvalue) {
				return function(){
					eval(actionvalue);
				};
			})(actionvalue));
		}else if(action == "4"){//提交并返回
			$btn.click((function(callbackfunction) {
				return function(){
					var $that = $(this);
					var reminder = $that.attr("reminder");
					Mobile_NS.formSubmit(formid, function(billid){
						var res = {"id" : billid}; /*兼容老的获取billid的方法*/
						(function(){eval(callbackfunction);}).call($that[0]);
						
						Mobile_NS.refreshPrevPageList();
						Mobile_NS.backPage();
					}, reminder);
				};
			})(callbackfunction));
		}else if(action == "5"){//编辑
			$btn.click(function(){
				Mobile_NS.Form.edit(formid);
			});
		}else if(action == "6"){//删除
			$btn.click(function(){
				Mobile_NS.Form.deleteData(formid);
			});
		}
	}
};