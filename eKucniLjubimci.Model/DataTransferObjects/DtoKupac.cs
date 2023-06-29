using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.DataTransferObjects
{
    public class DtoKupac
    {
        public int KupacId { get; set; }
        public int BrojNarudzbi { get; set; }

        public bool Kuca { get; set; }
        public bool Dvoriste { get; set; }
        public bool Stan { get; set; }


        public virtual DtoOsoba Osoba { get; set; }

        public virtual DtoLokacija Lokacija { get; set; }

        public virtual List<DtoNarudzba> Narudzbe { get; set; }

        public string SlikaKupca { get; set; }

        public virtual DtoKorisnickiNalog KorisnickiNalog { get; set; }
    }
}
