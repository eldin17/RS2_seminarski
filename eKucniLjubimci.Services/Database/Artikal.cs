using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.Database
{
    public class Artikal
    {
        public int ArtikalId { get; set; }
        public string Naziv { get; set; }
        public decimal Cijena { get; set; }
        public bool Dostupnost { get; set; }
        public string Opis { get; set; }        
        public string StateMachine { get; set; }

        public virtual List<NarudzbaArtikal> NarudzbeArtikli { get; set; }

        public int KategorijaId { get; set; }
        public virtual Kategorija Kategorija { get; set; }

        public virtual List<Slika> Slike { get; set; } = new List<Slika>();

    }
}
