<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetFF" class="weaver.conn.RecordSet" scope="page" />
<script type="text/javascript" language="javascript" src="/FCKEditor/fckeditor_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt_wev8.js"></script>
<%	
String workflowid=Util.null2String(request.getParameter("workflowid"));
String nodeid=Util.null2String(request.getParameter("nodeid"));
String formid=Util.null2String(request.getParameter("formid"));
%>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<form name="frmmain" method="post" action="RequestBill4Operation.jsp">

<%

RecordSet.executeProc("FnaCurrency_SelectByDefault","");
RecordSet.next();
String defcurrenyid = RecordSet.getString(1);

boolean hasFF = true;
RecordSetFF.executeProc("Base_FreeField_Select","b4");
if(RecordSetFF.getCounts()<=0)
	hasFF = false;
else
	RecordSetFF.first();
String isSignDoc_add="";
String isSignWorkflow_add="";
RecordSet.execute("select titleFieldId,keywordFieldId,isSignDoc,isSignWorkflow from workflow_base where id="+workflowid);
if(RecordSet.next()){
    isSignDoc_add=Util.null2String(RecordSet.getString("isSignDoc"));
    isSignWorkflow_add=Util.null2String(RecordSet.getString("isSignWorkflow"));
}
String needcheck="requestname";
int rowsum=0;
%>
<div>
<BUTTON class=btn accessKey=B type=button onclick="doSubmit()"><U>B</U>-<%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></button>
<BUTTON class=btnSave accessKey=S type=button onclick="doSave()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></button>
</div>
<br>
<table class=form>
  <colgroup>
  <col width="20%">
  <col width="80%">
  <TR class=Section>
    	  <TH colSpan=2>
    	  <%=SystemEnv.getHtmlLabelName(648,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%>
    	  </TH></TR>
     <TR class=separator>
    	  <TD class=Sep1 colSpan=2></TD></TR>
  <tr>
  	<td>说明</td>
  	<td class=field><input type=text name=requestname onChange="checkinput('requestname','requestnamespan')" size=40 maxlength=25>
  		<span id=requestnamespan><IMG src="/images/BacoError_wev8.gif" align=absMiddle></span>
  	    <input type=radio value="0" name="requestlevel" checked>正常
        <input type=radio value="1" name="requestlevel">重要
        <input type=radio value="2" name="requestlevel">紧急	
  	</td>
  </tr>
<%
ArrayList fieldids=new ArrayList();
ArrayList fieldlabels=new ArrayList();
ArrayList fieldhtmltypes=new ArrayList();
ArrayList fieldtypes=new ArrayList();
RecordSet.executeProc("workflow_billfield_Select",formid+"");
while(RecordSet.next()){
	fieldids.add(RecordSet.getString("id"));
	fieldlabels.add(RecordSet.getString("fieldlabel"));
	fieldhtmltypes.add(RecordSet.getString("fieldhtmltype"));
	fieldtypes.add(RecordSet.getString("type"));
}

ArrayList isviews=new ArrayList();
ArrayList isedits=new ArrayList();
ArrayList ismands=new ArrayList();
RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");
while(RecordSet.next()){
	isviews.add(RecordSet.getString("isview"));
	isedits.add(RecordSet.getString("isedit"));
	ismands.add(RecordSet.getString("ismandatory"));
}


for(int i=0;i<fieldids.size();i++){
	String fieldid=(String)fieldids.get(i);
	String isview=(String)isviews.get(i);
	String isedit=(String)isedits.get(i);
	String ismand=(String)ismands.get(i);
	String fieldhtmltype=(String)fieldhtmltypes.get(i);
	String fieldtype=(String)fieldtypes.get(i);
	String fieldlable=SystemEnv.getHtmlLabelName(Util.getIntValue((String)fieldlabels.get(i),0),user.getLanguage());
	
   if(isview.equals("1")){
%>
   <tr>
<%if(fieldhtmltype.equals("2")){%>
   	<td valign=top><%=Util.toScreen(fieldlable,user.getLanguage())%></td>
<%}else{%>
   	<td><%=Util.toScreen(fieldlable,user.getLanguage())%></td>
<%}%>   	<td class=field>
<%
	if(fieldhtmltype.equals("1")){
		if(fieldtype.equals("1")){
			if(isedit.equals("1")){
				if(ismand.equals("1")) {%>
		<input type=text name="field<%=fieldid%>" onChange="checkinput('field<%=fieldid%>','field<%=fieldid%>span')">
		<span id="field<%=fieldid%>span"><img src="/images/BacoError_wev8.gif" align=absmiddle></span>
				<%
					needcheck+=",field"+fieldid;
				}else{%>
		<input type=text name="field<%=fieldid%>" >
				<%}
			}
		}
		else{
			if(isedit.equals("1")){
				if(ismand.equals("1")) {%>
		<input type=text name="field<%=fieldid%>" onChange="checkinput('field<%=fieldid%>','field<%=fieldid%>span')"
		onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)'>
		<span id="field<%=fieldid%>span"><img src="/images/BacoError_wev8.gif" align=absmiddle></span>
				<%
					needcheck+=",field"+fieldid;
				}else{%>
		<input type=text name="field<%=fieldid%>" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)'>
				<%}
			}
		}
	}
	else if(fieldhtmltype.equals("2")){
		if(isedit.equals("1")){
			if(ismand.equals("1")) {%>
		<textarea name="field<%=fieldid%>" onChange="checkinput('field<%=fieldid%>','field<%=fieldid%>span')"
		rows="4" cols="40" style="width:80%"></textarea>
		<span id="field<%=fieldid%>span"><img src="/images/BacoError_wev8.gif" align=absmiddle></span>
			<%
				needcheck+=",field"+fieldid;
			}else{%>
		<textarea name="field<%=fieldid%>" rows=4 cols=40 style="width:60%"></textarea>
			<%}
		}
	}
	else if(fieldhtmltype.equals("3")){
		String url=BrowserComInfo.getBrowserurl(fieldtype);
		String linkurl=BrowserComInfo.getLinkurl(fieldtype);
		%>
		<button class=Browser onclick="onShowBrowser('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>')"></button>
		<input type=hidden name="field<%=fieldid%>">
		<span id="field<%=fieldid%>span">
		<%if(ismand.equals("1")){%><img src="/images/BacoError_wev8.gif" align=absmiddle>
		<%	needcheck+=",field"+fieldid;	
			}%>
		</span>
		<%
	}
	else if(fieldhtmltype.equals("4")){
	%>
		<input type=checkbox value=1 name="field<%=fieldid%>" <%if(isedit.equals("0")){%> DISABLED <%}%> >
	<%}
%>
   	</td>
   </tr>
<%
   }
}
%>

<%
if(hasFF)
{
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+1).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2)%></TD>
          <TD class=Field>
          <BUTTON class=Calendar onclick="getDate(<%=i%>)"></BUTTON> 
              <SPAN id=datespan<%=i%> ></SPAN> 
              <input type="hidden" name="dff0<%=i%>" id="dff0<%=i%>">
          </TD>
        </TR>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+11).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2+10)%></TD>
          <TD class=Field><INPUT class=saveHistory maxLength=30 size=30 name="nff0<%=i%>" value="0.0"></TD>
        </TR>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+21).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2+20)%></TD>
          <TD class=Field><INPUT class=saveHistory maxLength=100 size=30 name="tff0<%=i%>"></TD>
        </TR>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+31).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2+30)%></TD>
          <TD class=Field>
          <INPUT type=checkbox  name="bff0<%=i%>" value="1"></TD>
        </TR>
		<%}
	}
}
%>
<TR class=Section>
    	  <TH colSpan=2>
    	  资产
    	  </TH></TR>
     <TR class=separator>
    	  <TD class=Sep1 colSpan=2></TD></TR>
  <tr>
  <table Class=ListShort cols=9 id="oTable">
      	<COLGROUP>
      	<COL width="4%">
  	<COL width="14%">
  	<COL width="13%">
  	<COL width="13%">
  	<COL width="13%">
  	<COL width="13%">
  	<COL width="10%">
  	<COL width="10%">
  	<COL width="10%">
    	   <tr class=header> 
    	   <td>选中</td>
            <td>资产</td>
            <td>批号</td>
            <td>数量</td>
            <td>单价</td>
            <td>税率(%)</td>
            <td>金额</td>
            <td>税额</td>
            <td>税价合计</td>
            </tr>
  </table>
  
  </tr>  	  
<br>
<BUTTON Class=Btn type=button accessKey=A onclick="addRow();"><U>A</U>-添加</BUTTON>
<BUTTON Class=Btn type=button accessKey=E onclick="deleteRow1();"><U>E</U>-删除</BUTTON></div>
<br>
</table>
<table class=form>
<tr class="Title">
      <td colspan=2 align="center" valign="middle"><font style="font-size:14pt;FONT-WEIGHT: bold"><%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%></font></td>
    </tr>
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(504,user.getLanguage())%></td>
<td class=field>
<input type="hidden" id="remarkText10404" name="remarkText10404" value="">
<textarea name=remark rows=7 cols=50 style="width=80%;display:none"></textarea>
<script defer>
function funcremark_log(){
	FCKEditorExt.initEditor("frmmain","remark",<%=user.getLanguage()%>,FCKEditorExt.NO_IMAGE);
	FCKEditorExt.toolbarExpand(false,"remark");
}
//if(ieVersion>=8) window.attachEvent("onload", funcremark_log());
//else window.attachEvent("onload", funcremark_log);
if (window.addEventListener){
    window.addEventListener("load", funcremark_log, false);
}else if (window.attachEvent){
    window.attachEvent("onload", funcremark_log);
}else{
    window.onload=funcremark_log;
}
</script>
</td>
</tr>
    <tr><td class=Line2 colSpan=2></td></tr>
<%
         if("1".equals(isSignDoc_add)){
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
            <td class=field>
                <input type="hidden" id="signdocids" name="signdocids">
                <button class=Browser onclick="onShowSignBrowser('/docs/docs/MutiDocBrowser.jsp','/docs/docs/DocDsp.jsp?isrequest=1&id=','signdocids','signdocspan',37)" title="<%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>"></button>
                <span id="signdocspan"></span>
            </td>
          </tr>
          <tr><td class=Line2 colSpan=2></td></tr>
         <%}%>
     <%
         if("1".equals(isSignWorkflow_add)){
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
            <td class=field>
                <input type="hidden" id="signworkflowids" name="signworkflowids">
                <button class=Browser onclick="onShowSignBrowser('/workflow/request/MultiRequestBrowser.jsp','/workflow/request/ViewRequest.jsp?isrequest=1&requestid=','signworkflowids','signworkflowspan',152)" title="<%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%>"></button>
                <span id="signworkflowspan"></span>
            </td>
          </tr>
          <tr><td class=Line2 colSpan=2></td></tr>
         <%}%>    
</table>
<input type=hidden name="workflowid" value=<%=workflowid%>>
<input type=hidden name="nodeid" value=<%=nodeid%>>
<input type=hidden name="nodetype" value="0">
<input type=hidden name="src">
<input type=hidden name="iscreate" value="1">
<input type=hidden name="formid" value=<%=formid%>>
<input type="hidden" value="0" name="nodesnum">
<input type="hidden" value="<%=defcurrenyid%>" name="defcurrencyid">

</form>
<script language=javascript>
rowindex = "<%=rowsum%>";
function addRow()
{
	ncol = oTable.cols;
	
	oRow = oTable.insertRow(-1);
	
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);  
		oCell.style.height=24;
		oCell.style.background= "#D2D1F1";
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node' value='0'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<button class=Browser onClick='onShowAsset(node_"+rowindex+"_assetspan,node_"+rowindex+"_assetid)'></button> " + 
        					"<span class=saveHistory id=node_"+rowindex+"_assetspan><img src='/images/BacoError_wev8.gif' align=absMiddle></span> "+
        					"<input type='hidden' name='node_"+rowindex+"_assetid' id='node_"+rowindex+"_assetid'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type='input' style=width:100% name='node_"+rowindex+"_batchmark'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type='input' style=width:100%  name='node_"+rowindex+"_number' onchange='changenumber("+rowindex+")'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 4: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type='input' style=width:100% name='node_"+rowindex+"_unitprice' onchange='changenumber("+rowindex+")'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 5: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type='input'  style=width:100%  name='node_"+rowindex+"_taxrate' onchange='changenumber("+rowindex+")'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 6: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<span id='node_"+rowindex+"_totalprice' name='node_"+rowindex+"_totalprice'></span>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 7: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<span id='node_"+rowindex+"_totaltax' name='node_"+rowindex+"_totaltax'></span>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 8: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<span id='node_"+rowindex+"_total' name='node_"+rowindex+"_total'></span>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			
		}
	}
	rowindex = rowindex*1 +1;
	
}

function changenumber(rowval){
	document.all("node_"+rowval+"_totalprice").innerHTML = document.all("node_"+rowval+"_number").value * document.all("node_"+rowval+"_unitprice").value;
	document.all("node_"+rowval+"_totaltax").innerHTML = document.all("node_"+rowval+"_number").value * document.all("node_"+rowval+"_unitprice").value * document.all("node_"+rowval+"_taxrate").value/100.0;
	document.all("node_"+rowval+"_total").innerHTML = document.all("node_"+rowval+"_totalprice").innerHTML/1 + document.all("node_"+rowval+"_totaltax").innerHTML/1;
	
}

function deleteRow1()
{
    var flag = false;
	var ids = document.getElementsByName('check_node');
	for(i=0; i<ids.length; i++) {
		if(ids[i].checked==true) {
			flag = true;
			break;
		}
	}
    if(flag) {
		if(isdel()){
            len = document.forms[0].elements.length;
            var i=0;
            var rowsum1 = 0;
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_node')
                    rowsum1 += 1;
            }
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_node'){
                    if(document.forms[0].elements[i].checked==true) {
                        oTable.deleteRow(rowsum1);
                    }
                    rowsum1 -=1;
                }

            }
        }
    }else{
        alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
}	



	function doSave(){
		if(check_form(document.frmmain,'requestname,<%=needcheck%>')){
			document.frmmain.src.value='save';
			document.frmmain.nodesnum.value=rowindex;
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
		}
	}
	function doSubmit(){
		if(check_form(document.frmmain,'<%=needcheck%>')){
			document.frmmain.src.value='submit';
			document.frmmain.nodesnum.value=rowindex;
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
		}
	}
</script>
<script language=vbs>

sub getDate(i)
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	document.all("datespan"&i).innerHtml= returndate
	document.all("dff0"&i).value=returndate
end sub

sub onShowAsset(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/asset/LgcAssetBrowser.jsp")
	if NOT isempty(id) then
	    if id(0)<> "" then
		spanname.innerHtml = id(1)
		inputname.value=id(0)
		else
		spanname.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		inputname.value=""
		end if
	end if
end sub
</script>


<script language=javascript>
	function doSave(){
		if(check_form(document.frmmain,'<%=needcheck%>')){
			document.frmmain.src.value='save';
			document.frmmain.remark.disabled=false ;
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
		}
	}
	function doSubmit(){
		if(check_form(document.frmmain,'<%=needcheck%>')){
			document.frmmain.src.value='submit';
			document.frmmain.remark.disabled=false ;
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
		}
	}
</script>