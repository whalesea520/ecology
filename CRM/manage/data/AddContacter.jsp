
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />

<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetFF" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<%
String CustomerID = Util.null2String(request.getParameter("CustomerID"));
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
String frombase =  Util.null2String(request.getParameter("frombase"));
boolean hasFF = true;
RecordSetFF.executeProc("Base_FreeField_Select","c2");
if(RecordSetFF.getCounts()<=0)
	hasFF = false;
else
	RecordSetFF.first();

RecordSet.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
if(RecordSet.getCounts()<=0)
{
	response.sendRedirect("/base/error/DBError.jsp");
	return;
}
RecordSet.first();

/*权限判断－－Begin*/

String useridcheck=""+user.getUID();
String customerDepartment=""+RecordSet.getString("department") ;
boolean canedit=false;
boolean isCustomerSelf=false;

//String ViewSql="select * from CrmShareDetail where crmid="+CustomerID+" and usertype=1 and userid="+user.getUID();

//RecordSetV.executeSql(ViewSql);

//if(RecordSetV.next())
//{
//	 if(RecordSetV.getString("sharelevel").equals("2") || RecordSetV.getString("sharelevel").equals("3") || RecordSetV.getString("sharelevel").equals("4")){
//		canedit=true;
//	 }
//}
int sharelevel = CrmShareBase.getRightLevelForCRM(""+user.getUID(),CustomerID);
if(sharelevel>1) canedit=true;

if(user.getLogintype().equals("2") && CustomerID.equals(useridcheck)){
isCustomerSelf = true ;
}

if(useridcheck.equals(RecordSet.getString("agent"))){
	 canedit=true;
 }

if(RecordSet.getInt("status")==7 || RecordSet.getInt("status")==8){
	canedit=false;
}

/*权限判断－－End*/

if(!canedit && !isCustomerSelf) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
 }
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(572,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(136,user.getLanguage())+":<a href='/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+RecordSet.getString("id")+"'>"+Util.toScreen(RecordSet.getString("name"),user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";
%>
<BODY onbeforeunload="protectContacter()">
<%if(!isfromtab){ %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%} %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(589,user.getLanguage())+",javascript:document.weaver.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
if(frombase.equals("1")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.close(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}else{
	if(!isfromtab){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:location.href='/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+CustomerID+"',_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}else{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:location.href='/CRM/data/ViewCustomerBase.jsp?log=n&CustomerID="+CustomerID+"',_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
}
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

<FORM id=weaver name="weaver" action="/CRM/data/ContacterOperation.jsp" method=post onsubmit='return check_form(this,"Title,FirstName,JobTitle,Manager")' enctype="multipart/form-data">
<input type="hidden" name="method" value="add">
<input type="hidden" name="CustomerID" value="<%=CustomerID%>">
<input type="hidden" name="isfromtab" value="<%=isfromtab %>">
<input type="hidden" name="frombase" value="<%=frombase%>">
	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
  		</COLGROUP>
        <TBODY>
        <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing style='height:1px'>
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(462,user.getLanguage())%></TD>
          <TD class=Field>
              <INPUT type=hidden class="wuiBrowser" _required="yes" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/ContacterTitleBrowser.jsp" name=Title></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=14 name="FirstName"  onchange='checkinput("FirstName","FirstNameimage")'><SPAN id=FirstNameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(475,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=14 name="LastName" ></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(640,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 size=30 name="JobTitle" onchange='checkinput("JobTitle","JobTitleimage")'><SPAN id=JobTitleimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <!-- 增加联系人项目角色、意向判断、关注点字段开始 QC16057-->
        <TR>
          <TD>项目角色</TD>
          <TD class=Field>
          	<INPUT class=InputStyle maxLength=100 size=30 name="projectrole" />
          </TD>
        </TR>
        <tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD>意向判断</TD>
          <TD class=Field>
          	<select name="attitude">
          		<option value=""></option>
          		<option value="支持我方">支持我方</option>
          		<option value="未表态">未表态</option>
          		<option value="未反对">未反对</option>
          		<option value="反对">反对</option>
          	</select>
          </TD>
        </TR>
        <tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD>关注点</TD>
          <TD class=Field>
          	<INPUT class=InputStyle maxLength=200 size=50 name="attention" />
          </TD>
        </TR>
        <tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <!-- 增加联系人项目角色、意向判断、关注点字段结束 -->
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></TD>
          <TD class=Field><INPUT name="CEmail" class=InputStyle maxLength=150 size=30 onblur="mailValid()"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(420,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=20 size=30 name="PhoneOffice"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(619,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=20 size=30 name="PhoneHome"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=20 size=30 name="Mobile"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=20 size=30 name="CFax"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>

		<TR>
		 <TD><%=SystemEnv.getHtmlLabelName(6066,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 size=30 name="interest"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		 <TD><%=SystemEnv.getHtmlLabelName(6067,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 size=30 name="hobby"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>		 <TD><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(596,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 size=30 name="managerstr"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>		 <TD><%=SystemEnv.getHtmlLabelName(442,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(460,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 size=30 name="subordinate"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
		<TR>
		 <TD><%=SystemEnv.getHtmlLabelName(6068,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 size=30 name="strongsuit"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <%--<TR>--%>
		 <%--<TD><%=SystemEnv.getHtmlLabelName(671,user.getLanguage())%></TD>--%>
        <%--  <TD class=Field><INPUT class=InputStyle maxLength=3 size=10 name="age" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("age")'></TD>--%>
        <%--</TR><tr><td class=Line colspan=2></td></tr>--%>
		<TR>
		 <TD><%=SystemEnv.getHtmlLabelName(1884,user.getLanguage())%></TD>
          <TD class=Field><button type="button" class=Calendar id=selectbirthday onClick="getbirthday()"></button><span id=birthdayspan></span>
		  <INPUT type = "hidden" class=InputStyle name="birthday"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(17534,user.getLanguage())%></TD>
          <TD class=Field><%=SystemEnv.getHtmlLabelName(17548,user.getLanguage())%><INPUT class=InputStyle maxLength=2 size=5 name="birthdaynotifydays" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("birthdaynotifydays")' value="<%=Util.toScreenToEdit(RecordSet.getString("birthdaynotifydays"),user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		 <TD><%=SystemEnv.getHtmlLabelName(1967,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 size=30 name="home"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		 <TD><%=SystemEnv.getHtmlLabelName(1518,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 size=30 name="school"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		 <TD><%=SystemEnv.getHtmlLabelName(803,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 size=30 name="speciality"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		 <TD><%=SystemEnv.getHtmlLabelName(1840,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 size=30 name="nativeplace"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		 <TD><%=SystemEnv.getHtmlLabelName(1887,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 size=30 name="IDCard"  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("IDCard")'  ></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		 <TD><%=SystemEnv.getHtmlLabelName(812,user.getLanguage())%></TD>
          <TD class=Field>
		  <TEXTAREA class=InputStyle NAME=experience ROWS=3 STYLE="width:60%"></TEXTAREA></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>

        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%></TD>
          <TD class=Field>
              <INPUT type=hidden class="wuiBrowser" _displayText="<%=Util.toScreen(LanguageComInfo.getLanguagename(""+user.getLanguage()),user.getLanguage())%>" _url="/systeminfo/BrowserMain.jsp?url=/systeminfo/language/LanguageBrowser.jsp" name=Language value="<%=user.getLanguage()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
<%if(!user.getLogintype().equals("2")) {%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></TD>
          <TD class=Field>
              <INPUT class=wuiBrowser _displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>" _required="yes" _displayText="<%=user.getUsername()%>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" type=hidden name=Manager value="<%=user.getUID()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
<%}else{%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></TD>
          <TD class=Field> <span
            id=manageridspan></span>
              <INPUT class=InputStyle type=hidden name=Manager value="<%=RecordSet.getString("manager")%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
<%}%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1262,user.getLanguage())%></TD>
          <TD class=Field><INPUT type=checkbox name="Main" value="1"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
    <!--    <TR>
          <TD><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=5 size=5 name="Photo" value="0"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        -->
        
        <TR>
		 <TD><%=SystemEnv.getHtmlLabelName(25101,user.getLanguage())%><!-- IM号码--></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 size=30 name="imcode"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        
        <TR>
		 <TD><%=SystemEnv.getHtmlLabelName(25102,user.getLanguage())%><!-- 状态 --></TD>
          <TD class=Field>
          	<select name="status">
          		<option value="1"><%=SystemEnv.getHtmlLabelName(2246,user.getLanguage())%><!-- 有效 --></option>
          		<option value="0"><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%><!-- 离职 --></option>
          		<option value="2"><%=SystemEnv.getHtmlLabelName(463,user.getLanguage())%><!-- 未知 --></option>
          	</select>
          </TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        
        <TR>
		 <TD><%=SystemEnv.getHtmlLabelName(25103,user.getLanguage())%><!-- 是否需要联系 --></TD>
          <TD class=Field>
          	<select name="isneedcontact">
          		<option value="1"><%=SystemEnv.getHtmlLabelName(25104,user.getLanguage())%><!-- 是 --></option>
          		<option value="0"><%=SystemEnv.getHtmlLabelName(25105,user.getLanguage())%><!-- 否 --></option>
          	</select>
          </TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(24976,user.getLanguage())%><!-- 客服负责人 --></TD>
          <TD class=Field>
              <button class=Browser id=SelectDeparment onClick="onShowResource('principalSpan','principalIds')"></button> 
              <span class=InputStyle id=principalSpan></span> 
              <input type=hidden name=principalIds>
          </TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        
        <TR>
           <TD><%=SystemEnv.getHtmlLabelName(15707,user.getLanguage())%></TD>
            <TD class=Field>
              <input class=inputstyle type="file" maxLength=100 size=30  name="photoid">
            </TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        
        </TBODY>
	  </TABLE>

	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
  		</COLGROUP>
        <TBODY>
        <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(73,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing style="height: 1px">
          <TD class=Line1 colSpan=2></TD></TR>
<%
if(hasFF)
{
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+1).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2)%></TD>
          <TD class=Field>
          <BUTTON type="button" class=Calendar onclick="getCrmDate(<%=i%>)"></BUTTON>
              <SPAN id=datespan<%=i%> ></SPAN>
              <input type="hidden" name="dff0<%=i%>" id="dff0<%=i%>">
          </TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+11).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2+10)%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=30 size=30 name="nff0<%=i%>" value="0.0"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+21).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2+20)%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 size=30 name="tff0<%=i%>"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+31).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2+30)%></TD>
          <TD class=Field>
          <INPUT type=checkbox  name="bff0<%=i%>" value="1"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<%}
	}
}
%>
        </TBODY>
	  </TABLE>

	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
  		</COLGROUP>
        <TBODY>
        <TR class=Title>
            <TH colSpan=4><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing style="height: 1px;">
          <TD class=Line1 colSpan=2></TD></TR>
		<TR>
		  <TD rowspan="1" colspan=2><TEXTAREA class=InputStyle NAME=Remark ROWS=3 STYLE="width:100%"></TEXTAREA>
		  </TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TD>
          <TD class=Field>
      	<INPUT class=wuiBrowser _displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}'>#b{name}</a>" _url="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp" type=hidden name=RemarkDoc value=0></TD>  </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
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
<SCRIPT language="javascript">
//added by lupeng 2004.06.04.
function mailValid() {
	var emailStr = document.all("CEmail").value;
	emailStr = emailStr.replace(" ","");
	if (!checkEmail(emailStr)) {
		alert("<%=SystemEnv.getHtmlLabelName(18779,user.getLanguage())%>");
		document.all("CEmail").focus();
		return;
	}
}

function onSave(obj){
	window.onbeforeunload=null;
	if(check_form(document.weaver,'Title,FirstName,JobTitle')){
		obj.disabled=true;
	    	weaver.submit();
	}
}
function protectContacter(){
	if(!checkDataChange())//added by cyril on 2008-06-12 for TD:8828
		event.returnValue="<%=SystemEnv.getHtmlLabelName(19004,user.getLanguage())%>";
}
function onShowResource(spanname, inputname) {
    tmpids = document.all(inputname).value;
    if(tmpids!="-1"){ 
     url="/hrm/resource/MutiResourceBrowser.jsp?resourceids="+tmpids;
    }else{
     url="/hrm/resource/MutiResourceBrowser.jsp";
    }
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
    try {
        jsid = new VBArray(id).toArray();
    } catch(e) {
        return;
    }
    if (jsid != null) {
        if (jsid[0] != "0" && jsid[1]!="") {
            document.all(spanname).innerHTML = jsid[1].substring(1);
            document.all(inputname).value = jsid[0].substring(1);
        } else {
            document.all(spanname).innerHTML = "";
            document.all(inputname).value = "";
        }
    }
}
</SCRIPT>
</BODY>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<!-- added by cyril on 2008-06-12 for td8828-->
<script language=javascript src="/js/checkData_wev8.js"></script>
<!-- end by cyril on 2008-06-12 for td8828-->
</HTML>
