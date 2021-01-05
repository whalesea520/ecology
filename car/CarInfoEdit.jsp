
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<% 
String isclosed = Util.null2String(request.getParameter("isclosed"),"0");
String dialog=Util.null2String(request.getParameter("dialog"),"0");
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script>
	<%if ("1".equals(isclosed)){%>
		window.parent.closeWinAFrsh();
	<%}%>
</script>

<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(920,user.getLanguage());//编辑:车辆
String needfav ="1";
String needhelp ="";
%>
<%
String carNo = "";
String carType = "";
String factoryNo = "";
String price = "";
String buyDate = "";
String engineNo = "";
String driver = "";
String remark = "";
String subCompanyId = "";
String usefee = "";
String id = Util.null2String(request.getParameter("id"));
if(!id.equals("")){
	String sql = "select * from CarInfo where id="+id;
	RecordSet.executeSql(sql);
	if(RecordSet.next()){
		carNo = RecordSet.getString("carNo");
		carType = RecordSet.getString("carType");
		factoryNo = RecordSet.getString("factoryNo");
		price = RecordSet.getString("price");
		buyDate = RecordSet.getString("buyDate");
		engineNo = RecordSet.getString("engineNo");
		driver = RecordSet.getString("driver");
		remark = RecordSet.getString("remark");
		subCompanyId = RecordSet.getString("subCompanyId");
		usefee = RecordSet.getString("usefee");
	}
}
if (Util.getIntValue(subCompanyId) < 0)
	subCompanyId = "";

int userId = user.getUID();

String sqlRight = "select carsdetachable from SystemSet";
RecordSet.executeSql(sqlRight);
String appdetachable = "";
if(RecordSet.next()){
	appdetachable = RecordSet.getString(1);
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ;//保存
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;//删除
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(309, user.getLanguage())+",javascript:closePrtDlgARfsh(),_self} ";//关闭
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="javascript:doSave(this)" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span><!-- 菜单 -->
		</wea:item>
	</wea:group>
</wea:layout>
<FORM id=weaver NAME=frmmain STYLE="margin-bottom:0" action="CarInfoOperation.jsp" method=post>
<input type="hidden" name="operation" value="edit">
<input type="hidden" name="id" value="<%=id%>">
<input type="hidden" name=dialog value=<%=dialog%>>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'><!-- 基本信息 -->
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(20319,user.getLanguage())%><!-- 车牌号 -->
		</wea:item>
		<wea:item>
			<INPUT class=inputstyle maxLength=30 size=20 name="carNo" onchange='checkinput("carNo","carNoimage")' value="<%=carNo%>"><SPAN id=carNoimage><%if(carNo.equals("")){%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></SPAN>
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%><!-- 所属机构 -->
		</wea:item>
		<wea:item>
			<brow:browser viewType="0" name="subCompanyId" browserValue='<%= ""+subCompanyId %>' 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=Car:Maintenance"
									hasInput="false" isSingle="true" hasBrowser = "true" isMustInput='<%=appdetachable.equals("1")?"2":"1" %>'
									completeUrl="/data.jsp?type=4" width="135px" 
									browserSpanValue='<%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(subCompanyId),user.getLanguage())%>'>
							</brow:browser>
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(17630,user.getLanguage())%><!-- 车辆类型 -->
		</wea:item>
		<wea:item>
			<select name="carType" onchange='checkinput("carType","carTypeimage")'>
          			<option value="">
          			<%
          			RecordSet.executeProc("CarType_Select","");
          			while(RecordSet.next()){
          			%>
          			<option value="<%=RecordSet.getString("id")%>" <%if(carType.equals(RecordSet.getString("id"))){%>selected<%}%>><%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%>
          			<%}%>
          		</select>
          		<SPAN id=carTypeimage><%if(carType.equals("")){%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></SPAN>
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(1491,user.getLanguage())%><!-- 费用 -->
		</wea:item>
		<wea:item>
			<INPUT class=inputstyle type=text size=20 name="usefee" onKeyPress="ItemNum_KeyPress()" 
		    onBlur="checknumber1(this);checkinput('usefee','usefeespan')" value="<%=usefee%>">
		    <SPAN id=usefeespan><%if("".equals(usefee)){%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></SPAN><%=SystemEnv.getHtmlLabelName(17647,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(20318,user.getLanguage())%><!-- 厂牌型号 -->
		</wea:item>
		<wea:item>
			<INPUT class=inputstyle maxLength=30 size=20 name="factoryNo" onBlur='checkinput("factoryNo","factoryNoimage")' value="<%=factoryNo%>"><SPAN id=factoryNoimage><%if(factoryNo.equals("")){%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></SPAN>
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(20320,user.getLanguage())%><!-- 购买价格 -->
		</wea:item>
		<wea:item>
			<INPUT class=inputstyle maxLength=18 size=20 name="price" value="<%=price%>" onKeyPress="ItemCount_KeyPress()" onchange="checkcount('price')">(RMB￥，<%=SystemEnv.getHtmlLabelName(20321,user.getLanguage())%>)<!-- 只能为数字 -->
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(16914,user.getLanguage())%><!-- 购置日期 -->
		</wea:item>
		<wea:item>
			<input name="buyDate" type="hidden" class=wuiDate value="<%=buyDate%>" ></input> 
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(20322,user.getLanguage())%><!-- 发动机号码 -->
		</wea:item>
		<wea:item>
			<INPUT class=inputstyle maxLength=30 size=20 name="engineNo" value="<%=engineNo%>">
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(17649,user.getLanguage())%><!-- 司机 -->
		</wea:item>
		<wea:item>
			<brow:browser viewType="0" name="driver" browserValue='<%=driver%>' 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
									hasInput="false" isSingle="true" hasBrowser = "true" isMustInput='1'
									completeUrl="/data.jsp" width="135px" 
									browserSpanValue='<%=ResourceComInfo.getResourcename(driver)%>'>
							</brow:browser>
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%><!-- 备注 -->
		</wea:item>
		<wea:item>
			<INPUT class=inputstyle maxLength=300 size=60 name="remark" value="<%=remark%>">
		</wea:item>
	</wea:group>
</wea:layout>
<%if ("1".equals(dialog)) {%>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
			<wea:group context="">
				<wea:item type="toolbar"><!-- 关闭 -->
					<input type="button"
						value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
						id="zd_btn_cancle" class="zd_btn_cancle" onclick="closePrtDlgARfsh()">
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
<%}%>
<script language=vbs>
sub onShowResourceID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
		if id(0)<> "" then
			driverSpan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
			frmmain.driver.value=id(0)
		else
			driverSpan.innerHtml = ""
			frmmain.driver.value=""
		end if
	end if
end sub
sub onShowSubcompany()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser4.jsp?selectedids="&weaver.subCompanyId.value&"&rightStr=Car:Maintenance")
	issame = false
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	if id(0) = weaver.subCompanyId.value then
		issame = true
	end if
	subcompanyspan.innerHtml = id(1)
	weaver.subCompanyId.value=id(0)
	else
	subcompanyspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	weaver.subCompanyId.value=""
	end if
	end if
end sub
</script>
<script language=javascript>
function doSave(obj){
	if(check_form(document.frmmain,'carNo,carType,usefee,factoryNo<%=appdetachable.equals("1")?",subCompanyId":"" %>')){
		obj.disabled = true;
		document.frmmain.submit();
	}
}
function onDelete(){
	if(isdel()) {
		$GetEle("operation").value="del";
		$GetEle("frmmain").submit();
	}
}
function closePrtDlgARfsh(){
	window.parent.closeWinAFrsh();
}
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
</html>
