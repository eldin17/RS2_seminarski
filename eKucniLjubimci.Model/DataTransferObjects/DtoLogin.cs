using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.DataTransferObjects
{
    public class DtoLogin
    {
        public string Token { get; set; }
        public int IdLogiranogKorisnika { get; set; }
        public string UlogaNaziv { get; set; }
    }
}
