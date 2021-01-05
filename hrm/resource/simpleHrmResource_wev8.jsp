<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.file.Prop" %>
<%@ page import="weaver.license.PluginUserCheck" %>
<%@ page import="weaver.hrm.resource.HrmListValidate"%>
<%@ page import="weaver.hrm.tools.HrmValidate" %>

<script type="text/javascript">
//用户语言
var languageid = '<%=user.getLanguage()%>'
</script>
<script type="text/javascript" src="/js/messagejs/highslide/highslide-full_wev8.js"></script>
<script type="text/javascript" src="/js/messagejs/simplehrm_wev8.js"></script>
<script type="text/javascript" src="/js/messagejs/messagejs_wev8.js"></script>
<script language="javascript" src="/qrcode/js/jquery.qrcode-0.7.0_wev8.js"></script>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<!--[if IE]> 
<script src="/qrcode/js/html5shiv_wev8.js"></script>
<script src="/qrcode/js/excanvas.compiled_wev8.js"></script>
<![endif]-->
<script type="text/javascript">
	function getImageResult(o)
	{
		hs.graphicsDir = '/js/messagejs/highslide/graphics/';
		hs.outlineType = 'rounded-white';
		hs.fadeInOut = true;
		hs.headingEval = 'this.a.title';
		var hrefimg = document.getElementById("resourceimghref").href;
		if(hrefimg.indexOf("javascript")!=-1)
		{
			void(0);
			return false;
		}
		else
		{
			return hs.expand(o);
		}
	}

function createQCode(){
	if(jQuery("#showSQRCodeDiv").is(":hidden"))
		jQuery("#showSQRCodeDiv").show();
	else
		jQuery("#showSQRCodeDiv").hide();
}

function initSrc(){
	if(jQuery("#result2").html()=="（男）"){
		jQuery("#resourceimg").attr("src","/images/messageimages/temp/man_wev8.png");	
		jQuery("#resourceimg").parent().attr("href","/images/messageimages/temp/man_wev8.png");
	}else if(jQuery("#result2").html()=="（女）"){
		jQuery("#resourceimg").attr("src","/images/messageimages/temp/women_wev8.png");	
		jQuery("#resourceimg").parent().attr("href","/images/messageimages/temp/women_wev8.png");
	}
}
</script>
<style type="text/css">
<!--
.STYLE4 {
	FONT-FAMILY: Verdana;
	font-size: 14px;
	cursor: hand;
}

.STYLE6 {
	FONT-FAMILY: Verdana;
	FONT-SIZE: 12px;
}

.STYLE61 {
	FONT-FAMILY: Verdana;
	FONT-SIZE: 12px;
	color: #000000;
}

.simplehrmhead {
	vertical-align:baseline;
}
#mainsupports {
	position: absolute;
	font-size: 12px;
	color: #929393;
	display: none;
	z-index: 1;
}

#closetext {
	float: right;
	margin-right: 20px;
}

#mainsupports li a:link {
	color: #2a788e;
	font-size: 12px;
	text-decoration: none;
}

#mainsupports li a:visited {
	color: #227086;
	font-size: 12px;
	text-decoration: none;
}

#mainsupports li a:hover {
	color: #FFFFFF;
	font-size: 12px;
	text-decoration: none;
}

#resourceimg {
	width: 198px;
	height: 293px;
	margin-top: 0px;
}
-->
</style>
<!-- 这里改了z-index(+2),因为UE编辑器会遮住弹窗 -->
<div id="mainsupports" style="z-index:1999;background-color:#e4e4e4;position: absolute;font-size: 12px;color: #929393;display: none;">
	<table width="455px" height="293px" border="0" align="center" style="vertical-align: middle;" cellpadding="0" cellspacing="0">
		<tr>
			<td width="198px" valign="top">
				<a id='resourceimghref' href="javascript:void(0);" onclick="return getImageResult(this);" onFocus="this.blur()"><img id='resourceimg' src="/images/messageimages/temp/loading_wev8.gif" border=0 width="100%" height="100%" onError="initSrc()"></a>
				<div style="position:absolute;top: 243px;background-image:url('/images/messageimages/temp/divbg_wev8.png');">
					<table style="width: 198px;height: 50px;text-align: center;vertical-align: middle;">
						<tr>
						<%HrmListValidate HrmListValidateObj = new HrmListValidate(); %>
							<%if(HrmValidate.hasEmessage(user)){ %>
							<td><img src="/images/messageimages/temp/emessage_wev8.png" onmouseover="javascript:this.src='/images/messageimages/temp/emessagehot_wev8.png';" onmouseout="javascript:this.src='/images/messageimages/temp/emessage_wev8.png';" onclick="javascript:sendSimpleEmessage();" title="<%=SystemEnv.getHtmlLabelName(127379,user.getLanguage())%>"></td>
							<%} %>
							<%if(HrmListValidateObj.isValidate(31)){ %>
							<td><img src="/images/messageimages/temp/msn_wev8.png" onmouseover="javascript:this.src='/images/messageimages/temp/msnhot_wev8.png';" onmouseout="javascript:this.src='/images/messageimages/temp/msn_wev8.png';" onclick="javascript:openmessage();" title="<%=SystemEnv.getHtmlLabelName(16635,user.getLanguage())%>"></td>
							<%}if(HrmListValidateObj.isValidate(19)){ %>
							<td><img src="/images/messageimages/temp/email_wev8.png" onmouseover="javascript:this.src='/images/messageimages/temp/emailhot_wev8.png';" onmouseout="javascript:this.src='/images/messageimages/temp/email_wev8.png';" onclick="javascript:openemail();" title="<%=SystemEnv.getHtmlLabelName(2051,user.getLanguage())%>"></td>
							<%}if(HrmListValidateObj.isValidate(32)){ %>
							<td><img src="/images/messageimages/temp/workplan_wev8.png" onmouseover="javascript:this.src='/images/messageimages/temp/workplanhot_wev8.png';" onmouseout="javascript:this.src='/images/messageimages/temp/workplan_wev8.png';" onclick="javascript:doAddWorkPlan();" title="<%=SystemEnv.getHtmlLabelName(18481,user.getLanguage())%>"></td>
							<%}%>
						</tr>
					</table>
				</div>
			</td>
			<td valign="top">
				<div style="position:absolute;top: -17px;left: 438px">
					<img id="closetext" style="cursor: hand;"src="/images/messageimages/temp/closeicno_wev8.png" onclick="javascript:closediv();"/>
				</div>
				<div id="showSQRCodeDiv" style="text-align: left;position:absolute;top: -20px;left: 350px; " onclick="createQCode()"></div>	
				<table width="257px" height="293px" border="0" style="padding-left: 16px;padding-top: 0px" bgcolor="#FFFFFF" cellpadding="0" cellspacing="0">
					<tr height="40px">
						<td>
							<div>
								<img id="isonline" src="/images/messageimages/temp/online_wev8.png" width="19" height="19" style="vertical-align:top;">&nbsp;<span class="STYLE4" id="result1"></span>&nbsp;<span class="STYLE6" id="result2"></span> &nbsp;<span class="STYLE6" id="result13"></span>&nbsp;&nbsp;&nbsp;&nbsp;
								<img src="/images/messageimages/temp/qcode_wev8.png" width="19" height="19" style="vertical-align:middle;cursor: hand;" onclick="createQCode()">
							</div>
						</td>
					</tr>
					<tr style="height:1px!important;" class="Spacing">
						<td><div class="intervalDivClass"></div></td>
					</tr>
					<tr style="height:4px!important;">
						<td></td>
					</tr>
					<tr>
						<td>
							<table height="203px">
								<tr>
									<td style="WORD-WRAP: break-word;TEXT-VALIGN: left;word-break:break-all;">
										<span class="STYLE6"><%=SystemEnv.getHtmlLabelName(18939,user.getLanguage())%>&nbsp;:&nbsp;&nbsp;&nbsp;</span>
										<span class="STYLE61" id="result6"></span>
									</td>
								</tr>
								<tr>
									<td style="WORD-WRAP: break-word;TEXT-VALIGN: left;word-break:break-all;">
										<span class="STYLE6"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>&nbsp;:&nbsp;&nbsp;&nbsp;</span>
										<span class="STYLE61" id="result9"></span>
									</td>
								</tr>
								<tr>
									<td style="WORD-WRAP: break-word;TEXT-VALIGN: left;word-break:break-all;">
										<span class="STYLE6"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%>&nbsp;:&nbsp;&nbsp;&nbsp;</span>
										<span class="STYLE61" id="result10"></span>
									</td>
								</tr>
								<tr>
									<td style="WORD-WRAP: break-word;TEXT-VALIGN: left;word-break:break-all;">
										<span class="STYLE6"><%=SystemEnv.getHtmlLabelName(596,user.getLanguage())%>&nbsp;:&nbsp;&nbsp;&nbsp;</span>
										<span class="STYLE61" id="result7"></span>
									</td>
								</tr>
								<tr>
									<td style="WORD-WRAP: break-word;TEXT-VALIGN: left;word-break:break-all;">
										<span class="STYLE6"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%>&nbsp;:&nbsp;&nbsp;&nbsp;</span>
										<span class="STYLE61" id="result11"></span>
									</td>
								</tr>
								<tr>
									<td style="WORD-WRAP: break-word;TEXT-VALIGN: left;word-break:break-all;">
										<span class="STYLE6"><%=SystemEnv.getHtmlLabelName(422,user.getLanguage())%>&nbsp;:&nbsp;&nbsp;&nbsp;</span>
										<span class="STYLE61" id="result3"></span>
									</td>
								</tr>
								<tr>
									<td style="WORD-WRAP: break-word;TEXT-VALIGN: left;word-break:break-all;">
										<span class="STYLE6"><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%>&nbsp;:&nbsp;&nbsp;&nbsp;</span>
										<span class="STYLE61" id="result4"></span>
									</td>
								</tr>
								<tr>
									<td style="WORD-WRAP: break-word;TEXT-VALIGN: left;word-break:break-all;">
										<span class="STYLE6"><%=SystemEnv.getHtmlLabelName(71,user.getLanguage())%>&nbsp;:&nbsp;&nbsp;&nbsp;</span>
										<span class="STYLE61" id="result5"></span>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr height="42px">
						<td align="right" valign="middle" style="padding-right: 12px">
							<span class="STYLE6" id="result0"></span>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
