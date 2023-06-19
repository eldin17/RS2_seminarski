using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.Database
{
    public class Osoba
    {
        public int OsobaId { get; set; }
        public string Ime { get; set; }
        public string Prezime { get; set; }
        public DateTime DatumRodjenja { get; set; }
        public bool isDeleted { get; set; } = false;

        public virtual Kupac? Kupac { get; set; }
        public virtual Prodavac? Prodavac { get; set; }

    }
}
