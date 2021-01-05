<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
if(!HrmUserVarify.checkUserRight("HrmPubHolidayAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.getParentWindow(window);
if("<%=isclose%>"=="1"){
		parentWin.onBtnSearchClick();
		parentWin.closeDialog();	
}
</script>
<script language=vbs>
sub onShowCountry(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp")
	if NOT isempty(id) then
		if id(0)<> 0 then
            document.all(tdname).innerHtml = id(1)
            document.all(inputename).value=id(0)
            if frmmain.holidaydate.value <> "" then
                frmmain.operation.value = "selectdate"
                frmmain.submit()
            end if
		else
            document.all(tdname).innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
            document.all(inputename).value=""
		end if
	end if
end sub
</script> 
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16750,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

boolean CanAdd = HrmUserVarify.checkUserRight("HrmPubHolidayAdd:Add", user);
String countryid=Util.null2String(request.getParameter("countryid"));
String holidaydate=Util.null2String(request.getParameter("holidaydate"));
String selectdate=Util.null2String(request.getParameter("selectdate"));
String selectdatetype=Util.null2String(request.getParameter("selectdatetype"));  // 选择的日期原来类型 : 1 工作日, 2: 休息日
String showtype=Util.null2String(request.getParameter("showtype"));
String year=Util.null2String(request.getParameter("year"));
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(CanAdd){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<% if( selectdate.equals("2") ) { // 该天已经有调整记录，不能新建调整%>
<font color=red><%=SystemEnv.getHtmlLabelName(16755,user.getLanguage())%></font>
<% } %>

<FORM id=frmmain name=frmmain method=post action="HrmPubHolidayOperation.jsp" onSubmit="return check_form(this,'countryid,holidaydate,holidayname')">
<input class=inputstyle type="hidden" name="operation" value="insert">
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		 <wea:item><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></wea:item>
      <wea:item>
			<brow:browser viewType="0" id="countryid" name="countryid" browserValue='<%=countryid %>' 
       browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/country/CountryBrowser.jsp?selectedids="
       hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
       completeUrl="/data.jsp?type=country" width="120px" _callback=""
       browserSpanValue='<%=Util.toScreen(CountryComInfo.getCountrydesc(countryid),user.getLanguage()) %>'>
     </brow:browser>
     </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></wea:item>
      <wea:item><BUTTON class=Calendar type="button" id=SelectDate onclick=getholiday1Date()></BUTTON>
      <span id="holidaydatespan1" style="display:none;" ><IMG id=""  src='/images/BacoError_wev8.gif' align="absMiddle"></span>
	  		<span id=holidaydatespan>   
       <%if(holidaydate.equals("")){%>
      <IMG src='/images/BacoError_wev8.gif' align=absMiddle>
      <%} else {%>
      <%=Util.toScreen(holidaydate,user.getLanguage())%><%}%>        
      </span>
      <input class=inputstyle type="hidden" name="holidaydate" value="<%=holidaydate%>">
      </wea:item>
   <% if( selectdate.equals("1") ) { %>
      <wea:item><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></wea:item>
      <wea:item><input class=inputstyle maxLength=30 onchange="checkinput('holidayname','InvalidFlag_Description')" size=30 
      name="holidayname"><SPAN id=InvalidFlag_Description><IMG src="../../images/BacoError_wev8.gif" align=absMiddle></SPAN>
      </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
      <wea:item>
      <select class=inputstyle name="changetype" <% if( selectdatetype.equals("2") ) {%> onChange="showType()"<%}%>>
		  <option value="1" ><%=SystemEnv.getHtmlLabelName(16478,user.getLanguage())%></option>
          <% if( selectdatetype.equals("2") ) { // 原来为假日，可以调整为工作日%>
		  <option value="2" ><%=SystemEnv.getHtmlLabelName(16751,user.getLanguage())%></option>
          <% } else { // 原来为工作日，可以调整为假日%>
          <option value="3" ><%=SystemEnv.getHtmlLabelName(16752,user.getLanguage())%></option>
          <% } %>
		</select>
      </wea:item>
   <% if( selectdatetype.equals("2") ) { %>
      <wea:item attributes="{'samePair':'relateweekdaytr'}"><%=SystemEnv.getHtmlLabelName(16754,user.getLanguage())%></wea:item>
      <wea:item attributes="{'samePair':'relateweekdaytr'}">
      <span id="relateweekdayspan">
      <select class=inputstyle name="relateweekday">
		  <option value="2"><%=SystemEnv.getHtmlLabelName(392,user.getLanguage())%></option>
          <option value="3"><%=SystemEnv.getHtmlLabelName(393,user.getLanguage())%></option>
          <option value="4"><%=SystemEnv.getHtmlLabelName(394,user.getLanguage())%></option>
		  <option value="5"><%=SystemEnv.getHtmlLabelName(395,user.getLanguage())%></option>
          <option value="6"><%=SystemEnv.getHtmlLabelName(396,user.getLanguage())%></option>
          <option value="7"><%=SystemEnv.getHtmlLabelName(397,user.getLanguage())%></option>
          <option value="1"><%=SystemEnv.getHtmlLabelName(398,user.getLanguage())%></option>
		</select>
       </span>
      </wea:item>
   <% } %>
   <% } %>
	</wea:group>
</wea:layout>
</form>
 <%if("1".equals(isDialog)){ %>
 </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="submitData();">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentWin.closeDialog();">
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
			hideEle("relateweekdaytr");
		});
	</script>
<%} %>
<script language=javascript>
function submitData() {
    if(check_form(document.frmmain,'countryid,holidaydate,holidayname')){
        document.frmmain.submit();
    }
}


function showType(){
    changetypelist = window.document.frmmain.changetype;
    if(changetypelist.value==2){
        showEle("relateweekdaytr");
    }
    else {
				hideEle("relateweekdaytr");
    }
}
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
