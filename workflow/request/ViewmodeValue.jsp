
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page" />
<jsp:useBean id="flowDoc" class="weaver.workflow.request.RequestDoc" scope="page"/>
<jsp:useBean id="WorkflowPhrase" class="weaver.workflow.sysPhrase.WorkflowPhrase" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page" />
<jsp:useBean id="urlcominfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="docinf" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="wfrequestcominfo" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page" />

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="java.util.*" %>

<%@ page import="weaver.fna.budget.BudgetHandler" %>
<%@ page import="weaver.general.BaseBean" %>
<script type="text/javascript">
var trrigerfieldary="";
var trrigerdetailfieldary="";
</script>
<div style="display:none">
<table id="hidden_tab" cellpadding='0' width=0 cellspacing='0'>
</table>
</div>
<%
String acceptlanguage = request.getHeader("Accept-Language");
User user = HrmUserVarify.getUser (request , response) ;

int requestid = Util.getIntValue(request.getParameter("requestid"));
int desrequestid = Util.getIntValue(request.getParameter("desrequestid"));
int workflowid = Util.getIntValue(request.getParameter("workflowid"));
int formid = Util.getIntValue(request.getParameter("formid"));
String billid = Util.null2String(request.getParameter("billid"));
String isbill = Util.null2String(request.getParameter("isbill"));
int Languageid = Util.getIntValue(request.getParameter("Languageid"));

String _nodeid = Util.null2String(request.getParameter("nodeid"));
String nodetype = Util.null2String(request.getParameter("nodetype"));

int intervenorright=Util.getIntValue((String)session.getAttribute(user.getUID()+"_"+requestid+"intervenorright"),0);



ArrayList flowDocs=flowDoc.getDocFiled(""+workflowid); //得到流程建文挡的发文号字段


String flowDocField="";
if (flowDocs!=null&&flowDocs.size()>1)
{

flowDocField=""+flowDocs.get(1);
}
String docFlags=Util.null2String((String)session.getAttribute("requestAdd"+requestid));
if (docFlags.equals("")) docFlags=Util.null2String((String)session.getAttribute("requestAdd"+user.getUID()));

String isSignMustInput="0";
RecordSet.execute("select issignmustinput from workflow_flownode where workflowid="+workflowid+" and nodeid="+_nodeid);
if(RecordSet.next()){
	isSignMustInput = ""+Util.getIntValue(RecordSet.getString("issignmustinput"), 0);
}
String organizationtype="";
String organizationid="";
String subject="";
String budgetperiod="";
String hrmremain="";
String hrmremaintype="";
String deptremain="";
String deptremaintype="";
String subcomremain="";
String subcomremaintype="";
String loanbalance="";
String loanbalancetype="";
String oldamount="";
String oldamounttype="";
if(isbill.equals("1")&&(formid==156 ||formid==157 ||formid==158 ||formid==159)){
    RecordSet.executeSql("select fieldname,id,type,fieldhtmltype from workflow_billfield where viewtype=1 and billid="+formid);
    while(RecordSet.next()){
        if("organizationtype".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase()))
        organizationtype="field"+RecordSet.getString("id");
        if("organizationid".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase()))
        organizationid="field"+RecordSet.getString("id");
        if("subject".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase()))
        subject="field"+RecordSet.getString("id");
        if("budgetperiod".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase()))
        budgetperiod="field"+RecordSet.getString("id");
        if("hrmremain".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase())){
            hrmremain="field"+RecordSet.getString("id");
            hrmremaintype=RecordSet.getString("type")+"_"+RecordSet.getString("fieldhtmltype");
        }
        if("deptremain".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase())){
            deptremain="field"+RecordSet.getString("id");
            deptremaintype=RecordSet.getString("type")+"_"+RecordSet.getString("fieldhtmltype");
        }
        if("subcomremain".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase())){
            subcomremain="field"+RecordSet.getString("id");
            subcomremaintype=RecordSet.getString("type")+"_"+RecordSet.getString("fieldhtmltype");
        }
        if("loanbalance".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase())){
            loanbalance="field"+RecordSet.getString("id");
            loanbalancetype=RecordSet.getString("type")+"_"+RecordSet.getString("fieldhtmltype");
        }
        if("oldamount".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase())){
            oldamount="field"+RecordSet.getString("id");
            oldamounttype=RecordSet.getString("type")+"_"+RecordSet.getString("fieldhtmltype");
        }
    }
}
BudgetHandler bp = new BudgetHandler();
String iswfshare = Util.null2String((String)session.getAttribute(user.getUID()+"_"+requestid+"iswfshare"));

FieldInfo.setRequestid(requestid);
FieldInfo.setUser(user);
FieldInfo.setIswfshare(iswfshare);
FieldInfo.GetManTableField(formid,Util.getIntValue(isbill),Languageid);
FieldInfo.GetDetailTableField(formid,Util.getIntValue(isbill),Languageid);
FieldInfo.GetWorkflowNode(workflowid);

ArrayList mantablefields=FieldInfo.getManTableFields();
ArrayList manfieldvalues=FieldInfo.getManTableFieldValues();
ArrayList manfielddbtypes=FieldInfo.getManTableFieldDBTypes();
ArrayList detailtablefields=FieldInfo.getDetailTableFields();
ArrayList detailfieldvalues=FieldInfo.getDetailTableFieldValues();
ArrayList detailtablefieldids=FieldInfo.getDetailTableFieldIds();
ArrayList ManUrlList=FieldInfo.getManUrlList();
ArrayList ManUrlLinkList=FieldInfo.getManUrlLinkList();
ArrayList DetailUrlList=FieldInfo.getDetailUrlList();
ArrayList DetailUrlLinkList=FieldInfo.getDetailUrlLinkList();
ArrayList NodeList=FieldInfo.getNodes();
ArrayList DetailFieldDBTypes=FieldInfo.getDetailFieldDBTypes();

ArrayList mantablefieldlables=new ArrayList();
ArrayList detailtablefieldlables=new ArrayList();
mantablefieldlables=FieldInfo.getManTableFieldNames();
detailtablefieldlables=FieldInfo.getDetailTableFieldNames();

String fieldid="";
String fieldvalue="";
String filedname="";
String url="";
String urllink="";
for(int i=0; i<mantablefields.size();i++){
    int htmltype=1;
    int type=1;
    int indx=-1;
    fieldid=(String)mantablefields.get(i);
    filedname=(String)mantablefieldlables.get(i);
    fieldvalue=(String)manfieldvalues.get(i);
    url=(String)ManUrlList.get(i);
    urllink=(String)ManUrlLinkList.get(i);
    indx=fieldid.lastIndexOf("_");
    if(indx>0){
        htmltype=Util.getIntValue(fieldid.substring(indx+1),1);
        fieldid=fieldid.substring(0,indx);            
    }
    indx=fieldid.lastIndexOf("_");
    if(indx>0){
        type=Util.getIntValue(fieldid.substring(indx+1),1);
        fieldid=fieldid.substring(0,indx);    
    }
    if(htmltype==6){
        ArrayList filenum=new ArrayList();
        if(!fieldvalue.equals("")){
            filenum=Util.TokenizerString(fieldvalue,",");
        }        
%>   
    <input type=hidden id="<%=fieldid%>_num" name='<%=fieldid%>_num' value="0"> 
    <input type=hidden name="<%=fieldid%>_idnum" value="<%=filenum.size()%>">
    <input type=hidden temptitle="<%=filedname%>" name="<%=fieldid%>" value="<%=fieldvalue%>">
<%
    }else{
        if(htmltype==3){            
%>
    <input type="hidden" temptitle="<%=filedname%>" name="<%=fieldid%>" value="<%=fieldvalue%>">
    <input type="hidden" name="<%=fieldid%>_url" value="<%=url%>">
    <input type="hidden" name="<%=fieldid%>_urllink" value="<%=urllink%>">
    <input type="hidden" name="<%=fieldid%>_linkno" value="">
<%
        }else if(htmltype ==9){
            %>  <input type="hidden" temptitle="<%=filedname%>" name="<%=fieldid%>" value=""><% 
        }else if(htmltype==7&&type==1){
%>
    <input type="hidden" temptitle="<%=filedname%>" name="<%=fieldid%>" value="<%=fieldvalue%>">
    <input type="hidden" name="<%=fieldid%>_url" value="<%=url%>">
    <input type="hidden" name="<%=fieldid%>_urllink" value="<%=urllink%>">
    <input type="hidden" name="<%=fieldid%>_linkno" value="">
<%
        }else{
	if(htmltype==2&&type==2) {%>
	 <textarea style="display:none" temptitle="<%=filedname%>" name="<%=fieldid%>"><%=FieldInfo.toScreen(fieldvalue)%></textarea>	
	<%}
	else {
		String ffieldvalue = FieldInfo.toScreen(Util.StringReplace(fieldvalue,"\"","&quot;"));
    	if(htmltype == 2 && type == 1) {
    		ffieldvalue = Util.StringReplace(ffieldvalue, "<", "&lt;");
    		ffieldvalue = Util.StringReplace(ffieldvalue, ">", "&gt;");
    	}
%>
    <input type="hidden" temptitle="<%=filedname%>" name="<%=fieldid%>" value="<%=ffieldvalue%>">
<%
	}   }
    }
}

//标题,紧急程度，是否短信提醒
String requestlevel = Util.null2String(request.getParameter("requestlevel"));
String requestname = Util.null2String((String)session.getAttribute(user.getUID()+"_"+requestid+"requestname"));
String sqlWfMessage = "select a.messagetype,b.messagetype from workflow_requestbase a,workflow_base b where a.workflowid=b.id and b.messagetype='1' and a.requestid="+requestid ;
RecordSet.executeSql(sqlWfMessage);
int rqMessageType=0;
int wbMessageType=0;
if(RecordSet.next()){
	rqMessageType=RecordSet.getInt(1);
	wbMessageType = RecordSet.getInt(2);
}
//微信提醒(QC:98106)
String sqlWfChats = "select a.chatstype,b.chatstype from workflow_requestbase a,workflow_base b where a.workflowid=b.id and b.chatstype='1' and a.requestid="+requestid ;
RecordSet.executeSql(sqlWfChats);
int rqChatsType=0;
int wbChatsType=0;
if(RecordSet.next()){
	rqChatsType=RecordSet.getInt(1);
	wbChatsType = RecordSet.getInt(2);
}
%>
<%RecordSet.executeSql("select * from workflow_modeview where formid="+formid+" and nodeid="+_nodeid+" and fieldid=-1");
if(RecordSet.next()){//如果在模板中设置了标题，下面的隐含字段作为标题对象保存数据

%>
<input type="hidden" temptitle="<%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%>" name="requestname" value="<%=FieldInfo.toScreen(Util.StringReplace(requestname,"\"","&quot;"))%>">
<%}%>
<%RecordSet.executeSql("select * from workflow_modeview where formid="+formid+" and nodeid="+_nodeid+" and fieldid=-2");
if(RecordSet.next()){//如果在模板中设置了紧急程度，下面的隐含字段作为紧急程度对象保存数据

%>
<input type="hidden" temptitle="<%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%>" name="requestlevel" value="<%=requestlevel%>">
<%}%>
<%RecordSet.executeSql("select * from workflow_modeview where formid="+formid+" and nodeid="+_nodeid+" and fieldid=-3");
if(RecordSet.next()){//如果在模板中设置了是否短信提醒，下面的隐含字段作为是否短信提醒保存数据

%>
<input type="hidden" temptitle="<%=SystemEnv.getHtmlLabelName(17582,user.getLanguage())%>" name="messageType" value="<%=rqMessageType%>">
<%}%>
<!-- 微信提醒(QC:98106) -->
<%RecordSet.executeSql("select * from workflow_modeview where formid="+formid+" and nodeid="+_nodeid+" and fieldid=-5");
if(RecordSet.next()){//如果在模板中设置了是否微信提醒，下面的隐含字段作为是否微信提醒保存数据

%>
<input type="hidden" temptitle="<%=SystemEnv.getHtmlLabelName(32812,user.getLanguage())%>" name="chatsType" value="<%=rqChatsType%>">
<%}%>
<%
for(int i=0; i<detailtablefields.size();i++){
String fieldlable="";
    ArrayList detaillist=(ArrayList)detailtablefields.get(i);
    ArrayList detaillablelist=(ArrayList)detailtablefieldlables.get(i);
    ArrayList detailurls=(ArrayList)DetailUrlList.get(i);
    ArrayList detailurllinks=(ArrayList)DetailUrlLinkList.get(i);
    ArrayList detailvalues=(ArrayList)detailfieldvalues.get(i);
    ArrayList detailfieldids=(ArrayList)detailtablefieldids.get(i);
    int htmltype=1;
    int type=1;
    int indx=-1;
    int row=0;
    for(int j=0;j<detailfieldids.size();j++){
        ArrayList fieldids=(ArrayList)detailfieldids.get(j);
        ArrayList fieldvalues=(ArrayList)detailvalues.get(j);
        url=(String)detailurls.get(j);
        urllink=(String)detailurllinks.get(j);
        String fieldname=(String)detaillist.get(j);
        String tempfieldname=fieldname.substring(0,fieldname.indexOf("_"));
        fieldlable=(String)detaillablelist.get(j);
        if(Util.getIntValue(fieldname.substring(fieldname.lastIndexOf("_")+1),1)==3){
 %>
    <input type="hidden" name="<%=fieldname.substring(0,fieldname.indexOf("_"))%>_url" value="<%=url%>">
    <input type="hidden" name="<%=fieldname.substring(0,fieldname.indexOf("_"))%>_urllink" value="<%=urllink%>">
    <input type="hidden" name="<%=fieldname.substring(0,fieldname.indexOf("_"))%>_linkno" value="">
<%
        }
        row=fieldids.size();
        for(int k=0;k<fieldids.size();k++){
            fieldid=(String)fieldids.get(k);
            fieldvalue=(String)fieldvalues.get(k);
            indx=fieldid.lastIndexOf("_");
            if(indx>0){
                htmltype=Util.getIntValue(fieldid.substring(indx+1),1);
                fieldid=fieldid.substring(0,indx);            
            }
            indx=fieldid.lastIndexOf("_");
            if(indx>0){
                type=Util.getIntValue(fieldid.substring(indx+1),1);
                fieldid=fieldid.substring(0,indx);    
            }
            if(htmltype==3 && (type==16 || type==152 || type==171) || htmltype==9){ %>
                <input type="hidden" name="<%=fieldid%>_linkno" value="">
            <%}
        }%>
            <input type="hidden"  value="<%=fieldlable%>" name="temp_<%=tempfieldname%>">
            <%
    }
%>
    <input type=hidden name="indexnum<%=i%>" id="indexnum<%=i%>" value="0">
    <input type=hidden name="nodesnum<%=i%>" id="nodesnum<%=i%>" value="0">
    <input type=hidden name="totalrow<%=i%>" id="totalrow<%=i%>" value="0">
    <input type=hidden name="tempdetail<%=i%>" id="tempdetail<%=i%>" value="<%=row%>">
<%
}
%>

<span  id=createDocButtonSpan><button id='createdoc' style='display:none' class=AddDoc onclick="createDocForNewTab('','0');return false;"></button></span>

<input type="hidden" name="flowDocField" value="<%=flowDocField%>">
<input type="hidden" name="requestid" value="<%=requestid%>">
<input type="hidden" name="workflowid" value="<%=workflowid%>">
<input type="hidden" name="formid" value="<%=formid%>">
<input type="hidden" name="billid" value="<%=billid%>">
<input type="hidden" name="isbill" value="<%=isbill%>">
<input type="hidden" name="nodeid" value="<%=_nodeid%>">
<input type="hidden" name="nodetype" value="<%=nodetype%>">

<input type=hidden name="rand" value="<%=System.currentTimeMillis()%>">
<input type=hidden name="needoutprint" value="">
<iframe name="delzw" width=0 height=0 style="border:none;"></iframe>
<script language=javascript>
var rowgroup=new Array();
function getRowGroup(){
<%
    for(int i=0; i<detailtablefields.size();i++){
%>
        var headrow=frmmain.ChinaExcel.GetCellUserStringValueRow("detail<%=i%>_head");
        var endrow=frmmain.ChinaExcel.GetCellUserStringValueRow("detail<%=i%>_end");
        if(headrow==null || headrow=="" || endrow==null || endrow=="" || endrow-headrow-1<1){
            rowgroup[<%=i%>]=0;
        }else{
            rowgroup[<%=i%>]=(endrow-headrow-1);
        }
<%
    }
%>
}

function setmantable(){
    var wcell=frmmain.ChinaExcel;
    try{
    	//标题
    	var temprow1=wcell.GetCellUserStringValueRow("requestname");
    	var tempcol1=wcell.GetCellUserStringValueCol("requestname");
    	if(temprow1>0){
	    	$G("needcheck").value=$G("needcheck").value+",requestname";
		    wcell.SetCellVal(temprow1,tempcol1,getChangeField('<%=FieldInfo.toExcel(Util.encodeJS(requestname))%>'));
		    imgshoworhide(temprow1,tempcol1);
		  }
	    
	    //紧急程度

    	var temprow2=wcell.GetCellUserStringValueRow("requestlevel");
    	var tempcol2=wcell.GetCellUserStringValueCol("requestlevel");
    	if(temprow2>0){
		   	//wcell.SetCellComboType1(temprow2,tempcol2,false,true,false,"<%=SystemEnv.getHtmlLabelName(225,Languageid)%>;<%=SystemEnv.getHtmlLabelName(15533,Languageid)%>;<%=SystemEnv.getHtmlLabelName(2087,Languageid)%>","0;1;2");
	      if("<%=requestlevel%>"==0) wcell.SetCellVal(temprow2,tempcol2,getChangeField("<%=SystemEnv.getHtmlLabelName(225,Languageid)%>")); 
	      if("<%=requestlevel%>"==1) wcell.SetCellVal(temprow2,tempcol2,getChangeField("<%=SystemEnv.getHtmlLabelName(15533,Languageid)%>")); 
	      if("<%=requestlevel%>"==2) wcell.SetCellVal(temprow2,tempcol2,getChangeField("<%=SystemEnv.getHtmlLabelName(2087,Languageid)%>")); 
	      $G("requestlevel").value="<%=requestlevel%>";
		    imgshoworhide(temprow2,tempcol2);
		  }
	    
	    //是否短信提醒
	    if("<%=wbMessageType%>"==1){
    	var temprow3=wcell.GetCellUserStringValueRow("messageType");
    	var tempcol3=wcell.GetCellUserStringValueCol("messageType");
    	if(temprow3>0){
		   	//wcell.SetCellComboType1(temprow3,tempcol3,false,true,false,"<%=SystemEnv.getHtmlLabelName(17583,Languageid)%>;<%=SystemEnv.getHtmlLabelName(17584,Languageid)%>;<%=SystemEnv.getHtmlLabelName(17585,Languageid)%>","0;1;2");
	      if("<%=rqMessageType%>"==0) wcell.SetCellVal(temprow3,tempcol3,getChangeField("<%=SystemEnv.getHtmlLabelName(17583,Languageid)%>")); 
	      if("<%=rqMessageType%>"==1) wcell.SetCellVal(temprow3,tempcol3,getChangeField("<%=SystemEnv.getHtmlLabelName(17584,Languageid)%>")); 
	      if("<%=rqMessageType%>"==2) wcell.SetCellVal(temprow3,tempcol3,getChangeField("<%=SystemEnv.getHtmlLabelName(17585,Languageid)%>")); 
	      $G("messageType").value="<%=rqMessageType%>";
		    imgshoworhide(temprow3,tempcol3);
		  }
		}
		//微信提醒(QC:98106)
		//是否微信提醒
	    if("<%=wbChatsType%>"==1){
    	var temprow6=wcell.GetCellUserStringValueRow("chatsType");
    	var tempcol6=wcell.GetCellUserStringValueCol("chatsType");
    	if(temprow6>0){ 
	      if("<%=rqChatsType%>"==0) wcell.SetCellVal(temprow6,tempcol6,getChangeField("<%=SystemEnv.getHtmlLabelName(19782,Languageid)%>")); 
	      if("<%=rqChatsType%>"==1) wcell.SetCellVal(temprow6,tempcol6,getChangeField("<%=SystemEnv.getHtmlLabelName(26928,Languageid)%>")); 
	       document.all("chatsType").value="<%=rqChatsType%>";
		    imgshoworhide(temprow6,tempcol6);
		  }
		}
		  //签字
    	var temprow4=wcell.GetCellUserStringValueRow("qianzi");
    	var tempcol4=wcell.GetCellUserStringValueCol("qianzi");
    	if(temprow4>0){
    		wcell.DeleteCellImage(temprow4,tempcol4,temprow4,tempcol4);
    	}

		//重新生成编号
    	var temprow5=wcell.GetCellUserStringValueRow("main_createCodeAgain");
    	var tempcol5=wcell.GetCellUserStringValueCol("main_createCodeAgain");
    	if(temprow5>0){
			imghide(temprow5,tempcol5);
    	}
  	}catch(e){}
<%
    for(int i=0; i<mantablefields.size();i++){
        String fid=(String)mantablefields.get(i);
        String fvalue=(String)manfieldvalues.get(i);
		String dbtype=(String)manfielddbtypes.get(i);
%>
    var nrow=wcell.GetCellUserStringValueRow("<%=fid%>");
    if(nrow>0){
        var ncol=wcell.GetCellUserStringValueCol("<%=fid%>");
<%
        int htmltype=1;    
        int ftype=0;
        String tmpfid=fid;
        int indx=tmpfid.lastIndexOf("_");
        if(indx>0){
           htmltype=Util.getIntValue(tmpfid.substring(indx+1),1);
           tmpfid=tmpfid.substring(0,indx); 
           indx=tmpfid.lastIndexOf("_");
            if(indx>0){
               ftype=Util.getIntValue(tmpfid.substring(indx+1),1);   
               tmpfid=tmpfid.substring(0,indx); 
            }
        } 
        if(htmltype==5){
            FieldInfo.getSelectItem(fid,isbill);
            ArrayList  SelectItems=FieldInfo.getSelectItems();
            ArrayList SelectItemValues=FieldInfo.getSelectItemValues();
            String Combostr="";
            fvalue="";
            for(int j=0;j<SelectItems.size();j++){
                String selectname=(String)SelectItems.get(j);
                String selectvalue=(String)SelectItemValues.get(j);
                Combostr+=";"+selectname;
%>
                var fieldvalue=$G("<%=tmpfid%>").value;
                var selvalue="<%=selectvalue%>";
                if(fieldvalue==selvalue){
                    wcell.SetCellVal(nrow,ncol,getChangeField('<%=FieldInfo.toExcel(Util.encodeJS(selectname))%>'));
                }
<%
            }
%>
        wcell.SetCellComboType(nrow,ncol,false,false,"<%=Util.encodeJS(Combostr)%>");           
<%
        }
        if(htmltype==4){
%>
        wcell.SetCellProtect(nrow,ncol,nrow,ncol,false);
        wcell.SetCellCheckBoxType(nrow,ncol);        
<%
            if(fvalue.equals("1")){
%>
        wcell.SetCellCheckBoxValue(nrow,ncol,true);
<%
            }
%>
        wcell.SetCellProtect(nrow,ncol,nrow,ncol,true);
<%
        }
        if(htmltype==3){
            if(ftype==16 || ftype==152 || ftype==171){
                ArrayList tempshowidlist=Util.TokenizerString(fvalue,",");
                String linknums="";
                int tempnum=Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
                for(int t=0;t<tempshowidlist.size();t++){
                    tempnum++;
                    session.setAttribute("resrequestid"+tempnum,""+tempshowidlist.get(t));
                    linknums+=tempnum+",";
                }
                session.setAttribute("slinkwfnum",""+tempnum);
                session.setAttribute("haslinkworkflow","1");
                if(linknums.length()>0) linknums=linknums.substring(0,linknums.length()-1);
%>
                $G("<%=tmpfid%>_linkno").value="<%=linknums%>";
<%
            }

            if( ftype==9&&docFlags.equals("1") && tmpfid.equals("field"+flowDocField) ) {
%>

            createDocButtonSpan.innerHTML="<button id='createdoc' style='display:none' class=AddDoc onclick=\"createDocForNewTab('<%=tmpfid%>','0');return false;\"></button>"
<%
            }
            fvalue=FieldInfo.getFieldName(fvalue,ftype,dbtype,workflowid);
        }
        if(htmltype==6){            
			if("-2".equals(fvalue)){
				fvalue = SystemEnv.getHtmlLabelName(21710, user.getLanguage());
%>
		var color_red = wcell.GetRGBValue(255, 0, 0);
		if(wcell.IsCellProtect(nrow,ncol) == true){
			wcell.SetCellProtect(nrow,ncol,nrow,ncol,false);
			wcell.SetCellTextColor(nrow, ncol, nrow, ncol, color_red);
			wcell.SetCellProtect(nrow,ncol,nrow,ncol,true);
		}else{
			wcell.SetCellTextColor(nrow, ncol, nrow, ncol, color_red);
		}
<%
			}else{
				fvalue=FieldInfo.getFileName(fvalue);
				fvalue=Util.StringReplace(fvalue,",","<br>");
			}

        }else if(htmltype==9){
            fvalue=SystemEnv.getHtmlLabelName(126136,user.getLanguage());
        }
        if(htmltype!=4 && htmltype!=5){
        	String ffvalue = Util.encodeJS(FieldInfo.toExcel(FieldInfo.dropScript(fvalue)));
			if(htmltype==1 && ftype==5) ffvalue = Util.StringReplace(ffvalue,",","");
        	if(htmltype == 2 && ftype == 1) {
        		ffvalue = Util.StringReplace(ffvalue, "<", "&lt;");
        		ffvalue = Util.StringReplace(ffvalue, ">", "&gt;");
        	}
%>
            var Formula=wcell.GetCellFormula(nrow,ncol);
            if(Formula==null || Formula==""){
                var strtxt = '<%=ffvalue%>';
<%
        if(htmltype==2&&ftype==2){
%>
    	strtxt = getFckText(strtxt);
<%
        }
%>
            wcell.SetCellVal(nrow,ncol,getChangeField(strtxt));
            }
<%
        }
%>
    imghide(nrow,ncol);
    }
<%
    }
%>
}
function setdetailtable(){
    var wcell=frmmain.ChinaExcel;    
<%
    String fid="";
    String fvalue="";
	String dfielddbtype="";
    for(int i=0; i<detailtablefieldids.size();i++){
%>
    var totalrow=parseInt($G("tempdetail<%=i%>").value);
    for(var row=0;row<totalrow;row++){
    rowIns("<%=i%>",1,1);
    }
    var selcol=wcell.GetCellUserStringValueCol("detail<%=i%>_sel");
    var nInsertAfterRow=wcell.GetCellUserStringValueRow("detail<%=i%>_end"); 
    var nInsertRows=rowgroup[<%=i%>];
    if(selcol>0 && nInsertAfterRow>0){
        if("<%=(i+1)%>"=="<%=detailtablefieldids.size()%>")
        wcell.SetCellCheckBoxValue(nInsertAfterRow-nInsertRows,selcol,false);
    }
<%
        ArrayList dfids=(ArrayList)detailtablefieldids.get(i);
        ArrayList dfvalues=(ArrayList)detailfieldvalues.get(i);
		ArrayList dfielddbtypes=(ArrayList)DetailFieldDBTypes.get(i);
        ArrayList torgtypevalues=new ArrayList();
        ArrayList tbudgetperiodvalues=new ArrayList();
        ArrayList torgidvalues=new ArrayList();
        ArrayList tsubjectvalues=new ArrayList();
        for(int j=0;j<dfids.size();j++){
            ArrayList fids=(ArrayList)dfids.get(j);
            ArrayList fvalues=(ArrayList)dfvalues.get(j);
			dfielddbtype=(String)dfielddbtypes.get(j);
            for(int k=0;k<fids.size();k++){
                fid=(String)fids.get(k);
                fvalue=(String)fvalues.get(k);
                if(fid.indexOf(budgetperiod+"_")==0){
                    tbudgetperiodvalues.add(fvalue);
                }else if(fid.indexOf(organizationtype+"_")==0){
                    torgtypevalues.add(fvalue);
                }else if(fid.indexOf(organizationid+"_")==0){
                    torgidvalues.add(fvalue);
                }else if(fid.indexOf(subject+"_")==0){
                    tsubjectvalues.add(fvalue);
                }
%>
                var nrow=wcell.GetCellUserStringValueRow("<%=fid%>");
                if(nrow>0){
                    var ncol=wcell.GetCellUserStringValueCol("<%=fid%>");
<%
                if(k==0){
%>  
                nrow=nrow+nInsertRows;
<%
                }
                int htmltype=1;    
                int ftype=0;
                String tmpfid=fid;
                int indx=tmpfid.lastIndexOf("_");
                if(indx>0){
                   htmltype=Util.getIntValue(tmpfid.substring(indx+1),1);
                   tmpfid=tmpfid.substring(0,indx);
                   indx=tmpfid.lastIndexOf("_");
                   if(indx>0){
                      ftype=Util.getIntValue(tmpfid.substring(indx+1),1); 
                      tmpfid=tmpfid.substring(0,indx); 
                   }
                }
                int tmprow=Util.getIntValue(tmpfid.substring(tmpfid.indexOf("_")+1));
%>
                $G("<%=tmpfid%>").value = "<%=FieldInfo.toScreen(Util.encodeJS(fvalue))%>";
<%
                if(htmltype==5){
                    FieldInfo.getSelectItem(fid,isbill);
                    ArrayList  SelectItems=FieldInfo.getSelectItems();
                    ArrayList SelectItemValues=FieldInfo.getSelectItemValues();
                    String Combostr="";
                    fvalue="";
                    for(int n=0;n<SelectItems.size();n++){
                        String selectname=(String)SelectItems.get(n);
                        String selectvalue=(String)SelectItemValues.get(n);
                        Combostr+=";"+selectname;
%>
                        var fieldvalue=$G("<%=tmpfid%>").value;
                        var selvalue="<%=selectvalue%>";
                        if(fieldvalue==selvalue){
                            wcell.SetCellVal(nrow,ncol,getChangeField('<%=FieldInfo.toExcel(Util.encodeJS(selectname))%>'));
                        }
<%
                    }
%>
                    wcell.SetCellComboType(nrow,ncol,false,false,"<%=Util.encodeJS(Combostr)%>");           
<%
                }
                if(htmltype==4){
%>
                    wcell.SetCellProtect(nrow,ncol,nrow,ncol,false);
                    wcell.SetCellCheckBoxType(nrow,ncol);
<%
                    if(fvalue.equals("1")){
%>
                    wcell.SetCellCheckBoxValue(nrow,ncol,true);
<%
                    }
%>
                    wcell.SetCellProtect(nrow,ncol,nrow,ncol,true);
<%
                }
                if(htmltype==3){
                    if(ftype==16 || ftype==152 || ftype==171){
                        ArrayList tempshowidlist=Util.TokenizerString(fvalue,",");
                        String linknums="";
                        int tempnum=Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
                        for(int t=0;t<tempshowidlist.size();t++){
                            tempnum++;
                            session.setAttribute("resrequestid"+tempnum,""+tempshowidlist.get(t));
                            linknums+=tempnum+",";
                        }
                        session.setAttribute("slinkwfnum",""+tempnum);
                        session.setAttribute("haslinkworkflow","1");
                        if(linknums.length()>0) linknums=linknums.substring(0,linknums.length()-1);
%>
                        $G("<%=tmpfid%>_linkno").value="<%=linknums%>";
<%
                    }
                    if(tmpfid.indexOf(organizationid+"_")==0){
                        if(torgtypevalues.size()>=tmprow){
                            int orgtype=Util.getIntValue((String)torgtypevalues.get(tmprow),3);
                            if(orgtype==1){
                                ftype=164;
                            }else if(orgtype==2){
                                ftype=4;
                            }else{
                                ftype=1;
                            }
                        }
%>
                    var temporgtype=3;
                    if($G("<%=organizationtype%>_<%=tmprow%>")) temporgtype=$G("<%=organizationtype%>_<%=tmprow%>").value;
                    wcell.SetCellProtect(nrow,ncol,nrow,ncol,false);
                    var tfieldid="<%=organizationid%>_<%=tmprow%>";
                    var turl="";
                    var turllink="";
                    if (temporgtype == 1) {
                        tfieldid += "_164_3";
                        turl = '<%=urlcominfo.getBrowserurl("164")%>';
                        turllink = '<%=urlcominfo.getLinkurl("164")%>';
                    } else if (temporgtype == 2) {
                        tfieldid += "_4_3";
                        turl = '<%=urlcominfo.getBrowserurl("4")%>';
                        turllink = '<%=urlcominfo.getLinkurl("4")%>';
                    } else {
                        tfieldid += "_1_3";
                        turl = '<%=urlcominfo.getBrowserurl("1")%>';
                        turllink = '<%=urlcominfo.getLinkurl("1")%>';
                    }
                    wcell.SetCellUserStringValue(nrow, ncol, nrow, ncol, tfieldid);
                    if ($G("<%=organizationid%>_<%=tmprow%>_url")) {
                        $G("<%=organizationid%>_<%=tmprow%>_url").value = turl;
                    }
                    if ($G("<%=organizationid%>_<%=tmprow%>_urllink")) {
                        $G("<%=organizationid%>_<%=tmprow%>_urllink").value = turllink;
                    }
<%
                    }
                    if(ftype!=161 && ftype!=162){//非自定义浏览框
						fvalue=FieldInfo.getFieldName(fvalue,ftype,dfielddbtype,workflowid);
					}else{//自定义浏览框的特殊处理
						fvalue=FieldInfo.getFieldName(fvalue+"^~^"+tmprow,ftype,dfielddbtype);
					}
                }
                if(htmltype==6){            
					if("-2".equals(fvalue)){
						fvalue = SystemEnv.getHtmlLabelName(21710, user.getLanguage());
		%>
						var color_red = wcell.GetRGBValue(255, 0, 0);
						if(wcell.IsCellProtect(nrow,ncol) == true){
							wcell.SetCellProtect(nrow,ncol,nrow,ncol,false);
							wcell.SetCellTextColor(nrow, ncol, nrow, ncol, color_red);
							wcell.SetCellProtect(nrow,ncol,nrow,ncol,true);
						}else{
							wcell.SetCellTextColor(nrow, ncol, nrow, ncol, color_red);
						}
		<%
					}else{
						fvalue=FieldInfo.getFileName(fvalue);
						fvalue=Util.StringReplace(fvalue,",","<br>");
					}
		
		        }
                if(htmltype == 9){
        		%>
               		wcell.SetCellVal(nrow,ncol,'<%=SystemEnv.getHtmlLabelName(126136,user.getLanguage()) %>');    
        			wcell.SetCellProtect(nrow,ncol,nrow,ncol,true);	 
                <%}    
                if(htmltype!=4 && htmltype!=5){
					if(htmltype==1 && ftype==5) fvalue = Util.StringReplace(fvalue,",","");
%>
                var Formula=wcell.GetCellFormula(nrow,ncol);
                if(Formula==null || Formula==""){
                    var strtxt = '<%=Util.encodeJS(FieldInfo.toExcel(FieldInfo.dropScript(fvalue)))%>';
<%
        if(htmltype==2&&ftype==2){
%>
    	strtxt = getFckText(strtxt);
<%
        }
%>
            wcell.SetCellVal(nrow,ncol,getChangeField(strtxt));
                }
<%
                }
                if(fid.indexOf(hrmremain+"_")==0||fid.indexOf(deptremain+"_")==0||fid.indexOf(subcomremain+"_")==0){
                    if(torgtypevalues.size()>=tmprow&&tbudgetperiodvalues.size()>=tmprow&&torgidvalues.size()>=tmprow&&tsubjectvalues.size()>=tmprow){
                        String kpi=bp.getBudgetKPI(""+tbudgetperiodvalues.get(tmprow),Util.getIntValue(""+torgtypevalues.get(tmprow)),Util.getIntValue(""+torgidvalues.get(tmprow)),Util.getIntValue(""+tsubjectvalues.get(tmprow)));

%>
                    callback("<%=kpi%>","<%=tmprow%>",nrow);
<%
                    }
                }else if(fid.indexOf(loanbalance+"_")==0){
                    if(torgtypevalues.size()>=tmprow&&tbudgetperiodvalues.size()>=tmprow&&torgidvalues.size()>=tmprow&&tsubjectvalues.size()>=tmprow){
                        double loanamount=bp.getLoanAmount(Util.getIntValue(""+torgtypevalues.get(tmprow)),Util.getIntValue(""+torgidvalues.get(tmprow)));
%>
                    callback1("<%=loanamount%>",<%=tmprow%>,nrow);
<%
                    }
                }else if(fid.indexOf(oldamount+"_")==0){
                    if(torgtypevalues.size()>=tmprow&&tbudgetperiodvalues.size()>=tmprow&&torgidvalues.size()>=tmprow&&tsubjectvalues.size()>=tmprow){
                        double toldamount=bp.getBudgetByDate(""+tbudgetperiodvalues.get(tmprow),Util.getIntValue(""+torgtypevalues.get(tmprow)),Util.getIntValue(""+torgidvalues.get(tmprow)),Util.getIntValue(""+tsubjectvalues.get(tmprow)));
%>
                    callback2("<%=toldamount%>",<%=tmprow%>,nrow);
<%
                    }
                }
%>
    imghide(nrow,ncol);
    }
<%
            }
        }
    }
%>
}
function setnodevalue(){
    var wcell=frmmain.ChinaExcel;
	//先解析模板中相同行节点意见位置

	var node_row = new Array();
	var node_ids = new Array();
	var node_addrows = new Array();
	var border_row = new Array();
	var SetRowSize_row = new Array();
	var SetRowSize_size = new Array();
	<%
	for(int i=0;i<NodeList.size();i++){
	    String nodestr=(String)NodeList.get(i);
	    int nodeid = 0;
	    int indx = nodestr.lastIndexOf("_");
	    if(indx>0){
	        nodeid=Util.getIntValue(nodestr.substring(indx+1));
	    }
	%>
		
	    var nrow=wcell.GetCellUserStringValueRow("<%=nodestr%>");
	    if(nrow>0){
	    	var idx = node_row.indexOf(nrow);
	    	if(idx > -1) {
	    		var tmpnode_ids = node_ids[idx];
	    		//alert(tmpnode_ids);
	    		node_ids[idx].push('<%=nodeid%>');
	    	} else {
	    		node_row.push(nrow);
	    		node_ids.push(new Array('<%=nodeid%>'));
	    		node_addrows.push(0);
	    	}
	    }
	<%
	}
	%>
<%
for(int i=0;i<NodeList.size();i++){
    String nodestr=(String)NodeList.get(i);
    int nodeid=0;
    int indx=nodestr.lastIndexOf("_");
    if(indx>0){
        nodeid=Util.getIntValue(nodestr.substring(indx+1));
    }
    //增加自由流转节点
    String nodemark="";
    if(nodeid == 999999999){
    	nodemark = FieldInfo.GetfreeNodeRemark(workflowid,Util.getIntValue(_nodeid),0);
    }else{
    	nodemark = FieldInfo.GetNodeRemark(workflowid,nodeid,Util.getIntValue(_nodeid));
    }
	nodemark = nodemark.replaceAll("&ldquo;","“");
    nodemark = nodemark.replaceAll("&rdquo;","”");
%>
    var nrow=wcell.GetCellUserStringValueRow("<%=nodestr%>");
    if(nrow>0){
        var ncol=wcell.GetCellUserStringValueCol("<%=nodestr%>");    
		var idx = 0;
		var rowCnt = 0;
		for(var h = 0; h < node_ids.length; h++) {
			if(node_ids[h].indexOf('<%=nodeid%>') > -1) {
	    		idx = h;
	    		break;
			}
		}
		
		if(idx > -1) {
			rowCnt = node_addrows[idx];
		}
<%
		if(nodemark.indexOf("/weaver/weaver.file.FileDownload?fileid=")>=0
		   ||nodemark.indexOf("/weaver/weaver.file.ImgFileDownload?userid=")>=0
		   ||nodemark.indexOf("/weaver/weaver.file.SignatureDownLoad?markId=")>=0){
%>
	        wcell.SetCanRefresh(false);
<%
			List nodeRemarkListOfBeenSplited=FieldInfo.getNodeRemarkList(nodemark);
			Map nodeRemarkOfBeenSplitedMap=null;
			String imageNodeRemark=null;
			String strNodeRemark=null;
			int n=0;
			for(int j=0;j<nodeRemarkListOfBeenSplited.size();j++){
			    nodeRemarkOfBeenSplitedMap=(Map)nodeRemarkListOfBeenSplited.get(j);
			    imageNodeRemark=(String)nodeRemarkOfBeenSplitedMap.get("imageNodeRemark");
			    strNodeRemark=(String)nodeRemarkOfBeenSplitedMap.get("strNodeRemark");
				if(imageNodeRemark != null){
					imageNodeRemark = imageNodeRemark.replaceAll("\r\n", "<br>");
					imageNodeRemark = imageNodeRemark.replaceAll("\n", "<br>");
					imageNodeRemark = imageNodeRemark.replaceAll("\"", "\\\\\"");
					imageNodeRemark = imageNodeRemark.replaceAll("\'", "\\\\\'");
				}
			    strNodeRemark=(String)nodeRemarkOfBeenSplitedMap.get("strNodeRemark");
				if(strNodeRemark != null){
					strNodeRemark = strNodeRemark.replaceAll("\r\n", "<br>");
					strNodeRemark = strNodeRemark.replaceAll("\n", "<br>");
					strNodeRemark = strNodeRemark.replaceAll("\"", "\\\\\"");
					strNodeRemark = strNodeRemark.replaceAll("\'", "\\\\\'");
				}
				if(j>0){
					n++;
%>
				if(<%=n%> > rowCnt) {
					wcell.InsertOnlyFormatRows(nrow+<%=n%>-1, 1,nrow,nrow);
					for(k=0; k < border_row.length; k++){
						if(border_row[k] > nrow+<%=n%>) {
							border_row[k] = border_row[k] + 1;
						}
					}
					for(k=0; k < SetRowSize_row.length; k++){
						if(SetRowSize_row[k] > nrow+<%=n%>) {
							SetRowSize_row[k] = SetRowSize_row[k] + 1;
						}
					}
					if(border_row.indexOf(nrow+<%=n%>) == -1) {
						border_row.push(nrow+<%=n%>);//记录添加的行，清除上边框使用
					}
					//新加的行清除图片
					for(k=0; k<=wcell.GetMaxCol(); k++){
						isProtect=wcell.IsCellProtect(nrow+<%=n%>,k);
						if(isProtect){
							wcell.SetCellProtect(nrow+<%=n%>,k,nrow+<%=n%>,k,false);
							wcell.DeleteCellImage(nrow+<%=n%>,k,nrow+<%=n%>,k);
							wcell.SizeRowToFontSizeHeight(nrow+<%=n%>,nrow+<%=n%>,k, false);
						}
						if(isProtect){
							wcell.SetCellProtect(nrow+<%=n%>,k,nrow+<%=n%>,k,true);
						}
					}
					node_addrows[idx] = '<%=n%>';
				}
<%
				}
%>
			    isProtect=wcell.IsCellProtect(nrow+<%=n%>,ncol);
			    if(isProtect){
				    wcell.SetCellProtect(nrow+<%=n%>,ncol,nrow+<%=n%>,ncol,false);
			    }
<%
	BaseBean wfsbean=FieldInfo.getWfsbean();
	int rowheight=Util.getIntValue(wfsbean.getPropValue("WFSignatureImg","imgheight"),0);
	int imgshowtpe=Util.getIntValue(wfsbean.getPropValue("WFSignatureImg","imgshowtpe"),2);
	if(imageNodeRemark.indexOf("/weaver/weaver.file.ImgFileDownload?userid=")>=0){
%>
<%
                    if(rowheight>0){
%>
						if(SetRowSize_row.indexOf(nrow+<%=n%>) == -1) {
							SetRowSize_row.push(nrow+<%=n%>);
							SetRowSize_size.push(<%=rowheight%>);
						}
<%
                    }
%>
			        wcell.ReadHttpImageFile("<%=imageNodeRemark%>",nrow+<%=n%>,ncol,true,<%=(imgshowtpe==1)?true:false%>);
                    wcell.SetCellImageSize(nrow+<%=n%>,ncol,<%=imgshowtpe%>);
<%
	}else if(imageNodeRemark.indexOf("/weaver/weaver.file.FileDownload?fileid=")>=0){
%>
			    wcell.ReadHttpImageFile("<%=imageNodeRemark%>",nrow+<%=n%>,ncol,true,false);
				wcell.SetCellImageSize(nrow+<%=n%>,ncol,<%=imgshowtpe%>);
				if(SetRowSize_row.indexOf(nrow+<%=n%>) == -1) {
					SetRowSize_row.push(nrow+<%=n%>);
					SetRowSize_size.push(<%=rowheight%>);
				}
<%
	}else if(imageNodeRemark.indexOf("/weaver/weaver.file.SignatureDownLoad?markId=")>=0){
%>
	    wcell.ReadHttpImageFile("<%=imageNodeRemark%>",nrow+<%=n%>,ncol,true,false);
		wcell.SetCellImageSize(nrow+<%=n%>,ncol,<%=imgshowtpe%>);
		if(SetRowSize_row.indexOf(nrow+<%=n%>) == -1) {
			SetRowSize_row.push(nrow+<%=n%>);
			SetRowSize_size.push(<%=rowheight%>);
		}
<%
	}
	//TD47194，用于解决签字意见中插入图片之后再模板模式下不显示签字意见的问题。

	if(strNodeRemark==null)strNodeRemark="";
	String txtImageNodeRemark = imageNodeRemark;
	if(imageNodeRemark.startsWith("/weaver/weaver.file.FileDownload?fileid=")
			||imageNodeRemark.startsWith("/weaver/weaver.file.ImgFileDownload?userid=")
			||imageNodeRemark.startsWith("/weaver/weaver.file.SignatureDownLoad?markId=")){
		txtImageNodeRemark="";
	}
%>
			    var strNodeRemark = '<%=Util.encodeJS(FieldInfo.toExcel(FieldInfo.dropScript(strNodeRemark+txtImageNodeRemark)))%>';
    			strNodeRemark = getFckText(strNodeRemark);

<%
	if(imageNodeRemark.indexOf("/weaver/weaver.file.ImgFileDownload?userid=")>=0&&!strNodeRemark.equals("")){
%>
			    if(isProtect){
				    wcell.SetCellProtect(nrow+<%=n%>,ncol,nrow+<%=n%>,ncol,true);
			    }
<%
        n++;	
%>
			if(<%=n%> > rowCnt) {
			    wcell.InsertOnlyFormatRows(nrow+<%=n%>-1, 1,nrow,nrow);
				for(k=0; k < border_row.length; k++){
					if(border_row[k] > nrow+<%=n%>) {
						border_row[k] = border_row[k] + 1;
					}
				}
				for(k=0; k < SetRowSize_row.length; k++){
					if(SetRowSize_row[k] > nrow+<%=n%>) {
						SetRowSize_row[k] = SetRowSize_row[k] + 1;
					}
				}
				if(border_row.indexOf(nrow+<%=n%>) == -1) {
					border_row.push(nrow+<%=n%>);//记录添加的行，清除上边框使用
				}
				//新加的行清除图片
				for(k=0; k<=wcell.GetMaxCol(); k++){
					isProtect=wcell.IsCellProtect(nrow+<%=n%>,k);
					if(isProtect){
						wcell.SetCellProtect(nrow+<%=n%>,k,nrow+<%=n%>,k,false);
						wcell.DeleteCellImage(nrow+<%=n%>,k,nrow+<%=n%>,k);
						wcell.SizeRowToFontSizeHeight(nrow+<%=n%>,nrow+<%=n%>,k, false);
					}
					if(isProtect){
						wcell.SetCellProtect(nrow+<%=n%>,k,nrow+<%=n%>,k,true);
					}
				}
				node_addrows[idx] = '<%=n%>';
			}
			    isProtect=wcell.IsCellProtect(nrow+<%=n%>,ncol);
			    if(!isProtect){
				    wcell.SetCellProtect(nrow+<%=n%>,ncol,nrow+<%=n%>,ncol,true);
			    }
                wcell.SetCellVal(nrow+<%=n%>,ncol,getChangeField(strNodeRemark));
                wcell.SetCellHorzTextAlign(nrow+<%=n%>,ncol,nrow+<%=n%>,ncol,1);
                wcell.SetCellVertTextAlign(nrow+<%=n%>,ncol,nrow+<%=n%>,ncol,3);

			    if(isProtect){
				    wcell.SetCellProtect(nrow+<%=n%>,ncol,nrow+<%=n%>,ncol,true);
			    }
<%
	}else{
%>
	if(isProtect){
				    wcell.SetCellProtect(nrow+<%=n%>,ncol,nrow+<%=n%>,ncol,true);
			    }
<%
if("".equals(txtImageNodeRemark)) {
	//n++;
}else{
%>

				if(<%=n%> > rowCnt) {
				    wcell.InsertOnlyFormatRows(nrow+<%=n%>-1, 1,nrow,nrow);
					for(k=0; k < border_row.length; k++){
						if(border_row[k] > nrow+<%=n%>) {
							border_row[k] = border_row[k] + 1;
						}
					}
					for(k=0; k < SetRowSize_row.length; k++){
						if(SetRowSize_row[k] > nrow+<%=n%>) {
							SetRowSize_row[k] = SetRowSize_row[k] + 1;
						}
					}
					if(border_row.indexOf(nrow+<%=n%>) == -1) {
						border_row.push(nrow+<%=n%>);//记录添加的行，清除上边框使用
					}
					//新加的行清除图片
					for(k=0; k<=wcell.GetMaxCol(); k++){
						isProtect=wcell.IsCellProtect(nrow+<%=n%>,k);
						if(isProtect){
							wcell.SetCellProtect(nrow+<%=n%>,k,nrow+<%=n%>,k,false);
							wcell.DeleteCellImage(nrow+<%=n%>,k,nrow+<%=n%>,k);
							wcell.SizeRowToFontSizeHeight(nrow+<%=n%>,nrow+<%=n%>,k, false);
						}
						if(isProtect){
							wcell.SetCellProtect(nrow+<%=n%>,k,nrow+<%=n%>,k,true);
						}
					}
					node_addrows[idx] = '<%=n%>';
				}
		<%}%>
                wcell.SetCellVal(nrow+<%=n%>,ncol,getChangeField(strNodeRemark));
                wcell.SetCellHorzTextAlign(nrow+<%=n%>,ncol,nrow+<%=n%>,ncol,1);
                wcell.SetCellVertTextAlign(nrow+<%=n%>,ncol,nrow+<%=n%>,ncol,3);
			    if(isProtect){
				    wcell.SetCellProtect(nrow+<%=n%>,ncol,nrow+<%=n%>,ncol,true);
			    }
<%
	}
			}
%>
	        wcell.SetCanRefresh(true);
	        wcell.RefreshViewSize();
	        wcell.ReCalculate();
<%
		}else{
			 //去掉每条签字意见内容之后所添加的分隔符。

			nodemark = nodemark.replace(String.valueOf(FieldInfo.getNodeSeparator()), "").replace(String.valueOf(Util.getSeparator()),""); 
%>
			var nodemark = '<%out.print(Util.encodeJS(FieldInfo.toExcel(FieldInfo.dropScript(nodemark))));%>';
			nodemark = getFckText(nodemark);
			wcell.SetCellProtect(nrow,ncol,nrow,ncol,false);
			wcell.SetCellAutoWrap(nrow,ncol,nrow,ncol,true);
            wcell.SetCellVal(nrow,ncol,getChangeField(nodemark));
            imghide(nrow,ncol);
            wcell.SetCellProtect(nrow,ncol,nrow,ncol,true);
<%
		}
%>
		for(k=0; k<=wcell.GetMaxRow(); k++){
			var idx = SetRowSize_row.indexOf(k);
			//wcell.AutoSizeRow(k, k, true);
			if(idx > -1) {
				var iRow = SetRowSize_row[idx];
				var iRowSize = SetRowSize_size[idx];
				if(wcell.GetRowSize(iRow, 0) < iRowSize) {
					wcell.SetRowSize(iRow, iRow, iRowSize, 1);
				}
			}
		}
		SetRowSize_size = new Array();
		SetRowSize_row = new Array();
    }
<%
}   
%>
	//新添加的行清除上边框的操作移到下面处理，提高效率
	if(border_row.length > 0) {
		for(var h = 0; h < border_row.length; h++) {
			for(k=0;k<=wcell.GetMaxCol();k++){
				isProtect=wcell.IsCellProtect(border_row[h],k);
				if(isProtect){
					wcell.SetCellProtect(border_row[h],k,border_row[h],k,false);
				}
			    wcell.ClearCellBorder(border_row[h],k, border_row[h], k, 2);
				if(isProtect){
					wcell.SetCellProtect(border_row[h],k,border_row[h],k,true);
				}
			}
		}
	
		wcell.SetCanRefresh(true);
		wcell.RefreshViewSize();
		wcell.ReCalculate();
	}
}

function createDocForNewTab(tmpfid,isedit){
  
   if(tmpfid==null||tmpfid==""){
	   return ;
   }

   var fieldbodyid="0";

   if(tmpfid.length>5){
	   fieldbodyid=tmpfid.substring(5);
   }
	/*
   for(i=0;i<=1;i++){
  		parent.$G("oTDtype_"+i).background="/images/tab2_wev8.png";
  		parent.$G("oTDtype_"+i).className="cycleTD";
  	}
  	parent.$G("oTDtype_1").background="/images/tab.active2_wev8.png";
  	parent.$G("oTDtype_1").className="cycleTDCurrent";
  	*/
	var docValue=$G(tmpfid).value;

  	frmmain.action = "RequestDocView.jsp?docView="+isedit+"&docValue="+docValue+"&requestid="+<%=requestid%>+"&desrequestid="+<%=desrequestid%>;
    frmmain.method.value = "crenew_"+fieldbodyid ;
	frmmain.target="delzw";
    parent.delsave();
	if(check_form(document.frmmain,'requestname')){
      	if($G("needoutprint")) $G("needoutprint").value = "1";//标识点正文

        document.frmmain.src.value='save';
        //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
		parent.clicktext();//切换当前tab页到正文页面
		if($G("needoutprint")) $G("needoutprint").value = "";//标识点正文

    }
}
function accesoryChanage(obj,maxUploadImageSize){
    var objValue = obj.value;
    if (objValue=="") return ;
    var fileLenth;
    try {
        var oFile=$G("oFile");
        oFile.FilePath=objValue;
        fileLenth= oFile.getFileSize();
    } catch (e){
		if(e.message=="<%=SystemEnv.getHtmlLabelName(83411,user.getLanguage())%>"||e.message=="<%=SystemEnv.getHtmlLabelName(83411,user.getLanguage())%>"){
			alert("<%=SystemEnv.getHtmlLabelName(21015,Languageid)%> ");
		}else{
			alert("<%=SystemEnv.getHtmlLabelName(21090,Languageid)%> ");
		}
        createAndRemoveObj(obj);
        return  ;
    }
    if (fileLenth==-1) {
        createAndRemoveObj(obj);
        return ;
    }
    var fileLenthByM = (fileLenth/(1024*1024)).toFixed(1)
    if (fileLenthByM>maxUploadImageSize) {
     	alert("<%=SystemEnv.getHtmlLabelName(20254,Languageid)%>"+fileLenthByM+"M,<%=SystemEnv.getHtmlLabelName(20255,Languageid)%>"+maxUploadImageSize+"M<%=SystemEnv.getHtmlLabelName(20256 ,Languageid)%>");
        createAndRemoveObj(obj);
    }
}

function createAndRemoveObj(obj){
    objName = obj.name;
    tempObjonchange=obj.onchange;
    outerHTML="<input name="+objName+" class=InputStyle type=file size=50 >";
    $G(objName).outerHTML=outerHTML;
    $G(objName).onchange=tempObjonchange;
}
function addannexRow(accname,maxsize)
  {
    $G(accname+'_num').value=parseInt($G(accname+'_num').value)+1;
    ncol = $G(accname+'_tab').cols;
    oRow = $G(accname+'_tab').insertRow(-1);
    for(j=0; j<ncol; j++) {
      oCell = oRow.insertCell(-1); 

      switch(j) {
        case 0:
          var oDiv = document.createElement("div");
          oCell.colSpan=3;
          var sHtml = "<input class=InputStyle  type=file size=50 name='"+accname+"_"+$G(accname+'_num').value+"' onchange='accesoryChanage(this,"+maxsize+")'> (<%=SystemEnv.getHtmlLabelName(18976,Languageid)%>"+maxsize+"<%=SystemEnv.getHtmlLabelName(18977,Languageid)%>) ";
          oDiv.innerHTML = sHtml;
          oCell.appendChild(oDiv);
          break;
      }
    }
  }

 function onChangeSharetype(delspan,delid,ismand,maxUploadImageSize){
	fieldid=delid.substr(0,delid.indexOf("_"));
	fieldidnum=fieldid+"_idnum_1";
	fieldidspan=fieldid+"span";
	fieldidspans=fieldid+"spans";
	fieldid=fieldid+"_1";
	 var sHtml = "<input class=InputStyle  type=file size=50 name="+fieldid+" onchange='accesoryChanage(this,"+maxUploadImageSize+")'> (<%=SystemEnv.getHtmlLabelName(18976,Languageid)%>"+maxUploadImageSize+"<%=SystemEnv.getHtmlLabelName(18977,Languageid)%>) ";
	 var sHtml1 = "<input class=InputStyle  type=file size=50 name="+fieldid+" onchange=\"accesoryChanage(this,"+maxUploadImageSize+");checkinput(\'"+fieldid+"\',\'"+fieldidspan+"\')\"> (<%=SystemEnv.getHtmlLabelName(18976,Languageid)%>"+maxUploadImageSize+"<%=SystemEnv.getHtmlLabelName(18977,Languageid)%>) ";

    if($G(delspan).style.visibility=='visible'){
      $G(delspan).style.visibility='hidden';
      $G(delid).value='0';
	  $G(fieldidnum).value=parseInt($G(fieldidnum).value)+1;
    }else{
      $G(delspan).style.visibility='visible';
      $G(delid).value='1';
	  $G(fieldidnum).value=parseInt($G(fieldidnum).value)-1;
    }
	//alert($G(fieldidnum).value);
	if (ismand=="1")
	  {
	if ($G(fieldidnum).value=="0")
	  {
	    $G("needcheck").value=$G("needcheck").value+","+fieldid;
		$G(fieldidspan).innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";

		//$G(fieldidspans).innerHTML=sHtml1;
	  }
	  else
	  {   if ($G("needcheck").value.indexOf(","+fieldid)>0)
		  {
	     $G("needcheck").value=$G("needcheck").value.substr(0,$G("needcheck").value.indexOf(","+fieldid));
		 $G(fieldidspan).innerHTML="";
		 //$G(fieldidspans).innerHTML=sHtml;
		  }
	  }
	  }
  }

function callback(o, index,nrow) {
    val = o.split("|");
    //alert(o);
    if (val[0] != "") {
        v = val[0].split(",");
        hrmremainstr = "<%=SystemEnv.getHtmlLabelName(18768,user.getLanguage())%>:" + v[0] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18503,user.getLanguage())%>:" + v[1] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18769,user.getLanguage())%>:" + v[2];
        var hrmremaincol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=hrmremain%>_" + index + "_<%=hrmremaintype%>");
        if (hrmremaincol > 0) {
            frmmain.ChinaExcel.SetCellProtect(nrow, hrmremaincol, nrow, hrmremaincol, false);
            frmmain.ChinaExcel.SetCellVal(nrow, hrmremaincol, getChangeField(hrmremainstr));
            frmmain.ChinaExcel.SetCellProtect(nrow, hrmremaincol, nrow, hrmremaincol, true);
        }
    }
    if (val[1] != "") {
        v = val[1].split(",");
        deptremainstr = "<%=SystemEnv.getHtmlLabelName(18768,user.getLanguage())%>:" + v[0] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18503,user.getLanguage())%>:" + v[1] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18769,user.getLanguage())%>:" + v[2];
        var deptremaincol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=deptremain%>_" + index + "_<%=deptremaintype%>");
        //alert(nrow+"+"+deptremaincol+"|"+deptremainstr);
        if (deptremaincol > 0) {
            frmmain.ChinaExcel.SetCellProtect(nrow, deptremaincol, nrow, deptremaincol, false);
            frmmain.ChinaExcel.SetCellVal(nrow, deptremaincol, getChangeField(deptremainstr));
            frmmain.ChinaExcel.SetCellProtect(nrow, deptremaincol, nrow, deptremaincol, true);
        }
    }
    if (val[2] != "") {
        v = val[2].split(",");
        subcomremainstr = "<%=SystemEnv.getHtmlLabelName(18768,user.getLanguage())%>:" + v[0] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18503,user.getLanguage())%>:" + v[1] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18769,user.getLanguage())%>:" + v[2];
        var subcomremaincol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=subcomremain%>_" + index + "_<%=subcomremaintype%>");
        //alert(nrow+"+"+subcomremaincol+"|"+subcomremainstr);
        if (subcomremaincol > 0) {
            frmmain.ChinaExcel.SetCellProtect(nrow, subcomremaincol, nrow, subcomremaincol, false);
            frmmain.ChinaExcel.SetCellVal(nrow, subcomremaincol, getChangeField(subcomremainstr));
            frmmain.ChinaExcel.SetCellProtect(nrow, subcomremaincol, nrow, subcomremaincol, true);
        }
    }
    frmmain.ChinaExcel.RefreshViewSize();
}

function callback1(o, index,nrow) {
    //alert(o);
    if($G("<%=loanbalance%>_" + index)!=null){
        $G("<%=loanbalance%>_" + index).value = o;
    }
    var loanbalancecol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=loanbalance%>_" + index + "_<%=loanbalancetype%>");
    if (loanbalancecol > 0) {
        frmmain.ChinaExcel.SetCellProtect(nrow, loanbalancecol, nrow, loanbalancecol, false);
        frmmain.ChinaExcel.SetCellVal(nrow, loanbalancecol, getChangeField(o));
        frmmain.ChinaExcel.SetCellProtect(nrow, loanbalancecol, nrow, loanbalancecol, true);
    }
    frmmain.ChinaExcel.RefreshViewSize();
}
function callback2(o, index,nrow) {
    //alert(o);
    if($G("<%=oldamount%>_" + index)!=null){
        $G("<%=oldamount%>_" + index).value = o;
    }
    var oldamountcol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=oldamount%>_" + index + "_<%=oldamounttype%>");
    if (oldamountcol > 0) {
        frmmain.ChinaExcel.SetCellProtect(nrow, oldamountcol, nrow, oldamountcol, false);
        frmmain.ChinaExcel.SetCellVal(nrow, oldamountcol, getChangeField(o));
        frmmain.ChinaExcel.SetCellProtect(nrow, oldamountcol, nrow, oldamountcol, true);
    }
    frmmain.ChinaExcel.RefreshViewSize();
}
function getOuterLanguage()
{
	return '<%=acceptlanguage%>';
}
</script>
<script language=javascript src="/js/characterConv_wev8.js"></script>
<script language=vbs src="/workflow/mode/loadmode.vbs"></script>