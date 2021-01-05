
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<%@ page import="weaver.formmode.service.ModelInfoService"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="modeLinkageInfo" class="weaver.formmode.setup.ModeLinkageInfo" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>
<html>
<head>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript" src="/js/dragBox/rightspluing_wev8.js"></script>
<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
<style type="text/css">
#lavaoTable{
	border-collapse: collapse;
	margin: 10px 0;
	width: 100%;
}	
#lavaoTable tr th{
	text-align: left;
	padding: 4px;
	background-color: #eee;
}
#lavaoTable tr td{
	padding: 4px;
	border-bottom: 1px solid #eee;
	background-color: #fff;
}
</style>
</head>
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
ModelInfoService modelInfoService = new ModelInfoService();
int modeId = Util.getIntValue(request.getParameter("id"),0);
if(modeId<=0){
	modeId = Util.getIntValue(request.getParameter("modeId"),0);
}
int formId = Util.getIntValue(request.getParameter("formId"),0);
if(modeId > 0 && formId == 0){
	formId = modelInfoService.getFormInfoIdByModelId(modeId); 
}

String subCompanyIdsql = "select subCompanyId from modeinfo where id="+modeId;
RecordSet recordSet = new RecordSet();
recordSet.executeSql(subCompanyIdsql);
int subCompanyId = -1;
if(recordSet.next()){
	subCompanyId = recordSet.getInt("subCompanyId");
}
String userRightStr = "ModeSetting:All";
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);

String titlename=SystemEnv.getHtmlLabelName(82199,user.getLanguage());//属性联动设置
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(operatelevel>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:linkageviewattrsubmit(this),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body style="height:400px;">
<%
//布局ID，布局名称（新建、编辑布局）
//String types = "1,2";
//String typenames = SystemEnv.getHtmlLabelName(16388,user.getLanguage())+","+ SystemEnv.getHtmlLabelName(16449,user.getLanguage());
String types = "";
String typenames = "";
rs.executeSql("select * from modehtmllayout where modeid="+modeId+" and formid="+formId+" and type in (1,2) order by type desc");
while(rs.next()){
	types += Util.null2String(rs.getString("id"))+",";
	typenames += Util.null2String(rs.getString("layoutname"))+",";
}
if(!"".equals(types)){
	types = types.substring(0, types.length()-1);
	typenames = typenames.substring(0, typenames.length()-1);
}
Map map = null;
String selectfields="";
String selectfieldnames="";
String selectfieldvalues="";
String selectfieldvaluenames="";
String firstselectfieldid="";

modeLinkageInfo.setUser(user);
modeLinkageInfo.setModeId(modeId);
modeLinkageInfo.setType(1);
modeLinkageInfo.init();
List selectFields = modeLinkageInfo.getSelectFieldByEdit();

/* for(int i=0;i<selectFields.size();i++){
	map = (Map)selectFields.get(i);
	if(selectfields.equals("")){
		selectfields = (String)map.get("fieldid")+"_"+(String)map.get("isdetail");
		selectfieldnames = (String)map.get("fieldname");
		firstselectfieldid = (String)map.get("fieldid");
	}else{
		selectfields += ","+(String)map.get("fieldid")+"_"+(String)map.get("isdetail");
		selectfieldnames += ","+(String)map.get("fieldname");
	}
}

List selectList = modeLinkageInfo.getSelectFieldItem(Util.getIntValue(firstselectfieldid,0));
for(int i=0;i<selectList.size();i++){
	map = (Map)selectList.get(i);
	if(selectfieldvalues.equals("")){
        selectfieldvalues=(String)map.get("selectvalue");
        selectfieldvaluenames=(String)map.get("selectname");
    }else{
        selectfieldvalues+=","+(String)map.get("selectvalue");
        selectfieldvaluenames+=","+(String)map.get("selectname");
    }
} */
%>

<form name="linkageattr" id="linkageattr" method="post" action="ModeOperation.jsp" >
	<input type=hidden name="operate" value="linkageattr">
	<input type=hidden name="modeId" value="<%=modeId%>">
    <input type=hidden name="formId" value="<%=formId%>">
	<TABLE id="lavaoTable" style="width:100%;" class="e8_tblForm">
	<COLGROUP>
	  <COL width="5%">
	  <COL width="25%">
	  <COL width="15%">
	  <COL width="10%">
	  <COL width="30%">
	  <COL width="10%">
	  <TBODY>
	    <TR>
	      <TD colSpan=2 style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(21694,user.getLanguage())%></TD><!-- 显示属性联动列表 -->
	      <TD colSpan=4 align="right"><!-- 添加行 -->
	      <%if(operatelevel>0){%>
	      <button
	      	type="button"
	      	title="<%=SystemEnv.getHtmlLabelName(21690,user.getLanguage())%>" 
	      	class="addbtn2" 
	      	onclick='linkagevaaddrow("<%=types%>","<%=typenames%>","<%=selectfields%>","<%=selectfieldnames%>","<%=selectfieldvalues%>","<%=selectfieldvaluenames%>")'></button>
	     <% } %>
	     
	     <%if(operatelevel>1){%><!-- 删除行 -->
	      <button 
	      	type="button"
	      	title="<%=SystemEnv.getHtmlLabelName(16182,user.getLanguage())%>"
	      	class="deletebtn2" 
	      	onclick="linkagevadelrow()"></button>
	     <% } %>
	    </TR>
	    
	    <TR>
		  <TH width="5%"><input type='checkbox' name='checkall' onclick="linkagevaselectall(this)"></TH>
		  <TH><%=SystemEnv.getHtmlLabelName(19407,user.getLanguage())%><!-- 布局 --></TH>
		  <TH><%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%><!-- 选择框 --></TH>
		  <TH><%=SystemEnv.getHtmlLabelName(21687,user.getLanguage())%><!--  选择框值  --></TH>
		  <TH><%=SystemEnv.getHtmlLabelName(82200,user.getLanguage())%><!-- 变更字段 --></TH>
		  <TH><%=SystemEnv.getHtmlLabelName(21689,user.getLanguage())%><!-- 显示属性 --></TH>
		</TR>
		<%
		String checkfield="";
	    String sql="select * from modeattrlinkage where modeid="+modeId+" order by id";
	   
	    int i = 0;
	    rs.executeSql(sql);
	    while(rs.next()){
	    	int type = Util.getIntValue(rs.getString("layoutid"),0);
	        String selectfieldid = Util.null2String(rs.getString("selectfieldid"));
	        String selectfieldvalue = Util.null2String(rs.getString("selectfieldvalue"));
	        String changefieldids = Util.null2String(rs.getString("changefieldids"));
	        String viewattr = Util.null2String(rs.getString("viewattr"));
	        checkfield+="type_"+i+",selectfieldid_"+i+",selectfieldvalue_"+i+",changefieldids_"+i+",";
	        ArrayList changefieldidlist=Util.TokenizerString(changefieldids,",");
	        int index=selectfieldid.indexOf("_");
	        String viewtype="";
	        int tselectfieldid=0;
	        if(index!=-1){
	            tselectfieldid=Util.getIntValue(selectfieldid.substring(0,index));
	            viewtype=selectfieldid.substring(index+1);
	        }
	        String fieldnames="";
	        
	        modeLinkageInfo.setUser(user);
	        modeLinkageInfo.setModeId(modeId);
	        modeLinkageInfo.setType(type);
	        //modeLinkageInfo.setViewtype(viewtype);
	        modeLinkageInfo.setFieldId(tselectfieldid);
	        modeLinkageInfo.init();
	        List selectLists = modeLinkageInfo.getSelectFieldByEdit();
	        
	        List svalueLists = modeLinkageInfo.getSelectFieldItem(tselectfieldid);
	        
	        List editfield = modeLinkageInfo.getFieldsByEdit();
	        List tfieldidlist = new ArrayList();
	        List tfieldnamelist = new ArrayList();
	        for(int j=0;j<editfield.size();j++){
	        	Map maps = (Map)editfield.get(j);
	        	String fid = (String)maps.get("fieldid");
	        	String fna = (String)maps.get("fieldname");
	        	tfieldidlist.add(fid);
	        	tfieldnamelist.add(fna);
	        }
	        for(int j=0;j<changefieldidlist.size();j++){
	            String tfieldid=(String)changefieldidlist.get(j);
	            tfieldid=tfieldid.substring(0,tfieldid.indexOf("_"));
	            int _index=tfieldidlist.indexOf(tfieldid);
	            if(_index<0||selectfieldid.equals(changefieldidlist.get(j))){
	                fieldnames+=",<font style=\"background-color:red\">"+modeLinkageInfo.getFieldnames(Util.getIntValue(tfieldid))+"</font>";
	            }else{
	                fieldnames+=","+tfieldnamelist.get(_index);
	            }
	        }
	        if(!"".equals(fieldnames)){
	          fieldnames = fieldnames.substring(1);
	        }
	        Map maps = null;
	    %>
	    <TR  <%if(i%2==0){%>CLASS="datadark"<%}else{%>class="datalight" <%}%>>
	      <TD class="e8_tblForm_field"><input type='checkbox' name='check_mode' value='<%=i%>'></TD>
	      <TD class="e8_tblForm_field">
	        <select class=inputstyle name='modeid_<%=i %>'  onchange='lavachangemode(this.value,<%=i %>)'>
 			<%
		      rs1.executeSql("select * from modehtmllayout where modeid="+modeId+" and formid="+formId+" and type in (1,2) order by type desc");
				while(rs1.next()){
		      		int layoutid = Util.getIntValue(rs1.getString("id"));
					String layoutname = Util.null2String(rs1.getString("layoutname"));
		      %>
		          <option value="<%=layoutid%>" <%if(type==layoutid){%>selected<%}%>><%=layoutname%></option>
		      <%}%>
	        </select>
	      </TD>
	      
	      <TD class="e8_tblForm_field"><select class=inputstyle name='selectfieldid_<%=i%>' id='selectfieldid_<%=i%>' onchange="lavachangefield(this.value,<%=i%>)">
		      <%
		      int notselectfield = -1;
		      for(int j=0;j<selectLists.size();j++){
		    	    maps = (Map)selectLists.get(j);
		      		String field = Util.null2String((String)maps.get("fieldid"));
		      		if(field.equals(selectfieldid.substring(0,selectfieldid.indexOf("_"))) && notselectfield == -1)
		      			notselectfield = j;
		      		String fieldn = Util.null2String((String)maps.get("fieldname"));
		      		int isdtl = Util.getIntValue((String)maps.get("isdetail"),0);
		      %>
		          <option value="<%=field+"_"+isdtl%>" <%if(field.equals(selectfieldid.substring(0,selectfieldid.indexOf("_")))){%>selected<%}%>><%=fieldn%></option>
		      <%}%>
		      <%
		      if(!selectfieldid.substring(0,selectfieldid.indexOf("_")).equals("") && notselectfield==-1){%>
		          <option value="" style="background-color:red" selected><%=SystemEnv.getHtmlLabelName(21697,user.getLanguage())%></option><!-- 选择框字段已被更改 -->
		      <%}%>
		      </select>
		      <span id="selectfieldid_<%=i%>span"><%if(selectLists.size()<1){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></span>
	      </TD>
	      <TD class="e8_tblForm_field"><select class=inputstyle name='selectfieldvalue_<%=i%>' id='selectfieldvalue_<%=i%>'>
		      <%
		      int notselectfieldvalue = -1;
		      for(int j=0;j<svalueLists.size();j++){
		    	  	maps = (Map)svalueLists.get(j);
		    	  	String selectvalue = Util.null2String((String)maps.get("selectvalue"));
		      		String selectname = Util.null2String((String)maps.get("selectname"));
		      		if(selectfieldvalue.equals(selectvalue) && notselectfieldvalue==-1)
		      			notselectfieldvalue = j;
		      %>
		          <option value="<%=selectvalue%>" <%if(selectfieldvalue.equals(selectvalue)){%>selected<%}%>><%=selectname%></option>
		      <%}%>
		      <%if(!selectfieldvalue.equals("") && notselectfieldvalue==-1){%>
		          <option value="" style="background-color:red" selected><%=SystemEnv.getHtmlLabelName(21698,user.getLanguage())%></option><!-- 选择框字段值已被更改 -->
		      <%}%>
		      </select>
		      <span id="selectfieldvalue_<%=i%>span"><%if(svalueLists.size()<1){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></span>
	      </TD>
	      <TD class="e8_tblForm_field" >
	          <!-- <button type='button' class=Browser onclick="lavaShowMultiField('changefieldidsspan_<%=i%>','changefieldids_<%=i%>',modeid_<%=i%>.value,selectfieldid_<%=i%>.value)"></button><SPAN id="changefieldidsspan_<%=i%>"><%if(changefieldids.equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}else{%><%=fieldnames%><%}%></SPAN>
	          <input type='hidden' class=inputstyle name='changefieldids_<%=i%>' id='changefieldids_<%=i%>' value="<%=changefieldids%>"> -->
	      	  <%
	      	  pageContext.setAttribute("i", i);
	      	  pageContext.setAttribute("modeId", modeId);
	      	  pageContext.setAttribute("type", type);
	      	  pageContext.setAttribute("selfieldid", selectfieldid);
	      	  pageContext.setAttribute("fieldids", changefieldids);
	      	  String browserName="changefieldids_"+i;
	      	  %>
  		 				<!-- browserUrl="'+setClickUrl()+'" -->
	      	  <brow:browser viewType="0" name='<%=browserName%>' browserValue='<%=changefieldids%>' 
  		 				browserUrl=""
						hasInput="false" isSingle="true" hasBrowser = "true" isMustInput="2"
						completeUrl="/data.jsp" linkUrl=""  width="228px"
						browserDialogWidth="500px"
						browserSpanValue='<%=fieldnames %>'>
			  </brow:browser>
	      </TD>
	      <TD class="e8_tblForm_field" >
	      <select class=inputstyle name='viewattr_<%=i%>' onchange="">
	        <option value="2" <%if(viewattr.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%></option><!-- 必填 -->
	        <option value="1" <%if(viewattr.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option><!-- 编辑 -->
	        <option value="3" <%if(viewattr.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17873,user.getLanguage())%></option><!-- 只读 -->
			 <option value="4" <%if(viewattr.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%></option><!-- 隐藏 -->
	      </select>
	      </TD>
	    </TR>
	    <%	i++;
	    }
		%>
	</TABLE>
	<input type='hidden' id="linkage_rownum" name="linkage_rownum" value="<%=i%>">
	<input type='hidden' id="linkage_indexnum" name="linkage_indexnum" value="<%=i%>">
	<input type='hidden' id="checkfield" name="checkfield" value="<%=checkfield%>">	
</form>		


</body>
<script type="text/javascript">
function setBrowserUrl(rownum){
	
}

$(document).ready(function(){//onload事件
	$(".loading", window.parent.document).hide(); //隐藏加载图片
	var oTable=document.getElementById("lavaoTable");
	if(oTable.rows.length === 2){
		linkagevaaddrow("<%=types%>","<%=typenames%>","<%=selectfields%>","<%=selectfieldnames%>","<%=selectfieldvalues%>","<%=selectfieldvaluenames%>");
	}
	else{
		var check_modes = document.getElementsByName("check_mode");
		for(var v=0; v<check_modes.length; v++){
			var rownum = check_modes[v].value;
			//alert($("#changefieldids_"+rownum).parent().parent().next().children("span").children("button").attr("class"));
			//$("#changefieldids_"+rownum).parent().parent().next().children("span").children("button").attr("class");
			//var btn = document.getElementById("changefieldids_"+rownum).parentNode.parentNode.nextSibling.getElementsByTagName("span")[0].getElementsByTagName("button")[0];
			var btn = $("#changefieldids_"+rownum+"_browserbtn");
			btn.click(function(){
				var btnid = $(this).attr("id");
				var rownum = btnid.split("_")[1];
				//var chk = this.parentNode.parentNode.parentNode.parentNode.parentNode.getElementsByTagName("td")[0].getElementsByTagName("span")[0].getElementsByName("check_mode")[0];
				//var rownum = this.parentNode.parentNode.parentNode.parentNode.parentNode.getElementsByTagName("td")[0].getElementsByTagName("span")[0].getElementsByTagName("input")[0].value;
				//$("#changefieldids_"+rownum).parent().parent().parent().parent().parent().children("td").children("span").children("input").attr("name");
				//alert(rownum);
				setClickUrl(event,rownum);
			});
		}
	}
})
function linkagevaselectall(obj){
	var checkboxs = document.getElementsByName("check_mode");
	for(var i=0;i<checkboxs.length;i++){
		//checkboxs[i].checked=obj.checked;
		changeCheckboxStatus(checkboxs[i],obj.checked);
	}
}
function linkageviewattrsubmit(obj){
	if (checkFieldValue(linkageattr.checkfield.value)){
		linkageattr.submit();
        obj.disabled=true;
    }
}

function checkFieldValue(ids){
	var idsArr = ids.split(",");
	for(var i=0;i<idsArr.length;i++){
		var obj = document.getElementById(idsArr[i]);
		if(obj&&obj.value==""){
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>",function(){displayAllmenu();});//必要信息不完整！
			return false;
		}
	}
	return true;
}

function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}

function lavachangemode(type,rownum){
//alert(document.getElementById("changefieldids_"+rownum).parentNode.parentNode.nextSibling.getElementsByTagName("span")[0].getElementsByTagName("button")[0].className);
    fieldsel=document.getElementById("selectfieldid_"+rownum);
    fieldselspan=document.getElementById("selectfieldid_"+rownum+"span");
    changefieldids=document.getElementById("changefieldids_"+rownum);
    changefieldidspan=document.getElementById("changefieldidsspan_"+rownum);
    clearOptionsCodeSeqSet(fieldsel);
    var ajax=ajaxinit();
    ajax.open("POST", "FieldSelectAjax.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("modeId=<%=modeId%>&option=selfield&languageid=<%=user.getLanguage()%>&type="+type);
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
            var returnvalues=ajax.responseText;
            if(returnvalues==""){
                fieldselspan.innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
                fieldsel.options.add(new Option("",""));
                lavachangefield("",rownum);
            }else{
                fieldselspan.innerHTML="";
                var selefields=returnvalues.split(",");
                for(var i=0; i<selefields.length; i++){
                    var itemids=selefields[i].split("$");
                    fieldsel.options.add(new Option(itemids[1],itemids[0]));
                    
                    if(i==0) {
                        lavachangefield(itemids[0],rownum);
                    }
                }
            }
   			jQuery(fieldsel).selectbox("detach");
            beautySelect(fieldsel);
            changefieldids.value="";
            changefieldidspan.innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
            }catch(e){}
        }
    }
}

function lavachangefield(fieldid,rownum){
    fieldvaluesel=document.getElementById("selectfieldvalue_"+rownum);
    fieldvalueselspan=document.getElementById("selectfieldvalue_"+rownum+"span");
    changefieldids=document.getElementById("changefieldids_"+rownum);
    changefieldidspan=document.getElementById("changefieldids_"+rownum+"span");
    changefieldidspanimg=document.getElementById("changefieldids_"+rownum+"spanimg");
    clearOptionsCodeSeqSet(fieldvaluesel);
    var ajax=ajaxinit();
    ajax.open("POST", "FieldSelectAjax.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("option=selfieldvalue&languageid=<%=user.getLanguage()%>&fieldId="+fieldid);
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
            var returnvalues=ajax.responseText;
            if(returnvalues==""){
                fieldvalueselspan.innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
                fieldvaluesel.options.add(new Option("",""));
            }else{
                fieldvalueselspan.innerHTML="";
                var selefieldvalues=returnvalues.split(",");
                for(var i=0; i<selefieldvalues.length; i++){
                    var itemids=selefieldvalues[i].split("$");
                    fieldvaluesel.options.add(new Option(itemids[1],itemids[0]));
                }
            }
            jQuery(fieldvaluesel).selectbox("detach");
            beautySelect(fieldvaluesel);
            changefieldids.value="";
            changefieldidspan.innerHTML="";
            changefieldidspanimg.innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
            }catch(e){}
        }
    }
}

function linkagevaaddrow(types,typenames,selectfieldids,selectfieldnames,selectvalues,selectvaluenames){
    var typearray=types.split(",");
    var typenamearray=typenames.split(",");
    var selectfieldidarray=selectfieldids.split(",");
    var selectfieldnamearray=selectfieldnames.split(",");
    var selectvaluearray=selectvalues.split(",");
    var selectvaluenamearray=selectvaluenames.split(",");
    var oTable=document.getElementById("lavaoTable");
    var curindex=parseInt($('#linkage_rownum').val());
    var rowindex=parseInt($('#linkage_indexnum').val());
    var ncol = 6;
    var oRow = oTable.insertRow(-1);
    for(j=0; j<ncol; j++) {
        var oCell = oRow.insertCell(-1);
		//oCell.style.height = 24;
		//oCell.style.background= "#E7E7E7";
		switch(j) {
            case 0:
            {
                var oDiv = document.createElement("div");
                var sHtml = "<input type='checkbox' name='check_mode' value='"+rowindex+"'>";
                oDiv.innerHTML = sHtml;
                jQuery(oDiv).jNice();
                oCell.appendChild(oDiv);
                break;
            }
            case 1:
            {
                var oDiv = document.createElement("div");
                var sHtml = "<select class=inputstyle name='modeid_"+rowindex+"' id='modeid_"+rowindex+"'  onchange='lavachangemode(this.value,"+rowindex+")'>"
                sHtml+="<option value=''></option>";
                for(i=0;i<typearray.length;i++){
                    sHtml+="<option value='"+typearray[i]+"'>"+typenamearray[i]+"</option>";
                }
                sHtml+="</select><span id='modeid_"+rowindex+"span'>";
                if(types==""){
                    sHtml+="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
                }
                sHtml+="</span>";
                oDiv.innerHTML = sHtml;
                oCell.appendChild(oDiv);
                break;
            }
            case 2:
            {
                var oDiv = document.createElement("div");
                var sHtml = "<select class=inputstyle name='selectfieldid_"+rowindex+"' id='selectfieldid_"+rowindex+"' onchange='lavachangefield(this.value,"+rowindex+")'>";
                for(i=0;i<selectfieldidarray.length;i++){
                    sHtml+="<option value='"+selectfieldidarray[i]+"'>"+selectfieldnamearray[i]+"</option>";
                }
                sHtml+="</select><span id='selectfieldid_"+rowindex+"span'>";
                if(selectfieldids==""){
                    sHtml+="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
                }
                sHtml+="</span>";
                oDiv.innerHTML = sHtml
                oCell.appendChild(oDiv);
                break;
            }
            case 3:
            {
                var oDiv = document.createElement("div");
                var sHtml = "<select class=inputstyle name='selectfieldvalue_"+rowindex+"' id='selectfieldvalue_"+rowindex+"'>";
                for(i=0;i<selectvaluearray.length;i++){
                    sHtml+="<option value='"+selectvaluearray[i]+"'>"+selectvaluenamearray[i]+"</option>";
                }
                sHtml+="</select><span id='selectfieldvalue_"+rowindex+"span'>";
                if(selectvalues==""){
                    sHtml+="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
                }
                sHtml+="</span>";
                oDiv.innerHTML = sHtml;
                oCell.appendChild(oDiv);
                break;
            }
            case 4:
            {
                var oDiv = document.createElement("div");
                var sHtml =
                	"<div class='e8_innerShow e8_innerShow_button e8_innerShow_button_right30'>"+
					"<span class='e8_spanFloat'>"+
					"<span class='e8_browserSpan'>"+
					"<button class='Browser e8_browflow' type='button' onclick='setClickUrl(event,"+rowindex+")'></button></span></span></div>"+
                	"<div class='e8_innerShow e8_innerShowMust' id='innerShowMust_"+rowindex+"div'>"+
                	"<span class='e8_spanFloat' id='changefieldids_"+rowindex+"spanimg' name='changefieldids_"+rowindex+"spanimg'/><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span></div>"+
                	"<div class='e8_outScroll' id='outchangefieldids_"+rowindex+"div' style='max-height: 26px;width: 100%; margin-right: -30px;'>"+
					"<div class='e8_innerShow e8_innerShowContent' id='innerContentchangefieldids_"+rowindex+"div' style='width: 100%; margin-right:30px;'>"+
					"<div id='innerchangefieldids_"+rowindex+"div' style='margin-left:31px;' hasAdd=false hasBrowser=true>"+
					"<input name='changefieldids_"+rowindex+"' id='changefieldids_"+rowindex+"' onpropertychange='' type='hidden' temptitle='' viewtype='0' value=''/>"+
					"<span id='changefieldids_"+rowindex+"span' name='changefieldids_"+rowindex+"span'></span>"+
					"</div>"+
					"</div>"+
					"</div>";
                //var sHtml = "<button type='button' class=Browser onclick='lavaShowMultiField(\"changefieldidsspan_"+rowindex+"\",\"changefieldids_"+
                //            rowindex+"\",modeid_"+rowindex+".value,selectfieldid_"+rowindex+".value)'></button><SPAN id='changefieldidsspan_"+rowindex+
                //            "'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN><input type='hidden' class=inputstyle name='changefieldids_"+rowindex+"' id='changefieldids_"+rowindex+"'>";
                oDiv.innerHTML = sHtml;
                oDiv.className = "e8_os";
                oDiv.style.width = "228px";
                oCell.appendChild(oDiv);
                break;
            }
            case 5:
            {
                var oDiv = document.createElement("div");
                var sHtml = "<select class=inputstyle name='viewattr_"+rowindex+"' id='viewattr_"+rowindex+"'>";
                sHtml+="<option value=2><%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%></option> ";//必填
                sHtml+="<option value=1><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option>";//编辑
                sHtml+="<option value=3><%=SystemEnv.getHtmlLabelName(17873,user.getLanguage())%></option>";//只读
				sHtml+="<option value=4><%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%></option>";//-- 隐藏 -->
                sHtml+="</select>";
                oDiv.innerHTML = sHtml;
                oCell.appendChild(oDiv);
                break;
            }
        }
    }
    $('#checkfield').val($('#checkfield').val()+"modeid_"+rowindex+",selectfieldid_"+rowindex+",selectfieldvalue_"+rowindex+",changefieldids_"+rowindex+",");
    $("#linkage_rownum").val(curindex+1) ;
    $('#linkage_indexnum').val(rowindex+1);

    beautySelect();
}
function linkagevadelrow(){
	var oTable=document.getElementById('lavaoTable');
    curindex=parseInt(document.getElementById("linkage_rownum").value);
    len = document.linkageattr.elements.length;
    var i=0;
    var rowsum1 = 0;
    var delsum=0;
    for(i=len-1; i >= 0;i--) {
        if (document.linkageattr.elements[i].name=='check_mode'){
            rowsum1 += 1;
            if(document.linkageattr.elements[i].checked==true) delsum+=1;
        }
    }
    if(delsum<1){
        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return;
    }else{
	    window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>",function(){
			var oTable=$G('lavaoTable');
	        curindex=parseInt($G("linkage_rownum").value);
	        len = document.linkageattr.elements.length;
	        var i=0;
	        var rowsum1 = 0;
	        for(i=len-1; i >= 0;i--) {
	            if (document.linkageattr.elements[i].name=='check_mode')
	                rowsum1 += 1;
	        }
	        for(i=len-1; i >= 0;i--) {
	            if (document.linkageattr.elements[i].name=='check_mode'){
	                if(document.linkageattr.elements[i].checked==true) {
	                    $G('checkfield').value = ($G('checkfield').value).replace("modeid_"+document.linkageattr.elements[i].value+",","");
	                    $G('checkfield').value = ($G('checkfield').value).replace("selectfieldid_"+document.linkageattr.elements[i].value+",","");
	                    $G('checkfield').value = ($G('checkfield').value).replace("selectfieldvalue_"+document.linkageattr.elements[i].value+",","");
	                    $G('checkfield').value = ($G('checkfield').value).replace("changefieldids_"+document.linkageattr.elements[i].value+",","");
	                    oTable.deleteRow(rowsum1+1);
	                    curindex--;
	                }
	                rowsum1 -=1;
	            }
	        }
	        $G("linkage_rownum").value=curindex;
		});
	}
}
function encode(str){
    return escape(str);
}

function lavaShowMultiField(spanname,hiddenidname,modeid,fieldid){
	url=encode("/formmode/setup/MultiFormmodeFieldBrowser.jsp?modeId=<%=modeId%>&type="+modeid+"&selfieldid="+fieldid+"&fieldids="+$("#"+hiddenidname).val())
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
	issame = false;
	if (datas != undefined && datas != null) {
		if(datas.id != ""){
			$("#"+spanname).html(datas.name);
			$("#"+hiddenidname).val(datas.id);
		}else{
			$("#"+spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			$("#"+hiddenidname).val("");
		}
	}
}

//删除下拉框中的所有选项
function clearOptionsCodeSeqSet(ctl)
{
	for(var i=ctl.options.length-1; i>=0; i--){
		ctl.remove(i);
	}
}

function setClickUrl(e,rownum){
	//var url = "/systeminfo/BrowserMain.jsp?url=/formmode/setup/MultiFormmodeFieldBrowser.jsp?1=1";
	var url = "/systeminfo/BrowserMain.jsp?url=/formmode/setup/FormmodeFieldBrowser.jsp?1=1";
	var type = document.getElementsByName("modeid_"+rownum)[0].value;
	var selfieldid = document.getElementsByName("selectfieldid_"+rownum)[0].value;
	var fieldids = document.getElementById("changefieldids_"+rownum).value;
	var param = "";
	param += "&modeId=<%=modeId%>";
	param += "&type="+type;
	param += "&selfieldid="+selfieldid;
	param += "&fieldids="+fieldids;
	param += "&rownum="+rownum;
	//alert(url+param);
	
	//var data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/setup/FormmodeFieldBrowser.jsp?1=1"+param);
	showColDialog1(param);
	//alert(data);
	//showModalDialogForBrowser(e,url+param,'#','changefieldids_'+rownum,true,2,'',{name:'changefieldids_'+rownum,hasInput:false,zDialog:true,dialogTitle:'请选择',dialogWidth:600,arguments:'dialogWidth=600px'});
}

var dialog = null;
function showColDialog1(param){
   	dialog = new top.Dialog();
   	dialog.currentWindow = window;
   	dialog.okLabel = "<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>";//确定
   	dialog.cancelLabel = "<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>";//取消
   	dialog.Drag = true;
   	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("18214,82200",user.getLanguage())%>";//请选择变更字段
   	dialog.Width = 600;
   	dialog.Height = 400;
   	dialog.callbackfun = function(callbackfunParam, data){
   		var rownum = callbackfunParam.rownum;
   		if(rownum && rownum != ""){
	   		var newids = "";
	   		var newnames = "";
	   		var ids = data.id;
	   		var names = data.name;
	   		var id_arr = ids.split(",");
	   		var name_arr = names.split(",");
	   		for(var v=0; v<id_arr.length; v++){
	   			if(id_arr[v] && id_arr[v] != ""){
	   				var selectVal = jQuery("#selectfieldid_"+rownum).val();
	   				var isdetail = selectVal.split("_")[1];
	   				var newid = id_arr[v]+"_"+isdetail;//这里应该为是否为子表而不是行数
	   				newids += ","+newid;
	   				newnames += "  <a href='#"+newid+"'>"+name_arr[v]+"</a>";
	   			}
	   		}
	   		if(newids && newids != ""){
	   			newids = newids.substring(1);
	   			newnames = newnames.substring(1);
	   		}
	   		//alert(newids+"---"+newnames);
	   		document.getElementsByName("changefieldids_"+rownum)[0].value = newids;
	   		
	   		var span_temp = document.createElement("span");
	   		span_temp.className = "e8_showNameClass";
	   		span_temp.innerHTML = newnames;
	   		
	   		document.getElementsByName("changefieldids_"+rownum+"span")[0].innerHTML = span_temp.outerHTML;
	   		if(newnames!=""){
	   			document.getElementsByName("changefieldids_"+rownum+"spanimg")[0].innerHTML="";
	   		}else{
	   			document.getElementsByName("changefieldids_"+rownum+"spanimg")[0].innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	   		}
	   		
   		}
   	}
   	dialog.URL = "/formmode/setup/FormmodeFieldBrowser.jsp?1=1"+param;
	dialog.show();
	
}

function closeColDialog(){
	dialog.close();
}
</script>
</html>
