<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<!DOCTYPE html>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.Prop" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />

<style type="text/css">
.outerdiv{
	padding-top:2px; padding-left:8px;
}
.initBtn{
	width:92px;
}
.showhtml_span{
	display:inline-block; width:200px; margin-right:20px;
	overflow:hidden; white-space:nowrap; text-overflow:ellipsis; 
}
.printnodesignblockclass {
	display:inline-block; width:200px; text-align:left;
}
.pdfprint_span{
	display:none; width:120px;
	vertical-align:middle; text-overflow:ellipsis;
}
</style>

<%
int wfid = Util.getIntValue(request.getParameter("wfid"), 0);
int formid = Util.getIntValue(request.getParameter("formid"), 0);
int isbill = Util.getIntValue(request.getParameter("isbill"), 0);
int nodeid = Util.getIntValue(request.getParameter("nodeid"), 0);
int ajax = Util.getIntValue(request.getParameter("ajax"), 0);
int design = Util.getIntValue(request.getParameter("design"), 0);
String hdiv = Util.null2String(request.getParameter("hdiv"));
int viewtypeall = 0;
int vtapprove = 0;
int vtrealize = 0;
int vtforward=0;
int vtpostil=0;
int vtHandleForward = 0;
int vtTakingOpinions = 0;
int vttpostil=0;   
int vtrecipient=0;
int vtrpostil=0; 
int vtreject = 0;
int vtsuperintend = 0;
int vtover = 0;
int vtintervenor=0;
int viewdescall = 0;
int vdcomments = 0;
int vddeptname = 0;
int vdoperator = 0;
int vddate = 0;
int vdtime = 0;
int showtype = 0;
int stnull = 0;
int printflowcomment = 0;
int vsigndoc = 0;
int vsignworkflow = 0;
int vsignupload = 0;
int vmobilesource = 0;
int pdfprint = 0;
rs.execute("select * from workflow_flownode where nodeid="+nodeid+" and workflowid="+wfid);
if(rs.next()){
	viewtypeall = Util.getIntValue(rs.getString("viewtypeall"), 0);
	vtapprove = Util.getIntValue(rs.getString("vtapprove"), 0);
	vtrealize = Util.getIntValue(rs.getString("vtrealize"), 0);
	vtforward=Util.getIntValue(Util.null2String(rs.getString("vtforward")),0);
	vtTakingOpinions=Util.getIntValue(Util.null2String(rs.getString("vtTakingOpinions")), 0);  //征求意见
	vtHandleForward = Util.getIntValue(Util.null2String(rs.getString("vtHandleForward")), 0);  // 转办
	vttpostil=Util.getIntValue(Util.null2String(rs.getString("vttpostil")),0);
	vtrpostil=Util.getIntValue(Util.null2String(rs.getString("vtrpostil")),0);
    vtpostil=Util.getIntValue(Util.null2String(rs.getString("vtpostil")),0);
	vtrecipient = Util.getIntValue(rs.getString("vtrecipient"), 0);
	vtreject = Util.getIntValue(rs.getString("vtreject"), 0);
	vtsuperintend = Util.getIntValue(rs.getString("vtsuperintend"), 0);
	vtover = Util.getIntValue(rs.getString("vtover"), 0);
    vtintervenor = Util.getIntValue(rs.getString("vtintervenor"), 0);
	viewdescall = Util.getIntValue(rs.getString("viewdescall"), 0);
	vdcomments = Util.getIntValue(rs.getString("vdcomments"), 0);
	vddeptname = Util.getIntValue(rs.getString("vddeptname"), 0);
	vdoperator = Util.getIntValue(rs.getString("vdoperator"), 0);
	vddate = Util.getIntValue(rs.getString("vddate"), 0);
	vdtime = Util.getIntValue(rs.getString("vdtime"), 0);
	showtype = Util.getIntValue(rs.getString("showtype"), 0);
	stnull = Util.getIntValue(rs.getString("stnull"), 0);
	printflowcomment = Util.getIntValue(rs.getString("printflowcomment"), 1); //默认选中 流转意见放入模板时不打印
	vsigndoc = Util.getIntValue(rs.getString("vsigndoc"), 0);
	vsignworkflow = Util.getIntValue(rs.getString("vsignworkflow"), 0);
	vmobilesource = Util.getIntValue(rs.getString("vmobilesource"), 0);
	vsignupload = Util.getIntValue(rs.getString("vsignupload"), 0);
	pdfprint = Util.getIntValue(rs.getString("pdfprint"), 0);
}
/***2014-08-15*********/
String showtypeall = "";
String showtypenameall = "";
if(viewtypeall == 1){
	showtypeall = viewtypeall +"";
	showtypenameall = SystemEnv.getHtmlLabelName(332,user.getLanguage());
}else{
	if(vtapprove == 1){
		showtypeall += ",";
		showtypenameall += ",";
		showtypeall += "viewtype_approve2";
		showtypenameall += SystemEnv.getHtmlLabelName(615,user.getLanguage())+"&nbsp";
	}
	if(vtrealize == 1){
		showtypeall += ",";
		showtypenameall += ",";
		showtypeall += "viewtype_realize2";
		showtypenameall += SystemEnv.getHtmlLabelName(142,user.getLanguage());
	}
	if(vtforward == 1){  //转发
		showtypeall += ",";
		showtypenameall += ",";
		showtypeall += "viewtype_forward2";
		showtypenameall += SystemEnv.getHtmlLabelName(6011,user.getLanguage());
	}
	if(vtTakingOpinions == 1){  //意见征询
		showtypeall += ",";
		showtypenameall += ",";
		showtypeall += "view_takingOpinions2";
		showtypenameall += SystemEnv.getHtmlLabelName(82578,user.getLanguage());
	}
	if(vtHandleForward == 1){   // 转办
		showtypeall += ",";
		showtypenameall += ",";
		showtypeall += "view_handleForward2";
		showtypenameall += SystemEnv.getHtmlLabelName(23745,user.getLanguage());
	}
	if(vtpostil == 1){
		showtypeall += ",";
		showtypenameall += ",";
		showtypeall += "viewtype_postil2";
		showtypenameall += SystemEnv.getHtmlLabelName(6011,user.getLanguage())+SystemEnv.getHtmlLabelName(1006,user.getLanguage());
	}

	if(vttpostil == 1){
		showtypeall += ",";
		showtypenameall += ",";
		showtypeall += "viewtype_tpostil2";
		showtypenameall += SystemEnv.getHtmlLabelName(82578,user.getLanguage())+SystemEnv.getHtmlLabelName(18540,user.getLanguage());
	}
	if(vtrpostil == 1){
		showtypeall += ",";
		showtypenameall += ",";
		showtypeall += "viewtype_rpostil2";
		showtypenameall += SystemEnv.getHtmlLabelName(2084,user.getLanguage())+SystemEnv.getHtmlLabelName(1006,user.getLanguage());
	}
	if(vtrecipient == 1){
		showtypeall += ",";
		showtypenameall += ",";
		showtypeall += "viewtype_recipient2";
		showtypenameall += SystemEnv.getHtmlLabelName(2084,user.getLanguage());
	}
	if(vtreject == 1){
		showtypeall += ",";
		showtypenameall += ",";
		showtypeall += "viewtype_reject2";
		showtypenameall += SystemEnv.getHtmlLabelName(236,user.getLanguage());
	}
	if(vtsuperintend == 1){
		showtypeall += ",";
		showtypenameall += ",";
		showtypeall += "viewtype_superintend2";
		showtypenameall += SystemEnv.getHtmlLabelName(21223,user.getLanguage());
	}
	if(vtover == 1){
		showtypeall += ",";
		showtypenameall += ",";
		showtypeall += "viewtype_over2";
		showtypenameall += SystemEnv.getHtmlLabelName(18360,user.getLanguage());
	}
	if(vtintervenor == 1){
		showtypeall += ",";
		showtypenameall += ",";
		showtypeall += "viewtype_intervenor2";
		showtypenameall += SystemEnv.getHtmlLabelName(18913,user.getLanguage());
	}
	if (!"".equals(showtypeall) && showtypeall.length() > 1) {
		showtypeall = showtypeall.substring(1);
	}
	if (!"".equals(showtypenameall) && showtypenameall.length() > 1) {
		showtypenameall = showtypenameall.substring(1);
	}
}

String showdescall = "";
String showdescnameall = "";
if(viewdescall == 1){
	showdescall = viewdescall +"";
	showdescnameall = SystemEnv.getHtmlLabelName(332,user.getLanguage());
}else{
	if(vdcomments == 1){
		showdescall += ",";
		showdescnameall += ",";
		showdescall += "viewdesc_comments2";
		showdescnameall += "<a href='#'>" + SystemEnv.getHtmlLabelName(21662,user.getLanguage()) + "</a>";
	}
	if(vddeptname == 1){
		showdescall += ",";
		showdescnameall += ",";
		showdescall += "viewdesc_deptname2";
		showdescnameall += "<a href='#'>" + SystemEnv.getHtmlLabelName(15390,user.getLanguage()) + "</a>";
	}
	if(vdoperator == 1){
		showdescall += ",";
		showdescnameall += ",";
		showdescall += "viewdesc_operator2";
		showdescnameall += "<a href='#'>" + SystemEnv.getHtmlLabelName(17482,user.getLanguage()) + "</a>";
	}
	if(vddate == 1){
		showdescall += ",";
		showdescnameall += ",";
		showdescall += "viewdesc_date2";
		showdescnameall += "<a href='#'>" + SystemEnv.getHtmlLabelName(21663,user.getLanguage()) + "</a>";
	}
	if(vdtime == 1){
		showdescall += ",";
		showdescnameall += ",";
		showdescall += "viewdesc_time2";
		showdescnameall += "<a href='#'>" + SystemEnv.getHtmlLabelName(15502,user.getLanguage()) + "</a>";
	}
	if(vsigndoc == 1){
		showdescall += ",";
		showdescnameall += ",";
		showdescall += "viewdesc_signdoc2";
		showdescnameall += "<a href='#'>" + SystemEnv.getHtmlLabelName(857,user.getLanguage()) + "</a>";
	}
	if(vsignworkflow == 1){
		showdescall += ",";
		showdescnameall += ",";
		showdescall += "viewdesc_signworkflow2";
		showdescnameall += "<a href='#'>" + SystemEnv.getHtmlLabelName(1044,user.getLanguage()) + "</a>";
	}
	if(vsignupload == 1){
		showdescall += ",";
		showdescnameall += ",";
		showdescall += "viewdesc_signupload2";
		showdescnameall += "<a href='#'>" +SystemEnv.getHtmlLabelName(22194,user.getLanguage()) + "</a>";
	}
	if(vmobilesource == 1){
    		showdescall += ",";
    		showdescnameall += ",";
    		showdescall += "viewdesc_mobilesource2";
    		showdescnameall += "<a href='#'>" +SystemEnv.getHtmlLabelName(504,user.getLanguage())+SystemEnv.getHtmlLabelName(15240,user.getLanguage()) + "</a>";
    	}
	if (!"".equals(showdescall) && showdescall.length() > 1) {
		showdescall = showdescall.substring(1);
	}
	if (!"".equals(showdescnameall) && showdescnameall.length() > 1) {
		showdescnameall = showdescnameall.substring(1);
	}
}

/***2014-08-15*********/

int showhtmlid=0,printhtmlid=0,modbieid=0;
String showhtmlname="",printhtmlname="",modbiename="";
int showhtmlversion=0,printhtmlversion=0,mobileversion=0;	
rs.execute("select * from workflow_nodehtmllayout where nodeid="+nodeid+" and workflowid="+wfid+" and isactive=1");
while(rs.next()){
	int type_tmp = Util.getIntValue(rs.getString("type"), 0);
	int id_tmp = Util.getIntValue(rs.getString("id"), 0);
	String layoutname_tmp = Util.null2String(rs.getString("layoutname"));
	int version_tmp = Util.getIntValue(rs.getString("version"), 0);
	if(type_tmp == 0){//显示模板
		showhtmlid = id_tmp;
		showhtmlname = layoutname_tmp;
		showhtmlversion = version_tmp;
	}else if(type_tmp == 1){//打印模板
		printhtmlid = id_tmp;
		printhtmlname = layoutname_tmp;
		printhtmlversion = version_tmp;
	}else if(type_tmp == 2) { //Mobile模板
		modbieid = id_tmp;
		modbiename = layoutname_tmp;
		mobileversion = version_tmp;
	}
}
boolean indmouldtype = true;
if(isbill==1) {
    rs.executeSql("select indmouldtype from workflow_billfunctionlist where billid=" + formid);
    if(rs.next()) 
    	indmouldtype = Util.null2String(rs.getString("indmouldtype")).equals("1") ? true : false;
}
boolean isHaveMessager=Prop.getPropValue("Mobile","IsUseMobileHtmlLayout").equalsIgnoreCase("1");
String completeUrl2 = "/data.jsp?type=workflowNodeBrowser&wfid="+wfid;
String indmouldtype_disabled = "";
if(!indmouldtype)
	indmouldtype_disabled = " disabled";
%>

<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(16367,user.getLanguage())%>' attributes="<%=hdiv %>">
		<wea:item><%=SystemEnv.getHtmlLabelName(20873,user.getLanguage())%></wea:item>
		<wea:item>
		<div class="outerdiv">
			<%if(ajax==1){%>
				<button type="button" class="e8_btn_top initBtn" onclick="batchSetExcelField()"
				><%=SystemEnv.getHtmlLabelName(125556,user.getLanguage())%></button>
			<%}else{%>
				<button type="button" class="e8_btn_top initBtn" onclick="edithtmlnodefield('<%=nodeid%>','<%=ajax%>','<%=design%>','<%=wfid%>')"
				><%=SystemEnv.getHtmlLabelName(23689,user.getLanguage())%></button>
			<%}%>
		</div>	
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(16450,user.getLanguage())%></wea:item>
		<wea:item>
		<div class="outerdiv">
			<button type="button" class="e8_btn_top" onclick="chooseHtmlLayout('0','show')" <%=indmouldtype_disabled %>><%=SystemEnv.getHtmlLabelName(33251,user.getLanguage())%></button>&nbsp;
			<button type="button" class="e8_btn_top" onclick="onshowExcelDesign('0','0')" <%=indmouldtype_disabled %>><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>
			<span id="showhtmlspan" class="showhtml_span" style="vertical-align:middle;">
				<a href="#" 
				<%if(showhtmlversion==2){ %>
					onclick="onshowExcelDesign('0','<%=showhtmlid %>')"
				<%}else{ %>
					onclick="openFullWindowHaveBar('/workflow/html/LayoutEditFrame.jsp?formid=<%=formid%>&wfid=<%=wfid%>&nodeid=<%=nodeid%>&isform=0&isbill=<%=isbill%>&layouttype=0&modeid=<%=showhtmlid%>&ajax=<%=ajax%>')"
				<%} %>
				><%=showhtmlname%></a>
			</span>
			<span class="printnodesignblockclass" ></span>
			<span class="pdfprint_span"></span>
			<span style="vertical-align:middle;"><%=SystemEnv.getHtmlLabelName(125555,user.getLanguage())%>
			 	<span style="display:inline-block;vertical-align:middle;padding-left:5px;">
					<brow:browser name="syncNodes" viewType="0" hasBrowser="true" hasAdd="false" 
         				getBrowserUrlFn="getShowNodesUrl" getBrowserUrlFnParams="'syncNodes'" isMustInput="1" isSingle="false" hasInput="true"
          				completeUrl='<%=completeUrl2 %>'  width="150px" browserValue="" browserSpanValue="" />
          		</span>
			</span>
			<input type="hidden" id="showhtmlid" name="showhtmlid" value="<%=showhtmlid%>">
			<input type="hidden" id="showhtmlname" name="showhtmlname" value="<%=showhtmlname%>">
			<input type="hidden" id="showhtmlisform" name="showhtmlisform" value="">	
		</div>	
		</wea:item>

		<wea:item><%=SystemEnv.getHtmlLabelName(257,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%></wea:item>
		<wea:item>
		<div class="outerdiv">
			<button type="button" class="e8_btn_top" onclick="chooseHtmlLayout('1','print')"><%=SystemEnv.getHtmlLabelName(33251,user.getLanguage())%></button>&nbsp;
			<button type="button" class="e8_btn_top" onclick="onshowExcelDesign('1','0')" name="createPrintButton_html"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>
			<span id="printhtmlspan" class="showhtml_span" style="vertical-align:middle;">
				<a href="#" 
				<%if(printhtmlversion==2){ %>
					onclick="onshowExcelDesign('1','<%=printhtmlid %>')"
				<%}else{ %>
					onclick="openFullWindowHaveBar('/workflow/html/LayoutEditFrame.jsp?formid=<%=formid%>&wfid=<%=wfid%>&nodeid=<%=nodeid%>&isform=0&isbill=<%=isbill%>&layouttype=1&modeid=<%=printhtmlid%>&ajax=<%=ajax%>')"
				<%} %>
				><%=printhtmlname%></a>
			</span>
			<span class="printnodesignblockclass">
				<select class=inputstyle  name="printflowcomment" value="" style="width:200px;">
					<!-- 0 始终不打印流转意见 1 流转意见放入模板时不打印 2 始终打印流转意见 -->
					<option value="2" <%if(printflowcomment == 2){%> selected <%} %>><%=SystemEnv.getHtmlLabelName(128533, user.getLanguage()) %></option>
					<option value="0" <%if(printflowcomment == 0){%> selected <%} %>><%=SystemEnv.getHtmlLabelName(128534, user.getLanguage()) %></option>
					<option value="1" <%if(printflowcomment == 1){%> selected <%} %>><%=SystemEnv.getHtmlLabelName(128535, user.getLanguage()) %></option>
				</select>
				 <!-- <SPAN style="position: relative;left: 6px;bottom: 2px;padding-right:4px;" id="remind" title="<%=SystemEnv.getHtmlLabelName(126585,user.getLanguage())%>"><IMG id=ext-gen124 align=absMiddle src="/images/remind_wev8.png"></SPAN> -->
			</span>
			<span class="pdfprint_span">
				<input type="checkbox" name="pdfprint" <%=pdfprint==1?"checked":"" %>/>
				<span><%=SystemEnv.getHtmlLabelName(83180, user.getLanguage()) %></span>
				<span style="position:relative; top:-2px;" title="<%=SystemEnv.getHtmlLabelName(83181, user.getLanguage()) %>">
					<img src="/images/tooltip_wev8.png" align="absMiddle">
				</span>
			</span>
			<span style="vertical-align:middle;"><%=SystemEnv.getHtmlLabelName(125555,user.getLanguage())%>
			<span style="display:inline-block;vertical-align:middle;padding-left:5px;">			
			<brow:browser name="printsyncNodes" viewType="0" hasBrowser="true" hasAdd="false" 
         		getBrowserUrlFn="getShowNodesUrl" getBrowserUrlFnParams="'printsyncNodes'" isMustInput="1" isSingle="false" hasInput="true"
          		completeUrl='<%=completeUrl2 %>'  width="150px" browserValue="" browserSpanValue="" />
          	</span>
			</span>
            <input type="hidden" id="printhtmlid" name="printhtmlid" value="<%=printhtmlid%>">
			<input type="hidden" id="printhtmlname" name="printhtmlname" value="<%=printhtmlname%>">
			<input type="hidden" id="printhtmlisform" name="printhtmlisform" value="">		
		</div>
		</wea:item>
		
		<%if(isHaveMessager){%>
		<wea:item><%=SystemEnv.getHtmlLabelName(125554,user.getLanguage())%></wea:item>
		<wea:item>
		<div class="outerdiv">
			<button type="button" class="e8_btn_top" onclick="chooseHtmlLayout('2','mobile')" <%=indmouldtype_disabled %>><%=SystemEnv.getHtmlLabelName(33251,user.getLanguage())%></button>&nbsp;
			<button type="button" class="e8_btn_top" onclick="onshowExcelDesign('2','0')" <%=indmouldtype_disabled %>><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>
			<span id="mobilehtmlspan" class="showhtml_span" style="vertical-align:middle;">
				<a href="#" 
				<%if(mobileversion==2){ %>
					onclick="onshowExcelDesign('2','<%=modbieid %>')"
				<%}else{ %>
					onclick="openFullWindowHaveBar('/workflow/html/LayoutEditFrame.jsp?formid=<%=formid%>&wfid=<%=wfid%>&nodeid=<%=nodeid%>&isform=0&isbill=<%=isbill%>&layouttype=2&modeid=<%=modbieid%>&ajax=<%=ajax%>')"
				<%} %>
				><%=modbiename%></a>
			</span>
			<span class="printnodesignblockclass" > </span>
			<span class="pdfprint_span"></span>
			<span style="vertical-align:middle;"><%=SystemEnv.getHtmlLabelName(125555,user.getLanguage())%>
				<span style="display:inline-block;vertical-align:middle;padding-left:5px;">		
					<brow:browser name="syncMNodes" viewType="0" hasBrowser="true" hasAdd="false" 
         		 		getBrowserUrlFn="getShowNodesUrl" getBrowserUrlFnParams="'syncMNodes'" isMustInput="1" isSingle="false" hasInput="true"
          		 		completeUrl='<%=completeUrl2 %>'  width="150px" browserValue="" browserSpanValue="" />
          		</span>
			</span>
            <input type="hidden" id="mobilehtmlid" name="mobilehtmlid" value="<%=modbieid%>">
			<input type="hidden" id="mobilehtmlname" name="mobilehtmlname" value="<%=modbiename%>">
			<input type="hidden" id="mobilehtmlisform" name="mobilehtmlisform" value="">		
		</div>
		</wea:item>
		<%} %>
		</wea:group>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(21652,user.getLanguage())%>' attributes="<%=hdiv %>">
			<wea:item><%=SystemEnv.getHtmlLabelName(17139,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser name="viewtype_all2" viewType="0" hasBrowser="true" hasAdd="false" 
				    		browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/wfnTypeShow.jsp?resourceids=#id#&ishtml=1"  isMustInput="1" isSingle="false" hasInput="true"
				    		completeUrl=""  width="165px" browserValue='<%=showtypeall %>' browserSpanValue='<%=showtypenameall %>' />
				<%--<input type="checkbox" name="viewtype_all2" value="1" onclick="selectviewall2('viewtype',this.checked)" <%if(viewtypeall==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%>--%>
			</wea:item>
			<%--
			<wea:item attributes="{'colspan':'full'}">
				<table class="ListStyle" id="viewtypetab2">
					<tr>
					<TD width="50%"><input type="checkbox" name="viewtype_approve2" value="1" <%if(vtapprove==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></TD>
					<TD width="50%"><input type="checkbox" name="viewtype_realize2" value="1" <%if(vtrealize==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></TD>
					</tr>
					<tr>
					<TD width="50%"><input type="checkbox" name="viewtype_forward2" value="1" <%if(vtforward==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(6011,user.getLanguage())%></TD>
					<TD width="50%"><input type="checkbox" name="view_takingOpinions2" value="1" <%if(vtTakingOpinions==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(82578,user.getLanguage())%></TD>
					<TD width="50%"><input type="checkbox" name="view_handleForward2" value="1" <%if(vtHandleForward==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(23745,user.getLanguage())%></TD>
					<TD width="50%"><input type="checkbox" name="viewtype_postil2" value="1" <%if(vtpostil==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(6011,user.getLanguage())%>+<%=SystemEnv.getHtmlLabelName(1006,user.getLanguage())%></TD>
					<TD width="50%"><input type="checkbox" name="viewtype_tpostil2" value="1" <%if(vttpostil==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(82578,user.getLanguage())%>+<%=SystemEnv.getHtmlLabelName(18540,user.getLanguage())%></TD>
					<TD width="50%"><input type="checkbox" name="viewtype_rpostil2" value="1" <%if(vtrpostil==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(2084,user.getLanguage())%>+<%=SystemEnv.getHtmlLabelName(1006,user.getLanguage())%></TD>
					</tr>
					<tr>
					<TD width="50%"><input type="checkbox" name="viewtype_recipient2" value="1" <%if(vtrecipient==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(2084,user.getLanguage())%></TD>
					<TD width="50%"><input type="checkbox" name="viewtype_reject2" value="1" <%if(vtreject==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></TD>
					</tr>
					<tr>
					<TD width="50%"><input type="checkbox" name="viewtype_superintend2" value="1" <%if(vtsuperintend==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(21223,user.getLanguage())%></TD>
					<TD width="50%"><input type="checkbox" name="viewtype_over2" value="1" <%if(vtover==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(18360,user.getLanguage())%></TD>
					</tr>
		            <tr>
					<TD width="50%"><input type="checkbox" name="viewtype_intervenor2" value="1" <%if(vtintervenor==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(18913,user.getLanguage())%></TD>
					</tr>
				</table>		
			</wea:item>
			--%>
			<wea:item><%=SystemEnv.getHtmlLabelName(15935,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser name="viewdesc_all2" viewType="0" hasBrowser="true" hasAdd="false" 
				    		browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/wfnContentShow.jsp?resourceids=#id#&ishtml=1"  isMustInput="1" isSingle="false" hasInput="true"
				    		completeUrl=""  width="165px" browserValue='<%=showdescall %>' browserSpanValue='<%=showdescnameall %>' />
				<%--<input type="checkbox" name="viewdesc_all2" value="1" onclick="selectviewall2('viewdesc',this.checked)" <%if(viewdescall==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%>--%>
			</wea:item>
			<%--
			<wea:item attributes="{'colspan':'full'}">
				<table class="ListStyle" id="viewdesctab2">
					<tr>
					<TD width="50%"><input type="checkbox" name="viewdesc_comments2" value="1" <%if(vdcomments==1||viewdescall==1){%>checked <%}if(viewdescall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(21662,user.getLanguage())%></TD>
					<TD width="50%"><input type="checkbox" name="viewdesc_deptname2" value="1" <%if(vddeptname==1||viewdescall==1){%>checked <%}if(viewdescall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(15390,user.getLanguage())%></TD>
					</tr>
					<tr>
					<TD width="50%"><input type="checkbox" name="viewdesc_operator2" value="1" <%if(vdoperator==1||viewdescall==1){%>checked <%}if(viewdescall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(17482,user.getLanguage())%></TD>
					<TD width="50%"><input type="checkbox" name="viewdesc_date2" value="1" <%if(vddate==1||viewdescall==1){%>checked <%}if(viewdescall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(21663,user.getLanguage())%></TD>
					</tr>
					<tr>
					<TD width="50%"><input type="checkbox" name="viewdesc_time2" value="1" <%if(vdtime==1||viewdescall==1){%>checked <%}if(viewdescall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(15502,user.getLanguage())%></TD>
		            <TD width="50%"><input type="checkbox" name="viewdesc_signdoc2" value="1" <%if(vsigndoc==1||viewdescall==1){%>checked <%}if(viewdescall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></TD>
		            </tr>
		            <tr>
		            <TD width="50%"><input type="checkbox" name="viewdesc_signworkflow2" value="1" <%if(vsignworkflow==1||viewdescall==1){%>checked <%}if(viewdescall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></TD>
		            <TD width="50%"><input type="checkbox" name="viewdesc_signupload2" value="1" <%if(vsignupload==1||viewdescall==1){%>checked <%}if(viewdescall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></TD>
					<TD width="50%"><input type="checkbox" name="viewdesc_mobilesource2" value="1" <%if(vmobilesource==1||viewdescall==1){%>checked <%}if(viewdescall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(504,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15240,user.getLanguage()%></TD>    
		            </tr>
				</table>		
			</wea:item>
			--%>
			<wea:item><%=SystemEnv.getHtmlLabelName(21653,user.getLanguage())%></wea:item>
			<wea:item>
				<select class=inputstyle  name="showtype2" style="width:137px;">
					<option value="0" <%if(showtype!=1){%> selected <%}%>><strong><%=SystemEnv.getHtmlLabelName(21654,user.getLanguage())%></strong>
					<option value="1" <%if(showtype==1){%> selected <%}%>><strong><%=SystemEnv.getHtmlLabelName(21655,user.getLanguage())%></strong>
				</select>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(21678,user.getLanguage())%></wea:item>
			<wea:item><input type="checkbox" tzCheckbox="true" name="showtype_null2" value="1" <%if(stnull==1){%>checked<%}%>></td></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(125020,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser name="noderemarksync2" viewType="0" hasBrowser="true" hasAdd="false" 
					getBrowserUrlFn="getShowNodesUrl1" getBrowserUrlFnParams="'noderemarksync2'" isMustInput="1" isSingle="false" hasInput="true"
					completeUrl='<%="/data.jsp?type=workflowNodeBrowser&wfid="+wfid %>'  width="150px" browserValue="" browserSpanValue="" />
			</wea:item>
	</wea:group>
</wea:layout>


<script type="text/javascript">

jQuery(function(){
	jQuery("span[id^=remind]").wTooltip({html:true});
})
//新表单设计器-批量设置表单字段
function batchSetExcelField(){
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/workflow/exceldesign/excelInitModule.jsp?wfid=<%=wfid %>&nodeid=<%=nodeid %>&layouttype=0&modeid=<%=showhtmlid %>&fromwhere=batchset";
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(129435, user.getLanguage())%>";
	dialog.Width = 810;
	dialog.Height = 570;
	dialog.hideDraghandle = true;	
	dialog.URL = url;
	dialog.show();
}

//选择Html模板
function chooseHtmlLayout(choosetype, target){
	var curlayoutid = jQuery("input#"+target+"htmlid").val();
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/workflow/exceldesign/chooseHtmlTemplateTab.jsp?wfid=<%=wfid %>&formid=<%=formid %>&isbill=<%=isbill %>&choosetype="+choosetype+"&curlayoutid="+curlayoutid;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage()) %>";
	dialog.Width = 750;
	dialog.Height = 650;
	dialog.maxiumnable = false;
	dialog.URL = url;
	dialog.callback = function(datas){
		if(datas.id){
			jQuery("input#"+target+"htmlid").val(datas.id);
			jQuery("input#"+target+"htmlname").val(datas.name);
			jQuery("span#"+target+"htmlspan").text(datas.name);
			dialog.close();
		}
	}
	dialog.show();
}


//打开新表单设计器
function onshowExcelDesign(layouttype, modeid){
	var dlg=new window.top.Dialog();//定义Dialog对象
	dlg.currentWindow=window;
	dlg.Model=true;
    if ($.browser.msie && parseInt($.browser.version, 10) < 9) {		//run for ie7/8
    	dlg.maxiumnable=false;
    	dlg.Width = 1000;
		dlg.Height = 600;
    	dlg.URL="/wui/common/page/sysRemind.jsp?labelid=124796";
    	dlg.hideDraghandle = false;
    }else{
    	dlg.maxiumnable=true;
    	dlg.Width = $(window.top).width()-60;
		dlg.Height = $(window.top).height()-80;
    	dlg.URL="/workflow/exceldesign/excelMain.jsp?wfid=<%=wfid %>&nodeid=<%=nodeid %>&formid=<%=formid %>&isbill=<%=isbill %>&layouttype="+layouttype+"&modeid="+modeid;
    	dlg.hideDraghandle = true;
    } 
	dlg.Title="<%=SystemEnv.getHtmlLabelName(128169, user.getLanguage())%>";
	dlg.closeHandle = function (paramobj, datas){
		window.location.reload();
	}
　　 dlg.show();
}


</script>