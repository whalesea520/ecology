<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>
<%
	if (!HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",
			user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);

</script>
<!--For Jquery UI-->
<link href="/js/jquery/ui/jquery-ui_wev8.css" type="text/css" rel=stylesheet>
<script type="text/javascript" src="/js/jquery/ui/ui.core_wev8.js"></script>
<!--For Dialog-->
<script type="text/javascript" src="/js/jquery/ui/ui.dialog_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/hrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	//jQuery("#searchfrm").submit();
}
</script>
<STYLE type=text/css>
#loading{
    position:absolute;
    left:45%;
    background:#ffffff;
    top:40%;
    padding:8px;
    z-index:20001;
    height:auto;
    border:1px solid #ccc;
    display:none;
}
</STYLE>

</head>
<%  String isclose = Util.null2String(request.getParameter("isclose"));
    String isDialog = Util.null2String(request.getParameter("isdialog"));
	String imagefilename = "/images/hdHRMCard_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(17887, user.getLanguage());
	String needfav = "1";
	String needhelp = "";
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:dosubmit(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(24644,user.getLanguage())+",javascript:openHistoryLog(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	<td></td>
	<td class="rightSearchSpan" style="text-align:right;">
		<input type=button class="e8_btn_top" onClick="dosubmit(this)" value="<%=SystemEnv.getHtmlLabelName(615, user.getLanguage())%>">
		<input type=button class="e8_btn_top" onClick="openHistoryLog()" value="<%=SystemEnv.getHtmlLabelName(24644, user.getLanguage())%>">
		<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
	</td>
	</tr>
</table>
<FORM id=frmMain name=frmMain action="HrmImportProcess.jsp" method=post enctype="multipart/form-data" target="subframe">
 <input type=hidden id="improstatus" name="improstatus"  value="0" />
	<wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(24638, user.getLanguage())%></wea:item>
      <wea:item>
        <select name="keyField" id="keyField" style="width: 80px;">
            <option value="workcode"><%=SystemEnv.getHtmlLabelName(714, user.getLanguage())%></option>
            <option value="loginid"><%=SystemEnv.getHtmlLabelName(412, user.getLanguage())%></option>
            <option value="lastname"><%=SystemEnv.getHtmlLabelName(413, user.getLanguage())%></option>
        </select>
        <%--
        <span style="" >
                <%=SystemEnv.getHtmlLabelName(24646, user.getLanguage())%>
        </span>
        --%>
      </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(24863, user.getLanguage())%></wea:item>
      <wea:item>
          <select id="importType" name="importType" style="width: 80px"  onchange="jsShowSpan()">
              <option value="add"><%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%></option>
              <option value="update"><%=SystemEnv.getHtmlLabelName(17744, user.getLanguage())%></option>
          </select>
        <span id=remand style="display: none;color: red;" >
                &nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(81696, user.getLanguage())%>
        </span>   
     	</wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(16699, user.getLanguage())%></wea:item>
      <wea:item>
        <input class=inputstyle style="width: 360px" type="file" name="excelfile" onchange='checkinput("excelfile","excelfilespan");this.value=trim(this.value)'><SPAN id=excelfilespan>
         <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
        </SPAN>
      </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(19971, user.getLanguage())%></wea:item>
      <wea:item><a href='/hrm/resource/inputexcellfile/hrminput.xls' style="color: #30b5ff"><%=SystemEnv.getHtmlLabelName(28576, user.getLanguage())%></a>&nbsp;<%=SystemEnv.getHtmlLabelName(20211, user.getLanguage())%></wea:item>
		</wea:group>
	</wea:layout> 
	
	<wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())+SystemEnv.getHtmlLabelName(85,user.getLanguage())%>' attributes="{'samePair':'RemarkInfo','groupOperDisplay':'none','itemAreaDisplay':'block'}">
		  <wea:item attributes="{'colspan':'2'}">
		 	1、<%=SystemEnv.getHtmlLabelName(125868, user.getLanguage())%>
			<BR><BR>
			2、<%=SystemEnv.getHtmlLabelName(128365, user.getLanguage())%>
			<BR><BR>
			3、<%=SystemEnv.getHtmlLabelName(81697, user.getLanguage())%>
			<BR><BR>
			4、<%=SystemEnv.getHtmlLabelName(81698, user.getLanguage())%>
			<BR><BR>
			5、<%=SystemEnv.getHtmlLabelName(81699, user.getLanguage())%>
			<BR><BR>
			6、<%=SystemEnv.getHtmlLabelName(81700, user.getLanguage())%>
			<BR><BR>
			7、<%=SystemEnv.getHtmlLabelName(81701, user.getLanguage())%>
			<BR><BR>			
			8、<%=SystemEnv.getHtmlLabelName(81702, user.getLanguage())%>
			<BR><BR>
			9、<%=SystemEnv.getHtmlLabelName(81703, user.getLanguage())%>
			<BR><BR>
			10、<%=SystemEnv.getHtmlLabelName(125869, user.getLanguage())%>		
		</wea:item>
		</wea:group>
	</wea:layout>	
	
   <!-- 隐藏提交iframe -->
   <iframe name='subframe' id="subframe" style='display:none'></iframe>
</form>
<%if("1".equals(isDialog)){ %>
   </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
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
<!-- 导入等待 -->
 <div id="loading">	
		<span  id="loading-msg"><img src="/images/loading2_wev8.gif"><%=SystemEnv.getHtmlLabelName(24635, user.getLanguage())%></span>
 </div>

<!-- 结果展示弹出层 -->
<div id="divInfo" title="<%=SystemEnv.getHtmlLabelName(24635, user.getLanguage())%>">
     <DIV style="BORDER-BOTTOM: #bbbbbb 1px solid; width:100%;height:310px">
	        <DIV id="content" style="OVERFLOW-y: auto;OVERFLOW-x: hidden; WIDTH: 100%; HEIGHT: 310px">
				 		<TABLE id="head" class=ListStyle cellspacing=1 border="0" cellspacing="0" style="display: none;">
			        <TR class=HeaderForXtalbe>
			        	<TH width="10%" id="keyColum">
			        	<%=SystemEnv.getHtmlLabelName(714, user.getLanguage())%>
			        	</TH>
				        <TH width="55%"><%=SystemEnv.getHtmlLabelName(141, user.getLanguage())%></TH>
				        <TH width="10%"><%=SystemEnv.getHtmlLabelName(104, user.getLanguage())%></TH>
					    <TH width="25%"><%=SystemEnv.getHtmlLabelName(602, user.getLanguage())%></TH>
			        </TR>
			      </TABLE>
			      <div id="result"></div>
           </DIV>
	 </DIV>
      <div style="padding-top: 5px" align="center">
				<input id="closeBtn" type="button" value="[<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>]" class="zd_btn_cancle" onclick="closeDiv();">
		    <span id="downLogFile" style="padding-left: 20px"></span>
	  </div>  
	  
</div>
<iframe id="downLoad" src="" style="display: none;"></iframe>
<script language=javascript>
var index=0; //控制从resultList中读取数据的位置   
var timeId;  //定时器
var saveBtn;
/*jQuery dialog 初始化*/
$("#divInfo").dialog({   
			autoOpen: false,
        	modal: true, 
        	height: 400,
        	width:  650,
        	draggable: false,
        	resizable: false
	     });
	     
function check_form(frm)
{
	if(document.frmMain.excelfile.value==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>！");
		return false;
	}
	
	return true;
}
/*提交请求，通过隐藏iframe提交*/
function dosubmit(obj) {
  saveBtn=obj;
  saveBtn.disabled = true;
   var improstatus= document.getElementById("improstatus").value;
  if(improstatus=='1'){
    return;
  }
  document.getElementById("improstatus").value='1';

	$("#result").html("");
  if(check_form(document.frmMain)) {
  		var keyFieldValue=$("#keyField").val();    //获取重复性验证字段，在显示日志中只显示重复性验证列
      if(keyFieldValue=="workcode")      //编号
          $("#keyColum").html("<%=SystemEnv.getHtmlLabelName(714, user.getLanguage())%>");
      else if(keyFieldValue=="loginid")  //登录名 
          $("#keyColum").html("<%=SystemEnv.getHtmlLabelName(412, user.getLanguage())%>");    
      else if(keyFieldValue=="lastname") //姓名
          $("#keyColum").html("<%=SystemEnv.getHtmlLabelName(413, user.getLanguage())%>");
      $("#divInfo").dialog('open');   //打开dialog
      //$("#keyField").hide();          //隐藏select 在IE6中bug
      //$("#importType").hide();
      $(".ui-dialog-titlebar-close").css("display","none");//隐藏 jQuery dialog 标题栏默认的关闭按钮
      $( "#divInfo" ).dialog( "option", "title", '<%=SystemEnv.getHtmlLabelName(24635, user.getLanguage())%>' );  //设置状态为正在导入
   		index=0;   //初始化为 0     
      timeId=window.setInterval(getData,2000); //定时读取
      $("#loading").css("display","");

      document.frmMain.submit() ; 
  }
}

/*每次读取都返回，读取位置，如果调用该函数则说明，显示的事导入结果*/
function changeIndex(resultIndex){
  index=resultIndex;
  //$("#head").css("display",""); 
}

/*读取数据 index 为开始读取位置*/
function getData(){
		var selectText = $("#keyField option:selected").text();
		var tableHead = "<TABLE class=ListStyle cellspacing=1 >" +
		 "<TBODY>" + 
		 "<TR class=HeaderForXtalbe>" + 
		 "<th width=\"10%\">"+selectText+"</th>" + 
		 "<th width=\"55%\"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></th>" + 
		 "<th width=\"10%\"><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></th>" + 
		 "<th width=\"25%\"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></th>" + 
		 "</TR></TBODY>" + 
		 "</TABLE>";
	$.get("HrmImportLog.jsp?index="+index,function(data){
		//需要显示全部日志 
		if(jQuery("#result").html() == "") {
		  jQuery("#result").append(tableHead);
     }
	   jQuery("#result").children("TABLE").children("TBODY").append(data);
	});

}

/*返回处理函数 message状态 logfile导入日志文件名*/
function callback(message,logFile){
   window.clearInterval(timeId);
   $("#loading").css("display","none");
   $("#closeBtn").attr("disabled",false);
   
   if(message=='error'){
      $( "#divInfo" ).dialog( "option", "title", '<%=SystemEnv.getHtmlLabelName(24647, user.getLanguage())%>' );  //设置状态为错误提示
   }
   if(message=='ok'){
     $( "#divInfo" ).dialog( "option", "title", '<%=SystemEnv.getHtmlLabelName(24645, user.getLanguage())%>' );  //设置状态为导入完成
     if(logFile!='null')
       $("#downLogFile").html("<input type=button value='[<%=SystemEnv.getHtmlLabelName(24835, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>]' class=zd_btn_cancle onclick=downLoadLog('"+logFile+"')>");
   }
}


/*关闭弹出层刷新页面*/
//  function closeDiv(){
//   $("#divInfo").dialog("close");      //关闭dialog
//   window.location.reload();
//}

//modify yangdacheng 2011-12-02
/*关闭弹出层不刷新页面*/
  function closeDiv(){
	document.getElementById("improstatus").value='0';
	//saveBtn.disabled = false;
   $("#divInfo").dialog("close");      //关闭dialog

}


/*打开历史导入记录*/
function openHistoryLog(){
	$("#result").html("");
var tableHead = "  <TABLE class=ListStyle cellspacing=1 >" +
		 "<TBODY>" + 
		 "<TR class=HeaderForXtalbe>" + 
		 "<th width=\"30%\"><%=SystemEnv.getHtmlLabelName(20515,user.getLanguage())%></th>" + 
		 "<th width=\"50%\"><%=SystemEnv.getHtmlLabelName(17517,user.getLanguage())%></th>" + 
		 "<th width=\"10%\"><%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%></th>" + 
		 "<th width=\"10%\"><%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%></th>" + 
		 "</TR></TBODY>" + 
		 "</TABLE>";

  $("#divInfo").dialog('open');   //打开dialog
  //$("#keyField").hide();
  //$("#importType").hide();
  $(".ui-dialog-titlebar-close").css("display","none");//隐藏 jQuery dialog 标题栏默认的关闭按钮
  $( "#divInfo" ).dialog( "option", "title", '<%=SystemEnv.getHtmlLabelName(24644, user.getLanguage())%>' );  //设置状态为导入历史记录
  $.get("HrmImportHistoryLog.jsp",function(data){
		 //$("#result").append(data);
	   if ($("#result").html() == "") {
		  $("#result").append(tableHead);
       }
	   $("#result").children("TABLE").children("TBODY").append(data);
	});
}
/*下载导入日志*/
function downLoadLog(path){
  $("#downLoad").attr("src","HrmImportHistoryLog.jsp?option=downLoad&path="+encodeURI(path));
}
/*删除日志文件*/
function deleteLog(path,obj){
  //if(window.confirm('<%=SystemEnv.getHtmlLabelName(23271, user.getLanguage())%>'+"?"))
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(23271,user.getLanguage())%>",function(){
		$.post("HrmImportHistoryLog.jsp?option=delete&path="+encodeURI(path),function(data){
     	if($.trim(data)=="true")
       		$(obj).parent().parent().remove();
 		});
 	})
}
function jsShowSpan(){
 	jQuery("#remand").hide();
	if(jQuery("#importType").val()=="update") jQuery("#remand").show();
}
</script>

</BODY>
</HTML>
