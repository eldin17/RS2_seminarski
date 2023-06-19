using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.Requests
{
    public class AddArtikal
    {
        public string Naziv { get; set; }
        public decimal Cijena { get; set; }
        public bool Dostupnost { get; set; } = true;
        public string Opis { get; set; }
        public string StateMachine { get; set; } = "Initial";


        public int KategorijaId { get; set; }

        //public virtual List<Slika> Slike { get; set; }
    }
}
