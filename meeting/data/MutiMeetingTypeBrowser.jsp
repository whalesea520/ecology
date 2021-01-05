
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

<style type="text/css">
#departmentid, #country1 {
	width:100%;
}
</style>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/rightspluingForBrowser_wev8.js"></script>
<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>
<%
//是否分权系统，如不是，则不显示框架，直接转向到列表页面
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("meetingdetachable")),0);
int subid=Util.getIntValue(request.getParameter("subCompanyId"));
if(subid<0){
        subid=user.getUserSubCompany1();
}

ArrayList subcompanylist=SubCompanyComInfo.getRightSubCompany(user.getUID(),"MeetingType:Maintenance");
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(2104,user.getLanguage());
String needfav ="1";
String needhelp ="";
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
<!--##############Right click context menu buttons START####################-->
		<DIV align=right style="display:none">
		<%
		RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		%>
		<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>


		<%
		RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:document.SearchForm.btnok.click(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		%>
		<BUTTON class=btn accessKey=O id=btnok onclick="btnok_onclick(event)"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>

		<%
		RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		%>
		<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>


		<%
		RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		%>
		<BUTTON class=btn accessKey=2 id=btnclear onclick="btnclear_onclick(event);"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
		</DIV>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<!--##############Right click context menu buttons END//####################-->
<div class="zDialog_div_content">
	<!--########Shadow Table Start########-->
	<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="MutiMeetingTypeBrowser.jsp" method=post>
	<input type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
	<input type="hidden" name="pagenum" value=''>
	<input type="hidden" name="resourceids" value="">
	<input type="hidden" name="crmManager" value="">
	
	<!--######## Search Table Start########-->
		<wea:layout type="4col">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(20331, user.getLanguage())%>' >
				<wea:item>
				<%=SystemEnv.getHtmlLabelName(2104,user.getLanguage())%>
				</wea:item>
				<wea:item>
					<input class=InputStyle  name=names name=names value="<%=names %>">
				</wea:item>
				<%
					if (detachable == 1) {
				%>
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%>
				</wea:item>
				<wea:item>
					<brow:browser viewType="0" name="selsubCompanyId" browserValue='<%=""+selsubCompanyId%>' 
					browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=" 
					hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  width="150px"
					completeUrl="/data.jsp?type=164" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
					browserSpanValue='<%=""+SubCompanyComInfo.getSubCompanyname(""+selsubCompanyId)%>'></brow:browser>
				</wea:item>
				<%
					}
				%>
			</wea:group>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(320,user.getLanguage())%>' >
				<wea:item attributes="{'isTableList':\"true\"}">
					<div id="dialog">
					<div id='colShow'></div>
					</div>
				</wea:item>
			</wea:group>
		</wea:layout>
	</FORM>
<!--#################Search Table END//######################-->

	<!--############Browser Table START################-->
	<!--
	<TABLE class=BroswerStyle cellspacing="0" cellpadding="0" style="width:100%;height:410px">
		<TR class=DataHeader>
			<TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
			
			<TH width="50%">会议类型</TH>
		<%
				if (detachable == 1) {
		%>			
			<TH width="50%"><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></TH>
		<%
			}
		%>
			
			  
		</tr>

		<tr>
		<td  width="100%" height="360px" valign="top" >
			<div style="overflow-y:scroll;width:100%;height:360px">
			<table width="100%" id="BrowseTable"  style="width:100%;">
				<%

                String sqlWhere = "";
                if(!"".equals(names)) sqlWhere += " and name like '%"+names+"%' ";
				if(detachable==1){
					String subcompanys=SubCompanyComInfo.getRightSubCompanyStr1(""+subid,subcompanylist);
					for(int i=0; i<subcompanylist.size(); i++){
						if(!"".equals(subcompanys)){
							subcompanys += ","+(String)subcompanylist.get(i);
						}else{
							subcompanys = (String)subcompanylist.get(i);
						}
					}
					if( selsubCompanyId > 0){
						sqlWhere += " and subcompanyid = "+selsubCompanyId+" ";
					} else {
						if(subcompanys.length()>0){
						    sqlWhere += " and subcompanyid in("+subcompanys+") ";
						}else{
							if(HrmUserVarify.checkUserRight("MeetingType:Maintenance",user)){
								sqlWhere += " and 1=2 ";
							}else{
								sqlWhere += " and subcompanyid="+user.getUserSubCompany1()+" ";
							}
						}
					}
				}
				String prmSql = " and exists ( "+
					" SELECT 1 FROM MeetingType_share b where meeting_type.id = b.mtid and b.departmentid = "+user.getUserDepartment()+" and b.deptlevel <= "+user.getSeclevel()+" AND b.deptlevelMax >= "+user.getSeclevel()+" AND b.permissiontype = 1 "+
					" UNION ALL "+
					" SELECT 1 FROM MeetingType_share b where meeting_type.id = b.mtid and b.subcompanyid in ("+
				        user.getUserSubCompany1()+","+user.getUserSubCompany2()+","+user.getUserSubCompany3()+","+user.getUserSubCompany4()+") and b.sublevel <= "+user.getSeclevel()+" and b.sublevelMax >= "+user.getSeclevel()+" AND b.permissiontype = 6 "+
				    " UNION ALL "+
				    " SELECT 1 FROM MeetingType_share b where meeting_type.id = b.mtid and b.seclevel <= "+user.getSeclevel()+" and b.seclevelMax >= "+user.getSeclevel()+" AND b.permissiontype = 3 "+
				    " UNION ALL "+
				    " SELECT 1 FROM MeetingType_share b where meeting_type.id = b.mtid AND b.userid = "+user.getUID()+" AND b.permissiontype = 5 "+
				    " UNION ALL "+
				    " SELECT 1 FROM MeetingType_share b, hrmRoleMembers hr WHERE meeting_type.id = b.mtid AND hr.roleid = b.roleid AND hr.resourceid = "+user.getUID()+" AND hr.rolelevel > b.rolelevel AND b.seclevel <= "+user.getSeclevel()+" and b.seclevelMax >= "+user.getSeclevel()+" AND b.permissiontype = 2 ) ";
				sqlWhere += prmSql;
				if(sqlWhere.length() > 4){
					sqlWhere = sqlWhere.substring(4);
					RecordSet.executeSql("select * from meeting_type where "+sqlWhere);
				} else {
					RecordSet.executeSql("select * from meeting_type ");
				}

				boolean isLight = false;
				int i=0;
				int totalline=1;
				while(RecordSet.next()){
					String id = RecordSet.getString("id");
					String name = Util.null2String(RecordSet.getString("name"));
					String subcompanyid = Util.null2String(RecordSet.getString("subcompanyid"));
					if(i==0){
						i=1;
				%>
					<TR class=DataLight>
					<%
						}else{
							i=0;
					%>
					<TR class=DataDark>
					<%
					}
					%>
					<TD style="display:none"><A HREF=#><%=id%></A></TD>
					
				<td width="50%" style="word-break:break-all"> <%=name%></TD>
				<%
				if (detachable == 1) {
				%>		
				<TD width="50%" style="word-break:break-all"><%=SubCompanyComInfo.getSubCompanyname(subcompanyid)%>
				</TD>
				<%
				}
				%>
				</TR>
				<%
					
				}
				//RecordSet.executeSql("drop table "+temptable);
				%>
						</table>
						<table align=right style="display:none">
						<tr>
						   <td>&nbsp;</td>
						   <td>
							   
						   </td>
						   <td>
							   
						   </td>
						   <td>&nbsp;</td>
						</tr>
						</table>
			</div>
		</td>
	</tr>
	</TABLE>
	-->

<!--##########Browser Table END//#############-->

	<!--########Select Table Start########-->
	
	<!--########//Select Table End########-->


		<!--##############Shadow Table END//######################-->

</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar">
				<BUTTON class=btn accessKey=S  id=btnsearch><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
				<BUTTON class=btn accessKey=O  id=btnok><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
				<BUTTON class=btn accessKey=2  id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
				<BUTTON class=btnReset accessKey=T  id=btncancel><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</BODY></HTML>

<script type="text/javascript">
jQuery(document).ready(function(){
	showMultiDocDialog("<%=check_per%>");
});

function showMultiDocDialog(selectids){
	var config = null;
	config= rightsplugingForBrowser.createConfig();
	config.srchead=["<%=SystemEnv.getHtmlLabelName(24986,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(2094,user.getLanguage())%>"];
    config.container =$("#colShow");
    config.searchLabel="";
    config.hiddenfield="id";
    config.saveLazy = true;
    config.srcurl = "/docs/docs/MutiDocBrowserAjax.jsp?src=src";
    config.desturl = "/docs/docs/MutiDocBrowserAjax.jsp?src=dest";
    config.pagesize = 10;
    config.formId = "weaver";
    config.target = "queryIframe";
    config.selectids = selectids;
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

function btnOnSearch(){
 jQuery("#btnsearch").trigger("click");
}


<!--
	resourceids = "<%=resourceids%>";
	resourcenames = "<%=resourcenames%>";
	function btnclear_onclick(){
	    window.parent.parent.returnValue = {id:"",name:""};
	    window.parent.parent.close();
	}


jQuery(document).ready(function(){
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
	jQuery("#BrowseTable").bind("mouseover",BrowseTable_onmouseover);
	jQuery("#BrowseTable").bind("mouseout",BrowseTable_onmouseout);
})


function btnok_onclick(){
	 setResourceStr();
	 if(resourceids.length > 0){
		resourceids = resourceids.substr(1);
		resourcenames = resourcenames.substr(1);
	 }
	 window.parent.parent.returnValue = {id:resourceids,name:resourcenames};
    window.parent.parent.close();
}

function btnsub_onclick(){
    setResourceStr();
   $("#resourceids").val(resourceids);
   document.SearchForm.submit();
}
	
function BrowseTable_onclick(e){
	var target =  e.srcElement||e.target ;
	try{
		if(target.nodeName == "TD" || target.nodeName == "A"){
			var newEntry = $($(target).parents("tr")[0].cells[0]).text()+"~"+jQuery.trim($($(target).parents("tr")[0].cells[1]).text()) ;
			if(!isExistEntry(newEntry,resourceArray)){
				addObjectToSelect($("select[name=srcList]")[0],newEntry);
				reloadResourceArray();
			}
		}
	}catch (en) {
		alert(en.message);
	}
}
function BrowseTable_onmouseover(e){
	var e=e||event;
   var target=e.srcElement||e.target;
   if("TD"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }else if("A"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }
}
function BrowseTable_onmouseout(e){
	var e=e||event;
   var target=e.srcElement||e.target;
   var p;
	if(target.nodeName == "TD" || target.nodeName == "A" ){
      p=jQuery(target).parents("tr")[0];
      if( p.rowIndex % 2 ==0){
         p.className = "DataDark";
      }else{
         p.className = "DataLight";
      }
   }
}
//-->
</script>
<script language="javascript">
//var resourceids = "<%=resourceids%>"
//var resourcenames = "<%=resourcenames%>"

//Load
var resourceArray = new Array();
for(var i =1;i<resourceids.split(",").length;i++){
	
	resourceArray[i-1] = resourceids.split(",")[i]+"~"+resourcenames.split(",")[i];
	//alert(resourceArray[i-1]);
}

loadToList();
function loadToList(){
	var selectObj = $("select[name=srcList]")[0];
	for(var i=0;i<resourceArray.length;i++){
		addObjectToSelect(selectObj,resourceArray[i]);
	}
	
}
/**
加入一个object 到Select List
 格式object ="1~董芳"
*/
function addObjectToSelect(obj,str){
	//alert(obj.tagName+"-"+str);
	
	if(obj.tagName != "SELECT") return;
	var oOption = document.createElement("OPTION");
	obj.options.add(oOption);
	oOption.value = str.split("~")[0];
	$(oOption).text(str.split("~")[1]);
	
}

function isExistEntry(entry,arrayObj){
	
	for(var i=0;i<arrayObj.length;i++){
		
		if(entry == arrayObj[i].toString()){
			return true;
		}
	}
	return false;
}

function upFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = 0; i <= (len-1); i++) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i>0 && destList.options[i-1] != null){
				fromtext = destList.options[i-1].text;
				fromvalue = destList.options[i-1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i-1] = new Option(totext,tovalue);
				destList.options[i-1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
      }
   }
   reloadResourceArray();
}
function addAllToList(){
	var table =$("#BrowseTable");
	$("#BrowseTable").find("tr").each(function(){
		var str=jQuery.trim($($(this)[0].cells[0]).text()+"~"+$($(this)[0].cells[1]).text());
		if(!isExistEntry(str,resourceArray))
			addObjectToSelect($("select[name=srcList]")[0],str);
	});
	reloadResourceArray();
}

function deleteFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}
function deleteAllFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if (destList.options[i] != null) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}
function downFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i<(len-1) && destList.options[i+1] != null){
				fromtext = destList.options[i+1].text;
				fromvalue = destList.options[i+1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i+1] = new Option(totext,tovalue);
				destList.options[i+1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
      }
   }
   reloadResourceArray();
}
//reload resource Array from the List
function reloadResourceArray(){
	resourceArray = new Array();
	var destList =$("select[name=srcList]")[0];
	for(var i=0;i<destList.options.length;i++){
		resourceArray[i] = destList.options[i].value+"~"+jQuery.trim(destList.options[i].text) ;
	}
	//alert(resourceArray.length);
}

function setResourceStr(){
	
	resourceids ="";
	resourcenames = "";
	for(var i=0;i<resourceArray.length;i++){
		resourceids += ","+resourceArray[i].split("~")[0] ;
		resourcenames += ","+resourceArray[i].split("~")[1] ;
	}
	//alert(resourceids+"--"+resourcenames);
	$("input[name=resourceids]").val( resourceids.substring(1));
}

function doSearch()
{
	setResourceStr();
	$("input[name=resourceids]").val(resourceids.substring(1)) ;
    document.SearchForm.submit();
}

jQuery(document).ready(function(){

});
</script>
