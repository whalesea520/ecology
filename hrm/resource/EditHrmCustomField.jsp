
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,
                 weaver.hrm.definedfield.HrmFieldManager" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>
<%!
public String getName(String showname) {
	RecordSet rs = new RecordSet();
	if (showname != null && !"".equals(showname)) {
		//兼容老数据，如果id有moduleid，则去掉
		int index = showname.indexOf(".");
		if (index > 0) {
			showname = showname.substring(index + 1);
		}
		String sql = "select name from datashowset where showname='" + showname + "'";
		rs.executeSql(sql);
		if (rs.next()) {
			return Util.null2String(rs.getString("name"));
		}	
	}
	return "";
}
%>
<%  
String userid =""+user.getUID();
/*权限判断,人力资产管理员以及其所有上级*/
boolean canView = false;
ArrayList allCanView = new ArrayList();
String tempsql ="select resourceid from HrmRoleMembers where roleid in (select roleid from SystemRightRoles where rightid=22)";
RecordSet.executeSql(tempsql);
while(RecordSet.next()){
    String tempid = RecordSet.getString("resourceid");
    allCanView.add(tempid);
}// end while
for (int i=0;i<allCanView.size();i++){
    if(userid.equals((String)allCanView.get(i))){
        canView = true;
    }
}
if(!canView) {
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}
/*权限判断结束*/

int id = Util.getIntValue(request.getParameter("id"),-1);//所属页签 基本信息 个人信息 工作信息
String message =Util.null2String(request.getParameter("message"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript"> 
var itemchange = false; 
function onBtnSearchClick(){
  clearTempObj();
	if(itemchange){
		parent.parent.location.reload(); 
	}else{
		jQuery("#weaver").submit();
	}
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function openDialog(id){
	var parentid = '<%=id%>';
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(id==null)id="";
	
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=AddHrmCustomTreeField&parentid="+parentid;
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("32732", user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=EditHrmCustomTreeField&id="+id;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,81817", user.getLanguage())%>";
		if(parentid=="0"){
			window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(83584,user.getLanguage())%>');	
			return;
		}
	}
	dialog.Width = 400;
	dialog.Height = 203;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

var trObj = "";
function addItemDialog(obj,item_id){
	trObj=jQuery(obj).parent().parent();
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;

	var selectObj = trObj.find("select[name=selectOption] option");
	var alloption = "";
	jQuery(selectObj).each(function(){
		var val = jQuery(this).val();
		var txt = jQuery(this).text();
		var node = val+","+txt;
		alloption += "|"+node;
	});
	
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=EditHrmCustomFieldSelect&id=<%=id%>&item_id="+item_id+"&alloption="+encodeURI(alloption);
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32714,user.getLanguage()) %>";
	dialog.Width = 600;
	dialog.Height = 400;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}

function setSelectOption(resultDatas){
	var selectObj = trObj.find("select[name=selectOption]");
	var tdobj = trObj.find("td").get(4);
	jQuery(selectObj).empty();
	jQuery(selectObj).selectbox("detach");
	jQuery(tdobj).find("div[id=selectItems]").empty();
		
	for(var i=0;i<resultDatas.length;i++){
		var resultData = resultDatas[i];
		var selectitemvalue = resultData.selectitemvalue;
		var selectitemid = resultData.selectitemid;
		jQuery(selectObj).append("<option value='"+selectitemid+"'>"+selectitemvalue+"</option>"); 
		jQuery(tdobj).find("div[id=selectItems]").append("<input name='selectitemid' type=hidden value='"+selectitemid+"'>");
		selectitemvalue = resultData.__multilangpre_selectitemvalue || selectitemvalue;
		jQuery(tdobj).find("div[id=selectItems]").append("<input name='selectitemvalue' type=hidden value='"+selectitemvalue+"'>");
	}
	jQuery(tdobj).find("div[id=selectItems]").append("<input name='selectitemid' type=hidden value='--'>");
	jQuery(tdobj).find("div[id=selectItems]").append("<input name='selectitemvalue' type=hidden value=''>");
	jQuery(tdobj).find("div[id=selectItems]").append(" <input name=flength type=hidden  value=100><input name=definebroswerType type=hidden  value=emptyVal>");

	jQuery(selectObj).selectbox();
}

function onLog(id){
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	var url = "/systeminfo/SysMaintenanceLog.jsp?isdialog=1&secid=65&sqlwhere=where operateitem=25 and relatedid="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}
jQuery(document).ready(function(){
 registerDragEvent();
 <%if(message.equals("1")){%>
 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>");
<%}else if(message.equals("-2")){%>
window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83912,user.getLanguage())%>现有字段不存在！");
<%}else if(message.equals("-3")){%>
window.top.Dialog.alert("保存现有字段出错，字段类型不一致！");
<%}%>
})

function registerDragEvent(){
	 var fixHelper = function(e, ui) {
	    ui.children().each(function() {  
	      jQuery(this).width(jQuery(this).width());     //在拖动时，拖动行的cell（单元格）宽度会发生改变。在这里做了处理就没问题了  
	      jQuery(this).height("30px");						//在CSS中定义为30px,目前不能动态获取
	    });  
	    return ui;  
    }; 
     jQuery(".ListStyle tbody").sortable({                //这里是talbe tbody，绑定 了sortable  
         helper: fixHelper,                  //调用fixHelper  
         axis:"y",  
         start:function(e, ui){
         	 ui.helper.addClass("moveMousePoint");
           ui.helper.addClass("e8_hover_tr")     //拖动时的行，要用ui.helper  
           if(ui.item.hasClass("notMove")){
           	e.stopPropagation();
           }
           $(".hoverDiv").css("display","none");
           return ui;  
         },  
         stop:function(e, ui){
             //ui.item.removeClass("ui-state-highlight"); //释放鼠标时，要用ui.item才是释放的行  
             jQuery(ui.item).hover(function(){
            	jQuery(this).addClass("e8_hover_tr");
            },function(){
            	jQuery(this).removeClass("e8_hover_tr");
            	
            });
            jQuery(ui.item).removeClass("moveMousePoint");
            sortOrderTitle();
            return ui;  
         }  
     });  
}

function sortOrderTitle()
{
	jQuery("#inputface tbody tr").each(function(index){
		if(index==0)return;
		jQuery(this).find("input[name=filedorder]").val(index);
	})
}
</script>
</HEAD>
<%
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17088,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
%>
<body>
<%
  RecordSet.executeSql("select * from cus_treeform where scope='HrmCustomFieldByInfoType' and id="+id);
  RecordSet.next();
  int parentid = RecordSet.getInt("parentid");
  String formlabel = RecordSet.getString("formlabel");
  int cusId = RecordSet.getInt("id");
  if(cusId==-1){
	  formlabel = SystemEnv.getHtmlLabelName(1361,user.getLanguage());
  }else if(cusId==1){
	  formlabel = SystemEnv.getHtmlLabelName(15687,user.getLanguage());
  }else if(cusId==3){
	  formlabel = SystemEnv.getHtmlLabelName(15688,user.getLanguage());
  }
  String viewType = Util.null2String(RecordSet.getString("viewtype"));
  boolean canEdit = true;
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canEdit){
  if(!viewType.equals("1")){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(17550,user.getLanguage())+",javascript:openDialog();,_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
	}
	if(parentid!=0){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(32732,user.getLanguage())+",javascript:openDialog("+id+");,_self}" ;
	  RCMenuHeight += RCMenuHeightStep ;
	}
  
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel();,_self}" ;
  RCMenuHeight += RCMenuHeightStep ;
  
  RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:addrow(),_self} " ;
  RCMenuHeight += RCMenuHeightStep;
  
  RCMenu += "{"+SystemEnv.getHtmlLabelName(77,user.getLanguage())+",javascript:copyRow();,_self}" ;
  RCMenuHeight += RCMenuHeightStep ;

  RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
  RCMenuHeight += RCMenuHeightStep;
}
%>
<script type="text/javascript">
jQuery(document).ready(function(){
<%if(formlabel.length()>0){%>
 parent.setTabObjName('<%=formlabel%>')
 <%}%>
});
</script>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div id="tabDiv">
	<span class="toggleLeft" id="toggleLeft" title="<%=SystemEnv.getHtmlLabelName(32814,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(32815,user.getLanguage())%></span>
</div>
<%
    String disableLable = "disabled";
    if(canEdit)disableLable="";
    
    HrmFieldManager hfm = new HrmFieldManager("HrmCustomFieldByInfoType",id);
    hfm.getCustomFields();
    LinkedHashMap htGroup = hfm.getGroups();
%>
<div style="DISPLAY: none" id="flchk">
    <input name="fieldChk" type="checkbox" value="">
</div>
<div style="DISPLAY: none" id="fname">
    <input class=InputStyle name="fieldname" style="width: 100px;display:none;" type="text" onchange='checkKey(this);checkinput_char_num(this);hrmCheckinput(this);'>
    <SPAN></SPAN>
    <input type="hidden" name="fieldid" value="-1">
</div>
<div style="DISPLAY: none" id="flable">
    <input  class=InputStyle name="fieldlable" style="width: 100px" onchange='hrmCheckinput(this);'>
    <SPAN><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
</div>
<div style="DISPLAY: none" id="fhtmltype">
    <select size="1" name="fieldhtmltype" onChange = "htmltypeChange(this)" style="width: 95px" notBeauty=true>
        <option value="1" selected><%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%></option>
        <option value="2" ><%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%></option>
        <option value="3" ><%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%></option>
        <option value="4" ><%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%></option>
        <option value="5" ><%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%></option>
        <%if(id==-1||viewType.equals("0")){ %>  
        <option value="6" ><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%></option>
        <%} %>
  </select>
</div>

<div style="DISPLAY: none" id="ftype1">
    <select size=1 name=type onChange = "typeChange(this)" style="width: 80px" notBeauty=true>
        <option value="1" selected><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
        <option value="2"><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
        <option value="3"><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
    </select>
</div>

<div style="DISPLAY: none" id="ftype2">
    <select size=1 name=type style="width: 95px" notBeauty=true onChange = "BrowserTypeChange(this)" notBeauty=true>
    <%while(BrowserComInfo.next()){
         if(("226".equals(BrowserComInfo.getBrowserid()))||"227".equals(BrowserComInfo.getBrowserid())||"224".equals(BrowserComInfo.getBrowserid())||"225".equals(BrowserComInfo.getBrowserid())||("256".equals(BrowserComInfo.getBrowserid()))||("257".equals(BrowserComInfo.getBrowserid()))){
                 //屏蔽集成浏览按钮-zzl
            continue;
            }
    %>
        <option value="<%=BrowserComInfo.getBrowserid()%>" ><%=SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(),0),user.getLanguage())%></option>
    <%}%>
    </select>
</div>

<div style="DISPLAY: none" id="ftype3">
    <input name=type type=hidden value="0">&nbsp;
</div>

<div style="DISPLAY: none" id="ftype4">
    <input name=flength type=hidden  value="100">
    <input name=definebroswerType type=hidden  value="emptyVal">&nbsp;
</div>

<div style="DISPLAY: none" id="ftype5">
  <%=SystemEnv.getHtmlLabelName(608,user.getLanguage()) %>:
    <input  class=InputStyle name=flength type=text value="100" maxlength=4 style="width:80px" >
    <input name=definebroswerType type=hidden  value="emptyVal">
</div>

<div style="DISPLAY: none" id="ftype6">
    <select size=1 name=type onChange="typeChange(this)" style="width:80px" notBeauty=true>
        <option value="1" selected><%=SystemEnv.getHtmlLabelName(20798,user.getLanguage())%></option>
        <!-- 
        <option value="2"><%=SystemEnv.getHtmlLabelName(20001,user.getLanguage())%></option>        
         -->
    </select>
</div>

<div style="DISPLAY: none" id="ftype7">
    <brow:browser width="150px" viewType="0" name="definebroswerType"
            browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/field/UserDefinedBrowserTypeBrowser.jsp"
            completeUrl="/data.jsp"
            hasInput="false" isSingle="true"
            isMustInput="2"
            browserDialogWidth="550px"
            browserDialogHeight="650px"></brow:browser>
    <input name=flength type=hidden  value="100">
</div>

<div style="DISPLAY: none" id="fgroupid">
  <select name="groupid" notBeauty=true>
        <%
    Set<Integer> groupids = htGroup.keySet();  
     for(Integer groupid: groupids){  
        int grouplabel = Util.getIntValue((String)htGroup.get(groupid),0);
    %>
    <option value="<%=groupid %>" <%=groupid==hfm.getGroupid()?"selected":""%>><%=SystemEnv.getHtmlLabelName(grouplabel ,user.getLanguage()) %></option>
    <%} %>
  </select>
</div>

<div style="DISPLAY: none" id="fisuse">
    <input type=checkbox name=chkisuse checked="checked">
  <input type=hidden name=isuse >
</div>

<div style="DISPLAY: none" id="fismand">
    <input type=checkbox name=chkismand >
  <input type=hidden name=ismand >
</div>

<div style="DISPLAY: none" id="fisfixed">
    <input type=checkbox name=chkisfixed >
  <input type=hidden name=isfixed >
</div>

<div style="DISPLAY: none" id="fselectaction">
    <input name=definebroswerType type=hidden  value="emptyVal">
    <input name=type type=hidden  value="0">
    <input type=button value=<%=SystemEnv.getHtmlLabelName(32714,user.getLanguage()) %> class=e8_btn_top onclick="addItemDialog(this,'')" style="width: 80px">
</div>

<div style="DISPLAY: none" id="fselectoptionview">
    <%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>:
    <select class='InputStyle' style='width:70px' name='selectOption' notBeauty=true>
        <option value="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>
    </select>
    <div id="selectItems">
    </div>
</div>

<div style="DISPLAY: none" id="action">
  <input class=InputStyle  name="filedorder"  type="text" value="" style="width: 40px">
</div>
<FORM id=weaver name="weaver" action="HrmCustomFieldOperation.jsp" method=post>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(canEdit){ %>	
			<%if(!viewType.equals("1")){ %>		
				<input type=button class="e8_btn_top" onclick="javascript:openDialog();" value="<%=SystemEnv.getHtmlLabelName(17550,user.getLanguage())%>"></input>
			<%} if(parentid!=0){ %>
				<input type=button class="e8_btn_top" onclick="javascript:openDialog('<%=id %>');" value="<%=SystemEnv.getHtmlLabelName(32732,user.getLanguage())%>"></input>
				<%} %>
				<input type=button class="e8_btn_top" onclick="addrow();" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
				<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(23777, user.getLanguage())%>"></input>
				<input type=button class="e8_btn_top" onclick="copyRow();" value="<%=SystemEnv.getHtmlLabelName(77, user.getLanguage())%>"></input>
				<input type=button class="e8_btn_top" onclick="submitData();" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<input type="hidden" id="method" name="method" value="edit">
<input type="hidden" name="id" value="<%=id%>">
<input type="hidden" name="parentid" value="<%=parentid%>">
<iframe name="selectItemGetter" style="width:100%;height:200;display:none"></iframe>
<wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
<wea:group context="" attributes="{'groupDisplay':'none'}">
<wea:item attributes="{'isTableList':'true'}">
<TABLE CLASS="ListStyle" valign="top" cellspacing=1 style="position:fixed;z-index:99!important;border: 1px">
	<colgroup>
	 <%if(parentid==0){ %>  	
	  <col width="10%">
  	<col width="19%">
  	<col width="13%">
  	<col width="10%">
  	<col width="18%">
  	<col width="10%">
  	<col width="8%">
  	<col width="8%">
    <col width="8%">
	 <%}else{ %>
	 	<col width="10%">
  	<col width="19%">
  	<col width="13%">
  	<col width="10%">
  	<col width="28%">
  	<col width="8%">
  	<col width="8%">
    <col width="8%">
	 <%} %>
  </colgroup>
<TR class=HeaderForXtalbe>
  	<th><input name="chkAll" type="checkbox" onclick="jsChkAll(this)"></th>
  	<th><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%>(字段名)</th>
  	<th colspan="3"><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></th>
  	<%if(parentid==0){ %>
  	<th><%=SystemEnv.getHtmlLabelName(30127,user.getLanguage())%></th>
  	<%} %>
  	<th><input type="checkbox" name="checkalluse" onClick="formUseCheckAll(checkalluse.checked)" value="ON">
  		<%=SystemEnv.getHtmlLabelName(31676,user.getLanguage())%>
  	</th>
  	<th><input type="checkbox" name="checkallmand" onClick="formMandCheckAll(checkallmand.checked)" value="ON">
  		<%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%>
  	</th>
    <th>现有字段</th>
  </tr>
</TABLE>
</wea:item>
</wea:group>
<wea:group context="aaa" attributes="{'groupDisplay':''}">
<wea:item attributes="{'isTableList':'true'}">
<TABLE CLASS="ListStyle" id="inputface" valign="top" cellspacing=1 style="z-index:1!important;">
	<colgroup>
	 <%if(parentid==0){ %>  	
	  <col width="10%">
  	<col width="19%">
  	<col width="13%">
  	<col width="10%">
  	<col width="18%">
  	<col width="10%">
  	<col width="8%">
  	<col width="8%">
    <col width="8%">
	 <%}else{ %>
	 	<col width="10%">
  	<col width="19%">
  	<col width="13%">
  	<col width="10%">
  	<col width="28%">
  	<col width="8%">
  	<col width="8%">
    <col width="8%">
	 <%} %>
  </colgroup>
  <tr class="DataLight"><td colspan="<%=parentid == 0 ? 9 : 8%>"></td></tr>
    <%
    int idx = 0;
    boolean canDel = false;
    while(hfm.next()){
    	boolean isSysField = hfm.isBaseField(hfm.getFieldname());
    	boolean isSysDefinedField = hfm.isBaseDefinedField(hfm.getFieldname());
    	boolean isUsed = false;
    	if(!isSysField)isUsed = hfm.fieldIsUsed( "field"+ hfm.getFieldid());
    	boolean allowhide = hfm.getAllowhide();
    %>
    <tr class="DataLight">
  	<td>
  		<%if(isUsed||isSysField){%>
  			<input name="fieldChk" type="checkbox" value="<%=idx++%>" disabled="disabled">
  		<%}else{ %><input name="fieldChk" type="checkbox" value="<%=idx++%>"><%} %>
  		<img moveimg src='/proj/img/move_wev8.png'   title='<%=SystemEnv.getHtmlLabelName(82783,user.getLanguage())%>' />
  		<input type="hidden" name="fieldname" value="<%=hfm.getFieldname()%>" >
  	</td>
    <td title="<%=hfm.getFieldname()%>">
    	<%if(isSysField&&!isSysDefinedField) {%>
    	<%=SystemEnv.getHtmlLabelName(Integer.parseInt(hfm.getLable()),user.getLanguage())%>
    	<input type="hidden" name="fieldlable" value="<%=SystemEnv.getHtmlLabelName(Integer.parseInt(hfm.getLable()),user.getLanguage())%>">
    	<%}else{ %>
    	<input  class=InputStyle name="fieldlable" value="<%=SystemEnv.getHtmlLabelName(Integer.parseInt(hfm.getLable()),user.getLanguage())%>" <%=disableLable%> onchange='hrmCheckinput(this);' style="width: 100px">
			<SPAN>
			<%if(hfm.getLable().equals("")) {%>
			    <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
			<%}%>
		  </SPAN>
		  <%} %>
		  (<%=hfm.getFieldname()%>)
    	<input  type="hidden" name="fieldid" value="<%=hfm.getFieldid()%>" >
    </td>
    <td>
    	<%=hfm.getHtmlType().equals("1")?""+SystemEnv.getHtmlLabelName(688,user.getLanguage())+"":"" %>
    	<%=hfm.getHtmlType().equals("2")?""+SystemEnv.getHtmlLabelName(689,user.getLanguage())+"":"" %>
    	<%=hfm.getHtmlType().equals("3")?""+SystemEnv.getHtmlLabelName(695,user.getLanguage())+"":"" %>
    	<%=hfm.getHtmlType().equals("4")?""+SystemEnv.getHtmlLabelName(691,user.getLanguage())+"":"" %>
    	<%=hfm.getHtmlType().equals("5")?""+SystemEnv.getHtmlLabelName(690,user.getLanguage())+"":"" %>
    	<%=hfm.getHtmlType().equals("6")?""+SystemEnv.getHtmlLabelName(17616,user.getLanguage())+"":""%>
    	<input name="fieldhtmltype" type="hidden" value="<%=hfm.getHtmlType()%>" >
    </td>
    <td>
	    <%if(hfm.getHtmlType().equals("1")){%>
	   		<%=hfm.getType()==1?""+SystemEnv.getHtmlLabelName(608,user.getLanguage())+"":""%>
	   		<%=hfm.getType()==2?""+SystemEnv.getHtmlLabelName(696,user.getLanguage())+"":""%>
	   		<%=hfm.getType()==3?""+SystemEnv.getHtmlLabelName(697,user.getLanguage())+"":""%>
	    <input name=type type="hidden" value="<%=hfm.getType()%>">
    </td>
    <td>
        <%if(hfm.getType()==1){%>
        	<%=SystemEnv.getHtmlLabelName(608,user.getLanguage()) %>:<%=hfm.getStrLength()%>
          <input  name=flength type=hidden value="<%=hfm.getStrLength()%>">
        <%}else{%>
            <input name=flength type=hidden  value="100">
        <%}%>
        <input name=definebroswerType type=hidden  value="emptyVal">
    </td>
    <%}else if(hfm.getHtmlType().equals("3")){%>
    	<%=SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(String.valueOf(hfm.getType())),0),user.getLanguage())%>
      <input name=type type="hidden" value="<%=hfm.getType()%>">
    </td>
    <td>
    		<%if("emptyVal".equals(hfm.getDmrUrl()) || "".equals(hfm.getDmrUrl())){%>
				<input name=definebroswerType type=hidden  value="emptyVal">
        <%}else{
        out.println(getName(hfm.getDmrUrl()));
		     %>
	            <input name=definebroswerType type=hidden value="<%=hfm.getDmrUrl()%>">
        <%}%>
        <input name=flength type=hidden  value="100">&nbsp;
    </td>
    <%}else if(hfm.getHtmlType().equals("6")){%>
			<%=hfm.getType()==1?SystemEnv.getHtmlLabelName(20798,user.getLanguage()):SystemEnv.getHtmlLabelName(20001,user.getLanguage()) %>
    <input name=type type="hidden" value="<%=hfm.getType()%>">
		</td>
		<td>
		    <input name=flength type=hidden  value="100">
		    <input name=definebroswerType type=hidden  value="emptyVal">
		    &nbsp;
		</td>
		<%}else if(hfm.getHtmlType().equals("5")){%>
        <input name=type type=hidden  value="0">
		<%if(!isSysField && canEdit){%>
        <input type=button value=<%=SystemEnv.getHtmlLabelName(32714,user.getLanguage()) %> class=e8_btn_top onclick="addItemDialog(this,'<%=hfm.getFieldid() %>')" style="width: 95px">
		<%}%>
        </td>
        <td >
      <%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>:
      <select class='InputStyle' style='width:70px' name='selectOption' >
     <%
		     if(hfm.isBaseField(hfm.getFieldname())){
			  		hfm.getSelectItem(hfm.getFieldid()); 
		     }else{
		     	hfm.getCusSelectItem(hfm.getFieldid()); 
		     }
        while(hfm.nextSelect()){
     %>
 					<option value="<%=hfm.getSelectValue()%>"><%=hfm.getSelectName()%></option>
     <%}%>
     	</select>
     		<div id="selectItems">
     		  <%
		        if(hfm.isBaseField(hfm.getFieldname())){
     		  		hfm.getSelectItem(hfm.getFieldid()); 
		        }else{
		        	hfm.getCusSelectItem(hfm.getFieldid()); 
		        	while(hfm.nextSelect()){
		   		     %>
		        		<input name='selectitemid' type=hidden value='<%=hfm.getSelectValue()%>'>
		   					<input name='selectitemvalue' type=hidden value='<%=hfm.getSelectName()%>'>
		   			<%}%>
		        		<input name=selectitemid type=hidden value="--">
            		<input name=selectitemvalue type=hidden >
            <%}%>
            <input name=flength type=hidden  value="100">
            <input name=definebroswerType type=hidden  value="emptyVal">
     		</div>
        </td>
    <%}else{%>
            <input name=type type=hidden  value="0">
        </td>
        <td>
            <input name=flength type=hidden  value="100">
            <input name=definebroswerType type=hidden  value="emptyVal">&nbsp;
        </td>
    <%}%>
    <%if(parentid==0){%>
    <td>
    	<%
    	if( allowhide){ %>
    	<select name="groupid">
    	<%
    	 groupids = htGroup.keySet();  
       for(Integer groupid: groupids){  
      	int grouplabel = Util.getIntValue((String)htGroup.get(groupid),0);
    	%>
    	<option value="<%=groupid %>" <%=groupid==hfm.getGroupid()?"selected":""%>><%=SystemEnv.getHtmlLabelName(grouplabel ,user.getLanguage()) %></option>
    	<%} %>
    	</select>
    	<%}else{ %>
    	<%=SystemEnv.getHtmlLabelName(Util.getIntValue((String)htGroup.get(hfm.getGroupid()),0) ,user.getLanguage()) %>
    	<input name="groupid" type="hidden" value="<%=hfm.getGroupid() %>">
    	<%}%>
    </td>
    <%} %>
        <td>
            <span style="padding-right:50px"><input type=checkbox name=chkisuse <%=disableLable%> <%=allowhide?"":"disabled" %> <%=hfm.isUse()?"checked":""%> id="<%=hfm.getFieldname() %>"></span>
            <input type=hidden name=isuse  value="<%=hfm.isUse()?"1":"0" %>" >
        </td>
        <td>
        		<span style="padding-right:50px"><input type=checkbox name=chkismand  <%=disableLable%> <%=allowhide?"":"disabled" %> <%=hfm.isMand()?"checked":""%> ></span>
            <input type=hidden name=ismand  value="<%=hfm.isMand()?"1":"0" %>" >
        </td>
        <td>
            <span style="padding-right:50px"><input type=checkbox name=chkisfixed disabled></span>
            <input type=hidden name=isfixed  value="0" >
        </td>
        
        <td style="display: none">
  				<input class="InputStyle" name="filedorder" type="text" value="<%=hfm.getOrder()%>" style="width: 40px" >
        </td>
    </tr>
    <%}%>
</TABLE>
</wea:layout>
<%--自定义字段结束--%>
</FORM>

<%--自定义字段--%>
<SCRIPT LANGUAGE=javascript>
var parentid = '<%=parentid%>';
function addrow(){
	var oRow;
	var oCell;
	oRow = jQuery("#inputface")[0].insertRow(-1);
	oRow.className="DataLight";
	oCell = oRow.insertCell(-1);
	oCell.innerHTML = "<input name=fieldChk type=checkbox value=''><img moveimg src='/proj/img/move_wev8.png'   title='<%=SystemEnv.getHtmlLabelName(82783,user.getLanguage())%>' />" ;
	
	oCell = oRow.insertCell(-1);
	oCell.innerHTML = jQuery("#flable").html()+jQuery("#fname").html();
	
	oCell = oRow.insertCell(-1);
	oCell.innerHTML = jQuery("#fhtmltype").html();
	
	oCell = oRow.insertCell(-1);
	oCell.innerHTML = jQuery("#ftype1").html() ;
	
	oCell = oRow.insertCell(-1);
	oCell.innerHTML = jQuery("#ftype5").html() ;
	
	if(parentid==0){
		oCell = oRow.insertCell(-1);
		oCell.innerHTML = jQuery("#fgroupid").html() ;
	}
	oCell = oRow.insertCell(-1);
  oCell.innerHTML = "<span style=\"padding-right:50px\"><input type=checkbox name=chkisuse checked></span><input type=hidden name=isuse >" ;
	
	oCell = oRow.insertCell(-1);
  oCell.innerHTML = "<span style=\"padding-right:50px\"><input type=checkbox name=chkismand></span><input type=hidden name=ismand >";

  oCell = oRow.insertCell(-1);
  var rowIdx = jQuery("#inputface tr").length;
  oCell.innerHTML = "<span style=\"padding-right:50px\"><input type=checkbox name=chkisfixed onclick='changePro("+rowIdx+")'></span><input type=hidden name=isfixed >";
    							
  oCell = oRow.insertCell(-1);
	oCell.innerHTML = "<input class=InputStyle  name=\"filedorder\"  type=\"text\" value=\""+rowIdx+"\" style=\"width: 40px\">";
	oCell.style.display='none';
	
	jQuery("#inputface").find("select").each(function(){
		jQuery(this).attr("notBeauty","");
	})
	jQuery("#inputface").find("select").selectbox();
	jQuery("body").jNice();
}

function copyRow()
{
	if($("input:checked[name='fieldChk']").length<=0)
	{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31433,user.getLanguage())%>");
  	return false;
	}
	var chkObj = jQuery("input:checked[name='fieldChk']");
	chkObj.each(function(){
		var fromTrObj = jQuery(this).parent().parent().parent();
		jQuery(fromTrObj).find("select").each(function(){
			jQuery(this).selectbox("detach");
		});
		var trObj = fromTrObj.clone();
		jQuery(trObj).find("td:first").empty().html("<input name=fieldChk type=checkbox value=''><input type='hidden' name='fieldname' value='' ><img moveimg src='/proj/img/move_wev8.png'   title='<%=SystemEnv.getHtmlLabelName(82783,user.getLanguage())%>' />");
		if(parentid==0){
			jQuery(jQuery(trObj).find("td").get(6)).empty().html("<input type=checkbox name=chkisuse checked><input type=hidden name=isuse >");
			jQuery(jQuery(trObj).find("td").get(7)).empty().html("<input type=checkbox name=chkismand><input type=hidden name=ismand >");
            jQuery(jQuery(trObj).find("td").get(8)).empty().html("<input type=checkbox name=chkisfixed><input type=hidden name=isfixed >");
		}else{
			jQuery(jQuery(trObj).find("td").get(5)).empty().html("<input type=checkbox name=chkisuse checked><input type=hidden name=isuse >");
			jQuery(jQuery(trObj).find("td").get(6)).empty().html("<input type=checkbox name=chkismand><input type=hidden name=ismand >");
            jQuery(jQuery(trObj).find("td").get(7)).empty().html("<input type=checkbox name=chkisfixed><input type=hidden name=isfixed >");
		}
		jQuery(trObj).find("input[name=fieldid]").val("");
		jQuery("#inputface").append($(trObj));
		jQuery("body").jNice();
		jQuery("#inputface").find("select").each(function(){
			beautySelect(this);
		});
		
	});
}

function doDel(){
	clearTempObj();
	var chkobj = $("input:checked[name='fieldChk']");
	if(chkobj.length<=0)
	{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>");
  	return false;
	}

	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
			$("input:checked[name='fieldChk']").each(function(){jQuery(this).parent().parent().parent().remove();});
			if(checkform()){
			weaver.submit();
		    }
	});
}

function jsChkAll(obj){
	$("input[name='fieldChk']").each(function(){
		changeCheckboxStatus(this,obj.checked);
	}); 
}

function formUseCheckAll(checked) {
  jQuery("#inputface").find("input[name=chkffuse]").each(function(){
  	changeCheckboxStatus(this,checked);
  });
  jQuery("#inputface").find("input[name=chkisuse]").each(function(){
  	changeCheckboxStatus(this,checked);
  });
}

function formMandCheckAll(checked) {
  jQuery("#inputface").find("input[name=chkismand]").each(function(){
  	changeCheckboxStatus(this,checked);
  });
}

function htmltypeChange(obj){
	var celltype = jQuery(obj).parents("tr")[0].cells[3];
	var celllenth = jQuery(obj).parents("tr")[0].cells[4];
	if(obj.selectedIndex == 0){
		celltype.innerHTML=jQuery("#ftype1").html() ;
		celllenth.innerHTML=jQuery("#ftype5").html() ;
	}else if(obj.selectedIndex == 2){
		celltype.innerHTML=jQuery("#ftype2").html() ;
		celllenth.innerHTML=jQuery("#ftype4").html() ;
	}else if(obj.selectedIndex == 4){
		celltype.innerHTML=jQuery("#fselectaction").html() ;
		celllenth.innerHTML=jQuery("#fselectoptionview").html() ;
	}else if(obj.selectedIndex == 5){
		celltype.innerHTML=jQuery("#ftype6").html() ;
		celllenth.innerHTML=jQuery("#ftype4").html();
	}else{
		celltype.innerHTML=jQuery("#ftype3").html() ;
		celllenth.innerHTML=jQuery("#ftype4").html();
	}
	jQuery("#inputface").find("select").each(function(){
		jQuery(this).attr("notBeauty","");
	})
	jQuery("#inputface").find("select").selectbox();
}

function typeChange(obj){
	if(obj.selectedIndex == 0){
		jQuery(obj).parents("tr")[0].cells[4].innerHTML=jQuery("#ftype5").html();
	}else{
		jQuery(obj).parents("tr")[0].cells[4].innerHTML=jQuery("#ftype4").html();
	}
	
	jQuery("#inputface").find("select").each(function(){
		jQuery(this).attr("notBeauty","");
	})
	jQuery("#inputface").find("select").selectbox();
}

function BrowserTypeChange(obj){
	//alert("BrowserTypeChange==obj.selectedIndex===" + obj.selectedIndex); 66 67 
	if(obj.selectedIndex == 66 || obj.selectedIndex == 67 ){
		jQuery(obj).parents("tr")[0].cells[4].innerHTML=jQuery("#ftype7").html();
	}
	
	jQuery("#inputface").find("select").each(function(){
		jQuery(this).attr("notBeauty","");
	})
	jQuery("#inputface").find("select").selectbox();
}

function clearTempObj(){
		//flchk.innerHTML="";
		//fname.innerHTML="";
    //flable.innerHTML="";
    //fhtmltype.innerHTML="";
    //ftype1.innerHTML="";
    //ftype2.innerHTML="";
    //ftype3.innerHTML="";
    //ftype4.innerHTML="";
    //ftype5.innerHTML="";
    //ftype6.innerHTML="";
    //ftype7.innerHTML="";
    //fgroupid.innerHTML="";
    //fismand.innerHTML="";
    //fisuse.innerHTML="";
    //fselectaction.innerHTML="";
    //fselectoptionview.innerHTML="";
    //action.innerHTML="";
}

function showSelectRow(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CustomSelectFieldBrowser.jsp");
	if (data!=null){
        return data.id;
	}else{
        return "";
	}
}

function submitData()
{
  clearTempObj();
  var checkFieldnameFlag=true;
	var chkisuses = document.getElementsByName("chkisuse");
	var chkismands = document.getElementsByName("chkismand");
    var chkisfixeds = document.getElementsByName("chkisfixed");
	var chkffuses = document.getElementsByName("chkffuse");
	var isuses = document.getElementsByName("isuse");
	var ismands = document.getElementsByName("ismand");
    var isfixeds = document.getElementsByName("isfixed");
	var ffuses = document.getElementsByName("ffuse");
    var fieldnames = document.getElementsByName("fieldname");
	//var definebroswerTypes = document.getElementsByName("definebroswerType");
	//alert(definebroswerTypes.length+"=="+ismands.length);
	//return;
	for(var i=0;i< chkisuses.length;i++)
	{
		if(chkisuses[i].checked)
			isuses[i].value=1;
		else
			isuses[i].value=0;
		
		if(chkismands[i].checked)
			ismands[i].value=1;
		else
			ismands[i].value=0;
        
        if(chkisfixeds[i].checked){
            isfixeds[i].value=1;
	    if(fieldnames[i].value==''){checkFieldnameFlag=false;}
	    }
        else
            isfixeds[i].value=0;
	}
	
	for(var i=0;i< chkffuses.length;i++)
	{
		if(chkffuses[i].checked)
			ffuses[i].value=1;
		else
			ffuses[i].value=0;
	}
	
	if(!checkFieldnameFlag){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
	}
	
	if(checkform() && checkFieldnameFlag){
		jQuery("#method").val("edit");
		weaver.submit();
  }
}

function checkform()
{
	if(!check_form(document.weaver,"fieldlable"))return false;
	
	var fieldlables = document.getElementsByName("fieldlable");
	var array = new Array();
	var idx = 0;
	for(var i=0;fieldlables!=null&&i<fieldlables.length;i++){
		if(fieldlables[i].value!="")array[idx++]=fieldlables[i].value;
	}
	
	var array=array.sort();
	for(var i=0;i<array.length;i++){
	 if (array[i]==array[i+1]){
	  window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%>  "+ array[i+1]+" <%=SystemEnv.getHtmlLabelName(83381,user.getLanguage())%>");
	  return false;
	 }
	}
	
	var fieldnames = document.getElementsByName("fieldname");
	var array = new Array();
	var idx = 0;
	for(var i=0;fieldnames!=null&&i<fieldnames.length;i++){
		if(fieldnames[i].value!="")array[idx++]=fieldnames[i].value;
	}
	
	var array=array.sort();
	for(var i=0;i<array.length;i++){
	 if (array[i]==array[i+1]){
	  window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83470,user.getLanguage())%>!<br><%=SystemEnv.getHtmlLabelName(24647,user.getLanguage())%>："+array[i]);
	  return false;
	 }
	 }
	
	return true;
}

function deleteField(mid,mparentid){
    if(isdel()){
      document.all("method").value="delete";
      clearTempObj();
      weaver.submit();
    }
}

function changePro(index){
    var chkisfixeds = document.getElementsByName("chkisfixed");
    var fieldnames = document.getElementsByName("fieldname");
    if(chkisfixeds[index-1].checked){
         $(fieldnames[index-1]).next().html('<IMG src=/images/BacoError_wev8.gif align=absMiddle>');
         $(fieldnames[index-1]).show();
    }
    else{
        $(fieldnames[index-1]).val('');
        $(fieldnames[index-1]).next().html('');
        $(fieldnames[index-1]).hide();
    }
}

function checkKey(obj){
    var keys=",PERCENT,PLAN,PRECISION,PRIMARY,PRINT,PROC,PROCEDURE,PUBLIC,RAISERROR,READ,READTEXT,RECONFIGURE,REFERENCES,REPLICATION,RESTORE,RESTRICT,RETURN,REVOKE,RIGHT,ROLLBACK,ROWCOUNT,ROWGUIDCOL,RULE,SAVE,SCHEMA,SELECT,SESSION_USER,SET,SETUSER,SHUTDOWN,SOME,STATISTICS,SYSTEM_USER,TABLE,TEXTSIZE,THEN,TO,TOP,TRAN,TRANSACTION,TRIGGER,TRUNCATE,TSEQUAL,UNION,UNIQUE,UPDATE,UPDATETEXT,USE,USER,VALUES,VARYING,VIEW,WAITFOR,WHEN,WHERE,WHILE,WITH,WRITETEXT,EXCEPT,EXEC,EXECUTE,EXISTS,EXIT,FETCH,FILE,FILLFACTOR,FOR,FOREIGN,FREETEXT,FREETEXTTABLE,FROM,FULL,FUNCTION,GOTO,GRANT,GROUP,HAVING,HOLDLOCK,IDENTITY,IDENTITY_INSERT,IDENTITYCOL,IF,IN,INDEX,INNER,INSERT,INTERSECT,INTO,IS,JOIN,KEY,KILL,LEFT,LIKE,LINENO,LOAD,NATIONAL,NOCHECK,NONCLUSTERED,NOT,NULL,NULLIF,OF,OFF,OFFSETS,ON,OPEN,OPENDATASOURCE,OPENQUERY,OPENROWSET,OPENXML,OPTION,OR,ORDER,OUTER,OVER,ADD,ALL,ALTER,AND,ANY,AS,ASC,AUTHORIZATION,BACKUP,BEGIN,BETWEEN,BREAK,BROWSE,BULK,BY,CASCADE,CASE,CHECK,CHECKPOINT,CLOSE,CLUSTERED,COALESCE,COLLATE,COLUMN,COMMIT,COMPUTE,CONSTRAINT,CONTAINS,CONTAINSTABLE,CONTINUE,CONVERT,CREATE,CROSS,CURRENT,CURRENT_DATE,CURRENT_TIME,CURRENT_TIMESTAMP,CURRENT_USER,CURSOR,DATABASE,DBCC,DEALLOCATE,DECLARE,DEFAULT,DELETE,DENY,DESC,DISK,DISTINCT,DISTRIBUTED,DOUBLE,DROP,DUMMY,DUMP,ELSE,END,ERRLVL,ESCAPE,";
    //以下for oracle.update by cyril on 2008-12-08 td:9722
    keys+="ACCESS,ADD,ALL,ALTER,AND,ANY,AS,ASC,AUDIT,BETWEEN,BY,CHAR,"; 
    keys+="CHECK,CLUSTER,COLUMN,COMMENT,COMPRESS,CONNECT,CREATE,CURRENT,";
    keys+="DATE,DECIMAL,DEFAULT,DELETE,DESC,DISTINCT,DROP,ELSE,EXCLUSIVE,";
    keys+="EXISTS,FILE,FLOAT,FOR,FROM,GRANT,GROUP,HAVING,IDENTIFIED,";
    keys+="IMMEDIATE,IN,INCREMENT,INDEX,INITIAL,INSERT,INTEGER,INTERSECT,";
    keys+="INTO,IS,LEVEL,LIKE,LOCK,LONG,MAXEXTENTS,MINUS,MLSLABEL,MODE,";
    keys+="MODIFY,NOAUDIT,NOCOMPRESS,NOT,NOWAIT,NULL,NUMBER,OF,OFFLINE,ON,";
    keys+="ONLINE,OPTION,OR,ORDER,PCTFREE,PRIOR,PRIVILEGES,PUBLIC,RAW,";
    keys+="RENAME,RESOURCE,REVOKE,ROW,ROWID,ROWNUM,ROWS,SELECT,SESSION,";
    keys+="SET,SHARE,SIZE,SMALLINT,START,SUCCESSFUL,SYNONYM,SYSDATE,TABLE,";
    keys+="THEN,TO,TRIGGER,UID,UNION,UNIQUE,UPDATE,USER,VALIDATE,VALUES,";
    keys+="VARCHAR,VARCHAR2,VIEW,WHENEVER,WHERE,WITH,";
    var fname=obj.value;
    if (fname!=""){
        fname=","+fname.toUpperCase()+",";
        if (keys.indexOf(fname)>0){
            window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(19946,user.getLanguage())%>');
            obj.value="";
            return false;
        }
    }
    return true;
}

//判断input框中是否输入的是英文字母和数字，并且以字母开头
function checkinput_char_num(obj)
{
valuechar = obj.value.split("") ;
if(valuechar.length==0){
    return ;
}
notcharnum = false ;
notchar = false ;
notnum = false ;
for(i=0 ; i<valuechar.length ; i++) {
    notchar = false ;
    notnum = false ;
    charnumber = parseInt(valuechar[i]) ; if(isNaN(charnumber)) notnum = true ;
    if((valuechar[i].toLowerCase()<'a' || valuechar[i].toLowerCase()>'z')&&valuechar[i]!='_') notchar = true ;
    if(notnum && notchar) notcharnum = true ;
}
if(valuechar[0].toLowerCase()<'a' || valuechar[0].toLowerCase()>'z') notcharnum = true ;
if(notcharnum) obj.value = "" ;
}


function hrmCheckinput(obj){
    if(obj.value==""){
        jQuery(obj).next("span").html("<IMG src=/images/BacoError_wev8.gif align=absMiddle>");
    }else{
        jQuery(obj).next("span").html("");
    }
}

jQuery(function(){
	$("#inputface").find("tr")
	.live("mouseover",function(){$(this).find("img[moveimg]").attr("src","/proj/img/move-hot_wev8.png")})
	.live("mouseout",function(){$(this).find("img[moveimg]").attr("src","/proj/img/move_wev8.png")});
	
	jQuery("#accounttype").bind('click',function(){
		if(jQuery(this).attr("checked")){
			changeCheckboxStatus(jQuery("#belongto"),true);
		}else{
			changeCheckboxStatus(jQuery("#belongto"),false);
		}
	})
	jQuery("#belongto").bind('click',function(){
		if(jQuery(this).attr("checked")){
			changeCheckboxStatus(jQuery("#accounttype"),true);
		}else{
			changeCheckboxStatus(jQuery("#accounttype"),false);
		}
	})
});
</script>
</BODY>
</HTML>