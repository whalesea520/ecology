<%@ page import="weaver.general.Util,
                 weaver.hrm.resource.ResourceComInfo" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.conn.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetid" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="AwardComInfo" class="weaver.hrm.award.AwardComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<% 
	String id = Util.null2String(request.getParameter("id"));
	String cmd = Util.null2String(request.getParameter("cmd"));
%>
<HTML><HEAD>

<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<%
if(!HrmUserVarify.checkUserRight("HrmResourceRewardsRecordAdd:Add" , user)) {
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}
%>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#SearchForm").submit();
}

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
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
		var idArr = id.split(",");
		var ajaxNum = 0;
		for(var i=0;i<idArr.length;i++){
			ajaxNum++;
			jQuery.ajax({
				url:"/hrm/award/HrmAwardOperation.jsp?isdialog=1&operation=delete&id="+idArr[i],
				type:"post",
				async:true,
				complete:function(xhr,status){
					ajaxNum--;
					if(ajaxNum==0){
						_table.reLoad();
					}
				}
			});
		}
	});
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function openDialog(id){
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmAwardAdd";
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())+SystemEnv.getHtmlLabelName(6100,user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmAwardEdit&id="+id;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(6100,user.getLanguage())%>";
	}
	dialog.Width = 600;
	dialog.Height = 503;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

if("<%=cmd%>" == "showEdit"){
	openDialog("<%=id%>");
}

function onLog(id){
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	var url = "";
	if(id && id!=""){
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=93 and relatedid=")%>&relatedid="+id;
	}else{
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=93")%>";
	}
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}
</script>
</HEAD>

<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6100,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<% 
String startdateselect = Util.null2String(request.getParameter("startdateselect"));
String departmentid = Util.null2String(request.getParameter("departmentid"));//部门
String resourceid = Util.null2String(request.getParameter("resourceid"));//惩罚人员的id
String rptypeid = Util.null2String(request.getParameter("rptypeid"));//惩罚种类id
String rpdate =Util.fromScreen(request.getParameter("rpdate"),user.getLanguage());
String torpdate =Util.fromScreen(request.getParameter("torpdate"),user.getLanguage());
if(!startdateselect.equals("") && !startdateselect.equals("0")&& !startdateselect.equals("6")){
	rpdate = TimeUtil.getDateByOption(startdateselect,"0");//起始日期
	torpdate = TimeUtil.getDateByOption(startdateselect,"1");//结束日期
}
String qname = Util.null2String(request.getParameter("flowTitle"));
%>
 
<%
   String fromSql="from HrmAwardInfo t1";
   String sqlWhere="";
   String hid="";
   String str="";
   int flag=0;
   if(qname.length()>0){
   sqlWhere+=" exists (select * from hrmresource hrm where hrm.id = t1.resourseid and lastname like '%"+qname+"%')";
   }
   RecordSet.executeSql("select  id, resourseid from HrmAwardInfo ");

   if(!resourceid.equals("")){//惩罚人员id不为空
           
 while(RecordSet.next()){
   str=RecordSet.getString("resourseid");
	 RecordSetid.executeSql("select id from HrmAwardInfo where "+ resourceid+"  in ("+str+")");
		while(RecordSetid.next()){
	       	  if(hid=="")
			          hid=hid+RecordSet.getInt("id");
	         else
				      hid=hid+","+RecordSet.getInt("id");
	  }
  }
   sqlWhere=sqlWhere+"t1.id in("+hid+")";
   flag=1;
   }
   
   if(!rptypeid.equals("")){//惩罚种类id不为空
      if(flag==1){
	      sqlWhere=sqlWhere+" and rptypeid="+rptypeid;	  
	  }
      else{
	      sqlWhere=sqlWhere+" rptypeid="+rptypeid;
	       flag=1;
	  }
   }

if(!rpdate.equals("")) {//起始日期不为空
    if(flag==1){
	 sqlWhere=sqlWhere+" and rpdate >='"+rpdate+"'";
	}
	else{
	sqlWhere=sqlWhere+" rpdate >='"+rpdate+"'";
	flag=1;
	}
}

if(!torpdate.equals("")){//结束日期不为空
if(flag==1){
   sqlWhere=sqlWhere+" and rpdate<='"+torpdate+"'";
}
else{
   sqlWhere=sqlWhere+" rpdate<='"+torpdate+"'";
   flag=1;
 }
}
if(!departmentid.equals("")){
	RecordSet.executeSql("select  id, resourseid from HrmAwardInfo ");
	hid="";
if(flag==1){
     while(RecordSet.next()){
     str=RecordSet.getString("resourseid");
	 RecordSetid.executeSql("select id from HrmResource where departmentid="+departmentid +" and  id in ("+str+")");
		while(RecordSetid.next()){
	       	  if(hid=="")
			          hid=hid+RecordSet.getInt("id");
	         else
				      hid=hid+","+RecordSet.getInt("id");
	}
}

sqlWhere=sqlWhere+"and t1.id in ("+hid+")";
}
else{
    while(RecordSet.next()){
     str=RecordSet.getString("resourseid");
	 RecordSetid.executeSql("select id from HrmResource where departmentid="+departmentid +" and  id in ("+str+")");
		while(RecordSetid.next()){
	       	  if(hid=="")
			          hid=hid+RecordSet.getInt("id");
	         else
				      hid=hid+","+RecordSet.getInt("id");
	}
}
   sqlWhere="t1.id in ("+hid+")";
}
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmResourceRewardsRecordAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmResourceRewardsRecordAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=SearchForm NAME=SearchForm STYLE="margin-bottom:0" action="HrmAward.jsp" method=post>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(HrmUserVarify.checkUserRight("HrmSpecialityAdd:Add", user)){ %>
				<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
			<%}if(HrmUserVarify.checkUserRight("HrmSpecialityEdit:Delete", user)){ %>
				<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
			<%} %>
			<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></wea:item>
		<wea:item> 
	    <brow:browser viewType="0" id="resourceid" name="resourceid" browserValue='<%=resourceid %>' 
      browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?selectedids="
      hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
      completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="120px"
      browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage()) %>'>
      </brow:browser>
    </wea:item>    
  	<wea:item><%=SystemEnv.getHtmlLabelName(6099,user.getLanguage())%></wea:item>
   	<wea:item>
   	  <brow:browser viewType="0" id="rptypeid" name="rptypeid" browserValue='<%=rptypeid %>' 
      browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/award/AwardTypeBrowser.jsp?selectedids="
      hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
      completeUrl="/data.jsp?type=HrmAwardType" width="120px"
      browserSpanValue='<%=Util.toScreen(AwardComInfo.getAwardName(rptypeid),user.getLanguage())%>'>
      </brow:browser>
  	</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1962,user.getLanguage())%></wea:item>
		<wea:item>
			<span>
      	<select name="startdateselect" id="startdateselect" onchange="changeDate(this,'spanStartdate');" style="width: 135px">
      		<option value="0" <%=startdateselect.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
      		<option value="1" <%=startdateselect.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
      		<option value="2" <%=startdateselect.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
      		<option value="3" <%=startdateselect.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
      		<option value="4" <%=startdateselect.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
      		<option value="5" <%=startdateselect.equals("5")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
      		<option value="6" <%=startdateselect.equals("6")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
      	</select>
       </span>
       <span id=spanStartdate style="<%=startdateselect.equals("6")?"":"display:none;" %>">
      		<BUTTON type="button" class=Calendar id=selectstartdate onclick="getDate(startdatespan,rpdate)"></BUTTON>
       		<SPAN id=startdatespan ><%=rpdate%></SPAN>－
       		<BUTTON type="button" class=Calendar id=selectstartdateTo onclick="getDate(startdateTospan,torpdate)"></BUTTON>
       		<SPAN id=startdateTospan ><%=torpdate%></SPAN>
       </span>
       <input class=inputstyle type="hidden" id="rpdate" name="rpdate" value="<%=rpdate%>">
       <input class=inputstyle type="hidden" id="torpdate" name="torpdate" value="<%=torpdate%>">
    </wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
    <wea:item>
      <brow:browser viewType="0" id="departmentid" name="departmentid" browserValue='<%=departmentid %>' 
      browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="
      hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
      completeUrl="/data.jsp?type=4" width="200px"
      browserSpanValue='<%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%>'>
      </brow:browser>            
    </wea:item>
	</wea:group>
	<wea:group context="">
	<wea:item type="toolbar">
		<input type="button" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>" class="e8_btn_submit" onclick="submitData();"/>
		<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
	</wea:item>
</wea:group>
</wea:layout>
</div>
<%
   String tableString="";

 //操作字符串
   String  operateString= "";
   operateString = "<operates width=\"20%\">";
    	       operateString+=" <popedom transmethod=\"weaver.hrm.HrmTransMethod.getHrmAwardOperate\" otherpara=\""+HrmUserVarify.checkUserRight("HrmResourceRewardsRecordAdd:Add", user)+"\" otherpara2=\""+HrmUserVarify.checkUserRight("HrmResourceRewardsRecordDelete:Delete", user)+":"+HrmUserVarify.checkUserRight("HrmResourceRewardsRecordEdit:Edit", user)+"\"></popedom> ";
    	       operateString+="     <operate href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
    	       operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
    	       //operateString+="     <operate href=\"javascript:onLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" index=\"2\"/>";
    	       operateString+="</operates>";	
    String tabletype="checkbox";
    if(HrmUserVarify.checkUserRight("HrmResourceRewardsRecordEdit:Delete", user)){
    	tabletype = "checkbox";
    }
    
   String backfields ="t1.id,t1.rptitle,t1.resourseid,t1.rptypeid,t1.rpdate,t1.rpexplain,t1.rptransact";
   tableString="<table tabletype=\""+tabletype+"\" pageId=\""+PageIdConst.HRM_Award+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_Award,user.getUID(),PageIdConst.HRM)+"\">"+"<sql  backfields=\""+backfields+"\"   sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlprimarykey=\"t1.id\"  sqlsortway=\"Desc\"  sqlisdistinct=\"true\" />"+
   " <checkboxpopedom showmethod=\"weaver.hrm.HrmTransMethod.getHrmAwardCheckbox\"  id=\"checkbox\"  popedompara=\"column:id\" />"+
   operateString+
   "<head>"+ "<col  width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(15665, user.getLanguage())+"\"   column=\"rptitle\" orderkey=\"t1.rptitle\"   href=\"/hrm/award/HrmAward.jsp?cmd=showEdit\"  linkkey=\"id\" linkvaluecolumn=\"id\" target=\"_self\" />" +
    "<col  width=\"35%\"   text=\""+SystemEnv.getHtmlLabelName(1867, user.getLanguage())+"\"   column=\"resourseid\" orderkey=\"t1.resourseid\"    transmethod=\"weaver.splitepage.transform.SptmForHR.getResourName\"  />" +
	"<col  width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(6099, user.getLanguage())+"\"   column=\"rptypeid\" orderkey=\"t1.rptypeid\"  transmethod=\"weaver.splitepage.transform.SptmForHR.getPunishType\"  />" +
	"<col  width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(1962, user.getLanguage())+"\"   column=\"rpdate\" orderkey=\"t1.rpdate\" />" +
	//"<col  width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(85, user.getLanguage())+"\"   column=\"rpexplain\" orderkey=\"t1.rpexplain\" />" +
	//"<col  width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(15432, user.getLanguage())+"\"   column=\"rptransact\" orderkey=\"t1.rptransact\" />" +
   "</head>"+
   "</table>";
    
  %>
  <input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HRM_Award %>"/>
<wea:SplitPageTag tableString='<%=tableString%>' mode="run"/>
</FORM>
<script language=javascript>  
function submitData() {
 SearchForm.submit();
}
function ResetCondition(){
	window.location='/hrm/award/HrmAward.jsp';
}
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT LANGUAGE=VBS>
  sub onShowResourceID(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	inputname.value=id(0)
	else 
	spanname.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub
sub onShowAwardTypeID(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/award/AwardTypeBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = id(1)
	inputname.value=id(0)
    else 
	spanname.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub
sub onShowDepartment(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&inputname.value)
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	    spanname.innerHtml = id(1)
	    inputname.value=id(0)
	else
	    spanname.innerHtml = ""
	    inputname.value=""
	end if
	end if
end sub
</SCRIPT>
</BODY>
</HTML>
