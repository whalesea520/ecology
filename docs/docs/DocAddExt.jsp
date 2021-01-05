
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager,
                 java.net.*" %>
<%@ page import="weaver.docs.category.security.MultiAclManager " %>
<%@ page import="weaver.docs.category.* " %>

<%@ page import="weaver.conn.RecordSet"%>

 <%@ include file="/systeminfo/init_wev8.jsp" %> 
 <%@ include file="iWebOfficeConf.jsp" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

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

<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<jsp:useBean id="rsDummyDoc" class="weaver.conn.RecordSet" scope="page"/> 

<jsp:useBean id="RequestDoc" class="weaver.workflow.request.RequestDoc" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link type="text/css" href="/css/ecology8/crudoc_wev8.css" rel="stylesheet"></link>

<jsp:include page="/systeminfo/WeaverLangJS.jsp">
    <jsp:param name="languageId" value="<%=user.getLanguage()%>" />
</jsp:include>

<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(58,user.getLanguage());
String needfav ="1";
String needhelp ="";
//判断金阁控件的版本	 2003还是2006
String canPostil = "";
if(isIWebOffice2006 == true){
	canPostil = ",1";
}
int languageId=user.getLanguage();

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
docsubject=java.net.URLDecoder.decode(docsubject,"UTF-8");
String docCode = "";//DocCoder.getDocCoder(secid+"");

//编辑：王金永
String  docType=Util.null2String(request.getParameter("docType"));
if(docType.equals("")){
    docType=".doc";
}
//out.println(docType);
String f_weaver_belongto_userid=Util.null2String(request.getParameter("f_weaver_belongto_userid"));
String f_weaver_belongto_usertype=Util.null2String(request.getParameter("f_weaver_belongto_usertype"));
session.setAttribute("f_weaver_belongto_userid_doc",f_weaver_belongto_userid);
session.setAttribute("f_weaver_belongto_usertype_doc",f_weaver_belongto_usertype);
String  docId=Util.null2String(request.getParameter("docId"));
String  docTemplate=Util.null2String(request.getParameter("docTemplate"));
String  docEditType=Util.null2String(request.getParameter("docEditType"));
if(docEditType.equals("")){
    docEditType = "1";
}
String agent = request.getHeader("user-agent");
if((agent.contains("Firefox")||agent.contains(" Chrome")||agent.contains("Safari") )|| agent.contains("Edge")){
	isIE = "false";
}else{
	isIE = "true";
}	
if("false".equals(isIE)){
	request.setAttribute("labelid","27969");
	request.getRequestDispatcher("/wui/common/page/sysRemind.jsp").forward(request,response);
	return;
}

String  prjid = Util.null2String(request.getParameter("prjid"));
String  crmid=Util.null2String(request.getParameter("crmid"));
String  hrmid=Util.null2String(request.getParameter("hrmid"));
String  showsubmit=Util.null2String(request.getParameter("showsubmit"));
String  coworkid = Util.null2String(request.getParameter("coworkid"));
String  topage=Util.null2String(request.getParameter("topage"));
String  tmptopage=URLEncoder.encode(topage);
topage=URLDecoder.decode(tmptopage);

String temStr = request.getRequestURI();
temStr=temStr.substring(0,temStr.lastIndexOf("/")+1);

String mServerUrl=temStr+mServerName;
String mClientUrl=temStr+mClientName;

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
int requestid=Util.getIntValue(request.getParameter("requestid"),0);
int workflowid=-1;
MultiAclManager am = new MultiAclManager();

int secid=Util.getIntValue(Util.null2String(request.getParameter("secid")), -1);
if(secid==-1){
	secid = Util.getIntValue(request.getParameter("seccategory"),-1);
}
int subid=Util.getIntValue(Util.null2String(request.getParameter("subid")), -1);
int mainid=Util.getIntValue(Util.null2String(request.getParameter("mainid")), -1);
String fromFlowDoc=Util.null2String(request.getParameter("fromFlowDoc"));  //来源于流程建文挡
if (fromFlowDoc.equals("1")) {
	docsubject=Util.null2String((String)session.getAttribute(""+user.getUID()+"_"+requestid+"docsubject"));
	docCode=Util.null2String((String)session.getAttribute(""+user.getUID()+"_"+requestid+"docCode"));
	if(docsubject.equals("")){
		docsubject=Util.null2String((String)session.getAttribute("docsubject"+user.getUID()));
	}
	if(docCode.equals("")){
		docCode=Util.null2String((String)session.getAttribute("docCode"+user.getUID()));
	}
	//session.removeAttribute(""+user.getUID()+"_"+requestid+"docsubject");
	//session.removeAttribute(""+user.getUID()+"_"+requestid+"docCode");
	//session.removeAttribute("docsubject"+user.getUID());
	//session.removeAttribute("docCode"+user.getUID());
}

if(docsubject!=null&&!docsubject.trim().equals("")){
	docsubject=Util.StringReplace(docsubject,"\"","&quot;");
}


int nodeid=-1;
int maxUploadImageSize = DocUtil.getMaxUploadImageSize(secid);
if(isPersonalDoc) {
    int haspost= Util.getIntValue(request.getParameter("haspost"),0);
    
    int cannew = 0;
    if(userCategory<0 && haspost != 1){
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


String docmodule=Util.null2String(request.getParameter("docmodule"));
String ischeckeditmould =Util.null2String(request.getParameter("ischeckeditmould"));
String editMouldIdAndSecCategoryId="";
int mouldSecCategoryId=0;
int countNum = 0;
List countMouldList = new ArrayList();

if(docmodule.equals("")&&fromFlowDoc.equals("1")){
       RecordSet.executeProc("workflow_Requestbase_SByID",requestid+"");
               if(RecordSet.next()){
                   workflowid=RecordSet.getInt("workflowid");                 
               }
	editMouldIdAndSecCategoryId=RequestDoc.getEditMouldIdAndSecCategoryIdForDocAddExt(requestid);
	int indexId=editMouldIdAndSecCategoryId.indexOf("_");
	docmodule=""+Util.getIntValue(editMouldIdAndSecCategoryId.substring(0,indexId),0);
	mouldSecCategoryId=Util.getIntValue(editMouldIdAndSecCategoryId.substring(indexId+1),0);

	RecordSet.executeSql("SELECT distinct docMouldFile.ID,docMouldFile.mouldName FROM DocSecCategoryMould docSecCategoryMould, DocMouldFile docMouldFile WHERE docMouldFile.id in (select mouldid from workflow_mould where visible=1   and mouldType in(3,4) and seccategory="+mouldSecCategoryId+" and workflowid = "+workflowid+") and docSecCategoryMould.mouldID = docMouldFile.ID AND docSecCategoryMould.mouldType in(4,8) AND docSecCategoryMould.mouldBind = 1 AND docSecCategoryMould.secCategoryID = " + mouldSecCategoryId);//获取模板的数量
	while(RecordSet.next()){
        String docMouldID = RecordSet.getString("ID");
		String mode_name = RecordSet.getString("mouldName");
        countMouldList.add(docMouldID);
	}
    countNum = countMouldList.size();
}

if(ischeckeditmould.equals("1")&&fromFlowDoc.equals("1")&&!docmodule.equals("")){
	  RecordSet.executeProc("workflow_Requestbase_SByID",requestid+"");
               if(RecordSet.next()){
                   workflowid=RecordSet.getInt("workflowid");                 
               }
	editMouldIdAndSecCategoryId=docmodule+"_"+secid;
	int indexId=editMouldIdAndSecCategoryId.indexOf("_");
	docmodule=""+Util.getIntValue(editMouldIdAndSecCategoryId.substring(0,indexId),0);
	mouldSecCategoryId=Util.getIntValue(editMouldIdAndSecCategoryId.substring(indexId+1),0);

	RecordSet.executeSql("SELECT docMouldFile.ID,docMouldFile.mouldName FROM DocSecCategoryMould docSecCategoryMould, DocMouldFile docMouldFile WHERE docMouldFile.id in (select mouldid from workflow_mould where visible=1 and mouldType = 4 and seccategory="+mouldSecCategoryId+" and workflowid = "+workflowid+") and docSecCategoryMould.mouldID = docMouldFile.ID AND docSecCategoryMould.mouldType in(4,8) AND docSecCategoryMould.mouldBind = 1 AND docSecCategoryMould.secCategoryID = " + mouldSecCategoryId);//获取模板的数量
	while(RecordSet.next()){
        String docMouldID = RecordSet.getString("ID");
		String mode_name = RecordSet.getString("mouldName");
        countMouldList.add(docMouldID);
	}
    countNum = countMouldList.size();
}

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


String needapprovecheck="";

char flag=2;
String tempsubcategoryid="";

int maxOfficeDocFileSize=8;
String isSetShare = "";
if(secid > 0){
    RecordSet.executeProc("Doc_SecCategory_SelectByID",secid+"");
    RecordSet.next();
	isSetShare = Util.null2String(""
			+ RecordSet.getString("isSetShare"));
    categoryname=Util.toScreenToEdit(RecordSet.getString("categoryname"),languageId);
    subcategoryid=Util.null2String(""+RecordSet.getString("subcategoryid"));
    docmouldid=Util.null2String(""+RecordSet.getString("docmouldid"));
    publishable=Util.null2String(""+RecordSet.getString("publishable"));
    replyable=Util.null2String(""+RecordSet.getString("replyable"));
    shareable=Util.null2String(""+RecordSet.getString("shareable"));
    
	readoptercanprint = Util.null2String(""+RecordSet.getString("readoptercanprint"));
    
	maxOfficeDocFileSize = Util.getIntValue(RecordSet.getString("maxOfficeDocFileSize"),8);

}



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


RecordSet.executeSql("select workflowId,currentNodeId from workflow_requestbase where requestid="+requestid);
if(RecordSet.next()){
	workflowid=RecordSet.getInt("workflowid");
	nodeid=RecordSet.getInt("currentnodeid");
}

if(fromFlowDoc.equals("1")&&trueright!=1&&!isPersonalDoc) {
	int tempSecId=-1;

    ArrayList docCategoryList=RequestDoc.getSelectItemValue(""+workflowid,""+requestid);	
    if(docCategoryList!=null&&docCategoryList.size()>0){
		if(docCategoryList.size() == 1){
			tempSecId=Util.getIntValue((String)docCategoryList.get(0),-1);
		}else{
			tempSecId=Util.getIntValue((String)docCategoryList.get(2),-1);
		}
    }else{
        ArrayList docFieldList=RequestDoc.getDocFiled(""+workflowid);
		if (docFieldList!=null&&docFieldList.size()>0){
			ArrayList tempArrayList=Util.TokenizerString(""+docFieldList.get(2),"||");
			if (tempArrayList!=null&&tempArrayList.size()>0){
                 tempSecId=Util.getIntValue((String)tempArrayList.get(2),-1);
			}
		}
	}

	if(tempSecId==secid){
		//判断当前用户是否为流程当前节点的操作者
	    RecordSet.executeSql("select 1 from workflow_currentoperator where userId="+user.getUID()+" and requestId="+requestid+" and nodeId="+nodeid);
		if(RecordSet.next()){
		    trueright=1;
		}
	}
}

// 	Check Right
if(trueright!=1&&!isPersonalDoc) {
    response.sendRedirect("/notice/noright.jsp");
    return;
}

// add by liuyu for dsp moulde text
String mouldtext = "" ;
int mouldType= 0;
if(!docmodule.equals("")) {
    MouldManager.setId(Util.getIntValue(docmodule));
    MouldManager.getMouldInfoById();
    mouldtext=MouldManager.getMouldText();
    mouldType=MouldManager.getMouldType();
    MouldManager.closeStatement();
    if(mouldType==1){
        String queryStr = request.getQueryString();
        String toQueryStr = queryStr;
        toQueryStr = Util.replace(toQueryStr,"&docmodule=([^&])*","",0);
        response.sendRedirect("DocAdd.jsp?"+toQueryStr);
        return;
    }else if(mouldType==2){
        if(docType.trim().equals("")){
			docType = ".doc";
		}
    }else if(mouldType==3){
        if(docType.trim().equals("")){
			docType = ".xls";
		}
    }else if(mouldType==4){
        if(docType.trim().equals("")){
			docType = ".wps";
		}
    }else if(mouldType==5){
        if(docType.trim().equals("")){
			docType = ".et";
		}
    }
    MouldManager.closeStatement();
}


List selectMouldList = new ArrayList();
int selectMouldType = 0;
int selectDefaultMould = 0;

if(docType.equals(".doc")||docType.equals(".docx")||docType.equals(".xls")||docType.equals(".xlsx")||docType.equals(".wps")||docType.equals(".et")){
	int  tempMouldType=4;//4：WORD编辑模版
	if(docType.equals(".xls")||docType.equals(".xlsx")){
		tempMouldType=6;//6：EXCEL编辑模版
	}else if(docType.equals(".wps")){
		tempMouldType=8;//8：WPS文字编辑模版
	}else if(docType.equals(".et")){
		tempMouldType=10;//8：WPS表格编辑模版
	}

	RecordSet.executeSql("select * from DocSecCategoryMould where secCategoryId = "+secid+" and mouldType="+tempMouldType+" order by id ");
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
        String queryStr = Util.null2String(request.getQueryString());
        String toQueryStr = queryStr;
        if(toQueryStr.indexOf("docmodule=")>-1)
            toQueryStr = Util.replace(toQueryStr,"docmodule=([^&])*","docmodule="+selectDefaultMould,0);
        else
            toQueryStr = toQueryStr + "&docmodule=" + selectDefaultMould;
        toQueryStr = Util.replace(toQueryStr,"docsubject=([^&])*","",0);
        %>
		<script type="text/javascript">
		location = "<%="DocAddExt.jsp?"+toQueryStr%>&docsubject=<%=docsubject%>";
		</script>
<%
        //response.sendRedirect("DocAddExt.jsp?"+toQueryStr);
        return;
	}
}
%>
<script language="javascript" for=WebOffice event="OnMenuClick(vIndex,vCaption)">
    // 1.保存 2.存为草稿 3.预览 4.页眉 5.打开本地文件 6.存为本地文件 7.签名印章  9.显示隐藏 10.刷新窗口
    if (vIndex==1) onSave();
	else if (vIndex==2)  onDraft();
    else if (vIndex==3)  onPreview();
    else if (vIndex==4)  showHeader();
    else if (vIndex==5)  WebOpenLocal();
    else if (vIndex==6)  WebSaveLocal2();
    else if (vIndex==7)  WebOpenSignature();
    else if (vIndex==9)  onExpandOrCollapse();
    else if (vIndex==10) location.reload();
	else if (vIndex == 81) {
		openByDocType(".htm");
	} else if (vIndex == 82) {
		openByDocType(".doc");
	} else if (vIndex == 83) {
		openByDocType(".docx");
	} else if (vIndex == 84) {
		openByDocType(".xls");
	} else if (vIndex == 85) {
		openByDocType(".xlsx");
	} else if (vIndex == 86) {
		openByDocType(".wps");
	}
</script>

<script language=javascript>
	var prjid='<%=prjid%>';
   var coworkid='<%=coworkid%>';
   var crmid='<%=crmid%>';
   var hrmid='<%=hrmid%>';
  var f_weaver_belongto_userid='<%=f_weaver_belongto_userid%>';
   var f_weaver_belongto_usertype='<%=f_weaver_belongto_usertype%>';
    function StatusMsg(mString){
    	try{
    		// Ext.get('loading').fadeIn();
    		 document.getElementById('loading-msg').innerHTML = mString;
    		 //Ext.get('loading').fadeOut();
    	}catch(e){}
    }

    function WebSaveLocal2(){
    try{
		
		var hisFileName=weaver.WebOffice.FileName;
		
			var tempFileName=document.all("docsubject").value;

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
			weaver.WebOffice.FileName=tempFileName;
		
		weaver.WebOffice.WebSaveLocal();
		StatusMsg(weaver.WebOffice.Status);
		
		weaver.WebOffice.FileName=hisFileName;


    }catch(e){}
    }

    function WebOpenLocal(){
    try{
    weaver.WebOffice.WebOpenLocal();
    StatusMsg(weaver.WebOffice.Status);
    }catch(e){
    }

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
	    var properties = weaver.WebOffice.WebObject.BuiltInDocumentProperties;
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

    function SaveDocument(){

    var fileSize=getFileSize();

	if(parseFloat(fileSize)>parseFloat(<%=maxOfficeDocFileSize%>)){
		alert("<%=SystemEnv.getHtmlLabelName(24028,languageId)%>"+fileSize+"M，<%=SystemEnv.getHtmlLabelName(24029,languageId)%><%=maxOfficeDocFileSize%>M！");
		return false;
	}

    showPrompt("<%=SystemEnv.getHtmlLabelName(18886,languageId)%>");

    var tempFileName=document.getElementById("docsubject").value;
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
	tempFileName = tempFileName+'<%=docType%>';
    document.getElementById("WebOffice").FileName=tempFileName;

    weaver.WebOffice.FileType=changeFileType(weaver.WebOffice.FileType);
<%if(isIWebOffice2003&&docType.equals(".doc")){%>
	try{
		var fileSize=0;
		document.getElementById("WebOffice").WebObject.SaveAs();
		fileSize=document.getElementById("WebOffice").WebObject.BuiltinDocumentProperties(22);
		document.getElementById("WebOffice").WebSetMsgByName("NEWFS",fileSize);
	}catch(e){
	}
<%}%>
	var success = weaver.WebOffice.WebSave(<%=isNoComment%>);

    if (!success){
		StatusMsg(weaver.WebOffice.Status);
		alert("<%=SystemEnv.getHtmlLabelName(19007,languageId)%>");
		hiddenPrompt();
		return false;
    }else{
		StatusMsg(weaver.WebOffice.Status);
		weaver.docId.value=weaver.WebOffice.WebGetMsgByName("CREATEID");
		hiddenPrompt();
		return true;
    }
    }
	
    function onLoad(){
		var docType = "<%=docType%>";
		var fromFlowDoc = "<%=fromFlowDoc %>" === "1";
    
        <%if(!isIE.equals("true")){%>
		    if(!checkIWebPlugin()){
		        window.location.href="/wui/common/page/sysRemind.jsp?labelid=5";
		    };
        <%}%>

        showPrompt("<%=SystemEnv.getHtmlLabelName(18974,languageId)%>");
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


        //weaver.WebOffice.WebUrl="<%=mServerUrl%>"
        document.body.scroll = "no";
        document.title="<%=SystemEnv.getHtmlLabelName(1986,languageId)%>";
        window.status="<%=SystemEnv.getHtmlLabelName(1986,languageId)%>";
        //确定菜单类型 
        var menuType=[];
        if ("<%=docType%>"!=".htm"){
        	menuType.push({ text: 'HTML&nbsp;<%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>',  iconCls: 'btn_html',
        		handler:function(){onChangeDocType('/docs/docs/DocAdd.jsp','.htm')}
        	});
        }
        if ("<%=docType%>"!=".doc"){
        	menuType.push({ text: 'Word&nbsp;<%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>',  iconCls: 'btn_word',
        	    handler:function(){onChangeDocType('/docs/docs/DocAddExt.jsp','.doc')}
			});
        }
        if ("<%=docType%>"!=".xls"){
        	menuType.push({ text: 'Excel&nbsp;<%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>',  iconCls:'btn_excel',
				handler:function(){onChangeDocType('/docs/docs/DocAddExt.jsp','.xls')}
			});
        }
        
        if ("<%=docType%>"!=".wps"){
        	menuType.push({ text: 'WPS&nbsp;<%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>',  iconCls:'btn_wps',
				handler:function(){onChangeDocType('/docs/docs/DocAddExt.jsp','.wps')}
			});
        }
<%if("1".equals(isUseET)){%>
        if ("<%=docType%>"!=".et"){
        	menuType.push({ text: 'Et&nbsp;<%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>',  iconCls:'btn_et',
				handler:function(){onChangeDocType('/docs/docs/DocAddExt.jsp','.et')}
			});
        }
<%}%>		
        try{
             if ("<%=docType%>"==".ppt"){
                  weaver.WebOffice.ProgName="powerpoint.show";
             }

             //添加菜单
             //分离改造   19718替换为615	19719替换为220
            
              
            weaver.WebOffice.ShowMenu="1";
            weaver.WebOffice.AppendMenu("1","<%=SystemEnv.getHtmlLabelName(615,languageId)%>(&S)");
            
            if (!<%=isPersonalDoc%>){
                weaver.WebOffice.AppendMenu("2","<%=SystemEnv.getHtmlLabelName(220,languageId)%>(&D)");
            }

            //weaver.WebOffice.AppendMenu("4","页眉(&H)");
            
            
            
            weaver.WebOffice.AppendMenu("5","<%=SystemEnv.getHtmlLabelName(16381,languageId)%>");
            
            weaver.WebOffice.AppendMenu("6","<%=SystemEnv.getHtmlLabelName(16382,languageId)%>");
            
            weaver.WebOffice.AppendMenu("7","<%=SystemEnv.getHtmlLabelName(16383,languageId)%>(&G)");
            
			if(!fromFlowDoc && docType !== ".htm") {
				weaver.WebOffice.AppendMenu("81","HTML "+"<%=SystemEnv.getHtmlLabelName(58,languageId)%>");
			}
			if(!fromFlowDoc && docType !== ".doc") {
				weaver.WebOffice.AppendMenu("82","DOC "+"<%=SystemEnv.getHtmlLabelName(58,languageId)%>");
			}
			if(!fromFlowDoc && docType !== ".docx") {
				weaver.WebOffice.AppendMenu("83","DOCX "+"<%=SystemEnv.getHtmlLabelName(58,languageId)%>");
			}
			if(!fromFlowDoc && docType !== ".xls") {
				weaver.WebOffice.AppendMenu("84","XLS "+"<%=SystemEnv.getHtmlLabelName(58,languageId)%>");
			}
			if(!fromFlowDoc && docType !== ".xlsx") {
				weaver.WebOffice.AppendMenu("85","XLSX "+"<%=SystemEnv.getHtmlLabelName(58,languageId)%>");
			}
			if(!fromFlowDoc && docType !== ".wps") {
				weaver.WebOffice.AppendMenu("86","WPS "+"<%=SystemEnv.getHtmlLabelName(58,languageId)%>");
			}
            
            weaver.WebOffice.AppendMenu("11","-");

            weaver.WebOffice.WebUrl="<%=mServerUrl%>";
            weaver.WebOffice.RecordID="-1";
            weaver.WebOffice.Template="<%=(mouldType==1?"":docmodule)%>";
            weaver.WebOffice.FileName="";
	        try{
				weaver.WebOffice.Compatible  = false;
            }catch(e){
            }
            weaver.WebOffice.FileType="<%=docType%>";
			
			<% 
			if(Util.getIntValue(docmodule,0) > 0) { 
				String isCompellentMark = "0";//是否必须显示痕迹
				String isHideTheTraces="0";//编辑正文时默认隐藏痕迹
				RecordSet.executeSql("select * from workflow_createdoc where workflowId="+workflowid);
				if(RecordSet.next()){
					isCompellentMark = Util.null2String(RecordSet.getString("iscompellentmark"));
					isHideTheTraces = Util.null2String(RecordSet.getString("isHideTheTraces"));
				}
				String hideOrShowTraces = "1".equals(isHideTheTraces) ? "0" : "1";// "0" 不显示痕迹， "1" 显示痕迹
				String keepTraces = "1".equals(isCompellentMark) ? "1" : "0"; // "0" 不保留痕迹， "1" 保留痕迹
				RecordSet.writeLog("DocAddExt.jsp hideOrShowTraces="+hideOrShowTraces+",keepTraces="+keepTraces);
			%>
				weaver.WebOffice.EditType="-1,0,<%=hideOrShowTraces %>,<%=keepTraces %>,0,0,1";
			<% } else { %>
				weaver.WebOffice.EditType="1<%=canPostil%>";
			<% } %>
			
			<%if(isIWebOffice2006 == true){%>
			  weaver.WebOffice.ShowToolBar="0";      //ShowToolBar:是否显示工具栏:1显示,0不显示
			<%}%>

            weaver.WebOffice.MaxFileSize = <%=maxOfficeDocFileSize%> * 1024; 
            weaver.WebOffice.UserName="<%=user.getUsername()%>";
            weaver.WebOffice.WebSetMsgByName("USERID","<%=user.getUID()%>");
<%if(user.getLanguage()==7){%>
            weaver.WebOffice.Language="CH";
<%}else if(user.getLanguage()==9){%>
            weaver.WebOffice.Language="TW";
<%}else{%>
            weaver.WebOffice.Language="EN";
<%}%>
<%if(docType.equals(".xls")||docType.equals(".xlsx")){%>
	    try{
			  weaver.WebOffice.ShowStatus = true;
        }catch(e){
        }
<%}%>
            weaver.WebOffice.WebOpen();  	//打开该文档
            weaver.WebOffice.WebObject.Saved=true;//added by cyril on 2008-06-10 检测文档是否被修改用
            <%if(!editMouldIdAndSecCategoryId.equals("")){%>				
		      document.getElementById("WebOffice").WebSetMsgByName("ISEDITMOULD","TRUE");
		      document.getElementById("WebOffice").WebSetMsgByName("EDITMOULDID","<%=docmodule%>");
		      document.getElementById("WebOffice").WebSetMsgByName("REQUESTID","<%=requestid%>");
		      document.getElementById("WebOffice").WebSetMsgByName("WORKFLOWID","<%=workflowid%>");
		      document.getElementById("WebOffice").WebSetMsgByName("LANGUAGEID","<%=languageId%>");
			  document.getElementById("WebOffice").WebSetMsgByName("SHOWDOCMOULDBOOKMARK","<%=fromFlowDoc%>");//载入是否显示“文档模板书签表”数据,这根据“是否来源于流程建文挡”来确定。
		      document.getElementById("WebOffice").WebLoadBookMarks();//替换书签
		<%}%>  
<%if(isIWebOffice2006 == true){%>
//iWebOffice2006 特有内容开始
  weaver.WebOffice.ShowType="1";  //文档显示方式  1:表示文字批注  2:表示手写批注  0:表示文档核稿
//iWebOffice2006 特有内容结束
<%}%>             
weaver.WebOffice.DisableMenu("<%=SystemEnv.getHtmlLabelName(20757,user.getLanguage())%>");
weaver.WebOffice.WebToolsEnable('Standard',109,false);
            weaver.WebOffice.WebToolsVisible("iSignature",false);//隐藏盖章按钮 
            StatusMsg(weaver.WebOffice.Status);

        }catch(e){}

     //TD4213 增加提示信息  开始
     //oPopup.hide();
     hiddenPrompt();
     //TD4213 增加提示信息  结束
     
	//WebToolsEnable('Standard',109,true);StatusMsg('ok');
     
    }

function onLoadEnd(){

    try{
       
    }catch(e){
    }
}

    function UnLoad(){
    try{
    if (!weaver.WebOffice.WebClose()){
    StatusMsg(weaver.WebOffice.Status);
    }else{
    StatusMsg("<%=SystemEnv.getHtmlLabelName(19716,languageId)%>...");
    }
    }catch(e){}
    }

    function WebOpenSignature(){
    try{
    weaver.WebOffice.WebOpenSignature();
    StatusMsg(weaver.WebOffice.Status);
    return true;
    }catch(e){
    return false;
    }
    }

function openByDocType(type) {
	var from = "<%=from %>";
	var userCategory = "<%=userCategory %>";
	//alert("type="+type +",from="+from+",userCategory="+userCategory);
	if(".htm" === type) {
		onChangeDocType("DocAdd.jsp?from="+from+"&userCategory="+userCategory,type);
	} else if(".doc" === type) {
		onChangeDocType("DocAddExt.jsp?from="+from+"&userCategory="+userCategory,type);
	} else if(".docx" === type) {
		onChangeDocType("DocAddExt.jsp?from="+from+"&userCategory="+userCategory,type);
	} else if(".xls" === type) {
		onChangeDocType("DocAddExt.jsp?from="+from+"&userCategory="+userCategory,type);
	} else if(".xlsx" === type) {
		onChangeDocType("DocAddExt.jsp?from="+from+"&userCategory="+userCategory,type);
	} else if(".wps" === type) {
		onChangeDocType("DocAddExt.jsp?from="+from+"&userCategory="+userCategory,type);
	}
}
function WebToolsVisible(ToolName,Visible){
  try{
    weaver.WebOffice.WebToolsVisible(ToolName,Visible);
    StatusMsg(weaver.WebOffice.Status);
  }catch(e){}
}

    function WebToolsEnable(ToolName,ToolIndex,Enable){
    try{
    weaver.WebOffice.WebToolsEnable(ToolName,ToolIndex,Enable);
    StatusMsg(weaver.WebOffice.Status);
    }catch(e){}
    }

   function protectDoc(){
    	//modified by cyril on 2008-06-10 for TD:8828
    	var Modify = weaver.WebOffice.WebObject.Saved;   	
    	if(!Modify || !checkDataChange()) {
    	  event.returnValue="<%=SystemEnv.getHtmlLabelName(19006,languageId)%>";
    	}
    }
    
    /**added by cyril on 2008-07-02 for TD:8921**/
    function protectDoc_include() {
    	var Modify = weaver.WebOffice.WebObject.Saved;
    	if(!Modify || !checkDataChange()) {
			if(!confirm('<%=SystemEnv.getHtmlLabelName(19006,languageId)%>'))
    			document.getElementById('onbeforeunload_protectDoc_return').value = 0;//检测不通过
    		else 
    			document.getElementById('onbeforeunload_protectDoc_return').value = 1;//检测通过
    	}
    }
    /**end added by cyril on 2008-07-02 for TD:8921**/
function onChangeDocTypeHtml(){
	onChangeDocType('/docs/docs/DocAdd.jsp','.html');
}

function onChangeDocTypeDoc(){
	onChangeDocType('/docs/docs/DocAddExt.jsp','.doc');
}
function onChangeDocTypeDocx(){
	onChangeDocType('/docs/docs/DocAddExt.jsp','.docx');
}
function onChangeDocTypeXls(){
	onChangeDocType('/docs/docs/DocAddExt.jsp','.xls');
}
function onChangeDocTypeXlsx(){
	onChangeDocType('/docs/docs/DocAddExt.jsp','.xlsx');
}
function onChangeDocTypeWps(){
	onChangeDocType('/docs/docs/DocAddExt.jsp','.wps');
}
function onChangeDocTypeEt(){
	onChangeDocType('/docs/docs/DocAddExt.jsp','.et');
}

   function wfchangetab(){
    	var Modify = weaver.WebOffice.WebObject.Saved;   	
    	if(!Modify || !checkDataChange()) {
    	  return true;
    	}else{
    	  return false;
    	}
    }

function onChanageShowMode(){
	/*if(DocInfoWindow.style.display == ""){
		DocInfoWindow.style.display = "none";

	}
	else{
		DocInfoWindow.style.display = "";
	}*/

}


</script>
<script language="javascript" src="/js/doc/DocAddScript_wev8.js"></script>
<Title id="Title"></Title>
</head>

<body class="ext-ie ext-ie8 x-border-layout-ct" id="mybody" scroll="no" onunload="UnLoad()" onbeforeunload="protectDoc()" oncontextmenu="doNothing()">

<FORM id=weaver name=weaver action="UploadDoc.jsp?fromFlowDoc=<%=fromFlowDoc%>&workflowid=<%=workflowid%>" method=post  enctype="multipart/form-data">
<!--该参数必须作为Form的第一个参数,并且不能在其他地方调用，用于解决在IE6.0中输入·这个特殊符号存在的问题-->
<INPUT TYPE="hidden" id="docIdErrorError" NAME="docIdErrorError" value="">
<%@ include file="/systeminfo/DocTopTitle.jsp"%>
<input type="hidden" name="onbeforeunload_protectDoc" onclick="protectDoc_include()"/>
<input type="hidden" name="onbeforeunload_protectDoc_return"/>
<input id="f_weaver_belongto_userid" name="f_weaver_belongto_userid" type="hidden" value="<%=f_weaver_belongto_userid%>">
<input id="f_weaver_belongto_usertype" name="f_weaver_belongto_usertype" type="hidden" value="<%=f_weaver_belongto_usertype%>">

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

if(("1").equals(fromFlowDoc)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	if(countNum > 1 && mouldSecCategoryId>0){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(18167,user.getLanguage())+",javascript:selectTemplate(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
} else {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSave(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;

	if (!isPersonalDoc){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(220,user.getLanguage())+",javascript:onDraft(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		
	}
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(16381,user.getLanguage())+",javascript:WebOpenLocal(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(16382,user.getLanguage())+",javascript:WebSaveLocal2(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;

	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(16383,user.getLanguage())+",javascript:WebOpenSignature(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;

	int tmpindex = 0;
	if (!"1".equals(fromFlowDoc) && !docType.equals(".htm")){
		RCMenu += "{HTML&nbsp;"+SystemEnv.getHtmlLabelName(58,user.getLanguage())+",javascript:onChangeDocTypeHtml(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	if (!"1".equals(fromFlowDoc) && !docType.equals(".doc")){	
		RCMenu += "{DOC&nbsp;"+SystemEnv.getHtmlLabelName(58,user.getLanguage())+",javascript:onChangeDocTypeDoc(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	if (!"1".equals(fromFlowDoc) && !docType.equals(".docx")){	
		RCMenu += "{DOCX&nbsp;"+SystemEnv.getHtmlLabelName(58,user.getLanguage())+",javascript:onChangeDocTypeDocx(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	if (!"1".equals(fromFlowDoc) && !docType.equals(".xls")){	
		RCMenu += "{XLS&nbsp;"+SystemEnv.getHtmlLabelName(58,user.getLanguage())+",javascript:onChangeDocTypeXls(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	if (!"1".equals(fromFlowDoc) && !docType.equals(".xlsx")){	
		RCMenu += "{XLSX&nbsp;"+SystemEnv.getHtmlLabelName(58,user.getLanguage())+",javascript:onChangeDocTypeXlsx(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	if (!"1".equals(fromFlowDoc) && !docType.equals(".wps")){	
		RCMenu += "{WPS&nbsp;"+SystemEnv.getHtmlLabelName(58,user.getLanguage())+",javascript:onChangeDocTypeWps(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}

    if("1".equals(isUseET)){
	    if (!docType.equals(".et")){	
	    	RCMenu += "{ET&nbsp;"+SystemEnv.getHtmlLabelName(58,user.getLanguage())+",javascript:onChangeDocTypeEt(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	     }
	}

}
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
//文档的id 插件提交文档后设置这个值
%>
<INPUT TYPE="hidden" id="docId" NAME="docId" value="">
<INPUT TYPE="hidden" id="docType" NAME="docType" value="<%=docType%>">
<input type="hidden" name="operation">
<input type="hidden" name="SecId" id="SecId" value="<%=secid%>">

<script>
    function onSelectCategory(whichcategory) {
    	var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp?operationcode=<%=MultiAclManager.OPERATION_CREATEDOC%>");
    	if (result != null) {
    		if (result[0] > 0)  {
    			location = "DocAddExt.jsp?secid="+result[1]+"&fromFlowDoc=<%=fromFlowDoc%>&requestid=<%=requestid%>&showsubmit=<%=showsubmit%>&prjid=<%=prjid%>&crmid=<%=crmid%>&hrmid=<%=hrmid%>&from=<%=from%>&docsubject="+weaver.docsubject.value+"&invalidationdate=<%=invalidationdate%>";
    		}
    	}
    }
function onBtnSearchClick(){}
var __DocAddExtPage = true;
function getGotoPage(doPage,docType){
	if(doPage.indexOf("?") > 0) {
		return doPage+"&secid="+jQuery("#seccategory").val()+"&topage=<%=tmptopage%>&showsubmit=<%=showsubmit%>&prjid=<%=prjid%>&coworkid=<%=coworkid%>&crmid=<%=crmid%>&hrmid=<%=hrmid%>&docType="+docType+"&docsubject="+encodeURIComponent(encodeURIComponent(weaver.docsubject.value))+"&from=<%=from%>&userCategory=<%=userCategory%>&invalidationdate=<%=invalidationdate%>";
	} else {
		return doPage+"?secid="+jQuery("#seccategory").val()+"&topage=<%=tmptopage%>&showsubmit=<%=showsubmit%>&prjid=<%=prjid%>&coworkid=<%=coworkid%>&crmid=<%=crmid%>&hrmid=<%=hrmid%>&docType="+docType+"&docsubject="+encodeURIComponent(encodeURIComponent(weaver.docsubject.value))+"&from=<%=from%>&userCategory=<%=userCategory%>&invalidationdate=<%=invalidationdate%>";
	}
}
jQuery(document).ready(function(){
	 jQuery("div#divTab").show();
	 <%if(secid<=0){%>
	 	jQuery("#divPropATab").addClass("x-tab-strip-div-disabled").hide();
	 	jQuery("#divAccATab").addClass("x-tab-strip-div-disabled").hide();
	 <%}else{%>
	 	loadPropAndAcc(<%=secid%>);
	 <%}%>
});
</script>
<%--<input type=hidden name=docapprovable value="<%=needapprovecheck%>">--%>
<input type="hidden" name="docreplyable" value="<%=replyable%>">
<input type="hidden" name="usertype" value="<%=usertype%>">
<input type="hidden" name="from">
<input type="hidden" name="source" id="source" value="DocAddExt">
<input type="hidden" name="userCategory">
<input type="hidden" name="userId" value="<%=user.getUID()%>">
<input type="hidden" name="userType" value="<%=user.getLogintype()%>">

<input type="hidden" name="docstatus" value="0">
<input type="hidden" name="doccode" value="<%=docCode%>">
<input type="hidden" name="docedition" value="-1">
<input type="hidden" name="doceditionid" value="-1">
<input type="hidden" name="maincategory" value="<%=(mainid==-1?"":Integer.toString(mainid))%>">
<INPUT type="hidden" name="subcategory" value="<%=(subid==-1?"":Integer.toString(subid))%>">
<INPUT type="hidden" name="seccategory" id="seccategory" value="<%=(secid==-1?"":Integer.toString(secid))%>">
<input type="hidden" name="ownerid" value="<%=ownerid%>">
<input type="hidden" name="docdepartmentid" value="<%=docdepartmentid%>">
<input type="hidden" name="doclangurage" value="<%=languageId%>">
<INPUT type="hidden" name="maindoc" id="maindoc" value="-1">

<input type=hidden name=topage value="<%=topage%>">

<input type=hidden name="requestid" value=<%=requestid%>>
<input type=hidden name="workflowid" value=<%=workflowid%>>
<input type=hidden name="editMouldId" value="<%=docmodule%>">
<input type=hidden id="selectedpubmouldid" name=selectedpubmouldid value="<%=docmodule%>">

<div style="display:none;">
		<brow:browser name="__selectTaohongMould" viewType="0" getBrowserUrlFn="getBrowserUrlFn" getBrowserUrlFnParams='<%=""+secid%>'
			_callback="afterSelectMould" browserBtnID="selectTaohongMouldBtn" isMustInput="1"></brow:browser>
	</div>
<div style="position: absolute; left: 0; top: 0; width:100%;height:100%;">

<div id="divContentTab" style="width:100%;height:100%;">
	<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(("1").equals(fromFlowDoc)){ %>
				<input type=button class="e8_btn_top" onclick="onSave();" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
				<input type=button class="e8_btn_top" onclick="backToForm();" value="<%=SystemEnv.getHtmlLabelName(129071, user.getLanguage())%>"></input>
				<%if(countNum > 1){%>
				<input type=button id="thModeS_id" style="display:"  class="e8_btn_top" onclick="selectTemplate2(<%= secid %>,<%=docmodule %>)" value="<%=SystemEnv.getHtmlLabelName(375, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(16449, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(172, user.getLanguage())%>"></input>
			<%}}else{ %>
				<input type=button class="e8_btn_top" onclick="onSave();" value="<%=SystemEnv.getHtmlLabelName(615, user.getLanguage())%>"></input>
			<%} %>
			<%if (!isPersonalDoc && !"1".equals(fromFlowDoc)){ %>
				<input type=button class="e8_btn_top" onclick="onDraft();" value="<%=SystemEnv.getHtmlLabelName(220, user.getLanguage())%>"></input>
			
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
	   <jsp:param name="docsubject" value='<%=URLEncoder.encode(docsubject,"UTF-8") %>'/>
	   <jsp:param name="fromFlowDoc" value="<%=fromFlowDoc %>"/>
	   <jsp:param name="_fromURL" value="doc"/>
	   <jsp:param name="limitSec" value='<%=Util.null2String(request.getParameter("limitSec")) %>'/>
	 </jsp:include>
	<%-- 文档标题 start --%>
    	<script type="text/javascript">
				var isChecking = false;
				var prevValue = "";
				
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
							return false;
					}
					isChecking = true; 
					//var subject = encodeURIComponent(obj.value);	
					var subject = obj.value;						
					var url = 'DocSubjectCheck.jsp';
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
								secid:jQuery("#seccategory").val(),
								f_weaver_belongto_userid:"<%=f_weaver_belongto_userid%>",
					            f_weaver_belongto_usertype:"<%=f_weaver_belongto_usertype%>"
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
	<input type="hidden" name="needinputitems" id="needinputitems" value="<%=needinputitems %>"/>
	<%-- 文档标题 end --%>
	
	<div id="divContent" style="width:100%;margin:0 auto;overflow:hidden;">
		<%-- iWebOffice编辑控件 start --%>
		<iframe id="e8shadowifrm" name="e8shadowifrm" frameborder="none" scrolling="no" style="overflow:hidden;z-index:1;width:100%;height:23px;position:absolute;top:37px;visibility:hidden;left:0px;background-color:#fff;" src="javascript:return false;"></iframe>
		<div id="divContentInfo" class="e8_propTab " style="width:100%;height:100%;">
			<table cellpadding="0" cellspacing="0" style="width:100%;height:100%;">
				<tr><td bgcolor=menu style="vertical-align:top;position:relative;">
				    <OBJECT id="WebOffice" classid="<%=mClassId%>" style="POSITION:absolute;width:0;height:0;top:-23px;filter='progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0)';" codebase="<%=mClientUrl%>" >
					</OBJECT>
				</td></tr>
			</table>
		</div>
		<%-- iWebOffice编辑控件 end --%>
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
				<iframe id="e8DocAccIfrm" style="border:none;"  src="javascript:false;" frameborder="0" width="100%" height="100%"></iframe>
				</DIV>
			</div>
			<!-- 文档附件栏 end -->
		</div>


<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</div>
<div style="position:relative;">
	<!-- 底部选项卡栏 start -->
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

<div id="divFavContent18886" style="display:none">
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
		<tr height="22">
			<td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(18886,languageId)%>
			</td>
		</tr>
	</table>
</div>

<div id="divFavContent18974" style="display:none">
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
		<tr height="22">
			<td style="font-size:9pt">owi<%=SystemEnv.getHtmlLabelName(18974,languageId)%>
			</td>
		</tr>
	</table>
</div>
<!--TD4213 增加提示信息  结束-->

<input type="text" style="display:none" name="txtDocTitle" id="txtDocTitle" TABINDEX="1" style="position:absolute" onBlur="docsubject.value=this.value;docsubject.fireEvent('onBlur');">

<input type="hidden" name="imageidsExt"  id="imageidsExt">
<input type="hidden" name="imagenamesExt"  id="imagenamesExt">
<input type="hidden" name="delImageidsExt"  id="delImageidsExt">

   </div>
</div>	
</FORM>
 
</body>

</html>

<jsp:include page="/docs/docs/DocComponents.jsp">
	<jsp:param value="<%=user.getLanguage()%>" name="language"/>
	<jsp:param value="getBase" name="operation"/>
</jsp:include>

<script language="javascript" type="text/javascript">
var maxUploadImageSize="<%=maxUploadImageSize%>";
var doctype="<%=docType%>";
var isFromWf=<%=("1").equals(fromFlowDoc)%>;
var fromFlowDoc="<%=fromFlowDoc%>";
var languageid="<%=user.getLanguage()%>";

function adjustContentHeight(type){
	var lang=<%=(user.getLanguage()==8)?"true":"false"%>;
	try{
		var propTabHeight = 34;
		if(document.getElementById("divPropTab")&&document.getElementById("divPropTab").style.display=="none") propTabHeight = (isFromWf)?10:34;
		
		var pageHeight=document.body.clientHeight;
		var pageWidth=document.body.clientWidth;
		
		//document.getElementById("divContentTab").style.height = pageHeight - propTabHeight;
		if(isFromWf) propTabHeight += 25;
		jQuery("#divContentTab").height(pageHeight - propTabHeight);
		jQuery(".e8_box").height(pageHeight - propTabHeight);
		if(isFromWf) propTabHeight -= 50;
		jQuery(".tab_box").height(pageHeight - propTabHeight-jQuery(".e8_boxhead").height());
		var divContentHeight=jQuery(".tab_box").height();
		if(isFromWf) divContentHeight += 25;
		
		var divContentWidth=pageWidth;
		if(divContentHeight!=null && divContentHeight>0){
			/*document.getElementById("divContent").style.height=divContentHeight;
			document.getElementById("divContent").style.width=divContentWidth;
			document.getElementById("WebOffice").style.height=divContentHeight + 23;
			document.getElementById("WebOffice").style.width=divContentWidth;*/
			jQuery("#divContent").height(divContentHeight);
			jQuery("#divContent").width(divContentWidth);
			jQuery("#WebOffice").height(divContentHeight);
			jQuery("#WebOffice").width(divContentWidth);
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

function onActiveTab(tab,notOpen){
		if(jQuery("#"+tab+"ATab").hasClass("x-tab-strip-div-disabled")){
			return false;
		}
	lastTab = tab;
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
		//eval("doGet"+tab+"();");
		onResizeDiv();
	} catch(e){
		if(window.console){console.log(e);}
	}
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
}

function doNothing(){  
    window.event.returnValue=false;  
    return false;
}
jQuery(document).ready(
	function(){
	<%if(fromFlowDoc.equals("1") && (docType.equals(".doc")||docType.equals(".xls")||docType.equals(".wps")||docType.equals(".et"))){%>
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

			//onActiveTab("divProp",true);
			setE8ShadowPosition("divContentInfo");
			
			//document.getElementById('rightMenu').style.visibility="hidden";
			document.getElementById("divMenu").style.display='';	
		} catch(e){}

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
<%@ include file="DocAddExtScript.jsp" %>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
