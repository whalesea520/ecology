<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
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
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ctci" class="weaver.hrm.contract.ContractTypeComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<%
if(!HrmUserVarify.checkUserRight("HrmContractEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
String rightStr = "";
if(HrmUserVarify.checkUserRight("HrmContractEdit:Edit", user)){
rightStr="HrmContractEdit:Edit";
}
%>
<%
  Calendar todaycal = Calendar.getInstance ();
  String today = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;
                 
String id = Util.null2String(request.getParameter("id"));
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
String contractman = "";
String startdate = "";
String enddate = "";
String proenddate = "";
String typeid = "";
int docid = 0;

String sql = "select * from HrmContract where id = "+id;
rs.executeSql(sql);

while(rs.next()){
  contractman = rs.getString("contractman");
  typeid = rs.getString("contracttypeid");
  startdate = rs.getString("contractstartdate");
  enddate = rs.getString("contractenddate");
  proenddate = rs.getString("proenddate");
  docid = Util.getIntValue(rs.getString("contractdocid"),0);
}

int aheaddate = ctci.getRemindAheadDate(typeid);

String ishrm = "";
sql = "select * from HrmContractType where id = "+typeid;

rs.executeSql(sql);
while(rs.next()){  
  ishrm = rs.getString("ishirecontract");  
}

String man = Util.null2String(request.getParameter("contractman"));
if(!man.equals("")){
  contractman = man;
}

sql = "select startdate,enddate,probationenddate from HrmResource where id = "+contractman;

rs.executeSql(sql);

while(rs.next()){
   if(ishrm.equals("1")){
   //根据qc212896 不需要 合同开始和合同结束日期同人事卡片一致  
     //startdate = rs.getString("startdate");
    // enddate  = rs.getString("enddate");
   }
   //proenddate = rs.getString("probationenddate");
}

String subid=Util.null2String(request.getParameter("subid"));
int SecId=Util.getIntValue(Util.null2String(request.getParameter("SecId")),0);

String needinputitems = "";


//int docid = Util.getIntValue(request.getParameter("id"),0);
DocManager.resetParameter();
DocManager.setId(docid);
DocManager.getDocInfoById();
int docType = DocManager.getDocType();
if(docType == 2){
    response.sendRedirect("HrmContractEditExt.jsp?id="+id);
}

//文档信息
    int maincategory=DocManager.getMaincategory();
    int subcategory=DocManager.getSubcategory();
    int seccategory=DocManager.getSeccategory();
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

DocManager.closeStatement();
String docmain = "";

if(ownerid==0) ownerid=user.getUID() ;
String owneridname=ResourceComInfo.getResourcename(ownerid+"");
//子目录信息
RecordSet.executeProc("Doc_SecCategory_SelectByID",seccategory+"");
RecordSet.next();
String categoryname=Util.toScreenToEdit(RecordSet.getString("categoryname"),user.getLanguage());
String subcategoryid=Util.null2String(""+RecordSet.getString("subcategoryid"));
String docmouldid=Util.null2String(""+RecordSet.getString("docmouldid"));
String publishable=Util.null2String(""+RecordSet.getString("publishable"));
String replyable=Util.null2String(""+RecordSet.getString("replyable"));
String shareable=Util.null2String(""+RecordSet.getString("shareable"));
String cusertype=Util.null2String(""+RecordSet.getString("cusertype"));
    cusertype = cusertype.trim();
String approvewfid=RecordSet.getString("approveworkflowid");
String needapprovecheck="";
    if(approvewfid.equals(""))  approvewfid="0";
    if(approvewfid.equals("0")) 
        needapprovecheck="0";
    else
        needapprovecheck="1";
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
String ddip=Util.null2String(request.getParameter("departmentid"));
String ssid=Util.null2String(request.getParameter("subcompanyid"));

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =  SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(614,user.getLanguage())+":"+Util.add0(docid,12);
String needfav ="1";
String needhelp ="";
%>

<html><head>
<link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<script language="javascript" src="/js/weaver_wev8.js"></script>


<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script>

<script language="javascript" type="text/javascript">
var clsDT;
blnIsNeedOnload=false
window.onload=function(){
	var lang=<%=(user.getLanguage()==8)?"true":"false"%>;
	CkeditorExt.initEditor('weaver','doccontent',lang, "", 500);
};
</script>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//if(!docstatus.equals("3") && !docstatus.equals("4")) {
//RCMenu += "{"+SystemEnv.getHtmlLabelName(220,user.getLanguage())+",javascript:onDraft(this),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(221,user.getLanguage())+",javascript:onPreview(this),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
//}
RCMenu += "{"+SystemEnv.getHtmlLabelName(222,user.getLanguage())+",javascript:switchEditMode(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(224,user.getLanguage())+",javascript:showHeader(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(HrmUserVarify.checkUserRight("HrmContractDelete:Delete", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(Util.dayDiff(today,enddate)==aheaddate ||Util.dayDiff(today,proenddate)==aheaddate){
RCMenu += "{"+SystemEnv.getHtmlLabelName(15781,user.getLanguage())+",javascript:oninfo(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/contract/contract/HrmContractView.jsp?id="+id+",_self} " ;
//RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(156,user.getLanguage())+",javascript:addannexRow(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table style="position: relative;width: 100%;">
<tr>
<td>
<b><%=SystemEnv.getHtmlLabelName(401,user.getLanguage())%>:</b><%=doccreatedate%>&nbsp;<%=doccreatetime%>&nbsp<b> 
  <%=SystemEnv.getHtmlLabelName(623,user.getLanguage())%>:</b><a href="/hrm/resource/HrmResource.jsp?id=<%=doccreaterid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(""+doccreaterid),user.getLanguage())%></a> 
 <b><%=SystemEnv.getHtmlLabelName(103,user.getLanguage())%>:</b><%=doclastmoddate%>&nbsp;<%=doclastmodtime%>&nbsp<b> 
  <%=SystemEnv.getHtmlLabelName(623,user.getLanguage())%>:</b><a href="/hrm/resource/HrmResource.jsp?id=<%=doclastmoduserid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(""+doclastmoduserid),user.getLanguage())%></a> 
 </td>
  </tr>
</table> 
<form id=weaver name=weaver action="/docs/docs/UploadDoc.jsp?ddip=<%=ddip%>&ssid=<%=ssid%>" method=post enctype="multipart/form-data">
<input class=inputstyle type=hidden name=docapprovable value="<%=needapprovecheck%>">
<input class=inputstyle type=hidden name=isreply value="<%=isreply%>">
<input class=inputstyle type=hidden name=replydocid value="<%=replydocid%>">

<input class=inputstyle type=hidden name=docreplyable value="<%=replyable%>">
<input class=inputstyle type=hidden name=docstatus value="0">
<input class=inputstyle type=hidden name=olddocstatus value="<%=docstatus%>">
<input class=inputstyle type=hidden name=doccreaterid value="<%=doccreaterid%>">
<input class=inputstyle type=hidden name=doccreatedate value="<%=doccreatedate%>">
<input class=inputstyle type=hidden name=doccreatetime value="<%=doccreatetime%>">
<input class=inputstyle type=hidden name=docapproveuserid value="<%=docapproveuserid%>">
<input class=inputstyle type=hidden name=docapprovedate value="<%=docapprovedate%>">
<input class=inputstyle type=hidden name=docapprovetime value="<%=docapprovetime%>">
<input class=inputstyle type=hidden name=docarchiveuserid value="<%=docarchiveuserid%>">
<input class=inputstyle type=hidden name=docarchivedate value="<%=docarchivedate%>">
<input class=inputstyle type=hidden name=docarchivetime value="<%=docarchivetime%>">
<input class=inputstyle type=hidden name=usertype value="<%=usertype%>">
<input class=inputstyle type=hidden name="ownerid" value="<%=ownerid%>">
<input class=inputstyle type=hidden name="oldownerid" value="<%=ownerid%>">
<input class=inputstyle type=hidden name="docdepartmentid" value="<%=docdepartmentid%>">
<input class=inputstyle type=hidden name=doclangurage value="<%=doclangurage%>">
<input class=inputstyle type=hidden name=urlfrom value=hr>
<input class=inputstyle type=hidden name=conId value=<%=id%>>
<input class=inputstyle type=hidden name=typeid value=<%=typeid%>>
<input type=hidden name=maincategory value="<%=maincategory%>">
<input type=hidden name=subcategory value="<%=subcategory%>">
<input type=hidden name=seccategory value="<%=seccategory%>">


<%
if(!publishable.trim().equals("") && !publishable.trim().equals("0")){
%>
<table class=viewform>
<tbody>
<tr>
<td width=15%><b><%=SystemEnv.getHtmlLabelName(114,user.getLanguage())%></b></td>
<td width=40%>
<%
String ischeck1="";
String ischeck2="";
String ischeck3="";
if(docpublishtype.equals("1")) ischeck1=" checked";

if(docpublishtype.equals("2")) {
	ischeck2=" checked";
	int tmppos = doccontent.indexOf("!@#$%^&*");
	if(tmppos!=-1){
		docmain = doccontent.substring(0,tmppos);
		doccontent = doccontent.substring(tmppos+8,doccontent.length());
	}
}

if(docpublishtype.equals("3")) ischeck3=" checked";
%>
<input class=inputstyle type=radio name="docpublishtype" value=1 <%=ischeck1%> onClick="onshowdocmain(0)"><font color=red><%=SystemEnv.getHtmlLabelName(1984,user.getLanguage())%></font>
<input class=inputstyle type=radio name="docpublishtype" value=2 <%=ischeck2%> onClick="onshowdocmain(1)"><font color=red><%=SystemEnv.getHtmlLabelName(227,user.getLanguage())%></font>
<input class=inputstyle type=radio name="docpublishtype" value=3 <%=ischeck3%> onClick="onshowdocmain(0)"><font color=red><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></font>
</td>
</tbody>
</table>
<%}%>
 <table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
	
        <input type=button class="e8_btn_top" onclick="onSave(this);" value="<%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%>"></input>
		
		<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
   </table>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
   <wea:item><%=SystemEnv.getHtmlLabelName(15776,user.getLanguage())%></wea:item>
   <wea:item> 
  	<%					
  	/*
  		int[] subcomids = CheckSubCompanyRight.getSubComPathByUserRightId(user.getUID(),"HrmContractAdd:Add",0);
String whereClause = "";
for(int i=0; i<subcomids.length; i++){
	if(i!=0){
		whereClause+=",";
	}
	whereClause += String.valueOf(subcomids[i]);
}
String sqlwherestr = "?sqlwhere= hr.subcompanyid1 in( "+whereClause+")";
	*/
					String sqlwherestr = "";
					boolean onlyselfdept = CheckSubCompanyRight.getDecentralizationAttr(user.getUID(),"HrmContractAdd:Add",-1,-1,1);
					boolean isall = CheckSubCompanyRight.getIsall();
					String departments = CheckSubCompanyRight.getDepartmentids();
					String subcompanyids = CheckSubCompanyRight.getSubcompanyids();
					if(!isall){
						if(onlyselfdept){
							sqlwherestr = " ("+Util.getSubINClause(departments, "t1.departmentid", "in") +") ";
						}else{
							sqlwherestr = " ("+Util.getSubINClause(subcompanyids, "t1.subcompanyid1", "in") +") ";
						}
					}
					String browserUrl = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowserByRight.jsp?rightStr=HrmContractAdd:Add";
					String dataUrl = "/data.jsp";
					if(!"".equals(sqlwherestr)){
						dataUrl = "/data.jsp?whereClause="+xssUtil.put(sqlwherestr);
					}
				%>
	  			 <brow:browser viewType="0" name="contractman" browserValue='<%=contractman %>' 
            browserUrl='<%=browserUrl%>'
            hasInput="true" isSingle="true" hasBrowser="true" isMustInput='2'
            completeUrl='<%=dataUrl%>' linkUrl="javascript:openhrm($id$)" width="120px"
            browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(contractman),user.getLanguage()) %>'
            ></brow:browser>
            <%
		    needinputitems += ",contractman";
		    %>
   </wea:item>
   <wea:item attributes="{'samePair':'conHead'}"><%=SystemEnv.getHtmlLabelName(15777,user.getLanguage())%></wea:item>
   <wea:item attributes="{'samePair':'conHead'}"> 
     <button class=Calendar type="button" id=selectcontractstartdate onClick="getDate(contractstartdatespan,contractstartdate)"></button> 
     <span id=contractstartdatespan ><%=startdate%></span> -&nbsp;&nbsp;
     <button class=Calendar  type="button"id=selectcontractenddate onClick="getDate(contractenddatespan,contractenddate)"></button> 
     <span id=contractenddatespan ><%=enddate%></span> 
     <input class=inputstyle type="hidden" name="contractstartdate" value="<%=startdate%>">
     <input class=inputstyle type="hidden" name="contractenddate" value="<%=enddate%>">
   </wea:item>
<%
 if(ishrm.equals("1")){
%>  
   <wea:item attributes="{'samePair':'conHead'}"><%=SystemEnv.getHtmlLabelName(15778,user.getLanguage())%></wea:item>
   <wea:item attributes="{'samePair':'conHead'}"> 
     <button class=Calendar type="button" id=selectproenddate onClick="getDate(proenddatespan,proenddate)"></button> 
     <span id=proenddatespan ><%=proenddate%></span>       
     <input class=inputstyle type="hidden" name="proenddate" value="<%=proenddate%>">      
   </wea:item>
<%}%>
	<wea:item attributes="{'isTableList':'true'}">
		<input class=inputstyle type=hidden name=accessorynum value="1">
		<wea:layout type="2col" attributes="{'formTableId':'accessoryTable'}">
			<wea:group context="" attributes="{'groupDisplay':'none'}">
		<%
        if(!hasaccessory.trim().equals("")){
            int i= 0;
            DocImageManager.resetParameter();
            DocImageManager.setDocid(docid);
            DocImageManager.selectDocImageInfo();
            while(DocImageManager.next()){
                String curimgid = DocImageManager.getImagefileid();
                String curimgname = DocImageManager.getImagefilename();
        //	while(i<accessorynum){
                i++;
                String curlabel = SystemEnv.getHtmlLabelName(156,user.getLanguage())+i;
        %>
        <wea:item><%=curlabel%></wea:item>
        <wea:item>
	        <a href="/weaver/weaver.file.FileDownload?fileid=<%=curimgid%>"><%=curimgname%></a>&nbsp;
	        <button class=btnDelete accessKey=<%=i%> onClick="onDelpic(<%=curimgid%>)"><u><%=i%></u>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>
	        </button>
        </wea:item>
        <%
            }}
            %>

            <%
                 String curlabel = SystemEnv.getHtmlLabelName(156,user.getLanguage());
        %>
        <wea:item><%=curlabel%></wea:item>
        <wea:item>
        <input class=inputstyle type=file size=70 name=accessory1>
        </wea:item>
        </wea:group>
		</wea:layout>
	</wea:item>
	</wea:group>
</wea:layout>

<script language=javascript>
function switchEditMode(ename){
	var oEditor = CKEDITOR.instances.doccontent;
	oEditor.execCommand("source");
}
function showHeader(){    
 	if(true)
 		hideEle("conHead");
 	else
 		showEle("conHead");
}
</script>
<table class=viewform>
<tbody>
<tr class=spacing style="height:2px"><td class=line1 colspan=2></td></tr>
<tr>
<td width=15%><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></td>
<td width=85% class=field>
<input class=inputstyle  size=70 name=docsubject  value="<%=docsubject%>" onChange="checkinput('docsubject','docsubjectspan')">
<span id=docsubjectspan></span>
<%needinputitems += ",docsubject";%>
</td>
</tr>
<tr id=otrtmp <%if(!docpublishtype.equals("2")){%>style="display:none"<%}%>>
<td width=20%><%=SystemEnv.getHtmlLabelName(341,user.getLanguage())%></td>
<td width=80% class=field>
<input class=inputstyle  size=70 name="docmain" value="<%=docmain%>" onChange="checkinput('docmain','docmainspan')" >
<span id="docmainspan">
</span>
<%
//needinputitems += ",docmain";
%>
</td>
</tr>
</tbody>
</table>

<table class=LayoutTable>
<tbody>
<tr class=spacing style="height:2px">
<td class=line1 colspan=2></td></tr>
<!--###@2007-08-29 modify by yeriwei!
<tr><td>
<%//SystemEnv.getHtmlLabelName(681,user.getLanguage())%>
</td><td>
<div id=divimg name="divimg">
<input class=inputstyle type=file name=docimages_0 size=60></input>
</div>
<input class=inputstyle type=hidden name=docimages_num value=0></input>
</td></tr>
--->
<%
int oldpicnum = 0;
int pos = doccontent.indexOf("<img alt=\"");
while(pos!=-1){
	pos = doccontent.indexOf("?fileid=",pos);
	int endpos = doccontent.indexOf("\"",pos);
	String tmpid = doccontent.substring(pos+8,endpos);
	int startpos = doccontent.lastIndexOf("\"",pos);
	String servername = request.getServerName();
	String tmpcontent = doccontent.substring(0,startpos+1);
	tmpcontent += "http://"+servername+":"+request.getServerPort();;
	tmpcontent += doccontent.substring(startpos+1);
	doccontent=tmpcontent;
%>
<input class=inputstyle type=hidden name=olddocimages<%=oldpicnum%> value="<%=tmpid%>">
<%
	pos = doccontent.indexOf("<img alt=\"",endpos);
	oldpicnum += 1;
}
%>
<input class=inputstyle type=hidden name=olddocimagesnum value="<%=oldpicnum%>">
<tr><td colspan=2 id=doccontenttd>
<textarea name=doccontent style="display:none;width:100%;height:500px"><%=doccontent%></textarea>
<!---###@2007-08-29 modify by yeriwei!
<div id=divifrm style="display:;">
<iframe frameborder=0 style="width:100%;height:500px" name="dhtmlFrm" id="dhtmlFrm" src="/docs/docs/dhtml.jsp"></iframe>

</div>
--->

</td>

</tr>
</TBODY>
</table>

<script language=vbs>
sub onShowLanguage()
	id = window.showModalDialog("/systeminfo/language/LanguageBrowser.jsp")
	language.innerHtml = id(1)
	weaver.doclangurage.value=id(0)
end sub
</script>  
<input class=inputstyle type=hidden name=operation>
<input class=inputstyle type=hidden name=id value="<%=docid%>">
<input class=inputstyle type=hidden name=delimgid>
</form>

<script language=vbs>
sub onShowResource()
	doccontenttd.innerHtml="<textarea id='doccontent' name='doccontent' style='display:none;width:100%;height:500px'></textarea>"
	if <%=detachable%> <> 1 then
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	else
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowserByRight.jsp?rightStr=<%=rightStr%>")
end if
	if NOT isempty(id) then
	    if id(0)<> "" then
			contractmanspan.innerHtml = "<a href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</a>"
			weaver.contractman.value=id(0)
			weaver.contractman.value=id(1)
			else
			contractmanspan.innerHtml = " <IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			weaver.contractman.value=""

		end if
			weaver.action="HrmContractEdit.jsp?id=<%=id%>&contractman="&id(0)
			weaver.submit()
	else
		//TD8673
		//为解决因为模板内容过多而导致系统无响应的问题，所以使页面自动刷新
	weaver.action="HrmContractEdit.jsp?id=<%=id%>&contractman="&weaver.contractman.value
	weaver.submit()

	end if

end sub

sub onShowHrmresID(objval)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")

	if (Not IsEmpty(id)) then
		if id(0)<> "" then
			hrmresspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
			weaver.hrmresid.value=id(0)
		else
			if objval="2" then
				hrmresspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			else
				hrmresspan.innerHtml =""
			end if
			weaver.hrmresid.value=""
		end if
	end if
end sub

sub onShowAssetId(objval)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	assetidspan.innerHtml = "<A href='/cpt/capital/CapitalBrowser.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	weaver.assetid.value=id(0)
	else
		if objval="2" then
				assetidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			else
				assetidspan.innerHtml =""
			end if
	weaver.assetid.value="0"
	end if
	end if
end sub

sub onShowItemID(objval)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/asset/LgcAssetBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	itemspan.innerHtml = "<A href='/lgc/asset/LgcAsset.jsp?paraid="&id(0)&"'>"&id(1)&"</A>"
	weaver.itemid.value=id(0)
	else
		if objval="2" then
				itemspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			else
				itemspan.innerHtml =""
			end if
	weaver.itemid.value="0"
	end if
	end if
end sub

sub onShowItemmaincategoryID(objval)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssortmentBrowserAll.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	itemmaincategorypan.innerHtml = id(1)
	weaver.itemmaincategoryid.value=id(0)
	else
		if objval="2" then
				itemmaincategorypan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			else
				itemmaincategorypan.innerHtml =""
			end if
	weaver.itemmaincategoryid.value="0"
	end if
	end if
end sub


sub onShowCrmID(objval)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	crmidspan.innerHtml = "<A href='/CRM/data/ViewCustomer.jsp?CustomerID="&id(0)&"'>"&id(1)&"</A>"
	weaver.crmid.value=id(0)
	else
		if objval="2" then
				crmidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			else
				crmidspan.innerHtml =""
			end if
	weaver.crmid.value="0"
	end if
	end if
end sub

sub onShowProjectID(objval)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	projectidspan.innerHtml = "<A href='/proj/data/ViewProject.jsp?ProjID="&id(0)&"'>"&id(1)&"</A>"
	weaver.projectid.value=id(0)
	else
	if objval="2" then
				projectidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			else
				projectidspan.innerHtml =""
			end if
	weaver.projectid.value="0"
	end if
	end if
end sub
</script>

<script language="javascript">
function onshowdocmain(vartmp){
	if(vartmp==1)
		otrtmp.style.display='';
	else
		otrtmp.style.display='none';
}

<%--Add by Charoes Huang ON May 21,2004--%>
function checkDateValidity(){
    var isValid = false;
    isValid = checkDateRange(weaver.contractstartdate,weaver.contractenddate,"<%=SystemEnv.getHtmlLabelName(16721,user.getLanguage())%>")<%if(ishrm.equals("1")){%>&&checkDateBetween(weaver.contractstartdate.value,weaver.proenddate.value,weaver.contractenddate.value,"<%=SystemEnv.getHtmlLabelName(17411,user.getLanguage())%>")<%}%>;
    return isValid;
}

function onSave(obj){
	
		  if(check_form(document.weaver,'<%=needinputitems%>')&&checkDateValidity()){
    obj.disabled = true;
	/***###@2007-08-29 modify by yeriwei!
	text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
	text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
	document.weaver.doccontent.innerText=text;
	****/
	CkeditorExt.updateContent();
	
	document.weaver.docstatus.value=1;
	document.weaver.operation.value='editsave';
	document.weaver.submit();
//	alert(text);
//	number=0;
//	startpos=text.indexOf("src=\"");
//	while(startpos!=-1){
//		endpos=text.indexOf("\"",startpos+5);
	//	alert(startpos+'shit'+endpos);
//		curpath = text.substring(startpos+5,endpos);
//		number++;
	//	alert(curpath);
	//	var oDiv = document.createElement("div");
	//	var sHtml = "<input class=inputstyle class=inputstyle type='file' size='25' name='docimages"+number+"' value="+curpath+">";
	//	var sHtml = "<input class=inputstyle class=inputstyle type='file' size='25' name='docimages"+number+"' value='c:\\'>";
	//	oDiv.innerHTML = sHtml;
	//	imgfield.appendChild(oDiv);
//		startpos = text.indexOf("src=\"",endpos);
//	}
	}
}

function onDraft(obj){
	if(check_form(document.weaver,'<%=needinputitems%>')&&checkDateValidity()){
    obj.disabled = true;
	/***###@2007-08-29 modify by yeriwei!
	text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
	text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
	document.weaver.doccontent.innerText=text;
	***/
	CkeditorExt.updateContent();
	
	document.weaver.docstatus.value=0;
	document.weaver.operation.value='editdraft';
	document.weaver.submit();
	}
}

function onPreview(obj){
if(check_form(document.weaver,'<%=needinputitems%>')&&checkDateValidity()){
    obj.disabled = true;
	/***###@2007-08-29-modify by yeriwei!
	text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
	text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
	document.weaver.doccontent.value=text;
	***/
	CkeditorExt.updateContent();
	document.weaver.docstatus.value=0;
	document.weaver.operation.value='editpreview';
	document.weaver.submit();
	}
}

function onDelpic(imgid){
	document.weaver.operation.value='delpic';
	document.weaver.delimgid.value=imgid;
	document.weaver.submit();
}

function onHtml(thiswin){
	if(document.weaver.doccontent.style.display==''){
		text = document.weaver.doccontent.value;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML=text;
		document.weaver.doccontent.style.display='none';
		divifrm.style.display='';
	}
	else{
		text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		document.weaver.doccontent.value=text;
		document.weaver.doccontent.style.display='';
		divifrm.style.display='none';
	}
}

function oninfo(){
  if(confirm("<%=SystemEnv.getHtmlLabelName(15782,user.getLanguage())%>")){
    location="HrmContractOperation.jsp?id=<%=id%>";
  }
}

function onDelete(){
	if(confirm("<%=SystemEnv.getHtmlLabelName(17048,user.getLanguage())%>")){
		document.weaver.operation.value="delete";
		document.weaver.submit();
	}
}
var accessorynum = 2 ;
function addannexRow()
{

	var ncol = 2;
	oRow = accessoryTable.insertRow();

	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell();
		oCell.style.height=24;
		switch(j) {
             case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
            case 1:
				oCell.colSpan = 3;
				oCell.className = "field";
				var oDiv = document.createElement("div");
				var sHtml = "<input class=InputStyle  type=file size=70 name='accessory"+accessorynum+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;

		}
	}
	accessorynum = accessorynum*1 +1;
	document.weaver.accessorynum.value = accessorynum ;
}
</script>
<%@include file="/hrm/include.jsp"%>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</body>
