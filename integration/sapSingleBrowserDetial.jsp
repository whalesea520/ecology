<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="com.weaver.integration.entity.*"%>
<%@page import="com.weaver.integration.entity.Int_BrowserbaseInfoBean"%>
<%@page import="com.weaver.integration.entity.Sap_outParameterBean"%>
<%@page import="com.weaver.integration.entity.Sap_outTableBean"%>
<%@page import="com.weaver.integration.entity.Sap_inParameterBean"%>
<%@page import="com.weaver.integration.datesource.SAPInterationOutUtil"%>
<%@page import="com.weaver.integration.params.BrowserReturnParamsBean"%>
<%@page import="com.weaver.integration.log.LogInfo"%>
<%@page import="com.weaver.integration.entity.Sap_inStructureBean"%>
<%@page import="com.weaver.integration.entity.Sap_outStructureBean"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%> 
<%@page import="com.weaver.integration.util.IntegratedSapUtil"%> 
<%@ page import="java.util.List" %>
<%@ page import="com.sap.mw.jco.JCO" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs01" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="butil" class="com.weaver.integration.util.BaseUtil" scope="page" />
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page" />
<script language="javascript" src="/js/weaver_wev8.js"></script>
<link href="/integration/css/intepublic_wev8.css" type=text/css rel=stylesheet>
<link href="/integration/css/loading_wev8.css" type=text/css rel=stylesheet>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<html>
	<head>
		<%
			String workflowid=Util.null2String(request.getParameter("workflowid"));//字段id
			//搜索时大小写切换，默认大写，值分别为0大，1大小，2小
			String upperorlower = baseBean.getPropValue("Integrated", "IsUpperOrLower");
			//如果是新建流程，只能从页面取数据
			String imagefilename = "/images/hdSystem_wev8.gif";
			String titlename = "SAP"+SystemEnv.getHtmlLabelName(30688 ,user.getLanguage());
			String needfav ="1";
			String needhelp ="";
			//add by wshen
			String firstLoad = Util.getIntValue(request.getParameter("firstLoad"),0)+"";
			String type=Util.null2String(request.getParameter("type"));//集成流程按钮标识
			String operate=Util.null2String(request.getParameter("operate"));
			if("".equals(operate)){operate="select";}
			String fromfieldid=Util.null2String(request.getParameter("fromfieldid"));//字段id
			String fromNodeorReport=Util.getIntValue(request.getParameter("fromNodeorReport"),0)+"";//1表示改浏览按钮的点击来源为报表或节点前或批次条件
			String detailrow=Util.null2String(request.getParameter("detailrow"));//行号
			String nodeid=Util.null2String(request.getParameter("nodeid"));//流程表单的节点id
			Int_BrowserbaseInfoBean nb=butil.getSapBaseInfoById(type);
			String browsertype=nb.getBrowsertype();//226--集成单选浏览,227--集成多选浏览按钮
			int detailTable = 0;
			if("227".equals(browsertype)){
				rs.execute("select mxformname from sap_multiBrowser where browsermark='"+type+"'");
				if(rs.next()){
					String tempMx = Util.null2String(rs.getString("mxformname"));
					detailTable = Util.getIntValue(tempMx.substring(tempMx.indexOf("_dt")+3),0);
				}
			}
			String authcontorl=nb.getAuthcontorl();//是否开启权限控制
			IntegratedSapUtil integratedSapUtil=new IntegratedSapUtil();
			int rows=50;//每页显示多少行
			int rownum=1;//行号
			int countdata=1;//得到总数据
			int curpage=Util.getIntValue(request.getParameter("curpage"), 1);//当前页
			List outParameter=nb.getSap_outParameter();//获取输出参数
			List outStructure=nb.getSap_outStructure();//获取输出结构

			List inParameter=nb.getSap_inParameter();//获取输入参数
			List inStructure=nb.getSap_inStructure();//获取输入结构
			List outTable=nb.getSap_outTable();//获取输出表

			String hpid = nb.getHpid();//异构系统的id
			String poolid=nb.getPoolid();//连接池的id
			String regservice=nb.getRegservice();//服务id
			String isbill=nb.getIsbill();
			int loadDate=0;
			if(rs.execute("select loadDate from sap_service where id='"+regservice+"'")&&rs.next()){
				loadDate=Util.getIntValue(Util.null2String(rs.getString("loadDate")),0);
			}

			boolean isOnlyOutTable=true;//判断是否只有输出表，如果只有输出表，回写“主键”的值到表单，如果没有输出表，就不回写“主键”的值到表单，因为目前输出参数和输出结构没有主键的概念

			StringBuffer outtablestr=new StringBuffer();//记录输出表的显示字段
			StringBuffer outtablelist=new StringBuffer();//记录输出表的数据list

			List listoafield=new ArrayList();//封装赋值字段
			List listsapfield=new ArrayList();//封装输出表的sap显示列字段名
			List listsapfielddisplay=new ArrayList();//封装输出表的sap隐藏列字段名
			List listparamy=new ArrayList();//封装主键字段
			List seachfield=new ArrayList();//封装查询字段
			Map TableList=new HashMap();
			SAPInterationOutUtil saputil=new SAPInterationOutUtil();


			HashMap hashmap=new HashMap();
			HashMap hashmapstu=new HashMap();
			//处理页面输入参数
			for(int i=0;i<inParameter.size();i++){
				Sap_inParameterBean sap_inParameterBean=(Sap_inParameterBean)inParameter.get(i);
				String Constant=sap_inParameterBean.getConstant();//输入参数的固定值
				String Oafield=sap_inParameterBean.getOafield();//输入参数来源于OA字段的值
				String sapfield=sap_inParameterBean.getSapfield();//输入参数的sap字段
				String oafieldid=sap_inParameterBean.getFromfieldid();//OA字段的id
				String ismainfieldmy=sap_inParameterBean.getIsmainfield();//是否主表字段
				String inpar="";
				if("1".equals(ismainfieldmy)){
					//baseBean.writeLog("参数的名字operate="+operate);
					if("search".equals(operate)){
						//主表
						if("0".equals(upperorlower)){//大写
							inpar=Util.null2String(request.getParameter(sapfield)).trim().toUpperCase();//表示来源于当前页面的搜索
						}else if("1".equals(upperorlower)){//大小写
							inpar=Util.null2String(request.getParameter(sapfield)).trim();//表示来源于当前页面的搜索
						}else if("2".equals(upperorlower)){//小写
							inpar=Util.null2String(request.getParameter(sapfield)).trim().toLowerCase();//表示来源于当前页面的搜索
						}

					}else{
						//主表
						if("0".equals(upperorlower)){//大写
							inpar=Util.null2String(request.getParameter("field"+oafieldid)).trim().toUpperCase();//表示来源于/integration/sapSingleBrowser.jsp页面的搜索条件
						}else if("1".equals(upperorlower)){//大小写
							inpar=Util.null2String(request.getParameter("field"+oafieldid)).trim();//表示来源于/integration/sapSingleBrowser.jsp页面的搜索条件
						}else if("2".equals(upperorlower)){//小写
							inpar=Util.null2String(request.getParameter("field"+oafieldid)).trim().toLowerCase();//表示来源于/integration/sapSingleBrowser.jsp页面的搜索条件
						}
					}
				}else{
					if("search".equals(operate)){
						//明细表字段
						if("0".equals(upperorlower)){//大写
							inpar=Util.null2String(request.getParameter(sapfield)).trim().toUpperCase();
						}else if("1".equals(upperorlower)){//大小写
							inpar=Util.null2String(request.getParameter(sapfield)).trim();
						}else if("2".equals(upperorlower)){//小写
							inpar=Util.null2String(request.getParameter(sapfield)).trim().toLowerCase();
						}
					}else{
						//明细表字段
						if("0".equals(upperorlower)){//大写
							inpar=Util.null2String(request.getParameter("field"+oafieldid+"_"+detailrow)).trim().toUpperCase();
						}else if("1".equals(upperorlower)){//大小写
							inpar=Util.null2String(request.getParameter("field"+oafieldid+"_"+detailrow)).trim();
						}else if("2".equals(upperorlower)){//小写
							inpar=Util.null2String(request.getParameter("field"+oafieldid+"_"+detailrow)).trim().toLowerCase();
						}
					}
				}
				//baseBean.writeLog("------输入参数的过滤日志------");
				if("".equals(Oafield)&&!"".equals(Constant)){
					nb.setListAllSerchValue(sapfield, Constant);
					hashmap.put(sapfield,Constant);
					//baseBean.writeLog("s输入参数----"+sapfield+"--值:"+Constant);
				}else{
					nb.setListAllSerchValue(sapfield, inpar);
					hashmap.put(sapfield,inpar);
					//baseBean.writeLog("y输入参数----"+sapfield+"--值:"+inpar);
				}
			}
			//处理页面输入结构
			for(int i=0;i<inStructure.size();i++){
				Sap_inStructureBean sap_instructureBean=(Sap_inStructureBean)inStructure.get(i);
				String Constant=sap_instructureBean.getConstant();//输入参数的固定值
				String Oafield=sap_instructureBean.getOafield();//输入参数来源于OA字段的值
				String sapfield=sap_instructureBean.getSapfield();//输入参数的sap字段
				String oafieldid=sap_instructureBean.getFromfieldid();//OA字段的id
				String ismainfieldmy=sap_instructureBean.getIsmainfield();//是否主表字段
				String stuname=sap_instructureBean.getName();//结构体的名字
				String inpar="";
				if("1".equals(ismainfieldmy)){//主表
					if("search".equals(operate)){
						if("0".equals(upperorlower)){//大写
							inpar=Util.null2String(request.getParameter(stuname+"."+sapfield)).trim().toUpperCase();
						}else if("1".equals(upperorlower)){//大小写
							inpar=Util.null2String(request.getParameter(stuname+"."+sapfield)).trim();
						}else if("2".equals(upperorlower)){//小写
							inpar=Util.null2String(request.getParameter(stuname+"."+sapfield)).trim().toLowerCase();
						}
					}else{
						if("0".equals(upperorlower)){//大写
							inpar=Util.null2String(request.getParameter("field"+oafieldid)).trim().toUpperCase();
						}else if("1".equals(upperorlower)){//大小写
							inpar=Util.null2String(request.getParameter("field"+oafieldid)).trim();
						}else if("2".equals(upperorlower)){//小写
							inpar=Util.null2String(request.getParameter("field"+oafieldid)).trim().toLowerCase();
						}
					}
				}else{//明细表字段
					if("search".equals(operate)){
						if("0".equals(upperorlower)){//大写
							inpar=Util.null2String(request.getParameter(stuname+"."+sapfield)).trim().toUpperCase();
						}else if("1".equals(upperorlower)){//大小写
							inpar=Util.null2String(request.getParameter(stuname+"."+sapfield)).trim();
						}else if("2".equals(upperorlower)){//小写
							inpar=Util.null2String(request.getParameter(stuname+"."+sapfield)).trim().toLowerCase();
						}
					}else{
						if("0".equals(upperorlower)){//大写
							inpar=Util.null2String(request.getParameter("field"+oafieldid+"_"+detailrow)).trim().toUpperCase();
						}else if("1".equals(upperorlower)){//大小写
							inpar=Util.null2String(request.getParameter("field"+oafieldid+"_"+detailrow)).trim();
						}else if("2".equals(upperorlower)){//小写
							inpar=Util.null2String(request.getParameter("field"+oafieldid+"_"+detailrow)).trim().toLowerCase();
						}
					}
				}
				//baseBean.writeLog("------输入结构的过滤日志------");
				if("".equals(Oafield)&&!"".equals(Constant)){
					nb.setListAllSerchValue(stuname+"."+sapfield, Constant);
					hashmapstu.put(stuname+"."+sapfield,Constant);
					//baseBean.writeLog("s结构参数----"+stuname+"."+sapfield+"--值:"+Constant);
				}else{
					nb.setListAllSerchValue(stuname+"."+sapfield, inpar);
					hashmapstu.put(stuname+"."+sapfield,inpar);
					//baseBean.writeLog("y结构参数----"+stuname+"."+sapfield+"--值:"+inpar);
				}
			}






			int display=0;//得到显示列的总数
			if(outTable.size()>0)//说明有输出表,返回多行值
			{
				//输出表--start
				int tempj=0;
				//baseBean.writeLog("------输出表的过滤日志------");
				for(int i=0;i<outTable.size();i++){
					//循环参数
					Sap_outTableBean s=(Sap_outTableBean)outTable.get(i);
					//判断是否有查询字段
					if((s.getSearch()).equals("1")){
						if("0".equals(upperorlower)){//大写
							nb.setListAllSerchValue(s.getName()+"@"+s.getSapfield(), Util.null2String(request.getParameter(s.getName()+"@"+s.getSapfield())).toUpperCase());
						}else if("1".equals(upperorlower)){//大小写
							nb.setListAllSerchValue(s.getName()+"@"+s.getSapfield(), Util.null2String(request.getParameter(s.getName()+"@"+s.getSapfield())));
						}else if("2".equals(upperorlower)){//小写
							nb.setListAllSerchValue(s.getName()+"@"+s.getSapfield(), Util.null2String(request.getParameter(s.getName()+"@"+s.getSapfield())).toLowerCase());
						}
						tempj++;
						seachfield.add(s.getName()+"@"+s.getSapfield());
					}
					if(display==0)
					{
						//隐藏主键列
						outtablestr.append("<td style='display:none'>"+SystemEnv.getHtmlLabelName(30689 ,user.getLanguage()));
						outtablestr.append("</td>");

						if("227".equals(browsertype)){
							//多选sap浏览按钮
							outtablestr.append("<td><input type='checkbox' onclick=checkAllBox(this)></td>");
						}

						outtablestr.append("<td>");
						//序号
						outtablestr.append(SystemEnv.getHtmlLabelName(15486 ,user.getLanguage()));
						outtablestr.append("</td>");
					}
					//判断是否有显示字段
					if((s.getDisplay()).equals("1"))//显示列
					{
						outtablestr.append("<td>");
						outtablestr.append(s.getShowname());
						outtablestr.append("</td>");
						display++;
						listsapfield.add(s.getName()+"@"+s.getSapfield());//表明.字段名
					}else//隐藏列
					{
						outtablestr.append("<td style='display:none'>");
						outtablestr.append(s.getShowname());
						outtablestr.append("</td>");
						display++;
						listsapfielddisplay.add(s.getName()+"@"+s.getSapfield());//表明.字段名
					}
					//判断是否有赋值字段
					if(!"".equals(s.getFromfieldid())&&"0".equals(fromNodeorReport)){
						listoafield.add(s.getFromfieldid()+"-"+s.getOafield()+"-"+s.getIsmainfield()+"-"+s.getName()+"@"+s.getSapfield()+"-0");
					}else if("1".equals(s.getPrimarykey())&&"1".equals(fromNodeorReport)){//有主键列，并且来着与节点或出口条件配置
						listoafield.add(s.getFromfieldid()+"-"+s.getOafield()+"-"+s.getIsmainfield()+"-"+s.getName()+"@"+s.getSapfield()+"-1");
					}else if("0".equals(s.getPrimarykey())&&"1".equals(fromNodeorReport)){//有主键列，并且来着与节点或出口条件配置
						listoafield.add(s.getFromfieldid()+"-"+s.getOafield()+"-"+s.getIsmainfield()+"-"+s.getName()+"@"+s.getSapfield()+"-0");
					}
					//判断是否为主键
					if("1".equals(s.getPrimarykey())){
						listparamy.add(s.getName()+"@"+s.getSapfield());//表明.字段名
					}
				}

				//输出表--end
				//baseBean.writeLog("------调用sap函数的基本参数信息----");
				//baseBean.writeLog("------输入参数的个数----"+hashmap.size());
				//baseBean.writeLog("------浏览按钮的标识----"+type);
				//baseBean.writeLog("---------------------------------");
				BrowserReturnParamsBean returnpar=new BrowserReturnParamsBean ();
				if("search".equals(operate)||loadDate==1)
				{
					//baseBean.writeLog("执行搜索来得");
					returnpar=saputil.executeABAPFunction(hashmap,hashmapstu,null,type,new LogInfo(),workflowid);//add workflowid by wshen 175856
				}
				/*
				//输出表模拟数据   add by wshen 
				if(returnpar==null){
					returnpar = new BrowserReturnParamsBean();
				}
				Map tableMap = new HashMap();
				String sapTableName ="T_DATA";
				List tabletemp = new ArrayList();
				Map tableMapTemp1 = new HashMap();
				tableMapTemp1.put(sapTableName+"@"+"MANDT", "800");
				tableMapTemp1.put(sapTableName+"@"+"PREIS", "2.35");
				tabletemp.add(tableMapTemp1);
				Map tableMapTemp2 = new HashMap();
				tableMapTemp2.put(sapTableName+"@"+"MANDT", "810");
				tableMapTemp2.put(sapTableName+"@"+"PREIS", "2.351");
				tabletemp.add(tableMapTemp2);

				tableMap.put(sapTableName, tabletemp);
				returnpar.setTableMap(tableMap);
				//add end
				*/


				if(null!=returnpar)
				{
					TableList=returnpar.getTableMap();
					if(null!=TableList)
					{
						Iterator iteratorm=TableList.entrySet().iterator();
						while(iteratorm.hasNext())
						{
							Map.Entry entry = (Map.Entry)iteratorm.next();
							Object key=entry.getKey();
							List valuelist = (List)entry.getValue();
							//baseBean.writeLog("输出表的表名为:-------------"+key);
							if(null!=valuelist)
							{
								for(int ji=0;ji<valuelist.size();ji++)
								{
									boolean flag=false;
									Map hashmap02=(HashMap)valuelist.get(ji);//表示一行数据
									//过滤数据
									for(int jk=0;jk<seachfield.size();jk++)
									{

										//解决大小写过滤问题
										String seaflied="";
										if("0".equals(upperorlower)){//大写
											seaflied=Util.null2String(request.getParameter(seachfield.get(jk)+"")).trim().toUpperCase();
										}else if("1".equals(upperorlower)){//大小写
											seaflied=Util.null2String(request.getParameter(seachfield.get(jk)+"")).trim();
										}else if("2".equals(upperorlower)){//小写
											seaflied=Util.null2String(request.getParameter(seachfield.get(jk)+"")).trim().toLowerCase();
										}
										//seaflied = StringEscapeUtils.escapeHtml((String)seaflied);
										//baseBean.writeLog("过滤条件"+seaflied);
										//baseBean.writeLog("数据"+hashmap02.get(seachfield.get(jk)+""));
										if((hashmap02.get(seachfield.get(jk)+"")+"").indexOf(seaflied)==-1)//条件过滤数据
										{

											flag=true;//表示这条数据不符合条件
											break;
										}

									}
									if(flag)
									{
										rownum++;
										continue;
									}
									if(listsapfield.size()>0)//说明有可显示的字段或有隐藏的字段
									{
										if("search".equals(operate))//如果来源于搜索
										{
											String prarmlie="";
											//循环主键列
											for(int bj=0;bj<listparamy.size();bj++)//主键列可能有很多，复合主键
											{
												prarmlie+=hashmap02.get(listparamy.get(bj))+"$_$";
											}
											//验证权限--start
											if(integratedSapUtil.checkUserOperate(type,prarmlie,user,authcontorl))
											{

												if(countdata<=(rows*curpage)&&countdata>rows*(curpage-1))
												{
													if(countdata%2==0)
													{
														outtablelist.append("<tr class='DataDark'>");
													}else
													{
														outtablelist.append("<tr class='DataLight'>");
													}
													outtablelist.append("<td style='display:none'>"+prarmlie.replaceAll("\\$_\\$"," "));
													outtablelist.append("</td>");
													if("227".equals(browsertype)){
														//多选sap浏览按钮
														outtablelist.append("<td><input type='checkbox'></td>");
													}
													outtablelist.append("<td>"+countdata);
													outtablelist.append("</td>");
													for(int jk=0;jk<listsapfield.size();jk++)//输出显示列
													{
														Object result=hashmap02.get(listsapfield.get(jk));
														if(null==result)
														{
															result="";
														}
														result = (result+"").replaceAll("\"","&quot;");
														outtablelist.append("<td>"+result+"<input name='"+listsapfield.get(jk)+"' type='hidden' value=\""+result+"\"></td>");
													}
													for(int jk=0;jk<listsapfielddisplay.size();jk++)//输出隐藏列
													{
														Object result=hashmap02.get(listsapfielddisplay.get(jk));
														if(null==result)
														{
															result="";
														}
														result = (result+"").replaceAll("\"","&quot;");
														outtablelist.append("<td style='display:none'>"+result+"<input name='"+listsapfielddisplay.get(jk)+"' type='hidden' value=\""+result+"\"></td>");
													}
													outtablelist.append("</tr>");
												}
												countdata++;
												rownum++;
												continue;
											}
											//验证权限--end
										}else//不来源于搜索
										{
											String prarmlie="";
											//循环主键列
											for(int bj=0;bj<listparamy.size();bj++)//主键列可能有很多，复合主键
											{
												prarmlie+=hashmap02.get(listparamy.get(bj))+"$_$";
											}


											//验证权限--start
											if(integratedSapUtil.checkUserOperate(type,prarmlie,user,authcontorl))
											{

												if(rownum<=(rows*curpage)&&rownum>rows*(curpage-1))
												{
													if(rownum%2==0)
													{
														outtablelist.append("<tr class='DataDark'>");
													}else
													{
														outtablelist.append("<tr class='DataLight'>");
													}
													outtablelist.append("<td style='display:none'>"+prarmlie.replaceAll("\\$_\\$"," "));
													outtablelist.append("</td>");
													if("227".equals(browsertype)){
														//多选sap浏览按钮
														outtablelist.append("<td><input type='checkbox'></td>");
													}
													outtablelist.append("<td>"+rownum);
													outtablelist.append("</td>");
													for(int jk=0;jk<listsapfield.size();jk++)//输出显示列
													{
														Object result=hashmap02.get(listsapfield.get(jk));
														if(null==result)
														{
															result="";
														}
														result = (result+"").replaceAll("\"","&quot;");
														outtablelist.append("<td>"+result+"<input name='"+listsapfield.get(jk)+"' type='hidden' value=\""+result+"\"></td>");
													}
													for(int jk=0;jk<listsapfielddisplay.size();jk++)//输出隐藏列
													{
														Object result=hashmap02.get(listsapfielddisplay.get(jk));
														if(null==result)
														{
															result="";
														}
														result = (result+"").replaceAll("\"","&quot;");
														outtablelist.append("<td style='display:none'>"+result+"<input name='"+listsapfielddisplay.get(jk)+"' type='hidden' value=\""+result+"\"></td>");
													}
													outtablelist.append("</tr>");
												}

												countdata++;
												rownum++;
												continue;
											}
											//验证权限--end
										}

									}

								}
							}
						}
					}
				}
			}else  //下面为输出结构和输出参数
			{


				isOnlyOutTable=false;

				//baseBean.writeLog("输出结构字段个数"+outStructure.size());
				for(int i=0;i<outStructure.size();i++){
					Sap_outStructureBean s=(Sap_outStructureBean)outStructure.get(i);
					//判断是否有显示字段
					if((s.getDisplay()).equals("1")){
						//显示列
						outtablestr.append("<td>");
						outtablestr.append(s.getShowname());
						outtablestr.append("</td>");
						display++;
						//baseBean.writeLog("输出结构的显示列"+s.getName()+"."+s.getSapfield());
						listsapfield.add(s.getName()+"."+s.getSapfield());//结构名.字段名
					}else{
						//隐藏列
						outtablestr.append("<td style='display:none'>");
						outtablestr.append(s.getShowname());
						outtablestr.append("</td>");
						display++;
						//baseBean.writeLog("输出结构的隐藏列"+s.getName()+"."+s.getSapfield());
						listsapfielddisplay.add(s.getName()+"."+s.getSapfield());//结构名.字段名
					}
					//baseBean.writeLog("结构的赋值字段"+s.getFromfieldid());
					//判断是否有赋值字段
					if(!"".equals(s.getFromfieldid())){
						//表单字段的id-oa字段的英文名字-是否主表单的字段-sap字段的英文名字
						listoafield.add(s.getFromfieldid()+"-"+s.getOafield()+"-"+s.getIsmainfield()+"-"+s.getName()+"."+s.getSapfield()+"-0");
					}
				}

				//模拟结构的数据
					/* outtablestr.append("<td>");
					outtablestr.append("结构列");
					outtablestr.append("</td>");
					display++;
					listsapfield.add("zzl.test");//结构名.字段名
					listoafield.add("11203-oa-1-zzl.test");  */


				//输出参数处理逻辑开始---------------------------------------------------------------------------------------------------------------------
				for(int i=0;i<outParameter.size();i++){
					Sap_outParameterBean s=(Sap_outParameterBean)outParameter.get(i);
					//判断是否有显示字段
					if((s.getDisplay()).equals("1")){
						//显示列
						outtablestr.append("<td>");
						outtablestr.append(s.getShowname());
						outtablestr.append("</td>");
						display++;
						//baseBean.writeLog("输出参数的显示列"+s.getSapfield());
						listsapfield.add(s.getSapfield());//参数名
					}else{
						//隐藏列
						outtablestr.append("<td style='display:none'>");
						outtablestr.append(s.getShowname());
						outtablestr.append("</td>");
						display++;
						//baseBean.writeLog("输出参数的隐藏列"+s.getSapfield());
						listsapfielddisplay.add(s.getSapfield());//参数名
					}
					//判断是否有赋值字段
					if(!"".equals(s.getFromfieldid())){
						listoafield.add(s.getFromfieldid()+"-"+s.getOafield()+"-"+s.getIsmainfield()+"-"+s.getSapfield()+"-0");
					}
				}
				if(display>0){
					//拼接序号列
					String face_title="<td>"+SystemEnv.getHtmlLabelName(15486 ,user.getLanguage())+"</td>";
					if("227".equals(browsertype)){
						//多选sap浏览按钮
						face_title="<td><input type='checkbox'  onclick=checkAllBox(this)></td>"+face_title;
					}
					//保证序号列在第一位置
					outtablestr=new  StringBuffer(face_title+outtablestr.toString());
				}
				outtablelist=new StringBuffer("<tr class='DataDark'>");
				//执行sap函数，获取返回值
				BrowserReturnParamsBean returnpar=saputil.executeABAPFunction(hashmap,hashmapstu,null,type,new LogInfo(),workflowid);;//add workflowid by wshen 175856
				//add by wshen TestInput 输出参数
				/*if(returnpar==null){
					returnpar = new BrowserReturnParamsBean();
				}
				Map strMap = new HashMap();
				strMap.put("E_INFNR", "000235461");
				strMap.put("E_MESSAGE", "成功");
				strMap.put("E_TYPE", "S");
				returnpar.setStrMap(strMap);*/

				
				

				//add end


				if(null!=returnpar)
				{
					//outtablelist.append("<td style='display:none'>");
					//outtablelist.append("</td>");
					if("227".equals(browsertype)){
						//多选sap浏览按钮
						outtablelist.append("<td><input type='checkbox'></td>");
					}
					outtablelist.append("<td>"+rownum);
					outtablelist.append("</td>");
					//得到输出参数
					Map stmap=returnpar.getStrMap();
					//得到输出结构
					Map stmap_stur=returnpar.getStructMap();
					for(int jk=0;jk<listsapfield.size();jk++){//输出显示列
						Object result=null;
						//baseBean.writeLog("---------------"+listsapfield.get(jk));
						if((listsapfield.get(jk)+"").indexOf(".")!=-1){
							//获得输出结构的显示值
							//result="输出结构的显示值";
							result=stmap_stur.get(listsapfield.get(jk));
							//baseBean.writeLog("获得输出结构的显示值"+result);
						}else{
							//获得输出参数的显示值
							result=stmap.get(listsapfield.get(jk));
							//baseBean.writeLog("获得输出参数的显示值"+result);
						}
						if(null==result){
							result="";
						}
						result = (result+"").replaceAll("\"","&quot;");
						outtablelist.append("<td>"+result+"<input name='"+listsapfield.get(jk)+"' type='hidden' value=\""+result+"\"></td>");
					}
					for(int jk=0;jk<listsapfielddisplay.size();jk++){//输出隐藏列
						Object result=null;
						if((listsapfielddisplay.get(jk)+"").indexOf(".")!=-1){
							//获得输出结构的隐藏值
							result=stmap_stur.get(listsapfielddisplay.get(jk));
							//	baseBean.writeLog("获得输出结构的隐藏值"+result);
						}else{
							//获得输出参数的隐藏值
							result=stmap.get(listsapfielddisplay.get(jk));
							//baseBean.writeLog("获得输出参数的隐藏值"+result);
						}
						if(null==result)
						{
							result="";
						}
						result = (result+"").replaceAll("\"","&quot;");
						outtablelist.append("<td style='display:none'>"+result+"<input name='"+listsapfielddisplay.get(jk)+"' type='hidden' value=\""+result+"\"></td>");
					}
				}
				outtablelist.append("</tr>");

				countdata=2;//表示只有一行数据
			}

			List listAllSerch = nb.getListAllSerch();
			int count = listAllSerch.size();
			List listtd=new ArrayList();

		%>
		<script type="text/javascript">
			function btnseach()
			{
				$("#operate").attr("value","search");
				$("#curpage").attr("value","1");
				weaver.submit();
				enableAllmenu();
				var temp=parseInt($("#bjsap").css("height"))+50;
				$("#hidediv").css("height",temp);
				var h2=$("#hidedivmsg").css("height");
				var w2=$("#hidedivmsg").css("width");
				var a=(document.body.clientWidth)/2-140; 
				var b=(document.body.clientHeight)/2-40;
				$("#hidedivmsg").css("left",a);
				$("#hidedivmsg").css("top",b);
				$("#hidediv").show();
				$("#hidedivmsg").html("<%=SystemEnv.getHtmlLabelName(83785,user.getLanguage()) %>"+"...").show();

			}
			function nextpage(type){
			  $("#operate").attr("value","search");
				if(type=="1"){
					var temp=parseInt($("#curpage").val())+1;
					$("#curpage").attr("value",temp);
					weaver.submit();
				}else{
					var temp=parseInt($("#curpage").val())-1;
					$("#curpage").attr("value",temp);
					weaver.submit();
				}
			}
			//通用的选中表格某列的所有checkbox的方法
			function checkAllBox(obj){
				var T_table="";
				if($(obj).parent().parent().parent()[0].tagName=="TABLE"){
					T_table=$(obj).parent().parent().parent()[0];
				}else if($(obj).parent().parent().parent().parent()[0].tagName=="TABLE"){
					T_table=$(obj).parent().parent().parent().parent()[0];
				}

				T_table = $(obj).parents("table:first");

				var countTD=$(T_table).find("tr:first").find("td").length;
				if(countTD<=0){
					countTD=$(T_table).find("tr:first").find("th").length;
				}
				var tdindex=$(T_table).find("td").index($(obj).parents("td:first")[0]);
				if(tdindex<0){
					tdindex=$(T_table).find("th").index($(obj).parents("td:first")[0]);
				}
				if(tdindex>=countTD){
					tdindex=tdindex%countTD;
				}
				index=(tdindex);//表格的第几列
				var trSeq = $(T_table).find("tr").index($(obj).parents("tr:first")[0]);//表格的第几行
				var  flag="";
				$(T_table).find("tr").each(function(i){
					if(i==0){
						flag=$(obj).attr('checked');
					}
					$(this).find("td:eq("+index+")").find("input[type='checkbox']").attr('checked',flag);
					$(this).find("th:eq("+index+")").find("input[type='checkbox']").attr('checked',flag);
					changeCheckboxStatus($(this).find("td:eq("+index+")").find("input[type='checkbox']"),flag);
					changeCheckboxStatus($(this).find("th:eq("+index+")").find("input[type='checkbox']"),flag);
				});
			}
			function onClear()
			{
				btnclear_onclick();
			}
			function onCancel()
			{
				if(dialog) {
					dialog.close();
				}else{
					window.parent.close();
				}
			}

			var dialog = top.getDialog(parent);
			var winArguments;
			if(dialog){
				winArguments = dialog.currentWindow;
			}else{
				winArguments = window.dialogArguments
			}

			jQuery(window).ready(function(){
				<%
                    if("226".equals(browsertype)){
                %>
				//alert(jQuery("#BrowseTable").find("tr").length)
				jQuery("#BrowseTable").find("tr").bind("click",function(event){
					if($(this).index()>0){
						setParentWindowValue($(this));
						var returnvalue;
						<%
                            //检查赋值设置是否有赋值给本身的情况
                            if("1".equals(fromNodeorReport)){
                            //得到需要赋值的oa字段
                            for(int jk=0;jk<listoafield.size();jk++){
                                //表单字段的id-oa字段的英文名字-是否主表单的字段-sap字段的英文名字-是否主键
                                //T_DATA.MATNR
                                //s.getFromfieldid()+"-"+s.getOafield()+"-"+s.getismainfield()
                                String temp=listoafield.get(jk)+"";
                                String tempa[]=temp.split("-");
                                //baseBean.writeLog("tempa[4]=="+tempa[4]);
                                if("1".equals(tempa[4])){//如果设置了主键，那么永远浏览按钮傍边的显示的就是主键
                            %>
						//window.parent.returnValue = Array($.trim($(this).find("td")[0].innerHTML),$.trim($(this).find("td")[0].innerHTML));
						returnvalue = Array($.trim($(this).find("td")[0].innerHTML),$.trim($(this).find("td")[0].innerHTML));
						<%
                            }else if(fromfieldid.equals(tempa[0])){//找到了赋值给本身的字段
                                String filename=tempa[3];
                                //得到输出参数的赋值字段
                                //得到输出结构的赋值字段
                                //得到输出表的赋值字段
                                //得到输出表的主键字段
                        %>
						var _vs="";
						try{
							if($(this).find("input[name='<%=filename%>']").val()){
								_vs=$(this).find("input[name='<%=filename%>']").val();
							}else{
								_vs="";
							}
						}catch(e){
						}
						returnvalue = Array($.trim(_vs),$.trim(_vs));
						<%
                            }
                        }%>

                        <%
                        }else if(isOnlyOutTable&&listparamy.size()>0){%>
						returnvalue =  Array($.trim($(this).find("td")[0].innerHTML),$.trim($(this).find("td")[0].innerHTML));

						<%}
                        //主键优先赋值，如果设置了赋值字段，那么赋值字段不能覆盖主键的字段的值（把上面的setParentWindowValue方法放到returnvalue下面执行好像有问题，不起作用）
                        %>
						if(dialog){
							try{
								<%if("1".equals(fromNodeorReport)){%>

									if(returnvalue.length>1){
										var temp =  "{\"id\":\""+returnvalue[0]+"\",\"name\":\""+returnvalue[1]+"\"}";
										dialog.callback(eval("("+temp+")"));
									}
								<%}else{%>
									dialog.callback(returnvalue);
								<%}%>
							}catch(e){alert(e)}

							try{
								<%if("1".equals(fromNodeorReport)){%>
								if(returnvalue.length>1){
									var temp =  "{\"id\":\""+returnvalue[0]+"\",\"name\":\""+returnvalue[1]+"\"}";
									dialog.close(eval("("+temp+")"));
								}
								<%}else{%>
									dialog.close(returnvalue);
								<%}%>
							}catch(e){alert(e)}

							winArguments = dialog.currentWindow;
						}else{
							window.parent.returnValue = returnvalue;
							window.parent.close();
						}


					}
				});
				<%
                    }else{
                %>

				var vbox="input[type='checkbox']";
				jQuery("#BrowseTable").find("tr").bind("click",function(event){
					if($(this).index()>0){
						if(event.target.nodeName=="TD"){
							if(jQuery(this).find(vbox).attr("checked")){
								jQuery(this).find(vbox).attr("checked",false);
								changeCheckboxStatus(jQuery(this).find(vbox),false);
							}else{
								jQuery(this).find(vbox).attr("checked",true);
								changeCheckboxStatus(jQuery(this).find(vbox),true);
							}

						}
					}
				});
				<%
                    }
                %>
				jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
					$(this).addClass("Selected")
				})
				jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
					$(this).removeClass("Selected")
				})

			});
			function btnclear_onclick(){
				<%
                    //得到需要赋值的oa字段
                    for(int jk=0;jk<listoafield.size();jk++){
                        String temp=listoafield.get(jk)+"";
                        String tempa[]=temp.split("-");
                        String jie="field"+tempa[0];
                        String jiespan="field"+tempa[0]+"span";
                        String ismainfield=tempa[2];
                        String filename=tempa[3];
                        if("0".equals(ismainfield)){
                            jie = jie+"_"+detailrow;
                            jiespan=jie+"span";
                        }
                        //清空流程表单的数据--start
                        out.println("if(false) { ");
                            out.println("var wparg=winArguments;");
                            out.println("try{ ");
                            out.println("wparg.document.getElementById('"+jie+"').value='';");
                            out.println("$(wparg.document.getElementById('"+jie+"')).trigger('change');");

                            //判断必填性
                            out.println("var isbt=wparg.document.getElementById('"+jie+"').getAttribute('viewtype');");
                            //out.println("alert('"+jie+"'+isbt)");
                            out.println("if(isbt==1){ ");
                                out.println("wparg.document.getElementById('"+jiespan+"').innerHTML=\"<img src='/images/BacoError_wev8.gif' align='absmiddle'>\";");
                                //out.println("alert('哈哈')");
                            out.println("}");
                            out.println("}catch(e){ ");
                            out.println("}");
                            out.println("try{ ");
                            //浏览按钮判断--start
                            out.println("var t_type_hh=0; ");
                            out.println("try{ ");
                                out.println("if($(wparg.document.getElementById('"+jie+"')).prev().get(0).tagName=='BUTTON'){ ");//明细表字段比主表字段要少一个prev()
                                    out.println("t_type_hh='1'; ");//说明OA的这个字段是浏览按钮
                                out.println("} ");
                            out.println("}catch(e){ ");
                            out.println("} ");
                            out.println("try{ ");
                                out.println("if($(wparg.document.getElementById('"+jie+"')).prev().prev().get(0).tagName=='BUTTON'){ ");
                                    out.println("t_type_hh='1'; ");//说明OA的这个字段是浏览按钮
                                out.println("} ");
                            out.println("}catch(e){ ");
                            out.println("} ");
                            //浏览按钮判断--end
                            out.println("if(t_type_hh==0){");//文本框
                                out.println("if(wparg.document.getElementById('"+jie+"').type=='hidden')");
                                out.println("{");
                                out.println("wparg.document.getElementById('"+jiespan+"').innerHTML='';");
                                out.println("}");
                            out.println("}else{");//浏览按钮
                                out.println("if(isbt!=1){ ");//浏览按钮要多加一层不必填的判断
                                    out.println("wparg.document.getElementById('"+jiespan+"').innerHTML='';");
                                out.println("} ");
                            out.println("}");
                            out.println("}catch(e){ ");
                            out.println("}");
                        out.println("}else{");
                        out.println("var wparg=winArguments;");
                        out.println("try{");
                                out.println("wparg.document.getElementsByName('"+jie+"')[0].value='';");
                                out.println("$(wparg.document.getElementsByName('"+jie+"')[0]).trigger('change');");

                                //判断必填性
                                out.println("var isbt=wparg.document.getElementsByName('"+jie+"')[0].getAttribute('viewtype');");
                                out.println("if(isbt==1){ ");
                                out.println("wparg.document.getElementById('"+jiespan+"').innerHTML='<img src=/images/BacoError_wev8.gif align=absmiddle>';");
                                out.println("}");
                        out.println("}catch(e){");
                        out.println("}");
                        out.println("try{");
                                //浏览按钮判断--start
                                out.println("var t_type_hh=0; ");
                                out.println("try{ ");
                                    out.println("if($(wparg.document.getElementsByName('"+jie+"')[0]).prev().get(0).tagName=='BUTTON'){ ");//明细表字段比主表字段要少一个prev()
                                        out.println("t_type_hh='1'; ");//说明OA的这个字段是浏览按钮
                                    out.println("} ");
                                out.println("}catch(e){ ");
                                out.println("} ");
                                out.println("try{ ");
                                    out.println("if($(wparg.document.getElementsByName('"+jie+"')[0]).prev().prev().get(0).tagName=='BUTTON'){ ");
                                        out.println("t_type_hh='1'; ");//说明OA的这个字段是浏览按钮
                                    out.println("} ");
                                out.println("}catch(e){ ");
                                out.println("} ");
                                //浏览按钮判断--end
                                out.println("if(t_type_hh==0){");//文本框
                                    out.println("if(wparg.document.getElementsByName('"+jie+"')[0].type=='hidden')");
                                    out.println("{");
                                    out.println("wparg.document.getElementById('"+jiespan+"').innerHTML='';");
                                    out.println("}");
                                out.println("}else{");//浏览按钮
                                out.println("if(isbt!=1){ ");//浏览按钮要多加一层不必填的判断
                                    out.println("wparg.document.getElementById('"+jiespan+"').innerHTML='';");
                                    out.println("} ");
                                out.println("}");

                        out.println("}catch(e){");
                        out.println("}");
                        out.println("}");
                        //清空流程表单的数据--end
                    }
                %>
				var returnvalue =  Array(0,"");
				if(dialog){
					try{
						dialog.callback( returnvalue);
					}catch(e){alert(e)}

					try{
						dialog.close(returnvalue);

					}catch(e){alert(e)}

					winArguments = dialog.currentWindow;
				}else{
					window.parent.returnValue = returnvalue
					window.parent.close();
				}



			}
			$(document).ready(function(){
				$("input").keydown(function(e){
					var curKey = e.which;
					if(curKey == 13){
						btnseach();
						return false;
					}
				});
				//add by wshen
				<%--<%
                    for(int j=0;j<listAllSerch.size();j++)
                    {
                        SapSearchList s=(SapSearchList)listAllSerch.get(j);
                        if(Util.getIntValue(Util.null2String(s.getFromfieldid()),0)>0){
                            String fieldid = "";
                            if(s.getIsmainfield()==0){//detail
                                fieldid= s.getFromfieldid()+"_"+s.getDetailrow();
                            }else if(s.getIsmainfield()==1) {//main
                                fieldid= s.getFromfieldid();
                            }
                    %>

					var obj = winArguments.document.getElementById("field<%=fieldid%>");
					if(obj!=null&&document.getElementById("<%=s.getFromfieldid()%>")!==null){
						if(obj.tagName=="SELECT"){
							//下拉框
							if(document.getElementById("<%=s.getFromfieldid()%>").value==""){
								document.getElementById("<%=s.getFromfieldid()%>").value=obj[obj.selectedIndex].text;
							}
						}else{
							if(document.getElementById("<%=s.getFromfieldid()%>").value==""){
								document.getElementById("<%=s.getFromfieldid()%>").value=obj.value;
							}
						}
					}
					<%
						}
					}
            %>--%>
			});

			function setParentWindowValue(checkvalue)
			{
				//$(checkvalue).children("td").each(function(index) {
				//var tdvalue=$(this).text();
				//});
				<%
                    //得到需要赋值的oa字段
                    for(int jk=0;jk<listoafield.size();jk++)
                    {
                        //表单字段的id-oa字段的英文名字-是否主表单的字段-sap字段的英文名字
                        //T_DATA.MATNR
                        //s.getFromfieldid()+"-"+s.getOafield()+"-"+s.getismainfield()
                        String temp=listoafield.get(jk)+"";
                        String tempa[]=temp.split("-");
                        String jie="field"+tempa[0];
                        String jiespan="field"+tempa[0]+"span";
						String jieLable = "field_lable"+tempa[0];
						String jieLablespan = "field_lable"+tempa[0]+"span";
                        String ismainfield=tempa[2];
                        String filename=tempa[3];
                        //s.getFromfieldid()+"-"+s.getOafield()+"-"+s.getismainfield()
                        if("0".equals(ismainfield)){
                            jie = jie+"_"+detailrow;
                            jiespan=jie+"span";
							jieLable+="_"+detailrow;
							jieLablespan=jieLable+"span";
                        }

                %>
				if(false) {
					//ie
					try{
						if($(checkvalue).find("input[name='<%=filename%>']").val()){
							winArguments.document.getElementById("<%=jie%>").value = $(checkvalue).find("input[name='<%=filename%>']").val();
							$(winArguments.document.getElementById("<%=jie%>")[0]).trigger("change");
						}else{
							winArguments.document.getElementById("<%=jie%>").value="";
							$(winArguments.document.getElementById("<%=jie%>")[0]).trigger("change");
						}
					}catch(e){
					}

					try{
						if(winArguments.document.getElementById("<%=jie%>").type=="hidden"){
							if($(checkvalue).find("input[name=<%=filename%>]").val())
							{
								winArguments.document.getElementById("<%=jiespan%>").innerHTML = $(checkvalue).find("input[name='<%=filename%>']").val();
							}else
							{
								winArguments.document.getElementById("<%=jiespan%>").innerHTML="";
							}
						}else{
							winArguments.document.getElementById("<%=jiespan%>").innerHTML = "";
						}
					}catch(e){
					}
				}else{
					//非ie
					//说明：老表单的明细字段解析
					//input对面没有id属性，只有name属性
					//导致在非ie浏览器下，js脚本找不到对象
					//所以在非ie浏览器下，用	winArguments.document.getElementsByName("<%=jie%>")[0]来取对象
					//另外非ie浏览器下，非空字符串默认不等于ture么？？
					var fieldtype=0;
					var datatype="";
					if(winArguments.document.getElementById('<%=jie%>'))
					{
						fieldtype=winArguments.document.getElementById('<%=jie%>').getAttribute('fieldtype');
						datatype=winArguments.document.getElementById('<%=jie%>').getAttribute('datatype');
					}
					try{
						if($(checkvalue).find("input[name='<%=filename%>']").val()){
							winArguments.document.getElementsByName("<%=jie%>")[0].value = $(checkvalue).find("input[name='<%=filename%>']").val();
							$(winArguments.document.getElementsByName("<%=jie%>")[0]).trigger("change");
							if(winArguments.document.getElementsByName("<%=jie%>")[0].value!=""){
								var imgObj = winArguments.document.getElementsByName("<%=jie%>"+"spanimg");
								$(imgObj).find("img").hide();
								imgObj = winArguments.document.getElementById("<%=jie%>"+"span");
								$(imgObj).find("img").hide();

							}
							if(fieldtype==4&&datatype=="float"){
								winArguments.document.getElementsByName("<%=jieLable%>")[0].value = $(checkvalue).find("input[name='<%=filename%>']").val();
								$(winArguments.document.getElementsByName("<%=jieLable%>")[0]).trigger("blur");
							}
						}else{
							winArguments.document.getElementsByName("<%=jie%>")[0].value="";
							$(winArguments.document.getElementsByName("<%=jie%>")[0]).trigger("change");
							if(fieldtype==4&&datatype=="float"){
								winArguments.document.getElementsByName("<%=jieLable%>")[0].value = "";
								$(winArguments.document.getElementsByName("<%=jieLable%>")[0]).trigger("blur");
							}

						}
						
					}catch(e){

					}
					var isbt=0;
					if(winArguments.document.getElementById('<%=jie%>'))
					{
						isbt = winArguments.document.getElementById('<%=jie%>').getAttribute('viewtype')
					}
					var t_type_hh=0;
					try{
						if($(winArguments.document.getElementById('<%=jie%>')).prev().get(0).tagName=='BUTTON'){
							t_type_hh='1';
						}
					}catch(e){}
					try{
						if($(winArguments.document.getElementById('<%=jie%>')).prev().prev().get(0).tagName=='BUTTON'){
							t_type_hh='1';
						}
					}catch(e){}
					try{

						if(	winArguments.document.getElementsByName("<%=jie%>")[0].type=="hidden"){

							if($(checkvalue).find("input[name='<%=filename%>']").val()!=""){
								if(fieldtype==4&&datatype=="float"){
									if(	winArguments.document.getElementsByName("<%=jieLable%>")[0].type=="hidden"){
										winArguments.document.getElementById("<%=jieLablespan%>").innerHTML = $(checkvalue).find("input[name='<%=filename%>']").val();
									}
								}else{
									winArguments.document.getElementById("<%=jiespan%>").innerHTML = $(checkvalue).find("input[name='<%=filename%>']").val();
								}


							}else{
								if(isbt!=1){
									if(fieldtype==4&&datatype=="float"){
										winArguments.document.getElementById("<%=jieLablespan%>").innerHTML="";
									}
									winArguments.document.getElementById("<%=jiespan%>").innerHTML="";
									
								}
							}
						}else{
							if(isbt!=1){
								if(fieldtype==4&&datatype=="float"){
									winArguments.document.getElementById("<%=jieLablespan%>").innerHTML="";
								}
								winArguments.document.getElementById("<%=jiespan%>").innerHTML = "";
							}
						}
					}catch(e){


					}
				}
				<%
                    }
                %>
			}

			function setParentWindowValue02(checkvalue,temps)
			{
				//$(checkvalue).children("td").each(function(index) {
				//var tdvalue=$(this).text();
				//});
				<%
                    //得到需要赋值的oa字段
                    for(int jk=0;jk<listoafield.size();jk++)
                    {
                        //表单字段的id-oa字段的英文名字-是否主表单的字段-sap字段的英文名字
                        //T_DATA.MATNR
                        //s.getFromfieldid()+"-"+s.getOafield()+"-"+s.getismainfield()
                        String temp=listoafield.get(jk)+"";
                        String tempa[]=temp.split("-");
                        String jie="field"+tempa[0];
                        String jiespan="field"+tempa[0]+"span";
						String jieLable = "field_lable"+tempa[0];
						String jieLablespan = "field_lable"+tempa[0]+"span";
                        String ismainfield=tempa[2];
                        String filename=tempa[3];
                        //s.getFromfieldid()+"-"+s.getOafield()+"-"+s.getismainfield()
                        /* if("0".equals(ismainfield)){
                            jie = jie+"_"+detailrow;
                            jiespan=jie+"span";
                        } */

                %>
				var jie="<%=jie%>"+"_"+temps;
				var jiespan=jie+"span";
				var jieLable="<%=jieLable%>"+"_"+temps;
				var jieLablespan=jieLable+"span";
				if(false) {
					//ie
					try{
						if($(checkvalue).find("input[name='<%=filename%>']").val()){
							winArguments.document.getElementById(jie).value = $(checkvalue).find("input[name='<%=filename%>']").val();
							$(winArguments.document.getElementsByName(jie)[0]).trigger("change");
							winArguments.calSum("<%=detailTable-1%>",true,temps);
						}else{
							winArguments.document.getElementById(jie).value="";
							$(winArguments.document.getElementsByName(jie)[0]).trigger("change");
							winArguments.calSum("<%=detailTable-1%>",true,temps);
						}
					}catch(e){

					}

					try{
						if(winArguments.document.getElementById(jie).type=="hidden"){
							if($(checkvalue).find("input[name=<%=filename%>]").val())
							{
								winArguments.document.getElementById(jiespan).innerHTML = $(checkvalue).find("input[name='<%=filename%>']").val();
							}else
							{
								winArguments.document.getElementById(jiespan).innerHTML="";
							}
						}else{
							winArguments.document.getElementById(jiespan).innerHTML = "";
						}
					}catch(e){
					}

				}else{
					//非ie
					//说明：老表单的明细字段解析
					//input对面没有id属性，只有name属性
					//导致在非ie浏览器下，js脚本找不到对象
					//所以在非ie浏览器下，用	winArguments.document.getElementsByName("<%=jie%>")[0]来取对象
					//另外非ie浏览器下，非空字符串默认不等于ture么？？

					var fieldtype=0;
					var datatype="";
					if(winArguments.document.getElementById(jieLable))
					{
						fieldtype=winArguments.document.getElementById(jieLable).getAttribute('fieldtype');
						datatype=winArguments.document.getElementById(jieLable).getAttribute('datatype');
					}
					try{
						if($(checkvalue).find("input[name='<%=filename%>']").val()){

							winArguments.document.getElementsByName(jie)[0].value = $(checkvalue).find("input[name='<%=filename%>']").val();
							$(winArguments.document.getElementsByName(jie)[0]).trigger("change");
							if(fieldtype==4&&datatype=="float"){
								winArguments.document.getElementsByName(jieLable)[0].value = $(checkvalue).find("input[name='<%=filename%>']").val();
								$(winArguments.document.getElementsByName(jieLable)[0]).trigger("blur");
							}
							winArguments.calSum("<%=detailTable-1%>",true,temps);
						}else{
							winArguments.document.getElementsByName(jie)[0].value="";
							$(winArguments.document.getElementsByName(jie)[0]).trigger("change");
							winArguments.calSum("<%=detailTable-1%>",true,temps);
						}
					}catch(e){

					}
					try{

						if(	winArguments.document.getElementsByName(jie)[0].type=="hidden"){

							if($(checkvalue).find("input[name='<%=filename%>']").val()!=""){
								if(fieldtype==4&&datatype=="float"){
									if(	winArguments.document.getElementsByName(jieLable)[0].type=="hidden"){
										winArguments.document.getElementById(jieLablespan).innerHTML = $(checkvalue).find("input[name='<%=filename%>']").val();
									}
								}else{
									winArguments.document.getElementById(jiespan).innerHTML = $(checkvalue).find("input[name='<%=filename%>']").val();									
								}

							}else{
								if(fieldtype==4&&datatype=="float"){
									winArguments.document.getElementById(jieLablespan).innerHTML="";
								}
								winArguments.document.getElementById(jiespan).innerHTML="";
							}
						}else{
							if(fieldtype==4&&datatype=="float"){
								winArguments.document.getElementById(jieLablespan).innerHTML="";
							}
							winArguments.document.getElementById(jiespan).innerHTML = "";
						}
					}catch(e){


					}
				}
				<%
                    }
                %>

			}

			var isbill="<%=isbill%>";
			function btnmulok(){
				var temps=0;
				//多选浏览按钮点击Ok
				$("#BrowseTable tr").each(function(i){
					if(i>=1){
						if($(this).find("input[type='checkbox']").attr("checked")){
							if(false) {
								if(isbill==1){
									//ie
									winArguments.addRow<%=fromfieldid%>(<%=fromfieldid%>);
									//alert(winArguments.document.getElementById("indexnum<%=fromfieldid%>").value);
									temps=parseInt(winArguments.document.getElementById("indexnum<%=fromfieldid%>").value)-1;
								}else{
									//老表单
									////老表单要传2个参数
									winArguments.addRow<%=fromfieldid%>('<%=fromfieldid%>','<%=fromfieldid%>');
									//alert(winArguments.document.getElementById("indexnum<%=fromfieldid%>").value);
									temps=parseInt(winArguments.document.getElementById("indexnum<%=fromfieldid%>").value)-1;
								}

							}else{
								if(isbill==1){
									//非ie
									winArguments.addRow<%=fromfieldid%>(<%=fromfieldid%>);
									temps=parseInt(winArguments.document.getElementById("indexnum<%=fromfieldid%>").value)-1;
								}else{
									//老表单
									//非ie
									winArguments.addRow<%=fromfieldid%>('<%=fromfieldid%>','<%=fromfieldid%>');
									temps=parseInt(winArguments.document.getElementById("indexnum<%=fromfieldid%>").value)-1;
								}
							}
							setParentWindowValue02($(this),temps);
						}
					}
				});
				if(dialog){
					dialog.close();
				}else{
					window.parent.close();
				}

			}
		</script>
	</head>
	<body>
			<jsp:include page="/systeminfo/commonTabHead.jsp">
			   <jsp:param name="mouldID" value="integration"/>
			   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(30654,user.getLanguage())%>"/> 
			</jsp:include> 
			<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
			<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td width="160px">
					</td>
					<td class="rightSearchSpan"
						style="text-align: right; width: 500px !important">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="btnseach();">
						&nbsp;&nbsp;&nbsp;
						<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage()) %>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			<%
		
			if("227".equals(browsertype)){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(826 ,user.getLanguage())+",javascript:btnmulok(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
																				
			RCMenu += "{"+SystemEnv.getHtmlLabelName(197 ,user.getLanguage())+",javascript:btnseach(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onCancel(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			if(curpage>1)
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1258 ,user.getLanguage())+",javascript:nextpage(2),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		
			if((countdata-1)>(curpage*rows))
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1259 ,user.getLanguage())+",javascript:nextpage(1),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			if("226".equals(browsertype)){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			}
			%>
			<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
			<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		
			<div  style="width:100%;height:495px;overflow-x:auto;">
			<table width=100% height=100% border="0" cellspacing="0" cellpadding="0" style="padding-bottom: 32px;" id="bjsap">
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
								<form action="/integration/sapSingleBrowserDetial.jsp" name="weaver" method="post" >
										<!--//add by wshen-->
										<input type="hidden" name="firstLoad" id="firstLoad" value="<%=firstLoad%>">
										<input type="hidden" name="operate" id="operate" value="<%=operate%>">
										<input type="hidden" name="nodeid" id="nodeid" value="<%=nodeid%>">
										<input type="hidden" name="type"  id="type" value="<%=type%>">
										<input type="hidden" name="curpage"  id="curpage" value="<%=curpage%>">
										<input type="hidden" name="fromfieldid"  id="curpage" value="<%=fromfieldid%>">
										<input type="hidden" name="detailrow"  id="detailrow" value="<%=detailrow%>">
										<input type="hidden" name="fromNodeorReport"  id="fromNodeorReport" value="<%=fromNodeorReport%>">
										<input type="hidden" name="workflowid"  id="workflowid" value="<%=workflowid%>">
										
										<%

										if(listAllSerch!=null){//输出隐藏的输入参数或者查询条件。 解决当输入参数和输入结构不勾选显示的时候，点击搜索无法出数据，以及无法获取下一页的数据问题。qc:201915
											for(int i=0;i<listAllSerch.size();i++){
												SapSearchList s=(SapSearchList)listAllSerch.get(i);
												if(s.getSearch()==0){
													//隐藏的搜索条件
													String sapField = s.getSapfield();
													String sapFieldValue = s.getSapfieldvalue().replace("\'","&#39;");
													String fromFieldId =  s.getFromfieldid();
													int searchType = s.getSerchtype();
													%>
													<input type='hidden' name='<%=sapField%>' value='<%=sapFieldValue%>' id="<%=fromFieldId%>" class='styled input'   saptype='<%=searchType%>'>
													<%
												}
											}
										%>
											<wea:layout type="4Col">
											<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
										<%	
											for(int i=0;i<listAllSerch.size();i++){
												SapSearchList s=(SapSearchList)listAllSerch.get(i);
												String sapField = s.getSapfield();
												String sapFieldValue = s.getSapfieldvalue().replace("\'","&#39;");
												String fromFieldId =  s.getFromfieldid();
												int searchType = s.getSerchtype();
												if(s.getSearch()==0){
													//隐藏的搜索条件
													%>
													<input type='hidden' name='<%=sapField%>' value='<%=sapFieldValue%>' id="<%=fromFieldId%>" class='styled input'   saptype='<%=searchType%>'>
													<%
													continue;
												}

												%>
												<wea:item><%=s.getShowname()%></wea:item>
												<wea:item><input type='text' name='<%=sapField %>' value='<%=sapFieldValue %>'id='<%=fromFieldId%>' class='styled input'   saptype='<%=searchType%>'></wea:item>
												<%

											}
											%>
												<wea:item></wea:item>
											</wea:group>
										</wea:layout>
										<%
										}
										%>
											
										
										
							</form>
							
							<table class=viewform width="100%">
							<tr>
								<td style="text-align:right">
									<span class="e8_pageinfo">
										<span style="float:left;TEXT-DECORATION:none;height:30px;line-height:30px;color:#666666;"><%=SystemEnv.getHtmlLabelName(30640,user.getLanguage())%></span>



										<span id="-weaverTable-0_XTABLE_GOPAGE_buttom_go_page_wrap" style="float:left;display:inline-block;width:30px;height:20px;margin:0px 1px;padding:0px;position:relative;left:0px;top:5px;">
										
																				
										<%=curpage %></span><span style="float:left;TEXT-DECORATION:none;height:30px;line-height:30px;color:#666666;padding-right:10px;"><%=SystemEnv.getHtmlLabelName(30642,user.getLanguage())%></span><span class="e8_splitpageinfo"><span style="position:relative;TEXT-DECORATION:none;height:21px;padding-top:2px;"><div class="K13_select" style="width: 40px; z-index: 99;"><%=rows%></div><%=SystemEnv.getHtmlLabelName(18256,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(30642,user.getLanguage())%>&nbsp;|&nbsp;<%=SystemEnv.getHtmlLabelName(18609,user.getLanguage())%><%=(countdata-1) %><%=SystemEnv.getHtmlLabelName(30690,user.getLanguage())%></span></span></span>
																		 
									
									</td>
							</tr>
							</table>
							<table  ID=BrowseTable class=ListStyle cellspacing="1"  style="width:100%">
								<tr class="header">
									<%=outtablestr%>
								</tr>
									<%=outtablelist %>
							</table>
					</td>
					</tr>
					<%if(countdata-1==0){ %>
					<tr>
						<td align="center">
							<%= SystemEnv.getHtmlLabelName(22521,user.getLanguage())%>
						</td>
					</tr>
					<% }%>
					</TABLE>
				</td>
				<td></td>
			</tr>
			<tr>
				<td height="10" colspan="3"></td>
			</tr>
			</table>
			</div>
			<div style="height:42px;width:100%;"></div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClear();">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();">
	 	</wea:item>
	</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 	
	

	<DIV class=huotu_dialog_overlay id="hidediv"></DIV>
	<div  id="hidedivmsg" class="bd_dialog_main"></div>

</body>
</html>

