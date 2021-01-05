	<%@ page import="weaver.general.Util" %>
	<%@ page import="java.util.*" %> 
	<jsp:useBean id="rsl" class="weaver.conn.RecordSet" scope="page" />
	<jsp:useBean id="rsb" class="weaver.conn.RecordSet" scope="page" />
	<jsp:useBean id="rss" class="weaver.conn.RecordSet" scope="page" />
	<%!
	public void showTarget (String id,String split,boolean isLight,String mainid)
	{
	String mid="";
	String pid="";
	String sname="";
	String iid="";
	String per="";
	rsl.execute("select * from HrmPerformanceCheckDetail where parentId="+id);	
	while (rsl.next())
	{
	split=split+"  ";
	if(isLight = !isLight)
	{ 
	out.print("<TR CLASS="+DataLight+">");
	}
	else
	{
	out.print("<TR CLASS="+DataDark+">");
	}
	out.print("<TD>");
	out.print(split);
	iid=rsl.getString("id");
	pid=rsl.getString("parentId");
	per=rsl.getString("percent_n");
	sname=Util.toScreen(rsl.getString("targetName"),user.getLanguage());
	out.print("<a href=TargetDetailEdit.jsp?id="+iid+"&mainid='+mainid+'&parentId="+pid+">"+sname+"</a></td>");
	out.print("<TD>"+per+"</TD>");
	out.print("<TD>");
    rsb.execute("select * from HrmPerformanceCheckStd where checkDetailId="+rsl.getString("id"));
        String stdName="";
        int j=1;
        Vector vs=new Vector();
        while(rsb.next())
        {
        vs.add(rsb.getString("stdName"));
        //stdName=stdName.equals("")? (String.valueOf(j)+"  "+rsb.getString("stdName")):(String.valueOf(j)+"  "+stdName+"<br>"+rsb.getString("stdName"));
        j++;
        }
        for (j=0;j<vs.size();j++)
        {
        out.println((j+1)+" "+vs.get(j)+"<br>");
       
        }
	
     out.print("</TD>");
	 out.print("<TD><a href=targetDetailAdd.jsp?id="+mainid+"&parentId="+iid+">"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+"</a>");
	 out.print("  <a  onclick='deldetail("+iid+","+mainid+ ")' href='#' >");
	 out.prin(SystemEnv.getHtmlLabelName(91,user.getLanguage()));
	 out.print("</TD>");

	 out.print("</TR>");
	 rss.execute("select * from HrmPerformanceCheckDetail where parentId="+iid);
	 if (rss.next()) showTarget(iid,split,isLight,mainid);
	}

	} 
	%>