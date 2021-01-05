<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

/*用户验证*/
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}

int eid = Util.getIntValue(Util.null2String(request.getParameter("eid")));
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
	<script type="text/javascript" src="/page/element/imgSlide/resource/js/jquery-1.8.3.min_wev8.js"></script>
	<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
	<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
	<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
	<script type="text/javascript" src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js"></script>
	<script type="text/javascript" src="/page/element/imgSlide/resource/js/jquery-ui-1.11.4.custom/jquery-ui.min.js"></script>
	<link href="/page/element/imgSlide/resource/js/jquery-ui-1.11.4.custom/jquery-ui.min.css" rel="stylesheet" type="text/css">
	
	
<%if(user.getLanguage()==7) {%>
	<script type="text/javascript" src="/js/page/maint/common/lang-cn_wev8.js"></script>
<%} else if(user.getLanguage()==8) {%>
	<script type='text/javascript' src='/js/page/maint/common/lang-en_wev8.js'></script>
<%} else if(user.getLanguage()==9) {%>
	<script type='text/javascript' src='/js/page/maint/common/lang-tw_wev8.js'></script>
<%}%>
	
	<link href="/rdeploy/assets/css/index.css" rel="stylesheet" type="text/css">
	
	<style type="text/css">
		.settingblock {
			padding:0px 5px;
		}
		.sitemblock {
			height:145px;border:1px solid #eeeeee;background-color:#fff;
			position:relative;
			margin-bottom:12px;
		}
		/*
		.sitemblock:hover {
			border:1px solid #d2ebc7;background-color:#f7fbf5;
		}
		*/
		.sitemblock_slt {
			border:1px solid #d2ebc7;background-color:#f7fbf5;
		}
		
		.sitemblock table {
			font-size:12px!important;
		}
		
		.sitempreview {
			margin:9px;width:200px;height:127px;
			position:relative;
		}
		.siteminputblock {
			margin:9px;
		}
		.sitemline {
			height:12px!important;
		}
		.siteminputblock input {
			height:40px;width:100%;border:1px solid #d2d2d2;color:#595959;font-size:12px;padding-left:10px;
		}
		
		.sitemdelete {
			position:absolute;width:15px;height:15px;right:9px;top:9px;display:none;
			background:url('/page/element/imgSlide/resource/image/close.png') 0 0 no-repeat;
			cursor:pointer;
		}
		
		.sitemdelete:hover {
			background:url('/page/element/imgSlide/resource/image/close_slt.png') 0 0 no-repeat;
		}
		
		.sitemmove {
			position:absolute;width:15px;height:15px;right:35px;top:9px;display:none;
			background:url('/page/element/imgSlide/resource/image/move.png') 0 0 no-repeat;
			cursor:pointer;
		}
		
		.sitemmove:hover {
			background:url('/page/element/imgSlide/resource/image/move_slt.png') 0 0 no-repeat;
		}
		
		.sitempreviewinfo {
			text-align:center;
			line-height:30px;
			font-size:12px;
			height:30px;
			width:100%;
			background-color: #4b4b4b;
			color:#fff;
			filter: Alpha(Opacity=70);
			opacity: 0.7;z-index: 1000;
			position:absolute;
			bottom:0px;
			cursor: pointer;
		}
		.itemnew {
			height:54px;border:1px dotted #eeeeee;position:relative;
		}
		.itemnew:hover {
			background-color:#f7fbf5;
		}
		object {
			position:absolute;
			left:0px;
			top:0px;
			opacity:0;
			filter: Alpha(Opacity=0);
		}
	</style>
	
	<script type="text/javascript">
	<!--
		var dialog = parent.getDialog(window);
		var parentWin = parent.getParentWindow(window);
	  	function cancle() {
			dialog.close();
	  	}
		$(function () {
			$(".settingblock").on("mouseenter", ".sitemblock", function () {
				$(this).addClass("sitemblock_slt");
				$(this).find(".sitemdelete").show();
				$(this).find(".sitemmove").show();
			}).on("mouseleave", ".sitemblock", function () {
				$(this).removeClass("sitemblock_slt");
				$(this).find(".sitemdelete").hide();
				$(this).find(".sitemmove").hide();
			});
			
			$("#addItem").bind("click", function () {
				var line = "";//'<div class="sitemline"></div>';
				var itemlength = $("#content").children(".sitemblock").length;
				if (itemlength > 0) {
					$("#content").append(line);
				}
				$("#content").append($("#addhtmlblock").html().replace(/_mode/g, ""));
				if (itemlength >9) {
					$(this).closest(".itemnew").hide();
				}
				var newitembtnid = "uploadimgbtn_" + new Date().getTime();
				$("#content").find("#uploadimgbtn_temp").attr("id", newitembtnid);
				
				$("#"+newitembtnid).closest(".portalstbtn").bind("click",function(){selectImgSource(this)})
			});
			
			$("#displaydescbtn").bind("click", function () {
				$(".sitempreviewinfo").toggle();
				if (parseInt($("#displaydesc").val()) == 1) {
					$("#displaydesc").val("0")
					$(this).children("img").attr("src", "/page/element/imgSlide/resource/image/display.png");
					$(this).children("span").html("<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())+SystemEnv.getHtmlLabelName(22965,user.getLanguage())%>");
				} else {
					$("#displaydesc").val("1")
					$(this).children("img").attr("src", "/page/element/imgSlide/resource/image/display_none.png");
					$(this).children("span").html("<%=SystemEnv.getHtmlLabelName(23857,user.getLanguage())+SystemEnv.getHtmlLabelName(22965,user.getLanguage())%>");
				}
				

			});
			
			$(".settingblock").on("click", ".sitemdelete", function () {
				var sitemele = $(this).closest(".sitemblock");
				top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
					if (!!sitemele.prev(".sitemline")[0]) {
						sitemele.prev(".sitemline").remove();	
					} else {
						sitemele.next(".sitemline").remove();
					}
					sitemele.remove();
					
					if ($(".settingblock").children(".sitemblock").length < 11) {
						$("#addItem").closest(".itemnew").show();
					}
				});
			});
			
			$(".settingblock").on("blur", "input[name=imgdesc]", function () {
				$(this).closest(".sitemblock").find(".sitempreviewinfo").html($(this).val());
			});
			
		})
		
		
		
		function dosubmit() {
			var eid = "<%=eid %>";
			
			//alert($(".sitemblock").length)
			if ($(".sitemblock").length < 2) {
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(127914,user.getLanguage())%>");
				return;
			}
			
			//是否显示说明文字
			var displaydesc = $("#displaydesc").val();
			
			var imgdescs = "";
			var imgsrcs = "";
			var imgsrcarray = $("input[name=imgsrc]");
			for (var i=0; i<imgsrcarray.length; i++) {
				var $this = $(imgsrcarray[i]);
				if ($this.val() == "") {
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(127915,user.getLanguage())%>" + (i + 1) + "<%=SystemEnv.getHtmlLabelName(127916,user.getLanguage())%>");
					return ;
				}
				if (imgsrcs != "") {
					imgsrcs += ",";
				}
				imgsrcs += $this.val();
			}
			var imgdescarray = $("input[name=imgdesc]");
			for (var i=0; i<imgdescarray.length; i++) {
				var $this = $(imgdescarray[i]);
				if (displaydesc == "1" && $this.val() == "") {
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(127917,user.getLanguage())%>" + (i + 1) + "<%=SystemEnv.getHtmlLabelName(127918,user.getLanguage())%>");
					return ;
				}
				
				if (imgdescs != "") {
					imgdescs += ",";
				}
				imgdescs += $this.val();
			}
			
			
			$("#pform")[0].submit();
			/*
			$.ajax({
				url: "/page/element/imgSlide/detailsettingOperation.jsp",
				type : "POST", 
				data : {eid:eid, imgsrcs:imgsrcs, imgdescs:imgdescs, displaydesc:displaydesc},
		        contentType : "charset=UTF-8", 
		        error:function(ajaxrequest){
		        	//dialog.close();
				}, 
		        success:function(content) {
		        alert(111);
		        	//parentWin.location.reload();
		        	//dialog.close();
				}
			});
			*/
		}
		$(function() {
			$( "#content" ).sortable({
		    	revert: true,
		    	axis: "y",
		    	handle: ".sitemmove"
		    });
		});
		
		function selectImgSource(ele){
			var isSingle = true;
			var tempFile='';
			var pos=tempFile.indexOf("/page/resource/userfile/");
			if(pos!=-1) tempFile=tempFile.substring(pos+24);
			var dlg=new window.top.Dialog();//定义Dialog对象
			dlg.currentWindow = window;   
			dlg.Model=true;
			dlg.Width = top.document.body.clientWidth-100;
			dlg.Height = top.document.body.clientHeight-100;
			
			dlg.URL="/page/maint/common/CustomResourceMaint.jsp?isDialog=1&?file="+tempFile+"&isSingle="+isSingle;
			dlg.callbackfun=function(obj,datas){
				if (datas!=null&&datas.id!="false"){
					$(ele).closest(".sitemblock").find("input[name=imgsrc]").val(datas.id)
					$(ele).closest(".sitemblock").find(".sitempreview").css("background","url('"+datas.id+"')center center no-repeat")
				}
			}
			dlg.show();
		}
		function setImgSlideSrc(obj,src){
			console.log(obj)
			console.log(src)
		}
		$(function () {
			$("#content .sitemblock .portalstbtn").bind("click",function(){selectImgSource(this)})
		});
	-->
	</script>
  </head>

	<%
	RecordSet rs = new RecordSet();
	rs.executeSql("select * FROM hpElement_slidesetting where eleid=" + eid+" order by cast(id as int) asc");
	int rowcount = rs.getCounts();
	int displaydesc = 1;
  	if (rs.next()) {
  	  	displaydesc = Util.getIntValue(Util.null2String(rs.getString("displaydesc")), 1);
  	}
  	rs.beforFirst();
  	
  	
	if (rs.getCounts() == 0) {
	%>
	<script type="text/javascript">
	$(function () {
		$("#addItem").trigger("click");
	});
	</script>
	<%	
	}
	%>
  
  <body style="margin:0px;padding:0ppx;">
  <form method="post" action="/page/element/imgSlide/detailsettingOperation.jsp" target="formiframe" id="pform">
	  <input type="hidden" name="eid" value="<%=eid %>">
	  <div class="zDialog_div_content" style="position:absolute;bottom:48px;top:0px;width: 100%;">
	  	<span class="portalstbtn2 bgblue" id="displaydescbtn" style="margin: 9px;float:right;">
	  		<img src="/page/element/imgSlide/resource/image/display<%=displaydesc == 1 ? "_none":"" %>.png" width="28px" height="28px" align="absMiddle">&nbsp;&nbsp;<span><%=(displaydesc == 1 ? SystemEnv.getHtmlLabelName(23857,user.getLanguage()): SystemEnv.getHtmlLabelName(89,user.getLanguage()))+SystemEnv.getHtmlLabelName(22965,user.getLanguage()) %></span>
	  	</span>
	  	<input type="hidden" name="displaydesc" id="displaydesc" value="<%=displaydesc %>">
	  	<div style="clear:both;"></div>
	    <div class="settingblock" id="content">
	    	<%
		  	while (rs.next()) {
		  	  	String imgsrc = Util.null2String(rs.getString("imgsrc"));
			  	String imgdesc = Util.null2String(rs.getString("imgdesc"));
			  	rowcount--;
		  	%>
	    	<!-- item -->
	    	<div class="sitemblock">
	    		<div class="sitemmove" title="<%=SystemEnv.getHtmlLabelName(78,user.getLanguage())%>"></div>
	    		<div class="sitemdelete" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></div>
	    		<table width="100%" height="100%" cellpadding="0" cellspacing="0">
	    			<colgroup><col width="218px">
	    			<col width="*">
	    			</colgroup>
	    			<tr>
	    				<td width="218px">
	    					<div class="sitempreview" style="background:url('<%=imgsrc %>') center center no-repeat;border:1px solid #d7d8e0;">
	    						<div class="sitempreviewinfo" style="<%=displaydesc == 0 ? "display:none;" : "" %>">
	    							<%=imgdesc %>
	    						</div>
	    					</div>
	    				</td>
	    				<td>
	    					<div class="siteminputblock">
	    						<div><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></div>
	    						<!-- 分割线 -->
	    						<div class="sitemline"></div>
	    						<div>
	    							<!-- 图片简介 -->
	    							<input type="text" name="imgdesc" value="<%=imgdesc %>">
	    						</div>
	    						<div class="sitemline"></div>
	    						<div>
	    							<!-- 选择图片src -->
	    							<input type="hidden" name="imgsrc" value="<%=imgsrc %>">
	    							<span class="portalstbtn bggreen" style="position:relative;"><span class="btntext"><%=(!"".equals(imgsrc) ? SystemEnv.getHtmlLabelName(83738,user.getLanguage()):SystemEnv.getHtmlLabelName(172,user.getLanguage()))+ SystemEnv.getHtmlLabelName(74,user.getLanguage())%></span>
	    								<span class="uploadbtn" id="uploadimgbtn_<%=new Date().getTime() %>"></span>  
	    							</span>
	    							
	    							(<%=SystemEnv.getHtmlLabelName(127919,user.getLanguage())%>)
	    						</div>
	    					</div>
	    				</td>
	    			</tr>
	    		</table>
	    	</div>
	    		<%
	    		if (rowcount != 0) {
	    		%>
	    	<!-- 
	    	<div class="sitemline">
	   		</div>
	   		-->
	   			<%
	    		}
	   			%>
	    	<%
		  	}
		    %>
	    	
	    </div>
	    <!-- 
	   	<div class="sitemline">
	   	</div>
	   	 -->
	   	<div class="itemnew" style="<%=rs.getCounts() >10 ? "display:none;" : "" %>">
	   		<div style="position:absolute;height:24px;width:24px;z-index:10000;top:50%;left:50%;cursor:pointer; ">
				<img src="/page/element/imgSlide/resource/image/new.png" height="24px" width="24px" style="margin-top:-12px;margin-left:-12px;" id="addItem" title="<%=SystemEnv.getHtmlLabelName(124841,user.getLanguage())%>">
			</div>
	   	</div>
	   	
	   	<!-- 隐藏的区域，用于添加时copy -->
	   	<div style="display:none;" id="addhtmlblock">
	   		<!-- item -->
	   		<div class="sitemblock">
	   			<div class="sitemmove" title="<%=SystemEnv.getHtmlLabelName(78,user.getLanguage())%>"></div>
	   			<div class="sitemdelete" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></div>
	    		<table width="100%" height="100%" cellpadding="0" cellspacing="0">
	    			<colgroup><col width="218px"><col width="*"></colgroup>
	    			<tr>
	    				<td width="218px">
	    					<div class="sitempreview" style="background:url('') center center no-repeat;border:1px solid #d7d8e0;">
	    						<div class="sitempreviewinfo" style="<%=displaydesc == 0 && rs.getCounts() > 0 ? "display:none;" : "" %>">
	    						</div>
	    					</div>
	    				</td>
	    				<td>
	    					<div class="siteminputblock">
	    						<div><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></div>
	    						<!-- 分割线 -->
	    						<div class="sitemline"></div>
	    						<div>
	    							<!-- 图片简介 -->
	    							<input type="text" name="imgdesc_mode">
	    						</div>
	    						<div class="sitemline"></div>
	    						<div>
	    							<!-- 选择图片src -->
	    							<input type="hidden" name="imgsrc_mode">
	    							<!-- <span class="portalstbtn bggreen" onclick="">选择图片</span>  -->
	    							<span class="portalstbtn bggreen" style="position:relative;"><span class="btntext"><%=SystemEnv.getHtmlLabelName(125080,user.getLanguage())%></span>
	    								<span class="uploadbtn" id="uploadimgbtn_temp"></span>
	    							</span>
	    							(<%=SystemEnv.getHtmlLabelName(127919,user.getLanguage())%>)
	    						</div>
	    					</div>
	    				</td>
	    			</tr>
	    		</table>
	    	</div>
	   	</div>
	   	</div>
	   	
	   	
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<wea:layout needImportDefaultJsAndCss="false">
				<wea:group context="" attributes="{'groupDisplay':'none'}">
					<wea:item type="toolbar">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="" class="zd_btn_cancle" onclick="dosubmit();"/>
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="" class="zd_btn_cancle" onclick="cancle();"/>
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>
	</form>
	
	<div style="display:none;">
	  	<iframe name="formiframe" src="">
	</div>
  </body>
</html>
