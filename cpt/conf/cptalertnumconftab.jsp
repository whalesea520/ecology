<%@page import="weaver.cpt.maintenance.CapitalTypeComInfo"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.proj.util.PropUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page" />
<jsp:useBean id="CapitalTypeComInfo" class="weaver.cpt.maintenance.CapitalTypeComInfo" scope="page" />
<%

if(!HrmUserVarify.checkUserRight("CptCapital:modify", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

String from=Util.null2String(request.getParameter("from"));
String nameQuery = Util.null2String(request.getParameter("flowTitle"));
String nameQuery1 = Util.null2String(request.getParameter("flowTitle1"));
String capitalspec = Util.null2String(request.getParameter("capitalspec"));
String mark = Util.null2String(request.getParameter("mark"));
String fnamark = Util.null2String(request.getParameter("fnamark"));
String capitalgroupid = Util.null2String(request.getParameter("capitalgroupid"));
String blongsubcompany = Util.null2String(request.getParameter("blongsubcompany"));
String capitaltypeid = Util.null2String(request.getParameter("capitaltypeid"));

String sqlWhere=" where isdata='2' and ( sptcount is null or sptcount !=1) ";
if(!"".equals(nameQuery)){
	sqlWhere+=" and name like '%"+nameQuery+"%' ";
}
if(!"".equals(nameQuery1)){
	sqlWhere+=" and name like '%"+nameQuery1+"%' ";
}
if(!"".equals(capitalspec)){
	sqlWhere+=" and capitalspec like '%"+capitalspec+"%' ";
}
if(!"".equals(mark)){
	sqlWhere+=" and mark like '%"+mark+"%' ";
}
if(!"".equals(fnamark)){
	sqlWhere+=" and fnamark like '%"+fnamark+"%' ";
}
if(!"".equals(capitalgroupid)){
	sqlWhere+=" and capitalgroupid='"+capitalgroupid+"' ";
}
if(!"".equals(blongsubcompany)){
	sqlWhere+=" and blongsubcompany='"+blongsubcompany+"' ";
}
if(!"".equals(capitaltypeid)){
	sqlWhere+=" and capitaltypeid='"+capitaltypeid+"' ";
}


//是否分权系统，如不是，则不显示框架，直接转向到列表页面
rs.executeSql("select cptdetachable from SystemSet");
int detachable=0;

if(rs.next()){
	detachable=rs.getInt("cptdetachable");
	session.setAttribute("cptdetachable",String.valueOf(detachable));
}

int subcompanyid1 =Util.getIntValue( Util.null2String(request.getParameter("subcompanyid1")),0);//分权的分部id
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

if(subcompanyid1>0){
	sqlWhere += " and blongsubcompany="+subcompanyid1;
}



//权限条件 modify by ds Td:9699
String rightStr="CptCapital:modify";
if(detachable == 1 && user.getUID()!=1){
	int allsubids[] = CheckSubCompanyRight.getSubComByUserRightId(user.getUID(),rightStr);
	String allsubid = "";
	for(int i=0;i<allsubids.length;i++){
		if(allsubids[i]>0){
			allsubid += (allsubid.equals("")?"":",") + allsubids[i];
		}	
	}
	if(allsubid.equals("")) allsubid = user.getUserSubCompany1() + "";
	if(!"".equals(allsubid)){//角色设置的权限
		sqlWhere += " and blongsubcompany in ("+allsubid+") ";
	}else{
		sqlWhere += " and blongsubcompany in ("+allsubid+") ";
	}
}
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/cpt/js/common_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<link type="text/css" href="/js/ecology8/base/jquery-ui_wev8.css" rel=stylesheet>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82855,user.getLanguage());
String needfav ="1";
String needhelp ="";
String needcheck="";
int rownum=1;

String pageId=Util.null2String(PropUtil.getPageId("cpt_cptalertnumconf"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(33511,user.getLanguage())+",javascript:batchSet(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=frmain name=frmain method=post action="/cpt/conf/cptalertnumconftab.jsp"    >
<input type="hidden" name="pageId" id="pageId" value="<%=pageId  %>" />
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" class="e8_btn_top"  onclick="doSave()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(33511,user.getLanguage()) %>" class="e8_btn_top" onclick="batchSet()"/>
			<input type="text" class="searchInput" name="flowTitle" value="<%=nameQuery %>" />
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>		
<div class="advancedSearchDiv" id="advancedSearchDiv">
	<wea:layout type="4col">
	    <wea:group context='<%=SystemEnv.getHtmlLabelNames("15774",user.getLanguage())%>'>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		    <wea:item><input type=text name=flowTitle1 class=InputStyle value='<%=nameQuery1 %>'></wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></wea:item>
		    <wea:item><input type=text name=mark class=InputStyle value='<%=mark %>'></wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(904,user.getLanguage())%></wea:item>
		    <wea:item><input type=text name=capitalspec class=InputStyle value='<%=capitalspec %>'></wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(15293,user.getLanguage())%></wea:item>
		    <wea:item><input type=text name=fnamark class=InputStyle value='<%=fnamark %>'></wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(831,user.getLanguage())%></wea:item>
		    <wea:item>
		    	<brow:browser viewType="0" name="capitalgroupid" 
					browserValue='<%=capitalgroupid %>' browserSpanValue='<%=CapitalAssortmentComInfo.getAssortmentName(capitalgroupid ) %>' 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=25" />
		    </wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(703,user.getLanguage())%></wea:item>
		    <wea:item>
			    <brow:browser viewType="0" name="capitaltypeid" 
						browserValue='<%=capitaltypeid %>' browserSpanValue='<%=CapitalTypeComInfo.getCapitalTypename(capitaltypeid ) %>' 
						browserUrl="/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalTypeBrowser.jsp"
						hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
						completeUrl="/data.jsp?type=242" />
		    </wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%></wea:item>
		    <wea:item>
		    	<brow:browser viewType="0" name="blongsubcompany" 
					browserValue='<%=blongsubcompany %>' browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(blongsubcompany ) %>' 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=164" />
		    </wea:item>
	    </wea:group>
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input class="zd_btn_submit" type="submit" name="submit1" value="<%=SystemEnv.getHtmlLabelNames("197",user.getLanguage())%>"/>
	    		<input class="zd_btn_cancle" type="button" name="reset" onclick="resetForm();"  value="<%=SystemEnv.getHtmlLabelNames("2022",user.getLanguage())%>"/>
	    		<input class="zd_btn_cancle" type="button" name="cancel" id="cancel" value="<%=SystemEnv.getHtmlLabelNames("201",user.getLanguage())%>"  />
	    	</wea:item>
	    </wea:group>
	</wea:layout>
</div>
<script>
	var adName = $("input[name='flowTitle1']").eq(0);
	$("input[name='submit1']").eq(0).click(function(){
		var value = adName.val();
		$("input[name='flowTitle']").eq(0).val(value);
	});
	function resetForm(){
		var form= $("#frmain");
		//form.find("input[type='text']").val("");
		form.find(".e8_os").find("span.e8_showNameClass").remove();
		form.find(".e8_os").find("input[type='hidden']").val("");
		form.find("select[name!=mouldid]").selectbox("detach");
		form.find("select[name!=mouldid]").val("");
		//form.find("select[name!=mouldid]").trigger("change");
		form.find("span.jNiceCheckbox").removeClass("jNiceChecked");
		beautySelect(form.find("select[name!=mouldid]"));
		form.find(".calendar").siblings("span").html("");
		form.find(".calendar").siblings("input[type='hidden']").val("");
		form.find(".wuiDateSel").val("");
		form.find("input[name=flowTitle1]").val("");
		form.find("input[name=mark]").val("");
		form.find("input[name=capitalspec]").val("");
		form.find("input[name=fnamark]").val("");
	}
</script>

<%

String popedomOtherpara="";

//操作列参数
/**JSONObject operatorInfo=new JSONObject();
operatorInfo.put("userid", user.getUID());
operatorInfo.put("usertype", user.getLogintype());
operatorInfo.put("languageid", user.getLanguage());
operatorInfo.put("operatortype", "cpt_cptalertnum");//操作项类型
operatorInfo.put("operator_num", 5);//操作项数量
operatorInfo.put("operator_val", popedomOtherpara);**/



if(!"".equals(nameQuery)){
	sqlWhere+=" and name like '%"+nameQuery+"%'";
}


String orderby =" id ";
String tableString = "";
int perpage=10;                                 
String backfields = " id,name,mark,capitalspec,fnamark,capitalgroupid,capitaltypeid,blongsubcompany,unitid,capitalnum,alertnum ";
String fromSql  = " cptcapital ";

tableString =   " <table  pageId=\""+pageId+"\"  instanceid=\"CptCapitalAssortmentTable\" tabletype=\"checkbox\"  pagesize=\""+PageIdConst.getPageSize(pageId,user.getUID(),"cpt")+"\"  >"+
				" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod='weaver.cpt.util.CapitalTransUtil.getCanDelCptAssortmentShare'  />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"ASC\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName( 195 ,user.getLanguage())+"\" column=\"name\" linkvaluecolumn=\"id\"  linkkey=\"id\" href=\"/cpt/capital/CptCapital.jsp\" target=\"_fullwindow\" />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName( 714 ,user.getLanguage())+"\" column=\"mark\"  />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName( 904 ,user.getLanguage())+"\" column=\"capitalspec\"  />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName( 15293 ,user.getLanguage())+"\" column=\"fnamark\"  />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName( 831 ,user.getLanguage())+"\" column=\"capitalgroupid\" transmethod='weaver.cpt.maintenance.CapitalAssortmentComInfo.getAssortmentName'  />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName( 703 ,user.getLanguage())+"\" column=\"capitaltypeid\" transmethod='weaver.cpt.maintenance.CapitalTypeComInfo.getCapitalTypename'  />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(  19799  ,user.getLanguage())+"\" column=\"blongsubcompany\" transmethod='weaver.hrm.company.SubCompanyComInfo.getSubCompanyname'  />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(  705  ,user.getLanguage())+"\" column=\"unitid\" transmethod='weaver.lgc.maintenance.AssetUnitComInfo.getAssetUnitname' />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName( 1331 ,user.getLanguage())+"\" column=\"capitalnum\" otherpara='column:alertnum' transmethod='weaver.cpt.util.CapitalTransUtil.getWarningnum' />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(  15294  ,user.getLanguage())+"\" column=\"alertnum\" otherpara='column:id' transmethod='weaver.cpt.util.CapitalTransUtil.getAlertnumInput' />"+
                "       </head>"+
                " </table>";
%>

</form>
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />

<script language="javascript">
function onBtnSearchClick(){
	var value=$("input[name='flowTitle']",parent.document).val();
    $("input[name='flowTitle1']").val(value);
	$("#frmain").submit();
}
$(function(){
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
});

$(function(){
	var from='<%=from %>';
	var cptgroupname='<%=SubCompanyComInfo.getSubCompanyname(""+subcompanyid1) %>';
	try{
		if(cptgroupname!=""){
			parent.setTabObjName(cptgroupname);
		}else{
			parent.setTabObjName("<%=SystemEnv.getHtmlLabelName(82855,user.getLanguage()) %>");
		}
	}catch(e){}
});
function afterDoWhenLoaded(){
	
}
function batchSet(){
	var ids= _xtable_CheckedCheckboxId();
	if(ids==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82891,user.getLanguage()) %>");
	}else{
		var url = "/cpt/conf/cptalertnumbatchset.jsp?isdialog=1&capitalids="+ids;
		var title="<%=SystemEnv.getHtmlLabelName(33511,user.getLanguage()) %>";
		openDialog(url,title,500,290);
		
	}
}
function doSave(){
	var table=$("#_xTable");
	var objArr=[];
	table.find("input[name=alertnum]").each(function(){
		var obj={'cptid':$(this).attr("cptid"),'alertnum':$(this).val()};
		objArr.push(obj);
	});
	
	if(objArr.length>0){
		$.ajax({
			url : "/cpt/conf/cptalertnumconfop.jsp?method=dosave",
			type : "post",
			async : true,
			data : "cptalertinfo="+JSON.stringify(objArr),
			dataType : "json",
			success: function do4Success(msg){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("82933",user.getLanguage())%>");
				_table.reLoad();
			}
		});
	}
}
</script>

</BODY>
</HTML>

