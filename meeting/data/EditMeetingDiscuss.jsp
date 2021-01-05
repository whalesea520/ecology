
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
	//本文件为会议，日程共用相关交流编辑页面
	String sortid = Util.null2String(request.getParameter("sortid"));
	String discussid = Util.null2String(request.getParameter("discussid"));
	String operation = Util.null2String(request.getParameter("operation"));
 %>
 <%if("edit".equals(operation)){ %>
 	<%@ include file="/cowork/uploader.jsp" %>
 <%}%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
</HEAD>
<BODY>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(2108,user.getLanguage());
String needfav ="1";
String needhelp ="";

int topicrows=0;
%>
<BODY>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:exchangeSubmit(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:btn_cancle(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	   <td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button"
				value="<%=SystemEnv.getHtmlLabelName(615, user.getLanguage())%>"
				class="e8_btn_top middle" onclick="exchangeSubmit()">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
	<span id="hoverBtnSpan" class="hoverBtnSpan">
			<span></span>
	</span>
</div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
</div>
<div class="zDialog_div_content">
<FORM id=Exchange name=Exchange action="/discuss/ExchangeOperation.jsp" method=post enctype="multipart/form-data">	
<input type="hidden" name="sortid" value="<%=sortid%>">
<div id="editdiv">
	<jsp:include page="MeetingEditDiscuss.jsp" flush="true">
         <jsp:param name="sortid" value="<%=sortid%>" />
         <jsp:param name="discussid" value="<%=discussid%>" />
         <jsp:param name="operation" value="<%=operation%>" />
     </jsp:include>
</div>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
					id="zd_btn_cancle" class="zd_btn_cancle" onclick="btn_cancle()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<script language=javascript>

 var parentWin = null;
 try{
  parentWin = parent.parent.getParentWindow(window.parent);
 }catch(e){}

/*附加功能*/
function external(externalid){
   if(jQuery("#"+externalid).is(":visible")){
      jQuery("#"+externalid).hide();
      jQuery("#"+externalid+"_img").attr("src","/images/ecology8/meeting/edit_down_wev8.png");
   }else{
      jQuery("#"+externalid).show();
      jQuery("#"+externalid+"_img").attr("src","/images/ecology8/meeting/edit_up_wev8.png");
   }
}

function exchangeSubmit(){
	if(check_form(Exchange,'ExchangeInfo')){
		//enableAllmenu();
	    var oUploader=window[jQuery("#uploadDiv").attr("oUploaderIndex")];
		try{
		    if(oUploader.getStats().files_queued==0) 
		   	doSaveAfterAccUpload();
		    else 
		    oUploader.startUpload();
		}catch(e){
			doSaveAfterAccUpload();
		}
		
	}
	
}

//附件删除
function onDeleteAcc(delspan,delid){
	 var delrelatedacc=jQuery("#delrelatedacc").val();
	 var relatedacc=jQuery("#edit_relatedacc").val();
	 relatedacc=","+relatedacc+",";
	 delrelatedacc=","+delrelatedacc+",";
	 if(jQuery("#"+delspan).is(":hidden")){
		delrelatedacc=delrelatedacc+delid+",";
		var index=relatedacc.indexOf(","+delid+",");
		relatedacc=relatedacc.substr(0,index+1)+relatedacc.substr(index+delid.length+2);
		jQuery("#"+delspan).show();    
	 }else{
		var index=delrelatedacc.indexOf(","+delid+",");
		delrelatedacc=delrelatedacc.substr(0,index+1)+delrelatedacc.substr(index+delid.length+2);
						         
		relatedacc=relatedacc+delid+",";
						         
		jQuery("#"+delspan).hide(); 
	}
		relatedacc = relatedacc.substr(0,relatedacc.length-1);
		delrelatedacc = delrelatedacc.substr(0,delrelatedacc.length-1);
		jQuery("#edit_relatedacc").val(relatedacc.substr(1,relatedacc.length));
		jQuery("#delrelatedacc").val(delrelatedacc.substr(1,delrelatedacc.length));
} 

function doSaveAfterAccUpload(){
	 //Exchange.submit();
	//提交参数
    //var paramnames="sortid,method1,types,docids,relatedwf,relatedcus,projectIDs,relatedprj,relateddoc,discussid,edit_relatedacc,delrelatedacc".split(",");
    
    //var param="{";
    //for(var i=0;i<paramnames.length;i++){
    //	if(jQuery("input[name='"+paramnames[i]+"']").length > 0){
    //		var value=jQuery("input[name='"+paramnames[i]+"']").val();
    //		param=param+paramnames[i]+":'"+value+"',";
    //	}
   // }
	
    //param=param+"ExchangeInfo"+":'"+encodeURIComponent($GetEle("ExchangeInfo").value)+"',";

	//param=param.substr(0,param.length-1)+"}";
	jQuery.post("/discuss/ExchangeOperation.jsp",{sortid:jQuery("input[name='sortid']").val(),method1:jQuery("input[name='method1']").val(),docids:jQuery("input[name='docids']").val(),types:jQuery("input[name='types']").val(),relatedwf:jQuery("input[name='relatedwf']").val(),relatedcus:jQuery("input[name='relatedcus']").val(),projectIDs:jQuery("input[name='projectIDs']").val(),relatedprj:jQuery("input[name='relatedprj']").val(),relateddoc:jQuery("input[name='relateddoc']").val(),discussid:jQuery("input[name='discussid']").val(),edit_relatedacc:jQuery("input[name='edit_relatedacc']").val(),delrelatedacc:jQuery("input[name='delrelatedacc']").val(),ExchangeInfo:encodeURIComponent($GetEle("ExchangeInfo").value)},function(data){
		parentWin.toPage(1);
		 btn_cancle();
		
	});
}
function btn_cancle(){
	
     parentWin.diag_vote.close();
}
jQuery(document).ready(function(){
	resizeDialog(document);
	$("#othbtndiv").css("display","none");
	<%if("edit".equals(operation)){ %>
	if(jQuery("#uploadDiv").length>0){
   		bindUploaderDiv(jQuery("#uploadDiv"),"relateddoc"); 
	}
	<%}%>
});
</script>
</body>
</html>