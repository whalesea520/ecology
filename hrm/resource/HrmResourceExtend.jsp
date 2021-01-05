<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.common.Tools"%> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<html>
<% if(!HrmUserVarify.checkUserRight("HrmResourceAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String resourceid=Util.null2String(request.getParameter("resourceid"));
if(resourceid.equals("undefined"))resourceid="";
boolean hasFF = true;
rs.executeProc("Base_FreeField_Select","hr");
if(rs.getCounts()<=0)
	hasFF = false;
else
	rs.first();
	
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6089,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(179,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM name=resource id=resource action="HrmResourceStatusOperation.jsp" method=post>
<input class=inputstyle type=hidden name=operation value="extend">
<%
String errmsg = Util.null2String(request.getParameter("errmsg"));
if(errmsg.equals("1")){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getHtmlLabelName(16078,user.getLanguage())%>
</div>
<%}%>        
  <table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="doSave(this);" value="<%=SystemEnv.getHtmlLabelName(615, user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
	</table>
		<wea:layout>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelName(16079,user.getLanguage())%></wea:item>
        <wea:item>
			  <%
			  String lastname = "";
			  if(resourceid.length()>0) lastname = resourceComInfo.getLastnameAllStatus(resourceid);
			  String subcomstr=SubCompanyComInfo.getRightSubCompany(user.getUID(),"HrmResourceAdd:Add",0);
			  String sqlwhere = " status in(0,1,2,3) ";
			  String browserUrl = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MultiResourceBrowserByRight.jsp?rightStr=HrmResourceAdd:Add&fromHrmStatusChange=HrmResourceExtend&sqlwhere="+xssUtil.put(sqlwhere)+"&selectedids=";
			  String completeUrl = "/data.jsp?whereClause="+xssUtil.put(" t1.subcompanyid1 in("+subcomstr+")");
			  %>
	        <brow:browser viewType="0" name="resourceid" browserValue='<%=resourceid %>' 
	             browserUrl='<%=browserUrl %>' 
	             hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
	             completeUrl='<%=completeUrl %>' linkUrl="javascript:openhrm($id$)"
	             browserSpanValue='<%=lastname %>'>     
	        </brow:browser>
        <!-- 
        <BUTTON class=Browser type="button" onclick="onShowResourceID(resourceid,resourceidspan)"></BUTTON>
          <SPAN id=resourceidspan>
            <%if(resourceid.equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}else{%>
              <a href="HrmResource.jsp?id=<%=resourceid%>"><%=resourceComInfo.getLastname(resourceid)%></a>
          <%}%>
          </SPAN>
          <input class=inputstyle type=hidden name=resourceid value="<%=resourceid%>">
         -->
        </wea:item>
        <wea:item><%=SystemEnv.getHtmlLabelName(16080,user.getLanguage())%></wea:item>
        <wea:item>
            <select class=inputstyle name=status value="1" style="width: 120px">         
              <option value="1"><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></option>
              <option value="2"><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></option>
            </select>             
        </wea:item>
        <wea:item><%=SystemEnv.getHtmlLabelName(15970,user.getLanguage())%></wea:item>
        <wea:item><BUTTON class=Calendar type="button" id=selectcontractdate onclick="getchangedate()"></BUTTON> 
          <SPAN id=changedatespan ><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN>
          <input class=inputstyle type="hidden" name="changedate">
        </wea:item> 
        <wea:item><%=SystemEnv.getHtmlLabelName(15971,user.getLanguage())%></wea:item>
        <wea:item><BUTTON class=Calendar type="button" id=selectcontractdate onclick="getchangeenddate()"></BUTTON> 
          <SPAN id=changeenddatespan ><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN>
          <input class=inputstyle type="hidden" name="changeenddate">
        </wea:item>
        <wea:item><%=SystemEnv.getHtmlLabelName(16081,user.getLanguage())%></wea:item>
        <wea:item>
          <textarea class=inputstyle rows=5 cols=40 name="changereason"></textarea>
        </wea:item>
        <wea:item><%=SystemEnv.getHtmlLabelName(16082,user.getLanguage())%></wea:item>
        <wea:item>
         	<brow:browser viewType="0" name="changecontractid" browserValue="" 
            browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/contract/contract/HrmContractBrowser.jsp?status=1"
            hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
            completeUrl="/data.jsp?type=HrmContract&whereClause=status=1" width="240px"
            browserSpanValue="">
           </brow:browser> 
         <!-- 
        <input class="wuiBrowser" type=hidden name=changecontractid
 			_url="/systeminfo/BrowserMain.jsp?url=/hrm/contract/contract/HrmContractBrowser.jsp"
 			_displayTemplate="<A href='/hrm/contract/contract/HrmContractEdit.jsp?id=#b{id}'>#b{name}</A>"> 
          -->             
        </wea:item>
        <wea:item><%=SystemEnv.getHtmlLabelName(16083,user.getLanguage())%></wea:item>
        <wea:item>
	     	<span>
	  		<brow:browser viewType="0" name="infoman" browserValue="" 
	           browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
	           hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
	           completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="240px"
	           browserSpanValue=""></brow:browser>
	      	</span>
	      	<!-- 
		    <BUTTON class=Browser type="button" onClick="onShowResource(infoman,infomanspan)">
		    </BUTTON>
		    <span class=inputstyle id=infomanspan>
		    </span>
		    <INPUT class=inputstyle id=organizer type=hidden name=infoman >
	      	 -->
         </wea:item>
			</wea:group>
		</wea:layout>
</FORM>
<script language=vbs>
sub onShowContract()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/contract/contract/HrmContractBrowser.jsp?status=1 ")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	contractspan.innerHtml = "<A href='/hrm/contract/contract/HrmContractEdit.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.changecontractid.value=id(0)
	else
	contractspan.innerHtml = ""
	resource.changecontractid.value=""
	end if
	end if
end sub


</script>
<script language="javascript">
function disModalDialogRtnM(url, inputname, spanname) {
	var id = window.showModalDialog(url);
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			var ids = wuiUtil.getJsonValueByIndex(id, 0).substr(1);
			var names = wuiUtil.getJsonValueByIndex(id, 1).substr(1);

			jQuery(inputname).val(ids);
			var sHtml = "";
			var ridArray = ids.split(",");
			var rNameArray = names.split(",");

			linkurl = ""

			for ( var i = 0; i < ridArray.length; i++) {

				var curid = ridArray[i];
				var curname = rNameArray[i];

				sHtml += "<a tatrget='_blank' href=/hrm/resource/HrmResource.jsp?id=" + curid + ">" + curname + "</a>&nbsp;";
			}

			jQuery(spanname).html(sHtml);
		} else {
			jQuery(inputname).val("")
			jQuery(spanname).html("");
		}
	}
}

function onShowResource(tdname,inputename){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	if(results){
	  if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	  	 jQuery($GetEle(tdname)).html("<a href='javascript:openhrm("+wuiUtil.getJsonValueByIndex(results,0)+")'>"+wuiUtil.getJsonValueByIndex(results,1)+"</a>");
	     jQuery("input[name='"+inputename+"']")[0].value=wuiUtil.getJsonValueByIndex(results,0);
	  }else{
	     jQuery($GetEle(tdname)).html("");
	     jQuery("input[name='"+inputename+"']").val("");
	  }
	}
}

function onShowResource1(inputname,spanname){
	disModalDialogRtnM("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp",inputname,spanname)
}

function onShowResourceID(inputname,spanname){
	disModalDialogRtnM("/systeminfo/BrowserMain.jsp?url=/hrm/resource/browser/extend/MutiResourceBrowser.jsp",inputname,spanname)
}


function doSave(obj) {
    if(check_form(document.resource,"resourceid,changedate,changeenddate")&&checkDateRange(resource.changedate,resource.changeenddate,"<%=SystemEnv.getHtmlLabelName(16721,user.getLanguage())%>"))
	{
    	obj.disabled=true;
        document.resource.submit();
     }
}

function jsChangeContractId(inputName,spanName){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/contract/contract/HrmContractBrowser.jsp");
	if (datas){
		if (datas.id!=""){
			var showName = "<A href=javascript:openFullWindowForXtable('/hrm/contract/contract/HrmContractEdit.jsp?id="+datas.id+"')>"+datas.name+"</A>";
			$(inputName).val(datas.id);
			$(spanName).html(showName);			
		}else{
			$(spanName).html( "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			$(inputName).val( "");
		}
	}
}
</script>
<%@include file="../include.jsp"%>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>

