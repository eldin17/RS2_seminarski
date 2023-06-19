using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.Database
{
    public class Kupac
    {
        public int KupacId { get; set; }        
        public int BrojNarudzbi { get; set; }
        public bool Kuca { get; set; }
        public bool Dvoriste { get; set; }
        public bool Stan { get; set; }
        public bool isDeleted { get; set; } = false;


        public int OsobaId { get; set; }
        public virtual Osoba Osoba { get; set; }

        public virtual Lokacija Lokacija { get; set; }
        public int LokacijaId { get; set; }

        public virtual List<Narudzba> Narudzbe { get; set; }

        public string SlikaKupca { get; set; }

        public virtual KorisnickiNalog KorisnickiNalog { get; set; }
        public int KorisnickiNalogId { get; set; }
    }
}
