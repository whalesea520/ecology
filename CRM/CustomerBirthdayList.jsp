
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" /> <!--added by xwj for td2044 on 2005-05-30-->
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(621,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:window.frmmain.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%

int currentMonth=Calendar.getInstance().get(Calendar.MONTH)+1;

String firstName=Util.null2String(request.getParameter("firstName"));
String customerName=Util.null2String(request.getParameter("customerName"));
int month=Util.getIntValue(request.getParameter("month"),currentMonth);
String day=Util.null2String(request.getParameter("day"));

%>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input type="text" class="searchInput"  id="searchName" name="searchName" value="<%=firstName%>"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr><td class="rightSearchSpan" style="text-align:right;">
			
	</td></tr>
</table>


<!-- 高级搜索 -->
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
<form id=weaver name=frmmain method=post action="/CRM/CustomerBirthdayList.jsp">	
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%>'>
		  <wea:item><%=SystemEnv.getHtmlLabelName(887,user.getLanguage())%></wea:item>
		  <wea:item>
			  	<select id="month" name="month" _defaultValue="<%=month %>">
			  		<%for(int i=1;i<=12;i++){
			  		%>
					<option value="<%=i%>" <%if(i==month){ %>selected="selected"<%} %>>
						<%=i%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>
					</option>
					<%}%>
				</select>
				<select id="day" name="day" _defaultValue="<%=day %>">
					<option value="" <%if(day.equals("")){ %>selected="selected"<%} %>>
			  		<%for(int i=1;i<=31;i++){
			  			String daystr=i<10?("0"+i):(""+i);
			  		%>
					<option value="<%=daystr%>" <%if(daystr.equals(day)){ %>selected="selected"<%} %>>
						<%=daystr%>
					</option>
					<%}%>
				</select>
		  </wea:item>                    
	  
	  	  <wea:item><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></wea:item>
		  <wea:item>
		 		<input type="text" name="firstName" id="firstName" value="<%=firstName%>"/>
		  </wea:item>
	  
		  <wea:item><%=SystemEnv.getHtmlLabelName(1268,user.getLanguage())%></wea:item>
		  <wea:item>
				<input type="text" name="customerName" id="customerName" value="<%=customerName%>"/>
		  </wea:item>
		  
	</wea:group>
	
	<wea:group context="" attributes="{'Display':'none'}">
		<wea:item type="toolbar">
			<input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(82529,user.getLanguage())%>" id="searchBtn"/>
			<span class="e8_sep_line">|</span>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(27088,user.getLanguage())%>" class="e8_btn_cancel"  onclick="resetCondition()"/>
			<span class="e8_sep_line">|</span>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32694,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		</wea:item>
		
	</wea:group>
</wea:layout>
</form>
</div>


<%

String language=String.valueOf(user.getLanguage());
String leftjointable = CrmShareBase.getTempTable(""+user.getUID());

String backfields="id,firstname,customerName,title,phoneoffice,mobilephone,email,customerid,birthday,";

if(RecordSet.getDBType().equals("oracle")){
	backfields +=  " substr(birthday,6,4) as birthdaydata";
  }else{
	backfields +=  " substring(birthday,6,4) as birthdaydata";
}

String sqlstr="select id as cutomerid,manager,name as customerName from CRM_CustomerInfo t1 left join "+leftjointable+" t2 on t1.id = t2.relateditemid ";
String searchstr=" where t1.deleted = 0  and t1.id = t2.relateditemid ";

String sqlFrom  = " CRM_CustomerContacter t1,("+sqlstr+searchstr+") t2";
String sqlWhere=" t1.customerid=t2.cutomerid and birthday is not null ";

if(!"".equals(firstName))
	sqlWhere+=" and firstName like '%"+firstName+"%'";

if(!"".equals(customerName))
	sqlWhere+=" and customerName like '%"+customerName+"%'";


if(RecordSet.getDBType().equals("oracle")){
  	sqlWhere +=  " and substr(birthday,6,2) = '"+(month<10?"0":"")+month+"' ";
  }else{
  	sqlWhere +=  " and substring(birthday,6,2) = '"+(month<10?"0":"")+month+"'";
}

if(!day.equals("")){
	if(RecordSet.getDBType().equals("oracle")){
	  	sqlWhere +=  " and substr(birthday,9,2) = '"+day+"' ";
	  }else{
	  	sqlWhere +=  " and substring(birthday,9,2) = '"+day+"'";
	}
}

String tableString=""+
			  "<table  pageId=\""+PageIdConst.CRM_Birthday+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_Birthday,user.getUID(),PageIdConst.CRM)+"\" tabletype=\"checkbox\">"+
			  "<sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlprimarykey=\"id\" sqlorderby=\"birthdaydata\" sqlsortway=\"ASC\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"/>"+
			  "<head>";
			  
tableString += "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(1268,user.getLanguage())+"\" column=\"customerName\" orderkey=\"customerName\" target=\"_fullwindow\" linkkey=\"CustomerID\" linkvaluecolumn=\"customerid\" href=\"/CRM/data/ViewCustomer.jsp\" />";
tableString += "<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(572,user.getLanguage())+"\" column=\"firstname\" orderkey=\"firstname\" target=\"_fullwindow\" linkkey=\"ContacterID\" linkvaluecolumn=\"id\" href=\"/CRM/contacter/ContacterView.jsp\" />";
tableString += "<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(462,user.getLanguage())+"\" column=\"title\" transmethod=\"weaver.crm.Maint.ContacterTitleComInfo.getContacterTitlename\" />";
tableString += "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(661,user.getLanguage())+"\" column=\"phoneoffice\"/>";
tableString += "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(422,user.getLanguage())+"\" column=\"mobilephone\" linkvaluecolumn=\"mobilephone\" href=\"javascript:sendSMS('{0}')\"/>";
tableString += "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(20869,user.getLanguage())+"\" column=\"email\" linkvaluecolumn=\"email\" href=\"javascript:sendMail('{0}')\"/>";
tableString += "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(1964,user.getLanguage())+"\" column=\"birthday\" orderkey=\"birthday\" otherpara='"+user.getLanguage()+"' transmethod=\"weaver.crm.Maint.CRMTransMethod.getBirthdayFormate\" pkey=\"birthday+weaver.crm.Maint.CRMTransMethod.getBirthdayFormate\"/>";

tableString	+=	"</head></table>";
%>
<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.CRM_Birthday%>">
<wea:SplitPageTag tableString='<%=tableString%>'  mode="run" isShowTopInfo="true" />
		
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<script type="text/javascript">

$(document).ready(function(){
			
		jQuery("#topTitle").topMenuTitle({searchFn:searchName});
		jQuery("#hoverBtnSpan").hoverBtn();
				
});
//阻止事件冒泡函数
function stopBubble(e){
	if (e && e.stopPropagation){
		e.stopPropagation()
	}else{
		window.event.cancelBubble=true
	}
}

function searchName(){
	var searchName = jQuery("#searchName").val();
	$("#firstName").val(searchName);
	window.frmmain.submit();
}

function sendMail(email){
	var url= "/email/new/MailInBox.jsp?opNewEmail=1&isInternal=0&to="+email;
	openFullWindowHaveBar(url);
}

function sendSMS(number){
	var url= "/sms/SmsMessageEditTab.jsp?customernumber="+number;
	openFullWindowHaveBar(url);
}

function getDialog(title, width ,height){
	var dialog =new window.top.Dialog();
    dialog.currentWindow = window; 
    dialog.Modal = true;
    dialog.Drag=true;
	dialog.Width =width?width:680;
	dialog.Height =height?height:420;
	dialog.Title = title;
	return dialog;
}
	
</script>
</body>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
