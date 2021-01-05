

<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<META http-equiv="X-UA-Compatible" content="IE=8">
		</META>
		<style type="text/css">
* {
	font-family: '微软雅黑';
}

.relationblock {
	padding-left: 45px;
	position: relative;
}

.relationItem {
	padding-left: 10px;
}

.relationStyle {
	position: absolute;
	height: 100%;
	left: 35px;
}

.relationStyleTop {
	height: 6px;
	width: 10px;
	border-bottom: 2px solid #7E7E7E;
}

.relationStyleBottom {
	position: absolute;
	bottom: 0px;
	height: 6px;
	width: 10px;
	border-top: 2px solid #7E7E7E;
}

.relationStyleCenter {
	position: absolute;
	top: 6px;
	bottom: 6px;
	border-left: 2px solid #7E7E7E;
}

.verticalblock {
	position: absolute;
	top: 50%;
	margin-top: -7px;
	height: 15px;
	width: 2px;
	left: 0px;
	line-height: 15px;
	color: red;
}

.displayspan {
	border: 2px solid #fff;
}

.spanselected {
	border: 2px dashed #17d68c;
}
</style>
		<script type="text/javascript">
		
		function changeDivWidthparamdatafield() {

		    var outerWidth = jQuery('#outparamdatafielddiv').closest('td').width();
		    var innerWidth = parseInt(100) / 100 * outerWidth;
		    jQuery('#innerparamdatafielddiv').width(innerWidth);
		}
		window.changeFunctions.push(changeDivWidthparamdatafield);
		jQuery(document).ready(function() {
		    jQuery('#outparamdatafielddiv').parent('div').hover(function() {
		        jQuery('#paramdatafield__').show();
		        jQuery('#paramdatafield__').focus();
		    },
		    function() {
		        /*jQuery('#paramdatafield__').hide();*/
		    }).bind('click',
		    function() {
		        jQuery('#paramdatafield__').show();
		        jQuery('#paramdatafield__').focus();
		    });
		    jQuery('#paramdatafield__').autocomplete("/browserData.jsp", {
		        selectFirst: false,
		        autoFill: false,
		        dataType: 'json',
		        divID: 'innerparamdatafielddiv',
		        parse: function(data) {
		            return jQuery.map(data,
		            function(row) {
		                return {
		                    data: row,
		                    value: row.id,
		                    result: row.name
		                }
		            });
		        },
		        formatItem: function(row, i, max) {
		            return row.name;
		        },
		        formatResult: function(row) {
		            return [row.id, row.name];
		        }
		    });
		    jQuery('#paramdatafield__').result(function(event, data, formatted) {
		        var showName = '';
		        showName = "<a href='" + formatted + "' target='_blank'>" + data.name + "</a>";
		        var newSpan = "<span class='e8_showNameClass'>" + showName + "<span class='e8_delClass' id='" + formatted + "' onclick='del(this,1);'>&nbsp;x&nbsp;</span></span>"
		        var html = jQuery('#paramdatafieldspan').html();
		        if (html == null || html.toLowerCase().indexOf('<img') > -1) {
		            html = '';
		        }
		        jQuery('#paramdatafield').val(formatted);
		        jQuery('#paramdatafieldspan').html(newSpan) jQuery('#paramdatafield__').val('');
		    });
		});
	</script>
	</head>
	<body>


		<div class="e8_os">
			<div class="e8_outScroll" id="outparamdatafielddiv">
				<div class="e8_innerShow" id="innerparamdatafielddiv">
					<input type="hidden" value="" viewtype="0" onpropertychange=""
						temptitle="" name="paramdatafield" id="paramdatafield">
					<span name="paramdatafieldspan" id="paramdatafieldspan"></span>
					<input onblur="jQuery(this).hide();"
						class="e8_browserInput ac_input" type="text" value=""
						name="paramdatafield__" id="paramdatafield__"
						onkeydown="delByBS(event,'paramdatafield__',1);"
						autocomplete="off" style="display: none;">
				</div>
			</div>
			<div class="e8_innerShow">
				<span class="e8_spanFloat"><button
						class="Browser e8_browflow" type="button"
						onclick=";callback('paramdatafield','paramdatafield',1);"></button>
				</span>
			</div>
		</div>
		<div class="relationblock spanselected">
			<div class="verticalblock">
				OR
			</div>
			<div class="relationStyle">
				<div class="relationStyleTop"></div>
				<div class="relationStyleCenter"></div>
				<div class="relationStyleBottom"></div>
			</div>

			<div class="relationItem">
				上级 等于 杨国生
			</div>
			<div class="relationItem">
				上级安全级别 大于 50
			</div>
			<div class="relationItem">
				上级安全级别 大于 80
			</div>
			<div class="relationItem">
				上级安全级别 小于等于 100
			</div>

		</div>

	</body>
</html>