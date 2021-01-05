function showdiv() {
	jQuery("#szsyjfsbg").show();
	jQuery("#szsyjfsshow").show();
	if(js_clienttype!=''&&js_clienttype!='Webclient'){
		jQuery("body").css("height"," 100%");
		jQuery("body").css("overflow","hidden");
		jQuery("body").css("width","100%");
		jQuery("body").css("position","fixed");
	}
      
	 if($(".cardeditContentTable").height()>$(window).height()-90){
		$(".cardeditContentTable").css("height",($(window).height()-90)+"px"); 
		$(".cardeditContentTable").css("overflow-y","auto");  
	 } 
}

function hidediv() {
    jQuery("#szsyjfsbg").hide();
    jQuery("#szsyjfsshow").hide();
	if(js_clienttype!=''&&js_clienttype!='Webclient'){
		jQuery("body").css("height","");
		jQuery("body").css("overflow","");
		jQuery("body").css("width","");
		jQuery("body").css("position","");
	}
}

function showCssDiv(obj,idstr,keyid,keyval){
	  jQuery(".szsyjfsul1 li").each(function(){
	       if(jQuery(this).attr("id") == "szsyfsulid"+keyid){
				 jQuery(this).attr("class","cursor");
		   }else{
                 jQuery(this).attr("class","");
		   }
	  });
	 try{
      
		jQuery("select[id='"+idstr+"'] option").each(function(){
			  if(jQuery(this).attr("value") == keyid){
					jQuery(this).attr("selected","selected");
			  }else{
					jQuery(this).removeAttr("selected");
			  }
		});
		jQuery("select[id='"+idstr+"']").val(keyid);
		jQuery("input[id='szsyjfsui"+idstr+"']").each(function(){
		      jQuery(this).val(keyval);
			  jQuery(this).attr("value",keyval);
		});
		jQuery("select[id='"+idstr+"'] option").change();
	 }catch(e){}
	 try{
		 var fieldid = (idstr.split("_")[0]+"").replace("field","");
		var rowid = (idstr.split("_")[1]+"");
		var showdivid=jQuery("input[type='hidden'][id='"+(fieldid+rowid)+"']").val();
		jQuery("div[id='"+showdivid+"']").html(keyval);
	 }catch(ev){}

	 try{
		  if(jQuery("#"+idstr+"_ismandspan").attr("class")&&jQuery("#"+idstr+"_ismandspan").attr("class")=='ismand'){
			    if(keyid==''){
					 jQuery("#"+idstr+"_ismandspan").css("display","block");
					 jQuery("#"+idstr+"_d_ismandspan").css("display","block");
				}else{
					jQuery("#"+idstr+"_ismandspan").css("display","none");
					jQuery("#"+idstr+"_d_ismandspan").css("display","none");
				}
		  }
	 }catch(e){
	 }

	  hidediv();
     jQuery("#szsyjfsshow").html("");
}

function cardSaveInfo(_this,initSaveInfo){
  var contentkey=""+$(_this).attr("content").replace("new@#$","");
                          var fieldidStr=contentkey.replace("isshow","");
						  var fieldid="";
						  var fieldformartid="";
						  try{
						     fieldid="field"+fieldidStr.split("_")[2]+"_"+fieldidStr.split("_")[1];
							 fieldformartid="fieldformart"+fieldidStr.split("_")[2]+"_"+fieldidStr.split("_")[1];
							 var fieldvalue=$("#"+fieldid).val();
							 $("#"+fieldid).attr("value",$("#"+fieldid).val());
							  $("#"+contentkey).html(fieldvalue);
							 if($("#"+fieldformartid).length>0){
								  var fieldformartvalue=$("#"+fieldformartid).val();
								  $("#"+fieldformartid).attr("value",$("#"+fieldformartid).val());
								  $("#"+contentkey).html(fieldformartvalue);
							 }

                             if($("#"+fieldid+"_span").length>0){
								  $("#"+contentkey).html($("#"+fieldid+"_span").html());
							 }
							 if($("#"+fieldformartid+"_span").length>0){
								  $("#"+contentkey).html($("#"+fieldformartid+"_span").html());
							 }

							 if($("#"+fieldid).attr("datavaluetype")!=undefined&&$("#"+fieldid).attr("datavaluetype")!=null&&$("#"+fieldid).attr("datavaluetype")=='4'){
								   if($("#"+fieldid.replace("field","field_chinglish")).length>0){
									    $("#"+fieldid.replace("field","field_chinglish")).attr("value",$("#"+fieldid.replace("field","field_chinglish")).val());
										$("#"+fieldid.replace("field","field_lable")).attr("value",$("#"+fieldid.replace("field","field_lable")).val());
										var fieldValue=$("#"+fieldid.replace("field","field_lable")).val();
										if(fieldValue!=''){
											  fieldValue= "("+$("#"+fieldid.replace("field","field_lable")).val()+")";
										}else{
											fieldValue= "";
										}
									     $("#"+contentkey).html($("#"+fieldid.replace("field","field_chinglish")).val()+fieldValue); 
								   }
							 }
							 if($("#"+fieldid).is("textarea")){
								$("#"+fieldid).html($("#"+fieldid).val()); 
							 }

							  if($("#"+fieldid).is("input[type='checkbox']")){
								var checkobj=  $("#"+fieldid).clone();
								checkobj.attr("disabled","disabled");
                                checkobj.removeAttr("name");
								checkobj.removeAttr("id");
								if($("#"+fieldid).is(":checked")){
									$("#"+fieldid).attr("checked",true); 
								}else{
                                    $("#"+fieldid).removeAttr("checked"); 
								}
								$("#"+contentkey).html(checkobj);
							 }
							 if($("#"+fieldid).is("select")){
                                var selectText= $("#"+fieldid).find("option:selected").text();
								 $("#"+contentkey).html(selectText);
								 
								var  selectVal =  $("#"+fieldid).find("option:selected").val();
								$("#"+fieldid).find("option").each(function(){
								     if($(this).val()==selectVal){
										  $(this).attr("selected","selected");
									 }else{
									      $(this).removeAttr("selected");
									 }
								});

							 }
						  }catch(e){}
                          if(initSaveInfo){
                              
						  }else{
							   $(_this).find("div[name='hiddenEditdiv']").hide();
							   if($("tr[key='"+contentkey+"']").find("td[cardtdflag='content']").find("div[name='hiddenEditdiv']").length>0){
									 $("tr[key='"+contentkey+"']").find("td[cardtdflag='content']").find("div[name='hiddenEditdiv']").remove();
							   }
							   $("tr[key='"+contentkey+"']").find("td[cardtdflag='content']").append($(_this).find("div[name='hiddenEditdiv']"));
							   $(_this).find("div[name='hiddenEditdiv']").remove();
						  }
						  try{
							  var isCalSum= false;
							 if($("#"+fieldid).attr("onchange")!=null&&$("#"+fieldid).attr("onchange")!=undefined&&$("#"+fieldid).attr("onchange").indexOf("calSum")!=-1){
								   isCalSum= true;
							 }
							 if($("#"+fieldid).attr("onblur")!=null&&$("#"+fieldid).attr("onblur")!=undefined&&$("#"+fieldid).attr("onblur").indexOf("calSum")!=-1){
								  isCalSum= true;
							 }
							 if(isCalSum){
							   calSum(fieldidStr.split("_")[2]);
							 }
						  }catch(e){}
}

//获取当前所属的位置
function  getArrayOfIndex(trIndex,ArrayObj){
	var indexInfo = 0;
	  if(ArrayObj.length>0){
		     for(var i=0;i<ArrayObj.length;i++){
				   if(ArrayObj[i] == trIndex){
					   indexInfo = i;
					   break;
				 }
			 }
	  }
	return indexInfo;
}

//获取下一行所属的行号
function getNextArrayIndex(tableTrNum,ArrayObj){
	  var indexInfo = ArrayObj[(ArrayObj.length-1)];
	  if(tableTrNum <(ArrayObj.length-1)){
		   indexInfo =ArrayObj[tableTrNum+1]; 
	  }
	return indexInfo;
}

//获取上一行所属的行号
function getUpArrayIndex(tableTrNum,ArrayObj){
	  var indexInfo = 0;
	  if(tableTrNum >0){
		   indexInfo =ArrayObj[tableTrNum-1]; 
	  }
	return indexInfo;
}


function showUlDiv(type,groupindex,trIndex,isread){
	var cardTableObj =  $("table[key='cardeditcontent"+groupindex+"_"+trIndex+"']");
	var ziduanInfoHtml = "";
	var cardTableLength=cardTableObj.find("tr[key^='isshow"+groupindex+"_"+trIndex+"']").length;
	var tableOldJSON=[];
	var totalTrCount=$("#nodenum"+groupindex).val();
	var tdRCount =0;
	var arrayViewArray = new Array();
     $("tr[name^='trView_"+groupindex+"_']").each(function(index){
		 var trviewname =  $(this).attr("name");
		 if(trviewname.indexOf("_card")==-1){
			 try{
			 arrayViewArray.push(trviewname.split("_")[2]);
			 }catch(e){
			 }
			   tdRCount++;
		 }
	 });
	 if(tdRCount!=0){
		  totalTrCount = tdRCount;
	 }
    
    var iseditcount=0;
    cardTableObj.find("tr[key^='isshow"+groupindex+"_"+trIndex+"']").each(function(rowindex){
			var cardkey=$(this).attr("key");
			var fieldCardId="";
			try{
				if(cardkey.indexOf("_")!=-1){
				   fieldCardId="field"+cardkey.split("_")[2]+"_"+trIndex;
				}
			}catch(e){}
            var cardtitleClass=$(this).find("td[cardtdflag='title']").attr("class");
			try{
				if(cardtitleClass !=null && cardtitleClass !=undefined && cardtitleClass.indexOf("detail_hide_col")!=-1 &&  cardtitleClass.indexOf("realhide")!=-1  ){
					 cardtitleClass = " detail_hide_col ";
					  //$(this).find("td[cardtdflag='content']").find("div[name='hiddenEditdiv']").find("span[class='ismand']").removeAttr("class");
					 //$(this).find("td[cardtdflag='content']").find("div[name='hiddenEditdiv']").find("input[type='hidden'][name='ismandfield']").val("");

				}else{
				  cardtitleClass="";
				}
			}catch(e){}
			var cardtitlehtml=$(this).find("td[cardtdflag='title']").html();
			
			//复制一份字段相关内容信息
			var  cardContentObj=$(this).find("td[cardtdflag='content']").clone();
			cardContentObj.find("div[name='hiddenEditdiv']").siblings().remove();
			//将隐藏编辑的原始控件的去掉
			var oldhiddenEditdiv=$(this).find("td[cardtdflag='content']").find("div[name='hiddenEditdiv']");
			tableOldJSON[rowindex]={"key":cardkey,"content":oldhiddenEditdiv};
			try{
				if(oldhiddenEditdiv.find("input[isedit='1']").length>0){
					  iseditcount++; 
				}else if(oldhiddenEditdiv.find("textarea[isedit='1']").length>0){
					 iseditcount++; 
				}else if(oldhiddenEditdiv.find("select[isedit='1']").length>0){
					 iseditcount++;
				}
			}catch(e){}
			try{
			  cardContentObj.find("div[name='hiddenEditdiv']").find("input[datavaluetype='4']").each(function(){
			 					 jezhcardshow(this);
			  });
		   }catch(e){}
		   try{
			   cardContentObj.find("div[name='hiddenEditdiv']").find("select").each(function(){
			 				$(this).change();
			  });
		   }catch(e){}
			oldhiddenEditdiv.remove();
			try{
		    	$(cardContentObj.find("div[name='hiddenEditdiv']").find("table")[0]).css("width","90%");
			}catch(e){}
			cardContentObj.find("div[name='hiddenEditdiv']").show();
			
			var cardContentHtml = cardContentObj.html();

			if(rowindex ==(cardTableLength-1)){
				  ziduanInfoHtml += "    <tr class=\""+cardtitleClass+"\">";
				  ziduanInfoHtml += "      <td class=\"cardeditContentTableTd03\">"+cardtitlehtml+"</td>";
		          ziduanInfoHtml += "      <td content=\"new@#$"+cardkey+"\" id=\""+fieldCardId+"_tdwrap\">"+cardContentHtml+"</td>";
		          ziduanInfoHtml += "    </tr> ";
			}else{
				 ziduanInfoHtml += "    <tr class=\""+cardtitleClass+"\">";
				 ziduanInfoHtml += "      <td class=\"cardeditContentTableTd01\">"+cardtitlehtml+"</td>";
		         ziduanInfoHtml += "      <td class=\"cardeditContentTableTd02\" content=\"new@#$"+cardkey+"\" id=\""+fieldCardId+"_tdwrap\">"+cardContentHtml+"</td>";
		         ziduanInfoHtml += "    </tr> ";
			}
		   
	});
	var tableindex = (new Number(groupindex)+1);
	var tableTrNum = getArrayOfIndex(trIndex,arrayViewArray);
	var tabletrindex = (new Number(tableTrNum)+1);
	var tableTrNo = (new Number(trIndex)+1);
	  var uiHtml = "<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\" style=\"width:100%;height:100%;\">";
	      uiHtml += " <tbody><tr><td> ";
		      uiHtml += "<div class=\"cardeditTitleDiv\">";
			  uiHtml += " <table class=\"cardeditTitleTable\" cellspacing=\"0\" cellpadding=\"0\" style=\"width:100%;\">";
		    if(type == 'edit'){
              uiHtml += "    <tbody> <tr> ";
			 
			  if($("#detailheadtitle"+tableindex).length>0){
				   uiHtml +="<td></td> ";
				   uiHtml += "    <td>  <span >"+($("#detailheadtitle"+tableindex).html())+"</span> </td>  </tr></tbody></table></div> ";
			  }else{
				 uiHtml +="<td> <img src=\"/mobile/plugin/1/images/cardedit.png\" /> </td> ";
			    uiHtml += "    <td>  <span class=\"cardeditTitleSpan\">编辑行(明细表"+tableindex+")</span> </td>  </tr></tbody></table></div> ";
			  }
			}else{
              uiHtml += "    <tbody><tr> ";
			   if($("#detailheadtitle"+tableindex).length>0){
				 uiHtml += "  <td>  </td> ";
			     uiHtml += "    <td>  <span >"+($("#detailheadtitle"+tableindex).html())+"</span> </td>  </tr></tbody></table></div> ";
			   }else{
			    uiHtml += "  <td> <img src=\"/mobile/plugin/1/images/carddetail.png\" /> </td> ";
			    uiHtml += "    <td>  <span class=\"cardeditTitleSpan\">详细信息(明细表"+tableindex+")</span> </td>  </tr></tbody></table></div> ";
			   }
			}

			  uiHtml += "    <div class=\"cardeditTitleClose\"><img src=\"/mobile/plugin/1/images/cardclose.png\" id='close"+groupindex+"_"+trIndex+"' /></div>";
			  uiHtml += " ";
          uiHtml += "</td></tr>";
		  uiHtml += "<tr><td>";
				  uiHtml += "<div class=\"cardeditContentTable\"><table cellspacing=\"0\" cellpadding=\"0\" border=\"0\" width=\"100%\" height=\"100%\" >";
				  uiHtml += " <tbody>";
				  uiHtml += "   <tr>";
				  uiHtml += "      <td class=\"cardeditContentTableTd01 fontbold\">序号</td>";
                  uiHtml += "      <td class=\"cardeditContentTableTd02 fontbold\">"+tabletrindex+"</td>";
				  uiHtml += "   </tr> ";
				  uiHtml += ziduanInfoHtml;
				  uiHtml += "     </tbody></table></div> </td> </tr> ";
			uiHtml += "   <tr><td> ";
			if(iseditcount>0){
               if(type == 'edit'||(totalTrCount==1&&tabletrindex==1)){
					if(isread>0){
					   uiHtml += "    <div class=\"cardeditContentTableOprator\" ><div class=\"nextHandleOprator\" id='save"+groupindex+"_"+trIndex+"'>保存</div><div id=\"new"+groupindex+"_"+trIndex+"\">新增一行</div></div> ";
					 }
				}else{
					if(tabletrindex==1 && totalTrCount>1 ){
						   uiHtml += "    <div class=\"cardeditContentTableOprator\" id=\"next"+groupindex+"_"+trIndex+"\">下一行</div> ";
					}else if(tabletrindex==totalTrCount){
						if(isread>0){
							 uiHtml += "    <div class=\"cardeditContentTableOprator\" ><div class=\"nextHandleOprator\" id=\"up"+groupindex+"_"+trIndex+"\">上一行</div><div id=\"save"+groupindex+"_"+trIndex+"\">保存</div><</div> ";
						}else{
							 uiHtml += "    <div class=\"cardeditContentTableOprator\"  id=\"up"+groupindex+"_"+trIndex+"\">上一行</div> ";  
						}
						 
					}else{
						uiHtml += "    <div class=\"cardeditContentTableOprator\" ><div class=\"nextHandleOprator\" id=\"up"+groupindex+"_"+trIndex+"\">上一行</div><div id=\"next"+groupindex+"_"+trIndex+"\">下一行</div></div> ";
					}
				}
			}
			uiHtml += "    </td></tr></tbody>";
            uiHtml +="</table>";

		  jQuery("#szsyjfsshow").html(uiHtml);
		  try {
			clearInterval(ckInterval);
		} catch (e){}
		  setInterval("setRedflag()",1000);
          try{
			  $("td[content^='new@#$']").each(function(){
					 $(this).find("input[class='scroller_date']").scroller({preset: 'date',dateFormat:'yy-mm-dd',theme: 'default',display: 'bottom', mode: 'scroller',endYear:2020,nowText:'今天',setText:'确定',cancelText:'取消',monthText:'月',yearText:'年',dayText:'日',showNow:true,dateOrder: 'yymmdd',onShow: moveDataTimeContorl});
					 $(this).find("input[class='scroller_time']").scroller({preset: 'time',timeFormat:'HH:ii',theme: 'default',display: 'bottom',mode: 'scroller',nowText:'现在',setText:'确定',cancelText:'取消',minuteText:'分',hourText:'时',timeWheels:'HHii',showNow:true,onShow: moveDataTimeContorl});
			  });
          }catch(e){alert(e);}

		  try{
			  //关闭按钮事件
			  $("#close"+groupindex+"_"+trIndex+"").click(function(){
					 if(tableOldJSON.length>0){
						   var oldJsonLength =tableOldJSON.length;
						   for(var i=0;i<oldJsonLength;i++){
								 var oldJsonObj=tableOldJSON[i];
								 if($("tr[key='"+oldJsonObj.key+"']").find("td[cardtdflag='content']").find("div[name='hiddenEditdiv']").length>0){
									 $("tr[key='"+oldJsonObj.key+"']").find("td[cardtdflag='content']").find("div[name='hiddenEditdiv']").remove();
								 }
								 $("tr[key='"+oldJsonObj.key+"']").find("td[cardtdflag='content']").append(oldJsonObj.content);
						   }
					 }
					 hidediv();
					 try{
					    calSum(groupindex);
					 }catch(e){}
					 $("#showcardhidden").val("");
			  });
			   //上一行
                $("#up"+groupindex+"_"+trIndex+"").click(function(){
					if(isread>0){
				      $("td[content^='new@#$']").each(function(){
						 cardSaveInfo(this);
					  });
					}
                    showUlDiv(type,groupindex,(new Number(getUpArrayIndex(tableTrNum,arrayViewArray))),isread);
			   });
			   //下一行
			   $("#next"+groupindex+"_"+trIndex+"").click(function(){
				   if(isread>0){
				      $("td[content^='new@#$']").each(function(){
						 cardSaveInfo(this);
					 });
				   }
                    showUlDiv(type,groupindex,(new Number(getNextArrayIndex(tableTrNum,arrayViewArray))),isread);
			   });
			  //保存事件
			  $("#save"+groupindex+"_"+trIndex+"").click(function(){
					$("td[content^='new@#$']").each(function(){
						 cardSaveInfo(this);
					});
					var idstr=$(this).attr("id").replace("save","editCardShow");
					 if($("#"+idstr).length>0&&$("#"+idstr).attr("editcardshowcount")>0){
						     hidediv(); 
							 $("#showcardhidden").val("");
					 }

					
			  });

			  //新增一行
			  $("#new"+groupindex+"_"+trIndex+"").click(function(){
			        $("#save"+groupindex+"_"+trIndex+"").click();
					try{
						eval("addRow"+groupindex+"("+groupindex+")");

                         var trrowindex = (new Number($("#nodenum"+groupindex).val())-1);
						try{
							detailattrshow(trrowindex);
							formuaAttrShowDetail(trrowindex);
						}catch(e){}
					}catch(e){}
			  });

		  }catch(e){}
		   var _scrollHeight = $(document).scrollTop();//获取当前窗口距离页面顶部高度 
			var _windowHeight = $(window).height();//获取当前窗口高度 
			var _windowWidth = $(window).width();//获取当前窗口宽度 
			var _popupHeight = jQuery("#szsyjfsshow").height();//获取弹出层高度 
			var _popupWeight = jQuery("#szsyjfsshow").width();//获取弹出层宽度 
			var _posiTop = (_windowHeight - _popupHeight)/2 + _scrollHeight;
		  jQuery("#szsyjfsbg").css("height",jQuery(document).height()+"px");
	      showdiv();
		  $("#showcardhidden").val("1");
		  $("#showcardhidden").attr("closeAttr","save"+groupindex+"_"+trIndex+"");
}


//编辑与详细内容
function cardeditshow(type,groupindex,trIndex,isreadCount){
     showUlDiv(type,groupindex,trIndex,isreadCount);
	 if($("#editCardShow"+groupindex+"_"+trIndex).length>0){
		 var editCardShowObj = $("#editCardShow"+groupindex+"_"+trIndex);
		 var editcardshowcount=new Number(editCardShowObj.attr("editcardshowcount"));
		 if(editcardshowcount==0){
			 /*  $("td[content^='new@#$']").each(function(){
						 cardSaveInfo(this,true);
				});*/
		 }
		 editCardShowObj.attr("editcardshowcount",(editcardshowcount+1));
	 }
   
}

function carddeleshow(groupindex,trIndex){
    $("input[type='checkbox'][name='check_node_"+groupindex+"'][_rowindex='"+trIndex+"']").attr("checked","checked");
	eval("deleteRow"+groupindex+"('"+groupindex+"','delcard','"+trIndex+"')");
}



function checkAllHandler(groupindex,type){
	var checkAllRecordObj = $("input[name='check_all_record'][groupindex='"+groupindex+"']");
	if(type=='yes'){
	     checkAllRecordObj.attr("checked",true);
	}else{
		 checkAllRecordObj.attr("checked",false);
	}
	  checkAllRecordObj.click();
	if(type=='yes'){ 
	   $("#checkAllCk"+groupindex).hide();
	   $("#checkAllQx"+groupindex).hide();
	   $("allcheckckbox"+groupindex).attr("checked",true);
	    checkAllRecordObj.attr("checked",true);
	}else{
       $("#checkAllCk"+groupindex).show();
	   $("#checkAllQx"+groupindex).show(); 
	   $("#allcheckckbox"+groupindex).attr("checked",false);
	    checkAllRecordObj.attr("checked",false);
	}
}
//拼接全选与取消html元素
function getCheckAllHtml(groupindex){
	var checkAllRecordObj = $("input[name='check_all_record'][groupindex='"+groupindex+"']");
	 var checkAllTargetHtml = " <table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"width:100%;height:100%;\">";
	if(checkAllRecordObj.is(":disabled")){
		 checkAllTargetHtml += " <tbody><tr> ";
		 checkAllTargetHtml += " <td style=\"width:24%;\" id=\"checkAllCk"+groupindex+"\"><input type=\"checkbox\"  id=\"allcheckckbox"+groupindex+"\" class=\"allchecked_ck\"   disabled /></td> ";
		 checkAllTargetHtml +="     <td style=\"width:28%;\" id=\"checkAllQx"+groupindex+"\"> ";
		 checkAllTargetHtml +=" <span class=\"allchecked_span\"   >全选</span></td> ";
		 checkAllTargetHtml +=" <td id=\"checkAllQx"+groupindex+"\"><span class=\"allchecked_cancelspan\" >取消</span></td>";
	}else{
		 checkAllTargetHtml += " <tbody><tr> ";
		 checkAllTargetHtml += " <td style=\"width:24%;\" id=\"checkAllCk"+groupindex+"\"><input type=\"checkbox\"  id=\"allcheckckbox"+groupindex+"\" class=\"allchecked_ck\"   onclick=\"checkAllHandler("+groupindex+",'yes')\" ></td> ";
		 checkAllTargetHtml +="     <td style=\"width:28%;\" id=\"checkAllQx"+groupindex+"\"> ";
		 checkAllTargetHtml +=" <span class=\"allchecked_span\"   onclick=\"checkAllHandler("+groupindex+",'yes')\">全选</span></td> ";
		 checkAllTargetHtml +=" <td id=\"checkAllQx"+groupindex+"\"><span class=\"allchecked_cancelspan\" onclick=\"checkAllHandler("+groupindex+",'no')\">取消</span></td>";
	}						
	checkAllTargetHtml +=" </tr></tbody></table>";
   
   return checkAllTargetHtml;
}

//解析全选与取消按钮
function  parseCheckAllCancalButton(_this,groupindex,checkalldetailTr){
    if($(_this).find("input[type='checkbox'][name='check_all_record']").length>0){ //判断是否添加全选与取消按钮
					if($(_this).find("tr[class='exceldetailtitle ']").length>0){
						var check_all_recordobj =$(_this).find("input[type='checkbox'][name='check_all_record']");
						check_all_recordobj.attr("groupindex",groupindex);
						 var  checkalldetailTd=$(checkalldetailTr[0]).find("td");
						 checkalldetailTd.css("height","45px");
						 var  checkallcolspanstr= new Number(checkalldetailTd.attr("colspan"));
						 if(!isNaN(checkallcolspanstr)){
							 if(checkallcolspanstr%2==0){
								  checkalldetailTd.attr("colspan",(checkallcolspanstr/2));
							 }else{
									   checkalldetailTd.attr("colspan",(checkallcolspanstr- Math.round((checkallcolspanstr/2))));
							 }
							
                             var  checkalldetailTdTarget = checkalldetailTd.clone();
							 if(checkallcolspanstr%2!=0){
								   checkalldetailTdTarget.attr("colspan",(Math.round((checkallcolspanstr/2))));
							 }
						         checkalldetailTdTarget.html("");
								// checkalldetailTdTarget.html(getCheckAllHtml(groupindex));
								 checkalldetailTd.before(checkalldetailTdTarget);

						 }else{
							  var lastindex=$(checkalldetailTr[0]).find("td").length;
							  var checkalldetailTd =$($(checkalldetailTr[0]).find("td")[lastindex-1]);
						      checkalldetailTd.siblings().remove();
							  var  checkalldetailTdTarget=  checkalldetailTd.clone();
                              checkalldetailTdTarget.attr("colspan",(lastindex-1));
							  checkalldetailTdTarget.html("");
                              // checkalldetailTdTarget.html(getCheckAllHtml(groupindex));
							  checkalldetailTd.before(checkalldetailTdTarget);
						 }
						 
					}
		}
   
}


function cardTableData(_this,tdindex,groupindex,tableheadObj,type){
                           var tdViewDataObj = $(_this).find("td[class^='detail"+groupindex+"_']");
						   var  trIndex = $(_this).attr("name");
						   var trName=trIndex;
						   if(trIndex!=null&&trIndex!=undefined&&trIndex.indexOf("_")!=-1){
							   try{
							      trIndex = trIndex.split("_")[2];
							   }catch(e){
							       if(tdindex!=null&&tdindex!=undefined){
                                        trIndex = tdindex;
								   }
							   }
						   }
						   var specialHtml = isSpecialHandler(groupindex);
						   var ckHtml = "";
						   var xhHtml = "";
						   var lieHtml = "";
						   var trfirstClass="";
						   var trlastClass = "";
						   var isreadCount = 0;
						   var fisrtAll = 0;
						   var lieSpeHtml="";
						   var speciltotalArray=new Array();
						   tdViewDataObj.each(function(tviewindex){
							   if(type=='hj'){
								     if(tviewindex==0){
										 trfirstClass = $(this).attr("class");
								     }
                                    
                                      xhHtml = "合计";
									 if ( $(this).attr("id") !=undefined && $(this).attr("id")!=null && $(this).attr("id").indexOf("sum")!=-1){
									     lieHtml += " <tr> ";
										 lieHtml += "   <td style=\"width:30%;height:30px;\" class=\""+tableheadObj[tviewindex+1].classStr+"\"  cardtdflag=\"title\" > "+ tableheadObj[tviewindex+1].html+"</td>";


										 lieHtml += "    <td class=\""+$(this).attr("class")+"\" cardtdflag=\"content\" id=\""+$(this).attr("id")+"\">"+$(this).html()+"</td>";
										 lieHtml+= "</tr>";
										  $(this).removeAttr("id");
									 }
									 if(tviewindex=(tdViewDataObj.length-1)){
										   trlastClass = $(this).attr("class");
									}	
									 $(this).html("");
							   }else{
								   if(tviewindex==0){
										 trfirstClass = $(this).attr("class");
								   }
									if($(this).find("input[name='check_node_"+groupindex+"']").length>0){
                                         if(detailSpecialInfo=='1'&&specialHtml){
											 $(this).find("input[name='check_node_"+groupindex+"']").css("width","18px").css("height","18px");
										 }else{
										    $(this).find("input[name='check_node_"+groupindex+"']").css("width","22px").css("height","22px");
										 }
										 ckHtml=   $(this).html();
									}else  if($(this).find("span[name='detailIndexSpan"+groupindex+"']").length>0){
										 xhHtml=   $(this).html();
									}else{
										if(detailSpecialInfo=='1'&&specialHtml){
										  lieSpeHtml = "<table width=\"100%\" height=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\">";
										  lieHtml="";
                                        }
										var trflag = $(this).find("div[id^='isshow']");
										var trflagStr="";
										if(trflag!=undefined&&trflag!=null){
											  trflagStr = trflag.attr("id");
										}
                                        var classStr="";
                                        if(trflagStr==undefined){
										    classStr= "detail_hide_col realhide";
										}
										if(classStr==''&&tableheadObj[tviewindex]!=undefined && tableheadObj[tviewindex].classStr!=undefined){
											  if(tableheadObj[tviewindex].classStr.indexOf("detail_hide_col")!=-1){
													  classStr= "detail_hide_col realhide";
											  }
										}
										 lieHtml += " <tr key=\""+trflagStr+"\" class=\""+classStr+"\"> ";
										 if(trflagStr!=undefined && detailSpecialInfo=='1'&&specialHtml){
											 var fisrField = isShowFieldInfo(groupindex);
                                             if(fisrField!=''){
												  if($(this).html().indexOf(fisrField)!=-1){
													    lieHtml += "<td style=\"width:10%;height:30px;\">"+ckHtml+"</td>";   
												  }else{
													   lieHtml += "<td style=\"width:7%;height:30px;\"></td>";
												  }
											 }else{
													if(fisrtAll==0){
														  lieHtml += "<td style=\"width:10%;height:30px;\">"+ckHtml+"</td>";  
														  fisrtAll++;
													}else{
														  lieHtml += "<td style=\"width:7%;height:30px;\"></td>";  
													}
											 }
										    lieHtml += "   <td style=\"width:30%;height:30px;display:none;\" class=\""+tableheadObj[tviewindex].classStr+"\"  cardtdflag=\"title\" > "+ tableheadObj[tviewindex].html+"</td>";
										 }else{
                                            lieHtml += "   <td style=\"width:30%;height:30px;\" class=\""+tableheadObj[tviewindex].classStr+"\"  cardtdflag=\"title\" > "+ tableheadObj[tviewindex].html+"</td>";
										 }

										 lieHtml += "    <td class=\""+$(this).attr("class")+"\" cardtdflag=\"content\">"+$(this).html()+"</td>";
										 lieHtml+= "</tr>";
										 if($(this).find("div[name='hiddenEditdiv']").length>0){
											  isreadCount++;
										 }
							            if(detailSpecialInfo=='1'&&specialHtml){
											 lieSpeHtml =lieSpeHtml+lieHtml+" </table>";
										   speciltotalArray.push(lieSpeHtml);
										}
										
									}
									if(tviewindex=(tdViewDataObj.length-1)){
										   trlastClass = $(this).attr("class");
									}	
									 $(this).html("");
							   }
						   });

						   if(detailSpecialInfo=='1'&&specialHtml&&detailSpecialRowConfig!=''&&speciltotalArray.length>0){
							   try{
                                 if(detailSpecialRowConfig.indexOf("%")!=-1){
									 var  detailRowConfig= detailSpecialRowConfig.split("%");
									 var htmlSpecial="";
										 for(var drc=0;drc<detailSpecialRowConfig.split("%").length;drc++){
											   var detailRowC =   detailSpecialRowConfig.split("%")[drc];
											 if(detailRowC.indexOf("$")!=-1&&detailRowC.split("$").length>=2){
												var maxFieldCount=0;
												var speciatlgroupindex=detailRowC.split("$")[0];
											   if(speciatlgroupindex==groupindex){
												   var speciatlTrCounts=detailRowC.split("$")[1];
													if(speciatlTrCounts.indexOf("-")!=-1){
														var   liePpArray = new Array();
														var lieindex = 0;
														 var  speciatotaltrcount=speciatlTrCounts.split("-")[0];
														 var  specitTrTotalHtml = "";
														  //获取最大的列数
														  for(var si=1;si<speciatlTrCounts.split("-").length;si++){
																 var   speciTdArray= speciatlTrCounts.split("-")[si];
																 if(speciTdArray.indexOf(":")!=-1){
																		var  tdRowCount=speciTdArray.split(":")[0];
																		if(maxFieldCount<tdRowCount){
																			maxFieldCount=tdRowCount;
																		}

																 }
														  }
														  var indexPrecent=maxFieldCount/100;
														  //拼接列
														  var liePpFieldHtml="";
														   for(var sk=1;sk<speciatlTrCounts.split("-").length;sk++){
																	var   speciTdArray= speciatlTrCounts.split("-")[sk];
																	 if(speciTdArray.indexOf(":")!=-1){
																			var  tdRowFields=speciTdArray.split(":")[1];
																			var  tdRowCount=speciTdArray.split(":")[0];
																				liePpFieldHtml+="<tr>";  
																				for(var st=0;st<tdRowFields.split(",").length;st++ ){
																					 for(var sa=0;sa<speciltotalArray.length;sa++){
																							 var  specilArray= speciltotalArray[sa];
																							if(specilArray.indexOf(tdRowFields.split(",")[st])!=-1){
																								 if(tdRowCount<maxFieldCount){
																									 liePpFieldHtml+="<td colspan=\""+maxFieldCount+"\">"+specilArray+"</td>";  
																								 }else{
																									  liePpFieldHtml+="<td  style=\"width:"+indexPrecent+"%\">"+specilArray+"</td>";   
																								 }	
																								 liePpArray[lieindex] = sa;
																								 lieindex++;
																							}
																					}
																				}
																				liePpFieldHtml+="</tr>";
																	}
														  }
														  var liebpFieldHtml ="<tr  colspan=\""+maxFieldCount+"\" style=\"display:none\"><td>";
														  for(var sarray=0;sarray<speciltotalArray.length;sarray++){
																var  specilArray= speciltotalArray[sarray];
																var  isspecilbool =false;
																for(var dde=0;dde<liePpArray.length;dde++){
																	   if(sarray==liePpArray[dde]){
																		    isspecilbool =true;
																			break;
																	   }
																}
																if(isspecilbool){
																	continue;
																}
																if(specilArray!=''){
																  liebpFieldHtml +=specilArray;
																}
														  }
														 liebpFieldHtml +="</td></tr>";
														 htmlSpecial +="<table width=\"100%\" height=\"100%\" cellspacing=\"0\" cellpadding=\"0\"  border=\"0\">"+liePpFieldHtml+liebpFieldHtml+"</table>";
													}
											}
											
										 } 
									 }
									 lieHtml=htmlSpecial;
								 }else{
								    if(detailSpecialRowConfig.indexOf("$")!=-1&&detailSpecialRowConfig.split("$").length>=2){
									    var maxFieldCount=0;
									    var speciatlgroupindex=detailSpecialRowConfig.split("$")[0];
										if(speciatlgroupindex==groupindex){
											   var speciatlTrCounts=detailSpecialRowConfig.split("$")[1];
												if(speciatlTrCounts.indexOf("-")!=-1){
													 var  speciatotaltrcount=speciatlTrCounts.split("-")[0];
													 var  specitTrTotalHtml = "";
													  //获取最大的列数
													  for(var si=1;si<speciatlTrCounts.split("-").length;si++){
														     var   speciTdArray= speciatlTrCounts.split("-")[si];
															 if(speciTdArray.indexOf(":")!=-1){
																    var  tdRowCount=speciTdArray.split(":")[0];
                                                                    if(maxFieldCount<tdRowCount){
																		maxFieldCount=tdRowCount;
																	}

															 }
													  }
													  var indexPrecent=maxFieldCount/100;
                                                      //拼接列
													  var liePpFieldHtml="";
													   for(var sk=1;sk<speciatlTrCounts.split("-").length;sk++){
																var   speciTdArray= speciatlTrCounts.split("-")[sk];
																 if(speciTdArray.indexOf(":")!=-1){
																	    var  tdRowFields=speciTdArray.split(":")[1];
																		var  tdRowCount=speciTdArray.split(":")[0];
                                                                            liePpFieldHtml+="<tr>";  
																			for(var st=0;st<tdRowFields.split(",").length;st++ ){
																				 for(var sa=0;sa<speciltotalArray.length;sa++){
																			             var  specilArray= speciltotalArray[sa];
																						if(specilArray.indexOf(tdRowFields.split(",")[st])!=-1){
																							 if(tdRowCount<maxFieldCount){
																								 liePpFieldHtml+="<td colspan=\""+maxFieldCount+"\">"+specilArray+"</td>";  
																							 }else{
																								  liePpFieldHtml+="<td  style=\"width:"+indexPrecent+"%\">"+specilArray+"</td>";   
																							 }	
																							 speciltotalArray[sa]="";
																						}
																				}
																			}
																			liePpFieldHtml+="</tr>";
															    }
													  }
													  var liebpFieldHtml ="<tr  colspan=\""+maxFieldCount+"\" style=\"display:none\"><td>";
                                                      for(var sarray=0;sarray<speciltotalArray.length;sarray++){
															var  specilArray= speciltotalArray[sarray];
															if(specilArray!=''){
                                                              liebpFieldHtml +=specilArray;
															}
													  }
													 liebpFieldHtml +="</td></tr>";
													  lieHtml="<table width=\"100%\" height=\"100%\" cellspacing=\"0\" cellpadding=\"0\"  border=\"0\">"+liePpFieldHtml+liebpFieldHtml+"</table>";

												}
										}
								   }
								 }
							   }catch(e){}
						   }

						    $(_this).hide();
							var trclassName=$(_this).attr("name");
							$(_this).attr("name",trclassName+"_card");
                               
						   	var detailCardShowDataHtml =" <tr _target=\"datarow\" name=\""+trclassName+"\"> "; 
							 if(type=='hj'){
								 $(_this).attr("_target","");
								 detailCardShowDataHtml =" <tr _target=\"tailrow\" name=\""+trclassName+"\"> ";
							 }
							
							 if(type!='hj'){
							    detailCardShowDataHtml +=" <td colspan=\""+tdViewDataObj.length+"\"  style=\"height:100%;\"> ";
							 }else{
								 var hjcount=tdViewDataObj.length+1;
								  detailCardShowDataHtml +=" <td colspan=\""+hjcount+"\"  style=\"height:100%;\"> ";
							 }
							 detailCardShowDataHtml +="   <table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"width:100%;height:100%;\" > ";
							 detailCardShowDataHtml +="     <tbody> ";
							  if(type !='hj'){
								  if(detailSpecialInfo=='1'&&specialHtml){
									  detailCardShowDataHtml +="<tr style=\"display:none;\">";
								  }else{
									   detailCardShowDataHtml +="<tr>";
								  }
								   
									 detailCardShowDataHtml +="       <td colspan=\"2\">";
									 detailCardShowDataHtml +="    <div class=\"cardopratordiv\"> ";
									 detailCardShowDataHtml +="   <div class=\"cardopratoredit\" > ";
									 if(detailSpecialInfo!='1'){
										 	detailCardShowDataHtml +=" <div class=\"trckclass\">"+ckHtml +"</div>";
                                             detailCardShowDataHtml +=" <div class=\"trxhclass\">序号:"+xhHtml+"</div>";
									 }
									 detailCardShowDataHtml +="</div> ";
									detailCardShowDataHtml +="    <div class=\"cardopratorxxnr\"  > ";
                                               if(isreadCount==0){
											  }else{
												   if($("button[name='delbutton"+groupindex+"']").length==0){
												       detailCardShowDataHtml +="    <span id=\"editCardShow"+groupindex+"_"+trIndex+"\"  editcardshowcount=\"0\"   onclick=\"cardeditshow('edit','"+groupindex+"','"+trIndex+"',"+isreadCount+")\">编辑</span> ";
												   }else{
													   detailCardShowDataHtml +="    <span id=\"editCardShow"+groupindex+"_"+trIndex+"\"  editcardshowcount=\"0\" class=\"editCardShowClass\"  onclick=\"cardeditshow('edit','"+groupindex+"','"+trIndex+"',"+isreadCount+")\">编辑</span> ";
												   }
											  }
											  //detailCardShowDataHtml +="  <span onclick=\"cardeditshow('info','"+groupindex+"','"+trIndex+"',"+isreadCount+")\">详细内容</span> ";
											  if(isreadCount>0){
												  if($("button[name='delbutton"+groupindex+"']").length>0){
												     detailCardShowDataHtml +="  <span onclick=\"carddeleshow('"+groupindex+"','"+trIndex+"')\">删除</span> ";
												  }
											  }
                                              detailCardShowDataHtml +=" </div> ";
											  detailCardShowDataHtml +=" </div> ";
											  detailCardShowDataHtml +=" </td> ";
											  detailCardShowDataHtml +=" </tr> ";
							  }
									  detailCardShowDataHtml +=" <tr> ";
                              if(type =='hj'){
									  detailCardShowDataHtml +=" <td style=\"width:10%;\" class=\""+trfirstClass+"\"> ";
											  detailCardShowDataHtml +="  <table border=\"0\" cellspacing=\"0\" cellpadding=\"0\" style=\"width:100%;height:100%;\" > ";
											  detailCardShowDataHtml +="    <tbody><tr> ";
											  detailCardShowDataHtml +="      <td style=\"height:22px;\"> ";
                                              detailCardShowDataHtml +=" "+ckHtml;
											  detailCardShowDataHtml +="      </td> ";
											  detailCardShowDataHtml +="  </tr> ";
											  detailCardShowDataHtml +=" <tr><td style=\"text-align:center;\"> ";
											 //   if(type !='hj'){
                                            //  detailCardShowDataHtml +=" <div class=\"cardxhdiv\">"+xhHtml+"</div>";
											 // }else{
											       detailCardShowDataHtml +=" <div >"+xhHtml+"</div>";
											
                                                 detailCardShowDataHtml +=" </td>";
											  detailCardShowDataHtml +="   </tr> ";
											  detailCardShowDataHtml +=" </tbody></table> ";
									  detailCardShowDataHtml +=" </td> ";
                                 }
if(trlastClass!=null&&trlastClass!=undefined){
 trlastClass =trlastClass.replace("detail_hide_col","");
}
									  detailCardShowDataHtml +="  <td class=\""+trlastClass+"\" > ";
 if(type !='hj'){
									 detailCardShowDataHtml +="   <table cellpadding=\"0\" cellspacing=\"0\" style=\"width:100%;border:0px;\" key=\"cardeditcontent"+groupindex+"_"+trIndex+"\" onclick=\"cardeditshow('edit','"+groupindex+"','"+trIndex+"',"+isreadCount+")\"> ";
 }else{
	                                 detailCardShowDataHtml +="   <table cellpadding=\"0\" cellspacing=\"0\" style=\"width:100%;border:0px;\" key=\"cardeditcontent"+groupindex+"_"+trIndex+"\" > ";
 }
											  detailCardShowDataHtml +="    <tbody> ";
											  if(detailSpecialInfo=='1'&&specialHtml){
												  detailCardShowDataHtml +="<tr><td>"+lieHtml+"</td></tr>";
											  }else{
											     detailCardShowDataHtml += lieHtml;
											  }
											  detailCardShowDataHtml +=" </tbody></table> ";
									  detailCardShowDataHtml +=" </td> </tr></tbody></table></td></tr> ";
			return detailCardShowDataHtml;
}


function isSpecialHandler(groupindex){
	  var result = false;
      if(detailSpecialRowConfig!=''){
		     if(detailSpecialRowConfig.indexOf("%")!=-1){
                  for(var dsrc=0;dsrc<detailSpecialRowConfig.split("%").length;dsrc++){
					    var  specialRowConfig =    detailSpecialRowConfig.split("%")[dsrc];
                       if(specialRowConfig.indexOf("$")!=-1){
					       if( groupindex == specialRowConfig.split("$")[0]){
							    result = true;
							   break;
						   }
					   }
				  }
			 }else{
				  if(detailSpecialRowConfig.indexOf("$")!=-1&&groupindex==detailSpecialRowConfig.split("$")[0]){
					   result = true;
				  }
				   
			 }
	  }
	  return result;
}

function isShowFieldInfo(groupindex){
	  var result = "";
      if(detailSpecialRowConfig!=''){
		     if(detailSpecialRowConfig.indexOf("%")!=-1){
                  for(var dsrc=0;dsrc<detailSpecialRowConfig.split("%").length;dsrc++){
					    var  specialRowConfigRoot =    detailSpecialRowConfig.split("%")[dsrc];
                       if(specialRowConfigRoot.indexOf("$")!=-1){
						   var specialRowConfig=specialRowConfigRoot.split("$")[1];
						   if(groupindex == specialRowConfigRoot.split("$")[0]){
							        if(specialRowConfig.indexOf("-")!=-1){
										var specialFieldConfig =  specialRowConfig.split("-")[1];
										if(specialFieldConfig.indexOf(":")!=-1){
											  var specialField=  specialFieldConfig.split(":")[1];
											  if(specialField.indexOf(",")!=-1){
												  result=specialField.split(",")[0];
											  }else{
												result = specialField;
											  }
											  break;
										}
								   }
						   }
					   }
				  }
			 }else{
				  if(detailSpecialRowConfig.indexOf("$")!=-1&&groupindex==detailSpecialRowConfig.split("$")[0]){
					    var specialRowConfig=detailSpecialRowConfig.split("$")[1];
                        if(groupindex == detailSpecialRowConfig.split("$")[0]){
						   if(specialRowConfig.indexOf("-")!=-1){
							    var specialFieldConfig =  specialRowConfig.split("-")[1];
								if(specialFieldConfig.indexOf(":")!=-1){
									  var specialField=  specialFieldConfig.split(":")[1];
									  if(specialField.indexOf(",")!=-1){
									      result=specialField.split(",")[0];
									  }else{
										result = specialField;
									  }
								}
						   }
						}
						 
				  }
				   
			 }
	  }
	  return result;
}

function jezhcardshow(obj){
	try{
        var objId=jQuery(obj).attr("id");
		var fieldIndex=objId.replace("field_lable","");
		var objVal=jQuery(obj).val();
		if(!!objVal){
				if(objVal.indexOf(',')!=-1){
					objVal = objVal.replace(/,/g,'');
				}
				var val_1 = floatFormat(objVal);            //补零
				var val_2 = milfloatFormat(val_1);          //转千分位
				var val_3 = numberChangeToChinese(val_1);   //转大写
				$(obj).val(val_1);
				$(obj).attr("value",val_1);
				$(obj).siblings("input[name='field_lable" + fieldIndex + "']").val(val_2);
				$(obj).siblings("input[name='field_lable" + fieldIndex + "']").attr("value",val_2);

				$(obj).siblings("input[name='field_chinglish" + fieldIndex + "']").val(val_3);
				$(obj).siblings("input[name='field_chinglish" + fieldIndex + "']").attr("value",val_3);

		}else{
			   $(obj).val("");
				$(obj).attr("value","");
				$(obj).siblings("input[name='field_lable" + fieldIndex + "']").val("");
				$(obj).siblings("input[name='field_lable" + fieldIndex + "']").attr("value","");

				$(obj).siblings("input[name='field_chinglish" + fieldIndex + "']").val("");
				$(obj).siblings("input[name='field_chinglish" + fieldIndex + "']").attr("value","");
		}
	}catch(e){}
}



//转换卡片式的形式
function formatCardShow(type,groupindex,trtableheadClass,_this,tableheadObj,tdindex,lastSerialNum){
     var trViewDataObj = $(_this).find("tr[name^='trView_"+groupindex+"_']");
	 if(type=='add'){
		  trViewDataObj = $(_this).find("tr[name='trView_"+groupindex+"_"+tdindex+"']");   
	 }
		   trViewDataObj.each(function(trindex){
							   var detailCardShowDataHtml= cardTableData(this,tdindex,groupindex,tableheadObj,'detail');
                               $(this).after(detailCardShowDataHtml);
			});



            //加载合计
		 if(type=='init'){
			var  tailrowDataObj = $(_this).find("tr[_target='tailrow']");
            tailrowDataObj.each(function(trindex){
			      var detailCardShowDataHtml= cardTableData(this,tdindex,groupindex,tableheadObj,'hj');
                   $(this).after(detailCardShowDataHtml);
			});
		 }
}


//初始化加载卡片展示
function  initCardShow(type,addgroupindex,addtrtableheadClass,_this,addtablehead,tdindex,lastSerialNum){
     if(type=='init'){
		    $("table[name^='oTable']").each(function(){
			   var nameAttr=$(this).attr("name");
			   if(nameAttr!=null&&nameAttr!=undefined){
					 var groupindex = nameAttr.replace("oTable","");
					var   checkalldetailTr= $(this).find("tr[class='exceldetailtitle ']");
					//解析全选与取消按钮
					//parseCheckAllCancalButton(this,groupindex,checkalldetailTr);
					 //解析表头信息
					 var tableheadObj = new Array();
					 var trtableheadClass="";
					if(checkalldetailTr.length>0){
							if(checkalldetailTr[1]!=null && checkalldetailTr[1]!=undefined && $(checkalldetailTr[1]).find("td").length>0){
								$(checkalldetailTr[1]).find("td").each(function(tdindex){
								   tableheadObj[tdindex] = {"html":""+$(this).html()+"","classStr":""+$(this).attr("class")+""};
									if(tdindex==0){
										 trtableheadClass = $(this).attr("class");
									}
								});
								$(checkalldetailTr[1]).hide();
							}
					}

					//将数据行转换成卡片状进行展示
					if($(this).find("tr[name^='trView_"+groupindex+"_']").length>0||$(this).find("tr[_target='tailrow']").length>0){
						 formatCardShow(type,groupindex,trtableheadClass,this,tableheadObj);
					}else{ //当没有明细数据的时候需要添加底部颜色
						if(trtableheadClass.indexOf(" ")!=-1){
							  trtableheadClass= trtableheadClass.split(" ")[0];
						}
						 var bbottomwidth=$("."+trtableheadClass).css("border-bottom-width");
						 var bbottomstyle=$("."+trtableheadClass).css("border-bottom-style");
						 var bbottomcolor=$("."+trtableheadClass).css("border-bottom-color");
						 $(this).css("border-bottom-width",bbottomwidth);
						  $(this).css("border-bottom-style",bbottomstyle);
						  $(this).css("border-bottom-color",bbottomcolor);
					}

			   }
        });
	 }else if(type=='add'){
		 if($(_this).find("tr[name='trView_"+addgroupindex+"_"+tdindex+"']").length>0){
	        formatCardShow(type,addgroupindex,addtrtableheadClass,_this,addtablehead,tdindex,lastSerialNum);
		 }
		 if($("#editCardShow"+addgroupindex+"_"+tdindex).length>0){
				$("#editCardShow"+addgroupindex+"_"+tdindex).click();  
		 }
	 }else if(type=='trigroupinfo'){
		 type="add";
		 if($(_this).find("tr[name='trView_"+addgroupindex+"_"+tdindex+"']").length>0){
	        formatCardShow(type,addgroupindex,addtrtableheadClass,_this,addtablehead,tdindex,lastSerialNum);
		 }
	 }
}

$(function(){
      initCardShow("init");
   try{
	  maindetailfieldchange=function(obj){
	        var datavaluetypeAttr= $(obj).attr("datavaluetype");
			if(datavaluetypeAttr!=null&&datavaluetypeAttr!=undefined){
				 if(datavaluetypeAttr == '2'){
					 var objVal=toPrecision($(obj).val(),0);
					   $(obj).val(objVal);
                        $(obj).attr("value",objVal);
				 }else if(datavaluetypeAttr == '3'||datavaluetypeAttr == '5'){
					   var datalength=2;
                        datalength=jQuery(obj).attr("datalength");
						var objVal = jQuery(obj).val();
                        if(datavaluetypeAttr=="3"){
							objVal=toPrecision(objVal,parseInt(datalength));
                            jQuery(obj).attr("value",objVal);
                        }else if(datavaluetypeAttr=="5"){
							objVal=objVal.replace(/,/g,"");
							objVal=toPrecision(objVal,parseInt(datalength));
                            jQuery(obj).val(changeToThousandsVal(objVal));
							jQuery(obj).attr("value",changeToThousandsVal(objVal));
                        }
				 }else if(datavaluetypeAttr == '4'){
					  jezhcardshow(obj);
				 }
			}
	  }
   }catch(e){}


	$(window).resize(function(){
		try{
		  var nowWindowHeight=$(window).height();
		  var showdivheight=$(".cardeditContentTable").height();
		  if(showdivheight>nowWindowHeight){
                 $(".cardeditContentTable").attr("style","height:"+nowWindowHeight+"px;overflow-y: auto;");
		  }else{
		      $(".cardeditContentTable").removeAttr("style");
		  }
		}catch(e){}
	});

});