<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.fna.budget.FnaWfSet"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
//new LabelComInfo().removeLabelCache();
if(!HrmUserVarify.checkUserRight("CostControlProcedure:set", user)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

SubCompanyComInfo subCompanyComInfo = new SubCompanyComInfo();
ManageDetachComInfo manageDetachComInfo = new ManageDetachComInfo();
CheckSubCompanyRight checkSubCompanyRight = new CheckSubCompanyRight();

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int wfid=0;
int templateid=0;
WfRightManager wfrm = new WfRightManager();
wfid = (wfid==0)?templateid:wfid;
boolean haspermission = wfrm.hasPermission3(wfid, 0, user, WfRightManager.OPERATION_CREATEDIR);
int subCompanyId2 = -1;
boolean isHasRight = false;
int subCompanyId=-1;
int operatelevel=0;
String[] subCompanyArray = null;


if(detachable==1){  
    //如果开启分权，管理员
    subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId2")),-1);
    subCompanyId2 = subCompanyId;
    String hasRightSub = subCompanyComInfo.getRightSubCompany(user.getUID(),"WorkflowManage:All",0);
    if(!"".equals(hasRightSub)){
        subCompanyArray = hasRightSub.split(",");    
    }
    if(subCompanyId == -1){
        //系统管理员
        if(user.getUID() == 1 ){
   	         rs.executeProc("SystemSet_Select","");
   	         if(rs.next()){
   	             subCompanyId2 = Util.getIntValue(rs.getString("wfdftsubcomid"),0);
   	         }
       }else{
           if(subCompanyArray != null){
               subCompanyId2 = Util.getIntValue(subCompanyArray[0]);  
           }
       }
    }
    if(user.getUID() == 1){
        operatelevel = 2;
    }else{
        String subCompanyIds = manageDetachComInfo.getDetachableSubcompanyIds(user);
        if (subCompanyId == 0 || subCompanyId == -1 ) {
            if (subCompanyIds != null && !"".equals(subCompanyIds)) {
                String [] subCompanyIdArray = subCompanyIds.split(",");
                for (int i=0; i<subCompanyIdArray.length; i++) {
                    subCompanyId = Util.getIntValue(subCompanyIdArray[i]);
                    operatelevel= checkSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"WorkflowManage:All",subCompanyId);
                    if (operatelevel > 0) {
                        break;
                    }
                }
            }
        } else {
            operatelevel= checkSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"WorkflowManage:All",subCompanyId);
        }            
    }

}else{
    if(HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
        operatelevel=2;
    }else{
        operatelevel=1;
    }
        
}

String r = FnaCommon.getPrimaryKeyGuid1();
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(83182,user.getLanguage());
String needfav ="1";
String needhelp ="";

String creatType = Util.null2String(request.getParameter("creatType")).trim();
%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@page import="weaver.hrm.moduledetach.ManageDetachComInfo"%>
<%@page import="weaver.systeminfo.systemright.CheckSubCompanyRight"%>
<%@page import="weaver.workflow.workflow.WfRightManager"%><HTML><HEAD>
<link href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET"/>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
<script language=javascript>
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...
var _getHtmlLabelName30702 = "<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage()) %>";//必填信息不完整
var _creatType = "<%=creatType %>";
</script>
<script language="javascript" src="/fna/guide/css/fna_guide_css_01_wev8.js?r=<%=r %>"></script>
<link href="/fna/guide/css/fna_guide_css_01_wev8.css?r=<%=r %>" type="text/css" rel="STYLESHEET"/>
</head>
<body style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(127025, user.getLanguage())
			+ ",javascript:fnaWfCreat_doSave(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content">
<form action="">
	<div class="fnaTitle1">1、<%= SystemEnv.getHtmlLabelName(127027,user.getLanguage())%></div><!-- 创建表单 -->
	<div class="u_line u444_line u444_line1"></div>
	<div class="u_node u438_node">
		<font class="u_nodeFont">1</font>		
	</div>
	<div class="u_line u437_line u437_line1"></div>
	<div class="u_node u440_node">
		<font class="u_nodeFont">2</font>		
	</div>
	<div class="u_line u437_line u437_line1"></div>
	<div class="u_node u440_node">
		<font class="u_nodeFont">3</font>		
	</div>
	<div class="u_line u437_line u437_line2"></div>
	<div class="fnaContent fnaContent1"><%= SystemEnv.getHtmlLabelName(127028,user.getLanguage())%></div><!-- 请先初始化表单 -->
	<div class="fnaContent fnaContent2"><%= SystemEnv.getHtmlLabelName(127029,user.getLanguage())%></div><!-- （填写表单名称后，点击【初始化表单】按钮进行初始化） -->
	<div class="fnaContent fnaContent3">
		<div class="fnaContentSubDiv1">
			<%=SystemEnv.getHtmlLabelName(15451,user.getLanguage())%>：
		</div>
		<div class="fnaContentSubDiv2">
			<wea:required id="formNameSpan" required="true">
				<input class="inputstyle" id="formName" name="formName" maxlength="80" style="width: 196px;" value="" 
	   	   			onchange='checkinput("formName","formNameSpan");' />
			</wea:required>
		</div>
	</div>
<%
if("fnaFeeWf".equals(creatType)){//费用报销流程
%>
	<div class="fnaContent fnaContent6">
		<div class="fnaContentSubDiv1">
			<%=SystemEnv.getHtmlLabelName(128175,user.getLanguage())%>：<!-- 启用明细报销 -->
		</div>
		<div class="fnaContentSubDiv2">
		    <select id="isFnaFeeDtl" name="isFnaFeeDtl" notBeauty="true">
				<option value="0"><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option><!-- 否 -->
				<option value="1" selected="selected"><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option><!-- 是 -->
		    </select>
		</div>
	</div>
	<div class="fnaContent fnaContent6">
		<div class="fnaContentSubDiv1">
			<%=SystemEnv.getHtmlLabelName(84237,user.getLanguage())%>：<!-- 启用还款 -->
		</div>
		<div class="fnaContentSubDiv2">
   			<input id="enableRepayment" name="enableRepayment" value="1" type="checkbox" tzCheckbox="true" />
		</div>
	</div>
<%
}
%>
<%if(detachable==1){%>
	<div class="fnaContent fnaContent6">
		<div class="fnaContentSubDiv1">
			<%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%>：
		</div>
		<div class="fnaContentSubDiv2">
		<%
		if(operatelevel>0 && (!haspermission || isHasRight)){%>
			<brow:browser name="subcompanyid" viewType="0" hasBrowser="true" hasAdd="false" 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowManage:All&isedit=1" isMustInput="2" isSingle="true" hasInput="true"
				completeUrl="/data.jsp?type=164&show_virtual_org=-1"  width="300px" browserValue="<%=String.valueOf(subCompanyId2)%>" 
				browserSpanValue="<%=subCompanyComInfo.getSubCompanyname(String.valueOf(subCompanyId2))%>" />
		<%}else{%>
			<span id="subcompanyspan"><%=subCompanyComInfo.getSubCompanyname(String.valueOf(subCompanyId2))%>
			<%if(String.valueOf(subCompanyId2).equals("")){%>
				<IMG src="/images/BacoError_wev8.gif" align="absMiddle" />
			<%}%>
			</span>
			<input id="subcompanyid" name="subcompanyid" type="hidden" value="<%=subCompanyId2%>">
		<%} %>
		</div>	
	</div>
<%}%>
	<div class="fnaContent fnaContent4">
   		<input class="e8_btn_top" type="button" id="btnSave" onclick="fnaWfCreat_doSave();" 
   	   		style="width: 140px;height: 40px;background-color: #30b5ff;color: #FFF;" 
   			value="<%=SystemEnv.getHtmlLabelName(127025,user.getLanguage())%>"/><!-- 初始化表单 -->
	</div>
</form>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" id="btnClose" onclick="doClose();" 
    			value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"/><!-- 取消 -->
    	</wea:item>
    </wea:group>
</wea:layout>
</div>
</BODY>
</HTML>
