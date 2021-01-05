<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="init.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=10" /> 
<title></title>

<script type="text/javascript">

			
	//显示热点列表部分
	function showRD(){
				$("#syshotkeydiv").load("HotKeys.jsp?hotkeystype=sys");
				$("#perhotkeydiv").load("HotKeys.jsp?hotkeystype=per");
				jQuery("#rd_div").show().animate({ width:291},300,null,function(){jQuery(this).css("display","");});
			}
			
	//关闭热点列表部分
	function hideRD(){
		if(jQuery("#rd_div").width()>0 && jQuery("#rd_div").css("display")!= "none"){
					jQuery("#rd_div").animate({ width:0},300,null,function(){
						jQuery(this).css("display","none");
					});
				}
				jQuery(this).css("display","none");
			}
			
	function hotkeyclick(obj){
	    jQuery("#key").val(obj.title);
	    dosubmit();
	}
</script>
<style>
	<!--
	#hotkeysCloud{width:552px;height:0px;position:relative;margin:0px auto 0;top: 240px; left: 0px;}
	#divCloud{background:#fff;top:0px;left:0px;width:542px;position:absolute;margin:0px auto 0;text-align:center;filter:"alpha(opacity=50)";opacity:.50;-ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=50)";}
	#divCloud a:hover{color:#ff0000;padding:5px;display:block;border:2px solid #ff0000;}
	#divCloud a{position:absolute;top:0px;left:0px;text-decoration:none;font-size:16px;color:#000;font-family:Arial;}
	#divCloud a.tagc1{margin:0 10px 15px 0;line-height:20px;text-align:center;padding:1px 5px;white-space:nowrap;display:inline-block;border-radius:3px;}
	#divCloud a.tagc2{margin:0 10px 15px 0;line-height:20px;text-align:center;padding:1px 5px;white-space:nowrap;display:inline-block;border-radius:3px;}
	#divCloud a.tagc5{margin:0 10px 15px 0;line-height:20px;text-align:center;padding:1px 5px;white-space:nowrap;display:inline-block;border-radius:3px;}
	-->
</style>

<!-- 热点展示 -->
       
			<table style="width: 100%;" cellspacing="0" cellpadding="0" border="0">
				<colgroup><col width="5px"/><col width="*"/><col width="5px"/></colgroup>
				<tbody><tr style="height: 5px;">
					<td style="height: 5px;font-size: 0px;background: url('../images/bg/t_left_box_wev8.png')"></td>
					<td style="height: 5px;font-size: 0px;background: url('../images/bg/t_center_box_wev8.png') repeat-x;"></td>
					<td style="height: 5px;font-size: 0px;background: url('../images/bg/t_right_box_wev8.png')"></td>
				</tr>
				<tr>
					<td style="font-size: 0px;background: url('../images/bg/c_left_box_wev8.png') repeat-y;"></td>
					<td style="background: #fff;">
						<table id="app_table" style="width: auto;height: auto" cellpadding="0" cellspacing="0" border="0">
							<tbody><tr>
			<td valign="top" style="border-left: 1px #E4E4E4 solid;">
			<div id="syshotkeydiv" class="apppanel">
				<!-- <div class="apptitle"><div class="apptitle_txt">系统热点</div></div>
				
				<div id="appdetail_27555" class="appdetail" title="行业动态">
					<div class="appdetail_txt">行业动态</div>
				</div>	 -->
			</div>
			</td>
			
			<td valign="top" style="border-left: 1px #E4E4E4 solid;">
			<div id="perhotkeydiv" class="apppanel">
				<!-- <div class="apptitle"><div class="apptitle_txt">个人热点</div></div>
				
				<div id="appdetail_27572" class="appdetail" title="合同金额前十">
					<div class="appdetail_txt">合同金额前十</div>
				</div>	 -->
			</div>
			</td>
			
			</tr>
			</tbody></table>
					</td>
					<td style="font-size: 0px;background: url('../images/bg/c_right_box_wev8.png') repeat-y;"></td>
				</tr>
				<tr style="height: 5px;">
					<td style="height: 5px;font-size: 0px;background: url('../images/bg/f_left_box_wev8.png')"></td>
					<td style="height: 5px;font-size: 0px;background: url('../images/bg/f_center_box_wev8.png') repeat-x;"></td>
					<td style="height: 5px;font-size: 0px;background: url('../images/bg/f_right_box_wev8.png')"></td>
				</tr>
			</tbody></table>
			<div class="btn_close" style="position: absolute;top: 3px;right: 3px;" title="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" onclick="hideRD()"></div>
</body>
</html>
