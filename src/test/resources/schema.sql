drop database IF EXISTS Proca;
create database Proca;
use Proca;
--  domain - ⠡���, � ���ன �࠭���� ������ (�ᯮ������� � ⠡��� subscribers)
--  status ����� �ਭ����� ���祭��:
--    0 -  ����� �६���� �ਮ�⠭����� (�६���� �� ���⠢�塞 �����)
--    1 -  ��⨢�� �����
--    9 -  �����, �ᥬ ᠡ�ࠩ��ࠬ � ���ண� ����饭� ���뫠�� �����

create table domain (
    id                                  int auto_increment primary key,
    status                              tinyint default 1,
    domain                              varchar( 64 ) not null unique,
    comment                             varchar( 128 ) default ''
);                                     
           


--  country - ��࠭�
--  status ����� �ਭ����� ���祭��:
--    0 -  disabled
--    1 -  active
--  code - ����㪢���� ��� ��࠭�
                            
CREATE TABLE country (                 
    id                                  smallint auto_increment primary key,
    status                              tinyint default 1,
    code                                CHAR( 2 ) NOT NULL,
    name                                VARCHAR( 64 ) NOT NULL,
    index (code)
);                                     
                                       

--  state - ����
--  status ����� �ਭ����� ���祭��:
--    0 -  ��� "disabled"
--    1 -  active
--  code - ����㪢���� ��� ���
--  country_id - ��� ��࠭�, ���ன �ਭ������� ���
                                       
CREATE TABLE state (                   
    id                                  smallint auto_increment primary key,
    status                              tinyint default 1,
    code                                CHAR( 2 ) NOT NULL,
    name                                VARCHAR( 64 ) NOT NULL,
    country_id                          smallINT NOT NULL,
    index (code)
);                                     



--  template - ⠡��� 蠡����� 
--             �ᯮ������� ��� �⮡ࠦ���� ࠧ����� ��࠭�� ������稪��, 
--             ���䨪�樮���� ��ᥬ � �.�.
--  type_id - ⨯ 蠡����, �ਭ����� ᫥���騥 ���祭��:
--            SUBS_CONFIRM_EMAIL     2 蠡��� ���쬠 ���⢥ত���� �����᪨
--            UNSUBS_CONFIRM_EMAIL   3 ���쬮 ���⢥ত���� �⯨᪨
--            SUBS_EMAIL             4 ���쬮 ������稪 �����ᠭ
--            UNSUBS_EMAIL           5 ���쬮 ������稪 �⯨ᠭ
--            SUBS_PAGE              6 蠡��� �����᭮� ��࠭��� 
--            UNSUBS_PAGE            7 �⯨᭮� ��࠭���
--            SUBS_CONFIRM_PAGE      8 ��࠭�� ���⢥ত���� �����᪨
--            UNSUBS_CONFIRM_PAGE    9 ���⢥ত���� �⯨᪨
--            CONVERSION_EMAIL      10 ���䨪�樮���� ���쬮 ���뫠���� �������� 
--            HTML_PAGE             11 html ��࠭�� 
--
--   html / text - ⥪�⮢�� � html ��� ���쬠 ( � ��砥 web - text ���⮩ )
--   from_name - �� �쥣� ����� ���뫠�� ���쬮 ( ���砥 蠡���� ���쬠 )
--   subject - ���� ⥬� ���쬠

CREATE TABLE template (
    id                                  smallint auto_increment primary key ,
    type_id                             tinyint DEFAULT 1 NOT NULL,
    name                                varchar(32),
    description                         varchar(256),
    from_name                           varchar(256),
    subject                             text,
    text                                text,
    html                                text
);


--  srcdomain ⠡��� "������� ���뫪�" - �� �������, �� ����� 
--            ������ ��⥬� ����� ���뫠�� ���쬠 ������稪�� 
--            (� ���� return_to, �⯨�� ����� � ��.) 
--  status ����� �ਭ����� ���祭��:
--    0 -  disabled
--    1 -  active
--
--  name - �������� ���
--  smtp - ���� �� �ࢥ�, �१ ����� ���뫠���� ���䨪�樮��� ���쬠
--  path - ����, �� ���஬� ��⠭�������(ᬠ��஢���) �ਫ������ ��� �⮣� ������
--  default_conversion_code_id - 㬮��⥫�� ��� �����᪨, �ᯮ������ �� ����祭�� 
--         �����᪨ �� ����
--  unsubs_****** - ����ன�� ����� 蠡���� � ��� ������ ��ࠡ��뢠���� �⯨᪠ 
--                  �� 㬮�砭�� ��� �⮣� ������ ���뫪�

CREATE TABLE srcdomain (
    id                                  smallint auto_increment PRIMARY KEY,
    status                              tinyint default 1,
    name                                varchar(128) unique,
    smtp                                varchar(128) NOT NULL,
    path                                varchar(128) NOT NULL,

    default_conversion_code_id          smallint default NULL,

    unsubs_confirm                      bool NOT NULL DEFAULT true,
    unsubs_confirm_e_id                 smallint, -- references template ("id") on delete set NULL
    unsubs_confirm_h_id                 smallint, -- references template ("id") on delete set NULL
    unsubs_confirm_url                  character varying(256),
    unsubs_confirm_rwt                  BOOL default false,
    unsubs_choice                       bool NOT NULL DEFAULT true,
    unsubs_choice_h_id                  smallint, -- references template ("id") on delete set NULL
    unsubs_goodbye_h_id                 smallint, -- references template ("id") on delete set NULL
    unsubs_goodbye_e_id                 smallint, -- references template ("id") on delete set NULL
    unsubs_goodbye_url                  character varying(256),
    unsubs_goodbye_rwt                  bool default false
);


-- conversion_code. 
--  ᠬ� �� ᥡ� ����⨥ �������� ���ࠧ㬥���� ����⢨� ⨯� ᮢ��襭�� ���㯪�
--  ���㯠⥫�� � ���஭��� ��������, ��� ���������� ���짮��⥫�� ����� � ���.
--  �������� ���� ������� १���� ४������ ���⥫쭮�� � 楯�窥 ᮡ�⨩:
--     �����뢠���� ������, ���뫠���� ४���� �� ����, ������ ४���� ��������;
--     ���� 㢨����� ४���� ������� �� ������ / ��뫪�;
--     � ᢮� ��।� ���� �� ��������, ������ ���㯪� � �������� (�.�. ᮢ����� ��������)
--  ᮮ⢥��⢥��� ���筮 ���� ��᪮�쪮 �᭮���� ⨯�� ������ᨩ:
--  sale - �த��� 祣� � ( type_id = 1 )
--  lead - "�ਢ��" - 䠪� ���������� ���짮��⥫�� ����� � ���, �����᪨ ( type_id = 2 )
--  rebill - ��宦� �� sale, ⮫쪮 ������砥� �������饥 ����⢨�, � �ਬ��� 
--           �뫠 �������� �� �த������� ��� �⮢�� �裡. ����� ���㯠⥫� 
--           ��室�� ���� ࠧ � ᮢ��蠥� ���㯪� �ࢨ�, ��⥬� ��⮪������ �� � ⨯�� 
--           sale. �����, ����� ����� ���� ��室��� ���⥦� ������᪮� �����, � ⠪�� ���⥦� 
--           ��࠭����� � ⨯�� rebill ( type_id = 3 )
--
-- ��� 㤮��⢠ ��࠭���� / ����஢�� ������ᨩ � ��⥬� ���� ����⨥
-- ������ᨮ��� ���. ������� � �� �����祭���:
-- � ��� ���� ����� ࠧ��� �ணࠬ - ������ ���������, �ࢨᮢ � �ਫ������ �� ��ࠡ�⪥ ��. 
-- ������ �� ⠪�� �� ���� ᢮� ��ࠬ����, ᢮� �⨫� ࠡ���.
-- ��� ⮣� �⮡� ����� �뫮 "����ந��" �ਫ������ ��� ����� ⠪�� ������� / ��� �������㠫쭮,
-- � ��⥬� ���� ����⨥ ������ᨮ��� ���. � ��� ����ࠨ������ ����� ��ࠬ��஢ � ������ ��室��
-- ���� ⨯� �㬬� ������, ����� ������, ��� ���� � ��. ��⠫�.
--
-- ⠪ �� ������ᨮ��� ���� �ᯮ������ ��� ���������� (�����᪨) ������稪�� � ��⥬�
-- � ������ᨮ���� ���� ����ࠨ������ �����쭨⥫�� ����⢨�, ����� ������ �।�ਭ���
-- ��⥬� �� ��⮪���஢���� ������ᨨ - ��᫠�� ���䨪�樮���� ���쬮, �⮡ࠧ��� ��࠭���,
-- ��।�४��� �� ����� � ��� � �.�.
--
-- ����� ������ᨮ��� ��� ����� ᢮� 㭨����� URL, ����� ��뢠���� ���������/�ମ�
-- ��� ��।�� ������� ��ࠬ��஢ �१ GET / POST / ... �����
-- 

CREATE TABLE conversion_code (
    id                                  smallint auto_increment primary key,
    name                                VARCHAR( 64 ) NOT NULL,
    type_id                             tinyint NOT NULL DEFAULT 1,
    type_id_pname                       VARCHAR( 32 ) default 'type_id',
    campaign_id_pname                   VARCHAR( 32 ) default 'campaign_id',
    publisher_id_pname                  VARCHAR( 32 ) default 'publisher_id',
    custom_id_pname                     VARCHAR( 32 ) DEFAULT 'id',
    status_pname                        VARCHAR( 32 ) DEFAULT 'status',
    default_status                      tinyint default 1,
                                       
    redirect_url                        varchar( 255 ) default '',
    redirect_rewrite                    BOOL default false,
    log_unreferred                      bool default true,
    log_diplicate_id                    bool default true,
    log_diplicate_cookie                bool default true,
                                       
    default_amount                      DOUBLE default 0.00,
    amount_param                        varchar( 32 )  default 'amount',
                                       
    subscribe                           bool default true,
    confirm_on_subscribe                bool default true,
                                       
    email_pname                         VARCHAR( 32 ) DEFAULT 'email',
                                       
    accept_id                           bool,
    id_pname                            VARCHAR( 32 ) DEFAULT 'sid',
                                       
    accept_md5_code                     bool,
    md5_code_pname                      VARCHAR( 32 ) DEFAULT 'c',
                                       
    accept_newslist                     bool,
    newslist_pname                      VARCHAR( 32 ) DEFAULT 'newslist',
                                      
    accept_password                     bool,
    password_pname                      VARCHAR( 32 ) DEFAULT 'password',

    accept_fname                        bool,
    fname_pname                         VARCHAR( 32 ) DEFAULT 'fname',

    accept_lname                        bool,
    lname_pname                         VARCHAR( 32 ) DEFAULT 'lname',
                                       
    accept_sex                          bool,
    sex_pname                           VARCHAR( 32 ) DEFAULT 'sex',
                                       
    accept_address1                     bool,
    address1_pname                      VARCHAR( 32 ) DEFAULT 'address1',
                                       
    accept_address2                     bool,
    address2_pname                      VARCHAR( 32 ) DEFAULT 'address2',
                                       
    accept_city                         bool,
    city_pname                          VARCHAR( 32 ) DEFAULT 'city',
                                       
    accept_state                        bool,
    state_pname                         VARCHAR( 32 ) DEFAULT 'state',
                                       
    accept_zip                          bool,
    zip_pname                           VARCHAR( 32 ) DEFAULT 'zip',
                                       
    accept_country                      bool,
    country_pname                       VARCHAR( 32 ) DEFAULT 'country',
                                       
    accept_phone1                       bool,
    phone1_pname                        VARCHAR( 32 ) DEFAULT 'phone1',
                                       
    accept_phone2                       bool,
    phone2_pname                        VARCHAR( 32 ) DEFAULT 'phone2',
                                       
    accept_custom1                      bool,
    custom1_pname                       VARCHAR( 32 ) DEFAULT 'custom1',
                                       
    accept_custom2                      bool,
    custom2_pname                       VARCHAR( 32 ) DEFAULT 'custom2',
                                       
    accept_custom3                      bool,
    custom3_pname                       VARCHAR( 32 ) DEFAULT 'custom3',
                                       
    accept_custom4                      bool,
    custom4_pname                       VARCHAR( 32 ) DEFAULT 'custom3',
                                       
    accept_custom5                      bool,
    custom5_pname                       VARCHAR( 32 ) DEFAULT 'custom3',
                                       
    accept_custom6                      bool,
    custom6_pname                       VARCHAR( 32 ) DEFAULT 'custom3',
                                       
    accept_custom7                      bool,
    custom7_pname                       VARCHAR( 32 ) DEFAULT 'custom3',
                                       
    accept_custom8                      bool,
    custom8_pname                       VARCHAR( 32 ) DEFAULT 'custom3',
                                       
    accept_custom9                      bool,
    custom9_pname                       VARCHAR( 32 ) DEFAULT 'custom3',
                                       
    homepage_template_id                smallint, -- REFERENCES "template" ON DELETE SET NULL
                                       
    subs_confirm                        BOOL NOT NULL DEFAULT true,
    subs_confirm_e_id                   smallint, -- REFERENCES "template" ON DELETE SET NULL
    subs_confirm_e2_id                  smallint, -- REFERENCES "template" ON DELETE SET NULL
    subs_confirm_h_id                   smallint, -- REFERENCES "template" ON DELETE SET NULL
    subs_confirm_url                    VARCHAR( 255 ),
    subs_confirm_rwt                    bool,
    subs_welcome                        bool DEFAULT true,
    subs_welcome_h_id                   smallint, -- REFERENCES "template" ON DELETE SET NULL
    subs_welcome_e_id                   smallint, -- REFERENCES "template" ON DELETE SET NULL
    subs_welcome_url                    VARCHAR( 255 ),
    subs_welcome_rwt                    bool default false,
                                       
    srcdomain_id                        smallint, -- REFERENCES "srcdomain" ON DELETE SET NULL
                                       
    description                         TEXT,
                                       
    postback                            bool,
    postback_url                        VARCHAR( 256 ),
    postback_method                     char(1), -- "G" for get, "P" for post
    postback_pending                    bool,
    postback_condition                  TEXT,
    postback_expression                 TEXT,
                                       
    email_notification                  bool,
    email_template_id                   smallint,
    email_to                            VARCHAR( 128 ),
    email_cc                            VARCHAR( 128 ),
    email_bcc                           VARCHAR( 128 ),
    email_condition                     TEXT,
    email_pending                       bool,

    pending_if_duplicate_subscriber     bool default false,
    pending_if_duplicate_subscription   bool default true,
                                            
    preserve_subscriber                 bool default false,

    preprocess                          TEXT
);


--  conversion - ⠡��� ������ᨩ (�������) � ���ଠ樥� ����� ��ࠧ�� ������ ��������
--  �뫠 "��᫠��" (referred) ����砫쭮: �१ ����� ������, ����� ������஬, 
--  ����� ���������; ����� ����� ����஢�� ������஢���� � �.�.
--  paid** ���� �࠭�騥 ���ଠ�� �� ����� �����ᨮ���� ��������, �����
--  ��᫠� ��������. 

CREATE TABLE conversion (
    id                                  int auto_increment primary key,
    status                              tinyint default 1,
    created_date                        datetime,
    craeted_ip                          varchar( 32 ) default '0.0.0.0',
    updated_date                        datetime,
    conversion_code_id                  smallINT,  --  references conversion ON DELETE SET NULL
    custom_id                           VARCHAR( 64 ),
    type_id                             tinyint NOT NULL DEFAULT 1,
    amount                              DOUBLE default 0.00,
    click_date                          datetime,
    click_url_id                        INT, -- REFERENCES url ON DELETE SET NULL,
    click_custom                        varchar( 128 ),
    click_creative_id                   INT, -- REFERENCES creative ON DELETE SET NULL,
    click_banner_id                     INT, -- REFERENCES banner ON DELETE SET NULL,
    campaign_id                         smallint, -- REFERENCES campaign ON DELETE SET NULL,
    publisher_id                        INT, -- REFERENCES publisher ON DELETE SET NULL,
    subscriber_id                       INT, -- REFERENCES subscriber ON DELETE SET NULL,
    paid                                bool default false,
    paid_date                           datetime,
    paid_commission                     float default 0.00,
    comment                             VARCHAR( 128 ),
    index (custom_id)
);                                      
                                        

--  ⠡��� ������稪��. �᭮��� ���� - �� �� ������稪� � ��� ���⮢� ����,
--  ��� ������஢���� �१ id ������ � user (����� ��� ���⮢��� ����);
--  0 ����� - ����⨢�� ������稪
--  1 ��⨢��
--  3 �ਮ�⠭������� ⠪ ��� �뫮 ����祭� ᨫ쭮 ����� bounces �� ��᫪� ��� ��ᥬ
--  9 ���������⨢�� �������஢���� - ��⥬� ������� �� 諥� ⠪�� ������稪�� ���쬠                                        
--  ���, ���� � ��. ��⠫� ������稪�
--  custom** - ���� ��� �࠭���� �ந����쭮� ���ଠ樨
--  conversion_id - �� ������ᨨ �१ ������ ����� ������稪 ����� � ��⥬�.

create table subscriber (
    id                                  int auto_increment primary key,
    status                              tinyint default 1,
    user                                varchar(64) not null,
    domain_id                           int REFERENCES domain ON DELETE cascade,
    conversion_id                       smallint, --  references conversion ON DELETE SET NULL
    bounces                             tinyint default 0,
    signup                              datetime,
    signup_ip                           varchar(32) default '0.0.0.0',
    modify                              datetime,
    modify_ip                           varchar(32) default '0.0.0.0',
    unsubscribe                         datetime,
    unsubscribe_ip                      varchar(32) default '0.0.0.0',
    first_name                          varchar(64) default '',
    last_name                           varchar(64) default '',
    address1                            varchar(64) default '',
    address2                            varchar(64) default '',
    city                                varchar(64) default '',
    state_id                            smallint,
    region                              VARCHAR( 16 ) default '',
    zip                                 varchar(16) default '',
    country_id                          smallint,
    birthday                            date,
    phone1                              varchar(32) default '',
    phone2                              varchar(32) default '',
    custom1                             varchar(64) default '',
    custom2                             varchar(64) default '',
    custom3                             varchar(64) default '',
    custom4                             varchar(64) default '',
    custom5                             varchar(64) default '',
    custom6                             varchar(64) default '',
    custom7                             varchar(64) default '',
    custom8                             varchar(64) default '',
    custom9                             varchar(64) default '',
    unique                              subscriber_email(domain_id,user)
);


-- ⠡��� ��⥣�਩ ���᫨�⮢

CREATE TABLE newslist_category (   
    id                                  smallint PRIMARY KEY auto_increment,
    status                              tinyint DEFAULT 1,
    name                                varchar(128) NOT NULL,
    description                         text,
    visible                             boolean default true
);


-- ���᫨��� (��� �����᪨ ������稪���)
-- �������� ��ࠬ���� �����᪨-�⯨᪨ (subs_** / unsubs_** ), ����� ���⮬ ����� (custom***) �
-- �१ ����� "����� ���뫪�" (srcdomain_id) ����� ���쬠 ������稪�� ���᫨��

CREATE TABLE newslist (   
    id                                  smallint PRIMARY KEY auto_increment,
    status                              smallint DEFAULT 1,
    name                                varchar(128) UNIQUE NOT NULL,
    description                         varchar(256),
    url                                 varchar(256),
    visible                             boolean default true,
    category_id                         smallint, -- references newslist_category("id") on delete set NULL
    subs_confirm_over                   bool,
    subs_confirm                        boolean NOT NULL default true,
    subs_welcome_e_over                 bool,
    subs_welcome_e_id                   smallint, -- references t_template("id") on delete set NULL
    unsubs_confirm_over                 BOOL,
    unsubs_confirm                      boolean NOT NULL default true,
    unsubs_goodbye_e_id                 smallint, -- references t_template("id") on delete set NULL
    unsubs_goodbye_e_over               BOOL,
    srcdomain_id                        smallint, -- references t_srcdomain("id") on delete set NULL
    active_subscribers                  int DEFAULT 0 NOT NULL,
    blocked_subscribers                 int DEFAULT 0 NOT NULL,
    suspended_subscribers               int DEFAULT 0 NOT NULL,
    custom1_name                        varchar(32) default 'ncustom1',
    custom2_name                        varchar(32) default 'ncustom2',
    custom3_name                        varchar(32) default 'ncustom3'
);


-- ⠡��� �����᪨ - ����� ������稪 �����ᠭ �� ����� ���᫨��
-- ���� � �� �����᪨-����䨪�樨
-- ���祭�� ����ᮢ �宦� � ⠡��楩 ������稪��
-- custom** -  ���� ��� �࠭���� �ந����쭮� ���ଠ樨 � ������稪�-�����᪥

create table subscription (
    subscriber_id                       int NOT NULL,
    newslist_id                         smallint NOT NULL,
    status                              tinyint DEFAULT 1,
    signup                              datetime,
    signup_ip                           varchar(32) default '0.0.0.0',
    modify                              datetime,
    modify_ip                           varchar(64) default '0.0.0.0',
    custom1                             varchar(64),
    custom2                             varchar(64),
    custom3                             varchar(64),
    primary key ( subscriber_id, newslist_id )
);

-- ⠡��� �ࢥ஢ ���뫪�
-- srcdomain_id - ���뫮�� ����� ����� ���㦨���� ����� relay
-- db_** ��ࠬ���� ᮥ������� � ����� ������ relay
CREATE TABLE relay (
    id                                  smallint primary key auto_increment,
    status                              tinyint  DEFAULT 1 NOT NULL,
    srcdomain_id                        smallint, -- references srcdomain("id") on delete set NULL
    db_host                             varchar(64) DEFAULT 'localhost' NOT NULL,
    db_name                             varchar(32) DEFAULT 'mail' NOT NULL,
    db_user                             varchar(32) DEFAULT 'mail' NOT NULL,
    db_password                         varchar(32) DEFAULT '' NOT NULL
);                                     


-- ��⥣�ਨ �૥�
CREATE TABLE url_category (   
    id                                  smallint PRIMARY KEY auto_increment,
    status                              tinyint DEFAULT 1,
    name                                varchar(128) NOT NULL,
    description                         text,
    visible                             boolean default true
);


-- ᠬ� �૨
CREATE TABLE url (
    id                                  int PRIMARY KEY auto_increment,
    status                              tinyint default 1,
    name                                VARCHAR( 64 ) NOT NULL,
    url                                 TEXT NOT NULL,
    url_category_id                     smallint, -- references url_category("id") on delete set NULL
    rewrite                             bool default false,
    description                         TEXT
);



-- ��⥣�ਨ creative
CREATE TABLE creative_category (   
    id                                  smallint PRIMARY KEY auto_increment,
    status                              tinyint DEFAULT 1,
    name                                varchar(128) NOT NULL,
    description                         text,
    visible                             boolean default true
);


-- creative - "�ॠ⨢" - ४����� ���ਠ�. ����� ���� ���쬮�, html ��࠭�楩, � �.�.
CREATE TABLE creative (
    id                                  INT PRIMARY KEY auto_increment,
    type_id                             tinyint not null,
    name                                VARCHAR(64),
    private                             bool,
    description                         TEXT,
    creative_category_id                smallint, -- references creative_category("id") on delete set NULL

    subject                             TEXT,
    text                                TEXT,
    html                                TEXT,
    body_type                           CHAR(1) NOT NULL DEFAULT 'm' -- mime / plain text / html
);


-- ��⥣�ਨ �����஢
CREATE TABLE banner_category (   
    id                                  smallint PRIMARY KEY auto_increment,
    status                              tinyint DEFAULT 1,
    name                                varchar(128) NOT NULL,
    description                         text,
    visible                             boolean default true
);


-- ������
CREATE TABLE banner (
    id                                  INT PRIMARY KEY auto_increment,
    name                                VARCHAR(64),
    description                         TEXT,
    url_id                              INT, -- REFERENCES url
    banner_category_id                  smallint, -- references banner_category("id") on delete set NULL
--    dimension_id                      smallint REFERENCES dimension,
    image_file                          VARCHAR( 32 ),
    image_url                           VARCHAR( 128 ),
    rich_media                          bool default false,
    alt_text                            VARCHAR( 128 ),
    target                              VARCHAR( 32 )
);


-- ����� �� ���뫪� ��ᥬ - �������� ����� �ॠ⨢ ���뫠����, �����,
-- � ����� ������, � ������ ��ࠬ��ࠬ�, �������⥫�� ���ਨ �롮� ������稪��,
-- ������᪨� ����� ᪮�쪮 ��᫠��, ᪮�쪮 bounced, � �.�.
CREATE TABLE task (
    id                                  int primary key auto_increment,
    status                              tinyint DEFAULT 1,
    newslist_id                         smallint NOT NULL, -- references newslist("id") on delete cascade,

    creative_id                         int NOT NULL, -- references creative("id") on delete set null,

    from_email                          varchar(128),
    from_name                           varchar(128),
    to_name                             varchar(128),

    start                               datetime NOT NULL,

    filter                              text, -- base64( Storable::freeze( \%filter ) )

    s_queued                            int DEFAULT 0,
    s_sent                              int DEFAULT 0,
    s_deferred                          int DEFAULT 0,
    s_opened                            int DEFAULT 0,
    s_bounced                           int DEFAULT 0,
    s_unsubscribed                      int DEFAULT 0,
    s_ordered                           int DEFAULT 0,
    index (start)
);


-- ⠡��� ���뫪� - ᯨ᪨ ������稪�� ��� ����祩 �� ��ࠢ��, �१ ����� �ࢥ� ���뫠����,
-- ��⠫� � ����� ��ࠢ��
create table mailing (
    subscriber_id                       int NOT NULL,
    task_id                             int NOT NULL,
    status                              smallint DEFAULT 0,
    relay_id                            smallint DEFAULT 0,
    date                                date,
    primary key ( subscriber_id, task_id  )
);

-- ��㯯� ������஢ - ����� ������� �ਭ������� � ����� � ����� ��㯯� -
-- ��� 㤮��⢠ �����㫨஢���� ������ࠬ� � ����஥� �����ᨮ����
CREATE TABLE publisher_group (   
    id                                  smallint PRIMARY KEY auto_increment,
    status                              tinyint DEFAULT 1,
    name                                varchar(128) NOT NULL,
    description                         text
);

-- ������� - 祫���� / �������� ����� ࠧ��頥� ४���� �� ᢮�� ᠩ� ��� ��㣨� ��⮤��;
-- ����砥� ������ࠦ����� �� �������� ��⥬�, ᮣ��᭮ ����ᨮ��� ����ன��� 
-- (����� ���� �� �����, �� ������ �����஢ ��� �� ������ᨨ)
CREATE TABLE publisher (
    id                                  INT PRIMARY KEY auto_increment,
    status                              tinyint default 1,

    signup                              datetime,

    login                               VARCHAR( 32 ) UNIQUE NOT NULL,
    password                            CHAR( 32 ) NOT NULL,

    email                               VARCHAR( 64 ) NOT NULL,

    publisher_group_id                  smallINT NOT NULL,

    company                             VARCHAR( 64 ),
    fname                               VARCHAR( 32 ),
    lname                               VARCHAR( 32 ) NOT NULL,

    address1                            VARCHAR( 64 ) NOT NULL,
    address2                            VARCHAR( 64 ),
    city                                VARCHAR( 32 ) NOT NULL,
    state_id                            smallINT,
    region                              VARCHAR( 16 ),
    zip                                 VARCHAR( 16 ) NOT NULL,
    country_id                          smallINT,
    phone1                              VARCHAR( 32 ) NOT NULL,
    phone2                              VARCHAR( 32 ) NOT NULL,
    fax                                 VARCHAR( 32 ),

    pay_to                              VARCHAR( 32 ),

    custom_0                            VARCHAR( 128 ),
    custom_1                            VARCHAR( 128 ),
    custom_2                            VARCHAR( 128 ),
    custom_3                            VARCHAR( 128 ),
    custom_4                            VARCHAR( 128 ),
    custom_5                            VARCHAR( 128 ),
    custom_6                            VARCHAR( 128 ),
    custom_7                            VARCHAR( 128 ),
    custom_8                            VARCHAR( 128 ),
    custom_9                            VARCHAR( 128 ),

    comment                             TEXT
);


-- ⠡��� ॣ����樨 ������ 
CREATE TABLE clicks (
    date                                DATE NOT NULL,
    url_id                              INT NOT NULL DEFAULT 0, -- REFERENCES url
    campaign_id                         smallint NOT NULL DEFAULT 0, -- REFERENCES campaign
    publisher_id                        INT NOT NULL DEFAULT 0, -- REFERENCES affiliation
    banner_id                           INT NOT NULL DEFAULT 0, -- REFERENCES banner
    creative_id                         INT NOT NULL DEFAULT 0, -- REFERENCES creative
    task_id                             INT NOT NULL DEFAULT 0, -- REFERENCES task

    count_total                         int default 0,
    count_unique                        int default 0,

    paid                                bool default false,
    paid_date                           date,
    paid_commission                     float default 0.00,

    PRIMARY KEY(
        date,
        url_id,
        campaign_id,
        publisher_id,
        banner_id,
        creative_id,
        task_id
   )
);


-- ⠡��� ४������ ��������, ����뢠�� ���� ����-��⠭����, 
-- 㬮��⥫�� �����ᨮ��� ����ன��
--

CREATE TABLE campaign (
    id                                  smallint PRIMARY KEY auto_increment,
    status                              tinyint default 1,
    name                                VARCHAR( 128 ),

    start_date                          DATE,
    end_date                            DATE,

    -- campaign setup cost
    setup_cost                          DOUBLE PRECISION NOT NULL DEFAULT 0,

    -- cost per thousand impressions
    rpm                                 DOUBLE PRECISION NOT NULL DEFAULT 0,
    -- cost per click
    rpc                                 DOUBLE PRECISION NOT NULL DEFAULT 0,

    -- default RPAs
    rpa_sale                            DOUBLE PRECISION NOT NULL DEFAULT 0,
    rpa_sale_is_percent                 bool default true,

    rpa_lead                            DOUBLE PRECISION NOT NULL DEFAULT 0,
    rpa_lead_is_percent                 bool default true,

    rpa_rebill                          DOUBLE PRECISION NOT NULL DEFAULT 0,
    rpa_rebill_is_percent               bool default true,

    description                         TEXT

);

-- ⠡��� "�����祭��" ����� �������� ����㯭� ����� ��㯯�� ������஢.
-- ������⢨� ����� � �⮩ ⠡��� ������ � ⮬, �� ������� �� ⠪�� ��㯯�
-- �� ����� ����㯠 � ᮮ⢥�����饩 ��������. ⠪ �� ���� �����������
-- ��७������� 㬮��⥫�� ����ᨮ��� �����⭮� ��㯯� �� �������� ��������.
--

create table campaign_publisher_group (
    campaign_id                         smallint NOT NULL,
    publisher_group_id                  smallint NOT NULL,

    rpm_default                         bool default true,
    rpm                                 DOUBLE PRECISION NOT NULL DEFAULT 0,

    rpc_default                         bool default true,
    rpc                                 DOUBLE PRECISION NOT NULL DEFAULT 0,

    rpa_sale_default                    bool default true,
    rpa_sale                            DOUBLE PRECISION NOT NULL DEFAULT 0,
    rpa_sale_is_percent                 bool default true,

    rpa_lead_default                    bool default true,
    rpa_lead                            DOUBLE PRECISION NOT NULL DEFAULT 0,
    rpa_lead_is_percent                 bool default true,

    rpa_rebill_default                  bool default true,
    rpa_rebill                          DOUBLE PRECISION NOT NULL DEFAULT 0,
    rpa_rebill_is_percent               bool default true,

    PRIMARY KEY(
        campaign_id,
        publisher_group_id
   )
);


-- ⠡��� ����⨪� �� ���ᠬ
-- ᪮�쪮 ���ᮢ ����祭� �� ����� ���� ��� ������� ������ � ࠧ���� ���� ����� 
--
create table bounce_report (
    date                                date not NULL,
    domain_id                           int NOT NULL,
    relay_id                            smallint NOT NULL,
    counter                             int NOT NULL default 0,
    code                                smallint NOT NULL default 0,
    reason                              character varying(128) NOT NULL,
    primary key ( domain_id, code, date, relay_id )
);


