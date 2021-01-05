<%@page import="com.weaver.integration.entity.Int_BrowserbaseInfoBean"%>
<%@page import="com.weaver.integration.util.BaseUtil"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.weaver.integration.entity.Sap_outTableBean"%>
<%@page import="com.weaver.integration.datesource.SAPInterationOutUtil"%>
<%@page import="com.weaver.integration.log.LogInfo"%>
<%@page import="com.weaver.integration.params.BrowserReturnParamsBean"%>
<%@page import="com.weaver.integration.entity.Sap_complexnameBean"%> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.List" %>
<%@ page import="com.sap.mw.jco.JCO" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs01" class="weaver.conn.RecordSet" scope="page" />
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<html>
	<base target="_self">
	<body>
	
			<% 
				
				String imagefilename = "/images/hdSystem_wev8.gif";
				String titlename = SystemEnv.getHtmlLabelName(30638 ,user.getLanguage());
				String needfav ="1";
				String needhelp ="";
				String mark=Util.null2String(request.getParameter("mark"));//集成流程按钮标识 
				String rightid=Util.null2String(request.getParameter("rightid"));//int_authorizeRight表的id
				//查出默认选中的值
				String operate=Util.null2String(request.getParameter("operate"));
				if("".equals(operate)){operate="search";}
				String isinclude=Util.getIntValue(request.getParameter("isinclude"),0)+"";
				String sql="";
				String ids=Util.null2String(request.getParameter("ids")).trim();
				int rows=50;//每页显示多少行
				int rownum=1;//行号
				int countdata=0;//得到总数据
				int curpage=Util.getIntValue(request.getParameter("curpage"),1);//当前页
				BaseUtil newSapBrowserComInfo=new BaseUtil();
				Int_BrowserbaseInfoBean nb=newSapBrowserComInfo.getSapBaseInfoById(mark);
				List outParameter=nb.getSap_outParameter();//获取输出参数
				List outTable=nb.getSap_outTable();//获取输出表
				List outStructure=nb.getSap_outStructure();//获取输出结构
				List inParameter=nb.getSap_inParameter();//获取输入参数
				List inStructure=nb.getSap_inStructure();//获取输入结构
				StringBuffer intablefield=new StringBuffer(); //记录输入参数的字段
				StringBuffer intstrufield=new StringBuffer(); //记录输入结构的字段
				StringBuffer outtablesb=new StringBuffer(); //记录输出表的搜索字段
				StringBuffer outtablestr=new StringBuffer();//记录输出表的显示字段
				StringBuffer outtablelist=new StringBuffer();//组装本页面的table
				List listoafield=new ArrayList();//封装赋值字段
				List seachfield=new ArrayList();//封装查询字段
				List listsapfield=new ArrayList();//封装输出表的sap显示列字段名
				List listsapfielddisplay=new ArrayList();//封装输出表的sap隐藏列字段名
				List listparamy=new ArrayList();//封装主键字段
				Map tableMap=new HashMap();
				List listvalue=new ArrayList();
				int display=0;//得到列的总数	
				
				
				if("save".equals(operate))
				{
					//保存操作
					String check_per[]=ids.split(",");
					if(null!=check_per)
					{
						rs.execute("delete int_authorizeDetaRight where rightid='"+rightid+"'");
						for(int jbk=0;jbk<check_per.length;jbk++){
							String valuerwo=check_per[jbk];
							if(!"".equals(valuerwo))
							{
								sql="insert into int_authorizeDetaRight (rightid,isinclude,value) values ('"+rightid+"','"+isinclude+"','"+valuerwo+"')";
								rs.execute(sql);
							}
						}
					
					}
				}	
				
				sql="select * from int_authorizeDetaRight where rightid='"+rightid+"'";
				rs.execute(sql);
				while(rs.next())
				{
					ids=ids.replace((","+rs.getString("value")),"");//先去掉重复的值
					ids+=","+rs.getString("value");
				}
							
				//说明有输出字段
				if(outTable.size()>0){
							//循环输出表里面的所有字段--start
							for(int i=0;i<outTable.size();i++){
										Sap_outTableBean s=(Sap_outTableBean)outTable.get(i);
										//判断是否有查询字段
										if((s.getSearch()).equals("1")){
												//outtablesb.append("<TR class='Spacing'  style='height:1px;'>");
												outtablesb.append("@@<td class=field>"+s.getShowname()+"</td>");
												outtablesb.append("@@<td><input type='text' name='"+s.getName()+"@"+s.getSapfield()+"' value='"+Util.null2String(request.getParameter(s.getName()+"@"+s.getSapfield()))+"'></td>");
												//outtablesb.append("</TR>");
												seachfield.add(s.getName()+"@"+s.getSapfield());
										}
										//第一列显示复选框
										if(display==0){
												outtablestr.append("<th>");
												outtablestr.append("<input type='checkbox' name='check_perALL' onclick=selectall(this) value=1 >全选");
												outtablestr.append("</th>");
												outtablestr.append("<th>序号");
												outtablestr.append("</th>");
										}
										//判断是否有显示字段，显示列
										if((s.getDisplay()).equals("1")){
											outtablestr.append("<th>");
												outtablestr.append(s.getShowname());
											outtablestr.append("</th>");
											display++;
											listsapfield.add(s.getName()+"@"+s.getSapfield());//表明.字段名
										}else {
											 //隐藏列
											outtablestr.append("<th style='display:none'>");
												outtablestr.append(s.getShowname());
											outtablestr.append("</th>");
											display++;
											listsapfielddisplay.add(s.getName()+"@"+s.getSapfield());//表明.字段名
										}
										//判断是否有赋值字段
										if(!"".equals(s.getFromfieldid())){
											listoafield.add(s.getFromfieldid()+"-"+s.getOafield()+"-"+s.getIsmainfield());
										}
										//判断是否为主键
										if("1".equals(s.getPrimarykey())){
											listparamy.add(s.getName()+"@"+s.getSapfield());//表明.字段名
										}
							}
						//循环输出表里面的所有字段--end
						if(!"".equals(outtablesb.toString().trim())){	
								String pj="";
								String strtj[]=outtablesb.toString().split("@@");
								for(int i=0;i<strtj.length;i++){
									if(i%4==0&&i!=0){
											pj+="<TR class='Spacing'  style='height:1px;'>";
											pj+=strtj[i-3];
											pj+=strtj[i-2];
											pj+=strtj[i-1];
											pj+=strtj[i];
											pj+="</TR>";
									}else if((strtj.length-1)==i){
											pj+="<TR class='Spacing'  style='height:1px;'>";
											pj+=strtj[i-1];
											pj+=strtj[i];
											pj+="</TR>";
									}
								}
								//System.out.println("pj="+pj);
								//说明有搜索条件
								outtablesb=new StringBuffer("<table width=100% class='viewform' id='seachtable'><colgroup><col width='25%'><col width='25%'><col width='25%'><col width='25%'></colgroup>"+pj);
								outtablesb.append("</table>");
						}
						SAPInterationOutUtil saputil=new SAPInterationOutUtil();
						//传入的输入参数和输入结构都为空
						//因为这里不可能去对应的表单上去抓值
						//HashMap hashmap=new HashMap();
						//执行函数
						BrowserReturnParamsBean returnpar=saputil.executeABAPFunction(null,null,null,mark,new LogInfo());
						if(null!=returnpar){
								List listouttable=nb.getSap_complexnameBeanByMark(mark, "2");
								if(null!=listouttable&&listouttable.size()>0){
									//说明有输出表,只输出一张表供用户设置权限--start
									for(int c=0;c<1;c++){
													Sap_complexnameBean sap_complexnameBean02=(Sap_complexnameBean)listouttable.get(c);
													tableMap=returnpar.getTableMap();
													listvalue=(List)tableMap.get(sap_complexnameBean02.getName());//得到该表下面的所有的abap数据
													if(null!=listvalue){
															for(int i=0;i<listvalue.size();i++){
																	boolean flag=false;
																	Map hashmap02=(HashMap)listvalue.get(i);//表示一行数据
																	//过滤数据--start
																	for(int jk=0;jk<seachfield.size();jk++){
																		String seaflied=Util.null2String(request.getParameter(seachfield.get(jk)+"")).trim().toUpperCase();
																		//System.out.println("过滤条件"+seaflied);
																		//System.out.println(seachfield.get(jk)+"数据"+hashmap02.get(seachfield.get(jk)+""));
																		if((hashmap02.get(seachfield.get(jk)+"")+"").indexOf(seaflied)==-1){
																			flag=true;//表示这条数据不符合条件
																			break;
																		}
																	}
																	if(flag){
																		//继续判断下一条数据，是否符合条件
																		continue;
																	}else{
																		//说明有可显示的字段
																		if(listsapfield.size()>0){
																					if(countdata<(rows*curpage)&&countdata>=rows*(curpage-1)){
																						//数据属于当前页显示的内容
																						String prarmlie="";
																						if(countdata%2==0){
																							outtablelist.append("<tr class='DataDark'>");
																						}else{
																							outtablelist.append("<tr class='DataLight'>");
																						}
																						//循环主键列
																						for(int bj=0;bj<listparamy.size();bj++){
																							//主键列可能有很多，复合主键
																							prarmlie+=hashmap02.get(listparamy.get(bj))+"$_$";
																						}
																						outtablelist.append("<td>");
																						//prarmlie=002$_$
																						//ids=,GG-CDE-002$_$
																						//System.out.println("prarmlie="+prarmlie);
																						//System.out.println("ids="+ids);
																						//循环选中的列
																						boolean  checkb=false;
																						String chenckedin[]=ids.split(",");
																						for(int ck=0;ck<chenckedin.length;ck++){
																								if(!"".equals(ids)&&prarmlie.equals(chenckedin[ck])&&!"$_$".equals(prarmlie)){
																									checkb=true;
																								}
																						}
																						if(checkb){
																								outtablelist.append("<input type='checkbox' name='check_per' value='"+prarmlie+"' checked> ");
																						}else{
																								outtablelist.append("<input type='checkbox' name='check_per' value='"+prarmlie+"'> ");
																						}
																					
																						outtablelist.append("</td>");
																						outtablelist.append("<td>"+(countdata+1));
																						outtablelist.append("</td>");
																						for(int jk=0;jk<listsapfield.size();jk++){
																         						outtablelist.append("<td>"+hashmap02.get(listsapfield.get(jk))+"</td>");
																         				}
																         				for(int jk=0;jk<listsapfielddisplay.size();jk++){
																         					//输出隐藏列
																         						outtablelist.append("<td style='display:none'>"+hashmap02.get(listsapfielddisplay.get(jk))+"<input name='"+listsapfielddisplay.get(jk)+"' type='hidden' value='"+hashmap02.get(listsapfielddisplay.get(jk))+"'></td>");
																         				}
																         				outtablelist.append("</tr>");
																         				countdata++;
																						continue;
																					}else{
																						//数据不属于当前页显示的内容
																						countdata++;
																						continue;
																					}
																			
																		}
																	
																	}
																	//过滤数据--end
														}
												}
									}
									//说明有输出表,只输出一张表供用户设置权限--end
								}
						}
				}
				
			 %>
			 
			 
			<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(197 ,user.getLanguage())+",javascript:btnseach(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(826 ,user.getLanguage())+",javascript:btnok_onclick(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btnCancel(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			//System.out.println("总数据"+listvalue.size());
			if(curpage>1)
			{
				//有上一页
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1258 ,user.getLanguage())+",javascript:nextpage(2),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			
			if(countdata>(curpage*rows))
			{
				//有下一页
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1259 ,user.getLanguage())+",javascript:nextpage(1),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		
			
			RCMenu += "{"+SystemEnv.getHtmlLabelName(15504,user.getLanguage())+",javascript:submitClear(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			
			
			
			
			%>
			<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
			<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
			
			<form action="/integration/browse/integrationSAPDataAuthSetting.jsp" name="weaver" method="post">
			<input type="hidden" name="operate" id="operate" value="<%=operate%>">
			<input type=hidden  name="mark"  id="mark" value="<%=mark%>">
			<input type="hidden" name="rightid" id="rightid" value="<%=rightid%>">
			<input type="hidden" name="curpage"  id="curpage" value="<%=curpage%>">
			
		
			<input type="hidden" name="ids"  id="ids" value="<%=ids%>">
			<!--  
			<textarea rows="5" cols="50" name="ids" id="ids"><=ids%></textarea>
			-->
			<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
			<colgroup>
			<col width="10">
			<col width="*">
			<col width="10">
			<tr>
				<td height="10" colspan="3"></td>
			</tr>
			<tr>
				<td ></td>
				<td valign="top">
					<TABLE class=Shadow>
					<tr>
					<td valign="top" width="100%">
							<%=outtablesb%>
							<br>
							说明：当SAP的主键列的值为空时,选择作为权限控制值,视为无效！
							<table class=viewform>
							<colgroup>
									<col width="100px">
									<col width="*">
							</colgroup>
							<TR class='Spacing'  style='height:1px;'><TD class='Line1' colspan=2></TD></TR>
							<tr>
								<td>
								
									 <%=SystemEnv.getHtmlLabelName(28224 ,user.getLanguage()) %>
									  <input type="checkbox"   checked="checked" disabled="disabled"><%=SystemEnv.getHtmlLabelName(346 ,user.getLanguage()) %>
									   <input type="hidden" name="isinclude" value="1">
								</td>
								<td class=field style="text-align: right;">
									<%=SystemEnv.getHtmlLabelName(30640 ,user.getLanguage()) %><%=curpage%><%=SystemEnv.getHtmlLabelName(30642 ,user.getLanguage()) %>&nbsp;&nbsp;
									<%=SystemEnv.getHtmlLabelName(18609 ,user.getLanguage()) %>
									<%=countdata%>
									<%=SystemEnv.getHtmlLabelName(24683 ,user.getLanguage()) %>&nbsp;&nbsp;
									<%=SystemEnv.getHtmlLabelName(30643 ,user.getLanguage()) %><%=rows%><%=SystemEnv.getHtmlLabelName(24683 ,user.getLanguage()) %>&nbsp;&nbsp;
								</td>
							</tr>
							<TR class='Spacing'  style='height:1px;'><TD class='Line1' colspan=2></TD></TR>
							</table>	
							<table  ID=BrowseTable class=BroswerStyle cellspacing="1">
								<tr class="DataHeader">
									<%=outtablestr%>
								</tr>
									<%=outtablelist %>
							</table>
							<%
							
									if("".equals(outtablesb.toString().trim())&&"".equals(outtablestr.toString().trim())&&"".equals(outtablelist.toString().trim()))
									{
										out.println(SystemEnv.getHtmlLabelName(30645 ,user.getLanguage()));
									}
							%>
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
		
	</body>
</html>
<script type="text/javascript">

$(document).ready(function(){ 
	         $("input").keydown(function(e){ 
	             var curKey = e.which; 
	             if(curKey == 13){ 
	                 btnseach();
	                 return false; 
	             } 
	         }); 
}); 
var ids = "<%=ids%>";
//多选
jQuery(document).ready(function(){
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(event){
		if($(this)[0].tagName=="TR"&&event.target.tagName!="INPUT"){
				var obj = jQuery(this).find("input[name=check_per]");
			   	if (obj.attr("checked") == true){
			   		obj.attr("checked", false);
			   		ids = ids.replace("," + jQuery(this).find("input[name=check_per]").val(), "")
			   	}else{
			   		obj.attr("checked", true);
			   		ids = ids + "," + jQuery(this).find("input[name=check_per]").val();
			   	}
		}
		//点击checkbox框
	    if(event.target.tagName=="INPUT"){
	       var obj = jQuery(this).find("input[name=check_per]");
		   	if (obj.attr("checked") == true){
		   	    ids = ids + "," + jQuery(this).find("input[name=check_per]").val();
		   	}else{
		   		ids = ids.replace("," + jQuery(this).find("input[name=check_per]").val(), "")
		   	}
		   
	    }
	   
	})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
		$(this).addClass("Selected")
	})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
		$(this).removeClass("Selected")
	})
});
function btnseach()
{
	$("#operate").attr("value","search");
	$("#curpage").attr("value","1");
	weaver.submit();
	enableAllmenu();
}
function btnclear_onclick() {
     window.parent.returnValue = {id: "0",name: ""};
     window.parent.close();
}

function btnok_onclick() {
	//alert("保存"+ids);
	$("#ids").attr("value",ids);
	$("#operate").attr("value","save");
	weaver.submit();
	enableAllmenu();
}
function btnCancel()
{
	window.close();
}
function submitClear()
{
	//清除
	$("#seachtable").find("input").attr("value","");
	
}
function nextpage(type)
{
	if(type=="1")
	{
		//下一页
		var temp=parseInt($("#curpage").val())+1;
		$("#curpage").attr("value",temp);
		$("#ids").attr("value",ids);
		weaver.submit();
	}else
	{
		//上一页
		var temp=parseInt($("#curpage").val())-1;
		$("#curpage").attr("value",temp);
		$("#ids").attr("value",ids);
		weaver.submit();
	}
	enableAllmenu();
}
function selectall(obj){
	var check_nodes = jQuery("input[type='checkbox'][name='check_per']"); 
	if(obj.checked){
		var allsapcode = '';
		check_nodes.each(function(){
			this.checked = true;
			ids = ids.replace("," +this.value, "");
			ids +=","+this.value;//去重复并且获取值
		});
	}else{
		var allsapcode = '';
		check_nodes.each(function(){
			this.checked = false;
			ids = ids.replace("," +this.value, "");
		});
	}
}
</script>
