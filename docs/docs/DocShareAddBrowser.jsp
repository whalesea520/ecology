
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page import="weaver.docs.category.CategoryUtil" %>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ShareManager" class="weaver.share.ShareManager" scope="page"/>
<jsp:useBean id="SpopForDoc" class="weaver.splitepage.operate.SpopForDoc" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="scc" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page"/>
<html>
<HEAD> 
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
    <SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
	<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<style type="text/css">
.current a {
	font-size: 20px;
}

.over {
	display: none;
	position: absolute;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background-color: #ffffff;
	opacity: 0;
	filter:Alpha(opacity=0);
	z-index: 1000;
}

.layout {
	display: none;
	position: absolute;
	top: 40%;
	left: 40%;
	width: 20%;
	height: 20%;
	z-index: 1001;
	text-align: center;
}
</style>
<% 
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String para = Util.null2String(request.getParameter("para")); 
	if("".equals(para)){
		para = Util.null2String(request.getParameter("_para2"));
	}
    String[] paraArray = Util.TokenizerString2(para,"_");
    int docid =Util.getIntValue(paraArray[1],0);  // browserType:1 docid用目录ID   2 docid 为文档ID
    int browserType =Util.getIntValue(paraArray[0],0);   //1:表示 目录中的默认共享    2:表示文档中的默认共享
	if(browserType!=1){
		browserType=2;
	} 
	String message = Util.null2String(request.getParameter("message"));
%>
<script language=javascript >
var parentWin = parent.getParentWindow(window);
var dialog = parent.getDialog(window);
if("<%=isclose%>"=="1"){
	//parentWin.location.href="DocSubCategoryDefaultRightEdit.jsp?id=<%=docid%>";
	parentWin._table.reLoad();
	//parentWin.closeDialog();	
}
<%if(message.equals("1")){%>
	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(2012,user.getLanguage())%>");
	parentWin.closeDialog();
<%}%>

<%if(isclose.equals("2")){%>
	parentWin._table.reLoad();
	parentWin.closeDialog();
<%}%>
</script>
</HEAD>
<%    
	int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
	int categoryid = Util.getIntValue(request.getParameter("categoryid"),0);
	//System.out.println("categoryid:"+categoryid);
	int categorytype = Util.getIntValue(request.getParameter("categorytype"),0);
	int operationcode = Util.getIntValue(request.getParameter("operationcode"),0);
    

	boolean canAdd=false;
	if(browserType==1){//1:表示 目录中的默认共享
	    MultiAclManager am = new MultiAclManager();
	    int parentId = Util.getIntValue(scc.getParentId(""+docid));
	    boolean hasSecManageRight = false;
	    if(parentId>0){
	    	hasSecManageRight = am.hasPermission(parentId, MultiAclManager.CATEGORYTYPE_SEC, user, MultiAclManager.OPERATION_CREATEDIR);
	    }
        if(HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit", user) || hasSecManageRight){
	        canAdd=true;
        }
	}else if(browserType==2){//2:表示文档中的默认共享
        //3:共享
        //user info
        int userid=user.getUID();
        String logintype = user.getLogintype();
        String userSeclevel = user.getSeclevel();
        String userType = ""+user.getType();
        String userdepartment = ""+user.getUserDepartment();
        String usersubcomany = ""+user.getUserSubCompany1();
        String userInfo=logintype+"_"+userid+"_"+userSeclevel+"_"+userType+"_"+userdepartment+"_"+usersubcomany;
        ArrayList PdocList = SpopForDoc.getDocOpratePopedom(""+docid,userInfo);
        if (((String)PdocList.get(3)).equals("true")){ 
        	canAdd = true ;
        }
	}
    
	if(!canAdd){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
    /**TD12005 文档下载权限控制(获取禁止下载标志) 开始*/
    int noDownload = Util.getIntValue(Util.null2String(request.getParameter("noDownload")),0);
    RecordSet.executeSql("select d2.noDownload from docdetail d1,DocSecCategory d2 where d1.seccategory=d2.id and d1.id=" + docid);
    if(RecordSet.next()){
    	noDownload = Util.getIntValue(RecordSet.getString(1),0);
    }
    //是否有效
    String isDownloadDisabled = "";
    if(noDownload == 1) isDownloadDisabled ="disabled";
    /**TD12005 文档下载权限控制(获取禁止下载标志) 结束*/
	//System.out.println("browserType:"+browserType);
	

	
	
    boolean blnOsp = "true".equals(request.getParameter("blnOsp"));  //用于存放共享提醒对话框的设置
    
    String actionid = Util.null2String(request.getParameter("actionid"));
	String datasourceid = Util.null2String(request.getParameter("datasourceid"));
	
	//System.out.println("blnOsp:"+blnOsp);
%>
<body style="overflow:hidden;">
<div id="over" class="over"></div>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" class="e8_btn_top" onclick="doSave(this);">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="doc"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(385,user.getLanguage()) %>"/>
</jsp:include>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:doSave(this),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
    //RCMenu += "{返回,javascript:window.history.go(-1),_top} ";
    //RCMenuHeight += RCMenuHeightStep ;
if(!"1".equals(isDialog)){
	if(browserType==1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/docs/category/DocSecCategoryEdit.jsp?id="+docid+"&tab=1,_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
	}
	if(browserType==2){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/docs/docs/DocShare.jsp?docid="+docid+",_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
	}
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
    //通过文档的id得到文档的类型,文档创建人类型,文档创建者所具有的条件'
    String createUserType="";
    String strSql = "select usertype from docdetail  where id="+docid;
    rs.executeSql(strSql);
    if (rs.next()){
        createUserType = Util.null2String(rs.getString("usertype"));           
    }
%>

    <div id="layout" class="layout"><img src="/formmode/js/ext/resources/images/default/shared/blue-loading_wev8.gif" alt="" /></div>
<form name="weaver" id="weaver" method="post">
  <INPUT TYPE="hidden" NAME="docid" value="<%=docid%>">
  <%--
  <INPUT type="hidden" Name="method" value="<%=browserType==1?"addMutil":"addMulti" %>">
   --%>
  <INPUT type="hidden" Name="method" value="<%=browserType==1?"add":"addMutil" %>">
  
  
  <INPUT type="hidden" Name="actionid" value="<%=actionid%>">
  <INPUT type="hidden" Name="datasourceid" value="<%=datasourceid%>">
  
  <%if(isDialog.equals("1")){ %>
  <INPUT type="hidden" Name="isdialog" value="<%=isDialog %>">
  <INPUT type="hidden" Name="noDownload" value="<%=noDownload %>">
  <INPUT type="hidden" id="txtShareDetail" Name="txtShareDetail" value="">
  <%} %>
  <wea:layout>
	  <wea:group context='<%=SystemEnv.getHtmlLabelName(2112,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(21956,user.getLanguage())%></wea:item>
			<wea:item>
				<span style="float:left;display:inline-block;width:135px;">
				<SELECT class=InputStyle style="width:100px;" id="sharetype"  name=sharetype onChange="onChangeSharetype()" >   
					<option value="1" selected><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option> 
					<option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
					<option value="3"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
					<option value="10"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></option>
					<option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
					<option value="6"><%=SystemEnv.getHtmlLabelName(24002,user.getLanguage())%></option>	
					
					<option value="5"><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></option>
					<%if(isgoveproj==0){%>
					 <option value="9"><%=SystemEnv.getHtmlLabelName(18647,user.getLanguage())%></option>
					  <option value="-1"><%=SystemEnv.getHtmlLabelName(1282,user.getLanguage())%></option>
					 <%}%>
					
				    <%
					if (browserType!=1){
						if ("1".equals(createUserType)){%>
						<OPTION value="80"><%=SystemEnv.getHtmlLabelName(15079,user.getLanguage())%></OPTION>
						<OPTION value="81"><%=SystemEnv.getHtmlLabelName(18583,user.getLanguage())%></OPTION>
						<OPTION value="82"><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())+SystemEnv.getHtmlLabelName(15762,user.getLanguage())%></OPTION>     
						<OPTION value="84"><%=SystemEnv.getHtmlLabelName(18584,user.getLanguage())%></OPTION>
						<OPTION value="85"><%=SystemEnv.getHtmlLabelName(15081,user.getLanguage())%></OPTION>
					   <%} else {%>
						<OPTION value="-80"><%=SystemEnv.getHtmlLabelName(15079,user.getLanguage())%></OPTION>
						<OPTION value="-81"><%=SystemEnv.getHtmlLabelName(15080,user.getLanguage())%></OPTION>                                                  
					   <%}
					  }%>
				</SELECT>
				</span>
				<span id="showorgid" name="showorgid" style="display:none">
					
					<%
             if(CompanyVirtualComInfo.getCompanyNum()>0){
			%>
				<select name="orgid" id="orgid" onchange="onOptionChange('PCreaterManager')">
				<option value="0"  ><%=SystemEnv.getHtmlLabelName(83179,user.getLanguage())%></option>
			
    		
    		<%
    		CompanyVirtualComInfo.setTofirstRow();
    		while(CompanyVirtualComInfo.next()){
    		%>
    		<option value="<%=CompanyVirtualComInfo.getCompanyid() %>" ><%=CompanyVirtualComInfo.getVirtualType() %></option>
    		<%} %>
    	

			   </select> 
			<%
			  }
            %>
					
				    </span>
			

			</wea:item>
		
			<wea:item  attributes="{'samePair':'showobg'}">				
				<%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%>
			</wea:item>
			<wea:item  attributes="{'samePair':'showobg'}">

			

				<span id="showButton" style="float:left;">
					<brow:browser viewType="0" name="relatedshareid" browserValue="" 
							browserUrl="#" getBrowserUrlFn="getBrowserUrlFn"
							hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
							completeUrl="javascript:getCompleteUrl()" width="170px" _callback="setRelatedName">
					</brow:browser>
					<input type="hidden" name = "showrelatedsharename" id="showrelatedsharename"/>
				</span>

				<span id="showcustype" name="showcustype" style="display:none">
				
					<SELECT  name="custype" id="custype">
						<%
					if(isgoveproj==0){
					while(CustomerTypeComInfo.next()){
									String curid=CustomerTypeComInfo.getCustomerTypeid();
									String curname=CustomerTypeComInfo.getCustomerTypename();
									String optionvalue="-"+curid;
					%>
					<option value="<%=optionvalue%>"><%=curname%></option>
					<%}
					}
					%>
				    </SELECT>
					
				</span>
				 <span id="showrolelevelname" name="showrolelevelname" style="display:none;">
				 <%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>
				 </span>

				<span id="showrolelevel" name="showrolelevel" style="display:none">
					<SELECT  name=rolelevel>
					<option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
					<option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
					<option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
				    </SELECT>
					
				</span>

				<span id="showincludesub" name="showincludesub" style="display:none">
					  <input class='InputStyle' type='checkbox' name='includesub' id='includesub' value='' ><%=SystemEnv.getHtmlLabelName(33864,user.getLanguage())+SystemEnv.getHtmlLabelName(27170,user.getLanguage())%>
					
				</span>

				
				</wea:item>
			
			<wea:item attributes="{'samePair':'showseclevel','display':'none'}"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
			<wea:item attributes="{'samePair':'showseclevel','display':'none'}"> 
				<INPUT type=text name=seclevel class=InputStyle style="width:30px;" size=6 value="10" onchange='checkinput("seclevel","seclevelimage")' onKeyPress="ItemCount_KeyPress()"> <span id=seclevelimage></span>-<INPUT type=text name=seclevelmax class=InputStyle style="width:30px;" size=6 value="" onchange='checkinput("seclevelmax","seclevelmaximage")' onKeyPress="ItemCount_KeyPress()">
                 <span id=seclevelmaximage></span>
			</wea:item>
			<wea:item  attributes="{'samePair':'_joblevel','itemAreaDisplay':'none','display':'none'}"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></wea:item>
<wea:item attributes="{'samePair':'_joblevel','itemAreaDisplay':'none','display':'none'}">
        <SELECT name=joblevel id=joblevel align="left" style="float:left" onchange="checkjoblevel()">
          <option value="1" selected><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
          <option value="2"><%=SystemEnv.getHtmlLabelName(19437,user.getLanguage())%></option>
          <option value="3"><%=SystemEnv.getHtmlLabelName(19438,user.getLanguage())%></option>
        </SELECT>
		<span id=jobsubcompanysapn style="display:none">
			<brow:browser viewType="0" name="jobsubcompany" browserValue="" 
          browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser3.jsp?selectedids=#id#&isedit=1&rightStr=HrmResourceAdd:Add"
          hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2' width="220px"  
          completeUrl="/data.jsp?type=164">
          </brow:browser>
         </span>
		
		  <brow:browser viewType="0" name="jobdepartment" browserValue="" 
          browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=#id#&excludeid=1"
          hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2' width="220px"
          completeUrl="/data.jsp?type=4"  display="none">
          </brow:browser>
		
</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(385,user.getLanguage())%></wea:item>
			<wea:item>
				<!-- TD12005 文档下载权限控制    ONCHANGE添加 -->
				<SELECT class=InputStyle  name=Psharelevel onchange="onOptionChange('Psharelevel')">
					<option value="1"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option>
					<option value="2"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option>
				<%
					String sharelevel="";
					if(browserType==2){
						String userId = "" +user.getUID() ;
						String loginType = user.getLogintype() ;
						String userType = ""+user.getType();
						String userDepartment = ""+user.getUserDepartment();
						String userSubCompany  = ""+user.getUserSubCompany1();
						String userSeclevel = user.getSeclevel();
						String strSqlSharelevel=ShareManager.getSharLevel("doc",userId, loginType,userType,userDepartment,userSubCompany ,userSeclevel,""+docid);
						rs.executeSql(strSqlSharelevel);
						if (rs.next()) {
							sharelevel = ""+Util.getIntValue(rs.getString(1));            
						}
					}
					
					if(browserType==1||sharelevel.equals("3")){
				%>
															<option value="3"><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option>
				<%
					}
				%>
														&nbsp;&nbsp;&nbsp;
                 </SELECT>
				<!-- TD12005 文档下载权限控制    复选框对象添加 -->
                  <input class='InputStyle' type='checkbox' value="1" <%if(noDownload==0){%> checked<%}%> name='chkPsharelevel' id='chkPsharelevel' style="display:<%="" %>" <%=isDownloadDisabled%>><label for='chkPsharelevel' id='lblPsharelevel' style="display:<%="" %>"><%=SystemEnv.getHtmlLabelName(23733,user.getLanguage())%></label>

			</wea:item>
	  </wea:group>
  </wea:layout>
  <TABLE class=ViewForm>
	<COLGROUP>
	<COL width="30%">
	<COL width="70%">
	<TBODY>                                    
		<%if(!"1".equals(isDialog)){ %>
		<tr>
			<TD  colspan=2>
			   <TABLE  width="100%">
				<TR>
					<TD width="*"></TD>
					<TD width="300px"><button class="btnNew" type="button" title="<%=SystemEnv.getHtmlLabelName(18645,user.getLanguage())%>" onClick="addValue()" accesskey="a"><u>A</u>&nbsp;<%=SystemEnv.getHtmlLabelName(18645,user.getLanguage())%></button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<button class="btnDelete" type="button" title="<%=SystemEnv.getHtmlLabelName(18646,user.getLanguage())%>" onClick="removeValue()" accesskey="d"><u>D</u>&nbsp;<%=SystemEnv.getHtmlLabelName(18646,user.getLanguage())%></button></TD>
				</TR>
			   </TABLE>
			</TD>
		</tr>
	   <TR style="height: 1px">
			<TD class=Line colSpan=2></TD>
	   </TR>
	   <tr>
			<td colspan=2>
				<table class="listStyle" id="oTable" name="oTable">
					<colgroup>
					<col width="3%">
					<col width="20%">
					<col width="20%">
					<col width="17%">
					<col width="20%">
					<col width="20%">
					<tr class="header">
						<td><input type="checkbox" name="chkAll" onClick="chkAllClick(this)"></td>
						<td><%=SystemEnv.getHtmlLabelName(18495,user.getLanguage())%></td>
						<td><%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%></td>
						<td><%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%></td>
						<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td>
						<td><%=SystemEnv.getHtmlLabelName(385,user.getLanguage())%></td>
					</tr>
					<tr class=Line style="height: 1px" ><td colspan=6 style="padding: 0px"></td></tr>
				</table>
			</td>
	   </tr>
	   <%} %>
	</TBODY>
</TABLE>
</form>
                    
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
				</wea:item>
			</wea:group>
		</wea:layout>
	
</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			   resizeDialog(document);
				jQuery("#showorgid").hide();
				jQuery("#showcustype").hide();
				jQuery("#showrolelevel").hide();
				jQuery("#showrolelevelname").hide();
		});
	</script>
<%} %>
 <jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>       
</body>
</html>

<SCRIPT LANGUAGE="JavaScript">

  function afterCallBack(e,data,name){
	  if(data && data.id != ""){
	     //$("#showrelatedsharename").html("");
	     $("input[name=relatedshareid]").val(data.id);
	  }else{
	     //$("#showrelatedsharename").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	     $("input[name=relatedshareid]").val("");
	  }
  }

function getBrowserUrlFn(){
	var thisvalue=parseInt($GetEle("sharetype").value);
	if(thisvalue==1){
		return "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+jQuery("#relatedshareid").val();
	}

	if(thisvalue==2){
 		return "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+jQuery("#relatedshareid").val();
	}
	if(thisvalue==3){
		return "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+jQuery("#relatedshareid").val();
	}
	if(thisvalue==4){
		return "/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp?selectedids="+jQuery("#relatedshareid").val();
	}

	if(thisvalue==6){
		return "/systeminfo/BrowserMain.jsp?url=/hrm/orggroup/HrmOrgGroupBrowser.jsp?selectedids="+jQuery("#relatedshareid").val();
	}
	if(thisvalue==10){
		return "/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp?selectedids="+jQuery("#relatedshareid").val();
	}


  	if(thisvalue==9){
  		return "/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="+jQuery("#relatedshareid").val();
	}
}

function getCompleteUrl(){
	var thisvalue=parseInt($GetEle("sharetype").value);
	if(thisvalue==1){
		return "/data.jsp";
	}
	if(thisvalue==2){
 		return "/data.jsp?type=164";
	}
	if(thisvalue==3){
		return "/data.jsp?type=4";
	}
	if(thisvalue==4){
		return "/data.jsp?type=65";
	}

	if(thisvalue==6){
		return "/data.jsp?type=hrmOrgGroup";
	}
    if(thisvalue==10){
  		return "/data.jsp?type=24";
	}

  	if(thisvalue==9){
  		return "/data.jsp?type=7";
	}
}

<!--

  function onChangeSharetype(){


	var thisvalue=$GetEle("sharetype").value;
	$GetEle("relatedshareid").value="";
	jQuery("#relatedshareidspan").html("");
	showEle("showseclevel");
	showEle("showobg");
	 hideEle("_joblevel");
	jQuery("#showorgid").hide();

	jQuery("#relatedshareidspanimg").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
    if(thisvalue!=4){
		jQuery("#showrolelevel").hide();
		jQuery("#showrolelevelname").hide();
		$GetEle("seclevel").value=10;
		jQuery("#showButton").hide();
    }

    if(thisvalue!=2||thisvalue!=3){
		jQuery("#showincludesub").hide();
    }
    if(thisvalue!=9){
		jQuery("#showButton").hide();	
    }
	  if(thisvalue!=-1){		
		jQuery("#showcustype").hide();
    }



	

    if(thisvalue==80||thisvalue==81||thisvalue==82||thisvalue==83||thisvalue==84||thisvalue==85||thisvalue==-80||thisvalue==-81||thisvalue==-82){
        jQuery("#relatedshareidspanimg").html("");
		hideEle("showobg");
        if (thisvalue==83||thisvalue==84||thisvalue==85) {
			$GetEle("seclevel").value=10;
		 $GetEle("seclevelmax").value=100;
			showEle("showseclevel");
        } else {
            hideEle("showseclevel");
        }
		if(thisvalue>=81){
		
		jQuery("#showorgid").show();		
		}
        jQuery("#showButton").hide();
	}else if(thisvalue==1){
		  hideEle("showseclevel");
		 $GetEle("seclevel").value=0;		 		
		 jQuery("#showButton").show();
	}else if(thisvalue==2){
		jQuery("#showincludesub").show();
 		$GetEle("seclevel").value=10;
		 $GetEle("seclevelmax").value=100;
 		jQuery("#showButton").show();
	}else if(thisvalue==3){
		jQuery("#showincludesub").show();
 		$GetEle("seclevel").value=10;
		$GetEle("seclevelmax").value=100;
 		jQuery("#showButton").show();
	}else if(thisvalue==10){
		  hideEle("showseclevel");
		 $GetEle("seclevel").value=0;	
		  jQuery("#showButton").show();
		 showEle("_joblevel");
	}else if(thisvalue==4){
		
		jQuery("#showrolelevel").show();
		jQuery("#showrolelevelname").show();
		$GetEle("seclevel").value=10;
		$GetEle("seclevelmax").value=100;
		jQuery("#showButton").show();
	}else if(thisvalue==5){
		hideEle("showobg");
		$GetEle("relatedshareidspan").innerHTML='';
        jQuery("#relatedshareidspanimg").html("");
		$GetEle("relatedshareid").value=-1;
		$GetEle("seclevel").value=10;
		$GetEle("seclevelmax").value=100;
		jQuery("#showButton").hide();
	}else if(thisvalue==6){
 		$GetEle("seclevel").value=10;
		$GetEle("seclevelmax").value=100;
 		jQuery("#showButton").show();
	}else if(thisvalue<0){
		if(thisvalue==-1){
		jQuery("#showcustype").show();
		
		}
	
		$GetEle("relatedshareidspan").innerHTML='';
        jQuery("#relatedshareidspanimg").html("");
		$GetEle("relatedshareid").value=-1;
		$GetEle("seclevel").value=10;
		$GetEle("seclevelmax").value=100;
		jQuery("#showButton").hide();
	}else if(thisvalue==9){
		hideEle("showseclevel");
    	$GetEle("seclevel").value=0;
    	jQuery("#showButton").show();
	}else{
		
		$GetEle("seclevel").value=10;
		$GetEle("seclevelmax").value=100;
		jQuery("#showButton").hide();
		
	}
}


function checkjoblevel(){

       if(jQuery("#joblevel  option:selected").val()=="2"){
		    jQuery("#jobsubcompanysapn").css("display","");
		   jQuery("#jobdepartment").closest("div.e8_os").css("display","none");
		}else if(jQuery("#joblevel  option:selected").val()=="3"){
		  jQuery("#jobsubcompanysapn").css("display","none");
		   jQuery("#jobdepartment").closest("div.e8_os").css("display","");
		}else{
		    jQuery("#jobsubcompanysapn").css("display","none");
		   jQuery("#jobdepartment").closest("div.e8_os").css("display","none");
		}
}

function removeValue(){
    var chks = document.getElementsByName("chkShareDetail");
    for (var i=chks.length-1;i>=0;i--){
        var chk = chks[i];
        if (chk.checked)
            oTable.deleteRow(chk.parentElement.parentElement.parentElement.rowIndex)
    }
}

function onSave(obj){

	thisvalue=$GetEle("sharetype").value;

   var shareTypeValue = thisvalue;
  
   var shareTypeText = $GetEle("sharetype").options.item($GetEle("sharetype").selectedIndex).text;


    //人力资源(1),分部(2),部门(3),具体客户(9),角色后的那个选项值不能为空(4)
    var relatedShareIds="0";
	
    var relatedShareNames="";
    if (thisvalue==1||thisvalue==2||thisvalue==3||thisvalue==4||thisvalue==9||thisvalue==6||thisvalue==10) {
        if(!check_form(document.weaver,'relatedshareid')) {
            return ;
        }
        if (thisvalue==4){
            if (!check_form(document.weaver,'seclevel')||!check_form(document.weaver,'seclevelmax'))
                return;
        }
		if (thisvalue==10){
			if($GetEle("joblevel").value=="2"){
                if (!check_form(document.weaver,'jobsubcompany'))
                return;
			}else if($GetEle("joblevel").value=="3"){
				 if (!check_form(document.weaver,'jobdepartment'))
                return;
			   
			}
        }
        relatedShareIds = $GetEle("relatedshareid").value;
        relatedShareNames= jQuery("#showrelatedsharename").val();
		

    }
	if(thisvalue==-1){	
		   shareTypeValue=jQuery("#custype").val();
           relatedShareIds=-1;
      }
    var orgid="0";
	var includesub="0";
    var secLevelValue="0";
	var secLevelValueMax="0";
    var secLevelText="";
    if (thisvalue!=1&&thisvalue!=-80&&thisvalue!=-81&&thisvalue!=-82&&thisvalue!=80&&thisvalue!=81&&thisvalue!=82&&thisvalue!=9&&thisvalue!=10) {
        secLevelValue = $GetEle("seclevel").value;
		secLevelValueMax =  $GetEle("seclevelmax").value;
        secLevelText=secLevelValue;
    }

   var rolelevelValue=0;
   var rolelevelText="";
   if (thisvalue==4){  //角色  0:部门   1:分部  2:总部
       rolelevelValue = $GetEle("rolelevel").value;
       rolelevelText=$GetEle("rolelevel").options.item($GetEle("rolelevel").selectedIndex).text;
   }

   if (thisvalue==81||thisvalue==82||thisvalue==84||thisvalue==85){
        orgid=jQuery("#orgid").val();
		
   }
   if (thisvalue==2||thisvalue==3){
	    if(jQuery("#includesub").attr("checked")){
	       includesub=1
	      }
		
   }



   var PsharelevelValue =  $GetEle("Psharelevel").value;
   var PsharelevelText = $GetEle("Psharelevel").options.item($GetEle("Psharelevel").selectedIndex).text;

   /**===TD12005 文档下载权限控制  开始====*/
    var selObj = $GetEle("Psharelevel");//选择控件对象
    var oVal = selObj.options[selObj.selectedIndex].value;//选中值
    var PdownloadlevelValue = 1;
    var PdownloadlevelText = '';
    if(oVal == 1) {
        var chkObj = $GetEle('chkPsharelevel');//复选框控件对象
        if (chkObj.checked == true) {
        	PdownloadlevelValue = 1;
        	PdownloadlevelText = '(' + '<%=SystemEnv.getHtmlLabelName(23733,user.getLanguage())%>' + ')';
        } else {
            PdownloadlevelValue = 0;
            PdownloadlevelText = '(' + '<%=SystemEnv.getHtmlLabelName(23734,user.getLanguage())%>' + ')';
        }
        PsharelevelText = PsharelevelText + PdownloadlevelText;
    }
   /**===TD12005 文档下载权限控制  结束====*/
   
   //共享类型 + 共享者ID +共享角色级别 +共享级别+共享权限+下载权限(TD12005)
   //var totalValue=shareTypeValue+"_"+relatedShareIds+"_"+rolelevelValue+"_"+secLevelValue+"_"+PsharelevelValue
   var totalValue=shareTypeValue+"_"+relatedShareIds+"_"+rolelevelValue+"_"+secLevelValue+"_"+PsharelevelValue+"_"+PdownloadlevelValue+"_"+secLevelValueMax+"_"+includesub+"_"+orgid;
   jQuery("#txtShareDetail").val(totalValue);
   <%if(browserType==1){%>
   		document.weaver.action="/docs/category/ShareOperation.jsp";
   <%}else{%>
   		//document.weaver.action="/docs/docs/DocShareUtilNew.jsp";
   		document.weaver.action="DocShareOperation.jsp?docid=<%=docid%>&blnOsp=<%=blnOsp%>"
   <%}%>
	   showLoading();
   document.weaver.submit();
}

function addValue(){
    thisvalue=$GetEle("sharetype").value;

   var shareTypeValue = thisvalue;
   var shareTypeText = $GetEle("sharetype").options.item($GetEle("sharetype").selectedIndex).text;
   var seclevelmain = $GetEle("seclevel").value;
   var seclevelmax = $GetEle("seclevelmax").value;;
   if(parseInt(seclevelmain)>parseInt(seclevelmax)){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82808,user.getLanguage())%>");
		return false;
	 }


    //人力资源(1),分部(2),部门(3),具体客户(9),角色后的那个选项值不能为空(4)
    var relatedShareIds="0";
    var relatedShareNames="";
    if (thisvalue==1||thisvalue==2||thisvalue==3||thisvalue==4||thisvalue==9||thisvalue==6) {
        if(!check_form(document.weaver,'relatedshareid')) {
            return ;
        }
        if (thisvalue==4){
            if (!check_form(document.weaver,'seclevel')||!check_form(document.weaver,'seclevelmax'))
                return;
        }
        relatedShareIds = $GetEle("relatedshareid").value;
        relatedShareNames= $GetEle("showrelatedsharename").innerHTML;
    }

    var secLevelValue="0";
    var secLevelText="";
    if (thisvalue!=1&&thisvalue!=-80&&thisvalue!=-81&&thisvalue!=-82&&thisvalue!=80&&thisvalue!=81&&thisvalue!=82) {
        secLevelValue = $GetEle("seclevel").value;
        secLevelText=secLevelValue;
    }

   var rolelevelValue=0;
   var rolelevelText="";
   if (thisvalue==4){  //角色  0:部门   1:分部  2:总部
       rolelevelValue = $GetEle("rolelevel").value;
       rolelevelText=$GetEle("rolelevel").options.item($GetEle("rolelevel").selectedIndex).text;
   }



   var PsharelevelValue =  $GetEle("Psharelevel").value;
   var PsharelevelText = $GetEle("Psharelevel").options.item($GetEle("Psharelevel").selectedIndex).text;

   /**===TD12005 文档下载权限控制  开始====*/
    var selObj = $GetEle("Psharelevel");//选择控件对象
    var oVal = selObj.options[selObj.selectedIndex].value;//选中值
    var PdownloadlevelValue = 1;
    var PdownloadlevelText = '';
    if(oVal == 1) {
        var chkObj = $GetEle('chkPsharelevel');//复选框控件对象
        if (chkObj.checked == true) {
        	PdownloadlevelValue = 1;
        	PdownloadlevelText = '(' + '<%=SystemEnv.getHtmlLabelName(23733,user.getLanguage())%>' + ')';
        } else {
            PdownloadlevelValue = 0;
            PdownloadlevelText = '(' + '<%=SystemEnv.getHtmlLabelName(23734,user.getLanguage())%>' + ')';
        }
        PsharelevelText = PsharelevelText + PdownloadlevelText;
    }
   /**===TD12005 文档下载权限控制  结束====*/
   
   //共享类型 + 共享者ID +共享角色级别 +共享级别+共享权限+下载权限(TD12005)
   //var totalValue=shareTypeValue+"_"+relatedShareIds+"_"+rolelevelValue+"_"+secLevelValue+"_"+PsharelevelValue
   var totalValue=shareTypeValue+"_"+relatedShareIds+"_"+rolelevelValue+"_"+secLevelValue+"_"+PsharelevelValue+"_"+PdownloadlevelValue

   var oRow = oTable.insertRow(-1);
   var oRowIndex = oRow.rowIndex;

   if (oRowIndex%2==0) oRow.className="dataLight";
   else oRow.className="dataDark";

   for (var i =1; i <=6; i++) {   //生成一行中的每一列


      oCell = oRow.insertCell(-1);
      var oDiv = document.createElement("div");
      if (i==1) oDiv.innerHTML="<input class='inputStyle' type='checkbox' name='chkShareDetail' value='"+totalValue+"'><input type='hidden' name='txtShareDetail' value='"+totalValue+"'>";
      else if (i==2) oDiv.innerHTML=shareTypeText;
      else  if (i==3) oDiv.innerHTML=relatedShareNames;
      else  if (i==4) oDiv.innerHTML=rolelevelText;
      else  if (i==5) {if (secLevelText=="0") secLevelText=""; oDiv.innerHTML=secLevelText;}
      else  if (i==6) oDiv.innerHTML=PsharelevelText;

      oCell.appendChild(oDiv);
   }
}

function chkAllClick(obj){
    var chks = document.getElementsByName("chkShareDetail");
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        chk.checked=obj.checked;
    }
}
//=====TD12005 文档下载权限控制  开始========//
function onOptionChange(selObjName) {
    var selObj = $GetEle(selObjName);//选择控件对象
    var oVal = selObj.options[selObj.selectedIndex].value;//选中值
    var chkObj = $GetEle('chk'+selObjName);//复选框控件对象
    var lblObj = $GetEle('lbl'+selObjName);//复选框控件对应标签对象

    if(oVal == 1) {//查看时显示  
        chkObj.style.display = '';
        lblObj.style.display = '';
        jQuery(chkObj).siblings("span.jNiceCheckbox").css("display","");
		jQuery(chkObj).siblings("span.jNiceCheckbox_disabled").css("display","");
    } else {
        chkObj.style.display = 'none';
        lblObj.style.display = 'none';
        jQuery(chkObj).siblings("span.jNiceCheckbox").css("display","none");
		jQuery(chkObj).siblings("span.jNiceCheckbox_disabled").css("display","none");
    }
}
function showLoading()
        {
            document.getElementById("over").style.display = "block";
            document.getElementById("layout").style.display = "block";
            removeRightClickMenu();
            parentWin.isclose = 1;
        }
function removeRightClickMenu(){
	if(jQuery("#modeTitle",_menuWindow.parent._menuDocument).length>0){
		jQuery("#modeTitle",_menuWindow.parent._menuDocument).parent().remove();
	}			
	try{
		_menuDocument.getElementById("rightMenu").remove();
	}catch(e){}
	jQuery(rightMenuStr).remove();
}
function doSave(obj){
	 var seclevelmain = $GetEle("seclevel").value;
   var seclevelmax = $GetEle("seclevelmax").value;;
   if(parseInt(seclevelmain)>parseInt(seclevelmax)){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82808,user.getLanguage())%>");
		return ;
	 }
		var thisvalue=$G("sharetype").value;
		if (thisvalue==1||thisvalue==2||thisvalue==3||thisvalue==4||thisvalue==6||thisvalue==9||thisvalue==10) {
			if(!check_form(document.weaver,'relatedshareid')) return;
	    if (thisvalue==2||thisvalue==3||thisvalue==4){
	    	if (!check_form(document.weaver,'seclevel')||!check_form(document.weaver,'seclevelmax')) return;
	    }  
	  }
	
    obj.disabled=true
     if (<%=browserType%>==1){ 
         document.weaver.action="/docs/category/ShareOperation.jsp"
         document.weaver.submit();
     }else{
     	onSave(obj);
        //document.weaver.action="DocShareOperation.jsp?docid=<%=docid%>&blnOsp=<%=blnOsp%>"
     }
}

function setRelatedName(e,datas,name,params){
	if(datas){
		jQuery("#showrelatedsharename").val(datas.name);
	}
}

//=====TD12005 文档下载权限控制  结束========//
//-->
</SCRIPT>

