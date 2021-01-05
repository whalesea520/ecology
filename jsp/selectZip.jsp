<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/jsp/systeminfo/init_wev8.jsp"%> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%> 
<%@ page import="com.weaver.general.GCONSTUClient" %>
<html>
<head>
<title> E-cology升级程序</title>

 <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
 <link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
 <script type="text/javascript" src="/js/updateclient/selectZip.js?r=2"></script>
 <script type="text/javascript" src="/js/updateclient/jquery.form.js?r=2"></script>
<script type="text/javascript">
var xhr = new XMLHttpRequest();
function uploadFile() {
	$(parent.document.getElementById("nextbutton")).attr("disabled","disabled");
	
    var fileObj = $("#zipfile"); // js 获取文件对象
   
    //console.info("上传的文件："+fileObj);
    var FileController = "/uploadzip.do"; // 接收上传文件的后台地址 
    // FormData 对象
    var form = new FormData();
    // form.append("author", "hooyes"); // 可以增加表单数据
    form.append("uploadzip", $("input[name='uploadzip']").val());// 文件对象
    form.append("localfile",$("input:radio[name='localfile']").val());
    form.append("file", fileObj);
    form.append("upfilepath", encodeURIComponent($("#zipfile").val()));
    // XMLHttpRequest 对象
    
    xhr.open("POST", FileController, true);
    xhr.onload = function() {
    };
    xhr.upload.addEventListener("progress", progressFunction, false);
    //2.设置回调函数      
    xhr.onreadystatechange = backFun;
    xhr.send(form);
}

//回调函数      
function backFun(){      
    //if(xhr.readyState == 4 && xhr.status == 200){      
        window.location.href="check.jsp";          
    //}      
}


function progressFunction(evt) {
    var progressBar = $("#progressBar");
    if (evt.lengthComputable) {
        var completePercent = Math.round(evt.loaded / evt.total * 100)+ "%";
        progressBar.width(completePercent);
        $("#uploadmessage").html("正在上传 " + completePercent);
    }
}

function next() {
	if(donext>0) {
		top.Dialog.alert("正在上传附件！");
		return;
	}
	
	if($("#zipfile").val()!=""||$("input:radio[name='localfile']").val()!=""){
	    var uploadzip  = $("input:radio[name='uploadzip']:checked").val();
	   	var zipval;
	   	if(uploadzip=="local") {
	   		zipval = $("input:radio[name='localfile']").val();
	       	if(zipval.indexOf(".zip") < 0) {
	       		top.Dialog.alert("上传的升级包格式不对！");
	       		return;
	       	}
	       	$("#filename").val(zipval);
	   		document.weaverform.submit();
        	donext++;
	   	} else {
	   		$("#filename").val(encodeURIComponent($("#zipfile").val()));
	   		zipval = $("#zipfile").val();
        	
        	if(zipval.indexOf(".zip") < 0) {
        		top.Dialog.alert("上传的升级包格式不对！");
        		return;
        	}	
			var options = {
				//提交表单之前做的验证
				type:'POST',
	            beforeSubmit:function(xhr){
	            	 //$("#progressBar").width("1px");
        			 $("#uploadmessage").html("<span style=\"color:red\">正在上传 ...");
	            },
				//服务器返回结果处理
	            success:function(data){
	            	 $("#progressBar").width("100%");
        			 $("#uploadmessage").html("正在上传 100%");
	                 backFun();
	            },
	            error:function(xhr){
	            	alert(xhr.responseText)
	            },
				//进度条的监听器
	            xhr:function(evt){
	           		xhr.upload.addEventListener("progress" , progressFunction, false);
	                return xhr;
	            }
			}

			//提交表单（uploadTaskForm --->表单的ID） 
     		$("#weaverform").ajaxSubmit(options);//阻止页面跳转
			donext++;
	   	}

    } else {
	   top.Dialog.alert("请选择升级包");
	   return;
   }
   


 }
    
  
    
//IE低版本有问题
function next_old(){
	if(donext>0) {
		top.Dialog.alert("正在上传附件！");
		return;
	}
	if($("#zipfile").val()!=""||$("input:radio[name='localfile']").val()!=""){
	    var uploadzip  = $("input:radio[name='uploadzip']:checked").val();
	   	var zipval;
	   	if(uploadzip=="local") {
	   		zipval = $("input:radio[name='localfile']").val();
	       	if(zipval.indexOf(".zip") < 0) {
	       		top.Dialog.alert("上传的升级包格式不对！");
	       		return;
	       	}
	       	$("#filename").val(zipval);
	   		document.weaverform.submit();
        	donext++;
	   	} else {
	       	$("#filename").val(zipval);
	       	
	       	var obj = $("#zipfile");	    	
			var photoExt=obj.val().substr(obj.val().lastIndexOf(".")).toLowerCase();//获得文件后缀名
			var fileSize = 0;
			var isIE = /msie/i.test(navigator.userAgent) && !window.opera;      
			if (isIE && !obj.files) {     
				var filePath = obj.val();      
				var fileSystem = new ActiveXObject("Scripting.FileSystemObject");  
				var file = fileSystem.GetFile(filePath);        
				fileSize = file.Size;     
			}else { 
				fileSize = obj.get(0).files[0].size;   
			} 
			//非zip无法上传
			if(photoExt != ".zip") {
		       	top.Dialog.alert("只能上传zip");
				return false;
			}
			fileSize=Math.round(fileSize/1024*100)/100; //单位为KB
			if(fileSize > 2097152){
		       	top.Dialog.alert("文件不能大于2G!");
				return false;
			}
			
			$("#progressBar").width("0%");
			uploadFile();
			donext++;
	   	}
	    

    } else {
	   top.Dialog.alert("请选择升级包");
	   return;
   } 
}

</script>
 </head>
<%
String titlename ="";
String packagepath  = GCONSTUClient.getPackagePath();
File packagefile = new File(packagepath);
String ziplist  = "";
if(packagefile.exists()) {
	File[] zips = packagefile.listFiles();
	for(int i = 0; i < zips.length; i++) {
		String zipname = zips[i].getName();
		if(!zipname.endsWith("zip")) {
			continue;
		}
		String fname = java.net.URLEncoder.encode(zipname,"UTF-8");
		
		ziplist = ziplist + "<span style='display:block;''><input name='localfile' type='radio' value='"+fname+"'>"+zips[i].getName()+"</input></span>";
	}
}

 %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(1402,user.getLanguage())+",javascript:next(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/jsp/systeminfo/commonTabHead.jsp?step=1">
			<jsp:param name="mouldID" value="upgrade" />
			<jsp:param name="navName" value="选择升级包" />
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important;top:20px;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(1402 ,user.getLanguage()) %>" class="e8_btn_top" onclick="next()"/>
		</td>
	</tr>
</table>

<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=titlename%></span> 
</div>
<body  style="height:100%;width:100%;">
<div style="width:24%;height:100%;float:left;background:#fcfcfc;">
<jsp:include page="step.jsp"></jsp:include>
</div>
<div style="width:75%;height:100%;float:right">
<form name="weaverform"  id="weaverform" action="/uploadzip.do"  method="post" enctype="multipart/form-data"> 
<input name="filename" id="filename" type="hidden"></input>
<wea:layout>
<wea:group context="选择升级包">
<wea:item><span style="font-size:15;font-weight:bold">升级包来源</span></wea:item>
<wea:item>
<input type="radio" name="uploadzip" value="upload" checked>上传升级包</input>&nbsp;&nbsp;<input type="radio" name="uploadzip" value="local">服务器指定路径(/filesystem/upgradepackages目录下的升级包)</input>
</wea:item>
<wea:item attributes="{'samePair':'uploadtd'}"><span style="font-size:15;font-weight:bold">请选择ecology升级包</span></wea:item>
<wea:item attributes="{'samePair':'uploadtd'}"><input style="width:80%;height:25px;" id="zipfile" type="file" onchange="checkfile(this)" name="uploadFile[0].file"  ></wea:item>
<wea:item attributes="{'samePair':'localtd'}"><span style="font-size:15;font-weight:bold">请选择ecology升级包</span></wea:item>
<wea:item attributes="{'samePair':'localtd'}"><%=ziplist %></wea:item>
<wea:item></wea:item><wea:item><span style="font-size:15;color:red">请选择泛微提供的补丁包，按照规范进行操作</wea:item>
</wea:group>
</wea:layout>
	<div class="" style="display:;background-color:white;height:10px;width:100%;bord: 1px solid;">
		<div id="progressBar" style="width:0%;background-color:#a9d325;height:10px;line-height:10px;">
		</div>
	</div>
	<div id="uploadmessage">
	</div>
	<table id="uploadBatchDg"></table>
</form>
</div>
</body>
</html>
