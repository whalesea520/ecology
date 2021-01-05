<%@page import="weaver.formmode.setup.ModeRightInfoExtend"%>
<%@page import="weaver.formmode.setup.ModeRightInfo"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.docs.docs.CustomFieldManager" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%

response.setHeader("Pragma","no-cache");

response.setHeader("Cache-Control","no-cache");

response.setDateHeader("Expires",0);

%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.net.*,weaver.general.Util" %>
<%@ page import="weaver.systeminfo.setting.HrmUserSettingComInfo" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="weaver.file.Prop" %>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryManager" class="weaver.docs.category.SecCategoryManager" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" /> 
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="DocDetailLog" class="weaver.docs.DocDetailLog" scope="page" />
<jsp:useBean id="MouldManager" class="weaver.docs.mould.MouldManager" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="AssetAssortmentComInfo" class="weaver.lgc.maintenance.AssetAssortmentComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DocViewer" class="weaver.docs.docs.DocViewer" scope="page"/>
<jsp:useBean id="Record" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="OpenSendDoc" class="weaver.docs.senddoc.OpenSendDoc" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="DocUserSelfUtil" class="weaver.docs.docs.DocUserSelfUtil" scope="page"/>
<jsp:useBean id="DocDsp" class="weaver.docs.docs.DocDsp" scope="page"/>
<jsp:useBean id="VotingManager" class="weaver.voting.VotingManager" scope="page"/>
<jsp:useBean id="CoworkDAO" class="weaver.cowork.CoworkDAO" scope="page"/>
<jsp:useBean id="DocUtil" class="weaver.docs.docs.DocUtil" scope="page"/>
<jsp:useBean id="SpopForDoc" class="weaver.splitepage.operate.SpopForDoc" scope="page"/>

<jsp:useBean id="SecCategoryMouldComInfo" class="weaver.docs.category.SecCategoryMouldComInfo" scope="page"/>
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page"/>
<jsp:useBean id="DocCoder" class="weaver.docs.docs.DocCoder" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="DocMouldComInfo" class="weaver.docs.mould.DocMouldComInfo" scope="page" />

<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<jsp:useBean id="rsDummyDoc" class="weaver.conn.RecordSet" scope="page"/> 
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="RequestAnnexUpload" class="weaver.workflow.request.RequestAnnexUpload" scope="page" />
<jsp:useBean id="DocMark" class="weaver.docs.docmark.DocMark" scope="page" />
<jsp:useBean id="ResourceConditionManager" class="weaver.workflow.request.ResourceConditionManager" scope="page"/>
<jsp:useBean id="MeetingUtil" class="weaver.meeting.MeetingUtil" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="BlogDao" class="weaver.blog.BlogDao" scope="page"/>
<jsp:useBean id="shareManager" class="weaver.share.ShareManager" scope="page" />
<jsp:useBean id="workplanService" class="weaver.WorkPlan.WorkPlanService" scope="page" />
<jsp:useBean id="docReply"
	class="weaver.docs.docs.reply.DocReplyManager" scope="page" />
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page"/>
<%@ page import="weaver.docs.docs.reply.PraiseInfo"%>
<%@ page import="weaver.docs.docs.reply.UserInfo"%>
<%@ page import="weaver.docs.docs.reply.DocReplyUtil"%>
<%

String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");
HrmUserSettingComInfo userSetting=new HrmUserSettingComInfo();
String belongtoshow = userSetting.getBelongtoshowByUserId(user.getUID()+""); 
String belongtoids = user.getBelongtoids();
String account_type = user.getAccount_type();

String pointUrl = Util.null2String(request.getParameter("pointUrl")); // 指定版本查看标记
int imagefileId = Util.getIntValue(request.getParameter("imagefileId"),0);
int pointImagefileId = imagefileId;// 指定pdf文件的imagefileId

int docid = Util.getIntValue(request.getParameter("id"),0);
//页面操作类型，如果为提交状态页面的请求，默认值为sub，TD23929。
String pagestatus = Util.null2String(request.getParameter("pstate")); 
int meetingid = Util.getIntValue(request.getParameter("meetingid"),0);
int workplanid = Util.getIntValue(request.getParameter("workplanid"),0);
//文档弹出窗口次数开始
String popnum = Util.null2String(request.getParameter("popnum"));
int is_popnum = 0;
if(!"".equals(popnum)){

 docid = Util.getIntValue(popnum.substring(0,popnum.indexOf("_")));

}
//文档弹出窗口次数结束

int olddocid=Util.getIntValue(request.getParameter("olddocid"),0);
if(olddocid<1) olddocid=docid;

//增加日志记录标示，已经记录阅读日志的在后面的转发页面(如docdspext.jsp)不再记录
boolean  hasviewlog=false;
//董平添加 修改BUG1483 原因:查看ID=0的文档，系统会将文档全部列出来
if (docid==0){
    response.sendRedirect("/notice/Deleted.jsp?showtype=doc0");
    return ;
}
rs.executeSql("select DocSubject from Docdetail where id="+docid);
if(!rs.next()){
    response.sendRedirect("/notice/Deleted.jsp?showtype=doc");
    return ;
}
String  formmodeparamsStr = "";
String formmodeflag = StringHelper.null2String(request.getParameter("formmode_authorize"));
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
		//zengh  判断下是否文档存了新版本
		ModeRightInfoExtend modeRightInfoExtend=new ModeRightInfoExtend();
		int newDocId=modeRightInfoExtend.updateModeFieldIfNewDocid(docid,modeId,formmodebillId,fieldid);
		if(newDocId!=-1){
			response.sendRedirect(request.getRequestURI()+"?"+request.getQueryString().replace("&id="+docid+"&","&id="+newDocId+"&"));
		}
		formmodeAuthorizeInfo = modeRightInfo.isFormModeAuthorize(formmodeflag, modeId, formmodebillId, fieldid, docid);
	}
}
String fromFlowDoc=Util.null2String(request.getParameter("fromFlowDoc"));  //来源于流程建文挡
boolean  blnOsp = "true".equals(request.getParameter("blnOsp")) ;   //共享提醒的Session名字
String selectedpubmould = Util.null2String(request.getParameter("selectedpubmould")); //选择显示模版的ID

//user info
int userid=user.getUID();
String logintype = user.getLogintype();
String username=ResourceComInfo.getResourcename(""+userid);
String userSeclevel = user.getSeclevel();
String userType = ""+user.getType();
String userdepartment = ""+user.getUserDepartment();
String usersubcomany = ""+user.getUserSubCompany1();

//判断新建的是不是个人文档
boolean isPersonalDoc = false ;
String from =  Util.null2String(request.getParameter("from"));
int userCategory= Util.getIntValue(request.getParameter("userCategory"),0);
//System.out.println("userCategory is "+userCategory);
int shareparentid= Util.getIntValue(request.getParameter("shareparentid"),0);

if ("personalDoc".equals(from)){
    isPersonalDoc = true ;
}

//TD.5091判断是否客户
boolean isCustomer = false;
if(user.getLogintype().equals("2")){
    isCustomer = true ;
}

int messageid=Util.getIntValue(request.getParameter("messageid"),0);
String isrequest = Util.null2String(request.getParameter("isrequest"));
int desrequestid = Util.getIntValue(request.getParameter("desrequestid"),0);

char flag=Util.getSeparator() ;
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);
int requestid=Util.getIntValue(request.getParameter("requestid"),0);
int votingId=Util.getIntValue(request.getParameter("votingId"),0);

String requestname="";
int workflowid=0;
int formid=0;
int isbill = -1;
int billid=0;
int nodeid=0;
String nodetype="0";
int hasright=0;
String status="";
int creater=0;
int isremark=0;
int operatortype = 0 ;
int replyid = 0 ;
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

String topageFromOther=Util.null2String(request.getParameter("topage"));

DocManager.resetParameter();
DocManager.setId(docid);
DocManager.getDocInfoById();

int docType = DocManager.getDocType();

/*判断是否是PDF文档*/
if(12==docType&&imagefileId<=0){
	rs.executeSql("select imagefileid from docimagefile where docid="+docid+" and (isextfile is null or isextfile<>'1') order by versionId desc ");
	if(rs.next()){
		imagefileId=Util.getIntValue(rs.getString("imagefileid"));
	}
}
//文档中心的是否打开附件控制
String isOpenFirstAss = Util.null2String(request.getParameter("isOpenFirstAss"));
//isAppendTypeField参数标识  当前字段类型是附件上传类型
String isAppendTypeField = Util.null2String(request.getParameter("isAppendTypeField"));
String versionId_fromAcc = Util.null2String(request.getParameter("versionId"));
boolean isFromAccessory="true".equals(request.getParameter("isFromAccessory"))?true:false;
boolean isPDF = DocDsp.isPDF(docid,imagefileId,Util.getIntValue(isOpenFirstAss,1));
boolean isPDF_First=isPDF;
if(imagefileId==0&&docType == 2) isPDF = false;




if(docType == 2&&!isPDF){
    //response.sendRedirect("DocDspExt.jsp?fromFlowDoc="+fromFlowDoc+"&from="+from+"&userCategory="+userCategory+"&id="+docid+"&isrequest="+isrequest+"&requestid="+requestid+"&blnOsp="+blnOsp);
    response.sendRedirect("DocDspExt.jsp?fromFlowDoc="+fromFlowDoc+"&from="+from+"&isFromAccessory="+isFromAccessory+"&userCategory="+userCategory+"&id="+docid+"&olddocid="+olddocid+"&isrequest="+isrequest+"&requestid="+requestid+"&votingId="+votingId+"&desrequestid="+desrequestid+"&blnOsp="+blnOsp+"&topage="+URLEncoder.encode(topageFromOther)+"&meetingid="+meetingid+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&hasviewlog="+hasviewlog+"&workplanid="+workplanid+formmodeparamsStr);

	return ;
}
%>
<HTML><HEAD>
<script src='/ueditor/ueditor.uparse_wev8.js'></script>
<SCRIPT LANGUAGE="javaScript">
function onSavePDF(){
	//alert("onsavepdf");
	try
	{
		if(document.getElementById("doccontentifm").contentWindow.onSave(true)){
			mybody.onbeforeunload=null;
			showPrompt("<%=SystemEnv.getHtmlLabelName(18885,user.getLanguage())%>");
			Ext.getCmp("divContentTab").getBottomToolbar().disable();
			document.weaver.submit();
		}
	}
	catch (e)
	{
		//alert(e);
	}
	
}
function onSavePDFOnline(){
	try {
		document.getElementById("doccontentifm").contentWindow.onSave();
	} catch (e){}
}

</script>

<%
String checkOutMessage=Util.null2String(request.getParameter("checkOutMessage"));  //已被检出提示信息
checkOutMessage=java.net.URLDecoder.decode(checkOutMessage,"UTF-8");

if(!checkOutMessage.equals("")){
%>
<SCRIPT LANGUAGE="JavaScript">
alert("<%=checkOutMessage%>");
</SCRIPT>
<%
}
int praiseCount_int = 0;
int isPraise = 0;

PraiseInfo praiseInfo = docReply.getPraiseInfoByDocid(DocManager.getDocid()+"",user.getUID());
if(praiseInfo.getUsers() != null)
{
    praiseCount_int = praiseInfo.getUsers().size();
    isPraise = praiseInfo.getIsPraise();
}

List<UserInfo> userInfos = praiseInfo.getUsers();

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
String docno = DocManager.getDocno();

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

boolean blnRealViewLog=false;
//子目录信息
RecordSet.executeProc("Doc_SecCategory_SelectByID",seccategory+"");
RecordSet.next();
String categoryname=Util.toScreenToEdit(RecordSet.getString("categoryname"),user.getLanguage());
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
String needapprovecheck="";
String iscopycontrol=Util.null2String(""+RecordSet.getString("defaultLockedDoc"));//锁定查看文档
if(approvewfid.equals(""))  approvewfid="0";
if(approvewfid.equals("0")) needapprovecheck="0";
else needapprovecheck="1";

String hasaccessory =Util.toScreen(RecordSet.getString("hasaccessory"),user.getLanguage());
int accessorynum = Util.getIntValue(RecordSet.getString("accessorynum"),user.getLanguage());
String hasasset=Util.toScreen(RecordSet.getString("hasasset"),user.getLanguage());
String assetlabel=Util.toScreen(RecordSet.getString("assetlabel"),user.getLanguage());
String hasitems =Util.toScreen(RecordSet.getString("hasitems"),user.getLanguage());
String itemlabel =Util.toScreenToEdit(RecordSet.getString("itemlabel"),user.getLanguage());
String hashrmres =Util.toScreen(RecordSet.getString("hashrmres"),user.getLanguage());
String hrmreslabel =Util.toScreenToEdit(RecordSet.getString("hrmreslabel"),user.getLanguage());
String hascrm =Util.toScreen(RecordSet.getString("hascrm"),user.getLanguage());
String crmlabel =Util.toScreenToEdit(RecordSet.getString("crmlabel"),user.getLanguage());
String hasproject =Util.toScreen(RecordSet.getString("hasproject"),user.getLanguage());
String projectlabel =Util.toScreenToEdit(RecordSet.getString("projectlabel"),user.getLanguage());
String hasfinance =Util.toScreen(RecordSet.getString("hasfinance"),user.getLanguage());
String financelabel =Util.toScreenToEdit(RecordSet.getString("financelabel"),user.getLanguage());
String approvercanedit=Util.toScreen(RecordSet.getString("approvercanedit"),user.getLanguage());
String isSetShare=Util.null2String(""+RecordSet.getString("isSetShare"));
int relationable=Util.getIntValue(""+RecordSet.getString("relationable"),0);
int isOpenAttachment=Util.getIntValue(""+RecordSet.getString("isOpenAttachment"),0);
String readCount = " ";
String topage= URLEncoder.encode("/docs/docs/DocDsp.jsp?id="+docid+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype);

boolean canDownload = (Util.getIntValue(Util.null2String(RecordSet.getString("nodownload")),0)==0)?true:false;
int categoryreadoptercanprint = Util.getIntValue(RecordSet.getString("readoptercanprint"),0);

String isOpenApproveWf=Util.null2String(RecordSet.getString("isOpenApproveWf"));

String readerCanViewHistoryEdition=Util.null2String(RecordSet.getString("readerCanViewHistoryEdition"));
int appointedWorkflowId = Util.getIntValue(RecordSet.getString("appointedWorkflowId"),0);

int isAutoExtendInfo = Util.getIntValue(RecordSet.getString("isAutoExtendInfo"),0);

boolean isEditionOpen = SecCategoryComInfo.isEditionOpen(seccategory);

int coworkid = Util.getIntValue(request.getParameter("coworkid"),0);
int blogDiscussid=Util.getIntValue(request.getParameter("blogDiscussid"),0);
//blogDiscussid=0;
/***************************取出文章被阅读的次数*********************************************************/
int readCount_int = 0 ;
String sql_readCount ="select count(id)  from DocDetailLog where operatetype = 0 and docid =" + docid ;
if( userid != doccreaterid || !usertype.equals(logintype) ) {
    sql_readCount ="select count(id)+1  from DocDetailLog where operatetype = 0 and docid =" + docid ;
}
rs.execute(sql_readCount);
if(rs.next()) readCount_int = Util.getIntValue(rs.getString(1),0);


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

//置顶
boolean cantop = false;

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
if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")&&!canReader){//如果主账号不能能查看随机找次账号的权限
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

session.setAttribute("f_weaver_belongto_userid_doc",f_weaver_belongto_userid);
session.setAttribute("f_weaver_belongto_usertype_doc",f_weaver_belongto_usertype);

//对于正常状态的文档，是否具有查看权限
boolean canReaderHis = canReader;
//对于正常状态的文档，是否具有编辑权限
boolean canEditHis = canEdit;

//只读权限操作者所见的文档状态为：“生效、正常”、“归档”。
//文档所在子目录的“只读权限操作人可查看历史版本”选上时，也可查看该子目录下的失效文档

//if(canReader && ((canEdit&&!docstatus.equals("8")) || (docstatus.equals("1") || docstatus.equals("2") || docstatus.equals("5"))))
//    canReader = true;
//else
//    canReader = false;

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
	//if(SecCategoryComInfo.isReaderCanViewHistoryEdition(seccategory)){
	if(readerCanViewHistoryEdition.equals("1")){
    	if(canReader && !canEdit) canReader = true;
	} else {
	    if(canReader && !canEdit) canReader = false;
	}
}	


//编辑权限操作者可查看文档状态为：“审批”、“归档”、“待发布”或历史文档
if(canEdit && ((docstatus.equals("3") || docstatus.equals("5") || docstatus.equals("6") || docstatus.equals("7")) || ishistory==1)) {
	//canEdit = false;
    canReader = true;
}

//编辑权限操作者可编辑的文档状态为：“草稿”、“生效、正常”、“失效”,非历史文档
if(canEdit && (docstatus.equals("0") || docstatus.equals("4") || docstatus.equals("1") || docstatus.equals("2") || docstatus.equals("7") || docstatus.equals("-1")) && (ishistory!=1))
    canEdit = true;
else
    canEdit = false;

//可回复
// liyx 增加归档文档可回复及可查看回复列表
if(docreplyable.equals("1") && (docstatus.equals("5") || docstatus.equals("2") || docstatus.equals("1")))
    canReplay = true;
//可打印
//if(docreadoptercanprint==1)
//    canPrint = true;
if(canEdit||(categoryreadoptercanprint==1)||(categoryreadoptercanprint==2&&docreadoptercanprint==1)){
	canPrint = true;
}
//可发布
//if(HrmUserVarify.checkUserRight("DocEdit:Publish",user,docdepartmentid) && SecCategoryComInfo.needPubOperation(seccategory) && docstatus.equals("6") && (ishistory!=1))
//    canPublish = true ;
if(HrmUserVarify.checkUserRight("DocEdit:Publish",user,docdepartmentid) && docstatus.equals("6") && (ishistory!=1)){
    canPublish = true ;
}
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
    //canDel = true;
	if(docstatus.equals("5")||docstatus.equals("3")||ishistory==1){
        canDel = false;
	}else{
		canDel = true;
	}
}else{
    canDel = false;
}

//对于需要弹出共享窗口//或从流程过来的文档//需要可读 
//为消除隐患，取消功能://对于需要弹出共享窗口//或从流程过来的文档//需要可读    update by fanggsh 2007-03-23 for TD6249  begin
////if(blnOsp || isrequest.equals("1")) canReader = true;
//if(blnOsp || (isrequest.equals("1")&&(docstatus.equals("1") || docstatus.equals("2") || docstatus.equals("5")))) canReader = true;
//为消除隐患，取消功能://对于需要弹出共享窗口//或从流程过来的文档//需要可读    update by fanggsh 2007-03-23 for TD6249  end

//从流程过来的文档，并且当前用户处于流程当前操作者中。//可以查看
//if(!canReader&&isrequest.equals("1")&&(isOpenApproveWf.equals("1")||isOpenApproveWf.equals("2"))){
if(!canReader&&(isrequest.equals("1")||requestid>0)){
//    int userTypeForThisIf=0;
//    if("2".equals(""+user.getLogintype())){
//		userTypeForThisIf= 1;
//	}
		
//	StringBuffer sqlSb=new StringBuffer();

//	if(isOpenApproveWf.equals("1")){
//		sqlSb.append(" select 1 ")
//			 .append(" from workflow_currentoperator t2,DocApproveWf t4 ")
//			 .append(" where t2.requestid=t4.requestid ")
//			 .append("   and t2.requestid= ").append(requestid)
//			 .append("   and t4.docId=").append(docid)
//			 .append("   and t2.userid= ").append(userid)
//			 .append("   and t2.usertype= ").append(userTypeForThisIf)
//			 //.append("   and t2.isremark in( '0','1') ")
//		  ;
//	}else{
//		sqlSb.append(" select 1 ")
//			 .append(" from workflow_currentoperator t2,bill_Approve t4 ")
//			 .append(" where t2.requestid=t4.requestid ")
//           .append("   and t2.requestid= ").append(requestid)
//		     .append("   and t4.approveid= ").append(docid)
//		     .append("   and t2.userid= ").append(userid)
//		     .append("   and t2.usertype= ").append(userTypeForThisIf)
//		     .append("   and t4.status='0' ")
//		     //.append("   and t2.isremark in( '0','1') ")
//		    ;
//	}
	
//
//		sqlSb.append(" select 1 ")
//			 .append(" from workflow_currentoperator t2,DocApproveWf t4 ")
//			 .append(" where t2.requestid=t4.requestid ")
//			 .append("   and t2.requestid= ").append(requestid)
//			 .append("   and t4.docId=").append(olddocid)
//			 .append("   and t2.userid= ").append(userid)
//			 .append("   and t2.usertype= ").append(userTypeForThisIf)
//			 .append(" union all ")
//			 .append(" select 1 ")
//			 .append(" from workflow_currentoperator t2,bill_Approve t4 ")
//			 .append(" where t2.requestid=t4.requestid ")
//             .append("   and t2.requestid= ").append(requestid)
//		     .append("   and t4.approveid= ").append(olddocid)
//		     .append("   and t2.userid= ").append(userid)
//		     .append("   and t2.usertype= ").append(userTypeForThisIf)
////		     .append("   and t4.status='0' ")
//		    ;
//
//
//	RecordSet.executeSql(sqlSb.toString());
//
//    if(RecordSet.next()){
//		canReader=true;
//	}
    canReader=WFUrgerManager.OperHaveDocViewRight(requestid,userid,Util.getIntValue(logintype,1),""+docid);
    
  	//另外一种情况,子流程触发的,当前流程创建人可以查看文档
    if(!canReader) {
	    RecordSet.executeSql("SELECT 1 FROM workflow_requestbase WHERE requestid="+requestid+" and creater="+userid);
	    if(RecordSet.next()) {
	    	canReader=true;
	    }
    }
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
boolean noWorkplanDocRight = true;
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
	noWorkplanDocRight = !workplanService.UrgerHaveWorkplanDocViewRight(""+workplanid,user,Util.getIntValue(logintype),""+docid);
	if(!noWorkplanDocRight)
	{
		isfrommeeting=1;
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

//工作微博点击查看文档
if(!canReader&&blogDiscussid!=0){
	//工作微博记录id
	if(BlogDao.appViewRight("doc",""+userid,docid,blogDiscussid)){	
	      CoworkDAO.shareCoworkRelateddoc(Util.getIntValue(logintype),docid,userid);
	      canReader=true;
	}      
}

//协作区点击查看文档
if(!canReader&&coworkid!=0){
	if(CoworkDAO.haveViewCoworkDocRight(""+userid,""+coworkid,""+docid)) {
	   CoworkDAO.shareCoworkRelateddoc(Util.getIntValue(logintype),docid,userid);
	   canReader=true;
	}
}
if(!canReader)  {
		
		if("1".equals(formmodeAuthorizeInfo.get("AuthorizeFlag"))){//如果是表单建模的关联授权，那么直接有查看权限
			canViewLog = true ;
		    cannewworkflow = false;
		}else if (!CoworkDAO.haveRightToViewDoc(Integer.toString(userid),Integer.toString(docid))&&noMeetingDocRight){
        if(!WFUrgerManager.OperHaveDocViewRight(requestid,desrequestid,userid,Util.getIntValue(logintype),""+olddocid) && !WFUrgerManager.getWFShareDesRight(requestid,desrequestid,user,Util.getIntValue(logintype),""+docid) && !WFUrgerManager.getWFChatShareRight(requestid,userid,Util.getIntValue(logintype),""+docid) && !WFUrgerManager.UrgerHaveDocViewRight(requestid,userid,Util.getIntValue(logintype),""+docid) && !WFUrgerManager.getMonitorViewObjRight(requestid,userid,""+docid,"0") && !WFUrgerManager.getWFShareViewObjRight(requestid,user,""+docid,"0") && isfrommeeting==0 && !RequestAnnexUpload.HaveAnnexDocViewRight(requestid,userid,Util.getIntValue(logintype),docid)){
		if(doceditionid>-1&&ishistory==1){
			RecordSet.executeSql(" select id from DocDetail where doceditionid = " + doceditionid + " and ishistory=0 and id<>"+docid+"  order by docedition desc ");
            //RecordSet.next();
	        //int newDocId = Util.getIntValue(RecordSet.getString("id"));
			int newDocId=0;
			if(RecordSet.next()){
				newDocId = Util.getIntValue(RecordSet.getString("id"));
			}
	        if(newDocId!=docid&&newDocId>0){
	%>
		    <script language=javascript>
			//location="DocDsp.jsp?id=<%=newDocId%>";
		        if(confirm("<%=SystemEnv.getHtmlLabelName(20300,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19986,user.getLanguage())%>")) {
					 location="DocDsp.jsp?fromFlowDoc=<%=fromFlowDoc%>&from=<%=from%>&userCategory=<%=userCategory%>&id=<%=newDocId%>&olddocid=<%=olddocid%>&isrequest=<%=isrequest%>&requestid=<%=requestid%>&blnOsp=<%=blnOsp%>&topage=<%=URLEncoder.encode(topageFromOther)%>&f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>";
		        }else{
					location="/notice/noright.jsp";
				}
		    </script> 
	<%
			return;//TD10386 JS跳转需要加入return，下面的JAVA代码才不会执行
	        }else{
				response.sendRedirect("/notice/noright.jsp") ;
	            return ;
			}
		}else{
	        response.sendRedirect("/notice/noright.jsp") ;
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
//QC216437在单附件访问跳转之前就判断权限，防止无权查看却能记录日志

/*TD7574 当文档的内容为空时且此文档只有一个附件时，而且没有摘要的文档，直接打开此附件，而不是打开页面*/
boolean openFirstAss = false;
boolean hasImageFile=false;
if("1".equals(isOpenFirstAss)) openFirstAss = true;
else if("0".equals(isOpenFirstAss)) openFirstAss = false;
else if(blnOsp||isOpenAttachment==0) openFirstAss = false;
else if(isOpenAttachment==1) openFirstAss = true;
if(openFirstAss){
	if(doccontent!=null&&doccontent.indexOf("weaver.file.FileDownload")>=0){
		hasImageFile=true;
	}
	//替换HTML标签
	String strDoccontent=Util.replace(doccontent,"<[^>]*>","",0);
	//替换空字符串
	strDoccontent=Util.replace(strDoccontent,"&nbsp;","",0);
	//替换换行
	strDoccontent=Util.replace(strDoccontent,"\r\n","",0);
    //替换空格
	strDoccontent=Util.replace(strDoccontent," ","",0);

	if("initFlashVideo();".equals(strDoccontent)||"".equals(strDoccontent)){
		if(!hasImageFile){
			openFirstAss = true;        			
		}else{
			openFirstAss = false;       			
		}
	}else{
		openFirstAss = false;
	}
}
int isUseEMessager = 0;
try {
	isUseEMessager = Util.getIntValue(RecordSet.getPropValue("Messager2", "IsUseEMessager"), 0);	
} catch(Exception e){}
int isUseiWebPDF = 0;
try {
	isUseiWebPDF = Util.getIntValue(RecordSet.getPropValue("weaver_iWebPDF", "isUseiWebPDF"), 0);
} catch(Exception e){}

if(isPDF&&isUseiWebPDF==1&&"true".equalsIgnoreCase(isIE)){
	if(imagefileId==0){
		if("sub".equals(pagestatus)||!openFirstAss){
			isPDF = false;
		}
	}
	openFirstAss=false;//若文件是pdf文件且启用PDF在线打开，则不下载打开pdf文件而在线打开PDF文件。
} else if(isPDF&&(isUseiWebPDF==0||"false".equalsIgnoreCase(isIE))){
	String agent = request.getHeader("user-agent");
	boolean isIE8 = (agent.indexOf("MSIE 8.0;") > 0||agent.indexOf("MSIE 7.0") > 0);
	if((agent.indexOf("Trident/5.0") > 0||agent.indexOf("Trident/6.0")> 0||agent.indexOf("Trident/7.0") > 0)){
		isIE8=false;
	}
	int isUsePDFViewerForIE8 = 0;
	try {
		isUsePDFViewerForIE8 = Util.getIntValue(RecordSet.getPropValue("docpreview", "isUsePDFViewerForIE8"), 0);
	} catch(Exception e){}
	if(imagefileId==0){
		if(!"sub".equals(pagestatus)&&openFirstAss){
			DocImageManager.resetParameter();
			DocImageManager.setDocid(docid);
	        try {
	        	DocImageManager.selectDocImageInfo();
				if (DocImageManager.next()) {
					imagefileId = Util.getIntValue(DocImageManager.getImagefileid(),0);
				}
			} catch (Exception e) {			
			}
			if( userid != doccreaterid || !usertype.equals(logintype) ) {
			    rs.executeProc("docReadTag_AddByUser",""+docid+flag+userid+flag+logintype); 
			    DocDetailLog.resetParameter();
			    DocDetailLog.setDocId(docid);
			    DocDetailLog.setDocSubject(docsubject);
			    DocDetailLog.setOperateType("0");
			    DocDetailLog.setOperateUserid(user.getUID());
			    DocDetailLog.setUsertype(user.getLogintype());
			    DocDetailLog.setClientAddress(request.getRemoteAddr());
			    DocDetailLog.setDocCreater(doccreaterid);
			    DocDetailLog.setDocLogInfo();
				hasviewlog=true;
			}
			
			if(!isIE8){
				response.sendRedirect("DocDspExt.jsp?imagefileId="+imagefileId+"&versionId="+versionId_fromAcc+"&isFromAccessory="+isFromAccessory+"&openFirstAss="+openFirstAss+"&hasviewlog="+hasviewlog+"&fromFlowDoc="+fromFlowDoc+"&from="+from+"&userCategory="+userCategory+"&id="+docid+"&olddocid="+olddocid+"&isrequest="+isrequest+"&requestid="+requestid+"&votingId="+votingId+"&desrequestid="+desrequestid+"&blnOsp="+blnOsp+"&topage="+URLEncoder.encode(topageFromOther)+"&meetingid="+meetingid+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&workplanid="+workplanid+formmodeparamsStr);
			return ;
			}
			else
			{
				if(isUsePDFViewerForIE8==1){
					response.sendRedirect("/docs/pdfview/web/sysRemind.jsp");	
					return ;
				}else{
					response.sendRedirect("/weaver/weaver.file.FileDownload?fileid="+imagefileId+"&coworkid="+coworkid+"&requestid="+requestid+"&desrequestid="+desrequestid+"&votingId="+votingId+"&hasviewlog="+hasviewlog+"&workplanid="+workplanid+formmodeparamsStr);
					return;
				}
			}
		} else {
			isPDF = false;
		}
	} else {
		if( userid != doccreaterid || !usertype.equals(logintype) ) {
		    rs.executeProc("docReadTag_AddByUser",""+docid+flag+userid+flag+logintype); 
		    DocDetailLog.resetParameter();
		    DocDetailLog.setDocId(docid);
		    DocDetailLog.setDocSubject(docsubject);
		    DocDetailLog.setOperateType("0");
		    DocDetailLog.setOperateUserid(user.getUID());
		    DocDetailLog.setUsertype(user.getLogintype());
		    DocDetailLog.setClientAddress(request.getRemoteAddr());
		    DocDetailLog.setDocCreater(doccreaterid);
		    DocDetailLog.setDocLogInfo();
			hasviewlog=true;
		}
		if(!isIE8){
				response.sendRedirect("DocDspExt.jsp?imagefileId="+imagefileId+"&versionId="+versionId_fromAcc+"&isFromAccessory="+isFromAccessory+"&hasviewlog="+hasviewlog+"&fromFlowDoc="+fromFlowDoc+"&from="+from+"&userCategory="+userCategory+"&id="+docid+"&olddocid="+olddocid+"&isrequest="+isrequest+"&requestid="+requestid+"&votingId="+votingId+"&desrequestid="+desrequestid+"&blnOsp="+blnOsp+"&topage="+URLEncoder.encode(topageFromOther)+"&meetingid="+meetingid+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&workplanid="+workplanid+formmodeparamsStr);
		return ;
		}
		else
		{
			if(isUsePDFViewerForIE8==1){
				response.sendRedirect("/docs/pdfview/web/sysRemind.jsp");	
				return ;
			}else{
				response.sendRedirect("/weaver/weaver.file.FileDownload?fileid="+imagefileId+"&coworkid="+coworkid+"&requestid="+requestid+"&desrequestid="+desrequestid+"&votingId="+votingId+"&hasviewlog="+hasviewlog+"&workplanid="+workplanid+formmodeparamsStr);
				return;
			}
		}
	}
}
if(isPDF_First&&imagefileId<=0){
    	rs.executeSql("select count(distinct id) from DocImageFile where isextfile = '1' and docid = "+docid+" and docfiletype <> '1'");
    	int fileCount=0;
    	if(rs.next()){
            fileCount=Util.getIntValue(rs.getString(1));
        }
       if(fileCount==1){
           rs.executeSql("select imagefileid from DocImageFile where isextfile = '1' and docid = "+docid+" and docfiletype <> '1' order by versionId desc");
           if(rs.next()){
               imagefileId=Util.getIntValue(rs.getString(1));
           }
       }  
}

if ("sub".equals(pagestatus)) openFirstAss = false;

//如果当前打开文档是  流程中的附件上传类型字段，则不论该附件所在文档内容是否为空、或者存在最新版本，在该链接打开页面永远打开该附件内容、不显示该附件所在文档内容。
if("1".equals(isAppendTypeField)){
	openFirstAss = true;
}
if(openFirstAss){
	DocDsp.setIsRequest(isrequest);
	DocDsp.setRequestId(requestid);
	DocDsp.setFrom(from);
	DocDsp.setUserCategory(userCategory);
	DocDsp.setDesRequestId(desrequestid);
	String redUrl=DocDsp.getNoContentRedirUrl(docid);
	if(workplanid>0){
		redUrl+="&workplanid="+workplanid;
	}
	if(meetingid>0){
		redUrl+="&meetingid="+meetingid;
	}
	//得到附件数，如果附件总数为1就直接打开附件，否则就直接打开这个HTML文档
	if(redUrl!="") {
		/* For TD11396 解决文档中心元素直接打开文档附件时，该文档未被记录已查看 by Hqf Start*/
		if( userid != doccreaterid || !usertype.equals(logintype) ) {
		    rs.executeProc("docReadTag_AddByUser",""+docid+flag+userid+flag+logintype); 
		    DocDetailLog.resetParameter();
		    DocDetailLog.setDocId(docid);
		    DocDetailLog.setDocSubject(docsubject);
		    DocDetailLog.setOperateType("0");
		    DocDetailLog.setOperateUserid(user.getUID());
		    DocDetailLog.setUsertype(user.getLogintype());
		    DocDetailLog.setClientAddress(request.getRemoteAddr());
		    DocDetailLog.setDocCreater(doccreaterid);
		    DocDetailLog.setDocLogInfo();
			hasviewlog=true;
		}
		/* For TD11396 解决文档中心元素直接打开文档附件时，该文档未被记录已查看 by Hqf End */
		if("1".equals(isAppendTypeField)){
			response.sendRedirect(redUrl+"&checkOutMessage="+URLEncoder.encode(URLEncoder.encode(checkOutMessage,"UTF-8"),"UTF-8")+"&votingId="+votingId+"&hasviewlog="+hasviewlog+formmodeparamsStr);
		}else{
			response.sendRedirect(redUrl+"&checkOutMessage="+URLEncoder.encode(URLEncoder.encode(checkOutMessage,"UTF-8"),"UTF-8")+"&openFirstAss=true&votingId="+votingId+"&hasviewlog="+hasviewlog+formmodeparamsStr);
		}
		return;
	}
}

Hashtable hr = new Hashtable();
hr.put("DOC_MainCategory",Util.null2String(MainCategoryComInfo.getMainCategoryname(""+maincategory)));
hr.put("DOC_SubCategory",Util.null2String(SubCategoryComInfo.getSubCategoryname(""+subcategory)));
hr.put("DOC_SecCategory",Util.null2String(SecCategoryComInfo.getSecCategoryname(""+seccategory)));
hr.put("DOC_Department",Util.null2String("<a href='/hrm/company/HrmDepartmentDsp.jsp?id="+docdepartmentid+"'>"+Util.toScreen(DepartmentComInfo.getDepartmentname(""+docdepartmentid),user.getLanguage())+"</a>"));
hr.put("DOC_Content",Util.null2String(doccontent));

String doccontentbackgroud="";
int strindex=doccontent.indexOf("data-background=");
if(strindex!=-1){
strindex=doccontent.indexOf("\"", doccontent.indexOf("data-background="))+1;
doccontentbackgroud=doccontent.substring(strindex, doccontent.indexOf("\"", strindex));
}

//if(usertype.equals("1"))  {
//    hr.put("DOC_CreatedBy",Util.null2String(Util.toScreen(ResourceComInfo.getFirstname(""+ownerid),user.getLanguage())));
//    hr.put("DOC_CreatedByLink",Util.null2String("<a href='javaScript:openhrm("+ownerid+"'>"+Util.toScreen(ResourceComInfo.getResourcename(""+ownerid),user.getLanguage())+"</a>"));
//    hr.put("DOC_CreatedByFull",Util.null2String(Util.toScreen(ResourceComInfo.getResourcename(""+ownerid),user.getLanguage())));
//}
//else {
//    hr.put("DOC_CreatedBy",Util.null2String(Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+ownerid),user.getLanguage())));
//    hr.put("DOC_CreatedByLink",Util.null2String("<a href='/CRM/data/ViewCustomer.jsp?CustomerID="+ownerid+"'>"+Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+ownerid),user.getLanguage())+"</a>"));
//    hr.put("DOC_CreatedByFull",Util.null2String(Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+ownerid),user.getLanguage())));
//}
if(usertype.equals("2"))  {

    hr.put("DOC_CreatedBy",Util.null2String(Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+doccreaterid),user.getLanguage())));
    hr.put("DOC_CreatedByLink",Util.null2String("<a href='/CRM/data/ViewCustomer.jsp?CustomerID="+doccreaterid+"'>"+Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+doccreaterid),user.getLanguage())+"</a>"));
    hr.put("DOC_CreatedByFull",Util.null2String(Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+doccreaterid),user.getLanguage())));
}else {
    hr.put("DOC_CreatedBy",Util.null2String(Util.toScreen(ResourceComInfo.getFirstname(""+doccreaterid),user.getLanguage())));
    hr.put("DOC_CreatedByLink",Util.null2String("<a href='javaScript:openhrm("+doccreaterid+");' onclick='pointerXY(event);'>"+Util.toScreen(ResourceComInfo.getResourcename(""+doccreaterid),user.getLanguage())+"</a>"));
    hr.put("DOC_CreatedByFull",Util.null2String(Util.toScreen(ResourceComInfo.getResourcename(""+doccreaterid),user.getLanguage())));
}

hr.put("DOC_CreatedDate",Util.null2String(doccreatedate));
hr.put("DOC_DocId",Util.null2String(Util.add0(docid,12)));
hr.put("DOC_ModifiedBy",Util.null2String(Util.toScreen(ResourceComInfo.getFirstname(""+doclastmoduserid),user.getLanguage())));
hr.put("DOC_ModifiedDate",Util.null2String(doclastmoddate));
hr.put("DOC_Language",Util.null2String(LanguageComInfo.getLanguagename(""+doclangurage)));
hr.put("DOC_ParentId",Util.null2String(Util.add0(replydocid,12)));
hr.put("DOC_Status",Util.null2String(docstatusname));
hr.put("DOC_Subject",Util.null2String(docsubject));
hr.put("DOC_Publish",Util.null2String(tmppublishtype));
hr.put("DOC_ApproveDate",Util.null2String(docapprovedate));
hr.put("DOC_NO", Util.null2String(docCode)) ;

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+docsubject;
String needfav ="1";
String needhelp ="";


//从流程过来文档直接跳转
String doc_topage=Util.null2String((String)session.getAttribute("doc_topage")); 
//TD8562
//通过项目卡片或任务信息页面新建文档，提交时要弹出共享设置页面。
if (!"".equals(doc_topage)&&doc_topage.indexOf("ViewCoWork.jsp")==-1&&doc_topage.indexOf("coworkview.jsp")==-1&&doc_topage.indexOf("ViewProject.jsp")==-1&&doc_topage.indexOf("ViewTask.jsp")==-1&&doc_topage.indexOf("/proj/process/DocOperation.jsp")==-1){
   //session.removeAttribute("doc_topage");  
   //response.sendRedirect(doc_topage+"&docfileid=1&docid="+docid); 
   //return ;

    if(!topageFromOther.equals("")){
	    session.removeAttribute("doc_topage");  
	    response.sendRedirect(doc_topage+"&docfileid=1&docid="+docid); 
	    return ;
    }
}else 
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

//TD10368 把日志记录移动到权限判断的跳转之后 Start
/**********************向阅读标记表中插入阅读记录，修改阅读次数(只有当浏览者不是创建者时)********************/
if( userid != doccreaterid || !usertype.equals(logintype) ) {
    rs.executeProc("docReadTag_AddByUser",""+docid+flag+userid+flag+logintype); 
    DocDetailLog.resetParameter();
    DocDetailLog.setDocId(docid);
    DocDetailLog.setDocSubject(docsubject);
    DocDetailLog.setOperateType("0");
    DocDetailLog.setOperateUserid(user.getUID());
    DocDetailLog.setUsertype(user.getLogintype());
    DocDetailLog.setClientAddress(request.getRemoteAddr());
    DocDetailLog.setDocCreater(doccreaterid);
    DocDetailLog.setDocLogInfo();
    hasviewlog=true;
}
//TD10368 End

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
	
//取得模版设置
String mouldtext = "";
int docmouldid = 0;

List selectMouldList = new ArrayList();
int selectMouldType = 0;
int selectDefaultMould = 0;

if(SecCategoryDocPropertiesComInfo.getDocProperties(""+seccategory,"10")&&SecCategoryDocPropertiesComInfo.getVisible().equals("1")){

	if(docType==1){
		RecordSet.executeSql("select t1.* from DocSecCategoryMould t1 right join DocMould t2 on t1.mouldId = t2.id where t1.secCategoryId = "+seccategory+" and t1.mouldType=1 order by t1.id");
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
				    docmouldid = selectDefaultMould;
				}
		    } else {
		        docmouldid = Util.getIntValue(selectedpubmould);
		    }
		} else {
		    if(Util.getIntValue(Util.null2String(selectedpubmould),0)<=0){
		    	if(selectedpubmouldid<=0){
		    	    if(selectMouldType>0)
		    	        docmouldid = selectDefaultMould;
		    	} else {
		    	    docmouldid = selectedpubmouldid;
		    	}
		    } else {
		        docmouldid = Util.getIntValue(selectedpubmould);
		    }
		}
	}
}

if(docmouldid<=0)
    docmouldid = MouldManager.getDefaultMouldId();
MouldManager.setId(docmouldid);
MouldManager.getMouldInfoById();
mouldtext= MouldManager.getMouldText();
String mouldhtml = MouldManager.getMouldText();
if("".equals(doccontentbackgroud)){
int strindextemp=mouldtext.indexOf("data-background=");
if(strindextemp!=-1){
strindextemp=mouldtext.indexOf("\"", strindextemp)+1;
doccontentbackgroud=mouldtext.substring(strindextemp, mouldtext.indexOf("\"", strindextemp));}}

MouldManager.closeStatement();

mouldtext = Util.fillValuesToString(mouldtext,hr);

String owneridname=ResourceComInfo.getResourcename(ownerid+"");

String strSql="select catelogid from DocDummyDetail where docid="+docid;
rsDummyDoc.executeSql(strSql);
String dummyIds="";
while(rsDummyDoc.next()){
	dummyIds+=Util.null2String(rsDummyDoc.getString(1))+",";
}

%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<!-- 图片轮播 -->
		<script src="/social/js/drageasy/drageasy.js"></script>
		<script type="text/javascript" src="/social/js/bootstrap/js/bootstrap.js"></script>
		<script type="text/javascript" src="/social/im/js/IMUtil_wev8.js"></script>
		<script type="text/javascript" src="/social/js/imcarousel/imcarousel.js"></script>
<style type="text/css">
html, body {
  height: 100%;
  overflow: hidden;
}
#ext-gen34, #ext-gen29 {
	Line-height:161%!important;
	font-family:"verdana","宋体"!important; 
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
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet"></link>
<link type="text/css" href="/css/ecology8/crudoc_wev8.css" rel="stylesheet"></link>

<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script type="text/javascript">
	function openVersion(docId,currentVersionId) {
		var mouldDialog = new top.Dialog();
		mouldDialog.currentWindow = window;
		mouldDialog.URL="/docs/tabs/DocCommonTab.jsp?_fromURL=1103&docId="+docId+"&currentVersionId="+currentVersionId;
		mouldDialog.Title = "<%=SystemEnv.getHtmlLabelNames("33325",user.getLanguage())%>";
		mouldDialog.Width = 800;
		mouldDialog.Height = 640;
		mouldDialog.show();
	}

	function onBtnSearchClick(){}
	jQuery(document).ready(function(){
		jQuery('.e8_box').Tabs({
		 	getLine:0,
		 	image:false,
		 	needLine:true,
		 	lineSep: ">",
		 	exceptHeight:true,
		 	objNameNew:"<%=docsubject%>",
        	mouldID:"<%=  MouldIDConst.getID("doc")%>"
		 });
		 jQuery("div#divTab").show();
		 
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
	});
	
	
	
	function downloads(fileid){
						window.open("/weaver/weaver.file.FileDownload?fileid="+fileid+"&download=1");
					}
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
<title><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>:<%=docsubject+"("+SystemEnv.getHtmlLabelName(18469,user.getLanguage())+":"+readCount_int+")" %></title>
</HEAD>

<body class="ext-ie ext-ie8 x-border-layout-ct" scroll="no" style="overflow-x: auto;">

<div id="mouldhtml" style="display:none">
	<%=mouldhtml %>
</div>

<%@ include file="/systeminfo/DocTopTitle.jsp"%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    loadTopMenu=0; 
%>
<div style="display:none;width:100%;height:100%;" >
	<%
	  session.setAttribute("html_"+docid,mouldtext);
	  int htmlcounter=Util.getIntValue((String)session.getAttribute("htmlcounter_"+docid),-1);
		if(htmlcounter<=0){
			session.setAttribute("htmlcounter_"+docid,"1");
		}else{
			htmlcounter++;
			session.setAttribute("htmlcounter_"+docid,""+htmlcounter);
		}
	%>
	<textarea id="txtContent"><%=mouldtext%></textarea>
</div>
<form name=workflow method=post action="/workflow/request/RequestType.jsp">
	<input type=hidden name=topage value='<%=topage%>'>
	<input type=hidden name=docid value='<%=docid%>'>
</form>

<%
List menuBars = new ArrayList();
List menuBarsForWf = new ArrayList();
List menuOtherBar = new ArrayList();

Map menuBarMap = new HashMap();
Map[] menuBarToolsMap = new HashMap[]{};

String strOtherBar="";
//strOtherBar="[";
String strExtBar="";
//strExtBar="[";
String strFunctionBar="";

if(!onlyview){
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
            ////~~~~~~~~~~~~~~get billformid & billid~~~~~~~~~~~~~~~~~~~~~
            //RecordSet.executeProc("workflow_form_SByRequestid",requestid+"");
            //RecordSet.next();
            //formid=RecordSet.getInt("billformid");
            //billid=RecordSet.getInt("billid");
            //~~~~~~~~~~~~~~get  billid~~~~~~~~~~~~~~~~~~~~~
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

        //// 如果从工作流进入，文档审批流程的当前操作者在文档不为正常和归档的情况下可以修改，其它流程的在文档为非审批正常或者退回状态下可以修改
        //if(canEditHis && ((!docstatus.equals("5") && hasright == 1) ||  ((docstatus.equals("0") || docstatus.equals("2") || docstatus.equals("1") || docstatus.equals("4")) && hasright == 0)) ) {
		//如果从工作流进入，文档审批流程的当前操作者在文档不为归档的情况下可以修改，其他操作者在文档为草稿、正常或者退回状态下可以修改。
        if(canEditHis && ((!docstatus.equals("5") && hasright == 1) ||  ((docstatus.equals("0") || docstatus.equals("2") || docstatus.equals("1") || docstatus.equals("4")||Util.getIntValue(docstatus,0)<0) && hasright == 0)) ) {
            RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:location='DocEdit.jsp?id="+docid+"',_top} " ;
            RCMenuHeight += RCMenuHeightStep ;
            
            //strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"',iconCls: 'btn_edit',handler: function(){window.location='DocEdit.jsp?id="+docid+"'}},";
            menuBarMap = new HashMap();
            menuBarMap.put("text",SystemEnv.getHtmlLabelName(93,user.getLanguage()));
            menuBarMap.put("iconCls","btn_edit");
            menuBarMap.put("handler","window.location='DocEdit.jsp?id="+docid+"';");
            menuBars.add(menuBarMap);
            
			//RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSave(this),_top} " ;
			//RCMenuHeight += RCMenuHeightStep ;
        }
		/*
        // 如果是转发，有批注按钮
        if(isremark==1){
            RCMenu += "{"+SystemEnv.getHtmlLabelName(1005,user.getLanguage())+",javascript:doRemark(),_top} " ;
            RCMenuHeight += RCMenuHeightStep ;
            strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(1005,user.getLanguage())+"',iconCls: 'btn_add',handler: function(){doRemark()}},";
        }
        else if(hasright==1 && !isend.equals("1")){       // 否则未结束的有批准或者转发的按钮,可退回的有退回按钮.
            if(nodetype.equals("1")) {// 审批
                RCMenu += "{"+SystemEnv.getHtmlLabelName(142,user.getLanguage())+",javascript:doSubmit(),_top} " ;
                strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(142,user.getLanguage())+"',iconCls: 'btn_add',handler: function(){doSubmit()}},";
            } else {                    // 提交
                RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSubmit(),_top} " ;
                strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+"',iconCls: 'btn_save',handler: function(){doSubmit()}},";
            }
            RCMenuHeight += RCMenuHeightStep ;

            RCMenu += "{"+SystemEnv.getHtmlLabelName(6011,user.getLanguage())+",javascript:location.href='/workflow/request/RemarkOld.jsp?requestid="+requestid+"',_top} " ;
            RCMenuHeight += RCMenuHeightStep ;
            strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(6011,user.getLanguage())+"',iconCls: 'btn_add',handler: function(){window.location='/workflow/request/RemarkOld.jsp?requestid="+requestid+"'}},";

            if(isreject.equals("1")){
                RCMenu += "{"+SystemEnv.getHtmlLabelName(236,user.getLanguage())+",javascript:doReject(),_top} " ;
                RCMenuHeight += RCMenuHeightStep ;
                
                strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(236,user.getLanguage())+"',iconCls: 'btn_reject',handler: function(){doReject()}},";
            }
        }
		*/
    }
    
    // 从非工作流进入的文档
    else if(canEdit) {
        RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:location='DocEdit.jsp?id="+docid+"',_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
        
        //strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"',iconCls: 'btn_edit',handler: function(){window.location='DocEdit.jsp?id="+docid+"'}},";
        menuBarMap = new HashMap();
        menuBarMap.put("text",SystemEnv.getHtmlLabelName(93,user.getLanguage()));
        menuBarMap.put("iconCls","btn_edit");
        menuBarMap.put("handler","window.location='DocEdit.jsp?id="+docid+"';");
        menuBars.add(menuBarMap);
		
        if(docstatus.equals("0")||Util.getIntValue(docstatus,0)<=0){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSave(this),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
			
			//strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+"',iconCls: 'btn_save',handler: function(){onSave(this)}},";
	        menuBarMap = new HashMap();
	        menuBarMap.put("id", "btn_save");
	        menuBarMap.put("text",SystemEnv.getHtmlLabelName(615,user.getLanguage()));
	        menuBarMap.put("iconCls","btn_save");
	        menuBarMap.put("handler","onSave(this);");
	        menuBars.add(menuBarMap);
		}
    }else if(canReader){
		if(docstatus.equals("0")||Util.getIntValue(docstatus,0)<=0){
		    RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSave(this),_top} " ;
		    RCMenuHeight += RCMenuHeightStep ;

			//strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+"',iconCls: 'btn_save',handler: function(){onSave(this)}},";
	        menuBarMap = new HashMap();
	        menuBarMap.put("id", "btn_save");
	        menuBarMap.put("text",SystemEnv.getHtmlLabelName(615,user.getLanguage()));
	        menuBarMap.put("iconCls","btn_save");
	        menuBarMap.put("handler","onSave(this);");
	        menuBars.add(menuBarMap);
		}
	}

    // 具有编辑权限的人,对文档可以修改共享的, 有共享按钮
    if(canShare){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(119,user.getLanguage())+",javascript:doShare(),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
        
        //strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(119,user.getLanguage())+"',iconCls: 'btn_share',handler: function(){doShare()}},";
        menuBarMap = new HashMap();
        menuBarMap.put("text",SystemEnv.getHtmlLabelName(119,user.getLanguage()));
        menuBarMap.put("iconCls","btn_share");
        menuBarMap.put("handler","doShare();");
        menuBars.add(menuBarMap);
    }

   

    // 具有编辑权限的人对审批后正常的文档可以重新打开
    /*
    if(canReopen){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(244,user.getLanguage())+",javascript:onReopen(),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
    }
    */
	int versionId = 0;
	rs.executeQuery("SELECT versionId FROM DocImageFile WHERE imagefileid = ?",imagefileId);
	if(rs.next()) {
		versionId = Util.getIntValue(rs.getString("versionId"),0);
	}

    //文档回复， 如果是可以回复的文档且是正常的文档， 可以回复
    if(canReplay) {
        replyid = docid; //replyid初始设为文档id
        if(isreply.equals("1")) replyid = replydocid; //如果是回复的文档
        if(DocReplyUtil.isUseNewReply())
		{
            RCMenu += "{"+SystemEnv.getHtmlLabelName(117,user.getLanguage())+",javascript:newDoReply(),_top} " ;
        }
        else{
            RCMenu += "{"+SystemEnv.getHtmlLabelName(117,user.getLanguage())+",javascript:doReply(),_top} " ;
        }
        RCMenuHeight += RCMenuHeightStep ;
        
        //strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(117,user.getLanguage())+"',iconCls: 'btn_add',handler: function(){doReply()}},";
        menuBarMap = new HashMap();
        menuBarMap.put("text",SystemEnv.getHtmlLabelName(117,user.getLanguage()));
        menuBarMap.put("iconCls","btn_add");
        if(DocReplyUtil.isUseNewReply())
		{
            menuBarMap.put("handler","newDoReply();");
        }
        else{
            menuBarMap.put("handler","doReply();");
        }
        
        menuBars.add(menuBarMap);
        
		//strFunctionBar+="{text:'"+SystemEnv.getHtmlLabelName(21703,user.getLanguage())+"(<font id=fontReply style=color:#FF0000;font-weight:bold>0</font>)',iconCls: 'btn_add',handler: function(){doReplyList()}},";
    }
    
     // 文档本人在文档非归档,非审批后正常,非打开状态的时候可以删除文档
    if(canDel) {
        RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(this),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
        
        //strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"',iconCls: 'btn_remove',handler: function(){onDelete(this)}},";
        menuBarMap = new HashMap();
        menuBarMap.put("text",SystemEnv.getHtmlLabelName(91,user.getLanguage()));
        menuBarMap.put("iconCls","btn_remove");
        menuBarMap.put("handler","onDelete(this);");
        menuBars.add(menuBarMap);
    }

    // 如果可以对其它系统发送该文档,可以发送这个文档
    if(OpenSendDoc.inSendDoc(""+docid)) {
        RCMenu += "{"+SystemEnv.getHtmlLabelName(16999,user.getLanguage())+",javascript:location.href='/docs/sendDoc/docCheckDetail.jsp?sendDocId="+OpenSendDoc.getSendDocId(""+docid)+"',_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
        
        //strOtherBar+="{text:'"+SystemEnv.getHtmlLabelName(16999,user.getLanguage())+"',iconCls: 'btn_add',handler: function(){window.location='/docs/sendDoc/docCheckDetail.jsp?sendDocId="+OpenSendDoc.getSendDocId(""+docid)+"'}},";
        menuBarMap = new HashMap();
        menuBarMap.put("text",SystemEnv.getHtmlLabelName(16999,user.getLanguage()));
        menuBarMap.put("iconCls","btn_add");
        menuBarMap.put("handler","window.location='/docs/sendDoc/docCheckDetail.jsp?sendDocId="+OpenSendDoc.getSendDocId(""+docid)+"';");
        menuOtherBar.add(menuBarMap);
    }

    // 如果文档不在打开状态,可以新建工作流
    if(!docstatus.equals("3")&&!docstatus.equals("7") && cannewworkflow ) {
        //RCMenu += "{"+SystemEnv.getHtmlLabelName(16392,user.getLanguage())+",javascript:document.workflow.submit(),_top} " ;

		if(appointedWorkflowId>0){
			boolean hasNewRequestRight=false;
			String isagent="0";
		    //判断是否有流程创建权限
			hasNewRequestRight = shareManager.hasWfCreatePermission(user, appointedWorkflowId);

            if(!hasNewRequestRight){
				String begindate="";
				String begintime="";
				String enddate="";
				String endtime="";
				int beagenterid=0;
				RecordSet.executeSql("select distinct workflowid,bagentuid,begindate,begintime,enddate,endtime from workflow_agentConditionSet where workflowid="+appointedWorkflowId+" and agenttype>'0' and iscreateagenter=1 and agentuid="+userid);
				while(RecordSet.next()&&!hasNewRequestRight){
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
					
					hasNewRequestRight = shareManager.hasWfCreatePermission(beagenterid, appointedWorkflowId);
					
					if(hasNewRequestRight){
						isagent="1";
					}
				}
			}

			if(hasNewRequestRight){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(16392,user.getLanguage())+",javascript:location.href='/workflow/request/AddRequest.jsp?workflowid="+appointedWorkflowId+"&isagent="+isagent+"&docid="+docid+"',_top} " ;
				RCMenuHeight += RCMenuHeightStep ;

				//strOtherBar+="{text:'"+SystemEnv.getHtmlLabelName(16392,user.getLanguage())+"',iconCls: 'btn_relateCwork',handler: function(){window.location='/workflow/request/AddRequest.jsp?workflowid="+appointedWorkflowId+"&isagent="+isagent+"&docid="+docid+"'}},";
		        menuBarMap = new HashMap();
		        menuBarMap.put("text",SystemEnv.getHtmlLabelName(16392,user.getLanguage()));
		        menuBarMap.put("iconCls","btn_relateCwork");
		        menuBarMap.put("handler","window.location='/workflow/request/AddRequest.jsp?workflowid="+appointedWorkflowId+"&isagent="+isagent+"&docid="+docid+"';");
		        menuOtherBar.add(menuBarMap);
			}else{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(16392,user.getLanguage())+",javascript:document.workflow.submit(),_top} " ;
				RCMenuHeight += RCMenuHeightStep ;

				//strOtherBar+="{text:'"+SystemEnv.getHtmlLabelName(16392,user.getLanguage())+"',iconCls: 'btn_relateCwork',handler: function(){document.workflow.submit()}},";
		        menuBarMap = new HashMap();
		        menuBarMap.put("text",SystemEnv.getHtmlLabelName(16392,user.getLanguage()));
		        menuBarMap.put("iconCls","btn_relateCwork");
		        menuBarMap.put("handler","document.workflow.submit();");
		        menuOtherBar.add(menuBarMap);
			}
		}else{
			RCMenu += "{"+SystemEnv.getHtmlLabelName(16392,user.getLanguage())+",javascript:document.workflow.submit(),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;

			//strOtherBar+="{text:'"+SystemEnv.getHtmlLabelName(16392,user.getLanguage())+"',iconCls: 'btn_relateCwork',handler: function(){document.workflow.submit()}},";
	        menuBarMap = new HashMap();
	        menuBarMap.put("text",SystemEnv.getHtmlLabelName(16392,user.getLanguage()));
	        menuBarMap.put("iconCls","btn_relateCwork");
	        menuBarMap.put("handler","document.workflow.submit();");
	        menuOtherBar.add(menuBarMap);
		}
    }
    /**分离改造	 标签1239替换为16392  16426替换为18481	15295替换为1044**/

	

    // 可以查看文档的人都具有查看相关工作流的列表权限
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1044,user.getLanguage())+",javascript:doRelateWfFun("+docid+"),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
	//strOtherBar+="{text:'"+SystemEnv.getHtmlLabelName(1044,user.getLanguage())+"',iconCls: 'btn_relateWork',handler: function(){window.location='/workflow/search/WFSearchTemp.jsp?docids="+docid+"'}},";
    menuBarMap = new HashMap();
    menuBarMap.put("text",SystemEnv.getHtmlLabelName(1044,user.getLanguage()));
    menuBarMap.put("iconCls","btn_relateWork");
    menuBarMap.put("handler","doRelateWfFun("+docid+");");
    menuOtherBar.add(menuBarMap);

    //新建计划
    if(!isCustomer&&!docstatus.equals("7")){
	    // added by lupeng 200-07-09 to add the "add work plan" button.
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(18481,user.getLanguage())+",javascript:doAddWorkPlan(),_top} " ;
	    RCMenuHeight += RCMenuHeightStep ;
	    // end
		//strOtherBar+="{text:'"+SystemEnv.getHtmlLabelName(18481,user.getLanguage())+"',iconCls: 'btn_newPlan',handler: function(){doAddWorkPlan()}},";
	    menuBarMap = new HashMap();
	    menuBarMap.put("text",SystemEnv.getHtmlLabelName(18481,user.getLanguage()));
	    menuBarMap.put("iconCls","btn_newPlan");
	    menuBarMap.put("handler","doAddWorkPlan();");
	    menuOtherBar.add(menuBarMap);
    }

    // 具有文档管理员权限的人可以对待发布文档进行发布
    if(canPublish){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(114,user.getLanguage())+",javascript:onPublish(this),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
		//strOtherBar+="{text:'"+SystemEnv.getHtmlLabelName(114,user.getLanguage())+"',iconCls: 'btn_add',handler: function(){onPublish(this)}},";
	    menuBarMap = new HashMap();
	    menuBarMap.put("text",SystemEnv.getHtmlLabelName(114,user.getLanguage()));
	    menuBarMap.put("iconCls","btn_add");
	    menuBarMap.put("handler","onPublish(this);");
	    menuOtherBar.add(menuBarMap);
    }
    if(canInvalidate){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(15750,user.getLanguage())+",javascript:onInvalidate(this),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
		//strOtherBar+="{text:'"+SystemEnv.getHtmlLabelName(15750,user.getLanguage())+"',iconCls: 'btn_add',handler: function(){onInvalidate(this)}},";
	    menuBarMap = new HashMap();
	    menuBarMap.put("text",SystemEnv.getHtmlLabelName(15750,user.getLanguage()));
	    menuBarMap.put("iconCls","btn_add");
	    menuBarMap.put("handler","onInvalidate(this);");
	    menuOtherBar.add(menuBarMap);
    }
    // 具有文档管理员权限的人可以对归档文档进行重新打开操作
    // 具有文档管理员权限的人可以对作废文档进行重新打开操作
    if(canReopen){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(244,user.getLanguage())+",javascript:onReopen(this),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
		//strOtherBar+="{text:'"+SystemEnv.getHtmlLabelName(244,user.getLanguage())+"',iconCls: 'btn_add',handler: function(){onReopen(this)}},";
	    menuBarMap = new HashMap();
	    menuBarMap.put("text",SystemEnv.getHtmlLabelName(244,user.getLanguage()));
	    menuBarMap.put("iconCls","btn_add");
	    menuBarMap.put("handler","onReopen(this);");
	    menuOtherBar.add(menuBarMap);
    }
    

    //文档签出，且签出人为当前用户，则可进行文档签入操作

    if(canCheckIn){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(19693,user.getLanguage())+",javascript:onCheckIn(),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
		//strOtherBar+="{text:'"+SystemEnv.getHtmlLabelName(19693,user.getLanguage())+"',iconCls: 'btn_add',handler: function(){onCheckIn()}},";
	    menuBarMap = new HashMap();
	    menuBarMap.put("text",SystemEnv.getHtmlLabelName(19693,user.getLanguage()));
	    menuBarMap.put("iconCls","btn_add");
	    menuBarMap.put("handler","onCheckIn();");
	    menuOtherBar.add(menuBarMap);
    }

	//文档签出，且签出人不为当前用户，当前用户具有文档管理员或目录管理员权限，则可进行强制签入操作
    if(canCheckInCompellably){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(19688,user.getLanguage())+",javascript:onCheckIn(),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
		//strOtherBar+="{text:'"+SystemEnv.getHtmlLabelName(19688,user.getLanguage())+"',iconCls: 'btn_add',handler: function(){onCheckIn()}},";
	    menuBarMap = new HashMap();
	    menuBarMap.put("text",SystemEnv.getHtmlLabelName(19688,user.getLanguage()));
	    menuBarMap.put("iconCls","btn_add");
	    menuBarMap.put("handler","onCheckIn();");
	    menuOtherBar.add(menuBarMap);
    }
    
    // 具有文档管理员权限的人可以对正常文档进行重载
    if(HrmUserVarify.checkUserRight("DocEdit:Reload",user,docdepartmentid) && docstatus.equals("5")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(256,user.getLanguage())+",javascript:onReload(),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
		//strOtherBar+="{text:'"+SystemEnv.getHtmlLabelName(256,user.getLanguage())+"',iconCls: 'btn_add',handler: function(){onReload()}},";
	    menuBarMap = new HashMap();
	    menuBarMap.put("text",SystemEnv.getHtmlLabelName(256,user.getLanguage()));
	    menuBarMap.put("iconCls","btn_add");
	    menuBarMap.put("handler","onReload();");
	    menuOtherBar.add(menuBarMap);
    }

    // 具有打印权限可以对文档进行打印
    if(canPrint){
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(257,user.getLanguage())+",javascript:onPrint(),_top} " ;
	    RCMenuHeight += RCMenuHeightStep ;
		//strOtherBar+="{text:'"+SystemEnv.getHtmlLabelName(257,user.getLanguage())+"',iconCls: 'btn_print',handler: function(){onPrint()}},";
	    menuBarMap = new HashMap();
	    menuBarMap.put("text",SystemEnv.getHtmlLabelName(257,user.getLanguage()));
	    menuBarMap.put("iconCls","btn_print");
	    menuBarMap.put("handler","onPrint();");
	    menuOtherBar.add(menuBarMap);
    }
    
    // 从审批工作流进入的, 或者具有编辑权限并且文档有审批的，都有审批意见按钮
//    if((canEdit && docapprovable.equals("1")) || isremark==1 || hasright==1 ) {
    if(((canEdit && docapprovable.equals("1")) || isremark==1 || hasright==1 )&&isbill==1&&formid==28) {
        RCMenu += "{"+SystemEnv.getHtmlLabelName(1008,user.getLanguage())+",javascript:location.href='DocApproveRemark.jsp?docid="+docid+"&isrequest="+isrequest+"&requestid="+requestid+"',_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
		//strOtherBar+="{text:'"+SystemEnv.getHtmlLabelName(1008,user.getLanguage())+"',iconCls: 'btn_add',handler: function(){window.location='DocApproveRemark.jsp?docid="+docid+"&isrequest="+isrequest+"&requestid="+requestid+"'}},";
	    menuBarMap = new HashMap();
	    menuBarMap.put("text",SystemEnv.getHtmlLabelName(1008,user.getLanguage()));
	    menuBarMap.put("iconCls","btn_add");
	    menuBarMap.put("handler","window.location='DocApproveRemark.jsp?docid="+docid+"&isrequest="+isrequest+"&requestid="+requestid+"';");
	    menuOtherBar.add(menuBarMap);
    }
//TD12005    if((SecCategoryComInfo.getLogviewtype(seccategory)==1&&user.getLoginid().equalsIgnoreCase("sysadmin"))||(SecCategoryComInfo.getLogviewtype(seccategory)==0)){
	//当文档目录设定为"按文档日志权限查看"时，对于有文档查看权限的人也能查看日志(TD12005)    
    if((SecCategoryComInfo.getLogviewtype(seccategory)==1&&HrmUserVarify.checkUserRight("FileLogView:View", user)||canEdit)||(SecCategoryComInfo.getLogviewtype(seccategory)==0)){
    // 具有编辑权限的人都可以查看文档的查看日志
    if(canViewLog&&logintype.equals("1")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:doViewLog(),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;

		//strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"',iconCls: 'btn_log',handler: function(){doViewLog()}},";
        menuBarMap = new HashMap();
        menuBarMap.put("text",SystemEnv.getHtmlLabelName(83,user.getLanguage()));
        menuBarMap.put("iconCls","btn_log");
        menuBarMap.put("handler","doViewLog();");
        menuBars.add(menuBarMap);
		blnRealViewLog=true;

    }else if(canEdit&&logintype.equals("2")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:doViewLog(),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;

		//strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"',iconCls: 'btn_log',handler: function(){doViewLog()}},";
        menuBarMap = new HashMap();
        menuBarMap.put("text",SystemEnv.getHtmlLabelName(83,user.getLanguage()));
        menuBarMap.put("iconCls","btn_log");
        menuBarMap.put("handler","doViewLog();");
        menuBars.add(menuBarMap);
		blnRealViewLog=true;
    }
    
    }
    
} else {
    RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:location='DocEdit.jsp?from="+from+"&id="+docid+"&userCategory="+userCategory+"',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;

	//strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"',iconCls: 'btn_edit',handler: function(){window.location='DocEdit.jsp?from="+from+"&id="+docid+"&userCategory="+userCategory+"'}},";
    menuBarMap = new HashMap();
    menuBarMap.put("text",SystemEnv.getHtmlLabelName(93,user.getLanguage()));
    menuBarMap.put("iconCls","btn_edit");
    menuBarMap.put("handler","window.location='DocEdit.jsp?from="+from+"&id="+docid+"&userCategory="+userCategory+"';");
    menuBars.add(menuBarMap);
	if(!docstatus.equals("1") || !docstatus.equals("2") || !docstatus.equals("6")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSave(this),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	//strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+"',iconCls: 'btn_add',handler: function(){onSave(this)}},";
    menuBarMap = new HashMap();
    menuBarMap.put("text",SystemEnv.getHtmlLabelName(615,user.getLanguage()));
    menuBarMap.put("iconCls","btn_add");
    menuBarMap.put("handler","onSave(this);");
    menuBars.add(menuBarMap);
	}
}
if(HrmUserVarify.checkUserRight("Document:Top", user))
{
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	String createidsubcomid = ResourceComInfo.getSubCompanyID(""+doccreaterid);
	if(detachable==1)
	{
		ArrayList subcompanylist=SubCompanyComInfo.getRightSubCompany(user.getUID(),"Document:Top");
		if(subcompanylist.indexOf(createidsubcomid)!=-1)
		{
			cantop = true;	
		}
	}
	else
	{
		cantop = true;
	}
	if(docstatus.equals("3"))
	{
		cantop = false;
	}
	if(cantop)
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(23784,user.getLanguage())+",javascript:DocToTop("+docid+",1),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		//strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(23784,user.getLanguage())+"',iconCls: 'btn_up',handler: function(){DocToTop("+docid+",1);}},";
	    menuBarMap = new HashMap();
	    menuBarMap.put("text",SystemEnv.getHtmlLabelName(23784,user.getLanguage()));
	    menuBarMap.put("iconCls","btn_up");
	    menuBarMap.put("handler","DocToTop("+docid+",1);");
	    menuBars.add(menuBarMap);
	}
	String sql = "select istop from docdetail d where d.id="+docid;
	rs.executeSql(sql);
	rs.next();
	int istop = rs.getInt(1);
	if(istop==1)
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(24675,user.getLanguage())+",javascript:DocToTop("+docid+",2),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		//strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(24675,user.getLanguage())+"',iconCls: 'btn_down',handler: function(){DocToTop("+docid+",2);}},";
	    menuBarMap = new HashMap();
	    menuBarMap.put("text",SystemEnv.getHtmlLabelName(24675,user.getLanguage()));
	    menuBarMap.put("iconCls","btn_down");
	    menuBarMap.put("handler","DocToTop("+docid+",2);");
	    menuBars.add(menuBarMap);
	}
}
}
//if(",".equals(strOtherBar.substring(strOtherBar.length()-1))) strOtherBar=strOtherBar.substring(0,strOtherBar.length()-1);
//strOtherBar+="]";

//strFunctionBar+="{text:'"+SystemEnv.getHtmlLabelName(21704,user.getLanguage())+"(<font id=fontImgAcc style=color:#FF0000;font-weight:bold>0</font>)',iconCls: 'btn_add',handler: function(){doImgAcc()}}"; //附件


//System.out.println("============"+strOtherBar);
//strExtBar+="'-',{text:'"+SystemEnv.getHtmlLabelName(21739,user.getLanguage())+"',iconCls: 'btn_list',menu:"+strOtherBar+"}";
//strExtBar+="'-',"+strFunctionBar;
if((docstatus.equals("1")||docstatus.equals("2")||docstatus.equals("5")) && "1".equals(user.getLogintype()) && isUseEMessager==1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(126091,user.getLanguage())+",javascript:onDocShare("+docid+",\\\""+docsubject+"\\\"),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;	
	menuBarMap = new HashMap();
	menuBarMap.put("text",SystemEnv.getHtmlLabelName(126091,user.getLanguage()));
	menuBarMap.put("iconCls","btn_relateCwork");
	menuBarMap.put("handler","onDocShare("+docid+",\\\""+docsubject+"\\\");");
	menuBars.add(menuBarMap);
}
if(menuOtherBar.size()>0){
menuBarMap = new HashMap();
menuBars.add(menuBarMap);

menuBarMap = new HashMap();
menuBarMap.put("text",SystemEnv.getHtmlLabelName(21739,user.getLanguage()));
menuBarMap.put("iconCls","btn_list");
menuBarMap.put("id","menuTypeChanger");
menuBarToolsMap = new HashMap[menuOtherBar.size()];
for(int tmpindex=0;tmpindex<menuOtherBar.size();tmpindex++) menuBarToolsMap[tmpindex]=(Map)menuOtherBar.get(tmpindex);
menuBarMap.put("menu",menuBarToolsMap);
menuBars.add(menuBarMap);
}

//strExtBar+=",'-',{text:'<span id=spanProp>"+SystemEnv.getHtmlLabelName(21689,user.getLanguage())+"</span>',iconCls: 'btn_ShowOrHidden',handler: function(){DocCommonExt.showorhiddenprop()}}";  //显示属性
//strExtBar+="]";

menuBarMap = new HashMap();
menuBars.add(menuBarMap);

menuBarMap = new HashMap();
menuBarMap.put("text","<span id=spanProp><script type=\"text/javascript\">document.write(wmsg.base.showProp);</script></span>");
menuBarMap.put("iconCls","btn_ShowOrHidden");
menuBarMap.put("id","btn_ShowOrHidden");
menuBarMap.put("handler","onExpandOrCollapse();");
menuBars.add(menuBarMap);
%>



<div id="divTopMenu" style="display:none">
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</div>

<FORM id=docsharelog name=docsharelog action="DocShare.jsp" method=post  target="_blank">
<input type=hidden name=docid value="<%=docid%>">
<input type=hidden name=docsubject value="<%=docsubject%>">
<input type=hidden name=doccreaterid value="<%=doccreaterid%>">
<input type=hidden name=sqlwhere value="<%=xssUtil.put("where docid="+docid)%>">
</form>

<FORM id=weaver name=weaver action="UploadDoc.jsp" method=post>
	<input type=hidden name=operation>
	<input type=hidden name="isSubmit">
	<input type=hidden name=id value="<%=docid%>">
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
	<input type=hidden name=selectedpubmouldid value="<%=docmouldid%>">
	<input type=hidden name=isreply value="<%=isreply%>">
	<input type=hidden name=replydocid value="<%=replydocid%>">
	<input type=hidden name=doccreaterid value="<%=doccreaterid%>">
	<input type=hidden name=docCreaterType value="<%=docCreaterType%>">

	<input type=hidden name=keyword value="<%=keyword%>">
	<input type=hidden name=doccode value="<%=docCode%>">
	<input type=hidden name=assetid value="<%=assetid%>">
	<input type=hidden name=crmid value="<%=crmid%>">
	<input type=hidden name=itemid value="<%=itemid%>">
	<input type=hidden name=projectid value="<%=projectid%>">
	<input type=hidden name=financeid value="<%=financeid%>">

	<input type="hidden" name="hrmresid" value="<%=hrmresid%>">
	<input type="hidden" name="invalidationdate" value="<%=invalidationdate%>">
	<input type="hidden" name="dummycata" value="<%=dummyIds%>">
	<input type="hidden" name="docmodule" value="<%=docmouldid%>">

    <input type=hidden name=replaydoccount value="<%=replaydoccount%>">

	<table style="display:none" id="customerTable">
		<tr id="customerTR">
			<td id="customerTD">
			</td>
		</tr>
	</table>
	<script language="JavaScript">
		function insertToCustomer(id, value){
			var customerTD = document.getElementById("customerTD");
			customerTD.innerHTML += "<input type='hidden' name='customfield"+id+"' value='"+value+"' /> ";
		}
	</script>

	<%if(isrequest.equals("1")&&(hasright==1||isremark==1)){%>
		<input type=hidden name="isremark" >
		<input type=hidden name="requestid" value=<%=requestid%>>
		<input type=hidden name="workflowid" value=<%=workflowid%>>
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
	<%if(docstatus.equals("0")||Util.getIntValue(docstatus,0)<=0){ //草稿状态提交的时候  不改变文档内容%>
	<input type=hidden name="doccontentflag" value="1">
	<%}%>

	<textarea name=doccontent style="display:none;"><%=doccontent%></textarea> 

</FORM>

<div style=" width:100%;height:100%;">

<div id="divContentTab" style="width:100%;height:100%;">
	<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
		<%
		int nodeid2 = 0;
		int currentnodeid=0;
		boolean isSignatureNodes=false;
		String signatureNodes = "";
		boolean isCurrentOperator = false;
		nodeid2=WFLinkInfo.getCurrentNodeid(requestid,userid,Util.getIntValue(logintype,1)); 

		RecordSet.executeSql("select id from workflow_currentoperator where  requestid="+requestid+" and nodeid="+nodeid2+" and userid="+userid);
		if(RecordSet.next()){
			isCurrentOperator=true;
		}

		RecordSet.executeSql("select workflowId,currentNodeId from workflow_requestbase where requestid="+requestid);
		if(RecordSet.next()){
			workflowid=RecordSet.getInt("workflowid");
			currentnodeid=RecordSet.getInt("currentnodeid");
		}
		RecordSet.executeQuery("SELECT signatureNodes FROM workflow_createdoc WHERE workflowId = ?",workflowid);
		if(RecordSet.next()){





			signatureNodes=Util.null2String(RecordSet.getString("signatureNodes"));

		}
		//System.out.println("------signatureNodes="+signatureNodes+",nodeid2="+nodeid2+",currentnodeid="+currentnodeid+",isCurrentOperator="+isCurrentOperator);
		if((","+signatureNodes+",").indexOf(","+nodeid2+",")>=0&&nodeid2>0&&nodeid2==currentnodeid&&isCurrentOperator){
			isSignatureNodes=true;





		}
		
		if(!onlyview){
			if (!isPersonalDoc){ 
				if(isrequest.equals("1")){ //从工作流进入的文档
			%>
				<%if(canEditHis && ((!docstatus.equals("5") && hasright == 1) ||  ((docstatus.equals("0") || docstatus.equals("2") || docstatus.equals("1") || docstatus.equals("4")||Util.getIntValue(docstatus,0)<0) && hasright == 0)) ) { %>
					<input type=button class="e8_btn_top" onclick="javascript:onEdit(<%=docid %>)" value="<%=SystemEnv.getHtmlLabelName(93, user.getLanguage())%>"></input>
				<%} %>
			<%}else if(canEdit) { %>
				<input type=button class="e8_btn_top" onclick="javascript:onEdit(<%=docid %>)" value="<%=SystemEnv.getHtmlLabelName(93, user.getLanguage())%>"></input>
				<%if(docstatus.equals("0")||Util.getIntValue(docstatus,0)<=0){ %>
					<input type=button class="e8_btn_top" onclick="javascript:onSave(this);" value="<%=SystemEnv.getHtmlLabelName(615, user.getLanguage())%>"></input>
				<%} %>
			<%}else if(canReader){ %>
				<%if(docstatus.equals("0")||Util.getIntValue(docstatus,0)<=0){ %>
					<input type=button class="e8_btn_top" onclick="javascript:onSave(this);" value="<%=SystemEnv.getHtmlLabelName(615, user.getLanguage())%>"></input>
				<%} %>
			<%} %>
			<% if(canShare){ %>
				<input type=button class="e8_btn_top" onclick="javascript:doShare();" value="<%=SystemEnv.getHtmlLabelName(119, user.getLanguage())%>"></input>
			<%} %>
			<%//文档回复， 如果是可以回复的文档且是正常的文档， 可以回复
    		  if(canReplay) { 
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

			<% if(canDownload&&isPDF){ %>
    			<input type=button class="e8_btn_top" onclick="javascript:onDownload()" value="<%=SystemEnv.getHtmlLabelName(31156, user.getLanguage())%>"></input>
			<%} %>

			<%}else{%>
				<input type=button class="e8_btn_top" onclick="javascript:onEdit(<%=docid %>)" value="<%=SystemEnv.getHtmlLabelName(93, user.getLanguage())%>"></input>
				<%if(docstatus.equals("0")||Util.getIntValue(docstatus,0)<=0){ %>
					<input type=button class="e8_btn_top" onclick="javascript:onSave(this);" value="<%=SystemEnv.getHtmlLabelName(615, user.getLanguage())%>"></input>
				<%} %>
			<%} %>
		<%}%>
		<%
			//String isIE = (String)session.getAttribute("browser_isie");
			String isCommentVersion = Prop.getPropValue("weaver_iWebPDF", "isCommentVersion");
			//System.out.println("isIE="+isIE+",isCommentVersion="+isCommentVersion);
			if(isSignatureNodes && isPDF && "true".equals(isIE)){ 
		%>						
			<input type=button id="signature_id2" class="e8_btn_top" onclick="onSavePDF();" value="<%=SystemEnv.getHtmlLabelName(21656, user.getLanguage())%>"></input>
		<%
			} else if(!isSignatureNodes && isPDF && canEditHis && "true".equals(isIE) && "1".equals(isCommentVersion)) {
			
		%>
			<input type=button id="signature_id3" class="e8_btn_top" onclick="onSavePDFOnline()" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
		<%}%>
		  <%if((docstatus.equals("1")||docstatus.equals("2")||docstatus.equals("5")) && "1".equals(user.getLogintype()) && isUseEMessager==1){ %>
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
	<div class="e8_box demo2">
    	<div class="e8_boxhead" <%if("pdfText".equals(from)){%>style="display:none"<%}%>>
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
    		<% if(DocReplyUtil.isUseNewReply()){ %>
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
				        	/***if (!iTime)
				          		{
				          			iTime = setTimeout(function(){
				          			jQuery("#praiseUsers").fadeOut();
				          			jQuery(".magic-line1").fadeOut();
				          			iTime = null;
				          			}, 2000);
				          		}*/
				          	var _left = Math.floor(jQuery(this).position().left);
				          	var _right = Math.floor(_left + this.clientWidth);
				          	var _top = Math.floor(jQuery(this).position().top);
				          	var _eventX = event.clientX;
				          	var _eventY = event.clientY;
				          	console.log("left::" + _left + ",right::" + _right + ",top::" + _top + ",ex::" + _eventX + ",ey::" + _eventY);
				          	if(_left >= _eventX || _right <= _eventX || _top >= _eventY){
				          		jQuery("#praiseUsers").fadeOut();
				          		jQuery(".magic-line1").fadeOut();
				          	}
				        });
				       
				       jQuery("#praiseUsers").hover(function(){
				       		return;
				       },function(){
				       		jQuery("#praiseUsers").fadeOut();
				          	jQuery(".magic-line1").fadeOut();
				       });
				       
				       /***
				        jQuery("#praiseUsers").hover(function() {
				       		if (iTime)
				          	{
				          		clearTimeout(iTime);
				          		flag = true;
				          	}
				          		return ;
				        },function(){
				        	if (iTime)
				          	{
				          		iTime = setTimeout(function(){
				          			jQuery("#praiseUsers").fadeOut();
				          			jQuery(".magic-line1").fadeOut();
				          			iTime = null;
				          			}, 2000);
				          	}
				        });*/
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
	        <div>
	<div id="divContent" style="width:100%;">
		<%-- HTML编辑控件 start --%>
		<div id="divContentInfo" class="e8_propTab " style="width:100%;height:100%;">
			<IFRAME id="doccontentifm" style="OVERFLOW: auto;width:100%;height:100%;" class=x-managed-iframe src="" frameBorder=0></IFRAME>
		</div>
		<%-- HTML编辑控件 end --%>
		<!-- 文档属性栏 start -->
		<div id="divProp" class="e8_propTab" style="display:none;width:100%;height:100%;">
			<DIV style="width:100%; height:100%; overflow: visible" class="x-panel-body x-panel-body-noheader x-panel-body-noborder">
				<jsp:include page="/docs/docs/DocDspBaseInfo.jsp">
					<jsp:param name="docid" value="<%=docid%>" />
					<jsp:param name="isPersonalDoc" value="<%=isPersonalDoc%>" />
					<jsp:param name="userCategory" value="<%=userCategory%>" />
					<jsp:param name="canPublish" value="<%=canPublish%>" />
					<jsp:param name="selectedpubmould" value="<%=selectedpubmould%>" />
					<jsp:param name="f_weaver_belongto_userid" value="<%=f_weaver_belongto_userid%>" />
					<jsp:param name="f_weaver_belongto_usertype" value="<%=f_weaver_belongto_usertype%>" />
				</jsp:include>
			</DIV>
		</div>
		<!-- 文档属性栏 end -->
		<!-- 文档附件栏 start -->
		<div id="divAcc" class="e8_propTab" style="display:none;width:100%;height:100%;">
			<DIV style="width:100%; height:100%; overflow: visible;border:none;" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
<%
			String sessionPara=""+docid+"_"+user.getUID()+"_"+user.getLogintype();
			session.setAttribute("right_view_"+sessionPara,"1");
%>
			<iframe id="e8DocAccIfrm" style="border:none;"  frameborder="0" width="100%" height="100%"></iframe>
			</DIV>
		</div>
		<!-- 文档附件栏 end -->
		<% if(canReplay) { %>
			<!-- 文档回复栏 start -->
			<div id="divReplay" class="e8_propTab" style="display:none;width:100%;height:100%;">
				<DIV style="width:100%; height:100%; overflow: visible" class="x-panel-body x-panel-body-noheader x-panel-body-noborder">
					<%
						if(DocReplyUtil.isUseNewReply())
						{
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
			<iframe  id="shareListIfrm" style="border:none;"  frameborder="0" width="100%" height="100%"></iframe>
			</DIV>
		</div>
		<!-- 文档共享栏 end -->
		<% if(isEditionOpen) { %>
		<!-- 文档版本栏 start -->
		<div id="divVer" class="e8_propTab" style="display:none;width:100%;height:100%;">
			<DIV style="width:100%; height:100%; overflow: visible;border:none;" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
			<iframe  id="versionListIfrm"  style="border:none;"  frameborder="0" width="100%" height="100%"></iframe>
			</DIV>
		</div>
		<!-- 文档版本栏 end -->
		<% } %>
		<% if(canViewLog) { %>
		<!-- 文档日志栏 start -->
		<div id="divViewLog" class="e8_propTab" style="display:none;width:100%;height:100%;">
			<DIV style="width:100%; height:100%; overflow: visible;border:none;" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
			<iframe  id="logListIfrm" style="border:none;"  frameborder="0" width="100%" height="100%"></iframe>
			</DIV>
		</div>
		<!-- 文档日志栏 end -->
		<% } %>
			
		<% if(DocMark.isAllowMark(""+seccategory)){ %>
		<!-- 文档打分栏 start -->
		<div id="divMark" class="e8_propTab" style="display:none;width:100%;height:100%;">
			<DIV style="width:100%; height:100%; overflow: visible" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
			<iframe   id="markListIfrm" style="border:none;" frameborder="0" width="100%" height="100%"></iframe>
			</DIV>
		</div>
		<!-- 文档打分栏 end -->
		<% } %>
		
		<% if(relationable==1){ %>
		<!-- 相关资源栏 start -->
		<div id="divRelationResource" class="e8_propTab" style="display:none;width:100%;height:100%;">
			<DIV style="width:100%; height:100%; overflow: visible" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
			<iframe   id="resourceListIfrm" style="border:none;"  frameborder="0" width="100%" height="100%"></iframe>
			</DIV>
		</div>
		<!-- 相关资源栏 end -->
		<% } %>
	</div>
	<%if(isAutoExtendInfo>0&&accessorycount>0){ %>
		<jsp:include page="/docs/docs/DocAccView.jsp">
			<jsp:param name="f_weaver_belongto_userid" value="<%=f_weaver_belongto_userid%>" />
			<jsp:param name="f_weaver_belongto_usertype" value="<%=f_weaver_belongto_usertype%>" />
			 <jsp:param name="seccategory" value="<%=seccategory%>" />
		    <jsp:param name="docid" value="<%=docid%>" />
			<jsp:param name="canEdit" value="<%=canEdit%>" />
		    <jsp:param name="meetingid" value="<%=meetingid%>" />
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
<div style="position:relative;">
	<div id="divTab" class="e8_weavertab" style="display:none;width:100%;position:relative;">

		<DIV style="WIDTH:100%" class="x-tab-panel-footer x-tab-panel-footer-noborder">
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
		
		<% if(relationable==1){ %>
		<LI id=divRelationResourceATab class=" "  onclick="onActiveTab('divRelationResource');">
		<A class=x-tab-strip-close onclick="return false;"></A>
		<A class=x-tab-right onclick="return false;" href="#">
		<EM class=x-tab-left>
		<SPAN class=x-tab-strip-inner><SPAN class="x-tab-strip-text "><script type="text/javascript">document.write(wmsg.base.relationResource);</script></SPAN></SPAN>
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
	<!-- 底部选项卡栏 end -->
	<div id="divPropTab" style="display:none;width: 100%">
	
	
</div>
 	</div>


</body>
</html>

<jsp:include page="/docs/docs/DocComponents.jsp">
	<jsp:param name="f_weaver_belongto_userid" value="<%=f_weaver_belongto_userid%>" />
	<jsp:param name="f_weaver_belongto_usertype" value="<%=f_weaver_belongto_usertype%>" />
	<jsp:param value="<%=user.getLanguage()%>" name="language"/>
	<jsp:param value="getBase" name="operation"/>
</jsp:include>

<script language="javascript" type="text/javascript">
var isFromWf=false;
var docid="<%=docid%>";
var olddocid="<%=olddocid%>";
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
var workplanid="<%=workplanid%>";

var strExtBar="<%=strExtBar%>";
//alert(strExtBar)
var menubar=eval(strExtBar);
var menubarForwf=[];
var canViewLog=<%=blnRealViewLog%>;	
var canShare=<%=canShare%>;
var canEdit=<%=canEdit%>;
var canDownload=<%=canDownload%>;
var canDocMark=<%=DocMark.isAllowMark(""+seccategory)%>;
var canReplay=<%=canReplay%>
var readCount_int=<%=readCount_int%>
var relationable=<%=relationable==1%>;
var maxUploadImageSize="<%= DocUtil.getMaxUploadImageSize(seccategory)%>";
var pagename="docdsp";
var requestid="<%=requestid%>";
var isrequest="<%=isrequest%>";

var isPDF=<%=isPDF?1:0%>;
var imagefileId=<%=imagefileId%>;
var canPrint=<%=canPrint?1:0%>;
var canEditPDF=<%=canEdit?1:0%>;
var accessorycount=<%=accessorycount%>;

var isEditionOpen=<%=isEditionOpen%>;

var doccreaterid="<%=doccreaterid%>";
var docCreaterType="<%=docCreaterType%>";
var ownerid="<%=ownerid%>";
var ownerType="<%=ownerType%>";

var isAutoExtendInfo=<%=isAutoExtendInfo%>;

function adjustContentHeight(type,deltaHeight){
	var lang=<%=(user.getLanguage()==8)?"true":"false"%>;
	try{
		deltaHeight = jQuery("div.e8AccListArea").height();
		if(jQuery("div.e8AccListArea").css("display")=="none"){
			deltaHeight = 0;
		}
		var propTabHeight = 34;
		if(document.getElementById("divPropTab")&&document.getElementById("divPropTab").style.display=="none") propTabHeight = 34;
		
		var pageHeight=document.body.clientHeight;
		var pageWidth=document.body.clientWidth;
		//var divContentHeight=pageHeight-propTabHeight-65;
		jQuery("#divContentTab").height(pageHeight - propTabHeight);
		jQuery(".e8_box").height(pageHeight - propTabHeight);
		<%if("pdfText".equals(from)){%>
		jQuery(".tab_box").height(pageHeight - propTabHeight);
<%}else{%>
		jQuery(".tab_box").height(pageHeight - propTabHeight-jQuery(".e8_boxhead").height());
<%}%>
		var divContentHeight=jQuery(".tab_box").height()-deltaHeight;
		var divContentWidth=pageWidth;
		//document.getElementById("divContent").style.height=divContentHeight;
		jQuery("#divContent").height(divContentHeight);
		//document.getElementById("divContentTab").style.height = pageHeight - propTabHeight;
		//jQuery("#divContentTab").height(pageHeight - propTabHeight);
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
		<% 
		for(Iterator mbit = menuBars.iterator();mbit.hasNext();){
			menuBarMap = (Map)mbit.next();
			if(menuBarMap.size()>0) {
				String toolid = (String)menuBarMap.get("id");
				menuBarToolsMap = (Map[])menuBarMap.get("menu");
				if(menuBarToolsMap!=null&&menuBarToolsMap.length>0){
				%>
				try{
					hideToolsMenu<%=toolid%>();
				}catch(e){
					if(window.console)console.log(e+"-->DocDsp.jsp-->adjustContentHeight");
				}
				<%
				}
			}
		}
		%>
		onResizeDiv();
	} catch(e){
		if(window.console)console.log(e+"-->DocDsp.jsp end-->adjustContentHeight");
	}
}
var lastTab = "divProp";
var fromTab = '0';
function onExpandOrCollapse(show,from){
	var flag = false;
	if(document.getElementById("divPropTab")&&document.getElementById("divPropTab").style.display=="none"||show) flag = true;
	var e8_shadow = jQuery("#e8_shadow");
	if(flag){
		e8_shadow.show();
		//document.getElementById("divPropTab").style.display = "block";
		//document.getElementById("divPropTabCollapsed").style.display = "none";
		if(document.getElementById("spanProp")) document.getElementById("spanProp").innerHTML=wmsg.base.hiddenProp;
		jQuery("#divTab #divPropTileIcon").removeClass("x-tool-expand-south").addClass("x-tool-collapse-south-over ");
		if(!from){
			onActiveTab(lastTab);
		}
	}else{
		e8_shadow.hide();
		document.getElementById("divPropTab").style.display = "none";
		//document.getElementById("divPropTabCollapsed").style.display = "block";
		if(document.getElementById("spanProp")) document.getElementById("spanProp").innerHTML=wmsg.base.showProp;
		jQuery("#divTab #divPropTileIcon").removeClass("x-tool-collapse-south-over").addClass("x-tool-expand-south");
		jQuery("#divTab li.x-tab-strip-active").removeClass("x-tab-strip-active");
	}
	adjustContentHeight();
	try {
		loadExt();
	} catch(e){}
}
<%
    String accUrl="/docs/docs/DocAcc.jsp?canEdit="+canEdit+"&canDownload="+canDownload+"&language="+user.getLanguage()+"&bacthDownloadFlag="+DocUtil.getBatchDownloadFlag(docid)+"&docid="+docid+"&mode=view&pagename=docdsp&isFromWf=false&operation=getDivAcc&maxUploadImageSize="+DocUtil.getBatchDownloadFlag(docid)+"&isrequest="+isrequest+"&requestid="+requestid+"&desrequestid="+desrequestid+"&meetingid="+meetingid+"&votingId="+votingId+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+formmodeparamsStr; 
	String replyInfoUrl=null;
	if(DocReplyUtil.isUseNewReply()){
		replyInfoUrl="/docs/reply/DocReplyGetNew.jsp?docid="+docid+"&secid="+seccategory;
	}else{
		replyInfoUrl="/docs/docs/DocReplyGetNew.jsp?docid="+docid+"&secid="+seccategory;
	}
	String shareUrl="/docs/docs/DocShareGetNew.jsp?language="+user.getLanguage()+"&id="+docid+"&mode=view&pagename=docdsp&canShare="+canShare+"&operation=getDivShare&docvestin="+DocManager.getDocVestIn();
	String verUrl="/docs/docs/DocVersionGetNew.jsp?language="+user.getLanguage()+"&docid="+docid+"&mode=view&pagename=docdsp&canShare="+canShare+"&operation=getDivVer&doceditionid="+doceditionid+"&readerCanViewHistoryEdition="+readerCanViewHistoryEdition+"&canEditHis="+canEditHis; 	
    
	String logUrl="/docs/DocDetailLogTab.jsp?height=all&_fromURL=0&language="+user.getLanguage()+"&id="+docid+"&mode=view&pagename=docdsp&canShare="+canShare+"&operation=getDivViewLog";
	
	String logUrlReaded="/docs/DocDetailLogTab.jsp?height=all&_fromURL=5&language="+user.getLanguage()+"&id="+docid+"&mode=view&pagename=docdsp&canShare="+canShare+"&operation=getDivViewLog";
	
    String docmarkUrl="/docs/docmark/DocMarkAdd.jsp?language="+user.getLanguage()+"&docId="+docid+"&mode=view&pagename=docdsp&secId="+seccategory+"&operation=getDivMark&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
    String relativeResourceUrl="/docs/docs/DocRelationGetNew.jsp?requestid="+requestid
						+"&secid="+seccategory+"&language="+user.getLanguage()+"&docid="+docid+"&mode=view&pagename=docdsp&canShare="+canShare+"&operation=getDivRelationResource&requestid="
						+requestid+"&olddocid="+olddocid
						+"&isrequest="+isrequest
						+"&doccreaterid="+doccreaterid
						+"&docCreaterType="+docCreaterType
						+"&ownerid="+ownerid
						+"&ownerType="+ownerType;	
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
var has_resourceListIfrm=0;

function onActiveTab(tab,notOpen){
	lastTab = tab;
	document.getElementById("divProp").style.display='none';
	document.getElementById("divAcc").style.display='none';
	document.getElementById("divContentInfo").style.display='none';
	if(tab=="divContentInfo"){
		var e8AccListArea = jQuery("div.e8AccListArea");
		if(e8AccListArea.length>0){
			if(e8AccListArea.data("isClosed")===true){
				jQuery("div.e8AccListBtn").show();
			}else{
				e8AccListArea.show();
			}
		}
	}else{
		jQuery("div.e8AccListArea").hide();
 		jQuery("div.e8AccListBtn").hide();
	}

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
		document.getElementById("logListIfrm").src="<%=logUrlReaded%>";
	}
	if(tab=="divMark"&&has_markListIfrm==0){
		has_markListIfrm=1;
		document.getElementById("markListIfrm").src="<%=docmarkUrl%>";
	}
	if(tab=="divRelationResource"&&has_resourceListIfrm==0){
		has_resourceListIfrm=1;
		document.getElementById("resourceListIfrm").src="<%=relativeResourceUrl%>";
	}
	var e8_shadow = jQuery("#e8_shadow");
	<% if(canReplay) { %>
	
	<% if(DocReplyUtil.isUseNewReply()){ %>
		if(fromTab == "1")
		{
				window.setTimeout(function(){
					try{
						replyInfoIfrm.window.initRemark();
						fromTab = "0";
					}catch(e){}
				},200);
		}
		else
		{
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
	<% if(relationable==1){ %>
	document.getElementById("divRelationResource").style.display='none';
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
	<% if(relationable==1){ %>
	document.getElementById("divRelationResourceATab").className = "";
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
	} catch(e){if(window.console)console.log(e);}
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
	<% if(relationable==1){ %>
	else if(document.getElementById("divRelationResource").style.display!='none')
		resizedivRelationResource();
	<% } %>
}
<%
    if(isPDF){
		String sessionParaPDF=""+docid+"_"+imagefileId+"_"+userid+"_"+logintype;
		session.setAttribute("canEdit_"+sessionParaPDF,canEdit?"1":"0");
		session.setAttribute("canPrint_"+sessionParaPDF,canPrint?"1":"0");	
		session.setAttribute("isSignatureNodes_"+sessionParaPDF,isSignatureNodes?"1":"0");				
	}
%>

jQuery(document).ready(
	function(){
		
		try{
			onLoad();
		} catch(e){}
		
		try{
			document.getElementById("doccontentifm").src = "/docs/docs/DocDspHtmlShow.jsp?iscopycontrol=<%=iscopycontrol%>&docid=<%=docid%>&imagefileId=<%=imagefileId%>&isPDF=<%=isPDF?1:0%>&canPrint=<%=canPrint?1:0%>&canEdit=<%=canEdit?1:0%>&doccontentbackgroud=<%=URLEncoder.encode(doccontentbackgroud)%>&isrequest=<%=isrequest%>&requestid=<%=requestid%>&isSignatureNodes=<%=isSignatureNodes?1:0%>&pointUrl=<%=pointUrl %>&pointImagefileId=<%=pointImagefileId %>&nodeId=<%=nodeid2 %>";
			
			document.getElementById("divPropTab").style.display = "none";
			//document.getElementById("divPropTabCollapsed").style.display = "block";

			//onActiveTab("divProp",true);
			setE8ShadowPosition("divContentInfo");
			
			document.getElementById('rightMenu').style.visibility="hidden";
			document.getElementById("divTopMenu").style.display='';	

			adjustContentHeight("load");

			document.getElementById("divContentTab").style.display='block';
		} catch(e){}

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

		//finalDo("view");

		try{	
			onLoadEnd();
		} catch(e){}
	}
);

function onDownload(){
<%if(canDownload&&isPDF){%>
	top.location="/weaver/weaver.file.FileDownload?fileid=<%=imagefileId%>&download=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>&votingId=<%=votingId%>&f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>";
<%}%>
}
</script>
<jsp:include page="/docs/docs/DocDspScript.jsp">
	<jsp:param name="f_weaver_belongto_userid" value="<%=f_weaver_belongto_userid%>" />
	<jsp:param name="f_weaver_belongto_usertype" value="<%=f_weaver_belongto_usertype%>" />
    <jsp:param name="docid" value="<%=docid%>" />
    <jsp:param name="docmouldid" value="<%=docmouldid%>" />
    <jsp:param name="username" value="<%=username%>" />
    <jsp:param name="CurrentDate" value="<%=CurrentDate%>" />
    <jsp:param name="CurrentTime" value="<%=CurrentTime%>" />
	<jsp:param name="parentids" value="<%=parentids%>" />
	<jsp:param name="meetingid" value="<%=meetingid%>" />
	<jsp:param name="workplanid" value="<%=workplanid%>" />
	<jsp:param name="isPDF" value="<%=isPDF?1:0%>" />
</jsp:include>
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
    <jsp:param name="isSetShare" value="<%=isSetShare%>" />
    <jsp:param name="doc_topage" value="<%=doc_topage%>" />
    <jsp:param name="isfromext" value="0" />
</jsp:include>
<style>
	.x-ie-shadow{
		 background-color:#fff;
		background-color:#777!important;
	}
</style>