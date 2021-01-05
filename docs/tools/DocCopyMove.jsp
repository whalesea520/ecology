
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.docs.category.CategoryUtil" %>
<%@ page import="weaver.docs.category.security.MultiAclManager" %>
<%@ page import="weaver.general.PageIdConst" %>
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SecCategoryCustomSearchComInfo" class="weaver.docs.category.SecCategoryCustomSearchComInfo" scope="page" />
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ page import="weaver.docs.docs.CustomFieldManager"%>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
String hasTab = Util.null2String(request.getParameter("hasTab"));
if(hasTab.equals("")){
	response.sendRedirect("/docs/search/DocSearchTab.jsp?_fromURL=3&"+request.getQueryString());
	return;
}
boolean isoracle = RecordSet.getDBType().equals("oracle");
boolean CanCopy = HrmUserVarify.checkUserRight("DocCopyMove:Copy", user);
boolean CanMove = HrmUserVarify.checkUserRight("DocCopyMove:Move", user);
int srcsecid = Util.getIntValue(request.getParameter("srcsecid"), -1);
int srcsubid = Util.getIntValue(SecCategoryComInfo.getSubCategoryid(""+srcsecid), -1);
int srcmainid = Util.getIntValue(SubCategoryComInfo.getMainCategoryid(""+srcsubid), -1);

int objsecid = Util.getIntValue(request.getParameter("objsecid"), -1);
int objsubid = Util.getIntValue(SecCategoryComInfo.getSubCategoryid(""+objsecid), -1);
int objmainid = Util.getIntValue(SubCategoryComInfo.getMainCategoryid(""+objsubid), -1);

String otype=Util.null2String(request.getParameter("otype"));//操作类型 1复制、2移动

if(otype.equals(""))otype="1";

int operationcode = MultiAclManager.OPERATION_COPYDOC;
if(CanCopy){
	operationcode = -1;
}
if(otype.equals("2")){
	operationcode = MultiAclManager.OPERATION_MOVEDOC;
	if(CanMove){
		operationcode = -1;
	}
}


String currentStep = Util.null2String(request.getParameter("currentStep"));
if(currentStep.equals(""))currentStep = "0";

boolean firstStep = currentStep.equals("0");

String srcpath = "";
String objpath = "";

MultiAclManager am = new MultiAclManager();
if(am.hasPermission(srcsecid, MultiAclManager.CATEGORYTYPE_SEC, user, MultiAclManager.OPERATION_COPYDOC)&&am.hasPermission(objsecid, MultiAclManager.CATEGORYTYPE_SEC, user, MultiAclManager.OPERATION_COPYDOC)){
    CanCopy = true;
}

if(am.hasPermission(srcsecid, MultiAclManager.CATEGORYTYPE_SEC, user, MultiAclManager.OPERATION_MOVEDOC)&&am.hasPermission(objsecid, MultiAclManager.CATEGORYTYPE_SEC, user, MultiAclManager.OPERATION_MOVEDOC)){
    CanMove = true;
}


if (srcsecid != -1) {
    srcpath = SecCategoryComInfo.getAllParentName(""+srcsecid,true);
}
if (objsecid != -1) {
    objpath = SecCategoryComInfo.getAllParentName(""+objsecid,true);
}

if (srcsecid == -1 || objsecid == -1 || srcsecid == objsecid) {
    CanMove = false;
    CanCopy = false;
}
//System.out.println("CanMove: "+CanMove+" CanCopy:"+CanCopy+"::"+otype);
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<script type='text/javascript' src='/dwr/interface/DocDwrUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<script language=javascript src="/js/ecology8/docs/docSearchExt_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<style type="text/css">
	#SrcBrowseTable .field,#ObjBrowseTable .field{
		background-color:#fff!important;
	}
	
	#SrcBrowseTable,#ObjBrowseTable{
		width:89%;
		margin:0 auto;
		border:1px solid #F3F2F2;
	}
</style>
<script type="text/javascript">

function nextStep(){
	//jQuery("#frmmain").submit();
	var srcid = jQuery("#srcsecid").val();
	var objid = jQuery("#objsecid").val();
	if(!srcid||!objid){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(33252,user.getLanguage())%>");
		return;
	}
	if(srcid==objid){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(33253,user.getLanguage())%>");
		return;
	}
	jQuery("#currentStep").val("1");
	jQuery("#setting").hide();
	jQuery("#resultList").show();
	jQuery("#nextStep",parent.document).hide();
	jQuery("#topTitleBtn",parent.document).show();
	jQuery("#firstBtn",parent.document).hover(function(){
		jQuery(this).addClass("e8_btn_top_first_hover");
	},function(){
		jQuery(this).removeClass("e8_btn_top_first_hover");
	});
	hiddenRCMenuItem(0);
	showRCMenuItem(1);
	showRCMenuItem(2);
	showRCMenuItem(3);
}

function preStep(){
	jQuery("#currentStep").val("0");
	jQuery("#setting").show();
	jQuery("#resultList").hide();
	jQuery("#nextStep",parent.document).show();
	jQuery("#topTitleBtn",parent.document).hide();
	hiddenRCMenuItem(1);
	hiddenRCMenuItem(2);
	hiddenRCMenuItem(3);
	showRCMenuItem(0);
}

function onLog(){
	var dialog = new window.top.Dialog();
	dialog.URL = '/docs/DocCopyMoveLog.jsp?sqlwhere=<%=xssUtil.put("where operatetype=11 or operatetype=12")%>';
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>";
	dialog.Width = jQuery(document).width();
	dialog.Height = jQuery(document).height();
	dialog.maxiumnable = true;
	dialog.checkDataChange = false;
	dialog.show();
	
}

</script>
<style type="text/css">
TABLE.ListStyle TR.Selected {
	BACKGROUND-COLOR: #E5E5E5 ; HEIGHT: 22px ; BORDER-Spacing:1pt
}
</style>


</HEAD>
<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(77,user.getLanguage())+"、"+SystemEnv.getHtmlLabelName(78,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(58,user.getLanguage());
    String needfav ="1";
    String needhelp ="";
%>
<BODY> 
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1402,user.getLanguage())+",javascript:nextStep(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
    if(CanCopy&&otype.equals("1")){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onBtnSearchClickRight(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
        RCMenu += "{"+SystemEnv.getHtmlLabelName(77,user.getLanguage())+",javascript:onCopy(this),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
		 RCMenu += "{"+SystemEnv.getHtmlLabelName(33247,user.getLanguage())+",javascript:onCopyShare(this),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
    }
    if(CanMove&&otype.equals("2")){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onBtnSearchClickRight(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(78,user.getLanguage())+",javascript:onMove(),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
        RCMenu += "{"+SystemEnv.getHtmlLabelName(33246,user.getLanguage())+",javascript:onMoveShare(),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
		
    }
    RCMenu += "{"+SystemEnv.getHtmlLabelNames("1290,1876",user.getLanguage())+",javascript:preStep(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
    if(HrmUserVarify.checkUserRight("DocCopyMove:Log", user)){
       	RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog(),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
    }
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td >
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(firstStep){ %>
				<input id="nextStep" type="button" onclick="nextStep();" name="nextStep" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(1402,user.getLanguage())%>"/>
			<%}%>
				<span id="topTitleBtn" style="display:<%=firstStep?"none":"" %>"> 
				<%if(CanMove && otype.equals("2")){ %>
					<input id="firstBtn" type="button" onclick="onMove();" name="move" class="e8_btn_top middle e8_btn_top_first" value="<%=SystemEnv.getHtmlLabelName(78,user.getLanguage())%>"/>
					<input type="button" onclick="onMoveShare();" name="move" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(33246,user.getLanguage())%>"/>
					<input type="button" onclick="preStep();" name="move" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelNames("1290,1876",user.getLanguage())%>"/>
					<input type="text" id="flowTitle" class="searchInput" name="flowTitle" value="" onchange="setKeyword('flowTitle','docsubject','frmmain');"/>
					<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
				<%}else if(CanCopy && otype.equals("1")){ %>
					<input id="firstBtn" type="button" onclick="onCopy(this);" name="move" class="e8_btn_topmiddle e8_btn_top_first" value="<%=SystemEnv.getHtmlLabelName(77,user.getLanguage())%>"/>
					<input type="button" onclick="onCopyShare(this);" name="move" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(33247,user.getLanguage())%>"/>
					<input type="button" onclick="preStep();" name="move" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelNames("1290,1876",user.getLanguage())%>"/>
					<input type="text" id="flowTitle" class="searchInput" name="flowTitle" value="" onchange="setKeyword('flowTitle','docsubject','frmmain');"/>
					<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
				<%} %>
				</span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>



        <FORM id=frmmain name=frmmain action="DocCopyMoveOperation.jsp" method=post >
            <input type="hidden" name="operation">
            <input type="hidden" name="docStrs">
            <input type="hidden" name="currentStep" id="currentStep" value="<%=currentStep %>">
            <input type="hidden" name="ifrepeatedname" value="yes">
            <input type="hidden" name="otype" id="otype" value="<%=otype %>">
			<input name="hasTab" id="hasTab" type=hidden value="1">
		<%
		int numperpage = Util.getIntValue(request.getParameter("numperpage"), -1);
		if(numperpage==-1){
			UserDefaultManager.setUserid(user.getUID());
			UserDefaultManager.selectUserDefault();
			numperpage = UserDefaultManager.getNumperpage();
		}
		if(numperpage <2) numperpage=10;

	  if(CanMove || CanCopy){
		//处理自定义条件 begin

		String docsubject = Util.null2String(request.getParameter("docsubject")) ;
		String ownerid=Util.null2String(request.getParameter("ownerid"));
		if(ownerid.equals("0")) ownerid="";
		String departmentid=Util.null2String(request.getParameter("departmentid"));
		if(departmentid.equals("0")) departmentid="";

		DocSearchComInfo.resetSearchInfo();
		DocSearchComInfo.setSeccategory(""+srcsecid);
		DocSearchComInfo.setDocsubject(docsubject);
		DocSearchComInfo.setOwnerid(ownerid);
		DocSearchComInfo.setDocdepartmentid(departmentid);

		String whereKeyStr="docsubject="+docsubject;
		whereKeyStr+="^,^ownerid="+ownerid;
		whereKeyStr+="^,^departmentid="+departmentid;

		String[] checkcons = request.getParameterValues("check_con");
		String sqlwhere = "";
		String sqlrightwhere = "";
		String temOwner = "";

		if(checkcons!=null){
			for(int i=0;i<checkcons.length;i++){
				String tmpid = ""+checkcons[i];
				String tmpcolname = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_colname"));
				String tmphtmltype = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_htmltype"));
				String tmptype = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_type"));
				String tmpopt = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_opt"));
				String tmpvalue = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_value"));
				String tmpname = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_name"));
				String tmpopt1 = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_opt1"));
				String tmpvalue1 = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_value1"));

				whereKeyStr+="^,^tmpid="+tmpid;
				whereKeyStr+="~@~tmpcolname="+tmpcolname;
				whereKeyStr+="~@~tmphtmltype="+tmphtmltype;
				whereKeyStr+="~@~tmptype="+tmptype;
				whereKeyStr+="~@~tmpopt="+tmpopt;
				whereKeyStr+="~@~tmpvalue="+tmpvalue;
				whereKeyStr+="~@~tmpname="+tmpname;
				whereKeyStr+="~@~tmpopt1="+tmpopt1;
				whereKeyStr+="~@~tmpvalue1="+tmpvalue1;

				//生成where子句

				temOwner = "tCustom";
				boolean haveLeftBracket=false;
				if((tmphtmltype.equals("1")&& tmptype.equals("1"))||tmphtmltype.equals("2")){
					sqlwhere += "and ("+temOwner+"."+tmpcolname;
					haveLeftBracket=true;
					if(tmpopt.equals("1"))	sqlwhere+=" ='"+tmpvalue +"' ";
					if(tmpopt.equals("2"))	sqlwhere+=" <>'"+tmpvalue +"' ";
					if(tmpopt.equals("3"))	sqlwhere+=" like '%"+tmpvalue +"%' ";
					if(tmpopt.equals("4"))	sqlwhere+=" not like '%"+tmpvalue +"%' ";
				}else if(tmphtmltype.equals("1")&& !tmptype.equals("1")){
					//sqlwhere += "and ("+temOwner+"."+tmpcolname;
					if(!tmpvalue.equals("")){
						sqlwhere += "and ("+temOwner+"."+tmpcolname;
						haveLeftBracket=true;
						if(tmpopt.equals("1"))	sqlwhere+=" >"+tmpvalue +" ";
						if(tmpopt.equals("2"))	sqlwhere+=" >="+tmpvalue +" ";
						if(tmpopt.equals("3"))	sqlwhere+=" <"+tmpvalue +" ";
						if(tmpopt.equals("4"))	sqlwhere+=" <="+tmpvalue +" ";
						if(tmpopt.equals("5"))	sqlwhere+=" ="+tmpvalue +" ";
						if(tmpopt.equals("6"))	sqlwhere+=" <>"+tmpvalue +" ";

					}
					if(!tmpvalue1.equals("")){
						if(!haveLeftBracket){
							sqlwhere += " and ("+temOwner+"."+tmpcolname;
							haveLeftBracket=true;
						}else{
							sqlwhere += " and "+temOwner+"."+tmpcolname;
						}

						if(tmpopt1.equals("1"))	sqlwhere+=" >"+tmpvalue1 +" ";
						if(tmpopt1.equals("2"))	sqlwhere+=" >="+tmpvalue1 +" ";
						if(tmpopt1.equals("3"))	sqlwhere+=" <"+tmpvalue1 +" ";
						if(tmpopt1.equals("4"))	sqlwhere+=" <="+tmpvalue1 +" ";
						if(tmpopt1.equals("5"))	sqlwhere+=" ="+tmpvalue1+" ";
						if(tmpopt1.equals("6"))	sqlwhere+=" <>"+tmpvalue1 +" ";
					}
				}
				else if(tmphtmltype.equals("4")){
					sqlwhere += "and ("+temOwner+"."+tmpcolname;
					haveLeftBracket=true;
					if(!tmpvalue.equals("1")) sqlwhere+="<>'1' ";
					else sqlwhere +="='1' ";
				}
				else if(tmphtmltype.equals("5")){
					sqlwhere += "and ("+temOwner+"."+tmpcolname;
					haveLeftBracket=true;
					if(tmpopt.equals("1"))	sqlwhere+=" ="+tmpvalue +" ";
					if(tmpopt.equals("2"))	sqlwhere+=" <>"+tmpvalue +" ";
				}
				else if(tmphtmltype.equals("3") && !tmptype.equals("2") && !tmptype.equals("18") && !tmptype.equals("19")&& !tmptype.equals("17") && !tmptype.equals("37")&& !tmptype.equals("65") && !tmptype.equals("162") ){
					if(!tmpvalue.equals("")){
						sqlwhere += "and ("+temOwner+"."+tmpcolname;
						haveLeftBracket=true;
						if(tmpopt.equals("1")){
							sqlwhere+=" ="+tmpvalue +" ";
						}
						if(tmpopt.equals("2")){	
							sqlwhere+=" <>"+tmpvalue +" ";
						}
					}
				}
				else if(tmphtmltype.equals("3") && (tmptype.equals("2")||tmptype.equals("19"))){ // 对日期处理
					//sqlwhere += "and ("+temOwner+"."+tmpcolname;
					if(!tmpvalue.equals("")){
						sqlwhere += " and ("+temOwner+"."+tmpcolname;
						haveLeftBracket=true;
						if(tmpopt.equals("1"))	sqlwhere+=" >'"+tmpvalue +"' ";
						if(tmpopt.equals("2"))	sqlwhere+=" >='"+tmpvalue +"' ";
						if(tmpopt.equals("3"))	sqlwhere+=" <'"+tmpvalue +"' ";
						if(tmpopt.equals("4"))	sqlwhere+=" <='"+tmpvalue +"' ";
						if(tmpopt.equals("5"))	sqlwhere+=" ='"+tmpvalue +"' ";
						if(tmpopt.equals("6"))	sqlwhere+=" <>'"+tmpvalue +"' ";

					}
					if(!tmpvalue1.equals("")){
						if(!haveLeftBracket){
							sqlwhere += " and ("+temOwner+"."+tmpcolname;
							haveLeftBracket=true;
						}else{
							sqlwhere += " and "+temOwner+"."+tmpcolname;
						}
						if(tmpopt1.equals("1"))	sqlwhere+=" >'"+tmpvalue1 +"' ";
						if(tmpopt1.equals("2"))	sqlwhere+=" >='"+tmpvalue1 +"' ";
						if(tmpopt1.equals("3"))	sqlwhere+=" <'"+tmpvalue1 +"' ";
						if(tmpopt1.equals("4"))	sqlwhere+=" <='"+tmpvalue1 +"' ";
						if(tmpopt1.equals("5"))	sqlwhere+=" ='"+tmpvalue1+"' ";
						if(tmpopt1.equals("6"))	sqlwhere+=" <>'"+tmpvalue1 +"' ";
					}
				}
				else if(tmphtmltype.equals("3") && (tmptype.equals("17") || tmptype.equals("18") || tmptype.equals("37") || tmptype.equals("65") || tmptype.equals("162"))){       // 对多人力资源，多客户，多文档的处理
					//sqlwhere += "and (','+CONVERT(varchar,"+temOwner+"."+tmpcolname+")+',' ";
					if(isoracle){
						sqlwhere += "and (','||"+temOwner+"."+tmpcolname+"||',' ";
					}else{
						sqlwhere += "and (','+CONVERT(varchar,"+temOwner+"."+tmpcolname+")+',' ";
					}
					haveLeftBracket=true;
					if(tmpopt.equals("1"))	sqlwhere+=" like '%,"+tmpvalue +",%' ";
					if(tmpopt.equals("2"))	sqlwhere+=" not like '%,"+tmpvalue +",%' ";
				}

				if(haveLeftBracket){
					sqlwhere +=") ";
				}

			}

		}

			session.setAttribute(user.getUID()+"_"+srcsecid+"whereKeyStr",whereKeyStr);
		
		//for debug
		//System.out.println(sqlwhere);
		if(!sqlwhere.equals("")){
			//去掉sql语句前面的and
			sqlwhere = sqlwhere.trim().substring(3);
			DocSearchComInfo.setCustomSqlWhere(sqlwhere);
		}else{
			DocSearchComInfo.setCustomSqlWhere("");
		}
		//处理自定义条件 end
	  }
	  String attrs = "{'layoutTableId':'setting','expandAllGroup':'true','layoutTableDisplay':'"+(firstStep?"":"none")+"'}";
	%>
	
		<wea:layout type="4col" attributes='<%=attrs %>'>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(19214,user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelName(331,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(33092,user.getLanguage())%></wea:item>
				<wea:item>
					<span>
						   <brow:browser temptitle='<%=SystemEnv.getHtmlLabelNames("331,33092",user.getLanguage()) %>' viewType="0" name="srcsecid" browserValue='<%=srcsecid!=-1?(""+srcsecid):""%>' 
							browserUrl="" getBrowserUrlFn="getBrowserUrlFn" idKey="id" nameKey="path" language='<%=""+user.getLanguage() %>'
							_callback="afterOnSelectCategory" _callbackParams="1"
							hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
							completeUrl='<%="/data.jsp?type=categoryBrowser&onlySec=true&operationcode="+operationcode%>' linkUrl="#" width="60%" 
							browserSpanValue='<%=srcpath%>'></brow:browser>
					</span>
					<INPUT type=hidden name=srcmainid id="srcmainid" value="<%=srcmainid%>">
                    <INPUT type=hidden name=srcsubid id="srcsubid"  value="<%=srcsubid%>">
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(330,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(33092,user.getLanguage())%></wea:item>
				<wea:item>
					<span>
					   <brow:browser temptitle='<%=SystemEnv.getHtmlLabelNames("330,33092",user.getLanguage()) %>' viewType="0" name="objsecid" browserValue='<%=objsecid!=-1?(""+objsecid):""%>' 
						browserUrl="" getBrowserUrlFn="getBrowserUrlFn" idKey="id" nameKey="path"
						_callback="afterOnSelectCategory" _callbackParams="1" language='<%=""+user.getLanguage() %>'
						hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
						completeUrl='<%="/data.jsp?type=categoryBrowser&onlySec=true&operationcode="+operationcode%>' linkUrl="#"  
						browserSpanValue='<%=objpath%>'></brow:browser>
					</span>
					<INPUT type=hidden name=objmainid id="objmainid" value="<%=objmainid%>">
                    <INPUT type=hidden name=objsubid  id="objsubid" value="<%=objsubid%>">
				</wea:item>
				</wea:group>
				<wea:group context='<%=SystemEnv.getHtmlLabelNames("17037",user.getLanguage())%>'>
				<wea:item attributes="{'colspan':'2','isTableList':'true','customAttrs':'style=width:50%;'}">
					<wea:layout type="table" needImportDefaultJsAndCss="false" attributes="{'layoutTableId':'SrcBrowseTable','cols':'3','cws':'20%,40%,40%'}">
						<wea:group context="" attributes="{'groupDisplay':'none'}">
							<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(331,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(33092,user.getLanguage())%></wea:item>
							<wea:item type="thead"></wea:item>
							<wea:item type="thead"></wea:item>
							<%
								CustomFieldManager cfm = new CustomFieldManager("DocCustomFieldBySecCategory",srcsecid);
								cfm.getCustomFields();
								String desc = "";
								while(cfm.next()){
								 	if(cfm.getHtmlType().equals("1")){
								        desc = SystemEnv.getHtmlLabelName(688,user.getLanguage());
								    } else if(cfm.getHtmlType().equals("2")){
								        desc = SystemEnv.getHtmlLabelName(689,user.getLanguage());
								    } else if(cfm.getHtmlType().equals("3")){
								        desc=SystemEnv.getHtmlLabelName(695,user.getLanguage());
								    } else if(cfm.getHtmlType().equals("4")){
								        desc=SystemEnv.getHtmlLabelName(691,user.getLanguage());
								    } else if(cfm.getHtmlType().equals("5")){
								        desc=SystemEnv.getHtmlLabelName(690,user.getLanguage());
								    } 
								    desc += "-";
								    if(cfm.getHtmlType().equals("1")){
								        if(cfm.getType() == 1){
								            desc+=SystemEnv.getHtmlLabelName(608,user.getLanguage());
								        } else if(cfm.getType() == 2){
								            desc+=SystemEnv.getHtmlLabelName(696,user.getLanguage());
								        } else if(cfm.getType() == 3){;
								            desc+=SystemEnv.getHtmlLabelName(697,user.getLanguage());
								        }
								    }else if(cfm.getHtmlType().equals("3")){
								    	desc+=SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(String.valueOf(cfm.getType())),0),7);
								    } else if(cfm.getHtmlType().equals("5")){

								    }
							%>
								<wea:item>
									<input type="radio" name="SelectedSrcProperty" value="<%=cfm.getId()%>`<%=cfm.getLable()%>`<%=cfm.getHtmlType()%>`<%=cfm.getType()%>`<%=desc %>">
								</wea:item>
								<wea:item>
									<%=cfm.getLable()%>
								</wea:item>
								<wea:item>
									
								   <%=desc %>
								</wea:item>
							<%}%>
						</wea:group>
					</wea:layout>
				</wea:item>
				<wea:item attributes="{'colspan':'2','isTableList':'true','customAttrs':'style=width:50%;'}">
					<wea:layout type="table" needImportDefaultJsAndCss="false" attributes="{'layoutTableId':'ObjBrowseTable','cols':'3','cws':'20%,40%,40%'}">
						<wea:group context="" attributes="{'groupDisplay':'none'}">
							<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(330,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(33092,user.getLanguage())%></wea:item>
							<wea:item type="thead"></wea:item>
							<wea:item type="thead"></wea:item>
							<%
								CustomFieldManager cfm = new CustomFieldManager("DocCustomFieldBySecCategory",objsecid);
									cfm.getCustomFields();
									String desc = "";
									while(cfm.next()){
									if(cfm.getHtmlType().equals("1")){
								        desc = SystemEnv.getHtmlLabelName(688,user.getLanguage());
								    } else if(cfm.getHtmlType().equals("2")){
								        desc = SystemEnv.getHtmlLabelName(689,user.getLanguage());
								    } else if(cfm.getHtmlType().equals("3")){
								        desc=SystemEnv.getHtmlLabelName(695,user.getLanguage());
								    } else if(cfm.getHtmlType().equals("4")){
								        desc=SystemEnv.getHtmlLabelName(691,user.getLanguage());
								    } else if(cfm.getHtmlType().equals("5")){
								        desc=SystemEnv.getHtmlLabelName(690,user.getLanguage());
								    } 
								    desc += "-";
								    if(cfm.getHtmlType().equals("1")){
								        if(cfm.getType() == 1){
								            desc+=SystemEnv.getHtmlLabelName(608,user.getLanguage());
								        } else if(cfm.getType() == 2){
								            desc+=SystemEnv.getHtmlLabelName(696,user.getLanguage());
								        } else if(cfm.getType() == 3){;
								            desc+=SystemEnv.getHtmlLabelName(697,user.getLanguage());
								        }
								    }else if(cfm.getHtmlType().equals("3")){
								    	desc+=SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(String.valueOf(cfm.getType())),0),7);
								    } else if(cfm.getHtmlType().equals("5")){

								    }
							%>
								<wea:item>
									<input type="radio" name="SelectedObjProperty" value="<%=cfm.getId()%>`<%=cfm.getLable()%>`<%=cfm.getHtmlType()%>`<%=cfm.getType()%>`<%=desc %>">
								</wea:item>
								<wea:item>
									<%=cfm.getLable()%>
								</wea:item>
								<wea:item>
									
								   <%=desc %>
								</wea:item>
							<%}%>
						</wea:group>
					</wea:layout>
				</wea:item>
			</wea:group>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(33254,user.getLanguage())%>'>
				<wea:item type="groupHead">
					<input Class=addbtn type=button onclick="addPropertyMapping()" />
					<input Class=delbtn type=button onclick="delPropertyMapping()" />
				</wea:item>
				<wea:item attributes="{'colspan':'full','isTableList':'true'}">
					<div id="selectedPropertyMappingDiv">
					</div>
					<script type="text/javascript">
						var group = null;
						jQuery(document).ready(function(){
							var items=[
								{width:"30%",colname:"<%=SystemEnv.getHtmlLabelNames("331,33092,17037",user.getLanguage())%>",itemhtml:"<span type='span' name='srccol'></span>"},
								{width:"20%",colname:"<%=SystemEnv.getHtmlLabelName(687,user.getLanguage())%>",itemhtml:"<span type='span' name='srctype'></span>"},
								{width:"30%",colname:"<%=SystemEnv.getHtmlLabelNames("330,33092,17037",user.getLanguage())%>",itemhtml:"<span type='span' name='objcol'></span>"},
								{width:"20%",colname:"<%=SystemEnv.getHtmlLabelName(687,user.getLanguage())%>",itemhtml:"<span type='span' name='objtype'></span>"}
								];
							var option = {
								basictitle:"",
								optionHeadDisplay:"none",
								colItems:items,
								container:"#selectedPropertyMappingDiv",
								toolbarshow:false,
								configCheckBox:true,
             					checkBoxItem:{"itemhtml":'<input name="chkSelectedPropertyMapping" class="groupselectbox" type="checkbox" >',width:"5%"}
							};
							group=new WeaverEditTable(option);
							jQuery("#selectedPropertyMappingDiv").append(group.getContainer());
							});
					</script>
				</wea:item>
			</wea:group>
		</wea:layout>
		<%if (CanMove || CanCopy){%>
			<%String attrs1 = "{'layoutTableId':'resultList','layoutTableDisplay':'"+(!firstStep?"":"none")+"'}"; %>
			<wea:layout needImportDefaultJsAndCss="false" attributes='<%=attrs1 %>'>
				<wea:group context="" attributes="{'groupDisplay':'none'}">
					<wea:item attributes="{'isTableList':'true','colspan':'full'}">
						<%
							String userid=user.getUID()+"" ;
							String loginType = user.getLogintype() ;

							int displayUsage = Util.getIntValue(request.getParameter("displayUsage"),0);
							String sqlWhere="";
							String tabletype="checkbox";
							String browser="";

							String tableString = "";
							String tableInfo = "";
							String isNew = "";

							boolean isUsedCustomSearch = false;

							if(DocSearchComInfo.getSeccategory()!=null&&!"".equals(DocSearchComInfo.getSeccategory())){
								isUsedCustomSearch = SecCategoryComInfo.isUsedCustomSearch(Util.getIntValue(DocSearchComInfo.getSeccategory()));
							}


							if(isUsedCustomSearch){
								String outFields = "isnull((select sum(readcount) from docReadTag where userType ="+user.getLogintype()+" and docid=r.id and userid="+user.getUID()+"),0) as readCount";
								if(RecordSet.getDBType().equals("oracle"))
								{
									outFields = "nvl((select sum(readcount) from docReadTag where userType ="+user.getLogintype()+" and docid=r.id and userid="+user.getUID()+"),0) as readCount";
								}
								//backFields
								String backFields = "";
								//backFields = getFilterBackFields(backFields,"t1.id,t1.seccategory,t1.doclastmodtime,t1.docsubject,t1.docextendname");
								backFields = getFilterBackFields(backFields,"t1.id,t1.seccategory,t1.doclastmodtime,t1.docsubject,t1.docextendname,t1.doccreaterid");
								
								//from
								String  sqlFrom = "DocDetail  t1 ";
								
								String strCustomSql=DocSearchComInfo.getCustomSqlWhere();
								if(!strCustomSql.equals("")){
								  sqlFrom += ", cus_fielddata tCustom ";
								}
								//where
								
								//String isNew
								isNew = DocSearchComInfo.getIsNew() ;
								
								String whereclause = " where " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;

								/* added by wdl 2006-08-28 不显示历史版本 */
								whereclause+=" and (ishistory is null or ishistory = 0) ";
								/* added end */
								
								
								//用于暂时屏蔽外部用户的订阅功能
								//if (!"1".equals(loginType)){
									tableInfo = "";
								//}
								
								
									
								sqlFrom += ",(select ljt1.id as docid,ljt2.* from DocDetail ljt1 LEFT JOIN cus_fielddata ljt2 ON ljt1.id=ljt2.id and ljt2.scope='DocCustomFieldBySecCategory' and ljt2.scopeid="+DocSearchComInfo.getSeccategory()+") tcm";
								whereclause += " and t1.id = tcm.docid ";
								
								
								
								
								
								sqlWhere = whereclause;
								//System.out.println(sqlWhere);
								//colString
								String userInfoForotherpara =loginType+"+"+userid;
								String colString ="";
								if(displayUsage==0){
									colString +="<col name=\"id\" width=\"3%\"  align=\"center\" text=\" \" column=\"docextendname\" orderkey=\"docextendname\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIconByExtendName\"/>";
								}
								if(displayUsage==1){
									//colString +="<col name=\"id\" width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"\" column=\"id\" orderkey=\"docsubject\" target=\"_fullwindow\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameAndIsNewByDocId\" otherpara=\""+userInfoForotherpara+"\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\"/>";
									colString +="<col name=\"id\" width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"\" column=\"id\" orderkey=\"docsubject\" target=\"_fullwindow\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameAndIsNewByDocId90974\" otherpara=\""+userInfoForotherpara+"+column:doccreaterid+column:readCount+column:docsubject\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\"/>";
								}
								
								//orderBy
								//String orderBy = "doclastmoddate,doclastmodtime"; 
								String orderBy = "doclastmoddate,doclastmodtime";   
								//primarykey
								String primarykey = "t1.id";
								//pagesize
								int pagesize = numperpage;
								
									   
								SecCategoryCustomSearchComInfo.checkDefaultCustomSearch(Util.getIntValue(DocSearchComInfo.getSeccategory()));
								RecordSet.executeSql("select * from DocSecCategoryCusSearch where secCategoryId = "+DocSearchComInfo.getSeccategory()+" order by viewindex");
								while(RecordSet.next()){
									int currId = RecordSet.getInt("id");
									int currDocPropertyId = RecordSet.getInt("docPropertyId");
									int currVisible = RecordSet.getInt("visible");
									
									int currType = Util.getIntValue(SecCategoryDocPropertiesComInfo.getType(currDocPropertyId+""));
							//		if(currType==1) continue;
									
									int currIsCustom = Util.getIntValue(SecCategoryDocPropertiesComInfo.getIsCustom(currDocPropertyId+""));
									
									int currLabelId = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
									String currCustomName = Util.null2String(SecCategoryDocPropertiesComInfo.getCustomName(currDocPropertyId+"",user.getLanguage()));
									
									String currName = (currCustomName.equals("")&&currLabelId>0)?SystemEnv.getHtmlLabelName(currLabelId, user.getLanguage()):currCustomName;
									
									if((currVisible==1 || currVisible==-1)&&displayUsage==0){
										if(currIsCustom==1){
											int tmpfieldid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getFieldId(currDocPropertyId+""));
											String tmpcustomName = SecCategoryDocPropertiesComInfo.getCustomName(currDocPropertyId+"",user.getLanguage());

											int tempIndexId=tmpcustomName.lastIndexOf("("+SystemEnv.getHtmlLabelName(19516,user.getLanguage())+")");
											if(tempIndexId<=0){
												tempIndexId=tmpcustomName.lastIndexOf("(user-defined)");
											}
											if(tempIndexId>0){
												tmpcustomName=tmpcustomName.substring(0,tempIndexId);
											}

											backFields=getFilterBackFields(backFields,"tcm.field"+tmpfieldid);
											colString +="<col width=\"10%\"  text=\""+tmpcustomName+"\" column=\""+"field"+tmpfieldid+"\" orderkey=\""+"field"+tmpfieldid+"\"  transmethod=\"weaver.docs.docs.CustomFieldSptmForDoc.getFieldShowName\"   otherpara=\""+tmpfieldid+"+"+ user.getLanguage()+"\"/>";
										} else {
											if(currType==1){
													//colString +="<col name=\"id\" width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(19541,user.getLanguage())+"\" column=\"id\" orderkey=\"docsubject\" target=\"_fullwindow\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameAndIsNewByDocId\" otherpara=\""+userInfoForotherpara+"\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\"/>";
													colString +="<col name=\"id\" width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(19541,user.getLanguage())+"\" column=\"id\" orderkey=\"docsubject\" target=\"_fullwindow\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameAndIsNewByDocId90974\" otherpara=\""+userInfoForotherpara+"+column:doccreaterid+column:readCount+column:docsubject\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\"/>";
											} else if(currType==2){
												int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
												backFields=getFilterBackFields(backFields,"t1.docCode");
												colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"docCode\" orderkey=\"docCode\"/>";
											} else if(currType==3){
												int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
												backFields=getFilterBackFields(backFields,"t1.docpublishtype");
												colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"docpublishtype\" orderkey=\"docpublishtype\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocPublicType\" otherpara=\""+user.getLanguage()+"\"/>";
											} else if(currType==4){
												int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
												backFields=getFilterBackFields(backFields,"t1.docedition");
												colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"id\" orderkey=\"docedition\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocVersion\"/>";
											} else if(currType==5){
												int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
												backFields=getFilterBackFields(backFields,"t1.docstatus");
												//colString +="<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"id\" orderkey=\"docstatus\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus2\" otherpara=\""+user.getLanguage()+"\"/>";
												colString +="<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"id\" orderkey=\"docstatus\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus3\" otherpara=\""+user.getLanguage()+"+column:docstatus+column:seccategory\"/>";            	    
											} else if(currType==6){
												int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
												backFields=getFilterBackFields(backFields,"t1.maincategory");
												//colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"maincategory\" orderkey=\"maincategory\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocMaincategory\"/>";
											} else if(currType==7){
												int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
												backFields=getFilterBackFields(backFields,"t1.subcategory");
												//colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"subcategory\" orderkey=\"subcategory\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocSubcategory\"/>";
											} else if(currType==8){
												int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
												backFields=getFilterBackFields(backFields,"t1.seccategory");
												colString +="<col width=\"10%\" pkey=\"seccategory+weaver.splitepage.transform.SptmForDoc.getDocSeccategory\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"seccategory\" orderkey=\"seccategory\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getAllDirName\"/>";
											} else if(currType==9){
												int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
												backFields=getFilterBackFields(backFields,"t1.docdepartmentid");
												colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"docdepartmentid\" orderkey=\"docdepartmentid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocDepartment\"/>";
											} else if(currType==10){
												
												
											} else if(currType==11){
												int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
												backFields=getFilterBackFields(backFields,"t1.doclangurage");
												colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"doclangurage\" orderkey=\"doclangurage\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocLangurage\"/>";
											} else if(currType==12){
												int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
												backFields=getFilterBackFields(backFields,"t1.keyword");
												colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"keyword\" orderkey=\"keyword\"/>";
											} else if(currType==13){
												int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
												//backFields=getFilterBackFields(backFields,"t1.doccreaterid,t1.doccreatedate,t1.doccreatetime");
												backFields=getFilterBackFields(backFields,"t1.doccreatedate,t1.doccreatetime");
												colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"doccreatedate\" orderkey=\"doccreatedate\"/>";
											} else if(currType==14){
												int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
												backFields=getFilterBackFields(backFields,"t1.doclastmoduserid,t1.doclastmoddate,t1.doclastmodtime");
												colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"doclastmoddate\" orderkey=\"doclastmoddate,doclastmodtime\"/>";
											} else if(currType==15){
												int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
												backFields=getFilterBackFields(backFields,"t1.docapproveuserid,t1.docapprovedate,t1.docapprovetime");
												colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"docapprovedate\" orderkey=\"docapprovedate\"/>";
											} else if(currType==16){
												int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
												backFields=getFilterBackFields(backFields,"t1.docinvaluserid,t1.docinvaldate,t1.docinvaltime");
												colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"docinvaldate\" orderkey=\"docinvaldate\"/>";
											} else if(currType==17){
												int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
												backFields=getFilterBackFields(backFields,"t1.docarchiveuserid,t1.docarchivedate,t1.docarchivetime");
												colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"docarchivedate\" orderkey=\"docarchivedate\"/>";
											} else if(currType==18){
												int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
												backFields=getFilterBackFields(backFields,"t1.doccanceluserid,t1.doccanceldate,t1.doccanceltime");
												colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"doccanceldate\" orderkey=\"doccanceldate\"/>";
											} else if(currType==19){
												int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
												backFields=getFilterBackFields(backFields,"t1.maindoc");
												colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"id\" otherpara=\"column:maindoc+"+user.getLanguage()+"\" orderkey=\"maindoc\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocMaindoc\"/>";
											} else if(currType==20){
												
												
											} else if(currType==21){
												int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
												backFields=getFilterBackFields(backFields,"t1.ownerid");
												colString +="<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"ownerid\" orderkey=\"ownerid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"column:usertype\"/>";
											} else if(currType==22){
												int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
												backFields=getFilterBackFields(backFields,"t1.invalidationdate");
												colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"invalidationdate\" orderkey=\"invalidationdate\"/>";
											}
											
											
										}
									}
								}
								
								
								
								
								
								
								
								//  用户自定义设置
								boolean dspcreater = false ;
								boolean dspcreatedate = false ;
								boolean dspmodifydate = false ;
								boolean dspdocid = false;
								boolean dspcategory = false ;
								boolean dspaccessorynum = false ;
								boolean dspreplynum = false ;
								
								if (UserDefaultManager.getHasdocid().equals("1")) {
									dspdocid = true;
								}

								if (UserDefaultManager.getHasreplycount().equals("1")&&displayUsage==0) {  
									dspreplynum = true ;
									backFields=getFilterBackFields(backFields,"t1.replaydoccount");
									colString +="<col width=\"6%\"  text=\""+SystemEnv.getHtmlLabelName(18470,user.getLanguage())+"\" column=\"id\" otherpara=\"column:replaydoccount\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getAllEditionReplaydocCount\"/>";
								}
								if (UserDefaultManager.getHasaccessorycount().equals("1")&&displayUsage==0) {  
									dspaccessorynum = true ;
									backFields=getFilterBackFields(backFields,"t1.accessorycount");
									colString +="<col width=\"6%\" text=\""+SystemEnv.getHtmlLabelName(2002,user.getLanguage())+"\" column=\"accessorycount\" orderkey=\"accessorycount\"/>";
								}
								

								backFields=getFilterBackFields(backFields,"t1.sumReadCount,t1.docstatus,t1.sumMark");
								if(displayUsage==0) {
									colString +="<col width=\"6%\"   text=\""+SystemEnv.getHtmlLabelName(18469,user.getLanguage())+"\" column=\"sumReadCount\" orderkey=\"sumReadCount\"/>";

								}
								
								if(backFields.startsWith(",")) backFields=backFields.substring(1);
								if(backFields.endsWith(",")) backFields=backFields.substring(0,backFields.length()-1);
								
								
									
								//默认为按文档创建日期排序所以,必须要有这个字段
								if (backFields.indexOf("doclastmoddate")==-1) {
									backFields+=",doclastmoddate";
								}
								
								//String tableString
								tableString="<table  pagesize=\""+pagesize+"\" tabletype=\""+tabletype+"\">";
								tableString+=browser;
								//tableString+="<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\""+primarykey+"\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqldistinct=\"true\" />";
								tableString+="<sql outfields=\""+Util.toHtmlForSplitPage(outFields)+"\" backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\""+primarykey+"\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqldistinct=\"true\" />";
								tableString+="<head>"+colString+"</head>";
								//tableString+=operateString;
								tableString+="</table>";   
								  
							} else {
								
								 
								//backFields
								//String backFields="t1.id,t1.seccategory,t1.doclastmodtime,t1.docsubject,t1.docextendname,";
								String outFields = "isnull((select sum(readcount) from docReadTag where userType ="+user.getLogintype()+" and docid=r.id and userid="+user.getUID()+"),0) as readCount";
								if(RecordSet.getDBType().equals("oracle"))
								{
									outFields = "nvl((select sum(readcount) from docReadTag where userType ="+user.getLogintype()+" and docid=r.id and userid="+user.getUID()+"),0) as readCount";
								}
								//backFields
								String backFields="t1.id,t1.seccategory,t1.doclastmodtime,t1.docsubject,t1.docextendname,t1.doccreaterid,";
								//from
								String  sqlFrom = "DocDetail  t1";  
								String strCustomSql=DocSearchComInfo.getCustomSqlWhere();
								if(!strCustomSql.equals("")){
								  sqlFrom += ", cus_fielddata tCustom ";
								}
								//where
								

								String whereclause = " where " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;
								
								/* added by wdl 2006-08-28 不显示历史版本 */
								whereclause+=" and (ishistory is null or ishistory = 0) ";
								/* added end */
								
								
								//用于暂时屏蔽外部用户的订阅功能
								//if (!"1".equals(loginType)){
									tableInfo = "";
								//}
								sqlWhere = whereclause;
								//System.out.println(sqlWhere);
								//colString
								String userInfoForotherpara =loginType+"+"+userid;
								String colString ="";
								if(displayUsage==0){
									colString +="<col name=\"id\" width=\"3%\"  align=\"center\" text=\" \" column=\"docextendname\" orderkey=\"docextendname\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIconByExtendName\"/>";
								}
								//colString +="<col name=\"id\" width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"\" column=\"id\" orderkey=\"docsubject\" target=\"_fullwindow\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameAndIsNewByDocId\" otherpara=\""+userInfoForotherpara+"\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\"/>";
								colString +="<col name=\"id\" width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"\" column=\"id\" orderkey=\"docsubject\" target=\"_fullwindow\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameAndIsNewByDocId90974\" otherpara=\""+userInfoForotherpara+"+column:doccreaterid+column:readCount+column:docsubject\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\"/>";
								//orderBy
								String orderBy = "doclastmoddate,doclastmodtime";    
								//primarykey
								String primarykey = "t1.id";
								//pagesize
								int pagesize = numperpage;

									
								//  用户自定义设置
								boolean dspcreater = false ;
								boolean dspcreatedate = false ;
								boolean dspmodifydate = false ;
								boolean dspdocid = false;
								boolean dspcategory = false ;
								boolean dspaccessorynum = false ;
								boolean dspreplynum = false ;
								
								
								if (UserDefaultManager.getHasdocid().equals("1")) {
									dspdocid = true;    
								}
								if (UserDefaultManager.getHascreater().equals("1")&&displayUsage==0) {
									  dspcreater = true ;
									  backFields+="ownerid,t1.usertype,";
									  colString +="<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(79,user.getLanguage())+"\" column=\"ownerid\" orderkey=\"ownerid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"column:usertype\"/>";
								}
								if (UserDefaultManager.getHascreatedate().equals("1")&&displayUsage==0) { 
									dspcreatedate = true ;
									backFields+="doccreatedate,";
									colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"doccreatedate\" orderkey=\"doccreatedate\"/>";
								}
								if (UserDefaultManager.getHascreatetime().equals("1")&&displayUsage==0) {
									dspmodifydate = true ;
									backFields+="doclastmoddate,";
									colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(723,user.getLanguage())+"\" column=\"doclastmoddate\" orderkey=\"doclastmoddate,doclastmodtime\"/>";
								}
								if (UserDefaultManager.getHascategory().equals("1")&&displayUsage==0) {   
									dspcategory = true ;
									backFields+="maincategory,";
									colString +="<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(92,user.getLanguage())+"\" column=\"id\" orderkey=\"maincategory\" returncolumn=\"id\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getAllDirName\"/>";
								}
								if (UserDefaultManager.getHasreplycount().equals("1")&&displayUsage==0) {  
									dspreplynum = true ;
									backFields+="replaydoccount,";
									colString +="<col width=\"6%\"  text=\""+SystemEnv.getHtmlLabelName(18470,user.getLanguage())+"\" column=\"id\" otherpara=\"column:replaydoccount\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getAllEditionReplaydocCount\"/>";
								}
								if (UserDefaultManager.getHasaccessorycount().equals("1")&&displayUsage==0) {  
									dspaccessorynum = true ;
									backFields+="accessorycount,";
									colString +="<col width=\"6%\" text=\""+SystemEnv.getHtmlLabelName(2002,user.getLanguage())+"\" column=\"accessorycount\" orderkey=\"accessorycount\"/>";
								}
								
								backFields+="sumReadCount,docstatus,sumMark";
								
								if(displayUsage==0) {
									colString +="<col width=\"6%\"   text=\""+SystemEnv.getHtmlLabelName(18469,user.getLanguage())+"\" column=\"sumReadCount\" orderkey=\"sumReadCount\"/>";
									//colString +="<col width=\"5%\"   text=\""+SystemEnv.getHtmlLabelName(15663,user.getLanguage())+"\" column=\"sumMark\" orderkey=\"sumMark\"/>";
									//colString +="<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"docstatus\" orderkey=\"docstatus\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus\" otherpara=\""+user.getLanguage()+"\"/>";
									//colString +="<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"id\" orderkey=\"docstatus\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus2\"  otherpara=\""+user.getLanguage()+"\"/>";
									colString +="<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"id\" orderkey=\"docstatus\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus3\"  otherpara=\""+user.getLanguage()+"+column:docstatus+column:seccategory\"/>";
								}
									
								//默认为按文档创建日期排序所以,必须要有这个字段
								if (backFields.indexOf("doclastmoddate")==-1) {
									backFields+=",doclastmoddate";
								}
								

								//String tableString
								tableString="<table  pagesize=\""+pagesize+"\" tabletype=\""+tabletype+"\">";
								tableString+=browser;
								//tableString+="<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\""+primarykey+"\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqldistinct=\"true\" />";
								tableString+="<sql outfields=\""+Util.toHtmlForSplitPage(outFields)+"\" backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\""+primarykey+"\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqldistinct=\"true\" />";
								tableString+="<head>"+colString+"</head>";
								//tableString+=operateString;
								tableString+="</table>";     
								 
							}     
							 %>
							<%--
							<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"/>
							--%> 
							<div id ='divContent' style='' >
								<div id='_xTable' style='background:#FFFFFF;width:100%' valign='top'> </div>
 							</div>
 							<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.DOC_CMLIST%>"/>
					</wea:item>
				</wea:group>
			</wea:layout>
			<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
				<jsp:include page="/docs/search/DocSearchCondition.jsp" flush="true">
					<jsp:param name="secCategoryId" value="<%=srcsecid%>" />
					<jsp:param name="urlType" value="99" />
				</jsp:include>
			</div>
			<%}%>
			
</form>
</body>
</html>

<script language="javascript">

function onBtnSearchClick(){
	getGridInfo();
}

function CheckAll(checked) {
    len = document.frmmain.elements.length;
    var i=0;
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name=='checkedDoc') {
            if(document.frmmain.elements[i].disabled==false){
                document.frmmain.elements[i].checked=(checked==true?true:false);
            }
        }
    }
}

function getBrowserUrlFn(){
	var otype=jQuery("#otype").val();
	var operationcode = <%=HrmUserVarify.checkUserRight("DocCopyMove:Copy", user)?-1:MultiAclManager.OPERATION_COPYDOC%>;
	if(parseInt(otype)==1){
		operationcode = <%=HrmUserVarify.checkUserRight("DocCopyMove:Copy", user)?-1:MultiAclManager.OPERATION_COPYDOC%>;
	}else if(parseInt(otype)==2){
		operationcode = <%=HrmUserVarify.checkUserRight("DocCopyMove:Move", user)?-1:MultiAclManager.OPERATION_MOVEDOC%>;
	}
	return "/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/category/MultiCategorySingleBrowser.jsp?operationcode="+operationcode+"&otype="+jQuery("#otype").val();
	
}

function afterOnSelectCategory(e,result,fieldid,whichcategory){
	if (result != null) {
	    if (parseInt(result.id) > 0)  {
			delAllPropertyMapping();
			onSearch();
    	} else {
   	    	document.getElementById(fieldid).value=-1;
			delAllPropertyMapping();
			onSearch();
    	}
	}
}

function onSelectCategory(whichcategory,input,spanname) {
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;

    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp?otype="+document.getElementById("otype").value
    		,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
    if (result != null) {
	    if (parseInt(result.tag) > 0)  {
    	    if (whichcategory == 1) {
				document.getElementById("srcsecid").value=result.id;
				delAllPropertyMapping();
				onSearch();
    	    } else {
    	    	document.getElementById("objsecid").value=result.id;
				delAllPropertyMapping();
				onSearch();
    	    }
    	} else {
    	    if (whichcategory == 1) {
    	    	document.getElementById("srcsecid").value=-1;
				delAllPropertyMapping();
				onSearch();
    	    } else {
    	    	document.getElementById("objsecid").value=-1;
				delAllPropertyMapping();
				onSearch();
    	    }
    	}
	}
}
function checkHaveSce(){
	if (document.frmmain.objsecid.value==-1 || document.frmmain.objsecid.value==''){
		window.top.Dialog.alert('<%=SystemEnv.getErrorMsgName(10,user.getLanguage())%>');
		return false;
		}
	else return true;
}
function checkSelected(){
	len = document.frmmain.elements.length;
	for( i=0; i<len; i++) {
		if (document.frmmain.elements[i].name=='chkInTableTag') {
			if(document.frmmain.elements[i].checked)
			return true;
		}
	}
	window.top.Dialog.alert('<%=SystemEnv.getErrorMsgName(10,user.getLanguage())%>');
	return false;
}
function onCopy(copybtn){
	if(checkHaveSce()&&checkSelected()){
        document.frmmain.docStrs.value=_xtable_CheckedCheckboxId(); 
		
		 jQuery(copybtn).attr('disabled','disabled');
		e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(33592,user.getLanguage())%>",true);
        document.frmmain.operation.value="copy";
		DocDwrUtil.ifCanRepeatName(_xtable_CheckedCheckboxId(),document.frmmain.objsecid.value,
			{callback:function(result){
				if(result=='true'){
					if(confirm("<%=SystemEnv.getHtmlLabelName(26086,user.getLanguage())%>")){
						document.frmmain.ifrepeatedname.value="yes";
					}else{
						document.frmmain.ifrepeatedname.value="no";
					}
					document.frmmain.submit();
				}else{
 					document.frmmain.submit();
				}
			  }
			}
		);
		_xtable_CleanCheckedCheckbox(); 
	}

}
function onCopyShare(coysharebtn){
	
	if(confirm("<%=SystemEnv.getHtmlLabelName(31831,user.getLanguage())%>")){
	if(checkHaveSce()&&checkSelected()){
        document.frmmain.docStrs.value=_xtable_CheckedCheckboxId();  
		
		 jQuery(coysharebtn).attr('disabled','disabled');
		 e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(33592,user.getLanguage())%>",true);
        document.frmmain.operation.value="copy";
		document.frmmain.action="DocCopyMoveOperation.jsp?sharebysec=1";
		DocDwrUtil.ifCanRepeatName(_xtable_CheckedCheckboxId(),document.frmmain.objsecid.value,
			{callback:function(result){
				if(result=='true'){
					if(confirm("<%=SystemEnv.getHtmlLabelName(26086,user.getLanguage())%>")){
						document.frmmain.ifrepeatedname.value="yes";
					}else{
						document.frmmain.ifrepeatedname.value="no";
					}
					document.frmmain.submit();
				}else{
 					document.frmmain.submit();
				}
			  }
			}
		);
		_xtable_CleanCheckedCheckbox(); 
	}
	}
}
function onMove(){
	if(checkHaveSce()&&checkSelected()){

        document.frmmain.docStrs.value=_xtable_CheckedCheckboxId();  
		document.frmmain.operation.value="move";
		
		DocDwrUtil.ifCanRepeatName(_xtable_CheckedCheckboxId(),document.frmmain.objsecid.value,
			{callback:function(result){
				if(result=='true'){
					if(confirm("<%=SystemEnv.getHtmlLabelName(26086,user.getLanguage())%>")){
						document.frmmain.ifrepeatedname.value="yes";
					}else{
						document.frmmain.ifrepeatedname.value="no";
					}
					document.frmmain.submit();
				}else{
 					document.frmmain.submit();
				}
			  }
			}
		);
	}
}
function onMoveShare(){
	if(confirm("<%=SystemEnv.getHtmlLabelName(31831,user.getLanguage())%>")){
	if(checkHaveSce()&&checkSelected()){
		
        document.frmmain.docStrs.value=_xtable_CheckedCheckboxId(); 
		document.frmmain.action="DocCopyMoveOperation.jsp?sharebysec=1";
		document.frmmain.operation.value="move";
		
		DocDwrUtil.ifCanRepeatName(_xtable_CheckedCheckboxId(),document.frmmain.objsecid.value,
			{callback:function(result){
				if(result=='true'){
					if(confirm("<%=SystemEnv.getHtmlLabelName(26086,user.getLanguage())%>")){
						document.frmmain.ifrepeatedname.value="yes";
					}else{
						document.frmmain.ifrepeatedname.value="no";
					}
					document.frmmain.submit();
				}else{
 					document.frmmain.submit();
				}
			  }
			}
		);
	}
	}
}
function oc(otype){
	jQuery("otype").val(otype);
    document.frmmain.srcsecid.value="";
    document.frmmain.objsecid.value="";
    location="/docs/tools/DocCopyMove.jsp?hasTab=<%=hasTab%>&otype="+otype;
}

function addPropertyMapping(){
	var srcps = document.getElementsByName("SelectedSrcProperty");
	var objps = document.getElementsByName("SelectedObjProperty");

	var count = 0;
	var srcp = null;
	for(var i=0;srcps!=null&&srcps.length>0&&i<srcps.length;i++){
		if(srcps[i].checked){
			srcp = srcps[i].value;
			count++;
		}
	}
	if(count!=1){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(23598,user.getLanguage())%>");
		return;
	}
	count = 0;
	var objp = null;
	for(var i=0;objps!=null&&objps.length>0&&i<objps.length;i++){
		if(objps[i].checked){
			objp = objps[i].value;
			count++;
		}
	}
	if(count!=1){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(23598,user.getLanguage())%>");
		return;
	}
	
	if(srcp!=null&&objp!=null){
		var srca = srcp.split("`");
		var obja = objp.split("`");

		var chks = document.getElementsByName("chkSelectedPropertyMapping");
		var count = 0;
		for(var i=0;chks!=null&&i<chks.length;i++){
			if(chks[i]&&!chks[i].disabled&&chks[i].value==(srca[0] + "_" + obja[0])) count++;
		}
		if(count==0) {
			if(srca[2]==obja[2]&&srca[3]==obja[3]){
				//document.getElementById("selectedPropertyMappingDiv").innerHTML += "<label><input type=checkbox name='chkSelectedPropertyMapping' value='"+srca[0] + "_" + obja[0]+"'><input type=hidden name='selectedPropertyMapping' value='"+srca[0] + "_" + obja[0]+"'>"+srca[1]+" -> "+obja[1]+"&nbsp;</label>";
				var itemdata = [
					{name:"chkSelectedPropertyMapping",value:srca[0]+"_"+obja[0],type:"checkbox"},
					{name:"srccol",value:srca[1],type:"span"},
					{name:"srctype",value:srca[4],type:"span"},
					{name:"objcol",value:obja[1],type:"span"},
					{name:"objtype",value:obja[4],type:"span"}
				];
				group.addRow(itemdata);
				
			} else {
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(23596,user.getLanguage())%>");
			}
		} else {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(23597,user.getLanguage())%>");
		}
	}
}

function delPropertyMapping(){
	/*var chkSelectedPropertyMapping = document.getElementsByName("chkSelectedPropertyMapping");
	if(chkSelectedPropertyMapping==null||chkSelectedPropertyMapping.length==0) return;
	for(var i=0;chkSelectedPropertyMapping!=null&&i<chkSelectedPropertyMapping.length;i++){
		if(chkSelectedPropertyMapping[i]&&chkSelectedPropertyMapping[i].checked){
			chkSelectedPropertyMapping[i].disabled = true;
			jQuery(chkSelectedPropertyMapping[i]).parent().hide();
			jQuery(chkSelectedPropertyMapping[i]).parent().children(":eq(1)").attr("disabled","true");
		}
	}*/
	/*var chkSelectedPropertyMapping = jQuery("input[name='chkSelectedPropertyMapping']:checked");
	console.log(chkSelectedPropertyMapping);*/
	group.deleteRows();
}

function onBtnSearchClickRight(){
	if(jQuery("#advancedSearchOuterDiv").css("display")!="none"){
		onBtnSearchClick();
		jQuery("#advancedSearchOuterDiv").slideUp();
	}else{
		try{
			jQuery("span#searchblockspan",parent.document).find("img:first").click();
		}catch(e){
			onBtnSearchClick();
		}
	}
}

function onSearch(){
	document.frmmain.action="/docs/tools/DocCopyMove.jsp";
    document.frmmain.submit();
}
function delAllPropertyMapping(){
	var chkSelectedPropertyMapping = document.getElementsByName("chkSelectedPropertyMapping");
	if(chkSelectedPropertyMapping==null||chkSelectedPropertyMapping.length==0) return;
	for(var i=0;chkSelectedPropertyMapping!=null&&i<chkSelectedPropertyMapping.length;i++){
		if(chkSelectedPropertyMapping[i]){
			chkSelectedPropertyMapping[i].disabled = true;
			jQuery(chkSelectedPropertyMapping[i]).parent().hide();
			jQuery(chkSelectedPropertyMapping[i]).parent().children(":eq(1)").attr("disabled","true");
		}
	}
}
</script>
<%if (CanMove || CanCopy){%>
<script type="text/javascript">
var sessionId="";		
var colInfo;
var gridUrl ='ext/DocSearchGridExt.jsp';
var displayUsage = '0';
var seccategoryid='<%=srcsecid%>';
var customSearchPara = '';
function URLencode(sStr) 
{
	 return escape(sStr).replace(/\+/g, '%2B').replace(/\"/g,'%22').replace(/\'/g, '%27').replace(/\//g,'%2F');
}

function getSearchPara(){
	
	
	 try{
        if($G("ownerid2").value+"" != "0"){
        	
        	//jQuery("input[name='ownerid']")[0].value = $G("ownerid2").value;
        }

        if($G("doccreaterid2").value+"" != "0"){
           //$G("doccreaterid").value = $G("doccreaterid2").value;
        }
    }catch(e){}
    
	var docSearchForm = document.forms.frmmain;
	var searchPara ='';
	
	for(i=0;i<docSearchForm.elements.length;i++)
	{
		if(docSearchForm.elements[i].type=='checkbox'){
			if(docSearchForm.elements[i].checked==false){
				continue;
			}
		}
		if(docSearchForm.elements[i].name=='customSearchPara'){
			continue;
		}
		if(docSearchForm.elements[i].name=='seccategory'&&seccategoryid!='0'){
			searchPara+='&seccategory='+seccategoryid;
		}else if(docSearchForm.elements[i].name!= ''){

			if(docSearchForm.elements[i].value!=''){

				
					searchPara+='&'+docSearchForm.elements[i].name+'='+URLencode(docSearchForm.elements[i].value);
				
			}
		}
	}
	searchPara='sessionId='+sessionId+'&list=all'+searchPara;
	return searchPara;
}	


function getGridInfo(){
		var url = '/docs/search/ext/DocSearchViewColumnExt.jsp?urlType=99';
		var data2duringparam = "";
		if(document.getElementById("date2during"))
		{
			data2duringparam = "&date2during="+document.getElementById("date2during").value;
		}
		if(url.indexOf("?")==-1){
			url = url+"?seccategoryid="+seccategoryid+"&isUsedCustomSearch="+jQuery("#isUsedCustomSearch").val()+data2duringparam;
		}else{
			url = url+"&seccategoryid="+seccategoryid+"&isUsedCustomSearch="+jQuery("#isUsedCustomSearch").val()+data2duringparam;
		}
		//if(displayUsage==1){

		if(customSearchPara==''){
			url =url+'&'+getSearchPara();
		}else{
			url =url+'&'+customSearchPara;
		}
		//}


		//alert(url)

		//alert("colinfo:"+colInfo);
	
		/*var obj; 
	
	    if (window.ActiveXObject) { 
	        obj = new ActiveXObject('Microsoft.XMLHTTP'); 
	    } 
	    else if (window.XMLHttpRequest) { 
	        obj = new XMLHttpRequest(); 
	    } 	
	    
		obj.open('GET', url+"&b="+new Date().getTime(), false); 
	    obj.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded'); 
	    obj.send(null); 
	    if (obj.status == "200") {
	    	var tmpcolInfo =  obj.responseText;
	    	
	    	var posTemp=tmpcolInfo.indexOf("^^");
			if(posTemp!=-1){
		    	colInfo=tmpcolInfo.substring(0,posTemp);
		    	sessionId=tmpcolInfo.substring(posTemp+2,tmpcolInfo.length);
			}else{
				colInfo=tmpcolInfo;
			}
	    	//colInfo.subString(colInfo.indexOf("^^"))
		} else {
		}*/
		jQuery.ajax({
			url:url,
			type:"get",
			dataType:"script",
			success:function(data){
				var tmpcolInfo =  data;
		    	var posTemp=tmpcolInfo.indexOf("^^");
				if(posTemp!=-1){
			    	colInfo=tmpcolInfo.substring(0,posTemp);
			    	sessionId=tmpcolInfo.substring(posTemp+2,tmpcolInfo.length);
				}else{
					colInfo=tmpcolInfo;
				}
				eval(colInfo);
				loadData();
			}
		}); 	    
}

jQuery(document).ready(function(){
	<%if(firstStep){%>
		window.setTimeout(function(){
			hiddenRCMenuItem(1);
			hiddenRCMenuItem(2);
			hiddenRCMenuItem(3);
		},500);
	<%}%>
	getGridInfo();
});
</script>

<%
//displayUsage==1||isShow.equalsIgnoreCase("false")
if(true){
	%>
	<script language='javascript' type='text/javascript' src='/js/xmlextras_wev8.js'></script>
	<script language='javascript' type='text/javascript' src='/js/weaverTable_wev8.js'></script>
	<script language='javascript' type='text/javascript' src='/js/ArrayList_wev8.js'></script>
	<script type="text/javascript">
		
		 var _xtable_checkedList = new ArrayList();
	     var _xtalbe_checkedValueList = new ArrayList();
	     var _xtalbe_radiocheckId =""; 
	     var _xtalbe_radiocheckValue = "";
	     var _table;
	     function loadData(){
	     	var isShowThumbnail = "";
		     _table = new weaverTable('/weaver/weaver.common.util.taglib.SplitPageXmlServlet',0, '',
		     sessionId,
			 'run',
			 '',
			 tableInfo,
			 '',
			 '',
			 '',
			 isShowThumbnail,
			 '5',
			 '',
			 '');
			 var showTableDiv  = document.getElementById('_xTable');
			 jQuery(showTableDiv).children().remove();
		     showTableDiv.appendChild(_table.create());
		     //提示窗口
		     var message_table_Div = document.createElement("div")
		     message_table_Div.id="message_table_Div";
		     message_table_Div.className="xTable_message"; 
		     showTableDiv.appendChild(message_table_Div); 
		     var message_table_Div  = document.getElementById("message_table_Div"); 
		     message_table_Div.style.display=""; 
		     /*if (readCookie("languageidweaver")==8){        
		     	message_table_Div.innerHTML="Executing...."; 
		     } else {        
				message_table_Div.innerHTML="服务器正在处理,请稍等...."; 
		     } */
			 message_table_Div.innerHTML = SystemEnv.getHtmlNoteName(3403,readCookie("languageidweaver"));
		     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;   
		     var pLeft= document.body.offsetWidth/2-50;   
		     message_table_Div.style.position="absolute"
		    jQuery(message_table_Div).css({
				"top":pTop,
				"left":pLeft,
				"position":"absolute"
			 }).show();
	     }
	</script>
	
	<%
} %>


</script>


<script type="text/javascript">

 function onShowResource(tdname,inputename){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	if(results){
	  if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	     jQuery($GetEle(tdname)).html("<a href='javascript:openhrm("+wuiUtil.getJsonValueByIndex(results,0)+")'>"+wuiUtil.getJsonValueByIndex(results,1)+"</a>");
	     //alert(wuiUtil.getJsonValueByIndex(results,0))
	     jQuery("input[name='"+inputename+"']")[0].value=wuiUtil.getJsonValueByIndex(results,0);
	     $GetEle("usertype").value="1";
	     $GetEle("ownerid2span").innerHTML="";
	     $GetEle("ownerid2").value="";
	     $GetEle("doccreaterid2span").innerHTML="";
	     $GetEle("doccreaterid2").value="";
	  }else{
	     jQuery($GetEle(tdname)).html("");
	     jQuery("input[name='"+inputename+"']").val("");
	     jQuery($GetEle("usertype")).val("");
	  }
	}
}

function afterShowResource(e,data,name){
	if(data){
		if(data.id!=""){
			$GetEle("usertype").value="1";
		     $GetEle("ownerid2span").innerHTML="";
		     $GetEle("ownerid2").value="";
		     $GetEle("doccreaterid2span").innerHTML="";
		     $GetEle("doccreaterid2").value="";
		}else{
			jQuery($GetEle("usertype")).val("");
		}
	}
}

function onShowParent(tdname,inputename){
   var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp");
   if((results)){
      if(wuiUtil.getJsonValueByIndex(results,0)!=""){
       jQuery($GetEle(tdname)).html("<a href='#"+wuiUtil.getJsonValueByIndex(results,0)+"'>"+wuiUtil.getJsonValueByIndex(results,1))+"</a>";
       jQuery("input[name='"+inputename+"']")[0].value=wuiUtil.getJsonValueByIndex(results,0);
       $GetEle("usertype").value="2";
       
       $GetEle("owneridspan").innerHTML="";
       jQuery("input[name='ownerid']")[0].value="";
	   
	   $GetEle("doccreateridspan").innerHTML="";
	   $GetEle("doccreaterid").value="";
	  }else{
	   jQuery($GetEle(tdname)).html("");
	   $GetEle(inputename).value="";
	   $GetEle("usertype").value="";
	  }
   }
}

function afterShowParent(e,data,name){
	if(data){
		if(data.id!=""){
			$GetEle("usertype").value="2";
	       $GetEle("owneridspan").innerHTML="";
	       jQuery("input[name='ownerid']")[0].value="";
		   
		   $GetEle("doccreateridspan").innerHTML="";
		   $GetEle("doccreaterid").value="";
		}else{
			jQuery($GetEle("usertype")).val("");
		}
	}
}

function onShowDept(tdname,inputename){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+$GetEle(inputename).value);
	if(results){
	  if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	     jQuery($GetEle(tdname)).html("<a href='#"+wuiUtil.getJsonValueByIndex(results,0)+"'>"+wuiUtil.getJsonValueByIndex(results,1)+"</a>");
         $GetEle(inputename).value=wuiUtil.getJsonValueByIndex(results,0);
	  }else{
	     jQuery($GetEle(tdname)).html("");
         $GetEle(inputename).value="";
	  }
	}
}

function onShowSubcompany(tdname,inputename){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="+$GetEle(inputename).value);
	if(results){
	  if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	     jQuery($GetEle(tdname)).html("<a href='#"+wuiUtil.getJsonValueByIndex(results,0)+"'>"+wuiUtil.getJsonValueByIndex(results,1)+"</a>");
         $GetEle(inputename).value=wuiUtil.getJsonValueByIndex(results,0);
	  }else{
	     jQuery($GetEle(tdname)).html("");
         $GetEle(inputename).value="";
	  }
	}
}

function onShowLanguage(span,id){
	if(!span)span = "languagespan";
	if(!id)id = "doclangurage";
	var results = window.showModalDialog("/systeminfo/language/LanguageBrowser.jsp");
	if(results){
	  if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	     jQuery($GetEle(span)).html("<a href='#"+wuiUtil.getJsonValueByIndex(results,0)+"'>"+wuiUtil.getJsonValueByIndex(results,1)+"</a>");
         $GetEle(id).value=wuiUtil.getJsonValueByIndex(results,0);
	  }else{
	     jQuery($GetEle(span)).html("");
         $GetEle(id).value="";
	  }
	}
}

function onShowItemCategory(tdname,inputename){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssortmentBrowserAll.jsp");
	if(results){
	   if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	     jQuery($GetEle(tdname)).html(wuiUtil.getJsonValueByIndex(results,1));
         $GetEle(inputename).value=wuiUtil.getJsonValueByIndex(results,0);
	  }else{
	     jQuery($GetEle(tdname)).html("");
         $GetEle(inputename).value="";
	  }
	}
}

function onShowCustomer(tdname,inputename){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp");
	if(results){
	   if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	     jQuery($GetEle(tdname)).html(wuiUtil.getJsonValueByIndex(results,1));
         $GetEle(inputename).value=wuiUtil.getJsonValueByIndex(results,0);
	  }else{
	     jQuery($GetEle(tdname)).html("");
         $GetEle(inputename).value="";
	  }
	}
}

function onShowCpt(tdname,inputename){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp");
	if(results){
	   if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	     jQuery($GetEle(tdname)).html(wuiUtil.getJsonValueByIndex(results,1));
         $GetEle(inputename).value=wuiUtil.getJsonValueByIndex(results,0);
	  }else{
	     jQuery($GetEle(tdname)).html("");
         $GetEle(inputename).value="";
	  }
	}
}

function onShowProject(tdname,inputename){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp");
	if(results){
	   if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	     jQuery($GetEle(tdname)).html("<a href='#"+wuiUtil.getJsonValueByIndex(results,0)+"'>"+wuiUtil.getJsonValueByIndex(results,1))+"</a>";
         $GetEle(inputename).value=wuiUtil.getJsonValueByIndex(results,0);
	  }else{
	     jQuery($GetEle(tdname)).html("");
         $GetEle(inputename).value="";
	  }
	}
}

function onShowMutiDummy1(input,span){	
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para="+$GetEle(input).value);
	if(results){
	   if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	     var dummyidArray=wuiUtil.getJsonValueByIndex(results,0).split(",");
	     var dummynames=wuiUtil.getJsonValueByIndex(results,1).split(",");
	     var sHtml="";
	     for(var i=0;i<dummyidArray.length;i++){
	        if(dummyidArray[i]!=""){
	           //sHtml = sHtml+"<a href='/docs/docdummy/DocDummyList.jsp?dummyId="+dummyidArray[i]+"'>"+dummynames[i]+"</a>&nbsp";
	           sHtml = sHtml+"<a href='#"+dummyidArray[i]+"'>"+dummynames[i]+"</a>&nbsp";
	        }
	     }
	   
	     jQuery($GetEle(span)).html(sHtml);
         $GetEle(input).value=wuiUtil.getJsonValueByIndex(results,0);
	  }else{
	     jQuery($GetEle(span)).html("");
         $GetEle(input).value="";
	  }
	
	}
}
function onShowBrowser1(id,url,type1){
	if(type1==1){
		id1 = window.showModalDialog(url,"","dialogHeight:320px;dialogwidth:275px");
		$GetEle("con"+id+"_valuespan").innerHTML=id1;
    	$GetEle("con"+id+"_value").value=id1;
     }else if(type1==2){
    	id1 = window.showModalDialog(url,"","dialogHeight:320px;dialogwidth:275px");
 		$GetEle("con"+id+"_value1span").innerHTML=id1;
     	$GetEle("con"+id+"_value1").value=id1;
     }
}
function onShowBrowser(id,url){
	datas = window.showModalDialog(url+"?selectedids="+$GetEle("con"+id+"_value").value);
	if (datas) {
        if (datas.id!=""){
        	$GetEle("con"+id+"_valuespan").innerHTML=datas.name;
        	$GetEle("con"+id+"_value").value=datas.id;
        	$GetEle("con"+id+"_name").value=datas.name;
        }
		else{
			$GetEle("con"+id+"_valuespan").innerHTML="";
        	$GetEle("con"+id+"_value").value="";
        	$GetEle("con"+id+"_name").value="";
		}
	}
}
function onShowDepartment(id,url){
	datas = window.showModalDialog(url+"?selectedDepartmentIds="+$GetEle("con"+id+"_value").value);
	if (datas) {
        if (datas.id!=""){
            var shtml="";
            if(datas.name.indexOf(",")!=-1){
                 var namearray =datas.name.substr(1).split(",");
                 for(var i=0;i<namearray.length;i++){
                	 shtml +=namearray[i]+" ";
                 }
            }
        	$GetEle("con"+id+"_valuespan").innerHTML=shtml;
        	$GetEle("con"+id+"_value").value=datas.id;
        	$GetEle("con"+id+"_name").value=datas.name;
        }
		else{
			$GetEle("con"+id+"_valuespan").innerHTML="";
        	$GetEle("con"+id+"_value").value="";
        	$GetEle("con"+id+"_name").value="";
		}
	}
}


function onShowBrowserCommon(id,url,type1){

		if(type1==162){
			tmpids = $GetEle("con"+id+"_value").value;
			url = url + "&beanids=" + tmpids;
			url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));

		}
		id1 = window.showModalDialog(url);

		if(id1){

				if(id1.id!=0 && id1.id!=""){

	               if (type1 == 162) {
				   		var ids = id1.id;
						var names =  id1.name;
						var descs =  id1.key3;
						shtml = ""
						ids = ids.substr(1);
						$GetEle("con"+id+"_value").value=ids;
						
						names = names.substr(1);
						descs = descs.substr(1);
						var idArray = ids.split(",");
						var nameArray = names.split(",");
						var descArray = descs.split(",");
						for (var _i=0; _i<idArray.length; _i++) {
							var curid = idArray[_i];
							var curname = nameArray[_i];
							var curdesc = descArray[_i];
							shtml += "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
						}
						
						$GetEle("con"+id+"_valuespan").innerHTML=shtml;

						return;
	               }
				   if (type1 == 161) {
					   	var ids = id1.id;
					   	var names = id1.name;
						var descs =  id1.desc;
						$GetEle("con"+id+"_value").value=ids;
						shtml = "<a title='" + descs + "'>" + names + "</a>&nbsp";
						$GetEle("con"+id+"_valuespan").innerHTML=shtml;
						return ;
				   }


				}else{
						$GetEle("con"+id+"_valuespan").innerHTML="";
						$GetEle("con"+id+"_value").value="";
						$GetEle("con"+id+"_name").value="";
				}

			}

}
 
</script>
<%} %>

<%! 
private String getFilterBackFields(String oldbf,String addedbfs){
    String[] bfs = Util.TokenizerString2(addedbfs,",");
    String bf = "";
    for(int i=0;bfs!=null&&bfs.length>0&&i<bfs.length;i++){
        bf = bfs[i];
        if(oldbf.indexOf(","+bf+",")==-1){
            if(oldbf.endsWith(",")) oldbf+=bf+",";
            else oldbf+=","+bf+",";
        }
    }
    return oldbf;
}
%>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>