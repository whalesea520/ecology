
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
//获得当前的日期和时间
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
char flag=Util.getSeparator() ;
String ProcPara = "";
String meetingtype = Util.null2String(request.getParameter("meetingtype"));
String meetingname = Util.toScreen(Util.null2String(request.getParameter("meetingname")),user.getLanguage(),"0");
String roomid = Util.null2String(request.getParameter("roomid"));
String startdate = Util.null2String(request.getParameter("startdate"));
String enddate = Util.null2String(request.getParameter("enddate"));
String starttime = Util.null2String(request.getParameter("starttime"));
String endtime = Util.null2String(request.getParameter("endtime"));
String roomname = "";
String getroomsql = "select * from MeetingRoom where id=";
if (null != roomid && !"".equals(roomid))
{
	RecordSet.executeSql(getroomsql + roomid);
	while (RecordSet.next())
	{
		roomname = RecordSet.getString("name");
	}
}

String mainId = "";
String subId = "";
String secId = "";
String maxsize = "";
if(!meetingtype.equals(""))
{
	RecordSet.executeProc("Meeting_Type_SelectByID",meetingtype);
	if(RecordSet.next())
	{
		String category = Util.null2String(RecordSet.getString("catalogpath"));
	    if(!category.equals(""))
	    {
	    	String[] categoryArr = Util.TokenizerString2(category,",");
	    	mainId = categoryArr[0];
	    	subId = categoryArr[1];
	    	secId = categoryArr[2];
	    }
    }
	if(!secId.equals(""))
	{
		RecordSet.executeSql("select maxUploadFileSize from DocSecCategory where id="+secId);
		RecordSet.next();
	    maxsize = Util.null2String(RecordSet.getString(1));
	}
}
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/js/extjs/adapter/ext/ext-base_wev8.js"></script>
<script type="text/javascript" src="/js/extjs/ext-all_wev8.js"></script>
</HEAD>
<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(2103,user.getLanguage());
String needfav ="1";
String needhelp ="";
int topicrows=0;
String needcheck="name,caller,contacter,begindate,begintime,enddate,endtime,totalmember";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(220,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSubmit(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM id=weaver name=weaver action="/meeting/data/AjaxMeetingOperation.jsp" method=post enctype="multipart/form-data">
<input class=inputstyle type="hidden" name="method" value="add">
<input class=inputstyle type="hidden" name="meetingtype" value="<%=meetingtype%>">
<input class=inputstyle type="hidden" name="topicrows" value="0">
<TABLE class=viewform>
  <COLGROUP>
  <COL width="49%">
  <COL width=10>
  <COL width="49%">
  <TBODY>
  <TR>
	<TD vAlign=top>
	
	  <TABLE class=viewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></TH>
          </TR>
        <TR class=spacing style="height:2px">
          <TD class=line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2151,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputStyle size=28 name="name" value="<%=meetingname%>" onchange='checkinput("name","nameimage")'><SPAN id=nameimage></SPAN></TD>
        </TR>
		<TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
<%
//生成召集人的where子句
RecordSet.executeProc("MeetingCaller_SByMeeting",meetingtype) ;
String whereclause="where ( " ;
int ishead=0 ;
int isset=0;//是否有设置召集人标识，0没有，1有
while(RecordSet.next()){
    String callertype=RecordSet.getString("callertype") ;
    String seclevel=RecordSet.getString("seclevel") ;
    String rolelevel=RecordSet.getString("rolelevel") ;
    String thisuserid=RecordSet.getString("userid") ;
    String departmentid=RecordSet.getString("departmentid") ;
    String roleid=RecordSet.getString("roleid") ;
    String foralluser=RecordSet.getString("foralluser") ;
    isset=1;

    if(callertype.equals("1")){
        if(ishead==0)
            whereclause+=" t1.id="+thisuserid ;
        if(ishead==1)
            whereclause+=" or t1.id="+thisuserid ;
    }
    if(callertype.equals("2")){
        if(ishead==0)
            whereclause+=" t1.id in (select id from hrmresource where departmentid="+departmentid+" and seclevel >="+seclevel+" )" ;
        if(ishead==1)
            whereclause+=" or t1.id in (select id from hrmresource where departmentid="+departmentid+" and seclevel >="+seclevel+" )" ;
    }
    if(callertype.equals("3")){
        if(ishead==0)
            whereclause+=" t1.id in (select resourceid from hrmrolemembers where roleid="+roleid+" and rolelevel >="+rolelevel+" )" ;
        if(ishead==1)
            whereclause+=" or t1.id in (select resourceid from hrmrolemembers where roleid="+roleid+" and rolelevel >="+rolelevel+" )" ;
    }
    if(callertype.equals("4")){
        if(ishead==0)
            whereclause+=" t1.id in (select id from hrmresource where seclevel >="+seclevel+" )" ;
        if(ishead==1)
            whereclause+=" or t1.id in (select id from hrmresource where seclevel >="+seclevel+" )" ;
    }
    if(ishead==0)   ishead=1;
}
if(!whereclause.equals(""))  whereclause+=" )" ;

%>

    <%if(isset==0){%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2152,user.getLanguage())%></TD>
          <TD class=Field>
          	<INPUT id="caller" class=wuiBrowser type="hidden" name="caller"_required=yes
      _url="/systeminfo/BrowserMain.jsp?url=/meeting/data/CallerBrowser.jsp?sqlwhere=<%=xssUtil.put(whereclause)%>"
      _displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>"></TD>
        </TR>
   <% }else{%>

  <TR>
      <TD><%=SystemEnv.getHtmlLabelName(2152,user.getLanguage())%></TD>        
	  <TD class=Field>
      <INPUT id="caller" class=wuiBrowser type="hidden" name="caller"_required=yes
      _url="/systeminfo/BrowserMain.jsp?url=/meeting/data/CallerBrowser.jsp?sqlwhere=<%=xssUtil.put(whereclause)%>"
      _displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>"></TD>	
  </TR>
    <%}%>


        <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></TD>
          <TD class=Field>
          <INPUT class=wuiBrowser type=hidden name="contacter" value="<%=user.getUID()%>" _required=yes _displayText=<%=user.getUsername()%>
          _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?sqlwhere=<%=xssUtil.put(whereclause)%>"
          _displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>"></TD>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
		<%if(isgoveproj==0){%>
<%if(software.equals("ALL") || software.equals("CRM")){%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></TD>
          <TD class=Field style="word-break:break-all;"> 
          <input class=wuiBrowser type=hidden  name=projectid value=""
          _url="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp"
          _displayTemplate="<A href='/proj/data/ViewProject.jsp?ProjID=#b{id}'>#b{name}</A>"></TD>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
<%}%>
<%}%>
		<!--================ 提醒方式  ================-->
		<TR>
			<TD><%=SystemEnv.getHtmlLabelName(18713,user.getLanguage())%></TD>
			<TD class="Field">
				<INPUT type="radio" value="1" name="remindType" onclick=showRemindTime(this) checked><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
				<INPUT type="radio" value="2" name="remindType" onclick=showRemindTime(this)><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%>
				<INPUT type="radio" value="3" name="remindType" onclick=showRemindTime(this)><%=SystemEnv.getHtmlLabelName(18845,user.getLanguage())%>
			</TD>
		</TR>
		<TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
		
		<!--================ 提醒时间  ================-->
		<TR id="remindTime" style="display:none">
			<TD><%=SystemEnv.getHtmlLabelName(785,user.getLanguage())%></TD>
			<TD class="Field">
				<INPUT type="checkbox" name="remindBeforeStart" value="1">
					<%=SystemEnv.getHtmlLabelName(19784,user.getLanguage())%>
					<INPUT class="InputStyle" type="input" name="remindDateBeforeStart" onchange="checkint('remindDateBeforeStart')" size=4 value="0">
					<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
					<INPUT class="InputStyle" type="input" name="remindTimeBeforeStart" onchange="checkint('remindTimeBeforeStart')" size=4 value="10">
					<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
				<INPUT type="checkbox" name="remindBeforeEnd" value="1">
					<%=SystemEnv.getHtmlLabelName(19785,user.getLanguage())%>
					<INPUT class="InputStyle" type="input" name="remindDateBeforeEnd" onchange="checkint('remindDateBeforeEnd')" size=4 value="0">
					<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
					<INPUT class="InputStyle" type="input" name="remindTimeBeforeEnd" onchange="checkint('remindTimeBeforeEnd')"  size=4 value="10">
					<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
			</TD>
		</TR>
		<TR id="remindTimeLine" style="display:none;height:1px;">
			<TD class="Line" colSpan="6"></TD>
		</TR>
        </TBODY>
	  </TABLE>
	</TD>
	<TD></TD>
	<TD vAlign=top>
	  <TABLE class=viewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TH>
          </TR>
        <TR class=spacing style="height:2px">
          <TD class=line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></TD>
          <TD class=Field> <BUTTON class=Calendar type=button onclick="onShowDate(BeginDatespan,begindate)"></BUTTON> 
          	<SPAN id=BeginDatespan ><%if (null == startdate || startdate.equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%><%=startdate%></SPAN>
          	<input class=inputstyle type="hidden" name="begindate" value="<%=startdate%>">
          </TD>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></TD>
          <TD class=Field><button class=Clock type=button onclick="onshowMeetingTime(BeginTimespan,begintime)"></button>
          	<span id="BeginTimespan"><%if (null == starttime || starttime.equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%><%=starttime%></span>
		  	<input class=inputstyle type=hidden name="begintime" value="<%=starttime%>">
		  </TD>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></TD>
          
          <TD class=Field> <BUTTON class=Calendar type=button onclick="onShowDate(EndDatespan,enddate)"></BUTTON> 
          	<SPAN id=EndDatespan><%if (null == enddate || enddate.equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%><%=enddate%></SPAN>
			<input class=inputstyle type="hidden" name="enddate" value="<%=enddate%>">
          </TD>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></TD>
          <TD class=Field><button class=Clock type=button onclick="onshowMeetingTime(EndTimespan,endtime)"></button>
          	<span id="EndTimespan"><%if (null == endtime || endtime.equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%><%=endtime%></span>
			<input class=inputstyle type=hidden name="endtime" value="<%=endtime%>">
          </TD>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
        
        <!--================ 会议地点 ================-->
		<TR>
			<TD><%=SystemEnv.getHtmlLabelName(2105,user.getLanguage())%></TD>
			<TD class=Field>	       
				<INPUT type=hidden class=wuiBrowser id=address name=address value="<%=roomid%>"
				_required=yes _displayText="<%=roomname%>"
				_url="/systeminfo/BrowserMain.jsp?url=/meeting/Maint/MeetingRoomBrowser.jsp"
				_displayTemplate="<A href='/meeting/Maint/MeetingRoom.jsp'>#b{name}</A>">
				
			</TD>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
        
        <!--================ 自定义会议地点 ================-->
		<TR>
			<TD><%=SystemEnv.getHtmlLabelName(20392, user.getLanguage())%></TD>
			<TD class=Field>
				<INPUT class=inputStyle size=28 id="customizeAddress"  onmousedown="omd()" viewtype=1 name="customizeAddress" value=""  onBlur="checkaddress(this);checkinput3(customizeAddress, customizeAddressspan, this.getAttribute('viewtype'))">
				<span id="customizeAddressspan"><%if(roomid==null||"".equals(roomid)){ %><img src="/images/BacoError_wev8.gif" align=absmiddle><%} %></span>
			</TD>
		</TR>
        <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
        
        </TBODY>
	  </TABLE>
	</TD>
        </TR>
        </TBODY>
	  </TABLE>

	  <TABLE class=viewForm>
        <TBODY>
        <TR class=title>
            <TH><%=SystemEnv.getHtmlLabelName(2106,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(2166,user.getLanguage())%> <input class=inputstyle type=text name="totalmember" size=5 onKeyPress="ItemCount_KeyPress_Plus()" value="0" onBlur="checkcount1(this);checkinput('totalmember','totalmemberspan')">
			<%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%>)
            <span id="totalmemberspan"></span></TH>
          </TR>
        <TR class=spacing style="height:2px">
          <TD class=line1></TD></TR>
        <TR>
          <TD class=Field> 

<%
RecordSet.executeProc("Meeting_Member_SelectByType",meetingtype+flag+"1");
while(RecordSet.next()){
%>
			<input class=inputstyle type=checkbox name=hrmids01 value="<%=RecordSet.getString("memberid")%>" onclick="countAttend()"><%=ResourceComInfo.getResourcename(RecordSet.getString("memberid"))%>&nbsp&nbsp
<%}%>		  
		  </TD>
        </TR>
        <TR>
          <TD class=Field><%=SystemEnv.getHtmlLabelName(2106,user.getLanguage())%>: 
			<input class=wuiBrowser type=hidden name="hrmids02" value=""
			_required=yes _callback="countAttend()"
			_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
			_displayTemplate="<a href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</a>&nbsp;"
			_trimLeftComma="yes"
			>
		  </TD>
        </TR>
<%if(software.equals("ALL") || software.equals("CRM")){%>
        <TR>
          <TD class=Field>
<%
RecordSet.executeProc("Meeting_Member_SelectByType",meetingtype+flag+"2");
while(RecordSet.next()){
%>
			<input class=inputstyle type=checkbox name=crmids01 value="<%=RecordSet.getString("memberid")%>" onclick="countAttend()"><%=CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("memberid"))%>&nbsp&nbsp
<%}%>		  
		  </TD>
        </TR>
		<%if(isgoveproj==0){%>
        <TR>
          <TD class=Field><%=SystemEnv.getHtmlLabelName(2167,user.getLanguage())%>: 
			<%}%>
			<input class=wuiBrowser type=hidden name="crmids02" value=""
			_url="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp"
			_displayTemplate="<a href='/CRM/data/ViewCustomer.jsp?CustomerID=#b{id}'>#b{name}</a>&nbsp;"
			_callback="countAttend()"  _trimLeftComma="yes"
			>
			<%if(isgoveproj==0){%>
			<span id="crmids02span"></span> 
		  </TD>
        </TR>
		<%}%>
<%}%>
        <tr>
          <td class=field><%=SystemEnv.getHtmlLabelName(2168,user.getLanguage())%>: 
          <input class=inputstyle type=text name="othermembers" size=70>
          <td>
        <tr>
        </TBODY>
	  </TABLE>

	  <TABLE class=viewForm>
        <TBODY>
        <TR class=title>
            <TH><%=SystemEnv.getHtmlLabelName(2169,user.getLanguage())%></TH>
            <Td align=right>
				<A href="javascript:addRow();"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></A>
				<A href="javascript:if(isdel()){deleteRow1();}"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></A>	
			</Td>
          </TR>
        <TR class=spacing style="height:1px">
          <TD class=line1 colspan=2></TD></TR>
        <tr><td colspan=2>
          <table class=liststyle cellspacing=1  id="oTable">
            <COLGROUP>
    		<COL width="4%">
    		<COL width="40%">
    		<COL width="20%">
    		<COL width="15%">
    		<COL width="15%">
    		<tr class=header>
    		   <td><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></td>
    		   <td>&nbsp;</td>
    		   <td><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></td>
			   <%if(isgoveproj==0){%>
    		   <td><%if(software.equals("ALL") || software.equals("CRM")){%><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%><%}%>&nbsp</td>
    		   <td><%if(software.equals("ALL") || software.equals("CRM")){%><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%><%}%>&nbsp</td>
    		   <%}else{%>
			   <td>&nbsp;</td>
    		   <td>&nbsp;</td>
			   <%}%>
			   <td><%=SystemEnv.getHtmlLabelName(2161,user.getLanguage())%></td>
    		</tr>
          </table>
        </td></tr>
        
        <TR>
          <TD colspan=2>   
	  <TABLE class=viewForm cellpadding=1  cols=6>
      	<COLGROUP>
      	<COL width="4%">
		<COL width="40%">
		<COL width="20%">
		<COL width="15%">
		<COL width="15%">
		<COL width="6%">
        <TBODY>
        </TBODY>
	  </TABLE>		  
		  
		  </TD>
        </TR>
        </TBODY>
	  </TABLE>
<%
int servicerows=0;
RecordSet.executeProc("Meeting_Service_SelectAll",meetingtype);
if(RecordSet.getCounts()>0){
%>
	  <TABLE class=viewForm>
        <COLGROUP>
		<COL width="15%">
  		<COL width="85%">
        <TBODY>
        <TR class=title>
            <TH colspan=2><%=SystemEnv.getHtmlLabelName(2107,user.getLanguage())%></TH>
          </TR>
        <TR class=spacing>
          <TD class=Sep1 colspan=2></TD></TR>
<%
while(RecordSet.next()){
%>
        <TR>
		  <td><%=RecordSet.getString("name")%></td>
          <TD> 
		  <input class=inputstyle type=hidden name=servicename_<%=servicerows%> value="<%=RecordSet.getString("name")%>">
		  <input class=inputstyle type=hidden name=servicehrm_<%=servicerows%> value="<%=RecordSet.getString("hrmid")%>">
	  <TABLE class=viewForm>
        <TBODY>
        <TR>
          <TD class=Field>
<%
	ArrayList serviceitems = Util.TokenizerString(RecordSet.getString("desc_n"),",");
	for(int i=0;i<serviceitems.size();i++){
%>
		  <input class=inputstyle type=checkbox name=serviceitem_<%=servicerows%> value="<%=serviceitems.get(i)%>"><%=serviceitems.get(i)%>&nbsp&nbsp
<%
	}
%>
		  </TD>
        </TR>
        <TR>
          <TD class=Field><%=SystemEnv.getHtmlLabelName(375,user.getLanguage())%>：<input class=inputstyle name=serviceother_<%=servicerows%>  style="width:90%"></TD>
        </TR>
        </TBODY>
	  </TABLE>		  
		  
		  </TD>
        </TR>
<%
	servicerows+=1;
}
%>
        </TBODY>
	  </TABLE>
<%}%>
	  <input class=inputstyle type="hidden" name="servicerows" value="<%=servicerows%>">
	  <TABLE id=AccessoryTable class="ViewForm" style="margin-top:10px;">
	  	<COLGROUP>
		<COL width="15%">
  		<COL width="85%">
	  	<TR class=title>
            <TH colspan=2><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></TH><!-- 相关附件 -->
          </TR>
          <TR class=spacing>
          	<TD class=line1 colspan=2></TD></TR>
          <TR>
          <TR>
            <td></td>
            <td class=field id="divAccessory" name="divAccessory">
			 <%if(!"".equals(secId)){ %>
			    <input class=InputStyle type=file name="accessory1" onchange='accesoryChanage(this)'>(<%=SystemEnv.getHtmlLabelName(18642,user.getLanguage())%>:<%=maxsize%>M)
	        	&nbsp;&nbsp;&nbsp;
		        <button type="button" class=AddDoc name="addacc" onclick="addannexRow()"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button>
		        <input type=hidden id="accessory_num" name="accessory_num" value="1">
		        <input type=hidden id="mainId" name="mainId" value="<%=mainId%>">
		        <input type=hidden id="subId" name="subId" value="<%=subId%>">
		        <input type=hidden id="secId" name="secId" value="<%=secId%>">
		        <input type=hidden id="maxsize" name="maxsize" value="<%=maxsize%>">
		      <%}else{%>   
		        <font color=red>(<%=SystemEnv.getHtmlLabelName(20476,user.getLanguage())%>)</font>
		      <%}%>
    		</td>
          </TR>
          <TR style="height:1px;"><TD class=Line colspan=2></TD></TR>
	  </TABLE>
	  <TABLE class=viewForm>
        <COLGROUP>
		<COL width="15%">
  		<COL width="85%">
        <TBODY>
        <TR class=title>
            <TH colspan=2><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TH>
          </TR>
        <TR class=spacing style="height:1px">
          <TD class=line1 colspan=2></TD></TR>
        <TR>
		  <td colspan=2>
		  <textarea class=inputstyle rows=5 style="width:100%" name="desc"></textarea>
		  </TD>
        </TR>
        </TBODY>
	  </TABLE>
</FORM>

</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>
<script language="JavaScript" src="/js/addRowBg_wev8.js" >   
</script>  
<script language=javascript>
function submitData() {
 window.history.back();
}
var rowColor="" ;
rowindex = "<%=topicrows%>";
function addRow()
{
	ncol = jQuery(oTable).find("tr:nth-child(1)").find("td").length;
	rowColor = getRowBg();
	oRow = oTable.insertRow(-1);
	
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1); 
		oCell.style.height=24;
		oCell.style.background= rowColor;
		oCell.style.wordBreak = "break-all";
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox' name='check_node' value='0'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=inputstyle type='input' style=width:99%  name='topicsubject_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;			
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=wuiBrowser type='hidden' name='topichrmids_"+rowindex+"' id='topichrmids_"+rowindex+"' "+
        					" _url='/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp' "+
        					" _displayTemplate='<a href=/hrm/resource/HrmResource.jsp?id=#b{id}>#b{name}</a>&nbsp;'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv); 
				jQuery(oDiv).find(".wuiBrowser").modalDialog();
				break;
            case 3: 
				var oDiv = document.createElement("div"); 
				<%if(isgoveproj==0){%>
				var sHtml = " " + 
        		<%}else{%>
				var sHtml = " " + 
				<%}%>
        					"<input class=wuiBrowser type='hidden' name='topicprojid_"+rowindex+"' id='topicprojid_"+rowindex+"' "+
        					" _url='/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp' "+
        					" _displayTemplate='<a href=/proj/data/ViewProject.jsp?ProjID=#b{id}>#b{name}</a>&nbsp;'>";
<%if(software.equals("ALL") || software.equals("CRM")){%>
				oDiv.innerHTML = sHtml;   
<%}%>
				oCell.appendChild(oDiv);  
				jQuery(oDiv).find(".wuiBrowser").modalDialog();
				break;
		    case 4: 
				var oDiv = document.createElement("div"); 
				<%if(isgoveproj==0){%>
				var sHtml = " " + 
        		<%}else{%>
					var sHtml = " " + 
					<%}%>
        					"<input class=wuiBrowser type='hidden' name='topiccrmid_"+rowindex+"' id='topiccrmid_"+rowindex+"' "+
        					" _url='/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp' >";
<%if(software.equals("ALL") || software.equals("CRM")){%>
				oDiv.innerHTML = sHtml;   
<%}%>
				oCell.appendChild(oDiv);  
				jQuery(oDiv).find(".wuiBrowser").modalDialog();
				break;
			case 5: 
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox' name='topicopen_"+rowindex+"' value='1'>"+SystemEnv.getHtmlLabelName(2161,user.getLanguage()) ; //文字
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
	
		}
	}
	rowindex = rowindex*1 +1;
	
}

function deleteRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node'){
			if(document.forms[0].elements[i].checked==true) {
				//oTable.deleteRow(rowsum1-1);	
				jQuery(document.forms[0].elements[i]).parents("tr:first").remove();
			}
			rowsum1 -=1;
		}
	
	}	
}	

function checkuse(){
    <%
    String tempbegindate="";
    String tempenddate="";
    String tempbegintime="";
    String tempendtime="";
    String tempAddress="0";
    RecordSet.executeSql("select Address,begindate,enddate,begintime,endtime from meeting where meetingstatus=2 and isdecision<2 and (cancel is null or cancel<>'1') and begindate>='"+currentdate+"'");
    while(RecordSet.next()){
        tempAddress=RecordSet.getString("Address");
        tempbegindate=RecordSet.getString("begindate");
        tempenddate=RecordSet.getString("enddate");
        tempbegintime=RecordSet.getString("begintime");
        tempendtime=RecordSet.getString("endtime");
   %>
   if(document.weaver.address.value=="<%=tempAddress%>"){
       if(!(document.weaver.begindate.value+" "+document.weaver.begintime.value>"<%=tempenddate+' '+tempendtime%>" || document.weaver.enddate.value+" "+document.weaver.endtime.value<"<%=tempbegindate+' '+tempbegintime%>")){
           return true;
       }
   }
   <%
    }
    %>
    return false;
}

function doSave(obj){
	if(check_form(document.weaver,'<%=needcheck%>')&&checkAddress()&&checkDateValidity(weaver.begindate.value,weaver.begintime.value,weaver.enddate.value,weaver.endtime.value,"<%=SystemEnv.getHtmlLabelName(16722,user.getLanguage())%>")){
		if(($G("hrmids02").value!="" && $G("hrmids02").value.length>0) || ($G("crmids02").value!="" && $G("crmids02").value.length>0) || checkHrm() || checkCrm()){
		var hashrmids=false;
        var lens = document.forms[0].elements.length;
        for(var i=0; i < lens;i++) {
            if ((document.forms[0].elements[i].name=='hrmids01' || document.forms[0].elements[i].name=='crmids01') && document.forms[0].elements[i].checked==true){
                hashrmids=true;
                break;
            }
        }
		if(document.weaver.hrmids02.value!="" || document.weaver.crmids02.value!="" || hashrmids){
	        obj.disabled = true;
			document.weaver.topicrows.value=rowindex;
			//document.weaver.submit();
			Ext.Ajax.request({
            form:document.weaver,
            method: 'POST',
            success: function(response, request)
			{
				window.parent.parent.returnValue = 0;
   	  			window.parent.parent.close();
			},
            failure: function ( result, request) 
            { 
				alert("Error!... ");
			},
            scope: this
        });
		}else{
            alert("<%=SystemEnv.getHtmlLabelName(20118,user.getLanguage())%>");
        }
		}else{
			alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
		}
	}
}

function doSubmit(obj){
    if(check_form(document.weaver,'<%=needcheck%>')&&checkAddress()&&checkDateValidity(weaver.begindate.value,weaver.begintime.value,weaver.enddate.value,weaver.endtime.value,"<%=SystemEnv.getHtmlLabelName(16722,user.getLanguage())%>")){
		if(($G("hrmids02").value!="" && $G("hrmids02").value.length>0) || ($G("crmids02").value!="" && $G("crmids02").value.length>0) || checkHrm() || checkCrm()){
	         var hashrmids=false;
	        var lens = document.weaver.elements.length;
	        for(var i=0; i < lens;i++) {
	            if ((document.weaver.elements[i].name=='hrmids01' || document.weaver.elements[i].name=='crmids01') && document.weaver.elements[i].checked==true){
	                hashrmids=true;
	                break;
	            }
	        }
	        if(checkuse()){
	            if(confirm("<%=SystemEnv.getHtmlLabelName(19095,user.getLanguage())%>")){
	                if(document.weaver.hrmids02.value!="" || document.weaver.crmids02.value!="" || hashrmids){
	                obj.disabled = true;
	                document.weaver.topicrows.value=rowindex;
	                document.weaver.method.value = "addSubmit";
	                //document.weaver.submit();
	                Ext.Ajax.request({
			            form:document.weaver,
			            method: 'POST',
			            success: function(response, request)
						{
							window.parent.parent.returnValue = 0;
			   	  			window.parent.parent.close();
						},
			            failure: function ( result, request) 
			            { 
							alert("Error!... ");
						},
			            scope: this
			        });
	                }else{
	                    alert("<%=SystemEnv.getHtmlLabelName(20118,user.getLanguage())%>");
	                }
	            }
	        }else{
	            if(document.weaver.hrmids02.value!="" || document.weaver.crmids02.value!="" || hashrmids || document.weaver.hrmids01.value!=""){
	                obj.disabled = true;
	                document.weaver.topicrows.value=rowindex;
	                document.weaver.method.value = "addSubmit";
	                //document.weaver.submit();
	                Ext.Ajax.request({
			            form:document.weaver,
			            method: 'POST',
			            success: function(response, request)
						{
							window.parent.parent.returnValue = 0;
			   	  			window.parent.parent.close();
						},
			            failure: function ( result, request) 
			            { 
							alert("Error!... ");
						},
			            scope: this
			        });
	                }else{
	                    alert("<%=SystemEnv.getHtmlLabelName(20118,user.getLanguage())%>");
	                }
	        }
			}else{
				alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
		  }
	}
}
function checkHrm(){
	var hashrmchecked = new Array();
	var hashrmid = false;
	hashrmchecked = document.getElementsByName("hrmids01");
	for(var i = 0; i < hashrmchecked.length; i++)
	{
		if(hashrmchecked[i].checked)
		{
			hashrmid = true;
		}
	}
	return hashrmid;
}
function checkCrm(){
	var hascrmchecked = new Array();
	var hascrmid = false;
	hascrmchecked = document.getElementsByName("crmids01");
	for(var i = 0; i < hascrmchecked.length; i++)
	{
		if(hascrmchecked[i].checked)
		{
			hascrmid = true;
		}
	}
	return hascrmid;
}

function checkDateValidity(begindate,begintime,enddate,endtime,errormsg){
	var isValid = true;
	if(compareDate(begindate,begintime,enddate,endtime) == 1){
		alert(errormsg);
		isValid = false;
	}
	return isValid;
}

function checkAddress()
{
	if("" == $G("address").value && "" == $G("customizeAddress").value)
	{
		alert("<%=SystemEnv.getHtmlLabelName(20393, user.getLanguage())%>");
		return false;
	}
	
	return true;
}

/*Check Date */
function compareDate(date1,time1,date2,time2){

	var ss1 = date1.split("-",3);
	var ss2 = date2.split("-",3);

	date1 = ss1[1]+"-"+ss1[2]+"-"+ss1[0] + " " +time1;
	date2 = ss2[1]+"-"+ss2[2]+"-"+ss2[0] + " " +time2;

	var t1,t2;
	t1 = Date.parse(date1);
	t2 = Date.parse(date2);
	if(t1==t2) return 0;
	if(t1>t2) return 1;
	if(t1<t2) return -1;

    return 0;
}

function countAttend()
{
	var count = 0;
	var pageArray = new Array();
	var countArray = new Array();
	var finalArray = new Array();
	var hascheckhrm = false;
	var hascheckcrm = false;
	
	if("" != $G("hrmids02").value)
	{
		pageArray = $G("hrmids02").value.split(",");
		countArray = countArray.concat(pageArray);
	}
	pageArray = document.getElementsByName("hrmids01");
	for(var i = 0; i < pageArray.length; i++)
	{
		if(pageArray[i].checked)
		{
			hascheckhrm = true;
			countArray.push(pageArray[i].value);
		}
	}
	for(var i = 0; i < countArray.length; i++)
	{
		var flag = true;
		var countString = countArray[i];
		for(var j = 0; j < finalArray.length; j++)
		{
			var finalString = finalArray[j];
			if(countString == finalString)
			{
				flag = false;
				break;
			}

		}
		if(flag)
		{
			finalArray.push(countString);
		}
	}
	count += finalArray.length;
	
	pageArray = new Array();
	countArray = new Array();
	finalArray = new Array();
	if("" != $G("crmids02").value)
	{
		pageArray = $G("crmids02").value.split(",");
		countArray = countArray.concat(pageArray);
	}
	pageArray = document.getElementsByName("crmids01");
	for(var i = 0; i < pageArray.length; i++)
	{
		if(pageArray[i].checked)
		{
			hascheckcrm = true;
			countArray.push(pageArray[i].value);
		}
	}
	//if(hascheckhrm == true){
		//if(document.all("crmids02").value==null || document.all("crmids02").value==""){
			//document.all("crmids02span").innerHTML = "";
		//}
	//}else{
		//if(document.all("crmids02").value==null || document.all("crmids02").value==""){
			//document.all("crmids02span").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		//}
	//}
	if(hascheckhrm==true || hascheckcrm==true || ($G("hrmids02").value!="" && $G("hrmids02").value.length>0) || ($G("crmids02").value!="" && $G("crmids02").value.length>0)){
		if($G("hrmids02").value==null || $G("hrmids02").value==""){
			$G("hrmids02Span").innerHTML = "";
		}
	}else{
		$G("hrmids02Span").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	}
	
	for(var i = 0; i < countArray.length; i++)
	{
		var flag = true;
		var countString = countArray[i];
		for(var j = 0; j < finalArray.length; j++)
		{
			var finalString = finalArray[j];
			if(countString == finalString)
			{
				flag = false;
				break;
			}

		}
		if(flag)
		{
			finalArray.push(countString);
		}
	}
	count += finalArray.length;

	if(count<1)
		$G("totalmemberspan").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	else
		$G("totalmemberspan").innerHTML = "";
	$G("totalmember").value = count;
}

function ItemCount_KeyPress_Plus()
{
	if(!(window.event.keyCode >= 48 && window.event.keyCode <= 57))
	{
		window.event.keyCode = 0;
	}
}
</script>
<script language=vbs>

sub  onShowHrmCaller(spanname,inputename,needinput)
	Dim id
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?sqlwhere=<%=xssUtil.put(whereclause)%>")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	document.all(spanname).innerHtml= id(1)
	document.all(inputename).value=id(0)
	else 
	if needinput = "1" then
	document.all(spanname).innerHtml= "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	else
	document.all(spanname).innerHtml= ""
	end if
	document.all(inputename).value=""
	end if
	end if
end sub

sub onShowCaller()
	Dim id
   id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/meeting/data/CallerBrowser.jsp?sqlwhere=<%=xssUtil.put(whereclause)%>") 	
	 if (Not IsEmpty(id)) then
	 if id(0)<> "" then
         document.all("Callerspan").innerHtml= id(1)
         document.all("caller").value=id(0)
   else
   	document.all("Callerspan").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
   	document.all("caller").value = ""
   end if
	 end if
end sub   

sub onShowHrm(spanname,inputename,needinput)
	Dim id
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	document.all(spanname).innerHtml= id(1)
	document.all(inputename).value=id(0)
	else 
	if needinput = "1" then
	document.all(spanname).innerHtml= "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	else
	document.all(spanname).innerHtml= ""
	end if
	document.all(inputename).value=""
	end if
	end if
end sub

sub onShowProjectID(objval)
	Dim id
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	projectidspan.innerHtml = id(1)
	weaver.projectid.value=id(0)
	else 
	if objval="2" then
				projectidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			else
				projectidspan.innerHtml =""
			end if
	weaver.projectid.value="0"
	end if
	end if
end sub

sub onShowMProj(spanname,inputname)
	Dim id
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	document.all(spanname).innerHtml = id(1)
	document.all(inputname).value=id(0)
	else 
	document.all(spanname).innerHtml =""
	document.all(inputname).value="0"
	end if
	end if
end sub

sub onShowMHrm(spanname,inputename)
		Dim tmpids
		Dim id1
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="&tmpids)
		    if (Not IsEmpty(id1)) then
				if id1(0)<> "" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.all(inputename).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&curname&"&nbsp"
					wend
					sHtml = sHtml&resourcename&"&nbsp"
					document.all(spanname).innerHtml = sHtml
					
				else
					document.all(spanname).innerHtml =""
					document.all(inputename).value=""
				end if
			end if
end sub

sub onShowMeetingHrm(spanname,inputename)
		Dim tmpids
		Dim id1
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="&tmpids)
		    if (Not IsEmpty(id1)) then
				if id1(0)<> "" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.all(inputename).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&curname&"&nbsp"
					wend
					sHtml = sHtml&resourcename&"&nbsp"
					document.all(spanname).innerHtml = sHtml
					
				else
					document.all(spanname).innerHtml ="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
					document.all(inputename).value=""
				end if
			end if
end sub


sub onShowMCrm(spanname,inputename)
		Dim tmpids
		Dim id1
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="&tmpids)
			if (Not IsEmpty(id1)) then	
				if id1(0)<> "" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.all(inputename).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&curname&"&nbsp"
					wend
					sHtml = sHtml&resourcename&"&nbsp"
					document.all(spanname).innerHtml = sHtml

				else
					document.all(spanname).innerHtml =""
					document.all(inputename).value=""
				end if
			end if
end sub

sub onShowAddress()
	Dim id
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/meeting/Maint/MeetingRoomBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	addressspan.innerHtml =id(1)
	weaver.address.value=id(0)
	customizeAddressspan.innerHtml = ""
	else
	addressspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	weaver.address.value=""
	customizeAddressspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	end if
	end if
end sub

</script>
</body>
</html>
<script language="javascript">

accessorynum = 2 ;
function addannexRow(){
	var nrewardTable = document.getElementById("AccessoryTable");
	var maxsize = document.getElementById("maxsize").value;
	oRow = nrewardTable.insertRow(-1);
	oRow.height=20;
	for(j=0; j<2; j++) {
		oCell = oRow.insertCell(-1);
		switch(j) {
    		case 0:
				var sHtml = "";
				oCell.innerHTML = sHtml;
				break;
	        case 1:
	       		oCell.className = "field";
	            var sHtml = "<input class=InputStyle  type=file name='accessory"+accessorynum+"' onchange='accesoryChanage(this)'>(<%=SystemEnv.getHtmlLabelName(18642,user.getLanguage())%>:"+maxsize+"M)";
				oCell.innerHTML = sHtml;
				break;
		}
	}
	document.getElementById("accessory_num").value = accessorynum ;
	accessorynum = accessorynum*1 +1;
	oRow1 = nrewardTable.insertRow(-1);
	oCell1 = oRow1.insertCell(-1);
    oCell1.colSpan = 2
    oCell1.className = "Line";
    $(oRow1).css("height","1px");
}
function accesoryChanage(obj){
	var secId = '<%=secId%>';
	if(secId=="")
	{
		alert("<%=SystemEnv.getHtmlLabelName(24429,user.getLanguage())%>!");
		obj.value = "";
		createAndRemoveObj(obj);
		return;
	}
    var objValue = obj.value;
    if (objValue=="") return ;
    var fileLenth;
    try {
        File.FilePath=objValue;
        fileLenth= File.getFileSize();
    } catch (e){
        try{
        	fileLenth=parseInt(obj.files[0].size);
        }catch (e) {
        	if(e.message=="Type mismatch")
                alert("<%=SystemEnv.getHtmlLabelName(21015,user.getLanguage())%> ");
                else
                alert("<%=SystemEnv.getHtmlLabelName(21090,user.getLanguage())%> ");
                createAndRemoveObj(obj);
                return  ;
		}
    	
    }
    alert(fileLenth);
    if (fileLenth==-1) {
        createAndRemoveObj(obj);
        return ;
    }
    //var fileLenthByM = (fileLenth/(1024*1024)).toFixed(1)
    var fileLenthByK =  fileLenth/1024;
		var fileLenthByM =  fileLenthByK/1024;
	
		var fileLenthName;
		if(fileLenthByM>=0.1){
			fileLenthName=fileLenthByM.toFixed(1)+"M";
		}else if(fileLenthByK>=0.1){
			fileLenthName=fileLenthByK.toFixed(1)+"K";
		}else{
			fileLenthName=fileLenth+"B";
		}
		maxsize = document.getElementById("maxsize").value;
    if (fileLenthByM>maxsize) {
        alert("<%=SystemEnv.getHtmlLabelName(20254,user.getLanguage())%>"+fileLenthByM+",<%=SystemEnv.getHtmlLabelName(20255,user.getLanguage())%>"+maxsize+"M<%=SystemEnv.getHtmlLabelName(20256,user.getLanguage())%>!");
        createAndRemoveObj(obj);
    }
}
   function CheckOnShowAddress(){
	 if((document.weaver.customizeAddress.value!="")&&(document.getElementById("addressspan").innerHTML=="")){
     alert("<%=SystemEnv.getHtmlLabelName(20888, user.getLanguage())%>");   
	 }
	 onShowAddress();		 
   } 
  function omd(){
	  var addressspan = document.getElementById("addressspan").innerHTML;
      if(document.getElementById("addressspan").innerHTML!="" && addressspan.indexOf("BacoError")<=0 && document.weaver.customizeAddress.value==""){
          alert("<%=SystemEnv.getHtmlLabelName(20889, user.getLanguage())%>");
	}
}
function checkaddress(obj){
	var addressspan = document.getElementById("addressspan").innerHTML;
    if(document.getElementById("addressspan").innerHTML!="" && addressspan.indexOf("BacoError")<=0 && document.weaver.customizeAddress.value==""){
        document.getElementById("customizeAddress").getAttribute('viewtype') = 0;
	}else{
		if((document.getElementById("addressspan").innerHTML!="" && addressspan.indexOf("BacoError")>0) || document.getElementById("addressspan").innerHTML==""){
			document.getElementById("customizeAddress").getAttribute('viewtype') = 1;
		}
	}
	if(obj.value!=""){
		if(addressspan.indexOf("BacoError") > 0){
			document.getElementById("addressspan").innerHTML = "";
		}
	}else{
		if(addressspan=="" || addressspan.indexOf("BacoError")>0){
			document.getElementById("addressspan").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		}
	}
}
function showRemindTime(obj)
{
	if("1" == obj.value)
	{
		$G("remindTime").style.display = "none";
		$G("remindTimeLine").style.display = "none";
	}
	else
	{
		$G("remindTime").style.display = "";
		$G("remindTimeLine").style.display = "";
	}
}
  
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>