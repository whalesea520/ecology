
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>

<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/rightspluingForBrowser_wev8.js"></script>

<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>

<%
//是否分权系统，如不是，则不显示框架，直接转向到列表页面
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("meetingdetachable")),0);
int forall=Util.getIntValue(request.getParameter("forall"), 0);
int subid=Util.getIntValue(request.getParameter("subCompanyId"));
if(subid<0){
        subid=user.getUserSubCompany1();
}

ArrayList subcompanylist=SubCompanyComInfo.getRightSubCompany(user.getUID(),"MeetingType:Maintenance");
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(2104,user.getLanguage());
String needfav ="1";
String needhelp ="";
int from = Util.getIntValue(request.getParameter("from"), -1);
String callbkfun = Util.null2String(request.getParameter("callbkfun"));
String names = Util.null2String(request.getParameter("names"));
int selsubCompanyId = Util.getIntValue(request.getParameter("selsubCompanyId"), -1);
String check_per = Util.null2String(request.getParameter("resourceids"));
String resourceids ="";
String resourcenames ="";

if (!check_per.equals("")) {
	if(check_per.indexOf(',')==0){
		check_per=check_per.substring(1);
	}
	String strtmp = "select * from meeting_type where id in ("+check_per+")";

	RecordSet.executeSql(strtmp);
	Hashtable ht = new Hashtable();
	while(RecordSet.next()){
		ht.put( Util.null2String(RecordSet.getString("id")), Util.null2String(RecordSet.getString("name")));
		/*
		if(check_per.indexOf(","+RecordSet.getString("id")+",")!=-1){

				resourceids +="," + RecordSet.getString("id");
				resourcenames += ","+RecordSet.getString("name");
		}
		*/
	}
	try{
		
		StringTokenizer st = new StringTokenizer(check_per,",");
	
		while(st.hasMoreTokens()){
			String s = st.nextToken();
			if(ht.containsKey(s)){//如果check_per中的已选的客户此时不存在会出错TD1612
				resourceids +=","+s;
				resourcenames += ","+ht.get(s).toString();
			}
		}
	}catch(Exception e){
		resourceids ="";
		resourcenames ="";
	}
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<!--########Shadow Table Start########-->
	<!--##############Right click context menu buttons START####################-->
		<%
		RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:submitOk(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		
		RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:btnOnSearch(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;

		RCMenu += "{"+SystemEnv.getHtmlLabelName(2022,user.getLanguage())+",javascript:resetCd(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;

		RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:closeDlg(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		
		RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		
		%>
		<BUTTON   id="btnsearch" style="display:none;" ><%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<!--##############Right click context menu buttons END//####################-->
	<!--######## Search Table Start########-->
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
		   <td>
		    </td>
			<td class="rightSearchSpan" style="text-align:right; ">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>" class="e8_btn_top middle" onclick="javascript:btnOnSearch();"/>
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
			</td>
		</tr>
	</table>
	<div id="tabDiv" >
		<span id="hoverBtnSpan" class="hoverBtnSpan">
				<span><%=SystemEnv.getHtmlLabelName(2104,user.getLanguage()) %></span>
		</span>
	</div>
	<div class="advancedSearchDiv" id="advancedSearchDiv">
	</div>
	<div class="zDialog_div_content">
	
<div style="max-height:155px;overflow:hidden;" id="e8QuerySearchArea">
	<FORM id="weaver" NAME="SearchForm" STYLE="margin-bottom:0" action="MutiMeetingTypeBrowserChld.jsp" onsubmit="return false;" method=post>
	<input type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
	<input type="hidden" name="pagenum" value=''>
	<input type="hidden" name="resourceids" value="">
	<input type="hidden" name="crmManager" value="">
	<input type="hidden" name="forall" value="<%=forall%>">
	<input type="hidden" name="from" id="from" value='<%=from%>'>
	<input type="hidden" name="callbkfun" id="callbkfun" value='<%=callbkfun%>'>
		<wea:layout type="4col">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(20331, user.getLanguage())%>' attributes="{'groupSHBtnDisplay':'none'}">
				<wea:item>
				<%=SystemEnv.getHtmlLabelName(2104,user.getLanguage())%>
				</wea:item>
				<wea:item>
					<input class=InputStyle type="text" name=names name=names value="<%=names %>">
				</wea:item>
				<%
					if (detachable == 1) {
				%>
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%>
				</wea:item>
				<wea:item>
					<brow:browser viewType="0" name="selsubCompanyId" browserValue='<%=""+selsubCompanyId%>' 
					browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?show_virtual_org=-1&selectedids=" 
					hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  width="150px"
					completeUrl="/data.jsp?type=164&show_virtual_org=-1" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
					browserSpanValue='<%=""+SubCompanyComInfo.getSubCompanyname(""+selsubCompanyId)%>'></brow:browser>
				</wea:item>
				<%
					}
				%>
			</wea:group>
		</wea:layout>
	</FORM>
		</div>
		<div id="dialog" >
		<div id='colShow'></div>
		</div>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom" >
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context="" attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					
					<input type="button" class="zd_btn_submit" accessKey=O id=btnok onclick="submitOk();" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>"></input>
					<input type="button" class="zd_btn_submit" accessKey=2 id=btnclear onclick="submitClear();" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>"></input>
					<input type="button" class="zd_btn_cancle" accessKey=T id=btncancel onclick="closeDlg();" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"></input>
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>

</BODY></HTML>

<script type="text/javascript">
var parentWin = parent.parent.parent.getParentWindow(parent.parent);
var dialog = parent.parent.parent.getDialog(parent.parent);

jQuery(document).ready(function(){
	resizeDialog(document);
	showMultiDocDialog("<%=check_per%>");
});
var config = null;
function showMultiDocDialog(selectids){
	config= rightsplugingForBrowser.createConfig();
	<%if (detachable == 1) {%>
		config.srchead=["<%=SystemEnv.getHtmlLabelName(2104,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%>"];
    <%} else {%>
		config.srchead=["<%=SystemEnv.getHtmlLabelName(2104,user.getLanguage())%>"];
	<%}%>
	config.container =$("#colShow");
    config.searchLabel="";
    config.hiddenfield="id";
    config.saveLazy = true;
    config.srcurl = "/meeting/Maint/MutiMeetingTypeBrowserAjax.jsp?forall=<%=forall%>&src=src";
    config.desturl = "/meeting/Maint/MutiMeetingTypeBrowserAjax.jsp?forall=<%=forall%>&src=dest";
    config.pagesize = 10;
    config.formId = "weaver";
    config.searchAreaId = "e8QuerySearchArea";
    config.selectids = selectids;
    try{
		config.dialog = dialog;
	}catch(e){
		alert(e)
	}
    jQuery("#colShow").html("");
    rightsplugingForBrowser.createRightsPluing(config);
    jQuery("#btnok").bind("click",function(){
     rightsplugingForBrowser.system_btnok_onclick(config);
    });
    jQuery("#btnclear").bind("click",function(){
     rightsplugingForBrowser.system_btnclear_onclick(config);
    });
    jQuery("#btncancel").bind("click",function(){
     rightsplugingForBrowser.system_btncancel_onclick(config);
    });
    jQuery("#btnsearch").bind("click",function(){
     rightsplugingForBrowser.system_btnsearch_onclick(config);
    });
}
	function submitOk(){
		rightsplugingForBrowser.system_btnok_onclick(config);
	}

	function submitClear()
	{
		rightsplugingForBrowser.system_btnclear_onclick(config);
	}
	
	function returnValue(returnjson){
		if(1 == <%=from%>){
		<%if(!"".equals(callbkfun)){%>
			<%="parentWin."+callbkfun+"(returnjson);"%>
		<%}%>
		} else {
			if(dialog){
				try{
					dialog.callback(returnjson);
				 }catch(e){}

				try{
					 dialog.close(returnjson);
				 }catch(e){}
			}else{ 
				window.parent.parent.returnValue  = returnjson;
				window.parent.parent.close();
			}
		}
	}
	
	function closeDlg(){
		rightsplugingForBrowser.system_btncancel_onclick(config);
	}
	
function resetCd(){
	resetCondtionBrw('weaver');
}

function btnOnSearch(){
	jQuery("#btnsearch").trigger("click");
}
</script>
