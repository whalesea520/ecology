var timeout2;
$(document).ready(function(){
	
	var process = $("#process").val();
	if(process != "" && process != "0") {
		//bindnextclick(process);
		getData();
		clearInterval(timeout2);
		timeout2=setInterval(getData,1000);
	} else {
		doUpgrade();
	}

});
function  bindnextclick(process){
	
 	$("#next").unbind("click");
 	if(process =="100") {
 		$("#message").html("备份成功!请点击“下一步”开始执行脚本。<br><span style='font-size:10px;'>备份目录："+$("#backuppath").val()+"</span>");
 		$("#next").click(function(){

	  	});
 	}
}
function next() {
	$.get('/getProcess.do?date='+(new Date()).valueOf(),function(res){
		var pro = res.progress;
		var backuppath = res.backuppath;
		if(pro == "100") {
		    window.onbeforeunload=null;
		    processSql();
		} else {
			top.Dialog.alert("正在备份！");
		}
	});
}
function doUpgrade()
{
	$("#message").html("开始备份...");
	$("#bak").show();
    $.get('/upgrade.do?date='+(new Date()).valueOf(),function(data)
 	{
 		
 		var result = data;

 		if(result.isSuccess=="true")
 		{
	 		clearInterval(timeout2);
	 		$("#pro").css("width","100%");
	     	$("#pro").html("100%");
	     	$("#message").html("备份成功!请点击“下一步”开始执行脚本。<br><span style='font-size:10px;'>系统已备份，备份目录："+decodeURIComponent(decodeURIComponent(result.backuppath))+"</span>");
	     	$("#next").attr("disabled",false);
	     	$("#next").unbind("click");
 		}
 		else if(result.isSuccess=="false")
 		{
 			top.Dialog.confirm("覆盖文件失败，确认还原？",
 					function(){
 						window.location.href="/jsp/backup.jsp";
 					},
 					function(){
 						$("#message").html("覆盖文件失败!<br><span style='font-size:10px;'>系统已备份，备份目录："+decodeURIComponent(decodeURIComponent(result.backuppath))+"</span>");
 			});
 			//window.location.href="/jsp/backup.jsp";
 			return;
 		}
        
  	});	
	timeout2=setInterval(getData,1000);
}
function processSql() {
	
	$.post('/processSql.do?date='+(new Date()).valueOf(),function(data){
		window.location.href="/jsp/processSql.jsp";
	});
}
function getData()
{
	$("#bak").show();
 	$.get('/getProcess.do?date='+(new Date()).valueOf(),function(res){
 			  //var backuppath = $("#backuppath").val();
 			 var pro = res.progress;
 		
 			 var backuppath = res.backuppath;
 			 backuppath = decodeURIComponent(decodeURIComponent(backuppath));
 			 var filecount = res.filecount;
 			 var filecurrent = res.filecurrent;
 			 var covererror = res.covererror;
 			 
 			  $("#backuppath").val(backuppath);
 	     	  $("#pro").css("width",pro+"%");
 	     	  $("#pro").html(pro+"%");
 	     	  $("#pro").show();
 	     	  if(covererror=="1") {//部分文件没有覆盖全
 	     			window.location.href="/jsp/errorFiles.jsp?process="+pro;
 	     			clearInterval(timeout2);
 	     		
 	     	  }
 	     	  if(pro == "0") {
 	     		$("#message").html("正在备份ecology...");
 	     	  } else if(pro == "5"){
 	     		$("#message").html("正在备份ecology...");
 	     	  }else if(pro == "25") {
 	     		$("#message").html("正在备份resin..."); 
 	     	  } else if(pro == "50") {
 	     		$("#message").html("正在覆盖ecology...（补丁包中文件总数："+filecount+",已覆盖数量："+filecurrent+"）<br><span style='font-size:10px;'>系统已备份，备份目录："+backuppath+"</span>");
 	     	  } else if(pro == "75") {
 	     		$("#message").html("正在覆盖resin...（补丁包中文件总数："+filecount+",已覆盖数量："+filecurrent+"）<br><span style='font-size:10px;'>系统已备份，备份目录："+backuppath+"</span>");
 	     	  } else if(pro == "90") {
 	     		$("#message").html("正在删除临时文件...<br><span style='font-size:10px;'>系统已备份，备份目录："+backuppath+"</span>");
 	     	  } else {
 	     		$("#message").html("备份成功!请点击“下一步”开始执行脚本。<br><span style='font-size:10px;'>系统已备份，备份目录："+backuppath+"</span>");
 	     		clearInterval(timeout2);
 	     	  }
  	});	
} 
var dWidth = 600;
var dHeight = 500;
function doOpen(url,title){
	if(typeof dialog  == 'undefined' || dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	dialog.Title = title;
	dialog.Width =  dWidth || 700;
	dialog.Height =  dWidth || 300;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	
	dialog.show();
}