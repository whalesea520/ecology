
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.worktask.code.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />

<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
boolean canEdit=true;
if(!HrmUserVarify.checkUserRight("WorktaskManage:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<html>
<%
	int wtid = Util.getIntValue(Util.null2String(request.getParameter("wtid")), 0);

	String sql = "select worktask_taskfield.fieldid, worktask_taskfield.crmname, worktask_fielddict.description from worktask_taskfield, worktask_fielddict where worktask_taskfield.fieldid=worktask_fielddict.id and worktask_fielddict.fieldhtmltype=1 and worktask_fielddict.type=1 and worktask_taskfield.isshow=1 and worktask_taskfield.taskid="+wtid;

	//初始值
	//CodeBuild cbuild = new CodeBuild(formid); 
	//CodeBuild cbuild = new CodeBuild(formid,isbill);
	CodeBuild cbuild = new CodeBuild(wtid);
	boolean hasHistoryCode = cbuild.hasHistoryCode(RecordSet,wtid);
	CoderBean cbean = cbuild.getTaskCBuild();
	ArrayList coderMemberList = cbean.getMemberList();
	String isUse =  cbean.getUserUse();
	String worktaskSeqAlone =  cbean.getWorktaskSeqAlone();
	String dateSeqAlone =  cbean.getDateSeqAlone();
	String dateSeqSelect =  cbean.getDateSeqSelect();
	String codefield = cbean.getCodeFieldId();
%>

<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

<link type="text/css" href="/js/ecology8/base/jquery-ui_wev8.css" rel=stylesheet>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
</head>
<body>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:flowCodeSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(21931,user.getLanguage())+",javascript:useSetto(this),_self} " ;
//RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:location.reload(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(21931,user.getLanguage())+",javascript:useSetto(),_self}" ;
//RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
			   <td>
				</td>
				<td class="rightSearchSpan" style="text-align:right; ">
					<input type="button"
				value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"
				class="e8_btn_top middle" onclick="flowCodeSave(this);">
			<span title="<%=SystemEnv.getHtmlLabelName(2104,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>

<form id="frmCoder" name="frmCoder" method=post action="coderOperation.jsp" >

 <INPUT TYPE="hidden" NAME="postValue">
 <INPUT TYPE="hidden" NAME="wtid" value="<%=wtid%>">
 
 <%
		String  groupShow = "{'samePair':'groupShow','groupDisplay':'none',itemAreaDisplay:'none','expandAllGroup':'true'}";
		if("1".equals(isUse)) groupShow = "{'samePair':'groupShow','groupDisplay':'',itemAreaDisplay:'block','expandAllGroup':'true'}";
%>

 <wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>' attributes="{'expandAllGroup':'true'}">
			<wea:item><%=SystemEnv.getHtmlLabelName(18624, user.getLanguage())%></wea:item>
			<wea:item>
				<input class="inputStyle" type="checkbox" onclick="toShowGroup(this)" name="txtUserUse" value="1" <%if ("1".equals(isUse)) out.println("checked");%>>
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(19503, user.getLanguage())%></wea:item>
			<wea:item>
				<select name="selectField" style="width: 120px">
			            <%  
						//System.out.println(sql);
						RecordSet.execute(sql);
						while (RecordSet.next()){
							int fieldid = Util.getIntValue(RecordSet.getString("fieldid"), 0);
							String description = Util.null2String(RecordSet.getString("description"));
							String crmname = Util.null2String(RecordSet.getString("crmname"));
							if("".equals(crmname)){
								crmname = description;
							}
			            %>
			            <option  <%if (codefield.equals(""+fieldid)) {%>selected<%}%>  value=<%=fieldid%>>
						<%=crmname%>
						</option>
			            <%}%>
            	</select>
			</wea:item>
		</wea:group>

      <wea:group context='<%=SystemEnv.getHtmlLabelName(19381, user.getLanguage())%>' attributes="<%=groupShow%>">
          <wea:item attributes="{'isTableList':'true','colspan':'full','classTR':'notMove'}">
               <wea:layout needImportDefaultJsAndCss="false" type="3col" attributes="{'formTableId':'codeRule'}">
					<wea:group context="" attributes="{'groupDisplay':'none'}">		
        
						<%
							List hisShowNameList =new ArrayList();
							hisShowNameList.add("18729");
							hisShowNameList.add("445");
							hisShowNameList.add("6076");
							hisShowNameList.add("18811");
						%>
			          <%for (int i=0;i<coderMemberList.size();i++){
			                 String[] codeMembers = (String[])coderMemberList.get(i);
			                 String codeMemberName = codeMembers[0];
			                 String codeMemberValue = codeMembers[1];
			                 String codeMemberType = codeMembers[2];
							 
							 if(hasHistoryCode&&hisShowNameList.indexOf(codeMemberName)==-1){
								 continue;
							 }
							 String attributes = "{'colspan':'full','trId':'TR_"+i+"','customer1':'member'}";
							 String attrs = "{'codevalue':'"+codeMemberName+"'}";
			             %>
				            <wea:item attributes='<%=attrs %>'>
				                     <%if (canEdit){%>
				                       <a style="display:inline-block;padding-right:10px" href="#" onclick="return false;"><img id="img_up_<%=i%>" _moveimg name="img_up" src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(78,user.getLanguage())%>' border=0></a>
				                     <%}%>
				                      <%=SystemEnv.getHtmlLabelName(Util.getIntValue(codeMemberName),user.getLanguage()) %>
				            </wea:item>
				            <wea:item attributes='<%=attributes %>'>
				                      <%
				                         if ("1".equals(codeMemberType)){   //1:checkbox
				                           if ("1".equals(codeMemberValue)){
				                             if (canEdit){
				                      %>
				                            <input  tzCheckbox=true  id="chk_<%=i %>" type=checkbox class=inputstyle checked value=1  onclick=proView()>
				                      <%
				                             } else {
				                              out.println("<div>"+SystemEnv.getHtmlLabelName(160,user.getLanguage())+"</div>");
				                             }
				                           } else {
				                              if (canEdit){
				                          %>
				                              <input tzCheckbox="true"  id="chk_<%=i %>" type=checkbox class=inputstyle  value=1  onclick=proView()>
				                          <%
				                               
				                               } else {
				                                out.println("<div>"+SystemEnv.getHtmlLabelName(165,user.getLanguage())+"</div>");
				                               }
				                           }
				                         } else if ("2".equals(codeMemberType)){   //2:input
				                              if (canEdit){%>
				                                 <input type=text  style="width:60px"  name="inputt<%=i%>" <%if (codeMemberName.equals("18811")) {%> onchange='checkint("inputt<%=i%>");proView();'<%} else {%>onchange=proView()<%}%> class=inputstyle   value="<%=codeMemberValue%>">
				                              <% } else {
				                                  out.println("<div>"+codeMemberValue+"</div>");
				                               } 
				                             
				                         }  
				                    %>
				              </wea:item>     
						<%}%>
			          
						
		             </wea:group>
		         </wea:layout>
		     </wea:item>		     
		     
		     
							      <%if(!hasHistoryCode){%>
								       <wea:item attributes="{'classTR':'notMove'}"><%=SystemEnv.getHtmlLabelName(22133, user.getLanguage())%></wea:item>   
							                 <wea:item attributes="{'colspan':'full','classTR':'notMove'}">
							                        <input class="inputStyle" tzCheckbox=true  type="checkbox" name="worktaskSeqAlone" value="1" <%if ("1".equals(worktaskSeqAlone)) out.println("checked");%> <%if(!canEdit){%>disabled<%}%>>
							                 </wea:item>   
								              
								       <wea:item attributes="{'classTR':'notMove'}"><%=SystemEnv.getHtmlLabelName(19418, user.getLanguage())%></wea:item>   
							              <wea:item attributes="{'colspan':'full','classTR':'notMove'}">
							                   	<input class="inputStyle" tzCheckbox=true  type="checkbox" name="dateSeqAlone" value="1" <%if ("1".equals(dateSeqAlone)) out.println("checked");%> >&nbsp;
											<input class="inputStyle" type="radio" name="dateSeqSelect" value="1" <%if ("1".equals(dateSeqSelect)||"".equals(dateSeqSelect)) out.println("checked");%> ><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>&nbsp;&nbsp;
											<input class="inputStyle" type="radio" name="dateSeqSelect" value="2" <%if ("2".equals(dateSeqSelect)) out.println("checked");%> ><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>&nbsp;&nbsp;
											<input class="inputStyle" type="radio" name="dateSeqSelect" value="3" <%if ("3".equals(dateSeqSelect)) out.println("checked");%> ><%=SystemEnv.getHtmlLabelName(390,user.getLanguage())%>
							             </wea:item>  
								            
								 <%}%>
							                      <wea:item attributes="{'classTR':'notMove'}"><%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%></wea:item>
							          <wea:item attributes="{'classTR':'notMove'}">
							                   <table style="border:1px solid #0070C0;border-bottom:none;border-left:none;border-top:none;" cellspacing="0" cellpadding="0">
							                   	<tr id="TR_pro"></tr>
							                   </table>
							       </wea:item>	
		       			 
      
      </wea:group>    
      
</wea:layout>

</form>

<script language="JavaScript" src="/js/addRowBg_wev8.js" >
</script>

</body>

<SCRIPT LANGUAGE="JavaScript">

var colors= new Array ("#6633CC","#FF33CC","#666633","#CC00FF","#996666")  ;

function load(){  //检查Imag的状态
  var img_ups = jQuery("img[name=img_up]");
  for (var index_up=0;index_up<img_ups.length;index_up++)  {
    var img_up = img_ups[index_up];
    if (index_up==0)  {img_up.style.visibility ='hidden';
    img_up.style.width =0;}
    else  
    {img_up.style.visibility ='visible';
    img_up.style.width =10;
    }
  }

  var img_downs = jQuery("img[name=img_down]");
  for (var index_down=0;index_down<img_downs.length;index_down++)  {
    var img_down = img_downs[index_down];
    if (index_down==img_downs.length-1)  {img_down.style.visibility ='hidden';
    img_down.style.width =0;
    }
    
    else  {img_down.style.visibility ='visible';
    img_down.style.width =10;
    }
  }

  proView();
}


jQuery(document).ready(function(){
	<%if (canEdit){%>
		registerDragEvent();
	<%}%>
	proView();
});



function toShowGroup(obj){
	var isChecked = obj.checked;
	   if(isChecked){
		  showGroup("groupShow");
		  showEle("itemShow");
	   }else{
		  hideGroup("groupShow");
		  hideEle("itemShow");
	   }
}

function MainCallback(){
	dialog.close();
	window.location.reload();
}


function useSetto(){
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(21931,user.getLanguage()) %>";
    dialog.URL = "/worktask/base/WorktaskList.jsp?wtid=<%=wtid%>&usesettotype=0";
	dialog.Width = 660;
	dialog.Height = 660;
	dialog.Drag = true;
	dialog.textAlign = "center";
	dialog.show();
}


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
	      
	jQuery("#codeRule tbody tr").bind("mousedown",function(e){
		copyTR = jQuery(this).next("tr.Spacing");
	});
	
        
    jQuery("#codeRule tbody").sortable({                //这里是talbe tbody，绑定 了sortable  
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
       		proView();
       	}
           return ui;  
        }  
    });  
    
}

function proView(){
    var TR_pro = document.getElementById("TR_pro");
    var TR_proChilds = TR_pro.childNodes;    
    for (var i=TR_proChilds.length-1;i>=0;i--) jQuery(TR_proChilds[i]).remove();


    var TR_members= jQuery("TR[customer1]");
    for (var index=0;index< TR_members.length;index++ ){      
      var TR_member = TR_members[index];
      //if ($(TR_member).attr("customer1")!="member") continue;
      
      var codeTitle = jQuery.trim(jQuery(jQuery(TR_member).children()[0]).text());
      //var codeTypeTag = jQuery(jQuery(TR_member).children()[1]).children()[0].tagName;   //checkbox input div   
       //var codeTypeTag = $(TR_member).find("td::eq(1)").children(":first").attr("tagName") ;
       var codeTypeTag = $(TR_member).find("td::eq(1)").children(":first").attr("tagName");
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
       

        if (codeTypeTag=="INPUT"||codeTypeTag=="DIV"&&codeValue!="<%=SystemEnv.getHtmlLabelName(82185,user.getLanguage())%>")  { 
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
        var tempTable = document.createElement("TABLE");
        
        jQuery(tempTable).css("border","1px solid #0070C0");
	    jQuery(tempTable).css("border-right","none");
        
        var newRow = tempTable.insertRow(-1);
        var newRowMiddle = tempTable.insertRow(-1);
        var newRow1 = tempTable.insertRow(-1);


        var newCol = newRow.insertCell(-1);
        var newColMiddle=newRowMiddle.insertCell(-1);
        var newCol1 = newRow1.insertCell(-1);

        newColMiddle.className="Line";
        jQuery(newColMiddle).parents("tr")[0].style.height="1px";

        newCol.innerHTML="<font color="+colors[index%5]+">"+codeTitle+"</font>";

        if (codeValue=="1") {
          codeValue="****";
        } else if (codeValue=="0") {
          codeValue="**";
        }
        newCol1.innerHTML="<font color="+colors[index%5]+">"+codeValue+"</font>";
        tempTd.appendChild(tempTable);
        TR_pro.appendChild(tempTd);         
      }
    }
    
}

function onSave(obj){
 
 var TR_members= document.getElementsByTagName("TR");
  var postValueStr="";
  jQuery("tr[customer1").each(function(index,obj){
	  var codeTitle = $(obj).find("td::eq(0)").attr("codevalue")
	  codeTitle = jQuery.trim(codeTitle)
	  var codeTypeTag = $(obj).find("td::eq(1)").children(":first").attr("tagName");
	  var codeValue;
	  var codeType;

	    if (codeTypeTag=="INPUT") {
	      codeValue= $(obj).find("td::eq(1)").children(":first").val();
	      if ( $(obj).find("td::eq(1)").children(":first").attr("type")=="text") {
	         codeValue =  $(obj).find("td::eq(1)").children(":first").val();
	         if (codeValue=="") codeValue="[(*_*)]";
	         var name =  $(obj).find("td::eq(1)").children(":first").attr("name");
	         if(name.substring(0,1)==2)
	         	codeType = 2;
	         else if(name.substring(0,1)==3)
	         	codeType = 3;
	      } else if ( $(obj).find("td::eq(1)").children(":first").attr("type")=="checkbox"){
	         codeValue =  $(obj).find("td::eq(1)").children(":first").attr("checked")==true?"1":"0";
	         var name =  $(obj).find("td::eq(1)").children(":first").attr("name");
	         if(name.substring(0,1)==1)
	         	codeType = 1;      
	         else if(name.substring(0,1)==4)
	         	codeType = 4;
	      }
	    }
	    postValueStr += codeTitle+"\u001b"+codeValue+"\u001b"+ codeType+"\u0007";
  })

 postValueStr = postValueStr.substring(0,postValueStr.length-1);
 document.frmCoder.postValue.value=postValueStr;
 //document.frmCoder.method.value="update";
 //alert(postValueStr)
 //document.frmCoder.submit();
}
 
function onYearChkClick(obj,index){  
    document.getElementById("select_"+index).disabled=!obj.checked;
    proView();
}

function imgUpOnclick(index){

  var checkbox1Stats = 0;
  var checkbox2Stats = 0;
  var obj1 = document.getElementById("TR_"+index);

  var checkbox1 = jQuery(jQuery(obj1).children()[1]).children()[0];
  if (checkbox1.type=="checkbox") checkbox1Stats = checkbox1.checked;

  var obj2 = jQuery(obj1).prev().prev()[0];
  var checkbox2 = jQuery(jQuery(obj2).children()[1]).children()[0];
  if (checkbox2.type=="checkbox") checkbox2Stats = checkbox2.checked;

  swapNode(obj1,obj2);
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

	var checkbox1 = jQuery(jQuery(obj1).children()[1]).children()[0];
	if (checkbox1.type=="checkbox"){
		checkbox1Stats = checkbox1.checked;
	}

	var obj2 = jQuery(obj1).next().next()[0];
	var checkbox2 = jQuery(jQuery(obj2).children()[1]).children()[0];
	if (checkbox2.type=="checkbox") checkbox2Stats = checkbox2.checked;

	swapNode(obj1,obj2);
	if (checkbox1Stats!=0) {
		checkbox1.checked=checkbox1Stats;
	}

	if (checkbox2Stats!=0) {
		checkbox2Stats.checked=checkbox2Stats;
	}
	load();

}
function flowCodeSave(obj){
	obj.disabled=true;
	onSave(obj);
	frmCoder.submit();
}



function swapNode(node, node2) {
	jQuery(node2).replaceWith(jQuery("<div></div>").append(jQuery(node).clone()).html());
	jQuery(node).replaceWith(jQuery("<div></div>").append(jQuery(node2).clone()).html());
}
</SCRIPT>

</html>
