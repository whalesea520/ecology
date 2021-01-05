
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></SCRIPT>
		<style>
			#loading {
				Z-INDEX: 20001; BORDER-BOTTOM: #ccc 1px solid; POSITION: absolute; BORDER-LEFT: #ccc 1px solid; PADDING-BOTTOM: 8px; PADDING-LEFT: 8px; PADDING-RIGHT: 8px; BACKGROUND: #ffffff; HEIGHT: auto; BORDER-TOP: #ccc 1px solid; BORDER-RIGHT: #ccc 1px solid; PADDING-TOP: 8px; TOP: 40%; LEFT: 45%
			}
			.tab-left-selected,#tab-center .tab-selected{
				background-image:none;
				background-color:#f8f8f8;
			}
			.tab-left-unselected,#tab-center,#tab-right{
				background-image:none;
				background-color:#f8f8f8;
			}
			#tab-center ul li{
				background-image:none;
				font-family:"Microsoft YaHei", "SimSun"; FONT-SIZE: 12px;
			}
			#tab-center .tab-item{
				padding-top:0px;
				padding-bottom:0px;
			}
			#tab-center .tab-item a{
				line-height:28px;
				color: #6c6c6c;
			}
			#tab-center .tab-selected a:link,#tab-center .tab-selected a:visited{
				color:#2094ff;
			}
		</style>
	</HEAD>
<%
    String Customname = "";
    String Customdesc = "";
	
	String id = Util.null2String(request.getParameter("id"));
	String sql = "select * from mode_custompage where id="+id;
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
	    Customname = Util.toScreen(RecordSet.getString("Customname"),user.getLanguage()) ;
	    Customdesc = Util.toScreenToEdit(RecordSet.getString("Customdesc"),user.getLanguage());
	}
%>
<BODY>
	
<table width="100%" style="min-width:820px;height:100%;border-collapse:collapse;border-spacing:0;">
	<colgroup>
		<col width="5">
		<col width="">
		<col width="5">
	</colgroup>
	<tr style="height:1px;background:#f8f8f8;">
		<td></td>
		<td>
			
			<table cellpadding="0" cellspacing="0" width="100%" border="0">
			  	<tr>
			  		<td width="6px" height="28px;" style="">
						<div id="tab-left" class="tab-left-selected" style="">
							
						</div>
					</td>
					<td>
						<div id="tab-center" >
							<ul>
						   		<%
						   			int rowno =0;
						   			String needcheck = "";
						   			sql = "select * from mode_custompagedetail where mainid = "+id+" order by disorder asc,id asc ";
						   			rs.executeSql(sql);
						   			String iframeList = "";
						   			while(rs.next()){
						   				String detailid = Util.null2String(rs.getString("id"));
						   		    	String hrefname = Util.null2String(rs.getString("hrefname"));
						   		    	String hreftitle = Util.null2String(rs.getString("hreftitle"));
						   		    	String hrefdesc = Util.null2String(rs.getString("hrefdesc"));
						   		    	String hrefaddress = Util.null2String(rs.getString("hrefaddress"));
						   		    	double disorder = Util.getDoubleValue(rs.getString("disorder"),0);
						   		    	needcheck += ",hrefname_"+rowno+",hrefaddress_"+rowno;
						   		    	if(hreftitle.equals("")){
						   		    		hreftitle = hrefname;
						   		    	}
						   		    	if(rowno==0){
						   		    		iframeList=" <iframe src='"+hrefaddress+"'  id='iframepage'  frameBorder=0 scrolling=auto width=100% height='100%' onload=\"loading()\"  style='display:block;'></iframe>";
								%>
						   					<li sid="<%=detailid%>" first="yes" url="<%=hrefaddress%>" title="<%=hreftitle%>">
							   					<div class="tab-selected tab-item">
								   					<a href='javascript:void(0)'>
								   						<%=hrefname%>
								   					</a>
							   					</div>
						   					</li>
								<%						   		    		
						   		    	}else{
								%>
											<li sid="<%=detailid%>" url="<%=hrefaddress%>" title="<%=hreftitle%>">
												<div class="tab-item" >
													<a href='javascript:void(0)'>
														<%=hrefname%>
													</a>
												</div>
											</li>
								<%
						   		    	}
						   				rowno++;
						   			}
						   		%>
							</ul>
						</div>
					</td>
					<td width="6px" style="">
						<div id="tab-right" style=""></div>
					</td>
			  	</tr>
	  		</table>
		</td>
		<td></td>
	</tr>
	<tr style="height:100%">
		<td colspan="3" style="height:100%">
		  <div id="content" style="height:100%">
				<%=iframeList%>		
		  </div>
		</td>
	</tr>
</table>

<script language="javascript">

function loading(){
	  $("#loading").hide();
}

$("#tab-left").addClass("tab-left-selected");

$(function(){
	initMenuWidth();
	$("#tab-center li").click(function(){
		
		$("#tab-center li .tab-selected").removeClass("tab-selected");
		$(this).children("div").addClass("tab-selected");
		$("#content iframe").css("display","none");
		var temid=$(this).attr("sid");
		if($(this).attr("first")=="yes"){
			$("#tab-left").removeClass("tab-left-unselected");
			$("#tab-left").addClass("tab-left-selected");
			
			$("#iframepage").css("display","block");
			
		}else{
			$("#tab-left").removeClass("tab-left-selected");
			$("#tab-left").addClass("tab-left-unselected");
			if($("#"+$(this).attr("sid")).attr("src")==undefined){
			  $("#content").append(	" <iframe src=''  id='"+$(this).attr("sid")+"'  frameBorder=0 onload=\"loading()\" scrolling=auto width='100%'  height='100%' onload='loading();'  style='display:none;'></iframe>");
			  $("#"+$(this).attr("sid")).attr("src",$(this).attr("url")).load(function(){});
				$("#loading").hide();
				$("#loading").show();
			}else{
				$("#loading").hide();
			}
		}
		
		$("#"+$(this).attr("sid")).css("display","block");
	});
	window.onresize=function(){
		var ifms=document.getElementsByTagName("iframe");
		for(var i=0;i<ifms.length;i++ ){
			ifms[i].height=document.body.clientHeight-getElementTop(ifms[i])-3;
		}
	}
	var Customname = '<%=Customname %>';
	if(Customname==''){
		 alert("<%=SystemEnv.getHtmlLabelName(82786,user.getLanguage())%>");//后台配置已删除，请联系管理员！
	}
});
function getElementTop(element){
	var actualTop = element.offsetTop;
	var current = element.offsetParent;
	while (current !== null){
	actualTop += current.offsetTop;
	current = current.offsetParent;
	}
	return actualTop;
}
function initMenuWidth(){
	var tabWidth=0;
	$("#tab-center li").each(function(e,e2){
		tabWidth+=$(e2).width();
	});
	$("#tab-center ul").css("width",tabWidth+10);
}

</script>
</BODY></HTML>
