using System;

namespace Canvas
{
    public class Account
    {
        public string id {get; set;}
        public string name {get; set;}
        public string parent_account_id {get; set;}
        public string root_account_id {get; set;}
        public string default_storage_quota_mb {get; set;}
        public string default_user_storage_quota_mb {get; set;}
        public string default_group_storage_quota_mb {get; set;}
        public string default_time_zone {get; set;}
        public string sis_account_id {get; set;}
        public string integration_id {get; set;}
        public string sis_import_id {get; set;}
        public string lti_guid {get; set;}
        public string workflow_state {get; set;}
    }
}
