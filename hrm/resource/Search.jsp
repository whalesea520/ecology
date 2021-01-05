<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
</HEAD>
<body>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1867,user.getLanguage());
String needfav ="1";
String needhelp ="";

int uid=user.getUID();
    String resourcemulti = "";

    Cookie[] cks = request.getCookies();

    for (int i = 0; i < cks.length; i++) {
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if (cks[i].getName().equals("resourcemulti" + uid)) {
            resourcemulti = cks[i].getValue();
            break;
        }
    }

    String rem = "";
	if(resourcemulti.length()>0){
		rem="2"+resourcemulti.substring(1);
	}else{
		rem="2"+resourcemulti;
	}
Cookie ck = new Cookie("resourcemulti"+uid,rem);  
ck.setMaxAge(30*24*60*60);
response.addCookie(ck);
//组合查询不接收条件
String sqlwhere ="";// Util.null2String(request.getParameter("sqlwhere"));
String status ="";// Util.null2String(request.getParameter("status"));
String check_per = Util.null2String(request.getParameter("resourceids"));
String moduleManageDetach=Util.null2String(request.getParameter("moduleManageDetach"));//(模块管理分权-分权管理员专用)
String fromHrmStatusChange = Util.null2String(request.getParameter("fromHrmStatusChange"));

String resourceids = "" ;
String resourcenames ="";
if(!check_per.equals("")){
	try{
	String strtmp = "select id,lastname from HrmResource where id in ("+check_per+")";
	RecordSet.executeSql(strtmp);
	Hashtable ht = new Hashtable();
	while(RecordSet.next()){
		ht.put(RecordSet.getString("id"),RecordSet.getString("lastname"));
		/*
		if(check_per.indexOf(","+RecordSet.getString("id")+",")!=-1){

				resourceids +="," + RecordSet.getString("id");
				resourcenames += ","+RecordSet.getString("lastname");
		}
		*/
	}

	StringTokenizer st = new StringTokenizer(check_per,",");

	while(st.hasMoreTokens()){
		String s = st.nextToken();
		resourceids +=","+s;
		resourcenames += ","+ht.get(s).toString();
	}
	}catch(Exception e){
		
	}
}
%>
	<FORM NAME="SearchForm" id="SearchForm" STYLE="margin-bottom:0" action="MultiSelect.jsp" method=post target="frame2">
	<input type="hidden" name="isinit" value="1"/>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
BaseBean baseBean_self = new BaseBean();
int userightmenu_self = 1;
try{
	userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}
if(userightmenu_self == 1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.btnsearch.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	//td19321
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:SearchForm.reset(),_self} " ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:document.SearchForm.btnok.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	//把window.close() 改成window.parent.parent.close()
	//2012-08-15 ypc 修改
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:document.SearchForm.btncancel.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
	<BUTTON class=btnSearch accessKey=S style="display:none" type="button" onclick="btnsearch_onclick()"  id="btnsearch" ><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
	<!--td19321
	<BUTTON class=btnReset accessKey=T style="display:none" type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
	-->
	<BUTTON class=btnReset accessKey=T style="display:none" id=reset type="button" onclick="reset_onclick()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
	<BUTTON class=btn accessKey=O style="display:none" id=btnok onclick="btnok_onclick()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
	<BUTTON class=btnReset accessKey=T style="display:none" id=btncancel onclick="btncancel_onclick()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
	
	<!-- 2012-08-15 ypc 修改 把btnclear() 换成 btncancel_onclick() 就解决右键清楚菜单不起左右啦-->
	<BUTTON class=btn accessKey=2 style="display:none" id=btnclear onclick="btnclear_onclick()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>

		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script>
rightMenu.style.visibility='hidden'
</script>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="btnsearch_onclick()" value="<%=SystemEnv.getHtmlLabelName(197, user.getLanguage())%>"></input>
		  <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></wea:item>
			<wea:item><input class=inputstyle name=lastname ></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
      <wea:item>
        <select class=inputstyle id=status name=status >
        	<%if(fromHrmStatusChange.equals("HrmResourceTry")){ %>
        	  <option value="" selected ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
			  		<option value=2 ><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></option>
        	<%}else if(fromHrmStatusChange.equals("HrmResourceHire")) {%>
           	<option value="" selected ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option> 
			  		<option value=0 ><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></option>
					  <option value=2 ><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></option>
					  <option value=3 ><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></option>
          <%}else if(fromHrmStatusChange.equals("HrmResourceExtend")) {%>
        	  <option value="" selected ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
			  		<option value=1><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></option>
            <option value=0 ><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></option>
            <option value=2 ><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></option>
            <option value=3 ><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></option>
        	<%}else if(fromHrmStatusChange.equals("HrmResourceDismiss")) {%>
        		<option value="" selected ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
					  <option value=0 ><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></option>
					  <option value=1 ><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></option>
					  <option value=2 ><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></option>
					  <option value=3 ><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></option>
					  <option value=7 ><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option>
     	  	<%}else if(fromHrmStatusChange.equals("HrmResourceRetire")) {%>
     	  		<option value="" selected ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
			  		<option value=1><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></option>
     	  	<%}else if(fromHrmStatusChange.equals("HrmResourceFire")) {%>
     	  	  <option value="" selected ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
            <option value=0 ><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></option>
			  		<option value=1 ><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></option>
            <option value=2 ><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></option>
			  		<option value=3 ><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></option>
     	  	<%}else if(fromHrmStatusChange.equals("HrmResourceRehire")) {%>
     	  	  <option value="" selected ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
					  <option value=4 ><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%></option>
					  <option value=5 ><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%></option>
					  <option value=6 ><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%></option>
					  <option value=7 ><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option>
        	<%}else{ %>
          <option value=9 ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
          <option value="8" selected><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%></option>
          <option value=0 ><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></option>
          <option value=1 ><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></option>
          <option value=2 ><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></option>
          <option value=3 ><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></option>
          <option value=4 ><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%></option>
          <option value=5 ><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%></option>
          <option value=6 ><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%></option>
          <option value=7 ><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option>
          <%} %>
        </select>
      </wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
      <wea:item>
	    	<brow:browser viewType="0" name="subcompanyid" browserValue="" 
	        browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
	        hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	        completeUrl="/data.jsp?type=164"
	        _callback="jsSubcompanyCallback" browserSpanValue="">
	      </brow:browser>
      </wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
      <wea:item>
	      <brow:browser viewType="0" name="departmentid" browserValue="" 
	        browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/DepartmentBrowser.jsp?selectedids="
	        hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	        completeUrl="/data.jsp?type=4"
	        _callback="jsDepartmentCallback" browserSpanValue="">
	      </brow:browser>
      </wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></wea:item>
			<wea:item>
				<input class=inputstyle name=jobtitle maxlength=60 >
      </wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></wea:item>
			<wea:item>
      	<brow:browser viewType="0" name="roleid" browserValue="" 
	        browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/roles/HrmRolesBrowser.jsp?selectedids="
	        hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	        completeUrl="/data.jsp?type=65" browserSpanValue="">
      	</brow:browser>
      </wea:item>
	</wea:group>
</wea:layout>

<input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
  <input class=inputstyle type="hidden" name="resourceids">
<input class=inputstyle type="hidden" name="tabid"  >
<input class=inputstyle type="hidden" name="isNoAccount" id="isNoAccount">
<input class=inputstyle type="hidden" name="moduleManageDetach" id="moduleManageDetach"> 
<input class=inputstyle type="hidden" name="fromHrmStatusChange" id="fromHrmStatusChange" value='<%=fromHrmStatusChange%>'> 
	<!--########//Search Table End########-->
	</FORM>
<script language="javascript">
	var dialog = null;
	try{
		dialog = parent.parent.parent.getDialog(parent.parent);
	}catch(ex1){}
	var resourceids =""
	var resourcenames = ""
	
	function reset_onclick(){
		_writeBackData('subcompanyid','1',{'id':'','name':''});
		_writeBackData('departmentid','1',{'id':'','name':''});
		_writeBackData('roleid','1',{'id':'','name':''});
		//清除select框
		jQuery("#status").selectbox("detach");
		jQuery("#status").val("");
		jQuery("#status").selectbox();
		document.SearchForm.status.value=""
		document.SearchForm.jobtitle.value=""
		document.SearchForm.lastname.value=""
		jQuery("input[name=subcompanyid]").val("");
		jQuery("input[name=departmentid]").val("");
		jQuery("input[name=roleid]").val("");
	}
	
	function btnclear_onclick(){
		var returnjson = {id:"",name:""};
		if(dialog){
			try{
	    	dialog.callback(returnjson);
	    }catch(e){}
	
			try{
		  	dialog.close(returnjson);
		 	}catch(e){}
		}else{
			window.parent.parent.returnValue = returnjson;
	    window.parent.parent.close();
		}
	}

function btnok_onclick(){
	window.parent.frame2.btnok.click();
}
	
	
function btnok_onclick1(){
	setResourceStr();
	replaceStr();
	window.parent.parent.returnValue = {id:resourceids,name:resourcenames};
	window.parent.parent.close();
	}
	
function btncancel_onclick(){
	if(dialog){
	  	dialog.close();
	}else{
	   window.parent.parent.close();
	}
}

var resourceids="";
function btnsearch_onclick(){
	setResourceStr() ;
	//$("input[name=resourceids]").val(window.parent.frame2.systemIds.value);
		$("input[name=resourceids]").val(jQuery(parent.document).find("#frame2").contents().find("#systemIds").val());
    $("input[name=tabid]").val(2);  
    //是否显示无账号人员
    if(jQuery(parent.document).find("#frame2").contents().find("#isNoAccount").attr("checked"))
      jQuery("#isNoAccount").val("1");
    else
      jQuery("#isNoAccount").val("0");
      
    jQuery("#moduleManageDetach").val("<%=moduleManageDetach%>");  
      
	$("#SearchForm").submit();
}

function setResourceStr(){
	
	var resourceids1 =""
        var resourcenames1 = ""
     try{   
	for(var i=0;i<parent.frame2.resourceArray.length;i++){
		resourceids1 += ","+parent.frame2.resourceArray[i].split("~")[0] ;
		
		resourcenames1 += ","+parent.frame2.resourceArray[i].split("~")[1] ;
	}
	resourceids=resourceids1
	resourcenames=resourcenames1
     }catch(err){}
}

function replaceStr(){
    var re=new RegExp("[ ]*[|][^|]*[|]","g")
    resourcenames=resourcenames.replace(re,"|")
    re=new RegExp("[|][^,]*","g")
    resourcenames=resourcenames.replace(re,"")
}    
function jsSubcompanyCallback(e,datas, name){
	if (datas && datas.id!=""){
		_writeBackData('departmentid','1',{'id':'','name':''});
	}
}
function jsDepartmentCallback(e,datas, name){
	if(datas && datas.id!="") {
		_writeBackData('subcompanyid','1',{'id':'','name':''});
	}   
}
</script>
</BODY>
</HTML>
