<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>

</HEAD>

<body>
<%
int uid=user.getUID();
    String resourcemulti = "";

    Cookie[] cks = request.getCookies();

    for (int i = 0; i < cks.length; i++) {
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
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

%>
	<FORM NAME="SearchForm" id="SearchForm" STYLE="margin-bottom:0" action="MultiSelect.jsp" method=post target="frame2">
	<input type="hidden" name="isinit" value="1"/>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:btnsub_onclick(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:reset_onclick(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<input class=inputstyle type="hidden" name="resourceids" >
<wea:layout type="4col">
     	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
	      <wea:item><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></wea:item>
	      <wea:item>
	      	<input class="InputStyle" id="lastname" type="text" name="lastname" >
	      </wea:item>
	      <wea:item><%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%></wea:item>
	      <wea:item>
	        	<select id="status" name="status" >
		          <option value=9 ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
		          <option value="" selected><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%></option>
		          <option value=0 ><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></option>
		          <option value=1 ><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></option>
		          <option value=2 ><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></option>
		          <option value=3 ><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></option>
		          <option value=4 ><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%></option>
		          <option value=5 ><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%></option>
		          <option value=6 ><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%></option>
		          <option value=7 ><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option>
		        </select>
	      </wea:item>
	      
	      <wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
	      <wea:item>
	      		<brow:browser viewType="0" temptitle="" name="subcompanyid" browserValue="" 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
							hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1' 
							completeUrl="/data.jsp?type=164" width="80%" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
							browserSpanValue=""></brow:browser>
	      </wea:item>
	      <wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
	      <wea:item>
	        	<brow:browser viewType="0" temptitle="" name="departmentid" browserValue="" 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="
							hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'   
							completeUrl="/data.jsp?type=4" width="80%" linkUrl="/hrm/company/HrmDepartmentDsp.jsp?id=" 
							browserSpanValue="" ></brow:browser>
	      </wea:item>
	      
	      <wea:item><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></wea:item>
	      <wea:item>
	      	<brow:browser viewType="0"  name="jobtitle" browserValue="" 
			   browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp" 
			   hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
			   completeUrl="/data.jsp?type=hrmjobtitles" width="80%" browserSpanValue="">
			 	</brow:browser>
	      </wea:item>
	      <wea:item><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></wea:item>
	      <wea:item>
				<brow:browser viewType="0" temptitle="" name="roleid" browserValue=""
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp" 
							hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  
							completeUrl="/data.jsp?type=65" width="80%" linkUrl="" 
							browserSpanValue=""></brow:browser>
	      </wea:item>
	      
	 </wea:group>
</wea:layout>		 	
<!--########//Search Table End########-->
</FORM>
<script language="javascript">
$(document).ready(function(){
	if(typeof(parent.frame2) != "undefined"){
		parent.frame2.resetCondition(3,false);
	}
});

function reset_onclick(){
	$('#lastname').val("");
	$('#status').val("");
	$("#status").selectbox('detach');
	$("#status").selectbox('attach');		
	$('#subcompanyid').val("");
	$('#subcompanyidspan').html("");
	$('#departmentid').val("");
	$('#departmentidspan').html("");
	$('#roleid').val("");
	$('#roleidspan').html("");
	$('#jobtitle').val("");
	$('#jobtitlespan').html("");
	rightMenu.style.visibility='hidden';
}


function btnsub_onclick(){
	parent.frame2.setSearchCondition3($('#lastname').val(),$("#jobtitle").val(),$("#status").val(),$('#subcompanyid').val(),$('#departmentid').val(),$('#roleid').val());
	rightMenu.style.visibility='hidden';
}
</script>
</BODY>
</HTML>
