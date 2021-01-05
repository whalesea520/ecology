
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager,
                 java.net.*" %>
<%@ page import="weaver.docs.category.security.MultiAclManager " %>
<%@ page import="weaver.docs.category.* " %>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="com.alibaba.fastjson.JSON"%>
<%@ page import="com.alibaba.fastjson.serializer.SerializerFeature"%>

<%@ include file="/systeminfo/init_wev8.jsp" %> 
<%@ include file="/docs/docs/iWebOfficeConf.jsp" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="MouldManager" class="weaver.docs.mouldfile.MouldManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocCheckInOutUtil" class="weaver.docs.docs.DocCheckInOutUtil" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DocDetailLog" class="weaver.docs.DocDetailLog" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link type="text/css" href="/css/ecology8/crudoc_wev8.css" rel="stylesheet"></link>

<jsp:include page="/systeminfo/WeaverLangJS.jsp">
    <jsp:param name="languageId" value="<%=user.getLanguage()%>" />
</jsp:include>

<%
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(58,user.getLanguage());
String needfav ="1";
String needhelp ="";
//判断金阁控件的版本	 2003还是2006
String canPostil = "";
if(isIWebOffice2006 == true){
	canPostil = ",1";
}
int languageId=user.getLanguage();

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

String f_weaver_belongto_userid=Util.null2String(request.getParameter("f_weaver_belongto_userid"));
String f_weaver_belongto_usertype=Util.null2String(request.getParameter("f_weaver_belongto_usertype"));
session.setAttribute("f_weaver_belongto_userid_doc",f_weaver_belongto_userid);
session.setAttribute("f_weaver_belongto_usertype_doc",f_weaver_belongto_usertype);

String temStr = request.getRequestURI();
temStr=temStr.substring(0,temStr.lastIndexOf("/")+1);
String mServerUrl=temStr+mServerName;
String mClientUrl=temStr+mClientName;

String usertype = user.getLogintype();
int ownerid = user.getUID() ;
String owneridname = ResourceComInfo.getResourcename(ownerid+"");
int docdepartmentid = user.getUserDepartment() ;

int mainid = -1;
int subid = -1;
int secid = -1;

RecordSet.execute("select * from modeinfo where id='2678'");
if(RecordSet.next()){
	mainid = Util.getIntValue(RecordSet.getString("maincategory"),-1);
	subid = Util.getIntValue(RecordSet.getString("subcategory"),-1);
	secid = Util.getIntValue(RecordSet.getString("seccategory"),-1);
}

String docmodule="";
String replyable="";
String categoryname = "";
String subcategoryid = "";
String docmouldid = "";
String publishable = "";
String shareable = "";
String readoptercanprint = "";
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

/*int haschecked =0;
int trueright = 0;
if (new MultiAclManager().hasPermission(secid, MultiAclManager.CATEGORYTYPE_SEC, user.getUID(), user.getType(), Integer.parseInt(user.getSeclevel()), MultiAclManager.OPERATION_CREATEDOC)) {
    trueright = 1;
}
if (secid < 0) {
    trueright = 1;
}
if(trueright!=1) {
    response.sendRedirect("/notice/noright.jsp");
    return;
}*/

int editType = Util.getIntValue(Util.null2String(request.getParameter("editType")),0);
//type 0查看布局   1新建布局  2编辑布局  (与表单建模一致)
String checkOutMessage=Util.null2String(request.getParameter("checkOutMessage"));  //已被检出提示信息
checkOutMessage=java.net.URLDecoder.decode(checkOutMessage,"UTF-8");
String checkOutMessage_jspinclude=URLEncoder.encode(URLEncoder.encode(checkOutMessage,"UTF-8"),"UTF-8");
String fwid = Util.null2String(request.getParameter("fwid"));
if("".equals(fwid)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String docType=".doc";
String gwid = "";
String laiwen = "";
String docsubject = "";
String sourcedocsubject = "";
String versionId = "";
String mbid = "";
String mbVersionId = "";

RecordSet.executeSql("select * from uf_fawen where id="+fwid);
if(RecordSet.next()){
	gwid = Util.null2String(RecordSet.getString("gwid"));
	laiwen = Util.null2String(RecordSet.getString("laiwen"));
	//sourcedocsubject = Util.null2String(RecordSet.getString("docsubject"));
	sourcedocsubject = "测试文档内容";
}
editType = "".equals(gwid)?1:(editType==1?0:editType);//如果没有找到对应的已有发文  则切换为新建  如果已有发文 新建切换到显示
if(editType == 2){
	if(!"".equals(gwid)){//编辑模式下判断文档签出状态
		int docid = Util.getIntValue(gwid);
		DocManager.resetParameter();
		DocManager.setId(docid);
		DocManager.getDocInfoById();
		
		int doccreaterid=DocManager.getDoccreaterid();
		String docCreaterType = DocManager.getDocCreaterType();//文档创建者类型（1:内部用户  2：外部用户）
		String _docsubject=DocManager.getDocsubject();
		_docsubject=Util.StringReplace(_docsubject,"\"", "&quot;");
		
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
		
		if(checkOutStatus!=null&&(checkOutStatus.equals("1")||checkOutStatus.equals("2"))&&!(checkOutUserId==user.getUID()&&checkOutUserType!=	null&&checkOutUserType.equals(user.getLogintype()))&&DocCheckInOutUtil.isCheckOutByOther(docid,user.getUID(),user.getLogintype())){
	
			checkOutMessage=SystemEnv.getHtmlLabelName(19695,languageId)+SystemEnv.getHtmlLabelName(19690,languageId)+"："+checkOutUserName;
	
		    checkOutMessage=URLEncoder.encode(URLEncoder.encode(checkOutMessage,"UTF-8"),"UTF-8");
		    response.sendRedirect("/govern/information/InformationEdit0.jsp?fwid="+fwid+"&editType=0&checkOutMessage="+checkOutMessage);
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
			DocDetailLog.setDocSubject(_docsubject);
			DocDetailLog.setOperateType("18");
			DocDetailLog.setOperateUserid(user.getUID());
			DocDetailLog.setUsertype(user.getLogintype());
			DocDetailLog.setClientAddress(request.getRemoteAddr());
			DocDetailLog.setDocCreater(doccreaterid);
			DocDetailLog.setCreatertype(docCreaterType);
			DocDetailLog.setDocLogInfo();  
		}
		try{
			DocCheckInOutUtil.saveDocCheckInOut(docid,"1",user.getUID(),user.getLogintype());
		}catch(Exception e){
	
		}
	}
}
RecordSet.executeSql("select di.versionId,dt.docsubject from docdetail dt,docimagefile di where dt.id=docid and dt.id="+gwid);
if(RecordSet.next()){
	versionId = Util.null2String(RecordSet.getString("versionId"));
	docsubject = Util.null2String(RecordSet.getString("docsubject"));
}

docsubject=java.net.URLDecoder.decode(docsubject,"UTF-8");
if(docsubject!=null&&!docsubject.trim().equals("")){
	docsubject=Util.StringReplace(docsubject,"\"","&quot;");
}

RecordSet.executeSql("select * from uf_doc_template");
if(RecordSet.next()){
	mbid = Util.null2String(RecordSet.getString("template"));
	String filename = Util.null2String(RecordSet.getString("imagefilename"));
	docType = filename.indexOf(".docx")>0 ? ".docx" : ".doc";
}

RecordSet.executeSql("select * from docimagefile where docid="+mbid);
if(RecordSet.next()){
	mbVersionId = Util.null2String(RecordSet.getString("versionId"));
}

String fileId = ("".equals(gwid)||"".equals(versionId)) ? (mbVersionId+"_"+mbid) : (versionId+"_"+gwid);

Map<String,Object> allDataMap = new HashMap<String,Object>();
RecordSet.executeSql("select u.id id,u.content content,u.title title,u.unit unit,u.section typeid,l.name type from uf_communication u right join uf_traffic_section l on u.section=l.id where u.id in ("
		+laiwen+")");
while(RecordSet.next()){
	String id = Util.null2String(RecordSet.getString("id"));
	String title = Util.null2String(RecordSet.getString("title"));
	String unit = Util.null2String(RecordSet.getString("unit"));
	String typeid = Util.null2String(RecordSet.getString("typeid"));
	String type = Util.null2String(RecordSet.getString("type"));
	String content = Util.null2String(RecordSet.getString("content"));
	
	if(!"".equals(typeid)){
		Map<String,Object> dataMap = allDataMap.containsKey(typeid) ? 
				(Map<String,Object>)allDataMap.get(typeid) : 
					new HashMap<String,Object>();
		List<Map<String,String>> list = allDataMap.containsKey(typeid) ? 
				(List<Map<String,String>>)dataMap.get("data") : 
					new ArrayList<Map<String,String>>();
		if(!allDataMap.containsKey(typeid)){
			dataMap.put("id",typeid);
			dataMap.put("name",type);
		}
		Map<String,String> map = new HashMap<String,String>();
		map.put("index",id);
		map.put("id",id);
		map.put("title",title);
		map.put("unitid",unit);
		map.put("unit",DepartmentComInfo.getDepartmentname(unit));
		map.put("typeid",typeid);
		map.put("type",type);
		map.put("content",content);
		list.add(map);
		dataMap.put("data",list);
		allDataMap.put(typeid,dataMap);
	}
}

String jsonData = JSON.toJSONString(allDataMap,SerializerFeature.DisableCircularReferenceDetect);

boolean isLocked = false;
%>
<script language="javascript" for=WebOffice event="OnMenuClick(vIndex,vCaption)">
    // 1.保存 2.存为草稿 3.预览 4.页眉 5.打开本地文件 6.存为本地文件 7.签名印章  9.显示隐藏 10.刷新窗口
    if (vIndex==1) onSave();
	else if (vIndex==2)  onDraft();
    else if (vIndex==3)  showMore();
    else if (vIndex==4)  showHeader();
    else if (vIndex==5)  WebOpenLocal();//打开本地文件
    else if (vIndex==6)  WebSaveLocal2();//存为本地文件
    else if (vIndex==7)  WebOpenSignature();//签名印章
    else if (vIndex==8)  doShare();//共享
    else if (vIndex==9)  onExpandOrCollapse();
    else if (vIndex==10) location.reload();
    else if (vIndex==13) acceptAll();  //接受修订
    else if (vIndex==33) ShowRevision();//显示/隐藏痕迹
    else if (vIndex==39) onEdit();//编辑
    else if (vIndex==47) onPrintDoc(); //打印
    else if (vIndex==71) onDownload(); //下载
	else if (vIndex == 85) changeRead();
	else if (vIndex == 95) appendass();
	else if(vIndex == 96) appendass1()
	else if(vIndex == 97) onLoadContent()
	
</script>

<script language=javascript>
window.console = window.console || (function () {
	var c ={}; 
	c.log = c.warn = c.debug = c.info = c.error = c.time = c.dir = c.profile= c.clear = c.exception = c.trace = c.assert = function(){};
	return c;
})();
	
var data = <%=jsonData%>;
var gwid = "<%=gwid%>";
var f_weaver_belongto_userid='<%=f_weaver_belongto_userid%>';
var f_weaver_belongto_usertype='<%=f_weaver_belongto_usertype%>';
function StatusMsg(mString){
	try{
		document.getElementById('loading-msg').innerHTML = mString;
	}catch(e){}
}

function onPrintDoc(){
	weaver.WebOffice.WebOpenPrint();
}

function onDownload(){
	WebSaveLocal2();
}

function onEdit(){
	location.href='InformationEdit0.jsp?fwid=<%=fwid%>&editType=2';  //编辑
}

var viewStatus = false;
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

function acceptAll(){
    document.getElementById("WebOffice").WebObject.Application.ActiveDocument.AcceptAllRevisions();
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

	<%if(editType == 2){%>
		weaver.WebOffice.WebSetMsgByName("SAVETYPE","EDIT");
	<%}%>
	
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
	
function initMenu(){
	weaver.WebOffice.ShowMenu="1";
  <%if(editType==0){%>
    weaver.WebOffice.AppendMenu("39","<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>");//编辑
    weaver.WebOffice.AppendMenu("71","<%=SystemEnv.getHtmlLabelName(31156,user.getLanguage())%>");//下载
    weaver.WebOffice.AppendMenu("47","<%=SystemEnv.getHtmlLabelName(257,user.getLanguage())%>");//打印
    weaver.WebOffice.AppendMenu("85","显示/隐藏红头");//
  <%}else if(editType==1){%>
    weaver.WebOffice.AppendMenu("1","<%=SystemEnv.getHtmlLabelName(615,languageId)%>");//提交
	weaver.WebOffice.AppendMenu("2","<%=SystemEnv.getHtmlLabelName(103,languageId)%>");//修改
	weaver.WebOffice.AppendMenu("5","<%=SystemEnv.getHtmlLabelName(16381,languageId)%>");//打开本地文件
	weaver.WebOffice.AppendMenu("6","<%=SystemEnv.getHtmlLabelName(16382,languageId)%>");//存为本地文件
	weaver.WebOffice.AppendMenu("7","<%=SystemEnv.getHtmlLabelName(16383,languageId)%>");//签名印章
	weaver.WebOffice.AppendMenu("85","显示/隐藏红头");//
  <%}else if(editType==2){%>
    weaver.WebOffice.AppendMenu("1","<%=SystemEnv.getHtmlLabelName(615,languageId)%>");//提交
	weaver.WebOffice.AppendMenu("2","<%=SystemEnv.getHtmlLabelName(103,languageId)%>");//修改
	weaver.WebOffice.AppendMenu("5","<%=SystemEnv.getHtmlLabelName(16381,languageId)%>");//打开本地文件
	weaver.WebOffice.AppendMenu("6","<%=SystemEnv.getHtmlLabelName(16382,languageId)%>");//存为本地文件
	weaver.WebOffice.AppendMenu("7","<%=SystemEnv.getHtmlLabelName(16383,languageId)%>");//签名印章
    weaver.WebOffice.AppendMenu("33","<%=SystemEnv.getHtmlLabelName(16385,languageId)%>");  //显示/隐藏痕迹
  	weaver.WebOffice.AppendMenu("13","<%=SystemEnv.getHtmlLabelName(129673,languageId)%>");  //接受修订
  	weaver.WebOffice.AppendMenu("85","显示/隐藏红头");//
  <%}%>
}

function onLoad(){
	var docType = "<%=docType%>";
	<%if(!isIE.equals("true")){%>
		if(!checkIWebPlugin()){
		    window.location.href="/wui/common/page/sysRemind.jsp?labelid=5";
		};
    <%}%>

    showPrompt("<%=SystemEnv.getHtmlLabelName(18974,languageId)%>");


    //weaver.WebOffice.WebUrl="<%=mServerUrl%>"
    document.body.scroll = "no";
    document.title="<%=SystemEnv.getHtmlLabelName(1986,languageId)%>";
    window.status="<%=SystemEnv.getHtmlLabelName(1986,languageId)%>";
		
    try{

        //添加菜单
        initMenu();
		weaver.WebOffice.AppendMenu("95","12");
		weaver.WebOffice.AppendMenu("96","13");
		weaver.WebOffice.AppendMenu("97","14");
        weaver.WebOffice.AppendMenu("11","-");
        
        weaver.WebOffice.WebUrl="<%=mServerUrl%>";
        weaver.WebOffice.RecordID="<%=fileId%>";
        weaver.WebOffice.Template="";
        weaver.WebOffice.FileName="";
	    try{
			weaver.WebOffice.Compatible  = false;
        }catch(e){
        }
        weaver.WebOffice.FileType="<%=docType%>";
		weaver.WebOffice.EditType="<%=editType%><%=canPostil%>";
			
	<%if(isIWebOffice2006 == true){%>
		weaver.WebOffice.ShowToolBar="0";      //ShowToolBar:是否显示工具栏:1显示,0不显示
	<%}else{%>
	      <%if(editType==0){%>
	        	document.getElementById("WebOffice").ShowToolBar="2";      //ShowToolBar:是否显示工具栏:1显示,0不显示  2 :隐藏OFFICE软件工具栏
          <%}%>
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

        var flag = weaver.WebOffice.WebOpen();  	//打开该文档
        weaver.WebOffice.WebObject.Saved=true;//added by cyril on 2008-06-10 检测文档是否被修改用
	<%if(isIWebOffice2006 == true){%>
		//iWebOffice2006 特有内容开始
		weaver.WebOffice.ShowType="1";  //文档显示方式  1:表示文字批注  2:表示手写批注  0:表示文档核稿
		//iWebOffice2006 特有内容结束
	<%}%>             
		weaver.WebOffice.DisableMenu("<%=SystemEnv.getHtmlLabelName(20757,user.getLanguage())%>");
		weaver.WebOffice.WebToolsEnable('Standard',109,false);
        weaver.WebOffice.WebToolsVisible("iSignature",false);//隐藏盖章按钮 
        StatusMsg(weaver.WebOffice.Status);

    }catch(e){console.log(e)}

  	//TD4213 增加提示信息  开始
    //oPopup.hide();
    hiddenPrompt();
    //TD4213 增加提示信息  结束
}
function onLoadEnd(){
	
}
function onLoadContent(){
	try{
		//if(!gwid){
			var con = "";
			for(var obj in data){
				var dataList = data[obj] ? data[obj].data : [];
				var id = data[obj] ? data[obj].id : "";
				var name = data[obj] ? data[obj].name : "";
				if(id && name){
					con += "【" + name + "】\n";
					for(var i=0;i<dataList.length;i++){
						var title = dataList[i].title;
						var content = dataList[i].content;
						con += " "+title + "。" + content + "\n";
					}
				}
			}
			weaver.WebOffice.WebObject.Application.Selection.Range.InsertAfter(con);
		//}
	}catch(e){console.log(e)}
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

function changeRead(){
	
}

function appendass1() {
    var object=weaver.WebOffice.WebObject;
    var ss = object.Shapes.Range(1);
    ss.Line.ForeColor="&HFFFFFF";
    ss.Line.Weight=0;
}

function appendass() {
	var object=weaver.WebOffice.WebObject;
 	var myl=object.Shapes.AddLine(100,160,305,160)
 	myl.Line.ForeColor=255;
 	myl.Line.Weight=2;
 	var myl1=object.Shapes.AddLine(326,160,520,160)
 	myl1.Line.ForeColor=255;
 	myl1.Line.Weight=2;
 	
	weaver.WebOffice.WebObject.Application.Selection.Range.InsertAfter("123123\n");
	var myRange=weaver.WebOffice.WebObject.Paragraphs(1).Range;
    
	myRange.ParagraphFormat.LineSpacingRule =1.5;
 	myRange.ParagraphFormat.Alignment=1;
 	myRange.font.ColorIndex=1;
 	myRange.font.Bold = 1; 
}

function openByDocType(type) {
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

function showMore(){
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	//dialog.callbackfunParam = null;
	dialog.URL = "/systeminfo/BrowserMain.jsp?url=/govern/information/ContentSelect.jsp";
	dialog.callbackfun = function (paramobj, id1) {
		
		appendass();
	}
	dialog.Title = "";//请选择
	dialog.Width = 550 ;
	dialog.Height = 600;
	dialog.Drag = true;
	//dialog.maxiumnable = true;
	dialog.show();
}

</script>
<script language="javascript" src="/js/doc/DocAddScript_wev8.js"></script>
<Title id="Title"></Title>
</head>

<body class="ext-ie ext-ie8 x-border-layout-ct" id="mybody" scroll="no" onunload="UnLoad()" onbeforeunload="protectDoc()">

<FORM id=weaver name=weaver action="UploadInformation.jsp?dataId=<%=fwid %>" method=post  enctype="multipart/form-data">
<!--该参数必须作为Form的第一个参数,并且不能在其他地方调用，用于解决在IE6.0中输入·这个特殊符号存在的问题-->
<INPUT TYPE="hidden" id="docIdErrorError" NAME="docIdErrorError" value="">
<%@ include file="/systeminfo/DocTopTitle.jsp"%>
<input type="hidden" name="onbeforeunload_protectDoc" onclick="protectDoc_include()"/>
<input type="hidden" name="onbeforeunload_protectDoc_return"/>
<input id="f_weaver_belongto_userid" name="f_weaver_belongto_userid" type="hidden" value="<%=f_weaver_belongto_userid%>">
<input id="f_weaver_belongto_usertype" name="f_weaver_belongto_usertype" type="hidden" value="<%=f_weaver_belongto_usertype%>">

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

	if(editType==0){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:onEdit(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		
		RCMenu += "{"+SystemEnv.getHtmlLabelName(31156,user.getLanguage())+",javascript:WebSaveLocal2(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		
		RCMenu += "{"+SystemEnv.getHtmlLabelName(257,user.getLanguage())+",javascript:onPrintDoc(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		
	}else if(editType==1){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSave(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;

		RCMenu += "{"+SystemEnv.getHtmlLabelName(103,user.getLanguage())+",javascript:showMore(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		
		RCMenu += "{"+SystemEnv.getHtmlLabelName(16381,user.getLanguage())+",javascript:WebOpenLocal(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		
		RCMenu += "{"+SystemEnv.getHtmlLabelName(16382,user.getLanguage())+",javascript:WebSaveLocal2(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;

		RCMenu += "{"+SystemEnv.getHtmlLabelName(16383,user.getLanguage())+",javascript:WebOpenSignature(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}else if(editType==2){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSave(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;

		RCMenu += "{"+SystemEnv.getHtmlLabelName(103,user.getLanguage())+",javascript:showMore(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		
		RCMenu += "{"+SystemEnv.getHtmlLabelName(16381,user.getLanguage())+",javascript:WebOpenLocal(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		
		RCMenu += "{"+SystemEnv.getHtmlLabelName(16382,user.getLanguage())+",javascript:WebSaveLocal2(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;

		RCMenu += "{"+SystemEnv.getHtmlLabelName(16383,user.getLanguage())+",javascript:WebOpenSignature(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		
		RCMenu += "{"+SystemEnv.getHtmlLabelName(16385,user.getLanguage())+",javascript:ShowRevision(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		
		RCMenu += "{"+SystemEnv.getHtmlLabelName(129673,user.getLanguage())+",javascript:acceptAll(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	

	int tmpindex = 0;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
//文档的id 插件提交文档后设置这个值
%>
<script>
jQuery(document).ready(function(){
	 jQuery("div#divTab").show();
	 <%if(secid<=0){%>
	 	jQuery("#divPropATab").addClass("x-tab-strip-div-disabled").hide();
	 	jQuery("#divAccATab").addClass("x-tab-strip-div-disabled").hide();
	 <%}else{%>
	 	loadPropAndAcc0(<%=secid%>);
	 <%}%>
});
function loadPropAndAcc0(seccategory,treeNode,catoptions){
	//loadPropAndAcc(seccategory,treeNode,catoptions);//信息采编暂时不需要其他选项卡
}
</script>

<INPUT TYPE="hidden" id="docId" NAME="docId" value="<%=gwid%>">
<INPUT TYPE="hidden" id="id" NAME="id" value="<%=gwid%>">
<INPUT TYPE="hidden" id="docType" NAME="docType" value="<%=docType%>">
<input type="hidden" name="SecId" id="SecId" value="<%=secid%>">
<input type="hidden" name=operation>
<input type="hidden" name=versionId value="<%=versionId%>">
<input type="hidden" name="fwid" id="fwid"  value="<%=fwid%>">
<input type="hidden" name="docsubject" id="docsubject" value="<%="".equals(docsubject)?sourcedocsubject:docsubject%>">
<input type="hidden" name="docreplyable" value="<%=replyable%>">
<input type="hidden" name="usertype" value="<%=usertype%>">
<input type="hidden" name="from">
<input type="hidden" name="source" id="source" value="DocAddExt">
<input type="hidden" name="userId" value="<%=user.getUID()%>">
<input type="hidden" name="userType" value="<%=user.getLogintype()%>">

<input type="hidden" name="docstatus" value="0">
<input type="hidden" name="docedition" value="-1">
<input type="hidden" name="doceditionid" value="-1">
<input type="hidden" name="maincategory" value="<%=(mainid==-1?"":Integer.toString(mainid))%>">
<INPUT type="hidden" name="subcategory" value="<%=(subid==-1?"":Integer.toString(subid))%>">
<INPUT type="hidden" name="seccategory" id="seccategory" value="<%=(secid==-1?"":Integer.toString(secid))%>">
<input type="hidden" name="ownerid" value="<%=ownerid%>">
<input type="hidden" name="docdepartmentid" value="<%=docdepartmentid%>">
<input type="hidden" name="doclangurage" value="<%=languageId%>">
<INPUT type="hidden" name="maindoc" id="maindoc" value="-1">

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
		<%if(editType==0){%> 
			<input type=button class="e8_btn_top" onclick="onEdit();" value="<%=SystemEnv.getHtmlLabelName(93, user.getLanguage())%>"></input>
			<input type=button class="e8_btn_top" onclick="WebSaveLocal2();" value="<%=SystemEnv.getHtmlLabelName(31156, user.getLanguage())%>"></input>
			<input type=button class="e8_btn_top" onclick="onPrintDoc();" value="<%=SystemEnv.getHtmlLabelName(257, user.getLanguage())%>"></input>
		<%}else if(editType==1||editType==2){%>
			<input type=button class="e8_btn_top" onclick="onSave();" value="<%=SystemEnv.getHtmlLabelName(615, user.getLanguage())%>"></input>
			<input type=button class="e8_btn_top" onclick="showMore();" value="修改"></input>
		<%}%>
			<input type=button class="e8_btn_top" onclick="changeRead();" value="显示/隐藏红头"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
	<jsp:include page="/systeminfo/commonTabHead.jsp">
	   <jsp:param name="mouldID" value="formmode"/>
	   <jsp:param name="navName" value='信息采编'/>
	   <jsp:param name="exceptHeight" value="true"/>
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
					callback();
				}
				function doCheckDocSubject(req){						
					
				}
				function checkSubjectRepeated(){
					return true;
				}
				
				
			</script>

	<input type="hidden" name="needinputitems" id="needinputitems" value="seccategory,docsubject"/>
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
		
		<!--  <LI id=divPropATab class="" onclick="onActiveTab('divProp');">
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
		</LI>-->
		
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
var prjid = "";
var coworkid="";
var crmid="";
var hrmid="";
var doctype="<%=docType%>";
var isFromWf=false;

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

function getneedinputitems(){
	var allneedinputitems = document.getElementsByName("needinputitems");
	var needinputitemsstr = "";
	if(allneedinputitems&&allneedinputitems.length)
	for(var i=0;i<allneedinputitems.length;i++)
	if(allneedinputitems[i]&&allneedinputitems[i].value) needinputitemsstr += ","+allneedinputitems[i].value;
	return needinputitemsstr;
}

jQuery(document).ready(
	function(){
		
		<%if(!"".equals(checkOutMessage)){%>
			top.Dialog.alert("<%=checkOutMessage%>");
		<%}%>
		try{
			onLoad();
		} catch(e){}

		document.title="信息采编";
		
		
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


		try{	
			onLoadEnd();
		} catch(e){}
	}   
);
</script>
<%if(editType==1){%>
<script language="javascript" type="text/javascript">
function onSave(){
	try{
		disableTabBtn();
	}catch(e){
		console.log(e)
	}
	if(!jQuery("#seccategory").val()){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81559,user.getLanguage())%>");
		try{
			enableTabBtn();
		}catch(e){}
		return;
	}
	checkDocSubject($GetEle("docsubject"),function(){
		/*if($GetEle("namerepeated").value==1){
			try{
				enableTabBtn();
			}catch(e){}
			return;
		}*/
		afterSaveValidate();
	});
}

function afterSaveValidate(){
       	if(!check_form(document.weaver,getNeedinputitems())){
			enableTabBtn();
		}
	    if(checkSubjectRepeated()){
		//document.getElementById("btn_saveid").disabled=true;
		//document.getElementById("btn_draft").disabled=true;


	        document.weaver.operation.value='addsave';
		    if(SaveDocument()){
		        mybody.onbeforeunload=null;

                showPrompt("<%=SystemEnv.getHtmlLabelName(18885,languageId)%>");
                 try{
		        	Ext.getCmp("divContentTab").getBottomToolbar().disable();
		        }catch(e){}
		        document.weaver.submit();
		    }
		} else {
		try{
			enableTabBtn();
		}catch(e){}
       }
}
</script>
<%}else if(editType==2){%>
<script type='text/javascript' src='/dwr/interface/DocDwrUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<script language="javascript" type="text/javascript">
function onSave(notSubmit){
	disableTabBtn();
	//setTimeout("btndisabledfalse();",10000);
	var isIWebOffice2006 = <%=isIWebOffice2006 %>;
	
	DocDwrUtil.ifCheckOutByCurrentUser("<%=gwid%>",<%=user.getUID()+""%>,{
		callback:function(result){
			if(result) {
				checkDocSubject($GetEle("docsubject"),function() {
					afterSaveValidate();
				});
			} else {
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(26090,user.getLanguage())%>");
				return;
			}
		}
	});
}

/*
 * isFromAccessory 是否是附件
 * newVersion 是否生成新版本
 * notSubmit  是否提交form  true仅保存,false保存并提交
 * closeCurPage 保存后是否需要关闭页面  true关闭
 */
function afterSaveValidate(isFromAccessory,newVersion,notSubmit,closeCurPage){
	if(check_form(document.weaver,getneedinputitems())&&checkSubjectRepeated()){//如果是附件编辑提交的话，不需要验证文档的字段信息。
		document.weaver.operation.value='editsave';
		var saveStatus;
		weaver.WebOffice.WebSetMsgByName("VERSIONDETAIL","<%=SystemEnv.getHtmlLabelName(28121, user.getLanguage())%>");
		weaver.WebOffice.WebSetMsgByName("CLIENTADDRESS","<%=request.getRemoteAddr()%>");
		saveStatus=SaveDocument();
		if(saveStatus){
			mybody.onbeforeunload = null;
			showPrompt("<%=SystemEnv.getHtmlLabelName(18893,user.getLanguage())%>");
			//Ext.getCmp("divContentTab").getBottomToolbar().disable();
			document.weaver.submit();
		}
    }
}
</script>
<%}%>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
