
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
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
<jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page"/>
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<% 
	String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<script type="text/javascript">

function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}
<%if("1".equals(isDialog)){%>
	var refreshDialog = true;
<%}%>
</script>
</head>
<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
String titlename = "";
MultiAclManager am = new MultiAclManager();
int id = Util.getIntValue(request.getParameter("id"),0);
int messageid = Util.getIntValue(request.getParameter("message"),0);
int errorcode = Util.getIntValue(request.getParameter("errorcode"),0);
CategoryManager cm = new CategoryManager();
int hasVirtualCom = 0 ;
 if(CompanyVirtualComInfo.getCompanyNum()>0){
 hasVirtualCom=1;
 }
String  operateString= "";
String sqlWhere = "";
String tabletype="none";
String tableString = "";
String intanceid = "";
  String isdisable = "";
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
	if (HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit", user) || hasSubManageRight || hasSecManageRight){
	    canEdit = true;
    }
    if (HrmUserVarify.checkUserRight("DocSecCategoryAdd:Add", user) || hasSubManageRight || hasSecManageRight){
        canAdd = true;
    }
    if (HrmUserVarify.checkUserRight("DocSecCategoryEdit:Delete", user) || hasSubManageRight || hasSecManageRight) {
        canDelete = true;
    }
    if (HrmUserVarify.checkUserRight("DocSecCategory:log", user) || hasSubManageRight || hasSecManageRight) {
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
  int operatelevel=0;
  if(detachable==1){
	   operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocSecCategoryEdit:Edit",Util.getIntValue(scc.getSubcompanyIdFQ(id+""),0));
  }else{
	   if(HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit", user) || hasSecManageRight)
	         operatelevel=2;
 }

if(operatelevel>0){
	 canEdit = true;
	 canAdd = true;
	 canDelete = true;
	 canLog = true;
	 hasSubManageRight = true;
	 hasSecManageRight = true;

}else{
	 canEdit = false;
	 canAdd = false;
	 canDelete = false;
	 canLog = false;
	 hasSubManageRight = false;
	 hasSecManageRight = false;

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
	} else if("1".equals(strOprateValue) ) {
		
		strDLNewValue = "1";
		
	} else if("0".equals(strOprateValue)) {
		strDLNewValue = "0";
	}
	return strDLNewValue;
}
/** TD12005 文档下载权限控制   结束 */
%>
<BODY>
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
			<%if(canEdit){ %>
				<input id="saveRight" type=button class="e8_btn_top" onclick="onSave(this);" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
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
<input type=hidden name="fromtab" value="4">
<input type=hidden name="fromSecSet" value="right">
<input type=hidden name="subcategoryid" value="<%=subcategoryid %>">
<%if("1".equals(isDialog)){ %>
<input type="hidden" name="isdialog" value="<%=isDialog%>">
<%} %>
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
 

 

if (canEdit) {
%>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_top} " ;
//RCMenuHeight += RCMenuHeightStep ;
if(cansharingsy){
RCMenu += "{"+SystemEnv.getHtmlLabelName(31816,user.getLanguage())+",javascript:onSynchronous(this),_top} " ;
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
<%
}
%>


<%
	String isDownloadShow = "";
	String isDownloadCheck = "";
%>
<form name="weaver" id="weaver" method="post">

<table class="LayoutTable" style="width:100%;">
			<colgroup>
				<col width="20%">
				<col width="80%">
			</colgroup>
			<tbody>
			<tr height="30px;">
				<td >
					<span class="groupbg" style="display:block;margin-left:10px;"> </span>
					<span class="e8_grouptitle" style="display:block;color:#5b5b5b!important;"><%=SystemEnv.getHtmlLabelName(18582,user.getLanguage())+SystemEnv.getHtmlLabelName(63,user.getLanguage())%></span>
				</td>
				<td  colspan="2" style="text-align: center;">

				<table width=100% class=ListStyle cellspacing=1>
					<tr>
						<td width=10%>
							<nobr><input type=radio  name=operategroup checked value=1 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(362,user.getLanguage())%></nobr>
						</td>
						<td width=10%>
							<nobr><input type=radio  name=operategroup  value=2 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></nobr>
						</td>
						<td width=10%>
							<nobr><input type=radio  name=operategroup  value=3 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(83561,user.getLanguage())%></nobr>
						</td>
						<td width=70%>
							
						</td>
						
					</tr>
				</table>
			</td>
		</tr>
		<tr class="Spacing" style="height:1px;display:" width="100%">							
		<td class="Line" colspan="2" width="100%"></td>
		</tr>
	</tbody>
</table>


<wea:layout type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">

	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%>' attributes="{'samePair':'codedetail_use'}">
		<wea:item><input type=radio  name=sharetype1 checked value=1 ><%=SystemEnv.getHtmlLabelName(15079,user.getLanguage())%></wea:item>
		<wea:item>			
		</wea:item>
		<wea:item>			
		</wea:item>
		<wea:item>			
		</wea:item>
		<wea:item><input type=radio  name=sharetype1  value=2 ><%=SystemEnv.getHtmlLabelName(18583,user.getLanguage())%></wea:item>
		<wea:item>
			<%
             if(CompanyVirtualComInfo.getCompanyNum()>0){
			%>
				<select name="orgid1" id="orgid1"  onchange="changenewtype(1)">
				<option value="0"  ><%=SystemEnv.getHtmlLabelName(83179,user.getLanguage())%></option>
			
    		
    		<%
    		CompanyVirtualComInfo.setTofirstRow();
    		while(CompanyVirtualComInfo.next()){
    		%>
    		<option value="<%=CompanyVirtualComInfo.getCompanyid() %>" ><%=CompanyVirtualComInfo.getVirtualType() %></option>
    		<%} %>
    	

			   </select> 
			<%
			  }
            %>
			
		</wea:item>
		<wea:item>			
		</wea:item>
		<wea:item>			
		</wea:item>
		<wea:item>
			<input type=radio  name=sharetype1  value=3 ><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())+SystemEnv.getHtmlLabelName(15762,user.getLanguage())%>
		</wea:item>
		
		<wea:item>
				<%
             if(CompanyVirtualComInfo.getCompanyNum()>0){
			%>
				<select name="orgid2" id="orgid2"   onchange="changenewtype(2)">
				<option value="0"  ><%=SystemEnv.getHtmlLabelName(83179,user.getLanguage())%></option>
			
    		
    		<%
    		CompanyVirtualComInfo.setTofirstRow();
    		while(CompanyVirtualComInfo.next()){
    		%>
    		<option value="<%=CompanyVirtualComInfo.getCompanyid() %>" ><%=CompanyVirtualComInfo.getVirtualType() %></option>
    		<%} %>
    	

			   </select> 
			<%
			  }
            %>
		</wea:item>
		<wea:item>			
		</wea:item>
		<wea:item>			
		</wea:item>
		<wea:item>
			<input type=radio  name=sharetype1  value=4 ><%=SystemEnv.getHtmlLabelName(18584,user.getLanguage())%>
		</wea:item>
		<wea:item>
				<%
             if(CompanyVirtualComInfo.getCompanyNum()>0){
			%>
				<select name="orgid3" id="orgid3"  onchange="changenewtype(3)">
				<option value="0"  ><%=SystemEnv.getHtmlLabelName(83179,user.getLanguage())%></option>
			
    		
    		<%
    		CompanyVirtualComInfo.setTofirstRow();
    		while(CompanyVirtualComInfo.next()){
    		%>
    		<option value="<%=CompanyVirtualComInfo.getCompanyid() %>" ><%=CompanyVirtualComInfo.getVirtualType() %></option>
    		<%} %>
    	

			   </select> 
			<%
			  }
            %>
		</wea:item>
		<wea:item>	
		<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
		</wea:item>
		<wea:item>	
		<input type=text id="seclevelmain1"  name=seclevelmain1  value="0" style="width:30px"    onfocus="changenewtype(3)"  onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}"                                      onafterpaste="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'0')}else{this.value=this.value.replace(/\D/g,'')}" >&nbsp;-&nbsp;<input type=text  name=seclevelmax1 id="seclevelmax1"  value="100" style="width:30px"  onfocus="changenewtype(3)" onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}"                                      onafterpaste="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'0')}else{this.value=this.value.replace(/\D/g,'')}" >
		</wea:item>
		<wea:item><input type=radio  name=sharetype1  value=5 ><%=SystemEnv.getHtmlLabelName(15081,user.getLanguage())%></wea:item>
		<wea:item>
				<%
             if(CompanyVirtualComInfo.getCompanyNum()>0){
			%>
				<select name="orgid4" id="orgid4"   onchange="changenewtype(4)">
				<option value="0"  ><%=SystemEnv.getHtmlLabelName(83179,user.getLanguage())%></option>
			
    		
    		<%
    		CompanyVirtualComInfo.setTofirstRow();
    		while(CompanyVirtualComInfo.next()){
    		%>
    		<option value="<%=CompanyVirtualComInfo.getCompanyid() %>" ><%=CompanyVirtualComInfo.getVirtualType() %></option>
    		<%} %>
    	

			   </select> 
			<%
			  }
            %>
		</wea:item>
		<wea:item>	
		<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
		</wea:item>
		<wea:item>	
		<input type=text  name=seclevelmain2 id="seclevelmain2"  value="0" style="width:30px"  onfocus="changenewtype(4)" onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}"                                      onafterpaste="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'0')}else{this.value=this.value.replace(/\D/g,'')}" >&nbsp;-&nbsp;<input type=text  name=seclevelmax2 id="seclevelmax2" value="100" style="width:30px" onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}"                                       onfocus="changenewtype(4)" onafterpaste="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'0')}else{this.value=this.value.replace(/\D/g,'')}">
		</wea:item>
		
		<wea:item>
			<input type=radio  name=sharetype1  value=6 ><%=SystemEnv.getHtmlLabelName(126610,user.getLanguage())%>
		</wea:item>
		<wea:item></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(34216,user.getLanguage())%></wea:item>
		<wea:item>
			<select name="createsubtype1" id="createsubtype1">
				<option value="1"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
				<option value="2"><%=SystemEnv.getHtmlLabelName(21837,user.getLanguage())%></option>
				<option value="3"><%=SystemEnv.getHtmlLabelName(126607,user.getLanguage())%></option>
				<option value="4"><%=SystemEnv.getHtmlLabelName(126608,user.getLanguage())%></option>
				<option value="5"><%=SystemEnv.getHtmlLabelName(30792,user.getLanguage())%></option>
				<option value="6"><%=SystemEnv.getHtmlLabelName(19436,user.getLanguage())%></option>
				<option value="7"><%=SystemEnv.getHtmlLabelName(27189,user.getLanguage())%></option>
			</select>
		</wea:item>
	</wea:group>



	<wea:group context='<%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%>' attributes="{'samePair':'codedetail_cus','groupDisplay':'none','itemAreaDisplay':'none'}" >
		<wea:item><input type=radio  name=sharetype2 checked value=1 ><%=SystemEnv.getHtmlLabelName(15079,user.getLanguage())%></wea:item>
		<wea:item>
			
		</wea:item>
		<wea:item>			
		</wea:item>
		<wea:item>			
		</wea:item>
		<wea:item><input type=radio  name=sharetype2  value=2 ><%=SystemEnv.getHtmlLabelName(15080,user.getLanguage())%></wea:item>
		<wea:item>
			
		</wea:item>
		<wea:item>			
		</wea:item>
		<wea:item>			
		</wea:item>
		
	</wea:group>

	
	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%>' attributes="{'samePair':'codedetail_defa','groupDisplay':'none','itemAreaDisplay':'none'}" >
		<wea:item><input type=radio  name=sharetype3 checked value=2 ><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
		<wea:item>	
			<brow:browser viewType="0" name="subcompany" id="subcompany" browserValue="" 
				browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="
				hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' width="50%"  _callback ="changenewtype3"  _callbackParams="0"
				completeUrl="/data.jsp?type=164" 
				browserSpanValue="">
		   </brow:browser>&nbsp;&nbsp; <input  onclick="changenewtype2(0)" class='InputStyle' type='checkbox' name='includesub1' id='includesub1' value='' ><%=SystemEnv.getHtmlLabelName(33864,user.getLanguage())+SystemEnv.getHtmlLabelName(27170,user.getLanguage())%>
		</wea:item>
		<wea:item>	
			<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
		</wea:item>
		
		<wea:item>
		<input type=text  name=seclevelmain3 id=seclevelmain3  value="10" style="width:30px"  onfocus="changenewtype3(0)" onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}"                                      onafterpaste="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'0')}else{this.value=this.value.replace(/\D/g,'')}" >&nbsp;-&nbsp;<input type=text  name=seclevelmax3 id=seclevelmax3  value="100" style="width:30px"  onfocus="changenewtype3(0)" onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}"                                      onafterpaste="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'0')}else{this.value=this.value.replace(/\D/g,'')}">
		</wea:item>
		<wea:item><input type=radio  name=sharetype3  value=3 ><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
		<wea:item>	
			<brow:browser viewType="0" name="department" browserValue="" 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="
				hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' width="50%" _callback ="changenewtype3"  _callbackParams="1"
				completeUrl="/data.jsp?type=4" 
				browserSpanValue="">
		   </brow:browser>&nbsp;&nbsp;           
		    <input onclick="changenewtype2(1)" class='InputStyle' type='checkbox' name='includesub2' id='includesub2' value='' ><%=SystemEnv.getHtmlLabelName(33864,user.getLanguage())+SystemEnv.getHtmlLabelName(27170,user.getLanguage())%>
		</wea:item>
		<wea:item>	
			<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
		</wea:item>		
		<wea:item>
		<input type=text  name=seclevelmain4 id=seclevelmain4  value="10" style="width:30px" onfocus="changenewtype2(1)" onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}"                                      onafterpaste="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'0')}else{this.value=this.value.replace(/\D/g,'')}" >&nbsp;-&nbsp;<input type=text  name=seclevelmax4 id=seclevelmax4  value="100" style="width:30px" onfocus="changenewtype2(1)" onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}"                                      onafterpaste="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'0')}else{this.value=this.value.replace(/\D/g,'')}">
		</wea:item>
		<wea:item>
			<input type=radio  name=sharetype3  value=10 ><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<span id="showjobs">
				<brow:browser viewType="0" name="jobtitleid" browserValue="" _callback ="changenewtype3"  _callbackParams="2" 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp?"
				hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' width="50%"
				completeUrl="/data.jsp?type=hrmjobtitles" />
			</span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(28169,user.getLanguage())%></wea:item>
		<wea:item>
			<select name="createsubtype" id="createsubtype" onchange="onSelectChanged(this.value);" style="float:left;" _type="164" _formFieldType="164,194,169,170,4,57,167,168,1,17,165,166">
				<option value="1"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
				<option value="2"><%=SystemEnv.getHtmlLabelName(19437,user.getLanguage())%></option>
				<option value="3"><%=SystemEnv.getHtmlLabelName(19438,user.getLanguage())%></option>
			</select>
			<span id="showPosLevel" style="display:none">
				<brow:browser viewType="0" name="subcompanyid1" browserValue="" 
						_callback="afterOnShowDepartment"
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids=#id#&selectedDepartmentIds=#id#"
						hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2' width="50%"
						completeUrl="/data.jsp?type=164" temptitle='<%=SystemEnv.getHtmlLabelName(21957,user.getLanguage())%>'>
				</brow:browser>
			</span>
			<span id="showDeptLevel" style="display:none">
				<brow:browser viewType="0" name="departmentid1" browserValue="" 
						_callback="afterOnShowDepartment"
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=#id#&selectedDepartmentIds=#id#"
						hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2' width="50%"
						completeUrl="/data.jsp?type=4" temptitle='<%=SystemEnv.getHtmlLabelName(21957,user.getLanguage())%>'>
				</brow:browser>
			</span>
		</wea:item>
		
		<wea:item>
			<input type=radio  name=sharetype3  value=4 ><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%>
		</wea:item>	
		<wea:item >
			<brow:browser viewType="0" name="role" browserValue="" 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp?selectedids="
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' width="50%"
				completeUrl="/data.jsp?type=65" _callback ="changenewtype3"    _callbackParams="3"
				browserSpanValue="">
		   </brow:browser>&nbsp;&nbsp;
              <%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>
		      <SELECT  name=rolelevel id="rolelevel" style="width:40px" onchange="changenewtype2(3)"> 

					<option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
					<option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
					<option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
				</SELECT>


		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
		<wea:item>
		<input type=text  name=seclevelmain5 id=seclevelmain5 value="10" style="width:30px"  onfocus="changenewtype2(3)" onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}"                                      onafterpaste="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'0')}else{this.value=this.value.replace(/\D/g,'')}" >&nbsp;-&nbsp;<input type=text  name=seclevelmax5 id=seclevelmax5  value="100" style="width:30px" onfocus="changenewtype2(3)" onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}"                                      onafterpaste="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'0')}else{this.value=this.value.replace(/\D/g,'')}" >
		</wea:item>
		<wea:item>
			<input type=radio  name=sharetype3  value=1 ><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>
		</wea:item>
		<wea:item>
				<brow:browser viewType="0" name="resource" browserValue="" 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="
				hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' width="50%"  _callback ="changenewtype3"   _callbackParams="4"
				completeUrl="/data.jsp" 
				browserSpanValue="">
		   </brow:browser>
		</wea:item>
		<wea:item>	
		
		</wea:item>
		<wea:item>	
		
		</wea:item>
		<wea:item><input type=radio  name=sharetype3  value=5 ><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></wea:item>
		<wea:item>
				
		</wea:item>
		<wea:item>	
		<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
		</wea:item>
		<wea:item>	
		<input type=text  name=seclevelmain6 id=seclevelmain6 value="10" style="width:30px" onfocus="changenewtype2(5)" onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}"                                      onafterpaste="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'0')}else{this.value=this.value.replace(/\D/g,'')}" >&nbsp;-&nbsp;<input type=text  name=seclevelmax6 id=seclevelmax6  value="100" style="width:30px" onfocus="changenewtype2(5)" onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}"                                      onafterpaste="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'0')}else{this.value=this.value.replace(/\D/g,'')}">
		</wea:item>
		<wea:item><input type=radio  name=sharetype3  value=6 ><%=SystemEnv.getHtmlLabelName(24002,user.getLanguage())%></wea:item>
		<wea:item>
		<brow:browser viewType="0" name="group" browserValue="" 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/orggroup/HrmOrgGroupBrowser.jsp?selectedids="
				hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' width="50%"  _callback ="changenewtype3" _callbackParams="6" 
				completeUrl="/data.jsp?type=hrmOrgGroup" 
				browserSpanValue="">
		   </brow:browser>		
		</wea:item>
		<wea:item>	
		<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
		</wea:item>
		<wea:item>	
		<input type=text  name=seclevelmain7 id=seclevelmain7  value="10" style="width:30px" onfocus="changenewtype2(6)"  onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}"                                      onafterpaste="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'0')}else{this.value=this.value.replace(/\D/g,'')}" >&nbsp;-&nbsp;<input type=text  name=seclevelmax7 id=seclevelmax7 value="100" style="width:30px"  onfocus="changenewtype2(6)" onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}"                                      onafterpaste="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'0')}else{this.value=this.value.replace(/\D/g,'')}">
		</wea:item>
		<%if(isgoveproj==0){%>
		<wea:item><input type=radio  name=sharetype3  value=7 ><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></wea:item>
		<wea:item>
		<brow:browser viewType="0" name="crm" browserValue="" 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="
				hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' width="50%" _callback ="changenewtype3" _callbackParams="7"
				completeUrl="/data.jsp?type=7" 
				browserSpanValue="">
		   </brow:browser>	
				
		</wea:item>
		<wea:item>	
	
		</wea:item>
		<wea:item>	
		
		</wea:item>
		<wea:item><input type=radio  name=sharetype3  value=8 ><%=SystemEnv.getHtmlLabelName(1282,user.getLanguage())%></wea:item>
		<wea:item>
		<SELECT class=InputStyle style="width:100px;" id="custype"  name=custype onChange="changenewtype2(8)" >   
		<%
					if(isgoveproj==0){
					while(CustomerTypeComInfo.next()){
									String curid=CustomerTypeComInfo.getCustomerTypeid();
									String curname=CustomerTypeComInfo.getCustomerTypename();
									String optionvalue=curid;
					%>
					<option value="<%=optionvalue%>"><%=curname%></option>
					<%}
					}%>
		
		</SELECT>
		</wea:item>
		<wea:item>	
		<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
		</wea:item>
		<wea:item>	
		<input type=text  name=seclevelmain8 id=seclevelmain8  value="10" style="width:30px" onfocus="changenewtype2(8)" onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}"                                      onafterpaste="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'0')}else{this.value=this.value.replace(/\D/g,'')}" >&nbsp;-&nbsp;<input type=text  name=seclevelmax8 id=seclevelmax8 value="100" style="width:30px"  onfocus="changenewtype2(8)" onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}"                                      onafterpaste="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'0')}else{this.value=this.value.replace(/\D/g,'')}">
		</wea:item>
		<%}%>
	</wea:group>
	
</wea:layout>


<table class="LayoutTable" style="width:100%;">
			<colgroup>
				<col width="20%">
				<col width="80%">
			</colgroup>
			<tbody>
			<tr height="30px;">
				<td >
					<span class="groupbg" style="display:block;margin-left:10px;"> </span>
					<span class="e8_grouptitle" style="display:block;color:#5b5b5b!important;"><%=SystemEnv.getHtmlLabelName(385,user.getLanguage())%></span>
				</td>
				<td  colspan="2" style="text-align: center;">

				<table width=100% class=ListStyle cellspacing=1>
					<tr>
						<td width=30%>
							<nobr><input type=radio  name=sharelevel checked value=1 onclick="setDownload(1);"  ><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></nobr>
							<span  id='lbldownloadlevel'>
							<input class='InputStyle' type='checkbox' name='downloadlevel' id= 'downloadlevel'  <% if(noDownload==0){%>checked<%}%>   <% if(noDownload==1){%>disabled<%}%>  >
							 <label  ><%=SystemEnv.getHtmlLabelName(23733,user.getLanguage())%></label>
							 </span>
						</td>
						<td width=15%>
							<nobr><input type=radio  name=sharelevel  onclick="setDownload(2);" value=2 ><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></nobr>
						</td>
						<td width=15%>
							<nobr><input type=radio  name=sharelevel onclick="setDownload(3);" value=3 ><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></nobr>
						</td>
						<td width=40%>
							
						</td>
						
					</tr>
				</table>
			</td>
		</tr>
		<tr class="Spacing" style="height:1px;display:" width="100%">							
		<td class="Line" colspan="2" width="100%"></td>
		</tr>
	</tbody>
</table>
</form>
<wea:layout type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
<wea:group context='<%=SystemEnv.getHtmlLabelName(119,user.getLanguage())+SystemEnv.getHtmlLabelName(320,user.getLanguage())%>'>
		<%if(canAdd){ %>
			<wea:item type="groupHead">
				<input type=button class="addbtn" onclick="openDialog(3);"  title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
				<input type=button class="delbtn" onclick="onDelShare();"  title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
			</wea:item>
		<%} %>
		<wea:item attributes="{\"isTableList\":\"true\"}">
			 <%
				sqlWhere = "seccategoryid="+id;
				
				
				 if(isdisable.equals("")){
					tabletype = "checkbox";
				 }
				tableString=""+
				   "<table pageId=\""+PageIdConst.DOC_SECCATEGORDEAULTRIGHT+"\" instanceid=\""+intanceid+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_SECCATEGORDEAULTRIGHT,user.getUID(),PageIdConst.DOC)+"\" tabletype=\""+tabletype+"\">"+
				   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlform=\"DocSecCategoryShare\" sqlorderby=\"isolddate,operategroup\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
				   "<head>"+	
				         "<col width=\"20%\" transmethod=\"weaver.general.KnowledgeTransMethod.getOperateGroup\" text=\""+SystemEnv.getHtmlLabelName(18582,user.getLanguage())+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"operategroup\" otherpara=\""+user.getLanguage()+"\"  orderkey=\"operategroup\"/>"+
						 "<col width=\"20%\" transmethod=\"weaver.general.KnowledgeTransMethod.getShareTypeNew\" text=\""+SystemEnv.getHtmlLabelName(21956,user.getLanguage())+"\" column=\"sharetype\" otherpara=\""+user.getLanguage()+"+column:operategroup+column:orgid+"+hasVirtualCom+"\"  orderkey=\"sharetype\"/>"+
						 "<col width=\"20%\"  transmethod=\"weaver.general.KnowledgeTransMethod.getShareTypeDescNew\" column=\"sharetype\" otherpara=\""+user.getLanguage()+"+column:departmentid+column:roleid+column:roleLevel+column:orgGroupId+column:userid+column:subcompanyid+column:crmid+column:operategroup+column:includesub+column:custype+column:joblevel+column:jobdepartment+column:jobsubcompany+column:jobids\"  text=\""+SystemEnv.getHtmlLabelName(106,user.getLanguage())+"\"/>"+
					     "<col width=\"20%\" transmethod=\"weaver.general.KnowledgeTransMethod.getSecLevel\" text=\""+SystemEnv.getHtmlLabelName(683,user.getLanguage())+"\" column=\"seclevel\" otherpara=\""+user.getLanguage()+"+column:seclevelmax+column:operategroup+column:sharetype\"  orderkey=\"seclevel\"/>"+
						 "<col width=\"20%\" transmethod=\"weaver.general.KnowledgeTransMethod.getShareLevel\"  otherpara=\""+user.getLanguage()+"\" text=\""+SystemEnv.getHtmlLabelName(385,user.getLanguage())+"\" column=\"sharelevel\"   orderkey=\"sharelevel\"/>";
				 if(noDownload!=1){
				 tableString+="<col width=\"20%\" transmethod=\"weaver.general.KnowledgeTransMethod.getDownloadLevel\" text=\""+SystemEnv.getHtmlLabelName(32070,user.getLanguage())+"\" column=\"downloadlevel\" otherpara=\""+user.getLanguage()+"+column:sharelevel\"    orderkey=\"downloadlevel\"/>";
				 }
					
				 tableString+=		 
				   "</head>"+
				   "</table>";
				   
			%> 
			<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.DOC_SECCATEGORDEAULTRIGHT %>"/>
			<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
		</wea:item>
	</wea:group>
</wea:layout>


   <SCRIPT language="javaScript">
  function  onChangetype(val){
	  if(val==1){
		
		  showGroup('codedetail_use');
		  hideGroup('codedetail_cus');  
		  hideGroup('codedetail_defa');
	  }else if(val==2){
		
	      hideGroup('codedetail_use');
		  showGroup('codedetail_cus');  
		  hideGroup('codedetail_defa');
	  }else if(val==3){
		
	      hideGroup('codedetail_use');
		  hideGroup('codedetail_cus');  
		  showGroup('codedetail_defa');
	  
	  }
	 
 
  }
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

function reloadPage(){
	window.location.reload();
}


 function onSynchronous(obj){

	var tanchu=0;

	
		<%if(docsecnum>0){%>    
		  tanchu=1;
		  <%}%>
	if(tanchu==1){
		if(confirm("<%=SystemEnv.getHtmlLabelName(31822,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(126294,user.getLanguage())%><%=docsecnum%><%=SystemEnv.getHtmlLabelName(126295,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(31823,user.getLanguage())%>")){
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


function onDelShare(id){
	if(!id){
		id = _xtable_CheckedCheckboxId();
	}
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>",function(){ 
	    document.weaver.action="ShareOperation.jsp?secid=<%=id%>&method=delMShare&shareids="+id;
	    document.weaver.submit();
	});
    
}

function changenewtype(temindex){
	jQuery("input[name=sharetype1]:eq("+temindex+")").trigger("checked",true);
}
function changenewtype2(temindex){

	jQuery("input[name=sharetype3]:eq("+temindex+")").trigger("checked",true);
}
function changenewtype3(event,data,fieldId,temindex){

	jQuery("input[name=sharetype3]:eq("+temindex+")").trigger("checked",true);
}
//=====TD12005 文档下载权限控制  开始========//
function onOptionChange(selObjName) {

    var selObj = $GetEle(selObjName);//选择控件对象
	var oVal = selObj.options[selObj.selectedIndex].value;//选中值
	var chkObj = document.all('chk'+selObjName);//复选框控件对象
    var lblObj = document.all('lbl'+selObjName);//复选框控件对应标签对象
	if(oVal == 1) {//查看时显示	
		chkObj.style.display = '';
		lblObj.style.display = '';
		jQuery("body").jNice();
		jQuery(chkObj).siblings("span.jNiceCheckbox").css("display","");
		jQuery(chkObj).siblings("span.jNiceCheckbox_disabled").css("display","");
	} else {
		chkObj.style.display = 'none';
		lblObj.style.display = 'none';
		jQuery(chkObj).siblings("span.jNiceCheckbox").css("display","none");
		jQuery(chkObj).siblings("span.jNiceCheckbox_disabled").css("display","none");
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
function setDownload(sharelevel){

if(sharelevel==1){
jQuery("#lbldownloadlevel").css("display","");
}else {
jQuery("#lbldownloadlevel").css("display","none");
}
}

function openDialog(type){
      var operategroup = jQuery("input[name='operategroup'][type='radio']:checked").val();
	  var sharetype1 = jQuery("input[name='sharetype1'][type='radio']:checked").val();
	  var sharetype2 = jQuery("input[name='sharetype2'][type='radio']:checked").val();
	  var sharetype3 = jQuery("input[name='sharetype3'][type='radio']:checked").val();
	  var orgid1 = jQuery("#orgid1").val();
	  var orgid2 = jQuery("#orgid2").val();
	  var orgid3 = jQuery("#orgid3").val();
	  var orgid4 = jQuery("#orgid4").val();
	  var orgid = "";
	  var seclevelmax="";
	  var seclevelmain="";
	  var seclevelmax1 = jQuery("#seclevelmax1").val();
	  var seclevelmax2 = jQuery("#seclevelmax2").val();
	  var seclevelmain1 = jQuery("#seclevelmain1").val();
	  var seclevelmain2 = jQuery("#seclevelmain2").val();
	  var sharelevel = jQuery("input[name='sharelevel'][type='radio']:checked").val();
	  var sharetype="";
	  var downloadlevel="0";
	  var subcompany="";
	  var department="";
	  var includesub ="";
	  var resource="";
	  var role="";
	  var rolelevel="";
	  var group ="";
	  var crm ="";
	  var custype ="";
	  var relatedshareid="";
	  var joblevel="";
	  var jobdepartment="";
	  var jobsubcompany="";
	  if( jQuery("#downloadlevel").attr("checked")||parseInt(sharelevel)>1){
	    downloadlevel=1
	  }
	  if(operategroup==1){
		  sharetype=sharetype1;
		  if(sharetype1==2){
		    orgid=orgid1;
		  }else if(sharetype1==3){
		    orgid=orgid2;
		  }else if(sharetype1==4){
			seclevelmain=seclevelmain1;
			seclevelmax=seclevelmax1;
			if(parseInt(seclevelmain)>parseInt(seclevelmax)){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82808,user.getLanguage())%>");
			    return;
	        }
		    orgid=orgid3;
		  }else if(sharetype1==5){
			seclevelmain=seclevelmain2;
			seclevelmax=seclevelmax2;
		    orgid=orgid4;
			if(parseInt(seclevelmain)>parseInt(seclevelmax)){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82808,user.getLanguage())%>");
			    return;
	        }
		  }	  
		  else if(sharetype1==6){
			joblevel=jQuery("#createsubtype1").val();
		  }	  
	  }else if(operategroup==2){
	      sharetype=sharetype2;
	  
	  }else if(operategroup==3){
		 sharetype=sharetype3;
		if(sharetype3==1){
	      resource = jQuery("#resource").val();
		  relatedshareid=resource;
		  if(resource=="") {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
            return ;
         }
		}else if(sharetype3==2){
		  seclevelmain=jQuery("#seclevelmain3").val();
		  seclevelmax=jQuery("#seclevelmax3").val();
		 // includesub=jQuery("#includesub1").val();
		 if(parseInt(seclevelmain)>parseInt(seclevelmax)){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82808,user.getLanguage())%>");
			    return;
	        }
		  if(jQuery("#includesub1").attr("checked")){
	       includesub=1
	      }
		  

		  subcompany = jQuery("#subcompany").val()	;	
		   relatedshareid=subcompany;
		   if(subcompany=="") {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
            return ;
          }
		
		}else if(sharetype3==3){
		  seclevelmain=jQuery("#seclevelmain4").val();
		  seclevelmax=jQuery("#seclevelmax4").val();
		  if(parseInt(seclevelmain)>parseInt(seclevelmax)){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82808,user.getLanguage())%>");
			    return;
	        }
		  includesub=jQuery("#includesub2").val();
		  if(jQuery("#includesub2").attr("checked")){
	       includesub=1
	      }
		  department = jQuery("#department").val()	;	
		  relatedshareid=department;
		  if(department=="") {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
            return ;
          }
		
		}else if(sharetype3==4){
		  seclevelmain=jQuery("#seclevelmain5").val();
		  seclevelmax=jQuery("#seclevelmax5").val();
		  if(parseInt(seclevelmain)>parseInt(seclevelmax)){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82808,user.getLanguage())%>");
			    return;
	        }
		  role=jQuery("#role").val()	;
		  relatedshareid=role;
		  rolelevel=jQuery("#rolelevel").val()	;	
		  if(role=="") {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
            return ;
          }
		
		}else if(sharetype3==5){
			relatedshareid=1;
		    seclevelmain=jQuery("#seclevelmain6").val();
		    seclevelmax=jQuery("#seclevelmax6").val();
			if(parseInt(seclevelmain)>parseInt(seclevelmax)){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82808,user.getLanguage())%>");
			    return;
	        }
		
		}else if(sharetype3==6){
		  seclevelmain=jQuery("#seclevelmain7").val();
		  seclevelmax=jQuery("#seclevelmax7").val();
		  if(parseInt(seclevelmain)>parseInt(seclevelmax)){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82808,user.getLanguage())%>");
			    return;
	        }
		  group=jQuery("#group").val()	;	
		  relatedshareid=group;
		  if(group=="") {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
            return ;
          }
		
		}else if(sharetype3==7){
		  crm=jQuery("#crm").val()	;
		  relatedshareid=crm;
		  if(crm=="") {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
            return ;
          }
		
		}else if(sharetype3==8){
		  seclevelmain=jQuery("#seclevelmain8").val();
		  seclevelmax=jQuery("#seclevelmax8").val();
		  if(parseInt(seclevelmain)>parseInt(seclevelmax)){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82808,user.getLanguage())%>");
			    return;
	       }
		  custype=jQuery("#custype").val()	;	
		  relatedshareid=custype;
		  if(custype=="") {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
            return ;
          }
		
		}
	  else if(sharetype3==10){
		  relatedshareid = jQuery("#jobtitleid").val();
		  joblevel=jQuery("#createsubtype").val();
	  	  jobdepartment=jQuery("#departmentid1").val();
	      	  jobsubcompany=jQuery("#subcompanyid1").val();
	      	  if(relatedshareid=="") {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
            		return ;
	          }
          
	          if(joblevel=="2" && jobsubcompany == "") {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83526,user.getLanguage())%>!");
	            	return ;
	          }
	          if(joblevel=="3" && jobdepartment == "") {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83527,user.getLanguage())%>!");
	            	return ;
	          }
		}
	  }

    

	  jQuery.post("ShareOperation.jsp",
	  {'secid':'<%=id%>',
	  'method':'add',
	  'operategroup':operategroup,
	  'sharetype':sharetype,
	  'orgid':orgid,
	  'seclevelmain':seclevelmain,
	  'seclevelmax':seclevelmax,
	  'sharelevel':sharelevel,
	  'downloadlevel':downloadlevel,
	  'includesub':includesub,
	  'resource':resource,
	  'subcompany':subcompany,
	  'department':department,
	  'role':role,
	  'rolelevel':rolelevel,
	  'group':group,
	  'crm':crm,
	  'custype':custype,
	  'joblevel':joblevel,
	  'jobdepartment':jobdepartment,
	  'jobsubcompany':jobsubcompany,
	  'relatedshareid':relatedshareid
	  },function(data){
	       _table.reLoad();
	  });
		
}

//选择岗位级别
function onSelectChanged(value){
	if(value == 1){
		jQuery("#showPosLevel,#showDeptLevel").hide();
	}else if(value == 2){
		jQuery("#showPosLevel").show();
		jQuery("#showDeptLevel").hide();
	}else if(value == 3){
		jQuery("#showPosLevel").hide();
		jQuery("#showDeptLevel").show();
	}
	changenewtype2('2');
}
function afterOnShowDepartment(e,datas,fieldid,params){
	if (datas) {
		$GetEle("mutil").value = "1"
	}else{
	
	}
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
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentDialog.closeByHand();">
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
