jQuery(document).ready(function(){
	if(window.location.href.indexOf("AddRequest")!=-1 ||window.location.href.indexOf("ManageRequest")!=-1||window.location.href.indexOf("ViewRequest")!=-1){
	
	}else{
		initLayout();
	}
});

var __defaultTemplNamespace__ = (function(){
	return (function(){
		return {
			initLayoutForCss:function(){
				var tr = jQuery("table.e8Table tr[class!=intervalTR]");
				tr.each(function(){
					var $this = jQuery(this);
					if(!$this.hasClass("intervalTR")){
						$this.hover(function(){
							jQuery(this).addClass("Selected");
						},function(){
							jQuery(this).removeClass("Selected");
						});
						$this.children("td").hover(function(){
							jQuery(this).addClass("e8Selected");
						},function(){
							jQuery(this).removeClass("e8Selected");	
						});
					}
				});
			},
			initLayout:function(){
				var tr = jQuery("table.LayoutTable tr[class!=intervalTR]");
				tr.each(function(){
					if(!jQuery(this).hasClass("intervalTR")){
						jQuery(this).hover(function(){
							jQuery(this).addClass("Selected");
						},function(){
							jQuery(this).removeClass("Selected");	
						});
						jQuery(this).children("td").hover(function(){
							jQuery(this).addClass("e8Selected");
						},function(){
							jQuery(this).removeClass("e8Selected");	
						});
					}
				});
				
				initLayoutForCss();
				
			
				/*jQuery("tr.groupHeadHide").each(function(){
					var hideBlockDiv = jQuery(this).find(".hideBlockDiv");
					if(hideBlockDiv.length>0 && hideBlockDiv.css("display")!="none"){
						jQuery(this).unbind("click").bind("click",function(e){
							var evt = e||window.event;
							var srcElement = evt.srcElement||evt.target;
							if(jQuery(this).attr("_show")||jQuery(srcElement).attr("_show")){
								hideBlockDiv.attr("_status","1");
							}
							try{
								var noHideEle = jQuery(srcElement).closest(".noHide");
								if(!jQuery(this).attr("_show") && (srcElement.tagName.toLowerCase()=="input"||srcElement.tagName.toLowerCase()=="a") || jQuery(srcElement).hasClass("noHide")||noHideEle.length>0){
									showItemArea(srcElement);
									if(jQuery(srcElement).attr("type")!="checkbox"){
										evt.stopPropagation();
										evt.preventDefault();
									}
								}else{
									hideBlockDiv.click();
								}
								jQuery(this).removeAttr("_show");
								if(typeof(setContentHeight)=="function"&&isneedSetContentHieght){
									setContentHeight();
								}
							}catch(e){
								jQuery(this).removeAttr("_show");
								if(window.console)console.log(e+"-->templates/default.js-->initLayout()");
							}
						});
					}
				});*/
				
			
				jQuery(".hideBlockDiv").unbind("click").bind("click", function (e) {
					var _status = jQuery(this).attr("_status");
					var currentTREle = jQuery(this).closest("table").closest("TR");
					var groupHideTR = currentTREle.find("tr.groupHeadHide:first");
					if(groupHideTR.attr("_show")==="true"){
						_status = "1";
						groupHideTR.removeAttr("_show");
					}
					if (!!!_status || _status == "0") {
						jQuery(this).attr("_status", "1");
						jQuery(this).html("<img src='/wui/theme/ecology8/templates/default/images/1_wev8.png'>");
						currentTREle.next("TR.Spacing").next("TR.items").hide();
					} else {
						jQuery(this).attr("_status", "0");
						jQuery(this).html("<img src='/wui/theme/ecology8/templates/default/images/2_wev8.png'>");
						currentTREle.next("TR.Spacing").next("TR.items").show();
					}
					var evt = e||window.event;
					evt.stopPropagation();
					evt.preventDefault();
				}).hover(function(){
					$(this).css("color","#000000");
				},function(){
					$(this).css("color","#cccccc");
				});
				
				_initFormat();
			},
			showItemArea:function(selector,_document){
				if(!_document)_document = document;
				if(!selector)return;
				var tr = jQuery(selector,_document).closest("tr.groupHeadHide");
				var hideBlockDiv = tr.find(".hideBlockDiv");
				if(tr.length>0 && hideBlockDiv.length>0){
					tr.attr("_show","true");
					hideBlockDiv.click();
				}
			},
			isSamePairHidden:function(samePair){
				var samePairTds = jQuery("td[_samePair*='"+objid+"']");
				samePairTds.each(function(){
					if(jQuery(this).css("display")=="none")return true;
				});
				return false;
			},
			showGroup:function(samePair){
				sohGroup(samePair,true);
			},
			hideGroup:function(samePair){
				sohGroup(samePair,false);
			},
			sohGroup:function(samePair,soh){
				var trs = jQuery("tr[_samePair*='"+samePair+"']");
				trs.each(function(){
					var tr = jQuery(this);
					var span = tr.find("span.hideBlockDiv");
					if(soh){
						tr.show();
						tr.next("tr.Spacing").show();
						span.attr("_status","0");
						span.html("<img src='/wui/theme/ecology8/templates/default/images/2_wev8.png'>");
						//if(span.attr("_status")=="1" && span.css("display")!="none")return;
						tr.next("tr.Spacing").next("TR.items").show();
						tr.next("tr.Spacing").next("TR.items").next("tr.Spacing").show();
					}else{
						tr.hide();
						tr.next("tr.Spacing").hide();
						//if(span.attr("_status")=="1" && span.css("display")!="none")return;
						span.attr("_status","1");
						span.html("<img src='/wui/theme/ecology8/templates/default/images/1_wev8.png'>");
						tr.next("tr.Spacing").next("TR.items").hide();
						tr.next("tr.Spacing").next("TR.items").next("tr.Spacing").hide();
					}
					
				});
			},
			_initFormat:function(){
				var tds = jQuery("td[_samePair][_samePair!='']");
				var visited = [];
				tds.each(function(){
					var _samePair = jQuery(this).attr("_samePair");
					if(!visited.contains(_samePair)){
						visited.push(_samePair);
						_colspan(_samePair);
					}
				});
			},
			_colspan:function(objid){
				var samePairTds = jQuery("td[_samePair*='"+objid+"']:hidden");
				var lastTR = null;
				samePairTds.each(function(){
					if(jQuery(this).css("display")!="none"){
					}else{
						var tr = jQuery("td[_samePair*='"+objid+"']").closest("tr");
						if(lastTR && tr.attr("_trrandom")==lastTR.attr("_trrandom")){
						}else{
							var tds = tr.children("td");
							var isHide = true;
							tds.each(function(){
								if(jQuery(this).css("display")!="none"){
									isHide = false;
								}
							});
							var _samePairTds = tr.find("td[_samePair*='"+objid+"']:hidden");
							var lastTd = tds.eq(tds.length-1);
							var colspan=lastTd.attr("colspan");
							if(isHide){
								tr.css("display","none");
								tr.next("tr.Spacing").css("display","none");
							}
							if(!colspan)colspan=1;
							if(!!colspan){
								lastTd.attr("colspan",colspan+_samePairTds.length);
							}
						}
						lastTR=tr;
					}
				});
			},
			showEle:function(objid){
				hosEle(objid,"",true);
			},
			hideEle:function(objid,needHideTr){
				if(needHideTr!=false){
					needHideTr=true;
				}
				hosEle(objid,"none",needHideTr);
			},
			hosEle:function(objid,soh,needHideTr){
				var samePairTds = jQuery("td[_samePair*='"+objid+"']");
				if(soh=="none"){
					if(samePairTds.slice(0,1).css("display")=="none")return;
					jQuery("td[_samePair*='"+objid+"']").css("display",soh);
				}else{
					if(jQuery("td[_samePair*='"+objid+"']").css("display")!="none")return;
				}
				var lastTR = null;
				samePairTds.each(function(){
					var tr = jQuery(this).closest("tr");
					if(lastTR && tr.attr("_trrandom")==lastTR.attr("_trrandom")){
					}else{
						var showTd = 0;
						var hideTd = 0;
						var lastTd;
						tr.children("td").each(function(){
							if(jQuery(this).css("display")!="none"){
								showTd++;
								lastTd = jQuery(this);
							} else {
								hideTd++;
							}
						});
						if((showTd==0 || soh!="none")&&!!needHideTr){
							tr.css("display",soh);
							if(tr.hasClass("intervalTR")){
							}else{
								tr.next("tr.Spacing").css("display",soh);
							}
						}
						if(tr.css("display")=="none"){
						}else{
							if(!!lastTd ){
								var colspan=lastTd.attr("colspan");
								if(!colspan)colspan=1;
								if(!!colspan){
									if(soh=="none"){
										lastTd.attr("colspan",colspan+hideTd);
									}else{
										lastTd.attr("colspan",colspan-hideTd);
									}
								}
							}
							
							tr.find("td[_samePair*='"+objid+"']").css("display",soh);
						}
					}
					lastTR=tr;
				});
			}
		}
	})();
})();

//@deprecated
function initLayoutForCss(){
	__defaultTemplNamespace__.initLayoutForCss();
}

//@deprecated
function initLayout(){
	__defaultTemplNamespace__.initLayout();
}

//@deprecated
function showItemArea(selector,_document){
	__defaultTemplNamespace__.showItemArea(selector,_document);
}

//@deprecated
function isSamePairHidden(samePair){
	return __defaultTemplNamespace__.isSamePairHidden(samePair);
}

//@deprecated
function showGroup(samePair){
	__defaultTemplNamespace__.showGroup(samePair);
}

//@deprecated
function hideGroup(samePair){
	__defaultTemplNamespace__.hideGroup(samePair);
}

//@deprecated
function sohGroup(samePair,soh){
	__defaultTemplNamespace__.sohGroup(samePair,soh);
}

Array.prototype.contains = function (element) {  
	for (var i = 0; i < this.length; i++) { 
		if (this[i] == element) {  
			return true; 
		}
	}
	return false; 
} 

//@deprecated
function _initFormat(){
	__defaultTemplNamespace__._initFormat();
}

//@deprecated
function _colspan(objid){
	__defaultTemplNamespace__._colspan(objid);
}

//@deprecated
function showEle(objid){
	__defaultTemplNamespace__.showEle(objid);
}

//@deprecated
function hideEle(objid,needHideTr){
	__defaultTemplNamespace__.hideEle(objid,needHideTr);
}

//@deprecated
function hosEle(objid,soh,needHideTr){
	__defaultTemplNamespace__.hosEle(objid,soh,needHideTr);
}

