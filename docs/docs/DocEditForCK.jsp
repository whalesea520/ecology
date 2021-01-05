
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager,
                 java.net.*" %>
<%@ page import="weaver.docs.category.security.AclManager " %>
<%@ page import="weaver.docs.category.* " %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.general.DesUtil"%>	

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
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
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="Record" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="DocUserSelfUtil" class="weaver.docs.docs.DocUserSelfUtil" scope="page"/>
<jsp:useBean id="DocDsp" class="weaver.docs.docs.DocDsp" scope="page"/>
<jsp:useBean id="DocDwrUtil" class="weaver.docs.docs.DocDwrUtil" scope="page"/>

<jsp:useBean id="SpopForDoc" class="weaver.splitepage.operate.SpopForDoc" scope="page"/>
<jsp:useBean id="DocUtil" class="weaver.docs.docs.DocUtil" scope="page" />

<jsp:useBean id="SecCategoryMouldComInfo" class="weaver.docs.category.SecCategoryMouldComInfo" scope="page"/>
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page"/>
<jsp:useBean id="DocCoder" class="weaver.docs.docs.DocCoder" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="DocMouldComInfo" class="weaver.docs.mould.DocMouldComInfo" scope="page" />
<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<jsp:useBean id="DocMark" class="weaver.docs.docmark.DocMark" scope="page" />
<jsp:useBean id="rsDummyDoc" class="weaver.conn.RecordSet" scope="page"/> 
<jsp:useBean id="DocDetailLog" class="weaver.docs.DocDetailLog" scope="page"/>
<jsp:useBean id="ResourceConditionManager" class="weaver.workflow.request.ResourceConditionManager" scope="page"/>
<%
//判断新建的是不是个人文档
boolean isPersonalDoc = false ;
String from =  Util.null2String(request.getParameter("from"));
//System.out.println("from is "+from);
int userCategory= Util.getIntValue(request.getParameter("userCategory"),0);
if ("personalDoc".equals(from)){
    isPersonalDoc = true ;
}
String f_weaver_belongto_userid=Util.null2String(request.getParameter("f_weaver_belongto_userid"));
String f_weaver_belongto_usertype=Util.null2String(request.getParameter("f_weaver_belongto_usertype"));
HrmUserSettingComInfo userSetting=new HrmUserSettingComInfo();
String belongtoshow = userSetting.getBelongtoshowByUserId(user.getUID()+""); 
String belongtoids = user.getBelongtoids();
String account_type = user.getAccount_type();

int docid = Util.getIntValue(request.getParameter("id"),0);

DocManager.resetParameter();
DocManager.setId(docid);
DocManager.getDocInfoById();
int docType = DocManager.getDocType();
if(docType == 2){
    response.sendRedirect("DocEditExt.jsp?from="+from+"&userCategory="+userCategory+"&id="+docid+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype);
    return ;
}

DesUtil desUtilitem = new DesUtil();
String udesid=desUtilitem.encrypt(user.getUID()+"");
String utype=user.getLogintype();

%>
<%!
//toHtml2 :把 "&lt;"  转化为 "XXX" 和  "&gt;"  转化为 "YYY" 
private String toHtml2(String src){   
    String returnStr = "" ;
    returnStr = Util.StringReplace(src,"&lt;","XXX");
    returnStr = Util.StringReplace(returnStr,"&gt;","YYY");
    return returnStr ;
}
//TD.5290 对于某些如MS Office生成的格式复杂HTML文档源码进行过滤
private String filterStyle(String src) throws Exception {
    String returnStr = src;
    //returnStr = Util.replace(returnStr,"style=\".*\"","",0);
    //returnStr = Util.replace(returnStr,"<HTML\\s*.*>","<HTML>",0);
    returnStr = Util.replace(returnStr,"<HTML([^<])*","<HTML>",0);
	//19957 当html文档内容存在textarea对象时，显示会有问题
    returnStr = Util.StringReplace(returnStr,"<","&lt;");
    returnStr = Util.StringReplace(returnStr,">","&gt;");
    return returnStr;
}
%>
<script LANGUAGE="JavaScript">
<!--
//重载replace方法为replaceALl
function replace(string,text,by) {    
    var strLength = string.length, txtLength = text.length;
    if ((strLength == 0) || (txtLength == 0)) return string;

    var i = string.indexOf(text);
    if ((!i) && (text != string.substring(0,txtLength))) return string;
    if (i == -1) return string;

    var newstr = string.substring(0,i) + by;

    if (i+txtLength < strLength)
        newstr += replace(string.substring(i+txtLength,strLength),text,by);

    return newstr;
}

//fromHtml2 :把 "XXX"  转化为 "&lt;" 和  "YYY"  转化为 "&gt;"
function  fromHtml2(src1){	
    var returnStr = replace(src1,"XXX","&lt;");
    returnStr = replace(returnStr,"YYY","&gt;");
    return returnStr ;
    
}

//-->
</script>
<%
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



String subid=Util.null2String(request.getParameter("subid"));
int SecId=Util.getIntValue(Util.null2String(request.getParameter("SecId")),0);


int maxUploadImageSize = DocUtil.getMaxUploadImageSize2(docid);

String needinputitems = "";
//DocManager.resetParameter();
//DocManager.setId(docid);
//DocManager.getDocInfoById();
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


String doccode = DocManager.getDocCode();
int docedition = DocManager.getDocEdition();
int doceditionid = DocManager.getDocEditionId();
    
int selectedpubmouldid = DocManager.getSelectedPubMouldId();

String docCreaterType = DocManager.getDocCreaterType();//文档创建者类型（1:内部用户  2：外部用户）
String docLastModUserType = DocManager.getDocLastModUserType();//文档最后修改者类型（1:内部用户  2：外部用户）
String ownerType = DocManager.getOwnerType();//文档拥有者类型（1:内部用户  2：外部用户）
int canPrintedNum=DocManager.getCanPrintedNum();//可打印份数

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



// modify by dongping for td1227 start
//一篇文档共享给客户，并且将编辑权限放给客户，则当客户编辑这篇文档时，系统的日志记录是“系统管理员”修改的这篇文档。
String opreateType=user.getLogintype();

//end

//是否回复提醒
String canRemind=DocManager.getCanRemind();

DocManager.closeStatement();
String docmain = "";

if(ownerid==0) ownerid=user.getUID() ;
String owneridname=ResourceComInfo.getResourcename(ownerid+"");
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
    if(approvewfid.equals(""))  approvewfid="0";
    if(approvewfid.equals("0"))
        needapprovecheck="0";
    else
        needapprovecheck="1";

String readoptercanprint = Util.null2String(""+RecordSet.getString("readoptercanprint"));

/*现在把附件的添加从由文档管理员确定改成了由用户自定义的方式.*/
// String hasaccessory =Util.toScreen(RecordSet.getString("hasaccessory"),user.getLanguage());
// int accessorynum = Util.getIntValue(RecordSet.getString("accessorynum"),user.getLanguage());
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

boolean isEditionOpen = SecCategoryComInfo.isEditionOpen(seccategory);



/***************************权限判断**************************************************/
boolean  canReader = false;
boolean  canEdit = false;
boolean  canViewLog = false;
boolean canDel = false;
boolean canShare = false ;
String logintype = user.getLogintype() ;
String userid = "" +user.getUID() ;
String userSeclevel = user.getSeclevel();
String userType = ""+user.getType();
String userdepartment = ""+user.getUserDepartment();
String usersubcomany = ""+user.getUserSubCompany1();

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

//归档状态的文档不能被编辑
if(canEdit && (docstatus.equals("5"))){
    canEdit = false;
}

if(!canEdit)  {
    //response.sendRedirect("/notice/noright.jsp") ;
    //return ;
	if(canReader){
		response.sendRedirect("/docs/docs/DocDsp.jsp?id="+docid+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype) ;
		return ;		
	}else{
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
}


boolean blnRealViewLog=false;
if((SecCategoryComInfo.getLogviewtype(seccategory)==1&&user.getLoginid().equalsIgnoreCase("sysadmin"))||(SecCategoryComInfo.getLogviewtype(seccategory)==0)){
	blnRealViewLog=canViewLog;
}


String temStr="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";

//temStr+=SystemEnv.getHtmlLabelName(401,user.getLanguage())+":"+doccreatedate+" "+doccreatetime+" "+SystemEnv.getHtmlLabelName(623,user.getLanguage())+":"+Util.toScreen(ResourceComInfo.getResourcename(""+doccreaterid),user.getLanguage())+SystemEnv.getHtmlLabelName(103,user.getLanguage())+":"+doclastmoddate+" "+doclastmodtime+" "+SystemEnv.getHtmlLabelName(623,user.getLanguage())+":"+Util.toScreen(ResourceComInfo.getResourcename(""+doclastmoduserid),user.getLanguage());

if(doccreaterid>0){
	temStr+=SystemEnv.getHtmlLabelName(401,user.getLanguage())+":"+doccreatedate+" "+doccreatetime+" "+SystemEnv.getHtmlLabelName(623,user.getLanguage())+":"+ResourceComInfo.getClientDetailModifier(""+doccreaterid,docCreaterType,user.getLogintype());
}

if(doclastmoduserid>0){
	temStr+="&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(103,user.getLanguage())+":"+doclastmoddate+" "+doclastmodtime+" "+SystemEnv.getHtmlLabelName(623,user.getLanguage())+":"+ResourceComInfo.getClientDetailModifier(""+doclastmoduserid,docLastModUserType,user.getLogintype());
}

if(checkOutStatus!=null&&(checkOutStatus.equals("1")||checkOutStatus.equals("2"))&&!(checkOutUserId==user.getUID()&&checkOutUserType!=	null&&checkOutUserType.equals(user.getLogintype()))){



	String checkOutMessage=SystemEnv.getHtmlLabelName(19695,user.getLanguage())+SystemEnv.getHtmlLabelName(19690,user.getLanguage())+"："+checkOutUserName;

    //checkOutMessage=URLEncoder.encode(checkOutMessage);
	 checkOutMessage=URLEncoder.encode(URLEncoder.encode(checkOutMessage,"UTF-8"),"UTF-8");

    response.sendRedirect("DocDsp.jsp?id="+docid+"&checkOutMessage="+checkOutMessage+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype);
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

String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+docsubject;
String needfav ="1";
String needhelp ="";


int tmppos = doccontent.indexOf("!@#$%^&*");
if(tmppos!=-1){
	docmain = doccontent.substring(0,tmppos);
	doccontent = doccontent.substring(tmppos+8,doccontent.length());
}
%>

<html><head>
<title><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>:<%=docsubject %></title>
<link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script>
   var f_weaver_belongto_userid='<%=f_weaver_belongto_userid%>';
   var f_weaver_belongto_usertype='<%=f_weaver_belongto_usertype%>';
   window.top.udesid='<%=udesid%>';
   window.top.utype='<%=utype%>';
   window.top.imguploadurl="/docs/docs/DocImgUploadOnly.jsp?userid="+window.top.udesid+"&usertype="+window.top.utype+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
</script>   
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/css/ecology8/workflowsign_wev8.css" />
<!-- 
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/fckeditor_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt_wev8.js"></script>
 -->

 <!--引入ueditor相关文件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.config_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/js/doc/ueditor.all.min_wev8.js"> </script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>
<!--添加插件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/appdoc_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/appcrm_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/appproj_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/appwf_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/wordtohtml_wev8.js"></script>
<!--图片上传插件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/imgupload_wev8.js"></script>
<link type="text/css" href="/ueditor/ueditorextend_wev8.css" rel="stylesheet"></link>

<jsp:include page="/systeminfo/WeaverLangJS.jsp">
    <jsp:param name="languageId" value="<%=user.getLanguage()%>" />
</jsp:include>
<link type="text/css" href="/css/ecology8/crudoc_wev8.css" rel="stylesheet"></link>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>

<script LANGUAGE="javascript">

function onLoad(){
	/***@2007-08-24 modify by yeriwei! ***/
	//var lang=<%=(user.getLanguage()==8)?"true":"false"%>;
	//FCKEditorExt.initEditor('weaver','doccontent',lang);
  	//Element.hide($("_xTable"));
  //td4694
	//modified by hubo,2006-07-14
  //var msg =weaver.doccontent.innerText+" "; 
  //var msg = document.getElementById("divDocContent").innerHTML + " ";
  //document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML=fromHtml2(msg);//weaver.doccontent.innerText;

  try{
  onshowdocmain(<%=(docpublishtype.equals("2"))?1:0%>);
  }catch(e){}
}

function onUnLoad(){   
    try{
	    docCheckIn(<%=docid%>);//签入刚签出的文档
    }catch(e){
    	if(window.console){
    		console.log("onUnLoad::");
    		console.log(e);
    	}
    }
}

function onBtnSearchClick(){}

jQuery(document).ready(
	function(){
		try{
			onLoad();
		} catch(e){}
		
		try{
			jQuery("#divContentTab").show();
			jQuery("#divPropTab").hide();
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
			checkDocSubject($GetEle('docsubject'));
		} catch(e){}
<%}%>

	 jQuery("div#divTab").show();

	}   
);


</script>
<style type="text/css">
html, body {
  height: 100%;
  overflow: hidden;
}
.edui-editor{
  z-index:900 !important;
}
.fileupload:hover{
   background-color: #fff5d4;
   border: 1px solid #dcac6c;
}

.items td{
	border:none!important;
}
</style>
</head>
<body class="ext-ie ext-ie8 x-border-layout-ct" scroll="no" onLoad="onLoad()" onbeforeunload="if(checkChange(event)){onUnLoad();}" onunload="onUnLoad()">

<div name="doccontentcopy" id="doccontentcopy" style="display:none;width:100%;"><%=doccontent%></div>

<form id=weaver name=weaver action="UploadDoc.jsp" method=post enctype="multipart/form-data">
<%@ include file="/systeminfo/DocTopTitle.jsp"%>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
List menuBars = new ArrayList();
List menuBarsForWf = new ArrayList();

Map menuBarMap = new HashMap();
Map[] menuBarToolsMap = new HashMap[]{};

String strExtBar="";
//strExtBar="[";
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSave(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
//strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+"',iconCls: 'btn_save',handler: function(){onSave(this)}},";
menuBarMap = new HashMap();
menuBarMap.put("id", "btn_save");
menuBarMap.put("text",SystemEnv.getHtmlLabelName(615,user.getLanguage()));
menuBarMap.put("iconCls","btn_save");
menuBarMap.put("handler","onSave(this);");
//menuBars.add(menuBarMap);

if (!isPersonalDoc){
         if(!docstatus.equals("3") && !docstatus.equals("4")) {
            RCMenu += "{"+SystemEnv.getHtmlLabelName(220,user.getLanguage())+",javascript:onDraft(this),_top} " ;
            RCMenuHeight += RCMenuHeightStep ;
			//strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(220,user.getLanguage())+"',iconCls: 'btn_draft',handler: function(){onDraft(this)}},";
			menuBarMap = new HashMap();
			menuBarMap.put("id", "btn_draft");
			menuBarMap.put("text",SystemEnv.getHtmlLabelName(220,user.getLanguage()));
			menuBarMap.put("iconCls","btn_draft");
			menuBarMap.put("handler","onDraft(this);");
			//menuBars.add(menuBarMap);
           
        }
        

		
 } 
        
 
 menuBarMap = new HashMap();
 //menuBars.add(menuBarMap);

 menuBarMap = new HashMap();
 menuBarMap.put("text","<span id=spanProp>"+SystemEnv.getHtmlLabelName(21689,user.getLanguage())+"</span>");
 menuBarMap.put("iconCls","btn_ShowOrHidden");
 menuBarMap.put("id","btn_ShowOrHidden");
 menuBarMap.put("handler","onExpandOrCollapse();");
 //menuBars.add(menuBarMap);
%>
<!--button class=btn accessKey=4 onClick="addannexRow();"><u>4</u>-<%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%></button-->
<div id="divMenu" style="display:none">
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</div>
<input id="f_weaver_belongto_userid" name="f_weaver_belongto_userid" type="hidden" value="<%=f_weaver_belongto_userid%>">
<input id="f_weaver_belongto_usertype" name="f_weaver_belongto_usertype" type="hidden" value="<%=f_weaver_belongto_usertype%>">

<input type=hidden name=docapprovable value="<%=needapprovecheck%>">
<input type=hidden name=isreply value="<%=isreply%>">
<input type=hidden name=replydocid value="<%=replydocid%>">
<input type=hidden name=isSubmit>
<input type=hidden name=docreplyable value="<%=replyable%>">
<input type=hidden name=docstatus value="<%=docstatus%>">
<input type=hidden name=doccreaterid value="<%=doccreaterid%>">
<input type=hidden name=docCreaterType value="<%=docCreaterType%>">
<input type=hidden name=doccreatedate value="<%=doccreatedate%>">
<input type=hidden name=doccreatetime value="<%=doccreatetime%>">
<input type=hidden name=usertype value="<%=usertype%>"> 
<input type=hidden name=opreateType value="<%=opreateType%>">
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

<input type="hidden" class=InputStyle name="doccode" value="<%=doccode%>">
<input type="hidden" name="docedition" value="<%=docedition%>">
<input type=hidden name=doceditionid value="<%=doceditionid%>">
<input type=hidden name=maincategory value="<%=(maincategory==-1?"":Integer.toString(maincategory))%>">
<input type=hidden name=subcategory value="<%=(subcategory==-1?"":Integer.toString(subcategory))%>">
<input type=hidden name=seccategory value="<%=(seccategory==-1?"":Integer.toString(seccategory))%>">

<input type="hidden" name="maindoc" id="maindoc" value="<%=maindoc%>">

<input type=hidden name=operation>
<input type=hidden name=id value="<%=docid%>">
<input type=hidden name=delimgid>

<input type="hidden" name="imageidsExt"  id="imageidsExt">
<input type="hidden" name="imagenamesExt"  id="imagenamesExt">

<input type=hidden name="deleteaccessory" id="deleteaccessory" value="">

<div style="position: absolute; left: 0; top: 0; width:100%;height:100%;">

<div id="divContentTab" style="height:100%;width:100%;">
	<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="onSave(this);" value="<%=SystemEnv.getHtmlLabelName(615, user.getLanguage())%>"></input>
			<%if (!isPersonalDoc){ %>
				<input type=button class="e8_btn_top" onclick="onDraft(this);" value="<%=SystemEnv.getHtmlLabelName(220, user.getLanguage())%>"></input>
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

	</jsp:include>
	<%-- 文档标题 start --%>
    	<script type="text/javascript">
				var isChecking = false;
				//var prevValue = "";
				var checkCnt = 0;
				function getEvent() {
					if (window.ActiveXObject) {
						return window.event;// 如果是ie
					}
					func = getEvent.caller;
					while (func != null) {
						var arg0 = func.arguments[0];
						if (arg0) {
							if ((arg0.constructor == Event || arg0.constructor == MouseEvent)
									|| (typeof (arg0) == "object" && arg0.preventDefault && arg0.stopPropagation)) {
								return arg0;
							}
						}
						func = func.caller;
					}
					return null;
				}
				
				function docSubjectMouseDown(obj){
					var evt=getEvent();
					if(evt.button==0){
						checkDocSubject(obj);
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
					var pars = 'subject='+subject+'&secid=<%=seccategory%>&docid=<%=docid%>';
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
							if(callback)callback();
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
						$GetEle('namerepeated').value = 0;
						/** added by cyril on 2008-06-10 for TD:8828 ajax调用后再检查生成一遍校验值 **/
						if(checkCnt==0){
							createTags();
						}
						checkCnt = 1;
						/** end by cyril on 2008-06-10 for TD:8828 **/
						checkinput('docsubject','docsubjectspan');
					}
					isChecking = false;
					//prevValue = $GetEle('docsubject').value;
				}
				function checkSubjectRepeated(){
					if(isChecking){
							top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>");
							return;
					} else {
							if(1==$GetEle("namerepeated").value){
								top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20073,user.getLanguage())%>");
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
		
		<div id="divContent" style="width:100%;position: relative;margin:0 auto;">
			<div id="test"></div>
			<%-- HTML编辑控件 start --%>
			<div id="divContentInfo" class="e8_propTab " style="width:100%;height:100%;">
				<textarea name="doccontent" id="doccontent" style="width:100%;"></textarea>
			<%-- HTML编辑控件 end --%>
			</div>
			<%-- 基本属性 start --%>
			<div id="divProp" class="e8_propTab" style="display:none;width:100%;height:100%;">
				<DIV style="width 100%; height 100%; overflow: visible" class="x-panel-body x-panel-body-noheader x-panel-body-noborder">
					<%@ include file="/docs/docs/DocEditBaseInfo.jsp" %>
				</DIV>
			</div>
			<%-- 基本属性 end --%>
			<!-- 文档附件栏 start -->
			<div id="divAcc" class="e8_propTab" style="border:none;display:none;width:100%;height:100%;">
				<DIV style="border:none;width: 100%; height: 100%;overflow:visible" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
<%
			String sessionPara=""+docid+"_"+user.getUID()+"_"+user.getLogintype();
			session.setAttribute("right_edit_"+sessionPara,"1");

			String accUrl="/docs/docs/DocAcc.jsp?canDel=true&canDownload=true&docid="+docid+"&mode=edit&pagename=docedit&isFromWf=false&operation=getDivAcc&maxUploadImageSize="+maxUploadImageSize+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype; 
%>
				<iframe  id="e8DocAccIfrm" style="border:none;" src="<%= accUrl%>" frameborder="0" width="100%" height="100%"></iframe>
				</DIV>
			</div>
			<!-- 文档附件栏 end -->
			<!-- 文档共享栏 start -->
			<div id="divShare" class="e8_propTab" style="border:none;display:none;width:100%;height:100%;">
				<DIV style="border:none;width: 100%; height: 100%;overflow:visible" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
				<%String shareUrl="/docs/docs/DocShareGetNew.jsp?id="+docid+"&mode=edit&pagename=docedit&canShare="+canShare+"&operation=getDivShare&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype; %>
				<iframe src="<%= shareUrl%>" style="border:none;" frameborder="0" width="100%" height="100%"></iframe>
				</DIV>
			</div>
			<!-- 文档共享栏 end -->
			<% if(DocMark.isAllowMark(""+seccategory)){ %>
				<!-- 文档打分栏 start -->
				<div id="divMark" class="e8_propTab" style="border:none;display:none;width:100%;height:100%;">
					<DIV style="border:none;width: 100%; height: 100%;overflow:visible" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
					<jsp:include page="/docs/docs/DocComponents.jsp">
						<jsp:param value="edit" name="mode"/>
						<jsp:param value="docedit" name="pagename"/>
						<jsp:param value="<%=docid%>" name="docid"/>
						<jsp:param value="<%=seccategory%>" name="secid"/>
						<jsp:param value="getDivMark" name="operation"/>
						<jsp:param value="<%=f_weaver_belongto_usertype%>" name="f_weaver_belongto_usertype"/>
						<jsp:param value="<%=f_weaver_belongto_userid%>" name="f_weaver_belongto_userid"/>
					</jsp:include>
					</DIV>
				</div>
				<!-- 文档打分栏 end -->
			<% } %>
		</div>
		
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  	
</div>
<!-- 底部选项卡栏 start -->
	<div style="position:relative;z-index: 900;">
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
		
		<LI id=divAccATab class="e8_weavertab_li "  onclick="onActiveTab('divAcc');">
		<A class=x-tab-strip-close onclick="return false;"></A>
		<A class=x-tab-right onclick="return false;" href="#">
		<EM class=x-tab-left>
		<SPAN class=x-tab-strip-inner><SPAN class="x-tab-strip-text " id="divAccATabTitle">
		<%=  SystemEnv.getHtmlLabelName(31208,user.getLanguage())%>
		(<label id="accCount" style="font-weight:normal;"><%=accessorycount%></label>)
		</SPAN></SPAN>
		</EM>
		</A>
		</LI>
		
		<LI id=divShareATab class="e8_weavertab_li "  onclick="onActiveTab('divShare');">
		<A class=x-tab-strip-close onclick="return false;"></A>
		<A class=x-tab-right onclick="return false;" href="#">
		<EM class=x-tab-left>
		<SPAN class=x-tab-strip-inner><SPAN class="x-tab-strip-text "><script type="text/javascript">document.write(wmsg.doc.share);</script></SPAN></SPAN>
		</EM>
		</A>
		</LI>

		<% if(DocMark.isAllowMark(""+seccategory)){ %>
		<LI id=divMarkATab class="e8_weavertab_li "  onclick="onActiveTab('divMark');">
		<A class=x-tab-strip-close onclick="return false;"></A>
		<A class=x-tab-right onclick="return false;" href="#">
		<EM class=x-tab-left>
		<SPAN class=x-tab-strip-inner><SPAN class="x-tab-strip-text "><script type="text/javascript">document.write(wmsg.doc.mark);</script></SPAN></SPAN>
		</EM>
		</A>
		</LI>
		<% } %>

		<LI class=x-tab-edge></LI>
		<DIV class=x-clear></DIV></UL>
			<div style="border:1px solid red;color:#ffffff;background:#ff0000;height:16px;padding-left:5px;padding-right:5px;display:none;top:4px;left:300px;position:absolute;" id="newAccCount"></div>
		</DIV></DIV>
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

</form>
<%@ include file="uploader.jsp" %>
</body>

</html>

<jsp:include page="/docs/docs/DocComponents.jsp">
	<jsp:param value="<%=user.getLanguage()%>" name="language"/>
	<jsp:param value="getBase" name="operation"/>
    <jsp:param value="<%=f_weaver_belongto_usertype%>" name="f_weaver_belongto_usertype"/>
   <jsp:param value="<%=f_weaver_belongto_userid%>" name="f_weaver_belongto_userid"/>
</jsp:include>

<script language="javascript" type="text/javascript">
<%if(maxUploadImageSize>0){%>
jQuery(window).resize(function() {
    var fileuplod=jQuery(".fileupload");
	if(fileuplod.length>0){
	   var divcontentoffset=jQuery("#divContent").offset();
	  var offset=jQuery(".edui-for-attachment").find(".edui-button-body").offset();
       fileuplod.css("left",(offset.left-divcontentoffset.left)+"px");
	   fileuplod.css("top",(offset.top-divcontentoffset.top)+"px");
	}
});

jQuery(document).ready(function(){
	window.setTimeout(function(){
		bindAttachmentUpload();
	},500);
	
	function bindAttachmentUpload(){
		var cke_button_swfupload = jQuery(".edui-for-attachment").find(".edui-button-body");
		
		if(cke_button_swfupload.length>0){
           
			var offset=jQuery(".edui-for-attachment").find(".edui-button-body").offset();
			cke_button_swfupload.find(".edui-icon").css("background-image","url('')");
			var divcontentoffset=jQuery("#divContent").offset();
		    cke_button_swfupload=jQuery("<div title='<%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%>' class='fileupload' style='position:absolute;width:20px;height:20px;left:"+(offset.left-divcontentoffset.left)+"px;top:"+(offset.top-divcontentoffset.top)+"px;z-index:900;'></div>");
			jQuery("#divContent").append(cke_button_swfupload);
			cke_button_swfupload.css({
				"display":"inline-block",
				"background-image":"url(/wui/common/js/ckeditor/plugins/swfupload/swf_wev8.png)",
				"background-position":"50% 50%",
				"background-repeat":"no-repeat"
			});
            cke_button_swfupload.attr("docid","<%=docid%>");
			cke_button_swfupload.attr("mode","edit");
			cke_button_swfupload.attr("maxsize","<%=maxUploadImageSize%>");
			bindUploaderDiv(cke_button_swfupload,null,true);
		
		}else{
			window.setTimeout(function(){
				bindAttachmentUpload();
			},500);
		}
	}
});
<%}%>
var isFromWf=false;
var seccategory="<%=seccategory%>"; 

var docid="<%=docid%>";
var docTitle="<%=Util.encodeJS(docsubject)%>";
var isReply="<%=isreply.equals("1")%>";
var doceditionid="<%=doceditionid%>";

var showType="view";
var coworkid="0";
var meetingid="0";

var strExtBar="<%=strExtBar%>";
var menubar=eval(strExtBar);
var menubarForwf=[];

var canShare=<%=canShare%>;
var canEdit=<%=canEdit%>;
var canDownload=<%=canEdit%>;
var canViewLog=<%=false%>;
var canDocMark=<%=DocMark.isAllowMark(""+seccategory)%>;
var requestid="0";
var maxUploadImageSize="<%= DocUtil.getMaxUploadImageSize(seccategory)%>";
var ue;
var isEditionOpen=<%=isEditionOpen%>;
function adjustContentHeight(type){
	
	var lang=<%=(user.getLanguage()==8)?"true":"false"%>;
	try{
		var propTabHeight = 34;
		if(document.getElementById("divPropTab")&&document.getElementById("divPropTab").style.display=="none") propTabHeight = 34;
		
		var pageHeight=document.body.clientHeight;
		var pageWidth=document.body.clientWidth;
		//document.getElementById("divContentTab").style.height = pageHeight - propTabHeight;
		//var divContentHeight=pageHeight-propTabHeight-65;
		if(propTabHeight<=15){
			jQuery("#divContentTab").height(jQuery(".e8_box").height());
		}else{
			jQuery("#divContentTab").height(pageHeight - propTabHeight);
			jQuery(".e8_box").height(pageHeight - propTabHeight);
			jQuery(".tab_box").height(pageHeight - propTabHeight-jQuery(".e8_boxhead").height());
		}
		var divContentHeight=jQuery(".tab_box").height()-15;
		var divContentWidth=pageWidth;
		if(type=="load"){
			//document.getElementById("doccontent").style.height=divContentHeight;
			jQuery("#doccontent").height(divContentHeight);
			jQuery("#divContent").height(divContentHeight);
			//FCKEditorExt.initEditor('weaver','doccontent',lang);
			//var ckeditor = CKEDITOR.replace('doccontent',{height:divContentHeight-50,toolbar:'base'});
	    	//实例化插件
			 // ue = UE.getEditor('doccontent');
  if(~~maxUploadImageSize<=0){
    ue = UE.getEditor('doccontent',{toolbars: [[
            'fullscreen', 'source', '|',
            'bold', 'italic', 'underline', 'fontborder', 'strikethrough', '|', 'fontfamily', 'fontsize', 'forecolor', 'backcolor','|', 'insertorderedlist', 'insertunorderedlist',
            'lineheight',
            'indent','paragraph', '|',
            ,'justifyleft', 'justifycenter', 'justifyright', '|',
            'link', 'unlink', 'anchor', '|', 'imagenone', 'imageleft', 'imageright', 'imagecenter', '|',
            'insertimage', 'insertvideo', 'map', 'insertframe', 'background',
            'horizontal',  'spechars', '|',
            'inserttable' ,'|','cleardoc','removeformat', 'formatmatch','pasteplain', '|',
            'print', 'searchreplace', 'undo', 'redo'
        ]]});
  }else{
     ue = UE.getEditor('doccontent');
  }
			  ue.addListener( 'ready', function( editor ) {
				    ue.execCommand( 'focus' ); //编辑器家在完成后，让编辑器拿到焦点
                    ue.setContent(jQuery("#doccontentcopy").html());   
					jQuery("#doccontentcopy").remove();
					var editorheight=divContentHeight+15;
					var toolbarheight=jQuery(".edui-editor-toolbarbox");
					var contentareaheight=editorheight-toolbarheight.height();
					jQuery(".edui-editor-iframeholder").css("height",contentareaheight);	
					jQuery(".edui-editor").css("height",editorheight);
					
			  } );

		} else {			
			if(divContentHeight!=null && divContentHeight>0) {
				//FCKEditorExt.resize(divContentWidth,divContentHeight);	
				var editorheight=divContentHeight+15;
				var toolbarheight=jQuery(".edui-editor-toolbarbox");
				var contentareaheight=editorheight-toolbarheight.height();
				jQuery(".edui-editor-iframeholder").css("height",contentareaheight);	
				jQuery(".edui-editor").css("height",editorheight);					
			}
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
					if(window.console)console.log(e+"-->DocEditForCK.jsp-->adjustContentHeight");
				}
				<%
				}
			}
		}
		%>
		onResizeDiv();
	} catch(e){
		if(window.console)console.log(e+"-->DocEditForCK.jsp end-->adjustContentHeight");
	}
}

function switchEditMode(){
	ue.execCommand( 'source');
}

function onAccessory(){	
	onExpandOrCollapse(true);
	onActiveTab("divAcc");
}

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

var lastTab = "divProp";

function onActiveTab(tab,notOpen){
	lastTab = tab;
	if(tab=="divAcc"){
		jQuery("#newAccCount").hide();
	}
    
	//隐藏显示上传按钮
	if(tab==='divContentInfo'){
	   jQuery(".fileupload").show();
	   jQuery(".e8fileupload").show();
	}else{
	   jQuery(".fileupload").hide();
	   jQuery(".e8fileupload").hide();
	}

	document.getElementById("divProp").style.display='none';
	document.getElementById("divAcc").style.display='none';
	document.getElementById("divShare").style.display='none';
	document.getElementById("divContentInfo").style.display='none';
	var e8_shadow = jQuery("#e8_shadow");
	<% if(DocMark.isAllowMark(""+seccategory)){ %>
	document.getElementById("divMark").style.display='none';
	<% } %>
	document.getElementById("divPropATab").className = "";
	document.getElementById("divAccATab").className = "";
	document.getElementById("divShareATab").className = "";
	document.getElementById("divContentInfoATab").className = "";
	<% if(DocMark.isAllowMark(""+seccategory)){ %>
	document.getElementById("divMarkATab").className="";
	<% } %>
	
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
	else if(document.getElementById("divShare").style.display!='none')
		resizedivShare();
	<% if(DocMark.isAllowMark(""+seccategory)){ %>
	else if(document.getElementById("divMark").style.display!='none')
		resizedivMark();
	<% } %>
}

function disableToolBar(){
	<% 
	for(Iterator mbit = menuBars.iterator();mbit.hasNext();){
		menuBarMap = (Map)mbit.next();
		if(menuBarMap.size()>0) {
			String toolid = (String)menuBarMap.get("id");
			menuBarToolsMap = (Map[])menuBarMap.get("menu");
			if(menuBarToolsMap!=null&&menuBarToolsMap.length>0){
			%>
			if(documet.getElementById("BUTTON<%=toolid%>"))
				documet.getElementById("BUTTON<%=toolid%>").disabled = true;
			<%
			}
		}
	}
	%>
}

function enableToolBar(){
	<% 
	for(Iterator mbit = menuBars.iterator();mbit.hasNext();){
		menuBarMap = (Map)mbit.next();
		if(menuBarMap.size()>0) {
			String toolid = (String)menuBarMap.get("id");
			menuBarToolsMap = (Map[])menuBarMap.get("menu");
			if(menuBarToolsMap!=null&&menuBarToolsMap.length>0){
			%>
			if(documet.getElementById("BUTTON<%=toolid%>"))
				documet.getElementById("BUTTON<%=toolid%>").disabled = false;
			<%
			}
		}
	}
	%>
}
</script>
<%@ include file="DocEditForCKScript.jsp" %>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>