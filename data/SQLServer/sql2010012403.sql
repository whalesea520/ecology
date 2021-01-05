CREATE INDEX checkor_rb_index ON worktask_requestbase (checkor)
GO

CREATE INDEX planstartdate_rb_index ON worktask_requestbase (planstartdate)
GO
CREATE INDEX planenddate_rb_index ON worktask_requestbase (planenddate)
GO
CREATE INDEX taskid_rb_index ON worktask_requestbase (taskid)
GO

CREATE INDEX taskid_tf_index ON worktask_taskfield (taskid)
GO
CREATE INDEX fieldid_tf_index ON worktask_taskfield (fieldid)
GO

CREATE INDEX taskid_tl_index ON worktask_tasklist (taskid)
GO
CREATE INDEX fieldid_tl_index ON worktask_tasklist (fieldid)
GO

CREATE INDEX taskid_rss_index ON requestshareset (taskid)
GO
CREATE INDEX requestid_rss_index ON requestshareset (requestid)
GO

CREATE INDEX userid_wto_index ON worktask_operator (userid)
GO
CREATE INDEX requestid_wto_index ON worktask_operator (requestid)
GO

CREATE INDEX operatorid_bl_index ON worktask_backlog (operatorid)
GO
CREATE INDEX type_bl_index ON worktask_operator (type)
GO
