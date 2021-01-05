<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo"/>
<jsp:useBean id="SearchNumberRecordSet" class="weaver.conn.RecordSet" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.browserData.BrowserManager"%>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
 <%@ include file="/workflow/request/WorkflowManageRequestTitle.jsp" %>
<jsp:useBean id="WFNodeDtlFieldManager" class="weaver.workflow.workflow.WFNodeDtlFieldManager" scope="page" />
<form name="frmmain" method="post" action="BillCptFetchOperation.jsp" enctype="multipart/form-data">
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

<%!
//页面过大抽取方法
private String getAddAndDelButton(User user, String isaffirmancebody, String reEditbody, String dtladd, String dtldelete) {
	StringBuffer sf = new StringBuffer("<table class=liststyle cellspacing=1 ><tr><td>");

	if(!isaffirmancebody.equals("1")|| reEditbody.equals("1")) {
		if(dtladd.equals("1")){
			sf.append("<BUTTON Class=BtnFlow type=button accessKey=A onclick=\"addRow();\"><U>A</U>-");
			sf.append(SystemEnv.getHtmlLabelName(611,user.getLanguage()));
			sf.append("</BUTTON>");
		}
		if(dtladd.equals("1") || dtldelete.equals("1")){
			sf.append("<BUTTON Class=BtnFlow type=button accessKey=E onclick=\"deleteRow1();\"><U>E</U>-");
			sf.append(SystemEnv.getHtmlLabelName(91,user.getLanguage()));
			sf.append("</BUTTON>");
		}
	}
	sf.append("</td></tr></table>");
	
	return sf.toString();
	
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

if(viewCount>0){
%>
<%--
<%=getAddAndDelButton(user, isaffirmancebody, reEditbody, dtladd, dtldelete) %>
 --%>
<%}%>
<%--
  <table class=liststyle cellspacing=1   cols=9 id="oTable">
      	<COLGROUP>
    	
    	<tr class=header> 
		<% if((!isaffirmancebody.equals("1")|| reEditbody.equals("1"))  ) { %>
	    <%if(viewCount>0){%><td width="5%"><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td><%}%>
	    <%}%>
 --%>	    
<%





String dsptypes="";
String edittypes ="";
String mandtypes ="";
int tmpcount = 1;
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
    	  
            <td <%if(isview.equals("0")){%> style="display:none" <%}%> width="<%=viewCount==0?0:95/viewCount%>%"><%=Util.toScreen(fieldlable,user.getLanguage())%></td>
<%}%>
            </tr>
            
    	   
            <%
            
	           int linecolor=0;  
				int i=0;
	RecordSet.executeProc("bill_CptFetchDetail_Select",billid+"");
%>
<%
	while(RecordSet.next()){
		i++;
        %>
        <tr <%if(linecolor==0){%> class=DataLight <%} else {%> class=DataDark <%}%> > 

        <% if( (!isaffirmancebody.equals("1")|| reEditbody.equals("1")) ) { %>
        <%if(viewCount>0){%><td>
        <input type='checkbox' name='check_node' id='check_node' isexist="1" value="<%=RecordSet.getString("id")%>" <%if(!dtldelete.equals("1")){%>disabled<%}%>>
		<input type="hidden" name='check_node_val' value='<%=rowsum%>'>
		<span serialno>&nbsp;&nbsp;&nbsp;<%=i %></span>
        </td><%}%>
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
        
        <!-- 
        <button class=Browser onClick='onShowAssetType(node_<%=rowsum%>_cptidspan,node_<%=rowsum%>_cptid)'></button>
        <span id=node_<%=rowsum%>_cptidspan>
        
    	 <% if(mandtypes.indexOf("1_1")!=-1){
    	 		 if(RecordSet.getInt("cptid")==0) 
    	 %>
    	 			<img src='/images/BacoError_wev8.gif' align=absmiddle>
    	 <%
    	 	needcheck+=",node_"+rowsum+"_cptid";
    	 }%>
    	 <%=Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(RecordSet.getString("cptid")),user.getLanguage())%>
     	 </span>
     	  -->
     	 
     	 <brow:browser viewType="0" name='<%=tempfieldname %>' browserValue='<%= ""+tempvalue %>' 
			browserUrl="/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp"
			hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='<%=isMustInput %>'
			completeUrl="/data.jsp?type=25" linkUrl=""
			browserSpanValue='<%=tempshowvalue  %>' width='150px' _callBack="onSetCptCapital" />
     	 
    	<%}else{%>
    	<%=Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(RecordSet.getString("cptid")),user.getLanguage())%>
    	<input type='hidden' name='node_<%=rowsum%>_cptid' id='node_<%=rowsum%>_cptid' value="<%=(RecordSet.getInt("cptid")>0?RecordSet.getString("cptid"):"")%>">
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
        <!-- 
		<button class=Browser onClick='onShowCptCapital(node_<%=rowsum%>_capitalidspan,node_<%=rowsum%>_capitalid,node_<%=rowsum%>_capitalcount,node_<%=rowsum%>_number,node_<%=rowsum%>_numberspan,"node_<%=rowsum%>")'></button>
        <span id="node_<%=rowsum%>_capitalidspan">
        
    	 <% if(mandtypes.indexOf("2_1")!=-1){
    	 		if(RecordSet.getInt("capitalid")==0)
    	 %>
    	 			<img src='/images/BacoError_wev8.gif' align=absmiddle>
    	 <%
    	 	needcheck+=",node_"+rowsum+"_capitalid";
    	 }%>
    	 <a href='/cpt/capital/CptCapital.jsp?id=<%=RecordSet.getString("capitalid")%>'><%=Util.toScreen(CapitalComInfo.getCapitalname(RecordSet.getString("capitalid")),user.getLanguage())%></a>
     	 </span>
     	  -->
     	 <brow:browser viewType="0" name='<%=tempfieldname %>' browserValue='<%= ""+tempvalue %>' 
			browserUrl="/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata=2&cptstateid=1&cptuse=1"
			hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='<%=isMustInput %>'
			completeUrl="/data.jsp?type=23&cptstateid=1&cptuse=1" linkUrl="/cpt/capital/CptCapital.jsp?id="
			browserSpanValue='<%=tempshowvalue  %>' width='150px' _callBack="onSetCptCapital1" />
     	 
    	<%}else{%>
    	<a href='/cpt/capital/CptCapital.jsp?id=<%=RecordSet.getString("capitalid")%>' target='_blank'><%=Util.toScreen(CapitalComInfo.getCapitalname(RecordSet.getString("capitalid")),user.getLanguage())%></a>
    	<input type='hidden' name='node_<%=rowsum%>_capitalid' id='node_<%=rowsum%>_capitalid' value="<%=(RecordSet.getInt("capitalid")>0?RecordSet.getString("capitalid"):"")%>">
        <%
         String tempStockAmount = "";
         SearchNumberRecordSet.executeSql("select capitalnum from CptCapital where id="+RecordSet.getString("capitalid"));
         if(SearchNumberRecordSet.next()) tempStockAmount = SearchNumberRecordSet.getString("capitalnum");
         %>
        <input type='hidden' name='node_<%=rowsum%>_capitalcount' id='node_<%=rowsum%>_capitalcount' value="<%=tempStockAmount%>">
      <%}%>
    </td>

        <td <%if(dsptypes.indexOf("3_0")!=-1){%> style="display:none" <%}%>>
        <% if(edittypes.indexOf("3_1")!=-1&&canedit){
        	if(mandtypes.indexOf("3_1")!=-1){%>
        		<input type='text' name='node_<%=rowsum%>_number' id='node_<%=rowsum%>_number' value="<%=RecordSet.getString("number_n")%>"  onKeyPress='ItemNum_KeyPress()' onBlur="checknumber1(this);checkinput('node_<%=rowsum%>_number','node_<%=rowsum%>_numberspan');checkCount(<%=rowsum%>);changeamountsum('node_<%=rowsum%>')">
        		<span id="node_<%=rowsum%>_numberspan">
        		<%if(RecordSet.getString("number_n").equals("")){%>
        		<img src="/images/BacoError_wev8.gif" align=absmiddle>
	         <%
    	 	}needcheck+=",node_"+rowsum+"_number";
    	 	%>
	        </span>
	<%}else{%>
        		<input type='text' name='node_<%=rowsum%>_number' id='node_<%=rowsum%>_number' value="<%=RecordSet.getString("number_n")%>" onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);checkCount(<%=rowsum%>);changeamountsum("node_<%=rowsum%>")'>
        		<span id="node_<%=rowsum%>_numberspan"></span>
        	<%}%>
    <%}else{%>
    	<span id="node_<%=rowsum%>_numberspan"><%=RecordSet.getString("number_n")%></span>
    <input type='hidden' name='node_<%=rowsum%>_number' id='node_<%=rowsum%>_number' value="<%=RecordSet.getString("number_n")%>">
    
    <%}%>
    </td>
        <td <%if(dsptypes.indexOf("4_0")!=-1){%> style="display:none" <%}%>>
        <% if(edittypes.indexOf("4_1")!=-1&&canedit){
        	if(mandtypes.indexOf("4_1")!=-1){%>
        		<input type='text' name='node_<%=rowsum%>_unitprice' id='node_<%=rowsum%>_unitprice' value="<%=RecordSet.getString("unitprice")%>"  onKeyPress='ItemNum_KeyPress()' onBlur=checknumber1(this);checkinput('node_<%=rowsum%>_unitprice','node_<%=rowsum%>_unitpricespan');changeamountsum('node_<%=rowsum%>')>
        		<span id="node_<%=rowsum%>_unitpricespan">
        		<%if(RecordSet.getString("unitprice").equals("")){%>
        		<img src="/images/BacoError_wev8.gif" align=absmiddle>
	        <%
    	 	}needcheck+=",node_"+rowsum+"_unitprice";
    	 	%>
	        </span>
	<%}else{%>
        		<input type='text' name='node_<%=rowsum%>_unitprice' id='node_<%=rowsum%>_unitprice' value="<%=RecordSet.getString("unitprice")%>" onBlur="checknumber1(this);changeamountsum('node_<%=rowsum%>')">
        	<%}%>
    <%}else{%>
    <span id="node_<%=rowsum%>_unitpricespan"><%=RecordSet.getString("unitprice")%></span>
    <input type='hidden' name='node_<%=rowsum%>_unitprice' id='node_<%=rowsum%>_unitprice' value="<%=RecordSet.getString("unitprice")%>">
    <%}%>
    </td>
        <td <%if(dsptypes.indexOf("5_0")!=-1){%> style="display:none" <%}%>>
        <% if(edittypes.indexOf("5_1")!=-1&&canedit){
        	if(mandtypes.indexOf("5_1")!=-1){%>
        		<input class=Inputstyle type='text' name='node_<%=rowsum%>_amount' id='node_<%=rowsum%>_amount' value="<%=RecordSet.getString("amount")%>"  onKeyPress='ItemNum_KeyPress()' onBlur=checknumber1(this);checkinput('node_<%=rowsum%>_amount','node_<%=rowsum%>_amountspan')>
        		<span id="node_<%=rowsum%>_amountspan">
        		<%if(RecordSet.getString("amount").equals("")){%>
        		<img src="/images/BacoError_wev8.gif" align=absmiddle>
	        <%
    	 	}needcheck+=",node_"+rowsum+"_amount";
    	 	%>
	        </span>
	<%}else{%>
        		<input class=Inputstyle type='text' onBlur='checknumber1(this);' name='node_<%=rowsum%>_amount' id='node_<%=rowsum%>_amount' value="<%=RecordSet.getString("amount")%>">
        	<%}%>
    <%}else{%>
    <span id="node_<%=rowsum%>_amountspan"><%=RecordSet.getString("amount")%></span>
    <input type='hidden' name='node_<%=rowsum%>_amount' id='node_<%=rowsum%>_amount' value="<%=RecordSet.getString("amount")%>">
    <%}%>
    </td>
        <td <%if(dsptypes.indexOf("6_0")!=-1){%> style="display:none" <%}%>>
        <% if(edittypes.indexOf("6_1")!=-1&&canedit){%>
        <button class=e8_browflow type=button onClick='onBillCPTShowDate(node_<%=rowsum%>_needdatespan,node_<%=rowsum%>_needdate,<%=mandtypes.indexOf("6_1")%>)'></button>
        <span id=node_<%=rowsum%>_needdatespan>
        
    	 <% if(mandtypes.indexOf("6_1")!=-1){
    	 			if(RecordSet.getString("needdate").equals(""))
    	 %>
    	 			<img src='/images/BacoError_wev8.gif' align=absmiddle>
    	 <%
    	 	needcheck+=",node_"+rowsum+"_needdate";
    	 }%><%=RecordSet.getString("needdate")%>
        
    	 </span>
    	<%}else{%>
    	<%=RecordSet.getString("needdate")%>       
        <%}%>
		<input type='hidden' name='node_<%=rowsum%>_needdate' id='node_<%=rowsum%>_needdate' value="<%=RecordSet.getString("needdate")%>">
    </td>
        <td <%if(dsptypes.indexOf("7_0")!=-1){%> style="display:none" <%}%>>
        <% if(edittypes.indexOf("7_1")!=-1&&canedit){
        	if(mandtypes.indexOf("7_1")!=-1){%>
        		<input class=Inputstyle type='text' name='node_<%=rowsum%>_purpose' id='node_<%=rowsum%>_purpose' value="<%=RecordSet.getString("purpose")%>"  OnBlur=checkinput('node_<%=rowsum%>_purpose','node_<%=rowsum%>_purposespan')>
        		<span id="node_<%=rowsum%>_purposespan">
        		<%if(RecordSet.getString("purpose").equals("")){%>
        		<img src="/images/BacoError_wev8.gif" align=absmiddle>
	        <%
    	 	}needcheck+=",node_"+rowsum+"_purpose";
    	 	%>
	        </span>
	<%}else{%>
        		<input class=Inputstyle type='text' name='node_<%=rowsum%>_purpose' id='node_<%=rowsum%>_purpose' value="<%=Util.toScreenToEdit(RecordSet.getString("purpose"),user.getLanguage())%>">
        	<%}%>
    <%}else{%>
    <%=Util.toScreen(RecordSet.getString("purpose"),user.getLanguage())%><input type='hidden' name='node_<%=rowsum%>_purpose' id='node_<%=rowsum%>_purpose' value="<%=RecordSet.getString("purpose")%>">
    <%}%>
    </td>
        <td <%if(dsptypes.indexOf("8_0")!=-1){%> style="display:none" <%}%>>
        <% if(edittypes.indexOf("8_1")!=-1&&canedit){
        	if(mandtypes.indexOf("8_1")!=-1){%>
        		<input class=Inputstyle type='text' name='node_<%=rowsum%>_cptdesc' id='node_<%=rowsum%>_cptdesc' value="<%=RecordSet.getString("cptdesc")%>"  OnBlur=checkinput('node_<%=rowsum%>_cptdesc','node_<%=rowsum%>_cptdescspan')>
        		<span id="node_<%=rowsum%>_cptdescspan">
        		<%if(RecordSet.getString("cptdesc").equals("")){%>
        		<img src="/images/BacoError_wev8.gif" align=absmiddle>
	        <%
    	 	}needcheck+=",node_"+rowsum+"_cptdesc";
    	 	%>
	        </span>
	<%}else{%>
        		<input class=Inputstyle type='text' name='node_<%=rowsum%>_cptdesc' id='node_<%=rowsum%>_cptdesc' value="<%=Util.toScreenToEdit(RecordSet.getString("cptdesc"),user.getLanguage())%>">
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
  <input  type ='hidden' id=delids name=delids value="">


</wea:item>
</wea:group>
</wea:layout>  
  
  <br>
<%@ include file="/workflow/request/WorkflowManageSign.jsp" %>


<input type="hidden" name="f_weaver_belongto_userid" value="<%=request.getParameter("f_weaver_belongto_userid") %>">
<input type="hidden" name="f_weaver_belongto_usertype" value="<%=request.getParameter("f_weaver_belongto_usertype") %>">
</form>
 <!--页面过大-->
<jsp:include page="ManageBillCptFetch2.jsp" flush="true">
    <jsp:param name="mandtypes" value="<%=mandtypes%>" />
    <jsp:param name="groupid" value="<%=groupid%>" />
    <jsp:param name="needcheck" value="<%=needcheck%>" />
    <jsp:param name="dsptypes" value="<%=dsptypes%>" />
    <jsp:param name="edittypes" value="<%=edittypes%>" />
    <jsp:param name="newenddate" value="<%=newenddate%>" />
    <jsp:param name="newfromdate" value="<%=newfromdate%>" />
    <jsp:param name="totalamountsum" value="<%=totalamountsum%>" />
</jsp:include>
<script>
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
</script>
</body>
</html>
