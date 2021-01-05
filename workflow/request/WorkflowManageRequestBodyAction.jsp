<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.browserData.BrowserManager"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.formmode.tree.CustomTreeUtil"%>
<%@page import="weaver.formmode.tree.CustomTreeData"%>
<%@page import="weaver.workflow.field.FileElement"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.workflow.datainput.DynamicDataInput"%>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="weaver.system.code.CodeBuild" %>
<%@ page import="weaver.system.code.CoderBean" %>
<%@ page import="weaver.workflow.request.WFFreeFlowManager"%>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.hrm.attendance.domain.*"%>
<jsp:useBean id="workflowJspBean" class="weaver.workflow.request.WorkflowJspBean" scope="page"/>
<%@ page import="weaver.workflow.request.RequestConstants" %>
<%@ page import="weaver.general.LocateUtil" %>
<jsp:useBean id="SpecialField" class="weaver.workflow.field.SpecialFieldInfo" scope="page" />
<jsp:useBean id="rsfgs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="mrci" class="weaver.meeting.Maint.MeetingRoomComInfo" scope="page" />
<jsp:useBean id="MeetingBrowser" class="weaver.meeting.MeetingBrowser" scope="page" />
<%
	HashMap specialfield = SpecialField.getFormSpecialField();//特殊字段的字段信息





%>
<jsp:useBean id="rs_item" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rscount" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DocUtil" class="weaver.docs.docs.DocUtil" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSet_nf1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsaddop" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet_nf2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo1" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo1" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="deptVirComInfo" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo1" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="subCompVirComInfo" class="weaver.hrm.companyvirtual.SubCompanyVirtualComInfo" scope="page"/>
<jsp:useBean id="DocComInfo1" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo1" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="WorkflowRequestComInfo1" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page"/>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="ResourceConditionManager" class="weaver.workflow.request.ResourceConditionManager" scope="page"/>
<jsp:useBean id="flowDoc1" class="weaver.workflow.request.RequestDoc" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="WfLinkageInfo" class="weaver.workflow.workflow.WfLinkageInfo" scope="page"/>
<jsp:useBean id="WFNodeFieldMainManager" class="weaver.workflow.workflow.WFNodeFieldMainManager" scope="page" />
<jsp:useBean id="DocReceiveUnitComInfo" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/>
<jsp:useBean id="docReceiveUnitComInfo_mba" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/>
<jsp:useBean id="leaveTypeColorManager" class="weaver.hrm.attendance.manager.HrmLeaveTypeColorManager" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page"/>

<!-- 
<script type="text/javascript" language="javascript" src="/FCKEditor/fckeditor_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt_wev8.js"></script>
 -->
<!-- browser 相关 -->
<script type="text/javascript" src="/js/workflow/wfbrow_wev8.js"></script>
<script type='text/javascript' src="/js/ecology8/request/autoSelect_wev8.js"></script>
<link type="text/css" href="/js/ecology8/base/jquery-ui_wev8.css" rel=stylesheet>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript" src="/js/jquery-autocomplete/jquery.autocomplete_wev8.js"></script>
<script type="text/javascript">
window.__userid = '<%=request.getParameter("f_weaver_belongto_userid")%>';
window.__usertype = '<%=request.getParameter("f_weaver_belongto_usertype")%>';
</script>

<%
	//FileUpload fu = new FileUpload(request);
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
session.setAttribute("f_weaver_belongto_userid",f_weaver_belongto_userid);
session.setAttribute("f_weaver_belongto_usertype",f_weaver_belongto_usertype);
User user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
String userid = ""+user.getUID();
int usertype = 0;
	String selectInitJsStr = "";
	String initIframeStr = "";
	char flag = Util.getSeparator();
	String docfileid = Util.null2String(request
			.getParameter("docfileid")); // 新建文档的工作流字段

	String topage = Util.null2String(request.getParameter("topage"));
	String newfromdate = "a";
	String newenddate = "b";
	int requestid = Util.getIntValue(request.getParameter("requestid"),
			0);
	String nodetype = Util
			.null2String(request.getParameter("nodetype"));
	int isremark = Util
			.getIntValue(request.getParameter("isremark"), 0); //当前操作状态





	//String userid = Util.null2String(request.getParameter("userid"));
	String needcheck = Util.null2String(request
			.getParameter("needcheck"));

	String workflowtype = Util.null2String(request
			.getParameter("workflowtype"));

	int workflowid = Util.getIntValue(request
			.getParameter("workflowid"));
	String workflowname = Util.null2String((String) session
			.getAttribute(userid + "_" + requestid + "workflowname"));//update by fanggsh 20060509 TD4294
	String fromFlowDoc = Util.null2String(request
			.getParameter("fromFlowDoc")); //是否从流程创建文档而来
	int languageidfromrequest = Util.getIntValue(request
			.getParameter("languageid"));

	boolean canactive = Util.null2String(
			request.getParameter("canactive")).equalsIgnoreCase("true");
	int deleted = Util.getIntValue(request.getParameter("deleted"), 0); //请求是否删除  1:是 0或者其它 否





	int nodeid = Util.getIntValue(request.getParameter("nodeid"), 0);
	String sql = "";
	String bodychangattrstr = "";

	//String requestname = Util.null2String(request.getParameter("requestname"));//update by fanggsh 20060509 TD4294
	String requestname = Util.null2String((String) session
			.getAttribute(userid + "_" + requestid + "requestname"));//update by fanggsh 20060509 TD4294
	String requestlevel = Util.null2String(request
			.getParameter("requestlevel"));

	String isbill = Util.null2String(request.getParameter("isbill"));
	int billid = Util.getIntValue(request.getParameter("billid"), 0);

	int formid = Util.getIntValue(request.getParameter("formid"), 0);

	boolean isprint = Util.null2String(request.getParameter("isprint"))
			.equalsIgnoreCase("true");
	boolean isurger = Util.null2String(request.getParameter("isurger"))
			.equalsIgnoreCase("true");
	boolean wfmonitor = Util.null2String(
			request.getParameter("wfmonitor")).equalsIgnoreCase("true");
	String isrequest = Util.null2String(request
			.getParameter("isrequest"));

	ArrayList flowDocs = flowDoc1.getDocFiled("" + workflowid); //得到流程建文挡的发文号字段





	String codeField = "";
	String flowCat="";
	if (flowDocs != null && flowDocs.size() > 0) {
		codeField = "" + flowDocs.get(0);
		flowCat=""+flowDocs.get(3);	//取得流程中“显示目录”字段ID	
	}
	String docFlags = Util.null2String((String) session
			.getAttribute("requestAdd" + requestid));
	String newTNflag = Util.null2String((String) session
			.getAttribute("requestAddNewNodes" + user.getUID()));
	String flowDocField = Util.null2String((String) session
			.getAttribute("requestFlowDocField" + user.getUID()));
	ArrayList managefckfields_body = new ArrayList();
	if (docFlags.equals(""))
		docFlags = Util.null2String((String) session
				.getAttribute("requestAdd" + user.getUID()));
%>
<!--请求的标题开始 -->
<div align="center" style="background:#fff;margin-bottom:4px;">
<font style="font-size:14pt;FONT-WEIGHT: bold"><%=Util.toScreen(workflowname, user.getLanguage())%></font>
</div>
<title><%=Util.toScreen(workflowname, user.getLanguage())%></title>

<!--请求的标题结束 -->
<%
	int creater = Util.getIntValue(request.getParameter("creater"), 0);
	int creatertype = Util.getIntValue(request
			.getParameter("creatertype"), 0);
	String currentdate = Util.null2String(request
			.getParameter("currentdate"));
	String currenttime = Util.null2String(request
			.getParameter("currenttime"));

	CodeBuild cbuild = new CodeBuild(formid, isbill, workflowid,
			creater, creatertype);
	CoderBean cb = cbuild.getFlowCBuild();
	String isUse = cb.getUserUse(); //是否使用流程编号
	String fieldCode = Util.null2String(cb.getCodeFieldId());
	ArrayList memberList = cb.getMemberList();
	
	//判断是否是E8新版保存
    boolean isE8Save = false;
    String E8sql = "select 1 from workflow_codeRegulate where concreteField  = '8' "+
		 " and ((formId="+formid+" and isBill='"+isbill+"') or workflowId="+workflowid+" ) ";
    RecordSet.execute(E8sql);
    if(RecordSet.next()){
	  isE8Save = true;
    }
    //end
	
	boolean hasHistoryCode = cbuild.hasHistoryCode(RecordSet_nf2,
			workflowid);
	String fieldIdSelect = "";
	String departmentFieldId = "";
	String subCompanyFieldId = "";
	String supSubCompanyFieldId = "";
	String yearFieldId = "";
	String yearFieldHtmlType = "";
	String monthFieldId = "";
	String dateFieldId = "";
	if(!isE8Save){//E8前





		for (int i = 0; i < memberList.size(); i++) {
			String[] codeMembers = (String[]) memberList.get(i);
			String codeMemberName = codeMembers[0];
			String codeMemberValue = codeMembers[1];
			if ("22755".equals(codeMemberName)) {
				fieldIdSelect = String.valueOf(Util.getIntValue(codeMemberValue, -1));
			} else if ("22753".equals(codeMemberName)) {
				supSubCompanyFieldId = String.valueOf(Util.getIntValue(codeMemberValue, -1));
			} else if ("141".equals(codeMemberName)) {
				subCompanyFieldId = String.valueOf(Util.getIntValue(codeMemberValue, -1));
			} else if ("124".equals(codeMemberName)) {
				departmentFieldId = String.valueOf(Util.getIntValue(codeMemberValue, -1));
			} else if ("445".equals(codeMemberName)) {
				yearFieldId = String.valueOf(Util.getIntValue(codeMemberValue, -1));
			} else if ("6076".equals(codeMemberName)) {
				monthFieldId = String.valueOf(Util.getIntValue(codeMemberValue, -1));
			} else if ("390".equals(codeMemberName)
					|| "16889".equals(codeMemberName)) {
				dateFieldId = String.valueOf(Util.getIntValue(codeMemberValue, -1));
			}
		}
	}else{//E8
		int strindex = 1;//字符串字段





		int selectindex = 1;//选择框字段





		int deptindex = 1;//部门字段
		int subindex = 1;//分部字段
		int supsubindex = 1;//上级分部字段
		int yindex = 1;//年字段





		int mindex = 1;//月字段





		int dindex = 1;//日字段





		for (int i=0;i<memberList.size();i++){
			String[] codeMembers = (String[])memberList.get(i);
			String codeMemberName = codeMembers[0];
			String codeMemberValue = codeMembers[1];
			String codeMemberType = codeMembers[2];

            String concreteField = "";
            String enablecode = "";
            //防止旧版流程导入时报错的问题
			if(codeMembers.length >= 5){
	            concreteField = codeMembers[3];
	            enablecode = codeMembers[4];
			}
			if(codeMemberType.equals("5") && concreteField.equals("0")){
				if("".equals(fieldIdSelect)){
					fieldIdSelect = String.valueOf(Util.getIntValue(codeMemberValue, -1));
				}else{
					fieldIdSelect += "~~wfcode~~"+String.valueOf(Util.getIntValue(codeMemberValue, -1));
				}
			}else if(codeMemberType.equals("5") && concreteField.equals("1")){
				if("".equals(departmentFieldId)){
					departmentFieldId = String.valueOf(Util.getIntValue(codeMemberValue, -1));
				}else{
					departmentFieldId += "~~wfcode~~"+String.valueOf(Util.getIntValue(codeMemberValue, -1));
				}
				//departmentFieldId = Util.getIntValue(codeMemberValue, -1);
			}else if(codeMemberType.equals("5") && concreteField.equals("2")){
				if("".equals(subCompanyFieldId)){
					subCompanyFieldId = String.valueOf(Util.getIntValue(codeMemberValue, -1));
				}else{
					subCompanyFieldId += "~~wfcode~~"+String.valueOf(Util.getIntValue(codeMemberValue, -1));
				}
				//subCompanyFieldId = Util.getIntValue(codeMemberValue, -1);
			}else if(codeMemberType.equals("5") && concreteField.equals("3")){
				if("".equals(supSubCompanyFieldId)){
					supSubCompanyFieldId = String.valueOf(Util.getIntValue(codeMemberValue, -1));
				}else{
					supSubCompanyFieldId += "~~wfcode~~"+String.valueOf(Util.getIntValue(codeMemberValue, -1));
				}
				//supSubCompanyFieldId = Util.getIntValue(codeMemberValue, -1);
			}else if(codeMemberType.equals("5") && concreteField.equals("4")){
				if("".equals(yearFieldId)){
					yearFieldId = String.valueOf(Util.getIntValue(codeMemberValue, -1));
				}else{
					yearFieldId += "~~wfcode~~"+String.valueOf(Util.getIntValue(codeMemberValue, -1));
				}
				//yearFieldId = Util.getIntValue(codeMemberValue, -1);
			}else if(codeMemberType.equals("5") && concreteField.equals("5")){
				if("".equals(monthFieldId)){
					monthFieldId = String.valueOf(Util.getIntValue(codeMemberValue, -1));
				}else{
					monthFieldId += "~~wfcode~~"+String.valueOf(Util.getIntValue(codeMemberValue, -1));
				}
				//monthFieldId = Util.getIntValue(codeMemberValue, -1);
			}else if(codeMemberType.equals("5") && concreteField.equals("6")){
				if("".equals(dateFieldId)){
					dateFieldId = String.valueOf(Util.getIntValue(codeMemberValue, -1));
				}else{
					dateFieldId += "~~wfcode~~"+String.valueOf(Util.getIntValue(codeMemberValue, -1));
				}
				//dateFieldId = Util.getIntValue(codeMemberValue, -1);
			}
		}
	}
%>

<iframe id="selectChange" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="datainputform" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="workflowKeywordIframe" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<input type="hidden" name="htmlfieldids">


<%
	String isaffirmancebody = Util.null2String((String) session
			.getAttribute(user.getUID() + "_" + requestid
					+ "isaffirmance"));//是否需要提交确认





	String reEditbody = Util.null2String((String) session
			.getAttribute(user.getUID() + "_" + requestid + "reEdit"));//是否需要提交确认





	int rqMessageType = -1;
	int wfMessageType = -1;
	int rqchatstype = -1;//微信提醒(QC:98106)
	int wfChatsType = -1;//微信提醒(QC:98106)
	String docCategory = "";
    int hrmResourceShow = 0;
	//String sqlWfMessage = "select a.messagetype,b.docCategory from workflow_requestbase a,workflow_base b where a.workflowid=b.id and a.requestid="+requestid ;
    String sqlWfMessage = "select a.messagetype,a.chatstype,b.chatstype as wfChatsType,b.docCategory,b.messagetype as wfMessageType,b.hrmResourceShow from workflow_requestbase a,workflow_base b where a.workflowid=b.id and a.requestid="
			+ requestid;
	RecordSet.executeSql(sqlWfMessage);
	if (RecordSet.next()) {
        hrmResourceShow = RecordSet.getInt("hrmResourceShow");
		rqchatstype = RecordSet.getInt("chatstype");//微信提醒(QC:98106)
	    wfChatsType = RecordSet.getInt("wfChatsType");//微信提醒(QC:98106)
		rqMessageType = RecordSet.getInt("messagetype");
		wfMessageType = RecordSet.getInt("wfMessageType");
		docCategory = RecordSet.getString("docCategory");
	}
	Map secCategorys = new HashMap();
	secCategorys.put("", docCategory);
	Map secMaxUploads = new HashMap();//封装选择目录的信息





	int secid = Util.getIntValue(docCategory.substring(docCategory
			.lastIndexOf(",") + 1), -1);
	int maxUploadImageSize = Util.getIntValue(SecCategoryComInfo1
			.getMaxUploadFileSize("" + secid), 5); //从缓存中取





	if (maxUploadImageSize <= 0) {
		maxUploadImageSize = 5;
	}
	secMaxUploads.put("", maxUploadImageSize + "");
	int uploadType = 0;
	String selectedfieldid = "";
	String result = RequestManager.getUpLoadTypeForSelect(workflowid);
	if (!result.equals("")) {
		selectedfieldid = result.substring(0, result.indexOf(","));
		uploadType = Integer.valueOf(
				result.substring(result.indexOf(",") + 1)).intValue();
	}
	boolean isCanuse = RequestManager.hasUsedType(workflowid);
	if (selectedfieldid.equals("") || selectedfieldid.equals("0")) {
		isCanuse = false;
	}
	//如果附件存放方式为选择目录，则重置默认值





	if (uploadType == 1) {
		maxUploadImageSize = 5;
	}
 if(isCanuse&&uploadType==1){
				String fieldName="";//字段名称
				String fieldValue="";//字段的值





				String tableName="workflow_form";
				if(isbill.equals("0")){//如果不为单据，即为表单





					sql=" select fieldName,fieldHtmlType,type from workflow_formdict where id="+selectedfieldid;
				}else{//否则为单据





					rs.executeSql(" select tableName from workflow_bill where id="+formid);
					if(rs.next()){
						tableName=rs.getString(1);
					}
					sql=" select fieldName,fieldHtmlType,type from workflow_billfield where (viewtype is null or viewtype<>1) and id= "+selectedfieldid;
				}
				rs.executeSql(sql);
				if(rs.next()){
					fieldName=rs.getString(1);
				}
				
				if(fieldName!=null&&!(fieldName.trim().equals(""))
				 &&tableName!=null&&!(tableName.trim().equals(""))){			
					rs.executeSql(" select "+fieldName+" from "+tableName+" where requestid= "+requestid);			
					if(rs.next()){
						fieldValue=Util.null2String(rs.getString(1));
					}
				}			
				rs.executeProc("workflow_SelectItemSelectByid", ""+selectedfieldid+flag+isbill);
				while(rs.next()){
					String tmpselectvalue = Util.null2String(rs.getString("selectvalue"));
					String isdefault = Util.null2String(rs.getString("isdefault"));
					String tdocCategory = Util.null2String(rs.getString("docCategory"));
					
					int tsecid = Util.getIntValue(tdocCategory.substring(tdocCategory.lastIndexOf(",")+1),-1);
					String tMaxUploadFileSize = ""+Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+tsecid),-1);
                    
					if(!"".equals(tdocCategory)&&(("y".equals(isdefault)&&fieldValue.trim().equals(""))||tmpselectvalue.equals(fieldValue))){
						maxUploadImageSize = Util.getIntValue(tMaxUploadFileSize,5);
						docCategory = tdocCategory;
					}
				}
 }
	
	String keywordismand = "0";
	String keywordisedit = "0";
	int titleFieldId = 0;
	int keywordFieldId = 0;
	String canDelAcc = "";
	String forbidAttDownload="";
	RecordSet
			.execute("select titleFieldId,keywordFieldId,candelacc,forbidAttDownload from workflow_base where id="
					+ workflowid);
	if (RecordSet.next()) {
		titleFieldId = Util.getIntValue(RecordSet
				.getString("titleFieldId"), 0);
		keywordFieldId = Util.getIntValue(RecordSet
				.getString("keywordFieldId"), 0);
		canDelAcc = Util.null2String(RecordSet.getString("candelacc"));
		forbidAttDownload = Util.null2String(RecordSet.getString("forbidAttDownload"));
	}
	ArrayList selfieldsadd = WfLinkageInfo.getSelectField(workflowid,
			nodeid, 0);
	ArrayList changefieldsadd = WfLinkageInfo.getChangeField(
			workflowid, nodeid, 0);
	
	ArrayList uploadfieldids = new ArrayList();
	

 String selectfieldlable = "";
 String selectfieldvalue = "";
 
 if(uploadType==1 && !"".equals(selectedfieldid.trim())){
 	 String selectfieldsql = "";
	 if(isbill.equals("1")){
		 selectfieldsql = "SELECT bf.fieldlabel,bf.fieldname,b.tablename FROM workflow_billfield bf,workflow_bill b WHERE b.id=bf.billid AND bf.id="+selectedfieldid;
	 }else{
	 	 selectfieldsql = "select fl.fieldlable,fd.fieldname,'workflow_form' AS tablename  FROM workflow_fieldlable fl,workflow_formdict fd WHERE fl.fieldid=fd.id and fl.fieldid="+selectedfieldid+" AND fl.langurageid="+user.getLanguage()+" AND fl.formid="+formid;
	 }
 	 RecordSet.executeSql(selectfieldsql);
 	 if(RecordSet.next()){
 	    String _fieldlabel = RecordSet.getString(1);
 	    String _fieldname = RecordSet.getString("fieldname");
 	    String _tablename = RecordSet.getString("tablename");
 		if(isbill.equals("1")){
 			selectfieldlable = SystemEnv.getHtmlLabelName(Util.getIntValue(_fieldlabel),user.getLanguage());
 		}else{
 			selectfieldlable = _fieldlabel;
 		}
 		RecordSet.executeSql("select "+_fieldname+" from "+_tablename+" where requestid="+requestid);
 		if(RecordSet.next()){
 		  	selectfieldvalue = RecordSet.getString(1).trim();
 		}
 	 }
 }
String isTextInForm = "";
RecordSet.executeSql("select * from workflow_createdoc where workflowid="+workflowid);	
 		if(RecordSet.next()){
 		  	isTextInForm = RecordSet.getString("isTextInForm");
 		}
%>
<input type=hidden name ="uploadType" id="uploadType" value="<%=uploadType %>">
<input type=hidden name ="selectfieldvalue" id="selectfieldvalue" value="<%=selectfieldvalue %>">

<table class="ViewForm">
  <colgroup>
  <col width="20%">
  <col width="80%">

  <%
  	//xwj for td1834 on 2005-05-22
  	String isEdit_ = "-1";
  	RecordSet
  			.executeSql("select isedit from workflow_nodeform where nodeid = "
  					+ String.valueOf(nodeid) + " and fieldid = -1");
  	if (RecordSet.next()) {
  		isEdit_ = Util.null2String(RecordSet.getString("isedit"));
  	}

  	//获得触发字段名 mackjoe 2005-07-22
  	DynamicDataInput ddi = new DynamicDataInput(workflowid + "");
  	String trrigerfield = ddi.GetEntryTriggerFieldName();
  %>

  <!--新建的第一行，包括说明和重要性 -->
  <tr class="Spacing" style="height:1px;">
    <td class="Line1" colSpan=2></td>
  </tr>
  <%
  	boolean editflag = true;//流程的处理人可以编辑流程的优先级和是否短信提醒





  	boolean IsCanModify_1="true".equals(session.getAttribute(userid+"_"+requestid+"IsCanModify"))?true:false;
  	if (isremark == 8 || isremark == 9|| ((isremark == 1 || isremark == 7) && IsCanModify_1==false ))
  		editflag = false;//被抄送人不能编辑
  	String requestlevel_disabled = "disabled";

  	WFNodeFieldMainManager.resetParameter();
  	WFNodeFieldMainManager.setNodeid(nodeid);
  	WFNodeFieldMainManager.setFieldid(-2);//"紧急程度"字段在workflow_nodeform中的fieldid 定为 "-2"
  	WFNodeFieldMainManager.selectWfNodeField();
  	if (WFNodeFieldMainManager.getIsedit().equals("1")
  			|| "0".equals(nodetype))
  		requestlevel_disabled = "";
  	WFNodeFieldMainManager.closeStatement();

  	String messageType_disabled = "disabled";
  	WFNodeFieldMainManager.resetParameter();
  	WFNodeFieldMainManager.setNodeid(nodeid);
  	WFNodeFieldMainManager.setFieldid(-3);//"是否短信提醒"字段在workflow_nodeform中的fieldid 定为 "-3"
  	WFNodeFieldMainManager.selectWfNodeField();
  	if (WFNodeFieldMainManager.getIsedit().equals("1")
  			|| "0".equals(nodetype))
  		messageType_disabled = "";
  	//微信提醒(QC:98106)
  	String chatsType_disabled = "disabled";
  	WFNodeFieldMainManager.resetParameter();
  	WFNodeFieldMainManager.setNodeid(nodeid);
  	WFNodeFieldMainManager.setFieldid(-5);//"是否微信提醒"字段在workflow_nodeform中的fieldid 定为 "-5"
  	WFNodeFieldMainManager.selectWfNodeField();
  	if (WFNodeFieldMainManager.getIsedit().equals("1"))
  		chatsType_disabled = "";
  	//微信提醒(QC:98106)
  %>

<jsp:include page="WorkflowManageRequestBodyActionTitle.jsp" flush="true">
    <jsp:param name="requestid" value="<%=requestid%>" />
    <jsp:param name="nodeid" value="<%=nodeid%>" />
    <jsp:param name="editflag" value="<%=editflag%>" />
    <jsp:param name="nodetype" value="<%=nodetype%>" />
	<jsp:param name="isaffirmancebody" value="<%=isaffirmancebody%>" />
	<jsp:param name="reEditbody" value="<%=reEditbody%>" />
	<jsp:param name="isEdit_" value="<%=isEdit_%>" />
	<jsp:param name="rqMessageType" value="<%=rqMessageType%>" />
	<jsp:param name="messageType_disabled" value="<%=messageType_disabled%>" />
	<jsp:param name="rqchatsType" value="<%=rqchatstype%>" />
	<jsp:param name="wfChatsType" value="<%=wfChatsType%>" />
	<jsp:param name="chatsType_disabled" value="<%=chatsType_disabled%>" />
	<jsp:param name="wfMessageType" value="<%=wfMessageType%>" />
	<jsp:param name="requestlevel" value="<%=requestlevel%>" />
	<jsp:param name="requestlevel_disabled" value="<%=requestlevel_disabled%>" />
	<jsp:param name="RequestName_Size" value="<%=RequestConstants.RequestName_Size%>" />
	<jsp:param name="RequestName_MaxLength" value="<%=RequestConstants.RequestName_MaxLength%>" />
</jsp:include>

<%
	boolean IsCanModify = "true".equals(session.getAttribute(userid
			+ "_" + requestid + "IsCanModify")) ? true : false;
	boolean editbodyactionflag = false;
	if ((isremark == 0 || IsCanModify)
			&& (!isaffirmancebody.equals("1") || !nodetype.equals("0") || reEditbody
					.equals("1")))
		editbodyactionflag = true;
	//查询表单或者单据的字段,字段的名称，字段的HTML类型和字段的类型（基于HTML类型的一个扩展）
	String newdocid = Util.null2String((String) session
			.getAttribute(userid + "_" + requestid + "newdocid"));
	ArrayList fieldids = new ArrayList(); //字段队列
	ArrayList fieldorders = new ArrayList(); //字段显示顺序队列 (单据文件不需要)
	ArrayList languageids = new ArrayList(); //字段显示的语言(单据文件不需要)
	ArrayList fieldlabels = new ArrayList(); //单据的字段的label队列
	ArrayList fieldhtmltypes = new ArrayList(); //单据的字段的html type队列
	ArrayList fieldtypes = new ArrayList(); //单据的字段的type队列
	ArrayList fieldnames = new ArrayList(); //单据的字段的表字段名队列
	ArrayList fieldvalues = new ArrayList(); //字段的值





	ArrayList fieldqfws = new ArrayList(); //字段的值





	ArrayList fieldviewtypes = new ArrayList(); //单据是否是detail表的字段1:是 0:否(如果是,将不显示)
	ArrayList fieldimgwidths = new ArrayList();
	ArrayList fieldimgheights = new ArrayList();
	ArrayList fieldimgnums = new ArrayList();
	int fieldlen = 0; //字段类型长度
	ArrayList fieldrealtype = new ArrayList();
	String fielddbtype = ""; //字段数据类型
	String textheight = "4";//xwj for @td2977 20051111
 
	if (isbill.equals("0")) {
		RecordSet
				.executeSql("select t2.fieldid,t2.fieldorder,t1.fieldlable,t1.langurageid from workflow_fieldlable t1,workflow_formfield t2 where t1.formid=t2.formid and t1.fieldid=t2.fieldid and (t2.isdetail<>'1' or t2.isdetail is null) and   t1.langurageid="
						+ user.getLanguage()
						+ " and t2.formid="
						+ formid + " order by t2.fieldorder");
		while (RecordSet.next()) {
			fieldids.add(Util.null2String(RecordSet
					.getString("fieldid")));
			fieldorders.add(Util.null2String(RecordSet
					.getString("fieldorder")));
			fieldlabels.add(Util.null2String(RecordSet
					.getString("fieldlable")));
			languageids.add(Util.null2String(RecordSet
					.getString("langurageid")));
		}
	} else {
		RecordSet.executeProc("workflow_billfield_Select", formid + "");
		while (RecordSet.next()) {
			fieldids.add(Util.null2String(RecordSet.getString("id")));
			fieldlabels.add(Util.null2String(RecordSet
					.getString("fieldlabel")));
			fieldhtmltypes.add(Util.null2String(RecordSet
					.getString("fieldhtmltype")));
			fieldtypes.add(Util
					.null2String(RecordSet.getString("type")));
			fieldnames.add(Util.null2String(RecordSet
					.getString("fieldname")));
			fieldviewtypes.add(Util.null2String(RecordSet
					.getString("viewtype")));
			fieldrealtype.add(Util.null2String(RecordSet
					.getString("fielddbtype")));
			fieldimgwidths.add(Util.null2String(RecordSet
					.getString("imgwidth")));
			fieldimgheights.add(Util.null2String(RecordSet
					.getString("imgheight")));
			fieldimgnums.add(Util.null2String(RecordSet
					.getString("textheight")));
		 fieldqfws.add(Util.null2String(RecordSet.getString("qfws")));
		}
	}

	// 查询每一个字段的值





	if (!isbill.equals("1")) {
		RecordSet.executeProc("workflow_FieldValue_Select", requestid
				+ ""); // 从workflow_form表中查





		RecordSet.next();
		for (int i = 0; i < fieldids.size(); i++) {
			String fieldname = FieldComInfo
					.getFieldname((String) fieldids.get(i));
			fieldvalues.add(Util.null2String(RecordSet
					.getString(fieldname)));
		}
	} else {
		RecordSet
				.executeSql("select tablename from workflow_bill where id = "
						+ formid); // 查询工作流单据表的信息





		RecordSet.next();
		String tablename = RecordSet.getString("tablename");
		RecordSet.executeSql("select * from " + tablename
				+ " where id = " + billid); // 对于默认的单据表,必须以id作为自增长的Primary key, billid的值就是id. 如果不是,则需要改写这个部分. 另外,默认的单据表必须有 requestid 的字段






		RecordSet.next();
		for (int i = 0; i < fieldids.size(); i++) {
			String fieldname = (String) fieldnames.get(i);
			fieldvalues.add(Util.null2String(RecordSet
					.getString(fieldname)));
		}
	}

	// 确定字段是否显示，是否可以编辑，是否必须输入
	ArrayList isfieldids = new ArrayList(); //字段队列
	ArrayList isviews = new ArrayList(); //字段是否显示队列
	ArrayList isedits = new ArrayList(); //字段是否可以编辑队列
	ArrayList ismands = new ArrayList(); //字段是否必须输入队列
 
	
	RecordSet.executeProc("workflow_FieldForm_Select", nodeid + "");
	while (RecordSet.next()) {
		isfieldids
				.add(Util.null2String(RecordSet.getString("fieldid")));
		isviews.add(Util.null2String(RecordSet.getString("isview")));
		isedits.add(Util.null2String(RecordSet.getString("isedit")));
		ismands.add(Util
				.null2String(RecordSet.getString("ismandatory")));
	}

	String beagenter = "" + userid;
	//获得被代理人
	RecordSet
			.executeSql("select agentorbyagentid from workflow_currentoperator where usertype=0 and isremark='0' and requestid="
					+ requestid
					+ " and userid="
					+ userid
					+ " and nodeid=" + nodeid + " order by id desc");
	if (RecordSet.next()) {
		int tembeagenter = RecordSet.getInt(1);
		if (tembeagenter > 0)
			beagenter = "" + tembeagenter;
	}
	session.removeAttribute("beagenter_"+user.getUID());
	session.setAttribute("beagenter_"+user.getUID(), beagenter);
	// 得到每个字段的信息并在页面显示






	for (int i = 0; i < fieldids.size(); i++) { // 循环开始





		int tmpindex = i;
		if (isbill.equals("0"))
			tmpindex = fieldorders.indexOf("" + i); // 如果是表单, 得到表单顺序对应的 i

		String fieldid = (String) fieldids.get(tmpindex); //字段id

		if (isbill.equals("1")) {
			String viewtype = (String) fieldviewtypes.get(tmpindex); // 如果是单据的从表字段,不显示





			if (viewtype.equals("1"))
				continue;
		}

		String isview = "0"; //字段是否显示
		String isedit = "0"; //字段是否可以编辑
		String ismand = "0"; //字段是否必须输入
		int qfws=0;
		int isfieldidindex = isfieldids.indexOf(fieldid);
		if (isfieldidindex != -1) {
			isview = (String) isviews.get(isfieldidindex); //字段是否显示
			isedit = (String) isedits.get(isfieldidindex); //字段是否可以编辑
			ismand = (String) ismands.get(isfieldidindex); //字段是否必须输入
		}
		if (isremark == 5 || isremark == 9) {
			isedit = "0";//抄送(需提交)不可编辑
			ismand = "0";
		}

		//当自由流程设置当前节点的表单不可以编辑时，则全部表单字段都禁止编辑





		if( !WFFreeFlowManager.allowFormEdit(requestid, nodeid) ){
		    isedit = "0";
		}
		
		String bclick="";
		String isbrowisMust = "";
		
		if ("1".equals(isedit)) {
	        isbrowisMust = "1";
	    }
	    
	    if ("1".equals(ismand)) {
	        isbrowisMust = "2";
	    }


		String fieldname = ""; //字段数据库表中的字段名





		String fieldhtmltype = ""; //字段的页面类型





		String fieldtype = ""; //字段的类型





		String fieldlable = ""; //字段显示名





		int fieldimgwidth = 0; //图片字段宽度
		int fieldimgheight = 0; //图片字段高度
		int fieldimgnum = 0; //每行显示图片个数
		int languageid = 0;

		
		
		if (isbill.equals("0")) {
			languageid = Util.getIntValue((String) languageids
					.get(tmpindex), 0); //需要更新





			fieldhtmltype = FieldComInfo.getFieldhtmltype(fieldid);
			fieldtype = FieldComInfo.getFieldType(fieldid);
			fieldlable = (String) fieldlabels.get(tmpindex);
			fieldname = FieldComInfo.getFieldname(fieldid);
			fielddbtype = FieldComInfo.getFielddbtype(fieldid);
			fieldimgwidth = FieldComInfo.getImgWidth(fieldid);
			fieldimgheight = FieldComInfo.getImgHeight(fieldid);
			fieldimgnum = FieldComInfo.getImgNumPreRow(fieldid);
		} else {
			languageid = user.getLanguage();
			fieldname = (String) fieldnames.get(tmpindex);
			fieldhtmltype = (String) fieldhtmltypes.get(tmpindex);
			fieldtype = (String) fieldtypes.get(tmpindex);
			fielddbtype = (String) fieldrealtype.get(tmpindex);
			fieldlable = SystemEnv.getHtmlLabelName(Util.getIntValue(
					(String) fieldlabels.get(tmpindex), 0), languageid);
			fieldimgwidth = Util.getIntValue((String) fieldimgwidths
					.get(tmpindex), 0);
			fieldimgheight = Util.getIntValue((String) fieldimgheights
					.get(tmpindex), 0);
			fieldimgnum = Util.getIntValue((String) fieldimgnums
					.get(tmpindex), 0);
			qfws=Util.getIntValue(""+fieldqfws.get(tmpindex));		
		}

		String fieldvalue = (String) fieldvalues.get(tmpindex);

		String browfieldvalue = fieldvalue;
		boolean isallres = false;
		
		fieldlen = 0;
		if ((fielddbtype.toLowerCase()).indexOf("varchar") > -1) {
			fieldlen = Util.getIntValue(fielddbtype.substring(
					fielddbtype.indexOf("(") + 1,
					fielddbtype.length() - 1));

		}
		if (fieldname.equals("manager")) {
	        //QC169123
	        //判断是否客户门户
			//String tmpmanagerid = ResourceComInfo
			//		.getManagerID(beagenter);
	        String tmpmanagerid;
	        if(user.getLogintype().equals("2")){
	            tmpmanagerid = CustomerInfoComInfo.getCustomerInfomanager(beagenter);
	        }else{
	            tmpmanagerid = ResourceComInfo.getManagerID(beagenter);
	        }
%>
	<input type=hidden name="field<%=fieldid%>" id="field<%=fieldid%>" value="<%=tmpmanagerid%>">
<%
	if (isview.equals("1")) {
%> <tr>
      <td class="fieldnameClass" <%if (fieldhtmltype.equals("2")) {%> valign=top <%}%>> <%=Util.toScreen(fieldlable, languageid)%></td>
      <td class=fieldvalueClass style="TEXT-VALIGN: center"><%=ResourceComInfo.getLastname(tmpmanagerid)%></td>
   </tr><tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
<%
	}
			continue;
		}

		if (fieldname.equals("begindate"))
			newfromdate = "field" + fieldid; //开始日期,主要为开始日期不大于结束日期进行比较
		if (fieldname.equals("enddate"))
			newenddate = "field" + fieldid; //结束日期,主要为开始日期不大于结束日期进行比较
		if (fieldhtmltype.equals("3") && !(fieldtype.equals("161") || fieldtype.equals("162") ) && fieldvalue.equals("0"))
			fieldvalue = "";
		//if(fieldhtmltype.equals("1") && (fieldtype.equals("2") || fieldtype.equals("3")) && Util.getDoubleValue(fieldvalue,0) == 0 ) fieldvalue = "" ;
		if (("" + keywordFieldId).equals(fieldid))
			keywordismand = Util.null2o(ismand);
		if (("" + keywordFieldId).equals(fieldid))
			keywordisedit = Util.null2o(isedit);
		if (("" + yearFieldId).equals(fieldid)) {
			yearFieldHtmlType = fieldhtmltype;
		}

		if (ismand.equals("1") && !fieldid.equals(codeField))
			needcheck += ",field" + fieldid; //如果必须输入,加入必须输入的检查中


        if(fieldid.equals(flowCat)){
%>
	<input type=hidden name="oldfield<%=fieldid%>" id="oldfield<%=fieldid%>" value="<%=fieldvalue%>">
<%
		}
		// 下面开始逐行显示字段

		if (isview.equals("1")) { // 字段需要显示





%>
    <tr>
      <td class="fieldnameClass" <%if (fieldhtmltype.equals("2")) {%> valign=top <%}%>> <%=Util.toScreen(fieldlable, languageid)%></td>
      <td class=fieldvalueClass style="word-wrap:break-word;word-break:break-all;TEXT-VALIGN: center">
      <%
      	if (fieldhtmltype.equals("1")) { // 单行文本框





      				if (fieldtype.equals("1")) { // 单行文本框中的文本





      					if (isedit.equals("1")
      							&& !fieldid.equals(codeField)
      							&& editbodyactionflag) {
      						if (keywordFieldId > 0
      								&& ("" + keywordFieldId)
      										.equals(fieldid)) {
      %>
<button  id="field<%=fieldid%>browser" name="field<%=fieldid%>browser" type=button  class=Browser  onclick="onShowKeyword($G('field<%=fieldid%>').getAttribute('viewtype'))" title="<%=SystemEnv.getHtmlLabelName(21517,	user.getLanguage())%>"></button> 

<%
	}
						//TD18867
						String strJSChangeCode = "";
						if ("1".equals(isUse) && !hasHistoryCode
								&& fieldCode.equals(fieldid)) {
							strJSChangeCode = ";onChangeCode('"
									+ ismand + "')";
						}
						if (ismand.equals("1")) {
%>
        <input datatype="text" viewtype="<%=ismand%>" type=text class=Inputstyle name="field<%=fieldid%>" id="field<%=fieldid%>" temptitle="<%=Util.toScreen(fieldlable,
											languageid)%>" size=50 value="<%=Util
											.toScreenForWorkflow(fieldvalue)%>" <%if (trrigerfield.indexOf("field" + fieldid) >= 0) {%> onBlur="datainput('field<%=fieldid%>');" <%}%> onChange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.viewtype);checkLength('field<%=fieldid%>','<%=fieldlen%>','<%=Util.toScreen(fieldlable,
											languageid)%>','<%=SystemEnv.getHtmlLabelName(20246,
											user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,
											user.getLanguage())%>')<%if (titleFieldId > 0
											&& keywordFieldId > 0
											&& ("" + titleFieldId)
													.equals(fieldid)) {%>;changeKeyword()<%}%><%=strJSChangeCode%>">
        <span id="field<%=fieldid%>span"><%
        	if (fieldvalue.equals("")) {
        %><img src="/images/BacoError_wev8.gif" align=absmiddle><%
        	}
        %></span>
      <%
      	} else {
      %>
        <input datatype="text" viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,
											languageid)%>" onChange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.viewtype);checkLength('field<%=fieldid%>','<%=fieldlen%>','<%=Util.toScreen(fieldlable,
											languageid)%>','<%=SystemEnv.getHtmlLabelName(20246,
											user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,
											user.getLanguage())%>')<%if (titleFieldId > 0
											&& keywordFieldId > 0
											&& ("" + titleFieldId)
													.equals(fieldid)) {%>;changeKeyword()<%}%><%=strJSChangeCode%>" type=text class=Inputstyle name="field<%=fieldid%>" id="field<%=fieldid%>" <%if (trrigerfield.indexOf("field" + fieldid) >= 0) {%> onBlur="datainput('field<%=fieldid%>');" <%}%> value="<%=Util
											.toScreenForWorkflow(fieldvalue)%>" size=50>
        <span id="field<%=fieldid%>span"></span>
      <%
      	}
      						//流程编号  开始





      						if ("1".equals(isUse) && !hasHistoryCode
      								&& fieldCode.equals(fieldid)) {//启用新版流程编号
      %>
                        <A href="#" onclick="onCreateCodeAgain('<%=ismand%>');return false;"><%=SystemEnv.getHtmlLabelName(22784,
											user.getLanguage())%></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
                        <A href="#" onclick="onChooseReservedCode('<%=ismand%>');return false;"><%=SystemEnv.getHtmlLabelName(22785,
											user.getLanguage())%></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
                        <A href="#" onclick="onNewReservedCode('<%=ismand%>');return false;"><%=SystemEnv.getHtmlLabelName(22783,
											user.getLanguage())%></a>
<%
	}
						//流程编号  结束
					} else {
%>
        <span id="field<%=fieldid%>span"><%=Util.toScreenForWorkflow(fieldvalue)%></span>
         <input type=hidden class=Inputstyle name="field<%=fieldid%>" id="field<%=fieldid%>" value="<%=Util.toScreenForWorkflow(fieldvalue)%>"  onpropertychange="datainput('field<%=fieldid%>');">
      <%
      	}
      					if (changefieldsadd.indexOf(fieldid) >= 0) {
      %>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview, 0)
										+ Util.getIntValue(isedit, 0)
										+ Util.getIntValue(ismand, 0)%>" />
<%
	}
				} else if (fieldtype.equals("2")) { // 单行文本框中的整型





					if (isedit.equals("1") && editbodyactionflag) {
						if (ismand.equals("1")) {
%>
        <input datatype="int" viewtype="<%=ismand%>" type=text class=Inputstyle name="field<%=fieldid%>" id="field<%=fieldid%>" temptitle="<%=Util.toScreen(fieldlable,
											languageid)%>" size=20 value="<%=fieldvalue%>"
		onKeyPress="ItemCount_KeyPress()" <%if (trrigerfield.indexOf("field" + fieldid) >= 0) {%>  onBlur="checkcount1(this);checkItemScale(this,'<%=SystemEnv.getHtmlLabelName(31181,user.getLanguage()).replace("12","9")%>',-999999999,999999999);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.viewtype);datainput('field<%=fieldid%>')" <%} else {%> onBlur="checkcount1(this);checkItemScale(this,'<%=SystemEnv.getHtmlLabelName(31181,user.getLanguage()).replace("12","9")%>',-999999999,999999999);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.viewtype);" <%}%>>
        <span id="field<%=fieldid%>span"><%
        	if (fieldvalue.equals("")) {
        %><img src="/images/BacoError_wev8.gif" align=absmiddle><%
        	}
        %></span>
       <%
       	} else {
       %>
       <!-- 单行文本-整数  再此行添加 onkeyup onafterpaste style="ime-mode:disabled" ypc  2012-09-04 添加 -->
        <input datatype="int" viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" 
        type=text class=Inputstyle name="field<%=fieldid%>" id="field<%=fieldid%>" size=20 
         onafterpaste="if(isNaN(value))execCommand('undo')"  style="ime-mode:disabled"
        value="<%=fieldvalue%>" onKeyPress="ItemCount_KeyPress()"  
        <%if (trrigerfield.indexOf("field" + fieldid) >= 0) {%>  onBlur="checkcount1(this);checkItemScale(this,'<%=SystemEnv.getHtmlLabelName(31181,user.getLanguage()).replace("12","9")%>',-999999999,999999999);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.viewtype);datainput('field<%=fieldid%>')" <%} else {%> onBlur="checkcount1(this);checkItemScale(this,'<%=SystemEnv.getHtmlLabelName(31181,user.getLanguage()).replace("12","9")%>',-999999999,999999999);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.viewtype);" <%}%>>
        <span id="field<%=fieldid%>span"></span>
       <%
       	}
       	if (changefieldsadd.indexOf(fieldid) >= 0) {
       %>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview, 0)
											+ Util.getIntValue(isedit, 0)
											+ Util.getIntValue(ismand, 0)%>" />
<%
	}
					} else {
%>
        <span id="field<%=fieldid%>span"><%=fieldvalue%></span>
         <input datatype="int" type=hidden class=Inputstyle name="field<%=fieldid%>" id="field<%=fieldid%>" value="<%=fieldvalue%>" >
      <%
      	}
      				} else if (fieldtype.equals("3")
      						|| fieldtype.equals("5")) { // 单行文本框中的浮点型
      					int decimaldigits_t = 2;
      					if (fieldtype.equals("3")) {
      						int digitsIndex = fielddbtype.indexOf(",");
      						if (digitsIndex > -1) {
      							decimaldigits_t = Util.getIntValue(
      									fielddbtype.substring(
      											digitsIndex + 1,
      											fielddbtype.length() - 1),
      									2);
								//add by liaodong for qc75759 in 2013年10月23日 start 
      							fieldvalue = Util.toDecimalDigits(fieldvalue,decimaldigits_t);
      							//end
      						} else {
      							decimaldigits_t = 2;
								//add by liaodong for qc75759 in 2013年10月23日 start 
      							fieldvalue = Util.toDecimalDigits(fieldvalue,2);
      							//end
      						}
      					}
      					String datavaluetype = "";
				    	if(fieldtype.equals("5")){
				    		  if(isbill.equals("0")){
						        	RecordSet_nf2.executeSql("select * from workflow_formdict where id = " + fieldid);
									 if(RecordSet_nf2.next()){
									   qfws = Util.getIntValue(RecordSet_nf2.getString("qfws"),2);
									 }
									 decimaldigits_t=qfws;
								}else{
									if(qfws == -1){
										 decimaldigits_t=2;
									}else{
										 decimaldigits_t=qfws;
								 }
								}
				    		  
				    		 fieldvalue = Util.toDecimalDigits(fieldvalue,decimaldigits_t);
				    		// fieldvalue=Util.milfloatFormat(fieldvalue+"");
				    		datavaluetype ="datavaluetype='5'";
				    	}
				    	if(fieldtype.equals("3")){
				    		datavaluetype ="datalength='"+decimaldigits_t+"'";
				    	}
						//update  by liaodong for  qc75759 in 2013年10月23日 start
				            datavaluetype +=" datalength='"+decimaldigits_t+"'";
				        //end 
      					if (isedit.equals("1") && editbodyactionflag) {
      						if (ismand.equals("1")) {
      %>
        <input datatype="float" <%=datavaluetype%> viewtype="<%=ismand%>" type=text class=Inputstyle name="field<%=fieldid%>" id="field<%=fieldid%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>" size=20 value="<%=fieldvalue%>"
       onKeyPress="ItemDecimal_KeyPress('field<%=fieldid%>',15,<%=decimaldigits_t%>)" <%if (fieldtype.equals("5")) {%>onfocus="changeToNormalFormat('field<%=fieldid%>')"<%}%> <%if (trrigerfield.indexOf("field" + fieldid) >= 0) {%>  onBlur="checkFloat(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.viewtype);datainput('field<%=fieldid%>');<%if (fieldtype.equals("5")) {%>changeToThousands2('field<%=fieldid%>','<%=decimaldigits_t %>') <%}%>" <%} else {%> onBlur="checkFloat(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.viewtype);<%if (fieldtype.equals("5")) {%>changeToThousands2('field<%=fieldid%>','<%=decimaldigits_t %>')<%}%>" <%}%>>
        <span id="field<%=fieldid%>span"><%
        	if (fieldvalue.equals("")) {
        %><img src="/images/BacoError_wev8.gif" align=absmiddle><%
        	}
        %></span>
       <%
       	} else {
       %>
       	<!-- 单行文本-浮点数 和金额千分位  style="ime-mode:disabled" onkeyup  onafterpaste ypc  2012-09-04 添加  start-->
        <input datatype="float" <%=datavaluetype%> viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,languageid)%>"
         type=text class=Inputstyle name="field<%=fieldid%>" id="field<%=fieldid%>" size=20 
         style="ime-mode:disabled"  onafterpaste="if(isNaN(value))execCommand('undo')"
         value="<%=fieldvalue%>" onKeyPress="ItemDecimal_KeyPress('field<%=fieldid%>',15,<%=decimaldigits_t%>)" <%if (fieldtype.equals("5")) {%>onfocus="changeToNormalFormat('field<%=fieldid%>')"<%}%> <%if (trrigerfield.indexOf("field" + fieldid) >= 0) {%>  onBlur="checkFloat(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.viewtype);datainput('field<%=fieldid%>');<%if (fieldtype.equals("5")) {%>changeToThousands2('field<%=fieldid%>','<%=decimaldigits_t %>')<%}%>" <%} else {%> onBlur="checkFloat(this);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.viewtype);<%if (fieldtype.equals("5")) {%>changeToThousands2('field<%=fieldid%>','<%=decimaldigits_t %>')<%}%>" <%}%>>
        <span id="field<%=fieldid%>span"></span>
       <%
       	}
       						if (changefieldsadd.indexOf(fieldid) >= 0) {
       %>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview, 0)
											+ Util.getIntValue(isedit, 0)
											+ Util.getIntValue(ismand, 0)%>" />
<%
	}
					} else {
						
						
					String toPvalue = "";
							if(fieldtype.equals("5")){
								if(fieldvalue.matches("-*\\d+\\.?\\d*")){
									NumberFormat formatter = new DecimalFormat("###,###.##");   
									toPvalue = formatter.format(Double.parseDouble(fieldvalue))+""; 
								}else{
									toPvalue = fieldvalue;
								}
								fieldvalue = toPvalue;
							}
%>
        <span id="field<%=fieldid%>span"><%=fieldvalue%></span>
         <input datatype="float" <%=datavaluetype%> type=hidden class=Inputstyle name="field<%=fieldid%>" id="field<%=fieldid%>" value="<%=fieldvalue%>" >
      <%
      	}
      				}
      				/*------------- xwj for td3131 20051116 begin----------*/
      				else if (fieldtype.equals("4")) { // 单行文本框中的金额转换





							int decimaldigits_t = 2;
      					if (fieldtype.equals("4")) {
      						int digitsIndex = fielddbtype.indexOf(",");
      						if (digitsIndex > -1) {
      							decimaldigits_t = Util.getIntValue(
      									fielddbtype.substring(
      											digitsIndex + 1,
      											fielddbtype.length() - 1),
      									2);
      						} else {
      							decimaldigits_t = 2;
      						}
							if( !"".equals(fieldvalue) && null != fieldvalue){
							     String formartValue = "0";
								 for(int fi=0;fi<decimaldigits_t;fi++){
									   if(fi == 0){
										   formartValue += ".0"; 
									   }else{
										   formartValue += "0";
									   }
								 }
                              fieldvalue =   new java.text.DecimalFormat(formartValue).format(Double.parseDouble(fieldvalue));
						   }
      					}
      %>
            <table cols=2 id="field<%=fieldid%>_tab">
                <tr><td>
                <%
                	if (isedit.equals("1") && editbodyactionflag) {
                						if (ismand.equals("1")) {
                %>
                        <input datatype="float" type=text class=Inputstyle name="field_lable<%=fieldid%>" temptitle="<%=Util.toScreen(fieldlable,
											languageid)%>" size=60
                            onfocus="FormatToNumber('<%=fieldid%>')"
                            onKeyPress="ItemDecimal_KeyPress('field_lable<%=fieldid%>',15,<%=decimaldigits_t%>)"
                            <%if (trrigerfield.indexOf("field" + fieldid) >= 0) {%>
                                onBlur="checkFloat(this);numberToFormat('<%=fieldid%>');
                                checkinput2('field_lable<%=fieldid%>','field_lable<%=fieldid%>span',$G('field<%=fieldid%>').getAttribute('viewtype'));
                                datainput('field_lable<%=fieldid%>')"
                            <%} else {%>
                                onBlur="checkFloat(this);numberToFormat('<%=fieldid%>');
                                checkinput2('field_lable<%=fieldid%>','field_lable<%=fieldid%>span',$G('field<%=fieldid%>').getAttribute('viewtype'))"
                            <%}%>
                        >
                    <span id="field_lable<%=fieldid%>span"><%
                    	if (fieldvalue.equals("")) {
                    %><img src="/images/BacoError_wev8.gif" align=absmiddle><%
                    	}
                    %></span>
                    <%
                    	} else {
                    %>
                    	<!-- 把  onKeyPress="ItemNum_KeyPress('field_lable<%=fieldid%>')替换掉 onkeydown="clearNoNum(this)" ypc 2012-09-04 添加-->
                        <!--  onkeydown="clearNoNum(this)" 2012-09-06 ypc 修改 成onKeyPress() -->
                        <input datatype="float" type=text class=Inputstyle name="field_lable<%=fieldid%>" id="field_lable<%=fieldid%>" size=60
                          onKeyPress="ItemDecimal_KeyPress('field_lable<%=fieldid%>',15,<%=decimaldigits_t%>)"
                            style="ime-mode:disabled"
                            onfocus="FormatToNumber('<%=fieldid%>')"
                            <%if (trrigerfield.indexOf("field" + fieldid) >= 0) {%>
                                onBlur="checkFloat(this);numberToFormat('<%=fieldid%>');
                                checkinput2('field_lable<%=fieldid%>','field_lable<%=fieldid%>span',$G('field<%=fieldid%>').getAttribute('viewtype'));
                                datainput('field_lable<%=fieldid%>')"
                            <%} else {%>
                                onBlur="checkFloat(this);numberToFormat('<%=fieldid%>');
                                checkinput2('field_lable<%=fieldid%>','field_lable<%=fieldid%>span',$G('field<%=fieldid%>').getAttribute('viewtype'))"
                            <%}%>
                        >
                        <span id="field_lable<%=fieldid%>span"></span>
                    <%
                    	}
                    %>
                    <span id="field<%=fieldid%>span"></span>
					<!-- add by liaodong for qc82290 in 2013-10-17  datalength="2"  filedtype="4"-->
                    <input datatype="float" datalength="2" filedtype="4" viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,
												languageid)%>" type=hidden class=Inputstyle name="field<%=fieldid%>" id="field<%=fieldid%>" value="<%=fieldvalue%>" >
                <%
                	if (changefieldsadd.indexOf(fieldid) >= 0) {
                %>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview, 0)
											+ Util.getIntValue(isedit, 0)
											+ Util.getIntValue(ismand, 0)%>" />
<%
	}
					} else {
%>
                    <span id="field<%=fieldid%>span"></span>
                    <input datatype="float" type=text class=Inputstyle id="field_lable<%=fieldid%>" name="field_lable<%=fieldid%>"  disabled="true" size=60>
					<!-- add by liaodong for qc82290 in 2013-10-17  datalength="2"  filedtype="4"-->
                    <input datatype="float" datalength="2" filedtype="4"  type=hidden class=Inputstyle name="field<%=fieldid%>" id="field<%=fieldid%>" value="<%=fieldvalue%>" >
                <%
                	}
                %>
                </td></tr>
                <tr><td>
                    <input type=text class=Inputstyle size=60 name="field_chinglish<%=fieldid%>" id="field_chinglish<%=fieldid%>"  readOnly="true">
                </td></tr>
                <script language="javascript">
                    $GetEle("field_lable"+<%=fieldid%>).value  = milfloatFormat(floatFormat(<%=fieldvalue%>));
                    $GetEle("field_chinglish"+<%=fieldid%>).value = numberChangeToChinese(floatFormat(<%=fieldvalue%>));
                </script>
            </table>
	    <%
	    	}
	    				/*------------- xwj for td3131 20051116 end ----------*/

	    			} // 单行文本框条件结束





	    			else if (fieldhtmltype.equals("2")) { // 多行文本框





	    				/*-----xwj for @td2977 20051111 begin-----*/
	    				if (isbill.equals("0")) {
	    					rscount
	    							.executeSql("select textheight from workflow_formdict where id = "
	    									+ fieldid);
	    					if (rscount.next()) {
	    						textheight = rscount.getString("textheight");
	    					}
	    				} else {
	    					rscount
	    							.executeSql("select * from workflow_billfield where viewtype=0 and id = "
	    									+ fieldid + " and billid=" + formid);
	    					if (rscount.next()) {
	    						textheight = ""
	    								+ Util.getIntValue(rscount
	    										.getString("textheight"), 4);
	    					}
	    				}
	    				/*-----xwj for @td2977 20051111 begin-----*/
	    				if (isedit.equals("1") && editbodyactionflag) {
	    					if (ismand.equals("1")) {
	    %>
        <textarea class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,
												languageid)%>" name="field<%=fieldid%>"  id="field<%=fieldid%>" <%if (trrigerfield.indexOf("field" + fieldid) >= 0) {%> onBlur="datainput('field<%=fieldid%>');" <%}%>  onChange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.viewtype);checkLengthfortext('field<%=fieldid%>','<%=fieldlen%>','<%=Util.toScreen(fieldlable,
												languageid)%>','<%=SystemEnv.getHtmlLabelName(20246,
										user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,
										user.getLanguage())%>')"
		rows="<%=textheight%>" cols="40" style="width:80%;word-break:break-all;word-wrap:break-word" ><%=fieldtype.equals("2") ? Util
										.toHtmltextarea(Util
												.encodeAnd(fieldvalue)) : Util
										.toScreenToEdit(fieldvalue, user
												.getLanguage())%></textarea><!--xwj for @td2977 20051111-->
        <span id="field<%=fieldid%>span"><%
        	if (fieldvalue.equals("")) {
        %><img src="/images/BacoError_wev8.gif" align=absmiddle><%
        	}
        %></span>
       <%
       	} else {
       %>
      <textarea class=Inputstyle viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable,
												languageid)%>" name="field<%=fieldid%>" id="field<%=fieldid%>" rows="<%=textheight%>" onchange="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.viewtype);checkLengthfortext('field<%=fieldid%>','<%=fieldlen%>','<%=Util.toScreen(fieldlable,
												languageid)%>','<%=SystemEnv.getHtmlLabelName(20246,
										user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,
										user.getLanguage())%>')" cols="40" <%if (trrigerfield.indexOf("field" + fieldid) >= 0) {%> onBlur="datainput('field<%=fieldid%>');" <%}%> style="width:80%;word-break:break-all;word-wrap:break-word"><%=fieldtype.equals("2") ? Util
										.toHtmltextarea(Util
												.encodeAnd(fieldvalue)) : Util
										.toScreenToEdit(fieldvalue, user
												.getLanguage())%></textarea><!--xwj for @td2977 20051111-->
      <span id="field<%=fieldid%>span"></span>
      <%
      	}
      %>
	  <script>$(function () { $GetEle("htmlfieldids").value += "field<%=fieldid%>;<%=Util.toScreen(fieldlable, languageid)%>;<%=fieldtype%>,";});</script>
	  <%
	  	if (fieldtype.equals("2")) {
	  %>
		    <script>
			   function funcField<%=fieldid%>(){
				CkeditorExt.initEditor('frmmain','field<%=fieldid%>','<%=user.getLanguage()%>',CkeditorExt.NO_IMAGE,200)
			   	//FCKEditorExt.initEditor('frmmain','field<%=fieldid%>',<%=user.getLanguage()%>,FCKEditorExt.NO_IMAGE);
				<%if (isedit.equals("1"))
									out.println("CkeditorExt.checkText('field"
											+ fieldid + "span','field"
											+ fieldid + "');");%>
					CkeditorExt.toolbarExpand(false,"field<%=fieldid%>");
			   }

				//window.attachEvent("onload", funcField<%=fieldid%>);
				//$(window).bind("load", funcField<%=fieldid%>);
				if (window.addEventListener){
	        	    window.addEventListener("load", funcField<%=fieldid%>, false);
	        	}else if (window.attachEvent){
	        	    window.attachEvent("onload", funcField<%=fieldid%>);
	        	}else{
	        	    window.onload=funcField<%=fieldid%>;
	        	}
				
			</script>
			
			<%
							}
						%>  
			<%
  				if (changefieldsadd.indexOf(fieldid) >= 0) {
  			%>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview, 0)
										+ Util.getIntValue(isedit, 0)
										+ Util.getIntValue(ismand, 0)%>" />
<%
	}
				} else {
					if (fieldtype.equals("2")) {
						session.setAttribute("FCKEDDesc_" + requestid
								+ "_" + userid + "_" + fieldid + "_-1",
								fieldvalue);
						managefckfields_body.add("FCKiframe" + fieldid);
%>
<input type="hidden" id="FCKiframefieldid" value="FCKiframe<%=fieldid%>"/>
        <iframe id="FCKiframe<%=fieldid%>" name="FCKiframe<%=fieldid%>" src="/workflow/request/ShowFckEditorDesc.jsp?requestid=<%=requestid%>&userid=<%=userid%>&fieldid=<%=fieldid%>&rowno=-1"  width="100%" height="100%" marginheight="0" marginwidth="0" allowTransparency="true" frameborder="0"></iframe>
         <textarea name="field<%=fieldid%>" id="field<%=fieldid%>" style="display:none"><%=Util.toHtmltextarea(Util
										.encodeAnd(fieldvalue))%></textarea>
<%
	} else {
%>
        <span id="field<%=fieldid%>span" style="word-break:break-all;word-wrap:break-word"><%=fieldvalue%></span>
         <textarea name="field<%=fieldid%>" id="field<%=fieldid%>" style="display:none"><%=Util.toScreenToEdit(fieldvalue, user
										.getLanguage())%></textarea>
<script>			
	var fieldfieldidspan =  $GetEle('field<%=fieldid%>span');
	var afieldFieldHtml = fieldfieldidspan.getElementsByTagName('a');
	for(var i=0;i<afieldFieldHtml.length;i++){
		if(afieldFieldHtml[i].href.indexOf('javascript:')==-1){
			afieldFieldHtml[i].target='_blank';
		}
	}
</script>
<%
	}
%>

      <%
      	}
      			} // 多行文本框条件结束





      			else if (fieldhtmltype.equals("3")) { // 浏览按钮 (涉及workflow_broswerurl表)
      				String url = BrowserComInfo.getBrowserurl(fieldtype); // 浏览按钮弹出页面的url
      				String linkurl = BrowserComInfo.getLinkurl(fieldtype); // 浏览值点击的时候链接的url

      				if("23".equals(fieldtype)){
      			    	if(url.indexOf("CapitalBrowser.jsp?")>-1){
      			    		url+="&billid="+formid;
      			    	}else{
      			    		url+="?billid="+formid;
      			    	}
      			    }
      				String showname = ""; // 值显示的名称
      				String showid = ""; // 值





      				String hiddenlinkvalue = "";

      				String tablename = ""; //浏览框对应的表,比如人力资源表





      				String columname = ""; //浏览框对应的表名称字段





      				String keycolumname = ""; //浏览框对应的表值字段





      				// 如果是多文档, 需要判定是否有新加入的文档,如果有,需要加在原来的后面
      				if ((fieldtype.equals("37") || (fieldtype.equals("9") && docFlags
      						.equals("1")))
      						&& fieldid.equals(docfileid)
      						&& !newdocid.equals("")) {
      					if (!fieldvalue.equals(""))
      						fieldvalue += ",";
      					if (fieldtype.equals("9") && docFlags.equals("1"))
      						fieldvalue = newdocid;
      					else
      						fieldvalue += newdocid;
      				}

      				if (fieldtype.equals("2") || fieldtype.equals("19"))
      					showname = fieldvalue; // 日期时间
      				else if (!fieldvalue.equals("")) {
      					ArrayList tempshowidlist = Util.TokenizerString(
      							fieldvalue, ",");
      					if (fieldtype.equals("8")
      							|| fieldtype.equals("135")) {
      						//项目，多项目
      						for (int k = 0; k < tempshowidlist.size(); k++) {
      							if (!linkurl.equals("")) {
      								showname += "<a href='"
      										+ linkurl
      										+ tempshowidlist.get(k)
											+ "&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype
      										+ "' target='_new'>"
      										+ ProjectInfoComInfo1
      												.getProjectInfoname((String) tempshowidlist
      														.get(k))
      										+ "</a>&nbsp";
      							} else {
      								showname += ProjectInfoComInfo1
      										.getProjectInfoname((String) tempshowidlist
      												.get(k))
      										+ " ";
      							}
      						}
      					} else if (fieldtype.equals("17")) {
      					   	browfieldvalue = fieldvalue;
      					    weaver.workflow.request.WorkflowJspBean workflowJspBean2 = new weaver.workflow.request.WorkflowJspBean();
      					  	workflowJspBean2.setRequestid(requestid);
      					  	StringBuffer _sbf = new StringBuffer(fieldvalue);
      					  	String splitflg = "_____";
	      					  if (isedit.equals("0") || !editbodyactionflag) {
	      					    splitflg = "&nbsp";
	      					  }
      					  	
      						showname = workflowJspBean2.getMultiResourceShowName(_sbf, linkurl, fieldid, user.getLanguage(), splitflg);
      						browfieldvalue = _sbf.toString();
      						boolean hasGroup = workflowJspBean2.isHasGroup();
      						if ((isedit.equals("0") || !editbodyactionflag) && hasGroup) {
	      						String[]fieldvalarray = fieldvalue.split(",");
	      	                	List<String> fieldvalList = new ArrayList<String>();
	      	                	for (int z=0; z<fieldvalarray.length; z++) {
	      	                	    if (!fieldvalList.contains(fieldvalarray[z])) {
	      	                	        fieldvalList.add(fieldvalarray[z]);
	      	                	    }
	      	                	}
	      	                	if (fieldvalList.size() > 0) {
	      	                	    showname += "&nbsp;<span style='color:#bfbfc0;'>（"+SystemEnv.getHtmlLabelName(83698,user.getLanguage()) + fieldvalList.size() + SystemEnv.getHtmlLabelName(84097,user.getLanguage())+"）</span>";    
	      	                	}
      						}
      						//是否选择了所有人
      						isallres = workflowJspBean2.isIsallres();
      					} else if (fieldtype.equals("1")
      							|| fieldtype.equals("165")
      							|| fieldtype.equals("166")) {
      						//人员，多人员
      						for (int k = 0; k < tempshowidlist.size(); k++) {
      							if (!linkurl.equals("")) {
                        	if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl)||"/hrm/hrmTab.jsp?_fromURL=HrmResource&id=".equals(linkurl)){
      									showname += "<a href='javaScript:openhrm("
      											+ tempshowidlist.get(k)
      											+ ");' onclick='pointerXY(event);'>"
      											+ ResourceComInfo
      													.getResourcename((String) tempshowidlist
      															.get(k))
      											+ "</a>&nbsp";
      								} else
      									showname += "<a href='"
      											+ linkurl
      											+ tempshowidlist.get(k)
													+ "&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype
      											+ "' target='_new'>"
      											+ ResourceComInfo
      													.getResourcename((String) tempshowidlist
      															.get(k))
      											+ "</a>&nbsp";
      							} else {
      								showname += ResourceComInfo
      										.getResourcename((String) tempshowidlist
      												.get(k))
      										+ " ";
      							}
      						}
      					} else if (fieldtype.equals("160")) {
      						//角色人员
      						for (int k = 0; k < tempshowidlist.size(); k++) {
      							if (!linkurl.equals("")) {
      								if ("/hrm/resource/HrmResource.jsp?id="
      										.equals(linkurl)) {
      									showname += "<a href='javaScript:openhrm("
      											+ tempshowidlist.get(k)
      											+ ");' onclick='pointerXY(event);'>"
      											+ ResourceComInfo
      													.getResourcename((String) tempshowidlist
      															.get(k))
      											+ "</a>&nbsp";
      								} else
      									showname += "<a href='"
      											+ linkurl
      											+ tempshowidlist.get(k)
												+ "&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype
      											+ "' target='_new'>"
      											+ ResourceComInfo
      													.getResourcename((String) tempshowidlist
      															.get(k))
      											+ "</a>&nbsp";
      							} else {
      								showname += ResourceComInfo
      										.getResourcename((String) tempshowidlist
      												.get(k))
      										+ " ";
      							}
      						}
      					} else if (fieldtype.equals("142")) {
      						//收发文单位





      						for (int k = 0; k < tempshowidlist.size(); k++) {
      							if (!linkurl.equals("")) {
      								showname += "<a href='"
      										+ linkurl
      										+ tempshowidlist.get(k)
											+ "&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype
      										+ "' target='_new'>"
      										+ docReceiveUnitComInfo_mba
      												.getReceiveUnitName((String) tempshowidlist
      														.get(k))
      										+ "</a>&nbsp";
      							} else {
      								showname += docReceiveUnitComInfo_mba
      										.getReceiveUnitName((String) tempshowidlist
      												.get(k))
      										+ " ";
      							}
      						}
      					} else if (fieldtype.equals("7")
      							|| fieldtype.equals("18")) {
      						//客户，多客户
      						for (int k = 0; k < tempshowidlist.size(); k++) {
      							if (!linkurl.equals("")) {
      								showname += "<a href='"
      										+ linkurl
      										+ tempshowidlist.get(k)
												+ "&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype
      										+ "' target='_new'>"
      										+ CustomerInfoComInfo
      												.getCustomerInfoname((String) tempshowidlist
      														.get(k))
      										+ "</a>&nbsp";
      							} else {
      								showname += CustomerInfoComInfo
      										.getCustomerInfoname((String) tempshowidlist
      												.get(k))
      										+ " ";
      							}
      						}
      					} else if (fieldtype.equals("4")
      							|| fieldtype.equals("57")
      							|| fieldtype.equals("167")
      							|| fieldtype.equals("168")) {
      						//部门，多部门
      						for (int k = 0; k < tempshowidlist.size(); k++) {
      							String showdeptname = "";
      							String showdeptid = (String) tempshowidlist.get(k);
      							if(!"".equals(showdeptid)){
      								if(Integer.parseInt(showdeptid) < -1){
      									showdeptname = deptVirComInfo.getDepartmentname(showdeptid);
      								}else{
      									showdeptname = DepartmentComInfo1.getDepartmentname(showdeptid);
      								}
      							}
      							if (!linkurl.equals("")) {
      								showname += "<a href='"
      										+ linkurl
      										+ tempshowidlist.get(k)
											+ "&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype
      										+ "' target='_new'>"
      										+ showdeptname
      										+ "</a>&nbsp";
      							} else {
      								showname += showdeptname
      										+ " ";
      							}
      						}
      					}else if(fieldtype.equals("164") || fieldtype.equals("194")){
                       //分部、多分部

                       for(int k=0;k<tempshowidlist.size();k++){
                    	    String showsubcompname = "";
 							String showsubcompid = (String) tempshowidlist.get(k);
 							if(!"".equals(showsubcompid)){
 								if(Integer.parseInt(showsubcompid) < -1){
 									showsubcompname = subCompVirComInfo.getSubCompanyname(showsubcompid);
 								}else{
 									showsubcompname = SubCompanyComInfo1.getSubCompanyname(showsubcompid);
 								}
 							}
                       
                           if(!linkurl.equals("")){
                           		showname+="<a href='"+linkurl+tempshowidlist.get(k)+ "&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"' target='_new'>"+showsubcompname+"</a>&nbsp";
                           }else{
                           		showname+=showsubcompname+" ";
                           }
                       }
                } else if (fieldtype.equals("9")
      							|| fieldtype.equals("37")) {
      						//文档，多文档
      						for (int k = 0; k < tempshowidlist.size(); k++) {

      							if (fieldtype.equals("9")
      									&& docFlags.equals("1") && fieldid.equals(flowDocField)) {
      								//linkurl="WorkflowEditDoc.jsp?docId=";//????
      								String tempDoc = ""
      										+ tempshowidlist.get(k);
      								String tempDocView = "0";
      								if (isedit.equals("1")
      										&& editbodyactionflag) {
      									tempDocView = "1";
      								}
      								showname += "<a href='#' onclick='javascript:createDoc("
      										+ fieldid
      										+ "," + tempDoc + "," + tempDocView + ")' >"+ DocComInfo1.getDocname((String) tempshowidlist.get(k))+ "</a><button type=button  id='createdoc' style='display:none' class=AddDocFlow onclick=createDoc("
      										+ fieldid
      										+ ","
      										+ tempDoc
      										+ ","
      										+ tempDocView + ")></button>";

      							} else {
      								if (!linkurl.equals("")) {
      									showname += "<a href='"
      											+ linkurl
      											+ tempshowidlist.get(k)
												+ "&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype
      											+ "&requestid="
      											+ requestid
      											+ "' target='_blank'>"
      											+ DocComInfo1
      													.getDocname((String) tempshowidlist
      															.get(k))
      											+ "</a>&nbsp";
      								} else {
      									showname += DocComInfo1
      											.getDocname((String) tempshowidlist
      													.get(k))
      											+ " ";
      								}
      							}
      						}
      					} else if (fieldtype.equals("23")) {
      						//资产
      						for (int k = 0; k < tempshowidlist.size(); k++) {
      							if (!linkurl.equals("")) {
      								showname += "<a href='"
      										+ linkurl
      										+ tempshowidlist.get(k)
												+ "&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype
      										+ "' target='_new'>"
      										+ CapitalComInfo1
      												.getCapitalname((String) tempshowidlist
      														.get(k))
      										+ "</a>&nbsp";
      							} else {
      								showname += CapitalComInfo1
      										.getCapitalname((String) tempshowidlist
      												.get(k))
      										+ " ";
      							}
      						}
      					} else if (fieldtype.equals("16")
      							|| fieldtype.equals("152")
      							|| fieldtype.equals("171")) {
      						//相关请求
      						for (int k = 0; k < tempshowidlist.size(); k++) {
      							if (!linkurl.equals("")) {
      								int tempnum = Util
      										.getIntValue(String
      												.valueOf(session
      														.getAttribute("slinkwfnum")));
      								tempnum++;
      								session.setAttribute("resrequestid"
      										+ tempnum, ""
      										+ tempshowidlist.get(k));
      								session.setAttribute("slinkwfnum", ""
      										+ tempnum);
      								session.setAttribute("haslinkworkflow",
      										"1");
      								hiddenlinkvalue += "<input type=hidden name='slink"
      										+ fieldid
      										+ "_rq"
      										+ tempshowidlist.get(k)
      										+ "' value=" + tempnum + ">";
      								showname += "<a href='"
      										+ linkurl
      										+ tempshowidlist.get(k)
      										+ "&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&wflinkno="
      										+ tempnum
      										+ "' target='_new'>"
      										+ WorkflowRequestComInfo1
      												.getRequestName((String) tempshowidlist
      														.get(k))
      										+ "</a>&nbsp";
      							} else {
      								showname += WorkflowRequestComInfo1
      										.getRequestName((String) tempshowidlist
      												.get(k))
      										+ " ";
      							}
      						}
      					}
      					//add by fanggsh for TD4528   20060621 begin
      					else if (fieldtype.equals("141")) {
      						//人力资源条件
                    ResourceConditionManager.setWorkflowid(workflowid);
      						showname += ResourceConditionManager
      								.getFormShowName(fieldvalue, languageid);
      					}
      					//add by fanggsh for TD4528   20060621 end
      					//added by alan for td:10814
      					else if (fieldtype.equals("142")) {
      						//收发文单位





      						for (int k = 0; k < tempshowidlist.size(); k++) {
      							if (!linkurl.equals("") && !isprint) {
      								showname += "<a href='"
      										+ linkurl
      										+ tempshowidlist.get(k)
												+ "&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype
      										+ "' target='_new'>"
      										+ DocReceiveUnitComInfo
      												.getReceiveUnitName(""
      														+ tempshowidlist
      																.get(k))
      										+ "</a>&nbsp";
      							} else {
      								showname += DocReceiveUnitComInfo
      										.getReceiveUnitName(""
      												+ tempshowidlist.get(k))
      										+ " ";
      							}
      						}
      					}
      					//end by alan for td:10814
      					else if (fieldtype.equals("161")) {//自定义单选





      						showname = ""; // 新建时候默认值显示的名称
      						String showdesc = "";
      						showid = fieldvalue; // 新建时候默认值




							showid = showid.replace("&#039;","'").replace("&quot;", "\"");
      						try {
      							Browser browser = (Browser) StaticObj
      									.getServiceByFullname(fielddbtype,
      											Browser.class);
      							BrowserBean bb = browser.searchById(requestid+"^~^"+showid);
      							String desc = Util.null2String(bb
      									.getDescription());
      							String name = Util
      									.null2String(bb.getName());
                                String href=Util.null2String(bb.getHref());
                                name = name.replaceAll("<", "&lt;");
        						name = name.replaceAll(">", "&gt;");
                                if(href.equals("")){
                                	showname+="<a title='"+desc+"'>"+name+"</a>&nbsp";
                                }else{
                                	showname+="<a title='"+desc+"' href='"+href+"' target='_blank'>"+name+"</a>&nbsp";
                                }
      						} catch (Exception e) {
      						}
      					} else if (fieldtype.equals("162")) {//自定义多选





      						showname = ""; // 新建时候默认值显示的名称
      						showid = fieldvalue; // 新建时候默认值





      						try {
      							Browser browser = (Browser) StaticObj
      									.getServiceByFullname(fielddbtype,
      											Browser.class);
      							List l = Util.TokenizerString(showid, ",");
      							for (int j = 0; j < l.size(); j++) {
      								String curid = (String) l.get(j);
									curid = curid.replace("&#039;","'").replace("&quot;", "\"");
      								BrowserBean bb = browser
      										.searchById(requestid+"^~^"+curid);
      								String name = Util.null2String(bb
      										.getName());
      								//System.out.println("showname:"+showname);
      								String desc = Util.null2String(bb
      										.getDescription());
      	                            String href=Util.null2String(bb.getHref());
      	                            name = name.replaceAll("<", "&lt;");
          						    name = name.replaceAll(">", "&gt;");
      	                            if(href.equals("")){
      	                            	showname+="<a title='"+desc+"'>"+name+"</a>&nbsp";
      	                            }else{
      	                            	showname+="<a title='"+desc+"' href='"+href+"' target='_blank'>"+name+"</a>&nbsp";
      	                            }
      							}
      						} catch (Exception e) {
      						}
      					}else if(fieldtype.equals("256")||fieldtype.equals("257")){//自定义多选





      						CustomTreeUtil customTreeUtil = new CustomTreeUtil();
      						showid = fieldvalue;
      						showname = customTreeUtil.getTreeFieldShowName(fieldvalue,fielddbtype);
                        }
						else if (fieldtype.equals("224")||fieldtype.equals("225")||fieldtype.equals("226")||fieldtype.equals("227")) {
								//集成浏览按钮
								//zzl
								//String showname = ""; // 值显示的名称
      							//String showid = ""; // 值





								//showname+="<a title='"+desc+"'>"+name+"</a>&nbsp";
								showname+="<a title='"+fieldvalue+"'>"+fieldvalue+"</a>&nbsp";
								//System.out.println("fieldids"+fieldid);
								//System.out.println("fieldnames"+fieldname);
								//System.out.println("fieldvalues"+fieldvalue);
						}else if (fieldtype.equals("269")) {// 多提醒方式
							showname += MeetingBrowser.getRemindNames(fieldvalue, user.getLanguage());
						}
						else if(fieldtype.equals("263")){
						    tablename = BrowserComInfo
                            .getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
                    columname = BrowserComInfo
                            .getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
                    /*因为应聘库中(HrmCareerApply)的人员的firstname在新增时都为空，此处列名直接取上面查出来的(lastname+firstname)
                    会导致流程提交后应聘人不显示，所以此处做下特殊处理，只取应聘人的lastname    参考TD24866*/
                    if (columname.equals("(lastname+firstname)"))
                        columname = "lastname";
                    keycolumname = BrowserComInfo
                            .getBrowserkeycolumname(fieldtype); //浏览框对应的表值字段
                    //add by wang jinyong
                    HashMap temRes = new HashMap();
                    if (fieldvalue.indexOf(",") != -1) {
                        sql = "select " + keycolumname + ","
                                + columname + " from " + tablename
                                + " where " + keycolumname
                                + " in( " + fieldvalue + ")";
                    } else {
                        sql = "select " + keycolumname + ","
                                + columname + " from " + tablename
                                + " where " + keycolumname + "="
                                + fieldvalue;
                    }

                    RecordSet.executeSql(sql);
                    while (RecordSet.next()) {
                        showid = Util.null2String(RecordSet
                                .getString(1));
                        String tempshowname = Util.toScreen(
                                RecordSet.getString(2), user
                                        .getLanguage());
                       showname = tempshowname;
                    }
						}else if(fieldtype.equals("87")||fieldtype.equals("184")){
						
					    
					    	String[] tmp=fieldvalue.split(",");
							for(int k=0;k<tmp.length;k++){
								if(!tmp[k].isEmpty()){
									String roomname=mrci.getMeetingRoomInfoname(tmp[k]);
									showname += "<a href='" + linkurl
										+ tmp[k] + "' target='_new'>"
										+ roomname + "</a>&nbsp";
								}
							}
					      }
      					else {
      						tablename = BrowserComInfo
      								.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表





      						columname = BrowserComInfo
      								.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段





      						/*因为应聘库中(HrmCareerApply)的人员的firstname在新增时都为空，此处列名直接取上面查出来的(lastname+firstname)
      						会导致流程提交后应聘人不显示，所以此处做下特殊处理，只取应聘人的lastname	参考TD24866*/
      						if (columname.equals("(lastname+firstname)"))
      							columname = "lastname";
      						keycolumname = BrowserComInfo
      								.getBrowserkeycolumname(fieldtype); //浏览框对应的表值字段






      						//add by wang jinyong
      						HashMap temRes = new HashMap();

      						if (fieldvalue.indexOf(",") != -1) {
      							sql = "select " + keycolumname + ","
      									+ columname + " from " + tablename
      									+ " where " + keycolumname
      									+ " in( " + fieldvalue + ")";
      						} else {
      							sql = "select " + keycolumname + ","
      									+ columname + " from " + tablename
      									+ " where " + keycolumname + "="
      									+ fieldvalue;
      						}

      						RecordSet.executeSql(sql);
      						while (RecordSet.next()) {
      							showid = Util.null2String(RecordSet
      									.getString(1));
      							String tempshowname = Util.toScreen(
      									RecordSet.getString(2), user
      											.getLanguage());
      							if (!linkurl.equals("")) {
      								showname += "<a href='" + linkurl
      										+ showid + "' target='_new'>"
      										+ tempshowname + "</a>&nbsp";
      							} else {
      								showname += tempshowname + " ";
      							}
      						}
      					}
      				}

      				//add by dongping
      				//永乐要求在审批会议的流程中增加会议室报表链接，点击后在新窗口显示会议室报表





      				if (fieldtype.equals("118")) {
      					showname = "<a href=/meeting/report/MeetingRoomPlan.jsp target=blank>"+SystemEnv.getHtmlLabelName(2165,user.getLanguage())+"</a>";
      				}

      				if (isedit.equals("1") && editbodyactionflag) {
      				    try {
      				    	 if(fieldtype.equals("161") || fieldtype.equals("162")){
      				               showname = showname.replaceAll("</a>&nbsp", "</a>~~WEAVERSplitFlag~~");   
      				    	 }else{
      				               showname = showname.replaceAll("</a>&nbsp", "</a>,"); 
      				    	 }     	  	
      				    } catch (Exception e) {
      				        e.printStackTrace();
      				    }
      				  
					  
		if("16".equals(fieldtype)){   //请求
			if(url.indexOf("RequestBrowser.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("ViewRequest.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/
		}

/*	if("152".equals(fieldtype) || "171".equals(fieldtype)){   //多请求





			if(url.indexOf("MultiRequestBrowser.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("ViewRequest.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
		}		 */

		if("7".equals(fieldtype)){   //客户
			if(url.indexOf("CustomerBrowser.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("ViewCustomer.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/
		}

			if("9".equals(fieldtype)){   //文档
			if(url.indexOf("DocBrowser.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("DocDsp.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/
		}

			if("37".equals(fieldtype)){   //多文档





			if(url.indexOf("MutiDocBrowser.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("DocDsp.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/
		}

								if("1".equals( fieldtype)){   //单人力





			if(url.indexOf("ResourceBrowser.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("HrmResource.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/

		}

	/*	if("17".equals( fieldtype)){   ////多人力





			if(url.indexOf("MultiResourceBrowser.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("hrmTab.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}

		}*/
		
							if("165".equals( fieldtype)){   //分权单人力





			if(url.indexOf("ResourceBrowserByDec.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("HrmResource.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/

		}

		if("166".equals( fieldtype)){   ////分权多人力





			if(url.indexOf("MultiResourceBrowserByDec.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("hrmTab.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/

		}

			if("167".equals( fieldtype)){   ////分权单部门





			if(url.indexOf("DepartmentBrowserByDec.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("HrmDepartmentDsp.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/

		}

		if("168".equals( fieldtype)){   ////分权多部门





			if(url.indexOf("MultiDepartmentBrowserByDecOrder.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("HrmDepartmentDsp.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/

		}

		if("169".equals( fieldtype)){   ////分权单分部





			if(url.indexOf("SubcompanyBrowserByDec.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("HrmSubCompanyDsp.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/

		}

		if("170".equals( fieldtype)){   ////分权多分部





			if(url.indexOf("MultiSubcompanyBrowserByDec.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("HrmSubCompanyDsp.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/

		}
      					//add by fanggsh 20060621 for TD4528 begin
      					if (fieldtype.equals("160")) {
      						rsaddop
      								.execute("select a.level_n, a.level2_n from workflow_groupdetail a ,workflow_nodegroup b where a.groupid=b.id and a.type=50 and a.objid="
      										+ fieldid
      										+ " and b.nodeid in (select nodeid from workflow_flownode where workflowid="
      										+ workflowid + ") ");
      						String roleid = "";
      						int rolelevel_tmp = 0;
      						if (rsaddop.next()) {
      							roleid = rsaddop.getString(1);
      							rolelevel_tmp = Util.getIntValue(rsaddop
      									.getString(2), 0);
      							roleid += "a" + rolelevel_tmp+"b"+beagenter;
      						}
      						bclick = "onShowResourceRole('"+fieldid+"','"+url+"','"+linkurl+"','"+fieldtype+"',$G('field"+fieldid+"').getAttribute('viewtype'),'"+roleid+"')";
      						String _completeUrl= "javascript:getajaxurl(" + fieldtype +",'','','"+fieldid+"','"+roleid+"')";
      %>
      <brow:browser viewType="0" name='<%="field"+fieldid%>' browserValue='<%=fieldvalue%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldtype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%=_completeUrl%>' width="auto" needHidden="false" defaultRow="99" onPropertyChange='<%="wfbrowvaluechange(this," + fieldid + ")" %>' linkUrl='<%=linkurl%>' type='<%=fieldtype%>'> </brow:browser>
      <!-- 
      <button id="field<%=fieldid%>browser" name="field<%=fieldid%>browser" type=button  class=Browser  onclick="onShowResourceRole('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',$G('field<%=fieldid%>').getAttribute('viewtype'),'<%=roleid%>')" title="<%=SystemEnv.getHtmlLabelName(20570,
										user.getLanguage())%>"></button>
										 -->
        
<%
	} else if (fieldtype.equals("161")|| fieldtype.equals("162")) {
						url += "?type=" + fielddbtype;
						bclick = "onShowBrowser2('" + fieldid + "','"+url+"','"+linkurl+"','"+fieldtype+"',$G('field"+fieldid+"').getAttribute('viewtype'));";
						String compurl = "javascript:getajaxurl(" + fieldtype + ",'"+fielddbtype+"')";
%>
		<brow:browser viewType="0" name='<%="field"+fieldid%>' browserValue='<%=fieldvalue %>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" nameSplitFlag="~~WEAVERSplitFlag~~" isSingle='<%=BrowserManager.browIsSingle(fieldtype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%=compurl%>' width="auto" needHidden="false" defaultRow="99" onPropertyChange='<%="wfbrowvaluechange(this," + fieldid + ")" %>' linkUrl='<%=linkurl%>' type='<%=fieldtype%>'> </brow:browser>
		<!-- 
         <button id="field<%=fieldid%>browser" name="field<%=fieldid%>browser"  type=button  class=Browser  onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',$G('field<%=fieldid%>').getAttribute('viewtype'));<%if (trrigerfield.indexOf("field" + fieldid) >= 0) {%>datainput('field<%=fieldid%>');<%}%>" ></button>
		 -->
<%
  	}else if (fieldtype.equals("256")
			|| fieldtype.equals("257")) {
		url+="?type="+fielddbtype+"_"+fieldtype;	
		bclick = "onShowBrowser2('" + fieldid + "','"+url+"','"+linkurl+"','"+fieldtype+"',$G('field"+fieldid+"').getAttribute('viewtype'));";
		if (trrigerfield.indexOf("field" + fieldid) >= 0) {
		   // bclick += "datainput('field" + fieldid + "')";
		}
%>
<brow:browser viewType="0" name='<%="field"+fieldid%>' browserValue='<%=fieldvalue %>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldtype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldtype + ")"%>' width="auto" needHidden="false" defaultRow="99" onPropertyChange='<%="wfbrowvaluechange(this," + fieldid + ")" %>' linkUrl='<%=linkurl%>' type='<%=fieldtype%>'> </brow:browser>
<%
} else if (fieldtype.equals("224")|| fieldtype.equals("225")||fieldtype.equals("226")|| fieldtype.equals("227")) {
			//zzl
			//解决新建的时候不选择sap浏览按钮的数据，然后保存，在代办页面打开，浏览按钮里面没有数据的问题
			url+="?type="+fielddbtype+"|"+fieldid;	
			bclick = "onShowBrowser2('"+fieldid+"','"+url+"','"+linkurl+"','"+fieldtype+"',$G('field"+fieldid+"').getAttribute('viewtype'));";
			if (trrigerfield.indexOf("field" + fieldid) >= 0) {
				//bclick += "datainput('field" + fieldid+"');";
			}
%>
 	<brow:browser viewType="0" name='<%="field"+fieldid%>' browserValue='<%=fieldvalue %>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldtype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldtype + ")"%>' width="auto" needHidden="false" defaultRow="99" onPropertyChange='<%="wfbrowvaluechange(this," + fieldid + ")" %>' linkUrl='<%=linkurl%>' type='<%=fieldtype%>'> </brow:browser>
 	<!-- 
      <button id="field<%=fieldid%>browser" name="field<%=fieldid%>browser" type=button  class=Browser  onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',$G('field<%=fieldid%>').getAttribute('viewtype'));<%if (trrigerfield.indexOf("field" + fieldid) >= 0) {%>datainput('field<%=fieldid%>');<%}%>" ></button>
       -->
		 
<%	
	}
  	else if (fieldtype.equals("141")) {
  	  bclick = "onShowResourceConditionBrowser('"+fieldid+"','"+url+"','"+linkurl+"','"+fieldtype+"',$G('field"+fieldid+"').getAttribute('viewtype'))";
  %>
  <brow:browser viewType="0" name='<%="field"+fieldid%>' browserValue='<%=fieldvalue %>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldtype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldtype + ")"%>' width="auto" needHidden="false" defaultRow="99" onPropertyChange='<%="wfbrowvaluechange(this," + fieldid + ")" %>' linkUrl='<%=linkurl%>' type='<%=fieldtype%>'> </brow:browser>
  <!-- 
  <button id="field<%=fieldid%>browser" name="field<%=fieldid%>browser" type=button  class=Browser  onclick="onShowResourceConditionBrowser('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',$G('field<%=fieldid%>').getAttribute('viewtype'))" title="<%=SystemEnv.getHtmlLabelName(172, user
          
										.getLanguage())%>"></button>
   -->
        
<%
	} else if(fieldtype.equals("34")){//added by wcd 2015-08-18
	%>
		<select class="inputstyle" size="1" viewtype="<%=ismand%>" name="newLeaveType" id="<%="field"+fieldid%>" onchange="setLeaveTypeValue(this.value);checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.viewtype);">
			<option value=''></option>
		<%
			List leaveTypeList = leaveTypeColorManager.find("[map]field002:1");
			int leaveTypeSize = leaveTypeList == null ? 0 : leaveTypeList.size();
			HrmLeaveTypeColor leaveTypeBean = null;
			for(int leaveTypeIndex=0; leaveTypeIndex<leaveTypeSize; leaveTypeIndex++) {
				leaveTypeBean = (HrmLeaveTypeColor)leaveTypeList.get(leaveTypeIndex);
		%>
				<option value='<%=leaveTypeBean.getField004()%>' <%=showid.equals(String.valueOf(leaveTypeBean.getField004())) ? "selected" : ""%>><%=leaveTypeBean.getTitle(user.getLanguage())%></option>
		<%	}
		%>
		</select>
		<span id="field<%=fieldid%>span"><%if(ismand.equals("1") && showid.length() <= 0) out.println("<img src='/images/BacoError_wev8.gif' align=absMiddle>");%></span>
	   <script>
		jQuery(document).ready(function(){
			var newLeaveType = $GetEle("newLeaveType");
			$(newLeaveType).selectbox('hide');
			jQuery(newLeaveType).autoSelect({showAll: 'true'});
		});
		function setLeaveTypeValue(vl) {
			jQuery("input[name=<%="field"+fieldid%>]").val(vl);
			try{showVacationInfo();}catch(e){}
		}
	   </script>
	<%
	  } else {
						//add by fanggsh 20060621 for TD4528 end
						if (!fieldtype.equals("37")
								&& !fieldtype.equals("9")) { //  多文档特殊处理





						    
						    if(fieldtype.equals("2") || fieldtype.equals("19")){
								%>
								
        <button type=button class="<%=fieldtype.equals("19")?"Clock":"calendar"%>" id="field<%=fieldid%>browser" name="field<%=fieldid%>browser" class=Browser   
		<%if (trrigerfield.indexOf("field" + fieldid) >= 0) {%>      onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',$G('field<%=fieldid%>').getAttribute('viewtype'));datainput('field<%=fieldid%>');"		
		<%} else {%>
		onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',$G('field<%=fieldid%>').getAttribute('viewtype'))"
		<%}%> 
		title="<%=SystemEnv.getHtmlLabelName(172,
											user.getLanguage())%>">

		</button>

							<%
								} else if(fieldtype.equals("58")){   //城市
                                    %>
                                    <div areaType="city" areaName="<%="field"+fieldid%>" areaValue="<%=fieldvalue %>"
                                    areaSpanValue="<%=Util.formatMultiLang(showname) %>"  areaMustInput="<%=isbrowisMust %>"  areaCallback="browAreaSelectCallback"  class="_areaselect" id="_areaselect_<%="field"+fieldid%>"></div>
                                    <script type="text/javascript">
                                     areromancedivbyid("_areaselect_<%="field"+fieldid%>",-1);
                                    </script>
                                    <% 
                                }else if(fieldtype.equals("263")){    //区县
                                    %>
                                    <div areaType="citytwo" areaName="<%="field"+fieldid%>" areaValue="<%=fieldvalue %>"
                                    areaSpanValue="<%=Util.formatMultiLang(showname) %>"  areaMustInput="<%=isbrowisMust %>"  areaCallback="browAreaSelectCallback"  class="_areaselect" id="_areaselect_<%="field"+fieldid%>"></div>
                                    <script type="text/javascript">
                                     areromancedivbyid("_areaselect_<%="field"+fieldid%>",-1);
                                    </script>
                                    <% 
                                    
                                } else {
						    
						    if (trrigerfield.indexOf("field" + fieldid) >= 0) {
						        bclick="onShowBrowser2('"+fieldid+"','"+url+"','"+linkurl+"','"+fieldtype+"',$G('field"+fieldid+"').getAttribute('viewtype'))";
						    } else {
						        bclick= "onShowBrowser2('"+fieldid+"','"+url+"','"+linkurl+"','"+fieldtype+"',$G('field"+fieldid+"').getAttribute('viewtype'));";
						    }
%>
  <brow:browser viewType="0" name='<%="field"+fieldid%>' browserValue='<%=fieldtype.equals("17") ? browfieldvalue : fieldvalue %>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldtype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldtype + ")"%>' width="auto" needHidden="false" defaultRow="99" onPropertyChange='<%="wfbrowvaluechange(this," + fieldid + ")" %>'
 hasAdd='<%=fieldtype.equals("17") + "" %>' addBtnClass="resAddGroupClass" addOnClick='<%="showrescommongroup(this, " + fieldid + ")" %>' idSplitFlag='<%=fieldtype.equals("17") ? "__":""%>' nameSplitFlag='<%=fieldtype.equals("17") ? "_____":""%>'
 browBtnDisabled='<%=fieldtype.equals("17") && isallres ? "true" : "" %>' addBtnDisabled ='<%=fieldtype.equals("17") && isallres ? "true" : "" %>' linkUrl='<%=linkurl%>' type='<%=fieldtype%>'> </brow:browser>
 
 <!-- 
        <button type=button id="field<%=fieldid%>browser" name="field<%=fieldid%>browser" class=Browser   
		<%if (trrigerfield.indexOf("field" + fieldid) >= 0) {%>      onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',$G('field<%=fieldid%>').getAttribute('viewtype'));datainput('field<%=fieldid%>');"		
		<%} else {%>
		onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',$G('field<%=fieldid%>').getAttribute('viewtype'))"
		<%}%> 
		title="<%=SystemEnv.getHtmlLabelName(172,
											user.getLanguage())%>">

		</button>
-->
	   			
       <%}
	   			       	} else if (fieldtype.equals("37")) { // 如果是多文档字段,加入新建文档按钮
	   			       	    bclick = "onShowBrowser2('" + fieldid + "','" + url + "','" + linkurl + "','" + fieldtype + "',$G('field" + fieldid + "').getAttribute('viewtype'))";
	   			       %>
	   			       
	   			       <!-- 
        <button type=button  class=AddDocFlow onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',$G('field<%=fieldid%>').getAttribute('viewtype'))" > <%=SystemEnv.getHtmlLabelName(611,
											user.getLanguage())%></button>&nbsp;&nbsp;<button type=button  class=AddDocFlow onclick="onNewDoc(<%=fieldid%>)" title="<%=SystemEnv.getHtmlLabelName(82,
											user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(82,
											user.getLanguage())%></button>
											-->
											
											
	<brow:browser viewType="0" name='<%="field"+fieldid%>' browserValue='<%=fieldvalue %>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldtype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldtype + ")"%>' width="auto" needHidden="false" defaultRow="99" onPropertyChange='<%="wfbrowvaluechange(this," + fieldtype + ")" %>' hasAdd="true" addOnClick='<%="onNewDoc(" + fieldid + ")"%>' linkUrl='<%=linkurl%>' type='<%=fieldtype%>'> </brow:browser>
       <%
       	} else if (fieldtype.equals("9") && fieldid.equals(flowDocField)&& docFlags.equals("1") ) {
       							if (!"1".equals(newTNflag)) {
       							    
       							 if (trrigerfield.indexOf("field"+ fieldid) >= 0) {  
       								bclick="onShowBrowser2('" + fieldid + "','" + url + "','" + linkurl + "','" + fieldtype + "',$G('field" + fieldid + "').getAttribute('viewtype'));";	
       							} else {
       							 	bclick="onShowBrowser2('" + fieldid + "','" + url + "','" + linkurl + "','" + fieldtype + "',$G('field" + fieldid + "').getAttribute('viewtype'))";
       							}
       						    boolean iscreatenewdoc = false;
       						    String createnewdocfun = "";
       							if (fieldtype.equals("9") && fieldid.equals(flowDocField)&&fieldvalue.equals("")) {
       							    iscreatenewdoc = true;
       							    createnewdocfun = "createDoc('" + fieldid + "','" + fieldvalue + "','1')";
       							}
       %>
       <brow:browser viewType="0" name='<%="field"+fieldid%>' browserValue='<%=fieldvalue %>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldtype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldtype + ")"%>' width="auto" needHidden="false" defaultRow="99" onPropertyChange='<%="wfbrowvaluechange(this," + fieldid + ")" %>'
       hasAdd='<%=iscreatenewdoc + "" %>' addOnClick='<%=createnewdocfun %>' addBtnID="createdoc" linkUrl='<%=linkurl%>' type='<%=fieldtype%>'> </brow:browser>
       <!-- 
		<button type=button id="field<%=fieldid%>browser" name="field<%=fieldid%>browser" class=Browser 
		<%if (trrigerfield.indexOf("field"+ fieldid) >= 0) {%>      onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',$G('field<%=fieldid%>').getAttribute('viewtype'));datainput('field<%=fieldid%>');"	
		<%} else {%>
		onclick="onShowBrowser2('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>',$G('field<%=fieldid%>').getAttribute('viewtype'))"
		<%}%> 
		title="<%=SystemEnv.getHtmlLabelName(172, user.getLanguage())%>">
		</button>
		 -->
	   <%
	   	    }else{
		        if(fieldvalue==null||fieldvalue.trim().equals("")){
					boolean iscreatenewdoc = false;
					String createnewdocfun = "";
					if (fieldtype.equals("9") && fieldid.equals(flowDocField)) {
						iscreatenewdoc = true;
						createnewdocfun = "createDoc('" + fieldid + "','" + fieldvalue + "','1')";
					}
%>
					<brow:browser viewType="0" browBtnDisabled="none" name='<%="field"+fieldid%>' browserValue='<%=showid%>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="false" isSingle='<%=BrowserManager.browIsSingle(fieldtype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldtype + ")"%>' width="auto" needHidden="false" defaultRow="99" onPropertyChange='<%="wfbrowvaluechange(this," + fieldid + ")" %>'
					hasAdd='<%=iscreatenewdoc + "" %>' addOnClick='<%=createnewdocfun %>'  addBtnID="createdoc"  linkUrl='<%=linkurl%>' type='<%=fieldtype%>'
					> </brow:browser>
<%
				}else{
				   boolean iscreatenewdoc = false;
				   String createnewdocfun = "";
				   if (fieldtype.equals("9") && fieldid.equals(flowDocField)) {
					   iscreatenewdoc = false;
					   createnewdocfun = "createDoc('" + fieldid + "','" + fieldvalue + "','1')";
				   }
%>
				   <brow:browser viewType="0" browBtnDisabled="none" name='<%="field"+fieldid%>' browserValue='<%=fieldvalue %>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="false" isSingle='<%=BrowserManager.browIsSingle(fieldtype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldtype + ")"%>' width="auto" needHidden="false" defaultRow="99" onPropertyChange='<%="wfbrowvaluechange(this," + fieldid + ")" %>'
				   hasAdd='<%=iscreatenewdoc + "" %>' addOnClick='<%=createnewdocfun %>' addBtnID="createdoc" linkUrl='<%=linkurl%>' type='<%=fieldtype%>'> </brow:browser>
<%
				}
	   	    }
	   	} else {
	   	    
	   	 if(trrigerfield.indexOf("field"+fieldid)>=0){
	   	     bclick="onShowBrowser3('" + fieldid + "','" + url + "','" + linkurl + "','" + fieldtype + "','" + ismand + "');datainput('field" + fieldid + "','" + ismand + "');";
		 } else {
			 bclick="onShowBrowser3('" + fieldid + "','" + url + "','" + linkurl + "','" + fieldtype + "','" + ismand + "')";
		 }
	   %>
	   <brow:browser viewType="0" name='<%="field"+fieldid%>' browserValue='<%=fieldvalue %>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldtype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + fieldtype + ")"%>' width="auto" needHidden="false" defaultRow="99" onPropertyChange='<%="wfbrowvaluechange(this," + fieldid + ")" %>' linkUrl='<%=linkurl%>' type='<%=fieldtype%>'> </brow:browser>
	   <!-- 
	    <button type=button id="field<%=fieldid%>browser" name="field<%=fieldid%>browser" class=Browser <%if(trrigerfield.indexOf("field"+fieldid)>=0){%>
	      onclick="onShowBrowser3('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>');datainput('field<%=fieldid%>','<%=ismand%>');"
	   <%} else {%>
		  onclick="onShowBrowser3('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>')"
	   <%}%> 
		  title="<%=SystemEnv.getHtmlLabelName(172, user.getLanguage())%>">
	    </button>
	     -->
		<%
			}
			
           %>
           </span>
            
           <%
           	}
           				}
      				
      	if(!isedit.equals("1") || !editbodyactionflag ||fieldtype.equals("2") || fieldtype.equals("19")){
           %>
           
        <span id="field<%=fieldid%>span"><%=showname%>
       <%
       	if (ismand.equals("1") && fieldvalue.equals("")) {
       %>
        <img src="/images/BacoError_wev8.gif" align=absmiddle>
       <%
       	}
       %>
        </span>
         
         <%
      	}
        	if (false && fieldtype.equals("134")) {
        %>
        <%=showname %>
        <%
        	}
        %>
        <%
        if (fieldtype.equals("87")||fieldtype.equals("184")) {
        %>
        &nbsp;&nbsp;<A href="/meeting/report/MeetingRoomPlan.jsp" target="blank"><%=SystemEnv.getHtmlLabelName(2193, user
									.getLanguage())%></A>
        <%
        	}
        %>
		   <%
		   	if (fieldtype.equals("9") || fieldtype.equals("161")|| fieldtype.equals("162")) {
			fieldvalue = fieldvalue.replace("\"", "&quot;");
		   %>
		    <input type=hidden viewtype="<%=ismand%>" name="field<%=fieldid%>"  id="field<%=fieldid%>" value="<%=fieldvalue%>" temptitle="<%=Util.toScreen(fieldlable, languageid)%>" onpropertychange="<%if(trrigerfield.indexOf("field"+fieldid)>=0){%>datainput('field<%=fieldid%>');<%}%>">
					<%if("1".equals(isTextInForm)){%>
					<div style="clear:both;height:650px;width:900px;overflow:hidden">
					<iframe id="ODocIframe" name="ODocIframe" src="/odoc/workflow/request/tableText.jsp?requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&formid=<%=formid%>" style="height:705px;width:99%">
					</iframe></div>	
			<script>
				jQuery("#ODocIframe").parent().parent().parent().children(".fieldnameClass").css("vertical-align","top");
				jQuery("#ODocIframe").parent().parent().parent().children(".fieldnameClass").css("line-height","22px");
			</script>					
					<%}%>
		   <%
		   	} else {
		   %>
		   <input type=hidden viewtype="<%=ismand%>" name="field<%=fieldid%>" id="field<%=fieldid%>" value="<%=fieldvalue%>"  temptitle="<%=Util.toScreen(fieldlable, languageid)%>" onpropertychange="checkLengthbrow('field<%=fieldid%>','field<%=fieldid%>span','<%=fieldlen%>','<%=Util.toScreen(fieldlable, languageid)%>','<%=SystemEnv.getHtmlLabelName(20246, user
									.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247, user
									.getLanguage())%>',$G('field<%=fieldid%>').getAttribute('viewtype'));<%if (trrigerfield.indexOf("field" + fieldid) >= 0) {%>datainput('field<%=fieldid%>')<%}%>">
			 <%
			 	}
			 %>
           <%=hiddenlinkvalue%>
       <%
       	if (changefieldsadd.indexOf(fieldid) >= 0) {
       %>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview, 0)
									+ Util.getIntValue(isedit, 0)
									+ Util.getIntValue(ismand, 0)%>" />
<%
	}
			} // 浏览按钮条件结束
			else if (fieldhtmltype.equals("4")) { // check框





%>
        <input type=checkbox viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable, languageid)%>" value=1 <%if (isedit.equals("0") || !editbodyactionflag) {%> DISABLED <%} else {%> name="field<%=fieldid%>" id="field<%=fieldid%>" <%}
						if (trrigerfield.indexOf("field" + fieldid) >= 0) {%> onChange="datainput('field<%=fieldid%>');" <%}%> <%if (fieldvalue.equals("1")) {%> checked <%}%> >
        <%
        	if (isedit.equals("0") || !editbodyactionflag) {
        %>
        <input type=hidden class=Inputstyle name="field<%=fieldid%>" id="field<%=fieldid%>" value="<%=fieldvalue.equals("")?"0":fieldvalue %>" >
        <%
        	}
        %>
       <%
       	if (changefieldsadd.indexOf(fieldid) >= 0) {
       %>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview, 0)
									+ Util.getIntValue(isedit, 0)
									+ Util.getIntValue(ismand, 0)%>" />
<%
	}
			} // check框条件结束





			else if (fieldhtmltype.equals("5")) { // 选择框   select
				//处理select字段联动
				String onchangeAddStr = "";
				int childfieldid_tmp = 0;
				if ("0".equals(isbill)) {
					rs_item
							.execute("select childfieldid from workflow_formdict where id="
									+ fieldid);
				} else {
					rs_item
							.execute("select childfieldid from workflow_billfield where id="
									+ fieldid);
				}
				if (rs_item.next()) {
					childfieldid_tmp = Util.getIntValue(rs_item
							.getString("childfieldid"), 0);
				}
				int firstPfieldid_tmp = 0;
				boolean hasPfield = false;
				if ("0".equals(isbill)) {
					rs_item
							.execute("select id from workflow_formdict where childfieldid="
									+ fieldid);
				} else {
					rs_item
							.execute("select id from workflow_billfield where childfieldid="
									+ fieldid);
				}
				while (rs_item.next()) {
					firstPfieldid_tmp = Util.getIntValue(rs_item
							.getString("id"), 0);
					if (fieldids.contains("" + firstPfieldid_tmp)) {
						hasPfield = true;
						break;
					}
				}
				if (childfieldid_tmp != 0) {//如果先出现子字段，则要把子字段下拉选项清空
					onchangeAddStr = "changeChildField(this, "
							+ fieldid + ", " + childfieldid_tmp + ")";
				}
				//添加事件信息
				String uploadMax = "";
				if (fieldid.equals(selectedfieldid) && uploadType == 1) {
					uploadMax = "changeMaxUpload('field" + fieldid
							+ "');reAccesoryChanage();";
				}
%>
        <script>
        	function funcField<%=fieldid%>(){
        	    changeshowattr('<%=fieldid%>_0', $GetEle('field<%=fieldid%>').value,-1,'<%=workflowid%>','<%=nodeid%>');
        	}
        	//window.attachEvent("onload", funcField<%=fieldid%>);
        	if (window.addEventListener){
        	    window.addEventListener("load", funcField<%=fieldid%>, false);
        	}else if (window.attachEvent){
        	    window.attachEvent("onload", funcField<%=fieldid%>);
        	}else{
        	    window.onload=funcField<%=fieldid%>;
        	}
        	//$(window).bind("load", funcField<%=fieldid%>);
        </script>
        <%
        if(!uploadMax.equals("")){
        %>
		<input type="hidden" id="uploadMaxField" name="uploadMaxField" isedit="<%=isedit %>" value="<%=fieldid%>" />
		<%
		}
		%>
        
        <select class=inputstyle notBeauty=true  viewtype="<%=ismand%>" temptitle="<%=Util.toScreen(fieldlable, languageid)%>" onBlur="checkinput2('field<%=fieldid%>','field<%=fieldid%>span',this.viewtype);" <%if (isedit.equals("0") || !editbodyactionflag) {%> name="disfield<%=fieldid%>" DISABLED <%} else {%> name="field<%=fieldid%>" id="field<%=fieldid%>" <%}%> onChange="<%=uploadMax%><%if (trrigerfield.indexOf("field" + fieldid) >= 0 && !(isedit.equals("0") || !editbodyactionflag)) {%>setTimeout(function() {datainput('field<%=fieldid%>')},500);<%}
						if (selfieldsadd.indexOf(fieldid) >= 0) {%>changeshowattr('<%=fieldid%>_0',this.value,-1,<%=workflowid%>,<%=nodeid%>);<%}%><%=onchangeAddStr%>"  >
	    <option value=""></option><!--added by xwj for td3297 20051130 -->
	   <%
	   	// 查询选择框的所有可以选择的值





	   				boolean checkempty = true;//xwj for td3313 20051206
	   				String finalvalue = "";//xwj for td3313 20051206
					String isAccordToSubCom="";
	   				if (hasPfield == false
	   						|| isedit.equals("0")
	   						|| (isaffirmancebody.equals("1") && !reEditbody
	   								.equals("1")) || isremark != 0
	   						|| nodetype.equals("3")) {
	   					rs.executeProc("workflow_SelectItemSelectByid", ""
	   							+ fieldid + flag + isbill);
	   					while (rs.next()) {
							if(!isedit.equals("0")){
							    int sltitemCancel = Util.getIntValue(rs.getString("cancel"), 0);
							    if (sltitemCancel == 1) {
						            continue;
						        }
							}
							isAccordToSubCom = Util.null2String(rs.getString("isAccordToSubCom"));
	   						String tmpselectvalue = Util.null2String(rs
	   								.getString("selectvalue"));
	   						String tmpselectname = Util.toScreen(rs
	   								.getString("selectname"), user
	   								.getLanguage());
	   						//获取选择目录的附件大小信息





	   						String tdocCategory = Util.toScreen(rs
	   								.getString("docCategory"), user
	   								.getLanguage());

							if(isAccordToSubCom.equals("1")){	    		    	
		    	int subCompanyIdfgs=0;
		    	try{
		    		subCompanyIdfgs=Util.getIntValue(ResourceComInfo.getSubCompanyID(""+user.getUID()),0);
		    	}catch(Exception ex){
		    		
		    	}
			    	
			    rsfgs2.executeSql("SELECT docCategory FROM Workflow_SelectitemObj where fieldid="+fieldid+" and selectvalue="+tmpselectvalue+" and  isBill="+isbill+" and objType='1' and objId= "+subCompanyIdfgs);		  
				while (rsfgs2.next()){
			    	 tdocCategory=Util.null2String(rsfgs2.getString("docCategory"));
					 
				   }

			   }	    

	   						String tMaxUploadFileSize = "";
	   						if (!"".equals(tdocCategory)
	   								&& fieldid.equals(selectedfieldid)
	   								&& uploadType == 1) {
	   							int tsecid = Util.getIntValue(tdocCategory
	   									.substring(tdocCategory
	   											.lastIndexOf(",") + 1), -1);
	   							tMaxUploadFileSize = ""
	   									+ Util
	   											.getIntValue(
	   													SecCategoryComInfo1
	   															.getMaxUploadFileSize(""
	   																	+ tsecid),
	   													5);
	   							secMaxUploads.put(tmpselectvalue,
	   									tMaxUploadFileSize);
	   							secCategorys.put(tmpselectvalue,
	   									tdocCategory);
	   							if (tmpselectvalue.equals(fieldvalue)) {
	   								maxUploadImageSize = Util.getIntValue(
	   										tMaxUploadFileSize, 5);
	   								docCategory = tdocCategory;
	   							}
	   						}
	   						/* -------- xwj for td3313 20051206 begin -*/
	   						if (tmpselectvalue.equals(fieldvalue)) {
	   							checkempty = false;
	   							finalvalue = tmpselectvalue;
	   						}
	   						/* -------- xwj for td3313 20051206 end -*/
	   %>
	    <option value="<%=tmpselectvalue%>" <%if (fieldvalue.equals(tmpselectvalue)) {%> selected <%}%>><%=tmpselectname%></option>
	   <%
	   	}
	   				} else {
	   					rs.executeProc("workflow_SelectItemSelectByid", ""
	   							+ fieldid + flag + isbill);
	   					while (rs.next()) {
							int sltitemCancel = Util.getIntValue(rs.getString("cancel"), 0);
							if (sltitemCancel == 1) {
						        continue;
						    }
							isAccordToSubCom = Util.null2String(rs.getString("isAccordToSubCom"));
	   						String tmpselectvalue = Util.null2String(rs
	   								.getString("selectvalue"));
	   						String tmpselectname = Util.toScreen(rs
	   								.getString("selectname"), user
	   								.getLanguage());
	   						/* -------- xwj for td3313 20051206 begin -*/
	   						if (tmpselectvalue.equals(fieldvalue)) {
	   							checkempty = false;
	   							finalvalue = tmpselectvalue;
	   						}
	   						//获取选择目录的附件大小信息





	   						String tdocCategory = Util.toScreen(rs
	   								.getString("docCategory"), user
	   								.getLanguage());


							if(isAccordToSubCom.equals("1")){	    		    	
		    	int subCompanyIdfgs=0;
		    	try{
		    		subCompanyIdfgs=Util.getIntValue(ResourceComInfo.getSubCompanyID(""+user.getUID()),0);
		    	}catch(Exception ex){
		    		
		    	}
			    	
			    rsfgs2.executeSql("SELECT docCategory FROM Workflow_SelectitemObj where fieldid="+fieldid+" and selectvalue="+tmpselectvalue+" and  isBill="+isbill+" and objType='1' and objId= "+subCompanyIdfgs);		  
				while (rsfgs2.next()){
			    	 tdocCategory=Util.null2String(rsfgs2.getString("docCategory"));
					 
				   }

			   }	   
	   						String tMaxUploadFileSize = "";
	   						if (!"".equals(tdocCategory)
	   								&& fieldid.equals(selectedfieldid)
	   								&& uploadType == 1) {
	   							int tsecid = Util.getIntValue(tdocCategory
	   									.substring(tdocCategory
	   											.lastIndexOf(",") + 1), -1);
	   							tMaxUploadFileSize = ""
	   									+ Util
	   											.getIntValue(
	   													SecCategoryComInfo1
	   															.getMaxUploadFileSize(""
	   																	+ tsecid),
	   													5);
	   							secMaxUploads.put(tmpselectvalue,
	   									tMaxUploadFileSize);
	   							secCategorys.put(tmpselectvalue,
	   									tdocCategory);
	   							if (tmpselectvalue.equals(fieldvalue)) {
	   								maxUploadImageSize = Util.getIntValue(
	   										tMaxUploadFileSize, 5);
	   								docCategory = tdocCategory;
	   							}
	   						}
		%>
		<option value="<%=tmpselectvalue%>" <%if(fieldvalue.equals(tmpselectvalue)){%> selected <%}%>><%=tmpselectname%></option>
		<%
	   					}
	   					selectInitJsStr += "doInitChildSelect(" + fieldid
	   							+ "," + firstPfieldid_tmp + ",\""
	   							+ finalvalue + "\");\n";
	   					initIframeStr += "<iframe id=\"iframe_"
	   							+ firstPfieldid_tmp
	   							+ "_"
	   							+ fieldid
	   							+ "_00\" frameborder=0 scrolling=no src=\"\"  style=\"display:none\"></iframe>";
	   				}
	   				if (selfieldsadd.indexOf(fieldid) >= 0)
	   					bodychangattrstr += "changeshowattr('" + fieldid
	   							+ "_0','" + finalvalue + "',-1,"
	   							+ workflowid + "," + nodeid + ");";
	   %>
	    </select>

	    <!--xwj for td3313 20051206 begin-->
	    <span id="field<%=fieldid%>span">
	    <%
	    	if (ismand.equals("1") && checkempty) {
	    %>
       <img src='/images/BacoError_wev8.gif' align=absMiddle>
      <%
      	}
      %>
	     </span>
	    <!--xwj for td3313 20051206 end-->

        <%
        	if (isedit.equals("0") || !editbodyactionflag) {
        %>
        <input type=hidden class=Inputstyle name="field<%=fieldid%>" id="field<%=fieldid%>" value="<%=finalvalue%>" temptitle="<%=Util.toScreen(fieldlable, languageid)%>"
            onpropertychange="datainput('field<%=fieldid%>')"
         >
        <%
        	}
        %>
       <%
       	if (changefieldsadd.indexOf(fieldid) >= 0) {
       %>
    <input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview, 0)
									+ Util.getIntValue(isedit, 0)
									+ Util.getIntValue(ismand, 0)%>" />
<%
	}
				//add by xhheng @20050310 for 附件上传
			} else if (fieldhtmltype.equals("6")) {
%>
          <%
          	if (isedit.equals("1") && editbodyactionflag) {
          		boolean nodownloadnew = true;
          		int AttachmentCountsnew = 0;
          		int linknumnew= -1;
          %>
          <!--modify by xhheng @20050511 for 1803-->
          <table cols=3 class="annexblocktblclass" id="field<%=fieldid%>_tab" style="border-collapse:collapse;border:0px;width:400px">
            <tbody >
            <col width="70%" >
            <col width="17%" >
            <col width="13%">
          <%
          	if ("-2".equals(fieldvalue)) {
          %>
			<tr>
				<td colSpan=3><font color="red">
				<%=SystemEnv.getHtmlLabelName(21710,
										languageidfromrequest)%></font>
				</td>
			</tr>
			  <%
			  	} else {
			  						fieldvalue = FileElement.delEmptyDicId(fieldvalue);
			  						if (!fieldvalue.equals("")) {
			  							sql = "select id,docsubject,accessorycount,SecCategory from docdetail where id in("
			  									+ fieldvalue + ") order by id asc";
			  							RecordSet.executeSql(sql);
			  							int AttachmentCounts=RecordSet.getCounts();
			  							AttachmentCountsnew = AttachmentCounts;
			  							int linknum = -1;
			  							boolean isfrist = false;
			  							int imgnum = fieldimgnum;
			  							while (RecordSet.next()) {
			  								isfrist = false;
			  								linknum++;
			  								String showid = Util
			  										.null2String(RecordSet
			  												.getString(1));
			  								String tempshowname = Util.toScreen(
			  										RecordSet.getString(2), user
			  												.getLanguage());
			  								int accessoryCount = RecordSet
			  										.getInt(3);
			  								String SecCategory = Util
			  										.null2String(RecordSet
			  												.getString(4));
			  								DocImageManager.resetParameter();
			  								DocImageManager.setDocid(Integer
			  										.parseInt(showid));
			  								DocImageManager.selectDocImageInfo();

			  								String docImagefileid = "";
			  								long docImagefileSize = 0;
			  								String docImagefilename = "";
			  								String fileExtendName = "";
			  								int versionId = 0;

			  								if (DocImageManager.next()) {
			  									//DocImageManager会得到doc第一个附件的最新版本





			  									docImagefileid = DocImageManager
			  											.getImagefileid();
			  									docImagefileSize = DocImageManager
			  											.getImageFileSize(Util
			  													.getIntValue(docImagefileid));
			  									docImagefilename = DocImageManager
			  											.getImagefilename();
			  									fileExtendName = docImagefilename
			  											.substring(
			  													docImagefilename
			  															.lastIndexOf(".") + 1)
			  											.toLowerCase();
			  									versionId = DocImageManager
			  											.getVersionId();
			  								}
			  								if (accessoryCount > 1) {
			  									fileExtendName = "htm";
			  								}
			  								boolean nodownload = SecCategoryComInfo1
			  										.getNoDownload(SecCategory)
			  										.equals("1") ? true : false;
			  								nodownloadnew = nodownload;
			  								String imgSrc = AttachFileUtil
			  										.getImgStrbyExtendName(
			  												fileExtendName, 20);

			  								if (fieldtype.equals("2")) {
			  									if (linknum == 0) {
			  										isfrist = true;
			  %>
			<% 
             if(!"1".equals(forbidAttDownload) && !nodownload && AttachmentCounts>1 && linknum==0){
            %>
            <tr> 
              <td class="fieldvalueClass" colSpan=3><nobr>
                  <button style="color:#123885;border:0px;line-height:20px;font-size:12px;padding:3px;background: #fff" type=button class=wffbtn accessKey=1  onclick="downloadsBatch('<%=fieldvalue%>','<%=requestid%>')">
                    [<%=SystemEnv.getHtmlLabelName(74,user.getLanguage())+SystemEnv.getHtmlLabelName(332,user.getLanguage())+SystemEnv.getHtmlLabelName(258,user.getLanguage())%>]
                  </button>              
              </td>
            </tr> 
            <%}%> 
            <tr>
                <td class="fieldvalueClass" colSpan=3>
                    <table cellspacing="0" cellpadding="0">
                        <tr>
              <%
              	}
              									if (imgnum > 0 && linknum >= imgnum) {
              										imgnum += fieldimgnum;
              										isfrist = true;
              %>
              </tr>
              <tr>
              <%
              	}
              %>
                  <input type=hidden name="field<%=fieldid%>_del_<%=linknum%>" value="0">
                  <input type=hidden name="field<%=fieldid%>_id_<%=linknum%>" value=<%=showid%>>
                  <td class="fieldvalueClass" <%if (!isfrist) {%>style="padding-left:15"<%}%>>
                     <table cellspacing="0" cellpadding="0">
                      <tr>
                          <td class="fieldvalueClass" colspan="2" align="center"><img src="/weaver/weaver.file.FileDownload?fileid=<%=docImagefileid%>&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>" style="cursor:hand;margin:auto;" alt="<%=docImagefilename%>" <%if (fieldimgwidth > 0) {%>width="<%=fieldimgwidth%>"<%}%> <%if (fieldimgheight > 0) {%>height="<%=fieldimgheight%>"<%}%> onclick="addDocReadTag('<%=showid%>');openAccessory('<%=docImagefileid%>')">
                          </td>
                      </tr>
                      <tr>
                              <%
                              	//创建节点，并且该流程允许创建人删除附件才有权限删除附件。





                              									if (!canDelAcc.equals("1")
                              											|| (canDelAcc.equals("1") && nodetype
                              													.equals("0"))) {
                              %>
                              <td class="fieldvalueClass" align="center"><nobr>
                                  <a href="#" style="text-decoration:underline" onmouseover="this.style.color='blue'" onclick='onChangeSharetype("span<%=fieldid%>_id_<%=linknum%>","field<%=fieldid%>_del_<%=linknum%>","<%=ismand%>",oUpload<%=fieldid%>);return false;'>[<span style="cursor:hand;color:black;"><%=SystemEnv
																.getHtmlLabelName(
																		91,
																		user
																				.getLanguage())%></span>]</a>
                                    <span id="span<%=fieldid%>_id_<%=linknum%>" name="span<%=fieldid%>_id_<%=linknum%>" style="visibility:hidden"><b><font COLOR="#FF0033">√</font></b><span></td>
                              <%
                              	}
                              									if (!nodownload) {
                              %>
                              <td class="fieldvalueClass" align="center"><nobr>
                                  <a href="#" style="text-decoration:underline" onmouseover="this.style.color='blue'" onclick="addDocReadTag('<%=showid%>');downloads('<%=docImagefileid%>');return false;">[<span  style="cursor:hand;color:black;"><%=SystemEnv
																.getHtmlLabelName(
																		258,
																		user
																				.getLanguage())%></span>]</a>
                              </td>
                              <%
                              	}
                              %>
                      </tr>
                        </table>
                    </td>
              <%
              	} else {
              %>
              <tr onmouseover="changecancleon(this)" onmouseout="changecancleout(this)" style="border-bottom:1px solid #e6e6e6;height: 40px;">
                <input type=hidden name="field<%=fieldid%>_del_<%=linknum%>" value="0" >
            <td class="fieldvalueClass" valign="middle" colSpan=3 style="word-break:normal;word-wrap:normal;">      
              <div style="float:left;height:40px; line-height:40px;width:270px;" class="fieldClassChange">
              <div style="float:left;width:20px;height:40px; line-height:40px;">
              <span style="display:inline-block;vertical-align: middle;padding-top:6px;">
              <%=imgSrc%>
			  </span>
              </div>
              <div style="float:left;">
              <span style="display:inline-block;width:245px;height:30px;padding-bottom:10px;overflow:hidden;white-space:nowrap;text-overflow:ellipsis;vertical-align: middle;">
              <%if(accessoryCount==1 && (Util.isExt(fileExtendName)||fileExtendName.equalsIgnoreCase("pdf"))){%>
                
                <a style="cursor:pointer;color:#8b8b8b!important;" onmouseover="changefileaon(this)" onmouseout="changefileaout(this)" onclick="addDocReadTag('<%=showid%>');openDocExt('<%=showid%>','<%=versionId%>','<%=docImagefileid%>',1)" title="<%=docImagefilename%>"><%=docImagefilename%></a>
              <%
                	} else {
                %>
                
                <a style="cursor:pointer;color:#8b8b8b!important;" onmouseover="changefileaon(this)" onmouseout="changefileaout(this)" onclick="addDocReadTag('<%=showid%>');openAccessory('<%=docImagefileid%>')" title="<%=docImagefilename%>"><%=docImagefilename%></a>
				

              <%
                	}
                %>
                </span>
              </div>
              </div>
              <input type=hidden name="field<%=fieldid%>_id_<%=linknum%>" value=<%=showid%>>
              
            
            <%
            	if (accessoryCount == 1) {
            %>
            
              <!-- 再次加一个nobr 标签 就可以 2012-08-28 ypc 修改 一行不该换行的元素换行 使用此标签 -->
              <div style="float:left;height:40px; line-height:40px;width:70px;padding-left:10px;" class="fieldClassChange">
              <span id = "selectDownload">
              	<nobr>
                <%
                	if((!Util.isExt(fileExtendName))||!nodownload){
                %>
                  <span style="width:45px;display:inline-block;color:#898989;margin-top:1px;"><%=docImagefileSize / 1000%>K</span>
				  <a style="display:inline-block;cursor:pointer;vertical-align:middle;width:20px;height:20px;margin-bottom:5px;background-image:url('/images/ecology8/workflow/fileupload/upload_wev8.png');" onclick="addDocReadTag('<%=showid%>');downloads('<%=docImagefileid%>')" title="<%=SystemEnv.getHtmlLabelName(31156,user.getLanguage())%>"></a>
                 
                <%
                	}
                %>
                </nobr>
              </span>
              </div>
            
            <%
            	}
            %>
            <%
            	//创建节点，并且该流程允许创建人删除附件才有权限删除附件。





            	if (!canDelAcc.equals("1")|| (canDelAcc.equals("1") && nodetype.equals("0"))) {
            %>
            
            	<div class="fieldClassChange" id="fieldCancleChange" style="float:left;width:50px;height:40px; line-height: 40px;text-align:center;">
	                <span id="span<%=fieldid%>_id_<%=linknum%>" name="span<%=fieldid%>_id_<%=linknum%>" style="display:none;">
	                	<a href="javascript:void(0);" style="display:inline-block;cursor:pointer;vertical-align:middle;width:20px;height:20px;background-image:url('/images/ecology8/workflow/fileupload/cancle_wev8.png');background-repeat :no-repeat;" type=button onclick='onChangeSharetypeNew(this,"span<%=fieldid%>_id_<%=linknum%>","field<%=fieldid%>_del_<%=linknum%>","<%=showid%>","<%=docImagefilename%>","<%=ismand%>",oUpload<%=fieldid%>)' title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></a>
	                </span>
                </div>
            
            <%
            	}
            %>
          </tr>
            <%
            	}
            							}
			  							linknumnew = linknum;
            							if (fieldtype.equals("2") && linknum > -1) {
            %>
            </tr></table></td></tr>
            <%
            	}
            %>
            <input type=hidden name="field<%=fieldid%>_idnum" value=<%=linknum + 1%>>
            <input type=hidden name="field<%=fieldid%>_idnum_1" value=<%=linknum + 1%>>
          <%
          	}
          					}
          %>
          <tr>
            <td class="fieldvalueClass" colspan=3>
             <%
             	String mainId = "";
             					String subId = "";
             					String secId = "";
             					if (docCategory != null && !docCategory.equals("")) {
             						if(docCategory.indexOf(',') == -1){
	             						mainId = "-1";
	             						subId = "-1";
	             						secId = docCategory;
             							
             						}else{
	             						mainId = docCategory.substring(0, docCategory
	             								.indexOf(','));
	             						subId = docCategory.substring(docCategory
	             								.indexOf(',') + 1, docCategory
	             								.lastIndexOf(','));
	             						secId = docCategory.substring(docCategory
	             								.lastIndexOf(',') + 1, docCategory
	             								.length());
             						}
             					}
             					String picfiletypes = "*.*";
             					String filetypedesc = "All Files";
             					if (fieldtype.equals("2")) {
             						picfiletypes = BaseBean.getPropValue(
             								"PicFileTypes", "PicFileTypes");
             						filetypedesc = "Images Files";
             					}
             					boolean canupload = true;
             					if (uploadType == 0) {
             						if ("".equals(mainId) && "".equals(subId)
             								&& "".equals(secId)) {
             							canupload = false;
             %>
           <font color="red"> <%=SystemEnv.getHtmlLabelName(17616,
											user.getLanguage())
											+ SystemEnv.getHtmlLabelName(92,
													user.getLanguage())
											+ SystemEnv.getHtmlLabelName(15808,
													user.getLanguage())%>!</font>
           <%
           	}
           					} else if (!isCanuse) {
           						canupload = false;
           %>
           <font color="red"> <%=SystemEnv.getHtmlLabelName(17616,
										user.getLanguage())
										+ SystemEnv.getHtmlLabelName(92, user
												.getLanguage())
										+ SystemEnv.getHtmlLabelName(15808,
												user.getLanguage())%>!</font>
           <%
           	}
           					if (canupload) {
           						uploadfieldids.add(fieldid);
           %>
            <script>
          var oUpload<%=fieldid%>;
          function fileupload<%=fieldid%>() {
			  var language =  <%=user.getLanguage()%> ;
			  //alert("===language===="+language);
			  var settings;
			    if (language == 8)
			  {
         settings = {
            flash_url : "/js/swfupload/swfupload.swf",
            upload_url: "/docs/docupload/MultiDocUploadByWorkflow.jsp",    // Relative to the SWF file
            post_params: {
                "mainId": "<%=mainId%>",
                "subId":"<%=subId%>",
                "secId":"<%=secId%>",
                "userid":"<%=user.getUID()%>",
                "logintype":"<%=user.getLogintype()%>",
                "workflowid":"<%=workflowid%>"
            },
            file_size_limit :"<%=maxUploadImageSize%> MB",
            file_types : "<%=picfiletypes%>",
            file_types_description : "<%=filetypedesc%>",
            file_upload_limit : 100,
            file_queue_limit : 0,
            custom_settings : {
                progressTarget : "fsUploadProgress<%=fieldid%>",
                cancelButtonId : "btnCancel<%=fieldid%>",
                uploadspan : "field_<%=fieldid%>span",
                uploadfiedid : "field<%=fieldid%>"
            },
            debug: false,
            button_image_url : "/images/ecology8/workflow/fileupload/begin1_wev8-2.png",
            button_placeholder_id : "spanButtonPlaceHolder<%=fieldid%>",
            button_width: 144,
            button_height: 26,
            //button_text : '<span class="button"><%=SystemEnv.getHtmlLabelName(21406,user.getLanguage())%></span>',
            //button_text_style : '.button { font-family: Helvetica, Arial, sans-serif; font-size: 12pt; } .buttonSmall { font-size: 10pt; }',
            button_text_top_padding: 0,
            button_text_left_padding: 18,
            button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
            button_cursor: SWFUpload.CURSOR.HAND,

            // The event handler functions are defined in handlers.js
            file_queued_handler : fileQueued,
            file_queue_error_handler : fileQueueError,
            file_dialog_complete_handler : fileDialogComplete_1,
            upload_start_handler : uploadStart,
            upload_progress_handler : uploadProgress,
            upload_error_handler : uploadError,
            upload_success_handler : uploadSuccess_1,
            upload_complete_handler : uploadComplete_1,
            queue_complete_handler : queueComplete    // Queue plugin event
        };
			  }else{
			  settings = {
            flash_url : "/js/swfupload/swfupload.swf",
            upload_url: "/docs/docupload/MultiDocUploadByWorkflow.jsp",    // Relative to the SWF file
            post_params: {
                "mainId": "<%=mainId%>",
                "subId":"<%=subId%>",
                "secId":"<%=secId%>",
                "userid":"<%=user.getUID()%>",
                "logintype":"<%=user.getLogintype()%>",
                "workflowid":"<%=workflowid%>"
            },
            file_size_limit :"<%=maxUploadImageSize%> MB",
            file_types : "<%=picfiletypes%>",
            file_types_description : "<%=filetypedesc%>",
            file_upload_limit : 100,
            file_queue_limit : 0,
            custom_settings : {
                progressTarget : "fsUploadProgress<%=fieldid%>",
                cancelButtonId : "btnCancel<%=fieldid%>",
                uploadspan : "field_<%=fieldid%>span",
                uploadfiedid : "field<%=fieldid%>"
            },
            debug: false,
            button_image_url : "/images/ecology8/workflow/fileupload/begin1_wev8-0.png",
            button_placeholder_id : "spanButtonPlaceHolder<%=fieldid%>",
            button_width: 104,
            button_height: 26,
            button_text : '<span class="button"><%=SystemEnv.getHtmlLabelName(21406,user.getLanguage())%></span>',
            button_text_style : '.button { font-family: Microsoft YaHei; font-size: 12px;color:#ffffff;} .buttonSmall { font-size: 10px; }',
			button_text_top_padding: 2,
			button_text_left_padding: 22,
            button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
            button_cursor: SWFUpload.CURSOR.HAND,

            // The event handler functions are defined in handlers.js
            file_queued_handler : fileQueued,
            file_queue_error_handler : fileQueueError,
            file_dialog_complete_handler : fileDialogComplete_1,
            upload_start_handler : uploadStart,
            upload_progress_handler : uploadProgress,
            upload_error_handler : uploadError,
            upload_success_handler : uploadSuccess_1,
            upload_complete_handler : uploadComplete_1,
            queue_complete_handler : queueComplete    // Queue plugin event
			  
			  };
			  }


        try {
            oUpload<%=fieldid%>=new SWFUpload(settings);
        } catch(e) {
            alert(e)
        }
    }
        	//window.attachEvent("onload", fileupload<%=fieldid%>);
        	//$(window).bind("load", fileupload<%=fieldid%>);
          	if (window.addEventListener){
	      	    window.addEventListener("load", fileupload<%=fieldid%>, false);
	      	}else if (window.attachEvent){
	      	    window.attachEvent("onload", fileupload<%=fieldid%>);
	      	}else{
	      	    window.onload=funcField<%=fieldid%>;
	      	}
        </script>
      <TABLE class="ViewForm">
          <tr>
              <td colspan="2" style="background-color:#ffffff;">
                  <div style="height: 32px;vertical-align:middle;width: 450px;">
                  <span id="uploadspan" style="display:inline-block;line-height: 32px;"><%=SystemEnv.getHtmlLabelName(83523,user.getLanguage())%><%=maxUploadImageSize%><%=SystemEnv.getHtmlLabelName(83528,user.getLanguage())%></span>
				  <%
				  if(ismand.equals("1") && fieldvalue.equals("")) {
				  %>
				  <span id="field_<%=fieldid%>span" style='display:inline-block;line-height: 32px;color:red;font-weight:normal;'><%=SystemEnv.getHtmlLabelName(81909,user.getLanguage())%></span>
				  <%
					}else{
				  %>
				  <span id="field_<%=fieldid%>span" style='display:inline-block;line-height: 32px;color:red;font-weight:normal;'></span>
				  <%
					}
			   	  %>
				  </div>
                  <div style="height: 30px;">
                  <div style="float:left;">
                  <span>
                  	<span id="spanButtonPlaceHolder<%=fieldid%>"></span><!--选取多个文件-->
                  </span>
                  </div>
				<%--<span style="color:#262626;cursor:hand;TEXT-DECORATION:none" disabled onclick="oUpload<%=fieldid%>.cancelQueue();showmustinput(oUpload<%=fieldid%>);" id="btnCancel<%=fieldid%>">
					<span><img src="/js/swfupload/delete_wev8.gif" border="0"></span>
					<span style="height:19px"><font style="margin:0 0 0 -1"><%=SystemEnv.getHtmlLabelName(21407,
						user.getLanguage())%></font><!--清除所有选择--></span> 
				</span>--%>
				<div style="width:10px!important;height:3px;float:left;"></div>
				
				<div style="height: 30px;float:left;">
				<%--
				<span style="display:inline-block;height:25px;cursor:pointer;text-align:center;vertical-align:middle;line-height:25px;background-color: #aaaaaa;color:#ffffff;padding:0 20px 0 14px;" onclick="clearAllQueue(oUpload<%=fieldid%>);showmustinput(oUpload<%=fieldid%>);"><img src='/images/ecology8/workflow/fileupload/clearall_wev8.png' style="width:20px;height:20px;padding-bottom:2px;" align=absMiddle><%= SystemEnv.getHtmlLabelName(21407,user.getLanguage())%></span>
                 --%>
                <button type="button" id="btnCancel<%=fieldid%>" disabled style="height:25px;cursor:pointer;text-align:center;vertical-align:middle;line-height:23px;background-color: #dfdfdf;color:#999999;padding:0 10px 0 4px;" onclick="clearAllQueue(oUpload<%=fieldid%>);showmustinput(oUpload<%=fieldid%>);" onmouseover="changebuttonon(this)" onmouseout="changebuttonout(this)"><img src='/images/ecology8/workflow/fileupload/clearallenable_wev8.png' style="width:20px;height:20px;" align=absMiddle><%= SystemEnv.getHtmlLabelName(21407,user.getLanguage())%></button>
		        
                <span id="field<%=fieldid%>spantest" style="display:none;">
				<%
					if (ismand.equals("1") && fieldvalue.equals("")) {
				%>
			   <img src='/images/BacoError_wev8.gif' align=absMiddle>
			   <%
			  	}
			   %>
	     		</span>
	     		</div>
	     		<div style="width:10px!important;height:3px;float:left;"></div>
	     		<div style="height: 30px;float:left;">
     	<% 
           //if(isDownloadAll && AttachmentCounts>1 && (linknum+1)==AttachmentCounts){
           if(!"1".equals(forbidAttDownload) && !nodownloadnew && AttachmentCountsnew>1 && linknumnew>=0){
         %>
         <button type="button" id="field_upload_<%=fieldid%>" onclick="downloadsBatch('<%=fieldvalue%>','<%=requestid%>')" style="display:inline-block;height:25px;cursor:pointer;text-align:center;vertical-align:middle;line-height:25px;background-color: #6bcc44;color:#ffffff;padding:0 10px 0 4px;" onmouseover="uploadbuttonon(this)" onmouseout="uploadbuttonout(this)"><img src='/images/ecology8/workflow/fileupload/uploadall_wev8.png' style="width:20px;height:20px;padding-bottom:2px;" align=absMiddle><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())+SystemEnv.getHtmlLabelName(258,user.getLanguage())%></button>
         <%--<button style="color:#123885;border:0px;line-height:20px;font-size:12px;padding:3px;background: #fff" type=button class=wffbtn accessKey=1  onclick="downloadsBatch('<%=fieldvalue%>','<%=requestid%>')">
           [<%=SystemEnv.getHtmlLabelName(332,user.getLanguage())+SystemEnv.getHtmlLabelName(258,user.getLanguage())%>]
         </button> --%>
         <%}%> 
              </div>
              <div style="clear:both;"></div>
              </div>
                  <input  class=InputStyle  type=hidden size=60 name="field<%=fieldid%>" id="field<%=fieldid%>" temptitle="<%=Util.toScreen(fieldlable,
												languageid)%>"  viewtype="<%=ismand%>" value="<%=fieldvalue%>">
              </td>
          </tr>
          <tr>
              <td colspan="2" style="background-color:#ffffff;">
                  <div class="_uploadForClass">
	                  <div class="fieldset flash" id="fsUploadProgress<%=fieldid%>">
	                  </div>
                  </div>
                  <div id="divStatus<%=fieldid%>"></div>
              </td>
          </tr>
      </TABLE>
            <%
            	}
            %>
          <input type=hidden name='mainId' value=<%=mainId%>>
          <input type=hidden name='subId' value=<%=subId%>>
          <input type=hidden name='secId' value=<%=secId%>>
             </td>
          </tr>
      </TABLE>
          <%
          	} else {
            fieldvalue = FileElement.delEmptyDicId(fieldvalue);
          					if (!fieldvalue.equals("")) {
          						boolean nodownloadnew1 = true;
          		          		int AttachmentCountsnew1 = 0;
          		          		int linknumnew1= -1;
          %>
          <table cols=3 id="field<%=fieldid%>_tab">
            <tbody >
            <col width="70%" >
            <col width="17%" >
            <col width="13%">
            <%
            	sql = "select id,docsubject,accessorycount,SecCategory from docdetail where id in("
            								+ fieldvalue + ") order by id asc";
            						int linknum = -1;
            						RecordSet.executeSql(sql);
            						int AttachmentCounts=RecordSet.getCounts();
            						AttachmentCountsnew1 = AttachmentCounts;
            						boolean isfrist = false;
            						int imgnum = fieldimgnum;
            						while (RecordSet.next()) {
            							isfrist = false;
            							linknum++;
            							String showid = Util.null2String(RecordSet
            									.getString(1));
            							String tempshowname = Util.toScreen(
            									RecordSet.getString(2), user
            											.getLanguage());
            							int accessoryCount = RecordSet.getInt(3);
            							String SecCategory = Util
            									.null2String(RecordSet.getString(4));
            							DocImageManager.resetParameter();
            							DocImageManager.setDocid(Integer
            									.parseInt(showid));
            							DocImageManager.selectDocImageInfo();

            							String docImagefileid = "";
            							long docImagefileSize = 0;
            							String docImagefilename = "";
            							String fileExtendName = "";
            							int versionId = 0;

            							if (DocImageManager.next()) {
            								docImagefileid = DocImageManager
            										.getImagefileid();
            								docImagefileSize = DocImageManager
            										.getImageFileSize(Util
            												.getIntValue(docImagefileid));
            								docImagefilename = DocImageManager
            										.getImagefilename();
            								fileExtendName = docImagefilename
            										.substring(
            												docImagefilename
            														.lastIndexOf(".") + 1)
            										.toLowerCase();
            								versionId = DocImageManager
            										.getVersionId();
            							}
            							if (accessoryCount > 1) {
            								fileExtendName = "htm";
            							}
            							String imgSrc = AttachFileUtil
            									.getImgStrbyExtendName(
            											fileExtendName, 20);
            							boolean nodownload = SecCategoryComInfo1
            									.getNoDownload(SecCategory).equals(
            											"1") ? true : false;
            							nodownloadnew1 = nodownload;
            							if (fieldtype.equals("2")) {
            								if (linknum == 0) {
            									isfrist = true;
            %>
			<% 
             if(!"1".equals(forbidAttDownload) && !nodownload && AttachmentCounts>1 && linknum==0){
            %>              
            <tr> 
              <td colSpan=3 class="fieldvalueClass"><nobr>
                  <button style="color:#123885;border:0px;line-height:20px;font-size:12px;padding:3px;background: #fff" type=button class=wffbtn accessKey=1  onclick="downloadsBatch('<%=fieldvalue%>','<%=requestid%>')">
                    [<%=SystemEnv.getHtmlLabelName(74,user.getLanguage())+SystemEnv.getHtmlLabelName(332,user.getLanguage())+SystemEnv.getHtmlLabelName(258,user.getLanguage())%>]
                  </button>           
              </td>
            </tr> 
           <%}%>
            <tr>
                <td colSpan=3 class="fieldvalueClass" >
                    <table cellspacing="0" cellpadding="0">
                        <tr>
              <%
              	}
              								if (imgnum > 0 && linknum >= imgnum) {
              									imgnum += fieldimgnum;
              									isfrist = true;
              %>
              </tr>
              <tr>
              <%
              	}
              %>
                  <input type=hidden name="field<%=fieldid%>_del_<%=linknum%>" value="0">
                  <input type=hidden name="field<%=fieldid%>_id_<%=linknum%>" value=<%=showid%>>
                  <td class="fieldvalueClass" <%if (!isfrist) {%>style="padding-left:15"<%}%>>
                     <table cellspacing="0" cellpadding="0">
                      <tr>
                          <td class="fieldvalueClass" colspan="2" align="center"><img src="/weaver/weaver.file.FileDownload?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&fileid=<%=docImagefileid%>&requestid=<%=requestid%>" style="cursor:hand;margin:auto;" alt="<%=docImagefilename%>" <%if (fieldimgwidth > 0) {%>width="<%=fieldimgwidth%>"<%}%> <%if (fieldimgheight > 0) {%>height="<%=fieldimgheight%>"<%}%> onclick="addDocReadTag('<%=showid%>');openAccessory('<%=docImagefileid%>')">
                          </td>
                      </tr>
                      <tr>
                              <%
                              	if (!nodownload) {
                              %>
                              <td class="fieldvalueClass" align="center"><nobr>
                                  <a href="#" style="text-decoration:underline" onmouseover="this.style.color='blue'" onclick="addDocReadTag('<%=showid%>');downloads('<%=docImagefileid%>');return false;">[<span  style="cursor:hand;color:black;"><%=SystemEnv
													.getHtmlLabelName(258, user
															.getLanguage())%></span>]</a>
                              </td>
                              <%
                              	}
                              %>
                      </tr>
                        </table>
                    </td>
              <%
              	} else {
              %>
              <tr style="border-bottom:1px solid #e6e6e6;height: 40px;">
                <input type=hidden name="field<%=fieldid%>_del_<%=linknum%>" value="0">
                <td class="fieldvalueClass" colspan=3 valign="middle" style="word-break:normal;word-wrap:normal;">
                <div style="float:left;height:40px; line-height:40px;width:310px;" class="fieldClassChange">
              <div style="float:left;width:20px;height:40px; line-height:40px;">
              <span style="display:inline-block;vertical-align: middle;padding-top:6px;">
              <%=imgSrc%>
			  </span>
              </div>
              <div style="float:left;">
              <span style="display:inline-block;width:285px;height:30px;padding-bottom:10px;overflow:hidden;white-space:nowrap;text-overflow:ellipsis;vertical-align: middle;">
              <%if(accessoryCount==1 && (Util.isExt(fileExtendName)||fileExtendName.equalsIgnoreCase("pdf"))){%>
                <a style="cursor:pointer;color:#8b8b8b!important;" onmouseover="changefileaon(this)" onmouseout="changefileaout(this)" onclick="addDocReadTag('<%=showid%>');openDocExt('<%=showid%>','<%=versionId%>','<%=docImagefileid%>',0)" title="<%=docImagefilename%>"><%=docImagefilename%></a>
              <%
                	} else {
                %>
                <a style="cursor:pointer;color:#8b8b8b!important;" onmouseover="changefileaon(this)" onmouseout="changefileaout(this)" onclick="addDocReadTag('<%=showid%>');openAccessory('<%=docImagefileid%>')" title="<%=docImagefilename%>"><%=docImagefilename%></a>
              <%
                	}
                %>
                </span>
              </div>
              </div>
              <input type=hidden name="field<%=fieldid%>_id_<%=linknum%>" value=<%=showid%>>
            <%
            	if (accessoryCount == 1) {
            %>
              <!-- 再次加一个nobr 标签 就可以 2012-08-28 ypc 修改 一行不该换行的元素换行 使用此标签 -->
              <div style="float:left;height:40px; line-height:40px;width:70px;padding-left:10px;padding-right:10px;" class="fieldClassChange">
              <span id = "selectDownload">
              	<nobr>
                <%
                	if((!Util.isExt(fileExtendName))||!nodownload){
                %>
                  <span style="width:45px;display:inline-block;color:#898989;margin-top:1px;"><%=docImagefileSize / 1000%>K</span>
				  <a style="display:inline-block;cursor:pointer;vertical-align:middle;width:20px;height:20px;margin-bottom:5px;background-image:url('/images/ecology8/workflow/fileupload/upload_wev8.png');" onclick="addDocReadTag('<%=showid%>');downloads('<%=docImagefileid%>')" title="<%=SystemEnv.getHtmlLabelName(31156,user.getLanguage())%>"></a>
                <%
                	}
                %>
                </nobr>
              </span>
              </div>
            <%
            	}
            %>

                <!--  -->
              
              </td>
          </tr>
            <%
            	}
					}
					linknumnew1 = linknum;
					if (fieldtype.equals("2") && linknum > -1) {
            %>
            </tr></table></td></tr>
            <%
            	}
            %>
             <tr>
            <td class="fieldvalueClass" valign="middle" colSpan=3> 
            	<% 
                   if(!"1".equals(forbidAttDownload) && !nodownloadnew1 && AttachmentCountsnew1>1 && linknumnew1>=0){
                 %>
                 <span onclick="downloadsBatch('<%=fieldvalue%>','<%=requestid%>')" style="display:inline-block;height:25px;cursor:pointer;text-align:center;vertical-align:middle;line-height:25px;background-color: #6bcc44;color:#ffffff;padding:0 20px 0 14px;" onmouseover="uploadbuttonon(this)" onmouseout="uploadbuttonout(this)"><img src='/images/ecology8/workflow/fileupload/uploadall_wev8.png' style="width:20px;height:20px;padding-bottom:2px;" align=absMiddle><%=SystemEnv.getHtmlLabelName(332,languageidfromrequest)+SystemEnv.getHtmlLabelName(258,languageidfromrequest)%></span>
                 <%}%>
	         </td>
            </tr>
            
              <input type=hidden name="field<%=fieldid%>_idnum" value=<%=linknum + 1%>><!--xwj for td2893 20051017-->
              <input type=hidden name="field<%=fieldid%>" id="field<%=fieldid%>" value=<%=fieldvalue%>>
              </tbody>
              </table>
              <%
              	}
              				}
          	if(changefieldsadd.indexOf(fieldid)>=0){
    			%>
    				<input type=hidden name="oldfieldview<%=fieldid%>" value="<%=Util.getIntValue(isview,0)+Util.getIntValue(isedit,0)+Util.getIntValue(ismand,0)%>" />
    			<%
    		}
      	} // 选择框条件结束 所有条件判定结束
		else if (fieldhtmltype.equals("7")) {//特殊字段
			if (isbill.equals("0"))
				out.println(Util.null2String((String) specialfield.get(fieldid + "_0")));
			else
				out.println(Util.null2String((String) specialfield.get(fieldid + "_1")));
		}
		else if(fieldhtmltype.equals("9")){	//位置字段
		    //LocationElement.getHtmlElementString();	
			String locateData = LocateUtil.joinLoctionsField(workflowid,requestid,fieldname,fieldid,fieldvalue,user);

			String[] htmljs = locateData.split(LocateUtil.SPLIT_HTMLJS);
			out.println(htmljs[0]);
			out.println("<script language='javascript'>\n"+htmljs[1] + "</script>\n");
		}
          
      %>
      </td>
    </tr><tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>

<%
	} else { // 不显示的作为 hidden 保存信息
			if (fieldhtmltype.equals("6")) {
				if (!fieldvalue.equals("")) {
					ArrayList fieldvalueas = Util.TokenizerString(
							fieldvalue, ",");
					// sql="select id,docsubject,accessorycount from docdetail where id in("+fieldvalue+") order by id asc";
					// RecordSet.executeSql(sql);
					int linknum = -1;
					for (int j = 0; j < fieldvalueas.size(); j++) {
						linknum++;
						String showid = Util.null2String(""
								+ fieldvalueas.get(j));
%>
            <input type=hidden name="field<%=fieldid%>_id_<%=linknum%>"  value=<%=showid%>>

          <%
          	}
          %><input type=hidden name="field<%=fieldid%>_idnum" value=<%=linknum + 1%>>
          <%
          	}
          			}

          			if (fieldhtmltype.equals("2") && fieldtype.equals("2")) {
          %>
	<textarea name="field<%=fieldid%>" id="field<%=fieldid%>" style="display:none"><%=fieldvalue%></textarea>
	<%
		} else {
	%>
    <input type=hidden name="field<%=fieldid%>" id="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue, user
								.getLanguage())%>" >
<%
	}
		}
%>
<%
	} // 循环结束
%>

</table>
<%=initIframeStr%>
<!--#######明细表 Start#######-->
<%
	//@ include file="/workflow/request/WorkflowManageRequestDetailBody.jsp"
%>
<!--#######明细表 END#########-->
<!-- 给一下input隐藏域添加id 供其他页面 通过getElementById()取值 2012-08-0-29 ypc 修改 -->

<input type=hidden name="requestid" id="requestid" value=<%=requestid%>>           <!--请求id-->
<input type=hidden name="workflowid" id="workflowid" value="<%=workflowid%>">       <!--工作流id-->
<input type=hidden name="workflowtype" id="workflowtype" value="<%=workflowtype%>">       <!--工作流类型-->
<input type=hidden name="nodeid" id="nodeid" value="<%=nodeid%>">               <!--当前节点id-->
<input type=hidden name="nodetype" id="nodetype" value="<%=nodetype%>">                     <!--当前节点类型-->
<input type=hidden name="src">                                <!--操作类型 save和submit,reject,delete-->
<input type=hidden name="iscreate" id="iscreate" value="0">                     <!--是否为创建节点 是:1 否 0 -->
<input type=hidden name="formid" id="formid" value="<%=formid%>">               <!--表单的id-->
<input type=hidden name ="isbill" id="isbill" value="<%=isbill%>">            <!--是否单据 0:否 1:是-->
<input type=hidden name="billid" id="billid" value="<%=billid%>">             <!--单据id-->

<input type=hidden name ="method">                                <!--新建文档时候 method 为docnew-->
<input type=hidden name ="topage" id="topage" value="<%=topage%>">				<!--返回的页面-->
<input type=hidden name ="needcheck" id="needcheck" value="<%=needcheck%>">
<input type=hidden name ="inputcheck" id="inputcheck" value="">

<input type=hidden name ="isMultiDoc" id="isMultiDoc" value=""><!--多文档新建-->

<input type=hidden name="rand" id="rand" value="<%=System.currentTimeMillis()%>">
<input type=hidden name="needoutprint" id="needoutprint" value="">
<div style="height:0px!important;">
<iframe name="delzw" width=0 height=0 style="border:none;height:0px!important;"></iframe>
</div>

<%
String fieldids_str = Util.listToString(fieldids);
String managefckfields_body_str = Util.listToString(managefckfields_body);
%>

<script language="javascript">

//默认大小
var uploadImageMaxSize = <%=maxUploadImageSize%>;
var uploaddocCategory="<%=docCategory%>";
var uploadCategorys=new Array();
//填充选择目录的附件大小信息





var selectValues = new Array();
var maxUploads = new Array();
function setMaxUploadInfo()
{
<%if (secMaxUploads != null && secMaxUploads.size() > 0) {
				Set selectValues = secMaxUploads.keySet();

				for (Iterator i = selectValues.iterator(); i.hasNext();) {
					String value = (String) i.next();
					String maxUpload = (String) secMaxUploads.get(value);
					String uplCategory = (String) secCategorys.get(value);%>
		selectValues.push('<%=value%>');
		maxUploads.push('<%=maxUpload%>');
        uploadCategorys.push('<%=uplCategory%>');
<%}
			}%>
}
setMaxUploadInfo();
//目录发生变化时，重新检测文件大小





function reAccesoryChanage()
{
	<%for (int i = 0; i < uploadfieldids.size(); i++) {%>
    checkfilesize(oUpload<%=uploadfieldids.get(i)%>,uploadImageMaxSize,uploaddocCategory);
    showmustinput(oUpload<%=uploadfieldids.get(i)%>);
    <%}%>
	
	checkfilesize2();
	
	try{
	    if(!!reAccesoryChanageDetail && typeof reAccesoryChanageDetail == "function"){
	    	reAccesoryChanageDetail();
	    }
	}catch(e){}
}


function changeMaxUpload2(fieldid,derecorderindex){

    var uploadMaxFieldisedit = jQuery("#uploadMaxField").attr("isedit");
   
    if(!!uploadMaxFieldisedit && uploadMaxFieldisedit=="1"){
	    var selectfieldv = jQuery("#"+fieldid).val();
		for(var i = 0;i<selectValues.length;i++)
		{
			var value = selectValues[i];
			if(value == selectfieldv)
			{
				uploadImageMaxSize = parseFloat(maxUploads[i]);
                uploaddocCategory=uploadCategorys[i];
			}
		}
		
		jQuery("#selectfieldvalue").val(selectfieldv);
		
		if(selectfieldv=="")
		{
			uploaddocCategory = "";
			uploadImageMaxSize = 5;
			maxUploadImageSize = 5;
			//var fieldlable = jQuery("#"+fieldid).attr("temptitle");
			var fieldlable = "<%=selectfieldlable%>";
			jQuery("span[id^='uploadspan']").each(function(){
				jQuery(this).html("<%=SystemEnv.getHtmlLabelName(125389,user.getLanguage())%> \""+fieldlable+"\"");
			});
		}else{
			maxUploadImageSize = uploadImageMaxSize;
			jQuery("span[id^='uploadspan_"+derecorderindex+"']").each(function(){
				jQuery(this).html("<%=SystemEnv.getHtmlLabelName(83523,user.getLanguage())%>"+uploadImageMaxSize+"<%=SystemEnv.getHtmlLabelName(83528,user.getLanguage())%>");
			});
		}
	}else{
	
	
    <%
	if(uploadType==1){
	    if(selectfieldvalue.equals("")){
	%>
			uploadImageMaxSize = 5;
			maxUploadImageSize = 5;
			uploaddocCategory = "";
			//var fieldlable = jQuery("#"+fieldid).attr("temptitle");
			var fieldlable = "<%=selectfieldlable%>";
			
			jQuery("span[id^='uploadspan_"+derecorderindex+"']").each(function(){
				jQuery(this).html("<%=SystemEnv.getHtmlLabelName(125389,user.getLanguage())%> \""+fieldlable+"\"");
			});
	<%  }else{%>
	        for(var i = 0;i<selectValues.length;i++)
			{
				var value = selectValues[i];
				if(value == "<%=selectfieldvalue%>")
				{
					uploadImageMaxSize = parseFloat(maxUploads[i]);
                	uploaddocCategory=uploadCategorys[i];
				}
			}
			jQuery("span[id^='uploadspan_"+derecorderindex+"']").each(function(){
				jQuery(this).html("<%=SystemEnv.getHtmlLabelName(83523,user.getLanguage())%>"+uploadImageMaxSize+"<%=SystemEnv.getHtmlLabelName(83528,user.getLanguage())%>");
				maxUploadImageSize = uploadImageMaxSize;
			});
	<%
		}
	}
	%>
	
	}
}


//选择目录时，改变对应信息
function changeMaxUpload(fieldid)
{
	var efieldid = $GetEle(fieldid);
	if(efieldid)
	{
		var tselectValue = efieldid.value;
		for(var i = 0;i<selectValues.length;i++)
		{
			var value = selectValues[i];
			if(value == tselectValue)
			{
				uploadImageMaxSize = parseFloat(maxUploads[i]);
                uploaddocCategory=uploadCategorys[i];
			}
		}
		
		var oUploadArray = new Array();
		var oUploadfieldidArray = new Array();
		<%
		if(uploadfieldids!=null){
		   	for(int i=0;i<uploadfieldids.size();i++){
		   %>
		oUploadArray.push(oUpload<%=uploadfieldids.get(i)%>);
		oUploadfieldidArray.push("<%=uploadfieldids.get(i)%>");
		<%
			}
		}
		%>
		
		jQuery("#selectfieldvalue").val(tselectValue);
		
		if(tselectValue=="")
		{
			uploadImageMaxSize = 5;
			maxUploadImageSize =5;
			uploaddocCategory = "";
			attachmentDisabled(oUploadArray,true,oUploadfieldidArray);
			
			//var fieldlable = jQuery("#"+fieldid).attr("temptitle");
			var fieldlable = "<%=selectfieldlable%>";
			jQuery("span[id^='uploadspan']").each(function(){
				jQuery(this).html("<%=SystemEnv.getHtmlLabelName(125389,user.getLanguage())%> \""+fieldlable+"\"");
			});
		}else{
		    maxUploadImageSize = uploadImageMaxSize;
			jQuery("span[id^='uploadspan']").each(function(){
				var viewtype = jQuery(this).attr("viewtype");
				if(viewtype == 1){
				    jQuery(this).html("<%=SystemEnv.getHtmlLabelName(83523,user.getLanguage())%>"+uploadImageMaxSize+"<%=SystemEnv.getHtmlLabelName(83528,user.getLanguage())%>");
				}else{
					jQuery(this).html("<%=SystemEnv.getHtmlLabelName(83523,user.getLanguage())%>"+uploadImageMaxSize+"<%=SystemEnv.getHtmlLabelName(83528,user.getLanguage())%>");
				}
			});
			attachmentDisabled(oUploadArray,false,oUploadfieldidArray);
		}
	}
}

<%
if(uploadType==1){
%>

function initUploadMax(){
	try{
    	<%
    	if(selectfieldvalue.equals("")){
    	%>
		setTimeout(function(){
				var oUploadArray = new Array();
				var oUploadfieldidArray = new Array();
				<%
				if(uploadfieldids!=null){
				   	for(int i=0;i<uploadfieldids.size();i++){
				   %>
				   try{
					oUploadArray.push(oUpload<%=uploadfieldids.get(i)%>);
					oUploadfieldidArray.push("<%=uploadfieldids.get(i)%>");
				   }catch(e){}
				<%
					}
				}
				%>
				uploadImageMaxSize = 5;
				uploaddocCategory = "";
				attachmentDisabled(oUploadArray,true,oUploadfieldidArray);
				
				var fieldlable = "<%=selectfieldlable%>";
				jQuery("span[id^='uploadspan']").each(function(){
					jQuery(this).html("<%=SystemEnv.getHtmlLabelName(125389,user.getLanguage())%> \""+fieldlable+"\"");
				});
			},2000);
		
		<%}%>
    	
    }catch(e){}
}

initUploadMax();
<%}%>

var js_hrmResourceShow = "<%=hrmResourceShow%>";
</script>
<jsp:include page="WorkflowManageRequestBodyAction_script.jsp" flush="true">
	<jsp:param name="f_weaver_belongto_userid" value="<%=f_weaver_belongto_userid%>" />
	<jsp:param name="f_weaver_belongto_usertype" value="<%=selectInitJsStr%>" />
    <jsp:param name="selectInitJsStr" value="<%=selectInitJsStr%>" />
    <jsp:param name="newfromdate" value="<%=newfromdate%>" />
    <jsp:param name="newenddate" value="<%=newenddate%>" />
    <jsp:param name="requestid" value="<%=requestid%>" />
    <jsp:param name="nodetype" value="<%=nodetype%>" />
    <jsp:param name="isremark" value="<%=isremark%>" />
    <jsp:param name="workflowid" value="<%=workflowid%>" />
    <jsp:param name="nodeid" value="<%=nodeid%>" />
    <jsp:param name="bodychangattrstr" value="<%=bodychangattrstr%>" />
    <jsp:param name="requestname" value="<%=requestname%>" />
    <jsp:param name="isbill" value="<%=isbill%>" />
    <jsp:param name="formid" value="<%=formid%>" />
    <jsp:param name="isrequest" value="<%=isrequest%>" />
    <jsp:param name="creatertype" value="<%=creatertype%>" />
    <jsp:param name="currentdate" value="<%=currentdate%>" />
    <jsp:param name="currenttime" value="<%=currenttime%>" />
    <jsp:param name="fieldCode" value="<%=fieldCode%>" />
    <jsp:param name="isE8Save" value="<%=isE8Save%>" />
    <jsp:param name="fieldIdSelect" value="<%=fieldIdSelect%>" />
    <jsp:param name="departmentFieldId" value="<%=departmentFieldId%>" />
    <jsp:param name="subCompanyFieldId" value="<%=subCompanyFieldId%>" />
    <jsp:param name="supSubCompanyFieldId" value="<%=supSubCompanyFieldId%>" />
    <jsp:param name="yearFieldId" value="<%=yearFieldId%>" />
    <jsp:param name="yearFieldHtmlType" value="<%=yearFieldHtmlType%>" />
    <jsp:param name="monthFieldId" value="<%=monthFieldId%>" />
    <jsp:param name="dateFieldId" value="<%=dateFieldId%>" />
    <jsp:param name="docCategory" value="<%=docCategory%>" />
    <jsp:param name="uploadType" value="<%=uploadType%>" />
    <jsp:param name="selectedfieldid" value="<%=selectedfieldid%>" />
	<jsp:param name="keywordismand" value="<%=keywordismand%>" />
	<jsp:param name="keywordisedit" value="<%=keywordisedit%>" />
	<jsp:param name="titleFieldId" value="<%=titleFieldId%>" />
	<jsp:param name="keywordFieldId" value="<%=titleFieldId%>" />
    <jsp:param name="editbodyactionflag" value="<%=editbodyactionflag%>" />
    <jsp:param name="fieldids" value="<%=fieldids_str%>" />
	<jsp:param name="managefckfields_body" value="<%=managefckfields_body_str%>" />
</jsp:include>

<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>
