if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.Countdown = function(type, id, mecJson){
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
MEC_NS.Countdown.prototype.getID = function(){
	return this.id;
};

MEC_NS.Countdown.prototype.runWhenPageOnLoad = function(){
	var theId = this.id;
	$("#timeContainer_"+theId).children().remove();
	this.afterDesignHtmlBuild();
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.Countdown.prototype.getDesignHtml = function(){
	var theId = this.id;
	var countdowndate;
	var rightActionTypeV = this.mecJson["rightActionType"];
	
	var datasource = this.mecJson["datasource"];
	var rightAction_SQL = this.mecJson["rightAction_SQL"];
	
	var parameter = this.mecJson["parameter"];
	if(rightActionTypeV==1){
		
		countdowndate = this.mecJson["countdowndate1"];
		if(countdowndate==""){
			var htm = "<div class=\"Design_Countdown_Tip\">"+SystemEnv.getHtmlNoteName(4273)+"</div>";  //信息设置不完整，未配置截止日期
			return htm;
		}
		
	}else if(rightActionTypeV==2){
		
		var theThis = this;
		if($.trim(rightAction_SQL) == ""){
			var htm = "<div class=\"Design_Countdown_Tip\">"+SystemEnv.getHtmlNoteName(4274)+"</div>";  //信息设置不完整，未配置数据来源SQL
			return htm;
		}else{
			if($.trim(rightAction_SQL).toLowerCase().indexOf("select ") == 0){
				
				var regexp = /\{(.*)\}/;
				if(regexp.test(rightAction_SQL)){
					var htm = "<div class=\"Design_Countdown_Tip\">"+SystemEnv.getHtmlNoteName(4275)+"</div>";  //SQL中包含自定义变量，预览时显示
					return htm;
				}
			
				rightAction_SQL = $m_encrypt(rightAction_SQL);// 系统安全编码
				if(rightAction_SQL == ""){// 系统安全关键字验证不通过
					var tipHtm = "<div class=\"Design_Countdown_Tip\">"+SystemEnv.getHtmlNoteName(4207)+"</div>";  //数据来源SQL未通过系统安全测试，请检查关键字
					return tipHtm;
				}
				
				var flag;
				MADCD_DataGet(theId, datasource, rightAction_SQL, function(status,date){
					if(status == "0"){
						flag = 0;
					}else if(status == "-1"){
						flag = -1;
					}else if(status == "1"){
						countdowndate = date;
					}
					
				});
				
				if(flag==0){
					var htm = "<div class=\"Design_Countdown_Tip\">"+SystemEnv.getHtmlNoteName(4208)+"</div>";  //查询数据来源SQL时出现错误，请检查SQL是否拼写正确
					return htm;
				}else if(flag==-1) {
					var htm = "<div class=\"Design_Countdown_Tip\">"+SystemEnv.getHtmlNoteName(4276)+"</div>";  //查询数据来源SQL时出现异常
					return htm;
				}
				
			}
		}
		
		
	}else if(rightActionTypeV==3){
		
		if(parameter==""){
			var htm = "<div class=\"Design_Countdown_Tip\">"+SystemEnv.getHtmlNoteName(4277)+"</div>";  //信息设置不完整，未配置参数
			return htm;
		}else {
			var htm = "<div id=\"timeContainer_"+theId+"\" data-timer=\"90\" style=\"height: 86px; overflow: hidden; position: relative; z-index: 0; \"></div>";
			return htm;
		}
		
	}
	
	
	var htm = "<div id=\"timeContainer_"+theId+"\" data-date=\""+ countdowndate +"\" style=\"height: 86px; overflow: hidden; position: relative; z-index: 0; \"></div>";
	return htm;
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.Countdown.prototype.getAttrDlgHtml = function(){
	var styleL = "_style" + _userLanguage;
	var theId = this.id;
	
	var htm = "<div id=\"MADCD_"+theId+"\">"
				+ "<div class=\"MADCD_Title\">"+SystemEnv.getHtmlNoteName(3614)+"</div>"  //截止日期
				+ "<div class=\"MADCD_BaseInfo\">"
				
						+ "<div class=\"MADCD_BaseInfo_Entry\">"
							+ "<span class=\"MADCD_BaseInfo_Entry_Label\">"+SystemEnv.getHtmlNoteName(4278)+"</span>"  //执行操作：
							+ "<span class=\"MADCD_BaseInfo_Entry_Content\">"
								+ "<span class=\"cbboxEntry cbboxEntry1 cbboxEntry"+styleL+"\">"
									+ "<input type=\"checkbox\" name=\"rightActionType_"+theId+"\" value=\"1\" onclick=\"MADCD_ChangeRAT(this, '"+theId+"');\"/><span class=\"cbboxLabel\">"+SystemEnv.getHtmlNoteName(4279)+"</span>"  //选择时间
								+ "</span>"
								+ "<span class=\"cbboxEntry cbboxEntry2 cbboxEntry"+styleL+"\">"
									+ "<input type=\"checkbox\" name=\"rightActionType_"+theId+"\" value=\"2\" onclick=\"MADCD_ChangeRAT(this, '"+theId+"');\"/><span class=\"cbboxLabel\">"+SystemEnv.getHtmlNoteName(4280)+"</span>"  //手动输入SQL
								+ "</span>"
								+ "<span class=\"cbboxEntry cbboxEntry1 cbboxEntry"+styleL+"\">"
									+ "<input type=\"checkbox\" name=\"rightActionType_"+theId+"\" value=\"3\" onclick=\"MADCD_ChangeRAT(this, '"+theId+"');\"/><span class=\"cbboxLabel\">"+SystemEnv.getHtmlNoteName(4281)+"</span>"  //获取参数
								+ "</span>"
							+ "</span>"
						+ "</div>"
						
						+ "<div class=\"rightActionContent actionContent\" id=\"rightActionContent_"+theId+"_1\" style=\"display: none;\">"
						
							+"<div class=\"MADCD_DataSource\">"
								+"<div style=\"position: relative;padding-left: 60px;\">"
									+"<span class=\"MADCD_DataSource_Label MADCD_DataSource_Label1 MADCD_DataSource_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4282)+"</span>"   //截止日期：
									+ "<input type=\"text\" id=\"countdowndate_"+theId+"\" class=\"MADCD_Text MADCD_Text"+styleL+"\" style=\"width: 145px;\" onfocus=\"WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'%y-%M-%d %H:%m:%s'})\"/>"
								+"</div>"
							+"</div>"
						
						+ "</div>"
						
						+ "<div class=\"rightActionContent actionContent\" id=\"rightActionContent_"+theId+"_2\" style=\"display: none;\">"
						
							+"<div class=\"MADCD_DataSource\">"
								+"<div style=\"position: relative;padding-left: 60px;\">"
									+"<span class=\"MADCD_DataSource_Label MADCD_DataSource_Label"+styleL+"\" style=\"position: absolute;top: -1px;left: 0px;\">"+SystemEnv.getHtmlNoteName(4201)+"</span>"  //数据源：
									+"<select class=\"MADCD_Select MADCD_Select"+styleL+"\" id=\"datasource_"+theId+"\">"
										+"  <option value=\"\">(local)</option>"
									+"</select>"
								+"</div>"
							+"</div>"
							
							+ "<textarea id=\"rightAction_SQL_"+theId+"\" class=\"MADCD_Textarea\" placeholder=\""+SystemEnv.getHtmlNoteName(4283)+"\"></textarea>"  //请在此处输入SQL...
							+"<div style=\"padding-top: 3px;\">"+SystemEnv.getHtmlNoteName(4284)+"</div>"  //请输入一个能返回类似2014-12-12 12:12:12这种日期时间的数据的SQL。
						+ "</div>"
						
						+ "<div class=\"rightActionContent actionContent\" id=\"rightActionContent_"+theId+"_3\" style=\"display: none;\">"
						
							+"<div class=\"MADCD_DataSource\">"
								+"<div style=\"position: relative;padding-left: 60px;\">"
									+"<span class=\"MADCD_DataSource_Label\" style=\"position: absolute;top: 3px;left: 0px;\">"+SystemEnv.getHtmlNoteName(4285)+"</span>"  //获取参数：  
									+ "<input type=\"text\" id=\"parameter_"+theId+"\" class=\"MADCD_Text\" style=\"width: 243px;\" />"
								+"</div>"
							+"</div>"
							
						+ "</div>"
						
				+ "</div>"
				+ "<div class=\"MADCD_Bottom\"><div class=\"MADCD_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>"  //确定
			+ "</div>";
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	return htm;
};

/*页面上显示控件完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.Countdown.prototype.afterDesignHtmlBuild = function(){
	
	var theId = this.id;
	
	if($("#timeContainer_"+theId).length > 0){
		var $htm = $("#timeContainer_"+theId);
		
		/*$htm[0].value = this.getHtm();*/
		/*此处拿时间差距*/
		
		$htm.TimeCircles({
			time : {
				Days: {
					show: false,
					text: "天",
					color: "#FC6"
				},
				Hours: {
					show: false,
					text: "时",
					color: "#9CF"
				},
				Minutes: {
					show: false,
					text: "分",
					color: "#BFB"
				},
				Seconds: {
					show: false,
					text: "秒",
					color: "#F99"
				}
			},
			refresh_interval: 0.1,
			count_past_zero: true,
			circle_bg_color: "#ddd",
			fg_width: 0.03,
			bg_width: 0.2
		});
		
	}
	
	
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.Countdown.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	
	var rightActionTypeV = this.mecJson["rightActionType"];
	var $rightActionType = $("input[type='checkbox'][name='rightActionType_"+theId+"'][value='"+rightActionTypeV+"']");
	if($rightActionType.length > 0){
		//MADCD_ChangeRAT($rightActionType[0], theId);
		$rightActionType.attr("checked", "checked");
		$rightActionType.triggerHandler("click");
	}
	
	
	var countdowndate = this.mecJson["countdowndate1"];	//截止日期
	$("#countdowndate_"+theId).val(countdowndate);
	
	
	//动态获取数据源的值，并给数据源添加HTML
	$("#datasource_" + theId).val(this.mecJson["datasource"]);
	MADCD_setDataSourceHTML(theId,this.mecJson["datasource"]);

	var $sql = $("#rightAction_SQL_"+theId);
	$sql[0].value = this.mecJson["rightAction_SQL"];
	
	$sql.focus(function(){
		$(this).addClass("MADCD_Textarea_Focus");
	});
	$sql.blur(function(){
		$(this).removeClass("MADCD_Textarea_Focus");
	});
	
	
	$("#parameter_" + theId).val(this.mecJson["parameter"]);
	
	
	$("#MADCD_"+theId).jNice();
	
};

/*获取JSON*/
MEC_NS.Countdown.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADCD_"+theId);
	if($attrContainer.length > 0){
		
		var rightActionType = $("input[type='checkbox'][name='rightActionType_"+theId+"']:checked").val();
		this.mecJson["rightActionType"] = rightActionType;
		
		var countdowndate;
		var datasource;
		var rightAction_SQL;
		var parameter;
		
		if(rightActionType==1) {
			countdowndate = $("#countdowndate_"+theId).val();	//截止日期
			this.mecJson["countdowndate1"] = countdowndate;
		}else if(rightActionType==2) {
			datasource = $("#datasource_" + theId).val();
			rightAction_SQL = $("#rightAction_SQL_"+theId).val();
			this.mecJson["datasource"] = datasource;
			this.mecJson["rightAction_SQL"] = rightAction_SQL;
		}else if(rightActionType==3) {
			parameter = $("#parameter_"+theId).val();
			this.mecJson["parameter"] = parameter;
		}
		
		
	}
	return this.mecJson;
};

MEC_NS.Countdown.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var defMecJson = {};
	
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["rightActionType"] = 1;
	
	defMecJson["countdowndate1"] = "";
	
	defMecJson["datasource"] = "";
	defMecJson["rightAction_SQL"] = "";
	
	defMecJson["parameter"] = "";
	
	return defMecJson;
};

function MADCD_ChangeRAT(cbObj, mec_id){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		var objV = cbObj.value;
		if(!cbObj.checked){
			changeCheckboxStatus(cbObj, true);
			return;
		}else{
			$("input[type='checkbox'][name='rightActionType_"+mec_id+"']").each(function(){
				if(this.value != objV){
					changeCheckboxStatus(this, false);
				}
			});
		}
		
		$("#MADCD_"+mec_id+" .rightActionContent").hide();
		$("#rightActionContent_" + mec_id + "_" + objV).show();
	},100);
}

function MADCD_OpenSQLHelp(){
	var url = "/mobilemode/chartSQLHelp.jsp";
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 540;//定义长度
	dlg.Height = 555;
	dlg.URL = url;
	dlg.Title = SystemEnv.getHtmlNoteName(4204);  //SQL帮助
	dlg.show();
}

function MADCD_setDataSourceHTML(mec_id,val){
	var $MADL_DataSource = $("#datasource_" + mec_id);
	var url = jionActionUrl("com.weaver.formmodel.mobile.servlet.MobileAppBaseAction", "action=getDataSource");
	FormmodeUtil.doAjaxDataLoad(url, function(datas){
		for(var i = 0; i < datas.length; i++){
			var data = datas[i];
			var pointid = data;
			var selected = "";
			if (pointid=="" || typeof(pointid)=="undefined") continue;
			if (pointid == val) selected = "selected";
			var dataSourceSelectHtml = "<option value=\""+pointid+"\" "+selected+">";
			dataSourceSelectHtml += pointid;
			dataSourceSelectHtml += "</option>";
			$MADL_DataSource.append(dataSourceSelectHtml);
		}
	});
}




function MADCD_DataGet(theId, datasource, sql, fn){
	var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "&sql="+encodeURIComponent(sql));
	$.ajax({
		type:"POST",
		async:false,
		url:url,
		data:{action:"getDataBySQLWithCountdown",datasource:datasource},
		success : function (responseText){
			var jObj = $.parseJSON(responseText);
			var status = jObj["status"];
			var date = jObj["date"];
			fn.call(this, status, date);
		}
	});
	/*$.post(url, null, function(responseText){
		var jObj = $.parseJSON(responseText);
		var status = jObj["status"];
		if(status == "0"){
			var tipHtm = "<div class=\"Design_Countdown_Tip\">查询数据来源SQL时出现错误，请检查SQL是否拼写正确</div>";
			$TimeContainer.html(tipHtm);
		}else if(status == "-1"){
			var tipHtm = "<div class=\"Design_Countdown_Tip\">出现异常</div>";
			$TimeContainer.html(tipHtm);
		}else if(status == "1"){
			var date = jObj["date"];
			fn.call(this, date);
		}
	});*/
}



