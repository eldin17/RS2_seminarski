using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.Database
{
    public class Zivotinja
    {
        public int ZivotinjaId { get; set; }
        public string Naziv { get; set; }
        public string Napomena { get; set; }
        public decimal Cijena { get; set; }
        public bool Dostupnost { get; set; }
        public DateTime DatumPostavljanja { get; set; }
        public string StateMachine { get; set; }

        public int? NarudzbaId { get; set; }
        public virtual Narudzba Narudzba { get; set; }

        public int VrstaId { get; set; }
        public virtual Vrsta Vrsta { get; set; }

        public virtual List<Slika> Slike { get; set; } = new List<Slika>();

    }
}
