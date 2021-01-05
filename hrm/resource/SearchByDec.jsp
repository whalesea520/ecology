<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.workflow.browserdatadefinition.ConditionField"%> 
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>


</HEAD>

<body>
<%
String f_weaver_belongto_userid=Util.fromScreen(request.getParameter("f_weaver_belongto_userid"),user.getLanguage());
String f_weaver_belongto_usertype=Util.fromScreen(request.getParameter("f_weaver_belongto_usertype"),user.getLanguage());
String bdf_wfid = Util.null2String(request.getParameter("bdf_wfid"));
String bdf_fieldid = Util.null2String(request.getParameter("bdf_fieldid"));
String bdf_viewtype = Util.null2String(request.getParameter("bdf_viewtype"));
List<ConditionField> lsConditionField = null;
if(bdf_wfid.length()>0){
	lsConditionField = ConditionField.readAll(Util.getIntValue(bdf_wfid),Util.getIntValue(bdf_fieldid),Util.getIntValue(bdf_viewtype));
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1867,user.getLanguage());
String needfav ="1";
String needhelp ="";

int uid=user.getUID();
int tabid=0;

String nodeid=null;
String rem=null;
        Cookie[] cks= request.getCookies();
        
        for(int i=0;i<cks.length;i++){
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if(cks[i].getName().equals("decresourcemulti"+uid)){
        rem=cks[i].getValue();
        break;
        }
        }
if(rem!=null){
rem=tabid+rem.substring(1);
Cookie ck = new Cookie("decresourcemulti"+uid,rem);  
ck.setMaxAge(30*24*60*60);
response.addCookie(ck);

String[] atts=Util.TokenizerString2(rem,"|");
if(atts.length>1)
nodeid=atts[1];
}

//组合查询不接收条件
String sqlwhere ="";// Util.null2String(request.getParameter("sqlwhere"));
String status ="";// Util.null2String(request.getParameter("status"));
String check_per = Util.null2String(request.getParameter("resourceids"));

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

String isdetail = Util.null2String(request.getParameter("isdetail"));
String isbill = Util.null2String(request.getParameter("isbill"));
String fieldid = Util.null2String(request.getParameter("fieldid"));
String detachable = Util.null2String(request.getParameter("detachable"));

%>
	<FORM id=SearchForm NAME=SearchForm STYLE="margin-bottom:0" action="MultiSelectByDec.jsp" method=post target="frame2">
	<input type="hidden" name="isinit" value="1"/>
	
	<input type="hidden" name="isdetail" value="<%=isdetail %>"/>
	<input type="hidden" name="isbill" value="<%=isbill %>"/>
	<input type="hidden" name="fieldid" value="<%=fieldid %>"/>
	<input type="hidden" name="detachable" value="<%=detachable %>"/>
	
	<input type="hidden" name="f_weaver_belongto_userid" value="<%=f_weaver_belongto_userid %>"/>
	<input type="hidden" name="f_weaver_belongto_usertype" value="<%=f_weaver_belongto_usertype %>"/>
	
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
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:btnsearch_onclick(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:document.SearchForm.btnok.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:document.SearchForm.btncancel.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
	<BUTTON class=btnSearch accessKey=S style="display:none" id="btnsearch" onclick="btnsearch_onclick();"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
	<BUTTON class=btnReset accessKey=T style="display:none" id=reset type="button" onclick="reset_onclick();"><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
	<!-- 2012-08-15 ypc 修改 添加了btnok_onclick() 事件 -->
	<BUTTON class=btn accessKey=O style="display:none" id=btnok onclick="btnok_onclick();"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
	<BUTTON class=btnReset accessKey=T style="display:none" id=btncancel onclick="btncancel_onclick()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
	<!-- 2012-08-15 ypc 修改 添加了btnok_onclick() 事件 -->
	<BUTTON class=btn accessKey=2 style="display:none" id=btnclear onclick="btnclear_onclick();"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script>
rightMenu.style.visibility='hidden'
</script>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="btnsearch_onclick();" value="<%=SystemEnv.getHtmlLabelName(197, user.getLanguage())%>"></input>
		  <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%if(lsConditionField!=null && lsConditionField.size()>0){ 
	Hashtable<String,String> htHide = new Hashtable<String,String>();
%>
  <wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
  <%
	for(ConditionField conditionField: lsConditionField){
		boolean isHide = conditionField.isHide();
		//if(isHide)continue;
		boolean isReadonly = conditionField.isReadonly();
		String filedname = conditionField.getFieldName();
		String valuetype = conditionField.getValueType();
		boolean isGetValueFromFormField = conditionField.isGetValueFromFormField();
		String filedvalue = "";
		if(isGetValueFromFormField){
			//表单字段 bdf_fieldname
			filedvalue = Util.null2String(request.getParameter(filedname));
			/*
			if(filedvalue.length()>0){
				filedvalue = Util.TokenizerString2(filedvalue,",")[0];
				if(filedname.equals("subcompanyid")){
					filedvalue = conditionField.getSubcompanyIds(filedvalue);
				}else if(filedname.equals("departmentid")){
					filedvalue = conditionField.getDepartmentIds(filedvalue);
				}
			}*/
		}else{
			if(valuetype.equals("1")){
				//当前操作者所属
				if(filedname.equals("subcompanyid")){
					filedvalue = ""+ResourceComInfo.getSubCompanyID(""+user.getUID());
				}else if(filedname.equals("departmentid")){
					filedvalue = ""+ResourceComInfo.getDepartmentID(""+user.getUID());
				}
			}else{
				//指定字段
				filedvalue = conditionField.getValue();
			}
		}
		if(isHide){
			//隐藏域要显示
			if(filedname.equals("status")&&filedvalue.equals("8"))filedvalue="";
			htHide.put(filedname,filedvalue);
			continue;
		}
		//姓名 状态 分部 部门 岗位 角色
		if(filedname.equals("lastname")){
		%>
			<wea:item><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></wea:item>
			<wea:item><input class=inputstyle name=lastname <%=isReadonly?"readonly":"" %> value='<%=filedvalue %>'></wea:item>
		<%
		}else if(filedname.equals("status")){
		%>
			<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
			<wea:item>
				<%if(isReadonly){ %>
				<input type="hidden" id=status name=status value="<%=filedvalue.equals("8")?"":filedvalue %>">
				<%}%>
		    <select class=inputstyle id=status name=status <%=isReadonly?"disabled":"" %>>
		    <%
		    List<String> lsList = conditionField.getCanSelectValueList();
		   	for(String option:lsList){
		   		%>
		   		<option value="<%=option.equals("8")?"":option %>" <%=filedvalue.endsWith(option)?"selected":"" %>><%=ResourceComInfo.getStatusName(Util.getIntValue(option),user) %></option>
		   		<%	
		   	}
		   %>
		   </select>
			</wea:item>
		<%
		}else if(filedname.equals("subcompanyid")){
			String isMustInput = isReadonly?"0":"1";
		%>
			<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="subcompanyid" browserValue='<%=filedvalue %>' 
        browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids="
        hasInput="true" isSingle="false" hasBrowser="true" isMustInput='<%=isMustInput %>'
        completeUrl="/data.jsp?type=164"
        _callback="jsSubcompanyCallback" browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(filedvalue) %>'>
      </brow:browser>
			</wea:item>
		<%
		}else if(filedname.equals("departmentid")){
			String isMustInput = isReadonly?"0":"1";
		%>
			<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
			<wea:item>
			  <brow:browser viewType="0" name="departmentid" browserValue='<%=filedvalue %>' 
        browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="
        hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='<%=isMustInput %>'
        completeUrl="/data.jsp?type=4"
        _callback="jsDepartmentCallback" browserSpanValue='<%=DepartmentComInfo.getDepartmentname(filedvalue) %>'>
      </brow:browser>
			</wea:item>
		<%
		}else if(filedname.equals("jobtitle")){
			String isMustInput = isReadonly?"0":"1";
		%>
			<wea:item><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></wea:item>
			<wea:item>
				<input class=inputstyle id=jobtitle name=jobtitle maxlength=60 >
			<!-- 
				 <brow:browser viewType="0"  name="jobtitle" browserValue='<%=filedvalue %>' 
			   browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp" 
			   hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='<%=isMustInput %>'
			   completeUrl="/data.jsp?type=hrmjobtitles" width="80%" browserSpanValue='<%=JobTitlesComInfo.getJobTitlesname(filedvalue) %>'>
			 	</brow:browser>
			 -->
			</wea:item>
		<%
		}else if(filedname.equals("roleid")){
			String isMustInput = isReadonly?"0":"1";
		%>
			<wea:item><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" temptitle="" name="roleid" browserValue='<%=filedvalue %>'
					browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp" 
					hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='<%=isMustInput %>'
					completeUrl="/data.jsp?type=65" width="80%"
					browserSpanValue='<%=RoleComInfo.getRolesname(filedvalue) %>'>
				</brow:browser>
			</wea:item>
		<%
		}
		} %>
</wea:group>
</wea:layout>
<%
//显示隐藏域
 Set<String> key = htHide.keySet();
 for (Iterator<String> it = key.iterator(); it.hasNext();) {
  String fieldname = (String) it.next();
  String fieldvalue = htHide.get(fieldname);
 %>
<input type="hidden" name="<%=fieldname %>" value="<%=fieldvalue %>" >
<%}%>
<%}else{ %>
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle name=lastname ></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
    <wea:item>
      <select class=inputstyle id=status name=status >
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
       <brow:browser viewType="0" name="subcompanyid"
        browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids="
        hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
        completeUrl="/data.jsp?type=164" _callback="jsSubcompanyCallback">
      </brow:browser>
    </wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
    <wea:item>
      <brow:browser viewType="0" name="departmentid" browserValue="" 
        browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="
        hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
        completeUrl="/data.jsp?type=4" _callback="jsDepartmentCallback" >
      </brow:browser>
    </wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></wea:item>
		<wea:item>
				<input class=inputstyle id=jobtitle name=jobtitle maxlength=60 >
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
<%} %>
<input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
  <input class=inputstyle type="hidden" name="resourceids" >
  <input class=inputstyle type="hidden" name="isNoAccount" id="isNoAccount">
<input class=inputstyle type="hidden" name="tabid" >
	<!--########//Search Table End########-->
	</FORM>
<!--
<SCRIPT LANGUAGE=VBS>
resourceids =""
resourcenames = ""

Sub btnclear_onclick()
     window.parent.returnvalue = Array("","")
     window.parent.close
End Sub


Sub btnok_onclick()
	 setResourceStr()
     replaceStr()
     window.parent.returnvalue = Array(resourceids,resourcenames)
    window.parent.close
End Sub

Sub btnsub_onclick()
	setResourceStr()
    document.all("resourceids").value = Mid(resourceids,2)
    document.all("tabid").value=2
    document.SearchForm.submit
End Sub

Sub btncancel_onclick()
     window.close()
End Sub
sub onShowDepartment()
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&document.SearchForm.departmentid.value)
	if (Not IsEmpty(id)) then
		if id(0)<> 0 then
			departmentspan.innerHtml = id(1)
			document.SearchForm.departmentid.value=id(0)
            subcompanyspan.innerHtml=""
            document.SearchForm.subcompanyid.value=""
            else
            departmentspan.innerHtml=""
            document.SearchForm.departmentid.value=""
		end if
	end if
end sub

sub onShowSubcompany()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="&document.SearchForm.subcompanyid.value)
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	subcompanyspan.innerHtml = id(1)
	document.SearchForm.subcompanyid.value=id(0)
    departmentspan.innerHtml=""
    document.SearchForm.departmentid.value=""
    else
    subcompanyspan.innerHtml=""
    document.SearchForm.subcompanyid.value=""
	end if
	end if
end sub

sub onShowRole()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		rolespan.innerHtml = id(1)
		document.SearchForm.roleid.value=id(0)
		else
		rolespan.innerHtml = ""
		document.SearchForm.roleid.value=""
		end if
	end if
end sub
</SCRIPT>  -->
<script language="javascript">
	var dialog = null;
	try{
		dialog = parent.parent.parent.getDialog(parent.parent);
	}catch(ex1){}
	
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
//2012-08-15 ypc  添加此函数
function btnsearch_onclick(){
	setResourceStr();
	//$("input[name=resourceids]").val(window.parent.frame2.systemIds.value);
	$("input[name=resourceids]").val(jQuery(parent.document).find("#frame2").contents().find("#systemIds").val());
  $("input[name=tabid]").val(2); //把这个val(2) 改为val(1) 就可以解决掉 搜索之后搜索按钮不见了的问题 2012-08-15 ypc 修改
  //是否显示无账号人员
  if(jQuery(parent.document).find("#frame2").contents().find("#isNoAccount").attr("checked"))
    jQuery("#isNoAccount").val("1");
  else
    jQuery("#isNoAccount").val("0");
    
	$("#SearchForm").submit();
}

function btnok_onclick(){
	window.parent.frame2.btnok.click();
}
	
	
//2012-08-15 ypc 添加 原因是：本页面的 确定右键菜单的 事件处理是用vbs编写的 在Google和火狐是不能解析的 所以改为js end
	function btnok_onclick1(){
			setResourceStr();
		    replaceStr();
		    window.parent.parent.returnValue = {id:resourceids,name:resourcenames};
		    window.parent.parent.close();
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

function onShowSubcompany(){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="+jQuery("#subcompanyid").val());
	if(results){
		if (results.id!="" ){
			subcompanyspan.innerHTML =results.name;
			$G("subcompanyid").value=results.id;
		    $G("departmentspan").innerHTML="";
		    $G("departmentid").value="";
		}
		else{
			subcompanyspan.innerHTML ="";
			$G("subcompanyid").value="";
		}
	}
}
function onShowDepartment(){
    var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+jQuery("#departmentid").val());
	if (results){
		if (results.id!="") {
				departmentspan.innerHTML =results.name;
				document.SearchForm.departmentid.value=results.id;
				subcompanyspan.innerHTML="";
				document.SearchForm.subcompanyid.value="";
			}
            else{
				departmentspan.innerHTML="";
				document.SearchForm.departmentid.value="";
			}
	}
}

function onShowRole(){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp")
	if(results){
	     if (results.id!= "" ){
			rolespan.innerHTML=results.name;
			document.SearchForm.roleid.value=results.id;
		}
		else{
			rolespan.innerHTML=results.name;
			document.SearchForm.roleid.value="";
		}
	}
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
	
function btncancel_onclick(){
	if(dialog){
	  	dialog.close();
	}else{
	   window.parent.parent.close();
	}
}

</script>
</BODY>
</HTML>
