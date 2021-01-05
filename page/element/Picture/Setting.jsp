
<%@page import="java.util.ArrayList"%>
<%--以下为支持JBOSS应用服务器校验语法，作出如下改动，将<wea:layout>和<wea:group>标签头移入此页面保证标签有始有终--%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ include file="/page/element/settingCommon_params.jsp"%>
<%@ include file="common.jsp"%>
<wea:layout type="2Col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'class':\"e8_title e8_title_1\"}">
<%@ include file="/page/element/settingCommon_dom.jsp"%>

<%--以上，为支持JBOSS应用服务器校验语法，作出如下改动，将<wea:layout>和<wea:group>标签头移入此页面保证标签有始有终--%>
<%
String pictureheight = (String)valueList.get(nameList.indexOf("pictureheight"));
String picturewidth = (String)valueList.get(nameList.indexOf("picturewidth"));
String height = (String)valueList.get(nameList.indexOf("height"));
String width = (String)valueList.get(nameList.indexOf("width"));
String highopen = (String)valueList.get(nameList.indexOf("highopen"));
String needbutton = (String)valueList.get(nameList.indexOf("needbutton"));

String picturewordcount = (String)valueList.get(nameList.indexOf("picturewordcount"));
String pictureShowType = (String)valueList.get(nameList.indexOf("pictureShowType"));
String autoShow = (String)valueList.get(nameList.indexOf("autoShow"));
String autoShowSpeed = (String)valueList.get(nameList.indexOf("autoShowSpeed"));
if("".equals(height)){
	height ="75";
}
if("".equals(width)){
	width = "75";
}
String single = "{'id':'singlePicture_"+eid+"','display':'"+("1".equals(pictureShowType)?"":"none")+"'}";
String muti = "{'id':'mutilPicture_"+eid+"','display':'"+("2".equals(pictureShowType)?"":"none")+"'}";
%>


	<%
if("2".equals(esharelevel)){
		%>	
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(24051,user.getLanguage())%></wea:item>
	<wea:item>
		<INPUT type="checkbox" title="<%=SystemEnv.getHtmlLabelName(24052,user.getLanguage())%>"
		style="WIDTH: 24px" name="highopen_<%=eid %>" value="<%=highopen %>" 
		<%if("1".equals(highopen)) out.print("checked");%> onclick="if(this.checked){this.value='1';}else{this.value='0';}"/>
		&nbsp;<%=SystemEnv.getHtmlLabelName(24052,user.getLanguage())%>
	</wea:item>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(21653,user.getLanguage())%></wea:item>
	<wea:item>
		<INPUT id="pictureShowType_<%=eid%>" type="radio" <%if(pictureShowType.equals("1")) out.print("checked");%>
		name="pictureShowType_<%=eid%>" selecttype="1" value='1'
		onclick="if(this.checked){jQuery('td[name=mutilPicture_<%=eid%>]').hide();jQuery('td[name=mutilPicture_<%=eid%>]').parent().hide();jQuery('td[name=singlePicture_<%=eid%>]').show();jQuery('td[name=singlePicture_<%=eid%>]').parent().show();}"/>
		&nbsp;<%=SystemEnv.getHtmlLabelName(22920,user.getLanguage())%>&nbsp;		
		<INPUT id="pictureShowType_<%=eid%>" type="radio" <%if(pictureShowType.equals("2")) out.print("checked");%>
		name="pictureShowType_<%=eid%>" selecttype="1" value='2' 
		onclick="if(this.checked){jQuery('td[name=mutilPicture_<%=eid%>]').show();jQuery('td[name=mutilPicture_<%=eid%>]').parent().show();jQuery('td[name=singlePicture_<%=eid%>]').hide();jQuery('td[name=singlePicture_<%=eid%>]').parent().hide();}"/>
		&nbsp;<%=SystemEnv.getHtmlLabelName(22921,user.getLanguage())%>
	</wea:item>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2036,user.getLanguage())%></wea:item>
	<wea:item>
		<%=SystemEnv.getHtmlLabelName(203,user.getLanguage())%>:
		<INPUT class="inputstyle"
			title="<%=SystemEnv.getHtmlLabelName(203,user.getLanguage())%>"
			style="WIDTH: 24px" name="width_<%=eid %>"
			value="<%=width %>" onkeypress="ItemCount_KeyPress(event)" onpaste="return !clipboardData.getData('text').match(/\D/)"
			ondragenter="return false"
			style="ime-mode:Disabled"
			>
		&nbsp;
		<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>:
		<INPUT class="inputstyle"
			title="<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>"
			style="WIDTH: 24px" name="height_<%=eid %>"
			value="<%=height %>" onkeypress="ItemCount_KeyPress(event)" onpaste="return !clipboardData.getData('text').match(/\D/)"
			ondragenter="return false"
			style="ime-mode:Disabled"
			>
		&nbsp;
		</wea:item>
		<wea:item attributes='<%=single %>'>&nbsp;<%=SystemEnv.getHtmlLabelName(22930,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=single %>'>
			<BUTTON type='button' class=btnSetting id=BacoAddFavorite title="<%=SystemEnv.getHtmlLabelName(22922,user.getLanguage())%>" 
				onclick="showLink('<%=eid%>');" >
			</BUTTON>
			<a href="javascript:void(0);" title="<%=SystemEnv.getHtmlLabelName(22922,user.getLanguage())%>" onclick="showLink('<%=eid%>');"><%=SystemEnv.getHtmlLabelName(22923,user.getLanguage())%></a>
		</wea:item>
		<wea:item attributes='<%=muti %>'>
		&nbsp;<%=SystemEnv.getHtmlLabelName(22930,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=muti %>'>
				<TABLE class="viewform" width="100%">
					<colgroup>
						<col width="50%" />
						<col width="50%" />
					</colgroup>
					<TBODY>
						<TR vAlign="top">
							<td class="field" style='padding-left:4px'>
								<INPUT type=checkbox
									title="<%=SystemEnv.getHtmlLabelName(203,user.getLanguage())%>"
									style="WIDTH: 24px" name="autoShow_<%=eid%>" <%if("1".equals(autoShow)) out.print("checked");%>
									value="<%=autoShow %>" onclick="if(this.checked){this.value='1';}else{this.value='';}"/><%=SystemEnv.getHtmlLabelName(22926,user.getLanguage())%>
								&nbsp;
							</td>
							<TD class="field" style='padding-left:4px'>
								<%=SystemEnv.getHtmlLabelName(22927,user.getLanguage())%>:
								<INPUT class="inputstyle"
									title="<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>"
									style="WIDTH: 24px" name="autoShowSpeed_<%=eid %>"
									value="<%=autoShowSpeed %>" onkeypress="ItemCount_KeyPress(event)" onpaste="return !clipboardData.getData('text').match(/\D/)"
									ondragenter="return false"
									style="ime-mode:Disabled"
									>
								&nbsp;
							</TD>
						</TR>
						<TR>
							<td class="field" style='padding-left:4px'>
								<INPUT type=checkbox
									title="<%=SystemEnv.getHtmlLabelName(22928,user.getLanguage())%>"
									style="WIDTH: 24px" name="needbutton_<%=eid%>" <%if("1".equals(needbutton)) out.print("checked");%>
									value="<%=needbutton %>" onclick="if(this.checked){this.value='1';}else{this.value='';}"/><%=SystemEnv.getHtmlLabelName(22928,user.getLanguage())%>
								&nbsp;
							</td>
							<td class="field" style='padding-left:4px'>
								<%=SystemEnv.getHtmlLabelName(22929,user.getLanguage())%>:
								<INPUT class="inputstyle"
									title="<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>"
									style="WIDTH: 24px" name="picturewordcount_<%=eid %>"
									value="<%=picturewordcount %>" onkeypress="ItemCount_KeyPress(event)" onpaste="return !clipboardData.getData('text').match(/\D/)"
									ondragenter="return false"
									style="ime-mode:Disabled"
									>
							</td>
						</TR>
						<TR>
							<td class="field" style='padding-left:8px' >
								<BUTTON type='button' class=btnSetting id=BacoAddFavorite title="<%=SystemEnv.getHtmlLabelName(22922,user.getLanguage())%>" 
									onclick="onShowPicDetail('<%=eid%>');" >
								</BUTTON>
								<a href="javascript:void(0);" title="<%=SystemEnv.getHtmlLabelName(22922,user.getLanguage())%>" onclick="onShowPicDetail('<%=eid%>');"><%=SystemEnv.getHtmlLabelName(22923,user.getLanguage()) %></a>
							</td>
							<td class="field"></td>
						</TR>
					</TBODY>
				</TABLE>
				 <script>
					   var a='<%=pictureShowType%>';
					   if(a==='1'){
					      jQuery('td[name=mutilPicture_<%=eid%>]').hide();
						  jQuery('td[name=mutilPicture_<%=eid%>]').parent().hide();
						  jQuery('td[name=singlePicture_<%=eid%>]').show();
						  jQuery('td[name=singlePicture_<%=eid%>]').parent().show();
					   }else if(a==='2'){
					      jQuery('td[name=mutilPicture_<%=eid%>]').show();
						  jQuery('td[name=mutilPicture_<%=eid%>]').parent().show();
						  jQuery('td[name=singlePicture_<%=eid%>]').hide();
						  jQuery('td[name=singlePicture_<%=eid%>]').parent().hide();
					   }
						function onShowPicDetail(eid){
							var dlg=new window.top.Dialog();//定义Dialog对象
							dlg.Model=true;
							dlg.Width=550;//定义长度
							dlg.Height=760;
							dlg.URL="/page/element/Picture/SettingBrowser.jsp?picturetype=2&eid=<%=eid%>";
							dlg.callbackfun=function(formParams){
								if(formParams!=""){
									$.ajax({
									   type: "POST",
									   url: "/page/element/Picture/PictureOperation.jsp",
									   data: formParams,
									   success: function(data){
									    data = $.parseJSON($.trim(data));
										if(data&&data.__result__===false){
											top.Dialog.alert(data.__msg__);
										}else{
											dlg.close();
										}
									   }
									});
								}
								
							};
							dlg.show();
						}
						function showLink(eid){
							var dlg=new window.top.Dialog();//定义Dialog对象
							dlg.Model=true;
							dlg.Width=550;//定义长度
							dlg.Height=760;
							dlg.URL="/page/element/Picture/SettingBrowser.jsp?picturetype=1&eid=<%=eid%>";
							dlg.callbackfun=function(formParams){
								if(formParams!=""){
									$.ajax({
									   type: "POST",
									   url: "/page/element/Picture/PictureOperation.jsp",
									   data: formParams,
									   success: function(data){
										   	data = $.parseJSON($.trim(data));
											if(data&&data.__result__===false){
												top.Dialog.alert(data.__msg__);
											}else{
												dlg.close();
											}
									   }
									});  
								}
								
							};
							dlg.show();
						}
                 </script>
	</wea:item>
	<%
}
		%>
	</wea:group>
</wea:layout>


