
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="GetFormDetailInfo" class="weaver.workflow.automatic.GetFormDetailInfo" scope="page" />
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<% 
if(!HrmUserVarify.checkUserRight("intergration:automaticsetting",user)) {
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}
%>
<%
String setname = "";
String datasourceid = "";
String workflowname = "";
String outermaintable = "";
String keyfield = "";
String datarecordtype = "";
String requestid = "";
String FTriggerFlag = "";
String FTriggerFlagValue = "";
String outermainwhere = "";
String successback = "";
String failback = "";
String outerdetailtables = "";
String outerdetailwheres = "";
//QC289154  [80][90]流程触发集成-名称重复，点击保存，应该只是弹出系统提示，而不是最后关闭新建/编辑流程触发集成页面   ---stat
String isview = "";
String isnextnode=""; //是否停留创建节点 
String isupdatewfdata="";  //创建节点修改流程数据
String isupdatewfdataField=""; //修改流程数据标志字段
setname = Util.null2String(request.getParameter("setname"));//名称
datasourceid = Util.null2String(request.getParameter("datasourceid"));//数据源
outermaintable = Util.null2String(request.getParameter("outermaintable"));//外部主表
outermainwhere = Util.null2String(request.getParameter("outermainwhere"));//外部主表条件
successback = Util.null2String(request.getParameter("successback"));//流程触发成功时回写设置
failback = Util.null2String(request.getParameter("failback"));//流程触发失败时回写设置
datarecordtype = Util.null2String(request.getParameter("datarecordtype"));//
keyfield = Util.null2String(request.getParameter("keyfield"));//
requestid = Util.null2String(request.getParameter("requestid"));//
FTriggerFlag = Util.null2String(request.getParameter("FTriggerFlag"));//
FTriggerFlagValue = Util.null2String(request.getParameter("FTriggerFlagValue"));//
isview = Util.null2String(request.getParameter("isview"));//
isnextnode = Util.null2String(request.getParameter("isnextnode")); //是否停留创建节点 
isupdatewfdata = Util.null2String(request.getParameter("isupdatewfdata"));  //创建节点修改流程数据
isupdatewfdataField = Util.null2String(request.getParameter("isupdatewfdataField"));  //修改流程数据标志字段
ArrayList outerdetailtablesArr = new ArrayList();
ArrayList outerdetailwheresArr = new ArrayList();
String isDialog = Util.null2String(request.getParameter("isdialog"));
//QC289154  [80][90]流程触发集成-名称重复，点击保存，应该只是弹出系统提示，而不是最后关闭新建/编辑流程触发集成页面   ---end

String msg = Util.null2String(request.getParameter("msg"));
String typename = Util.null2String(request.getParameter("typename"));
String backto = Util.null2String(request.getParameter("backto"));
if(!"".equals(backto))
	typename = backto;
String viewid = Util.null2String(request.getParameter("viewid"));
String workflowid = Util.null2String(request.getParameter("workFlowId"));
String operate = Util.null2String(request.getParameter("operate"));
String formID = "";
String isbill = "";
boolean isnew = true;

if(operate.equals("reedit")){//编辑时重新选择流程
    setname = Util.null2String(request.getParameter("setname"));
    workflowid = Util.null2String(request.getParameter("workFlowId"));
    datasourceid = Util.null2String(request.getParameter("datasourceid"));
    
}else{
    RecordSet.executeSql("select * from outerdatawfset where id='"+viewid+"'");
    if(RecordSet.next()){
        setname = Util.null2String(RecordSet.getString("setname"));
        workflowid = Util.null2String(RecordSet.getString("workflowid"));
        datasourceid = Util.null2String(RecordSet.getString("datasourceid"));
        outermaintable = Util.null2String(RecordSet.getString("outermaintable"));
        keyfield = Util.null2String(RecordSet.getString("keyfield"));
        datarecordtype = Util.null2String(RecordSet.getString("datarecordtype"));
        requestid = Util.null2String(RecordSet.getString("requestid"));
        FTriggerFlag = Util.null2String(RecordSet.getString("FTriggerFlag"));
        FTriggerFlagValue = Util.null2String(RecordSet.getString("FTriggerFlagValue"));
        
        outermainwhere = Util.null2String(RecordSet.getString("outermainwhere"));
        successback = Util.null2String(RecordSet.getString("successback"));
        failback = Util.null2String(RecordSet.getString("failback"));
        outerdetailtables = Util.null2String(RecordSet.getString("outerdetailtables"));
        outerdetailwheres = Util.null2String(RecordSet.getString("outerdetailwheres"));
        outerdetailtablesArr = Util.TokenizerString(outerdetailtables,",");
        //outerdetailwheresArr = Util.TokenizerString(outerdetailwheres,"$@|@$");
        String[] outerdetailtablesStrArr=outerdetailwheres.split("\\$@\\|@\\$");
        isview = Util.null2String(RecordSet.getString("isview"));
        isnextnode = Util.null2String(RecordSet.getString("isnextnode"));
        isupdatewfdata = Util.null2String(RecordSet.getString("isupdatewfdata"));
        isupdatewfdataField = Util.null2String(RecordSet.getString("isupdatewfdataField"));
        isnew = false;
        if("".equals(keyfield))
    	keyfield = "id";
        
        for(int i=0;i<outerdetailtablesStrArr.length;i++){
        	outerdetailwheresArr.add(outerdetailtablesStrArr[i]);
       }   
    }
}
boolean isexist = false;
ArrayList pointArrayList = DataSourceXML.getPointArrayList();
for(int i=0;i<pointArrayList.size();i++){
    String pointid = (String)pointArrayList.get(i);
    if(datasourceid.equals(pointid)){
        isexist = true;
    }
}
if(!isexist)
{
	datasourceid  = "";
}
//out.println("datasourceid : "+datasourceid);
if(!"".equals(workflowid))
{
	workflowname = Util.null2String(WorkflowComInfo.getWorkflowname(workflowid));
	isbill = Util.null2String(WorkflowComInfo.getIsBill(workflowid));
	formID = Util.null2String(WorkflowComInfo.getFormId(workflowid));
}
if("".equals(datarecordtype))
	datarecordtype = "1";
int detailcount = GetFormDetailInfo.getDetailNum(formID,isbill);
%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />
<script type="text/javascript" src="/wui/common/jquery/plugin/jQuery.modalDialog_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/wuiform/jquery.wuiform_wev8.js"></script>

</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23076,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(367,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body id='setbody' <%if("1".equals(isview)){ %> onload="viewSet()"<%} %>>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<script language=javascript >
var parentWin = parent.parent.getParentWindow(parent);


function viewSet(){
	jQuery('#datarecordtype').selectbox('change',1);
	jQuery('#datarecordtype').selectbox('disable');
	
	jQuery('#isupdatewfdata').selectbox('change',1);
	jQuery('#isupdatewfdata').selectbox('disable')
}

function viewChg(v){
	if(!v.checked){
	//	v.value=1;
		jQuery('#isview').val(0);
		
		//alert(1);
		//ChangeDatarecordType(2);
		//jQuery('#datarecordtype').selectbox('change',2);
		jQuery('#datarecordtype').selectbox('enable');
		jQuery('#isupdatewfdata').selectbox('enable');
	}else{

        jQuery('#isview').val(1);
        
		ChangeDatarecordType(1);
		jQuery('#datarecordtype').selectbox('change',1);
		jQuery('#datarecordtype').selectbox('disable')
		
		ChangeIsupdatewfdatagroup(1);
		jQuery('#isupdatewfdata').selectbox('change',1);
		jQuery('#isupdatewfdata').selectbox('disable');
		
	}
}


</script>
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(1),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(viewid.equals("")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(125540,user.getLanguage())+",javascript:submitData(2),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(32367,user.getLanguage())+",javascript:getTest(),_self} " ;//有效性检查
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBack(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" id="submitData" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="submitData(1)"/>
			<%if(viewid.equals("")){%>
			<input type="button" id="submitAndDetailData" value="<%=SystemEnv.getHtmlLabelName(125540 ,user.getLanguage()) %>" class="e8_btn_top" onclick="submitData(2)"/>
			<%}%>
			<input type="button" id="getTest" value="<%=SystemEnv.getHtmlLabelName(32367 ,user.getLanguage()) %>" class="e8_btn_top" onclick="getTest()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form name="frmmain" method="post" action="automaticOperation.jsp">
<input type="hidden" id="operate" name="operate" value="edit">
<input type="hidden" id="typename" name="typename" value="<%=typename%>">
<input type="hidden" id="backto" name="backto" value="<%=backto%>">
<input type="hidden" id="viewid" name="viewid" value="<%=viewid%>">
<input type="hidden" id="detailcount" name="detailcount" value="<%=detailcount%>">
<%if("1".equals(isDialog)){ %>
<input type="hidden" name="isdialog" value="<%=isDialog%>">
<%} %>
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(21988,user.getLanguage())+SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
	  <wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
			<wea:item>
				<wea:required id="setnamespan" required="true" value='<%=setname%>'>
				<!--QC282793 [80][90]流程触发集成-新建/编辑页面【名称】前后空格问题   增加鼠标移除事件（onblur="isExist(this.value)"）-->
				<input type=text size=35 class=inputstyle style='width:280px!important;' id="setname" name="setname" value="<%=setname%>" onChange="checkinput('setname','setnamespan')" onblur="isExist(this.value)">
				</wea:required>
			</wea:item>
	  		<wea:item><%=SystemEnv.getHtmlLabelName(18104,user.getLanguage())%></wea:item>
			<wea:item>
				<!-- input id="workFlowId" class="wuiBrowser" name="workFlowId" _url="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp" _scroll="no" _callback="" value="<%=workflowid %>" _displayText="<%=workflowname %>" _displayTemplate="" _required="yes"/ -->
				<brow:browser viewType="0" name="workFlowId" browserValue='<%= ""+workflowid %>' 
					browserUrl="/systeminfo/BrowserMain.jsp?mouldID=workflow&url=/workflow/workflow/WorkflowBrowser.jsp?showvalid=1"
					hasInput="true" isSingle="true" hasBrowser="true" isMustInput='2' hasAdd="false"
					completeUrl="/data.jsp?type=workflowBrowser&isTemplate=0" linkUrl=""
					browserSpanValue='<%=workflowname %>' width='280px' _callback="onShowWorkFlowSerach"></brow:browser>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%></wea:item>
			<wea:item>
				<wea:required id="datasourceidspan" required="true" value='<%=datasourceid %>'>
				<select id="datasourceid" name="datasourceid" style='width:120px!important;' onchange="ChangeDatasource(this,datasourceidspan)">
					<option></option>
					<%
					for(int i=0;i<pointArrayList.size();i++){
					    String pointid = (String)pointArrayList.get(i);
					    String isselected = "";
					    if(datasourceid.equals(pointid)){
					        isexist = true;
					        isselected = "selected";
					    }
					%>
					<option value="<%=pointid%>" <%=isselected%>><%=pointid%></option>
					<%    
					}
					%>
				</select>
				</wea:required>
				<%-- <input type="button" value="<%=SystemEnv.getHtmlLabelName(68,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage()) %>" onClick="setDataSource();" class="e8_btn_submit"/> --%>
			</wea:item>
		<%if(!workflowid.equals("")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%></wea:item>
			<wea:item>
				<wea:required id="outermaintablespan" required="true" value='<%=outermaintable%>'>
				<input type=text size=35 class=inputstyle style='width:280px!important;' id="outermaintable" name="outermaintable" value="<%=outermaintable%>" onchange="checkinput('outermaintable','outermaintablespan')">
				</wea:required>
				<input type="checkbox" id="isview" name="isview" value="<%=isview %>" onclick="viewChg(this)"  <%if(isview.equals("1")){%>checked<%}%>  ><%=SystemEnv.getHtmlLabelName(128488,user.getLanguage()) %></input>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(32368,user.getLanguage())%></wea:item><!-- 外部主表/视图的关键字段 -->
			<wea:item>
				<!-- button type='button' class=Browser name=TableField onClick="onShowTableField(this,1);"></BUTTON><input type=text size=35 maxLength=50 class=inputstyle style='width:120px!important;' name="keyfield" value="<%=keyfield %>" onchange="checkinput('keyfield','keyfieldspan')" -->
				<brow:browser viewType="0" name="keyfield" browserValue='<%= ""+keyfield %>' 
					browserUrl="" getBrowserUrlFn='onShowTableField' getBrowserUrlFnParams='1'
					hasInput="false" isSingle="true" hasBrowser = "true" isMustInput='2'
					completeUrl="/data.jsp" linkUrl=""
					browserSpanValue='<%=keyfield %>' width='200px' _callback=''></brow:browser>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(32369,user.getLanguage())%></wea:item><!-- 是否回写标志到外部主表 -->
			<wea:item>
				<select id="datarecordtype" name="datarecordtype" style='width:120px!important;' onchange="ChangeDatarecordType(this.value)">
					<option value="1" <%if("1".equals(datarecordtype)) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option><!-- 否 -->
					<option value="2" <%if("2".equals(datarecordtype)) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option><!-- 是 -->
				</select>
			</wea:item>
	    	<wea:item attributes="{'samePair':'datarecord'}"><%=SystemEnv.getHtmlLabelName(32370,user.getLanguage())%></wea:item><!-- 触发成功回写流程ID字段 -->
			<wea:item attributes="{'samePair':'datarecord'}">
				<brow:browser viewType="0" name="requestid" browserValue='<%= ""+requestid %>' 
					browserUrl="" getBrowserUrlFn='onShowTableField' getBrowserUrlFnParams='1'
					hasInput="false" isSingle="true" hasBrowser = "true" isMustInput='2'
					completeUrl="/data.jsp" linkUrl=""
					browserSpanValue='<%=requestid %>' width='200px' _callback=''></brow:browser>
			</wea:item>
			<wea:item attributes="{'samePair':'datarecord'}"><%=SystemEnv.getHtmlLabelName(32371,user.getLanguage())%></wea:item><!-- 触发成功回写标志字段 -->
			<wea:item attributes="{'samePair':'datarecord'}">
				<brow:browser viewType="0" name="FTriggerFlag" browserValue='<%= ""+FTriggerFlag %>' 
					browserUrl="" getBrowserUrlFn='onShowTableField' getBrowserUrlFnParams='1'
					hasInput="false" isSingle="true" hasBrowser = "true" isMustInput='2'
					completeUrl="/data.jsp" linkUrl=""
					browserSpanValue='<%=FTriggerFlag %>' width='200px' _callback=''></brow:browser>
				<wea:required id="FTriggerFlagValuespan" required="true" value='<%=FTriggerFlagValue %>'>
				&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(32372,user.getLanguage())%>&nbsp;&nbsp;:&nbsp;&nbsp;<input type=text size=35 style='width:120px!important;' maxLength=50 class=inputstyle name="FTriggerFlagValue" value="<%=FTriggerFlagValue %>" onchange="checkinput('FTriggerFlagValue','FTriggerFlagValuespan')">
				</wea:required>
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(129922,user.getLanguage())%></wea:item><!-- 是否停留创建节点 -->
			<wea:item>
				<select id="isnextnode" name="isnextnode" style='width:120px!important;' ">
					<option value="1" <%if("1".equals(isnextnode)) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option><!-- 否 -->
					<option value="2" <%if("2".equals(isnextnode)) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option><!-- 是 -->
				</select>
			
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(130121,user.getLanguage())%></wea:item><!-- 创建节点修改流程数据 -->
			<wea:item>
				<select id="isupdatewfdata" name="isupdatewfdata" style='width:120px!important;' onchange="ChangeIsupdatewfdatagroup(this.value)">
					<option value="1" <%if("1".equals(isupdatewfdata)) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option><!-- 否 -->
					<option value="2" <%if("2".equals(isupdatewfdata)) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option><!-- 是 -->
				</select>
			<SPAN class="e8tips" style="CURSOR: hand" id=isnextnoderemind title="<%=SystemEnv.getHtmlLabelName(130737, user.getLanguage()) %>"><IMG src="/images/tooltip_wev8.png" align="absMiddle"/></SPAN>
			</wea:item>
			
			<wea:item attributes="{'samePair':'isupdatewfdatagroup'}"><%=SystemEnv.getHtmlLabelName(130122,user.getLanguage())%></wea:item><!-- 修改流程数据标志字段 -->
			<wea:item attributes="{'samePair':'isupdatewfdatagroup'}">
				<brow:browser viewType="0" name="isupdatewfdataField" browserValue='<%= ""+isupdatewfdataField %>' 
					browserUrl="" getBrowserUrlFn='onShowTableField' getBrowserUrlFnParams='1'
					hasInput="false" isSingle="true" hasBrowser = "true" isMustInput='2'
					completeUrl="/data.jsp" linkUrl=""
					browserSpanValue='<%=isupdatewfdataField %>' width='200px' _callback=''></brow:browser>
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></wea:item>
			<wea:item>
				<textarea id="outermainwhere" name="outermainwhere" cols=100 rows=4 ><%=outermainwhere%></textarea>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(23107,user.getLanguage())%></wea:item>
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(23108,user.getLanguage())%>:<br>
				<textarea id="successback" name="successback" cols=100 rows=4 ><%=successback%></textarea><br>
				<%=SystemEnv.getHtmlLabelName(23109,user.getLanguage())%>:<br>
				<textarea id="failback" name="failback" cols=100 rows=4 ><%=failback%></textarea>
			</wea:item>
		<%
		for(int i=0;i<detailcount;i++){
		    String outerdetailtable = "";
		    String outerdetailwhere = "";
		    if(!operate.equals("reedit")){
		        if(outerdetailtablesArr.size()>i){
		            outerdetailtable = (String)outerdetailtablesArr.get(i);
		            outerdetailwhere = (String)outerdetailwheresArr.get(i);
		            if(outerdetailtable.equals("-")) outerdetailtable = "";
		            if(outerdetailwhere.equals("-")) outerdetailwhere = "";
		        }
		    }
		%>
			<wea:item><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%><%=i+1%></wea:item>
			<wea:item><input type=text size=35 class=inputstyle id="outerdetailname<%=i%>" name="outerdetailname<%=i%>" value='<%=outerdetailtable%>' onchange="checkDetail(this.value,<%=detailcount%>,<%=i%>)"></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%><%=i+1%><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></wea:item>
			<wea:item>
				<textarea id="outerdetailwhere<%=i%>" name="outerdetailwhere<%=i%>" cols=100 rows=4 ><%=outerdetailwhere%></textarea>
			</wea:item>
		<%}%>
		<%}%>
		</wea:group>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>' attributes="{'samePair':'RemarkInfo','groupOperDisplay':'none','itemAreaDisplay':'block'}">
			<wea:item attributes="{'colspan':'2'}">
			<font style="word-break:break-all;">
				1:<%=SystemEnv.getHtmlLabelName(23111,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(23154,user.getLanguage())%><BR>
				2:<%=SystemEnv.getHtmlLabelName(23110,user.getLanguage())%><BR>
				3:<%=SystemEnv.getHtmlLabelName(23152,user.getLanguage())%><BR>
                4:<%=SystemEnv.getHtmlLabelName(31318,user.getLanguage())%><br>
			</font>
			</wea:item>
		</wea:group>
	</wea:layout>
</form>
<%if("1".equals(isDialog)){ %>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" onclick="onClose();"></input>
				</wea:item>
			</wea:group>
		</wea:layout>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				resizeDialog(document);
			});
		</script>
	</div>
</div>
<%} %>
</body>
</html>
<script language="javascript">


//QC289154 [80][90]流程触发集成-名称重复，点击保存，应该只是弹出系统提示，而不是最后关闭新建/编辑流程触发集成页面 ---strat
$(document).ready(function(){
	<%if("1".equals(msg)){%>
	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129932, user.getLanguage())%>!");//名称已存在，请重新填写
	<%}else if("2".equals(msg)){%>
	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129512, user.getLanguage())%>!");//必填字段不能为空
	<%}%>
	jQuery(".e8tips").wTooltip({html:true});
});

//QC289154 [80][90]流程触发集成-名称重复，点击保存，应该只是弹出系统提示，而不是最后关闭新建/编辑流程触发集成页面 ---end

function checkDetail(objvalue,detailcount,num){
	for(var i=0;i<detailcount;i++){
	  	if(i != num){
		  	var tempouterdetailname = document.getElementById("outerdetailname"+i).value;
		  	if(tempouterdetailname.trim() == objvalue.trim()){
		  		document.getElementById("outerdetailname"+num).value = "";
		  		alert("<%=SystemEnv.getHtmlLabelName(127192,user.getLanguage())%>");
		  	}
	  	}
        
    }
}
window.onbeforeunload = function protectManageBillFlow(event){
  	if(!checkDataChange())//added by cyril on 2008-06-10 for TD:8828
        return "<%=SystemEnv.getHtmlLabelName(18407,user.getLanguage())%>";
}


$(document).ready(function(){
	wuiform.init();
});
function submitData(type){
	//QC286119  [80][90]流程触发集成-外部明细表条件中where若输入大写，会拼接SQL错误，导致明细表插入内容失败 START
	if(type == 1) {
        $("[name^='outerdetailwhere']").each(function (test) {
            var reallyTest = $.trim($(this).val());
            if (reallyTest.length > 5) {
                var lowerTest = reallyTest.toLowerCase();
                var isWhere = lowerTest.substr(0,5);
                if("where" == isWhere) {
                    var testval2 = "where" + reallyTest.substr(5);
                    $(this).val(testval2);
                }
            }
        })
		
		//QC286119  [80][90]流程触发集成-外部明细表条件中where若输入大写，会拼接SQL错误，导致明细表插入内容失败 end
	   //QC286417  [80][90]流程触发集成-外部主表回写设置中set若输入大写，会拼接SQL错误，导致外部主表插入内容失败 START
		var setSucessSql = $.trim($("[name='successback']").val());
        if(setSucessSql && setSucessSql.length >3){
            var lowerTest = setSucessSql.toLowerCase();
            var isSet = lowerTest.substr(0,3);
            if("set" == isSet) {
                var reallySetSql = "set" + setSucessSql.substr(3);
                $("[name='successback']").val(reallySetSql)
            }
		}
        var setFailSql = $.trim($("[name='failback']").val());
        if(setFailSql && setFailSql.length >3){
            var lowerTest = setFailSql.toLowerCase();
            var isSet = lowerTest.substr(0,3);
            if("set" == isSet) {
                var reallyFailSetSql = "set" + setFailSql.substr(3);
                $("[name='failback']").val(reallyFailSetSql)
            }
        }

    }
    //QC286417  [80][90]流程触发集成-外部主表回写设置中set若输入大写，会拼接SQL错误，导致外部主表插入内容失败 end


	var fieldchecks = "setname,workFlowId,datasourceid,outermaintable,keyfield";
	<%if(!workflowid.equals("")){%>
	var datarecordtype = frmmain.datarecordtype.value;
	var isupdatewfdata = frmmain.isupdatewfdata.value;
	if(datarecordtype==2)
	{
		fieldchecks += ",requestid,FTriggerFlag,FTriggerFlagValue";
	}
	if(isupdatewfdata==2)
	{
		fieldchecks += ",isupdatewfdataField";
	}
	<%}%>
	<%
	if("".equals(viewid))
	{
	%>
	if(type==1){//保存
		document.frmmain.operate.value = "add";
	}else if(type==2){//保存后进入详细设置页面
		document.frmmain.operate.value = "addAndDetail";
	}
	<%
	}
	%>
    if(check_form($GetEle("frmmain"),fieldchecks)){
    	jQuery($GetEle("setbody")).attr("onbeforeunload", "");
        $GetEle("frmmain").submit();
    }
}

function getTest()
{
    var isupdatewfdata = frmmain.isupdatewfdata.value;
	var fieldchecks = "setname,workFlowId,datasourceid,outermaintable,keyfield";
	if(datarecordtype==2)
	{
		fieldchecks += ",requestid,FTriggerFlag,FTriggerFlagValue";
	}
	if(isupdatewfdata==2)
	{
		fieldchecks += ",isupdatewfdataField";
	}
    if(!check_form($GetEle("frmmain"),fieldchecks)){
    	return;
    }
    var datasourceid = frmmain.datasourceid.value;//数据源
	var outermaintable = frmmain.outermaintable.value;//外部主表
	var datarecordtype = frmmain.datarecordtype.value;//
	var keyfield = frmmain.keyfield.value;//
	var requestid = frmmain.requestid.value;//
	var FTriggerFlag = frmmain.FTriggerFlag.value;//
	var FTriggerFlagValue = frmmain.FTriggerFlagValue.value;//
    var timestamp = (new Date()).valueOf();
    var params = "operation=check&datasourceid="+datasourceid+"&outermaintable="+outermaintable+"&datarecordtype="+datarecordtype+"&keyfield="+keyfield+"&requestid="+requestid+"&FTriggerFlag="+FTriggerFlag+"&timestamp="+timestamp;

    //有效性检查，增加名称校验
    var setNameValue = frmmain.setname.value;
    var viewIdValue = frmmain.viewid.value;
    params += "&setname=" + setNameValue+"&viewid=" + viewIdValue;

    var outermainwhere = frmmain.outermainwhere.value;
    params += "&outermainwhere="+outermainwhere;
    
    var detailcount = frmmain.detailcount.value;
    if(detailcount!=""&&detailcount>0)
    {
    	params += "&detailcount="+detailcount;
    }
    for(var i=0;i<detailcount;i++){
        var tempouterdetailname = document.getElementById("outerdetailname"+i).value;
        var tempouterdetailwhere = document.getElementById("outerdetailwhere"+i).value;
        if(tempouterdetailname!="")
        {
        	params += "&outerdetailname"+i+"="+tempouterdetailname;
        	if(tempouterdetailwhere!="")
        	{
        		params += "&outerdetailwhere"+i+"="+tempouterdetailwhere;
        	}
        }
    }
    
    //alert(params);
    jQuery.ajax({
        type: "POST",
        url: "/workflow/automaticwf/automaticCheck.jsp",
        data: params,
        success: function(msg){
            if(jQuery.trim(msg)=="-1")
            {
            	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32373,user.getLanguage())%>")//测试通过，配置正确!
            }
            else
            {
            	var errormsg = "";
                if(jQuery.trim(msg)=="-2") {
                    //名称重复
                    errormsg = "<%=SystemEnv.getHtmlLabelName(129932, user.getLanguage())%>";
                } else if(jQuery.trim(msg)=="-3") {
                    //名称必填
                    errormsg = "<%=SystemEnv.getHtmlLabelName(129512, user.getLanguage())%>";
                } else {
                    //测试不通过，配置不正确，请检查配置!
                    errormsg = "<%=SystemEnv.getHtmlLabelName(32374,user.getLanguage())%>";
                }

                top.Dialog.alert(errormsg)

            	/*if(jQuery.trim(msg)=="0")
            	{
            		errormsg = "<%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%>";
            	}
            	else
				{
            		errormsg = "<%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%>"+jQuery.trim(msg);
            	}
            	//top.Dialog.alert(errormsg+"<%=SystemEnv.getHtmlLabelName(32374,user.getLanguage())%>")//测试不通过，配置不正确，请检查配置!
            	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32374,user.getLanguage())%>")//测试不通过，配置不正确，请检查配置!*/
            }
        }
    });
}
function onBack()
{
	jQuery($GetEle("setbody")).attr("onbeforeunload", "");
	parent.document.location.href='/workflow/automaticwf/automaticsetting.jsp?typename=<%=typename%>';
}
function onClose()
{
	parentWin.closeDialog();
}
function ChangeDatarecordType(objvalue)
{
	var type = objvalue;
	if(type=="1")
	{
		hideEle("datarecord");
	}
	else if(type=="2")
	{
		showEle("datarecord");
	}
}
function ChangeIsupdatewfdatagroup(objvalue)
{
	var type = objvalue;
	
	if(type=="2") 
	{
		showEle("isupdatewfdatagroup");
	}else{
	
	hideEle("isupdatewfdatagroup");
	
	}
}
function onShowTableField(type){
	var fieldname = "";
	var datasource = frmmain.datasourceid.value;
	var tablename = frmmain.outermaintable.value;
	//alert("type : "+type+" datasource : "+datasource+" tablename2 : "+tablename2)
    //QC303535 [80][90]流程触发集成-当数据源未选择，点击外部主表/视图的关键字段，建议系统提示“数据源未选择，请选择！-start
	if (datasource == "") {

        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(131998, user.getLanguage())%>");//数据源未选择，请选择！
        return;
	}
    //QC303535 [80][90]流程触发集成-当数据源未选择，点击外部主表/视图的关键字段，建议系统提示“数据源未选择，请选择！-end
   	if(tablename=="")
   	{
   		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32253,user.getLanguage())%>");//对应表名未填写，请填写！
   		return "";
   	}
	var urls = "/systeminfo/BrowserMain.jsp?mouldID=workflow&dmltablename="+tablename+"&datasourceid="+datasource+"&url=/workflow/dmlaction/dmlTableFieldsBrowser.jsp";
	//alert(urls);
	return urls;
	/*var id_t = showModalDialog(urls);
	if(id_t){
		if(id_t.id != ""&& typeof id_t!='undefined'){
			fieldname = wuiUtil.getJsonValueByIndex(id_t, 0);
		}else{
			fieldname = "";
		}
	}
	//alert("fieldname : "+fieldname+" obj : "+obj)
	obj.nextSibling.value=fieldname;
	$(obj.nextSibling).change();
	*/
}
function setTableField(event,data,name,paras,tg){
	//Dialog.alert("event : "+event);
	var obj = null;
	//alert(typeof(tg)+"  event : "+event);
	if(typeof(tg)=='undefined'){
		obj= event.target || event.srcElement;
	}
	else
	{
		obj = tg;
	}
	var fieldname = "";
	if(data){
		if(data.id != ""&& typeof data!='undefined'){
			fieldname = data.name;
		}else{
			fieldname = "";
		}
	}
	//alert("fieldname : "+fieldname+" obj : "+obj)
	obj.nextSibling.value=fieldname;
	$(obj.nextSibling).change();
}
function setDataSource()
{
	jQuery($GetEle("setbody")).attr("onbeforeunload", "");
	parent.parent.document.location.href="/integration/integrationTab.jsp?urlType=3";
}
$(document).ready(function(){
	ChangeDatarecordType(<%=datarecordtype%>);
	ChangeIsupdatewfdatagroup(<%=isupdatewfdata%>)
});
function ChangeDatasource(obj,datasourceidspan){
    if(obj.value!=""&&obj.value!=null) datasourceidspan.innerHTML = "";
    else datasourceidspan.innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
}
function onBackUrl(url)
{
	jQuery($GetEle("setbody")).attr("onbeforeunload", "");
	document.location.href=url;
}
</script>
<script type="text/javascript">
function disModalDialog(url, spanobj, inputobj, need, curl) {

	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			} else {
				spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			}
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}
function onShowWorkFlowSerach() {
	jQuery($GetEle("setbody")).attr("onbeforeunload", "");
	document.frmmain.operate.value = "reedit";
	document.frmmain.action="/workflow/automaticwf/automaticsettingEdit.jsp"
   	document.frmmain.submit()
}

//是否包含特殊字段
function isSpecialChar(str){
	var reg = /[-\+=\`~!@#$%^&\*\(\)\[\]{};:'",.<>\/\?\\|]/;
	return reg.test(str);
}
//是否含有中文（也包含日文和韩文）
function isChineseChar(str){   
   var reg = /[\u4E00-\u9FA5\uF900-\uFA2D]/;
   return reg.test(str);
}
//是否含有全角符号的函数
function isFullwidthChar(str){
   var reg = /[\uFF00-\uFFEF]/;
   return reg.test(str);
}

<!--QC282793 [80][90]流程触发集成-新建/编辑页面【名称】前后空格问题   增加鼠标移除事件-->
function isExist(newvalue){
	newvalue = $.trim(newvalue);
	document.getElementById("setname").value = newvalue;

	if(isSpecialChar(newvalue)){
		//标识包含特殊字符，请重新输入！
		/*QC329737 [80][90][建议]流程触发集成-名称输入特殊字符，系统提示不准确，建议修改成“名称包含特殊字符，请重新输入！”，以保持统一 start*/
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(131334,user.getLanguage())%>");
		/*QC329737 [80][90][建议]流程触发集成-名称输入特殊字符，系统提示不准确，建议修改成“名称包含特殊字符，请重新输入！”，以保持统一 end*/
		document.getElementById("setname").value = "";
		document.getElementById("setnamespan").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
		
		return false;
	}
	

	return true;

}


</script>
<script language=javascript src="/js/checkData_wev8.js"></script>
