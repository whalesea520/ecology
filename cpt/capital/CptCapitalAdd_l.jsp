<%@page import="weaver.cpt.util.html.HtmlElement"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="weaver.cpt.util.CptFieldComInfo"%>
<%@page import="org.json.JSONObject"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<% if(!(user.getLogintype()).equals("1")) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<% 
//modify under popedom by dongping for TD559
if(!HrmUserVarify.checkUserRight("Capital:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CptFieldManager" class="weaver.cpt.util.CptFieldManager" scope="page" />
<jsp:useBean id="CptFieldComInfo" class="weaver.cpt.util.CptFieldComInfo" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page" />
<jsp:useBean id="CodeUtil" class="weaver.proj.util.CodeUtil" scope="page" />
<jsp:useBean id="CptCardGroupComInfo" class="weaver.cpt.util.CptCardGroupComInfo" scope="page" />
<%
String codeuse=CodeUtil.getCptData1CodeUse();

String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String assortmentid = Util.null2String(request.getParameter("assortmentid"));
boolean cptdetach="1".equals( ManageDetachComInfo.getCptdetachable());
String lme = Util.null2String(request.getParameter("lme"));
%>
<HTML><HEAD>
<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<link href="/proj/js/colortip-1.0/colortip-1.0-jquery_wev8.css" rel="stylesheet" type="text/css" />
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlers_wev8.js"></script>

<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script>
<script type="text/javascript">
var parentWin;
if("<%=isDialog %>"=="1"){
	parentWin = parent.parent.getParentWindow(parent.window);
	var parentDialog = parent.parent.getDialog(parent);
}
if("<%=isclose%>"=="1"){
	try{
		parentWin = parent.parent.getParentWindow(parent.window);
		parentWin.closeDialog();
		parentWin._table.reLoad();
		parentWin.refreshLeftTree();
	}catch(e){}
		
}
if("<%=lme%>"=="false"){
	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("81855",user.getLanguage())%><%=SystemEnv.getHtmlLabelNames("1321",user.getLanguage())%>"
		+"<%=SystemEnv.getHtmlLabelNames("23181",user.getLanguage())%><%=SystemEnv.getHtmlLabelNames("27515",user.getLanguage())%><%=SystemEnv.getHtmlLabelNames("33466",user.getLanguage())%>，"
		+"<%=SystemEnv.getHtmlLabelNames("83638",user.getLanguage())%><%=SystemEnv.getHtmlLabelNames("199",user.getLanguage())%><%=SystemEnv.getHtmlLabelNames("19381",user.getLanguage())%>");
}
</script>


<style type="text/css">
.InputStyle{width:30%!important;}
.inputstyle{width:30%!important;}
.Inputstyle{width:30%!important;}
.inputStyle{width:30%!important;}
.e8_os{width:30%!important;}
select.InputStyle{width:10%!important;} 
select.inputstyle{width:10%!important;} 
select.inputStyle{width:10%!important;} 
select.Inputstyle{width:10%!important;} 
textarea.InputStyle{width:70%!important;} 
</style>

</HEAD>
<%
Calendar today = Calendar.getInstance();
	String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

boolean hasFF = true;
/*缺省币种*/
String defcurrenyid ="";
RecordSet.executeProc("FnaCurrency_SelectByDefault","");
if(RecordSet.next()){
 defcurrenyid = RecordSet.getString(1);
}
RecordSet.executeProc("Base_FreeField_Select","cp");
if(RecordSet.getCounts()<=0)
	hasFF = false;
else
	RecordSet.first();
	
int blongsubcompany = Util.getIntValue(request.getParameter("blongsubcompany"));//所属分部
String nameQuery = Util.null2String(request.getParameter("nameQuery"));
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(1509,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:submitData(this),_TOP} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM name=frmain id=frmain action="CptCapitalOperation.jsp" method=post enctype="multipart/form-data" >
<input type=hidden name=operation value="addcapital">

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName( 615 ,user.getLanguage()) %>" class="e8_btn_top"  onclick="submitData(this)"/>
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>		
<div class="advancedSearchDiv" id="advancedSearchDiv" ></div>

<%
//资产组有效性验证
String validatedAssortmentid="";
String validatedAssortmentname="";
if( Util.getIntValue( CapitalAssortmentComInfo.getSubAssortmentCount(assortmentid))<=0){
	validatedAssortmentid=assortmentid;
	validatedAssortmentname=CapitalAssortmentComInfo.getAssortmentName(assortmentid);
}

int fieldcount=0;//用来定位插图片
String needHideField=",";//用来隐藏字段
boolean dataornot=true;
if(dataornot){//资产资料
	needHideField+="isinner,barcode,fnamark,stateid,blongdepartment,departmentid,capitalnum,startdate,enddate,manudate,stockindate,location,selectdate,contractno,invoice,deprestartdate,usedyear,currentprice,alertnum,";
}
//必填字段控制
String[]mandStr= Util.TokenizerString2(CptFieldComInfo.getMandFieldStr(),",") ;
String checkStr="";
if(mandStr!=null&&mandStr.length>0){
	for(int i=0;i<mandStr.length;i++){
		if(mandStr[i].equals("mark")){
			continue;
		}
		if(dataornot){
			if((","+needHideField).indexOf(","+mandStr[i]+",")>=0){
				continue;
			}
		}
		checkStr+=mandStr[i]+",";
	}
}

%>

<wea:layout  attributes="{'expandAllGroup':'true'}">
<%


TreeMap<String,TreeMap<String,JSONObject>> groupFieldMap=CptFieldComInfo.getGroupFieldMap();
CptCardGroupComInfo.setTofirstRow();
while(CptCardGroupComInfo.next()){
	String groupid=CptCardGroupComInfo.getGroupid();
	TreeMap<String,JSONObject> openfieldMap= groupFieldMap.get(groupid);
	if(openfieldMap==null||openfieldMap.size()==0){
		continue;
	}
	int grouplabel=Util.getIntValue( CptCardGroupComInfo.getLabel(),-1);
	
	%>
<wea:group context='<%=SystemEnv.getHtmlLabelName(grouplabel,user.getLanguage())%>'>	
<%
if(!openfieldMap.isEmpty()){
	Iterator it=openfieldMap.entrySet().iterator();
	while(it.hasNext()){
		Entry<String,JSONObject> entry=(Entry<String,JSONObject>)it.next();
		String k= entry.getKey();
		JSONObject v=new JSONObject(((JSONObject)entry.getValue()).toString());
		int fieldlabel=v.getInt("fieldlabel");
		String fieldName=v.getString("fieldname");
		String fieldValue="";
		String hideField="{}";
		if(needHideField.indexOf(","+fieldName+",")!=-1){
			hideField="{'samePair':'hideField'}";
		}
		if("resourceid".equals( fieldName)&&dataornot){
			fieldlabel=1507;
		}else if("mark".equals(fieldName)&&!"2".equals(codeuse)){//非手动编码
			continue;
		}else if("capitalgroupid".equals(fieldName)){//自动带资产组
			fieldValue=validatedAssortmentid;
		}else if("currencyid".equals(fieldName)){   //默认的币种
			fieldValue = defcurrenyid;
		}
		
		fieldcount++;
		
	%>
	<wea:item attributes='<%=hideField %>'><%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%></wea:item>
	<wea:item attributes='<%=hideField %>'>
		<%=((HtmlElement)Class.forName(v.getString("eleclazzname")).newInstance()).getHtmlElementString(fieldValue, v, user) %>
		<%
		if("deprerate".equals(fieldName)){
			%>
			%
			<%
		}
		%>
	</wea:item>
	<%
	if(fieldcount==1 ){
	%>
	<wea:item><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></wea:item>
	<wea:item>
		<input type="file" name="capitalimage" class="InputStyle">
	</wea:item>
	<%
	}
	%>
	
	<%
	}
}

%>
</wea:group>
	<%
}
%>

	
</wea:layout>

<div style="height:100px!important;"></div>

</FORM>
<table id="remindtbl" class=ReportStyle style="display:none;">
<TBODY>
<TR><TD>
<%=SystemEnv.getHtmlLabelName(21777,user.getLanguage())%>
<%=SystemEnv.getHtmlLabelName(21769,user.getLanguage())%><br>     
<%=SystemEnv.getHtmlLabelName(21770,user.getLanguage())%>
<%=SystemEnv.getHtmlLabelName(21771,user.getLanguage())%>
<%=SystemEnv.getHtmlLabelName(21772,user.getLanguage())%><br>
<%=SystemEnv.getHtmlLabelName(21773,user.getLanguage())%>
<%=SystemEnv.getHtmlLabelName(21774,user.getLanguage())%>
</TD>
</TR>
</TBODY>
</table>
<script language="javascript">


function checkinputnumber(obj){
	
	valuechar = obj.value.split("");
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { 
	    charnumber = parseInt(valuechar[i]) ; 
	    if( isNaN(charnumber)&& valuechar[i]!="." && valuechar[i]!="-") 
	    isnumber = true ;
	}
	if(isnumber) obj.value="";
}

  
function submitData(obj){
	var checkstr='<%=checkStr %>';
	if("<%=codeuse %>"=="2"){
		checkstr+=",mark";
	}
	if (check_form($GetEle("frmain"),checkstr)){
		obj.disabled = true;
		
		var mark = $("#mark").val();
		if(!(mark==undefined)){	
			mark =mark.toString().trim();
		}
		jQuery.ajax({
		url : "CptCapitalOperation.jsp",
		type : "post",
		async : true,
		processData : true,
		data : {"operation":"checkmark","mark":mark,"isdata":"1","codeuse":"<%=codeuse %>"},
		dataType : "json",
		success: function do4Success(data){
				if(data.msg=="true"){
					$GetEle("frmain").submit();
				}else{
					obj.disabled = false;
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("714",user.getLanguage())%>"+"<%=SystemEnv.getHtmlLabelNames("18082",user.getLanguage())%>");
					return;
				}
			}
		});
	}
}
</script>


<%
if("1".equals(isDialog)){
	%>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentDialog.closeByHand();"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout>
</div>	
	
	<%
}
%>

<script type="text/javascript" src="/proj/js/colortip-1.0/colortip-1.0-jquery_wev8.js"></script>
<script type="text/javascript">	
$(function(){
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelName( 1509 ,user.getLanguage()) %>");
		var remindimg="<a name='remindlink' href='javascript:void(0)' title='"+$("#remindtbl").text()+"'><img src='/wechat/images/remind_wev8.png' align='absMiddle'  /></a>";
		$("span.e8_grouptitle:contains('<%=SystemEnv.getHtmlLabelName( 1374 ,user.getLanguage()) %>')").append("&nbsp;&nbsp;&nbsp;&nbsp;").append(remindimg);
	}catch(e){}
	
	//$('a[name=remindlink][title]').colorTip({color:'yellow'});
	
	$("#deprerate").live("blur", function () { 
        var deprerate = $GetEle("deprerate").value;
		if(deprerate>100){
			$GetEle("deprerate").value = 100;
		}
      }); 
      
});
</script>
<script type="text/javascript">
jQuery(function(){
	hideEle('hideField');
});
</script>
</BODY>

<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>
<script type="text/javascript">
function onShowTime(spanname,inputname){
	var dads  = document.getElementById("meizzDateLayer2").style;
	setLastSelectTime(inputname);
	/*var th = spanname;
	var ttop  = spanname.offsetTop; 
	var thei  = spanname.clientHeight;
	var tleft = spanname.offsetLeft; 
	var ttyp  = spanname.type;       
	while (spanname = spanname.offsetParent){
		ttop += spanname.offsetTop; 
		tleft += spanname.offsetLeft;
	}*/
	
	var th = $ele4p(spanname);
	var ttop  = $ele4p(spanname).offsetTop; 
	var thei  = $ele4p(spanname).clientHeight;
	var tleft = $ele4p(spanname).offsetLeft; 
	var ttyp  = $ele4p(spanname).type;    
	while (spanname = $ele4p(spanname).offsetParent){
		ttop += $ele4p(spanname).offsetTop; 
		tleft += $ele4p(spanname).offsetLeft;
	}
	//dads.top  = ((ttyp == "image") ? ttop + thei : ttop + thei - 50)+"px";
	dads.top = (jQuery(th).offset().top+8)+"px";
	//dads.left = (tleft - 5)+"px";
	dads.left = jQuery(th).offset().left+"px";
	
	
	//dads.top  = ((ttyp == "image") ? ttop + thei : ttop + thei + 22)+"px";
	//dads.left = tleft+"px";
	outObject = th;
	outValue = inputname;
	outButton = (arguments.length == 1) ? null : th;
	dads.display = '';
	bShow = true;
}
</script>
</HTML>
