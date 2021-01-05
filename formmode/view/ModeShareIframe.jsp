
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.formmode.setup.ModeRightForPage" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<%
//处理表单重复提交新增共享权限
String sessionToken = UUID.randomUUID().toString().replace("-", "");
request.getSession().setAttribute("sessionToken", sessionToken);

int modeId = Util.getIntValue(request.getParameter("modeId"),0);
int formId = Util.getIntValue(request.getParameter("formId"),0);
int billid = Util.getIntValue(request.getParameter("billid"),0);
int ajax = Util.getIntValue(request.getParameter("ajax"),0);
int MaxShare = Util.getIntValue(request.getParameter("MaxShare"),0);
String DefaultShared = "";//允许修改默认共享
String NonDefaultShared = "";//允许修改非默认共享

String sql = "select DefaultShared,NonDefaultShared from modeinfo where id = " + modeId;
rs.executeSql(sql);
while(rs.next()){
	DefaultShared = rs.getString("DefaultShared");
	NonDefaultShared = rs.getString("NonDefaultShared");
}
boolean showsave = false;
boolean showdel = false;
if(NonDefaultShared.equals("1")){
	showsave = true;
	showdel = true;
}else if(DefaultShared.equals("1")){
	showdel = true;
}

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = null;
var dialog = null;
try{
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
}catch(e){}
</script>
</HEAD>
<BODY>
<%
String imagefilename = "/images/hdCRMAccount_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16526,user.getLanguage());//权限设置
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	if(showsave){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(18645,user.getLanguage())+",javascript:doSave(this)',_top} " ;//添加共享
		RCMenuHeight += RCMenuHeightStep ;
	}
	if(showsave||showdel){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(18646,user.getLanguage())+",javascript:doDel(this)',_top} " ;//删除共享
		RCMenuHeight += RCMenuHeightStep ;
	}
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(15033,user.getLanguage())+",javascript:parent.dialog.close()',_top} " ;//关闭窗口
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(showsave){%>
				<input type="button" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(18645,user.getLanguage())%>" onclick="javascript:doSave(this)"/>
			<%}%>
			<%if(showsave||showdel){%>
				<input type="button" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(18646,user.getLanguage())%>" onclick="javascript:doDel(this)"/>
			<%}%>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>

<FORM id=weaver name=weaver action="/formmode/view/ModeShareOperation.jsp" method=post>
  <input type="hidden" name="method" value="addShare">
  <input type="hidden" name="modeId" value="<%=modeId%>">
  <input type="hidden" name="billid" value="<%=billid%>">
  <input type="hidden" name="MaxShare" value="<%=MaxShare%>">
  <input type="hidden" name="relatedid" id="relatedid" value="">
  <input type="hidden" name="token" id="token" value="<%=sessionToken%>">
  <table class="e8_tblForm">
    <COLGROUP>
		<COL width="20%">
  		<COL width="80%">
    </COLGROUP>
    <TBODY>
    
	<%
		if(showsave){
	%>    
     <TR><!-- 共享类型 -->
       <TD class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(18495,user.getLanguage())%></TD>
       <TD class="e8_tblForm_field">
         <SELECT class=InputStyle  name=sharetype onChange="onChangeSharetype()" >  
           <option value="1" selected><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option> <!-- 人员 -->
           <option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option><!-- 分部 -->
           <option value="3"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option><!-- 部门 -->
           <option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option><!-- 角色 -->
           <option value="5"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option><!-- 所有人 -->
           <option value="6"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></option><!-- 岗位 -->
         </SELECT>
         
         <span id="orgrelationspan" style="display:none;width: 220px;" >
         <select class=InputStyle id="orgrelation" name="orgrelation" onchange="" style="width: 80px;">
         	<option value=""></option>
         	<option value="1"><%=SystemEnv.getHtmlLabelName(15762,user.getLanguage())%></option><!-- 所有上级 -->
         	<option value="2"><%=SystemEnv.getHtmlLabelName(15765,user.getLanguage())%></option><!-- 所有下级 -->
         </select>
         </span>
       </TD>
     </TR>
     <tr id="tr_virtualtype" style="display: none">
     	<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(34069, user.getLanguage()) %></td>
     	<td class="e8_tblForm_field">
     		<select id="HrmCompanyVirtual" name="HrmCompanyVirtual">
     			<option value="0"><%=SystemEnv.getHtmlLabelName(83179, user.getLanguage()) %></option>
     			<%
     				rs.executeSql("select * from HrmCompanyVirtual  where (canceled is null or canceled<>1) order by showorder");
     				while(rs.next()){
     					String id = Util.null2String(rs.getString("id"));
     					String companyname = Util.null2String(rs.getString("companyname"));
     			 %>
     			 <option value="<%=id%>"><%=companyname %></option>
     			 <%} %>
     		</select>
     	</td>
     </tr>
     <TR id="browserTr">
     	<TD class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%><!-- 选择 --></TD>
     	<TD class="e8_tblForm_field">
     		<span id="showspan1">
         	<brow:browser viewType="0" name="relatedid1" browserValue="" browserOnClick="" 
         		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" 
         		hasInput="true"  width="50%" isSingle="false" hasBrowser="true" completeUrl="/data.jsp?type=1" browserSpanValue="" isMustInput="2">
         	</brow:browser>
         </span>
         <span id="showspan2" style="display:none;">
         	<brow:browser viewType="0" name="relatedid2" browserValue="" browserOnClick="" 
         		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids=&selectedDepartmentIds=" 
         		hasInput="true"  width="50%" isSingle="false" hasBrowser="true" completeUrl="/data.jsp?type=164" browserSpanValue="" isMustInput="2">
         	</brow:browser>
         </span>
         <span id="showspan3" style="display:none;">
         	<brow:browser viewType="0" name="relatedid3" browserValue="" browserOnClick="" 
         		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" 
         		hasInput="true"  width="50%" isSingle="false" hasBrowser="true" completeUrl="/data.jsp?type=4" browserSpanValue="" isMustInput="2">
         	</brow:browser>
         </span>
         <span id="showspan4" style="display:none;">
         	<brow:browser viewType="0" name="relatedid4" browserValue="" browserOnClick="" 
         		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp" 
         		hasInput="true"  width="50%" isSingle="true" hasBrowser="true" completeUrl="/data.jsp?type=65" browserSpanValue="" isMustInput="2">
         	</brow:browser>
         </span>
         <span id="showspan6" style="display:none;">
         	<brow:browser viewType="0" name="relatedid6" browserValue="" browserOnClick="" 
         		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp" 
         		hasInput="true"  width="50%" isSingle="false" hasBrowser="true" completeUrl="/data.jsp?type=24" browserSpanValue="" isMustInput="2">
         	</brow:browser>
         </span>
     	</TD>
     </TR>
     
     <TR id="isRoleLimitedTr" style="display: none;" >
     	<TD class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(82385,user.getLanguage())%></TD><!-- 角色是否受范围限制 -->
     	<TD class="e8_tblForm_field">
     		<table style="width: 100%;">
     			<colgroup>
		   			<col style="width: 20%"  />
		   			<col style="width: 35%"  />
		   			<col style="width: 15%"  />
		   			<col style="width: 30%"  />
		   		</colgroup>
     			<tr>
     				<td>
	     				<SELECT id="isRoleLimited"  name="isRoleLimited" style="width:60px;" onchange="changeRoleLimited()">
				           <option value="0"><%=SystemEnv.getHtmlLabelName(30587,user.getLanguage())%></option><!-- 否 -->
				           <option value="1"><%=SystemEnv.getHtmlLabelName(30586,user.getLanguage())%></option><!-- 是 -->
				       </SELECT>
			       </td>
     				<td id="isRoleLimitedTd2" style="display: none;">
					         <span><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></span><!-- 字段类型 -->
					         <select class=InputStyle id="rolefieldtype" name="rolefieldtype" onchange="roleFieldTypeChange()" >
					         	<option value="1"><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option>
					         	<option value="2"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
					         	<option value="3"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
					         </select>
     				</td>
     				<td id="isRoleLimitedTd3" style="display: none;"><%=SystemEnv.getHtmlLabelName(82386,user.getLanguage())%></td><!-- 限制字段 -->
     				<td id="isRoleLimitedTd4" style="display: none;">
	     				<brow:browser viewType="0" name="rolefield" browserValue="" browserOnClick="" getBrowserUrlFn="rolefiledChange" 
			         		hasInput="false"  width="260px;" isSingle="false" hasBrowser="true" completeUrl="/data.jsp" browserSpanValue="" isMustInput="2">
			         	</brow:browser>
     				</td>
     			</tr>
     		</table>
     	</TD>
     </TR>
     <!-- 角色级别 -->
     <TR id=rolelevel_tr name=id=rolelevel_tr style="display:none">
       <TD class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%></td>
       <TD class="e8_tblForm_field">
           <SELECT  name=rolelevel>
	           <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%><!-- 部门 -->
	           <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%><!-- 分部 -->
	           <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%><!-- 总部 -->
	       </SELECT>
       </td>
     </TR>
     <!-- 岗位级别 -->
     <TR id=joblevel_tr name=id=joblevel_tr style="display:none">
       <td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(28169,user.getLanguage())%></td>
       <TD class="e8_tblForm_field">
           <SELECT  name=joblevel style="width:100px;float: left;" onchange="onJoblevelChange();">
	           <option value="0"><%=SystemEnv.getHtmlLabelName(19438,user.getLanguage())%><!-- 部门 -->
	           <option value="1"><%=SystemEnv.getHtmlLabelName(19437,user.getLanguage())%><!-- 分门 -->
	           <option value="2" selected><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%><!-- 总部 -->
	       </SELECT>
	       <span id="joblevel_1" style="display:none;">
         	<brow:browser viewType="0" name="jobleveltext1" browserValue="" browserOnClick="" 
         		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids=&selectedDepartmentIds=" 
         		hasInput="true"  width="31%" isSingle="false" hasBrowser="true" completeUrl="/data.jsp?type=164" browserSpanValue="" isMustInput="2">
         	</brow:browser>
         	</span>
       	 	<span id="joblevel_0" style="display:none;">
         	<brow:browser viewType="0" name="jobleveltext0" browserValue="" browserOnClick="" 
         		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" 
         		hasInput="true"  width="31%" isSingle="false" hasBrowser="true" completeUrl="/data.jsp?type=167" browserSpanValue="" isMustInput="2">
         	</brow:browser>
         	</span>
         	<input type="hidden" id="jobleveltext" name="jobleveltext" value=""/>
       </td>
     </TR>
     <!-- 安全级别 -->
     <TR  id=showlevel_tr name=showlevel_tr style="display:none;height: 1px">
      <TD class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></TD>
       <TD class="e8_tblForm_field">
       	 <INPUT type=text name="showlevel" id="showlevel" onblur="checkLevel('showlevel','showlevel2',this)" class=InputStyle size=6 value="10" onchange='checkinput("showlevel","showlevelimage")' onKeyPress="ItemCount_KeyPress()">
         <span id=showlevelimage></span>-
         <INPUT type=text name="showlevel2" id="showlevel2" onblur="checkLevel('showlevel','showlevel2',this)" class=InputStyle size=6 value=""  onKeyPress="ItemCount_KeyPress()">
       </TD>
     </TR>
     <!-- 权限项 -->
     <TR>
       <TD class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(440,user.getLanguage())%></td>
       <TD class="e8_tblForm_field">
         <SELECT class=InputStyle  name=righttype >
	         <option value="1"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option>
	         <%if(MaxShare > 1){ %>
			 <option value="2"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option>
			 <%}if(MaxShare > 2){ %>
			 <option value="3"><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option>
			 <%} %>
		 </SELECT>
       </TD>
     </TR>
     <%
     	} 
     %>
     
	<%
     	if(showsave||showdel){ 
	%>
	     <TR>
	       <TD colspan=2><br/>
	         <TABLE  width="100%">
	           <TR>
	     		<TD width="*" style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(26137,user.getLanguage())%><!-- 共享权限 --></TD>
	        	<TD width="300px" align="right" style="padding-right: 10px;">
				<%
	     			if(showsave){ 
				%>        	
	        			<button
					      	type="button"
					      	id="savebutton" name="savebutton"
					      	title="<%=SystemEnv.getHtmlLabelName(18645,user.getLanguage())%>" 
					      	class="addbtn2" 
					      	onClick="doSave(this)"></button> <!-- 添加共享 -->
				<%
	     			}
	     			if(showsave||showdel){ 
				%>
	        			<button
					      	type="button"
					      	id="delbutton" name="delbutton"
					      	title="<%=SystemEnv.getHtmlLabelName(18646,user.getLanguage())%>" 
					      	class="deletebtn2" 
					      	onClick="doDel(this)"></button><!-- 删除共享 --></TD>
	        	<%
	     			}
	        	%>
	           </TR>
	         </TABLE>
	       </TD>
	     </TR>
     <%
     	} 
     %>
     
     <tr>
       <td colspan=2>
         <table class="listStyle" id="oTable" name="oTable" style="margin-top: 5px;">
             <colgroup>
             <col width="3%">
             <col width="15%">
             <col width="15%">
             <col width="20%">
             <col width="30%">
             <!-- col width="20%">-->
             <col width="15%">
             </colgroup>
             <tr class="header">
                 <th><input type="checkbox" name="chkAll" onClick="chkAllClick(this)"></th>
                 <th><%=SystemEnv.getHtmlLabelName(31248,user.getLanguage())%></th><!-- 共享来源 -->
                 <th><%=SystemEnv.getHtmlLabelName(18495,user.getLanguage())%></th><!-- 共享类型 -->
                 <th><%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%></th><!-- 共享级别 -->
                 <th><%=SystemEnv.getHtmlLabelName(19117,user.getLanguage())%></th><!-- 共享对象 -->
                 <!-- th><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></th> -->
                 <th><%=SystemEnv.getHtmlLabelName(385,user.getLanguage())%></th><!-- 权限 -->
             </tr>
             <tr class=Line style="height: 1px" ><td colspan=6 style="padding: 0px"></td></tr>
			<%
				ModeRightForPage ModeRightForPage = new ModeRightForPage();
		       	rs.executeSql("select * from modeDataShare_"+modeId+"_set where sourceid="+billid+" order by isDefault desc,ID asc");
		        rs3.executeSql("select * from modeDataShare_"+modeId+" where sourceid="+billid+" order by isDefault desc,requestid asc,ID asc");
                HashMap shareMap = new HashMap();
                while(rs3.next()){
                 shareMap.put(rs3.getString("setid"),"");
                }
		       	while(rs.next()){
		       		//Sharetype共享类型 1、人员；2、分部；3、部门；4、角色;5、所有人；80、创建人本身 81、创建人直接上级 84、创建人同分部 85、创建人同部门 89创建人所有上级
		       		String id = rs.getString("id");
		       		boolean setHave=shareMap.containsKey(id);
                    if(!setHave){continue;}
		       		String shareTypeValue = rs.getString("sharetype");
		       		String isdefault = rs.getString("isdefault");//1 默认共享，0非默认共享
		       		String rolelevelValue = rs.getString("rolelevel");
		       		String content = rs.getString("relatedid");	
		       		String showlevelValue = rs.getString("showlevel");	//Showlevel 安全级别type=1时此处为0
		       		String showlevel2 = rs.getString("showlevel2");	//
		       		String sharelevel = rs.getString("righttype");//Righttype 共享级别1、查看；2、编辑；3、完全控制
		       		String isrolelimited = rs.getString("isrolelimited");//是否受角色范围控制
		       		String higherlevel = rs.getString("higherlevel"); //创建人上级关系
		       		String requestid = rs.getString("requestid"); //流程id
		       		String hrmCompanyVirtualType = rs.getString("hrmCompanyVirtualType");//多维度组织
		       		String orgrelation = rs.getString("orgrelation");
		       		String joblevel = rs.getString("joblevel");
		       		String jobleveltext = rs.getString("jobleveltext");
		       		ModeRightForPage.setSetid(id);
		       		if(shareTypeValue.equals("4")&&isrolelimited.equals("1")){//角色受范围限制时，单独处理
		       			Map map = ModeRightForPage.getRightShowTextByRole(user,modeId,billid,isdefault,shareTypeValue,content,rolelevelValue,showlevelValue,sharelevel,id,showlevel2,hrmCompanyVirtualType);
		       			if(map.size()>0){
			       			String shareTypeText = Util.null2String(map.get("shareTypeText"));
				       		String righttypelText = Util.null2String(map.get("righttypelText"));
				       		String showlevelText = Util.null2String(map.get("showlevelText"));
				       		String isdefaulttext = Util.null2String(map.get("isdefaulttext"));
				       		String sharelevelText = Util.null2String(map.get("sharelevelText"));
				       		String name = Util.null2String(map.get("name"));
				       		
							boolean showcheckbox = false;
				       		if(DefaultShared.equals("1")&&isdefault.equals("1")){//默认共享
				       			showcheckbox = true;
				       		}
				       		if(NonDefaultShared.equals("1")&&isdefault.equals("0")){//非默认共享
				       			showcheckbox = true;
				       		}
			       			%>
			       			<tr>
								<td>
									<%
										if(showcheckbox){
									%>
											<input class='inputStyle' type='checkbox' id='share_set_id' name='share_set_id' value='<%=id%>'>
									<%
										}
				       				%>
								</td>
				       		  	<td><%=isdefaulttext%></td>
				       		  	<td><%=shareTypeText%></td>
				       		  	<td><%=sharelevelText%></td>
				       		  	<td><%=name%></td>
				       		  	<!--
				       		  	<td><%=showlevelText %></td>
				       		  	-->
				       		  	<td><%=righttypelText%></td>
				       		</tr>
			       			
			       			<%
		       			}
		       		}else{
			       		ModeRightForPage.getRightShowText(user,modeId,billid,isdefault,shareTypeValue,content,rolelevelValue,showlevelValue,sharelevel,higherlevel,showlevel2,hrmCompanyVirtualType,orgrelation,joblevel,jobleveltext);
			       		//Sharetype共享类型 1、人员；2、分部；3、部门；4、角色;5、所有人；80、创建人本身 81、创建人直接上级 84、创建人同分部 85、创建人同部门
			       		String shareTypeText = ModeRightForPage.getShareTypeText();
			       		String relatedShareNames = ModeRightForPage.getRelatedShareText();
			       		String righttypelText = ModeRightForPage.getRighttypelText();
			       		String showlevelText = ModeRightForPage.getShowlevelText();
			       		String isdefaulttext = ModeRightForPage.getIsdefaulttext();
			       		String sharelevelText = ModeRightForPage.getSharelevelText();
	       				
			       		boolean showcheckbox = false;
			       		
			       		if(DefaultShared.equals("1")&&isdefault.equals("1")){//默认共享
			       			showcheckbox = true;
			       		}
			       		if(NonDefaultShared.equals("1")&&isdefault.equals("0")){//非默认共享
			       			showcheckbox = true;
			       		}
			       		if("0".equals(isdefault)&&(!"".equals(requestid)&&!"0".equals(requestid))){
			       			isdefaulttext=SystemEnv.getHtmlLabelName(125272,user.getLanguage());;
			       		}
		       		
			%>
		       		<tr>
						<td>
							<%
								if(showcheckbox){
							%>
									<input class='inputStyle' type='checkbox' id='share_set_id' name='share_set_id' value='<%=id%>'>
							<%
								}
		       				%>
						</td>
		       		  	<td><%=isdefaulttext%></td>
		       		  	<td><%=shareTypeText%></td>
		       		  	<td><%=sharelevelText%></td>
		       		  	<td><%=relatedShareNames%></td>
		       		  	<!--
		       		  	<td><%=showlevelText %></td>
		       		  	-->
		       		  	<td><%=righttypelText%></td>
		       		</tr>
			<%
		       		}
		       	}
			%>
         </table>
       </td>
  	  </tr>
    </TBODY>
  </TABLE>
</FORM>

<script language=javascript>
function onChangeSharetype(){
	var thisvalue=$GetEle("sharetype").value;
    var strAlert= ""
    $("span[id^='showspan']").css('display','none');
	if(thisvalue==1 || thisvalue==2 || thisvalue==3 || thisvalue==4 || thisvalue==6){//需要浏览框
		$GetEle("browserTr").style.display = '';
		$GetEle("showspan"+thisvalue).style.display='';	//浏览框
		$GetEle("relatedid").value="";
	}else{
		$GetEle("browserTr").style.display = 'none';
	}
	if(thisvalue==6){
		jQuery("#joblevel_tr").show();
	}else{
		jQuery("#joblevel_tr").hide();
	}
	var isRoleLimitedTr = jQuery("#isRoleLimitedTr");
	
	if(thisvalue != 4){
		$GetEle("rolelevel_tr").style.display='none';	//角色级别	
		isRoleLimitedTr.hide();
	}else{
		$GetEle("rolelevel_tr").style.display='';	//需要角色级别
		changeRoleLimited();
	}
	if(thisvalue == 1){//人员不需要安全级别
		$GetEle("showlevel_tr").style.display='none';	//安全级别
	}else{
		$GetEle("showlevel_tr").style.display='';	//安全级别
	}
	changeOrgRelationShow();
}
function onJoblevelChange(){
	var joblevel = $GetEle("joblevel").value;
	jQuery("#jobleveltext").val('');
	if(joblevel=='0'){//指定部门
		jQuery("#joblevel_0").show();
		jQuery("#joblevel_1").hide();
	}else if(joblevel=='1'){//指定分部
		jQuery("#joblevel_1").show();
		jQuery("#joblevel_0").hide();
	}else{//总部
		jQuery("#joblevel_0").hide();
		jQuery("#joblevel_1").hide();
	}
}
var isNeedOrgRelation = false;//是否需要组织关系
function changeOrgRelationShow(){
	var sharetype = $("select[name=sharetype]").val();
	if(sharetype==3||sharetype==2){//部门     分部
		isNeedOrgRelation = true;
	}else{
		isNeedOrgRelation = false;
	}
	$("#orgrelation").selectbox("detach");
	$("#orgrelation").val("");
	$("#orgrelation").selectbox("attach");
	if(isNeedOrgRelation){
		$("#orgrelationspan").show();
	}else{
		$("#orgrelationspan").hide();
	}
}

function checkLevel(befEleName,aftEleName,obj){
	var bef = jQuery("[name="+befEleName+"]");
	var aft = jQuery("[name="+aftEleName+"]");
	if(isNaN(bef.val())){
		bef.val("");
	}
	if(isNaN(aft.val())){
		aft.val("");
	}
	if(bef.val()==""&&aft.val()!=""){
		if(aft.val()<10){
			bef.val(aft.val());
			checkinput("showlevel","showlevelimage");
			return;
		}else{
			bef.val("10");
			checkinput("showlevel","showlevelimage");
		}
		
	}
	if(bef.val()==""||aft.val()==""){
		return;
	}
	if(parseInt(bef.val())>parseInt(aft.val())){
		obj.value = "";
		if(obj.name==befEleName){
			bef.val(aft.val());
			checkinput("showlevel","showlevelimage");
		}else{
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(82808,user.getLanguage())%>");
		}
	}
}

function changeRoleLimited(){
	var isRoleLimitedTr = jQuery("#isRoleLimitedTr");
	
	var isRoleLimitedTd2 = jQuery("#isRoleLimitedTd2");
	var isRoleLimitedTd3 = jQuery("#isRoleLimitedTd3");
	var isRoleLimitedTd4 = jQuery("#isRoleLimitedTd4");
	
	var isRoleLimited = jQuery("#isRoleLimited");
	isRoleLimitedTr.show();
	if(isRoleLimited.val()==1){
		isRoleLimitedTd2.show();
		isRoleLimitedTd3.show();
		isRoleLimitedTd4.show();
	}else{
		isRoleLimitedTd2.hide();
		isRoleLimitedTd3.hide();
		isRoleLimitedTd4.hide();
	}
	changeRolelevelShow();
}

function roleFieldTypeChange(){
	var relatedid1001 = jQuery("#rolefield");
	var relatedid1001span = jQuery("#rolefieldspan");
	var relatedid1001spanimg = jQuery("#rolefieldspanimg");
	
	relatedid1001.val("");
	relatedid1001span.html("");
	relatedid1001spanimg.html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	changeRolelevelShow();
}

function changeRolelevelShow(){
	var isRoleLimited = jQuery("#isRoleLimited").val();
	var rolelevel_tr = jQuery("#rolelevel_tr");
	var rolefieldtype = jQuery("#rolefieldtype").val();
	var sharetype = jQuery("[name=sharetype]").val();
	if(sharetype!=4){
		rolelevel_tr.hide();
		return;
	}
	if(sharetype==4&&isRoleLimited==0){
		rolelevel_tr.show();
		return;
	}
	
	if(sharetype==4&&isRoleLimited==1&&rolefieldtype==1){
		rolelevel_tr.show();
		return;
	}else{
		rolelevel_tr.hide();
		return;
	}
	
}

function rolefiledChange(){
    var tmpval = $GetEle("rolefieldtype").value;
    var selectedids = $GetEle("rolefield").value;
	var tempurl1 = "/systeminfo/BrowserMain.jsp?url=/formmode/setup/MultiFormmodeShareFieldBrowser.jsp?type="+tmpval+"&selectedids="+selectedids+"&modeId=<%=modeId%>&isRoleLimited=1";
	return tempurl1;
}

function chkAllClick(obj){
    var chks = document.getElementsByName("share_set_id");
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        changeCheckboxStatus(chk, obj.checked);
    }
}

function doSave(obj){
	var thisvalue=$GetEle("sharetype").value;
	var isRoleLimited = jQuery("#isRoleLimited").val();
	
	if(thisvalue==1 || thisvalue==2 || thisvalue==3 || thisvalue==4 || thisvalue==6){//需要浏览框
		$GetEle("relatedid").value = $GetEle("relatedid"+thisvalue).value;
		if($GetEle("relatedid").value==""){
			Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>！");//必要信息不完整
			return false;
		}
		
		if(thisvalue==4){
	       	if(isRoleLimited==1){
	       		 if (jQuery("#rolefield").val()==''){
		            Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>！");//必要信息不完整
					return false;
		        }
	       	}
		}
		if(thisvalue == 6){
	    	joblevel = $GetEle("joblevel").value;
	    	if(joblevel=='0'||joblevel=='1'){
	    		jobleveltext = $GetEle("jobleveltext"+joblevel).value;
	    		$GetEle("jobleveltext").value = jobleveltext;
		    	if (!check_form(document.weaver,'jobleveltext')){
		            return;
		        }
	    	}else{
	    		$GetEle("jobleveltext").value = '';
	    	}
	    }
	}
	if(thisvalue==4&&isRoleLimited==1){
		var role = jQuery("#relatedid4").val();
		var rolefieldtype = jQuery("#rolefieldtype").val();
		var rolefield = jQuery("#rolefield").val();
		var rolelevel = jQuery("[name=rolelevel]").val();
		var showlevel = jQuery("[name=showlevel]").val();
		var showlevel2 = jQuery("[name=showlevel2]").val();
		jQuery.ajax({
		   type: "POST",
		   url: "/formmode/view/ModeShareAjax.jsp?method=checkRoleCondition&modeId=<%=modeId%>&billid=<%=billid%>",
		   dataType:"json",
		   data: "role="+role+"&rolefieldtype="+rolefieldtype+"&rolefield="+rolefield+"&rolelevel="+rolelevel+"&showlevel="+showlevel+"&showlevel2="+showlevel2,
		   success: function(data){
		     if(data&&data.canadd){
		    	 obj.disabled=true;
			    disabledButton();
			    $GetEle("method").value = "addShare";
			    weaver.submit();
		     }else{
		    	 Dialog.alert("<%=SystemEnv.getHtmlLabelName(82469,user.getLanguage())%>");//按照你的限制条件，在角色中没有满足条件的人员！
		     }
		   }
		});
	}else{
	    obj.disabled=true;
	    disabledButton();
	    $GetEle("method").value = "addShare";
	    weaver.submit();
	}
}

function doDel(obj){
	var havechecked = false;
    var chks = document.getElementsByName("share_set_id");
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        if(chk.checked){
        	havechecked = true;
		}
    }
	if(!havechecked){
		Dialog.alert("<%=SystemEnv.getHtmlLabelName(31251,user.getLanguage())%>");//请先选择需要删除的权限项！
		return;
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(31250,user.getLanguage())%>",function(){  //确认需要删除这些共享吗？
		obj.disabled=true;
	    disabledButton();
	    $GetEle("method").value = "delShare";
	    weaver.submit();
	});
}
function disabledButton(){
	if($GetEle("savebutton")!=null){
		$GetEle("savebutton").disabled=true;
	}
	if($GetEle("delbutton")!=null){
		$GetEle("delbutton").disabled=true;
	}
	enableAllmenu();
}
</script>

</BODY>
</HTML>
