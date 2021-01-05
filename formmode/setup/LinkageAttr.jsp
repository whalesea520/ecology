
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="modeLinkageInfo" class="weaver.formmode.setup.ModeLinkageInfo" scope="page" />
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%

int modeId = Util.getIntValue(request.getParameter("modeId"),0);
int formId = Util.getIntValue(request.getParameter("formId"),0);

%>
<body>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(28477,user.getLanguage());//属性联动
String needfav ="";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:linkageviewattrsubmit(this),_self}" ;//保存
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
String types = "1,2";
String typenames = SystemEnv.getHtmlLabelName(16388,user.getLanguage())+","+//新建模板
				   SystemEnv.getHtmlLabelName(16449,user.getLanguage());//编辑模板

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

for(int i=0;i<selectFields.size();i++){
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
}
%>
<table width=100% height=95% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
 <td ></td>
 <td valign="top">
<TABLE class=Shadow>
  <tr>
	<td valign="top">
<form name="linkageattr" id="linkageattr" method="post" action="ModeOperation.jsp" >
	<input type=hidden name="operate" value="linkageattr">
	<input type=hidden name="modeId" value="<%=modeId%>">
    <input type=hidden name="formId" value="<%=formId%>">
	<TABLE class=ListStyle cellspacing=1 id="lavaoTable"  width="100%">
	<COLGROUP>
	  <COL width="5%">
	  <COL width="15%">
	  <COL width="20%">
	  <COL width="20%">
	  <COL width="20%">
	  <COL width="20%">
	  <TBODY>
	    <TR>
	      <TD colSpan=2><b><%=SystemEnv.getHtmlLabelName(21694,user.getLanguage())%></b></TD><!-- 显示属性联动列表 -->
	      <TD colSpan=4 align="right">
		    <a style="color:#262626;cursor:pointer; TEXT-DECORATION:none" onclick='linkagevaaddrow("<%=types%>","<%=typenames%>","<%=selectfields%>","<%=selectfieldnames%>","<%=selectfieldvalues%>","<%=selectfieldvaluenames%>")'>
		     <img src="/js/swfupload/add_wev8.gif" align="absmiddle" border="0">&nbsp;<%=SystemEnv.getHtmlLabelName(21690,user.getLanguage())%><!-- 添加行 -->
		    </a>
			&nbsp;
			<a style="color:#262626;cursor:pointer;TEXT-DECORATION:none"  onclick="linkagevadelrow()">
			 <img src="/js/swfupload/delete_wev8.gif" align="absmiddle" border="0">&nbsp;<%=SystemEnv.getHtmlLabelName(16182,user.getLanguage())%><!-- 删除行 -->
			</a>
	    </TR>
	    
	    <TR class="Spacing"><TD class="Line1" colSpan=6 style="padding: 0"></TD></TR>
	    
	    <TR class=Header >
		  <TH width="5%"><input type='checkbox' class=inputstyle name='checkall' onclick="linkagevaselectall(this)"></TH>
		  <TH><%=SystemEnv.getHtmlLabelName(20622,user.getLanguage())%></TH><!-- 模板类型 -->
		  <TH><%=SystemEnv.getHtmlLabelName(21686,user.getLanguage())%></TH><!-- 选择框名称（可编辑、必填） -->
		  <TH><%=SystemEnv.getHtmlLabelName(21687,user.getLanguage())%></TH><!-- 选择框值 -->
		  <TH><%=SystemEnv.getHtmlLabelName(21688,user.getLanguage())%></TH><!-- 变更的字段（可编辑、必填） -->
		  <TH><%=SystemEnv.getHtmlLabelName(21689,user.getLanguage())%></TH><!-- 显示属性 -->
		</TR>
		<%
		String checkfield="";
	    String sql="select * from modeattrlinkage where modeid="+modeId+" order by id";
	    int i = 0;
	    rs.executeSql(sql);
	    while(rs.next()){
	    	int type = Util.getIntValue(rs.getString("type"),0);
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
	        modeLinkageInfo.setViewtype(viewtype);
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
	        fieldnames = fieldnames.substring(1);
	        Map maps = null;
	    %>
	    <TR  <%if(i%2==0){%>CLASS="datadark"<%}else{%>class="datalight" <%}%>>
	      <TD><input type='checkbox' class=inputstyle name='check_mode' value='<%=i%>'></TD>
	      <TD>
	        <select class=inputstyle name='modeid_<%=i %>'  onchange='lavachangemode(this.value,<%=i %>)'>
	          <option value="1" <%if(type==1){%>selected<%}%>>
	            <%=SystemEnv.getHtmlLabelName(16388,user.getLanguage())%><!-- 新建模板 -->
	          </option>
	          <option value="2" <%if(type==2){%>selected<%}%>>
	            <%=SystemEnv.getHtmlLabelName(16449,user.getLanguage())%><!-- 编辑模板 -->
	          </option>
<!--	          <option value="3" <%if(type==3){%>selected<%}%>>-->
<!--	            <%=SystemEnv.getHtmlLabelName(665,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%>-->
<!--	          </option>-->
	        </select>
	      </TD>
	      
	      <TD><select class=inputstyle name='selectfieldid_<%=i%>' onchange="lavachangefield(this.value,<%=i%>)">
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
	      </TD>
	      <TD><select class=inputstyle name='selectfieldvalue_<%=i%>'>
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
	      <TD>
	          <button type='button' class=Browser onclick="lavaShowMultiField('changefieldidsspan_<%=i%>','changefieldids_<%=i%>',modeid_<%=i%>.value,selectfieldid_<%=i%>.value)"></button><SPAN id="changefieldidsspan_<%=i%>"><%if(changefieldids.equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}else{%><%=fieldnames%><%}%></SPAN>
	          <input type='hidden' class=inputstyle name='changefieldids_<%=i%>' id='changefieldids_<%=i%>' value="<%=changefieldids%>">
	      </TD>
	      <TD>
	      <select class=inputstyle name='viewattr_<%=i%>' onchange="">
	        <option value="2" <%if(viewattr.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%></option><!-- 必填 -->
	        <option value="1" <%if(viewattr.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option><!-- 编辑 -->
	        <option value="3" <%if(viewattr.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17873,user.getLanguage())%></option><!-- 只读 -->
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
	</td>
  </tr>
</TABLE>
 </td>
 <td></td>
</tr>
</table>

</body>
<script type="text/javascript">

$(document).ready(function(){//onload事件
	$(".loading", window.parent.document).hide(); //隐藏加载图片
})
function linkagevaselectall(obj){
	var checkboxs = document.getElementsByName("check_mode");
	for(var i=0;i<checkboxs.length;i++){
		checkboxs[i].checked=obj.checked;
	}
}
function linkageviewattrsubmit(obj){
	if (check_form(linkageattr,linkageattr.checkfield.value)){
		linkageattr.submit();
        obj.disabled=true;
    }
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
    changefieldidspan=document.getElementById("changefieldidsspan_"+rownum);
    clearOptionsCodeSeqSet(fieldvaluesel);
    var ajax=ajaxinit();
    ajax.open("POST", "FieldSelectAjax.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("option=selfieldvalue&fieldId="+fieldid);
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
            changefieldids.value="";
            changefieldidspan.innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
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
		oCell.style.height = 24;
		oCell.style.background= "#E7E7E7";
		switch(j) {
            case 0:
            {
                var oDiv = document.createElement("div");
                var sHtml = "<input type='checkbox' class=inputstyle name='check_mode' value='"+rowindex+"'>";
                oDiv.innerHTML = sHtml;
                oCell.appendChild(oDiv);
                break;
            }
            case 1:
            {
                var oDiv = document.createElement("div");
                var sHtml = "<select class=inputstyle name='modeid_"+rowindex+"' id='modeid_"+rowindex+"'  onchange='lavachangemode(this.value,"+rowindex+")'>"
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
                var sHtml = "<button type='button' class=Browser onclick='lavaShowMultiField(\"changefieldidsspan_"+rowindex+"\",\"changefieldids_"+
                            rowindex+"\",modeid_"+rowindex+".value,selectfieldid_"+rowindex+".value)'></button><SPAN id='changefieldidsspan_"+rowindex+
                            "'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN><input type='hidden' class=inputstyle name='changefieldids_"+rowindex+"' id='changefieldids_"+rowindex+"'>";
                oDiv.innerHTML = sHtml;
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
        alert("<%=SystemEnv.getHtmlLabelName(15543, user.getLanguage())%>");//请先选择需要删除的信息
    }else{
	    if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){//确定要删除吗?
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
	                    oTable.deleteRow(rowsum1+2);
	                    curindex--;
	                }
	                rowsum1 -=1;
	            }
	        }
	        $G("linkage_rownum").value=curindex;
	    }
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
</script>
</html>