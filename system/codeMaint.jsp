
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.system.code.*"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="ProjCodeParaBean" class="weaver.proj.form.ProjCodeParaBean" scope="page"/>

<%

	int codeId = Util.getIntValue( Util.null2String(request.getParameter("codemainid")));
%>
<%
	//初始值
  CodeBuild cbuild = new CodeBuild(codeId); 
	CoderBean cbean = cbuild.getCBuild();

  ArrayList coderMemberList = cbean.getMemberList();
	String titleImg = cbean.getImage();
	String titleName = cbean.getTitleName();
  String isUse =  cbean.getUserUse();
  String allowStr = cbean.getAllowStr();
%>
<html>
	<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	</HEAD>	
<%
  boolean canEdit = false ;
  if (HrmUserVarify.checkUserRight(allowStr,user)) {
        canEdit = true ;   
  }


	//标题
	String imagefilename =titleImg;
	String titlename =SystemEnv.getHtmlLabelName(Util.getIntValue(titleName),user.getLanguage());
	String needfav ="1";
	String needhelp =""; 
%>
	<body onload="load()">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
  //菜单
  if (canEdit){
	  RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_top} " ;
	  RCMenuHeight += RCMenuHeightStep ;
  }
  RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_top} " ;
  RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	  <FORM METHOD="POST" name="frmCoder" ACTION="coderOperation.jsp">
    <INPUT TYPE="hidden" NAME="method">
    <INPUT TYPE="hidden" NAME="postValue">
    <INPUT TYPE="hidden" NAME="codemainid" value="<%=codeId%>">

	  <table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
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
          <TABLE class=ViewForm>
          <COLGROUP>
          <COL width="30%">
          <COL width="70%">         
          <TBODY>
             <TR class="Title"><TH><%=SystemEnv.getHtmlLabelName(Util.getIntValue(titleName),user.getLanguage()) %></TH><TD></TD></TR>
             <TR style="height: 1px"><TD class=Line1 colSpan=2></TD></TR>
             <%for (int i=0;i<coderMemberList.size();i++){
                 String[] codeMembers = (String[])coderMemberList.get(i);
                 String codeMemberName = codeMembers[0];
                 String codeMemberValue = codeMembers[1];
                 String codeMemberType = codeMembers[2];       
             %>
                <TR id="TR_<%=i%>" customer1="member">
                    <TD codevalue="<%=codeMemberName%>">
                     
                     <%if (canEdit){%>
                       <a href="javaScript:imgUpOnclick(<%=i%>)"><img id="img_up_<%=i%>" name="img_up" src='/images/ArrowUpGreen_wev8.gif' title='<%=SystemEnv.getHtmlLabelName(15084,user.getLanguage())%>' border=0></a>
                       &nbsp;
                       <a href="javaScript:imgDownOnclick(<%=i%>)"><img id="img_down_<%=i%>"  name ="img_down" src='/images/ArrowDownRed_wev8.gif' title='<%=SystemEnv.getHtmlLabelName(15085,user.getLanguage())%>' border=0></a>              
                       &nbsp;
                       <%}%>
                      <%=SystemEnv.getHtmlLabelName(Util.getIntValue(codeMemberName),user.getLanguage()) %>
                    </TD>
                    <TD class="Field">
                      <%
                         if ("1".equals(codeMemberType)){   //1:checkbox
                           if ("1".equals(codeMemberValue)){
                             if (canEdit){
                              out.println("<input id=chk_"+i+" type=checkbox class=inputstyle checked value=1  onclick=proView()>");
                             } else {
                              out.println("<div>"+SystemEnv.getHtmlLabelName(160,user.getLanguage())+"</div>");
                             }
                           } else {
                              if (canEdit){
                                out.println("<input id=chk_"+i+" type=checkbox class=inputstyle  value=1  onclick=proView()>");
                               } else {
                                out.println("<div>"+SystemEnv.getHtmlLabelName(165,user.getLanguage())+"</div>");
                               }                              
                           }
                         } else if ("2".equals(codeMemberType)){   //2:input
                              if (canEdit){
                                 out.println("<input type=text class=inputstyle onchange=proView() maxlength='20'  value="+codeMemberValue+">");
                               } else {
                                  out.println("<div>"+codeMemberValue+"</div>");
                               } 
                             
                         } else if ("3".equals(codeMemberType)){  //3:year  1|1 表示需用，并且年为四年制 1|0表示 需用  年为两年制 0|1 表示不需用，并且年为四年制 0|0表示 不需用 年为两年制
                             if ("1|1".equals(codeMemberValue)){
                               if (canEdit){
                                out.println("<input type=checkbox id=chk_"+i+" class=inputstyle checked value=1 onclick=onYearChkClick(this,"+i+")>");
                                out.println("&nbsp;&nbsp;<select id=select_"+i+" name=select_"+i+" onchange=proView()><option value=0>2-"+SystemEnv.getHtmlLabelName(15933,user.getLanguage())+"</option><option value=1 selected>4-"+SystemEnv.getHtmlLabelName(15933,user.getLanguage())+"</option></select>");
                               } else {
                                out.println("<div>4-"+SystemEnv.getHtmlLabelName(15933,user.getLanguage())+"</div>");
                               }  
                               
                             } else if ("1|0".equals(codeMemberValue)){
                                if (canEdit){
                                out.println("<input type=checkbox id=chk_"+i+" class=inputstyle checked value=1 onclick=onYearChkClick(this,"+i+")>");
                                out.println("&nbsp;&nbsp;<select id=select_"+i+" name=select_"+i+" onchange=proView()><option value=0 selected>2-"+SystemEnv.getHtmlLabelName(15933,user.getLanguage())+"</option><option value=1 >4-"+SystemEnv.getHtmlLabelName(15933,user.getLanguage())+"</option></select>");
                               } else {
                                out.println("<div>2-"+SystemEnv.getHtmlLabelName(15933,user.getLanguage())+"</div>");
                               }
                             } else if  ("0|1".equals(codeMemberValue)){
                                if (canEdit){
                                out.println("<input type=checkbox id=chk_"+i+" class=inputstyle  value=1 onclick=onYearChkClick(this,"+i+")>");
                                out.println("&nbsp;&nbsp;<select id=select_"+i+" name=select_"+i+" disabled onchange=proView()><option value=0>2-"+SystemEnv.getHtmlLabelName(15933,user.getLanguage())+"</option><option value=1 selected>4-"+SystemEnv.getHtmlLabelName(15933,user.getLanguage())+"</option></select>");
                               } else {
                                out.println("<div>"+SystemEnv.getHtmlLabelName(165,user.getLanguage())+"</div>");
                               }
                             }  else  if ("0|0".equals(codeMemberValue)){
                               if (canEdit){
                                out.println("<input type=checkbox id=chk_"+i+" class=inputstyle  value=1 onclick=onYearChkClick(this,"+i+")>");
                                out.println("&nbsp;&nbsp;<select id=select_"+i+" name=select_"+i+" disabled onchange=proView()><option value=0 selected>2-"+SystemEnv.getHtmlLabelName(15933,user.getLanguage())+"</option><option value=1 >4-"+SystemEnv.getHtmlLabelName(15933,user.getLanguage())+"</option></select>");
                               } else {
                                out.println("<div>"+SystemEnv.getHtmlLabelName(165,user.getLanguage())+"</div>");
                               }
                             } 
                         }       
                    %>
                    </TD>                   
                </TR>  
                <tr  style="height: 1px"><td class=Line colspan=2></TD></TR>
              <%}%>
               <TR>
                    <TD><%=SystemEnv.getHtmlLabelName(18624,user.getLanguage())%></TD>
                    <TD  class="Field"> <input class="inputStyle" type="checkbox" name="txtUserUse" value="1" <%if ("1".equals(isUse)) out.println("checked");%>>
                    </TD>
                 </TR>
                  <tr  style="height: 1px"><td class=Line colspan=2></TD></TR>
                 <TR>
                    <TD><%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%></TD>
                    <TD> 
                      <table border="1" cellspacing="0" cellpadding="0">
                        <tr id="TR_pro"></tr>
                      </table>
                    </TD>
                 </TR>
                 <tr  style="height: 1px"><td class=Line colspan=2></TD></TR>
          </TBODY>
        </td>
        </tr>
        </TABLE>
	  </FORM>    
      </td>
      <td></td>
    </tr>
    <tr>
      <td height="10" colspan="3"></td>
    </tr>   
    </table>    
	</body>
</html>
<SCRIPT LANGUAGE="JavaScript">
<!--

jQuery.fn.swap = function(other) {
    $(this).replaceWith($(other).after($(this).clone(true)));
};


var colors= new Array ("#6633CC","#FF33CC","#666633","#CC00FF","#996666")  ;

function load(){  //检查Imag的状态
  var img_ups = document.getElementsByName("img_up");
  for (var index_up=0;index_up<img_ups.length;index_up++)  {
    var img_up = img_ups[index_up];
    if (index_up==0)  {
    	img_up.style.visibility ='hidden';
    	img_up.parentNode.style.visibility ='hidden';
    }
    else  {
    	img_up.style.visibility ='visible';
    	img_up.parentNode.style.visibility ='visible';
    }
  }

  var img_downs = document.getElementsByName("img_down");
  for (var index_down=0;index_down<img_downs.length;index_down++)  {
    var img_down = img_downs[index_down];
    if (index_down==img_downs.length-1)  {
   	 	img_down.style.visibility ='hidden';
   	 	img_down.parentNode.style.visibility ='hidden';
    }
    else  {
    	img_down.style.visibility ='visible';
    	img_down.parentNode.style.visibility ='visible';
    }
  }

  proView();
}



function proView(){
  
    var TR_pro =  jQuery("#TR_pro");
    jQuery(TR_pro).children("td").remove();
    jQuery("tr[customer1='member']").each(function(index,obj){
		
		  var codeTitle = $(obj).find("td::eq(0)").text()
		  codeTitle = jQuery.trim(codeTitle)
		  var codeTypeTag = $(obj).find("td::eq(1)").children(":first").attr("tagName")
		  
		  var codeValue;

	      if (codeTypeTag=="INPUT") {
	        codeValue= $(obj).find("td::eq(1)").children(":first").val(); 

	        if ($(obj).find("td::eq(1)").children(":first").attr("type")=="text") {
	           codeValue = $(obj).find("td::eq(1)").children(":first").val();
	        } else if ($(obj).find("td::eq(1)").children(":first").attr("type")=="checkbox"){
	           codeValue = $(obj).find("td::eq(1)").children(":first").attr("checked")==true?"1":"0";
	        }
	      }
	      else if (codeTypeTag=="DIV") codeValue = $(obj).find("td::eq(1)").children(":first").text();
	      
	      if (codeTypeTag=="INPUT"||codeTypeTag=="DIV"&&codeValue!="不使用")  { 
	            if (codeTypeTag=="INPUT") {
	                if ($(obj).find("td::eq(1)").children(":first").attr("type")=="checkbox"&&codeValue=="0"){ 
	                	return true;
	                }else if ($(obj).find("td::eq(1)").children(":first").attr("type")=="checkbox"&&codeValue=="1"){
	                	 var selectObjs=$(obj).find("select");                 
	                     if (selectObjs.length>=1)  {
	                       if(selectObjs[0].value=="0") codeValue="**";
	                       else codeValue="****";
	                     }
	                }
	            }

	        var tempTd = document.createElement("TD");
	        var tempTable = document.createElement("TABLE");
	        var newRow = tempTable.insertRow(-1);
	        var newRowMiddle = tempTable.insertRow(-1);
	        var newRow1 = tempTable.insertRow(-1);


	        var newCol = newRow.insertCell(-1);
	        var newColMiddle=newRowMiddle.insertCell(-1);
	        var newCol1 = newRow1.insertCell(-1);

	        jQuery(newRowMiddle).css("height","1px");
	        newColMiddle.className="Line";

	        newCol.innerHTML="<font color="+colors[index%5]+">"+codeTitle+"</font>";

	        if (codeValue=="1") {
	          codeValue="****";
	        } else if (codeValue=="0") {
	          codeValue="**";
	        }
	        newCol1.innerHTML="<font color="+colors[index%5]+">"+codeValue+"</font>";
	        jQuery(tempTd).append(tempTable);
	        //tempTd.appendChild(tempTable);
	        jQuery(TR_pro).append(tempTd)
	        //TR_doc.appendChild(tempTd);
	      } 
  	})
  
   
}

function onSave(obj){
 // obj.disabled=true;
 
  var postValueStr="";
 
  jQuery("tr[customer1='member']").each(function(index,obj){
	  var codeTitle = $(obj).find("td::eq(0)").attr("codevalue");
	  codeTitle = jQuery.trim(codeTitle)
	  var codeTypeTag = $(obj).find("td::eq(1)").children(":first").attr("tagName")
	  var codeValue;
	  var codeType;

	    if (codeTypeTag=="INPUT") {
	      codeValue= $(obj).find("td::eq(1)").children(":first").val();
	      if ( $(obj).find("td::eq(1)").children(":first").attr("type")=="text") {
	         codeValue =  $(obj).find("td::eq(1)").children(":first").val();
	         if (codeValue=="") codeValue="[(*_*)]";
	         codeType = 2
	      } else if ( $(obj).find("td::eq(1)").children(":first").attr("type")=="checkbox"){
	         codeValue =  $(obj).find("td::eq(1)").children(":first").attr("checked")==true?"1":"0";
	         codeType=1
	         var selectObjs=$(obj).find("td::eq(1)").find("select");                 
	         if (selectObjs.length>=1)  {
	           codeType=3   //year
	           codeValue=codeValue+"|"+selectObjs[0].value;
	         }
	      }
	    }
	    postValueStr += codeTitle+"\u001b"+codeValue+"\u001b"+ codeType+"\u0007";
	})
 
 postValueStr = postValueStr.substring(0,postValueStr.length-1);
 document.frmCoder.postValue.value=postValueStr;
 document.frmCoder.method.value="update";
 //alert(postValueStr)
 document.frmCoder.submit();
}
 
function onYearChkClick(obj,index){  
    document.getElementById("select_"+index).disabled=!obj.checked;
    proView();
}

function imgUpOnclick(index){

  var checkbox1Stats = 0;
  var checkbox2Stats = 0;
  var obj1 = document.getElementById("TR_"+index);

  var checkbox1 =obj1.childNodes[1].firstChild;
  if (checkbox1.type=="checkbox") checkbox1Stats = checkbox1.checked;

  //var obj2 = obj1.previousSibling.previousSibling;
  var obj2 = jQuery(obj1).prevAll("tr[customer1='member']").filter("tr:visible:first");
  var checkbox2 =$(obj2).find("td::eq(1)").children(":first");
  if (checkbox2.type=="checkbox") checkbox2Stats = checkbox2.checked;

 
   //obj1.swapNode(obj2);
  jQuery(obj1).swap(obj2);
  if (checkbox1Stats!=0) {
    checkbox1.checked=checkbox1Stats;
  }

   if (checkbox2Stats!=0) {
    checkbox2Stats.checked=checkbox2Stats;
  }
  load();
}

function imgDownOnclick(index){

  var checkbox1Stats = 0;
  var checkbox2Stats = 0;
  var obj1 = document.getElementById("TR_"+index);

  var checkbox1 =obj1.childNodes[1].firstChild;
  if (checkbox1.type=="checkbox") checkbox1Stats = checkbox1.checked;

  //var obj2 = obj1.nextSibling.nextSibling;
  //var checkbox2 =obj2.childNodes[1].firstChild;
  var obj2 =jQuery(obj1).nextAll("tr[customer1='member']").filter("tr:visible:first");// 
  var checkbox2 =$(obj2).find("td::eq(1)").children(":first");
  if (checkbox2.type=="checkbox") checkbox2Stats = checkbox2.checked;

 
  //obj1.swapNode(obj2);
  jQuery(obj1).swap(obj2);
  if (checkbox1Stats!=0) {
    checkbox1.checked=checkbox1Stats;
  }

   if (checkbox2Stats!=0) {
    checkbox2Stats.checked=checkbox2Stats;
  }
  load();
 
}
//-->
</SCRIPT>