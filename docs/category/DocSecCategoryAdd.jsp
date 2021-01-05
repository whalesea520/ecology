
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
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
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="SysDefaultsComInfo" class="weaver.docs.tools.SysDefaultsComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="DocFTPConfigComInfo" class="weaver.docs.category.DocFTPConfigComInfo" scope="page" />
<jsp:useBean id="scc" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<HTML><HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(67,user.getLanguage());
String needfav ="1";
String needhelp ="";
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String isEntryDetail = Util.null2String(request.getParameter("isentrydetail"));
String secId = Util.null2String(request.getParameter("secId"));
String from = Util.null2String(request.getParameter("from"));
String fromSubId = Util.null2String(request.getParameter("curSubId"));
String oriSecId = Util.null2String(request.getParameter("oriSecId"));
String OriSubId = Util.null2String(request.getParameter("OriSubId"));
int detachable = Util.getIntValue(String.valueOf(session.getAttribute("docdetachable")),0);
int subcompanyid = 0;
int operatelevel=0;
if(detachable==1){
	subcompanyid = Util.getIntValue(String.valueOf(session.getAttribute("maincategory_subcompanyid")),Util.getIntValue(String.valueOf(session.getAttribute("docdftsubcomid"))));
	operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocSecCategoryAdd:Add",subcompanyid);
}
if(isEntryDetail.equals(""))isEntryDetail = "0";
%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<script language=javascript >
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if("<%=isclose%>"=="1"){
	<%if(secId.equals("") && from.equals("")){%>
		//parentWin.location.href="DocMainCategoryList.jsp";
		try{
			parentWin.parent.parent.refreshTreeMain("","",true);
			parentWin._table.reLoad();
		}catch(e){}
	<%}else if(from.equals("subedit")){%>
		parentWin.parent.parent.refreshTreeMain(<%=Util.getIntValue(OriSubId)%>,<%=Util.getIntValue(secId)%>,true);
		try{
			parentWin._table.reLoad();
		}catch(e){}
	<%}else if(from.equals("edit")){%>
		parentWin.parent.parent.refreshTreeMain(<%=Util.getIntValue(secId)%>,<%=Util.getIntValue(secId)%>,true);
	<%}else{%>
		parentWin.parent.location.href="/docs/category/DocCategoryTab.jsp?_fromURL=3&reftree=1&refresh=1&id=<%=secId%>";
	<%}%>
	dialog.close();
}
</script>
</head>
<%
MultiAclManager am = new MultiAclManager();
int id = -1;
int parentid = Util.getIntValue(request.getParameter("id"),0);
String parentName = scc.getAllParentName(""+parentid,true);
int messageid = Util.getIntValue(request.getParameter("message"),0);
int errorcode = Util.getIntValue(request.getParameter("errorcode"),0);
CategoryManager cm = new CategoryManager();

	RecordSet.executeProc("Doc_SecCategory_SelectByID",id+"");
	RecordSet.next();
	String categoryname=Util.toScreenToEdit(RecordSet.getString("categoryname"),user.getLanguage());
	String coder=Util.toScreenToEdit(RecordSet.getString("coder"),user.getLanguage());
	//String subcategoryid=RecordSet.getString("subcategoryid");
	String subcategoryid="-1";//subid+"";
	//String docmouldid=RecordSet.getString("docmouldid");
	/* added by wdl 2006.7.3 TD.4617 start */
	//String wordmouldid = RecordSet.getString("wordmouldid");
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
    int bacthDownload = Util.getIntValue(Util.null2String(RecordSet.getString("bacthDownload")),0);
    int isControledByDir = Util.getIntValue(Util.null2String(RecordSet.getString("iscontroledbydir")),0);
    int pubOperation = Util.getIntValue(Util.null2String(RecordSet.getString("puboperation")),0);
    int childDocReadRemind = Util.getIntValue(Util.null2String(RecordSet.getString("childdocreadremind")),0);
	
    int relationable  = Util.getIntValue(Util.null2String(RecordSet.getString("relationable")),0);
    
    String isPrintControl=Util.null2String(RecordSet.getString("isPrintControl"));
    int printApplyWorkflowId = Util.getIntValue(Util.null2String(RecordSet.getString("printApplyWorkflowId")),0);

    int readOpterCanPrint = Util.getIntValue(Util.null2String(RecordSet.getString("readoptercanprint")),0);
    
    int isOpenAttachment = Util.getIntValue(Util.null2String(RecordSet.getString("isOpenAttachment")),0);
    
    int isAutoExtendInfo = Util.getIntValue(Util.null2String(RecordSet.getString("isAutoExtendInfo")),0);
    
    /*RecordSet.executeSql(" select norepeatedname from DocMainCategory where id = " + mainid);
    RecordSet.next();
    if(Util.getIntValue(RecordSet.getString("norepeatedname"),0)==1||Util.getIntValue(SubCategoryComInfo.getNoRepeatedName(subcategoryid),0)==1)
        noRepeatedName = 11;
	*/
	boolean canEdit = false;
	boolean canAdd = false;
	boolean canDelete = false;
	boolean canLog = false;
	boolean hasSubManageRight = false;
	boolean hasSecManageRight = false;
	//hasSubManageRight = am.hasPermission(mainid, MultiAclManager.CATEGORYTYPE_MAIN, user, MultiAclManager.OPERATION_CREATEDIR);
	//hasSecManageRight = am.hasPermission(id, MultiAclManager.CATEGORYTYPE_SEC, user, MultiAclManager.OPERATION_CREATEDIR);
	if(parentid>0)
		hasSecManageRight = am.hasPermission(parentid, MultiAclManager.CATEGORYTYPE_SEC, user, MultiAclManager.OPERATION_CREATEDIR);
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

%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


<%
if(messageid !=0) {
%>
<script type="text/javascript">
	top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(messageid,user.getLanguage())%>");
</script>
<%}%>
<%
if(errorcode == 10) {
%>
	<script type="text/javascript">
	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21999,user.getLanguage()) %>");
	</script>
<%}%>
<%
if(errorcode == 11) {
%>
	<script type="text/javascript">
	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31877,user.getLanguage()) %>");
	</script>
<%}%>

<iframe name="DocFTPConfigInfoGetter" style="width:100%;height:200;display:none"></iframe>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" class="e8_btn_top" onclick="onSave(<%= isEntryDetail%>);">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage())%>" class="e8_btn_top" onclick="onSave(1);">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=weaver action="SecCategoryOperation.jsp" method=post>
<input type=hidden name="operation">
<input type=hidden name="id" value="<%=id%>">
<input type=hidden name="secId" value="<%=parentid%>">
<input type=hidden name="oriSecId" value="<%=oriSecId %>">
<input type=hidden name="OriSubId" value="<%=OriSubId %>">
<input type=hidden name="fromtab" value="0">
<input type=hidden name="tab" value="0">
<input type="hidden" name="isdialog" value="<%=isDialog%>">
<input type="hidden" name="from" id="from" value="<%=from%>">
<input type="hidden" id = "isentrydetail" name="isentrydetail" value="<%= isEntryDetail%>">
<input type=hidden name="PDocCreater" value="3">
<input type=hidden name="PCreaterManager" value="1">
<input type=hidden name="PDocCreaterW" value="3">
<input type=hidden name="PCreaterManagerW" value="1">

<%
if(!"1".equals(isDialog)){
	if (canEdit) {
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(0),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	}
}else if (canEdit){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave("+isEntryDetail+"),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(32159,user.getLanguage())+",javascript:onSave(1),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>

<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(61,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(81530,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=hidden name="subcategoryid" value="<%=subcategoryid%>">
			<% 
				String completeUrl="/data.jsp?type=categoryBrowser&onlySec=true";
				String browserUrl="/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/category/MultiCategorySingleBrowser.jsp";
				/*if(!HrmUserVarify.checkUserRight("DocSecCategoryAdd:add", user) && hasSecManageRight){
					completeUrl+="&operationcode="+MultiAclManager.OPERATION_CREATEDIR;
					browserUrl+="?operationcode="+MultiAclManager.OPERATION_CREATEDIR;
				}*/
				if(HrmUserVarify.checkUserRight("DocSecCategoryAdd:Add", user)){
			%>
			<span>
			   <brow:browser viewType="0" name="parentid" idKey="id" nameKey="path" browserValue='<%=""+parentid%>' 
				browserUrl='<%=browserUrl %>'
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='<%=canEdit?"1":"0" %>' language='<%=""+user.getLanguage() %>'
				_callback="showOrHideExtendAttr"
				completeUrl='<%=completeUrl %>' linkUrl="#" temptitle='<%=SystemEnv.getHtmlLabelName(81530,user.getLanguage())%>'
				browserSpanValue='<%= parentName%>'></brow:browser>
			</span>	
			<%}else{ %>
				<input type=hidden name="parentid" value="<%=parentid%>">
				<%= parentName%>
			<%} %>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(24764,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="categorynamespan" required="true" value='<%=categoryname%>'>
				<%if(canEdit){%>
            <INPUT temptitle="<%=SystemEnv.getHtmlLabelName(24764,user.getLanguage()) %>" class=InputStyle maxLength=100 size=60 name=categoryname value="<%=categoryname%>" onChange="checkinput('categoryname','categorynamespan')"><%}else{%><%=categoryname%><%}%>
            <INPUT type=hidden maxLength=100 size=60 name=srccategoryname value="<%=categoryname%>" >
			</wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(81529,user.getLanguage())%></wea:item>
		<wea:item><%if(canEdit){%><INPUT maxLength=50 size=30 class=InputStyle name="coder" value='<%=coder%>'><%}else{%><%=coder%><%}%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(19449,user.getLanguage())%></wea:item>
		<wea:item>  
			<INPUT class=InputStyle tzCheckbox="true" type=checkbox <%if(noRepeatedName==1){%>checked<%}%> <%if(noRepeatedName==11){%>checked disabled<%}%> value=1 name="noRepeatedName" <%if(!canEdit){%>disabled<%}%>>
		</wea:item>
		<%String attr = "{'samePair':'_extendParentAttr','display':'"+(parentid>0?"":"none")+"'}"; %>
		<wea:item attributes='<%=attr %>'><%=SystemEnv.getHtmlLabelName(81532,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=attr %>'>  
			<INPUT class=InputStyle checked="checked" tzCheckbox="true" type=checkbox value=1 name="extendParentAttr" <%if(!canEdit){%>disabled<%}%>>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></wea:item>
		<wea:item><INPUT maxLength=5 size=5 class=InputStyle name="secorder" style="width:50px;" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("secorder")' value=""></wea:item>
		<%if(detachable==1){ 
			String attrs = "{'samePair':'_subcompanyid','display':'"+(parentid<=0?"":"none")+"'}";
		%>
			<wea:item attributes='<%=attrs %>'><%= SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
			<wea:item attributes='<%=attrs %>'>
				<span>
			        <brow:browser viewType="0" name="subcompanyId" browserValue='<%= ""+subcompanyid %>' 
			                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
			                hasInput='<%=operatelevel>0?"true":"false" %>' isSingle="true" hasBrowser = "true" isMustInput='<%=operatelevel>0?"2":"0" %>'
			                completeUrl="/data.jsp?type=164"  temptitle='<%= SystemEnv.getHtmlLabelName(17868,user.getLanguage())%>'
			                browserSpanValue='<%=subcompanyid!=0?Util.toScreen(SubCompanyComInfo.getSubCompanyname(subcompanyid+""),user.getLanguage()):""%>'>
			        </brow:browser>
			    </span>
			</wea:item>
			<%} %>
	</wea:group>
</wea:layout>
       
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

function showOrHideExtendAttr(e,datas,name,params){
	if(datas){
		if(datas.id){
			showEle("_extendParentAttr");
			hideEle("_subcompanyid");
		}else{
			hideEle("_extendParentAttr");
			showEle("_subcompanyid");
		}
	}
}

function _userDelCallback(text,name){
	if(!jQuery("#parentid").val()){
		hideEle("_extendParentAttr");
		showEle("_subcompanyid");
	}
}

function onSave(isEnterDetail){
	try{
		parent.disableTabBtn();
	}catch(e){}
	jQuery('#isentrydetail').val(isEnterDetail);
	if(check_form(document.weaver,'categoryname')){
		<%if(detachable==1 && parentid<=0){%>
			if(check_form(document.weaver,'subcompanyId')){
		<%}%>
			document.weaver.operation.value="add";
			document.weaver.submit();
		<%if(detachable==1 && parentid<=0){%>
			}else{
				try{
					parent.enableTabBtn();
				}catch(e){}
			}
		<%}%>
	}else{
		try{
			parent.enableTabBtn();
		}catch(e){}
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
            if(!window.confirm("<%= SystemEnv.getHtmlLabelName(83397,user.getLanguage())%>")) {
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

function showFTPConfig(){
    if(document.all("isUseFTP").checked){
        document.all("FTPConfigDiv").style.display = "block";
    }else{
    	document.all("FTPConfigDiv").style.display = "none";
    }
}

function loadDocFTPConfigInfo(obj){
	document.all("DocFTPConfigInfoGetter").src="DocFTPConfigIframe.jsp?operation=loadDocFTPConfigInfo&FTPConfigId="+obj.value;
}


function returnDocFTPConfigInfo(FTPConfigName,FTPConfigDesc,serverIP,serverPort,userName,userPassword,defaultRootDir,maxConnCount,showOrder){
	FTPConfigNameSpan.innerHTML=FTPConfigName;
	FTPConfigDescSpan.innerHTML=FTPConfigDesc;
	serverIPSpan.innerHTML=serverIP;
	serverPortSpan.innerHTML=serverPort;
	userNameSpan.innerHTML=userName;
	userPasswordSpan.innerHTML=userPassword;
	defaultRootDirSpan.innerHTML=defaultRootDir;
	maxConnCountSpan.innerHTML=maxConnCount;
	showOrderSpan.innerHTML=showOrder;
}

function setBacthDownload(o){
    var bacthDownload = document.getElementById("bacthDownload");
 	if(o.checked){
 	 //bacthDownload.value="1";
 	 //bacthDownload.checked=true;
 	 bacthDownload.disabled=true;
 	}else{
 	  bacthDownload.disabled=false;
 	  //bacthDownload.checked=false;
 	  //bacthDownload.value="";
 	}
 }

function checkPositiveNumber(label,obj){
	var def = jQuery(obj).attr("defValue");
	if(obj.value<0){
		alert("'"+label+"'<%=SystemEnv.getHtmlLabelName(22065,user.getLanguage())%>")
		obj.value=def;
	}
}

</script>
<script language=vbs>
sub onShowDirMould()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/DocSecCategoryTmplBrowser.jsp")
	if NOT isempty(id) then
		weaver.dirmouldid.value=id(0)&""
		dirmouldidname.innerHtml = id(1)&""
		if id(0)>0 then
			if MsgBox("<%=SystemEnv.getHtmlLabelName(18767,user.getLanguage())%>",49,"<%=SystemEnv.getHtmlLabelName(558,user.getLanguage())%>") = 1 then
				window.parent.location="DocSecCategorySaveAsTmplOperation.jsp?secCategoryId=<%=id%>&tmplId="&id(0)&"&method=getsettingfromtmpl"
			else
				weaver.dirmouldid.value=""
				dirmouldidname.innerHtml=""
			end if
		end if
	end if
end sub
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

sub onShowAppointedWorkflow(inputName,spanName)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?isValid=1")
	if NOT isempty(id) then
	    if id(0)<> 0 then
		    document.getElementById(inputName).value=id(0)
		    document.getElementById(spanName).innerHtml = id(1)
		else
		    document.getElementById(inputName).value=""
		    document.getElementById(spanName).innerHtml = empty
		end if
	end if
end sub

sub onShowPrintApplyWorkflow(inputName,spanName)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere= where isbill=1 and formid=200")
	if NOT isempty(id) then
	    if id(0)<> 0 then
		    document.getElementById(inputName).value=id(0)
		    document.getElementById(spanName).innerHtml = id(1)
		else
		    document.getElementById(inputName).value=""
		    document.getElementById(spanName).innerHtml = empty
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
sub onShowMutiDummy(input,span)	
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?treeDocFieldIds="+input.value)
	if NOT isempty(id) then
	    if id(0)<> "" then	
			dummyidArray=Split(id(0),",")
			dummynames=Split(id(1),",")
			dummyLen=ubound(dummyidArray)-lbound(dummyidArray) 

			For k = 0 To dummyLen
				sHtml = sHtml&"<a href='/docs/docdummy/DocDummyList.jsp?dummyId="&dummyidArray(k)&"'>"&dummynames(k)&"</a>&nbsp"
			Next

			input.value=id(0)
			span.innerHTML=sHtml
		else			
			input.value=""
			span.innerHTML=""
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
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
					</wea:item>
		</wea:group>
	</wea:layout>
</div>
<script type="text/javascript">
	jQuery(document).ready(function(){
		resizeDialog(document);
	});
</script>	
<%} %>
</BODY></HTML>
