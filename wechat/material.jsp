<!DOCTYPE HTML>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.wechat.util.DateUtil"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<html>
<head>
<title><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(81634,user.getLanguage())%></title>

<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<link rel=stylesheet href="/css/Weaver_wev8.css" type="text/css" />
<LINK href="/wechat/css/material_wev8.css" type="text/css" rel="STYLESHEET">

<script type="text/javascript">var languageid=<%=user.getLanguage()%>;</script>
<script type="text/javascript" src="/wechat/kindeditor/kindeditor.js"></script>
<%
    if(user.getLanguage()==8){
%>
    <script type="text/javascript" src="/wechat/kindeditor/lang/en.js"></script>
<%
	}else if(user.getLanguage()==9){
%>
   <script type="text/javascript" src="/wechat/kindeditor/lang/zh_TW.js"></script>
<%
    }else{
%>
    <script type="text/javascript" src="/wechat/kindeditor/lang/zh_CN.js"></script>
<%
    }
%>	

<style>
.upload_area a{
	color: #000 !important;
}

.upload_area a:hover{
	color: #000 !important;
}
</style>


</head>
<body>
<%
String userid = "" + user.getUID();
String newsId=Util.null2String(request.getParameter("newsid"));
String remark="";
String newsType=Util.null2String(request.getParameter("newstype"));
String from=Util.null2String(request.getParameter("from"));

int limitSize=8;//新建图文的最大条数

int addSize=1;//目前最大编号 dsporder
int itemSize=1;//总数

String msg_title="";
String msg_picUrl="";
String msg_summary="";
String msg_url="";


if(!"".equals(newsId)){
	rs.execute("select * from wechat_news where createrid="+userid+" and id="+newsId);
	if(!rs.next()){
%>		
		<script>
			alert("<%=SystemEnv.getHtmlLabelName(561,user.getLanguage())+SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>");
			location.href="/wechat/materialList.jsp";
		</script>

<%		return;
	}else{
		remark=rs.getString("name");
		newsType=rs.getString("newstype");
		//哪些记录条数
		rs.execute("select dspOrder,title,picUrl,summary,url from wechat_news_material where newsid="+newsId+" order by dsporder asc");
		itemSize=rs.getCounts();
		if(rs.next()){
			addSize=rs.getInt("dspOrder");//应该来说第一条 是1
			msg_title=Util.null2String(rs.getString("title"));
			msg_picUrl=Util.null2String(rs.getString("picUrl"));
			msg_summary=Util.null2String(rs.getString("summary"));
			msg_url=Util.null2String(rs.getString("url"));
		}
	}
}else{
	//新建一条图文信息
	String time=DateUtil.getCurrentTime(null);
	rs.execute("insert into wechat_news(createrid,newstype,createtime,updatetime) values("+userid+",'"+newsType+"','"+time+"','"+time+"')");
	rs.execute("select id from wechat_news where createrid="+userid+" and newsType='"+newsType+"' and createtime='"+time+"'");
	if(rs.next()){
		newsId=rs.getString("id");
	}
	rs.execute("select * from wechat_news_material where 1=2 ");
}

if("".equals(newsId)){
%>
		<script>
			alert("<%=SystemEnv.getHtmlLabelName(561,user.getLanguage())+SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>");
			location.href="/wechat/materialList.jsp";
		</script>

<%
}


String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(81634,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<div class="main_hd">
	<div style="margin: 20px;">
	<%=SystemEnv.getHtmlLabelName(454, user.getLanguage())%>：<input id="remark" name="remark" value="<%=remark%>" type="text" style="width:60%">
	</div>
</div>
<div class="main_bd" style="margin:10px;">    
	<div class="media_preview_area">
		<%if("1".equals(newsType)){%>
			<div class="appmsg editing">            
				<div id="js_appmsg_preview" class="appmsg_content">                                            
					<div id="appmsgItem1" data-fileid="<%=newsId%>" data-id="1" class="js_appmsg_item  <%=(!"".equals(msg_picUrl))?"has_thumb":""%>">
							<h4 class="appmsg_title">
								<a onclick="return false;" href="javascript:void(0);" target="_blank"><%="".equals(msg_title)?SystemEnv.getHtmlLabelName(229, user.getLanguage()):msg_title%></a>
							</h4>
							<div class="appmsg_info">
								<em class="appmsg_date"></em>
							</div>
							<div class="appmsg_thumb_wrp ">
								<img class="js_appmsg_thumb appmsg_thumb" src="<%=msg_picUrl%>">
								<i class="appmsg_thumb default"><%=SystemEnv.getHtmlLabelName(81643, user.getLanguage())%></i>
							</div>
							<p class="appmsg_desc"><%=msg_summary%></p>
					</div>
				</div>                    
			</div> 

		<%}else{%>
			<div class="appmsg multi editing">
				<div id="js_appmsg_preview" class="appmsg_content">
					<div id="appmsgItem1" data-fileid="<%=newsId%>" data-id="1" class="js_appmsg_item <%=(!"".equals(msg_picUrl))?"has_thumb":""%>">
						<div class="appmsg_info">
							<em class="appmsg_date"></em>
						</div>
						<div class="cover_appmsg_item">
							<h4 class="appmsg_title">
								<a href="javascript:void(0);" onclick="return false;" target="_blank"><%="".equals(msg_title)?SystemEnv.getHtmlLabelName(229, user.getLanguage()):msg_title%></a>
							</h4>
							<div class="appmsg_thumb_wrp">
								<img class="js_appmsg_thumb appmsg_thumb" src="<%=msg_picUrl%>">
								<i class="appmsg_thumb default"><%=SystemEnv.getHtmlLabelName(81643, user.getLanguage())%></i>
							</div>
							<div class="appmsg_edit_mask">
								<a onclick="return false;" class="icon18_common edit_gray js_edit" data-id="1" href="javascript:void(0);" ><%=SystemEnv.getHtmlLabelName(93, user.getLanguage())%></a>
							</div>
						</div>
    
					</div>
					<%
					while(rs.next()){
						addSize=rs.getInt("dspOrder");
						String temp_title=Util.null2String(rs.getString("title"));
						String temp_pic=Util.null2String(rs.getString("picUrl"));
					%>
						<div id="appmsgItem<%=addSize%>" data-fileid="<%=newsId%>" data-id="<%=addSize%>" class="appmsg_item js_appmsg_item <%=(!"".equals(temp_pic))?"has_thumb":""%>">
							<img class="js_appmsg_thumb appmsg_thumb" src="<%=temp_pic%>">
							<i class="appmsg_thumb default"><%=SystemEnv.getHtmlLabelName(19064, user.getLanguage())%></i>
							<h4 class="appmsg_title">
								<a onclick="return false;" href="javascript:void(0);" target="_blank"><%="".equals(temp_title)?SystemEnv.getHtmlLabelName(229, user.getLanguage()):temp_title%></a>
							</h4>
							<div class="appmsg_edit_mask">
								<a class="icon18_common edit_gray js_edit" data-id="<%=addSize%>" onclick="return false;" href="javascript:void(0);"><%=SystemEnv.getHtmlLabelName(93, user.getLanguage())%></a>
								<a class="icon18_common del_gray js_del" data-id="<%=addSize%>" onclick="return false;" href="javascript:void(0);"><%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></a>
							</div>
						</div>
					
					<%}	
					%>
				</div>
                        
				<a onclick="return false;" class="create_access_primary appmsg_add" id="js_add_appmsg" href="javascript:void(0);">
					<i class="icon20_common add_gray">增加一条</i>
                </a>
            </div>		
		<%}%>
	</div>    
	<div class="media_edit_area">        
		<div id="js_appmsg_editor">
			<div class="appmsg_editor" style="margin-top: 0px;">
				<div class="inner">
					<div class="appmsg_edit_item">
						<label for="" class="frm_label">
							<strong class="title"><%=SystemEnv.getHtmlLabelName(229, user.getLanguage())%></strong>
							<p class="js_cover_tip tips" style="display: none;">（标题不能为空且长度不能超过64字）</p>
						</label>
						<span class="frm_input_box">
						<input id="msg_title" style="width:100%" type="text" class="frm_input js_title" onkeyup="show(this,'appmsg_title')" onchange="show(this,'appmsg_title')" value="<%=msg_title%>">
						</span>
					</div>
					<div class="appmsg_edit_item">
						<label for="" class="frm_label">
							<strong class="title"><%=SystemEnv.getHtmlLabelName(30601, user.getLanguage())%></strong>
							<p class="js_cover_tip tips js_cover_tip_pic">（大图片建议尺寸：900像素 * 500像素）</p>
							<p class="js_cover_tip tips js_cover_tip_pic">（小图片建议尺寸：200像素 * 200像素）</p>
						</label>
						<div class="upload_wrap">
							<span id="js_appmsg_upload_cover" class="btn btn_input btn_default"><button><%=SystemEnv.getHtmlLabelName(74, user.getLanguage())%></button></span>
							<input type="hidden" name="imgUrl" id="imgUrl" value="<%=msg_picUrl%>">
							<p class="js_cover upload_preview" style="display:<%="".equals(msg_picUrl)?"none":""%>">
								<img id="upload_preview_img" src="<%=msg_picUrl%>">
								<a class="js_removeCover" href="javascript:void(0);" onclick="return false;"><%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></a>
							</p>
						</div>
					</div>
					
					<div class="js_desc_area dn appmsg_edit_item" style="display:<%="1".equals(newsType)?"block":"none"%>">
						<label for="" class="frm_label"><%=SystemEnv.getHtmlLabelName(341, user.getLanguage())%></label>
						<span class="frm_textarea_box">
						<textarea id="msg_summary" style="width:100%" class="js_desc frm_textarea" rowspan="5" onkeyup="show(this,'appmsg_desc')" onchange="show(this,'appmsg_desc')" value="<%=msg_summary%>"><%=msg_summary%></textarea>
						</span>
					</div>
					<div id="js_ueditor" class="appmsg_edit_item content_edit">
						<label for="" class="frm_label">
							<strong class="title"><%=SystemEnv.getHtmlLabelName(1265, user.getLanguage())%></strong>
						</label>
						<div id="js_editor" class="edui_editor_wrp edui-default"> 
							<textarea id="submitText" name="submitText" scroll="none" style="border: solid 1px;"></textarea>
						</div>
					</div>
					<p><a class="js_addURL" href="javascript:void(0);" onclick="return false;"><%=SystemEnv.getHtmlLabelName(81644, user.getLanguage())%></a></p>
					<div class="js_url_area dn appmsg_edit_item" style="display: none;">
						<label for="" class="frm_label"><%=SystemEnv.getHtmlLabelName(81644, user.getLanguage())%></label>
						<span class="frm_input_box">
						<input id="msg_url" style="width:100%" type="text" class="js_url frm_input" value="<%=msg_url%>">
						</span>
						<div class="frm_msg fail js_url_error" style="display:none;color:red">链接不合法(http:// 或 https:// 开头)</div>
					</div>
				</div>
				<i class="arrow arrow_out" style="margin-top: 0px;"></i>
				<i class="arrow arrow_in" style="margin-top: 0px;"></i>
			</div>
			
		</div>
	</div>
	<div class="tool_area">        
		<div class="tool_bar border tc" style="text-align: center">           
			<span id="js_submit" class="btn btn_input btn_primary"><button type="button"><%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%></button></span>            
			<span id="js_preview" class="btn btn_input btn_default"><button type="button"><%=SystemEnv.getHtmlLabelName(221, user.getLanguage())%></button></span>
			<%if(!"1".equals(from)){%><span id="js_back" class="btn btn_input btn_default"><button type="button"><%=SystemEnv.getHtmlLabelName(1290, user.getLanguage())%></button></span><%}%>
		</div>    
	</div>
</div>
</body>
</html>
<script>
	var current_id=1;
	var itemSize="<%=itemSize%>";
	var addSize="<%=addSize%>";
 window.onbeforeunload = onbeforeunload_handler;
 function onbeforeunload_handler(){ 
	//保存数据
	saveDataAndRemark(true);
	var w="<%=SystemEnv.getHtmlLabelName(81645, user.getLanguage())%>";
	
	var warning=w.replace("{1}",(new Date()).Format("yyyy-MM-dd hh:mm:ss"));       
	return warning; 
}   

//添加一则图文消息
function addItem(){
	addSize++;
	var html='<div id="appmsgItem'+addSize+'" data-fileid="<%=newsId%>" data-id="'+addSize+'" class="appmsg_item js_appmsg_item">'+
				'<img class="js_appmsg_thumb appmsg_thumb" src=>'+
				'<i class="appmsg_thumb default"><%=SystemEnv.getHtmlLabelName(19064, user.getLanguage())%></i>'+
				'<h4 class="appmsg_title"><a onclick="return false;" href="javascript:void(0);" target="_blank"><%=SystemEnv.getHtmlLabelName(229, user.getLanguage())%></a></h4>'+
				'<div class="appmsg_edit_mask">'+
					'<a class="icon18_common edit_gray js_edit" data-id="'+addSize+'" onclick="return false;" href="javascript:void(0);"><%=SystemEnv.getHtmlLabelName(93, user.getLanguage())%></a>'+
					'<a class="icon18_common del_gray js_del" data-id="'+addSize+'" onclick="return false;" href="javascript:void(0);"><%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></a>'+
				'</div>'+
			'</div>';

	var objs=$('#js_appmsg_preview').children();
	$($(objs)[objs.length-1]).after(html);
	//绑定事件
	bandEditDelEvent();

}
//保存数据和备注
function saveDataAndRemark(autoSave){
	editor1.sync();
	var remark=$('#remark').val();
	if(remark==""){
		$('#remark').val($($('#appmsgItem1').find('.appmsg_title')[0]).children("a").html());
	}
	remark=$('#remark').val();
	
	$.post("materialOperate.jsp", 
    {"operate":"add","newsId":"<%=newsId%>","userId":"<%=userid%>","dsporder":current_id,
		"title":encodeURIComponent($('#msg_title').val()),"picUrl":$('#imgUrl').val(),
		"summary":encodeURIComponent($('#msg_summary').val()),"url":$('#msg_url').val(),
		"content":encodeURIComponent($('#submitText').val()),"remark":encodeURIComponent(remark),"all":autoSave},
  	function(data){
  		 //主动保存不提示离开
		 if(!autoSave){
			window.onbeforeunload=null;
			if("<%=from%>"=="1"){
				window.close();
			}else{
				location.href="/wechat/materialList.jsp";
			}
			
		 }
 	});
}

//保存数据 和后续操作
function saveData(id,type){
	//同步编辑器内容
	editor1.sync();
	$.post("materialOperate.jsp", 
    {"operate":"add","newsId":"<%=newsId%>","userId":"<%=userid%>","dsporder":id,
		"title":encodeURIComponent($('#msg_title').val()),"picUrl":$('#imgUrl').val(),
		"summary":encodeURIComponent($('#msg_summary').val()),"url":$('#msg_url').val(),
		"content":encodeURIComponent($('#submitText').val())},
  	function(data){
		 var data=data.replace(/[\r\n]/g,"").replace(/[ ]/g,"");
		 if(type=="preview"){
			 openNewsPreview('/wechat/materialView.jsp?newsid=<%=newsId%>');
		 }
 	});
}
//读取数据
function readData(id){
	$.post("materialOperate.jsp", 
    {"operate":"query","newsId":"<%=newsId%>","userId":"<%=userid%>","dsporder":id},
  	function(data){
		//var data=data.replace(/[\r\n]/g,"").replace(/[ ]/g,"");
		var jsonData=eval('('+data+')');
		//处理标题
		$('#msg_title').val(jsonData.title);
		//处理摘要
		$('#msg_summary').val(jsonData.summary);
		//处理正文
		//$('#submitText').val(jsonData.content);
		//同步编辑器
		editor1.html(jsonData.content);
		editor1.sync();

		//处理原文链接
		$('#msg_url').val(jsonData.url);
		showUrl();

		//处理封面图片
		$('#imgUrl').val(jsonData.picUrl);
		if($('#imgUrl').val()==''){
			$('.js_removeCover').parent().hide()
		}else{
			//更换图片显示
			$('#upload_preview_img').attr("src",jsonData.picUrl);
			$('.js_removeCover').parent().show()
		}
 	});
}
//删除数据
function delData(id){
	$.post("materialOperate.jsp", 
    {"operate":"del","newsId":"<%=newsId%>","userId":"<%=userid%>","dsporder":id},
  	function(data){
  		 
 	});
}

//编辑
function editGray(obj){
	//点击是本身，忽略操作
	if($(obj).data("id")==current_id){
		return;
	}
	saveData(current_id,"edit");

	current_id=$(obj).data("id");
	obj=$('#appmsgItem'+current_id);
	var top=$('#appmsgItem'+current_id).position().top;
	if(top>500){
		$('.arrow').css("margin-top",500);
		$('.appmsg_editor').css("margin-top",top-500);
	}else{
		$('.arrow').css("margin-top",0);
		$('.appmsg_editor').css("margin-top",$('#appmsgItem'+current_id).position().top);
	}
	showOrDispay();
	readData(current_id);
}

//删除
function delGray(obj){
	itemSize=$('.js_appmsg_item').length;
	var minSize=1;
	if(itemSize>minSize){
		var id=$(obj).data("id");

		if($($('#appmsgItem'+id).find('.appmsg_title')[0]).children("a").html()=="<%=SystemEnv.getHtmlLabelName(229, user.getLanguage())%>"){
				delData(id);
				if(id==current_id){
					current_id=1;
					readData(current_id);
				}
				
				$('#appmsgItem'+$(obj).data("id")).remove();

				var top=$('#appmsgItem'+current_id).position().top;
				if(top>500){
					$('.arrow').css("margin-top",500);
					$('.appmsg_editor').css("margin-top",top-500);
				}else{
					$('.arrow').css("margin-top",0);
					$('.appmsg_editor').css("margin-top",$('#appmsgItem'+current_id).position().top);
				}
		}else{
			if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){//确定要删除么
				delData(id);
				if(id==current_id){
					current_id=1;
					readData(current_id);
				}
				
				$('#appmsgItem'+$(obj).data("id")).remove();

				var top=$('#appmsgItem'+current_id).position().top;
				if(top>500){
					$('.arrow').css("margin-top",500);
					$('.appmsg_editor').css("margin-top",top-500);
				}else{
					$('.arrow').css("margin-top",0);
					$('.appmsg_editor').css("margin-top",$('#appmsgItem'+current_id).position().top);
				}
			}
		}

				
	}else{
		alert("多图文至少需要"+minSize+"条消息");
	}
	showOrDispay();
}
//隐藏和显示 封面提示
function showOrDispay(){
	$('.js_cover_tip_pic').hide();
	if(current_id==1){
		$($('.js_cover_tip_pic')[0]).show();
	}else{
		$($('.js_cover_tip_pic')[1]).show();
	}
}
var  editor1;
//初始化
jQuery(function(){
		
	showOrDispay();

	var items = [
			'source','fullscreen', 'preview', '|', 'undo', 'redo', '|',  'template', 'cut', 'copy', 'paste',
			'plainpaste', 'wordpaste', '|', 'justifyleft', 'justifycenter', 'justifyright',
			'justifyfull', '|', 'insertorderedlist', 'insertunorderedlist', 'indent', 'outdent', 'subscript',
			'superscript',  '/',
			'formatblock', 'fontname', 'fontsize', '|', 'forecolor', 'hilitecolor', 'bold',
			'italic', 'underline', 'strikethrough', 'lineheight', 'removeformat', '|', 'image', 'multiimage',
		    'table', 'hr', 'emoticons', 'baidumap', , 'link', 'unlink'
		];
	var  items1=[
				'source','justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist', 'insertunorderedlist', 
				'title', 'fontname', 'fontsize',  'textcolor', 'bold','italic',  'strikethrough', 'image', 'advtable','remote_image'
		   ];

	KindEditor.ready(function(K) {
		//编辑器
		editor1 = K.create('#submitText', {
			uploadJson : '/kindeditor/jsp/upload_json.jsp',
			allowFileManager : false,
			height :'400px',
			width:'100%',
			resizeMode:1,
			items:items,
			newlineTag:'br',
			afterCreate : function() {
				this.sync();
			}
		});
		//读取第一条数据
		readData(1);

		//独立图片上传
		var editor = K.editor({
			uploadJson : '/kindeditor/jsp/upload_json.jsp',
			allowFileManager : false
		});
		K('#js_appmsg_upload_cover').click(function() {
				editor.loadPlugin('image', function() {
					editor.plugin.imageDialog({
						imageUrl : K('#imgUrl').val(),
						clickFn : function(url, title, width, height, border, align) {
							K('#imgUrl').val(url);
							//显示上传附件
							$('#upload_preview_img').parent().show();
							$('#upload_preview_img').attr("src",url);
							//展示左侧预览效果
							if(!$('#appmsgItem'+current_id).hasClass("has_thumb")){
								$('#appmsgItem'+current_id).addClass("has_thumb");
							}
							$('#appmsgItem'+current_id).find("img.appmsg_thumb").attr("src",url);
							editor.hideDialog();
						}
					});
				});
			});


		});
	

	//删除图片
	$('.js_removeCover').click(function(){
		$(this).parent().hide();
		$('#imgUrl').val("");
		$('#appmsgItem'+current_id).removeClass("has_thumb");
	});
	//添加新闻外链
	$('.js_addURL').click(function(){ 
		$(this).hide();
		$('.js_url_area').show();
	
	});
	 
	//新增
	$('#js_add_appmsg').click(function(){ 
		itemSize=$('.js_appmsg_item').length;
		if(itemSize<"<%=limitSize%>"){
			if($('.js_appmsg_item').length<10){
				addItem();
			}
		}else{
			var w="<%=SystemEnv.getHtmlLabelName(81646, user.getLanguage())%>";
			var warning=w.replace("{param}","<%=limitSize%>");
			alert(warning);
		}
	});

	//返回
	$('#js_back').click(function(){ 
		 location.href="/wechat/materialList.jsp";
	});
	//保存离开
	$('#js_submit').click(function(){ 
		saveDataAndRemark(false);
	});
	//预览
	$('#js_preview').click(function(){ 
		 saveData(current_id,"preview");
	});
	//
	showUrl();
	bandEditDelEvent();
});

function bandEditDelEvent(){
	$('.edit_gray').unbind('click').click(function(){ 
		editGray(this);
	});
	$('.del_gray').unbind('click').click(function(){ 
		delGray(this);
	});
}
 

function showUrl(){
	if($('#msg_url').val()==''){
		$('.js_addURL').show();
		$('.js_url_area').hide();
	}else{
		$('.js_addURL').hide();
		$('.js_url_area').show();
	}
}
//展示标题 或 摘要
function show(obj,target){
	if(target=='appmsg_title'){
		if($(obj).val()==''){
			$($('#appmsgItem'+current_id).find('.'+target)[0]).children("a").html('<%=SystemEnv.getHtmlLabelName(229, user.getLanguage())%>');
		}else{
			$($('#appmsgItem'+current_id).find('.'+target)[0]).children("a").html($(obj).val());
		}
		
	}else if(target='appmsg_desc'){
		$($('#appmsgItem'+current_id).find('.'+target)[0]).html($(obj).val());
	}
}

 function isURL(obj) {
		var strRegex = "^((https|http|ftp|rtsp|mms)://)";
		var re = new RegExp(strRegex);
		if (re.test($(obj).val())) {
			$('.js_url_error').hide();
			return true;
		} else {
			$('.js_url_error').show();
			return false;
		}
	}

// 对Date的扩展，将 Date 转化为指定格式的String 
// 月(M)、日(d)、小时(h)、分(m)、秒(s)、季度(q) 可以用 1-2 个占位符， 
// 年(y)可以用 1-4 个占位符，毫秒(S)只能用 1 个占位符(是 1-3 位的数字) 
// 例子： 
// (new Date()).Format("yyyy-MM-dd hh:mm:ss.S") ==> 2006-07-02 08:09:04.423 
// (new Date()).Format("yyyy-M-d h:m:s.S")      ==> 2006-7-2 8:9:4.18 
Date.prototype.Format = function(fmt) 
{ //author: meizz 
  var o = { 
    "M+" : this.getMonth()+1,                 //月份 
    "d+" : this.getDate(),                    //日 
    "h+" : this.getHours(),                   //小时 
    "m+" : this.getMinutes(),                 //分 
    "s+" : this.getSeconds(),                 //秒 
    "q+" : Math.floor((this.getMonth()+3)/3), //季度 
    "S"  : this.getMilliseconds()             //毫秒 
  }; 
  if(/(y+)/.test(fmt)) 
    fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length)); 
  for(var k in o) 
    if(new RegExp("("+ k +")").test(fmt)) 
  fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length))); 
  return fmt; 
}

</script>
<SCRIPT language="javascript" defer="defer" src="/wechat/js/wechatNews_wev8.js"></script>