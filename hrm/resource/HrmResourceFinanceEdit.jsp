
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BankComInfo" class="weaver.hrm.finance.BankComInfo" scope= "page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<HTML>
<%
String id = request.getParameter("id");
String isView = request.getParameter("isView");
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;

int hrmid = user.getUID();
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int hrmdetachable=Util.getIntValue(String.valueOf(session.getAttribute("hrmdetachable")),0);
int operatelevel=0;
if(hrmdetachable==1){
    String deptid=ResourceComInfo.getDepartmentID(id);
    String subcompanyid=DepartmentComInfo.getSubcompanyid1(deptid)  ;
    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmResourceWelfareEdit:Edit",Integer.parseInt(subcompanyid));
}else{
    if(HrmUserVarify.checkUserRight("HrmResourceWelfareEdit:Edit", user))
        operatelevel=2;
}
boolean isf = ResourceComInfo.isFinInfoView(hrmid,id);
boolean ishasF =HrmUserVarify.checkUserRight("HrmResourceWelfareEdit:Edit",user);
//if(!(isf&&operatelevel>0)){
if(operatelevel<=0){
	response.sendRedirect("/notice/noright.jsp") ;
}
%>
<HEAD>
  <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(189,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %> 
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:edit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:viewFinanceInfo(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="edit();" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
		  <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM name=resourcefinanceinfo id=resource action="HrmResourceOperation.jsp" method=post enctype="multipart/form-data">
<input type=hidden name=operation>
<input type=hidden name=id value="<%=id%>">
<input type=hidden name=isView value="<%=isView%>">
<input type=hidden name=isfromtab value="<%=isfromtab%>">
 <%
  String sql = "";
  sql = "select * from HrmResource where id = "+id;  
  rs.executeSql(sql);
  if(rs.next()){
    String bankid1 = Util.null2String(rs.getString("bankid1"));
    String accountid1 = Util.null2String(rs.getString("accountid1"));
    String accountname = Util.null2String(rs.getString("accountname"));
    String accumfundaccount = Util.null2String(rs.getString("accumfundaccount"));    
%>
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15805,user.getLanguage())%>'>
	<wea:item><%=SystemEnv.getHtmlLabelName(83353,user.getLanguage())%></wea:item>
    <wea:item> 
      <input style="width: 300px" type=text name="accountname" value="<%=accountname%>">
    </wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15812,user.getLanguage())%></wea:item>        
    <wea:item>
			<brow:browser viewType="0" name="bankid1" browserValue='<%=bankid1 %>' 
			browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/finance/bank/BankBrowser.jsp?selectedids="
			hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
			completeUrl="/data.jsp?type=hrmbank" width="120px"
			browserSpanValue='<%=BankComInfo.getBankname(bankid1)%>'>
			</brow:browser>
    <!-- 
      <input class="wuiBrowser" id=bankid1 type=hidden name=bankid1 value="<%=bankid1%>"
			_url="/systeminfo/BrowserMain.jsp?url=/hrm/finance/bank/BankBrowser.jsp"
			_displayText="<%=BankComInfo.getBankname(bankid1)%>">
     -->
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(16016,user.getLanguage())%></wea:item>
    <wea:item> 
      <input style="width: 300px" type=text name="accountid1" value="<%=accountid1%>">
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(16085,user.getLanguage())%></wea:item>
    <wea:item> 
      <input style="width: 300px" type=text name="accumfundaccount" value="<%=accumfundaccount%>">
    </wea:item>
	</wea:group>
</wea:layout>
<%
  }
%>    
</form>

<script language=vbs>
sub onShowBank(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/finance/bank/BankBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = id(1)
	inputname.value=id(0)
	else 
	spanname.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub
</script>
<script language=javascript>
  function edit(){
  	  document.resourcefinanceinfo.operation.value="addresourcefinanceinfo";
	  document.resourcefinanceinfo.submit();
  }
  
  function viewFinanceInfo(){    
    location = "/hrm/resource/HrmResourceFinanceView.jsp?id=<%=id%>&isView=<%=isView%>";
  }
</script> 
</BODY>
</HTML>
