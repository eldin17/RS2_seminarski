using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.Database
{
    public class Kategorija
    {
        public int KategorijaId { get; set; }
        public string Naziv { get; set; }
        public bool isDeleted { get; set; } = false;


        public virtual List<Artikal> Artikli { get; set; }

    }
}
