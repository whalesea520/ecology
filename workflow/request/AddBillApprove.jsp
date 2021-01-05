<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="weaver.workflow.request.RequestConstants" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet_nf1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page"/>
<%@ page import="weaver.workflow.request.RevisionConstants" %>

<!--  
<script type="text/javascript" language="javascript" src="/FCKEditor/fckeditor_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt_wev8.js"></script>
-->
<script type="text/javascript" language="javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/css/ecology8/workflowsign_wev8.css" />

<!--yl qc:67452 start-->
<iframe id="selectChange" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<%
String selectInitJsStr = "";
String initIframeStr = "";
//yl qc:67452 end
String newfromdate="a";
String newenddate="b";
String workflowid=Util.null2String(request.getParameter("workflowid"));
String nodeid=Util.null2String(request.getParameter("nodeid"));
String formid=Util.null2String(request.getParameter("formid"));
//对不同的模块来说,可以定义自己相关的工作流
String prjid = Util.null2String(request.getParameter("prjid"));
String docid = Util.null2String(request.getParameter("docid"));
String crmid = Util.null2String(request.getParameter("crmid"));
String hrmid = Util.null2String(request.getParameter("hrmid"));
//......
String topage = Util.null2String(request.getParameter("topage"));
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");

int userid=user.getUID();
String logintype = user.getLogintype();
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String currentdate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String currenttime = (timestamp.toString()).substring(11,13) +":" +(timestamp.toString()).substring(14,16)+":"+(timestamp.toString()).substring(17,19);
String username = "";
if(logintype.equals("1"))
	username = Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage()) ;
if(logintype.equals("2"))
	username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+userid),user.getLanguage());

String workflowname=WorkflowComInfo.getWorkflowname(workflowid);
String needcheck="requestname";
String isSignDoc_add="";
String isSignWorkflow_add="";
RecordSet.execute("select titleFieldId,keywordFieldId,isSignDoc,isSignWorkflow from workflow_base where id="+workflowid);
if(RecordSet.next()){
    isSignDoc_add=Util.null2String(RecordSet.getString("isSignDoc"));
    isSignWorkflow_add=Util.null2String(RecordSet.getString("isSignWorkflow"));
}

 
	
  weaver.general.DateUtil   DateUtil=new weaver.general.DateUtil();
  String 	txtuseruse=DateUtil.getWFTitleNew(""+workflowid,""+user.getUID(),""+username,logintype);

%>
<form name="frmmain" method="post" action="BillApproveOperation.jsp">
<input type="hidden" name="needwfback" id="needwfback" value="1" />
<input type=hidden name="workflowid" value=<%=workflowid%>>
<input type=hidden name="nodeid" value=<%=nodeid%>>
<input type=hidden name="nodetype" value="0">
<input type=hidden name="src">
<input type=hidden name="iscreate" value="1">
<input type=hidden name="formid" value=<%=formid%>>
<input type=hidden name ="topage" value="<%=topage%>">
<input type="hidden" name="f_weaver_belongto_userid" value="<%=request.getParameter("f_weaver_belongto_userid") %>">
<input type="hidden" name="f_weaver_belongto_usertype" value="<%=request.getParameter("f_weaver_belongto_usertype") %>">
  <div align="center"><br>
    <font style="font-size:14pt;FONT-WEIGHT: bold"><%=Util.toScreen(workflowname,user.getLanguage())%></font> <br>
    <br>
  </div>
  <table class="viewform">
    <colgroup> <col width="20%"> <col width="80%"> 
    <tr class="Spacing" style="height:1px;"> 
      <td class="Line1" colspan=2></td>
    </tr>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
      <td class=field> 
        <input type=text class=Inputstyle name=requestname onChange="checkinput('requestname','requestnamespan')" size=<%=RequestConstants.RequestName_Size%> maxlength=<%=RequestConstants.RequestName_MaxLength%>
        value="<%=Util.toScreenToEdit(txtuseruse,user.getLanguage())%>">
        <span id=requestnamespan>
		
 	<%
		 if(txtuseruse.equals("")){
		%>	
		<img src="/images/BacoError_wev8.gif" align=absmiddle>
		 <%}
		%>
		</span> 
        <input type=radio value="0" name="requestlevel" checked><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
        <input type=radio value="1" name="requestlevel"><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
        <input type=radio value="2" name="requestlevel"><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>
      </td>
    </tr>
    <tr class="Spacing" style="height:1px;"> 
      <td class="Line2" colspan=2></td>
    </tr>
    <%
ArrayList fieldids=new ArrayList();
ArrayList fieldlabels=new ArrayList();
ArrayList fieldhtmltypes=new ArrayList();
ArrayList fieldtypes=new ArrayList();
ArrayList fieldnames=new ArrayList();
RecordSet.executeProc("workflow_billfield_Select",formid+"");
while(RecordSet.next()){
	fieldids.add(RecordSet.getString("id"));
	fieldlabels.add(RecordSet.getString("fieldlabel"));
	fieldhtmltypes.add(RecordSet.getString("fieldhtmltype"));
	fieldtypes.add(RecordSet.getString("type"));
	fieldnames.add(RecordSet.getString("fieldname"));
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
 int fieldop1id=0;
String strFieldId=null;
String strCustomerValue=null;
String strManagerId=null;
String strUnderlings=null;
ArrayList inoperatefields=new ArrayList();
ArrayList inoperatevalues=new ArrayList();
//rsaddop.executeSql("select fieldid,customervalue from workflow_addinoperate where workflowid=" + workflowid + " and ispreadd='1' and isnode = 1 and objid = "+nodeid);
    RecordSet.executeSql("select fieldid,customervalue,fieldop1id from workflow_addinoperate where workflowid=" + workflowid + " and ispreadd='1' and isnode = 1 and objid = "+nodeid);
    while(RecordSet.next()){
        //inoperatefields.add(rsaddop.getString("fieldid"));
        //inoperatevalues.add(rsaddop.getString("customervalue"));
        strFieldId=Util.null2String(RecordSet.getString("fieldid"));
        strCustomerValue=Util.null2String(RecordSet.getString("customervalue"));
        fieldop1id=Util.getIntValue(RecordSet.getString("fieldop1id"),0);
        if(fieldop1id==-3){
            strManagerId="";
            rs.executeSql("select managerId from HrmResource where id="+userid);
            if(rs.next()){
                strManagerId=Util.null2String(rs.getString("managerId"));
            }
            inoperatefields.add(strFieldId);
            inoperatevalues.add(strManagerId);
        }else if(fieldop1id==-4){
            strUnderlings="";
            rs.executeSql("select id from HrmResource where managerId="+userid+" and status in(0,1,2,3)");
            while(rs.next()){
                strUnderlings+=","+Util.null2String(rs.getString("id"));
            }
            if(!strUnderlings.equals("")){
                strUnderlings=strUnderlings.substring(1);
            }
            inoperatefields.add(strFieldId);
            inoperatevalues.add(strUnderlings);
        }else{
            inoperatefields.add(strFieldId);
            inoperatevalues.add(strCustomerValue);
        }
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
	if(fieldname.equals("begindate")) newfromdate="field"+fieldid;
	if(fieldname.equals("enddate")) newenddate="field"+fieldid;

	String  preAdditionalValue = "";
    boolean isSetFlag = false;
    //将节点前附加操作移出循环外操作减少数据库访问量
  //rsaddop.executeSql("select customervalue from workflow_addinoperate where workflowid=" + workflowid + " and ispreadd='1' and isnode = 1 and objid = "+nodeid+" and fieldid = " + fieldbodyid);
    int inoperateindex=inoperatefields.indexOf(fieldid);
        if(inoperateindex>-1){
        isSetFlag = true;
         preAdditionalValue = (String)inoperatevalues.get(inoperateindex);
        }


   if(isview.equals("1")){
%>
    <tr> 
      <%if(fieldhtmltype.equals("2")){%>
      <td valign=top><%=Util.toScreen(fieldlable,user.getLanguage())%></td>
      <%}else{%>
      <td><%=Util.toScreen(fieldlable,user.getLanguage())%></td>
      <%}%>
      <td class=field> 
        <%
	if(fieldhtmltype.equals("1")){
		if(fieldtype.equals("1")){
			if(isedit.equals("1")){
				if(ismand.equals("1")) {%>
        <input type=text class=Inputstyle name="field<%=fieldid%>" onChange="checkinput('field<%=fieldid%>','field<%=fieldid%>span')" style="width:50%">
        <span id="field<%=fieldid%>span"><img src="/images/BacoError_wev8.gif" align=absmiddle></span> 
        <%
					needcheck+=",field"+fieldid;
				}else{%>
        <input type=text class=Inputstyle name="field<%=fieldid%>" style="width:50%">
        <%}
			}
		}
		else if(fieldtype.equals("2")){
			if(isedit.equals("1")){
				if(ismand.equals("1")) {%>
        <input type=text class=Inputstyle name="field<%=fieldid%>" style="width:50%"
		onKeyPress="ItemCount_KeyPress()" onBlur="checkcount1(this);checkinput('field<%=fieldid%>','field<%=fieldid%>span')">
        <span id="field<%=fieldid%>span"><img src="/images/BacoError_wev8.gif" align=absmiddle></span> 
        <%
					needcheck+=",field"+fieldid;
				}else{%>
        <input type=text class=Inputstyle name="field<%=fieldid%>" onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)' style="width:50%">
        <%}
			}
		}
		else if(fieldtype.equals("3")){
			if(isedit.equals("1")){
				if(ismand.equals("1")) {%>
        <input type=text class=Inputstyle name="field<%=fieldid%>" style="width:50%"
		onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);checkinput('field<%=fieldid%>','field<%=fieldid%>span')">
        <span id="field<%=fieldid%>span"><img src="/images/BacoError_wev8.gif" align=absmiddle></span> 
        <%
					needcheck+=",field"+fieldid;
				}else{%>
        <input type=text class=Inputstyle name="field<%=fieldid%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)' style="width:50%">
        <%}
			}
		}
	}
	else if(fieldhtmltype.equals("2")){
		if(isedit.equals("1")){
			if(ismand.equals("1")) {%>
        <textarea class=Inputstyle name="field<%=fieldid%>" onChange="checkinput('field<%=fieldid%>','field<%=fieldid%>span')"
		rows="4" cols="40" style="width:80%"></textarea>
        <span id="field<%=fieldid%>span"><img src="/images/BacoError_wev8.gif" align=absmiddle></span> 
        <%
				needcheck+=",field"+fieldid;
			}else{%>
        <textarea class=Inputstyle name="field<%=fieldid%>" rows=4 cols=40 style="width:80%"></textarea>
        <%}
		}
	}
	else if(fieldhtmltype.equals("3")){
		String url=BrowserComInfo.getBrowserurl(fieldtype);
		String linkurl=BrowserComInfo.getLinkurl(fieldtype);
		String showname = "";
		int tmpid = 0;
		if(fieldtype.equals("8") && !prjid.equals("")){
			tmpid = Util.getIntValue(prjid,0);
		}else if(fieldtype.equals("9") && !docid.equals("")){
			tmpid = Util.getIntValue(docid,0);
		}else if(fieldtype.equals("1") && !hrmid.equals("")){
			tmpid = Util.getIntValue(hrmid,0);
		}else if(fieldtype.equals("7") && !crmid.equals("")){
			tmpid = Util.getIntValue(crmid,0);
		}else if(fieldtype.equals("4") && !hrmid.equals("")){
			tmpid = Util.getIntValue(ResourceComInfo.getDepartmentID(hrmid),0);
		}

		String showid = "";
		if(tmpid!=0)
			showid = ""+tmpid;
		if(tmpid !=0){
			String tablename=BrowserComInfo.getBrowsertablename(fieldtype);
			String columname=BrowserComInfo.getBrowsercolumname(fieldtype);
			String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);
			String sql="select "+columname+" from "+tablename+" where "+keycolumname+"="+tmpid;
			RecordSet.executeSql(sql);
			if(RecordSet.next())
			{
				if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
            	{
            		showname = "<a href='javaScript:openhrm(" + tmpid + ");' onclick='pointerXY(event);'>" + RecordSet.getString(1) + "</a>&nbsp";
            	}
				else
					showname = "<a href='"+linkurl+tmpid+"'>"+RecordSet.getString(1)+"</a>&nbsp";
			}
		}
		if(isedit.equals("1")){
			String bclick="onShowBrowser('"+fieldid+"','"+url+"','"+linkurl+"','"+fieldtype+"','"+ismand+"')";
		%>
		<brow:browser viewType="0" name='<%="field"+fieldid%>' browserValue='<%=showid%>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=WFLinkInfo.browIsSingle(fieldtype)%>' hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="130px" needHidden="false" browserSpanValue='<%=showname%>'> </brow:browser>
		<!--
        <button type=button  class=Browser onClick="onShowBrowser('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>')"></button> -->
        <%}%>
        <input type=hidden name="field<%=fieldid%>" value="<%=showid%>"/>
      <!--  <span id="field<%=fieldid%>span"> 
        <%=Util.toScreen(showname,user.getLanguage())%>
        <%if(ismand.equals("1") && showname.equals("")){%>
        <img src="/images/BacoError_wev8.gif" align=absmiddle> 
        <%	needcheck+=",field"+fieldid;	
			}%>
        </span> --> 
        <%
	}
	else if(fieldhtmltype.equals("4")){
	%>
        <input type=checkbox value=1 name="field<%=fieldid%>" <%if(isedit.equals("0")){%> DISABLED <%}%> >
        <%}
    else if(fieldhtmltype.equals("5")){
            //yl 67452   start
            //处理select字段联动
            String onchangeAddStr = "";
            int childfieldid_tmp = 0;
            rs.execute("select childfieldid from workflow_billfield where id="+fieldid);
            if(rs.next()){
                childfieldid_tmp = Util.getIntValue(rs.getString("childfieldid"), 0);
            }
            int firstPfieldid_tmp = 0;
            boolean hasPfield = false;
            rs.execute("select id from workflow_billfield where childfieldid="+fieldid);
            while(rs.next()){
                firstPfieldid_tmp = Util.getIntValue(rs.getString("id"), 0);
                if(fieldids.contains(""+firstPfieldid_tmp)){
                    hasPfield = true;
                    break;
                }
            }
            if(childfieldid_tmp != 0){//如果先出现子字段，则要把子字段下拉选项清空
                onchangeAddStr = " onchange = '" +  "$changeOption(this, "+fieldid+", "+childfieldid_tmp+");'";
            }

            //yl 67452   end

        %>
          <script>
              function funcField<%=fieldid%>(){
                  changeshowattr('<%=fieldid%>_0',document.getElementById('field<%=fieldid%>').value,-1,'<%=workflowid%>','<%=nodeid%>');
              }
              window.attachEvent("onload", funcField<%=fieldid%>);
          </script>

	<select class="inputstyle"   <%=onchangeAddStr%>     name="field<%=fieldid%>" <%if(isedit.equals("0")){%> DISABLED <%}%> >
        <option value=""></option>
	<%
	char flag=2;
	rs.executeProc("workflow_selectitembyid_new",""+fieldid+flag+"1");

        //yl 67452   start
    boolean checkempty = true;
    String finalvalue = "";
        if(hasPfield == false){
            while(rs.next()) {
                String tmpselectvalue = Util.null2String(rs.getString("selectvalue"));
                String tmpselectname = Util.toScreen(rs.getString("selectname"),user.getLanguage());
                String isdefault = Util.toScreen(rs.getString("isdefault"),user.getLanguage());//xwj for td2977 20051107
				         /* -------- xwj for td3313 20051206 begin -*/
                if("".equals(preAdditionalValue)){
                    if("y".equals(isdefault)){
                        checkempty = false;
                        finalvalue = tmpselectvalue;
                    }
                }
                else{
                    if(tmpselectvalue.equals(preAdditionalValue)){
                        checkempty = false;
                        finalvalue = tmpselectvalue;
                    }
                }
    %>
          <option value="<%=tmpselectvalue%>"><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
          <%}
          }else{
              while(rs.next()){
                  String tmpselectvalue = Util.null2String(rs.getString("selectvalue"));
                  String tmpselectname = Util.toScreen(rs.getString("selectname"),user.getLanguage());
                  if(tmpselectvalue.equals(preAdditionalValue)){
                      checkempty = false;
                      finalvalue = tmpselectvalue;
                  }
          %>
          <option value="<%=tmpselectvalue%>" <%if(preAdditionalValue.equals(tmpselectvalue)){%> selected <%}%>><%=tmpselectname%></option>
          <%
                  }
                  selectInitJsStr += "doInitChildSelect("+fieldid+","+firstPfieldid_tmp+",\""+finalvalue+"\");\n";
                  initIframeStr += "<iframe id=\"iframe_"+firstPfieldid_tmp+"_"+fieldid+"_00\" frameborder=0 scrolling=no src=\"\"  style=\"display:none\"></iframe>";

                  //yl 67452   end


              }%>

      </select>
          <span id="field<%=fieldid%>span">
	    <%
            if(ismand.equals("1") && checkempty){
        %>
       <IMG src='/images/BacoError_wev8.gif' align=absMiddle>
      <%
          }
      %>

	     </span>
        <%if(isedit.equals("0")){%>
        <input type=hidden class=Inputstyle name="field<%=fieldid%>" value="<%=finalvalue%>" >
        <%}%>
        <%}

                                                            // 选择框   select结束
%>
      </td>
    </tr>
    <tr class="Spacing" style="height:1px;"> 
      <td class="Line2" colspan=2></td>
    </tr>
    <%
   }
}
%>    	  
  </table>
  <!-- 单独写签字意见Start ecology8.0 -->
    <%
  //String workflowPhrases[] = WorkflowPhrase.getUserWorkflowPhrase(""+userid);
    //add by cyril on 2008-09-30 for td:9014
		boolean isSuccess  = RecordSet_nf1.executeProc("sysPhrase_selectByHrmId",""+userid);
		String workflowPhrases[] = new String[RecordSet_nf1.getCounts()];
		String workflowPhrasesContent[] = new String[RecordSet_nf1.getCounts()];
		int m = 0 ;
		if (isSuccess) {
			while (RecordSet_nf1.next()){
				workflowPhrases[m] = Util.null2String(RecordSet_nf1.getString("phraseShort"));
				workflowPhrasesContent[m] = Util.toHtml(Util.null2String(RecordSet_nf1.getString("phrasedesc")));
				m ++ ;
			}
		}
		//end by cyril on 2008-09-30 for td:9014
		
		String isSignMustInput="0";
		String isHideInput="0";
		String isFormSignature=null;
		int formSignatureWidth=RevisionConstants.Form_Signature_Width_Default;
		int formSignatureHeight=RevisionConstants.Form_Signature_Height_Default;
		RecordSet_nf1.executeSql("select isFormSignature,formSignatureWidth,formSignatureHeight,issignmustinput,ishideinput from workflow_flownode where workflowId="+workflowid+" and nodeId="+nodeid);
		if(RecordSet_nf1.next()){
		isFormSignature = Util.null2String(RecordSet_nf1.getString("isFormSignature"));
		formSignatureWidth= Util.getIntValue(RecordSet_nf1.getString("formSignatureWidth"),RevisionConstants.Form_Signature_Width_Default);
		formSignatureHeight= Util.getIntValue(RecordSet_nf1.getString("formSignatureHeight"),RevisionConstants.Form_Signature_Height_Default);
		isSignMustInput = ""+Util.getIntValue(RecordSet_nf1.getString("issignmustinput"), 0);
		isHideInput = ""+Util.getIntValue(RecordSet_nf1.getString("ishideinput"), 0);
		}
		int isUseWebRevision_t = Util.getIntValue(new weaver.general.BaseBean().getPropValue("weaver_iWebRevision","isUseWebRevision"), 0);
		if(isUseWebRevision_t != 1){
		isFormSignature = "";
		}
	String workflowRequestLogId = "";
	String isSignDoc_edit=isSignDoc_add;
	String signdocids = "";
	String signdocname = "";
	String isSignWorkflow_edit = isSignWorkflow_add; 
	String signworkflowids = "";
	String signworkflowname = "";
	
	String isannexupload_add=(String)session.getAttribute(userid+"_"+workflowid+"isannexupload");
	String isannexupload_edit = isannexupload_add;
	String annexdocids = "";
	String requestid = "-1";
	
	
	String myremark = "";
	int annexmainId=0;
    int annexsubId=0;
    int annexsecId=0;
    int annexmaxUploadImageSize = 0;
	if("1".equals(isannexupload_add)){
        
        String annexdocCategory_add=(String)session.getAttribute(userid+"_"+workflowid+"annexdocCategory");
         if("1".equals(isannexupload_add) && annexdocCategory_add!=null && !annexdocCategory_add.equals("")){
            annexmainId=Util.getIntValue(annexdocCategory_add.substring(0,annexdocCategory_add.indexOf(',')));
            annexsubId=Util.getIntValue(annexdocCategory_add.substring(annexdocCategory_add.indexOf(',')+1,annexdocCategory_add.lastIndexOf(',')));
            annexsecId=Util.getIntValue(annexdocCategory_add.substring(annexdocCategory_add.lastIndexOf(',')+1));
          }
         annexmaxUploadImageSize=Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+annexsecId),5);
         if(annexmaxUploadImageSize<=0){
            annexmaxUploadImageSize = 5;
         }
     }
    %>
	<%@ include file="/workflow/request/WorkflowSignInput.jsp" %>
<!-- 单独写签字意见End ecology8.0 -->
</form>
<script language="JavaScript" src="/js/workflow/wfbrow_wev8.js" ></script>
<!-- yl qc:67452 start-->
<%=initIframeStr%>
<!-- yl qc:67452 end-->



<script language=javascript>

    //yl qc:67452 start
    function $changeOption(obj, fieldid, childfieldid){

        var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=1&isdetail=0&selectvalue="+obj.value;
        $GetEle("selectChange").src = "SelectChange.jsp?"+paraStr;
    }
    function doInitChildSelect(fieldid,pFieldid,finalvalue){
        try{
            var pField = $GetEle("field"+pFieldid);
            if(pField != null){
                var pFieldValue = pField.value;
                if(pFieldValue==null || pFieldValue==""){
                    return;
                }
                if(pFieldValue!=null && pFieldValue!=""){
                    var field = $GetEle("field"+fieldid);
                    var paraStr = "fieldid="+pFieldid+"&childfieldid="+fieldid+"&isbill=1&isdetail=0&selectvalue="+pFieldValue+"&childvalue="+finalvalue;
                    $GetEle("iframe_"+pFieldid+"_"+fieldid+"_00").src = "SelectChange.jsp?"+paraStr;
                }
            }
        }catch(e){}
    }
    <%=selectInitJsStr%>
    //yl qc:67452 end



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
if ("<%=newenddate%>"!="b" && "<%=newfromdate%>"!="a" && $GetEle("<%=newenddate%>").value != ""){
			YearFrom= $GetEle("<%=newfromdate%>").value.substring(0,4);
			MonthFrom= $GetEle("<%=newfromdate%>").value.substring(5,7);
			DayFrom= $GetEle("<%=newfromdate%>").value.substring(8,10);
			YearTo= $GetEle("<%=newenddate%>").value.substring(0,4);
			MonthTo= $GetEle("<%=newenddate%>").value.substring(5,7);
			DayTo= $GetEle("<%=newenddate%>").value.substring(8,10);
			// window.alert(YearFrom+MonthFrom+DayFrom);
                   if (!DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo )){
        window.alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
         return false;
  			 }
  }
     return true; 
}

function doSave(){
	parastr = "<%=needcheck%>" ;
	if(check_form($GetEle("frmmain"),parastr)){
		 $GetEle("src").value='save';
		if(checktimeok()){
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
		}
	}
}
function doSubmit(){
	parastr = "<%=needcheck%>" ;
	if(check_form($GetEle("frmmain"),parastr)){
		 $GetEle("src").value='submit';
		document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
		if(checktimeok()){
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
		}
	}
}   
</script> 

