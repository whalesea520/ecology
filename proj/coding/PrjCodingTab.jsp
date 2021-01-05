
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page import="java.util.*" %>
<%@ page import="weaver.system.code.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
    String nameQuery = Util.null2String(request.getParameter("nameQuery"));
    String typedesc = Util.null2String(request.getParameter("typedesc"));
%>
<HTML><HEAD>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
<LINK href="/proj/css/common_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
if(!HrmUserVarify.checkUserRight("ProjCode:Maintenance", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name="frmSearch" method="post"  >
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("86",user.getLanguage())%>" class="e8_btn_top"  onclick="onSave(this)"/>
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>		
		<!-- bpf start 2013-10-29 -->
		<div class="advancedSearchDiv" id="advancedSearchDiv" >
		</div>
</form>		



<%

  CodeBuild cbuild = new CodeBuild(1);  
  CoderBean cbean = cbuild.getCBuild();
  ArrayList coderMemberList = cbean.getMemberList();
  
  String sql = "select * from Prj_Code";
	rs.executeSql(sql);
	while(rs.next()){
		int codeid = rs.getInt("id");
		cbean.setCodeid(codeid);
		cbean.setIsuse(rs.getInt("isuse"));
		cbean.setSubcompanyflow(rs.getString("subcompanyflow"));
		cbean.setDepartmentflow(rs.getString("departmentflow"));
		cbean.setCapitalgroupflow(rs.getString("capitalgroupflow"));
		cbean.setCapitaltypeflow(rs.getString("capitaltypeflow"));
		cbean.setBuydateflow(rs.getString("buydateflow"));
		cbean.setWarehousingflow(rs.getString("Warehousingflow"));
		cbean.setStartcodenum(rs.getString("startcodenum"));
		cbean.setAssetdataflow(rs.getString("assetdataflow"));
	}
  
  String isUse =  cbean.getIsuse() + "";
  String codeid = cbean.getCodeid() + "";
  String subcompanyflow =  cbean.getSubcompanyflow();
  String departmentflow =  cbean.getDepartmentflow();
  String capitalgroupflow =  cbean.getCapitalgroupflow();//项目类型单独流水
  String capitaltypeflow =  cbean.getCapitaltypeflow();//工作类型单独流水
  String buydateflow =  cbean.getBuydateflow();//日期单独流水
  String Warehousingflow =  cbean.getWarehousingflow();
  String statrcodenum = cbean.getStartcodenum();
  String assetdataflow = cbean.getAssetdataflow();
  
  String buydate = "";
  String buydateselect = "";
  String Warehousing = "";
  String Warehousingselect = "";
  try{
  	buydate = Util.TokenizerString2(buydateflow,"|")[0];
  	buydateselect = Util.TokenizerString2(buydateflow,"|")[1];
  }catch(Exception e){
    new weaver.general.BaseBean().writeLog("buydateflow：" + e);
  }
  
  
  boolean ifUse="1".equals(isUse);
  

%>
<form id="frmCoder" name="frmCoder" method=post action="coderOperation.jsp" >
<input type=hidden name=codeid value="<%=codeid%>">
<input type=hidden name=postValue value="">
<!-- listinfo -->
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("83545",user.getLanguage())%>' attributes="{'groupDisplay':''}" >
		<wea:item><%=SystemEnv.getHtmlLabelNames("83545",user.getLanguage())%></wea:item>
		<wea:item>
			<select	name="isuse" onchange="onChangeSharetype(this)" style="width:150px!important;" >
				<option value="1" <%="1".equals(isUse)?"selected":"" %> ><%=SystemEnv.getHtmlLabelNames("83546",user.getLanguage())%></option>
				<option value="2" <%="2".equals(isUse)?"selected":"" %> ><%=SystemEnv.getHtmlLabelNames("83547",user.getLanguage())%></option>
				<option value="0" <%="0".equals(isUse)?"selected":"" %> ><%=SystemEnv.getHtmlLabelNames("83552",user.getLanguage())%></option>
			</select>
		</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("83549",user.getLanguage())%>' attributes="{'samePair':'codedetail_g','itemAreaDisplay':'true'}" >
		<wea:item attributes="{'isTableList':'true','colspan':'full'}">
		<TABLE class=ViewForm id="membersTable">
    	  <colgroup>
    	  	<col width="20%">
    	  	<col width="80%">
    	  </colgroup>
          <TBODY>
		<%
		for (int i=0;i<coderMemberList.size();i++){
            String[] codeMembers = (String[])coderMemberList.get(i);
            String codeMemberName = codeMembers[0];
            String codeMemberValue = codeMembers[1];
            String codeMemberType = codeMembers[2];
            if("18809".equals(codeMemberName)){//客户编码去除
            	continue;
            }
            %>
            

    	  
            
            <TR id="TR_<%=i%>" customer1="member" onmouseover="$(this).find('img[moveimg]').attr('src','/proj/img/move-hot_wev8.png');" onmouseout="$(this).find('img[moveimg]').attr('src','/proj/img/move_wev8.png');">
              <TD codevalue="<%=codeMemberName%>" class="fieldName">
            <img moveimg src="/proj/img/move_wev8.png"  title="<%=SystemEnv.getHtmlLabelNames("82783",user.getLanguage())%>" />
            <%--	<a href="javaScript:imgUpOnclick(<%=i%>)">
                    <img id="img_up_<%=i%>" <%if (i==0) {%>style="visibility:hidden;width=0"  <%}%> name="img_up" src='/images/ArrowUpGreen_wev8.gif' title='<%=SystemEnv.getHtmlLabelName(15084,user.getLanguage())%>' border=0></a> 
                    &nbsp;
                    <a href="javaScript:imgDownOnclick(<%=i%>)">
                    <%%><img id="img_down_<%=i%>"  <%if (i==coderMemberList.size()-1) {%>style="visibility:hidden;width=0" <%}%> name ="img_down" src='/images/ArrowDownRed_wev8.gif' title='<%=SystemEnv.getHtmlLabelName(15085,user.getLanguage())%>' border=0></a>  --%>            
                    &nbsp;
                   <%=SystemEnv.getHtmlLabelName(Util.getIntValue(codeMemberName),user.getLanguage()) %>
                </TD>
              <TD class="field">
            	<%
                  if ("1".equals(codeMemberType)){  //1:checkbox
                    if ("1".equals(codeMemberValue)){
                       out.println("<input id=chk_"+i+" type=checkbox class=InputStyle tzCheckbox=\"true\" checked value=1  onclick=proView()>");
                    } else {
                         out.println("<input id=chk_"+i+" type=checkbox class=InputStyle tzCheckbox=\"true\"  value=1  onclick=proView()>");
                    }
                  } else if ("2".equals(codeMemberType)){   //2:input
                       %>
                       <input type=text name="inputt<%=i%>" <%if (codeMemberName.equals("18811")) {%> style="width:50px!important" onchange='checkint("inputt<%=i%>");proView();'<%} else {%>onchange=proView()<%}%> class=InputStyle   value="<%=codeMemberValue%>" maxLength='50'>
                       <%  
                  } else if ("3".equals(codeMemberType)){  //3:year  1|1 表示需用，并且年为四年制 1|0表示 需用  年为两年制 0|1 表示不需用，并且年为四年制 0|0表示 不需用 年为两年制
                      if ("1|1".equals(codeMemberValue)){
                          out.println("<input type=checkbox id=chk_"+i+" class=InputStyle tzCheckbox=\"true\" checked value=1 onclick=onYearChkClick(this,"+i+")>");
                          out.println("&nbsp;&nbsp;<select id=select_"+i+" name=select_"+i+" onchange=proView()><option value=0>2-"+SystemEnv.getHtmlLabelName(15933,user.getLanguage())+"</option><option value=1 selected>4-"+SystemEnv.getHtmlLabelName(15933,user.getLanguage())+"</option></select>");
                       } else if ("1|0".equals(codeMemberValue)){
                          out.println("<input type=checkbox id=chk_"+i+" class=InputStyle tzCheckbox=\"true\" checked value=1 onclick=onYearChkClick(this,"+i+")>");
                          out.println("&nbsp;&nbsp;<select id=select_"+i+" name=select_"+i+" onchange=proView()><option value=0 selected>2-"+SystemEnv.getHtmlLabelName(15933,user.getLanguage())+"</option><option value=1 >4-"+SystemEnv.getHtmlLabelName(15933,user.getLanguage())+"</option></select>");
                       } else if  ("0|1".equals(codeMemberValue)){
                          out.println("<input type=checkbox id=chk_"+i+" class=InputStyle tzCheckbox=\"true\" value=1 onclick=onYearChkClick(this,"+i+")>");
                          out.println("&nbsp;&nbsp;<select id=select_"+i+" name=select_"+i+" disabled onchange=proView()><option value=0>2-"+SystemEnv.getHtmlLabelName(15933,user.getLanguage())+"</option><option value=1 selected>4-"+SystemEnv.getHtmlLabelName(15933,user.getLanguage())+"</option></select>");
                       }  else  if ("0|0".equals(codeMemberValue)){
                          out.println("<input type=checkbox id=chk_"+i+" class=InputStyle tzCheckbox=\"true\" value=1 onclick=onYearChkClick(this,"+i+")>");
                          out.println("&nbsp;&nbsp;<select id=select_"+i+" name=select_"+i+" disabled onchange=proView()><option value=0 selected>2-"+SystemEnv.getHtmlLabelName(15933,user.getLanguage())+"</option><option value=1 >4-"+SystemEnv.getHtmlLabelName(15933,user.getLanguage())+"</option></select>");
                       } 
                  }
                 %>
                </TD>                   
               </TR>  
             <tr style="height:1px!important;display:;" class="Spacing"><td class="paddingLeft18" colspan="2"><div class="intervalDivClass"></div></td></tr>
             
            <%
            
        }
		
		%>
		</TBODY></TABLE>
		</wea:item>
	</wea:group>
	
	
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("83550",user.getLanguage())%>' attributes="{'samePair':'codedetail_g','itemAreaDisplay':'true'}" >
		
		
		
		<wea:item><%=SystemEnv.getHtmlLabelNames("101,22133",user.getLanguage())%></wea:item>
		<wea:item>
			<input class="InputStyle" type="checkbox" tzCheckbox="true" name="capitalgroupflow" value="1" <%if ("1".equals(capitalgroupflow)) out.println("checked");%> >
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("380,22133",user.getLanguage())%></wea:item>
		<wea:item>
			<input class="InputStyle" type="checkbox" tzCheckbox="true" name="capitaltypeflow" value="1" <%if ("1".equals(capitaltypeflow)) out.println("checked");%> >
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(19418,user.getLanguage())%></wea:item>
		<wea:item>
			<input class="InputStyle" type="checkbox" tzCheckbox="true"  name="buydate" value="1" <%if ("1".equals(buydate)) out.println("checked");%> >
			<input class="InputStyle" style="width:50px!important" type="radio"  name="buydateselect" value="1" <%if ("1".equals(buydateselect)||"".equals(buydateselect)) out.println("checked");%> ><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>
			<input class="InputStyle" style="width:50px!important" type="radio"  name="buydateselect" value="2" <%if ("2".equals(buydateselect)) out.println("checked");%> ><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>
			<input class="InputStyle" style="width:50px!important" type="radio"  name="buydateselect" value="3" <%if ("3".equals(buydateselect)) out.println("checked");%> ><%=SystemEnv.getHtmlLabelName(390,user.getLanguage())%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(103,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(20578,user.getLanguage())%></wea:item>
		<wea:item>
			<input class="InputStyle" type="checkbox" tzCheckbox="true"  name="changecode" value="1" onclick="onchangecode(this)">
		</wea:item>
		<wea:item attributes="{'samePair':'startcodenum_td','display':'none'}"><%=SystemEnv.getHtmlLabelName(20578,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'startcodenum_td','display':'none'}">
			<input class="InputStyle" style="width:50px!important" type="text" name="startcodenum" value="<%=statrcodenum%>" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("startcodenum")' >
		</wea:item>
	</wea:group>
	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>' attributes="{'samePair':'codedetail_g','itemAreaDisplay':'true'}" >
		<wea:item>
			<table border="1" cellspacing="0" cellpadding="0" >
               <tr id="TR_pro" ></tr>
               
             </table>
		</wea:item>
	</wea:group>
	
</wea:layout>

</form>

<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">
function onSave(obj){
	
	  var TR_members= document.getElementById("membersTable").getElementsByTagName("TR");
	  var postValueStr="";
	  for (var index=0;index< TR_members.length;index++ ){     
	    var TR_member = TR_members[index];
	    
	    if (jQuery(TR_member).attr("customer1")!="member") continue;
	    var codeTitle = jQuery(jQuery(TR_member).children()[0]).attr("codevalue").replace(/(^\s+|\s+$)/g,"");
	    var codeTypeTag = jQuery(jQuery(TR_member).children()[1]).children()[0].tagName;   //checkbox input div
	    var codeValue;
	    var codeType;
	    if (codeTypeTag=="INPUT") {
	      codeValue= jQuery(jQuery(TR_member).children()[1]).children()[0].value; 
	      if (jQuery(jQuery(TR_member).children()[1]).children()[0].type=="text") {
	         codeValue = jQuery(jQuery(TR_member).children()[1]).children()[0].value;
	         if (codeValue=="") codeValue="[(*_*)]";
	         codeType = 2
	      } else if (jQuery(jQuery(TR_member).children()[1]).children()[0].type=="checkbox"){
	         codeValue = jQuery(jQuery(TR_member).children()[1]).children()[0].checked==true?"1":"0";
	         codeType=1      //input

	         var selectObjs=jQuery(TR_member).children()[1].getElementsByTagName("SELECT");                 
	         if (selectObjs.length>=1)  {
	           codeType=3   //year
	           codeValue=codeValue+"|"+selectObjs[0].value;
	         }
	      }
	    }
	    postValueStr += codeTitle+"\u001b"+codeValue+"\u001b"+ codeType+"\u0007";
	 }
	 postValueStr = postValueStr.substring(0,postValueStr.length-1);
	 document.frmCoder.postValue.value=postValueStr;
	 document.frmCoder.method.value="update";
	
	var forminfo=jQuery("#frmCoder").serialize();
	
	jQuery.post(
		"/proj/coding/coderOperation.jsp",
		forminfo,
		function(data){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83551",user.getLanguage())%>",function(){
			});
		}
	);
}



function onBtnSearchClick(){
	var typename=$("input[name='flowTitle']",parent.document).val();
	$("input[name='typename']").val(typename);
	frmSearch.submit();
}

function onchangecode(obj){
	if(obj.checked==true){
		showEle('startcodenum_td');		
	}else{
		hideEle('startcodenum_td');	
	}
}

</script>

<SCRIPT LANGUAGE="JavaScript">
<!--
var colors= new Array ("#6633CC","#FF33CC","#666633","#CC00FF","#996666")  ;

function load(){  //检查Imag的状态
  var img_ups = document.getElementsByName("img_up");
  for (var index_up=0;index_up<img_ups.length;index_up++)  {
    var img_up = img_ups[index_up];
    if (index_up==0)  img_up.style.visibility ='hidden';
    else  img_up.style.visibility ='visible';
  }

  var img_downs = document.getElementsByName("img_down");
  for (var index_down=0;index_down<img_downs.length;index_down++)  {
    var img_down = img_downs[index_down];
    if (index_down==img_downs.length-1)  img_down.style.visibility ='hidden';
    else  img_down.style.visibility ='visible';
  }

  proView();
}

function proView(){
    var TR_pro = document.getElementById("TR_pro");
    var TR_proChilds = TR_pro.childNodes;    
    for (var i=TR_proChilds.length-1;i>=0;i--) jQuery(TR_proChilds[i]).remove();


    var TR_members= jQuery("TR[customer1=member]");
    for (var index=0;index< TR_members.length;index++ ){      
      var TR_member = TR_members[index];
      if ($(TR_member).attr("customer1")!="member") continue;

	  var codeTitle = $.trim(jQuery(jQuery(TR_member).children()[0]).text());
      var codeTypeTag = jQuery(jQuery(TR_member).children()[1]).children()[0].tagName;   //checkbox input div    
      var codeValue;

      if (codeTypeTag=="INPUT") {
        codeValue= jQuery(jQuery(TR_member).children()[1]).children()[0].value; 

        if (jQuery(jQuery(TR_member).children()[1]).children()[0].type=="text") {
           codeValue = jQuery(jQuery(TR_member).children()[1]).children()[0].value;
        } else if (jQuery(jQuery(TR_member).children()[1]).children()[0].type=="checkbox"){
           codeValue = jQuery(jQuery(TR_member).children()[1]).children()[0].checked==true?"1":"0";
        }
      }
      else if (codeTypeTag=="DIV") codeValue = jQuery(jQuery(TR_member).children()[1]).children()[0].innerText;
       

        if (codeTypeTag=="INPUT"||codeTypeTag=="DIV"&&codeValue!="<%=SystemEnv.getHtmlLabelNames("82185",user.getLanguage())%>")  { 
            if (codeTypeTag=="INPUT") {
                if (jQuery(jQuery(TR_member).children()[1]).children()[0].type=="checkbox"&&codeValue=="0") continue;
                if (jQuery(jQuery(TR_member).children()[1]).children()[0].type=="checkbox"&&codeValue=="1"){
                 var selectObjs=jQuery(TR_member).children()[1].getElementsByTagName("SELECT");                 
                  if (selectObjs.length>=1)  {
                    if(selectObjs[0].value=="0") codeValue="**";
                    else codeValue="****";
                  }
                }
            }

        var tempTd = document.createElement("TD");
        tempTd.setAttribute("nowrap","");
        var tempTable = document.createElement("TABLE");
        var newRow = tempTable.insertRow(-1);
        var newRowMiddle = tempTable.insertRow(-1);
        var newRow1 = tempTable.insertRow(-1);


        var newCol = newRow.insertCell(-1);
        var newColMiddle=newRowMiddle.insertCell(-1);
        var newCol1 = newRow1.insertCell(-1);

        newColMiddle.className="Line";
        jQuery(newColMiddle).parents("tr")[0].style.height="1px";

        
        if(codeTitle=="<%=SystemEnv.getHtmlLabelNames("18811",user.getLanguage())%>") codeTitle="<%=SystemEnv.getHtmlLabelNames("16318",user.getLanguage())%>";
        newCol.innerHTML="<font color="+colors[index%5]+">"+codeTitle+"</font>";

        if (codeValue=="1") {
          codeValue="****";
        } else if (codeValue=="0") {
          codeValue="**";
        }
        
        if(codeTitle=="<%=SystemEnv.getHtmlLabelNames("16318",user.getLanguage())%>"&&codeValue=="****"){
        	codeValue="1";
        }else if(codeTitle=="<%=SystemEnv.getHtmlLabelNames("16318",user.getLanguage())%>"&&codeValue>0){
        	codeValue=pad(1,codeValue);
        }
        newCol1.innerHTML="<font color="+colors[index%5]+">"+codeValue+"</font>";
        tempTd.appendChild(tempTable);
        TR_pro.appendChild(tempTd);         
      }
    }
    
}
function pad(num, n) {  
	  return Array(n>num?(n-(''+num).length+1):0).join(0)+num;  
}
 
function onYearChkClick(obj,index){  
    document.getElementById("select_"+index).disabled=!obj.checked;
    proView();
}

function imgUpOnclick(index){
return;	
  var checkbox1Stats = 0;
  var checkbox2Stats = 0;
  var obj1 = document.getElementById("TR_"+index);

  var checkbox1 =jQuery(jQuery(obj1).children()[1]).children()[0];
  if (checkbox1.type=="checkbox") checkbox1Stats = checkbox1.checked;
  var obj2 = jQuery(obj1).prev().prev()[0];
  var checkbox2 =jQuery(jQuery(obj2).children()[1]).children()[0];
  if (checkbox2.type=="checkbox") checkbox2Stats = checkbox2.checked;

  swapNode(obj1, obj2);
  if (checkbox1Stats!=0) {
    checkbox1.checked=checkbox1Stats;
  }

   if (checkbox2Stats!=0) {
    checkbox2Stats.checked=checkbox2Stats;
  }
  load();
}

function imgDownOnclick(index){
return;
  var checkbox1Stats = 0;
  var checkbox2Stats = 0;
  var obj1 = document.getElementById("TR_"+index);

  var checkbox1 =jQuery(jQuery(obj1).children()[1]).children()[0];
  if (checkbox1.type=="checkbox") checkbox1Stats = checkbox1.checked;

  var obj2 = jQuery(obj1).next().next()[0];
  var checkbox2 =jQuery(jQuery(obj2).children()[1]).children()[0];
  if (checkbox2.type=="checkbox") checkbox2Stats = checkbox2.checked;

 
  swapNode(obj1, obj2);
  if (checkbox1Stats!=0) {
    checkbox1.checked=checkbox1Stats;
  }

   if (checkbox2Stats!=0) {
    checkbox2Stats.checked=checkbox2Stats;
  }
  load();
 
}

proView();

function swapNode(node, node2) {
	jQuery(node2).replaceWith(jQuery("<div></div>").append(jQuery(node).clone()).html());
	jQuery(node).replaceWith(jQuery("<div></div>").append(jQuery(node2).clone()).html());
}

function onChangeSharetype(obj){
	var thisvalue = jQuery(obj).val();
	if(thisvalue==1){
		showGroup('codedetail_g');
	}else{
		hideGroup('codedetail_g');
	}
}
jQuery(function(){
	var ifUse='<%=ifUse %>';
	if(ifUse!='true'){
		hideGroup('codedetail_g');
	}
	registerDragEvent();
});

function registerDragEvent(){
	 var fixHelper = function(e, ui) {
      ui.children().each(function() { 
          $(this).width($(this).width());     //在拖动时，拖动行的cell（单元格）宽度会发生改变。在这里做了处理就没问题了
          $(this).height($(this).height());  
      });  
      return ui;  
  };
  
  var copyTR = null;
	var startIdx = 0;
  
  jQuery("#membersTable tbody tr").bind("mousedown",function(e){
		copyTR = jQuery(this).next("tr.Spacing");
	});
  
   jQuery("#membersTable tbody").sortable({                //这里是talbe tbody，绑定 了sortable  
       helper: fixHelper,                  //调用fixHelper  
       axis:"y",  
       start:function(e, ui){
           ui.helper.addClass("e8_hover_tr")     //拖动时的行，要用ui.helper  
           if(ui.item.hasClass("notMove")){
           	e.stopPropagation();
           }
           if(copyTR){
      		copyTR.hide();
      	}
      	startIdx = ui.item.get(0).rowIndex;
           return ui;  
       },  
       stop:function(e, ui){
           ui.item.removeClass("e8_hover_tr"); //释放鼠标时，要用ui.item才是释放的行  
          if(copyTR){
      	  if(ui.item.get(0).rowIndex>startIdx){
       	  	ui.item.before(copyTR.clone().show());
       	  }else{
       	  	ui.item.after(copyTR.clone().show());
       	  }
      	  copyTR.remove();
      	  copyTR = null;
      	}
          
		load();
          return ui;  
       }  
   });  
}
jQuery.fn.swap = function(other) {
   $(this).replaceWith($(other).after($(this).clone(true)));
};

//-->
</SCRIPT>
</BODY>
</HTML>
