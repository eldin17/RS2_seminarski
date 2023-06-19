using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.Database
{
    public class Novost
    {
        public int NovostId { get; set; }
        public string Naslov { get; set; }
        public string Sadrzaj { get; set; }
        public DateTime DatumPostavljanja { get; set; }
        public bool isDeleted { get; set; } = false;

        public int ProdavacId { get; set; }
        public virtual Prodavac Prodavac { get; set; }
    }
}
