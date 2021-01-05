
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.docs.category.CategoryUtil" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script language="javascript" src="/js/browsertypechooser/btc_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/js/browsertypechooser/browserTypeChooser_wev8.css">
<style type=text/css>
.replaceVal{
   color:#fff;
   background:green;
}
.move_hot{
   cursor:move;
}
.movemark{
   background:url('../../proj/img/move-hot_wev8.png') no-repeat;
}
</style>
<% 
String noneedtree = Util.null2String(request.getParameter("noneedtree"),"0");
%>
<script type="text/javascript">	
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}
    function winclose(){
        parent.winclose();
    }
	function save(){
	    SearchForm.submit();
	}
	function preview(){
		new BTC().init({
			renderTo:jQuery("#btcview"),
			headerURL:"/workflow/field/BTCAjax.jsp?action=queryHead&noneedtree=<%=noneedtree%>",
			contentURL:"/workflow/field/BTCAjax.jsp?action=queryContent&noneedtree=<%=noneedtree%>"
		});
		$(".zDialog_div_content").hide();
	}
	var itemnames = [];
	var tops = [];
	
	$(document).ready(function(){
	  registerMouseDrag();
	  resetArray();
	  $(".DataLight").live('mouseover',function(){
	  	 $(this).addClass("move_hot");
	     $(this).find("td:eq(0)").find("div").addClass("movemark");
	  }).live('mouseout',function(){
	  	 $(this).removeClass("move_hot");
	  	 $(this).find("td:eq(0)").find("div").removeClass("movemark");
	  });
	});
	
	function resetArray(){
		itemnames = [];
		tops = [];
		$("#oTable .searchTerm").each(function(){
	  	   var _html = $(this).html();
	  	   itemnames.push(_html);
	  	   tops.push($(this).offset().top+$('.zDialog_div_content').scrollTop());
	  });
	  var x = 0;
	  $(".order_").each(function(){
	     x++;
	     $(this).val(x);
	  });
	}
	function searchTable(){
	  var i = 0;
	  var t = true;
	  var term = jQuery("#searchVal",parent.document).val(); 
	  $("#oTable .searchTerm").each(function(){
	       var $this = $(this);
	  	   var _html = itemnames[i];
	  	   if(_html.indexOf(term)!= -1){
	  	      if(t == true){
	  	   	  	$('.zDialog_div_content').animate({scrollTop:tops[i]},500);
	  	   	    t = false;
	  	   	  }
	  	      $this.html(_html.replace(term,"<span class='replaceVal'>"+term+"</span>"));
	  	   }else{
	  	      $this.html(_html);
	  	   }
	  	   i++
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
                 var i = 0;
                 $("#oTable .searchTerm").each(function(){
                     $(this).html(itemnames[i]);
                     i++;
                 });
                 if(ui.item.hasClass("notMove")){
                 	e.stopPropagation();
                 }
             },  
             stop:function(e, ui){
                 ui.item.removeClass("e8_hover_tr"); //释放鼠标时，要用ui.item才是释放的行  
                 resetArray();
             }  
         });  
	 }
	
</script>
</HEAD>


<%
   String isFromMode = Util.null2String(request.getParameter("isFromMode"),"0");
   String action = Util.null2String(request.getParameter("action"));
   Map<String,String> groupuseable = new HashMap<String,String>();
   if(action.equals("save")){
	   String sql = "select id from workflow_browsertype";
	   RecordSet.executeSql(sql);
	   while(RecordSet.next()){
		   groupuseable.put(RecordSet.getString("id"),"0");
	   }
	   Enumeration<String> es = request.getParameterNames();
	   while(es.hasMoreElements()){
		   String group = "";
		   String item = "";
		   String order = "";
		   String useable = "";
		  String pname = es.nextElement();
		  if(pname.indexOf("groupid_")!=-1){
			  group = Util.null2String(request.getParameter(pname));
			  item = pname.split("_")[1];
			  order = Util.null2String(request.getParameter("order_"+item));
			  useable = Util.null2String(request.getParameter("useable_"+item),"1");
			  if(useable.equals("1")){
				  groupuseable.put(group,"1");
			  }
			  sql = "update workflow_browserurl set typeid = "+group+",orderid = "+order+",useable = "+useable+" where id = "+item;
			  RecordSet.executeSql(sql);
		  }
	   }
	   
	   Set<Map.Entry<String,String>> gs = groupuseable.entrySet();
	   Iterator<Map.Entry<String,String>> ite = gs.iterator();
	   while(ite.hasNext()){
		   Map.Entry<String,String> entity = ite.next();
		   sql = "update workflow_browsertype set useable = "+entity.getValue()+" where id = "+entity.getKey();
		   RecordSet.executeSql(sql);
	   }
	   
	   BrowserComInfo.removeBrowserCache();
   }

   ArrayList<String> groupid = new ArrayList<String>();
   ArrayList<String> groupname = new ArrayList<String>();
   String excludeIds = "10, 11, 64, 6, 56, 5, 3, 26,235,242,243,246,224,225,14,15,267,261,258,264,265,33,266";
   if(noneedtree.equals("1")){
	   excludeIds += ",256,257";
   }
   String sql = "select id,labelname from workflow_browsertype order by orderid";
   RecordSet.executeSql(sql);
   while(RecordSet.next()){
	   groupid.add(RecordSet.getString("id"));
	   groupname.add(RecordSet.getString("labelname"));
   }
   sql = "update workflow_browserurl set typeid = 13 where typeid is null";
   RecordSet.executeSql(sql);
   sql = "select a.id as groupid,a.orderid as grouporderid,b.id as itemid,b.labelid as itemlabel,b.orderid as itemorderid,a.useable as groupuseable,b.useable as itemuseable from workflow_browsertype a inner join workflow_browserurl b on a.id=b.typeid and b.browserurl is not null and b.id not in ("+excludeIds+")  order by grouporderid asc,itemorderid asc";
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
<DIV id="btcview">
</DIV>
<div class="zDialog_div_content" style="height: 500px;overflow: auto;">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="/workflow/field/browsermanagetype.jsp?action=save" method=post>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top"  onclick="save()">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>" class="e8_btn_top"  onclick="preview()">
			<span id="searchblockspan">
				<span class="searchInputSpan" style="position:relative;width:100px;">	
					<input class="searchInput" style="vertical-align:top;width:70px;" id="searchVal" name="searchVal" value="" onkeypress="javascript:if(event.keyCode==13) {searchTable();}">	
					<span class="middle searchImg">
						<img class="middle" style="vertical-align:top;margin-top:2px;" src="/images/ecology8/request/search-input_wev8.png" onclick="javascript:searchTable();">
					</span>
				</span>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<table class="ListStyle" style="height:400;overflow-x:hidden;overflow-y:auto;">
	<colgroup>
	    <col width="5%">
		<col width="35%">
		<col width="40%">
		<col width="20%">
	</colgroup>
	<tr class=HeaderForXtalbe>
	    <th></th>
		<th><%=SystemEnv.getHtmlLabelNames("81829,81709",user.getLanguage())%></th>
		<th><%=SystemEnv.getHtmlLabelName(81535,user.getLanguage())%></th>
		<th><%=SystemEnv.getHtmlLabelName(18096,user.getLanguage())%></th>
	</tr>
</table>
<table class="ListStyle" cellspacing=0 id="oTable" style="height:400;overflow-x:hidden;overflow-y:auto;">
	<colgroup>
	    <col width="5%">
		<col width="35%">
		<col width="40%">
		<col width="20%">
	</colgroup>
	<TBODY>
	<%
	while(RecordSet.next()){
	%>
	<tr class="DataLight">
	    <td><div style="width: 16px;height: 16px;vertical-align:middle;text-align: center;"></div></td>
		<td class="searchTerm"><%=SystemEnv.getHtmlLabelName(RecordSet.getInt("itemlabel"),user.getLanguage())%></td>
		<td>
			<select class='InputStyle' name="groupid_<%=RecordSet.getString("itemid")%>" style="width:60%">
				<%
				for(int i=0; i<groupid.size();i++){
				%>
				<option value="<%=groupid.get(i)%>" <%if(RecordSet.getString("groupid").equals(groupid.get(i))){%>selected<%}%>><%=groupname.get(i)%>
				<%}%>
			</select>
		</td>
		<td>
			<input type="checkbox" name="useable_<%=RecordSet.getString("itemid")%>" value="0" <%if(RecordSet.getString("itemuseable").equals("0")){%>checked<%}%>>
			<input type="hidden" class="order_" name="order_<%=RecordSet.getString("itemid")%>">
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
</BODY>
</HTML>