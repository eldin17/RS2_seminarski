using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.Database
{
    public class Uloga
    {
        public int UlogaId { get; set; }
        public string Naziv { get; set; }

        public virtual List<KorisnickiNalog> KorisnickiNalozi { get; set; }
    }
}
