

<%@page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page"/>
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

String sql2=" select name,value from hpelementSetting where eid="+eid;
baseBean.writeLog(sql2);
rs_Setting.execute(sql2);
String[] colNames=rs_Setting.getColumnName();
//baseBean.writeLog(colNames.toString());
HashMap values=new HashMap();
while(rs_Setting.next()){
		values.put(Util.null2String(rs_Setting.getString(colNames[0])),Util.null2String(rs_Setting.getString(colNames[1])));
}
%>

<%
if("2".equals(esharelevel)){
		%>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(26286,user.getLanguage())%></wea:item>
	<wea:item>
		<input name="slide_t_AutoChangeTime" class="inputStyle" style="width:120px" value='<%=Util.null2String((String)values.get("slide_t_AutoChangeTime")) %>'></input><%=SystemEnv.getHtmlLabelName(26287,user.getLanguage())%>
	</wea:item>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(26288,user.getLanguage())%></wea:item>
	<wea:item>
			<select name="slide_t_changeStyle" id="slide_t_changeStyle">
			<option value="uncover" <%=Util.null2String(values.get("slide_t_changeStyle")).equals("uncover")?"selected":"" %> >uncover</option>
			<option value="blindX" <%=Util.null2String(values.get("slide_t_changeStyle")).equals("blindX")?"selected":"" %>>blindX</option>
			<option value="fade" <%=Util.null2String(values.get("slide_t_changeStyle")).equals("fade")?"selected":"" %>>fade</option>
			<option value="curtainX" <%=Util.null2String(values.get("slide_t_changeStyle")).equals("curtainX")?"selected":"" %>>curtainX</option>
			<option value="curtainY" <%=Util.null2String(values.get("slide_t_changeStyle")).equals("curtainY")?"selected":"" %>>curtainY</option>
			<option value="fadeZoom" <%=Util.null2String(values.get("slide_t_changeStyle")).equals("fadeZoom")?"selected":"" %>>fadeZoom</option>
		</select>
	</wea:item>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(26289,user.getLanguage())%></wea:item>
	<wea:item>
		<input name="slide_t_changeTime" class="inputStyle" style="width:120px" value='<%=Util.null2String((String)values.get("slide_t_changeTime")) %>'></input><%=SystemEnv.getHtmlLabelName(26287,user.getLanguage())%>
	</wea:item>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(20623,user.getLanguage()).substring(0,2)%><%=SystemEnv.getHtmlLabelName(19989,user.getLanguage())%></wea:item>
	<wea:item>
		<%if("1".equals(values.get("slide_t_position"))){ %>
			<%=SystemEnv.getHtmlLabelName(22986,user.getLanguage())%>:&nbsp;<input type="radio" checked="checked" name="slide_t_position" value="1">&nbsp;
			<%=SystemEnv.getHtmlLabelName(22988,user.getLanguage())%>:&nbsp;<input type="radio" name="slide_t_position" value="2">&nbsp;
			<%=SystemEnv.getHtmlLabelName(23010,user.getLanguage())%>:&nbsp;<input type="radio" name="slide_t_position" value="3">&nbsp;
		<%}else if("2".equals(values.get("slide_t_position"))){ %>
			<%=SystemEnv.getHtmlLabelName(22986,user.getLanguage())%>:&nbsp;<input type="radio"  name="slide_t_position" value="1">&nbsp;
			<%=SystemEnv.getHtmlLabelName(22988,user.getLanguage())%>:&nbsp;<input type="radio" checked="checked"  name="slide_t_position" value="2">&nbsp;
			<%=SystemEnv.getHtmlLabelName(23010,user.getLanguage())%>:&nbsp;<input type="radio" name="slide_t_position" value="3">&nbsp;
		<%} else{%>
			<%=SystemEnv.getHtmlLabelName(22986,user.getLanguage())%>:&nbsp;<input type="radio"  name="slide_t_position" value="1">&nbsp;
			<%=SystemEnv.getHtmlLabelName(22988,user.getLanguage())%>:&nbsp;<input type="radio"  name="slide_t_position" value="2">&nbsp;
			<%=SystemEnv.getHtmlLabelName(23010,user.getLanguage())%>:&nbsp;<input type="radio" checked="checked" name="slide_t_position" value="3">&nbsp;
		<%} %>
	</wea:item>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(131137,user.getLanguage())%></wea:item>
	<wea:item>
	    <select name="slide_t_picShow" id="slide_t_picShow">
            <option value="auto" <%=Util.null2String(values.get("slide_t_picShow")).equals("auto")?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(131138,user.getLanguage())%></option>
            <option value="normal" <%=Util.null2String(values.get("slide_t_picShow")).equals("normal")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(131139,user.getLanguage())%></option>
        </select>
	</wea:item>
	<wea:item>&nbsp;</wea:item>
	<wea:item>
			<a href="javascript:void(0);" title="<%=SystemEnv.getHtmlLabelName(22922,user.getLanguage())%>" onclick="showSetting(<%=eid%>)"><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></a>
			<script type="text/javascript">
				function showSetting(eid){
					var dlg=new window.top.Dialog();//定义Dialog对象
					dlg.Model=true;
					dlg.Width=880;//定义长度
					dlg.Height=300;
					dlg.URL="/page/element/Slide/SettingBrowser2.jsp?picturetype=2&eid=<%=eid%>";
					dlg.callbackfun=function(formParams){
						if(formParams!=""){
							$.ajax({
							   type: "POST",
							   url: "/page/element/Slide/PictureOperation.jsp",
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
	<%} %>
	</wea:group>
</wea:layout>