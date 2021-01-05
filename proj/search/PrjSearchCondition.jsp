<%@page import="weaver.cpt.util.html.HtmlElement"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.util.*"%>
<%@page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="SearchComInfo1" class="weaver.proj.search.SearchComInfo" scope="session" />
<jsp:useBean id="CptFieldComInfo" class="weaver.proj.util.PrjFieldComInfo" scope="page"/>
<jsp:useBean id="CptFieldManager" class="weaver.proj.util.PrjFieldManager" scope="page"/>

<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>

<%
String needshowadv = Util.null2String(request.getParameter("needshowadv"));

String nameQuery = Util.null2String(request.getParameter("nameQuery"));
String method=Util.null2String(request.getParameter("method"));
int mouldid=Util.getIntValue(request.getParameter("mouldid"),0);	
SearchComInfo1.resetSearchInfo();
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

String status ="";
String prjtype   ="";
String worktype="";
String nameopt   ="";
String name="";
String description ="";
String customer ="";
	String parent = "";
String securelevel ="";
String department ="";
String manager ="";
String member ="";
String procode="";

String startdate="";
String startdateto="";
String enddate="";
String enddateto="";
String finish="";
String finish1="";
String subcompanyid1="";

RecordSet.executeProc("Prj_SearchMould_SelectByID",""+mouldid);
if(RecordSet.next()){		
status =Util.toScreenToEdit(RecordSet.getString(5),user.getLanguage());
prjtype   =Util.toScreenToEdit(RecordSet.getString(6),user.getLanguage());
worktype=Util.toScreenToEdit(RecordSet.getString(7),user.getLanguage());
nameopt   =Util.toScreenToEdit(RecordSet.getString(8),user.getLanguage());
name=Util.toScreenToEdit(RecordSet.getString(9),user.getLanguage());
description =Util.toScreenToEdit(RecordSet.getString(10),user.getLanguage());
customer =Util.toScreenToEdit(RecordSet.getString(11),user.getLanguage());
parent =Util.toScreenToEdit(RecordSet.getString(12),user.getLanguage());
securelevel =Util.toScreenToEdit(RecordSet.getString(13),user.getLanguage());
department =Util.toScreenToEdit(RecordSet.getString(14),user.getLanguage());
manager =Util.toScreenToEdit(RecordSet.getString(15),user.getLanguage());
member =Util.toScreenToEdit(RecordSet.getString(16),user.getLanguage());
procode=Util.toScreenToEdit(RecordSet.getString("procode"),user.getLanguage()); 

startdate=Util.toScreenToEdit(RecordSet.getString("startdatefrom"),user.getLanguage()); 
startdateto=Util.toScreenToEdit(RecordSet.getString("startdateto"),user.getLanguage()); 
enddate=Util.toScreenToEdit(RecordSet.getString("enddatefrom"),user.getLanguage()); 
enddateto=Util.toScreenToEdit(RecordSet.getString("enddateto"),user.getLanguage()); 	
finish=Util.toScreenToEdit(RecordSet.getString("finish"),user.getLanguage()); 	
finish1=Util.toScreenToEdit(RecordSet.getString("finish1"),user.getLanguage()); 
subcompanyid1=Util.toScreenToEdit(RecordSet.getString("subcompanyid1"),user.getLanguage()); 

}
else{
 status =Util.toScreenToEdit(SearchComInfo1.getstatus(),user.getLanguage());
 prjtype   =Util.toScreenToEdit(SearchComInfo1.getprjtype(),user.getLanguage());
 worktype=Util.toScreenToEdit(SearchComInfo1.getworktype(),user.getLanguage());
 nameopt   =Util.toScreenToEdit(SearchComInfo1.getnameopt(),user.getLanguage());
 name=Util.toScreenToEdit(SearchComInfo1.getname(),user.getLanguage());
 description =Util.toScreenToEdit(SearchComInfo1.getdescription(),user.getLanguage());
 customer =Util.toScreenToEdit(SearchComInfo1.getcustomer(),user.getLanguage());
 parent =Util.toScreenToEdit(SearchComInfo1.getparent(),user.getLanguage());
 securelevel =Util.toScreenToEdit(SearchComInfo1.getsecurelevel(),user.getLanguage());
 department =Util.toScreenToEdit(SearchComInfo1.getdepartment(),user.getLanguage());
 manager =Util.toScreenToEdit(SearchComInfo1.getmanager(),user.getLanguage());
 member =Util.toScreenToEdit(SearchComInfo1.getmember(),user.getLanguage());
 procode=Util.toScreenToEdit(SearchComInfo1.getProcode(),user.getLanguage());
 
 startdate=Util.toScreenToEdit(SearchComInfo1.getStartDate(),user.getLanguage());
 startdateto=Util.toScreenToEdit(SearchComInfo1.getStartDateTo(),user.getLanguage());
 enddate=Util.toScreenToEdit(SearchComInfo1.getEndDate(),user.getLanguage());
 enddateto=Util.toScreenToEdit(SearchComInfo1.getEndDateTo(),user.getLanguage());
 finish=Util.toScreenToEdit(SearchComInfo1.getFinish(),user.getLanguage());
 finish1=Util.toScreenToEdit(SearchComInfo1.getFinish1(),user.getLanguage());
 subcompanyid1=Util.toScreenToEdit(SearchComInfo1.getSubcompanyid1(),user.getLanguage());
}

if(Util.getIntValue( finish,0)==0){finish="";}
if(Util.getIntValue( finish1,0)==0){finish1="";}
if(Util.getIntValue( subcompanyid1,0)==0){subcompanyid1="";}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearch(),_top}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(2022,user.getLanguage())+",javascript:onReset(),_top}" ;
RCMenuHeight += RCMenuHeightStep ;

if(mouldid==0) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(350,user.getLanguage())+",javascript:onSaveas(),_top}";
RCMenuHeight += RCMenuHeightStep;
} 

if(mouldid!=0) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top}" ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top}" ;
RCMenuHeight += RCMenuHeightStep;
}

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name="form2" id="form2" method="post"  action="SearchOperation.jsp">
<input type="hidden" name="fromassortmenttab_name" value="<%=nameQuery %>" />
<input type="hidden" name="needshowadv" id="needshowadv" value="<%=needshowadv %>" />
<input type="hidden" name="mouldname" value="" />
<input type="hidden" name="operation" value="" />

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input class="e8_btn_top" type="button" name="btn_search" value="<%=SystemEnv.getHtmlLabelNames("197",user.getLanguage())%>" onclick="onSearch();" />
			<input class="e8_btn_top" type="button" name="btn_reset" value="<%=SystemEnv.getHtmlLabelNames("2022",user.getLanguage())%>" onclick="$('input[name=reset]').trigger('click');" />
<%
if(mouldid>0){
	%>
			<input class="e8_btn_top" type="button" name="savetmp" value="<%=SystemEnv.getHtmlLabelNames("86",user.getLanguage())%>" onclick="onSave();" />
	<%
}else{
	%>
			<input class="e8_btn_top" type="button" name="saveastmp" value="<%=SystemEnv.getHtmlLabelNames("18418",user.getLanguage())%>" onclick="onSaveas();" />
	<%
}
%>			
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv"></div>


	<wea:layout type="4col">
	    <wea:group context='<%=SystemEnv.getHtmlLabelNames("32905",user.getLanguage())%>'>
	    	<wea:item type="groupHead" >
	    		<select name="mouldid" id="mouldid" style="width: 135px;">
	    			<option value="0" ><%=SystemEnv.getHtmlLabelNames("149",user.getLanguage())%></option>
	    			<%
	    			rs.executeSql("select id,mouldname from Prj_SearchMould where userid='"+user.getUID()+"' ");
	    			while(rs.next()){
	    				int mid=Util.getIntValue( rs.getString("id"));
	    				String mname=Util.null2String( rs.getString("mouldname"));
	    				%>
	    				<option value="<%=rs.getString("id") %>" <%=mouldid==mid?"selected":"" %>><%=mname %></option>
	    				<%
	    				
	    			}
	    			%>
	    		</select>
	    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelNames("1353",user.getLanguage())%></wea:item>
	    	<wea:item><INPUT name=name size=50 value='<%=name%>' class="InputStyle"></wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelNames("17852",user.getLanguage())%></wea:item>
	    	<wea:item><INPUT name=procode size=18 value='<%=procode%>' class="InputStyle"></wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelNames("586",user.getLanguage())%></wea:item>
	    	<wea:item>
	    		<select class="InputStyle" name='prjtype' >
	    			<option value="" ><%=SystemEnv.getHtmlLabelNames("332",user.getLanguage())%></option>
	    		<%
              		while(ProjectTypeComInfo .next()){
              			String tmpid=ProjectTypeComInfo.getProjectTypeid ();
              			String tmpname=ProjectTypeComInfo.getProjectTypename ();
              		%>	
              		<option value="<%=tmpid %>" <%=prjtype.equals(tmpid)?"selected":"" %> ><%=tmpname %></option>
              		<%
              		}
              	%>
	    		</select>
	    		
	    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelNames("432",user.getLanguage())%></wea:item>
	    	<wea:item>
	    		<select class="InputStyle" name='worktype' >
	    			<option value="" ><%=SystemEnv.getHtmlLabelNames("332",user.getLanguage())%></option>
	    		<%
              		while(WorkTypeComInfo.next()){
              			String tmpid=WorkTypeComInfo.getWorkTypeid();
              			String tmpname=WorkTypeComInfo.getWorkTypename();
              		%>	
              		<option value="<%=tmpid %>" <%=worktype.equals(tmpid)?"selected":"" %> ><%=tmpname %></option>
              		<%
              		}
              	%>
	    		</select>
	    		
	    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelNames("783",user.getLanguage())%></wea:item>
	    	<wea:item>
	    		<brow:browser  name="customer" browserValue='<%=customer %>' browserSpanValue='<%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(customer ),user.getLanguage())%>' browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" completeUrl="/data.jsp?type=7"  isMustInput="1" viewType="0" browserOnClick=""  hasInput="true"  isSingle="true" hasBrowser = "true" />
	    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelNames("83796",user.getLanguage())%></wea:item>
	    	<wea:item>
				<span class="wuiDateSpan" selectId="startdate_sel" selectValue="">
				    <input class=wuiDateSel type="hidden" name="startdate" value="<%=startdate %>">
				    <input class=wuiDateSel  type="hidden" name="startdateTo" value="<%=startdateto %>">
				</span>
			</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelNames("22170",user.getLanguage())%></wea:item>
	    	<wea:item>
				<span class="wuiDateSpan" selectId="enddate_sel" selectValue="">
				    <input class=wuiDateSel type="hidden" name="enddate" value="<%=enddate %>">
				    <input class=wuiDateSel  type="hidden" name="enddateTo" value="<%=enddateto %>">
				</span>
			</wea:item>

		</wea:group>
		
		
		
		<wea:group context='<%=SystemEnv.getHtmlLabelNames("27858",user.getLanguage())%>' attributes="{'samePair':'moreKeyWord','itemAreaDisplay':''}">
			<wea:item><%=SystemEnv.getHtmlLabelNames("587",user.getLanguage())%></wea:item>
			<wea:item>
	    		<select class="InputStyle" name='status' >
	    			<option value="" ><%=SystemEnv.getHtmlLabelNames("332",user.getLanguage())%></option>
	    		<%
              		while(ProjectStatusComInfo .next()){
              			String tmpid= ProjectStatusComInfo.getProjectStatusid();
              			String tmpname=ProjectStatusComInfo.getProjectStatusdesc();
              		%>	
              		<option value="<%=tmpid %>" <%=status.equals(tmpid)?"selected":"" %> ><%=tmpname %></option>
              		<%
              		}
              	%>
	    		</select>
	    	</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelNames("636",user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="parent" 
				browserValue='<%=parent %>' 
				browserSpanValue='<%=ProjectInfoComInfo.getProjectInfoname  (""+parent) %>'
				browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp?type=8"  />
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelNames("847",user.getLanguage())%></wea:item>
			<wea:item>
				<input class=InputStyle style="width:60px!important;" maxlength=3 size=5 value="<%=finish %>" name="finish" onkeypress="return event.keyCode>=4&&event.keyCode<=57">
				-<input class=InputStyle style="width:60px!important;" maxlength=3 size=5 value="<%=finish1 %>" name="finish1" onkeypress="return event.keyCode>=4&&event.keyCode<=57">
				%
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelNames("16573",user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="manager" 
					browserValue='<%=manager %>' 
					browserSpanValue='<%=ResourceComInfo.getResourcename (""+manager) %>'
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp"  />
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelNames("83797",user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="department" 
					browserValue='<%=department %>' 
					browserSpanValue='<%=DepartmentComInfo.getDepartmentname(""+department ) %>'
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=4"  />
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelNames("83813",user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="subcompanyid1" 
					browserValue='<%=subcompanyid1 %>' 
					browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(""+subcompanyid1 ) %>'
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=164"  />
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelNames("18628",user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="member" 
					browserValue='<%=member %>' 
					browserSpanValue='<%=ResourceComInfo.getResourcename (""+member) %>'
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp"  />
			</wea:item>
		


		</wea:group>
		
		
		<wea:group context='<%=SystemEnv.getHtmlLabelNames("16169",user.getLanguage())%>' attributes="{'samePair':'moreKeyWord','groupOperDisplay':'none'}">

<%
//cusfield
TreeMap<String,JSONObject> openfieldMap= CptFieldComInfo.getOpenFieldMap();
if(!openfieldMap.isEmpty()){
	Iterator it=openfieldMap.entrySet().iterator();
	while(it.hasNext()){
		Entry<String,JSONObject> entry=(Entry<String,JSONObject>)it.next();
		String k= entry.getKey();
		JSONObject v= entry.getValue();
		int fieldhtmltype= v.getInt("fieldhtmltype");
		if(fieldhtmltype==2||fieldhtmltype==6||fieldhtmltype==7){
			continue;
		}
		v.put("ismand", "0");//查询不用必填
	//RecordSet.getString(v.getString("fieldname"))
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
    		<input class="zd_btn_submit" type="submit" name="submit1" value="查询"/>
	    	<input class="zd_btn_cancle" type="reset" name="reset" value="<%=SystemEnv.getHtmlLabelNames("2022",user.getLanguage())%>"/>
	    	<input class="zd_btn_submit" type="button" name="savetmp" onclick="onSaveas();" value="<%=SystemEnv.getHtmlLabelNames("18418",user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout>
</div>
</form>
<script language="javascript">
function onSearch(){
	$("#form2").submit();
}
function onReset(){
	$("input[type=reset]").trigger('click');
}

function onBtnSearchClick(){
	$("#form2").submit();
}

function onDelete(){
	window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83695",user.getLanguage())%>',function(){
		jQuery.post(
			"/proj/search/SearchMouldOperation.jsp",
			{"operation":"delete","mouldid":'<%=mouldid %>'},
			function(data){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83472",user.getLanguage())%>",function(){
					document.form2.action="PrjSearchCondition.jsp";
					$("input[name=needshowadv]").val('1');
					$("input[name=submit1]").trigger('click');
				});
			}
		);
		
	});
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

function onSaveas(){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Width = 330;
	dialog.Height = 88;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("19468",user.getLanguage())%>";
	dialog.URL ="/proj/search/PrjSaveAsMould.jsp?isdialog=0";
	dialog.OKEvent = function(){
		document.form2.mouldname.value=dialog.innerFrame.contentWindow.document.getElementById('assortmentname').value;
		if(document.form2.mouldname.value==""){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage()) %>");
			return;
		}else{
			document.form2.operation.value="add";
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
					dialog.close();
					
				}
			});	
		}
		
	};
	dialog.show();
}

$(function(){
	$("#mouldid").bind('change',function(){
		document.form2.action="PrjSearchCondition.jsp";
		$("input[name=needshowadv]").val('1');
		$("input[name=submit1]").trigger('click');
	});
	
});


jQuery(document).ready(function(){
	
	/**hideGroup("moreKeyWord");
	
	var showText = "显示";
	var hideText = "隐藏";
	var languageid=readCookie("languageidweaver");
	if(languageid==8){
		showText = "Display";
		hideText = "Hide";
	}else if(languageid==9){
		showText = "顯示";
		hideText = "隐藏";
	}

	jQuery("#moreSearch_Span").unbind("click").bind("click", function () {
		var _status = jQuery(this).attr("_status");
		var currentTREle = jQuery(this).closest("table").closest("TR");
		if (!!!_status || _status == "0") {
			jQuery(this).attr("_status", "1");
			jQuery(this).html(showText+"<image src='/wui/theme/ecology8/templates/default/images/1_wev8.png'>");
			currentTREle.next("TR.Spacing").next("TR.items").hide();
			hideGroup("moreKeyWord");
		} else {
			jQuery(this).attr("_status", "0");
			jQuery(this).html(hideText+"<image src='/wui/theme/ecology8/templates/default/images/2_wev8.png'>");
			currentTREle.next("TR.Spacing").next("TR.items").show();
			showGroup("moreKeyWord");
		}
	}).hover(function(){
		$(this).css("color","#000000");
	},function(){
		$(this).css("color","#cccccc");
	});**/
});

$(function(){
	try{
		parent.setTabObjName('<%=SystemEnv.getHtmlLabelName(16413,user.getLanguage()) %>');
	}catch(e){}
});


$(function(){
	//setTimeout("hideLeftTree()",10);
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
