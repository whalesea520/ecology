<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
 if(!HrmUserVarify.checkUserRight("WorkflowCustomManage:All", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	} 
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String id = Util.null2String(request.getParameter("id"));

String isBill = Util.null2String(request.getParameter("isBill"));

String formID = Util.null2String(request.getParameter("formID"));

int dbordercount = Integer.parseInt(Util.null2String(request.getParameter("dbordercount")));

String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(20773,user.getLanguage())+SystemEnv.getHtmlLabelName(261,user.getLanguage())+SystemEnv.getHtmlLabelName(19653,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
String isclose = Util.null2String(request.getParameter("isclose"));
String otype = Util.null2String(request.getParameter("otype"));
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int operatelevel=Util.getIntValue(request.getParameter("operatelevel"),0);
if(detachable==1)
{

    rs.execute("select subcompanyid from workflow_custom where id="+id);
    rs.next();
    String subcompanyid= Util.null2String(rs.getString("subcompanyid"));
    operatelevel = checkSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "WorkflowCustomManage:All", Util.getIntValue(subcompanyid,0));
}
if(!isclose.equals("1") && operatelevel < 0){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%if(operatelevel > 0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
}%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<%if(operatelevel > 0){ %>
			<input id="btnSave" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" class="e8_btn_top" onclick="submitData()" />
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=frmMain action="CustomOperation.jsp" method=post>
<input type="hidden" name="otype" value="<%=otype%>" />
<input type=hidden name=formID id=formID value=<%=formID%>>
<input type=hidden name=isBill id=isBill value=<%=isBill%>>	    
<input type=hidden name=dbordercount id=dbordercount value=<%=dbordercount%>>	    
<%
    int tmpcount = 0;
    int tmpcount1 = 0;
    int tmpcount2 = 0;
    String ifquery="";
	String isshows="";
    int dborder=-1;
    String dbordertype = "";
    int compositororder = 0;
    String dsporder="";
	String fieldname="";
	String fieldnamevalue="";
	String ifshows="";
    String queryorder="";
%>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20773,user.getLanguage())+SystemEnv.getHtmlLabelName(261,user.getLanguage())%>'>
		<wea:item attributes="{'isTableList':'true'}">
			<table class="ListStyle" id="oTable">
				<colgroup>
					<col width="20%">
					<col width="30%">
					<col width="20%">
				</colgroup>
				<tbody> 
				<tr class=header> 
					<th><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></th>
					<th><%=SystemEnv.getHtmlLabelName(20779,user.getLanguage())%></th>
					<th><%=SystemEnv.getHtmlLabelName(20778,user.getLanguage())%></th> 
				</tr>
<%--				<%--%>
<%--				for(int i = -1; i >=-10; i--){--%>
<%--					tmpcount ++;--%>
<%--					ifquery="";--%>
<%--					isshows = ""; --%>
<%--					dsporder="";--%>
<%--					queryorder="";--%>
<%--					rs.executeSql("select * from Workflow_CustomDspField where customid="+id+" and fieldid="+i+"  ");--%>
<%--					if(rs.next()){--%>
<%--						ifquery=rs.getString("ifquery");--%>
<%--						isshows=rs.getString("ifshow");--%>
<%--						dsporder=rs.getString("showorder");--%>
<%--						if(tmpcount1<Util.getIntValue(dsporder))--%>
<%--							tmpcount1=Util.getIntValue(dsporder);--%>
<%--						queryorder=rs.getString("queryorder");--%>
<%--						if(tmpcount2<Util.getIntValue(queryorder))--%>
<%--							tmpcount2=Util.getIntValue(queryorder);--%>
<%--					}--%>
<%--					--%>
<%--					   //if (isshows.equals("1")) tmpcount1++;--%>
<%--					if("-1".equals(""+i)){--%>
<%--						fieldname=SystemEnv.getHtmlLabelName(1334,user.getLanguage());--%>
<%--						fieldnamevalue="requestname";--%>
<%--					}else if("-2".equals(""+i)){--%>
<%--						fieldname=SystemEnv.getHtmlLabelName(15534,user.getLanguage());--%>
<%--						fieldnamevalue="requestlevel";--%>
<%--					}else if("-9".equals(""+i)){--%>
<%--						fieldname=SystemEnv.getHtmlLabelName(16354,user.getLanguage());--%>
<%--						fieldnamevalue="";--%>
<%--					}else if("-8".equals(""+i)){--%>
<%--						fieldname=SystemEnv.getHtmlLabelName(1335,user.getLanguage());--%>
<%--						fieldnamevalue="status";--%>
<%--					}else if("-7".equals(""+i)){--%>
<%--						fieldname=SystemEnv.getHtmlLabelName(17994,user.getLanguage());--%>
<%--						fieldnamevalue="receivedate";--%>
<%--					}else if("-6".equals(""+i)){--%>
<%--						fieldname=SystemEnv.getHtmlLabelName(18564,user.getLanguage());--%>
<%--						fieldnamevalue="currentnodeid";--%>
<%--					}else if("-5".equals(""+i)){--%>
<%--						fieldname=SystemEnv.getHtmlLabelName(259,user.getLanguage());--%>
<%--						fieldnamevalue="workflowid";--%>
<%--					}else if("-4".equals(""+i)){--%>
<%--						fieldname=SystemEnv.getHtmlLabelName(882,user.getLanguage());--%>
<%--						fieldnamevalue="creater";--%>
<%--					}else if("-3".equals(""+i)){--%>
<%--						fieldname=SystemEnv.getHtmlLabelName(722,user.getLanguage());--%>
<%--						fieldnamevalue="createdate";--%>
<%--					}else if("-10".equals(""+i)){--%>
<%--						fieldname=SystemEnv.getHtmlLabelName(19061,user.getLanguage());--%>
<%--						fieldnamevalue="requeststatus";--%>
<%--					}--%>
<%--				%>--%>
<%--				<tr>--%>
<%--					<td>--%>
<%--						<%=fieldname%><%if (!fieldnamevalue.equals("")) {%>(<%=fieldnamevalue%>)<%}%>--%>
<%--						<input type="hidden" name='<%="fieldid_"+tmpcount%>' value="<%=i%>">--%>
<%--						<input type="hidden" name='<%="lable_"+tmpcount%>' value=<%=fieldname%>>--%>
<%--					</td>--%>
<%--					<%String strtmpcount1 =(new Integer(tmpcount)).toString();%>--%>
<%--					<td class=Field>--%>
<%--			            <%if(i!=-10){%>--%>
<%--			        		<input type="checkbox" name='<%="isshows_"+tmpcount%>' onclick="onCheckShows(<%=strtmpcount1%>)"  value="1" <%if(isshows.equals("1")){%> checked <%}%> >--%>
<%--			        	<%        	   --%>
<%--			            }else{%>--%>
<%--			        		<input type="checkbox" style="display: none;visibility: hidden;" name='<%="isshows_"+tmpcount%>' onclick="onCheckShows(<%=strtmpcount1%>)"  value=""  >--%>
<%--			        	<%} %>--%>
<%----%>
<%--			        	<%if(isshows.equals("1")){%>--%>
<%--							<input type="text" style="<%if(i==-10){%>display:none;<%} %>" onKeyPress="Count_KeyPress1('dsporder_',<%=strtmpcount1%>)" class=Inputstyle name='<%="dsporder_"+tmpcount%>' size="6" onblur="checkint('dsporder_<%=tmpcount%>')"  <%if(!"".equals(dsporder)){%> value=<%=dsporder%> <%}%>  >--%>
<%--						<%}else{%>--%>
<%--							<input type="text" style="<%if(i==-10){%>display:none;<%} %>" onKeyPress="Count_KeyPress1('dsporder_',<%=strtmpcount1%>)" class=Inputstyle name='<%="dsporder_"+tmpcount%>' size="6" value="" disabled = "true" onblur="checkint('dsporder_<%=tmpcount%>')">--%>
<%--						<%}%>--%>
<%--					</td>--%>
<%--					<td class=Field>--%>
<%--						<input type="checkbox" name='<%="ifquery_"+tmpcount%>' value="1" <%if(ifquery.equals("1")){%> checked <%}%> onclick='onCheckShow(<%=strtmpcount1%>)' >--%>
<%----%>
<%--						<%if(ifquery.equals("1")){%>--%>
<%--						<input type="text" onKeyPress="Count_KeyPress1('queryorder_',<%=strtmpcount1%>)"  class=Inputstyle name='<%="queryorder_"+tmpcount%>' size="6"  onblur="checkint('queryorder_<%=tmpcount%>')" <%if(!"".equals(queryorder)){%> value=<%=queryorder%> <%}%> >--%>
<%--						<%}else{%>--%>
<%--						<input type="text" onKeyPress="Count_KeyPress1('queryorder_',<%=strtmpcount1%>)" class=Inputstyle name='<%="queryorder_"+tmpcount%>' size="6" value="" disabled = "true" onblur="checkint('queryorder_<%=tmpcount%>')">--%>
<%--						<%}%>--%>
<%--					</td>--%>
<%--				</tr>--%>
<%--				<tr class='Spacing' style="height:1px!important;"><td colspan=5 class='paddingLeft18'><div class='intervalDivClass'></div></td></tr>--%>
<%--				<%}%>--%>
				
				<%
				int linecolor=0;
				String sql="";
				boolean isOracle=rs.getDBType().equals("oracle");
				if(isBill.equals("0")){
					sql = "select workflow_formfield.fieldid as id,fieldname as name,workflow_fieldlable.fieldlable as label,workflow_formfield.fieldorder as fieldorder,workflow_formdict.fielddbtype as dbtype, workflow_formdict.fieldhtmltype as httype,workflow_formdict.type as type from workflow_formfield,workflow_formdict,workflow_fieldlable where workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.isdefault = 1 and workflow_fieldlable.fieldid =workflow_formfield.fieldid and workflow_formdict.id = workflow_formfield.fieldid and workflow_formfield.formid="+formID+" and (workflow_formfield.isdetail = '' or workflow_formfield.isdetail is null) order by workflow_formfield.fieldorder";
					String sql1 = "select isdetail viewtype,workflow_formfield.fieldid as id,fieldname as name,workflow_fieldlable.fieldlable as label,workflow_formfield.fieldorder as fieldorder,workflow_formdict.fielddbtype as dbtype, workflow_formdict.fieldhtmltype as httype,workflow_formdict.type as type from workflow_formfield,workflow_formdict,workflow_fieldlable where workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.isdefault = 1 and workflow_fieldlable.fieldid =workflow_formfield.fieldid and workflow_formdict.id = workflow_formfield.fieldid and workflow_formfield.formid="+formID+" and (workflow_formfield.isdetail = '' or workflow_formfield.isdetail is null) ";
					if(isOracle)sql1+=" order by viewtype,workflow_formfield.fieldorder";
					//查询明细表
					String sql2 = "select isdetail viewtype, wf.fieldid id, fd.fieldname name, fl.fieldlable label, wf.fieldorder fieldorder, fd.fielddbtype dbtype, fd.fieldhtmltype httype, fd.type type from workflow_formfield wf, workflow_formdictdetail fd, workflow_fieldlable fl where fd.id = fl.fieldid and wf.fieldid = fd.id and fl.formid = wf.formid and wf.isdetail = '1' and wf.formid = "+formID+" ";
					if(isOracle)sql2+=" order by viewtype,wf.groupid ";
					if(isOracle){
						sql = "select * from("+sql1+") union all select * from ("+sql2+")";
					}else{
						sql = sql1+" union all "+sql2+" ORDER BY viewtype,fieldorder";
					}
				}else if(isBill.equals("1")){
					sql = "select workflow_billfield.id as id,workflow_billfield.fieldname as name,workflow_billfield.fieldlabel as label,workflow_billfield.fielddbtype as dbtype ,workflow_billfield.fieldhtmltype as httype, workflow_billfield.type as type,workflow_billfield.dsporder as dsporder from workflow_billfield where workflow_billfield.billid="+formID+"  and (viewtype='0') order by dsporder";
					String sql1 = "select viewtype,workflow_billfield.id as id,workflow_billfield.fieldname as name,workflow_billfield.fieldlabel as label,workflow_billfield.fielddbtype as dbtype ,workflow_billfield.fieldhtmltype as httype, workflow_billfield.type as type,workflow_billfield.dsporder as dsporder from workflow_billfield where workflow_billfield.billid="+formID+"  and (viewtype='0') ";
					if(isOracle)sql1+=" order by dsporder ";
					//查询明细表
					String sql2 = "select viewtype,bf.id id, bf.fieldname name, bf.fieldlabel label, bf.fielddbtype dbtype, bf.fieldhtmltype httype, bf.type type,bf.dsporder as dsporder from workflow_billfield bf, Workflow_billdetailtable bft where bf.viewtype = '1' and bf.billid = "+formID+" and bf.detailtable = bft.tablename and bft.billid = bf.billid ";
					if(isOracle)sql2+=" ORDER BY viewtype,bf.dsporder ";
					if(isOracle){
						sql = "select * from("+sql1+") union all select * from ("+sql2+")";
					}else{
						sql = sql1+" union all "+sql2+" ORDER BY viewtype,dsporder";
					}
				}
				
				rs.executeSql(sql);
				boolean firstDetail = false;
				while(rs.next()){
				//if(rs.getString("type").equals("226")||rs.getString("type").equals("227")||rs.getString("type").equals("224")||rs.getString("type").equals("225")){
					//屏蔽集成浏览按钮-zzl
					//continue;
				//}	
				String viewtype = rs.getString("viewtype");
				tmpcount ++;
				//在找到第一个明细表的时候,添加一个独立的行表示之后是明细表!
				if(!firstDetail&&"1".equals(viewtype)){
					firstDetail = true;
					%>
					 <tr class='Title'> <th colspan='5' ><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage()) %></th></tr>
					<%
				}				
				String fieldid = rs.getString("id"); 
				String label = rs.getString("label");
				String dbtype= rs.getString("dbtype");
				if(isBill.equals("1"))
					label = SystemEnv.getHtmlLabelName(Util.getIntValue(label),user.getLanguage());
				ifquery="";
				ifshows = ""; 
				dsporder="";
				queryorder="";
				rs1.executeSql("select * from Workflow_CustomDspField where customid="+id+" and fieldid="+fieldid);
				if(rs1.next()){
					ifquery=rs1.getString("ifquery");
					dsporder=rs1.getString("showorder");
					ifshows=rs1.getString("ifshow");
					queryorder=rs1.getString("queryorder");
					if (tmpcount1<Util.getIntValue(dsporder))
					tmpcount1=Util.getIntValue(dsporder);
					queryorder=rs1.getString("queryorder");
					if (tmpcount2<Util.getIntValue(queryorder))
						tmpcount2=Util.getIntValue(queryorder);
				}
				
				%>
				
				<tr> 
				<td><%=label%>(<%=rs.getString("name")%>)
					<input type="hidden" name='<%="fieldid_"+tmpcount%>' value=<%=fieldid%>>
					<input type="hidden" name='<%="lable_"+tmpcount%>' value=<%=label%>>
				</td>
				<%String strtmpcount =(new Integer(tmpcount)).toString();%>
				<td class=Field>
					<%if(!firstDetail){%>
					<input type="checkbox" name='<%="isshows_"+tmpcount%>' onclick="onCheckShows(<%=strtmpcount%>)" value="1" <%if(ifshows.equals("1")){%> checked <%}%> >
					<%}else{ %>
					<input type="checkbox" name='<%="isshows_"+tmpcount%>' onclick="onCheckShows(<%=strtmpcount%>)" style='display:none' value="0">
					<%} %>

					<%if(ifshows.equals("1")){%>
					<input type="text" onKeyPress="Count_KeyPress1('dsporder_',<%=strtmpcount%>)"  class=Inputstyle name='<%="dsporder_"+tmpcount%>' size="6"  onblur="checkint('dsporder_<%=tmpcount%>')" <%if(!"".equals(dsporder)){%> value=<%=dsporder%> <%}%> >
					<%}else{%>
					<input type="text" onKeyPress="Count_KeyPress1('dsporder_',<%=strtmpcount%>)" class=Inputstyle name='<%="dsporder_"+tmpcount%>' size="6" value="" disabled = "true" onblur="checkint('dsporder_<%=tmpcount%>')">
					<%}%>
				</td>
				<td class=Field>
				     <input type="checkbox" name='<%="ifquery_"+tmpcount%>'  value="1" <%if(ifquery.equals("1")){%> checked <%}%>  onclick='onCheckShow(<%=strtmpcount%>)'>

				      <%if(ifquery.equals("1")){%>
						<input type="text" onKeyPress="Count_KeyPress1('queryorder_',<%=strtmpcount%>)"  class=Inputstyle name='<%="queryorder_"+tmpcount%>' size="6"  onblur="checkint('queryorder_<%=tmpcount%>')" <%if(!"".equals(queryorder)){%> value=<%=queryorder%> <%}%> >
						<%}else{%>
						<input type="text" onKeyPress="Count_KeyPress1('queryorder_',<%=strtmpcount%>)" class=Inputstyle name='<%="queryorder_"+tmpcount%>' size="6" value="" disabled = "true" onblur="checkint('queryorder_<%=tmpcount%>')">
						<%}%>
				</td>
				</tr>
				<tr class='Spacing' style="height:1px!important;"><td colspan=5 class='paddingLeft18'><div class='intervalDivClass'></div></td></tr>   
				<%}%>
				<input type="hidden" name=operation value=formfieldadd>
				<input type="hidden" name=reportid value=<%=id%>>
				<input type="hidden" name=tmpcount value=<%=tmpcount%>>
				<input type="hidden" name=tmpcount1 value=<%=tmpcount1%>>
				<input type="hidden" name=tmpcount2 value=<%=tmpcount2%>>
				</tbody> 
			</table>		
		</wea:item>
	</wea:group>
</wea:layout>
</form>
<br/>
<script language="javascript">
if("<%=isclose%>"==1){
	var dialog = parent.parent.getDialog(parent);
	var parentWin = parent.parent.getParentWindow(parent);
	parentWin.location="/workflow/workflow/CustomQuerySet.jsp?otype=<%=otype%>";
	dialog.closeByHand();	
}

jQuery(document).ready(function(){
	jQuery("#oTable").find("tr[class=Spacing]:last").find("td").removeClass("paddingLeft18").addClass("paddingLeft0");
});
var isenabled;
if(<%=dbordercount%>>0)
  isenabled=false;
else
  isenabled=true;


function submitData()
{    
 if (check_form(frmMain,'fieldidimage')){
	len = document.forms[0].elements.length;
  var i=0;
  var index;
  var selectName;
  var checkName;
  var lableName; 
  var compositororderName;
  submit = true;   

  var rowsum1 = 0;
  
  if(submit == true){
   if(checkSame()){
       enableAllmenu();
   frmMain.submit();
   }
  }
}
}


function checkSame(){
var num = <%=tmpcount%>;
var showcount = 0;
var ordervalue = "";
var tempcount = -1;
var checkcount = 0;
for(i=1;i<=num;i++){
if(document.all("isshows_"+i).checked == true){
showcount = showcount+1;
}
}
var arr = new Array(showcount);
for(i=1;i<=num;i++){
if(document.all("isshows_"+i).checked == true){
tempcount = tempcount + 1;
arr[tempcount] = document.all("dsporder_"+i).value;
}
}
for(i=1;i<=num;i++){
checkcount = 0;
if(document.all("isshows_"+i).checked == true){
ordervalue = document.all("dsporder_"+i).value;
 for(a=0;a<arr.length;a++){
   if(parseFloat(ordervalue) == parseFloat(arr[a])){
   checkcount = checkcount + 1;
   }
 }
 if(checkcount>1){
 	alert("<%=SystemEnv.getHtmlLabelName(23277,user.getLanguage())%>!");
  return false;
 }
}
}
return true;
}
<!-- Modified  by xwj on 20051031 for td2974 end -->




 
function onCheckShows(index)
{
   num=document.all("tmpcount1").value;
   if (num=="") num=0;
   num=parseInt(num)+1;
   if(document.all("isshows_" + index).checked == true){
	 document.all("dsporder_" + index).disabled = false;
     document.all("dsporder_" + index).value = num;
     document.all("tmpcount1").value=num;
  }
 else{
      
      document.all("dsporder_" + index).disabled = true;
      document.all("dsporder_" + index).value = "";
      
 }
}


function onCheckShow(index)
{
   num=document.all("tmpcount2").value;
   if (num=="") num=0;
   num=parseInt(num)+1;
   if(document.all("ifquery_" + index).checked == true){
      document.all("queryorder_" + index).disabled = false;
      document.all("queryorder_" + index).value = num;
      document.all("tmpcount2").value=num;
  }
 else{
      document.all("queryorder_" + index).disabled = true;
      document.all("queryorder_" + index).value = "";
 }
}

function checkDsporder(index){ 
     var dsporderValue;
     if(document.all("dsporder_" + index).value == ""){
        document.all("dsporder_" + index).value = "0";
     }
     else{
     checkdecimal_length(index,2);
     }
}

function checkCompositororder(index){
     if(document.all("compositororder_" + index).value == ""){
       document.all("compositororder_" + index).value = "0";
     }
     
}


function Count_KeyPress(name,index)
{
 if(!(window.event.keyCode>=48 && window.event.keyCode<=57)) 
  {
     window.event.keyCode=0;
  }
}

<!-- Modified  by xwj on 2005-06-06 for td2099 end -->
 
 
function bak(){
  document.forms[0].elements[i].enabled==false;
  alert(document.forms[0].elements[i].name.substringData(0,8));
}


<!-- Modified  by xwj on 20051026 for td2974 begin -->

function checkdecimal_length(index,maxlength)
{
	var  elementname = "dsporder_" + index;
	if(!isNaN(parseInt(document.all(elementname).value)) && (maxlength > 0)){
		inputTemp = document.all(elementname).value ;
		if (inputTemp.indexOf(".") !=-1)
		{
			inputTemp = inputTemp.substring(inputTemp.indexOf(".")+1,inputTemp.length);
		}
		if (inputTemp.length > maxlength)
		{
			var tempvalue = document.all(elementname).value;
			tempvalue = tempvalue.substring(0,tempvalue.length-inputTemp.length+maxlength);
			document.all(elementname).value = tempvalue;
		}
	}
}

function Count_KeyPress1(name,index)
{
 var elementname = name + index;
 tmpvalue = document.all(elementname).value;
 var count = 0;
 var len = -1;
 if(elementname){
 len = tmpvalue.length;
 }
 for(i = 0; i < len; i++){
    if(tmpvalue.charAt(i) == "."){
    count++;     
    }
 }
 if(!(((window.event.keyCode>=48) && (window.event.keyCode<=57)) || window.event.keyCode==46 || window.event.keyCode==45) || (window.event.keyCode==46 && count == 1))
  {  
     
     window.event.keyCode=0;
     
  }
}
<!-- Modified  by xwj on 20051026 for td2974 end -->


</script>
</BODY></HTML>
