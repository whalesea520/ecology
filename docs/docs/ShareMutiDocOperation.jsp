
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="DocViewer" class="weaver.docs.docs.DocViewer" scope="page"/>
<%
    char flag=Util.getSeparator();
    String ProcPara = "";

    String sharedocids = Util.null2String(request.getParameter("sharedocids"));
    int rownum = Util.getIntValue(request.getParameter("rownum"),0);

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

    //StringTokenizer stk = new StringTokenizer(sharedocids,";");
    StringTokenizer stk = new StringTokenizer(sharedocids,",");
    while(stk.hasMoreTokens()){
        String docid = stk.nextToken();
        if(!docid.trim().equals("")){

            /*
            RecordSet.executeProc("DocShare_SelectByDocID",""+docid);
            while(RecordSet.next()){
                RecordSet2.executeProc("DocShare_Delete",RecordSet.getString("id"));
            }
            */

            for(int i=0; i<rownum; i++){
                String sharetype = request.getParameter("sharetype_"+i);
                if(sharetype != null){
                    String relatedshareid = Util.null2String(request.getParameter("relatedshareid_"+i));
                    String rolelevel = Util.null2String(request.getParameter("rolelevel_"+i));
                    String seclevel = Util.null2String(request.getParameter("seclevel_"+i));
                    String sharelevel = Util.null2String(request.getParameter("sharelevel_"+i));
                    String downloadlevel = Util.null2o(request.getParameter("downloadlevel_"+i));
                    
                    //System.out.println("docid="+docid+";relatedshareid:"+relatedshareid+";rolelevel:"+rolelevel+";seclevel:"+seclevel+";sharelevel:"+sharelevel+";downloadlevel:"+downloadlevel);

                    //if(sharetype.equals("2")) subcompanyid = relatedshareid ;
                    //if(sharetype.equals("3")) departmentid = relatedshareid ;
                    if(sharetype.equals("4")) roleid = relatedshareid ;
                    if(sharetype.equals("5")) foralluser = "1" ;
                    
                    if(sharetype.equals("1") || sharetype.equals("2") || sharetype.equals("3") || sharetype.equals("6")) {
                        ArrayList userIdList=Util.TokenizerString(relatedshareid,",");
						String tempUserId="0";
                        String temporgGroupId="0";
                        String tempSubCompId="0";
                        String tempDeptId="0";
                        for(int k=0;k<userIdList.size();k++){
                            if(sharetype.equals("1")) tempUserId = (String)userIdList.get(k) ;
                            if(sharetype.equals("2")) tempSubCompId = (String)userIdList.get(k) ;
                            if(sharetype.equals("3")) tempDeptId = (String)userIdList.get(k) ;
                            if(sharetype.equals("6")) temporgGroupId = (String)userIdList.get(k) ;
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
							if( Util.getIntValue(sharelevel,0)>1){
							downloadlevel="1";
							}
                            ProcPara += flag+downloadlevel;//"1";//默认可下载
                            
                            //RecordSet.executeProc("DocShare_IFromDocSecCategory",ProcPara);
                            RecordSet.executeProc("DocShare_IFromDocSecCat_G",ProcPara);
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
						if( Util.getIntValue(sharelevel,0)>1){
							downloadlevel="1";
							}
                        ProcPara += flag+downloadlevel ;
    
                      	//RecordSet.executeProc("DocShare_IFromDocSecCategory",ProcPara);
                        RecordSet.executeProc("DocShare_IFromDocSecCat_G",ProcPara);
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
    String urlType = Util.null2String(request.getParameter("urlType"));
    response.sendRedirect("ShareMutiDocTo.jsp?isclose=1	");
%>
