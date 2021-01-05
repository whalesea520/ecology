<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/formmode/checkright4setting.jsp" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<HTML>
<head>
<link href="/css/Weaver_wev8.css" type="text/css" rel="stylesheet">
<style type="text/css">
#lavaoTable{
	border-collapse: collapse;

	width: 100%;
}	
#lavaoTable tr th{
	text-align: left;
	padding: 4px;
	background-color: #eee;
}
#lavaoTable tr td{
	padding: 4px;
	border-bottom: 1px solid #eee;
	background-color: #fff;
}

.e8_innerShowContentOther{
	float:right;
	position:relative;
	background-color:#FFF;
	text-align:left;
	border: 1px solid #E9E9E2;
}


</style>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<!--以下是显示定制组件所需的js -->
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
</head>

<%!

public String getIdName(String id,int type, User user){
	RecordSet rs2 = new RecordSet();
	String fieldSpan = "";
	String sql = "";
    sql = "select b.indexdesc,a.detailtable from workflow_billfield a,htmllabelindex b where a.id in("+id+") and b.id=a.fieldlabel";
    rs2.executeSql(sql);
    while(rs2.next()){
    	String fieldname = rs2.getString("indexdesc");
    	String detailtable = rs2.getString("detailtable");
    	if(!detailtable.equals("")){
    		fieldname += "(" + SystemEnv.getHtmlLabelName(126218, user.getLanguage()) +detailtable.substring(detailtable.length()-1,detailtable.length())+")";
    	}
    	if( type == 0){
    		fieldSpan += "<span class='e8_showNameClass e8_showNameClassPadding'>"+fieldname+"</span>";
    	}else{
    		fieldSpan += fieldname;
    	}
    	

    }
	return fieldSpan;
}

public String getSelectName(String id,String selectvalue){
	RecordSet rs2 = new RecordSet();
	String fieldSpan = "";
	String sql = "";
	sql = "select * from workflow_SelectItem where fieldid="+id+" and selectvalue="+selectvalue;
	rs2.executeSql(sql);
    if(rs2.next()){
    	fieldSpan = rs2.getString("selectname");
    }
	return fieldSpan;
}

%>

<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16757,user.getLanguage());//文档监控
String needfav ="1";
String needhelp ="";

String id = Util.null2String(request.getParameter("id"));
String modeid = Util.null2String(request.getParameter("modeid"));
String formid = Util.null2String(request.getParameter("formid"));
int sourcetype = Util.getIntValue(request.getParameter("sourcetype"),0);

int i = 0;
%>


<%
   String sql = "";
   String note = "";
   if(!id.equals("")){
	   sql = "select * from mode_excelField where id="+id; 
	   RecordSet.executeSql(sql);
   	   if(RecordSet.next()){
   		   note = RecordSet.getString("note");
   	   }
   }
%>



<BODY>
<div class="zDialog_div_content" style="overflow-x:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%  
    if(sourcetype == 1){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:certain_click();,_self}" ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(127148,user.getLanguage())+",javascript:certain_clear();,_self}" ;
		RCMenuHeight += RCMenuHeightStep ;
    }
	
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%if(sourcetype == 1){ %>
<table id="topTitle" cellpadding="0" cellspacing="0"
				style="display: none;">
				<tr>
					<td></td>
					<td class="rightSearchSpan"
						style="text-align: right; width: 500px !important">
						<input type="button"
							value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"
							id="zd_btn_submit" class="e8_btn_top" onclick="certain_click();">
						<!-- 保存 -->
						<input type="button"
							value="<%=SystemEnv.getHtmlLabelName(127148,user.getLanguage()) %>"
							id="zd_btn_clear" class="e8_btn_top" onclick="certain_clear();">
						<span
							title="<%=SystemEnv.getHtmlLabelName(81804, user.getLanguage()) %>"
							class="cornerMenu"></span>
					</td>
				</tr>
</table>
<%} %>
<form name="linkageattr" id="linkageattr" method="post" action="" >
<input type="hidden" name="modeid" id="modeid" value='<%=modeid%>'>
<input type="hidden" name="formid" id="formid" value='<%=formid%>'>
<input type="hidden" name="id"  id="id" value='<%=id%>'>
	<wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelNames("32935,18019,22628,68",user.getLanguage())%>' >
		<%if(sourcetype == 1){%>
			<wea:item type="groupHead">
				<input type=button class=addbtn onclick="linkagevaaddrow()" title="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
	  			<input type=button class=delbtn onclick="linkagevadelrow()"title="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>"></input>
			</wea:item>	
	    <%} %>
			<wea:item attributes="{'isTableList':'true'}">
				<table width="100%" id="lavaoTable">
				    <COLGROUP>
				    <%if(sourcetype == 1){ %>
	  					<COL width="5%">
	  					<COL width="25%">
	  					<COL width="25%">
	  					<COL width="45%">
	  			    <%}else if(sourcetype == 0){%>
	  			        <COL width="25%">
	  			        <COL width="25%">
	  					<COL width="50%">
	  			    <%} %>
	  				</COLGROUP>
	  				 <TBODY>
	  				     <tr>
	  				        <%if(sourcetype == 1){ %>
	  				        <th><input type='checkbox' name='checkall' onclick="linkagevaselectall(this)"></th>
	  				        <%} %>
	  				     	<th ><%=SystemEnv.getHtmlLabelNames("690",user.getLanguage())%></th>
	  				     	<th ><%=SystemEnv.getHtmlLabelNames("21687",user.getLanguage())%></th>
	  				     	<th><%=SystemEnv.getHtmlLabelNames("24657",user.getLanguage())%></th>
	  				     </tr>
	  				     <%   
	  				     
	  				    String sqlwhere = " and modeid="+modeid+" and formid="+formid+" and ( fieldid  in ('-1000','-1001','-1002') or exists (select 1 from  workflow_billfield b where b.billid="+formid+" and b.id=a.fieldid) )";
						String sql2 = "select a.fieldid from mode_import_template a where 1=1 "+sqlwhere+"  order by a.dsporder,a.fieldid ";
						rs2.execute(sql2);//设置的字段
						int count = rs2.getCounts();
						sqlwhere = "";
						if(count>0){
							sqlwhere = " and exists (select 1 from  mode_import_template c where c.fieldid=a.id and c.modeid="+modeid+" and c.formid="+formid+" )";	
						}
						    if(!id.equals("")){
						    	sql = "select * from mode_excelFieldDetail where mainid="+id;
						    	if(count==0){
							    	sql+=" and selectids in(select a.id from workflow_billfield a, htmllabelindex b, ModeFormFieldExtend c where c.needExcel = 1 and a.billid=c.formId "
								  		+"and a.id=c.fieldId and a.billid="+formid+" and fieldhtmltype=5 and b.id=a.fieldlabel union select a.id from workflow_billfield a ,HtmlLabelindex c where "
								  		+"a.billid="+formid+" and c.id=a.fieldlabel and fieldhtmltype=5 and not exists (select 1 from ModeFormFieldExtend b where b.formid=a.billid and b.formid="+formid+" and b.fieldId=a.id) )";
								}
						    	RecordSet.executeSql(sql);
						    	while(RecordSet.next()){
						    		String fieldid = RecordSet.getString("fieldid");
						            String selectid = Util.null2String(RecordSet.getString("selectids"));
						            String selectvalue = Util.null2String(RecordSet.getString("selectvalue"));
						            String css = "";
						            if(!selectid.equals("")){
						            	css = "display:";						            	
						            }else{
						            	css = "display:none";
						            }
						            String fieldSpan = "";
						            sql = "select b.indexdesc,a.detailtable from workflow_billfield a,htmllabelindex b where a.id in("+fieldid+") and b.id=a.fieldlabel";
						            rs.executeSql(sql);
						            while(rs.next()){
						            	String fieldname = rs.getString("indexdesc");
						            	String detailtable = rs.getString("detailtable");
						            	if(!detailtable.equals("")){
						            		fieldname += "(" + SystemEnv.getHtmlLabelName(126218, user.getLanguage()) +detailtable.substring(detailtable.length()-1,detailtable.length())+")";
						            	}
						            	fieldSpan += fieldname + ",";
						            }
						            if(fieldSpan.length() > 0){
						            	fieldSpan = fieldSpan.substring(0,fieldSpan.length() - 1);
						            }
						%>
						
						<%
			     				String tempTitle = SystemEnv.getHtmlLabelName(18214,user.getLanguage());
	  				            //String browserUrl = "/systeminfo/BrowserMain.jsp?url=/formmode/setup/ImportValidationField.jsp?modeid="+modeid+"&formid="+formid+"&id="+id;
			                    String fieldidLabel = "fieldids_"+i;
			                    String fieldidSpanLabel = "sqlwhere_"+i;
	  				     %>
	  				     <tr>	
	  				     <%
	  				     if(sourcetype == 1){ %>
	  				      <td class="e8_tblForm_field">
	  				           <input type='checkbox' name='check_mode' value=''>
	  				       </td>
	  				       <%} %>	  	
	  				       <td class="e8_tblForm_field">
	  				           <% if(sourcetype == 1){ %>
	  				     	    <select onchange="selectValue(this,<%=i %>);" name="selectName_<%=i %>" id="selectName_<%=i %>">
	  				     	      <option></option>
	  				     	    <%
  				     	         if(count>0){
								  	sql = "select a.id,a.detailtable,b.* from workflow_billfield a, htmllabelindex b where a.billid="+formid+" and fieldhtmltype=5 and b.id=a.fieldlabel "+sqlwhere;
								  }else{
								  	sql="select a.id,a.detailtable,b.* ,c.needExcel from workflow_billfield a, htmllabelindex b, ModeFormFieldExtend c where c.needExcel = 1 and a.billid=c.formId "
								  		+"and a.id=c.fieldId and a.billid="+formid+" and fieldhtmltype=5 and b.id=a.fieldlabel union select a.id,a.detailtable,c.*,1 as needExcel from workflow_billfield a ,HtmlLabelindex c where "
								  		+"a.billid="+formid+" and c.id=a.fieldlabel and fieldhtmltype=5 and not exists (select 1 from ModeFormFieldExtend b where b.formid=a.billid and b.formid="+formid+" and b.fieldId=a.id)";
								  }
	  				     	       
	  				     	       rs.executeSql(sql);
	  				     	       while(rs.next()){
	  				     	         String tempfieldid = rs.getString("id");
	  				     	         String templabel = rs.getString("indexdesc");
	  				     	         String detailtable = rs.getString("detailtable");
	  				     	         if(detailtable != null && !detailtable.equals("")){
	  				     	        	templabel = templabel + "(" + SystemEnv.getHtmlLabelName(126218, user.getLanguage()) +detailtable.substring(detailtable.length()-1,detailtable.length())+")";
	  				     	         }
	  				     	    %>	  				     	      
	  				     	        <option value='<%=tempfieldid %>' <%if(tempfieldid.equals(selectid)){ %> selected <%} %>><%=templabel %></option>
	  				     	   <%} %>
	  				     	    </select>	
	  				     	     <%} else if(sourcetype == 0){%> 
	  				     	        					
						            <span ><%=getIdName(selectid,1, user) %></span>
						           
	  				     	     <%}%>				     	   
	  				     	 
	  				     </td>  
	  				     <TD class="e8_tblForm_field" >
	  				      <div STYLE="<%=css %>" id="valueTd_<%=i %>">
	  				         <%if(sourcetype == 1){ %>
	  				         <select name="validationName_<%=i %>" id="validationName_<%=i %>" style="min-width:100px;max-width:200px">
	  				        <%
	  				         if(!selectid.equals("")){
	  				        	 sql = "select * from workflow_SelectItem where fieldid="+selectid;
	  				        	 rs.executeSql(sql);
	  				     	     while(rs.next()){
	  				     	      	String label = rs.getString("selectname");
	  				  		  		String value = rs.getString("selectvalue");	 
	  				        %>
                            <option value="<%=value %>" <%if(selectvalue.equals(value)){ %> selected <%} %>><%=label %></option>
	  				     	<%}} %>	 				       	  				     	    	  				     	     
	  				     	</select>
	  				     	<%} else if(sourcetype == 0){ %>
	  				     	  					
						            <span ><%=getSelectName(selectid,selectvalue) %></span>
						    
	  				     	<%} %>
	  				     </div>			       
	  				     </TD>		   
	  				    
	  				     	<td class="e8_tblForm_field">
	  				     	  <%
	  				     	  if(sourcetype == 1){ 
	  				     	  		String tmpParams = i+" ";
	  				     	  %>
	  				     	    <brow:browser viewType="0" name="<%=fieldidLabel %>" browserValue='<%=fieldid %>' 
 		 						browserUrl=""
 		 						getBrowserUrlFn = "getBrowserUrl"
 		 						getBrowserUrlFnParams = "<%=tmpParams%>"
								hasInput='' isSingle="true" hasBrowser = "true" isMustInput="2"  tempTitle=""
								completeUrl="/data.jsp?type=mdFormBrowser" linkUrl=""  width="228px"
								browserDialogWidth="700px" browserDialogHeight="400px"
								browserSpanValue='<%=fieldSpan %>'
								></brow:browser>
								<%} else if(sourcetype == 0){%>
								
								 					
						            <span ><%=getIdName(fieldid,0, user) %></span>
						           
					
	  				     	<% }%>
	  				     	</td>	
	  				     	  				     
	  				     </tr>
	  				     <%  
	  				             i++;
	  				          }
						    }
						 %>
	  				 </TBODY>
				</table>
			</wea:item>	
            <%if(sourcetype == 1){ %>
			<wea:item attributes="{\"colspan\":\"\"}">
			     <table width="100%" class="temp">
			        <tr>
			           <td>
			              <span style="font-size: 15px;"><%=SystemEnv.getHtmlLabelName(85,user.getLanguage()) %>:</span><textarea style="width:560px;height:100px;" name="note" id="note" ><%=note %></textarea>
			           </td>
			        </tr>
			     </table>
			</wea:item>
			<%}else{ 
			    if(!note.trim().equals("")){
			%>		
			<wea:item attributes="{'isTableList':'true'}">
			     <table width="100%" class="temp" style="padding-left:0px;">
			        <tr>
			           <td>
			             <span style="font-size: 15px;"><%=SystemEnv.getHtmlLabelName(85,user.getLanguage()) %>:</span>
			             <span style="color:red;color-size:16px;"><%=note %></span>
			        </tr>
			     </table>
			</wea:item>
			<%} 
			}
			%>
		</wea:group>
	</wea:layout>
	<input type='hidden' id="field_rownum" name="field_rownum" value="<%=i%>">
	<input type='hidden' id="field_indexnum" name="field_indexnum" value="<%=i%>">
	<input type='hidden' id="checkfield" name="checkfield" value="">	
</form>
</div>
	
<script type="text/javascript">
var i = 0;
var dialog = null;
try{
	parentWin = parent.parent.parent.getParentWindow(parent.parent);
	dialog = parent.parent.parent.getDialog(parent.parent);
}catch(e){}



jQuery(document).ready(function(){
	resizeDialog(document);	
	$(".loading", window.parent.document).hide(); //隐藏加载图片
	var oTable = document.getElementById("lavaoTable");
	if(oTable.rows.length == 1){
		linkagevaaddrow();
	}
	else{
		var check_modes = document.getElementsByName("check_mode");
		for(var v=0; v<check_modes.length; v++){
			var rownum = check_modes[v].value;
			var btn = $("#changefieldids_"+rownum+"_browserbtn");
			btn.click(function(){
				var btnid = $(this).attr("id");
				var rownum = btnid.split("_")[1];
				setClickUrl(event,rownum);
			});
		}
	}
});


function certain_click(){
    var id = $("#id").val();
    var formid = $("#formid").val();
    var modeid = $("#modeid").val();
    var rownum = $("#field_indexnum").val();
    var fieldids = "";
    var selectid = "";
    var selectvalue = "";
    var jsonparam = "id="+id+"&formid="+formid+"&modeid="+modeid+"&field_rownum="+rownum;
    for(var i=0;i<rownum;i++){
       if(typeof($("#selectName_"+i).val()) != "undefined" && $("#selectName_"+i).val() != ""){
           selectid = "selectid_"+i+"="+$("#selectName_"+i).val();
           jsonparam += "&"+selectid;
       }    
         
       if(typeof($("#validationName_"+i).val()) != "undefined" && $("#validationName_"+i).val() != ""){
            selectvalue = "selectvalue_"+i+"="+$("#validationName_"+i).val();
            jsonparam += "&"+selectvalue;
       }
       if($("#fieldids_"+i).val() == "" ){
           window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("24657,18622",user.getLanguage())%>");
           return;
       }
       if(typeof($("#fieldids_"+i).val()) == "undefined"){
           continue;
       }
       fieldids = "fieldids_"+i+"="+$("#fieldids_"+i).val();
       jsonparam += "&"+fieldids;
    }
    var note = $("#note").val();
    jsonparam += "&note="+note;
   // var object = eval("("+jsonparam+")");
    var url = "/formmode/setup/ExcleFieldOperation.jsp?action=getFieldIds";
    jQuery.ajax({
         url : url,
         type : "post",
         processData : false,
         data : jsonparam,
         dataType : "json",
         async : true,
         success: function do4Success(data){
             var id = data.id;
         	var flag = data.flag;
         	
         	parentWin = parent.parent.parent.getParentWindow(parent.parent);
	        dialog = parent.parent.parent.getDialog(parent.parent);
         	
		    if(dialog){
				try{
					dialog.callback(data);
				}catch(e){}
				try{
					dialog.callbackfunParam = {rownum:rownum};
					dialog.close(data);
				}catch(e){}
			}else{
				if(config.parentWin){
					config.parentWin.returnValue = data;
					config.parentWin.close();
				}else{
					window.parent.returnValue = data;
					window.parent.close();
				}
			}
         }
     });
    /* $.post(
         url,
         object,
         function(data){        	
         	var id = data.id;
         	var flag = data.flag;
         	
         	parentWin = parent.parent.parent.getParentWindow(parent.parent);
	        dialog = parent.parent.parent.getDialog(parent.parent);
         	
		    if(dialog){
				try{
					dialog.callback(data);
				}catch(e){}
				try{
					dialog.callbackfunParam = {rownum:rownum};
					dialog.close(data);
				}catch(e){}
			}else{
				if(config.parentWin){
					config.parentWin.returnValue = data;
					config.parentWin.close();
				}else{
					window.parent.returnValue = data;
					window.parent.close();
				}
			}
         },
         "json"
         ) */
}

function linkagevaaddrow(){
    var oTable=document.getElementById("lavaoTable");
    var curindex=parseInt($('#field_rownum').val());
    var rowindex=parseInt($('#field_indexnum').val());
    var ncol = 4;
    var oRow = oTable.insertRow(-1);
    for(j=0; j<ncol; j++) {
        var oCell = oRow.insertCell(-1);
		switch(j) {
            case 0:
            {
                var oDiv = document.createElement("div");
                var sHtml = "<input type='checkbox' name='check_mode' value='"+rowindex+"'>";
                oDiv.innerHTML = sHtml;
                jQuery(oDiv).jNice();
                oCell.appendChild(oDiv);
                break;
            }
 
            case 1:
            {
                var oDiv = document.createElement("div");
                var sHtml = "";
		        $.ajax({
			         url:"/formmode/setup/ExcleFieldOperation.jsp",
			         async: false,
			         type:"post",
			         dataType:"json",
			         data:{formid:'<%=formid%>',modeid:'<%=modeid%>',action:'getSelectId'},
			         success : function(data){
			            sHtml = "<select onchange='selectValue(this,"+rowindex+");' name='selectName_"+rowindex+"' id='selectName_"+rowindex+"'><option value=''></option>";
			            for(var i=0;i<data.info.length;i++){
			                sHtml += "<option value='"+data.info[i].tempfieldid+"'>"+data.info[i].templabel+"</option>"
			            }
			            sHtml += "</select>";            
			         }
		        })  
		        oDiv.innerHTML = sHtml
			    oCell.appendChild(oDiv);    
		        break;	                           
            }
            
            case 2:
            {
                var oDiv = document.createElement("div");
                var sHtml = "<div STYLE='DISPLAY:NONE;' id='valueTd_"+rowindex+"'>"+
	  				        "<select name='validationName_"+rowindex+"' id='validationName_"+rowindex+"' style='min-width:100px;max-width:250px'>"+	  				     	    	  				     	     
	  				     	"</select>"+
	  				        "</div>";              
                oDiv.innerHTML = sHtml
                oCell.appendChild(oDiv);
                break;
            }
            case 3:
            {
                var oDiv = document.createElement("div");            
                var sHtml = "<div class='e8_os' style='width:228px;'>"+
                	"<div class='e8_innerShow e8_innerShow_button e8_innerShow_button_right30'>"+
					"<span class='e8_spanFloat'>"+
					"<span class='e8_browserSpan'>"+
					"<button class='Browser e8_browflow' type='button' onclick='setClickUrl(event,"+rowindex+")'></button></span></span></div>"+
                	"<div class='e8_innerShow e8_innerShowMust' id='innerShowMust_"+rowindex+"div'>"+
                	"<span class='e8_spanFloat' id='fieldids_"+rowindex+"spanimg' name='fieldids_"+rowindex+"spanimg'/><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span></div>"+
                	"<div class='e8_outScroll' id='outfieldids_"+rowindex+"div' style='width: 100%; margin-right: -30px;'>"+
					"<div class='e8_innerShow e8_innerShowContent' id='innerContentfieldids_"+rowindex+"div' style='width: 100%; margin-right:30px;'>"+
					"<div id='innerfieldids_"+rowindex+"div'  hasAdd=false hasBrowser=true style='margin-left:31px;'>"+
					"<input name='fieldids_"+rowindex+"' id='fieldids_"+rowindex+"' onpropertychange='' type='hidden' temptitle='' viewtype='0' value=''/>"+
					"<span id='fieldids_"+rowindex+"span' name='fieldids_"+rowindex+"span'></span>"+
					"</div>"+
					"</div>"+
					"</div>"+
					"</div>";
                oDiv.innerHTML = sHtml;
                oCell.appendChild(oDiv);
                break;
            }
    	}
    }
    $("#field_rownum").val(curindex+1) ;
    $('#field_indexnum').val(rowindex+1);
    beautySelect();
}


function linkagevadelrow(){
	var oTable=document.getElementById('lavaoTable');
    curindex=parseInt(document.getElementById("field_rownum").value);
    len = document.linkageattr.elements.length;
    var i=0;
    var rowsum1 = 0;
    var delsum=0;
    for(i=len-1; i >= 0;i--) {
        if (document.linkageattr.elements[i].name=='check_mode'){
            rowsum1 += 1;
            if(document.linkageattr.elements[i].checked==true) delsum+=1;
        }
    }
    if(delsum<1){
        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return;
    }else{
	    window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>",function(){
			var oTable=$G('lavaoTable');
	        curindex=parseInt($G("field_rownum").value);
	        len = document.linkageattr.elements.length;
	        var i=0;
	        var rowsum1 = 0;
	        for(i=len-1; i >= 0;i--) {
	            if (document.linkageattr.elements[i].name=='check_mode')
	                rowsum1 += 1;
	        }
	        for(i=len-1; i >= 0;i--) {
	            if (document.linkageattr.elements[i].name=='check_mode'){
	                if(document.linkageattr.elements[i].checked==true) {
	                    $G('checkfield').value = ($G('checkfield').value).replace("modeid_"+document.linkageattr.elements[i].value+",","");
	                    $G('checkfield').value = ($G('checkfield').value).replace("selectfieldid_"+document.linkageattr.elements[i].value+",","");
	                    $G('checkfield').value = ($G('checkfield').value).replace("selectfieldvalue_"+document.linkageattr.elements[i].value+",","");
	                    $G('checkfield').value = ($G('checkfield').value).replace("changefieldids_"+document.linkageattr.elements[i].value+",","");
	                    oTable.deleteRow(rowsum1);
	                    curindex--;
	                }
	                rowsum1 -=1;
	            }
	        }
	        $G("field_rownum").value=curindex;
		});
	}
}


function linkagevaselectall(obj){
	var checkboxs = document.getElementsByName("check_mode");
	for(var i=0;i<checkboxs.length;i++){
		//checkboxs[i].checked=obj.checked;
		changeCheckboxStatus(checkboxs[i],obj.checked);
	}
}


function setClickUrl(e,rownum){ 
	var fieldids = document.getElementById("fieldids_"+rownum).value;
	var selectName = $("#selectName_"+rownum).val();
	var param = "";
	param += "&modeid=<%=modeid%>";
	param += "&formid=<%=formid%>";	
	param += "&fieldids="+fieldids;
	param += "&rownum="+rownum;
	param += "&selectid="+selectName;
	showColDialog1(param);
}

var dialog = null;
function showColDialog1(param){
   	dialog = new top.Dialog();
   	dialog.currentWindow = window;
   	dialog.okLabel = "<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>";//确定
   	dialog.cancelLabel = "<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>";//取消
   	dialog.Drag = true;
   	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("18214",user.getLanguage())%>";//请选择
   	dialog.Width = 700;
   	dialog.Height = 400;
   	dialog.callbackfun = function(callbackfunParam, data){
   	var rownum = callbackfunParam.rownum;
   	   if(data){
   	      var newids = "";
	   	  var newnames = "";
	   	  var outerHTML = "";
   	   	  var id = data.id;
   	   	  var name = data.name;
   	   	  var id_arr = id.split(",");
	   	  var name_arr = name.split(",");
   	   	  for(var v=0; v<id_arr.length; v++){
	   			if(id_arr[v] && id_arr[v] != ""){	   				
	   				var newid = id_arr[v];//这里应该为是否为子表而不是行数
	   				newids += ","+newid;
	   				newnames = "  <a onclick='return false;' href='#"+newid+"'>"+name_arr[v]+"</a>";
	   				var span_temp = document.createElement("span");
	   		        span_temp.className = "e8_showNameClass e8_showNameClassPadding";
	   		        span_temp.innerHTML = newnames;
	   		        outerHTML += span_temp.outerHTML;
	   			}
	   		}
	   		if(newids && newids != ""){
	   			newids = newids.substring(1);
	   			newnames = newnames.substring(1);
	   		}
	   		document.getElementsByName("fieldids_"+rownum)[0].value = newids;
	   		
	   		var span_temp = document.createElement("span");
	   		span_temp.className = "e8_showNameClass e8_showNameClassPadding";
	   		span_temp.innerHTML = newnames;
	   		
	   		document.getElementsByName("fieldids_"+rownum+"span")[0].innerHTML = outerHTML;
	   		if(newnames!=""){
	   			document.getElementsByName("fieldids_"+rownum+"spanimg")[0].innerHTML="";
	   		}else{
	   			document.getElementsByName("fieldids_"+rownum+"spanimg")[0].innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	   		}
   	   }
   	}
   	dialog.URL ="/formmode/setup/ImportValidationField.jsp?"+param;
	dialog.show();
	
}

function closeColDialog(){
	dialog.close();
}

function selectValue(obj,num){
   $("#fieldids_"+num).val("");
   $("#fieldids_"+num+"spanimg").html("<img src='/images/BacoError_wev8.gif' align='absMiddle'>");
   $("#fieldids_"+num+"span").html("");
   var selectName = $(obj).val();
   if(selectName != ""){
      var url = "/formmode/setup/ExcleFieldOperation.jsp?action=getSelectInfo&selectid="+selectName;
      jQuery.ajax({
         url : url,
         type : "post",
         processData : false,
         data:{formid:'<%=formid%>',modeid:'<%=modeid%>'},
         dataType : "json",
         async : true,
         success: function do4Success(data){
             var info = data.info;
           	var selectObj = $("#validationName_"+num);
			selectObj.selectbox("detach");//禁用
			selectObj.empty();
			var varItem = new Option("","");   
			for(var i=0;i<info.length;i++){
				selectObj.append("<option value='"+info[i].value+"'>"+info[i].label+"</option>"); 
			}
			selectObj.selectbox("attach");//启用	 
         }
     });
      $("#valueTd_"+num).css("display","");
   }else{
      $("#valueTd_"+num).find("select").html("");
      $("#valueTd_"+num).css("display","none");
   }
}

function getBrowserUrl(num){   
     var selectName = $("#selectName_"+num).val();
     var fieldids = $("#fieldids_"+num).val();
     return  "/formmode/setup/ImportValidationField.jsp?modeid=<%=modeid%>&formid=<%=formid%>&id=<%=id%>&selectid="+selectName+"&fieldids="+fieldids;
}


function certain_clear(){
   window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(84545, user.getLanguage()) %>",function(){
       var url = "/formmode/setup/ExcleFieldOperation.jsp?action=clearAll";
       var modeid ="<%=modeid %>";
       var data = {formid:'<%=formid%>',modeid:'<%=modeid%>'};
       $.post(
           url,
           data,
           function(result){  
               dialog = parent.parent.parent.getDialog(parent.parent);
               var currentWindow = dialog.currentWindow;                          
               dialog.close();
               currentWindow.location.reload();
           })
   });

}


</script>
	</BODY>
</HTML>






