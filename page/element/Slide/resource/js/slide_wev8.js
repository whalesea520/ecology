$(function() {
		var iconImgList=['/page/element/Slide/images/1_1_wev8.png','/page/element/Slide/images/2_2_wev8.png','/page/element/Slide/images/3_3_wev8.png','/page/element/Slide/images/4_4_wev8.png'];
		var iconImg_overList=['/page/element/Slide/images/1_1_over_wev8.png','/page/element/Slide/images/2_2_over_wev8.png','/page/element/Slide/images/3_3_over_wev8.png','/page/element/Slide/images/4_4_over_wev8.png'];
		$('#slideArea .slideContinar').cycle({  //turnUp   //fade  //uncover
			fx:      'fade',  //blindX     * blindY    * blindZ    * cover    * curtainX    * curtainY    * fade    * fadeZoom    * growX    * growY    * none   * scrollUp    * scrollDown    * scrollLeft    * scrollRight    * scrollHorz    * scrollVert    * shuffle    * slideX    * lideY   * toss    * turnUp    * turnDown    * turnLeft    * turnRight    * uncover    * wipe    * zoom*/
			timeout:  3000,
			pager:   '#slideTitleNavContainer',
			pagerAnchorBuilder: pagerFactory,
			before:        function(currSlideElement, nextSlideElement, options, forwardFlag) {	
			
				var nextIndex=$(nextSlideElement).attr("index");
				var slidnavtitleArray=$("#slideArea .slidnavtitle");
				var newTop=0;
				var newLeft=0;
				if(slidnavtitleArray.length==0){
					
				} else {
					var nextSlidnavtitle=$($("#slideArea .slidnavtitle")[nextIndex]);
					newTop=nextSlidnavtitle.position().top;
					newLeft=nextSlidnavtitle.position().left;
				}
				$("#slideArea .slideTitleFloat").css({
					"display":"block",
					"background":"url('"+iconImg_overList[nextIndex]+"')"
				}).each(function(){$.dequeue(this, "fx");}).animate({top :newTop,left: newLeft},400,'backout');

			}			
		}); 

	
		function pagerFactory(idx, slide) {
			var s = idx > 3 ? ' style="display:none"' : '';			 
			return '<div '+s+' class="slidnavtitle"  style="background:url('+iconImgList[idx]+') no-repeat;">&nbsp;</div>';
		};

	});