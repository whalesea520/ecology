
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="DocViewer" class="weaver.docs.docs.DocViewer" scope="page"/>
<jsp:useBean id="docdetailLog" class="weaver.docs.DocDetailLog" scope="page"/>


<%@ page import="java.text.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.docs.docs.ShareManageDocOperation" %>
<%
   ShareManageDocOperation manager = new ShareManageDocOperation();
    char flag=Util.getSeparator();
    String ProcPara = "";
	String defaultshare =  Util.null2String(request.getParameter("defaultshare"));
    String nondefaultshare =  Util.null2String(request.getParameter("nondefaultshare"));
    String otherversion =  Util.null2String(request.getParameter("otherversion"));
	manager.setUserid(user.getUID());
	
	String sharedocids = Util.null2String(request.getParameter("sharedocids"));
	if("1".equals(otherversion)){
		if(sharedocids.endsWith(",")) sharedocids=sharedocids.substring(0,sharedocids.length()-1);
		RecordSet.executeSql("select distinct id from DocDetail where doceditionid in (select doceditionid from DocDetail where doceditionid>0 and id in ("+sharedocids+")) or id in ("+sharedocids+")");
		sharedocids="";
		while(RecordSet.next()){
			sharedocids +=","+RecordSet.getString(1);
		}
	}
    int rownum = Util.getIntValue(request.getParameter("weaverTableRows"),0);

    String userid = "0" ;
    String departmentid = "0" ;
    String subcompanyid="0";
    String roleid = "0" ; 
    String foralluser = "0" ;
    int sharecrm=0;

    String subcompanyid1="";
    int seccategoryid=0;
    int departmentid2=0;
    int ownerid=0;
	String docsubject="";
	String doccreaterid="";

	

    //StringTokenizer stk = new StringTokenizer(sharedocids,";");
    StringTokenizer stk = new StringTokenizer(sharedocids,",");
    while(stk.hasMoreTokens()){
        String docid = stk.nextToken();
        if(!docid.trim().equals("")){
			RecordSet3.execute("select docsubject,doccreaterid from DocDetail where id="+docid);
			if(RecordSet3.next()){
			docsubject=RecordSet3.getString("docsubject");
			doccreaterid=RecordSet3.getString("doccreaterid");
			
			}
			                         if(nondefaultshare.equals("1")){
	    		    						manager.deleteNonDefault(docid);
	    		    					}
	    		    					if(defaultshare.equals("1")){
	    		    						manager.deleteDefault(docid);
	    		    					}
	    		    					
	    		    				     		   							    		    				
	    		    				    DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	    			    				String operatedate = df.format(new Date());
	    			    				df = new SimpleDateFormat("hh:mm:ss");
	    			    				String operatetime = df.format(new Date());	
										
										try{
	    			    				docdetailLog.writeDetailLog(Integer.parseInt(docid),docsubject,"23",user.getUID(),user.getLogintype(),request.getRemoteAddr(),Integer.parseInt(doccreaterid));
    				    		       }catch (Exception ex){
									     
									   }

            /*
            RecordSet.executeProc("DocShare_SelectByDocID",""+docid);
            while(RecordSet.next()){
                RecordSet2.executeProc("DocShare_Delete",RecordSet.getString("id"));
            }
            */

            for(int i=0; i<rownum; i++){
                String sharetype = request.getParameter("sharetype_"+i);
				String joblevel = request.getParameter("joblevel_"+i);
				String jobdepartment = request.getParameter("jobdepartment_"+i);
				String jobsubcompany = request.getParameter("jobsubcompany_"+i);
				if(jobdepartment.equals("")){
				  jobdepartment="0";
				}
				if(jobsubcompany.equals("")){
				  jobsubcompany="0";
				}
                if(sharetype != null){
                   
				
                    String relatedshareid = Util.null2String(request.getParameter("relatedshareid_"+i));
                    String rolelevel = Util.null2String(request.getParameter("rolelevel_"+i));
                    String seclevel = Util.null2String(request.getParameter("seclevel_"+i));
                    String sharelevel = Util.null2String(request.getParameter("sharelevel_"+i));
                    String downloadlevel = Util.null2o(request.getParameter("downloadlevel_"+i));
					if(Integer.parseInt(sharelevel)>1){
							  downloadlevel="1";
							}
		            String includesub =Util.null2String(request.getParameter("includesub_"+i));
	                String custype = Util.null2String(request.getParameter("custype_"+i));
	                String seclevelmax =Util.null2String(request.getParameter("seclevelmax_"+i));
		
                    //System.out.println("docid="+docid+";relatedshareid:"+relatedshareid+";rolelevel:"+rolelevel+";seclevel:"+seclevel+";sharelevel:"+sharelevel+";downloadlevel:"+downloadlevel);

                    //if(sharetype.equals("2")) subcompanyid = relatedshareid ;
                    //if(sharetype.equals("3")) departmentid = relatedshareid ;
					if(sharetype.equals("-1")) sharetype = relatedshareid ;
					
                    if(sharetype.equals("4")) roleid = relatedshareid ;
                    if(sharetype.equals("5")) foralluser = "1" ;

                    
                    if(sharetype.equals("1") || sharetype.equals("2") || sharetype.equals("3") || sharetype.equals("6")|| sharetype.equals("10") ){
                        ArrayList userIdList=Util.TokenizerString(relatedshareid,",");
						String tempUserId="0";
                        String temporgGroupId="0";
                        String tempSubCompId="0";
                        String tempDeptId="0";
						String tempJobId="0";
                        for(int k=0;k<userIdList.size();k++){
                            if(sharetype.equals("1")) tempUserId = (String)userIdList.get(k) ;
                            if(sharetype.equals("2")) tempSubCompId = (String)userIdList.get(k) ;
                            if(sharetype.equals("3")) tempDeptId = (String)userIdList.get(k) ;
                            if(sharetype.equals("6")) temporgGroupId = (String)userIdList.get(k) ;
							if(sharetype.equals("10")) tempJobId = (String)userIdList.get(k) ;
                            ProcPara = docid;
                            ProcPara += flag+sharetype;
                            ProcPara += flag+seclevel;
                            ProcPara += flag+rolelevel;
                            ProcPara += flag+sharelevel;
                            ProcPara += flag+tempUserId;
                            ProcPara += flag+tempSubCompId;
                            ProcPara += flag+tempDeptId;
                            ProcPara += flag+roleid;
                            ProcPara += flag+foralluser;
                            ProcPara += flag+"0" ;
                            ProcPara += flag+temporgGroupId;
                            ProcPara += flag+downloadlevel;//"1";//默认可下载
                            
                            //RecordSet.executeProc("DocShare_IFromDocSecCategory",ProcPara);
                            RecordSet.executeProc("DocShare_IFromDocSecCat_G",ProcPara);
						if(RecordSet.next()){
		                int shareid = RecordSet.getInt(1);
		                RecordSet.executeSql("update docshare set includesub='"+includesub+"',seclevelmax='"+seclevelmax+"',joblevel='"+joblevel+"',jobdepartment='"+jobdepartment+"',jobsubcompany='"+jobsubcompany+"',jobids='"+tempJobId+"' where id=" + shareid);
						}
                       }
                    } else {                    
                        ProcPara = docid;
                        ProcPara += flag+sharetype;
                        ProcPara += flag+seclevel;
                        ProcPara += flag+rolelevel;
                        ProcPara += flag+sharelevel;
                        ProcPara += flag+userid;
                        ProcPara += flag+subcompanyid;
                        ProcPara += flag+departmentid;
                        ProcPara += flag+roleid;
                        ProcPara += flag+foralluser;
                        ProcPara += flag+"0";
                        ProcPara += flag+"0";
                        ProcPara += flag+downloadlevel ;
    
                      	//RecordSet.executeProc("DocShare_IFromDocSecCategory",ProcPara);
                        RecordSet.executeProc("DocShare_IFromDocSecCat_G",ProcPara);
						if(RecordSet.next()){
						int shareid = RecordSet.getInt(1);
		                RecordSet.executeSql("update docshare set includesub='"+includesub+"',seclevelmax='"+seclevelmax+"' where id=" + shareid);
						}
                    }

                    int userid2=user.getUID();
                    DocManager.resetParameter();
                    DocManager.setId(Util.getIntValue(docid));
                    DocManager.getDocInfoById();

                    seccategoryid=DocManager.getSeccategory();
                    departmentid2=DocManager.getDocdepartmentid();
                    ownerid=DocManager.getOwnerid();

                    subcompanyid1="";
                    RecordSet.executeSql("select subcompanyid1 from HrmResource where id="+userid2+"");
                    if(RecordSet.next())
                    {
                        subcompanyid1=RecordSet.getString("subcompanyid1");
                    }

                    DocViewer.setDocShareByDoc(docid);

                }
            }
        }
    }
    response.sendRedirect("ShareManageDocTo.jsp?isclose=1&sharedocids="+sharedocids);
    //response.sendRedirect("/docs/search/DocCommonContent.jsp?urlType=11&ishow=false&from=shareManageDoc");
%>
