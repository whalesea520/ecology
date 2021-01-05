
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
<script type="text/javascript" src="/js/ecology8/browserCommon_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/wuiform/jquery.wuiform_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<script type="text/javascript" src="/js/init_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/wuiform/jquery.wuiform_wev8.js"></script>
 
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<jsp:include page="/social/im/SocialIMUtil.jsp"></jsp:include>
<html>
<head>
	<link rel="stylesheet" href="/social/css/base_wev8.css"/>
	<link rel="stylesheet" href="/social/css/im_wev8.css"/>
	<link rel="stylesheet" href="/social/css/im_chatrec_wev8.css"/>
	<link rel="stylesheet" href="/social/css/base_public_wev8.css" type="text/css" />
	<script src="/social/im/js/IMUtil_wev8.js"></script>
	<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
	<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
	<style type="text/css">
		.RC_Expression {
		    width: 22px;
		    height: 22px;
		    background-image: url('/social/im/js/css-sprite_bg.png');
		    display: inline-block;
		}
		a.opdir {
			margin-left: 10px;
		}
		a.opdiv {
			cursor: pointer;
		}
	</style>
</head>
<%
	String userid=""+user.getUID();
	String targetid = Util.null2String(request.getParameter("targetid"));
	String targettype = Util.null2String(request.getParameter("targettype"));
	String IS_BASE_ON_OPENFIRE = Util.null2String(request.getParameter("IS_BASE_ON_OPENFIRE"));
%>

<body>

<div class='dataloading' style='text-align:center;position:relative;top:50%'>
	<img src='/social/images/loading_large_wev8.gif'/>
</div>

<div id="chatrec_div_top" class="chatrec_div_top">
	
	<div class="inputsGroup">
		<%=SystemEnv.getHtmlLabelName(345, user.getLanguage())%><!-- 内容 -->
		<input class="inputStyle middle" type="text" name="content" id="content"/>
		<%=SystemEnv.getHtmlLabelName(277, user.getLanguage())%><!-- 时间 -->
		<input type="text" name="begindate" readonly="readonly" class="inputStyle middle" id="begindate" value="" onclick="onShowDate('begindate')"/>
		<BUTTON type="button" class="imCalendar middle" onclick="onShowDate('begindate')"></BUTTON>
		<input type="text" name="enddate" readonly="readonly" class="inputStyle middle" id="enddate" value='' onclick="onShowDate('enddate')"/>
		<BUTTON type="button" class="imCalendar middle"  onclick="onShowDate('enddate')"></BUTTON>
	</div>
	<div class="rightBtnGroup middle">
		<input type="button" value="<%=SystemEnv.getHtmlLabelName(527, user.getLanguage())%>" class="searchBtn middle"  onclick="doSearch()"><!-- 查询 -->
	</div>
	
	
	
</div>
<div id="zDialog_div_content" class="zDialog_div_content chatList chatRecord">
	
</div>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<div class="crPagination">
		<div class="crLeft visitFirst visitFirstGray crDisabled" onclick="visitPage('first')"></div>
		<div class="crLeft visitPrev visitPrevGray crDisabled" onclick="visitPage('prev')"></div>
		<div class="crCenter"><%=SystemEnv.getHtmlLabelName(15323, user.getLanguage())%><span>0/0</span><%=SystemEnv.getHtmlLabelName(23161, user.getLanguage())%></div><!-- 第   页 -->
		<div class="crRight visitNext crDisabled" onclick="visitPage('next')"></div>
		<div class="crRight visitLast crDisabled" onclick="visitPage('last')"></div>
	</div>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
<!-- 聊天记录模板 -->
<div id="tempChatItem" class="chatItemdiv" style="display:none;">
	<div class="chatRItem">
			<div class="chatHead">
				<img src="" class="head35 userimage" onclick="showConverChatpanel($(this).parents('.chatItemdiv'))">
			</div>
			<div class="chattd">
				<div class="chatName"></div>
				<div class="clear"></div>
				<div class="chatArrow"></div>
				<div class="chatContentdiv">
					<div class="chatContent"></div>
					<div class="clear"></div>
				</div>
				<div class="clear"></div>
			</div>
			<div class="clear"></div>
	</div>	
</div>
<SCRIPT language="javascript"  defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript"  src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src='/js/JSDateTime/WdatePicker_wev8.js?rnd="+Math.random()+"'></script>
</body>
</html>
<script type="text/javascript">
	curPageNo = 1;
	totalPage = 1;
	targetid = '<%=targetid%>';
	targettype = getRongTargettype('<%=targettype%>');
	loginuserid = '<%=userid%>';
	IS_BASE_ON_OPENFIRE = '<%=IS_BASE_ON_OPENFIRE%>';
	parentwin = top.topWin.Dialog._Array[0].openerWin;
	client = parentwin.client;
	M_CORE = parentwin.M_CORE;
	IM_Ext = parentwin.IM_Ext;
	IMUtil = parentwin.IMUtil;
	docUtil = parentwin.docUtil; 
	ChatUtil = parentwin.ChatUtil;
	IMCarousel = parentwin.IMCarousel;
	var checkMore = "<%=SystemEnv.getHtmlLabelName(130114, user.getLanguage())%>";
	var begindateTemp;
	var enddateTemp;
	var contentTemp;
	var idTemp;
	var msgidTemp;
	$(function(){
		$('#zDialog_div_content').perfectScrollbar();
		//取第一页的数据
		if(targettype==2){
			
			parentwin.ChatUtil.getDiscussionInfo(targetid,false,function(discussion){
				if(discussion){
					fetchRecords(1);
				}
			});

		}else{
			fetchRecords(1);
		}
		//绑定所有获取的Imageid
		//bindImageIds(null);
	});
	
	/*查询*/
	function doSearch() {
		fetchRecords(1);
	}
	/*翻页*/
	function visitPage(tag){
		var no = curPageNo;
		switch(tag){
		case 'next':
			no++;
		break;
		case 'last':
			no = totalPage;
			if(curPageNo==totalPage) return ;
		break;
		case 'prev':
			no--;
		break;
		case 'first':
			no = 1;
			if(curPageNo==1) return ;
		break;
		default:
			no = parseInt(tag);
		}
		if(no>=1 && no<=totalPage){
			fetchRecords(no,true);
		}
	}
	/*访问数据库抓取数据*/
	function fetchRecords(no,istemp){
		var begindate = $('#begindate').val();
		var enddate = $('#enddate').val();
		var content=$("#content").val();
		if(istemp){
			 begindate = begindateTemp;
			 enddate = enddateTemp;
			 content=contentTemp;
		}else{
			 idTemp ="";
			 begindateTemp = begindate;
			 enddateTemp = enddate;
			 contentTemp = content;
		}
		content = encodeURI(content);
		var isShowBA = (begindate.length ==0&&enddate.length==0&&content.length==0)?false:true;
		//var enddateAry = enddate.split("-");
		//enddate = enddateAry[0]+"-"+enddateAry[1]+"-"+(++enddateAry[2]);
		$(".dataloading").show();
		$.post("/social/im/SocialIMOperation.jsp?operation=getChatRecords&pageNo="+no+"&begindate="+begindate+"&enddate="+enddate, 
			{
				"targetid":targetid, 
				"senderid":loginuserid, 
				"targettype":targettype,
				"content":content
			}, 
			function(json){
				//alert("json:"+json);
				if($.trim(json)!=''){
					var data = $.parseJSON(json);
					//if(data.isSuccess){
						curPageNo = no;
						totalPage = data.totalPage; //有可能更新


						//debugger;
						updatePagination();
						//更新显示
						updateContent(data.recList,isShowBA);
						//绑定获取的Imageid
						//bindImageIds(data.recList);
					//}
				}
				$(".dataloading").hide();
			});
	}
	/*判断imgid是否已经被绑定*/
	function checkIfExist(id, imgids){
		id = $.trim(id);
		imgids = $.trim(imgids);
		if(imgids == undefined || id == undefined || imgids == '' || id == '')
			return false;
		//只有一个元素的情况
		if(imgids.indexOf(",") == -1 && imgids == id){
			return true;
		}
		if(imgids.indexOf(id+",") == 0){
			return true;
		}else if(imgids.indexOf(","+id) != -1 && 
			imgids.indexOf(","+id) == (imgids.length -(id+",").length)){
			return true;
		}else if(imgids.indexOf(","+id+",") != -1){
			return true;
		}
		return false;
	}
	/*绑定Imageid*/
	function bindImageIds(recs){
		//FIXME:以下代码没有考虑浏览顺序
		/*
		var rec,imgUrl;
		var $dg = $('#zDialog_div_content');
		var imgids = $dg.data("imgids");
		for(var i = recs.length-1; i>=0; i--){
			rec = recs[i];
			imgUri=rec.imageUri;
			if(imgUri != "" && imgUri != "null"){
				imgUri = $.trim(imgUri);
				//第一次绑定


				if(imgids == undefined){
					imgids = imgUri;
				}else if(!checkIfExist(imgUri, imgids)){
					imgids += (","+imgUri);
				}
			}
		}
		$dg.data("imgids", imgids);
		*/
		$.post("/social/im/SocialIMOperation.jsp?operation=getImageIds&targetid="+targetid+"&senderid="+loginuserid+"&targettype="+targettype, 
		function(ids){
			if(ids != "")
				$('#zDialog_div_content').data("imgids", $.trim(ids));
		});
		
	}
	/*更新显示*/
	function updateContent(recs,isShowBA){
		//封装参数
		var senderInfo,msgObj,msgType,recordtype,immessage,realTargetid;
		var rec, extra;
		var container = $("#zDialog_div_content");
		container.empty();
		var date = new Date();
		var currentFullYear = date.getFullYear();
		//alert(recs.length);
		for(var i = recs.length-1; i>=0; i--){
			rec = recs[i];
            var extra = rec.extra;
            try {
                var extraObj=eval("("+extra+")");
                if(extraObj.msg_id && $("#"+extraObj.msg_id).length>0){
                    continue;
				}
            } catch (error) {
                extraObj = {};
            }
			//debugger;
			var senderid = parentwin.getRealUserId(rec.fromUserId);
			//if(senderid=="3379"||senderid=="3981"||senderid=="819") senderid="8";
			senderInfo = parentwin.getUserInfo(senderid);
			var content = rec.content;
			var imgUrl=rec.imageUri;

			var objName =rec.classname;
			var ID = rec.ID;
			var msgType = '';
			var sendtime=rec.dateTime;
			if(rec.classname=="RC:TxtMsg"){
				msgType=1;
			}else if(rec.classname=="RC:ImgMsg"){
				msgType=2;
			}else if(rec.classname=="RC:VcMsg"){
				msgType=3;
			}else if(rec.classname=="RC:LBSMsg"){
				msgType=8;
			}else{
				msgType=6;
			};
			
			if(IS_BASE_ON_OPENFIRE){
				content = content.replace(/\[.+?\]/g, function (x) {
	        		 return M_CORE.Expression.getEmojiObjByEnglishNameOrChineseName(x.slice(1, x.length - 1)).tag || x;});
			}
			msgObj = {"content":parentwin.IMUtil.htmlEncode(content),"objectName":objName,"extra":extra,"imgUrl":imgUrl};
			recordtype = "send";
			if(loginuserid != senderid){		//查看者不是消息的发送者


				recordtype = "receive";
			}
			immessage = null;
			realTargetid = rec.targetId;
			var senddate;
			//时间戳格式


			if(/^[0-9]+$/.test(sendtime)){
				date = new Date();
				date.setTime(sendtime);
			}
			//yyyy-MM-dd HH:mm:ss
			else{
				var tempst = sendtime;
				var a = tempst.split(" "); 
				var b = a[0].split("-"); 
				var c = a[1].split(":"); 
				date = new Date(b[0], b[1] - 1, b[2], c[0], c[1], c[2]);
			}
			try{
				var targetFullYear = date.getFullYear(), datePattern = "MM-dd HH:mm:ss";	
				if(targetFullYear < currentFullYear) {
					datePattern = "yyyy-MM-dd HH:mm:ss";
				}
				senddate = date.pattern(datePattern);
			}catch(e){
				senddate = sendtime;
			}
			var latestSendtime=container.find(".chatItemdiv:last").attr("_sendtime");
			latestSendtime=latestSendtime==undefined?0:latestSendtime;
			sendtime = date.getTime();
			if((sendtime-latestSendtime)/(1000*60)>2){
				container.append("<div class='chatTime'>"+senddate+"</div>");
			}
			var tempdiv =parentwin.ChatUtil.getChatRecorddiv(senderInfo, msgObj, recordtype, msgType, immessage, realTargetid);
			tempdiv = parentwin.FontUtils.clearFontSetStyle(tempdiv);
			tempdiv.attr("_sendtime",sendtime);
			tempdiv.find(".chatContent").removeAttr("onmouseover").removeAttr("onmouseout");
			if(isShowBA){
				tempdiv.find(".chatContent").css("max-width", "75%");
				tempdiv.find(".msgUnreadCount").after("<div class ='beforeAndAfterMsg' onclick = 'viewBeforeAndAfterMsg("+ID+")'>"+checkMore+"</div>");
			}
			if(idTemp==ID){
                msgidTemp=extraObj.msg_id?extraObj.msg_id:"";
				tempdiv.children().css("background-color","#F1D8A2");
			}
			container.append(tempdiv);
		}
		parentwin.scrollTOBottom(container);
		scrollToContainer();
	}
	/*更新翻页显示*/
	function updatePagination(){
		var pag = $('.crPagination');
		pag.find('.crCenter span').html(curPageNo + '/' + totalPage);
		if(totalPage==0){
			pag.find('.crLeft').addClass('crDisabled');
			pag.find('.crRight').addClass('crDisabled');
			pag.find('.visitFirst').addClass('visitFirstGray');
			pag.find('.visitPrev').addClass('visitPrevGray');
			pag.find('.visitLast').addClass('visitLastGray');
			pag.find('.visitNext').addClass('visitNextGray');
		}else if(curPageNo == 1){  //首页
			pag.find('.crLeft').addClass('crDisabled');
			pag.find('.crRight').removeClass('crDisabled');
			pag.find('.visitFirst').addClass('visitFirstGray');
			pag.find('.visitPrev').addClass('visitPrevGray');
			pag.find('.visitLast').removeClass('visitLastGray');
			pag.find('.visitNext').removeClass('visitNextGray');
		}else if(curPageNo == totalPage){  //末页
			pag.find('.crLeft').removeClass('crDisabled');
			pag.find('.crRight').addClass('crDisabled');
			pag.find('.visitFirst').removeClass('visitFirstGray');
			pag.find('.visitPrev').removeClass('visitPrevGray');
			pag.find('.visitLast').addClass('visitLastGray');
			pag.find('.visitNext').addClass('visitNextGray');
		}else{	//中间页


			pag.find('.crLeft').removeClass('crDisabled');
			pag.find('.crRight').removeClass('crDisabled');
			pag.find('.visitFirst').removeClass('visitFirstGray');
			pag.find('.visitPrev').removeClass('visitPrevGray');
			pag.find('.visitLast').removeClass('visitLastGray');
			pag.find('.visitNext').removeClass('visitNextGray');
		}
	}
	/*获取融云定义的targettype*/
	function getRongTargettype(type){
		switch(type){
		case '0':		//私聊
			return '1';
		case '1':		//群
			return '2';
			default: return "-1";
		}
	}
	/*url打开*/
	function openUrlFromEmessge(url,type){
		if(typeof parent.openUrlFromEmessge ==="function"){
			parent.openUrlFromEmessge(url,type);
		}else{
			var strRegex  = /^(:\/\/)/;
		if(strRegex.test(url)){
			url = url.replace(strRegex,"http://");
		}
		if(url.indexOf(":")==-1||url.indexOf(":")>5){
			url = "http://" +url;
		}
			top.window.open(url,'_blank');
		}
	}
	function scrollToContainer(){
		var container = $("#zDialog_div_content");
		if(typeof msgidTemp !=="undefined"&&msgidTemp.length>0){
			try {
						var msgDiv = $("#"+msgidTemp);
						container.animate({
					    scrollTop: msgDiv.offset().top - container.offset().top + container.scrollTop()
					  }, 1000);
					} catch (error) {
				}
		}	

	}
	// 查看前后一条消息记录
	function viewBeforeAndAfterMsg(id){
			 idTemp = id;
		 	 begindateTemp = "";
			 enddateTemp = "";
			 contentTemp = "";
		$.post("/social/im/SocialIMOperation.jsp?operation=getBeforeAfterChatRecords", 
			{
				"targetid":targetid, 
				"senderid":loginuserid, 
				"targettype":targettype,
				"id":id
			}, 
			function(json){
				if($.trim(json)!=''){
						var data = $.parseJSON(json);
						curPageNo = data.pageNO;
						totalPage = data.totalPage; //有可能更新

						//debugger;
						updatePagination();
						//更新显示
						updateContent(data.recList);
				}
				$(".dataloading").hide();
			});
	}
	/*下载附件*/
	function downAccFile(obj, isDefPath){
		parentwin.downAccFile(obj, isDefPath);
	}
	/*查看图片*/
	function viewIMFile(obj) {
		parentwin.viewIMFile(obj);
	}
</script>