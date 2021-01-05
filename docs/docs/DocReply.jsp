
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocUtil" class="weaver.docs.docs.DocUtil" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<html><head>
<%
    int docid = Util.getIntValue(request.getParameter("id"),0);
	String topage=Util.null2String(request.getParameter("topage"));
	String pstate=Util.null2String(request.getParameter("pstate"));
	String fromFlowDoc=Util.null2String(request.getParameter("fromFlowDoc"));
    String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");
    String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");
	session.setAttribute("f_weaver_belongto_userid_doc",f_weaver_belongto_userid);
    session.setAttribute("f_weaver_belongto_usertype_doc",f_weaver_belongto_usertype);
    String parentids=Util.null2String(request.getParameter("parentids"));
    String dialog = Util.null2String(request.getParameter("dialog"));
    String isclose = Util.null2String(request.getParameter("isclose"));
    boolean  blnOsp = "true".equals(request.getParameter("blnOsp")) ;
    String docName="";
    String newParentIds=","+parentids;
    int lastFlagIndex=newParentIds.lastIndexOf(",");
    String replyedDoc=newParentIds.substring(lastFlagIndex+1);
    String replyedName=DocComInfo.getDocname(replyedDoc);
    if (replyedName.indexOf("Re:")!=-1)  docName=replyedName;
    else  docName="Re: "+replyedName;
       

    DocManager.resetParameter();
    DocManager.setId(docid);
    DocManager.getDocInfoById();

    int maincategory=DocManager.getMaincategory();
    int subcategory=DocManager.getSubcategory();
    int seccategory=DocManager.getSeccategory();
    int replydocid=DocManager.getReplydocid();
    String docsubject=DocManager.getDocsubject();
    DocManager.closeStatement();


    String imagefilename = "/images/hdDOC_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(117,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(58,user.getLanguage());
    String needfav ="1";
    String needhelp ="";

    int maxUploadImageSize = DocUtil.getMaxUploadImageSize2(docid);
%>
<link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="JavaScript" src="/js/checkinput_wev8.js"></script>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<!--
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script>
-->
<!--swfupload相关-->
<script type="text/javascript" src="/js/page/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/page/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/page/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/js/page/swfupload/handlers_wev8.js"></script>
<link href="/js/page/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<!--引入ueditor相关文件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.config_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/js/doc/ueditor.all.min_wev8.js"> </script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>
<!--添加插件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/appdoc_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/appcrm_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/appproj_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/appwf_wev8.js"></script>
<link type="text/css" href="/ueditor/ueditorextend_wev8.css" rel="stylesheet"></link>
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/wordtohtml_wev8.js"></script>
<!--图片上传插件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/imgupload_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/css/ecology8/workflowsign_wev8.css" />
<style type="text/css">
	.edui-editor{
	  z-index:900 !important;
	}
	.zDialog_div_content{
		overflow:hidden;
	}
	.fileupload:hover{
	   background-color: #fff5d4;
	   border: 1px solid #dcac6c;
	}
</style>
<script language="javascript" type="text/javascript">
 var f_weaver_belongto_userid='<%=f_weaver_belongto_userid%>';
 var f_weaver_belongto_usertype='<%=f_weaver_belongto_usertype%>';
var lang=<%=(user.getLanguage()==8)?"true":"false"%>;
var ue;
jQuery(document).ready(function(){
	//FCKEditorExt.initEditor('weaver','doccontent',lang);
	window.setTimeout(function(){
		ue = UE.getEditor('doccontent',{
			toolbars:window.UEDITOR_CONFIG.docreplytoolbars,
			initialFrameHeight:jQuery(window).height()-191
		});
	},200);
});

function switchEditMode(){
	try{
		ue.execCommand('source');
	}catch(e){
	}
}
</script>
<script type="text/javascript">
	var parentWin = null;
	var dialog = null;
	try{
		parent.setTabObjName("<%=Util.stringReplace4DocDspExt(DocComInfo.getDocname(""+docid))%>");
	}catch(e){}
	if("<%=dialog%>"==1){
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
		function btn_cancle(){
			dialog.closeByHand();
		}
	}
	if("<%=isclose%>"==1){
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
		try{
			parentWin._table.reLoad();
		}catch(e){}
		try{
			openFullWindowForXtable("/docs/docs/DocDsp.jsp?id=<%=docid%>&blnOsp=<%=blnOsp%>&topage=<%=topage%>&pstate=<%=pstate%>&fromFlowDoc=<%=fromFlowDoc%>&f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>");
		}catch(e){
			
		}
		dialog.close();
	}
</script>
</head>

<body>
<%if("1".equals(dialog)){ %>
<div class="zDialog_div_content">
<%}%>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%>" class="e8_btn_top" onclick="onSave(this);">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%>" class="e8_btn_top" onclick="onDraft(this);">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%


RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSave(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(220,user.getLanguage())+",javascript:onDraft(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(222,user.getLanguage())+",javascript:switchEditMode(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(156,user.getLanguage())+",javascript:addannexRow(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;


%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>





<form id=weaver name=weaver action="UploadDoc.jsp" method=post enctype="multipart/form-data">
<input type=hidden name=docapprovable value="0">
<input type=hidden name=docreplyable value="1">
<input type=hidden name=isreply value="1">
<input type=hidden name=docpublishtype value="1">
<input type=hidden name=replydocid value="<%=docid%>">
<input type=hidden name=dialog value="<%=dialog%>">
<input type=hidden name=usertype value="<%=user.getLogintype()%>">
<input type=hidden name=maincategory value="<%=maincategory%>">
<input type=hidden name=docdepartmentid value="<%=user.getUserDepartment()%>">
<input type=hidden name=subcategory value="<%=subcategory%>">
<input type=hidden name=doclangurage value="<%=user.getLanguage()%>">
<input type=hidden name=seccategory value="<%=seccategory%>">
<input type=hidden name=operation value="addsave">
<input type=hidden name=parentids value="<%=parentids%>">
<input type=hidden name=docstatus>
<input type=hidden name=ownerid value="<%=user.getUID()%>">
<input id="f_weaver_belongto_userid" name="f_weaver_belongto_userid" type="hidden" value="<%=f_weaver_belongto_userid%>">
<input id="f_weaver_belongto_usertype" name="f_weaver_belongto_usertype" type="hidden" value="<%=f_weaver_belongto_usertype%>">

<wea:layout attributes="{'formTableId':'rewardTable'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(32830,user.getLanguage())%>' attributes="{'groupOperDisplay':'none'}">
	
		<wea:item><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="hidden" name="namerepeated" value="0">
			<input class=InputStyle size=70 name="docsubject" 
			value="<%=docName%>" 
			onkeydown="if(window.event.keyCode==13)return false"
			onChange="checkDocSubject(this);"
			onMouseDown="docSubjectMouseDown(this);"
			onBlur="checkDocSubject(this);"
			>
			<span id="docsubjectspan"><%if(docName.equals("")){%><img src="/images/BacoError_wev8.gif" align=absMiddle><%} %></span>
		
			<script type="text/javascript">
				var isChecking = false;
				var prevValue = "";
				<%if(!docsubject.equals("")){%>
				checkDocSubject($GetEle('docsubject'));
				<%}%>
				function getEvent() {
					if (window.ActiveXObject) {
						return window.event;// 如果是ie
					}
					func = getEvent.caller;
					while (func != null) {
						var arg0 = func.arguments[0];
						if (arg0) {
							if ((arg0.constructor == Event || arg0.constructor == MouseEvent)
									|| (typeof (arg0) == "object" && arg0.preventDefault && arg0.stopPropagation)) {
								return arg0;
							}
						}
						func = func.caller;
					}
					return null;
				}
		
				function docSubjectMouseDown(obj){
							if(window.event&&window.event.button==1)
							{
								checkDocSubject(obj);
							}
							else
							{
								var evt = getEvent();
								if(evt.button==0)
								{
									checkDocSubject(obj);
								}	
							}
				}
				function checkDocSubject(obj){
						if(obj!=null&&obj.value!=null&&""==obj.value){
									checkinput('docsubject','docsubjectspan');
									return;
						}
		
					  isChecking = true;			  
					  var subject = encodeURIComponent(obj.value);
					  var url = 'DocSubjectCheck.jsp';
					  var pars = 'subject='+subject+'&secid=<%=seccategory%>';
					  /*var myAjax = new Ajax.Request(
						url,
						{method: 'post', parameters: pars, onComplete: doCheckDocSubject}
					  );*/
					  jQuery.ajax({
					  	url:url,
					  	data:{
					  		subject:subject,
					  		secid:<%=seccategory%>			
					  	},
					  	dataType:"json",
					  	success:function(data){
					  		if(parseInt(data.num)>0){
					  			$GetEle('docsubjectspan').innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"+" <font color=red><%=SystemEnv.getHtmlLabelName(20073,user.getLanguage())%></font>";
								$GetEle('namerepeated').value = 1;
					  		}else{
					  			$GetEle('namerepeated').value = 0;
								checkinput('docsubject','docsubjectspan');
					  		}
					  		isChecking = false;
					  	}
					  });
					  
				}
				function doCheckDocSubject(req){
					var num = req.responseXML.getElementsByTagName('num')[0].firstChild.data;
					if(num>0){
						//alert("<%=SystemEnv.getHtmlLabelName(20073,user.getLanguage())%>");
						$GetEle('docsubjectspan').innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"+" <font color=red><%=SystemEnv.getHtmlLabelName(20073,user.getLanguage())%></font>";
						$GetEle('namerepeated').value = 1;
					} else {
						$GetEle('namerepeated').value = 0;
						checkinput('docsubject','docsubjectspan');
					}
					isChecking = false;
				}
				function checkSubjectRepeated(){
							if(isChecking){
									top.Dailog.alert("<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>");
									return;
							} else {
									if(1==$GetEle("namerepeated").value){
										top.Dailog.alert("<%=SystemEnv.getHtmlLabelName(20073,user.getLanguage())%>");
										return;
									}
									return true;
							}
				}
			</script>
		
		</wea:item>

		<wea:item><%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%></wea:item>
		<wea:item attributes="{'id':'attachments'}">
			<input type=file size=55 name="accessory1" onchange='accesoryChanage(this)'>&nbsp;&nbsp;(<%=SystemEnv.getHtmlLabelName(31513,user.getLanguage())%> <%=maxUploadImageSize%> M)
			<input type=hidden name=accessorynum value="1">
		</wea:item>
		
		
		<wea:item attributes="{'colspan':'full','samePair':'imgfield','display':'none'}">
		<div id=imgfield></div>
		</wea:item>
	</wea:group>
</wea:layout>
<div style="width:100%;position:absolute;bottom:0;top:93px;" id="replyContent">
<textarea id="doccontent" name=doccontent style="width:100%;height:100%;"></textarea>
</div>
</form>

<input type=hidden id='btnSave' name='btnSave' onclick='onSave(this)'>
<input type=hidden id=btnDraft onclick=onDraft(this)>
<input type=hidden id=btnHtml onclick=switchEditMode()>
<input type=hidden id=btnAccAdd onclick=addannexRow()>
<%if("1".equals(dialog)){ %>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<script type="text/javascript">
	jQuery(document).ready(function(){
		resizeDialog(document);
	});
</script>
<%} %>
<script language=javascript><!--
function onSave(obj){
	if(check_form(document.weaver,'docsubject')&&checkSubjectRepeated()){
		/****####@2007-08-27 modify by yeriwei!
		text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		document.weaver.doccontent.value=text;
		**/
		//FCKEditorExt.updateContent();
		
		document.weaver.docstatus.value=0;
		document.weaver.operation.value='addsave';
		var objSubmit;
		try{
			objSubmit=obj.parentNode.parentNode.parentNode.firstChild.nextSibling.firstChild.firstChild;
			objSubmit.disabled = true ;
			enableAllmenu();
		}catch(e){}
        obj.disabled = true ;
		document.weaver.submit();
	}
}

function onDraft(obj){
	if(check_form(document.weaver,'docsubject')&&checkSubjectRepeated()){
		/***###@2007-08-27 modify by yeriwei!
		text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		document.weaver.doccontent.value=text;
		***/
		//FCKEditorExt.updateContent();
		
		document.weaver.docstatus.value=0;
		document.weaver.operation.value='adddraft';
		var objSubmit;
		try{
			objSubmit=obj.parentNode.parentNode.parentNode.firstChild.firstChild.firstChild;
			objSubmit.disabled = true ;
			enableAllmenu();
		}catch(e){}
        obj.disabled = true ;
		document.weaver.submit();
	}
}

/****
function onHtml(){
	if(document.weaver.doccontent.style.display==''){

		text = document.weaver.doccontent.value;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML=text;
		document.weaver.doccontent.style.display='none';
		divifrm.style.display='';
	}
	else{
		text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		document.weaver.doccontent.value=text;
		document.weaver.doccontent.style.display='';
		divifrm.style.display='none';
	}
}
***/

accessorynum = 2 ;
function addannexRow()
{
	/*ncol = jQuery(rewardTable).attr("cols");
	oRow = rewardTable.insertRow(-1);
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);
		oCell.style.height=24;
		switch(j) {
             case 0:
				var oDiv = document.createElement("div");
				var sHtml = "&nbsp;";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
            case 1:
				oCell.className="field";
				var oDiv = document.createElement("div");
				var sHtml = "<input  type=file size=55 name='accessory"+accessorynum+"'  onchange='accesoryChanage(this)'>&nbsp;&nbsp;(<%=SystemEnv.getHtmlLabelName(31513,user.getLanguage())%> <%=maxUploadImageSize%> M)";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;

		}
	}*/
	var td = jQuery("#attachments");
	var oDiv = document.createElement("div");
	var sHtml = "<input  type=file size=55 name='accessory"+accessorynum+"'  onchange='accesoryChanage(this)'>&nbsp;&nbsp;(<%=SystemEnv.getHtmlLabelName(31513,user.getLanguage())%> <%=maxUploadImageSize%> M)";
	oDiv.innerHTML = sHtml;
	td.append(jQuery(oDiv));
	accessorynum = accessorynum*1 +1;
	document.weaver.accessorynum.value = accessorynum ;
	var delta = 22;
	jQuery("#replyContent").css("top",jQuery("#replyContent").offset().top+delta);
	jQuery("#edui1").height(jQuery("#edui1").height()-delta);
	jQuery("#edui1_iframeholder").height(jQuery("#edui1_iframeholder").height()-delta);
}


function accesoryChanage(obj){
    var objValue = obj.value;
    if (objValue=="") return ;
    var fileLenth;
    /*try {
        File.FilePath=objValue;  
        fileLenth= File.getFileSize();  
    } catch (e){
        alert("用于检查文件上传大小的控件没有安装，请检查IE设置，或与管理员联系！");
        createAndRemoveObj(obj);
        return  ;
    }*/
    var fileLenth=-1;
    try {
    	var fso = new ActiveXObject("Scripting.FileSystemObject");
    	fileLenth=parseInt(fso.getFile(objValue).size);
    } catch (e){
        try{
    		fileLenth=parseInt(obj.files[0].size);
        }catch (e) {
			alert("<%=SystemEnv.getHtmlLabelName(31567,user.getLanguage())%>");
			createAndRemoveObj(obj)
			return;
		}
    }
    if (fileLenth==-1) {
        createAndRemoveObj(obj);
        return ;
    }
    //var fileLenthByM = fileLenth/(1024*1024) 
	var fileLenthByK =  fileLenth/1024;
	var fileLenthByM =  fileLenthByK/1024;

	var fileLenthName;
	if(fileLenthByM>=0.1){
		fileLenthName=fileLenthByM.toFixed(1)+"M";
	}else if(fileLenthByK>=0.1){
		fileLenthName=fileLenthByK.toFixed(1)+"K";
	}else{
		fileLenthName=fileLenth+"B";
	}
    if (fileLenthByM><%=maxUploadImageSize%>) {
        //alert("所传附件为:"+fileLenthByM+"M,此目录下不能上传超过<%=maxUploadImageSize%>M的文件,如果需要传送大文件,请与管理员联系!");
        alert("<%=SystemEnv.getHtmlLabelName(20254,user.getLanguage())%>"+fileLenthName+",<%=SystemEnv.getHtmlLabelName(20255,user.getLanguage())%><%=maxUploadImageSize%>M<%=SystemEnv.getHtmlLabelName(20256,user.getLanguage())%>");		
        createAndRemoveObj(obj);
    }
}

function createAndRemoveObj(obj){
    objName = obj.name;
    var  newObj = document.createElement("input");
    newObj.name=objName;
    newObj.className="InputStyle";
    newObj.type="file";
    newObj.size=55;
    newObj.onchange=function(){accesoryChanage(this);};
    
    var objParentNode = obj.parentNode;
    var objNextNode = obj.nextSibling;
    jQuery(obj).remove()
    //obj.removeNode();
    objParentNode.insertBefore(newObj,objNextNode); 
}
--></script>
</body>
