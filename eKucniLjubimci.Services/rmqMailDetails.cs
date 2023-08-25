using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services
{
    public class rmqMailDetails
    {
        public string HostName { get; set; }
        public string User { get; set; }
        public string Password { get; set; }
        public string Port { get; set; }
        public string AdressFrom { get; set; }
        public string AdressTo { get; set; }
        public string MailPassword { get; set; }
        public string SmtpMail { get; set; }
        public string EmailContent { get; set; }
    }
}
