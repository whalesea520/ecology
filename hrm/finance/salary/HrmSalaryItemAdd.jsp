<%@ page import = "weaver.general.Util" %>
<%@ page import = "weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file = "/systeminfo/init_wev8.jsp" %>

<%
if(!HrmUserVarify.checkUserRight("HrmResourceComponentAdd:Add" , user)){
	response.sendRedirect("/notice/noright.jsp") ; 
	return ; 
}
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id = "RecordSet" class = "weaver.conn.RecordSet" scope = "page"/>
<HTML><HEAD>
<LINK href = "/css/Weaver_wev8.css" type = text/css rel = STYLESHEET>
<SCRIPT language = "javascript" src = "/js/weaver_wev8.js"></script>
<SCRIPT language = "javascript" src = "/js/addRowBg_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
var dialogForCloseBtn = parent.parent.getDialog(parent);//关闭按钮专用dialog
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
<script type="text/javascript">
	checkinput("itemname","nameimage");
	checkinput("itemcode","itemcodeimage");
	checkinput("showorder","showorderimage");
  function showOrder() {
		isshowlist = window.document.frmMain.isshow;
		if(isshowlist.value == 1) {
			showEle("tr_showorder");
		}else{
			hideEle("tr_showorder");
		}
  }
  showOrder();
</script>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(16481,user.getLanguage()) ;
String needfav = "1" ; 
String needhelp = "" ;
String subcompanyid = Util.null2String(request.getParameter("subcompanyid") ) ;
String applyscope = Util.null2String(request.getParameter("applyscope") ) ;
String itemname = Util.null2String(request.getParameter("itemname") ) ;
String itemcode = Util.null2String(request.getParameter("itemcode") ) ;
String itemtype = Util.null2String(request.getParameter("itemtype") ) ;
if(itemtype.equals("")){
	itemtype = "4";
}
String isshow = Util.null2String(request.getParameter("isshow") ) ;
String showorder = Util.null2String(request.getParameter("showorder") ) ;
String calMode =  Util.null2String(request.getParameter("calMode")) ;

String directModify =  Util.null2String(request.getParameter("directModify")) ;
String companyPercent = Util.null2String(request.getParameter("companyPercent")) ;
String personalPercent =  Util.null2String(request.getParameter("personalPercent")) ;
String subids=SubCompanyComInfo.getSubCompanyTreeStr(subcompanyid);


String scriptStr = "";
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file = "/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
String rolelevel=CheckUserRight.getRightLevel("HrmResourceComponentAdd:Add" , user);
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSubmit(this);">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form  name = frmMain method = post action = "HrmSalaryItemOperation.jsp" method = post>
<input class=inputstyle type = "hidden" name = "method" value = "add">
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361 , user.getLanguage())%>'>
	<wea:item><%=SystemEnv.getHtmlLabelName(195 , user.getLanguage())%></wea:item>
	<wea:item><INPUT class = inputstyle maxLength=50 size=25 name="itemname" style="width: 240px" value='<%=itemname%>' onchange = 'checkinput("itemname","nameimage")'>
	  	<SPAN id = nameimage>
	  <%if(itemname.length()==0){ %>
			<IMG src = "/images/BacoError_wev8.gif" align = absMiddle>
	  <%} %>
	  </SPAN>
	</wea:item>
	
	<wea:item><%=SystemEnv.getHtmlLabelName(590 , user.getLanguage())%></wea:item>
	<wea:item>
		<INPUT class = inputstyle maxLength = 50 size = 25 name = "itemcode" style="width: 240px" value="<%=itemcode%>" onchange = 'checkinput("itemcode","itemcodeimage")'>
			<SPAN id = itemcodeimage>
	  <%if(itemcode.length()==0){ %>
			<IMG src = "/images/BacoError_wev8.gif" align = absMiddle>
	  <%} %>
	  	<img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelName(15830 , user.getLanguage())%>" />
	  </SPAN>
		
	</wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(19799 , user.getLanguage())%></wea:item>
	<wea:item>
		<brow:browser viewType="0" name="subcompanyid" browserValue='<%= subcompanyid %>' 
		  browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowserByDec.jsp?rightStr=HrmResourceComponentAdd:Add&selectedids="
		  hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
		  completeUrl="/data.jsp?type=164" width="240px"
		  _callback="changeSubcompany"
		  browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(subcompanyid)%>'>
		</brow:browser>
	</wea:item>
  <wea:item><%=SystemEnv.getHtmlLabelName(63 , user.getLanguage())%></wea:item>
  <wea:item> 
      <select name = "itemtype" style = "width:100px" onChange = "showType()">
        <option value = "1" <%if(itemtype.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1804 , user.getLanguage())%></option>
        <option value = "3" <%if(itemtype.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15826 , user.getLanguage())%></option>
        <option value = "4" <%if(itemtype.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(449 , user.getLanguage())%></option>
        <%--<option value = "5" <%if(itemtype.equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16668 , user.getLanguage())%></option>
        <option value = "6" <%if(itemtype.equals("6")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16669 , user.getLanguage())%></option>
        <option value = "7" <%if(itemtype.equals("7")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16740 , user.getLanguage())%></option>--%>
        <%--<option value = "8" <%if(itemtype.equals("8")){%>selected<%}%>>出勤杂费</option>--%>
        <option value = "9" <%if(itemtype.equals("9")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15825 , user.getLanguage())+SystemEnv.getHtmlLabelName(449 , user.getLanguage())%></option>
      </select>
  </wea:item>
  <wea:item attributes="{'samePair':'tr_wel'}"><%=SystemEnv.getHtmlLabelNames("449,599" , user.getLanguage())%></wea:item>
  <wea:item attributes="{'samePair':'tr_wel'}">
  	<input name="original" type="hidden" value="<%=calMode%>">
    <select class=inputstyle name="calMode" onChange ="changeScope(this);">
      <option value = "1" <%if(calMode.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19529 , user.getLanguage())%></option>
      <option value = "2" <%if(calMode.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19530 , user.getLanguage())%></option>
    </select>
	</wea:item>
	<wea:item attributes="{'samePair':'tr_taxrelateitem'}"><%=SystemEnv.getHtmlLabelName(15827 , user.getLanguage())%></wea:item>
	<wea:item attributes="{'samePair':'tr_taxrelateitem'}">
    <brow:browser viewType="0" name="taxrelateitem" browserValue="" 
  		getBrowserUrlFn="onShowItemId" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
      completeUrl="/data.jsp?type=SalaryItem" width="210px">
    </brow:browser>
	</wea:item>
  <wea:item><%=SystemEnv.getHtmlLabelName(33602 , user.getLanguage())%></wea:item>
  <wea:item>
    <select class=inputstyle id=isshow name=isshow onChange="showOrder()" style="width:60px">
			<option value = 1 <%if(isshow.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(163 , user.getLanguage())%></option>
			<option value = 0 <%if(isshow.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(161 , user.getLanguage())%></option>
    </select>
  </wea:item>
  <wea:item attributes="{'samePair':'tr_showorder'}"><%=SystemEnv.getHtmlLabelName(15513 , user.getLanguage())%></wea:item>
  <wea:item attributes="{'samePair':'tr_showorder'}"><INPUT class = inputstyle maxLength = 5 size = 5 style="width: 60px"  onKeyPress="ItemCount_KeyPress()" onBlur="checknumber('showorder')" name = "showorder" value='<%=showorder%>' onchange = 'checkinput4order("showorder","showorderimage")'>
  <SPAN id = showorderimage>
  <%if(showorder.length()==0){ %>
  <IMG src = "/images/BacoError_wev8.gif" align = absMiddle>
  <%} %>
  </SPAN>
  </wea:item>
  <wea:item><%=SystemEnv.getHtmlLabelName(19374,user.getLanguage())%></wea:item>
  <wea:item>
  	<input name="original" type="hidden" value="<%=applyscope%>">
	  <select class=inputstyle name = "applyscope" size = 1  onchange="changeScope(this);">
		  <%if(user.getLoginid().equalsIgnoreCase("sysadmin")||rolelevel.equals("2")){%>
		  <option value = "0" <%if(applyscope.equals("0")){%>selected<%}%>>
		  <%=SystemEnv.getHtmlLabelName(140 , user.getLanguage())%></option>
		  <%}%>
		  <option value = "1" <%if(applyscope.equals("1")){%>selected<%}%>>
		  <%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%></option>
		  <option value = "2" <%if(applyscope.equals("2")){%>selected<%}%>>
		  <%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18921, user.getLanguage())%></option>
		</select>
	</wea:item>
	<wea:item attributes="{'samePair':'td_wel1'}"><%=SystemEnv.getHtmlLabelName(19531,user.getLanguage())%></wea:item>
 	<wea:item attributes="{'samePair':'td_wel1'}">
  	<select class=inputstyle name="directModify" size = 1 >
    	<option value="0"><%=SystemEnv.getHtmlLabelName(161 , user.getLanguage())%></option>
			<option value="1"><%=SystemEnv.getHtmlLabelName(163 , user.getLanguage())%></option>
    </select>
	</wea:item>
	</wea:group>
</wea:layout>

<div id = tb_jssm style = "display:none">
<!-- 
<table  width = 100% border = 1 bordercolor = 'black'>
  <tbody>
  <tr>
  	<td><%=SystemEnv.getHtmlLabelName(16670 , user.getLanguage())%></td>
  </tr>
  </tbody>
</table>
-->
</div>
<div id = tb_je>
<table  class=ViewForm width="100%">
  <tbody>
  <TR class=Title> 
    <TH><%=SystemEnv.getHtmlLabelName(603 , user.getLanguage())%></TH>
    <TH style = "TEXT-ALIGN: right">
    <BUTTON type="button" class = addbtn accessKey = I onClick="addRowJe();" title="<%=SystemEnv.getHtmlLabelName(551 , user.getLanguage())%>"></BUTTON>
    <BUTTON type="button" class = delbtn accessKey = D onClick = "javascript:if(isdel()){deleteRow1_Je()};" title="<%=SystemEnv.getHtmlLabelName(91 , user.getLanguage())%>"></BUTTON>
  </TH>
  </TR>
  <TR class=Spacing style="height:2px"><TD class=Line1 colSpan = 2></TD></TR>
  </tbody>
</table>
<TABLE class=ListStyle cellspacing=1  id = "oTable_je" cols = 6>
  <COLGROUP> 
  <COL width = "5%"> 
  <COL width = "20%"> 
  <COL width = "20%"> 
  <COL width = "17%">
  <COL width = "17%">
  <COL width = "20%"> 
  <TBODY>
  <TR class = HeaderForXtalbe> 
    <TH>&nbsp;</TH>
    <TH><%=SystemEnv.getHtmlLabelName(1915 , user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(6086 , user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(15831 , user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(15832 , user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(534 , user.getLanguage())%></TH>
  </TR>
  <TR class="DataLight"> 
    <TD><input class=inputstyle type = 'checkbox' name = 'check_je' value = 1></TD>
    <TD><BUTTON type="button" class=Browser onClick="onShowJobActivity(jobactivityspan0,jobactivityid0)"></BUTTON><span class=inputstyle id=jobactivityspan0></span> 
        <INPUT class=inputstyle id=jobactivityid0 type=hidden name=jobactivityid0>
    </TD>
    <TD><BUTTON type="button" class = Browser onclick = 'onShowJobID(jobidspan0,jobid0)'></BUTTON><SPAN id = jobidspan0></SPAN>
    <input class=inputstyle type = 'hidden' name = 'jobid0' value = ''>
    </TD>
    <TD><input class=inputstyle type = 'text' name = 'joblevelfrom0' value = "" style = 'width:100%'  onKeyPress = 'ItemCount_KeyPress()' onBlur = 'checkcount1(this)'></TD>
    <TD><input class=inputstyle type = 'text' name = 'joblevelto0' value = "" style='width:100%'  onKeyPress = 'ItemCount_KeyPress()' onBlur = 'checkcount1(this)'></TD>
    <TD><input class=inputstyle type = 'text' name = 'amount0' value = "" style = 'width:100%' onKeyPress = 'ItemNum_KeyPress()' onBlur = 'checknumber1(this)'></TD>
  </TR>
  </tbody>
</table>
</div>
<script language=javascript>
function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}
function showdeptCompensation(deptid,xuhao){
    var ajax=ajaxinit();
    ajax.open("POST", "HrmSalarySetAjax.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("subCompanyId=<%=subcompanyid%>&departmentid="+deptid+"&xuhao="+xuhao+"&userid=<%=user.getUID()%>");
    //获取执行状态

    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里

        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
                jQuery("#div"+deptid+"ajax").html(ajax.responseText);
            }catch(e){
                return false;
            }
        }
    }
}
</script>
<div id = tb_cqzf >
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(33603 , user.getLanguage())%>' attributes="{'groupOperDisplay':'false'}">
		<wea:item attributes="{'isTableList':'true'}">
<table  class = Liststyle cellspacing=1>
  <COLGROUP> 
  <COL width = "15%"> 
  <COL width = "15%"> 
  <COL width = "70%"> 
  <tbody>
  <TR class = HeaderForXtalbe> 
    <TH><%=SystemEnv.getHtmlLabelName(179 , user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(714 , user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(534 , user.getLanguage())%></TH>
  </TR>
	<tr>
       <td colspan="3">
<%
	if(applyscope.equals("")){
		if(user.getLoginid().equalsIgnoreCase("sysadmin")||rolelevel.equals("2")){
			RecordSet.executeSql(" select departmentid, count(id) from Hrmresource where status in (0,1,2,3) group by departmentid");
		}else{
			RecordSet.executeSql(" select departmentid, count(id) from Hrmresource where status in (0,1,2,3) and subcompanyid1="+subcompanyid+" group by departmentid") ;
		}
	}else{
		if(applyscope.equals("0")&&(user.getLoginid().equalsIgnoreCase("sysadmin")||rolelevel.equals("2"))){
			RecordSet.executeSql(" select departmentid, count(id) from Hrmresource where status in (0,1,2,3) group by departmentid") ;
		}else if(applyscope.equals("1")){
			RecordSet.executeSql(" select departmentid, count(id) from Hrmresource where status in (0,1,2,3) and subcompanyid1="+subcompanyid+" group by departmentid") ;
		}else if(applyscope.equals("2")) {
			subids=subcompanyid+","+subids;
			subids=subids.substring(0,subids.length()-1);
			RecordSet.executeSql(" select departmentid, count(id) from Hrmresource where status in (0,1,2,3) and subcompanyid1 in("+subids+") group by departmentid") ;
		}
	}
	int i = 0;
	scriptStr = "";
	while(RecordSet.next()){
		int departmentid_tmp = Util.getIntValue(RecordSet.getString(1), 0);
		int count_tmp = Util.getIntValue(RecordSet.getString(2), 0);
		if(count_tmp>0){
			if(departmentid_tmp==0)continue;
%>
			<div id="div<%=departmentid_tmp%>ajax" style="width:100%"><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>
<%
			if(itemtype.equals("1")){
%>
		<script>showdeptCompensation("<%=departmentid_tmp%>","<%=i%>");</script>
<%
			}else{
				scriptStr += "showdeptCompensation(\""+departmentid_tmp+"\",\""+i+"\");\n";
			}
%>
	</div>
<%
			i+=count_tmp;
		}
	}
%>
		</td>
	</tr>
  </tbody>
</table>
</wea:item>
</wea:group>
</wea:layout>
</div>

<div id=tb_fl style = "display:none">
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15833 , user.getLanguage())%>' attributes="{'groupOperDisplay':'false'}">
		<wea:item type="groupHead" >
			<input type="button" class =addbtn type=button accessKey = I onClick = "addRowFl();" title="<%=SystemEnv.getHtmlLabelName(551 , user.getLanguage())%>">
	    <input type="button" class =delbtn type=button accessKey = D onClick = "javascript:if(isdel()){deleteRow1_Fl()};" title="<%=SystemEnv.getHtmlLabelName(91 , user.getLanguage())%>">
		</wea:item>
		<wea:item attributes="{'isTableList':'true'}">
<TABLE class=ListStyle cellspacing=1  id = "oTable_fl" cols = 4>
  <COLGROUP> 
  <COL width = "5%"> 
  <COL width = "30%"> 
  <COL width = "32%"> 
  <COL width = "32%">
  <TBODY>
  <TR class = HeaderForXtalbe> 
    <TD>&nbsp;</TD>
    <TH><%=SystemEnv.getHtmlLabelName(493 , user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(6087 , user.getLanguage())%>(%)</TH>
    <TH><%=SystemEnv.getHtmlLabelName(1851 , user.getLanguage())%>(%)</TH>
  </TR>
  <TR> 
    <TD><input class=inputstyle type = 'checkbox' name = 'check_fl' value = 1></TD>
    <TD><BUTTON type="button" class = Browser onclick = 'onShowCityID(ratecityidspan0,ratecityid0)'>
        </BUTTON><SPAN id = "ratecityidspan0"></SPAN>
        <input class=inputstyle type = 'hidden' name = 'ratecityid0' value = ''>
    </TD>
    <TD><INPUT class = inputstyle maxLength = 10 size = 15 name = "personwelfarerate0" onKeyPress = "ItemNum_KeyPress()" onBlur = 'checknumber1(this)' >%
    </TD>
    <TD><INPUT class = inputstyle maxLength = 10 size=15 name = "companywelfarerate0" onKeyPress = "ItemNum_KeyPress()" onBlur = 'checknumber1(this)' >%</TD>
  </TR>
  </tbody>
</table>
</wea:item>
</wea:group>
</wea:layout>
</div>

<div id = tb_ss style = "display:none">
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15834 , user.getLanguage())%>' attributes="{'groupOperDisplay':'false'}">
		<wea:item type="groupHead" >
			<input type="button" class =addbtn type=button accessKey = I onClick = "addRowSs();" title="<%=SystemEnv.getHtmlLabelName(551 , user.getLanguage())%>">
	    <input type="button" class =delbtn type=button accessKey = D onClick = "javascript:if(isdel()){deleteRow1_Ss()};" title="<%=SystemEnv.getHtmlLabelName(91 , user.getLanguage())%>">
		</wea:item>
		<wea:item attributes="{'isTableList':'true'}">
<TABLE class=ListStyle cellspacing=1  id = "oTable_ss" cols = 2>
  <COLGROUP>
  <COL width = "3%">
  <COL width = "97%"> 
  <TBODY>
  <TR><TD><input class=inputstyle type = 'checkbox' name = 'check_ss' value = 1></TD>
  <TD>
  <TABLE class = ListStyle id = 'oTable_ssdetail0'name = 'oTable_ssdetail0' cols = 7>
    <COLGROUP>
    <COL width = '15%'>
    <COL width = '18%'> 
    <COL width = '7%'>
    <COL width = '18%'>
    <COL width = '18%'>
    <COL width = '10%'>
    <COL width = '15%'>
    <TBODY>
    <TR class = HeaderForXtalbe> 
    <TH><%=SystemEnv.getHtmlLabelName(19467 , user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(15835 , user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(15836 , user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(15837 , user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(15838 , user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(15834 , user.getLanguage())%>(%)</TH>
    <TH><%=SystemEnv.getHtmlLabelName(19756 , user.getLanguage())%></TH>
    </TR>
    <TR class = DataDark> 
    <TD>
        <select id=scopetype0 name=scopetype0 onchange="changescopetype(this);">
        <option  value="0"><%=SystemEnv.getHtmlLabelName(332 , user.getLanguage())%></option>
        <option  value="1"><%=SystemEnv.getHtmlLabelName(493 , user.getLanguage())%></option>
        <option  value="2"><%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%></option>
        <option  value="3"><%=SystemEnv.getHtmlLabelName(18939 , user.getLanguage())%></option>
        <option  value="4"><%=SystemEnv.getHtmlLabelName(179 , user.getLanguage())%></option>
        </select>
        <BUTTON type="button" class = Browser type=button onclick = 'onShowOrganization(cityidspan0,cityid0,scopetype0)'>
        </BUTTON><SPAN id = "cityidspan0"></SPAN>
        <input class=inputstyle type = 'hidden' name = 'cityid0' value = ''></TD>
        <script type="text/javascript">
            function changescopetype(obj) {
              jQuery(obj).selectbox("detach");
            	jQuery(obj).parent().find("span").html("");
                jQuery(obj).parent().find("input").val("");
                if (obj.value == "0")
                    jQuery(obj).next().hide();
                else
                    jQuery(obj).next().show();
              jQuery(obj).selectbox();     
            }
        </script>
    <TD><INPUT class = inputstyle maxLength = 10 style = 'width:100%'  name = 'taxbenchmark0' value = "" onKeyPress = 'ItemCount_KeyPress()' onBlur = 'checkcount1(this)' ></TD>
    <TD><INPUT class = inputstyle maxLength = 10 style = 'width:100%'  name = 'ranknum0_0' value = "" onKeyPress = 'ItemCount_KeyPress()' onBlur = 'checkcount1(this)' ></TD>
    <TD><INPUT class = inputstyle maxLength = 10 style = 'width:100%'  name = 'ranklow0_0' value = "" onKeyPress = 'ItemCount_KeyPress()' onBlur = 'checkcount1(this)' ></TD>
    <TD><INPUT class = inputstyle maxLength = 10 style = 'width:100%'  name = 'rankhigh0_0' value = "" onKeyPress = 'ItemCount_KeyPress()' onBlur = 'checkcount1(this)' ></TD>
    <TD><INPUT class = inputstyle maxLength = 10 style = 'width:100%'  name = 'taxrate0_0' value = "" onKeyPress = 'ItemCount_KeyPress()' onBlur = 'checkcount1(this)' ></TD>
    <TD><INPUT class = inputstyle maxLength = 10 style = 'width:100%'  name = 'subtractnum0_0' value = "" onKeyPress = 'ItemCount_KeyPress()' onBlur = 'checkcount1(this)' ></TD>
    </TR>
    </TABLE>
    <TABLE width = 100%>
    <TR> 
    <TD style="text-align: right;">
    <BUTTON type="button" class = addbtn accessKey = 1 onClick = "addRowSsD('0')"; title="<%=SystemEnv.getHtmlLabelName(15836 , user.getLanguage())%>" ></BUTTON>
    </TD>
    </TR>
    </table>
    </TD></TR>
  </TBODY>
</TABLE>
</wea:item>
</wea:group>
</wea:layout>
</div>

<div id = tb_cal style = "display:none">
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("18125,68" , user.getLanguage())%>' attributes="{'groupOperDisplay':'false'}">
		<wea:item type="groupHead" >
			<input type="button" class =addbtn type=button accessKey = I onClick = "addRowCal();" title="<%=SystemEnv.getHtmlLabelName(551 , user.getLanguage())%>">
	    <input type="button" class =delbtn type=button accessKey = D onClick = "javascript:if(isdel()){deleteRow1_Cal()};" title="<%=SystemEnv.getHtmlLabelName(91 , user.getLanguage())%>">
		</wea:item>
		<wea:item attributes="{'isTableList':'true'}">
			<TABLE class=ViewForm style="width: 100%" cellspacing=1  id = "oTable_cal" cols = 2>
		  <COLGROUP>
		  <COL width = "3%">
		  <COL width = "97%">
		  <TBODY>
		  <Tr>
		  <TD><input class=inputstyle type = 'checkbox' name = 'check_cal' value = 1></TD>
		  <TD>
		  <TABLE class = ListStyle id = 'oTable_caldetail0' name = 'oTable_caldetail0' cols = 6>
		    <COLGROUP>
		    <COL width = '20%'>
		    <COL width = '20%'>
		    <COL width = '30%'>
		    <COL width = '30%'>
		    <TBODY>
		    <TR class = HeaderForXtalbe>
		    <TH><%=SystemEnv.getHtmlLabelName(19467 , user.getLanguage())%></TH>
		    <TH><%=SystemEnv.getHtmlLabelName(19482 , user.getLanguage())%></TH>
		    <TH><%=SystemEnv.getHtmlLabelName(15364 , user.getLanguage())%></TH>
		    <TH><%=SystemEnv.getHtmlLabelName(18125 , user.getLanguage())%><img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelName(16670 , user.getLanguage())%>" /></TH>
		    </TR>
		    <TR class = DataDark>
		    <TD>
		        <select name=scopetypecal0 onchange="changescopetype(this);" >
		        <option  value="0"><%=SystemEnv.getHtmlLabelName(332 , user.getLanguage())%></option>
		        <option  value="2"><%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%></option>
		        <option  value="3"><%=SystemEnv.getHtmlLabelName(18939 , user.getLanguage())%></option>
		        <option  value="4"><%=SystemEnv.getHtmlLabelName(179 , user.getLanguage())%></option>
		        </select>
		        <BUTTON class = Browser type=button  style="display:none" onclick = 'onShowOrganization(objectidcalspan0,objectidcal0,scopetypecal0)'></BUTTON>
		        <SPAN id = "objectidcalspan0"></SPAN>
		        <input class=inputstyle type = 'hidden' name = 'objectidcal0' value = ''>
		     </TD>
		
		    <TD><select  name = 'timescopecal0_0'>
		        <option value=1><%=SystemEnv.getHtmlLabelName(17138 , user.getLanguage())%></option>
		        <option value=2><%=SystemEnv.getHtmlLabelName(19483 , user.getLanguage())%></option>
		        <option value=3><%=SystemEnv.getHtmlLabelName(17495 , user.getLanguage())%></option>
		        <option value=4><%=SystemEnv.getHtmlLabelName(19398 , user.getLanguage())%></option>
		        </select>
		    </TD>
		    <TD>
		        <BUTTON class=Browser type=button style="display:''" onClick="onShowCon(concalspan0_0,concal0_0,condspcal0_0,scopetypecal0)" ></BUTTON>
		              <span id="concalspan0_0" name="concalspan0_0"></span>
		              <input type="hidden" name="concal0_0">
		              <input type="hidden" name="condspcal0_0">
		    </td>
		    <TD>
		        <BUTTON class=Browser type=button style="display:''" onClick="onShowFormula(formulacalspan0_0,formulacal0_0,formuladspcal0_0,scopetypecal0)" ></BUTTON>
		              <span id="formulacalspan0_0" name="formulacalspan0_0"></span>
		              <input type="hidden" name="formulacal0_0">
		              <input type="hidden" name="formuladspcal0_0">
		    </TD>
		    </TR>
		    </TABLE>
		    <TABLE width = 100%>
		    <TR>
		    <TD style="text-align: right;">
		    	<BUTTON class = addbtn type=button accessKey = 1 onClick = "addRowCalD('0')"; title="<%=SystemEnv.getHtmlLabelName(15836 , user.getLanguage())%>"></BUTTON>
		    </TD>
		    </TR>
		    </table>
		    </TD></TR>
		  </TBODY>
		</TABLE>
		</wea:item>
	</wea:group>
</wea:layout>
</div>

<div id = tb_wel style = "display:none">
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("18125,68" , user.getLanguage())%>' attributes="{'groupOperDisplay':'false'}">
		<wea:item type="groupHead" >
			<input type="button" class =addbtn type=button accessKey = I onClick = "addRowWel();" title="<%=SystemEnv.getHtmlLabelName(551 , user.getLanguage())%>">
	    <input type="button" class =delbtn type=button accessKey = D onClick = "javascript:if(isdel()){deleteRow1_Wel()};" title="<%=SystemEnv.getHtmlLabelName(91 , user.getLanguage())%>">
		</wea:item>
		<wea:item attributes="{'isTableList':'true'}">
<TABLE class=ViewForm style="width: 100%" cellspacing=1  id = "oTable_wel" cols = 2>
  <COLGROUP>
  <COL width = "3%">
  <COL width = "97%">
  <TBODY>
  <TR><TD><input class=inputstyle type = 'checkbox' name = 'check_wel' value = 1></TD>
  <TD>
  <TABLE class = ListStyle id = 'oTable_weldetail0' name = 'oTable_weldetail0' cols = 6>
    <COLGROUP>
    <COL width = '20%'>
    <COL width = '20%'>
    <COL width = '30%'>
    <COL width = '30%'>
    <TBODY>
    <TR class = HeaderForXtalbe>
    <TH><%=SystemEnv.getHtmlLabelName(19467 , user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(19482 , user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(15364 , user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(18125 , user.getLanguage())%><img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelName(16670 , user.getLanguage())%>" /></TH>
    </TR>
    <TR class = DataDark>
    <TD>
        <select name=scopetypewel0 onchange="changescopetype(this);" style="width: 73px">
        <option  value="0"><%=SystemEnv.getHtmlLabelName(332 , user.getLanguage())%></option>
        <option  value="2"><%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%></option>
        <option  value="3"><%=SystemEnv.getHtmlLabelName(18939 , user.getLanguage())%></option>
        <option  value="4"><%=SystemEnv.getHtmlLabelName(179 , user.getLanguage())%></option>
        </select>
        <BUTTON class = Browser type=button style="display:none" onclick = 'onShowOrganization(objectidwelspan0,objectidwel0,scopetypewel0)'></BUTTON>
        <SPAN id = "objectidwelspan0"></SPAN>
        <input class=inputstyle type = 'hidden' name = 'objectidwel0' value = ''>
     </TD>

    <TD><select  name = 'timescopewel0_0' style="width: 61px">
        <option value=1><%=SystemEnv.getHtmlLabelName(17138 , user.getLanguage())%></option>
        <option value=2><%=SystemEnv.getHtmlLabelName(19483 , user.getLanguage())%></option>
        <option value=3><%=SystemEnv.getHtmlLabelName(17495 , user.getLanguage())%></option>
        <option value=4><%=SystemEnv.getHtmlLabelName(19398 , user.getLanguage())%></option>
        </select>
    </TD>
    <TD>
        <BUTTON class=Browser type=button style="display:''" onClick="onShowCon(conwelspan0_0,conwel0_0,condspwel0_0,scopetypewel0)" ></BUTTON>
              <span id="conwelspan0_0" name="conwelspan0_0"></span>
              <input type="hidden" name="conwel0_0">
              <input type="hidden" name="condspwel0_0">
    </td>
    <TD>
        <BUTTON class=Browser type=button style="display:''" onClick="onShowFormula(formulawelspan0_0,formulawel0_0,formuladspwel0_0,scopetypewel0)" ></BUTTON>
              <span id="formulawelspan0_0" name="formulawelspan0_0"></span>
              <input type="hidden" name="formulawel0_0">
              <input type="hidden" name="formuladspwel0_0">
    </TD>
    </TR>
    </TABLE>
    <TABLE width = 100%>
    <TR>
    <TD style="text-align: right;">
    <BUTTON type=button class = addbtn accessKey = 1 onClick = "addRowWelD('0')"; title="<%=SystemEnv.getHtmlLabelName(15836 , user.getLanguage())%>"></BUTTON>
    </TD>
    </TR>
    </table>
    </TD></TR>
  </TBODY>
</TABLE>
</wea:item>
</wea:group>
</wea:layout>
</div>

<div id = tb_wel1 style = "display:none">
<TABLE class=ListStyle cellspacing=1   cols = 2>
  <COLGROUP>
  <COL width = "3%">
  <COL width = "97%">
  <TBODY>
  <TR><TD></TD>
  <TD>
  <TABLE class = ListStyle cols = 2>
    <COLGROUP>
    <COL width = '50%'>
    <COL width = '50%'>

    <TBODY>
    <TR class = HeaderForXtalbe>
    <TH><%=SystemEnv.getHtmlLabelName(6087 , user.getLanguage())+SystemEnv.getHtmlLabelName(1464 , user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(1851 , user.getLanguage())+SystemEnv.getHtmlLabelName(1464 , user.getLanguage())%></TH>
    </TR>
    <TR class="DataDark">
    <TD><input class=inputstyle  name = 'personalPercent'>%</TD>
    <TD><input class=inputstyle  name = 'companyPercent'>%</TD>
    </TR>
    </TABLE>

    </TD></TR>
  </TBODY>
</TABLE>
</div>

<div id = tb_kqkk style = "display:none">
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("16668" , user.getLanguage())%>' attributes="{'groupOperDisplay':'false'}">
		<wea:item type="groupHead" >
			<input type="button" class =addbtn type=button accessKey = I onClick = "addRowKq_Dec();" title="<%=SystemEnv.getHtmlLabelName(551 , user.getLanguage())%>">
	    <input type="button" class =delbtn type=button accessKey = D onClick = "javascript:if(isdel()){deleteRow1_Kq_Dec()};" title="<%=SystemEnv.getHtmlLabelName(91 , user.getLanguage())%>">
		</wea:item>
		<wea:item attributes="{'isTableList':'true'}">
<TABLE class=ListStyle cellspacing=1  id = "oTable_kqkk" cols = 2>
  <COLGROUP>
  <COL width = "5%">
  <COL width = "95%">
  <TBODY>
  <TR class = HeaderForXtalbe>
    <TH>&nbsp;</TH>
    <TH><%=SystemEnv.getHtmlLabelName(16672 , user.getLanguage())%></TH>
    </TR>
  <TR>
    <TD><input class=inputstyle type = 'checkbox' name = 'check_kqkk' value = 1></TD>
    <TD><BUTTON type=button class = Browser onclick = 'onShowScheduleDec(diffnamekkspan01,diffnamekk0)'></BUTTON>
    <SPAN id='diffnamekkspan01' ></SPAN>
    <input class=inputstyle type = 'hidden' name = 'diffnamekk0' value = ''>
    </TD>
    </TR>
  </tbody>
</table>
</wea:item>
</wea:group>
</wea:layout>
</div>

<div id = tb_kqjx style = "display:none">
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("16669" , user.getLanguage())%>' attributes="{'groupOperDisplay':'false'}">
		<wea:item type="groupHead" >
			<input type="button" class =addbtn type=button accessKey = I onClick = "addRowKq_Add();" title="<%=SystemEnv.getHtmlLabelName(551 , user.getLanguage())%>">
	    <input type="button" class =delbtn type=button accessKey = D onClick = "javascript:if(isdel()){deleteRow1_Kq_Add()};" title="<%=SystemEnv.getHtmlLabelName(91 , user.getLanguage())%>">
		</wea:item>
		<wea:item attributes="{'isTableList':'true'}">
<TABLE class=ListStyle cellspacing=1  id = "oTable_kqjx" cols = 2>
  <COLGROUP>
  <COL width = "5%">
  <COL width = "95%">
  <TBODY>
  <TR class = HeaderForXtalbe>
    <TH>&nbsp;</TH>
    <TH><%=SystemEnv.getHtmlLabelName(16672 , user.getLanguage())%></TD>
    </TR>
  <TR>
    <TD><input class=inputstyle type = 'checkbox' name = 'check_kqjx' value = 1></TD>
    <TD><BUTTON type=button class = Browser onclick = 'onShowScheduleAdd(diffnamejxspan0,diffnamejx0)'></BUTTON>
    <SPAN id = diffnamejxspan0></SPAN>
    <input class=inputstyle type = 'hidden' name = 'diffnamejx0' value = ''>
    </TD>
    </TR>
  </tbody>
</table>
</wea:item>
</wea:group>
</wea:layout>
</div>


<div id = tb_cqjt style = "display:none">
<table  class = Liststyle cellspacing=1>
  <COLGROUP>
  <COL width = "15%">
  <COL width = "85%">
  <tbody>
  <TR class = HeaderForXtalbe>
    <TH><%=SystemEnv.getHtmlLabelName(16740 , user.getLanguage())%></TH>
    <TH style = "TEXT-ALIGN: right"></TH>
  </TR>
  <TR class = HeaderForXtalbe>
    <TD><%=SystemEnv.getHtmlLabelName(16741 , user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(534 , user.getLanguage())%></TD>
  </TR>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(16254,user.getLanguage())%></TD>
    <TD><input class=inputstyle type = 'text' name = 'shift0' value = '' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)'></TD>
  </TR>
  <%
     RecordSet.executeProc("HrmArrangeShift_SelectAll" , "0") ;
	 while(RecordSet.next()){
		String shiftid = Util.null2String( RecordSet.getString("id") ) ;
        String shiftname = Util.null2String( RecordSet.getString("shiftname") ) ;
  %>
  <TR>
    <TD><%=shiftname%></TD>
    <TD><input class=inputstyle type = 'text' name = 'shift<%=shiftid%>' value = '' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)'></TD>
  </TR>
  <% } %>
  </tbody>
</table>
</div>

<input class=inputstyle type = "hidden" name = "totalje" value = 1>
<input class=inputstyle type = "hidden" name = "totalss" value = 1>
<input class=inputstyle type = "hidden" name = "totalcal" value = 1>
<input class=inputstyle type = "hidden" name = "totalwel" value = 1>
<input class=inputstyle type = "hidden" name = "totalfl" value = 1>
<input class=inputstyle type = "hidden" name = "totalssd">
<input class=inputstyle type = "hidden" name = "totalcald">
<input class=inputstyle type = "hidden" name = "totalweld">
<input class=inputstyle type = "hidden" name = "totalkqkk" value = 1>
<input class=inputstyle type = "hidden" name = "totalkqjx" value = 1>
</form>
<%if("1".equals(isDialog)){ %>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
    <wea:group context="">
    	<wea:item type="toolbar">
    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialogForCloseBtn.closeByHand();">
    	</wea:item>
   	</wea:group>
  </wea:layout>
</div>
<script type="text/javascript">
	jQuery(document).ready(function(){
		resizeDialog(document);
	});
</script>
<%} %>
<script language = javascript>
function onShowJobID(tdname , inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp");
	if (data!=null){
		if (data.id!=null){
            tdname.innerHTML = data.name;
            inputename.value = data.id;
		}else{
            tdname.innerHTML = "";
            inputename.value = "";
		}
	}
}

function onShowCityID(tdname , inputename){	
    url="/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp";
    dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%>";
	dialog.Width = 700;
	dialog.Height = 450;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.callbackfun = function (params,data){
	   if(data){
	       if(data.id!=""){
	           tdname.innerHTML = "&nbsp&nbsp&nbsp" + data.name;
               inputename.value = data.id;
	       }else{
	    	   tdname.innerHTML = "";
               inputename.value = "";
	       }
       
    	}
	};
	dialog.show();
}



function onShowJobActivity(tdname,inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobactivities/JobActivitiesBrowser.jsp");
	if (data!=null){
		if (data.id!=null){
			tdname.innerHTML = data.name;
			inputename.value = data.id;
		}else{
			tdname.innerHTML = "";
			inputename.value="";
		}
	}
}
</script>

<script language = javascript>
var jerowindex = 1 ;
var flrowindex = 1 ;
var ssrowindex = 1 ;
var calrowindex = 1 ;
var welrowindex = 1 ;
var kqkkrowindex = 1 ; //考勤扣款index
var kqjxrowindex = 1 ;//考勤加薪index

var ssdrowindex = new Array() ;
ssdrowindex[0] = 1 ;
var caldrowindex = new Array() ;
caldrowindex[0] = 1 ;
var weldrowindex = new Array() ;
weldrowindex[0] = 1 ;
function doSubmit(obj) {
	if(!validateItemCode()){
    	return;
    }
    itemtype = document.frmMain.itemtype.value ;
    isshow = window.document.frmMain.isshow.value ;
    checkitemstr = "" ;
    if(itemtype==1) checkitemstr = "itemname,itemcode,isshow,history" ;
    else if(itemtype==2) checkitemstr = "itemname,itemcode,isshow,history,personwelfarerate,companywelfarerate" ;
    else if(itemtype==3) checkitemstr = "itemname,itemcode,isshow,history,taxrelateitem" ;
    else if(itemtype==4) checkitemstr = "itemname,itemcode,isshow,history,amountecp" ;
    else if(itemtype==5) checkitemstr = "itemname,itemcode,isshow,history,diffname" ;
    else if(itemtype==6) checkitemstr = "itemname,itemcode,isshow,history,diffname" ;
    else if(itemtype==9) checkitemstr = "itemname,itemcode,isshow,history,diffname" ;
    if(isshow==1) checkitemstr += ",showorder" ;

    if(check_form(document.frmMain , checkitemstr)){
        if( itemtype == 3){                   // 税收
            totalssd = "" ;
            for(i= 0 ; i<ssrowindex ; i++){
                temptotalss = ssdrowindex[i] ;
                if(totalssd == "") totalssd = temptotalss ;
                else totalssd += "," + temptotalss ;
            }
            document.frmMain.totalssd.value = totalssd ;
        }
        if( itemtype == 4){                   // 税收
            totalcald = "" ;
            for(i= 0 ; i<calrowindex ; i++){
                temptotalcal = caldrowindex[i] ;
                if(totalcald == "") totalcald = temptotalcal ;
                else totalcald += "," + temptotalcal ;
            }
            document.frmMain.totalcald.value = totalcald ;
        }
        if( itemtype == 9){                   //
            totalweld = "" ;
            for(i= 0 ; i<welrowindex ; i++){
                temptotalwel = weldrowindex[i] ;
                if(totalweld == "") totalweld = temptotalwel ;
                else totalweld += "," + temptotalwel ;
            }
            document.frmMain.totalweld.value = totalweld ;
        }
        obj.disabled=true;
        document.frmMain.submit() ;
    }
}

function validateItemCode(){
	var itemCode = jQuery("input[name=itemcode]").val();
	var re = new RegExp("\^[A-Za-z0-9]+\$");
	var result = re.test(itemCode);
	if(result){
		return true;
	}else{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15830 , user.getLanguage())%>");
		return false;
	}
}

function changeSubcompany(){
   window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(19545 , user.getLanguage())%>",function(){
    	document.frmMain.action="HrmSalaryItemAdd.jsp"
   		document.frmMain.submit() ;
   		return false;
   },function(){
   	_writeBackData("subcompanyid",1,{id:"",name:""},{
			hasInput:true,
			replace:true,
			isSingle:true,
			isedit:true
		});
   })
}

function changeScope(obj){
   window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(19545 , user.getLanguage())%>",function(){
   	document.frmMain.action="HrmSalaryItemAdd.jsp"
  	document.frmMain.submit() ;
  	return false;
   },function(){
   	var applyscope_original = jQuery(obj).parent().find("input[name=original]").val();
   	var calMode_original = jQuery(obj).parent().find("input[name=original]").val();
   	document.frmMain.applyscope.selectedIndex=applyscope_original;
	  document.frmMain.calMode.selectedIndex =calMode_original-1;
   	return false;
   })
}
function addRowKq_Dec() {   //类型中选考勤的处理加入一行的程序代码
  //ncol = oTable_kqkk.cols ;
  ncol = 2;
	oRow = oTable_kqkk.insertRow(oTable_kqkk.rows.length) ;
	oRow.className="DataLight";
	for(j=0 ; j < ncol ; j++){
		oCell = oRow.insertCell(j) ;
        oCell.style.height = 24 ;
		//oCell.style.background = "#efefef" ;
		switch(j) {
			case 0:
				var oDiv = document.createElement("div") ;
				var sHtml = "<input class=inputstyle type='checkbox' name='check_kqkk' value=1>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
            case 1:
				var oDiv = document.createElement("div") ;
				var sHtml = "<BUTTON type=button class=Browser onclick='onShowScheduleDec(diffnamekkspan" + kqkkrowindex + ",diffnamekk" + kqkkrowindex + ")'></BUTTON><SPAN id=diffnamekkspan" + kqkkrowindex + "></SPAN><input class=inputstyle type='hidden' name='diffnamekk" + kqkkrowindex + "'>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
		}
	}
	kqkkrowindex = kqkkrowindex * 1 + 1 ;
	frmMain.totalkqkk.value = kqkkrowindex ;
	jQuery(oRow).find("select").selectbox();
	jQuery("body").jNice();
}

function addRowKq_Add() {   //类型中选考勤加薪的处理加入一行的程序代码
  //ncol = oTable_kqjx.cols ;
  ncol = 2;
	oRow = oTable_kqjx.insertRow(oTable_kqjx.rows.length) ;
	oRow.className="DataLight";
	for(j=0 ; j < ncol ; j++){
		oCell = oRow.insertCell(j) ;
        oCell.style.height = 24 ;
		//oCell.style.background = "#efefef" ;
		switch(j) {
			case 0:
				var oDiv = document.createElement("div") ;
				var sHtml = "<input class=inputstyle type='checkbox' name='check_kqjx' value=1>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
            case 1:
				var oDiv = document.createElement("div") ;
				var sHtml = "<BUTTON type=button class=Browser onclick='onShowScheduleAdd(diffnamejxspan" + kqjxrowindex + ",diffnamejx" + kqjxrowindex + ")'></BUTTON><SPAN id=diffnamejxspan" + kqjxrowindex + "></SPAN><input class=inputstyle type='hidden' name='diffnamejx" + kqjxrowindex + "'>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
		}
	}
	kqjxrowindex = kqjxrowindex * 1 + 1 ;
	frmMain.totalkqjx.value = kqjxrowindex ;
	jQuery(oRow).find("select").selectbox();
	jQuery("body").jNice();
}
function addRowJe(){//类型中选工资的处理加一行的代码,此处加上
	//ncol = oTable_je.cols ;
	ncol = 6;
	oRow = oTable_je.insertRow(oTable_je.rows.length) ;
	oRow.className="DataLight";
	for(j=0 ; j<ncol ; j++){
		oCell = oRow.insertCell(j) ;
    oCell.style.height = 24 ;
		//oCell.style.background = "#efefef" ;
		switch(j){
			case 0:
				var oDiv = document.createElement("div") ;
				var sHtml = "<input class=inputstyle type='checkbox' name='check_je' value=1>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
            case 1:
				var oDiv = document.createElement("div") ;
				var sHtml = "<BUTTON type=button class=Browser onClick ='onShowJobActivity(jobactivityspan"+jerowindex+",jobactivityid"+jerowindex+")'></BUTTON>"+
                "<span class=inputstyle id=jobactivityspan"+jerowindex+"></span>" +
                "<INPUT class=inputstyle id=jobactivityid"+jerowindex+" type=hidden name=jobactivityid"+jerowindex+">";
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
			case 2:
				var oDiv = document.createElement("div") ;
				var sHtml = "<BUTTON type=button class=Browser onclick='onShowJobID(jobidspan"+jerowindex+",jobid"+jerowindex+")'></BUTTON>"+
                            "<SPAN id=jobidspan"+jerowindex+"></SPAN><input class=inputstyle type='hidden' name='jobid"+jerowindex+"'>";
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
			case 3:
				var oDiv = document.createElement("div") ;
				var sHtml = "<input class=inputstyle type='text' name='joblevelfrom"+jerowindex+"' style='width:100%' onKeyPress='ItemCount_KeyPress()' onBlur='checkcount1(this)'>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
			case 4:
				var oDiv = document.createElement("div") ;
				var sHtml = "<input class=inputstyle type='text' name='joblevelto"+jerowindex+"' style='width:100%' onKeyPress='ItemCount_KeyPress()' onBlur='checkcount1(this)'>" ;
				oDiv.innerHTML = sHtml ;
                oCell.appendChild(oDiv) ;
                break ;
            case 5:
				var oDiv = document.createElement("div") ;
				var sHtml = "<input class=inputstyle type='text' name='amount"+jerowindex+"' style='width:100%' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)'>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
		}
	}
	jerowindex = jerowindex * 1 + 1 ;
	frmMain.totalje.value = jerowindex ;
	jQuery(oRow).find("select").selectbox();
	jQuery("body").jNice();
}

function addRowFl(){
	//ncol = oTable_fl.cols ;
	ncol = 4;
	oRow = oTable_fl.insertRow(oTable_fl.rows.length) ;
	oRow.className="DataLight";
	for(j=0; j<ncol ; j++) {
		oCell = oRow.insertCell(j) ;
        oCell.style.height=24 ;
		//oCell.style.background = "#efefef" ;
		switch(j){
			case 0:
				var oDiv = document.createElement("div") ;
				var sHtml = "<input class=inputstyle type='checkbox' name='check_fl' value=1>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
            case 1:
				var oDiv = document.createElement("div") ;
				var sHtml = "<BUTTON type=button class=Browser onclick='onShowCityID(ratecityidspan"+flrowindex+",ratecityid"+flrowindex+")'></BUTTON><SPAN id='ratecityidspan"+flrowindex+"'></SPAN><input class=inputstyle type='hidden' name='ratecityid"+flrowindex+"' value=''>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
			case 2:
				var oDiv = document.createElement("div") ;
				var sHtml = "<INPUT class=inputstyle maxLength=10 size=15 name='personwelfarerate"+flrowindex+"' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)'>%" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
			case 3:
				var oDiv = document.createElement("div") ;
				var sHtml = "<INPUT class=inputstyle maxLength=10 size=15 name='companywelfarerate"+flrowindex+"' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)'>%" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
		}
	}
	flrowindex = flrowindex*1 +1;
	frmMain.totalfl.value = flrowindex;
	jQuery(oRow).find("select").selectbox();
	jQuery("body").jNice();
}

function addRowSs(){
	//ncol = oTable_ss.cols ;
  ncol = 2 ;
	oRow = oTable_ss.insertRow(oTable_ss.rows.length) ;
  ssdrowindex[ssrowindex] = 1 ;
	oRow.className="DataLight";
	for(j = 0 ; j < ncol ; j++){
		oCell = oRow.insertCell(j) ;
        oCell.style.height=24 ;
		//oCell.style.background = "#efefef" ;
		switch(j){
			case 0:
				var oDiv = document.createElement("div") ;
				var sHtml = "<input class=inputstyle type='checkbox' name='check_ss' value=1>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
			case 1:
				var oDiv = document.createElement("div") ;
				var sHtml = "<TABLE class=ListStyle id='oTable_ssdetail"+ssrowindex+"' " +                             "name='oTable_ssdetail"+ssrowindex+"' cols=7>"+
                            "<COLGROUP>"+
                            "<COL width = '15%'>"+
                            "<COL width = '18%'>"+
                            "<COL width = '7%'>"+
                            "<COL width = '18%'>"+
                            "<COL width = '18%'>"+
                            "<COL width = '10%'>"+
                            "<COL width = '15%'>"+
                            "<TBODY>"+
                            "<TR class=HeaderForXtalbe>"+
                            "<TH><%=SystemEnv.getHtmlLabelName(19467,user.getLanguage())%></TH>"+
                            "<TH><%=SystemEnv.getHtmlLabelName(15835,user.getLanguage())%></TH>"+
                            "<TH><%=SystemEnv.getHtmlLabelName(15836,user.getLanguage())%></TH>"+
                            "<TH><%=SystemEnv.getHtmlLabelName(15837,user.getLanguage())%></TH>"+
                            "<TH><%=SystemEnv.getHtmlLabelName(15838,user.getLanguage())%></TH>"+
                            "<TH><%=SystemEnv.getHtmlLabelName(15834,user.getLanguage())%>(%)</TH>"+
					        "<TH><%=SystemEnv.getHtmlLabelName(19756,user.getLanguage())%>(%)</TH>"+
                            "</TR>"+
                            "<TR class=DataDark>"+
                            "<TD>"+
                            "<select name=scopetype"+ssrowindex+" onchange='changescopetype(this);'>"+
                            "<option  value=0><%=SystemEnv.getHtmlLabelName(332 , user.getLanguage())%></option>"+
                            "<option  value=1><%=SystemEnv.getHtmlLabelName(493 , user.getLanguage())%></option>"+
                            "<option  value=2><%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%></option>"+
                            "<option  value=3><%=SystemEnv.getHtmlLabelName(18939 , user.getLanguage())%></option>"+
                            "<option  value=4><%=SystemEnv.getHtmlLabelName(179 , user.getLanguage())%></option>"+
                            "</select>"+
                            "<BUTTON class=Browser type=button style = 'display:none'"+
                            "onclick='onShowOrganization(cityidspan"+ssrowindex+",cityid"+ssrowindex+",scopetype"+ssrowindex+")'>"+
                            "</BUTTON><SPAN id=cityidspan"+ssrowindex+"></SPAN>"+
                            "<input class=inputstyle type='hidden' name='cityid"+ssrowindex+"'></TD>"+
                            "<TD><INPUT class=inputstyle maxLength=10 style='width:100%' "+
                            "name='taxbenchmark"+ssrowindex+"' onKeyPress='ItemCount_KeyPress()' "+
                            "onBlur='checkcount1(this)' ></TD>"+
                            "<TD><INPUT class=inputstyle maxLength=10 style='width:100%' "+
                            "name='ranknum"+ssrowindex+"_0' onKeyPress='ItemCount_KeyPress()' "+
                            "onBlur='checkcount1(this)' ></TD>"+
                            "<TD><INPUT class=inputstyle maxLength=10 style='width:100%' "+
                            "name='ranklow"+ssrowindex+"_0' onKeyPress='ItemCount_KeyPress()' "+
                            "onBlur='checkcount1(this)' ></TD>"+
                            "<TD><INPUT class=inputstyle maxLength=10 style='width:100%' "+
                            "name='rankhigh"+ssrowindex+"_0' onKeyPress='ItemCount_KeyPress()' "+
                            "onBlur='checkcount1(this)' ></TD>"+
                            "<TD><INPUT class=inputstyle maxLength=10 style='width:100%' "+
                            "name='taxrate"+ssrowindex+"_0' onKeyPress='ItemCount_KeyPress()' "+
                            "onBlur='checkcount1(this)' ></TD>"+
					        "<TD><INPUT class=inputstyle maxLength=10 style='width:100%' "+
                            "name='subtractnum"+ssrowindex+"_0' onKeyPress='ItemCount_KeyPress()' "+
                            "onBlur='checkcount1(this)' ></TD>"+
                            "</TR>"+
                            "</tbody>"+
                            "</table>"+
                            "<TABLE width=100%>"+
                            "<TR>"+
                            "<TD style=\"text-align: right;\">"+
                            "<BUTTON type=button class=addbtn accessKey=1 onClick=addRowSsD("+ssrowindex+"); title=\"<%=SystemEnv.getHtmlLabelName(15836,user.getLanguage())%>\"></BUTTON>"+
                            "</TD>"+
                            "</TR>"+
                            "</table>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
		}
	}
	ssrowindex = ssrowindex * 1 + 1 ;
	frmMain.totalss.value = ssrowindex ;
	jQuery(oRow).find("select").selectbox();
	jQuery("body").jNice();
}

function addRowSsD(tableid){
    thetable = $GetEle("oTable_ssdetail"+tableid) ;
    tablerowindex = ssdrowindex[tableid] ;
		ncol = 7;
	oRow = thetable.insertRow(thetable.rows.length) ;
		oRow.className="DataLight";
	for(j=0 ; j<ncol ; j++){
		oCell = oRow.insertCell(j) ;
        oCell.style.height = 24 ;
		//oCell.style.background = "#efefef" ;
		switch(j){
			case 0:
				var oDiv = document.createElement("div") ;
				var sHtml = "&nbsp;" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
            case 1:
				var oDiv = document.createElement("div") ;
				var sHtml = "&nbsp;" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
			case 2:
				var oDiv = document.createElement("div") ;
				var sHtml = "<INPUT class=inputstyle maxLength=10 style='width:100%' "+
                            "name='ranknum"+tableid+"_"+tablerowindex+"' onKeyPress='ItemCount_KeyPress()' "+
                            "onBlur='checkcount1(this)' >" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
            case 3:
				var oDiv = document.createElement("div") ;
				var sHtml = "<INPUT class=inputstyle maxLength=10 style='width:100%' "+
                            "name='ranklow"+tableid+"_"+tablerowindex+"' onKeyPress='ItemCount_KeyPress()' "+
                            "onBlur='checkcount1(this)' >" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
            case 4:
				var oDiv = document.createElement("div") ;
				var sHtml = "<INPUT class=inputstyle maxLength=10 style='width:100%' "+
                            "name='rankhigh"+tableid+"_"+tablerowindex+"' onKeyPress='ItemCount_KeyPress()' "+
                            "onBlur='checkcount1(this)' >" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
            case 5:
				var oDiv = document.createElement("div") ;
				var sHtml = "<INPUT class=inputstyle maxLength=10 style='width:100%' "+
                            "name='taxrate"+tableid+"_"+tablerowindex+"' onKeyPress='ItemCount_KeyPress()' "+
                            "onBlur='checkcount1(this)' >" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
			case 6:
				var oDiv = document.createElement("div") ;
				var sHtml = "<INPUT class=inputstyle maxLength=10 style='width:100%' "+
                            "name='subtractnum"+tableid+"_"+tablerowindex+"' onKeyPress='ItemCount_KeyPress()' "+
                            "onBlur='checkcount1(this)' >" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
		}
	}
	ssdrowindex[tableid] = ssdrowindex[tableid] * 1 + 1 ;
	jQuery(oRow).find("select").selectbox();
	jQuery("body").jNice();
}

function addRowCal(){
	ncol = 2 ;
	oRow = oTable_cal.insertRow(oTable_cal.rows.length) ;
  caldrowindex[calrowindex] = 1 ;
   
  oRow.className="DataLight";
	for(j = 0 ; j < ncol ; j++){
		
		oCell = oRow.insertCell(j) ;
        oCell.style.height=24 ;
	    //oCell.style.background= rowColor;
//		oCell.style.background = "#efefef" ;
		switch(j){
			case 0:
				var oDiv = document.createElement("div") ;
				var sHtml = "<input class=inputstyle type='checkbox' name='check_cal' value=1>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
			case 1:
				var oDiv = document.createElement("div") ;
				var sHtml = "<TABLE class=ListStyle id='oTable_caldetail"+calrowindex+"' " +  "name='oTable_caldetail"+calrowindex+"' cols=4>"+
                            "<COLGROUP>"+
                            "<COL width='20%'>"+
                            "<COL width='20%'>"+
                            "<COL width='30%'>"+
                            "<COL width='30%'>"+
                            "<TBODY>"+
                            "<TR class=HeaderForXtalbe>"+
                            "<TH><%=SystemEnv.getHtmlLabelName(19467,user.getLanguage())%></TH>"+
                            "<TH><%=SystemEnv.getHtmlLabelName(19482,user.getLanguage())%></TH>"+
                            "<TH><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></TH>"+
                            "<TH><%=SystemEnv.getHtmlLabelName(18125,user.getLanguage())%></TH>"+
                            "</TR>"+
                            "<TR class=DataDark>"+
                            "<TD>"+
                            "<select name=scopetypecal"+calrowindex+" onchange='changescopetype(this);' style='width:100px'>"+
                            "<option  value=0><%=SystemEnv.getHtmlLabelName(332 , user.getLanguage())%></option>"+
                            "<option  value=2><%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%></option>"+
                            "<option  value=3><%=SystemEnv.getHtmlLabelName(18939 , user.getLanguage())%></option>"+
                            "<option  value=4><%=SystemEnv.getHtmlLabelName(179 , user.getLanguage())%></option>"+
                            "</select>"+
                            "<BUTTON class=Browser type=button style = 'display:none'"+
                            "onclick='onShowOrganization(objectidcalspan"+calrowindex+",objectidcal"+calrowindex+",scopetypecal"+calrowindex+")'>"+
                            "</BUTTON><SPAN id=objectidcalspan"+calrowindex+"></SPAN>"+
                            "<input class=inputstyle type='hidden' name='objectidcal"+calrowindex+"'></TD>"+
                            "<TD>"+
                            "<select name=timescopecal"+calrowindex+"_0  style='width:60px'>"+
                            "<option  value=1><%=SystemEnv.getHtmlLabelName(17138 , user.getLanguage())%></option>"+
                            "<option  value=2><%=SystemEnv.getHtmlLabelName(19483 , user.getLanguage())%></option>"+
                            "<option  value=3><%=SystemEnv.getHtmlLabelName(17495 , user.getLanguage())%></option>"+
                            "<option  value=4><%=SystemEnv.getHtmlLabelName(19398 , user.getLanguage())%></option>"+
                            "</select></td>"+
                            "<TD><BUTTON class=Browser type=button onClick='onShowCon(concalspan"+calrowindex+"_0,concal"+calrowindex+"_0,condspcal"+calrowindex+"_0,scopetypecal"+calrowindex+")' ></BUTTON>"+
                            "<span id=concalspan"+calrowindex+"_0 name=concalspan"+calrowindex+"_0></span>"+
                            "<input type=hidden name=concal"+calrowindex+"_0>"+
                            "<input type=hidden name=condspcal"+calrowindex+"_0></TD>"+
                            "<TD><BUTTON class=Browser type=button onClick='onShowFormula(formulacalspan"+calrowindex+"_0,formulacal"+calrowindex+"_0,formuladspcal"+calrowindex+"_0,scopetypecal"+calrowindex+")' ></BUTTON>"+
                            "<span id=formulacalspan"+calrowindex+"_0 name=formulacalspan"+calrowindex+"_0></span>"+
                            "<input type=hidden name=formulacal"+calrowindex+"_0></TD>"+
                            "<input type=hidden name=formuladspcal"+calrowindex+"_0></TD>"+
                            "</TR>"+
                            "</tbody>"+
                            "</table>"+
                            "<TABLE width=100%>"+
                            "<TR>"+
                            "<TD style='text-align:right'>"+
                            "<BUTTON class=addbtn type=button accessKey=1 onClick=addRowCalD("+calrowindex+"); title=\"<%=SystemEnv.getHtmlLabelName(15836,user.getLanguage())%>\"></BUTTON>"+
                            "</TD>"+
                            "</TR>"+
                            "</table>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
		}
	}
	calrowindex = calrowindex * 1 + 1 ;
	frmMain.totalcal.value = calrowindex ;
	jQuery(oRow).find("select").selectbox();
	jQuery("body").jNice();
}

function addRowWel(){
	//ncol = oTable_wel.cols ;
	ncol = 2;
	oRow = oTable_wel.insertRow(oTable_wel.rows.length) ;
    weldrowindex[welrowindex] = 1 ;
	oRow.className="DataLight";
	for(j = 0 ; j < ncol ; j++){
		oCell = oRow.insertCell(j) ;
        oCell.style.height=24 ;
		//oCell.style.background = "#efefef" ;
		switch(j){
			case 0:
				var oDiv = document.createElement("div") ;
				var sHtml = "<input class=inputstyle type='checkbox' name='check_wel' value=1>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
			case 1:
				var oDiv = document.createElement("div") ;
				var sHtml = "<TABLE class=ListStyle id='oTable_weldetail"+welrowindex+"' " +  "name='oTable_wldetail"+welrowindex+"' cols=4>"+
                            "<COLGROUP>"+
                            "<COL width='20%'>"+
                            "<COL width='20%'>"+
                            "<COL width='30%'>"+
                            "<COL width='30%'>"+
                            "<TBODY>"+
                            "<TR class=HeaderForXtalbe>"+
                            "<TH><%=SystemEnv.getHtmlLabelName(19467,user.getLanguage())%></TH>"+
                            "<TH><%=SystemEnv.getHtmlLabelName(19482,user.getLanguage())%></TH>"+
                            "<TH><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></TH>"+
                            "<TH><%=SystemEnv.getHtmlLabelName(18125,user.getLanguage())%></TH>"+
                            "</TR>"+
                            "<TR class=DataDark>"+
                            "<TD>"+
                            "<select name=scopetypewel"+welrowindex+" onchange='changescopetype(this);'>"+
                            "<option  value=0><%=SystemEnv.getHtmlLabelName(332 , user.getLanguage())%></option>"+
                            "<option  value=2><%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%></option>"+
                            "<option  value=3><%=SystemEnv.getHtmlLabelName(18939 , user.getLanguage())%></option>"+
                            "<option  value=4><%=SystemEnv.getHtmlLabelName(179 , user.getLanguage())%></option>"+
                            "</select>"+
                            "<BUTTON class=Browser type=button style = 'display:none'"+
                            "onclick='onShowOrganization(objectidwelspan"+welrowindex+",objectidwel"+welrowindex+",scopetypewel"+welrowindex+")'>"+
                            "</BUTTON><SPAN id=objectidwelspan"+welrowindex+"></SPAN>"+
                            "<input class=inputstyle type='hidden' name='objectidwel"+welrowindex+"'></TD>"+
                            "<TD>"+
                            "<select name=timescopewel"+welrowindex+"_0 >"+
                            "<option  value=1><%=SystemEnv.getHtmlLabelName(17138 , user.getLanguage())%></option>"+
                            "<option  value=2><%=SystemEnv.getHtmlLabelName(19483 , user.getLanguage())%></option>"+
                            "<option  value=3><%=SystemEnv.getHtmlLabelName(17495 , user.getLanguage())%></option>"+
                            "<option  value=4><%=SystemEnv.getHtmlLabelName(19398 , user.getLanguage())%></option>"+
                            "</select></td>"+
                            "<TD><BUTTON class=Browser type=button onClick='onShowCon(conwelspan"+welrowindex+"_0,conwel"+welrowindex+"_0,condspwel"+welrowindex+"_0,scopetypewel"+welrowindex+")' ></BUTTON>"+
                            "<span id=conwelspan"+welrowindex+"_0 name=conwelspan"+welrowindex+"_0></span>"+
                            "<input type=hidden name=conwel"+welrowindex+"_0>"+
                            "<input type=hidden name=condspwel"+welrowindex+"_0></TD>"+
                            "<TD><BUTTON class=Browser type=button onClick='onShowFormula(formulawelspan"+welrowindex+"_0,formulawel"+welrowindex+"_0,formuladspwel"+welrowindex+"_0,scopetypewel"+welrowindex+")' ></BUTTON>"+
                            "<span id=formulawelspan"+welrowindex+"_0 name=formulawelspan"+welrowindex+"_0></span>"+
                            "<input type=hidden name=formulawel"+welrowindex+"_0></TD>"+
                            "<input type=hidden name=formuladspwel"+welrowindex+"_0></TD>"+
                            "</TR>"+
                            "</tbody>"+
                            "</table>"+
                            "<TABLE width=100%>"+
                            "<TR>"+
                            "<TD style='text-align:right'>"+
                            "<BUTTON type=button class=addbtn accessKey=1 onClick=addRowWelD("+welrowindex+"); title=\"<%=SystemEnv.getHtmlLabelName(15836,user.getLanguage())%>\"></BUTTON>"+
                            "</TD>"+
                            "</TR>"+
                            "</table>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
		}
	}
	welrowindex = welrowindex * 1 + 1 ;
	frmMain.totalwel.value = welrowindex ;
	jQuery(oRow).find("select").selectbox();
	jQuery("body").jNice();
}
function addRowCalD(tableid){
  thetable = jQuery("#oTable_caldetail"+tableid)[0];
  tablerowindex = caldrowindex[tableid] ;
	ncol = 4;
	oRow = thetable.insertRow(thetable.rows.length) ;
	oRow.className="DataLight";

	for(j=0 ; j<ncol ; j++){
		oCell = oRow.insertCell(j) ;
    oCell.style.height = 24 ;

		switch(j){
			case 0:
				var oDiv = document.createElement("div") ;
				var sHtml = "&nbsp;" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
        case 1:
				var oDiv = document.createElement("div") ;
                var sHtml = "<select  name = 'timescopecal"+tableid+"_"+tablerowindex+"'>"+
                            "<option value=1><%=SystemEnv.getHtmlLabelName(17138 , user.getLanguage())%></option>"+
                            "<option value=2><%=SystemEnv.getHtmlLabelName(19483 , user.getLanguage())%></option>"+
                            "<option value=3><%=SystemEnv.getHtmlLabelName(17495 , user.getLanguage())%></option>"+
                            "<option value=4><%=SystemEnv.getHtmlLabelName(19398 , user.getLanguage())%></option>"+
                            "</select>" ;
        oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
			case 2:
				var oDiv = document.createElement("div") ;
				var sHtml = "<BUTTON type=button class=Browser type=button onClick='onShowCon(concalspan"+tableid+"_"+tablerowindex+",concal"+tableid+"_"+tablerowindex+",condspcal"+tableid+"_"+tablerowindex+",scopetypecal"+tableid+")' ></BUTTON>"+
                            "<span id='concalspan"+tableid+"_"+tablerowindex+"' name='concalspan"+tableid+"_"+tablerowindex+"'></span>"+
                            "<input type=hidden name='concal"+tableid+"_"+tablerowindex+"'>"+
                            "<input type=hidden name='condspcal"+tableid+"_"+tablerowindex+"'>"
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
            case 3:
				var oDiv = document.createElement("div") ;
				var sHtml = "<BUTTON type=button class=Browser type=button onClick='onShowFormula(formulacalspan"+tableid+"_"+tablerowindex+",formulacal"+tableid+"_"+tablerowindex+",formuladspcal"+tableid+"_"+tablerowindex+",scopetypecal"+tableid+")' ></BUTTON>"+
                            "<span id='formulacalspan"+tableid+"_"+tablerowindex+"' name='formulacalspan"+tableid+"_"+tablerowindex+"'></span>"+
                            "<input type=hidden name='formulacal"+tableid+"_"+tablerowindex+"'>"+
                            "<input type=hidden name='formuladspcal"+tableid+"_"+tablerowindex+"'>"
                oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;

		}
	}
	caldrowindex[tableid] = caldrowindex[tableid] * 1 + 1 ;
	jQuery(oRow).find("select").selectbox();
	jQuery("body").jNice();
}

function addRowWelD(tableid){
    thetable = $GetEle("oTable_weldetail"+tableid) ;
    tablerowindex = weldrowindex[tableid] ;
	//ncol = thetable.cols ;
	ncol = 4;
	oRow = thetable.insertRow(thetable.rows.length) ;
	oRow.className="DataLight";
	for(j=0 ; j<ncol ; j++){
		oCell = oRow.insertCell(j) ;
        oCell.style.height = 24 ;
		//oCell.style.background = "#efefef" ;
		switch(j){
			case 0:
				var oDiv = document.createElement("div") ;
				var sHtml = "&nbsp;" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
            case 1:
				var oDiv = document.createElement("div") ;
                var sHtml = "<select  name = 'timescopewel"+tableid+"_"+tablerowindex+"'>"+
                            "<option value=1><%=SystemEnv.getHtmlLabelName(17138 , user.getLanguage())%></option>"+
                            "<option value=2><%=SystemEnv.getHtmlLabelName(19483 , user.getLanguage())%></option>"+
                            "<option value=3><%=SystemEnv.getHtmlLabelName(17495 , user.getLanguage())%></option>"+
                            "<option value=4><%=SystemEnv.getHtmlLabelName(19398 , user.getLanguage())%></option>"+
                            "</select>" ;
                oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
			case 2:
				var oDiv = document.createElement("div") ;
				var sHtml = "<BUTTON class=Browser type=button onClick='onShowCon(conwelspan"+tableid+"_"+tablerowindex+",conwel"+tableid+"_"+tablerowindex+",condspwel"+tableid+"_"+tablerowindex+",scopetypewel"+tableid+")' ></BUTTON>"+
                            "<span id='conwelspan"+tableid+"_"+tablerowindex+"' name='conwelspan"+tableid+"_"+tablerowindex+"'></span>"+
                            "<input type=hidden name='conwel"+tableid+"_"+tablerowindex+"'>"+
                            "<input type=hidden name='condspwel"+tableid+"_"+tablerowindex+"'>"
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
            case 3:
				var oDiv = document.createElement("div") ;
				var sHtml = "<BUTTON class=Browser type=button onClick='onShowFormula(formulawelspan"+tableid+"_"+tablerowindex+",formulawel"+tableid+"_"+tablerowindex+",formuladspwel"+tableid+"_"+tablerowindex+",scopetypewel"+tableid+")' ></BUTTON>"+
                            "<span id='formulawelspan"+tableid+"_"+tablerowindex+"' name='formulawelspan"+tableid+"_"+tablerowindex+"'></span>"+
                            "<input type=hidden name='formulawel"+tableid+"_"+tablerowindex+"'>"+
                            "<input type=hidden name='formuladspwel"+tableid+"_"+tablerowindex+"'>"
                oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;

		}
	}
	weldrowindex[tableid] = weldrowindex[tableid] * 1 + 1 ;
	jQuery(oRow).find("select").selectbox();
	jQuery("body").jNice();
}

function deleteRow1_Kq_Dec(){//在类型中选了考勤扣款的删除程序代码

    len = document.forms[0].elements.length ;
    var i = 0 ;
    var rowsum1 = 0 ;
	for(i=len-1 ;  i>=0 ; i--){
		if (document.forms[0].elements[i].name=='check_kqkk')
			rowsum1 += 1 ;
	}

	for(i=len-1 ; i>=0 ; i--){
		if (document.forms[0].elements[i].name=='check_kqkk') {
			if(document.forms[0].elements[i].checked==true) {
				oTable_kqkk.deleteRow(rowsum1+1) ;
			}
			rowsum1 -=1 ;
		}
	}
 }
 function deleteRow1_Kq_Add(){//在类型中选了考勤加薪的删除程序代码

    len = document.forms[0].elements.length ;
    var i = 0 ;
    var rowsum1 = 0 ;
	for(i=len-1 ;  i>=0 ; i--){
		if (document.forms[0].elements[i].name=='check_kqjx')
			rowsum1 += 1 ;
	}

	for(i=len-1 ; i>=0 ; i--){
		if (document.forms[0].elements[i].name=='check_kqjx') {
			if(document.forms[0].elements[i].checked==true) {
				oTable_kqjx.deleteRow(rowsum1+1) ;
			}
			rowsum1 -=1 ;
		}
	}
 }

function deleteRow1_Je(){//在类型中选工资的删除代码
	len = document.forms[0].elements.length ;
  var i = 0 ;
  var rowsum1 = 0 ;
	for( i=len-1 ;  i>=0 ; i-- ) {
		if (document.forms[0].elements[i].name=='check_je')
			rowsum1 += 1 ;
	}
	for(i=len-1 ; i>=0 ; i--){
		if (document.forms[0].elements[i].name=='check_je') {
			if(document.forms[0].elements[i].checked==true) {
				oTable_je.deleteRow(rowsum1) ;
			}
			rowsum1 -= 1 ;
		}
	}
}

function deleteRow1_Fl(){
	len = document.forms[0].elements.length ;
    var i = 0 ;
    var rowsum1 = 0 ;
	for( i=len - 1 ; i>=0 ; i-- ) {
		if (document.forms[0].elements[i].name=='check_fl')
			rowsum1 += 1 ;
	}
	for(i=len - 1 ; i>=0 ; i--){
		if (document.forms[0].elements[i].name=='check_fl') {
			if(document.forms[0].elements[i].checked==true) {
				oTable_fl.deleteRow(rowsum1+1) ;
			}
			rowsum1 -= 1 ;
		}
	}
}

function deleteRow1_Ss(){
	len = document.forms[0].elements.length ;
	var i = 0 ;
    var rowsum1 = 0 ;
    for(i=len - 1 ; i>=0 ; i--){
		if (document.forms[0].elements[i].name=='check_ss')
			rowsum1+= 1 ;
	}
	for(i=len - 1; i>= 0 ; i--){
		if (document.forms[0].elements[i].name=='check_ss'){
			if(document.forms[0].elements[i].checked==true) {
				oTable_ss.deleteRow(rowsum1-1) ;
			}
			rowsum1 -= 1 ;
		}
	}
}
function deleteRow1_Cal(){
	len = document.forms[0].elements.length ;
	var i = 0 ;
    var rowsum1 = 0 ;
    for(i=len - 1 ; i>=0 ; i--){
		if (document.forms[0].elements[i].name=='check_cal')
			rowsum1+= 1 ;
	}
	for(i=len - 1; i>= 0 ; i--){
		if (document.forms[0].elements[i].name=='check_cal'){
			if(document.forms[0].elements[i].checked==true) {
				oTable_cal.deleteRow(rowsum1-1) ;
			}
			rowsum1 -= 1 ;
		}
	}
}
function deleteRow1_Wel(){
	len = document.forms[0].elements.length ;
	var i = 0 ;
    var rowsum1 = 0 ;
    for(i=len - 1 ; i>=0 ; i--){
		if (document.forms[0].elements[i].name=='check_wel')
			rowsum1+= 1 ;
	}
	for(i=len - 1; i>= 0 ; i--){
		if (document.forms[0].elements[i].name=='check_wel'){
			if(document.forms[0].elements[i].checked==true) {
				oTable_wel.deleteRow(rowsum1-1) ;
			}
			rowsum1 -= 1 ;
		}
	}
}
var isfirst = false;
 function showType(){
    itemtypelist = window.document.frmMain.itemtype ;
    if(itemtypelist.value==1){
        tb_fl.style.display = 'none' ;
        hideEle("tr_taxrelateitem");
        //tr_taxrelateitem.style.display = 'none' ;
        //tr_amountecp.style.display = 'none' ;
        tb_je.style.display = '' ;
        tb_ss.style.display = 'none' ;
        tb_cal.style.display = 'none' ;
        tb_wel.style.display = 'none' ;
        tb_jssm.style.display = 'none' ;
        tb_kqkk.style.display = 'none' ;
        tb_kqjx.style.display = 'none' ;
        tb_cqjt.style.display = 'none' ;
        tb_cqzf.style.display = '' ;
        tb_wel1.style.display = 'none' ;
        hideEle("tr_wel");
        //tr_wel.style.display='none';
        hideEle("td_wel1");
        //td_wel1.style.display='none';
        //$GetEle("calMode").style.display='none';
        //$GetEle("directModify").style.display='none';
        if(isfirst==false){
        <%
        if(!"1".equals(itemtype)){
	        out.print(scriptStr);
        }
        %>
        }
        isfirst = true;
    }
    else if(itemtypelist.value==2){
        tb_fl.style.display = '' ;
        hideEle("tr_taxrelateitem");
        //tr_taxrelateitem.style.display = 'none' ;
        //tr_amountecp.style.display = 'none' ;
        tb_je.style.display = '' ;
        tb_ss.style.display = 'none' ;
        tb_cal.style.display = 'none' ;
        tb_wel.style.display = 'none' ;
        tb_jssm.style.display = 'none' ;
        tb_kqkk.style.display = 'none' ;
        tb_kqjx.style.display = 'none' ;
        tb_cqjt.style.display = 'none' ;
        tb_cqzf.style.display = '' ;
        tb_wel1.style.display = 'none' ;
        hideEle("tr_wel");
        //tr_wel.style.display='none';
        hideEle("td_wel1");
        //td_wel1.style.display='none';
        //$GetEle("calMode").style.display='none';
        //$GetEle("directModify").style.display='none';
    }
    else if(itemtypelist.value==3){
        tb_fl.style.display = 'none';
        showEle("tr_taxrelateitem");
        //tr_taxrelateitem.style.display = '';
        //tr_amountecp.style.display='none' ;
        tb_je.style.display = 'none' ;
        tb_ss.style.display = '' ;
        tb_cal.style.display = 'none' ;
        tb_wel.style.display = 'none' ;
        tb_jssm.style.display = 'none' ;
        tb_kqkk.style.display = 'none' ;
        tb_kqjx.style.display = 'none' ;
        tb_cqjt.style.display = 'none' ;
        tb_cqzf.style.display = 'none' ;
        tb_wel1.style.display = 'none' ;
        hideEle("tr_wel");
        //tr_wel.style.display='none';
        hideEle("td_wel1");
        //td_wel1.style.display='none';
        //$GetEle("calMode").style.display='none';
        //$GetEle("directModify").style.display='none';
    }
    else if(itemtypelist.value==4){
        tb_fl.style.display = 'none' ;
        hideEle("tr_taxrelateitem");
        //tr_taxrelateitem.style.display = 'none' ;
        //tr_amountecp.style.display = '' ;
        tb_je.style.display = 'none' ;
        tb_cal.style.display = '' ;
        tb_ss.style.display = 'none' ;
        tb_wel.style.display = 'none' ;
        tb_jssm.style.display = '' ;
        tb_kqkk.style.display = 'none' ;
        tb_kqjx.style.display = 'none' ;
        tb_cqjt.style.display = 'none' ;
        tb_cqzf.style.display = 'none' ;
        tb_wel1.style.display = 'none' ;
        hideEle("tr_wel");
        //tr_wel.style.display='none';
        showEle("td_wel1");
        //td_wel1.style.display='';
        //$GetEle("calMode").style.display='none';
        //$GetEle("directModify").style.display='';
    }
    else if(itemtypelist.value==5){
        tb_fl.style.display = 'none' ; //福利
        hideEle("tr_taxrelateitem");
        //tr_taxrelateitem.style.display = 'none' ; //相关税率项目
        //tr_amountecp.style.display = 'none' ; //计算公式
        tb_je.style.display = 'none' ; //工资
        tb_ss.style.display = 'none' ; //税收
        tb_cal.style.display = 'none' ;
        tb_wel.style.display = 'none' ;
        tb_jssm.style.display = 'none' ; //计算
        tb_kqjx.style.display = 'none' ;
        tb_kqkk.style.display = '' ;
        tb_cqjt.style.display = 'none' ;
        tb_cqzf.style.display = 'none' ;
        tb_wel1.style.display = 'none' ;
        hideEle("tr_wel");        
        //tr_wel.style.display='none';
        hideEle("td_wel1");
        //td_wel1.style.display='none';
        //$GetEle("calMode").style.display='none';
        //$GetEle("directModify").style.display='none';
    }
    else if(itemtypelist.value==6){
        tb_fl.style.display = 'none' ; //福利
        hideEle("tr_taxrelateitem");
        //tr_taxrelateitem.style.display = 'none' ; //相关税率项目
        //tr_amountecp.style.display = 'none' ; //计算公式
        tb_je.style.display = 'none' ; //工资
        tb_ss.style.display = 'none' ; //税收
        tb_cal.style.display = 'none' ;
        tb_wel.style.display = 'none' ;
        tb_jssm.style.display = 'none' ; //计算
        tb_kqkk.style.display = 'none' ;
        tb_kqjx.style.display = '' ;    // 考勤
        tb_cqjt.style.display = 'none' ;
        tb_cqzf.style.display = 'none' ;
        tb_wel1.style.display = 'none' ;
        hideEle("tr_wel");        
        //tr_wel.style.display='none';
        hideEle("td_wel1");
        //td_wel1.style.display='none';
        //$GetEle("calMode").style.display='none';
        //$GetEle("directModify").style.display='none';
    }
    else if(itemtypelist.value==7){
        tb_fl.style.display = 'none' ; //福利
        hideEle("tr_taxrelateitem");
        //tr_taxrelateitem.style.display = 'none' ; //相关税率项目
        //tr_amountecp.style.display = 'none' ; //计算公式
        tb_je.style.display = 'none' ; //工资
        tb_ss.style.display = 'none' ; //税收
        tb_cal.style.display = 'none' ;
        tb_wel.style.display = 'none' ;
        tb_jssm.style.display = 'none' ; //计算
        tb_kqkk.style.display = 'none' ;
        tb_kqjx.style.display = 'none' ;    // 考勤
        tb_cqjt.style.display = '' ;       // 出勤津贴
        tb_cqzf.style.display = 'none' ;
        tb_wel1.style.display = 'none' ;
        hideEle("tr_wel");        
        //tr_wel.style.display='none';
        hideEle("td_wel1");
        //td_wel1.style.display='none';
        //$GetEle("calMode").style.display='none';
        //$GetEle("directModify").style.display='none';
    }
    else if(itemtypelist.value==8){
        tb_fl.style.display = 'none' ; //福利
        hideEle("tr_taxrelateitem");
        //tr_taxrelateitem.style.display = 'none' ; //相关税率项目
        //tr_amountecp.style.display = 'none' ; //计算公式
        tb_je.style.display = 'none' ; //工资
        tb_ss.style.display = 'none' ; //税收
        tb_cal.style.display = 'none' ;
        tb_wel.style.display = 'none' ;
        tb_jssm.style.display = 'none' ; //计算
        tb_kqkk.style.display = 'none' ;
        tb_kqjx.style.display = 'none' ;    // 考勤
        tb_cqjt.style.display = 'none' ;       // 出勤津贴
        tb_cqzf.style.display = '' ;
        tb_wel1.style.display = 'none' ;
        hideEle("tr_wel");        
        //tr_wel.style.display='none';
        hideEle("td_wel1");
        //td_wel1.style.display='none';
        //$GetEle("calMode").style.display='none';
        //$GetEle("directModify").style.display='none';
    }
    else if(itemtypelist.value==9){
        tb_fl.style.display = 'none' ; //福利
        hideEle("tr_taxrelateitem");
        //tr_taxrelateitem.style.display = 'none' ;
        //tr_amountecp.style.display = 'none' ; //计算公式

        tb_je.style.display = 'none' ; //工资
        tb_ss.style.display = 'none' ; //税收
        tb_cal.style.display = 'none' ;
        tb_wel.style.display = '' ;
        tb_jssm.style.display = '' ; //计算
        tb_kqjx.style.display = 'none' ;
        tb_kqkk.style.display = 'none' ;
        tb_cqjt.style.display = 'none' ;
        tb_cqzf.style.display = 'none' ;

        if($GetEle("calMode").value=='1')
        	tb_wel1.style.display = '' ;
        else
        	tb_wel1.style.display = 'none' ;
        showEle("tr_wel");
        //tr_wel.style.display='';
        showEle("td_wel1");
        //td_wel1.style.display='';
        //$GetEle("calMode").style.display='';
        //$GetEle("directModify").style.display='';
    }
}

function onShowOrganization(spanname, inputname,orgtype) {
    if (orgtype.value == "4")
        return onShowHR(spanname, inputname);
    else if (orgtype.value == "3")
        return onShowDept(spanname, inputname);
    else if (orgtype.value == "2")
        return onShowSubcom(spanname, inputname);
    else if (orgtype.value == "1")
        return onShowCityID(spanname, inputname);
    else{
        return null;
        }
}
function onShowHR(spanname, inputname) {

		
	var arrayid,arrayname;
    if($GetEle("applyscope").value=="0")
    url="/hrm/resource/MutiResourceBrowser.jsp";
    else if($GetEle("applyscope").value=="1")
     url=escape("/hrm/resource/MutiResourceBrowser.jsp?sqlwhere=subcompanyid1=<%=subcompanyid%>");
    else if($GetEle("applyscope").value=="2")
     url=escape("/hrm/resource/MutiResourceBrowser.jsp?sqlwhere=subcompanyid1 in(<%=subids%>)");
    var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.URL = url;
    
    if(1==1)
    //datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
    url="/systeminfo/BrowserMain.jsp?url="+url;
     dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>";
	dialog.Width = 700;
	dialog.Height = 450;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.callbackfun = function (params,datas){
	    if(datas){
        if(datas.id!=""){
              arrayid=datas.id.split(",");
              arrayname=datas.name.split(",");
              sHtml = "";
              for(var i=0;i<arrayid.length;i++){
            	  if(arrayid[i]!=""){
            	      sHtml = sHtml+"<a href =javaScript:openhrm("+arrayid[i]+")  onclick='pointerXY(event);' >"+arrayname[i]+"</a>&nbsp";
            	  }
              }                   
              spanname.innerHTML = sHtml;
              inputname.value = datas.id;
        }else{
	      	   spanname.innerHTML = "";
	           inputname.value = "";
       }

    }
	};
	dialog.show();
   
}

function onShowDept(spanname, inputname) {
    url=escape("/hrm/finance/salary/MutiDepartmentByRightBrowser.jsp?selectedids="+inputname.value+"&rightStr=HrmResourceComponentAdd:Add&subcompanyid=<%=subcompanyid%>&scope="+$GetEle("applyscope").value);
    //datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
    sHtml = "";
    url="/systeminfo/BrowserMain.jsp?url="+url;
     dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(18939,user.getLanguage())%>";
	dialog.Width = 700;
	dialog.Height = 450;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.callbackfun = function (params,datas){
	   if(datas){
        if(datas.id!=""){
        	arrayname=datas.name.split(",");
        	for(var i=0;i<arrayname.length;i++){
        		sHtml =sHtml+arrayname[i]+"&nbsp" ;
            }
     	    spanname.innerHTML = sHtml;
            inputname.value = datas.id;
        }else{
     	    spanname.innerHTML = "";
            inputname.value = "";
        }
        
     }
	};
	dialog.show();

}
function onShowSubcom(spanname, inputname) {
    url=escape("/hrm/finance/salary/MutiSubCompanyByRightBrowser.jsp?selectedids="+inputname.value+"&rightStr=HrmResourceComponentAdd:Add&subcompanyid=<%=subcompanyid%>&scope="+$GetEle("applyscope").value);
    //datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
    sHtml = "";
    url="/systeminfo/BrowserMain.jsp?url="+url;
     dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>";
	dialog.Width = 700;
	dialog.Height = 450;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.callbackfun = function (params,datas){
	   if(datas){
	       if(datas.id!=""){
	    	   arrayname=datas.name.split(",");
	       	   for(var i=0;i<arrayname.length;i++){
	       		     sHtml =sHtml+arrayname[i]+"&nbsp" ;
	           }
	    	   spanname.innerHTML = sHtml;
	           inputname.value = datas.id;
	       }else{
	    	   spanname.innerHTML = "";
	           inputname.value = "";
	       }
       
    	}
	};
	dialog.show();
   
    
}
function onShowItemId(){
    url="/hrm/finance/salary/SalaryItemRightBrowser.jsp?mouldID=hrm&subcompanyid=<%=subcompanyid%>&scope="+$GetEle("applyscope").value;
    url="/systeminfo/BrowserMain.jsp?mouldID=hrm&url="+url;
    return url;
}
function onShowScheduleDec(spanname , inputname){
    url=escape("/hrm/finance/salary/HrmScheduleDiffBrowser.jsp?mouldID=hrm&difftype=1&subcompanyid=<%=subcompanyid%>&scope="+$GetEle("applyscope").value)
    //datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url)
    url="/systeminfo/BrowserMain.jsp?url="+url;
     dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(16672,user.getLanguage())%>";
	dialog.Width = 700;
	dialog.Height = 450;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.callbackfun = function (params,datas){
	  if(datas){
        if(datas.id!=""){
        	spanname.innerHTML = datas.name;
            inputname.value = datas.id;
        }else{
        	 spanname.innerHTML = "";
             inputname.value = "";
        }
    }
	};
	dialog.show();
}

function onShowScheduleAdd(spanname , inputname){
    url=escape("/hrm/finance/salary/HrmScheduleDiffBrowser.jsp?mouldID=hrm&difftype=0&subcompanyid=<%=subcompanyid%>&scope="+$GetEle("applyscope").value)
    //datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
    url="/systeminfo/BrowserMain.jsp?url="+url;
     dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(16672,user.getLanguage())%>";
	dialog.Width = 700;
	dialog.Height = 450;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.callbackfun = function (params,datas){
	  if(datas){
        if(datas.id!=""){
        	spanname.innerHTML = datas.name;
            inputname.value = datas.id;
        }else{
        	 spanname.innerHTML = "";
             inputname.value = "";
        }
    }
	};
	dialog.show();
    
}

function onShowCon(spanname , inputname,inputname1,scopetype){
    if(scopetype.value!=0&&scopetype.parentNode.getElementsByTagName("input")[0].value==""){
    window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18214 , user.getLanguage())+SystemEnv.getHtmlLabelName(19467 , user.getLanguage())%>")  ;
    return;
        }
    url=escape("/hrm/finance/salary/conditions.jsp?subc=<%=subcompanyid%>&scope="+$GetEle("applyscope").value+"&st="+scopetype.value+"&sv="+scopetype.parentNode.getElementsByTagName("input")[0].value);
    //datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?mouldID=hrm&url="+url, "" , "dialogWidth=700px;dialogHeight=550px")  ;
    url = "/systeminfo/BrowserMain.jsp?mouldID=hrm&url="+url;
     dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%>";
	dialog.Width = 700;
	dialog.Height = 550;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.callbackfun = function (params,datas){
	  if(datas){
        if(datas.id!=""){
        	spanname.innerHTML = datas.name;
            inputname.value = datas.id;
            inputname1.value = datas.name;
        }else{
        	 spanname.innerHTML = "";
             inputname.value = "";
             inputname1.value = "";
        }
    }
	};
	dialog.show();
}
var dialog;
function onShowFormula(spanname , inputname,inputname1,scopetype){
    dialog = new window.top.Dialog();
    if(scopetype.value!=0&&scopetype.parentNode.getElementsByTagName("input")[0].value==""){
    window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18214 , user.getLanguage())+SystemEnv.getHtmlLabelName(19467 , user.getLanguage())%>")  ;
        return;
        }
    var sizestr = "dialogWidth=700px;dialogHeight=550px";
    if($GetEle("itemtype").value=='9'&&$GetEle("calMode").value=='2'){
    	//url=escape("/hrm/finance/salary/formula1.jsp?subc=<%=subcompanyid%>&scope="+$GetEle("applyscope").value+"&st="+scopetype.value+"&sv="+scopetype.parentNode.getElementsByTagName("input")[0].value);
    	url=escape("/hrm/finance/salary/formula1.jsp?subc=<%=subcompanyid%>&scope="+$GetEle("applyscope").value+"&st="+scopetype.value+"&sv="+scopetype.parentNode.getElementsByTagName("input")[0].value);
    	 sizestr = "dialogWidth=850px;dialogHeight=550px";
    	 dialog.Width = 850;
		 dialog.Height = 550;
    }else{
    	//url=escape("/hrm/finance/salary/formula.jsp?subc=<%=subcompanyid%>&scope="+$GetEle("applyscope").value+"&st="+scopetype.value+"&sv="+scopetype.parentNode.getElementsByTagName("input")[0].value);
    	url=escape("/hrm/finance/salary/formula.jsp?subc=<%=subcompanyid%>&scope="+$GetEle("applyscope").value+"&st="+scopetype.value+"&sv="+scopetype.parentNode.getElementsByTagName("input")[0].value);
    	dialog.Width = 700;
		dialog.Height = 450;
    }
    url="/systeminfo/BrowserMain.jsp?mouldID=hrm&url="+url;
    //datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?mouldID=hrm&url="+url, "" , sizestr)  ;
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(15828,user.getLanguage())%>";
	dialog.Drag = true;
	dialog.URL = url;
	dialog.callbackfun = function (params,datas){
	  if(datas){
	        if(datas.id!=""){
	        	spanname.innerHTML = datas.name;
	            inputname.value = datas.id;
	            inputname1.value = datas.name;
	        }else{
	        	 spanname.innerHTML = "";
	             inputname.value = "";
	             inputname1.value = "";
	        }
	    }
	};
	dialog.show();
   
}




showType();
changescopetype($GetEle("scopetype0"));
changescopetype($GetEle("scopetypecal0"));
</script>
</body>
</html>
