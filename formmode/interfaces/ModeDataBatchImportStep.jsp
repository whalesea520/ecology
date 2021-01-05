<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.formmode.excel.ImpExcelServer"%>
<%@page import="java.util.Map"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.general.Util"%>
<%@page import="java.util.Date"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<HTML>
<%
User user = HrmUserVarify.getUser(request,response);
String action = Util.null2String(request.getParameter("action"));
int modeid = Util.getIntValue(request.getParameter("modeid"),0);
int isimport = Util.getIntValue(request.getParameter("isimport"),0);
String dialogid = Util.null2String(request.getParameter("dialogid"));
String tempkey = Util.null2String(request.getParameter("tempkey"));
String key = user.getUID()+"_"+modeid+"_"+tempkey;
%>
<HEAD>
<style type="text/css">

*{padding:0;margin:0;font-size: 12px;}
.ui-stepBar-wrap{position:relative;width:100%;height:70px;background:#ebeef3;overflow:hidden;display:none;z-index:100;}
.ui-stepBar-wrap .ui-stepBar{position:relative;width:90%;height:5px;background:#cccccc;top:22px;left:5%;z-index:101;}
.ui-stepBar-wrap .ui-stepBar .ui-stepProcess{position:relative;width:0;height:5px;background:#516784;top:0;left:0;z-index:102;}
.ui-stepBar-wrap .ui-stepInfo-wrap{width:90%;margin:0 auto;height:100%;}
.ui-stepBar-wrap .ui-stepInfo-wrap .ui-stepInfo{position:relative;float:left;padding-top:12px;text-align:center;}
.ui-stepBar-wrap .ui-stepInfo-wrap .ui-stepInfo .ui-stepSequence{position:relative;padding:4px 8px;border-radius:50%;z-index:103;}
.ui-stepBar-wrap .ui-stepInfo-wrap .ui-stepInfo .ui-stepName{position:relative;line-height:40px;z-index:103;}
.ui-stepBar-wrap .ui-stepInfo-wrap .ui-stepInfo .judge-stepSequence-pre-change,
.ui-stepBar-wrap .ui-stepInfo-wrap .ui-stepInfo .judge-stepSequence-hind-change{cursor:pointer;}
.ui-stepBar-wrap .ui-stepInfo-wrap .ui-stepInfo .judge-stepSequence-pre-change:hover{box-shadow:0 0 3px 1px #516784;}
.ui-stepBar-wrap .ui-stepInfo-wrap .ui-stepInfo .judge-stepSequence-hind-change:hover{box-shadow:0 0 3px 1px #cccccc;}
.judge-stepSequence-pre{background:#516784;color:#ffffff;}
.judge-stepSequence-hind{background:#cccccc;color:#000000;}

.author{position:absolute;bottom:0;width:100%;text-align:center;margin:40px auto;color:#1569ec;text-shadow:1px 1px 0 #e7e7e7, 0 1px 7px #fff;}

a.errorRow{font-size: 15px;color: red;cursor: pointer;font-weight: bold;text-decoration: none;}
</style>
</HEAD>
<body>

<div id="stepBar" class="ui-stepBar-wrap">
	<div class="ui-stepBar">
		<div class="ui-stepProcess"></div>
	</div>
	<div class="ui-stepInfo-wrap">
		<table class="ui-stepLayout" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td class="ui-stepInfo">
					<a class="ui-stepSequence">1</a>
					<p class="ui-stepName"><%=SystemEnv.getHtmlLabelName(129859,user.getLanguage()) %></p>
				</td>
				<td class="ui-stepInfo">
					<a class="ui-stepSequence">2</a>
					<p class="ui-stepName"><%=SystemEnv.getHtmlLabelName(129860,user.getLanguage()) %></p>
				</td>
				<td class="ui-stepInfo">
					<a class="ui-stepSequence">3</a>
					<p class="ui-stepName"><%=SystemEnv.getHtmlLabelName(129861,user.getLanguage()) %></p>
				</td>
				<td class="ui-stepInfo">
					<a class="ui-stepSequence">4</a>
					<p class="ui-stepName"><%=SystemEnv.getHtmlLabelName(129862,user.getLanguage()) %></p>
				</td>
				<td class="ui-stepInfo">
					<a class="ui-stepSequence">5</a>
					<p class="ui-stepName"><%=SystemEnv.getHtmlLabelName(129863,user.getLanguage()) %></p>
				</td>
				<td class="ui-stepInfo">
					<a class="ui-stepSequence">6</a>
					<p class="ui-stepName"><%=SystemEnv.getHtmlLabelName(555,user.getLanguage()) %></p>
				</td>
			</tr>
		</table>
	</div>
</div>

<div id="msgDiv" style="display: none;" >
    <div id="impMsg" style="height: 300px;">
    	<div id="impMsgTitle" style="font-size: 15px;line-height: 30px;padding:5px 10px;border-bottom:1px solid #e6e6e6;"></div>
    	<div id="impMsgError" style="padding:5px 10px;color: red;height: 246px;overflow-y: auto;text-align: left;"></div>
    </div>
</div>

<script type="text/javascript" src="/formmode/js/jquery/jquery-1.8.3.min_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/jquery/step/jquery.easing.1.3_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/jquery/step/stepBar_wev8.js"></script>
<script type="text/javascript">

var dialog;
try{
	if(!dialog){
		dialog = window.parent.getDialog(window);
	}
}catch(e){
}

var step = 1;
var stepBar;
$(function(){
	stepBar.init("stepBar", {
		change : true,
		animation : true,
		speed:600
	});
	showOrHideCloseBtn(false);
	getImpStatus();
});


function showOrHideCloseBtn(isshow){
	var id = "<%=dialogid%>";
	var dialogDraghandle = top.$("#_Draghandle_"+id);
	var closeBtn = dialogDraghandle.find("td div:last");
	if(isshow){
		closeBtn.show();
	}else{
		closeBtn.hide();
	}
}
    
    
var index = 0;

var myTimer = setInterval(function(){ getImpStatus() }, 1000);

function getImpStatus(){
$.ajax({
	type: "GET",
	cache:false,
	url: "/formmode/interfaces/ModeDataBatchImportAjax.jsp?action=getImpStatus",
	data: "modeid=<%=modeid%>&tempkey=<%=tempkey%>",
	dataType:"json",
	success: function(data){
      var s = data["s"];
      if(s==0){
    	  if(index<20){
			  index++;
    	  }else{
    	  	if(6>step){
   			  step = 6;
   			  stepBar.triggerStep = step;
              stepBar.percent();
   		  	}
			clearInterval(myTimer);
    		showOrHideCloseBtn(true);
    	  }
      }else{
   		  var msg = data["msg"];
   		  var status = data["status"];
   		  var errmsg = data["errmsg"];
   		  var time = data["time"];
   		  var tempstep = data["step"];
   		  if(tempstep>0&&tempstep>step){
   			  step = tempstep;
   			  stepBar.triggerStep = step;
              stepBar.percent();
   			  
   		  }
    	  $("#msgDiv").show();
   		  if(errmsg!=""){
   			 $("#impMsgError").html(errmsg).show();
   		  }
   		  if(status==-1){
   			  if(dialog){
	   			  dialog.callbackfun();
   			  }
   			  showOrHideCloseBtn(true);
   			  jQuery("#impMsgTitle").html(msg+",<%=SystemEnv.getHtmlLabelName(33419, user.getLanguage())%>"+time);
   			  if($("#impMsgError").height()+$("#impMsgTitle").height()>300-22){
   				  $("#impMsgError").height(300-$("#impMsgTitle").height()-22);
   			  }
			  clearInterval(myTimer);
   		  }else{
   			  jQuery("#impMsgTitle").html(msg);
   		  }
   	  }
   }
});
  }
</script>

</body>
</html>
