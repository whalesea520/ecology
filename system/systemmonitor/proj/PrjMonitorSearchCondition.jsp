<%@page import="weaver.cpt.util.html.HtmlElement"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.util.*"%>
<%@page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CptFieldComInfo" class="weaver.proj.util.PrjFieldComInfo" scope="page"/>
<jsp:useBean id="CptFieldManager" class="weaver.proj.util.PrjFieldManager" scope="page"/>

<%
String needshowadv = Util.null2String(request.getParameter("needshowadv"));

String nameQuery = Util.null2String(request.getParameter("nameQuery"));
String method=Util.null2String(request.getParameter("method"));
int mouldid=Util.getIntValue(request.getParameter("mouldid"),0);	
%>



<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>

</HEAD>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(101,user.getLanguage());
String needfav ="1";
String needhelp ="";

int userid = user.getUID();


%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearch(),_top}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(2022,user.getLanguage())+",javascript:onReset(),_top}" ;
RCMenuHeight += RCMenuHeightStep ;


%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name="form2" id="form2" method="post"  action="ProjMonitorTab.jsp">
<input type="hidden" name="fromassortmenttab_name" value="<%=nameQuery %>" />
<input type="hidden" name="needshowadv" id="needshowadv" value="<%=needshowadv %>" />
<input type="hidden" name="src" value="prjmonitorsearchcondition" />
<input type="hidden" name="mouldname" value="" />
<input type="hidden" name="operation" value="" />

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input class="e8_btn_top" type="button" name="btn_search" value="<%=SystemEnv.getHtmlLabelNames("197",user.getLanguage())%>" onclick="onSearch();" />
			<input class="e8_btn_top" type="button" name="btn_reset" value="<%=SystemEnv.getHtmlLabelNames("2022",user.getLanguage())%>" onclick="$('input[name=reset]').trigger('click');" />
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv"></div>


<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("32905",user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelNames("1353",user.getLanguage())%></wea:item>
		<wea:item><input class="InputStyle" name="prjname" id="prjname" value=""></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("17852",user.getLanguage())%></wea:item>
		<wea:item><input class="InputStyle" name="procode" id="procode" value=""></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("586",user.getLanguage())%></wea:item>
    	<wea:item>
    		<select class="InputStyle" name='paraid' >
    			<option value="" ><%=SystemEnv.getHtmlLabelNames("332",user.getLanguage())%></option>
    		<%
             		while(ProjectTypeComInfo .next()){
             			String tmpid=ProjectTypeComInfo.getProjectTypeid ();
             			String tmpname=ProjectTypeComInfo.getProjectTypename ();
             		%>	
             		<option value="<%=tmpid %>"  ><%=tmpname %></option>
             		<%
             		}
             	%>
    		</select>
    		
    	</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(432,user.getLanguage())%></wea:item>
		<wea:item>
			<Select class="InputStyle" name="WorkType">
				<option value=""></option>
				<%while(WorkTypeComInfo.next()){%>
					<option value="<%=WorkTypeComInfo.getWorkTypeid()%>"><%=WorkTypeComInfo.getWorkTypename()%></option>
				<%}%>
			</Select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("783",user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="crm" 
				browserValue="" 
				browserSpanValue=""
				browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp?type=7"  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("83796",user.getLanguage())%></wea:item>
		<wea:item>
			<span class="wuiDateSpan" selectId="planbegindate_sel" selectValue="">
				  <input class=wuiDateSel type="hidden" name="planbegindate" value="">
				  <input class=wuiDateSel  type="hidden" name="planbegindate1" value="">
			</span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("22170",user.getLanguage())%></wea:item>
		<wea:item>
			<span class="wuiDateSpan" selectId="planendate_sel" selectValue="">
				  <input class=wuiDateSel type="hidden" name="planenddate" value="">
				  <input class=wuiDateSel  type="hidden" name="planenddate1" value="">
			</span>
		</wea:item>
		<wea:item>ID</wea:item>
		<wea:item><input class="InputStyle" name="prjid" id="prjid" value=""></wea:item>
	</wea:group>
	
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("27858",user.getLanguage())%>' attributes="{'samePair':'moreKeyWord','groupOperDisplay':'','groupDisplay':'','itemAreaDisplay':''}">	
		<wea:item><%=SystemEnv.getHtmlLabelName(587,user.getLanguage())%></wea:item>
		<wea:item>
			<Select class="InputStyle" name="prjstatus">
				<option value=""><%=SystemEnv.getHtmlLabelNames("332",user.getLanguage())%></option>
				<%while(ProjectStatusComInfo.next()){%>
					<option value="<%=ProjectStatusComInfo.getProjectStatusid ()%>"><%=ProjectStatusComInfo.getProjectStatusdesc ()%></option>
				<%}%>
			</Select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("636",user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="parentprj" 
				browserValue="" 
				browserSpanValue=""
				browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp?type=8"  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("847",user.getLanguage())%></wea:item>
		<wea:item>
			<input class=InputStyle style="width:60px!important;" maxlength=3 size=5 value="" name="finish" onkeypress="return event.keyCode>=4&&event.keyCode<=57">
			-<input class=InputStyle style="width:60px!important;" maxlength=3 size=5 value="" name="finish1" onkeypress="return event.keyCode>=4&&event.keyCode<=57">
			%
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelNames("16573",user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="manager" 
				browserValue="" 
				browserSpanValue=""
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp"  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("83797",user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="managerdept" 
				browserValue="" 
				browserSpanValue=""
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp?type=4"  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("83813",user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="managersubcom" 
				browserValue="" 
				browserSpanValue=""
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp?type=164"  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("18628",user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="member" 
				browserValue="" 
				browserSpanValue=""
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp"  />
		</wea:item>
	</wea:group>
	
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("16169",user.getLanguage())%>' attributes="{'samePair':'moreKeyWord','groupOperDisplay':''}">
<%
//cusfield
TreeMap<String,JSONObject> openfieldMap= CptFieldComInfo.getOpenFieldMap();
if(!openfieldMap.isEmpty()){
	Iterator it=openfieldMap.entrySet().iterator();
	while(it.hasNext()){
		Entry<String,JSONObject> entry=(Entry<String,JSONObject>)it.next();
		String k= entry.getKey();
		JSONObject v=new JSONObject(((JSONObject)entry.getValue()).toString());
		int fieldhtmltype= v.getInt("fieldhtmltype");
		if(fieldhtmltype==2||fieldhtmltype==6||fieldhtmltype==7){
			continue;
		}
		v.put("ismand", "0");//查询不用必填
	%>
	<wea:item><%=SystemEnv.getHtmlLabelName(v.getInt("fieldlabel"),user.getLanguage())%></wea:item>
	<wea:item>
		<%=((HtmlElement)Class.forName(v.getString("eleclazzname")).newInstance()).getHtmlElementString(Util.null2String(""), v, user) %>
	</wea:item>
	
	<%
	}
}

%>		
	</wea:group>
	
    
</wea:layout>

<div style="height:50px!important;"></div>
	
<div id="zDialog_div_bottom" class="zDialog_div_bottom" style="display:none;">
<wea:layout>
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_submit" type="submit" name="submit1" value="<%=SystemEnv.getHtmlLabelNames("527",user.getLanguage())%>"/>
	    	<input class="zd_btn_cancle" type="reset" name="reset" value="<%=SystemEnv.getHtmlLabelNames("2022",user.getLanguage())%>"/>
	    	<input class="zd_btn_submit" type="button" name="savetmp" onclick="onSaveas();" value="<%=SystemEnv.getHtmlLabelNames("18418",user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout>
</div>
</form>
<script language="javascript">
function onSearch(){
	$("input[name=submit1]").trigger('click');
}
function onReset(){
	$("input[type=reset]").trigger('click');
}

function onBtnSearchClick(){
	$("input[name=submit1]").trigger('click');
}

function onSave(){
	document.form2.operation.value="update";
	document.form2.target="";
	var params=$("#form2").serialize();
	jQuery.ajax({
		url : "SearchMouldOperation.jsp",
		type : "post",
		async : true,
		data : params,
		dataType : "text",
		contentType: "application/x-www-form-urlencoded;charset=utf-8",
		success: function do4Success(data){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83551",user.getLanguage())%>");
		}
	});
}




$(function(){
	try{
		//parent.setTabObjName('<%=SystemEnv.getHtmlLabelName(24457,user.getLanguage()) %>');
	}catch(e){}
});


function hideLeftTree(){
	$('#oTd1', parent.parent.document).slideLeftHide(200);
}
</script>

<script type="text/javascript">
	jQuery.fn.slideLeftHide = function( speed, callback ) {
		this.animate({
			width : "hide",
			paddingLeft : "hide",
			paddingRight : "hide",
			marginLeft : "hide",
			marginRight : "hide"
		}, speed, callback );
	};
	jQuery.fn.slideLeftShow = function( speed, callback ) {
		this.animate({
			width : "show",
			paddingLeft : "show",
			paddingRight : "show",
			marginLeft : "show",
			marginRight : "show"
		}, speed, callback );
	};
</script>
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
</body>
</html>
