using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.Database
{
    public class Lokacija
    {
        public int LokacijaId { get; set; }
        public string Drzava { get; set; }
        public string Grad { get; set; }
        public string Ulica { get; set; }
        public bool isDeleted { get; set; } = false;


        public virtual List<Kupac> Kupci { get; set; }

    }
}
