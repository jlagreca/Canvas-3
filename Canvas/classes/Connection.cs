using System;
using System.Management.Automation;

namespace Canvas
{
    public class Connection
    {
        public string CanvasUrl {get; set;}
        public int AccountId {get; set;}
        public System.Management.Automation.PSCredential Credential {get; set;}
    }
}
