
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/docs/docs/iWebOfficeConf.jsp" %>
<%@ page import="weaver.general.Util" %>
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
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("HrmContractAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
String rightStr = "";
if(HrmUserVarify.checkUserRight("HrmContractAdd:Add", user)){
rightStr="HrmContractAdd:Add";
}
%>
<link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<script language="javascript" src="/js/weaver_wev8.js"></script>

</head>
<%
String id = Util.null2String(request.getParameter("id"));


String temStr = request.getRequestURI();
temStr="/docs/docs/";

String mServerUrl=temStr+mServerName;
String mClientUrl="/docs/docs/"+mClientName;

String urlfrom ="hr";
int secid= 0;
String ishrm = "";
String sql = "select * from HrmContractType where id = "+id;
rs.executeSql(sql);
while(rs.next()){
  secid = Util.getIntValue(rs.getString("saveurl"),0);  
  ishrm = rs.getString("ishirecontract");  
}

/*Modified By 杨国生 2004-10-11 FOR BUG 1192*/
String subid=SecCategoryComInfo.getSubCategoryid(""+secid);
String mainid=SubCategoryComInfo.getMainCategoryid(subid);
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
String  prjid = Util.null2String(request.getParameter("prjid"));
String  crmid=Util.null2String(request.getParameter("crmid"));
String  hrmid=Util.null2String(request.getParameter("hrmid"));
String  showsubmit=Util.null2String(request.getParameter("showsubmit"));
String  topage=Util.null2String(request.getParameter("topage"));
String  tmptopage=URLEncoder.encode(topage);
topage=URLDecoder.decode(tmptopage);
if(!showsubmit.equals("0"))  showsubmit="1"; 

String usertype = user.getLogintype();
int ownerid=user.getUID() ;
String owneridname=ResourceComInfo.getResourcename(ownerid+"");
int docdepartmentid=user.getUserDepartment() ;
String needinputitems = "";
String docmodule=Util.null2String(request.getParameter("templetdocid"));
String contractman = Util.null2String(request.getParameter("contractman"));


String startdate = "";
String enddate = "";
String proenddate = "";


int mouldType=0 ;
// add by liuyu for dsp moulde text

String mouldtext = "" ;
if(!docmodule.equals("")) {
	MouldManager.setId(Util.getIntValue(docmodule));
	MouldManager.getMouldInfoById();
	mouldtext=MouldManager.getMouldText();
	mouldType= MouldManager.getMouldType();
	MouldManager.closeStatement();
}
String docType ="";
//System.out.println("docmould:"+docmodule);
//System.out.println("mouldType:"+mouldType);
try{
	if(mouldType==2){
		docType = ".doc";
	}else if(mouldType==3){
		docType = ".xls";
	}else if(mouldType==4){
		docType = ".wps";
	}else if(mouldType==5){
		docType = ".et";
	}
}catch(Exception e){
	e.printStackTrace();
	docType = ".doc";
}
//If the template file is the type of 'word doc' or 'excel',redirect to the ext page

if(!contractman.equals("")){
	sql = "select startdate,enddate,probationenddate from HrmResource where id = "+contractman;
	rs.executeSql(sql);
	while(rs.next()){
	   startdate = rs.getString("startdate");
	   enddate  = rs.getString("enddate");
	   proenddate = rs.getString("probationenddate");
	}
}

String categoryname="";
String subcategoryid="";
String docmouldid="";
String publishable="";
String replyable="";
String shareable="";
//String docdefseclevel="";
// String docseclevel="";
//int docmaxseclevel=-1;
String cusertype="";
String cuserseclevel="";
String cdepartmentid1="";
String cdepseclevel1="";
String cdepartmentid2="";
String cdepseclevel2="";
String croleid1="";
String crolelevel1="";
String croleid2="";
String crolelevel2="";
String croleid3="";
String crolelevel3="";
String needapprovecheck="";

ArrayList mainids=new ArrayList();
ArrayList subids=new ArrayList();
ArrayList secids=new ArrayList();
char flag=2;
String tempsubcategoryid="";
if(user.getType()==0)
{
    RecordSet.executeProc("DocUserCategory_SMainByUser",""+user.getUID()+flag+user.getType());
    while(RecordSet.next()){
    mainids.add(RecordSet.getString("mainid"));}
    RecordSet.executeProc("DocUserCategory_SSubByUser",""+user.getUID()+flag+user.getType());
    while(RecordSet.next()){
    subids.add(RecordSet.getString("subid"));}

    RecordSet.executeProc("DocUserCategory_SSecByUser",""+user.getUID()+flag+user.getType());
    while(RecordSet.next()){
    secids.add(RecordSet.getString("secid"));}
}else{
    String subid2="";
    RecordSet.executeProc("DocSecCategory_SByCustomerType",""+user.getType()+flag+user.getSeclevel());
    
    while(RecordSet.next()){
        secids.add(RecordSet.getString("id"));
        if(!tempsubcategoryid.equals(RecordSet.getString("subcategoryid"))){
            subids.add(RecordSet.getString("subcategoryid"));
        }
        tempsubcategoryid=RecordSet.getString("subcategoryid");
    }
    for(int m=0;m<subids.size();m++){
        if(m<subids.size()-1)
        subid2 += (String)subids.get(m)+",";
        else 
        subid2 += (String)subids.get(m);
    }

    sql="select distinct(maincategoryid) from DocSubCategory where id in ("+subid2+")  order by maincategoryid";
    RecordSet.executeSql(sql);
    while(RecordSet.next()){
        mainids.add(RecordSet.getString("maincategoryid"));
    }
}

while(SubCategoryComInfo.next()){
  	String curid = SubCategoryComInfo.getSubCategoryid();
  	String curmainid = SubCategoryComInfo.getMainCategoryid();
  	if(!curmainid.equals(mainid)) continue;
  	if(subid.equals("")) {
  		subid = curid;
  		break;
  	}
}
SubCategoryComInfo.setTofirstRow();
    
while(SecCategoryComInfo.next()){
  	String curid = SecCategoryComInfo.getSecCategoryid();
  	String curmainid = SecCategoryComInfo.getSubCategoryid();
  	if(!curmainid.equals(subid)) continue;
    if(secids.indexOf(curid) == -1) continue ;
  	if(secid==0){
  		secid = Util.getIntValue(curid,0);
  		break;
  	}
}
SecCategoryComInfo.setTofirstRow();


if(secid!=0){
	RecordSet.executeProc("Doc_SecCategory_SelectByID",secid+"");
	RecordSet.next();
	 categoryname=Util.toScreenToEdit(RecordSet.getString("categoryname"),user.getLanguage());
	 subcategoryid=Util.null2String(""+RecordSet.getString("subcategoryid"));
	 docmouldid=Util.null2String(""+RecordSet.getString("docmouldid"));
	 publishable=Util.null2String(""+RecordSet.getString("publishable"));
	 replyable=Util.null2String(""+RecordSet.getString("replyable"));
	 shareable=Util.null2String(""+RecordSet.getString("shareable"));
	 cusertype=Util.null2String(""+RecordSet.getString("cusertype"));
	 cusertype = cusertype.trim();
	 cuserseclevel=Util.null2String(""+RecordSet.getString("cuserseclevel"));
	if(cuserseclevel.equals("255")) cuserseclevel="0";
	 cdepartmentid1=Util.null2String(""+RecordSet.getString("cdepartmentid1"));
	 cdepseclevel1=Util.null2String(""+RecordSet.getString("cdepseclevel1"));
	if(cdepseclevel1.equals("255")) cdepseclevel1="0";
	 cdepartmentid2=Util.null2String(""+RecordSet.getString("cdepartmentid2"));
	 cdepseclevel2=Util.null2String(""+RecordSet.getString("cdepseclevel2"));
	if(cdepseclevel2.equals("255")) cdepseclevel2="0";
	 croleid1=Util.null2String(""+RecordSet.getString("croleid1"));
	 crolelevel1=Util.null2String(""+RecordSet.getString("crolelevel1"));
	 croleid2=Util.null2String(""+RecordSet.getString("croleid2"));
	 crolelevel2=Util.null2String(""+RecordSet.getString("crolelevel2"));
	 croleid3=Util.null2String(""+RecordSet.getString("croleid3"));
	 crolelevel3=Util.null2String(""+RecordSet.getString("crolelevel3"));
	 String approvewfid=RecordSet.getString("approveworkflowid");
	 if(approvewfid.equals("")) approvewfid="0";
    if(approvewfid.equals("0")) 
        needapprovecheck="0";
    else
        needapprovecheck="1";
}



String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(614,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<script language="javascript">
function StatusMsg(mString){
  StatusBar.innerText=mString;
}

function WebSaveLocal(){
  try{
    weaver.WebOffice.WebSaveLocal();
    StatusMsg(weaver.WebOffice.Status);
  }catch(e){}
}

function WebOpenLocal(){
  try{
    weaver.WebOffice.WebOpenLocal();
    StatusMsg(weaver.WebOffice.Status);
  }catch(e){
  }
}

function SaveDocument(){
  if (!weaver.WebOffice.WebSave(<%=isNoComment%>)){
     StatusMsg(weaver.WebOffice.Status);
     alert("<%=SystemEnv.getHtmlLabelName(19007,user.getLanguage())%>");
     return false;
  }else{
    StatusMsg(weaver.WebOffice.Status);
    //alert(weaver.WebOffice.WebGetMsgByName("CREATEID"));
    weaver.docId.value=weaver.WebOffice.WebGetMsgByName("CREATEID");
	//alert(weaver.docId.value);
	//weaver.id.value=weaver.WebOffice.WebGetMsgByName("CREATEID");
   // weaver.docType.value=weaver.WebOffice.WebGetMsgByName("DOCTYPE");
    //alert(weaver.id.value);
    //alert(weaver.docType.value);
    return true;
  }
}

function Load(){
  //weaver.WebOffice.WebUrl="<%=mServerUrl%>"
  try{
  weaver.WebOffice.WebUrl="<%=mServerUrl%>";
  weaver.WebOffice.RecordID="-1";
  weaver.WebOffice.Template="<%=docmodule%>";
  weaver.WebOffice.FileName="";
  weaver.WebOffice.FileType="<%=docType%>";
<%if(isIWebOffice2006 == true){%>
//iWebOffice2006 特有内容开始
  weaver.WebOffice.EditType="1,1";
  weaver.WebOffice.ShowToolBar="0";      //ShowToolBar:是否显示工具栏:1显示,0不显示
//iWebOffice2006 特有内容结束
<%}else{%>
  weaver.WebOffice.EditType="1";
<%}%>
  weaver.WebOffice.UserName="<%=user.getUsername()%>";
  weaver.WebOffice.WebOpen();  	//打开该文档
<%if(isIWebOffice2006 == true){%>
//iWebOffice2006 特有内容开始
  weaver.WebOffice.ShowType="1";  //文档显示方式  1:表示文字批注  2:表示手写批注  0:表示文档核稿
//iWebOffice2006 特有内容结束
<%}%>
  StatusMsg(weaver.WebOffice.Status);
  var onlstr = new clsDateTime();
  }catch(e){}
}



function UnLoad(){
  try{
  if (!weaver.WebOffice.WebClose()){
     StatusMsg(weaver.WebOffice.Status);
  }else{
      StatusMsg("<%=SystemEnv.getHtmlLabelName(83475,user.getLanguage())%>");
  }
  }catch(e){}
}

function protectDoc(){
    event.returnValue="<%=SystemEnv.getHtmlLabelName(19006,user.getLanguage())%>";
}
</script>
<body  id="mybody" onLoad="Load()" onUnload="UnLoad()" onbeforeunload="protectDoc()">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(showsubmit.equals("1")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
//RCMenu += "{"+SystemEnv.getHtmlLabelName(220,user.getLanguage())+",javascript:onDraft(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(221,user.getLanguage())+",javascript:onPreview(),_self} " ;

//RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(222,user.getLanguage())+",javascript:onHtml(),_self} " ;

//RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(224,user.getLanguage())+",javascript:showHeader(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<table class=Shadow>
<tr>
<td valign="top">

<form id=weaver name=weaver action="/docs/docs/UploadDoc.jsp" method=post enctype="multipart/form-data">
    <input class=inputstyle type=hidden name=docapprovable value="<%=needapprovecheck%>">
    <input class=inputstyle type=hidden name=docreplyable value="<%=replyable%>">
    <input class=inputstyle type=hidden name=docstatus value="0">
    <input class=inputstyle type=hidden name=usertype value="<%=usertype%>">
    <input class=inputstyle type=hidden name=topage value="<%=topage%>">
    <input class=inputstyle type=hidden name=doclangurage value=<%=user.getLanguage()%>>
    <input class=inputstyle type=hidden name=maincategory value=<%=mainid%>>
    <input class=inputstyle type=hidden name=subcategory value=<%=subid%>>
    <input class=inputstyle type=hidden name=seccategory value=<%=secid%>>
    <input class=inputstyle type=hidden name=docmodule value=<%=docmodule%>>
    <%if(user.getType()==0){%>	
    <input class=inputstyle type=hidden name="ownerid" value="<%=ownerid%>">
    <input class=inputstyle type=hidden name="docdepartmentid" value="<%=docdepartmentid%>">		
    <%}else{%>	
    <input class=inputstyle type=hidden name="ownerid" value=<%=ownerid%>>
    <input class=inputstyle type=hidden name="docdepartmentid" value="<%=docdepartmentid%>">	
    <%}%>
    <input class=inputstyle type=hidden name=typeid value=<%=id%>>
    <input class=inputstyle type=hidden name=id value=<%=id%>>
    <input class=inputstyle type=hidden name=templetdocid value="<%=docmodule%>">
    <input class=inputstyle type=hidden name=urlfrom value=hr>
    
    <%
    if(!publishable.trim().equals("") && !publishable.trim().equals("0")){
    %>
    <table class=form>
    <tbody>
    <tr>
    <td width=15%><b><%=SystemEnv.getHtmlLabelName(114,user.getLanguage())%></b></td>
    <td width=40%>
    <input class=inputstyle type=radio name="docpublishtype" value=1 checked><font color=red><%=SystemEnv.getHtmlLabelName(1984,user.getLanguage())%></font>
    <input class=inputstyle type=radio name="docpublishtype" value=2><font color=red><%=SystemEnv.getHtmlLabelName(227,user.getLanguage())%></font>
    <input class=inputstyle type=radio name="docpublishtype" value=3><font color=red><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></font>
    </td>
    </tr>
    </tbody>
    </table>
    <%}%>
  <table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
		<%if(showsubmit.equals("1")){%>
        <input type=button class="e8_btn_top" onclick="onSave(this);" value="<%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%>"></input>
		<%}%>
		<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
   </table>   

<div id=oDiv style="display:''">
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(15776,user.getLanguage())%></wea:item>
		<wea:item>
		<%
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
			<brow:browser viewType="0" name="contractman" browserValue="" 
							browserUrl="<%=browserUrl%>"
							hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
							completeUrl="<%=dataUrl%>" linkUrl="javascript:openhrm($id$)" width="165px"
							browserSpanValue='<%=ResourceComInfo.getResourcename(contractman)%>'></brow:browser>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15777,user.getLanguage())%></wea:item>
		<wea:item> 
	        <button type=button  class=Calendar id=selectcontractstartdate onClick="getDate(contractstartdatespan,contractstartdate)"></button> 
	        <span id=contractstartdatespan ><%=startdate%></span> -&nbsp;
	        <button type=button  class=Calendar id=selectcontractenddate onClick="getDate(contractenddatespan,contractenddate)"></button> 
	        <span id=contractenddatespan ><%=enddate%></span> 
	        <input class=inputstyle type="hidden" name="contractstartdate" value="<%=startdate%>">
	        <input class=inputstyle type="hidden" name="contractenddate" value="<%=enddate%>">
      	</wea:item>
		<%
      if(ishrm.equals("1")){
      %> 
         <wea:item><%=SystemEnv.getHtmlLabelName(15778,user.getLanguage())%></wea:item>
		<wea:item> 
	     <button class=Calendar type="button" id=selectproenddate onClick="getDate(proenddatespan,proenddate)"></button> 
          <span id=proenddatespan ><%=proenddate%></span>       
          <input class=inputstyle type="hidden" name="proenddate" value="<%=proenddate%>">      
      	</wea:item>
	  <%
      }
    %> 
	</wea:group>
</wea:layout>
   
</div>

    <%
    String Id=""+secid;
    RecordSet.executeProc("Doc_SecCategory_SelectByID",Id);
    if(RecordSet.next());
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
    %>
<!-- div id=noDiv style="display:none">
    <table class=form>
    <tbody><%if(accessorynum!=0||!hasasset.equals("0")||!hasitems.equals("0")||!hashrmres.equals("0")||!hascrm.equals("0")||!hasproject.equals("0")||!hasfinance.equals("0")){%>
    <tr class=separator><td class=Sep1 colspan=4></td></tr><%}%>
    <tr>
    <%
    int needtr=0;
    if(!hashrmres.trim().equals("")&&!hashrmres.trim().equals("0")){
    	String curlabel = SystemEnv.getHtmlLabelName(179,user.getLanguage());
    	if(!hrmreslabel.trim().equals("")) curlabel = hrmreslabel;
    %>
    <td width=20%><%=curlabel%></td>
    <td width=30% class=field>
      <button class=Browser onClick="onShowHrmresID(<%=hashrmres%>)"></button>
      <span id=hrmresspan>
    	  <%if(hrmid.equals("")){%>
      <%if(hashrmres.equals("2")){
      	needinputitems += ",hrmresid";
      %>
      <img src='/images/BacoError_wev8.gif' align=absMiddle>
      <%}%>
    	  <%}else{%>
    	<%=ResourceComInfo.getResourcename(hrmid)%>
    	  <%}%>
      </span> 
        <input class=inputstyle type=hidden name=hrmresid value=<%=hrmid%>>
    </td>
    	  <%
    if(needtr==1){ out.print("</tr><tr>");needtr=0;}
    else needtr++;
    }else{%>
        <input class=inputstyle type=hidden name=hrmresid value=<%=hrmid%>>
    <%}%>
    <%
    if(!hasasset.trim().equals("")&&!hasasset.trim().equals("0")){
    	String curlabel = SystemEnv.getHtmlLabelName(535,user.getLanguage());
    	if(!assetlabel.trim().equals("")) curlabel = assetlabel;
    %>
    <td width=20%><%=curlabel%></td>
    <td width=30% class=field>
      <button class=Browser onClick="onShowAssetId(<%=hasasset%>)"></button>
      <span id=assetidspan>
      <%if(hasasset.equals("2")){
      	needinputitems += ",assetid";
      %>
      <img src='/images/BacoError_wev8.gif' align=absMiddle>
      <%}%>
      </span> 
      <input class=inputstyle type=hidden name=assetid>
    </td>
    <%
    if(needtr==1){ out.print("</tr><tr>");needtr=0;}
    else needtr++;
    }%>
    <%
    if(!hascrm.trim().equals("")&&!hascrm.trim().equals("0")){
    	String curlabel = SystemEnv.getHtmlLabelName(147,user.getLanguage());
    	if(!crmlabel.trim().equals("")) curlabel = crmlabel;
    %>
    <td width=20%><%=curlabel%></td>
    <td width=30% class=field>
      <button class=Browser onClick="onShowCrmID(<%=hascrm%>)"></button>
      <span id=crmidspan>
    	  <%if(crmid.equals("")){%>
      <%if(hascrm.equals("2")){
      	needinputitems += ",crmid";
      %>
      <img src='/images/BacoError_wev8.gif' align=absMiddle>
      <%}%>
    	  <%}else{%>
    	<%=CustomerInfoComInfo.getCustomerInfoname(crmid)%>
    	  <%}%>
      </span> 
      <input class=inputstyle type=hidden name=crmid value=<%=crmid%>>
    </td>
    <%
    if(needtr==1){ out.print("</tr><tr>");needtr=0;}
    else needtr++;
    }else{%>
      <input class=inputstyle type=hidden name=crmid value=<%=crmid%>>
    <%}%>
    <%
    if(!hasitems.trim().equals("")&&!hasitems.trim().equals("0")){
    	String curlabel = SystemEnv.getHtmlLabelName(145,user.getLanguage());
    	if(!itemlabel.trim().equals("")) curlabel = itemlabel;
    %>
    <td width=20%><%=curlabel%></td>
    <td width=30% class=field>
      <button class=Browser onClick="onShowItemID(<%=hasitems%>)"></button>
      <span id=itemspan>
      <%if(hasitems.equals("2")){
      	needinputitems += ",itemid";
      %>
      <img src='/images/BacoError_wev8.gif' align=absMiddle>
      <%}%>
      </span> 
        <input class=inputstyle type=hidden name=itemid>
    </td>
    <%
    if(needtr==1){ out.print("</tr><tr>");needtr=0;}
    else needtr++;
    }%>
    
    <%
    if(!hasproject.trim().equals("")&&!hasproject.trim().equals("0")){
    	String curlabel = SystemEnv.getHtmlLabelName(101,user.getLanguage());
    	if(!projectlabel.trim().equals("")) curlabel = projectlabel;
    %>
    <td width=20%><%=curlabel%></td>
    <td width=30% class=field>
       <button class=Browser onClick="onShowProjectID(<%=hasproject%>)"></button>
      <span id=projectidspan>
    	  <%if(prjid.equals("")){%>
      <%if(hasproject.equals("2")){
      	needinputitems += ",projectid";
      %>
    
      <img src='/images/BacoError_wev8.gif' align=absMiddle>
    
      <%}%>
    	  <%}else{%>
    	<%=ProjectInfoComInfo.getProjectInfoname(prjid)%>
    	  <%}%>
      </span> 
        <input class=inputstyle type=hidden name=projectid value=<%=prjid%>>
    </td>
    <%
    if(needtr==1){ out.print("</tr><tr>");needtr=0;}
    else needtr++;
    }else{%>
        <input class=inputstyle type=hidden name=projectid value=<%=prjid%>>
    <%}%>
    <%
    if(!hasfinance.trim().equals("")&&!hasfinance.trim().equals("0")){
    	String curlabel = SystemEnv.getHtmlLabelName(189,user.getLanguage());
    	if(!financelabel.trim().equals("")) curlabel = financelabel;
    %>
    <td width=20%><%=curlabel%></td>
    <td width=30% class=field>
      <button class=Browser></button>
        <input class=inputstyle type=hidden name=financeid>
    </td>
    <%
    if(needtr==1){ out.print("</tr><tr>");needtr=0;}
    else needtr++;
    }%>
    </tbody>
    </table>
</div-->
    
    <table class=viewform id="accessoryTable">
    <tbody>
  

   
    </tbody>
    </table>
	 <input class=inputstyle type=hidden name=accessorynum value="1">
    
    <script language=javascript>
    function showHeader(){    
    	if(oDiv.style.display=='')
    	    
    		oDiv.style.display='none';
    	else
    		oDiv.style.display='';
    }
    </script>
    <table class=viewform>
    <tbody>
    <tr class=spacing><td class=line1 colspan=2></td></tr>
    <tr>
    <td width=20%><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></td>
    <td width=80% class=field>
    <input class=inputstyle  size=70 name="docsubject" onChange="checkinput('docsubject','docsubjectspan')" >
    <span id="docsubjectspan">
    <img src="/images/BacoError_wev8.gif" align=absMiddle>
    </span>
    <%
    needinputitems += ",docsubject";
    %>
    </td>
    </tr>
    <tr><td class=Line colSpan=2></td></tr>
    <tr id=otrtmp style="display:none">
    <td width=20%><%=SystemEnv.getHtmlLabelName(341,user.getLanguage())%></td>
    <td width=80% class=field>
    <input class=inputstyle  size=70 name="docmain" onChange="checkinput('docmain','docmainspan')" >
    <span id="docmainspan">
    <img src="/images/BacoError_wev8.gif" align=absMiddle>
    </span>
    <%
    //needinputitems += ",docmain";
    %>
    </td>
    </tr>
    
    </tbody>
    </table>
<div id=imgfield>
</div>
    <table class=viewform>
    <colgroup>
      <col width="20%">
      <col width=80%>
      
    <tbody>
    <tr class=spacing>
    <td class=line1 colspan=2></td></tr>

    <%
    int pos = mouldtext.indexOf("<img alt=\"");
    while(pos!=-1){
    	pos = mouldtext.indexOf("?fileid=",pos);
    	int endpos = mouldtext.indexOf("\"",pos);
    	String tmpid = mouldtext.substring(pos+8,endpos);
    	int startpos = mouldtext.lastIndexOf("\"",pos);
    	String servername = request.getServerName();
    	String tmpcontent = mouldtext.substring(0,startpos+1);
    	tmpcontent += "http://"+servername;
    	tmpcontent += mouldtext.substring(startpos+1);
    	mouldtext=tmpcontent;
    %>
    <input class=inputstyle type=hidden name=moduleimages value="<%=tmpid%>">
    <%
    	pos = mouldtext.indexOf("<img alt=\"",endpos);
    }
    %>

<tr>
	<td class=Line colSpan=2></td>
</tr>
<tr><td colspan=2>
<textarea name=mouldtext style="display:none;width:100%;height:500px"></textarea>
<!--###@2007-08-29 modify by yeriwei!
<div id=divifrm style="display:;">
<iframe src="/docs/docs/dhtml.jsp" frameborder=0 style="width:100%;height=500px;display:none" id="dhtmlFrm"></iframe>
</div>
---->
</td></tr>

<tr><td colspan="2">
	<div  id="worddiv" style="POSITION: relative;width:100%;height:660;OVERFLOW:hidden;">
    <object  id="WebOffice" style="POSITION: relative;top:-20" width="100%"  height="680"  value="" classid="<%=mClassId%>" codebase="<%=mClientUrl%>" >
    </object>
</div>
</td></tr> 

<tr><td colspan="2">
<span id=StatusBar></span>
</td></tr>
</TBODY>
</table>
<input type=hidden name=operation>
<input type=hidden name=urlfrom value="<%=urlfrom%>">
<input TYPE="hidden" id="docId" NAME="docId" value="">
<input TYPE="hidden" id="docType" NAME="docType" value="<%=docType%>">

</form>

		</td>
		</tr>
		</table>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
<script language=vbs>
sub onShowResource11()
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
			mybody.onbeforeunload=null
			weaver.action="HrmContractAddExt.jsp?id=<%=id%>&templetdocid=<%=docmodule%>&contractman="&id(0)
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
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script>
<%--Add by Charoes Huang ON May 21,2004--%>
function onShowResource(){
	var url = "";
	if(<%=detachable%> != 1){
		url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
	}else{
		url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowserByRight.jsp?rightStr=<%=rightStr%>";
	}
	return url; 
}
function checkDateValidity(){
    var isValid = false;
    isValid = checkDateRange(weaver.contractstartdate,weaver.contractenddate,"<%=SystemEnv.getHtmlLabelName(16721,user.getLanguage())%>")<%if(ishrm.equals("1")){%>&&checkDateBetween(weaver.contractstartdate.value,weaver.proenddate.value,weaver.contractenddate.value,"<%=SystemEnv.getHtmlLabelName(17411,user.getLanguage())%>")<%}%>;
    return isValid;
}
function onSave(){
  document.getElementById("worddiv").style.display="none";

  if(document.weaver.contractman.value==""){
     window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15779,user.getLanguage())%>",function(){
	             document.getElementById("worddiv").style.display="";
       });
  }else{
	if(checkform_c(document.weaver,'<%=needinputitems%>')&&checkDateValidity()){
		/**
		text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		**/
		document.weaver.docstatus.value=1;
		document.weaver.operation.value='addsave';
		
	
		 if(SaveDocument()){
            mybody.onbeforeunload=null;
            document.weaver.submit();
        }
	//	alert(text);
		
	}
  }
}

function onDraft(){
  if(document.weaver.contractman.value==""){
    alert("<%=SystemEnv.getHtmlLabelName(15779,user.getLanguage())%>");
  }else{
	if(check_form(document.weaver,'<%=needinputitems%>')&&checkDateValidity()){
		/**
		text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		***/
		document.weaver.docstatus.value=0;
		document.weaver.operation.value='adddraft';

		 if(SaveDocument()){
            mybody.onbeforeunload=null;
            document.weaver.submit();
        }
	}
  }	
}

function onPreview(){
if(document.weaver.contractman.value==""){
    alert("<%=SystemEnv.getHtmlLabelName(15779,user.getLanguage())%>");
  }else{
if(check_form(document.weaver,'<%=needinputitems%>')&&checkDateValidity()){
	/***
	text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
	text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
	****/
	
	document.weaver.docstatus.value=0;
	document.weaver.operation.value='addpreview';
	
		 if(SaveDocument()){
            mybody.onbeforeunload=null;
            document.weaver.submit();
        }
}
}
}

accessorynum = 2 ;
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
				var sHtml = "<%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%>"+accessorynum;
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
            case 1:
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
function checkform_c(thiswins,items)
{
	

	thiswin = thiswins
	items = ","+items + ",";
	
	var tempfieldvlaue1 = "";
	try{
		tempfieldvlaue1 = document.getElementById("htmlfieldids").value;
	}catch (e) {
	}

	for(i=1;i<=thiswin.length;i++){
		tmpname = thiswin.elements[i-1].name;
		tmpvalue = thiswin.elements[i-1].value;
	    if(tmpvalue==null){
	        continue;
	    }

		if(tmpname!="" && items.indexOf(","+tmpname+",")!=-1){
			var href = location.href;
			if(href && href.indexOf("Ext.jsp")!=-1){
				window.__oriAlert__ = true;
			}
			if(tempfieldvlaue1.indexOf(tmpname+";") == -1){
				while(tmpvalue.indexOf(" ") >= 0){
					tmpvalue = tmpvalue.replace(" ", "");
				}
				while(tmpvalue.indexOf("\r\n") >= 0){
					tmpvalue = tmpvalue.replace("\r\n", "");
				}

				if(tmpvalue == ""){
					if(thiswin.elements[i-1].getAttribute("temptitle")!=null && thiswin.elements[i-1].getAttribute("temptitle")!=""){
						if(window.__oriAlert__){
							window.top.Dialog.alert("\""+thiswin.elements[i-1].getAttribute("temptitle")+"\""+"<%=SystemEnv.getHtmlLabelName(21423, user.getLanguage())%>");
						}else{
							var tempElement = thiswin.elements[i-1];
							//ueditor必填验证
							if (checkueditorContent(tempElement)) {
								continue;
							}
							
							window.top.Dialog.alert("&quot;"+thiswin.elements[i-1].getAttribute("temptitle")+"&quot;"+"<%=SystemEnv.getHtmlLabelName(21423, user.getLanguage())%>", function () {
						    formElementFocus(tempElement);						
							});
						}
						return false;
					}else{
						if(window.__oriAlert__){
								window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>",function(){
	                            document.getElementById("worddiv").style.display="";
                            });
						}else{
								window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>",function(){
	                            document.getElementById("worddiv").style.display="";
                            });
						}
						return false;
					}
				}
			} else {
				var divttt=document.createElement("div");
				divttt.innerHTML = tmpvalue;
				var tmpvaluettt = jQuery.trim(jQuery(divttt).text());
				if(tmpvaluettt == ""){
					if(thiswin.elements[i-1].getAttribute("temptitle")!=null && thiswin.elements[i-1].getAttribute("temptitle")!=""){
						if(window.__oriAlert__){
							window.top.Dialog.alert("\";"+thiswin.elements[i-1].getAttribute("temptitle")+"\""+"<%=SystemEnv.getHtmlLabelName(21423, user.getLanguage())%>");
						}else{
							var tempElement = thiswin.elements[i-1];
							
							//ueditor必填验证
							if (checkueditorContent(tempElement)) {
								continue;
							}
							
							window.top.Dialog.alert("&quot;"+thiswin.elements[i-1].getAttribute("temptitle")+"&quot;"+"<%=SystemEnv.getHtmlLabelName(21423, user.getLanguage())%>", function () {
								formElementFocus(tempElement);
							});
							
						}
						return false;
					}else{
						if(window.__oriAlert__){
							  window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>",function(){
	                          document.getElementById("worddiv").style.display="";
                            });
						}else{
								 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>",function(){
	                             document.getElementById("worddiv").style.display="";
                            });
						}
						return false;
					}
				}
			}
		}
	}
	return true;
}
</script>
<%@include file="/hrm/include.jsp"%>
</body>
