<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.expdoc.ExpUtil"%>
<%@page import="weaver.workflow.workflow.WorkflowComInfo"%>
<%@page import="weaver.workflow.mode.FieldInfo"%> 
<%@ include file="/systeminfo/init_wev8.jsp" %>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("intergration:expsetting", user)){
 	response.sendRedirect("/notice/noright.jsp");
 	return;
}
String backto = Util.null2String(request.getParameter("backto"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String id = Util.null2String(request.getParameter("id"));
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelNames("83253,87",user.getLanguage());//归档流程注册信息
String needfav ="1";
String needhelp ="";

String workflowid="";
String workflowname="";
String expid="";
String xmltext="";
String xmltype = "";
RecordSet rs=new RecordSet();
String sql="select c.xmltype,a.workflowid as workflowid,a.workflowname as workflowname,a.expid as expid,b.Proid,c.xmltext as xmltext from exp_workflowDetail a,exp_ProList b,exp_XMLProSettings c where a.expid=b.id and b.Proid=c.id and a.id='"+id+"'";
rs.executeSql(sql);
if(rs.next()){
	workflowid=rs.getString("workflowid");
	workflowname=rs.getString("workflowname");
	expid=rs.getString("expid");
	xmltext= Util.null2String(rs.getString("xmltext"));//-XML模板内容
	xmltype = rs.getString("xmltype");
}
sql="select xmltext from exp_workflowXML  where rgworkflowid='"+id+"'";
rs.executeSql(sql);
if(rs.next()){
	String tempXmltext=Util.null2String(rs.getString("xmltext"));//-XML模板内容
	if(!tempXmltext.equals("")){
		xmltext=tempXmltext;
	}
}
sql="select fieldid,valueType from exp_workflowFieldXMLMap  where rgworkflowid='"+id+"'";
rs.executeSql(sql);
Map fieldidToRules=new HashMap();
while(rs.next()){
	String tempFieldid=Util.null2String(rs.getString("fieldid"));
	String tempValueType=Util.null2String(rs.getString("valueType"));
	if(!tempFieldid.equals("")){
		fieldidToRules.put(tempFieldid,tempValueType);
	}
}


ExpUtil eu=new ExpUtil();

weaver.workflow.workflow.WorkflowComInfo workflowcominfo=new WorkflowComInfo();

String formid=workflowcominfo.getFormId(workflowid);
String isbill=workflowcominfo.getIsBill(workflowid);

FieldInfo fieldinfo=new FieldInfo();
fieldinfo.GetManTableField(Util.getIntValue(formid,-1),Util.getIntValue(isbill,-1),user.getLanguage());

ArrayList mainTableFieldNames=fieldinfo.getManTableFieldNames();
ArrayList mainTableFieldFieldNames=fieldinfo.getManTableFieldFieldNames();

ArrayList mainTableFields=fieldinfo.getManTableFields();



%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<script language=javascript >
var parentWin = parent.parent.getParentWindow(parent);
</script>
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("intergration:expsetting", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<%if(HrmUserVarify.checkUserRight("intergration:expsetting", user)){%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="submitData()"/>
			<%}%>
			<span id="advancedSearch" class="advancedSearch" style='display:none;'><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=titlename%></span> 
</div>
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'>
</div>
<FORM id=weaver name=frmMain action="/integration/exp/ExpWorkflowDetailOperation.jsp?isdialog=1" method=post  >
<input class=inputstyle type=hidden name="backto" value="<%=backto%>">
<input class=inputstyle type="hidden" id='operation' name=operation value="editxml">
<input class=inputstyle type="hidden" id='id' name=id value="<%=id%>">

<table height="300px" width="100%">
		<tr>
		<td align="center" valign="top"  height="300px">
			<table border="0" cellpadding="0" cellspacing="0" width="100%" height="350px">
			<colgroup>
			<col width="58%">
			<col width="1%">
			<col width="41%">
			</colgroup>
			<tr class="Title" valign="top"  style="width:200px; height:100px;">
					
		<td align="left" style="height:100px;">
		<wea:layout attributes="{'cw1':'30%'}"><!-- XML模板设置 -->
		<wea:group context="<%=SystemEnv.getHtmlLabelName(125773,user.getLanguage())%>" attributes="{'samePair':'BaseInfo','groupOperDisplay':'none','groupSHBtnDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(125774,user.getLanguage())%></wea:item><!-- XML格式 -->
		<wea:item><%if("1".equals(xmltype)){out.println(SystemEnv.getHtmlLabelName(125782,user.getLanguage()));}else{out.println(SystemEnv.getHtmlLabelName(125775,user.getLanguage()));}%></wea:item><!-- 中信格式 -->
		<wea:item><%=SystemEnv.getHtmlLabelName(28053,user.getLanguage())%></wea:item><!-- 模板内容 -->
		<wea:item>
           <textarea class="InputStyle" id="fieldattr" name="fieldattr" rows="14" style="width:100%;height=200px" ><%=xmltext%></textarea>
           <br>
           <!--说明：<br>若要引用流程表单字段，请点击右侧字段标签，会自动在输入光标位置插入字段标签。<font color="red">标签禁止随意修改！</font> -->
		   <%=SystemEnv.getHtmlLabelName(125776,user.getLanguage())%><br><%=SystemEnv.getHtmlLabelName(125777,user.getLanguage())%><font color="red"><%=SystemEnv.getHtmlLabelName(125778,user.getLanguage())%></font>
		</wea:item>	
	
	</wea:group>
	</wea:layout>
	</td>
	<td></td>
	<td align="left"  style="height:100px;">
	
	<wea:layout><!-- 插入流程主表字段标签 -->
		<wea:group context="<%=SystemEnv.getHtmlLabelName(125779,user.getLanguage())%>" attributes="{'groupSHBtnDisplay':'none','groupOperDisplay':'none'}">
		</wea:group>
	</wea:layout>
		<div style="width:320px; height:300px; overflow:scroll; overflow-x:hidden;">
		<div id="RequestName" onclick="insertMark(this)"><a style="color:#00B2FC;"><%=SystemEnv.getHtmlLabelName(26876,user.getLanguage())%></a></div><!-- 流程标题 -->
		<div id="RequestId" onclick="insertMark(this)"><a style="color:#00B2FC;"><%=SystemEnv.getHtmlLabelName(18376,user.getLanguage())%></a></div><!-- 流程请求ID -->
		<div id="RequestCreator" onclick="insertMark(this)"><a style="color:#00B2FC;"><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></a></div><!-- 创建人 -->
		<div id="RequestCreateDate" onclick="insertMark(this)"><a style="color:#00B2FC;"><%=SystemEnv.getHtmlLabelName(30436,user.getLanguage())%></a></div><!-- 创建时间 -->
		<% 
		if(mainTableFieldNames!=null){
		for(int i=0;i<mainTableFieldNames.size();i++){
		%>
			<div id="<%=mainTableFieldFieldNames.get(i)%>" onclick="insertMark(this)"><a style="color:#00B2FC;"><%=mainTableFieldNames.get(i)%></a></div>
		<% 
		}
		}
		%>
		</div>
	</td>
     </tr>
</table>
	<wea:layout type="table" attributes="{cols:3,cws:33%}"><!-- 流程主表字段转换规则 -->
	<wea:group context="<%=SystemEnv.getHtmlLabelName(125762,user.getLanguage())%>" attributes="{'samePair':'BaseInfo','groupOperDisplay':'none','isTableList':'true'}">
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></wea:item><!-- 字段名称 -->
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></wea:item><!-- 字段类型 -->
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(23128,user.getLanguage())%></wea:item><!-- 转换规则 -->
		
		<% 
		if(mainTableFieldNames!=null){
		for(int i=0;i<mainTableFieldNames.size();i++){
			String tempfield=(String)mainTableFields.get(i);
		String[] temp=tempfield.split("_");
		String fieldid=temp[0].substring(temp[0].indexOf("field")+5);
		weaver.general.FormFieldTransMethod formfieldtransmethod=new FormFieldTransMethod();
		String displayType="";
		if(temp[2].equals("5")&&temp[1].equals("1")){
			displayType=formfieldtransmethod.getHTMLType(temp[2],user.getLanguage()+"");
		}else{
			displayType=formfieldtransmethod.getHTMLType(temp[2],user.getLanguage()+"")+"-"+formfieldtransmethod.getFieldType(temp[1],temp[2]+"+"+fieldid+"+"+user.getLanguage()+"");	
		}
		
		%>
		<wea:item><%=mainTableFieldNames.get(i)%>
		<input type="hidden" name="mainfileddbnames" value="<%=mainTableFieldFieldNames.get(i)%>">		
		<input type="hidden" name="mainFieldNames" value="<%=mainTableFieldNames.get(i)%>">
		<input type="hidden" name="mainFieldIds" value="<%=fieldid%>">
		<input type="hidden" name="fieldhtmltypes" value="<%=temp[2]%>">
		<input type="hidden" name="types" value="<%=temp[1]%>">
		</wea:item>
		
		<wea:item><%=displayType%></wea:item>

		<wea:item  attributes="{'isTableList':'true'}"> 
		  <%out.print(eu.getExpWorkflowFieldRulseSelect(fieldid,temp[2],temp[1]));%>
		 <%if(temp[2].equals("5")&&temp[1].equals("1")){
		 %>
		   <div id="selectValueConvert_<%=fieldid%>" style="display:none">
		  	<table class="ListStyle" cellSpacing="0" cellpadding="2">
								<colgroup>
									<col width="50%">
									<col width="50%">
								</colgroup>
								<thead >
									<tr >
										<th  style="text-align: left;">
										<font style="font-weight:normal;"><%=SystemEnv.getHtmlLabelName(125764,user.getLanguage())%></font><!-- 选择文字 -->
										</th>
										<th  style="text-align:center">
										<font style="font-weight:normal;"><%=SystemEnv.getHtmlLabelName(125765,user.getLanguage())%></font><!-- 转换值 -->
										</th>
									</tr>
									
								</thead>
								 <%
			 String[] tempvalues=formfieldtransmethod.getFieldType(temp[1],temp[2]+"+"+fieldid+"+"+user.getLanguage()+"").split("<br>");
				for(int t=0;t<tempvalues.length;t++){
		     %>
								<tr>
								<td><%=tempvalues[t]%><input  type="hidden" name="selectValue_<%=fieldid%>" value="<%=tempvalues[t]%>"></td>
								<td style="text-align:center">
								<input  type="text" name="selectValueTo_<%=fieldid%>" value="<%=eu.getSelectConvertValue(id,"0",fieldid,tempvalues[t])%>">
								</td>
								</tr>
						<%}%>
							</table>
		   	</div>
		  	 <%}%>
		  	 <%if(temp[2].equals("4")&&temp[1].equals("1")){  //check框
		 %>
		  <div id="checkValueConvert" >
		  	<table class="ListStyle" cellSpacing="0" cellpadding="2">
								<colgroup>
									<col width="50%">
									<col width="50%">
								</colgroup>
								<thead >
									<tr >
										<th  style="text-align: left;">
										        <font style="font-weight:normal;"><%=SystemEnv.getHtmlLabelName(125780,user.getLanguage())%></font><!-- 选择状态 -->
										</th>
										<th  style="text-align:center">
										<font style="font-weight:normal;"><%=SystemEnv.getHtmlLabelName(125765,user.getLanguage())%></font><!-- 转换值 -->
										</th>
									</tr>
									
								</thead>
								<tr>
								<td style="text-align: left;"><%=SystemEnv.getHtmlLabelName(125766,user.getLanguage())%><!-- 已勾选 --><input  type="hidden" name="checkedValue_<%=fieldid%>" value="1"></td>
								<td style="text-align:center">
								<input  type="text" name="checkedValueTo_<%=fieldid%>" value="<%=eu.getSelectConvertValue(id,"0",fieldid,"1")%>">
								</td>
								</tr>
								<tr>
								<td style="text-align: left;"><%=SystemEnv.getHtmlLabelName(125767,user.getLanguage())%><!-- 不勾选 --><input  type="hidden" name="uncheckedValue_<%=fieldid%>" value="0"></td>
								<td style="text-align:center">
								<input  type="text" name="uncheckedValueTo_<%=fieldid%>" value="<%=eu.getSelectConvertValue(id,"0",fieldid,"0")%>">
								</td>
								</tr>
							</table>
		   	</div>
		  	 <%}%>
		</wea:item>
		
		<% 
		}
		}
		%>
        
        
	</wea:group>
</wea:layout>
<br>
 </form>

<script language=javascript>

jQuery(document).ready(function () {

<%
if(mainTableFieldNames!=null&&fieldidToRules.size()>0){
	for(int i=0;i<mainTableFieldNames.size();i++){
	String tempfield=(String)mainTableFields.get(i);
	String[] temp=tempfield.split("_");
	String fieldid=temp[0].substring(temp[0].indexOf("field")+5);
	%>
	 $("#fieldRules_<%=fieldid%>").val("<%=fieldidToRules.get(fieldid)%>");
	 	
	 	//解绑，绑定
	jQuery("#fieldRules_<%=fieldid%>").selectbox("detach");
 	__jNiceNamespace__.beautySelect("#fieldRules_<%=fieldid%>");
 	 $("#fieldRules_<%=fieldid%>").change();
 
	<%
	}
}
	
%>
});


function submitData() {
	
      frmMain.submit();
   
}
function onBack(){
	parentWin.closeDialog();
}

function changeProValue()
{
var expProType="";
var fileSaveType="";

var temp=jQuery("#expid").val();
   $.ajax({ 
        	type:"POST",
            url: "/integration/exp/ExpGetProInf.jsp?"+Math.random(),
             data:{Proid:temp},
            cache: false,
  			async: false,
            success: function(data){
            data=data.replace(/(^\s+)|(\s+$)/g,"");
            var datas=data.split("#");
            if(datas.length>1){
             expProType=datas[0];
             fileSaveType=datas[1];
            
             }
             }
         });
     jQuery("#proTypeSpan").html(expProType);    
     jQuery("#proFileSaveTypeSpan").html(fileSaveType);    
 
}

function insertMark(obj){
	insertIntoTextarea(obj);
}
function selectValueChange(obj) {

	var name=$(obj).attr('name');
  
  var arr = name.split('_');
  var tempname=arr[1];
	var v=$(obj).val();
	if(v!='2'){
	$("#selectValueConvert_"+tempname).hide();
	//hideGroup("selectValueGroup");
	}else{
	$("#selectValueConvert_"+tempname).show();
	}
    
    
   
}

function insertIntoTextarea(obj1){
     var temp=$(obj1).attr("id");
    
    var textvalue="\$\{"+temp+"\}";
	var obj = document.getElementById("fieldattr");
	obj.focus();
	if(document.selection){
		document.selection.createRange().text = textvalue;
	}else{
		obj.value = obj.value.substr(0, obj.selectionStart) + textvalue + obj.value.substr(obj.selectionEnd);
	}
	//checkSql2($("#fieldattr").get(0));
}
</script>
<%if("1".equals(isDialog)){ %>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" onclick='onBack();'></input>
				</wea:item>
			</wea:group>
		</wea:layout>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				resizeDialog(document);
			});
		</script>
	</div>
</div>
<%} %>
</BODY>
</HTML>