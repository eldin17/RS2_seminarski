using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.Database
{
    public class NarudzbaArtikal
    {
        public int NarudzbaArtikalId { get; set; }
        public int NarudzbaId { get; set; }
        public virtual Narudzba Narudzba { get; set; }

        public int ArtikalId { get; set; }
        public virtual Artikal Artikal { get; set; }

    }
}
