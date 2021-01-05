<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CapitalStateComInfo" class="weaver.cpt.maintenance.CapitalStateComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>
<jsp:useBean id="WFNodeDtlFieldManager" class="weaver.workflow.workflow.WFNodeDtlFieldManager" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.browserData.BrowserManager"%>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<%@ include file="/workflow/request/WorkflowManageRequestTitle.jsp" %>
<form name="frmmain" method="post" action="BillCptAdjustOperation.jsp" enctype="multipart/form-data">
<input type="hidden" name="needwfback" id="needwfback" value="1" />
<input type="hidden" name="lastOperator"  id="lastOperator" value="<%=lastOperator%>"/>
<input type="hidden" name="lastOperateDate"  id="lastOperateDate" value="<%=lastOperateDate%>"/>
<input type="hidden" name="lastOperateTime"  id="lastOperateTime" value="<%=lastOperateTime%>"/>

<%@ include file="/workflow/request/WorkflowManageRequestBody.jsp" %>
<%
    //获取明细表设置
    WFNodeDtlFieldManager.resetParameter();
    WFNodeDtlFieldManager.setNodeid(Util.getIntValue(""+nodeid));
    WFNodeDtlFieldManager.setGroupid(0);
    WFNodeDtlFieldManager.selectWfNodeDtlField();
    String dtladd = WFNodeDtlFieldManager.getIsadd();
    String dtledit = WFNodeDtlFieldManager.getIsedit();
    String dtldelete = WFNodeDtlFieldManager.getIsdelete();
    
    String dtldefault = WFNodeDtlFieldManager.getIsdefault();
    String dtlneed = WFNodeDtlFieldManager.getIsneed();
    int dtldefaultrows = WFNodeDtlFieldManager.getDefaultrows();
    boolean canedit = false;
    if("1".equals(dtledit)){
        canedit = true;
    }
%>
<%
int groupid = 0 ;
fieldids.clear();
fieldnames.clear();
fieldvalues.clear();
fieldlabels.clear();
fieldhtmltypes.clear();
fieldtypes.clear();
ArrayList viewtypes=new ArrayList();
RecordSet.executeProc("workflow_billfield_Select",formid+"");
while(RecordSet.next()){
	String theviewtype = Util.null2String(RecordSet.getString("viewtype")) ;
	if( !theviewtype.equals("1") ) continue ;   // 如果是单据的主表字段,不显示
	fieldids.add(RecordSet.getString("id"));
	fieldnames.add(RecordSet.getString("fieldname"));
	fieldlabels.add(RecordSet.getString("fieldlabel"));
	fieldhtmltypes.add(RecordSet.getString("fieldhtmltype"));
	fieldtypes.add(RecordSet.getString("type"));
	viewtypes.add(RecordSet.getString("viewtype"));
}
isviews.clear();
isedits.clear();
ismands.clear();
RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");
while(RecordSet.next()){
	String thefieldid = Util.null2String(RecordSet.getString("fieldid")) ;
	int thefieldidindex = fieldids.indexOf( thefieldid ) ;
	if( thefieldidindex == -1 ) continue ;
	isviews.add(RecordSet.getString("isview"));
	isedits.add(RecordSet.getString("isedit"));
	ismands.add(RecordSet.getString("ismandatory"));
}
String dsptypes="";
String edittypes ="";
String mandtypes ="";
int tmpcount = 1;
int viewCount = 0; 
for(int ii=0;ii<fieldids.size();ii++){
	String isview1=(String)isviews.get(ii);
	if(isview1.equals("1")) viewCount++;
}

for(int i=0;i<fieldids.size();i++){
	String fieldname=(String)fieldnames.get(i);
	String fieldid=(String)fieldids.get(i);
	String isview=(String)isviews.get(i);
	String isedit=(String)isedits.get(i);
	String ismand=(String)ismands.get(i);
	String fieldhtmltype=(String)fieldhtmltypes.get(i);
	String fieldtype=(String)fieldtypes.get(i);
	String fieldlable=SystemEnv.getHtmlLabelName(Util.getIntValue((String)fieldlabels.get(i),0),user.getLanguage());
	String viewtype = (String)viewtypes.get(i);
	if(viewtype.equals("0"))
		continue;
	
	dsptypes +=","+tmpcount+"_"+isview;
	edittypes +=","+tmpcount+"_"+isedit;
	mandtypes +=","+tmpcount+"_"+ismand;
	tmpcount++;
}
int rowsum=0;
%>
<wea:layout>
	<wea:group attributes="{\"groupOperDisplay\":\"none\"}" context='<%=SystemEnv.getHtmlLabelName(17463,user.getLanguage()) %>'>
		<wea:item type="groupHead">
			<% if(!isaffirmancebody.equals("1")|| reEditbody.equals("1")) { %>
              	<%if(dtladd.equals("1")){%>
				<input type=button  Class="addbtn" type=button accessKey=A onclick="addRow()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
				<%}
				if(dtladd.equals("1") || dtldelete.equals("1")){%>
				<input type=button  Class="delbtn" type=button accessKey=E onclick="deleteRow1();" title="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>"></input>
				<%}%>
			<%  } %>
   	   </wea:item>
	   <wea:item attributes="{\"isTableList\":\"true\"}">
            <table Class="ListStyle" cellspacing=1 cols=10 id="oTable">
              <tr class=header>
			  <% if((!isaffirmancebody.equals("1")|| reEditbody.equals("1"))  ) { %>
			  <td width="5%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></td>
			  <%}%>
<%
for(int i=0;i<fieldids.size();i++){
	String fieldname=(String)fieldnames.get(i);
	String fieldid=(String)fieldids.get(i);
	String isview=(String)isviews.get(i);
	String isedit=(String)isedits.get(i);
	String ismand=(String)ismands.get(i);
	String fieldhtmltype=(String)fieldhtmltypes.get(i);
	String fieldtype=(String)fieldtypes.get(i);
	String fieldlable=SystemEnv.getHtmlLabelName(Util.getIntValue((String)fieldlabels.get(i),0),user.getLanguage());
	String viewtype = (String)viewtypes.get(i);
	if(viewtype.equals("0"))
		continue;
	
%>
    	  
            <td <%if(isview.equals("0")){%> style="display:none" <%}%> width="<%=viewCount>0?( 95/viewCount):0 %>%"><%=Util.toScreen(fieldlable,user.getLanguage())%></td>
<%}%>
            </tr>
    	   
            <%
	        int linecolor=0;  
            int i=0;
			RecordSet.executeProc("bill_CptAdjustDetail_Select",billid+"");
			while(RecordSet.next()){
				i++;
            %>
            <tr <%if(linecolor==0){%> class=DataLight <%} else {%> class=DataDark <%}%> > 
            	
			      <% if( (!isaffirmancebody.equals("1")|| reEditbody.equals("1")) ) { %>
            <td>
            <input type='checkbox' name='check_node' id='check_node' value="<%=RecordSet.getString("id")%>" <%if(!dtldelete.equals("1")){%>disabled<%}%>>
            <input type="hidden" name='check_node_val' value='<%=rowsum %>'>
            <span serialno>&nbsp;&nbsp;&nbsp;<%=i %></span>
            </td>
            <%}else{%>
            	&nbsp;
          	<%}%>
          	
            <td <%if(dsptypes.indexOf("1_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("1_1")!=-1&&canedit){
            	String tempvalue = (RecordSet.getInt("cptid")>0?RecordSet.getString("cptid"):"");
            	String tempshowvalue = Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(RecordSet.getString("cptid")),user.getLanguage());
            	String isMustInput = "1";
	           	if(mandtypes.indexOf("1_1")!=-1){
	           		isMustInput = "2";
	           	 	needcheck+=",node_"+rowsum+"_cptid";
	           	}
	           	String tempfieldname = "node_"+rowsum+"_cptid";
            %>
         	<brow:browser viewType="0" name='<%=tempfieldname %>' browserValue='<%= ""+tempvalue %>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp"
								hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='<%=isMustInput %>'
								completeUrl="/data.jsp?type=25" linkUrl=""
								browserSpanValue='<%=tempshowvalue  %>'  width='150px' _callBack="onSetCptCapital"></brow:browser>
        	<%}else{%>
        	<%=Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(RecordSet.getString("cptid")),user.getLanguage())%>
        	<input type='hidden' name='node_<%=rowsum%>_cptid' id='node_<%=rowsum%>_cptid' value="<%=RecordSet.getString("cptid")%>">
         	<%}%>
	    </td>

			<td <%if(dsptypes.indexOf("2_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("2_1")!=-1&&canedit){
            	String tempvalue = (RecordSet.getInt("capitalid")>0?RecordSet.getString("capitalid"):"");
            	String tempshowvalue = Util.toScreen(CapitalComInfo.getCapitalname(RecordSet.getString("capitalid")),user.getLanguage());
            	String isMustInput = "1";
	           	if(mandtypes.indexOf("2_1")!=-1){
	           		isMustInput = "2";
	           		needcheck+=",node_"+rowsum+"_capitalid";
	           	}
	           	String tempfieldname = "node_"+rowsum+"_capitalid";
            %>
         	 <brow:browser viewType="0" name='<%=tempfieldname %>' browserValue='<%= ""+tempvalue %>' 
								   getBrowserUrlFn='onShowTableUrl1'
								hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='<%=isMustInput %>'
								completeUrl="/data.jsp?type=23&cptstateid=2" linkUrl="/cpt/capital/CptCapital.jsp?id="
								browserSpanValue='<%=tempshowvalue  %>' width='150px' _callBack="onSetCptCapital1"></brow:browser>
        	<%}else{%>
        	<a href='/cpt/capital/CptCapital.jsp?id=<%=RecordSet.getString("capitalid")%>'><%=Util.toScreen(CapitalComInfo.getCapitalname(RecordSet.getString("capitalid")),user.getLanguage())%></a>
        	<input type='hidden' name='node_<%=rowsum%>_capitalid' id='node_<%=rowsum%>_capitalid' value="<%=RecordSet.getString("capitalid")%>">
         <%}%>
	    </td>
            
            <td <%if(dsptypes.indexOf("3_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("3_1")!=-1&&canedit){
            	if(mandtypes.indexOf("3_1")!=-1){%>
            		<input type='text' class=inputstyle   name='node_<%=rowsum%>_number' id='node_<%=rowsum%>_number' value="<%=RecordSet.getString("number_n")%>"  onKeyPress='ItemNum_KeyPress()' onBlur=checknumber1(this);checkinput('node_<%=rowsum%>_number','node_<%=rowsum%>_numberspan')>
            		<span id="node_<%=rowsum%>_numberspan">
            		<%if(RecordSet.getString("number_n").equals("")){%>
            		<img src="/images/BacoError_wev8.gif" align=absmiddle>
		         <%
        	 	}needcheck+=",node_"+rowsum+"_number";%>
		        </span>
		<%}else{%>
            		<input type='text' class=inputstyle onBlur='checknumber1(this);' name='node_<%=rowsum%>_number' id='node_<%=rowsum%>_number' value="<%=RecordSet.getString("number_n")%>">
            	<%}%>
	    <%}else{%>
	    	<%=RecordSet.getString("number_n")%>
	    <input type='hidden' name='node_<%=rowsum%>_number' id='node_<%=rowsum%>_number' value="<%=RecordSet.getString("number_n")%>">
	    <%}%>
	    </td>
            <td <%if(dsptypes.indexOf("4_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("4_1")!=-1&&canedit){
            	if(mandtypes.indexOf("4_1")!=-1){%>
            		<input type='text' class=inputstyle   name='node_<%=rowsum%>_unitprice' id='node_<%=rowsum%>_unitprice' value="<%=RecordSet.getString("unitprice")%>"  onKeyPress='ItemNum_KeyPress()' onBlur=checknumber1(this);checkinput('node_<%=rowsum%>_unitprice','node_<%=rowsum%>_unitpricespan')>
            		<span id="node_<%=rowsum%>_unitpricespan">
            		<%if(RecordSet.getString("unitprice").equals("")){%>
            		<img src="/images/BacoError_wev8.gif" align=absmiddle>
		        <%
        	 	}needcheck+=",node_"+rowsum+"_unitprice";%>
		        </span>
		<%}else{%>
            		<input type='text' class=inputstyle onBlur='checknumber1(this);'  name='node_<%=rowsum%>_unitprice' id='node_<%=rowsum%>_unitprice' value="<%=RecordSet.getString("unitprice")%>">
            	<%}%>
	    <%}else{%>
	    <%=RecordSet.getString("unitprice")%>
	    <input type='hidden' name='node_<%=rowsum%>_unitprice' id='node_<%=rowsum%>_unitprice' value="<%=RecordSet.getString("unitprice")%>">
	    <%}%>
	    </td>
            <td <%if(dsptypes.indexOf("5_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("5_1")!=-1&&canedit){
            	if(mandtypes.indexOf("5_1")!=-1){%>
            		<input type='text' class=inputstyle   name='node_<%=rowsum%>_amount' id='node_<%=rowsum%>_amount' value="<%=RecordSet.getString("amount")%>"  onKeyPress='ItemNum_KeyPress()' onBlur=checknumber1(this);checkinput('node_<%=rowsum%>_amount','node_<%=rowsum%>_amountspan')>
            		<span id="node_<%=rowsum%>_amountspan">
            		<%if(RecordSet.getString("amount").equals("")){%>
            		<img src="/images/BacoError_wev8.gif" align=absmiddle>
		        <%
        	 	}needcheck+=",node_"+rowsum+"_amount";%>
		        </span>
		<%}else{%>
            		<input type='text' class=inputstyle onBlur='checknumber1(this);'  name='node_<%=rowsum%>_amount' id='node_<%=rowsum%>_amount' value="<%=RecordSet.getString("amount")%>">
            	<%}%>
	    <%}else{%>
	    <%=RecordSet.getString("amount")%>
	    <input type='hidden' name='node_<%=rowsum%>_amount' id='node_<%=rowsum%>_amount' value="<%=RecordSet.getString("amount")%>">
	    <%}%>
	    </td>
	       <td <%if(dsptypes.indexOf("6_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("6_1")!=-1&&canedit){%>
            <button class=e8_browflow type=button onClick='onBillCPTShowDate(node_<%=rowsum%>_needdatespan,node_<%=rowsum%>_needdate,<%=mandtypes.indexOf("6_1")%>)'></button>
            <span class=Inputstyle id=node_<%=rowsum%>_needdatespan>
            
        	 <% if(mandtypes.indexOf("6_1")!=-1){
        	 		if(RecordSet.getString("needdate").equals(""))
        	 %>
        	 			<img src='/images/BacoError_wev8.gif' align=absmiddle>
        	 <%
        	 	needcheck+=",node_"+rowsum+"_needdate";
        	 }%>
        	 <%=RecordSet.getString("needdate")%>
            
        	 </span>
        	<%}else{%>
        	<%=RecordSet.getString("needdate")%>
            <%}%>
	    <input type='hidden' name='node_<%=rowsum%>_needdate' id='node_<%=rowsum%>_needdate' value="<%=RecordSet.getString("needdate")%>">
	    </td>
            <td <%if(dsptypes.indexOf("7_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("7_1")!=-1&&canedit){
            	if(mandtypes.indexOf("7_1")!=-1){%>
            		<input type='text' class=inputstyle   name='node_<%=rowsum%>_purpose' id='node_<%=rowsum%>_purpose' value="<%=RecordSet.getString("purpose")%>"  OnBlur=checkinput('node_<%=rowsum%>_purpose','node_<%=rowsum%>_purposespan')>
            		<span id="node_<%=rowsum%>_purposespan">
            		<%if(RecordSet.getString("purpose").equals("")){%>
            		<img src="/images/BacoError_wev8.gif" align=absmiddle>
		        <%
        	 	}needcheck+=",node_"+rowsum+"_purpose";%>
		        </span>
		<%}else{%>
            		<input type='text' class=inputstyle   name='node_<%=rowsum%>_purpose' id='node_<%=rowsum%>_purpose' value="<%=Util.toScreenToEdit(RecordSet.getString("purpose"),user.getLanguage())%>">
            	<%}%>
	    <%}else{%>
	    <%=Util.toScreen(RecordSet.getString("purpose"),user.getLanguage())%><input type='hidden' name='node_<%=rowsum%>_purpose' id='node_<%=rowsum%>_purpose' value="<%=RecordSet.getString("purpose")%>">
	    <%}%>
	    </td>
            <td <%if(dsptypes.indexOf("8_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("8_1")!=-1&&canedit){
            	if(mandtypes.indexOf("8_1")!=-1){%>
            		<input type='text' class=inputstyle   name='node_<%=rowsum%>_cptdesc' id='node_<%=rowsum%>_cptdesc' value="<%=RecordSet.getString("cptdesc")%>"  OnBlur=checkinput('node_<%=rowsum%>_cptdesc','node_<%=rowsum%>_cptdescspan')>
            		<span id="node_<%=rowsum%>_cptdescspan">
            		<%if(RecordSet.getString("cptdesc").equals("")){%>
            		<img src="/images/BacoError_wev8.gif" align=absmiddle>
		        <%
        	 	}needcheck+=",node_"+rowsum+"_cptdesc";%>
		        </span>
		<%}else{%>
            		<input type='text' class=inputstyle   name='node_<%=rowsum%>_cptdesc' id='node_<%=rowsum%>_cptdesc' value="<%=Util.toScreenToEdit(RecordSet.getString("cptdesc"),user.getLanguage())%>">
            	<%}%>
	    <%}else{%>
	    <%=Util.toScreen(RecordSet.getString("cptdesc"),user.getLanguage())%>
	    <input type='hidden' name='node_<%=rowsum%>_cptdesc' id='node_<%=rowsum%>_cptdesc' value="<%=RecordSet.getString("cptdesc")%>">
	    <%}%>
	    </td>
           </tr>
            <%if(linecolor==0) linecolor=1;
          else linecolor=0; rowsum++;}%>
  </table>
  <input  type ='hidden' id=nodesnum name=nodesnum value=<%=rowsum%>>
   <input type='hidden' id=rowneed name=rowneed value="<%=dtlneed %>">
  </wea:item>
	</wea:group>
</wea:layout>

 <%@ include file="/workflow/request/WorkflowManageSign.jsp" %>
<script language=vbs>
sub onShowResourceID(ismand)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	resourceidspan.innerHtml = "<A href='javaScript:openhrm("&id(0)&");' onclick='pointerXY(event);'>"&id(1)&"</A>"
	frmmain.resourceid.value=id(0)
	else 
		if ismand=1 then
			resourceidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		else
			resourceidspan.innerHtml = ""
		end if
	frmmain.resourceid.value="0"
	end if
	end if
end sub

sub onShowAssetType(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp")
	if NOT isempty(id) then
	    if id(0)<> "" and id(0)<> "0" then
		spanname.innerHtml = id(1)
		inputname.value=id(0)
		else
		spanname.innerHtml =  "<img src='/images/BacoError_wev8.gif' align=absmiddle>"
		inputname.value=""
		end if
	end if
end sub
sub onShowAssetCapital(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata='2'&cptstateid=2")
	if NOT isempty(id) then
	    if id(0)<> "" and id(0)<> "0" then
		spanname.innerHtml = "<a href='/cpt/capital/CptCapital.jsp?id="&id(0)&"'>"&id(1)&"</a>"
		inputname.value=id(0)
		else
		spanname.innerHtml =  "<img src='/images/BacoError_wev8.gif' align=absmiddle>"
		inputname.value=""
		end if
	end if
end sub
</script>   
<input type="hidden" name="f_weaver_belongto_userid" value="<%=request.getParameter("f_weaver_belongto_userid") %>">
<input type="hidden" name="f_weaver_belongto_usertype" value="<%=request.getParameter("f_weaver_belongto_usertype") %>">
</form>
<script language=javascript>
groupid = <%=groupid%>;
rowindex = document.frmmain.nodesnum.value ;
needcheck = "<%=needcheck%>";
document.all("needcheck").value += ","+needcheck;
function addRow()
{
	ncol = 9;
	dsptypes = "<%=dsptypes%>";
	edittypes = "<%=edittypes%>";
	mandtypes = "<%=mandtypes%>";
	
	var rownum = oTable.rows.length;
	oRow = oTable.insertRow(rownum);
	//rowindex = oRow.rowIndex;
	if (0 == rowindex % 2)
    {
        oRow.className = "DataLight";
    }
    else
    {
        oRow.className = "DataDark";
    }
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);  
		oCell.style.height=24;
		//oCell.style.background= "#D2D1F1";
		if(dsptypes.indexOf(j+"_0")!=-1){
			oCell.style.display="none";
		}
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node' value='"+rowindex+"'><input type='hidden' name='check_node_val' value='"+rowindex+"'>"; 
				oDiv.innerHTML = sHtml+"<span serialno>&nbsp;&nbsp;&nbsp;&nbsp;"+rownum+"</span>";
				oCell.appendChild(oDiv);
				jQuery(oCell).jNice();
				break;
			
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("1_1")!=-1){
					oDiv.innerHTML="<div class='e8Browser'></div>";
        			oCell.appendChild(oDiv);
			        try
			        {
			        	var tempisMustInput = "1";
			        	if(mandtypes.indexOf("1_1")!=-1){
        					tempisMustInput = "2";
        					needcheck += ","+"node_"+rowindex+"_cptid";
        				}
				       	jQuery(oDiv).find(".e8Browser").e8Browser({
						   name:"node_"+rowindex+"_cptid",
						   viewType:"0",
						   browserValue:"",
						   isMustInput:tempisMustInput,
						   browserSpanValue:"",
						   getBrowserUrlFn:'onShowTableUrl',
						   getBrowserUrlFnParams:"",
						   hasInput:true,
						   linkUrl:"#",
						   isSingle:true,
						   completeUrl:"/data.jsp?type=25",
						   browserUrl:"",
						   width:'90%',
						   hasAdd:false,
						   isSingle:true,
						   _callback:"onSetCptCapital"
						});
					}
					catch(e)
					{
						alert(e);
					}
				}
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("2_1")!=-1){					
					oDiv.innerHTML="<div class='e8Browser'></div>";
        			oCell.appendChild(oDiv);
			        try
			        {
			        	var tempisMustInput = "1";
			        	if(mandtypes.indexOf("2_1")!=-1){
        					tempisMustInput = "2";
        					needcheck += ","+"node_"+rowindex+"_capitalid";
        				}
				       	jQuery(oDiv).find(".e8Browser").e8Browser({
						   name:"node_"+rowindex+"_capitalid",
						   viewType:"0",
						   browserValue:"",
						   isMustInput:tempisMustInput,
						   browserSpanValue:"",
						   getBrowserUrlFn:'onShowTableUrl1',
						   getBrowserUrlFnParams:"",
						   hasInput:true,
						   linkUrl:"#",
						   isSingle:true,
						   completeUrl:"/data.jsp?type=23&cptstateid=2",
						   browserUrl:"",
						   width:'90%',
						   hasAdd:false,
						   isSingle:true,
						   _callback:"onSetCptCapital1"
						});
					}
					catch(e)
					{
						alert(e);
					}
				}
				break;
			case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("3_1")!=-1){
					if(mandtypes.indexOf("3_1")!=-1){ 
						sHtml = "<input type='text' class=Inputstyle name='node_"+rowindex+"_number' onKeyPress='ItemNum_KeyPress()' onBlur=checknumber1(this);checkinput('node_"+rowindex+"_number','node_"+rowindex+"_numberspan')><span id='node_"+rowindex+"_numberspan'>";
						sHtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
						sHtml+="</span>";
        					needcheck += ","+"node_"+rowindex+"_number";
        				}else{
        					sHtml = "<input type='text' onBlur='checknumber1(this);' class=Inputstyle name='node_"+rowindex+"_number'>";
        				}
	        			oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				}
				break;
			case 4: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("4_1")!=-1){
					if(mandtypes.indexOf("4_1")!=-1){
						sHtml = "<input type='text' class=Inputstyle  name='node_"+rowindex+"_unitprice'  onKeyPress='ItemNum_KeyPress()' onBlur=checknumber1(this);checkinput('node_"+rowindex+"_unitprice','node_"+rowindex+"_unitpricespan')><span id='node_"+rowindex+"_unitpricespan'>";
						sHtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_unitprice";
        					sHtml+="</span>"
        				}else{
        					sHtml = "<input type='text' class=Inputstyle onBlur='checknumber1(this);' name='node_"+rowindex+"_unitprice'>";
        				}
        				
        				oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
        			}
				break;
			case 5: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("5_1")!=-1){
					if(mandtypes.indexOf("5_1")!=-1){
						sHtml = "<input type='text' class=Inputstyle  name='node_"+rowindex+"_amount'  onKeyPress='ItemNum_KeyPress()' onBlur=checknumber1(this);checkinput('node_"+rowindex+"_amount','node_"+rowindex+"_amountspan')><span id='node_"+rowindex+"_amountspan'>";
						sHtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_amount";
        					sHtml+="</span>"
        				}else{
        					sHtml = "<input type='text' class=Inputstyle onBlur='checknumber1(this);' name='node_"+rowindex+"_amount'>";
        				}
        				
        				oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
        			}
				break;
			case 6: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("6_1")!=-1){
					sHtml = "<button class=e8_browflow type=button onClick='onBillCPTShowDate(node_"+rowindex+"_needdatespan,node_"+rowindex+"_needdate,"+mandtypes.indexOf("6_1")+")'></button> " + 
						"<span id=node_"+rowindex+"_needdatespan> ";
					if(mandtypes.indexOf("6_1")!=-1){
        					sHtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_needdate";
        				}
        				sHtml+="</span>"
        				sHtml += "<input type='hidden' name='node_"+rowindex+"_needdate' id='node_"+rowindex+"_needdate'>";
        				oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
        			}
				break;
			
			case 7: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";;
				if(edittypes.indexOf("7_1")!=-1){
					if(mandtypes.indexOf("7_1")!=-1){
						sHtml = "<input type='text' class=Inputstyle  name='node_"+rowindex+"_purpose' onBlur=checkinput('node_"+rowindex+"_purpose','node_"+rowindex+"_purposespan')><span id='node_"+rowindex+"_purposespan'>";
						sHtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_purpose";
        					sHtml+="</span>"        				
        				}else{
        					sHtml = "<input type='text' class=Inputstyle name='node_"+rowindex+"_purpose'>";
        				}
        				oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
        			}
				break;	
			case 8: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";;
				if(edittypes.indexOf("8_1")!=-1){
					if(mandtypes.indexOf("8_1")!=-1){
						sHtml = "<input type='text' class=Inputstyle name='node_"+rowindex+"_cptdesc' onBlur=checkinput('node_"+rowindex+"_cptdesc','node_"+rowindex+"_cptdescspan')><span id='node_"+rowindex+"_cptdescspan'>";
						sHtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_cptdesc";
        					sHtml+="</span>"        				
        				}else{
        					sHtml = "<input type='text' class=Inputstyle name='node_"+rowindex+"_cptdesc'>";
        				}
        				oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
        			}
				break;	
				
		}
	}
	rowindex = rowindex*1+1;
	document.frmmain.nodesnum.value = rowindex ;
	document.all("needcheck").value += ","+needcheck;
}

<%
if(dtldefault.equals("1")&&rowsum<1)
{
%>
for(var k=0;k<'<%=dtldefaultrows %>';k++){
addRow();
}
<%	
}
%>

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
			var sumnum = rowsum1;
            mandtypes = "<%=mandtypes%>";
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_node'){
                    if(document.forms[0].elements[i].checked==true) {
                        tmprow = document.forms[0].elements[i].value;
                        if(document.forms[0].elements[i].isexist==1){//删除已经存在的明细
                            document.getElementById("delids").value = document.getElementById("delids").value+","+tmprow;
                        }
                        for(j=0; j<7; j++) {
                            if(mandtypes.indexOf(j+"_1")!=-1){
                                if(j==1)
                                    needcheck = needcheck.replace(",node_"+tmprow+"_cptid","");
                                if(j==2)
                                    needcheck = needcheck.replace(",node_"+tmprow+"_capitalid","");
                                if(j==3)
                                    needcheck = needcheck.replace(",node_"+tmprow+"_number","");
                                if(j==4)
                                    needcheck = needcheck.replace(",node_"+tmprow+"_unitprice","");
                                if(j==5)
                                    needcheck = needcheck.replace(",node_"+tmprow+"_amount","");
                                if(j==6)
                                    needcheck = needcheck.replace(",node_"+tmprow+"_needdate","");
                                if(j==7)
                                    needcheck = needcheck.replace(",node_"+tmprow+"_purpose","");
                                if(j==8)
                                    needcheck = needcheck.replace(",node_"+tmprow+"_cptdesc","");

                            }
                        }
                        oTable.deleteRow(rowsum1);
						sumnum -=1;	
        //				rowindex = rowindex*1 - 1;
                    }
                    rowsum1 -=1;
                }
            }
			//document.frmmain.nodesnum.value = sumnum ;
            reloadSerialNum();
            amountsumcount();
}
}else{
alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
}
}	
function reloadSerialNum(){
	jQuery(oTable).find("tr").each(function(index,item){
		jQuery(item).find("span[serialno]").html("&nbsp;&nbsp;&nbsp;&nbsp;"+index);
	});
}

function onShowTableUrl()
{
	return "/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp";
}

function onSetCptCapital(event,data,name)
{
	var ismust1 = <%=mandtypes.indexOf("1_1")!=-1%>
	var obj= event.target || event.srcElement;
	try
	{
		var rowindexstr = name.substring(name.indexOf("_"),name.length)
		var rowindex = rowindexstr.substring(0,rowindexstr.indexOf("_"));
		
		if (data) 
		{
			if (wuiUtil.getJsonValueByIndex(data, 0) != "") 
			{
				jQuery("#node_"+rowindex+"_cptidspan").html(data.name);
				jQuery("#node_"+rowindex+"_cptid").val(data.id);
		    }
			else
			{
				if(ismust1)
				{
					jQuery("#node_"+rowindex+"_cptidspan").html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
					jQuery("#node_"+rowindex+"_cptid").val('');
				}
				else
				{
					jQuery("#node_"+rowindex+"_cptidspan").html("");
					jQuery("#node_"+rowindex+"_cptid").val('');
				}
			}
		}
	}
	catch(e)
	{
	}
}
function onShowTableUrl1()
{
	return "/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata='2'&cptstateid=2";
}

function onSetCptCapital1(event,data,name)
{
	var ismust1 = <%=mandtypes.indexOf("2_1")!=-1%>
	var obj= event.target || event.srcElement;
	try
	{
		var rowindexstr = name.substring(name.indexOf("_"),name.length)
		var rowindex = rowindexstr.substring(0,rowindexstr.indexOf("_"));
		
		if (data) 
		{
			if (wuiUtil.getJsonValueByIndex(data, 0) != "") 
			{
				jQuery("#node_"+rowindex+"_capitalidspan").html(data.name);
				jQuery("#node_"+rowindex+"_capitalid").val(data.id);
		    }
			else
			{
				if(ismust1)
				{
					jQuery("#node_"+rowindex+"_capitalidspan").html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
					jQuery("#node_"+rowindex+"_capitalid").val('');
				}
				else
				{
					jQuery("#node_"+rowindex+"_capitalidspan").html("");
					jQuery("#node_"+rowindex+"_capitalid").val('');
				}
			}
		}
	}
	catch(e)
	{
	}
}
function changetype(obj){
	groupid = obj.value;		
//	obj.disabled = true;
}
	
function DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo)
{  
    YearFrom  = parseInt(YearFrom,10);
    MonthFrom = parseInt(MonthFrom,10);
    DayFrom = parseInt(DayFrom,10);
    YearTo    = parseInt(YearTo,10);
    MonthTo   = parseInt(MonthTo,10);
    DayTo = parseInt(DayTo,10);
    if(YearTo<YearFrom)
    return false;
    else{
        if(YearTo==YearFrom){
            if(MonthTo<MonthFrom)
            return false;
            else{
                if(MonthTo==MonthFrom){
                    if(DayTo<DayFrom)
                    return false;
                    else
                    return true;
                }
                else 
                return true;
            }
            }
        else
        return true;
        }
}


function checktimeok(){
if ("<%=newenddate%>"!="b" && "<%=newfromdate%>"!="a" && document.frmmain.<%=newenddate%>.value != ""){
			YearFrom=document.frmmain.<%=newfromdate%>.value.substring(0,4);
			MonthFrom=document.frmmain.<%=newfromdate%>.value.substring(5,7);
			DayFrom=document.frmmain.<%=newfromdate%>.value.substring(8,10);
			YearTo=document.frmmain.<%=newenddate%>.value.substring(0,4);
			MonthTo=document.frmmain.<%=newenddate%>.value.substring(5,7);
			DayTo=document.frmmain.<%=newenddate%>.value.substring(8,10);
			// window.alert(YearFrom+MonthFrom+DayFrom);
                   if (!DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo )){
        window.alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
         return false;
  			 }
  }
     return true; 
}

</script>

</body>
</html>
