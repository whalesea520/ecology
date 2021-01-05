
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="mfs" class="weaver.email.service.MailFolderService" scope="page" />
<jsp:useBean id="mas" class="weaver.email.service.MailAccountService" scope="page" />
<jsp:useBean id="MailConfigService" class="weaver.email.service.MailConfigService" scope="page" />
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<meta name="viewport" content="width=device-width,minimum-scale=1.0, maximum-scale=1.0" />
	<title></title>
	<script type='text/javascript' src='/js/jquery/jquery_wev8.js'></script>
	<link rel="stylesheet" href="/wui/common/css/w7OVFont_wev8.css" type="text/css">
	<style type="text/css">
	html,body {
		height:100%;
		margin:0;
		padding:0;
		font-size:9pt;
		background: white;
	}
	a {
		text-decoration: none;
		cursor: pointer;
	}
	table {
		border-collapse: separate;
		border-spacing: 0px;
	}
	#page {
		width:100%;
		height:100%;
		background: white;
	}
	
	#header {
		width: 100%;
		filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#FFFFFF',
			endColorstr='#ececec' );
		background: -webkit-gradient(linear, left top, left bottom, from(#FFFFFF),
			to(#ECECEC) );
		background: -moz-linear-gradient(top, white, #ECECEC);
		border-bottom: #CCC solid 1px;
		/*
			filter: alpha(opacity=70);
			-moz-opacity: 0.70;
			opacity: 0.70;
			*/
	}
	#header_seach {
		width: 100%;
		background-color: #7f94af;
		border-top: #CCC solid 1px;
		border-bottom: #CCC solid 1px;
		height: 44px;
	}
	#header #title {
		color: #336699;
		font-size: 20px;
		font-weight: bold;
		text-align: center;
	}
	
	#loading {
		width: 250px;
		height: 65px;
		line-height: 65px;
		position: absolute;
		background: url("/mobile/plugin/images/loading_bg_wev8.png");
		top: 50%;
		left: 50%;
		display: block;
		text-align: center;
		margin-top: -32px;
		margin-left: -125px;
		z-index: 1002;
	}
	
	#loadingmask {
		position: absolute;
		width: 100%;
		height: 100%;
		z-index: 1001;
		display: block;
		filter:alpha(opacity=30); BACKGROUND-COLOR: #7f94af;
		opacity:0.3;
		overflow: hidden;
		top: 0;
		left: 0;
	}
	
	/* 流程搜索区域 */
	.search {
		width: 100%;
		height:44px;
		text-align: center;
		position: relative;
		background-color: #7f94af;

	}
	
	/* 流程搜索text */
	.searchText {
		width: 90%;
		height: 28px;
		margin-left: 0px;
		margin-right: auto;
		border: 0px;
		background: #fff;
		-moz-border-radius: 5px;
		-webkit-border-radius: 5px;
		border-radius: 5px;
		-webkit-box-shadow: inset 0px 1px 0px 0px #BCBFC3;
		-moz-box-shadow: inset 0px 1px 0px 0px #BCBFC3;
	}
	
	.prompt {
		color: #777878;
	}
	
	/* 列表区域 */
	.list {
		width: 100%;
		background: url(/images/bg_w_75_wev8.png);
	}
	/* 列表项*/
	.listitem {
		width: 100%;
		height: 80px;
		background: url(/images/bg_w_25_wev8.png);
		border-bottom: 1px solid #D8DDE4;
		cursor: pointer;
	}
	/* 列表项后置导航 */
	.itemnavpoint {
		height: 100%;
		width: 26px;
		text-align: center;
	}
	/* 列表项后置导航图  */
	.itemnavpoint img {
		width: 10px;
		heigth: 14px;
	}
	/* 流程创建人头像区域  */
	.itempreview {
		height: 100%;
		width: 30px;
		text-align: center;
	}
	/* 流程创建人头像  */
	.itempreview img {
		width: 40px;
		height: 40px;
		margin-top: 4px;
	}
	
	/* 列表项内容区域 */
	.itemcontent {
		width: *;
		height: 100%;
		font-size: 14px;
		cursor: pointer;
	}
	
	/* 列表项内容名称 */
	.itemcontenttitle {
		width: 100%;
		height: 23px;
		overflow-y: hidden;
		line-height: 23px;
		font-weight: bold;
		word-break: keep-all;
		text-overflow: ellipsis;
		white-space: nowrap;
		overflow: hidden;
		font-size: 14px;
	}
	
	/* 列表项内容简介 */
	.itemcontentitdt {
		width: 100%;
		height: 23px;
		overflow-y: hidden;
		line-height: 23px;
		font-size: 12px;
		color: #777878;
		word-break: keep-all;
		text-overflow: ellipsis;
		white-space: nowrap;
		overflow: hidden;
	}
	/* 更多 */
	.listitemmore {
		height: 50px;
		text-align: center;
		line-height: 50px;
		font-weight: bold;
		color: #777878;
		background:url(/images/bg_w_75_wev8.png);
		cursor: pointer;
		background-color: #ececec;
		
	}
	/* 列表更新时间 */
	.lastupdatedate {
		width: 100%;
		height: 20px;
		text-align: right;
		font-size: 12px;
		line-height: 20px;
		background: #E1E8EC;
		background: -moz-linear-gradient(0, white, #E1E8EC);
		background: -webkit-gradient(linear, 0 0, 0 100%, from(white),
			to(#E1E8EC) );
	}
	/* 间隔 */
	.blankLines {
		width: 100%;
		height: 1px;
		overflow: hidden;
		background-color: #ececec;
		
	
	}
	
	/* 列表项标题 */
	.ictwz {
		width: *;
		word-break: keep-all;
		text-overflow: ellipsis;
		white-space: nowrap;
		overflow: hidden;
	}
	
	

	/* new */
	.ictnew {
		width: 70px;
	}
	
	.tdimg{
		border-top: 1px solid black;
		border-left: 1px solid black;
		border-bottom: 1px solid black;
		border-right:0px;
		background-color: white;
		vertical-align:middle;
		padding-left: 5px;
		padding-top: 3px;
		cursor: pointer;
	}
	
	.tdinput{
		border-top: 1px solid black;
		border-right: 1px solid black;
		border-bottom: 1px solid black;
		text-align:left;
		padding-left:5px;
		padding-right:5px;
		border-left:0px;
		background-color: white;
		vertical-align:middle;
	}
	
	.fivestar{
		width: 14px;
		height: 14px;
		background: url(/email/images/mailicon_wev8.png) -32px -160px no-repeat;
	}
	.fivestarcheck {
		width: 14px;
		height: 14px;
		background: url(/email/images/mailicon_wev8.png) -48px -160px no-repeat;
	}
	
	#receiveLoading div{
		width:110px;color:#fff;margin-top:3px;height:20px;;background: #499b3c;line-height: 20px;background-image: url(/email/images/loading_wev8.gif);background-repeat:no-repeat;background-position: left;
	}
	
	#tools {
		width: 100%;
		filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#FFFFFF',endColorstr='#f3f3f3' );
		background: -webkit-gradient(linear, left top, left bottom, from(#FFFFFF),to(#f3f3f3) );
		background: -moz-linear-gradient(top, white, #f3f3f3);
		border-bottom: #CCC solid 1px;
		padding:3px 0px 3px 3px;
	}
	
	.Rr {
		background: url(/email/images/mailicon_wev8.png) -48px -16px no-repeat;
	}
	.Ru {
		background: url(/email/images/mailicon_wev8.png) -48px 0px no-repeat;
	}
	
	.cir {
		width: 18px;
		height: 16px;
		overflow: hidden;
		cursor: pointer;
	}
	
	</style>
</head>
<body>


<%
	
	
	

	String receivemail = Util.null2String(request.getParameter("receivemail"));
	String receivemailid = Util.null2String(request.getParameter("receivemailid"));
	String subject = Util.null2String(request.getParameter("subject"));
	//0--收件箱，-1--发件箱，-2--草稿箱，-3--已删除
	String  folderid =Util.null2String(Util.getIntValue(request.getParameter("folderid"),0)+"");
	String labelid = Util.null2String(request.getParameter("labelid"));
	//star = '1'表示标星邮件
	String star = Util.null2String(request.getParameter("star"));
	String isInternal= Util.null2String(request.getParameter("isInternal"));
	String method = Util.null2String(request.getParameter("method"));
	String mailaccountid = Util.null2String(request.getParameter("mailaccountid"));
	
	
	
	String status = Util.null2String(request.getParameter("status"));
	String from = Util.null2String(request.getParameter("from"));
	String to = Util.null2String(request.getParameter("to"));
	String attachmentnumber = Util.null2String(request.getParameter("attachmentnumber"));
	int index = Util.getIntValue(request.getParameter("index"),1);
	int perpage =Util.getIntValue(request.getParameter("perpage"),10);
	
	//0--收件箱，1--发件箱，2--草稿箱，3--已删除，4内部邮件，5标星邮件，6我的文件夹
	String menuid=Util.null2String(Util.getIntValue(request.getParameter("menuid"),0)+"");	
	String emailtitle="";
	 if ("0".equals(menuid)){
				emailtitle=SystemEnv.getHtmlLabelName(19816,user.getLanguage());
				isInternal="";
				folderid="0";
				star="";
	}else  if ("1".equals(menuid)){
				emailtitle=SystemEnv.getHtmlLabelName(19558,user.getLanguage());
				isInternal="";
				folderid="-1";
				star="";
	}else  if ("2".equals(menuid)){
				emailtitle=SystemEnv.getHtmlLabelName(2039,user.getLanguage());
				isInternal="";
				folderid="-2";
				star="";
	}else  if ("3".equals(menuid)){
				emailtitle=SystemEnv.getHtmlLabelName(2040,user.getLanguage());
				isInternal="";
				star="";
				folderid="-3";
	}else  if ("4".equals(menuid)){
				emailtitle=SystemEnv.getHtmlLabelName(24714,user.getLanguage());
				isInternal="1";
				folderid="";
				star="";
	}else  if ("5".equals(menuid)){
				emailtitle=SystemEnv.getHtmlLabelName(81337,user.getLanguage());
				star="1";
				folderid="";
				isInternal="";
	}
	else  if ("6".equals(menuid)){
				emailtitle = mfs.getSysFolderName(Util.getIntValue(folderid),user.getLanguage());
				if(emailtitle.equals("")){
					mfs.selectMailFolderInfo(Util.getIntValue(folderid));
					if(mfs.next()){
						emailtitle = mfs.getFolderName();//得到文件夹的名字
					}
				}
				star="";
				isInternal="";
	}

	
/* 	if("1".equals(isInternal)){
				emailtitle="内部邮件";
	}
	 */

	/* if(!folderid.equals("")){
		emailtitle = mfs.getSysFolderName(Util.getIntValue(folderid),user.getLanguage());
		if(emailtitle.equals("")){
			mfs.selectMailFolderInfo(Util.getIntValue(folderid));
			if(mfs.next()){
				emailtitle = mfs.getFolderName();//得到文件夹的名字
			}
		}
	}else if(!labelid.equals("")){
		emailtitle = lms.getLabelInfo(labelid).getName();
	}else if("1".equals(isInternal)){
		emailtitle =  SystemEnv.getHtmlLabelName(24714,user.getLanguage());//内部邮件
	}else{
		emailtitle = SystemEnv.getHtmlLabelName(81288,user.getLanguage());//??这个标签4.114没有？（标星邮件）
	}
	
	if(method.equals("dosearch")){
		emailtitle = SystemEnv.getHtmlLabelName(81289,user.getLanguage()); //搜索结果
	} */
	
	String receivemailids =  mas.getAllAccountIds(user.getUID());
	
	String clienttype = Util.null2String((String)request.getParameter("clienttype"));
	String clientlevel = Util.null2String((String)request.getParameter("clientlevel"));
	String module=Util.null2String((String)request.getParameter("module"));
	String scope=Util.null2String((String)request.getParameter("scope"));
	
	String userid=""+user.getUID();
	Map mailConfig=MailConfigService.getMailConfig();
	int innerMail=Util.getIntValue(Util.null2String(mailConfig.get("innerMail")),0);
	int outterMail=Util.getIntValue(Util.null2String(mailConfig.get("outterMail")),0);
	int autoreceive=Util.getIntValue(Util.null2String(mailConfig.get("autoreceive")),0);
	
	int defaultMailType=MailConfigService.getDefaultMailType(userid);
	String mailUrl="/mobile/plugin/email/EmailNew.jsp?";
	if(defaultMailType==1)
		mailUrl="/mobile/plugin/email/EmailNewIn.jsp?";
	mailUrl+="type=2&folderid="+folderid+"&isInternal="+isInternal+"&star="+star+"&menuid="+menuid+"&module="+module+"&scope="+scope;
	
%>


<table id="page"  style="width: 100%;height: 100%;"  cellpadding="0" cellspacing="0">
	<tr>
	<td width="100%" height="100%" valign="top" align="left">
			<div id="header"  style="<%if (clienttype.equals("Webclient")) {%>display:block;<%} else {%>display:none;<%}%>">
					<table style="width: 100%; height: 40px;">
						<tr>
							<td width="10%" align="left" valign="middle" style="padding-left:5px;">
									<a href="/mobile/plugin/email/EmailMenu.jsp?module=<%=module%>&scope=<%=scope%>">
										<div style="width:56px;height:26px;background:url('/images/bg-top-btn.png') no-repeat;text-align:center;line-height:26px;color:#000;font-size: 14px">
											<%=SystemEnv.getHtmlLabelName(71,user.getLanguage()) %>
										</div>
									</a>
							</td>
							<td align="center" valign="middle">
								<div id="title" ><%=Util.getMoreStr(emailtitle, 5, "..")%></div>
							</td>
							<td width="10%" align="right" valign="middle" style="padding-right:5px;">
										
										<a href="<%=mailUrl%>">
										<div style="width:56px;height:26px;background:url('/images/bg-top-btn.png') no-repeat;text-align:center;line-height:26px;color:#000;font-size: 14px">
										<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) %>
										</div>
									</a>
							</td>
						</tr>
					</table>
			</div>
			
			<form id="highSearchForm" name="highSearchForm" action="/mobile/plugin/email/EmailMain.jsp?module=<%=module%>&scope=<%=scope%>" method="post " style="margin: 0px">
			<div id="header_seach">
						<input name="folderid" id="folderid" type="hidden" value="<%=folderid%>">
						<input name="labelid" id="labelid" type="hidden" value="<%=labelid%>">
						<input name="star" id="star" type="hidden" value="<%=star%>">
						<input name="isInternal" id="isInternal" type="hidden" value="<%=isInternal%>">
						<input name="method" id="method" type="hidden" value="dosearch">
						<input name="perpage" id="perpage" type="hidden" value="<%=perpage%>">
						<input name ="index"  id="index" type="hidden" value="<%=index %>">
						<input name ="menuid"  id="menuid" type="hidden" value="<%=menuid %>">
						
						
					
						<div class="search">
									<table style="width: 100%;height:40px;margin-top: 2px"  cellpadding="0" cellspacing="0">
											<colgroup>
																<col width="5px">
												   				<col width="25px">
												   				<col width="*">
												   				<col width="5px">
											</colgroup>
											<tr>
													<td>
													</td>
													<td class="tdimg" id="seach">
														<img src="/images/icon-search.png">
														
														
													</td>
													<td class="tdinput">
														<input type="text" id="subject" name="subject" class="searchText prompt"  >
													</td>
													<td>
													</td>
											</tr>
									</table>
						</div>
					
			</div>
			</form>
			<div id="tools">
				<div style="float: left;">
					<input type="checkbox" id="checkAll" onclick="checkAll(this)">
				</div>
				<div onclick="delMails()" style="float:left;width:56px;height:26px;background:url('/images/bg-top-btn.png') no-repeat;text-align:center;line-height:26px;color:#000;font-size: 14px">
					 <%=SystemEnv.getHtmlLabelName(125426,user.getLanguage()) %>
				</div>
				<div style="clear: left;"></div>
			</div>
			<div class="list" id="list">
						<div id="receiveLoading" style="display: none;" align="center"><div>&nbsp;<%=SystemEnv.getHtmlLabelName(81290,user.getLanguage()) %></div></div>
						<div id="mailList">
						</div>
			</div>
	</td>
</tr>
<tr>
		<td>
				<div class=" listitemmore"  id="listItemMore"  >
						<%=SystemEnv.getHtmlLabelName(81408,user.getLanguage()) %>
				</div>
		</td>
</tr>	
</table>

<div id="loading"><%=SystemEnv.getHtmlLabelName(30665,user.getLanguage()) %>...</div>
<div id="loadingmask" ></div>

	

	
<script type="text/javascript">
var module="<%=module%>";
var scope="<%=scope%>";
var isFirst=true;
jQuery(document).ready(function(){

	//对汉字参数进行处理
	jQuery.param=function( a ) {  
		    var s = [ ];  
		    var encode=function(str){  
		        str=escape(str);  
		        str=str.replace(/\+/g,"%u002B");
		        return str;  
		    };  
		    function add( key, value ){  
		        s[ s.length ] = encode(key) + '=' + encode(value);  
		    };  
		    // If an array was passed in, assume that it is an array  
		    // of form elements  
		    if ( jQuery.isArray(a) || a.jquery )  
		        // Serialize the form elements  
		        jQuery.each( a, function(){  
		            add( this.name, this.value );  
		        });  
		    // Otherwise, assume that it's an object of key/value pairs  
		    else  
		        // Serialize the key/values  
		        for ( var j in a )  
		            // If the value is an array then the key names need to be repeated  
		            if ( jQuery.isArray(a[j]) )  
		                jQuery.each( a[j], function(){  
		                    add( j, this );  
		                });  
		            else  
		                add( j, jQuery.isFunction(a[j]) ? a[j]() : a[j] );   
		    // Return the resulting serialization  
		    return s.join("&").replace(/%20/g, "+");  
	}
		
		loadMailListContent(1);
		//初始化标签相关响应
		$("#listItemMore").bind("click", function(){
			//TotalPage
			var upindex=parseInt($("#index").val())+1;
			if(upindex<=parseInt($("#TotalPage").val())){
					var newhtml="<img src='/images/loading2_wev8.gif'><%=SystemEnv.getHtmlLabelName(30665,user.getLanguage()) %>...";
					$("#index").attr("value",upindex);
					var temp=$("#index").val();
					$("#listItemMore").html(newhtml);
					loadMailListAppendContent(temp);
			}else{
				$("#listItemMore").hide();
			}
		});
		$("#seach").bind("click", function(){
				loadMailListContent(1);
		});
		//getMail();
});

var receivedTimes=0; //接收次数
// 收取邮件
function getMail(){
    if(<%=outterMail%> == 0) return;

	receivedTimes++;
	var ids ="<%=receivemailids%>";
	var ids2 = ids.split(",");
	var len = ids2.length;
	if(ids=="")  return;
	var receivedMailNumber=0;
	var isOverTime=false;
	jQuery("#receiveLoading").show();
	for(var i=0;i<ids2.length;i++){
		if(ids2[i]=="") continue;
		jQuery.post("/mobile/plugin/email/EmailOperationGet.jsp?operation=get&mailAccountId=" + ids2[i],function(data){
			data=eval("("+data+")");
			if(data.receivedMailNumber == '0'){
				jQuery("#receiveLoading").hide();
				return;
			}
			len--; 
			receivedMailNumber=receivedMailNumber+parseInt(data.receivedMailNumber);
			if(isNaN(parseInt(data.receivedMailNumber)))
			   isOverTime=true;
			if(len==0){
				if(isOverTime){
					setTimeout(getMail,5000);
				}else{
					jQuery("#receiveLoading").hide();
					// 刷新总数据和未读数据
					if(receivedMailNumber>0||(receivedMailNumber==0 && receivedTimes>1)){
						loadMailListContent(1);
					}
				}	
			}
		})
	}
	
}


//默认加载
function loadMailListContent(index){
	$("#index").attr("value",index);
	var formData=$("#highSearchForm").serialize()+"&loadtype=0&module="+module+"&scope="+scope+"&data="+new Date().getTime();
	jQuery("#mailList").load("/mobile/plugin/email/EmailListContent.jsp",formData, function(){
		//初始化标签相关响应
		initLableTarget();
		$("#loadingmask").hide();
		$("#loading").hide();
		if($("#TotalPage").val()=="1"){
				$("#listItemMore").hide();
		}
		if(isFirst&&"<%=folderid%>"=="0"){  
			isFirst=false;
			getMail();
		}	
	});
}


//更多加载
function loadMailListAppendContent(index){
	var formData="?"+$("#highSearchForm").serialize()+"&module="+module+"&scope="+scope+"&loadtype=1&data="+new Date().getTime();
	//通过post第2个参数传递过去无效
	$.post("/mobile/plugin/email/EmailListContent.jsp"+formData, "", function(Data){
				jQuery("#mailList").append(Data);
				//初始化标签相关响应
				initLableTarget();
				if(index==$("#TotalPage").val()){
						$("#listItemMore").hide();
				}else{
					//判断更多按钮是否可用
					$("#listItemMore").html("<%=SystemEnv.getHtmlLabelName(81408,user.getLanguage()) %>");
				}
	});
}


		
//标签功能
function initLableTarget(){
	$(".trclick").unbind().bind("click", function(event){
		var _name=$(event.target).attr("_name");
		if(_name=="star"){
			if (event.stopPropagation) { 
				// this code is for Mozilla and Opera 
				event.stopPropagation(); 
			} 
			else if (window.event) { 
				// this code is for IE 
				window.event.cancelBubble = true; 
			}
		}else{
			var mailId=$(this).attr("_id");
			var _folderid=$(this).attr("_folderid");
			var _star=$(this).attr("_star");
			var _isInternal=$(this).attr("_isInternal");
			if("-2"==_folderid){//草稿直接打开到新建页面
				if("1"==_isInternal){//是草稿，并且是内部邮件
					var url ="/mobile/plugin/email/EmailNewIn.jsp?type=2&id="+ mailId +"&flag=4&star="+_star+"&isInternal=1&folderid=<%=folderid%>&menuid=<%=menuid%>&module="+module+"&scope="+scope+"";
					window.location.href=url;
				}else{
					var url ="/mobile/plugin/email/EmailNew.jsp?type=2&id="+ mailId +"&flag=4&star="+_star+"&folderid=<%=folderid%>&menuid=<%=menuid%>&module="+module+"&scope="+scope+"";
					window.location.href=url;
				}
			}else{//非草稿调至查看页面
				var url = "/mobile/plugin/email/EmailView.jsp?mailid="+mailId+"&folderid=<%=folderid%>&status=<%=status%>&star="+_star+"&menuid=<%=menuid%>&module="+module+"&scope="+scope+"";
				window.location.href=url;
			}
		}
	});
	//星标功能
	$(".fivestar,.fivestarcheck").unbind().bind("click", function(){
			var self = this;
			var mailId=$(self).attr("_id");
			if($(self).hasClass("fivestarcheck")) {
				
				$.post("/mobile/plugin/email/EmailViewOperation.jsp?mailId="+mailId+"&star=0&operation=updateStar&module="+module+"&scope="+scope+"", "", function(){
					$(self).removeClass("fivestarcheck").addClass("fivestar");
				});
			} else {
				$.post("/mobile/plugin/email/EmailViewOperation.jsp?mailId="+mailId+"&star=1&operation=updateStar&module="+module+"&scope="+scope+"", "", function(){
					$(self).addClass("fivestarcheck").removeClass("fivestar");
				});
			}
		});
	
}

//当用户点击标题上左边或右边按钮时，客户端会调用页面上的javascript方法:
function doLeftButton() {
			window.location.href="/mobile/plugin/email/EmailMenu.jsp?module="+module+"&scope="+scope+"";
			return "1";
}
function doRightButton(){
	
	<%
			if("4".equals(menuid)){
				//内部邮件只能回复到内部人员
	%>
				window.location.href="/mobile/plugin/email/EmailNewIn.jsp?type=2&folderid=<%=folderid%>&isInternal=<%=isInternal%>&star=<%=star%>&menuid=<%=menuid%>&module="+module+"&scope="+scope+"";
	<%
			}else{
	%>
				window.location.href="<%=mailUrl%>";
	<%} %>
	return "1";

}
function getLeftButton(){
		return "1,<%=SystemEnv.getHtmlLabelName(71,user.getLanguage()) %>";
}
function getRightButton(){
		return "1,<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) %>";
		///mobile/plugin/email/EmailNew.jsp?type=1"
}

function delMails(){
	var mailids="";
	$("#mailList").find("input:checked").each(function(){
		mailids=mailids+","+$(this).val();
	});
	mailids=mailids.length>0?mailids.substr(1):mailids;
	if(mailids.length>0){
		if(confirm("<%=SystemEnv.getHtmlLabelName(129890,user.getLanguage()) %>")){
			$.post("/mobile/plugin/email/EmailViewOperation.jsp?operation=delMail&mailId="+mailids,function(){
				loadMailListContent(1);
				$("#checkAll").attr("checked",false);  
			});
		}
	}else{
		alert("<%=SystemEnv.getHtmlLabelName(130170,user.getLanguage()) %>");
	}
}

function checkAll(obj){
	var flag=false;
	if(obj.checked){ 
		flag=true;
	}
	$("#mailList").find("input[type=checkbox]").each(function(){
		this.checked=flag;
	});
}

function getMenus(){
	var menuStr='['+
	               '{"title":"<%=SystemEnv.getHtmlLabelName(19816,user.getLanguage())%>","url":"/mobile/plugin/email/EmailMain.jsp?folderid=0&menuid=0","target":"_self","icon":"/mobile/plugin/images/f_m_wev8.png"},'+
	               '{"title":"<%=SystemEnv.getHtmlLabelName(19558,user.getLanguage())%>","url":"/mobile/plugin/email/EmailMain.jsp?folderid=-1&menuid=1","target":"_self","icon":"/mobile/plugin/images/s_m_wev8.png"},'+
	               '{"title":"<%=SystemEnv.getHtmlLabelName(2039,user.getLanguage())%>","url":"/mobile/plugin/email/EmailMain.jsp?folderid=-2&menuid=2","target":"_self","icon":"/mobile/plugin/images/c_m_wev8.png"},'+
	               '{"title":"<%=SystemEnv.getHtmlLabelName(2040,user.getLanguage())%>","url":"/mobile/plugin/email/EmailMain.jsp?folderid=-3&menuid=3","target":"_self","icon":"/mobile/plugin/images/delete_m_wev8.png"},'+
	               (<%=innerMail%>==1?'{"title":"<%=SystemEnv.getHtmlLabelName(24714,user.getLanguage())%>","url":"/mobile/plugin/email/EmailMain.jsp?isInternal=1&menuid=4","target":"_self","icon":"/mobile/plugin/images/inside_m_wev8.png"},':'')+
	               '{"title":"<%=SystemEnv.getHtmlLabelName(81337,user.getLanguage())%>","url":"/mobile/plugin/email/EmailMain.jsp?star=1&menuid=4","target":"_self","icon":"/mobile/plugin/images/star_m_wev8.png"}'+
	               ']';
	return menuStr;               
}

</script>
	
</body>
</html>