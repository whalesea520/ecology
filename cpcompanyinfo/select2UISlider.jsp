<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<script type="text/javascript" src="js/jquery-ui-1.7.1.custom.min_wev8.js"></script>
<script type="text/javascript" src="js/selectToUISlider.jQuery_wev8.js"></script>
<link rel="Stylesheet" href="style/ui.slider.extras_wev8.css" type="text/css" />
<link rel="stylesheet" href="style/jquery-ui-1.7.1.custom_wev8.css" type="text/css" />
<style type="text/css">
	fieldset { border:0;margin-left:3em;margin-right:3em;}
	.ui-slider {clear: both; top: 4em;}
</style>
	<script type="text/javascript">
	/* 	$(document).ready(function(){
			var abc = $('select#speed').selectToUISlider().next();
		
			//fix color 
			fixToolTipColor();
		});
		//purely for theme-switching demo... ignore this unless you're using a theme switcher
		//quick function for tooltip color match
		function fixToolTipColor(){
			//grab the bg color from the tooltip content - set top border of pointer to same
			$('.ui-tooltip-pointer-down-inner').each(function(){
				var bWidth = $('.ui-tooltip-pointer-down-inner').css('borderTopWidth');
				var bColor = $(this).parents('.ui-slider-tooltip').css('backgroundColor')
				$(this).css('border-top', bWidth+' solid '+bColor);
			});	
		} */
	</script>
	
	<fieldset>
		<!--  
		<label for="speed">放大倍数:</label>
		-->
		<select name="speed" id="speed" style="display:none">
			<option value="2" selected="selected">2</option>
		</select>
	</fieldset>