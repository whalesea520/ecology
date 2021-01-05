<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<%!
//2004-6-16 Edit by Evan:得到user的级别，总部的user可以看到所有部门，分部和部门级的user只能看到所属的部门
    private String getDepartmentSql(User user){
        String sql ="";
        String rightLevel = HrmUserVarify.getRightLevel("HrmResourceEdit:Edit",user);
        int departmentID = user.getUserDepartment();
        int subcompanyID = user.getUserSubCompany1();
        if(rightLevel.equals("2") ){
          //总部级别的，什么也不返回
        }else if (rightLevel.equals("1")){ //分部级别的
          sql = " WHERE subcompanyid1="+subcompanyID ;
        }else if (rightLevel.equals("0")){ //部门级别
          sql = " WHERE id="+departmentID ;
        }
        //System.out.println("sql = "+sql);
        return sql;
    }
//End Edit
%>
<HTML><HEAD>
<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.getParentWindow(window);
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
function showAlert(msg){
    window.top.Dialog.alert(msg);
}
function showConfirm(msg){
    return confirm(msg);
}
function checkPass(){
    saveBtn.disabled = true;
    document.resource.submit() ;
}
</script>
<SCRIPT language="javascript" src="/js/chechinput_wev8.js"></script>
</HEAD>
<%

int msgid = Util.getIntValue(request.getParameter("msgid"),-1);

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(179,user.getLanguage());
String needfav ="1";
String needhelp ="";
String departmentid = Util.null2String(request.getParameter("departmentid"));
boolean flagaccount = weaver.general.GCONST.getMOREACCOUNTLANDING();
String ifinfo = Util.null2String(request.getParameter("ifinfo"));//检查loginid参数
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1402,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<iframe id="checkHas" src="" style="display:none"></iframe>
<%
/*登录名冲突*/
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<%
      if(ifinfo.equals("y")){
      %>
      <DIV>
     <font color=red size=2>
     <%=SystemEnv.getHtmlLabelName(25170,user.getLanguage())%>
      </div>
            <%}%>
<FORM name=resource id=resource action="/hrm/resource/HrmResourceOperation.jsp" method=post enctype="multipart/form-data">
<input class=inputstyle type=hidden name=operation value="addresourcebasicinfo">
<input class=inputstyle type=hidden name=isDialog value="1"> 
<input class=inputstyle type=hidden name=urlFrom value="departmentList"> 
<%
  String sql = "select max(id) from HrmResource";
  rs.executeSql(sql);
  rs.next();
  int id = rs.getInt(1);
  sql = "select max(id) from HrmCareerApply";
  rs.executeSql(sql);
  rs.next();
  if(id<rs.getInt(1)){
    id = rs.getInt(1);
  }
    id +=1;
%>
<input class=inputstyle type=hidden name=id value="<%=id%>">
  <TABLE class=ViewForm>
    <TBODY>
    <TR>
      <TD vAlign=top>
        <TABLE width=100%>
          <COLGROUP> 
          <COL width=30%> 
          <COL width=70%>
          <TBODY>
          <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR class=Spacing style="height:2px">
            <TD class=Line1 colSpan=2></TD>
          </TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></TD>
            <TD class=Field>
              <INPUT class=InputStyle maxLength=30 size=30 name="workcode" onchange="this.value=trim(this.value)">
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
            <TD class=Field>
              <INPUT class=InputStyle maxLength=30 size=30 name="lastname" onchange='checkinput("lastname","lastnamespan");this.value=trim(this.value)'>
              <SPAN id=lastnamespan>
               <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
              </SPAN>
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <%if(flagaccount){%>
          <TR>
                      <TD><%=SystemEnv.getHtmlLabelName(17745,user.getLanguage())%></TD>
            <TD class=Field>
              <select class=InputStyle id=accounttype name=accounttype onchange="if(this.options[0].selected) {belongtodata.style.display='none';belongtoline.style.display='none';}else {belongtodata.style.display='';belongtoline.style.display='';}  ">
                <option value=0 selected><%=SystemEnv.getHtmlLabelName(17746,user.getLanguage())%></option>
                <option value=1><%=SystemEnv.getHtmlLabelName(17747,user.getLanguage())%></option>
              </select>
            </TD>
          </TR>
          <TR style="height:1px;">
          <TD class=Line colSpan=2></TD></TR>
          <TR id=belongtodata style="display:none">
            <TD><%=SystemEnv.getHtmlLabelName(17746,user.getLanguage())%></TD>
            <TD class=Field>
              <BUTTON type="button" class=Browser id=SelectBelongto onClick="onBelongto()"></BUTTON>
              <span id=belongtospan>
              <img src="/images/BacoError_wev8.gif" align=absMiddle>
              </span>
              <INPUT  id=belongto type=hidden name=belongto>
            </TD>
          </TR>
          <TR style="height:1px"><TD id=belongtoline class=Line colSpan=2 style="display:none"></TD></TR>
          <%}%>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></TD>
            <TD class=Field>
              <select class=InputStyle id=sex name=sex>
                <option value=0 selected><%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%></option>
                <option value=1><%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%></option>
              </select>
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(15707,user.getLanguage())%></TD>
            <TD class=Field>
              <input class=inputstyle type="file" name="photoid">
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD height=><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
            <TD class=Field >
              <BUTTON class=Browser type="button" id=SelectDepartment onclick="onShowDepartment()"></BUTTON>
              <SPAN id=departmentspan>
                <%=DepartmentComInfo.getDepartmentname(departmentid)%>
               <!--IMG src="/images/BacoError_wev8.gif" align=absMiddle-->
              </SPAN>
              <INPUT class=inputstyle id=departmentid type=hidden name=departmentid value=<%=departmentid%>>
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
<!--
<%  if(software.equals("ALL") || software.equals("HRM")){%>
          <TR>
            <TD height=><%=SystemEnv.getHtmlLabelName(515, user.getLanguage())%></TD>
            <TD class=Field >
              <BUTTON type="button" class=Browser id=SelectCostcenter onclick="onShowCostcenter()"></BUTTON>
              <SPAN id=costcenterspan>
               <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
              </SPAN>
              <INPUT class=inputstyle id=costcenterid type=hidden name=costcenterid>
            </TD>
          </TR>
<%}else{%>
              <INPUT class=inputstyle id=costcenterid type=hidden name=costcenterid value='1'>
<%}%>
          <TR>
-->         <INPUT class=inputstyle id=costcenterid type=hidden name=costcenterid value='1'>

            <TD><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TD>
            <TD class=Field>
              <BUTTON class=Browser type="button" id=SelectJobTitle onclick="onShowJobtitle()"></BUTTON>
              <SPAN id=jobtitlespan>
               <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
              </SPAN>
              <INPUT class=inputstyle id=jobtitle type=hidden name=jobtitle>
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(806,user.getLanguage())%></TD>
            <TD class=Field>
              <INPUT id=jobcall type=hidden name=jobcall class=wuiBrowser 
              _url="/systeminfo/BrowserMain.jsp?url=/hrm/jobcall/JobCallBrowser.jsp">
              <SPAN id=jobcallspan>
              </SPAN>
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(1909,user.getLanguage())%></td>
            <td class=Field>
              <input class=InputStyle maxlength=3 size=5 name=joblevel onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("joblevel")'>
            </td>
          </tr>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
	  <TR>
      <TD><%=SystemEnv.getHtmlLabelName(15708,user.getLanguage())%></TD>
            <TD class=Field>
              <INPUT class=InputStyle maxLength=90 size=30 name=jobactivitydesc>
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
	  <TR>
            <TD><%=SystemEnv.getHtmlLabelName(15709,user.getLanguage())%></TD>
            <TD class=Field>
              <INPUT class=wuiBrowser id=managerid type=hidden name=managerid _required=yes
              _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
              _displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'target='_blank'>#b{name}</A>">
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD id=lblAss><%=SystemEnv.getHtmlLabelName(441,user.getLanguage())%></TD>
            <TD class=Field id=txtAss>
              <INPUT class=wuiBrowser id=assistantid type=hidden name=assistantid
              _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
              _displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'target='_blank'>#b{name}</A>">
            <SPAN id=assistantidspan></SPAN>
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
            <TD class=Field>
                <select class=inputstyle name=status value="0">
                  <option value="0"><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></option>
                  <option value="1"><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></option>
                  <option value="2"><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></option>
                </select>
            </TD>
          </TR>
            <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD id=lblLocation><%=SystemEnv.getHtmlLabelName(15712,user.getLanguage())%></TD>
            <TD class=Field id=txtLocation>
              <INPUT class=wuiBrowser id=locationid type=hidden name=locationid _required=yes
              _url="/systeminfo/BrowserMain.jsp?url=/hrm/location/LocationBrowser.jsp">
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <tr>
            <td id=lblRoom><%=SystemEnv.getHtmlLabelName(420,user.getLanguage())%></td>
            <td class=Field id=txtRoom>
              <input class=InputStyle maxlength=30 size=30 name=workroom>
            </td>
          </tr>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(661,user.getLanguage())%></TD>
            <TD class=Field>
              <INPUT class=InputStyle maxLength=25 size=30 name=telephone>
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%></TD>
            <TD class=Field>
              <INPUT class=InputStyle maxLength=25 size=30  name=mobile>
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(15714,user.getLanguage())%></TD>
            <TD class=Field>
              <INPUT class=InputStyle maxLength=15 size=30 name=mobilecall>
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></TD>
            <TD class=Field>
              <INPUT class=InputStyle maxLength=15 size=30 name=fax>
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(20869,user.getLanguage())%></TD>
            <TD class=Field>
              <input class=inputstyle type=text name=email value="">
            </TD>
          </TR>
         <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></TD>
            <TD class=Field>
              <input class=inputstyle type=text name=dsporder value="">
            </TD>
          </TR>
         <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <%
            boolean hasFF = true;
            rs.executeProc("Base_FreeField_Select","hr");
            if(rs.getCounts()<=0)
                hasFF = false;
            else
                rs.first();

            if(hasFF){
                for(int i=1;i<=5;i++)
                {
                    if(rs.getString(i*2+1).equals("1"))
                    {%>
                          <TR>
                            <TD><%=rs.getString(i*2)%></TD>
                            <TD class=Field>
                                
                                <input class=wuiDate type="hidden" name="datefield<%=(i-1)%>" value="">
                            </TD>
                          </TR>
                        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
                          <%}
                }
                for(int i=1;i<=5;i++)
                {
                    if(rs.getString(i*2+11).equals("1"))
                    {%>
                          <TR>
                            <TD><%=rs.getString(i*2+10)%></TD>
                            <TD class=Field>
                                <input class=InputStyle  name="numberfield<%=(i-1)%>" value="" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("numberfield<%=(i-1)%>")'>
                            </TD>
                          </TR>
                         <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
                          <%}
                }
                for(int i=1;i<=5;i++)
                {
                    if(rs.getString(i*2+21).equals("1"))
                    {%>
                          <TR>
                            <TD><%=rs.getString(i*2+20)%></TD>
                            <TD class=Field>
                                <input class=InputStyle  name="textfield<%=(i-1)%>" value="">
                            </TD>
                          </TR>
                        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
                          <%}
                }
                for(int i=1;i<=5;i++)
                {
                    if(rs.getString(i*2+31).equals("1"))
                    {%>
                          <TR>
                            <TD><%=rs.getString(i*2+30)%></TD>
                            <TD class=Field>
                              <INPUT class=inputstyle type=checkbox  name="tinyintfield<%=(i-1)%>" value="1">
                            </TD>
                          </TR>
                   <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
                          <%}
                }
            }

            %>
          </TBODY>
        </TABLE>
   </FORM>
   
   <%if("1".equals(isDialog)){ %>
    </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">	</div>
	<table width="100%">
	    <tr><td  class="btnTd" colspan="3">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="doSave(this);">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentWin.closeDialog();">
	    </td></tr>
	</table>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %> 
</td>
</tr>
</TABLE>
<script language=vbs>
sub onShowManagerID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	manageridspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.managerid.value=id(0)
	else
	manageridspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	resource.managerid.value=""
	end if
	end if
end sub

sub onShowAssistantID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	assistantidspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.assistantid.value=id(0)
	else
	assistantidspan.innerHtml = ""
	resource.assistantid.value=""
	end if
	end if
end sub

sub onShowLocationID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/location/LocationBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	locationidspan.innerHtml = id(1)
	resource.locationid.value=id(0)
	else
	locationidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	resource.locationid.value=""
	end if
	end if
end sub

sub onShowJobcall()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobcall/JobCallBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	jobcallspan.innerHtml = id(1)
	resource.jobcall.value=id(0)
	else
	jobcallspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	resource.jobcall.value=""
	end if
	end if
end sub

sub onShowJobType()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtype/JobtypeBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	jobtypespan.innerHtml = id(1)
	resource.jobtype.value=id(0)
	else
	jobtypespan.innerHtml = ""
	resource.jobtype.value=""
	end if
	end if
end sub

</script>
<SCRIPT LANGUAGE="JavaScript">
<!--
	
//-->
</SCRIPT>
<script language="JavaScript">
function onShowDepartment(){
//2004-6-16 Edit by Evan :传sql参数给部门浏览页面
    url=encode("/hrm/company/DepartmentBrowser2.jsp?isedit=1&rightStr=HrmResourceAdd:Add&sqlwhere=<%=xssUtil.put(getDepartmentSql(user))%>&selectedids="+jQuery("input[name=departmentid]").val());
    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
//2004-6-16 End Edit
	issame = false;
	if (data!=null){
		if (data.id != 0 ){
			if (data.id == jQuery("input[name=departmentid]").val()){
				issame = true;
			}
			jQuery("#departmentspan").html(data.name);
			jQuery("input[name=departmentid]").val(data.id);
		}else{
			jQuery("#departmentspan").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			jQuery("input[name=departmentid]").val("");
		}
		if (issame == false){
				jQuery("#jobtitlespan").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
				jQuery("input[name=jobtitle]").val("");
			//	costcenterspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			//	resource.costcenterid.value=""
		}
	}
}

function onShowCostCenter(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/CostcenterBrowser.jsp?sqlwhere= where departmentid="+jQuery("input[name=departmentid]").val());
	if (data!=null){
		if (data.id != 0 ){
			jQuery("#costcenterspan").html(data.name);
			jQuery("input[name=costcenterid]").val(data.id);
		}else{
			jQuery("#costcenterspan").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			jQuery("input[name=costcenterid]").val("");
		}
	}
}

function onShowJobtitle(){ 
	url=encode("/hrm/jobtitles/JobTitlesBrowser.jsp?sqlwhere= where jobdepartmentid="+jQuery("input[name=departmentid]").val()+"&fromPage=add");
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
	if (data!=null){
		if (data.id != 0 ){
			jQuery("#jobtitlespan").html(data.name);
			jQuery("input[name=jobtitle]").val(data.id);
		}else{
			jQuery("#jobtitlespan").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			jQuery("input[name=jobtitle]").val("");
		}
	}
}

function onBelongto(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?from=add&sqlwhere=(accounttype is null or accounttype=0)");
	if (data!=null){
		if (data.id != ""){
			jQuery("#belongtospan").html("<A href='/hrm/resource/HrmResource.jsp?id="+data.id+"'>"+data.name+"</A>");
			jQuery("input[name=belongto]").val(data.id);
		}else{
			jQuery("#belongtospan").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			jQuery("input[name=belongto]").val("");
		}
	}
}

var saveBtn ;
function encode(str){     
       return escape(str);
    }
function doSave(obj) {
   saveBtn = obj;
if(jQuery("input[name=managerid]").val()==""&&!confirm("<%=SystemEnv.getHtmlLabelName(16072,user.getLanguage())%>")){
  }else{
	  //alert(document.resource.accounttype.value)
	  if(<%=flagaccount%>){
 if(document.resource.accounttype.value ==0){
	  if(document.resource.departmentid.value==""||
     document.resource.costcenterid.value==""||
     document.resource.jobtitle.value==""||
     document.resource.locationid.value==""){
     window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
  }else{
    if(check_form(document.resource,'lastname,locationid')){
      //document.resource.submit() ;
      //alert("HrmResourceCheck.jsp?lastname="+document.all("lastname").value+"&workcode="+document.all("workcode").value);

      jQuery("#checkHas")[0].src="/hrm/resource/HrmResourceCheck.jsp?lastname="+jQuery("input[name=lastname]").val()+"&workcode="+jQuery("input[name=workcode]").val();
    }
  }  
	  }else{
	  if(document.resource.departmentid.value==""||
     document.resource.costcenterid.value==""||
     document.resource.jobtitle.value==""||
	  document.resource.belongto.value==""||
     document.resource.locationid.value==""){
     window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>")
  }else{
    if(check_form(document.resource,'lastname,locationid')){
      //document.resource.submit() ;
      //alert("HrmResourceCheck.jsp?lastname="+document.all("lastname").value+"&workcode="+document.all("workcode").value);

      jQuery("#checkHas")[0].src="/hrm/resource/HrmResourceCheck.jsp?lastname="+jQuery("input[name=lastname]").val()+"&workcode="+jQuery("input[name=workcode]").val();
    }
  }  
	  }}else{
	  if(document.resource.departmentid.value==""||
     document.resource.costcenterid.value==""||
     document.resource.jobtitle.value==""||
     document.resource.locationid.value==""){
     window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>")
  }else{
    if(check_form(document.resource,'lastname,locationid')){
      //document.resource.submit() ;
      //alert("HrmResourceCheck.jsp?lastname="+document.all("lastname").value+"&workcode="+document.all("workcode").value);

      jQuery("#checkHas")[0].src="/hrm/resource/HrmResourceCheck.jsp?lastname="+jQuery("input[name=lastname]").val()+"&workcode="+jQuery("input[name=workcode]").val();
    }
  }
	  }

}
}
</script>


<script language="vbs">
sub onShowBrowser(id,id2,url,linkurl,type1,ismand)

	if type1= 2 or type1 = 19 then
		id1 = window.showModalDialog(url,,"dialogHeight:320px;dialogwidth:275px")
		document.all("span"+id2).innerHtml = id1
		document.all("dateField"+id).value=id1
	else
		if type1 <> 17 and type1 <> 18 and type1<>27 and type1<>37 and type1<>4 and type1<>167 and type1<>164 and type1<>169 and type1<>170 then
			id1 = window.showModalDialog(url)
		elseif type1=4 or type1=167 or type1=164 or type1=169 or type1=170 then
            tmpids = document.all("dateField"+id).value
			id1 = window.showModalDialog(url&"?selectedids="&tmpids)
		else
			tmpids = document.all("dateField"+id).value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
		end if
		if NOT isempty(id1) then
			if type1 = 17 or type1 = 18 or type1=27 or type1=37 then
				if id1(0)<> ""  and id1(0)<> "0" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.all("dateField"+id).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
					document.all("span"+id2).innerHtml = sHtml

				else
					if ismand=0 then
						document.all("span"+id2).innerHtml = empty
					else
						document.all("span"+id2).innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					end if
					document.all("dateField"+id).value=""
				end if

			else
			   if  id1(0)<>""   and id1(0)<> "0"  then
			        if linkurl = "" then
						document.all("span"+id2).innerHtml = id1(1)
					else
						document.all("span"+id2).innerHtml = "<a href="&linkurl&id1(0)&">"&id1(1)&"</a>"
					end if
					document.all("dateField"+id).value=id1(0)
				else
					if ismand=0 then
						document.all("span"+id2).innerHtml = empty
					else
						document.all("span"+id2).innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					end if
					document.all("dateField"+id).value=""
				end if
			end if
		end if
	end if
end sub
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src='/js/datetime_wev8.js?rnd="+Math.random()+"'></script>
<SCRIPT language="javascript" defer="defer" src='/js/JSDateTime/WdatePicker_wev8.js?rnd="+Math.random()+"'></script>
</HTML>
