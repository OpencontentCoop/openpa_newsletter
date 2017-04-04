
ALTER TABLE cjwnl_user ADD external_user_id integer DEFAULT NULL;


ALTER TABLE cjwnl_list ADD is_virtual smallint NOT NULL DEFAULT 0;
ALTER TABLE cjwnl_list ADD virtual_filter text NOT NULL DEFAULT '';

ALTER TABLE cjwnl_edition_send ADD list_contentobject_version integer NOT NULL DEFAULT 0;
ALTER TABLE cjwnl_edition_send ADD list_is_virtual smallint NOT NULL DEFAULT 0;

ALTER TABLE cjwnl_list ADD email_reply_to character varying( 255 ) NOT NULL DEFAULT '';
ALTER TABLE cjwnl_list ADD email_return_path character varying( 255 ) NOT NULL DEFAULT '';
ALTER TABLE cjwnl_edition_send ADD email_reply_to character varying( 255 ) NOT NULL DEFAULT '';
ALTER TABLE cjwnl_edition_send ADD email_return_path character varying( 255 ) NOT NULL DEFAULT '';

ALTER TABLE cjwnl_user ADD custom_data_text_1 character varying( 255 )  NOT NULL DEFAULT '';
ALTER TABLE cjwnl_user ADD custom_data_text_2 character varying( 255 )  NOT NULL DEFAULT '';
ALTER TABLE cjwnl_user ADD custom_data_text_3 character varying( 255 )  NOT NULL DEFAULT '';
ALTER TABLE cjwnl_user ADD custom_data_text_4 character varying( 255 )  NOT NULL DEFAULT '';

ALTER TABLE cjwnl_edition_send ADD mailqueue_process_scheduled INTEGER NULL DEFAULT NULL;


    

