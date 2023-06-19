using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.Database
{
    public class Prodavac
    {
        public int ProdavacId { get; set; }
        public string PoslovnaJedinica { get; set; }
        public bool isDeleted { get; set; } = false;
        public string SlikaProdavca { get; set; }


        public int OsobaId { get; set; }
        public virtual Osoba Osoba { get; set; }

        public virtual KorisnickiNalog KorisnickiNalog { get; set; }
        public int KorisnickiNalogId { get; set; }


        public virtual List<Novost> Novosti { get; set; }
    }
}
