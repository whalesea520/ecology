<%@ page buffer="1024kb" autoFlush="false"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager,
                 java.net.*" %>
<%@ page import="weaver.docs.category.security.MultiAclManager " %>
<%@ page import="weaver.docs.category.* " %>
<%@ page import="java.util.*"%>
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
<jsp:useBean id="SecCategoryDocTypeComInfo" class="weaver.docs.category.SecCategoryDocTypeComInfo" scope="page" />
<jsp:useBean id="DocTypeComInfo" class="weaver.docs.type.DocTypeComInfo" scope="page" />
<jsp:useBean id="DocTypeManager" class="weaver.docs.type.DocTypeManager" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="MouldManager" class="weaver.docs.mouldfile.MouldManager" scope="page" />
<jsp:useBean id="DocMouldComInfo" class="weaver.docs.mouldfile.DocMouldComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetAcc" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="RecordSetEX" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="DocUserSelfUtil" class="weaver.docs.docs.DocUserSelfUtil" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="DocUtil" class="weaver.docs.docs.DocUtil" scope="page" />
<jsp:useBean id="ProjectTaskApprovalDetail" class="weaver.proj.Maint.ProjectTaskApprovalDetail" scope="page"/>
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>

<jsp:useBean id="SecCategoryMouldComInfo" class="weaver.docs.category.SecCategoryMouldComInfo" scope="page"/>
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page"/>
<jsp:useBean id="DocCoder" class="weaver.docs.docs.DocCoder" scope="page"/>

<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<jsp:useBean id="rsDummyDoc" class="weaver.conn.RecordSet" scope="page"/> 
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />

<html><head>
<%
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-cache");
response.setDateHeader("Expires",0);
DesUtil desUtilitem = new DesUtil();
String udesid=desUtilitem.encrypt(user.getUID()+"");
String utype=user.getLogintype();
String f_weaver_belongto_userid=Util.null2String(request.getParameter("f_weaver_belongto_userid"));
String f_weaver_belongto_usertype=Util.null2String(request.getParameter("f_weaver_belongto_usertype"));
session.setAttribute("f_weaver_belongto_userid_doc",f_weaver_belongto_userid);
session.setAttribute("f_weaver_belongto_usertype_doc",f_weaver_belongto_usertype);
%>
<link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" type="text/css" href="/css/ecology8/workflowsign_wev8.css" />
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/js/doc/DocAddScript_wev8.js"></script>

<script>
   var f_weaver_belongto_userid='<%=f_weaver_belongto_userid%>';
   var f_weaver_belongto_usertype='<%=f_weaver_belongto_usertype%>';
   window.top.udesid='<%=udesid%>';
   window.top.utype='<%=utype%>';
   window.top.imguploadurl="/docs/docs/DocImgUploadOnly.jsp?userid="+window.top.udesid+"&usertype="+window.top.utype;
</script>

<!--
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script>
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
<link type="text/css" href="/ueditor/ueditorextend_wev8.css" rel="stylesheet"></link>
<!--图片上传插件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/imgupload_wev8.js"></script>

<jsp:include page="/systeminfo/WeaverLangJS.jsp">
    <jsp:param name="languageId" value="<%=user.getLanguage()%>" />
</jsp:include>
<link type="text/css" href="/css/ecology8/crudoc_wev8.css" rel="stylesheet"></link>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
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
</style>
</head>
<%
//判断新建的是不是个人文档
boolean isPersonalDoc = false ;
String from =  Util.null2String(request.getParameter("from"));
int userCategory= Util.getIntValue(request.getParameter("userCategory"),0);
//System.out.println("userCategory is "+userCategory);
int shareparentid= Util.getIntValue(request.getParameter("shareparentid"),0);

if ("personalDoc".equals(from)){
    isPersonalDoc = true ;
}

String  docsubject=Util.null2String(request.getParameter("docsubject"));

//编辑：王金永
String  docType=Util.null2String(request.getParameter("docType"));
if(docType.equals("")){
    docType=".htm";
}
//out.println(docType);

/*added by hubo 050829*/
String isExpDiscussion = Util.null2String(request.getParameter("isExpDiscussion"));

String  prjid = Util.null2String(request.getParameter("prjid"));
String  crmid=Util.null2String(request.getParameter("crmid"));
String  hrmid=Util.null2String(request.getParameter("hrmid"));
String  coworkid = Util.null2String(request.getParameter("coworkid"));
String  showsubmit=Util.null2String(request.getParameter("showsubmit"));

String  topage=Util.null2String(request.getParameter("topage"));
String  tmptopage=URLEncoder.encode(topage);//专门用于页面直接导向
%>
<script>
   var prjid='<%=prjid%>';
   var coworkid='<%=coworkid%>';
   var crmid='<%=crmid%>';
   var hrmid='<%=hrmid%>';
</script>
<%
/*added by hubo 060226*/
if(!prjid.equals("")){
	docsubject = ProjectInfoComInfo.getProjectInfoname(prjid);
	String sqlProj = "SELECT proCode FROM Prj_ProjectInfo WHERE id="+prjid+"";
	RecordSet.executeSql(sqlProj);
	if(RecordSet.next()){
		docsubject += "("+RecordSet.getString("proCode")+")";
	}
}


String  sepStr="";
if(!showsubmit.equals("0"))  showsubmit="1";

String usertype = user.getLogintype();
int ownerid=user.getUID() ;
String owneridname=ResourceComInfo.getResourcename(ownerid+"");
int docdepartmentid=user.getUserDepartment() ;
String needinputitems = "";
if(!isPersonalDoc){
    //needinputitems += "maincatgory,subcategory,seccategory";
	 needinputitems += "seccategory";
}
MultiAclManager am = new MultiAclManager();

int secid=Util.getIntValue(Util.null2String(request.getParameter("secid")), -1);
if(secid==-1){
	secid = Util.getIntValue(Util.null2String(request.getParameter("seccategory")), -1);
}
int subid=Util.getIntValue(Util.null2String(request.getParameter("subid")), -1);
int mainid=Util.getIntValue(Util.null2String(request.getParameter("mainid")), -1);

int maxUploadImageSize = DocUtil.getMaxUploadImageSize(secid);

String isUseET=Util.null2String(BaseBean.getPropValue("weaver_obj","isUseET"));

if(isPersonalDoc) {
    int cannew = 0;
    if(userCategory<0){
        String sqlcheck = "select distinct t1.id  from HrmResource t1 ,  DocShare as t2,  HrmRoleMembers as t3 ";
        sqlcheck +="where  ( (t2.foralluser=1 )  ";
        sqlcheck +="or ( t2.userid= t1.id ) ";
        sqlcheck +="or (t2.departmentid=t1.departmentid )  ";
        sqlcheck +="or (t2.subcompanyid=t1.subcompanyid1 ) ";
        sqlcheck +="or ( t3.resourceid=t1.id and t3.roleid=t2.roleid ) ";
        sqlcheck +=" )  and t1.id <> 0 and t2.docid = ";
        sqlcheck += ((-1)*shareparentid);
        sqlcheck += " and t2.sharelevel=2 and  t1.id = "+user.getUID();
        if(shareparentid!=0){
            RecordSet.executeSql(sqlcheck);
            //out.print(sqlcheck);
            if(RecordSet.next())
                cannew = 1;
        }
    } else
        cannew = 1;

    if(cannew != 1){
        response.sendRedirect("/notice/noright.jsp") ;
            return;
    }
    secid = 0 ;
    subid = 0 ;
    mainid = 0 ;
}



if (secid == -1) {
    MultiCategoryTree tree = am.getPermittedTree(user.getUID(), user.getType(), Integer.parseInt(user.getSeclevel()), MultiAclManager.OPERATION_CREATEDOC);
    if (subid != -1) {
        CommonCategory cc = tree.findCategory(subid, MultiAclManager.CATEGORYTYPE_SUB);
        if (cc != null) {
            CommonCategory secCategory = null;
            while (secCategory == null && cc.children.size() > 0) {
                for (int i=0;i<cc.children.size();i++) {
                    if (cc.getChild(i).type == MultiAclManager.CATEGORYTYPE_SEC) {
                        secCategory = cc.getChild(i);
                        break;
                    }
                }
                if (secCategory == null && cc.children.size() > 0) {
                    cc = cc.getChild(0);
                }
            }
            if (secCategory != null) {
                secid = secCategory.id;
            }
        }
    } else if (mainid != -1) {
        CommonCategory cc = tree.findCategory(subid, MultiAclManager.CATEGORYTYPE_MAIN);
        if (cc != null) {
            CommonCategory secCategory = null;
            while (secCategory == null && cc.children.size() > 0) {
                for (int i=0;i<cc.children.size();i++) {
                    if (cc.getChild(i).type == MultiAclManager.CATEGORYTYPE_SEC) {
                        secCategory = cc.getChild(i);
                        break;
                    }
                }
                if (secCategory == null && cc.children.size() > 0) {
                    cc = cc.getChild(0);
                }
            }
            if (secCategory != null) {
                secid = secCategory.id;
            }
        }
    }
}
if (secid != -1) {
    subid = Util.getIntValue(SecCategoryComInfo.getSubCategoryid(""+secid), -1);
    mainid = Util.getIntValue(SubCategoryComInfo.getMainCategoryid(""+subid), -1);
}

String path = "";
if (secid != -1) {
    path = "/"+CategoryUtil.getCategoryPath(secid);
}

//String doctypeid=Util.null2String(request.getParameter("doctypeid"));
String docmodule=Util.null2String(request.getParameter("docmodule"));
//if(doctypeid.equals("")) doctypeid = "0";

boolean isTemporaryDoc = false;
String invalidationdate = Util.null2String(request.getParameter("invalidationdate"));
if(invalidationdate!=null&&!"".equals(invalidationdate))
    isTemporaryDoc = true;
    

String categoryname="";
String subcategoryid="";
String docmouldid="";
String publishable="";
String replyable="";
String shareable="";

String readoptercanprint="";
String editionisopen = "";
String norepeatedname = "";
String iscontroledbydir = "";
String puboperation = "";


//String docdefseclevel="";
// String docseclevel="";
//int docmaxseclevel=-1;

String needapprovecheck="";

char flag=2;
String tempsubcategoryid="";
String isSetShare = "";
if(secid > 0){
	RecordSet.executeProc("Doc_SecCategory_SelectByID",secid+"");
	RecordSet.next();
	isSetShare = Util.null2String(""
			+ RecordSet.getString("isSetShare"));
	categoryname=Util.toScreenToEdit(RecordSet.getString("categoryname"),user.getLanguage());
	subcategoryid=Util.null2String(""+RecordSet.getString("subcategoryid"));
	docmouldid=Util.null2String(""+RecordSet.getString("docmouldid"));
	publishable=Util.null2String(""+RecordSet.getString("publishable"));
	replyable=Util.null2String(""+RecordSet.getString("replyable"));
	shareable=Util.null2String(""+RecordSet.getString("shareable"));
	
	readoptercanprint = Util.null2String(""+RecordSet.getString("readoptercanprint"));

	/* 在DocManager中判断
	String approvewfid=RecordSet.getString("approveworkflowid");
	if(approvewfid.equals("")) approvewfid="0";
    if(approvewfid.equals("0"))
        needapprovecheck="0";
    else
        needapprovecheck="1";
	*/
}

String docCode = "";//DocCoder.getDocCoder(secid+"");

// check user right

int haschecked =0;
int trueright = 0;


/* 谭小鹏 2003-05-29日 修改 将原来的权限判断改为新的方法，下面注释中的是原代码 */
if (am.hasPermission(secid, MultiAclManager.CATEGORYTYPE_SEC, user.getUID(), user.getType(), Integer.parseInt(user.getSeclevel()), MultiAclManager.OPERATION_CREATEDOC)) {
    trueright = 1;
}
if (secid < 0) {
    trueright = 1;
}



// 	Check Right
if(trueright!=1&&!isPersonalDoc) {
  	response.sendRedirect("/notice/noright.jsp");
	return;
}

// add by liuyu for dsp moulde text
String mouldtext = "" ;
int mouldType = 0;
if(!docmodule.equals("")) {
	MouldManager.setId(Util.getIntValue(docmodule));
	MouldManager.getMouldInfoById();
	//mouldtext=MouldManager.getMouldText();
    mouldType=MouldManager.getMouldType();
	MouldManager.closeStatement();
    if(mouldType>1){
        String queryStr = request.getQueryString();
        String toQueryStr = queryStr;
        toQueryStr = Util.replace(toQueryStr,"&docmodule=([^&])*","",0);
%>
<SCRIPT LANGUAGE="JavaScript">
	document.location.href = "DocAddExt.jsp?<%=toQueryStr%>";
</SCRIPT>
<%
        return;
    }
	MouldManager.closeStatement();
}

List selectMouldList = new ArrayList();
int selectMouldType = 0;
int selectDefaultMould = 0;

if(docType.equals(".htm")){
	RecordSet.executeSql("select * from DocSecCategoryMould where secCategoryId = "+secid+" and mouldType=2 order by id ");
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
			    if(selectMouldType==0){
			        selectMouldType = 1;
				    selectDefaultMould = Util.getIntValue(moduleid);
			    }
				selectMouldList.add(moduleid);
		    } else {
		        if(Util.getIntValue(modulebind,1)!=3)
					selectMouldList.add(moduleid);
		    }
		}
	}
	if(selectMouldType>0&&Util.getIntValue(docmodule,0)==0){
        String queryStr = request.getQueryString();
        String toQueryStr = queryStr;
        if(toQueryStr.indexOf("docmodule=")>-1)
            toQueryStr = Util.replace(toQueryStr,"docmodule=([^&])*","docmodule="+selectDefaultMould,0);
        else
            toQueryStr = toQueryStr + "&docmodule=" + selectDefaultMould;
        response.sendRedirect("DocAdd.jsp?"+toQueryStr);
        return;
	}
}



/**************************************************************************************************************
Discussion of project export to document
hubo,2005-08-29 modify by yshxu 2005-12-01 for adding customer contract export to document
*/
if(isExpDiscussion.equals("y")){
	String defaultSubject = "";
	char flag0=2;
	String projDiscussionHTML = "";
	StringBuffer projDiscussion = new StringBuffer("");
	if(!prjid.equals("")){
		String types = "PP";
		String sortid = prjid;

		RecordSetEX.executeProc("ExchangeInfo_SelectBID",sortid+flag0+types);
		while(RecordSetEX.next()){
			projDiscussion.append("<table style='width:100%;font-family:MS Shell Dlg;font-size:12px'><tr style='background-color:#dfdfdf;height:20px'>");
			projDiscussion.append("<td>"+RecordSetEX.getString("createDate")+"&nbsp;"+RecordSetEX.getString("createTime")+"&nbsp;&nbsp;<a href='javaScript:openhrm("+RecordSetEX.getString("creater")+");' onclick='pointerXY(event);'>"+ResourceComInfo.getResourcename(RecordSetEX.getString("creater"))+"</a></td>");
			projDiscussion.append("</tr>");
			projDiscussion.append("<tr><td>"+Util.toHtml5(RecordSetEX.getString("remark"))+"</td></tr>");
			String docids_0=  Util.null2String(RecordSetEX.getString("docids"));
			String docsname="";
			if(!docids_0.equals("")){
				ArrayList docs_muti = Util.TokenizerString(docids_0,",");
				int docsnum = docs_muti.size();
				for(int i=0;i<docsnum;i++){
					 docsname= docsname+"<a href=/docs/docs/DocDsp.jsp?id="+docs_muti.get(i)+">"+Util.toScreen(DocComInfo.getDocname(""+docs_muti.get(i)),user.getLanguage())+"</a>"+"&nbsp;&nbsp;";
				}
				projDiscussion.append("<tr><td>"+SystemEnv.getHtmlLabelName(857,user.getLanguage())+"："+docsname+"</td></tr>");
			}
			projDiscussion.append("</table>");
		}
		defaultSubject = ProjectInfoComInfo.getProjectInfoname(prjid)+"-"+SystemEnv.getHtmlLabelName(15153,user.getLanguage());
	}else if(!coworkid.equals("")){

		RecordSetEX.executeSql("select * from cowork_discuss where coworkid="+coworkid+" order by createdate desc,createtime desc");
		while(RecordSetEX.next()){
			projDiscussion.append("<table style='width:100%;font-family:MS Shell Dlg;font-size:12px'><tr style='background-color:#dfdfdf;height:20px'>");
			projDiscussion.append("<td>"+RecordSetEX.getString("createdate")+"&nbsp;"+RecordSetEX.getString("createtime")+"&nbsp;&nbsp;<a href='javaScript:openhrm("+RecordSetEX.getString("discussant")+");' onclick='pointerXY(event);'>"+ResourceComInfo.getResourcename(RecordSetEX.getString("discussant"))+"</a></td>");
			projDiscussion.append("</tr>");
			String str = Util.null2String(RecordSetEX.getString("remark"));
			str = Util.StringReplace(str,"&lt;br&gt;","");
			projDiscussion.append("<tr><td>"+str+"</td></tr>");

			String relatedprj = Util.null2String(RecordSetEX.getString("relatedprj"));
			if(relatedprj.equals("0"))relatedprj="";
			String relatedcus = Util.null2String(RecordSetEX.getString("relatedcus"));
			if(relatedcus.equals("0"))relatedcus="";
			String relatedwf = Util.null2String(RecordSetEX.getString("relatedwf"));
			if(relatedwf.equals("0"))relatedwf="";
			String relateddoc = Util.null2String(RecordSetEX.getString("relateddoc"));
			if(relateddoc.equals("0"))relateddoc="";
			String relatedacc = Util.null2String(RecordSetEX.getString("ralatedaccessory"));
			if(relatedacc.equals("0"))relatedacc="";
			ArrayList relatedprjList = Util.TokenizerString(relatedprj, ",");
			ArrayList relatedcusList = Util.TokenizerString(relatedcus, ",");
			ArrayList relatedwfList = Util.TokenizerString(relatedwf, ",");
			ArrayList relateddocList = Util.TokenizerString(relateddoc, ",");
			ArrayList relatedaccList = Util.TokenizerString(relatedacc, ",");

			String prjsname="",cussname="",wfsname="",docsname="",accsname="";

			if(relateddocList.size()>0){
				for(int i=0;i<relateddocList.size();i++){
					docsname= docsname+"<a href=/docs/docs/DocDsp.jsp?id="+relateddocList.get(i)+">"+Util.toScreen(DocComInfo.getDocname(""+relateddocList.get(i)),user.getLanguage())+"</a>"+"&nbsp;&nbsp;";
				}
				projDiscussion.append("<tr><td>"+SystemEnv.getHtmlLabelName(857,user.getLanguage())+"："+docsname+"</td></tr>");
			}
			if(relatedcusList.size()>0){
				for(int i=0;i<relatedcusList.size();i++){
					cussname= cussname+"<a href=/CRM/data/ViewCustomer.jsp?CustomerID="+relatedcusList.get(i)+">"+Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+relatedcusList.get(i)),user.getLanguage())+"</a>"+"&nbsp;&nbsp;";
				}
				projDiscussion.append("<tr><td>"+SystemEnv.getHtmlLabelName(783,user.getLanguage())+"："+cussname+"</td></tr>");
			}
			if(relatedwfList.size()>0){
				for(int i=0;i<relatedwfList.size();i++){
					wfsname= wfsname+"<a href=/workflow/request/ViewRequest.jsp?requestid="+relatedwfList.get(i)+">"+Util.toScreen(RequestComInfo.getRequestname(""+relatedwfList.get(i)),user.getLanguage())+"</a>"+"&nbsp;&nbsp;";
				}
				projDiscussion.append("<tr><td>"+SystemEnv.getHtmlLabelName(1044,user.getLanguage())+"："+wfsname+"</td></tr>");
			}
			if(relatedprjList.size()>0){
				for(int i=0;i<relatedprjList.size();i++){
					prjsname= prjsname+"<a href=/proj/process/ViewTask.jsp?taskrecordid="+relatedprjList.get(i)+">"+Util.toScreen(ProjectTaskApprovalDetail.getTaskSuject(""+relatedprjList.get(i)),user.getLanguage())+"</a>"+"&nbsp;&nbsp;";
				}
				projDiscussion.append("<tr><td>"+SystemEnv.getHtmlLabelName(18871,user.getLanguage())+"："+prjsname+"</td></tr>");
			}
			if(relatedaccList.size()>0){
				for(int i=0;i<relatedaccList.size();i++){
					RecordSetAcc.executeSql("select id,docsubject from docdetail where id="+relatedaccList.get(i));
					if(RecordSetAcc.next()){
						String showid = Util.null2String(RecordSetAcc.getString(1));
            String tempshowname= Util.toScreen(RecordSetAcc.getString(2),user.getLanguage()) ;
            String fileExtendName = "";
            String docImagefileid = "";
            String docImagefilename = "";
						DocImageManager.resetParameter();
            DocImageManager.setDocid(Integer.parseInt(showid));
            DocImageManager.selectDocImageInfo();
            if(DocImageManager.next()){
              docImagefileid = DocImageManager.getImagefileid();
              docImagefilename = DocImageManager.getImagefilename();
            	fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".")+1).toLowerCase();
            }
            if(fileExtendName.equalsIgnoreCase("xls")||fileExtendName.equalsIgnoreCase("doc")){
            	accsname = accsname + "<a href=/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&fromcowork=1>"+tempshowname+"</a>"+"&nbsp;&nbsp;";
            }else{
            	accsname = accsname + "<a href=/docs/docs/DocDsp.jsp?id="+showid+"&isOpenFirstAss=1&fromcowork=1>"+tempshowname+"</a>"+"&nbsp;&nbsp;";
            }
					}
				}
				projDiscussion.append("<tr><td>"+SystemEnv.getHtmlLabelName(156,user.getLanguage())+"："+accsname+"</td></tr>");
			}
			projDiscussion.append("</table>");
			projDiscussion.append("<br>");
		}

		RecordSetEX.executeSql("select * from cowork_items where id="+coworkid);
		while(RecordSetEX.next()){
			projDiscussion.append("<table style='width:100%;font-family:MS Shell Dlg;font-size:12px'><tr style='background-color:#dfdfdf;height:20px'>");
			projDiscussion.append("<td>"+RecordSetEX.getString("createdate")+"&nbsp;"+RecordSetEX.getString("createtime")+"&nbsp;&nbsp;<a href='javaScript:openhrm("+RecordSetEX.getString("creater")+");' onclick='pointerXY(event);'>"+ResourceComInfo.getResourcename(RecordSetEX.getString("creater"))+"</a></td>");
			projDiscussion.append("</tr>");
			String str = Util.toHtml7(RecordSetEX.getString("remark"));
			str = Util.StringReplace(str,"&lt;br&gt;","");
			projDiscussion.append("<tr><td>"+str+"</td></tr>");

			String relatedprj = Util.null2String(RecordSetEX.getString("relatedprj"));
			if(relatedprj.equals("0"))relatedprj="";
			String relatedcus = Util.null2String(RecordSetEX.getString("relatedcus"));
			if(relatedcus.equals("0"))relatedcus="";
			String relatedwf = Util.null2String(RecordSetEX.getString("relatedwf"));
			if(relatedwf.equals("0"))relatedwf="";
			String relateddoc = Util.null2String(RecordSetEX.getString("relateddoc"));
			if(relateddoc.equals("0"))relateddoc="";
			String relatedacc = Util.null2String(RecordSetEX.getString("accessory"));
			if(relatedacc.equals("0"))relatedacc="";
			ArrayList relatedprjList = Util.TokenizerString(relatedprj, ",");
			ArrayList relatedcusList = Util.TokenizerString(relatedcus, ",");
			ArrayList relatedwfList = Util.TokenizerString(relatedwf, ",");
			ArrayList relateddocList = Util.TokenizerString(relateddoc, ",");
			ArrayList relatedaccList = Util.TokenizerString(relatedacc, ",");

			String prjsname="",cussname="",wfsname="",docsname="",accsname="";

			if(relateddocList.size()>0){
				for(int i=0;i<relateddocList.size();i++){
					String relateddoctemp = ""+relateddocList.get(i);
					if(relateddoctemp.indexOf("|")!=-1)
						relateddoctemp = relateddoctemp.substring(0,relateddoctemp.indexOf("|"));
					docsname= docsname+"<a href=/docs/docs/DocDsp.jsp?id="+relateddoctemp+">"+Util.toScreen(DocComInfo.getDocname(relateddoctemp),user.getLanguage())+"</a>"+"&nbsp;&nbsp;";
				}
				projDiscussion.append("<tr><td>"+SystemEnv.getHtmlLabelName(857,user.getLanguage())+"："+docsname+"</td></tr>");
			}
			if(relatedcusList.size()>0){
				for(int i=0;i<relatedcusList.size();i++){
					cussname= cussname+"<a href=/CRM/data/ViewCustomer.jsp?CustomerID="+relatedcusList.get(i)+">"+Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+relatedcusList.get(i)),user.getLanguage())+"</a>"+"&nbsp;&nbsp;";
				}
				projDiscussion.append("<tr><td>"+SystemEnv.getHtmlLabelName(783,user.getLanguage())+"："+cussname+"</td></tr>");
			}
			if(relatedwfList.size()>0){
				for(int i=0;i<relatedwfList.size();i++){
					wfsname= wfsname+"<a href=/workflow/request/ViewRequest.jsp?requestid="+relatedwfList.get(i)+">"+Util.toScreen(RequestComInfo.getRequestname(""+relatedwfList.get(i)),user.getLanguage())+"</a>"+"&nbsp;&nbsp;";
				}
				projDiscussion.append("<tr><td>"+SystemEnv.getHtmlLabelName(1044,user.getLanguage())+"："+wfsname+"</td></tr>");
			}
			if(relatedprjList.size()>0){
				for(int i=0;i<relatedprjList.size();i++){
					prjsname= prjsname+"<a href=/proj/process/ViewTask.jsp?taskrecordid="+relatedprjList.get(i)+">"+Util.toScreen(ProjectTaskApprovalDetail.getTaskSuject(""+relatedprjList.get(i)),user.getLanguage())+"</a>"+"&nbsp;&nbsp;";
				}
				projDiscussion.append("<tr><td>"+SystemEnv.getHtmlLabelName(18871,user.getLanguage())+"："+prjsname+"</td></tr>");
			}
			if(relatedaccList.size()>0){
				for(int i=0;i<relatedaccList.size();i++){
					RecordSetAcc.executeSql("select id,docsubject from docdetail where id="+relatedaccList.get(i));
					if(RecordSetAcc.next()){
						String showid = Util.null2String(RecordSetAcc.getString(1));
            String tempshowname= Util.toScreen(RecordSetAcc.getString(2),user.getLanguage()) ;
            String fileExtendName = "";
            String docImagefileid = "";
            String docImagefilename = "";
						DocImageManager.resetParameter();
            DocImageManager.setDocid(Integer.parseInt(showid));
            DocImageManager.selectDocImageInfo();
            if(DocImageManager.next()){
              docImagefileid = DocImageManager.getImagefileid();
              docImagefilename = DocImageManager.getImagefilename();
            	fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".")+1).toLowerCase();
            }
            if(fileExtendName.equalsIgnoreCase("xls")||fileExtendName.equalsIgnoreCase("doc")){
            	accsname = accsname + "<a href=/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&fromcowork=1>"+tempshowname+"</a>"+"&nbsp;&nbsp;";
            }else{
            	accsname = accsname + "<a href=/docs/docs/DocDsp.jsp?id="+showid+"&isOpenFirstAss=1&fromcowork=1>"+tempshowname+"</a>"+"&nbsp;&nbsp;";
            }
					}
				}
				projDiscussion.append("<tr><td>"+SystemEnv.getHtmlLabelName(156,user.getLanguage())+"："+accsname+"</td></tr>");
			}
			projDiscussion.append("</table>");
			projDiscussion.append("<br>");
		}
		defaultSubject = RecordSetEX.getString("name")+"-"+SystemEnv.getHtmlLabelName(15153,user.getLanguage());
	}else if(!crmid.equals("")){
		String tempsql = "";
		if (RecordSetC.getDBType().equals("oracle"))
			tempsql = " SELECT * FROM ( SELECT id, begindate, begintime, resourceid, description, createrid, createrType, taskid, crmid, requestid, docid"
				+ " FROM WorkPlan WHERE id IN ( "
				+ " SELECT DISTINCT a.id FROM WorkPlan a "
				+ " where (CONCAT(CONCAT(',',a.crmid),',')) LIKE '%," + crmid + ",%'"
				+ " AND a.type_n = '3') ORDER BY createdate DESC, createtime DESC)";
		else if (RecordSetC.getDBType().equals("db2"))
			tempsql = " SELECT id, begindate, begintime, resourceid, description, createrid, createrType, taskid, crmid, requestid, docid"
				+ " FROM WorkPlan WHERE id IN ( "
				+ " SELECT DISTINCT a.id FROM WorkPlan a "
				+ " where (CONCAT(CONCAT(',',a.crmid),',')) LIKE '%," + crmid + ",%'"
				+ " AND a.type_n = '3') ORDER BY createdate DESC, createtime DESC";
		else
			tempsql = "SELECT id, begindate , begintime, resourceid, description, createrid, createrType, taskid, crmid, requestid, docid"
				+ " FROM WorkPlan WHERE id IN ("
				+ "SELECT DISTINCT a.id FROM WorkPlan a"
				+ " where (',' + a.crmid + ',') LIKE '%," + crmid + ",%'"
				+ " AND a.type_n = '3') ORDER BY createdate DESC, createtime DESC";
		RecordSetC.executeSql(tempsql);
		while (RecordSetC.next()) {
			String m_beginDate = Util.null2String(RecordSetC.getString("begindate"));
			String m_beginTime = Util.null2String(RecordSetC.getString("begintime"));
			String m_memberId = Util.null2String(RecordSetC.getString("createrid"));
			String m_createrType = Util.null2String(RecordSetC.getString("createrType"));
			String m_description = Util.null2String(RecordSetC.getString("description"));
			String relatedprj = Util.null2String(RecordSetC.getString("taskid"));
			if(relatedprj.equals("0"))relatedprj="";
			String relatedcus = Util.null2String(RecordSetC.getString("crmid"));
			if(relatedcus.equals("0"))relatedcus="";
			String relatedwf = Util.null2String(RecordSetC.getString("requestid"));
			if(relatedwf.equals("0"))relatedwf="";
			String relateddoc = Util.null2String(RecordSetC.getString("docid"));
			if(relateddoc.equals("0"))relateddoc="";
			ArrayList relatedprjList = Util.TokenizerString(relatedprj, ",");
			ArrayList relatedcusList = Util.TokenizerString(relatedcus, ",");
			ArrayList relatedwfList = Util.TokenizerString(relatedwf, ",");
			ArrayList relateddocList = Util.TokenizerString(relateddoc, ",");

			projDiscussion.append("<table style='width:100%;font-family:MS Shell Dlg;font-size:12px'><tr style='background-color:#dfdfdf;height:20px'>");
			if (m_createrType.equals("1"))
				projDiscussion.append("<td>"+m_beginDate+"&nbsp;"+m_beginTime+"&nbsp;&nbsp;<a href='javaScript:openhrm("+m_memberId+");' onclick='pointerXY(event);'>"+ResourceComInfo.getResourcename(m_memberId)+"</a></td>");
			else
				projDiscussion.append("<td>"+m_beginDate+"&nbsp;"+m_beginTime+"&nbsp;&nbsp;<a href='/CRM/data/ViewCustomer.jsp?CustomerID="+m_memberId+"'>"+CustomerInfoComInfo.getCustomerInfoname(m_memberId)+"</a></td>");
			projDiscussion.append("</tr>");
			projDiscussion.append("<tr><td>"+m_description+"</td></tr>");
			String prjsname="",cussname="",wfsname="",docsname="";
			if(relatedprjList.size()>0){
				for(int i=0;i<relatedprjList.size();i++){
					prjsname= prjsname+"<a href=/proj/process/ViewTask.jsp?taskrecordid="+relatedprjList.get(i)+">"+Util.toScreen(ProjectTaskApprovalDetail.getTaskSuject(""+relatedprjList.get(i)),user.getLanguage())+"</a>"+"&nbsp;&nbsp;";
				}
				projDiscussion.append("<tr><td>"+SystemEnv.getHtmlLabelName(18871,user.getLanguage())+"："+prjsname+"</td></tr>");
			}
			if(relatedcusList.size()>0){
				for(int i=0;i<relatedcusList.size();i++){
					cussname= cussname+"<a href=/CRM/data/ViewCustomer.jsp?CustomerID="+relatedcusList.get(i)+">"+Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+relatedcusList.get(i)),user.getLanguage())+"</a>"+"&nbsp;&nbsp;";
				}
				projDiscussion.append("<tr><td>"+SystemEnv.getHtmlLabelName(783,user.getLanguage())+"："+cussname+"</td></tr>");
			}
			if(relatedwfList.size()>0){
				for(int i=0;i<relatedwfList.size();i++){
					wfsname= wfsname+"<a href=/workflow/request/ViewRequest.jsp?requestid="+relatedwfList.get(i)+">"+Util.toScreen(RequestComInfo.getRequestname(""+relatedwfList.get(i)),user.getLanguage())+"</a>"+"&nbsp;&nbsp;";
				}
				projDiscussion.append("<tr><td>"+SystemEnv.getHtmlLabelName(1044,user.getLanguage())+"："+wfsname+"</td></tr>");
			}
			if(relateddocList.size()>0){
				for(int i=0;i<relateddocList.size();i++){
					docsname= docsname+"<a href=/docs/docs/DocDsp.jsp?id="+relateddocList.get(i)+">"+Util.toScreen(DocComInfo.getDocname(""+relateddocList.get(i)),user.getLanguage())+"</a>"+"&nbsp;&nbsp;";
				}
				projDiscussion.append("<tr><td>"+SystemEnv.getHtmlLabelName(857,user.getLanguage())+"："+docsname+"</td></tr>");
			}
			projDiscussion.append("</table>");
			projDiscussion.append("<br>");
		}
		defaultSubject = CustomerInfoComInfo.getCustomerInfoname(crmid)+"-"+SystemEnv.getHtmlLabelName(6082,user.getLanguage());
	}
	projDiscussionHTML = projDiscussion.toString();

	docsubject = defaultSubject;
	mouldtext = projDiscussionHTML;
}
/**************************************************************************************************************/



String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(58,user.getLanguage());
String needfav ="1";
String needhelp ="";

String Id=""+secid;
%>
<body class="ext-ie ext-ie8 x-border-layout-ct" scroll="no" onbeforeunload="checkChange(event)">

<input type='hidden' value='<%=udesid%>' name='udesid'>

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
menuBarMap.put("text",SystemEnv.getHtmlLabelName(615,user.getLanguage()));
menuBarMap.put("iconCls","btn_save");
menuBarMap.put("handler","onSave(this);");
menuBars.add(menuBarMap);

if (!isPersonalDoc){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(220,user.getLanguage())+",javascript:onDraft(this),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
    
    //strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(220,user.getLanguage())+"',iconCls: 'btn_draft',handler: function(){onDraft(this)}},";
	menuBarMap = new HashMap();
	menuBarMap.put("text",SystemEnv.getHtmlLabelName(220,user.getLanguage()));
	menuBarMap.put("iconCls","btn_draft");
	menuBarMap.put("handler","onDraft(this);");
	menuBars.add(menuBarMap);
    
	
}

//RCMenu += "{"+SystemEnv.getHtmlLabelName(224,user.getLanguage())+",javascript:showHeader(),_top} " ;
//RCMenuHeight += RCMenuHeightStep ;

//strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(224,user.getLanguage())+"',iconCls: 'btn_add',handler: function(){showHeader()}}";

//strExtBar+="{text:'"+SystemEnv.getHtmlLabelName(156,user.getLanguage())+"',iconCls: 'btn_add',handler: function(){onAccessory()}},";
menuBarMap = new HashMap();
menuBarMap.put("text",SystemEnv.getHtmlLabelName(156,user.getLanguage()));
menuBarMap.put("iconCls","btn_add");
menuBarMap.put("handler","onAccessory();");
menuBars.add(menuBarMap);

menuBarMap = new HashMap();
menuBars.add(menuBarMap);

//strExtBar+="'-',{text:'"+SystemEnv.getHtmlLabelName(21622,user.getLanguage())+"',iconCls: 'btn_list',id:'menuTypeChanger', menu: [{ text: 'WORD&nbsp;"+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"',  iconCls: 'btn_word',handler:function(){onChangeDocType(\'DocAddExt.jsp\',\'.doc\')}},{ text: 'EXCEL&nbsp;"+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"',  iconCls: 'btn_excel',handler:function(){onChangeDocType(\'DocAddExt.jsp\',\'.xls\')}},{ text: 'WPS&nbsp;"+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"',  iconCls: 'btn_wps',handler:function(){onChangeDocType(\'DocAddExt.jsp\',\'.wps\')}}]  },";

// 取消文档类型切换。hqf
/*
menuBarMap = new HashMap();
menuBarMap.put("text",SystemEnv.getHtmlLabelName(21622,user.getLanguage()));
menuBarMap.put("iconCls","btn_list");
menuBarMap.put("id","menuTypeChanger");

if("1".equals(isUseET)){
    menuBarToolsMap = new HashMap[]{new HashMap(),new HashMap(),new HashMap(),new HashMap()};
}else{
    menuBarToolsMap = new HashMap[]{new HashMap(),new HashMap(),new HashMap()};
}

String bversion="";
menuBarToolsMap[0].put("text","WORD&nbsp;"+SystemEnv.getHtmlLabelName(58,user.getLanguage()));
menuBarToolsMap[0].put("iconCls","btn_word");
menuBarToolsMap[0].put("handler","onChangeDocType('DocAddExt.jsp','.doc');");
menuBarToolsMap[1].put("text","EXCEL&nbsp;"+SystemEnv.getHtmlLabelName(58,user.getLanguage()));
menuBarToolsMap[1].put("iconCls","btn_excel");
menuBarToolsMap[1].put("handler","onChangeDocType('DocAddExt.jsp','.xls');");
menuBarToolsMap[2].put("text","WPS&nbsp;"+SystemEnv.getHtmlLabelName(58,user.getLanguage()));
menuBarToolsMap[2].put("iconCls","btn_wps");
menuBarToolsMap[2].put("handler","onChangeDocType('DocAddExt.jsp','.wps');");
if("1".equals(isUseET)){
    menuBarToolsMap[3].put("text","ET&nbsp;"+SystemEnv.getHtmlLabelName(58,user.getLanguage()));
    menuBarToolsMap[3].put("iconCls","btn_et");
    menuBarToolsMap[3].put("handler","onChangeDocType('DocAddExt.jsp','.et');");
}
menuBarMap.put("menu",menuBarToolsMap);

menuBars.add(menuBarMap);

menuBarMap = new HashMap();
menuBars.add(menuBarMap);
*/
//strExtBar+="'-',{text:'<span id=spanProp>"+SystemEnv.getHtmlLabelName(21689,user.getLanguage())+"</span>',iconCls: 'btn_ShowOrHidden',handler: function(){DocCommonExt.showorhiddenprop()}}";
menuBarMap = new HashMap();
menuBarMap.put("text","<span id=spanProp>"+SystemEnv.getHtmlLabelName(21689,user.getLanguage())+"</span>");
menuBarMap.put("iconCls","btn_ShowOrHidden");
menuBarMap.put("id","btn_ShowOrHidden");
menuBarMap.put("handler","onExpandOrCollapse();");
menuBars.add(menuBarMap);

//strExtBar+="]";

//RCMenu += "{"+SystemEnv.getHtmlLabelName(156,user.getLanguage())+",javascript:addannexRow(),_top} " ;
//RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_top} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>
<div id="divMenu" style="display:none">
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</div>

<script>
function onSelectCategory(whichcategory) {	
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp?operationcode=<%=MultiAclManager.OPERATION_CREATEDOC%>");
	if (result != null) {
	    if (result[0] > 0)  {
	        //location = "DocAdd.jsp?secid="+result[1]+"&showsubmit=<%=showsubmit%>&prjid=<%=prjid%>&coworkid=<%=coworkid%>&crmid=<%=crmid%>&hrmid=<%=hrmid%>&from=<%=from%>&docsubject="+weaver.docsubject.value+"&invalidationdate=<%=invalidationdate%>";
	        location = "DocAdd.jsp?secid="+result[1]+"&topage=<%=tmptopage%>&showsubmit=<%=showsubmit%>&prjid=<%=prjid%>&coworkid=<%=coworkid%>&crmid=<%=crmid%>&hrmid=<%=hrmid%>&from=<%=from%>&docsubject="+weaver.docsubject.value+"&invalidationdate=<%=invalidationdate%>";
    	}
	}
}

function onBtnSearchClick(){}
jQuery(document).ready(function(){
	 jQuery("div#divTab").show();
	 <%if(secid<=0){%>
	 	jQuery("#divPropATab").addClass("x-tab-strip-div-disabled").hide();
	 	jQuery("#divAccATab").addClass("x-tab-strip-div-disabled").hide();
	 <%}else{%>
	 	
	 <%}%>
});

</script>
<%--<input type=hidden name=docapprovable value="<%=needapprovecheck%>">--%>
<input id="f_weaver_belongto_userid" name="f_weaver_belongto_userid" type="hidden" value="<%=f_weaver_belongto_userid%>">
<input id="f_weaver_belongto_usertype" name="f_weaver_belongto_usertype" type="hidden" value="<%=f_weaver_belongto_usertype%>">
<input type="hidden" name="docreplyable" value="<%=replyable%>">
<input type="hidden" name="usertype" value="<%=usertype%>">
<input type="hidden" name="from">
<input type="hidden" name="userCategory">
<input type="hidden" name="userId" value="<%=user.getUID()%>">
<input type="hidden" name="userType" value="<%=user.getLogintype()%>">

<input type="hidden" name="docstatus" value="0">
<input type="hidden" name="doccode" value="<%=docCode%>">
<input type="hidden" name="docedition" value="-1">
<input type="hidden" name="doceditionid" value="-1">
<input type="hidden" name="maincategory" id="maincategory" value="<%=(mainid==-1?"":Integer.toString(mainid))%>">
<input type="hidden" name="subcategory" id="subcategory" value="<%=(subid==-1?"":Integer.toString(subid))%>">
<input type="hidden" temptitle="<%=SystemEnv.getHtmlLabelName(16398,user.getLanguage())%>" name="seccategory" id="seccategory" value="<%=(secid==-1?"":Integer.toString(secid))%>">
<input type="hidden" name="ownerid" value="<%=ownerid%>">
<input type="hidden" name="docdepartmentid" value="<%=docdepartmentid%>">
<input type="hidden" name="doclangurage" value=<%=user.getLanguage()%>>
<input type="hidden" name="maindoc" id="maindoc" value="-1">

<input type="hidden" name="topage" value="<%=Util.null2String(request.getParameter("topage"))%>">
<input type=hidden name=operation>
<input type="hidden" name="SecId" id="SecId" value="<%=Id%>">
<input type="hidden" name="imageidsExt"  id="imageidsExt">
<input type="hidden" name="imagenamesExt"  id="imagenamesExt">
<input type="hidden" name="delImageidsExt"  id="delImageidsExt">

<div style="position: absolute; left: 0; top: 0; width:100%;height:100%;">

<div id="divContentTab" style="display:none;width:100%;height:100%;">
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
	   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("82,30041",user.getLanguage()) %>'/>
	   <jsp:param name="exceptHeight" value="true"/>
	   <jsp:param name="isPersonalDoc" value="<%=isPersonalDoc %>"/>
	   <jsp:param name="docsubject" value="<%=docsubject %>"/>
	   <jsp:param name="_fromURL" value="doc"/>
	   <jsp:param name="limitSec" value='<%=Util.null2String(request.getParameter("limitSec")) %>'/>
	</jsp:include>
	<%-- 文档标题 start --%>
	        	
	    	<script type="text/javascript">
					var isChecking = false;
					//var prevValue = "";
					
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
							checkDocSubject(obj)
						}
					}
					function checkDocSubject(obj,callback){
						if(obj!=null&&obj.value!=null&&""==obj.value){
							checkinput('docsubject','docsubjectspan');
							if(callback){
								callback();
							}
							return false;
						}
						isChecking = true; 
						//var subject = encodeURIComponent(obj.value);	
						var subject = obj.value;							
						var url = 'DocSubjectCheck.jsp?f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>';
						var pars = 'subject='+subject+'&secid='+jQuery("#seccategory").val();
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
								secid:jQuery("#seccategory").val()
							},
							success:function(data){
								if(parseInt(data.num)>0){
									$("#docsubjectspan").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
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
							//alert("<%=SystemEnv.getHtmlLabelName(20073,user.getLanguage())%>");
							$("#docsubjectspan").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
							top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20073,user.getLanguage())%>");
							$GetEle("namerepeated").value = 1;
						} else {
							$GetEle("namerepeated").value = 0;
							checkinput('docsubject','docsubjectspan');
						}
						isChecking = false;
						//prevValue =$GetEle("docsubject").value;
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
	    	<input type="hidden" name="needinputitems" id="needinputitems" value="<%=needinputitems %>"/>
	<%-- 文档标题 end --%>
		<div id="divContent" style="width:100%;margin:0 auto;position: relative;">
			<%-- HTML编辑控件 start --%>
			<div id="divContentInfo" class="e8_propTab " style="width:100%;height:100%;">
				<textarea  class="ckeditor1" name="doccontent" id="doccontent" TABINDEX="2" style="width: 100%"><%=Util.encodeAnd(mouldtext)%></textarea>
            </div>
			<%-- HTML编辑控件 end --%>
			<%-- 基本属性 start --%>
			<div id="divProp" class="e8_propTab" style="display:none;width:100%;height:100%;">
				<DIV id="divPropContent" style="width 100%; height 100%; overflow: visible" class="x-panel-body x-panel-body-noheader x-panel-body-noborder">
					<%--@ include file="/docs/docs/DocAddBaseInfo.jsp" --%>
				</DIV>
			</div>
			<%-- 基本属性 end --%>
			<!-- 文档附件栏 start -->
			<div id="divAcc" class="e8_propTab" style="border:none;display:none;width:100%;height:100%;">
				<DIV style="border:none;width: 100%; height: 100%;overflow:visible" class="x-tab-panel-body x-tab-panel-body-noheader x-tab-panel-body-noborder x-tab-panel-body-bottom">
<%
			String sessionPara=""+secid+"_"+user.getUID()+"_"+user.getLogintype();
			session.setAttribute("right_add_"+sessionPara,"1");
%>
				<iframe id="e8DocAccIfrm" style="border:none;" src="javascript:false;" frameborder="0" width="100%" height="100%"></iframe>
				</DIV>
			</div>
			<!-- 文档附件栏 end -->
		</div>


<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</div>

	


<!-- 底部选项卡栏 start -->
	<div style="position:relative;z-index: 900;">
	<div id="divTab" class="e8_weavertab" style="display:none;width:100%;position:relative;">

		<DIV style="float:left;" class="x-tab-panel-footer x-tab-panel-footer-noborder">
		<DIV class=x-tab-strip-spacer></DIV>
		<DIV class=x-tab-strip-wrap>
		<UL class="x-tab-strip x-tab-strip-bottom">
		
		<LI id=divContentInfoATab class="x-tab-strip-active" onclick="onActiveTab('divContentInfo');">
		<A class=x-tab-strip-close onclick="return false;"></A>
		<A class=x-tab-right onclick="return false;" href="#">
		<EM class=x-tab-left>
		<SPAN class=x-tab-strip-inner><SPAN class="x-tab-strip-text "><%= SystemEnv.getHtmlLabelName(18332,user.getLanguage())%></SPAN></SPAN>
		</EM>
		</A>
		</LI>
		
		<LI id=divPropATab class="" onclick="onActiveTab('divProp');">
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
		<SPAN class=x-tab-strip-inner><SPAN class="x-tab-strip-text "><script type="text/javascript">document.write(wmsg.doc.acc);</script></SPAN></SPAN>
		</EM>
		</A>
		</LI>
		
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
</jsp:include>

<!--文档内容过滤JS-->
<script language="javascript" type="text/javascript">

jQuery(window).resize(function() {
    var fileuplod=jQuery(".fileupload");
	if(fileuplod.length>0){
	   var divcontentoffset=jQuery("#divContent").offset();
	   var offset=jQuery(".edui-for-attachment").find(".edui-button-body").offset();
       fileuplod.css("left",(offset.left-divcontentoffset.left)+"px");
	   fileuplod.css("top",(offset.top-divcontentoffset.top)+"px");
	}
});

<%if(maxUploadImageSize>0){%>
	jQuery(document).ready(function(){
		window.setTimeout(function(){
			bindAttachmentUpload("<%=maxUploadImageSize%>");
		},500);
	});
<%} %>	
<%
	String msg1 = SystemEnv.getHtmlLabelName(25838,user.getLanguage());
%>
	function bindAttachmentUpload(maxUploadImageSize){
		var cke_button_swfupload = jQuery(".edui-for-attachment").find(".edui-button-body");
		
        if(cke_button_swfupload.length>0){
           	var edui156_body =  cke_button_swfupload;
           	jQuery(".edui-for-attachment").removeClass("hideuploaditem");
			var offset=edui156_body.offset();
			cke_button_swfupload.find(".edui-icon").css("background-image","url('')");
			var divcontentoffset=jQuery("#divContent").offset();
			cke_button_swfupload = $("div.fileupload");
			if(cke_button_swfupload.length==0){
			    cke_button_swfupload=$("<div class='fileupload' style='position:absolute;width:20px;height:20px;left:"+(offset.left-divcontentoffset.left)+"px;top:"+(offset.top-divcontentoffset.top)+"px;z-index:900;'></div>");
				jQuery("#divContent").append(cke_button_swfupload);
				cke_button_swfupload.css({
					"display":"inline-block",
					"background-image":"url(/wui/common/js/ckeditor/plugins/swfupload/swf_wev8.png)",
					"background-position":"50% 50%",
					"background-repeat":"no-repeat"
				});
			}else{
				cke_button_swfupload.show();
			}
			cke_button_swfupload.attr("title","<%=msg1%>"+maxUploadImageSize+"M)");
            cke_button_swfupload.attr("docid","");
			cke_button_swfupload.attr("mode","add");
			cke_button_swfupload.attr("maxsize",maxUploadImageSize);
			bindUploaderDiv(cke_button_swfupload,null,true);
		}else{
			window.setTimeout(function(){
				bindAttachmentUpload();
			},500);
		}
	}
  function ContentSearch(){
	var flag = false;//检查标志。false：表示未找到。true：表示找到
   /* try {
	   var str = "<%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%>";//keyword
	   var arr = [];//支持多关键字查找
	   var splitflag = " ";//分隔标志
		if(str === ""){	
			return false;
		}else{
			//将关键字放到数组之中
			arr = str.split(splitflag);	
		}
		var v_html = FCKeditorAPI.GetInstance("doccontent").GetXHTML(true);//需要查找的内容
		//删除注释
		v_html = v_html.replace(/<!--(?:.*)\-->/g,"");
		//将HTML代码支离为HTML片段和文字片段，其中文字片段用于正则替换处理，而HTML片段置之不理
		var tags = /[^<>]+|<(\/?)([A-Za-z]+)([^<>]*)>/g;
		var a = v_html.match(tags);
		jQuery.each(a, function(i, c){
			if(!/<(?:.|\s)*?>/.test(c)){//非标签
				//开始执行替换
				jQuery.each(arr,function(index, con){
					if(con === ""){return;}
					var reg = new RegExp(regTrim(con), "g");
					if(reg.test(c)){
						//正则替换
						c = c.replace(reg,"♂"+con+"♀");
						flag = true;
					}
				});
				a[i] = c;
			}
		});
	}catch(err) {
	   flag = false;
	}*/
	return flag;
}

 function regTrim(s){
		var imp = /[\^\.\\\|\(\)\*\+\-\$\[\]\?]/g;
		var imp_c = {};
		imp_c["^"] = "\\^";
		imp_c["."] = "\\.";
		imp_c["\\"] = "\\\\";
		imp_c["|"] = "\\|";
		imp_c["("] = "\\(";
		imp_c[")"] = "\\)";
		imp_c["*"] = "\\*";
		imp_c["+"] = "\\+";
		imp_c["-"] = "\\-";
		imp_c["$"] = "\$";
		imp_c["["] = "\\[";
		imp_c["]"] = "\\]";
		imp_c["?"] = "\\?";
		s = s.replace(imp,function(o){
			return imp_c[o];					   
		});	
		return s;
}
</script>
<!--文档内容过滤JSend-->

<script language="javascript" type="text/javascript">
var isFromWf=false;
var languageid="<%=user.getLanguage()%>";
var maxUploadImageSize="<%=maxUploadImageSize%>";
var strExtBar="<%=strExtBar%>";
var menubar=eval(strExtBar);
var menubarForwf=[];
var doctype="html";
var ue;

function adjustContentHeight(type){
	var lang="<%=(user.getLanguage()==8)?"en":"zh-cn"%>";
	try{
		//var propTabHeight = 215;
		var propTabHeight = 34;

		if(document.getElementById("divPropTab")&&document.getElementById("divPropTab").style.display=="none") propTabHeight = 34;
		
		var pageHeight=document.body.clientHeight;
		var pageWidth=document.body.clientWidth;
		//console.log(pageHeight+"::"+propTabHeight);
		//document.getElementById("divContentTab").style.height = pageHeight - propTabHeight;
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
			jQuery("#doccontent").height(divContentHeight);
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
					var editorheight=divContentHeight+15;
					var toolbarheight=jQuery(".edui-editor-toolbarbox");
					var contentareaheight=editorheight-toolbarheight.height();
					jQuery(".edui-editor-iframeholder").css("height",contentareaheight);	
					jQuery(".edui-editor").css("height",editorheight);
				   
					 <%if(secid>0){%>
						loadPropAndAcc(<%=secid%>);
					<%}%>
			} );
		} else {			
			if(divContentHeight!=null && divContentHeight>0) {
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
				hideToolsMenu<%=toolid%>();
				<%
				}
			}
		}
		%>
		jQuery("#e8DocAccIfrm").parent().height(jQuery(".tab_box").height());
		onResizeDiv();
	} catch(e){
		if(window.console)console.log(e);
	}
}
// 切换到HTML模式
function switchEditMode(){
	ue.execCommand("source");
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

function onActiveTab(tab,notOpen){
		if(jQuery("#"+tab+"ATab").hasClass("x-tab-strip-div-disabled")){
			return false;
		}
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
	document.getElementById("divContentInfo").style.display='none';

	document.getElementById("divPropATab").className = "";
	document.getElementById("divAccATab").className = "";
	document.getElementById("divContentInfoATab").className = "";
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
		eval("doGet"+tab+"();");
		onResizeDiv();
	} catch(e){}
}

function onResizeDiv() {
	if(document.getElementById("divAcc").style.display!='none')
		resizedivAcc();
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

$(document).ready(
	function(){
		
		try{
			onLoad();
		} catch(e){}

		if(doctype=="html"){
			document.title=wmsg.doc.createHTML;
		} else if(doctype==".doc"){
			document.title=wmsg.doc.createWord;
		}else if(doctype==".xls"){
			document.title=wmsg.doc.createExcel;
		}else if(doctype==".ppt"){
			document.title=wmsg.doc.createPPT;
		}else if(doctype==".wps"){
			document.title=wmsg.doc.createWps;
		}
		
		try{
			document.getElementById("divContentTab").style.display='block';
			document.getElementById("divPropTab").style.display = "none";
			//document.getElementById("divPropTabCollapsed").style.display = "block";

			//onActiveTab("divContentInfo",true);
			setE8ShadowPosition("divContentInfo");
			//document.getElementById('rightMenu').style.visibility="hidden";
			document.getElementById("divMenu").style.display='';	
		} catch(e){
			
		}

		adjustContentHeight("load");

		finalDo();
		
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
<%@ include file="DocAddForCKScript.jsp" %>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
