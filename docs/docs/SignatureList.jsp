
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.security.AclManager " %>
<%@ page import="weaver.docs.category.* " %>
<%@ page import="java.util.*"%>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>

<jsp:useBean id="SignatureManager" class="weaver.docs.docs.SignatureManager" scope="page" />
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<%

if(!(user.getLogintype()).equals("1")) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
if(!HrmUserVarify.checkUserRight("SignatureAdd:Add", user)){
    response.sendRedirect("/notice/noright.jsp");
    return ;
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "<b>"+SystemEnv.getHtmlLabelName(16627,user.getLanguage())+"</b>";
String needfav = "1";
String needhelp = "1";

String  subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String  departmentid = Util.null2String(request.getParameter("departmentid"));
String flowTitle = Util.null2String(request.getParameter("flowTitle"));
String name = Util.null2String(request.getParameter("name"));
if(flowTitle.length()==0 && name.length()>0)flowTitle = name;
if(name.length()==0&&flowTitle.length()>0)name=flowTitle;
String  hrmresid = Util.null2String(request.getParameter("hrmresid"));
String	dateselect =Util.null2String(request.getParameter("dateselect"));
String  startdate = Util.null2String(request.getParameter("startdate"));
String  enddate = Util.null2String(request.getParameter("enddate"));
String  sealType = Util.null2String(request.getParameter("sealType"));
if(!dateselect.equals("") && !dateselect.equals("0")&& !dateselect.equals("6")){
	startdate = TimeUtil.getDateByOption(dateselect,"0");
	enddate = TimeUtil.getDateByOption(dateselect,"1");
}

int operatelevel= 0;
if(Util.null2String(ManageDetachComInfo.getDetachable()).equals("1")){ 
	session.setAttribute("detachable","1");
}else{
	session.setAttribute("detachable","0");
}
	
int dftsubcomid = 0;
RecordSet.executeProc("SystemSet_Select","");
if(RecordSet.next()){
	dftsubcomid = Util.getIntValue(RecordSet.getString("dftsubcomid"), 0);
}
	
String hrmdetachable="0";
boolean isUseHrmManageDetach=ManageDetachComInfo.isUseHrmManageDetach();
if(isUseHrmManageDetach){
   hrmdetachable="1";
   session.setAttribute("detachable","1");
   session.setAttribute("hrmdetachable",hrmdetachable);
}else{
   hrmdetachable="0";
   session.setAttribute("detachable","0");
   session.setAttribute("hrmdetachable",hrmdetachable);
}
int rolelevel = -2;
String defaultDept = "",defaultSub = "";
String detachSql = "";
String companyid = "";
if(user.getUID() != 1){
	if("1".equals(hrmdetachable)){
		operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"SignatureAdd:Add",Util.getIntValue(subcompanyid,-1));
		int tmpoperatelevel = 0;
		int[] companyids = CheckSubCompanyRight.getSubComByUserRightId(user.getUID(),"SignatureAdd:Add");
		for(int i=0;companyids!=null&&i<companyids.length;i++){
			tmpoperatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"SignatureAdd:Add",companyids[i]);
			if(tmpoperatelevel > -1){
				companyid += ","+companyids[i];
			}
		}
		
	}else{
		if(HrmUserVarify.checkUserRight("SignatureAdd:Add", user)){
				 String sql = "select max(a.rolelevel) as rolelevel from hrmrolemembers a ,systemrightroles b,systemrights c,systemrightdetail d" +
		                    " where a.roleid=b.roleid and b.rightid=c.id and c.id=d.rightid " +
		                    "and a.rolelevel>=b.rolelevel and a.resourceid=" + user.getUID() +
		                    " and d.rightdetail='SignatureAdd:Add'";
		         RecordSet.executeSql(sql);
		         RecordSet.next();
		         rolelevel = Util.getIntValue(RecordSet.getString("rolelevel"),-2);
		         ArrayList<String> childList = new ArrayList<String>();
		         
		         if(rolelevel == 0){//部门
		         	defaultDept = user.getUserDepartment()+"";
		         }else if(rolelevel == 1){//分部
		         	defaultSub = user.getUserSubCompany1()+"";
		         }
			 operatelevel = 2;
		}
	}

}else{
	 operatelevel = 2;
}		
ResourceComInfo rci = new ResourceComInfo();
DepartmentComInfo dci = new DepartmentComInfo();
SubCompanyComInfo sci = new SubCompanyComInfo();
String deptid = rci.getDepartmentID("" + user.getUID());
String subcomid = dci.getSubcompanyid1(deptid);
ArrayList subcompanylist=new ArrayList();
subcompanylist.add(subcomid);
subcomid=sci.getSupsubcomid(subcomid);
while(!subcomid.equals("0")&&!subcomid.equals("")){
    subcompanylist.add(subcomid);
    subcomid=sci.getSupsubcomid(subcomid);
}
                
String isclose = Util.null2String(request.getParameter("isclose"));
String action = Util.null2String(request.getParameter("action"));
String navName = "";
if(departmentid.length()>0){
	navName = DepartmentComInfo.getDepartmentName(departmentid);
}else if(subcompanyid.length()>0){
	navName = SubCompanyComInfo.getSubCompanyname(subcompanyid);
}else if(action.equals("yingyongsetting")){
	navName = SystemEnv.getHtmlLabelName(16627,user.getLanguage());
}
%>
<script type="text/javascript">
jQuery(document).ready(function(){
parent.setTabObjName('<%=SystemEnv.getHtmlLabelName(16627,user.getLanguage())%>')
});
</script>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript">

function doDel(id){
	if(!id){
		id = _xtable_CheckedCheckboxId();
	}
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>",function(){
		//var idArr = id.split(",");
		//for(var i=0;i<idArr.length;i++){
			jQuery.ajax({
				url:"UploadSignature.jsp?isdialog=1&opera=delete",
				type:"post",
				data:{
					id:id
				},
				complete:function(xhr,status){
					//if(i==idArr.length-1){
						window.location.reload();
					//}
				}
			});
		//}
	});
}

function showHeader(){
	if(oDiv.style.display=='')
		oDiv.style.display='none';
	else
		oDiv.style.display='';
}

function onBtnSearchClick(){
	onRefrush();
}


function onshowdocmain(vartmp){
	if(vartmp==1)
		otrtmp.style.display='';
	else	
		otrtmp.style.display='none';
}

function onRefrush(){
    weaver.submit();
}
	
var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function openDialogReadonly(id,operatelevel){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "";
	url = "/hrm/HrmDialogTab.jsp?_fromURL=SignatureEdit&markId="+id+"&subcompanyid=<%=subcompanyid%>&operatelevel="+operatelevel+"&rolelevel=<%=rolelevel%>";
	if(operatelevel > 0){
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,21650",user.getLanguage())%>";
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("367,21650",user.getLanguage())%>";
	}
	dialog.Width = 700;
	dialog.Height = 285;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.maxiumnable = true;
	//dialog.okLabel = "保存";
   	//dialog.cancelLabel = "取消";
	//dialog.InvokeElementId = "formDiv";
	//dialog.textAlign = "center";
	/*dialog.OKEvent = function(){
		submitData();
	}
	dialog.CancelEvent = function(){dialog.close();}*/
	dialog.show();
}

function openDialog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "";
	if(id && id!=""){
		url = "/hrm/HrmDialogTab.jsp?_fromURL=SignatureEdit&markId="+id+"&subcompanyid=<%=subcompanyid%>&operatelevel=<%=operatelevel%>&rolelevel=<%=rolelevel%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,21650",user.getLanguage())%>";
	}else{
		url = "/hrm/HrmDialogTab.jsp?_fromURL=SignatureAdd&subcompanyid=<%=subcompanyid%>&operatelevel=<%=operatelevel%>&rolelevel=<%=rolelevel%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(16387,user.getLanguage())%>";
	}	
	dialog.Width = 700;
	dialog.Height = 500;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.maxiumnable = true;
	//dialog.okLabel = "保存";
   	//dialog.cancelLabel = "取消";
	//dialog.InvokeElementId = "formDiv";
	//dialog.textAlign = "center";
	/*dialog.OKEvent = function(){
		submitData();
	}
	dialog.CancelEvent = function(){dialog.close();}*/
	dialog.show();
}

</script>
 
</head>
<BODY style="overflow-x: hidden">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onRefrush(),_top} " ;
//RCMenuHeight += RCMenuHeightStep ;
if(operatelevel > 0 && HrmUserVarify.checkUserRight("SignatureAdd:Add", user)){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(16387,user.getLanguage())+",javascript:openDialog(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
if(operatelevel > 1 && HrmUserVarify.checkUserRight("SignatureEdit:Delete", user)){
  RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDel(),_top} " ;
  RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td style="width:30%;">
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
		<%
			if(operatelevel > 0 && HrmUserVarify.checkUserRight("SignatureAdd:Add", user)){
		 %>
			<input type="button" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(16387,user.getLanguage())%>" onclick="javascript:openDialog()"/>
			<%
			}
			if(operatelevel > 1 && HrmUserVarify.checkUserRight("SignatureEdit:Delete", user)){
			 %>
			 <input type="button" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>" onclick="javascript:doDel()"/>
			<%} %>
			<input type="text" class="searchInput" name="flowTitle" value="<%=flowTitle %>" id="flowTitle" onchange="setKeyword('flowTitle','name','searchfrm');"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=frmmain method=post action="SignatureList.jsp">
<input type="hidden" name="action" value="<%=action %>">

<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;">
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage()) %>'>
    <wea:item><%=SystemEnv.getHtmlLabelName(18694,user.getLanguage()) %></wea:item>
    <wea:item><input type="text" class="InputStyle" id="name" name="name"   value='<%=name %>'/></wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
    <wea:item>
    	<brow:browser viewType="0"  name="subcompanyid" browserValue='<%=subcompanyid %>' 
            browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubCompanyBrowser.jsp"
            hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
            completeUrl="/data.jsp?type=164" width="200px"
            browserSpanValue='<%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(subcompanyid),user.getLanguage())%>'>
      </brow:browser>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
    <wea:item>
    	<brow:browser viewType="0"  name="departmentid" browserValue='<%=departmentid %>' 
            browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
            hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
            completeUrl="/data.jsp?type=4" width="200px"
            browserSpanValue='<%=Util.toScreen(DepartmentComInfo.getDepartmentmark(departmentid),user.getLanguage())%>'>
      </brow:browser>
    </wea:item>
    
    <wea:item><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></wea:item>
    <wea:item>
    	<brow:browser viewType="0"  name="hrmresid" browserValue='<%=hrmresid+"" %>' 
      browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
      hasInput="true" isSingle="true" hasBrowser="true" isMustInput='1'
      completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="150px" browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(""+hrmresid),user.getLanguage())%>' >
      </brow:browser>
	</wea:item>  
    <!-- 签章类型 -->
    <wea:item><%=SystemEnv.getHtmlLabelName(127436,user.getLanguage())%></wea:item>
    <wea:item>
        <select name="sealType"  id="sealType" >
            <option value="-1" <%=sealType.equals("-1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
            <option value="1"  <%=sealType.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(127439,user.getLanguage())%></option>
            <option value="2"  <%=sealType.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(127438,user.getLanguage())%></option>
        </select>
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(19520,user.getLanguage())%></wea:item>
  <wea:item>
  	<select name="dateselect" id="dateselect" onchange="changeDate(this,'spanselectdate');" style="width: 135px">
  		<option value="0" <%=dateselect.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
  		<option value="1" <%=dateselect.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
  		<option value="2" <%=dateselect.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
  		<option value="3" <%=dateselect.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
  		<option value="4" <%=dateselect.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
  		<option value="5" <%=dateselect.equals("5")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
  		<option value="6" <%=dateselect.equals("6")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
    </select>
    <span id=spanselectdate style="<%=dateselect.equals("6")?"":"display:none;" %>">
	  	<BUTTON class=Calendar type="button" id=selectstartdate onclick="getDate(startdatespan,startdate)"></BUTTON> 
	    <SPAN id=startdatespan><%=startdate%></SPAN>－
	    <BUTTON class=Calendar type="button" id=selectenddate onclick="getDate(enddatespan,enddate)"></BUTTON> 
	    <SPAN id=enddatespan><%=enddate%></SPAN>
    </span>      
     <input class=inputstyle type="hidden" name="startdate" value="<%=startdate%>">
     <input class=inputstyle type="hidden" name="enddate" value="<%=enddate%>"> 
  </wea:item>	    
    
	</wea:group>
	<wea:group context="">
		<wea:item type="toolbar">
			<input type="button" value="<%= SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>" class="e8_btn_submit" onclick="javascript:onRefrush();"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		</wea:item>
	</wea:group>
</wea:layout>
</div>
</form>
<%
String backfields = "markId, hrmresid, MarkName, markDate,sealType,isDefault,subcompanyid";
String sqlWhere = " where 1=1 ";
String fromSql  = " from DocSignature ";
if(!departmentid.equals("")){
	sqlWhere += " and EXISTS (select * from hrmresource where hrmresource.id = hrmresid and hrmresource.departmentid in( "+departmentid+"))";
}
if(!subcompanyid.equals("")){
	sqlWhere += " and EXISTS (select * from hrmresource where hrmresource.id = hrmresid and hrmresource.subcompanyid1 in( "+subcompanyid+"))";
}else{
	if(user.getUID() != 1){
		if("1".equals(hrmdetachable)){
			if(!companyid.equals("")){
				companyid = companyid.substring(1);
				sqlWhere += " and EXISTS (select * from hrmresource where hrmresource.id = hrmresid and hrmresource.subcompanyid1 in( "+companyid+"))";
			}else{
				sqlWhere += " and EXISTS (select * from hrmresource where hrmresource.id = hrmresid and hrmresource.subcompanyid1 in(0))";
			}
		}
	}
}
if(!defaultDept.equals("")){
	sqlWhere += " and EXISTS (select * from hrmresource where hrmresource.id = hrmresid and hrmresource.departmentid in( "+defaultDept+"))";
}
if(!defaultSub.equals("")){
	sqlWhere += " and EXISTS (select * from hrmresource where hrmresource.id = hrmresid and hrmresource.subcompanyid1 in( "+defaultSub+"))";
}

if(!flowTitle.equals("")){
	sqlWhere += " and MarkName like '%"+flowTitle+"%'";
}
if(!name.equals("")){
	sqlWhere += " and MarkName like '%"+name+"%'";
}
if(!hrmresid.equals("")){
	sqlWhere += " and hrmresid = '"+hrmresid+"'";
}
if(!startdate.equals("")){
	
	if(RecordSet.getDBType().equals("oracle")){
		sqlWhere += " and substr(markDate,0,10) >= '"+startdate+"'";
	}else{
		sqlWhere += " and CONVERT(varchar(100), markDate, 23) >= '"+startdate+"'";
	}
}
if(!enddate.equals("")){

	if(RecordSet.getDBType().equals("oracle")){
		sqlWhere += " and substr(markDate,0,10) <= '"+enddate+"'";
	}else{
		sqlWhere += " and CONVERT(varchar(100), markDate, 23) <= '"+enddate+"'";
	}
}
if(!"-1".equals(sealType) && !"".equals(sealType)) {
    sqlWhere += " and sealType = '"+sealType+"'";
}
String canDelete = HrmUserVarify.checkUserRight("SignatureEdit:Edit", user)+"";
String checkpara = "column:id+"+canDelete+"+"+operatelevel;
String operateString = "";
if(operatelevel > 0 && HrmUserVarify.checkUserRight("SignatureEdit:Edit", user)){
	operateString = "<operates>";
	operateString+=" <popedom transmethod=\"weaver.general.KnowledgeTransMethod.getDirOperate\"></popedom> ";
	operateString += "<operate href=\"javascript:openDialog();\" linkkey=\"markId\" linkvaluecolumn=\"markId\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\"  index=\"0\"/>";

if(operatelevel > 1){
	operateString += "<operate href=\"javascript:doDel();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\"  index=\"1\"/>";
}
	operateString += "</operates>";
}

String MarkNametransmethod = "weaver.hrm.HrmTransMethod.getHrmOpenDialogName";
String MarkNamePara = "column:markId";
if(user.getUID() != 1){
	if("1".equals(hrmdetachable)){
		MarkNametransmethod = "weaver.hrm.HrmTransMethod.getHrmOpenDialogNameForSignature";
		MarkNamePara = "column:markId+"+user.getUID();
	}
}
String tableString=""+
  "<table pageId=\""+PageIdConst.HRM_SignatureList+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_SignatureList,user.getUID(),PageIdConst.HRM)+"\" tabletype=\"checkbox\">";
  tableString += " <checkboxpopedom  id=\"checkbox\" showmethod=\"weaver.general.KnowledgeTransMethod.getDirCheckBoxDetach\" popedompara=\""+checkpara+"\" />";
  tableString += "<sql backfields=\""+backfields+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlform=\""+fromSql+"\" sqlorderby=\"hrmresid\"  sqlprimarykey=\"markId\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
  "<head>"+							 
	 "<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(179,user.getLanguage())+"\" column=\"hrmresid\" orderkey=\"hrmresid\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" otherpara=\"0\" target=\"_self\"/>"+
     "<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(18694,user.getLanguage())+"\" column=\"MarkName\" orderkey=\"MarkName\" transmethod=\""+MarkNametransmethod+"\" otherpara=\""+MarkNamePara+"\" />"+
     "<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(127436,user.getLanguage())+"\" column=\"sealType\" orderkey=\"sealType\" transmethod=\"weaver.general.KnowledgeTransMethod.getSealType\" otherpara=\""+user.getLanguage()+"\"/>"+
     "<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(131265,user.getLanguage())+"\" column=\"isDefault\" orderkey=\"sealType,isDefault\" transmethod=\"weaver.general.KnowledgeTransMethod.isPersonalDefault\" otherpara=\""+user.getLanguage()+"+column:sealType\"/>"+
	 "<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(19520,user.getLanguage())+"\" column=\"markDate\" orderkey=\"markDate\" transmethod=\"weaver.general.KnowledgeTransMethod.getMarkDate\"/>"+						
  "</head>"+ operateString+
  "</table>"; 

%>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HRM_SignatureList %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  /> 

<%if(action.equals("yingyongsetting")){%>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom"  style="padding:0px!important;">
		<div style="padding:5px 0px;">
			<wea:layout needImportDefaultJsAndCss="false">
				<wea:group context="" attributes='{\"groupDisplay\":\"none\"}'>
					<wea:item type="toolbar">
						<input type="button" class=zd_btn_cancle accessKey=T id=btn_Close
							value="T-<%=SystemEnv.getHtmlLabelName(309, user
										.getLanguage())%>"></input>
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>
	</div>
	<br>
	<br>
	<script>
			var parentWin = null;
				var dialog = null;
				var config = null;
				try {
					parentWin = parent.parent.getParentWindow(parent);
					dialog = parent.parent.getDialog(parent);
				} catch (e) {
			}
			jQuery("#btn_Close").click(function(){
			    dialog.close();
			});
	</script>
<%}%>
</body>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
