
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.weaver.integration.util.IntegratedSapUtil"%>
<%@page import="weaver.workflow.action.BaseAction"%>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.workflow.action.*"%>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs02" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SapUtil" class="com.weaver.integration.util.IntegratedSapUtil" scope="page"/>
<jsp:useBean id="basebean" class="weaver.general.BaseBean" scope="page" />

<%
	String opera=Util.null2String(request.getParameter("opera"));
	String flag="0";//0保存失败,1保存成功
	String baseid=Util.null2String(request.getParameter("baseid"));//int_BrowserbaseInfo表id
	String mark=Util.null2String(request.getParameter("mark"));
	String temp_mark=Util.null2String(request.getParameter("mark"));
	String hpid=Util.null2String(request.getParameter("hpid"));
	String poolid=Util.null2String(request.getParameter("poolid"));
	String formid=Util.null2String(request.getParameter("formid"));
	String regservice=Util.null2String(request.getParameter("regservice"));
	String brodesc=Util.null2String(request.getParameter("brodesc"));
	String dataauth=Util.null2String(request.getParameter("dataauth"));//得到是否跳到数据授权界面
	String oldautotypeid=Util.null2String(request.getParameter("oldautotypeid"));
	//String ismainfield=Util.null2String(request.getParameter("ismainfield"));
	String authcontorl=Util.getIntValue(request.getParameter("authcontorl"),0)+"";//用于说明该浏览按钮是否启用权限控制
	String updateTableName=Util.null2String(request.getParameter("updateTableName"));
	String w_fid= Util.getIntValue(Util.null2String(request.getParameter("workflowid")),-1)+"";//工作流的id
	String w_nodeid=Util.null2String(request.getParameter("nodeid"));//节点id
	String w_actionorder=Util.null2String(Util.getIntValue(request.getParameter("w_actionorder"),0)+"");//执行顺序
	String w_enable=Util.getIntValue(request.getParameter("w_enable"),0)+"";//是否启用(0,不启用，1，启用)	
	String w_type=Util.getIntValue(request.getParameter("w_type"),0)+"";//0-表示是浏览按钮的配置信息，1-表示是节点后动作配置时的信息，2--表示是流程创建的配置信息
	String browsertype=Util.null2String(Util.getIntValue(request.getParameter("browsertype"),226)+"");//226--单选浏览按钮,227--多选浏览按钮,228--SAP线程按钮
	int isbill= Util.getIntValue(request.getParameter("isbill"),0);//0表示老表单,1表示新表单
	if(!"".equals(formid)){
		if(Util.getIntValue(formid)<0){//修正isbill这个字段
			isbill=1;
		}
	}
	if(!"-1".equals(w_fid)){//修正isbill这个字段
		rs.execute("select isbill from workflow_base  where id='"+w_fid+"'");
		if(rs.next()){
				isbill=Util.getIntValue(rs.getString("isbill"), 0);
		}
	}
	
	//是否节点后附加操作
	String ispreoperator = Util.getIntValue(request.getParameter("ispreoperator"), -1)+"";
	//出口id
	String nodelinkid = Util.getIntValue(request.getParameter("nodelinkid"), -1)+"";
	int hidden01=Util.getIntValue(request.getParameter("hidden01"),0);//输入参数的总个数
	int hidden02=Util.getIntValue(request.getParameter("hidden02"),0);//输入结构的总个数
	int hidden03=Util.getIntValue(request.getParameter("hidden03"),0);//输出参数的总个数
	int hidden04=Util.getIntValue(request.getParameter("hidden04"),0);//输出结构的总个数
	int hidden05=Util.getIntValue(request.getParameter("hidden05"),0);//输出表的总个数
	int hidden06=Util.getIntValue(request.getParameter("hidden06"),0);//授权个数
	int hidden07=Util.getIntValue(request.getParameter("hidden07"),0);//输入表的总个数
	IntegratedSapUtil saputil=new IntegratedSapUtil();
	String isprintlog="0";
	String sql="";
	//验证一行值是否完整
	//修改时，先删再插
	String procpara="";
	//basebean.writeLog("------数据处理界面日志---"+opera);
	//basebean.writeLog("输入参数的总个数---"+hidden01);
	//basebean.writeLog("输入结构的总个数---"+hidden02);
	//basebean.writeLog("输出参数的总个数---"+hidden03);
	//basebean.writeLog("输出结构的总个数---"+hidden04);
	//basebean.writeLog("输出表的总个数-----"+hidden05);
	//basebean.writeLog("授权个数----------"+hidden06);
	//basebean.writeLog("输入表的总个数-----"+hidden07);
	
	String url=session.getAttribute("newSAP_browse")+"";
	
	
	if("save".equals(opera))
	{
		if("".equals(mark))
		{
			if(rs.executeProc("int_browermark_Insert","browser.")&&rs.next())
			{
				//得到流水号的mark
				mark=rs.getString(1);
			}
		}
		//basebean.writeLog("得到流水号"+mark);
		url=url.replace("mark=&", "mark="+mark+"&");//字段新建的时候
		if(url.indexOf("mark=")==-1){//节点后新建的时候
				url+="&mark="+mark;
		}
		//验证唯一
		if(rs.execute("select count(*) s from int_BrowserbaseInfo where mark='"+mark+"'")&&rs.next())
		{
			if(rs.getInt("s")<=0)//证明没有重复的值了
			{
					procpara = mark + Util.getSeparator(); 
					procpara += hpid + Util.getSeparator();
					procpara += poolid + Util.getSeparator();
					procpara += regservice + Util.getSeparator()+"";
					procpara += brodesc + Util.getSeparator()+"";
					procpara += authcontorl+ Util.getSeparator()+"";//添加权限控制开关
					procpara += w_fid + Util.getSeparator()+"";
					procpara += w_nodeid + Util.getSeparator()+"";
					procpara += w_actionorder + Util.getSeparator()+"";
					procpara += w_enable + Util.getSeparator()+"";
					procpara += w_type+ Util.getSeparator()+"";
					procpara += ispreoperator + Util.getSeparator()+"";
					procpara += nodelinkid+ Util.getSeparator()+"";
					procpara += ""+browsertype+ Util.getSeparator()+"";
					procpara += ""+isbill+ Util.getSeparator()+"";
					procpara +=url;
					
					if(rs.executeProc("int_BrowserbaseInfo_insert",procpara))
					{
						//basebean.writeLog("插入基本信息成功");
						rs.next();
						baseid=rs.getString(1);////sap_baseInfo表id
						for(int i=1;i<=hidden01;i++)
						{	
							//SAP取值字段
							String sap01=Util.null2String(request.getParameter("sap01_"+i)).toUpperCase()+""+"";
							//对应的oa字段
							String oa01=Util.null2String(request.getParameter("oa01_"+i)).toUpperCase()+"";
							//固定值
							String con01=Util.null2String(request.getParameter("con01_"+i));
							//是否主表字段
							String add01=Util.null2String(request.getParameter("add01_"+i));
							
							//得到OA字段的字段描述
							String oadesc=Util.null2String(request.getParameter("OAshow01_"+i));
							//得到SAP字段的字段描述
							String showname=Util.null2String(request.getParameter("show01_"+i));
							//是否显示
							String ishowField01=Util.getIntValue(Util.null2String(request.getParameter("ishowField01_"+i)),0)+"";
							//是否只读
							String isrdField01=Util.getIntValue(Util.null2String(request.getParameter("isrdField01_"+i)),0)+"";
							//显示序号
							String isorderby01=Util.null2String(request.getParameter("isorderby01_"+i));
							
							
							//判断输入的oa字段是否存在，并且得到该字段的fieldid
							String oafieldid="";
							String args[]=add01.split("_");
							if(args.length>=2)
							{
								oafieldid=args[1];
								add01=args[0];
							}
							if(!"".equals(sap01)){
								sql="insert into sap_inParameter (baseid,sapfield,oafield,constant,ordernum,ismainfield,fromfieldid,isbill,isshow,isrdonly,orderfield,oadesc,showname)"
										+"values ('"+baseid+"','"+sap01+"','"+oa01+"','"+con01+"','"+i+"','"+add01+"','"+oafieldid+"','"+isbill+"','"+ishowField01+"','"+isrdField01+"','"+isorderby01+"','"+oadesc+"','"+showname+"')";
								if("1".equals(isprintlog)){
									basebean.writeLog("插入输入参数"+sql);
								}
								boolean result=rs.execute(sql);
								if("1".equals(isprintlog)){
									basebean.writeLog("是否成功:"+result);
								}
								if(!result){
									basebean.writeLog("插入输入参数error"+sql);
								}
							}
							//w_type
							/* if(!"".equals(sap01)&&!"".equals(oa01))
							{
								procpara = baseid + Util.getSeparator(); 
							    procpara += sap01 + Util.getSeparator(); 
							    procpara += oa01 + Util.getSeparator();
							    procpara += con01+ Util.getSeparator()+"";
							    procpara += i+""+ Util.getSeparator();
							    procpara +=add01+ Util.getSeparator();//拼接是否明细表
							    procpara +=oafieldid+""+Util.getSeparator()+"";
							    procpara +=isbill;
							     
							    rs.executeProc("sap_inParameter_Insert",procpara);
							    
						    } */
						}
						for(int i=1;i<=hidden02;i++)
						{	
							//得到结构体名
							String stru=Util.null2String(request.getParameter("stru_"+i)).toUpperCase()+"";
							
							String nameid=SapUtil.InsertSap_complexname(baseid,"3",stru,"","");
							//得到该结构体里面的参数个数
							int cbox2=Util.getIntValue(request.getParameter("cbox2_"+i),0);
							if(cbox2<=0)
							{
								continue;//进入下一个结构体的循环
							}else
							{
								//循环取结构体里面的子数据
								
								for(int j=1;j<=cbox2;j++)
								{
									//SAP取值字段
									String sap02=Util.null2String(request.getParameter("sap02_"+i+"_"+j)).toUpperCase()+"";
									//对应的oa字段
									String oa02=Util.null2String(request.getParameter("oa02_"+i+"_"+j)).toUpperCase()+"";
									//固定值
									String con02=Util.null2String(request.getParameter("con02_"+i+"_"+j));
									//是否主表字段
									String add02=Util.null2String(request.getParameter("add02_"+i+"_"+j))+"";
									
									
									//得到OA字段的字段描述
									String oadesc=Util.null2String(request.getParameter("OAshow02_"+i+"_"+j));
									//得到SAP字段的字段描述
									String showname=Util.null2String(request.getParameter("show02_"+i+"_"+j));
									//是否显示
									String ishowField02=Util.getIntValue(Util.null2String(request.getParameter("ishowField02_"+i+"_"+j)),0)+"";
									//是否只读
									String isrdField02=Util.getIntValue(Util.null2String(request.getParameter("isrdField02_"+i+"_"+j)),0)+"";
									//显示序号
									String isorderby02=Util.null2String(request.getParameter("isorderby02_"+i+"_"+j));
							
									//判断输入的oa字段是否存在，并且得到该字段的fieldid
									String oafieldid="";
									String args[]=add02.split("_");
									if(args.length>=2)
									{
										oafieldid=args[1];
										add02=args[0];
									}
									 if(!"".equals(sap02)&&!"-1".equals(nameid)){
										sql="insert into sap_inStructure (baseid,nameid,sapfield,oafield,constant,ordernum,orderGroupnum,ismainfield,fromfieldid,isbill,isshow,isrdonly,orderfield,oadesc,showname)"
										+"values ('"+baseid+"','"+nameid+"','"+sap02+"','"+oa02+"','"+con02+"','"+j+"','"+i+"','"+add02+"','"+oafieldid+"','"+isbill+"','"+ishowField02+"','"+isrdField02+"','"+isorderby02+"','"+oadesc+"','"+showname+"')";
										if("1".equals(isprintlog)){
											basebean.writeLog("插入输入结构"+sql);
										}
										boolean result=rs.execute(sql);
										if("1".equals(isprintlog)){
											basebean.writeLog("是否成功:"+result);
										}
										if(!result){
											basebean.writeLog("插入输入结构error"+sql);
										}
									}
							
									/* if(!"".equals(sap02)&&!"".equals(oa02)&&!"-1".equals(nameid))
									{
										procpara = baseid + Util.getSeparator(); 
										procpara += nameid + Util.getSeparator(); 
									    procpara += sap02 + Util.getSeparator(); 
									    procpara += oa02 + Util.getSeparator();
									    procpara += con02+ Util.getSeparator();
									    procpara += j+""+ Util.getSeparator()+"";
										procpara += i+""+Util.getSeparator()+"";
										procpara +=add02+ Util.getSeparator();//拼接是否明细表
							    		procpara +=oafieldid+ Util.getSeparator()+"";
							    		procpara +=isbill;
									    rs.executeProc("sap_inStructure_Insert",procpara);
									     
								    } */
								}
							
							}
						}
						for(int i=1;i<=hidden03;i++)
						{
							//SAP取值字段
							String sap03=Util.null2String(request.getParameter("sap03_"+i)).toUpperCase()+"";
							//得到OA字段的字段描述
							String oadesc=Util.null2String(request.getParameter("OAshow03_"+i));
							//SAP显示名
							String show03=Util.null2String(request.getParameter("show03_"+i));
							//是否显示
							String dis03=Util.getIntValue(request.getParameter("dis03_"+i),0)+"";
							//需赋值的oa字段
							String setoa3=Util.null2String(request.getParameter("setoa3_"+i)).toUpperCase()+"";
							//是否主表字段
							String add03=Util.null2String(request.getParameter("add03_"+i));
							
							

							//判断输入的oa字段是否存在，并且得到该字段的fieldid
							String oafieldid="";
							String args[]=add03.split("_");
							if(args.length>=2)
							{
								oafieldid=args[1];
								add03=args[0];
							}	
							if(!"".equals(sap03)){
									 sql="insert into sap_outParameter (baseid,sapfield,showname,Display,ordernum,oafield,ismainfield,fromfieldid,isbill,oadesc)"
									+"values ('"+baseid+"','"+sap03+"','"+show03+"','"+dis03+"','"+i+"','"+setoa3+"','"+add03+"','"+oafieldid+"','"+isbill+"','"+oadesc+"')"; 
									if("1".equals(isprintlog)){
										basebean.writeLog("插入输出参数"+sql);
									}
									boolean result=rs.execute(sql);
									if("1".equals(isprintlog)){
										basebean.writeLog("是否成功:"+result);
									}
									if(!result){
										basebean.writeLog("插入输出参数error"+sql);
									}
							}
						
							
							
							/*插入数据*/
	//insert into sap_outParameter (baseid,sapfield,showname,Display,ordernum,oafield,ismainfield,fromfieldid,isbill)
	//values (baseid_1,sapfield_2,showname_3,Display_4,ordernum_5,oafield_6,ismainfield_7,fromfieldid_8,isbill_9);
	
							/* //得到该字段的fieldid
							if(!"".equals(sap03))
							{
								procpara = baseid + Util.getSeparator(); 
							    procpara += sap03 + Util.getSeparator(); 
							    procpara += show03 + Util.getSeparator();
							    procpara += dis03+ Util.getSeparator();
							    procpara += i+""+Util.getSeparator()+"";
							    procpara += setoa3+""+Util.getSeparator()+"";
							    procpara +=add03+ Util.getSeparator();//拼接是否明细表
							    procpara +=oafieldid+ Util.getSeparator()+"";
							    procpara +=isbill;
							    rs.executeProc("sap_outParameter_Insert",procpara);
							} */
						}
						

						for(int i=1;i<=hidden04;i++)
						{
							//得到结构体名
							String stru=Util.null2String(request.getParameter("outstru_"+i)).toUpperCase()+"";
							String nameid=SapUtil.InsertSap_complexname(baseid,"4",stru,"","");
							//得到该结构体里面的参数个数
							int cbox4=Util.getIntValue(request.getParameter("cbox4_"+i),0);

							if(cbox4<=0)
							{
								continue;//进入下一个结构体的循环
							}else
							{
								//循环取结构体里面的子数据
								for(int j=1;j<=cbox4;j++)
								{
									//SAP取值字段
									String sap04=Util.null2String(request.getParameter("sap04_"+i+"_"+j)).toUpperCase()+"";
									
									//得到OA字段的字段描述
									String oadesc=Util.null2String(request.getParameter("OAshow04_"+i+"_"+j));
							
									//SAP显示名
									String show04=Util.null2String(request.getParameter("show04_"+i+"_"+j));
									//是否显示
									String dis04=Util.getIntValue(request.getParameter("dis04_"+i+"_"+j),0)+"";
									//是否作为查询条件
									String con04=Util.getIntValue(request.getParameter("sea04_"+i+"_"+j),0)+"";
									//需赋值的oa字段
									String setoa4=Util.null2String(request.getParameter("setoa4_"+i+"_"+j)).toUpperCase()+"";
									//是否主表字段
									String add04=Util.null2String(request.getParameter("add04_"+i+"_"+j));
									
								
							
									//判断输入的oa字段是否存在，并且得到该字段的fieldid
									String oafieldid="";
									String args[]=add04.split("_");
									if(args.length>=2)
									{
										oafieldid=args[1];
										add04=args[0];
									}
									if(!"".equals(sap04)&&!"-1".equals(nameid))
									{
									
									/*插入数据*/
									sql="insert into sap_outStructure (baseid,nameid,sapfield,showname,Display,Search,ordernum,orderGroupnum,oafield,ismainfield,fromfieldid,isbill,oadesc)"
									+"values ('"+baseid+"','"+nameid+"','"+sap04+"','"+show04+"','"+dis04+"','"+con04+"','"+j+"','"+i+"','"+setoa4+"','"+add04+"','"+oafieldid+"','"+isbill+"','"+oadesc+"')";
									if("1".equals(isprintlog)){ 
										basebean.writeLog("插入输出结构"+sql);
									}
									boolean result=rs.execute(sql);
									if("1".equals(isprintlog)){
										basebean.writeLog("是否成功:"+result);
									}
									if(!result){
										basebean.writeLog("插入输出结构error"+sql);
									}
									  /*procpara = baseid + Util.getSeparator(); 
									    procpara += nameid + Util.getSeparator(); 
									    procpara += sap04 + Util.getSeparator(); 
									    procpara += show04 +Util.getSeparator(); 
									    procpara += dis04 +Util.getSeparator(); 
									    procpara += con04+Util.getSeparator(); 
									    procpara += j+""+ Util.getSeparator()+"";
										procpara += i+""+Util.getSeparator()+""; 
										procpara += setoa4+""+Util.getSeparator()+"";
										procpara +=add04+ Util.getSeparator();//拼接是否明细表
							   			procpara +=oafieldid+ Util.getSeparator()+"";
							   			procpara +=isbill;
									    rs.executeProc("sap_outStructure_Insert",procpara); */
								   }
								}
							}
						}
						for(int i=1;i<=hidden05;i++)
						{
							//得到表名
							String stru=Util.null2String(request.getParameter("outtable_"+i));
							//得到回写表
							String backtable5=Util.null2String(request.getParameter("backtable5_"+i));
							//得到回写操作
							String backoper5=Util.null2String(request.getParameter("backoper5_"+i));
							String nameid=SapUtil.InsertSap_complexname(baseid,"2",stru,backtable5,backoper5);
							//得到该表里面的参数个数
							int cbox5=Util.getIntValue(request.getParameter("cbox5_"+i),0);
							//得到where条件的总数据
				    		int sapson_05count=Util.getIntValue(request.getParameter("sapson_05count_"+i),0);
				    		//basebean.writeLog("where条件总个数"+sapson_05count);
					    	////basebean.writeLog("输出表里面的参数总个数"+cbox5);	
							//循环取表里面的子数据
							for(int j=1;j<=cbox5;j++)
							{
								//SAP取值字段
								String sap05=Util.null2String(request.getParameter("sap05_"+i+"_"+j)).toUpperCase()+"";
								
								
								//SAP显示名
								String show05=Util.null2String(request.getParameter("show05_"+i+"_"+j));
								//是否显示
								String dis05=Util.getIntValue(request.getParameter("dis05_"+i+"_"+j),0)+"";
								//是否作为查询条件
								String sea05=Util.getIntValue(request.getParameter("sea05_"+i+"_"+j),0)+"";
								//是否为主键
								String key05=Util.getIntValue(request.getParameter("key05_"+i+"_"+j),0)+"";
								//需赋值的oa字段
								String setoa5=Util.null2String(request.getParameter("setoa5_"+i+"_"+j)).toUpperCase()+"";
								//是否主表字段
								String add05=Util.null2String(request.getParameter("add05_"+i+"_"+j));
								
								//得到OA字段的字段描述
								String oadesc=Util.null2String(request.getParameter("OAshow05_"+i+"_"+j));
								//显示序号
								String isorderby05=Util.null2String(Util.getDoubleValue(request.getParameter("isorderby05_"+i+"_"+j))+"");
									
									
							
								//判断输入的oa字段是否存在，并且得到该字段的fieldid
								String oafieldid="";
								String args[]=add05.split("_");
								if(args.length>=2)
								{
									oafieldid=args[1];
									add05=args[0];
								}
								if(!"".equals(sap05)&&!"-1".equals(nameid))
								{
								
								   sql="insert into sap_outTable (baseid,nameid,sapfield,showname,Display,Search,Primarykey,ordernum,orderGroupnum,oafield,ismainfield,fromfieldid,isbill,oadesc,orderfield)"
									+"values ('"+baseid+"','"+nameid+"','"+sap05+"','"+show05+"','"+dis05+"','"+sea05+"','"+key05+"','"+j+"','"+i+"','"+setoa5+"','"+add05+"','"+oafieldid+"','"+isbill+"','"+oadesc+"','"+isorderby05+"')";
									if("1".equals(isprintlog)){ 
										basebean.writeLog("插入输出表"+sql);
									}
									boolean result=rs.execute(sql);
									if("1".equals(isprintlog)){
										basebean.writeLog("是否成功:"+result);
									}
									if(!result){
										basebean.writeLog("插入输出表error"+sql);
									}
									
								/*插入数据*/	
								  /* 	procpara = baseid + Util.getSeparator(); 
								    procpara += nameid + Util.getSeparator(); 
								    procpara += sap05 + Util.getSeparator();
								    procpara += show05 + Util.getSeparator();
								    procpara += dis05 + Util.getSeparator();
								    procpara += sea05 + Util.getSeparator();
								    procpara += key05+ Util.getSeparator();
								    procpara += j+""+ Util.getSeparator()+"";
									procpara += i+""+ Util.getSeparator()+"";
									procpara += setoa5+""+ Util.getSeparator()+"";
									procpara +=add05+ Util.getSeparator();//拼接是否明细表
						   			procpara +=oafieldid+ Util.getSeparator()+"";
						   			procpara +=isbill;
						   			//basebean.writeLog("插入输出表参数"+procpara);
								    boolean result=rs.executeProc("sap_outTable_Insert",procpara); */
							   }
							}
							//basebean.writeLog("处理where条件"+sapson_05count);
							//循环where条件
							
							if(sapson_05count<=0)
							{
								continue;
							}else
							{
					    		//循环存入where条件的个数
					    		for(int o=1;o<=sapson_05count;o++)
					    		{
					    				//baseid_1  integer,
										//outtablename_2   varchar2,	
										//sapfield_3    varchar2,	
									    //oafield_4    varchar2,	
									    //constant_5  varchar2,	
									    //ordernum_6  varchar2,	
									    //ismainfield_7 varchar2,	
									    //fromfieldid_8  varchar2,	
					    				 //插入输出表的where条件
							    		String input01=Util.null2String(request.getParameter("sap05son_"+i+"_"+o));//明细取值字段
										String input02=Util.null2String(request.getParameter("set05son_"+i+"_"+o));//明细赋值字段数据库字段的名字
										String input03=Util.null2String(request.getParameter("add05son_"+i+"_"+o));//明细赋值字段数据库字段的id
										String input04=Util.null2String(request.getParameter("con05son_"+i+"_"+o));//固定值
										String input05=Util.null2String(request.getParameter("show05son_"+i+"_"+o));//
										String input06=Util.null2String(request.getParameter("OAshow05son_"+i+"_"+o));//
										String ismainfield_7="";
										String fromfieldid_8="";
										if(!"".equals(input03))
										{
											ismainfield_7=input03.split("_")[0];
											fromfieldid_8=input03.split("_")[1];
										}
										
										if(!"".equals(input01))
										{
										
										/*插入数据*/
										 sql="insert into sap_outparaprocess (baseid,nameid,sapfield,oafield,constant,ordernum,ismainfield,fromfieldid,isbill,showname,oadesc)"
										+"values ('"+baseid+"','"+nameid+"','"+input01+"','"+input02+"','"+input04+"','"+0+"','"+ismainfield_7+"','"+fromfieldid_8+"','"+isbill+"','"+input05+"','"+input06+"')";
										if("1".equals(isprintlog)){ 
											basebean.writeLog("插入输出表的where条件"+sql);
										}
										boolean result=rs.execute(sql);
										if("1".equals(isprintlog)){
											basebean.writeLog("是否成功:"+result);
										}
										if(!result){
											basebean.writeLog("插入输出表的where条件error"+sql);
										}
		
										/*  	procpara = baseid + Util.getSeparator()+""; 
					    					procpara += nameid + Util.getSeparator()+""; 
					    					procpara += input01 + Util.getSeparator()+"";
					    					procpara += input02 + Util.getSeparator()+"";
					    					procpara += input04+ Util.getSeparator()+"";
					    					procpara += 0+""+Util.getSeparator()+"";
					    					procpara += ismainfield_7+""+ Util.getSeparator()+"";
					    					procpara += fromfieldid_8+""+ Util.getSeparator()+"";
					    					procpara +=isbill;
					    					//931PRODUCTIONRESOURCEDEL_INDMATKL2010595
					    					//basebean.writeLog("插入的条件"+procpara);
					    					boolean result02=rs.executeProc("sap_outparaprocess_Insert",procpara);
											basebean.writeLog("插入where条件是否成功"+result02); */
										}
					    		}
					    	}
						
						}
						for(int i=1;i<=hidden06;i++)
						{
							//授权类型
							String autotype=Util.null2String(request.getParameter("autotype_"+i));
							//授权人员或角色
							String autouserid=Util.null2String(request.getParameter("autouserorwf_"+i));
							//授权流程
							String autowfid=Util.null2String(request.getParameter("autowfid_"+i));
							//详细设置
							//String autoset=Util.null2String(request.getParameter("autodeti_"+i));
							if(!"".equals(autouserid))
							{
								procpara = baseid + Util.getSeparator(); 
							    procpara += autotype + Util.getSeparator(); 
							    if("1".equals(autotype))//人员
							    {
							    	 procpara += autouserid + Util.getSeparator(); 
							    	 procpara += "" + Util.getSeparator(); 
							    }else  if("2".equals(autotype))//角色
							    {
							    	procpara += "" + Util.getSeparator(); 
							    	procpara += autouserid + Util.getSeparator(); 
							    }
							    procpara += autowfid + Util.getSeparator();
							  //  procpara += autoset+ Util.getSeparator()+"";
							    procpara +=i;
								rs.executeProc("int_authorizeRight_Insert",procpara);	  
							}
						}
						for(int i=1;i<=hidden07;i++)
						{
							//得到表名
							String tablename=Util.null2String(request.getParameter("outtable7_"+i));
							String backtable7=Util.null2String(request.getParameter("backtable7_"+i));//得到源表
							String nameid=SapUtil.InsertSap_complexname(baseid,"1",tablename,backtable7,"");
							//得到该输入表里面的参数个数
							int cbox7=Util.getIntValue(request.getParameter("cbox7_"+i),0);
							
							//basebean.writeLog("输入表里面的参数个数"+cbox7);
							if(cbox7<=0)
							{
								continue;//进入下一个结构体的循环
							}else
							{
								//循环取结构体里面的子数据
								for(int j=1;j<=cbox7;j++)
								{
									//SAP赋值字段
									String sap07=Util.null2String(request.getParameter("sap07_"+i+"_"+j)).toUpperCase()+"";
									//oa取值字段
									String setoa7=Util.null2String(request.getParameter("setoa7_"+i+"_"+j)).toUpperCase()+"";
									//是否主表字段
									String add07=Util.null2String(request.getParameter("add07_"+i+"_"+j));
									//固定值
									String con07=Util.null2String(request.getParameter("con07_"+i+"_"+j));
									
									//得到OA字段的字段描述
								   String oadesc=Util.null2String(request.getParameter("OAshow07_"+i+"_"+j));
								   
								   	//得到SAp字段的字段描述
								   String show07=Util.null2String(request.getParameter("show07_"+i+"_"+j));
								
									//判断输入的oa字段是否存在，并且得到该字段的fieldid
									String oafieldid="";
									String args[]=add07.split("_");
									if(args.length>=2)
									{
										oafieldid=args[1];
										add07=args[0];
									}
									//得到该字段的fieldid
									//String oafieldid=saputil.checkOAField(add07, updateTableName, setoa7, formid);
									if(!"".equals(sap07)&&!"-1".equals(nameid))
									{
										sql="insert into sap_inTable (baseid,nameid,sapfield,oafield,constant,ordernum,orderGroupnum,ismainfield,fromfieldid,isbill,oadesc,showname)"
                                     	+"values ('"+baseid+"','"+nameid+"','"+sap07+"','"+setoa7+"','"+con07+"','"+j+"','"+i+"','"+add07+"','"+oafieldid+"','"+isbill+"','"+oadesc+"','"+show07+"')";
                                     	if("1".equals(isprintlog)){ 
											basebean.writeLog("插入输入表"+sql);
										}
										boolean result=rs.execute(sql);
										if("1".equals(isprintlog)){
											basebean.writeLog("是否成功:"+result);
										}
										if(!result){
											basebean.writeLog("插入输入表error"+sql);
										}
										
										
  
									  /* 	procpara = baseid + Util.getSeparator(); 
									    procpara += nameid + Util.getSeparator(); 
									    procpara += sap07 + Util.getSeparator();
									    procpara += setoa7+""+ Util.getSeparator()+"";
									    procpara += con07+""+ Util.getSeparator()+"";
									    procpara += j+""+ Util.getSeparator()+"";
										procpara += i+""+ Util.getSeparator()+"";
										procpara +=add07+ Util.getSeparator();//拼接是否明细表
							   			procpara +=oafieldid+ Util.getSeparator()+"";
							   			procpara +=isbill;
									    rs.executeProc("sap_inTable_Insert",procpara); */
								   }
								}
							
							}
						
						}
						
						flag="1";
					}
			}else
			{
				
				flag="2";
			}
		}
		if("1".equals(w_type))//需要更新附件规则表
		{
			int actionorder = Util.getIntValue(Util.null2String(request.getParameter("w_actionorder")),0);
			WorkflowActionManager workflowActionManager = new WorkflowActionManager();
			workflowActionManager.setActionid(0);
			workflowActionManager.setWorkflowid(Util.getIntValue(w_fid));
			workflowActionManager.setNodeid(Util.getIntValue(w_nodeid));
			workflowActionManager.setActionorder(actionorder);
			workflowActionManager.setNodelinkid(Util.getIntValue(nodelinkid));
			workflowActionManager.setIspreoperator(Util.getIntValue(ispreoperator));
			workflowActionManager.setActionname(mark);
			workflowActionManager.setInterfaceid(mark);
			workflowActionManager.setInterfacetype(4);
			workflowActionManager.setIsused(Util.getIntValue(w_enable));
			//workflowActionManager.setIsnewsap(1);
			workflowActionManager.doSaveWsAction();
			//检查更新流程节点前后、附加规则表
			//BaseAction baseAction = new BaseAction();
			//baseAction.checkActionOnNodeOrLink(Util.getIntValue(w_fid),Util.getIntValue(w_nodeid+""),Util.getIntValue(nodelinkid+""), Util.getIntValue(ispreoperator+""),1);
		}
	}else if("update".equals(opera))
	{
		//delete int_BrowserbaseInfo
		//delete sap_inParameter
		//delete sap_inStructure
		//delete sap_outParameter
		//delete sap_outStructure
		//delete sap_outTable
		//验证唯一
		if(rs.execute("select count(*) s from int_BrowserbaseInfo where mark='"+mark+"' and id<>'"+baseid+"'")&&rs.next())
		{
			//basebean.writeLog("修改唯一性验证---------");
			if(rs.getInt("s")<=0)//证明没有重复的值了
			{
				//basebean.writeLog("修改标识唯一---------");
				//procpara += authcontorl;//添加权限控制开关
				//procpara += w_fid + Util.getSeparator()+"";
					//procpara += w_nodeid + Util.getSeparator()+"";
					//procpara += w_actionorder + Util.getSeparator()+"";
					//procpara += w_enable + Util.getSeparator()+"";
					//procpara += w_type+"";
					//w_actionorder='"+w_actionorder+"',w_enable='"+w_enable+"',w_fid='"+w_fid+"',w_fid='"+w_fid+"',w_fid='"+w_fid+"
				rs.execute("update int_BrowserbaseInfo  set hpid='"+hpid+"',w_enable='"+w_enable+"',poolid='"+poolid+"',regservice='"+regservice+"',brodesc='"+brodesc+"',authcontorl='"+authcontorl+"' ,w_actionorder='"+w_actionorder+"',parurl='"+url+"',isbill='"+isbill+"' where id='"+baseid+"'");
				//basebean.writeLog("修改的update语句"+"update int_BrowserbaseInfo  set hpid='"+hpid+"',w_enable='"+w_enable+"',poolid='"+poolid+"',regservice='"+regservice+"',brodesc='"+brodesc+"',authcontorl='"+authcontorl+"' where id='"+baseid+"'");
				//修改操作，先删除所有的数据
				rs.execute("delete sap_inParameter where baseid='"+baseid+"'");
				rs.execute("delete sap_inStructure where baseid='"+baseid+"'");
				rs.execute("delete sap_outParameter where baseid='"+baseid+"'");
				rs.execute("delete sap_outStructure where baseid='"+baseid+"'");
				rs.execute("delete sap_outTable where baseid='"+baseid+"'");	
				rs.execute("delete sap_inTable where baseid='"+baseid+"'");	
				rs.execute("delete sap_complexname where baseid='"+baseid+"'");//删除表明或结构体的名字
				rs.execute("delete sap_outparaprocess where baseid='"+baseid+"'");//删除where条件
				//basebean.writeLog("数据删除完成一---------");
			//	rs.execute("delete int_authorizeRight where baseid='"+baseid+"'");	
				for(int i=1;i<=hidden01;i++)
				{	
					//SAP取值字段
					String sap01=Util.null2String(request.getParameter("sap01_"+i)).toUpperCase()+"";
					//对应的oa字段
					String oa01=Util.null2String(request.getParameter("oa01_"+i)).toUpperCase()+"";
					//固定值
					String con01=Util.null2String(request.getParameter("con01_"+i));
					//是否主表字段
					String add01=Util.null2String(request.getParameter("add01_"+i));
					//处理修改状态下多出来的_
					if(add01.length()==1&&"_".equals(add01)){add01="";}
					
					//得到OA字段的字段描述
					String oadesc=Util.null2String(request.getParameter("OAshow01_"+i));
					//得到SAP字段的字段描述
					String showname=Util.null2String(request.getParameter("show01_"+i));
					//是否显示
					String ishowField01=Util.getIntValue(Util.null2String(request.getParameter("ishowField01_"+i)),0)+"";
					//是否只读
					String isrdField01=Util.getIntValue(Util.null2String(request.getParameter("isrdField01_"+i)),0)+"";
					//显示序号
					String isorderby01=Util.null2String(request.getParameter("isorderby01_"+i));
							
					//判断输入的oa字段是否存在，并且得到该字段的fieldid
					String oafieldid="";
					String args[]=add01.split("_");
					if(args.length>=2)
					{
						oafieldid=args[1];
						add01=args[0];
					}
					//basebean.writeLog(oafieldid+"这一b步看看"+add01);
					if(!"".equals(sap01)){
								sql="insert into sap_inParameter (baseid,sapfield,oafield,constant,ordernum,ismainfield,fromfieldid,isbill,isshow,isrdonly,orderfield,oadesc,showname)"
										+"values ('"+baseid+"','"+sap01+"','"+oa01+"','"+con01+"','"+i+"','"+add01+"','"+oafieldid+"','"+isbill+"','"+ishowField01+"','"+isrdField01+"','"+isorderby01+"','"+oadesc+"','"+showname+"')";
								if("1".equals(isprintlog)){
									basebean.writeLog("修改输入参数"+sql);
								}
								boolean result=rs.execute(sql);
								if("1".equals(isprintlog)){
									basebean.writeLog("是否成功:"+result);
								}
								if(!result){
									basebean.writeLog("修改输入参数error"+sql);
								}
							}
					/* if(!"".equals(sap01)&&!"".equals(oa01))
					{
						procpara = baseid + Util.getSeparator(); 
					    procpara += sap01 + Util.getSeparator(); 
					    procpara += oa01 + Util.getSeparator();
					    procpara += con01+ Util.getSeparator()+"";
					    procpara += i+""+Util.getSeparator()+"";
					    procpara +=add01+ Util.getSeparator()+"";//拼接是否明细表
						procpara +=oafieldid+ Util.getSeparator()+"";
						procpara +=isbill;
					    boolean result=rs.executeProc("sap_inParameter_Insert",procpara);
				   } */
				}
				//basebean.writeLog("输入参数处理完成一---------");
				for(int i=1;i<=hidden02;i++)
				{	
					//得到结构体名
					String stru=Util.null2String(request.getParameter("stru_"+i)).toUpperCase()+"";
					String nameid=SapUtil.InsertSap_complexname(baseid,"3",stru,"","");
					//得到该结构体里面的参数个数
					int cbox2=Util.getIntValue(request.getParameter("cbox2_"+i),0);
					if(cbox2<=0)
					{
						continue;//进入下一个结构体的循环
					}else
					{
						//循环取结构体里面的子数据
						
						for(int j=1;j<=cbox2;j++)
						{
							//SAP取值字段
							String sap02=Util.null2String(request.getParameter("sap02_"+i+"_"+j)).toUpperCase()+"";
							//对应的oa字段
							String oa02=Util.null2String(request.getParameter("oa02_"+i+"_"+j)).toUpperCase()+"";
							//固定值
							String con02=Util.null2String(request.getParameter("con02_"+i+"_"+j));
							//是否主表字段
							String add02=Util.null2String(request.getParameter("add02_"+i+"_"+j));
							//处理修改状态下多出来的_
							if(add02.length()==1&&"_".equals(add02)){add02="";}
							
							//得到OA字段的字段描述
							String oadesc=Util.null2String(request.getParameter("OAshow02_"+i+"_"+j));
							//得到SAP字段的字段描述
							String showname=Util.null2String(request.getParameter("show02_"+i+"_"+j));
							//是否显示
							String ishowField02=Util.getIntValue(Util.null2String(request.getParameter("ishowField02_"+i+"_"+j)),0)+"";
							//是否只读
							String isrdField02=Util.getIntValue(Util.null2String(request.getParameter("isrdField02_"+i+"_"+j)),0)+"";
							//显示序号
							String isorderby02=Util.null2String(request.getParameter("isorderby02_"+i+"_"+j));
									
							//basebean.writeLog("add02_"+i+"_"+j+"得到输入结构的参数"+add02);
							//判断输入的oa字段是否存在，并且得到该字段的fieldid
							String oafieldid="";
							String args[]=add02.split("_");
							//basebean.writeLog("长度"+args.length);
							if(args.length>=2)
							{
								oafieldid=args[1];
								add02=args[0];
								//basebean.writeLog("oafieldid"+oafieldid);
								//basebean.writeLog("add02"+add02);
								
							}
							 if(!"".equals(sap02)&&!"-1".equals(nameid)){
										sql="insert into sap_inStructure (baseid,nameid,sapfield,oafield,constant,ordernum,orderGroupnum,ismainfield,fromfieldid,isbill,isshow,isrdonly,orderfield,oadesc,showname)"
										+"values ('"+baseid+"','"+nameid+"','"+sap02+"','"+oa02+"','"+con02+"','"+j+"','"+i+"','"+add02+"','"+oafieldid+"','"+isbill+"','"+ishowField02+"','"+isrdField02+"','"+isorderby02+"','"+oadesc+"','"+showname+"')";
										if("1".equals(isprintlog)){
											basebean.writeLog("修改输入结构"+sql);
										}
										boolean result=rs.execute(sql);
										if("1".equals(isprintlog)){
											basebean.writeLog("是否成功:"+result);
										}
										if(!result){
											basebean.writeLog("修改输入结构error"+sql);
										}
							}
							//basebean.writeLog("修改输入结构");
							/* if(!"".equals(sap02)&&!"".equals(oa02)&&!"-1".equals(nameid))
							{
								procpara = baseid + Util.getSeparator(); 
								procpara += nameid + Util.getSeparator(); 
							    procpara += sap02 + Util.getSeparator(); 
							    procpara += oa02 + Util.getSeparator();
							    procpara += con02 + Util.getSeparator();
							    procpara += j+""+ Util.getSeparator()+"";
								procpara += i+""+ Util.getSeparator()+"";
								procpara +=add02+""+Util.getSeparator();//拼接是否明细表
								procpara +=oafieldid+""+Util.getSeparator();
								procpara +=isbill;
							    boolean result=rs.executeProc("sap_inStructure_Insert",procpara);
						   } */
						}
					
					}
				}
				//basebean.writeLog("输入结构处理完成一---------");
				for(int i=1;i<=hidden03;i++)
				{
					
					//SAP取值字段
					String sap03=Util.null2String(request.getParameter("sap03_"+i)).toUpperCase()+"";
					//显示名
					String show03=Util.null2String(request.getParameter("show03_"+i));
					//是否显示
					String dis03=Util.getIntValue(request.getParameter("dis03_"+i),0)+"";
					//需赋值的oa字段
					String setoa3=Util.null2String(request.getParameter("setoa3_"+i)).toUpperCase()+"";
					//是否主表字段
					String add03=Util.null2String(request.getParameter("add03_"+i));
					//处理修改状态下多出来的_
					if(add03.length()==1&&"_".equals(add03)){add03="";}
					
					//得到OA字段的字段描述
					String oadesc=Util.null2String(request.getParameter("OAshow03_"+i));
							
					//判断输入的oa字段是否存在，并且得到该字段的fieldid
					String oafieldid="";
					String args[]=add03.split("_");
					//basebean.writeLog(args.length+"输出参数"+add03);
					if(args.length>=2)
					{
						oafieldid=args[1];
						add03=args[0];
						//basebean.writeLog("oafieldid"+oafieldid);
						//basebean.writeLog("add03"+add03);
					}	
					
					if(!"".equals(sap03)){
									 sql="insert into sap_outParameter (baseid,sapfield,showname,Display,ordernum,oafield,ismainfield,fromfieldid,isbill,oadesc)"
									+"values ('"+baseid+"','"+sap03+"','"+show03+"','"+dis03+"','"+i+"','"+setoa3+"','"+add03+"','"+oafieldid+"','"+isbill+"','"+oadesc+"')";
									if("1".equals(isprintlog)){ 
										basebean.writeLog("修改输出参数"+sql);
									}
									boolean result=rs.execute(sql);
									if("1".equals(isprintlog)){
										basebean.writeLog("是否成功:"+result);
									}
									if(!result){
										basebean.writeLog("修改输出参数error"+sql);
									}
					}	
					/* if(!"".equals(sap03))
					{
						procpara = baseid + Util.getSeparator(); 
					    procpara += sap03 + Util.getSeparator(); 
					    procpara += show03 + Util.getSeparator();
					    procpara += dis03+ Util.getSeparator();
					    procpara += i+""+Util.getSeparator()+"";
					    procpara +=setoa3+Util.getSeparator()+"";
					    procpara +=add03+ Util.getSeparator();//拼接是否明细表
						procpara +=oafieldid+ Util.getSeparator()+"";
						procpara +=isbill;
					    boolean result=rs.executeProc("sap_outParameter_Insert",procpara);
				    } */
				
				}
				//basebean.writeLog("输出参数处理完成一---------");
				for(int i=1;i<=hidden04;i++)
				{
					//得到结构体名
					String stru=Util.null2String(request.getParameter("outstru_"+i)).toUpperCase()+"";
					String nameid=SapUtil.InsertSap_complexname(baseid,"4",stru,"","");
					//得到该结构体里面的参数个数
					int cbox4=Util.getIntValue(request.getParameter("cbox4_"+i),0);
					//basebean.writeLog(nameid+"进入结"+stru+"构顺滑"+stru);
					if(cbox4<=0)
					{
						continue;//进入下一个结构体的循环
					}else
					{
						//循环取结构体里面的子数据
						for(int j=1;j<=cbox4;j++)
						{
							//SAP取值字段
							String sap04=Util.null2String(request.getParameter("sap04_"+i+"_"+j)).toUpperCase()+"";
							//显示名
							String show04=Util.null2String(request.getParameter("show04_"+i+"_"+j));
							//是否显示
							String dis04=Util.getIntValue(request.getParameter("dis04_"+i+"_"+j),0)+"";
							//是否作为查询条件
							String con04=Util.getIntValue(request.getParameter("sea04_"+i+"_"+j),0)+"";
							//需赋值的oa字段
							String setoa4=Util.null2String(request.getParameter("setoa4_"+i+"_"+j)).toUpperCase()+"";
							//是否主表字段
							String add04=Util.null2String(request.getParameter("add04_"+i+"_"+j));
							//处理修改状态下多出来的_
							if(add04.length()==1&&"_".equals(add04)){add04="";}
							
							//得到OA字段的字段描述
							String oadesc=Util.null2String(request.getParameter("OAshow04_"+i+"_"+j));
									
							//判断输入的oa字段是否存在，并且得到该字段的fieldid
							String oafieldid="";
							String args[]=add04.split("_");
							if(args.length>=2)
							{
								oafieldid=args[1];
								add04=args[0];
							}
							
							if(!"".equals(sap04)&&!"-1".equals(nameid))
							{
									
									/*插入数据*/
									sql="insert into sap_outStructure (baseid,nameid,sapfield,showname,Display,Search,ordernum,orderGroupnum,oafield,ismainfield,fromfieldid,isbill,oadesc)"
									+"values ('"+baseid+"','"+nameid+"','"+sap04+"','"+show04+"','"+dis04+"','"+con04+"','"+j+"','"+i+"','"+setoa4+"','"+add04+"','"+oafieldid+"','"+isbill+"','"+oadesc+"')";
									if("1".equals(isprintlog)){ 
										basebean.writeLog("修改输出结构"+sql);
									}
									boolean result=rs.execute(sql);
									if("1".equals(isprintlog)){
										basebean.writeLog("是否成功:"+result);
									}
									if(!result){
										basebean.writeLog("修改输出结构error"+sql);
									}
							}
							/* if(!"".equals(sap04)&&!"-1".equals(nameid))
							{
							  	procpara = baseid + Util.getSeparator(); 
							    procpara += nameid + Util.getSeparator(); 
							    procpara += sap04 + Util.getSeparator(); 
							    procpara += show04 +Util.getSeparator(); 
							    procpara += dis04 +Util.getSeparator(); 
							    procpara += con04 +Util.getSeparator(); 
							    procpara += j+""+ Util.getSeparator()+"";
								procpara += i+""+ Util.getSeparator()+"";
								procpara += setoa4+ Util.getSeparator()+"";
								procpara +=add04+ Util.getSeparator();//拼接是否明细表
								procpara +=oafieldid+ Util.getSeparator()+"";
								procpara +=isbill;
							    boolean result=rs.executeProc("sap_outStructure_Insert",procpara);
						   } */
						}
					}
				}
				//basebean.writeLog("输出结构处理完成一---------");
				for(int i=1;i<=hidden05;i++)
				{
					//得到表名
					String stru=Util.null2String(request.getParameter("outtable_"+i)).toUpperCase()+"";
					//得到回写表
					String backtable5=Util.null2String(request.getParameter("backtable5_"+i));
					//得到回写操作
					String backoper5=Util.null2String(request.getParameter("backoper5_"+i));
					String nameid=SapUtil.InsertSap_complexname(baseid,"2",stru,backtable5,backoper5);
							
					//得到该结构体里面的参数个数
					int cbox5=Util.getIntValue(request.getParameter("cbox5_"+i),0);
					//得到where条件的总数据
		    		int sapson_05count=Util.getIntValue(request.getParameter("sapson_05count_"+i),0);
		    		//basebean.writeLog("where条件总个数"+sapson_05count);
					
						//循环取结构体里面的子数据
						for(int j=1;j<=cbox5;j++)
						{
							//SAP取值字段
							String sap05=Util.null2String(request.getParameter("sap05_"+i+"_"+j)).toUpperCase()+"";
							//显示名
							String show05=Util.null2String(request.getParameter("show05_"+i+"_"+j));
							//是否显示
							String dis05=Util.getIntValue(request.getParameter("dis05_"+i+"_"+j),0)+"";
							//是否作为查询条件
							String sea05=Util.getIntValue(request.getParameter("sea05_"+i+"_"+j),0)+"";
							//是否为主键
							String key05=Util.getIntValue(request.getParameter("key05_"+i+"_"+j),0)+"";
							//是否主表字段
							String add05=Util.null2String(request.getParameter("add05_"+i+"_"+j));
							//处理修改状态下多出来的_
							if(add05.length()==1&&"_".equals(add05)){add05="";}
							//需赋值的oa字段
							String setoa5=Util.null2String(request.getParameter("setoa5_"+i+"_"+j)).toUpperCase()+"";
							//得到OA字段的字段描述
							String oadesc=Util.null2String(request.getParameter("OAshow05_"+i+"_"+j));
							//显示序号
							String isorderby05=Util.null2String(Util.getDoubleValue(request.getParameter("isorderby05_"+i+"_"+j),0)+"");
							
							basebean.writeLog("序号是啥"+isorderby05);
							
							//判断输入的oa字段是否存在，并且得到该字段的fieldid
							String oafieldid="";
							String args[]=add05.split("_");
							if(args.length>=2)
							{
								oafieldid=args[1];
								add05=args[0];
							}
							
							if(!"".equals(sap05)&&!"-1".equals(nameid))
							{
								
								   sql="insert into sap_outTable (baseid,nameid,sapfield,showname,Display,Search,Primarykey,ordernum,orderGroupnum,oafield,ismainfield,fromfieldid,isbill,oadesc,orderfield)"
									+"values ('"+baseid+"','"+nameid+"','"+sap05+"','"+show05+"','"+dis05+"','"+sea05+"','"+key05+"','"+j+"','"+i+"','"+setoa5+"','"+add05+"','"+oafieldid+"','"+isbill+"','"+oadesc+"','"+isorderby05+"')";
									if("1".equals(isprintlog)){ 
										basebean.writeLog("修改输出表"+sql);
									}
									boolean result=rs.execute(sql);
									if("1".equals(isprintlog)){
										basebean.writeLog("是否成功:"+result);
									}
									if(!result){
										basebean.writeLog("修改输出表error"+sql);
									}
						   }
							/* if(!"".equals(sap05)&&!"-1".equals(nameid))
							{
							  	procpara = baseid + Util.getSeparator(); 
							    procpara += nameid + Util.getSeparator(); 
							    procpara += sap05 + Util.getSeparator();
							    procpara += show05 + Util.getSeparator();
							    procpara += dis05 + Util.getSeparator();
							    procpara += sea05 + Util.getSeparator();
							    procpara += key05+ Util.getSeparator();
							    procpara += j+""+ Util.getSeparator()+"";
								procpara += i+""+ Util.getSeparator()+"";
								procpara += setoa5+ Util.getSeparator()+"";
								procpara +=add05+ Util.getSeparator();//拼接是否明细表
								procpara +=oafieldid+ Util.getSeparator()+"";
								procpara +=isbill;
							    boolean  result=rs.executeProc("sap_outTable_Insert",procpara);
						   } */
						}
					
					
							//循环where条件
							if(sapson_05count<=0)
							{
								continue;
							}else
							{
					    		//循环存入where条件的个数
					    		for(int o=1;o<=sapson_05count;o++)
					    		{
					    				//baseid_1  integer,
										//outtablename_2   varchar2,	
										//sapfield_3    varchar2,	
									    //oafield_4    varchar2,	
									    //constant_5  varchar2,	
									    //ordernum_6  varchar2,	
									    //ismainfield_7 varchar2,	
									    //fromfieldid_8  varchar2,	
					    				 //插入输出表的where条件
							    		String input01=Util.null2String(request.getParameter("sap05son_"+i+"_"+o));//明细取值字段
										String input02=Util.null2String(request.getParameter("set05son_"+i+"_"+o));//明细赋值字段数据库字段的名字
										String input03=Util.null2String(request.getParameter("add05son_"+i+"_"+o));//明细赋值字段数据库字段的id
										String input04=Util.null2String(request.getParameter("con05son_"+i+"_"+o));//固定值
										String input05=Util.null2String(request.getParameter("show05son_"+i+"_"+o));//
										String input06=Util.null2String(request.getParameter("OAshow05son_"+i+"_"+o));//
										String ismainfield_7="";
										String fromfieldid_8="";
										if(!"".equals(input03))
										{
											if(input03.split("_").length>=2){
												ismainfield_7=input03.split("_")[0];
												fromfieldid_8=input03.split("_")[1];												
											}
										}
										
										if(!"".equals(input01))
										{
											/*插入数据*/
											 sql="insert into sap_outparaprocess (baseid,nameid,sapfield,oafield,constant,ordernum,ismainfield,fromfieldid,isbill,showname,oadesc)"
											+"values ('"+baseid+"','"+nameid+"','"+input01+"','"+input02+"','"+input04+"','"+0+"','"+ismainfield_7+"','"+fromfieldid_8+"','"+isbill+"','"+input05+"','"+input06+"')";
											if("1".equals(isprintlog)){ 
												basebean.writeLog("修改输出表的where条件"+sql);
											}
											boolean result=rs.execute(sql);
											if("1".equals(isprintlog)){
												basebean.writeLog("是否成功:"+result);
											}
											if(!result){
												basebean.writeLog("修改输出表的where条件error"+sql);
											}
										}
									/* 	procpara = baseid + Util.getSeparator()+""; 
				    					procpara += nameid + Util.getSeparator()+""; 
				    					procpara += input01 + Util.getSeparator()+"";
				    					procpara += input02 + Util.getSeparator()+"";
				    					procpara += input04+ Util.getSeparator()+"";
				    					procpara += 0+""+Util.getSeparator()+"";
				    					procpara += ismainfield_7+""+ Util.getSeparator()+"";
				    					procpara += fromfieldid_8+""+ Util.getSeparator()+"";
				    					procpara +=isbill;
				    					//931PRODUCTIONRESOURCEDEL_INDMATKL2010595
				    					//basebean.writeLog("插入的条件"+procpara);
				    					boolean result02=rs.executeProc("sap_outparaprocess_Insert",procpara); */
				    					
										//basebean.writeLog("插入是否成功"+result02);
					    		}
					    	}
						
				}
						for(int i=1;i<=hidden06;i++)
						{
							//授权类型
							String autotype=Util.null2String(request.getParameter("autotype_"+i));
							//授权人员或角色
							String autouserid=Util.null2String(request.getParameter("autouserorwf_"+i));
							//授权流程
							String autowfid=Util.null2String(request.getParameter("autowfid_"+i));
							//int_authorizeRight表的id
							String autoset=Util.null2String(request.getParameter("autodeti_"+i));
							if("".equals(autoset))//插入
							{
								if(!"".equals(autouserid))
								{
									procpara = baseid + Util.getSeparator(); 
								    procpara += autotype + Util.getSeparator(); 
								    if("1".equals(autotype))//人员
								    {
								    	 procpara += autouserid + Util.getSeparator(); 
								    	 procpara += "" + Util.getSeparator(); 
								    }else  if("2".equals(autotype))//角色
								    {
								    	procpara += "" + Util.getSeparator(); 
								    	procpara += autouserid + Util.getSeparator(); 
								    }
								    procpara += autowfid + Util.getSeparator();
								    procpara +=i;
									rs.executeProc("int_authorizeRight_insert",procpara);	  
								}
								
							}else//修改
							{
								if(!"".equals(autouserid))
								{
									oldautotypeid=oldautotypeid.replace(","+autoset+",",",");//排除修改的数据id
									procpara = autoset + Util.getSeparator(); 
									procpara += baseid + Util.getSeparator(); 
								    procpara += autotype + Util.getSeparator(); 
								    if("1".equals(autotype))//人员
								    {
								    	 procpara += autouserid + Util.getSeparator(); 
								    	 procpara += "" + Util.getSeparator(); 
								    }else  if("2".equals(autotype))//角色
								    {
								    	procpara += "" + Util.getSeparator(); 
								    	procpara += autouserid + Util.getSeparator(); 
								    }
								    procpara += autowfid + Util.getSeparator();
								    procpara +=i;
									rs.executeProc("int_authorizeRight_update",procpara);	  
								}
							}
					}
					if(!"".equals(oldautotypeid)&&oldautotypeid.length()>0)//说明有些项需要删除
					{
						String oldautotypeids[]=oldautotypeid.split(",");
						for(int h=0;h<oldautotypeids.length;h++)
						{
							if(!"".equals(oldautotypeids[h]))
							{
								rs.execute("delete int_authorizeRight where id='"+oldautotypeids[h]+"'");
								rs.execute("delete int_authorizeDetaRight where rightid='"+oldautotypeids[h]+"'");
							}
						}
					}
					
					for(int i=1;i<=hidden07;i++)
						{
							//得到表名
							String tablename=Util.null2String(request.getParameter("outtable7_"+i));
							String backtable7=Util.null2String(request.getParameter("backtable7_"+i));//得到源表
							String nameid=SapUtil.InsertSap_complexname(baseid,"1",tablename,backtable7,"");
							//得到该结构体里面的参数个数
							int cbox7=Util.getIntValue(request.getParameter("cbox7_"+i),0);
							if(cbox7<=0)
							{
								continue;//进入下一个结构体的循环
							}else
							{
								//循环取结构体里面的子数据
								for(int j=1;j<=cbox7;j++)
								{
								
									//SAP赋值字段
									String sap07=Util.null2String(request.getParameter("sap07_"+i+"_"+j)).toUpperCase()+"";
									//oa取值字段
									String setoa7=Util.null2String(request.getParameter("setoa7_"+i+"_"+j)).toUpperCase()+"";
									//是否主表字段
									String add07=Util.null2String(request.getParameter("add07_"+i+"_"+j));
									//处理修改状态下多出来的_
									if(add07.length()==1&&"_".equals(add07)){add07="";}
									//固定值
									String con07=Util.null2String(request.getParameter("con07_"+i+"_"+j));
									//得到OA字段的字段描述
								   String oadesc=Util.null2String(request.getParameter("OAshow07_"+i+"_"+j));
								   
								   	//得到SAp字段的字段描述
								   String show07=Util.null2String(request.getParameter("show07_"+i+"_"+j));
								   
									//判断输入的oa字段是否存在，并且得到该字段的fieldid
									String oafieldid="";
									String args[]=add07.split("_");
									if(args.length>=2)
									{
										oafieldid=args[1];
										add07=args[0];
									}

									if(!"".equals(sap07)&&!"-1".equals(nameid))
									{
									
									   sql="insert into sap_inTable (baseid,nameid,sapfield,oafield,constant,ordernum,orderGroupnum,ismainfield,fromfieldid,isbill,oadesc,showname)"
                                     	+"values ('"+baseid+"','"+nameid+"','"+sap07+"','"+setoa7+"','"+con07+"','"+j+"','"+i+"','"+add07+"','"+oafieldid+"','"+isbill+"','"+oadesc+"','"+show07+"')";
                                     	if("1".equals(isprintlog)){ 
											basebean.writeLog("修改输入表"+sql);
										}
										boolean result=rs.execute(sql);
										if("1".equals(isprintlog)){
											basebean.writeLog("是否成功:"+result);
										}
										if(!result){
											basebean.writeLog("修改输入表error"+sql);
										}
  
									  	/* procpara = baseid + Util.getSeparator(); 
									    procpara += nameid + Util.getSeparator(); 
									    procpara += sap07 + Util.getSeparator();
									    procpara += setoa7+""+ Util.getSeparator()+"";
									    procpara += con07+""+ Util.getSeparator()+"";
									    procpara += j+""+ Util.getSeparator()+"";
										procpara += i+""+ Util.getSeparator()+"";
										procpara +=add07+ Util.getSeparator();//拼接是否明细表
							   			procpara +=oafieldid+ Util.getSeparator()+"";
							   			procpara +=isbill;
									    rs.executeProc("sap_inTable_Insert",procpara); */
								   }
								}
							
							}
						}
											
				flag="1";
			}else
			{
				flag="2";
			}
		}
		//add by wshen
		if("1".equals(w_type))//需要更新附件规则表
		{
			WorkflowActionManager workflowActionManager = new WorkflowActionManager();
			int actionid = Util.getIntValue(Util.null2String(request.getParameter("actionid")),0);
			int actionorder = Util.getIntValue(Util.null2String(request.getParameter("w_actionorder")),0);
			workflowActionManager.setActionid(actionid);
			workflowActionManager.setWorkflowid(Util.getIntValue(w_fid));
			workflowActionManager.setNodeid(Util.getIntValue(w_nodeid));
			workflowActionManager.setActionorder(actionorder);
			workflowActionManager.setNodelinkid(Util.getIntValue(nodelinkid));
			workflowActionManager.setIspreoperator(Util.getIntValue(ispreoperator));
			workflowActionManager.setActionname(mark);
			workflowActionManager.setInterfaceid(mark);
			workflowActionManager.setInterfacetype(4);
			workflowActionManager.setIsused(Util.getIntValue(w_enable));
			//workflowActionManager.setIsnewsap(1);
			workflowActionManager.doSaveWsAction();
		}
	}
	/*
	if("1".equals(w_type))//需要更新附件规则表
	{
		  WorkflowActionManager workflowActionManager = new WorkflowActionManager();
	        workflowActionManager.setActionid(0);
			workflowActionManager.setWorkflowid(Util.getIntValue(w_fid));
			workflowActionManager.setNodeid(Util.getIntValue(w_nodeid));
			workflowActionManager.setActionorder(0);
			workflowActionManager.setNodelinkid(Util.getIntValue(nodelinkid));
			workflowActionManager.setIspreoperator(Util.getIntValue(ispreoperator));
			workflowActionManager.setActionname(mark);
			workflowActionManager.setInterfaceid(mark);
			workflowActionManager.setInterfacetype(4);
			workflowActionManager.setIsused(Util.getIntValue(w_enable));
			workflowActionManager.setIsnewsap(1);
			workflowActionManager.doSaveWsAction();
		//检查更新流程节点前后、附加规则表
		//BaseAction baseAction = new BaseAction();
		//baseAction.checkActionOnNodeOrLink(Util.getIntValue(w_fid),Util.getIntValue(w_nodeid+""),Util.getIntValue(nodelinkid+""), Util.getIntValue(ispreoperator+""),1);
	}
	*/
%>
<body></body>
<script type="text/javascript">
	
	
	if("<%=flag%>"=="1")
	{
		window.parent.parent.alert("<%=SystemEnv.getHtmlLabelName(30648 ,user.getLanguage()) %>"+"!");
		
		<%
			if("1".equals(w_type))//0-表示是浏览按钮的配置信息，1-表示是节点后动作配置时的信息,2---表示线程扫描SAP触发OA流程
			{
			//刷新节点后动作界面
		%>
			window.parent.parent.closeWindow("");
			//dialogArguments.reloadDMLAtion();//编辑的时候，刷新节点后操作界面
		<%
			}else//0-表示是浏览按钮的配置信息，1-表示是节点后动作配置时的信息,2---表示线程扫描SAP触发OA流程
			{
		%>
				window.parent.parent.document.getElementById("hidediv").style.display="none";
				if("<%=dataauth%>"=="2")
				{
					//表示数据授权--(选中数据授权的界面)
					//window.parent.document.getElementById("dataauthli").style.display="";
					//window.parent.document.getElementById("dataauthli").click();
					
					var utlstr="/integration/browse/integrationBrowerMain.jsp";
					utlstr+="?browsertype=<%=browsertype%>&mark=<%=mark%>&formid=<%=formid%>&updateTableName=<%=updateTableName%>&dataauth=<%=dataauth%>&isbill=<%=isbill%>";
					window.parent.parent.changeurl(utlstr);
				}else
				{
					//window.parent.parent.returnValue='<%=mark%>';
					window.parent.parent.closeWindow('<%=mark%>');
				}
		<%
			}
		%>
	}else if(<%=flag%>=="2")
	{
		//操作失败
		window.parent.parent.alert("<%=SystemEnv.getHtmlLabelName(30651 ,user.getLanguage()) %>"+"!");
		window.parent.parent.document.getElementById("hidediv").style.display="none";
		window.parent.parent.document.getElementById("hidedivmsg").style.display="none";
		
	}
	else
	{
		window.parent.parent.alert("<%=SystemEnv.getHtmlLabelName(30651 ,user.getLanguage()) %>"+"!");
		window.parent.parent.document.getElementById("hidediv").style.display="none";
		window.parent.parent.document.getElementById("hidedivmsg").style.display="none";
	}
</script>