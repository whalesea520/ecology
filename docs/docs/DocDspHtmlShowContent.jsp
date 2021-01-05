<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%User user = HrmUserVarify.getUser (request , response) ;
String doccontentbackgroud=Util.null2String(request.getParameter("doccontentbackgroud"));%>
<html>
	<head>
		<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
		<script language="javascript" type="text/javascript" src="/js/init_wev8.js"></script>
		<script language="javascript" type="text/javascript" src="/FCKEditor/swfobject_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js"></script>
		<link rel="stylesheet" type="text/css" href="/ueditor/themes/iframe_wev8.css">
		<style type='text/css'>
			body{margin:0 auto;}
			body,td{font-size:12px;font-family:微软雅黑;}
			#message_table td,td{
				border:none;
			}

			#message_table  td{
				border:none;
			}
			#message_table  td a{
				border:none;
			}

			#message_table  td img{
				border:none;
			}

			a{color:blue;text-decoration:none;}
			a:hover{color:#018efb;}

			 #content table{margin-bottom:10px;border-collapse:collapse;display:table;}
            #content .selectTdClass{background-color:#edf5fa !important}
             #content table.noBorderTable td,
			 #content table.noBorderTable th,
			 #content table.noBorderTable caption{border:1px dashed #ddd !important}
            
             #content caption{border:1px dashed #DDD;border-bottom:0;padding:3px;text-align:center;}
             #content th{border-top:1px solid #BBB;background-color:#F7F7F7;}
             #content table tr.firstRow th{border-top-width:2px;}
             #content .ue-table-interlace-color-single{ background-color: #fcfcfc; } 
			 #content .ue-table-interlace-color-double{ background-color: #f7faff; }
              #content td p{margin:0;padding:0;}

			  #content .loadingclass{display:inline-block;cursor:default;background: url(/ueditor/themes/default/images/loading_wev8.gif) no-repeat center center transparent;border:1px solid #cccccc;margin-left:1px;height: 22px;width: 22px;}
              #content .loaderrorclass{display:inline-block;cursor:default;background: url(/ueditor/themes/default/images/loaderror_wev8.png) no-repeat center center transparent;border:1px solid #cccccc;margin-right:1px;height: 22px;width: 22px;}

			  #content pre{margin:.5em 0;padding:.4em .6em;border-radius:8px;background:#f8f8f8;}

			  #content .anchorclass{background: url(/ueditor/themes/default/images/anchor_wev8.gif) no-repeat scroll left center transparent;cursor: auto;display: inline-block;height: 16px;width: 15px;}

			  #content .pagebreak{display:block;clear:both !important;cursor:default !important;width: 100% !important;margin:0;}

			  #content .edui-editor-imagescale{display:none;position:absolute;border:1px solid #38B2CE;cursor:hand;-webkit-box-sizing: content-box;-moz-box-sizing: content-box;box-sizing: content-box;}
              #content .edui-editor-imagescale span{position:absolute;width:6px;height:6px;overflow:hidden;font-size:0px;display:block;background-color:#3C9DD0;}
              #content .edui-editor-imagescale .edui-editor-imagescale-hand0{cursor:nw-resize;top:0;margin-top:-4px;left:0;margin-left:-4px;}
               #content .edui-editor-imagescale .edui-editor-imagescale-hand1{cursor:n-resize;top:0;margin-top:-4px;left:50%;margin-left:-4px;}
                #content .edui-editor-imagescale .edui-editor-imagescale-hand2{cursor:ne-resize;top:0;margin-top:-4px;left:100%;margin-left:-3px;}
               #content .edui-editor-imagescale .edui-editor-imagescale-hand3{cursor:w-resize;top:50%;margin-top:-4px;left:0;margin-left:-4px;}'
                #content .edui-editor-imagescale .edui-editor-imagescale-hand4{cursor:e-resize;top:50%;margin-top:-4px;left:100%;margin-left:-3px;}
               #content .edui-editor-imagescale .edui-editor-imagescale-hand5{cursor:sw-resize;top:100%;margin-top:-3px;left:0;margin-left:-4px;}
             #content  .edui-editor-imagescale .edui-editor-imagescale-hand6{cursor:s-resize;top:100%;margin-top:-3px;left:50%;margin-left:-4px;}
               #content .edui-editor-imagescale .edui-editor-imagescale-hand7{cursor:se-resize;top:100%;margin-top:-3px;left:100%;margin-left:-3px;}

			  #content .view{padding:0;word-wrap:break-word;cursor:text;height:90%;}body{margin:8px;font-family:sans-serif;font-size:12px;}p{margin:5px 0;}
			  img{
				max-width:1024px!important;
			  }
			  
			  #content img{
				  cursor:pointer;
			  }
			 #content{word-break: break-all;}
			  
		</style>
		<script type="text/javascript">
			var mouldImgs = [];
			parent.parent.jQuery("#mouldhtml img").each(function(){
				mouldImgs.push(jQuery(this).attr("src"));	
			});
			
		
			jQuery(document).ready(function(){
				//不修改人力资源链接的target属性
				jQuery("a").each(function(){
					var _this=jQuery(this);
					var href=_this.attr("href").toLowerCase();
					if(-1==href.indexOf("javascript:openhrm("))
					{
						_this.attr("target","_blank");
					}
					if(href.indexOf("openfullwindowforxtable(")>0)
					{
						_this.attr("target","_self");
					}
					if(href.indexOf("#")==0)
					{
						_this.attr("target","_self");
					}
				});
				var _style = jQuery("p[data-background]").attr("data-background");
				_style="<%=doccontentbackgroud%>"
				//_style=_style.replace(/background-repeat: no-repeat;/g,"");
				
				if(_style){
					var _style2 = jQuery("body").attr("style");
					if(_style2 && _style2.length > 0){
						_style2 = /;$/.test(_style2) ? _style2 : (_style2 + ";")
					}else{
						_style2 = "";
					}
					jQuery("body").attr("style",_style2 + _style);
				}
			});

				//打开应用连接
			function openAppLink(obj,linkid){

				var linkType=jQuery(obj).attr("linkType");
				if(linkType=="doc")
					window.open("/docs/docs/DocDsp.jsp?id="+linkid);
				else if(linkType=="task")
					window.open("/proj/process/ViewTask.jsp?taskrecordid="+linkid);
				else if(linkType=="crm")
					window.open("/CRM/data/ViewCustomer.jsp?CustomerID="+linkid);
				else if(linkType=="workflow")
					window.open("/workflow/request/ViewRequest.jsp?requestid="+linkid);
				else if(linkType=="project")
					window.open("/proj/data/ViewProject.jsp?ProjID="+linkid);
				else if(linkType=="workplan")
					window.open("/workplan/data/WorkPlanDetail.jsp?workid="+linkid);
				return false;
			}
			
			jQuery(function(){
				jQuery("#content img").live({
					click : function(){
						var _src = jQuery(this).attr("src");
						for(var i = 0 ;i < mouldImgs.length;i++){
							if(_src == mouldImgs[i]) return;
						}	
						playImgs(this);
					}
				});
			})
			
			function playImgs(e){
				var imgPool=new Array()
				var indexNum = 0;
				var imgs = $("#content img");
				imgs.each(function(){
					var _src = jQuery(this).attr("src");
					for(var i = 0 ;i < mouldImgs.length;i++){
						if(_src == mouldImgs[i]){
							_src = "";
							break;
						}
					}
					if(_src != ""){
						imgPool.push(_src);
					}
				});
				for(var i = 0; i < imgPool.length ; i ++){
					if($(e).attr('src') == imgPool[i]){
						break;
					}
					else{
						indexNum++;
					}
				}
				parent.parent.IMCarousel.showImgScanner4Pool(true, imgPool, indexNum, null, window.top);
			}
		</script>
	</head>
	<body>
		
		<%@ include file="/hrm/resource/simpleHrmResource_wev8.jsp" %>
		<div id="content">
			<%
				
				int docid=Util.getIntValue(request.getParameter("docid"),0);
				if(docid!=0) {
					String str=(String)session.getAttribute("html_"+docid);
					out.println(str);
					int htmlcounter=Util.getIntValue((String)session.getAttribute("htmlcounter_"+docid),-1);
					if(htmlcounter<=1){
						session.removeAttribute("html_"+docid);
						session.removeAttribute("htmlcounter_"+docid);
					}else{
						htmlcounter--;
						session.setAttribute("htmlcounter_"+docid,""+htmlcounter);
					} 
				}
			%>
		</div>
	</body>
</html>
