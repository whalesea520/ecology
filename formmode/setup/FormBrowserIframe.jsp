
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.systemright.CheckSubCompanyRight" %>
<%@ page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@ page import="weaver.workflow.form.FormManager"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="com.weaver.formmodel.util.NumberHelper"%>
<%@page import="com.weaver.formmodel.util.DateHelper"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />


<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<HTML><HEAD>
<%
int pageNo = 1;
int pageSize = 12;
String formname = Util.null2String(request.getParameter("formname"));
String formtype = Util.null2String(request.getParameter("formtype"));
String strisReport  = Util.null2String(request.getParameter("isReport"));
boolean isReport = strisReport.equals("1")?true:false;
formtype = isReport?"2":formtype;

String userRightStr = "FORMMODEFORM:ALL";
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable ,-1,"",request,response,session);
int subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
String subCompanyId2 = ""+subCompanyId;
%>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
</HEAD>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_top} " ;//搜索
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:searchReset(),_top} " ;//重新设置
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;//清除
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.parent.close(),_top} " ;//取消
RCMenuHeight += RCMenuHeightStep ;

%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM NAME=SearchForm action="FormBrowserIframe.jsp" method=post>
<input type="hidden" name="isReport" value="<%=strisReport%>">
<table id="topTitle" cellpadding="0" cellspacing="0" style="display:none;">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(82529, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="submitData()">
				<span title="<%=SystemEnv.getHtmlLabelName(81804, user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
</table>
<table  width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td ></td>
	<td valign="top">
	  <TABLE class=Shadow>
		<tr>
		  <td valign="top">
			 <table class="e8_tblForm" style="margin: 10px 0;">
			   <TR>
				 <TD width=20% class="e8_tblForm_label"><!-- 自定义表单 -->
				   <%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%>
				 </TD>
				 <TD width=30% class="e8_tblForm_field"><input name=formname value="<%=formname%>" class="InputStyle"></TD>
				 <TD width=20% class="e8_tblForm_label"  style="display: <%=isReport?"none":""%>">
				    <%=SystemEnv.getHtmlLabelName(18411,user.getLanguage())%><!-- 表单类型 -->
				 </TD>
				 <TD width=30% class="e8_tblForm_field" style="display: <%=isReport?"none":""%>">
					<select name="formtype" id="formtype">
					    <option value="0" ></option>
						<option value="1" <%if(formtype.equals("1")) {%> selected <% }%>><%=SystemEnv.getHtmlLabelName(33885,user.getLanguage())%></option><!-- 虚拟表单 -->
						<option value="2" <%if(formtype.equals("2")) {%> selected <% }%>><%=SystemEnv.getHtmlLabelName(33886,user.getLanguage())%></option><!-- 实际表单 -->
					</select>
				 </TD>
			    </TR>
			  </table>
			  <%
			  String perpage = "12";
			  String backFields = "a.id,d.labelname,c.isvirtualform ";
			  String sqlFrom = "from workflow_bill a left join ModeFormExtend c on a.id=c.formid " + 
              "left join HtmlLabelInfo d on a.namelabel=d.indexid and d.languageid=7 ";
              String SqlWhere = " where id<0 and invalid is null ";
              
              if(fmdetachable.equals("1")){
	              	CheckSubCompanyRight mSubRight = new CheckSubCompanyRight();
		  			int[] mSubCom = mSubRight.getSubComByUserRightId(user.getUID(),"FORMMODEFORM:ALL",0);
		  			String subCompanyIds = "";
		  			for(int i=0;i<mSubCom.length;i++){
		  				if(i==0){
		  					subCompanyIds += ""+mSubCom[i];
		  				}else{
		  					subCompanyIds += ","+mSubCom[i];
		  				}
		  			}
		  			if(subCompanyIds.equals("")){
		  				SqlWhere+= " and 1=2 ";
		  			}else{
		  				SqlWhere+= " and a.subCompanyId3 in ("+subCompanyIds+") ";
		  			}
              }
			  if(!formname.equals(""))
				  SqlWhere += " and d.labelname like '%"+formname+"%'";
			  if(formtype.equals("1"))
			      SqlWhere += " and isvirtualform = 1";
			  else if(formtype.equals("2")) 
			      SqlWhere += " and (isvirtualform is null or isvirtualform != 1)";
			    
		  	 String tableString=""+
				"<table pagesize=\""+perpage+"\" tabletype=\"none\">"+
					"<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"a.id\" sqlsortway=\"desc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(SqlWhere)+"\"/>"+
						"<head>"+            //自定义表单
							"<col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(19516,user.getLanguage())+SystemEnv.getHtmlLabelName(19532,user.getLanguage())+"\" column=\"labelname\" orderkey=\"labelname\"  otherpara=\"column:id+column:issystem+column:issystemflag+"+user.getLanguage()+"\" />"+
							//表单类型
							"<col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(18411,user.getLanguage())+"\" column=\"isvirtualform\" orderkey=\"isvirtualform\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.formmode.search.FormBrowserTransMethod.getFormType\"/>"+
						"</head>"+
				"</table>";
			  %>
			  <wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" isShowTopInfo="true"/>
			</td>
		  </tr>
		</TABLE>
	 </td>
	 <td></td>
  </tr>
</table>
</FORM>
</BODY></HTML>

<script type="text/javascript">
var parentWin = parent.parent.parent.getParentWindow(parent.parent);
var dialog = parent.parent.parent.getDialog(parent.parent);

function btnclear_onclick(){
	var returnjson = {id:"",name:""};
	if(dialog){
	    dialog.callback(returnjson);
	    if(parentWin.customDialogCallBack){
	    	parentWin.customDialogCallBack(0);
	    }
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}
}

function BrowseTable_onmouseover(e){
	e=e||event;
   var target=e.srcElement||e.target;
   if("TD"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }else if("A"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }
}
function BrowseTable_onmouseout(e){
	var e=e||event;
   var target=e.srcElement||e.target;
   var p;
	if(target.nodeName == "TD" || target.nodeName == "A" ){
      p=jQuery(target).parents("tr")[0];
      if( p.rowIndex % 2 ==0){
         p.className = "DataDark"
      }else{
         p.className = "DataLight"
      }
   }
}
jQuery(document).ready(function(){
	$(".loading", window.document).hide();
	$("#_xTable").bind("click",BrowseTable_onclick);
	$("input[name='formname']").bind('keydown',function(event){
		if(event.keyCode == 13){    
			submitData();
		}
	});
	$("#formtype").bind("change",function(){
		submitData();
	});
	/*jQuery("#BrowseTable").bind("mouseover",BrowseTable_onmouseover);
	jQuery("#BrowseTable").bind("mouseout",BrowseTable_onmouseout);*/
})
function BrowseTable_onclick(e){
	var e=e||event;
	var target=e.srcElement||e.target;

	if( target.nodeName =="TD"||target.nodeName =="A"  ){
		var tr ;
		if(target.nodeName=="TD"){
			tr = jQuery(target).parent();
		}else if(target.nodeName =="A" ){
			tr = jQuery(target).parent().parent();
		}
		var idValue = tr.find("input[type='checkbox']").val();
		var isvirtualform = 0;
		var vstr = tr.find("td:last").html();
		if(vstr=="<%=SystemEnv.getHtmlLabelName(33885,user.getLanguage())%>"){//虚拟表单
			isvirtualform = 1;
		}
   	 	var nameValue = "<a href=\"#\" onclick=\"toformtabFormChoosed('"+idValue+"_"+isvirtualform+"')\" style=\"color:blue;TEXT-DECORATION:none\">"+
   	 				 jQuery(jQuery(target).parents("tr")[0].cells[1]).text();
   	 	if(isvirtualform==1){
   	 		nameValue+="<div class=\"e8_data_virtualform\" title=\"<%=SystemEnv.getHtmlLabelName(33885,user.getLanguage())%>\">V</div>";//虚拟表单
   	 	}
   	 	nameValue+="</a>";
		var returnjson = {id:idValue,name:nameValue};
		if(dialog){
	    	dialog.callback(returnjson);
	    	if(parentWin.customDialogCallBack){
		    	parentWin.customDialogCallBack(isvirtualform);
		    }
		}else{
	    	window.parent.parent.returnValue  = returnjson;
	    	window.parent.parent.close();
		}
	}
}
function submitData(){
	SearchForm.submit();
}

function submitClear()
{
	btnclear_onclick();
}

function nextPage(){
	document.all("pagenum").value=parseInt(document.all("pagenum").value)+1 ;
	SearchForm.submit();	
}

function perPage(){
	document.all("pagenum").value=document.all("pagenum").value-1 ;
	SearchForm.submit();
}

function searchReset() {
	SearchForm.formname.value='';
	SearchForm.formtype.value='';
}
</script>


