
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.*"%>
<%@page import="java.io.File"%>
<%@ include file="/page/element/loginViewCommon.jsp"%>
<%@ include file="common.jsp"%>
<jsp:useBean id="weatherData" class="weaver.general.WeatherData" scope="page" />

<!-- 判断元素是否可以独立显示，引入样式 -->
<%
	String indie = Util.null2String(request.getParameter("indie"), "false");
	if ("true".equals(indie)) {
%>
		<%@ include file="/homepage/HpElementCss.jsp" %>
<%	} %>

<%
	String weathersrc = (String)valueList.get(nameList.indexOf("weathersrc"));
    String autoScroll= (String)valueList.get(nameList.indexOf("autoScroll"));   //如果autoScroll 值为"1"则自动滚动，为"0"则不自动滚动
    String width= (String)valueList.get(nameList.indexOf("width"));
	//weatherData.getWeaherByCity(weathersrc,7); 单个城市读取方式
	String imgPath=GCONST.getRootPath()+"page"+File.separatorChar+"element"+File.separatorChar+"Weather"+File.separatorChar+"resource"+File.separatorChar+"image"+File.separatorChar+"weather";
//	List weatherDataList=weatherData.getWeaherByCitys(weathersrc,7,imgPath);
	User user = HrmUserVarify.getUser (request , response);
	List weatherDataList=weatherData.getWeaherByCitys(weathersrc,user.getLanguage(),imgPath);
	int wcount=weatherDataList.size();
%>
	<%if(weatherDataList!=null){ %>
	<table id="weatherTable_<%=eid %>" style="overflow: hidden; background-color: #FFFFFF; width: 100%;table-layout:fixed;" align="center" onresize="">
	<tr>
	<td VALIGN="middle" style="vertical-align:middle;width:35px;">
	    <div  id="weatherback_<%=eid %>" style="cursor:hand;"  <%if(autoScroll.equals("1")||wcount*80<Integer.parseInt(width)){ %> class="" <% } else{%> class=pictureback <% }%> onclick="backWeatherMarquee(<%=eid %>);"></div>
	</td>
	<td align="center">
	  <div id="weather_<%=eid%>" align="center">
		  <div id="weather_<%=eid%>_0" style="overflow:hidden;width:<%=width%>px;">
		  <%if(autoScroll.equals("1")){ %>
	  		<marquee direction="left" scrollamount="2" onMouseOver="stop();" onMouseOut="start();">
	  	  <% } %>
            <table align=center cellpadding=0 cellspace=0 border=0>
				<tr> 
				  <td id="weather_<%=eid%>_1" valign=top style="float: left;">
				      <table>
				         <tr>
				           <%
				           		if(weatherDataList.size()==0){
				           			%>
				           			<td width="*" align="top">
				           			<span height='20' style='padding-top:5px'>
									<img src='/images/icon_wev8.gif'/>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(24956,7) %>
									</span>
							</td>	
							<% 
				           		}else{
				           %>
				           <%
							   boolean needHeight =false;//是否需要定义高度
							   for(int i=0;i<weatherDataList.size();i++) {
								   weatherData = (WeatherData) weatherDataList.get(i);
								   String curCondition = Util.null2String(weatherData.getCurrentCondition());
								   int len = curCondition.length();
								   int showStrLen =len;
								   if(len>6){
									   showStrLen = curCondition.indexOf("，");
									   if(showStrLen<=0){
										   if(len>12){
											   showStrLen=13;
										   }else{
											   showStrLen =len;
										   }
									   }
								   }
								   if(showStrLen>6){
									   needHeight =true;
								   }
							   }
							   for(int i=0;i<weatherDataList.size();i++){
				        	   weatherData=(WeatherData)weatherDataList.get(i);
							   String curCondition = Util.null2String(weatherData.getCurrentCondition());
							   int len = curCondition.length();
							   int showStrLen =len;
							   if(len>6){
								   showStrLen = curCondition.indexOf("，");
								   if(showStrLen<=0){
									   if(len>12){
										   showStrLen=13;
									   }else{
										   showStrLen =len;
									   }
								   }
								}
						   %>
						       <td width="80" align="center">
										<div class="wetCityName" style="height:20px; "><%=weatherData.getCity()%> <!%=weatherData.getCondition()%></div>
								   			<div class="wetCityName" id="curConditionDiv" style="width:80px;cursor:pointer;<%if(needHeight){%>height:40px;<% if(showStrLen<6){%>line-height:40px;<%}}%>">
												<p title="<%=curCondition%>">
													<%
														if(showStrLen>12){
															out.println(curCondition.substring(0,11));
														}else if(showStrLen>0&&showStrLen<=12&&showStrLen!=6){
															out.println(curCondition.substring(0,showStrLen));
														}else if(showStrLen==6&&showStrLen<len){
															out.println(curCondition.substring(0,5));
														}else{
															out.println(curCondition);
														}
														if(showStrLen<len){
															out.println("...");
														}
													%>
												</p>
											</div>
										   <div style="width: 80;bottom:10px;"><%=weatherData.getIcon(curCondition)%></div>
											<br>
											<%=weatherData.getTemperature()%>
								</td>			
							<%} %>	
							<%} %>
						  </tr> 
					   </table>
		          </td>
				  <td id="weather_<%=eid%>_2" valign=top >
				
				  </td>
                 </tr>
               </table>
			<%if(autoScroll.equals("1")){ %>
			  	</marquee>
			<%} %>
	  </div>
	  <%-- 
	     <%if(autoScroll.equals("1")){ %>
			<script>
				weatherAutoScroll("weather_<%=eid%>");
			</script>
		 <%} %>	--%>
	 </div>
	 </td>
    <td VALIGN="middle" style="vertical-align:middle;width:35px;">
    	<div id="weathernext_<%=eid %>"  <%if(autoScroll.equals("1")||wcount*80<Integer.parseInt(width)){ %> class="" <%}else{%> class="picturenext"  <%}%> style="cursor:hand;" onclick="nextWeatherMarquee(<%=eid%>);"></div>
    </td>
  </tr>
</table>
	<%} %>
<script>
	$(function(){
		$("#curConditionDiv").blur(function(){
			$(this).html("");
		});
		var wid1 =$("#weatherTable_<%=eid%>").width();
		var wid2 = $("#weather_<%=eid%>_0").width();
		if(wid2>=(wid1-70)){
			var wid2 = $("#weather_<%=eid%>_0").width(wid1-70);
		}
	})

</script>
