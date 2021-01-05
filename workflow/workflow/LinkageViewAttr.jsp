<!DOCTYPE html>
<%@page import="weaver.workflow.workflow.WfRightManager"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.workflow.workflow.WfLinkageInfo" %>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<html>
<head>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<script language=javascript src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/js/ecology8/request/e8_tabHoverColor_wev8.js"></script>
<script language=javascript src="/js/weaverTable_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<style typt="text/css">
.noticeinfo{line-height:22px}
.noticediv1{margin-top:4px}
.noticemark{margin-left:14px; margin-right:8px;}
</style>
</head>
<%
	int wfid = Util.getIntValue(request.getParameter("wfid"),0);
	WfRightManager wfrm = new WfRightManager();
	boolean haspermission = wfrm.hasPermission3(wfid, 0, user, WfRightManager.OPERATION_CREATEDIR);
	if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

    String ajax=Util.null2String(request.getParameter("ajax"));
    int formid = Util.getIntValue(request.getParameter("formid"),0);
    int isbill = Util.getIntValue(request.getParameter("isbill"),0);

	ArrayList nodeidlist=new ArrayList();
	ArrayList nodenamelist=new ArrayList();
	String nodeids="";
	String nodenames="";
	String selectfields="";
	String selectfieldnames="";
	String selectfieldvalues="";
	String selectfieldvaluenames="";
	String firstnodeid="0";
	String firstselectfieldid="0";
	String firstselectfieldid_isdetail="0";
	WFNodeMainManager.setWfid(wfid);
	WFNodeMainManager.selectWfNode();
	while(WFNodeMainManager.next()){
	    String tnodeid=""+WFNodeMainManager.getNodeid();
	    String tnodename=WFNodeMainManager.getNodename();
	    String tnodetype=WFNodeMainManager.getNodetype();
	    if(tnodetype.equals("3")) continue;
	    if(nodeids.equals("")){
	        nodeids=tnodeid;
	        nodenames=tnodename;
	        firstnodeid=tnodeid;
	    }else{
	        nodeids+=","+tnodeid;
	        nodenames+=","+tnodename;
	    }
	    nodeidlist.add(tnodeid);
	    nodenamelist.add(tnodename);
	}
	WfLinkageInfo wfli=new WfLinkageInfo();
	wfli.setFormid(formid);
	wfli.setIsbill(isbill);
	wfli.setWorkflowid(wfid);
	wfli.setLangurageid(user.getLanguage());
	ArrayList[] selectfield=wfli.getSelectFieldByEdit(Util.getIntValue(firstnodeid));
	ArrayList selectfieldlist=selectfield[0];
	ArrayList selectfieldnamelist=selectfield[1];
	ArrayList selectfieldisdetaillist=selectfield[2];
	for(int i=0;i<selectfieldlist.size();i++){
	    if(selectfields.equals("")){
	        selectfields=(String)selectfieldlist.get(i)+"_"+selectfieldisdetaillist.get(i);
	        selectfieldnames=(String)selectfieldnamelist.get(i);
	        firstselectfieldid=(String)selectfieldlist.get(i);
	        firstselectfieldid_isdetail = selectfieldisdetaillist.get(i)+"";
	    }else{
	        selectfields+=","+selectfieldlist.get(i)+"_"+selectfieldisdetaillist.get(i);
	        selectfieldnames+=","+selectfieldnamelist.get(i);
	    }
	}
	ArrayList[] selectvalues=wfli.getSelectFieldItem(Util.getIntValue(firstselectfieldid));
	ArrayList selectfieldvaluelist=selectvalues[0];
	ArrayList selectfieldvaluenamelist=selectvalues[1];
	for(int i=0;i<selectfieldvaluelist.size();i++){
	    if(selectfieldvalues.equals("")){
	        selectfieldvalues=(String)selectfieldvaluelist.get(i);
	        selectfieldvaluenames=(String)selectfieldvaluenamelist.get(i);
	    }else{
	        selectfieldvalues+=","+selectfieldvaluelist.get(i);
	        selectfieldvaluenames+=","+selectfieldvaluenamelist.get(i);
	    }
	}
	
	int i=0;
	String checkfield="";
	String titlename = SystemEnv.getHtmlLabelName(21683,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(21684,user.getLanguage());
%>
<%@ include file="/workflow/workflow/addwf_checktetachable.jsp" %>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:linkageviewattrsubmit(this),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name="frmlinkageviewattr" method="post" action="linkageviewattr_operation.jsp" >
    <input type=hidden name="ajax" value="<%=ajax%>">
    <input type=hidden name="wfid" value="<%=wfid%>">
    <input type=hidden name="formid" value="<%=formid%>">
    <input type=hidden name="isbill" value="<%=isbill%>">
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(21694,user.getLanguage())%>'>
		<wea:item type="groupHead">
			<input type="button" class="addbtn" title="<%= SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onclick="group.addRow();"/>
			<input type="button" class="delbtn" title="<%= SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="group.deleteRows();"/>
		</wea:item>
		<wea:item attributes="{'isTableList':'true'}">
			<div class="groupmain" style="width:100%;"></div>
		</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>'>
		<wea:item>
			<p class="noticeinfo noticediv1">1、<%=SystemEnv.getHtmlLabelName(21716,user.getLanguage()) %></p>
			<p class="noticeinfo">2、<%=SystemEnv.getHtmlLabelName(126240,user.getLanguage()) %></p>
			<p class="noticeinfo"><span class="noticemark">●</span><%=SystemEnv.getHtmlLabelName(126238,user.getLanguage()) %>&nbsp;:&nbsp;<%=SystemEnv.getHtmlLabelName(126241,user.getLanguage()) %></p>
			<p class="noticeinfo"><span class="noticemark">●</span><%=SystemEnv.getHtmlLabelName(126239,user.getLanguage()) %>&nbsp;:&nbsp;<%=SystemEnv.getHtmlLabelName(126242,user.getLanguage()) %></p>
			<p class="noticeinfo">3、<%=SystemEnv.getHtmlLabelName(132144,user.getLanguage()) %></p>
		</wea:item>
	</wea:group>
</wea:layout>

<script type="text/javascript">
function addCallBackll(obj,tr,entry){
    var curindex=parseInt(document.getElementById('linkage_rownum').value);
    var rowindex=parseInt(document.getElementById('linkage_indexnum').value);  
    document.getElementById('checkfield').value = document.getElementById('checkfield').value+"nodeid_"+rowindex+",selectfieldid_"+rowindex+",selectfieldvalue_"+rowindex+",changefieldids_"+rowindex+",";
    document.getElementById("linkage_rownum").value = curindex+1 ;
    document.getElementById('linkage_indexnum').value = rowindex+1;
    //新增一行数据，entry为空，也要执行下拉框值校验
    //if(entry){
    	lavachangenode(tr.find("select[name^='nodeid']").get(0),entry);
    //}
    reflash();
}
var nodeids = "<%=nodeids%>";
var nodenames = "<%=nodenames%>";
var selectfieldids = "<%=selectfields%>";
var selectfieldnames = "<%=selectfieldnames%>";
var firstselectfieldid_isdetail = "<%=firstselectfieldid_isdetail %>";
var selectvalues = "<%=selectfieldvalues%>";
var selectvaluenames = "<%=selectfieldvaluenames%>";
var nodeidarray=nodeids.split(",");
var nodenamearray=nodenames.split(",");
var selectfieldidarray=selectfieldids.split(",");
var selectfieldnamearray=selectfieldnames.split(",");
var selectvaluearray=selectvalues.split(",");
var selectvaluenamearray=selectvaluenames.split(",");

var itemhtml1 = "<select width='100px' class=inputstyle name='nodeid' id='nodeid' onchange='lavachangenode(this)'>"
for(i=0;i<nodeidarray.length;i++){
    itemhtml1+="<option value='"+nodeidarray[i]+"'>"+nodenamearray[i]+"</option>";
}
itemhtml1+="<option value='-1'><%=SystemEnv.getHtmlLabelNames("235,15586",user.getLanguage())%></option>";
itemhtml1+="</select>";
//'节点名称'下拉框不显示非空
/*if(nodeids==""){
    itemhtml1+="<span class='mustinput' width='100px'></span>";
}*/

var itemhtml2 = "<select width='100px' class=inputstyle name='selectfieldid' id='selectfieldid' onchange='lavachangefield(null,null,this)'>";
for(i=0;i<selectfieldidarray.length;i++){
    itemhtml2+="<option value='"+selectfieldidarray[i]+"'>"+selectfieldnamearray[i]+"</option>";
}
itemhtml2+="</select>";
//'选择框字段'下拉框默认显示非空
//if(selectfieldids==""){
    itemhtml2+="<span id='selectfieldidspan' class='mustinput' width='100px'></span>";
//}

var itemhtml3 = "<select width='100px' class=inputstyle name='selectfieldvalue' id='selectfieldvalue' onchange='lavachangeViewIsmust(this)' >";
for(i=0;i<selectvaluearray.length;i++){
    itemhtml3+="<option value='"+selectvaluearray[i]+"'>"+selectvaluenamearray[i]+"</option>";
}
itemhtml3+="</select>";
//'选项值'下拉框默认显示非空
//if(selectvalues==""){
    itemhtml3+="<span id='selectvaluespan' class='mustinput' width='100px'></span>";
//}

var itemhtml4 = "<span class='browser' width='250px' name='changefieldids' viewType='0' browserValue='' browserSpanValue='' temptitle='<%=SystemEnv.getHtmlLabelName(33491,user.getLanguage())%>' language='<%=user.getLanguage()%>' isMustInput='2' hasInput=false isSingle=false getBrowserUrlFn='lavaShowMultiFieldUrl' getBrowserUrlFnParams=this></span>";

var itemhtml5 = "<select style='width:75px' name='viewattr'>";
	itemhtml5+="<option value=2><%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%></option> ";
	itemhtml5+="<option value=1><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option>";
	itemhtml5+="<option value=3><%=SystemEnv.getHtmlLabelName(17873,user.getLanguage())%></option>";
//if(firstselectfieldid_isdetail != "1"){
	itemhtml5+="<option value=4><%=SystemEnv.getHtmlLabelName(126238,user.getLanguage())%></option>";
	itemhtml5+="<option value=5><%=SystemEnv.getHtmlLabelName(126239,user.getLanguage())%></option>";
//}
itemhtml5+="</select>";

var items=[
	    {width:"20%",colname:"<%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%>",itemhtml:itemhtml1},
	    {width:"20%",colname:"<%=SystemEnv.getHtmlLabelName(22755,user.getLanguage())%><span class='e8tips' title='<%=SystemEnv.getHtmlLabelName(33492,user.getLanguage()) %>'><img src='/images/tooltip_wev8.png' align='absMiddle'/></span>",itemhtml:itemhtml2},
	    {width:"15%",colname:"<%=SystemEnv.getHtmlLabelName(33490,user.getLanguage())%>",itemhtml:itemhtml3},
	    {width:"30%",colname:"<%=SystemEnv.getHtmlLabelName(33491,user.getLanguage())%><span class='e8tips' title='<%=SystemEnv.getHtmlLabelName(33493,user.getLanguage()) %>'><img src='/images/tooltip_wev8.png' align='absMiddle'/></span>",itemhtml:itemhtml4},
	    {width:"15%",colname:"<%=SystemEnv.getHtmlLabelNames("25484,21689",user.getLanguage())%>",itemhtml:itemhtml5}];
var option= {
		basictitle:"",
		colItems:items,
		optionHeadDisplay:"none",
		useajax:true,
		visibility:"hidden",
		ajaxurl:"/workflow/workflow/LinkageViewAttrAjax.jsp",
		ajaxparams:{
			wfid:<%=wfid%>,
			formid:<%=formid%>,
			isbill:<%=isbill%>
		},
		configCheckBox:true,
		checkBoxItem:{"itemhtml":'<input name="viewid" class="groupselectbox" type="checkbox" >',width:"5%"},
		openindex:true,
        addrowCallBack:function(obj,tr,entry){
        	addCallBackll(obj,tr,entry)
        }
	};
var group=new WeaverEditTable(option);
group.deleteRows=function(){
	        var checkeditems=this.container.find(".groupselectbox").next(".jNiceChecked");
	        if(checkeditems.length===0)
	        {
				try{
					top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
					return;
				}catch(e){
					alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
				}
	        }
	        top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(17048,user.getLanguage())%>",confirmDelete,function(){return false});
 }
 function confirmDelete(o){
			var checkeditems=group.container.find(".groupselectbox").next(".jNiceChecked");
			for(var i=0;i<checkeditems.length;i++)
            {
                var tr=jQuery(checkeditems[i]).parent().parent().parent();
                var trline=tr.next("tr");
                tr.remove();
                trline.remove();
        	}
 }
jQuery(".groupmain").append(group.getContainer());
</script>


<input type='hidden' id="linkage_rownum" name="linkage_rownum" value="<%=i%>">
<input type='hidden' id="linkage_indexnum" name="linkage_indexnum" value="<%=i%>">
<input type='hidden' id="checkfield" name="checkfield" value="<%=checkfield%>">
</form>
<script type="text/javascript">
function linkageviewattrsubmit(obj){
    if (check_form(frmlinkageviewattr,document.all('checkfield').value)) {
        obj.disabled=true;
        frmlinkageviewattr.submit();
   }
}
//'节点名称'下拉框联动
function lavachangenode(obj,entry){
	var nodeid = jQuery(obj).attr("name");
	var rownum =  nodeid.substring(nodeid.lastIndexOf("_")+1); 
    fieldsel=$GetEle("selectfieldid_"+rownum);
    //fieldselspan=$GetEle("selectfieldid_"+rownum+"span");
    //感叹号所在span
    fieldselspan = jQuery(fieldsel).parent().find("#selectfieldidspan");
    changefieldids=$GetEle("changefieldids_"+rownum);
    changefieldidspanimg=$GetEle("changefieldids_"+rownum+"spanimg");
    changefieldidspan=$GetEle("changefieldids_"+rownum+"span");
    jQuery.ajax({
    	url:"WorkflowSelectAjax.jsp",
    	type:"post",
		async:false,
    	dataType:"text",
    	data:{
    		workflowid:<%=wfid%>,
    		formid:<%=formid%>,
    		isbill:<%=isbill%>,
    		language:<%=user.getLanguage()%>,
    		option:"selfield",
    		nodeid:jQuery(obj).val()
    	},
    	beforeSend:function(xhr){
			try{
				e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(129500, user.getLanguage())%>",true);
			}catch(e){}
		},
		complete:function(xhr){
			e8showAjaxTips("",false);
		},
    	success:function(returnvalues){
    		try{
	    		clearOptionsCodeSeqSet(fieldsel);
	            if(returnvalues==""){
	            	try{
	            		if(!entry){
		            		changefieldidspan.innerHTML = "";
		                	changefieldidspanimg.innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		                	//为空情况就显示非空标识
		                	fieldselspan.addClass("mustinput");
		                	//fieldselspan.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		                }
	                }catch(e){}
	                fieldsel.options.add(new Option("",""));
	                lavachangefield("",rownum);
	            }else{
	            	//不为空情况去掉非空标识
	            	fieldselspan.removeClass("mustinput");
	            	try{
	                	fieldselspan.innerHTML="";
	                }catch(e){}
	
	                var selefields=returnvalues.split(",");
	                for(var i=0; i<selefields.length; i++){
	                    var itemids=selefields[i].split("$");
						 
	                    fieldsel.options.add(new Option(itemids[1],itemids[0]));
	                    if(i==0 && !entry) {
	                        lavachangefield(itemids[0],rownum,null,entry);
	                        fieldsel.value=itemids[0];
	                    }
	                }
	                if(entry){
	                	for(var i=0;i<entry.length;i++){
	                		var et = entry[i];
	                		if(et.name=="selectfieldid"){
	                			lavachangefield(et.value,rownum,null,entry);
	                        	fieldsel.value=et.value;
	                		}
	                	}
	                }
	            }
	            beautySelect(fieldsel);
	            try{
	            	if(!entry){
			            changefieldids.value="";
			            jQuery(changefieldidspan).html("");
			            changefieldidspanimg.innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
			         }
		        }catch(e){}
            }catch(e){
            	if(window.console)console.log(e);
            }
    	}
    });
    $(fieldsel).selectbox("detach");
    $(fieldsel).selectbox();
	lavanodeattr(rownum);
}

//选择所有节点时，其他选项隐藏，只留隐藏
function lavanodeattr(rownum){
	var nodevalue = jQuery("select#nodeid_"+rownum).val();
	var viewattrObj = jQuery("select#viewattr_"+rownum);
	var hasHiddenAttr = false;
	if(viewattrObj.find("option[value='1']").length > 0)
		hasHiddenAttr = true;
	if(nodevalue == -1){
		viewattrObj.find("option[value='1'],option[value='2'],option[value='3']").remove();
	}else{
		if(!hasHiddenAttr){
			viewattrObj.find("option[value='4'],option[value='5']").remove();
			viewattrObj[0].options.add(new Option("<%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%>", "2"));
			viewattrObj[0].options.add(new Option("<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>", "1"));
			viewattrObj[0].options.add(new Option("<%=SystemEnv.getHtmlLabelName(17873,user.getLanguage())%>", "3"));
			viewattrObj[0].options.add(new Option("<%=SystemEnv.getHtmlLabelName(126238,user.getLanguage())%>", "4"));
			viewattrObj[0].options.add(new Option("<%=SystemEnv.getHtmlLabelName(126239,user.getLanguage())%>", "5"));
		}
	}
	viewattrObj.selectbox("detach");
	viewattrObj.selectbox();
}

//'选择框字段'下拉框联动
function lavachangefield(fieldid,rownum,obj,entry){
	try{
		if(fieldid==null)fieldid = jQuery(obj).val();
		var name = jQuery(obj).attr("name");
		if(rownum==null)rownum = name.substring(name.lastIndexOf("_")+1);
	}catch(e){
		if(window.console)console.log(e);
	}
    fieldvaluesel=$GetEle("selectfieldvalue_"+rownum);
    //fieldvalueselspan=$GetEle("selectfieldvalue_"+rownum+"span");
    //非空感叹号所在span
    fieldvalueselspan = jQuery(fieldvaluesel).parent().find("#selectvaluespan");
    changefieldids=$GetEle("changefieldids_"+rownum);
    changefieldidspanimg=$GetEle("changefieldids_"+rownum+"spanimg");
    changefieldidspan=$GetEle("changefieldids_"+rownum+"span");
    jQuery.ajax({
    	url:"WorkflowSelectAjax.jsp",
    	type:"post",
		async:false,
    	dataType:"text",
    	data:{
    		workflowid:<%=wfid%>,
    		formid:<%=formid%>,
    		isbill:<%=isbill%>,
    		language:<%=user.getLanguage()%>,
    		option:"selfieldvalue",
    		fieldid:fieldid
    	},
    	beforeSend:function(xhr){
			try{
				e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(129500, user.getLanguage())%>",true);
			}catch(e){}
		},
		complete:function(xhr){
			e8showAjaxTips("",false);
		},
    	success:function(returnvalues){
    		try{
	    		clearOptionsCodeSeqSet(fieldvaluesel);
				if (returnvalues == "") {
					try{
						if(!entry){
							jQuery(changefieldidspan).html("");
							changefieldidspanimg.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
							//为空情况就显示非空标识
							fieldvalueselspan.addClass("mustinput");
							//fieldvalueselspan.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
						}
					}catch(e){}
					fieldvaluesel.options.add(new Option("", ""));
				} else {
					//不为空情况就去除非空标识
					 var ismust2=false;
					var selectvalue2=fieldvaluesel.getAttribute("seleval");
					var selefieldvalues = returnvalues.split(",");
					 
					for ( var i = 0; i < selefieldvalues.length; i++) {
						var itemids = selefieldvalues[i].split("$");
						//if(itemids[0]!="_"&&itemids[0]!="")
							if(itemids[0]==selectvalue2){
								ismust2=true;
							}
							if(itemids[0]=="_"){
							itemids[0]="";
							}
						fieldvaluesel.options.add(new Option(itemids[1],
								itemids[0]));
					}
					if(entry){
						for(var i=0;i<entry.length;i++){
	                		var et = entry[i];
	                		if(et.name=="selectfieldvalue"){
	                        	fieldvaluesel.value=et.value;
	                		}
	                	}
					}
				}
				if(ismust2){
						fieldvalueselspan.removeClass("mustinput");
					try{
						fieldvalueselspan.innerHTML = "";
					}catch(e){}
				}
				beautySelect(fieldvaluesel);
				try{
					if(!entry){
						changefieldids.value = "";
						jQuery(changefieldidspan).html("");
						changefieldidspanimg.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
					}
				}catch(e){}
			} catch (e) {
				if(window.console)console.log(e);
			}
    	}
    });
    $(fieldvaluesel).selectbox("detach");
    $(fieldvaluesel).selectbox();
    lavachangeViewAttr(fieldid, rownum);
}

function lavachangeViewIsmust(obj){
   var fieldvalueselspan2 = jQuery(obj).parent().find("#selectvaluespan");
	
	if(jQuery(obj).val()!=""){
			
			fieldvalueselspan2.removeClass("mustinput");
					try{
						fieldvalueselspan2.innerHTML = "";
					}catch(e){}
	}else{
		fieldvalueselspan2.addClass("mustinput");
		 
	}
}

//控制主表字段才有“隐藏”属性
function lavachangeViewAttr(fieldid, rownum){
	if(fieldid==null || rownum==null)
		return;
	var viewattrObj = jQuery("select#viewattr_"+rownum);
	var isMainField = true;
	if(fieldid.substring(fieldid.length-2) == "_1")
		isMainField = false;
	var hasHiddenAttr = false;
	if(viewattrObj.find("option[value='4']").length > 0)
		hasHiddenAttr = true;
	if(isMainField && !hasHiddenAttr){
		viewattrObj[0].options.add(new Option("<%=SystemEnv.getHtmlLabelName(126238,user.getLanguage())%>", "4"));
		viewattrObj[0].options.add(new Option("<%=SystemEnv.getHtmlLabelName(126239,user.getLanguage())%>", "5"));
	}else if(!isMainField && hasHiddenAttr){
		viewattrObj.find("option[value='4'],option[value='5']").remove();
	}
	viewattrObj.selectbox("detach");
	viewattrObj.selectbox();
}

function lavaShowMultiField(spanname,hiddenidname,nodeid,fieldid) {
	var url=encode("/workflow/field/MultiWorkflowFieldBrowser.jsp?wfid=<%=wfid%>&nodeid=" + nodeid + "&selfieldid=" + fieldid + "&fieldids=" + $G(hiddenidname).value);
	var data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url)
	var issame = false

	if (data){
        if (data.id!="" && data.id != "0"){
            
            $G(spanname).innerHTML ="<a href='#"+data.id.substr(1)+"'>"+data.name.substr(1)+"</a>";
            $G(hiddenidname).value=data.id.substr(1);
        }else{
            $G(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
            $G(hiddenidname).value=""
        }
	}
}

function lavaShowMultiFieldUrl(obj){
	var hidden = jQuery(obj).closest("div.e8_os").find("input[type='hidden']").eq(0);
	var name = hidden.attr("name");
	var rowIndex = -1;
	if(name){
		rowIndex = name.substring(name.lastIndexOf("_")+1,name.length);
	}
	return "/systeminfo/BrowserMain.jsp?mouldID=workflow&url=/workflow/field/MultiWorkflowFieldBrowser.jsp?wfid=<%=wfid%>&nodeid="+jQuery("#nodeid_"+rowIndex).val()+"&selfieldid="+jQuery("#selectfieldid_"+rowIndex).val()+"&fieldids="+hidden.val();
}

function encode(str){
    return escape(str);
}

function clearOptionsCodeSeqSet(ctl)
{	
	jQuery(ctl).selectbox("detach");
	for(var i=ctl.options.length-1; i>=0; i--){
		ctl.remove(i);
	}
}

function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}

function linkagevaselectall(){
    len = document.frmlinkageviewattr.elements.length;
    var i=0;
    for(i=len-1; i >= 0;i--) {
       if(document.frmlinkageviewattr.elements[i].name=='check_node'){
       		var linkck =  document.frmlinkageviewattr.elements[i];
        		linkck.checked=document.frmlinkageviewattr.checkall.checked;
        		if(linkck.checked){
        			$(linkck).next().addClass("jNiceChecked");
        		}else{
        			$(linkck).next().removeClass("jNiceChecked");
        		}
       }
    }
}

jQuery(document).ready(function(){
	jQuery(".e8tips").wTooltip({html:true});
});

</script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/e8_btn_addOrdel_wev8.js"></script>
</body>
</html>
