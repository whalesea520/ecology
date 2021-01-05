
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%  //本文件为会议，日程共用相关交流展示页面 %>
<FORM id=Exchange name=Exchange action="/discuss/ExchangeOperation.jsp" method=post enctype="multipart/form-data">	
<input type="hidden" name="sortid" value="<%=sortid%>">
<div id="editdiv">
	<jsp:include page="/meeting/data/MeetingEditDiscuss.jsp" flush="true">
		<jsp:param name="types" value="<%=types%>" />
         <jsp:param name="sortid" value="<%=sortid%>" />
         <jsp:param name="discussid" value="-1" />
         <jsp:param name="operation" value="edit" />
     </jsp:include>
</div>
  <TABLE class=ListStyle cellspacing=1 style="width:100%;">

    <TBODY>
	    <TR class="header" style="height:1px !important;">
		   <td style="height:1px !important;"></td>
	    </TR>
	</tbody>
  </table>
  </FORM>
  <TABLE cellspacing=1 style="width:100%;">
	 <COLGROUP>
    	<COL width="10px">
    	<COL width="">
    	<COL width="10px">
    <TBODY>
	    <TR>
		<td></td>
	     <td>
			<div id="discsdiv" style="overflow-y: hidden;position: relative;width:100%;height:355px;">
			<div id="discusses"></div>
			</div>
		 </td>
         <td></td>
	    </TR>
	</tbody>
  </table>
<script language=javascript>

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
//分页
function toPage(pageNum){
  url="/meeting/data/MeetingDiscussRd.jsp?sortid=<%=sortid%>&types=<%=types%>&currentpage="+pageNum;
  jQuery.post(url,{},function(data){
     var tempdiv=jQuery("<div>"+data+"</div>");
     jQuery("#discusses").html("");
     jQuery("#discusses").append(tempdiv);

     jQuery(".thtd").live('mouseenter', function() {
      		jQuery(this).addClass("Selected");
      		jQuery(this).children(".hoverDiv").show();
	  }).live('mouseleave', function() {
	      jQuery(this).removeClass("Selected");
	      jQuery(this).children(".hoverDiv").hide();
	  });
     
	 jQuery(".operHoverSpan").live('mouseenter', function() {
         jQuery(this).addClass("operHoverSpan_hover");
	  }).live('mouseleave', function() {
	      jQuery(this).removeClass("operHoverSpan_hover");
	  });
	  jQuery(".operHover_hand").live("click",function(){
	  	jQuery(this).find("a").click();
	  });
	  jQuery("#discsdiv").perfectScrollbar("update");
  });
}


//转到
function toGoPage(totalpage,topage){
 	var topagenum=jQuery("#"+topage);
 	var topage =topagenum.val();
 	if(topage <0 || topage!=parseInt(topage) ) {
          Dialog.alert("<%=SystemEnv.getHtmlLabelName(25167,user.getLanguage())%>");  //请输入整数
          topagenum.val(""); //置空
          topagenum.focus();
 	      return ;
 	 }
 	if(topage>totalpage) topage=totalpage; //大于最大页数
 	if(topage==0) topage=1;                //小于最小页数 
 	toPage(topage);
}

function pmouseoverN(obj, flag) {
    if (obj == undefined) {
        return;
    }
    if (flag == true) {
    	if (jQuery(obj).attr("class") == "weaverTableNextPage") {
    		jQuery(obj).attr("class", "weaverTableNextSltPage");
    	} else {
    		jQuery(obj).attr("class", "weaverTablePrevSltPage");
    	}
    } else {
        if (obj.className == "weaverTableNextSltPage") {
        	jQuery(obj).attr("class", "weaverTableNextPage");
        } else {
        	jQuery(obj).attr("class", "weaverTablePrevPage");
        }
    }
}
function exchangeSubmit(obj){
	if(check_form(Exchange,'ExchangeInfo')){
		//enableAllmenu();
		obj.disabled = true;
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


function doSaveAfterAccUpload(){
	 //Exchange.submit();
	//提交参数
   // var paramnames="sortid,method1,types,docids,relatedwf,relatedcus,projectIDs,relatedprj,relateddoc,discussid,edit_relatedacc,delrelatedacc".split(",");
    //var param="";
    //for(var i=0;i<paramnames.length;i++){
    //	var value=jQuery("input[name='"+paramnames[i]+"']").val();
    //	param=param+paramnames[i]+":'"+value+"',";
    //}
	
    //param=param+'ExchangeInfo"+":"'+encodeURIComponent($GetEle("ExchangeInfo").value).replace(/\'/g,"%27")+'",';

	//param=param.substr(0,param.length-1)+"";

	jQuery.post("/discuss/ExchangeOperation.jsp",{sortid:jQuery("input[name='sortid']").val(),method1:jQuery("input[name='method1']").val(),docids:jQuery("input[name='docids']").val(),types:jQuery("input[name='types']").val(),relatedwf:jQuery("input[name='relatedwf']").val(),relatedcus:jQuery("input[name='relatedcus']").val(),projectIDs:jQuery("input[name='projectIDs']").val(),relatedprj:jQuery("input[name='relatedprj']").val(),relateddoc:jQuery("input[name='relateddoc']").val(),discussid:jQuery("input[name='discussid']").val(),edit_relatedacc:jQuery("input[name='edit_relatedacc']").val(),delrelatedacc:jQuery("input[name='delrelatedacc']").val(),ExchangeInfo:encodeURIComponent($GetEle("ExchangeInfo").value)},function(data){
		clearRemark();
		//editDiscuss(-1);
		toPage(1);
		try{
			parent.reloadData();
		}catch(e){}
	});
	

}

function clearRemark(){
        //隐藏附加功能
       	jQuery("#external").hide();
      	jQuery("#external"+"_img").attr("src","/images/ecology8/meeting/edit_down_wev8.png");
        //清空浏览按钮及对应隐藏域
		jQuery("#external").find(".Browser").siblings("span").html("");
		jQuery("#external").find(".Browser").siblings("input[type='hidden']").val("");
		jQuery("#external").find(".e8_os").find("input[type='hidden']").val("");
		jQuery("#external").find(".e8_outScroll .e8_innerShow span").html("");
 		jQuery("#ExchangeInfo").val("");
		$GetEle("btnSubmit").disabled = false;

 		//相关附件
 		if(jQuery("#uploadDiv").length>0)
     		bindUploaderDiv(jQuery("#uploadDiv"),"relateddoc"); //重新附件上传绑定
 		
}


function editDiscuss(disid){
	 jQuery.post("/meeting/data/MeetingEditDiscuss.jsp?operation=edit&types=<%=types%>",{discussid:disid},function(data){
      if(jQuery.trim(data)!=""){
        jQuery("#editdiv").html("");
		try{
			document.getElementById('editdiv').innerHTML = "<div>"+data+"</div>";
	    //jQuery("#editdiv").append(jQuery("<div>"+data+"</div>"));
		}catch(e){}
		jQuery("#discsdiv").perfectScrollbar("update");
	    if(jQuery("#uploadDiv").length>0){
     		bindUploaderDiv(jQuery("#uploadDiv"),"relateddoc"); 
		}
      }
   });
}

function editDiscussNew(disid,sortid){
	showDialog("/meeting/data/MeetingOthTab.jsp?toflag=discuss&types=<%=types%>&sortid=<%=sortid%>&operation=edit&discussid="+disid,"<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(15153, user.getLanguage())%>",600,400);
}

function deleteDiscuss(discussid){
	 jQuery.post("/discuss/ExchangeOperation.jsp?method1=delete&types=<%=types%>",{discussid:discussid},function(data){
      	toPage(1);
   });
}


jQuery(document).ready(function(){
	clearRemark();
	toPage(1);
});

function resetDiv(){
	if(jQuery(".zDialog_div_content")&&jQuery(".zDialog_div_content").length>0){
		jQuery("#discsdiv").css("height",(jQuery(".zDialog_div_content").height()-112)+"px");
	}
	jQuery("#discsdiv").perfectScrollbar();
}
</script>