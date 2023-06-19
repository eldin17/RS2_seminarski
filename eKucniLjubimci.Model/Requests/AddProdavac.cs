using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.Requests
{
    public class AddProdavac
    {
        public string PoslovnaJedinica { get; set; }
        public string SlikaProdavca { get; set; } = "empty";


        public int OsobaId { get; set; }

        public int KorisnickiNalogId { get; set; }
    }
}
