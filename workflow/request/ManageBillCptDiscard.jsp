<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo"/>
<jsp:useBean id="SearchNumberRecordSet" class="weaver.conn.RecordSet" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<%@page import="weaver.general.browserData.BrowserManager"%>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<%@ include file="/workflow/request/WorkflowManageRequestTitle.jsp" %>
<jsp:useBean id="WFNodeDtlFieldManager" class="weaver.workflow.workflow.WFNodeDtlFieldManager" scope="page" />
<form name="frmmain" method="post" action="BillCptDiscardOperation.jsp" enctype="multipart/form-data">
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

int viewCount = 0; 
for(int ii=0;ii<fieldids.size();ii++){
    String isview1=(String)isviews.get(ii);
    if(isview1.equals("1")) viewCount++;
}

int rowsum=0;
String dsptypes="";
String edittypes ="";
String mandtypes ="";
int tmpcount = 1;
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
		<%}}%>
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
    	   	
    	   	dsptypes +=","+tmpcount+"_"+isview;
    	   	edittypes +=","+tmpcount+"_"+isedit;
    	   	mandtypes +=","+tmpcount+"_"+ismand;
    	   	tmpcount++;
	
%>
    	  
            <td <%if(isview.equals("0")){%> style="display:none" <%}%> width="<%=viewCount<=0?0:95/viewCount%>%"><%=Util.toScreen(fieldlable,user.getLanguage())%></td>
<%}%>
            </tr>
            
    	   
            <%
            
	           int linecolor=0;  
            int i=0;
	RecordSet.executeSql("select * from bill_Discard_Detail where detailrequestid="+requestid+" order by id ");
	//System.out.println("select * from bill_Discard_Detail where detailrequestid="+requestid);
	while(RecordSet.next()){
		i++;
            %>
            <tr <%if(linecolor==0){%> class=DataLight <%} else {%> class=DataDark <%}%> > 

            <% if( (!isaffirmancebody.equals("1")|| reEditbody.equals("1")) ) { %>
            <td>
            <input type='checkbox' name='check_node' id='check_node' value="<%=RecordSet.getString("id")%>" <%if(!dtldelete.equals("1")){%>disabled<%}%>>
            <input type="hidden" name='check_node_val' value='<%=rowsum%>'>
            <span serialno>&nbsp;&nbsp;&nbsp;<%=i %></span>
            </td>
            <%}else{%>
            	&nbsp;
          	<%}%>
            
		<td <%if(dsptypes.indexOf("1_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("1_1")!=-1&&canedit){
            	String tempvalue = (RecordSet.getInt("capitalid")>0?RecordSet.getString("capitalid"):"");
            	String tempshowvalue = Util.toScreen(CapitalComInfo.getCapitalname(RecordSet.getString("capitalid")),user.getLanguage());
            	String isMustInput = "1";
	           	if(mandtypes.indexOf("1_1")!=-1){
	           		isMustInput = "2";
	           		needcheck+=",node_"+rowsum+"_capitalid";
	           	}
	           	String tempfieldname = "node_"+rowsum+"_capitalid";
            %>
            
            <brow:browser viewType="0" name='<%=tempfieldname %>' browserValue='<%= ""+tempvalue %>' 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata=2&cptstateid=1,2,3,4"
				hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='<%=isMustInput %>'
				completeUrl="/data.jsp?type=23&cptstateid=1,2,3,4" linkUrl="/cpt/capital/CptCapital.jsp?id="
				browserSpanValue='<%=tempshowvalue  %>' width='160px' _callBack="onSetCptCapital"></brow:browser>
            <!-- 
            <button class=Browser onClick='onShowAssetCapital(node_<%=rowsum%>_capitalidspan,node_<%=rowsum%>_capitalid,node_<%=rowsum%>_number,node_<%=rowsum%>_numberspan,node_<%=rowsum%>_count)'></button>
            <span id="node_<%=rowsum%>_capitalidspan">
            
        	 <% if(mandtypes.indexOf("1_1")!=-1 && RecordSet.getInt("capitalid")==0 ){%>
        	 			<img src='/images/BacoError_wev8.gif' align=absmiddle>
        	 <%}
        	 	if(mandtypes.indexOf("1_1")!=-1) needcheck+=",node_"+rowsum+"_capitalid";
        	 %>
        	 <a href='/cpt/capital/CptCapital.jsp?id=<%=RecordSet.getString("capitalid")%>'><%=Util.toScreen(CapitalComInfo.getCapitalname(RecordSet.getString("capitalid")),user.getLanguage())%></a>
         	 </span>
         	  -->
        	<%}else{%>
        	<a href='/cpt/capital/CptCapital.jsp?id=<%=RecordSet.getString("capitalid")%>'><%=Util.toScreen(CapitalComInfo.getCapitalname(RecordSet.getString("capitalid")),user.getLanguage())%></a>
         <%}%>
            <input type='hidden' name='node_<%=rowsum%>_capitalid' id='node_<%=rowsum%>_capitalid' value="<%=RecordSet.getString("capitalid")%>">
	        <%
             String tempStockAmount = "";
             SearchNumberRecordSet.executeSql("select capitalnum from CptCapital where id="+RecordSet.getString("capitalid"));
             if(SearchNumberRecordSet.next()) tempStockAmount = SearchNumberRecordSet.getString("capitalnum");
             %>
            <input type='hidden' name='node_<%=rowsum%>_count' id='node_<%=rowsum%>_count' value="<%=tempStockAmount%>">
	    </td>

            <td <%if(dsptypes.indexOf("2_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("2_1")!=-1&&canedit){
            	if(mandtypes.indexOf("2_1")!=-1){%>
            		<input class=Inputstyle type='text' name='node_<%=rowsum%>_number' id='node_<%=rowsum%>_number' value="<%=RecordSet.getString("numbers")%>"  onKeyPress='ItemNum_KeyPress()' onBlur="checknumber1(this);checkinput('node_<%=rowsum%>_number','node_<%=rowsum%>_numberspan');checkCount(<%=rowsum%>)">
            		<span id="node_<%=rowsum%>_numberspan">
            		<%if(RecordSet.getString("numbers").equals("")){%>
            		<img src="/images/BacoError_wev8.gif" align=absmiddle>
		         <%}
        	 	needcheck+=",node_"+rowsum+"_number";%>
		        </span>
		
		<%}else{%>
            		<input class=Inputstyle type='text' name='node_<%=rowsum%>_number' id='node_<%=rowsum%>_number' value="<%=RecordSet.getString("numbers")%>"  onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);checkCount(<%=rowsum%>)'>
            		<span id="node_<%=rowsum%>_numberspan"></span>
            	<%}%>
	    <%}else{%>
	    	<%=RecordSet.getString("numbers")%>
	    <input type='hidden' name='node_<%=rowsum%>_number' id='node_<%=rowsum%>_number' value="<%=RecordSet.getString("numbers")%>">
	    <span id="node_<%=rowsum%>_numberspan"></span>
	    <%}%>
	    </td>
            <td <%if(dsptypes.indexOf("3_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("3_1")!=-1&&canedit){%>
            <button class=e8_browflow type=button onClick='onBillCPTShowDate(node_<%=rowsum%>_needdatespan,node_<%=rowsum%>_needdate,<%=mandtypes.indexOf("3_1")%>)'></button>
            <span id=node_<%=rowsum%>_needdatespan>
            
        	 <% if(mandtypes.indexOf("3_1")!=-1 && RecordSet.getString("dates").equals("")){%>
        	 			<img src='/images/BacoError_wev8.gif' align=absmiddle>
        	 <%}
        	 	if(mandtypes.indexOf("3_1")!=-1) needcheck+=",node_"+rowsum+"_needdate";
        	 %><%=RecordSet.getString("dates")%>
            
        	 </span>
        	<%}else{%>
        	<%=RecordSet.getString("dates")%>
            <%}%>
	    <input type='hidden' name='node_<%=rowsum%>_needdate' id='node_<%=rowsum%>_needdate' value="<%=RecordSet.getString("dates")%>">
	    </td>
            <td <%if(dsptypes.indexOf("4_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("4_1")!=-1&&canedit){
            	if(mandtypes.indexOf("4_1")!=-1){%>
            		<input class=Inputstyle type='text' name='node_<%=rowsum%>_fee' id='node_<%=rowsum%>_fee' value="<%=RecordSet.getString("fee")%>"  onKeyPress='ItemNum_KeyPress()' onBlur=checknumber1(this);checkinput('node_<%=rowsum%>_fee','node_<%=rowsum%>_feespan')>
            		<span id="node_<%=rowsum%>_feespan">
            		<%if(RecordSet.getString("fee").equals("")){%>
            		<img src="/images/BacoError_wev8.gif" align=absmiddle>
		        <%}
        	 	needcheck+=",node_"+rowsum+"_fee";%>
		        </span>
		<%}else{%>
            		<input class=Inputstyle type='text' name='node_<%=rowsum%>_fee' onBlur='checknumber1(this);' id='node_<%=rowsum%>_fee' value="<%=RecordSet.getString("fee")%>">
            	<%}%>
	    <%}else{%>
	    <%=RecordSet.getString("fee")%>
	    <input type='hidden' name='node_<%=rowsum%>_fee' id='node_<%=rowsum%>_fee' value="<%=RecordSet.getString("fee")%>">
	    <%}%>
	    </td>
            <td <%if(dsptypes.indexOf("5_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf("5_1")!=-1&&canedit){
            	if(mandtypes.indexOf("5_1")!=-1){%>
            		<input class=Inputstyle type='text' name='node_<%=rowsum%>_remark' id='node_<%=rowsum%>_remark' value="<%=RecordSet.getString("remark")%>"  OnBlur=checkinput('node_<%=rowsum%>_remark','node_<%=rowsum%>_remarkspan')>
            		<span id="node_<%=rowsum%>_remarkspan">
            		<%if(RecordSet.getString("remark").equals("")){%>
            		<img src="/images/BacoError_wev8.gif" align=absmiddle>
		        <%}
        	 	needcheck+=",node_"+rowsum+"_remark";%>
		        </span>
		<%}else{%>
            		<input class=Inputstyle type='text' name='node_<%=rowsum%>_remark' id='node_<%=rowsum%>_remark' value="<%=Util.toScreenToEdit(RecordSet.getString("remark"),user.getLanguage())%>">
            	<%}%>
	    <%}else{%>
	    <%=Util.toScreen(RecordSet.getString("remark"),user.getLanguage())%><input type='hidden' name='node_<%=rowsum%>_remark' id='node_<%=rowsum%>_remark' value="<%=RecordSet.getString("remark")%>">
	    <%}%>
	    </td>
        </tr>
            <%if(linecolor==0) linecolor=1;
          else linecolor=0; rowsum++;}%>
  </table>
  <input  type ='hidden' id=nodesnum name=nodesnum value=<%=rowsum%>>
   <input type='hidden' id=rowneed name=rowneed value="<%=dtlneed %>">
  <!--<INPUT type="hidden" name="needcheck" value="<%=needcheck%>">-->
  <br>
 </wea:item>
</wea:group>
</wea:layout>  
  
<%@ include file="/workflow/request/WorkflowManageSign.jsp" %>
<input type="hidden" name="f_weaver_belongto_userid" value="<%=request.getParameter("f_weaver_belongto_userid") %>">
<input type="hidden" name="f_weaver_belongto_usertype" value="<%=request.getParameter("f_weaver_belongto_usertype") %>">
</form>
<script language=vbs>
sub onShowDate111(spanname,inputname)
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	spanname.innerHtml= returndate
	inputname.value=returndate
end sub

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

sub getBDate(ismand)
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	if	returndate="" and ismand=1 then
		document.all("begindatespan").innerHtml= "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	else
		document.all("begindatespan").innerHtml= returndate
	end if
	document.all("begindate").value=returndate
end sub
sub getEDate(ismand)
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	if	returndate="" and ismand=1 then
		document.all("enddatespan").innerHtml= "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	else	
		document.all("enddatespan").innerHtml= returndate
	end if
	document.all("enddate").value=returndate
end sub

sub getBTIme(ismand)
	returndate = window.showModalDialog("/systeminfo/Clock.jsp",,"dialogHeight:360px;dialogwidth:275px")
	if	returndate="" and ismand=1 then
		document.all("begintimespan").innerHtml= "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	else
		document.all("begintimespan").innerHtml= returndate
	end if
	document.all("begintime").value=returndate
end sub
sub getETime(ismand)
	returndate = window.showModalDialog("/systeminfo/Clock.jsp",,"dialogHeight:360px;dialogwidth:275px")
	if	returndate="" and ismand=1 then
		document.all("endtimespan").innerHtml= "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	else	
		document.all("endtimespan").innerHtml= returndate
	end if
	document.all("endtime").value=returndate
end sub
sub onShowAssetType(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp?supassortmentid="&groupid&"&fromcapital=2")
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
sub onShowAssetCapital(spanname,inputname,inputnumber,inputnumberspan,inputcount)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata='2'&cptstateid=1,2,3,4")
	if NOT isempty(id) then
	    if id(0)<> "" and id(0)<> "0" then
		spanname.innerHtml = "<a href='/cpt/capital/CptCapital.jsp?id="&id(0)&"'>"&id(1)&"</a>"
		inputname.value=id(0)
        inputnumber.value=id(7)
        inputcount.value=id(7)
        inputnumberspan.innerHtml =  ""
		else
		spanname.innerHtml =  "<img src='/images/BacoError_wev8.gif' align=absmiddle>"
		inputname.value=""
		end if
	end if
end sub
sub onShowCptCapital(spanname,inputname,inputnumber,inputnumberspan,inputcount)
	mand = 1
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata='2'&cptstateid=1,2,3,4")
	if NOT isempty(id) then
	    if id(0)<> "" and id(0)<> "0" then
		spanname.innerHtml = "<a href='/cpt/capital/CptCapital.jsp?id="&id(0)&"'>"&id(1)&"</a>"
		inputname.value=id(0)
        inputnumber.value=id(7)
        inputcount.value=id(7)
        inputnumberspan.innerHtml =  ""
		else
		if mand=1 then
		spanname.innerHtml =  "<img src='/images/BacoError_wev8.gif' align=absmiddle>"
		else 
		spanname.innerHtml =  ""
		end if
		inputname.value=""
		end if
	end if
end sub
sub onShowDate(spanname,inputname)
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	spanname.innerHtml= returndate
	inputname.value=returndate
end sub
</script>   
<script language=javascript>
groupid = <%=groupid%>;
rowindex = document.frmmain.nodesnum.value;
needcheck = "<%=needcheck%>";
document.all("needcheck").value = needcheck;
function addRow()
{
	ncol = 6;
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
					//sHtml = "<button class=Browser onClick='onShowCptCapital(node_"+rowindex+"_capitalidspan,node_"+rowindex+"_capitalid,node_"+rowindex+"_number,node_"+rowindex+"_numberspan,node_"+rowindex+"_capitalcount)'></button> " + 
        			//		"<span id=node_"+rowindex+"_capitalidspan>";
        			oDiv.innerHTML="<div class='e8Browser'></div><input type='hidden' name='node_"+rowindex+"_capitalcount' id='node_"+rowindex+"_capitalcount'>";
        			oCell.appendChild(oDiv);
			        try
			        {
			        	var tempisMustInput = "1";
			        	if(mandtypes.indexOf("1_1")!=-1){
        					tempisMustInput = "2";
        					needcheck += ","+"node_"+rowindex+"_capitalid";
        				}
				       	jQuery(oDiv).find(".e8Browser").e8Browser({
						   name:"node_"+rowindex+"_capitalid",
						   viewType:"0",
						   browserValue:"",
						   isMustInput:tempisMustInput,
						   browserSpanValue:"",
						   getBrowserUrlFn:'onShowTableUrl',
						   getBrowserUrlFnParams:"",
						   hasInput:true,
						   linkUrl:"#",
						   isSingle:true,
						   completeUrl:"/data.jsp?type=23&cptstateid=1,2,3,4",
						   browserUrl:"",
						   width:'160px',
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
					if(mandtypes.indexOf("2_1")!=-1){ 
						sHtml = "<input class=Inputstyle type='text' class=Inputstyle  id='node_"+rowindex+"_number' name='node_"+rowindex+"_number' onKeyPress='ItemNum_KeyPress()' onBlur=\"checknumber1(this);checkinput('node_"+rowindex+"_number','node_"+rowindex+"_numberspan');onchange=checkCount("+rowindex+")\"><span id='node_"+rowindex+"_numberspan'>";
						sHtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
						sHtml+="</span>";
        					needcheck += ","+"node_"+rowindex+"_number";
        				}else{
        					sHtml = "<input class=Inputstyle type='text' class=Inputstyle  id='node_"+rowindex+"_number' name='node_"+rowindex+"_number' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);checkCount("+rowindex+")'><span id='node_"+rowindex+"_numberspan'></span>";
        				}
	        			oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				}else{
                    sHtml = "<input type='hidden' class=Inputstyle id='node_"+rowindex+"_number'  name='node_"+rowindex+"_number'><span id='node_"+rowindex+"_numberspan'></span>";
	        	    oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv); 
                }
				break;
				
			case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("3_1")!=-1){
					sHtml = "<button class=e8_browflow type=button onClick='onBillCPTShowDate(node_"+rowindex+"_needdatespan,node_"+rowindex+"_needdate,"+mandtypes.indexOf("3_1")+")'></button> " + 
						"<span id=node_"+rowindex+"_needdatespan> ";
					if(mandtypes.indexOf("3_1")!=-1){
        					sHtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_needdate";
        				}
        				sHtml+="</span>"
        				sHtml += "<input type='hidden' name='node_"+rowindex+"_needdate' id='node_"+rowindex+"_needdate'>";
        				oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
        			}
				break;
				
			case 4: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("4_1")!=-1){
					if(mandtypes.indexOf("4_1")!=-1){
						sHtml = "<input class=Inputstyle type='text' class=Inputstyle   name='node_"+rowindex+"_fee'  onKeyPress='ItemNum_KeyPress()' onBlur=checknumber1(this);checkinput('node_"+rowindex+"_fee','node_"+rowindex+"_feespan')><span id='node_"+rowindex+"_feespan'>";
						sHtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_fee";
        					sHtml+="</span>"
        				}else{
        					sHtml = "<input class=Inputstyle type='text' onBlur='checknumber1(this);' class=Inputstyle  name='node_"+rowindex+"_fee'>";
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
						sHtml = "<input class=Inputstyle type='text' class=Inputstyle   name='node_"+rowindex+"_remark'  onKeyPress='ItemNum_KeyPress()' onBlur=checkinput('node_"+rowindex+"_remark','node_"+rowindex+"_remarkspan')><span id='node_"+rowindex+"_remarkspan'>";
						sHtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_remark";
        					sHtml+="</span>"
        				}else{
        					sHtml = "<input class=Inputstyle type='text' class=Inputstyle   name='node_"+rowindex+"_remark'>";
        				}
        				
        				oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
        			}
				break;
				
		}
	}
	document.all("needcheck").value = needcheck;
	rowindex = rowindex*1 +1;
	document.frmmain.nodesnum.value = rowindex ;
}

function checkCount(index){
    var stockamount = document.all("node_"+index+"_count").value;
    var useamount = document.all("node_"+index+"_number").value;
    if(eval(useamount)>eval(stockamount)){
        alert("<%=SystemEnv.getHtmlLabelName(15313,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1446,user.getLanguage())%>");
        document.all("node_"+index+"_number").value = stockamount;
    }
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
                        oTable.deleteRow(rowsum1);
						sumnum -=1;	
                    }
                    rowsum1 -=1;
                }
            }
			//document.frmmain.nodesnum.value = sumnum ;
			reloadSerialNum();
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
function onShowTableUrl()
{
	return "/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata='2'&cptstateid=1,2,3,4";
}
function onSetCptCapital(event,data,name)
{
	var obj= event.target || event.srcElement;
	try
	{
		var rowindex = 0;
		var namearr=name.split("_");
		if(namearr&&namearr[1]){
			rowindex=namearr[1];
		}
		if (data) 
		{
			if (wuiUtil.getJsonValueByIndex(data, 0) != "") 
			{
				jQuery("#node_"+rowindex+"_capitalidspan").html("<a href='/cpt/capital/CptCapital.jsp?id="+data.id+"' target='_blank'>"+data.name+"</a>");
				jQuery("#node_"+rowindex+"_capitalid").val(data.id);
		        jQuery("#node_"+rowindex+"_number").val(data.other6);
		        jQuery("#node_"+rowindex+"_capitalcount").val(data.other6);
		        jQuery("#node_"+rowindex+"_numberspan").html("");
		    }
			else
			{
				//jQuery("#node_"+rowindex+"_capitalidspan").html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
				jQuery("#node_"+rowindex+"_capitalid").val('');
			}
		}
	}
	catch(e)
	{
	}
}
</script>

</body>
</html>
