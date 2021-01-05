
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSetTrans" class="weaver.conn.RecordSetTrans" scope="page" />
<jsp:useBean id="sowf" class="weaver.synergy.SynergyOperatWorkflow" scope="page"/>
<jsp:useBean id="sod" class="weaver.synergy.SynergyOperatDoc" scope="page"/>
<jsp:useBean id="sc" class="weaver.synergy.SynergyComInfo" scope="page"/>
<jsp:useBean id="hec" class="weaver.homepage.cominfo.HomepageElementCominfo" scope="page"/>
<jsp:useBean id="spc" class="weaver.synergy.SynergyParamsComInfo" scope="page"/>

<%
	String hpid = Util.null2String(request.getParameter("hpid"));
	int isdel = Util.getIntValue(request.getParameter("isdel"),-1);
	String stype = Util.null2String(request.getParameter("whichtype"));
	String businessids = Util.null2String(request.getParameter("returnstr"));
	String spagetype = Util.null2String(request.getParameter("spagetype"));
	try{
		RecordSetTrans.setAutoCommit(false);
		if(businessids.equals("")) return;
		
		String[] ids= Util.TokenizerString2(businessids,",");
		for(int i = 0; i < ids.length; i++)
		{
			//删除原有设置
			if(isdel == 1)
			{
				RecordSetTrans.executeSql("delete from synergy_base where wfid="+ids[i]);
				RecordSetTrans.executeSql("select max(id) from synergy_base");
				RecordSetTrans.first();
				int sameid = (RecordSetTrans.getInt(1) + 1);
				if(stype.equals("wf"))
					sowf.insertBase4wf(RecordSetTrans,sameid,ids[i]);
				else if(stype.equals("doc"))
					sod.insertBase4Doc(RecordSetTrans,sameid,ids[i]);
				
				int newhpid = 0;
				if(spagetype.equals("operat"))
					newhpid = -(sameid + 1);
				else 
					newhpid = -sameid;
				String sql3= "update synergy_base set haslayout='1' where id="+Math.abs(newhpid);
				RecordSetTrans.executeSql(sql3);
				RecordSetTrans.executeSql("select * from hpLayout where hpid="+hpid);
				RecordSetTrans.first();
				String sql2 = "insert into hpLayout values("+newhpid+",'"+
						RecordSetTrans.getString("layoutbaseid")+"','"+
						RecordSetTrans.getString("areaflag")+"','"+
						RecordSetTrans.getString("areasize")+"','"+
						RecordSetTrans.getString("areaElements")+"','"+
						RecordSetTrans.getString("userid")+"','"+
						RecordSetTrans.getString("usertype")+"')";
				RecordSetTrans.executeSql(sql2);
				
				String[] areaElments = Util.TokenizerString2(RecordSetTrans.getString("areaElements"),",");
				String newAreaElments = "";
				for(int j=0; j<areaElments.length;j++)
				{
					RecordSetTrans.executeSql("insert into hpElement "+
							" select title,logo,islocked,strsqlwhere,ebaseid,isSysElement "+
							" ,"+newhpid+",isFixationRowHeight,background,styleid,height, "+
							" marginTop,marginBottom,marginRight,marginLeft,shareuser, "+
							" scrolltype,newstemplate,isRemind,fromModule,isuse from hpElement "
							+" where id="+areaElments[j]);
					RecordSetTrans.executeSql(" select max(id) from hpElement ");
					RecordSetTrans.first();
					int newEid = Util.getIntValue(RecordSetTrans.getString(1));
					RecordSetTrans.executeSql("insert into hpElementSettingDetail "+
							" select userid,usertype,'"+newEid+"',perpage,linkmode,showfield, "+
							" sharelevel,"+newhpid+",currentTab "+
							" from hpElementSettingDetail where eid="+areaElments[j]);
					RecordSetTrans.executeSql("insert into hpcurrenttab "+
							" select "+newEid+",currenttab,userid,usertype "+
							" from hpcurrenttab where eid="+areaElments[j]);
					//流程的特定表
					RecordSetTrans.executeSql("insert into hpsetting_wfcenter select "+newEid+", "+
							" viewtype,typeids,flowids,nodeids,isExclude,tabid,tabTitle,showCopy,completeflag "+
							" from hpsetting_wfcenter where eid="+areaElments[j]);
					RecordSetTrans.executeSql("insert into workflowcentersettingdetail "+
							" select "+newEid+",tabid,type,content,srcfrom from workflowcentersettingdetail where eid="+areaElments[j]);
					//文档特定表
					RecordSetTrans.executeSql("insert into hpNewsTabInfo "+
							" select "+newEid+",tabid,tabTitle,sqlWhere from hpNewsTabInfo where eid="+areaElments[j]);
					newAreaElments += newEid+",";
					RecordSetTrans.executeSql("select max(id) maxexpid from sypara_expressions");
					RecordSetTrans.first();
					int maxExpid = Util.getIntValue(RecordSetTrans.getString("maxexpid"));
					
					//以下是协同区的设置数据copy
					RecordSetTrans.executeSql("select (select max(id) from sypara_variablebase) maxvarbaseid, "+
							" t1.name,t1.type,t1.browsertype,t1.spid,t1.formid,t1.isbill, "+
							" t2.id expbaseid, t2.relation,t2.valueType,t2.value,t2.valueName,t2.valueVariableid,t2.systemParam, "+
							" (select max(id) from sypara_expressionbase) maxexpbaseid,t3.id expid "+
							" from sypara_variablebase t1,sypara_expressionbase t2,sypara_expressions t3 "+
							" where t1.id = t2.variableID and t2.id = t3.expbaseid and t1.eid="+areaElments[j] +
							" order by t1.id");
					
					int k = 0;
					int l = 0;
					Map<String,String> expidsmap = new HashMap<String,String>();
					while(RecordSetTrans.next())
					{
						int nextvarbaseid = (Util.getIntValue(RecordSetTrans.getString("maxvarbaseid"))+1)+k;
						int src_expid = Util.getIntValue(RecordSetTrans.getString("expid"));
						
						String sql4insert_variablebase = "insert into sypara_variablebase (id,name,type,browsertype,eid,spid,formid,isbill) values ("+
								" '"+ nextvarbaseid +"',"+
								" '"+RecordSetTrans.getString("name")+"',"+
								" '"+RecordSetTrans.getString("type")+"',"+
								" '"+RecordSetTrans.getString("browsertype")+"',"+
								" '"+newEid+"',"+
								" '"+RecordSetTrans.getString("spid")+"',"+
								" '"+RecordSetTrans.getString("formid")+"',"+
								" '"+RecordSetTrans.getString("isbill")+"')";
						RecordSetTrans.executeSql(sql4insert_variablebase);
						
						String sql4insert_expressionbase = "insert into sypara_expressionbase (id,eid,variableID,relation,valuetype,value,valuename,valuevariableid,systemparam) values ("+
								" (select max(id) from sypara_expressionbase)+1,"+
								" '"+newEid+"',"+
								" '"+nextvarbaseid +"',"+
								" '"+RecordSetTrans.getString("relation")+"',"+
								" '"+RecordSetTrans.getString("valuetype")+"',"+
								" '"+RecordSetTrans.getString("value")+"',"+
								" '"+RecordSetTrans.getString("valuename")+"',"+
								" '"+RecordSetTrans.getString("valuevariableid")+"',"+
								" '"+RecordSetTrans.getString("systemparam")+"')";
						RecordSetTrans.executeSql(sql4insert_expressionbase);
						int maxexpbaseid = (Util.getIntValue(RecordSetTrans.getString("maxexpbaseid"))+1)+k;
						String sql4insert_expression = "insert into sypara_expressions (id,eid,relation,expbaseid) values( "+
								" (select max(id) from sypara_expressions)+1, "+
								" '"+newEid+"','-1','"+maxexpbaseid+"')";
						RecordSetTrans.executeSql(sql4insert_expression);
						
						expidsmap.put(src_expid+"",((maxExpid+1)+l)+"");
						k++;
						l++;
					}
					
					RecordSetTrans.executeSql(" select * from sypara_expressions where relation!=-1 and eid="+areaElments[j]+" order by id");
					while(RecordSetTrans.next())
					{
						String src_expids = RecordSetTrans.getString("expids");
						String src_expid = RecordSetTrans.getString("id");
						String dest_expids = "";
						if(src_expids.indexOf(",") != -1)
						{
							String[] __src_expids = Util.TokenizerString2(src_expids,",");
							for(int x=0;x<__src_expids.length;x++)
							{
								if(x== (__src_expids.length - 1))
									dest_expids+= expidsmap.get(__src_expids[x]);
								else
								dest_expids+= expidsmap.get(__src_expids[x])+",";
							}
						}else
							dest_expids = expidsmap.get(src_expids).toString();
						String sql5 = "insert into sypara_expressions (id,eid,relation,expids) values( "+
								" (select max(id) from sypara_expressions)+1,"+
								" '"+newEid+"',"+
								" '"+RecordSetTrans.getString("relation")+"',"+
								" '"+dest_expids+"')";
						RecordSetTrans.execute(sql5);
						expidsmap.put(src_expid,((maxExpid+1)+l)+"");
						l++;
					}
				}
				RecordSetTrans.execute("update hpLayout set areaElements='"+newAreaElments+"' where hpid="+newhpid);
			}else
			{
				
			}
		}
		RecordSetTrans.commit();
		sc.reloadSynergyInfoCache();
		hec.reloadHpElementCache();
		spc.reloadSynergyInfoCache();
	}catch(Exception e)
	{
		RecordSetTrans.rollback();
		e.printStackTrace();
	}
	
%>
