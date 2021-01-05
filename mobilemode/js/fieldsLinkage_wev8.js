//fieldid   68611
//result   {name: "", value: ""}
function readyToTrigger(fieldid, result){
	var modeid = $("#formmodeid").val();
	//联动的基本信息
	var sql = "select * from modeDataInputentry where modeid = "+modeid+" and triggerfieldname = 'field"+fieldid+"'";
	//prompt("<%=SystemEnv.getHtmlLabelName(28624,user.getLanguage())%>",sql);
	SQL(sql, "", function(res){
		if(res){
			var entryID = "";
			if(res.length){
				for(var i=0; i<res.length; i++){
					entryID = getValueByKey(res[i],"id");
					setEachTrigger(entryID, fieldid, result, modeid);
				}
			}else{
				entryID = getValueByKey(res,"id");
				setEachTrigger(entryID, fieldid, result, modeid);
			}
		}
	});
}

function setEachTrigger(entryID, fieldid, result, modeid){
	if(!entryID ||entryID == "") return;
	//联动触发设置的数据源和where条件
	var sql1 = "select * from modeDataInputmain where entryid = "+entryID;
	SQL(sql1, "", function(res1){
		if(res1){
			var dataInputID = "";
			var whereClause = "";
			var datasourcename = "";
			if(res1.length){
				for(var i=0; i<res1.length; i++){
					dataInputID = getValueByKey(res1[i],"id");
					whereClause = getValueByKey(res1[i],"whereclause");
					if(whereClause == ""){
						whereClause = " 1=1 ";
					}
					datasourcename = getValueByKey(res1[i],"datasourcename");
					
					setEachTriggerDetail(fieldid, result, dataInputID, whereClause, datasourcename, modeid);
				}
			}else{
				dataInputID = getValueByKey(res1,"id");
				whereClause = getValueByKey(res1,"whereclause");
				if(whereClause == ""){
					whereClause = " 1=1 ";
				}
				datasourcename = getValueByKey(res1,"datasourcename");
				
				setEachTriggerDetail(fieldid, result, dataInputID, whereClause, datasourcename, modeid);
			}
		}
	});
}

function setEachTriggerDetail(fieldid, result, dataInputID, whereClause, datasourcename, modeid){
	//联动触发设置的表和别名
	var sql2 = "select * from modeDataInputtable where datainputid = "+dataInputID;
	SQL(sql2, "", function(res2){
		if(res2){
			var searchvalue = "";
			var trigjsonarr = [];
			var otherTrigjsonarr = [];
			var fromTable = "";
			var triggercondition = "";
			//是否触发字段联动，加此条件用来限制当触发字段为树形多节点，并且设置了多触发条件时生效，即只执行当前节点的触发设置，非当前节点则不执行
			var isTrigger = true;
			//触发相关的表，一个和多个生成的查询语句不一样
			if(res2.length){
				for(var i=0; i<res2.length; i++){
					var tableID = getValueByKey(res2[i],"id");
					var tableName = getValueByKey(res2[i],"tablename");
					var alias = getValueByKey(res2[i],"alias");
					var formid = getValueByKey(res2[i],"formid");
					fromTable += ("," + tableName +" "+alias);
					//查询每个联动表对应的字段
					var sql3 = "select * from modeDataInputfield where datainputid = "+dataInputID+" and tableid="+tableID;
					SQL(sql3, "", function(res3){
						if(res3){
							if(res3.length){
								for(var i=0; i<res3.length; i++){
									if(getValueByKey(res3[i],"PAGEFIELDNAME") == ("field"+fieldid)){//主触发字段
										if(alias == ""){
											triggercondition = getValueByKey(res3[i],"DBFIELDNAME");
										}else{
											triggercondition = (alias+"."+getValueByKey(res3[i],"DBFIELDNAME"));
										}
										var treenodeid = getValueByKey(res3[i], "treenodeid");
										var tempFieldValue = result["value"];
										if(treenodeid && tempFieldValue){
											var tempFieldValuePrefix = treenodeid + "_";
											if(tempFieldValue.slice(0, tempFieldValuePrefix.length) != tempFieldValuePrefix){
												isTrigger = false;
												break;
											}
											tempFieldValue = tempFieldValue.replace(tempFieldValuePrefix, "");
											result["value"] = tempFieldValue;
										}
									}else{															//联动字段
										if(alias != ""){
											searchvalue = searchvalue + "," + alias+".* ";
										}

										if(getValueByKey(res3[i],"TYPE") == "1"){//其他触发字段
											var otherTrigjson = {};
											var tempName = getValueByKey(res3[i],"DBFIELDNAME");
											if(alias != ""){
												tempName = alias+"."+tempName;
											}
											otherTrigjson.name = tempName;
											var tempFieldid = getValueByKey(res3[i],"PAGEFIELDNAME");
											otherTrigjson.fieldid = tempFieldid;
											var treenodeid = getValueByKey(res3[i], "treenodeid");
											var tempFieldValue = $("#" + tempFieldid).val();
											if(treenodeid && tempFieldValue){
												var tempFieldValuePrefix = treenodeid + "_";
												if(tempFieldValue.slice(0, tempFieldValuePrefix.length) != tempFieldValuePrefix){
													isTrigger = false;
													break;
												}
												tempFieldValue = tempFieldValue.replace(tempFieldValuePrefix, "");
											}
											otherTrigjson.value = tempFieldValue;
											otherTrigjsonarr.push(otherTrigjson);
										}else{
											var trigjson = {};
											trigjson.searchfieldname = getValueByKey(res3[i],"DBFIELDNAME");
											trigjson.beTriggerName = getValueByKey(res3[i],"PAGEFIELDNAME");
											trigjson.formid = formid;
											trigjsonarr.push(trigjson);
										}
									}
								}
							}else{//基本不可能，一般都有1和2
								if(getValueByKey(res3,"PAGEFIELDNAME") == ("field"+fieldid)){//主触发字段
									if(alias == ""){
										triggercondition = getValueByKey(res3,"DBFIELDNAME");
									}else{
										triggercondition = (alias+"."+getValueByKey(res3,"DBFIELDNAME"));
									}
									var treenodeid = getValueByKey(res3[i], "treenodeid");
									var tempFieldValue = result["value"];
									if(treenodeid && tempFieldValue){
										var tempFieldValuePrefix = treenodeid + "_";
										if(tempFieldValue.slice(0, tempFieldValuePrefix.length) != tempFieldValuePrefix){
											isTrigger = false;
										}
										tempFieldValue = tempFieldValue.replace(tempFieldValuePrefix, "");
										result["value"] = tempFieldValue;
									}
								}else{														//联动字段
									if(alias != ""){
										searchvalue = searchvalue + "," + alias+".* ";
									}
									
									if(getValueByKey(res3,"TYPE") == "1"){//其他触发字段
										var otherTrigjson = {};
										var tempName = getValueByKey(res3,"DBFIELDNAME");
										if(alias != ""){
											tempName = alias+"."+tempName;
										}
										otherTrigjson.name = tempName;
										var tempFieldid = getValueByKey(res3,"PAGEFIELDNAME");
										otherTrigjson.fieldid = tempFieldid;
										var treenodeid = getValueByKey(res3, "treenodeid");
										var tempFieldValue = $("#" + tempFieldid).val();
										if(treenodeid && tempFieldValue){
											var tempFieldValuePrefix = treenodeid + "_";
											if(tempFieldValue.slice(0, tempFieldValuePrefix.length) != tempFieldValuePrefix){
												isTrigger = false;
											}
											tempFieldValue = tempFieldValue.replace(tempFieldValuePrefix, "");
										}
										otherTrigjson.value = tempFieldValue;
										otherTrigjsonarr.push(otherTrigjson);
									}else{
										var trigjson = {};
										trigjson.searchfieldname = getValueByKey(res3,"DBFIELDNAME");
										trigjson.beTriggerName = getValueByKey(res3,"PAGEFIELDNAME");
										trigjson.formid = formid;
										trigjsonarr.push(trigjson);
									}
								}
							}
						}
					});
				}
			}else{
				var tableID = getValueByKey(res2,"id");
				var tableName = getValueByKey(res2, "tablename");
				var alias = getValueByKey(res2,"alias");
				var formid = getValueByKey(res2,"formid");
				fromTable += ("," + tableName +" "+alias);
				
				//查询每个联动表对应的字段
				var sql3 = "select * from modeDataInputfield where datainputid = "+dataInputID+" and tableid="+tableID;
				SQL(sql3, "", function(res3){
					if(res3){
						if(res3.length){
							for(var i=0; i<res3.length; i++){
								if(getValueByKey(res3[i],"PAGEFIELDNAME") == ("field"+fieldid)){//主触发字段
									if(alias == ""){
										triggercondition = getValueByKey(res3[i],"DBFIELDNAME");
									}else{
										triggercondition = (alias+"."+getValueByKey(res3[i],"DBFIELDNAME"));
									}
									var treenodeid = getValueByKey(res3[i], "treenodeid");
									var tempFieldValue = result["value"];
									if(treenodeid && tempFieldValue){
										var tempFieldValuePrefix = treenodeid + "_";
										if(tempFieldValue.slice(0, tempFieldValuePrefix.length) != tempFieldValuePrefix){
											isTrigger = false;
											break;
										}
										tempFieldValue = tempFieldValue.replace(tempFieldValuePrefix, "");
										result["value"] = tempFieldValue;
									}
								}else{															//联动字段
									if(alias != ""){
										searchvalue = searchvalue + "," + alias+".* ";
									}
									
									if(getValueByKey(res3[i],"TYPE") == "1"){//其他触发字段
										var otherTrigjson = {};
										var tempName = getValueByKey(res3[i],"DBFIELDNAME");
										if(alias != ""){
											tempName = alias+"."+tempName;
										}
										otherTrigjson.name = tempName;
										var tempFieldid = getValueByKey(res3[i],"PAGEFIELDNAME");
										otherTrigjson.fieldid = tempFieldid;
										var treenodeid = getValueByKey(res3[i], "treenodeid");
										var tempFieldValue = $("#" + tempFieldid).val();
										if(treenodeid && tempFieldValue){
											var tempFieldValuePrefix = treenodeid + "_";
											if(tempFieldValue.slice(0, tempFieldValuePrefix.length) != tempFieldValuePrefix){
												isTrigger = false;
												break;
											}
											tempFieldValue = tempFieldValue.replace(tempFieldValuePrefix, "");
										}
										otherTrigjson.value = tempFieldValue;
										otherTrigjsonarr.push(otherTrigjson);
									}else{
										var trigjson = {};
										trigjson.searchfieldname = getValueByKey(res3[i],"DBFIELDNAME");
										trigjson.beTriggerName = getValueByKey(res3[i],"PAGEFIELDNAME");
										trigjson.formid = formid;
										trigjsonarr.push(trigjson);
									}
								}
							}
						}else{//基本不可能，一般都有1和2
							if(getValueByKey(res3,"PAGEFIELDNAME") == ("field"+fieldid)){//主触发字段
								if(alias == ""){
									triggercondition = getValueByKey(res3,"DBFIELDNAME");
								}else{
									triggercondition = (alias+"."+getValueByKey(res3,"DBFIELDNAME"));
								}
								var treenodeid = getValueByKey(res3[i], "treenodeid");
								var tempFieldValue = result["value"];
								if(treenodeid && tempFieldValue){
									var tempFieldValuePrefix = treenodeid + "_";
									if(tempFieldValue.slice(0, tempFieldValuePrefix.length) != tempFieldValuePrefix){
										isTrigger = false;
									}
									tempFieldValue = tempFieldValue.replace(tempFieldValuePrefix, "");
									result["value"] = tempFieldValue;
								}
							}else{														//联动字段
								if(alias != ""){
									searchvalue = searchvalue + "," + alias+".* ";
								}
								
								if(getValueByKey(res3,"TYPE") == "1"){//其他触发字段
									var otherTrigjson = {};
									var tempName = getValueByKey(res3,"DBFIELDNAME");
									if(alias != ""){
										tempName = alias+"."+tempName;
									}
									otherTrigjson.name = tempName;
									var tempFieldid = getValueByKey(res3,"PAGEFIELDNAME");
									otherTrigjson.fieldid = tempFieldid;
									var treenodeid = getValueByKey(res3[i], "treenodeid");
									var tempFieldValue = $("#" + tempFieldid).val();
									if(treenodeid && tempFieldValue){
										var tempFieldValuePrefix = treenodeid + "_";
										if(tempFieldValue.slice(0, tempFieldValuePrefix.length) != tempFieldValuePrefix){
											isTrigger = false;
										}
										tempFieldValue = tempFieldValue.replace(tempFieldValuePrefix, "");
									}
									otherTrigjson.value = tempFieldValue;
									otherTrigjsonarr.push(otherTrigjson);
								}else{
									var trigjson = {};
									trigjson.searchfieldname = getValueByKey(res3,"DBFIELDNAME");
									trigjson.beTriggerName = getValueByKey(res3,"PAGEFIELDNAME");
									trigjson.formid = formid;
									trigjsonarr.push(trigjson);
								}
							}
						}
					}
				});
			}
			if(isTrigger){
				setTriggerdetail(searchvalue, fromTable.substring(1), whereClause, triggercondition, result, trigjsonarr, datasourcename, modeid, otherTrigjsonarr);
			}
		}
	});
}

//给被联动的字段赋值
function setTriggerdetail(searchvalue, fromTable, whereClause, triggercondition, result, trigjsonarr, datasourcename, modeid, otherTrigjsonarr){
	var searchfieldname = "";
	var beTriggerName = "";
	var formid = "";
	
	var btvArray=new Array();
	if(searchvalue == ""){
		searchvalue = " * ";
	}else{
		searchvalue = searchvalue.substring(1);
	}
	//查询联动赋值字段的值
	var sql_last = "select "+searchvalue+" from "+fromTable+" where "+whereClause+" and "+triggercondition+"='"+result["value"]+"'";
	for(var n = 0; n < otherTrigjsonarr.length; n++){
		var dataN = otherTrigjsonarr[n];
		var valueN = dataN["value"];//其他触发字段一起查询，没有值就为空
		var nameN = dataN["name"];
		if(valueN == ""){
			sql_last += (" and (" + nameN + "='' or " + nameN + " is null)");
		}else{
			sql_last += (" and " + nameN + "='" + valueN + "'");
		}
	}
	SQL(sql_last, datasourcename, function(res_last){
		for(var m = 0; m < trigjsonarr.length; m++){
			var data = trigjsonarr[m];
			searchfieldname = data["searchfieldname"];//obj1
			beTriggerName = data["beTriggerName"];	  //field68611
			formid = data["formid"];				  //-3841
			
			var beTriggerValues = "";
			
			if(result["value"] == "" || result["value"] == null){
				var beTriggerValue = "";
				beTriggerValues += (","+beTriggerValue);
				btvArray[0] = beTriggerValue;
				
				setTriggerdetailByhtmltype(formid, searchfieldname, datasourcename, btvArray, beTriggerValues, beTriggerName, false, modeid);
			}else{
				if(res_last){
					if(res_last.length){
						var beTriggerValue = getValueByKey(res_last[0],searchfieldname);
						beTriggerValues += (","+beTriggerValue);
						btvArray[0] = beTriggerValues;
					}else{//这里应该只有一条数据，走else
						var beTriggerValue = getValueByKey(res_last,searchfieldname);
						beTriggerValues += (","+beTriggerValue);
						btvArray[0] = beTriggerValue;
					}
					
					setTriggerdetailByhtmltype(formid, searchfieldname, datasourcename, btvArray, beTriggerValues, beTriggerName, true, modeid);
				}else{
					var beTriggerValue = "";
					beTriggerValues += (","+beTriggerValue);
					btvArray[0] = beTriggerValue;
					
					setTriggerdetailByhtmltype(formid, searchfieldname, datasourcename, btvArray, beTriggerValues, beTriggerName, false, modeid);
				}
			}
			
		}
			
	});
}

function setTriggerdetailByhtmltype(formid, searchfieldname, datasourcename, btvArray, beTriggerValues, beTriggerName, istrigger, modeid){
	var beTriggerdetail = "";
	
	//由字段名和表单id，查询字段的类型
	//var sql_type = "select * from workflow_billfield where billid="+formid+" and fieldname='"+searchfieldname+"'";
	//模块下需要被联动的字段在新建布局中的字段类型(任何布局类型都一样，这里只是保证只出一个值)
	var sql_type = "select a.fieldhtmltype,a.type,b.isview,b.isedit,b.ismandatory from workflow_billfield a,modeformfield b where a.id=b.fieldid and b.type=1 and b.modeid="+modeid+" and a.id="+beTriggerName.substring(5);
	SQL(sql_type, "", function(res_type){
		if(res_type){
			
			if(!!res_type.length){//这里应该只有一条数据
				res_type = res_type[0];
			}
			
			var htmltype = getValueByKey(res_type,"fieldhtmltype");
			//参考List_wev8.js的initAdvancedSearchContent方法
			if(htmltype == "3"){	//browser
				var type = getValueByKey(res_type,"type");
				if(type == "2" || type == "19"){//日期和时间
					$("#"+beTriggerName).val(beTriggerValues.substring(1));
					$("#"+beTriggerName+"span").html(beTriggerValues.substring(1));
				}else{
					if(istrigger){
						//查询联动赋值字段的browser值
						var browserid = $("#"+beTriggerName).attr("bid");
						var url="/mobilemode/searchtriggerbrowser.jsp?browserId="+browserid+"&showField="+beTriggerName+"&datasourcename="+datasourcename+"&btvArrayString="+btvArray.toString();
						$.ajax({
							type : "get",
							url : url,
							async : false,
							success : function(data){
								if($.parseJSON(data)["status"]=="1"){
									beTriggerdetail = $.parseJSON(data)["beTriggerdetail"];
									//给联动的字段赋值
									$("#"+beTriggerName).val(beTriggerValues.substring(1));
									var btg = beTriggerdetail.substring(1) + "<span class=\"delBrowser\" onclick=\"javascript:onBrowserCancel('"+beTriggerName.substring(5)+"');\"></span>";
									$("#"+beTriggerName+"span").html(btg);
								}
							}
				 		});
					}else{
						$("#"+beTriggerName).val(beTriggerValues.substring(1));
						var btg = "<span class=\"delBrowser\" onclick=\"javascript:onBrowserCancel('"+beTriggerName.substring(5)+"');\" style=\"display:none;\"></span>";
						$("#"+beTriggerName+"span").html(btg);
					}
				}
				
			}else if(htmltype == "5"){	//select,要区分改造select前后情况，select改动过之后要给div赋值
				var beTriggerText = "fieldText" + beTriggerName.substring(5);//fieldText68611
				var jsonstr = $("#"+beTriggerName).attr("jsonstr");
				if(jsonstr && jsonstr != ""){
					if(istrigger){
						jsonstr = decodeURIComponent(jsonstr);
						var menu_datas = $.parseJSON(jsonstr);
						for(var i = 0; i < menu_datas.length; i++){
							var value = menu_datas[i]["menuValue"] || "";
							if(value == beTriggerValues.substring(1)){
								$("#" + beTriggerText).html(menu_datas[i]["menuText"]);
								$("#"+beTriggerName).val(beTriggerValues.substring(1));
								$("#"+beTriggerName+"span").html(menu_datas[i]["menuText"]);
								break;
							}
						}
					}else{
						$("#" + beTriggerText).html("");
						$("#"+beTriggerName).val(beTriggerValues.substring(1));
						$("#"+beTriggerName+"span").html("");
					}
					
				}else{
					$("#"+beTriggerName).val(beTriggerValues.substring(1));
					$("#"+beTriggerName+"span").html(beTriggerValues.substring(1));
				}
			}else {
				brRegex = /<br>/g;
				replaceBrValue = "\n";
				spaceRegex = /&nbsp;/g;
				replaceSpaceValue = " ";
				beTriggerValues = beTriggerValues.replace(brRegex, replaceBrValue).replace(spaceRegex, replaceSpaceValue);
				//给联动的字段赋值
				$("#"+beTriggerName).val(beTriggerValues.substring(1));
				$("#"+beTriggerName+"span").html(beTriggerValues.substring(1));
			}
		}
	});
}