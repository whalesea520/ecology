
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%

if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String id = Util.null2String(request.getParameter("id"));

String isBill = Util.null2String(request.getParameter("isBill"));

String formID = Util.null2String(request.getParameter("formID"));

String imagefilename = "/images/hdHRMCard_wev8.gif";
//自定义查询字段设置
String titlename = SystemEnv.getHtmlLabelName(20773,user.getLanguage())+SystemEnv.getHtmlLabelName(261,user.getLanguage())+SystemEnv.getHtmlLabelName(19653,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_top} " ;//保存
RCMenuHeight += RCMenuHeightStep;
%>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doback(),_top} " ;//返回
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=weaver name=frmMain action="/formmode/search/CustomSearchOperation.jsp" method=post>




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

  <TABLE class="viewform">
  
    <COLGROUP> 
    <COL width="10%"> 
    <COL width="10%">
    <COL width="10%"> 
    <COL width="10%">
    <COL width="20%">
    <COL width="10%">
    <COL width="15%">
    <COL width="15%">
    </COLGROUP>
    <TBODY> 
    <TR class="Title"> <!-- 自定义查询字段 -->
      <TH colSpan=8><%=SystemEnv.getHtmlLabelName(20773,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></TH>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line1" colSpan=8 ></TD>
    </TR>
    <tr class=Header> 
		<TD><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></TD><!-- 字段名称 -->
		<TD><%=SystemEnv.getHtmlLabelName(20779,user.getLanguage())%></TD><!-- 表头 -->
		<TD><%=SystemEnv.getHtmlLabelName(19501,user.getLanguage())%></TD><!-- 标题字段 -->
		<TD><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></TD><!-- 标题显示顺序 -->
		<!-- 是否排序/排序类型/排序关键字顺序 -->
		<td><%=SystemEnv.getHtmlLabelName(18558,user.getLanguage())%> / <%=SystemEnv.getHtmlLabelName(17736,user.getLanguage())%> / <%=SystemEnv.getHtmlLabelName(18559,user.getLanguage())%></td>
		<!-- 列宽 -->
		<TD><%=SystemEnv.getHtmlLabelName(19509,user.getLanguage())%>(<span id="colwidthspan1">0.00</span>%)</TD>
		<!-- 是否作为查询条件 -->
		<TD><%=SystemEnv.getHtmlLabelName(20778,user.getLanguage())%></TD>
		<!-- 查询显示顺序 -->
		<TD><%=SystemEnv.getHtmlLabelName(527,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></TD>
    </tr>
    <TR class="Spacing"  style="height:1px;"> 
      <TD class="Line" colSpan=8 ></TD>
    </TR>
    

  <%
    int tmpcount = 0;
	int tmpcount1 = 0;
    int tmpcount2 = 0;
    String isquery="";
	String isshows="";
	String istitles="";
    int dborder=-1;
    String dbordertype = "";
    int compositororder = 0;
    String dsporder="";
	String fieldname="";
	String fieldnamevalue="";
    String queryorder="";
    String colwidth = "";
    int isorder = -1;
    String ordertype="";
    int ordernum= -1;
    boolean isshow = false;
	for(int i = -1; i >-3; i--) 
	{
	isquery="";
	isshows = ""; 
	istitles = "";
	dsporder="";
    queryorder="";
    colwidth="";
    isorder = -1;
    ordertype="";
    ordernum= -1;
    isshow = false;
	tmpcount ++;
    rs.executeSql("select * from mode_CustomDspField where customid="+id+" and fieldid="+i+"  ");
    if(rs.next()){
      isquery=rs.getString("isquery");
	  isshows=rs.getString("isshow");
	  istitles=rs.getString("istitle");
      dsporder=rs.getString("showorder");
      colwidth=Util.null2String(rs.getString("colwidth"));
      if(!isshows.equals("1")){
    	  colwidth = "";
      }
	  if (tmpcount1<Util.getIntValue(dsporder))
			tmpcount1=Util.getIntValue(dsporder);
      queryorder=rs.getString("queryorder");
      if (tmpcount2<Util.getIntValue(queryorder))
			tmpcount2=Util.getIntValue(queryorder);
      isshow = true;
      isorder = rs.getInt("isorder");
      ordertype=rs.getString("ordertype");
      ordernum= rs.getInt("ordernum");
    }

	if("-2".equals(""+i))
	{
	fieldname=SystemEnv.getHtmlLabelName(882,user.getLanguage());//创建人
	fieldnamevalue="modedatacreater";
	}
	else if("-1".equals(""+i))
	{
	fieldname=SystemEnv.getHtmlLabelName(722,user.getLanguage());//创建日期
	fieldnamevalue="modedatacreatedate";
	}
  %>
  <TR>
      <TD>
      <%=fieldname%><%if (!fieldnamevalue.equals("")) {%>(<%=fieldnamevalue%>)<%}%>
      <input type="hidden" name='<%="fieldid_"+tmpcount%>' value="<%=i%>">
      <input type="hidden" name='<%="lable_"+tmpcount%>' value=<%=fieldname%>>
      </TD>
      <%String strtmpcount1 =(new Integer(tmpcount)).toString();%>

	  <td class=Field>
           <input type="checkbox" name='<%="isshows_"+tmpcount%>' onclick="onCheckShows(<%=strtmpcount1%>)"  value="1" <%if(isshows.equals("1")){%> checked <%}%> >
      </td>
	  <td class=Field>
           <input type="checkbox" name='<%="istitles_"+tmpcount%>' onclick="onCheckTitles(<%=strtmpcount1%>)"  value="1" <%if(istitles.equals("1")){%> checked <%}%> disabled>
      </td>
      <TD class=Field>
         <%if(isshows.equals("1")){%>
         <input type="text" onKeyPress="Count_KeyPress1('dsporder_',<%=strtmpcount1%>)" class=Inputstyle name='<%="dsporder_"+tmpcount%>' size="6" onblur="checkint('dsporder_<%=tmpcount%>')"  <%if(!"".equals(dsporder)){%> value=<%=dsporder%> <%}%>  >
         <%}
         else{%>
         <input type="text" onKeyPress="Count_KeyPress1('dsporder_',<%=strtmpcount1%>)" class=Inputstyle name='<%="dsporder_"+tmpcount%>' size="6" value="" disabled = "true" onblur="checkint('dsporder_<%=tmpcount%>')">
         <%}%>
      </TD>
      <td class=Field>
      <%
           if(isshow){
             %>
              <input type="checkbox" name='<%="isorder_"+tmpcount%>' value="1" onclick="onCheck(<%=strtmpcount1%>)"  <%if(isorder==1){%> checked <%}%>>
           <%}
           else{%>
               <input type="checkbox" name='<%="isorder_"+tmpcount%>' value="1" disabled="true" onclick="onCheck(<%=strtmpcount1%>)">
           <%}%>
    
           <select name='<%="ordertype_"+tmpcount%>' <%if((isorder != 1 && isshow == true) || isshow == false){%>disabled="true"<%}%>>
                    <option value="n" <%if(!"a".equals(ordertype) && !"d".equals(ordertype)){%>selected<%}%>>--</option>
					<option value="a" <%if("a".equals(ordertype)){%>selected<%}%>  ><%=SystemEnv.getHtmlLabelName(339,user.getLanguage())%> </option><!-- 升序 -->
				    <option value="d" <%if("d".equals(ordertype)){%>selected<%}%>  ><%=SystemEnv.getHtmlLabelName(340,user.getLanguage())%> </option><!-- 降序 -->
		   </select>
		   <input type="text" onKeyPress="Count_KeyPress('ordernum_',<%=strtmpcount1%>)" class=Inputstyle name='<%="ordernum_"+tmpcount%>' size="6" <%if((isorder!=1 && isshow == true) || isshow == false){%>value="" disabled="true"<%}else{%>value=<%=ordernum%><%}%> onblur="checkOrderNum(<%=strtmpcount1%>)">
      </td>
	  <td class=Field>
           <input type="text" name='<%="colwidth_"+tmpcount%>' size="6" onkeypress="ItemNum_KeyPress()" onblur="checknumber1(this);sumColWidth()" onchange="" maxlength="5"  value="<%=colwidth%>" <%if(!isshows.equals("1")){%> disabled <%}%>>%
      </td>
      <td class=Field>
           <input type="checkbox" name='<%="isquery_"+tmpcount%>' value="1" <%if(isquery.equals("1")){%> checked <%}%> onclick='onCheckShow(<%=strtmpcount1%>)' >
      </td>
      <TD class=Field>
         <%if(isquery.equals("1")){%>

         <input type="text" onKeyPress="Count_KeyPress1('queryorder_',<%=strtmpcount1%>)"  class=Inputstyle name='<%="queryorder_"+tmpcount%>' size="6"  onblur="checkint('queryorder_<%=tmpcount%>')" <%if(!"".equals(queryorder)){%> value=<%=queryorder%> <%}%> >
         <%}
         else{%>

         <input type="text" onKeyPress="Count_KeyPress1('queryorder_',<%=strtmpcount1%>)" class=Inputstyle name='<%="queryorder_"+tmpcount%>' size="6" value="" disabled = "true" onblur="checkint('queryorder_<%=tmpcount%>')">
         <%}%>
      </TD>
      

    </TR>
    <TR class="Spacing"  style="height:1px;"> 
      <TD class="Line" colSpan=8 ></TD>
    </TR>
    
<%}%>

<%
int linecolor=0;
String sql = "select workflow_billfield.id as id,workflow_billfield.fieldname as name,workflow_billfield.fieldlabel as label,workflow_billfield.fielddbtype as dbtype ,workflow_billfield.fieldhtmltype as httype, workflow_billfield.type as type from workflow_billfield where workflow_billfield.billid="+formID+"  and (viewtype='0') order by dsporder";
rs.executeSql(sql);
while(rs.next()){
tmpcount ++;
String fieldid = rs.getString("id"); 
String label = rs.getString("label");
String dbtype= rs.getString("dbtype");
String httype= rs.getString("httype");
String cansettitles = "disabled";
if(httype.equals("1")||httype.equals("5")){
	cansettitles = "";
}
label = SystemEnv.getHtmlLabelName(Util.getIntValue(label),user.getLanguage());
isquery="";
isshows = "";
istitles = "";
dsporder="";
queryorder="";
colwidth="";
isorder = -1;
ordertype="";
ordernum= -1;
isshow = false;
rs1.executeSql("select * from mode_CustomDspField where customid="+id+" and fieldid="+fieldid);
if(rs1.next()){
	isquery=rs1.getString("isquery");
	dsporder=rs1.getString("showorder");
	isshows=rs1.getString("isshow");
	istitles=rs1.getString("istitle");
	queryorder=rs1.getString("queryorder");
	colwidth=rs1.getString("colwidth");
    if(!isshows.equals("1")){
		colwidth = "";
    }
	if (tmpcount1<Util.getIntValue(dsporder))
	tmpcount1=Util.getIntValue(dsporder);
	queryorder=rs1.getString("queryorder");
	if (tmpcount2<Util.getIntValue(queryorder)){
		tmpcount2=Util.getIntValue(queryorder);
	}
	isshow = true;
    isorder = rs1.getInt("isorder");
    ordertype=rs1.getString("ordertype");
    ordernum= rs1.getInt("ordernum");
}

%>

    <TR> 
      <TD><%=label%>(<%=rs.getString("name")%>)
      <input type="hidden" name='<%="fieldid_"+tmpcount%>' value=<%=fieldid%>>
      <input type="hidden" name='<%="lable_"+tmpcount%>' value=<%=label%>>
      </TD>
      <%String strtmpcount =(new Integer(tmpcount)).toString();%>
     
      <td class=Field>
           <input type="checkbox" name='<%="isshows_"+tmpcount%>' onclick="onCheckShows(<%=strtmpcount%>)" value="1" <%if(isshows.equals("1")){%> checked <%}%> >
      </td>
      <td class=Field>
           <input type="checkbox" name='<%="istitles_"+tmpcount%>' onclick="onCheckTitles(<%=strtmpcount%>)" value="1" <%if(istitles.equals("1")){%> checked <%}%> <%=cansettitles%>>
      </td>
      <TD class=Field>
         <%if(isshows.equals("1")){%>

         <input type="text" onKeyPress="Count_KeyPress1('dsporder_',<%=strtmpcount%>)"  class=Inputstyle name='<%="dsporder_"+tmpcount%>' size="6"  onblur="checkint('dsporder_<%=tmpcount%>')" <%if(!"".equals(dsporder)){%> value=<%=dsporder%> <%}%> >
         <%}
         else{%>

         <input type="text" onKeyPress="Count_KeyPress1('dsporder_',<%=strtmpcount%>)" class=Inputstyle name='<%="dsporder_"+tmpcount%>' size="6" value="" disabled = "true" onblur="checkint('dsporder_<%=tmpcount%>')">
         <%}%>
      </TD>
      <td class=Field>
      <%
      if(!(dbtype.equals("text") || dbtype.equals("ntext") || dbtype.equals("image"))){
           if(isshow){
             %>
              <input type="checkbox" name='<%="isorder_"+tmpcount%>' value="1" onclick="onCheck(<%=strtmpcount%>)"  <%if(isorder==1){%> checked <%}%>>
           <%}
           else{%>
               <input type="checkbox" name='<%="isorder_"+tmpcount%>' value="1" disabled="true" onclick="onCheck(<%=strtmpcount%>)">
           <%}%>
    
           <select name='<%="ordertype_"+tmpcount%>' <%if((isorder != 1 && isshow == true) || isshow == false){%>disabled="true"<%}%>>
                    <option value="n" <%if(!"a".equals(ordertype) && !"d".equals(ordertype)){%>selected<%}%>>--</option>
					<option value="a" <%if("a".equals(ordertype)){%>selected<%}%>  ><%=SystemEnv.getHtmlLabelName(339,user.getLanguage())%> </option><!-- 升序 -->
				    <option value="d" <%if("d".equals(ordertype)){%>selected<%}%>  ><%=SystemEnv.getHtmlLabelName(340,user.getLanguage())%> </option><!-- 降序 -->
		   </select>
		   <input type="text" onKeyPress="Count_KeyPress('ordernum_',<%=strtmpcount%>)" class=Inputstyle name='<%="ordernum_"+tmpcount%>' size="6" <%if((isorder!=1 && isshow == true) || isshow == false){%>value="" disabled="true"<%}else{%>value=<%=ordernum%><%}%> onblur="checkOrderNum(<%=strtmpcount%>)">
	 <%}else{ %>
	  <input type="checkbox" name='<%="isorder_"+tmpcount%>' value="1" style="visibility:hidden">
	  <select name='<%="ordertype_"+tmpcount%>'  style="visibility:hidden"><option value="n">--</option></select>
	  <input type="text" onKeyPress="Count_KeyPress('compositororder_',<%=strtmpcount%>)" class=Inputstyle name='<%="ordernum_"+tmpcount%>' size="6" value="" style="visibility:hidden" onblur="checkCompositororder(<%=strtmpcount%>)">
	 <%} %>
      </td>
	  <td class=Field>
           <input type="text" name='<%="colwidth_"+tmpcount%>' size="6" onkeypress="ItemNum_KeyPress()" onblur="checknumber1(this);sumColWidth()" onchange="" maxlength="5"  value="<%=colwidth%>" <%if(!isshows.equals("1")){%> disabled <%}%>>%
      </td>
      <td class=Field>
           <input type="checkbox" name='<%="isquery_"+tmpcount%>'  value="1" <%if(isquery.equals("1")){%> checked <%}%>  onclick='onCheckShow(<%=strtmpcount%>)'>
      </td>
      
      <TD class=Field>
         <%if(isquery.equals("1")){%>
        
         <input type="text" onKeyPress="Count_KeyPress1('queryorder_',<%=strtmpcount%>)"  class=Inputstyle name='<%="queryorder_"+tmpcount%>' size="6"  onblur="checkint('queryorder_<%=tmpcount%>')" <%if(!"".equals(queryorder)){%> value=<%=queryorder%> <%}%> >
         <%}
         else{%>
        
         <input type="text" onKeyPress="Count_KeyPress1('queryorder_',<%=strtmpcount%>)" class=Inputstyle name='<%="queryorder_"+tmpcount%>' size="6" value="" disabled = "true" onblur="checkint('queryorder_<%=tmpcount%>')">
         <%}%>
      </TD>
    </TR>
    <TR class="Spacing"  style="height:1px;"> 
      <TD class="Line" colSpan=8 ></TD>
    </TR>
    
 
     
<% } %>

    <tr class=Header> 
		<TD><%=SystemEnv.getHtmlLabelName(358,user.getLanguage())%></TD><!-- 合计 -->
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD><span id="colwidthspan2">0.00</span>%</TD>
		<TD></TD>
		<TD></TD>
    </tr>
    <TR class="Spacing"  style="height:1px;"> 
      <TD class="Line" colSpan=8 ></TD>
    </TR>

  <input type="hidden" name=operation value=formfieldadd>
  <input type="hidden" name=id value=<%=id%>>
  <input type="hidden" name=tmpcount value=<%=tmpcount%>>
  <input type="hidden" name=tmpcount1 value=<%=tmpcount1%>>
  <input type="hidden" name=tmpcount2 value=<%=tmpcount2%>>
    </TBODY> 
  </TABLE>
  
		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

 </form>

<script language="javascript">
function onCheck(index)
{
   if(document.all("isorder_" + index).checked == true){
      document.all("ordertype_" + index).disabled = false;
      document.all("ordertype_" + index).selectedIndex = 1;
      document.all("ordernum_" + index).disabled = false;
      document.all("ordernum_" + index).value = "0";
	} else {
      document.all("ordertype_" + index).disabled = true;
      document.all("ordertype_" + index).selectedIndex = 0;
      document.all("ordernum_" + index).disabled = true;
      document.all("ordernum_" + index).value = "";
	}
}

function checkOrderNum(index){
	if(document.getElementById("ordernum_" + index).value == ""){
		document.getElementById("ordernum_" + index).value = "0";
	}
}

function submitData()
{    
	len = document.forms[0].elements.length;
	var i=0;
	var index;
	var selectName;
	var checkName;
	var lableName; 
	var compositororderName;
	var rowsum1 = 0;
	if(checkSame()){
		enableAllmenu();
		frmMain.submit();
	}
}

function doback(){
    enableAllmenu();
    location.href="/formmode/search/CustomSearchEdit.jsp?id=<%=id%>";
}

function checkSame(){
	var num = <%=tmpcount%>;
	var showcount = 0;
	var ordervalue = "";
	var tempcount = -1;
	var checkcount = 0;
	for(i=1;i<=num;i++){
		if(document.getElementById("isshows_"+i).checked == true){
			showcount = showcount+1;
		}
	}
	var arr = new Array(showcount);
	for(i=1;i<=num;i++){
		if(document.getElementById("isshows_"+i).checked == true){
			tempcount = tempcount + 1;
			arr[tempcount] = document.getElementById("dsporder_"+i).value;
		}
	}
	for(i=1;i<=num;i++){
		checkcount = 0;
		if(document.getElementById("isshows_"+i).checked == true){
			ordervalue = document.getElementById("dsporder_"+i).value;
		 	for(a=0;a<arr.length;a++){
				if(parseFloat(ordervalue) == parseFloat(arr[a])){
		   			checkcount = checkcount + 1;
				}
		 	}
			if(checkcount>1){
				alert("<%=SystemEnv.getHtmlLabelName(23277,user.getLanguage())%>!");//您填写的显示顺序有重复数字
				return false;
			}
		}
	}

	//有些列表可以没有标题
	/*
	var havetitle = false;
	for(var i=0;i<="<%=tmpcount%>";i++){
		if(document.getElementById("istitles_" + i) && document.getElementById("istitles_" + i).checked == true){
			havetitle = true;
			break;
		}
	}
	if(!havetitle){
		alert("<%=SystemEnv.getHtmlLabelName(28501,user.getLanguage())%>");//必须设置一个标题字段！
		return false;
	}
	*/

	//检查列宽总和是否大于100，或者列宽存在0的。
	var msg = "";
	var SumColWidth = sumColWidth();

	var havezero = false;
	for(var i=0;i<="<%=tmpcount%>";i++){
		var obj = document.getElementById("ColWidth_" + i);
		if(obj!=null&&(document.getElementById("isshows_"+i).checked == true)){
			if(obj.value==""||getFloatValue(obj.value)=="0"){
				
				havezero = true;
			}
		}
	}

	var adjustment = false;
	if(SumColWidth*1.0>100){
		if(havezero){
			adjustment = confirm("<%=SystemEnv.getHtmlLabelName(31215,user.getLanguage())%>");//存在列宽设置为0的列，并且列宽总和大于100，请确认是否进行调整？
		}else{
			adjustment = confirm("<%=SystemEnv.getHtmlLabelName(31216,user.getLanguage())%>");//列宽总和大于100，请确认是否进行调整？
		}
	}else{
		if(havezero){
			adjustment = confirm("<%=SystemEnv.getHtmlLabelName(31217,user.getLanguage())%>");//存在列宽设置为0的列，请确认是否进行调整？
		}
	}
	if(adjustment){
		return false;
	}
	
	return true;
}

function sumColWidth(){
	var num = <%=tmpcount%>;
	var sumwidth = 0;
	for(var i=0;i<=num;i++){
		var obj = document.getElementById("ColWidth_" + i);
		if(obj!=null){
			if(obj.value!=""){
				sumwidth = sumwidth + getFloatValue(obj.value);
			}
		}
	}
	var strSumWidth = sumwidth.toFixed(2);
	document.getElementById("colwidthspan1").innerHTML = strSumWidth;
	document.getElementById("colwidthspan2").innerHTML = strSumWidth;
	return strSumWidth;
}

function getFloatValue(obj){
	try{
		return parseFloat(obj);
	}catch(e){
		return 0;
	}
}
 
function onCheckShows(index)
{
	num=document.getElementById("tmpcount1").value;
	if (num=="") num=0;
	num=parseInt(num)+1;
	if(document.getElementById("isshows_" + index).checked == true){
		document.getElementById("dsporder_" + index).disabled = false;
		document.getElementById("dsporder_" + index).value = num;
		document.getElementById("tmpcount1").value=num;
		document.getElementById("colwidth_" + index).disabled = false;
	} else {
		document.getElementById("dsporder_" + index).disabled = true;
		document.getElementById("dsporder_" + index).value = "";
		document.getElementById("istitles_" + index).checked = false;
		document.getElementById("colwidth_" + index).disabled = true;
		document.getElementById("colwidth_" + index).value = "";
	}
	sumColWidth();
}
function onCheckTitles(index)
{
	num=document.getElementById("tmpcount1").value;
	if (num=="") num=0;
	num=parseInt(num)+1;
	if(document.getElementById("isshows_" + index).checked == true){

	} else {
		document.getElementById("isshows_" + index).checked = true
		document.getElementById("dsporder_" + index).disabled = false;
		document.getElementById("dsporder_" + index).value = num;
		document.getElementById("tmpcount1").value=num;
		document.getElementById("colwidth_" + index).disabled = false;
      
	}
	if(document.getElementById("istitles_" + index).checked == true){
		for(var i=0;i<="<%=tmpcount%>";i++){
			if(document.getElementById("istitles_" + i) && i!= index){
				document.getElementById("istitles_" + i).checked = false;
			}
		}
	}
}


function onCheckShow(index)
{
	num=document.getElementById("tmpcount2").value;
	if (num=="") num=0;
	num=parseInt(num)+1;
	if(document.getElementById("isquery_" + index).checked == true){
		document.getElementById("queryorder_" + index).disabled = false;
		document.getElementById("queryorder_" + index).value = num;
		document.getElementById("tmpcount2").value=num;
	} else {
		document.getElementById("queryorder_" + index).disabled = true;
		document.getElementById("queryorder_" + index).value = "";
	}
}

function checkDsporder(index){ 
	var dsporderValue;
	if(document.getElementById("dsporder_" + index).value == ""){
		document.getElementById("dsporder_" + index).value = "0";
	} else {
		checkdecimal_length(index,2);
	}
}

function checkCompositororder(index){
	if(document.getElementById("compositororder_" + index).value == ""){
		document.getElementById("compositororder_" + index).value = "0";
	}
}


function Count_KeyPress(name,index)
{
	if(!(window.event.keyCode>=48 && window.event.keyCode<=57)) 
	{
	    window.event.keyCode=0;
	}
}

function checkdecimal_length(index,maxlength)
{
	var  elementname = "dsporder_" + index;
	if(!isNaN(parseInt(document.getElementById(elementname).value)) && (maxlength > 0)){
		inputTemp = document.getElementById(elementname).value ;
		if (inputTemp.indexOf(".") !=-1)
		{
			inputTemp = inputTemp.substring(inputTemp.indexOf(".")+1,inputTemp.length);
		}
		if (inputTemp.length > maxlength)
		{
			var tempvalue = document.getElementById(elementname).value;
			tempvalue = tempvalue.substring(0,tempvalue.length-inputTemp.length+maxlength);
			document.getElementById(elementname).value = tempvalue;
		}
	}
}

function Count_KeyPress1(name,index)
{
	var elementname = name + index;
	tmpvalue = document.getElementById(elementname).value;
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

function checknumber1(objectname)
{
	valuechar = objectname.value.split("") ;
	isnumber = false ;
	var hasdian = false;
	for(i=0 ; i<valuechar.length ; i++) {
		charnumber = parseInt(valuechar[i]) ; 
		if(isNaN(charnumber)&& valuechar[i]!="."){
			isnumber = true ;
		}
		if((valuechar[i]=="."&&i==0&&hasdian==false)||(valuechar[i]=="-"&&i>0)){
			isnumber = true ;
		}
		if(valuechar[i]=="."){
			hasdian = true;
		}
		if (valuechar.length==1 && valuechar[i]=="-"){
		    isnumber = true ;
		}
		if(isnumber){
			break;
		}
	}
	if(isnumber){
		objectname.value = "" ;
	}
}

jQuery(document).ready(function(){
	sumColWidth();
});

</script>
</BODY></HTML>
