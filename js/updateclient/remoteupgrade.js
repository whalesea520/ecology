$(document).ready(function(){
          $("#download").click(function()
          {
            $("#message").html("正在下载升级包,请稍后...");
            $.post('/remoteupgrade.do?date='+(new Date()).valueOf(),function(data){
		           eval("var result="+data);
		           switch(result.error){
		             
		             case  "licenseerror":
		            	 	$("#message").html("获取license信息出错,请检查ecology路径或者ecology数据库已启动!");
		            	 	break;
		             case  "noneed":
		            	 	$("#message").html("当前ecology不需要升级!");
		            	 	break;
		             case  "cannot":
		            	  	$("#message").html("暂时无法升级，请联系泛微公司相关人员!");
		            	  	break;
		             case  "canupgrade":
		            	  	$("#message").html("升级包下载成功,点击下一步进行升级!");
		            	  	$("#btnNext").attr("disabled",false);
		            	  	break;
		           	 case  "cannotupgrade":
		            	  	$("#message").html(result.message);
		            	  	break;
		             case  "interneterror":
		            	   $("#message").html("请检查网络，确保网络通畅!");
		            	   break;
		             case  "responseerror":
		            	   $("#message").html("响应错误，请联系泛微公司相关人员!");
		            	   break;
		             case  "requesterror":
		                   $("#message").html("请求错误，请联系泛微公司相关人员!");
		             		break;
		             case  "saveerror":
		                   $("#message").html("保存升级包错误,请重试!");
		             	   break;
		             case  "getdataerror":
		            	   $("#message").html("获取升级包数据错误，请联系泛微公司相关人员!");
		            	   break;
		             case  "responseempty":
		            	   $("#message").html("响应错误，请联系泛微公司相关人员!");
		            	   break;
		             case  "downloaderror":
		            	   $("#message").html("升级包下载失败，请联系泛微公司相关人员!");
		            	   break;	   
		             case  "unzipsuccess":
		            	  $("#message").html("下载完成!");
		            	  break;
		             }
	            });	
            });
          $("#btnNext").click(function(){
        	  next();
          });
          
});

function next() {
	self.location.href="/jsp/upgradefiles.jsp";
}