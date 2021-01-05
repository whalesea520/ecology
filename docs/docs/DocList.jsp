
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET></LINK>
<LINK href="/js/ecology8/customSelect/customSelect_wev8.css" type=text/css rel=STYLESHEET></LINK>
<script src="/js/ecology8/customSelect/customSelect_wev8.js" type="text/javascript"></script>
<style type="text/css">
	.e8menu .e8menu_btn{
		width:16px;
		height:16px;
		cursor:pointer;
		float:right;
		display:none;
		color:#000;
		right:18px;
		position:absolute;
		padding-right:7px;
		padding-left:5px;
		background-color:#f5f5f5;
		background-repeat:no-repeat;
		background-position:50% 50%;
	}
	
	#warn{
		width: 260px;
		height: 65px;
		line-height:65px;
		background-color: gray;
		position: absolute;
		display:none;
		text-align:center;
		background: url("/images/ecology8/addWorkGround_wev8.png");
	}
	
	.e8HoverZtreeDiv:hover .e8menu .e8menu_btn{
		background-color:#def0ff;
	}
	
	.ztree li div.curSelectedNode .e8menu .e8menu_btn{
		background-color:#0D93F6;
	}
	
	.e8_z_toplevel .e8menu_btn{
		top:6px;
	}
	
	.e8_z_seclevel .e8menu_btn{
		top:3px;
	}
	
	.e8menu_btn_add{
		background-image:url(/images/ecology8/addwf_wev8.png);
	}
	.e8menu_btn_remove{
		background-image:url(/images/ecology8/rmwf_wev8.png);
	}
</style>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(92,user.getLanguage());
String needfav ="1";
String needhelp ="";
int isOpenNewWind =  Util.getIntValue(request.getParameter("isOpenNewWind"),1); //0:表示不重新弹出窗口 1:表示重新弹出窗口
int showType = Util.getIntValue(Util.getCookie(request,"showType_"+user.getUID()),0);
String url = "DocListAjax.jsp?"+request.getQueryString();
String labelid = "332,32520";
String isFav = "0";
String isCommon = "0";
if(showType==2){//我的收藏
	url = "DocListAjax.jsp?isFav=1&"+request.getQueryString();
	labelid = "18030";
	isFav = "1";
}else if(showType==3){//常用目录
	url = "DocListAjax.jsp?isCommon=1&"+request.getQueryString();
	labelid = "28183";
	isCommon = "1";
}
/**
* 20:新建文档
*/
String urlType = Util.null2String(request.getParameter("urlType"));

String wfid = Util.null2String(request.getParameter("workflowid"));
String secid = "";
String limitSec = "0";
if(!"".equals(wfid)){
	RecordSet.executeSql("select newdocpath from workflow_base where id="+wfid);
	if(RecordSet.next()){
		String ids = Util.null2String(RecordSet.getString(1));
		if(!ids.equals("")){
			String[] idArr = ids.split(",");
			secid = idArr[idArr.length-1];
			limitSec = "1";
		}
	}
}

if(urlType.equals(""))urlType="20";
%>
<BODY style="overflow-x:none;">
<%@ include file="/docs/common.jsp" %>

<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<script type="text/javascript">
	<%if(limitSec.equals("1")){%>
		jQuery.post("/docs/docs/AddSecIdUseCount.jsp",{secid:<%=secid%>});
		if (<%=isOpenNewWind%>==1){
			openFullWindowHaveBar("/docs/docs/DocAdd.jsp?secid=<%=secid%>&<%=request.getQueryString()%>");
		}else{
			parent.location.href="/docs/docs/DocAdd.jsp?secid=<%=secid%>&<%=request.getQueryString()%>";
			if(parent.opener){
				parent.opener.__fromRequest = true;
			}
		}
	<%}%>
	jQuery(document).ready(function(){
	    window.oldtree = false;
	});
</script>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(false){
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.frmmain.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.frmmain.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(19253,user.getLanguage())+",javascript:treeView(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(19466,user.getLanguage())+",javascript:viewbyOrganization(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script type="text/javascript">
	
	
	var __ajaxStartMsg = "<%= SystemEnv.getHtmlLabelName(81558,user.getLanguage())%>";
	
	var __switchTypeMsg = "<%=SystemEnv.getHtmlLabelName(18691, user.getLanguage())%>";
	
	var __reSelectCatMsg = "<%=SystemEnv.getHtmlLabelName(81565, user.getLanguage())%>";
	
	function loadLeftTree(){
		e8_custom_search_for_tree("");
	}
	
	jQuery(document).ready(function(){
		<%if(!limitSec.equals("1")){%>
			loadLeftTree();
		<%}%>
	});
	function leftMenuClickFn(attr,level,numberType,node,options){
		var treeNode = options.treeNode;
		var seccategory = treeNode.categoryid;
		var __contentWindow = jQuery("#flowFrame").get(0).contentWindow;
		//__contentWindow.loadPropAndAcc(seccategory,treeNode,options);
		var _isFav = jQuery("#flowFrame").attr("_isFav")||0;
		var _isCommon = jQuery("#flowFrame").attr("_isCommon")||0;
		jQuery("#flowFrame").attr("src","/docs/docs/DocListAjax.jsp?isFav="+_isFav+"&isCommon="+_isCommon+"&id="+seccategory+"&<%=request.getQueryString()%>");
	}
	
	function addOrRemoveFav(event,obj,raflag,secid,treeId,tId){
		var from = parseInt(jQuery(obj).attr("_from"));
		if(raflag==0){
			jQuery.ajax({
				url:"/weaver/weaver.common.util.taglib.ShowColServlet?timestamp="+new Date().getTime(),
				dataType:"json",
				type:"post",
				data:{
					secid:secid,
					src:"removeDefault"
				},
				success:function(data){
					if(data.result==1){
						jQuery(obj).remove();
						if(from==1){
							jQuery("#sec_"+secid).remove();
							try{
								var __contentWindow = jQuery("#flowFrame").get(0).contentWindow;
								jQuery("#sectree_"+secid,__contentWindow.document).remove();
							}catch(e){}
						}else{
							try{
								var __contentWindow = jQuery("#flowFrame").get(0).contentWindow;
								jQuery("#sectree_"+secid,__contentWindow.document).remove();
							}catch(e){}
						}
						//jQuery(obj).closest("div").hide();
						jQuery("#warn").css("left",(jQuery(document.body).width()-220)/2);
						jQuery("#warn").css("top",215+document.body.scrollTop);
						jQuery("#warn").css("display","block");
						jQuery("#e8MsgLabel").html("<%=SystemEnv.getHtmlLabelName(32048,user.getLanguage())%>");
						setTimeout(function (){
							jQuery("#warn").css("display","none");
						},1200);
					}else{
						top.Dialog.alert(data.msg);
					}
				}
			});
		}else if(raflag==1){
			jQuery.ajax({
				url:"/weaver/weaver.common.util.taglib.ShowColServlet?timestamp="+new Date().getTime(),
				dataType:"json",
				type:"post",
				data:{
					secid:secid,
					src:"addDefault"
				},
				success:function(data){
					if(data.result==1){
						jQuery(obj).remove();
						if(from==1){
							jQuery("#sec_"+secid).remove();
						}else{
							try{
								var __contentWindow = jQuery("#flowFrame").get(0).contentWindow;
								jQuery("#sec_"+secid,__contentWindow.document).remove();
							}catch(e){}
						}
						jQuery("#warn").css("left",(jQuery(document.body).width()-220)/2);
						jQuery("#warn").css("top",215+document.body.scrollTop);
						jQuery("#e8MsgLabel").html("<%=SystemEnv.getHtmlLabelNames("28111,15242",user.getLanguage())%>");
						jQuery("#warn").css("display","block");
						setTimeout(function (){
							jQuery("#warn").css("display","none");
						},1200);
					}else{
						top.Dialog.alert(data.msg);
					}
				}
			});
		}
		var evt = event || window.event;
		try{
			evt.stopPropagation();
		}catch(e){
			if(window.event){
				window.event.cancelBubble = true;
				return false;
			}else{
				evt.stopPropagation();
			}
		}
	}
	
	function addHoverDiyDom(treeId, treeNode){
		setTimeout(function(){
			var options = treeNode.options;
			if(options && options.addDiyDom===false)return;
			if(treeNode[options.rightKey]==="N")return;
			var btnclass=""
			var raflag = -1;
			if(treeNode.myFavorite==="true"||treeNode.myFavorite===true){
				btnclass="e8menu_btn_remove";
				raflag = 0;
			}else if(treeNode.myCommonDir==="true"||treeNode.myCommonDir===true){
				return;
			}else{
				btnclass="e8menu_btn_add";
				raflag = 1;
				var hasFavoriteList = treeNode.hasFavoriteList;
				if(hasFavoriteList){
					hasFavoriteList = hasFavoriteList.split(",");
					if(jQuery.inArray(""+treeNode.categoryid,hasFavoriteList)!=-1)return;
				}
			}
			var aObj = $("#" + treeNode.tId + "_a").addClass("e8menu");
			if (aObj.find("span."+btnclass).length>0) return;
			aObj.hover(function(e){
				jQuery(this).children("span."+btnclass).css("display","block");	
			},function(e){
				jQuery(this).children("span."+btnclass).hide();	
			});
			var spanArr = [];
			spanArr.push("<span id=\"sec_",treeNode.categoryid,"\" onclick=\"addOrRemoveFav(event,this,",raflag,",",treeNode.categoryid,",'",treeId,"','",treeNode.tId,"');\" class='e8menu_btn ",btnclass,"' title='",treeNode.optitle,"'></span>");
			aObj.append(spanArr.join(""));
		},10);
	}
	
	function e8_custom_search_for_tree(categoryname,data){
			var expandAllFlag = categoryname?true:false;
			if(!data){
				data = {
					categoryname:categoryname,
					url:""
				};
			}else{
				data.categoryname = categoryname;
			}
			var showtype = jQuery("#showtype").val();
			if(showtype==2){
				data.myFavorite = true;
			}else if(showtype==3){
				data.myCommonDir = true;
			}
			if(data){
				expandAllFlag = (data.myFavorite || data.myCommonDir )?true:false;
			}
			data.operationcode = <%=MultiAclManager.OPERATION_CREATEDOC%>;
			jQuery.ajax({
				url:"/docs/search/DocSearchMenu.jsp?timestap="+new Date().getTime()+"&<%=request.getQueryString()%>",
				type:"post",
				dataType:"json",
				data:data,
				beforeSend:function(){
					if(jQuery(".leftTypeSearch").css("display")!="none")
						e8_before2();
				},
				complete:function(xhr){
					e8_after2();
				},
				success:function(data){
					var demoLeftMenus = data;
					$(".ulDiv").leftNumMenu(demoLeftMenus,{
							showZero:false,
							multiJson:true,	
							addDiyDom:true,
							setting:{
								view: {
									expandSpeed: "" ,    
									addDiyDom:addHoverDiyDom
								},
								callback: {
									onClick: _leftMenuClickFunction   
								}
							},
							_callback:expandAllFlag?_expandAll:null,	
							clickFunction:function(attr,level,numberType,node,options){
								leftMenuClickFn(attr,level,numberType,node,options);
							}
					});
					if(data && data.seccategory){
						selectDefaultNode("categoryid",data.seccategory);
					}
				}
			});
		}
	
	function setcookie(name,value){
		try{
			if(navigator.cookieEnabled){ 
			    var Days = 365;   
			    var exp  = new Date();   
			    exp.setTime(exp.getTime() + Days*24*60*60*1000);   
			    document.cookie = name + "="+ escape (value) + ";expires=" + exp.toGMTString();
			}
		}catch(e){}
	}   
	
	function changeShowType(obj,showtype){
		//window.location.href='DocLatest.jsp?showtype='+showtype;
		//jQuery("#topMenuTitileTree").children("div").removeClass("selectedTitle");
		//jQuery(obj).addClass("selectedTitle");
		jQuery("#optionSpan").html(jQuery(obj).find(".e8text").html());
		jQuery("#showtype").val(showtype);
		setcookie("showType_<%=user.getUID()%>",showtype);
		var data = {};
		if(showtype==2){
			jQuery("#leftTree").css("background-color",jQuery(".leftTypeSearch").css("background-color"));
			jQuery("#currentfav").removeClass("e8imgSel");
			jQuery("#currentdoc").addClass("e8imgSel");
			jQuery("#currentcom").addClass("e8imgSel");
			jQuery("#currentImg").attr("src","/images/ecology8/doc/doc_wev8.png");
			jQuery("#flowFrame").attr("_isFav",1);
			jQuery("#flowFrame").attr("_isCommon",0);
			e8_custom_search_for_tree(jQuery(".leftSearchInput").val(),{myFavorite:true});
			jQuery("#flowFrame").attr("src","/docs/docs/DocListAjax.jsp?isFav=1");
		}else if(showtype==3){
			jQuery("#leftTree").css("background-color",jQuery(".leftTypeSearch").css("background-color"));
			jQuery("#currentcom").removeClass("e8imgSel");
			jQuery("#currentdoc").addClass("e8imgSel");
			jQuery("#currentfav").addClass("e8imgSel");
			jQuery("#currentImg").attr("src","/images/ecology8/doc/doc_wev8.png");
			jQuery("#flowFrame").attr("_isFav",0);
			jQuery("#flowFrame").attr("_isCommon",1);
			e8_custom_search_for_tree(jQuery(".leftSearchInput").val(),{myCommonDir:true});
			jQuery("#flowFrame").attr("src","/docs/docs/DocListAjax.jsp?isCommon=1");
			showE8TypeOption();
		}else{
			jQuery("#leftTree").css("background-color","");
			jQuery("#currentcom").addClass("e8imgSel");
			jQuery("#currentfav").addClass("e8imgSel");
			jQuery("#currentdoc").removeClass("e8imgSel");
			jQuery("#currentImg").attr("src","/images/ecology8/doc/doc_wev8.png");
			jQuery("#flowFrame").attr("_isFav",0);
			jQuery("#flowFrame").attr("_isCommon",0);
			e8_custom_search_for_tree(jQuery(".leftSearchInput").val());
			jQuery("#flowFrame").attr("src","/docs/docs/DocListAjax.jsp");
			showE8TypeOption();
		}
		window.oldtree = false;
	}
	
</script>
<style type="text/css">
	.topMenuTitle{
	    border-bottom: 1px solid #C0C0C0;
	    margin: 0;
	    position: relative;
	    vertical-align: middle;
	    width: 100%;
	    line-height:40px;
	   	cursor:pointer;
		}
	
	.selectedTitle {
	    background-color: #E3E1E2;
	    color: black;
	    cursor:default;
	}
	
</style>
<div id="warn">
	<table width="100%" height="100%"><tr><td align="right" style="width:110px;"><img style="vertical-align:middle;" src='/images/ecology8/addWorkflow_wev8.png'></img></td><td align="left"><label style="margin-left: 5px" id="e8MsgLabel"> </label></td></tr></table>
</div>
<input type="hidden" id="showtype" name="showtype" value="<%=showType %>"/>
<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;"  >
	<tr>
		<td class="leftTypeSearch">
			<div class="topMenuTitle" style="border-bottom:none;">
				<span class="leftType" onclick="showE8TypeOption();">
					<span><img style="vertical-align:middle;" src="/images/ecology8/request/alltype_wev8.png" width="18"/></span>
				<span>
						<div id="e8typeDiv" style="width:auto;height:auto;position:relative;">
							<span id="optionSpan"><%=SystemEnv.getHtmlLabelNames(labelid,user.getLanguage())%></span>
							<span style="width:16px;height:16px;padding-left:8px;cursor:pointer;">
								<img id="e8typeImg" src="/images/ecology8/doc/down_wev8.png"/>
							</span>
						</div>
				</span>
				<span id="totalDoc"></span>
				</span>
				<span class="leftSearchSpan">
					<input type="text" class="leftSearchInput" style="width:110px;"/>
				</span>
			</div>
			
		</td>
		<td rowspan="2">
			<iframe src="<%=url%>" _isFav="<%=isFav %>" _isCommon="<%=isCommon %>" id="flowFrame" name="flowFrame" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
		</td>
	</tr>
	<tr>
		<td style="width:23%;" class="flowMenusTd">
			<div class="flowMenuDiv"  >
				<!--<div class="flowMenuAll"><span class="allText">全部&nbsp;</span></div>-->
				<div style="overflow:hidden;height:300px;position:relative;" id="overFlowDiv">
					<div class="ulDiv" id="e8treeArea"></div>
				</div>
			</div>
		</td>
	</tr>
</table>

	<ul id="e8TypeOption" class="e8TypeOption">
		<li onclick="changeShowType(this,0);">
			<span id="currentdoc" class="e8img <%=showType!=2&&showType!=3?"":"e8imgSel" %>"><img src="/images/ecology8/doc/current_wev8.png"/></span>
			<span class="e8img"><img src="/images/ecology8/doc/doc_sel_wev8.png"/></span>
			<span class="e8text"><%=SystemEnv.getHtmlLabelNames("332,32520",user.getLanguage())%></span>
		</li>
		<li onclick="changeShowType(this,2);">
			<span id="currentfav" class="e8img  <%=showType==2?"":"e8imgSel" %>"><img src="/images/ecology8/doc/current_wev8.png"/></span>
			<span class="e8img"><img src="/images/ecology8/doc/doc_sel_wev8.png"/></span>
			<span class="e8text"><%=SystemEnv.getHtmlLabelName(18030,user.getLanguage()) %></span>
		</li>
		<li onclick="changeShowType(this,3);">
			<span id="currentcom" class="e8img  <%=showType==3?"":"e8imgSel" %>"><img src="/images/ecology8/doc/current_wev8.png"/></span>
			<span class="e8img"><img src="/images/ecology8/doc/doc_sel_wev8.png"/></span>
			<span class="e8text"><%=SystemEnv.getHtmlLabelName(28183,user.getLanguage()) %></span>
		</li>
	</ul>
</body>
</html>