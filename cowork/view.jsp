<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.blog.BlogDao"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<html>
<head>
<link rel="stylesheet" href="/css/weaver_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<script type="text/javascript">var languageid=<%=user.getLanguage()%>;</script>
<script type="text/javascript" src="/weaverEditor/kindeditor_wev8.js"></script>
<script type="text/javascript" charset="utf-8" src="/weaverEditor/kindeditor-Lang_wev8.js"></script>

<style>
span{vertical-align:baseline}
.numitem{position:relative;width:40px;height:30px;cursor:pointer;}
.numdiv{position:absolute;left:0px;bottom:3px;color: #fff;width:40px;height:27px;line-height:27px;text-align: center;vertical-align:baseline;z-index:20}
.numa{position:absolute;left:0px;bottom:0px;width:40px;height:3px;z-index:5px;}
.numb{left:0px;bottom:0px;position:absolute;width:40px;height:0px;z-index:10}

.remarkdiv_show_b{border: 1px solid #dadada;border-top: 0px solid #dadada;}
#remarkdiv{background: #fff;font-size: 12px;vertical-align: middle;overflow: hidden;height: 0px;}

.remark_icon{float:left;background: url('/cowork/images/blue/down_wev8.png') no-repeat center;height:30px;width: 16px;cursor:pointer}

.discuss_item{margin-bottom:8px;}
.discuss_item .discuss{padding:5px;border: 1px solid #dadada;background: #fff;font-size: 12px;vertical-align: middle;}
.discuss .head{width:30px;float: left;position: absolute;}
.discuss .rightdiv{float: left;padding-left:8px;padding-left:40px;}
.discuss .content{color: #333;padding-top:8px;padding-bottom:8px}
.discuss .time{padding-left:8px;color: #929393}
.discuss .name{color: #929393}

.discuss_item .operations{padding-left: 5px;padding-top: 10px;padding-right: 5px;padding-bottom:5px;border: 1px solid #dadada;border-top: 0px solid #dadada;font-size: 12px;vertical-align: middle;background:#fff;}
.operations .item{padding-left:16px;color: #9e9e9e;cursor: pointer;}
.operations .comment{background-image:url('/cowork/images/icon/com_wev8.png');background-repeat: no-repeat;}
.operations .line{width: 1px;border-right:1px #a3bad1 solid;height: 11px;margin-left: 4px;margin-right: 4px;}
.operations .quote{background-image:url('/cowork/images/icon/quote_wev8.png');background-repeat: no-repeat;}
.operations .totop{background-image:url('/cowork/images/icon/top_wev8.png');background-repeat: no-repeat;}
.operations .favoriate{background-image:url('/cowork/images/icon/fav_wev8.png');background-repeat: no-repeat;}
.operations .del{background-image:url('/cowork/images/icon/del_wev8.png');background-repeat: no-repeat;}
.operations .top_n{background-image:url('/cowork/images/icon/top_n_wev8.png');background-repeat: no-repeat;}
.operations .approval{background-image:url('/cowork/images/icon/approval_wev8.png');background-repeat: no-repeat;}
.operations .edit{background-image:url('/cowork/images/icon/edit_wev8.png');background-repeat: no-repeat;}

.left{float:left}
.right{float:right}
.clear{clear:both}

.check_box{border: 1px solid #ccc;height:20px;width: 20px;padding:1px;}
.check_box:hover{  border: 2px solid #e4393c;height:20px;width:20px;}
.checkbox_selected{border: 2px solid #e4393c;height:20px;width:20px;}
.check_box .checkbox_check{display:none}

.checkbox_selected .checkbox_check{background: url('/cowork/images/blue/item_selected_wev8.gif');width: 10px;height: 10px;margin-top:10px;margin-left:10px;}

.btn_add_type,.btn_add_label{width: auto;line-height: 25px;cursor: pointer;font-family: 微软雅黑;padding-left:8px;padding-right:5px; }
.btn_add_type:hover{width: auto;background-color: #75B5DF;color: #FAFAFA;padding-left:8px; padding-right:5px;}
.choose_type{color:blue}
.drop_list{position: absolute;width: 100px;text-align:left;z-index: 999;top: 83px;left: 803px;
						background: #fff;border: 1px #CACACA solid;border-top: 0px;display: none;
						border-radius: 3px;-moz-border-radius: 3px;-webkit-border-radius: 3px;
    					behavior:url(/express/css/PIE2.htc);}
.cuttentTab{border: 1px #CACACA solid;border-bottom:0px;background: #fff;}    					

.nav{position:fixed;bottom:50px;right:10px;border:solid 1px #ccc;cursor:pointer;width:35px;z-index:100}
.nav .navitem{width: 35px;height: 35px;position: relative;}
.nav .navitemt{background:whiteSmoke url('/cowork/images/icon/totop_wev8.png') no-repeat center center;}
.nav .navitemd{background:whiteSmoke url('/cowork/images/icon/todown_wev8.png') no-repeat center center;border-top:1px solid rgb(245, 245, 245);}
.nav .navitem div{width:35px;height:35px;line-height: 35px;vertical-align:middle;text-align: center;z-index:10;position: absolute;background:#fff;display:none;}

</style>

<script>
	$(document).ready(function(){
	
		$(".check_box").bind("click",function(){
			if($(this).hasClass("check_box")){
			   $(this).removeClass("check_box").addClass("checkbox_selected");
			}else{
			   $(this).removeClass("checkbox_selected").addClass("check_box");
			}
		});
		
		$("#remark").bind("focus",function(){
		   $(this).html("");
		   $("#operationdiv").animate({height:30},200,null,function(){});
		   highEditor("remark");
		})
		
		$(document.body).bind("click",function(){
			//alert($("#remark").is(":hidden"));
			if($("#remark").is(":hidden")){
				//var remarkText=$.trim(removeHTMLTag(K.html("remark")));
				var remarkText=K.html("remark");
				if(remarkText==""){
					$("#operationdiv").animate({height:0},200,null,function(){});
					K.html("remark","<%=SystemEnv.getHtmlLabelName(83268,user.getLanguage())%>");
					K.g['remark'].sync();
					K.remove("#remark");
				}
			}
			
			hideTabMenu();	
		});
		
		$("#currentTab").hover(function(){
			showTabMenu();
		},function(){
			hideTabMenu();
		});
		
		$("#tabMenu").hover(function(){
			showTabMenu();
		},function(){
			hideTabMenu();
		});
		
		$(".numitem").hover(function(){
			$(this).find(".numdiv").css("color","#fff");
			$(this).find(".numb").animate({height:30},150);
		},function(){
			var color=$(this).attr("_color");
			$(this).find(".numdiv").css("color",color);
			$(this).find(".numb").animate({height:0},150);
		});
		
		$(".navitem").hover(function(){
			$(this).find("div").show();
		},function(){
			$(this).find("div").hide();
		}).bind("click",function(){
			if($(this).hasClass("navitemt")){
			    $('body,html').animate({scrollTop:0},200);
			}else{
				$('body,html').animate({scrollTop:$('#footer').offset().top},200);
			}
		});
		
	});
	
	function changeOrderType(obj){
		$(".tab_itemdiv").hide();
		$($(obj).attr("_target")).show();
		$("#currentTab div").html($(obj).html());
		$(".btn_add_type").show();
		$(obj).hide();
		hideTabMenu();
	}
	
	function showTabMenu(){
		$("#currentTab").addClass("cuttentTab").click();
	}
	
	function hideTabMenu(){
		$("#currentTab").removeClass("cuttentTab");
		$("#tabMenu").hide();
	}
	
	function showRemark(obj){
		var _status = $(obj).attr("_status");
		var _hh = $("#remarkContent").height()+16;
		if(_status==1){
			$("#remarkdiv").animate({height:0},300,null,function(){
				$(this).removeClass("remarkdiv_show_b")
			});
			$(obj).attr("_status",0).css("background-image","url('/cowork/images/blue/down_wev8.png')");
		}else{
			$("#remarkdiv").animate({height:_hh},300,null,function(){}).addClass("remarkdiv_show_b");
			$(obj).attr("_status",1).css("background-image","url('/cowork/images/blue/up_wev8.png')");
		}
	}
	
	/*高级编辑器*/
	function highEditor(remarkid){
	    if($("#"+remarkid).is(":visible")){
			
			var  items=[
							'source','justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist', 'insertunorderedlist', 
							'formatblock', 'fontname', 'fontsize',  'forecolor', 'bold','italic',  'strikethrough', 'table'
					   ];
				 
		    K.createEditor({
						id : remarkid,
						height : '80px',
						width:'100%',
						resizeType:1,
						imageUploadJson : '/weaverEditor/jsp/upload_json.jsp',
					    allowFileManager : false,
		                newlineTag:'br',
		                imageTabIndex:1,
		                filterMode:false,
		                items : items,
					    afterCreate : function(id) {
							//KE.util.focus(id);
							this.focus();
					    }
		   });
		}
 	}
 	
 	function removeHTMLTag(str) {
            str = str.replace(/<\/?[^>]*>/g,''); //去除HTML tag
            str = str.replace(/[ | ]*\n/g,'\n'); //去除行尾空白
            //str = str.replace(/\n[\s| | ]*\r/g,'\n'); //去除多余空行
            str=str.replace(/&nbsp;/ig,'');//去掉&nbsp;
            return str;
    }
    
    function showMenu(obj,target,e){
		$(".drop_list").hide();
		$("#"+target).css({
			"left":$(obj).position().left+"px",
			"top":($(obj).position().top+22)+"px"
		}).show();
		stopBubble(e);
	}
	
	//阻止事件冒泡函数
	 function stopBubble(e)
	 {
	     if (e && e.stopPropagation){
	         e.stopPropagation()
	     }else{
	         window.event.cancelBubble=true
	     }
	}
	
	function showExtend(obj){
		var _status = $(obj).attr("_status");
		if(_status==1){
			$("#extenddiv").animate({height:0},200,null,function(){});
			$(obj).attr("_status",0).css("background-image","url('/cowork/images/blue/down_wev8.png')");
		}else{
			$("#extenddiv").animate({height:$("#table1").height()},200,null,function(){});
			$(obj).attr("_status",1).css("background-image","url('/cowork/images/blue/up_wev8.png')");
		}
	}
	
</script>

</head>
<body style="background:rgb(249, 249, 249);">

<div class="nav"> 
	<div class="navitem navitemt">
		<div><%=SystemEnv.getHtmlLabelName(22432,user.getLanguage())%></div>
	</div>
	<div class="navitem navitemd">
		<div><%=SystemEnv.getHtmlLabelName(22433,user.getLanguage())%></div>
	</div>
</div>


<div style="padding-left: 5px;width:98%;padding-right:5px;padding-top:5px;position: relative;">

<div style="position:fixed;z-index: 1000;margin-right:9px;">

<div style="padding-left: 5px;border: 1px solid #dadada;background: #fff;font-size: 12px;">
	<div style="height:30px;line-height: 30px;float: left;vertical-align: middle;">
		<span><%=SystemEnv.getHtmlLabelName(83269,user.getLanguage())%></span>
	</div>
	
	<div onclick="showRemark(this)" class="remark_icon"></div>
	
	<div style="float:right;">
		<div class="left numitem" _color="#00CC00" title="评论我的26999">
			<div class="numdiv" style="color:#00CC00" class="numdiv">12</div>
			<div class="numa" style="background:#00CC00"></div>
			<div class="numb" style="background:#00CC00"></div>
		</div>
		<div class="left numitem" _color="#ff8d47" title="与我相关32572">
			<div class="numdiv" style="color:#ff8d47">25</div>
			<div class="numa" style="background:#ff8d47"></div>
			<div class="numb" style="background:#ff8d47"></div>
		</div>
		<div class="clear"></div>
	</div>
	<div style="clear: both;"></div>
	
</div>

<div id="remarkdiv" >
	<div id="remarkContent" style="padding:8px 5px 8px 5px;">	
		&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(83271,user.getLanguage())%>...
		<br />
		&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(83271,user.getLanguage())%>...
	</div>
</div>

<div style="padding:5px;border: 1px solid #dadada;border-top: 0px solid #dadada;background: #fff;font-size: 12px;vertical-align: middle;">
	
	<div>
		<textarea style="height:30px;width: 100%;color:#dadada;font-style:italic;overflow: hidden;border: 0px;" id="remark"><%=SystemEnv.getHtmlLabelName(83268,user.getLanguage())%></textarea>
	</div>
	
	<div id="operationdiv" style="overflow: hidden;height: 0px;">
		<div class="left">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(33848,user.getLanguage())%>" style="margin:5px 0 5px 0;" class="e8_btn" onclick="addLabel('add')" />
		</div>
		<div class="right">
			<div onclick="showExtend(this)" style="background:url('/cowork/images/blue/down_wev8.png') no-repeat right center;padding-right:14px;cursor: pointer;height:30px;line-height:30px;vertical-align: middle;"><%=SystemEnv.getHtmlLabelName(83273,user.getLanguage())%></div>
		</div>
	</div>	
	
	<div id="extenddiv" style="overflow: hidden;height: 0px;margin-top:5px;">
		<table class=ViewForm id="table1">
		   <TR style="height: 1px;"><TD class=Line colSpan=8></TD></TR>
           <tr>
               <!-- 相关文档 -->
               <td width="15%"><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
               <td width="85%" colspan="3" class=Field style="word-break:break-all">
                  <button type="button" class=browser onclick="onShowDoc('relateddoc','relateddocsspan')"></button>
               </td>
           </tr>
           <TR style="height: 1px;"><TD class=Line colSpan=8></TD></TR>
           <tr>
               <!-- 相关流程 -->
               <td width="15%"><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
               <td width="85%" colspan="3" class=Field style="word-break:break-all">
                  <button type="button" class=browser onclick="onShowRequest('relatedwf','relatedrequestspan')"></button>
               </td>
           </tr>
           <TR style="height: 1px;"><TD class=Line colSpan=8></TD></TR>
           <tr>
               <!-- 相关客户 -->
               <td><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></td>
               <td class=Field colspan="3" style="word-break:break-all">
                  <button type="button" class=browser onclick="onShowCRM('relatedcus','crmspan')"></button>
               </td>
           </tr>
           <TR style="height: 1px;"><TD class=Line colSpan=8></TD></TR>
           <tr>
               <!-- 相关项目 -->
               <td><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></td>
               <td class=Field colspan="3">
                  <BUTTON type="button" class="Browser" id="selectMultiProject" onclick="onShowMultiProjectCowork('projectIDs','mutilprojectSpan')"></BUTTON>
               </td>
           </tr>
           <TR style="height: 1px;"><TD class=Line colSpan=8></TD></TR>
           <tr>
               <!-- 相关项目任务 -->
               <td><%=SystemEnv.getHtmlLabelName(522,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1332,user.getLanguage())%></td>
               <td class=Field colspan="3" style="word-break:break-all;">
                  <button type="button" class=browser onclick="onShowTask('relatedprj','projectspan')"></button>
               </td>
           </tr>
       </table>   
	</div>
</div>

<div style="height:3px;background:rgb(249, 249, 249);"></div>

</div>

<div style="position: relative;top:80px;">

<div style="font-size: 12px;margin-top:4px;margin-bottom:4px;height: 26px;">
	
	<div class="left">
		<div id="currentTab" _currentTab="#exchange" onclick="showMenu(this,'tabMenu',event)" style="width:70px;margin-right: 5px;cursor: pointer;">
			<div style="padding:5px 5px 3px 8px;"><%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>15153</div>
		</div>
	</div>
	
	<div id="tabMenu" class="drop_list" style="width:70px;">
			<div class="btn_add_type" onclick="changeOrderType(this)" _target="#exchange" style="display: none;"><%=SystemEnv.getHtmlLabelName(15153,user.getLanguage())%></div><!-- 全部 -->
			<div class="btn_add_type" onclick="changeOrderType(this)" _target="#join"><%=SystemEnv.getHtmlLabelName(83274,user.getLanguage())%></div><!-- 全部 -->
		    <div class="btn_add_type" onclick="changeOrderType(this)" _target="#related"><%=SystemEnv.getHtmlLabelName(22672,user.getLanguage())%></div><!-- 全部 -->
	</div>
	
	
	<div class="right">
		<div style="margin-left:5px;" class="left" title="<%=SystemEnv.getHtmlLabelName(31507,user.getLanguage())%>">
			<div class="check_box" style="background:#fff url('/cowork/images/icon/reply_n_wev8.png') no-repeat center center;position: relative;">
				<div class="checkbox_check"></div>
			</div>
		</div>
		
		<div style="margin-left:5px;" class="left" title="<%=SystemEnv.getHtmlLabelName(83275,user.getLanguage())%>">
			<div class="check_box" style="background:#fff url('/cowork/images/icon/approval_p_wev8.png') no-repeat center center;">
				<div class="checkbox_check"></div>
			</div>
		</div>
		<div style="margin-left:5px;" class="left" title="<%=SystemEnv.getHtmlLabelName(81563,user.getLanguage())%>">
			<div class="check_box" style="background:#fff url('/cowork/images/icon/show_h_wev8.png') no-repeat center center;">
				<div class="checkbox_check"></div>
			</div>
		</div>
	</div>
	<div class="clear"></div>
</div>

<div id="exchange" class="tab_itemdiv">
	<div class="discuss_item">
		<div class="discuss">
			<div class="head">
				<img src="/cowork/images/50_wev8.jpg" width="30px"/>
			</div>
			<div class="rightdiv">
				<div>
					<div class="left">
						<span><a href="#" class="name">杨文元</a></span> <span class="time">19:02</span>
					</div>
					<div class="right">
						<span class="time">#1</span>
					</div>
					<div class="clear"></div>
				</div>
				
				<div class="content">
					有时候，我们实在想从这个纷繁世界逃离出去，丢掉手机，切断与世界的联系，逃到世界尽头那些僻静之地，感受舒缓的生活节奏，让阅读和放松成为生活的主题。尽管身不能行，我们依然可以从《赫芬顿邮报》的推荐中找找自己的向往之地，在心里保留一个不被打扰的空间。
				</div>
				
				<div class="operations" style="background-color: #fff;border:0px;" align="right">
					<a class="comment item">
						评论
					</a>
					<span class="line"></span>
					<a class="quote item">
						引用
					</a>
					<span class="line"></span>
					<a class="totop item">
						顶置
					</a>
					<span class="line"></span>
					<a class="del item">
						删除
					</a>
					<!--
					<span class="line"></span>
					<a class="edit item">
						编辑
					</a>
					<span class="line"></span>
					<a class="approval item">
						批准
					</a>
					<span class="line"></span>
					<a class="top_n item">
						取消顶置
					</a>
					 -->
				</div>
				
			</div>
			
			<div style="clear: left;"></div>
		</div>
	
	</div>
	
	<div class="discuss_item">
		<div class="discuss">
			<div class="head">
				<img src="/cowork/images/50_wev8.jpg" width="30px"/>
			</div>
			<div class="rightdiv">
				<div>
					<div class="left">
						<span><a href="#" class="name">杨文元</a></span> <span class="time">19:02</span>
					</div>
					<div class="right">
						<span class="time">#2</span>
					</div>
					<div class="clear"></div>
				</div>
				
				<div class="content">
					有时候，我们实在想从这个纷繁世界逃离出去，丢掉手机，切断与世界的联系，逃到世界尽头那些僻静之地，感受舒缓的生活节奏，让阅读和放松成为生活的主题。尽管身不能行，我们依然可以从《赫芬顿邮报》的推荐中找找自己的向往之地，在心里保留一个不被打扰的空间。
				</div>
				
				<div class="operations" style="background-color: #fff;border:0px;" align="right">
					<a class="comment item">
						评论
					</a>
					<span class="line"></span>
					<a class="quote item">
						引用
					</a>
					<span class="line"></span>
					<a class="totop item">
						顶置
					</a>
					<span class="line"></span>
					<a class="del item">
						删除
					</a>
					<!--
					<span class="line"></span>
					<a class="edit item">
						编辑
					</a>
					<span class="line"></span>
					<a class="approval item">
						批准
					</a>
					<span class="line"></span>
					<a class="top_n item">
						取消顶置
					</a>
					 -->
				</div>
				
			</div>
			
			<div style="clear: left;"></div>
		</div>
	
	</div>
	
	
	<div class="discuss_item">
		<div class="discuss">
			<div class="head">
				<img src="/cowork/images/50_wev8.jpg" width="30px"/>
			</div>
			<div class="rightdiv">
				<div>
					<div class="left">
						<span><a href="#" class="name">杨文元</a></span> <span class="time">19:02</span>
					</div>
					<div class="right">
						<span class="time">#3</span>
					</div>
					<div class="clear"></div>
				</div>
				
				<div class="content">
					有时候，我们实在想从这个纷繁世界逃离出去，丢掉手机，切断与世界的联系，逃到世界尽头那些僻静之地，感受舒缓的生活节奏，让阅读和放松成为生活的主题。尽管身不能行，我们依然可以从《赫芬顿邮报》的推荐中找找自己的向往之地，在心里保留一个不被打扰的空间。
				</div>
				
				<div class="operations" style="background-color: #fff;border:0px;" align="right">
					<a class="comment item">
						评论
					</a>
					<span class="line"></span>
					<a class="quote item">
						引用
					</a>
					<span class="line"></span>
					<a class="totop item">
						顶置
					</a>
					<span class="line"></span>
					<a class="del item">
						删除
					</a>
					<!--
					<span class="line"></span>
					<a class="edit item">
						编辑
					</a>
					<span class="line"></span>
					<a class="approval item">
						批准
					</a>
					<span class="line"></span>
					<a class="top_n item">
						取消顶置
					</a>
					 -->
				</div>
				
			</div>
			
			<div style="clear: left;"></div>
		</div>
	
	</div>
	
	<div class="discuss_item">
		<div class="discuss">
			<div class="head">
				<img src="/cowork/images/50_wev8.jpg" width="30px"/>
			</div>
			<div class="rightdiv">
				<div>
					<div class="left">
						<span><a href="#" class="name">杨文元</a></span> <span class="time">19:02</span>
					</div>
					<div class="right">
						<span class="time">#4</span>
					</div>
					<div class="clear"></div>
				</div>
				
				<div class="content">
					有时候，我们实在想从这个纷繁世界逃离出去，丢掉手机，切断与世界的联系，逃到世界尽头那些僻静之地，感受舒缓的生活节奏，让阅读和放松成为生活的主题。尽管身不能行，我们依然可以从《赫芬顿邮报》的推荐中找找自己的向往之地，在心里保留一个不被打扰的空间。
				</div>
				
				<div class="operations" style="background-color: #fff;border:0px;" align="right">
					<a class="comment item">
						评论
					</a>
					<span class="line"></span>
					<a class="quote item">
						引用
					</a>
					<span class="line"></span>
					<a class="totop item">
						顶置
					</a>
					<span class="line"></span>
					<a class="del item">
						删除
					</a>
					<!--
					<span class="line"></span>
					<a class="edit item">
						编辑
					</a>
					<span class="line"></span>
					<a class="approval item">
						批准
					</a>
					<span class="line"></span>
					<a class="top_n item">
						取消顶置
					</a>
					 -->
				</div>
				
			</div>
			
			<div style="clear: left;"></div>
		</div>
	
	</div>
</div>
</div>
<style>
.signalletter{
	height: 45px;
	line-height: 45px;
	font-size: 16px;
    font-weight: 200;;
	border-bottom: 2px solid #e2e2e2;
			 
}
.letterline{
   height:2px;
   width:70px;
   margin-top: -2px;
}
.itemdetail{
  height:32px;
  line-height:32px;
  width: 30%;
  margin-right: 3%;
  float: left;
}
.centerItem a{font-size:9pt;}
</style>

<div id="related" class="tab_itemdiv" style="display: none;padding-left: 5px;border: 1px solid #dadada;background: #fff;font-size: 12px;">
	<div class="lettercontainer">
	     <div class="C  signalletter" style="color: rgb(158, 23, 182);">相关流程</div>
	     	
		 <div class="letterline" style="background: rgb(158, 23, 182);"></div> 
		 
		 <div class="itemdetail">
			 <div class="centerItem" >
				 	<img name="esymbol" style="vertical-align: middle;" src="\images\ecology8\request\workflowTitle_wev8.png"/>
					<a style="color: grey; margin-right: 10px; margin-left: 8px; vertical-align: middle;" href="javascript:onNewRequest(187,0,0);"> 采购任务单-通用类 </a>
			 </div>
	      </div> 
			
		  <div class="itemdetail">
				<div class="centerItem" >
				 	<img name="esymbol" style="vertical-align: middle;" src="\images\ecology8\request\workflowTitle_wev8.png"/>
				 	<a style="color: grey; margin-right: 10px; margin-left: 8px; vertical-align: middle;" href="javascript:onNewRequest(256,0,0);">采购任务单通用类-测试 </a>
				</div>
	       </div> 
	       <div class="clear"></div>
	</div>

	<div class="lettercontainer">
	     <div class="C  signalletter" style="color:#166ca5;">相关文档</div>
	     	
		 <div class="letterline" style="background:#166ca5;"></div> 
		 
		 <div class="itemdetail">
			 <div class="centerItem" >
				 	<img name="esymbol" style="vertical-align: middle;" src="\images\ecology8\request\workflowTitle_wev8.png"/>
					<a style="color: grey; margin-right: 10px; margin-left: 8px; vertical-align: middle;" href="javascript:onNewRequest(187,0,0);"> 采购任务单-通用类 </a>
			 </div>
	      </div> 
			
		  <div class="itemdetail">
				<div class="centerItem" >
				 	<img name="esymbol" style="vertical-align: middle;" src="\images\ecology8\request\workflowTitle_wev8.png"/>
				 	<a style="color: grey; margin-right: 10px; margin-left: 8px; vertical-align: middle;" href="javascript:onNewRequest(256,0,0);">采购任务单通用类-测试 </a>
				</div>
	       </div> 
	       <div class="clear"></div>
	</div>
	
	<div class="lettercontainer">
	     <div class="C  signalletter" style="color:#953735;">相关客户</div>
	     	
		 <div class="letterline" style="background:#953735;"></div> 
		 
		 <div class="itemdetail">
			 <div class="centerItem" >
				 	<img name="esymbol" style="vertical-align: middle;" src="\images\ecology8\request\workflowTitle_wev8.png"/>
					<a style="color: grey; margin-right: 10px; margin-left: 8px; vertical-align: middle;" href="javascript:onNewRequest(187,0,0);"> 采购任务单-通用类 </a>
			 </div>
	      </div> 
			
		  <div class="itemdetail">
				<div class="centerItem" >
				 	<img name="esymbol" style="vertical-align: middle;" src="\images\ecology8\request\workflowTitle_wev8.png"/>
				 	<a style="color: grey; margin-right: 10px; margin-left: 8px; vertical-align: middle;" href="javascript:onNewRequest(256,0,0);">采购任务单通用类-测试 </a>
				</div>
	       </div> 
	       <div class="clear"></div>
	</div>
</div>

<div id="join" class="tab_itemdiv" style="display: none;padding-left: 5px;border: 1px solid #dadada;background: #fff;font-size: 12px;">
	<div class="lettercontainer">
	     <div class="C  signalletter" style="color: rgb(158, 23, 182);">参与条件</div>
	     	
		 <div class="letterline" style="background: rgb(158, 23, 182);"></div> 
		 
		 <div class="itemdetail">
			 <div class="centerItem" >
				 	<img name="esymbol" style="vertical-align: middle;" src="\images\ecology8\request\workflowTitle_wev8.png"/>
					<a style="color: grey; margin-right: 10px; margin-left: 8px; vertical-align: middle;" href="javascript:onNewRequest(187,0,0);"> 采购任务单-通用类 </a>
			 </div>
	      </div> 
			
		  <div class="itemdetail">
				<div class="centerItem" >
				 	<img name="esymbol" style="vertical-align: middle;" src="\images\ecology8\request\workflowTitle_wev8.png"/>
				 	<a style="color: grey; margin-right: 10px; margin-left: 8px; vertical-align: middle;" href="javascript:onNewRequest(256,0,0);">采购任务单通用类-测试 </a>
				</div>
	       </div> 
	       <div class="clear"></div>
	</div>

	<div class="lettercontainer">
	     <div class="C  signalletter" style="color:#166ca5;">参与人员</div>
	     	
		 <div class="letterline" style="background:#166ca5;"></div> 
		 
		 <div class="itemdetail">
			 <div class="centerItem" >
				 	<img name="esymbol" style="vertical-align: middle;" src="\images\ecology8\request\workflowTitle_wev8.png"/>
					<a style="color: grey; margin-right: 10px; margin-left: 8px; vertical-align: middle;" href="javascript:onNewRequest(187,0,0);"> 采购任务单-通用类 </a>
			 </div>
	      </div> 
			
		  <div class="itemdetail">
				<div class="centerItem" >
				 	<img name="esymbol" style="vertical-align: middle;" src="\images\ecology8\request\workflowTitle_wev8.png"/>
				 	<a style="color: grey; margin-right: 10px; margin-left: 8px; vertical-align: middle;" href="javascript:onNewRequest(256,0,0);">采购任务单通用类-测试 </a>
				</div>
	       </div> 
	       <div class="clear"></div>
	</div>
	
	<div class="lettercontainer">
	     <div class="C  signalletter" style="color:#953735;">未查看者</div>
	     	
		 <div class="letterline" style="background:#953735;"></div> 
		 
		 <div class="itemdetail">
			 <div class="centerItem" >
				 	<img name="esymbol" style="vertical-align: middle;" src="\images\ecology8\request\workflowTitle_wev8.png"/>
					<a style="color: grey; margin-right: 10px; margin-left: 8px; vertical-align: middle;" href="javascript:onNewRequest(187,0,0);"> 采购任务单-通用类 </a>
			 </div>
	      </div> 
			
		  <div class="itemdetail">
				<div class="centerItem" >
				 	<img name="esymbol" style="vertical-align: middle;" src="\images\ecology8\request\workflowTitle_wev8.png"/>
				 	<a style="color: grey; margin-right: 10px; margin-left: 8px; vertical-align: middle;" href="javascript:onNewRequest(256,0,0);">采购任务单通用类-测试 </a>
				</div>
	       </div> 
	       <div class="clear"></div>
	</div>
</div>


<br />
<br />
	 
</div>
<a id="footer" href="#"></a>
</body>
</html>