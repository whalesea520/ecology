<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.browserData.BrowserManager"%>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<%@ include file="/workflow/request/WorkflowManageRequestTitle.jsp" %>
<jsp:useBean id="WFNodeDtlFieldManager" class="weaver.workflow.workflow.WFNodeDtlFieldManager" scope="page" />
<form name="frmmain" method="post" action="BillCptApplyOperation.jsp" enctype="multipart/form-data">
<input type="hidden" name="needwfback" id="needwfback" value="1" />
<input type="hidden" name="lastOperator"  id="lastOperator" value="<%=lastOperator%>"/>
<input type="hidden" name="lastOperateDate"  id="lastOperateDate" value="<%=lastOperateDate%>"/>
<input type="hidden" name="lastOperateTime"  id="lastOperateTime" value="<%=lastOperateTime%>"/>

<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/interface/CptDwrUtil.js'></script>
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
String totalamountsum = "" ;
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
	if( !theviewtype.equals("1") ){
		if("totalamount".equals(RecordSet.getString("fieldname"))){
			totalamountsum = "field"+RecordSet.getString("id");
		}
		continue ;
	}    // 如果是单据的主表字段,不显示
	fieldids.add(RecordSet.getString("id"));
	fieldnames.add(RecordSet.getString("fieldname"));
	fieldlabels.add(RecordSet.getString("fieldlabel"));
	fieldhtmltypes.add(RecordSet.getString("fieldhtmltype"));
	fieldtypes.add(RecordSet.getString("type"));
	viewtypes.add(RecordSet.getString("viewtype"));
	//System.out.println("==RecordSet.getString()=="+RecordSet.getString("viewtype"));
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
		<%}}%>
		</wea:item>
		<wea:item attributes="{\"isTableList\":\"true\"}">
            <table Class="ListStyle" cellspacing=1 cols=11 id="oTable">
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
    	  
            <td <%if(isview.equals("0")){%> style="display:none" <%}%> width="<%=viewCount<=0?0:95/viewCount%>%"><%=Util.toScreen(fieldlable,user.getLanguage())%></td>
<%}%>
            </tr>
    	   
            <%
            
	           int linecolor=0;  
            int i=0;
	RecordSet.executeProc("bill_CptApplyDetail_Select",billid+"");
	
	while(RecordSet.next()){
		i++;
            %>
            <tr <%if(linecolor==0){%> class=DataLight <%} else {%> class=DataDark <%}%> > 
            	
			      <% if( (!isaffirmancebody.equals("1")|| reEditbody.equals("1")) ) { %>
            <td width="7%">
            <input type='checkbox' name='check_node' id='check_node' value="<%=RecordSet.getString("id")%>" <%if(!dtldelete.equals("1")){%>disabled<%}%>>
            <input type="hidden" name='check_node_val' value='<%=rowsum%>'>
            <span serialno>&nbsp;&nbsp;&nbsp;<%=i %></span>
            </td>
            <%}else{%>
            	&nbsp;
          	<%}%>
          	
            <td <%if(dsptypes.indexOf(","+"1_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf(","+"1_1")!=-1&&canedit){
            	String tempvalue = (RecordSet.getInt("cpttype")>0?RecordSet.getString("cpttype"):"");
            	String tempshowvalue = Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(RecordSet.getString("cpttype")),user.getLanguage());
            	String isMustInput = "1";
	           	if(mandtypes.indexOf(","+"1_1")!=-1){
	           		isMustInput = "2";
	           	 	needcheck+=",node_"+rowsum+"_cpttypeid";
	           	}
	           	String tempfieldname = "node_"+rowsum+"_cpttypeid";
            %>
            <!--
            <button class=Browser onClick='onShowAssetType(node_<%=rowsum%>_cpttypespan,node_<%=rowsum%>_cpttypeid,<%if(mandtypes.indexOf("1_1")!=-1) {%>1<%} else {%>0<%}%>)'></button>
            <span class=Inputstyle id=node_<%=rowsum%>_cpttypespan>
         	 </span>-->
         	 <brow:browser viewType="0" name='<%=tempfieldname %>' browserValue='<%= ""+tempvalue %>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp"
								hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='<%=isMustInput %>'
								completeUrl="/data.jsp" linkUrl=""
								browserSpanValue='<%=tempshowvalue  %>' width='150px' _callBack="onSetCptCapital"></brow:browser>
        	<%}else{%>
        	<%=Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(RecordSet.getString("cpttype")),user.getLanguage())%>
        	<input type='hidden' name='node_<%=rowsum%>_cpttypeid' id='node_<%=rowsum%>_cpttypeid' value="<%=(RecordSet.getInt("cpttype")>0?RecordSet.getString("cpttype"):"")%>">
         	<%}%>
	    </td>
	    
	    <td <%if(dsptypes.indexOf(","+"2_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf(","+"2_1")!=-1&&canedit){
            	String tempvalue = (RecordSet.getInt("cptid")>0?RecordSet.getString("cptid"):"");
            	String tempshowvalue = Util.toScreen(CapitalComInfo.getCapitalname(RecordSet.getString("cptid")),user.getLanguage());
            	String isMustInput = "1";
	           	if(mandtypes.indexOf(","+"2_1")!=-1){
	           		isMustInput = "2";
	           		needcheck+=",node_"+rowsum+"_cptid";
	           	}
	           	String tempfieldname = "node_"+rowsum+"_cptid";
            %>
        	 <brow:browser viewType="0" name='<%=tempfieldname %>' browserValue='<%= ""+tempvalue %>' 
								getBrowserUrlFn='onShowTableUrl1'
								hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='<%=isMustInput %>'
								completeUrl="/data.jsp" linkUrl="/cpt/capital/CptCapital.jsp?id="
								browserSpanValue='<%=tempshowvalue  %>' width='150px' _callBack="onSetCptCapital1"></brow:browser>
        	<%}else{%>
	         <a href='/cpt/capital/CptCapital.jsp?id=<%=RecordSet.getString("cptid")%>'><%=Util.toScreen(CapitalComInfo.getCapitalname(RecordSet.getString("cptid")),user.getLanguage())%> </a>
	         <input type='hidden' name='node_<%=rowsum%>_cptid' id='node_<%=rowsum%>_cptid' value="<%=(RecordSet.getInt("cptid")>0?RecordSet.getString("cptid"):"")%>">
         <%}%>
            
	    </td>
		 <td <%if(dsptypes.indexOf(","+"3_0")!=-1){%> style="display:none" <%}%>>           
            <% if(edittypes.indexOf(","+"3_1")!=-1&&canedit){
            	String tempvalue = (RecordSet.getInt("capitalid")>0?RecordSet.getString("capitalid"):"");
            	String tempshowvalue = Util.toScreen(CapitalComInfo.getCapitalname(RecordSet.getString("capitalid")),user.getLanguage());
            	String isMustInput = "1";
	           	if(mandtypes.indexOf(","+"3_1")!=-1){
	           		isMustInput = "2";
	           		needcheck+=",node_"+rowsum+"_cptcapitalid";
	           	}
	           	String tempfieldname = "node_"+rowsum+"_cptcapitalid";
            %>
        	 <brow:browser viewType="0" name='<%=tempfieldname %>' browserValue='<%= ""+tempvalue %>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp"
								hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='<%=isMustInput %>'
								completeUrl="/data.jsp?type=23" linkUrl="/cpt/capital/CptCapital.jsp?id="
								browserSpanValue='<%=tempshowvalue  %>' width='150px' _callBack="onSetCptCapital2"></brow:browser>
        	<%} else {%>
			 <a href='/cpt/capital/CptCapital.jsp?id=<%=RecordSet.getString("capitalid")%>'><%=Util.toScreen(CapitalComInfo.getCapitalname(RecordSet.getString("capitalid")),user.getLanguage())%> </a>
			 <input type='hidden' name='node_<%=rowsum%>_cptcapitalid' id='node_<%=rowsum%>_cptcapitalid' value="<%=(RecordSet.getInt("capitalid")>0?RecordSet.getString("capitalid"):"")%>">
			<%}%>
	    
	    </td>

            <td <%if(dsptypes.indexOf(","+"4_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf(","+"4_1")!=-1&&canedit){
            	if(mandtypes.indexOf(","+"4_1")!=-1){%>
            		<input type='text' class=inputstyle   name='node_<%=rowsum%>_number' id='node_<%=rowsum%>_number' value="<%=RecordSet.getString("number_n")%>"  onKeyPress='ItemNum_KeyPress()' onBlur=checkinput('node_<%=rowsum%>_number','node_<%=rowsum%>_numberspan');changeamountsum('node_<%=rowsum%>')>
            		<span id="node_<%=rowsum%>_numberspan">
            		<%if(RecordSet.getString("number_n").equals("")){%>
            		<img src="/images/BacoError_wev8.gif" align=absmiddle>
		         <%
        	 	}needcheck+=",node_"+rowsum+"_number";
        	 	%>
		        </span>
		<%}else{%>
            		<input type='text' class=inputstyle   name='node_<%=rowsum%>_number' id='node_<%=rowsum%>_number' value="<%=RecordSet.getString("number_n")%>" onKeyPress='ItemNum_KeyPress()'  onblur=checknumber('node_<%=rowsum%>_number');changeamountsum('node_<%=rowsum%>')>
            	<%}%>
	    <%}else{%>
	    	<span id="node_<%=rowsum%>_numberspan"><%=RecordSet.getString("number_n")%></span>
	    <input type='hidden' name='node_<%=rowsum%>_number' id='node_<%=rowsum%>_number' value="<%=RecordSet.getString("number_n")%>">
	    <%}%>
	    </td>
            <td <%if(dsptypes.indexOf(","+"5_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf(","+"5_1")!=-1&&canedit){
            	if(mandtypes.indexOf(","+"5_1")!=-1){%>
            		<input type='text' class=inputstyle   name='node_<%=rowsum%>_unitprice' id='node_<%=rowsum%>_unitprice' value="<%=RecordSet.getString("unitprice")%>"  onKeyPress='ItemNum_KeyPress()' onBlur=checkinput('node_<%=rowsum%>_unitprice','node_<%=rowsum%>_unitpricespan');changeamountsum('node_<%=rowsum%>')>
            		<span id="node_<%=rowsum%>_unitpricespan">
            		<%if(RecordSet.getString("unitprice").equals("")){%>
            		<img src="/images/BacoError_wev8.gif" align=absmiddle>
		        <%
        	 	}needcheck+=",node_"+rowsum+"_unitprice";
        	 	%>
		        </span>
		<%}else{%>
            		<input type='text' class=inputstyle   name='node_<%=rowsum%>_unitprice' id='node_<%=rowsum%>_unitprice' value="<%=RecordSet.getString("unitprice")%>" onKeyPress='ItemNum_KeyPress()' onblur=checknumber('node_<%=rowsum%>_unitprice');changeamountsum('node_<%=rowsum%>')>
            	<%}%>
	    <%}else{%>
	    <span id="node_<%=rowsum%>_unitpricespan"><%=RecordSet.getString("unitprice")%></span>
	    <input type='hidden' name='node_<%=rowsum%>_unitprice' id='node_<%=rowsum%>_unitprice' value="<%=RecordSet.getString("unitprice")%>">
	    <%}%>
	    </td>
            <td <%if(dsptypes.indexOf(","+"6_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf(","+"6_1")!=-1&&canedit){
            	if(mandtypes.indexOf(","+"6_1")!=-1){%>
            		<input type='text' class=inputstyle   name='node_<%=rowsum%>_amount' id='node_<%=rowsum%>_amount' value="<%=RecordSet.getString("amount")%>"  onKeyPress='ItemNum_KeyPress()' onBlur=checkinput('node_<%=rowsum%>_amount','node_<%=rowsum%>_amountspan')>
            		<span id="node_<%=rowsum%>_amountspan">
            		<%if(RecordSet.getString("amount").equals("")){%>
            		<img src="/images/BacoError_wev8.gif" align=absmiddle>
		        <%
        	 	}needcheck+=",node_"+rowsum+"_amount";
        	 	%>
		        </span>
		<%}else{%>
            		<input type='text' class=inputstyle   name='node_<%=rowsum%>_amount' id='node_<%=rowsum%>_amount' value="<%=RecordSet.getString("amount")%>" onKeyPress='ItemNum_KeyPress()' onblur=checknumber('node_<%=rowsum%>_amount')>
            	<%}%>
	    <%}else{%>
	   <span id="node_<%=rowsum%>_amountspan"><%=RecordSet.getString("amount")%></span>
	    <input type='hidden' name='node_<%=rowsum%>_amount' id='node_<%=rowsum%>_amount' value="<%=RecordSet.getString("amount")%>">
	    <%}%>
	    </td>
	    
            <td <%if(dsptypes.indexOf(","+"7_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf(","+"7_1")!=-1&&canedit){
            	if(mandtypes.indexOf(","+"7_1")!=-1){%>
            		<input type='text' class=inputstyle   name='node_<%=rowsum%>_cptspec' id='node_<%=rowsum%>_cptspec' value="<%=RecordSet.getString("cptspec")%>"  OnBlur=checkinput('node_<%=rowsum%>_cptspec','node_<%=rowsum%>_cptspecspan')>
            		<span id="node_<%=rowsum%>_cptspecspan">
            		<%if(RecordSet.getString("cptspec").equals("")){%>
            		<img src="/images/BacoError_wev8.gif" align=absmiddle>
		        <%
        	 	}needcheck+=",node_"+rowsum+"_cptspec";
        	 	%>
		        </span>
		<%}else{%>
            		<input type='text' class=inputstyle   name='node_<%=rowsum%>_cptspec' id='node_<%=rowsum%>_cptspec' value="<%=Util.toScreenToEdit(RecordSet.getString("cptspec"),user.getLanguage())%>">
            	<%}%>
	    <%}else{%>
	    <span id='node_<%=rowsum%>_cptspecspan'><%=Util.toScreen(RecordSet.getString("cptspec"),user.getLanguage())%></span>
	    <input type='hidden' name='node_<%=rowsum%>_cptspec' id='node_<%=rowsum%>_cptspec' value="<%=RecordSet.getString("cptspec")%>">
	    <%}%>
	    </td>
	    
            <td <%if(dsptypes.indexOf(","+"8_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf(","+"8_1")!=-1&&canedit){%>
            <button class=e8_browflow type=button onClick='onShowDate1(node_<%=rowsum%>_needdatespan,node_<%=rowsum%>_needdate,<%if(mandtypes.indexOf("7_1")!=-1) {%>1<%} else {%>0<%}%>)'></button>
            <span class=Inputstyle id=node_<%=rowsum%>_needdatespan>
            
        	 <% if(mandtypes.indexOf(","+"8_1")!=-1 ){
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
            <td <%if(dsptypes.indexOf(","+"9_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf(","+"9_1")!=-1&&canedit){
            	if(mandtypes.indexOf(","+"9_1")!=-1){%>
            		<input type='text' class=inputstyle   name='node_<%=rowsum%>_purpose' id='node_<%=rowsum%>_purpose' value="<%=RecordSet.getString("purpose")%>"  OnBlur=checkinput('node_<%=rowsum%>_purpose','node_<%=rowsum%>_purposespan')>
            		<span id="node_<%=rowsum%>_purposespan">
            		<%if(RecordSet.getString("purpose").equals("")){%>
            		<img src="/images/BacoError_wev8.gif" align=absmiddle>
		        <%
        	 	}needcheck+=",node_"+rowsum+"_purpose";
        	 	%>
		        </span>
		<%}else{%>
            		<input type='text' class=inputstyle   name='node_<%=rowsum%>_purpose' id='node_<%=rowsum%>_purpose' value="<%=Util.toScreenToEdit(RecordSet.getString("purpose"),user.getLanguage())%>">
            	<%}%>
	    <%}else{%>
	    <%=Util.toScreen(RecordSet.getString("purpose"),user.getLanguage())%><input type='hidden' name='node_<%=rowsum%>_purpose' id='node_<%=rowsum%>_purpose' value="<%=RecordSet.getString("purpose")%>">
	    <%}%>
	    </td>
            <td <%if(dsptypes.indexOf(","+"10_0")!=-1){%> style="display:none" <%}%>>
            <% if(edittypes.indexOf(","+"10_1")!=-1&&canedit){
            	if(mandtypes.indexOf(","+"10_1")!=-1){%>
            		<input type='text' class=inputstyle   name='node_<%=rowsum%>_cptdesc' id='node_<%=rowsum%>_cptdesc' value="<%=RecordSet.getString("cptdesc")%>"  OnBlur=checkinput('node_<%=rowsum%>_cptdesc','node_<%=rowsum%>_cptdescspan')>
            		<span id="node_<%=rowsum%>_cptdescspan">
            		<%if(RecordSet.getString("cptdesc").equals("")){%>
            		<img src="/images/BacoError_wev8.gif" align=absmiddle>
		        <%
        	 	}needcheck+=",node_"+rowsum+"_cptdesc";
        	 	%>
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

<!-- modify by xhheng @20050328 for TD 1703-->

<br>
<%@ include file="/workflow/request/WorkflowManageSign.jsp" %>
<input type="hidden" name="f_weaver_belongto_userid" value="<%=request.getParameter("f_weaver_belongto_userid") %>">
<input type="hidden" name="f_weaver_belongto_usertype" value="<%=request.getParameter("f_weaver_belongto_usertype") %>">
</form>
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

sub onShowAssetCapital(spanname,inputname,mand)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp")
	if NOT isempty(id) then
	    if id(0)<> "" and id(0)<> "0" then
		spanname.innerHtml = "<a href='/cpt/capital/CptCapital.jsp?id="&id(0)&"' target='_blank'>"&id(1)&"</a>"
		inputname.value=id(0)
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

sub onShowAsset(spanname,inputname,mand)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata='1' ")
	if NOT isempty(id) then
	    if id(0)<> "" and id(0)<> "0" then
		spanname.innerHtml = "<a href='/cpt/capital/CptCapital.jsp?id="&id(0)&"' target='_blank'>"&id(1)&"</a>"
		inputname.value=id(0)
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

sub onShowAssetType(spanname,inputname,mand)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp")
	if NOT isempty(id) then
	    if id(0)<> "" and id(0)<> "0" then
		spanname.innerHtml = id(1)
		inputname.value=id(0)
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

</script>   

<script language=javascript>
if ("<%=needcheck%>" != ""){
    document.all("needcheck").value += ","+"<%=needcheck%>";
}

groupid = <%=groupid%>;

rowindex = document.frmmain.nodesnum.value ;
needcheck = "<%=needcheck%>";
function addRow()
{
	ncol = 11;
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
		if(dsptypes.indexOf(","+j+"_0")!=-1){
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
				if(edittypes.indexOf(","+"1_1")!=-1){
					oDiv.innerHTML="<div class='e8Browser'></div>";
        			oCell.appendChild(oDiv);
        			var tempisMustInput = "1";
        			if(mandtypes.indexOf(","+"1_1")!=-1){
       					tempisMustInput = "2";
       					needcheck += ","+"node_"+rowindex+"_cpttypeid";
       				}
					
					jQuery(oDiv).find(".e8Browser").e8Browser({
						   name:"node_"+rowindex+"_cpttypeid",
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
				break;

			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf(","+"2_1")!=-1){
					oDiv.innerHTML="<div class='e8Browser'></div>";
        			oCell.appendChild(oDiv);
        			var tempisMustInput = "1";
        			if(mandtypes.indexOf(","+"2_1")!=-1){
       					tempisMustInput = "2";
       					needcheck += ","+"node_"+rowindex+"_cptid";
       				}
					
					jQuery(oDiv).find(".e8Browser").e8Browser({
						   name:"node_"+rowindex+"_cptid",
						   viewType:"0",
						   browserValue:"",
						   isMustInput:tempisMustInput,
						   browserSpanValue:"",
						   getBrowserUrlFn:'onShowTableUrl1',
						   getBrowserUrlFnParams:"",
						   hasInput:true,
						   linkUrl:"#",
						   isSingle:true,
						   completeUrl:"/data.jsp?type=23&isdata=1",
						   browserUrl:"",
						   width:'90%',
						   hasAdd:false,
						   isSingle:true,
						   _callback:"onSetCptCapital1"
					});
				}
				break;

			case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf(","+"3_1")!=-1){
					oDiv.innerHTML="<div class='e8Browser'></div>";
        			oCell.appendChild(oDiv);
        			var tempisMustInput = "1";
        			if(mandtypes.indexOf(","+"3_1")!=-1){
       					tempisMustInput = "2";
       					needcheck += ","+"node_"+rowindex+"_cptcapitalid";
       				}
					
					jQuery(oDiv).find(".e8Browser").e8Browser({
						   name:"node_"+rowindex+"_cptcapitalid",
						   viewType:"0",
						   browserValue:"",
						   isMustInput:tempisMustInput,
						   browserSpanValue:"",
						   getBrowserUrlFn:'onShowTableUrl2',
						   getBrowserUrlFnParams:"",
						   hasInput:true,
						   linkUrl:"#",
						   isSingle:true,
						   completeUrl:"/data.jsp?type=23",
						   browserUrl:"",
						   width:'90%',
						   hasAdd:false,
						   isSingle:true,
						   _callback:"onSetCptCapital2"
					});
				}
				break;

			case 4: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf(","+"4_1")!=-1){
					if(mandtypes.indexOf(","+"4_1")!=-1){ 
						sHtml = "<input type='text' class=inputstyle  name='node_"+rowindex+"_number' id='node_"+rowindex+"_number' onKeyPress='ItemNum_KeyPress()' onBlur=checkinput('node_"+rowindex+"_number','node_"+rowindex+"_numberspan');changeamountsum('node_"+rowindex+"')><span id='node_"+rowindex+"_numberspan'>";
						sHtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
						sHtml+="</span>";
        					needcheck += ","+"node_"+rowindex+"_number";
        				}else{
        					sHtml = "<input type='text' class=inputstyle   name='node_"+rowindex+"_number' id='node_"+rowindex+"_number'  onKeyPress='ItemNum_KeyPress()' onblur=checknumber('node_"+rowindex+"_number');changeamountsum('node_"+rowindex+"')>";
        				}
				}else{
                    sHtml = "<input type='hidden' class=Inputstyle  name='node_"+rowindex+"_number' id='node_"+rowindex+"_number'><span id='node_"+rowindex+"_numberspan'></span>";
                }
	        		oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				break;
			case 5: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf(","+"5_1")!=-1){
					if(mandtypes.indexOf(","+"5_1")!=-1){
						sHtml = "<input type='text' class=inputstyle    name='node_"+rowindex+"_unitprice'  id='node_"+rowindex+"_unitprice'  onKeyPress='ItemNum_KeyPress()' onBlur=checkinput('node_"+rowindex+"_unitprice','node_"+rowindex+"_unitpricespan');changeamountsum('node_"+rowindex+"')><span id='node_"+rowindex+"_unitpricespan'>";
						sHtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_unitprice";
        					sHtml+="</span>"
        				}else{
        					sHtml = "<input type='text' class=inputstyle    name='node_"+rowindex+"_unitprice'  id='node_"+rowindex+"_unitprice' onKeyPress='ItemNum_KeyPress()' onblur=checknumber('node_"+rowindex+"_unitprice');changeamountsum('node_"+rowindex+"')>";
        				}
        				
        			}else{
        				sHtml = "<input type='hidden' class=Inputstyle  name='node_"+rowindex+"_unitprice'  id='node_"+rowindex+"_unitprice'><span id='node_"+rowindex+"_unitpricespan'></span>";	
            		}
        			oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				break;
			case 6: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf(","+"6_1")!=-1){
					if(mandtypes.indexOf(","+"6_1")!=-1){
						sHtml = "<input type='text' class=inputstyle    name='node_"+rowindex+"_amount' id='node_"+rowindex+"_amount'  onKeyPress='ItemNum_KeyPress()' onBlur=checkinput('node_"+rowindex+"_amount','node_"+rowindex+"_amountspan')><span id='node_"+rowindex+"_amountspan'>";
						sHtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_amount";
        					sHtml+="</span>"
        				}else{
        					sHtml = "<input type='text' class=inputstyle    name='node_"+rowindex+"_amount' id='node_"+rowindex+"_amount' onKeyPress='ItemNum_KeyPress()' onblur=checknumber('node_"+rowindex+"_amount')>";
        				}
        				
        			}else{
        				sHtml = "<input type='hidden' class=Inputstyle  name='node_"+rowindex+"_amount' id='node_"+rowindex+"_amount'><span id='node_"+rowindex+"_amountspan'></span>";
            		}
        			oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				break;
			
			case 7: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf(","+"7_1")!=-1){
					if(mandtypes.indexOf(","+"7_1")!=-1){
						sHtml = "<input type='text' class=Inputstyle  name='node_"+rowindex+"_cptspec' id='node_"+rowindex+"_cptspec' onBlur=checkinput('node_"+rowindex+"_cptspec','node_"+rowindex+"_cptspecspan')><span id='node_"+rowindex+"_cptspecspan'>";
						sHtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_cptspec";
        					sHtml+="</span>"        				
        				}else{
        					sHtml = "<input type='text' class=Inputstyle  name='node_"+rowindex+"_cptspec' id='node_"+rowindex+"_cptspec'>";
        				}
        			}else{
        					sHtml = "<input type='hidden' class=Inputstyle id='node_"+rowindex+"_cptspec'  name='node_"+rowindex+"_cptspec'><span id='node_"+rowindex+"_cptspecspan'></span>";
        			}
        			oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				break;
				
			case 8: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf(","+"8_1")!=-1){
					sHtml = "<button class=e8_browflow type=button onClick='onBillCPTShowDate(node_"+rowindex+"_needdatespan,node_"+rowindex+"_needdate,"+mandtypes.indexOf("7_1")+")')'></button> " + 
						"<span class=Inputstyle id=node_"+rowindex+"_needdatespan> ";
					if(mandtypes.indexOf(","+"8_1")!=-1){
        					sHtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_needdate";
        				}
        				sHtml+="</span>"
        				sHtml += "<input type='hidden' name='node_"+rowindex+"_needdate' id='node_"+rowindex+"_needdate'>";
        				oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
        			}
				break;
			
			case 9: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf(","+"9_1")!=-1){
					if(mandtypes.indexOf(","+"9_1")!=-1){
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
				
			case 10: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";;
				if(edittypes.indexOf(","+"10_1")!=-1){
					if(mandtypes.indexOf(","+"10_1")!=-1){
						sHtml = "<input type='text' class=Inputstyle  name='node_"+rowindex+"_cptdesc' onBlur=checkinput('node_"+rowindex+"_cptdesc','node_"+rowindex+"_cptdescspan')><span id='node_"+rowindex+"_cptdescspan'>";
						sHtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_cptdesc";
        					sHtml+="</span>"        				
        				}else{
        					sHtml = "<input type='text' class=Inputstyle  name='node_"+rowindex+"_cptdesc'>";
        				}
        				oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
        			}
				break;	
				
		}
	}
    //if ("<%=needcheck%>" != ""){
        document.all("needcheck").value += ","+needcheck;
    //}
	rowindex = rowindex*1+1;
	document.frmmain.nodesnum.value = rowindex ;
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
		var rowindex = 0;
		var namearr=name.split("_");
		if(namearr&&namearr[1]){
			rowindex=namearr[1];
		}
		
		if (data) 
		{
			if (wuiUtil.getJsonValueByIndex(data, 0) != "") 
			{
				jQuery("#node_"+rowindex+"_cpttypeidspan").html(data.name);
				jQuery("#node_"+rowindex+"_cpttypeid").val(data.id);
		    }
			else
			{
				if(ismust1)
				{
					//jQuery("#node_"+rowindex+"_cpttypeidspan").html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
					jQuery("#node_"+rowindex+"_cpttypeid").val('');
				}
				else
				{
					jQuery("#node_"+rowindex+"_cpttypeidspan").html("");
					jQuery("#node_"+rowindex+"_cpttypeid").val('');
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
	return "/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata='1' ";
}
function onSetCptCapital1(event,data,name)
{
	
	var ismust1 = <%=mandtypes.indexOf("2_1")!=-1%>;
	var editspec = <%=edittypes.indexOf("7_1")!=-1%>;
	var mandspec = <%=mandtypes.indexOf("7_1")!=-1%>;
	var editunitprice = <%=edittypes.indexOf("5_1")!=-1%>;//单价
	var mandunitprice = <%=mandtypes.indexOf("5_1")!=-1%>;
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
				if(data.id!=''){
					CptDwrUtil.getCptInfoMap(data.id,function(data){
						if(editspec){
							jQuery("#node_"+rowindex+"_cptspec").val(data.capitalspec);
							if(mandspec){
								if(data.capitalspec==""){
									jQuery("#node_"+rowindex+"_cptspecspan").html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
								}else{
									jQuery("#node_"+rowindex+"_cptspecspan").html("");
								}
							}
						}else{
							jQuery("#node_"+rowindex+"_cptspec").val(data.capitalspec);
							jQuery("#node_"+rowindex+"_cptspecspan").html(data.capitalspec);
						}
						/**单价 start */
						if(editunitprice){
							jQuery("#node_"+rowindex+"_unitprice").val(data.startprice);
							if(mandunitprice){
								if(data.startprice==""){
									jQuery("#node_"+rowindex+"_unitpricespan").html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
								}else{
									jQuery("#node_"+rowindex+"_unitpricespan").html("");
								}
							}
						}else{
							jQuery("#node_"+rowindex+"_unitprice").val(data.startprice);
							jQuery("#node_"+rowindex+"_unitpricespan").html(data.startprice);
						}
						/**单价 end */
					});
				}
				
				jQuery("#node_"+rowindex+"_cptidspan").html("<a href='/cpt/capital/CptCapital.jsp?id="+data.id+"' target='_blank'>"+data.name+"</a>");
				jQuery("#node_"+rowindex+"_cptid").val(data.id);
		    }
			else
			{
				if(ismust1)
				{
				//	jQuery("#node_"+rowindex+"_cptidspan").html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
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
function onShowTableUrl2()
{
	return "/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp";
}
function onSetCptCapital2(event,data,name)
{
	var ismust1 = <%=mandtypes.indexOf("3_1")!=-1%>;
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
				jQuery("#node_"+rowindex+"_cptcapitalidspan").html(data.name);
				jQuery("#node_"+rowindex+"_cptcapitalid").val(data.id);
		    }
			else
			{
				if(ismust1)
				{
				//	jQuery("#node_"+rowindex+"_cptcapitalidspan").html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
					jQuery("#node_"+rowindex+"_cptcapitalid").val('');
				}
				else
				{
					jQuery("#node_"+rowindex+"_cptcapitalidspan").html("");
					jQuery("#node_"+rowindex+"_cptcapitalid").val('');
				}
			}
		}
	}
	catch(e)
	{
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
            mandtypes = "<%=mandtypes%>";
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_node'){
                    if(document.forms[0].elements[i].checked==true) {
                        tmprow = document.forms[0].elements[i].value;
                        oTable.deleteRow(rowsum1);
                    }
                        rowsum1 -=1;
                }
            }
            
             amountsumcount();
             reloadSerialNum();
             
}
}else{
	window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
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
	function doRemark(){
		document.frmmain.isremark.value='1';
		document.frmmain.src.value='save';
		document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
		document.frmmain.nodesnum.value=<%=rowsum%>;
		//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
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


function changeamountsum(noderowindex){
	
	var pricetmp = document.getElementById(noderowindex+"_unitprice").value;
	var numbertmp = document.getElementById(noderowindex+"_number").value;
	var amountsumtmp = pricetmp*numbertmp;
	
	if(document.getElementById(noderowindex+"_amount").type=="hidden"){
		document.getElementById(noderowindex+"_amount").value = toFloat(amountsumtmp,0).toFixed(3);
		document.getElementById(noderowindex+"_amountspan").innerHTML = toFloat(amountsumtmp,0).toFixed(3);
	}else{
		document.getElementById(noderowindex+"_amount").value = toFloat(amountsumtmp,0).toFixed(3);
		if(document.getElementById(noderowindex+"_amountspan")){
			document.getElementById(noderowindex+"_amountspan").innerHTML = "";
		}
	}

	amountsumcount();
}



function toFloat(str , def) {
	
    if(isNaN(parseFloat(str))) return def ;
    else return str ;
}


function amountsumcount(){

	if(jQuery("input[name='<%=totalamountsum%>']")){
		var amountsum = 0;
		for(var i=0;i<rowindex;i++){
			var amounttmp = "";
			try{
				amounttmp = eval(toFloat(document.getElementById("node_"+i+"_amount").value,0));
			}catch(e){amounttmp="";}
			if(amounttmp==""){
				amountsum += 0;
			}else{
				amountsum += parseFloat(amounttmp);
			}
		}
		if(jQuery("input[name='<%=totalamountsum%>']").attr("type")=="hidden"){
			document.getElementById("<%=totalamountsum%>span").innerHTML=amountsum.toFixed(3);
			jQuery("input[name='<%=totalamountsum%>']").val(amountsum.toFixed(3));
		}else{
			jQuery("input[name='<%=totalamountsum%>']").val(amountsum.toFixed(3));
			if(document.getElementById("<%=totalamountsum%>span")){
				document.getElementById("<%=totalamountsum%>span").innerHTML="";
				
			}
		}
	}
}	

</script>
</body>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
