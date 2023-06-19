using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.Requests
{
    public class UpdateArtikal
    {
        public string? Naziv { get; set; }
        public decimal? Cijena { get; set; }
        public bool? Dostupnost { get; set; }
        public string? Opis { get; set; }
        public int KategorijaId { get; set; }

    }
}
