CREATE TABLE ofUser (
  username              NVARCHAR(64)    NOT NULL,
  plainPassword         NVARCHAR(32),
  encryptedPassword     NVARCHAR(255),
  name                  NVARCHAR(100),
  email                 VARCHAR(100),
  creationDate          CHAR(15)        NOT NULL,
  modificationDate      CHAR(15)        NOT NULL,
  CONSTRAINT ofUser_pk PRIMARY KEY (username)
)
GO
CREATE INDEX ofUser_cDate_idx ON ofUser (creationDate ASC)
GO

CREATE TABLE ofUserProp (
  username              NVARCHAR(64)    NOT NULL,
  name                  NVARCHAR(100)   NOT NULL,
  propValue             NVARCHAR(2000)  NOT NULL,
  CONSTRAINT ofUserProp_pk PRIMARY KEY (username, name)
)
GO

CREATE TABLE ofUserFlag (
  username              NVARCHAR(64)    NOT NULL,
  name                  NVARCHAR(100)   NOT NULL,
  startTime             CHAR(15),
  endTime               CHAR(15),
  CONSTRAINT ofUserFlag_pk PRIMARY KEY (username, name)
)
GO
CREATE INDEX ofUserFlag_sTime_idx ON ofUserFlag (startTime ASC)
GO
CREATE INDEX ofUserFlag_eTime_idx ON ofUserFlag (endTime ASC)
GO


CREATE TABLE ofPrivate (
  username              NVARCHAR(64)    NOT NULL,
  name                  NVARCHAR(100)   NOT NULL,
  namespace             NVARCHAR(200)   NOT NULL,
  privateData           NTEXT           NOT NULL,
  CONSTRAINT ofPrivate_pk PRIMARY KEY (username, name, namespace)
)
GO

CREATE TABLE ofOffline (
  username              NVARCHAR(64)    NOT NULL,
  messageID             INTEGER         NOT NULL,
  creationDate          CHAR(15)        NOT NULL,
  messageSize           INTEGER         NOT NULL,
  stanza                NTEXT           NOT NULL,
  CONSTRAINT ofOffline_pk PRIMARY KEY (username, messageID)
)
GO

CREATE TABLE ofPresence (
  username              NVARCHAR(64)     NOT NULL,
  offlinePresence       NTEXT,
  offlineDate           CHAR(15)     NOT NULL,
  CONSTRAINT ofPresence_pk PRIMARY KEY (username)
)
GO

CREATE TABLE ofRoster (
  rosterID              INTEGER         NOT NULL,
  username              NVARCHAR(64)    NOT NULL,
  jid                   NVARCHAR(1024)  NOT NULL,
  sub                   INTEGER         NOT NULL,
  ask                   INTEGER         NOT NULL,
  recv                  INTEGER         NOT NULL,
  nick                  NVARCHAR(255),
  CONSTRAINT ofRoster_pk PRIMARY KEY (rosterID)
)
GO
CREATE INDEX ofRoster_username_idx ON ofRoster (username ASC)
GO
CREATE INDEX ofRoster_jid_idx ON ofRoster (jid ASC)
GO


CREATE TABLE ofRosterGroups (
  rosterID              INTEGER         NOT NULL,
  rank                  INTEGER         NOT NULL,
  groupName             NVARCHAR(255)   NOT NULL,
  CONSTRAINT ofRosterGroups_pk PRIMARY KEY (rosterID, rank)
)
GO
CREATE INDEX ofRosterGroups_rosterid_idx ON ofRosterGroups (rosterID ASC)
GO
ALTER TABLE ofRosterGroups ADD CONSTRAINT ofRosterGroups_rosterID_fk FOREIGN KEY (rosterID) REFERENCES ofRoster
GO


CREATE TABLE ofVCard (
  username              NVARCHAR(64)    NOT NULL,
  vcard                 NTEXT           NOT NULL,
  CONSTRAINT ofVCard_pk PRIMARY KEY (username)
)
GO

CREATE TABLE ofGroup (
  groupName             NVARCHAR(50)   NOT NULL,
  description           NVARCHAR(255),
  CONSTRAINT ofGroup_pk PRIMARY KEY (groupName)
)
GO

CREATE TABLE ofGroupProp (
   groupName            NVARCHAR(50)   NOT NULL,
   name                 NVARCHAR(100)   NOT NULL,
   propValue            NVARCHAR(2000)  NOT NULL,
   CONSTRAINT ofGroupProp_pk PRIMARY KEY (groupName, name)
)
GO

CREATE TABLE ofGroupUser (
  groupName             NVARCHAR(50)    NOT NULL,
  username              NVARCHAR(100)   NOT NULL,
  administrator         INTEGER         NOT NULL,
  CONSTRAINT ofGroupUser_pk PRIMARY KEY (groupName, username, administrator)
)
GO

CREATE TABLE ofID (
  idType                INTEGER         NOT NULL,
  id                    INTEGER         NOT NULL,
  CONSTRAINT ofID_pk PRIMARY KEY (idType)
)
GO

CREATE TABLE ofProperty (
  name        NVARCHAR(100) NOT NULL,
  propValue   NTEXT NOT NULL,
  CONSTRAINT ofProperty_pk PRIMARY KEY (name)
)
GO

CREATE TABLE ofVersion (
  name     NVARCHAR(50) NOT NULL,
  version  INTEGER  NOT NULL,
  CONSTRAINT ofVersion_pk PRIMARY KEY (name)
)
GO
CREATE TABLE ofExtComponentConf (
  subdomain             NVARCHAR(255)    NOT NULL,
  wildcard              INT              NOT NULL,
  secret                NVARCHAR(255),
  permission            NVARCHAR(10)     NOT NULL,
  CONSTRAINT ofExtComponentConf_pk PRIMARY KEY (subdomain)
)
GO
CREATE TABLE ofRemoteServerConf (
  xmppDomain            NVARCHAR(255)    NOT NULL,
  remotePort            INTEGER,
  permission            NVARCHAR(10)     NOT NULL,
  CONSTRAINT ofRemoteServerConf_pk PRIMARY KEY (xmppDomain)
)
GO
CREATE TABLE ofPrivacyList (
  username              NVARCHAR(64)    NOT NULL,
  name                  NVARCHAR(100)   NOT NULL,
  isDefault             INT             NOT NULL,
  list                  NTEXT           NOT NULL,
  CONSTRAINT ofPrivacyList_pk PRIMARY KEY (username, name)
)
GO
CREATE INDEX ofPrivacyList_default_idx ON ofPrivacyList (username, isDefault)
GO

CREATE TABLE ofSASLAuthorized (
  username        NVARCHAR(64)     NOT NULL,
  principal       NVARCHAR(2000)   NOT NULL,
  CONSTRAINT ofSASLAuthorized_pk PRIMARY KEY (username, principal)
)
GO
CREATE TABLE ofSecurityAuditLog (
  msgID                 INTEGER         NOT NULL,
  username              NVARCHAR(64)    NOT NULL,
  entryStamp            BIGINT          NOT NULL,
  summary               NVARCHAR(255)   NOT NULL,
  node                  NVARCHAR(255)   NOT NULL,
  details               NTEXT,
  CONSTRAINT ofSecurityAuditLog_pk PRIMARY KEY (msgID)
)
GO
CREATE INDEX ofSecurityAuditLog_tstamp_idx ON ofSecurityAuditLog (entryStamp)
GO
CREATE INDEX ofSecurityAuditLog_uname_idx ON ofSecurityAuditLog (username)
GO
CREATE TABLE ofMucService (
  serviceID           INT           NOT NULL,
  subdomain           NVARCHAR(255) NOT NULL,
  description         NVARCHAR(255),
  isHidden            INT           NOT NULL,
  CONSTRAINT ofMucService_pk PRIMARY KEY (subdomain)
)
GO
CREATE INDEX ofMucService_serviceid_idx ON ofMucService(serviceID)
GO

CREATE TABLE ofMucServiceProp (
  serviceID           INT           NOT NULL,
  name                NVARCHAR(100) NOT NULL,
  propValue           NVARCHAR(2000) NOT NULL,
  CONSTRAINT ofMucServiceProp_pk PRIMARY KEY (serviceID, name)
)
GO
CREATE TABLE ofMucRoom (
  serviceID           INT           NOT NULL,
  roomID              INT           NOT NULL,
  creationDate        CHAR(15)      NOT NULL,
  modificationDate    CHAR(15)      NOT NULL,
  name                NVARCHAR(50)  NOT NULL,
  naturalName         NVARCHAR(255) NOT NULL,
  description         NVARCHAR(255),
  lockedDate          CHAR(15)      NOT NULL,
  emptyDate           CHAR(15)      NULL,
  canChangeSubject    INT           NOT NULL,
  maxUsers            INT           NOT NULL,
  publicRoom          INT           NOT NULL,
  moderated           INT           NOT NULL,
  membersOnly         INT           NOT NULL,
  canInvite           INT           NOT NULL,
  roomPassword        NVARCHAR(50)  NULL,
  canDiscoverJID      INT           NOT NULL,
  logEnabled          INT           NOT NULL,
  subject             NVARCHAR(100) NULL,
  rolesToBroadcast    INT           NOT NULL,
  useReservedNick     INT           NOT NULL,
  canChangeNick       INT           NOT NULL,
  canRegister         INT           NOT NULL,
  CONSTRAINT ofMucRoom_pk PRIMARY KEY (serviceID, name)
)
GO
CREATE INDEX ofMucRoom_roomid_idx on ofMucRoom(roomID)
GO
CREATE INDEX ofMucRoom_serviceid_idx on ofMucRoom(serviceID)
GO

CREATE TABLE ofMucRoomProp (
  roomID                INT             NOT NULL,
  name                  NVARCHAR(100)   NOT NULL,
  propValue             NVARCHAR(2000)  NOT NULL,
  CONSTRAINT ofMucRoomProp_pk PRIMARY KEY (roomID, name)
)
GO

CREATE TABLE ofMucAffiliation (
  roomID              INT            NOT NULL,
  jid                 NVARCHAR(424) NOT NULL,
  affiliation         INT            NOT NULL,
  CONSTRAINT ofMucAffiliation_pk PRIMARY KEY (roomID,jid)
)
GO

CREATE TABLE ofMucMember (
  roomID              INT            NOT NULL,
  jid                 NVARCHAR(424)  NOT NULL,
  nickname            NVARCHAR(255)  NULL,
  firstName           NVARCHAR(100)  NULL,
  lastName            NVARCHAR(100)  NULL,
  url                 NVARCHAR(100)  NULL,
  email               NVARCHAR(100)  NULL,
  faqentry            NVARCHAR(100)  NULL,
  CONSTRAINT ofMucMember_pk PRIMARY KEY (roomID,jid)
)
GO

CREATE TABLE ofMucConversationLog (
  roomID              INT            NOT NULL,
  sender              NVARCHAR(1024) NOT NULL,
  nickname            NVARCHAR(255)  NULL,
  logTime             CHAR(15)       NOT NULL,
  subject             NVARCHAR(255)  NULL,
  body                NTEXT          NULL
)
GO
CREATE INDEX ofMucConversationLog_time_idx ON ofMucConversationLog (logTime)
GO

CREATE TABLE ofPubsubNode (
  serviceID           NVARCHAR(100)  NOT NULL,
  nodeID              NVARCHAR(100)  NOT NULL,
  leaf                INT            NOT NULL,
  creationDate        CHAR(15)       NOT NULL,
  modificationDate    CHAR(15)       NOT NULL,
  parent              NVARCHAR(100)  NULL,
  deliverPayloads     INT            NOT NULL,
  maxPayloadSize      INT            NULL,
  persistItems        INT            NULL,
  maxItems            INT            NULL,
  notifyConfigChanges INT            NOT NULL,
  notifyDelete        INT            NOT NULL,
  notifyRetract       INT            NOT NULL,
  presenceBased       INT            NOT NULL,
  sendItemSubscribe   INT            NOT NULL,
  publisherModel      NVARCHAR(15)   NOT NULL,
  subscriptionEnabled INT            NOT NULL,
  configSubscription  INT            NOT NULL,
  accessModel         NVARCHAR(10)   NOT NULL,
  payloadType         NVARCHAR(100)  NULL,
  bodyXSLT            NVARCHAR(100)  NULL,
  dataformXSLT        NVARCHAR(100)  NULL,
  creator             NVARCHAR(255)  NOT NULL,
  description         NVARCHAR(255)  NULL,
  language            NVARCHAR(255)  NULL,
  name                NVARCHAR(50)   NULL,
  replyPolicy         NVARCHAR(15)   NULL,
  associationPolicy   NVARCHAR(15)   NULL,
  maxLeafNodes        INT            NULL,
  CONSTRAINT ofPubsubNode_pk PRIMARY KEY (serviceID, nodeID)
)
GO
CREATE TABLE ofPubsubNodeJIDs (
  serviceID           NVARCHAR(100)  NOT NULL,
  nodeID              NVARCHAR(100)  NOT NULL,
  jid                 NVARCHAR(250) NOT NULL,
  associationType     NVARCHAR(20)   NOT NULL,
  CONSTRAINT ofPubsubNodeJIDs_pk PRIMARY KEY (serviceID, nodeID, jid)
)
GO
CREATE TABLE ofPubsubNodeGroups (
  serviceID           NVARCHAR(100)  NOT NULL,
  nodeID              NVARCHAR(100)  NOT NULL,
  rosterGroup         NVARCHAR(100)  NOT NULL
)
GO
CREATE INDEX ofPubsubNodeGroups_idx ON ofPubsubNodeGroups (serviceID, nodeID)
GO
CREATE TABLE ofPubsubAffiliation (
  serviceID           NVARCHAR(100)  NOT NULL,
  nodeID              NVARCHAR(100)  NOT NULL,
  jid                 NVARCHAR(250)  NOT NULL,
  affiliation         NVARCHAR(10)   NOT NULL,
  CONSTRAINT ofPubsubAffiliation_pk PRIMARY KEY (serviceID, nodeID, jid)
)
GO
CREATE TABLE ofPubsubItem (
  serviceID           NVARCHAR(100)  NOT NULL,
  nodeID              NVARCHAR(100)  NOT NULL,
  id                  NVARCHAR(100)  NOT NULL,
  jid                 NVARCHAR(1024) NOT NULL,
  creationDate        CHAR(15)       NOT NULL,
  payload             NTEXT          NULL,
  CONSTRAINT ofPubsubItem_pk PRIMARY KEY (serviceID, nodeID, id)
)
GO
CREATE TABLE ofPubsubSubscription (
  serviceID           NVARCHAR(100)  NOT NULL,
  nodeID              NVARCHAR(100)  NOT NULL,
  id                  NVARCHAR(100)  NOT NULL,
  jid                 NVARCHAR(1024) NOT NULL,
  owner               NVARCHAR(1024) NOT NULL,
  state               NVARCHAR(15)   NOT NULL,
  deliver             INT            NOT NULL,
  digest              INT            NOT NULL,
  digest_frequency    INT            NOT NULL,
  expire              CHAR(15)       NULL,
  includeBody         INT            NOT NULL,
  showValues          NVARCHAR(30)   NOT NULL,
  subscriptionType    NVARCHAR(10)   NOT NULL,
  subscriptionDepth   INT            NOT NULL,
  keyword             NVARCHAR(200)  NULL,
  CONSTRAINT ofPubsubSubscription_pk PRIMARY KEY (serviceID, nodeID, id)
)
GO
CREATE TABLE ofPubsubDefaultConf (
  serviceID           NVARCHAR(100) NOT NULL,
  leaf                INT           NOT NULL,
  deliverPayloads     INT           NOT NULL,
  maxPayloadSize      INT           NOT NULL,
  persistItems        INT           NOT NULL,
  maxItems            INT           NOT NULL,
  notifyConfigChanges INT           NOT NULL,
  notifyDelete        INT           NOT NULL,
  notifyRetract       INT           NOT NULL,
  presenceBased       INT           NOT NULL,
  sendItemSubscribe   INT           NOT NULL,
  publisherModel      NVARCHAR(15)  NOT NULL,
  subscriptionEnabled INT           NOT NULL,
  accessModel         NVARCHAR(10)  NOT NULL,
  language            NVARCHAR(255) NULL,
  replyPolicy         NVARCHAR(15)  NULL,
  associationPolicy   NVARCHAR(15)  NOT NULL,
  maxLeafNodes        INT           NOT NULL,
  CONSTRAINT ofPubsubDefaultConf_pk PRIMARY KEY (serviceID, leaf)
)
GO
INSERT INTO ofID (idType, id) VALUES (18, 1)
GO
INSERT INTO ofID (idType, id) VALUES (19, 1)
GO
INSERT INTO ofID (idType, id) VALUES (23, 1)
GO
INSERT INTO ofID (idType, id) VALUES (26, 1)
GO
INSERT INTO ofVersion (name, version) VALUES ('openfire', 20)
GO
INSERT INTO ofUser (username, plainPassword, name, email, creationDate, modificationDate) VALUES ('admin', 'admin', 'Administrator', 'admin@example.com', '0', '0')
GO
INSERT INTO ofMucService (serviceID, subdomain, isHidden) VALUES (1, 'conference', 0)
GO

delete from ofproperty
GO
insert into ofproperty (name,propvalue) values('admin.authorizedJIDs','zdp@222.66.55.182')
GO
insert into ofproperty (name,propvalue) values('cache.GatewayRegistrationCache.maxLifetime','-1')
GO
insert into ofproperty (name,propvalue) values('cache.GatewayRegistrationCache.min','-1')
GO
insert into ofproperty (name,propvalue) values('cache.GatewayRegistrationCache.size','-1')
GO
insert into ofproperty (name,propvalue) values('cache.GatewayRegistrationCache.type','optimistic')
GO
insert into ofproperty (name,propvalue) values('cache.GatewaySessionLocationCache.maxLifetime','-1')
GO
insert into ofproperty (name,propvalue) values('cache.GatewaySessionLocationCache.min','-1')
GO
insert into ofproperty (name,propvalue) values('cache.GatewaySessionLocationCache.size','-1')
GO
insert into ofproperty (name,propvalue) values('cache.GatewaySessionLocationCache.type','optimistic')
GO
insert into ofproperty (name,propvalue) values('httpbind.enabled','true')
GO
insert into ofproperty (name,propvalue) values('jdbcAuthProvider.passwordSQL','SELECT lower(password) as password FROM hrmresource WHERE loginid=?')
GO
insert into ofproperty (name,propvalue) values('jdbcAuthProvider.passwordType','md5')
GO
insert into ofproperty (name,propvalue) values('jdbcGroupProvider.allGroupsSQL','SELECT groupName FROM HrmMessagerGroup')
GO
insert into ofproperty (name,propvalue) values('jdbcGroupProvider.descriptionSQL','SELECT groupdesc FROM HrmMessagerGroup WHERE groupName=?')
GO
insert into ofproperty (name,propvalue) values('jdbcGroupProvider.groupCountSQL','SELECT count(*) FROM HrmMessagerGroup')
GO
insert into ofproperty (name,propvalue) values('jdbcGroupProvider.loadAdminsSQL','SELECT userloginid from HrmMessagerGroupUsers WHERE groupName=? AND isAdmin=''Y''')
GO
insert into ofproperty (name,propvalue) values('jdbcGroupProvider.loadMembersSQL','SELECT userloginid from HrmMessagerGroupUsers WHERE groupName=? AND isAdmin=''N''')
GO
insert into ofproperty (name,propvalue) values('jdbcGroupProvider.userGroupsSQL','SELECT groupName FroM HrmMessagerGroupUsers WHERE userloginid=?')
GO
insert into ofproperty (name,propvalue) values('jdbcProvider.connectionString','jdbc:jtds:sqlserver:GOGO192.168.0.204:1433GOecologydev;user=sa;password=ecology')
GO
insert into ofproperty (name,propvalue) values('jdbcProvider.driver','net.sourceforge.jtds.jdbc.Driver')
GO
insert into ofproperty (name,propvalue) values('jdbcUserProvider.allUsersSQL','SELECT loginid FROM hrmresource where loginid!='''' and loginid is not null')
GO
insert into ofproperty (name,propvalue) values('jdbcUserProvider.emailField','email')
GO
insert into ofproperty (name,propvalue) values('jdbcUserProvider.loadUserSQL','SELECT lastname,email FROM hrmresource WHERE loginid=?')
GO
insert into ofproperty (name,propvalue) values('jdbcUserProvider.nameField','lastname')
GO
insert into ofproperty (name,propvalue) values('jdbcUserProvider.searchSQL','SELECT loginid FROM hrmresource WHERE')
GO
insert into ofproperty (name,propvalue) values('jdbcUserProvider.userCountSQL','SELECT COUNT(*) FROM hrmresource where loginid!='''' and loginid is not null')
GO
insert into ofproperty (name,propvalue) values('jdbcUserProvider.usernameField','loginid')
GO
insert into ofproperty (name,propvalue) values('provider.admin.className','org.jivesoftware.openfire.admin.DefaultAdminProvider')
GO
insert into ofproperty (name,propvalue) values('provider.auth.className','org.jivesoftware.openfire.auth.JDBCAuthProvider')
GO
insert into ofproperty (name,propvalue) values('provider.group.className','org.jivesoftware.openfire.group.JDBCGroupProvider')
GO
insert into ofproperty (name,propvalue) values('provider.lockout.className','org.jivesoftware.openfire.lockout.DefaultLockOutProvider')
GO
insert into ofproperty (name,propvalue) values('provider.securityAudit.className','org.jivesoftware.openfire.security.DefaultSecurityAuditProvider')
GO
insert into ofproperty (name,propvalue) values('provider.user.className','org.jivesoftware.openfire.user.JDBCUserProvider')
GO
insert into ofproperty (name,propvalue) values('provider.vcard.className','org.jivesoftware.openfire.vcard.DefaultVCardProvider')
GO
insert into ofproperty (name,propvalue) values('update.lastCheck','1268099692562')
GO
insert into ofproperty (name,propvalue) values('xmpp.auth.anonymous','TRUE')
GO
insert into ofproperty (name,propvalue) values('xmpp.domain','222.66.55.182')
GO
insert into ofproperty (name,propvalue) values('xmpp.httpbind.scriptSyntax.enabled','true')
GO
insert into ofproperty (name,propvalue) values('xmpp.server.session.idle','600000')
GO
insert into ofproperty (name,propvalue) values('xmpp.session.conflict-limit','0')
GO
insert into ofproperty (name,propvalue) values('xmpp.socket.ssl.active','TRUE')
GO
