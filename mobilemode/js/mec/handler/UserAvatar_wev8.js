if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.UserAvatar = function(type, id, mecJson){
	this.type = type;
	if(!id){
		id = new UUID().toString();
	}
	this.id = id;
	if(!mecJson){
		mecJson = this.getDefaultMecJson();
	}
	this.mecJson = mecJson;
}

/*获取id。 必需的方法*/
MEC_NS.UserAvatar.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.UserAvatar.prototype.getDesignHtml = function(){
	var theId = this.id;
	var htmTemplate = getPluginContentTemplateById(this.type);
	htmTemplate = htmTemplate.replace("${theId}", theId);
	var userStyle = Mec_FiexdUndefinedVal(this.mecJson["userStyle"]);
	var className = "";
	if(userStyle == "2"){
		className = "userAvatarContainer2";
	}
	htmTemplate = htmTemplate.replace("${class2}", className);
	return htmTemplate;
};

/*页面上显示控件完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.UserAvatar.prototype.afterDesignHtmlBuild = function(){
	var theId = this.id;
	var p = this.mecJson;
	var userType = p["userType"];
	var userParam = Mec_FiexdUndefinedVal(p["userParam"]);
	
	var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=getUserAvatar&userType="+userType+"&userParam="+userParam);
	$.post(url, null, function(responseText){
		var jObj = $.parseJSON(responseText);
		var status = jObj["status"];
		if(status == "1"){
			var data = jObj["data"];
			var userName = data["userName"];
			var deptName = data["deptName"];
			var jobTitlesName = data["jobTitlesName"];
			var messagerUrls = data["messagerUrls"];
			var $userAvatar = $("#NMEC_" + theId);
			$(".avatarInfo > img", $userAvatar).attr("src", messagerUrls);
			$(".userName", $userAvatar).html(userName);
			$(".deptName", $userAvatar).html(deptName);
			$(".jobtitleName", $userAvatar).html(jobTitlesName);
		}else{
			alert(SystemEnv.getHtmlNoteName(4364));  //系统异常，获取用户信息失败
		}
	});
	
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.UserAvatar.prototype.getAttrDlgHtml = function(){
	var styleL = "_style" + _userLanguage;
	var theId = this.id;
	
	var htm = "<div id=\"MADUA_"+theId+"\">"
	htm += "<div class=\"MADUA_Title\">"+SystemEnv.getHtmlNoteName(4365)+"</div>";  //用户头像
	htm += "<div class=\"MADUA_Content\">" +
				"<div class=\"MADUA_BaseInfo_Entry\">"
					+ "<span class=\"MADUA_BaseInfo_Entry_Label\">"+SystemEnv.getHtmlNoteName(4366)+"</span>"  //用户来源：
					+ "<span class=\"MADUA_BaseInfo_Entry_Content\">"
						+ "<span class=\"cbboxEntry cbboxEntry1 cbboxEntry1"+styleL+"\">"
							+ "<input type=\"checkbox\" name=\"userType_"+theId+"\" value=\"1\" onclick=\"MADUA_ChangeUserType(this, '"+theId+"');\"/><span class=\"cbboxLabel\">"+SystemEnv.getHtmlNoteName(4367)+"</span>"  //当前用户
						+ "</span>"
						+ "<span class=\"cbboxEntry cbboxEntry2 cbboxEntry2"+styleL+"\">"
							+ "<input type=\"checkbox\" name=\"userType_"+theId+"\" value=\"2\" onclick=\"MADUA_ChangeUserType(this, '"+theId+"');\"/><span class=\"cbboxLabel\">"+SystemEnv.getHtmlNoteName(4281)+"</span>"  //获取参数
							+ "<span style=\"margin-left: 8px;position: absolute;top:-3px;\"><input type=\"text\" id=\"userParam_"+theId+"\" class=\"MADUA_Text\" placeholder=\""+SystemEnv.getHtmlNoteName(4593)+"\"/></span>"  //参数名称,如：userid
						+ "</span>"
					+ "</span>"
				+ "</div>" 
				
				+ "<div class=\"MADUA_BaseInfo_Entry\">"
					+ "<span class=\"MADUA_BaseInfo_Entry_Label\">"+SystemEnv.getHtmlNoteName(4369)+"</span>"  //样式：
				+ "</div>" 
				+ "<div class=\"MADUA_BaseInfo_Entry\">"
					+ "<span class=\"MADUA_BaseInfo_Entry_Content\">"
						+"<div width=\"300px;\">"
							+"<div class=\"userAvatarContainers\" onclick=\"MADUA_ChangeUserStyle('"+theId+"',1);\">"
								+"<img src=\"/mobilemode/images/template/userAvatar1_wev8.png\">"
								+"<div class=\"selectUserStyle\"></div>"
							+"</div>"
							
							+"<div class=\"userAvatarContainers userAvatarContainers2\" onclick=\"MADUA_ChangeUserStyle('"+theId+"',2);\">"
								+"<img src=\"/mobilemode/images/template/userAvatar2_wev8.png\">"
								+"<div class=\"selectUserStyle\"></div>"
							+"</div>"
							+"<input type=\"hidden\" id=\"userStyle_"+theId+"\" value=\"\" />"
						+"</div>"
					+ "</span>"
				+ "</div>" 
			+"</div>";
	htm += "<div style=\"clear:both;\"></div>";
	htm += "<div class=\"MADUA_Bottom\"><div class=\"MADUA_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>";  //确定
	htm += "</div>";
	
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.UserAvatar.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	
	var userTypeV = this.mecJson["userType"];
	var $userType = $("input[type='checkbox'][name='userType_"+theId+"'][value='"+userTypeV+"']");
	if($userType.length > 0){
		$userType.attr("checked", "checked");
		$userType.triggerHandler("click");
	}
	var $userStyle = Mec_FiexdUndefinedVal(this.mecJson["userStyle"]);
	MADUA_ChangeUserStyle(theId,$userStyle);
	
	$("#userParam_"+theId).val(Mec_FiexdUndefinedVal(this.mecJson["userParam"]));
	
	$("#MADUA_"+theId).jNice();
};

/*获取JSON*/
MEC_NS.UserAvatar.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MAD_"+theId);
	if($attrContainer.length > 0){
		this.mecJson["userType"] = $("input[type='checkbox'][name='userType_"+theId+"']:checked").val();
		this.mecJson["userParam"] = $("#userParam_"+theId).val();
		this.mecJson["userStyle"] = $("#userStyle_"+theId).val();
	}
	return this.mecJson;
};

MEC_NS.UserAvatar.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var defMecJson = {};
	
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["userType"] = "1";	//用户来源
	defMecJson["userStyle"] = "1";	//用户样式
	return defMecJson;
};

function MADUA_ChangeUserType(cbObj, mec_id){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		var objV = cbObj.value;
		if(!cbObj.checked){
			changeCheckboxStatus(cbObj, true);
			return;
		}else{
			$("input[type='checkbox'][name='userType_"+mec_id+"']").each(function(){
				if(this.value != objV){
					changeCheckboxStatus(this, false);
				}
			});
		}
		if(objV == "2"){
			$("#userParam_" + mec_id).show();
		}else{
			$("#userParam_" + mec_id).hide();
		}
	},100);
}

function MADUA_ChangeUserStyle(mec_id,userStyleVal){
	if(userStyleVal == ""){
		userStyleVal = "1";
	}
	$("#userStyle_"+mec_id).val(userStyleVal);
	if(userStyleVal == "1"){
		$(".selectUserStyle").eq(0).removeClass("controlUserStyle");
		$(".userAvatarContainers").eq(0).addClass("selectUserStyle2");
		$(".selectUserStyle").eq(1).addClass("controlUserStyle");
		$(".userAvatarContainers").eq(1).removeClass("selectUserStyle2");
	}else{
		$(".selectUserStyle").eq(0).addClass("controlUserStyle");
		$(".userAvatarContainers").eq(0).removeClass("selectUserStyle2");
		$(".userAvatarContainers").eq(1).addClass("selectUserStyle2");
		$(".selectUserStyle").eq(1).removeClass("controlUserStyle");
	}
}