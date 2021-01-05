
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
public class WriteLogAction implements Action {
    private Log log = LogFactory.getLog(WriteLogAction.class.getName());
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
        //import weaver.conn.RecordSet;��������
        //import weaver.conn.RecordSetTrans;������          
        //ע�⣺rstsֻ���������� workflow_requestbase��workflow_currentoperator,�����Ƿ��ʵ�ǰ���̵ļ�¼,�������ʾ��
        //������������RecordSet rs = new RecordSet()����
        //�������ж�rsts�Ƿ�Ϊnull,���Ϊnull,�����в�����������RecordSet rs = new RecordSet()����        
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