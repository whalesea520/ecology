
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.homepage.HomepageBean" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.IsGovProj" %>

<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />


<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page"/>
<jsp:useBean id="pu" class="weaver.page.PageUtil" scope="page" />
<jsp:useBean id="ebc" class="weaver.page.element.ElementBaseCominfo" scope="page" />

<%@ include file="/page/maint/common/init.jsp" %>
<jsp:include page="/systeminfo/WeaverLangJS.jsp">
    <jsp:param name="languageId" value="<%=user.getLanguage()%>" />
</jsp:include>
<%
//Get Parameter
String hpid = Util.null2String(request.getParameter("templateid"));
String templateType = Util.null2String(request.getParameter("templatetype"));
boolean isSetting="true".equalsIgnoreCase(Util.null2String(request.getParameter("isSetting")));
String pagetype = Util.null2String(request.getParameter("pagetype"));
String docid= Util.null2String(request.getParameter("docid"));
String requestid= Util.null2String(request.getParameter("requestid"));

int isfromportal =0;
String serverName=request.getHeader("Host");
if ("loginview".equals(pagetype)&&user.getUID()!=1)
{
	response.sendRedirect("/notice/noright.jsp");
	return;
}


//计算相关页面数据

%>
<html>
  <head>
  	<STYLE TYPE="text/css">
  	<%=pu.getHpCss(hpid,-1,0)%>;
  	</STYLE>  	  
	<%=pu.getPageJsImportStr("") %>
	<%=pu.getPageCssImportStr("") %>
	<script type="text/javascript">
		function initGauges(id,xml){
			try{
				setTimeout('bindows.loadGaugeIntoDiv("' + xml + '", "' +id+ '")', 1000);
			}catch(e){
				alert(e.name)
			}
		}
		
	</script>
</head>  
<body>


<%
    

	boolean isALlLocked=false;
    //if(pc.getIsLocked(hpid).equals("1"))  isALlLocked=true;
    
  %>
  <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
  <%


    
/*
    RCMenu += "{<span id=spanStatus status='show'>"+SystemEnv.getHtmlLabelName(18466,user.getLanguage())+"</span>,javascript:onChanageAllStatus(this),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	if(isSetting){
	  RCMenu += "{<span>"+SystemEnv.getHtmlLabelName(19614,user.getLanguage())+"</span>,javascript:toggleELib(this) ,_self} " ;
	  RCMenuHeight += RCMenuHeightStep ;
		
	  if("addElement".equals(from)) {
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	
	  } else if("setElement".equals(from)) {
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBackList(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	  }else {
		RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onOk(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBack(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	  }
	}
*/
if(isSetting){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBack(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %> 

<div id="divInfo" style="border:1px solid #8888AA; background:white;display:none;position:absolute;padding:5px;posTop:expression(document.body.offsetHeight/2+document.body.scrollTop-50);posLeft:expression(document.body.offsetWidth/2-50);z-index:100;"></div>
<!--Content Table-->
<input type="hidden" value="btnWfCenterReload" name="btnWfCenterReload" onclick="elmentReLoad(8)">

<div>
 <%
	//String strStyle="";
	//if(!"".equals(hpsb.getHpbgimg())) strStyle+="background:url('"+hpsb.getHpbgimg()+"');";						
	//if(!"".equals(hpsb.getHpbgcolor())) strStyle+="bgcolor='"+hpsb.getHpbgcolor()+"';";	
 
	String strSpanContentWidth="100%";
	if(isSetting){
		strSpanContentWidth="83%";	
	%>	
	<span  style="width:15%;overflow:auto;border:1px solid #808080;margin:10 0 0 10" id="spanELib">		
		<TABLE width="100%" valign="top">			
			<% 
			ArrayList idList=new ArrayList();
			ArrayList titleList=new ArrayList();
			ArrayList iconList=new ArrayList();
			
			ArrayList titleBakList=new ArrayList();
			
			while(ebc.next()) 
			{
				if ("loginview".equals(pagetype))
				{
					String loginView = ebc.getLoginView();
					if (!"1".equals(loginView))
					{
						continue;
					}
				}
				idList.add(ebc.getId());
				titleList.add(ebc.getTitle());
				iconList.add(ebc.getIcon());
				
				titleBakList.add(ebc.getTitle());
			}
			 
			Collections.sort(titleBakList, new  weaver.general.PinyinComparator());
			for(int i=0;i<titleBakList.size();i++)		{
				String title=(String)titleBakList.get(i);			
				int pos=titleList.indexOf(title);
				String icon=(String)iconList.get(pos);
				String id=(String)idList.get(pos);
			%>
			<TR width="100%">
				<TD title="<%=title%>" id="tdElement"><img src="<%=icon%>">
					<A HREF="javascript:onAddElement('<%=id%>','2')">&nbsp;<%=title%></A>	
				</TD>
			</TR>
			<%} %>
		</TABLE>
	</span>	
	<%}%>	
	<span  id="spanContent" style="width:<%=strSpanContentWidth%>;vertical-align:top">		
		 <%=pu.getPageNewsTemplateBaseStr(hpid,user,isSetting,docid,templateType,serverName,request)%>	 
	</span>	
</div>

</body>
</html>


<SCRIPT LANGUAGE="JavaScript">

$(document).ready(function(){

	$(".item").bind("reload",function(){
		elementReload(this.eid,this.cornerTop,this.cornerBottom,this.cornerTopRadian,this.cornerBottomRadian)
	});
	
	$(".item").trigger("reload");	
});

function elementReload(eid,top,bottom,topRadian,bottomRadian){	
	var $this = $("#content_view_id_"+eid);
	var url=$.trim($this.attr("url")).replace(/&amp;/g,"&");
	
	if(url.substring(0,1)!="?")  {
		$this.html("<img src=/images/loading2_wev8.gif> <%=SystemEnv.getHtmlLabelName(19611,user.getLanguage())%>...")
		log(url)
		$this.load(url,{},function(){
			
		});
	} 
	
	if(top=="Round") {
		$("#header_"+eid).corner("Round top "+topRadian); 
	}

	if(bottom=="Round") {
		$("#content_"+eid).corner("Round bottom "+bottomRadian); 
	}	
}

function toggleELib(obj){
	if($('#spanELib').css("width")=="0%") {
		$('#spanELib').css("margin","10 0 0 10");
		$('#spanELib').css("width","15%");		
		$('#spanContent').css("width","84%");

		obj.lastChild.innerHTML="<%=SystemEnv.getHtmlLabelName(19614,user.getLanguage())%>";
	} else {
		$('#spanELib').css("margin","0");
		$('#spanELib').css("width","0%");
		$('#spanContent').css("width","100%");
		obj.lastChild.innerHTML="<%=SystemEnv.getHtmlLabelName(19613,user.getLanguage())%>";
	}
}
function onAddElement(ebaseid,styleid){
	url="/homepage/element/ElementPreview.jsp?ebaseid="+ebaseid+"&styleid="+styleid+"&hpid=<%=hpid%>&subCompanyId=0&layoutflag=A&addType=newstemplate";	
	GetContent("divInfo",url,true);
}

function onDel(eid){	
    if(!confirm("<%=SystemEnv.getHtmlLabelName(19747,user.getLanguage())%>")) return;

    var group=$("#item_"+eid).parent();
    var flag=group.attr("areaflag");
    var eids="";
    
    $(group).children("div .item").each(function(){
        if(this.eid!=eid)  	eids+=this.eid+",";
    });
    
    $.get("/homepage/element/EsettingOperate.jsp",
    	  {method: "delElement", hpid: "<%=hpid%>",eid:eid,delFlag:flag,delAreaElement:eids,subCompanyId:"0",delType:'newstemplate'},
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
		$.post(formAction,{method:'submit',eid:eid},function(data){}); 
    	//document.frames["ifrmViewType_"+eid].document.getElementById("btnSave").click();    	
 	}catch(e){}		
}

var randomValue;
function onSetting(eid,ebaseid){
	//以下处理所有tabs插件	
	
	$("#setting_"+eid+" .weavertabs").weavertabs({selected:0});
	
	$("#setting_"+eid).show();	
	var urlContent=$.trim($("#weavertabs-content-"+eid).attr("url")).replace(/&amp;/g,"&");
	var urlStyle=$.trim($("#weavertabs-style-"+eid).attr("url")).replace(/&amp;/g,"&");
	var urlShare=$.trim($("#weavertabs-share-"+eid).attr("url")).replace(/&amp;/g,"&");	
	if(urlContent!="") {
		randomValue =Math.round(Math.random()*(100-1)+1)
		urlContent = urlContent+"&random="+randomValue;
		$("#weavertabs-content-"+eid).html("")
		$("#weavertabs-content-"+eid).html("<img src=/images/loading2_wev8.gif> <%=SystemEnv.getHtmlLabelName(19611,user.getLanguage())%>...");
		$("#weavertabs-content-"+eid).load(urlContent,{},function(){
			//alert($("#weavertabs-content-"+eid).html())
			//$("#tabDiv_"+eid).dialog('destroy');
			$(".filetree").filetree();
			fixedPosition(eid);
		});
	}
	if(urlStyle!="") $("#weavertabs-style-"+eid).load(urlStyle,{},function(){
		$("#weavertabs-style-"+eid+" .filetree").filetree();
		
	});
	
	if(urlShare!="") $("#weavertabs-share-"+eid).load(urlShare,{},function(){
		//$("#weavertabs-share-"+eid+" .filetree").filetree();
		
	});

	
	log("urlContent:"+urlContent);
	log("urlStyle:"+urlStyle);
}
function onNoUseSetting(eid){
 $("#setting_"+eid).hide();
}
function onUseSetting(eid,ebaseid){		
	if(ebaseid==8) { /*对流程中心元素进行特殊处理*/
		doWorkflowEleSet(eid);
		//return; 
	}	
	//common部分处理
	var ePerpageValue=5;
	var eShowMoulde='0';
	var eLinkmodeValue ='';
	var esharelevel = '';
	try{
		if(document.getElementById("_ePerpage_"+eid)!=null){
	    	ePerpageValue=document.getElementById("_ePerpage_"+eid).value;
	    }
	    if(document.getElementById("_eShowMoulde_"+eid)!=null){
	    	eShowMoulde=document.getElementById("_eShowMoulde_"+eid).value;
	    }
	    if(document.getElementById("_eLinkmode_"+eid)!=null){
	    	eLinkmodeValue=document.getElementById("_eLinkmode_"+eid).value;
	    }
	    
		esharelevel=document.getElementById("_esharelevel_"+eid).value;
	} catch(e){
	}
	
	//try{  
		
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
		if(document.getElementById("_imgWidth"+eid)!=null){
			
			var imgWidth = document.getElementById("_imgWidth"+eid).value;
			var imgHeight = document.getElementById("_imgHeight"+eid).value;
			
			if(imgWidth.replace(/(^\s*)|(\s*$)/g, "") == ""){
				imgWidth = "0";
			}
			if(imgHeight.replace(/(^\s*)|(\s*$)/g, "")==""){
				imgHeight = "0";
			}
			var imgSize = imgWidth+"*"+imgHeight;
			
			imsgSizeStr = "imgSize_"+document.getElementById("_imgWidth"+eid).basefield;
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
				alert("<%=SystemEnv.getHtmlLabelName(20858,user.getLanguage())%>");
				return;
			}
			$("#title_"+eid).html(eTitleValue);				
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
		
		eTitleValue=eTitleValue.replace(/&/g, "%26");//把eTitleValue中的&换成%26;
		
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
		log(operationurl)
		
		var postStr = "eid: '"+eid+"',eShowMoulde:'"+eShowMoulde+"',ebaseid:'"+ebaseid+"',eTitleValue:'"+eTitleValue+"',ePerpageValue:'"+ePerpageValue+"',eLinkmodeValue:'"+eLinkmodeValue+"',";
			postStr	+="eFieldsVale:'"+eFieldsVale+"',imgSizeStr:'"+imgSize+"',whereKeyStr:'"+whereKeyStr+"',esharelevel:'"+esharelevel+"',hpid:'"+'<%=hpid%>'+"',subCompanyId:'"+'0'+"',";
			postStr	+="eLogo:'"+eLogo+"',eStyleid:'"+eStyleid+"',eHeight:'"+eHeight+"',newstemplate:'"+newstemplateStr+"',imgType:'"+imgType+"',imgSrc:'"+imgSrc+"',"
			postStr	+="eMarginTop:'"+eMarginTop+"',eMarginBottom:'"+eMarginBottom+"',eMarginLeft:'"+eMarginLeft+"',eMarginRight:'"+eMarginRight+"'";

		var wordcountStr="";
		var _wordcountObjs=document.getElementsByName("_wordcount_"+eid);
		for(var j=0;j<_wordcountObjs.length;j++){
			var wordcountObj=_wordcountObjs[j];
			var basefield=wordcountObj.basefield;
			wordcountStr+="&wordcount_"+basefield+"="+wordcountObj.value;
			postStr+=",wordcount_"+basefield+":'"+wordcountObj.value+"'";
		}
		var newstr = $("#setting_form_"+eid).serialize();

		//alert(newstr)
		//newstr=newstr.replace(/%0A/g,"/n");

		newstr=newstr.replace(/&/g,"',");

		newstr=newstr.replace(/=/g,":'");
		newstr=newstr.replace(/%2F/g,"/");
		newstr = newstr.replace(/%3A/g,":");
		//newstr = decodeURIComponent (newstr);
		//alert(newstr)
		if(newstr!=""){
			postStr = postStr+","+newstr+"'";
		}
		
		postStr = "var postObj = {"+postStr+"}";
		
		eval(postStr)

		$.post(operationurl, postObj,				  
				function(data){
					  if($.trim(data)=="") 	{
						  $("#setting_"+eid).hide();
						  if(ebaseid=="news"||parseInt(ebaseid)==7){
						  	 $.post('/page/element/compatible/NewsOperate.jsp',{method:'submit',eid:eid},function(data){
						  	 	if($.trim(data)==""){
						  	 		$("#item_"+eid).trigger("reload");
						  	 	}
						  	 });
						  }else{
						  	 $("#item_"+eid).trigger("reload");
						  }
		    		  }
				}
		);
		
		//window.frames["eShareIframe_"+eid].document.getElementById("frmAdd_"+eid).submit();	
		
		//元素共享设置提交
		
			
	 //} catch(e){
	//	 alert(e)
	 //}
	
}

function onLockOrUn(eid,ebaseid,obj){
    if(confirm("<%=SystemEnv.getHtmlLabelName(19745,user.getLanguage())%>")){
        divInfo.style.display='inline';
        var url;
        if(obj.status=="unlocked"){
            url="/homepage/element/EsettingOperate.jsp?method=locked&eid="+eid+"&hpid=<%=hpid%>&subCompanyId=0";
        } else {
            url="/homepage/element/EsettingOperate.jsp?method=unlocked&eid="+eid+"&hpid=<%=hpid%>&subCompanyId=0";
        }
        log(url)
        $.get(url,{},function(data){
            log($.trim(data));
        	divInfo.style.display='none';
        	if(obj.status=="unlocked"){
                obj.status="locked";   
            } else {
                obj.status="unlocked";
            }           
        	obj.firstChild.src=$.trim(data);
         });
        
    }
}

function MoveEData(srcFlag,targetFlag){

	var srcItemEids=""; 
	$(".group[areaflag="+srcFlag+"]>.item").each(function(i){
		if(this.className=="item")	{
			srcItemEids+=this.eid+",";
		}
	})
	
	var targetItemEids="";   
	$(".group[areaflag="+targetFlag+"]>.item").each(function(i){
		if(this.className=="item")	{
			targetItemEids+=this.eid+",";
		}
	})  
	log("src"+srcFlag+"-"+srcItemEids);
	log("target:"+targetFlag+"-"+targetItemEids);

	var url="/homepage/element/EsettingOperate.jsp?method=editLayout&hpid=<%=hpid%>&subCompanyId=0&srcFlag="+srcFlag+"&targetFlag="+targetFlag+"&srcStr="+srcItemEids+"&targetStr="+targetItemEids+"&editType=newstemplate";		
	GetContent(divInfo,url,false);	
	
}
function   doSynize(obj){
     if(confirm("<%=SystemEnv.getHtmlLabelName(19745,user.getLanguage())%>")){
            //obj.disabled=true;
            divInfo.style.display='inline';
            var code="divInfo.style.display=\"none\";";
            var url='/homepage/maint/HomepageMaintOperate.jsp?method=synihp&subCompanyId=0&hpid=<%=hpid%>'
            GetContent(divInfo,url,false,code);
     }
}
function openMaginze(obj,url,linkmode){
  url=url+obj.value;
  if(linkmode=="1") window.location=url; 
  if(linkmode=="2") openFullWindowForXtable(url);
}

function onRefresh(eid,ebaseid){
	$("#item_"+eid).trigger("reload");  
}

//菜单



/**
	添加Tab页
*/
function addTab(eid,url,ebaseid){
	var tabCount = $("#tabDiv_"+eid+"_"+randomValue).attr("tabCount");
	tabCount = parseInt(tabCount);
	tabCount++;
	
	var url = $("#tabDiv_"+eid+"_"+randomValue).attr("url");
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
	}else if(ebaseid=="news"||parseInt(ebaseid)==7){
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
	var url = $("#tabDiv_"+eid+"_"+randomValue).attr("url");
	var tabTitle = $("#tab_"+eid+"_"+tabId).attr("tabTitle");
	
	url+="&tabId="+tabId+"&tabTitle="+tabTitle;
	if(ebaseid=="news" || parseInt(ebaseid)==7){
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
		$("#dialogIframe_"+eid+"_"+randomValue).attr("src",url);
		//$("#tabDiv_"+eid).dialog('destroy');
		$("#tabDiv_"+eid+"_"+randomValue).dialog({
				id:tabId,
				bgiframe: true,
				autoOpen: false,
				height: 600,
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
						if(parseInt(ebaseid)==8){
							$("#dialogIframe_"+eid+"_"+randomValue).contents().find("#ifrmViewType_"+eid).contents().find("#btnSave").trigger("click")
							formAction =$("#dialogIframe_"+eid+"_"+randomValue).contents().find("#ifrmViewType_"+eid).contents().find("#frmFlwCenter").attr("action")
							tabTitle = $("#dialogIframe_"+eid+"_"+randomValue).contents().find("#tabTitle_"+eid).attr("value")
							
							$("#dialogIframe_"+eid+"_"+randomValue).contents().find("#ifrmViewType_"+eid).contents().find("#frmFlwCenter").find("#tabTitle").attr("value",tabTitle);
							$("#dialogIframe_"+eid+"_"+randomValue).contents().find("#ifrmViewType_"+eid).contents().find("#frmFlwCenter").find("#tabId").attr("value",tabId);
							$("#dialogIframe_"+eid+"_"+randomValue).contents().find("#ifrmViewType_"+eid).contents().find("#frmFlwCenter").find("#method").attr("value",method);
							formParams = $("#dialogIframe_"+eid+"_"+randomValue).contents().find("#ifrmViewType_"+eid).contents().find("#frmFlwCenter").serializeArray();
							if($("#dialogIframe_"+eid+"_"+randomValue).contents().find("#showCopy_"+eid).attr("checked")){
								showCopy = "1"
							}else{
								showCopy = "0"
							}
							$("#dialogIframe_"+eid+"_"+randomValue).contents().find("#ifrmViewType_"+eid).contents().find("#frmFlwCenter").find("#showCopy").attr("value",showCopy);
							formAction ="/homepage/element/setting/"+formAction;
						}else if(ebaseid=="news" || parseInt(ebaseid)==7){
							formAction ="/page/element/compatible/NewsOperate.jsp";
							tabTitle = $("#dialogIframe_"+eid+"_"+randomValue).contents().find("#tabTitle_"+eid).attr("value")
						
							whereKeyStr = document.frames("dialogIframe_"+eid+"_"+randomValue).getNewsSettingString(eid);
							
							formParams ={eid:eid,tabId:tabId,tabTitle:tabTitle,tabWhere:whereKeyStr,method:method};
						}
						if(tabTitle==''){
							alert('<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>')
							return false;		
						}
						log(formAction)
						$.post(formAction,formParams,function(data){
							if($.trim(data)==""){
									if(method=='add'){
										$("#tabSetting_"+eid+">tbody").append("<TR><TD><span id = tab_"+eid+"_"+tabId+" tabId="+tabId+" tabTitle="+tabTitle+" tabWhere="+whereKeyStr+" showCopy="+showCopy+">"+tabTitle+"</span></TD><TD width=100 lign='right'><a href='javascript:deleTab("+eid+","+tabId+")'><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> &nbsp;&nbsp; <a href='javascript:editTab("+eid+","+tabId+",\""+ebaseid+"\")'><%=SystemEnv.getHtmlLabelName(22250,user.getLanguage())%></a></TD></TR>")
										$("#tabDiv_"+eid+"_"+randomValue).attr("tabCount",tabId);
									}else{
										$("#tab_"+eid+"_"+tabId).text(tabTitle);
										$("#tab_"+eid+"_"+tabId).attr("tabTitle",tabTitle);
										$("#tab_"+eid+"_"+tabId).attr("showCopy",showCopy);
										$("#tab_"+eid+"_"+tabId).attr("tabWhere",whereKeyStr);
									}
									$("#tabDiv_"+eid+"_"+randomValue).dialog('close');
					   		  } else {
					   		  		$("#tabDiv_"+eid+"_"+randomValue).dialog('close');
					   		  }
						});
					}
				},
				
				close: function() {
					$("#tabDiv_"+eid+"_"+randomValue).dialog('destroy');
					//alert($("#tabDiv_"+eid).dialog('option', 'id'))
					//  $("#dialog").dialog("destroy");
				}
			});
			//if($("#tabDiv_"+eid).dialog('option', 'id')==undefined){
			//	
			//}
			//alert($("#tabDiv_"+eid).dialog('option', 'id'))
			$("#tabDiv_"+eid+"_"+randomValue).dialog('open');
			
		}catch(e){
			alert(e)
		}
}

/**
	验证SQL语句
*/
function checkSql(){
	var sqlStr = event.srcElement.value;
	sqlStr = " "+sqlStr.toUpperCase();
	if(sqlStr.indexOf(' INSERT ')!=-1||sqlStr.indexOf(' UPDATE ')!=-1 || sqlStr.indexOf(' DELETE ')!=-1 || sqlStr.indexOf(' CREATE ')!=-1|| sqlStr.indexOf(' DROP ')!=-1 ){
		event.srcElement.value = "";
		alert("<%=SystemEnv.getHtmlLabelName(22949,user.getLanguage())%>")
	}
}
function onBack()
{
	window.location="/page/maint/template/news/list.jsp";
}

//-->
</SCRIPT>

<%@ include file="/js/homepage/Homepage_js.jsp" %>
