
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.net.*" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.cowork.CoworkShareManager" %>
<%@page import="weaver.formmode.setup.ModeRightInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="iWebOfficeConf.jsp" %>
<%@ include file="PDF417ManagerConf.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.file.Prop" %>
<%@ page import="weaver.systeminfo.setting.HrmUserSettingComInfo" %>
<%@ page import="net.sf.json.JSONArray" %>
<jsp:useBean id="TexttoPDFManager" class="weaver.workflow.request.TexttoPDFManager" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryManager" class="weaver.docs.category.SecCategoryManager" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="DocDetailLog" class="weaver.docs.DocDetailLog" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" /> 
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="OpenSendDoc" class="weaver.docs.senddoc.OpenSendDoc" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="DocUserSelfUtil" class="weaver.docs.docs.DocUserSelfUtil" scope="page"/>
<jsp:useBean id="CoworkDAO" class="weaver.cowork.CoworkDAO" scope="page"/>
<jsp:useBean id="VotingManager" class="weaver.voting.VotingManager" scope="page"/>	
<jsp:useBean id="DocUtil" class="weaver.docs.docs.DocUtil" scope="page"/>
<jsp:useBean id="SpopForDoc" class="weaver.splitepage.operate.SpopForDoc" scope="page"/>
<jsp:useBean id="MouldManager" class="weaver.docs.mould.MouldManager" scope="page" />
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="DocMouldComInfo" class="weaver.docs.mould.DocMouldComInfo" scope="page" />
<jsp:useBean id="RequestDoc" class="weaver.workflow.request.RequestDoc" scope="page" />

<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<jsp:useBean id="rsDummyDoc" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="RequestAnnexUpload" class="weaver.workflow.request.RequestAnnexUpload" scope="page" />
<jsp:useBean id="WorkflowBarCodeSetManager" class="weaver.workflow.workflow.WorkflowBarCodeSetManager" scope="page" />
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page"/>
<jsp:useBean id="DocMark" class="weaver.docs.docmark.DocMark" scope="page" />
<jsp:useBean id="BaseBeanOfDocDspExt" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="MeetingUtil" class="weaver.meeting.MeetingUtil" scope="page" />
<jsp:useBean id="DocDsp" class="weaver.docs.docs.DocDsp" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="WTRequestUtil" class="weaver.worktask.worktask.WTRequestUtil" scope="page" />
<jsp:useBean id="shareManager" class="weaver.share.ShareManager" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="BlogDao" class="weaver.blog.BlogDao" scope="page"/>
<jsp:useBean id="workplanService" class="weaver.WorkPlan.WorkPlanService" scope="page" />
<jsp:useBean id="docReply" class="weaver.docs.docs.reply.DocReplyManager" scope="page" />
<%@ page import="weaver.docs.docs.reply.PraiseInfo"%>
<%@ page import="weaver.docs.docs.reply.UserInfo"%>
<%@ page import="weaver.docs.docs.reply.DocReplyUtil"%>

<%//判断金格控件的版本	 2003还是2006
String canPostil = "";
if(isIWebOffice2006 == true){
	canPostil = ",0";
}
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");
HrmUserSettingComInfo userSetting=new HrmUserSettingComInfo();
String belongtoshow = userSetting.getBelongtoshowByUserId(user.getUID()+""); 
String belongtoids = user.getBelongtoids();
String account_type = user.getAccount_type();
int languageId=user.getLanguage();

int docid = Util.getIntValue(request.getParameter("id"),0);
int meetingid = Util.getIntValue(request.getParameter("meetingid"),0);
int workplanid = Util.getIntValue(request.getParameter("workplanid"),0);
int olddocid=Util.getIntValue(request.getParameter("olddocid"),0);
if(olddocid<1) olddocid=docid;    
//董平添加 修改BUG1483 原因:查看ID=0的文档，系统会将文档全部列出来
if (docid==0){
	out.println(SystemEnv.getHtmlLabelName(19711,languageId));
	return ;
}
//TD.5091判断是否客户
boolean isCustomer = false;
if(user.getLogintype().equals("2")){
    isCustomer = true ;
}
String  formmodeparamsStr = "";
String formmodeflag = Util.null2String(request.getParameter("formmode_authorize"));
Map<String,String> formmodeAuthorizeInfo = new HashMap<String,String>();
if(formmodeflag.equals("formmode_authorize")){
	int modeId = 0;
	int formmodebillId = 0;
	int fieldid = 0;
	int formModeReplyid = 0;
	modeId = Util.getIntValue(request.getParameter("authorizemodeId"),0);
	formmodebillId = Util.getIntValue(request.getParameter("authorizeformmodebillId"),0);
	fieldid = Util.getIntValue(request.getParameter("authorizefieldid"),0);
	formModeReplyid = Util.getIntValue(request.getParameter("authorizeformModeReplyid"),0);
	String fMReplyFName = Util.null2String(request.getParameter("authorizefMReplyFName"));
			
	formmodeparamsStr = "&formmode_authorize="+formmodeflag+"&authorizemodeId="+modeId+"&authorizeformmodebillId="+
        	formmodebillId+"&authorizefieldid="+fieldid+"&authorizeformModeReplyid="+formModeReplyid+"&authorizefMReplyFName="+fMReplyFName;
	ModeRightInfo modeRightInfo = new ModeRightInfo();
	modeRightInfo.setUser(user);
	if(formModeReplyid!=0){
		formmodeAuthorizeInfo = modeRightInfo.isFormModeAuthorize(formmodeflag, modeId, formmodebillId, fieldid, docid, formModeReplyid,fMReplyFName);
	}else{
		formmodeAuthorizeInfo = modeRightInfo.isFormModeAuthorize(formmodeflag, modeId, formmodebillId, fieldid, docid);
	}
}

String fromFlowDoc=Util.null2String(request.getParameter("fromFlowDoc"));  //来源于流程建文挡
boolean isNoTurnWhenHasToPage=Util.null2String(request.getParameter("isNoTurnWhenHasToPage")).equals("true")?true:false;//是否有转向页面时不转向  默认为false：否   为“true”表示不转向
boolean  blnOsp = "true".equals(request.getParameter("blnOsp")) ;

String selectedpubmould = Util.null2String(request.getParameter("selectedpubmould")); //选择显示模版的ID

//user info
int userid=user.getUID();
String logintype = user.getLogintype();
String username=ResourceComInfo.getResourcename(""+userid);
String userSeclevel = user.getSeclevel();
String userType = ""+user.getType();
String userdepartment = ""+user.getUserDepartment();
String usersubcomany = ""+user.getUserSubCompany1();
int desrequestid = Util.getIntValue(request.getParameter("desrequestid"),0);
int votingId=Util.getIntValue(request.getParameter("votingId"),0);
//判断新建的是不是个人文档
boolean isPersonalDoc = false ;
String from =  Util.null2String(request.getParameter("from"));
String fileExtendName =  Util.null2String(request.getParameter("fileExtendName"));
int userCategory= Util.getIntValue(request.getParameter("userCategory"),0);
//签章类型（signatureType）1：WPS混合签章；2：360签章；其他，Office签章
String signatureType = Util.null2String(Prop.getPropValue("wps_office_signature","wps_office_signature"));
boolean wps_office_signature=Prop.getPropValue("wps_office_signature","wps_office_signature").equalsIgnoreCase("1");
String wps_version=Util.null2String(Prop.getPropValue("wps_office_signature","wps_version"));
boolean isFromAccessory="true".equals(request.getParameter("isFromAccessory"))?true:false;
boolean openFirstAss="true".equals(request.getParameter("openFirstAss"))?true:false;
boolean hasviewlog="true".equals(request.getParameter("hasviewlog"))?true:false;
if(openFirstAss) isFromAccessory=false;//分离改造，如果是单附件打开，就将来自附件置为false，避免不显示文档的tab页等信息
int shareparentid= Util.getIntValue(request.getParameter("shareparentid"),0);

if ("personalDoc".equals(from)){
    isPersonalDoc = true ;
}
String temStr = request.getRequestURI();
temStr=temStr.substring(0,temStr.lastIndexOf("/")+1);

String mServerUrl=temStr+mServerName;
String mClientUrl=temStr+mClientName;

int versionId = Util.getIntValue(request.getParameter("versionId"),0);
//取得文档数据
String sql1 = "";
if(versionId==0){
    sql1 = "select * from DocImageFile where docid="+docid+" and (isextfile <> '1' or isextfile is null) order by versionId desc";
}else{
    sql1 = "select * from DocImageFile where docid="+docid+" and versionId="+versionId;
}
RecordSet.executeSql(sql1) ;
RecordSet.next();
versionId = Util.getIntValue(RecordSet.getString("versionId"),0);
if(versionId==0){
	RecordSet.executeSql("select * from DocImageFile where docid="+docid+" order by versionId desc") ;
	if(RecordSet.next()){
		versionId = Util.getIntValue(RecordSet.getString("versionId"),0);
	}
}

String filetype=Util.null2String(""+RecordSet.getString("docfiletype"));
String imagefileName=Util.null2String(""+RecordSet.getString("imagefilename"));
String fileExtendName_fl = (imagefileName.isEmpty()||imagefileName.lastIndexOf(".")==-1)?"":imagefileName.substring(imagefileName.lastIndexOf("."));
int requestid=Util.getIntValue(request.getParameter("requestid"),0);
int imagefileId = Util.getIntValue(request.getParameter("imagefileId"),0);
//跨浏览器直接下载文件用imagefileIdNotIE
int imagefileIdNotIE = imagefileId;
if(imagefileIdNotIE==0){
	imagefileIdNotIE = Util.getIntValue(""+RecordSet.getString("imagefileId"),0);
}
RecordSet.executeSql("select versionid  from DocImageFile where id = (select id from DocImageFile where docid=" + docid + " and versionId=" + versionId + ") order by versionid desc ") ;
RecordSet.next();
boolean islastversion=true;
if(Util.getIntValue(RecordSet.getString("versionId"),0)!= versionId) islastversion=false; //只有最新版本的附件才有编辑按钮
int versionCounts2=DocDsp.getVersionCounts(docid,versionId);
boolean  hasOpenEdition=false;
if (versionCounts2>1){
	hasOpenEdition=true;
}
//标识当前字段类型为附件上传类型
String isAppendTypeField = Util.null2String(request.getParameter("isAppendTypeField"));
//文档中心的是否打开附件控制*/
String isOpenFirstAss = Util.null2String(request.getParameter("isOpenFirstAss"));
//判断是否是PDF文档/
boolean isPDF = DocDsp.isPDF(docid,imagefileId,Util.getIntValue(isOpenFirstAss,1));
if(imagefileId==0&&Util.getIntValue(filetype,0) != 2) isPDF = false;
int isUseEMessager = 0;
try {
	isUseEMessager = Util.getIntValue(RecordSet.getPropValue("Messager2", "IsUseEMessager"), 0);	
} catch(Exception e){}
int isUseiWebPDF = 0;
try {
	isUseiWebPDF = Util.getIntValue(RecordSet.getPropValue("weaver_iWebPDF", "isUseiWebPDF"), 0);
} catch(Exception e){}
int isUsePDFViewerForIE8 = 0;
try {
	isUsePDFViewerForIE8 = Util.getIntValue(RecordSet.getPropValue("docpreview", "isUsePDFViewerForIE8"), 0);
} catch(Exception e){}
String agent = request.getHeader("user-agent");
boolean isIE8 = (agent.indexOf("MSIE 8.0;") > 0||agent.indexOf("MSIE 7.0") > 0);
if(isPDF&&isUseiWebPDF==1&&"true".equalsIgnoreCase(isIE)){
%>
		    <script language=javascript>
					location="DocDsp.jsp?id=<%=docid%>&imagefileId=<%=imagefileId%>&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>&f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype+formmodeparamsStr%>&meetingid=<%=meetingid%>&fromFlowDoc=<%=fromFlowDoc%>";
		    </script> 
<%
    return ;
}
else if(isPDF&&isUseiWebPDF==0&&isIE8&&isUsePDFViewerForIE8==1){
%>
		    <script language=javascript>
				location="/docs/pdfview/web/sysRemind.jsp";	
		    </script> 
<%
    return ;
}
if(filetype.equals("3")){
    filetype=".doc";
}else if(filetype.equals("4")){
    filetype=".xls";
}else if(filetype.equals("5")){
    filetype=".ppt";
}else if(filetype.equals("6")){
    filetype=".wps";
}else if(filetype.equals("7")){
    filetype=".docx";
}else if(filetype.equals("8")){
    filetype=".xlsx";
}else if(filetype.equals("9")){
    filetype=".pptx";
}else if(filetype.equals("10")){
    filetype=".et";
}else{
    filetype=fileExtendName_fl;
}

int messageid=Util.getIntValue(request.getParameter("messageid"),0);
String isrequest = Util.null2String(request.getParameter("isrequest"));

char flag=Util.getSeparator() ;
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);
//int requestid=Util.getIntValue(request.getParameter("requestid"),0);

String requestname="";
int workflowid=0;
int formid=0;
int isbill = -1;
int billid=0;
int nodeid=0;
int currentnodeid=0;
String nodetype="";
String nodeName="";
String ifVersion="0";
boolean hasRightOfViewHisVersion=HrmUserVarify.checkUserRight("DocExt:ViewHisVersion", user);

int hasright=0;
String status="";
int creater=0;
int isremark=0;
int operatortype = 0;
String workflowtype="";
String messageType="";

String docIds="";
String crmIds="";
String hrmIds="";
String prjIds="";
String cptIds="";

String user_fieldid="";
String isreopen="";
String isreject="";
String isend="";

DocManager.resetParameter();
DocManager.setId(docid);
DocManager.getDocInfoById();

String checkOutMessage=Util.null2String(request.getParameter("checkOutMessage"));  //已被检出提示信息
checkOutMessage=java.net.URLDecoder.decode(checkOutMessage,"UTF-8");
String checkOutMessage_jspinclude=URLEncoder.encode(URLEncoder.encode(checkOutMessage,"UTF-8"),"UTF-8");

//文档信息
int maincategory=DocManager.getMaincategory();
int subcategory=DocManager.getSubcategory();
int seccategory=DocManager.getSeccategory();
int doclangurage=DocManager.getDoclangurage();
String docapprovable=DocManager.getDocapprovable();
String docreplyable=SecCategoryComInfo.getSecReplyAbles(""+seccategory);
String isreply=DocManager.getIsreply();
int replydocid=DocManager.getReplydocid();
String docsubject=DocManager.getDocsubject();
docsubject=Util.StringReplace(docsubject,"\"", "&quot;");
String doccontent=DocManager.getDoccontent();
String docpublishtype=DocManager.getDocpublishtype();
int itemid=DocManager.getItemid();
int itemmaincategoryid=DocManager.getItemmaincategoryid();
int hrmresid=DocManager.getHrmresid();
int crmid=DocManager.getCrmid();
int projectid=DocManager.getProjectid();
int financeid=DocManager.getFinanceid();
int doccreaterid=DocManager.getDoccreaterid();
int docdepartmentid=DocManager.getDocdepartmentid();
String doccreatedate=DocManager.getDoccreatedate();
String doccreatetime=DocManager.getDoccreatetime();
int doclastmoduserid=DocManager.getDoclastmoduserid();
String doclastmoddate=DocManager.getDoclastmoddate();
String doclastmodtime=DocManager.getDoclastmodtime();
int docapproveuserid=DocManager.getDocapproveuserid();
String docapprovedate=DocManager.getDocapprovedate();
String docapprovetime=DocManager.getDocapprovetime();
int docarchiveuserid=DocManager.getDocarchiveuserid();
String docarchivedate=DocManager.getDocarchivedate();
String docarchivetime=DocManager.getDocarchivetime();
String docstatus=DocManager.getDocstatus();
String parentids=DocManager.getParentids();
int assetid=DocManager.getAssetid();
int ownerid=DocManager.getOwnerid();
String keyword=DocManager.getKeyword();
int accessorycount=DocManager.getAccessorycount();
int replaydoccount=DocManager.getReplaydoccount();
String usertype=DocManager.getUsertype();
String canCopy=DocManager.getCanCopy();
String docno = DocManager.getDocno();
int replyid = 0 ;

int docvaliduserid = DocManager.getDocValidUserId();
String docvaliddate = DocManager.getDocValidDate();
String docvalidtime = DocManager.getDocValidTime();
int docpubuserid = DocManager.getDocPubUserId();
String docpubdate = DocManager.getDocPubDate();
String docpubtime = DocManager.getDocPubTime();
int docreopenuserid = DocManager.getDocReOpenUserId();
String docreopendate = DocManager.getDocReOpenDate();
String docreopentime = DocManager.getDocReOpenTime();
int docinvaluserid = DocManager.getDocInvalUserId();
String docinvaldate = DocManager.getDocInvalDate();
String docinvaltime = DocManager.getDocInvalTime();
int doccanceluserid = DocManager.getDocCancelUserId();
String doccanceldate = DocManager.getDocCancelDate();
String doccanceltime = DocManager.getDocCancelTime();

String docCode = DocManager.getDocCode();
int docedition = DocManager.getDocEdition();
int doceditionid = DocManager.getDocEditionId();
int ishistory = DocManager.getIsHistory();
int selectedpubmouldid = DocManager.getSelectedPubMouldId();

int maindoc = DocManager.getMainDoc();
int docreadoptercanprint = DocManager.getReadOpterCanPrint();

boolean isTemporaryDoc = false;
String invalidationdate = DocManager.getInvalidationDate();
if(invalidationdate!=null&&!"".equals(invalidationdate))
    isTemporaryDoc = true;

//是否回复提醒
String canRemind=DocManager.getCanRemind();

String checkOutStatus=DocManager.getCheckOutStatus();
int checkOutUserId=DocManager.getCheckOutUserId();
String checkOutUserType=DocManager.getCheckOutUserType();

String docCreaterType = DocManager.getDocCreaterType();//文档创建者类型（1:内部用户  2：外部用户）
String docLastModUserType = DocManager.getDocLastModUserType();//文档最后修改者类型（1:内部用户  2：外部用户）
String docApproveUserType = DocManager.getDocApproveUserType();//文档审批者类型（1:内部用户  2：外部用户）
String docInvalUserType = DocManager.getDocInvalUserType();//失效操作人类型（1:内部用户  2：外部用户）
String docArchiveUserType = DocManager.getDocArchiveUserType();//文档归档者类型（1:内部用户  2：外部用户）
String docCancelUserType = DocManager.getDocCancelUserType();//作废操作人类型（1:内部用户  2：外部用户）
String ownerType = DocManager.getOwnerType();//文档拥有者类型（1:内部用户  2：外部用户）




String hasUsedTemplet=DocManager.getHasUsedTemplet();//是否已经套红
int canPrintedNum=DocManager.getCanPrintedNum();//可打印份数
int editMouldId=DocManager.getEditMouldId();//编辑模板id

String docmain = "";
if(docpublishtype.equals("2")){
    int tmppos = doccontent.indexOf("!@#$%^&*");
	if(tmppos!=-1){
		docmain = doccontent.substring(0,tmppos);
		doccontent = doccontent.substring(tmppos+8,doccontent.length());
	}
}

String docstatusname = DocComInfo.getStatusView(docid,user);

String tmppublishtype="";
if(docpublishtype.equals("2")) tmppublishtype=SystemEnv.getHtmlLabelName(227,user.getLanguage());
else if(docpublishtype.equals("3")) tmppublishtype=SystemEnv.getHtmlLabelName(229,user.getLanguage());
else tmppublishtype=SystemEnv.getHtmlLabelName(58,user.getLanguage());

//子目录信息
RecordSet.executeProc("Doc_SecCategory_SelectByID",seccategory+"");
RecordSet.next();
String categoryname=Util.toScreenToEdit(RecordSet.getString("categoryname"),languageId);
String subcategoryid=Util.null2String(""+RecordSet.getString("subcategoryid"));
//String docmouldid=Util.null2String(""+RecordSet.getString("docmouldid"));
String publishable=Util.null2String(""+RecordSet.getString("publishable"));
String replyable=Util.null2String(""+RecordSet.getString("replyable"));
String shareable=Util.null2String(""+RecordSet.getString("shareable"));
String cusertype=Util.null2String(""+RecordSet.getString("cusertype"));
cusertype = cusertype.trim();
String cuserseclevel=Util.null2String(""+RecordSet.getString("cuserseclevel"));
if(cuserseclevel.equals("255")) cuserseclevel="0";
String cdepartmentid1=Util.null2String(""+RecordSet.getString("cdepartmentid1"));
String cdepseclevel1=Util.null2String(""+RecordSet.getString("cdepseclevel1"));
if(cdepseclevel1.equals("255")) cdepseclevel1="0";
String cdepartmentid2=Util.null2String(""+RecordSet.getString("cdepartmentid2"));
String cdepseclevel2=Util.null2String(""+RecordSet.getString("cdepseclevel2"));
if(cdepseclevel2.equals("255")) cdepseclevel2="0";
String croleid1=Util.null2String(""+RecordSet.getString("croleid1"));
String crolelevel1=Util.null2String(""+RecordSet.getString("crolelevel1"));
String croleid2=Util.null2String(""+RecordSet.getString("croleid2"));
String crolelevel2=Util.null2String(""+RecordSet.getString("crolelevel2"));
String croleid3=Util.null2String(""+RecordSet.getString("croleid3"));
String crolelevel3=Util.null2String(""+RecordSet.getString("crolelevel3"));
String approvewfid=RecordSet.getString("approveworkflowid");
String iscopycontrol=Util.null2String(""+RecordSet.getString("defaultLockedDoc"));
String needapprovecheck="";
if(approvewfid.equals(""))  approvewfid="0";
if(approvewfid.equals("0")) needapprovecheck="0";
else needapprovecheck="1";

String hasaccessory =Util.toScreen(RecordSet.getString("hasaccessory"),languageId);
int accessorynum = Util.getIntValue(RecordSet.getString("accessorynum"),languageId);
String approvercanedit=Util.toScreen(RecordSet.getString("approvercanedit"),languageId);
int defaultDocLocked = Util.getIntValue(RecordSet.getString("defaultLockedDoc"),0);
String isSetShare=Util.null2String(""+RecordSet.getString("isSetShare"));
int relationable=Util.getIntValue(""+RecordSet.getString("relationable"),0);
String readCount = " ";

String topage= URLEncoder.encode("/docs/docs/DocDsp.jsp?id="+docid + "&fromFlowDoc="+fromFlowDoc);
if(workplanid>0){
	topage= URLEncoder.encode("/docs/docs/DocDsp.jsp?id="+docid+"&workplanid="+workplanid);
}
if(meetingid>0){
	topage= URLEncoder.encode("/docs/docs/DocDsp.jsp?id="+docid+"&meetingid="+meetingid);
}
boolean canDownload = (Util.getIntValue(RecordSet.getString("nodownload"),0)==0)?true:false;
int categoryreadoptercanprint = Util.getIntValue(RecordSet.getString("readoptercanprint"),0);

String isOpenApproveWf=Util.null2String(RecordSet.getString("isOpenApproveWf"));

String readerCanViewHistoryEdition=Util.null2String(RecordSet.getString("readerCanViewHistoryEdition"));

int appointedWorkflowId = Util.getIntValue(RecordSet.getString("appointedWorkflowId"),0);

int maxOfficeDocFileSize = Util.getIntValue(RecordSet.getString("maxOfficeDocFileSize"),8);

int isAutoExtendInfo = Util.getIntValue(RecordSet.getString("isAutoExtendInfo"),0);

boolean isEditionOpen = SecCategoryComInfo.isEditionOpen(seccategory);
String isTextInForm = Util.null2String(request.getParameter("isTextInForm"));

//打印申请
boolean canPrintApply=false;
String isagentOfprintApply="0";
String isPrintControl=Util.null2String(RecordSet.getString("isPrintControl"));
int printApplyWorkflowId = Util.getIntValue(RecordSet.getString("printApplyWorkflowId"),0);
		if(printApplyWorkflowId>0){

		    //判断是否有流程创建权限
			canPrintApply = shareManager.hasWfCreatePermission(user, printApplyWorkflowId);

            if(!canPrintApply){
				String begindate="";
				String begintime="";
				String enddate="";
				String endtime="";
				int beagenterid=0;
				RecordSet.executeSql("select distinct workflowid,bagentuid,begindate,begintime,enddate,endtime from workflow_agentConditionSet where workflowid="+printApplyWorkflowId+" and agenttype>'0' and iscreateagenter=1 and agentuid="+userid);
				while(RecordSet.next()&&!canPrintApply){
					begindate=Util.null2String(RecordSet.getString("begindate"));
					begintime=Util.null2String(RecordSet.getString("begintime"));
					enddate=Util.null2String(RecordSet.getString("enddate"));
					endtime=Util.null2String(RecordSet.getString("endtime"));
					beagenterid=Util.getIntValue(RecordSet.getString("bagentuid"),0);

					if(!begindate.equals("")){
						if((begindate+" "+begintime).compareTo(CurrentDate+" "+CurrentTime)>0)
							continue;
					}
					if(!enddate.equals("")){
					    if((enddate+" "+endtime).compareTo(CurrentDate+" "+CurrentTime)<0)
					        continue;
					}

					canPrintApply = shareManager.hasWfCreatePermission(beagenterid, printApplyWorkflowId);
					
					if(canPrintApply){
						isagentOfprintApply="1";
					}
				}
			}
		}

boolean canDoPrintByApply=false;
boolean canDoPrintByDocDetail=false;
boolean hasPrintNode=false;
boolean isPrintNode=false;

String printNodes="";
if(isPrintControl.equals("1")){
	//判断是否已经有申请成功的打印份数
	String canDoPrintByApplySb = " select 1   from workflow_requestbase a,Bill_DocPrintApply b  where a.requestId=b.requestid    and a.currentNodeType='3'    and b.resourceId="+userid+"   and b.relatedDocId="+docid+"   and printNum>hasPrintNum ";
	RecordSet.executeSql(canDoPrintByApplySb);
	if(RecordSet.next()){
		canDoPrintByApply=true;
	}

	//判断是否有默认的打印份数
	RecordSet.executeSql("select 1 from DocDetail where id="+docid+" and canPrintedNum>hasPrintedNum");
	if(RecordSet.next()){
		canDoPrintByDocDetail=true;
	}
}

boolean isUseTempletNode=false;//来自于流程创建文档时,当前节点是否为套红节点
boolean isSignatureNodes=false;//来自于流程创建文档时,当前节点是否为签章节点
boolean isCleanCopyNodes=false;//是否清稿节点
boolean showSignatureAPI=false;//鐠嬪啰鏁ignature閻ㄥ嚈PI
boolean isSavePDF=false;//閸欙箑鐡ㄦ稉绡淒F
boolean isSaveDecryptPDF=false;//閸欙箑鐡ㄦ稉楦垮姎鐎靛摉DF
int operationtype=0;
List attachmentList=new ArrayList();
int useTempletNode=0;
String isCompellentMark = "0";//是否必须显示痕迹
String isCancelCheck = "0";//是否取消审阅
String signatureNodes = ""; 
String cleanCopyNodes = "";//清稿节点
boolean isCurrentNode = false;
boolean isCurrentOperator = false;

if(fromFlowDoc.equals("1")){
	nodeid=WFLinkInfo.getCurrentNodeid(requestid,userid,Util.getIntValue(logintype,1));               //节点id

	RecordSet.executeSql("select id from workflow_currentoperator where  requestid="+requestid+" and nodeid="+nodeid+" and userid="+userid);
	if(RecordSet.next()){
		isCurrentOperator=true;
	}

	RecordSet.executeSql("select workflowId,currentNodeId from workflow_requestbase where requestid="+requestid);
	if(RecordSet.next()){
		workflowid=RecordSet.getInt("workflowid");
		//nodeid=RecordSet.getInt("currentnodeid");
		currentnodeid=RecordSet.getInt("currentnodeid");
	}
	RecordSet.executeSql("select ifVersion from workflow_base where id="+workflowid);
	if(RecordSet.next()){
		ifVersion = Util.null2String(RecordSet.getString("ifVersion"));
	}
	RecordSet.executeSql("select nodeName from workflow_nodebase where id="+nodeid);
	if(RecordSet.next()){
		nodeName = URLEncoder.encode(Util.null2String(RecordSet.getString("nodeName")),"UTF-8");
	}
	//RecordSet.executeSql("select useTempletNode from workflow_createdoc  where workflowId="+workflowid);
	RecordSet.executeSql("select * from workflow_createdoc  where workflowId="+workflowid);
	if(RecordSet.next()){
		useTempletNode=RecordSet.getInt("useTempletNode");
		printNodes=Util.null2String(RecordSet.getString("printNodes"));
		isCompellentMark = Util.null2String(RecordSet.getString("iscompellentmark"));
		isCancelCheck = Util.null2String(RecordSet.getString("iscancelcheck"));
		signatureNodes = Util.null2String(RecordSet.getString("signatureNodes"));
		cleanCopyNodes = Util.null2String(RecordSet.getString("cleanCopyNodes"));

	}
	if("".equals(isCompellentMark)){
		isCompellentMark = "0";
	}
	if("".equals(isCancelCheck)){
		isCancelCheck = "0";
	}
	if(nodeid==useTempletNode&&nodeid>0&&nodeid==currentnodeid&&isCurrentOperator){
		isUseTempletNode=true;
	}

	if(!printNodes.equals("")){
		hasPrintNode=true;
	}
	if((","+printNodes+",").indexOf(","+nodeid+",")>=0&&nodeid>0&&nodeid==currentnodeid&&isCurrentOperator){
		isPrintNode=true;
	}else{
		RecordSet.executeSql("select nodeid from workflow_currentoperator where preisremark in('0','4') and userid="+userid+" and requestid="+requestid);
		while(RecordSet.next()){
			int nodeidTemp = RecordSet.getInt("nodeid");
			if((","+printNodes+",").indexOf(","+nodeidTemp+",")>=0&&nodeidTemp>0){
				isPrintNode=true;
			}
		}
	}
	if((","+signatureNodes+",").indexOf(","+nodeid+",")>=0&&nodeid>0&&nodeid==currentnodeid&&isCurrentOperator){
		isSignatureNodes=true;
	}
	if((","+cleanCopyNodes+",").indexOf(","+nodeid+",")>=0&&nodeid>0&&nodeid==currentnodeid){
		isCleanCopyNodes=true;
	}	
	if(nodeid==currentnodeid&&isCurrentOperator){
		isCurrentNode=true;
	}
		
	if("1".equals(isTextInForm)){
		isUseTempletNode=false;
		isSignatureNodes=false;
	}
	String imagefileIdpdf="";
	rs.executeSql("select imagefileid from docimagefile where docid="+docid+" and  ( isextfile is null or isextfile<>1) and docfiletype=12 order by    imagefileid desc ");
    if(rs.next()&&imagefileId==0){
      imagefileIdpdf=Util.null2String(rs.getString("imagefileid"));
    }
    if(!imagefileIdpdf.equals("")){
        response.sendRedirect("/docs/docs/DocDsp.jsp?id="+docid+"&requestid="+requestid+"&nodeId="+currentnodeid+"&isPrintNode="+isPrintNode+"&isSignatureNodes="+isSignatureNodes+"&from=pdfText&fromFlowDoc=" +fromFlowDoc);
		return ;
    }

	Map  texttoPDFMap=TexttoPDFManager.getTexttoPDFMap(requestid, workflowid, currentnodeid,docid);
	showSignatureAPI="1".equals((String)texttoPDFMap.get("showSignatureAPI"))?true:false;
 	isSavePDF="1".equals((String)texttoPDFMap.get("isSavePDF"))?true:false;
	isSaveDecryptPDF="1".equals((String)texttoPDFMap.get("isSaveDecryptPDF"))?true:false;

}

/***************************取出文章被阅读的次数*********************************************************/
int readCount_int = 0 ;
String sql_readCount ="select count(id)  from DocDetailLog where operatetype = 0 and docid =" + docid ;
if(!isFromAccessory){
    /**********************向阅读标记表中插入阅读记录，修改阅读次数(只有当浏览者不是创建者时)********************/
    	if( userid != doccreaterid || !usertype.equals(logintype) ){
    	    sql_readCount ="select count(id)+1  from DocDetailLog where operatetype = 0 and docid =" + docid ;
    	}
    }
rs.execute(sql_readCount);
if(rs.next()) readCount_int = Util.getIntValue(rs.getString(1),0);


//end by mackjoe
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+docsubject;
String needfav ="1";
String needhelp ="";
String doctitlename=docsubject + "("+SystemEnv.getHtmlLabelName(260,user.getLanguage())+" "+readCount_int +" "+SystemEnv.getHtmlLabelName(18929,user.getLanguage())+ ")";
String webOfficeFileName=docsubject;
if (isFromAccessory){
    doctitlename=imagefileName;
    webOfficeFileName=imagefileName;
}

boolean showReplaceFile=true;
if(isFromAccessory){
	rs.executeSql("select 1 from DocImageFile where docid="+docid+" and id in(select id from DocImageFile where docid="+docid+" and versionId="+versionId+" and isextfile=1) ");
	int versionCounts=rs.getCounts();
	
	int versionnum=0;
	if(versionCounts>1){
		rs.executeSql("select 1 from DocImageFile where docid="+docid+" and id in(select id from DocImageFile where docid="+docid+" and versionId="+versionId+" and isextfile=1) and versionId<="+versionId);
		versionnum=rs.getCounts();
	}
	
	webOfficeFileName="<span style=\"color:gray;\">"+SystemEnv.getHtmlLabelName(156,user.getLanguage())+"</span>"+webOfficeFileName;

	if(versionCounts>1){
		webOfficeFileName +=" (<a href=\"#\" style=\"color:#30B5FF;\" onclick=\"javascript:used4SelectAccVersion("+versionId+")\">V"+versionnum+"</a>)";
	}	
	if(versionCounts!=versionnum&&versionCounts!=1) showReplaceFile=false;
}

doctitlename=Util.stringReplace4DocDspExt(doctitlename);
if(isFromAccessory)
webOfficeFileName=Util.stringReplace4DocDspExt(webOfficeFileName);

if(!isFromAccessory){
	
	String imageFileNameNoPostfix=webOfficeFileName;
	List postfixList=new ArrayList();
	postfixList.add(".doc");
	postfixList.add(".dot");
	postfixList.add(".docx");
	postfixList.add(".xls");	
	postfixList.add(".xlt");
	postfixList.add(".xlw");
	postfixList.add(".xla");
	postfixList.add(".xlsx");
	postfixList.add(".ppt");
	postfixList.add(".pptx");
	postfixList.add(".wps");
	postfixList.add(".pgf");		

	String tempPostfix=null;
	String postfix="";
	for(int i=0;i<postfixList.size();i++){
		tempPostfix=(String)postfixList.get(i)==null?"":(String)postfixList.get(i);			
	    if(imageFileNameNoPostfix.endsWith(tempPostfix)){
		    imageFileNameNoPostfix=imageFileNameNoPostfix.substring(0,imageFileNameNoPostfix.indexOf(tempPostfix));
			postfix=tempPostfix;
	    }
	}

	imageFileNameNoPostfix=Util.StringReplace(imageFileNameNoPostfix,".","．");
	webOfficeFileName=imageFileNameNoPostfix+postfix;
}

String doc_topage=Util.null2String((String)session.getAttribute("doc_topage"));
String topageFromOther=Util.null2String(request.getParameter("topage"));
if(!"".equals(checkOutMessage)){
	doc_topage="";
	session.removeAttribute("doc_topage");  
}

//从流程过来文档直接跳转
if(fromFlowDoc.equals("1")){
	//流程创建文档统一为不通过session里的doc_topage传值。
	session.removeAttribute("doc_topage");
	doc_topage="";
    if(!topageFromOther.equals("")&&!isNoTurnWhenHasToPage){

	    response.sendRedirect(topageFromOther+"&docfileid=1&docid="+docid); 
	    return ;
    }
}

//TD8562
//通过项目卡片或任务信息页面新建文档，提交时要弹出共享设置页面。
if (!"".equals(doc_topage)&&doc_topage.indexOf("ViewCoWork.jsp")==-1&&doc_topage.indexOf("coworkview.jsp")==-1&&doc_topage.indexOf("ViewProject.jsp")==-1&&doc_topage.indexOf("/proj/process/DocOperation.jsp")==-1){
    if(!topageFromOther.equals("")){
	    session.removeAttribute("doc_topage");  
	    response.sendRedirect(doc_topage+"&docfileid=1&docid="+docid); 
	    return ;
    }
}else{
	//从协作区过来文档直接跳转
	if(!"".equals(doc_topage)&&(doc_topage.indexOf("coworkview.jsp")>=0||doc_topage.indexOf("ViewCoWork.jsp")>=0)){
		session.removeAttribute("doc_topage");  
		%>
		<script>
		window.opener.location="<%=doc_topage%>&docfileid=1&docid=<%=docid%>";
		window.close();
		</script>
		<%
		return ;
	}
}
/***************************权限判断**************************************************/
//0:查看  
boolean canReader = false;
//1:编辑
boolean canEdit = false;
//2:删除
boolean canDel = false;
//3:共享
boolean canShare = false ;
//4:日志
boolean canViewLog = false;
//5:可以回复
boolean canReplay = false;
//6:打印
boolean canPrint = false;
//7:发布
boolean canPublish = false;
//8:失效
boolean canInvalidate = false;
//9:归档
boolean canArchive = false;
//10:作废
boolean canCancel = false;
//11:重新打开
boolean canReopen = false;
//签出
boolean canCheckOut = false;
//签入
boolean canCheckIn = false;
//强制签入
boolean canCheckInCompellably =false ;
//新建工作流
boolean cannewworkflow = true;
//TD12005不可下载
boolean canDownloadFromShare = false;

String sharelevel="";
String userSeclevelCheck = userSeclevel;//TD22220
if("2".equals(logintype)){
	userdepartment="0";
	usersubcomany="0";
	userSeclevel="0";
}

//String userInfo=logintype+"_"+userid+"_"+userSeclevel+"_"+userType+"_"+userdepartment+"_"+usersubcomany;
String userInfo=logintype+"_"+userid+"_"+userSeclevelCheck+"_"+userType+"_"+userdepartment+"_"+usersubcomany;
SpopForDoc.setIscloseMoreSql(true);
ArrayList PdocList = SpopForDoc.getDocOpratePopedom(""+docid,userInfo);

if (((String)PdocList.get(0)).equals("true")) canReader = true ;
if (((String)PdocList.get(1)).equals("true")) canEdit = true ;
if (((String)PdocList.get(2)).equals("true")) canDel = true ;
if (((String)PdocList.get(3)).equals("true")) canShare = true ;
if (((String)PdocList.get(4)).equals("true")) canViewLog = true ;
if (((String)PdocList.get(5)).equals("true")) canDownloadFromShare = true ;//TD12005

if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")&&!canReader){//濡傛灉涓昏处鍙蜂笉鑳借兘鏌ョ湅闅忔満鎵炬璐﹀彿鐨勬潈闄?
String[] votingshareids=Util.TokenizerString2(belongtoids,",");
	for(int i=0;i<votingshareids.length;i++){
		User user1=new User(Integer.parseInt(votingshareids[i]));			
		String logintype1 = user1.getLogintype();
 		String userSeclevel1 = user1.getSeclevel();
 		String userType1 = ""+user1.getType();
		String userdepartment1 = ""+user1.getUserDepartment();
		String usersubcomany1 = ""+user1.getUserSubCompany1();
		if("2".equals(logintype1)){
			userdepartment1="0";
			usersubcomany1="0";
			userSeclevel1="0";
		}
		String userInfo1=logintype1+"_"+votingshareids[i]+"_"+userSeclevel1+"_"+userType1+"_"+userdepartment1+"_"+usersubcomany1;
		//userInfo=logintype+"_"+votingshareids[i]+"_"+userSeclevelCheck+"_"+userType+"_"+userdepartment+"_"+usersubcomany;	
		PdocList = SpopForDoc.getDocOpratePopedom(""+docid,userInfo1);
		if (((String)PdocList.get(0)).equals("true")&&!canReader) {
			canReader = true ;
            f_weaver_belongto_userid=votingshareids[i];
			user=HrmUserVarify.getUser(request,response,f_weaver_belongto_userid,userType) ;
			userid=Util.getIntValue(votingshareids[i],0);
		}
		if (((String)PdocList.get(1)).equals("true")&&!canEdit) {
			canEdit = true ;
		    f_weaver_belongto_userid=votingshareids[i];
			user=HrmUserVarify.getUser(request,response,f_weaver_belongto_userid,userType) ;
			userid=Util.getIntValue(votingshareids[i],0);
		}
        if (((String)PdocList.get(2)).equals("true")) canDel = true ;
        if (((String)PdocList.get(3)).equals("true")) canShare = true ;
        if (((String)PdocList.get(4)).equals("true")) canViewLog = true ;
        if (((String)PdocList.get(5)).equals("true")) canDownloadFromShare = true ;//TD12005
		
	}
	
}

//对于正常状态的文档，是否具有查看权限
boolean canReaderHis = canReader;
//对于正常状态的文档，是否具有编辑权限
boolean canEditHis = canEdit;

if(canReader && ((!docstatus.equals("7")&&!docstatus.equals("8")) 
                  ||(docstatus.equals("7")&&ishistory==1&&readerCanViewHistoryEdition.equals("1"))
				  )){
    canReader = true;
}else{
    canReader = false;
}
//是否可以查看历史版本
//具有编辑权限的用户，始终可见文档的历史版本；
//可以设置具有只读权限的操作人是否可见历史版本；
if(ishistory==1) {
	if(readerCanViewHistoryEdition.equals("1")){
  	    if(canReader && !canEdit) canReader = true;
	} else {
	    if(canReader && !canEdit) canReader = false;
	}
}	
//编辑权限操作者可查看文档状态为：“审批”、“归档”、“待发布”或历史文档
if(canEdit && ((docstatus.equals("3") || docstatus.equals("5") || docstatus.equals("6") || docstatus.equals("7")) || ishistory==1)) {
    canReader = true;
}
//编辑权限操作者可编辑的文档状态为：“草稿”、“生效、正常”、“失效”、“流程草稿”,非历史文档
if(canEdit && (docstatus.equals("-1")||docstatus.equals("0") || docstatus.equals("4") || docstatus.equals("1") || docstatus.equals("2") || docstatus.equals("7")|| docstatus.equals("9")) && (ishistory!=1))
  canEdit = true;
else
  canEdit = false;
// 可回复
//liyx 增加归档文档可回复及可查看回复列表
if(docreplyable.equals("1") && (docstatus.equals("5") || docstatus.equals("2") || docstatus.equals("1")))
    canReplay = true;
//可打印
if(canEdit||(categoryreadoptercanprint==1)||(categoryreadoptercanprint==2&&docreadoptercanprint==1))
    canPrint = true;
//启用打印控制，而文档已经没有可打印份数时不可打印
if(isPrintControl.equals("1")&&(!canDoPrintByDocDetail)){
	canPrint = false;
}

//启用打印控制，流程创建文档时当前节点不为打印节点  则不可打印
if(isPrintControl.equals("1")&&fromFlowDoc.equals("1")&&hasPrintNode&&!isPrintNode){
	canPrint = false;
}

if(canDoPrintByApply){
    canPrint = true;
}

//启用打印控制或不启用打印控制，流程创建文档时当前节点为打印节点  则可打印
if(fromFlowDoc.equals("1")&&isPrintNode){
	canPrint = true;
}

//可发布
if(HrmUserVarify.checkUserRight("DocEdit:Publish",user,docdepartmentid) && docstatus.equals("6") && (ishistory!=1))
  canPublish = true ;
//可失效
if(HrmUserVarify.checkUserRight("DocEdit:Invalidate",user,docdepartmentid) && (docstatus.equals("1") || docstatus.equals("2")) && (ishistory!=1))
  canInvalidate = true ;
//可失效  文档编辑权限者可对文档进行失效
if(canEdit && (docstatus.equals("1") || docstatus.equals("2")) && (ishistory!=1)){
	    canInvalidate = true ;
}
//可归档
if(HrmUserVarify.checkUserRight("DocEdit:Archive",user,docdepartmentid) && (docstatus.equals("1") || docstatus.equals("2")) && (ishistory!=1))
	canArchive = true ;
//可作废
if(HrmUserVarify.checkUserRight("DocEdit:Cancel",user,docdepartmentid) && (docstatus.equals("1") || docstatus.equals("2") || docstatus.equals("5") || docstatus.equals("7")) && (ishistory!=1))
	canCancel = true ;
//可重新打开
if(HrmUserVarify.checkUserRight("DocEdit:Reopen",user,docdepartmentid) && (docstatus.equals("5") || docstatus.equals("8")) && (ishistory!=1))
  canReopen = true ;

if(canEdit){
  canShare = true;
  canViewLog = true;
}

//对任何状态的文档，拥有完全控制权限的操作人可在文档页面上以右键按钮的形式作“删除”操作。
//对任何状态的文档，如文档管理员和目录管理员拥有文档读权限，可在文档页面上以右键按钮的形式作“删除”操作
if(canDel   || HrmUserVarify.checkUserRight("DocEdit:Delete",user,docdepartmentid) ){
	if(docstatus.equals("5")||docstatus.equals("3")||ishistory==1){
        canDel = false;
	}else{
		canDel = true;
	}
}else{
    canDel = false;
}

//从流程过来的文档，并且当前用户处于流程当前操作者中。//可以查看
if(!canReader&&(isrequest.equals("1")||requestid>0)){
    canReader=WFUrgerManager.OperHaveDocViewRight(requestid,userid,Util.getIntValue(logintype,1),""+docid);
}
//从计划任务处过来
String fromworktask = Util.getFileidIn(Util.null2String(request.getParameter("fromworktask")));
String operatorid = Util.getFileidIn(Util.null2String(request.getParameter("operatorid")));
if(!canReader&&"1".equals(fromworktask)) {
	canReader=WTRequestUtil.UrgerHaveWorktaskDocViewRight(requestid,userid, docid ,Util.getIntValue(operatorid,0));
}

boolean onlyview=false;

if(!canReader){
	if(
		  ((""+userid).equals(""+doccreaterid)&&logintype.equals(docCreaterType))
	    ||((""+userid).equals(""+ownerid)&&logintype.equals(ownerType))
	  ){
		canReader=true;
	}
}
int isfrommeeting = 0;
boolean noMeetingDocRight = true;
boolean noWorkplangDocRight = true;
if(meetingid>0&&!canReader)
{
	noMeetingDocRight = !MeetingUtil.UrgerHaveMeetingDocViewRight(""+meetingid,user,Util.getIntValue(logintype),""+docid);
	if(!noMeetingDocRight)
	{
		isfrommeeting=1;
	}
}
if(workplanid>0&&!canReader)
{
	noWorkplangDocRight = !workplanService.UrgerHaveWorkplanDocViewRight(""+workplanid,user,Util.getIntValue(logintype),""+docid);
	if(!noWorkplangDocRight)
	{
		isfrommeeting=1;
	}
}

//工作微博点击查看文档
int blogDiscussid=Util.getIntValue(request.getParameter("blogDiscussid"),0);
if(!canReader&&blogDiscussid!=0){
	//工作微博记录id
	if(BlogDao.appViewRight("doc",""+userid,docid,blogDiscussid)){	
	      CoworkDAO.shareCoworkRelateddoc(Util.getIntValue(logintype),docid,userid);
	      canReader=true;
	}      
}


//调查点击查看文档
if(!canReader&&votingId>0){
	Map parameterMap=new HashMap();
	parameterMap.put("docId",docid);
	parameterMap.put("votingId",votingId);
	parameterMap.put("userId",user.getUID());
	canReader=VotingManager.haveViewVotingDocRight(parameterMap);
	if(canReader) canDownloadFromShare=true;
}

//协作区点击查看文档
int isfromcowork=0;
int coworkid=Util.getIntValue(request.getParameter("coworkid"),0);
if(!canReader&&coworkid!=0){
	if(CoworkDAO.haveViewCoworkDocRight(""+userid,""+coworkid,""+docid)) {
	   CoworkDAO.shareCoworkRelateddoc(Util.getIntValue(logintype),docid,userid);
	   isfromcowork=1;
	   canReader=true;
	}
}
//表单建模判断关联授权
if(!canReader){
	if("1".equals(formmodeAuthorizeInfo.get("AuthorizeFlag"))){//如果是表单建模的关联授权，那么直接有查看权限
		canReader=true;
	}
}
if(!canReader)  {
	if (!CoworkDAO.haveRightToViewDoc(Integer.toString(userid),Integer.toString(docid))&&noMeetingDocRight){
        if(!WFUrgerManager.OperHaveDocViewRight(requestid,desrequestid,userid,Util.getIntValue(logintype),""+docid) && !WFUrgerManager.getWFShareDesRight(requestid,desrequestid,user,Util.getIntValue(logintype),""+docid) && !WFUrgerManager.getWFChatShareRight(requestid,userid,Util.getIntValue(logintype),""+docid) && !WFUrgerManager.UrgerHaveDocViewRight(requestid,userid,Util.getIntValue(logintype),""+docid) && !WFUrgerManager.getMonitorViewObjRight(requestid,userid,""+docid,"0") && !WFUrgerManager.getWFShareViewObjRight(requestid,user,""+docid,"0") && isfrommeeting==0 && !RequestAnnexUpload.HaveAnnexDocViewRight(requestid,userid,Util.getIntValue(logintype),docid)){
        if(doceditionid>-1&&ishistory==1){
			RecordSet.executeSql(" select id from DocDetail where doceditionid = " + doceditionid + " and ishistory=0 and id<>"+docid+"  order by docedition desc ");
			int newDocId=0;
			if(RecordSet.next()){
				newDocId = Util.getIntValue(RecordSet.getString("id"));
			}
	        if(newDocId!=docid&&newDocId>0){
	%>
		    <script language=javascript>
		        if(confirm("<%=SystemEnv.getHtmlLabelName(20300,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19986,user.getLanguage())%>")) {
					location="DocDsp.jsp?fromFlowDoc=<%=fromFlowDoc%>&from=<%=from%>&userCategory=<%=userCategory%>&id=<%=newDocId%>&olddocid=<%=olddocid%>&isrequest=<%=isrequest%>&requestid=<%=requestid%>&blnOsp=<%=blnOsp%>&topage=<%=URLEncoder.encode(topageFromOther)%>&meetingid=<%=meetingid%>&workplanid=<%=workplanid+formmodeparamsStr%>";
		        }else{
					location="/notice/noright.jsp";
				}
		    </script> 
	<%
			return;//TD10386 JS跳转需要加入return，下面的JAVA代码才不会执行
	        }else{
				//response.sendRedirect("/notice/noright.jsp") ;
%>
		    <script language=javascript>
					location="/notice/noright.jsp";
		    </script> 
<%
	            return ;
			}
		}else{
	        //response.sendRedirect("/notice/noright.jsp") ;
			
%>
		    <script language=javascript>
					location="/notice/noright.jsp";
		    </script> 
<%
	        return ;
		  
		}
        }else{
            onlyview=true;
        }
    } else {
	    canViewLog = true ;
	    cannewworkflow = false;
	}
}
//TD10368 把日志记录移动到权限判断的跳转之后 Start
//TD.5544 判断是否用附件打开，如果是，不计次数和不记日志
if(!isFromAccessory&&!hasviewlog){
/**********************向阅读标记表中插入阅读记录，修改阅读次数(只有当浏览者不是创建者时)********************/
	if( userid != doccreaterid || !usertype.equals(logintype) ){
		rs.executeProc("docReadTag_AddByUser",""+docid+flag+userid+flag+logintype);  // 他人

		DocDetailLog.resetParameter();
		DocDetailLog.setDocId(docid);
		DocDetailLog.setDocSubject(docsubject);
		DocDetailLog.setOperateType("0");
		DocDetailLog.setOperateUserid(user.getUID());
		DocDetailLog.setUsertype(user.getLogintype());
		DocDetailLog.setClientAddress(request.getRemoteAddr());
		DocDetailLog.setDocCreater(doccreaterid);
		DocDetailLog.setDocLogInfo();
	}
}
//TD.5544 end
//TD 10368 End
	//文档未签出时,编辑权限的用户可手动进行文档签出操作
	if(canEdit&&(checkOutStatus==null||(!checkOutStatus.equals("1")&&!checkOutStatus.equals("2")))){
		canCheckOut=true;
        canCheckIn=false;
        canCheckInCompellably=false;
	}
    //文档签出，且签出人为当前用户，则可进行文档签入操作
	if(checkOutStatus!=null&&(checkOutStatus.equals("1")||checkOutStatus.equals("2"))&&checkOutUserId==userid&&checkOutUserType!=	null&&checkOutUserType.equals(logintype)){
		canCheckOut=false;
        canCheckIn=true;
        canCheckInCompellably=false;
	}

	//文档签出，且签出人不为当前用户，当前用户具有文档管理员或目录管理员权限，则可进行强制签入操作
	if(!canCheckIn&&checkOutStatus!=null&&(checkOutStatus.equals("1")||checkOutStatus.equals("2"))&&!(checkOutUserId==userid&&checkOutUserType!=	null&&checkOutUserType.equals(logintype))){

		//判断当前用户是否是文档管理员或目录管理员
		boolean isDocAdminOrDirAdmin=false;
		
		if(HrmUserVarify.checkUserRight("DocEdit:Delete",user,docdepartmentid)){
			isDocAdminOrDirAdmin=true;
		}else{
			String userTypeForDirAccess=usertype.equals("1")?"0":"1";//userTypeForDirAccess，0：内部用户，1：外部用户
            RecordSet.executeSql("select 1 from DirAccessControlDetail where  sourcetype=0 and sourceid="+maincategory+" and sharelevel=1  and ((type=0 and content="+user.getUserDepartment()+" and seclevel<="+user.getSeclevel()+") or (type=1 and content in ("+shareManager.getUserAllRoleAndRoleLevel(user.getUID())+") and seclevel<="+user.getSeclevel()+") or (type=3 and seclevel<="+user.getSeclevel()+") or (type=4 and content="+user.getType()+" and seclevel<="+user.getSeclevel()+") or (type=5 and content="+user.getUID()+") or (type=6 and content="+user.getUserSubCompany1()+" and seclevel<="+user.getSeclevel()+"))" );

			if(RecordSet.next()){
				isDocAdminOrDirAdmin=true;
			}else{
				rs.executeSql("select 1 from DirAccessControlDetail where  sourcetype=1 and sourceid="+subcategory+" and sharelevel=1 and ((type=0 and content="+user.getUserDepartment()+" and seclevel<="+user.getSeclevel()+") or (type=1 and content in ("+shareManager.getUserAllRoleAndRoleLevel(user.getUID())+") and seclevel<="+user.getSeclevel()+") or (type=3 and seclevel<="+user.getSeclevel()+") or (type=4 and content="+user.getType()+" and seclevel<="+user.getSeclevel()+") or (type=5 and content="+user.getUID()+") or (type=6 and content="+user.getUserSubCompany1()+" and seclevel<="+user.getSeclevel()+"))" );
				if(rs.next()){
					isDocAdminOrDirAdmin=true;
				}
			}
		}

		if(isDocAdminOrDirAdmin){
			canCheckOut=false;
            canCheckIn=false;
            canCheckInCompellably=true;
		}

	}

	if(canEdit) canDownload = true;
	
    //下载权限=目录的下载权限&&共享设定的下载权限
    canDownload = canDownloadFromShare && canDownload;//TD12005
    String sysremindurl="/wui/common/page/sysRemind.jsp?labelid=129755";
	if(canDownload){
		sysremindurl="/wui/common/page/sysRemind.jsp?labelid=129755";
	}else{
		sysremindurl="/wui/common/page/sysRemind.jsp?labelid=129757";
	}
/* added by wdl 2006.7.5 TD.4617 套用显示模板 */
boolean isApplyMould = false;
boolean blnRealViewLog=false;
//取得模版设置
int wordmouldid = 0;
String mouldtext = "";
List selectMouldList = new ArrayList();
int selectMouldType = 0;
int selectDefaultMould = 0;

if(SecCategoryDocPropertiesComInfo.getDocProperties(""+seccategory,"10")&&SecCategoryDocPropertiesComInfo.getVisible().equals("1")&&(!"1".equals(hasUsedTemplet))&&(!fromFlowDoc.equals("1"))){
	
	if(filetype.equals(".doc")||filetype.equals(".wps")){
		String mouldType=".doc".equals(filetype)?"3":"7";
		RecordSet.executeSql("select * from DocSecCategoryMould where secCategoryId = "+seccategory+" and mouldType="+mouldType+" order by id ");
		while(RecordSet.next()){
			String moduleid=RecordSet.getString("mouldId");
			String mType = DocMouldComInfo.getDocMouldType(moduleid);
			String modulebind = RecordSet.getString("mouldBind");
			int isDefault = Util.getIntValue(RecordSet.getString("isDefault"),0);
	
			if(isTemporaryDoc){
			    
				if(Util.getIntValue(modulebind,1)==3){
				    selectMouldType = 3;
				    selectDefaultMould = Util.getIntValue(moduleid);
				    selectMouldList.add(moduleid);
			    } else if(Util.getIntValue(modulebind,1)==1&&isDefault==1){
			        if(selectMouldType==0){
				        selectMouldType = 1;
					    selectDefaultMould = Util.getIntValue(moduleid);
			        }
					selectMouldList.add(moduleid);
			    } else {
			        if(Util.getIntValue(modulebind,1)!=2)
						selectMouldList.add(moduleid);
			    }
				
			} else {
			    
				if(Util.getIntValue(modulebind,1)==2){
				    selectMouldType = 2;
				    selectDefaultMould = Util.getIntValue(moduleid);
				    selectMouldList.add(moduleid);
			    } else if(Util.getIntValue(modulebind,1)==1&&isDefault==1){
			        selectMouldType = 1;
				    selectDefaultMould = Util.getIntValue(moduleid);
					selectMouldList.add(moduleid);
			    } else {
			        if(Util.getIntValue(modulebind,1)!=3)
						selectMouldList.add(moduleid);
			    }
			}
			
		}
		
		if(canPublish && docstatus.equals("6")){
		    if(Util.getIntValue(Util.null2String(selectedpubmould),0)<=0){
				if(selectMouldType>0){
				    wordmouldid = selectDefaultMould;
				}
		    } else {
		        wordmouldid = Util.getIntValue(selectedpubmould);
		    }
		} else {
		    if(Util.getIntValue(Util.null2String(selectedpubmould),0)<=0){
		    	if(selectedpubmouldid<=0){
		    	    if(selectMouldType>0)
		    	        wordmouldid = selectDefaultMould;
		    	} else {
		    	    wordmouldid = selectedpubmouldid;
		    	}
		    } else {
		        wordmouldid = Util.getIntValue(selectedpubmould);
		    }
		}
		
	}
}
if((wordmouldid<=0)&&(!fromFlowDoc.equals("1"))){
    wordmouldid = MouldManager.getDefaultWordMouldId();
}

String viewMouldIdAndSecCategoryId="";
int mouldSecCategoryId=0;

//以下情况同时满足，则显示模板取路径设置中的显示模板
//1、来源于流程建文挡
//2、文档没有套红过
//if(fromFlowDoc.equals("1")&&(!"1".equals(hasUsedTemplet))){
if(fromFlowDoc.equals("1") && isUseTempletNode){
	//wordmouldid=RequestDoc.getViewMouldIdForDocDspExt(requestid,docid);
	viewMouldIdAndSecCategoryId=RequestDoc.getViewMouldIdAndSecCategoryIdForDocDspExt(requestid,docid);
	int indexId=viewMouldIdAndSecCategoryId.indexOf("_");
	wordmouldid=Util.getIntValue(viewMouldIdAndSecCategoryId.substring(0,indexId),0);
	mouldSecCategoryId=Util.getIntValue(viewMouldIdAndSecCategoryId.substring(indexId+1),0);

}

if(wordmouldid!=0&&(filetype.equals(".doc")||filetype.equals(".wps"))&&(!"1".equals(hasUsedTemplet))){
	isApplyMould = true;
}

String owneridname=ResourceComInfo.getResourcename(ownerid+"");
int countNum = 0;
String docMouldName = "";
List countMouldList = new ArrayList();
if(fromFlowDoc.equals("1")){

	RecordSet.executeSql("SELECT distinct docMould.ID,docMould.mouldName FROM DocSecCategoryMould docSecCategoryMould, DocMould docMould,workflow_mould  WHERE docSecCategoryMould.mouldID = docMould.ID AND docSecCategoryMould.mouldType in(3,7) AND docSecCategoryMould.mouldBind = 1 AND docSecCategoryMould.secCategoryID = " + mouldSecCategoryId+" and docSecCategoryMould.mouldID=workflow_mould.mouldid and workflow_mould.seccategory="+mouldSecCategoryId+" and workflow_mould.workflowid="+workflowid+" and workflow_mould.mouldType in(0,1) and workflow_mould.visible=1 and workflow_mould.mouldid in ( select docMouldId from workflow_docshow where flowId="+workflowid+" and fieldid!=-1 and secCategoryId="+mouldSecCategoryId+")  ");//获取模板的数量


	String wordmID = String.valueOf(wordmouldid);
	while(RecordSet.next()){
        String docMouldID = RecordSet.getString("ID");
		String mode_name = RecordSet.getString("mouldName");
        countMouldList.add(docMouldID);

		if(docMouldID.equals(wordmID)){
		   docMouldName = mode_name;
		}
	}
    countNum = countMouldList.size();
 }
String strSql="select catelogid from DocDummyDetail where docid="+docid;
rsDummyDoc.executeSql(strSql);
String dummyIds="";
while(rsDummyDoc.next()){
	dummyIds+=Util.null2String(rsDummyDoc.getString(1))+",";
}


boolean istoManagePage=false;
if(!onlyview){
    if (!fromFlowDoc.equals("1")) {
	if (!isPersonalDoc){
       if(isrequest.equals("1")){ //从工作流进入的文档
           hasright = 0 ;        
           if(logintype.equals("1")) operatortype = 0;
           if(logintype.equals("2")) operatortype = 1;
           if(requestid != 0 ) {
               RecordSet.executeProc("workflow_Requestbase_SByID",requestid+"");
               if(RecordSet.next()){
                   workflowid=RecordSet.getInt("workflowid");
                   nodeid=RecordSet.getInt("currentnodeid");
                   nodetype=RecordSet.getString("currentnodetype");
                   requestname=RecordSet.getString("requestname");
                   status=RecordSet.getString("status");
                   creater=RecordSet.getInt("creater");

                   docIds = Util.null2String(RecordSet.getString("docIds"));
                   crmIds = Util.null2String(RecordSet.getString("crmIds"));
                   hrmIds = Util.null2String(RecordSet.getString("hrmIds"));
                   prjIds = Util.null2String(RecordSet.getString("prjIds"));
                   cptIds = Util.null2String(RecordSet.getString("cptIds"));
               }
               RecordSet.executeSql("select isremark from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" and usertype = "+operatortype + " and isremark in ('1','0') " );
               if(RecordSet.next())	{
                   if((RecordSet.getString(1)).equals("0")) hasright=1;
                   else if((RecordSet.getString(1)).equals("1")) isremark=1;
               }
               RecordSet.executeProc("workflow_Nodebase_SelectByID",nodeid+"");
               if(RecordSet.next()){
                   user_fieldid=RecordSet.getString("userids");
                   isreopen=RecordSet.getString("isreopen");
                   isreject=RecordSet.getString("isreject");
                   isend=RecordSet.getString("isend");
               }
               RecordSet.executeSql("select billId from workflow_form where requestid="+requestid);
               if(RecordSet.next()){
					billid = RecordSet.getInt("billId");
               }
               //~~~~~~~~~~~~~~get workflowtype & formid & isbill & messageType~~~~~~~~~~~~~~~~~~~~~
               RecordSet.executeSql("select workflowtype,formid,isbill,messageType from workflow_base where id="+workflowid);
               if(RecordSet.next()){
					workflowtype = RecordSet.getString("workflowtype");
					formid = RecordSet.getInt("formid");
					isbill = RecordSet.getInt("isbill");
					messageType = RecordSet.getString("messageType");
               }
           }
       }
       if(docreplyable.equals("1")&&(docstatus.equals("2")||docstatus.equals("1"))) { 
           replyid = docid; //replyid初始设为文档id
           if(isreply.equals("1")) replyid = replydocid; //如果是回复的文档
       }
       if((SecCategoryComInfo.getLogviewtype(seccategory)==1&&HrmUserVarify.checkUserRight("FileLogView:View", user))||(SecCategoryComInfo.getLogviewtype(seccategory)==0)){
           // 具有编辑权限的人都可以查看文档的查看日志
           if(canViewLog&&logintype.equals("1")){
          	 blnRealViewLog=true;
           }else if(canEdit&&logintype.equals("2")){}
          	 blnRealViewLog=true;
		    }
   }
   } else {
	   //boolean istoManagePage=false;
	   RecordSet.executeProc("workflow_Requestbase_SByID",requestid+"");
	   if(RecordSet.next()){
	   	nodetype=Util.null2String(RecordSet.getString("currentnodetype"));
	   }
	   if(logintype.equals("1")) operatortype = 0;
	   if(logintype.equals("2")) operatortype = 1;

	   RecordSet.executeSql("select isremark from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" and usertype="+operatortype+" order by isremark");
	   while(RecordSet.next())	{
	       isremark = Util.getIntValue(RecordSet.getString("isremark"),-1) ;
	       if( isremark==1||isremark==5 || (isremark==0  && !nodetype.equals("3")) ) {
	         istoManagePage=true;
	         break;
	       }
	   }
   }
}

boolean cantop = false;
int istop = 0;
if(HrmUserVarify.checkUserRight("Document:Top", user)) {
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	String createidsubcomid = ResourceComInfo.getSubCompanyID(""+doccreaterid);
	if(detachable==1) {
		ArrayList subcompanylist=SubCompanyComInfo.getRightSubCompany(user.getUID(),"Document:Top");
		if(subcompanylist.indexOf(createidsubcomid)!=-1) {
			cantop = true;	
		}
	} else {
		cantop = true;
	}
	if(docstatus.equals("3"))
	{
		cantop = false;
	}
	if(cantop) { }
	String sql = "select istop from docdetail d where d.id="+docid;
	rs.executeSql(sql);
	rs.next();
	//int 
	istop = rs.getInt(1);
	if(istop==1) { }
}

boolean isLocked=false;
if(!isUseTempletNode&&!isSignatureNodes&&(!canEdit&&defaultDocLocked==1)){
	isLocked=true;
}
String isUseBarCodeThisJsp="0";
if(fromFlowDoc.equals("1")){
    String isUseBarCode = Util.null2String(BaseBeanOfDocDspExt.getPropValue("weaver_barcode","ISUSEBARCODE"));
    if(isUseBarCode.equals("1")){
	    //判断是否启用二维条码
	    RecordSet.executeSql("select 1 from Workflow_BarCodeSet where workflowId="+workflowid+" and isUse='1'");

	    if(RecordSet.next()){
		    isUseBarCodeThisJsp="1";
	    }
    }
}


if((isUseTempletNode||isSignatureNodes)&&("false".equalsIgnoreCase(isIE))){
			request.setAttribute("labelid","27969");
			request.getRequestDispatcher("/wui/common/page/sysRemind.jsp").forward(request,response);
			return ;
}

String NotIERemind =Util.null2String(BaseBeanOfDocDspExt.getPropValue("docpreview","NotIERemind"));
//String agent = request.getHeader("user-agent");

	if((agent.contains("Firefox")||agent.contains(" Chrome")||agent.contains("Safari") )|| agent.contains("Edge")){
		isIE = "false";
	}
	else{
		isIE = "true";
	}	


//if("false".equals(isIE)){
boolean iframeLoad = false;
if(canEdit){
	iscopycontrol="0";
}
String previewUrl = "/docs/docpreview/main.jsp?iscopycontrol="+iscopycontrol+"&canPrint="+canPrint+"&canDownload="+canDownload+"&imageFileId="+imagefileId+"&docId="+docid+"&versionId="+versionId+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&workplanid="+workplanid+"&requestid="+requestid+"&desrequestid="+desrequestid+""+formmodeparamsStr;
String  loadDspSwfPara=""+user.getUID()+"_"+Util.getIntValue(user.getLogintype(),1)+"_"+docid+"_"+versionId+"_"+imagefileIdNotIE;
session.setAttribute("hasRight_"+loadDspSwfPara,"1");

	String IsUseDocPreview=Util.null2String(RecordSet.getPropValue("docpreview","IsUseDocPreview"));
	String docPreviewType_prop=Util.null2String(RecordSet.getPropValue("docpreview","DocPreviewType"));//文档预览方式    1：OpenOffice    2:html

	if(isUseTempletNode||isSignatureNodes){
		IsUseDocPreview="0";
	}
	

	boolean isToDocDspExt = false;
                if(imagefileName.toLowerCase().endsWith("png") || 
                    imagefileName.toLowerCase().endsWith("gif") || 
                    imagefileName.toLowerCase().endsWith("jpg") || 
                    imagefileName.toLowerCase().endsWith("jpeg") || 
                    imagefileName.toLowerCase().endsWith("bmp") ||
					imagefileName.toLowerCase().endsWith("pdf") ||
					imagefileName.toLowerCase().endsWith("html") ||
					imagefileName.toLowerCase().endsWith("htm")) {
		    			isToDocDspExt = true;
				}else if((imagefileName.toLowerCase().endsWith("sql") || 
                    imagefileName.toLowerCase().endsWith("json") || 
                    imagefileName.toLowerCase().endsWith("js") || 
                    imagefileName.toLowerCase().endsWith("css") || 
                    imagefileName.toLowerCase().endsWith("txt") ||
					imagefileName.toLowerCase().endsWith("pdf") ||
					imagefileName.toLowerCase().endsWith("swf") ||
					imagefileName.toLowerCase().endsWith("log"))&&IsUseDocPreview.equals("1")){
		    			isToDocDspExt = true;
				}   
	
boolean isNotOffice=false;
if(!(imagefileName.toLowerCase().endsWith(".doc") || 
	imagefileName.toLowerCase().endsWith(".docx") || 
	imagefileName.toLowerCase().endsWith(".ppt") || 
	imagefileName.toLowerCase().endsWith(".pptx") || 
	imagefileName.toLowerCase().endsWith(".wps") || 
	imagefileName.toLowerCase().endsWith(".xls") || 
	imagefileName.toLowerCase().endsWith(".xlsx"))){
	isNotOffice = true;//非office文档一定要往pdf预览的界面跳转
}	
	
	//开启在线预览的时候   
	boolean  sysremindflag=false;
	if(IsUseDocPreview.equals("1")){ 	//如果开启在线预览
		//response.sendRedirect("/docs/docpreview/main.jsp?docId="+docid+"&versionId="+versionId);
		String IsUseDocPreviewForIE=Util.null2String(RecordSet.getPropValue("docpreview","IsUseDocPreviewForIE"));
		if("false".equals(isIE)||"1".equals(IsUseDocPreviewForIE) || isPDF){//浏览器非IE或者IE下使用在线预览或者是PDF文件都跳转到pdf预览界面
			iframeLoad = true;	//
		}
	}else if((!"false".equalsIgnoreCase(isIE)) && !isNotOffice){//没开启在线预览并且浏览器是IE并且是office文档的时候，不跳转到pdf预览界面，直接使用金格插件打开
		iframeLoad = false;
	}
	else if(!isToDocDspExt ){							//非图片、html、pdf文件在没开启在线预览并且浏览器不是IE或者(浏览器是IE但文件不是office文件)的情况都直接根据下载权限进行提示
		//response.sendRedirect(sysremindurl);
		sysremindflag = true;
	}

	if(isToDocDspExt){
		iframeLoad = true;
	}

	
%>

<%
	int praiseCount_int = 0;
	int isPraise = 0;
	
	PraiseInfo praiseInfo = docReply.getPraiseInfoByDocid(DocManager.getDocid()+"",user.getUID());
	if(praiseInfo.getUsers() != null)
	{
	    praiseCount_int = praiseInfo.getUsers().size();
	    isPraise = praiseInfo.getIsPraise();
	}
	
	List<UserInfo> userInfos = praiseInfo.getUsers();
%>
<SCRIPT LANGUAGE="JavaScript">
	function onDownload(){
		//如果为非IE浏览器或该文档所在目录未开启锁定查看功能，则使用服务器下载
		<%if(iframeLoad||defaultDocLocked!=1||isNotOffice){%>
			top.location="/weaver/weaver.file.FileDownload?fileid=<%=imagefileIdNotIE%>&download=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>&votingId=<%=votingId%>&f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype+formmodeparamsStr%>";
		<%}else{%>
			webOfficeMenuClick(37,'');
		<%}%>
	}
	function onEditAcc(){
		location.href='DocEditExt.jsp?id=<%=docid%>&versionId=<%=versionId%>&isFromAccessory=true';
	}

</SCRIPT>


<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<META http-equiv=Content-Type content="text/html; charset=UTF-8">
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<script type='text/javascript' src='/dwr/interface/DocDetailLogWrite.js'></script>
<LINK href="/js/extjs/resources/css/ext-all_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/js/extjs/resources/css/xtheme-gray_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/css/weaver-ext_wev8.css" type=text/css rel=STYLESHEET>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet"></link>
<link type="text/css" href="/css/ecology8/crudoc_wev8.css" rel="stylesheet"></link>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<!-- 图片轮播 -->
		<script src="/social/js/drageasy/drageasy.js"></script>
		<script type="text/javascript" src="/social/js/bootstrap/js/bootstrap.js"></script>
		<script type="text/javascript" src="/social/im/js/IMUtil_wev8.js"></script>
		<script type="text/javascript" src="/social/js/imcarousel/imcarousel.js"></script>
<script type="text/javascript">
	function onBtnSearchClick(){}
	jQuery(document).ready(function(){
		jQuery('.e8_box').Tabs({
		 	getLine:0,
		 	image:false,
		 	needLine:true,
		 	lineSep: ">",
		 	needChange: false,
		 	exceptHeight:true,
		 	objNameNew:"<%=webOfficeFileName%>",
        	mouldID:"<%=  MouldIDConst.getID("doc")%>"
		 });
		 jQuery("div#divTab").show();
		 var canReply = <%= canReplay %>;
		 var isUseNewReply = "<%= DocReplyUtil.isUseNewReply() %>";
		 if(canReply) {
			  if(isUseNewReply){
			  	 	var isPraise = "<%= isPraise %>";
					if(isPraise == 0)
					{
						jQuery("#praiseInfo").bind("click",function (){
							praise(<%=docid%>,0,<%=docid%>);
						});
					}
					else
					{
						jQuery("#praiseInfo").bind("click",function (){
							unPraise(<%=docid%>,0);
						});
					}
			  }
		 }
	});
	
	function praise(replyid,replytype,docid)
	{
		jQuery.ajax({
			type: "POST",
			url: "/docs/reply/OperDocReply.jsp",
			data: {
			replyid: replyid,
			operation: 'praise',
			docid : docid,
			replytype: replytype,
			userid: <%=user.getUID() %>
			},
			cache: false,
			async:false,
			dataType: 'json',
			success: function(msg){
				jQuery("#praiseInfo").unbind("click");
					jQuery("#praiseInfo").bind('click',function(){
						unPraise(replyid, replytype);
					});
					if(jQuery("#praiseCount").text() == "")
					{
						jQuery("#praiseCount").text("1");
					}
					else
					{
						var index = parseInt(jQuery("#praiseCount").text());
		  				jQuery("#praiseCount").text(index+1);
		  				if(index > 12)
		  				{
							jQuery(".praiseuser_a:last").addClass("praiseuser_a_hidden");
							jQuery(".praiseuser_a:last").removeClass("praiseuser_a");
							jQuery("#fuserFont").text(index+1);
		  				}
					}
					jQuery("#praiseInfo").attr("title","<%=SystemEnv.getHtmlLabelName(32944,user.getLanguage())%>");
					jQuery("#praiseInfo").removeClass('praiseInfo');
					jQuery("#praiseInfo").addClass('praiseInfo_hot');
					jQuery("#praiseCountSpan").removeClass('praiseSpan');
					jQuery("#praiseCountSpan").addClass('praiseSpan_hot');
					
					jQuery("#praiseInfo").text("<%=SystemEnv.getHtmlLabelName(32944,user.getLanguage())%>");
					
						$name = jQuery("<a />");
						$name.addClass("praiseuser_a");
						$name.attr("id","<%= user.getUID() %>up");
						$name.attr("title","<%= user.getUsername() %>");
					  	$name.attr("href","javaScript:openhrm(<%=user.getUID() %>)");
					  	$name.click(function() {
								pointerXY(event);
						});
						$name.append("<%= user.getUsername() %>");
						jQuery("#praiseUsers").prepend($name);
						jQuery("#noPraise").hide();
					
			}
		});
	}
	
	
	function unPraise(replyid,replytype)
	{
		jQuery.ajax({
			type: "POST",
			url: "/docs/reply/OperDocReply.jsp",
			data: {
			replyid: replyid,
			operation: 'unpraise',
			docid : docid,
			replytype: replytype,
			userid: <%=user.getUID() %>
			},
			cache: false,
			async:false,
			dataType: 'json',
			success: function(msg){
				jQuery("#praiseInfo").unbind("click");
					jQuery("#praiseInfo").bind('click',function(){
						praise(replyid, replytype,docid);
					});
					var index = parseInt(jQuery("#praiseCount").text());
					if(index - 1 > 0)
						{
							jQuery("#praiseCount").text(index-1);
						}
		  				else
		  				{
		  					jQuery("#praiseCount").text("0");
		  					jQuery("#noPraise").show();
		  				}
		  			if(index-1 > 12)
		  			{
						if(jQuery("#<%= user.getUID() %>up").is('.praiseuser_a')){
							jQuery(".praiseuser_a_hidden:first").addClass("praiseuser_a");
							jQuery(".praiseuser_a_hidden:first").removeClass("praiseuser_a_hidden");
						}
							jQuery("#fuserFont").text(index-1);
		  			}
		  			jQuery("#praiseInfo").attr("title","<%=SystemEnv.getHtmlLabelName(32942,user.getLanguage())%>");
		  				jQuery("#praiseInfo").removeClass('praiseInfo_hot');
					jQuery("#praiseInfo").addClass('praiseInfo');
					jQuery("#praiseCountSpan").removeClass('praiseSpan_hot');
					jQuery("#praiseCountSpan").addClass('praiseSpan');
					jQuery("#praiseInfo").text("<%=SystemEnv.getHtmlLabelName(32942,user.getLanguage())%>");
				jQuery("#<%= user.getUID() %>up").remove();
			}
		});
	}
</script>
<style type="text/css">
	.e8_rightBox{
		top:-2px;
	}
	#rightMenu{
		visibility:hidden;
	}
.viewInfo {
    width: 22px;
    height: 22px;
    float: left;
    margin-left: 25px;
}
.viewInfo:hover {
    color: #676767;
}
.praiseInfo {
    width: 22px;
    height: 22px;
    float: left;
    margin-left: 15px;
}
.praiseInfo:hover {
	color: #676767;
}
.praiseInfo_hot {
    width: 28px;
    height: 22px;
    float: left;
    margin-left: 15px;
    color: #ffa53b;
}
.praiseInfo_hot:hover {
	color: #ff5b3b;
}
.praiseuser_a {
 	margin-left: 5px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    margin-top: 10px;
    width: 36px;
}

.praiseuser_a_hidden {
 	margin-left: 5px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    margin-top: 10px;
    width: 36px;
    display: none!important;
}

.praiseuser_a_show {
 	margin-left: 5px;
    white-space: nowrap;
    overflow: hidden;
    width: 36px;
    text-overflow: ellipsis;
    margin-top: 10px;
}

.moreUsers_a {
	 // margin-left: 5px;
}

.moreUserView {
	background-image: url('/docs/reply/img/more.png');
    width: 22px;
    height: 22px;
    float: right;
    margin-right: 11px;
}
.lettelUserView {
	background-image: url('/docs/reply/img/up.png');
    width: 22px;
    height: 22px;
    float: right;
    margin-right: 15px;
    margin-top: 9px;
    margin-bottom: 10px;
}
.moreUserView:hover {
	background-image: url('/docs/reply/img/more_hot.png');
}
.vpSpan {
	float: left;
    padding-left: 10px;
}

.praiseSpan {
	float: left;
}
.praiseSpan_hot {
	float: left;
	padding-left: 15px;
}
.magic-line1 {
    position: absolute;
    left: 0;
    height: 19px!important;
    line-height: 2px!important;
    top: 32px;
    background-image: url("/images/ecology8/angle_wev8.png");
    background-repeat: no-repeat;
    background-position: 50% 50%;
    width: 24px;
    left: 460px;
    top: 50px;
    z-index: 9;
    display:none;
}
.praiseUserDiv {
  position: absolute;
  white-space: normal;
  margin-top: 36px;
  margin-left: 375px;
  border: 1px solid rgb(218, 218, 218);
  max-width: 365px;
  min-width: 80px;
  line-height: 20px;
  text-align: left;
  top: 26px;
  z-index: 8;
  background-color: rgb(255, 255, 255);
  -webkit-box-shadow: #666 0px 0px 10px;
  -moz-box-shadow: #666 0px 0px 10px;
  box-shadow: #969696 0px 0px 5px;
  max-height: 500px;
  min-height: 40px;
  display:none;
  padding-left: 5px;
}
</style>
<jsp:include page="/systeminfo/WeaverLangJS.jsp">
    <jsp:param name="languageId" value="<%=user.getLanguage()%>" />
</jsp:include>

<%

Map<String,Object> menus = null;

Map menuBarMap = new HashMap();
Map[] menuBarToolsMap = new HashMap[]{};
menus = getMenuBars(onlyview, fromFlowDoc, isPersonalDoc, isrequest, canEditHis, docstatus,
		 hasright, languageId, canEdit, canReader, canShare, canDel, docreplyable,
		OpenSendDoc, docid, cannewworkflow, canPublish, canInvalidate,
		 canArchive, canCancel, canReopen, canCheckOut, canCheckIn, canCheckInCompellably,
		 user, docdepartmentid, canPrintApply, canPrint, isPrintControl, isbill, formid,
		 docapprovable, isremark,SecCategoryComInfo, seccategory, canViewLog,
		 logintype, hasRightOfViewHisVersion, isCurrentNode, defaultDocLocked, filetype, canDownload,
		 nodetype, isreply, istoManagePage, isUseTempletNode, wordmouldid, mouldSecCategoryId,
		 isSignatureNodes, cantop, istop, accessorycount,countNum,hasUsedTemplet,RCMenu,RCMenuHeight,RCMenuHeightStep,iframeLoad,isFromAccessory,openFirstAss,isIE,fileExtendName,isToDocDspExt,islastversion,hasOpenEdition,isCustomer,imagefileName,docsubject,isUseEMessager);

RCMenu += (String)menus.get("RCMenu");

RCMenuHeight += (Integer)menus.get("RCMenuHeight");

session.setAttribute("PDF417ManagerCopyRight",PDF417ManagerCopyRight);
session.setAttribute("docMouldName_"+wordmouldid,docMouldName);
%>

	<jsp:include page="/docs/docs/DocDspExtLoad.jsp" flush="true">
		<jsp:param name="f_weaver_belongto_userid" value="<%=f_weaver_belongto_userid%>" />
		<jsp:param name="f_weaver_belongto_usertype" value="<%=f_weaver_belongto_usertype%>" />
	    <jsp:param name="docid" value="<%=docid%>" />
	    <jsp:param name="isToDocDspExt" value="<%=isToDocDspExt ? 1 : 0%>" />
	    <jsp:param name="fromFlowDoc" value="<%=fromFlowDoc%>" />
	    <jsp:param name="iframeLoad" value="<%=iframeLoad%>" />
	    <jsp:param name="isIWebOffice2006" value="<%=(isIWebOffice2006?1:0)%>" />
	    <jsp:param name="requestid" value="<%=requestid%>" />
	    <jsp:param name="ifVersion" value="<%=ifVersion%>" />
	    <jsp:param name="isCompellentMark" value="<%=isCompellentMark%>" />
	    <jsp:param name="canPostil" value="<%=canPostil%>" />
	    <jsp:param name="isFromAccessory" value="<%=isFromAccessory%>" />
	    <jsp:param name="isrequest" value="<%=isrequest%>" />
	    <jsp:param name="hasUsedTemplet" value="<%=hasUsedTemplet%>" />
	    <jsp:param name="isPrintControl" value="<%=isPrintControl%>" />
	    <jsp:param name="doccreaterid" value="<%=doccreaterid%>" />
	    <jsp:param name="userid" value="<%=userid%>" />
	    <jsp:param name="countNum" value="<%=countNum%>" />
	    <jsp:param name="isremark" value="<%=isremark%>" />
	    <jsp:param name="isUseTempletNode" value="<%=(isUseTempletNode?1:0)%>" />
	    <jsp:param name="wordmouldid" value="<%=wordmouldid%>" />
		 <jsp:param name="currentnodeid" value="<%=currentnodeid%>" />
	    <jsp:param name="versionId" value="<%=versionId%>" />
	    <jsp:param name="isSignatureNodes" value="<%=(isSignatureNodes?1:0)%>" />			
	    <jsp:param name="CurrentDate" value="<%=CurrentDate%>" />
	    <jsp:param name="CurrentTime" value="<%=CurrentTime%>" />
	    <jsp:param name="workflowid" value="<%=workflowid%>" />
	    <jsp:param name="PDF417ManagerCopyRight" value="<%=PDF417ManagerCopyRight%>" />
	    <jsp:param name="appointedWorkflowId" value="<%=appointedWorkflowId%>" />
	    <jsp:param name="logintype" value="<%=logintype%>" />
	    <jsp:param name="userSeclevel" value="<%=userSeclevel%>" />
	    <jsp:param name="userCategory" value="<%=userCategory%>" />
	    <jsp:param name="from" value="<%=from%>" />
	    <jsp:param name="topage" value="<%=topage%>" />
	    <jsp:param name="maxOfficeDocFileSize" value="<%=maxOfficeDocFileSize%>" />
	    <jsp:param name="isPersonalDoc" value="<%=(isPersonalDoc?1:0)%>" />
	    <jsp:param name="onlyview" value="<%=(onlyview?1:0)%>" />
	    <jsp:param name="canEdit" value="<%=(canEdit?1:0)%>" />
	    <jsp:param name="nodeName" value="<%=nodeName%>" />
	    <jsp:param name="istoManagePage" value="<%=(istoManagePage?1:0)%>" />
	    <jsp:param name="mouldSecCategoryId" value="<%=mouldSecCategoryId%>" />
	    <jsp:param name="cantop" value="<%=(cantop?1:0)%>" />
	    <jsp:param name="istop" value="<%=istop%>" />
	    <jsp:param name="canEditHis" value="<%=(canEditHis?1:0)%>" />
	    <jsp:param name="docstatus" value="<%=docstatus%>" />
	    <jsp:param name="hasright" value="<%=hasright%>" />
	    <jsp:param name="languageId" value="<%=languageId%>" />
	    <jsp:param name="canReader" value="<%=(canReader?1:0)%>" />
	    <jsp:param name="canShare" value="<%=(canShare?1:0)%>" />
	    <jsp:param name="canDel" value="<%=(canDel?1:0)%>" />
		<jsp:param name="hasOpenEdition" value="<%=(hasOpenEdition?1:0)%>" />
	    <jsp:param name="docreplyable" value="<%=docreplyable%>" />
	    <jsp:param name="cannewworkflow" value="<%=(cannewworkflow?1:0)%>" />
	    <jsp:param name="canPublish" value="<%=(canPublish?1:0)%>" />
	    <jsp:param name="canInvalidate" value="<%=(canInvalidate?1:0)%>" />
	    <jsp:param name="canArchive" value="<%=(canArchive?1:0)%>" />
	    <jsp:param name="canCancel" value="<%=(canCancel?1:0)%>" />
	    <jsp:param name="canReopen" value="<%=(canReopen?1:0)%>" />
	    <jsp:param name="canCheckOut" value="<%=(canCheckOut?1:0)%>" />
	    <jsp:param name="canCheckIn" value="<%=(canCheckIn?1:0)%>" />
	    <jsp:param name="canCheckInCompellably" value="<%=(canCheckInCompellably?1:0)%>" />
	    <jsp:param name="docdepartmentid" value="<%=docdepartmentid%>" />
	    <jsp:param name="canPrintApply" value="<%=(canPrintApply?1:0)%>" />
	    <jsp:param name="canPrint" value="<%=(canPrint?1:0)%>" />
	    <jsp:param name="isbill" value="<%=isbill%>" />
	    <jsp:param name="formid" value="<%=formid%>" />
	    <jsp:param name="docapprovable" value="<%=docapprovable%>" />
	    <jsp:param name="seccategory" value="<%=seccategory%>" />
	    <jsp:param name="canViewLog" value="<%=(canViewLog?1:0)%>" />
	    <jsp:param name="hasRightOfViewHisVersion" value="<%=(hasRightOfViewHisVersion?1:0)%>" />
	    <jsp:param name="isCurrentNode" value="<%=(isCurrentNode?1:0)%>" />
	    <jsp:param name="defaultDocLocked" value="<%=defaultDocLocked%>" />
	    <jsp:param name="filetype" value="<%=filetype%>" />
	    <jsp:param name="canDownload" value="<%=(canDownload?1:0)%>" />
	    <jsp:param name="nodetype" value="<%=nodetype%>" />
	    <jsp:param name="isreply" value="<%=isreply%>" />
	    <jsp:param name="accessorycount" value="<%=accessorycount%>" />
	    <jsp:param name="mServerUrl" value="<%=mServerUrl%>" />
	    <jsp:param name="isLocked" value="<%=(isLocked?1:0)%>" />
	    <jsp:param name="isCancelCheck" value="<%=isCancelCheck%>" />
	    <jsp:param name="isApplyMould" value="<%=(isApplyMould?1:0)%>" />
	    <jsp:param name="isUseBarCodeThisJsp" value="<%=isUseBarCodeThisJsp%>" />
	    <jsp:param name="readCountint" value="<%=readCount_int%>" />
	    <jsp:param name="checkOutMessage" value="<%=checkOutMessage_jspinclude %>"/>
		<jsp:param name="signatureType" value="<%=signatureType%>" />
		<jsp:param name="wps_office_signature" value="<%=wps_office_signature?1:0%>" />
		<jsp:param name="openFirstAss" value="<%=openFirstAss %>" />
		<jsp:param name="ishistory" value="<%=ishistory %>" />
		<jsp:param name="islastversion" value="<%=islastversion?1:0 %>" />
		<jsp:param name="showReplaceFile" value="<%=showReplaceFile %>" />
		<jsp:param name="fileExtendName" value="<%=fileExtendName %>" />
		<jsp:param name="isNotOffice" value="<%=isNotOffice %>" />
		<jsp:param name="isTextInForm" value="<%=isTextInForm %>" />
	</jsp:include>

</head>

<body class="ext-ie ext-ie8 x-border-layout-ct" scroll="no" onunload="UnLoad()" oncontextmenu="doNothing()">    
<brow:browser name="_selectAccVersionBtn" viewType="0" display="none"  browserBtnID="selectAccVersionBtn" getBrowserUrlFn="getBrowserUrl4selectAccVersion"  isMustInput="1"  _callback="afterSelectAccVersion"/>
<iframe id="DocCheckInOutUtilIframe" frameborder=0 scrolling=no src=""  style="display:none"></iframe>

	<form name=workflow method=post action="/workflow/request/RequestType.jsp">
        <input type=hidden name=topage value='<%=topage%>'>
        <input type=hidden name=docid value='<%=docid%>'>
    </form>
 
    <FORM id=docsharelog name=docsharelog action="DocShare.jsp" method=post  target="_blank">
    <input type=hidden name=docid value="<%=docid%>">
    <input type=hidden name=docsubject value="<%=docsubject%>">
    <input type=hidden name=doccreaterid value="<%=doccreaterid%>">
    <input type=hidden name=sqlwhere value="<%=xssUtil.put("where docid="+docid)%>">
    </form>

    <FORM id=weaver name=weaver action="UploadDoc.jsp?fromFlowDoc=<%=fromFlowDoc%>&workflowid=<%=workflowid%>" method="post">
<!--该参数必须作为Form的第一个参数,并且不能在其他地方调用，用于解决在IE6.0中输入·这个特殊符号存在的问题-->
<INPUT TYPE="hidden" id="docIdErrorError" NAME="docIdErrorError" value="">
<%@ include file="uploader4replace.jsp" %>
<%@ include file="/systeminfo/DocTopTitle.jsp"%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<iframe id="ClearDocAccessoriesTraceIframe" frameborder=0 scrolling=no src=""  style="display:none"></iframe>

    <input type=hidden name=operation>
    <input type=hidden id="versionId" name=versionId value="<%=versionId%>">
    <input type=hidden name=id value="<%=docid%>">
    <input type=hidden name=docid value="<%=docid%>">
    <input type=hidden name=imagefileId value="<%=imagefileId%>">
    <input type=hidden name=docno value='<%=docno%>'>
    <input type=hidden name=docsubject value="<%=docsubject%>">
    <input type=hidden name=docapprovable value="<%=needapprovecheck%>">
	<input type=hidden name=ownerid value="<%=ownerid%>">
    <input type=hidden name="oldownerid" value="<%=ownerid%>">
    <input type=hidden name="ownerType" value="<%=ownerType%>">    
	<input type=hidden name=doccreatedate value="<%=doccreatedate%>">
	<input type=hidden name=doccreatetime value="<%=doccreatetime%>">
	<input type=hidden name=docstatus value="<%=docstatus%>">
	<input type=hidden name=docedition value="<%=docedition%>">
	<input type=hidden name=doceditionid value="<%=doceditionid%>">
	<input type=hidden name=maincategory value="<%=(maincategory==-1?"":Integer.toString(maincategory))%>">
	<INPUT type=hidden name=subcategory value="<%=(subcategory==-1?"":Integer.toString(subcategory))%>">
	<INPUT type=hidden name=seccategory value="<%=(seccategory==-1?"":Integer.toString(seccategory))%>">
	<input type=hidden name=docpublishtype value="<%=docpublishtype%>">
	<input type=hidden name=docmain value="<%=docmain%>">
<table style="display:none" id="customerTable">
		<tr id="customerTR">
			<td id="customerTD">
			</td>
		</tr>
	</table>
	<input type=hidden id="selectedpubmouldid" name=selectedpubmouldid value="<%=wordmouldid%>">
	<input type=hidden id=assetid name=assetid value="<%=assetid%>">
	<input type=hidden id= crmid name=crmid value="<%=crmid%>">
	<input type=hidden id=itemid name=itemid value="<%=itemid%>">
	<input type=hidden id=projectid name=projectid value="<%=projectid%>">
	<input type=hidden id=financeid name=financeid value="<%=financeid%>">
	<input type=hidden id=doccreaterid name=doccreaterid value="<%=doccreaterid%>">
	<input type=hidden id=docCreaterType name=docCreaterType value="<%=docCreaterType%>">
	<input type="hidden" id="dummycata" name="dummycata" value="<%=dummyIds%>">

	<input type=hidden id=keyword name=keyword value="<%=keyword%>">
	<input type=hidden id=doccode name=doccode value="<%=docCode%>">
	
    <input type=hidden id=topage name=topage value='<%=topageFromOther%>'>

    <input type=hidden id="requestid" name="requestid" value=<%=requestid%>>
    <input type=hidden id="workflowid" name="workflowid" value=<%=workflowid%>>
	<input type=hidden id="hasUsedTemplet" name=hasUsedTemplet value="<%=hasUsedTemplet%>">
	<input type=hidden id="noSavePDF" name="noSavePDF" value="">
	<input type=hidden  id=signatureCount name=signatureCount value="0">
    <input type=hidden id=isFromAccessory name=isFromAccessory value='<%=isFromAccessory?1:0%>'>
    <input type=hidden id="editMouldId" name="editMouldId" value="<%=editMouldId%>">
	<input type=hidden id="versionDetail" name="versionDetail" value="" />

    <%if(isrequest.equals("1")&&(hasright==1||isremark==1)){%>
        <input type=hidden name="isremark" >
        <input type=hidden name="nodeid" value=<%=nodeid%>>
        <input type=hidden name="nodetype" value=<%=nodetype%>>
        <input type=hidden name="src">
        <input type=hidden name="iscreate" value="0">
        <input type=hidden name="formid" value=<%=formid%>>
        <input type=hidden name="isbill" value=<%=isbill%>>
        <input type=hidden name="billid" value=<%=billid%>>
        <input type=hidden name="requestname" value=<%=requestname%>>
        <input type=hidden name="manager" value=<%=ResourceComInfo.getManagerID(""+userid)%>>
        <input type=hidden name="isfromdoc" value="1">
        <input type=hidden name="workflowtype" value=<%=workflowtype%>>
        <input type=hidden name="messageType" value=<%=messageType%>>

		<input type=hidden name="docIds" value="<%=docIds%>">
		<input type=hidden name="crmIds" value="<%=crmIds%>">
		<input type=hidden name="hrmIds" value="<%=hrmIds%>">
		<input type=hidden name="prjIds" value="<%=prjIds%>">
		<input type=hidden name="cptIds" value="<%=cptIds%>">
    <%}%>
    
    <input type="hidden" name="hrmresid" value="<%=hrmresid%>">
	<input type="hidden" name="invalidationdate" value="<%=invalidationdate%>">
	<input type="hidden" name="docmodule" value="<%=wordmouldid%>">
	<input type="hidden" id="canPrintedNum" name="canPrintedNum" value="<%=canPrintedNum%>">
    <textarea name=doccontent style="display:none;width:100%;"><%=doccontent%></textarea>

<div style="position: absolute; left: 0; top: 0; width:100%;height:100%;">
<span id="replaceAcc" style="display:inline-block;height:21px;padding-left:0!important;padding-right:0!important;position:absolute;z-index:99;"></span>
<div id="divContentTab" style="width:100%;height:100%;">
       <table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan" style="text-align:right;">
				<%if(!onlyview){
					if(!fromFlowDoc.equals("1")){
						if (!isPersonalDoc){ 
							if(isrequest.equals("1")){ //从工作流进入的文档
						%>
							<%if(canEditHis && ((!docstatus.equals("5") && hasright == 1) ||  ((docstatus.equals("0") || docstatus.equals("2") || docstatus.equals("1") || docstatus.equals("4")||Util.getIntValue(docstatus,0)<0) && hasright == 0)) ) { %>
							<input type=button class="e8_btn_top" onclick="javascript:webOfficeMenuClickNew(1)" value="<%=SystemEnv.getHtmlLabelName(93, user.getLanguage())%>"></input>
							<%if(openFirstAss&&"true".equalsIgnoreCase(isIE)&&fileExtendName.isEmpty()&&!imagefileName.toLowerCase().endsWith(".pdf")){%>
							<input type=button class="e8_btn_top" onclick="javascript:onEditAcc()" value="<%=SystemEnv.getHtmlLabelName(129740, user.getLanguage())%>"></input>
							<%} %>
							<%
							if((openFirstAss||isFromAccessory)&&ishistory!=1&&showReplaceFile){%>
							<input type=button class="e8_btn_top" id="AccPlaceHolder"   value="<%=SystemEnv.getHtmlLabelName(33029, user.getLanguage())%>"></input>
    					<%} %>
							<%} %>
						<%}else if(canEdit) { %>
						<%if(islastversion&&!(isFromAccessory&&"false".equalsIgnoreCase(isIE))&&(openFirstAss||!isNotOffice)) { %>
							<input type=button class="e8_btn_top" onclick="javascript:webOfficeMenuClickNew(7)" value="<%=SystemEnv.getHtmlLabelName(93, user.getLanguage())%>"></input>
							<%
						}
							if((openFirstAss||isFromAccessory)&&ishistory!=1&&showReplaceFile){%>
							<input type=button class="e8_btn_top" id="AccPlaceHolder"   value="<%=SystemEnv.getHtmlLabelName(33029, user.getLanguage())%>"></input>
    					<%} %>
							<%if(openFirstAss&&"true".equalsIgnoreCase(isIE)&&fileExtendName.isEmpty()&&!imagefileName.toLowerCase().endsWith(".pdf")){%>
							<input type=button class="e8_btn_top" onclick="javascript:onEditAcc()" value="<%=SystemEnv.getHtmlLabelName(129740, user.getLanguage())%>"></input>
    					<%} %>
							<%if(!isFromAccessory&&(docstatus.equals("0")||Util.getIntValue(docstatus,0)<=0)){ %>
								<input type=button class="e8_btn_top" onclick="javascript:onSave();" value="<%=SystemEnv.getHtmlLabelName(615, user.getLanguage())%>"></input>
							<%} %>
						<%}else if(canReader){ %>
							<%if(!isFromAccessory&&(docstatus.equals("0")||Util.getIntValue(docstatus,0)<=0)){ %>
								<input type=button class="e8_btn_top" onclick="javascript:onSave()" value="<%=SystemEnv.getHtmlLabelName(615, user.getLanguage())%>"></input>
							<%} %>
						<%} %>
						<% if(canDownload){ %>
							<input type=button class="e8_btn_top" onclick="javascript:onDownload()" value="<%=SystemEnv.getHtmlLabelName(31156, user.getLanguage())%>"></input>
						<%} %>

						<% if(canShare&&!isFromAccessory){ %>
							<input type=button class="e8_btn_top" onclick="javascript:webOfficeMenuClickNew(8)" value="<%=SystemEnv.getHtmlLabelName(119, user.getLanguage())%>"></input>
						<%} %>

						<%//文档回复， 如果是可以回复的文档且是正常的文档， 可以回复
			    		  if(canReplay&&!isFromAccessory) {
			    		      if(DocReplyUtil.isUseNewReply()){
			    		  	  %>    
			    		  	   <input type=button class="e8_btn_top" onclick="javascript:newDoReply();" value="<%=SystemEnv.getHtmlLabelName(117, user.getLanguage())%>"></input>
			    		  <%	}
			    		  	else{
			    		  	  %>
			    		  	  <input type=button class="e8_btn_top" onclick="javascript:doReply();" value="<%=SystemEnv.getHtmlLabelName(117, user.getLanguage())%>"></input>
			    		 <% 	}
			    		%>
			    		<%} %>
						<%}else{%>
							<input type=button class="e8_btn_top" onclick="javascript:webOfficeMenuClickNew(39)" value="<%=SystemEnv.getHtmlLabelName(93, user.getLanguage())%>"></input>
						<%} %>
					<%}else{ %>
						<%if (istoManagePage) { %>
							<%if (isUseTempletNode) { %>
								<input type=button id="thSure_id" style="<%=((!"1".equals(hasUsedTemplet))&&isUseTempletNode&&isremark==0)?"":"display:none" %>" class="e8_btn_top" onclick="saveTHTemplate(<%= wordmouldid %>)" value="<%=SystemEnv.getHtmlLabelName(21659, user.getLanguage())%>"></input>
								<%if(countNum > 1 && isUseTempletNode && isremark==0){ %>
									<input type=button id="thModeS_id" style="<%=(countNum > 1 && (!"1".equals(hasUsedTemplet))&&isUseTempletNode&&isremark==0)?"":"display:none" %>" class="e8_btn_top" onclick="selectTemplate(<%= mouldSecCategoryId %>,<%=wordmouldid %>)" value="<%=SystemEnv.getHtmlLabelName(21660, user.getLanguage())%>"></input>
								<%} %>
								<input type=button id="thCancel_id" class="e8_btn_top" style="<%=(("1".equals(hasUsedTemplet))&&isUseTempletNode&&isremark==0)?"":"display:none" %>" onclick="useTempletCancel()" value="<%=SystemEnv.getHtmlLabelName(22983, user.getLanguage())%>"></input>
								<input type=button id="thSaveAgain_id" style="<%=(("1".equals(hasUsedTemplet))&&isUseTempletNode&&isremark==0 && !isSignatureNodes)?"":"display:none" %>" class="e8_btn_top" onclick="saveTHTemplateNoConfirm(<%= wordmouldid %>)" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>	
								<input type=button class="e8_btn_top" onclick="backToForm();" value="<%=SystemEnv.getHtmlLabelName(129071, user.getLanguage())%>"></input>
							<%} %>
							<%if( isSignatureNodes){ %>
								<input type=button id="signature_id1" style="<%=(isremark==0)?"":"display:none" %>" class="e8_btn_top" onclick="CreateSignature(0);" value="<%=SystemEnv.getHtmlLabelName(21650, user.getLanguage())%>"></input>
								<input type=button id="signature_id2" style="<%=(isremark==0)?"":"display:none" %>" class="e8_btn_top" onclick="saveIsignatureFun();" value="<%=SystemEnv.getHtmlLabelName(21656, user.getLanguage())%>"></input>
							<%}%>
						<%} %>
						<%if (canPrint) { %>
								<input type=button id="thprint_id1" class="e8_btn_top" onclick="webOfficeMenuClick(47,'');" value="<%=SystemEnv.getHtmlLabelName(257, user.getLanguage())%>"></input>
						<%} %>
					
					<%} %>
				<%}%>
				  <%if((docstatus.equals("1")||docstatus.equals("2")||docstatus.equals("5")) && "1".equals(user.getLogintype())  && ( !isFromAccessory || "1".equals(isrequest)) && isUseEMessager==1){ %>
					<input type=button class="e8_btn_top" onclick="javascript:onDocShare(<%=docid %>,'<%=docsubject%>')" value="<%=SystemEnv.getHtmlLabelName(126091, user.getLanguage())%>"></input>
				  <%} %>

				 <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
	<%-- 文档标题 start --%>
	<%
	List<Map<String,String>> replyDocs = DocComInfo.getParentReplyDoc(""+docid); 
	%>
	<div style="display:none;">
		<brow:browser name="__selectTaohongMould" viewType="0" getBrowserUrlFn="getBrowserUrlFn" getBrowserUrlFnParams='<%=""+ mouldSecCategoryId%>'
			_callback="afterSelectMould" browserBtnID="selectTaohongMouldBtn" isMustInput="1"></brow:browser>
	</div>
	<div class="e8_box demo2">
    	<div class="e8_boxhead" style="<%="1".equals(fromFlowDoc)?"display:none":"" %>">
		<div class="div_e8_xtree" id="div_e8_xtree"></div>
		<div class="e8_tablogo" id="e8_tablogo"></div>
		<div class="e8_ultab">
			<div class="e8_navtab" id="e8_navtab">
				<span id="objName" style="height:30px"></span>
			</div>
			<div>
    	<ul class="tab_menu">
    		<%for(ListIterator<Map<String,String>> it = replyDocs.listIterator();it.hasNext();){ 
    			Map<String,String> replyDoc = it.next();
    		%>
    			<li>
		    		<a href='javascript:openFullWindowForXtable("/docs/docs/DocDsp.jsp?id=<%=replyDoc.get("id") %>");'>
		    			<span style="overflow:hidden;white-space:nowrap;text-overflow:ellipsis;"><%=replyDoc.get("name")%></span>
		    		</a>
	    		</li>
    		<%} %>
    		<% if(DocReplyUtil.isUseNewReply()&&!isFromAccessory){ %>
    		<li>
    		<div style="float: left;"><span><%=SystemEnv.getHtmlLabelName(126385,user.getLanguage())%></span><span><%= " "+Util.null2String(Util.toScreen(ResourceComInfo.getResourcename(""+doclastmoduserid),user.getLanguage()))+" " %></span><span><%=SystemEnv.getHtmlLabelName(126386,user.getLanguage())%></span><span><%= doclastmoddate %> <%= " "+doclastmodtime %></span></div>
		    	<div id="viewcountDiv" class="viewInfo change-font-color" style="height:auto;"><%=SystemEnv.getHtmlLabelName(260,user.getLanguage())%></div><span class="vpSpan change-font-color">(<font><%= readCount_int %></font>)</span>
		    	<script type="text/javascript">
		    		jQuery(function(){
				        jQuery("#viewcountDiv").bind("click",function (){
							onActiveTab('divViewLogRead');
						});
						
						jQuery(".change-font-color").mouseover(function(){
							$(".change-font-color").css("color","#676767");
						}).mouseout(function(){
							$(".change-font-color").css("color","#B8B8B8");
						});
						jQuery(".vpSpan.change-font-color").click(function(){
							$("#viewcountDiv").click();
						});
					 });
		    	</script>
		    	<% if(canReplay) { %>
		    	<% if(isPraise == 0){ %>
		    	<div class="praiseInfo" title="<%=SystemEnv.getHtmlLabelName(32942,user.getLanguage())%>" id="praiseInfo" >
		    	<%=SystemEnv.getHtmlLabelName(32942,user.getLanguage())%>
		    	</div>
		    		<span id="praiseCountSpan" class="praiseSpan">(<font id="praiseCount"><%= praiseCount_int %></font>)</span>
		    	<% } else { %>
			    		<div class="praiseInfo_hot" title="<%=SystemEnv.getHtmlLabelName(32944,user.getLanguage())%>" id="praiseInfo" >
			    		<%=SystemEnv.getHtmlLabelName(32944,user.getLanguage())%>
			    	</div>
			    	<span id="praiseCountSpan" class="praiseSpan_hot">(<font id="praiseCount"><%= praiseCount_int %></font>)</span>
		    	<% } %>
		    	
		    	<div class="magic-line1"></div>
		    	<div id="praiseUsers" class="praiseUserDiv">
					<%
						if(userInfos != null && userInfos.size() > 0)
						{
						    int length = userInfos.size() < 8 ? userInfos.size() : 8;
							for(int i = 0 ; i <  userInfos.size(); i ++)
							{
						    	UserInfo useri = userInfos.get(i);
						    	if(i < 13)
						    	{
					%>
						<a href="javaScript:openhrm(<%= useri.getUserid() %>);" id="<%= useri.getUserid()+"up" %>" title="<%= useri.getUserName() %>" class="praiseuser_a" onclick="pointerXY(event);"><%= useri.getUserName() %></a>
					<% } else { %>
						<a href="javaScript:openhrm(<%= useri.getUserid() %>);" id="<%= useri.getUserid()+"up" %>" title="<%= useri.getUserName() %>" class="praiseuser_a_hidden" onclick="pointerXY(event);"><%= useri.getUserName() %></a>
					 <% } %>
					
				  	<% } if(userInfos.size() > 13 ) {%>
				  		<div id="pumes" style="float: right; width: 130px; margin-top: 10px; margin-bottom: 10px; text-align: left;">
				  		<span style="padding-left: 10px;"><%=SystemEnv.getHtmlLabelName(126387,user.getLanguage())%><font id="fuserFont"><%= userInfos.size() %></font><%=SystemEnv.getHtmlLabelName(126388,user.getLanguage())%></span><div onclick="moreUserView();" class="moreUserView"></div>
				  	<% }%>
				  		<span id="noPraise" style="line-height: 40px;margin-left: 20px;margin-right: 20px;display:none;"><%=SystemEnv.getHtmlLabelName(126390,user.getLanguage())%></span>
				    <% } else { %>
						<span id="noPraise" style="line-height: 40px;margin-left: 20px;margin-right: 20px;"><%=SystemEnv.getHtmlLabelName(126390,user.getLanguage())%></span>
					<% } %>
				</div>
				<script type="text/javascript">
					 var iTime ;
					 jQuery(function(){
				        // 列表美化
						jQuery('#praiseUsers').perfectScrollbar();
						jQuery("#praiseUsers").live('mousedown', function(){
							return false;
						});
						jQuery("#praiseInfo").live('mousedown', function(){
							return false;
						});
						jQuery("html").live('mousedown', function(){
							jQuery("#praiseUsers").fadeOut();
				          	jQuery(".magic-line1").fadeOut();
						});
						
						jQuery("#praiseCountSpan").hover(function() {
								jQuery("#praiseUsers").show();
				          		jQuery(".magic-line1").show();
				          		jQuery(".magic-line1").css('left',jQuery("#praiseCount").position().left-9);
				          		jQuery("#praiseUsers").css('margin-left',jQuery("#praiseCount").position().left-100);
				          		return;
				        }).mouseout(function(event){
				          	var _left = Math.floor(jQuery(this).position().left);
				          	var _right = Math.floor(_left + this.clientWidth);
				          	var _top = Math.floor(jQuery(this).position().top);
				          	var _eventX = event.clientX;
				          	var _eventY = event.clientY;
				          	if(_left >= _eventX || _right <= _eventX || _top >= _eventY){
				          		jQuery("#praiseUsers").fadeOut();
				          		jQuery(".magic-line1").fadeOut();
				          	}
				          });
					});
					
					
					function moreUserView()
					{
						jQuery(".praiseuser_a_hidden").each(function(){
							jQuery(this).removeClass("praiseuser_a_hidden");
							jQuery(this).addClass("praiseuser_a_show");
						})
						$ldiv = jQuery("<div />");
						$ldiv.addClass("lettelUserView");
						$ldiv.click(function(){
							 lettelUserView();
						});
						jQuery("#praiseUsers").append($ldiv);
						jQuery("#pumes").hide();
						jQuery('#praiseUsers').perfectScrollbar("resize");
					}
					
					function lettelUserView()
					{
						jQuery(".praiseuser_a_show").each(function(){
							jQuery(this).removeClass("praiseuser_a_show");
							jQuery(this).addClass("praiseuser_a_hidden");
						})
						jQuery("#pumes").show();
						jQuery(".lettelUserView").hide();
						jQuery('#praiseUsers').perfectScrollbar("resize");
					}
					
					function downloads(fileid){
						window.open("/weaver/weaver.file.FileDownload?fileid="+fileid+"&download=1");
					}
					
				</script>
				<% } %>
	    	</li>
	    	<% } %>
    	</ul>
	<div style="clear:left"></div>
	<%-- 文档标题 end --%>
		<div id="rightBox" class="e8_rightBox"></div>
    	</div>
		</div>
		</div>
	    <div class="tab_box _synergyBox">
	        <div style="height:100%;">
	
	<div id="divContent" style="width:100%;overflow:hidden;">
		<%-- iWebOffice编辑控件 start --%>
		<iframe id="e8shadowifrm" name="e8shadowifrm" frameborder="none" scrolling="no" style="<%=fromFlowDoc.equals("1")?"display:none;":"" %>overflow:hidden;z-index:1;width:100%;height:23px;position:absolute;top:37px;visibility:hidden;left:0px;background-color:#fff;" src="javascript:false"></iframe>
		<div id="divContentInfo" class="e8_propTab " style="width:100%;height:100%;">
			<table cellpadding="0" cellspacing="0" style="width:100%;height:100%;">
				<tr height='100%'>
					<td bgcolor=menu style="vertical-align:top;position:relative;">
						<div id="objectDiv" style="width:100%;height:100%;background-color:#fff;">
						 <%if ((fileExtendName.isEmpty()||(!fileExtendName.isEmpty()&&isToDocDspExt))&&!sysremindflag){%>
							<%if(iframeLoad||isNotOffice){ %>
								<div style="height:100%;">
								<iframe id="previewDoc" style="border:none;background-color:#fff;" src="<%= previewUrl%>" frameborder="0" width="100%" height="100%"></iframe>
								</div>
							<%}else{ %>
								<div style="display:<%=iframeLoad?"none":""%>">
									<OBJECT id="WebOffice" name="WebOffice" classid="<%=mClassId%>" style="POSITION:absolute;width:0;height:0;<%if("1".equals(isTextInForm)){%>top:-120px<%}else{%>top:<%=fromFlowDoc.equals("1")?"-23px":"-23px" %><%}%>;" codebase="<%=mClientUrl%>" >
									</OBJECT>
								</div>
							<%} %>
							<span id=StatusBar style="display:none">&nbsp;</span>
						 <%}else{%>	
							<div style="height:100%;">
								<div style="height:100%;">
								<iframe id="previewDoc" onload="finalDo('view')" style="border:none;background-color:#fff;" src="<%=sysremindurl%>" frameborder="0" width="100%" height="100%"></iframe>
							</div>
							</div>
						 <%}%>	
						</div>
					</td>
				</tr>

			<%if(isUseBarCodeThisJsp.equals("1")){%>
				<tr>
					<td bgcolor=menu style="vertical-align:top;" id="PDF417ManagerTd">
						<div style="display: none;">
							<OBJECT id="PDF417Manager"  classid="<%=PDF417ManagerClassId%>"   codebase="<%=PDF417ManagerClientName%>"></OBJECT>
						</div>
					</td>
				</tr>
			<%}%>
				<tr>
					<td bgcolor=menu style="vertical-align:top;" id="SignatureAPITd">
					<%if(isSignatureNodes||isSaveDecryptPDF){
					  if("1".equals(signatureType)){%>
						<OBJECT id=SignatureAPI classid="clsid:A0689619-3E99-4012-A83F-E902CF3505BD"  codebase="iSignatureWPS_APIP.ocx#version=<%=wps_version%>" 
						width=0 height=0 align=center hspace=0 vspace=0></OBJECT>
					<%}else if("2".equals(signatureType)){%>
						<object id="SignatureAPI" width="0" height="0" classid="clsid:857F9703-BE32-4BD4-92A4-D8079C10BD41"></object>
					<%}else{%>	
						<OBJECT id=SignatureAPI classid="clsid:79F9A6F8-7DBE-4098-A040-E6E0C3CF2001"  codebase="iSignatureAPI.ocx#version=5,0,2,0" width=0 height=0 align=center hspace=0 vspace=0></OBJECT>
					<%}}%>
					</td>
				</tr>

			</table>
		</div>
		<%-- iWebOffice编辑控件 end --%>
		<!-- 文档属性栏 start -->
		<div id="divProp" class="e8_propTab" style="display:none;width:100%;height:100%;">
			<DIV style="width:100%; height:100%; overflow: visible" class="x-panel-body x-panel-body-noheader x-panel-body-noborder">
				<jsp:include page="/docs/docs/DocDspExtBaseInfo.jsp">
					<jsp:param name="f_weaver_belongto_userid" value="<%=f_weaver_belongto_userid%>" />
					<jsp:param name="f_weaver_belongto_usertype" value="<%=f_weaver_belongto_usertype%>" />
					<jsp:param name="seccategory" value="<%=seccategory%>" />
					<jsp:param name="languageId" value="<%=languageId%>" />
					<jsp:param name="isPersonalDoc" value="<%=isPersonalDoc%>" />
					<jsp:param name="publishable" value="<%=publishable%>" />
					<jsp:param name="docid" value="<%=docid%>" />
					<jsp:param name="wordmouldid" value="<%=wordmouldid%>" />
					<jsp:param name="canPublish" value="<%=canPublish%>" />
					<jsp:param name="selectMouldType" value="<%=selectMouldType%>" />
					<jsp:param name="fromFlowDoc" value="<%=fromFlowDoc%>" />
					<jsp:param name="filetype" value="<%=filetype%>" />
					<jsp:param name="dummyIds" value="<%=dummyIds%>" />
					<jsp:param name="userCategory" value="<%=userCategory%>" />
				</jsp:include>
			</DIV>
		</div>
		<!-- 文档属性栏 end -->
		<!-- 文档附件栏 start -->
		<div id="divAcc" class="e8_propTab" style="display:none;width:100%;height:100%;">
			<DIV style="width:100%; height:100%; overflow: visible;border:none;" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
<%
			String sessionPara=""+docid+"_"+userid+"_"+logintype;
			session.setAttribute("right_view_"+sessionPara,"1");			
%>
			<iframe id="e8DocAccIfrm" style="border:none;" frameborder="0" width="100%" height="100%"></iframe>
			</DIV>
		</div>
		<!-- 文档附件栏 end -->
		<% if(canReplay) { %>
		<!-- 文档回复栏 start -->
		<div id="divReplay" class="e8_propTab" style="display:none;width:100%;height:100%;">
			<DIV style="width:100%; height:100%; overflow: visible" class="x-panel-body x-panel-body-noheader x-panel-body-noborder">
				<%
					if(DocReplyUtil.isUseNewReply()){
						String replyviewsessionPara=""+docid+"_"+user.getUID()+"_"+user.getLogintype();
						session.setAttribute("view_reply_aboutfiles_"+replyviewsessionPara,"1");
					}
				%>
					<iframe  id="replyInfoIfrm" name="replyInfoIfrm" style="border:none;"  frameborder="0" width="100%" height="100%"></iframe>				
				
			</DIV>
		</div>
		<!-- 文档回复栏 end -->
	<% } %>
		<!-- 文档共享栏 start -->
		<div id="divShare" class="e8_propTab" style="display:none;width:100%;height:100%;">
			<DIV style="width:100%; height:100%; overflow: visible;border:none;" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
			<iframe  id="shareListIfrm" style="border:none;" frameborder="0" width="100%" height="100%"></iframe>
			</DIV>
		</div>
		<!-- 文档共享栏 end -->
		<% if(isEditionOpen) { %>
		<!-- 文档版本栏 start -->
		<div id="divVer" class="e8_propTab" style="display:none;width:100%;height:100%;">
			<DIV style="width:100%; height:100%; overflow: visible;border:none;" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
			<iframe  id="versionListIfrm" style="border:none;"  frameborder="0" width="100%" height="100%"></iframe>
			</DIV>
		</div>
		<!-- 文档版本栏 end -->
		<% } %>
		<% if(canViewLog) { %>
		<!-- 文档日志栏 start -->
		<div id="divViewLog" class="e8_propTab" style="display:none;width:100%;height:100%;">
			<DIV style="width:100%; height:100%; overflow: visible;border:none;" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
			<iframe  id="logListIfrm" style="border:none;"frameborder="0" width="100%" height="100%"></iframe>
			</DIV>
		</div>
		<!-- 文档日志栏 end -->
		<% } %>
			
		<% if(DocMark.isAllowMark(""+seccategory)){ %>
		<!-- 文档打分栏 start -->
		<div id="divMark" class="e8_propTab" style="display:none;width:100%;height:100%;">
			<DIV style="width:100%; height:100%; overflow: visible;border:none;" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
			<iframe id="markListIfrm" style="border:none;" frameborder="0" width="100%" height="100%"></iframe>
			</DIV>
		</div>
		<!-- 文档打分栏 end -->
		<% } %>
		

	</div>
	<%if(isAutoExtendInfo>0&&accessorycount>0 && !isFromAccessory){ %>
		<iframe id="e8DocAccviewIframe" style="position:absolute;bottom:60px;z-index:2;width:100%;width:44px;height:44px;right:15px;filter:alpha(opacity=0);opacity:0;" frameborder="none" src=""></iframe>
		<jsp:include page="/docs/docs/DocAccView.jsp">
			<jsp:param name="f_weaver_belongto_userid" value="<%=f_weaver_belongto_userid%>" />
			<jsp:param name="f_weaver_belongto_usertype" value="<%=f_weaver_belongto_usertype%>" />
			<jsp:param name="seccategory" value="<%=seccategory%>" />
		    <jsp:param name="docid" value="<%=docid%>" />
			<jsp:param name="canEdit" value="<%=canEdit%>" />
		    <jsp:param name="canDownload" value="<%=canDownload%>" />
		    <jsp:param name="language" value="<%=user.getLanguage()%>" />
		    <jsp:param name="bacthDownloadFlag" value="<%=DocUtil.getBatchDownloadFlag(docid)%>" />
		    <jsp:param name="mode" value="view" />
		    <jsp:param name="isFromWf" value="false" />
		    <jsp:param name="maxUploadImageSize" value="<%=DocUtil.getBatchDownloadFlag(docid)%>" />
		    <jsp:param name="votingId" value="<%=votingId%>" />	
		</jsp:include>
	<%} %>
		</div>
	</div>
</div>
</div>

	<!-- 底部选项卡栏 start -->
	<%if(!isFromAccessory){%>
	<div style="position:relative;">
	<div class="e8_weavertab" id="divTab" style="width:100%;position:relative;">

		<DIV style="WIDTH: 100%;" class="x-tab-panel-footer x-tab-panel-footer-noborder">
		<DIV class=x-tab-strip-spacer></DIV>
		<DIV class=x-tab-strip-wrap>
		<UL class="x-tab-strip x-tab-strip-bottom">
		
		<LI id=divContentInfoATab class="e8_weavertab_li x-tab-strip-active" onclick="onActiveTab('divContentInfo');">
		<A class=x-tab-strip-close onclick="return false;"></A>
		<A class=x-tab-right onclick="return false;" href="#">
		<EM class=x-tab-left>
		<SPAN class=x-tab-strip-inner><SPAN class="x-tab-strip-text "><%= SystemEnv.getHtmlLabelName(18332,user.getLanguage())%></SPAN></SPAN>
		</EM>
		</A>
		</LI>
		
		<LI id=divPropATab class="e8_weavertab_li " onclick="onActiveTab('divProp');">
		<A class=x-tab-strip-close onclick="return false;"></A>
		<A class=x-tab-right onclick="return false;" href="#">
		<EM class=x-tab-left>
		<SPAN class=x-tab-strip-inner><SPAN class="x-tab-strip-text "><%= SystemEnv.getHtmlLabelName(33197,user.getLanguage())%></SPAN></SPAN>
		</EM>
		</A>
		</LI>
		
		<LI id=divAccATab class=" "  onclick="onActiveTab('divAcc');">
		<A class=x-tab-strip-close onclick="return false;"></A>
		<A class=x-tab-right onclick="return false;" href="#">
		<EM class=x-tab-left>
		<SPAN class=x-tab-strip-inner><SPAN class="x-tab-strip-text " id="divAccATabTitle"><script type="text/javascript">document.write(wmsg.doc.acc + '(<%=accessorycount%>)');</script></SPAN></SPAN>
		</EM>
		</A>
		</LI>
		
		<% if(canReplay) { %>
		<LI id=divReplayATab class=" "  onclick="onActiveTab('divReplay');">
		<A class=x-tab-strip-close onclick="return false;"></A>
		<A class=x-tab-right onclick="return false;" href="#">
		<EM class=x-tab-left>
		<SPAN class=x-tab-strip-inner><SPAN class="x-tab-strip-text " id="divReplayATabTitle"><script type="text/javascript">document.write(wmsg.doc.reply + '(<%=replaydoccount%>)');</script></SPAN></SPAN>
		</EM>
		</A>
		</LI>
		<% } %>
		
		<LI id=divShareATab class=" "  onclick="onActiveTab('divShare');">
		<A class=x-tab-strip-close onclick="return false;"></A>
		<A class=x-tab-right onclick="return false;" href="#">
		<EM class=x-tab-left>
		<SPAN class=x-tab-strip-inner><SPAN class="x-tab-strip-text "><script type="text/javascript">document.write(wmsg.doc.share);</script></SPAN></SPAN>
		</EM>
		</A>
		</LI>
		<% if(isEditionOpen) { %>
		<LI id=divVerATab class=" "  onclick="onActiveTab('divVer');">
		<A class=x-tab-strip-close onclick="return false;"></A>
		<A class=x-tab-right onclick="return false;" href="#">
		<EM class=x-tab-left>
		<SPAN class=x-tab-strip-inner><SPAN class="x-tab-strip-text "><script type="text/javascript">document.write(wmsg.doc.version);</script></SPAN></SPAN>
		</EM>
		</A>
		</LI>
		<% } %>
		<% if(canViewLog) { %>
		<LI id=divViewLogATab class=" "  onclick="onActiveTab('divViewLog');">
		<A class=x-tab-strip-close onclick="return false;"></A>
		<A class=x-tab-right onclick="return false;" href="#">
		<EM class=x-tab-left>
		<SPAN class=x-tab-strip-inner><SPAN class="x-tab-strip-text "><%=SystemEnv.getHtmlLabelName(21990,user.getLanguage())%></SPAN></SPAN>
		</EM>
		</A>
		</LI>
		<% } %>

		<% if(DocMark.isAllowMark(""+seccategory)){ %>
		<LI id=divMarkATab class=" "  onclick="onActiveTab('divMark');">
		<A class=x-tab-strip-close onclick="return false;"></A>
		<A class=x-tab-right onclick="return false;" href="#">
		<EM class=x-tab-left>
		<SPAN class=x-tab-strip-inner><SPAN class="x-tab-strip-text "><script type="text/javascript">document.write(wmsg.doc.mark);</script></SPAN></SPAN>
		</EM>
		</A>
		</LI>
		<% } %>
		
		<LI class=x-tab-edge></LI>
		<DIV class=x-clear></DIV></UL></DIV></DIV>
		<DIV style="float:right;right:0px;position:absolute;top:3px;" class="x-tab-panel-footer-noborder">
			<DIV id=divPropTileIcon class="x-tool x-tool-expand-south " onclick="onExpandOrCollapse();">&nbsp;</DIV>
		</DIV>
		<div style="clear:both;"></div>
	</div>
	<div id="e8_shadow"></div>
	</div>
	<%}%>
		<!-- 底部选项卡栏 end -->
	<div id="divPropTab" style="display:none;width: 100%">
</div>
</div>
</FORM>

<jsp:include page="/docs/docs/DocUtil.jsp">
	<jsp:param name="f_weaver_belongto_userid" value="<%=f_weaver_belongto_userid%>" />
	<jsp:param name="f_weaver_belongto_usertype" value="<%=f_weaver_belongto_usertype%>" />
    <jsp:param name="seccategory" value="<%=seccategory%>" />
    <jsp:param name="docid" value="<%=docid%>" />
    <jsp:param name="maindoc" value="<%=maindoc%>" />
    <jsp:param name="ishistory" value="<%=ishistory%>" />
    <jsp:param name="doceditionid" value="<%=doceditionid%>" />
    <jsp:param name="olddocid" value="<%=olddocid%>" />
    <jsp:param name="isrequest" value="<%=isrequest%>" />
    <jsp:param name="desrequestid" value="<%=desrequestid%>" />
    <jsp:param name="requestid" value="<%=requestid%>" />
    <jsp:param name="fromFlowDoc" value="<%=fromFlowDoc%>" />
    <jsp:param name="from" value="<%=from%>" />
    <jsp:param name="userCategory" value="<%=userCategory%>" />
    <jsp:param name="blnOsp" value="<%=blnOsp%>" />
    <jsp:param name="isfromcowork" value="<%=isfromcowork%>" />
    <jsp:param name="topageFromOther" value="<%=topageFromOther%>" />
    <jsp:param name="meetingid" value="<%=meetingid%>" />
    <jsp:param name="isSetShare" value="<%=isSetShare%>" />
    <jsp:param name="doc_topage" value="<%=doc_topage%>" />
    <jsp:param name="isfromext" value="0" />
    <jsp:param name="topage" value="<%=URLEncoder.encode(topageFromOther)%>" />
    <jsp:param name="topage2" value="<%=URLEncoder.encode(topageFromOther)%>" />
    <jsp:param name="isNoTurnWhenHasToPage" value="<%=isNoTurnWhenHasToPage%>" />		
    <jsp:param name="isAppendTypeField" value="<%=isAppendTypeField%>" />		
</jsp:include>

</body>
</html>

<jsp:include page="/docs/docs/DocComponents.jsp">
	<jsp:param name="f_weaver_belongto_userid" value="<%=f_weaver_belongto_userid%>" />
	<jsp:param name="f_weaver_belongto_usertype" value="<%=f_weaver_belongto_usertype%>" />
	<jsp:param value="<%=user.getLanguage()%>" name="language"/>
	<jsp:param value="getBase" name="operation"/>
</jsp:include>

<SCRIPT LANGUAGE="JavaScript">
	var isFromWf=<%=("1").equals(fromFlowDoc)%>;
	var isFromWfTH = <%=isApplyMould&&isUseTempletNode&&isremark==0%>
	var isFromWfSN = <%=isSignatureNodes%>;
	var docid="<%=docid%>";
	var seccategory="<%=seccategory%>";	
	var parentids="<%=parentids%>";
	var docTitle="<%=Util.encodeJS(docsubject)%>";
	var isReply="<%=isreply.equals("1")%>";
	var doceditionid="<%=doceditionid%>";
	var readerCanViewHistoryEdition="<%=readerCanViewHistoryEdition%>";
	var canEditHis="<%=canEditHis%>";

	var showType="view";
	var coworkid="<%=coworkid%>";
	var meetingid="<%=meetingid%>";
	
	var canShare=<%=canShare%>;
	var canEdit=<%=canEdit%>;
	var canDownload=<%=canDownload%>;//canEdit
	var canViewLog=<%=blnRealViewLog%>;
	var canDocMark=<%=DocMark.isAllowMark(""+seccategory)%>;
	var canReplay=<%=canReplay%>
	var readCount_int=<%=readCount_int%>	
	var maxUploadImageSize="<%=DocUtil.getMaxUploadImageSize(seccategory)%>";
	var relationable=false;
	var pagename="docdspext";	
	var requestid="<%=requestid%>";
	function adjustContentHeight(type,deltaHeight){
		var lang=<%=(user.getLanguage()==8)?"true":"false"%>;
		try{
			deltaHeight = jQuery("div.e8AccListArea").height();
			<%if("1".equals(isTextInForm)){%>
			jQuery("div.e8AccListArea").css("display","none");
			jQuery("div.e8AccListBtn").hide();
			jQuery("#e8DocAccviewIframe").hide();
			<%}%>
			if(jQuery("div.e8AccListArea").css("display")=="none"){
				deltaHeight = 0;
			}
			var propTabHeight = 34;
			if(document.getElementById("divPropTab")&&document.getElementById("divPropTab").style.display=="none") propTabHeight = (isFromWf)?10:34;
			<%if(isFromAccessory){%>
				if(propTabHeight==34){
					propTabHeight=0
				}
			<%}%>
			var pageHeight=document.body.clientHeight;
			var pageWidth=document.body.clientWidth;
			if(isFromWf) propTabHeight += 25;
			jQuery("#divContentTab").height(pageHeight - propTabHeight);
			jQuery(".e8_box").height(pageHeight - propTabHeight);
			if(isFromWf) propTabHeight -= 50;
			jQuery(".tab_box").height(pageHeight - propTabHeight-jQuery(".e8_boxhead").height());
			var divContentHeight=jQuery(".tab_box").height()-deltaHeight;
			if(isFromWf) divContentHeight += 25;

			var divContentWidth=pageWidth;
			if(divContentHeight!=null && divContentHeight>0){
				jQuery("#divContent").height(divContentHeight);
				jQuery("#divContent").width(divContentWidth);
				jQuery("#previewDoc").height(divContentHeight);
			<%if("1".equals(isTextInForm)){%>
				jQuery("#WebOffice").height(divContentHeight+87);
			<%}else{%>
				jQuery("#WebOffice").height(divContentHeight);
			<%}%>
				jQuery("#WebOffice").width(divContentWidth);
			}
			try{
				jQuery("#e8DocAccIfrm").parent().height(jQuery(".tab_box").height());
			}catch(e){
			}
	        try{
				jQuery("#shareListIfrm").parent().height(jQuery(".tab_box").height());
			}catch(e){
			}
			try{
				jQuery("#markListIfrm").parent().height(jQuery(".tab_box").height());
			}catch(e){
			}
	        try{
				jQuery("#resourceListIfrm").parent().height(jQuery(".tab_box").height());
			}catch(e){
			}
			try{
				jQuery("#logListIfrm").parent().height(jQuery(".tab_box").height());
			}catch(e){
			}
	        try{
				jQuery("#versionListIfrm").parent().height(jQuery(".tab_box").height());
			}catch(e){
			}
			onResizeDiv();
		} catch(e){	}
	}
	var isPDF=0;
	var canEditPDF=0;
	var accessorycount=<%=accessorycount%>;
	var isEditionOpen=<%=isEditionOpen%>;
	var message21658 = "<%=SystemEnv.getHtmlLabelName(21658,languageId)%>";
	var message21700 = "<%=SystemEnv.getHtmlLabelName(21700,languageId)%>";
	var message21701 = "<%=SystemEnv.getHtmlLabelName(21701,languageId)%>";
	var message24355 = "<%=SystemEnv.getHtmlLabelName(24355,languageId)%>";
	var isAutoExtendInfo=<%=isAutoExtendInfo%>;

	var lastTab = "divProp";
	var fromTab = '0';
	function onExpandOrCollapse(show,from){
		
		var flag = false;
		if(document.getElementById("divPropTab")&&document.getElementById("divPropTab").style.display=="none"||show) flag = true;
		var e8_shadow = jQuery("#e8_shadow");
		if(flag){
			e8_shadow.show();
			if(document.getElementById("BUTTONbtn_ShowOrHidden")) document.getElementById("BUTTONbtn_ShowOrHidden").value=wmsg.base.hiddenProp;
			jQuery("#divTab #divPropTileIcon").removeClass("x-tool-expand-south").addClass("x-tool-collapse-south-over ");
			if(!from){
				onActiveTab(lastTab);
			}
		}else{
			e8_shadow.hide();
			document.getElementById("divPropTab").style.display = "none";
			if(document.getElementById("BUTTONbtn_ShowOrHidden")) document.getElementById("BUTTONbtn_ShowOrHidden").value=wmsg.base.showProp;
			jQuery("#divTab #divPropTileIcon").removeClass("x-tool-collapse-south-over").addClass("x-tool-expand-south");
			jQuery("#divTab li.x-tab-strip-active").removeClass("x-tab-strip-active");
		}
		adjustContentHeight();
		try {
			loadExt();
		} catch(e){}
	}
	function doAddWorkPlan_ext() {
		document.location.href = "/workplan/data/WorkPlan.jsp?docid=<%=docid%>&add=1";
	}
<%
	  String accUrl="/docs/docs/DocAcc.jsp?canEdit="+canEdit+"&canDownload="+canDownload+"&language="+user.getLanguage()+"&bacthDownloadFlag="+DocUtil.getBatchDownloadFlag(docid)+"&docid="+docid+"&mode=view&pagename=docdsp&isFromWf=false&operation=getDivAcc&maxUploadImageSize="+DocUtil.getBatchDownloadFlag(docid)+"&isrequest="+isrequest+"&requestid="+requestid+"&desrequestid="+desrequestid+"&meetingid="+meetingid+"&votingId="+votingId+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+formmodeparamsStr;
	  String replyInfoUrl=null;
	  if(DocReplyUtil.isUseNewReply()){
		  replyInfoUrl="/docs/reply/DocReplyGetNew.jsp?docid="+docid+"&secid="+seccategory;
	  }else{
		  replyInfoUrl="/docs/docs/DocReplyGetNew.jsp?docid="+docid+"&secid="+seccategory;
	  }
	  String shareUrl="/docs/docs/DocShareGetNew.jsp?language="+user.getLanguage()+"&id="+docid+"&mode=view&pagename=docdsp&canShare="+canShare+"&operation=getDivShare"; 
	  String verUrl="/docs/docs/DocVersionGetNew.jsp?language="+user.getLanguage()+"&docid="+docid+"&mode=view&pagename=docdsp&canShare="+canShare+"&operation=getDivVer&doceditionid="+doceditionid+"&readerCanViewHistoryEdition="+readerCanViewHistoryEdition+"&canEditHis="+canEditHis; 
	  String logUrl="/docs/DocDetailLogTab.jsp?height=all&_fromURL=0&language="+user.getLanguage()+"&id="+docid+"&mode=view&pagename=docdsp&canShare="+canShare+"&operation=getDivViewLog";
	  String logUrlReaded="/docs/DocDetailLogTab.jsp?height=all&_fromURL=5&language="+user.getLanguage()+"&id="+docid+"&mode=view&pagename=docdsp&canShare="+canShare+"&operation=getDivViewLog";
	  String docmarkUrl="/docs/docmark/DocMarkAdd.jsp?language="+user.getLanguage()+"&docId="+docid+"&mode=view&pagename=docdsp&secId="+seccategory+"&operation=getDivMark&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype; 	  
%>
<%
	RecordSet.executeSql("select d2.isLogControl from docdetail d1,DocSecCategory d2 where d1.seccategory=d2.id and d1.id=" + docid);
	int isLogControl = 0;
	if (RecordSet.next()) {
		isLogControl = Util.getIntValue(Util.null2String(RecordSet.getString("isLogControl")),0);
	}
%>
var has_e8DocAccIfrm=0;
var has_replyInfoIfrm=0;
var has_shareListIfrm=0;
var has_versionListIfrm=0;
var has_logListIfrm=0;
var has_markListIfrm=0;

	function onActiveTab(tab,notOpen){
		lastTab = tab;
		if(tab=="divContentInfo"){
			var e8AccListArea = jQuery("div.e8AccListArea");
			if(e8AccListArea.length>0){
				if(e8AccListArea.data("isClosed")===true){
					jQuery("div.e8AccListBtn").show();
					jQuery("#e8DocAccviewIframe").show();
				}else{
					e8AccListArea.show();
					jQuery("#e8DocAccviewIframe").hide();
				}
			}
		}else{
			jQuery("div.e8AccListArea").hide();
	 		jQuery("div.e8AccListBtn").hide();
	 		jQuery("#e8DocAccviewIframe").hide();
		}
		document.getElementById("divProp").style.display='none';
		document.getElementById("divAcc").style.display='none';
		document.getElementById("divContentInfo").style.display='none';

		if(tab=="divAcc"&&has_e8DocAccIfrm==0){
			has_e8DocAccIfrm=1;
			document.getElementById("e8DocAccIfrm").src="<%=accUrl%>";
		}
		if(tab=="divReplay"&&has_replyInfoIfrm==0){
			has_replyInfoIfrm=1;
			document.getElementById("replyInfoIfrm").src="<%=replyInfoUrl%>&fromTab="+fromTab;
		}
		if(tab=="divShare"&&has_shareListIfrm==0){
			has_shareListIfrm=1;
			document.getElementById("shareListIfrm").src="<%=shareUrl%>";
		}
		if(tab=="divVer"&&has_versionListIfrm==0){
			has_versionListIfrm=1;
			document.getElementById("versionListIfrm").src="<%=verUrl%>";
		}
		if(tab=="divViewLog"&&has_logListIfrm==0){
			has_logListIfrm=1;
			document.getElementById("logListIfrm").src="<%=logUrl%>";
		}
		if(tab=="divViewLogRead"&&has_logListIfrm==0){
			has_logListIfrm=1;
			tab = "divViewLog";
			document.getElementById("logListIfrm").src="<%=logUrlReaded%>";
		}
		if(tab=="divMark"&&has_markListIfrm==0){
			has_markListIfrm=1;
			document.getElementById("markListIfrm").src="<%=docmarkUrl%>";
		}

		var e8_shadow = jQuery("#e8_shadow");
		<% if(canReplay) { %>
		
		<% if(DocReplyUtil.isUseNewReply()){ %>
			if(fromTab == "1"){
				window.setTimeout(function(){
					try{
						replyInfoIfrm.window.initRemark();
						fromTab = "0";
					}catch(e){}
				},200);		
			}else{
				window.setTimeout(function(){
					try{
						replyInfoIfrm.window.hideRemark();
					}catch(e){}
				},200);	
			}
		<% } %>
		document.getElementById("divReplay").style.display='none';	
		
		<% } %>
		document.getElementById("divShare").style.display='none';
		<% if(isEditionOpen) { %>
		document.getElementById("divVer").style.display='none';
		<% } %>
		<% if(canViewLog) { %>
		document.getElementById("divViewLog").style.display='none';
		<% } %>
		<% if(DocMark.isAllowMark(""+seccategory)){ %>
		document.getElementById("divMark").style.display='none';
		<% } %>

		
		document.getElementById("divPropATab").className = "";
		document.getElementById("divAccATab").className = "";
		document.getElementById("divContentInfoATab").className = "";
		<% if(canReplay) { %>
		document.getElementById("divReplayATab").className = "";
		<% } %>
		document.getElementById("divShareATab").className = "";
		<% if(isEditionOpen) { %>
		document.getElementById("divVerATab").className = "";
		<% } %>
		<% if(canViewLog) { %>
		document.getElementById("divViewLogATab").className = "";
		<% } %>
		<% if(DocMark.isAllowMark(""+seccategory)){ %>
		document.getElementById("divMarkATab").className = "";
		<% } %>

		
		if(!notOpen){
			if(tab == "divViewLogRead")
			{
				document.getElementById("divViewLog").style.display='block';
				document.getElementById("divViewLogATab").className='x-tab-strip-active';
				setE8ShadowPosition("divViewLog");
			}
			else
			{
				document.getElementById(tab).style.display='block';
				document.getElementById(tab+"ATab").className='x-tab-strip-active';
				setE8ShadowPosition(tab);
			}
		}else{
			e8_shadow.hide();
		}

		try {
			if(!notOpen){
				onExpandOrCollapse(true,true);
			}
			loadExt();
			eval("doGet"+tab+"();");
			onResizeDiv();
		} catch(e){}
	}
	
	function setE8ShadowPosition(tab){
		var e8_shadow = jQuery("#e8_shadow");
		var _left = jQuery(document.getElementById(tab+"ATab")).offset().left-1;
		if(tab=="divContentInfo")_left+=1;
		var _top = jQuery("#divTab").position().top;
		e8_shadow.css({
			"left":_left,
			"top":_top
		});
		e8_shadow.show();
	}

	function onResizeDiv() {
		if(document.getElementById("divAcc").style.display!='none')
			resizedivAcc();
		<% if(canReplay) { %>
		else if(document.getElementById("divReplay").style.display!='none')
			resizedivReplay();
		<% } %>
		else if(document.getElementById("divShare").style.display!='none')
			resizedivShare();
		<% if(isEditionOpen) { %>
		else if(document.getElementById("divVer").style.display!='none')
			resizedivVer();
		<% } %>
		<% if(canViewLog) { %>
		else if(document.getElementById("divViewLog").style.display!='none')
			resizedivViewLog();
		<% } %>
		<% if(DocMark.isAllowMark(""+seccategory)){ %>
		else if(document.getElementById("divMark").style.display!='none')
			resizedivMark();
		<% } %>

	}
	
	var replaceAcc = null;
	jQuery(document).ready(function(){
		replaceAcc = jQuery("#replaceAcc");
		bindAttach();

	});

	function bindAttach(){
		if(jQuery("#AccPlaceHolder").length==0)return;
		resetReplaceAccPosition();
		bindUploaderDiv(replaceAcc);
		replaceAcc.hover(function(){
			 jQuery("#rightBox").find("#AccPlaceHolder").addClass("e8_top_btnHover");
		},function(){
			 jQuery("#rightBox").find("#AccPlaceHolder").removeClass("e8_top_btnHover");
		});
	}
	
	function resetReplaceAccPosition(){
		if(jQuery("#AccPlaceHolder").length==0)return;
		var placeHolder = jQuery("#rightBox").find("#AccPlaceHolder");
		if(placeHolder.length>0){
			var width = placeHolder.outerWidth();
			var left = placeHolder.offset().left;
			var top = placeHolder.offset().top;
			replaceAcc.css({
				"width":width+"px",
				"left":left+"px",
				"top":top+"px"
			});
		}else{
			setTimeout(function(){
				resetReplaceAccPosition();
			},500);
		}
	}

	jQuery(window).resize(function(){
		resetReplaceAccPosition();
	});
	
	function used4SelectAccVersion(versionId){
		jQuery("#selectAccVersionBtn").attr("data-versionid",versionId);
		jQuery("#selectAccVersionBtn").trigger("click");	
	}
	
	function getBrowserUrl4selectAccVersion(){
		return "/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/docs/listVersion.jsp?versionId="+jQuery("#selectAccVersionBtn").attr("data-versionid")+"&docid=<%=docid%>"+"&canDownload=<%=canDownload%>";	
	}
	
	function afterSelectAccVersion(e,datas,params,name){
		if(datas){			
			if(datas.id!=""){
				window.location="DocDspExt.jsp?id=<%=docid%>&versionId="+datas.id+"&fromFlowDoc=<%=fromFlowDoc%>&isrequest=<%=isrequest%>&requestid=<%=requestid%>&isFromAccessory=true&isNoTurnWhenHasToPage=true&topage=<%=URLEncoder.encode(topageFromOther)%>&meetingid=<%=meetingid%>&votingId=<%=votingId%>&workplanid=<%=workplanid%>";
			}
		}	
	}

function doNothing(){  
    window.event.returnValue=false;  
    return false;
}
	jQuery(document).ready(
		function(){

    <%if(fromFlowDoc.equals("1") && (filetype.equals(".doc")||filetype.equals(".xls")||filetype.equals(".wps")||filetype.equals(".et"))){%>
    	try{
        jQuery('#rightMenu').remove();
        jQuery("body",window.parent.parent.frames["workflowtext"].document).mouseenter(function(){
            window.parent.parent.document.getElementById('rightMenu').style.visibility="hidden";
            window.parent.parent.document.getElementById('rightMenu').style.display="none";
        });
    	}catch(e){}
    <%}%>
			
			try{
				onLoad();
			} catch(e){}
			
			try{
				document.getElementById("divContentTab").style.display='block';
				document.getElementById("divPropTab").style.display = "none";
				//document.getElementById("divPropTabCollapsed").style.display = "block";

				//onActiveTab("divProp",true);
				setE8ShadowPosition("divContentInfo");
				
				document.getElementById('rightMenu').style.visibility="hidden";
				document.getElementById("divMenu").style.display='';	
			} catch(e){}

			adjustContentHeight("load");
			if(isFromWf) {			 
				try{
					if(isFromWfTH && isFromWfSN){
					  //Ext.getCmp('signature_id1').hide();
					  document.getElementById('signature_id1').style.display = "none";
					  //Ext.getCmp('signature_id2').hide();
					  document.getElementById('signature_id2').style.display = "none";
					}
			    	//Ext.getCmp('hide_id').hide();
			    	document.getElementById('hide_id').style.display = "none";
				} catch(e){}
		    }
				finalDo("view");
			try{	
				onLoadEnd();
			} catch(e){}
		}   
	);
	
	function webOfficeMenuClickNew(type){
		webOfficeMenuClick(type,"");
	}
</SCRIPT>
<script type="text/javascript" src="/js/DocDspExt_wev8.js"></script>
<jsp:include page="/docs/docs/DocDspExtScript.jsp">
	<jsp:param name="f_weaver_belongto_userid" value="<%=f_weaver_belongto_userid%>" />
	<jsp:param name="f_weaver_belongto_usertype" value="<%=f_weaver_belongto_usertype%>" />
    <jsp:param name="docid" value="<%=docid%>" />
    <jsp:param name="fromFlowDoc" value="<%=fromFlowDoc%>" />
    <jsp:param name="isIWebOffice2006" value="<%=isIWebOffice2006%>" />
    <jsp:param name="requestid" value="<%=requestid%>" />
    <jsp:param name="ifVersion" value="<%=ifVersion%>" />
    <jsp:param name="isCompellentMark" value="<%=isCompellentMark%>" />
    <jsp:param name="canPostil" value="<%=canPostil%>" />
    <jsp:param name="nodeid" value="<%=nodeid%>" />
    <jsp:param name="isFromAccessory" value="<%=isFromAccessory%>" />
    <jsp:param name="topageFromOther" value="<%=topageFromOther%>" />
    <jsp:param name="isrequest" value="<%=isrequest%>" />
    <jsp:param name="meetingid" value="<%=meetingid%>" />
    <jsp:param name="hasUsedTemplet" value="<%=hasUsedTemplet%>" />
    <jsp:param name="isPrintControl" value="<%=isPrintControl%>" />
    <jsp:param name="doccreaterid" value="<%=doccreaterid%>" />
    <jsp:param name="userid" value="<%=userid%>" />
    <jsp:param name="hasPrintNode" value="<%=hasPrintNode%>" />
    <jsp:param name="isPrintNode" value="<%=isPrintNode%>" />
    <jsp:param name="printApplyWorkflowId" value="<%=printApplyWorkflowId%>" />
    <jsp:param name="isagentOfprintApply" value="<%=isagentOfprintApply%>" />
    <jsp:param name="username" value="<%=username%>" />
    <jsp:param name="countNum" value="<%=countNum%>" />
    <jsp:param name="isremark" value="<%=isremark%>" />
    <jsp:param name="isUseTempletNode" value="<%=(isUseTempletNode?1:0)%>" />
    <jsp:param name="wordmouldid" value="<%=wordmouldid%>" />
    <jsp:param name="versionId" value="<%=versionId%>" />
    <jsp:param name="isSignatureNodes" value="<%=isSignatureNodes%>" />
    <jsp:param name="CurrentDate" value="<%=CurrentDate%>" />
    <jsp:param name="CurrentTime" value="<%=CurrentTime%>" />
    <jsp:param name="replyid" value="<%=replyid%>" />
    <jsp:param name="parentids" value="<%=parentids%>" />
    <jsp:param name="workflowid" value="<%=workflowid%>" />
    <jsp:param name="PDF417ManagerCopyRight" value="<%=PDF417ManagerCopyRight%>" />
	<jsp:param name="canPrint" value="<%=(canPrint?1:0)%>" />
	<jsp:param name="isCleanCopyNodes" value="<%=isCleanCopyNodes%>" />
	<jsp:param name="currentnodeid" value="<%=currentnodeid%>" />	
</jsp:include>
<%!
private Map<String,Object> getMenuBars(
		boolean onlyview,String fromFlowDoc,boolean isPersonalDoc,String isrequest,boolean canEditHis,String docstatus,
		int hasright,int languageId,boolean canEdit,boolean canReader,boolean canShare,boolean canDel,String docreplyable,
		weaver.docs.senddoc.OpenSendDoc OpenSendDoc,int docid,boolean cannewworkflow,boolean canPublish,boolean canInvalidate,
		boolean canArchive,boolean canCancel,boolean canReopen,boolean canCheckOut,boolean canCheckIn,boolean canCheckInCompellably,
		User user,int docdepartmentid,boolean canPrintApply,boolean canPrint,String isPrintControl,int isbill,int formid,
		String docapprovable,int isremark,weaver.docs.category.SecCategoryComInfo secCategoryComInfo,int seccategory,boolean canViewLog,
		String logintype,boolean hasRightOfViewHisVersion,boolean isCurrentNode,int defaultDocLocked,String filetype,boolean canDownload,
		String nodetype,String isreply,boolean istoManagePage,boolean isUseTempletNode,int wordmouldid,int mouldSecCategoryId,
		boolean isSignatureNodes,boolean cantop,int istop,int accessorycount,int countNum,String hasUsedTemplet,String RCMenu,int RCMenuHeight,int RCMenuHeightStep,boolean  iframeLoad,boolean  isFromAccessory,boolean openFirstAss,String isIE,String fileExtendName,boolean isToDocDspExt,boolean islastversion,boolean hasOpenEdition,boolean isCustomer,String imagefileName,String docsubject,int isUseEMessager) {

		boolean isNotOffice=false;
		if(!(imagefileName.toLowerCase().endsWith(".doc") || 
			imagefileName.toLowerCase().endsWith(".docx") || 
			imagefileName.toLowerCase().endsWith(".ppt") || 
			imagefileName.toLowerCase().endsWith(".pptx") || 
			imagefileName.toLowerCase().endsWith(".wps") || 
			imagefileName.toLowerCase().endsWith(".xls") || 
			imagefileName.toLowerCase().endsWith(".xlsx"))){
			isNotOffice = true;//非office文档
		}
		Map<String,Object> menus = new HashMap<String,Object>();

		if(!isFromAccessory){//如果不是查看附件页面，菜单按之前的逻辑，否则单独为查看附件页面列出附件的菜单
		if (!onlyview) {
			if (!fromFlowDoc.equals("1")) {
				if (!isPersonalDoc) {
					if (isrequest.equals("1")) { //从工作流进入的文档
						//// 如果从工作流进入，文档审批流程的当前操作者在文档不为正常和归档的情况下可以修改，其它流程的在文档为非审批正常或者退回状态下可以修改
						//如果从工作流进入，文档审批流程的当前操作者在文档不为归档的情况下可以修改，其他操作者在文档为草稿、正常或者退回状态下可以修改。
						if(canEditHis && ((!docstatus.equals("5") && hasright == 1) ||  ((docstatus.equals("0") || docstatus.equals("2") || docstatus.equals("1") || docstatus.equals("4")||Util.getIntValue(docstatus,0)<0) && hasright == 0)) ) {
							RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:webOfficeMenuClickNew(1),_top} " ;
   	 						RCMenuHeight += RCMenuHeightStep ;
						}
						// 如果是转发，有批注按钮

					}
					// 从非工作流进入的文档
					else if (canEdit&&islastversion) {
						RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:webOfficeMenuClickNew(7),_top} " ;
   	 					RCMenuHeight += RCMenuHeightStep ;
						if (docstatus.equals("0") || Util.getIntValue(docstatus, 0) <= 0) {							
							RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSave(),_top} " ;
   	 						RCMenuHeight += RCMenuHeightStep ;
						}
					}
					// 草稿时编辑提交
					else if (canReader) {
						if (docstatus.equals("0") || Util.getIntValue(docstatus, 0) <= 0) {
							RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSave(),_top} " ;
   	 						RCMenuHeight += RCMenuHeightStep ;
						}
					}
					// 具有下载权限的人,有下载按钮
					if(canDownload&&!openFirstAss){//单附件打开的时候把下载移到附件菜单组的位置(因为是对附件的操作)
						RCMenu += "{"+SystemEnv.getHtmlLabelName(31156,user.getLanguage())+",javascript:onDownload(),_top} " ;
						RCMenuHeight += RCMenuHeightStep ;
					}
					// 具有编辑权限的人,对文档可以修改共享的, 有共享按钮
					if (canShare) {
						RCMenu += "{"+SystemEnv.getHtmlLabelName(119,user.getLanguage())+",javascript:webOfficeMenuClickNew(8),_top} " ;
   	 					RCMenuHeight += RCMenuHeightStep ;
					}

					// 文档本人在文档非归档,非审批后正常,非打开状态的时候可以删除文档
					if (canDel) {
						RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:webOfficeMenuClickNew(9),_top} " ;
   	 					RCMenuHeight += RCMenuHeightStep ;
					}

					// 具有编辑权限的人对审批后正常的文档可以重新打开
					if (canEdit && docstatus.equals("10")) {
						RCMenu += "{"+SystemEnv.getHtmlLabelName(244,user.getLanguage())+",javascript:webOfficeMenuClickNew(10),_top} " ;
   	 					RCMenuHeight += RCMenuHeightStep ;
					}

					//文档回复， 如果是可以回复的文档且是正常的文档， 可以回复
					if (docreplyable.equals("1") && (docstatus.equals("2") || docstatus.equals("1"))) {
						RCMenu += "{"+SystemEnv.getHtmlLabelName(18540,user.getLanguage())+",javascript:webOfficeMenuClickNew(11),_top} " ;
   	 					RCMenuHeight += RCMenuHeightStep ;
					}

					// 如果可以对其它系统发送该文档,可以发送这个文档
					if (OpenSendDoc.inSendDoc("" + docid)) {
						RCMenu += "{"+SystemEnv.getHtmlLabelName(18540,user.getLanguage())+",javascript:webOfficeMenuClickNew(12),_top} " ;
   	 					RCMenuHeight += RCMenuHeightStep ;

					}
					//分离改造	 标签1239替换为16392  	15295替换为1044  
					// 如果文档不在打开状态,可以新建工作流
					if (!docstatus.equals("3") &&!docstatus.equals("7") && cannewworkflow) {
						
						RCMenu += "{"+SystemEnv.getHtmlLabelName(16392,user.getLanguage())+",javascript:webOfficeMenuClickNew(13),_top} " ;
   	 					RCMenuHeight += RCMenuHeightStep ;
					}
					//新建计划
					if(!isCustomer&&!docstatus.equals("7")){
						RCMenu += "{"+SystemEnv.getHtmlLabelName(18481,user.getLanguage())+",javascript:doAddWorkPlan_ext(),_top} " ;
						RCMenuHeight += RCMenuHeightStep ;
					}
					/** 分离改造
					RCMenu += "{"+SystemEnv.getHtmlLabelName(19759,user.getLanguage())+",javascript:webOfficeMenuClickNew(45),_top} " ;
   	 				RCMenuHeight += RCMenuHeightStep ;
					**/
					RCMenu += "{"+SystemEnv.getHtmlLabelName(1044,user.getLanguage())+",javascript:webOfficeMenuClickNew(14),_top} " ;
   	 				RCMenuHeight += RCMenuHeightStep ;

					// 具有文档管理员权限的人可以对待发布文档进行发布
					if (canPublish) {
						RCMenu += "{"+SystemEnv.getHtmlLabelName(114,user.getLanguage())+",javascript:webOfficeMenuClickNew(15),_top} " ;
   	 					RCMenuHeight += RCMenuHeightStep ;
					}
					if (canInvalidate) {
						RCMenu += "{"+SystemEnv.getHtmlLabelName(15750,user.getLanguage())+",javascript:webOfficeMenuClickNew(16),_top} " ;
   	 					RCMenuHeight += RCMenuHeightStep ;
					}

					// 具有文档管理员权限的人可以对归档文档进行重新打开操作
					// 具有文档管理员权限的人可以对作废文档进行重新打开操作
					if (canReopen) {
						RCMenu += "{"+SystemEnv.getHtmlLabelName(244,user.getLanguage())+",javascript:webOfficeMenuClickNew(19),_top} " ;
   	 					RCMenuHeight += RCMenuHeightStep ;
					}

					//文档签出，且签出人为当前用户，则可进行文档签入操作
					if (canCheckIn) {
						RCMenu += "{"+SystemEnv.getHtmlLabelName(19693,user.getLanguage())+",javascript:webOfficeMenuClickNew(26),_top} " ;
   	 					RCMenuHeight += RCMenuHeightStep ;
					}

					//文档签出，且签出人不为当前用户，当前用户具有文档管理员或目录管理员权限，则可进行强制签入操作
					if (canCheckInCompellably) {
						RCMenu += "{"+SystemEnv.getHtmlLabelName(19688,user.getLanguage())+",javascript:webOfficeMenuClickNew(27),_top} " ;
   	 					RCMenuHeight += RCMenuHeightStep ;
					}

					// 具有文档管理员权限的人可以对正常文档进行归档
					if (HrmUserVarify.checkUserRight("DocEdit:Reload", user, docdepartmentid) && docstatus.equals("5")) {
						RCMenu += "{"+SystemEnv.getHtmlLabelName(256,user.getLanguage())+",javascript:webOfficeMenuClickNew(30),_top} " ;
   	 					RCMenuHeight += RCMenuHeightStep ;
					}
					if (canPrintApply) {
						RCMenu += "{"+SystemEnv.getHtmlLabelName(21530,user.getLanguage())+",javascript:webOfficeMenuClickNew(48),_top} " ;
   	 					RCMenuHeight += RCMenuHeightStep ;
					}
					if (canPrint&&!iframeLoad) {
						RCMenu += "{"+SystemEnv.getHtmlLabelName(257,user.getLanguage())+",javascript:webOfficeMenuClickNew(47),_top} " ;
   	 					RCMenuHeight += RCMenuHeightStep ;
					}
					if (isPrintControl.equals("1")) {
						RCMenu += "{"+SystemEnv.getHtmlLabelName(21533,user.getLanguage())+",javascript:webOfficeMenuClickNew(49),_top} " ;
   	 					RCMenuHeight += RCMenuHeightStep ;
					}
					// 从审批工作流进入的, 或者具有编辑权限并且文档有审批的，都有审批意见按钮
					if (isbill == 1 && formid == 28) {
						if ((canEdit && docapprovable.equals("1")) || isremark == 1 || hasright == 1) {
							RCMenu += "{"+SystemEnv.getHtmlLabelName(1008,user.getLanguage())+",javascript:webOfficeMenuClickNew(31),_top} " ;
   	 						RCMenuHeight += RCMenuHeightStep ;
						}
					}
					//当文档目录设定为"按文档日志权限查看"时，对于有文档查看权限的人也能查看日志(TD12005)
						if ((secCategoryComInfo.getLogviewtype(seccategory) == 1 && HrmUserVarify.checkUserRight("FileLogView:View", user)||canEdit) || (secCategoryComInfo.getLogviewtype(seccategory) == 0)) {
						// 具有编辑权限的人都可以查看文档的查看日志
						if (canViewLog && logintype.equals("1")) {
							RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:webOfficeMenuClickNew(32),_top} " ;
   	 						RCMenuHeight += RCMenuHeightStep ;
						} else if (canEdit && logintype.equals("2")) {
							RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:webOfficeMenuClickNew(33),_top} " ;
   	 						RCMenuHeight += RCMenuHeightStep ;
						}
					}
						/**分离改造，把置顶/取消置顶移到 文档菜单组**/
						if (HrmUserVarify.checkUserRight("Document:Top", user)) {
							if (cantop) {
								RCMenu += "{"+SystemEnv.getHtmlLabelName(23784,user.getLanguage())+",javascript:DocToTop(" + docid + ",1),_top} " ;
								RCMenuHeight += RCMenuHeightStep ;
							}
							if (istop == 1) {
								RCMenu += "{"+SystemEnv.getHtmlLabelName(24675,user.getLanguage())+",javascript:DocToTop(" + docid + ",2),_top} " ;
								RCMenuHeight += RCMenuHeightStep ;
							}
						}
					/*分离改造 单附件打开的时候有打开版本菜单  加入分组分割线*/
					if(openFirstAss){
						RCMenu	 += "{__splitHR__,__hr__,_self} " ;
						RCMenuHeight += 1;
					}
					if(canEdit&&openFirstAss&&"true".equalsIgnoreCase(isIE)&&fileExtendName.isEmpty()&&!imagefileName.toLowerCase().endsWith(".pdf")){
						RCMenu += "{"+SystemEnv.getHtmlLabelName(129740,user.getLanguage())+",javascript:onEditAcc(),_top} " ;
   	 					RCMenuHeight += RCMenuHeightStep ;
					} 
					if(canDownload&&openFirstAss){//单附件打开的时候把下载移到附件菜单组的位置(因为是对附件的操作)
						RCMenu += "{"+SystemEnv.getHtmlLabelName(31156,user.getLanguage())+",javascript:onDownload(),_top} " ;
						RCMenuHeight += RCMenuHeightStep ;
					}
					if ((hasRightOfViewHisVersion || canEditHis)&&hasOpenEdition) {
						RCMenu += "{"+SystemEnv.getHtmlLabelName(16384,user.getLanguage())+",javascript:webOfficeMenuClickNew(35),_top} " ;
   	 					RCMenuHeight += RCMenuHeightStep ;
					}
					if (canEdit || (defaultDocLocked != 1 && !docstatus.equals("5")) || hasRightOfViewHisVersion) {
						if ((filetype.equals(".doc")||filetype.equals(".docx")|| filetype.equals(".wps"))&&!iframeLoad) {
							RCMenu += "{"+SystemEnv.getHtmlLabelName(16385,user.getLanguage())+",javascript:webOfficeMenuClickNew(36),_top} " ;
   	 						RCMenuHeight += RCMenuHeightStep ;
						}
					}
				} else {
					RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:webOfficeMenuClickNew(39),_top} " ;
   	 				RCMenuHeight += RCMenuHeightStep ;
				}
			} else {
				if (istoManagePage) {
					if (isUseTempletNode) {
						RCMenu += "{"+SystemEnv.getHtmlLabelName(21659,user.getLanguage())+",javascript:saveTHTemplate(" + wordmouldid + "),_top} " ;
   	 					RCMenuHeight += RCMenuHeightStep ;
						if(countNum > 1 && isUseTempletNode && isremark==0){
							RCMenu += "{"+SystemEnv.getHtmlLabelName(21660,user.getLanguage())+",javascript:selectTemplate(" + mouldSecCategoryId + "," + wordmouldid + "),_top} " ;
							RCMenuHeight += RCMenuHeightStep ;
						}
						RCMenu += "{"+SystemEnv.getHtmlLabelName(22983,user.getLanguage())+",javascript:useTempletCancel(),_top} " ;
   	 					RCMenuHeight += RCMenuHeightStep ;
						RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveTHTemplateNoConfirm(" + wordmouldid + "),_top} " ;
   	 					RCMenuHeight += RCMenuHeightStep ;
					}
					if (isSignatureNodes) {/*是否显示盖章*/
					    RCMenu += "{"+SystemEnv.getHtmlLabelName(21650,user.getLanguage())+",javascript:CreateSignature(0),_top} " ;
					    RCMenuHeight += RCMenuHeightStep ;
					    RCMenu += "{"+SystemEnv.getHtmlLabelName(21656,user.getLanguage())+",javascript:saveIsignatureFun(),_top} " ;
					    RCMenuHeight += RCMenuHeightStep ;
					}	
				}
				if(canDownload){
					RCMenu += "{"+SystemEnv.getHtmlLabelName(31156,user.getLanguage())+",javascript:onDownload(),_top} " ;
					RCMenuHeight += RCMenuHeightStep ;
				}
				if ((hasRightOfViewHisVersion|| canEditHis)&&hasOpenEdition) {
					RCMenu += "{"+SystemEnv.getHtmlLabelName(16384,user.getLanguage())+",javascript:webOfficeMenuClickNew(35),_top} " ;
					RCMenuHeight += RCMenuHeightStep ;
			    }				
				if (canPrint&&!iframeLoad) {
					RCMenu += "{"+SystemEnv.getHtmlLabelName(257,user.getLanguage())+",javascript:webOfficeMenuClickNew(47),_top} " ;
   	 				RCMenuHeight += RCMenuHeightStep ;
				}
				if (canEdit || (defaultDocLocked != 1 && !docstatus.equals("5")) || hasRightOfViewHisVersion) {
					if ((filetype.equals(".doc") ||filetype.equals(".docx")|| filetype.equals(".wps"))&&!iframeLoad) {
						RCMenu += "{"+SystemEnv.getHtmlLabelName(16385,user.getLanguage())+",javascript:webOfficeMenuClickNew(36),_top} " ;
						RCMenuHeight += RCMenuHeightStep ;
					}
				}
				RecordSet rs = new RecordSet();
				rs.executeProc("DocImageFile_SelectByDocid", "" + docid);
				if (rs.next()) {
					RCMenu += "{"+SystemEnv.getHtmlLabelName(31208,user.getLanguage())+",javascript:doImgAcc(),_top} " ;
					RCMenuHeight += RCMenuHeightStep ;
				}
			}
		}
		}else{//分离改造  查看附件的时候为附件单独设置菜单
			if (canEdit&&"true".equalsIgnoreCase(isIE)&&!isNotOffice&&islastversion) {
				RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:webOfficeMenuClickNew(7),_top} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			if(canDownload){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(31156,user.getLanguage())+",javascript:onDownload(),_top} " ;
   	 			RCMenuHeight += RCMenuHeightStep ;
			}
			if ((hasRightOfViewHisVersion || canEditHis)&&hasOpenEdition) {
				RCMenu += "{"+SystemEnv.getHtmlLabelName(16384,user.getLanguage())+",javascript:webOfficeMenuClickNew(35),_top} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			if (canEdit || (defaultDocLocked != 1 && !docstatus.equals("5")) || hasRightOfViewHisVersion) {
				if ((filetype.equals(".doc")||filetype.equals(".docx")|| filetype.equals(".wps"))&&!iframeLoad) {
					RCMenu += "{"+SystemEnv.getHtmlLabelName(16385,user.getLanguage())+",javascript:webOfficeMenuClickNew(36),_top} " ;
					RCMenuHeight += RCMenuHeightStep ;
				}
			}
			if (canPrint&&!isNotOffice) {
				RCMenu += "{"+SystemEnv.getHtmlLabelName(257,user.getLanguage())+",javascript:webOfficeMenuClickNew(47),_top} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		}
		if((docstatus.equals("1")||docstatus.equals("2")||docstatus.equals("5")) && "1".equals(user.getLogintype()) && ( !isFromAccessory || "1".equals(isrequest)) && isUseEMessager==1){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(126091,user.getLanguage())+",javascript:onDocShare("+docid+",\\\""+docsubject+"\\\"),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;				
		}
		menus.put("RCMenu",RCMenu);
		menus.put("RCMenuHeight",RCMenuHeight);
		return menus;
	}
%>
