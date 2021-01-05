
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.docs.docs.CustomFieldManager,
                 java.net.*" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.file.Prop" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="iWebOfficeConf.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryManager" class="weaver.docs.category.SecCategoryManager" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="AssetAssortmentComInfo" class="weaver.lgc.maintenance.AssetAssortmentComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="Record" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="DocUserSelfUtil" class="weaver.docs.docs.DocUserSelfUtil" scope="page"/>
<jsp:useBean id="SpopForDoc" class="weaver.splitepage.operate.SpopForDoc" scope="page"/>
<jsp:useBean id="DocUtil" class="weaver.docs.docs.DocUtil" scope="page" />
<jsp:useBean id="DocDsp" class="weaver.docs.docs.DocDsp" scope="page"/>
<jsp:useBean id="SecCategoryMouldComInfo" class="weaver.docs.category.SecCategoryMouldComInfo" scope="page"/>
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page"/>
<jsp:useBean id="DocCoder" class="weaver.docs.docs.DocCoder" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="DocMouldComInfo" class="weaver.docs.mould.DocMouldComInfo" scope="page" />
<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<jsp:useBean id="DocMark" class="weaver.docs.docmark.DocMark" scope="page" />
<jsp:useBean id="rsDummyDoc" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page"/>
<jsp:useBean id="DocHandwrittenManager" class="weaver.docs.docs.DocHandwrittenManager" scope="page"/>
<jsp:useBean id="DocDetailLog" class="weaver.docs.DocDetailLog" scope="page"/>
<jsp:useBean id="ResourceConditionManager" class="weaver.workflow.request.ResourceConditionManager" scope="page"/>
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="WTRequestUtil" class="weaver.worktask.worktask.WTRequestUtil" scope="page" />
<jsp:useBean id="shareManager" class="weaver.share.ShareManager" scope="page" />
<jsp:useBean id="TexttoPDFManager" class="weaver.workflow.request.TexttoPDFManager" scope="page" />
<jsp:useBean id="ODocRightManager" class="weaver.odoc.workflow.request.ODocRightManager" scope="page" />
<%//判断金阁控件的版本	 2003还是2006

String canPostil = "";
if(isIWebOffice2006 == true){
	canPostil = ",1";
}
int languageId=user.getLanguage();

char flag=Util.getSeparator() ;

//user info
String userid=""+user.getUID();
String logintype = user.getLogintype();
String username=ResourceComInfo.getResourcename(""+userid);
String userSeclevel = user.getSeclevel();
String userType = ""+user.getType();
String userdepartment = ""+user.getUserDepartment();
String usersubcomany = ""+user.getUserSubCompany1();
String f_weaver_belongto_userid=Util.null2String(request.getParameter("f_weaver_belongto_userid"));
String f_weaver_belongto_usertype=Util.null2String(request.getParameter("f_weaver_belongto_usertype"));
String isAppendTypeField = Util.null2String(request.getParameter("isAppendTypeField"));
HrmUserSettingComInfo userSetting=new HrmUserSettingComInfo();
String belongtoshow = userSetting.getBelongtoshowByUserId(user.getUID()+""); 
String belongtoids = user.getBelongtoids();
String account_type = user.getAccount_type();
String isrequest = Util.null2String(request.getParameter("isrequest"));
int requestid=Util.getIntValue(request.getParameter("requestid"),0);
int workflowid=0;
int nodeid=0;
int currentnodeid=0;
int lastnodeid = 0;
String nodeName="";
String ifVersion="0";
boolean hasRightOfViewHisVersion=HrmUserVarify.checkUserRight("DocExt:ViewHisVersion", user);

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

//判断新建的是不是个人文档
boolean isPersonalDoc = false ;
String from =  Util.null2String(request.getParameter("from"));
int userCategory= Util.getIntValue(request.getParameter("userCategory"),0);
if ("personalDoc".equals(from)){
    isPersonalDoc = true ;
}
boolean isFromAccessory="true".equals(request.getParameter("isFromAccessory"))?true:false;
//签章类型（signatureType）1：WPS混合签章；2：360签章；其他，Office签章
String signatureType=Util.null2String(Prop.getPropValue("wps_office_signature","wps_office_signature"));
String wps_version=Util.null2String(Prop.getPropValue("wps_office_signature","wps_version"));
String temStr = request.getRequestURI();
temStr=temStr.substring(0,temStr.lastIndexOf("/")+1);

String mServerUrl=temStr+mServerName;
String mClientUrl=temStr+mClientName;

String fromFlowDoc=Util.null2String(request.getParameter("fromFlowDoc"));  //来源于流程建文挡
int docid = Util.getIntValue(request.getParameter("id"),0);
int versionId = Util.getIntValue(request.getParameter("versionId"),0);
if(isrequest.equals("1")&&requestid>0){
	versionId=0;
	int maxId=0;
	RecordSet.executeSql("select max(a.id) as maxid from DocDetail a where a.doceditionid>0 and  exists(select 1 from DocDetail  where doceditionid=a.doceditionid and id="+docid+") ") ;
	if(RecordSet.next()){
		maxId = Util.getIntValue(RecordSet.getString("maxid"),0);
	}
	if(maxId>docid){
		docid=maxId;
	}
}
//取得文档数据
String sql = "";
if(versionId==0){
    sql = "select * from DocImageFile where docid="+docid+" and (isextfile <> '1' or isextfile is null) order by versionId desc";
}else{
    sql = "select * from DocImageFile where docid="+docid+" and versionId="+versionId;
}
RecordSet.executeSql(sql) ;
RecordSet.next();
versionId = Util.getIntValue(RecordSet.getString("versionId"),0);
if(versionId==0){
	sql = "select * from DocImageFile where docid="+docid+" order by versionId desc";
	RecordSet.executeSql(sql) ;
	RecordSet.next();
}
versionId = Util.getIntValue(RecordSet.getString("versionId"),0);
String fileName=Util.null2String(""+RecordSet.getString("imagefilename"));
String filetype=Util.null2String(""+RecordSet.getString("docfiletype"));

String agent = request.getHeader("user-agent");
if((agent.contains("Firefox")||agent.contains(" Chrome")||agent.contains("Safari") )|| agent.contains("Edge")){
	isIE = "false";
}else{
	isIE = "true";
}	
if("false".equals(isIE)){
	response.sendRedirect("/docs/docs/DocDspExt.jsp?fromFlowDoc="+fromFlowDoc+"&isFromAccessory="+isFromAccessory+"&isAppendTypeField="+isAppendTypeField+"&id="+docid+"&versionId="+versionId+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&isrequest="+isrequest+"&requestid="+requestid) ;
	return ;	
}

int imagefileId = Util.getIntValue(request.getParameter("imagefileId"),0);

/*判断是否是PDF文档//文档中心的是否打开附件控制*/
String isOpenFirstAss = Util.null2String(request.getParameter("isOpenFirstAss"));
boolean isPDF = DocDsp.isPDF(docid,imagefileId,Util.getIntValue(isOpenFirstAss,1));
if(imagefileId==0&&Util.getIntValue(filetype,0) != 2) isPDF = false;
if(isPDF){
    //response.sendRedirect("DocDsp.jsp?id="+docid+"&imagefileId="+imagefileId+"&isFromAccessory=true&isrequest=1&requestid="+requestid);
%>
		    <script language=javascript>
					location="DocDsp.jsp?id=<%=docid%>&imagefileId=<%=imagefileId%>&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>&fromFlowDoc=<%=fromFlowDoc%>";
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
    filetype=".doc";
}


String  docEditType=Util.null2String(request.getParameter("docEditType"));
if(docEditType.equals("")){
    docEditType = "1";
}
String topageFromOther=Util.null2String(request.getParameter("topage"));
String subid=Util.null2String(request.getParameter("subid"));
int SecId=Util.getIntValue(Util.null2String(request.getParameter("SecId")),0);
int maxUploadImageSize = DocUtil.getMaxUploadImageSize2(docid);
int bacthDownloadFlag = DocUtil.getBatchDownloadFlag(docid);
String fromFlowDocsubm=Util.null2String(request.getParameter("fromFlowDocsubm"));
String needinputitems = "";
DocManager.resetParameter();
DocManager.setId(docid);
DocManager.getDocInfoById();
boolean isDefaultNoShowRevision=false;

String checkOutStatus=DocManager.getCheckOutStatus();
int checkOutUserId=DocManager.getCheckOutUserId();
String checkOutUserType=DocManager.getCheckOutUserType();

String checkOutUserName="";
if(checkOutUserType!=null&&checkOutUserType.equals("2")){
	checkOutUserName=CustomerInfoComInfo.getCustomerInfoname(""+checkOutUserId);
}else{
	checkOutUserName=ResourceComInfo.getResourcename(""+checkOutUserId);
}

String checkOutDate=DocManager.getCheckOutDate();
String checkOutTime=DocManager.getCheckOutTime();
String nodeType = "0";

//文档信息
int maincategory=DocManager.getMaincategory();
int subcategory=DocManager.getSubcategory();
int seccategory=DocManager.getSeccategory();
int secid = seccategory;//白名单功能
int doclangurage=DocManager.getDoclangurage();
String docapprovable=DocManager.getDocapprovable();
String docreplyable=DocManager.getDocreplyable();
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
int assetid=DocManager.getAssetid();
int ownerid=DocManager.getOwnerid();
String keyword=DocManager.getKeyword();
int accessorycount=DocManager.getAccessorycount();
int replaydoccount=DocManager.getReplaydoccount();
String usertype=DocManager.getUsertype();
String canCopy=DocManager.getCanCopy();  //1:不能拷贝 其他：代表可以拷贝
//System.out.println("canCopyEdit = " + canCopy);


String docCode = DocManager.getDocCode();
int docedition = DocManager.getDocEdition();
int doceditionid = DocManager.getDocEditionId();

int selectedpubmouldid = DocManager.getSelectedPubMouldId();

String docCreaterType = DocManager.getDocCreaterType();//文档创建者类型（1:内部用户  2：外部用户）
String ownerType = DocManager.getOwnerType();//文档拥有者类型（1:内部用户  2：外部用户）

int maindoc = DocManager.getMainDoc();


int docreadoptercanprint = DocManager.getReadOpterCanPrint();

boolean isTemporaryDoc = false;
String invalidationdate = DocManager.getInvalidationDate();
String reqinvalidationdate = request.getParameter("invalidationdate");
if(reqinvalidationdate!=null)
    invalidationdate = reqinvalidationdate;
if(invalidationdate!=null&&!"".equals(invalidationdate))
    isTemporaryDoc = true;

String docstatusname = DocComInfo.getStatusView(docid,user);
String isTextInForm = Util.null2String(request.getParameter("isTextInForm"));

//是否回复提醒
String canRemind=DocManager.getCanRemind();
String hasUsedTemplet=DocManager.getHasUsedTemplet();//是否已经套红
int canPrintedNum=DocManager.getCanPrintedNum();//可打印份数
int editMouldId=DocManager.getEditMouldId();//编辑模板id

DocManager.closeStatement();
String docmain = "";

if(ownerid==0) ownerid=user.getUID() ;
String owneridname=ResourceComInfo.getResourcename(ownerid+"");
if (fromFlowDoc.equals("1")) {
	String tempdocsubject=Util.null2String((String)session.getAttribute(""+user.getUID()+"_"+requestid+"docsubject"));

	if(tempdocsubject.equals("")){
		tempdocsubject=Util.null2String((String)session.getAttribute("docsubject"+user.getUID()));
	}
	session.removeAttribute(""+user.getUID()+"_"+requestid+"docsubject");
	session.removeAttribute("docsubject"+user.getUID());
	if(!tempdocsubject.equals("")){
		docsubject=tempdocsubject;
	}
}

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
String needapprovecheck="";
if(approvewfid.equals(""))  approvewfid="0";
if(approvewfid.equals("0"))
    needapprovecheck="0";
else
    needapprovecheck="1";

String readoptercanprint = Util.null2String(""+RecordSet.getString("readoptercanprint"));

/*现在把附件的添加从由文档管理员确定改成了由用户自定义的方式.*/
// String hasaccessory =Util.toScreen(RecordSet.getString("hasaccessory"),languageId);
// int accessorynum = Util.getIntValue(RecordSet.getString("accessorynum"),languageId);
String hasasset=Util.toScreen(RecordSet.getString("hasasset"),languageId);
String assetlabel=Util.toScreen(RecordSet.getString("assetlabel"),languageId);
String hasitems =Util.toScreen(RecordSet.getString("hasitems"),languageId);
String itemlabel =Util.toScreenToEdit(RecordSet.getString("itemlabel"),languageId);
String hashrmres =Util.toScreen(RecordSet.getString("hashrmres"),languageId);
String hrmreslabel =Util.toScreenToEdit(RecordSet.getString("hrmreslabel"),languageId);
String hascrm =Util.toScreen(RecordSet.getString("hascrm"),languageId);
String crmlabel =Util.toScreenToEdit(RecordSet.getString("crmlabel"),languageId);
String hasproject =Util.toScreen(RecordSet.getString("hasproject"),languageId);
String projectlabel =Util.toScreenToEdit(RecordSet.getString("projectlabel"),languageId);
String hasfinance =Util.toScreen(RecordSet.getString("hasfinance"),languageId);
String financelabel =Util.toScreenToEdit(RecordSet.getString("financelabel"),languageId);
String approvercanedit=Util.toScreen(RecordSet.getString("approvercanedit"),languageId);

int maxOfficeDocFileSize = Util.getIntValue(RecordSet.getString("maxOfficeDocFileSize"),8);

boolean isEditionOpen = SecCategoryComInfo.isEditionOpen(seccategory);

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
	StringBuffer canDoPrintByApplySb=new StringBuffer();
	canDoPrintByApplySb.append(" select 1   ")
		               .append(" from workflow_requestbase a,Bill_DocPrintApply b ")
		               .append(" where a.requestId=b.requestid ")
		               .append("   and a.currentNodeType='3' ")
		               .append("   and b.resourceId=").append(userid)
		               .append("   and b.relatedDocId=").append(docid)
		               .append("   and printNum>hasPrintNum ")
    ;
	RecordSet.executeSql(canDoPrintByApplySb.toString());
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
boolean isCleanCopyNodes=false;
boolean showSignatureAPI=false;//璋冪敤Signature鐨凙PI
boolean isSavePDF=false;//鍙﹀瓨涓篜DF
boolean isSaveDecryptPDF=false;//鍙﹀瓨涓鸿劚瀵哖DF
int operationtype=0;
List attachmentList=new ArrayList();
int useTempletNode=0;
String signatureNodes = "";//是否显示签章
String cleanCopyNodes = "";
String isCompellentMark = "0";//是否必须显示痕迹
String isCancelCheck = "0";//是否取消审阅
String isHideTheTraces="0";//编辑正文时默认隐藏痕迹

if(fromFlowDoc.equals("1")){
	nodeid=WFLinkInfo.getCurrentNodeid(requestid,Util.getIntValue(userid,0),Util.getIntValue(logintype,1));               //节点id
	RecordSet.executeSql("select workflowId,currentNodeId, lastnodeid, currentnodetype from workflow_requestbase where requestid="+requestid);
	if(RecordSet.next()){
		workflowid=RecordSet.getInt("workflowid");
		//nodeid=RecordSet.getInt("currentnodeid");
        currentnodeid=RecordSet.getInt("currentnodeid");
		lastnodeid = RecordSet.getInt("lastnodeid");
		nodeType = Util.null2String(RecordSet.getString("currentnodetype"));
	}

	RecordSet.executeSql("select ifVersion from workflow_base where id="+workflowid);
	if(RecordSet.next()){
		ifVersion = Util.null2String(RecordSet.getString("ifVersion"));
	}
	RecordSet.executeSql("select nodeName from workflow_nodebase where id="+nodeid);
	if(RecordSet.next()){
		nodeName = Util.null2String(RecordSet.getString("nodeName"));
	}

	RecordSet.executeSql("select * from workflow_createdoc where workflowId="+workflowid);
	if(RecordSet.next()){
		useTempletNode=RecordSet.getInt("useTempletNode");
		printNodes=Util.null2String(RecordSet.getString("printNodes"));
		isCompellentMark = Util.null2String(RecordSet.getString("iscompellentmark"));
		isCancelCheck = Util.null2String(RecordSet.getString("iscancelcheck"));
		signatureNodes = Util.null2String(RecordSet.getString("signatureNodes"));
		isHideTheTraces = Util.null2String(RecordSet.getString("isHideTheTraces"));
		cleanCopyNodes = Util.null2String(RecordSet.getString("cleanCopyNodes"));		
	}
	if("".equals(isCompellentMark)){
		isCompellentMark = "0";
	}
	if("".equals(isCancelCheck)){
		isCancelCheck = "0";
	}

	if(nodeid==useTempletNode&&nodeid>0&&nodeid==currentnodeid){
		isUseTempletNode=true;
	}

	if(!printNodes.equals("")){
		hasPrintNode=true;
	}
	if((","+printNodes+",").indexOf(","+nodeid+",")>=0&&nodeid>0&&nodeid==currentnodeid){
		isPrintNode=true;
	}
	if((","+signatureNodes+",").indexOf(","+nodeid+",")>=0&&nodeid>0&&nodeid==currentnodeid){
		isSignatureNodes=true;
	}
	if((","+cleanCopyNodes+",").indexOf(","+nodeid+",")>=0&&nodeid>0&&nodeid==currentnodeid){
		isCleanCopyNodes=true;
	}	
	String imagefileIdpdf="";
	rs.executeSql("select imagefileid from docimagefile where docid="+docid+" and  ( isextfile is null or isextfile<>1) and docfiletype=12 order by    imagefileid desc ");
    if(rs.next()&&imagefileId==0){
      imagefileIdpdf=Util.null2String(rs.getString("imagefileid"));
    }
    if(!imagefileIdpdf.equals("")){
        response.sendRedirect("/docs/docs/DocDsp.jsp?id="+docid+"&requestid="+requestid+"&nodeId="+currentnodeid+"&isPrintNode="+isPrintNode+"&isSignatureNodes="+isSignatureNodes+"&from=pdfText&fromFlowDoc=" + fromFlowDoc);
		return ;
    }

	Map  texttoPDFMap=TexttoPDFManager.getTexttoPDFMap(requestid, workflowid, currentnodeid,docid);
	showSignatureAPI="1".equals((String)texttoPDFMap.get("showSignatureAPI"))?true:false;
 	isSavePDF="1".equals((String)texttoPDFMap.get("isSavePDF"))?true:false;
	isSaveDecryptPDF="1".equals((String)texttoPDFMap.get("isSaveDecryptPDF"))?true:false;
	attachmentList=(List)texttoPDFMap.get("attachmentList");
	operationtype=Util.getIntValue((String)texttoPDFMap.get("operationtype"),0);
}




/***************************权限判断**************************************************/
boolean  canReader = false;
boolean  canEdit = false;
boolean  canViewLog = false;
boolean canDel = false;
boolean canShare = false ;
String sharelevel="";
//String logintype = user.getLogintype() ;
//String userid = "" +user.getUID() ;
//String userSeclevel = user.getSeclevel();
//String userType = ""+user.getType();
//String userdepartment = ""+user.getUserDepartment();
//String usersubcomany = ""+user.getUserSubCompany1();
if("2".equals(logintype)){
	userdepartment="0";
	usersubcomany="0";
	userSeclevel="0";
}
String userInfo=logintype+"_"+userid+"_"+userSeclevel+"_"+userType+"_"+userdepartment+"_"+usersubcomany;
SpopForDoc.setIscloseMoreSql(true);
ArrayList PdocList =  SpopForDoc.getDocOpratePopedom(""+docid,userInfo);
//0:查看 1:编辑 2:删除 3:共享 4:日志
if (((String)PdocList.get(0)).equals("true")) canReader = true ;
if (((String)PdocList.get(1)).equals("true")) canEdit = true ;
if (((String)PdocList.get(2)).equals("true")) canDel = true ;
if (((String)PdocList.get(3)).equals("true")) canShare = true ;
if (((String)PdocList.get(4)).equals("true")) canViewLog = true ;    

if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")&&!canEdit){//濡傛灉涓昏处鍙蜂笉鑳借兘鏌ョ湅闅忔満鎵炬璐﹀彿鐨勬潈闄?
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
			userid=votingshareids[i];
		}
		if (((String)PdocList.get(1)).equals("true")&&!canEdit) {
			canEdit = true ;
		    f_weaver_belongto_userid=votingshareids[i];
			user=HrmUserVarify.getUser(request,response,f_weaver_belongto_userid,userType) ;
			userid=votingshareids[i];
		}
        if (((String)PdocList.get(2)).equals("true")) canDel = true ;
        if (((String)PdocList.get(3)).equals("true")) canShare = true ;
        if (((String)PdocList.get(4)).equals("true")) canViewLog = true ;
		
	}
	
}
session.setAttribute("f_weaver_belongto_userid_doc",f_weaver_belongto_userid);
session.setAttribute("f_weaver_belongto_usertype_doc",f_weaver_belongto_usertype);
   
if(!canEdit&&fromFlowDoc.equals("1")){
	if((userid.equals(""+doccreaterid)&&logintype.equals(docCreaterType))||(userid.equals(""+ownerid)&&logintype.equals(ownerType))){
		canEdit=true;
	}
}

//归档状态的文档不能被编辑
if(canEdit && (docstatus.equals("5"))){
    canEdit = false;
}

boolean blnRealViewLog=false;
if((SecCategoryComInfo.getLogviewtype(seccategory)==1&&user.getLoginid().equalsIgnoreCase("sysadmin"))||(SecCategoryComInfo.getLogviewtype(seccategory)==0)){
	blnRealViewLog=canViewLog;
}
if(fromFlowDocsubm.equals("1")&&operationtype==1){
 canEdit = true;
}

if(!canEdit&&requestid>0){
	if(ODocRightManager.ifCanEdit(requestid,nodeid,user,docid)){
		canEdit=true;
	}
}

if(!canEdit)  {
    //response.sendRedirect("/notice/noright.jsp") ;
    //return ;
    if(!canReader&&(isrequest.equals("1") || requestid > 0)){
    	canReader=WFUrgerManager.OperHaveDocViewRight(requestid,user.getUID(),Util.getIntValue(logintype,1),""+docid);
	}
	//从计划任务处过来
	String fromworktask = Util.getFileidIn(Util.null2String(request.getParameter("fromworktask")));
	String operatorid = Util.getFileidIn(Util.null2String(request.getParameter("operatorid")));
	if(!canReader&&"1".equals(fromworktask)) {
		canReader=WTRequestUtil.UrgerHaveWorktaskDocViewRight(requestid,Util.getIntValue(userid), docid ,Util.getIntValue(operatorid,0));
	}
	if(canReader){
		response.sendRedirect("/docs/docs/DocDspExt.jsp?fromFlowDoc="+fromFlowDoc+"&id="+docid+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype) ;
		return ;		
	}else{
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
}

temStr="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";

temStr+=SystemEnv.getHtmlLabelName(401,languageId)+":"+doccreatedate+" "+doccreatetime+" "+SystemEnv.getHtmlLabelName(623,languageId)+":"+Util.toScreen(ResourceComInfo.getResourcename(""+doccreaterid),languageId)+SystemEnv.getHtmlLabelName(103,languageId)+":"+doclastmoddate+" "+doclastmodtime+" "+SystemEnv.getHtmlLabelName(623,languageId)+":"+Util.toScreen(ResourceComInfo.getResourcename(""+doclastmoduserid),languageId);
if(docstatus.equals("0")){
    docEditType = "1";
}else{
    docEditType = "2";
}

if(checkOutStatus!=null&&(checkOutStatus.equals("1")||checkOutStatus.equals("2"))&&!(checkOutUserId==user.getUID()&&checkOutUserType!=	null&&checkOutUserType.equals(user.getLogintype()))){

	String checkOutMessage=SystemEnv.getHtmlLabelName(19695,languageId)+SystemEnv.getHtmlLabelName(19690,languageId)+"："+checkOutUserName;

    checkOutMessage=URLEncoder.encode(URLEncoder.encode(checkOutMessage,"UTF-8"),"UTF-8");

    response.sendRedirect("DocDspExt.jsp?id="+docid+"&checkOutMessage="+checkOutMessage+"&fromFlowDoc="+fromFlowDoc+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&f_weaver_belongto_userid="+f_weaver_belongto_userid);
    return ;
}else if(!"1".equals(checkOutStatus)&&!"2".equals(checkOutStatus)){
        Calendar today = Calendar.getInstance();
        String formatDate = Util.add0(today.get(Calendar.YEAR), 4) + "-"
                + Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-"
                + Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
        String formatTime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":"
                + Util.add0(today.get(Calendar.MINUTE), 2) + ":" + Util.add0(today.get(Calendar.SECOND), 2);

        checkOutDate=formatDate;
        checkOutTime=formatTime;
        checkOutUserName=user.getUsername();
        checkOutStatus="1";

         RecordSet.executeSql("update  DocDetail set checkOutStatus='1',checkOutUserId="+user.getUID()+",checkOutUserType='"+user.getLogintype()+"',checkOutDate='"+formatDate+"',checkOutTime='"+formatTime+"' where id="+docid);

		 DocDetailLog.resetParameter();
		 DocDetailLog.setDocId(docid);
		 DocDetailLog.setDocSubject(docsubject);
		 DocDetailLog.setOperateType("18");
		 DocDetailLog.setOperateUserid(user.getUID());
		 DocDetailLog.setUsertype(user.getLogintype());
		 DocDetailLog.setClientAddress(request.getRemoteAddr());
		 DocDetailLog.setDocCreater(doccreaterid);
		 DocDetailLog.setCreatertype(docCreaterType);
		 DocDetailLog.setDocLogInfo();  
}

if(fromFlowDoc.equals("1")){
    if(!isFromAccessory){
	    if( !userid.equals(""+doccreaterid) || !logintype.equals(docCreaterType) ){
			rs.executeProc("docReadTag_AddByUser",""+docid+flag+userid+flag+logintype);  // 他人
		}
	}
}

String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+Util.add0(docid,12)+"   "+temStr;;
String needfav ="1";
String needhelp ="";

boolean canPrint=true;
//启用打印控制，而文档已经没有可打印份数时不可打印
if(isPrintControl.equals("1")&&(!canDoPrintByDocDetail)){
	canPrint = false;
}

//启用打印控制或不启用打印控制，流程创建文档时当前节点为打印节点  则可打印
if(fromFlowDoc.equals("1")&&isPrintNode){
	canPrint = true;
}

//启用打印控制，流程创建文档时当前节点部委打印节点  则不可打印
if(isPrintControl.equals("1")&&fromFlowDoc.equals("1")&&hasPrintNode&&!isPrintNode){
	canPrint = false;
}

if(canDoPrintByApply){
    canPrint = true;
}
%>

<html>

<head>
<link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<link type="text/css" href="/css/ecology8/crudoc_wev8.css" rel="stylesheet"></link>

<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<jsp:include page="/systeminfo/WeaverLangJS.jsp">
    <jsp:param name="languageId" value="<%=user.getLanguage()%>" />
</jsp:include>

<script language="javascript">
    var f_weaver_belongto_userid='<%=f_weaver_belongto_userid%>';
    var f_weaver_belongto_usertype='<%=f_weaver_belongto_usertype%>';
	var menubar=[];
	var menubarForwf=[];
	var menuOtherBar=[];
	<%
	List menuBars = new ArrayList();
	List menuBarsForWf = new ArrayList();
	List menuOtherBar = new ArrayList();
	Map menuBarMap = new HashMap();
	Map[] menuBarToolsMap = new HashMap[]{};
	%>
	function webOfficeMenuClick(vIndex){
		if (vIndex==1)       <%if (!ifVersion.equals("1")) {%> onSave(); <%} else {%>onSaveNewVersion();<%}%>  //保存到服务器
		else if (vIndex==2)  <%if (!ifVersion.equals("1")) {%> onSave(); <%} else {%>onSaveNewVersion();<%}%> //保存到服务器
		else if (vIndex==3)  onDraft(); //保存为服务器草稿
		else if (vIndex==4)  onPreview(); //预览
		else if (vIndex==5)  onSaveNewVersion();  //存为新版本
		else if (vIndex==6)  openVersion(<%=versionId%>) ;   //打开版本
		else if (vIndex==7 || vIndex == 71)  ShowRevision();   //显示/隐藏痕迹
		else if (vIndex==8)  WebOpenLocal()     //打开本地文件
		else if (vIndex==9)  WebSaveLocal2();  //存为本地文件
		else if (vIndex==10) WebOpenSignature();  //签名印章
		else if (vIndex==11) shiftCanCopy();  //锁定拷贝
		else if (vIndex==12) shiftCanCopy;  //恢复拷贝
		else if (vIndex==13)  acceptAll();  //接受文档
		else if (vIndex==15) onExpandOrCollapse();  //显示/隐藏 
		else if (vIndex==16) location.reload();   //刷新  
		else if (vIndex==17) window.history.go(-1);  //返回
		else if (vIndex==47) onPrintDoc();//打印
		else if (vIndex==48) onPrintApply();//打印申请	
		else if (vIndex==49) onPrintLog();//打印日志	
		else if (vIndex==101) onCleanCopy();		
	}
</script>
<script language="javascript" for=WebOffice event="OnMenuClick(vIndex,vCaption)">   
	 webOfficeMenuClick(vIndex);
</script>

<%if(isIWebOffice2006 == true){%>
<script language=javascript for=WebOffice event=OnToolsClick(vIndex,vCaption)>
//响应工具栏事件
if (vIndex==-1){//控件默认的工具栏都是INDEX值为-1，这时我们需要用vCaption的值判断点了哪个按钮
  if(vCaption=="<%=SystemEnv.getHtmlLabelName(127874,user.getLanguage())%>"){//重新调用执行初始化的方法
    onLoadAgain();
  }
}
</script>
<%}%>

<script language="javascript">
function onBtnSearchClick(){}
jQuery(document).ready(function(){
	 jQuery("div#divTab").show();
});
function StatusMsg(mString){
  StatusBar.innerText=mString;
}



function WebSaveLocal2(){

        try{
			var tempFileName=document.getElementById("WebOffice").FileName;

			tempFileName=tempFileName.replace(/\\/g,'＼');
			tempFileName=tempFileName.replace(/\//g,'／');
			tempFileName=tempFileName.replace(/:/g,'：');
			tempFileName=tempFileName.replace(/\*/g,'×');
			tempFileName=tempFileName.replace(/\?/g,'？');
			tempFileName=tempFileName.replace(/\"/g,'“');
			tempFileName=tempFileName.replace(/</g,'＜');
			tempFileName=tempFileName.replace(/>/g,'＞');
			tempFileName=tempFileName.replace(/\|/g,'｜');

			var tempfiletype = tempFileName.substring(tempFileName.lastIndexOf("."),tempFileName.length);
			if(tempfiletype!=null&&(tempfiletype==".doc"||tempfiletype==".xls"||tempfiletype==".ppt"||tempfiletype==".wps"||tempfiletype==".docx"||tempfiletype==".xlsx"||tempfiletype==".pptx"||tempfiletype==".et")){
				tempFileName=tempFileName.substring(0,tempFileName.lastIndexOf("."));
				tempFileName=tempFileName.replace(/\./g,'．');
				tempFileName=tempFileName+tempfiletype;
			} else 

			tempFileName=tempFileName.replace(/\./g,'．');
			document.getElementById("WebOffice").FileName=tempFileName;
		}catch(e){}
  try{
    document.getElementById("WebOffice").WebSaveLocal();
    StatusMsg(document.getElementById("WebOffice").Status);
  }catch(e){}
}

function WebOpenLocal(){
	try {
		var tempFileName=document.getElementById("WebOffice").FileName;

		tempFileName=tempFileName.replace(/\\/g,'＼');
		tempFileName=tempFileName.replace(/\//g,'／');
		tempFileName=tempFileName.replace(/:/g,'：');
		tempFileName=tempFileName.replace(/\*/g,'×');
		tempFileName=tempFileName.replace(/\?/g,'？');
		tempFileName=tempFileName.replace(/\"/g,'“');
		tempFileName=tempFileName.replace(/</g,'＜');
		tempFileName=tempFileName.replace(/>/g,'＞');
		tempFileName=tempFileName.replace(/\|/g,'｜');

		tempFileName=tempFileName.replace(/\./g,'．');

		document.getElementById("WebOffice").FileName=tempFileName;
	}
	catch(e) {}
  try{	
    document.getElementById("WebOffice").WebOpenLocal();
    StatusMsg(document.getElementById("WebOffice").Status);
  }catch(e){
  }
}

<%
if(isHideTheTraces.equals("1")){
	isDefaultNoShowRevision=true;
}
%>

var viewStatus=false;
<%if(isDefaultNoShowRevision){%>
viewStatus=true;
<%}%>

<%if("1".equals(isCompellentMark) && fromFlowDoc.equals("1")){%>//是否必须保留痕迹

	function ShowRevision(mObject){
		//var mFlag=mObject.value;
		//alert(document.getElementById("WebOffice").editType);
		if (viewStatus){
			//mObject.value="隐藏痕迹";
			//document.getElementById("WebOffice").WebShow(true);
			<%if("1".equals(isCancelCheck)){%>
			document.getElementById("WebOffice").editType="-1,0,1,1,0,0,1<%=canPostil%>";
			<%}else{%>
			document.getElementById("WebOffice").editType="-1,0,1,1,0,1,1<%=canPostil%>";
			<%}%>
			viewStatus=false;
			StatusMsg("<%=SystemEnv.getHtmlLabelName(19712,languageId)%>...");
		}else{
			//mObject.value="显示痕迹";
			//document.getElementById("WebOffice").WebShow(false);
			<%if("1".equals(isCancelCheck)){%>
			document.getElementById("WebOffice").editType="-1,0,0,1,0,0,1<%=canPostil%>";
			<%}else{%>
			document.getElementById("WebOffice").editType="-1,0,0,1,0,1,1<%=canPostil%>";
			<%}%>
			viewStatus=true;
			StatusMsg("<%=SystemEnv.getHtmlLabelName(19713,languageId)%>...");
		}
	}
<%}else{%>
	function ShowRevision(mObject){

		if (viewStatus){
			weaver.WebOffice.WebShow(true);
			viewStatus=false;
			StatusMsg("<%=SystemEnv.getHtmlLabelName(19712,languageId)%>...");
		}else{
			weaver.WebOffice.WebShow(false);
			viewStatus=true;
			StatusMsg("<%=SystemEnv.getHtmlLabelName(19713,languageId)%>...");
		}
	}
<%}%>


function WebToolsVisible(ToolName,Visible){
  try{
    document.getElementById("WebOffice").WebToolsVisible(ToolName,Visible);
    StatusMsg(document.getElementById("WebOffice").Status);
  }catch(e){}
}

	function WebToolsVisibleISignatureFalse(){
	  try{
	    document.getElementById("WebOffice").WebToolsVisible("iSignature","false");
	  }catch(e){}
	  try{

	  }catch(e){}
	}

function WebToolsEnable(ToolName,ToolIndex,Enable){
  try{
    document.getElementById("WebOffice").WebToolsEnable(ToolName,ToolIndex,Enable);
    StatusMsg(document.getElementById("WebOffice").Status);
  }catch(e){}
}

function showMarkFunc(){
   ShowRevision();   
   //Ext.getCmp('hide_id').hide()
   document.getElementById('hide_id').style.display = "none";
   //Ext.getCmp('dispaly_id').show()
   document.getElementById('dispaly_id').style.display = "block";
}

function hideMarkFunc(){
   ShowRevision();   
   //Ext.getCmp('dispaly_id').hide()	
   document.getElementById('dispaly_id').style.display = "none";
   //Ext.getCmp('hide_id').show()
   document.getElementById('hide_id').style.display = "block";
}

function changeFileType(xFileType){
	return xFileType;
}

/*
Index:
wdPropertyAppName		:9
wdPropertyAuthor		:3
wdPropertyBytes			:22
wdPropertyCategory		:18
wdPropertyCharacters		:16
wdPropertyCharsWSpaces		:30
wdPropertyComments		:5
wdPropertyCompany		:21
wdPropertyFormat		:19
wdPropertyHiddenSlides		:27
wdPropertyHyperlinkBase		:29
wdPropertyKeywords		:4
wdPropertyLastAuthor		:7
wdPropertyLines			:23
wdPropertyManager		:20
wdPropertyMMClips 		:28
wdPropertyNotes			:26
wdPropertyPages			:14
wdPropertyParas			:24
wdPropertyRevision		:8
wdPropertySecurity		:17
wdPropertySlides		:25
wdPropertySubject		:2
wdPropertyTemplate		:6
wdPropertyTimeCreated		:11
wdPropertyTimeLastPrinted	:10
wdPropertyTimeLastSaved		:12
wdPropertyTitle			:1
wdPropertyVBATotalEdit		:13
wdPropertyWords			:15
*/
//获取或设置文档摘要信息
function WebShowDocumentProperties(Index){
    var propertiesValue="";
    try{
	    var properties = document.getElementById("WebOffice").WebObject.BuiltInDocumentProperties;
	    propertiesValue=properties.Item(Index).Value;
    }catch(e){
    }
    return propertiesValue;
}

function getFileSize(){
	var fileSize=new String((1.0*WebShowDocumentProperties(22))/(1024*1024));

    var len = fileSize.length;

	var afterDotCount=0;
	var hasDot=false;
    var newIntValue="";
	var newDecValue="";

    for(i = 0; i < len; i++){
		if(fileSize.charAt(i) == "."){ 
			hasDot=true;
		}else{
			if(hasDot==false){
				newIntValue+=fileSize.charAt(i);
			}else{
				afterDotCount++;
				if(afterDotCount<=2){
					newDecValue+=fileSize.charAt(i);
				}
			}
		}		
    }

    var newValue="";
	if(newDecValue==""){
		newValue=newIntValue;
	}else{
		newValue=newIntValue+"."+newDecValue;
	}

	return newValue;
}

var hasAcceptAllRevisions="false";

function SaveDocument(){
    var fileSize=getFileSize();

	if(parseFloat(fileSize)>parseFloat(<%=maxOfficeDocFileSize%>)){
		alert("<%=SystemEnv.getHtmlLabelName(24028,languageId)%>"+fileSize+"M，<%=SystemEnv.getHtmlLabelName(24029,languageId)%><%=maxOfficeDocFileSize%>M！");
		return false;
	}
  //document.getElementById("WebOffice").FileName=weaver.docsubject.value+"<%=filetype%>";
  //document.getElementById("WebOffice").FileName=document.getElementById("docsubject").value;
  document.getElementById("WebOffice").WebSetMsgByName("SAVETYPE","EDIT");

  //增加提示信息  开始
  showPrompt("<%=SystemEnv.getHtmlLabelName(18886,languageId)%>");
  
	
  //增加提示信息  结束
  document.getElementById("WebOffice").WebSetMsgByName("HASUSEDTEMPLET", document.getElementById("hasUsedTemplet").value);


  document.getElementById("WebOffice").FileType=changeFileType(document.getElementById("WebOffice").FileType);

<%
	if(!isFromAccessory){
%>
    var tempFileName=document.getElementById("docsubject").value;
<%
	}else{
	    String imageFileNameNoPostfix=fileName;
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
		postfixList.add(".et");			
		
		String tempPostfix=null;
		for(int i=0;i<postfixList.size();i++){
			tempPostfix=(String)postfixList.get(i)==null?"":(String)postfixList.get(i);			
		    if(imageFileNameNoPostfix.endsWith(tempPostfix)){
			    imageFileNameNoPostfix=imageFileNameNoPostfix.substring(0,imageFileNameNoPostfix.indexOf(tempPostfix));
	 	    }
		}
%>
    var tempFileName="<%=imageFileNameNoPostfix%>";
<% } %>
	tempFileName=tempFileName.replace(/\\/g,'＼');
	tempFileName=tempFileName.replace(/\//g,'／');
	tempFileName=tempFileName.replace(/:/g,'：');
	tempFileName=tempFileName.replace(/\*/g,'×');
	tempFileName=tempFileName.replace(/\?/g,'？');
	tempFileName=tempFileName.replace(/\"/g,'“');
	tempFileName=tempFileName.replace(/</g,'＜');
	tempFileName=tempFileName.replace(/>/g,'＞');
	tempFileName=tempFileName.replace(/\|/g,'｜');
	tempFileName=tempFileName.replace(/\./g,'．');

	tempFileName = tempFileName+document.getElementById("WebOffice").FileType;

    document.getElementById("WebOffice").FileName=tempFileName;
<%if(isIWebOffice2003&&filetype.equals(".doc")){%>
	try{
		var fileSize=0;
		document.getElementById("WebOffice").WebObject.SaveAs();
		fileSize=document.getElementById("WebOffice").WebObject.BuiltinDocumentProperties(22);
		document.getElementById("WebOffice").WebSetMsgByName("NEWFS",fileSize);
	}catch(e){
	}
<%}%>
  if (!document.getElementById("WebOffice").WebSave(<%=isNoComment%>)){
     StatusMsg(document.getElementById("WebOffice").Status);
     alert("<%=SystemEnv.getHtmlLabelName(19007,languageId)%>");
     //增加提示信息  开始
     hiddenPrompt();
     //增加提示信息  结束

     return false;
  }else{
     StatusMsg(document.getElementById("WebOffice").Status);
     //alert(document.getElementById("WebOffice").WebGetMsgByName("CREATEID"));
     //weaver.docId.value=document.getElementById("WebOffice").WebGetMsgByName("CREATEID");
     //weaver.docType.value=document.getElementById("WebOffice").WebGetMsgByName("DOCTYPE");
     //alert(weaver.docId.value);
     //alert(weaver.docType.value);

     //增加提示信息  开始
     hiddenPrompt();
     //增加提示信息  结束
	 <%
		if(operationtype ==0){
	 %>
 //return true;
     return onSavePDF();
	<%}else{%>
    return true;
	<%}%>
 
  }
}

/*
 * notInputVDetail 是否需要手动输入版本信息  false-手动输入
 * isFromAccessory 是否是附件
 */
function SaveDocumentNewV(notInputVDetail,isFromAccessory){
		return SaveDocumentNewV_all(1,notInputVDetail,isFromAccessory);
}

function SaveDocumentNewV_all(isprompt,notInputVDetail,isFromAccessory){	
    var fileSize=getFileSize();

	if(parseFloat(fileSize)>parseFloat(<%=maxOfficeDocFileSize%>)){
		alert("<%=SystemEnv.getHtmlLabelName(24028,languageId)%>"+fileSize+"M，<%=SystemEnv.getHtmlLabelName(24029,languageId)%><%=maxOfficeDocFileSize%>M！");
		return false;
	}

  //document.getElementById("WebOffice").FileName=weaver.docsubject.value+"<%=filetype%>";
  //document.getElementById("WebOffice").FileName=document.getElementById("docsubject").value;
  document.getElementById("WebOffice").WebSetMsgByName("SAVETYPE","NEWVERSION");
  document.getElementById("WebOffice").WebSetMsgByName("HASUSEDTEMPLET", document.getElementById("hasUsedTemplet").value);
  if(isFromAccessory) {
	 document.getElementById("WebOffice").WebSetMsgByName("NONEWVERSION","TRUE");
  }

<%
if (!ifVersion.equals("1")) {
%>
  if(isprompt == 1){
	var vDetail = notInputVDetail ? "<%=SystemEnv.getHtmlLabelName(28121,languageId)%>" : "";
	if(!notInputVDetail) {
		vDetail = prompt("<%=SystemEnv.getHtmlLabelName(19721,languageId)%>","");
		if(vDetail==null){
			return false;
		}
	}
  }
<%
}else{
%>
	var vDetail="<%=user.getUsername()%>"+"<%=TimeUtil.getCurrentDateString()%>"+" "+"<%=TimeUtil.getOnlyCurrentTimeString()%>"+"<%=SystemEnv.getHtmlLabelName(18805,languageId)%>“"+"<%=nodeName%>"+"”<%=SystemEnv.getHtmlLabelName(15586,languageId)%>"+"<%=SystemEnv.getHtmlLabelName(21706,languageId)%>";
<%
}
%>
  document.getElementById("WebOffice").WebSetMsgByName("VERSIONDETAIL", vDetail);

  //增加提示信息  开始
  showPrompt("<%=SystemEnv.getHtmlLabelName(18886,languageId)%>");
  //增加提示信息  结束

    document.getElementById("WebOffice").FileType=changeFileType(document.getElementById("WebOffice").FileType);

<%
	if(!isFromAccessory){
%>
    var tempFileName=document.getElementById("docsubject").value;
<%
	}else{
	    String imageFileNameNoPostfix=fileName;
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
		postfixList.add(".et");			
		
		String tempPostfix=null;
		for(int i=0;i<postfixList.size();i++){
			tempPostfix=(String)postfixList.get(i)==null?"":(String)postfixList.get(i);			
		    if(imageFileNameNoPostfix.endsWith(tempPostfix)){
			    imageFileNameNoPostfix=imageFileNameNoPostfix.substring(0,imageFileNameNoPostfix.indexOf(tempPostfix));
	 	    }
		}
%>
    var tempFileName="<%=imageFileNameNoPostfix%>";
<%
	}
%>


	tempFileName=tempFileName.replace(/\\/g,'＼');
	tempFileName=tempFileName.replace(/\//g,'／');
	tempFileName=tempFileName.replace(/:/g,'：');
	tempFileName=tempFileName.replace(/\*/g,'×');
	tempFileName=tempFileName.replace(/\?/g,'？');
	tempFileName=tempFileName.replace(/\"/g,'“');
	tempFileName=tempFileName.replace(/</g,'＜');
	tempFileName=tempFileName.replace(/>/g,'＞');
	tempFileName=tempFileName.replace(/\|/g,'｜');
	tempFileName=tempFileName.replace(/\./g,'．');

	tempFileName = tempFileName+document.getElementById("WebOffice").FileType;

    document.getElementById("WebOffice").FileName=tempFileName;

<%if(isIWebOffice2003&&filetype.equals(".doc")){%>
	try{
		var fileSize=0;
		document.getElementById("WebOffice").WebObject.SaveAs();
		fileSize=document.getElementById("WebOffice").WebObject.BuiltinDocumentProperties(22);
		document.getElementById("WebOffice").WebSetMsgByName("NEWFS",fileSize);
	}catch(e){
	}
<%}%>

  if (!document.getElementById("WebOffice").WebSave(<%=isNoComment%>)){
     StatusMsg(document.getElementById("WebOffice").Status);
     alert("<%=SystemEnv.getHtmlLabelName(19007,languageId)%>");

     //增加提示信息  开始
     hiddenPrompt();
     //增加提示信息  结束
     return false;
  }else{
     StatusMsg(document.getElementById("WebOffice").Status);
     //alert(document.getElementById("WebOffice").WebGetMsgByName("CREATEID"));
     //weaver.docId.value=document.getElementById("WebOffice").WebGetMsgByName("CREATEID");
     //weaver.docType.value=document.getElementById("WebOffice").WebGetMsgByName("DOCTYPE");
     //alert(weaver.docId.value);
     //alert(weaver.docType.value);

     //增加提示信息  开始
     hiddenPrompt();
     //增加提示信息  结束

     <%
		if(operationtype ==0){
	 %>
 //return true;
     return onSavePDF();
	<%}else{%>
    return true;
	<%}%>
 

  }
}


var  attachNum=0;
var attachCount=0;
//签章类型
var signatureType = '<%=signatureType%>';

function  onSavePDF(){
	var noSavePDF=document.getElementById("noSavePDF").value;
	if("TRUE"==noSavePDF){
		document.getElementById("noSavePDF").value="";
		return true;
	}
<%
if(attachmentList==null||attachmentList.size()==0){
%>
	return onSavePDFOfText();
<%
}else{
%>
	attachNum=<%=attachmentList.size()%>;
<%
	int docId_Attach=0;
    int imageFileId_Attach=0;
	int versionId_Attach=0;
	Map attachmentMap=null;
	for(int i=0;i<attachmentList.size();i++){
		attachmentMap=(Map)attachmentList.get(i);
		docId_Attach=Util.getIntValue((String)attachmentMap.get("docId"));
		imageFileId_Attach=Util.getIntValue((String)attachmentMap.get("imageFileId"));
		versionId_Attach=Util.getIntValue((String)attachmentMap.get("versionId"));
%>
		onSavePDFOfAttach(<%=docId_Attach%>,<%=imageFileId_Attach%>,<%=versionId_Attach%>);
<%}%>
	var intervalCount=0;
	var timer=setInterval(function(){
		intervalCount=intervalCount+1;

		if((attachCount>=attachNum)||intervalCount>=300) {
					clearInterval(timer);
					
					if(onSavePDFOfText()){
						doDocSubmit();
						return true;
					}
				}
	},1000);
<%
}
%>
}
function doDocSubmit(){
			mybody.onbeforeunload=null;
	 <%
		if(operationtype ==0){
	 %>
     document.weaver.submit();
	<%}%>
   
 
			
			
}

//另存为PDF
function  onSavePDFOfText(){
	 var pdfDocId=0;
	   var DecryptpdfDocId=0;
<%
	if(isSavePDF||isSaveDecryptPDF){
%>
	    document.getElementById("WebOffice").WebSetMsgByName("requestid","<%=requestid%>");
	    document.getElementById("WebOffice").WebSetMsgByName("workflowid","<%=workflowid%>");
	    document.getElementById("WebOffice").WebSetMsgByName("docid","<%=docid%>");
		document.getElementById("WebOffice").WebSetMsgByName("currentnodeid","<%=currentnodeid%>");
		try{
			document.getElementById("WebOffice").WebObject.AcceptAllRevisions(); 
		}catch(e){
		}

<%
	}
	//另存为脱密PDF
	if(isSavePDF&&isSaveDecryptPDF){
		
%>	
		//同时存PDF和脱密PDF
		document.getElementById("WebOffice").WebSetMsgByName("savePdfAndDecryptPDF","1");
	    document.getElementById("WebOffice").WebSetMsgByName("savemethod","isSavePDF");
	
	    if(document.getElementById("WebOffice").WebSavePDF()){
			pdfDocId=document.getElementById("WebOffice").WebGetMsgByName("pdfDocId");
			var signatureCount=0;
			try{
				SetActiveDocument();  
				try{
					weaver.SignatureAPI.InitSignatureItems(); 
				}catch(e){}
				if("1" == signatureType){//WPS混合签章
					signatureCount = weaver.SignatureAPI.iSignatureCount();
				}else if("2" == signatureType){//360签章
					signatureCount = weaver.SignatureAPI.AllSignatureCount;
				}else{
					signatureCount=weaver.SignatureAPI.SignatureCount;
				}
			}catch(e){
			}
			if(signatureCount == undefined || signatureCount<=0){
				 <%if(operationtype ==1&&fromFlowDocsubm.equals("1")){%>
					window.parent.doctopdfandsubmitReturn(1,pdfDocId,DecryptpdfDocId);
				 <%}%>
				return true;
			}
			try{
				document.getElementById("SignatureAPI").UnLockDocument();
			}catch(e){}
			if("1" == signatureType){//WPS混合签章
				document.getElementById("SignatureAPI").iSignatureDecryption(1);
			}else if("2" == signatureType){//360签章
				for(var i=signatureCount-1;i>=0;i--){
					document.getElementById("SignatureAPI").DecryptSignature(i);
				}
			}else{
				document.getElementById("SignatureAPI").ShedCryptoDocument();
			}
			document.getElementById("WebOffice").WebSetMsgByName("savemethod","isSaveDecryptPDF");
			if(document.getElementById("WebOffice").WebSavePDF()){
				
				DecryptpdfDocId=document.getElementById("WebOffice").WebGetMsgByName("pdfDocId");
				 <%
		if(operationtype ==1&&fromFlowDocsubm.equals("1")){
	 %>
     window.parent.doctopdfandsubmitReturn(1,pdfDocId,DecryptpdfDocId);
	<%}%>
			   
				return true;
			}else{
				return confirmmethod();
			}
        }else{
			return confirmmethod();
		}
<%
	}else if(isSavePDF){
%>
	    document.getElementById("WebOffice").WebSetMsgByName("savemethod","isSavePDF");
	    if(document.getElementById("WebOffice").WebSavePDF()){
			
			  pdfDocId=document.getElementById("WebOffice").WebGetMsgByName("pdfDocId");	
			  <%if(operationtype ==1&&fromFlowDocsubm.equals("1")){%>
				window.parent.doctopdfandsubmitReturn(1,pdfDocId,DecryptpdfDocId);
			  <%}%>
	        return true;
        }else{
			return confirmmethod();
		}
<%
	}else if(isSaveDecryptPDF){
%>
			var signatureCount=0;
			try{
				SetActiveDocument(); 
				try{
					weaver.SignatureAPI.InitSignatureItems();  
				}catch(e){}
				if("1" == signatureType){//WPS混合签章
					signatureCount = weaver.SignatureAPI.iSignatureCount();
				}else if("2" == signatureType){//360签章
					signatureCount = weaver.SignatureAPI.AllSignatureCount;
				}else{
					signatureCount=weaver.SignatureAPI.SignatureCount;
				}
			}catch(e){
			}
			if(signatureCount == undefined || signatureCount<=0){
				 <%if(operationtype ==1&&fromFlowDocsubm.equals("1")){%>
					window.parent.doctopdfandsubmitReturn(1,pdfDocId,DecryptpdfDocId);
				 <%}%>
				return true;
			}			
			try{
				document.getElementById("SignatureAPI").UnLockDocument();
			}catch(e){}
			if("1" == signatureType){//WPS混合签章
				document.getElementById("SignatureAPI").iSignatureDecryption(1);
			}else if("2" == signatureType){//360签章
				for(var i=signatureCount-1;i>=0;i--){
					document.getElementById("SignatureAPI").DecryptSignature(i);
				}
			}else{
				document.getElementById("SignatureAPI").ShedCryptoDocument();
			}
			document.getElementById("WebOffice").WebSetMsgByName("savemethod","isSaveDecryptPDF");
			if(document.getElementById("WebOffice").WebSavePDF()){
				DecryptpdfDocId=document.getElementById("WebOffice").WebGetMsgByName("pdfDocId");
				<%if(operationtype ==1&&fromFlowDocsubm.equals("1")){ %>
					window.parent.doctopdfandsubmitReturn(1,pdfDocId,DecryptpdfDocId);
				<%}%>
				return true;
			}else{
				return confirmmethod();
			}
<%
	}else{
%>
 <%
		if(operationtype ==1&&fromFlowDocsubm.equals("1")){
	 %>
     window.parent.doctopdfandsubmitReturn(1,pdfDocId,DecryptpdfDocId);
	<%}%>      
return true;
<%
	}
%>
	
}


function  onSavePDFOfAttach(docId_Attach,imageFileId_Attach,versionId_Attach){
	var iframe2 = document.createElement('iframe');
	iframe2.id ="DocCheckInOutUtilIframe"+imageFileId_Attach;
	iframe2.name ="DocCheckInOutUtilIframe"+imageFileId_Attach;
	document.body.appendChild(iframe2); 
	iframe2.src="/docs/docs/OfficeToPDF.jsp?docId="+docId_Attach+"&imageFileId="+imageFileId_Attach+"&versionId="+versionId_Attach;

}

function  onSavePDFOfAttachReturn(){
	attachCount=attachCount+1;
	return true;
}

function confirmmethod(){
	if(confirm("<%=SystemEnv.getHtmlLabelName(125968 ,user.getLanguage())%>?")){
		return true;
	}else{
		return false;
	}
}


function onChanageShowMode(){
    if(DocInfoWindow.style.display == ""){
        DocInfoWindow.style.display = "none";

    }
    else{
        DocInfoWindow.style.display = "";
    }

}
function  initmenu(){
    document.getElementById("WebOffice").ShowMenu="1"; 

    <%
	//129673为新增标签需要导出sql
	//分离改造   19718替换为615	19719替换为220	19724替换为129673   去掉预览221		
    if (isPersonalDoc){%>
        document.getElementById("WebOffice").AppendMenu("1","<%=SystemEnv.getHtmlLabelName(615,languageId)%>(&S)");  //保存到服务器  onSave(this)   
		<%

		RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:webOfficeMenuClick(1),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		%>
  <%} else {%>
        document.getElementById("WebOffice").AppendMenu("2","<%=SystemEnv.getHtmlLabelName(615,languageId)%>(&S)");  //保存到服务器  onSave(this)
<%
		RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:webOfficeMenuClick(2),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;

        if(!docstatus.equals("3") && !docstatus.equals("4")&&!isFromAccessory) {
%>
		// if(!isFromAccessory) {
			<!-- [文件]草稿 -->
			document.getElementById("WebOffice").AppendMenu("3","<%=SystemEnv.getHtmlLabelName(220,languageId)%>");
		// }
		// if(isFromAccessory) {
			<!-- [文件]显示/隐藏痕迹 -->
			// document.getElementById("WebOffice").AppendMenu("71","<%=SystemEnv.getHtmlLabelName(16385,user.getLanguage())%>");
		// }
<%

			RCMenu += "{"+SystemEnv.getHtmlLabelName(220,user.getLanguage())+",javascript:webOfficeMenuClick(3),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;

		}
	if(isCleanCopyNodes){
%>
        document.getElementById("WebOffice").AppendMenu("101","<%=SystemEnv.getHtmlLabelName(129893,user.getLanguage())%>"); 
<%
		RCMenu += "{"+SystemEnv.getHtmlLabelName(129893,user.getLanguage())+",javascript:webOfficeMenuClick(101),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
%>
        //document.getElementById("WebOffice").AppendMenu("5","<%=SystemEnv.getHtmlLabelName(16386,languageId)%>");  //存为新版本  onSaveNewVersion(this)
        <%
		
        %>
		<%if(fromFlowDoc.equals("1") && isSignatureNodes){/*是否显示盖章*/%>
		  <%
	    	RCMenu += "{"+SystemEnv.getHtmlLabelName(21650,user.getLanguage())+",javascript:CreateSignature(0),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;

	    	RCMenu += "{"+SystemEnv.getHtmlLabelName(21656,user.getLanguage())+",javascript:saveIsignatureFun(),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
		  %>
        <%}%>  
        <%
        //if(((user.getUID()==ownerid)||(user.getUID()==doccreaterid))&&logintype.equals(usertype)&&canEdit){
        if(((user.getUID()==ownerid||user.getUID()==doccreaterid)&&logintype.equals(usertype)&&canEdit)||hasRightOfViewHisVersion){
		%>
            document.getElementById("WebOffice").AppendMenu("6","<%=SystemEnv.getHtmlLabelName(16384,languageId)%>");  //打开版本 openVersion("+versionId+")      
            <%
			/** 分离改造  只有编辑附件的时候才有打开版本**/
	    	RCMenu += "{"+SystemEnv.getHtmlLabelName(16384,user.getLanguage())+",javascript:webOfficeMenuClick(6),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
            %>
         <%}%>
<%
				  if(!isSignatureNodes){
					  if(".doc".equals(filetype) || ".wps".equals(filetype) || ".docx".equals(filetype)){
%>
             document.getElementById("WebOffice").AppendMenu("7","<%=SystemEnv.getHtmlLabelName(16385,languageId)%>");  //显示/隐藏痕迹 ShowRevision()  
            <%
	    	RCMenu += "{"+SystemEnv.getHtmlLabelName(16385,user.getLanguage())+",javascript:webOfficeMenuClick(7),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
            %>
<%
			
					  }
				  }
%>

			<%if(!fromFlowDoc.equals("1")){/*来自流程的文档一律不可打开本地文件*/%>
				 document.getElementById("WebOffice").AppendMenu("8","<%=SystemEnv.getHtmlLabelName(16381,languageId)%>");  //打开本地文件 WebOpenLocal() 
				<%
		    	RCMenu += "{"+SystemEnv.getHtmlLabelName(16381,user.getLanguage())+",javascript:webOfficeMenuClick(8),_top} " ;
				RCMenuHeight += RCMenuHeightStep ;
				%>
			<%}%>    
             document.getElementById("WebOffice").AppendMenu("9","<%=SystemEnv.getHtmlLabelName(16382,languageId)%>");  //存为本地文件 WebSaveLocal() 
            <%

        	RCMenu += "{"+SystemEnv.getHtmlLabelName(16382,user.getLanguage())+",javascript:webOfficeMenuClick(9),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
            %>
             document.getElementById("WebOffice").AppendMenu("10","<%=SystemEnv.getHtmlLabelName(16383,languageId)%>");  //签名印章 WebOpenSignature() 
            <%
        	RCMenu += "{"+SystemEnv.getHtmlLabelName(16383,user.getLanguage())+",javascript:webOfficeMenuClick(10),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
            %>
		<%/**分离改造  --去掉锁定拷贝和恢复拷贝%>
        <%if("1".equals(canCopy)&&!fromFlowDoc.equals("1")){%>
            // document.getElementById("WebOffice").AppendMenu("11","<%=SystemEnv.getHtmlLabelName(19722,languageId)%>");  //锁定拷贝 shiftCanCopy(this) 
            <%
        	RCMenu += "{"+SystemEnv.getHtmlLabelName(19722,user.getLanguage())+",javascript:webOfficeMenuClick(11),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
            %>
        <%}else if(!fromFlowDoc.equals("1")){%>
             // document.getElementById("WebOffice").AppendMenu("12","<%=SystemEnv.getHtmlLabelName(19723,languageId)%>");  //恢复拷贝 shiftCanCopy(this) 
             <%
         	RCMenu += "{"+SystemEnv.getHtmlLabelName(19723,user.getLanguage())+",javascript:webOfficeMenuClick(12),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
             %>
        <%}%>
		<%**/%>
		<%if(!fromFlowDoc.equals("1") || "0".equals(isCompellentMark)){/*来自流程的文档并且后台设置必须保存痕迹，则不可接受文档*/%>
           document.getElementById("WebOffice").AppendMenu("13","<%=SystemEnv.getHtmlLabelName(129673,languageId)%>");  //接受文档 acceptAll()
		  <%

      	RCMenu += "{"+SystemEnv.getHtmlLabelName(129673,user.getLanguage())+",javascript:webOfficeMenuClick(13),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		  %>
		<%}%>
<%
		  if(canPrintApply){
%>
            document.getElementById("WebOffice").AppendMenu("48","<%=SystemEnv.getHtmlLabelName(21530,languageId)%>");  //打印申请    onPrintApply
<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(21530,user.getLanguage())+",javascript:webOfficeMenuClick(48),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
		  }
		  if(canPrint){
%>
              document.getElementById("WebOffice").AppendMenu("47","<%=SystemEnv.getHtmlLabelName(257,languageId)%>");  //打印    onPrintDoc
              <%

  	    	RCMenu += "{"+SystemEnv.getHtmlLabelName(257,user.getLanguage())+",javascript:webOfficeMenuClick(47),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
    	    	/*RCMenu += "{"+SystemEnv.getHtmlLabelName(257,user.getLanguage())+",javascript:webOfficeMenuClick(47),_top} " ;
				RCMenuHeight += RCMenuHeightStep ;*/
		  }
		  if(isPrintControl.equals("1")){
%>
				document.getElementById("WebOffice").AppendMenu("49","<%=SystemEnv.getHtmlLabelName(21533,languageId)%>");  //打印    onPrintDoc
<%
				RCMenu += "{"+SystemEnv.getHtmlLabelName(21533,user.getLanguage())+",javascript:webOfficeMenuClick(49),_top} " ;
				RCMenuHeight += RCMenuHeightStep ;
		  }
		  if(fromFlowDoc.equals("1")){
			  RecordSet.executeProc("DocImageFile_SelectByDocid", "" + docid);
			  if(RecordSet.next()){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(58,user.getLanguage())+",javascript:doImgAcc(),_top} " ;
				RCMenuHeight += RCMenuHeightStep ;
			  }			  
		  }
%>
    <%}%>
        // document.getElementById("WebOffice").AppendMenu("14","-");  //---- 
        //document.getElementById("WebOffice").AppendMenu("15","<%=SystemEnv.getHtmlLabelName(19652,languageId)%>");   //显示/隐藏 
		//document.getElementById("WebOffice").AppendMenu("16","<%=SystemEnv.getHtmlLabelName(354,languageId)%>");   //刷新        
        <%/**分离改造  去掉刷新/返回%>
        <%if(!fromFlowDoc.equals("1")){%>
        // document.getElementById("WebOffice").AppendMenu("17","<%=SystemEnv.getHtmlLabelName(1290,languageId)%>");   //返回  
        <%}%>
        <%
        if(!fromFlowDoc.equals("1")){
    	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:webOfficeMenuClick(17),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
    	}
    	RCMenu += "{"+SystemEnv.getHtmlLabelName(354,user.getLanguage())+",javascript:webOfficeMenuClick(16),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
        %>
		<%**/%>
        // document.getElementById("WebOffice").AppendMenu("18","-");  //-------
		<%
		/** 分离改造
		RCMenu += "{"+SystemEnv.getHtmlLabelName(21689,user.getLanguage())+",javascript:webOfficeMenuClick(15),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		**/
		%>
}


<%
String doctitlename=null;
String webOfficeFileName=null;

if (isFromAccessory){
    doctitlename=fileName;
    webOfficeFileName=fileName;
}else{
    doctitlename=docsubject;
    webOfficeFileName=docsubject+filetype;
}

doctitlename=Util.StringReplace(doctitlename,"\\","\\\\");
doctitlename=Util.StringReplace(doctitlename,"&lt;","<");
doctitlename=Util.StringReplace(doctitlename,"&gt;",">");
doctitlename=Util.StringReplace(doctitlename,"&quot;","\"");
doctitlename=Util.StringReplace(doctitlename,""+'\n',"\n");
doctitlename=Util.StringReplace(doctitlename,""+'\r',"\r");
doctitlename=Util.StringReplace(doctitlename,"\"","\\\"");
doctitlename=Util.StringReplace(doctitlename,"&#8226;","·");

webOfficeFileName=Util.StringReplace(webOfficeFileName,"\\","\\\\");
webOfficeFileName=Util.StringReplace(webOfficeFileName,"&lt;","<");
webOfficeFileName=Util.StringReplace(webOfficeFileName,"&gt;",">");
webOfficeFileName=Util.StringReplace(webOfficeFileName,"&quot;","\"");
webOfficeFileName=Util.StringReplace(webOfficeFileName,""+'\n',"\n");
webOfficeFileName=Util.StringReplace(webOfficeFileName,""+'\r',"\r");
webOfficeFileName=Util.StringReplace(webOfficeFileName,"\"","\\\"");
webOfficeFileName=Util.StringReplace(webOfficeFileName,"&#8226;","·");
%>


function onLoad(){

    //增加提示信息  开始
    showPrompt("<%=SystemEnv.getHtmlLabelName(18974,languageId)%>");
    //增加提示信息  结束

	try{
		if(parent.jQuery("#loading")[0].style.display != "none"){
			document.getElementById('loading').style.display = "none";
		}
	}catch(e){}
	try{
		if(parent.parent.jQuery("#loading")[0].style.display != "none"){
			document.getElementById('loading').style.display = "none";
		}
	}catch(e){}
  try{
        document.body.scroll = "no";

        document.title="<%=doctitlename%>";
        document.getElementById("WebOffice").FileName="<%=webOfficeFileName%>";

        window.status="<%=SystemEnv.getHtmlLabelName(19725,languageId)%>";

        // 添加菜单
        initmenu();
      if ("<%=filetype%>"==".ppt"){
        document.getElementById("WebOffice").ProgName="powerpoint.show"; 
      } 
      document.getElementById("WebOffice").WebUrl="<%=mServerUrl%>";
      document.getElementById("WebOffice").RecordID="<%=(versionId==0?"":versionId+"")%>_<%=docid%>";
      document.getElementById("WebOffice").Template="";
	  try{
			document.getElementById("WebOffice").Compatible  = false;
      }catch(e){
      }
      document.getElementById("WebOffice").FileType="<%=filetype%>";
	<%
		String 	EditType_C="1";//C  "1" 是否显示痕迹		 "0" 不显示痕迹， "1" 显示痕迹
		if(isDefaultNoShowRevision){
			EditType_C="0";
		}
		String EditType_D="1";//C  "1" 是否显示痕迹		 "0" 不显示痕迹， "1" 显示痕迹
		if("0".equals(isCompellentMark)&&isDefaultNoShowRevision){
			EditType_D="0";
		}
	%>
	  <%if(isSignatureNodes&& fromFlowDoc.equals("1")){%>//是否取消审阅
      document.getElementById("WebOffice").EditType="-1,0,<%=EditType_C%>,<%=EditType_D%>,0,0,1<%=canPostil%>";
	  document.getElementById("WebOffice").DisableKey("CTRL+SHIFT+E");
	  <%}else if("1".equals(isCancelCheck) && "1".equals(isCompellentMark) && fromFlowDoc.equals("1")){%>//是否取消审阅
      document.getElementById("WebOffice").EditType="-1,0,<%=EditType_C%>,<%=EditType_D%>,0,0,1<%=canPostil%>";
	  document.getElementById("WebOffice").DisableKey("CTRL+SHIFT+E");
	  <%}else if("1".equals(isCancelCheck) && "0".equals(isCompellentMark) && fromFlowDoc.equals("1")){%>
	  document.getElementById("WebOffice").EditType="-1,0,<%=EditType_C%>,<%=EditType_D%>,0,0,1<%=canPostil%>";
	  <%}else if("0".equals(isCancelCheck) && "0".equals(isCompellentMark) && fromFlowDoc.equals("1")){%>
	  document.getElementById("WebOffice").EditType="-1,0,<%=EditType_C%>,<%=EditType_D%>,0,1,1<%=canPostil%>";
	  <%}else{%>
	  document.getElementById("WebOffice").EditType="-1,0,<%=EditType_C%>,<%=EditType_D%>,0,1,1<%=canPostil%>";
	  <%}%>
//alert(document.getElementById("WebOffice").EditType);
<%if("1".equals(isCancelCheck)){%>
      try{
		  var mStatus = document.getElementById("WebOffice").Office2007Ribbon; //获得当前Office2007是功能区的状态，如果取得结果为-1，表示没有安装Office2007
		  if(mStatus!=-1){
			  document.getElementById("WebOffice").RibbonUIXML = '<customUI xmlns="http://schemas.microsoft.com/office/2006/01/customui">' +
                                             '<ribbon startFromScratch="false">'+ //false时显示选项卡
                                             ' <tabs>'+
                                             ' <tab idMso="TabReviewWord" visible="false">' + //关闭审阅工具栏
                                             ' </tab>'+
                                             ' </tabs>' +
                                             '</ribbon>' +
                                             '</customUI>'; //以上为设置的XML的内容
		  }

	  }catch(e){
	  }
<%}%>
<%
        if(isIWebOffice2006 == true){
	        String penColor=DocHandwrittenManager.getPenColor(docid,doceditionid,user.getUsername());
%>
            document.getElementById("WebOffice").PenColor="<%=penColor%>";				//PenColor:默认批注颜色
<%
        }
%>

	  <%if(isIWebOffice2006 == true){%>
	      <%if((!isIWebOffice2009||"1".equals(isHandWriteForIWebOffice2009))&&!isSignatureNodes){%>
	            document.getElementById("WebOffice").ShowToolBar="1";      //ShowToolBar:是否显示工具栏:1显示,0不显示
		        document.getElementById("WebOffice").VisibleTools('<%=SystemEnv.getHtmlLabelName(18474,user.getLanguage())%>',false);
		        document.getElementById("WebOffice").VisibleTools('<%=SystemEnv.getHtmlLabelName(83412,user.getLanguage())%>',false);
		        document.getElementById("WebOffice").VisibleTools('<%=SystemEnv.getHtmlLabelName(83413,user.getLanguage())%>',false);
		        document.getElementById("WebOffice").VisibleTools('<%=SystemEnv.getHtmlLabelName(26096,user.getLanguage())%>',false);
		        document.getElementById("WebOffice").VisibleTools('<%=SystemEnv.getHtmlLabelName(83414,user.getLanguage())%>',false);
          <%}else{%>
	        	document.getElementById("WebOffice").ShowToolBar="0";      //ShowToolBar:是否显示工具栏:1显示,0不显示
	      <%}%>
	  <%}%>
      document.getElementById("WebOffice").MaxFileSize = <%=maxOfficeDocFileSize%> * 1024; 
      document.getElementById("WebOffice").UserName="<%=user.getUsername()%>";
      document.getElementById("WebOffice").WebSetMsgByName("USERID","<%=user.getUID()%>");
<%if(user.getLanguage()==7){%>
      document.getElementById("WebOffice").Language="CH";
<%}else if(user.getLanguage()==9){%>
      document.getElementById("WebOffice").Language="TW";
<%}else{%>
      document.getElementById("WebOffice").Language="EN";
<%}%>
<%if(RMMode){%>
      document.getElementById("WebOffice").RMMode = true;
<%}%>
<%if(filetype.equals(".xls")||filetype.equals(".xlsx")){%>
	    try{
			  document.getElementById("WebOffice").ShowStatus = true;
        }catch(e){
        }
<%}%>
      document.getElementById("WebOffice").WebOpen();  	//打开该文档
      //document.getElementById("WebOffice").WebShow(true);
<%if(filetype.equals(".doc")&&(editMouldId>0)&&(!fromFlowDocsubm.equals("1"))){%>
      var t_EditType = document.getElementById("WebOffice").EditType;
      document.getElementById("WebOffice").EditType = "-1,0,0,0,0,0,1<%=canPostil%>";
      document.getElementById("WebOffice").RecordID="<%=(versionId==0?"":versionId+"")%>_<%=docid%>";
      document.getElementById("WebOffice").WebSetMsgByName("ISEDITMOULD","TRUE");
      document.getElementById("WebOffice").WebSetMsgByName("EDITMOULDID","<%=editMouldId%>");
      document.getElementById("WebOffice").WebSetMsgByName("REQUESTID","<%=requestid%>");
      document.getElementById("WebOffice").WebSetMsgByName("WORKFLOWID","<%=workflowid%>");
      document.getElementById("WebOffice").WebSetMsgByName("LANGUAGEID","<%=languageId%>");
	  document.getElementById("WebOffice").WebSetMsgByName("SHOWDOCMOULDBOOKMARK","<%=fromFlowDoc%>");//载入是否显示“文档模板书签表”数据,这根据“是否来源于流程建文挡”来确定。
      document.getElementById("WebOffice").WebLoadBookMarks();//替换书签
      document.getElementById("WebOffice").RecordID="<%=(versionId==0?"":versionId+"")%>_<%=docid%>";
      document.getElementById("WebOffice").EditType = t_EditType;
<%}%>	  

      var signatureCount=0;
      try{
			SetActiveDocument();   //设置活动文档

			try{
				 weaver.SignatureAPI.InitSignatureItems();  //当签章数据发生变化时，请重新执行该方法
			}catch(e){}
			if("1" == signatureType){//WPS混合签章
				signatureCount = weaver.SignatureAPI.iSignatureCount();
			}else if("2" == signatureType){//360签章
				signatureCount = weaver.SignatureAPI.AllSignatureCount;
			}else{
				signatureCount=weaver.SignatureAPI.SignatureCount;
			}
	        if(signatureCount>=1){
	            document.getElementById("signatureCount").value=signatureCount;
	        }
      }catch(e){
      }
	  <%if(isIWebOffice2006 == true){%>
		//iWebOffice2006 特有内容开始
		  document.getElementById("WebOffice").ShowType="1";  //文档显示方式  1:表示文字批注  2:表示手写批注  0:表示文档核稿
		//iWebOffice2006 特有内容结束
		<%}%>  
      
//document.getElementById("WebOffice").DisableMenu("打印预览");
//document.getElementById("WebOffice").WebToolsEnable('Standard',109,false);

	     <%if(canPrint&&!"1".equals(isPrintControl)){%>
document.getElementById("WebOffice").WebToolsEnable('Standard',2521,true);
document.getElementById("WebOffice").DisableMenu("<%=SystemEnv.getHtmlLabelName(20757,user.getLanguage())%>");
document.getElementById("WebOffice").WebToolsEnable('Standard',109,false);
	     <%} else if(canPrint&&"1".equals(isPrintControl)){%>
document.getElementById("WebOffice").WebToolsEnable('Standard',2521,false);
document.getElementById("WebOffice").DisableMenu("<%=SystemEnv.getHtmlLabelName(20757,user.getLanguage())%>");
document.getElementById("WebOffice").DisableMenu("<%=SystemEnv.getHtmlLabelName(19850,user.getLanguage())%>");
document.getElementById("WebOffice").WebToolsEnable('Standard',109,false);
document.getElementById("WebOffice").WebToolsEnable('Standard',7226,false);
document.getElementById("WebOffice").WebToolsEnable('E-mail',2521,false);
WebToolsVisible('Reading Layout',false);
document.getElementById("WebOffice").DisableKey("F12,CTRL+P,CTRL+SHIFT+F12");
try{
    document.getElementById("WebOffice").Print="0"; 
}catch(e){
}
	     <%} else {%>
document.getElementById("WebOffice").WebToolsEnable('Standard',2521,false);
document.getElementById("WebOffice").DisableMenu("<%=SystemEnv.getHtmlLabelName(20757,user.getLanguage())%>");
document.getElementById("WebOffice").DisableMenu("<%=SystemEnv.getHtmlLabelName(26096,user.getLanguage())%>");
document.getElementById("WebOffice").DisableMenu("<%=SystemEnv.getHtmlLabelName(257,user.getLanguage())%>");
document.getElementById("WebOffice").WebToolsEnable('Standard',109,false);
document.getElementById("WebOffice").WebToolsEnable('Standard',7226,false);
document.getElementById("WebOffice").WebToolsEnable('E-mail',2521,false);
WebToolsVisible('Reading Layout',false);
document.getElementById("WebOffice").DisableKey("F12,CTRL+P,CTRL+SHIFT+F12");
try{
    document.getElementById("WebOffice").Print="0"; 
}catch(e){
}
		 <%}%>
	     <%if(canPrint&&!"1".equals(isPrintControl)){%>
document.getElementById("WebOffice").WebToolsEnable('Standard',2521,true);
document.getElementById("WebOffice").DisableMenu("<%=SystemEnv.getHtmlLabelName(20757,user.getLanguage())%>");
document.getElementById("WebOffice").WebToolsEnable('Standard',109,false);
	     <%} else if(canPrint&&"1".equals(isPrintControl)){%>
document.getElementById("WebOffice").WebToolsEnable('Standard',2521,false);
document.getElementById("WebOffice").DisableMenu("<%=SystemEnv.getHtmlLabelName(20757,user.getLanguage())%>");
document.getElementById("WebOffice").DisableMenu("<%=SystemEnv.getHtmlLabelName(19850,user.getLanguage())%>");
document.getElementById("WebOffice").WebToolsEnable('Standard',109,false);
document.getElementById("WebOffice").WebToolsEnable('Standard',7226,false);
document.getElementById("WebOffice").WebToolsEnable('E-mail',2521,false);
WebToolsVisible('Reading Layout',false);
document.getElementById("WebOffice").DisableKey("F12,CTRL+P,CTRL+SHIFT+F12");
try{
    document.getElementById("WebOffice").Print="0"; 
}catch(e){
}
	     <%} else {%>
document.getElementById("WebOffice").WebToolsEnable('Standard',2521,false);
document.getElementById("WebOffice").DisableMenu("<%=SystemEnv.getHtmlLabelName(20757,user.getLanguage())%>");
document.getElementById("WebOffice").DisableMenu("<%=SystemEnv.getHtmlLabelName(257,user.getLanguage())%>");
document.getElementById("WebOffice").DisableMenu("<%=SystemEnv.getHtmlLabelName(19850,user.getLanguage())%>");
document.getElementById("WebOffice").WebToolsEnable('Standard',109,false);
document.getElementById("WebOffice").WebToolsEnable('Standard',7226,false);
document.getElementById("WebOffice").WebToolsEnable('E-mail',2521,false);
WebToolsVisible('Reading Layout',false);
document.getElementById("WebOffice").DisableKey("F12,CTRL+P,CTRL+SHIFT+F12");
try{
    document.getElementById("WebOffice").Print="0"; 
}catch(e){
}
		 <%}%>

      StatusMsg(document.getElementById("WebOffice").Status);
  }catch(e){
      alert(e.description);
  }
     //增加提示信息  开始
     hiddenPrompt();
     //增加提示信息  结束
     
	//WebToolsEnable('Standard',109,true);StatusMsg('ok');
	
    try{
        saveDocCheckInOutTime();
    }catch(e){}
<%if("1".equals(isTextInForm)){%>
	document.getElementById("WebOffice").EditType ="0<%=canPostil%>";	
<%}%>    
	try{
	onshowdocmain(<%=(docpublishtype.equals("2"))?1:0%>);
	}catch(e){}
	setWebObjectSaved();//该行请放于onLoad方法最后一行chujun TD10961
}

function saveDocCheckInOutTime(){
<%
int refreshTime = Util.getIntValue(new BaseBean().getPropValue("docCheckoutChecktime","refreshTime"),0);
if(refreshTime <=0) refreshTime = 5;
%>
    try{                        
                    var url = 'DocCheckInOutUtilIframe.jsp?docid=<%=docid%>&operation=refreshCheckoutTime';
                    jQuery.ajax({
                        type: "POST",
                        url: "/docs/docs/DocCheckInOutUtilIframe.jsp",
                        data: {
                            docid: <%=docid%>,
                            userId: <%=userid%>,
                            operation: 'refreshCheckoutTime'
                        },
                        cache: false,
                        async:false,
                        dataType: 'json',
                        success: function(msg){
                        }
                    });     
    }catch(e){}
    setTimeout("saveDocCheckInOutTime()",<%=refreshTime%> * 60*1000);
}

function onLoadEnd(){
	 <%
		if(operationtype ==1&&fromFlowDocsubm.equals("1")){
	 %>
		 
     onSavePDF();
	 return;
	<%}%>
	
	try{
<%
	if(fromFlowDoc.equals("1")){
%>//是否显示盖章
		//document.getElementById("WebOffice").WebToolsVisible("iSignature",false);//隐藏盖章按钮
		WebToolsVisibleISignatureFalse();
<%
	    if(isIWebOffice2006 == true&&!isSignatureNodes){
%>
		    if(document.getElementById("WebOffice").Pages >=1){
				if(window.confirm('<%=SystemEnv.getHtmlLabelName(21680,languageId)%>')){
				    document.getElementById("WebOffice").ShowType="2";
				}								 
		    }
<%
	    }
        if(isSignatureNodes){
%>
		    if(window.confirm('<%=SystemEnv.getHtmlLabelName(21658,languageId)%>')){
	            CreateSignature(0);
	         }
<%
        }
	}
%>
	try{
	<%if(isDefaultNoShowRevision){%>
		try{
			//Ext.getCmp('hide_id').hide();
			document.getElementById('hide_id').style.display = "none";
		}catch(e){}
		try{
			//Ext.getCmp('dispaly_id').show();
			document.getElementById('dispaly_id').style.display = "block";
		}catch(e){}
	<%}else{%>								  
		try{
			//Ext.getCmp('hide_id').show();
			document.getElementById('hide_id').style.display = "block";
		}catch(e){}
		try{
			//Ext.getCmp('dispaly_id').hide();
			document.getElementById('dispaly_id').style.display = "none";
		}catch(e){}
	<%}%>
	}catch(e){}
  }catch(e){
  }
}

function onLoadAgain(){

      //document.getElementById("WebOffice").WebObject.Saved=true;//added by cyril on 2008-06-10 文档修改判断用
      setWebObjectSaved();

	  //document.getElementById("WebOffice").WebToolsVisible("iSignature",false);//隐藏盖章按钮
	  WebToolsVisibleISignatureFalse();

      //document.getElementById("WebOffice").DisableMenu("打印预览");
      //document.getElementById("WebOffice").WebToolsEnable('Standard',109,false);
	     <%if(canPrint&&!"1".equals(isPrintControl)){%>
document.getElementById("WebOffice").WebToolsEnable('Standard',2521,true);
document.getElementById("WebOffice").DisableMenu("<%=SystemEnv.getHtmlLabelName(20757,user.getLanguage())%>");
document.getElementById("WebOffice").WebToolsEnable('Standard',109,false);
	     <%} else if(canPrint&&"1".equals(isPrintControl)){%>
document.getElementById("WebOffice").WebToolsEnable('Standard',2521,false);
document.getElementById("WebOffice").DisableMenu("<%=SystemEnv.getHtmlLabelName(20757,user.getLanguage())%>");
document.getElementById("WebOffice").DisableMenu("<%=SystemEnv.getHtmlLabelName(19850,user.getLanguage())%>");
document.getElementById("WebOffice").WebToolsEnable('Standard',109,false);
document.getElementById("WebOffice").WebToolsEnable('Standard',7226,false);
document.getElementById("WebOffice").WebToolsEnable('E-mail',2521,false);
WebToolsVisible('Reading Layout',false);
document.getElementById("WebOffice").DisableKey("F12,CTRL+P,CTRL+SHIFT+F12");
try{
    document.getElementById("WebOffice").Print="0"; 
}catch(e){
}
	     <%} else {%>
document.getElementById("WebOffice").WebToolsEnable('Standard',2521,false);
document.getElementById("WebOffice").DisableMenu("<%=SystemEnv.getHtmlLabelName(20757,user.getLanguage())%>");
document.getElementById("WebOffice").DisableMenu("<%=SystemEnv.getHtmlLabelName(257,user.getLanguage())%>");
document.getElementById("WebOffice").DisableMenu("<%=SystemEnv.getHtmlLabelName(19850,user.getLanguage())%>");
document.getElementById("WebOffice").WebToolsEnable('Standard',109,false);
document.getElementById("WebOffice").WebToolsEnable('Standard',7226,false);
document.getElementById("WebOffice").WebToolsEnable('E-mail',2521,false);
WebToolsVisible('Reading Layout',false);
document.getElementById("WebOffice").DisableKey("F12,CTRL+P,CTRL+SHIFT+F12");
try{
    document.getElementById("WebOffice").Print="0"; 
}catch(e){
}
		 <%}%>
}

function onUnLoad(){
  try{
	  weaver.SignatureAPI.ReleaseActiveDocument();  //退出的时候释放活动文档，一定要执行
  }catch(e){
  }

  try{
	  docCheckIn(<%=docid%>);//签入刚签出的文档
  }catch(e){
  }

  try{
      if (!document.getElementById("WebOffice").WebClose()){
         StatusMsg(document.getElementById("WebOffice").Status);
      }else{
         StatusMsg("<%=SystemEnv.getHtmlLabelName(19716,languageId)%>...");
      }
  }catch(e){}
  return false;
}

function WebOpenSignature(){
  try{
    document.getElementById("WebOffice").WebOpenSignature();
    StatusMsg(document.getElementById("WebOffice").Status);
    return true;
  }catch(e){
      return false;
  }
}

function protectDoc(){
	//modified by cyril on 2008-06-10 for TD:8828
	try {
		document.getElementById(tagFlag+'namerepeated').value = document.getElementById('namerepeated').value;//namerepeated不检测
	}
	catch(e) {}
	var Modify = document.getElementById("WebOffice").WebObject.Saved;
	if(!Modify || !checkDataChange())
		event.returnValue="<%=SystemEnv.getHtmlLabelName(19006,languageId)%>";
}

   function wfchangetab(){
		try {
			document.getElementById(tagFlag+'namerepeated').value = document.getElementById('namerepeated').value;//namerepeated不检测
		}
		catch(e) {}
		var Modify = document.getElementById("WebOffice").WebObject.Saved;
    	if(!Modify || !checkDataChange()) {
    	  return true;
    	}else{
    	  return false;
    	}
    }

function shiftCanCopy(){
	if(check_form(document.weaver,getneedinputitems())){
<%
if (fromFlowDoc.equals("1")&&(docstatus.equals("2")||docstatus.equals("5"))) {
%>
        document.weaver.docstatus.value="<%=docstatus%>";
<%
}else{
%>
        document.weaver.docstatus.value=1;
<%
}
%>
        document.weaver.operation.value='editsave';
        if(SaveDocument()){
            mybody.onbeforeunload=null;

            //增加提示信息  开始
            showPrompt("<%=SystemEnv.getHtmlLabelName(18893,languageId)%>");
            //增加提示信息  结束

            document.weaver.cancopy.value="<%="1".equals(canCopy)?"0":"1"%>";
            document.weaver.submit();
        }
    }
}
function acceptAll(){
    document.getElementById("WebOffice").WebObject.Application.ActiveDocument.AcceptAllRevisions();
}

    function onPrintDoc(){
	    //document.getElementById("WebOffice").WebOpenPrint();
<%if(isPrintControl.equals("1")){%>
    if(document.getElementById("WebOffice").FileType==".doc"||document.getElementById("WebOffice").FileType==".docx"){	
	    WebCopysCtrlPrint();
    }else if(document.getElementById("WebOffice").FileType==".xls"||document.getElementById("WebOffice").FileType==".xlsx"){
   	    WebCopysCtrlPrintExcel();   //设置EXCEL对象
    }else{
		document.getElementById("WebOffice").WebOpenPrint();
	}
<%}else{%>		
		document.getElementById("WebOffice").WebOpenPrint();
<%}%>
    }

//打印份数控制
function WebCopysCtrlPrint(){
	var mCopies,objPrint;
    objPrint = document.getElementById("WebOffice").WebObject.Application.Dialogs(88);     //打印设置对话框
    if (objPrint.Display==-1){
        mCopies=objPrint.NumCopies;    //取得需要打印份数
        document.getElementById("WebOffice").WebSetMsgByName("COMMAND","COPIES");
        document.getElementById("WebOffice").WebSetMsgByName("OFFICEPRINTS",mCopies.toString());   //设置变量OFFICEPRINTS的值，在WebSendMessage()时，一起提交到OfficeServer中
        document.getElementById("WebOffice").WebSetMsgByName("DOCID","<%=docid%>");  
        document.getElementById("WebOffice").WebSetMsgByName("USERID","<%=userid%>");
        document.getElementById("WebOffice").WebSetMsgByName("CLIENTADDRESS","<%=request.getRemoteAddr()%>");		
        document.getElementById("WebOffice").WebSetMsgByName("HASPRINTNODE","<%=hasPrintNode%>");
        document.getElementById("WebOffice").WebSetMsgByName("ISPRINTNODE","<%=isPrintNode%>");			
        document.getElementById("WebOffice").WebSetMsgByName("CANPRINT","<%=canPrint%>");				
        document.getElementById("WebOffice").WebSendMessage();                               //交互OfficeServer的OPTION="SENDMESSAGE"       
        if (document.getElementById("WebOffice").Status=="1") {
            objPrint.Execute;
        }else{
            var maxPrints=document.getElementById("WebOffice").WebGetMsgByName("MAXPRINTS");			
            alert("<%=SystemEnv.getHtmlLabelName(21534 ,languageId)%>！<%=SystemEnv.getHtmlLabelName(21535 ,languageId)%>："+maxPrints);
            return false;
        }
    }
}

//打印份数控制   EXCEL
function WebCopysCtrlPrintExcel(){

	document.getElementById("WebOffice").WebOpenPrint();

}
    function onPrintApply(){
		//location.href='/workflow/request/AddRequest.jsp?workflowid=<%=printApplyWorkflowId%>&isagent=<%=isagentOfprintApply%>&docid=<%=docid%>' ;
		openFullWindow("/workflow/request/AddRequest.jsp?workflowid=<%=printApplyWorkflowId%>&isagent=<%=isagentOfprintApply%>&docid=<%=docid%>");
    }

    function onPrintLog(){
		//location.href='/docs/docs/DocPrintLog.jsp?docid=<%=docid%>' ;
		openFullWindow("/docs/docs/DocPrintLog.jsp?docid=<%=docid%>");
    }

    function setWebObjectSaved(){
		try{
			document.getElementById("WebOffice").WebObject.Saved=true;
		}catch(e){}
	}

    /**added by cyril on 2008-07-02 for TD:8921**/
	function protectDoc_include() {
		try {
			document.getElementById(tagFlag+'namerepeated').value = document.getElementById('namerepeated').value;//namerepeated不检测
		}
		catch(e) {}
		var Modify = document.getElementById("WebOffice").WebObject.Saved;
		if(!Modify || !checkDataChange()) {
			if(!confirm('<%=SystemEnv.getHtmlLabelName(19006,languageId)%>'))
				document.getElementById('onbeforeunload_protectDoc_return').value = 0;//检测不通过
			else 
				document.getElementById('onbeforeunload_protectDoc_return').value = 1;//检测通过
		}
	}
	/**end added by cyril on 2008-07-02 for TD:8921**/
</script>

</head>

<body class="ext-ie ext-ie8 x-border-layout-ct" id="mybody" scroll="no" onUnload="onUnLoad()" <%if(!fromFlowDocsubm.equals("1")){%>onbeforeunload="protectDoc()"<%}%> oncontextmenu="doNothing()">

<form id=weaver name=weaver action="UploadDoc.jsp?fromFlowDoc=<%=fromFlowDoc%>&workflowid=<%=workflowid%>" method=post enctype="multipart/form-data">
<!--该参数必须作为Form的第一个参数,并且不能在其他地方调用，用于解决在IE6.0中输入·这个特殊符号存在的问题-->
<INPUT TYPE="hidden" id="docIdErrorError" NAME="docIdErrorError" value="">

<iframe id="DocCheckInOutUtilIframe" frameborder=0 scrolling=no src=""  style="display:none"></iframe>

<%@ include file="/systeminfo/DocTopTitle.jsp"%>
<input type="hidden" name="onbeforeunload_protectDoc" onclick="protectDoc_include()"/>
<input type="hidden" name="onbeforeunload_protectDoc_return"/>

<%
int tmppos = doccontent.indexOf("!@#$%^&*");
if(tmppos!=-1){
	docmain = doccontent.substring(0,tmppos);
	doccontent = doccontent.substring(tmppos+8,doccontent.length());
}
%>


<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<input type=hidden name=cancopy value="<%=canCopy%>">
<input type=hidden name=docapprovable value="<%=needapprovecheck%>">
<input type=hidden name=isreply value="<%=isreply%>">
<input type=hidden name=replydocid value="<%=replydocid%>">
<input id="f_weaver_belongto_userid" name="f_weaver_belongto_userid" type="hidden" value="<%=f_weaver_belongto_userid%>">
<input id="f_weaver_belongto_usertype" name="f_weaver_belongto_usertype" type="hidden" value="<%=f_weaver_belongto_usertype%>">

<input type=hidden name=docreplyable value="<%=replyable%>">
<input type=hidden name=docstatus value="<%=docstatus%>">
<input type=hidden name=doccreaterid value="<%=doccreaterid%>">
<input type=hidden name=docCreaterType value="<%=docCreaterType%>">
<input type=hidden name=doccreatedate value="<%=doccreatedate%>">
<input type=hidden name=doccreatetime value="<%=doccreatetime%>">
<input type=hidden name=docapproveuserid value="<%=docapproveuserid%>">
<input type=hidden name=docapprovedate value="<%=docapprovedate%>">
<input type=hidden name=docapprovetime value="<%=docapprovetime%>">
<input type=hidden name=docarchiveuserid value="<%=docarchiveuserid%>">
<input type=hidden name=docarchivedate value="<%=docarchivedate%>">
<input type=hidden name=docarchivetime value="<%=docarchivetime%>">
<input type=hidden name=usertype value="<%=usertype%>">
<input type=hidden name="ownerid" value="<%=ownerid%>">
<input type=hidden name="oldownerid" value="<%=ownerid%>">
<input type=hidden name="ownerType" value="<%=ownerType%>">
<input type=hidden name="docdepartmentid" value="<%=docdepartmentid%>">
<input type=hidden name=doclangurage value="<%=doclangurage%>">
<input type=hidden name=replaydoccount value="<%=replaydoccount%>">

<input type=hidden name=from value="<%=from%>">
<input type=hidden name=userCategory  value="<%=userCategory%>">
<input type="hidden" name="userId" value="<%=user.getUID()%>">
<input type="hidden" name="userType" value="<%=user.getLogintype()%>">

<input type="hidden" name="doccode" value="<%=docCode%>">
<input type="hidden" name="docedition" value="<%=docedition%>">
<input type=hidden name=doceditionid value="<%=doceditionid%>">
<input type=hidden name=maincategory value="<%=(maincategory==-1?"":Integer.toString(maincategory))%>">
<input type=hidden name=subcategory value="<%=(subcategory==-1?"":Integer.toString(subcategory))%>">
<input type=hidden name=seccategory value="<%=(seccategory==-1?"":Integer.toString(seccategory))%>">

<input type=hidden name=maindoc id="maindoc" value="<%=maindoc%>">

<input type=hidden name=topage value='<%=topageFromOther%>'>

<input type=hidden name="requestid" value=<%=requestid%>>
<input type=hidden name="workflowid" value=<%=workflowid%>>
<input type=hidden id="versionDetail" name="versionDetail" value="" />

<input type=hidden name=isFromAccessory value='<%=isFromAccessory?1:0%>'>
<input type=hidden name=operation>
<input type=hidden name=id value="<%=docid%>">
<input type=hidden name=versionId value="<%=versionId%>">
<input type=hidden name=delimgid>
<input type=hidden id="hasUsedTemplet" name=hasUsedTemplet value="<%=hasUsedTemplet%>">
<input type=hidden id="noSavePDF" name="noSavePDF" value="">
<input type=hidden id="signatureCount" name="signatureCount" value="0">
<input type=hidden name="editMouldId" value="<%=editMouldId%>">

<input type="hidden" name="imageidsExt"  id="imageidsExt">
<input type="hidden" name="imagenamesExt"  id="imagenamesExt">

<input type=hidden name="deleteaccessory" value="">

<div style="position: absolute; left: 0; top: 0; width:100%;height:100%;">

<div id="divContentTab" style="width:100%;height:100%;">
	<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(("1").equals(fromFlowDoc)){ %>
				<%if( isSignatureNodes){ %>
					<input type=button class="e8_btn_top" onclick="CreateSignature(0);" value="<%=SystemEnv.getHtmlLabelName(21650, user.getLanguage())%>"></input>
					<input type=button class="e8_btn_top" onclick="saveIsignatureFun();" value="<%=SystemEnv.getHtmlLabelName(21656, user.getLanguage())%>"></input>
				<%}else{ %>
					<input type=button class="e8_btn_top" onclick="<%if (!ifVersion.equals("1")) {%> onSave(); <%} else {%>onSaveNewVersion();<%}%>" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
					<input type=button class="e8_btn_top" onclick="backToForm();" value="<%=SystemEnv.getHtmlLabelName(129071, user.getLanguage())%>"></input>
					<input type=button class="e8_btn_top" onclick="webOfficeMenuClick(7);" value="<%=SystemEnv.getHtmlLabelName(16385, user.getLanguage())%>"></input>
				<%} %>
				<%if(isCleanCopyNodes){%>
					<input type=button class="e8_btn_top" onclick="webOfficeMenuClick(101);" value="<%=SystemEnv.getHtmlLabelName(129893, user.getLanguage())%>"></input>
				<%}%>				
			<%}else{ %>
				<input type=button class="e8_btn_top" onclick="<%if (!ifVersion.equals("1")) {%> onSave(); <%} else {%>onSaveNewVersion();<%}%>" value="<%=SystemEnv.getHtmlLabelName(615, user.getLanguage())%>"></input>
			<%} %>
			<%if (!isPersonalDoc && !"1".equals(fromFlowDoc)&&!isFromAccessory){ %>
				<input type=button class="e8_btn_top" onclick="onDraft();" value="<%=SystemEnv.getHtmlLabelName(220, user.getLanguage())%>"></input>
			<!--	<input type=button class="e8_btn_top" onclick="onPreview();" value="<%=SystemEnv.getHtmlLabelName(221, user.getLanguage())%>"></input> 分离改造-->
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
	<jsp:include page="/systeminfo/commonTabHead.jsp">
	   <jsp:param name="mouldID" value="doc"/>
  	   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(19725,user.getLanguage()) %>"/>
	   <jsp:param name="exceptHeight" value="true"/>
	   <jsp:param name="isPersonalDoc" value="<%=isPersonalDoc %>"/>
	  <jsp:param name="docid" value="<%=docid %>"/>
	   <jsp:param name="_fromURL" value="doc"/>
	   <jsp:param name="fromFlowDoc" value="<%=fromFlowDoc %>"/>
	   <jsp:param name="isFromAccessory" value="<%=isFromAccessory%>" />
	   <jsp:param name="docsubject" value='<%=URLEncoder.encode(docsubject,"UTF-8") %>'/>
	   <jsp:param name="fileName" value='<%=URLEncoder.encode(fileName,"UTF-8")%>'/>
	 </jsp:include>
	<%-- 文档标题 start --%>
    	<script type="text/javascript">
				var isChecking = false;
				var prevValue = "";
				var checkCnt = 0;

				function docSubjectMouseDown(obj){
					if(event.button==1){
						checkDocSubject(obj)
					}
				}
				function checkDocSubject(obj,callback){
					if(obj!=null&&obj.value!=null&&""==obj.value){
						checkinput('docsubject','docsubjectspan');
						if(callback){
								callback();
							}
						return;
					}
					
					isChecking = true;  
					//var subject = encodeURIComponent(obj.value);	
					var subject = obj.value;							
					var url = 'DocSubjectCheck.jsp';
					var pars = 'subject='+subject+'&secid=<%=seccategory%>';
					//var myAjax = new Ajax.Request(url,{method: 'post', parameters: pars, onComplete: doCheckDocSubject});
					jQuery.ajax({
						url:url,
						type:"post",
						dataType:"json",
						beforeSend:function(){
							e8showAjaxTips("<%= SystemEnv.getHtmlLabelName(20204,user.getLanguage())%>",true);
						},
						complete:function(xhr){
							e8showAjaxTips("",false);
						},
						data:{
							subject:subject,
							secid:<%=seccategory%>,
							docid:<%=docid%>,
							f_weaver_belongto_userid:"<%=f_weaver_belongto_userid%>",
					        f_weaver_belongto_usertype:"<%=f_weaver_belongto_usertype%>"
						},
						success:function(data){
							if(parseInt(data.num)>0){
								jQuery("#docsubjectspan").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
								top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20073,user.getLanguage())%>");
								$GetEle("namerepeated").value = 1;
							} else {
								$GetEle("namerepeated").value = 0;
								checkinput('docsubject','docsubjectspan');
							}
							isChecking = false;
							if(callback){
								callback();
							}
						}
					});
				}
				function doCheckDocSubject(req){						
					var num = req.responseXML.getElementsByTagName('num')[0].firstChild.data;
					if(num>0){
						jQuery("#docsubjectspan").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"+
								" <div style='color:red;padding:8px 2px;width:310px;position:absolute;left:415px;top:6px;'><%=SystemEnv.getHtmlLabelName(20073,user.getLanguage())%></div>");
						$GetEle("namerepeated").value = 1;
					} else {
						$GetEle("namerepeated").value = 0;
						/** added by cyril on 2008-06-10 for TD:8828 ajax调用后再检查生成一遍校验值 **/
						if(checkCnt==0)
							createTags();
						checkCnt = 1;
						/** end by cyril on 2008-06-10 for TD:8828 **/
						checkinput('docsubject','docsubjectspan');
					}
					isChecking = false;
					//prevValue = $GetEle('docsubject').value;
				}
				function checkSubjectRepeated(){
					if(isChecking){
							alert("<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>");
							return;
					} else {
							if(1==$GetEle("namerepeated").value){
								alert("<%=SystemEnv.getHtmlLabelName(20073,user.getLanguage())%>");
								return;
							}
							return true;
					}
				}
			</script>
			<%
			needinputitems += ",docsubject";
			%>
	
	<%-- 文档标题 end --%>
	
	<input type="hidden" name="needinputitems" value="<%=needinputitems%>">
	<div id="divContent" style="width:100%;margin:0 auto;overflow:hidden;">

	<%-- iWebOffice编辑控件 start --%>
		<div id="divContentInfo" class="e8_propTab " style="width:100%;height:100%;">
		<iframe id="e8shadowifrm" name="e8shadowifrm" frameborder="none" scrolling="no" style="overflow:hidden;z-index:1;width:100%;height:23px;position:absolute;top:37px;visibility:hidden;left:0px;background-color:#fff;" src="javascript:return false;"></iframe>
		<table cellpadding="0" cellspacing="0" style="width:100%;height:100%;">
			<tr><td bgcolor=menu style="vertical-align:top;position:relative;">
			<div id="objectDiv">
				<div>
				<OBJECT id="WebOffice" classid="<%=mClassId%>" style="POSITION:absolute;width:0;height:0;<%if("1".equals(isTextInForm)){%>top:-120px<%}else{%>top:<%=fromFlowDoc.equals("1")?"-23px":"-23px" %><%}%>;" codebase="<%=mClientUrl%>" >
				</OBJECT>
				</div>
				<span id=StatusBar style="display:none">&nbsp;</span>
			</div>
			<%if(isSignatureNodes||showSignatureAPI){
				if("1".equals(signatureType)){%>					
					<OBJECT id=SignatureAPI classid="clsid:A0689619-3E99-4012-A83F-E902CF3505BD"  codebase="iSignatureWPS_APIP.ocx#version=<%=wps_version%>" 
					width=0 height=0 align=center hspace=0 vspace=0></OBJECT>
				<%}else if("2".equals(signatureType)){%>	
					<object id="SignatureAPI" width="0" height="0" classid="clsid:857F9703-BE32-4BD4-92A4-D8079C10BD41"></object>
				<%}else{%>	
                   <OBJECT id=SignatureAPI classid="clsid:79F9A6F8-7DBE-4098-A040-E6E0C3CF2001"  codebase="iSignatureAPI.ocx#version=5,0,2,0" width=0 height=0 align=center hspace=0 vspace=0></OBJECT>
				<%}}%>
			</td></tr>
		</table>
	</div>
	<%-- iWebOffice编辑控件 end --%>
	<%-- 基本属性 start --%>
	<div id="divProp" class="e8_propTab" style="display:none;width:100%;height:100%;">
		<DIV style="width 100%; height 100%; overflow: visible" class="x-panel-body x-panel-body-noheader x-panel-body-noborder">
			<jsp:include page="/docs/docs/DocEditExtBaseInfo.jsp">
				<jsp:param value="<%=userCategory%>" name="userCategory"/>
				<jsp:param value="<%=docid%>" name="docid"/>
				<jsp:param value="<%=imagefileId%>" name="imagefileId"/>
				<jsp:param value="<%=versionId%>" name="versionId"/>
				<jsp:param value="<%=isPersonalDoc%>" name="isPersonalDoc"/>
				<jsp:param value="<%=fromFlowDoc%>" name="fromFlowDoc"/>
			</jsp:include>
		</DIV>
	</div>
	<%-- 基本属性 end --%>
	<!-- 文档附件栏 start -->
	<div id="divAcc" class="e8_propTab" style="border:none;display:none;width:100%;height:100%;">
		<DIV style="border:none;width: 100%; height: 100%;overflow:visible" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
<%
			String sessionPara=""+docid+"_"+user.getUID()+"_"+user.getLogintype();
			session.setAttribute("right_edit_"+sessionPara,"1");
		    
%>
		<iframe id="e8DocAccIfrm" style="border:none;"  frameborder="0" width="100%" height="100%"></iframe>
		</DIV>
	</div>
	<!-- 文档附件栏 end -->
	<!-- 文档共享栏 start -->
	<div id="divShare" class="e8_propTab" style="border:none;display:none;width:100%;height:100%;">
		<DIV style="border:none;width: 100%; height: 100%;overflow:visible" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
		<iframe  id="shareListIfrm"  style="border:none;" frameborder="0" width="100%" height="100%"></iframe>
		</DIV>
	</div>
	<!-- 文档共享栏 end -->
	<% if(DocMark.isAllowMark(""+seccategory)){ %>
			<!-- 文档打分栏 start -->
		<div id="divMark" class="e8_propTab" style="display:none;width:100%;height:100%;">
			<DIV style="width:100%; height:100%; overflow: visible;border:none;" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
			<iframe id="markListIfrm" style="border:none;"  frameborder="0" width="100%" height="100%"></iframe>
			</DIV>
		</div>
			<!-- 文档打分栏 end -->
		<% } %>
	</div>
	
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  	
</div>
<!-- 底部选项卡栏 start -->
<%if(!isFromAccessory){%>
<div style="position:relative;">
	<div id="divTab" class="e8_weavertab" style="display:none;width:100%;position:relative;">

		<DIV style="WIDTH: 1278px" class="x-tab-panel-footer x-tab-panel-footer-noborder">
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
		
		<LI id=divShareATab class=" "  onclick="onActiveTab('divShare');">
		<A class=x-tab-strip-close onclick="return false;"></A>
		<A class=x-tab-right onclick="return false;" href="#">
		<EM class=x-tab-left>
		<SPAN class=x-tab-strip-inner><SPAN class="x-tab-strip-text "><script type="text/javascript">document.write(wmsg.doc.share);</script></SPAN></SPAN>
		</EM>
		</A>
		</LI>

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

</form>

</body>

</html>

<jsp:include page="/docs/docs/DocComponents.jsp">
	<jsp:param value="<%=user.getLanguage()%>" name="language"/>
	<jsp:param value="getBase" name="operation"/>
</jsp:include>

<script language="javascript" type="text/javascript">
var isFromWf=<%=("1").equals(fromFlowDoc)%>;
var docid="<%=docid%>";
var seccategory="<%=seccategory%>"; 
var docTitle="<%=docsubject%>";
var isReply="<%=isreply.equals("1")%>";
var doceditionid="<%=doceditionid%>";

var showType="view";
var coworkid="0";
var meetingid="0";

var requestid="<%=requestid%>";
var canViewLog=<%=false%>;
var canShare=<%=canShare%>;
var canEdit=<%=canEdit%>;
var canDownload=<%=canEdit%>;
var canDocMark=<%=DocMark.isAllowMark(""+seccategory)%>;	

var maxUploadImageSize="<%=maxUploadImageSize%>";

var isEditionOpen=<%=isEditionOpen%>;

function adjustContentHeight(type){
	var lang=<%=(user.getLanguage()==8)?"true":"false"%>;
	try{
		var propTabHeight = 34;
		if(document.getElementById("divPropTab")&&document.getElementById("divPropTab").style.display=="none") propTabHeight = (isFromWf)?10:34;
		<%if(isFromAccessory){%>
			if(propTabHeight==34){
				propTabHeight=0
			}
		<%}%>
		var pageHeight=document.body.clientHeight;
		var pageWidth=document.body.clientWidth;
		
		//document.getElementById("divContentTab").style.height = pageHeight - propTabHeight;
		if(isFromWf) propTabHeight += 25;
		jQuery("#divContentTab").height(pageHeight - propTabHeight);
		jQuery(".e8_box").height(pageHeight - propTabHeight);
		if(isFromWf) propTabHeight -= 50;
		jQuery(".tab_box").height(pageHeight - propTabHeight-jQuery(".e8_boxhead").height());
		var divContentHeight=jQuery(".tab_box").height()-15;
		<%if(isFromAccessory){%>
		 divContentHeight=jQuery(".tab_box").height();
		<%}%>
		if(isFromWf) divContentHeight += 25;

		var divContentWidth=pageWidth;
		if(divContentHeight!=null && divContentHeight>0){
			/*document.getElementById("divContent").style.height=divContentHeight;
			document.getElementById("divContent").style.width=divContentWidth;
			document.getElementById("WebOffice").style.height=divContentHeight + 23;
			document.getElementById("WebOffice").style.width=divContentWidth;*/
			jQuery("#divContent").height(divContentHeight);
			jQuery("#divContent").width(divContentWidth);
			<%if("1".equals(isTextInForm)){%>
				jQuery("#WebOffice").height(divContentHeight+96);
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

		onResizeDiv();
	} catch(e){
	}
}

function onAccessory(){	
	onExpandOrCollapse(true);
	onActiveTab("divAcc");
}
var lastTab = "divProp";
function onExpandOrCollapse(show,from){
	
	var flag = false;
	if(document.getElementById("divPropTab")&&document.getElementById("divPropTab").style.display=="none"||show) flag = true;
	var e8_shadow = jQuery("#e8_shadow");
	if(flag){
		e8_shadow.show();
		//document.getElementById("divPropTab").style.display = "block";
		//document.getElementById("divPropTabCollapsed").style.display = "none";
		if(document.getElementById("BUTTONbtn_ShowOrHidden")) document.getElementById("BUTTONbtn_ShowOrHidden").value=wmsg.base.hiddenProp;
		jQuery("#divTab #divPropTileIcon").removeClass("x-tool-expand-south").addClass("x-tool-collapse-south-over ");
		if(!from){
			onActiveTab(lastTab);
		}
	}else{
		e8_shadow.hide();
		document.getElementById("divPropTab").style.display = "none";
		//document.getElementById("divPropTabCollapsed").style.display = "block";
		if(document.getElementById("BUTTONbtn_ShowOrHidden")) document.getElementById("BUTTONbtn_ShowOrHidden").value=wmsg.base.showProp;
		jQuery("#divTab #divPropTileIcon").removeClass("x-tool-collapse-south-over").addClass("x-tool-expand-south");
		jQuery("#divTab li.x-tab-strip-active").removeClass("x-tab-strip-active");
	}
	adjustContentHeight();
	try {
		loadExt();
	} catch(e){}
}
<%
    String accUrl="/docs/docs/DocAcc.jsp?canDownload=true&canDel=true&bacthDownloadFlag="+bacthDownloadFlag+"&docid="+docid+"&mode=edit&pagename=docedit&isFromWf=false&operation=getDivAcc&maxUploadImageSize="+maxUploadImageSize+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
    String shareUrl="/docs/docs/DocShareGetNew.jsp?id="+docid+"&mode=edit&pagename=docedit&canShare="+canShare+"&operation=getDivShare";
    String docmarkUrl="/docs/docmark/DocMarkAdd.jsp?language="+user.getLanguage()+"&docId="+docid+"&mode=view&pagename=docdsp&secId="+seccategory+"&operation=getDivMark&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype; 	
%>

var has_e8DocAccIfrm=0;
var has_shareListIfrm=0;
var has_markListIfrm=0;

function onActiveTab(tab,notOpen){
	lastTab = tab;
	document.getElementById("divProp").style.display='none';
	document.getElementById("divAcc").style.display='none';
	document.getElementById("divShare").style.display='none';
	document.getElementById("divContentInfo").style.display='none';
	<% if(DocMark.isAllowMark(""+seccategory)){ %>
	document.getElementById("divMark").style.display='none';
	<% } %>
	document.getElementById("divPropATab").className = "";
	document.getElementById("divAccATab").className = "";
	document.getElementById("divShareATab").className = "";
	<% if(DocMark.isAllowMark(""+seccategory)){ %>
	document.getElementById("divMarkATab").className="";
	<% } %>
	document.getElementById("divContentInfoATab").className = "";
	if(tab=="divAcc"&&has_e8DocAccIfrm==0){
		has_e8DocAccIfrm=1;
		document.getElementById("e8DocAccIfrm").src="<%=accUrl%>";
	}
	if(tab=="divShare"&&has_shareListIfrm==0){
		has_shareListIfrm=1;
		document.getElementById("shareListIfrm").src="<%=shareUrl%>";
	}
	if(tab=="divMark"&&has_markListIfrm==0){
		has_markListIfrm=1;
		document.getElementById("markListIfrm").src="<%=docmarkUrl%>";
	}
	var e8_shadow = jQuery("#e8_shadow");
	if(!notOpen){
		document.getElementById(tab).style.display='block';
		document.getElementById(tab+"ATab").className='x-tab-strip-active';
		setE8ShadowPosition(tab);
	}else{
		e8_shadow.hide();
	}
	try {
		if(!notOpen){
			onExpandOrCollapse(true,true);
		}
		loadExt();
		//eval("doGet"+tab+"();");
		onResizeDiv();
	} catch(e){console.log(e);}
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
	else if(document.getElementById("divShare").style.display!='none')
		resizedivShare();
	<% if(DocMark.isAllowMark(""+seccategory)){ %>
	else if(document.getElementById("divMark").style.display!='none')
		resizedivMark();
	<% } %>
}

function getneedinputitems(){
	var allneedinputitems = document.getElementsByName("needinputitems");
	var needinputitemsstr = "";
	if(allneedinputitems&&allneedinputitems.length)
	for(var i=0;i<allneedinputitems.length;i++)
	if(allneedinputitems[i]&&allneedinputitems[i].value) needinputitemsstr += ","+allneedinputitems[i].value;
	return needinputitemsstr;
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
			
			//document.getElementById('rightMenu').style.visibility="hidden";
			document.getElementById("divMenu").style.display='';	
		} catch(e){}

		adjustContentHeight("load");

		finalDo("edit");
		createTags();// by cyril on 2008-08-14 for td:9077

		try{	
			onLoadEnd();
		} catch(e){}

<%if(!docsubject.equals("")&&!isPersonalDoc){%>
		try{
			checkDocSubject($GetEle("docsubject"));
		} catch(e){}
<%}%>
	}   
);
</script>
<jsp:include page="/docs/docs/DocEditExtScript.jsp">
    <jsp:param name="docid" value="<%=docid%>" />
    <jsp:param name="fromFlowDoc" value="<%=fromFlowDoc%>" />
    <jsp:param name="isIWebOffice2006" value="<%=(isIWebOffice2006?1:0)%>" />
    <jsp:param name="requestid" value="<%=requestid%>" />
    <jsp:param name="docstatus" value="<%=docstatus%>" />
	<jsp:param name="ifVersion" value="<%=ifVersion%>" />
	<jsp:param name="isCompellentMark" value="<%=isCompellentMark%>" />
	<jsp:param name="canPostil" value="<%=canPostil%>" />
	<jsp:param name="nodeid" value="<%=nodeid%>" />
	<jsp:param name="isFromAccessory" value="<%=isFromAccessory%>" />
	<jsp:param name="topageFromOther" value="<%=URLEncoder.encode(topageFromOther)%>" />
	<jsp:param name="currentnodeid" value="<%=currentnodeid%>" />	
</jsp:include>

<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
