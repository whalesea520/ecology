var mec_flbs_id;
var mec_save_type;

Mobile_NS.flbsInit = function(mecJson){
	var mecid = mecJson["id"];
	mec_flbs_id = mecJson["id"];
	mec_save_type = mecJson["savetype"];
	var $Design_LBS_Entry = $("#div"+mec_flbs_id+" .Design_LBS_Entry");
	var lbsFieldV = $("#lbsField" + mec_flbs_id).val();
	if($Design_LBS_Entry.hasClass("Design_LBS_ShowText") && lbsFieldV == ""){
		$Design_LBS_Entry.removeClass("Design_LBS_ShowText")
	}
	
	if(mecJson["savetype"] == "3"){
		$("#div"+mecid+" .Design_LBS_Entry").append("<input type=\"hidden\" name=\"fieldname_"+mecJson["addressFieldname"]+"\" id=\"lbsAddressField"+mecid+"\"/>");
	}
	
	if(mecJson["readonly"] != "1"){
		$("#lbsLocation"+mecid).bind("click", function(){
			Mobile_NS.flbsGetPosition(this, mecJson);
		});
		
		$("#lbsText"+mecid).bind("click", function(){
			Mobile_NS.flbsShowMap(this);
		});
		
		$("#deleteBtn"+mecid).bind("click", function(){
			Mobile_NS.flbsDelete(mecid, mecJson);
		});
	}
	
	var formid = mecJson["formid"];
	var $form = $("#"+formid);
	if(mecJson["isShowCurrLocation"] == "1" && lbsFieldV == ""){
		Mobile_NS.getCurrentPosition(function(result){
            var status = result["status"];
            if(status == "1"){
            	var addr = result["addr"];
				var gpsstr = result["lng"] + "," + result["lat"];
				Mobile_NS._LBSLoaded(gpsstr, addr);
            }else{
                var errMsg = result["errMsg"];
                Mobile_NS.formMsg($form, errMsg, "Form_Msg_Err");
            }
        });
	}else if(lbsFieldV != ""){
		var addressFieldvalue = mecJson["addressFieldvalue"];
		if(addressFieldvalue != ""){
			$("#lbsAddressField" + mecid).val(addressFieldvalue);
			$("#lbsText" + mecid).html(addressFieldvalue);
		}
	}
}

Mobile_NS._LBSLoaded = function(gpsstr, addstr){
	if(mec_save_type == "1"){
		$("#lbsField" + mec_flbs_id).val(gpsstr);
	}else if(mec_save_type == "2"){
		$("#lbsField" + mec_flbs_id).val(addstr);
	}else if(mec_save_type == "3"){
		$("#lbsField" + mec_flbs_id).val(gpsstr);
		$("#lbsAddressField" + mec_flbs_id).val(addstr);
	}
	$("#lbsText" + mec_flbs_id).attr("gpsstr", gpsstr);// gps
	$("#lbsText" + mec_flbs_id).html(addstr);
	var $Design_LBS_Entry = $("#div"+mec_flbs_id+" .Design_LBS_Entry");
	if(!$Design_LBS_Entry.hasClass("Design_LBS_ShowText")){
		$Design_LBS_Entry.addClass("Design_LBS_ShowText")
	}
}

Mobile_NS.flbsGetPosition = function(obj, mecJson){
	mec_flbs_id = $(obj).attr("mecid");
	
	$(obj).addClass("link_active");
	setTimeout(function(){$(obj).removeClass("link_active");},300);
	
	var paramObj = {};
	paramObj.posType = mecJson["postype"];
	paramObj.btnText = mecJson["btntext"];
	paramObj.poiRadius = mecJson["poiradius"];
	paramObj.numPois = mecJson["numpois"];
	paramObj.success = function(gpsstr, address){
		if(mecJson["savetype"] == "1"){
			$("#lbsField" + mec_flbs_id).val(gpsstr);
		}else if(mecJson["savetype"] == "2"){
			$("#lbsField" + mec_flbs_id).val(address);
		}else if(mecJson["savetype"] == "3"){
			$("#lbsField" + mec_flbs_id).val(gpsstr);
			$("#lbsAddressField" + mec_flbs_id).val(address);
		}
		$("#lbsText" + mec_flbs_id).attr("gpsstr", gpsstr);// gps
		$("#lbsText" + mec_flbs_id).html(address);
		var $Design_LBS_Entry = $("#div"+mec_flbs_id+" .Design_LBS_Entry");
		if(!$Design_LBS_Entry.hasClass("Design_LBS_ShowText")){
			$Design_LBS_Entry.addClass("Design_LBS_ShowText")
		}
		var backscript = mecJson["backscript"];
		if(backscript && backscript != ""){
			var backscript = decodeURIComponent(mecJson["backscript"]);
			eval(backscript);
		}
	}
	
	Mobile_NS.openLBSWin(paramObj);
	
}

Mobile_NS.flbsShowMap = function(obj){
	var gpsstr = $(obj).attr("gpsstr");
	if(gpsstr.indexOf(",") > 0){
		var dataArr = gpsstr.split(",");
		gpsstr = dataArr[1] + "," + dataArr[0];// var gpsstr = "31.173211,121.475134";
		gpsstr += "&isLbsAddress=0";
	}else{
		gpsstr += "&isLbsAddress=1";
	}
	Mobile_NS.flbsOpenDetail("/mobilemode/showmap.jsp?gpsstr=" + gpsstr);
}

Mobile_NS.flbsDelete = function(mecid, mecJson){
	$("#lbsField" + mecid).val("");
	if(mecJson["savetype"] == "3"){
		$("#lbsAddressField" + mecid).val("");
	}
	var $Design_LBS_Entry = $("#div"+mec_flbs_id+" .Design_LBS_Entry");
	if($Design_LBS_Entry.hasClass("Design_LBS_ShowText")){
		$Design_LBS_Entry.removeClass("Design_LBS_ShowText")
	}
}

Mobile_NS.flbsOpenDetail = function(url){
	if(top && typeof(top.openUrl) == "function"){
		top.openUrl(url);
	}else{
		location.href = url;
	}
}
