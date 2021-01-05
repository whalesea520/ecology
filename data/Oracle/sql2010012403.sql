CREATE INDEX checkor_rb_index ON worktask_requestbase (checkor)
/

CREATE INDEX planstartdate_rb_index ON worktask_requestbase (planstartdate)
/
CREATE INDEX planenddate_rb_index ON worktask_requestbase (planenddate)
/
CREATE INDEX taskid_rb_index ON worktask_requestbase (taskid)
/

CREATE INDEX taskid_tf_index ON worktask_taskfield (taskid)
/
CREATE INDEX fieldid_tf_index ON worktask_taskfield (fieldid)
/

CREATE INDEX taskid_tl_index ON worktask_tasklist (taskid)
/
CREATE INDEX fieldid_tl_index ON worktask_tasklist (fieldid)
/

CREATE INDEX taskid_rss_index ON requestshareset (taskid)
/
CREATE INDEX requestid_rss_index ON requestshareset (requestid)
/

CREATE INDEX userid_wto_index ON worktask_operator (userid)
/
CREATE INDEX requestid_wto_index ON worktask_operator (requestid)
/

CREATE INDEX operatorid_bl_index ON worktask_backlog (operatorid)
/
CREATE INDEX type_bl_index ON worktask_operator (type)
/
