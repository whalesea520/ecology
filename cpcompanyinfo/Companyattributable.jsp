<%@page import="weaver.cpcompanyinfo.CompanyInfoTransMethod"%>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("License:manager", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/cpcompanyinfo/style/Public_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(30987,user.getLanguage());
String needfav ="1";
String needhelp ="";
int temp=0;
String flag=Util.null2String(request.getParameter("flag"));
String n_01="4px";
String n_02="0px";
String n_03="430px";
String  isie=Util.null2String(session.getAttribute("browser_isie")+"");
if(!"true".equals(isie)){
		n_01="0px";
		n_02="10px";
		n_03="400px";
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:doadd_gd(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:dodel_gd(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(30986,user.getLanguage())+",javascript:dosave_gd(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<iframe src="" style="display: none;" id="postiframe" name="postiframe"></iframe>
	<FORM id=frmMain  name=frmMain action="/cpcompanyinfo/CompanyServiceOperate.jsp" method=post  target="postiframe">
		<input type="hidden" name=delete_n   id="delete_n" >	
		<input type="hidden" name=temp_n   id="temp_n" value="<%=temp%>">
		<input type="hidden" name=countryid_count   id="countryid_count"  >
		<input type="hidden" name=temp_type   id="temp_type" value="Companyattributable">
		
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<%
		if(HrmUserVarify.checkUserRight("EditProjectType:Edit", user)){
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("86",user.getLanguage())%>" class="e8_btn_top"  onclick="dosave_gd()"/>
			<%
		}
		%>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<wea:layout >
     <wea:group context='<%=SystemEnv.getHtmlLabelName(30987,user.getLanguage()) %>' attributes="">
     <wea:item type="groupHead">
     	<input class="addbtn" accesskey="A" onclick="doadd_gd();" title="<%=SystemEnv.getHtmlLabelNames("611",user.getLanguage())%>" type="button">
		<input class="delbtn" accesskey="E" onclick="dodel_gd();" title="<%=SystemEnv.getHtmlLabelNames("91",user.getLanguage())%>" type="button">
     </wea:item>
    <wea:item attributes="{'isTableList':'true'}">

			<div style="overflow-y: auto;overflow-x:none ;height: <%=n_03 %>"  id=valign_div>
							<table class="ListStyle" cellspacing="1"  id="webTable2gd"   style="table-layout: fixed;margin: 0px">
								<colgroup>
										<col width="8%">
										<col width="30%">
										<col width="20%">
										<col width="*">
								</colgroup>
								
								<tr class="header">
									<th ><input type="checkbox"   onclick="checkAll(this)"></th>
									<th><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></th>
									<th><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th>
									<th><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></th>
								</tr>
										<%
							        		String sql="select Companyattributable.*,(select count(*) from Companyattributable ) s from Companyattributable  order by affixindex";
								      			rs.execute(sql);
								      			int i = 0;
								      			while(rs.next()){
								      				i++;
								      					temp=Util.getIntValue(rs.getString("s"),0);
								      					String name=rs.getString("name");
								      					String id=rs.getString("id");
								      					String affixindex=rs.getString("affixindex");
							      						String affdesc=rs.getString("affdesc");
								      	%>
								      		 <tr class="<%=i%2==0?"DataLight":"DataDark" %>">
										 	<td style=""> 
													<%
									 			if(!CompanyInfoTransMethod.CheckSION("3",id)){
									 			%>
										 			<input type="checkbox" name="checkbox"  value='<%=id%>'>
											 	<%			
											 			}
											 	 %>
											</td> 
											<td style=""> 
													<input class=inputstyle type=text  style="80px"  name=affixindexdesc   value='<%=affixindex%>' maxlength="5"  onblur="changeimg(this)"   onkeypress="if(!this.value.match(/^(?:[+-]|(?:[+-]?(?:[1-9]\d*|0)(?:\.\d*)?)?)$/))this.value=this.t_value;else this.t_value=this.value;if(this.value.match(/^(?:[+-]|(?:[+-]?(?:[1-9]\d*|0)(?:\.\d*)?)?)$/))this.o_value=this.value" onkeyup="if(!this.value.match(/^(?:[+-]|(?:[+-]?(?:[1-9]\d*|0)(?:\.\d*)?)?)$/))this.value=this.t_value;else this.t_value=this.value;if(this.value.match(/^(?:[+-]|(?:[+-]?(?:[1-9]\d*|0)(?:\.\d*)?)?)$/))this.o_value=this.value">
						            			<SPAN ></SPAN>
											</td>
											<td style=""> 
													<input class=inputstyle type=hidden  size=50  name=countryid     value="<%=id%>">
													<input class=inputstyle type=text  style="80px"   name=affname   maxlength="10"  onblur="changeimg(this)" value="<%=name%>">
										            <SPAN> </SPAN>
											</td> 
												<td style=""> 
													<input class=inputstyle type=text  style="80px"  name=affdesc   maxlength="20"   value='<%=affdesc%>'   >
						            			
												</td> 
											</tr>
								      	<% 	
								      		}	
										 %>
							</table>
			</div>

   		 </wea:item>
     </wea:group>
</wea:layout>	
 </form>
			
		<div id="hiddenTrInDIV" style="display:none">	
				<span _name="s">
						<input type="checkbox" name="checkbox">
				</span>
				<span _name="s">
						<input class=inputstyle type=text  style="80px"  name=affixindexdesc   maxlength="5"  onblur="changeimg(this)"   onkeypress="if(!this.value.match(/^(?:[+-]|(?:[+-]?(?:[1-9]\d*|0)(?:\.\d*)?)?)$/))this.value=this.t_value;else this.t_value=this.value;if(this.value.match(/^(?:[+-]|(?:[+-]?(?:[1-9]\d*|0)(?:\.\d*)?)?)$/))this.o_value=this.value" onkeyup="if(!this.value.match(/^(?:[+-]|(?:[+-]?(?:[1-9]\d*|0)(?:\.\d*)?)?)$/))this.value=this.t_value;else this.t_value=this.value;if(this.value.match(/^(?:[+-]|(?:[+-]?(?:[1-9]\d*|0)(?:\.\d*)?)?)$/))this.o_value=this.value">
						<SPAN ><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
				</span>
				<span _name="s">
						<input class=inputstyle type=hidden  size=50  name=countryid  >
						<input class=inputstyle type=text style="80px"  name=affname   _id=""  maxlength="10"  onblur="changeimg(this)">
			            <SPAN ><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
				</span>
				<span _name="s">
						<input class=inputstyle type=text  style="80px"  name=affdesc   maxlength="20"   >
				</span>
			</div>
		<script type="text/javascript">
		
			jQuery(document).ready(function(){
				<%
					if(!"".equals(flag)){
					out.println("alert('"+SystemEnv.getHtmlLabelName(30992,user.getLanguage())+"')");
					}
				%>
			});
			var temp_n=<%=temp%>;
			/*增加一行tr*/
			function doadd_gd(){
				var trhrml="<tr class='DataLight'>";
				jQuery("#hiddenTrInDIV").find("span[_name='s']").each(function(i){
								var temp=jQuery(this).html();
								if(i==0){
									trhrml+="<td >";
								}else if(i==1){
									trhrml+="<td class=Field>";
								}else if(i==2){
									trhrml+="<td >";
								}else if(i==3){
									trhrml+="<td >";
								}
								trhrml+=temp;
								trhrml+="</td>";
				})
				trhrml+="</tr>";
				jQuery("#webTable2gd").append(trhrml);
				
				jQuery("#webTable2gd").find("tr").last().find("span.jNiceCheckbox").bind("click",function(){
					jQuery(this).toggleClass("jNiceChecked");
					var pe=jQuery(this).prev();
					if(pe&&pe.attr("checked")==true){
						pe.removeAttr("checked");
					}else{
						pe.attr("checked","true");
					}
				});
				
				temp_n++;
				//控制新添加的行获得焦点
				var allelm = jQuery('#webTable2gd tr:gt(0)');
		        allelm.each( function(i){
		            		 jQuery(this).children("td:eq(1)").find("input").focus();
		         });
			}
			
			function dodel_gd(){
						var cheon=0;
						jQuery("#webTable2gd").find("input[name='checkbox']").each(function(){
							if(jQuery(this).attr("checked")==true){
								cheon++;
							}
						});
						if(cheon<=0){
							alert("<%=SystemEnv.getHtmlLabelName(30993,user.getLanguage()) %>!");
						}else{
							if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695,user.getLanguage()) %>?")){
										jQuery("#webTable2gd").find("input[name='checkbox']").each(function(){
										if(jQuery(this).attr("checked")==true){
											var t_value=jQuery(this).val();
											if(t_value){
												jQuery("#delete_n").val(jQuery("#delete_n").val()+t_value+",");
											}
											//jQuery(this).parent().parent().next().remove();
											jQuery(this).parents("tr").first().remove();
											temp_n--;
										}
									});
							}
						}
			}
			function changeimg(obj){
				if(jQuery(obj).val()!==""){
					jQuery(obj).next().html("");
				}else{
				  jQuery(obj).next().html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
				}
			}
			function dosave_gd(){
					var l=jQuery("#webTable2gd img").length;
					var arr = new Array();
					jQuery("#webTable2gd").find("input[type='text'][name='affname']").each(function(jk){
								arr[jk]=$.trim($(this).val());
					});
					if(mm(arr)){
							alert("<%=SystemEnv.getHtmlLabelName(31340,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(30569,user.getLanguage()) %>"+mm(arr)+"<%=SystemEnv.getHtmlLabelName(30570,user.getLanguage()) %>!");
							return;
					}		
					if(l>0){
							alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage()) %>");
					}else{
					
							var ary =  new Array();
							jQuery("#webTable2gd").find("input[name='affixindexdesc']").each(function(jk){
										ary.push(jQuery(this).val());
							});
							var s = ","+ary.join(",")+",";
							 for(var i=0;i<ary.length;i++) {
							 			if(ary[i]!=""){
											if(s.replace(","+ary[i]+",",",").indexOf(","+ary[i]+",")>-1) {
												alert("<%=SystemEnv.getHtmlLabelName(31434,user.getLanguage())%>：" + ary[i]+" !");
												return;
											}
										}
							}
							
							jQuery("#temp_n").val(temp_n);
							jQuery("#webTable2gd").find("input[type='text'][name='affname']").each(function(jk){
									jQuery(this).attr("name","affname_"+jk);
							});
							jQuery("#webTable2gd").find("input[type='hidden'][name='countryid']").each(function(jk){
									jQuery("#countryid_count").attr("value",jQuery("#countryid_count").attr("value")+jQuery(this).val()+",");
									jQuery(this).attr("name","countryid_"+jk);
							});
							jQuery("#webTable2gd").find("input[type='text'][name='affixindexdesc']").each(function(jk){
									jQuery(this).attr("name","affixindexdesc_"+jk);
									
							});
							
							jQuery("#webTable2gd").find("input[type='text'][name='affdesc']").each(function(jk){
									jQuery(this).attr("name","affdesc_"+jk);
									
							});
						  	jQuery("#frmMain").submit();
					}
			}
			function checkAll(obj){
				 var allelm = jQuery('#webTable2gd tr:gt(0)');
				 if(obj.checked==true){
			      	 allelm.each( function(i){
		          		jQuery(this).children("td:eq(0)").find("input").attr("checked",obj.checked);   
		          		jQuery(this).children("td:eq(0)").find("span:eq(1)").attr("class","jNiceCheckbox jNiceChecked"); 
			         });
			       }else{
			       		allelm.each( function(i){
		          		jQuery(this).children("td:eq(0)").find("input").attr("checked",obj.checked);   
		          		jQuery(this).children("td:eq(0)").find("span:eq(1)").attr("class","jNiceCheckbox"); 
			         });
			       }
			}
			// 验证重复元素，有重复返回true；否则返回false
			function mm(ary){
			   		var nary = ary.sort();
					for(var i = 0; i < nary.length - 1; i++){
					    if (nary[i] == nary[i+1]){
					         return  nary[i];
					    }
					}
			}
			$(function(){
				try{
					window.parent.hideLeftTree();
					parent.rebindNavEvent(null,null,null,null,{_window:window,hasLeftTree:false});
				}catch(e){}
			});
			</script>
	</body>
</html>
