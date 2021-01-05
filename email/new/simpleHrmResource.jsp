<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.file.Prop" %>
<%@ page import="weaver.license.PluginUserCheck" %>



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
	
</script>
<style type="text/css">
<!--
.STYLE4 {
	font-size: 12;
	color: #2B6DAA;
}

.STYLE6 {
	FONT-FAMILY: Verdana;
	FONT-SIZE: 9pt;
}
.simplehrmhead {
	vertical-align:baseline;
}
#mainsupports {
	position: absolute;
	font-size: 12px;
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
	width: 100px;
	height: 115px;
	margin-top: 0px;
}
-->
</style>
<div id="mainsupports" style="display;none;z-index:999;">
		<table width="373" height="216" border="0" align="center"
			cellpadding="0" cellspacing="0">
			<tr>
				<td rowspan="13" bgcolor="#AAAAAA">
					<table width="100%" height="100%" border="0" cellpadding="0"
						cellspacing="1">
						<tr>
							<td bgcolor="#FFFFFF">
								<table width="100%" height="210" border="0" cellpadding="0"
									cellspacing="0" style="padding-bottom:6px;">
									<tr>
										<td width="40%" align="center" valign="middle">
											<table width="114" height="179" border="0" align="center"
												cellpadding="0" cellspacing="0">
												<tr>
													<td height="130" align="center" valign="middle"
														bgcolor="#C4C4C4">
														<table width="100%" height="130" border="0" align="center"
															cellpadding="0" cellspacing="1">
															<tr>
																<td height="100%" align="center" valign="middle"
																	bgcolor="#FFFFFF">
																		<a id='resourceimghref' href="javascript:void(0);"
																			onclick="return getImageResult(this);" onFocus="this.blur()"> <img
																				id='resourceimg' src="/images/messageimages/temp/man_wev8.gif" border=0 width="100px"
																				height="115">
																		</a>
																</td>
															</tr>
														</table>
													</td>
												</tr>
												<tr>
													<td height="18" style="padding-left:5px;">
														<table width="100%" border="0" cellspacing="0"
															cellpadding="0" style="margin-top:6px;margin-bottom:2px;">
															<tr>
																<td width="25%" class="STYLE4">
																	<div align="right">
																		<img src="/images/messageimages/temp/email_wev8.gif"
																			width="16" height="12" align="absmiddle" title="<%=SystemEnv.getHtmlLabelName(2051,user.getLanguage())%>">
																	</div>
																</td>
																<td width="81%" class="STYLE4" style="padding-left:10px;">
																	<div align="left">
																		<a href="javascript:openemail();"><%=SystemEnv.getHtmlLabelName(2051,user.getLanguage())%></a>
																	</div>
																</td>
															</tr>
														</table>
													</td>
												</tr>
												<tr>
													<td height="18" style="padding-left:5px;">
														<table width="100%" border="0" cellspacing="0"
															cellpadding="0">
															<tr>
																<td width="25%" class="STYLE4">
																	<div align="right">
																		<img src="/images/messageimages/temp/msn_wev8.gif"
																			width="16" height="16" align="absmiddle" title="<%=SystemEnv.getHtmlLabelName(16635,user.getLanguage())%>">
																	</div>
																</td>
																<td width="81%" class="STYLE4" style="padding-left:10px;">
																	<div align="left">
																		<a href="javascript:openmessage();"><%=SystemEnv.getHtmlLabelName(16635,user.getLanguage())%></a>
																	</div>
																</td>
															</tr>
														</table>
													</td>
												</tr>
												
												<tr>
													<td height="18" style="padding-left:5px;">
														<table width="100%" border="0" cellspacing="0"
															cellpadding="0">
															<tr>
																<td width="25%" class="STYLE4">
																	<div align="right">
																		<img src="/images/messageimages/temp/hrmresource_wev8.gif"
																			width="16" height="16" align="absmiddle" title="<%=SystemEnv.getHtmlLabelName(411,user.getLanguage())%>">
																	</div>
																</td>
																<td width="81%" class="STYLE4" style="padding-left:10px;">
																	<div align="left">
																		<a href="javascript:openhrmresource();"><%=SystemEnv.getHtmlLabelName(411,user.getLanguage())%></a>
																	</div>
																</td>
															</tr>
														</table>
													</td>
												</tr>
												<%
												PluginUserCheck pcheck=new PluginUserCheck();
												boolean isHaveMessager1=Prop.getPropValue("Messager","IsUseWeaverMessager").equalsIgnoreCase("1");
												int isHaveMessagerRight1 = pcheck.checkPluginUserRight("messager",user.getUID()+"");
												if(isHaveMessager1&&user.getUID()!=1&&isHaveMessagerRight1==1){
												%>
												<tr id="showMessagerTrForSimpleHrm" style="display:none;">
													<td height="18" style="padding-left:5px;">
														<table width="100%" border="0" cellspacing="0"
															cellpadding="0">
															<tr>
																<td width="25%" class="STYLE4">
																	<div align="right">
																		<img src="/images/messageimages/temp/message_wev8.gif"
																			width="16" height="16" align="absmiddle" title="<%=SystemEnv.getHtmlLabelName(23525,user.getLanguage())%>">
																	</div>
																</td>
																<td width="81%" class="STYLE4" style="padding-left:10px;">
																	<div align="left">
																		<a href="javascript:showHrmChat();"><%=SystemEnv.getHtmlLabelName(23525,user.getLanguage())%></a>
																	</div>
																</td>
															</tr>
														</table>
													</td>
												</tr>
												<%}%>
											</table>
										</td>
										<td width="60%">
											<table width="100%" border="0" cellspacing="0"
												cellpadding="0" onselectstart="return false">
												<tr>
													<td height="15" colspan="2">
													<img id="closetext" style="color: #262626; cursor: hand;"
																src="/images/messageimages/temp/closeicno_wev8.gif" width="7"
																height="7" onclick="javascript:closediv();">
													</td>
												</tr>
												<tr>
													<td width="20%" height="25">
														<div align="center">
															<img id="isonline"
																src="/images/messageimages/temp/online_wev8.gif" width="21"
																height="20">
														</div>
													</td>
													<td width="80%">
														<span class="STYLE6" id="result0"></span>
													</td>
												</tr>
												<tr>
													<td class="simplehrmhead" height="25">
														<div align="right">
															<span class="STYLE6"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%>&nbsp:&nbsp</span>
														</div>
													</td>
													<td class="simplehrmhead" style="LEFT: 0px; WIDTH: 80%; WORD-WRAP: break-word;TEXT-VALIGN: left;word-break:break-all;">
														<span class="STYLE6" id="result1"></span>
													</td>
												</tr>
												<tr>
													<td class="simplehrmhead" height="25">
														<div align="right">
															<span class="STYLE6"><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%>&nbsp:&nbsp</span>
														</div>
													</td>
													<td class="simplehrmhead">
														<span class="STYLE6" id="result2"></span>
													</td>
												</tr>
												<tr>
													<td class="simplehrmhead" height="25">
														<div align="right">
															<span class="STYLE6"><%=SystemEnv.getHtmlLabelName(422,user.getLanguage())%>&nbsp:&nbsp</span>
														</div>
													</td>
													<td class="simplehrmhead" style="LEFT: 0px; WIDTH: 80%; WORD-WRAP: break-word;TEXT-VALIGN: left;word-break:break-all;">
														<span class="STYLE6" id="result3"></span>
													</td>
												</tr>
												<tr>
													<td class="simplehrmhead" height="25">
														<div align="right">
															<span class="STYLE6"><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%>&nbsp:&nbsp</span>
														</div>
													</td>
													<td class="simplehrmhead" style="LEFT: 0px; WIDTH: 80%; WORD-WRAP: break-word;TEXT-VALIGN: left;word-break:break-all;">
														<span class="STYLE6" id="result4"></span>
													</td>
												</tr>
												<tr>
													<td class="simplehrmhead" height="25">
														<div align="right">
															<span class="STYLE6"><%=SystemEnv.getHtmlLabelName(71,user.getLanguage())%>&nbsp:&nbsp</span>
														</div>
													</td>
													<td class="simplehrmhead" style="LEFT: 0px; WIDTH: 80%; WORD-WRAP: break-word;TEXT-VALIGN: left;word-break:break-all;">
														<span class="STYLE6" id="result5"></span>
													</td>
												</tr>
												<tr>
													<td class="simplehrmhead" height="25">
														<div align="right">
															<span class="STYLE6"><%=SystemEnv.getHtmlLabelName(18939,user.getLanguage())%>&nbsp:&nbsp</span>
														</div>
													</td>
													<td class="simplehrmhead" style="LEFT: 0px; WIDTH: 80%; WORD-WRAP: break-word;TEXT-VALIGN: left;word-break:break-all;">
														<span class="STYLE6" id="result6"></span>
													</td>
												</tr>
												<tr>
													<td class="simplehrmhead" height="25">
														<div align="right">
															<span class="STYLE6"><%=SystemEnv.getHtmlLabelName(596,user.getLanguage())%>&nbsp:&nbsp</span>
														</div>
													</td>
													<td class="simplehrmhead" style="LEFT: 0px; WIDTH: 80%; WORD-WRAP: break-word;TEXT-VALIGN: left;word-break:break-all;">
														<span class="STYLE6" id="result7"></span>
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
</div>