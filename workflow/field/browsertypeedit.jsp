
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<style type=text/css>
.move_hot{
   cursor:move;
}
.movemark{
   background:url('../../proj/img/move-hot_wev8.png') no-repeat;
}
</style>

<script type="text/javascript">	
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}
	$(function(){
	   registerMouseDrag();
	   $("input[name^=labelname_]").each(function(){
	      if($(this).val()==""){
	        $(this).after('<img src="/images/BacoError_wev8.gif" align=absmiddle>');
	      }else{
	        $(this).next("img").remove();
	      }
	   });
	   $("input[name^=labelname_]").live("change",function(){
	      if($(this).val()==""){
	        $(this).after('<img src="/images/BacoError_wev8.gif" align=absmiddle>');
	      }else{
	        $(this).next("img").remove();
	      }
	   });
	   $(".DataLight").live('mouseover',function(){
	  	 $(this).addClass("move_hot");
	     $(this).find("td:eq(0)").find("div").addClass("movemark");
	   }).live('mouseout',function(){
	  	 $(this).removeClass("move_hot");
	  	 $(this).find("td:eq(0)").find("div").removeClass("movemark");
	   });
	   resetArray();
	});
    function winclose(){
        parent.winclose();
    }
	
	function addRow(){
		$.ajax({
	       url:"/workflow/field/BTCAjax.jsp?action=addrow",
	       type:"post",
	       success:function(id){
	          var $table = $("#oTable");   
			  var _html = '<tr class="DataLight"><td><div style="width: 16px;height: 16px;vertical-align:middle;text-align: center;"></div></td><td class="searchTerm"><input type="checkbox"  name="select_'+$.trim(id)+'" value="'+$.trim(id)+'">';
			  _html += '</td><td><input name="labelname_'+$.trim(id)+'"><img src="/images/BacoError_wev8.gif" align=absmiddle></td><td><input type="checkbox" name="useable_'+id+'" value="0">';
			  _html += '<input type="hidden" name="changeable_'+$.trim(id)+'" value="1">';
			  _html += '<input type="hidden" class="order_" name="order_'+$.trim(id)+'">';
			  _html += '</td></tr>';
			  $table.append(_html);
			  jQuery('body').jNice();
			  resetArray();
	       }
	    });
	}
	
	function save(){
	    if($("img[align=absmiddle]").size()!=0){
	       Dialog.alert("<%=SystemEnv.getHtmlLabelName(129044, user.getLanguage())%>");
	       return;
	    }
	    SearchForm.submit();
	}
	
	function resetArray(){
	  var x = 0;
	  $(".order_").each(function(){
	     x++;
	     $(this).val(x);
	  });
	}
	
	function deleteRow(){
	    var ids = [];
	    var names= [];
	    var undoNames = [];
	    var undoIds = [];
	    $("input[name^=select_]").each(function(){
	       if($(this).is(":checked")){
	       	  ids.push($(this).val());
	       	  names.push($("input[name=labelname_"+$(this).val()+"]").val());
	       }
	    });
	    $.ajax({
	       url:"/workflow/field/BTCAjax.jsp?action=delete&ids="+ids.join(","),
	       type:"post",
	       success:function(data){
	         if(!!data){
	             var json = eval('('+data+')');
	             undoIds = json.undoIds.split(",");
		         $("input[name^=select_]").each(function(){
			       if($(this).is(":checked")){
			          if(json.undoIds.indexOf($(this).val())==-1)
			       	  	$(this).closest(".DataLight").remove();
			       }
			     });
			 }
			 var p;
			 while(p = undoIds.shift()){
			   for(var i = 0 ;i<ids.length;i++){
			      if(ids[i] == p){
			         undoNames.push(names[i]);
			      }
			   }
			 }
			 if(undoNames.length>0){
			 	Dialog.alert("<%=SystemEnv.getHtmlLabelName(178, user.getLanguage())%>"+undoNames.join(",")+"<%=SystemEnv.getHtmlLabelName(129045, user.getLanguage())%>");
			 }
			 resetArray();
	       }
	    });
	}
	
	
	/**
     *注册控件拖拽事件
     * @param option
     * @constructor
     */
	 function registerMouseDrag(){		
		var fixHelper = function(e, ui) {
            ui.children().each(function() { 
                jQuery(this).width(jQuery(this).width());     //在拖动时，拖动行的cell（单元格）宽度会发生改变。在这里做了处理就没问题了
                jQuery(this).height(jQuery(this).height());  
            });  
            return ui;  
        };     
        jQuery("#oTable tbody").sortable({                //这里是talbe tbody，绑定 了sortable  
             helper: fixHelper,                      //调用fixHelper  
             axis:"y",  
             start:function(e, ui){
                 ui.helper.addClass("e8_hover_tr")     //拖动时的行，要用ui.helper  ;
                 ui.item.addClass("move_hot");
                 if(ui.item.hasClass("notMove")){
                 	e.stopPropagation();
                 }
             },  
             stop:function(e, ui){
                 ui.item.removeClass("e8_hover_tr"); //释放鼠标时，要用ui.item才是释放的行  
                 ui.item.removeClass("move_hot");
                 resetArray();
             }  
         });  
	 }
</script>
</HEAD>


<%
    String action = Util.null2String(request.getParameter("action"));
    String id = "";
	String labelname = "";
	String useable = "";
	String changeable = "1";
	String sql = "";
	String order = "";
	if(action.equals("save")){
		   RecordSet.executeSql(sql);
		   Enumeration<String> es = request.getParameterNames();
		   while(es.hasMoreElements()){
			  String pname = es.nextElement();
			  if(pname.indexOf("labelname_")!=-1){
				  labelname = Util.null2String(request.getParameter(pname));
				  id = pname.split("_")[1];
				  useable = Util.null2String(request.getParameter("useable_"+id),"1");
				  order = Util.null2String(request.getParameter("order_"+id));
				  sql = "update workflow_browserurl set useable = "+useable+" where typeid = "+id;
				  RecordSet.executeSql(sql);
				  changeable = Util.null2String(request.getParameter("changeable_"+id),"0");
				  sql = "update workflow_browsertype set labelname='"+labelname+"',useable="+useable+",changeable="+changeable+",orderid="+order+" where id ="+id;
				  RecordSet.executeSql(sql);
			  }
		   }
	}
   sql = "select * from workflow_browsertype order by orderid";
   RecordSet.executeSql(sql);
%>


<BODY style="overflow:hidden">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:save(),_top} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(221,user.getLanguage())+",javascript:preview(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<DIV id="btcview" align=right style="">
</DIV>
<div class="zDialog_div_content" style="height: 500px;overflow: auto;">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="/workflow/field/browsertypeedit.jsp?action=save" method=post>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" class="e8_btn_top"  onclick="addRow()">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top"  onclick="save()">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>" class="e8_btn_top"  onclick="deleteRow()">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<table class="ListStyle" style="height:400;overflow-x:hidden;overflow-y:auto;">
	<colgroup>
		<col width="5%">
		<col width="5%">
		<col width="70%">
		<col width="20%">
	</colgroup>
	<tr class=HeaderForXtalbe>
	    <th></th>
		<th></th>
		<th style="cursor: default;text-indent:45px;"><%=SystemEnv.getHtmlLabelName(23051,user.getLanguage())%></th>
		<th style="cursor: default;"><%=SystemEnv.getHtmlLabelName(18096,user.getLanguage())%></th>
	</tr>
</table>
<table class="ListStyle" cellspacing=0 id="oTable" style="height:400;overflow-x:hidden;overflow-y:auto;">
	<colgroup>
		<col width="5%">
		<col width="5%">
		<col width="70%">
		<col width="20%">
	</colgroup>
	<TBODY>
	<%
	while(RecordSet.next()){
	%>
	<tr class="DataLight">
	    <td><div style="width: 16px;height: 16px;vertical-align:middle;text-align: center;"></div></td>
		<td class="searchTerm">
		   <%if(RecordSet.getString("changeable").equals("1")){%>
		   		<input type="checkbox"  name="select_<%=RecordSet.getString("id")%>" value="<%=RecordSet.getString("id")%>">
		   <%}%>
		</td>
		<td>
			<input name="labelname_<%=RecordSet.getString("id")%>" size="20" value="<%=RecordSet.getString("labelname")%>">
		</td>
		<td>
			<input type="checkbox" name="useable_<%=RecordSet.getString("id")%>" value="0" <%if(RecordSet.getString("useable").equals("0")){%>checked<%}%>>
			<input type="hidden" name="changeable_<%=RecordSet.getString("id")%>" value="<%=RecordSet.getString("changeable")%>">
			<input type="hidden" class='order_' name="order_<%=RecordSet.getString("id")%>">
		</td>
	</tr>
	<%}%>
	</TBODY>
</table>
</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	    <wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes='{\"groupDisplay\":\"none\"}'>
				<wea:item type="toolbar">
			    	<input type="button" accessKey="S"  id="btnclose" value="<%="T-"+SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="winclose()">
				</wea:item>
			</wea:group>
		</wea:layout>
</div>
<script language="javascript" >
</script>
</BODY>
</HTML>