<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<%@page import="weaver.social.po.SocialClientProp"%>
<%@page import="weaver.social.service.SocialIMService"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
<link rel="stylesheet" href="/social/css/animate.min.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<link rel="stylesheet" href="/social/css/broadcast.send.css" type="text/css" />
<!-- 图片批量上传库 -->
<link rel="stylesheet" href="/social/js/imupload/imUploader.css" type="text/css" />
<script type="text/javascript" src="/social/js/imupload/imUploader.js"></script>
<script src="/social/js/dmuploader/src/dmuploader.js"></script>
<!-- 浏览框 -->
<script type="text/javascript" src="/js/messagejs/simplehrm_wev8.js"></script>
<script type="text/javascript" src="/js/workflow/wfbrow_wev8.js"></script>
<link rel="stylesheet" href="/css/rp_wev8.css" type="text/css"/>
<%
String userid=user.getUID()+"";
int usertype=0;
String from = Util.null2String(request.getParameter("from"));
boolean isFromPc = "pc".equals(from);
SocialIMService sis = new SocialIMService();
JSONObject sysBroadcastSet = sis.getSysBroadcastSet(user); 
if("1".equals(sysBroadcastSet.getString("isSysBroadcastForbit")) || "0".equals(sysBroadcastSet.getString("hasSysBroadcastRight"))){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<input type='hidden' id='f_weaver_belongto_userid' value='<%=userid%>'>
<input type='hidden' id='f_weaver_belongto_usertype' value='<%=usertype%>'>
<div id="content">
	<div class="warn">
		<div class="title"></div>
	</div>
	<form id="bcSendForm" method='post' action=''>
		<div id='receiveBrowser'>
			<span class='receiveTitle'><%=SystemEnv.getHtmlLabelName(131689, user.getLanguage()) %></span> <!-- 广播接收人 -->
			<brow:browser 
				viewType="0" name="field_toUserIds"
				browserValue="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="
				browserSpanValue="" 
				hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="2" 
				completeUrl="/data.jsp"
				width="88%" needHidden="false" defaultRow="99" 
				onPropertyChange="wfbrowvaluechange(this,122)"
				hasAdd="true" addBtnClass="resAddGroupClass" 
				addOnClick="showrescommongroup(this, '_toUserIds')">
			</brow:browser>
		</div>
		<textarea id='plaintextarea' placeholder='<%=SystemEnv.getHtmlLabelName(131690, user.getLanguage()) %>...' onkeyup="BC.checkWord(this);"></textarea><!-- 请填写广播内容 -->
		<div id='imagearea'>
			<div class='areaTitle'>
				<span><%=SystemEnv.getHtmlLabelName(74, user.getLanguage()) %></span><span class='greycolor'>(<%=SystemEnv.getHtmlLabelName(129933, user.getLanguage()) %>)</span><!-- 最多上传9张图片 -->
				<span class='errorSpan'></span>
			</div>
			<div id='imagelist'>
			</div>
		</div>
		<div id='oaresourcearea'>
			<div class='icobtngroup'>
				<div class="chatapp" title="<%=SystemEnv.getHtmlLabelName(156, user.getLanguage()) %>">
					<input type="file" id='uploadAccLayer' name="accfiles[]" multiple="multiple" class="uploadAccFiles">
					<div class="uploadAccLayer"></div>
				</div>
				<!--<a href='javascript:void(0)' title='<%=SystemEnv.getHtmlLabelName(156, user.getLanguage()) %>'><img src='/social/images/broadcast_acc_wev8.png'/>-->
				</a><a href='javascript:void(0)' title='<%=SystemEnv.getHtmlLabelName(131692, user.getLanguage()) %>' onclick='BC.showApp(0)'><img src='/social/images/broadcast_wf_wev8.png'/>
				</a><a href='javascript:void(0)' title='<%=SystemEnv.getHtmlLabelName(58, user.getLanguage()) %>' onclick='BC.showApp(1)'><img src='/social/images/broadcast_doc_wev8.png'/></a>
			</div>
			<div class='resourcelist'>
				<table width="100%" height="52px" cellpadding="0" cellspacing="0">
					<colgroup><col width="60px"><col width="*"></colgroup>
					<tr class='accList'>
						<td class="titleHead greycolor">
							<%=SystemEnv.getHtmlLabelName(156, user.getLanguage()) %>
						</td>
						<td class="titleBody">

						</td>
					</tr>
					<tr class='wfList'>
						<td class="titleHead greycolor">
							<%=SystemEnv.getHtmlLabelName(131692, user.getLanguage()) %>
						</td>
						<td class="titleBody">

						</td>
					</tr>
					<tr class='docList'>
						<td class="titleHead greycolor">
							<%=SystemEnv.getHtmlLabelName(58, user.getLanguage()) %>
						</td>
						<td class="titleBody">

						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
</div>
<!-- 底部按钮组 -->
<div id="zDialog_div_bottom" class="zDialog_div_bottom">	
 	<wea:layout>
 		<wea:group context="" attributes="{groupDisplay:none}">
 			<wea:item type="toolbar">
 				 <input type="button" value="<%=SystemEnv.getHtmlLabelName(131693, user.getLanguage()) %>" id="zd_btn_confirm" class="zd_btn_cancle" onclick="BC.doSendBroadcast();"><!-- 发布新广播 -->
                 <input type="button" value="<%=SystemEnv.getHtmlLabelName(201, user.getLanguage()) %>" id="zd_btn_cancle" class="zd_btn_cancle" onclick="top.getDialog(window).close()"> <!-- 取消 -->
 			</wea:item>
 		</wea:group>
 	</wea:layout>
 </div>
 
 <script>
 languageid = readCookie("languageidweaver");
 $(document).ready(function(){
	$('#content').perfectScrollbar();
	var initConfig = {
		url: '/social/SocialUploadOperate.jsp',
		dataType: 'json',
		fileName: 'Filedata',
		maxFiles: 9,
		onFilesMaxError: function(){
			BC.showInnerTip("<%=SystemEnv.getHtmlLabelName(131694, user.getLanguage()) %>！"); // 超过最大文件数
		},
		onUploadSuccess: function(boxEle, data){
			boxEle.attr('imageid', data.fileId);
		},
		onComplete: function(boxEle){
			//图片上传完毕后进行附件上传
			BC.doAccUpload();
		}
	}
 	$('#imagelist').imUploader(initConfig);
	//绑定附件上传
	var targetId = "oaresourcearea";
	var opts = {
		"allowedTypes": ".*",
		"fireBtnCls": "uploadAccLayer",
		"url": '/social/SocialUploadOperate.jsp',
		"dataType": 'json',
		"maxFileSize": <%=Util.getIntValue(SocialClientProp.getPropValue(SocialClientProp.MAXACCUPLOADSIZE)) * 1024 * 1024%>,
		"fileName": 'Filedata',
		"maxFiles": 10,
		"isAutoUploadOff": true,
			"ignoreReset": true,
	};
	BC.bindDmUploader(targetId, opts);
 });
 var opener = top.topWin.Dialog._Array[0].openerWin;
 var isFromPc = <%=isFromPc?1:0%>;
 var userid = "<%=userid%>";
 var BC = {
 	accDatas: [],
 	addIMFileRight: function(receiverIds, cb){
 		var targetid = "SysNotice_"+userid;
 		var targettype = "1";
 		var data = {};
 		var url="/social/im/SocialIMOperation.jsp?operation=addIMFile";
 		data["targetid"]=targetid;
		data["targetType"]=targettype;
		if((","+receiverIds+",").indexOf(","+userid+",") == -1){
			receiverIds += (","+userid);
		}
		data["memberids"]=receiverIds;
		
		var intervalId = setInterval(function(){
			jQuery.post(url,$.extend(BC.accDatas.pop(), data),function(content){	
				console.log("addIMFileRight callback content:"+content);
				if(BC.accDatas.length == 0){
					clearInterval(intervalId);
					if(typeof cb === 'function') {
						cb();
					}
				}
			});
		},200);
		
 	},
	bindDmUploader: function(targetid, opts){
		var targetCont = $("#"+targetid);
		var listeners = {
			onNewFile: function(id, file){
				BC.appendAccItem(id, file);
				var isfile = true;
		    	try{
		    		isfile = opener.PcMainUtils.isFile(file.path);
		    	}catch(e){
		    		console && console.error('PcMainUtils.isFile 未定义');
		    	}
		    	return isfile;
			},
			onUploadSuccess: function(id, data){
				var fileId = data.fileId;
				var fileName = data.filename;
				var fileSize = data.filesize;
				BC.accUploadCb(id, fileId, fileName, fileSize);
				BC.accDatas.push(
					{
						"fileId":fileId,
						"fileName":fileName,
						"fileSize": fileSize,
						"fileType": opener.getFileType(fileName),
						"objectName":"FW:attachmentMsg",
						"resourcetype": "1"
					});
			},
			onUploadProgress: function(id, percent){
				console.log("上传：", percent);
			},
			onFileSizeError: function(file){
				showImAlert("<%=SystemEnv.getHtmlLabelName(127328, user.getLanguage())+SocialClientProp.getPropValue(SocialClientProp.MAXACCUPLOADSIZE)%>M");//<!-- 最大不能超过300M -->
			},
			onFilesMaxError: function(file){

			},
			onComplete: function(){
				//附件上传完毕，进行数据封装和发送
				BC.doSend();
			}
		};
		targetCont.dmUploader($.extend(opts, listeners));
		if(opts && opts.hasOwnProperty('fireBtnCls')){
			var fireBtnCls = opts.fireBtnCls;
			if(fireBtnCls == '')
				return;
			//绑定上传按钮点击事件
			targetCont.find('.'+fireBtnCls).bind('click', function(event){
				var obj = targetCont.find('#'+fireBtnCls)[0];
				if(obj.fireEvent){
					return obj.fireEvent("onclick");
				}else if(obj.onclick){
					return obj.onclick();
				}else if(obj.click){
					return obj.click();
				}
			});
		}
	},
	showMsg: function(msg){
		jQuery(".warn").find(".title").html(msg);
		jQuery(".warn").css("display","block");
		setTimeout(function (){
			jQuery(".warn").css("display","none");
		},1500);
	},
	doSendBroadcast: function(){
		BC.doImgUpload();
	},
	doImgUpload: function(){
		// 上传图片
		var pluginName = 'imUploader';
		var imUploader = $('#imagelist').data(pluginName);
		if(imUploader && imUploader.getFileLen() > 0){
			BC.showMsg("<%=SystemEnv.getHtmlLabelName(131695, user.getLanguage()) + " " + SystemEnv.getHtmlLabelName(74, user.getLanguage()) %>"); // 正在上传图片
			imUploader.processQueue();
		}else{
			BC.doAccUpload();
		}
	},
	doAccUpload: function(){
		// 上传附件
		var pluginName = 'dmUploader';
		var dmUploader = $('#oaresourcearea').data(pluginName);
		if(dmUploader && dmUploader.queue.length > 0){
			BC.showMsg("<%=SystemEnv.getHtmlLabelName(131695, user.getLanguage()) + " " + SystemEnv.getHtmlLabelName(156, user.getLanguage()) %>"); // 正在上传附件
			dmUploader.processQueue();
		}else{
			BC.doSend();
		}
	},
	doSend: function(){
		var params = BC.packParams();
		$.post("/mobile/plugin/social/SocialMobileOperation.jsp?operation=sendBroadcast",params, function(data){
			BC.showMsg('发送成功');
			setTimeout(function(){
				if(opener){
					//TODO 更新最后一条消息并刷新列表
					//文档、流程赋权
					var resourcetype = 0;
					var receiverids = params.receiverIds;
					var resourceary = opener.IMUtil.niceSplit(params.wfids, ",");
					for(var i = 0; i < resourceary.length; ++i){
						opener.addShareRight(resourcetype, resourceary[i], "", receiverids);
					}
					resourcetype = 1;
					resourceary = opener.IMUtil.niceSplit(params.docids, ",");
					for(var i = 0; i < resourceary.length; ++i){
						opener.addShareRight(resourcetype, resourceary[i], "", receiverids);
					}
					//附件赋权
					console.log("附件赋权开始");
					BC.addIMFileRight(params.receiverIds, function(){
						top.getDialog(window).close()
					});
				}
			},1000);
		});
		return params;
	},
	packParams: function(){
		var plaintext = $('#plaintextarea')[0].value;
		plaintext = $.trim(plaintext);
		var receiverIds = '';

		var spans = $('#field_toUserIdsspan .e8_showNameClass>span');
		for(var i = 0; i < spans.length; ++i) {
			receiverIds += (","+$(spans[i]).attr('id'));
		}
		if(receiverIds === ''){
			BC.showMsg("<%=SystemEnv.getHtmlLabelName(131696, user.getLanguage()) %>"); // 请选择接收人
			throw new Error('输入接收人');
		}
		//imageids
		var imageids = "";
		var thumbBoxs = $('#imagelist').children('.thumbbox');
		for(var i = 0; i < thumbBoxs.length; ++i) {
			var imageid = $(thumbBoxs[i]).attr('imageid');
			if(typeof imageid !== 'undefined' && imageid != '') {
				imageids += (","+imageid);
			}
		}
		//accids
		var accids = "",accnames ="", accsizes ="";
		var accLines = $('#oaresourcearea .accList .titleBody>div');
		for(var i = 0; i < accLines.length; ++i){
			var accid = $(accLines[i]).attr('data-resourceid');
			var accname = $(accLines[i]).attr('data-resourcename');
			var accsize = $(accLines[i]).attr('data-resourcesize');
			if(typeof accid !== 'undefined' && accid != ''){
				accids += (","+accid);
				accnames += (","+accname);
				accsizes += (","+accsize);
			}
		}
		//wfids
		var wfids = "", wfnames = "";
		var wfLines = $('#oaresourcearea .wfList .titleBody>div');
		for(var i = 0; i < wfLines.length; ++i){
			var wfid = $(wfLines[i]).attr('data-resourceid');
			var wfname = $(wfLines[i]).attr('data-resourcename');
			if(typeof wfid !== 'undefined' && wfid != ''){
				wfids += (","+wfid);
				wfnames += (","+wfname);
			}
		}
		//docids
		var docids = "", docnames = "";
		var docLines = $('#oaresourcearea .docList .titleBody>div');
		for(var i = 0; i < docLines.length; ++i){
			var docid = $(docLines[i]).attr('data-resourceid');
			var docname = $(docLines[i]).attr('data-resourcename');
			if(typeof docid !== 'undefined' && docid != ''){
				docids += (","+docid);
				docnames += (","+docname);
			}
		}
		if(plaintext === '' && imageids ==='' && accids === '' && wfids === '' && docids === ''){
			BC.showMsg("<%=SystemEnv.getHtmlLabelName(131697, user.getLanguage()) %>"); // 请编辑发送内容
			throw new Error('无编辑要发送的内容');
		}
		var params = {
			'imageids': imageids,
			'accids': accids,
			'accnames': accnames,
			'accsizes':accsizes,
			'wfids': wfids,
			'wfnames': wfnames,
			'docids': docids,
			'docnames': docnames,
			'receiverIds': receiverIds,
			'plaintext':plaintext
		};
		return params;
	},
	showApp: function(appType){
		var url = "";
		switch(appType){
		//流程
		case 0:
			url = "/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp";
		break;
		//文档
		case 1:
			url = "/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp";
		break;
		}
		showModalDialogForBrowser(event,url,'#','resourceBrowser',false,1,'',
		{
			name:'resourceBrowser',
			hasInput:false,
			zDialog:true,
			needHidden:true,
			dialogTitle:'',
			arguments:'',
			_callback: function(event, data){
				BC.appCb(event, data, appType);
			}
		});
	},
	appCb: function(event,data,appType){
		var ids = data.id;
		var names=data.name;
		if(ids.split(",").length>10){
			BC.showMsg("<%=SystemEnv.getHtmlLabelName(131698, user.getLanguage()) %>"); // 您选择的数量太多
		}else if(ids.length>0){
			var tempids=ids.split(",");
			var tempnames=names.split(",");

			for(var i=0;i<tempids.length;i++){
				var tempid=tempids[i];
				var tempname=tempnames[i];
				if(tempid=='') continue;
				var url="";
				var resourcetype=0;
				var className = "";
				if(appType === 0){
					url="/workflow/request/ViewRequest.jsp?requestid="+tempid;
					resourcetype=0;
					className = 'wfList';
				}else if(appType === 1){
					url="/docs/docs/DocDsp.jsp?id="+tempid;
					resourcetype=1;
					className = 'docList';
				}
				var divTmp = "<div data-resourcetype=\""+resourcetype+"\" data-resourcename=\""+tempname+"\" data-resourceid=\""+tempid+"\"><a href=\"javascript:void(0);\" onclick=\"BC.openViewer(\'"+url+"\')\">"+tempname+"</a><span class=\"itemCloseSpan\" onclick=\"BC.closeListItem(this)\">×</span></div>";

				$('#oaresourcearea .'+className+' .titleBody').append(divTmp);
				$('#oaresourcearea .'+className+'').show();
			}
		}
	},
	humanizeSize: function (size) {
		var i = Math.floor( Math.log(size) / Math.log(1024) );
		return ( size / Math.pow(1024, i) ).toFixed(2) * 1 + ' ' + ['B', 'kB', 'MB', 'GB', 'TB'][i];
	},
	appendAccItem: function(index, file){
		var className = 'accList';
		var divTmp = "<div id=\"acc-"+index+"\"><a href=\"javascript:void(0);\">"+file.name+"</a>("+BC.humanizeSize(file.size)+")<span class=\"itemCloseSpan\" onclick=\"BC.closeListItem(this)\">×</span></div>";
		$('#oaresourcearea .'+className+' .titleBody').append(divTmp);
		$('#oaresourcearea .'+className+'').show();
	},
	accUploadCb: function(index, fileid, filename, filesize){
		var className = 'accList';
		var itemDiv = $('#oaresourcearea #acc-'+index);
		if(itemDiv.length > 0){
			itemDiv.
				attr('data-resourcetype', '2').
				attr('data-resourceid', fileid).
				attr('data-resourcename', filename).
				attr('data-resourcesize', filesize);
		}
		$('#oaresourcearea .'+className+'').show();
	},
	openViewer: function(url){
		if(opener && isFromPc){
			opener.PcExternalUtils.openUrlByLocalApp(url);
		}else{
			window.open(url);
		}
	},
	closeListItem: function(ele){
		var itemBlock = $(ele).parent();
		var id = itemBlock.attr('id');
		//附件要把file对象打上删除标记
		if(id){
			var index = id.split('-')[1];
			var dmUploader = $('#oaresourcearea').data("dmUploader");
			dmUploader.queueMark[index] = 'DEL';
		}
		if(itemBlock.parent().children().length == 1){
			itemBlock.closest('tr').hide();
		}
		itemBlock.remove();
	},
	checkWord: function(obj){
		var bcSendForm = $("#bcSendForm");
	  	var maxLen = 1000;
	  	var IMUtil = opener.IMUtil;
	  	var curContent = obj.value;
	  	//删空后会预留一个<br>
	  	if(curContent == "<br>"){
	  		curContent = "";
	  	}
	  	var strLen = 0;
	  	if(IMUtil){
	  		strLen = IMUtil.getStrLen(curContent);
	  	}
	  	if(strLen > maxLen * 2){
	  		BC.showInnerTip("<%=SystemEnv.getHtmlLabelName(131682, user.getLanguage()) %> "+maxLen+" <%=SystemEnv.getHtmlLabelName(131676, user.getLanguage())+SystemEnv.getHtmlLabelName(594, user.getLanguage()) %>");
	  	}else{
	  		var left = Math.ceil(maxLen-strLen/2);
	  		BC.showInnerTip("<%=SystemEnv.getHtmlLabelName(131677, user.getLanguage()) %> " + left + " <%=SystemEnv.getHtmlLabelName(131676, user.getLanguage()) %>");
	  	}
	},
	showInnerTip: function(msg){
		var errorSpanObj = $('#bcSendForm .errorSpan');
		var timerId = null;
		window.clearTimeout(errorSpanObj.data("timerId"));
		errorSpanObj.text(msg);
		timerId = setTimeout(function(){
			errorSpanObj.text("");
		},5000);
		errorSpanObj.data("timerId", timerId);
	}
 };
 
 </script>