
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="hpc" class="weaver.homepage.cominfo.HomepageCominfo" scope="page"/>
<jsp:useBean id="pu" class="weaver.page.PageUtil" scope="page" />
<jsp:useBean id="wpc" class="weaver.admincenter.homepage.WeaverPortalContainer" scope="page"/>
<jsp:useBean id="sc" class="weaver.synergy.SynergyComInfo" scope="page"/>
<jsp:useBean id="sm" class="weaver.synergy.SynergyManage" scope="page"/>
<HTML>
<%
	String hpid = Util.null2String(request.getParameter("hpid"));
	String isset = Util.null2String(request.getParameter("isset"));
	int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
	int addpage = Util.getIntValue(request.getParameter("addpage"),-1);
	if(addpage == 0)
		hpid = (Util.getIntValue(hpid)+1)+"";
	hpid = Util.null2String((0 - Util.getIntValue(hpid,0)));
	//if(hpid.equals("0")) hpid = "-1";
	boolean isSetting = isset.equals("1")?true:false;
	//非设置模式下的逻辑
	if(!isSetting)
	{
		String samepageid = sc.getSamepageID(Util.null2String(Math.abs(Util.getIntValue(hpid))));
		if(!samepageid.equals(""))
			hpid = "-"+samepageid;
	}
	
	//此3参数暂时不做处理，门户中用来判断分权的
	int subCompanyId = Util.getIntValue(user.getUserSubCompany1()+"",-1);
	int nodelUserid=1;//pu.getHpUserId(hpid,""+tempsubid,user);
	int nodelUsertype=1;//pu.getHpUserType(hpid,""+tempsubid,user);

	String layoutid=sc.getLayoutid(Util.null2String(Math.abs(Util.getIntValue(hpid))));
	String styleid=sc.getStyleid(Util.null2String(Math.abs(Util.getIntValue(hpid))));
	String pagetype = "1";	//获取所有元素时中判断是登录后所用[门户中]
	
	String stype = Util.null2String(request.getParameter("stype"));
	String spagetype = Util.null2String(request.getParameter("pagetype"));
	String haslayout = sc.getHaslayout(Util.null2String(Math.abs(Util.getIntValue(hpid))));
	if(haslayout.equals("0")){	//在没有元素模板的情况下，需要在hplayout表里生成一条数据
		sm.addLayoutByNew(hpid,layoutid,user.getUID()+"",user.getLogintype());
		sc.removeSynergyInfoCache();
	}
	//暂时写死=1;
	int isfromportal = 1;
%>
<HEAD>
<%if(user.getLanguage()==7) {%>
	<script type='text/javascript' src='/js/weaver-lang-cn-gbk_wev8.js'></script>
<%} else if(user.getLanguage()==8) {%>
	<script type='text/javascript' src='/js/weaver-lang-en-gbk_wev8.js'></script>
<%} else if(user.getLanguage()==9) {%>
	<script type='text/javascript' src='/js/weaver-lang-tw-gbk_wev8.js'></script>
<%}%>
<%=pu.getPageJsImportStr(hpid) %>
<%=pu.getPageCssImportStr(hpid) %>
<STYLE TYPE="text/css">
.setting_button_row{
		padding-top: 5px!important;
		padding-bottom: 5px!important;
		background-color: #F6F6F6;
		border: none;
		border-top: 1px solid #dadedb;
	}
	.item a{
		text-decoration: none!important;
	}
	.header{
		background-position:left center;
	}
	.ehoverBg{
  		background:#cacaca;
  	}
  	.ehover{
  		height:25px;
  	}
  #container_Table{
  		border-collapse: collapse;
  }
  #container_Table td
  {
  		vertical-align:top;
  }
  .layouttable
  {
	margin-left:10px;
	width:99%;
  }
  	
<%=sm.getHpCss(hpid,nodelUserid,nodelUsertype,user,subCompanyId)%>;
</STYLE> 

</HEAD>
<%
String titlename = "";
%>
<BODY scroll="auto" style="overflow-x:hidden">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<% if(isSetting){%>
<table id="topTitle" cellpadding="0" cellspacing="0" >
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(84287,user.getLanguage()) %>" class="e8_btn_top"  onclick="javascript:getSetting4Otherm();"/>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table> 
<%} %>
<% if(!isSetting){%>
<div id="reldiv" style="border-color: #c3c3c3; border-bottom-width: 2px; border-bottom-style: solid; position: absolute; width: 0px; bottom: 0px; background-color: rgb(255, 255, 255); height: auto; overflow: hidden; top: 0px; right: 0px; display: block;">
<div id=relbtn  _status="0" onclick="javascript:runeffect(this)" style="text-align: center; width: 10px; background: #f6f7f9; float: left; height: 100%; color: #000; cursor: pointer; font-weight: bold; padding-top: 200px;border-left:solid 1px #c4c4c4" >
	
</div>
<%} %>
<div  style="height:100%;overflow-y:auto;overflow-x:hidden;background:#f6f7f9;">
<table id="container_Table" width="100%" style="margin">
<tr>
<%if(isSetting){ %>
	<td style="width:150px;background-color:#ebeef3;border-right:1px solid #DADADA">
	<%
	out.print(wpc.getAllElementList(pagetype,user));
	//System.out.println("wpc.getAllElementList(pagetype,user)====="+wpc.getAllElementList(pagetype,user));
	%>
	</td>
	<%} %>
	<td>
	<div id="Element_Container" style="display:block;vertical-align:top;height:100%;padding-bottom:10px">
 
	<span  id="spanContent" style="">		
		<%if(!hpid.equals("0")) {%>
			<%=sm.getHpAllElement(hpid+"",user,isSetting,requestid) %>
		<% }%>
	</span>	
</div>
	</td>
</tr>
</table>
</div>
<% if(!isSetting){%>
</div>
<%} %>
<div id='encodeHTML' style='display:none'></div>
<!-- for scrollbar -->

<SCRIPT type="text/javascript" src="/js/jscolor/jscolor_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<link rel="stylesheet" href="/js/tabs/css/e8tabs_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/templates/default/css/default2_wev8.css" type="text/css"> </link>
<script src="/js/tabs/jquery.tabs_wev8.js"></script>

<script type="text/javascript">
$(document).ready(function(){
	
	$(".ehover").bind("mouseover",function(){
		$(this).addClass("ehoverBg")
	})
	$(".ehover").bind("mouseout",function(){
		$(this).removeClass("ehoverBg")
	})
	$("#Container").css("width","99%").css("margin-left","10px");
	
	if("<%=isSetting%>" == "false")
	{
		/*if($(window.parent.document).find("._synergyBox").length > 0)
		{
			var ptop ;
			var bodyheight = jQuery(window.parent.document.body).height();
			var headHeight = 0;
			headHeight = jQuery(window.parent.document).find(".e8_boxhead").height();
			ptop = headHeight+1;
			$(window.parent.document).find("#synergy_framecontent").css("top",ptop);
			var phei = bodyheight - ptop;
			$(window.parent.document).find("#synergy_framecontent").css("height",phei);
		}else
 		$(window.parent.document).find("#synergy_framecontent").css("height",window.parent.document.body.scrollHeight);*/
 	}else
 	{
 		jQuery("#spanContent").width(document.body.clientWidth-180);
 	}
});
function copyLayoutSetforChoose(isdel,returnstr,whichtype,whichpagetype)
{
	var hpid = "<%=hpid%>";
	jQuery.ajax({
		    url: "/synergy/maintenance/SynergyCopyOperation.jsp?hpid="+hpid+"&isdel="+isdel+"&returnstr="+returnstr+"&whichtype="+whichtype+"&=spagetype=<%=spagetype%>",
		    dataType: "text", 
		    error:function(ajaxrequest){alert("<%=SystemEnv.getHtmlLabelName(84287,user.getLanguage()) %>");}, 
		    success:function(content){
		    	alert("<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage()) %>	");
		    }  
    	});
}
function getSetting4Otherm()
{
	var stype = "<%=stype%>";
	var spagetype = "<%=spagetype%>";
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/synergy/browser/Synergy4WfBrowserContent.jsp";
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(26259,user.getLanguage()) %>";
	if(stype=="wf" && spagetype=="menu")
	{
		url = "/synergy/browser/Synergy4WfMenuBrowserContent.jsp";
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(84293,user.getLanguage()) %>";
	}
	if(stype === "doc")
	{
		if(spagetype == "menu")
		{
			url = "/synergy/browser/Synergy4DocMenuBrowserContent.jsp";
			dialog.Title = "<%=SystemEnv.getHtmlLabelName(84294,user.getLanguage()) %>";
		}else
		{
			url = "/synergy/browser/Synergy4DocBrowserContent.jsp";
			dialog.Title = "<%=SystemEnv.getHtmlLabelName(84296,user.getLanguage()) %>";
		}
	}
	
	dialog.Width = 450;
	dialog.Height = 500;
	dialog.Drag = true; 	
	dialog.URL = url;
	dialog.show();
}

function showTabs(eid,tabid){
	if(tabid=="tabContent"){
		jQuery("#weavertabs-content-"+eid).show();
		jQuery("#weavertabs-style-"+eid).hide();
		jQuery("#weavertabs-share-"+eid).hide();
		jQuery("#weavertabs-param-"+eid).hide();
	}else if(tabid=="tabStyle"){
		jQuery("#weavertabs-style-"+eid).show();
		jQuery("#weavertabs-share-"+eid).hide();
		jQuery("#weavertabs-content-"+eid).hide();
		jQuery("#weavertabs-param-"+eid).hide();
	}else if(tabid=="tabShare"){
		jQuery("#weavertabs-share-"+eid).show();
		jQuery("#weavertabs-content-"+eid).hide();
		jQuery("#weavertabs-style-"+eid).hide();
		jQuery("#weavertabs-param-"+eid).hide();
	}else if(tabid=="tabSynergy")
	{
		jQuery("#weavertabs-share-"+eid).hide();
		jQuery("#weavertabs-content-"+eid).hide();
		jQuery("#weavertabs-style-"+eid).hide();
		jQuery("#weavertabs-param-"+eid).show();
	}
}
var myin;
function runeffect(obj)
{
	var _status = jQuery(obj).attr("_status");
	var _w = "421px";
	var _r = "410px";
	
	if(_status==1){
		_w = "0px";
		_r = "0px";
		jQuery(obj).attr("_status",0);
	}else{
		jQuery(obj).attr("_status",1);
		$(window.parent.document).find("#synergy_framecontent").css("width",_w);
	}
	
	jQuery($(window.parent.document).find("#synergy_moveDiv")).animate({right:_r},300,null,function(){
		if(_status==1)
		{
			$(this).find("img").attr("src","/page/resource/userfile/image/synergy/left_wev8.png");
			$(this).attr("title","<%=SystemEnv.getHtmlLabelName(31835,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(32832,user.getLanguage()) %>");
			window.clearInterval(myin);
			if($(window.parent.document).find("._synergyBox").length > 0)
			{
				$(window.parent.document.body).css("overflow-y","hidden");
			}else
				$(window.parent.document.body).css("overflow-y","auto");
			
		}
		else
		{
			$(this).find("img").attr("src","/page/resource/userfile/image/synergy/right_wev8.png");
			$(this).attr("title","<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(32832,user.getLanguage()) %>");
			var abc=0;
			myin = window.setInterval(function(){
				if(abc>40)
				{
					window.clearInterval(myin);
				}else
				{
					setScroll();
				}
				abc++;
			},500);
			
		}
	});
	jQuery("#reldiv").animate({ width:_w},300,null,function(){
		if(_status==1)
			$(window.parent.document).find("#synergy_framecontent").css("width",_w);
	});
	
}

function setScroll()
{
	if($(window.parent.document).find("._synergyBox").length > 0)
	{
		var ptop ;
		var bodyheight = jQuery(window.parent.document.body).height();
		var headHeight = 0;
		headHeight = jQuery(window.parent.document).find(".e8_boxhead").height();
		ptop = headHeight+1;
		$(window.parent.document).find("#synergy_framecontent").css("top",ptop);
		var phei = bodyheight - ptop;
		$(window.parent.document).find("#synergy_framecontent").css("height",phei);
	}else
	{
		var parentheight = window.parent.document.body.scrollHeight;
		var contentheight = $("#Element_Container")[0].scrollHeight;
		if(parentheight > contentheight)
		{
			$(window.parent.document).find("#synergy_framecontent").css("height",parentheight);
			$(window.parent.document).find("#synergy_framecontent").css("top","0px");
			//$("#Element_Container").css("overflow-y","hidden");
			$(window.parent.document.body).css("overflow-y","auto");
		}else
		{
			var isChrome=navigator.userAgent.indexOf("Chrome")==-1?false:true;
			var ptop ;
			if(isChrome)
				ptop = window.parent.document.body.scrollTop;
			else
				ptop = window.parent.document.documentElement.scrollTop + "px";
			var phei = window.parent.document.body.offsetHeight;
			$(window.parent.document).find("#synergy_framecontent").css("top",ptop);
			$(window.parent.document).find("#synergy_framecontent").css("height",phei);
			//$("#Element_Container").css("overflow-y","auto");
			$(window.parent.document.body).css("overflow-y","hidden");
		}
	}
}


function onAddElement(ebaseid,styleid){
	var hpid="<%=hpid%>";
	var hpstyleid = "<%=styleid%>";
	var suffix = $(".item").length + 1;
	
	if(suffix > 6) 
	{
		var i = 0; 
		i = Math.floor(suffix / 6);
		
		suffix = suffix - 6 * i;
	}
	hpstyleid = hpstyleid + suffix;
	if(hpstyleid!="") styleid = hpstyleid;
	if($(".item").length==10){
		if(confirm("<%=SystemEnv.getHtmlLabelName(84090,user.getLanguage()) %>")){
			url="/synergy/maintenance/SynergyElementPreview.jsp?ebaseid="+ebaseid+"&styleid="+styleid+"&hpid=<%=hpid%>&subCompanyId=<%=subCompanyId%>&fromModule=synergy&layoutflag=A";	
			GetContent("divInfo",url,true);
		}
	}else{
		url="/synergy/maintenance/SynergyElementPreview.jsp?ebaseid="+ebaseid+"&styleid="+styleid+"&hpid=<%=hpid%>&subCompanyId=<%=subCompanyId%>&fromModule=synergy&layoutflag=A";	
		GetContent("divInfo",url,true);
	}
}

function  GetContent(divObj,url,isAddElement,code,isNeedRefresh){
	var msg=SystemEnv.getHtmlNoteName(3494,this.languageid);
	divObj.innerHTML="<img src=/images/loading2_wev8.gif> "+msg+"...";
	//return;
	var xmlHttp = XmlHttp.create();
	xmlHttp.open("GET",url, true);
	xmlHttp.onreadystatechange = function () {
		switch (xmlHttp.readyState) {
           case 3 :
        	   var msg=SystemEnv.getHtmlNoteName(3495,this.languageid);
			    divObj.innerHTML="<img src=/images/loading2_wev8.gif> "+msg+"...";
		        break;
		   case 4 :
		       if(isAddElement){
			       	$(".group[areaflag='A']").prepend(xmlHttp.responseText);
			       	try{
			       		$(".group[areaflag='A']").children("div:first").bind("reload",function(){
			       			elementReload($(this).attr("ebaseid"),$(this).attr("eid"),$(this).attr("cornerTop"),$(this).attr("cornerBottom"));
			       		});
			       		
			       		$(".group[areaflag='A']").children("div:first").trigger("reload");	
			       		
					    //var eid=$(".group[areaflag='A']").children("div:first").attr("eid");					    
				       	//var jsCode = $("#content_js_"+eid).html();
						//eval(jsCode)			       
			       	}catch(e){
			       		//alert(e.name)
			       	} 
			   } else {
				   divObj.innerHTML =xmlHttp.responseText;
			   }
			   if(isNeedRefresh!=undefined){
				   window.location.reload();
			   }
		       if(xmlHttp.status < 400)   if(code!=null&&code!="") eval(code);
               break;
		}
	}
	xmlHttp.setRequestHeader("Content-Type","text/xml")
	xmlHttp.send(null);
}

function onDel(eid){	
    if(!confirm("<%=SystemEnv.getHtmlLabelName(19747,user.getLanguage())%>")) return;

    var group=$($("#item_"+eid).parents(".group")[0]);
    var flag=group.attr("areaflag");
    var eids="";
    
    $(group).children("div .item").each(function(){
        if($(this).attr("eid")!=eid)  	eids+=$(this).attr("eid")+",";
    });
    $.get("/homepage/element/EsettingOperate.jsp",
    	  {method: "delElement", hpid: "<%=hpid%>",eid:eid,delFlag:flag,delAreaElement:eids,subCompanyId:"<%=subCompanyId%>"},
		  function(data){		  	  
    		  if($.trim(data)=="") 	{
    		  	$("#item_"+eid).remove();
    		  } else {
    		  	alert($.trim(data))
    		  }
		  }
    );
}

function MoveEData(srcFlag,targetFlag){

	var srcItemEids=""; 
	$(".group[areaflag="+srcFlag+"]>.item").each(function(i){
		if(this.className=="item")	{
			srcItemEids+=$(this).attr("eid")+",";
		}
	})
	
	var targetItemEids="";   
	$(".group[areaflag="+targetFlag+"]>.item").each(function(i){
		if(this.className=="item")	{
			targetItemEids+=$(this).attr("eid")+",";
		}
	})  

	var url="/homepage/element/EsettingOperate.jsp?method=editLayout&hpid=<%=hpid%>&subCompanyId=<%=subCompanyId%>&srcFlag="+srcFlag+"&targetFlag="+targetFlag+"&srcStr="+srcItemEids+"&targetStr="+targetItemEids;		
	GetContent("divInfo",url,false);	
	
}

var randomValue;
function onSetting(eid,ebaseid){
	
	
	//获取设置页面内容
	var settingUrl="/synergy/maintenance/SynergyElementSetting.jsp?pagetype=<%=pagetype%>&eid="+eid+"&ebaseid="+ebaseid+"&hpid=<%=hpid%>&subcompanyid=<%=subCompanyId%>&stype=<%=stype%>&spagetype=<%=spagetype%>&addpage=<%=addpage%>";
	
	$.post(settingUrl, null,
		function(data){
		  if($.trim(data)!="") 	{
		  	  $("#setting_"+eid).hide();	
		  	  $("#setting_"+eid).remove(); 
		  	  $("#content_"+eid).prepend($.trim(data))
		  	  //$("#setting_"+eid+" .weavertabs").weavertabs({selected:0});
				
				$(".tabs").Tabs({
			        getLine:1,
			        topHeight:40
			    });
			    $(".tab_box").height(0);
				$("#setting_"+eid).show();	
				$("#weavertabs-content-"+eid).show();
				
				$("#setting_"+eid).show();	
				var urlContent=$.trim($("#weavertabs-content-"+eid).attr("url")).replace(/&amp;/g,"&");
				var urlStyle=$.trim($("#weavertabs-style-"+eid).attr("url")).replace(/&amp;/g,"&");
				var urlParam=$.trim($("#weavertabs-param-"+eid).attr("url")).replace(/&amp;/g,"&");
				var urlShare=$.trim($("#weavertabs-share-"+eid).attr("url")).replace(/&amp;/g,"&");	
				
				//alert(document.getElementById("weavertabs-content-"+eid));
				if(urlContent!="") {
					if(ebaseid==7||ebaseid==8||ebaseid==1||ebaseid=='news'||ebaseid==29){
						//randomValue =Math.round(Math.random()*(100-1)+1)
						randomValue = new Date().getTime();
						$("#setting_"+eid).attr("randomValue",randomValue);
					}
					urlContent = urlContent+"&random="+randomValue;
					$("#weavertabs-content-"+eid).html("")
					$("#weavertabs-content-"+eid).html("<img src=/images/loading2_wev8.gif> <%=SystemEnv.getHtmlLabelName(19611,user.getLanguage())%>...");
					$("#weavertabs-content-"+eid).load(urlContent,{},function(){
						//alert($("#weavertabs-content-"+eid).html())
						//$("#tabDiv_"+eid).dialog('destroy');
						$(".filetree").filetree();
						$(".vtip").simpletooltip();
						fixedPosition(eid);
						jscolor.init();
					});
				}
				if(urlStyle!="") $("#weavertabs-style-"+eid).load(urlStyle,{},function(){
					
					var checkimg=$("#eLogo_"+eid).attr("value");
					$("#weavertabs-style-"+eid+" .filetree").filetree({"file":checkimg});
					//$("#weavertabs-style-"+eid+" .filetree").filetree();
					
				});
				
				if(urlParam!="") $("#weavertabs-param-"+eid).load(urlParam,{},function(){
					
				});
				
				
				if(urlShare!="") $("#weavertabs-share-"+eid).load(urlShare,{},function(){
					//$("#weavertabs-share-"+eid+" .filetree").filetree();
					
				});
   		  }
   		  
	});
}

/*修改相应元素位置 到到相应的元素下去*/
function fixedPosition(eid){	
	//jQuery("#Element_Container").perfectScrollbar('update');
}

function docParamSetting(eid,ebaseid){
	var sharelevel=$("input[name=_esharelevel_"+eid+"]").val();
	var ePerpageValue=5;
 	var dlg=new window.top.Dialog();//定义Dialog对象
	dlg.Model=true;
	dlg.Width=550;//定义长度
	dlg.Height=360;
	dlg.URL="/synergy/maintenance/SynergyElementSet4Param.jsp?eid="+eid+"&ebaseid="+ebaseid+"&esharelevel="+sharelevel+"&subCompanyId=<%=subCompanyId%>&hpid=<%=hpid%>&stype=<%=stype%>&spagetype=<%=spagetype%>&saddpage=<%=addpage%>";
	dlg.Title="<%=SystemEnv.getHtmlLabelName(84299,user.getLanguage()) %>";
	dlg.callbackfun=function(datas){
		if(datas){
			if(datas != ""){
				datas = "SynergyParamXML:'"+datas+"'";
			}
			datas = "var postObj = {"+datas+"}";
			eval(datas)
			$.post('/synergy/browser/operationCommon.jsp?eid='+eid+'&ebaseid='+ebaseid+'&esharelevel='+sharelevel+'&ePerpageValue='+ePerpageValue+'&hpid=<%=hpid%>&stype=<%=stype%>&spagetype=<%=spagetype%>&saddpage=<%=addpage%>', postObj,				  
					function(data){
						  if($.trim(data)=="") 	{
							  //$("#setting_"+eid).hide();
							  //$("#setting_"+eid).remove(); 
							  if(ebaseid=="news"||parseInt(ebaseid)==7||parseInt(ebaseid)==1||parseInt(ebaseid)==29){
							  	 $.post('/page/element/compatible/NewsOperate.jsp',{method:'submit',eid:eid},function(data){
							  	 	if($.trim(data)==""){
							  	 		//$("#item_"+eid).attr('needRefresh','true')
							  	 		//$("#item_"+eid).trigger("reload");
							  	 	}
							  	 });
							  }else{
							  	 //$("#item_"+eid).attr('needRefresh','true')
							  	 //$("#item_"+eid).trigger("reload");
							  }
			    		  }
					}
			);
		}
		dlg.close();
	}
	dlg.show();
}


function synParamSetting(eid,ebaseid){
	var sharelevel=$("input[name=_esharelevel_"+eid+"]").val();
	var ePerpageValue=5;
 	var dlg=new window.top.Dialog();//定义Dialog对象
	dlg.Model=true;
	dlg.Width=550;//定义长度
	dlg.Height=360;
	dlg.URL="/synergy/maintenance/SynergyElementSet4Param.jsp?eid="+eid+"&ebaseid="+ebaseid+"&esharelevel="+sharelevel+"&subCompanyId=<%=subCompanyId%>&hpid=<%=hpid%>&stype=<%=stype%>&spagetype=<%=spagetype%>&saddpage=<%=addpage%>";
	dlg.Title="<%=SystemEnv.getHtmlLabelName(84299,user.getLanguage()) %>";
	dlg.callbackfun=function(datas){
		if(datas){
			if(datas != ""){
				datas = "SynergyParamXML:'"+datas+"'";
			}
			datas = "var postObj = {"+datas+"}";
			eval(datas)
			$.post('/synergy/browser/operationCommon.jsp?eid='+eid+'&ebaseid='+ebaseid+'&esharelevel='+sharelevel+'&ePerpageValue='+ePerpageValue+'&hpid=<%=hpid%>&stype=<%=stype%>&spagetype=<%=spagetype%>&saddpage=<%=addpage%>', postObj,				  
					function(data){
						  if($.trim(data)=="") 	{
							  //$("#setting_"+eid).hide();
							  //$("#setting_"+eid).remove(); 
							  if(ebaseid=="news"||parseInt(ebaseid)==7||parseInt(ebaseid)==1||parseInt(ebaseid)==29){
							  	 $.post('/page/element/compatible/NewsOperate.jsp',{method:'submit',eid:eid},function(data){
							  	 	if($.trim(data)==""){
							  	 		//$("#item_"+eid).attr('needRefresh','true')
							  	 		//$("#item_"+eid).trigger("reload");
							  	 	}
							  	 });
							  }else{
							  	 //$("#item_"+eid).attr('needRefresh','true')
							  	 //$("#item_"+eid).trigger("reload");
							  }
			    		  }
					}
			);
		}
		dlg.close();
	}
	dlg.show();
}
 
function showSynParamSetting2Wf(eid,tabid,ebaseid){
	var ePerpageValue=5;
	var sharelevel=$("input[name=_esharelevel_"+eid+"]").val();
 	var dlg=new window.top.Dialog();//定义Dialog对象
	dlg.Model=true;
	dlg.Width=550;//定义长度
	dlg.Height=360;
	dlg.URL="/synergy/maintenance/SynergyElementSet4Wf.jsp?eid="+eid+"&ebaseid="+ebaseid+"&tabid="+tabid+"&esharelevel="+sharelevel+"&subCompanyId=<%=subCompanyId%>&hpid=<%=hpid%>&stype=<%=stype%>&spagetype=<%=spagetype%>&saddpage=<%=addpage%>";
	console.log("dlg.URL:"+dlg.URL);
	dlg.Title="<%=SystemEnv.getHtmlLabelName(84301,user.getLanguage()) %>";
	dlg.callbackfun=function(datas){
		if(datas){
			if(datas != ""){
				datas = "SynergyParamXML:'"+datas+"'";
			}
			datas = "var postObj = {"+datas+"}";
			eval(datas)
			$.post('/synergy/browser/operationCommon.jsp?eid='+eid+'&ebaseid='+ebaseid+'&tabid='+tabid+'&esharelevel='+sharelevel+'&ePerpageValue='+ePerpageValue+'&hpid=<%=hpid%>&stype=<%=stype%>&spagetype=<%=spagetype%>&saddpage=<%=addpage%>', postObj,				  
					function(data){
						  if($.trim(data)=="") 	{
							  //$("#setting_"+eid).hide();
							  //$("#setting_"+eid).remove(); 
							  if(ebaseid=="news"||parseInt(ebaseid)==7||parseInt(ebaseid)==1||parseInt(ebaseid)==29){
							  	 $.post('/page/element/compatible/NewsOperate.jsp',{method:'submit',eid:eid},function(data){
							  	 	if($.trim(data)==""){
							  	 		//$("#item_"+eid).attr('needRefresh','true')
							  	 		//$("#item_"+eid).trigger("reload");
							  	 	}
							  	 });
							  }else{
							  	 //$("#item_"+eid).attr('needRefresh','true')
							  	 //$("#item_"+eid).trigger("reload");
							  }
			    		  }
					}
			);
		}
		dlg.close();
	}
	dlg.show();
}

/**
	添加Tab页
*/
function addTab(eid,url,ebaseid){
	
	var tabCount = $("#tabDiv_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).attr("tabCount");
	tabCount = parseInt(tabCount);
	tabCount++;
	
	var url = $("#tabDiv_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).attr("url");
	url+="&tabId="+tabCount
	showTabDailog(eid,'add',tabCount,url,ebaseid)
}

/**
	删除Tab页
*/
function deleTab(eid,tabId,ebaseid){
	var formAction="";
	if(parseInt(ebaseid)==8){
		formAction ="/homepage/element/setting/WorkflowCenterOpration.jsp";
	}else if(ebaseid=="news"||parseInt(ebaseid)==7||parseInt(ebaseid)==1||parseInt(ebaseid)==29){
		formAction ="/page/element/compatible/NewsOperate.jsp";
	}
	
	var para = {method:'delete',eid:eid,tabId:tabId};
	$.post(formAction,para,function(data){
		if($.trim(data)==""){
			$("#tab_"+eid+"_"+tabId).parent().parent().remove();
		}
	});
	
}
/**
	编辑Tab页
*/
function editTab(eid,tabId,ebaseid){
	
	var url = $("#tabDiv_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).attr("url");
	var tabTitle = $("#tab_"+eid+"_"+tabId).attr("tabTitle");
	tabTitle = encodeURIComponent(encodeURIComponent(tabTitle));
	url+="&tabId="+tabId+"&tabTitle="+tabTitle;
	if(ebaseid=="news" || parseInt(ebaseid)==7||parseInt(ebaseid)==1||parseInt(ebaseid)==29){
		var tabWhere = $("#tab_"+eid+"_"+tabId).attr("tabWhere");
		url+="&value="+tabWhere;
	}else{
		var showCopy = $("#tab_"+eid+"_"+tabId).attr("showCopy");
		url+="&showCopy="+showCopy;
	}
	showTabDailog(eid,"edit",tabId,url,ebaseid)
}

function doTabSave(eid,ebaseid,tabId,method){
	//console.log(eid+":"+ebaseid+":"+tabId+":"+method);
	// 准备Tab页条件数据
	var tabDocument = tab_dialog.innerDoc
	var tabWindow = tab_dialog.innerWin
	var whereKeyStr="";
	var showCopy="1";
	var formParams ={};
	var formAction ="";
	var tabTitle ="";
	var displayTitle="";
	if(parseInt(ebaseid)==8){
		$(tabDocument).find("#ifrmViewType_"+eid).contents().find("#btnSave").trigger("click")
		formAction =$(tabDocument).find("#ifrmViewType_"+eid).contents().find("#frmFlwCenter").attr("action")
		tabTitle = $(tabDocument).find("#tabTitle_"+eid).attr("value")
		
		displayTitle = $("#encodeHTML").text(tabTitle).html();
		$(tabDocument).find("#ifrmViewType_"+eid).contents().find("#frmFlwCenter").find("#tabTitle").attr("value",tabTitle);
		$(tabDocument).find("#ifrmViewType_"+eid).contents().find("#frmFlwCenter").find("#tabId").attr("value",tabId);
		$(tabDocument).find("#ifrmViewType_"+eid).contents().find("#frmFlwCenter").find("#method").attr("value",method);
		formParams = $(tabDocument).find("#ifrmViewType_"+eid).contents().find("#frmFlwCenter").serializeArray();
		if($(tabDocument).find("#showCopy_"+eid).attr("checked")){
			showCopy = "1"
		}else{
			showCopy = "0"
		}
		$(tabDocument).find("#ifrmViewType_"+eid).contents().find("#frmFlwCenter").find("#showCopy").attr("value",showCopy);
		formAction ="/homepage/element/setting/"+formAction;
	}else if(ebaseid=="news" || parseInt(ebaseid)==7||parseInt(ebaseid)==1||parseInt(ebaseid)==29){
		formAction ="/page/element/compatible/NewsOperate.jsp";
		tabTitle =$(tabDocument).find("#tabTitle_"+eid).attr("value")
		displayTitle = $("#encodeHTML").text(tabTitle).html();
		
		whereKeyStr = tabWindow.getNewsSettingString(eid);
		formParams ={eid:eid,tabId:tabId,tabTitle:tabTitle,tabWhere:whereKeyStr,method:method};
	}
	if(tabTitle==''){
		alert('<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>')
		return false;		
	}
	//console.log("formAction"+formAction);
	$.post(formAction,formParams,function(data){
		//console.log("data"+data);
		if($.trim(data)==""){
				if(method=='add'){
					$("#tabSetting_"+eid+">tbody").append("<TR><TD><span id = tab_"+eid+"_"+tabId+" tabId='"+tabId+"' tabTitle='' tabWhere='"+whereKeyStr+"' showCopy='"+showCopy+"'></span></TD><TD width=100 lign='right'><a href='javascript:deleTab("+eid+","+tabId+",\""+ebaseid+"\")'><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>&nbsp;&nbsp;<a href='javascript:editTab("+eid+","+tabId+",\""+ebaseid+"\")'><%=SystemEnv.getHtmlLabelName(22250,user.getLanguage())%></a>&nbsp;&nbsp;<a href='javascript:showSynParamSetting2Wf("+eid+","+tabId+",\""+ebaseid+"\")'><%=SystemEnv.getHtmlLabelName(561,user.getLanguage())%></a></TD></TR>")
					$("#tabDiv_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).attr("tabCount",tabId);
					$("#tab_"+eid+"_"+tabId).html(displayTitle);
					$("#tab_"+eid+"_"+tabId).attr("tabTitle",tabTitle);
				}else{
					$("#tab_"+eid+"_"+tabId).html(displayTitle);
					$("#tab_"+eid+"_"+tabId).attr("tabTitle",tabTitle);
					$("#tab_"+eid+"_"+tabId).attr("showCopy",showCopy);
					$("#tab_"+eid+"_"+tabId).attr("tabWhere",whereKeyStr);
				}
				tab_dialog.close();
   		  } else {
   		  		tab_dialog.close();
   		  }
	});

}

/**
	打开对话框
*/
var tab_dialog ;
function showTabDailog(eid,method,tabId,url,ebaseid){
	var whereKeyStr="";
	var showCopy="1";
	// 更换弹出窗口为zDialog
	if(true){
		tab_dialog = new window.top.Dialog();
		tab_dialog.currentWindow = window;   //传入当前window
	 	tab_dialog.Width = 630;
	 	tab_dialog.Height = 500;
	 	tab_dialog.Modal = true;
	 	tab_dialog.Title = "<%=SystemEnv.getHtmlLabelName(19480,user.getLanguage()) %>"; 
	 	tab_dialog.URL = url+"&ebaseid="+ebaseid+"&method="+method;
	 	tab_dialog.show();
		return;
	}
}
function onNoUseSetting(eid,ebaseid){

 if(ebaseid=="news"||parseInt(ebaseid)==7||parseInt(ebaseid)==1){
  	 $.post('/page/element/compatible/NewsOperate.jsp',{method:'cancel',eid:eid},function(data){
  	 	if($.trim(data)==""){
  	 		//$("#item_"+eid).attr('needRefresh','true')
  	 		//$("#item_"+eid).trigger("reload");
  	 	}
  	 });
  }else if(parseInt(ebaseid)==8){
  		var formAction ="/homepage/element/setting/WorkflowCenterOpration.jsp";
    	$.ajax({
                url :formAction,
                data:{method:'cancel',eid:eid},
                cache : false, 
                async : false,
                type : "post",
                dataType : 'json',
                success : function (result){
                	
                }
            });
  }
 $("#setting_"+eid).hide();
 $("#setting_"+eid).remove();
 fixedPosition(eid);
}
function onUseSetting(eid,ebaseid){		
	if(ebaseid==8) { /*对流程中心元素进行特殊处理*/
		doWorkflowEleSet(eid);
		//return; 
	}	
	/*对知识订阅元素进行特殊处理*/
	if(ebaseid==34){
		var begin = document.getElementById("begindate_"+eid).value;
		var end = document.getElementById("enddate_"+eid).value;
		if(begin != "" && end != ""){
			if(begin > end){
				alert("<%=SystemEnv.getHtmlLabelName(24569,user.getLanguage())%>");
				return;
			}
		}
	}
	//common部分处理
	var ePerpageValue=5;
	var eShowMoulde='0';
	var eLinkmodeValue ='';
	var esharelevel = '';
	try{
		if(document.getElementById("_ePerpage_"+eid)!=null){
	    	ePerpageValue=$("#_ePerpage_"+eid).val();
	    }
	    if(document.getElementById("_eShowMoulde_"+eid)!=null){
	    	eShowMoulde=document.getElementById("_eShowMoulde_"+eid).value;
	    }
	    if(document.getElementById("_eLinkmode_"+eid)!=null){
	    	eLinkmodeValue=$("#_eLinkmode_"+eid).val();
	    }
	    
		esharelevel=$("input[name=_esharelevel_"+eid+"]").val();
	} catch(e){
	}
		var eFieldsVale="";
		var chkFields=document.getElementsByName("_chkField_"+eid);
		
		if (chkFields!=null){
			for(var i=0;i<chkFields.length;i++){
				var chkField=chkFields[i];
				if(chkField.checked) eFieldsVale+=chkField.value+",";
			}
			
			if(eFieldsVale!="") eFieldsVale=eFieldsVale.substring(0,eFieldsVale.length-1);
		}
		var imsgSizeStr ="";
		if($("input[name=_imgWidth"+eid+"]").val()){
			
			var imgWidth = $("input[name=_imgWidth"+eid+"]").val();
			var imgHeight = $("input[name=_imgHeight"+eid+"]").val();
			
			if(imgWidth.replace(/(^\s*)|(\s*$)/g, "") == ""){
				imgWidth = "0";
			}
			if(imgHeight.replace(/(^\s*)|(\s*$)/g, "")==""){
				imgHeight = "0";
			}
			var imgSize = imgWidth+"*"+imgHeight;
			
			imsgSizeStr = "imgSize_"+$("input[name=_imgWidth"+eid+"").attr("basefield");
		}
		
		var imgType=0;
		var imgSrc = "";
		if(document.getElementById("_imgType"+eid)!=null){
			imgType=document.getElementById("_imgType"+eid).value;
			
			if(imgType==1){
				imgSrc = $("#_imgsrc"+eid).val();
			}
		}
		
		//得到上传时的字数标准
		
		var newstemplateStr = "";
		if(document.getElementById("_newstemplate"+eid)!=null){
			newstemplateStr = document.getElementById("_newstemplate"+eid).value
		}
		var eTitleValue="";
		var whereKeyStr="";
		if(esharelevel=="2"){
			var eTitleValue=document.getElementById("_eTitel_"+eid).value;
			var _whereKeyObjs=document.getElementsByName("_whereKey_"+eid);
			if(eTitleValue.indexOf('%')!=-1) {
				//alert("<%=SystemEnv.getHtmlLabelName(20858,user.getLanguage())%>");
				//return;
			}
			//alert(escape(eTitleValue));
			$("#title_"+eid).html(eTitleValue.replace(/ /gi,"&nbsp;"));
			eTitleValue = eTitleValue.replace(/\\/g,"\\\\");
			eTitleValue = eTitleValue.replace(/'/g,"\\'");
			eTitleValue = eTitleValue.replace(/"/g,"\\\"");
			if(ebaseid == 'notice'){
				onchanges(eid);
			}
			//newstr=newstr.replace(/&/g,"',");
			//eTitleValue = $("#title_"+eid).html();	
			//eTitleValue = escape(eTitleValue)		
			//得到上传的SQLWhere语句
			for(var k=0;k<_whereKeyObjs.length;k++){
				var _whereKeyObj=_whereKeyObjs[k];	
				if(_whereKeyObj.tagName=="INPUT" && _whereKeyObj.type=="checkbox" &&! _whereKeyObj.checked) continue;
				if(ebaseid=='reportForm'){
					if(_whereKeyObj.tagName=="INPUT" && _whereKeyObj.type=="radio" &&! _whereKeyObj.checked) continue;			
				}
				whereKeyStr+=_whereKeyObj.value+"^,^";			
			}
		}
		
		if(whereKeyStr!="") whereKeyStr=whereKeyStr.substring(0,whereKeyStr.length-3);	
		
		whereKeyStr = whereKeyStr.replace(/'/g,"\\'");

		//仅对多文档中心元素进行此处理，修正td21552
		if(whereKeyStr != null && $.trim(whereKeyStr) != ""&&ebaseid=='17'){
			var whereStr = $.trim(whereKeyStr).split('^,^');
			if(whereStr[1] != null && whereStr[1] != "" && whereStr[1].length != 0) {
				$("#more_"+eid).attr("href","javascript:openFullWindowForXtable('/page/element/compatible/more.jsp?ebaseid="+ebaseid+"&eid="+eid+"')");
				$("#more_"+eid).attr("morehref","/page/element/compatible/more.jsp?ebaseid="+ebaseid+"&eid="+eid);
			}else{
				$("#more_"+eid).attr("href","#");
				$("#more_"+eid).attr("morehref","");
			}
		}

		
		var scolltype = "";
		if(document.getElementsByName("_scolltype"+eid).length>0){
			scolltype=document.getElementsByName("_scolltype"+eid)[0].value;
			//whereKeyStr+="^,^"+scolltype;
			
		}
	
		//alert(scolltype);
		//eTitleValue=eTitleValue.replace(/&/g, "%26");//把eTitleValue中的&换成%26;
		//eTitleValue = encodeURIComponent(eTitleValue)
		//alert(eTitleValue) 
		//用户自定义元素内容部分
		
		//相关的样式设置部分
		var eLogo=$("#eLogo_"+eid).val();
		var eStyleid=$("#eStyleid_"+eid).val();	
		var eHeight=$("#eHeight_"+eid).val();	
		var eMarginTop=$("#eMarginTop_"+eid).val();
		var eMarginBottom=$("#eMarginBottom_"+eid).val();
		var eMarginLeft=$("#eMarginLeft_"+eid).val();
		var eMarginRight=$("#eMarginRight_"+eid).val();	
		
		//相关的共享设置部分
		var operationurl=$.trim($("#setting_"+eid).attr("operationurl")).replace(/&amp;/g,"&");
		//log(operationurl)
		//alert(eid)
		var postStr = "eid:'"+eid+"',eShowMoulde:'"+eShowMoulde+"',ebaseid:'"+ebaseid+"',eTitleValue:'"+eTitleValue+"',ePerpageValue:'"+ePerpageValue+"',eLinkmodeValue:'"+eLinkmodeValue+"',";
			postStr	+="eFieldsVale:'"+eFieldsVale+"',imgSizeStr:'"+imgSize+"',whereKeyStr:'"+whereKeyStr+"',esharelevel:'"+esharelevel+"',hpid:'"+'<%=hpid%>'+"',subCompanyId:'"+'<%=subCompanyId%>'+"',";
			postStr	+="eLogo:'"+eLogo+"',eStyleid:'"+eStyleid+"',eHeight:'"+eHeight+"',newstemplate:'"+newstemplateStr+"',imgType:'"+imgType+"',imgSrc:'"+imgSrc+"',eScrollType:'"+scolltype+"',"
			postStr	+="eMarginTop:'"+eMarginTop+"',eMarginBottom:'"+eMarginBottom+"',eMarginLeft:'"+eMarginLeft+"',eMarginRight:'"+eMarginRight+"'";
		
		var wordcountStr="";
		var _wordcountObjs=document.getElementsByName("_wordcount_"+eid);

		for(var j=0;j<_wordcountObjs.length;j++){
			var wordcountObj=_wordcountObjs[j];
			var basefield=$(wordcountObj).attr("basefield");
			wordcountStr+="&wordcount_"+basefield+"="+wordcountObj.value;
			postStr+=",wordcount_"+basefield+":'"+wordcountObj.value+"'";
		}
		var newstr = $("#setting_form_"+eid).serialize();

		newstr=newstr.replace(/&/g,"',");

		newstr=newstr.replace(/=/g,":'");
		newstr=newstr.replace(/%2F/g,"/");
		newstr = newstr.replace(/%3A/g,":");
		newstr = decodeURIComponent (newstr);
		
		if(ebaseid == "weather") {
			var weatherWidth;       
			var wWidth = $("#content_view_id_"+eid).width(); 
			if(newstr != null && newstr != "" && newstr.length != 0) {
				var weatherWidth = newstr.substring(newstr.lastIndexOf("'")+1);    
				var reg=new RegExp("[\+\]","g");
				weatherWidth=weatherWidth.replace(reg,"");     
				if(weatherWidth == null || 
						weatherWidth == "" || 
						isNaN(weatherWidth) || 
						parseFloat(weatherWidth) > parseFloat(wWidth) || 
						parseFloat(weatherWidth) <= 0) {   
					var lNewStr = newstr.substring(0,newstr.lastIndexOf("'")+1);
					newstr = lNewStr+wWidth;
				}else{
					var lNewStr = newstr.substring(0,newstr.lastIndexOf("'")+1);
					newstr = lNewStr+weatherWidth;
				}
			}
		}
		
		if(newstr!=""){
			postStr = postStr+","+newstr+"'";
		}
		//alert(encodeURI(postStr))
		//if(ebaseid==8 || ebaseid==7)
		//{
		//	var paramstr = $("#sepframe_"+eid)[0].contentWindow.saveSynergyParam();
		//	//alert(paramstr);
		//	if(paramstr != "")
		//		postStr += ",SynergyParamXML:'"+paramstr+"'";
		//}
		postStr = "var postObj = {"+postStr+"}";
		
		eval(postStr)
		$.post(operationurl, postObj,				  
				function(data){
					  if($.trim(data)=="") 	{
						  $("#setting_"+eid).hide();
						  $("#setting_"+eid).remove(); 
						  if(ebaseid=="news"||parseInt(ebaseid)==7||parseInt(ebaseid)==1||parseInt(ebaseid)==29){
						  	 $.post('/page/element/compatible/NewsOperate.jsp',{method:'submit',eid:eid},function(data){
						  	 	if($.trim(data)==""){
						  	 		$("#item_"+eid).attr('needRefresh','true')
						  	 		$("#item_"+eid).trigger("reload");
						  	 	}
						  	 });
						  }else{
						  	 $("#item_"+eid).attr('needRefresh','true')
						  	 $("#item_"+eid).trigger("reload");
						  }
		    		  }
				}
		);
		
		if(window.frames["eShareIframe_"+eid]&&esharelevel=="2"){
			window.frames["eShareIframe_"+eid].document?window.frames["eShareIframe_"+eid].document.getElementById("frmAdd_"+eid).submit():"";	
		}
		
		if(ebaseid == "menu") {
			setTimeout(function rload(){
				location.reload();
			},200);
		}
		
		//元素共享设置提交
		
			
	 //} catch(e){
	//	 alert(e)
	 //}
	fixedPosition(eid);
}



function onNewContentCheck(obj,eid,name){	
	obj.checked=true;			
	var isHaveReply="0";
	try{
		if(document.getElementById("chk"+name+"_"+eid).checked) isHaveReply="1";
	} catch(e){
	}
	
	document.getElementById("_whereKey_"+eid).value=$(obj).attr("selecttype")+"|"+obj.value+"|"+isHaveReply;		
	
}
function doWorkflowEleSet(eid){
    try{ 
    	//var formAction =$("#dialogIframe_"+eid).contents().find("#ifrmViewType_"+eid).contents().find("#frmFlwCenter").attr("action")
		var formAction ="/homepage/element/setting/WorkflowCenterOpration.jsp";
		//$.post(formAction,{method:'submit',eid:eid},function(data){}); 
    	$.ajax({
                url :formAction,
                data:{method:'submit',eid:eid},
                cache : false, 
                async : false,
                type : "post",
                dataType : 'json',
                success : function (result){
                }
            });
    	//document.frames["ifrmViewType_"+eid].document.getElementById("btnSave").click();    	
 	}catch(e){}		
}
function checkSql(Obj){
	var sqlStr = jQuery(Obj).val();//event.srcElement.value;
	sqlStr = sqlStr.replace(/\n/g,"");
	sqlStr = sqlStr.replace(/\r/g,"");
	event.srcElement.value = sqlStr;
	sqlStr = " "+sqlStr.toUpperCase();
	if(sqlStr.indexOf(' INSERT ')!=-1||sqlStr.indexOf(' UPDATE ')!=-1 || sqlStr.indexOf(' DELETE ')!=-1 || sqlStr.indexOf(' CREATE ')!=-1|| sqlStr.indexOf(' DROP ')!=-1 ){
		//event.srcElement.value = "";
		jQuery(Obj).val("");
		alert("<%=SystemEnv.getHtmlLabelName(22949,user.getLanguage())%>")
	}
}

</script>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%@ include file="/js/homepage/Homepage_js.jsp" %>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
</BODY>
</HTML>

