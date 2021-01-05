<%@ page import = "weaver.general.Util" %>
<%@ page import = "weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file = "/systeminfo/init_wev8.jsp" %>

<jsp:useBean id = "RecordSet" class = "weaver.conn.RecordSet" scope = "page"/>
<jsp:useBean id = "RecordSet2" class = "weaver.conn.RecordSet" scope = "page"/>
<jsp:useBean id = "RecordSet3" class = "weaver.conn.RecordSet" scope = "page"/>
<jsp:useBean id = "SalaryComInfo" class = "weaver.hrm.finance.SalaryComInfo" scope = "page" />
<jsp:useBean id = "JobTitlesComInfo" class = "weaver.hrm.job.JobTitlesComInfo" scope = "page" />
<jsp:useBean id = "CityComInfo" class = "weaver.hrm.city.CityComInfo" scope = "page" />
<jsp:useBean id = "HrmScheduleDiffComInfo" class = "weaver.hrm.schedule.HrmScheduleDiffComInfo" scope = "page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" />
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
if(!HrmUserVarify.checkUserRight("HrmResourceComponentEdit:Edit" , user)) {
    response.sendRedirect("/notice/noright.jsp") ; 
    return ; 
 }
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));

String rolelevel=CheckUserRight.getRightLevel("HrmResourceComponentEdit:Edit" , user);
String itemid = Util.null2String(request.getParameter("id")) ; 

String itemname = "" ; //工资项名称

String itemcode = "" ; //工资项代码

String itemtype = "" ; //项目类型

// String personwelfarerate = "" ; //福利个人费率
// String companywelfarerate = "" ; //福利公司费率
String taxrelateitem = "" ; //税收基准项目
String amountecp = "" ; //计算公式

String feetype = "" ; //费用类型
String isshow = "" ; //是否显示
String showorder = "" ; //显示顺序
String ishistory = "" ; //是否记录历史变动
String calMode = "" ; //计算方式
String directModify = "" ; //是否可以直接修改工资单

String companyPercent = "" ; //公司百分比

String personalPercent = "" ; //个人百分比

String applyscope=Util.null2String(request.getParameter("applyscope")) ;//应用范围
String subcompanyid = Util.null2String(request.getParameter("subcompanyid") ) ;
RecordSet.executeSql(" select * from HrmSalaryItem where id = " + itemid + " order by id " ) ; 
if(RecordSet.next()) {
    itemname = Util.toScreen(RecordSet.getString("itemname") , user.getLanguage()) ; 
    itemcode = Util.null2String(RecordSet.getString("itemcode")) ; 
    itemtype = Util.null2String(RecordSet.getString("itemtype")) ; 
    subcompanyid = Util.null2String(RecordSet.getString("subcompanyid")) ; 
//  personwelfarerate = ""+Util.getIntValue(RecordSet.getString("personwelfarerate") , 0) ; 

//  companywelfarerate = ""+Util.getIntValue(RecordSet.getString("companywelfarerate") , 0) ; 
    taxrelateitem = "" + Util.getIntValue(RecordSet.getString("taxrelateitem") , 0) ; 
    amountecp = Util.null2String(RecordSet.getString("amountecp")) ; 
    feetype = "" + Util.getIntValue(RecordSet.getString("feetype") , 0) ; 

    isshow = "" + Util.getIntValue(RecordSet.getString("isshow") , 0) ; 
    showorder = "" + Util.getIntValue(RecordSet.getString("showorder") , 0) ; 
    ishistory = "" + Util.getIntValue(RecordSet.getString("ishistory") , 0) ;
    calMode = "" + Util.getIntValue(RecordSet.getString("calMode") , 0) ;
    directModify = "" + Util.getIntValue(RecordSet.getString("directModify") , 0) ;
    companyPercent = "" + Util.null2String(RecordSet.getString("companyPercent")) ;
    personalPercent = "" + Util.null2String(RecordSet.getString("personalPercent")) ;
    if(subcompanyid.length()==0){
    	subcompanyid = Util.null2String(RecordSet.getString("subcompanyid")) ;
    }
}
String subids=SubCompanyComInfo.getSubCompanyTreeStr(subcompanyid);
if(!applyscope.equals("")) {
    itemname = Util.null2String(request.getParameter("itemname")) ;
    itemcode = Util.null2String(request.getParameter("itemcode"))  ;
    itemtype = Util.null2String(request.getParameter("itemtype"))  ;
//  personwelfarerate = ""+Util.getIntValue(RecordSet.getString("personwelfarerate") , 0) ;

//  companywelfarerate = ""+Util.getIntValue(RecordSet.getString("companywelfarerate") , 0) ;
    taxrelateitem = "" + Util.getIntValue(request.getParameter("taxrelateitem") , 0) ;
    amountecp = Util.null2String(request.getParameter("amountecp")) ;
    feetype = "" + Util.getIntValue(request.getParameter("feetype") , 0) ;

    isshow = "" + Util.getIntValue(request.getParameter("isshow") , 0) ;
    showorder = "" + Util.getIntValue(request.getParameter("showorder") , 0) ;
    ishistory = "" + Util.getIntValue(request.getParameter("ishistory") , 0) ;
    calMode = "" + Util.getIntValue(request.getParameter("calMode") , 0) ;
    directModify = "" + Util.getIntValue(request.getParameter("directModify") , 0) ;
    companyPercent = "" + Util.null2String(request.getParameter("companyPercent")) ;
    personalPercent = "" + Util.null2String(request.getParameter("personalPercent")) ;
}else
  applyscope = Util.null2String(RecordSet.getString("applyscope")) ;
// if(personwelfarerate.equals("0")) personwelfarerate = "" ; 
// if(companywelfarerate.equals("0")) companywelfarerate = "" ; 
if(taxrelateitem.equals("0")) taxrelateitem = "" ;  
if(feetype.equals("0")) feetype = "" ; 

if(showorder.equals("0")) showorder = "" ; 
if(itemtype.equals("4")) {
    amountecp = Util.StringReplace(amountecp , "$" , "") ; 
    }

HashMap schedulediffmap=new HashMap();
HashMap targetmap=new HashMap();
RecordSet3.executeSql("select * from hrmschedulediff where salaryable!=1");
while(RecordSet3.next()){
      schedulediffmap.put(RecordSet3.getString("id"),RecordSet3.getString("diffname"));
}
RecordSet3.executeSql(" select * from hrm_compensationtargetset");
while(RecordSet3.next()){
      targetmap.put(RecordSet3.getString("id"),RecordSet3.getString("targetname"));
}
%>

<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language = "javascript" src = "/js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
var dialogForCloseBtn = parent.parent.getDialog(parent);//关闭按钮专用dialog
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
var ssdrowindex = new Array() ;
var caldrowindex = new Array() ;
var weldrowindex = new Array() ;
</script>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16481 , user.getLanguage())  ; 
String needfav = "1" ; 
String needhelp = "" ; 

int jobindex = -1 ; 
int rateindex = -1 ;
int benchindexwel = -1 ;
int diffDecindex = -1 ;
int diffAddindex = -1 ;
String scriptStr = "";
%>

<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file = "/systeminfo/TopTitle_wev8.jsp"%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
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
<input class=inputstyle type = "hidden" name = "method" value = "edit">
<input class=inputstyle type = "hidden" name = "subcompanyid" value = "<%=subcompanyid%>">
<input class=inputstyle type = "hidden" name = "id" value = "<%=itemid%>">
<input class=inputstyle type = "hidden" name = "olditemtype" value = "<%=itemtype%>">
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361 , user.getLanguage())%>'>
	  <wea:item><%=SystemEnv.getHtmlLabelName(195 , user.getLanguage())%></wea:item>
	  <wea:item><input class=inputstyle  maxLength = 50 size = 25 name = "itemname" style="width: 240px" value = '<%=itemname%>' onchange = 'checkinput("itemname","nameimage")'><SPAN id = nameimage>
	  <% if(itemname.equals("")) {%><IMG src="/images/BacoError_wev8.gif" align = absMiddle><%}%> </SPAN>
	  </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(590 , user.getLanguage())%></wea:item>
    <wea:item><input class=inputstyle  maxLength = 50 size = 25 name = "itemcode" style="width: 240px" value = '<%=itemcode%>' onchange = 'checkinput("itemcode","itemcodeimage")'><SPAN id = itemcodeimage>
    <% if(itemcode.equals("")) {%><IMG src = "/images/BacoError_wev8.gif" align = absMiddle><%}%>
    	<img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelName(15830 , user.getLanguage())%>" />
    </SPAN>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(19799 , user.getLanguage())%></wea:item>
		<wea:item><%=SubCompanyComInfo.getSubCompanyname(subcompanyid)%></wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(63 , user.getLanguage())%></wea:item>
    <wea:item> 
        <select class=inputstyle  style = "width:100px" onChange = "showType()" disabled>
          <option value = "1" <% if(itemtype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1804 , user.getLanguage())%></option>                   
          <option value = "3" <% if(itemtype.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15826 , user.getLanguage())%></option>
          <option value = "4" <% if(itemtype.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(449 , user.getLanguage())%></option>
          <%--<option value = "5" <% if(itemtype.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16668 , user.getLanguage())%></option>
          <option value = "6" <% if(itemtype.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16669 , user.getLanguage())%></option>
          <option value = "7" <% if(itemtype.equals("7")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16740 , user.getLanguage())%></option>--%>
          <option value = "9" <% if(itemtype.equals("9")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15825 , user.getLanguage())+SystemEnv.getHtmlLabelName(449 , user.getLanguage())%></option>
        </select>
        <input type="hidden" name = "itemtype" value="<%=itemtype%>">
    </wea:item>
    <wea:item attributes="{'samePair':'tr_wel'}"><%=SystemEnv.getHtmlLabelName(449 , user.getLanguage())+SystemEnv.getHtmlLabelName(599 , user.getLanguage())%></wea:item>
    <wea:item attributes="{'samePair':'tr_wel'}">
      	<input name="original" type="hidden" value="<%=calMode%>">
        <select class=inputstyle name = "calMode" <% if(!itemtype.equals("9")){%>style = "display:none"<%}%> onChange = "changeScope()">
         <option value = "1" <% if(calMode.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19529 , user.getLanguage())%></option>
         <option value = "2" <% if(calMode.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19530 , user.getLanguage())%></option>
       </select>
    </wea:item>
    <wea:item attributes="{'samePair':'tr_taxrelateitem'}"><%=SystemEnv.getHtmlLabelName(15827 , user.getLanguage())%></wea:item>
   	<wea:item attributes="{'samePair':'tr_taxrelateitem'}">
   		<button class = Browser type=button id = SelectItemId onClick = "onShowItemId(taxrelateitemspan,taxrelateitem)"></button> 
                <span class=inputstyle id = taxrelateitemspan><%=Util.toScreen(SalaryComInfo.getSalaryname(taxrelateitem) , user.getLanguage())%></span> 
                <input class=inputstyle id = taxrelateitem type = hidden name = taxrelateitem value = "<%=taxrelateitem%>"> 
   	</wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(33602 , user.getLanguage())%></wea:item>
    <wea:item>
        <select class=inputstyle id = isshow name = isshow onChange = "showOrder()" style="width:60px">
            <option value = 1 <% if(isshow.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(163 , user.getLanguage())%></option>
            <option value = 0 <% if(isshow.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(161 , user.getLanguage())%></option>
        </select>
    </wea:item>
    <wea:item attributes="{'samePair':'tr_showorder'}"><%=SystemEnv.getHtmlLabelName(15513 , user.getLanguage())%></wea:item>
    <wea:item attributes="{'samePair':'tr_showorder'}">
    	<INPUT class=inputstyle maxLength = 5 size = 5 name = "showorder" value = "<%=showorder%>" style="width:60px" onKeyPress="ItemCount_KeyPress()" onBlur="checknumber('showorder')" onchange = 'checkinput4order("showorder","showorderimage")'><SPAN id = showorderimage>
      <% if(showorder.equals("")) {%><IMG src="/images/BacoError_wev8.gif" align = absMiddle><%}%> </SPAN>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(19374,user.getLanguage())%></wea:item>
    <wea:item>
      <input name="original" type="hidden" value="<%=calMode%>">
    	<select class=inputstyle name = "applyscope" size = 1 onchange="changeScope();">
			 <%if(user.getLoginid().equalsIgnoreCase("sysadmin")||rolelevel.equals("2")){%>
			 <option value = "0" <% if(applyscope.equals("0")){%> selected<%}%>>
			 <%=SystemEnv.getHtmlLabelName(140 , user.getLanguage())%></option>
			 <%}%>
			 <option value = "1" <% if(applyscope.equals("1")){%> selected<%}%>>
			 <%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%></option>
			 <option value = "2" <% if(applyscope.equals("2")){%> selected<%}%>>
			 <%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18921, user.getLanguage())%></option>
			</select>
    </wea:item>
    <wea:item attributes="{'samePair':'td_wel1'}"><%=SystemEnv.getHtmlLabelName(19531,user.getLanguage())%></wea:item>
    <wea:item attributes="{'samePair':'td_wel1'}">
   		<select class=inputstyle <% if(!itemtype.equals("9")&&!itemtype.equals("4")){%>style = "display:none"<%}%> name = "directModify" size = 1 >
         <option value = "0" <% if(directModify.equals("0")){%> selected<%}%>>
         <%=SystemEnv.getHtmlLabelName(161 , user.getLanguage())%></option>
         <option value = "1" <% if(directModify.equals("1")){%> selected<%}%>>
         <%=SystemEnv.getHtmlLabelName(163 , user.getLanguage())%></option>
       </select>
    </wea:item>
	</wea:group>
</wea:layout>
<div>
<!-- 
<table  width = 100% border = 1 bordercolor = 'black'>
  <tbody>
  <tr><td>
  <%=SystemEnv.getHtmlLabelName(15830 , user.getLanguage())%>
  </td></tr>
  </tbody>
</table>
</div>
<br>
 -->
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
    ajax.open("POST", "HrmSalaryEditAjax.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("subCompanyId=<%=subcompanyid%>&departmentid="+deptid+"&xuhao="+xuhao+"&userid=<%=user.getUID()%>&itemid=<%=itemid%>");
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

<div id = tb_jssm <% if(!itemtype.equals("4")&&!itemtype.equals("9")) {%>style = "display:none"<%}%>>
<!-- 
<table  width = 100% border = 1 bordercolor = 'black'>
  <tbody>
  <tr><td>
  <%=SystemEnv.getHtmlLabelName(83483 , user.getLanguage())%> <BR>
  <%=SystemEnv.getHtmlLabelName(83487 , user.getLanguage())%> 
  </td></tr>
  </tbody>
</table>
 -->
</div>

<div id = tb_je <% if(!itemtype.equals("1") && !itemtype.equals("2")) {%>style = "display:none"<%}%>>
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(603 , user.getLanguage())%>' attributes="{'groupOperDisplay':'false'}">
		<wea:item type="groupHead" >
			<input type="button" class =addbtn type=button accessKey = I onClick = "addRowJe();" title="<%=SystemEnv.getHtmlLabelName(551 , user.getLanguage())%>">
	    <input type="button" class =delbtn type=button accessKey = D onClick = "dodelete_Je();" title="<%=SystemEnv.getHtmlLabelName(91 , user.getLanguage())%>">
		</wea:item>
		<wea:item attributes="{'isTableList':'true'}">
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
		  <%
		    String jobactivityid = "" ;
		    String jobid = "" ; 
		    String joblevelfrom = "" ; 
		    String joblevelto = "" ; 
		    String amount = "" ; 
		
		    RecordSet.executeSql(" select * from HrmSalaryRank where itemid = " + itemid + " order by id " ) ; 
		    while( RecordSet.next() ) {
		        jobactivityid = ""+Util.getIntValue(RecordSet.getString("jobactivityid"),0) ;
		        jobid = "" + Util.getIntValue(RecordSet.getString("jobid") , 0) ; 
		        joblevelfrom = "" + Util.getIntValue(RecordSet.getString("joblevelfrom") , 0) ; 
		        joblevelto = "" + Util.getIntValue(RecordSet.getString("joblevelto") , 0) ; 
		        amount = "" + Util.getDoubleValue(RecordSet.getString("amount") , 0) ; 
		        /*
		        if( jobid.equals("0") ) jobid = "" ; 
		        if( joblevelfrom.equals("0") ) joblevelfrom = "" ; 
		        if( joblevelto.equals("0") ) joblevelto = "" ; 
		        if( amount.equals("0") ) amount = "" ; 
		        */
		        jobindex ++ ; 
		   %>
			  <TR class="DataDark"> 
			    <TD><input class=inputstyle type = 'checkbox' name = 'check_je' value = 1></TD>
			    <TD>
			    	<%String jobactivity="jobactivityid"+jobindex; %>
				    <brow:browser viewType="0" name='<%=jobactivity %>' browserValue='<%=jobactivityid%>' 
						  browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/jobactivities/JobActivitiesBrowser.jsp"
						  hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
						  completeUrl="/data.jsp?type=jobactivity" width="240px"
						  browserSpanValue='<%=Util.toScreen(JobActivitiesComInfo.getJobActivitiesname(jobactivityid),user.getLanguage())%>'>
						</brow:browser>
			    </TD>
			    <TD>
			    <%String jobname="jobid"+jobindex; %>
				    <brow:browser viewType="0" name='<%=jobname %>' browserValue='<%=jobid%>' 
						  browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp"
						  hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
						  completeUrl="/data.jsp?type=hrmjobtitles" width="240px"
						  browserSpanValue='<%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(jobid) , user.getLanguage())%>'>
						</brow:browser>
			    </TD>
			    <TD><input class=inputstyle type = 'text' name = 'joblevelfrom<%=jobindex%>' value = "<%=joblevelfrom%>" style = 'width:100%'  onKeyPress = 'ItemCount_KeyPress()' onBlur = 'checkcount1(this)'></TD>
			    <TD><input class=inputstyle type = 'text' name = 'joblevelto<%=jobindex%>' value = "<%=joblevelto%>" style = 'width:100%'  onKeyPress = 'ItemCount_KeyPress()' onBlur = 'checkcount1(this)'></TD>
			    <TD><input class=inputstyle type = 'text' name = 'amount<%=jobindex%>' value = "<%=amount%>" style = 'width:100%' onKeyPress = 'ItemNum_KeyPress()' onBlur = 'checknumber1(this)'>
			    </TD></TR>
			<%} %>
			  </tbody>
			</table>
		</wea:item>
	</wea:group>
</wea:layout>
</div>

<div id = tb_cqzf <% if(!itemtype.equals("8") && !itemtype.equals("2") && !itemtype.equals("1")) {%>style = "display:none"<%}%>>
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(33603 , user.getLanguage())%>' attributes="{'groupOperDisplay':'false'}">
		<wea:item attributes="{'isTableList':'true'}">
<table class = ListStyle>
  <COLGROUP> 
  <COL width = "15%"> 
  <COL width = "15%">
  <COL width = "70%"> 
  <tbody>
  <TR class = HeaderForXtalbe> 
    <TH><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(714 , user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(534,user.getLanguage())%></TH>
  </TR>
<tr>
       <td colspan="3">
  <%
    //  获得所有出勤种类关联的金额
    ArrayList resourceids = new ArrayList() ;
    ArrayList resourcepays = new ArrayList() ;

    RecordSet.executeProc("HrmSalaryResourcePay_SByItemid" , itemid) ; 
    while( RecordSet.next() ) {
        String resourcepay = Util.null2String(RecordSet.getString("resourcepay")) ;
        if( Util.getDoubleValue(resourcepay,0) == 0 ) continue ;
        resourceids.add(Util.null2String(RecordSet.getString("resourceid"))) ;
        resourcepays.add(Util.null2String(RecordSet.getString("resourcepay"))) ;
    }
    
    if(applyscope.equals("")){
     if(user.getLoginid().equalsIgnoreCase("sysadmin")||rolelevel.equals("2")){
     RecordSet.executeSql(" select a.departmentid, count(a.id) from Hrmresource a  left join HrmSalaryResourcePay b on a.id=b.resourceid where status in (0,1,2,3) group by a.departmentid") ;
     
     }else{
     RecordSet.executeSql(" select a.departmentid, count(a.id) from Hrmresource a  left join HrmSalaryResourcePay b on a.id=b.resourceid where status in (0,1,2,3) and subcompanyid1="+subcompanyid+" group by a.departmentid") ;
   
     }
     }else{
        if(applyscope.equals("0")&&(user.getLoginid().equalsIgnoreCase("sysadmin")||rolelevel.equals("2"))){
     RecordSet.executeSql(" select a.departmentid, count(a.id) from Hrmresource a  left join HrmSalaryResourcePay b on a.id=b.resourceid where status in (0,1,2,3) group by a.departmentid") ;
     
        }else if(applyscope.equals("1")){
     RecordSet.executeSql(" select a.departmentid, count(a.id) from Hrmresource a  left join HrmSalaryResourcePay b on a.id=b.resourceid where status in (0,1,2,3) and subcompanyid1="+subcompanyid+" group by a.departmentid") ;
    
        }else if(applyscope.equals("2")) {
            subids=subcompanyid+","+subids;

    subids=subids.substring(0,subids.length()-1);
    RecordSet.executeSql(" select a.departmentid, count(a.id) from Hrmresource a  left join HrmSalaryResourcePay b on a.id=b.resourceid where status in (0,1,2,3) and subcompanyid1 in("+subids+") group by a.departmentid") ;
   
        }
     }
    int i = 0;
   
	while(RecordSet.next()){ 
		int departmentid_tmp = Util.getIntValue(RecordSet.getString(1), 0);
		if(departmentid_tmp==0)continue;
		int count_tmp = Util.getIntValue(RecordSet.getString(2), 0);
		if(count_tmp>0){
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

<div id = tb_fl <% if(!itemtype.equals("2")) {%>style = "display:none"<%}%>>
<br>
<table  class = viewform>
  <tbody>
  <TR class=Title> 
    <TH><%=SystemEnv.getHtmlLabelName(15833 , user.getLanguage())%></TH>
    <TH style = "TEXT-ALIGN: right">
    <BUTTON class = addbtn type=button accessKey = I onClick="addRowFl();" title="<%=SystemEnv.getHtmlLabelName(551 , user.getLanguage())%>"></BUTTON>
    <BUTTON class = delbtn type=button accessKey = D onClick = "dodelete_Fl();" title="<%=SystemEnv.getHtmlLabelName(91 , user.getLanguage())%>"></BUTTON>
  </TH>
  </TR>
  <TR class= Spacing style="height:2px"><TD class=Line1 colSpan = 2></TD></TR>
  </tbody>
</table>
<TABLE class=ListStyle cellspacing=1  id = "oTable_fl" cols = 4>
  <COLGROUP>
  <COL width = "5%"> 
  <COL width = "30%"> 
  <COL width = "32%">
  <COL width = "32%">
  <TBODY>
  <TR class = HeaderForXtalbe> 
    <TH>&nbsp;</TH>
    <TH><%=SystemEnv.getHtmlLabelName(493 , user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(6087 , user.getLanguage())%>(%)</TH>
    <TH><%=SystemEnv.getHtmlLabelName(1851 , user.getLanguage())%>(%)</TH>
  </TR>
  <%
    String ratecityid = "" ; 
    String personwelfarerate = "" ; 
    String companywelfarerate = "" ; 
    int ratecityindex = -1 ; 

    RecordSet.executeSql(" select * from HrmSalaryWelfarerate where itemid = " + itemid + " order by id " ) ; 
    while( RecordSet.next() ) { 
        ratecityid = ""+Util.getIntValue(RecordSet.getString("cityid") , 0) ;
        personwelfarerate = "" + Util.getDoubleValue(RecordSet.getString("personwelfarerate") , 0) ; 
        companywelfarerate = "" + Util.getDoubleValue(RecordSet.getString("companywelfarerate") , 0) ; 

        if( ratecityid.equals("0") ) ratecityid = "" ; 
        if( personwelfarerate.equals("0") ) personwelfarerate = "" ; 
        if( companywelfarerate.equals("0") ) companywelfarerate = "" ; 
        ratecityindex ++ ; 
%>
  <TR> 
    <TD><input class=inputstyle type = 'checkbox' name = 'check_fl' value = 1></TD>
    <TD>
        <input class=wuiBrowser type='hidden' name = 'ratecityid<%=ratecityindex%>' value = '<%=ratecityid%>'
        _url="/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp">
    </TD>
    <TD><input class=inputstyle  maxLength = 10 size = 15 name = "personwelfarerate<%=ratecityindex%>" onKeyPress = "ItemNum_KeyPress()" onBlur = 'checknumber1(this)' value = "<%=personwelfarerate%>">%
    </TD>
    <TD><INPUT class=inputstyle maxLength = 10 size = 15 name = "companywelfarerate<%=ratecityindex%>" onKeyPress = "ItemNum_KeyPress()" onBlur = 'checknumber1(this)' value = "<%=companywelfarerate%>">%</TD>
  </TR>
<%  } %>
  </tbody>
</table>
</div>

<div id = tb_ss <% if(!itemtype.equals("3")) {%>style = "display:none"<%}%>>
<%
int benchindexcal = -1 ;
String scopetype="";
String benchid = "" ; 
String cityid = "" ; 
String taxbenchmark = "" ; 
int benchindex = -1 ; 
%>
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15834 , user.getLanguage())%>' attributes="{'groupOperDisplay':'false'}">
		<wea:item type="groupHead" >
			<input type="button" class =addbtn type=button accessKey = I onClick = "addRowSs();" title="<%=SystemEnv.getHtmlLabelName(551,user.getLanguage())%>">
	    <input type="button" class =delbtn type=button accessKey = D onClick = "dodelete_Ss();" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>">
		</wea:item>
		<wea:item attributes="{'isTableList':'true'}">
<TABLE class=ListStyle cellspacing=1  id = "oTable_ss" cols = 2>
  <COLGROUP>
  <COL width="3%">
  <COL width="97%"> 
  <TBODY>
<%

    RecordSet.executeSql(" select * from HrmSalaryTaxbench where itemid = " + itemid + " order by id " ) ; 
    while( RecordSet.next() ) { 
        benchid = "" + Util.getIntValue(RecordSet.getString("id") , 0) ; 
        cityid = "" + Util.getIntValue(RecordSet.getString("cityid") , 0) ; 
        taxbenchmark = "" + Util.getIntValue(RecordSet.getString("taxbenchmark") , 0) ; 
        if( cityid.equals("0") ) cityid = "" ; 
        if( taxbenchmark.equals("0") ) taxbenchmark = "" ;
        benchindex ++ ;
        
        String ranknum = "" ; 
        String ranklow = "" ; 
        String rankhigh = "" ; 
        String taxrate = "" ;
        String subtractnum="";
        rateindex = -1 ; 

        RecordSet2.executeSql(" select * from HrmSalaryTaxscope where benchid = " + benchid ) ;
        scopetype="";
        String scopename="";
        String objids="";
        while(RecordSet2.next()){
             scopetype=Util.null2String(RecordSet2.getString("scopetype"));
             if(scopetype.equals("1")){
             String objid=Util.null2String(RecordSet2.getString("objectid"));
             scopename=CityComInfo.getCityname(objid) ;
             objids= objid;
             }else if(scopetype.equals("2")){
             String objid=Util.null2String(RecordSet2.getString("objectid"));
                if(scopename.equals("")){
                   scopename+=SubCompanyComInfo.getSubCompanyname(objid);
                   objids+=objid;
                }else{
                   scopename+=","+SubCompanyComInfo.getSubCompanyname(objid) ;
                   objids+= ","+objid ;
                }
             }else if(scopetype.equals("3")){
             String objid=Util.null2String(RecordSet2.getString("objectid"));
                if(scopename.equals("")){
                   scopename+=DepartmentComInfo.getDepartmentname(objid);
                   objids+=objid;
                }else  {
                   scopename+=","+DepartmentComInfo.getDepartmentname(objid) ;
                   objids+= ","+objid ;
                }
             }else if(scopetype.equals("4")){
             String objid=Util.null2String(RecordSet2.getString("objectid"));
                if(scopename.equals("")){
                   scopename+=ResourceComInfo.getLastname(objid);
                   objids+=objid;
                }else{
                   scopename+=","+ResourceComInfo.getLastname(objid) ;
                   objids+= ","+objid ;
                }
             }
        }
        RecordSet2.executeSql(" select * from HrmSalaryTaxrate where benchid = " + benchid + " order by ranknum " ) ; 
        if( RecordSet2.next() ) { 
            ranknum = "" + Util.getIntValue(RecordSet2.getString("ranknum") , 0) ; 
            ranklow = "" + Util.getIntValue(RecordSet2.getString("ranklow") , 0) ; 
            rankhigh = "" + Util.getIntValue(RecordSet2.getString("rankhigh") , 0) ; 
            taxrate = "" + Util.getIntValue(RecordSet2.getString("taxrate") , 0) ;
            subtractnum="" + Util.getIntValue(RecordSet2.getString("subtractnum") , 0) ;

            if( ranknum.equals("0") ) ranknum = "" ; 
//            if( ranklow.equals("0") ) ranklow = "" ; 
            if( rankhigh.equals("0") ) rankhigh = "" ; 
            if( taxrate.equals("0") ) taxrate = "" ;
            rateindex ++ ; 
        } 
   %>
  <TR><TD><input class=inputstyle type = 'checkbox' name = 'check_ss' value = 1></TD>
  <TD>
  <TABLE class=ListStyle cellspacing=1  id = 'oTable_ssdetail<%=benchindex%>' name = 'oTable_ssdetail<%=benchindex%>' cols = 7>
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
        <select name=scopetype<%=benchindex%> onchange="changescopetype(this);">
        <option  value="0" <%if(scopetype.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332 , user.getLanguage())%></option>
        <option  value="1" <%if(scopetype.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(493 , user.getLanguage())%></option>
        <option  value="2" <%if(scopetype.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%></option>
        <option  value="3" <%if(scopetype.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18939 , user.getLanguage())%></option>
        <option  value="4" <%if(scopetype.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(179 , user.getLanguage())%></option>
        </select>
        <BUTTON class = Browser type=button id="browser<%=benchindex%>" onclick = 'onShowOrganization(cityidspan<%=benchindex%>,cityid<%=benchindex%>,scopetype<%=benchindex%>)' <%if(scopetype.equals("0")){%> style="display:none"<%}%>>
        </BUTTON><SPAN id = "cityidspan<%=benchindex%>">
        <%=scopename%></SPAN>
        <input class=inputstyle type = 'hidden'  name = 'cityid<%=benchindex%>' value = '<%=objids%>'></TD>
    <TD><INPUT class=inputstyle maxLength = 10 style = 'width:100%'  name = 'taxbenchmark<%=benchindex%>'        value = "<%=taxbenchmark%>" onKeyPress = 'ItemCount_KeyPress()' onBlur = 'checkcount1(this)' ></TD>
    <TD><INPUT class=inputstyle maxLength = 10 style = 'width:100%' name = 'ranknum<%=benchindex%>_<%=rateindex%>' value = "<%=ranknum%>" onKeyPress = 'ItemCount_KeyPress()' onBlur = 'checkcount1(this)' ></TD>
    <TD><INPUT class=inputstyle maxLength = 10 style = 'width:100%'  name = 'ranklow<%=benchindex%>_<%=rateindex%>' value = "<%=ranklow%>" onKeyPress = 'ItemCount_KeyPress()' onBlur = 'checkcount1(this)' ></TD>
    <TD><INPUT class=inputstyle maxLength = 10 style = 'width:100%'  name = 'rankhigh<%=benchindex%>_<%=rateindex%>' value = "<%=rankhigh%>" onKeyPress = 'ItemCount_KeyPress()' onBlur = 'checkcount1(this)' ></TD>
    <TD><INPUT class=inputstyle maxLength = 10 style = 'width:100%'  name = 'taxrate<%=benchindex%>_<%=rateindex%>' value = "<%=taxrate%>" onKeyPress = 'ItemCount_KeyPress()' onBlur = 'checkcount1(this)' ></TD>
    <TD><INPUT class=inputstyle maxLength = 10 style = 'width:100%'  name = 'subtractnum<%=benchindex%>_<%=rateindex%>' value = "<%=subtractnum%>" onKeyPress = 'ItemCount_KeyPress()' onBlur = 'checkcount1(this)' ></TD>
    </TR>
 <%
        while( RecordSet2.next() ) { 
            ranknum = "" + Util.getIntValue(RecordSet2.getString("ranknum") , 0) ; 
            ranklow = "" + Util.getIntValue(RecordSet2.getString("ranklow") , 0) ; 
            rankhigh = "" + Util.getIntValue(RecordSet2.getString("rankhigh") , 0) ; 
            taxrate = "" + Util.getIntValue(RecordSet2.getString("taxrate") , 0) ;
            subtractnum = "" + Util.getIntValue(RecordSet2.getString("subtractnum") , 0) ;
            rateindex ++ ; 

            if( ranknum.equals("0") ) ranknum = "" ; 
 //         if( ranklow.equals("0") ) ranklow = "" ; 
            if( rankhigh.equals("0") ) rankhigh = "" ; 
            if( taxrate.equals("0") ) taxrate = "" ;
%>
    <TR class=DataDark> 
    <TD>&nbsp;</TD>
    <TD>&nbsp;</TD>
    <TD><INPUT class=inputstyle maxLength = 10 style = 'width:100%' name = 'ranknum<%=benchindex%>_<%=rateindex%>' value = "<%=ranknum%>" onKeyPress = 'ItemCount_KeyPress()' onBlur = 'checkcount1(this)' ></TD>
    <TD><INPUT class=inputstyle maxLength = 10 style = 'width:100%' name = 'ranklow<%=benchindex%>_<%=rateindex%>' value = "<%=ranklow%>" onKeyPress = 'ItemCount_KeyPress()' onBlur = 'checkcount1(this)' ></TD>
    <TD><INPUT class=inputstyle maxLength = 10 style = 'width:100%' name = 'rankhigh<%=benchindex%>_<%=rateindex%>' value = "<%=rankhigh%>" onKeyPress = 'ItemCount_KeyPress()' onBlur = 'checkcount1(this)' ></TD>
    <TD><INPUT class=inputstyle maxLength = 10 style = 'width:100%'  name = 'taxrate<%=benchindex%>_<%=rateindex%>' value = "<%=taxrate%>" onKeyPress = 'ItemCount_KeyPress()' onBlur = 'checkcount1(this)' ></TD>
    <TD><INPUT class=inputstyle maxLength = 10 style = 'width:100%'  name = 'subtractnum<%=benchindex%>_<%=rateindex%>' value = "<%=subtractnum%>" onKeyPress = 'ItemCount_KeyPress()' onBlur = 'checkcount1(this)' ></TD>
    </TR>
 <% }
        rateindex ++ ; 

        %>
    <script language = javascript>
        ssdrowindex[<%=benchindex%>] = <%=rateindex%> ; 
    </script>
    </TABLE>
    <TABLE width = 100%>
    <TR> 
    <TD style="text-align: right;">
    <BUTTON class = addbtn type="button" accessKey = 1 onClick = "addRowSsD('<%=benchindex%>')" title="<%=SystemEnv.getHtmlLabelName(15836 , user.getLanguage())%>"></BUTTON>
    </TD></TR>
    </table>
    </TD></TR>
<% } %>
    </TBODY>
    </TABLE>
    </wea:item>
</wea:group>
</wea:layout>
    </div>

<div id = tb_cal <% if(!itemtype.equals("4")) {%>style = "display:none"<%}%>>
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("18125,68" , user.getLanguage())%>' attributes="{'groupOperDisplay':'false'}">
		<wea:item type="groupHead" >
			<input class =addbtn type=button accessKey = I onClick = "addRowCal();" title="<%=SystemEnv.getHtmlLabelName(551,user.getLanguage())%>">
	    <input class =delbtn type=button accessKey = D onClick = "dodelete_Cal();" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>">
		</wea:item>
		<wea:item attributes="{'isTableList':'true'}">
			<TABLE class=viewform style="width: 100%" cellspacing=1   id = "oTable_cal" cols = 2>
  <COLGROUP>
  <COL width="3%">
  <COL width="97%">
  <TBODY>
<%
    benchid = "" ;
    scopetype = "" ;

    RecordSet.executeSql(" select * from HrmSalaryCalBench where itemid = " + itemid + " order by id " ) ;
    while( RecordSet.next() ) {
        benchid = "" + Util.getIntValue(RecordSet.getString("id") , 0) ;
        scopetype = "" + Util.getIntValue(RecordSet.getString("scopetype") , 0) ;


        benchindexcal++ ;

        String timescope = "" ;
        String condition = "" ;
        String formular = "" ;

        RecordSet2.executeSql(" select * from HrmSalaryCalScope where benchid = " + benchid ) ;

        String scopename="";
        String objids="";
        while(RecordSet2.next()){

           if(scopetype.equals("2")){
             String objid=Util.null2String(RecordSet2.getString("objectid"));
                if(scopename.equals("")){
                   scopename+=SubCompanyComInfo.getSubCompanyname(objid);
                   objids+=objid;
                }else{
                   scopename+=","+SubCompanyComInfo.getSubCompanyname(objid) ;
                   objids+= ","+objid ;
                }
             }else if(scopetype.equals("3")){
             String objid=Util.null2String(RecordSet2.getString("objectid"));
                if(scopename.equals("")){
                   scopename+=DepartmentComInfo.getDepartmentname(objid);
                   objids+=objid;
                }else  {
                   scopename+=","+DepartmentComInfo.getDepartmentname(objid) ;
                   objids+= ","+objid ;
                }
             }else if(scopetype.equals("4")){
             String objid=Util.null2String(RecordSet2.getString("objectid"));
                if(scopename.equals("")){
                   scopename+=ResourceComInfo.getLastname(objid);
                   objids+=objid;
                }else{
                   scopename+=","+ResourceComInfo.getLastname(objid) ;
                   objids+= ","+objid ;
                }
             }
        }
        RecordSet2.executeSql(" select * from HrmSalaryCalRate where benchid = " + benchid  ) ;
        if( RecordSet2.next() ) {
            timescope = "" + Util.getIntValue(RecordSet2.getString("timescope") , 0) ;
            condition = "" + Util.null2String(RecordSet2.getString("condition"))  ;
            formular = "" + Util.null2String(RecordSet2.getString("formular")) ;
            /*String schedulediff=Util.match(condition,"@[^@]*@");
            while(!schedulediff.equals("")){

            String schedulediffid= schedulediff.substring(1,schedulediff.lastIndexOf("@"));
            String schedulediffname=Util.null2String((String)schedulediffmap.get(schedulediffid));
            condition=Util.replace(condition,"@[^@]*@",schedulediffname,1) ;
            schedulediff=Util.match(condition,"@[^@]*@");
            }
            String target=Util.match(condition,"\\$[^\\$]*\\$");
            while(!target.equals("")){
            String targetid= target.substring(1,target.lastIndexOf("$"));
            String targetid_1=targetid.substring(0,targetid.indexOf("("));

            String targetid_2=targetid.substring(targetid.indexOf("(")+1,targetid.indexOf(")"));
            if(targetid_2.equals("1"))
             targetid_2= SystemEnv.getHtmlLabelName(17138,user.getLanguage());
                else  if(targetid_2.equals("2"))
            targetid_2= SystemEnv.getHtmlLabelName(19483,user.getLanguage());
            else  if(targetid_2.equals("3"))
            targetid_2= SystemEnv.getHtmlLabelName(17495,user.getLanguage());
                else  if(targetid_2.equals("4"))
            targetid_2= SystemEnv.getHtmlLabelName(19398,user.getLanguage());
            String targetname=Util.null2String((String)targetmap.get(targetid_1))+"("+targetid_2+")";
            condition=Util.replace(condition,"\\$[^\\$]*\\$",targetname,1) ;
            target=Util.match(condition,"\\$[^\\$]*\\$");
            }
            //解析公式
            schedulediff=Util.match(formular,"@[^@]*@");
            while(!schedulediff.equals("")){

            String schedulediffid= schedulediff.substring(1,schedulediff.lastIndexOf("@"));
            String schedulediffname=Util.null2String((String)schedulediffmap.get(schedulediffid));
            formular=Util.replace(formular,"@[^@]*@",schedulediffname,1) ;
            schedulediff=Util.match(formular,"@[^@]*@");
            }

            target=Util.match(formular,"\\$[^\\$]*\\$");
            while(!target.equals("")){
            String targetid= target.substring(1,target.lastIndexOf("$"));
            String targetid_1=targetid.substring(0,targetid.indexOf("("));

            String targetid_2=targetid.substring(targetid.indexOf("(")+1,targetid.indexOf(")"));
            if(targetid_2.equals("1"))
             targetid_2= SystemEnv.getHtmlLabelName(17138,user.getLanguage());
                else  if(targetid_2.equals("2"))
            targetid_2= SystemEnv.getHtmlLabelName(19483,user.getLanguage());
            else  if(targetid_2.equals("3"))
            targetid_2= SystemEnv.getHtmlLabelName(17495,user.getLanguage());
                else  if(targetid_2.equals("4"))
            targetid_2= SystemEnv.getHtmlLabelName(19398,user.getLanguage());
            String targetname=Util.null2String((String)targetmap.get(targetid_1))+"("+targetid_2+")";
            formular=Util.replace(formular,"\\$[^\\$]*\\$",targetname,1) ;
            target=Util.match(formular,"\\$[^\\$]*\\$");
            }
            //解析工资项目
            //System.out.println("formular"+formular);
            String item = Util.match(formular, "#[^#]*#");
            while (!item.equals("")) {
                String theitemid = item.substring(1, item.lastIndexOf("#"));
                String theitemcode="";
                if(theitemid.indexOf("_")>0){
                theitemcode=SalaryComInfo.getSalaryCode(theitemid.substring(0,theitemid.indexOf("_")))+theitemid.substring(theitemid.indexOf("_"));
                }else
                theitemcode=SalaryComInfo.getSalaryCode(theitemid);
                //System.out.println("theitemcode"+theitemcode);
                formular = Util.replace(formular, "#[^#]*#", theitemcode, 1);
                item = Util.match(formular, "#[^#]*#");
            }

            formular=Util.replace(formular,"\\^",SystemEnv.getHtmlLabelName(19378,user.getLanguage()),0);
            //System.out.println("formulars"+formular);*/
            rateindex ++ ;
        }else
           rateindex=0;
   %>
  <TR>
  	<TD><input class=inputstyle type = 'checkbox' name = 'check_cal' value = 1></TD>
  <TD>
  <TABLE class=ListStyle cellspacing=1  id = 'oTable_caldetail<%=benchindexcal%>'name = 'oTable_caldetail<%=benchindexcal%>' cols = 6>
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
        <select name=scopetypecal<%=benchindexcal%> onchange="changescopetype(this);">
        <option  value="0" <%if(scopetype.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332 , user.getLanguage())%></option>
        <option  value="2" <%if(scopetype.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%></option>
        <option  value="3" <%if(scopetype.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18939 , user.getLanguage())%></option>
        <option  value="4" <%if(scopetype.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(179 , user.getLanguage())%></option>
        </select>
        <BUTTON class = Browser type=button <%if(scopetype.equals("0")){%> style="display:none"<%}%> onclick = 'onShowOrganization(objectidcalspan<%=benchindexcal%>,objectidcal<%=benchindexcal%>,scopetypecal<%=benchindexcal%>)'>
        </BUTTON><SPAN id = "objectidcalspan<%=benchindexcal%>">
        <%=scopename%></SPAN>
        <input class=inputstyle type = 'hidden' name = 'objectidcal<%=benchindexcal%>' value = '<%=objids%>'></TD>

    <TD>
        <select  name = 'timescopecal<%=benchindexcal%>_<%=rateindex%>'>
        <option value=1 <%if(timescope.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17138 , user.getLanguage())%></option>
        <option value=2 <%if(timescope.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19483 , user.getLanguage())%></option>
        <option value=3 <%if(timescope.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17495 , user.getLanguage())%></option>
        <option value=4 <%if(timescope.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19398 , user.getLanguage())%></option>
        </select>
     </TD>
    <TD>
        <BUTTON class=Browser type=button style="display:block" onClick="onShowCon(concalspan<%=benchindexcal%>_<%=rateindex%>,concal<%=benchindexcal%>_<%=rateindex%>,condspcal<%=benchindexcal%>_<%=rateindex%>,scopetypecal<%=benchindexcal%>)" ></BUTTON>
              <span id = 'concalspan<%=benchindexcal%>_<%=rateindex%>' name = 'concalspan<%=benchindexcal%>_<%=rateindex%>'><%=Util.null2String(RecordSet2.getString("conditiondsp"))%></span>
              <input type="hidden" name = 'concal<%=benchindexcal%>_<%=rateindex%>' value = "<%=Util.null2String(RecordSet2.getString("condition"))%>">
              <input type="hidden" name = 'condspcal<%=benchindexcal%>_<%=rateindex%>' value = "<%=Util.null2String(RecordSet2.getString("conditiondsp"))%>">
   </TD>
    <TD>
        <BUTTON class=Browser type=button style="display:block" onClick="onShowFormula(formulacalspan<%=benchindexcal%>_<%=rateindex%>,formulacal<%=benchindexcal%>_<%=rateindex%>,formuladspcal<%=benchindexcal%>_<%=rateindex%>,scopetypecal<%=benchindexcal%>)" ></BUTTON>
              <span id = 'formulacalspan<%=benchindexcal%>_<%=rateindex%>' name = 'formulacalspan<%=benchindexcal%>_<%=rateindex%>'><%=Util.null2String(RecordSet2.getString("formulardsp"))%></span>
              <input type="hidden" name = 'formulacal<%=benchindexcal%>_<%=rateindex%>' value = "<%=Util.null2String(RecordSet2.getString("formular"))%>">
              <input type="hidden" name = 'formuladspcal<%=benchindexcal%>_<%=rateindex%>' value = "<%=Util.null2String(RecordSet2.getString("formulardsp"))%>">
     </TD>
    </TR>
 <%
        while( RecordSet2.next() ) {
            timescope = "" + Util.getIntValue(RecordSet2.getString("timescope") , 0) ;
            condition = "" + Util.null2String(RecordSet2.getString("condition"))  ;
            formular = "" + Util.null2String(RecordSet2.getString("formular")) ;

            rateindex ++ ;
            /*String schedulediff=Util.match(condition,"@[^@]*@");
            while(!schedulediff.equals("")){

            String schedulediffid= schedulediff.substring(1,schedulediff.lastIndexOf("@"));
            String schedulediffname=Util.null2String((String)schedulediffmap.get(schedulediffid));
            condition=Util.replace(condition,"@[^@]*@",schedulediffname,1) ;
            schedulediff=Util.match(condition,"@[^@]*@");
            }
            String target=Util.match(condition,"\\$[^\\$]*\\$");
            while(!target.equals("")){
            String targetid= target.substring(1,target.lastIndexOf("$"));
            String targetid_1=targetid.substring(0,targetid.indexOf("("));

            String targetid_2=targetid.substring(targetid.indexOf("(")+1,targetid.indexOf(")"));
            if(targetid_2.equals("1"))
             targetid_2= SystemEnv.getHtmlLabelName(17138,user.getLanguage());
                else  if(targetid_2.equals("2"))
            targetid_2= SystemEnv.getHtmlLabelName(19483,user.getLanguage());
            else  if(targetid_2.equals("3"))
            targetid_2= SystemEnv.getHtmlLabelName(17495,user.getLanguage());
                else  if(targetid_2.equals("4"))
            targetid_2= SystemEnv.getHtmlLabelName(19398,user.getLanguage());
            String targetname=Util.null2String((String)targetmap.get(targetid_1))+"("+targetid_2+")";
            condition=Util.replace(condition,"\\$[^\\$]*\\$",targetname,1) ;
            target=Util.match(condition,"\\$[^\\$]*\\$");
            }
            //解析公式
            schedulediff=Util.match(formular,"@[^@]*@");
            while(!schedulediff.equals("")){

            String schedulediffid= schedulediff.substring(1,schedulediff.lastIndexOf("@"));
            String schedulediffname=Util.null2String((String)schedulediffmap.get(schedulediffid));
            formular=Util.replace(formular,"@[^@]*@",schedulediffname,1) ;
            schedulediff=Util.match(formular,"@[^@]*@");
            }

            target=Util.match(formular,"\\$[^\\$]*\\$");
            while(!target.equals("")){
            String targetid= target.substring(1,target.lastIndexOf("$"));
            String targetid_1=targetid.substring(0,targetid.indexOf("("));

            String targetid_2=targetid.substring(targetid.indexOf("(")+1,targetid.indexOf(")"));
            if(targetid_2.equals("1"))
             targetid_2= SystemEnv.getHtmlLabelName(17138,user.getLanguage());
                else  if(targetid_2.equals("2"))
            targetid_2= SystemEnv.getHtmlLabelName(19483,user.getLanguage());
            else  if(targetid_2.equals("3"))
            targetid_2= SystemEnv.getHtmlLabelName(17495,user.getLanguage());
                else  if(targetid_2.equals("4"))
            targetid_2= SystemEnv.getHtmlLabelName(19398,user.getLanguage());
            String targetname=Util.null2String((String)targetmap.get(targetid_1))+"("+targetid_2+")";
            formular=Util.replace(formular,"\\$[^\\$]*\\$",targetname,1) ;
            target=Util.match(formular,"\\$[^\\$]*\\$");
            }
            //解析工资项目
            //System.out.println("formular"+formular);
            String item = Util.match(formular, "#[^#]*#");
            while (!item.equals("")) {
                String theitemid = item.substring(1, item.lastIndexOf("#"));
                String theitemcode="";
                if(theitemid.indexOf("_")>0){
                theitemcode=SalaryComInfo.getSalaryCode(theitemid.substring(0,theitemid.indexOf("_")))+theitemid.substring(theitemid.indexOf("_"));
                }else
                theitemcode=SalaryComInfo.getSalaryCode(theitemid);
                //System.out.println("theitemcode"+theitemcode);
                formular = Util.replace(formular, "#[^#]*#", theitemcode, 1);
                item = Util.match(formular, "#[^#]*#");
            }
            //System.out.println("formular"+formular);
            formular=Util.replace(formular,"\\^",SystemEnv.getHtmlLabelName(19378,user.getLanguage()),0);*/


%>
    <TR class=DataDark>
    <TD>&nbsp;</TD>
    <TD>
        <select  name = 'timescopecal<%=benchindexcal%>_<%=rateindex%>'>
        <option value=1 <%if(timescope.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17138 , user.getLanguage())%></option>
        <option value=2 <%if(timescope.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19483 , user.getLanguage())%></option>
        <option value=3 <%if(timescope.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17495 , user.getLanguage())%></option>
        <option value=4 <%if(timescope.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19398 , user.getLanguage())%></option>
        </select>
    </TD>
    <TD>
        <BUTTON class=Browser type=button style="display:''" onClick="onShowCon(concalspan<%=benchindexcal%>_<%=rateindex%>,concal<%=benchindexcal%>_<%=rateindex%>,condspcal<%=benchindexcal%>_<%=rateindex%>,scopetypecal<%=benchindexcal%>)" ></BUTTON>
              <span id = 'concalspan<%=benchindexcal%>_<%=rateindex%>' name = 'concalspan<%=benchindexcal%>_<%=rateindex%>'><%=Util.null2String(RecordSet2.getString("conditiondsp"))%></span>
              <input type="hidden" name = 'concal<%=benchindexcal%>_<%=rateindex%>' value = "<%=Util.null2String(RecordSet2.getString("condition"))%>">
              <input type="hidden" name = 'condspcal<%=benchindexcal%>_<%=rateindex%>' value = "<%=Util.null2String(RecordSet2.getString("conditiondsp"))%>">
   </TD>
    <TD>
        <BUTTON class=Browser type=button style="display:''" onClick="onShowFormula(formulacalspan<%=benchindexcal%>_<%=rateindex%>,formulacal<%=benchindexcal%>_<%=rateindex%>,formuladspcal<%=benchindexcal%>_<%=rateindex%>,scopetypecal<%=benchindexcal%>)" ></BUTTON>
              <span id = 'formulacalspan<%=benchindexcal%>_<%=rateindex%>' name = 'formulacalspan<%=benchindexcal%>_<%=rateindex%>'><%=Util.null2String(RecordSet2.getString("formulardsp"))%></span>
              <input type="hidden" name = 'formulacal<%=benchindexcal%>_<%=rateindex%>' value = "<%=Util.null2String(RecordSet2.getString("formular"))%>">
              <input type="hidden" name = 'formuladspcal<%=benchindexcal%>_<%=rateindex%>' value = "<%=Util.null2String(RecordSet2.getString("formulardsp"))%>">
   </TD>
    </TR>
 <%}

      rateindex ++ ;
        %>
    <script language = javascript>
        caldrowindex[<%=benchindexcal%>] = <%=rateindex%> ;
    </script>
    </TABLE>
    <TABLE width = 100%>
    <TR>
    <TD style="text-align: right;">
    	<BUTTON class = addbtn type=button accessKey = 1 onClick = "addRowCalD('<%=benchindexcal%>')" title="<%=SystemEnv.getHtmlLabelName(15836 , user.getLanguage())%>"></BUTTON>
    </TD></TR>
    </table>
    </TD></TR>
<% } %>
    </TBODY>
    </TABLE>
		</wea:item>
	</wea:group>
</wea:layout>
    </div>

<div id = tb_wel <% if(!itemtype.equals("9")) {%>style = "display:none"<%}%>>
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("18125" , user.getLanguage())%>' attributes="{'groupOperDisplay':'false'}">
		<wea:item type="groupHead" >
			<input type="button" class =addbtn type=button accessKey = I onClick = "addRowWel();" title="<%=SystemEnv.getHtmlLabelName(551,user.getLanguage())%>">
	    <input type="button" class =delbtn type=button accessKey = D onClick = "dodelete_Wel();" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>">
		</wea:item>
		<wea:item attributes="{'isTableList':'true'}">
<TABLE class=ListStyle cellspacing=1  id = "oTable_wel" cols = 2>
  <COLGROUP>
  <COL width="3%">
  <COL width="97%">
  <TBODY>
<%
    benchid = "" ;
    String scopetypewel = "" ;

    RecordSet.executeSql(" select * from HrmSalaryCalBench where itemid = " + itemid + " order by id " ) ;
    while( RecordSet.next() ) {
        benchid = "" + Util.getIntValue(RecordSet.getString("id") , 0) ;
        scopetype = "" + Util.getIntValue(RecordSet.getString("scopetype") , 0) ;


        benchindexwel++ ;

        String timescope = "" ;
        String condition = "" ;
        String formular = "" ;

        rateindex = -1 ;

        RecordSet2.executeSql(" select * from HrmSalaryCalScope where benchid = " + benchid ) ;

        String scopename="";
        String objids="";
        while(RecordSet2.next()){

           if(scopetype.equals("2")){
             String objid=Util.null2String(RecordSet2.getString("objectid"));
                if(scopename.equals("")){
                   scopename+=SubCompanyComInfo.getSubCompanyname(objid);
                   objids+=objid;
                }else{
                   scopename+=","+SubCompanyComInfo.getSubCompanyname(objid) ;
                   objids+= ","+objid ;
                }
             }else if(scopetype.equals("3")){
             String objid=Util.null2String(RecordSet2.getString("objectid"));
                if(scopename.equals("")){
                   scopename+=DepartmentComInfo.getDepartmentname(objid);
                   objids+=objid;
                }else  {
                   scopename+=","+DepartmentComInfo.getDepartmentname(objid) ;
                   objids+= ","+objid ;
                }
             }else if(scopetype.equals("4")){
             String objid=Util.null2String(RecordSet2.getString("objectid"));
                if(scopename.equals("")){
                   scopename+=ResourceComInfo.getLastname(objid);
                   objids+=objid;
                }else{
                   scopename+=","+ResourceComInfo.getLastname(objid) ;
                   objids+= ","+objid ;
                }
             }
        }
        RecordSet2.executeSql(" select * from HrmSalaryCalRate where benchid = " + benchid  ) ;
        if( RecordSet2.next() ) {
            timescope = "" + Util.getIntValue(RecordSet2.getString("timescope") , 0) ;
            condition = "" + Util.null2String(RecordSet2.getString("condition"))  ;
            formular = "" + Util.null2String(RecordSet2.getString("formular")) ;


            rateindex ++ ;
           /* String schedulediff=Util.match(condition,"@[^@]*@");
            while(!schedulediff.equals("")){

            String schedulediffid= schedulediff.substring(1,schedulediff.lastIndexOf("@"));
            String schedulediffname=Util.null2String((String)schedulediffmap.get(schedulediffid));
            condition=Util.replace(condition,"@[^@]*@",schedulediffname,1) ;
            schedulediff=Util.match(condition,"@[^@]*@");
            }
            String target=Util.match(condition,"\\$[^\\$]*\\$");
            while(!target.equals("")){
            String targetid= target.substring(1,target.lastIndexOf("$"));
            String targetid_1=targetid.substring(0,targetid.indexOf("("));

            String targetid_2=targetid.substring(targetid.indexOf("(")+1,targetid.indexOf(")"));
            if(targetid_2.equals("1"))
             targetid_2= SystemEnv.getHtmlLabelName(17138,user.getLanguage());
                else  if(targetid_2.equals("2"))
            targetid_2= SystemEnv.getHtmlLabelName(19483,user.getLanguage());
            else  if(targetid_2.equals("3"))
            targetid_2= SystemEnv.getHtmlLabelName(17495,user.getLanguage());
                else  if(targetid_2.equals("4"))
            targetid_2= SystemEnv.getHtmlLabelName(19398,user.getLanguage());
            String targetname=Util.null2String((String)targetmap.get(targetid_1))+"("+targetid_2+")";
            condition=Util.replace(condition,"\\$[^\\$]*\\$",targetname,1) ;
            target=Util.match(condition,"\\$[^\\$]*\\$");
            }
            //解析公式
            schedulediff=Util.match(formular,"@[^@]*@");
            while(!schedulediff.equals("")){

            String schedulediffid= schedulediff.substring(1,schedulediff.lastIndexOf("@"));
            String schedulediffname=Util.null2String((String)schedulediffmap.get(schedulediffid));
            formular=Util.replace(formular,"@[^@]*@",schedulediffname,1) ;
            schedulediff=Util.match(formular,"@[^@]*@");
            }

            target=Util.match(formular,"\\$[^\\$]*\\$");
            while(!target.equals("")){
            String targetid= target.substring(1,target.lastIndexOf("$"));
            String targetid_1=targetid.substring(0,targetid.indexOf("("));

            String targetid_2=targetid.substring(targetid.indexOf("(")+1,targetid.indexOf(")"));
            if(targetid_2.equals("1"))
             targetid_2= SystemEnv.getHtmlLabelName(17138,user.getLanguage());
                else  if(targetid_2.equals("2"))
            targetid_2= SystemEnv.getHtmlLabelName(19483,user.getLanguage());
            else  if(targetid_2.equals("3"))
            targetid_2= SystemEnv.getHtmlLabelName(17495,user.getLanguage());
                else  if(targetid_2.equals("4"))
            targetid_2= SystemEnv.getHtmlLabelName(19398,user.getLanguage());
            String targetname=Util.null2String((String)targetmap.get(targetid_1))+"("+targetid_2+")";
            formular=Util.replace(formular,"\\$[^\\$]*\\$",targetname,1) ;
            target=Util.match(formular,"\\$[^\\$]*\\$");
            }
            //解析工资项目
            //System.out.println("formular"+formular);
            String item = Util.match(formular, "#[^#]*#");
            while (!item.equals("")) {
                String theitemid = item.substring(1, item.lastIndexOf("#"));
                String theitemcode="";
                if(theitemid.indexOf("_")>0){
                theitemcode=SalaryComInfo.getSalaryCode(theitemid.substring(0,theitemid.indexOf("_")))+theitemid.substring(theitemid.indexOf("_"));
                }else
                theitemcode=SalaryComInfo.getSalaryCode(theitemid);
                //System.out.println("theitemcode"+theitemcode);
                formular = Util.replace(formular, "#[^#]*#", theitemcode, 1);
                item = Util.match(formular, "#[^#]*#");
            }
            //System.out.println("formular"+formular);
            formular=Util.replace(formular,"\\^",SystemEnv.getHtmlLabelName(19378,user.getLanguage()),0);*/
        }else
         rateindex++;

   %>
  <TR><TD><input class=inputstyle type = 'checkbox' name = 'check_wel' value = 1></TD>
  <TD>
  <TABLE class=ListStyle cellspacing=1  id = 'oTable_weldetail<%=benchindexwel%>'name = 'oTable_weldetail<%=benchindexwel%>' cols = 6>
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
        <select name=scopetypewel<%=benchindexwel%> onchange="changescopetype(this);">
        <option  value="0" <%if(scopetype.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332 , user.getLanguage())%></option>
        <option  value="2" <%if(scopetype.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%></option>
        <option  value="3" <%if(scopetype.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18939 , user.getLanguage())%></option>
        <option  value="4" <%if(scopetype.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(179 , user.getLanguage())%></option>
        </select>
        <BUTTON class = Browser type=button <%if(scopetype.equals("0")){%> style="display:none"<%}%> onclick = 'onShowOrganization(objectidwelspan<%=benchindexwel%>,objectidwel<%=benchindexwel%>,scopetypewel<%=benchindexwel%>)'>
        </BUTTON><SPAN id = "objectidwelspan<%=benchindexwel%>">
        <%=scopename%></SPAN>
        <input class=inputstyle type = 'hidden' name = 'objectidwel<%=benchindexwel%>' value = '<%=objids%>'></TD>

    <TD>
        <select  name = 'timescopewel<%=benchindexwel%>_<%=rateindex%>'>
        <option value=1 <%if(timescope.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17138 , user.getLanguage())%></option>
        <option value=2 <%if(timescope.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19483 , user.getLanguage())%></option>
        <option value=3 <%if(timescope.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17495 , user.getLanguage())%></option>
        <option value=4 <%if(timescope.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19398 , user.getLanguage())%></option>
        </select>
     </TD>
    <TD>
        <BUTTON class=Browser type=button style="display:block" onClick="onShowCon(conwelspan<%=benchindexwel%>_<%=rateindex%>,conwel<%=benchindexwel%>_<%=rateindex%>,condspwel<%=benchindexwel%>_<%=rateindex%>,scopetypewel<%=benchindexwel%>)" ></BUTTON>
              <span id = 'conwelspan<%=benchindexwel%>_<%=rateindex%>' name = 'conwelspan<%=benchindexwel%>_<%=rateindex%>'><%=Util.null2String(RecordSet2.getString("conditiondsp"))%></span>
              <input type="hidden" name = 'conwel<%=benchindexwel%>_<%=rateindex%>' value = "<%=Util.null2String(RecordSet2.getString("condition"))%>">
              <input type="hidden" name = 'condspwel<%=benchindexwel%>_<%=rateindex%>' value = "<%=Util.null2String(RecordSet2.getString("conditiondsp"))%>">
   </TD>
    <TD>
        <BUTTON class=Browser type=button style="display:block" onClick="onShowFormula(formulawelspan<%=benchindexwel%>_<%=rateindex%>,formulawel<%=benchindexwel%>_<%=rateindex%>,formuladspwel<%=benchindexwel%>_<%=rateindex%>,scopetypewel<%=benchindexwel%>)" ></BUTTON>
              <span id = 'formulawelspan<%=benchindexwel%>_<%=rateindex%>' name = 'formulawelspan<%=benchindexwel%>_<%=rateindex%>'><%=Util.null2String(RecordSet2.getString("formulardsp"))%></span>
              <input type="hidden" name = 'formulawel<%=benchindexwel%>_<%=rateindex%>' value = "<%=Util.null2String(RecordSet2.getString("formular"))%>">
               <input type="hidden" name = 'formuladspwel<%=benchindexwel%>_<%=rateindex%>' value = "<%=Util.null2String(RecordSet2.getString("formulardsp"))%>">
     </TD>
    </TR>
 <%
        while( RecordSet2.next() ) {
            timescope = "" + Util.getIntValue(RecordSet2.getString("timescope") , 0) ;
            condition = "" + Util.null2String(RecordSet2.getString("condition"))  ;
            formular = "" + Util.null2String(RecordSet2.getString("formular")) ;

            rateindex ++ ;
            /*String schedulediff=Util.match(condition,"@[^@]*@");
            while(!schedulediff.equals("")){

            String schedulediffid= schedulediff.substring(1,schedulediff.lastIndexOf("@"));
            String schedulediffname=Util.null2String((String)schedulediffmap.get(schedulediffid));
            condition=Util.replace(condition,"@[^@]*@",schedulediffname,1) ;
            schedulediff=Util.match(condition,"@[^@]*@");
            }
            String target=Util.match(condition,"\\$[^\\$]*\\$");
            while(!target.equals("")){
            String targetid= target.substring(1,target.lastIndexOf("$"));
            String targetid_1=targetid.substring(0,targetid.indexOf("("));

            String targetid_2=targetid.substring(targetid.indexOf("(")+1,targetid.indexOf(")"));
            if(targetid_2.equals("1"))
             targetid_2= SystemEnv.getHtmlLabelName(17138,user.getLanguage());
                else  if(targetid_2.equals("2"))
            targetid_2= SystemEnv.getHtmlLabelName(19483,user.getLanguage());
            else  if(targetid_2.equals("3"))
            targetid_2= SystemEnv.getHtmlLabelName(17495,user.getLanguage());
                else  if(targetid_2.equals("4"))
            targetid_2= SystemEnv.getHtmlLabelName(19398,user.getLanguage());
            String targetname=Util.null2String((String)targetmap.get(targetid_1))+"("+targetid_2+")";
            condition=Util.replace(condition,"\\$[^\\$]*\\$",targetname,1) ;
            target=Util.match(condition,"\\$[^\\$]*\\$");
            }
            //解析公式
            schedulediff=Util.match(formular,"@[^@]*@");
            while(!schedulediff.equals("")){

            String schedulediffid= schedulediff.substring(1,schedulediff.lastIndexOf("@"));
            String schedulediffname=Util.null2String((String)schedulediffmap.get(schedulediffid));
            formular=Util.replace(formular,"@[^@]*@",schedulediffname,1) ;
            schedulediff=Util.match(formular,"@[^@]*@");
            }

            target=Util.match(formular,"\\$[^\\$]*\\$");
            while(!target.equals("")){
            String targetid= target.substring(1,target.lastIndexOf("$"));
            String targetid_1=targetid.substring(0,targetid.indexOf("("));

            String targetid_2=targetid.substring(targetid.indexOf("(")+1,targetid.indexOf(")"));
            if(targetid_2.equals("1"))
             targetid_2= SystemEnv.getHtmlLabelName(17138,user.getLanguage());
                else  if(targetid_2.equals("2"))
            targetid_2= SystemEnv.getHtmlLabelName(19483,user.getLanguage());
            else  if(targetid_2.equals("3"))
            targetid_2= SystemEnv.getHtmlLabelName(17495,user.getLanguage());
                else  if(targetid_2.equals("4"))
            targetid_2= SystemEnv.getHtmlLabelName(19398,user.getLanguage());
            String targetname=Util.null2String((String)targetmap.get(targetid_1))+"("+targetid_2+")";
            formular=Util.replace(formular,"\\$[^\\$]*\\$",targetname,1) ;
            target=Util.match(formular,"\\$[^\\$]*\\$");
            }
            //解析工资项目
            //System.out.println("formular"+formular);
            String item = Util.match(formular, "#[^#]*#");
            while (!item.equals("")) {
                String theitemid = item.substring(1, item.lastIndexOf("#"));
                String theitemcode="";
                if(theitemid.indexOf("_")>0){
                theitemcode=SalaryComInfo.getSalaryCode(theitemid.substring(0,theitemid.indexOf("_")))+theitemid.substring(theitemid.indexOf("_"));
                }else
                theitemcode=SalaryComInfo.getSalaryCode(theitemid);
                //System.out.println("theitemcode"+theitemcode);
                formular = Util.replace(formular, "#[^#]*#", theitemcode, 1);
                item = Util.match(formular, "#[^#]*#");
            }
            //System.out.println("formular"+formular);
            formular=Util.replace(formular,"\\^",SystemEnv.getHtmlLabelName(19378,user.getLanguage()),0);*/


%>
    <TR class=DataDark>
    <TD>&nbsp;</TD>
    <TD>
        <select  name = 'timescopewel<%=benchindexwel%>_<%=rateindex%>'>
        <option value=1 <%if(timescope.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17138 , user.getLanguage())%></option>
        <option value=2 <%if(timescope.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19483 , user.getLanguage())%></option>
        <option value=3 <%if(timescope.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17495 , user.getLanguage())%></option>
        <option value=4 <%if(timescope.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19398 , user.getLanguage())%></option>
        </select>
    </TD>
    <TD>
        <BUTTON class=Browser type=button style="display:''" onClick="onShowCon(conwelspan<%=benchindexwel%>_<%=rateindex%>,conwel<%=benchindexwel%>_<%=rateindex%>,condspwel<%=benchindexwel%>_<%=rateindex%>,scopetypewel<%=benchindexwel%>)" ></BUTTON>
              <span id = 'conwelspan<%=benchindexwel%>_<%=rateindex%>' name = 'conwelspan<%=benchindexwel%>_<%=rateindex%>'><%=Util.null2String(RecordSet2.getString("conditiondsp"))%></span>
              <input type="hidden" name = 'conwel<%=benchindexwel%>_<%=rateindex%>' value = "<%=Util.null2String(RecordSet2.getString("condition"))%>">
              <input type="hidden" name = 'condspwel<%=benchindexwel%>_<%=rateindex%>' value = "<%=Util.null2String(RecordSet2.getString("conditiondsp"))%>">
   </TD>
    <TD>
        <BUTTON class=Browser type=button style="display:''" onClick="onShowFormula(formulawelspan<%=benchindexwel%>_<%=rateindex%>,formulawel<%=benchindexwel%>_<%=rateindex%>,formuladspwel<%=benchindexwel%>_<%=rateindex%>,scopetypewel<%=benchindexwel%>)" ></BUTTON>
              <span id = 'formulawelspan<%=benchindexwel%>_<%=rateindex%>' name = 'formulawelspan<%=benchindexwel%>_<%=rateindex%>'><%=Util.null2String(RecordSet2.getString("formulardsp"))%></span>
              <input type="hidden" name = 'formulawel<%=benchindexwel%>_<%=rateindex%>' value = "<%=Util.null2String(RecordSet2.getString("formular"))%>">
              <input type="hidden" name = 'formuladspwel<%=benchindexwel%>_<%=rateindex%>' value = "<%=Util.null2String(RecordSet2.getString("formulardsp"))%>">
     </TD>
    </TR>
 <% }
        rateindex ++ ;

        %>
    <script language = javascript>
        weldrowindex[<%=benchindexwel%>] = <%=rateindex%> ;
    </script>
    </TABLE>
    <TABLE width = 100%>
    <TR>
    <TD style="text-align: right;">
    <BUTTON class = addbtn type=button accessKey = 1 onClick = "addRowWelD('<%=benchindexwel%>')" title="<%=SystemEnv.getHtmlLabelName(15836 , user.getLanguage())%>"></BUTTON>
    </TD></TR>
    </table>
    </TD></TR>
<% } %>
    </TBODY>
    </TABLE>
    </wea:item>
    </wea:group>
    </wea:layout>
    </div>

<div id = tb_wel1 <% if(!itemtype.equals("9")||(itemtype.equals("9")&&calMode.equals("2"))) {%>style = "display:none"<%}%>>

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
    <TR >
    <TD><input class=inputstyle  name = 'personalPercent' value='<%=personalPercent%>'>%</TD>
    <TD><input class=inputstyle  name = 'companyPercent' value='<%=companyPercent%>'>%</TD>
    </TR>
    </TABLE> 
    </TD></TR>
  </TBODY>
</TABLE>
</div>
<div id = tb_kqkk <% if(!itemtype.equals("5")) {%>style = "display:none"<%}%>>
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(16668 , user.getLanguage())%>' attributes="{'groupDisplay':'none'}">
		<wea:item type="groupHead" >
			<input type="button" class =addbtn type=button accessKey = I onClick = "addRowKq_Dec();" title="<%=SystemEnv.getHtmlLabelName(551 , user.getLanguage())%>">
	    <input type="button" class =delbtn type=button accessKey = D onClick = "dodelete_Kq_Dec();" title="<%=SystemEnv.getHtmlLabelName(91 , user.getLanguage())%>">
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

  <%
    String diffidDec = "" ;

    RecordSet.executeSql(" select * from HrmSalarySchedule where itemid = " + itemid + " order by id " ) ;

    while( RecordSet.next() ) {
        diffidDec = "" + Util.getIntValue(RecordSet.getString("diffid") , 0) ;

        if( diffidDec.equals("0") ) diffidDec = "" ;
        diffDecindex ++ ;
%>
  <TR>
        <TD><input class=inputstyle type = 'checkbox' name = 'check_kqkk' value = 1></TD>
        <TD><BUTTON class = Browser type=button onclick = 'onShowScheduleDec(diffnamespan01<%=diffDecindex%>,diffname01<%=diffDecindex%>)'>
        </BUTTON>
        <SPAN id = "diffnamespan01<%=diffDecindex%>"><%=Util.toScreen(HrmScheduleDiffComInfo.getDiffname(diffidDec) , user.getLanguage())%></SPAN>
        <input class=inputstyle type='hidden' name = 'diffname01<%=diffDecindex%>' value='<%=diffidDec%>'>
        </TD>
       </TR>
<%  } %>
  </tbody>
</table>
</wea:item>
</wea:group>
</wea:layout>
</div>

<div id = tb_kqjx <% if(!itemtype.equals("6")) {%>style = "display:none"<%}%>>
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(16669 , user.getLanguage())%>' attributes="{'groupDisplay':'none'}">
		<wea:item type="groupHead" >
			<input type="button" class =addbtn type=button accessKey = I onClick = "addRowKq_Add();" title="<%=SystemEnv.getHtmlLabelName(551 , user.getLanguage())%>">
	    <input type="button" class =delbtn type=button accessKey = D onClick = "dodelete_Kq_Add();" title="<%=SystemEnv.getHtmlLabelName(91 , user.getLanguage())%>">
		</wea:item>
		<wea:item attributes="{'isTableList':'true'}">
<TABLE class=ListStyle cellspacing=1  id = "oTable_kqjx" cols = 2>
  <COLGROUP>
  <COL width = "5%">
  <COL width = "95%">
  <TBODY>
  <TR class = HeaderForXtalbe>
    <TH>&nbsp;</TH>
    <TH><%=SystemEnv.getHtmlLabelName(16672 , user.getLanguage())%></TH>
    </TR>

  <%
    String diffidAdd = "" ;

    RecordSet.executeSql(" select * from HrmSalarySchedule where  itemid = " + itemid + " order by id " ) ;
    while( RecordSet.next() ) {
        diffidAdd = "" + Util.getIntValue(RecordSet.getString("diffid") , 0) ;

        if( diffidAdd.equals("0") ) diffidAdd = "" ;
        diffAddindex ++ ;
  %>
  <TR>
    <TD><input class=inputstyle type = 'checkbox' name = 'check_kqjx' value = 1></TD>
    <TD><BUTTON class = Browser type=button onclick = 'onShowScheduleAdd(diffnamespan0<%=diffAddindex%>,diffname0<%=diffAddindex%>)'></BUTTON>
    <SPAN id = "diffnamespan0<%=diffAddindex%>"><%=Util.toScreen(HrmScheduleDiffComInfo.getDiffname(diffidAdd) , user.getLanguage())%></SPAN>
     <input class=inputstyle type='hidden' name ='diffname0<%=diffAddindex%>' value='<%=diffidAdd%>'>
    </TD>
    </TR>
<% } %>
  </tbody>
</table>
</wea:item>
</wea:group>
</wea:layout>
</div>



<div id = tb_cqjt <% if(!itemtype.equals("7")) {%>style = "display:none"<%}%>>
<br>
<table  class = ListStyle>
  <COLGROUP>
  <COL width = "15%">
  <COL width = "85%">
  <tbody>
  <TR class = Section>
    <TH><%=SystemEnv.getHtmlLabelName(16740,user.getLanguage())%></TH>
    <TH style = "TEXT-ALIGN: right"></TH>
  </TR>
  <TR class = Seperator><TD class = Sep1 colSpan = 2></TD></TR>
  <TR class = HeaderForXtalbe>
    <TH><%=SystemEnv.getHtmlLabelName(16741,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(534,user.getLanguage())%></TH>
  </TR>
  <%
    //  获得所有出勤种类关联的金额
    ArrayList shiftids = new ArrayList() ;
    ArrayList shiftpays = new ArrayList() ;

    RecordSet.executeProc("HrmSalaryShiftPay_SByItemid" , itemid) ;
    while( RecordSet.next() ) {
        String shiftpay = Util.null2String(RecordSet.getString("shiftpay")) ;
        if( Util.getDoubleValue(shiftpay,0) == 0 ) continue ;
        shiftids.add(Util.null2String(RecordSet.getString("shiftid"))) ;
        shiftpays.add(Util.null2String(RecordSet.getString("shiftpay"))) ;
    }
    String shiftpay = "" ;
    int shiftpayindex = shiftids.indexOf("0") ;
    if( shiftpayindex != -1 ) shiftpay = (String) shiftpays.get( shiftpayindex ) ;
  %>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(16254,user.getLanguage())%></TD>
    <TD><input type = 'text' name = 'shift0' value = '<%=shiftpay%>' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)'></TD>
  </TR>
  <%
     RecordSet.executeProc("HrmArrangeShift_SelectAll" , "0") ;
	 while(RecordSet.next()){
		String shiftid = Util.null2String( RecordSet.getString("id") ) ;
        String shiftname = Util.null2String( RecordSet.getString("shiftname") ) ;
        shiftpay = "" ;
        shiftpayindex = shiftids.indexOf(shiftid) ;
        if( shiftpayindex != -1 ) shiftpay = (String) shiftpays.get( shiftpayindex ) ;
  %>
  <TR>
    <TD><%=shiftname%></TD>
    <TD><input type = 'text' name = 'shift<%=shiftid%>' value = '<%=shiftpay%>' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)'></TD>
  </TR>
  <% } %>
  </tbody>
</table>
</div>



<%
jobindex ++ ;
ratecityindex ++ ;
benchindex ++ ;
benchindexcal ++ ;
benchindexwel ++ ;
diffDecindex++ ;
diffAddindex++ ;
%>
<input class=inputstyle type = "hidden" name = "totalje" value = <%=jobindex%>>
<input class=inputstyle type = "hidden" name = "totalfl" value = <%=ratecityindex%>>
<input class=inputstyle type = "hidden" name = "totalss" value = <%=benchindex%>>
<input class=inputstyle type = "hidden" name = "totalcal" value = <%=benchindexcal%>>
<input class=inputstyle type = "hidden" name = "totalwel" value = <%=benchindexwel%>>
<input class=inputstyle type = "hidden" name = "totalssd">
<input class=inputstyle type = "hidden" name = "totalcald">
<input class=inputstyle type = "hidden" name = "totalweld">
<input class=inputstyle type = "hidden" name = "totalkqkk" value =<%=diffDecindex%>>
<input class=inputstyle type = "hidden" name = "totalkqjx" value =<%=diffAddindex%>>
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
<script language = vbscript>
sub onShowJobID1(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp")
	if NOT isempty(id) then
		if id(0)<> 0 then
            tdname.innerHtml = id(1)
            inputename.value = id(0)
		else
            tdname.innerHtml = ""
            inputename.value = ""
		end if
	end if
end sub




sub onShowScheduleDec(tdname,inputename)
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/schedule/HrmScheduleDiffBrowser.jsp?sqlwhere=where difftype='1'")
	if NOT isempty(id) then
		if id(0)<> 0 then
            tdname.innerHtml = id(1)
            inputename.value = id(0)
		else
          tdname.innerHtml = ""
          inputename.value = ""
		end if
	end if
end sub

sub onShowScheduleAdd(tdname,inputename)
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/schedule/HrmScheduleDiffBrowser.jsp?sqlwhere=where difftype='0'")
	if NOT isempty(id) then
		if id(0)<> 0 then
          tdname.innerHtml = id(1)
          inputename.value = id(0)
		else
           tdname.innerHtml = ""
           inputename.value = ""
		end if
	end if
end sub

sub onShowJobActivity1(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobactivities/JobActivitiesBrowser.jsp")
	if Not isempty(id) then
	if id(0)<> 0 then
	tdname.innerHtml = id(1)
	inputename.value = id(0)
	else
	tdname.innerHtml = ""
	inputename.value=""
	end if
	end if
end sub

</script>
<script language="JavaScript" src="/js/addRowBg_wev8.js" >
</script>
<script language = javascript>
var jerowindex = <%=jobindex%> ;
var flrowindex = <%=ratecityindex%> ;
var ssrowindex = <%=benchindex%> ;
var calrowindex = <%=benchindexcal%> ;
var welrowindex = <%=benchindexwel%> ;
var kqkkrowindex =<%=diffDecindex%> ; //考勤扣款index
var kqjxrowindex =<%=diffAddindex%> ;//考勤加薪index
var rowColor="" ;
function doSubmit(obj) {
	if(!validateItemCode()){
    	return;
    }
    itemtype = document.frmMain.itemtype.value ;
    isshow = window.document.frmMain.isshow.value ;
    checkitemstr = "" ;
    if( itemtype == 1) checkitemstr = "itemname,itemcode,isshow,history" ;
    else if( itemtype == 2) checkitemstr = "itemname,itemcode,isshow,history,personwelfarerate,companywelfarerate" ;
    else if( itemtype == 3) checkitemstr = "itemname,itemcode,isshow,history,taxrelateitem" ;
    else if( itemtype == 4) checkitemstr = "itemname,itemcode,isshow,history" ;
    else if(itemtype == 5)  checkitemstr = "itemname,itemcode,isshow,history" ;
    else if(itemtype == 6)  checkitemstr = "itemname,itemcode,isshow,history" ;
    else if(itemtype == 9)  checkitemstr = "itemname,itemcode,isshow,history" ;
    if( isshow == 1 ) checkitemstr += ",showorder" ;

    if( check_form(document.frmMain, checkitemstr) ) {
        if( itemtype == 3) {                                // 税收
            totalssd = "" ;
            for( i= 0 ; i < ssrowindex ; i++ ) {
                temptotalss = ssdrowindex[i] ;
                if( totalssd == "" ) totalssd = temptotalss ;
                else totalssd += "," + temptotalss ;
            }
            document.frmMain.totalssd.value = totalssd ;
        }
        if( itemtype == 4) {                                // 税收
            totalcald = "" ;
            for( i= 0 ; i < calrowindex ; i++ ) {
                temptotalcal = caldrowindex[i] ;
                if( totalcald == "" ) totalcald = temptotalcal ;
                else totalcald += "," + temptotalcal ;
            }
            document.frmMain.totalcald.value = totalcald ;
        }
        if( itemtype == 9) {                                // 税收
            totalweld = "" ;
            for( i= 0 ; i < welrowindex ; i++ ) {
                temptotalwel = weldrowindex[i] ;
                if( totalweld == "" ) totalweld = temptotalwel ;
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

function changeScope(){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(19545 , user.getLanguage())%>",function(){
		document.frmMain.action="HrmSalaryItemEdit.jsp"
   	document.frmMain.submit() ;
	},function(){
	  var applyscope_original = jQuery(obj).parent().find("input[name=original]").val();
   	var calMode_original = jQuery(obj).parent().find("input[name=original]").val();
  	document.frmMain.applyscope.selectedIndex=applyscope_original;
    document.frmMain.calMode.selectedIndex =calMode_original-1;
    return false;
	})
}
function addRowJe() {
	//ncol = jQuery(oTable_je).find("tr:first")[0].cells.length ;
	ncol = 6;
	oRow = oTable_je.insertRow(oTable_je.rows.length) ;
		oRow.className="DataLight";
    rowColor = getRowBg();
	for( j=0 ; j<ncol ; j++ ) {
		oCell = oRow.insertCell(j) ;
        oCell.style.height = 24 ;
		//oCell.style.background= rowColor;
		switch(j) {
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
				var sHtml = "<input class=inputstyle type='text' name='joblevelfrom" + jerowindex + "' style='width:100%' onKeyPress='ItemCount_KeyPress()' onBlur='checkcount1(this)'>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
			case 4:
				var oDiv = document.createElement("div") ;
				var sHtml = "<input class=inputstyle type='text' name='joblevelto" + jerowindex + "' style='width:100%' onKeyPress='ItemCount_KeyPress()' onBlur='checkcount1(this)'>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
                break ;
            case 5:
				var oDiv = document.createElement("div") ;
				var sHtml = "<input class=inputstyle type='text' name='amount" + jerowindex + "' style='width:100%' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)'>" ;
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

function addRowFl() {
	//ncol = jQuery(oTable_fl).find("tr:first")[0].cells.length ;
	ncol=4;
	oRow = oTable_fl.insertRow(-1) ;
		oRow.className="DataLight";
    //rowColor = getRowBg();
	for( j = 0 ; j < ncol ; j++ ) {
		oCell = oRow.insertCell(-1) ;
        oCell.style.height = 24 ;
		//oCell.style.background= rowColor;
		switch(j) {
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
				var sHtml = "<INPUT class=inputstyle maxLength=10 size=15 name='personwelfarerate" + flrowindex + "' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)'>%" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
			case 3:
				var oDiv = document.createElement("div") ;
				var sHtml = "<INPUT class=inputstyle maxLength=10 size=15 name='companywelfarerate" + flrowindex + "' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)'>%" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
		}
	}
	flrowindex = flrowindex * 1 + 1 ;
	frmMain.totalfl.value = flrowindex ;
	jQuery(oRow).find("select").selectbox();
	jQuery("body").jNice();
}

function addRowSs() {
	//ncol = jQuery(oTable_ss).find("colgroup:first").find("col").length;
	ncol =2;
	oRow = oTable_ss.insertRow(oTable_ss.rows.length) ;
    rowColor = getRowBg();
    ssdrowindex[ssrowindex] = 1 ;

	for( j = 0; j < ncol ; j++ ) {
		oCell = oRow.insertCell(j) ;
        oCell.style.height = 24 ;
		oCell.style.background= rowColor;
		switch(j) {
			case 0:
				var oDiv = document.createElement("div") ;
				var sHtml = "<input class=inputstyle type='checkbox' name='check_ss' value=1>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
			case 1:
				var oDiv = document.createElement("div") ;
				var sHtml = "<TABLE class=ListStyle cellspacing=1  id = 'oTable_ssdetail" + ssrowindex + "' " + " name = 'oTable_ssdetail" + ssrowindex + "' cols = 7>"
                + "<COLGROUP>"
                + "<COL width = '15%'>"
                + "<COL width = '18%'>"
                + "<COL width = '7%'>"
                + "<COL width = '18%'>"
                + "<COL width = '18%'>"
                + "<COL width = '10%'>"
                + "<COL width = '15%'>"
                + "<TBODY>"
                + "<TR class = HeaderForXtalbe>" 
                + "<TH><%=SystemEnv.getHtmlLabelName(19467 , user.getLanguage())%></TH>"
                + "<TH><%=SystemEnv.getHtmlLabelName(15835 , user.getLanguage())%></TH>"
                + "<TH><%=SystemEnv.getHtmlLabelName(15836 , user.getLanguage())%></TH>"
                + "<TH><%=SystemEnv.getHtmlLabelName(15837 , user.getLanguage())%></TH>"
                + "<TH><%=SystemEnv.getHtmlLabelName(15838 , user.getLanguage())%></TH>"
                + "<TH><%=SystemEnv.getHtmlLabelName(15834 , user.getLanguage())%>(%)</TH>"
                + "<TH><%=SystemEnv.getHtmlLabelName(19756 , user.getLanguage())%></TH>"
                +"</TR>"
                + "<TR class = DataDark>"
                + "<TD>" +
                            "<select name=scopetype"+ssrowindex+" onchange='changescopetype(this);'>"+
                            "<option  value=0><%=SystemEnv.getHtmlLabelName(332 , user.getLanguage())%></option>"+
                            "<option  value=1><%=SystemEnv.getHtmlLabelName(493 , user.getLanguage())%></option>"+
                            "<option  value=2><%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%></option>"+
                            "<option  value=3><%=SystemEnv.getHtmlLabelName(18939 , user.getLanguage())%></option>"+
                            "<option  value=4><%=SystemEnv.getHtmlLabelName(179 , user.getLanguage())%></option>"+
                            "</select>"+
                        "<BUTTON class = Browser type=button " +  " style='display:none' onclick = 'onShowOrganization(cityidspan" + ssrowindex + ",cityid" + ssrowindex +",scopetype"+ssrowindex+ ")'>" + "</BUTTON><SPAN id = cityidspan" + ssrowindex + "></SPAN>"
                + "<input class=inputstyle type = 'hidden' name = 'cityid" + ssrowindex + "'></TD>"
                + "<TD><INPUT class=inputstyle maxLength=10 style='width:100%' " + "name = 'taxbenchmark" + ssrowindex
                + "' onKeyPress='ItemCount_KeyPress()'" + "onBlur='checkcount1(this)' ></TD>"
                + "<TD><input class=inputstyle  maxLength = 10 style = 'width:100%' "+
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
                            "<BUTTON class=addbtn accessKey=1 type=button onClick=addRowSsD("+ssrowindex+"); title=<%=SystemEnv.getHtmlLabelName(15836,user.getLanguage())%>></BUTTON>"+
                            "</TD>"+
                            "</TR>"+
                            "</table>" ;
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;

		}
	}
	ssrowindex = ssrowindex*1 +1;
	frmMain.totalss.value = ssrowindex;
	jQuery(oRow).find("select").selectbox();
	jQuery("body").jNice();
}

function addRowCal() {
	//ncol = jQuery(oTable_cal).find("colgroup:first").find("col").length;
	ncol = 2;
	oRow = oTable_cal.insertRow(-1) ;
  caldrowindex[calrowindex] = 1 ;
  
  oRow.className="DataLight";
	for(j = 0 ; j < ncol ; j++){
		oCell = oRow.insertCell(-1) ;
        oCell.style.height=24 ;
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
                            "<select name=scopetypecal"+calrowindex+" onchange='changescopetype(this);'>"+
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
                            "<select name=timescope"+calrowindex+"_0 >"+
                            "<option  value=1><%=SystemEnv.getHtmlLabelName(17138 , user.getLanguage())%></option>"+
                            "<option  value=2><%=SystemEnv.getHtmlLabelName(19483 , user.getLanguage())%></option>"+
                            "<option  value=3><%=SystemEnv.getHtmlLabelName(17495 , user.getLanguage())%></option>"+
                            "<option  value=4><%=SystemEnv.getHtmlLabelName(19398 , user.getLanguage())%></option>"+
                            "</select></td>"+
                            "<TD><BUTTON class=Browser  type=button onClick='onShowCon(concalspan"+calrowindex+"_0,concal"+calrowindex+"_0,condspcal"+calrowindex+"_0,scopetypecal"+calrowindex+")' ></BUTTON>"+
                            "<span id=concalspan"+calrowindex+"_0 name=concalspan"+calrowindex+"_0></span>"+
                            "<input type=hidden name=concal"+calrowindex+"_0>"+
                            "<input type=hidden name=condspcal"+calrowindex+"_0></TD>"+
                            "<TD><BUTTON class=Browser type=button onClick='onShowFormula(formulacalspan"+calrowindex+"_0,formulacal"+calrowindex+"_0,formuladspcal"+calrowindex+"_0,scopetypecal"+calrowindex+")' ></BUTTON>"+
                            "<span id=formulacalspan"+calrowindex+"_0 name=formulacalspan"+calrowindex+"_0></span>"+
                            "<input type=hidden name=formulacal"+calrowindex+"_0>"+
                            "<input type=hidden name=formuladspcal"+calrowindex+"_0></TD>"+
                            "</TR>"+
                            "</tbody>"+
                            "</table>"+
                            "<TABLE width=100%>"+
                            "<TR>"+
                            "<TD style='text-align:right'>"+
                            "<BUTTON class=addbtn accessKey=1 type=button onClick=addRowCalD("+calrowindex+"); title=<%=SystemEnv.getHtmlLabelName(15836,user.getLanguage())%>></BUTTON>"+
                            "</TD>"+
                            "</TR>"+
                            "</table>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
		}
	}
	calrowindex = calrowindex*1 +1;
	frmMain.totalcal.value = calrowindex;
	jQuery(oRow).find("select").selectbox();
	jQuery("body").jNice();
}

function addRowWel() {
	//ncol = jQuery(oTable_wel).find("tr:first").find("td").length ;
	ncol = 2;
	oRow = oTable_wel.insertRow(-1) ;
    oRow.className="DataLight";
    weldrowindex[welrowindex] = 1 ;

	for(j = 0 ; j < ncol ; j++){
		oCell = oRow.insertCell(-1) ;
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
				var sHtml = "<TABLE class=ListStyle id='oTable_weldetail"+welrowindex+"' " +  "name='oTable_weldetail"+welrowindex+"' cols=4>"+
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
                            "<input type=hidden name=formulawel"+welrowindex+"_0>"+
                            "<input type=hidden name=formuladspwel"+welrowindex+"_0></TD>"+
                            "</TR>"+
                            "</tbody>"+
                            "</table>"+
                            "<TABLE width=100%>"+
                            "<TR>"+
                            "<TD style=\"text-align: right;\">"+
                            "<BUTTON type=button class=addbtn accessKey=1 onClick=addRowWelD("+welrowindex+"); title=<%=SystemEnv.getHtmlLabelName(15836 , user.getLanguage())%>></BUTTON>"+
                            "</TD>"+
                            "</TR>"+
                            "</table>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
		}
	}
	welrowindex = welrowindex*1 +1;
	frmMain.totalwel.value = welrowindex;
	jQuery(oRow).find("select").selectbox();
	jQuery("body").jNice();
}
function addRowSsD(tableid) {
    thetable = jQuery("#oTable_ssdetail" + tableid)[0] ;
    tablerowindex = ssdrowindex[tableid] ;
	//ncol = thetable.cols ;
	ncol = 7;
	oRow = thetable.insertRow(thetable.rows.length) ;
	  oRow.className="DataLight";
    //rowColor = getRowBg();
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(j) ;
        oCell.style.height = 24 ;
		switch(j) {
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

function addRowCalD(tableid) {
  thetable = jQuery("#oTable_caldetail" + tableid)[0] ;
  tablerowindex = caldrowindex[tableid] ;
	//ncol = jQuery(thetable).find("tr:first").find("th").length ;
	ncol=6;
	oRow = thetable.insertRow(thetable.rows.length) ;
	oRow.className="DataLight";
	
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(j) ;
    oCell.style.height = 24 ;
		switch(j) {
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
				var sHtml = "<BUTTON class=Browser type=button onClick='onShowCon(concalspan"+tableid+"_"+tablerowindex+",concal"+tableid+"_"+tablerowindex+",condspcal"+tableid+"_"+tablerowindex+",scopetypecal"+tableid+")' ></BUTTON>"+
                            "<span id='concalspan"+tableid+"_"+tablerowindex+"' name='concalspan"+tableid+"_"+tablerowindex+"'></span>"+
                            "<input type=hidden name='concal"+tableid+"_"+tablerowindex+"'>"+
                            "<input type=hidden name='condspcal"+tableid+"_"+tablerowindex+"'>"
                oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
            case 3:
				var oDiv = document.createElement("div") ;
				var sHtml = "<BUTTON class=Browser type=button onClick='onShowFormula(formulacalspan"+tableid+"_"+tablerowindex+",formulacal"+tableid+"_"+tablerowindex+",formuladspcal"+tableid+"_"+tablerowindex+",scopetypecal"+tableid+")' ></BUTTON>"+
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
function addRowWelD(tableid) {
    thetable = jQuery("#oTable_weldetail" + tableid)[0] ;
    tablerowindex = weldrowindex[tableid] ;
	//ncol = thetable.cols ;
		ncol = 4;
	oRow = thetable.insertRow(thetable.rows.length) ;
 	oRow.className="DataLight";
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(j) ;
        oCell.style.height = 24 ;
		switch(j) {
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

function addRowKq_Dec() {   //类型中选考勤扣款的处理加入一行的程序代码
  //ncol = jQuery(oTable_kqkk).find("colgroup:first").find("col").length ;
	ncol = 2;
	oRow = oTable_kqkk.insertRow(oTable_kqkk.rows.length) ;
	oRow.className="DataLight";
	for(j=0 ; j < ncol ; j++) {
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
				var sHtml = "<BUTTON class=Browser type=button onclick='onShowScheduleDec(diffnamespan01" + kqkkrowindex + ",diffname01" + kqkkrowindex + ")'></BUTTON><SPAN id=diffnamespan01" + kqkkrowindex + "></SPAN><input class=inputstyle type='hidden' name='diffname01" + kqkkrowindex + "'>" ;
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
  //ncol = jQuery(oTable_kqjx).find("colgroup:first").find("col").length ;
	ncol = 2
	oRow = oTable_kqjx.insertRow(oTable_kqjx.rows.length) ;
	oRow.className="DataLight";
    //rowColor = getRowBg();
	for(j=0 ; j < ncol ; j++){
		oCell = oRow.insertCell(j) ;
    oCell.style.height = 24 ;
		//oCell.style.background= rowColor;
		switch(j) {
			case 0:
				var oDiv = document.createElement("div") ;
				var sHtml = "<input class=inputstyle type='checkbox' name='check_kqjx' value=1>" ;
				oDiv.innerHTML = sHtml ;
				oCell.appendChild(oDiv) ;
				break ;
            case 1:
				var oDiv = document.createElement("div") ;
				var sHtml = "<BUTTON class=Browser type=button onclick='onShowScheduleAdd(diffnamespan0" + kqjxrowindex + ",diffname0" + kqjxrowindex + ")'></BUTTON><SPAN id=diffnamespan0" + kqjxrowindex + "></SPAN><input class=inputstyle type='hidden' name='diffname0" + kqjxrowindex + "'>" ;
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

function deleteRow1_Je() {
	len = document.forms[0].elements.length;
	var i=0;
    var rowsum1 = 0 ;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_je')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_je'){
			if(document.forms[0].elements[i].checked==true) {
				oTable_je.deleteRow(rowsum1);
			}
			rowsum1 -=1;
		}
	}
}

function deleteRow1_Fl()
{
	len = document.forms[0].elements.length;
	var i=0;
    var rowsum1 = 0 ;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_fl')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_fl'){
			if(document.forms[0].elements[i].checked==true) {
				oTable_fl.deleteRow(rowsum1+1);
			}
			rowsum1 -=1;
		}
	}
}

function deleteRow1_Ss()
{
	len = document.forms[0].elements.length;
	var i=0;
    var rowsum1 = 0 ;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_ss')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_ss'){
			if(document.forms[0].elements[i].checked==true) {
				oTable_ss.deleteRow(rowsum1-1);
			}
			rowsum1 -=1;
		}
	}
}
function deleteRow1_Cal()
{
	len = document.forms[0].elements.length;
	var i=0;
    var rowsum1 = 0 ;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_cal')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_cal'){
			if(document.forms[0].elements[i].checked==true) {
				oTable_cal.deleteRow(rowsum1-1);
			}
			rowsum1 -=1;
		}
	}
}
function deleteRow1_Wel()
{
	len = document.forms[0].elements.length;
	var i=0;
    var rowsum1 = 0 ;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_wel')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_wel'){
			if(document.forms[0].elements[i].checked==true) {
				oTable_wel.deleteRow(rowsum1-1);
			}
			rowsum1 -=1;
		}
	}
}
var isfirst = false;
 function showType(){
    itemtypelist = window.document.frmMain.itemtype;
    if(itemtypelist.value==1){
        tb_fl.style.display='none';
        hideEle("tr_taxrelateitem"); 
        //tr_taxrelateitem.style.display='none';
        //tr_amountecp.style.display='none';
        tb_je.style.display='' ;
        tb_ss.style.display='none' ;
        tb_cal.style.display = 'none' ;
        tb_wel.style.display = 'none' ;
        tb_jssm.style.display='none' ;
        tb_kqkk.style.display = 'none' ;
        tb_kqjx.style.display = 'none' ;
        tb_cqjt.style.display = 'none' ;
        tb_cqzf.style.display = '' ;
        hideEle("tr_wel");        
        hideEle("td_wel1");
        //tr_wel.style.display='none';
        //td_wel1.style.display='none';
        
        //document.all("calMode").style.display='none';
        //document.all("directModify").style.display='none';
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
        tb_fl.style.display='';
        hideEle("tr_taxrelateitem"); 
        //tr_taxrelateitem.style.display='none';
        //tr_amountecp.style.display='none';
        tb_je.style.display='' ;
        tb_ss.style.display='none' ;
         tb_cal.style.display = 'none' ;
        tb_wel.style.display = 'none' ;
        tb_jssm.style.display='none' ;
        tb_kqkk.style.display = 'none' ;
        tb_kqjx.style.display = 'none' ;
        tb_cqjt.style.display = 'none' ;
        tb_cqzf.style.display = '' ;
        hideEle("tr_wel");        
        hideEle("td_wel1");
        //tr_wel.style.display='none';
        //td_wel1.style.display='none';
        //document.all("calMode").style.display='none';
        //document.all("directModify").style.display='none';
    }
    else if(itemtypelist.value==3){
        tb_fl.style.display='none';
        showEle("tr_taxrelateitem"); 
        //tr_taxrelateitem.style.display='';
        //tr_amountecp.style.display='none';
        tb_je.style.display='none' ;
        tb_ss.style.display='' ;
        tb_cal.style.display = 'none' ;
        tb_wel.style.display = 'none' ;
        tb_jssm.style.display='none' ;
        tb_kqkk.style.display = 'none' ;
        tb_kqjx.style.display = 'none' ;
        tb_cqjt.style.display = 'none' ;
        tb_cqzf.style.display = 'none' ;
        hideEle("tr_wel");        
        hideEle("td_wel1");
        //tr_wel.style.display='none';
        //td_wel1.style.display='none';
        //document.all("calMode").style.display='none';
        //document.all("directModify").style.display='none';
    }
    else if(itemtypelist.value==4){
        tb_fl.style.display='none';
        hideEle("tr_taxrelateitem"); 
        //tr_taxrelateitem.style.display='none';
        //tr_amountecp.style.display='';
        tb_je.style.display='none' ;
        tb_ss.style.display='none' ;
         tb_cal.style.display = '' ;
        tb_wel.style.display = 'none' ;
        tb_jssm.style.display='' ;
        tb_kqkk.style.display = 'none' ;
        tb_kqjx.style.display = 'none' ;
        tb_cqjt.style.display = 'none' ;
        tb_cqzf.style.display = 'none' ;
        hideEle("tr_wel");        
        showEle("td_wel1");
        //tr_wel.style.display='none';
        //td_wel1.style.display='';
        //document.all("calMode").style.display='none';
        //document.all("directModify").style.display='';
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
        hideEle("tr_wel");        
        hideEle("td_wel1");
        //tr_wel.style.display='none';
        //td_wel1.style.display='none';
        //document.all("calMode").style.display='none';
        //document.all("directModify").style.display='none';
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
        hideEle("tr_wel");        
        hideEle("td_wel1");
        //tr_wel.style.display='none';
        //td_wel1.style.display='none';
        //document.all("calMode").style.display='none';
        //document.all("directModify").style.display='none';
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
        tb_cqjt.style.display = '' ;
        tb_cqzf.style.display = 'none' ;
        hideEle("tr_wel");        
        hideEle("td_wel1");
        //tr_wel.style.display='none';
        //td_wel1.style.display='none';
        //document.all("calMode").style.display='none';
        //document.all("directModify").style.display='none';
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
        tb_cqjt.style.display = 'none' ;
        tb_cqzf.style.display = '' ;
        hideEle("tr_wel");        
        hideEle("td_wel1");
        //tr_wel.style.display='none';
        //td_wel1.style.display='none';
        //document.all("calMode").style.display='none';
        //document.all("directModify").style.display='none';
    }
    else if(itemtypelist.value==9){
        tb_fl.style.display = 'none' ; //福利
        hideEle("tr_taxrelateitem"); 
        //tr_taxrelateitem.style.display = 'none' ; //相关税率项目
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
        if(document.all("calMode").value=='1')
        tb_wel1.style.display = '' ;
        else
        tb_wel1.style.display = 'none' ;
        showEle("tr_wel");        
        showEle("td_wel1");
        //tr_wel.style.display='';
        //td_wel1.style.display='';
        //document.all("calMode").style.display='';
        //document.all("directModify").style.display='';
    }
}

  function showOrder() {
		isshowlist = window.document.frmMain.isshow;
		if(isshowlist.value == 1) {
			showEle("tr_showorder");
		}else{
			hideEle("tr_showorder");
		}
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


function onShowCityID(tdname , inputename){
	//data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp");
	url="/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp";
     dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(16524,user.getLanguage())%>";
	dialog.Width = 700;
	dialog.Height = 450;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.callbackfun = function (params,data){
	  if (data!=null){
		if (data.id!= 0) {
	        tdname.innerHTML = data.name;
	        inputename.value = data.id;
		}else{
	        tdname.innerHTML = "";
	        inputename.value = "";
		}
	}
	};
	dialog.show();
	
}
function onShowJobID(tdname , inputename){
	//data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp");
	url="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp";
     dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(16461,user.getLanguage())%>";
	dialog.Width = 700;
	dialog.Height = 450;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.callbackfun = function (params,data){
	  if (data!=null){
		if (data.id!=null){
            tdname.innerHTML = data.name;
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
	//data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobactivities/JobActivitiesBrowser.jsp");
	url="/systeminfo/BrowserMain.jsp?url=/hrm/jobactivities/JobActivitiesBrowser.jsp";
     dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%>";
	dialog.Width = 700;
	dialog.Height = 450;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.callbackfun = function (params,data){
	  if (data!=null){
		if (data.id!=null){
			tdname.innerHTML = data.name;
			inputename.value = data.id;
		}else{
			tdname.innerHTML = "";
			inputename.value="";
		}
	}
	};
	dialog.show();
	
}

function onShowHR(spanname, inputname) {
    if(document.all("applyscope").value=="0")
    url="/hrm/resource/MutiResourceBrowser.jsp";
    else if(document.all("applyscope").value=="1")
     url=escape("/hrm/resource/MutiResourceBrowser.jsp?sqlwhere=subcompanyid1=<%=subcompanyid%>");
    else if(document.all("applyscope").value=="2")
     url=escape("/hrm/resource/MutiResourceBrowser.jsp?sqlwhere=subcompanyid1 in(<%=subids%>)");
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
    url=escape("/hrm/finance/salary/MutiDepartmentByRightBrowser.jsp?selectedids="+inputname.value+"&rightStr=HrmResourceComponentAdd:Add&subcompanyid=<%=subcompanyid%>&scope="+document.all("applyscope").value);
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
    url=escape("/hrm/finance/salary/MutiSubCompanyByRightBrowser.jsp?selectedids="+inputname.value+"&rightStr=HrmResourceComponentAdd:Add&subcompanyid=<%=subcompanyid%>&scope="+document.all("applyscope").value);
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
function onShowItemId(spanname , inputname){
    url=escape("/hrm/finance/salary/SalaryItemRightBrowser.jsp?subcompanyid=<%=subcompanyid%>&scope="+document.all("applyscope").value);
    //datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url)  ;
    url="/systeminfo/BrowserMain.jsp?url="+url;
     dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(15827,user.getLanguage())%>";
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
    url=escape("/hrm/finance/salary/conditions.jsp?subc=<%=subcompanyid%>&scope="+document.all("applyscope").value+"&st="+scopetype.value+"&sv="+scopetype.parentNode.getElementsByTagName("input")[0].value);
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
    if(scopetype.value!=0&&scopetype.parentNode.getElementsByTagName("input")[0].value==""){
    window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18214 , user.getLanguage())+SystemEnv.getHtmlLabelName(19467 , user.getLanguage())%>")  ;
        return;
        }
    var sizestr = "dialogWidth=700px;dialogHeight=550px";
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(15828,user.getLanguage())%>";
	dialog.Drag = true;
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

jQuery(document).ready(function(){
	<% if(!itemtype.equals("9")){%>hideEle("tr_wel");<%}%>
	<% if(!itemtype.equals("3")) {%>hideEle("tr_taxrelateitem");<%}%>
	<% if(!isshow.equals("1")) {%>hideEle("tr_showorder");<%}%>
	<% if(!itemtype.equals("9")&&!itemtype.equals("4")){%>hideEle("td_wel1");<%}%>
})

function dodelete_Je(){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
		deleteRow1_Je()
	})
}

function dodelete_Fl(){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
		deleteRow1_Fl()
	})
}

function dodelete_Ss(){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
		deleteRow1_Ss();
	})
}

function dodelete_Cal(){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
		deleteRow1_Cal();
	})
}

function dodelete_Wel(){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
		deleteRow1_Wel();
	})
}

function dodelete_Kq_Dec(){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
		deleteRow1_Kq_Dec();
	})
}

function dodelete_Kq_Add(){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
		deleteRow1_Kq_Add();
	})
}


</script>
</body>
</html>
