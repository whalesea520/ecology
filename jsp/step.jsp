<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<html> 
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="/css/Weaver_wev8.css" type="text/css" />
		<style>
		
		a:hover{
		    text-decoration: none !important;
		    color:rgb(13,147,246) !important
		}
		
		.emptyRow {
		    width: 70px;
		    margin-top:8px;
		}
		
		.dateArea {
		    text-align: center;
		    color: #c3c3c3;
		    width: 70px;
		    margin-top:20px;
		    
		}
		
		.discussView{
			padding-top:2px;
		}
		
		.left{float:left}
		.right{float:right}
		.clear{clear:both}
		
		.signItem {
			background:#fcfcfc;
			padding-right:8px;
			padding-top:10px;
			position:relative;
		}
		
		.signItem .discussitem{
			border:1px solid #dadada;
			background:#fff;
		}
		
		.signItem .discussline{
			border-left:2px solid #dadada;
			position:absolute;
			width:1px;
			top:15px;
			bottom:-10px;
			margin-left:32px;
			z-index:1;
		}
		
		.signItem .item_td{
			background:#f4f4f4;
		}
		
		.signItem .sortInfo{
			width: 100%;
			height:20px;
		}	
		
		.signItem .sortInfo .name{
		    color: #262626;
		    float: left;
		    margin-left:8px;
		}
		
		.signItem .sortInfo .name a{
			color:#333;
		}
		
		.signItem .time {
		    height: 20px;
		    width: 20px;
		    position:absolute;
		    top:10px;
		    left:24px;
		    z-index:10;
		}
		
		.signItem .state {
		    height: 20px;
		    width: 20px;
		    position:absolute;
		    top:2px;
		    left:27px;
		    z-index:10;
		}
		
		.signItem .substate {
		    height: 20px;
		    width: 20px;
		    position:relative;
		    left:27px;
		    z-index:10;
		}
		
		.signItem .reportContent table{border-collapse:collapse;}
		
		.signItem .reportContent {
		    padding: 4px 4px 4px 10px;
		    word-break:break-all;
		    overflow:auto;
		    cursor: text;
		    text-align: left !important;
		}
		
		.reportContent p {
		    margin: 0px
		}
		
		.dotedLine {
		    border-bottom: 1px dashed #D8D8D8;
		    margin-left: 3px;
		    margin-top: 3px;
		    line-height: 1px;
		}
		
		.signItem .img001 {
		    background: url(/appres/hrm/image/mobile/signin/img001.png) no-repeat;
		}
		
		.signItem .img002 {
		    background: url(/appres/hrm/image/mobile/signin/img002.png) no-repeat;
		}
		
		.signItem .img003 {
		    background: url(/appres/hrm/image/mobile/signin/img003.png) no-repeat;
		}
		
		.img{
			width: 31px;
			height: 45px;
			float: left;
		}
		
		.img009{
			background: url(/appres/hrm/image/mobile/signin/img009.png) no-repeat;
		}
		
		.img011{
			background: url(/appres/hrm/image/mobile/signin/img011.png) no-repeat;
		}
		
		.leftBg{
			background: url(/appres/hrm/image/mobile/signin/img016.png) no-repeat;
		}
		
		.leftBgMou{
			background: url(/appres/hrm/image/mobile/signin/img012.png) no-repeat;
		}
		
		.rightBg{
			background: url(/appres/hrm/image/mobile/signin/img017.png) no-repeat;
		}
		
		.rightBgMou{
			background: url(/appres/hrm/image/mobile/signin/img013.png) no-repeat;
		}
		
		.rightDisBg{
			background: url(/appres/hrm/image/mobile/signin/img015.png) no-repeat;
		}
		
		
		</style>
	</head>
	<body>
		<div id="mainContent" class="mainContent" style="overflow:none;">
			<table style="width: 100%" cellpadding="0" cellspacing="0">
				<tr>
				   <td valign="top" width="*" style="max-width: 800px;">
						<div>
							<div class="reportBody" id="reportBody" style="background-color: inherit !important; ">


								<div class="signItem">
									<table width="80%" style="TABLE-LAYOUT: fixed;" cellpadding="0" cellspacing="0" >
										<tbody>
											<tr>
												<td valign="top" width="50px" nowrap="nowrap">
													<div class="dateArea"></div> 
													<div class="time img001"></div>
													<div class="discussline"></div>
												</td>
												<td valign="top" class="img002">
													<div style="margin:1px 0px 0px 15px;color:white;height:30px;">&nbsp;升级步骤</div>
												</td>
											</tr>
											<tr>
												<td valign="top" width="50px" nowrap="nowrap">
													<div class="emptyRow"></div>
													<div class="discussline"></div>
												</td>
												<td valign="top"></td>
											</tr>
										</tbody>
									</table>
								</div>
									<div class="signItem">
										<table width="80%" style="TABLE-LAYOUT: fixed;" cellpadding="0" cellspacing="0" >
											<tbody>
												<tr>
													<td valign="top" width="50px" nowrap="nowrap">
														<div class="dateArea"></div> 
														<div class="state img003" title=""></div>
														<div class="discussline" style=""></div>
													</td>
													<td valign="top" class="item_td">
														<div class="discussitem">
															<div class="discussView">
																<div class="sortInfo" style="height:40px;line-height:40px">
																	<div style="float: left;">
																		<div class="name">&nbsp;步骤一：备份数据库&nbsp;</div>
																		
																		<div class="clear"></div>
																	</div>
																	<div class="clear"></div>
																</div>
															</div>
														</div>
													</td>
												</tr>
											</tbody>
										</table>
									</div>

									<div class="signItem">
										<table width="80%" style="TABLE-LAYOUT: fixed;" cellpadding="0" cellspacing="0" >
											<tbody>
												<tr>
													<td valign="top" width="50px" nowrap="nowrap">
														<div class="dateArea"></div> 
														<div class="state img003" title=""></div>
														<div class="discussline" style=""></div>
													</td>
													<td valign="top" class="item_td">
														<div class="discussitem">
															<div class="discussView">
																<div class="sortInfo" style="height:40px;line-height:40px">
																	<div style="float: left;">
																		<div class="name">&nbsp;步骤二：选择升级包&nbsp;</div>
																		
																		<div class="clear"></div>
																	</div>
																	<div class="clear"></div>
																</div>
															</div>
														</div>
													</td>
												</tr>
											</tbody>
										</table>
									</div>
									<div class="signItem">
										<table width="80%" style="TABLE-LAYOUT: fixed;" cellpadding="0" cellspacing="0" >
											<tbody>
												<tr>
													<td valign="top" width="50px" nowrap="nowrap">
														<div class="dateArea"></div> 
														<div class="state img003" title=""></div>
														<div class="discussline" style=""></div>
													</td>
													<td valign="top" class="item_td">
														<div class="discussitem">
															<div class="discussView">
																<div class="sortInfo" style="height:40px;line-height:40px">
																	<div style="float: left;">
																		<div class="name">&nbsp;步骤三：升级包验证&nbsp;</div>
																		
																		<div class="clear"></div>
																	</div>
																	<div class="clear"></div>
																</div>
															</div>
														</div>
													</td>
												</tr>
											</tbody>
										</table>
									</div>
									<div class="signItem">
										<table width="80%" style="TABLE-LAYOUT: fixed;" cellpadding="0" cellspacing="0" >
											<tbody>
												<tr>
													<td valign="top" width="50px" nowrap="nowrap">
														<div class="dateArea"></div> 
														<div class="state img003" title=""></div>
														<div class="discussline" style=""></div>
													</td>
													<td valign="top" class="item_td">
														<div class="discussitem">
															<div class="discussView">
																<div class="sortInfo" style="height:40px;line-height:40px">
																	<div style="float: left;">
																		<div class="name">&nbsp;步骤四：文件备份与覆盖&nbsp;</div>
																		
																		<div class="clear"></div>
																	</div>
																	<div class="clear"></div>
																</div>
															</div>
														</div>
													</td>
												</tr>
											</tbody>
										</table>
									</div>
									<div class="signItem">
										<table width="80%" style="TABLE-LAYOUT: fixed;" cellpadding="0" cellspacing="0" >
											<tbody>
												<tr>
													<td valign="top" width="50px" nowrap="nowrap">
														<div class="dateArea"></div> 
														<div class="state img003" title=""></div>
														<div class="discussline" style=""></div>
													</td>
													<td valign="top" class="item_td">
														<div class="discussitem">
															<div class="discussView">
																<div class="sortInfo" style="height:40px;line-height:40px">
																	<div style="float: left;">
																		<div class="name">&nbsp;步骤五：执行脚本&nbsp;</div>
																		
																		<div class="clear"></div>
																	</div>
																	<div class="clear"></div>
																</div>
															</div>
														</div>
													</td>
												</tr>
											</tbody>
										</table>
									</div>
									<div class="signItem">
										<table width="80%" style="TABLE-LAYOUT: fixed;" cellpadding="0" cellspacing="0" >
											<tbody>
												<tr>
													<td valign="top" width="50px" nowrap="nowrap">
														<div class="dateArea"></div> 
														<div class="state img003" title=""></div>
														<div class="discussline" style=""></div>
													</td>
													<td valign="top" class="item_td">
														<div class="discussitem">
															<div class="discussView">
																<div class="sortInfo" style="height:40px;line-height:40px">
																	<div style="float: left;">
																		<div class="name">&nbsp;步骤六：升级成功&nbsp;</div>
																		
																		<div class="clear"></div>
																	</div>
																	<div class="clear"></div>
																</div>
															</div>
														</div>
													</td>
												</tr>
											</tbody>
										</table>
									</div>									
							</div>
						</div>
				   </td>
			   </tr>
			</table>
			<div class="clear"></div>
		</div>
		<div style="bottom:10px;left:1px;position:absolute"><b>版本信息：V37</b></div>
	</body>
</html>