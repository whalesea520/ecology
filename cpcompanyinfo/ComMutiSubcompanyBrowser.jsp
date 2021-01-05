
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.sql.Timestamp,java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<HTML>
<HEAD>
<base/>
<link href="/cpcompanyinfo/style/Operations_wev8.css" rel="stylesheet"type="text/css" />
<link href="/cpcompanyinfo/style/Public_wev8.css" rel="stylesheet" type="text/css" />
<%--<link rel="stylesheet" href="/cpcompanyinfo/style/dhtmlxtree_wev8.css" type="text/css">--%>
<script type="text/javascript" src="/cpcompanyinfo/js/dhtmlxcommon_wev8.js"></script>
<script type="text/javascript" src="/cpcompanyinfo/js/dhtmlxtree_wev8.js"></script>
<script type="text/javascript">
	var dialog = null;
	try{
		dialog = parent.parent.getDialog(parent);
		//console.log("dialog:"+dialog);
	}
	catch(e){}
	
</script>

</HEAD>
<BODY style="overflow:hidden;">
	
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="cpcompany"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("1851",user.getLanguage())%>'/>
</jsp:include>

	<%
		String selevalue=Util.null2String(request.getParameter("selevalue"));
	 %>
   <div class="OContRightScroll"  style="width:100%;height:480px;>
		  <form name="userform" >
		      <table width="100%" border="0"  cellpadding="0" cellspacing="0"  align="center">
			        <tr>
			          <td valign="top" >
			                <div id="treeboxbox_tree1" style="width:100%;height:auto;"></div>
			          </td>
			        </tr>
			       
		       </table>
			            
		</form>
	</div>
	
	
	
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="check(1);">
		    	<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_cancle" class="zd_btn_cancle" onclick="cleanall();">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="check(2);">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
 <!--  
	<ul class="OContRightMsg2" style="font-size:12px;margin-left: 230px">
		<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a onclick="check(1)" class="hover"><div><div><%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></div></div></a></li>
		<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a onclick="cleanall()" class="hover"><div><div><%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></div></div></a></li>
		<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a onclick="check(2)" class="hover"><div><div><%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></div></div></a></li>
	</ul>
-->
		<script>
 			tree=new dhtmlXTreeObject("treeboxbox_tree1","","","-1");
			tree.setSkin('dhx_skyblue');
			tree.setImagePath("/cpcompanyinfo/images/");
			tree.enableCheckBoxes(1);
			tree.enableThreeStateCheckboxes(true);//设置选中根目录，选中下面的所有复选框
			tree.setXMLAutoLoading("/cpcompanyinfo/Comajaxmanage.jsp?selevalue=<%=selevalue%>");	
		    tree.loadXML("/cpcompanyinfo/Comajaxmanage.jsp?selevalue=<%=selevalue%>");
		    
			function check(type_) {
				if(type_=="1"){
					 var tempstr="";
			         var idlisttree = tree.getAllChecked();
			         var temp=idlisttree.split(",");
			         //alert(tree.getItemText("31"));//获得指定节点的文本
			         for(var i=0;i<temp.length;i++)
			         {
			         	tempstr += tree.getItemText(temp[i])+",";
			         }
			         tempstr = tempstr.substring(0,tempstr.length-1);
			         var returnjson = {id:idlisttree,name:tempstr};
			          
			          if(dialog){
						try{
		          			dialog.callback(returnjson);
		     			}catch(e){}
						try{
						     dialog.close(returnjson);
						 }catch(e){}
						 
					}else{
						window.parent.parent.returnValue = returnjson;
				 	 	window.parent.parent.close();
					}
					          
			         <%--  window.close();	--%>	  
				}else{
				
				if(dialog){
						dialog.close();
					}else{
				  		window.parent.parent.close();
					}
					 <%-- 
					  window.returnValue={id:'',name:''}
					  window.close();	
					  --%>	  	         
				}
		     }				
			function cleanall() {
				var returnjson = {id:"",name:""};
				if(dialog){
					try{
	          dialog.callback(returnjson);
				     }catch(e){}
				
				try{
				     dialog.close(returnjson);
				 }catch(e){}
				}else{
					window.parent.parent.returnValue = returnjson;
			  		window.parent.parent.close();
				}
				 <%--
				 window.returnValue= new Array("","");
		         window.close();	--%>
			}
			
		</script>

 </BODY>
 
 
</HTML>
