
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SalaryComInfo" class="weaver.hrm.finance.SalaryComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
boolean hasright=true;
if(!HrmUserVarify.checkUserRight("Compensation:Manager", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int operatelevel=0;
if(detachable==1){
	if(user.isAdmin()){//管理员没有分部，下面分部有控制，这里不做处理
		
	}else{
    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"Compensation:Manager",Util.getIntValue(DepartmentComInfo.getSubcompanyid1(ResourceComInfo.getDepartmentID(""+user.getUID()))));
    if(operatelevel<1){
        if(operatelevel<0){
            response.sendRedirect("/notice/noright.jsp");
            return;
        }else{
            hasright=false;
        }
    }
	}
}
String subcompanyids=SubCompanyComInfo.getRightSubCompany(user.getUID(),"Compensation:Manager",0);
ArrayList subcompanylist=Util.TokenizerString(subcompanyids,",");
ArrayList itemlist=new ArrayList();
String items="";
for(int i=0;i<subcompanylist.size();i++){
    ArrayList tempitems=SalaryComInfo.getSubCompanyItemByType(Util.getIntValue((String)subcompanylist.get(i)),"'1'",false);
    for(int j=0;j<tempitems.size();j++){
        if(itemlist.indexOf((String)tempitems.get(j))<0){
            itemlist.add((String)tempitems.get(j));
        }
    }
}
for(int i=0;i<itemlist.size();i++){
    if(items.equals("")){
        items=(String)itemlist.get(i);
    }else{
        items+=","+itemlist.get(i);
    }
}
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#frmmain").submit();
}
</script>
</HEAD>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(2218,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(hasright){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(hasright){%>
				<input type=button class="e8_btn_top" onclick="submitData();" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"></input>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=frmmain name=frmmain action="HrmSalaryOperation.jsp" method=post >
<input class=inputstyle type="hidden" name="method" value="changesalary">
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
  	<wea:item><%=SystemEnv.getHtmlLabelName(15818,user.getLanguage())%></wea:item> 
    <wea:item>
			<%
			String url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?sqlwhere="+xssUtil.put("hr.subcompanyid1 in("+subcompanyids+")");
			%>
      <brow:browser viewType="0" name="multresourceid" browserValue="" 
          browserUrl='<%=url %>'hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
          completeUrl="/data.jsp">
      </brow:browser>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15815,user.getLanguage())%></wea:item> 
    <wea:item>
    	<%
    	String url = "/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/finance/salary/SalaryItemBrowser.jsp?sqlwhere="+xssUtil.put("where id in("+items+") and itemtype = 1 ");
    	String completeUrl = "/data.jsp?type=SalaryItem&whereClause="+xssUtil.put(" id in("+items+") and itemtype = 1");
    	%>
      <brow:browser viewType="0" name="itemid" browserValue="" 
          browserUrl='<%=url %>'hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
          completeUrl='<%=completeUrl %>' width="210px">
      </brow:browser>
    </wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(534,user.getLanguage())%></wea:item>
		<wea:item>
			<select name="changetype" style="width: 80px">
				<option value="1"><%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%></option>
				<option value="2"><%=SystemEnv.getHtmlLabelName(457,user.getLanguage())%></option>
				<option value="3"><%=SystemEnv.getHtmlLabelName(15816,user.getLanguage())%></option>
			</select>
		  <INPUT class=inputstyle maxLength=50 size=10 style="width: 100px" name="salary" onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);checkinput("salary","salaryimage")' value="">
		  <SPAN id=salaryimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
		</wea:item> 
		<wea:item><%=SystemEnv.getHtmlLabelName(1897,user.getLanguage())%></wea:item>
		<wea:item>
		    <textarea class=inputstyle id="changeresion" name="changeresion" cols="60" rows="6"></textarea>
		</wea:item> 
	</wea:group>
</wea:layout>
</FORM>

<script language=javascript>  
function submitData() {
 if(check_form(document.frmmain,"multresourceid,itemid,salary")){
 document.frmmain.submit();
 }
}

function onShowResource(spanname , inputname){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?sqlwhere=where subcompanyid1 in(<%=subcompanyids%>) ");
	if (data!=null){
	    if (data.id!= ""){ 
	        spanname.innerHTML = data.name.substr(1,data.name.length);
	        inputname.value = data.id.substr(1,data.id.length);
	    }else{
	        spanname.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	        inputname.value = "";
	    }
	}
}

function onShowItemId(tdname,inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/finance/salary/SalaryItemBrowser.jsp?sqlwhere=where id in(<%=items%>) and itemtype = '1' ");
	if (data!=null){ 
		if (data.id!=0){
	        tdname.innerHTML = data.name;
	        inputename.value=data.id;
		}else{
	        tdname.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	        inputename.value = "";
		}
	}
}
</script>
</BODY>
</HTML>
