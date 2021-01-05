
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%
/* if(!HrmUserVarify.checkUserRight("HrmProvinceAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	} */
%>
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
String sql = "";
sql = "select a.*,b.modename,b.formid from mode_Report a,modeinfo b where a.modeid = b.id and a.id = " + id;
rs.executeSql(sql);
rs.next();
String reportname = Util.toScreen(rs.getString("reportname"),user.getLanguage()) ;
String reportdesc = Util.toScreen(rs.getString("reportdesc"),user.getLanguage()) ;
String formID = Util.null2String(rs.getString("formID"));
String modename = Util.null2String(rs.getString("modename"));
String modeid = Util.null2String(rs.getString("modeid"));

String imagefilename = "/images/hdHRMCard_wev8.gif";
//报表:报表显示项编辑
String titlename = SystemEnv.getHtmlLabelName(15101,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(30539,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_top} " ;//保存
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/formmode/report/ReportEdit.jsp?id="+id+",_top} " ;//返回
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=weaver name=frmMain action="ReportOperation.jsp" method=post>
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
  
    <COLGROUP> <COL width="28%"> <COL width="14%"> <COL width="14%"> <COL width="30%"> <COL width="14%"><TBODY> 
    <TR class="Title"> 
      <TH colSpan=5><%=SystemEnv.getHtmlLabelName(15510,user.getLanguage())%></TH><!-- 报表显示项 -->
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line1" colSpan=5 ></TD>
    </TR>
    <tr class=Header> 
      <td><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></td><!-- 字段名称 -->
      <td><%=SystemEnv.getHtmlLabelName(15603,user.getLanguage())%></td><!-- 是否显示 -->
      <td><%=SystemEnv.getHtmlLabelName(15511,user.getLanguage())%></td><!-- 是否统计 -->
      <!-- 是否排序/排序类型/排序关键字顺序 -->
      <td><%=SystemEnv.getHtmlLabelName(18558,user.getLanguage())%> / <%=SystemEnv.getHtmlLabelName(17736,user.getLanguage())%> / <%=SystemEnv.getHtmlLabelName(18559,user.getLanguage())%></td>
      <td><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></td><!-- 显示顺序 -->
    </tr>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=5 ></TD>
    </TR>
  <%
	int tmpcount = 0;
	tmpcount += 1;
	boolean isshow=false;
	int isstat=-1;
	int dborder=-1;
	String dbordertype = "";
	int compositororder = 0;
	String dsporder="";
    rs.executeSql("select * from mode_ReportDspField where reportid="+id+" and fieldid=-1");
    if(rs.next()){
      isshow=true;
      isstat=rs.getInt("isstat");
      dborder=rs.getInt("dborder");
      dsporder=rs.getString("dsporder");
      if(!"".equals(rs.getString("dbordertype"))){
       dbordertype=rs.getString("dbordertype");
      }
      if(rs.getInt("compositororder") != -1){
       compositororder = rs.getInt("compositororder");
      }
    
    }
  %>
  <TR>
      <TD>
      <%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%>(modedatacreatedate)<!-- 创建日期 -->
      <input type="hidden" name='<%="fieldid_"+tmpcount%>' value="-1">
      <input type="hidden" name='<%="lable_"+tmpcount%>' value=<%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%>><!-- 请求标题 -->
      </TD>
      <%String strtmpcount1 =(new Integer(tmpcount)).toString();%>
      <td class=Field>
        <input type="checkbox" name='<%="isshow_"+tmpcount%>' value="1" <%if(isshow){%> checked <%}%> onclick="onCheckShow(<%=strtmpcount1%>)">
      </td>
      <td class=Field>
           <input type="checkbox" name='<%="isstat_"+tmpcount%>' value="1" style="visibility:hidden">
      </td>
      <td class=Field>
      <%
           if(isshow){
             %>
              <input type="checkbox" name='<%="dborder_"+tmpcount%>' value="1" onclick="onCheck(<%=strtmpcount1%>)"  <%if(dborder==1){%> checked <%}%>>
           <%}
           else{%>
               <input type="checkbox" name='<%="dborder_"+tmpcount%>' value="1" disabled="true" onclick="onCheck(<%=strtmpcount1%>)">
           <%}%>
    
           <select name='<%="dbordertype_"+tmpcount%>' <%if((dborder != 1 && isshow == true) || isshow == false){%>disabled="true"<%}%>>
                    <option value="n" <%if(!"a".equals(dbordertype) && !"d".equals(dbordertype)){%>selected<%}%>>--</option>
						        <option value="a" <%if("a".equals(dbordertype)){%>selected<%}%>  ><%=SystemEnv.getHtmlLabelName(339,user.getLanguage())%> </option><!-- 升序 -->
				            <option value="d" <%if("d".equals(dbordertype)){%>selected<%}%>  ><%=SystemEnv.getHtmlLabelName(340,user.getLanguage())%> </option><!-- 降序 -->
			             </select>
			       
			     <input type="text" onKeyPress="Count_KeyPress('compositororder_',<%=strtmpcount1%>)" class=Inputstyle name='<%="compositororder_"+tmpcount%>' size="6" <%if((dborder!=1 && isshow == true) || isshow == false){%>value="" disabled="true"<%}else{%>value=<%=compositororder%><%}%> onblur="checkCompositororder(<%=strtmpcount1%>)">
      </td>
      
      <TD class=Field>
         <%if(isshow){%>
         <input type="text" onKeyPress="Count_KeyPress1('dsporder_',<%=strtmpcount1%>)" class=Inputstyle name='<%="dsporder_"+tmpcount%>' size="6" <%if(!"".equals(dsporder)){%> value=<%=dsporder%> <%}%>  onblur="checkDsporder(<%=strtmpcount1%>)">
         <%}
         else{%>
         <input type="text" onKeyPress="Count_KeyPress1('dsporder_',<%=strtmpcount1%>)" class=Inputstyle name='<%="dsporder_"+tmpcount%>' size="6" value="" disabled = "true" onblur="checkDsporder(<%=strtmpcount1%>)">
         <%}%>
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>
    
    
    <%
	tmpcount += 1;
	isshow=false;
	isstat=-1;
	dborder=-1;
	dbordertype = "";
	compositororder = 0;
	dsporder="";
	rs.executeSql("select * from mode_ReportDspField where reportid="+id+" and fieldid=-2");
    
    
    
    if(rs.next()){
      isshow=true;
      isstat=rs.getInt("isstat");
      dborder=rs.getInt("dborder");
      dsporder=rs.getString("dsporder");
      if(!"".equals(rs.getString("dbordertype"))){
       dbordertype=rs.getString("dbordertype");
      }
      if(rs.getInt("compositororder") != -1){
       compositororder = rs.getInt("compositororder");
      }
    
    }
  %>
  <TR> 
      <TD>
      <%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%>(modedatacreater)<!-- 创建人 -->
      <input type="hidden" name='<%="fieldid_"+tmpcount%>' value="-2">
      <input type="hidden" name='<%="lable_"+tmpcount%>' value=<%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%>><!-- 紧急程度 -->
      </TD>
      <%strtmpcount1 =(new Integer(tmpcount)).toString();%>
      <td class=Field>
        <input type="checkbox" name='<%="isshow_"+tmpcount%>' value="1" <%if(isshow){%> checked <%}%> onclick="onCheckShow(<%=strtmpcount1%>)">
      </td>
      <td class=Field>
         <input type="checkbox" name='<%="isstat_"+tmpcount%>' value="1" style="visibility:hidden">
      </td>
      <td class=Field>
      <%
           if(isshow){
             %>
              <input type="checkbox" name='<%="dborder_"+tmpcount%>' value="1" onclick="onCheck(<%=strtmpcount1%>)"  <%if(dborder==1){%> checked <%}%>>
           <%}
           else{%>
               <input type="checkbox" name='<%="dborder_"+tmpcount%>' value="1" disabled="true" onclick="onCheck(<%=strtmpcount1%>)">
           <%}%>
    
           <select name='<%="dbordertype_"+tmpcount%>' <%if((dborder != 1 && isshow == true) || isshow == false){%>disabled="true"<%}%>>
                    <option value="n" <%if(!"a".equals(dbordertype) && !"d".equals(dbordertype)){%>selected<%}%>>--</option>
						        <option value="a" <%if("a".equals(dbordertype)){%>selected<%}%>  ><%=SystemEnv.getHtmlLabelName(339,user.getLanguage())%> </option><!-- 升序 -->
				            <option value="d" <%if("d".equals(dbordertype)){%>selected<%}%>  ><%=SystemEnv.getHtmlLabelName(340,user.getLanguage())%> </option><!-- 降序 -->
			             </select>
			       
			     <input type="text" onKeyPress="Count_KeyPress('compositororder_',<%=strtmpcount1%>)" class=Inputstyle name='<%="compositororder_"+tmpcount%>' size="6" <%if((dborder!=1 && isshow == true) || isshow == false){%>value="" disabled="true"<%}else{%>value=<%=compositororder%><%}%> onblur="checkCompositororder(<%=strtmpcount1%>)">
      </td>
      
      <TD class=Field>
         <%if(isshow){%>
         <input type="text" onKeyPress="Count_KeyPress1('dsporder_',<%=strtmpcount1%>)" class=Inputstyle name='<%="dsporder_"+tmpcount%>' size="6" <%if(!"".equals(dsporder)){%> value=<%=dsporder%> <%}%>  onblur="checkDsporder(<%=strtmpcount1%>)">
         <%}
         else{%>
         <input type="text" onKeyPress="Count_KeyPress1('dsporder_',<%=strtmpcount1%>)" class=Inputstyle name='<%="dsporder_"+tmpcount%>' size="6" value="" disabled = "true" onblur="checkDsporder(<%=strtmpcount1%>)">
         <%}%>
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>
    
<%----------    xwj for td2974 20051026     E N D   -----------%>

<%
int linecolor=0;
sql = "select workflow_billfield.id as id,workflow_billfield.fieldname as name,workflow_billfield.fieldlabel as label,workflow_billfield.fielddbtype as dbtype ,workflow_billfield.fieldhtmltype as httype, workflow_billfield.type as type,workflow_billfield.viewtype as viewtype from workflow_billfield where workflow_billfield.billid="+formID+" order by dsporder";
rs.executeSql(sql);
while(rs.next()){
tmpcount += 1;
String fieldid = rs.getString("id"); 
String label = rs.getString("label");
String dbtype= rs.getString("dbtype");
label = SystemEnv.getHtmlLabelName(Util.getIntValue(label),user.getLanguage());
int viewtype = Util.getIntValue(rs.getString("viewtype"),0);
if(viewtype == 1) label += "("+SystemEnv.getHtmlLabelName(17463,user.getLanguage())+")";
isshow=false;
isstat=-1;
dborder=-1;
dbordertype = ""; 
compositororder = 0; 
dsporder="";
rs1.executeSql("select * from mode_ReportDspField where reportid="+id+" and fieldid="+fieldid);
if(rs1.next()){
	isshow=true;
	isstat=rs1.getInt("isstat");
	dborder=rs1.getInt("dborder");
	dsporder=rs1.getString("dsporder");
	if(!"".equals(rs1.getString("dbordertype"))){
		dbordertype=rs1.getString("dbordertype");
	}
	if(rs1.getInt("compositororder") != -1){
	    compositororder = rs1.getInt("compositororder");
	}
}

%>

    <TR> 
      <TD>
      <%=label%>
      (<%=rs.getString("name")%>)
      <input type="hidden" name='<%="fieldid_"+tmpcount%>' value=<%=fieldid%>>
      <input type="hidden" name='<%="lable_"+tmpcount%>' value=<%=label%>> 
      </TD>
      <%String strtmpcount =(new Integer(tmpcount)).toString();%>
      <td class=Field>
        <input type="checkbox" name='<%="isshow_"+tmpcount%>' value="1" <%if(isshow){%> checked <%}%> onclick="onCheckShow(<%=strtmpcount%>)">
      </td>
      <td class=Field>
		<%
			if("1".equals(rs.getString("httype")) && ( "2".equals(rs.getString("type"))||"3".equals(rs.getString("type"))||"4".equals(rs.getString("type")) )){
	     		if(isshow){
		%>
					<input type="checkbox" name='<%="isstat_"+tmpcount%>' value="1" <%if(isstat==1){%> checked <%}%> >
		<%
				} else {
		%>
					<input type="checkbox" name='<%="isstat_"+tmpcount%>' value="1" disabled="true">
		<%
				}
	  		} else {
		%>
				<input type="checkbox" name='<%="isstat_"+tmpcount%>' value="1" style="visibility:hidden">
		<%
			}
		%>
      </td>
      <td class=Field>
      
        <%
        if(!(dbtype.equals("text") || dbtype.equals("ntext") || dbtype.equals("image"))){
           if(isshow){
             %>
              <input type="checkbox" name='<%="dborder_"+tmpcount%>' value="1" onclick="onCheck(<%=strtmpcount%>)"  <%if(dborder==1){%> checked <%}%>>
           <%}
           else{%>
               <input type="checkbox" name='<%="dborder_"+tmpcount%>' value="1" disabled="true" onclick="onCheck(<%=strtmpcount%>)">
           <%}
        }
        else{%>
              <input type="checkbox" name='<%="dborder_"+tmpcount%>' value="1" style="visibility:hidden">
          
           <%}%>
         
        <%
          if(!(dbtype.equals("text") || dbtype.equals("ntext") || dbtype.equals("image"))){%>
            
                   <select name='<%="dbordertype_"+tmpcount%>' <%if((dborder != 1 && isshow == true) || isshow == false){%>disabled="true"<%}%>>
                    <option value="n" <%if(!"a".equals(dbordertype) && !"d".equals(dbordertype)){%>selected<%}%>>--</option>
						        <option value="a" <%if("a".equals(dbordertype)){%>selected<%}%>  ><%=SystemEnv.getHtmlLabelName(339,user.getLanguage())%> </option><!-- 升序 -->
				            <option value="d" <%if("d".equals(dbordertype)){%>selected<%}%>  ><%=SystemEnv.getHtmlLabelName(340,user.getLanguage())%> </option><!-- 降序 -->
			             </select>
			        
			    <%}
			    else{%>
			     <select name='<%="dbordertype_"+tmpcount%>'  style="visibility:hidden">
                 <option value="n">--</option>
			     </select>
			    <%}%>
			    
			     <%
            if(!(dbtype.equals("text") || dbtype.equals("ntext") || dbtype.equals("image"))){%>
          
              <input type="text" onKeyPress="Count_KeyPress('compositororder_',<%=strtmpcount%>)" class=Inputstyle name='<%="compositororder_"+tmpcount%>' size="6" <%if((dborder!=1 && isshow == true) || isshow == false){%>value="" disabled="true"<%}else{%>value=<%=compositororder%><%}%> onblur="checkCompositororder(<%=strtmpcount%>)">
            <%}
            else{%>
              <input type="text" onKeyPress="Count_KeyPress('compositororder_',<%=strtmpcount%>)" class=Inputstyle name='<%="compositororder_"+tmpcount%>' size="6" value="" style="visibility:hidden" onblur="checkCompositororder(<%=strtmpcount%>)">
             
            <%}%>
       
      </td>
      
      <TD class=Field>
         <%if(isshow){%>
         <%--Modefied  by xwj on 20051026 for td2974--%>
         <input type="text" onKeyPress="Count_KeyPress1('dsporder_',<%=strtmpcount%>)"  class=Inputstyle name='<%="dsporder_"+tmpcount%>' size="6" <%if(!"".equals(dsporder)){%> value=<%=dsporder%> <%}%>  onblur="checkDsporder(<%=strtmpcount%>)">
         <%}
         else{%>
         <%--Modefied  by xwj on 20051026 for td2974--%>
         <input type="text" onKeyPress="Count_KeyPress1('dsporder_',<%=strtmpcount%>)" class=Inputstyle name='<%="dsporder_"+tmpcount%>' size="6" value="" disabled = "true" onblur="checkDsporder(<%=strtmpcount%>)">
         <%}%>
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>
<% } %>

  <input type="hidden" name=operation value=formfieldadd>
	<input type="hidden" name=reportid value=<%=id%>>
  <input type="hidden" name=tmpcount value=<%=tmpcount%>>
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
		for(i=len-1; i >= 0;i--) {
			if (document.forms[0].elements[i].name.substring(0,8)=='dborder_'){
			    index = document.forms[0].elements[i].name.substring(8,document.forms[0].elements[i].name.length);
			    checkName = "dborder_" + index;
			    selectName = "dbordertype_" + index;
			    lableName = "lable_" + index;
			    compositororderName = "compositororder_" + index;
				if(document.all(checkName).checked == true){
		        	if(document.all(selectName).value=="n"){
		        		alert ("[" + document.all(lableName).value + "] <%=SystemEnv.getHtmlLabelName(23276,user.getLanguage())%>!");//字段的“排序类型”未选择
		          		submit = false;
		          		break;
					}
		    	}
			}
		}
		if(submit == true){
	   		if(checkSame()){
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
		if(document.all("isshow_"+i).checked == true){
			showcount = showcount+1;
		}
	}
	var arr = new Array(showcount);
	for(i=1;i<=num;i++){
		if(document.all("isshow_"+i).checked == true){
			tempcount = tempcount + 1;
			arr[tempcount] = document.all("dsporder_"+i).value;
		}
	}
	for(i=1;i<=num;i++){
		checkcount = 0;
		if(document.all("isshow_"+i).checked == true){
			ordervalue = document.all("dsporder_"+i).value;
			for(a=0;a<arr.length;a++){
				if(parseFloat(ordervalue) == parseFloat(arr[a])){
					checkcount = checkcount + 1;
				}
			}
			if(checkcount>1){
				alert("<%=SystemEnv.getHtmlLabelName(23277,user.getLanguage()) %>!");//您填写的显示顺序有重复数字
				return false;
			}
		}
	}
	return true;
}

function selectType(index){
	if(document.all("dbordertype_" + index).value == "a" || document.all("dbordertype_" + index).value == "d"){
		document.all("dborder_" + index).checked = true;
	} else {
		document.all("dborder_" + index).checked = false;
	}
}
 
function onCheck(index)
{
   if(document.all("dborder_" + index).checked == true){
      document.all("dbordertype_" + index).disabled = false;
      document.all("dbordertype_" + index).selectedIndex = 0;
      document.all("compositororder_" + index).disabled = false;
      document.all("compositororder_" + index).value = "0";
	} else {
      document.all("dbordertype_" + index).disabled = true;
      document.all("dbordertype_" + index).selectedIndex = 0;
      document.all("compositororder_" + index).disabled = true;
      document.all("compositororder_" + index).value = "";
	}
}

function onCheckShow(index)
{
   if(document.all("isshow_" + index).checked == true){
      document.all("isstat_" + index).disabled = false;
      document.all("dborder_" + index).disabled = false;
      document.all("dsporder_" + index).disabled = false;
      document.all("dsporder_" + index).value = "0";
	} else {
      document.all("dborder_" + index).disabled = true;
      document.all("dborder_" + index).checked = false;
      document.all("dbordertype_" + index).disabled = true;
      document.all("dbordertype_" + index).selectedIndex = 0;
      document.all("compositororder_" + index).disabled = true;
      document.all("compositororder_" + index).value = "";
      document.all("isstat_" + index).disabled = true;
      document.all("isstat_" + index).checked = false;
      document.all("dsporder_" + index).disabled = true;
      document.all("dsporder_" + index).value = "";
	}
}

function checkDsporder(index){ //Modified  by xwj on 20051026 for td2974
     var dsporderValue;
     if(document.all("dsporder_" + index).value == ""){
        document.all("dsporder_" + index).value = "0.00";
     } else {
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

</script>
</BODY></HTML>
