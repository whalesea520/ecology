<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/element/viewCommon.jsp"%>
<%@ include file="common.jsp" %>

<!-- 判断元素是否可以独立显示，引入样式 -->
<%
	String indie = Util.null2String(request.getParameter("indie"), "false");
	if ("true".equals(indie)) {
%>
		<%@ include file="/homepage/HpElementCss.jsp" %>
<%	} %>

<%
String displayLayout = (String)valueList.get(nameList.indexOf("displayLayout"));
String classname = "";
if(displayLayout.equals("1")){
	classname = "oneCol";
}else{
	classname = "twoCol";
}

int eHeight = 185;

rs_Setting.executeSql("select height from hpelement where id =  "+eid);
if(rs_Setting.next()){
	if(rs_Setting.getInt("height")>0){
		eHeight = rs_Setting.getInt("height");
	}
}
eHeight -= 30; 
%>	
<div class="e8_box addwf" id="addwf_<%=eid %>" >
		 <div style="position: relative; height: 30px;">
		 		<ul class="tab_menu" style="position: absolute;">
		 			<li class="current" wftype='usedtodo'>
						<a target="tabcontentframe">
							<%=SystemEnv.getHtmlLabelName(28184,user.getLanguage()) %>
						</a>
					</li>
					<li class="" wftype=''>
						<a target="tabcontentframe">
							<%=SystemEnv.getHtmlLabelName(18030,user.getLanguage()) %>
						</a>
					</li>
					
					</ul>
		 </div>
		<div style="overflow: visible">
			<div id="addwflist_<%=eid %>" style="overflow-x:hidden">
				
			</div>
		</div>
		
</div>	

<script language="javascript">
		jQuery('#addwf_<%=eid %>').Tabs({
	        getLine:1,
	       
	    });
	    	
		$(document).ready(function(){
			var outHet = <%=eHeight%>;
	    	$("#content_view_id_<%=eid %>").height(outHet + 30)
	    	$("#content_view_id_<%=eid%>").css("overflow","hidden");
	    	queryData<%=eid %>(<%=eid %>,'<%=classname%>','usedtodo',outHet)
		});
	    
	    jQuery('#addwf_<%=eid %>').find("li").bind("click",function(){
	     	 type = $(this).attr("wftype")
	     	$("#addwf_<%=eid %>").find(".current").removeClass("current");
		    $(this).addClass("current");
	     	 $("#addwflist_<%=eid %>").html("<img class='imgWait' src=/images/loading2_wev8.gif> <%=SystemEnv.getHtmlNoteName(3494,user.getLanguage())%>...");
	     	queryData<%=eid %>(<%=eid %>,'<%=classname%>',type,<%=eHeight%>)
	     })
	     
	     jQuery('#addwf_<%=eid %>').find(".fontItem").live('hover',function(event){ 
			if(event.type=='mouseenter'){ 
				
				$(this).find(".opimg").show();
			}else{ 
				$(this).find(".opimg").hide();
			} 
		 }) 
		 
		 jQuery('#addwf_<%=eid %>').find(".addwfDrop").live('hover',function(event){ 
			if(event.type=='mouseenter'){ 
				
				//$(this).find(".opimg").show();
			}else{ 
				$(this).hide();
			} 
		 }) 
		 
		 jQuery('#addwf_<%=eid %>').find(".addwfDrop").find(".itemdrop").live('hover',function(event){ 
			if(event.type=='mouseenter'){ 
				
				$(this).addClass("itemdropOver");
			}else{ 
				$(this).removeClass("itemdropOver");
			} 
		 }) 
		 
		 function queryData<%=eid %>(eid,classname,wftype,outHet){
			$.post("/workflow/request/RequestShowInterface.jsp?needPopupNewPage=true&dfdfid=b&needall=0&"+wftype+"=1","",function(data){
				$("#addwflist_"+eid).html("");
		    	// var data = '[{"selfwf":true,"wfname":"sbn人力资源浏览框","wfid":"842"},{"selfwf":true,"wfname":"liuy_test011（所有字段类型，显示属性联动）","wfid":"405"},{"selfwf":true,"wfname":"liuzy-新表单设计器-8888专用","wfid":"1677"},{"selfwf":true,"wfname":"留言","wfid":"5"},{"selfwf":true,"wfname":"新表单--所有字段(LZY9966)","wfid":"1102"},{"selfwf":true,"wfname":"op-接口测试","wfid":"1047"},{"selfwf":true,"wfname":"选择框功能附件上传功能NC","wfid":"1055"},{"selfwf":true,"wfname":"退回--新表单--所有字段","wfid":"955"},{"selfwf":true,"wfname":"liuy_test025（html模式）","wfid":"839"},{"selfwf":true,"wfname":"老表单--签字意见附件链接12","wfid":"782"}]'
		    	data = $.parseJSON($.trim(data));
		    	$(data).each(function(){
		    		try{
			    		var node = $(this);
			    		var htmlnode = $('<div class="fontItem '+classname+'" style=""> <img name="esymbol" src="/images/ecology8/request/workflowTitle_wev8.png" style="vertical-align: middle;"> <a class="e8contentover" style="margin-left:8px;margin-right:10px;cursor: pointer;" >  </a></div>')
					    htmlnode.find("a").text(node.attr("wfname"))
			    		
			    		htmlnode.find("a").bind("click",function(){
			    			onNewRequest($(this),node.attr("wfid"),0,0,node.attr("selfwf"))
			    		})
			    		
			    		var mainsublength = 0;
			    		try{
			    			mainsublength = node.attr("mainsub").length
			    		}catch(ex){
			    			
			    		}
			    		var agentslength = 0;
			    		try{
			    			agentslength = node.attr("agents").length
			    		}catch(ex){
			    			
			    		}
			    		if(mainsublength+agentslength>0){
			    			htmlnode.append('<img onclick="agentWf(this);" class="opimg" style="vertical-align: middle;margin-right:10px;float:right;margin-top:8px;cursor:pointer;display:none;" src="/images/ecology8/mainsubwf_wev8.png">')
			    		}
			    		var dropObj = $("<ul class='addwfDrop'></ul>")
			    		
			    		if(mainsublength>0){
			    			dropObj.append("<li class='maindrop'><%=SystemEnv.getHtmlLabelName(17747,user.getLanguage()) %></li>")
			    			$(node.attr("mainsub")).each(function(){
			    			//alert($(this).attr("depName"))
			    					var mainsubobj = $(this)
			    					dropObj.append("<li class='itemdrop' onclick=onNewRequest2('"+node.attr("wfid")+"',0,'"+mainsubobj.attr("belongtoid")+"')>"+mainsubobj.attr("depName")+"/"+mainsubobj.attr("jobName")+"</li>")
			    			})
			    		}
			    		
			    		if(agentslength>0){
			    			dropObj.append("<li class='maindrop'><%=SystemEnv.getHtmlLabelName(26241,user.getLanguage())+SystemEnv.getHtmlLabelName(22322,user.getLanguage())+SystemEnv.getHtmlLabelName(125,user.getLanguage()) %></li>")
			    			$(node.attr("agents")).each(function(){
			    			//alert($(this).attr("depName"))
			    					var agentsobj = $(this)
			    					dropObj.append("<li class='itemdrop'onclick=onNewRequest(this,'"+node.attr("wfid")+"',1,'"+agentsobj.attr("beagenter")+"',true)>"+agentsobj.attr("agentname")+"/"+agentsobj.attr("depName")+"</li>")
			    		
			    			})
			    		}
			    		htmlnode.append(dropObj);
			    	}catch(ex){
			    	}
		    		$("#addwflist_"+eid).append(htmlnode)
		    	})
    			var height = $("#addwflist_"+eid).height();
	    		if(height>outHet){
	    			height=outHet;
	    		}
	    		$("#addwflist_"+eid).parent().height(height)
	    		if($("#addwflist_"+eid).parent().hasClass("ps-container")){
	    			$("#addwflist_"+eid).parent().perfectScrollbar("update");
	    		}else{
	    			$("#addwflist_"+eid).parent().perfectScrollbar();
	    		}
		    })
		}
	    
	     
	     
</script>
