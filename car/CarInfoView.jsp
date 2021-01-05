
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CarTypeComInfo" class="weaver.car.CarTypeComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />

<% 
String dialog=Util.null2String(request.getParameter("dialog"),"0");
%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
//编辑:车辆
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(920,user.getLanguage());
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
int identifier=0;
int fg=0;
if(!(request.getParameter("flag")==null)){
    identifier=Util.getIntValue(Util.null2String(request.getParameter("flag")));
}
if(!(request.getParameter("fg")==null)){
    fg=Util.getIntValue(Util.null2String(request.getParameter("fg")));
}
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
		subCompanyId = Util.null2String(RecordSet.getString("subCompanyId"),"0");
		usefee = RecordSet.getString("usefee");
	}
}
int operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"Car:Maintenance",Util.getIntValue(subCompanyId, 0));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//车辆使用情况
RCMenu += "{"+SystemEnv.getHtmlLabelName(19018,user.getLanguage())+",CarUseInfoTwo.jsp?fg="+fg+"&carId="+id+"&dialog="+dialog+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//编辑
if (operatelevel > 0) {
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(26473,user.getLanguage())+",CarInfoEdit.jsp?id="+id+"&dialog="+dialog+",_self} " ;
	//RCMenuHeight += RCMenuHeightStep ;
}
if(identifier==1&&fg==0){
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",CarSearchResult.jsp?dialog="+dialog+",_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
}else if(identifier==1&&fg==1){
 //RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",CarInfoMaintenanceIframe.jsp?dialog="+dialog+",_self} " ;
 //RCMenuHeight += RCMenuHeightStep ;   
}else  if(identifier==2){	
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",CarUseInfoTwo.jsp?fg="+fg+"&carId="+id+"&dialog="+dialog+",_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
}
//关闭
RCMenu += "{" + SystemEnv.getHtmlLabelName(309, user.getLanguage())+",javascript:closePrtDlgARfsh(),_self} ";
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}"><!-- 编辑 -->
			<span title="<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())%>" style="font-size: 12px;cursor: pointer;">
				<!-- <input class="e8_btn_top middle" onclick="javascript:doEdit()" type="button" value="<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())%>"/> -->
			</span><!-- 菜单 -->
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>
<FORM id=weaver NAME=frmmain STYLE="margin-bottom:0" action="CarInfoEdit.jsp" method=post>
<input type="hidden" name="id" value="<%=id%>" />
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'><!-- 基本信息 -->
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(20319,user.getLanguage())%><!-- 车牌号 -->
		</wea:item>
		<wea:item>
			<%=carNo%>
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%><!-- 所属机构 -->
		</wea:item>
		<wea:item>
			<%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(subCompanyId),user.getLanguage())%>
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(17630,user.getLanguage())%><!-- 车辆类型 -->
		</wea:item>
		<wea:item>
			<%=CarTypeComInfo.getCarTypename(carType)%>
		</wea:item>
		<wea:item><!-- 费用(元/公里) -->
			<%=SystemEnv.getHtmlLabelName(1491,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(17647,user.getLanguage())%>)
		</wea:item>
		<wea:item>
			<%=usefee%>
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(20318,user.getLanguage())%><!-- 厂牌型号 -->
		</wea:item>
		<wea:item>
			<%=factoryNo%>
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(20320,user.getLanguage())%>(RMB￥)<!-- 购买价格 -->
		</wea:item>
		<wea:item>
			<%=price%>
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(16914,user.getLanguage())%><!-- 购置日期 -->
		</wea:item>
		<wea:item>
			<%=buyDate%>
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(20322,user.getLanguage())%><!-- 发动机号码 -->
		</wea:item>
		<wea:item>
			<%=engineNo%>
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(17649,user.getLanguage())%><!-- 司机 -->
		</wea:item>
		<wea:item>
			<%=ResourceComInfo.getResourcename(driver)%>
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%><!-- 备注 -->
		</wea:item>
		<wea:item>
			<%=remark%>
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
</FORM>
<script language=vbs>
sub getBuyDate()
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	document.all("buyDateSpan").innerHtml= returndate
	document.all("buyDate").value=returndate
end sub
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
</script>
<script language=javascript>
function doEdit(){
	document.frmmain.submit();
}
function closePrtDlgARfsh(){
	window.parent.closeWinAFrsh();
}
</script>
</body>
</html>
