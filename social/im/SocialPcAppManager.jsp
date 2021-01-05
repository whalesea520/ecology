<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="java.util.regex.*"%> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
Pattern pattern = Pattern.compile("[0-9]*");
String id = request.getParameter("id");
if(id==null||id.equals("")){
    id = "";
}
%>
<!DOCTYPE html 
PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" 
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"> 
<html>
    <head>
    	<script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
        <link rel="stylesheet" href="/social/css/im_pcmodels_wev8.css" type="text/css" />
        <link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
		<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
		<script>
			jQuery(document).ready(function(){
				$('#pc-appmanager').perfectScrollbar();
				//绑定拖动时间
				registerDragEvent();
				//绑定按钮点击
				registerMouseEvent();
				delIdAry = new Array();
				addIcoIdAry = new Array();
				//绑定关闭事件
				saveTimer = null;
			});
			
			function registerMouseEvent() {
				 $(document).on("mouseover mouseout",'#pc-appmanager .item',function(e){
				 	e = e || window.event;
				 	if(event.type == "mouseover"){
					  $(this).find('.itembtnblock').css('display', 'block');
					}else if(event.type == "mouseout"){
					  $(this).find('.itembtnblock').css('display', 'none');
					}
				 });
				 //删除
				 $(document).on('click','#content .btnStyleBlue',function(e){
				 	doDel(this, e);
				 	e = e || window.event;
				 	e.preventDefault();
				 });
				 //添加
				 $(document).on('click','#content2 .btnStyleBlue',function(e){
				 	doAdd(this, e);
				 });
			}
			
			function doClose(){
			    $('.newWindow-close').click();
			}
			
			function doSave() {
				window.clearTimeout(saveTimer);
				saveTimer = setTimeout(function(){
					var delids = delIdAry.join(",");
					var addids = addIcoIdAry.join(",");
					var showindexs = getShowIndexs();
					$("input[name='readyToDelIds']").val(delids);
					$("input[name='readyToAddIds']").val(addids);
					$("input[name='showindexs']").val(showindexs);
					var userId = $("input[name='userId']").val();
					$.post("/social/im/SocialIMOperation.jsp?operation=saveUserAppSetting", {
						"readyToDelIds": delids,
						"readyToAddIds": addids,
						"showindexs": showindexs,
						"userId": userId
					}, function(ret){
						ret = $.trim(ret);
						if(ret == "1"){
							//window.location.href=window.location.href;
							delIdAry = [];
							addIcoIdAry = [];
						}
						closeWidthData();
						
						var id = "<%= id %>";
						if(id!==''){
						   doClose();
						}
						
					});
					//$("#mainform").submit();
				}, 200);
			}
			
			function getShowIndexs(){
				var items = $("#content .item");
				var indexAry = new Array();
				for(var i = 0; i < items.length; ++i){
					var id = $(items[i]).attr("id");
					if(id){
						indexAry.push(id+"_"+i);
					}else{
						indexAry.push("0_"+i+"_"+($(items[i]).attr("tempId")));
					}
				}
				return indexAry.join(",");
			}
			
			function checkRange(tag) {
				var itemcount = $("#content .item:visible").length;
				if(tag > 0 && itemcount >= 9){
					top.Dialog.alert("超出最多9个限制！");
					throw new Error("over maxmums!");
				}
				console.log("tag:"+tag,"itemcount:"+itemcount);
				if(tag < 0 && itemcount <= 1){
					top.Dialog.alert("至少显示一个按钮！");
					throw new Error("over minmums!");
				}
			}
			function doDel(btnObj, evt){
				try{
					checkRange(-1);
					var itemObj = $(btnObj).parents('.item');
					if(itemObj.attr("isTemp")){
						var tempId = itemObj.attr("tempId");
						for (var i = 0; i < addIcoIdAry.length; i++) {
							if (addIcoIdAry[i] == tempId){
								addIcoIdAry.splice(i, 1);
							}
						}
						$("#"+tempId).show();
						itemObj.remove();
					}else{
						var readyToDelId = itemObj.attr('id');
						var addObj = $("#item-template-1").children().clone();
						addObj.find(".itemico img").attr("src", itemObj.find(".itemico img").attr("src"));
						addObj.find(".itemtitle").text(itemObj.find(".itemtitle").text());
						addObj.attr({"isTemp": "isTemp", "tempId": readyToDelId});
						$("#content2").append(addObj);
						itemObj.hide();
						delIdAry.push(readyToDelId);
					}
					//doSave();
				}catch(err) {
					console.log("删除报错", err);
				}
			}
			
			function doAdd(btnObj, evt){
				try{
					checkRange(1);
					var itemObj = $(btnObj).parents('.item');
					if(itemObj.attr("isTemp")){
						var tempId = itemObj.attr("tempId");
						for (var i = 0; i < delIdAry.length; i++) {
							if (delIdAry[i] == tempId){
								delIdAry.splice(i, 1);
							}
						}
						$("#"+tempId).show();
						itemObj.remove();
					}else{
						var readyToAddIcoId = $(itemObj).attr("id");
						var linkuri = $(itemObj).attr("_linkuri");
						var uritype = $(itemObj).attr("_uritype");
						var linkuri = $(itemObj).attr("_linkuri");
						var linktitle = $(itemObj).attr("_linktitle");
						var icouri = itemObj.find(".itemico img").attr("src");
						var hoticouri = itemObj.find(".itemico img").attr("_srchot");
						
						var addObj = $("#item-template-0").children().clone();
						addObj.find(".itemico img").attr({"src": icouri, "_srchot":hoticouri});
						addObj.find(".itemtitle").text(itemObj.find(".itemtitle").text());
						addObj.attr({"isTemp": "isTemp", "tempId": readyToAddIcoId, "_linkuri": linkuri, "_uritype":uritype, "_linktitle":linktitle });
						$("#content").append(addObj);
						itemObj.hide();
						addIcoIdAry.push(readyToAddIcoId);
					}
					//doSave();
				}catch(err){
					console.log("添加报错", err);
				}
			}
			
			function registerDragEvent(){
				 var fixHelper = function(e, ui) {
			        ui.children().each(function() {  
			            jQuery(this).width(jQuery(this).width());     
			            jQuery(this).height("30");						
			        });  
			        return ui;  
			    }; 
			    $("#content").sortable({
		            revert: true,
		            axis: "y",
		            handle: ".movebtn",
		            stop : function () {
		                var itemcount = $("#content .item").length;
		                $("#content .item").each(function (i, e) {
		                    if (i < itemcount - 1) {
		                        //$(this).addClass("itemborder"); 
		                        $(this).find(".inrsplitline").addClass("inrsplitline-dis");
		                    } else {
		                        //$(this).removeClass("itemborder");
		                        $(this).find(".inrsplitline").removeClass("inrsplitline-dis");
		                    }
		                });
		                //doSave();
		            }
		        });
			}
			
			function closeWidthData(){
				var datas = new Array();
				var itemList = $("#content .item:visible"), item;
				var icouri, hoticouri, linkuri, uritype, icotitle;
				for(var i = 0; i < itemList.length; ++i){
					item = $(itemList[i]);
					icouri = item.find(".itemicoblock img").attr('src');
					icohoturi = item.find(".itemicoblock img").attr('_srchot');
					linkuri = item.attr("_linkuri");
					uritype = item.attr("_uritype");
					icotitle = item.attr("_linktitle");
					datas.push({"icouri": icouri, "icohoturi": icohoturi, "linkuri":linkuri, "uritype": uritype, "icotitle": icotitle});
				}
				
				var id = "<%= id %>";
                if(id===''){
                    top.getDialog(window).close(datas);
                }else{
                    window.Electron.ipcRenderer.send('plugin-pcAppManager-cb',datas);
                }
				
			}
		</script>
    </head>
    <body>
		<div id="pc-appmanager" class="appmanager">
			<div class="title">
		      <span class="margin-left-12"><%=SystemEnv.getHtmlLabelName(130706, user.getLanguage())%></span><!-- 已添加应用 -->
		    </div>
		    
		    <form action="" method="post" id="mainform" target="targetframe">
		    	<input type="hidden" name="readyToDelIds" value=""/> 
		    	<input type="hidden" name="readyToAddIds" value=""/> 
		    	<input type="hidden" name="showindexs" value=""/> 
		    	<input type="hidden" name="userId" value="<%=user.getUID() %>"/> 
		    	<div id="content">
			      	<!-- item -->
			      	<%
				      	RecordSet recordSet = new RecordSet();
						String querySql = "select t1.id id, t1.showindex showindex, t2.labelindexid labelindexid, t2.labeltemp labeltemp, " +
						"t2.uritype uritype, t2.linkuri linkuri, t2.icouri icouri, t2.hoticouri hoticouri " +
						"from SocialPcUserApps t1 " +
						"inner join Social_Pc_UrlIcons t2 " +
						"on t1.icoid = t2.id " +
						"where t2.icotype = '1' and t2.ifshowon = '1' and t1.userid = '"+user.getUID()+"' " +
						"order by t1.showindex ";
						recordSet.execute(querySql);
			      		String icouri = "", icotitle = "", hoticouri = "", uritype = "", linkuri = "";
			      		String defaultPicPath = "/social/images/pcmodels/htb_default_wev8.png";
						String defaultPicHotPath = "/social/images/pcmodels/htb_default_h_wev8.png";
			      		int labelindexid;
			      		while(recordSet.next()){
			      			icouri = recordSet.getString("icouri");
			      			icouri = pattern.matcher(icouri).matches()?"/weaver/weaver.file.FileDownload?fileid="+icouri:icouri;
			      			hoticouri = recordSet.getString("hoticouri");
			      			hoticouri = pattern.matcher(hoticouri).matches()?"/weaver/weaver.file.FileDownload?fileid="+hoticouri:hoticouri;
			      			uritype = recordSet.getString("uritype");
			      			linkuri = recordSet.getString("linkuri");
			      			labelindexid = recordSet.getInt("labelindexid");
			      			if(labelindexid != 0 && labelindexid != -1){
			      				icotitle = SystemEnv.getHtmlLabelName(labelindexid, user.getLanguage());
			      			}else{
			      				icotitle = recordSet.getString("labeltemp");
			      			}
			      	%>
			      	<div class="item" id="<%=recordSet.getString("id") %>" _linkuri="<%=linkuri %>" _uritype="<%=uritype %>" _linktitle="<%=icotitle %>">
				        <div class="itembtnblock">
				          <span class="btnStyleBlue"><%=SystemEnv.getHtmlLabelName(131200, user.getLanguage())%></span> <!-- 删除 -->
				          <span class="movebtn" title="<%=SystemEnv.getHtmlLabelName(131189, user.getLanguage())%>"></span> <!-- 移动 -->
				        </div>
				        <table width="100%" height="52px" cellpadding="0" cellspacing="0">
				          <colgroup><col width="60px"><col width="*"></colgroup>
				          <tr>
				            <td class="itemico">
				            	<div class="itemicoblock">
				            		<img onerror="javascript:this.src='<%=defaultPicPath %>';this.setAttribute('_srchot', '<%=defaultPicHotPath %>');" src="<%=icouri%>" _srchot="<%=hoticouri %>" width="18px" height="18px">
				            	</div>
				            </td>
				            <td>
				                <span class="itemtitle">
				                  	<%=icotitle %>
				                </span>
				            </td>
				          </tr>
				        </table>
			        	<div class="inrsplitline"></div>
			        </div> <!-- item end -->
			        <%} %>
			     </div>
		   </form>
		   <div class="title">
		      <span class="margin-left-12"><%=SystemEnv.getHtmlLabelName(130707, user.getLanguage())%></span><!-- 可添加应用 -->
		   </div>
		   <div id="content2">
		      <!-- item -->
		      <%
			      	recordSet = new RecordSet();
					querySql = "select id, showindex, labelindexid, labeltemp, uritype, linkuri, icouri, hoticouri  " +
					"from Social_Pc_UrlIcons " +
					"where ifshowon = '1' and not exists (select 1 from SocialPcUserApps where SocialPcUserApps.icoid = Social_Pc_UrlIcons.id and userid = '"+user.getUID()+"') " +
					"and icotype = '1' " +
					"order by showindex";
					System.err.println(querySql);
					recordSet.execute(querySql);
		      		while(recordSet.next()){
		      			icouri = recordSet.getString("icouri");
		      			icouri = pattern.matcher(icouri).matches()?"/weaver/weaver.file.FileDownload?fileid="+icouri:icouri;
		      			hoticouri = recordSet.getString("hoticouri");
		      			hoticouri = pattern.matcher(hoticouri).matches()?"/weaver/weaver.file.FileDownload?fileid="+hoticouri:hoticouri;
		      			uritype = recordSet.getString("uritype");
		      			linkuri = recordSet.getString("linkuri");
		      			labelindexid = recordSet.getInt("labelindexid");
		      			if(labelindexid != 0 && labelindexid != -1){
		      				icotitle = SystemEnv.getHtmlLabelName(labelindexid, user.getLanguage());
		      			}else{
		      				icotitle = recordSet.getString("labeltemp");
		      			}
		      	%>
		      <div class="item" id="<%=recordSet.getString("id") %>" _linkuri="<%=linkuri %>" _uritype="<%=uritype %>" _linktitle="<%=icotitle %>">
		        <table width="100%" height="52px" cellpadding="0" cellspacing="0">
		          <colgroup><col width="60px"><col width="*"><col width="100px"></colgroup>
		          <tr>
		            <td class="itemico">
		            	<div class="itemicoblock">
		              		<img onerror="javascript:this.src='<%=defaultPicPath %>';this.setAttribute('_srchot', '<%=defaultPicHotPath %>');" src="<%=icouri%>" _srchot="<%=hoticouri %>" width="18px" height="18px">
		            	</div>
		            </td>
		            <td>
		                <span class="itemtitle">
		                  	<%=icotitle %>
		                </span>
		            </td>
		            <td>
		            	<div class="itembtnblock">
		                	<span class="btnStyleBlue"><%=SystemEnv.getHtmlLabelName(131201, user.getLanguage())%></span><!-- 添加 -->
		                </div>
		            </td>
		          </tr>
		        </table>
		      <div class="inrsplitline" style=""></div>
		    </div> <!-- item end -->
		     <%} %>
		</div>
		<!-- item template -->
		<div id="item-template-0" style="display:none;">
			<div class="item">
		        <div class="itembtnblock">
		          <span class="btnStyleBlue"><%=SystemEnv.getHtmlLabelName(131200, user.getLanguage())%></span> <!-- 删除 -->
		          <span class="movebtn" title="<%=SystemEnv.getHtmlLabelName(131189, user.getLanguage())%>"></span> <!-- 移动 -->
		        </div>
		        <table width="100%" height="52px" cellpadding="0" cellspacing="0">
		          <colgroup><col width="60px"><col width="*"></colgroup>
		          <tr>
		            <td class="itemico">
		            	<div class="itemicoblock">
		            		<img src="" width="18px" height="18px">
		            	</div>
		            </td>
		            <td>
		                <span class="itemtitle">
		                  	<!-- 按钮标题 -->
		                </span>
		            </td>
		          </tr>
		        </table>
	        	<div class="inrsplitline"></div>
	        </div> <!-- item end -->
		</div>
		<div id="item-template-1" style="display:none;">
			<div class="item">
		        <table width="100%" height="52px" cellpadding="0" cellspacing="0">
		          <colgroup><col width="60px"><col width="*"><col width="100px"></colgroup>
		          <tr>
		            <td class="itemico">
		            	<div class="itemicoblock">
		              		<img src="" width="18px" height="18px">
		            	</div>
		            </td>
		            <td>
		                <span class="itemtitle">
		                  	<!-- 按钮标题 -->
		                </span>
		            </td>
		            <td>
		            	<div class="itembtnblock">
		                	<span class="btnStyleBlue"><%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%></span><!-- 添加 -->
		                </div>
		            </td>
		          </tr>
		        </table>
		      <div class="inrsplitline" style=""></div>
		    </div> <!-- item end -->
		</div>
		<!-- 底部按钮组 -->
	    <div id="zDialog_div_bottom" class="zDialog_div_bottom">	
	     	<wea:layout>
	     		<wea:group context="" attributes="{groupDisplay:none}">
	     			<wea:item type="toolbar">
	     				 <input type="button" value="<%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%>" id="zd_btn_confirm" class="zd_btn_cancle" onclick="doSave();"><!-- 确定 -->
	     				 <% 
	     				 if(id.equals("")){
	     				 %>
	                     <input type="button" value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>" id="zd_btn_cancle" class="zd_btn_cancle" onclick="top.getDialog(window).close()"> <!-- 关闭 -->
	     			     <% 
	     				 }else{
                         %>
                         <input type="button" value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>" id="zd_btn_cancle" class="zd_btn_cancle" onclick="doClose()"> <!-- 关闭 -->
                         <% 
                         }
                         %>
	     			</wea:item>
	     		</wea:group>
	     	</wea:layout>
	     </div>
	</body>
	</html>