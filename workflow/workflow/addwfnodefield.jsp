<!DOCTYPE html>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="BillComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="FormFieldMainManager" class="weaver.workflow.form.FormFieldMainManager" scope="page" />
<%FormFieldMainManager.resetParameter();%>
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<%WFNodeMainManager.resetParameter();%>
<jsp:useBean id="WFNodeFieldMainManager" class="weaver.workflow.workflow.WFNodeFieldMainManager" scope="page" />
<%WFNodeFieldMainManager.resetParameter();%>
<jsp:useBean id="WFNodeDtlFieldManager" class="weaver.workflow.workflow.WFNodeDtlFieldManager" scope="page" />
<%WFNodeDtlFieldManager.resetParameter();%>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="sysPubRefComInfo" class="weaver.general.SysPubRefComInfo" scope="page" />
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page" />
<%
    String ajax=Util.null2String(request.getParameter("ajax"));
	int design = Util.getIntValue(request.getParameter("design"),0);
	int wfid=0;
	wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
	WfRightManager wfrm = new WfRightManager();
	boolean haspermission = wfrm.hasPermission3(wfid, 0, user, WfRightManager.OPERATION_CREATEDIR);
	if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String dialogTitle=SystemEnv.getHtmlLabelName(23039,user.getLanguage());
%>
<html>
<%
	String wfname="";
	String wfdes="";
	String title="";
	String isbill = "";
	String iscust = "";
	int formid=0;
	int nodeid=-1;
	nodeid=Util.getIntValue(Util.null2String(request.getParameter("nodeid")),-1);
    String nodename="";
    String nodetype="";
    String modetype="";
    int printdes=0;
    int showdes=0;
    int viewtypeall=0;
    int viewdescall=0;
    int showtype=0;
    int vtapprove=0;
    int vtrealize=0;
    int vtforward=0;
	int vtpostil=0;
	int vtHandleForward = 0;
	int vtTakingOpinions = 0;
	int vttpostil=0;   
    int vtrecipient=0;
	int vtrpostil=0; 
    int vtreject=0;
    int vtsuperintend=0;
    int vtover=0;
    int vtintervenor=0;
    int vdcomments=0;
    int vddeptname=0;
    int vdoperator=0;
    int vddate=0;
    int vdtime=0;
    int stnull=0;
    int toexcel=0;
    int vsignupload=0;
    int vsigndoc=0;
    int vsignworkflow=0;
	int vmobilesource=0;
    RecordSet.executeSql("select a.*,b.nodename from workflow_flownode a,workflow_nodebase b where (b.IsFreeNode is null or b.IsFreeNode!='1') and b.id=a.nodeid and a.workflowid="+wfid+" and a.nodeid="+nodeid);
    if(RecordSet.next()){
        nodetype=RecordSet.getString("nodetype");
        nodename=RecordSet.getString("nodename");
        modetype=""+Util.getIntValue(RecordSet.getString("ismode"), 0);
        showdes=Util.getIntValue(Util.null2String(RecordSet.getString("showdes")),0);
        printdes=Util.getIntValue(Util.null2String(RecordSet.getString("printdes")),0);
        viewtypeall=Util.getIntValue(Util.null2String(RecordSet.getString("viewtypeall")),0);
        viewdescall=Util.getIntValue(Util.null2String(RecordSet.getString("viewdescall")),0);
        showtype=Util.getIntValue(Util.null2String(RecordSet.getString("showtype")),0);
        vtapprove=Util.getIntValue(Util.null2String(RecordSet.getString("vtapprove")),0);
        vtrealize=Util.getIntValue(Util.null2String(RecordSet.getString("vtrealize")),0);
        vtforward=Util.getIntValue(Util.null2String(RecordSet.getString("vtforward")),0);
		vtTakingOpinions=Util.getIntValue(Util.null2String(RecordSet.getString("vtTakingOpinions")), 0);  //征求意见
		vtHandleForward = Util.getIntValue(Util.null2String(RecordSet.getString("vtHandleForward")), 0);  // 转办
		vttpostil=Util.getIntValue(Util.null2String(RecordSet.getString("vttpostil")),0);
		vtrpostil=Util.getIntValue(Util.null2String(RecordSet.getString("vtrpostil")),0);
        vtpostil=Util.getIntValue(Util.null2String(RecordSet.getString("vtpostil")),0);
        vtrecipient=Util.getIntValue(Util.null2String(RecordSet.getString("vtrecipient")),0);
        vtreject=Util.getIntValue(Util.null2String(RecordSet.getString("vtreject")),0);
        vtsuperintend=Util.getIntValue(Util.null2String(RecordSet.getString("vtsuperintend")),0);
        vtover=Util.getIntValue(Util.null2String(RecordSet.getString("vtover")),0);
        vtintervenor=Util.getIntValue(Util.null2String(RecordSet.getString("vtintervenor")),0);
        vdcomments=Util.getIntValue(Util.null2String(RecordSet.getString("vdcomments")),0);
        vddeptname=Util.getIntValue(Util.null2String(RecordSet.getString("vddeptname")),0);
        vdoperator=Util.getIntValue(Util.null2String(RecordSet.getString("vdoperator")),0);
        vddate=Util.getIntValue(Util.null2String(RecordSet.getString("vddate")),0);
        vdtime=Util.getIntValue(Util.null2String(RecordSet.getString("vdtime")),0);
        stnull=Util.getIntValue(Util.null2String(RecordSet.getString("stnull")),0);
        toexcel=Util.getIntValue(Util.null2String(RecordSet.getString("toexcel")),0);
        vsignupload=Util.getIntValue(Util.null2String(RecordSet.getString("vsignupload")),0);
        vsigndoc=Util.getIntValue(Util.null2String(RecordSet.getString("vsigndoc")),0);
        vsignworkflow=Util.getIntValue(Util.null2String(RecordSet.getString("vsignworkflow")),0);
		vmobilesource=Util.getIntValue(Util.null2String(RecordSet.getString("vmobilesource")),0);
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
    		showtypeall += "viewtype_approve";
    		showtypenameall += SystemEnv.getHtmlLabelName(615,user.getLanguage())+"&nbsp";
    	}
    	if(vtrealize == 1){
    		showtypeall += ",";
    		showtypenameall += ",";
    		showtypeall += "viewtype_realize";
    		showtypenameall += SystemEnv.getHtmlLabelName(142,user.getLanguage());
    	}
    	if(vtforward == 1){
    		showtypeall += ",";
    		showtypenameall += ",";
    		showtypeall += "viewtype_forward";
    		showtypenameall += SystemEnv.getHtmlLabelName(6011,user.getLanguage());
    	}
		if(vtTakingOpinions == 1){  //意见征询
			showtypeall += ",";
			showtypenameall += ",";
			showtypeall += "view_takingOpinions";
			showtypenameall += SystemEnv.getHtmlLabelName(82578,user.getLanguage());
		}
		if(vtHandleForward == 1){   // 转办
			showtypeall += ",";
			showtypenameall += ",";
			showtypeall += "view_handleForward";
			showtypenameall += SystemEnv.getHtmlLabelName(23745,user.getLanguage());
		}
		if(vtpostil == 1){
    		showtypeall += ",";
    		showtypenameall += ",";
    		showtypeall += "viewtype_postil";
    		showtypenameall += SystemEnv.getHtmlLabelName(6011,user.getLanguage())+SystemEnv.getHtmlLabelName(1006,user.getLanguage());
    	}
		if(vttpostil == 1){
    		showtypeall += ",";
    		showtypenameall += ",";
    		showtypeall += "viewtype_tpostil";
    		showtypenameall += SystemEnv.getHtmlLabelName(82578,user.getLanguage())+SystemEnv.getHtmlLabelName(18540,user.getLanguage());
    	}
    	if(vtrpostil == 1){
    		showtypeall += ",";
    		showtypenameall += ",";
    		showtypeall += "viewtype_rpostil";
    		showtypenameall += SystemEnv.getHtmlLabelName(2084,user.getLanguage())+SystemEnv.getHtmlLabelName(1006,user.getLanguage());
    	}
    	if(vtrecipient == 1){
    		showtypeall += ",";
    		showtypenameall += ",";
    		showtypeall += "viewtype_recipient";
    		showtypenameall += SystemEnv.getHtmlLabelName(2084,user.getLanguage());
    	}
    	if(vtreject == 1){
    		showtypeall += ",";
    		showtypenameall += ",";
    		showtypeall += "viewtype_reject";
    		showtypenameall += SystemEnv.getHtmlLabelName(236,user.getLanguage());
    	}
    	if(vtsuperintend == 1){
    		showtypeall += ",";
    		showtypenameall += ",";
    		showtypeall += "viewtype_superintend";
    		showtypenameall += SystemEnv.getHtmlLabelName(21223,user.getLanguage());
    	}
    	if(vtover == 1){
    		showtypeall += ",";
    		showtypenameall += ",";
    		showtypeall += "viewtype_over";
    		showtypenameall += SystemEnv.getHtmlLabelName(18360,user.getLanguage());
    	}
    	if(vtintervenor == 1){
    		showtypeall += ",";
    		showtypenameall += ",";
    		showtypeall += "viewtype_intervenor";
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
    		showdescall += "viewdesc_comments";
    		showdescnameall += "<a href='#'>" + SystemEnv.getHtmlLabelName(21662,user.getLanguage()) + "</a>";
    	}
    	if(vddeptname == 1){
    		showdescall += ",";
    		showdescnameall += ",";
    		showdescall += "viewdesc_deptname";
    		showdescnameall += "<a href='#'>" + SystemEnv.getHtmlLabelName(15390,user.getLanguage()) + "</a>";
    	}
    	if(vdoperator == 1){
    		showdescall += ",";
    		showdescnameall += ",";
    		showdescall += "viewdesc_operator";
    		showdescnameall += "<a href='#'>" + SystemEnv.getHtmlLabelName(17482,user.getLanguage()) + "</a>";
    	}
    	if(vddate == 1){
    		showdescall += ",";
    		showdescnameall += ",";
    		showdescall += "viewdesc_date";
    		showdescnameall += "<a href='#'>" + SystemEnv.getHtmlLabelName(21663,user.getLanguage()) + "</a>";
    	}
    	if(vdtime == 1){
    		showdescall += ",";
    		showdescnameall += ",";
    		showdescall += "viewdesc_time";
    		showdescnameall += "<a href='#'>" + SystemEnv.getHtmlLabelName(15502,user.getLanguage()) + "</a>";
    	}
    	if(vsigndoc == 1){
    		showdescall += ",";
    		showdescnameall += ",";
    		showdescall += "viewdesc_signdoc";
    		showdescnameall += "<a href='#'>" + SystemEnv.getHtmlLabelName(857,user.getLanguage()) + "</a>";
    	}
    	if(vsignworkflow == 1){
    		showdescall += ",";
    		showdescnameall += ",";
    		showdescall += "viewdesc_signworkflow";
    		showdescnameall += "<a href='#'>" + SystemEnv.getHtmlLabelName(1044,user.getLanguage()) + "</a>";
    	}
    	if(vsignupload == 1){
    		showdescall += ",";
    		showdescnameall += ",";
    		showdescall += "viewdesc_signupload";
    		showdescnameall += "<a href='#'>" +SystemEnv.getHtmlLabelName(22194,user.getLanguage()) + "</a>";
    	}
		if(vmobilesource == 1){
    		showdescall += ",";
    		showdescnameall += ",";
    		showdescall += "viewdesc_mobilesource";
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
	title="edit";
	WFManager.setWfid(wfid);
	WFManager.getWfInfo();
	wfname=WFManager.getWfname();
	wfdes=WFManager.getWfdes();
	formid = WFManager.getFormid();
	isbill = WFManager.getIsBill();
	iscust = WFManager.getIsCust();
	int typeid = 0;
	typeid = WFManager.getTypeid();

    //add by mackjoe at 2005-12-16
    //显示类型

    //如果表单中设定了模板，节点自动引用表单模板

    String showmode="";
    String printmode="";
    int showmodeid=0;
    int printmodeid=0;
    int showisform=0;
    int printisform=0;
    int isprint=0;
    int tempshowmodeid=0;
    String tempshowmdoe="";
    RecordSet.executeSql("select id,isprint,modename from workflow_nodemode where workflowid="+wfid+" and nodeid="+nodeid);
    while(RecordSet.next()){
        isprint=RecordSet.getInt("isprint");
        if(isprint==0){
            showmodeid=RecordSet.getInt("id");
            showmode=RecordSet.getString("modename");
            //printmodeid=showmodeid;
            //printmode=showmode;
        }else{
            if(isprint==1){
                printmodeid=RecordSet.getInt("id");
                printmode=RecordSet.getString("modename");
            }
        }
    }
    RecordSet.executeSql("select id,isprint,modename from workflow_formmode where formid="+formid+" and isbill="+isbill);
    while(RecordSet.next()){
        isprint=RecordSet.getInt("isprint");
        if(isprint==0){
            tempshowmodeid=RecordSet.getInt("id");
            tempshowmdoe=RecordSet.getString("modename");
            if(showmodeid<1 && showdes==0){
                showmodeid=tempshowmodeid;
                showmode=tempshowmdoe;
                showisform=1;
            }
        }else{
            if(printmodeid<1 && isprint==1 && printdes==0){
                printmodeid=RecordSet.getInt("id");
                printmode=RecordSet.getString("modename");
                printisform=1;
            }
        }
    }
    if(tempshowmodeid>0 && printmodeid<1 && printdes==0){
        printmodeid=tempshowmodeid;
        printmode=tempshowmdoe;
        printisform=1;
    }
    boolean indmouldtype = true;
    if (isbill.equals("1")) {
        RecordSet.executeSql("select indmouldtype from workflow_billfunctionlist where billid=" + formid);
        if (RecordSet.next()) {
            indmouldtype = Util.null2String(RecordSet.getString("indmouldtype")).equals("1") ? true : false;
            if(formid==180){
            	indmouldtype = true;
            }
        }
    }
    //end by mackjoe
%>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23688,user.getLanguage());
String needfav ="";
String needhelp ="";
%>
<style type="text/css">
#test{
	padding-left:0px!important;
}
.ellipsis{ 
	display: inline-block; width: 115px; 
	white-space: nowrap; overflow: hidden; text-overflow: ellipsis; 
}
</style>
</head>

<body>
<%
if(design==0) {
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%
}
%>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(!ajax.equals("1"))
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
else
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:nodefieldsave(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

if(!ajax.equals("1"))
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",Editwfnode.jsp?wfid="+wfid+",_self} " ;
else
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:closeWindow(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div  class="zDialog_div_content">
<form id="nodefieldform" name="nodefieldform" method=post action="wf_operation.jsp" >
<input type="hidden" value="<%=design%>" name="design">
<%if(ajax.equals("1")){%>
<input type=hidden name=ajax value="1">
<%}%>

<%
	ArrayList wfsmtdetailCodeList = sysPubRefComInfo.getDetailCodeList("WorkflowShowModeType");
	ArrayList wfsmtdetailLabelList = sysPubRefComInfo.getDetailLabelList("WorkflowShowModeType");
%>

<!-- 此处空layout用来优先加载样式，因为下面有include页面导致样式加载阻断 -->
<div style="display: none;">
<wea:layout attributes="">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item> </wea:item>
	</wea:group>
</wea:layout>
</div>
<table id="topTitle" cellpadding="0" cellspacing="0" >
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage()) %>" class="e8_btn_top"  onclick="javascript:onsavefield();"/>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table> 
<wea:layout type="2col">
	<%if(!ajax.equals("1")){ %>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(2079,user.getLanguage())%></wea:item>
		<wea:item><%=wfname%></wea:item>
		<wea:item><%=WorkTypeComInfo.getWorkTypename(""+typeid)%></wea:item>
		<%if(isPortalOK){%>
		<wea:item><%=SystemEnv.getHtmlLabelName(15588,user.getLanguage())%></wea:item>
		<wea:item>
			<%if(iscust.equals("0")){%><%=SystemEnv.getHtmlLabelName(15589,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(15554,user.getLanguage())%><%}%>
		</wea:item>
		<%} %>
		<wea:item><%=SystemEnv.getHtmlLabelName(15600,user.getLanguage())%></wea:item>
		<wea:item>
	    <%if(isbill.equals("0")){%>
	    	<%=FormComInfo.getFormname(""+formid)%>
	    <%}else if(isbill.equals("1")){
	    	int labelid = Util.getIntValue(BillComInfo.getBillLabel(""+formid));
	    %>
	    	<%=SystemEnv.getHtmlLabelName(labelid,user.getLanguage())%>
	    <%}else{%> <%}%>		
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15594,user.getLanguage())%></wea:item>
		<wea:item><%=wfdes%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%></wea:item>
		<wea:item><%=nodename%></wea:item>
	</wea:group>
	<%} %>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(21657,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(21657,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  name="modetype" onChange="change(this)" style="width: 200px;">
			<%
			ArrayList specialBillIDList = sysPubRefComInfo.getDetailCodeList("SpecialBillID");
			boolean isSpecialBill = specialBillIDList.contains(""+formid)&&"1".equals(isbill);
			int useHtmlMode = 0;
			try{
				useHtmlMode = Util.getIntValue(baseBean.getPropValue("wfshowmode","wfhtmlmode"), 0);
			}catch(Exception e){}
			for(int listsize=0; listsize<wfsmtdetailCodeList.size(); listsize++){
				int detailCode = Util.getIntValue((String)wfsmtdetailCodeList.get(listsize), 0);
				int detailLabel = Util.getIntValue((String)wfsmtdetailLabelList.get(listsize), 0);
				String selectedStr = "";
				if(modetype.equals(""+detailCode)){
					selectedStr = " selected ";
				}
				if((useHtmlMode==0 || isSpecialBill==true) && detailCode==2){
					continue;
				}
				out.println("<option value=\""+detailCode+"\" "+selectedStr+"><STRONG>"+SystemEnv.getHtmlLabelName(detailLabel, user.getLanguage())+"</strong></option>");
			}
			%>
			</select>		
		</wea:item>
	</wea:group>
	<%if(!ajax.equals("1")){%>
	<script>
	//oDivOfAddWfNodeField：普通模式

	//tDivOfAddWfNodeField：模板模式

	//hDivOfAddWfNodeField：Html模式
	function change(thisele) {
		var modeid= thisele.value;
	    if(modeid=="1"){
	        hideGroup("oDivOfAddWfNodeField");
	        hideGroup("hDivOfAddWfNodeField");
	        showGroup("tDivOfAddWfNodeField");
	    }else if(modeid=="0"){
	   		showGroup("oDivOfAddWfNodeField");
	        hideGroup("hDivOfAddWfNodeField");
	        hideGroup("tDivOfAddWfNodeField"); 
	    }else if(modeid=="2"){
	   		hideGroup("oDivOfAddWfNodeField");
	        showGroup("hDivOfAddWfNodeField");
	        hideGroup("tDivOfAddWfNodeField"); 
	    }
	}
	</script>
	<%}%>	
	
	<%
		String tDivOfAddWfNodeField = "{'groupSHBtnDisplay':'none','samePair':'tDivOfAddWfNodeField','groupDisplay':'','itemAreaDisplay':''}";
		if(!modetype.equals("1")) tDivOfAddWfNodeField = "{'groupSHBtnDisplay':'none','samePair':'tDivOfAddWfNodeField','groupDisplay':'none','itemAreaDisplay':'none'}";
	%>
	<%-- 图形化模板   start --%>
	<% String completeUrl1 = "/data.jsp?type=workflowNodeBrowser&wfid="+wfid; %>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(16367,user.getLanguage())%>' attributes="<%=tDivOfAddWfNodeField %>">
		<wea:item><%=SystemEnv.getHtmlLabelName(16450,user.getLanguage())%></wea:item>
		<wea:item>
			<div style="display:inline-block;padding-top:1px;padding-left:5px;">
			    <button type="button" class="e8_btn_top middle" style="border:1px solid #aecef1 !important" onclick="onShowBrowser4field('<%=formid%>','<%=nodeid%>','<%=isbill%>','0')" <%if(!indmouldtype){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(33251,user.getLanguage())%></button>&nbsp;
			    <button type="button" class="e8_btn_top middle" style="border:1px solid #aecef1 !important" onclick="openFullWindowHaveBar('/workflow/mode/index.jsp?formid=<%=formid%>&wfid=<%=wfid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&isprint=0&ajax=<%=ajax%>')" <%if(!indmouldtype){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>
				<span id="showmodespan" class="ellipsis" style="vertical-align:middle;"><a href="#" onclick="openFullWindowHaveBar('/workflow/mode/index.jsp?formid=<%=formid%>&wfid=<%=wfid%>&nodeid=<%=nodeid%>&isform=<%=showisform%>&isbill=<%=isbill%>&isprint=0&modeid=<%=showmodeid%>&ajax=<%=ajax%>')"><%=showmode%></a></span>
				<span style="vertical-align:middle;"><%=SystemEnv.getHtmlLabelName(27966,user.getLanguage())%>
					<span style="display:inline-block;vertical-align:middle;padding-left:5px;">
						<brow:browser name="modesyncNodes" viewType="0" hasBrowser="true" hasAdd="false" 
							getBrowserUrlFn="getShowNodesUrl" getBrowserUrlFnParams="'modesyncNodes'" isMustInput="1" isSingle="false" hasInput="true"
							completeUrl='<%=completeUrl1 %>'  width="150px" browserValue="" browserSpanValue="" />
					</span>
				</span>  
			</div>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(257,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%></wea:item>
		<wea:item>
			<div style="display:inline-block;padding-top:1px;padding-left:5px;">
		    	<button type="button" class="e8_btn_top middle" style="border:1px solid #aecef1 !important" onclick="onShowBrowser4field('<%=formid%>','<%=nodeid%>','<%=isbill%>','1')"><%=SystemEnv.getHtmlLabelName(33251,user.getLanguage())%></button>&nbsp;
		    	<button name="createPrintButton_tx" type="button" class="e8_btn_top middle" style="border:1px solid #aecef1 !important" onclick="openFullWindowHaveBar('/workflow/mode/index.jsp?formid=<%=formid%>&wfid=<%=wfid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&isprint=1&ajax=<%=ajax%>')"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>
		    	<span id="printmodespan" class="ellipsis" style="vertical-align:middle;"><a href="#" onclick="openFullWindowHaveBar('/workflow/mode/index.jsp?formid=<%=formid%>&wfid=<%=wfid%>&nodeid=<%=nodeid%>&isform=<%=printisform%>&isbill=<%=isbill%>&isprint=1&modeid=<%=printmodeid%>&ajax=<%=ajax%>')"><%=printmode%></a></span>
		    	<span style="vertical-align:middle;"><%=SystemEnv.getHtmlLabelName(27966,user.getLanguage())%>
			 		<span style="display:inline-block;vertical-align:middle;padding-left:5px;"> 
				    	<brow:browser name="modeprintsyncNodes" viewType="0" hasBrowser="true" hasAdd="false" 
				    		getBrowserUrlFn="getShowNodesUrl" getBrowserUrlFnParams="'modeprintsyncNodes'" isMustInput="1" isSingle="false" hasInput="true"
				    		completeUrl='<%=completeUrl1 %>'  width="150px" browserValue="" browserSpanValue="" />
		    		</span>
		    	</span>
		    </div>	
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(17416,user.getLanguage())+"Excel"%></wea:item>
		<wea:item>
			<input type="checkbox"  tzCheckbox="true" name="toexcel" value="1" <%if(toexcel==1){%>checked<%}%>>
			<%--<span style="position:relative;left:204px">
				<%=SystemEnv.getHtmlLabelName(21738,user.getLanguage())%>
				<input type="checkbox"  tzCheckbox="false" name="synexcel" value="1" >
			</span> --%>
		</wea:item>
	</wea:group>	
<%
if(nodeid!=-1 && isbill.equals("0")){
	FormFieldMainManager.setFormid(formid);
	FormFieldMainManager.setNodeid(nodeid);
	FormFieldMainManager.selectFormFieldLable();
	int groupid=-1;
	String dtldisabled="";
	while(FormFieldMainManager.next()){
		int curid=FormFieldMainManager.getFieldid();
		String fieldname=FieldComInfo.getFieldname(""+curid);
		String fieldhtmltype = FieldComInfo.getFieldhtmltype(""+curid);
		String curlable = FormFieldMainManager.getFieldLable();
		int curgroupid=FormFieldMainManager.getGroupid();
		//表单头group值为－1，会引起拼装checkbox语句的脚本错误，这里简单的处理为999
		if(curgroupid==-1) curgroupid=999;
		String isdetail = FormFieldMainManager.getIsdetail();
		WFNodeFieldMainManager.resetParameter();
		WFNodeFieldMainManager.setNodeid(nodeid);
		WFNodeFieldMainManager.setFieldid(curid);
		WFNodeFieldMainManager.selectWfNodeField();
		String dtladd = WFNodeDtlFieldManager.getIsadd();				
		String dtledit = WFNodeDtlFieldManager.getIsedit();				
		String dtldelete = WFNodeDtlFieldManager.getIsdelete();			
		String dtlhide = WFNodeDtlFieldManager.getIshide();
		String dtldefault = WFNodeDtlFieldManager.getIsdefault();
    	String dtlneed = WFNodeDtlFieldManager.getIsneed();
		%>
			<input type="hidden" name="dtl_add_2_<%=groupid%>" value="<%=dtladd%>"/>
			<input type="hidden" name="dtl_edit_2_<%=groupid%>" value="<%=dtledit%>"/>
			<input type="hidden" name="dtl_del_2_<%=groupid%>" value="<%=dtldelete%>"/>
			<input type="hidden" name="hide_del_2_<%=groupid%>" value="<%=dtlhide%>"/>
			<input type="hidden" name="dtl_ned_2_<%=groupid%>"  value="<%=dtlneed%>"/>
			<input type="hidden" name="dtl_def_2_<%=groupid%>"  value="<%=dtldefault%>"/>			
		<%
		if(isdetail.equals("1") && curgroupid>groupid) {
			groupid=curgroupid;
			WFNodeDtlFieldManager.setNodeid(nodeid);
			WFNodeDtlFieldManager.setGroupid(curgroupid);
			WFNodeDtlFieldManager.selectWfNodeDtlField();
			int defaultrow = WFNodeDtlFieldManager.getDefaultrows();
			if(defaultrow<1)defaultrow=1;
			if(!nodetype.equals("3")){
		%>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(30054,user.getLanguage())%>'  attributes="<%=tDivOfAddWfNodeField %>">
			<wea:item><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%><%=groupid+1%></wea:item>	
			<wea:item>
				<input style="width:167px;" type="text" name="dtl_defrow_<%=groupid%>" onClick="" onkeypress="ItemCount_KeyPress()" onchange="checkcount2(this);" value="<%=defaultrow%>">
			</wea:item>	
		</wea:group>
<%
			}
		}
	} 
}else if(nodeid!=-1 && isbill.equals("1")){
	boolean isNewForm = false;//是否是新表单 modify by myq for TD8730 on 2008.9.12
	//数据中心表（新表单对应表）

	String tmpDataCenterTableName = "";
	RecordSet.executeSql("select  inpreptablename  from T_InputReport where billid = "+formid);
	if(RecordSet.next()) tmpDataCenterTableName = Util.null2String(RecordSet.getString("inpreptablename"));
	
	RecordSet.executeSql("select tablename from workflow_bill where id = "+formid);
	if(RecordSet.next()){
		String temptablename = Util.null2String(RecordSet.getString("tablename"));
		if(temptablename.equals("formtable_main_"+formid*(-1)) || temptablename.startsWith("uf_")) isNewForm = true;
		if(temptablename.equals(tmpDataCenterTableName+ "_main")) isNewForm = true;
	}
	
	boolean iscptbill = false;
	if(isbill.equals("1")&&(formid==7||formid==14||formid==15||formid==18||formid==19||formid==201))
		iscptbill = true;
	
	String sql = "";
	if(isNewForm == true){
		if("ORACLE".equalsIgnoreCase(RecordSet.getDBType())){
			sql = "select * from workflow_billfield where billid = "+formid +" order by viewtype,TO_NUMBER((select orderid from Workflow_billdetailtable bd where bd.billid = billid and bd.tablename = detailtable)),dsporder ";
		}else{
			sql = "select * from workflow_billfield where billid = "+formid +" order by viewtype,convert(int, (select orderid from Workflow_billdetailtable bd where bd.billid = billid and bd.tablename = detailtable)),dsporder ";
		}
	}else{
		sql = "select * from workflow_billfield where billid = "+formid +" order by viewtype,detailtable,dsporder ";
	}
	RecordSet.executeSql(sql);
	String predetailtable=null;
	int groupid=0;
	String dtldisabled="";
	while(RecordSet.next()){
		String fieldhtmltype = RecordSet.getString("fieldhtmltype");
		String fieldname = RecordSet.getString("fieldname");
		int curid=RecordSet.getInt("id");
		int curlabel = RecordSet.getInt("fieldlabel");
		int viewtype = RecordSet.getInt("viewtype");
		String detailtable = Util.null2String(RecordSet.getString("detailtable"));
	
		WFNodeFieldMainManager.resetParameter();
		WFNodeFieldMainManager.setNodeid(nodeid);
		WFNodeFieldMainManager.setFieldid(curid);
		WFNodeFieldMainManager.selectWfNodeField();
		if(viewtype==1 && !detailtable.equals(predetailtable)){
			predetailtable=detailtable;
			
			WFNodeDtlFieldManager.setNodeid(nodeid);
			WFNodeDtlFieldManager.setGroupid(groupid);
			WFNodeDtlFieldManager.selectWfNodeDtlField();
			int defaultrow = WFNodeDtlFieldManager.getDefaultrows();
			if(defaultrow<1)defaultrow=1;
			String dtladd = WFNodeDtlFieldManager.getIsadd();				
			String dtledit = WFNodeDtlFieldManager.getIsedit();				
			String dtldelete = WFNodeDtlFieldManager.getIsdelete();			
			String dtlhide = WFNodeDtlFieldManager.getIshide();
			String dtldefault = WFNodeDtlFieldManager.getIsdefault();
	    	String dtlneed = WFNodeDtlFieldManager.getIsneed();

%>
			<input type="hidden" name="dtl_add_2_<%=groupid%>" value="<%=dtladd%>"/>
			<input type="hidden" name="dtl_edit_2_<%=groupid%>" value="<%=dtledit%>"/>
			<input type="hidden" name="dtl_del_2_<%=groupid%>" value="<%=dtldelete%>"/>
			<input type="hidden" name="hide_del_2_<%=groupid%>" value="<%=dtlhide%>"/>
			<input type="hidden" name="dtl_ned_2_<%=groupid%>"  value="<%=dtlneed%>"/>
			<input type="hidden" name="dtl_def_2_<%=groupid%>"  value="<%=dtldefault%>"/>	
<%
			if(!nodetype.equals("3")){
%>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(30054,user.getLanguage())%>' attributes="<%=tDivOfAddWfNodeField %>">
		<wea:item><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%><%=groupid+1%></wea:item>
		<wea:item>
			<input style="width:167px;" type="text" name="dtl_defrow_<%=groupid%>" onClick="" onkeypress="ItemCount_KeyPress()" onchange="checkcount2(this);" value="<%=defaultrow%>">
		</wea:item>
	</wea:group>
<%
				groupid++;
			}
		}
	}
} 
%> 		
	<wea:group context='<%=SystemEnv.getHtmlLabelName(21652,user.getLanguage())%>'  attributes="<%=tDivOfAddWfNodeField %>">
		<wea:item><%=SystemEnv.getHtmlLabelName(17139,user.getLanguage())%></wea:item>	
		<wea:item>
			 <brow:browser name="viewtype_all" viewType="0" hasBrowser="true" hasAdd="false" 
				    		browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/wfnTypeShow.jsp?resourceids=#id#"  isMustInput="1" isSingle="false" hasInput="true"
				    		completeUrl="/data.jsp?type=workflowNodeBrowser" width="165px" browserValue='<%=showtypeall%>' browserSpanValue='<%=showtypenameall%>' />
			<%--<input type="checkbox" name="viewtype_all" value="1" onclick="selectviewall('viewtype',this.checked)" <%if(viewtypeall==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%>--%>
		</wea:item>
		<%-- 选择条件
		<wea:item attributes="{'colspan':'full'}">
	        <table class="ListStyle" id="viewtypetab">
	            <tr>
	            <TD width="50%"><input type="checkbox" name="viewtype_approve" value="1" <%if(vtapprove==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></TD>
	            <TD width="50%"><input type="checkbox" name="viewtype_realize" value="1" <%if(vtrealize==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></TD>
	            </tr>
	            <tr>
	            <TD width="50%"><input type="checkbox" name="viewtype_forward" value="1" <%if(vtforward==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(6011,user.getLanguage())%></TD>
				<TD width="50%"><input type="checkbox" name="view_takingOpinions" value="1" <%if(vtTakingOpinions==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(82578,user.getLanguage())%></TD>  
				<TD width="50%"><input type="checkbox" name="view_handleForward" value="1" <%if(vtHandleForward==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(23745,user.getLanguage())%></TD>
	            <TD width="50%"><input type="checkbox" name="viewtype_postil" value="1" <%if(vtpostil==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(6011,user.getLanguage())%>+<%=SystemEnv.getHtmlLabelName(1006,user.getLanguage())%></TD>
				<TD width="50%"><input type="checkbox" name="viewtype_tpostil" value="1" <%if(vttpostil==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(82578,user.getLanguage())%>+<%=SystemEnv.getHtmlLabelName(18540,user.getLanguage())%></TD>
				<TD width="50%"><input type="checkbox" name="viewtype_rpostil" value="1" <%if(vtrpostil==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(2084,user.getLanguage())%>+<%=SystemEnv.getHtmlLabelName(1006,user.getLanguage())%></TD>
	            </tr>
	            <tr>
	            <TD width="50%"><input type="checkbox" name="viewtype_recipient" value="1" <%if(vtrecipient==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(2084,user.getLanguage())%></TD>
	            <TD width="50%"><input type="checkbox" name="viewtype_reject" value="1" <%if(vtreject==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></TD>
	            </tr>
	            <tr>
	            <TD width="50%"><input type="checkbox" name="viewtype_superintend" value="1" <%if(vtsuperintend==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(21223,user.getLanguage())%></TD>
	            <TD width="50%"><input type="checkbox" name="viewtype_over" value="1" <%if(vtover==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(18360,user.getLanguage())%></TD>
	            </tr>
	            <tr>
	            <TD width="50%"><input type="checkbox" name="viewtype_intervenor" value="1" <%if(vtintervenor==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(18913,user.getLanguage())%></TD>
	            </tr>
	        </table>		
		</wea:item>
		--%>
		<wea:item><%=SystemEnv.getHtmlLabelName(15935,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser name="viewdesc_all" viewType="0" hasBrowser="true" hasAdd="false" 
				    		browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/wfnContentShow.jsp?resourceids=#id#"  isMustInput="1" isSingle="false" hasInput="true"
				    		completeUrl="/data.jsp?type=workflowNodeBrowser" width="165px" browserValue='<%=showdescall %>' browserSpanValue='<%=showdescnameall %>' />
			<%--<input type="checkbox" name="viewdesc_all" value="1" onclick="selectviewall('viewdesc',this.checked)" <%if(viewdescall==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%>--%>
		</wea:item>
		<%--
		<wea:item attributes="{'colspan':'full'}">
	        <table class="ListStyle" id="viewdesctab">
	            <tr>
	            <TD width="50%"><input type="checkbox" name="viewdesc_comments" value="1" <%if(vdcomments==1||viewdescall==1){%>checked <%}if(viewdescall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(21662,user.getLanguage())%></TD>
	            <TD width="50%"><input type="checkbox" name="viewdesc_deptname" value="1" <%if(vddeptname==1||viewdescall==1){%>checked <%}if(viewdescall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(15390,user.getLanguage())%></TD>
	            </tr>
	            <tr>
	            <TD width="50%"><input type="checkbox" name="viewdesc_operator" value="1" <%if(vdoperator==1||viewdescall==1){%>checked <%}if(viewdescall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(17482,user.getLanguage())%></TD>
	            <TD width="50%"><input type="checkbox" name="viewdesc_date" value="1" <%if(vddate==1||viewdescall==1){%>checked <%}if(viewdescall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(21663,user.getLanguage())%></TD>
	            </tr>
	            <tr>
	            <TD width="50%"><input type="checkbox" name="viewdesc_time" value="1" <%if(vdtime==1||viewdescall==1){%>checked <%}if(viewdescall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(15502,user.getLanguage())%></TD>
	            <TD width="50%"><input type="checkbox" name="viewdesc_signdoc" value="1" <%if(vsigndoc==1||viewdescall==1){%>checked <%}if(viewdescall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></TD>
	            </tr>
	            <tr>
	            <TD width="50%"><input type="checkbox" name="viewdesc_signworkflow" value="1" <%if(vsignworkflow==1||viewdescall==1){%>checked <%}if(viewdescall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></TD>
	            <TD width="50%"><input type="checkbox" name="viewdesc_signupload" value="1" <%if(vsignupload==1||viewdescall==1){%>checked <%}if(viewdescall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></TD> 
				<TD width="50%"><input type="checkbox" name="viewdesc_mobilesource" value="1" <%if(vmobilesource==1||viewdescall==1){%>checked <%}if(viewdescall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(504,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15240,user.getLanguage()%></TD>    
	            </tr>
	        </table>		
		</wea:item>--%>
		<wea:item><%=SystemEnv.getHtmlLabelName(21653,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle  name="showtype"  style="width:137px;">
               	<option value="0" <%if(showtype!=1){%> selected <%}%>><STRONG><%=SystemEnv.getHtmlLabelName(21654,user.getLanguage())%></strong>
               	<option value="1" <%if(showtype==1){%> selected <%}%>><strong><%=SystemEnv.getHtmlLabelName(21655,user.getLanguage())%></strong>
          	</select>
		            <td width="50%" class=field></td>
	         	
		</wea:item>	
		<wea:item><%=SystemEnv.getHtmlLabelName(21678,user.getLanguage())%></wea:item>
		<wea:item><input type="checkbox" tzCheckbox="true" name="showtype_null" value="1" <%if(stnull==1){%>checked<%}%>></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(125020,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser name="noderemarksync" viewType="0" hasBrowser="true" hasAdd="false" 
				getBrowserUrlFn="getShowNodesUrl1" getBrowserUrlFnParams="'noderemarksync'" isMustInput="1" isSingle="false" hasInput="true"
				completeUrl='<%=completeUrl1 %>'  width="150px" browserValue="" browserSpanValue="" />
		</wea:item>
	</wea:group>
	<%-- 图形化模板   end --%>
<%
	String oDivOfAddWfNodeField = "{'groupSHBtnDisplay':'none','samePair':'oDivOfAddWfNodeField','groupDisplay':'','itemAreaDisplay':''}"; 
	if(!modetype.equals("0")){
		oDivOfAddWfNodeField = "{'groupSHBtnDisplay':'none','samePair':'oDivOfAddWfNodeField','groupDisplay':'none','itemAreaDisplay':'none'}"; 
	}
 %>	
	<%-- 普通模板   start --%>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(21903,user.getLanguage())%>' attributes="<%=oDivOfAddWfNodeField %>">
		<%-- 显示模板  @author Dracula 2014-7-20 --%>
		<wea:item><%=SystemEnv.getHtmlLabelName(16450,user.getLanguage())%></wea:item>
		<wea:item>
			<div style="display:inline-block;padding-top:1px;padding-left:5px;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(33251,user.getLanguage())%>" class="e8_btn_top middle" style="border:1px solid #aecef1 !important;" onclick="onShowBrowser4General('<%=formid%>','<%=isbill%>')">&nbsp;
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>" class="e8_btn_top middle" style="border:1px solid #aecef1 !important" onclick="onaddwfnodegeneral('<%=formid%>','<%=nodeid%>','<%=isbill%>','<%=nodetype %>','y')">
			<%
				RecordSet.executeSql(" select id,modename from wfnodegeneralmode where formid="+formid+" and nodeid="+nodeid+" and isbill="+isbill+" and wfid="+wfid);
				String genmode_isnew="";
				String genmodeid="";
				String genmodename="";
				if(RecordSet.next()){
					genmode_isnew="n";
					genmodeid=Util.null2String(RecordSet.getString("id"));
					genmodename = Util.null2String(RecordSet.getString("modename"));
				}else{
					genmode_isnew="y";
					genmodename=nodename+ SystemEnv.getHtmlLabelName(19511,user.getLanguage());
					//liuzy  兼容历史老数据，无普通模板但有字段信息

					RecordSet.executeSql(" select fieldid from workflow_nodeform where nodeid="+nodeid);
					if(RecordSet.getCounts()>0){
						genmode_isnew="n";
					}
				}
			%>
			<span class="ellipsis" style="vertical-align:middle;" >
				<input type="hidden" id="genmode_isnew" value="<%=genmode_isnew %>" />
				<input type="hidden" name="ischoose" value="s">
				<input type="hidden" name="choosemodeid" value="<%=genmodeid %>" />
				<span id="modenamespan">
				<a id="modenamelink" style="cursor:pointer;" 
					onclick="onaddwfnodegeneral('<%=formid%>','<%=nodeid%>','<%=isbill%>','<%=nodetype %>','')">
					<%=genmodename %>
				</a>
				</span>
			</span>
			<span style="vertical-align:middle;"><%=SystemEnv.getHtmlLabelName(27966,user.getLanguage())%>
			<%
				String completeUrl2 = "/data.jsp?type=workflowNodeBrowser&wfid="+wfid;
			%>  
				<span style="display:inline-block;vertical-align:middle;padding-left:5px;">
				<brow:browser name="gensyncNodes" viewType="0" hasBrowser="true" hasAdd="false" 
         			getBrowserUrlFn="getShowNodesUrl" getBrowserUrlFnParams="'gensyncNodes'" isMustInput="1" isSingle="false" hasInput="true"
          			completeUrl='<%=completeUrl2 %>'  width="150px" browserValue="" browserSpanValue="" />
          		</span>
          	</span>
          	</div>
		</wea:item>
		<%-- 打印模板  @author Dracula 2014-7-20 --%>
		<wea:item><%=SystemEnv.getHtmlLabelName(257,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%></wea:item>
		<wea:item>
			<div style="display:inline-block;padding-top:1px;padding-left:5px;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(33251,user.getLanguage())%>" class="e8_btn_top middle" style="border:1px solid #aecef1 !important" onclick="onShowBrowser4GeneralPrint('<%=formid%>','<%=nodeid %>','<%=isbill%>')">&nbsp;
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>" class="e8_btn_top middle" style="border:1px solid #aecef1 !important" onclick="onaddwfnodegeneralPrint()">		
			<span class="ellipsis" style="vertical-align:middle;">
				<input type="hidden" name="gen_belmodetype" />
				<span id="gen_printmodespan"></span>
				<span id="gen_printhtmlspan"></span>
			</span>
			<span style="vertical-align:middle;"><%=SystemEnv.getHtmlLabelName(27966,user.getLanguage())%>
			<%
				String completeUrl2 = "/data.jsp?type=workflowNodeBrowser&wfid="+wfid;
			%>  
				<span style="display:inline-block;vertical-align:middle;padding-left:5px;">
				<brow:browser name="genprintsyncNodes" viewType="0" hasBrowser="true" hasAdd="false" 
         			getBrowserUrlFn="getShowNodesUrl" getBrowserUrlFnParams="'genprintsyncNodes'" isMustInput="1" isSingle="false" hasInput="true"
          			completeUrl='<%=completeUrl2 %>'  width="150px" browserValue="" browserSpanValue="" />
          		</span>
          	</span>
          	</div>
		</wea:item>
	</wea:group>
<%-- 节点字段显示设置
	<wea:group context='<%=SystemEnv.getHtmlLabelName(21652,user.getLanguage())%>' attributes="<%=oDivOfAddWfNodeField %>">
		<wea:item><%=SystemEnv.getHtmlLabelName(15935,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser name="showContent" viewType="0" hasBrowser="true" hasAdd="false" 
         			browserUrl="" isMustInput="1" isSingle="false" hasInput="true"
          			completeUrl=""  width="150px" browserValue="" browserSpanValue="" />
		</wea:item>
	</wea:group>
 --%>
	<%-- 普通模板   end --%>
	
	<%
	String hDivOfAddWfNodeField = "{'groupSHBtnDisplay':'none','samePair':'hDivOfAddWfNodeField','groupDisplay':'','itemAreaDisplay':''}"; 
	if(!modetype.equals("2")){
		hDivOfAddWfNodeField = "{'groupSHBtnDisplay':'none','samePair':'hDivOfAddWfNodeField','groupDisplay':'none','itemAreaDisplay':'none'}"; 
	}	
	%>
	<%-- Html模板   start --%>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(16367,user.getLanguage())%>' attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true'}">
			<%
			if(wfsmtdetailCodeList.size() == 3){
				//使用静态加载，防止java变量重复定义
			%>
				<jsp:include page="/workflow/workflow/hDivOfWfNodeField.jsp" flush="true">
					<jsp:param name="wfid" value="<%=wfid%>" />
					<jsp:param name="nodeid" value="<%=nodeid%>" />
					<jsp:param name="isbill" value="<%=isbill%>" />
					<jsp:param name="formid" value="<%=formid%>" />
					<jsp:param name="ajax" value="<%=ajax%>" />
					<jsp:param name="design" value="<%=design%>" />
					<jsp:param name="hdiv" value="<%=hDivOfAddWfNodeField %>" />
				</jsp:include>
			<%}%>		
		</wea:item>
	</wea:group>
	<%-- Html模板   end --%>
</wea:layout>
<center>
<input type="hidden" value="wfnodefield" name="src">
  <input type="hidden" value="<%=wfid%>" name="wfid">
  <input type="hidden" value="<%=nodeid%>" name="nodeid">
  <input type="hidden" value="<%=formid%>" name="formid">
  <input type="hidden" value="<%=isbill%>" name="isbill">
  <input type="hidden" value="<%=showmodeid%>" name="showmodeid">
  <input type="hidden" value="<%=printmodeid%>" name="printmodeid">
  <input type="hidden" value="<%=showisform%>" name="showisform">
  <input type="hidden" value="<%=printisform%>" name="printisform">
  <input type="hidden" value="<%=showmode%>" name="showmodename">
  <input type="hidden" value="<%=printmode%>" name="printmodename">
</center>
</form>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="closeWindow();">
	    </wea:item>
		</wea:group>
	</wea:layout>
</div>	
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
<script type="text/javascript">

var dialog = parent.parent.getDialog(parent);
$(document).ready(function(){
	//liuzy 普通模式打印模板,先读取模板模式，再读取HTML模式
	if($("#printmodespan").find("a").html()==""){
		$("[name='gen_belmodetype']").val("2");
		$("#gen_printhtmlspan").html($("#printhtmlspan").html());
	}else{
		$("[name='gen_belmodetype']").val("1");
		$("#gen_printmodespan").html($("#printmodespan").html());
	}
 	resizeDialog(document);
});

function closeWindow(){
	var design="<%=design %>";
	if(design=='1'){	//图形化工具打开
		//window.parent.design_callback('addwfnodefield');
	}
	dialog.close();
}

function onaddwfnodegeneral(formid,nodeid,isbill,nodetype,isnew){
	if(isnew==''){
		isnew=$("#genmode_isnew").val();
	}
	var modename=$("#modenamelink").html();
	var modetype=$("select[name='modetype']").val();
	var choosemodeid='-1';
	if($("[name=ischoose]").val()=='y'){
		choosemodeid=$("[name='choosemodeid']").val();
	}
	urls = "/workflow/workflow/addwfnodegeneral.jsp?formid="+formid
		+"&nodeid="+nodeid+"&isbill="+isbill
		+"&nodetype="+nodetype+"&modetype="+modetype
		+"&wfid=<%=wfid%>&isnew="+isnew
		+"&modename="+modename+"&choosemodeid="+choosemodeid;
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.URL = urls;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(16367,user.getLanguage())%>";
	dialog.Width = 800 ;
	dialog.Height = 500 ;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.show();
}

function onShowBrowser4General(formid,isbill){
	urls = "/workflow/workflow/WorkflowGeneralBrowser.jsp?formid="+formid+"&isbill="+isbill+"&dialog=1&noclean=1";
	urls = "/systeminfo/BrowserMain.jsp?url="+encode(urls);
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.URL = urls;
	dialog.callbackfun = function (paramobj, datas) {
		if(datas.modeid!=""){
			jQuery("#modenamespan").html(datas.modename);
			jQuery("[name=ischoose]").val("y");
			jQuery("[name=choosemodeid]").val(datas.modeid);
		}else{
			jQuery("#modenamespan").html("");
			jQuery("[name=ischoose]").val("s");
			jQuery("[name=choosemodeid]").val("");
		}
	} ;
	dialog.Title = "<%=dialogTitle %>";
	dialog.Modal = true;
	dialog.Width = 550 ;
	dialog.Height = 550 ;
	dialog.isIframe=false;
	dialog.show();
}

function onShowBrowser4GeneralPrint(formid,nodeid,isbill){
	urls = "/workflow/workflow/WorkflowGeneralPrintBrowser.jsp?formid="+formid+"&isbill="+isbill+"&dialog=1";
	urls = "/systeminfo/BrowserMain.jsp?url="+encode(urls);
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.URL = urls;
	dialog.callbackfun = function (paramobj, datas) {
		if(datas){
			$("[name='gen_belmodetype']").val(datas.belmodetype);
			if(datas.belmodetype=='1'){
				$G("printmodeid").value = datas.modeid;
				$G("printisform").value = datas.isForm;
				$G("printmodename").value = datas.modename;
	            if (datas.modeid==""){
	            	$("#printmodespan").html("");
	            }else{
	                //url="<a href='#' onclick=openFullWindowHaveBar('/workflow/mode/index.jsp?formid="+formid+"&wfid=<%=wfid%>&nodeid="+nodeid+"&isform="+datas.isForm+"&isbill="+isbill+"&isprint=1&modeid="+datas.modeid+"')>"+datas.modename+"</a>";
	                $("#printmodespan").html(datas.modename);
				}
				//同步到普通模式打印模板显示

				$("#gen_printmodespan").html($("#printmodespan").html());
				$("#gen_printhtmlspan").html("");
			}else if(datas.belmodetype=='2'){
				$G("printhtmlid").value = datas.modeid;
				$G("printhtmlisform").value = datas.isForm;
				$G("printhtmlname").value = datas.modename;
				if( datas.modeid == ""){
					$("#printhtmlspan").html("");
				}else{
					//url="<a href='#' onclick=openFullWindowHaveBar('/workflow/html/LayoutEditFrame.jsp?formid="+formid+"&wfid=<%=wfid%>&nodeid="+nodeid+"&isform="+datas.isForm+"&isbill="+isbill+"&layouttype=1&modeid="+datas.modeid+"')>"+datas.modename+"</a>";
					$("#printhtmlspan").html(datas.modename);
				}
				//同步到普通模式打印模板显示

				$("#gen_printmodespan").html("");
				$("#gen_printhtmlspan").html($("#printhtmlspan").html());
			}
		}
	}
	dialog.Title = "<%=dialogTitle %>";
	dialog.Modal = true;
	dialog.Width = 550 ;
	dialog.Height = 550 ;
	dialog.isIframe=false;
	dialog.show();
}

function onaddwfnodegeneralPrint(){
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.URL="/workflow/workflow/addwfnodegeneralPrint.jsp?";
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("33251,82,33234",user.getLanguage()) %>";
	dialog.Width = 350 ;
	dialog.Height = 250 ;
	dialog.show();
}

function titlebox(obj){
	var ckbox = $(obj);
	var flag = ckbox.attr("checked");
	var ckboxval = ckbox.attr("name");
	if(ckboxval.indexOf("_view")>=0 && !flag){
		ckbox.closest("tr").find(":checkbox").attr("checked",false).next().removeClass("jNiceChecked");
	}else if(ckboxval.indexOf("_edit")>=0){
		if(flag){
			ckbox.closest("tr").find(":checkbox").eq(0).attr("checked",true).next().addClass("jNiceChecked");
		}else{
			ckbox.closest("tr").find(":checkbox").eq(2).attr("checked",false).next().removeClass("jNiceChecked");
		}	
	}else if(ckboxval.indexOf("_man")>=0 && flag){
		ckbox.closest("tr").find(":checkbox").attr("checked",true).next().addClass("jNiceChecked");
	}
}

function nodeCkAll(obj){
	var ckbox = $(obj);
	var flag = ckbox.attr("checked");
	var ckboxval = ckbox.attr("name");
	if(ckboxval.indexOf("_view")>=0){
		if(flag){
			ckbox.closest("table").find("input[name*=_view]").attr("checked",true).next().addClass("jNiceChecked");
		}else{
			ckbox.closest("table").find(":checkbox").attr("checked",false).next().removeClass("jNiceChecked");
		}		
	}else if(ckboxval.indexOf("_edit")>=0){
		if(flag){
			ckbox.closest("table").find("input[name*=_view]").attr("checked",true).next().addClass("jNiceChecked");
			ckbox.closest("table").find("input[name*=_edit]").attr("checked",true).next().addClass("jNiceChecked");
		}else{
			ckbox.closest("table").find("input[name*=_edit]").attr("checked",false).next().removeClass("jNiceChecked");
			ckbox.closest("table").find("input[name*=_man]").attr("checked",false).next().removeClass("jNiceChecked");
		}	
	}else if(ckboxval.indexOf("_man")>=0){
		if(flag){
			ckbox.closest("table").find(":checkbox").attr("checked",true).next().addClass("jNiceChecked");			
		}else{
			ckbox.closest("table").find("input[name*=_man]").attr("checked",false).next().removeClass("jNiceChecked");
		}
	}	
}

function titleviewAll(obj){
	if(obj.checked){
		$("#tab_dtl_list-1 input[name*=_view]").each(function(){
			var ck = $(this);
			var disabled = ck.attr("disabled");
			if(!disabled){
				ck.attr("checked",true);
				ck.next().addClass("jNiceChecked");
			}
		});
	}else{
		$("#tab_dtl_list-1 input[name*=_view]").each(function(){
			var ck = $(this);
			var disabled = ck.attr("disabled");
			if(!disabled){
				ck.attr("checked",false);
				ck.next().removeClass("jNiceChecked");
			}
		});
		
		$("#tab_dtl_list-1 input[name*=_edit]").each(function(){
			var ck = $(this);
			var disabled = ck.attr("disabled");
			if(!disabled){
				ck.attr("checked",false);
				ck.next().removeClass("jNiceChecked");
			}
		});
		
		$("#tab_dtl_list-1 input[name*=_man]").each(function(){
			var ck = $(this);
			var disabled = ck.attr("disabled");
			if(!disabled){
				ck.attr("checked",false);
				ck.next().removeClass("jNiceChecked");
			}
		});
	}
}

function titleeditAll(obj){
	if(obj.checked){
		$("#tab_dtl_list-1 input[name*=_edit]").each(function(){
			var ck = $(this);
			var disabled = ck.attr("disabled");
			if(!disabled){
				ck.attr("checked",true);
				ck.next().addClass("jNiceChecked");
			}
		});
		$("#tab_dtl_list-1 input[name*=_view]").each(function(){
			var ck = $(this);
			var disabled = ck.attr("disabled");
			if(!disabled){
				ck.attr("checked",true);
				ck.next().addClass("jNiceChecked");
			}
		});		
	}else{		
		$("#tab_dtl_list-1 input[name*=_edit]").each(function(){
			var ck = $(this);
			var disabled = ck.attr("disabled");
			if(!disabled){
				ck.attr("checked",false);
				ck.next().removeClass("jNiceChecked");
			}
		});
		$("#tab_dtl_list-1 input[name*=_man]").each(function(){
			var ck = $(this);
			var disabled = ck.attr("disabled");
			if(!disabled){
				ck.attr("checked",false);
				ck.next().removeClass("jNiceChecked");
			}
		});		
	}
	<% if(!nodetype.equals("0") && !nodetype.equals("3")){%>
	if(obj.checked){
		document.getElementById("titleFillId").checked=true;
		document.nodefieldform.level_man.checked=true;
	}else{
		document.getElementById("titleFillId").checked=false;
		document.nodefieldform.level_man.checked=false;
	}
	<%} %>	
}

function titlemanAll(obj){
	if(obj.checked){
		$("#tab_dtl_list-1 input[name*=_man]").each(function(){
			var ck = $(this);
			var disabled = ck.attr("disabled");
			if(!disabled){
				ck.attr("checked",true);
				ck.next().addClass("jNiceChecked");
			}
		});		
		$("#tab_dtl_list-1 input[name*=_edit]").each(function(){
			var ck = $(this);
			var disabled = ck.attr("disabled");
			if(!disabled){
				ck.attr("checked",true);
				ck.next().addClass("jNiceChecked");
			}
		});
		$("#tab_dtl_list-1 input[name*=_view]").each(function(){
			var ck = $(this);
			var disabled = ck.attr("disabled");
			if(!disabled){
				ck.attr("checked",true);
				ck.next().addClass("jNiceChecked");
			}
		});				
	}else{		
		$("#tab_dtl_list-1 input[name*=_man]").each(function(){
			var ck = $(this);
			var disabled = ck.attr("disabled");
			if(!disabled){
				ck.attr("checked",false);
				ck.next().removeClass("jNiceChecked");
			}
		});
	}
}

function selectviewall(checkname, opt){
	var tab_id = checkname+"tab";
	if(opt){
		$("#"+tab_id+" input[name^="+checkname+"_]").each(function(){
			var ck = $(this);
			var disabled = ck.attr("disabled");
			if(!disabled){
				ck.attr("checked",true);
				ck.attr("disabled",true);
				ck.next().removeClass("jNiceChecked").removeClass("jNiceCheckbox").addClass("jNiceCheckbox_disabled").addClass("jNiceChecked_disabled");
			}
		});
	}else{
		$("#"+tab_id+" input[name^="+checkname+"_]").each(function(){
			var ck = $(this);
			var disabled = ck.attr("disabled");
			if(!disabled){
				ck.attr("checked",false);
				ck.next().removeClass("jNiceChecked");
			}else{
				ck.attr("disabled",false);
				ck.next("span.jNiceCheckbox_disabled").removeClass("jNiceCheckbox_disabled").removeClass("jNiceChecked_disabled").addClass("jNiceCheckbox").addClass("jNiceChecked");
			}
		});
	}
}

function selectviewall2(checkname, opt){
	var tab_id = checkname+"tab2";
	if(opt){
		$("#"+tab_id+" input[name^="+checkname+"_]").each(function(){
			var ck = $(this);
			var disabled = ck.attr("disabled");
			if(!disabled){
				ck.attr("checked",true);
				ck.attr("disabled",true);
				ck.next().removeClass("jNiceChecked").removeClass("jNiceCheckbox").addClass("jNiceCheckbox_disabled").addClass("jNiceChecked_disabled");
			}
		});
	}else{
		$("#"+tab_id+" input[name^="+checkname+"_]").each(function(){
			var ck = $(this);
			var disabled = ck.attr("disabled");
			if(!disabled){
				ck.attr("checked",false);
				ck.next().removeClass("jNiceChecked");
			}else{
				ck.attr("disabled",false);
				ck.next("span.jNiceCheckbox_disabled").removeClass("jNiceCheckbox_disabled").removeClass("jNiceChecked_disabled").addClass("jNiceCheckbox").addClass("jNiceChecked");
			}
		});
	}
}

var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
function nodefieldsave(){
	nodefieldform.submit();
}

function onsavefield(){
	nodefieldsave();
}

function change(thisele) {
	var modeid= thisele.value;
    if(modeid=="1"){
        hideGroup("oDivOfAddWfNodeField");
        hideGroup("hDivOfAddWfNodeField");
        showGroup("tDivOfAddWfNodeField");
    }else if(modeid=="0"){
   		showGroup("oDivOfAddWfNodeField");
        hideGroup("hDivOfAddWfNodeField");
        hideGroup("tDivOfAddWfNodeField"); 
    }else if(modeid=="2"){
   		hideGroup("oDivOfAddWfNodeField");
        showGroup("hDivOfAddWfNodeField");
        hideGroup("tDivOfAddWfNodeField"); 
    }
}

function onShowBrowser4field(formid,nodeid,isbill,isprint){
	var urls = "";
    urls="/workflow/workflow/WorkflowModeBrowser.jsp?formid="+formid+"&isprint="+isprint+"&isbill="+isbill;
    urls = "/systeminfo/BrowserMain.jsp?url="+encode(urls);
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.URL = urls;
	dialog.callbackfun = function (paramobj, datas) {
		if(datas){
			if (isprint!="1"){
	            $G("showmodeid").value = datas.modeid;
	            $G("showisform").value = datas.isForm;
	            $G("showmodename").value = datas.modename;
	            if (datas.modeid==""){
	                $("#showmodespan").html("");
				}else{
	                url="<a href='#' onclick=openFullWindowHaveBar('/workflow/mode/index.jsp?formid="+formid+"&wfid=<%=wfid%>&nodeid="+nodeid+"&isform="+datas.isForm+"&isbill="+isbill+"&isprint=0&modeid="+datas.modeid+"')>"+datas.modename+"</a>";
	                $("#showmodespan").html(url);
				}
			}else{
				$G("printmodeid").value = datas.modeid;
				$G("printisform").value = datas.isForm;
				$G("printmodename").value = datas.modename;

	            if (datas.modeid==""){
	            $("#printmodespan").html("");
	            }else{
	                url="<a href='#' onclick=openFullWindowHaveBar('/workflow/mode/index.jsp?formid="+formid+"&wfid=<%=wfid%>&nodeid="+nodeid+"&isform="+datas.isForm+"&isbill="+isbill+"&isprint=1&modeid="+datas.modeid+"')>"+datas.modename+"</a>"
	                $("#printmodespan").html(url);
				}
			}
		}
	} ;
	dialog.Title = "<%=dialogTitle %>";
	dialog.Width = 550 ;
	dialog.Height = 550 ;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.show();
}

function onShowNodes4html(inputname,spanname,selectids){
	var wfid = "<%=wfid %>";
	var nodeid = "<%=nodeid %>";
	var selectids = $("#"+inputname).val();
	if(selectids==""){
		selectids = "0";		
	}
	var urls="/workflow/workflow/WorkFlowNodesBrowser.jsp?wfid="+wfid+"_"+nodeid+"_"+selectids;
	urls="/systeminfo/BrowserMain.jsp?url="+urls
	var id1 = window.showModalDialog(urls);
	if(id1==null){
		return;	
	}else if(id1[0]==0||id1[1]==""){
		$("#"+inputname).val("");
		$("#"+spanname).html("");
	}else if(id1[0]==1){
		$("#"+inputname).val(id1[1]);
		$("#"+spanname).html("<a href='#"+id1[1]+"'>"+id1[2]+"</a>");
	}
}

function edithtmlnodefield(nodeid,ajax,design,wfid){
	window.location="/workflow/workflow/edithtmlnodefield.jsp?nodeid="+nodeid+"&ajax="+ajax+"&design="+design+"&wfid="+wfid;
}

function nodefieldbatchset(nodeid,ajax){
	window.location="/workflow/workflow/edithtmlnodefield.jsp?wfid=<%=wfid%>&nodeid="+nodeid+"&ajax="+ajax;
}

function encode(str){
    return escape(str);
}

function getShowNodesUrl(inputname) {
	var wfid = "<%=wfid%>";
	var nodeid = "<%=nodeid%>";
	var selectids = $G(inputname).value;
	if(selectids == ""){
		selectids = "0";		
	}
	var urls="/workflow/workflow/WorkFlowNodesBrowser.jsp?wfid="+wfid+"_"+nodeid+"_"+selectids;
	urls="/systeminfo/BrowserMain.jsp?url="+urls
	return urls;
}

function getShowNodesUrl1(inputname) {
	var wfid = "<%=wfid%>";
	var nodeid = "<%=nodeid%>";
	var selectids = $G(inputname).value;
	if(selectids == ""){
		selectids = "0";		
	}
	var urls="/workflow/workflow/WorkFlowNodesBrowser.jsp?wfid="+wfid+"_"+nodeid+"_"+selectids+"_1";
	urls="/systeminfo/BrowserMain.jsp?url="+urls
	return urls;
}
</script>
</body>
</html>
