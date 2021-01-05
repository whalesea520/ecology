
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.file.Prop" %>
<%@ page import="weaver.docs.docs.ShareManageDocOperation" %>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryManager" class="weaver.docs.category.SecCategoryManager" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryDocTypeComInfo" class="weaver.docs.category.SecCategoryDocTypeComInfo" scope="page" />
<jsp:useBean id="DocTypeComInfo" class="weaver.docs.type.DocTypeComInfo" scope="page" />
<jsp:useBean id="DocMouldComInfo" class="weaver.docs.mould.DocMouldComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="SysDefaultsComInfo" class="weaver.docs.tools.SysDefaultsComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="HrmOrgGroupComInfo" class="weaver.hrm.orggroup.HrmOrgGroupComInfo" scope="page" />
<jsp:useBean id="scc" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<HTML><HEAD>
<% 
	String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<script type="text/javascript">

function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}
function reloadPage(){
		window.location.reload();
	}
<%if("1".equals(isDialog)){%>
	var refreshDialog = true;
<%}%>
</script>
</head>
<%
String pageSize = PageIdConst.getPageSize(PageIdConst.DOC_SECCATEGORCOPYRIGHT,user.getUID(),PageIdConst.DOC);
String pageId = PageIdConst.DOC_SECCATEGORCOPYRIGHT;
int[] labels = {58,125,385};
String titlename = "";
MultiAclManager am = new MultiAclManager();
int id = Util.getIntValue(request.getParameter("id"),0);
int messageid = Util.getIntValue(request.getParameter("message"),0);
int errorcode = Util.getIntValue(request.getParameter("errorcode"),0);
CategoryManager cm = new CategoryManager();
String  operateString= "";
String sqlWhere = "";
String tabletype="none";
String tableString = "";
labels[1] = 77;
 int categorytype = MultiAclManager.CATEGORYTYPE_SEC;
 int operationcode = MultiAclManager.OPERATION_COPYDOC;
 String intanceid = "copyPermission";
	RecordSet.executeProc("Doc_SecCategory_SelectByID",id+"");
	RecordSet.next();
	String categoryname=Util.toScreenToEdit(RecordSet.getString("categoryname"),user.getLanguage());
	String coder=Util.toScreenToEdit(RecordSet.getString("coder"),user.getLanguage());
	String subcategoryid=RecordSet.getString("subcategoryid");
	String docmouldid=RecordSet.getString("docmouldid");
	/* added by wdl 2006.7.3 TD.4617 start */
	String wordmouldid = RecordSet.getString("wordmouldid");
	/* added end */
	String publishable=RecordSet.getString("publishable");
	String replyable=RecordSet.getString("replyable");
	String shareable=RecordSet.getString("shareable");

	String cusertype=RecordSet.getString("cusertype");
	String cuserseclevel=RecordSet.getString("cuserseclevel");
	if(cuserseclevel.equals("255")) cuserseclevel="";
	String cdepartmentid1=RecordSet.getString("cdepartmentid1");
	String cdepseclevel1=RecordSet.getString("cdepseclevel1");
	if(cdepseclevel1.equals("255")) cdepseclevel1="";
	String cdepartmentid2=RecordSet.getString("cdepartmentid2");
	String cdepseclevel2=RecordSet.getString("cdepseclevel2");
	if(cdepseclevel2.equals("255")) cdepseclevel2="";
	String croleid1=RecordSet.getString("croleid1");
	String crolelevel1=RecordSet.getString("crolelevel1");
	String croleid2=RecordSet.getString("croleid2");
	String crolelevel2=RecordSet.getString("crolelevel2");
	String croleid3=RecordSet.getString("croleid3");
	String crolelevel3=RecordSet.getString("crolelevel3");
	String approvewfid=RecordSet.getString("approveworkflowid");
	String hasaccessory=RecordSet.getString("hasaccessory");
	String accessorynum=RecordSet.getString("accessorynum");
	String hasasset=RecordSet.getString("hasasset");
	String assetlabel=RecordSet.getString("assetlabel");
	String hasitems=RecordSet.getString("hasitems");
	String itemlabel=RecordSet.getString("itemlabel");
	String hashrmres=RecordSet.getString("hashrmres");
	String hrmreslabel=RecordSet.getString("hrmreslabel");
	String hascrm=RecordSet.getString("hascrm");
	String crmlabel=RecordSet.getString("crmlabel");
	String hasproject=RecordSet.getString("hasproject");
	String projectlabel=RecordSet.getString("projectlabel");
	String hasfinance=RecordSet.getString("hasfinance");
	String financelabel=RecordSet.getString("financelabel");

    int markable=Util.getIntValue(Util.null2String(RecordSet.getString("markable")),0);
    int markAnonymity=Util.getIntValue(Util.null2String(RecordSet.getString("markAnonymity")),0);
    int orderable=Util.getIntValue(Util.null2String(RecordSet.getString("orderable")),0);
    int defaultLockedDoc=Util.getIntValue(Util.null2String(RecordSet.getString("defaultLockedDoc")),0);
    int isSetShare=Util.getIntValue(Util.null2String(RecordSet.getString("isSetShare")),0);
	int mainid = Util.getIntValue(SubCategoryComInfo.getMainCategoryid(subcategoryid),0);
    
    int maxUploadFileSize=Util.getIntValue(Util.null2String(RecordSet.getString("maxUploadFileSize")),0);
    int allownModiMShareL=Util.getIntValue(Util.null2String(RecordSet.getString("allownModiMShareL")),0);
    int allownModiMShareW=Util.getIntValue(Util.null2String(RecordSet.getString("allownModiMShareW")),0);
    String allowShareTypeStrs=Util.null2String(RecordSet.getString("allowShareTypeStrs"));
    ArrayList allowShareTypeList = Util.TokenizerString(allowShareTypeStrs,",");
    
    int noDownload = Util.getIntValue(Util.null2String(RecordSet.getString("nodownload")),0);
    int noRepeatedName = Util.getIntValue(Util.null2String(RecordSet.getString("norepeatedname")),0);
    int isControledByDir = Util.getIntValue(Util.null2String(RecordSet.getString("iscontroledbydir")),0);
    int pubOperation = Util.getIntValue(Util.null2String(RecordSet.getString("puboperation")),0);
    int childDocReadRemind = Util.getIntValue(Util.null2String(RecordSet.getString("childdocreadremind")),0);
    int readOpterCanPrint = Util.getIntValue(Util.null2String(RecordSet.getString("readoptercanprint")),0);

    float secorder = Util.getFloatValue(Util.null2String(RecordSet.getString("secorder")),0);

	boolean canEdit = false;
	boolean canAdd = false;
	boolean canDelete = false;
	boolean canLog = false;
	boolean hasSubManageRight = false;
	boolean hasSecManageRight = false;
	//hasSubManageRight = am.hasPermission(mainid, MultiAclManager.CATEGORYTYPE_MAIN, user, MultiAclManager.OPERATION_CREATEDIR);
	int parentId = Util.getIntValue(scc.getParentId(""+id));
	if(parentId>0){
		hasSecManageRight = am.hasPermission(parentId, MultiAclManager.CATEGORYTYPE_SEC, user, MultiAclManager.OPERATION_CREATEDIR);
	}
	//hasSecManageRight = am.hasPermission(Integer.parseInt(subcategoryid.equals("")?"-1":subcategoryid), MultiAclManager.CATEGORYTYPE_SUB, user, MultiAclManager.OPERATION_CREATEDIR);
	if (HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit", user) ||  hasSecManageRight){
	    canEdit = true;
    }
    if (HrmUserVarify.checkUserRight("DocSecCategoryAdd:Add", user) ||  hasSecManageRight){
        canAdd = true;
    }
    if (HrmUserVarify.checkUserRight("DocSecCategoryEdit:Delete", user)|| hasSecManageRight) {
        canDelete = true;
    }
    if (HrmUserVarify.checkUserRight("DocSecCategory:log", user) || hasSecManageRight) {
        canLog = true;
    }


String isdisplay="";
String ischeck="";

//求分目录中文档创建者相关的权限
String PCreater = "3";
String PCreaterManager = "1";
String PCreaterJmanager = "1";
String PCreaterDownOwner = "0";
String PCreaterSubComp = "0";
String PCreaterDepart = "0";
String PCreaterDownOwnerLS = "0";
String PCreaterSubCompLS = "0";
String PCreaterDepartLS = "0";

String PCreaterW = "3";
String PCreaterManagerW = "1";
String PCreaterJmanagerW = "1";

/** TD12005 文档下载权限控制    开始 */
String PCreaterDL = "1";
String PCreaterManagerDL = "1";
String PCreaterSubCompDL = "0";
String PCreaterDepartDL = "0";
String PCreaterWDL = "1";
String PCreaterManagerWDL = "1";
/** TD12005 文档下载权限控制   结束 */

RecordSet1.executeSql("select * from secCreaterDocPope where secid = "+id);
if (RecordSet1.next()) {
    PCreater = Util.null2String(RecordSet1.getString("PCreater"));
    PCreaterManager = Util.null2String(RecordSet1.getString("PCreaterManager"));
    PCreaterJmanager = Util.null2String(RecordSet1.getString("PCreaterJmanager"));
    PCreaterDownOwner = Util.null2String(RecordSet1.getString("PCreaterDownOwner"));
    PCreaterSubComp = Util.null2String(RecordSet1.getString("PCreaterSubComp"));
    PCreaterDepart = Util.null2String(RecordSet1.getString("PCreaterDepart"));
    PCreaterDownOwnerLS = Util.null2String(RecordSet1.getString("PCreaterDownOwnerLS"));   
    PCreaterSubCompLS = Util.null2String(RecordSet1.getString("PCreaterSubCompLS"));   
    PCreaterDepartLS = Util.null2String(RecordSet1.getString("PCreaterDepartLS"));
    PCreaterW = Util.null2String(RecordSet1.getString("PCreaterW"));
    PCreaterManagerW = Util.null2String(RecordSet1.getString("PCreaterManagerW"));
    PCreaterJmanagerW = Util.null2String(RecordSet1.getString("PCreaterJmanagerW"));
    /** TD12005 文档下载权限控制    开始 ======数据库添加以下字段========== */
    PCreaterDL = this.setDLValueInit(Util.null2String(RecordSet1.getString("PCreaterDL")), PCreater);
    PCreaterManagerDL = this.setDLValueInit(Util.null2String(RecordSet1.getString("PCreaterManagerDL")), PCreaterManager);
    PCreaterSubCompDL = this.setDLValueInit(Util.null2String(RecordSet1.getString("PCreaterSubCompDL")), PCreaterSubComp);
    PCreaterDepartDL = this.setDLValueInit(Util.null2String(RecordSet1.getString("PCreaterDepartDL")), PCreaterDepart);
    PCreaterWDL = this.setDLValueInit(Util.null2String(RecordSet1.getString("PCreaterWDL")), PCreaterW);
    PCreaterManagerWDL = this.setDLValueInit(Util.null2String(RecordSet1.getString("PCreaterManagerWDL")), PCreaterManagerW);
    /** TD12005 文档下载权限控制   结束 */
}

//是否有效
String isDownloadDisabled = "";
if(noDownload == 1) isDownloadDisabled ="disabled";
if(!canEdit){
	isDownloadDisabled ="disabled";
}

int detachable = ManageDetachComInfo.isUseDocManageDetach()?1:0;
	    if(detachable==1){
			 canEdit = false;
	         canAdd = false;
	         canDelete = false;
	         canLog = false;
	    	if( CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocSecCategoryEdit:Edit",Util.getIntValue(scc.getSubcompanyIdFQ(id+""),0))>0){
			   canEdit = true;
			}
			if( CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocSecCategoryAdd:Add",Util.getIntValue(scc.getSubcompanyIdFQ(id+""),0))>0){
			  canAdd = true;
			}
			if( CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocSecCategoryEdit:Delete",Util.getIntValue(scc.getSubcompanyIdFQ(id+""),0))>0){
			  canDelete = true;
			}
			if( CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocSecCategory:log",Util.getIntValue(scc.getSubcompanyIdFQ(id+""),0))>0){
			   canLog = true;
			}
	    }
%>
<%!
/** TD12005 文档下载权限控制   开始 */
private String getDLVisible(String strValue) {
    //是否可见
    String strShow = "";
    if(!"1".equals(strValue)) strShow ="none";
    return strShow;
}

private String getDLChecked(String strCheckValue) {
    //是否选中
    String strChecked = "";
    if("1".equals(strCheckValue)) strChecked ="checked";
    return strChecked;
}

//根据操作权限，共享下载权限判断最终的下载权限
private String setDLValueInit(String strDLValue, String strOprateValue) {
	String strDLNewValue = "0";
	if (strDLValue != null && !"".equals(strDLValue)) {
		strDLNewValue = strDLValue;
	} else if("1".equals(strOprateValue) || "2".equals(strOprateValue) || "3".equals(strOprateValue)) {
		strDLNewValue = "1";
	} else if("0".equals(strOprateValue)) {
		strDLNewValue = "0";
	}
	return strDLNewValue;
}
/** TD12005 文档下载权限控制   结束 */
%>
<BODY>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.DOC_SECCATEGORCOPYRIGHT %>"/>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

	<form action="" name="searchfrm" id="searchfrm">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
		<%if(canAdd){ %>
			<input id="newRight" type=button class="e8_btn_top" onclick="openDialog(2);" value="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>"></input>
			<input id="delRight" type=button class="e8_btn_top" onclick="onPermissionDelShare<%=operationcode%>();" value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>"></input>
			<%} %>
			<span id="cornerMenu" title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>
<%
if(messageid !=0) {
%>
<DIV><font color="#FF0000"><%=SystemEnv.getHtmlNoteName(messageid,user.getLanguage())%></font></DIV>
<%}%>
<%
if(errorcode == 10) {
%>
	<div><font color="red"><%=SystemEnv.getHtmlLabelName(21999,user.getLanguage()) %></font></div>
<%}%>
<FORM id=weaver name=weaver action="SecCategoryOperation.jsp" method=post>
<input type=hidden name="operation">
<input type=hidden name="id" value="<%=id%>">
<input type=hidden name="fromtab" value="2">
<%if("1".equals(isDialog)){ %>
<input type="hidden" name="isdialog" value="<%=isDialog%>">
<%} %>
<input type=hidden name="fromSecSet" value="right">
<%
//检测是否满足历史文档更新默认共享的条件


//if(HrmUserVarify.checkUserRight("DocSubCategoryEdit:Edit", user)){

Prop prop = Prop.getInstance();  
int panum = Util.getIntValue(prop.getPropValue("isSynchronous" , "panum"),0);	
int isSynchronous = Util.getIntValue(prop.getPropValue("isSynchronous" , "isSynchronous"),0);


boolean issytime=false;
ShareManageDocOperation manager = new ShareManageDocOperation();
int docsecnum=manager.getCountSecDocs(id);
boolean cansharingsy=false;
 for(int tt=0;tt<panum;tt++){
 if((prop.getPropValue("isSynchronous" , "fromtime_"+tt)).compareTo((manager.getOnlyCurrentTimeString()))<0&& (prop.getPropValue("isSynchronous" , "totime_"+tt)).compareTo((manager.getOnlyCurrentTimeString()))>0 &&isSynchronous==1){	
	
		 issytime=true;
		 break;
	 
	
	 
   } 
 }


	 if(isSynchronous==1&&panum==0){
	  cansharingsy=true;
	 }else if(issytime&&isSynchronous==1){	
	  cansharingsy=true;
	 }
 

 

%>
<%
if(canAdd){
RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:openDialog(2),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onPermissionDelShare"+operationcode+"(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%--
<%
}if(canAdd){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:onNew(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(canDelete){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(canLog){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
--%>


        <%@ include file="/docs/category/PermissionList.jsp" %>
        

   <SCRIPT language="javaScript">
       function onSelectChange(obj1,obj2){
            var selectValue = obj1.value;
            if (selectValue!=0) obj2.style.display="";
            else  obj2.style.display="none";           
       }
   
   </SCRIPT>
</form>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script language="javascript">

          var diag_vote = new Dialog();
			diag_vote.Width = 300;
			diag_vote.Height = 100;
			diag_vote.Modal = false;
			diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(20240,user.getLanguage())%>";
			diag_vote.URL = "/docs/docs/ShareProcess.jsp";
				
function onSave(obj){
	obj.disabled = true;
	if(check_form(document.weaver,'categoryname')){
	document.weaver.operation.value="edit";
    //clearTempObj();
	document.weaver.submit();}
}


 function onSynchronous(obj){

	var tanchu=0;

	
		<%if(docsecnum>0){%>    
		  tanchu=1;
		  <%}%>
	if(tanchu==1){
		if(confirm("<%=SystemEnv.getHtmlLabelName(31822,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(30569,user.getLanguage())%><%=docsecnum%><%=SystemEnv.getHtmlLabelName(30570,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(31823,user.getLanguage())%>")){
			 obj.disabled = true;
			diag_vote.show();
			onListen();
			 
         	 				 
		}
		  }else{
			  alert("<%=SystemEnv.getHtmlLabelName(27484,user.getLanguage())%>");
		    return false ;
		  }

       } 

	function onListen(){
			 	
			 	$.ajax({ cache:true,type: "POST",url:"/docs/docs/ShareProcessOperation.jsp?secid="+<%=id%>,
			 	data:$('#weaver').serialize(),// 你的formid              
			 	async: true,        
			  error: function(request) {  
				diag_vote.close();
			  	alert("<%=SystemEnv.getHtmlLabelName(31825,user.getLanguage())%>");              
			  	             
			  	     },              
			  success: function(data) {                
			  	  diag_vote.close();
			  	  alert("<%=SystemEnv.getHtmlLabelName(31439,user.getLanguage())%>");
			  	 
			  	    
			         }          
			         
			     });
			   }

function onNew(){
	window.parent.location="DocSecCategoryAdd.jsp?id=<%=subcategoryid%>&mainid=<%=mainid%>";
}
function onLog(){
	window.parent.location="/systeminfo/SysMaintenanceLog.jsp?secid=66&sqlwhere=<%=xssUtil.put("where operateitem=3 and relatedid="+id)%>";
}
function onDelete(){
	if(isdel()) {
		document.weaver.operation.value="delete";
		document.weaver.submit();
	}
}
  function onMarkableClick(){
        if (document.all("markable").checked){
            document.all("markAnonymity").disabled = false ;
        } else {
            document.all("markAnonymity").checked = false ;
            document.all("markAnonymity").disabled = true ;
        }
    }



//与共享相关的操作 
 function onOrderAbleClick(obj,obj2,obj3) {
     if (obj.checked){
         obj2.checked = true;
         obj3.checked = true;
         obj2.disabled = true;
         obj3.disabled = false ;
     } else {
         obj2.disabled = false ;
         obj3.disabled = true ;
     }
 }
function allowAddSharer3Onclick(obj) { //完全控制者
    if (obj.checked){       
    } else {
        if (document.getElementById("allowAddSharer4").checked||document.getElementById("allowAddSharer5").checked){
            if(!window.confirm("<%=SystemEnv.getHtmlLabelName(83397,user.getLanguage())%>")) {
                obj.checked = true ;
            }
        }
    }

}

function allowAddSharer4Onclick(obj) { //编辑权限者
    if (obj.checked){
       document.getElementById("allowAddSharer3").checked = true; 
    }else {
        if (document.getElementById("allowAddSharer5").checked){
            if(!window.confirm("<%=SystemEnv.getHtmlLabelName(83399,user.getLanguage())%>")) {
                obj.checked = true ;
            }
        }
    }

}

function allowAddSharer5Onclick(obj) { //查看权限者
    if (obj.checked){
       document.getElementById("allowAddSharer3").checked = true; 
       document.getElementById("allowAddSharer4").checked = true;
    }
}
  function chkAllClick(obj){   
    var chks = document.getElementsByName("chkShareId");    
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        chk.checked=obj.checked;
    }    
}
function onDelShare(){   
    document.weaver.action="ShareOperation.jsp?secid=<%=id%>&method=delMShare";
    document.weaver.submit();
}
//=====TD12005 文档下载权限控制  开始========//
function onOptionChange(selObjName) {
    var selObj = document.all(selObjName);//选择控件对象
	var oVal = selObj.options[selObj.selectedIndex].value;//选中值
	var chkObj = document.all('chk'+selObjName);//复选框控件对象
    var lblObj = document.all('lbl'+selObjName);//复选框控件对应标签对象

	if(oVal == 1) {//查看时显示	
		chkObj.style.display = '';
		lblObj.style.display = '';
	} else {
		chkObj.style.display = 'none';
		lblObj.style.display = 'none';
	}
}
function setCheckbox(chkObj) {
	if(chkObj.checked == true) {
		chkObj.value = 1;
	} else {
		chkObj.value = 0;
	}
}
//=====TD12005 文档下载权限控制  结束========//

//增加权限
var dialog = null;

function closeDialog(){
	if(dialog)
		dialog.close();
}

function openDialog(type){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/docs/category/AddCategoryPermission.jsp?categoryid=<%=id%>&categorytype=<%=categorytype%>&operationcode=<%=operationcode%>";
	dialog.Title = "<%=am.getMultiLabel(labels,user.getLanguage())%>";
	dialog.Width = 600;
	dialog.Height = 285;
	dialog.isIframe = false;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

</script>
<script language=vbs>

sub onShowMould()
	id = window.showModalDialog("/docs/mould/DocMouldBrowser.jsp?doctype=.htm")
	if NOT isempty(id) then
		weaver.docmouldid.value=id(0)&""
		docmouldidname.innerHtml = id(1)&""
		docmouldidname.innerHtml = "<a href='/docs/mould/DocMouldDsp.jsp?id="&id(0)&"'>"&id(1)&"</a>"
	end if
end sub
<%-- added by wdl 2006.7.3 TD.4617 start  --%>
sub onShowMould1()
	id = window.showModalDialog("/docs/mould/DocMouldBrowser.jsp?doctype=.doc")
	if NOT isempty(id) then
		weaver.wordmouldid.value=id(0)&""
		wordmouldidname.innerHtml = id(1)&""
		wordmouldidname.innerHtml = "<a href='/docs/mould/DocMouldDspExt.jsp?id="&id(0)&"'>"&id(1)&"</a>"
	end if
end sub
<%-- added end  --%>
sub onShowWorkflow()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere= where isbill=1 and formid=28")
	if NOT isempty(id) then
	        if id(0)<> 0 then
		approvewfspan.innerHtml = id(1)
		weaver.approvewfid.value=id(0)
		else
		approvewfspan.innerHtml = empty
		weaver.approvewfid.value=""
		end if
	end if
end sub

sub onShowDept(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&document.all(inputename).value)
	if NOT isempty(id) then
	        if id(0)<> 0 then
		document.all(tdname).innerHtml = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHtml = empty
		document.all(inputename).value=""
		end if
	end if
end sub

sub onShowRole(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		document.all(tdname).innerHtml = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHtml = empty
		document.all(inputename).value=""
		end if
	end if
end sub
</script>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentDialog.close();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<script type="text/javascript">
	var parentDialog = parent.parent.getDialog(parent);
	jQuery(document).ready(function(){
		resizeDialog(document);
	});
</script>
<%} %>	
</BODY></HTML>