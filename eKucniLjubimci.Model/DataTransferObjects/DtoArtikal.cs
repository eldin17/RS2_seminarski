using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.DataTransferObjects
{
    public class DtoArtikal
    {
        public int ArtikalId { get; set; }
        public string Naziv { get; set; }
        public decimal Cijena { get; set; }
        public bool Dostupnost { get; set; }
        public string Opis { get; set; }
        public string StateMachine { get; set; }

        public int KategorijaId { get; set; }
        public virtual DtoKategorija Kategorija { get; set; }

        public virtual List<DtoSlika> Slike { get; set; }
    }
}
