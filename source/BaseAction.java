package weaver.interfaces.workflow.action;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import weaver.interfaces.datasource.DataSource;
import weaver.interfaces.workflow.action.Action;
import weaver.soa.workflow.request.RequestInfo;

import weaver.conn.*;


/**
 * User: 
 * Date: 
 * Time: 
 */
public class BaseAction implements Action {
    private Log log = LogFactory.getLog(BaseAction.class.getName());
    private DataSource ds;

    public DataSource getDs() {
        return ds;
    }

    public void setDs(DataSource ds) {
        this.ds = ds;
    }

    public Log getLog() {
        return log;
    }

    public void setLog(Log log) {
        this.log = log;
    }

    public String execute(RequestInfo request) {
        log.info("do action on request:"+request.getRequestid());
                
        /**
        //import weaver.conn.RecordSet;不带事物
        //import weaver.conn.RecordSetTrans;带事物          
        //注意：rsts只是用来访问 workflow_requestbase、workflow_currentoperator,而且是访问当前流程的记录,如下面的示例
        //其它操作都用RecordSet rs = new RecordSet()进行
        //可以先判断rsts是否为null,如果为null,则所有操作都可以用RecordSet rs = new RecordSet()进行        
        weaver.conn.RecordSetTrans rsts = request.getRsTrans();
        if(rsts!=null){
	        try{
	        	rsts.executeSql("select * from workflow_requestbase where requestid = " + request.getRequestid());        
	        	while(rsts.next()){
	        		log.info("do action on request: " + rsts.getString(1) + " @ " + rsts.getString(2));
	        	}
	        }catch(Exception e){
	        	log.info("do action on request: " + e);
	        }
        }else{
        	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
        	rs.executeSql("select * from workflow_requestbase where requestid = " + request.getRequestid());        
	        while(rs.next()){
	        	log.info("do action on request: " + rs.getString(1) + " @ " + rs.getString(2));
	        }
        }
        **/
        
        return Action.SUCCESS;
    }
}
