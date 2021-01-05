<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@page import="weaver.conn.RecordSet"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,weaver.general.BaseBean" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<%@ page import="weaver.workflow.datainput.DynamicDataInput"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WfLinkageInfo" class="weaver.workflow.workflow.WfLinkageInfo" scope="page"/>
<jsp:useBean id="urlcominfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page" />
<%
RecordSet rs_11 = new RecordSet();

boolean fnaBudgetOAOrg = false;//OA组织机构
boolean fnaBudgetCostCenter = false;//成本中心
rs_11.executeSql("select * from FnaSystemSet");
if(rs_11.next()){
	fnaBudgetOAOrg = 1==rs_11.getInt("fnaBudgetOAOrg");
	fnaBudgetCostCenter = 1==rs_11.getInt("fnaBudgetCostCenter");
}

String acceptlanguage = request.getHeader("Accept-Language");
if(!"".equals(acceptlanguage))
	acceptlanguage = acceptlanguage.toLowerCase();
//TD9892
BaseBean bb_loadmode = new BaseBean();
int urm_loadmode = 1;
try{
	urm_loadmode = Util.getIntValue(bb_loadmode.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}

User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

String isbill = Util.null2String(request.getParameter("isbill"));
int workflowid = Util.getIntValue(request.getParameter("workflowid"));
int isform = Util.getIntValue(request.getParameter("isform"));
int modeid = Util.getIntValue(request.getParameter("modeid"));
int nodeid = Util.getIntValue(request.getParameter("nodeid"));
int formid = Util.getIntValue(request.getParameter("formid"));
String isHideInput = "" + Util.getIntValue(request.getParameter("isHideInput"), 0);

FieldInfo.setUser(user);
FieldInfo.GetManTableField(formid,Util.getIntValue(isbill),user.getLanguage());
FieldInfo.GetDetailTableField(formid,Util.getIntValue(isbill),user.getLanguage());
FieldInfo.GetWorkflowNode(workflowid);
boolean isFnabill=false;
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
String fccremain="";
String fccremaintype="";
String loanbalance="";
String loanbalancetype="";
String oldamount="";
String oldamounttype="";
 int uploadType = 0;
 String selectedfieldid = "";
 String result = RequestManager.getUpLoadTypeForSelect(workflowid);
 if(!result.equals("")){
     uploadType = Integer.valueOf(result.substring(result.indexOf(",")+1)).intValue();
     selectedfieldid = result.substring(0,result.indexOf(","));
 }
if(isbill.equals("1")&&(formid==156 ||formid==157 ||formid==158 ||formid==159)){
    isFnabill=true;
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
        if("fccremain".equals(Util.null2String(RecordSet.getString("fieldname")).toLowerCase())){
        	fccremain="field"+RecordSet.getString("id");
        	fccremaintype=RecordSet.getString("type")+"_"+RecordSet.getString("fieldhtmltype");
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

String isFormSignature=null;
int formSignatureWidth=RevisionConstants.Form_Signature_Width_Default;
int formSignatureHeight=RevisionConstants.Form_Signature_Height_Default;
RecordSet.executeSql("select isFormSignature,formSignatureWidth,formSignatureHeight from workflow_flownode where workflowId="+workflowid+" and nodeId="+nodeid);
if(RecordSet.next()){
	isFormSignature = Util.null2String(RecordSet.getString("isFormSignature"));
	formSignatureWidth= Util.getIntValue(RecordSet.getString("formSignatureWidth"),RevisionConstants.Form_Signature_Width_Default);
	formSignatureHeight= Util.getIntValue(RecordSet.getString("formSignatureHeight"),RevisionConstants.Form_Signature_Height_Default);
}
boolean ispopup=false;
RecordSet.executeSql("select isannexUpload from workflow_base where (isannexUpload='1' or isSignDoc='1' or isSignWorkflow='1') and id="+workflowid);
if(RecordSet.next()){
	ispopup=true;
}
ArrayList selfieldsadd=WfLinkageInfo.getSelectField(workflowid,nodeid,0);
ArrayList seldefieldsadd=WfLinkageInfo.getSelectField(workflowid,nodeid,1);
ArrayList changedefieldsmanage=WfLinkageInfo.getChangeField(workflowid,nodeid,1);
String selfieldsaddString = "";
for(int i=0;i<selfieldsadd.size();i++){
    selfieldsaddString += (String)selfieldsadd.get(i)+",";
}
if(!selfieldsaddString.equals("")) selfieldsaddString = selfieldsaddString.substring(0,selfieldsaddString.length()-1);
//获得触发字段名
DynamicDataInput ddi=new DynamicDataInput(workflowid+"");
String trrigerfield=ddi.GetEntryTriggerFieldName();
String trrigerdetailfield=ddi.GetEntryTriggerDetailFieldName();
ArrayList Linfieldname=ddi.GetInFieldName();
ArrayList Lcondetionfieldname=ddi.GetConditionFieldName();
%>
<script type="text/javascript">
var trrigerfields="<%=trrigerfield%>";
var trrigerdetailfields="<%=trrigerdetailfield%>";
var trrigerfieldary=trrigerfields.split(",");
var trrigerdetailfieldary=trrigerdetailfields.split(",");
</script>
<div style="width: 0px;height: 0px!important;">
<iframe id="modeComboChange" id="modeComboChange" frameborder=0 scrolling=no src=""  style="display:none" ></iframe>
<iframe id="datainputform" frameborder=0 height="0" width="0" scrolling=no src=""  style="display:none"></iframe>
<iframe id="datainputformdetail" frameborder=0 height="0" width="0" scrolling=no src=""  style="display:none"></iframe>
<iframe ID="selframe" BORDER=0 FRAMEBORDER=no height="0%" width="0%" scrolling="NO" src=""></iframe>
<iframe id="workflowKeywordIframe" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
</div>
<script language=javascript src="/workflow/mode/loadmode_wev8.js"></script>
<script type='text/javascript' src='/dwr/interface/BudgetHandler.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<script language=javascript src="/js/characterConv_wev8.js"></script>
<script language=javascript >
function getOuterLanguage()
{
	return '<%=acceptlanguage%>';
}
var isInit = true;
</SCRIPT>
<SCRIPT FOR="ChinaExcel" EVENT="ShowCellChanged()"	LANGUAGE="JavaScript" >
var nowrow=frmmain.ChinaExcel.Row;
var nowcol=frmmain.ChinaExcel.Col;
var uservalue=frmmain.ChinaExcel.GetCellUserStringValue(nowrow,nowcol);
var cellvalue=frmmain.ChinaExcel.GetCellValue(nowrow,nowcol);
if ("qianzi"==uservalue && "<%=isHideInput%>" == "1") {
	frmmain.ChinaExcel.SetCellProtect(nowrow, nowcol, nowrow, nowcol, true);
}
cellvalue = Simplized(cellvalue);
var ismand=frmmain.ChinaExcel.GetCellUserValue(nowrow,nowcol);
var fieldname=uservalue;
if(fieldname!=null){
    var indx=fieldname.lastIndexOf("_");
        if(indx>0){
        var addordel=fieldname.substring(indx+1);
        fieldname=fieldname.substring(0,indx);
        indx=fieldname.lastIndexOf("_");
		var htmltype = 0;
        if(indx>0){
			htmltype = fieldname.substring(indx+1);
            fieldname=fieldname.substring(0,indx);
        }
        if(addordel=="sel"){                
        		if(isHiddenPop(uservalue))return false;
                frmmain.ChinaExcel.SetCellCheckBoxValue(nowrow,nowcol,!frmmain.ChinaExcel.GetCellCheckBoxValue(nowrow,nowcol));
                return false;
        }else if(addordel == "3" && htmltype == "34") {//added by wcd 2015-08-24
			return false;
		}else{
            if(addordel=="4" &&  ismand>0){
            	if(isHiddenPop(uservalue))return false;
            	frmmain.ChinaExcel.SetCellProtect(nowrow,nowcol,nowrow,nowcol,true);
                frmmain.ChinaExcel.SetCellCheckBoxValue(nowrow,nowcol,!frmmain.ChinaExcel.GetCellCheckBoxValue(nowrow,nowcol));
                var checkvalue="0";
                if(GetCellCheckBoxValue(nowrow,nowcol)){
                    checkvalue="1";
                }
                $G(fieldname).value=checkvalue;
                DataInputByBrowser(fieldname);
                return false;
            }
        }
    }
}
showPopup(uservalue,cellvalue,ismand,1);
	return false;
</script>
<SCRIPT FOR="ChinaExcel" EVENT="MouseLClick(Row, Col, UpDown)"	LANGUAGE="JavaScript" >
	<%if(urm_loadmode==1){%>
    //rightMenu.style.visibility="hidden";
    hideRightClickMenu();
    <%}%>
    var nowrow=frmmain.ChinaExcel.Row;
    var nowcol=frmmain.ChinaExcel.Col;
    var uservalue=frmmain.ChinaExcel.GetCellUserStringValue(nowrow,nowcol); 
    var ismand=frmmain.ChinaExcel.GetCellUserValue(nowrow,nowcol);
    var fieldname=uservalue;
    var changefields="";
	var upDown = UpDown;
	if(upDown == 0){//only for mouse left up
    <%
    for(int i=0;i<changedefieldsmanage.size();i++){
    %>
    changefields+=",<%=changedefieldsmanage.get(i)%>";
    <%
    }
    %>
    if(uservalue!=null){
    	if(uservalue=="qianzi"&&ismand==1&&(<%=ispopup%>||"<%=isFormSignature%>"==1)){
    		var remark = $G("remark").value;
            var signdocids = $G("signdocids").value;
            var signworkflowids = $G("signworkflowids").value;
    		var workflowRequestLogId = $G("workflowRequestLogId").value;
        var fieldvalue=$G(uservalue).value;
        if(isHiddenPop(uservalue)){
        	ismand=0;
        	if(fieldvalue=="")return ;//无附件
        }
        var redirectUrl = "/workflow/request/WorkFlowSignUP.jsp?nodeid=<%=nodeid%>&fieldvalue="+fieldvalue+"&fieldname="+fieldname+"&workflowid=<%=workflowid%>&fieldid="+uservalue+"&isedit="+ismand+"&isFormSignature=<%=isFormSignature%>&formSignatureWidth=<%=formSignatureWidth%>&formSignatureHeight=<%=formSignatureHeight%>&remark="+remark+"&workflowRequestLogId="+workflowRequestLogId+"&signdocids="+signdocids+"&signworkflowids="+signworkflowids;
        var szFeatures = "top="+(screen.height-300)/2+"," ;
        szFeatures +="left="+(screen.width-750)/2+"," ;
        szFeatures +="width=750," ;
        szFeatures +="height=300," ; 
        szFeatures +="directories=no," ;
        szFeatures +="status=no," ;
        szFeatures +="menubar=no," ;
        szFeatures +="scrollbars=yes," ;
        szFeatures +="resizable=no" ; //channelmode
        window.open(redirectUrl,"fileup",szFeatures);                
        frmmain.ChinaExcel.GoToCell(1,1);
    	}else{
        var indx=uservalue.lastIndexOf("_");
        var uservalues =  uservalue.split("_");
        var isdetail = (uservalues.length>3)?1:0;
        if(indx>0){
            var addordel=uservalue.substring(indx+1);
            uservalue=uservalue.substring(0,indx);
            
            if(addordel=="add"){
  				//获取当前滚动条起始位置
            	var startCol = frmmain.ChinaExcel.GetStartCol();
            	isInit = true;
                rowIns(uservalue.substring(6),0,1,changefields);
                isInit = false;
                setheight();
                //将当前滚动条设置为添加前的位置
                frmmain.ChinaExcel.SetHScrollPos(startCol);
            }
            if(addordel=="del"){
                rowDel(uservalue.substring(6));
                setheight();
            }
            if(addordel=="showKeyword"){
                onShowKeyword();
            }
            if(addordel=="6" && ismand>0){
                indx=uservalue.indexOf("_");
                if(indx>0){
                    uservalue=uservalue.substring(0,indx);
                }
                if(isdetail==1){
                	uservalue=uservalues[0]+"_"+uservalues[1];
                }
                var fieldvalue=$G(uservalue).value;
                var selectfieldvalue="";
                <%
                if(!selectedfieldid.equals("")){
                %>
                if($G("field<%=selectedfieldid%>")) selectfieldvalue=$G("field<%=selectedfieldid%>").value
                <%}%>
                if(isHiddenPop(uservalue)){
		        	ismand=0;
		        	if(fieldvalue=="")return ;//无附件
		        }
                var redirectUrl = "/workflow/request/WorkFlowFileUP.jsp?fieldvalue="+fieldvalue+"&fieldname="+fieldname+"&workflowid=<%=workflowid%>&fieldid="+uservalue+"&isedit="+ismand+"&isbill=<%=isbill%>&uploadType=<%=uploadType%>&selectedfieldid=<%=selectedfieldid%>&selectfieldvalue="+selectfieldvalue;
                var szFeatures = "top="+(screen.height-300)/2+"," ;
                szFeatures +="left="+(screen.width-750)/2+"," ;
                szFeatures +="width=750," ;
                szFeatures +="height=300," ; 
                szFeatures +="directories=no," ;
                szFeatures +="status=no," ;
                szFeatures +="menubar=no," ;
                szFeatures +="scrollbars=yes," ;
                szFeatures +="resizable=no" ; //channelmode
                window.open(redirectUrl,"fileup",szFeatures);
				frmmain.ChinaExcel.SetCellProtect(nowrow,nowcol,nowrow,nowcol,true);
                frmmain.ChinaExcel.GoToCell(1,1);                
            }
        }
      }
    }
	}else{
		//frmmain.ChinaExcel.GoToCell(1,1);
	}
	setheight();
    frmmain.ChinaExcel.RefreshViewSize();
	return false;
</SCRIPT>
<SCRIPT FOR="ChinaExcel" EVENT="MouseRClick()"	LANGUAGE="JavaScript" >
        hidePopup();
        <%if(urm_loadmode==1){%>
        var divBillScrollTop=parent.$G("divWfBill").scrollTop;
		showRightClickMenuByHand((frmmain.ChinaExcel.offsetLeft+frmmain.ChinaExcel.GetMousePosX()),(frmmain.ChinaExcel.offsetTop+frmmain.ChinaExcel.GetMousePosY()-divBillScrollTop));
		try{
			event.stopPropagation();
		}catch(e){
			try{
				event.cancelBubble = true
				event.returnValue = false;
			}catch(e){}
		} 
		
		<%}%>
		return false;
</SCRIPT>
<SCRIPT FOR="ChinaExcel" EVENT="CellContentChanged(row, col)"	LANGUAGE="JavaScript" >
    imgshoworhide(row,col); 
    var uservalue=frmmain.ChinaExcel.GetCellUserStringValue(row,col);
    var cellvalue=frmmain.ChinaExcel.GetCellValue(row,col);
    cellvalue = Simplized(cellvalue);
    var ismand=frmmain.ChinaExcel.GetCellUserValue(row,col);
    changevalue(uservalue,cellvalue,ismand);
    changeKeyword(uservalue,cellvalue,ismand);
    var fieldname=uservalue;
    if(fieldname!=null){
        var indx=fieldname.lastIndexOf("_");
        if(indx>0){
        	var htmltype=fieldname.substring(fieldname.lastIndexOf("_")+1);
            var addordel=fieldname.substring(indx+1);
            fieldname=fieldname.substring(0,indx);
            indx=fieldname.lastIndexOf("_");
            if (htmltype == 5) return;
            if(indx>0){
				if(htmltype == 3 && fieldname.substring(indx+1) == 34) {//added by wcd 2015-08-24
					if(ismand==2){
						if(cellvalue!=null && cellvalue!=""){
							frmmain.ChinaExcel.DeleteCellImage(row,col,row,col);
						} else {
							frmmain.ChinaExcel.ReadHttpImageFile("/images/BacoError_wev8.gif",row,col,true,true);
						}
					}
					return false;
				}
                fieldname=fieldname.substring(0,indx);
                DataInputByBrowser(fieldname);
            }
        }
    }
    frmmain.ChinaExcel.RefreshViewSize();
	return false;
</script>
<SCRIPT FOR="ChinaExcel" EVENT="RegionHaveChanged(StartRow, StartCol, EndRow, EndCol)"	LANGUAGE="JavaScript" >
try {
	if(!isInit) {
		if(StartRow <= EndRow && StartCol <= EndCol) {
			for(var i=parseInt(StartRow); i <= parseInt(EndRow); i++) {
				for(var j=StartCol; j <= EndCol; j++) {
					frmmain.ChinaExcel.FireCellContentChangedEvent(i,j);
				}
			}
		}
	}
}catch(e) {}
</SCRIPT>
<SCRIPT FOR="ChinaExcel" EVENT="ComboSelEnd()"	LANGUAGE="JavaScript" >
    var nrow= frmmain.ChinaExcel.Row;
    var ncol=frmmain.ChinaExcel.Col;
    var selvalue=frmmain.ChinaExcel.GetCellComboSelectedActualValue(nrow,ncol);
    var uservalue=frmmain.ChinaExcel.GetCellUserStringValue(nrow,ncol);
    var nindx=uservalue.lastIndexOf("_");
    var fieldid="-1";
    var rownum=-1;
    <%if(isFnabill){%>
    var tindx=uservalue.indexOf("_");
    if(tindx>0){
        var tfieldname=uservalue.substring(0,tindx);
        var tlastfield=uservalue.substring(tindx+1);
        if(tfieldname=="<%=organizationtype%>"){
            tindx=tlastfield.indexOf("_");
            if(tindx>0){
                var trow=tlastfield.substring(0,tindx);
                if($G("<%=organizationtype%>_"+trow)){
                    var oldtype=$G("<%=organizationtype%>_"+trow).value;
                    var tfieldid="<%=organizationid%>_"+trow;
                    if(oldtype==1){
                        tfieldid+="_164_3";
                    }else if(oldtype==2){
                        tfieldid+="_4_3";
                    }else if(oldtype==<%=FnaCostCenter.ORGANIZATION_TYPE %>){
                        tfieldid+="_251_3";
                    }else{
                        tfieldid+="_1_3";
                    }
                    var orgidcol=frmmain.ChinaExcel.GetCellUserStringValueCol(tfieldid);
                    if(orgidcol>0){
                        tfieldid="<%=organizationid%>_"+trow;
                        var turl="";
                        var turllink="";
                        if(selvalue==1){
                            tfieldid+="_164_3";
                            turl='<%=urlcominfo.getBrowserurl("164")%>';
                            turllink='<%=urlcominfo.getLinkurl("164")%>';
                        }else if(selvalue==2){
                            tfieldid+="_4_3";
                            turl='<%=urlcominfo.getBrowserurl("4")%>';
                            turllink='<%=urlcominfo.getLinkurl("4")%>';
                        }else if(selvalue==<%=FnaCostCenter.ORGANIZATION_TYPE %>){
                            tfieldid+="_251_3";
                            turl='<%=urlcominfo.getBrowserurl("251")%>';
                            turllink='<%=urlcominfo.getLinkurl("251")%>';
                        }else{
                            tfieldid+="_1_3";
                            turl='<%=urlcominfo.getBrowserurl("1")%>';
                            turllink='<%=urlcominfo.getLinkurl("1")%>';
                        }
                        frmmain.ChinaExcel.SetCellProtect(nrow,orgidcol,nrow,orgidcol,false);
                        frmmain.ChinaExcel.SetCellUserStringValue(nrow,orgidcol,nrow,orgidcol,tfieldid);
                        frmmain.ChinaExcel.SetCellVal(nrow,orgidcol,"");
                        imgshoworhide(nrow,orgidcol);
                        frmmain.ChinaExcel.SetCellProtect(nrow,orgidcol,nrow,orgidcol,true);
                        if($G("<%=organizationid%>_"+trow)){
                        	$G("<%=organizationid%>_"+trow).value="";
                        }
                        if($G("<%=organizationid%>_"+trow+"_url")){
                        	$G("<%=organizationid%>_"+trow+"_url").value=turl;
                        }
                        if($G("<%=organizationid%>_"+trow+"_urllink")){
                        	$G("<%=organizationid%>_"+trow+"_urllink").value=turllink;
                        }
                        if($G("<%=hrmremain%>_"+trow)){
                        	$G("<%=hrmremain%>_"+trow).value="";
                        }
                        if($G("<%=deptremain%>_"+trow)){
                            $G("<%=deptremain%>_"+trow).value="";
                        }
                        if($G("<%=subcomremain%>_"+trow)){
                        	$G("<%=subcomremain%>_"+trow).value="";
                        }
                        if($G("<%=fccremain%>_"+trow)){
                        	$G("<%=fccremain%>_"+trow).value="";
                        }
                        if($G("<%=loanbalance%>_"+trow)){
                        	$G("<%=loanbalance%>_"+trow).value="";
                        }
                        if($G("<%=oldamount%>_"+trow)){
                        	$G("<%=oldamount%>_"+trow).value="";
                        }
                        var hrmremaincol=frmmain.ChinaExcel.GetCellUserStringValueCol("<%=hrmremain%>_"+trow+"_<%=hrmremaintype%>");
                        if(hrmremaincol>0){
                            frmmain.ChinaExcel.SetCellProtect(nrow,hrmremaincol,nrow,hrmremaincol,false);
                            frmmain.ChinaExcel.SetCellVal(nrow,hrmremaincol,"");
                            frmmain.ChinaExcel.SetCellProtect(nrow,hrmremaincol,nrow,hrmremaincol,true);
                        }
                        var deptremaincol=frmmain.ChinaExcel.GetCellUserStringValueCol("<%=deptremain%>_"+trow+"_<%=deptremaintype%>");
                        if(deptremaincol>0){
                            frmmain.ChinaExcel.SetCellProtect(nrow,deptremaincol,nrow,deptremaincol,false);
                            frmmain.ChinaExcel.SetCellVal(nrow,deptremaincol,"");
                            frmmain.ChinaExcel.SetCellProtect(nrow,deptremaincol,nrow,deptremaincol,true);
                        }
                        var subcomremaincol=frmmain.ChinaExcel.GetCellUserStringValueCol("<%=subcomremain%>_"+trow+"_<%=subcomremaintype%>");
                        if(subcomremaincol>0){
                            frmmain.ChinaExcel.SetCellProtect(nrow,subcomremaincol,nrow,subcomremaincol,false);
                            frmmain.ChinaExcel.SetCellVal(nrow,subcomremaincol,"");
                            frmmain.ChinaExcel.SetCellProtect(nrow,subcomremaincol,nrow,subcomremaincol,true);
                        }
                        var fccremaincol=frmmain.ChinaExcel.GetCellUserStringValueCol("<%=fccremain%>_"+trow+"_<%=fccremaintype%>");
                        if(fccremaincol>0){
                            frmmain.ChinaExcel.SetCellProtect(nrow,fccremaincol,nrow,fccremaincol,false);
                            frmmain.ChinaExcel.SetCellVal(nrow,fccremaincol,"");
                            frmmain.ChinaExcel.SetCellProtect(nrow,fccremaincol,nrow,fccremaincol,true);
                        }
                        var loanbalancecol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=loanbalance%>_" + trow + "_<%=loanbalancetype%>");
                        if (loanbalancecol > 0) {
                            frmmain.ChinaExcel.SetCellProtect(nrow, loanbalancecol, nrow, loanbalancecol, false);
                            frmmain.ChinaExcel.SetCellVal(nrow, loanbalancecol, "");
                            frmmain.ChinaExcel.SetCellProtect(nrow, loanbalancecol, nrow, loanbalancecol, true);
                        }
                        var oldamountcol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=oldamount%>_" + trow + "_<%=oldamounttype%>");
                        if (oldamountcol > 0) {
                            frmmain.ChinaExcel.SetCellProtect(nrow, oldamountcol, nrow, oldamountcol, false);
                            frmmain.ChinaExcel.SetCellVal(nrow, oldamountcol, "");
                            frmmain.ChinaExcel.SetCellProtect(nrow, oldamountcol, nrow, oldamountcol, true);
                            frmmain.ChinaExcel.ReCalculate();
                        }
                    }
                }
            }
        }
    }
    <%}%>
    if(uservalue!="requestlevel"&&uservalue!="messageType"){
	    if(nindx>0){
	        uservalue=uservalue.substring(0,nindx);
	        nindx=uservalue.lastIndexOf("_");
	        if(nindx>0){
	            uservalue=uservalue.substring(0,nindx);
                nindx=uservalue.lastIndexOf("_");
                if(nindx>0){
                    fieldid=uservalue.substring(5,nindx);
                    rownum=uservalue.substring(nindx+1);
                }else{
                    fieldid=uservalue.substring(5);
                }
            }
	    }
	  }
    $G(uservalue).value=selvalue;
    //select字段-联动
    DataInputByBrowser(uservalue);
    <%
    for(int i=0;i<selfieldsadd.size();i++){
    %>
    if("<%=selfieldsadd.get(i)%>"==fieldid){
        changeshowattrBymode('<%=selfieldsadd.get(i)%>_0',selvalue,-1,<%=workflowid%>,<%=nodeid%>);
    }
    <%
    }
    for(int i=0;i<seldefieldsadd.size();i++){
    %>
    if("<%=seldefieldsadd.get(i)%>"==fieldid){
        changeshowattrBymode('<%=seldefieldsadd.get(i)%>_1',selvalue,rownum,<%=workflowid%>,<%=nodeid%>);
    }
    <%
    }
    %>
    var childfieldObj = $G("childFieldfield"+fieldid);
    if(childfieldObj!=null){
		var childfieldid = childfieldObj.value;
		if(childfieldid!=null && childfieldid!="" && childfieldid!="0" && (childfieldid.indexOf("0_")==-1 || childfieldid.indexOf("0_")>0)){
			var paraStr = "fieldid="+fieldid+"&childfield="+childfieldid+"&isbill=<%=isbill%>&selectvalue="+selvalue+"&rownum="+rownum;
			//alert(paraStr);
		    $G("modeComboChange").src = "ComboChange.jsp?"+paraStr;
		}
    }
    return false;
</script>
<SCRIPT FOR="ChinaExcel" EVENT="CalculateEnd()"	LANGUAGE="JavaScript" >
    MainCalculate();
    DetailCalculate();
	return false;
</script>
<div id="exceldiv" name="exceldiv" style="display:none">
<%if(acceptlanguage.indexOf("zh-tw")>-1||acceptlanguage.indexOf("zh-hk")>-1){%>
<script language=javascript src="/workflow/mode/chinaexcelobj_tw_wev8.js"></script>
<%}else{%>
<script language=javascript src="/workflow/mode/chinaexcelobj_wev8.js"></script>
<%} %>
</div>

<DIV id="ocontext" name="ocontext" style="LEFT: 0px;Top:0px;POSITION:ABSOLUTE ;display:none" >
<table id=otable cellpadding='0' cellspacing='0' width="200" border=1 style="WORD-WRAP:break-word">
</table>
</DIV>
<input type=hidden name="indexrow" id="indexrow" value=0>
<input type=hidden name="modeid" id="modeid" value="<%=modeid%>">
<input type=hidden name="isform" id="isform" value="<%=isform%>">
<input type=hidden name="modestr" id="modestr" value="">
<script language=javascript>
function readmode(){
    frmmain.ChinaExcel.ReadHttpFile("/workflow/mode/ModeReader.jsp?modeid=<%=modeid%>&nodeid=<%=nodeid%>&isform=<%=isform%>");
    try{
	    var maxrow=frmmain.ChinaExcel.GetMaxRow();
	    var maxcol=frmmain.ChinaExcel.GetMaxCol();
	    var userstr="";
	    for(var i=1;i<=maxrow;i++){
	        for(var j=1;j<=maxcol;j++){
	            userstr=frmmain.ChinaExcel.GetCellUserStringValue(i,j);             
	<%if("1".equals(isbill) && formid==156) {%>
	            if(userstr == '<%=organizationid%>_0_1_3') {
	            	userstr = "<%=organizationid%>_0_4_3";
	            	isProtect=frmmain.ChinaExcel.IsCellProtect(i,j);
					if(isProtect){
						frmmain.ChinaExcel.SetCellProtect(i,j,i,j,false);
					}
					frmmain.ChinaExcel.SetCellUserStringValue(i,j,i,j,userstr);
					if(isProtect){
						frmmain.ChinaExcel.SetCellProtect(i,j,i,j,true);
					}
	            }
	<%}%>
			}
		}
	}catch(e){}
    $G("exceldiv").style.display='';
}

function doInitDetailchildSelectAdd(fieldid,selvalue,rownum){
	try{
		var childfieldObj = $G("childFieldfield"+fieldid);
		if(childfieldObj!=null){
			var childfieldid = childfieldObj.value;
			if(childfieldid!=null && childfieldid!="" && childfieldid!="0" && (childfieldid.indexOf("0_")==-1 || childfieldid.indexOf("0_")>0)){
				var paraStr = "fieldid="+fieldid+"&childfield="+childfieldid+"&isbill=<%=isbill%>&selectvalue="+selvalue+"&rownum="+rownum;
				var frm = document.createElement("iframe");
				frm.id = "iframe_"+fieldid+"_"+childfieldid+"_"+rownum;
				frm.style.display = "none";
				frm.src = "ComboChange.jsp?"+paraStr;
				document.body.appendChild(frm);
			}
		}
	}catch(e){}
}

function initRowData()
{
	var changefields="";
<%
	
    for(int j=0;j<changedefieldsmanage.size();j++){
    %>
    changefields+=",<%=changedefieldsmanage.get(j)%>";
    <%
    }
    ArrayList detailtablefieldids=FieldInfo.getDetailTableFieldIds();
    for(int i=0; i<detailtablefieldids.size();i++)
    {
    	RecordSet.executeSql("select defaultrows from workflow_NodeFormGroup where nodeid="+nodeid+" and groupid="+i);
    	RecordSet.next();
    	int defaultrows = Util.getIntValue(RecordSet.getString("defaultrows"),0);
%>
    //确认是否添加控制
	var isneed=frmmain.ChinaExcel.GetCellUserStringValueRow("detail<%=i%>_isneed");
	var isdefault=frmmain.ChinaExcel.GetCellUserStringValueRow("detail<%=i%>_isdefault");
	if(isdefault>0)
    {
    	isCreateDIframe = true;
    	isInit = true;
    	rowIns("<%=i%>",0,1,changefields);
    	isInit = false;
        var defaultrows = "<%=defaultrows%>";
		for(var k=0;k<parseInt(parseInt(defaultrows)-1);k++){
			isInit = true;
			rowIns("<%=i%>",0,1,changefields);
			isInit = false;
		}
		
    }
    isCreateDIframe = false;
<%
    }
%>
}
</script>
<script language=vbs>
sub init()
    frmmain.ChinaExcel.SetOnlyShowTipMessage true
    //hideRightClickMenu()
    chinaexcelregedit()
	readmode()
    frmmain.ChinaExcel.DesignMode = false
    frmmain.ChinaExcel.SetShowPopupMenu false
    frmmain.ChinaExcel.SetCanAutoSizeHideCols false
    frmmain.ChinaExcel.SetProtectFormShowCursor false
    frmmain.ChinaExcel.SetShowScrollBar 1,false        
    frmmain.ChinaExcel.ShowGrid = false
    getRowGroup()
    setmantable()
    setdetailtable()
	initRowData()
    doTriggerInit()
    doLinkAgeInit()
    changeKeyword "requestname",jQuery("#requestname").val(),1
    frmmain.ChinaExcel.ReCalculate()    
    setheight()    
    frmmain.ChinaExcel.SetPasteType 1
    RefreshViewSize()
    frmmain.ChinaExcel.SetOnlyShowTipMessage false
    isInit = false
    setheight()
end sub
</script>
<script language=javascript>
     function setheight(){
        var maxrow=frmmain.ChinaExcel.GetMaxRow();
        var totalheight=35;
        for(var i=1;i<=maxrow;i++){
            totalheight+=frmmain.ChinaExcel.GetRowSize(i,1);
        }
        frmmain.ChinaExcel.height=totalheight;
        frmmain.ChinaExcel.SetShowScrollBar(1,true);
     }

    function setwidth(){

        var totalwidth=0;
        var colnum = frmmain.ChinaExcel.GetMaxCol();		
		for(var i=0;i<colnum;i++){
			totalwidth += frmmain.ChinaExcel.GetColSize(i,1);
		}

        var temptotalwidth=parent.document.body.clientWidth-totalwidth;

        if(temptotalwidth>0&&false){ 
        	totalwidth=totalwidth;
        	frmmain.ChinaExcel.width=totalwidth;
        	frmmain.ChinaExcel.SetShowScrollBar(0,false);
        }else{
        	frmmain.ChinaExcel.width=parent.document.body.clientWidth - 40;
        	frmmain.ChinaExcel.SetShowScrollBar(0,true);
        }
    }

    window.onresize = function (){
    setheight();
	setwidth();
}
function RefreshViewSize(){
	<%if(urm_loadmode==1){%>
    //rightMenu.focus();
	    try {
		    rightMenu.focus();
	    }catch(e) {
	    }
    <%}%>
    for(r=0;r<rowgroup.length;r++){
        rhead=frmmain.ChinaExcel.GetCellUserStringValueRow("detail"+r+"_head");
        frmmain.ChinaExcel.SetRowHide(rhead,rhead+rowgroup[r],true);
    }
    frmmain.ChinaExcel.RefreshViewSize();
}
<%
//String isFormSignature=null;
//RecordSet.executeSql("select isFormSignature from workflow_flownode where workflowId="+workflowid+" and nodeId="+nodeid);
//if(RecordSet.next()){
//	isFormSignature = Util.null2String(RecordSet.getString("isFormSignature"));
//}
%>
function createDoc(fieldbodyid,docVlaue,isedit){
	
	try{
		hidePopup();
	}catch(e){
	}
   /*
   for(i=0;i<=1;i++){
  		parent.$G("oTDtype_"+i).background="/images/tab2_wev8.png";
  		parent.$G("oTDtype_"+i).className="cycleTD";
  	}
  	parent.$G("oTDtype_1").background="/images/tab.active2_wev8.png";
  	parent.$G("oTDtype_1").className="cycleTDCurrent";
  	*/
  	//frmmain.action = "RequestOperation.jsp?docView="+isedit+"&docValue="+docVlaue;
  	frmmain.action = frmmain.action+"?docView="+isedit+"&docValue="+docVlaue+"&isFromEditDocument=true";
    frmmain.method.value = "crenew_"+fieldbodyid ;
	frmmain.target="delzw";
	parent.delsave();
	if(check_form(document.frmmain,'requestname')){
      	if($G("needoutprint")) $G("needoutprint").value = "1";//标识点正文
        document.frmmain.src.value='save';
	                        try{
								jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
							}catch(e){}
                        document.frmmain.submit();

	parent.clicktext();//切换当前tab页到正文页面
	if($G("needoutprint")) $G("needoutprint").value = "";//标识点正文
	if($G("iscreate")) $G("iscreate").value = "0";	
    }

}

function openWindow(urlLink){

  	window.open(urlLink);

}

<%
int titleFieldId=-1;
int keywordFieldId=-1;
RecordSet.execute("select titleFieldId,keywordFieldId from workflow_base where id="+workflowid);
if(RecordSet.next()){
	titleFieldId=RecordSet.getInt("titleFieldId");
	keywordFieldId=RecordSet.getInt("keywordFieldId");
}
%>

function changeKeyword(uservalue,cellvalue,ismand){
	/*
	alert($G("workflowKeywordIframe"))
	if (!!!$G("workflowKeywordIframe")) {
		setTimeout(function () {
			changeKeyword(uservalue,cellvalue,ismand);	
		}, 100);
		return;		
	}
	*/
<%
	if(titleFieldId>0&&keywordFieldId>0){
%>
        fieldName=uservalue.substring(0,uservalue.indexOf("_"));
        if(fieldName=="field<%=titleFieldId%>"){
        	var keywordObj=$G("field<%=keywordFieldId%>");
		    $G("workflowKeywordIframe").src="/docs/sendDoc/WorkflowKeywordIframe.jsp?operation=UpdateKeywordData&docTitle="+cellvalue+"&docKeyword="+keywordObj.value;
	    }
<%
   }else if(titleFieldId==-3&&keywordFieldId>0){
%>
        fieldName=uservalue;
        if(fieldName=="requestname"){
        	var keywordObj=$G("field<%=keywordFieldId%>");
		    $G("workflowKeywordIframe").src="/docs/sendDoc/WorkflowKeywordIframe.jsp?operation=UpdateKeywordData&docTitle="+cellvalue+"&docKeyword="+keywordObj.value;
	    }
<%
   }
%>
}

function updateKeywordData(strWordkey){

	var nrow=frmmain.ChinaExcel.GetCellUserStringValueRow("field<%=keywordFieldId%>_1_1");
	if(nrow>0){
		var ncol=frmmain.ChinaExcel.GetCellUserStringValueCol("field<%=keywordFieldId%>_1_1");
		if(ncol>0){
			document.frmmain.ChinaExcel.SetCellVal(nrow,ncol,strWordkey);
			$G("field<%=keywordFieldId%>").value=strWordkey;
		    imgshoworhide(nrow,ncol);
            document.frmmain.ChinaExcel.RefreshViewSize();
		}
	}
}

function onShowKeyword(){

	var keywordRow=frmmain.ChinaExcel.GetCellUserStringValueRow("field<%=keywordFieldId%>_1_1");
	if(keywordRow>0){
		var keywordCol=frmmain.ChinaExcel.GetCellUserStringValueCol("field<%=keywordFieldId%>_1_1");
		if(keywordCol>0){

            strKeyword=$G("field<%=keywordFieldId%>").value;
            tempUrl=escape("/docs/sendDoc/WorkflowKeywordBrowserMulti.jsp?strKeyword="+strKeyword);
            id1=window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+tempUrl);
        
		    if(typeof(id1)!="undefined"){
			    document.frmmain.ChinaExcel.SetCellVal(keywordRow,keywordCol,id1);
			    $G("field<%=keywordFieldId%>").value=id1;
		        imgshoworhide(keywordRow,keywordCol);
                frmmain.ChinaExcel.RefreshViewSize();
			}

			frmmain.ChinaExcel.GoToCell(1,1);
		}
	}

}
function onShowFnaInfo(fieldid,nowrow){
<%if(isFnabill){%>
    var tindx = fieldid.indexOf("_");
    if (tindx > 0) {
        var tfieldname = fieldid.substring(0, tindx);
        var tlastfield = fieldid.substring(tindx + 1);
        if (tfieldname == "<%=organizationid%>" || tfieldname == "<%=subject%>" || tfieldname == "<%=budgetperiod%>") {
            tindx = tlastfield.indexOf("_");
            var trow=0;
            if(tindx>0){
                trow = tlastfield.substring(0, tindx);
            }else{
                trow = tlastfield;
            }
            if ($G("<%=organizationid%>_" + trow) && $G("<%=subject%>_" + trow) && $G("<%=budgetperiod%>_" + trow)) {
                if ($G("<%=organizationid%>_" + trow).value != "" && $G("<%=subject%>_" + trow).value != "" && $G("<%=budgetperiod%>_" + trow).value != "") {
                    getBudgetKpi(trow, $G("<%=organizationtype%>_" + trow).value, $G("<%=organizationid%>_" + trow).value, $G("<%=subject%>_" + trow).value,nowrow);
                    getLoan(trow, $G("<%=organizationtype%>_" + trow).value, $G("<%=organizationid%>_" + trow).value,nowrow);
                    getBudget(trow, $G("<%=organizationtype%>_" + trow).value, $G("<%=organizationid%>_" + trow).value, $G("<%=subject%>_" + trow).value,nowrow);
                    return;
                }
            }
            if ($G("<%=hrmremain%>_" + trow)) {
                $G("<%=hrmremain%>_" + trow).value = "";
            }
            if ($G("<%=deptremain%>_" + trow)) {
                $G("<%=deptremain%>_" + trow).value = "";
            }
            if ($G("<%=subcomremain%>_" + trow)) {
                $G("<%=subcomremain%>_" + trow).value = "";
            }
            if ($G("<%=fccremain%>_" + trow)) {
                $G("<%=fccremain%>_" + trow).value = "";
            }
            if($G("<%=loanbalance%>_" + trow)!=null){
                $G("<%=loanbalance%>_" + trow).value = "";
            }
            if($G("<%=oldamount%>_" + trow)!=null){
                $G("<%=oldamount%>_" + trow).value = "";
            }
            var hrmremaincol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=hrmremain%>_" + trow + "_<%=hrmremaintype%>");
            if (hrmremaincol > 0) {
                frmmain.ChinaExcel.SetCellProtect(nowrow, hrmremaincol, nowrow, hrmremaincol, false);
                frmmain.ChinaExcel.SetCellVal(nowrow, hrmremaincol, "");
                frmmain.ChinaExcel.SetCellProtect(nowrow, hrmremaincol, nowrow, hrmremaincol, true);
            }
            var deptremaincol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=deptremain%>_" + trow + "_<%=deptremaintype%>");
            if (deptremaincol > 0) {
                frmmain.ChinaExcel.SetCellProtect(nowrow, deptremaincol, nowrow, deptremaincol, false);
                frmmain.ChinaExcel.SetCellVal(nowrow, deptremaincol, "");
                frmmain.ChinaExcel.SetCellProtect(nowrow, deptremaincol, nowrow, deptremaincol, true);
            }
            var subcomremaincol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=subcomremain%>_" + trow + "_<%=subcomremaintype%>");
            if (subcomremaincol > 0) {
                frmmain.ChinaExcel.SetCellProtect(nowrow, subcomremaincol, nowrow, subcomremaincol, false);
                frmmain.ChinaExcel.SetCellVal(nowrow, subcomremaincol, "");
                frmmain.ChinaExcel.SetCellProtect(nowrow, subcomremaincol, nowrow, subcomremaincol, true);
            }
            var fccremaincol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=fccremain%>_" + trow + "_<%=fccremaintype%>");
            if (fccremaincol > 0) {
                frmmain.ChinaExcel.SetCellProtect(nowrow, fccremaincol, nowrow, fccremaincol, false);
                frmmain.ChinaExcel.SetCellVal(nowrow, fccremaincol, "");
                frmmain.ChinaExcel.SetCellProtect(nowrow, fccremaincol, nowrow, fccremaincol, true);
            }
            var loanbalancecol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=loanbalance%>_" + trow + "_<%=loanbalancetype%>");
            if (loanbalancecol > 0) {
                frmmain.ChinaExcel.SetCellProtect(nowrow, loanbalancecol, nowrow, loanbalancecol, false);
                frmmain.ChinaExcel.SetCellVal(nowrow, loanbalancecol, "");
                frmmain.ChinaExcel.SetCellProtect(nowrow, loanbalancecol, nowrow, loanbalancecol, true);
            }
            var oldamountcol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=oldamount%>_" + trow + "_<%=oldamounttype%>");
            if (oldamountcol > 0) {
                frmmain.ChinaExcel.SetCellProtect(nowrow, oldamountcol, nowrow, oldamountcol, false);
                frmmain.ChinaExcel.SetCellVal(nowrow, oldamountcol, "");
                frmmain.ChinaExcel.SetCellProtect(nowrow, oldamountcol, nowrow, oldamountcol, true);
                frmmain.ChinaExcel.ReCalculate();
            }
        }
    }
<%}%>
}
function callback(o, index,nowrow) {
    val = o.split("|");
    if (val[0] != "") {
        v = val[0].split(",");
        hrmremainstr = "<%=SystemEnv.getHtmlLabelName(18768,user.getLanguage())%>:" + v[0] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18503,user.getLanguage())%>:" + v[1] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18769,user.getLanguage())%>:" + v[2];
        var hrmremaincol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=hrmremain%>_" + index + "_<%=hrmremaintype%>");
        if (hrmremaincol > 0) {
            frmmain.ChinaExcel.SetCellProtect(nowrow, hrmremaincol, nowrow, hrmremaincol, false);
            frmmain.ChinaExcel.SetCellVal(nowrow, hrmremaincol, hrmremainstr);
            frmmain.ChinaExcel.SetCellProtect(nowrow, hrmremaincol, nowrow, hrmremaincol, true);
        }
    }
    if (val[1] != "") {
        v = val[1].split(",");
        deptremainstr = "<%=SystemEnv.getHtmlLabelName(18768,user.getLanguage())%>:" + v[0] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18503,user.getLanguage())%>:" + v[1] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18769,user.getLanguage())%>:" + v[2];
        var deptremaincol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=deptremain%>_" + index + "_<%=deptremaintype%>");
        if (deptremaincol > 0) {
            frmmain.ChinaExcel.SetCellProtect(nowrow, deptremaincol, nowrow, deptremaincol, false);
            frmmain.ChinaExcel.SetCellVal(nowrow, deptremaincol, deptremainstr);
            frmmain.ChinaExcel.SetCellProtect(nowrow, deptremaincol, nowrow, deptremaincol, true);
        }
    }
    if (val[2] != "") {
        v = val[2].split(",");
        subcomremainstr = "<%=SystemEnv.getHtmlLabelName(18768,user.getLanguage())%>:" + v[0] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18503,user.getLanguage())%>:" + v[1] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18769,user.getLanguage())%>:" + v[2];
        var subcomremaincol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=subcomremain%>_" + index + "_<%=subcomremaintype%>");
        if (subcomremaincol > 0) {
            frmmain.ChinaExcel.SetCellProtect(nowrow, subcomremaincol, nowrow, subcomremaincol, false);
            frmmain.ChinaExcel.SetCellVal(nowrow, subcomremaincol, subcomremainstr);
            frmmain.ChinaExcel.SetCellProtect(nowrow, subcomremaincol, nowrow, subcomremaincol, true);
        }
    }
    if (val[3] != "") {
        v = val[3].split(",");
        fccremainstr = "<%=SystemEnv.getHtmlLabelName(18768,user.getLanguage())%>:" + v[0] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18503,user.getLanguage())%>:" + v[1] + "&dt;&at;<%=SystemEnv.getHtmlLabelName(18769,user.getLanguage())%>:" + v[2];
        var fccremaincol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=fccremain%>_" + index + "_<%=fccremaintype%>");
        if (fccremaincol > 0) {
            frmmain.ChinaExcel.SetCellProtect(nowrow, fccremaincol, nowrow, fccremaincol, false);
            frmmain.ChinaExcel.SetCellVal(nowrow, fccremaincol, fccremainstr);
            frmmain.ChinaExcel.SetCellProtect(nowrow, fccremaincol, nowrow, fccremaincol, true);
        }
    }
    frmmain.ChinaExcel.RefreshViewSize();
}


function getBudgetKpi(index, organizationtype, organizationid, subjid,nowrow) {
	var budgetperiod = jQuery("#<%=budgetperiod%>_"+index).val();
	if(subjid!=""&&organizationtype!=""&&organizationid!=""&&budgetperiod!=""){
		var _data = "budgetfeetype="+subjid+"&orgtype="+organizationtype+"&orgid="+organizationid+"&applydate="+budgetperiod;
		jQuery.ajax({
			url : "/workflow/request/BudgetHandlerGetBudgetKPI.jsp",
			type : "post",
			processData : false,
			data : _data,
			dataType : "html",
			success: function do4Success(msg){
				callback(jQuery.trim(msg), index, nowrow);
			}
		});	
	}else{
		callback("", index, nowrow);
	}
}
function callback1(o, index,nowrow) {
    if($G("<%=loanbalance%>_" + index)!=null){
        $G("<%=loanbalance%>_" + index).value = o;
    }
    var loanbalancecol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=loanbalance%>_" + index + "_<%=loanbalancetype%>");
    if (loanbalancecol > 0) {
        frmmain.ChinaExcel.SetCellProtect(nowrow, loanbalancecol, nowrow, loanbalancecol, false);
        frmmain.ChinaExcel.SetCellVal(nowrow, loanbalancecol, o);
        frmmain.ChinaExcel.SetCellProtect(nowrow, loanbalancecol, nowrow, loanbalancecol, true);
    }
    frmmain.ChinaExcel.RefreshViewSize();
}
function callback2(o, index,nowrow) {
     if($G("<%=oldamount%>_" + index)!=null){
        $G("<%=oldamount%>_" + index).value = o;
    }
    var oldamountcol = frmmain.ChinaExcel.GetCellUserStringValueCol("<%=oldamount%>_" + index + "_<%=oldamounttype%>");
    if (oldamountcol > 0) {
        frmmain.ChinaExcel.SetCellProtect(nowrow, oldamountcol, nowrow, oldamountcol, false);
        frmmain.ChinaExcel.SetCellVal(nowrow, oldamountcol, o);
        frmmain.ChinaExcel.SetCellProtect(nowrow, oldamountcol, nowrow, oldamountcol, true);
    }
    frmmain.ChinaExcel.ReCalculate();
    frmmain.ChinaExcel.RefreshViewSize();
 }
function getLoan(index, organizationtype, organizationid,nowrow) {
    var callbackProxy = function(o) {
        callback1(o, index,nowrow);
    };
    var callMetaData = { callback:callbackProxy };
    BudgetHandler.getLoanAmount(organizationtype, organizationid,callMetaData);
}
function getBudget(index, organizationtype, organizationid, subjid,nowrow) {
     var callbackProxy = function(o) {
         callback2(o, index,nowrow);
     };
     var callMetaData = { callback:callbackProxy };

     BudgetHandler.getBudgetByDate($G("<%=budgetperiod%>_"+index).value, organizationtype, organizationid, subjid, callMetaData);
 }
 function doTriggerInit(){
    window.setTimeout("doDataInput()",200);
}

 function doDataInput(){
	    var tempS = "<%=trrigerfield%>";
	    datainput(tempS);
	}
function doLinkAgeInit(){
    window.setTimeout("RealdoLinkAgeInit()",500);
}
function RealdoLinkAgeInit(){
    var tempS = "<%=selfieldsaddString%>";
    var tempA = "";
    var fields = "";
    var fieldvalues = "";
    if(tempS.length>0){
        tempA = tempS.split(",");
        for(var i=0;i<tempA.length;i++){
            if($G("field"+tempA[i])){
                var tempselvalue = $G("field"+tempA[i]).value;
                fields += ","+tempA[i]+"_0";
                fieldvalues += ","+tempselvalue;
            }
        }
    }
    changeshowattrBymode(fields,fieldvalues,-1,<%=workflowid%>,<%=nodeid%>);
}

function datainput(parfield){                <!--数据导入-->
	try{
		if(event.propertyName && event.propertyName.toLowerCase() != "value"){
			return;
		}
	}catch(e){}
	  var tempdata = "";
      var temprand = $G("rand").value ;
      var tempParfieldArr = parfield.split(",");
      var StrData="id=<%=workflowid%>&formid=<%=formid%>&bill=<%=isbill%>&node=<%=nodeid%>&detailsum=0&trg="+parfield;
      for(var i=0;i<tempParfieldArr.length;i++){
      	var tempParfield = tempParfieldArr[i];
        try{
      	tempdata += $G(tempParfield).value+"," ;
        }catch(e){}
      <%
      if(!trrigerfield.trim().equals("")){
          for(int i=0;i<Linfieldname.size();i++){
              String temp=(String)Linfieldname.get(i);
      %>
          if($G("<%=temp.substring(temp.indexOf("|")+1)%>")!=null) StrData+="&<%=temp%>="+escape($G("<%=temp.substring(temp.indexOf("|")+1)%>").value);
      <%
          }
          for(int i=0;i<Lcondetionfieldname.size();i++){
              String temp=(String)Lcondetionfieldname.get(i);
      %>
         if($G("<%=temp.substring(temp.indexOf("|")+1)%>")) StrData+="&<%=temp%>="+escape($G("<%=temp.substring(temp.indexOf("|")+1)%>").value);
      <%
          }
          }
      %>
      }

      StrData += "&trgv="+tempdata+"&rand="+temprand+"&tempflag="+Math.random();
      StrData = StrData.replace(/\+/g,"%2B");
      //$G("datainputform").src="DataInputMode.jsp?"+StrData;
      if($G("datainput_"+parfield)){
		  	$G("datainput_"+parfield).src = "DataInputMode.jsp?"+StrData;
	  }else{
	  		createIframe("datainput_"+parfield);
	  		$G("datainput_"+parfield).src = "DataInputMode.jsp?"+StrData;
	  }
  }

var isCreateDIframe = false;

function datainputd(parfield){                <!--数据导入-->
	try{
		if(event.propertyName && event.propertyName.toLowerCase() != "value"){
			return;
		}
	}catch(e){}

      var tempParfieldArr = parfield.split(",");
      var StrData="id=<%=workflowid%>&formid=<%=formid%>&bill=<%=isbill%>&node=<%=nodeid%>&detailsum=1&trg="+parfield;

      for(var i=0;i<tempParfieldArr.length;i++){
      	var tempParfield = tempParfieldArr[i];
      	var indexid=tempParfield.substr(tempParfield.indexOf("_")+1);

      <%
      if(!trrigerdetailfield.trim().equals("")){
          for(int i=0;i<Linfieldname.size();i++){
              String temp=(String)Linfieldname.get(i);
      %>
          if($G("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid)!=null) StrData+="&<%=temp%>="+escape($G("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid).value);

      <%
          }
          for(int i=0;i<Lcondetionfieldname.size();i++){
              String temp=(String)Lcondetionfieldname.get(i);
      %>
          if($G("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid)) StrData+="&<%=temp%>="+escape($G("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid).value);
      <%
          }
          }
      %>
      }
      StrData = StrData.replace(/\+/g,"%2B");
      if(isCreateDIframe){
      	  var iframe_datainputd = document.createElement("iframe");
		  iframe_datainputd.src = "DataInputModeDetail.jsp?"+StrData;
		  iframe_datainputd.frameborder = "0";
		  iframe_datainputd.height = "0";
		  iframe_datainputd.scrolling = "no";
		  iframe_datainputd.style.display = "none";
		  document.body.appendChild(iframe_datainputd);
      }else{
    	  $G("datainputformdetail").src="DataInputModeDetail.jsp?"+StrData;
      }
  }
</script>