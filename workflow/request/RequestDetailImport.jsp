
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.file.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RequestDetailImport" class="weaver.workflow.request.RequestDetailImport" scope="page"/>
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page"/>
<jsp:useBean id="FieldInfo2" class="weaver.workflow.mode.FieldInfo" scope="page"/>

<%@page import="weaver.fna.maintenance.FnaBudgetControl"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%><HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
    <script language=javascript>
	var dialog = parent.parent.getDialog(parent);
	var parentWin = parent.parent.getParentWindow(parent);

	function btn_cancle(){
		if (dialog) {
			dialog.close();
		} else {
			window.parent.close();
		}
	}

    function onSave(obj) {
        var fileName=$G("excelfile").value;
		if(fileName!=""&&fileName.length>4){
			if(fileName.substring(fileName.length-4).toLowerCase()!=".xls"){
				Dialog.alert('<%=SystemEnv.getHtmlLabelName(31460,user.getLanguage())%>');
				return;
			}
			$G("detailimportform").submit();//上传文件
            obj.disabled=true;
		}else{
            Dialog.alert('<%=SystemEnv.getHtmlLabelName(31460,user.getLanguage())%>');
        }
    }
</script>
</HEAD>
<body>
<%
ResourceComInfo rci = new ResourceComInfo();
DepartmentComInfo dci = new DepartmentComInfo();
SubCompanyComInfo scci = new SubCompanyComInfo();
HashMap<String, HashMap<String, String>> fccListHm = FnaCostCenter.getAllFnaCostCenterRecord();

String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid = user.getUID();
	int requestid = Util.getIntValue(request.getParameter("requestid"));
	int workflowid=Util.getIntValue((String)session.getAttribute(user.getUID()+"_"+requestid+"workflowid"),0);
	if(workflowid==0){
	workflowid =Util.getIntValue(request.getParameter("workflowid"));
	}
	String ismode="";
	int modeid=0;
	int nodeid = Util.getIntValue((String) session.getAttribute(user.getUID() + "_" + requestid + "nodeid"));
	String sql="select formid,isbill,workflowname,isImportDetail from workflow_base where isImportDetail<>3 and id=" + workflowid;
	RecordSet.executeSql(sql);
	boolean hasright = false;
	if (RecordSet.next()) {
		int isImportDetail = Util.getIntValue(RecordSet.getString("isImportDetail"), 0);
		hasright = RequestDetailImport.getImportRight(requestid, nodeid, user.getUID(), isImportDetail);
	}
	if(!hasright){
	    response.sendRedirect("/notice/noright.jsp");
	    return ;
	}
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(26255, user.getLanguage());
	String needfav = "";
	String needhelp = "";
	ExcelSheet es = null;
	String workflowname="";
	int formid=-1;
	int isbill=0;
	
	formid = RecordSet.getInt("formid");
	isbill = RecordSet.getInt("isbill");
	workflowname=RecordSet.getString("workflowname")+SystemEnv.getHtmlLabelName(64, user.getLanguage());
	ArrayList editfields=new ArrayList();
	int showdes=0;
	RecordSet.executeSql("select ismode,showdes,printdes,toexcel from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
	if (RecordSet.next()) {
	    ismode = Util.null2String(RecordSet.getString("ismode"));
	    showdes = Util.getIntValue(Util.null2String(RecordSet.getString("showdes")), 0);
	}
	if (ismode.equals("1") && showdes != 1) {
	    RecordSet.executeSql("select id from workflow_nodemode where isprint='0' and workflowid=" + workflowid + " and nodeid=" + nodeid);
	    if (RecordSet.next()) {
	        modeid = RecordSet.getInt("id");
	    } else {
	        RecordSet.executeSql("select id from workflow_formmode where isprint='0' and formid=" + formid + " and isbill='" + isbill + "'");
	        if (RecordSet.next()) {
	            modeid = RecordSet.getInt("id");
	        }
	    }
	}
	if(ismode.equals("1")&&modeid>0){
	    sql="select fieldid from workflow_modeview where isedit='1' and formid=" + formid+" and isbill="+isbill+" and nodeid="+nodeid;
	}else{
	    sql="select fieldid from workflow_nodeform where isedit='1' and nodeid="+nodeid;
	}
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
	    editfields.add("field"+RecordSet.getString("fieldid"));
	}

	FnaCommon fnaCommon = new FnaCommon();
	Hashtable otherPara_hs = new Hashtable();
	otherPara_hs.put("hrmid", user.getUID()+"");
	otherPara_hs.put("reqid", requestid+"");
	fnaCommon.loadWFLayoutToHtmlFnaInfo(formid, workflowid, requestid, otherPara_hs);
	HashMap<String, String> _isEnableFnaWfHm = (HashMap<String, String>)otherPara_hs.get("_isEnableFnaWfHm_FnaCommon.getIsEnableFnaWfHm_workflowid="+workflowid+"__requestId="+requestid);
	if(_isEnableFnaWfHm==null){
		_isEnableFnaWfHm = new HashMap<String, String>();
	}
	HashMap<String, String> fnaWfSetMap = (HashMap<String, String>)otherPara_hs.get("_isEnableFnaWfHm_fnaBudgetControl.getFnaWfFieldInfo4Expense_workflowid="+workflowid+"__requestId="+requestid);
	if(fnaWfSetMap==null){
		fnaWfSetMap = new HashMap<String, String>();
	}
	HashMap<String, HashMap<String, String>> reqDataMap = (HashMap<String, HashMap<String, String>>)otherPara_hs.get("_isEnableFnaWfHm_FnaCommon.qryFnaExpenseRequestRecord_workflowid="+workflowid+"__requestId="+requestid);
	if(reqDataMap==null){
		reqDataMap = new HashMap<String, HashMap<String, String>>();
	}
	String fnaWfType = fnaWfSetMap.get("fnaWfType");
	
	ExcelFile.init() ;
	ExcelFile.setFilename(workflowname) ;
	ExcelStyle ess = ExcelFile.newExcelStyle("Header") ;
	ess.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
	ess.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
	ess.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
	ess.setAlign(ExcelStyle.WeaverHeaderAlign) ;
	
	FieldInfo.setRequestid(requestid);
	FieldInfo.setUser(user);
	FieldInfo.GetDetailTableField(formid, isbill, user.getLanguage());
	FieldInfo2.setRequestid(requestid);
	FieldInfo2.setUser(user);
	FieldInfo2.GetDetailTblFields(formid, isbill, user.getLanguage());
	ArrayList detailtablefieldlables=FieldInfo.getDetailTableFieldNames();
	ArrayList detailtablefieldids=FieldInfo.getDetailTableFields();
	for(int i=0;i<detailtablefieldlables.size();i++){
	    es = new ExcelSheet() ;   // 初始化一个EXCEL的sheet对象
	    ExcelRow er = es.newExcelRow () ;  //准备新增EXCEL中的一行

	    ArrayList detailfieldnames=(ArrayList)detailtablefieldlables.get(i);
	    ArrayList detailfieldids=(ArrayList)detailtablefieldids.get(i);
	    boolean hasfield=false;
	    es.addColumnwidth(3000);
	    er.addStringValue(SystemEnv.getHtmlLabelName(15486, user.getLanguage()), "Header");
	    for(int j=0;j<detailfieldids.size();j++){
	        if(editfields.indexOf((String)Util.TokenizerString((String)detailfieldids.get(j),"_").get(0))<0) continue;
	        //以下为EXCEL添加多个列
	        String fieldArray[] = Util.TokenizerString2((String)detailfieldids.get(j),"_");
	        if("6".equals(fieldArray[3])){ //htmltype=6 
	            continue;
	        }

	        es.addColumnwidth(6000);
	        er.addStringValue((String)detailfieldnames.get(j),"Header");
	        hasfield=true;
	    }
	    if(hasfield){
	        es.addExcelRow(er) ;   //加入一行

	        for (int k = 0; k < FieldInfo2.getRowSize(i); k++) {
	        	er = es.newExcelRow() ;  //准备新增EXCEL中的一行

	        	es.addColumnwidth(3000);
	            er.addStringValue(k + 1 + "", "Border");
	        	for (int j=0;j<detailfieldids.size();j++) {
	            	if(editfields.indexOf((String)Util.TokenizerString((String)detailfieldids.get(j),"_").get(0))<0) continue;
	            	
	            	String fieldArray[] = Util.TokenizerString2((String)detailfieldids.get(j),"_");
			        if("6".equals(fieldArray[3])){ //htmltype=6 
			            continue;
			        }
	            	
	            	es.addColumnwidth(6000);
	            	String _addStringValue = FieldInfo2.getFieldExportCellValue(FieldInfo, i, k, j);
			        
	            	String _detailFieldId_full = "";
	            	int _detailFieldId = 0;
	            	String _detailDbFieldname = "";
	            	try{_detailFieldId_full = (String)detailfieldids.get(j);}catch(Exception ex1){}
	            	try{_detailFieldId = Util.getIntValue(_detailFieldId_full.split("_")[0].replaceAll("field", ""));}catch(Exception ex1){}
	            	try{_detailDbFieldname = (String)((List)FieldInfo.getDetailDBFieldNames().get(i)).get(j);}catch(Exception ex1){}
	            	_addStringValue = FnaCommon.getOrgNameByOrgType(_addStringValue, _detailFieldId, requestid, k, 
	    	            	fnaWfType, fnaWfSetMap, reqDataMap, otherPara_hs, 
	    	            	user.getLanguage(), rci, dci, scci, fccListHm);
	            	
	            	er.addStringValue(_addStringValue, "Border");
	            }
	        	es.addExcelRow(er) ;   //加入一行

	        }
	    	ExcelFile.addSheet(SystemEnv.getHtmlLabelName(17463, user.getLanguage())+(i+1), es) ; //为EXCEL文件插入一个SHEET
	    }
	}

%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    RCMenu += "{" + SystemEnv.getHtmlLabelName(26255, user.getLanguage()) + ",javascript:onSave(this),_self} ";
    RCMenuHeight += RCMenuHeightStep;

    RCMenu += "{" + SystemEnv.getHtmlLabelName(309, user.getLanguage()) + ",javascript:btn_cancle(),_self} ";
    RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=titlename %>"/>
</jsp:include>

<table id="topTitle" cellpadding="0" cellspacing="0">
    <tr>
        <td>
        </td>
        <td class="rightSearchSpan" style="text-align:right;">
            <input type="button" value="<%=SystemEnv.getHtmlLabelName(26255,user.getLanguage())%>" id="zd_btn_OK"  class="e8_btn_top" onclick="onSave(this)">
            <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
        </td>
    </tr>
</table>
<div style="width: 0px;height: 0px!important;">
<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
</div>
<form name="detailimportform" method="post" action="RequestDetailImportOperation.jsp" enctype="multipart/form-data">
<input type=hidden name="requestid" value="<%=requestid%>">
<input type=hidden name="ismode" value="<%=ismode%>">
<input type=hidden name="modeid" value="<%=modeid%>">
<input type=hidden name="formid" value="<%=formid%>">
<input type=hidden name="isbill" value="<%=isbill%>">
<input type=hidden name="nodeid" value="<%=nodeid%>">
<input type="hidden" value="save" name="src">
<input type="hidden" name="f_weaver_belongto_userid" value="<%=f_weaver_belongto_userid%>">
<input type="hidden" name="f_weaver_belongto_usertype" value="<%=request.getParameter("f_weaver_belongto_usertype") %>">
<wea:layout type="4col">
<wea:group context='<%=SystemEnv.getHtmlLabelName(258, user.getLanguage()) + "" + SystemEnv.getHtmlLabelName(64, user.getLanguage())%>'>
	<wea:item>
		1、<%=SystemEnv.getHtmlLabelName(258, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(64, user.getLanguage())%>
	</wea:item>
	<wea:item attributes="{'colspan':'3'}">
		<a href="/weaver/weaver.file.ExcelOut" style="color:blue;"><%=workflowname%></a>
	</wea:item>

	<wea:item>
		2、<%=SystemEnv.getHtmlLabelName(16630, user.getLanguage())%>
	</wea:item>
	<wea:item attributes="{'colspan':'3'}">
		<input type="file" name="excelfile" size="35">
	</wea:item>
</wea:group>

<wea:group context='<%=SystemEnv.getHtmlLabelName(27577, user.getLanguage())%>' attributes="{'itemAreaDisplay':'block'}">
	<wea:item attributes="{'colspan':'4'}">
		1）<%=SystemEnv.getHtmlLabelName(27578, user.getLanguage())%><a href="/weaver/weaver.file.ExcelOut" style="color:blue;"><%=workflowname%></a><%=SystemEnv.getHtmlLabelName(27579, user.getLanguage())%>
	</wea:item>
	<wea:item attributes="{'colspan':'4'}">
		2）<%=SystemEnv.getHtmlLabelName(27580, user.getLanguage())%>“<%=SystemEnv.getHtmlLabelName(26255, user.getLanguage())%>”。

	</wea:item>
</wea:group>
<wea:group context='<%=SystemEnv.getHtmlLabelName(27581, user.getLanguage())%>' attributes="{'itemAreaDisplay':'block'}">
	<wea:item attributes="{'colspan':'4'}">
		1）<%=SystemEnv.getHtmlLabelName(27582, user.getLanguage())%>
	</wea:item>
	<wea:item attributes="{'colspan':'4'}">
		2）<%=SystemEnv.getHtmlLabelName(27583, user.getLanguage())%>
	</wea:item>
	<wea:item attributes="{'colspan':'4'}">
		3）<%=SystemEnv.getHtmlLabelName(27584, user.getLanguage())%>
	</wea:item>
	<wea:item attributes="{'colspan':'4'}">
		4）<%=SystemEnv.getHtmlLabelName(27585, user.getLanguage())%>
	</wea:item>
	<wea:item attributes="{'colspan':'4'}">
		5）<%=SystemEnv.getHtmlLabelName(27586, user.getLanguage())%>
	</wea:item>
	<wea:item attributes="{'colspan':'4'}">
		6）<%=SystemEnv.getHtmlLabelName(27587, user.getLanguage())%>
	</wea:item>
	<wea:item attributes="{'colspan':'4'}">
		7）<%=SystemEnv.getHtmlLabelName(27588, user.getLanguage())%>
	</wea:item>
	<wea:item attributes="{'colspan':'4'}">
		8）<%=SystemEnv.getHtmlLabelName(27589, user.getLanguage())%>
	</wea:item>
	<wea:item attributes="{'colspan':'4'}">
		9）<%=SystemEnv.getHtmlLabelName(27590, user.getLanguage())%>
	</wea:item>
	<wea:item attributes="{'colspan':'4'}">
		10）<%=SystemEnv.getHtmlLabelName(27635, user.getLanguage())%>
	</wea:item>
</wea:group>
</wea:layout>

</form>
</div>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
            <wea:item type="toolbar">
                <input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="btn_cancle()">
            </wea:item>
		</wea:group>
	</wea:layout>
</div>

</body>
</html>
