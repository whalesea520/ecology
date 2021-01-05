<%@ page language="java" import="weaver.systeminfo.SystemEnv"
	pageEncoding="utf-8"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="km" class="weaver.general.KnowledgeTransMethod"
	scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%
    int language = user.getLanguage();
    String modename = SystemEnv.getHtmlLabelName(16398, user.getLanguage());//16398:文档目录
    //详细设计后台页面
    String modeurl = "/docs/category/DocMainCategory.jsp";

    //编辑权限验证
    if (!HrmUserVarify.checkUserRight("homepage:Maint", user)) {
        response.sendRedirect("/notice/noright.jsp");
        return;
    }
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<link href="/rdeploy/assets/css/index.css" rel="stylesheet"
			type="text/css">
		<link rel="stylesheet" href="/css/init_wev8.css" type="text/css" />
		<script type="text/javascript"
			src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
		<script language="javascript" type="text/javascript"
			src="/js/init_wev8.js"></script>
		<script type="text/javascript">
  		$(function () {
  			//鼠标移到图标上触发事件，显示设置和启用图标
  			$(".item .itemico img").hover(function (e) {
				if (!!$(this).closest(".additem")[0]) {
  					$(this).attr("src", "/rdeploy/assets/img/new_slt.png");
  				} else {
					$(this).attr("src", "/rdeploy/assets/img/doc/doc_hover.png");
					$(this).closest(".item").find(".itemclose").show();
				}
  			});
			
  			//只有鼠标移除整个item范围才会隐藏图标
  			$(".item").hover(null, function () {
  				var imgobj = $(this).children(".itemico").find("img");
  				if (!!$(this).closest(".additem")[0]) {
  					imgobj.attr("src", "/rdeploy/assets/img/new.png");
  				} else {
					imgobj.attr("src", "/rdeploy/assets/img/doc/doc.png");
					$(this).find(".itemoperation").hide();
					$(this).find(".itemclose").hide();
				}
  			});
  			//删除图标鼠标悬浮事件
  			$(".item .itemclose img").hover(function (e) {
  				$(this).attr("src", "/rdeploy/assets/img/close_slt.png");
  			}, function () {
  				$(this).attr("src", "/rdeploy/assets/img/close.png");
  			});
  			
  			$(".item .itemclose img").bind("click", function (e) {
				var _this = jQuery(this);
  				top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435, language)%>",function(){
					jQuery.ajax({
						url:"SecCategoryOperation.jsp?isdialog=1&operation=delete&id="+_this.attr("_dataid"),
						type:"post",
						beforeSend:function(){
							e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(33592, language)%>",true);
						},
						success:function(data){
							try{
								var message = data.match(/~~~~\d+~~~~/);
								if(message){
									message = message[0];
									if(message){
										message = message.match(/\d+/)[0];
										if(parseInt(message)=="87"){
											top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21536, language)%>");
										}else{
											top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83473, language)%>");
										}
									}else{
										top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83472, language)%>");
										_this.closest("div.item").remove();
									}
								}else{
									top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83472, language)%>");
									_this.closest("div.item").remove();
								}
							}catch(e){
								if(window.console)console.log(e,"DocMainCategoryList.jsp#doDel");
							}
						},
						complete:function(){
							e8showAjaxTips("",false);
						}
					});
  				});
			});
  			
  			//弹出设置界面
  			$(".item .itemico img").bind("click", function () {
  				var dialog = new window.top.Dialog();
  				dialog.currentWindow = window;
  				if (!!$(this).closest(".additem")[0]) {
  					dialog.URL = "/rdeploy/doc/DocSecCategoryAdd.jsp";
  					dialog.Title = "<%=SystemEnv.getHtmlLabelName(84075, user.getLanguage())%>";    //84075:新建目录
					dialog.Width = 500;
  					dialog.Height = 200;
  					dialog.normalDialog = false;
  					dialog.Drag = true;
					dialog.show();
  				} else {
					
								jQuery.ajax({
									 type: "POST",
									 url: "/rdeploy/doc/CheckHasAdvancedPremission.jsp",
									 data: {secgoryid:$(this).attr("_dataid"),secnmae:$(this).attr("title")},
									cache: false,
							 			async:false,
							 		dataType: 'json',
									 success: function(msg){
									 		if(msg.hasAdvancedPremission)
									 		{
									 				dialog.URL = "/docs/category/DocCategoryTab.jsp?_fromURL=3&id="+msg.id;
								  					dialog.Title = msg.secnmae;
													dialog.Width = 1000;
								  					dialog.Height = 830;
								  					dialog.normalDialog = false;
								  					dialog.Drag = true;
													dialog.show();
													  
													  var altMesflog = true;
													  jQuery.ajax({
														type: "POST",
														url: "/rdeploy/doc/CheckHasAltMesConfig.jsp",
														cache: false,
														async:false,
														dataType: 'json',
														success: function(msg){
															altMesflog = msg.altMesFlog;
														  }
						 								});
													  
													 if(altMesflog)
													 {
													 	myInterval = setInterval((function(){
																	return(function(){
																		var dialogFrameDocument = top.document.getElementById("_DialogFrame_"+dialog.ID).contentWindow.document;
																	if(dialogFrameDocument != null){
																	
																		var dialogFrameDiv = dialogFrameDocument.getElementById('tabcontentframe').parentNode;
																		
																		
																		
																		var e8TreeSwitch = dialogFrameDocument.getElementById('e8TreeSwitch');
																		
																		if(e8TreeSwitch != null){
																			e8TreeSwitch.remove();
																		}
																		
																		var style = document.createElement('style');
																		style.type = 'text/css';
																		style.innerHTML = "@import url('/rdeploy/assets/css/doc/altmes.css')";
																		
																			
																		var altDiv = document.createElement("div"); 
																		altDiv.className = "altDiv";
																		
																		var altMes = document.createElement("div"); 
																		altMes.innerHTML = '<%=SystemEnv.getHtmlLabelName(127880,user.getLanguage()) %>';
																		 altMes.className = "altMes";
																		 
																		 
																		var btnDiv = document.createElement("div"); 
																		
																		
																		btnDiv.innerHTML = '<%=SystemEnv.getHtmlLabelName(127881,user.getLanguage()) %>';
																		 btnDiv.className = "btnDiv";
																		
																		altDiv.appendChild(altMes);
																		dialogFrameDiv.appendChild(style);
																		dialogFrameDiv.appendChild(btnDiv);
																		dialogFrameDiv.appendChild(altDiv);
																		
																		var flag = true;
																		btnDiv.onclick = function(){
																			jQuery.ajax({
																			type: "POST",
																			url: "/rdeploy/doc/AddAtlMesConfig.jsp",
																			cache: false,
																			async:false,
																			dataType: 'json'
																			});
																			flag = false;
																			clearInterval(myInterval);
																			
																			(function(o,i,s){
																				i=0.4;
																				s=0.01;
																				outInterval = setInterval((function(){
																				 return(function(){
																				 	i+=s;
																					s = -0.05;
																					if(o.filters)
																					o.filters[0].opacity=i*100;
																					else
																					 o.style.opacity=i;
																				 	if(i < 0)
																					{
																						clearInterval(outInterval);
																						altDiv.remove();
																					}
																					
																					if(i < 0.3)
																					{
																						btnDiv.remove();
																					}
																				 })
																				 })(),50);
																			})(altDiv);
																		}
																		
																		if(flag)
																		{
																		clearInterval(myInterval);
																		setTimeout(function(){
																			(function(o,i,s){
																				i=0.4;
																				s=0.01;
																				outInterval = setInterval((function(){
																				 return(function(){
																				 	i+=s;
																					s = -0.05;
																					if(o.filters)
																					o.filters[0].opacity=i*100;
																					else
																					 o.style.opacity=i;
																				 	if(i < 0)
																					{
																						clearInterval(outInterval);
																						altDiv.remove();
																					}
																					if(i < 0.3)
																					{
																						btnDiv.remove();
																					}
																				 })
																				 })(),50);
																			})(altDiv);
																			
																			
																		},8000);
																		}
																	}
																	})
																	})(),100);
													 }
													
									 		}
									 		else
									 		{
									 			dialog.URL = "/rdeploy/doc/DocSecCategoryRightEdit.jsp?id="+msg.id;
							  					dialog.Title = msg.secnmae;
												dialog.Width = 604;
							  					dialog.Height = 505;
							  					dialog.normalDialog = false;
							  					dialog.Drag = true;
												dialog.show();
									 		}
									 }
						 		});
				}
				
  			});
  		});
  	</script>

	</head>
	<body>
		<!-- 顶部 -->
		<jsp:include page="/rdeploy/indexTop.jsp" flush="false">
			<jsp:param name="modename" value="<%=modename%>" />
			<jsp:param name="modeurl" value="<%=modeurl%>" />
		</jsp:include>
		<div class="content">
			<%
			    rs.executeQuery("select id,categoryname from docseccategory where seccategorytype = 0 order by secorder");
			    while (rs.next()) {
			        String id = rs.getString("id");
			%>
			<!-- item block -->
			<div class="item">
				<div class="itemtitle" style="white-space:nowrap;overflow:hidden;text-overflow:ellipsis;" title="<%=rs.getString("categoryname")%>">
					<%=rs.getString("categoryname")%>
				</div>
				<div class="itemico">
					<img title="<%=rs.getString("categoryname")%>"
						src="/rdeploy/assets/img/doc/doc.png" _dataid="<%=id%>">
				</div>
				<%
				    if (km.getDocDirCheckbox("" + id).equals("true") && km.getDocSecDirCheckbox("" + id).equals("true")) {
				%>
				<div class="itemclose">
					<img src="/rdeploy/assets/img/close.png" width="25px" height="25px"
						_dataid="<%=id%>">
				</div>
				<%
				    }
				%>
			</div>
			<%
			    }
			%>
			<div class="item additem">
				<div class="itemtitle">
					<%=SystemEnv.getHtmlLabelName(84075, user.getLanguage())%>
					<!-- 84075:新建目录 -->
				</div>
				<div class="itemico">
					<img src="/rdeploy/assets/img/new.png">
				</div>
			</div>
		</div>

	</body>
</html>
