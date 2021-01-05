<%@page import="weaver.proj.util.PrjFieldComInfo"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.docs.docs.CustomFieldManager"%>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.docs.category.*" %>
<%@ page import="weaver.docs.category.security.MultiAclManager" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.general.StaticObj" %>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WeaverEditTableUtil" class="weaver.docs.util.WeaverEditTableUtil" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="ProjectTransUtil" class="weaver.proj.util.ProjectTransUtil" scope="page" />
<jsp:useBean id="UserDefinedBrowserTypeComInfo" class="weaver.workflow.field.UserDefinedBrowserTypeComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<link type="text/css" href="/js/ecology8/base/jquery-ui_wev8.css" rel=stylesheet>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<%
int proTypeId = Util.getIntValue (request.getParameter("proTypeId"),0); 
boolean fromProj ="1".equals( Util.null2String(request.getParameter("fromProj"))); 
	String id = Util.null2String(request.getParameter("id")); 
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String isclose = Util.null2String(request.getParameter("isclose"));
	boolean canEdit = true;
	RecordSet.executeSql("select 1 from cus_formfield where fieldid = "+id);
	if(RecordSet.next()){
		canEdit = false;
	}
	String fieldname = "";
	String fieldlabel = "";
	String fieldhtmltype="";
	String type = "";
	String flength = "";
	String fielddbtype = "";
	
	String isuse = "";
	String ismand = "";
	String prj_fieldlabel = "";
	String fieldorder = "";
	String sql="select * from cus_formdict where id = "+id;
	if(fromProj){
		sql=" select t1.* ,t2.id, t2.fielddbtype, t2.fieldhtmltype, t2.type, t2.fieldname, t2.fieldlabel ";
		sql+=" from cus_formfield t1, cus_formdict t2 ";
		sql+=" where t1.scope='ProjCustomField'  and t1.fieldid=t2.id and t1.scopeid='"+proTypeId+"' and t2.id='"+id+"' ";
	}
	RecordSet.executeSql(sql);
	if(RecordSet.next()){
		if(fromProj){
			isuse = Util.null2String(RecordSet.getString("isuse"));
			ismand = Util.null2String(RecordSet.getString("ismand"));
			prj_fieldlabel = ProjectTransUtil.getHtmlLabelName( Util.null2String(RecordSet.getString("prj_fieldlabel")),""+user.getLanguage()+"+"+Util.null2String(RecordSet.getString("fieldlable")));
			fieldorder = Util.null2String(RecordSet.getString("fieldorder"));
		}
		
		fieldname = Util.null2String(RecordSet.getString("fieldname"));
		if(fieldname.equals(""))fieldname = "field"+id;
		fieldlabel = Util.null2String(RecordSet.getString("fieldlabel"));
		if(fieldlabel.equals(""))fieldlabel = "field"+id;
		fieldhtmltype = Util.null2String(RecordSet.getString("fieldhtmltype"));
		type = Util.null2String(RecordSet.getString("type"));
		fielddbtype = Util.null2String(RecordSet.getString("fielddbtype"));
		if(fieldhtmltype.equals("1") && type.equals("1")){
			flength = fielddbtype.substring(fielddbtype.indexOf("(")+1,fielddbtype.indexOf(")"));
		}
	}
	if(fieldhtmltype.equals("5")){
		RecordSet.executeSql("select * from cus_selectitem where fieldid="+id+" order by fieldorder");
	}
%>
<script type="text/javascript">

var parentWin = null;
var dialog = null;
<%if(isDialog.equals("1") || isclose.equals("1")){%>
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
<%}%>

<%if(isclose.equals("1")){%>
	parentWin._table.reLoad();
	parentWin.closeDialog();
<%}%>

try{
	if(<%=fromProj %>===true){
		parent.setTabObjName("<%=fieldname %>");
	}else{
		parent.setTabObjName("<%=fieldlabel %>");
	}
}catch(e){
	if(window.console)console.log(e);
}

function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}

function htmltypeChange(obj){
	jQuery("#fdefinebroswerType").hide();	
	if(obj.value==1){
		jQuery("#typeDiv").html(jQuery("#ftype1").html());
		jQuery("#typedetailDiv").show();
		jQuery("#type").removeAttr("notBeauty");
		beautySelect("#type");
		hideGroup("selectItemArea")
		showEle("type");
	}else if(obj.value==2||obj.value==4){
		jQuery("#typeDiv").html("");
		hideEle("type");
		jQuery("#typedetailDiv").hide();
		hideGroup("selectItemArea")
	}else if(obj.value==3){
		jQuery("#typeDiv").html(jQuery("#ftype2").html());
		jQuery("#typedetailDiv").hide();
		showEle("type");
		jQuery("#type").removeAttr("notBeauty");
		beautySelect("#type");
		hideGroup("selectItemArea")
	}else if(obj.value==5){
		jQuery("#typedetailDiv").hide();
		showGroup("selectItemArea")
		hideEle("type");
	}
	
}

function typeChange(obj){
	if(obj.value==1){
		jQuery("#typedetailDiv").show();
	}else{
		jQuery("#typedetailDiv").hide();
	}
}

function broswertypeChange(obj){
	var seltype = jQuery("#type  option:selected").val();
	if(seltype==161||seltype==162){
	jQuery("#fdefinebroswerType").show();
	}else{
	jQuery("#fdefinebroswerType").hide();	
	
	}



}


function onSave(obj){
	if(check_form(frmProperties,"fieldname,fieldlabel<%=fromProj?",proTypeId":"" %>")){
		obj.disabled = true;
		var fieldname = "";
		<%if(!canEdit){%>
			fieldname = "<%=fieldname%>";
		<%}else{%>
			fieldname = jQuery("#fieldname").val();
		<%}%>
		jQuery.ajax({
			url:"/docs/category/docajax_operation.jsp",
			type:"post",
			dataType:"text",
			data:{
				src:"checkDocCusSame",
				fieldid:<%=id%>,
				fieldname:fieldname
			},
			success:function(data){
				if(data!=0){
					top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(33427,user.getLanguage())%>");
				}else{
					document.frmProperties.submit();
				}
			},
			complete:function(xhr){
				obj.disabled = false;
			}
		});
	}
}

function clearNoNum(obj){
	obj.value = obj.value.replace(/[^\d.]/g,"");
	obj.value = obj.value.replace(/^\./g,"");
	obj.value = obj.value.replace(/\.{2,}/g,"");
	obj.value = obj.value.replace(".","$#$").replace(/\./g,"").replace("$#$","");
}
</script>
</HEAD>

<%
	String titlename = "";

	%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%//菜单
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" class="e8_btn_top" onclick="onSave(this);">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM METHOD="POST" name="frmProperties" ACTION="DocSecCategoryDocPropertiesEditOperation.jsp">
	<INPUT TYPE="hidden" NAME="method" VALUE="edit">
	<INPUT TYPE="hidden" NAME="isdialog" VALUE="<%=isDialog%>">
	<INPUT TYPE="hidden" NAME="id" VALUE="<%=id %>">
	<INPUT TYPE="hidden" NAME="canEdit" VALUE="<%=canEdit %>">

<iframe name="selectItemGetter" style="width:100%;height:200;display:none"></iframe>


<wea:layout attributes="{'formTableId':'inputface','expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(23241,user.getLanguage())%></wea:item>
		<wea:item>
			<%if(canEdit){ %>
				<wea:required id="fieldnamespan" required="true" value='<%=fieldname %>'>
					<INPUT class=InputStyle id="fieldname" value="<%=fieldname %>" maxLength=30 size=32 name="fieldname" temptitle="<%=SystemEnv.getHtmlLabelName(23241,user.getLanguage())%>" 
		          onChange="checkinput('fieldname','fieldnamespan')">
				</wea:required>
			<%}else{ %>
				<%= fieldname%>
			<%} %>
		</wea:item>
<%
if(fromProj){
	%>
		<wea:item><%=SystemEnv.getHtmlLabelName(30828,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="fieldlabelspan" required="true" value='<%=prj_fieldlabel %>'>
				<INPUT class=InputStyle  name="fieldlabel" value="<%=prj_fieldlabel %>" temptitle="<%=SystemEnv.getHtmlLabelName(30828,user.getLanguage())%>" 
	          onChange="checkinput('fieldlabel','fieldlabelspan')">
			</wea:required>
		</wea:item>
	<%
}else{
	%>
		<wea:item><%=SystemEnv.getHtmlLabelName(30828,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="fieldlabelspan" required="true" value='<%=fieldlabel %>'>
				<INPUT class=InputStyle  name="fieldlabel" value="<%=fieldlabel %>" temptitle="<%=SystemEnv.getHtmlLabelName(30828,user.getLanguage())%>" 
	          onChange="checkinput('fieldlabel','fieldlabelspan')">
			</wea:required>
		</wea:item>
	<%
}
%>		
		
<%
//4projtype
if(fromProj){
	if(proTypeId>0){
		%>
		<wea:item><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%></wea:item>
		<wea:item>
			<span><%=ProjectTypeComInfo.getProjectTypename(""+proTypeId) %></span>
			<input type="hidden" name="proTypeId" id="proTypeId" value="<%=proTypeId %>" />
		</wea:item>
		<%
	}else{
		%>
		<wea:item><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="proTypeId" browserValue='<%=""+proTypeId %>' browserSpanValue='<%=ProjectTypeComInfo.getProjectTypename(""+proTypeId) %>' 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/Maint/ProjectTypeBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
				completeUrl="/data.jsp?type=244"  />
		</wea:item>
		<%
	}
	%>
		<wea:item><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></wea:item>
		<wea:item>
			<INPUT class=InputStyle type='checkbox' id="prjisuse"  name="prjisuse" value="1" <%="1".equals( isuse)?"checked":"" %> />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%></wea:item>
		<wea:item>
			<INPUT class=InputStyle type='checkbox' id="prjismand"  name="prjismand" value="1" <%="1".equals( ismand)?"checked":"" %> />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></wea:item>
		<wea:item>
			<INPUT class=InputStyle style="width:50px!important;" type='text' id="prjfieldorder"  name="prjfieldorder" value='<%=fieldorder %>' onkeyup="clearNoNum(this)"  />
		</wea:item>
	<%
}
%>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(687,user.getLanguage())%></wea:item>
		<wea:item>
			<%if(canEdit){ %>
				<select size="1" name="fieldhtmltype" onChange = "htmltypeChange(this)">
					<option value="1" <%=fieldhtmltype.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%></option>
					<option value="2" <%=fieldhtmltype.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%></option>
					<option value="3" <%=fieldhtmltype.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%></option>
					<option value="4" <%=fieldhtmltype.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%></option>
					<option value="5"<%=fieldhtmltype.equals("5")?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%></option>
			    </select>
			 <%}else{
			 	if(fieldhtmltype.equals("1")){ 
			 		out.println(SystemEnv.getHtmlLabelName(688,user.getLanguage()));
			 	}else if(fieldhtmltype.equals("2")){
			 		out.println(SystemEnv.getHtmlLabelName(689,user.getLanguage()));
			 	}else if(fieldhtmltype.equals("3")){
			 		out.println(SystemEnv.getHtmlLabelName(695,user.getLanguage()));
			 	}else if(fieldhtmltype.equals("4")){
			 		out.println(SystemEnv.getHtmlLabelName(691,user.getLanguage()));
			 	}else if(fieldhtmltype.equals("5")){
			 		out.println(SystemEnv.getHtmlLabelName(690,user.getLanguage()));
			 	}
			 %>
			 <input type="hidden" name="fieldhtmltype" id="fieldhtmltype" value='<%=fieldhtmltype %>'/>
			 <% } %>
		</wea:item>
		<%String typeAttr = "{'samePair':'type','display':'"+((fieldhtmltype.equals("1")||fieldhtmltype.equals("3"))?"":"none")+"'}"; %>
		<wea:item attributes='<%=typeAttr %>'><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=typeAttr %>'>
			<span id="typeDiv" style="float:left">
				<%if(canEdit){ %>
					<%if(fieldhtmltype.equals("1")){ %>
						<select size=1 name=type onChange = "typeChange(this)">
							<option value="1" selected><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
							<option value="2"><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
							<option value="3"><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
						</select>
					<%}else{ %>
						<select size=1 id="type" name=type onChange = "broswertypeChange(this)" >
					    <%while(BrowserComInfo.next()){
					    		 	 if(("226".equals(BrowserComInfo.getBrowserid()))||"227".equals(BrowserComInfo.getBrowserid())||"224".equals(BrowserComInfo.getBrowserid())||"225".equals(BrowserComInfo.getBrowserid())){
						        	 //屏蔽集成浏览按钮-zzl
									continue;
								}
					    %>
							<option <%=type.equals(BrowserComInfo.getBrowserid())?"selected":"" %> value='<%=BrowserComInfo.getBrowserid()%>' ><%=SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(),0),user.getLanguage())%></option>
					    <%}%>
	</select>
					<%} %>
					
				<%}else{
					if(fieldhtmltype.equals("1")){
						if(type.equals("1")){
							out.println(SystemEnv.getHtmlLabelName(608,user.getLanguage()));
						}else if(type.equals("2")){
							out.println(SystemEnv.getHtmlLabelName(696,user.getLanguage()));
						}else if(type.equals("3")){
							out.println(SystemEnv.getHtmlLabelName(697,user.getLanguage()));
						}
					}else if(fieldhtmltype.equals("3")){
						out.println(SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(type),0),user.getLanguage()));	
						out.println(UserDefinedBrowserTypeComInfo.getName(fielddbtype));
					}
				} %>
			</span>

			<span style="width:100px" style="DISPLAY: none" id="fdefinebroswerType">
						<brow:browser width="150px" viewType="0" name="definebroswerType"  id="definebroswerType" browserValue='<%=UserDefinedBrowserTypeComInfo.getName(fielddbtype)%>'
						    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/field/UserDefinedBrowserTypeBrowser.jsp"
						    completeUrl="/data.jsp"
							hasInput="false" isSingle="true"
							isMustInput="1" browserDialogWidth="550px"
							browserDialogHeight="650px"
							_callback="typeChange"
							browserSpanValue='<%=UserDefinedBrowserTypeComInfo.getName(fielddbtype)%>'></brow:browser>
					</span>

		
			<span id="typedetailDiv" style="padding-left:15px;">
					<%if(fieldhtmltype.equals("1")&&type.equals("1")){ %>
						<%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%>&nbsp;&nbsp;
						<%if(canEdit){ %>
							<input  class=InputStyle name=flength type=text value="<%=flength %>" maxlength=4 style="width:50px" >
						<%}else{ %>
							<%= flength%>
						<%} %>
					<%} %>
			</span>
			<input name=definebroswerType type=hidden value="">
		</wea:item>
	</wea:group>
	<%String groupAttr = "{'samePair':'selectItemArea','groupDisplay':'"+(fieldhtmltype.equals("5")?"":"none")+"','itemAreaDisplay':'"+(fieldhtmltype.equals("5")?"":"none")+"'}"; 
	%>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(32716,user.getLanguage())%>' attributes="<%=groupAttr %>">
		<wea:item type="groupHead">
			<input type="button" class="addbtn" title="<%= SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onclick="group.addRow();"/>
			<input type="button" class="delbtn" title="<%= SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="group.deleteRows();"/>
		</wea:item>
		<wea:item attributes="{'isTableList':'true','samePair':'selectItemArea'}">
			<div id="selectItemArea"></div>
			<%String ajaxDatas = WeaverEditTableUtil.getInitDatas("selectItem",user,RecordSet); %>
			<script type="text/javascript">
						var group = null;
						var ajaxDatas = <%=ajaxDatas%>;
						jQuery(document).ready(function(){
                             broswertypeChange();
							var items=[
								{width:"60%",colname:"<%=SystemEnv.getHtmlLabelNames("32715",user.getLanguage())%>",itemhtml:"<input type='text' name='itemname'></input><span class='mustinput'></span><input type='hidden' name='selectvalue'><input type='hidden' id='fieldorder' name='fieldorder'>"},
								{width:"20%",colname:"<%=SystemEnv.getHtmlLabelNames("149",user.getLanguage())%>",itemhtml:"<input value=1 type='checkbox' name='docdefault'></input>"},
								{width:"15%",colname:"<%=SystemEnv.getHtmlLabelNames("22151",user.getLanguage())%>",itemhtml:"<input value=1 type='checkbox' name='cancel'></input>"}
								];
							var option = {
								basictitle:"",
								optionHeadDisplay:"none",
								colItems:items,
								openindex:true,
								container:"#selectItemArea",
								toolbarshow:false,
								configCheckBox:true,
								usesimpledata:true,
								canDrag:true,
								orderField:"fieldorder",
								initdatas:ajaxDatas,
             					checkBoxItem:{"itemhtml":'<input name="itemId" class="groupselectbox" type="checkbox" >',width:"5%"}
							};
							group=new WeaverEditTable(option);
							jQuery("#selectItemArea").append(group.getContainer());
							});
					</script>
		</wea:item>
	</wea:group>
</wea:layout>

</FORM>



<div style="DISPLAY: none" id="ftype1">
	<select notBeauty="true" size=1 id="type" name=type onChange = "typeChange(this)" >
		<option value="1" selected><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
		<option value="2"><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
		<option value="3"><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
	</select>
	<input name=definebroswerType type=hidden value="">
</div>

<div style="DISPLAY: none" id="ftype2">
	<select notBeauty="true" size=1 id="type" name=type onChange = "broswertypeChange(this)" >
    <%while(BrowserComInfo.next()){
    		 	 if(("226".equals(BrowserComInfo.getBrowserid()))||"227".equals(BrowserComInfo.getBrowserid())||"224".equals(BrowserComInfo.getBrowserid())||"225".equals(BrowserComInfo.getBrowserid())){
	        	 //屏蔽集成浏览按钮-zzl
				continue;
			}
    %>
		<option value="<%=BrowserComInfo.getBrowserid()%>" ><%=SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(),0),user.getLanguage())%></option>
    <%}%>
	</select>
</div>



<div style="DISPLAY: none" id="fdefinebroswerTypeDefault">
	<input name=definebroswerType type=hidden value="">
</div>

<div style="DISPLAY: none" id="ftype3">
	&nbsp;<input name=type type=hidden value="0">
	<input name=definebroswerType type=hidden value="">
</div>

<div style="DISPLAY: none" id="ftype4">
	&nbsp;<input name=flength type=hidden  value="100">
</div>

<div style="DISPLAY: none" id="ftype5">
	<%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%>:<input  class=InputStyle name=flength type=text value="100" maxlength=4 style="width:50px">
</div>

<div style="DISPLAY: none" id="fismand">
	<%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%>:
	<select notBeauty="true" size=1 name=ismand >
		<option value="0"><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
		<option value="1"><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
	</select>
</div>

<div style="DISPLAY: none" id="fselectaction">
	<input name=type type=hidden  value="0">
	<input name=definebroswerType type=hidden value="">
	<input Class=Btn type=button onclick="addrow2(this)"  value="<%=SystemEnv.getHtmlLabelName(18597,user.getLanguage())%>"/>
    <input Class=Btn type=button onclick="importSel(this)"  value="<%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%>"/>
</div>

<div style="DISPLAY: none" id="fselectitems">
	<TABLE cellSpacing=0 cellPadding=1 width="100%" border=0 >
	<COLGROUP>
		<col width="40%">
		<col width="60%">
	</COLGROUP>
	</TABLE>
    <input name=selectitemid type=hidden value="--">
	<input name=selectitemvalue type=hidden >

    <input name=flength type=hidden  value="100">
</div>

<div style="DISPLAY: none" id="fselectitem">
	<input name=selectitemid type=hidden value="-1" >
	<input  class=InputStyle name=selectitemvalue type=text style="width:100" >
</div>

<div style="DISPLAY: none" id="itemaction">
  <img src="/images/icon_ascend_wev8.gif" height="14" onclick="upitem(this)" style="cursor:pointer" >
  <img src="/images/icon_descend_wev8.gif" height="14" onclick="downitem(this)" style="cursor:pointer" >
	<img src="/images/delete_wev8.gif" height="14" onclick="delitem(this)" style="cursor:pointer" >
</div>

<div style="DISPLAY: none" id="action">
    <img src="/images/icon_ascend_wev8.gif" height="14" onclick="up(this)" style="cursor:pointer;visibility:hidden" >
    <img src="/images/icon_descend_wev8.gif" height="14" onclick="down(this)" style="cursor:pointer;visibility:hidden" >
	<img src="/images/delete_wev8.gif" height="14" onclick="del(this);addToSettingInput();" style="cursor:pointer">
</div>

<!-- 自定义字段结束 -->

<div style="DISPLAY: none" id="settinglabel1">
	<input type="hidden" name="propertyid" value="-1">
	<input type="hidden" name="isCustom" value="1">
	<input type="hidden" name="scope" value="">
	<input type="hidden" name="scopeid" value="-1">
	<input type="hidden" name="fieldid1" value="-1">
	<input type="hidden" name="stype" value="0">
    <img id="imgArrowUp" src="/images/ArrowUpGreen_wev8.gif" onclick="onSettingUp(this);" style="cursor:pointer">&nbsp;
	<img id="imgArrowDown" src="/images/ArrowDownRed_wev8.gif" onclick="onSettingDown(this);" style="cursor:pointer;visibility:hidden">
</div>

<div style="DISPLAY: none" id="settinglabel2">
	#name#<input type="hidden" name="labelId" value="-1">
</div>

<div style="DISPLAY: none" id="settinglabel3">
	<INPUT type="checkbox" class=InputStyle name="chk_visible" onclick="jQuery(this).parent().children('::eq(1)')[0].value=(this.checked)?1:0;setCheckBox(this,1);" checked>
	<INPUT type="hidden" class=InputStyle name="visible" value="1">
</div>

<div style="DISPLAY: none" id="settinglabel4">
	<INPUT type="text" class=InputStyle name="customName" value="#name#" style="display:none" >&nbsp;
</div>

<div style="DISPLAY: none" id="settinglabel5">
	<select class=InputStyle name="columnWidth">
		<option value="1" selected><%=SystemEnv.getHtmlLabelName(19802,user.getLanguage())%></option>
		<option value="2"><%=SystemEnv.getHtmlLabelName(19803,user.getLanguage())%></option>
	</select>
	<%--<INPUT type="text" class=InputStyle name="columnWidth" size="3" maxLength="2" value="2">--%>
</div>
		
<div style="DISPLAY: none" id="settinglabel6">
	<INPUT type="checkbox" class=InputStyle name="chk_mustInput" style='display:none' onclick="jQuery(this).parent().children('::eq(1)')[0].value=(this.checked)?1:0;setCheckBox(this,2);" #checked#>
	<INPUT type="hidden" class=InputStyle name="mustInput" value="#mustInput#">
</div>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
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
		resizeDialog(document);
	</script>
<%} %>
</body>
</html>
