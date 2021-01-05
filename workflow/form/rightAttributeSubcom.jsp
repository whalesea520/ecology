
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

</head>
<%

	String selectValue = Util.null2String(request.getParameter("selectValue"));

	List subcom_keys = new ArrayList();
	subcom_keys.add("2");
	subcom_keys.add("20");
	subcom_keys.add("21");
	subcom_keys.add("22");
	subcom_keys.add("23");
	
	List subcom_values = new ArrayList();
	subcom_values.add(SystemEnv.getHtmlLabelName(30792,user.getLanguage()));
	subcom_values.add(SystemEnv.getHtmlLabelName(22753,user.getLanguage()));
	subcom_values.add(SystemEnv.getHtmlLabelName(235,user.getLanguage())+SystemEnv.getHtmlLabelName(22753,user.getLanguage()));
	subcom_values.add(SystemEnv.getHtmlLabelName(17898,user.getLanguage()));
	subcom_values.add(SystemEnv.getHtmlLabelName(235,user.getLanguage())+SystemEnv.getHtmlLabelName(17898,user.getLanguage()));

%>
<body>

<form name="frmain" method="post" action="rightAttributeSubcom.jsp">

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<div id="attrSubcomTab" style="">
	<table class="viewform" cellspacing=1  >
		<colgroup>
			<col width="10">
			<col width="*">
		</colgroup>
          <tbody>
          <tr class=title>
          	<th><input type="checkbox" value="" id="subcomAll" name="subcomAll" /></th>
            <th><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(16510,user.getLanguage())%></th>
          </tr>
          <TR class=spacing style="height:2px;"> <TD class=line1 colspan="2"></TD> </TR>
	      
	       <%
	      for(int i=0 ;i<subcom_keys.size();i++){
	      	String key = subcom_keys.get(i)+"";
	      	String value = subcom_values.get(i)+"";
	       %>
	      <tr>
	      	  <td><input type="checkbox" value="<%=key %>" id="subcom_<%=key %>" name="subcom_<%=key %>"/></td>
              <td><span id="subcom_<%=key %>_span"><%=value%></span></td>
          </tr>
          <TR class=spacing style="height:2px;"><TD class=line1 colspan="2" style='height:1px;padding:0;margin:0px;'></TD></TR>
          
          <%} %>
        </tbody>
    </table>

</div>

<TABLE class=viewform >
<TBODY>
   <TR>
     <td align="center">
  		<button type=button  class=btn onClick="save()"><%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></button>
  		<button type=button  class=btn onClick="resetData()"><%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%></button>
  		<button type=button  class=btn onClick="cancel()"><%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></button>
     </td>
   </TR>
</TBODY>
</TABLE>


		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

</form>
<script language=javascript>

var selectValue = '<%=selectValue%>';

jQuery(document).ready(function(){
	
	jQuery("#subcomAll").click(function(){
		if(jQuery(this).attr('checked')==false){
			jQuery("input[name^='subcom_']").each(function(){
				jQuery(this).removeAttr("checked");
			});
		}else{
			jQuery("input[name^='subcom_']").each(function(){
				jQuery(this).attr("checked","checked");
			});
		}
		disabledSubcom();
	});
	
	//所有上级分部  ，所有下级分部
	jQuery("#subcom_21,#subcom_23").click(function(){
		disabledSubcom();
	});
	
	init();
});

function init(){
	if(selectValue!=""){
		var sv = selectValue.split(",");
		for(var i=0;i<sv.length;i++){
			var s = sv[i];
			try{
				jQuery("#subcom_"+s).attr("checked","checked");
			}catch(e){}
		}
		disabledSubcom();
	}
}

function clearSubcomChk(){
	jQuery("#subcomAll").removeAttr("checked");
	jQuery("input[name^='subcom_']").each(function(){
		jQuery(this).removeAttr("checked");
	});
	disabledSubcom();
}

function disabledSubcom(){
	if(jQuery("#subcom_21").attr("checked")==true){ //所有上级分部
		jQuery("#subcom_20").removeAttr("checked"); //上级分部
		jQuery("#subcom_20").attr("disabled","disabled");
	}else{
		jQuery("#subcom_20").removeAttr("disabled");
	}
	
	if(jQuery("#subcom_23").attr("checked")==true){ //所有下级分部
		jQuery("#subcom_22").removeAttr("checked"); //下级分部
		jQuery("#subcom_22").attr("disabled","disabled");
	}else{
		jQuery("#subcom_22").removeAttr("disabled");
	}
}

function save(){
	var id = "";
	var name = "";	
	jQuery("input[name^='subcom_'][checked]").each(function(){
		id += ","+jQuery(this).val();
		
		var spanid = jQuery(this).attr("id");
		name += ","+jQuery("#"+spanid+"_span").text();
	});
	
	if(id!=""){
		id = id.substring(1);
		name = name.substring(1);
	}
	window.parent.returnValue = {id:""+id, name:""+name};
    window.parent.close();
}

function resetData(){
	clearSubcomChk();
	disabledSubcom();
	if(selectValue!=""){
		var sv = selectValue.split(",");
		for(var i=0;i<sv.length;i++){
			var s = sv[i];
			try{
				jQuery("#subcom_"+s).attr("checked","checked");
			}catch(e){}
		}
		
		disabledSubcom();
	}
}

function cancel(){
	window.parent.close();
}
</script>
</body>

</html>