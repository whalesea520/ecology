
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,weaver.general.BaseBean" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="oracle.sql.CLOB,java.text.*" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="weaver.conn.ConnStatement" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CoworkDAO" class="weaver.cowork.CoworkDAO" scope="page"/>
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="ReportAuthorization" class="weaver.workflow.report.ReportAuthorization" scope="page"/>
<jsp:useBean id="wfShareAuthorization" class="weaver.workflow.request.WFShareAuthorization" scope="page" />
<jsp:useBean id="DateUtil" class="weaver.general.DateUtil" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/css/rp_wev8.css" rel="STYLESHEET" type="text/css">
<script language=javascript src="/js/weaver_wev8.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<%
int ismultiprintmode = Util.getIntValue(request.getParameter("ismultiprintmode"));
String acceptlanguage = request.getHeader("Accept-Language");
if(!"".equals(acceptlanguage))
	acceptlanguage = acceptlanguage.toLowerCase();
//TD9892
BaseBean bb_printmode = new BaseBean();
int urm_printmode = 1;
try{
	urm_printmode = Util.getIntValue(bb_printmode.getPropValue("systemmenu", "userightmenu"), 1);
	if(ismultiprintmode == 1){
		urm_printmode = 0;
	}
}catch(Exception e){}
String isprintlog= Util.null2String(request.getParameter("isprintlog"));
String isbill = Util.null2String(request.getParameter("isbill"));
int workflowid = Util.getIntValue(request.getParameter("workflowid"));
String formid = Util.null2String(request.getParameter("formid"));
String billid = Util.null2String(request.getParameter("billid"));    
int requestid = Util.getIntValue(request.getParameter("requestid"));
String nodeid = Util.null2String(request.getParameter("nodeid"));
int urger=Util.getIntValue(request.getParameter("urger"),0);
int ismonitor=Util.getIntValue(request.getParameter("ismonitor"),0);    
String organizationid = "";
if("1".equals(isbill)&&"156".equals(formid)){
    RecordSet.executeSql("select fieldname,id,type,fieldhtmltype from workflow_billfield where viewtype=1 and billid="+formid);
    while(RecordSet.next()){
        if("organizationid".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase())){
            organizationid="field"+RecordSet.getString("id");
        }
    }
}
//add by mackjoe at 2005-12-20 增加模板应用
String ismode="";
int modeid=0;
int isform=0;
int printdes=0;
int creater = 0;
int creatertype = 0;
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
 user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid = user.getUID();
String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
int usertype = 0;
if(logintype.equals("1")) usertype = 0;
if(logintype.equals("2")) usertype = 1;
boolean canprint = false;
String modestr="";
String sql="";

sql = "select * from workflow_requestbase where requestid = " + requestid;
RecordSet.executeSql(sql);
if(RecordSet.next()){
   creater = RecordSet.getInt("creater");
   creatertype = RecordSet.getInt("creatertype");
}

//根据当前用户是否为流程的节点操作者来判断能否打印流程
sql = "select * from workflow_currentoperator where requestid = " + requestid + " and userid = " + userid;
RecordSet.executeSql(sql);
if(RecordSet.next()){
   canprint = true;
}
//相关流程可以打印
String wflinkno = Util.null2String((String) session.getAttribute(requestid+"wflinkno"));
if(!wflinkno.equals("")){
   canprint = true;
}
//主流程和子流程相互查看

ArrayList canviewwff = (ArrayList)session.getAttribute("canviewwf");
if(canviewwff!=null){
   if(canviewwff.indexOf(requestid+"")>-1)
         canprint = true;
}
if(creater == userid && creatertype == usertype){   // 创建者本人有打印权限
	canprint = true;
}
if(CoworkDAO.haveRightToViewWorkflow(Integer.toString(userid),Integer.toString(requestid))){//协作区

    canprint = true;
}

if(WFUrgerManager.UrgerHaveWorkflowViewRight(requestid,userid,Util.getIntValue(logintype,1)) || WFUrgerManager.getMonitorViewRight(requestid,userid)){//督办流程和监控流程的相关流程有打印权限

    canprint = true;    
}

String isfromreport = Util.null2String(request.getParameter("isfromreport"));
String isfromflowreport = Util.null2String(request.getParameter("isfromflowreport"));
if(isfromreport.equals("1") &&  requestid != 0){
	if(!canprint){
		canprint = ReportAuthorization.checkReportPrivilegesByRequest(request,user);
	}
}

if(isfromflowreport.equals("1") &&  requestid != 0){
	if(!canprint){
		canprint = ReportAuthorization.checkFlowReportByRequest(request,user);
	}
}

String iswfshare = Util.null2String(request.getParameter("iswfshare"));
if(!canprint && iswfshare.equals("1")){
	canprint = wfShareAuthorization.getWorkflowShareJurisdiction(String.valueOf(requestid),user);
}

if(!canprint){
    boolean isurger=false;
    boolean wfmonitor=false;
    if(urger==1)  isurger=WFUrgerManager.UrgerHaveWorkflowViewRight(requestid,userid,Util.getIntValue(logintype,1));
    if(ismonitor==1) wfmonitor=WFUrgerManager.getMonitorViewRight(requestid,userid);
    if(!isurger&&!wfmonitor){
    response.sendRedirect("/notice/noright.jsp");
    return;
    }
}
int toexcel=0;
RecordSet.executeSql("select ismode,printdes,toexcel from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
if(RecordSet.next()){
    ismode=Util.null2String(RecordSet.getString("ismode"));
    printdes=Util.getIntValue(Util.null2String(RecordSet.getString("printdes")),0);
    toexcel=Util.getIntValue(Util.null2String(RecordSet.getString("toexcel")),0);
}
if(  printdes!=1){
    RecordSet.executeSql("select id from workflow_nodemode where isprint='1' and workflowid="+workflowid+" and nodeid="+nodeid);
    if(RecordSet.next()){
        modeid=RecordSet.getInt("id");
    }else{
        RecordSet.executeSql("select id from workflow_formmode where formid="+formid+" and isbill='"+isbill+"' order by isprint desc");
        while(RecordSet.next()){
            if(modeid<1){
                modeid=RecordSet.getInt("id");
                isform=1;
            }
        }
    }
}

//=========================新增打印日志start=================
if(!isprintlog.equals("true")){//在printRequest.jsp打印过了无需再次调用
	
SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//设置日期格式
String currentdatestr=df.format(new Date());
int p_number=0;
String centip=request.getRemoteAddr();
rs1.executeSql("select  p_number from workflow_viewlog where requestid='"+requestid+"' and p_opteruid='"+user.getUID()+"' and p_nodeid='"+nodeid+"' order by  id desc ");
if(rs1.next()){
  p_number=Util.getIntValue(rs1.getString("p_number"),0);
}
 // System.out.println("select max(p_number) p_number from workflow_viewlog where requestid='"+requestid+"' and p_opteruid='"+user.getUID()+"' and p_nodeid='"+nodeid+"'");

String nodenamest=DateUtil.getWFNodename(""+nodeid,""+7);
String requestname2="";
rs1.executeSql("select requestname from workflow_requestbase where requestid='"+requestid+"'");
if(rs1.next()){
	requestname2=Util.null2String(rs1.getString("requestname"));
}
  String workflowtype2="";
  String workflowtypeid2="";
  rs1.executeSql("select typename,id from workflow_type where id in(select workflowtype from workflow_base where id='"+workflowid+"' )");
  if(rs1.next()){
	  workflowtype2=Util.null2String(rs1.getString("typename"));
	  workflowtypeid2=Util.null2String(rs1.getString("id"));
  }
  //System.out.println(p_number+"=====(p_number+1)==="+(p_number+1));
  rs1.executeSql("insert into workflow_viewlog(p_nodename,p_nodeid,p_opteruid,p_date,p_addip,p_number,requestid,workflowtype,requestname,workflowid,workflowtypeid)values('"+nodenamest+"','"+nodeid+"','"+user.getUID()+"','"+currentdatestr+"','"+centip+"','"+(p_number+1)+"','"+requestid+"','"+workflowtype2+"','"+requestname2+"','"+workflowid+"','"+workflowtypeid2+"')");
}
//=========================新增打印日志end===================

//=================设为已打印===============
if(ismultiprintmode == 1){  //只有批量打印的时候才需要单独处理，因为单个打印会从PrintRequest.jsp跳转过来，那里已经修改了状态
	rs1.executeSql("update workflow_requestbase set ismultiprint = '1' where requestid = " + requestid);
}

if(modeid<=0){
	if(ismultiprintmode == 1){
		return;
	}
	
%>
<script type="text/javascript">
var redirectUrl = "PrintRequest.jsp?isprintlogMode=true&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&isprint=1&fromFlowDoc=1&urger=<%=urger%>&ismonitor=<%=ismonitor%>" ;
<%//解决相关流程打印权限问题
if(!wflinkno.equals("")){
%>
redirectUrl = "PrintRequest.jsp?isprintlogMode=true&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&isprint=1&fromFlowDoc=1&isrequest=1&wflinkno=<%=wflinkno%>&urger=<%=urger%>&ismonitor=<%=ismonitor%>";
<%}%>
var width = screen.width ;
var height = screen.height ;
if (height == 768 ) height -= 75 ;
if (height == 600 ) height -= 60 ;
var szFeatures = "top=0," ;
szFeatures +="left=0," ;
szFeatures +="width="+width+"," ;
szFeatures +="height="+height+"," ;
szFeatures +="directories=no," ;
szFeatures +="status=yes," ;
szFeatures +="menubar=no," ;
szFeatures +="toolbar=yes," ;
szFeatures +="scrollbars=yes," ;

szFeatures +="resizable=yes" ; //channelmode
window.open(redirectUrl,"",szFeatures) ;
window.opener=null;
window.close();
</script>
<%
     return;
 }
 int uploadType = 0;
 String selectedfieldid = "";
 String result = RequestManager.getUpLoadTypeForSelect(workflowid);
 if(!result.equals("")){
     uploadType = Integer.valueOf(result.substring(result.indexOf(",")+1)).intValue();
     selectedfieldid = result.substring(0,result.indexOf(","));
 }    
//end by mackjoe


%>

<BODY id="flowbody" style="overflow:auto;<%if(urm_printmode!=1){%>margin-top: 24px;<%}%>" onLoad="init()">
<%if(ismultiprintmode!=1){%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(257,user.getLanguage())+",javascript:doPrint(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(20757,user.getLanguage())+",javascript:doPrintPreview(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18173,user.getLanguage())+",javascript:dosystemhead(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
if(toexcel==1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+" Excel,javascript:ToExcel(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%}%>
<%if(urm_printmode!=1){%>
<div id="printdiv" style='position: relative;left: 0px; top: 0px; height: 24px; right: 6px; padding-top: 3px; padding-right: 3px; padding-bottom: 3px; padding-left: 3px; margin-top: 0px; visibility: visible;'></div>
<%} %>
<table width="100%" height="98%" border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td width="100%" height=100% valign="top">
<script language=javascript src="/workflow/mode/loadmode_wev8.js"></script>
<script language=javascript src="/js/characterConv_wev8.js"></script>
<script type="text/javascript">
function getOuterLanguage()
{
	return '<%=acceptlanguage%>';
}
</script>
<SCRIPT FOR="ChinaExcel" EVENT="ShowCellChanged()"	LANGUAGE="JavaScript" >
var uservalue=frmmain.ChinaExcel.GetCellUserStringValue(frmmain.ChinaExcel.Row,frmmain.ChinaExcel.Col);
var cellvalue=frmmain.ChinaExcel.GetCellValue(frmmain.ChinaExcel.Row,frmmain.ChinaExcel.Col);
cellvalue = Simplized(cellvalue);
var ismand=frmmain.ChinaExcel.GetCellUserValue(frmmain.ChinaExcel.Row,frmmain.ChinaExcel.Col);
	showPopup(uservalue,cellvalue,ismand,0);   
	return false;
</script>
<SCRIPT FOR="ChinaExcel" EVENT="MouseRClick()"	LANGUAGE="JavaScript" >
        hidePopup();
        <%if(urm_printmode==1){%>
        showRightClickMenuByHand(frmmain.ChinaExcel.GetMousePosX(),frmmain.ChinaExcel.GetMousePosY());
		try{
			event.stopPropagation();
		}catch(e){
			try{
				event.cancelBubble = true
				event.returnValue = false;
			}catch(e){}
		} 
		//$G("rightMenu").style.display = "";
		<%}%>		
		return false;
</SCRIPT>
<SCRIPT FOR="ChinaExcel" EVENT="CellContentChanged()"	LANGUAGE="JavaScript" >
    imgshoworhide(frmmain.ChinaExcel.Row,frmmain.ChinaExcel.Col); 
    var uservalue=frmmain.ChinaExcel.GetCellUserStringValue(frmmain.ChinaExcel.Row,frmmain.ChinaExcel.Col);
    var cellvalue=frmmain.ChinaExcel.GetCellValue(frmmain.ChinaExcel.Row,frmmain.ChinaExcel.Col);
    cellvalue = Simplized(cellvalue);
    var ismand=frmmain.ChinaExcel.GetCellUserValue(frmmain.ChinaExcel.Row,frmmain.ChinaExcel.Col);
    changevalue(uservalue,cellvalue,ismand);
	return false;
</script>
<SCRIPT FOR="ChinaExcel" EVENT="ComboSelChanged()"	LANGUAGE="JavaScript" >
    var nrow= frmmain.ChinaExcel.Row;
    var ncol=frmmain.ChinaExcel.Col;
    var selvalue=GetCellComboSelectedValue(nrow,ncol);
    var uservalue=frmmain.ChinaExcel.GetCellUserStringValue(nrow,ncol);
    var nindx=uservalue.lastIndexOf("_");
    if(nindx>0){
        uservalue=uservalue.substring(0,nindx);
        nindx=uservalue.lastIndexOf("_");
        if(nindx>0){
            uservalue=uservalue.substring(0,nindx);
        }
    }
    $G("selframe").src="/workflow/request/WorkflowModeSel.jsp?nrow="+nrow+"&ncol="+ncol+"&selvalue="+selvalue+"&fieldid="+uservalue+"&isbill=<%=isbill%>";
	return false;
</script>
<SCRIPT FOR="ChinaExcel" EVENT="CheckBoxCliceked()"	LANGUAGE="JavaScript" >
    var nrow= frmmain.ChinaExcel.Row;
    var ncol=frmmain.ChinaExcel.Col;
    var checkvalue="0";
    var uservalue=frmmain.ChinaExcel.GetCellUserStringValue(nrow,ncol);
    if(uservalue.indexOf("_sel")<0){
        var nindx=uservalue.lastIndexOf("_");
        if(nindx>0){
            uservalue=uservalue.substring(0,nindx);
            nindx=uservalue.lastIndexOf("_");
            if(nindx>0){
                uservalue=uservalue.substring(0,nindx);
            }
        }
        if(GetCellCheckBoxValue(nrow,ncol)){
            checkvalue="1";
        }
        $G(uservalue).value=checkvalue;
    }
	return false;
</script>
<SCRIPT FOR="ChinaExcel" EVENT="MouseLClick()"	LANGUAGE="JavaScript" >
	<%if(urm_printmode==1){%>
    hideRightClickMenu();
    <%}%>
    var uservalue=frmmain.ChinaExcel.GetCellUserStringValue(frmmain.ChinaExcel.Row,frmmain.ChinaExcel.Col); 
    var fieldname=uservalue;
    if(uservalue!=null){
        var indx=uservalue.lastIndexOf("_");
        if(indx>0){
            var addordel=uservalue.substring(indx+1);
            uservalue=uservalue.substring(0,indx);
            if(addordel=="6"){
                indx=uservalue.indexOf("_");
                if(indx>0){
                    uservalue=uservalue.substring(0,indx);
                }
                var fieldvalue=$G(uservalue).value;
                if(fieldvalue.length>0){
                var selectfieldvalue="";
                <%
                if(!selectedfieldid.equals("")){
                %>
                if($G("field<%=selectedfieldid%>")) selectfieldvalue=$G("field<%=selectedfieldid%>").value
                <%}%>    
                var redirectUrl = "/workflow/request/WorkFlowFileUP.jsp?fieldvalue="+fieldvalue+"&fieldname="+fieldname+"&workflowid=<%=workflowid%>&fieldid="+uservalue+"&isedit=0&isbill=<%=isbill%>&uploadType=<%=uploadType%>&selectedfieldid=<%=selectedfieldid%>&selectfieldvalue="+selectfieldvalue;
                var szFeatures = "top="+(screen.height-300)/2+"," ;
                szFeatures +="left="+(screen.width-750)/2+"," ;
                szFeatures +="width=750," ;
                szFeatures +="height=300," ; 
                szFeatures +="directories=no," ;
                szFeatures +="status=no," ;
                szFeatures +="menubar=no," ;
                szFeatures +="scrollbars=yes," ;
                szFeatures +="resizable=no" ; //channelmode
                window.open(redirectUrl,"fileup",szFeatures) ;
                frmmain.ChinaExcel.GoToCell(1,1);
                }
            }
        }
    }
	return false;
</SCRIPT>
<div id="formcontent">
<form name="frmmain" method="post" action="RequestOperation.jsp" enctype="multipart/form-data">
<%if(acceptlanguage.indexOf("zh-tw")>-1||acceptlanguage.indexOf("zh-hk")>-1){%>
<script language=javascript src="/workflow/mode/chinaexcelobj_tw_wev8.js"></script>
<%}else{%>
<script language=javascript src="/workflow/mode/chinaexcelobj_wev8.js"></script>
<%} %>
<DIV id="ocontext" name="ocontext" style="LEFT: 0px;Top:0px;POSITION:ABSOLUTE ;display:none" >
<table id=otable cellpadding='0' cellspacing='0' width="200" border=1 style="WORD-WRAP:break-word">
</table>
</DIV>
<input type=hidden name="indexrow" id="indexrow" value=0>
<input type=hidden name="isform" id="isform" value="<%=isform%>">
<input type=hidden name="modeid" id="modeid" value="<%=modeid%>">
<input type=hidden name="modestr" id="modestr" value="">
<input type=hidden name ="needcheck" value="">

<jsp:include page="PrintHiddenField.jsp" flush="true">
    <jsp:param name="requestid" value="<%=requestid%>" />
	<jsp:param name="workflowid" value="<%=workflowid%>" />
	<jsp:param name="formid" value="<%=formid%>" />
    <jsp:param name="billid" value="<%=billid%>" />
    <jsp:param name="isbill" value="<%=isbill%>" />
    <jsp:param name="nodeid" value="<%=nodeid%>" />
    <jsp:param name="iswfshare" value="<%=iswfshare%>" />
    <jsp:param name="Languageid" value="<%=user.getLanguage()%>" />
	</jsp:include>
</form>
</div>
</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
</body>
</html>
<script language=javascript>
function readmode(){
    frmmain.ChinaExcel.ReadHttpFile("/workflow/mode/ModeReader.jsp?modeid=<%=modeid%>&nodeid=<%=nodeid%>&isform=<%=isform%>");
	try{
	    var maxrow=frmmain.ChinaExcel.GetMaxRow();
	    var maxcol=frmmain.ChinaExcel.GetMaxCol();
	    var userstr="";
	    for(var i=1;i<=maxrow;i++){
	        for(var j=1;j<=maxcol;j++){
	            userstr=frmmain.ChinaExcel.GetCellUserStringValue(i,j);             
	<%if("1".equals(isbill) && "156".equals(formid)) {%>
	            if(userstr == '<%=organizationid%>_0_1_3') {
	            	userstr = "<%=organizationid%>_0_4_3";
	            	isProtect=frmmain.ChinaExcel.IsCellProtect(i,j);
					if(isProtect){
						frmmain.ChinaExcel.SetCellProtect(i,j,i,j,false);
					}
					frmmain.ChinaExcel.SetCellUserStringValue(i,j,i,j,userstr);
					if(isProtect){
						frmmain.ChinaExcel.SetCellProtect(i,j,i,j,true);
					}
	            }
	<%}%>
			}
		}
	}catch(e){}
}
</script>
<script language=vbs>
sub init()
    frmmain.ChinaExcel.SetOnlyShowTipMessage true
    chinaexcelregedit()
	readmode()
    frmmain.ChinaExcel.DesignMode = false
    frmmain.ChinaExcel.SetShowPopupMenu false
    frmmain.ChinaExcel.SetCanAutoSizeHideCols true
    frmmain.ChinaExcel.SetProtectFormShowCursor true
    frmmain.ChinaExcel.ShowGrid = false
    frmmain.ChinaExcel.SetShowScrollBar 1,false
    getRowGroup()
    setmantable()
    setdetailtable()
    setnodevalue()
    frmmain.ChinaExcel.ReCalculate()
    frmmain.ChinaExcel.FormProtect true
    frmmain.ChinaExcel.SetPasteType 1
    frmmain.ChinaExcel.height= "100%"
    frmmain.ChinaExcel.GoToCell 1,1
    RefreshViewSize()
    frmmain.ChinaExcel.SetOnlyShowTipMessage false
	convertText()
<%if(ismultiprintmode==1){%>
	bodyresize()
<%}%>
	setheight()
end sub
</script>
<script language=javascript>
function bodyresize(){
	var totalheight = gettotalheight();
	var totalwidth = gettotalwidth();
	$G("requestiframe<%=requestid%>", parent.document).height = totalheight + 50;
	$G("requestiframe<%=requestid%>", parent.document).width = totalwidth + 50;
	var objAList = document.getElementsByTagName("A");
	for(var i=0; i<objAList.length; i++){
		var obj = objAList[i];
		var href = obj.href;
		var target = obj.target;
		if(href.indexOf("javascript:") == -1){
			obj.target = "_blank";
		}
	}
}

function setheight(){
     var maxrow=frmmain.ChinaExcel.GetMaxRow();
     var totalheight=35;
     for(var i=1;i<=maxrow;i++){
         totalheight+=frmmain.ChinaExcel.GetRowSize(i,1);
     }
     frmmain.ChinaExcel.height=totalheight;
     frmmain.ChinaExcel.SetShowScrollBar(1,true);
}

window.onresize = function  (){
    frmmain.ChinaExcel.height= "100%"
    frmmain.ChinaExcel.SetShowScrollBar(1,true);
}
function doPrintPreview(){
	frmmain.ChinaExcel.ClosePrintPreviewWindow();
    frmmain.ChinaExcel.SetUseDefaultPrinter(true);
    frmmain.ChinaExcel.OnFilePrintPreview();
}
function doPrint(){
	try{ 
		jQuery("#formcontent").hide();
		e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(81550,user.getLanguage())%>",true); 
	}catch(e){}
    frmmain.ChinaExcel.SetUseDefaultPrinter(true);
    frmmain.ChinaExcel.PrintFile();
	try{
		setTimeout(function(){
			e8showAjaxTips("",false); 
			jQuery("#formcontent").show();
		},2000);
	}catch(e){}
}
function RefreshViewSize(){
	<%if(urm_printmode==1){%>
    //rightMenu.focus();
	    try {
		    rightMenu.focus();
	    }catch(e) {
	    }
    <%}%>
    for(r=0;r<rowgroup.length;r++){
        rhead=frmmain.ChinaExcel.GetCellUserStringValueRow("detail"+r+"_head");
        frmmain.ChinaExcel.SetRowHide(rhead,rhead+rowgroup[r],true);
    }
    frmmain.ChinaExcel.RefreshViewSize();
}        
function dosystemhead(){
    frmmain.ChinaExcel.ShowHeader =!frmmain.ChinaExcel.ShowHeader;
}
function gettotalheight(){
	var maxrow=frmmain.ChinaExcel.GetMaxRow();
	var totalheight=0;
	for(var i=1;i<=maxrow;i++){
		totalheight+=frmmain.ChinaExcel.GetRowSize(i,1);
	}
	return totalheight;
}
function gettotalwidth(){
    var maxcol=parent.requestiframe<%=requestid%>.frmmain.ChinaExcel.GetMaxCol();
    var totalwidth=0;
    for(var i=1;i<=maxcol;i++){
    	totalwidth += parent.requestiframe<%=requestid%>.frmmain.ChinaExcel.GetColSize(i,1);
    }
    return totalwidth;
}
function openWindow(urlLink){

  	window.open(urlLink);

}
function convertText() {
	var cx = frmmain.ChinaExcel;
	cx.FormProtect = false; 
	var maxRow = cx.GetMaxRow();
	for (var x=1; x<=maxRow; x++) {
		var cellpx = cx.GetRowSize(x, 1);
		if (cellpx >= 1000) {
			for (var y=1; y<=cx.getMaxCol(); y++) {
			    cx.SetCellProtect(x, y, x, y, false);
				cx.SetCellLargeTextType(x, x, y);
				cx.SetCellProtect(x, y, x, y, true);
				maxRow = cx.GetMaxRow();
			}
		}
	}
	cx.FormProtect = true; 
}

$(document).ready(function(){
	<%if(urm_printmode!=1){%>
	var htmls = "<div id='menuTable' name='menuTable' style=\"height: 24px; padding-right: 5px; padding-left: 5px;\" >"+
	"<div onclick=\"doPrint()\" style=\"float:left;border:1px;width:65px;padding-left:2px;vertical-align:middle;cursor:pointer;\">"+
	"<img align=\"absMiddle\" style=\"margin-top: 4px;\" src=\"/wui/theme/ecology8/skins/default/contextmenu/CM_icon3_wev8.png\" border=\"0\"/>"+
	"<span style=\"margin-top: 8px;\" title='<%=SystemEnv.getHtmlLabelName(257,user.getLanguage())%>'><%=SystemEnv.getHtmlLabelName(257,user.getLanguage())%></span>"+
	"</div>"+
	"<div onclick=\"doPrintPreview()\" style=\"float:left;border:1px;width:95px;vertical-align:middle;cursor:pointer;\">"+
	"<img align=\"absMiddle\" style=\"margin-top: 4px;\" src=\"/wui/theme/ecology8/skins/default/contextmenu/default/1_wev8.png\" border=\"0\"/>"+
	"<span style=\"margin-top: 8px;\" title='<%=SystemEnv.getHtmlLabelName(20757,user.getLanguage())%>'><%=SystemEnv.getHtmlLabelName(20757,user.getLanguage())%></span>"+
	"</div>"+
	"</div>";
	jQuery("#printdiv").html(htmls)
	<%}%>
});
</script>