
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%@ include file="/page/element/loginViewCommon.jsp"%>
<%@ include file="common.jsp" %>

<!-- 判断元素是否可以独立显示，引入样式 -->
<%
	String indie = Util.null2String(request.getParameter("indie"), "false");
	if ("true".equals(indie)) {
%>
		<%@ include file="/homepage/HpElementCss.jsp" %>
<%	} %>

<%
String height = (String)valueList.get(nameList.indexOf("height"));
String width = (String)valueList.get(nameList.indexOf("width"));
if("".equals(height)){
	height ="75";
}
if("".equals(width)){
	width = "75";
}
String highopen = (String)valueList.get(nameList.indexOf("highopen"));
String pictureShowType = (String)valueList.get(nameList.indexOf("pictureShowType"));
String autoShow = (String)valueList.get(nameList.indexOf("autoShow"));
String autoShowSpeed = (String)valueList.get(nameList.indexOf("autoShowSpeed"));
String needbutton = (String)valueList.get(nameList.indexOf("needbutton"));
if(!"1".equals(needbutton)){
	needbutton = "0";
}
String pictureheight = (String)valueList.get(nameList.indexOf("pictureheight"));
String picturewidth = (String)valueList.get(nameList.indexOf("picturewidth"));
String picturewordcount = (String)valueList.get(nameList.indexOf("picturewordcount"));
pictureheight = height;
picturewidth = width;
if("".equals(autoShowSpeed))
{
	autoShowSpeed = "20";
}
String cursor = "default";
if("1".equals(highopen)) {
	cursor = "pointer";
}

if("0".equals(autoShow)||"".equals(autoShow)){
	autoShowSpeed= "0";
}

%>


<%
	String sql = "select * from picture where  eid='"+eid+"' order by pictureOrder";
	rs_Setting.executeSql(sql);
	
%>

<div id="pictureTable_<%=eid %>"  style=" background-color: #FFFFFF;height: <%=height %>px; width: 100%;margin:0px;" align="center">

	  <%
		if("1".equals(pictureShowType))
		{
		%>
				<%
									
									if(rs_Setting.next())
									{
										String id = rs_Setting.getString("id");
										String pictureurl = rs_Setting.getString("pictureurl");
										//String picturename = Util.toHtml(rs_Setting.getString("picturename"));
										String picturename = rs_Setting.getString("picturename");
										String picturelink = rs_Setting.getString("picturelink");
										String picturetype = rs_Setting.getString("picturetype");
										int pictureOrder = Util.getIntValue(rs_Setting.getString("pictureOrder"),0);
										if(picturelink.equals("")){
											picturelink="#";
										}else{
											cursor = "pointer";
										}

										
								%>

								
										
											<%if("1".equals(highopen)) {%>
											<div class="jCarouselLite" id="jCarouselLite_<%=eid %>">
												<a class="highslide" style="cursor:<%=cursor%>" title="<%=picturename %>" ref="<%=picturelink%>" id='resourceimghref_<%=eid %>'  <%if(!"".equals(pictureurl)) {%>href="<%=pictureurl%>" target="_blank"<%} %> onFocus="this.blur()"> 
												<img title="<%=picturename %>" id='resourceimg_<%=eid %>' src="<%=pictureurl %>" border=0 style="width:<%=picturewidth %>px;height:<%=pictureheight %>px;"></a>
											</div>
											<%}else{%>
												<a class="highslide" style="cursor:<%=cursor%>" title="<%=picturename %>" ref="<%=picturelink%>" id='resourceimghref_<%=eid %>'  <%if(!"#".equals(picturelink)) {%>href="<%=picturelink%>" target="_blank"<%} %> onFocus="this.blur()"> 
												<img title="<%=picturename %>" id='resourceimg_<%=eid %>' src="<%=pictureurl %>" border=0 style="width:<%=picturewidth %>px;height:<%=pictureheight %>px;"></a>
											<%}%>
										
										
									
								<%
									}
								%>
		
			<%}else{%>
				<table cellspacing="0" width="100%" cellpadding="0" border="0"  style="table-layout: fixed;">
				<tbody>
					<tr>
						  <%if("1".equals(needbutton)){ %>
						<td VALIGN="middle" style="vertical-align:middle;width:35px;">
							<div  id="pictureback_<%=eid %>" style="cursor:hand;" class="pictureback "></div>
						</td>
						<%} %>
						<td id="picturetd_<%=eid %>" nowrap="nowrap" style="overflow:hidden" >
							
								<div class="jCarouselLite" id="jCarouselLite_<%=eid %>">
									<ul>
								<%

									while(rs_Setting.next())
									{
										String id = rs_Setting.getString("id");
										String pictureurl = rs_Setting.getString("pictureurl");
										//String picturename = Util.toHtml(rs_Setting.getString("picturename"));
										String picturename = rs_Setting.getString("picturename");
										String picturelink = rs_Setting.getString("picturelink");
										String picturetype = rs_Setting.getString("picturetype");
										int pictureOrder = Util.getIntValue(rs_Setting.getString("pictureOrder"),0);
										if(picturelink.equals("")){
											picturelink="#";
										}


										
								%>

								
										<li>
										<%if("1".equals(highopen)) {%>
											<div class="jCarouselLite" id="jCarouselLite_<%=eid %>">
												<a class="highslide" style="cursor:<%=cursor%>" title="<%=picturename %>" ref="<%=picturelink%>" id='resourceimghref_<%=eid %>' <%if(!"".equals(pictureurl)) {%>href="<%=pictureurl%>" target="_blank"<%} %> onFocus="this.blur()"> 
												<img title="<%=picturename %>" id='resourceimg_<%=eid %>' src="<%=pictureurl %>" border=0 style="width:<%=picturewidth %>px;height:<%=pictureheight %>px;"></a>
											</div>
											<%}else{%>
												<a class="highslide" style="cursor:<%=cursor%>" title="<%=picturename %>" ref="<%=picturelink%>" id='resourceimghref_<%=eid %>' <%if(!"#".equals(picturelink)) {%>href="<%=picturelink%>" target="_blank"<%} %> > 
												<img title="<%=picturename %>" id='resourceimg_<%=eid %>' src="<%=pictureurl %>" border=0 style="width:<%=picturewidth %>px;height:<%=pictureheight %>px;"></a>
											<%}%>
										</li>
										
									
								<%
									}
								%>
								</ul>
								</div>
								
						</td>
						 <%if("1".equals(needbutton)){ %>
						<td VALIGN="middle" style="vertical-align:middle;width:35px;">
							<div id="picturenext_<%=eid %>" class="picturenext" style="cursor:hand;" ></div>
						</td>
						<%} %>
					</tr>
				</tbody>
			</table>
			<%}%>
</div>

<script language="javascript">
var width = $("#jCarouselLite_<%=eid %>").parent().width();
var count = parseInt(width/<%=picturewidth%>);

if($('#jCarouselLite_<%=eid %>').find("ul").length>0){
	var auto =  <%=autoShowSpeed%>*50;
	if($('#jCarouselLite_<%=eid %>').find("li").length<count){
		auto = 0;
		count = $('#jCarouselLite_<%=eid %>').find("li").length;
		$('#jCarouselLite_<%=eid %>').jCarouselLite({
			btnPrev: '#pictureback_<%=eid %>',
			btnNext: '#picturenext_<%=eid %>',
			auto: auto,
			speed:1000,
			visible:count,
			scroll:1,
			circular:false
		});
		$("#pictureback_<%=eid %>").hide();
		$("#picturenext_<%=eid %>").hide();
		//$("#picturetd_<%=eid %>").align("center");
		$("#picturetd_<%=eid %>").attr("align","center");
		var settingWidth = parseInt(count*<%=picturewidth%>);
		$("#jCarouselLite_<%=eid %>").width(settingWidth);
	}else{
		if(count==0){
			count = $('#jCarouselLite_<%=eid %>').find("li").length;
		}
		$('#jCarouselLite_<%=eid %>').jCarouselLite({
			btnPrev: '#pictureback_<%=eid %>',
			btnNext: '#picturenext_<%=eid %>',
			auto: auto,
			speed:1000,
			visible:count,
			scroll:1,
			circular:true
		});
		$("#jCarouselLite_<%=eid %>").width(width);
	}
	/*if($("#jCarouselLite_<%=eid %>").width()>width){
		$("#jCarouselLite_<%=eid %>").width(width);
	}*/


}

<%if("1".equals(highopen)) {%>
$('#jCarouselLite_<%=eid %>').find("a").each(function(){
			$img =  $(this);
			$($img).fancybox({
				wrapCSS    : 'fancybox-custom',
				closeClick : true,
				closeBtn:false,
				openEffect : 'none',

				helpers : {
					title : {
						type : 'inside'
					},
					overlay : {
						css : {
							'background' : 'rgba(238,238,238,0.85)'
						}
					}
				},
				afterLoad: function() {
					if($.trim(this.ref)!="#"){
						this.title = '<a href="' + this.ref + '" style="color:#000000!important;text-decoration:none!important;" target="_blank">'+ this.title+'</a> ';
					}
					
				}
			});
		})
<%}%>
</SCRIPT>

<style type="text/css">
	.jCarouselLite li{
		margin-left:2px;
		margin-right:2px;
	}
	.clear {clear:both;display:block;}
	.jCarouselLite{
		margin:auto;
	}


</style>