var util={
		 getData:function(para,passobj){
		    //if(para.loadingTarget!=null) jQuery(para.loadingTarget).showLoading();
			jQuery.ajax({
				type: "post",
				cache: false,
			    url: "/mobile/plugin/1/workflowSign.jsp?_" + new Date().getTime() + "=1&" + para.paras,
			    data:para.paras,
			    dataType: "json",  
			    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
			    complete: function(){
					//if(para.loadingTarget!=null)  jQuery(para.loadingTarget).hideLoading();
				},
			    error:function (XMLHttpRequest, textStatus, errorThrown) {
			    } , 
			    success:function (data, textStatus) {
			    	if (data == undefined || data == null) {
			    		return;
			    	} else { 
			    		para.callback.call(this,data,passobj);
			    	}
			    } 
		    });
		},
		
		/*
		 * 当且仅当data为非空的字符串时返回false，其他情况返回true
		 * @param data： 目标字符串
		 * @return 当且仅当data为非空的字符串时返回false，其他情况返回true
		 * */
		isNullOrEmpty: function (data) {
			if (data == undefined || data == null || data == "") {
				return true;
			}
			return false;
		},
		
		/*
		 * 指定格式的当前日期字符串
		 * @param format 格式化字符串
		 * @return 指定格式的当前日期字符串
		 */
		getCurrentDate4Format : function (formatstring) {
			var testDate = new Date(); 
			var testStr = testDate.format(formatstring);
			return testStr;
		}
	}


function getDataList(paras, isfirst) {
	//显示正在加载的旋转图片。
	//if(paras.loadingTarget!=null) jQuery(paras.loadingTarget).showLoading();
    util.getData({
        "loadingTarget": document.body,
        "paras": paras,
        "callback": function(data) {
            if (data.error) {
                //第一次加载删除加载图标
                if (isfirst != undefined && isfirst != null && isfirst == true) {
                	$("#workflowrequestsignblock").hide();
                	
                	//第一次加载，如果没有数据，则隐藏  流转意见 标签
                	jQuery("#page_remarksign_Title_div").css("display","none");
                	jQuery("#workflowrequestsignblock").css("display","none");
                } else {
                	$("#workflowsignmore").remove();
                }
            } else {
                var pageindex = data.pageindex;
                var pagesize = data.pagesize;
                var count = data.count;
                var ishavepre = data.ishavepre;
                var ishavenext = data.ishavenext
                var pagecount = data.pagecount;
                $("input[name='workflowsignid']").val(pageindex);
                var viewsignHtml = "";
                var currentPageDataCnt = new Date().getTime();
                
                if (data.logs != undefined && data.logs != null && count != "0") {
                    $.each(data.logs, 
                    function(i, item) {
                        currentPageDataCnt++;
                        var annexDocHtmls = item.annexDocHtmls;
                        var id = item.id;
                        var nodeId = item.nodeId;
                        var nodeName = item.nodeName;
                        var operateDate = item.operateDate;
                        var operateTime = item.operateTime;
                        var operateType = item.operateType;
                        var operatorDept = item.operatorDept;
                        var operatorId = item.operatorId;
                        var operatorName = item.operatorName;
                        var operatorSign = item.operatorSign;
                        var receivedPersons = item.receivedPersons;
                        var remark = item.remark;
                        var remarkSign = item.remarkSign;
                        var signDocHtmls = item.signDocHtmls;
                        var signWorkFlowHtmls = item.signWorkFlowHtmls;
                        var nodeRowName = '节点';
                        var operationRowName = '操作';
                        var receivedRowName = '接收人';
                        var accessoryRowName = '相关附件';
                        var signDocHtmlsRowName = '相关文档';
                        var signWorkFlowHtmlsRowName = '相关流程';
						
						if (!isfirst || ( isfirst && i != 0)) {
					        viewsignHtml += "<div style=\"width:100%;height:1px;border-top:1px solid #CFD3D8;overflow:hidden;margin-top:5px;\" name=\"moresigninfodiv\"></div>";
						}
                        viewsignHtml += "<div style=\"width:100%;\">" + "	<div class=\"signRow\" style=\"font-size:14px;font-weight:bold;color:#000;\">";
                        if (remarkSign != null && remarkSign != undefined) {
                            viewsignHtml += "<div style=\"width:100%;\">" + "    <img src=\"/download.do?url=" + remarkSign + "\">" + "</div>";
                        } else {
							if(operateType != "抄送"){
                            viewsignHtml += remark;	  
							}
                        }
                        viewsignHtml += "</div><br>";
                        if (operatorSign != null && operatorSign != undefined && operatorId != null && operatorId != undefined) {
                            viewsignHtml += "<div style=\"width:100%;\"><img src=\"/weaver/weaver.file.ImgFileDownload?userid=" + operatorId + "\"/>" + "</div>"+"<div class=\"signRow\">"+ operateDate + "&nbsp;" + operateTime +"</div>";
                        } else {
                            viewsignHtml += "<div class=\"signRow\">" + operatorDept + "&nbsp;/&nbsp;" + operatorName + "&nbsp;" + operateDate + "&nbsp;" + operateTime + "" + "</div>";
                        }
                        viewsignHtml += "<div class=\"signRow\">" + nodeRowName + ":" + nodeName + "&nbsp;&nbsp;&nbsp;&nbsp;" + operationRowName + ":" + operateType + "</div>" + "<div class=\"signRow\">" + receivedRowName + ":<span onclick=\"showwfsigndetail(this, 'wfsignreceivedp" + currentPageDataCnt + "');\" style=\"font-size:12px;\">" + ((util.isNullOrEmpty(receivedPersons) == false && receivedPersons.length > 15) ? (receivedPersons.substring(0, 15) + "...&nbsp;&nbsp;<span style=\"color: blue;\">显示</span>") : receivedPersons) + "</span><span id=\"wfsignreceivedp" + currentPageDataCnt + "\" style=\"display:none;\">" + receivedPersons + "</span>" + "</div>";
                        if (!util.isNullOrEmpty(signDocHtmls) || !util.isNullOrEmpty(signWorkFlowHtmls) || !util.isNullOrEmpty(annexDocHtmls)) {
                            viewsignHtml += "<br /><div style=\"border-top:1px dashed #AAAAAA;height:1px; overflow:hidden;margin-left:12px;margin-right:12px;\"></div>";
                        }
                        if (!util.isNullOrEmpty(signDocHtmls)) {
                            viewsignHtml += "<div class=\"signRow\">" + signDocHtmlsRowName + ":" + signDocHtmls + "</div>";
                        }
                        if (!util.isNullOrEmpty(signWorkFlowHtmls)) {
                            viewsignHtml += "<div class=\"signRow\">" + signWorkFlowHtmlsRowName + ":" + signWorkFlowHtmls + "</div>";
                        }
                        if (!util.isNullOrEmpty(annexDocHtmls)) {
                            viewsignHtml += "<div class=\"signRow\">" + accessoryRowName + ":" + annexDocHtmls + "</div>";
                        }
                        viewsignHtml += "</div>";
                    });
                }
                //第一次加载删除加载图标
                if (isfirst != undefined && isfirst != null && isfirst == true) {
                	$("#workflowrequestsignblock").html("");
                	
                	//第一次加载，如果没有数据，则隐藏  流转意见 标签
                	if(data.logs == undefined || data.logs == null || count == "0"){
                		jQuery("#page_remarksign_Title_div").css("display","none");
                		jQuery("#workflowrequestsignblock").css("display","none");
                	}
                }
                
                $("#cleaboth").remove();
                $("#workflowsignmore").remove();
                if (ishavenext == "1") {
                    var moreRowName = '展开全部';
                    viewsignHtml += "<div id=\"workflowsignmore\" class=\"operationBt\" style=\"font-size:12px;height:20px;line-height:20px;float:right;margin-right:10px;margin-top:10px;\" onclick=\"javascript:doexpand();\"><span id=\"moresigninfotext\">更多</span></div>" + "<div id=\"cleaboth\" style=\"clear:both;\"></div>"
                }
                $("#workflowrequestsignblock").append(viewsignHtml);
                
    			//在新加载的页面上，可能包含语音附件的播放按钮，则需要对其进行隐藏。
                hiddenSpeechBtn();
            }
        }
    })
}



function getMainForm(paras) {
	jQuery.ajax({
		type: "post",
		cache: false,
	    url: "/mobile/plugin/1/view_MainForm.jsp?_" + new Date().getTime() + "=1&" + paras,
	    dataType: "html",  
	    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
	    complete: function(){
		},
	    error:function (XMLHttpRequest, textStatus, errorThrown) {
	    } , 
	    success:function (data, textStatus) {
	    	$("#mainforminfoDiv").html(data);
	    	initFormPage();
			setRedflag();
	    } 
    });
}

function getDetailForm(paras) {
    jQuery.ajax({
		type: "post",
		cache: false,
	    url: "/mobile/plugin/1/view_DetailForm.jsp?_" + new Date().getTime() + "=1&" + paras,
	    dataType: "html",  
	    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
	    complete: function(){
		},
	    error:function (XMLHttpRequest, textStatus, errorThrown) {
	    } , 
	    success:function (data, textStatus) {
	    	if ($.trim(data) == "") {
	    		$("#detailforminfoDivHead").remove();
	    		$("#detailforminfoDiv").remove();
	    	}
	    	$("#detailforminfoDiv").html(data);
	    } 
    });
}


	/**
	 * 为日期增加格式化方法
	 * @param format 格式化字符串
	 * @return 指定格式的字符串
	 */
	Date.prototype.format = function(format){ 
		var o = { 
			"M+" : this.getMonth()+1, //month 
			"d+" : this.getDate(),    //day 
			"h+" : this.getHours(),   //hour 
			"m+" : this.getMinutes(), //minute 
			"s+" : this.getSeconds(), //second 
			"q+" : Math.floor((this.getMonth()+3)/3), //quarter 
			"S" : this.getMilliseconds() //millisecond 
		} 

		if(/(y+)/.test(format)) { 
			format = format.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length)); 
		} 

		for(var k in o) { 
			if(new RegExp("("+ k +")").test(format)) { 
				format = format.replace(RegExp.$1, RegExp.$1.length==1 ? o[k] : ("00"+ o[k]).substr((""+ o[k]).length)); 
			} 
		} 
		return format; 
	}
