<%@page import="weaver.cpt.maintenance.CapitalTypeComInfo"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.proj.util.PropUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.formmode.cuspage.cpt.Cpt4modeUtil" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page" />
<jsp:useBean id="CapitalTypeComInfo" class="weaver.cpt.maintenance.CapitalTypeComInfo" scope="page" />
<%

if(!HrmUserVarify.checkUserRight("Cpt4Mode:AlarmSettings", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}


String modeid=Cpt4modeUtil.getModeid("zczl");
String modeformid=Cpt4modeUtil.getFormid(modeid);
String modesearchid=Cpt4modeUtil.getSearchid("zczlwh");

String from=Util.null2String(request.getParameter("from"));
String nameQuery = Util.null2String(request.getParameter("flowTitle"));
String capitalspec = Util.null2String(request.getParameter("capitalspec"));
String mark = Util.null2String(request.getParameter("mark"));
String fnamark = Util.null2String(request.getParameter("fnamark"));
String capitalgroupid = Util.null2String(request.getParameter("capitalgroupid"));
String blongsubcompany = Util.null2String(request.getParameter("blongsubcompany"));
String capitaltypeid = Util.null2String(request.getParameter("capitaltypeid"));


String sqlWhere=" where isdata='1'  ";
if(!"".equals(nameQuery)){
	sqlWhere+=" and name like '%"+nameQuery+"%' ";
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
//rs.executeSql("select cptdetachable from SystemSet");
//int detachable=0;
//
//if(rs.next()){
//	detachable=rs.getInt("cptdetachable");
//	session.setAttribute("cptdetachable",String.valueOf(detachable));
//}

int subcompanyid1 =Util.getIntValue( Util.null2String(request.getParameter("subcompanyid1")),0);//分权的分部id
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

if(subcompanyid1>0){
	sqlWhere += " and blongsubcompany="+subcompanyid1;
}



//权限条件 modify by ds Td:9699
String rightStr="Cpt4Mode:AlarmSettings";
//if(detachable == 1 && user.getUID()!=1){
//	int allsubids[] = CheckSubCompanyRight.getSubComByUserRightId(user.getUID(),rightStr);
//	String allsubid = "";
//	for(int i=0;i<allsubids.length;i++){
//		if(allsubids[i]>0){
//			allsubid += (allsubid.equals("")?"":",") + allsubids[i];
//		}
//	}
//	if(allsubid.equals("")) allsubid = user.getUserSubCompany1() + "";
//	if(!"".equals(allsubid)){//角色设置的权限
//		sqlWhere += " and blongsubcompany in ("+allsubid+") ";
//	}else{
//		sqlWhere += " and blongsubcompany in ("+allsubid+") ";
//	}
//}
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
String titlename = SystemEnv.getHtmlLabelName(125633,user.getLanguage());
String needfav ="1";
String needhelp ="";
String needcheck="";
int rownum=1;

String pageId=Util.null2String(PropUtil.getPageId("mode4cpt_cptalertnumconf"));
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

<FORM id=frmain name=frmain method=post action="/formmode/cuspage/cpt/conf/cptalertnumconftab.jsp"    >
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
		    <wea:item><input type=text name=flowTitle class=InputStyle value='<%=nameQuery %>'></wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></wea:item>
		    <wea:item><input type=text name=mark class=InputStyle value='<%=mark %>'></wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(904,user.getLanguage())%></wea:item>
		    <wea:item><input type=text name=capitalspec class=InputStyle value='<%=capitalspec %>'></wea:item>
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
	    		<input class="zd_btn_cancle" type="reset" name="reset" value="<%=SystemEnv.getHtmlLabelNames("2022",user.getLanguage())%>"/>
	    		<input class="zd_btn_cancle" type="button" name="cancel" id="cancel" value="<%=SystemEnv.getHtmlLabelNames("201",user.getLanguage())%>"  />
	    	</wea:item>
	    </wea:group>
	</wea:layout>
</div>


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
String backfields = " id,name,mark,capitalspec,fnamark,capitalgroupid,capitaltypeid,blongsubcompany,unitid,capitalnum,alarm_lownum,alarm_highnum,alarm_dulldays ";
String fromSql  = " uf_cptcapital ";
String cpturl="/formmode/view/AddFormMode.jsp?type=0%26modeId="+ modeid+"%26formId="+modeformid+"%26opentype=0%26customid="+modesearchid+"%26viewfrom=fromsearchlist%26mainid=0";
tableString =   " <table  pageId=\""+pageId+"\"  instanceid=\"CptCapitalAssortmentTable\" tabletype=\"checkbox\"  pagesize=\""+PageIdConst.getPageSize(pageId,user.getUID(),"cpt")+"\"  >"+
				" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod='weaver.cpt.util.CapitalTransUtil.getCanDelCptAssortmentShare'  />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"desc\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName( 195 ,user.getLanguage())+"\" column=\"name\" linkvaluecolumn=\"id\"  linkkey=\"billid\" href=\""+cpturl+"\" target=\"_fullwindow\" />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName( 714 ,user.getLanguage())+"\" column=\"mark\"  />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName( 904 ,user.getLanguage())+"\" column=\"capitalspec\"  />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName( 831 ,user.getLanguage())+"\" column=\"capitalgroupid\" otherpara='capitalgroupid' transmethod='weaver.formmode.cuspage.cpt.util.Mode4CptTransUtil.getTransName'  />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName( 703 ,user.getLanguage())+"\" column=\"capitaltypeid\" otherpara='capitaltypeid' transmethod='weaver.formmode.cuspage.cpt.util.Mode4CptTransUtil.getTransName'  />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(  19799  ,user.getLanguage())+"\" column=\"blongsubcompany\" transmethod='weaver.hrm.company.SubCompanyComInfo.getSubCompanyname'  />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(  705  ,user.getLanguage())+"\" column=\"unitid\" otherpara='unitid' transmethod='weaver.formmode.cuspage.cpt.util.Mode4CptTransUtil.getTransName' />"+
		"           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(  125636  ,user.getLanguage())+"\" column=\"alarm_lownum\" otherpara='column:id+alarm_lownum' transmethod='weaver.formmode.cuspage.cpt.util.Mode4CptTransUtil.getAlertnumInput' />"+
		"           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(  125637  ,user.getLanguage())+"\" column=\"alarm_highnum\" otherpara='column:id+alarm_highnum' transmethod='weaver.formmode.cuspage.cpt.util.Mode4CptTransUtil.getAlertnumInput' />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(  125638  ,user.getLanguage())+"\" column=\"alarm_dulldays\" otherpara='column:id+alarm_dulldays' transmethod='weaver.formmode.cuspage.cpt.util.Mode4CptTransUtil.getAlertnumInput' />"+
                "       </head>"+
                " </table>";
%>

</form>
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />

<script language="javascript">
function onBtnSearchClick(){
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
			parent.setTabObjName("<%=SystemEnv.getHtmlLabelName(125633,user.getLanguage()) %>");
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
		var url = "/formmode/cuspage/cpt/conf/cptalertnumbatchset.jsp?isdialog=1&capitalids="+ids;
		var title="<%=SystemEnv.getHtmlLabelName(33511,user.getLanguage()) %>";
		openDialog(url,title,500,290);
		
	}
}
function doSave(){
	var table=$("#_xTable");
	var objArr1=[];
	var objArr2=[];
	var objArr3=[];
	table.find("input[name=alarm_lownum]").each(function(){
		var obj={'cptid':$(this).attr("cptid"),'alertnum':$(this).val()};
		objArr1.push(obj);
	});
	table.find("input[name=alarm_highnum]").each(function(){
		var obj={'cptid':$(this).attr("cptid"),'alertnum':$(this).val()};
		objArr2.push(obj);
	});
	table.find("input[name=alarm_dulldays]").each(function(){
		var obj={'cptid':$(this).attr("cptid"),'alertnum':$(this).val()};
		objArr3.push(obj);
	});

	if(objArr1.length>0||objArr2.length>0||objArr3.length>0){
		$.ajax({
			url : "/formmode/cuspage/cpt/conf/cptalertnumconfop.jsp?method=dosave",
			type : "post",
			async : true,
			data : "alarm_lownum="+JSON.stringify(objArr1)+"&alarm_highnum="+JSON.stringify(objArr2)+"&alarm_dulldays="+JSON.stringify(objArr3),
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

