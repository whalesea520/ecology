
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="pu" class="weaver.page.PageUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="wpc" class="weaver.admincenter.homepage.WeaverPortalContainer" scope="page"/>
<jsp:useBean id="hpec" class="weaver.homepage.cominfo.HomepageElementCominfo" scope="page"/>
<jsp:useBean id="wbe" class="weaver.admincenter.homepage.WeaverBaseElementCominfo" scope="page" />
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles_wev8.css">
	-->
		<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
  </head>
  
<jsp:include page="/systeminfo/WeaverLangJS.jsp">
    <jsp:param name="languageId" value="<%=user.getLanguage()%>" />
</jsp:include>

  <body>
  	<%
		String titlename = "";
	  	String hpid = "0";
	  	String eid = "0";
	  	int subCompanyId = -1;
	  	int isfromportal = 0;
	  	String ebaseid=Util.null2String(request.getParameter("ebaseid"));
	  	int userid=pu.getHpUserId(hpid,""+subCompanyId,user);
		int usertype=pu.getHpUserType(hpid,""+subCompanyId,user);
	  	String pagetype = "1".equals(wbe.getLoginview(ebaseid))?"loginview":"0";
	  	String strSql = "select id from hpelement where fromModule='hpPriview' and ebaseid='"+ebaseid+"'";
	  	rs.executeSql(strSql);
	  	if(rs.next())eid = rs.getString("id");
	  	if("0".equals(eid)){
		  	strSql="insert into hpElement(title,logo,islocked,ebaseid,isSysElement,hpid,styleid,marginTop,shareuser,scrolltype,fromModule) "
		  		+"values('"+(user.getLanguage()==8?wbe.getTitleEN(ebaseid):wbe.getTitle(ebaseid))+"','"+wbe.getElogo(ebaseid)+"','0','"+ebaseid+"','1',0,'template','10','5_1','None','hpPriview')";
			rs.executeSql(strSql);
			rs.executeSql("select max(id) from hpElement");
			if(rs.next()){
				eid=Util.null2String(rs.getString(1));
			}
			hpec.addHpElementCache(""+eid);
			//添加共享信息
			String strInsertSql = "insert into hpElementSettingDetail(hpid,eid,userid,usertype,perpage,linkmode,sharelevel) values("+hpid+","+eid+","+userid+","+usertype+","+wbe.getPerpage(ebaseid)+","+wbe.getLinkmode(ebaseid)+",'2')";
			rs.executeSql(strInsertSql);
	  	}
	%>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<SCRIPT language="javascript" src="/js/xmlextras_wev8.js"></script>
	<SCRIPT type="text/javascript" src="/js/jscolor/jscolor_wev8.js"></script>
	<link type='text/css' rel='stylesheet'  href='/wui/theme/<%=curTheme %>/skins/<%=curskin %>/wui_wev8.css'/>
	<link type='text/css' rel='stylesheet'  href='/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css'/>
	<link rel="stylesheet" href="/wui/theme/ecology8/templates/default/css/default2_wev8.css" type="text/css"> </link>
	<script type="text/javascript" src="/wui/theme/ecology8/templates/default/js/default_wev8.js"> </script>

	
	<script type="text/javascript">
		function initGauges(id,xml){
			try{
				setTimeout('try{bindows.loadGaugeIntoDiv("' + xml + '", "' +id+ '")}catch(e){}', 1000);
			}catch(e){
				alert(e.name)
			}
		}
		function onLoadComplete(ifm){
			if(ifm.readyState=="complete"){   
				if(ifm.contentWindow.document.body.scrollHeight>ifm.height){
					ifm.style.height = ifm.height;
				}else{
					ifm.style.height = ifm.contentWindow.document.body.scrollHeight;
				}
			}
		}
	</script>
	<!-- 引入CSS -->
	<%=pu.getPageCssImportStr(hpid) %>	
	<!-- 引入JavaScript -->  
	<%=pu.getPageJsImportStr(hpid) %>
	<STYLE TYPE="text/css">
	.item a{
		text-decoration: none!important;
	}
	.header{
		background-position:left center;
	}
  	<%=wpc.getBaseElementCss(eid,"template")%>
  	
  	</STYLE>
  	<table class="layoutTable" cellpadding="0" cellspacing="0" width="100%">
  	<col width="1%">
  	<col width="98%">
  	<col width="1%">
  	<colgroup>
  		<tr style="height:1px;">
	  		<td colspan="3">&nbsp;</td>
  		</tr>
  		<tr>
	  		<td>&nbsp;</td>
	  		<td><%=wpc.getElementFrame(ebaseid,eid,user)%></td>
	  		<td>&nbsp;</td>
  		</tr>
  	</table>
  </body>
</html>
<link rel="stylesheet" href="/js/tabs/css/e8tabs_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/tabs/jquery.tabs_wev8.js"></script>
<SCRIPT LANGUAGE="JavaScript">

function showTabs(eid,tabid){
	if(tabid=="tabContent"){
		jQuery("#weavertabs-content-"+eid).show();
		jQuery("#weavertabs-style-"+eid).hide();
		jQuery("#weavertabs-share-"+eid).hide();
	}else if(tabid=="tabStyle"){
		jQuery("#weavertabs-style-"+eid).show();
		jQuery("#weavertabs-share-"+eid).hide();
		jQuery("#weavertabs-content-"+eid).hide();
	}else if(tabid=="tabShare"){
		jQuery("#weavertabs-share-"+eid).show();
		jQuery("#weavertabs-content-"+eid).hide();
		jQuery("#weavertabs-style-"+eid).hide();
	}
}

$(document).ready(function(){
	
});

/*修改相应元素位置 到到相应的元素下去*/
function fixedPosition(eid){	

}
function toggleELib(obj){
	
	if($('#spanELib').is(":hidden")) {
		$('#spanELib').show();
		$('#spanELib').css("margin","10 0 0 10");
		$('#spanELib').css("width","120px");		
		$('#spanContent').css("width","80%");

		obj.lastChild.innerHTML="<%=SystemEnv.getHtmlLabelName(19614,user.getLanguage())%>";
	} else {
		$('#spanELib').hide();
		$('#spanELib').css("width","0%");
		$('#spanContent').css("width","100%");
		obj.lastChild.innerHTML="<%=SystemEnv.getHtmlLabelName(19613,user.getLanguage())%>";
	}
}
function onAddElement(ebaseid,styleid){
	if($(".item").length==10){
		if(confirm("继续添加会影响页面性能，还要继续吗？")){
			url="/homepage/element/ElementPreview.jsp?ebaseid="+ebaseid+"&styleid="+styleid+"&hpid=<%=hpid%>&subCompanyId=<%=subCompanyId%>&fromModule=Portal&layoutflag=A";	
			GetContent("divInfo",url,true);
		}
	}else{
		url="/homepage/element/ElementPreview.jsp?ebaseid="+ebaseid+"&styleid="+styleid+"&hpid=<%=hpid%>&subCompanyId=<%=subCompanyId%>&fromModule=Portal&layoutflag=A";	
		GetContent("divInfo",url,true);
	}

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
function doWorkflowEleSet(eid){
    try{ 
    	//var formAction =$("#dialogIframe_"+eid).contents().find("#ifrmViewType_"+eid).contents().find("#frmFlwCenter").attr("action")
		var formAction ="/homepage/element/setting/WorkflowCenterOpration.jsp";
		//$.post(formAction,{method:'submit',eid:eid},function(data){}); 
    	$.ajax({
                url :formAction,
                data:{method:'submit',eid:eid},
                cache : false, 
                type : "post",
                dataType : 'json',
                success : function (result){
                }
            });
    	//document.frames["ifrmViewType_"+eid].document.getElementById("btnSave").click();    	
 	}catch(e){}		
}
var randomValue;
function onSetting(eid,ebaseid){
	
	
	//获取设置页面内容
	var settingUrl="/page/element/setting.jsp?pagetype=<%=pagetype%>&eid="+eid+"&ebaseid="+ebaseid+"&hpid=<%=hpid%>&subcompanyid=<%=subCompanyId%>";
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
				
				var urlContent=$.trim($("#weavertabs-content-"+eid).attr("url")).replace(/&amp;/g,"&");
				var urlStyle=$.trim($("#weavertabs-style-"+eid).attr("url")).replace(/&amp;/g,"&");
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
						//初始化layout组件
						initLayout();
					});
				}
				if(urlStyle!="") $("#weavertabs-style-"+eid).load(urlStyle,{},function(){
					
					var checkimg=$("#eLogo_"+eid).attr("value");
					$("#weavertabs-style-"+eid+" .filetree").filetree({"file":checkimg});
					//$("#weavertabs-style-"+eid+" .filetree").filetree();
					//初始化layout组件
					initLayout();
					
				});
				
				if(urlShare!="") $("#weavertabs-share-"+eid).load(urlShare,{},function(){
					//$("#weavertabs-share-"+eid+" .filetree").filetree();
					
				});
   		  }
   		  
	});
	

	
	//log("urlContent:"+urlContent);
	//log("urlStyle:"+urlStyle);
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
			$("#title_"+eid).text(eTitleValue);	
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
		
		var eIsNew="";
		var eIsBold="";
		var eIsRgb="";
		var eNewColor="";
		var eIsLean=""; 
		
		if($("#isnew_"+eid).attr("checked")==true){
			eIsNew=$("#isnew_"+eid).val();
		}
		if($("#isbold_"+eid).attr("checked")==true){
			eIsBold=$("#isbold_"+eid).val();
		}
		if($("#isrgb_"+eid).attr("checked")==true){
			eIsRgb=$("#isrgb_"+eid).val();
		}
		if($("#islean_"+eid).attr("checked")==true){
			eIsLean=$("#islean_"+eid).val();
		}
		var eNewColor="#"+$("#newcolor_"+eid).val();
		
		//相关的共享设置部分
		var operationurl=$.trim($("#setting_"+eid).attr("operationurl")).replace(/&amp;/g,"&");
		log(operationurl)
		//alert(eid)
		var postStr = "eid:'"+eid+"',eShowMoulde:'"+eShowMoulde+"',ebaseid:'"+ebaseid+"',eTitleValue:'"+eTitleValue+"',ePerpageValue:'"+ePerpageValue+"',eLinkmodeValue:'"+eLinkmodeValue+"',";
			postStr	+="eFieldsVale:'"+eFieldsVale+"',imgSizeStr:'"+imgSize+"',whereKeyStr:'"+whereKeyStr+"',esharelevel:'"+esharelevel+"',hpid:'"+'<%=hpid%>'+"',subCompanyId:'"+'<%=subCompanyId%>'+"',";
			postStr	+="eLogo:'"+eLogo+"',eStyleid:'"+eStyleid+"',eHeight:'"+eHeight+"',newstemplate:'"+newstemplateStr+"',imgType:'"+imgType+"',imgSrc:'"+imgSrc+"',eScrollType:'"+scolltype+"',"
			postStr	+="eMarginTop:'"+eMarginTop+"',eMarginBottom:'"+eMarginBottom+"',eMarginLeft:'"+eMarginLeft+"',eMarginRight:'"+eMarginRight+"',isnew:'"+eIsNew+"',isbold:'"+eIsBold+"',isrgb:'"+eIsRgb+"',islean:'"+eIsLean+"',newcolor:'"+eNewColor+"'";

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



function onLockOrUn(eid,ebaseid,obj){
	
    if(confirm("<%=SystemEnv.getHtmlLabelName(19745,user.getLanguage())%>")){
    	
        divInfo.style.display='inline';
        var url;
        
        
        if(jQuery(obj).attr("status")=="unlocked"){
            url="/homepage/element/EsettingOperate.jsp?method=locked&eid="+eid+"&hpid=<%=hpid%>&subCompanyId=<%=subCompanyId%>";
        } else {
            url="/homepage/element/EsettingOperate.jsp?method=unlocked&eid="+eid+"&hpid=<%=hpid%>&subCompanyId=<%=subCompanyId%>";
        }
        log(url)
        $.get(url,{},function(data){
            log($.trim(data));
          
        	divInfo.style.display='none';
        	if(jQuery(obj).attr("status")=="unlocked"){
                jQuery(obj).attr("status","locked");   
            } else {
                jQuery(obj).attr("status","unlocked");
            }           
            //
        	jQuery(obj).children(":first").attr("src",$.trim(data));
         });
        
    }
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
	log("src"+srcFlag+"-"+srcItemEids);
	log("target:"+targetFlag+"-"+targetItemEids);

	var url="/homepage/element/EsettingOperate.jsp?method=editLayout&hpid=<%=hpid%>&subCompanyId=<%=subCompanyId%>&srcFlag="+srcFlag+"&targetFlag="+targetFlag+"&srcStr="+srcItemEids+"&targetStr="+targetItemEids;		
	GetContent(divInfo,url,false);	
	
}
function   doSynize(obj){
     if(confirm("<%=SystemEnv.getHtmlLabelName(19745,user.getLanguage())%>")){
            //obj.disabled=true;
            divInfo.style.display='inline';
            var code="divInfo.style.display=\"none\";";
            var url='/homepage/maint/HomepageMaintOperate.jsp?method=synihp&subCompanyId=<%=subCompanyId%>&hpid=<%=hpid%>'
            GetContent(divInfo,url,false,code);
     }
}
function   doSynizeNormal(obj){
	var isNeedRefresh=1;
    if(confirm("<%=SystemEnv.getHtmlLabelName(19745,user.getLanguage())%>")){
           //obj.disabled=true;
           divInfo.style.display='inline';
           var code="divInfo.style.display=\"none\";";
           var url='/homepage/maint/HomepageMaintOperate.jsp?method=synihpnormal&subCompanyId=<%=subCompanyId%>&hpid=<%=hpid%>'
           GetContent(divInfo,url,false,code,isNeedRefresh);
    }
}
function openMaginze(obj,url,linkmode){
  url=url+obj.value;
  if(linkmode=="1") window.location=url; 
  if(linkmode=="2") openFullWindowForXtable(url);
}

//菜单
function onMenuDivClick(hpid,subCompanyId){
	window.location="/homepage/Homepage.jsp?hpid="+hpid+"&subCompanyId="+subCompanyId+"&isfromportal=1&isfromhp=1"
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

/**
	打开对话框
*/
function showTabDailog(eid,method,tabId,url,ebaseid){
	var whereKeyStr="";
	var showCopy="1";
	try{
		$("#dialogIframe_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).attr("name","dialogIframe_"+eid+"_"+$("#setting_"+eid).attr("randomValue"));
		
		$("#dialogIframe_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).attr("src",url);
		$("#tabDiv_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).bgiframe();
		//$("#tabDiv_"+eid).dialog('destroy');
		$("#tabDiv_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).dialog({
				id:tabId,
				bgiframe: true,
				autoOpen: false,
				height: 630,
				width:450,
				draggable:true,
				modal: true,
				buttons: {
					'<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>': function() {
						$(this).dialog('destroy');
					},
					'<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>': function() {
						// 准备Tab页条件数据
						var formParams ={};
						var formAction ="";
						var tabTitle ="";
						var displayTitle="";
						if(parseInt(ebaseid)==8){
							$("#dialogIframe_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).contents().find("#ifrmViewType_"+eid).contents().find("#btnSave").trigger("click")
							formAction =$("#dialogIframe_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).contents().find("#ifrmViewType_"+eid).contents().find("#frmFlwCenter").attr("action")
							tabTitle = $("#dialogIframe_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).contents().find("#tabTitle_"+eid).attr("value")
							displayTitle = $("#encodeHTML").text(tabTitle).html();
							$("#dialogIframe_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).contents().find("#ifrmViewType_"+eid).contents().find("#frmFlwCenter").find("#tabTitle").attr("value",tabTitle);
							$("#dialogIframe_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).contents().find("#ifrmViewType_"+eid).contents().find("#frmFlwCenter").find("#tabId").attr("value",tabId);
							$("#dialogIframe_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).contents().find("#ifrmViewType_"+eid).contents().find("#frmFlwCenter").find("#method").attr("value",method);
							formParams = $("#dialogIframe_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).contents().find("#ifrmViewType_"+eid).contents().find("#frmFlwCenter").serializeArray();
							if($("#dialogIframe_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).contents().find("#showCopy_"+eid).attr("checked")){
								showCopy = "1"
							}else{
								showCopy = "0"
							}
							$("#dialogIframe_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).contents().find("#ifrmViewType_"+eid).contents().find("#frmFlwCenter").find("#showCopy").attr("value",showCopy);
							formAction ="/homepage/element/setting/"+formAction;
						}else if(ebaseid=="news" || parseInt(ebaseid)==7||parseInt(ebaseid)==1||parseInt(ebaseid)==29){
							formAction ="/page/element/compatible/NewsOperate.jsp";
							tabTitle = $("#dialogIframe_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).contents().find("#tabTitle_"+eid).attr("value")
							displayTitle = $("#encodeHTML").text(tabTitle).html();
							
							whereKeyStr = window.frames["dialogIframe_"+eid+"_"+$("#setting_"+eid).attr("randomValue")].getNewsSettingString(eid);
							
							formParams ={eid:eid,tabId:tabId,tabTitle:tabTitle,tabWhere:whereKeyStr,method:method};
						}
						if(tabTitle==''){
							alert('<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>')
							return false;		
						}
						//alert(formAction)
						$.post(formAction,formParams,function(data){
							//alert(data)
							if($.trim(data)==""){
									if(method=='add'){
										$("#tabSetting_"+eid+">tbody").append("<TR><TD><span id = tab_"+eid+"_"+tabId+" tabId='"+tabId+"' tabTitle='' tabWhere='"+whereKeyStr+"' showCopy='"+showCopy+"'></span></TD><TD width=100 lign='right'><a href='javascript:deleTab("+eid+","+tabId+",\""+ebaseid+"\")'><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> &nbsp;&nbsp; <a href='javascript:editTab("+eid+","+tabId+",\""+ebaseid+"\")'><%=SystemEnv.getHtmlLabelName(22250,user.getLanguage())%></a></TD></TR>")
										$("#tabDiv_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).attr("tabCount",tabId);
										$("#tab_"+eid+"_"+tabId).html(displayTitle);
										$("#tab_"+eid+"_"+tabId).attr("tabTitle",tabTitle);
									}else{
										$("#tab_"+eid+"_"+tabId).html(displayTitle);
										$("#tab_"+eid+"_"+tabId).attr("tabTitle",tabTitle);
										$("#tab_"+eid+"_"+tabId).attr("showCopy",showCopy);
										$("#tab_"+eid+"_"+tabId).attr("tabWhere",whereKeyStr);
									}
									$("#tabDiv_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).dialog('close');
					   		  } else {
					   		  		$("#tabDiv_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).dialog('close');
					   		  }
						});
					}
				},
				
				close: function() {
					$("#tabDiv_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).dialog('destroy');
					
				}
			});
			$("#tabDiv_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).dialog('open');
			$("#tabDiv_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).height(373);			
		}catch(e){
			alert(e.message)
		}
}

/**
	验证SQL语句
*/
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
function onBack()
{
	var pagetype = "<%=pagetype %>";
	if(pagetype=="loginview")
	{
		
		window.location="/homepage/base/LoginBase.jsp?hpid=<%=hpid%>";
		
	}
	else
	{
		window.location='/homepage/base/HomepageBase.jsp?hpid=<%=hpid%>&subCompanyId=<%=subCompanyId%>&opt=show';
	}
}
function onBackList()
{	
	var pagetype = "<%=pagetype %>";
	if(pagetype=="loginview")
	{
		window.location="/homepage/maint/LoginPageContent.jsp";
	}
	else
	{
		window.location='/homepage/maint/HomepageRight.jsp?subCompanyId=<%=subCompanyId%>';
	}
}
function onOk(){
	window.location="/homepage/maint/HomepageRight.jsp?subCompanyId=<%=subCompanyId%>";
}


function onAddedOrUn(eid,ebaseid,obj){
    divCenter.style.display='inline';
    var code="divCenter.style.display=\"none\";";
    if(jQuery(obj).attr("status")=="add"){
    	if(confirm("<%=SystemEnv.getHtmlLabelName(21775,user.getLanguage())%>")){
            jQuery(obj).attr("status","remove");
            obj.src='/images/homepage/style/style1/remove_wev8.png';	
            url="/homepage/element/EsettingOperate.jsp?method=addtoass&eid="+eid;	          
            GetContent(divCenter,url,false,code);
    	}
    } else {
    	if(confirm("<%=SystemEnv.getHtmlLabelName(21776,user.getLanguage())%>")){
            jQuery(obj).attr("status","add");
            obj.src='/images/homepage/style/style1/add_wev8.png';
            url="/homepage/element/EsettingOperate.jsp?method=removefromass&eid="+eid;	        
            GetContent(divCenter,url,false,code);
    	}
    }	    
}

//菜单
function onMenuDivClick(hpid,subCompanyId){
	window.location="/homepage/Homepage.jsp?hpid="+hpid+"&subCompanyId="+subCompanyId+"&isfromportal=1&isfromhp=1"
}
function onSubMenuShow(obj){
	var divCurrent=obj.parentElement;
	var pSibling=divCurrent;

	var subMenu=document.getElementById("divSubMenu");       
	subMenu.style.display='block';

	subMenu.style.position="absolute";
	//subMenu.style.width=pSibling.offsetWidth;
	subMenu.style.posLeft=pSibling.offsetLeft;
	subMenu.style.posTop=pSibling.offsetTop+pSibling.offsetHeight;        
}

function onSubMenuHidden(obj){
	var subMenu=document.getElementById("divSubMenu");       
	subMenu.style.display='none';           
}

/*首页导航栏设置*/
var lastestSubDiv;
/*
   cObj:Current Object
   pObj:Pervious Sibling Object
   sObj:Sub Menu Object
*/
function onShowSubMenu(cObj,sObj){
   
	if (sObj.style.display=="none")    {
		/*初始化其显示的位置及大小*/
		//var pObj=cObj.previousSibling;
		var pObj=$(cObj).prev("div")[0];

		$(sObj).css({
			"position":"absolute",
			"left":$(pObj).offset().left,
			"top":$(pObj).offset().top+$(pObj).height()+10		
		})
		
		if(lastestSubDiv!=null) lastestSubDiv.style.display="none";
		lastestSubDiv=sObj;
		sObj.style.display="";

		//alert(sObj.offsetWidth+":"+pObj.offsetWidth)
		
		var factDivWidth=pObj.offsetWidth+cObj.offsetWidth;		
		if(factDivWidth<sObj.offsetWidth) factDivWidth=sObj.offsetWidth;

		sObj.style.width=factDivWidth;
		if (sObj.canHaveChildren) {
			var childDivs=sObj.children;
			for(var i=0;i<childDivs.length;i++) {
				var aChild=childDivs[i];
				if(aChild.offsetWidth<factDivWidth) aChild.style.width=factDivWidth;
			}
		}

		


	}
}
var x,y;
window.document.body.onmousemove = function(e){
	e=e||event;
	x = e.clientX;
	y = e.clientY;
	if(lastestSubDiv){
		var _l = lastestSubDiv.offsetLeft;
		var _t = lastestSubDiv.offsetTop;
		var _w = lastestSubDiv.offsetWidth;
		var _h = lastestSubDiv.offsetHeight;
		if(x>_l+_w || x<_l){
			lastestSubDiv.style.display = 'none';
			lastestSubDiv = null;
		}
	}
}  

//过滤元素标题中的特殊字符
function checkTextValid(id)   
{   
	return true;
  	//注意：修改####处的字符，其它部分不许修改.   
    //if(/^[^####]*$/.test(form.elements[i].value))  
    
	if(/^[^\"+-\\|:;,='<>]*$/.test($("#"+id).val())){
		return true;
	}else{
		alert("<%=SystemEnv.getHtmlLabelName(24950,user.getLanguage())%>:"+"\"+-\\|:;,='<>")
		$("#"+id).val($("#"+id).attr("defautvalue"));
		return false;
	} 
}  


function showUnreadNumber(accountId){
	var oSpan = document.getElementById("span"+accountId);
	var oIframe = document.getElementById("iframe"+accountId);
	var unreadMailNumber;
	if(oIframe.contentWindow.document.body.innerText){
		unreadMailNumber=jQuery.trim(oIframe.contentWindow.document.body.innerText);
	}else{
		unreadMailNumber=jQuery.trim(oIframe.contentWindow.document.body.lastChild.textContent);
	}
	oSpan.innerHTML = unreadMailNumber==-1 ? "<img src='/images/BacoError_wev8.gif' align='absmiddle' alt='<%=SystemEnv.getHtmlLabelName(20266,user.getLanguage())%>'>" : "(<b>"+unreadMailNumber+"</b>)";
}

function stockGopage(type,url){
	 if(type==0)
	 	openFullWindowForXtable(url);
	 else
		 this.location = url;
	}
	
//处理元素样式编辑时没有设置图标图片会出现残图现象
$(".iconEsymbol").bind('error',function(){
	if($(this).attr("src")==''){
		$(this).hide();
	}
})


$(".toolbar").find("img").bind('error',function(){
	if($(this).attr("src")==''){
		$(this).hide();
	}
})


  $(".downarrowclass").bind('error',function(){
				if($(this).attr("src")==''){
					$(this).hide();
				}
  })		  

  
  $(".rightarrowclass").bind('error',function(){
		if($(this).attr("src")==''){
			$(this).hide();
		}
  })
  
 
//-->
</SCRIPT>

<%@ include file="/js/homepage/Homepage_js.jsp" %>

<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>