
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<% String isclosed = Util.null2String(request.getParameter("isclosed"),"0");%>
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
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(920,user.getLanguage());//新建:车辆
String needfav ="1";
String needhelp ="";
int driver = 0;
String isUseCar = Util.null2String(request.getParameter("isUseCar"));
String dialog=Util.null2String(request.getParameter("dialog"),"0");
%>
<%
int userId=0;
String subCompanyId;
userId = user.getUID();
if(request.getParameter("subCompanyId")!=null && Util.getIntValue(request.getParameter("subCompanyId")) > -1){
	subCompanyId = Util.null2String(request.getParameter("subCompanyId"));
}else{
	subCompanyId = Util.null2String(user.getUserSubCompany1());
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ;//保存
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(32720,user.getLanguage())+",javascript:doSaveAndNew(this),_self} " ;//保存并新建
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{" + SystemEnv.getHtmlLabelName(309, user.getLanguage())+",javascript:closePrtDlgARfsh(),_self} ";//关闭
RCMenuHeight += RCMenuHeightStep ;

String sqlRight = "select carsdetachable from SystemSet";
RecordSet.executeSql(sqlRight);
String appdetachable = "";
if(RecordSet.next()){
	appdetachable = RecordSet.getString(1);
}

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" style="font-size: 12px;cursor: pointer;"><!-- 保存 -->
				<input class="e8_btn_top middle" onclick="javascript:doSave(this)" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(32720,user.getLanguage())%>" style="font-size: 12px;cursor: pointer;"><!-- 保存并新建 -->
				<input class="e8_btn_top middle" onclick="javascript:doSaveAndNew(this)" type="button" value="<%=SystemEnv.getHtmlLabelName(32720,user.getLanguage())%>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span><!-- 菜单 -->
		</wea:item>
	</wea:group>
</wea:layout>
<FORM id=weaver NAME=frmmain STYLE="margin-bottom:0" action="CarInfoOperation.jsp" method=post>
		<input type="hidden" name="operation" value="add">
		<input type="hidden" name="addtype" value="add">
		<input type="hidden" name=dialog value=<%=dialog%>>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'><!-- 基本信息 -->
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(20319,user.getLanguage())%><!-- 车牌号 -->
		</wea:item>
		<wea:item>
			<INPUT class=inputstyle type="text" style="width:240px" maxLength=30 size=20 name="carNo" onchange='checkinput("carNo","carNoimage")'><SPAN id=carNoimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%><!-- 所属机构 -->
		</wea:item>
		<wea:item>
			<brow:browser viewType="0" name="subCompanyId" browserValue='<%=subCompanyId%>' 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=Car:Maintenance"
									hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='<%=appdetachable.equals("1")?"2":"1" %>'
									completeUrl="/data.jsp?type=164" width="135px" 
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
          			<option value="<%=RecordSet.getString("id")%>"><%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%>
          			<%}%>
          		</select>
          		<SPAN id=carTypeimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(1491,user.getLanguage())%><!-- 费用 -->
		</wea:item>
		<wea:item>
			<INPUT class=inputstyle type=text style="width:120px" size=20 name="usefee" onKeyPress="ItemNum_KeyPress()" 
		    onBlur="checknumber1(this);checkinput('usefee','usefeespan')">
		    <SPAN id=usefeespan><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN><%=SystemEnv.getHtmlLabelName(17647,user.getLanguage())%><!-- 元/公里 -->
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(20318,user.getLanguage())%><!-- 厂牌型号 -->
		</wea:item>
		<wea:item>
			<INPUT class=inputstyle type="text" style="width:240px" maxLength=30 size=20 name="factoryNo" onchange='checkinput("factoryNo","factoryNoimage")'><SPAN id=factoryNoimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(20320,user.getLanguage())%><!-- 购买价格 -->
		</wea:item>
		<wea:item>
			<INPUT class=inputstyle type="text" style="width:120px" maxLength=18 size=20 name="price" onKeyPress="ItemCount_KeyPress()" onchange="checkcount('price')">(RMB￥，<%=SystemEnv.getHtmlLabelName(20321,user.getLanguage())%>)<!-- 只能为数字 -->
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(16914,user.getLanguage())%><!-- 购置日期 -->
		</wea:item>
		<wea:item>
			<input name="buyDate" type="hidden" class=wuiDate  ></input> 
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(20322,user.getLanguage())%><!-- 发动机号码 -->
		</wea:item>
		<wea:item>
			<INPUT class=inputstyle type="text" style="width:240px" maxLength=30 size=20 name="engineNo">
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(17649,user.getLanguage())%><!-- 司机 -->
		</wea:item>
		<wea:item>
			<brow:browser viewType="0" name="driver" browserValue="" 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
									hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
									completeUrl="/data.jsp" width="135px" 
									browserSpanValue="">
							</brow:browser>
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%><!-- 备注 -->
		</wea:item>
		<wea:item>
			<INPUT class=inputstyle type="text" maxLength=300 size=60 name="remark">
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
</form>
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
		//if (<%=isUseCar%>=="1") 
			//window.close();
	}
}
function doSaveAndNew(obj){
	document.frmmain.addtype.value="addAndNew";
	doSave(obj);
}
function closePrtDlgARfsh(){
	window.parent.closeWinAFrsh();
}
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
</html>