using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.Requests
{
    public class AddKupac
    {
        public int BrojNarudzbi { get; set; } = 0;
        public bool Kuca { get; set; } = false;
        public bool Dvoriste { get; set; } = false;
        public bool Stan { get; set; } = false;
        public int OsobaId { get; set; }
        public int LokacijaId { get; set; }
        public string SlikaKupca { get; set; } = "empty";
        public int KorisnickiNalogId { get; set; }

    }
}
