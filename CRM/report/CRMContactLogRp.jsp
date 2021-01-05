
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:frmmain.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;   
%>

<%
String operation = Util.null2String(request.getParameter("operation"));
String planId = Util.null2String(request.getParameter("planId"));
String planIds = Util.null2String(request.getParameter("planIds"));
String userCustomer = Util.null2String(request.getParameter("userCustomer"));

if("once".equals(operation)){
	rs.execute("update WorkPlan set status = 1 where id ="+planId);
}

if("batch".equals(operation)){
	planIds = planIds.substring(0,planIds.length()-1);
	rs.execute("update WorkPlan set status = 1 where id in ("+planIds+")");
}

int finished = Util.getIntValue(request.getParameter("finished"),-1);
int contacttype = Util.getIntValue(request.getParameter("contacttype"),0);
int resource=Util.getIntValue(request.getParameter("viewer"),0);
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=10;
String resourcename=ResourceComInfo.getResourcename(resource+"");
String datetype = Util.null2String(request.getParameter("datetype"));
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String ownerid2=Util.fromScreen(request.getParameter("ownerid2"),user.getLanguage()); //客户id
String selectType = Util.null2String(request.getParameter("selectType"));//plan 联系计划; info联系情况
String pageId = selectType.equals("info")?PageIdConst.CRM_ContactPlan:PageIdConst.CRM_ContactPlanInfo;
String name = Util.null2String(request.getParameter("name"));
String description = Util.null2String(request.getParameter("description"));

String sqlwhere="";
boolean isOracle = false;
boolean isDb2 = false;
isOracle = RecordSet.getDBType().equals("oracle");
isDb2 = RecordSet.getDBType().equals("db2");
if(resource!=0){//Modify by 杨国生 2004-10-25 For TD1267
	if(isOracle)
		sqlwhere+= " and (','||t1.resourceid||',') LIKE '%," + resource + ",%' ";
	else if (isDb2)
           sqlwhere+= " and (CONCAT(',',t1.resourceid,',')) LIKE '%," + resource + ",%' ";
	else
		sqlwhere+= " and (',' + t1.resourceid + ',') LIKE '%," + resource + ",%' ";
}
if(!"".equals(datetype) && !"6".equals(datetype)){
	sqlwhere += " and t1.begindate >= '"+TimeUtil.getDateByOption(datetype+"","0")+"'";
	sqlwhere += " and t1.begindate <= '"+TimeUtil.getDateByOption(datetype+"","")+"'";
}
if(!fromdate.equals("")){
 	sqlwhere+=" and t1.begindate>='"+fromdate+"'";
}
if(!enddate.equals("")){
	sqlwhere+=" and t1.begindate<='"+enddate+"'";
}
if(!name.equals("")){
	sqlwhere+=" and t1.name like '%"+name+"%'";
}
if(!description.equals("")){
	sqlwhere+=" and t1.description like '%"+description+"%'";
}
if( finished != -1 ){
	sqlwhere+=" and t1.status = '"+finished +"'" ;
}
if( contacttype != 0 ){
	sqlwhere+=" and t1.urgentLevel = '"+contacttype +"'";
}
if(!ownerid2.equals("")){
	sqlwhere+=" and t1.crmid='"+ownerid2+"'";
}

String logintype = ""+user.getLogintype();
%>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="setContactStatusBatch()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(555,user.getLanguage()) %>"/>
			<input type="text" class="searchInput"  id="searchName" name="searchName" value="<%=description%>"/>
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
<form id=weaver name=frmmain method=post action="/CRM/report/CRMContactLogRp.jsp">
<input type="hidden" name="selectType"	value="<%=selectType %>">
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage()) %>'>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=InputStyle  name=description id="description" value="<%=description%>" style="width: 180px;">
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=InputStyle  name=name id="name" value="<%=name%>" style="width: 180px;">
		</wea:item>
		
		<%if(!user.getLogintype().equals("2")){%>
		  <wea:item><%=SystemEnv.getHtmlLabelName(15525,user.getLanguage())%></wea:item>
		  <wea:item>
		  	<span style="margin-right: 10px;">
			  	<select id="userCustomer" style="width: 120px;" name="userCustomer" onchange="changeType(this.value,'viewer','ownerid2');">
			  		<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
					<option value="1" <%if(userCustomer.equals("1")){ %>selected="selected"<%} %>>
						<%=SystemEnv.getHtmlLabelName(362,user.getLanguage())%>
					</option>
					<option value="2" <%if(userCustomer.equals("2")){ %>selected="selected"<%} %>>
						<%=SystemEnv.getHtmlLabelName(136,user.getLanguage()) %>
					</option>
				</select>
			</span>
			
			
			<span id="viewerselspan" style="<%=userCustomer.equals("1")?"":"display:none;" %>">
				
			   <brow:browser viewType="0" name="viewer" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
			         browserValue='<%=resource+""%>' 
			         browserSpanValue = '<%=Util.toScreen(resourcename,user.getLanguage())%>'
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			         completeUrl="/data.jsp" width="150px" ></brow:browser> 
			</span>
		  	
		  	
		  	<span id="ownerid2selspan" style="<%=userCustomer.equals("2")?"":"display:none;" %>">
			   <brow:browser viewType="0" name="ownerid2" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
			         browserValue='<%=ownerid2%>' 
			         browserSpanValue = '<%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(ownerid2),user.getLanguage())%>'
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			         completeUrl="/data.jsp?type=7" width="150px" ></brow:browser> 
			</span>
		  	
		  </wea:item>                    
	  <%}%>
	  
		  <wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
		  <wea:item>
		  <select class=InputStyle  size="1" name="finished" style="width: 120px;">
					<option value="-1" <%if (finished == -1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
					<option value="0" <%if (finished == 0) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(732,user.getLanguage())%></option>
					<option value="1" <%if (finished == 1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1961,user.getLanguage())%></option>
					<option value="2" <%if (finished == 2) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
					</select>
		  </wea:item>
	
		  <wea:item><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></wea:item>
		  <wea:item>
		  		<select  class=InputStyle size="1" name="contacttype" style="width: 120px;">
					<option value="0" <%if (contacttype == 0 ) { %>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
					<option value="1" <%if (contacttype == 1 ) { %>selected<%}%>><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></option>
					<option value="2" <%if (contacttype == 2 ) { %>selected<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></option>
					<option value="3" <%if (contacttype == 3 ) { %>selected<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></option>			
				</select>
		 </wea:item>
		 
		 <wea:item><%=SystemEnv.getHtmlLabelName(1275,user.getLanguage())%></wea:item>
         <wea:item>
         	<span>
	        	<SELECT  id="datetype" name="datetype" onchange="onChangetype(this)" style="width: 120px;">
				  <option value="" 	<%if(datetype.equals("")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				  <option value="1" <%if(datetype.equals("1")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
				  <option value="2" <%if(datetype.equals("2")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
				  <option value="3" <%if(datetype.equals("3")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
				  <option value="4" <%if(datetype.equals("4")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
				  <option value="5" <%if(datetype.equals("5")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
				  <option value="6" <%if(datetype.equals("6")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
				</SELECT>     
         	</span>
		        
        	<span id="dateTd" style="margin-left: 10px;padding-top: 5px;">
			  <BUTTON class=calendar type="button" id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
			  <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
			  <input type="hidden" name="fromdate" value=<%=fromdate%>>－&nbsp;<BUTTON type="button" class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
			  <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
			  <input type="hidden" name="enddate" value=<%=enddate%>>
			</span>
		  </wea:item>
	</wea:group>
	
	<wea:group context="" attributes="{'Display':'none'}">
		<wea:item type="toolbar">
			<input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(82529,user.getLanguage())%>" id="searchBtn"/>
			<span class="e8_sep_line">|</span>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(27088,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondition()"/>
			<span class="e8_sep_line">|</span>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32694,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		</wea:item>
	</wea:group>
</wea:layout>
</form>
</div>


<%
String language=String.valueOf(user.getLanguage());
String backFields = " id, begindate,  begintime, crmid, name, status, resourceid, agentId, urgentLevel, description , createrType,createrid , createdate,createtime";
String sqlFrom = "";
String whereclause="";
String sorttype = "plan".equals(selectType)?"asc":"desc";
if(isOracle){
	sqlFrom = " WorkPlan t1 left join "+CrmShareBase.getTempTable(user.getUID()+"")+" t0 on t1.crmid= TO_CHAR(t0.relateditemid)";
	whereclause = "t1.crmid=TO_CHAR(t0.relateditemid) and t1.type_n = '3' ";
}else{
	sqlFrom = " WorkPlan t1 left join "+CrmShareBase.getTempTable(user.getUID()+"")+" t0 on t1.crmid= convert(varchar(2000),t0.relateditemid)";
	whereclause = "t1.crmid=convert(varchar(2000),t0.relateditemid) and t1.type_n = '3' ";
}
whereclause += sqlwhere;

String operateString= "<operates width=\"15%\">";
operateString+=" <popedom transmethod=\"weaver.crm.report.CRMContractTransMethod.getCusOpratePopedom\"  otherpara=\"column:createrid+column:status+"+user.getUID()+"\"></popedom> ";
operateString+="     <operate  href=\"javascript:setContactStatus()\" text=\""+SystemEnv.getHtmlLabelName(555,user.getLanguage())+"\" target=\"_self\"  index=\"0\"/>";
operateString+="</operates>";

String tableString=""+
			  "<table  pageId=\""+pageId+"\"  pagesize=\""+PageIdConst.getPageSize(pageId,user.getUID(),PageIdConst.CRM)+"\" tabletype=\"checkbox\" sqlwhere=\""+Util.toHtmlForSplitPage(whereclause)+"\">"+
			  "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlprimarykey=\"id\" sqlorderby=\"createdate,createtime\" sqlsortway=\""+sorttype+"\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(whereclause)+"\"/>"+
			  "<checkboxpopedom showmethod=\"weaver.crm.report.CRMContractTransMethod.getContactCheckInfo\" popedompara=\"column:createrid+column:status+"+user.getUID()+"\"  />"+
			  "<head>";

tableString += 
			"<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(345,user.getLanguage())+"\" column=\"description\" orderkey=\"description\"/>"+
			"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(229,user.getLanguage())+"\" column=\"name\" orderkey=\"name\" otherpara=\"column:id+column:crmid\"  transmethod=\"weaver.crm.report.CRMContractTransMethod.getContactName\"/>"+
			"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15534,user.getLanguage())+"\" column=\"urgentLevel\" orderkey=\"urgentLevel\"   otherpara=\""+language+"\" transmethod=\"weaver.splitepage.transform.SptmForCrm.getUrgentName\"/>"+
			"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(1268,user.getLanguage())+"\" column=\"crmid\" orderkey=\"crmid\" otherpara=\""+language+"\"  transmethod=\"weaver.splitepage.transform.SptmForCrm.getCrmName\"/>"+
			"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15525,user.getLanguage())+"\" column=\"resourceid\" orderkey=\"resourceid\" otherpara=\""+language+"+column:createrType\" transmethod=\"weaver.splitepage.transform.SptmForCrm.getReceiveName\"/>"+
			"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(1275,user.getLanguage())+"\"  column=\"begindate\" orderkey=\"begindate\" otherpara=\"column:begintime\" transmethod=\"weaver.splitepage.transform.SptmForCrm.getTime\"/>";
if("info".equals(selectType)){
	tableString += "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"status\" orderkey=\"status\" otherpara=\""+language+"\" transmethod=\"weaver.splitepage.transform.SptmForCrm.getStatusName\"/>";
}
tableString	+=	"</head>"+operateString+"</table>";
%>
<input type="hidden" name="pageId" id="pageId" value="<%=pageId%>">
<wea:SplitPageTag tableString='<%=tableString%>'  mode="run" isShowTopInfo="true" />
		
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<script type="text/javascript">
function onShowResource(){

	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
	
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp",
			"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if(data){
		if(data.id!=""){
			viewerspan.innerHTML = "<A href='HrmResource.jsp?id="+data.id+"'>"+data.name+"</A>"
			frmmain.viewer.value=data.id
		}else{ 
			viewerspan.innerHTML = ""
			frmmain.viewer.value=""
		}
	}
}
function onShowParent(tdname,inputename){
	
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp",
			"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if (data){
	    if (data.id!=""){
	        document.all(tdname).innerHTML = data.name
	        document.all(inputename).value=data.id
	        document.all("usertype").value="2"
	
	        document.all("ownerspan").innerHTML = ""
	        document.all("ownerid").value = ""
	
	        document.all("doccreateridspan").innerHTML = ""
	        document.all("doccreaterid").value = ""
	
	    }else{
	        document.all(tdname).innerHTML = ""
	        document.all(inputename).value=""
	        document.all("usertype").value=""
	    }
	}
}

function onChangetype(obj){
	if(obj.value == 6){
		jQuery("#dateTd").show();
	}else{
		jQuery("#dateTd").hide();
	}
}

$(document).ready(function(){
			
		jQuery("#topTitle").topMenuTitle({searchFn:searchName});
		jQuery("#hoverBtnSpan").hoverBtn();
		
		if("<%=datetype%>" == 6){
			jQuery("#dateTd").show();
		}else{
			jQuery("#dateTd").hide();
		}		
});
//阻止事件冒泡函数
function stopBubble(e){
	if (e && e.stopPropagation){
		e.stopPropagation()
	}else{
		window.event.cancelBubble=true
	}
}

function setContactStatus(planId){
	 jQuery.post("/CRM/report/CRMContactLogRp.jsp",{"planId":planId,"operation":"once"},function(){
	 	_table.reLoad();
	 });
}

function setContactStatusBatch(){
	var planIds = _xtable_CheckedCheckboxId();
	if("" == planIds){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22000,user.getLanguage())%>");
		return;
	}

	jQuery.post("/CRM/report/CRMContactLogRp.jsp",{"planIds":planIds,"operation":"batch"});
	_table.reLoad();
}
function searchName(){
	var searchName = jQuery("#searchName").val();
	jQuery("#description").val(searchName);
	window.frmmain.submit();
}

function changeType(val,span1,span2){
	if(val=="2"){
		jQuery("#"+span1).val("");
		jQuery("#"+span1+"span").html("");
		jQuery("#"+span2+"selspan").show();
		jQuery("#"+span1+"selspan").hide();
	}else if(val =="1"){
		jQuery("#"+span2).val("");
		jQuery("#"+span2+"span").html("");
		jQuery("#"+span1+"selspan").show();
		jQuery("#"+span2+"selspan").hide();
	}else{
		jQuery("#"+span1).val("");
		jQuery("#"+span1+"span").html("");
		jQuery("#"+span1+"selspan").hide();
		jQuery("#"+span2).val("");
		jQuery("#"+span2+"span").html("");
		jQuery("#"+span2+"selspan").hide();
	}
}

var dialog = null;
function showInfo(planid ,customerid){
	dialog =new window.top.Dialog();
    dialog.currentWindow = window; 
    dialog.Modal = true;
    dialog.Drag=true;
	dialog.Width =680;
	dialog.Height =500;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("136,621",user.getLanguage())%>";
	dialog.URL = "/workplan/data/WorkPlanDetail.jsp?workid="+planid+"&customerid="+customerid;
	dialog.show();
	document.body.click();
}	

function closeByHand(){
	if(dialog){
		dialog.close();
	}
}	
</script>
</body>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
