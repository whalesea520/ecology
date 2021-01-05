
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.hrm.job.JobTitlesComInfo"%>
<%@ include file="/page/element/viewCommon.jsp"%>
<%@ include file="common.jsp" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.conn.RecordSet" %>
<jsp:useBean id="dci" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="job" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />

<!-- 判断元素是否可以独立显示，引入样式 -->
<%
	String indie = Util.null2String(request.getParameter("indie"), "false");
	if ("true".equals(indie)) {
%>
		<%@ include file="/homepage/HpElementCss.jsp" %>
<%	} 
	int eHeight = 210;
	rs_Setting.executeSql("select height from hpelement where id =  "+eid);
	if(rs_Setting.next()){
		if(rs_Setting.getInt("height")>0){
			eHeight = rs_Setting.getInt("height");
		}
	}
	eHeight -= 53; 
%>

<span id="searchblockspan_<%=eid %>" style="width: 284px;display: inline-block;height:23px">
	<span class="searchInputSpan overlabel-wrapper" style="position:relative;width: 288px">
		<label for="flowTitle_<%=eid %>" class="overlabel overlabel-apply" style="text-indent: 0px; cursor: text;"><%=SystemEnv.getHtmlLabelName(83815,user.getLanguage()) %></label>
		<input type="text" class="searchInput middle" id="flowTitle_<%=eid %>" eid="<%=eid %>" name="flowTitle" value=""   style="vertical-align: top;width: 258px">
		<span class="middle searchImg"><img class="middle" style="vertical-align:top;margin-top:2px;" src="/images/ecology8/request/search-input_wev8.png"></span>
	</span>
</span>
<div class="e8_box cntactbox" id="cntactbox_<%=eid %>" style="">
		 <div style="position: relative; height: 30px;">
		 		<ul class="tab_menu" style="position: absolute;margin-top:0px;">
		 			<li class="current" hrm='1'>
						<a target="tabcontentframe">
							<%=SystemEnv.getHtmlLabelName(24515,user.getLanguage()) %>
						</a>
					</li>
					<li class="" hrm='2'>
						<a target="tabcontentframe">
							<%=SystemEnv.getHtmlLabelName(18511,user.getLanguage()) %>
						</a>
					</li>
					<li class="" hrm='3'>
						<a target="tabcontentframe">
							<%=SystemEnv.getHtmlLabelName(15089,user.getLanguage()) %>
						</a>
					</li>
					</ul>
		 </div>
		<div style="overflow: visible">
			<div id="cntactsList_<%=eid %>">
				
			</div>
		</div>
</div>	
			<script language="javascript">
			var contactTimeOut_<%=eid %> = null;
			jQuery('#cntactbox_<%=eid %>').Tabs({
		        getLine:1,
		       
		    });
			$("#content_view_id_<%=eid %>").height(<%=eHeight+53%>)
	    	$("#content_view_id_<%=eid%>").css("overflow","hidden");
		    
		    $("#searchblockspan_<%=eid %> label.overlabel").overlabel();
		    
		    queryContactData('<%=eid %>','<%=eHeight%>','<%=request.getQueryString()%>',true)
		    
		    $("#flowTitle_<%=eid %>").bind("keyup",function(){
		    	clearTimeout(contactTimeOut_<%=eid %>);
		    	contactTimeOut_<%=eid %>=setTimeout(function(){queryContactData('<%=eid %>','<%=eHeight%>','<%=request.getQueryString()%>')},500)
		    })
		    	 
		    jQuery('#cntactbox_<%=eid %>').find("li").bind("click",function(){
		    	$("#cntactbox_<%=eid %>").find(".current").removeClass("current");
		    	$(this).addClass("current");
		    	
		    	queryContactData('<%=eid %>','<%=eHeight%>','<%=request.getQueryString()%>')
		    })
		    function queryContactData(eid,eHeight,queryStr,isInit){
		    	var hrmVal = $("#cntactbox_"+eid).find(".current").attr("hrm");
		    	var keyVal = encodeURIComponent($("#flowTitle_"+eid).val());
		    	$("#cntactsList_"+eid).load("/page/element/contacts/data.jsp?hrm="+hrmVal+"&key="+keyVal+"&"+queryStr,function(){
		    		var height = $("#cntactsList_"+eid).height();
		    		if(height>eHeight){
		    			height=eHeight;
		    		}
		    		$("#cntactsList_"+eid).parent().height(height)
		    		if(isInit){
		    			$("#cntactsList_"+eid).parent().perfectScrollbar();
		    		}else{
		    			$("#cntactsList_"+eid).parent().perfectScrollbar("update");
		    		}
		    		
		    	})		    
		    }
			</script>
			